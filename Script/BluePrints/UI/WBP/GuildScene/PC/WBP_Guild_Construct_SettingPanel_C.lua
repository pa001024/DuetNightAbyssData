require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GuildEntranceSettings = {
  {
    GroupID = "DisplaySettings",
    GroupTitle = "UI_DisplaySettings",
    ItemType = "CheckBox",
    Sorted = 1,
    Options = {
      {
        ID = "GridShow",
        Label = "UI_GridDisplay"
      },
      {
        ID = "EffectShow",
        Label = "UI_EffectDisplay"
      }
    }
  },
  {
    GroupID = "CameraAngle",
    GroupTitle = "UI_CameraView",
    ItemType = "Switch",
    Sorted = 2,
    Options = {
      {
        {
          ID = "FreeCam",
          Label = "UI_FreeCamera"
        },
        {
          ID = "TopCam",
          Label = "UI_TopDownCamera"
        }
      }
    }
  },
  {
    GroupID = "ComponentMove",
    GroupTitle = "UI_MoveComponent",
    ItemType = "Switch",
    Sorted = 3,
    Options = {
      {
        {
          ID = "GridMove",
          Label = "UI_GridMove"
        },
        {
          ID = "PixelMove",
          Label = "UI_PixelMove"
        }
      }
    }
  },
  {
    GroupID = "QuickDemolish",
    GroupTitle = "UI_DestroyAll",
    ItemType = "Button",
    Sorted = 4,
    DynamicOptions = "GetQuickDemolishOptions"
  }
}

function M:Construct()
  self.bIsFocusable = true
end

function M:Init(Parent)
  self.Parent = Parent
  self.Text_Title:SetText(GText("UI_ConstructSettings"))
  self.Btn_Restore:SetText(GText("GuildGarrisonRestore"))
  self.Btn_Restore:BindEventOnClicked(self, self.OnRestoreBtnClick)
  self.Btn_Restore:BindForbidStateExecuteEvent(self, self.OnRestoreBtnClick)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.GuildManager.OnPlacedItemChanged:Add(self, self.RefreshRestoreBtnState)
  self:InitGamepad()
  self:RefreshUI()
  self:RefreshRestoreBtnState()
  self:AddInputMethodChangedListen()
end

function M:InitGamepad()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self:SetFocus()
  self.Controller_Confirm:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Pwner = self
      }
    },
    Desc = GText("UI_Tips_Ensure")
  })
  self.Controller_Back:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        Pwner = self
      }
    },
    Desc = GText("UI_BACK")
  })
  self.Btn_Restore:SetGamePadImg("Y")
  self.List_Setting:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Setting:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:RefreshUI()
  self.List_Setting:ClearListItems()
  for _, ItemData in ipairs(GuildEntranceSettings) do
    if self:InitSettingItemData(ItemData) then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.ItemData = ItemData
      Content.Parent = self
      self.List_Setting:AddItem(Content)
    end
  end
  self.List_Setting:SetFocus()
end

function M:InitSettingItemData(ItemData)
  local Options = self:GetSettingOptions(ItemData)
  if #Options <= 0 then
    return nil
  end
  ItemData.Options = Options
  for Index, Option in ipairs(Options) do
    if ItemData.ItemType ~= "Switch" then
      Option.State = nil
      Option.State = self:GetEMSettinCache(Option)
    else
      for SubIndex, SubOption in ipairs(Option) do
        SubOption.State = nil
        SubOption.State = self:GetEMSettinCache(SubOption)
      end
    end
  end
  return true
end

function M:GetSettingOptions(ItemData)
  if ItemData.DynamicOptions and self[ItemData.DynamicOptions] then
    local Options = self[ItemData.DynamicOptions](self)
    if Options then
      return Options
    end
  end
  return ItemData.Options or {}
end

function M:OnRestoreBtnClick()
  if not self:CanRestoreScene() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "GuildGarrisonTip_2")
    return
  end
  local Params = {
    ShortText = GText("GuildGarrisonRestoreConfirm"),
    RightCallbackFunction = function()
      self:OnRestoreConfirmed()
    end
  }
  UIManager(self):ShowCommonPopupUI(100418, Params, self)
end

function M:CanRestoreScene()
  local GuildManager = self.GuildManager
  if not GuildManager then
    return false
  end
  local ActorStates = GuildManager:GetSceneActors()
  return ActorStates and ActorStates:Length() > 0
end

function M:RefreshRestoreBtnState()
  if not self.Btn_Restore then
    return
  end
  self.Btn_Restore:ForbidBtn(not self:CanRestoreScene())
end

function M:OnRestoreConfirmed()
  local GuildManager = self.GuildManager
  if not GuildManager then
    return
  end
  GuildManager:RestoreSceneToInitialStateLua(function(bSuccess)
    if not bSuccess then
      return
    end
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "GuildGarrisonTip")
    self:RefreshRestoreBtnState()
    self:RefreshUI()
  end)
end

function M:GetEMSettinCache(Option)
  local GuildManager = self.GuildManager
  if Option.ID == "GridShow" then
    return GuildManager.Settings.bShowGrid
  elseif Option.ID == "EffectShow" then
    return GuildManager.Settings.bShowParticle
  elseif Option.ID == "FreeCam" then
    return GuildManager.Settings.CameraMoveMode == UE4.EGuildCameraMoveMode.FreeMode
  elseif Option.ID == "TopCam" then
    return GuildManager.Settings.CameraMoveMode == UE4.EGuildCameraMoveMode.TopDownView
  elseif Option.ID == "GridMove" then
    return GuildManager.Settings.ComponentMoveMode == UE4.EGuildComponentMoveMode.GridMove
  elseif Option.ID == "PixelMove" then
    return GuildManager.Settings.ComponentMoveMode == UE4.EGuildComponentMoveMode.PixelMove
  end
  return nil
end

function M:SaveEMSettinCache(Option)
  local GuildManager = self.GuildManager
  if Option.ID == "GridShow" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("bShowGrid", 1)
    else
      GuildManager:SaveEMSettingCache("bShowGrid", 0)
    end
  elseif Option.ID == "EffectShow" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("bShowParticle", 1)
    else
      GuildManager:SaveEMSettingCache("bShowParticle", 0)
    end
  elseif Option.ID == "FreeCam" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("CameraMoveMode", 0)
    else
      GuildManager:SaveEMSettingCache("CameraMoveMode", 1)
    end
  elseif Option.ID == "TopCam" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("CameraMoveMode", 1)
    else
      GuildManager:SaveEMSettingCache("CameraMoveMode", 0)
    end
  elseif Option.ID == "GridMove" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("ComponentMoveMode", 0)
    else
      GuildManager:SaveEMSettingCache("ComponentMoveMode", 1)
    end
  elseif Option.ID == "PixelMove" then
    if Option.State == true then
      GuildManager:SaveEMSettingCache("ComponentMoveMode", 1)
    else
      GuildManager:SaveEMSettingCache("ComponentMoveMode", 0)
    end
  end
end

function M:GetQuickDemolishOptions()
  local CategoryItems = {}
  local GuildManager = self.GuildManager
  if not GuildManager then
    return CategoryItems
  end
  local UnitMap = GuildManager:CaculateSceneActorInfo()
  for Key, Value in pairs(UnitMap) do
    local Data = DataMgr.GuildItem[Key]
    if Data then
      local Catetory = DataMgr.GuildSecondCategory[Data.SecondCategory]
      table.insert(CategoryItems, {
        ID = Data.SecondCategory,
        Label = Catetory and Catetory.Name or ""
      })
    end
  end
  return CategoryItems
end

function M:QuickDemolishByOption(Option)
  local GuildManager = self.GuildManager
  if not GuildManager or not Option then
    return
  end
  local SecondCategory = Option.ID
  local ActorStates = GuildManager:GetSceneActors()
  local ActorStateList = ActorStates:ToTable()
  local ComponentItems = {}
  for _, ActorState in ipairs(ActorStateList) do
    local UnitId = ActorState.UnitId
    local GuildItemData = DataMgr.GuildItem[UnitId]
    if GuildItemData and GuildItemData.SecondCategory == SecondCategory then
      self.Parent:DeleteGuildActor(ActorState.Id)
    end
  end
  self:RefreshUI()
end

function M:BP_GetDesiredFocusTarget()
  local SelectedItem = self.List_Setting and self.List_Setting:BP_GetSelectedItem()
  local SettingItem = SelectedItem and SelectedItem.SelfWidget
  return SettingItem or self.List_Setting
end

function M:CloseByGamepad()
  if self.Parent.CloseSidePanel then
    self.Parent:CloseSidePanel()
  elseif self.Close then
    self:Close()
  end
end

function M:Destruct()
  local GuildManager = self.GuildManager
  if GuildManager and GuildManager.OnPlacedItemChanged then
    GuildManager.OnPlacedItemChanged:Remove(self, self.RefreshRestoreBtnState)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonRight then
    self:CloseByGamepad()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == Const.GamepadFaceButtonUp then
    self:OnRestoreBtnClick()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if not self:IsVisible() then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  if self.Mobile then
    return
  end
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self.Panel_Controller:SetVisibility(IsGamepad and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
end

return M
