require("UnLua")
local UpgradeUtils = require("Utils.UpgradeUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local SkillUtils = require("Utils.SkillUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.PetEntry_Component",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Initialize(Initializer)
  self.bChangingPetVisibility = false
end

function M:Construct()
  self.Btn_Intensify:BindEventOnClicked(self, self.OnIntensifyBtnClicked)
  self.Btn_Intensify:BindForbidStateExecuteEvent(self, self.OnForbiddenIntensifyBtnClicked)
  self.Btn_Replace:BindEventOnClicked(self, self.OnReplaceBtnClicked)
  self.Btn_Replace:BindForbidStateExecuteEvent(self, self.OnForbiddenReplaceBtnClicked)
  self.ConfirmBtns = {
    self.Btn_Intensify,
    self.Btn_Replace
  }
  self.Text_Invisible:SetText(GText("Pet_Invisible"))
  self.Text_Skill:SetText(GText("UI_Armory_Skill"))
  self.List_Skill:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.List_Skill.bIsFocusable = false
  self:AddDispatcher(EventID.OnSwitchPet, self, self.OnSwitchPet)
  self.Button_Preview:Init({
    ClickCallback = self.OnBtn_PreviewClicked,
    SoundFunc = function()
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
    end,
    SoundFuncReceiver = self,
    OwnerWidget = self,
    OnAddedToFocusPath = self.OnEntryWidgetAddedToFocusPath
  })
  self.Text_Preview:SetText(GText("UI_Preview_Title"))
  self.Panel_Invisible:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.CheckBox_HidePet.Text_Slot:AddChild(self.Text_Invisible)
  local NewSlot = self.CheckBox_HidePet.Root:GetChildAt(0):AddChildToOverlay(self.New)
  NewSlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Right)
  NewSlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Top)
  self.CheckBox_HidePet:InitGamepadKey("Menu")
  self.CheckBox_HidePet.Com_KeyImg:SetVisibility(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.CheckBox_HidePet:BindEventOnClicked({
    Inst = self,
    Func = self.BtnInvisibleArea
  })
  if self.Btn_PetRecycle and self.Btn_PetRecycle.Init then
    self.Btn_PetRecycle:Init(self, self.OnPetRecycleClicked)
  end
  self:SyncPetVisibility()
  self:InitPetIsShowReddot()
  self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if EMCache:Get("PetIsShowNew", true) then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnIntensifyBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  if not self.Pet:IsFinalMaxLevel() then
    local PetId = self.Pet.PetId
    local Level = self.Pet.Level
    local Params = {
      Target = self.Pet,
      Type = CommonConst.ArmoryType.Pet,
      Tag = CommonConst.ArmoryType.Pet,
      HideItemTips = true
    }
    local BreakData = DataMgr.PetBreak[PetId]
    local BreakLevelInfo = BreakData and BreakData[self.Pet.BreakNum]
    local NextBreakLevelInfo = BreakData and BreakData[self.Pet.BreakNum + 1]
    local UIConfig = DataMgr.SystemUI.ArmoryCardLevelWeapon
    if NextBreakLevelInfo then
      if Level < BreakLevelInfo.PetBreakLevel then
        Params.BehaviourType = "LevelUp"
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), CommonConst.ArmoryType.Pet, self.Pet, self, Params)
      else
        Params.BehaviourType = "BreakLevelUp"
        UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), CommonConst.ArmoryType.Pet, self.Pet, self, Params)
      end
    else
      Params.BehaviourType = "LevelUp"
      UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self.Parent:GetZOrder(), CommonConst.ArmoryType.Pet, self.Pet, self, Params)
    end
  else
    UIManager(self):ShowUITip("CommonToastMain", GText("Max_Level_Achieved"))
  end
end

function M:OnReplaceBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  local Avatar = ArmoryUtils:GetAvatar()
  if Avatar then
    self.Parent:BlockAllUIInput(true)
    Avatar:EquipPet(self.Pet.UniqueId)
  end
end

function M:OnSwitchPet()
  self.Parent:BlockAllUIInput(false)
end

function M:OnForbiddenIntensifyBtnClicked()
  UIManager(self):ShowUITip("CommonToastMain", GText("Max_Level_Achieved"))
end

function M:OnForbiddenReplaceBtnClicked()
end

function M:UpdateButtonStyle(CurPet, Pet)
  self.ButtonStyleInfo = {
    {},
    {}
  }
  local MaxLevel, RealMaxLevel = UpgradeUtils.GetMaxLevel(Pet, CommonConst.ArmoryType.Pet)
  if Pet:IsFinalMaxLevel() then
    self.ButtonStyleInfo[1].ForbidBtn = true
    self.ButtonStyleInfo[1].Visibility = UIConst.VisibilityOp.Collapsed
  else
    if Pet.Level >= (MaxLevel or RealMaxLevel) then
      self.ButtonStyleInfo[1].Text = GText("UI_FUNC_BREAKLEVELUP")
    else
      self.ButtonStyleInfo[1].Text = GText("UI_FUNC_LEVELUP")
    end
    self.ButtonStyleInfo[1].ForbidBtn = false
    self.ButtonStyleInfo[1].Visibility = UIConst.VisibilityOp.SelfHitTestInvisible
  end
  self.ButtonStyleInfo[2].Visibility = UIConst.VisibilityOp.SelfHitTestInvisible
  if CurPet == Pet then
    self.ButtonStyleInfo[2].Text = GText("UI_Armory_AlreadyPut")
    self.ButtonStyleInfo[2].ForbidBtn = true
  else
    self.ButtonStyleInfo[2].Text = GText("UI_Armory_PutOn")
    self.ButtonStyleInfo[2].ForbidBtn = false
  end
  if self.bHideDeployBtn then
    self.ButtonStyleInfo[2].Visibility = UIConst.VisibilityOp.Collapsed
  end
  for i, Param in ipairs(self.ButtonStyleInfo) do
    self.ConfirmBtns[i]:SetVisibility(Param.Visibility)
    self.ConfirmBtns[i]:SetText(Param.Text)
    self.ConfirmBtns[i]:ForbidBtn(Param.ForbidBtn)
  end
end

function M:OnBtn_PreviewClicked()
  if not self.Pet then
    return
  end
  local Params = {
    Pet = self.Pet,
    TabConfigData = {
      LeftGamePadKey = "LeftShoulder",
      RightGamePadKey = "RightShoulder",
      Tabs = {
        {
          Text = GText("UI_Armory_Pet_Positive"),
          TabId = 1
        },
        {
          Text = GText("UI_Armory_Pet_Passive"),
          TabId = 2
        }
      }
    }
  }
  UIManager(self):ShowCommonPopupUI(100346, Params, self)
end

function M:GetButtonStyleInfo()
  return self.ButtonStyleInfo
end

function M:Init(Params)
  self.bFromOptRewardPreview = Params.bFromOptRewardPreview == true
  self.Parent = Params.Parent
  self.Pet = Params.Target
  self.IsPreviewMode = Params.IsPreviewMode
  self.bHideDeployBtn = Params.bHideDeployBtn
  self.bNeedPreviewSwitcher = Params.bNeedPreviewSwitcher
  local EntryVisibility = (self.IsPreviewMode or self.bFromOptRewardPreview) and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible
  self.CheckBox_HidePet:SetVisibility(EntryVisibility)
  if self.Btn_PetRecycle then
    self.Btn_PetRecycle:SetVisibility(self.Btn_PetRecycle.Init and EntryVisibility or UIConst.VisibilityOp.Collapsed)
  end
  self:SyncPetVisibility()
  if self.bFromOptRewardPreview and self.Panel_Invisible then
    self.Panel_Invisible:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Parent.ActorController:BindEvent(self, {
    OnPlayPetFresnel = self.OnPlayPetFresnel,
    OnCharModelChanged = self.OnCharModelChanged
  })
  if self.IsPreviewMode and self.bNeedPreviewSwitcher then
    self.PreviewTab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.PreviewTab:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.IsPreviewMode then
    self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
    self.PreviewTab:UpdateState()
  else
    self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  end
  self:UpdatePetInfos(self.Pet)
  self:UpdateSkillInfos(self.Pet)
  self:UpdateLevelUpBtn(self.Pet)
  self:UpdateEntryInfos(self.Pet)
  self:UpdateButtonStyle(Params.CurPet, self.Pet)
end

function M:UpdatePetInfos(Pet)
  if not Pet then
    return
  end
  local MaxLevel, FinalMaxLevel = UpgradeUtils.GetMaxLevel(Pet, "Pet")
  local RealMaxLevel = MaxLevel or FinalMaxLevel
  local LevelUpData = DataMgr.PetLevelUp[Pet.Level]
  local Percent = math.clamp(Pet.Exp / LevelUpData.PetLevelMaxExp, 0, 1)
  if RealMaxLevel <= Pet.Level then
    Percent = 1
  end
  local BreakLevelUpData = DataMgr.PetBreak[Pet.PetId]
  self.LevelInfo:Init(Pet.Level, RealMaxLevel, Percent, Pet.BreakNum or 0, BreakLevelUpData)
  local Data = DataMgr.Pet[Pet.PetId]
  if Data then
    self.Text_Describe:SetText(GText(Data.IpDes))
  end
end

function M:UpdateSkillInfos(Pet)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Pet then
    return
  end
  self.List_Skill:ClearListItems()
  local Data = DataMgr.BattlePet[Pet:Data().BattlePetId]
  if not Data then
    return
  end
  local AdditionalLevel = Pet:GetSkillLevelUp()
  local CurPetSkillLevel = Pet.BreakNum + AdditionalLevel
  if Data.SupportSkillId then
    local SkillDesc = SkillUtils.GetSkillDesc(Data.SupportSkillId, ArmoryUtils:GetPetSkillLevel(CurPetSkillLevel))
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(Obj, "Owner", self)
    rawset(Obj, "Pet", Pet)
    rawset(Obj, "SkillId", Data.SupportSkillId)
    rawset(Obj, "SkillName", GText("UI_Armory_Pet_Positive"))
    rawset(Obj, "SkillDesc", SkillDesc)
    rawset(Obj, "SkillLevel", Pet.BreakNum + 1)
    rawset(Obj, "ExtraLevel", AdditionalLevel)
    local SkillData = DataMgr.Skill[Data.SupportSkillId]
    if SkillData and SkillData[1] and SkillData[1][0] then
      SkillData = SkillData[1][0]
      rawset(Obj, "SkillData", SkillData)
      rawset(Obj, "SkillBtnDesc", GText(SkillData.SkillBtnDesc))
    end
    self.List_Skill:AddItem(Obj)
  end
  local PassiveEffectDesc = ArmoryUtils:GenPetPassiveEffectDesc(Data, ArmoryUtils:GetPetSkillLevel(CurPetSkillLevel))
  if PassiveEffectDesc and "" ~= PassiveEffectDesc then
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(Obj, "Owner", self)
    rawset(Obj, "Pet", Pet)
    rawset(Obj, "SkillLevel", Pet.BreakNum + 1)
    rawset(Obj, "SkillName", GText("UI_Armory_Pet_Passive"))
    rawset(Obj, "SkillDesc", PassiveEffectDesc)
    rawset(Obj, "ExtraLevel", AdditionalLevel)
    self.List_Skill:AddItem(Obj)
  end
end

function M:UpdateLevelUpBtn(Target)
  if not self.bHideReddot then
    local CanBreak = UpgradeUtils.CheckPetCanBreakLevelUp(Target)
    if CanBreak then
      self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
    end
  else
    self.Btn_Intensify:SetReddotVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:PlayInAnim()
  if self:IsAnimationPlaying(self.In) or self:IsAnimationPlaying(self.Switch_Tab) then
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    return
  end
  self:PlayAnimation(self.In)
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WB_EntryItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:AddTimer(0.01, function()
    self.LevelInfo:PlayStarsInAnim()
    if rawget(self, "ShouldPlayNormalIn") then
      self.WB_EntryItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self:PlayEntriesInAnim()
    end
    self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end, false, 0, "PetInfoInAnim", true)
end

function M:PlayOutAnim()
  self:RemoveTimer("PetInfoInAnim")
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnCharModelChanged()
  rawset(self, "ShouldPlayNormalIn", nil)
end

function M:OnPlayPetFresnel()
  rawset(self, "ShouldPlayNormalIn", true)
  self.WB_EntryItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayEntriesInAnim()
end

function M:InitPetIsShowReddot()
  if self.IsPreviewMode or not self.Com_SwitchCheckBox then
    return
  end
end

function M:SyncPetVisibility(IsShow)
  local Avatar = GWorld:GetAvatar()
  if nil == IsShow and Avatar then
    IsShow = Avatar.ShowPet
  end
  if nil ~= IsShow then
    self.CheckBox_HidePet:SetIsCheckedWithoutCallback(not IsShow, false)
  end
  self.CheckBox_HidePet:ForbidBtn(self.bChangingPetVisibility)
end

function M:BtnInvisibleArea()
  self:SyncPetVisibility()
  if self.bChangingPetVisibility or self.IsPreviewMode or self.bFromOptRewardPreview then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not EMCache:Get("PetIsShowNew", true) then
    ArmoryUtils:SetPetIsShowReddotRead()
  end
  if not EMCache:Get("PetIsShowNew", true) then
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.bChangingPetVisibility = true
  self:SyncPetVisibility()
  local TargetIsShow = not Avatar.ShowPet
  
  local function Cancel()
    if not IsValid(self) then
      return
    end
    self.bChangingPetVisibility = false
    self:SyncPetVisibility()
  end
  
  local function Confirm()
    Avatar:SetShowPet(function(Ret, IsShow)
      if not IsValid(self) then
        return
      end
      self.bChangingPetVisibility = false
      if ErrorCode:Check(Ret) then
        self:SyncPetVisibility(IsShow)
      else
        self:SyncPetVisibility()
      end
    end, TargetIsShow)
  end
  
  if not TargetIsShow then
    UIManager(self):ShowCommonPopupUI(100382, {
      RightCallbackFunction = Confirm,
      LeftCallbackFunction = Cancel,
      CloseBtnCallbackFunction = Cancel
    }, self.Parent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/switch_off", nil, nil)
  else
    Confirm()
    AudioManager(self):PlayUISound(self, "event:/ui/common/switch_on", nil, nil)
  end
end

function M:OnPetRecycleClicked()
  if not self.IsPreviewMode and not self.bFromOptRewardPreview and not self.bChangingPetVisibility then
    self.Parent:OpenPetRecycle()
  end
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(UE4.UKismetInputLibrary.GetKey(InKeyEvent))
  if KeyName == UIConst.GamePadKey.SpecialRight then
    self:BtnInvisibleArea()
    return UIUtils.Handled, true
  elseif KeyName == UIConst.GamePadKey.RightThumb then
    self:OnPetRecycleClicked()
    return UIUtils.Handled, true
  end
  return UIUtils.UnHandled, false
end

function M:Destruct()
  self.CheckBox_HidePet:UnBindEventOnClickedByObj(self)
end

AssembleComponents(M)
return M
