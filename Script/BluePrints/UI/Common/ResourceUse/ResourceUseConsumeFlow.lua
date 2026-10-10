require("UnLua")
local CommonConst = require("CommonConst")
local ResourceUseOptionBuilder = require("BluePrints.UI.Common.ResourceUse.ResourceUseOptionBuilder")
local ResUseEffectType = CommonConst.ResUseEffectType
local ResourceUseConsumeFlow = {}
local DefaultPopupId = 100209
local ConfirmPopupId = 100210

local function CloseFirstPopup(FirstPopUIWidget)
  if not IsValid(FirstPopUIWidget) then
    return false
  end
  FirstPopUIWidget.DontFocusParentWidget = true
  FirstPopUIWidget:RemoveFirstItemInPopupQueue()
  FirstPopUIWidget:OnCloseBtnClicked()
  return true
end

local function BuildResourcePackTips(Ctx)
  return {
    string.format(Ctx.ExtraString, GText(Ctx.StuffConfigData.ResourceName), 1, 1, 1)
  }
end

local function BuildSelectResourceTips(Ctx)
  return {
    string.format(Ctx.ExtraString, GText(Ctx.StuffConfigData.ResourceName), 0, Ctx.OptCount, 2)
  }
end

local function BuildWeaponOrPetConfirmParams(Ctx)
  local ConfirmParams, TargetStuffName = {}, ""
  if Ctx.Host.CurrentChooseInfo then
    TargetStuffName = Ctx.Host.CurrentChooseInfo.ChooseName
  end
  ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
  return ConfirmParams
end

local function BuildSelectCharacterConfirmParams(Ctx)
  local ConfirmParams, TargetStuffName = {}, ""
  local GradeLevel = 0
  if Ctx.Host.CurrentChooseInfo then
    TargetStuffName = Ctx.Host.CurrentChooseInfo.ChooseName
    GradeLevel = Ctx.OptionalItemsList[Ctx.Host.CurrentChooseInfo.ChooseIndex].GradeLevel or 0
  end
  local MaxGradeLevel = DataMgr.GlobalConstant.CharCardLevelMax.ConstantValue
  if GradeLevel >= MaxGradeLevel then
    ConfirmParams.ShortText = string.format(GText("UI_Consumable_CardLevel_Max"), TargetStuffName)
  else
    ConfirmParams.ShortText = string.format(GText("UI_Consumable_Choose_Confirm"), TargetStuffName)
  end
  return ConfirmParams
end

local function BuildResourcePackConfirmParams(Ctx)
  local ChooseInfo = Ctx.Host.CurrentChooseInfo
  Ctx.Host.ConsumeCount = ChooseInfo and ChooseInfo.ConsumeCount or 1
  return {}
end

local function ConfirmItemsWithSecondaryDialog(Ctx, ConfirmParams, FirstPopUIWidget)
  local Host = Ctx.Host
  if not IsValid(Host) then
    return
  end
  if ConfirmParams.ShortText then
    if not IsValid(FirstPopUIWidget) then
      return
    end
    FirstPopUIWidget.DontFocusParentWidget = true
    ConfirmParams.AutoFocus = true
    
    function ConfirmParams.RightCallbackFunction(_, _, PopUIWidget)
      if not IsValid(Host) then
        return
      end
      if IsValid(PopUIWidget) then
        PopUIWidget:RemoveFirstItemInPopupQueue()
      end
      Host:ConfirmDealWithConsumableItems(Ctx.UseEffectType, Ctx.StuffConfigData.UseParam, Ctx.Extra.OnClose)
    end
    
    ConfirmParams.DontFocusParentWidget = true
    UIManager(Host):ShowCommonPopupUI_Interrupt(ConfirmPopupId, ConfirmParams, Host)
  else
    if IsValid(FirstPopUIWidget) then
      FirstPopUIWidget.DontFocusParentWidget = false
    end
    Host:ConfirmDealWithConsumableItems(Ctx.UseEffectType, Ctx.StuffConfigData.UseParam, Ctx.Extra.OnClose)
  end
end

local function ConfirmPacks(Ctx, _, FirstPopUIWidget)
  if not CloseFirstPopup(FirstPopUIWidget) then
    return
  end
  if not IsValid(Ctx.Host) then
    return
  end
  if not Ctx.Host.CurrentChooseInfo then
    return
  end
  Ctx.Host:ConfirmDealWithConsumablePacks(Ctx.UseEffectType)
end

local function ConfirmResource(Ctx, _, FirstPopUIWidget)
  if not CloseFirstPopup(FirstPopUIWidget) then
    return
  end
  if not IsValid(Ctx.Host) then
    return
  end
  Ctx.Host:ConfirmDealWithConsumableResource(Ctx.UseEffectType)
end

local function ConfirmRandomBox(Ctx, _, FirstPopUIWidget)
  if not CloseFirstPopup(FirstPopUIWidget) then
    return
  end
  if not IsValid(Ctx.Host) then
    return
  end
  Ctx.Host:ConfirmDealWithConsumableRandomBox(Ctx.UseEffectType)
end

ResourceUseConsumeFlow.TypeHandler = {
  [ResUseEffectType.SelectWeapon] = {BuildConfirmParams = BuildWeaponOrPetConfirmParams, OnConfirm = ConfirmItemsWithSecondaryDialog},
  [ResUseEffectType.SelectCharacter] = {BuildConfirmParams = BuildSelectCharacterConfirmParams, OnConfirm = ConfirmItemsWithSecondaryDialog},
  [ResUseEffectType.SelectPet] = {BuildConfirmParams = BuildWeaponOrPetConfirmParams, OnConfirm = ConfirmItemsWithSecondaryDialog},
  [ResUseEffectType.SelectResource] = {
    PopupId = 100208,
    BuildTips = BuildSelectResourceTips,
    OnConfirm = ConfirmResource
  },
  [ResUseEffectType.ResourcePack] = {
    PopupId = 100207,
    BuildTips = BuildResourcePackTips,
    BuildConfirmParams = BuildResourcePackConfirmParams,
    OnConfirm = ConfirmPacks
  },
  [ResUseEffectType.RandomSelectPack] = {PopupId = 100343, OnConfirm = ConfirmRandomBox}
}

function ResourceUseConsumeFlow.Open(Host, StuffConfigData, Extra, Handler)
  Extra = Extra or {}
  if not IsValid(Host) or not StuffConfigData then
    return
  end
  Host.CurrentChooseInfo = nil
  local UseEffectType = StuffConfigData.UseEffectType
  local ExtraString, OptCount = ""
  local OptionalItemsList = {}
  if UseEffectType then
    OptionalItemsList, ExtraString, OptCount = ResourceUseOptionBuilder.Build(Host, UseEffectType, StuffConfigData.ResourceId, StuffConfigData.UseParam)
  end
  local Ctx = {
    Host = Host,
    StuffConfigData = StuffConfigData,
    Extra = Extra,
    UseEffectType = UseEffectType,
    OptionalItemsList = OptionalItemsList,
    ExtraString = ExtraString,
    OptCount = OptCount
  }
  local CommonDialogParams = {}
  CommonDialogParams.OptionalItemsList = OptionalItemsList
  CommonDialogParams.Title = GText(StuffConfigData.ResourceName)
  if Handler and Handler.BuildTips then
    CommonDialogParams.Tips = Handler.BuildTips(Ctx)
  else
    CommonDialogParams.Tips = {
      string.format(GText("UI_Consumable_Choose"), ExtraString)
    }
  end
  CommonDialogParams.AutoFocus = true
  CommonDialogParams.DontCloseWhenRightBtnClicked = true
  CommonDialogParams.FunctionCallbackObj = Host
  CommonDialogParams.ChooseCallbackFunction = Host.TryToChooseConsumableItems
  CommonDialogParams.RightGamepadImg = EKeys.A.KeyName
  CommonDialogParams.RightGamepadKey = Const.GamepadFaceButtonBottom
  CommonDialogParams.ParentWidget = Host
  CommonDialogParams.HideItemTips = true
  CommonDialogParams.ResourceId = StuffConfigData.ResourceId
  CommonDialogParams.UseParam = StuffConfigData.UseParam
  if Extra.OnClose then
    CommonDialogParams.OnCloseCallbackFunction = Extra.OnClose
  end
  
  function CommonDialogParams.RightCallbackFunction(_, _, FirstPopUIWidget)
    if not IsValid(Host) then
      return
    end
    local ConfirmParams = {}
    if Handler and Handler.BuildConfirmParams then
      ConfirmParams = Handler.BuildConfirmParams(Ctx) or {}
    end
    if Handler and Handler.OnConfirm then
      Handler.OnConfirm(Ctx, ConfirmParams, FirstPopUIWidget)
      return
    end
    if IsValid(FirstPopUIWidget) then
      FirstPopUIWidget.DontFocusParentWidget = false
    end
    Host:ConfirmDealWithConsumableItems(UseEffectType, StuffConfigData.UseParam, Extra.OnClose)
  end
  
  local PopupId = DefaultPopupId
  if Handler and Handler.PopupId then
    PopupId = Handler.PopupId
  end
  UIManager(Host):ShowCommonPopupUI(PopupId, CommonDialogParams, Host)
end

return ResourceUseConsumeFlow
