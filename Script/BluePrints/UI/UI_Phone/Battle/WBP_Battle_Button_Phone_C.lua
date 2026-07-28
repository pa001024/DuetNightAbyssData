require("Unlua")
local EMCache = require("EMCache.EMCache")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local UltimateAttackGuideHelper = require("BluePrints.UI.UI_Phone.Battle.UltimateAttackGuideHelper")
local FOLD_FEATURE_UNLOCK_QUEST_ID = 10020203
local LEFT_AUTO_BTN_UNLOCK_QUEST_ID = 10020101

local function GetMappedLayout(Layout)
  if nil == Layout then
    return 1
  end
  if Layout >= 7 then
    return 3
  end
  return (Layout - 1) % 2 + 1
end

local function IsLayout3(Layout)
  return nil ~= Layout and Layout >= 7
end

local WBP_Battle_Button_Phone = Class("BluePrints.UI.BP_UIState_C")
WBP_Battle_Button_Phone._components = {
  "BluePrints.UI.UIComponent.TouchComponent",
  "BluePrints.UI.UI_Phone.Battle.Component.HUDWidgetDesignComponent"
}

function WBP_Battle_Button_Phone:Initialize(Initializer)
  self.Super.Initialize(self)
  self.OwnerPlayer = nil
end

function WBP_Battle_Button_Phone:Construct()
  self.Super.Construct(self)
  self.NoCancelBulletJumpActions = {
    "Skill3",
    "Jump",
    "Avoid",
    "BulletJump"
  }
  self.SettingDisabledTags = {}
  self.FoldPressedSkillInputs = {}
  self.bFoldBlockedByJetFly = false
  self.TripleBulletJumpLockStates = {}
end

function WBP_Battle_Button_Phone:ForceInit()
  local WasFolded = self.IsFolded == true
  self:StopFoldTimer()
  self.IsFolded = false
  self.FoldPressedSkillInputs = {}
  self.bFoldBlockedByJetFly = false
  self:OnLoaded()
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self:InitUnlockInfo()
  self:PlayAnim("In")
  self:InitTouchLayer(self.OwnerPlayer, 0, 0)
  self:InitVariable()
  self:GetSkillActiveInfo()
  self:RefreshLeftAutoBtnPrologueUnlockState()
  self.AtkRanged:UpdateWeaponIcon()
  self.DelayAddTouchLayerTimer = self:AddTimer(0.1, self.DelayAddTouchLayer, true)
  self:InitHUDLayout()
  self:InitMountHUD()
  self.OwnerPlayer:SetSkillPanelTimer()
  local bShowRecordButton = EMCache:Get("RecordButton") or false
  self:OnRecordButtonOptionChanged(bShowRecordButton)
  self:SyncAutoCombatVisual()
  if WasFolded then
    self:RestoreFoldHitBlock()
    EMUIAnimationSubsystem:EMPlayAnimation(self, self:GetFoldAnim(), EUMGSequencePlayMode.Reverse)
  end
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
end

function WBP_Battle_Button_Phone:InitListenEvent()
  self:AddDispatcher(EventID.UpdateMainPlayerSp, self, self.OnUpdateCharSp)
  self:AddDispatcher(EventID.UpdateMainPlayerMaxSp, self, self.OnUpdateMaxSp)
  self:AddDispatcher(EventID.UpdateSkillEfficiency, self, self.OnUpdateSkillEfficiency)
  self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
  self:AddDispatcher(EventID.OnSwitchPet, self, self.OnSwitchPet)
  self:AddDispatcher(EventID.OnBattlePetInitReady, self, self.OnBattlePetInitReady)
  self:AddDispatcher(EventID.ReloadStart, self, self.TryToEnterReloadState)
  self:AddDispatcher(EventID.OnSelectWeapon, self, self.RefreshWeaponInfo)
  self:AddDispatcher(EventID.OnSwitchWeapon, self, self.RefreshWeaponInfo)
  self:AddDispatcher(EventID.OnMainCharacterInitReady, self, self.RefreshWeaponInfo)
  self:AddDispatcher(EventID.OnRefreshBattleWheelEnableState, self, self.ChangeBattleWheelState)
  self:AddDispatcher(EventID.OnBuffSpModify, self, self.OnUpdateBuffSpModify)
  self:AddDispatcher(EventID.OnPropEffectReplaceSkill, self, self.OnPropEffectReplaceSkill)
  self:AddDispatcher(EventID.OnPropEffectEndReplaceSkill, self, self.OnPropEffectEndReplaceSkill)
  self:AddDispatcher(EventID.OnSwitchMobileHUDLayout, self, self.OnSwitchMobileHUDLayout)
  self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.UpdateLayoutInfoByServerData)
  self:AddDispatcher(EventID.OnSwitchLeftShoot, self, self.InitLeftShoot)
  self:AddDispatcher(EventID.OnSwitchLeftBulletJump, self, self.InitLeftBulletJump)
  self:AddDispatcher(EventID.OnSwitchBulletJumpCancel, self, self.InitBulletJumpCancel)
  self:AddDispatcher(EventID.OnSwitchExtraSlide, self, self.InitExtraSlide)
  self:AddDispatcher(EventID.OnSwitchExtraSlideAttack, self, self.InitExtraSlideAttack)
  self:AddDispatcher(EventID.OnEnableBattleMount, self, self.OnEnableBattleMount)
  self:AddDispatcher(EventID.OnDisableBattleMount, self, self.OnDisableBattleMount)
  self:AddDispatcher(EventID.OnStartMountFly, self, self.OnStartMountFly)
  self:AddDispatcher(EventID.OnStopMountFly, self, self.OnStopMountFly)
  self:AddDispatcher(EventID.OnSkillInfosRep, self, self.OnSkillInfosRep)
  self:AddDispatcher(EventID.OnMobileHookShow, self, self.OnMobileHookShow)
  self:AddDispatcher(EventID.OnSkill1InAirChanged, self, self.OnSkill1InAirChanged)
  self:AddDispatcher(EventID.OnSkill2InAirChanged, self, self.OnSkill2InAirChanged)
  self:AddDispatcher(EventID.OnLockOnButtonShowChanged, self, self.OnLockOnButtonShowChanged)
  self:AddDispatcher(EventID.OnCameraLockOnChanged, self, self.OnCameraLockOnChanged)
  self:AddDispatcher(EventID.OnRecordButtonOptionChanged, self, self.OnRecordButtonOptionChanged)
  self:AddDispatcher(EventID.OnAutoAttackEnabledChanged, self, self.OnAutoAttackEnabledChanged)
  self:AddDispatcher(EventID.OnAutoShootEnabledChanged, self, self.OnAutoShootEnabledChanged)
  self:AddDispatcher(EventID.QuestFinished, self, self.OnQuestFinished)
  self:AddDispatcher(EventID.OnNpcEnterOrQuitSpecialQuest, self, self.RefreshFoldStateBySpecialQuestState)
  self:AddDispatcher(EventID.OnAttackPressed, self, self.OnFoldAttackPressed)
  self:AddDispatcher(EventID.OnFirePressed, self, self.OnFoldFirePressed)
  self:AddDispatcher(EventID.OnSkill1Pressed, self, self.OnFoldSkillPressed)
  self:AddDispatcher(EventID.OnSkill2Pressed, self, self.OnFoldSkillPressed)
  self:AddDispatcher(EventID.OnSkill3Pressed, self, self.OnFoldSkillPressed)
  self:AddDispatcher(EventID.OnBattleMeleeTriggered, self, self.OnFoldMeleeTriggered)
  self:AddDispatcher(EventID.OnBattleFireTriggered, self, self.OnFoldFireTriggered)
  self:InitTouchListenEvent()
end

function WBP_Battle_Button_Phone:InitExtraButtons(WidgetPlanData)
  DebugPrint("[LAYOUT_DBG] InitExtraButtons: WidgetPlanData=", nil ~= WidgetPlanData and "not-nil" or "nil", " HasExtraSlide(before)=", self.HasExtraSlide, " HasExtraSlideAttack(before)=", self.HasExtraSlideAttack, " HasSlidingJump(before)=", self.HasSlidingJump, " CurrentLayout=", self.CurrentLayout)
  self:InitLeftShoot()
  self:InitBulletJumpCancel()
  self:InitLeftBulletJump()
  self:InitExtraSlide(WidgetPlanData)
  self:InitExtraSlideAttack(WidgetPlanData)
  self:InitSlidingJump(WidgetPlanData)
  self:ApplyLayoutButtonVisibility(self.CurrentLayout)
end

function WBP_Battle_Button_Phone:InitLeftShoot()
  self.HasLeftShoot = EMCache:Get("HasLeftShoot")
  if self.HasLeftShoot == nil then
    local DefaultValue = DataMgr.Option.LeftShootShow.DefaultValueM
    local ToBool = "True" == DefaultValue and true or false
    EMCache:Set("HasLeftShoot", ToBool)
  end
  if self.HasLeftShoot then
    self.SettingDisabledTags.AtkRangedLeft = nil
    self.AtkRangedLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.AtkRanged:ChangeLeftShootState()
  else
    self.SettingDisabledTags.AtkRangedLeft = true
    self.AtkRangedLeft:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:InitLeftBulletJump()
  self.HasLeftBulletJump = EMCache:Get("HasLeftBulletJump")
  if self.HasLeftBulletJump == nil then
    local DefaultValue = DataMgr.Option.LeftBulletJumpShow.DefaultValueM
    local ToBool = "True" == DefaultValue and true or false
    EMCache:Set("HasLeftBulletJump", ToBool)
    self.HasLeftBulletJump = ToBool
  end
  if self.HasLeftBulletJump then
    self.SettingDisabledTags.BulletJumpLeft = nil
    self.BulletJumpLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.SettingDisabledTags.BulletJumpLeft = true
    self.BulletJumpLeft:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:SetTouchItemEnabled("BulletJumpLeft", self.HasLeftBulletJump and 3 ~= GetMappedLayout(self.CurrentLayout))
end

function WBP_Battle_Button_Phone:InitBulletJumpCancel()
  self.HasBulletJumpCancel = EMCache:Get("BulletJumpCamRotate")
  if self.HasBulletJumpCancel == nil then
    local DefaultValue = DataMgr.Option.BulletJumpCamAdjust.DefaultValueM
    local ToBool = "True" == DefaultValue and true or false
    EMCache:Set("HasLeftBulletJump", ToBool)
  end
  if self.HasBulletJumpCancel then
    self.SettingDisabledTags.BulletJumpCancelLeft = nil
    self.SettingDisabledTags.BulletJumpCancelRight = nil
    self.SettingDisabledTags.BulletJumpCancelLeft_2 = nil
    self.SettingDisabledTags.BulletJumpCancelRight_2 = nil
  else
    self.SettingDisabledTags.BulletJumpCancelLeft = true
    self.SettingDisabledTags.BulletJumpCancelRight = true
    self.SettingDisabledTags.BulletJumpCancelLeft_2 = true
    self.SettingDisabledTags.BulletJumpCancelRight_2 = true
    self.BulletJumpCancelLeft:SetVisibility(ESlateVisibility.Collapsed)
    self.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
    self.BulletJumpCancelLeft_2:SetVisibility(ESlateVisibility.Collapsed)
    self.BulletJumpCancelRight_2:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:CheckHasExtraSlide(WidgetPlanData)
  local PlanData = WidgetPlanData
  if not PlanData then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local Layout = Avatar:GetCurrentMobileHudPlanIndex()
      if Layout then
        PlanData = Avatar:GetMobileHudPlan(Layout) or {}
      end
    end
  end
  if not PlanData then
    return false
  end
  if PlanData.SlideTacklePos and PlanData.SlideTacklePos.bHasAddInHUDSetting then
    return true
  end
  return false
end

function WBP_Battle_Button_Phone:InitExtraSlide(WidgetPlanData)
  self.HasExtraSlide = self:CheckHasExtraSlide(WidgetPlanData)
  if self.HasExtraSlide == nil then
    self.HasExtraSlide = false
  end
  if self.HasExtraSlide then
    self.Jump:OnSkillInActive(ESkillName.Slide)
    self.Slide:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    if not self.OwnerPlayer or not self.OwnerPlayer.CurMount then
      self.Jump:OnSkillActive(ESkillName.Slide)
    end
    self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:CheckHasExtraSlideAttack(WidgetPlanData)
  local PlanData = WidgetPlanData
  if not PlanData then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local Layout = Avatar:GetCurrentMobileHudPlanIndex()
      if Layout then
        PlanData = Avatar:GetMobileHudPlan(Layout) or {}
      end
    end
  end
  if not PlanData then
    return false
  end
  if PlanData.SlidingSlashPos and PlanData.SlidingSlashPos.bHasAddInHUDSetting then
    return true
  end
  return false
end

function WBP_Battle_Button_Phone:InitExtraSlideAttack(WidgetPlanData)
  self.HasExtraSlideAttack = self:CheckHasExtraSlideAttack(WidgetPlanData)
  if self.HasExtraSlideAttack == nil then
    self.HasExtraSlideAttack = false
  end
  if self.HasExtraSlideAttack then
    self.Jump:OnSkillInActive(ESkillName.Attack)
    self.SlideAttack:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    if not self.OwnerPlayer or not self.OwnerPlayer.CurMount then
      self.Jump:OnSkillActive(ESkillName.Attack)
    end
    self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:CheckHasSlidingJump(WidgetPlanData)
  local PlanData = WidgetPlanData
  if not PlanData then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local Layout = Avatar:GetCurrentMobileHudPlanIndex()
      if Layout then
        PlanData = Avatar:GetMobileHudPlan(Layout) or {}
      end
    end
  end
  if not PlanData then
    return false
  end
  if PlanData.SlidingJumpMallPos and PlanData.SlidingJumpMallPos.bHasAddInHUDSetting then
    return true
  end
  return false
end

function WBP_Battle_Button_Phone:InitSlidingJump(WidgetPlanData)
  self.HasSlidingJump = self:CheckHasSlidingJump(WidgetPlanData)
  if self.HasSlidingJump == nil then
    self.HasSlidingJump = false
  end
  if self.SlidingJump then
    if self.HasSlidingJump then
      self.SlidingJump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.SlidingJump:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function WBP_Battle_Button_Phone:InitHUDLayout()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.CurrentLayout = Avatar:GetCurrentMobileHudPlanIndex() or 2
  self:OnSwitchMobileHUDLayout(self.CurrentLayout)
end

function WBP_Battle_Button_Phone:UpdateLayoutInfoByServerData(OpType, Layout, LayoutData)
  DebugPrint("[LAYOUT_DBG] UpdateLayoutInfoByServerData: OpType=", OpType, "Layout=", Layout, "type(Layout)=", type(Layout), "LayoutData(3rd arg)=", nil ~= LayoutData and "not-nil" or "nil")
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if "Update" == OpType then
    local WidgetPlanData = Avatar:GetMobileHudPlan(Layout) or {}
    local bEmpty = IsEmptyTable(WidgetPlanData)
    DebugPrint("[LAYOUT_DBG] GetMobileHudPlan(", Layout, ") -> IsEmpty=", bEmpty)
    if not bEmpty then
      local keyCount = 0
      for k, v in pairs(WidgetPlanData) do
        keyCount = keyCount + 1
      end
      DebugPrint("[LAYOUT_DBG] PlanData keys count=", keyCount, " SlideTacklePos.bHasAddInHUDSetting=", WidgetPlanData.SlideTacklePos and WidgetPlanData.SlideTacklePos.bHasAddInHUDSetting or "nil", " SlidingSlashPos.bHasAddInHUDSetting=", WidgetPlanData.SlidingSlashPos and WidgetPlanData.SlidingSlashPos.bHasAddInHUDSetting or "nil", " SlidingJumpMallPos.bHasAddInHUDSetting=", WidgetPlanData.SlidingJumpMallPos and WidgetPlanData.SlidingJumpMallPos.bHasAddInHUDSetting or "nil")
    end
    if bEmpty then
      self:SetBtnDefaultPosition(Layout - 1)
      self:InitExtraButtons(WidgetPlanData)
    else
      local IsFirstPlan = 0 ~= self.EditPlanIndex % 2
      self.EditPlanIndex = Layout
      for ParentName, WidgetConfig in pairs(BattleHUDCommonConst.DesignBaseConfigInHUD) do
        local PositionInHUD = WidgetPlanData[ParentName]
        DebugPrint("WBP_Battle_Button_Phone:UpdateLayoutInfoByServerData", ParentName, PositionInHUD)
        if PositionInHUD then
          local NodeName = WidgetConfig.HUDNodeName or ParentName
          local ParentNode = self[ParentName] or self[NodeName]
          self:_UpdateWidgetToTargetPos(ParentNode, FVector2D(PositionInHUD.PosX, PositionInHUD.PosY), false, true)
          self:_UpdateWidgetToTargetScale(ParentNode, FVector2D(PositionInHUD.ScaleX, PositionInHUD.ScaleY), true)
        end
        if "JumpPos" == ParentName and PositionInHUD then
          self.Jump.InnerButtonDis = self.Jump.DefaultButtonDis * PositionInHUD.ScaleX
        end
      end
      self:SetBtnDefaultPosition(Layout - 1, self.IsFirstPlan)
      self:InitExtraButtons(WidgetPlanData)
    end
  end
end

function WBP_Battle_Button_Phone:OnSwitchMobileHUDLayout(Layout)
  DebugPrint("[LAYOUT_DBG] OnSwitchMobileHUDLayout called: Layout=", Layout, "type=", type(Layout), "PrevCurrentLayout=", self.CurrentLayout, "PrevEditPlanIndex=", self.EditPlanIndex)
  self.CurrentLayout = Layout
  self.EditPlanIndex = Layout
  local MappedLayout = GetMappedLayout(Layout)
  self:SetRootLayoutNode(self.Panel_Skill)
  self:UpdateLayoutInfoByServerData("Update", Layout)
  self.Jump:ChangeByLayout(Layout)
  if 1 == MappedLayout then
    if self:IsBulletJumpLockedForLayout() then
      self.Jump:OnSkillInActive(ESkillName.BulletJump)
    else
      self.Jump:OnSkillActive(ESkillName.BulletJump)
    end
  elseif 3 == MappedLayout then
    self:SyncTripleBulletJumpLockStates()
  end
  self:ApplyLayoutButtonVisibility(Layout)
  if self.IsFolded then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self:GetFoldAnim())
  else
    self:StopFoldTimer()
    self:TryStartFoldTimer()
  end
end

function WBP_Battle_Button_Phone:CheckHasBulletJumpButton()
  return GetMappedLayout(self.CurrentLayout) >= 2
end

function WBP_Battle_Button_Phone:RememberFoldHitBlockWidget(Widget, PrevVisibility)
  if not IsValid(Widget) then
    return
  end
  self.FoldHitBlockList = self.FoldHitBlockList or {}
  for _, entry in ipairs(self.FoldHitBlockList) do
    if entry.widget == Widget then
      return
    end
  end
  self.FoldHitBlockList[#self.FoldHitBlockList + 1] = {widget = Widget, prev = PrevVisibility}
end

function WBP_Battle_Button_Phone:SetVisibleByFoldState(Widget, Visibility)
  if not IsValid(Widget) then
    return
  end
  if self.IsFolded then
    Widget:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self:RememberFoldHitBlockWidget(Widget, Visibility)
    return
  end
  Widget:SetVisibility(Visibility)
end

function WBP_Battle_Button_Phone:IsTripleBulletJumpControlSkill(SkillName)
  return SkillName == ESkillName.Jump or SkillName == ESkillName.BulletJump
end

function WBP_Battle_Button_Phone:GetCurrentMappedLayout()
  local Layout = self.CurrentLayout
  if nil == Layout then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Layout = Avatar:GetCurrentMobileHudPlanIndex()
    end
  end
  return GetMappedLayout(Layout)
end

function WBP_Battle_Button_Phone:CacheTripleBulletJumpLockState(SkillName, StateName)
  if not self:IsTripleBulletJumpControlSkill(SkillName) then
    return
  end
  if "Lock" ~= StateName and "UnLock" ~= StateName then
    return
  end
  self.TripleBulletJumpLockStates = self.TripleBulletJumpLockStates or {}
  self.TripleBulletJumpLockStates[SkillName] = "Lock" == StateName
end

function WBP_Battle_Button_Phone:IsBulletJumpLockedForLayout()
  self.TripleBulletJumpLockStates = self.TripleBulletJumpLockStates or {}
  local bLocked = self.TripleBulletJumpLockStates[ESkillName.BulletJump]
  if nil ~= bLocked then
    return bLocked
  end
  return nil ~= self.OwnerPlayer and self.OwnerPlayer:CheckSkillInActive(ESkillName.BulletJump) == true
end

function WBP_Battle_Button_Phone:IsJumpLockedForLayout()
  self.TripleBulletJumpLockStates = self.TripleBulletJumpLockStates or {}
  local bLocked = self.TripleBulletJumpLockStates[ESkillName.Jump]
  if nil ~= bLocked then
    return bLocked
  end
  return nil ~= self.OwnerPlayer and self.OwnerPlayer:CheckSkillInActive(ESkillName.Jump) == true
end

function WBP_Battle_Button_Phone:SyncTripleBulletJumpLockStates()
  if not IsValid(self.BulletJump) then
    return
  end
  self.TripleBulletJumpLockStates = self.TripleBulletJumpLockStates or {}
  for _, SkillName in ipairs({
    ESkillName.Jump,
    ESkillName.BulletJump
  }) do
    local bLocked = self.TripleBulletJumpLockStates[SkillName]
    if nil == bLocked and self.OwnerPlayer then
      bLocked = self.OwnerPlayer:CheckSkillInActive(SkillName)
    end
    self.BulletJump:SetTripleActionLocked(SkillName, true == bLocked)
  end
end

function WBP_Battle_Button_Phone:IsCurrentTripleBulletJumpLayout()
  local Layout = self.CurrentLayout
  if nil == Layout then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Layout = Avatar:GetCurrentMobileHudPlanIndex()
    end
  end
  return 3 == GetMappedLayout(Layout)
end

function WBP_Battle_Button_Phone:RefreshTripleBulletJumpVisibility()
  if not IsValid(self.BulletJump) then
    return
  end
  if not self:IsCurrentTripleBulletJumpLayout() then
    return
  end
  local bShow = self.BulletJump:ShouldShowTripleButton()
  if bShow then
    self.BulletJump:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:SetTouchItemEnabled("BulletJump", true)
  else
    self:CancelBulletJump()
    self.BulletJump:SetVisibility(ESlateVisibility.Collapsed)
    self:SetTouchItemEnabled("BulletJump", false)
  end
end

function WBP_Battle_Button_Phone:TryApplyTripleBulletJumpLockState(SkillName, StateName)
  if not self:IsCurrentTripleBulletJumpLayout() then
    return false
  end
  if not self:IsTripleBulletJumpControlSkill(SkillName) then
    return false
  end
  if not IsValid(self.BulletJump) then
    return false
  end
  if "Lock" == StateName then
    self.BulletJump:SetTripleActionLocked(SkillName, true)
  elseif "UnLock" == StateName then
    self.BulletJump:SetTripleActionLocked(SkillName, false)
  else
    return false
  end
  self:RefreshTripleBulletJumpVisibility()
  return true
end

function WBP_Battle_Button_Phone:ApplyLayoutButtonVisibility(Layout)
  local MappedLayout = GetMappedLayout(Layout)
  DebugPrint("[LAYOUT_DBG] ApplyLayoutButtonVisibility: Layout=", Layout, "MappedLayout=", MappedLayout, "CurrentLayout=", self.CurrentLayout)
  if 3 == MappedLayout then
    self.BulletJump:SetTripleActionLocked(ESkillName.BulletJump, self:IsBulletJumpLockedForLayout())
    self:RefreshTripleBulletJumpVisibility()
  elseif MappedLayout >= 2 then
    local isLocked = self:IsBulletJumpLockedForLayout()
    if not isLocked then
      self.BulletJump:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self:SetTouchItemEnabled("BulletJump", true)
    else
      self.BulletJump:SetVisibility(ESlateVisibility.Collapsed)
      self:SetTouchItemEnabled("BulletJump", false)
    end
  else
    self.BulletJump:SetVisibility(ESlateVisibility.Collapsed)
    self:SetTouchItemEnabled("BulletJump", false)
  end
  if 3 == MappedLayout then
    self.BulletJumpLeft:SetVisibility(ESlateVisibility.Collapsed)
    self.SettingDisabledTags.BulletJumpLeft = true
    self:SetTouchItemEnabled("BulletJumpLeft", false)
    self.Jump:SetVisibility(ESlateVisibility.Collapsed)
    self:SetTouchItemEnabled("Jump", false)
  else
    self:SetTouchItemEnabled("BulletJumpLeft", true == self.HasLeftBulletJump)
    local jumpState = self.Jump.CurButtonState
    if not self:IsJumpLockedForLayout() and "InActive" ~= jumpState and "Lock_In" ~= jumpState and nil ~= jumpState then
      self.Jump:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self:SetTouchItemEnabled("Jump", true)
    else
      self.Jump:SetVisibility(ESlateVisibility.Collapsed)
      self:SetTouchItemEnabled("Jump", false)
    end
  end
end

function WBP_Battle_Button_Phone:CloseWithoutAnim()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnim("Out")
end

function WBP_Battle_Button_Phone:InitSkillAfterCharInitReady()
  if not IsValid(self) or IsDedicatedServer(self) then
    return
  end
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(self.OwnerPlayer) then
    return
  end
  self:ForceInit()
  self.SupportSkill:InitSupportSkill()
  self:OnBattlePetInitReady()
  self:InitListenEvent()
end

function WBP_Battle_Button_Phone:InitVariable()
  self.Skill.OwnerPanel = self
  self.Skill.CharSkill_1.OwnerPanel = self
  self.Skill.CharSkill_2.OwnerPanel = self
  self.SkillItems = {
    self.Skill.CharSkill_1,
    self.Skill.CharSkill_2
  }
  self.SupportSkill.OwnerPanel = self
  self.Bullet.OwnerPanel = self
  self.Jump.OwnerPanel = self
  self.AtkRanged.OwnerPanel = self
  self.AtkRangedLeft.OwnerPanel = self
  self.Dodge.OwnerPanel = self
  self.AtkMelee.OwnerPanel = self
  if self.Squat then
    self.Squat.OwnerPanel = self
    self.Squat.OwnerPlayer = self.OwnerPlayer
    self.Squat.Button_Area.OnPressed:Add(self, self.OnSquatPressed)
  end
  if self.Walk then
    self.Walk.OwnerPanel = self
    self.Walk.OwnerPlayer = self.OwnerPlayer
  end
  self.Battle_Menu.OwnerPanel = self
  self.Dodge.OwnerPanel = self
  self.AimLocked.OwnerPanel = self
  self.BulletJump.OwnerPanel = self
  self.BulletJumpLeft.OwnerPanel = self
  self.BulletJumpCancelRight.OwnerPanel = self
  self.BulletJumpCancelLeft.OwnerPanel = self
  self.BulletJumpCancelRight_2.OwnerPanel = self
  self.BulletJumpCancelLeft_2.OwnerPanel = self
  self.Slide.OwnerPanel = self
  self.SlideAttack.OwnerPanel = self
  self.SlidingJump.OwnerPanel = self
  local BattleMainUI_Init = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI_Init and BattleMainUI_Init.LeftAutoBtn then
    local LeftAutoBtn = BattleMainUI_Init.LeftAutoBtn
    LeftAutoBtn.OwnerPanel = self
    if IsValid(LeftAutoBtn.AutoBattle) then
      LeftAutoBtn.AutoBattle.OwnerPanel = self
    end
    if IsValid(LeftAutoBtn.AutoRemote) then
      LeftAutoBtn.AutoRemote.OwnerPanel = self
    end
    if IsValid(LeftAutoBtn.Squat) then
      LeftAutoBtn.Squat.OwnerPanel = self
      LeftAutoBtn.Squat.OwnerPlayer = self.OwnerPlayer
    end
    if IsValid(LeftAutoBtn.Walk) then
      LeftAutoBtn.Walk.OwnerPanel = self
      LeftAutoBtn.Walk.OwnerPlayer = self.OwnerPlayer
    end
    LeftAutoBtn:InitMenuAnchor()
    self.CachedLeftAutoBtn = LeftAutoBtn
    self:RefreshLeftAutoBtnPrologueUnlockState()
  end
  self.Fly.OwnerPanel = self
  self.Fly.OwnerPlayer = self.OwnerPlayer
  self.Fly:RefreshRoleVisible()
  self.SkillButtons = {}
  self.SkillButtons[ESkillName.Attack] = self.AtkMelee
  self.SkillButtons[ESkillName.Jump] = self.Jump
  self.SkillButtons[ESkillName.Slide] = self.Squat
  self.SkillButtons[ESkillName.Skill1] = self.Skill.CharSkill_1
  self.SkillButtons[ESkillName.Skill2] = self.Skill.CharSkill_2
  self.SkillButtons[ESkillName.Skill3] = self.SupportSkill
  self.SkillButtons[ESkillName.Fire] = self.AtkRanged
  self.SkillButtons[ESkillName.ChargeBullet] = self.Bullet
  self.SkillButtons[ESkillName.Avoid] = self.Dodge
  self:AddTimer(0.1, self.UpdateSkillInfoInTimer, true, 0, "UpdateSkillInfoInTimer", false)
  self:AddTimer(0.1, self.UpdateOtherInfoInTimer, true, 0.05, "UpdateOtherInfoInTimer", false)
end

function WBP_Battle_Button_Phone:OnBattlePetInitReady()
  local BattlePet = self.OwnerPlayer:GetBattlePet()
  if not BattlePet or 0 == BattlePet.BattlePetId then
    self:ChangeSkillButtonState(ESkillName.Skill3, "Empty")
    return
  end
  self.SupportSkill:RefreshSupportSkillIcon()
  if not self.OwnerPlayer:CheckSkillInActive(ESkillName.Skill3) then
    self:ChangeSkillButtonState(ESkillName.Skill3, "UnEmpty")
  end
end

function WBP_Battle_Button_Phone:InitMountHUD()
  if not IsValid(self.OwnerPlayer) then
    return
  end
  local IsMounted = self.OwnerPlayer.CurMount ~= nil
  local IsMountFlying = IsMounted and self.OwnerPlayer:IsFlying()
  if IsMounted then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_In)
    self.Fly:SetVisibility(ESlateVisibility.Collapsed)
  else
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
    self.Fly:RefreshRoleVisible()
  end
  self.Jump:SyncMountFlyState()
  self.BulletJump:SyncMountFlyState()
  if IsMountFlying then
    self.Dodge:OnStartMountFly()
  else
    self.Dodge:OnStopMountFly()
  end
end

function WBP_Battle_Button_Phone:DelayAddTouchLayer()
  if self.Jump.Image_Hotspot and not self.IsInitJumpTouch then
    self.IsInitJumpTouch = true
    self:AddStaticSubTouchItem("Jump", self.Jump.Image_Hotspot, {
      Down = self.Jump.ButtonJumpDown,
      Move = self.Jump.ButtonJumpMove,
      Up = self.Jump.ButtonJumpUp
    }, self.Jump)
  end
  if self.AtkRanged.Joystick and not self.IsInitAtkTouch then
    self.IsInitAtkTouch = true
    self:AddMovedSubTouchItem("RangedAttack", self.AtkRanged.Joystick, self.AtkRanged, {
      Down = self.AtkRanged.ButtonFireDown,
      Move = self.AtkRanged.ButtonFireMove,
      Up = self.AtkRanged.ButtonFireUp
    }, {
      Type = "Circle",
      Param = {
        Radius = self.AtkRanged.CircleLimitArea,
        NeedReset = false
      },
      TouchTimes = -1,
      NeedResetPos = true
    })
  end
  if self.BulletJump and self.BulletJumpLeft and not self.IsInitBulletJumpTouch then
    self.IsInitBulletJumpTouch = true
    self:AddStaticSubTouchItem("BulletJump", self.BulletJump.Image_Hotspot, {
      Down = self.BulletJumpDown,
      Move = self.BulletJumpMove,
      Up = self.BulletJumpUp
    }, self.BulletJump)
    self:AddStaticSubTouchItem("BulletJumpLeft", self.BulletJumpLeft.Image_Hotspot, {
      Down = self.LeftBulletJumpDown,
      Move = self.LeftBulletJumpMove,
      Up = self.LeftBulletJumpUp
    }, self.BulletJumpLeft)
    self:SetBulletJumpCancelInfo()
    self.BulletJump.CancelBtn = self.BulletJumpCancelRight
    self.BulletJumpLeft.CancelBtn = self.BulletJumpCancelLeft_2
  end
  local BattleMenu = self.Battle_Menu
  if BattleMenu.Bg and not self.IsInitMenuTouch then
    self.IsInitMenuTouch = true
    self:AddStaticSubTouchItem("BattleMenu", BattleMenu.Bg, {
      Down = BattleMenu.BattleMenuDown,
      Move = BattleMenu.BattleMenuMove,
      Up = BattleMenu.BattleMenuUp
    }, self.Battle_Menu)
  end
  if self.AtkMelee and self.AtkMelee.Joystick and not self.IsInitAtkMeleeTouch then
    self.IsInitAtkMeleeTouch = true
    self:AddStaticSubTouchItem("MeleeAttack", self.AtkMelee.Joystick, {
      Down = self.AtkMelee.ButtonAtkMeleeDown,
      Move = self.AtkMelee.ButtonAtkMeleeMove,
      Up = self.AtkMelee.ButtonAtkMeleeUp
    }, self.AtkMelee)
  end
  if self.Skill.CharSkill_1 and self.Skill.CharSkill_1.Joystick and not self.IsInitSkill1Touch then
    self.IsInitSkill1Touch = true
    self:AddStaticSubTouchItem("Skill1", self.Skill.CharSkill_1.Joystick, {
      Down = self.ButtonSkill1Down,
      Move = self.ButtonSkill1Move,
      Up = self.ButtonSkill1Up
    }, self.Skill)
  end
  if self.Skill.CharSkill_2 and self.Skill.CharSkill_2.Joystick and not self.IsInitSkill2Touch then
    self.IsInitSkill2Touch = true
    self:AddStaticSubTouchItem("Skill2", self.Skill.CharSkill_2.Joystick, {
      Down = self.ButtonSkill2Down,
      Move = self.ButtonSkill2Move,
      Up = self.ButtonSkill2Up
    }, self.Skill)
  end
  if self.IsInitAtkTouch and self.IsInitJumpTouch and self.IsInitMenuTouch and self.IsInitSkill1Touch and self.IsInitSkill2Touch then
    self:RemoveTimer(self.DelayAddTouchLayerTimer)
  end
end

function WBP_Battle_Button_Phone:SetBulletJumpCancelInfo()
  self.BulletJumpCancelRight:InitSlideText()
  self.BulletJumpCancelLeft:InitNormalText()
  self.BulletJumpCancelLeft_2:InitSlideText()
  self.BulletJumpCancelRight_2:InitNormalText()
end

function WBP_Battle_Button_Phone:BulletJumpDown(Index, StartPos)
  self.BulletJump:ButtonBulletJumpDown(Index, StartPos)
  if 3 == GetMappedLayout(self.CurrentLayout) and self.BulletJump and self.BulletJump.IsTripleBulletJumpLocked and self.BulletJump:IsTripleBulletJumpLocked() then
    return
  end
  if not EMCache:Get("AutoBulletJump") then
    if self.BulletJumpCancelShowTimer then
      self:RemoveTimer(self.BulletJumpCancelShowTimer)
      self.BulletJumpCancelShowTimer = nil
    end
    self.BulletJumpCancelShowTimer = self:AddTimer(0.5, function()
      if IsValid(self) then
        if not self.SettingDisabledTags.BulletJumpCancelLeft then
          self.BulletJumpCancelLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if not self.SettingDisabledTags.BulletJumpCancelRight then
          self.BulletJumpCancelRight:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
      end
      self.BulletJumpCancelShowTimer = nil
    end, false)
  end
end

function WBP_Battle_Button_Phone:BulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  self.BulletJump:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:BulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  self.BulletJump:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  if not EMCache:Get("AutoBulletJump") then
    if self.BulletJumpCancelShowTimer then
      self:RemoveTimer(self.BulletJumpCancelShowTimer)
      self.BulletJumpCancelShowTimer = nil
    end
    self.BulletJumpCancelLeft:SetVisibility(ESlateVisibility.Collapsed)
    self.BulletJumpCancelRight:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:LeftBulletJumpDown(Index, StartPos)
  self.BulletJumpLeft:ButtonBulletJumpDown(Index, StartPos)
  if not EMCache:Get("AutoBulletJump") then
    if self.BulletJumpCancelLeft2ShowTimer then
      self:RemoveTimer(self.BulletJumpCancelLeft2ShowTimer)
      self.BulletJumpCancelLeft2ShowTimer = nil
    end
    self.BulletJumpCancelLeft2ShowTimer = self:AddTimer(0.35, function()
      if IsValid(self) then
        if not self.SettingDisabledTags.BulletJumpCancelLeft_2 then
          self.BulletJumpCancelLeft_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
        if not self.SettingDisabledTags.BulletJumpCancelRight_2 then
          self.BulletJumpCancelRight_2:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        end
      end
      self.BulletJumpCancelLeft2ShowTimer = nil
    end, false)
  end
end

function WBP_Battle_Button_Phone:LeftBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  self.BulletJumpLeft:ButtonBulletJumpMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:LeftBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  self.BulletJumpLeft:ButtonBulletJumpUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  if not EMCache:Get("AutoBulletJump") then
    if self.BulletJumpCancelLeft2ShowTimer then
      self:RemoveTimer(self.BulletJumpCancelLeft2ShowTimer)
      self.BulletJumpCancelLeft2ShowTimer = nil
    end
    self.BulletJumpCancelLeft_2:SetVisibility(ESlateVisibility.Collapsed)
    self.BulletJumpCancelRight_2:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:ButtonSkill1Down(Index, StartPos)
  self.Skill.CharSkill_1:ButtonSkillDown(Index, StartPos)
end

function WBP_Battle_Button_Phone:ButtonSkill1Move(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  self.Skill.CharSkill_1:ButtonSkillMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:ButtonSkill1Up(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  self.Skill.CharSkill_1:ButtonSkillUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:ButtonSkill2Down(Index, StartPos)
  self.Skill.CharSkill_2:ButtonSkillDown(Index, StartPos)
end

function WBP_Battle_Button_Phone:ButtonSkill2Move(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  self.Skill.CharSkill_2:ButtonSkillMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:ButtonSkill2Up(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  self.Skill.CharSkill_2:ButtonSkillUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
end

function WBP_Battle_Button_Phone:SetBulletJumpOccupied(IsOccupied, Item)
  if not self.HasLeftBulletJump then
    return
  end
  local OtherItem = Item == self.BulletJump and self.BulletJumpLeft or self.BulletJump
  OtherItem.IsOccupied = IsOccupied
  if self.IsFolded and OtherItem == self.BulletJumpLeft then
    return
  end
  if IsOccupied then
    OtherItem:InActiveBulletJump("IsOccupied")
  else
    OtherItem:ActiveBulletJump("IsOccupied")
  end
end

function WBP_Battle_Button_Phone:OtherActionCancelBulletJump(InAction)
  if CommonUtils.HasValue(self.NoCancelBulletJumpActions, InAction) then
    return
  end
  self:CancelBulletJump()
end

function WBP_Battle_Button_Phone:CancelBulletJump()
  if self.SuppressBulletJumpSelfCancel then
    return
  end
  if not self.HasLeftBulletJump then
    DebugPrint("[CancelBulletJump] calling BulletJumpUp, BulletJump.OwnerPanel=", self.BulletJump.OwnerPanel ~= nil)
    self:BulletJumpUp()
    return
  end
  if self.BulletJump.IsOccupied then
    self:LeftBulletJumpUp()
  elseif self.BulletJumpLeft.IsOccupied then
    self:BulletJumpUp()
  end
end

local StopCommandKeys = {
  Skill1 = true,
  Skill2 = true,
  Skill3 = true,
  Slide = true,
  Attack = true,
  Fire = true,
  Jump = true,
  BulletJump = true,
  SwitchCrouch = true,
  SwitchWalk = true
}

function WBP_Battle_Button_Phone:TryToPlayTargetCommand(KeyName, IsAddInputCache)
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if self.OwnerPlayer:CheckForbidTags(KeyName) then
    return
  end
  if IsAddInputCache then
    self.OwnerPlayer:SetInputCache(KeyName)
  end
  if not self.OwnerPlayer.InitSuccess then
    return
  end
  self:OtherActionCancelBulletJump(KeyName)
  self.OwnerPlayer:ActionCallback(KeyName, EInputEvent.IE_Pressed)
  if "Attack" == KeyName then
    self:OnFoldAttackPressed()
  elseif "Fire" == KeyName then
    self:OnFoldFirePressed()
  end
end

function WBP_Battle_Button_Phone:TryToStopTargetCommand(KeyName, IsClearInputCache)
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if IsClearInputCache then
    self.OwnerPlayer:RemoveInputCache(KeyName)
  end
  if self.OwnerPlayer:CheckForbidTags(KeyName) then
    self.OwnerPlayer:ResetAttackProperty(KeyName)
    return
  end
  if not self.OwnerPlayer.InitSuccess then
    return
  end
  if not StopCommandKeys[KeyName] then
    return
  end
  self.OwnerPlayer:ActionCallback(KeyName, EInputEvent.IE_Released)
end

function WBP_Battle_Button_Phone:GetSkillActiveInfo()
  local PlayerController
  if self.OwnerPlayer and self.OwnerPlayer.GetController then
    PlayerController = self.OwnerPlayer:GetController()
  end
  if PlayerController then
    local len = PlayerController.CurrentInActiveSkills:Length()
    local TempButtons = self.SkillButtons
    for i = 1, len do
      self:ChangeSkillButtonState(PlayerController.CurrentInActiveSkills[i], "Lock")
      TempButtons[PlayerController.CurrentInActiveSkills[i]] = nil
    end
    for Id, _ in pairs(TempButtons) do
      self:ChangeSkillButtonState(Id, "UnLock")
    end
    self:ChangeBattleWheelState(PlayerController.bEnableBattleWheel, PlayerController.bShowBattleWheel)
  end
end

function WBP_Battle_Button_Phone:ChangeBattleWheelState(bEnable, bShow)
  DebugPrint("gmy@WBP_Battle_Button_Phone:ChangeBattleWheelState", bEnable)
  self.Battle_Menu.IsBan = not bEnable
  if not bEnable then
    self.Battle_Menu:StopAnimation(self.Battle_Menu.Normal)
    self.Battle_Menu:PlayAnimationForward(self.Battle_Menu.Ban)
  else
    self.Battle_Menu:StopAnimation(self.Battle_Menu.Ban)
    self.Battle_Menu:PlayAnimationForward(self.Battle_Menu.Normal)
  end
  if self.BattleMenuUnlocked and bShow then
    self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
  else
    self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:ChangeSkillButtonState(SkillName, StateName)
  self:CacheTripleBulletJumpLockState(SkillName, StateName)
  if self:TryApplyTripleBulletJumpLockState(SkillName, StateName) then
    return
  end
  if "Empty" == StateName then
    if SkillName == ESkillName.Skill1 then
      self.SkillItems[1].CurButtonState = "Empty"
      self.SkillItems[1].Switcher:SetActiveWidgetIndex(1)
      self.SkillItems[1].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 0.3))
    elseif SkillName == ESkillName.Skill2 then
      self.SkillItems[2].CurButtonState = "Empty"
      self.SkillItems[2].Switcher:SetActiveWidgetIndex(1)
      self.SkillItems[2].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 0.3))
    elseif SkillName == ESkillName.Skill3 then
      self.SupportSkill.CurButtonState = "Empty"
      self.SupportSkill.Switcher:SetActiveWidgetIndex(1)
      self.SupportSkill.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 0.3))
    elseif SkillName == ESkillName.Fire then
      self.AtkRanged.CurButtonState = "Empty"
      self.Bullet.CurButtonState = "Empty"
      self.AtkRanged:UpdateRangeWeaponButton()
      self.Bullet:SetVisibility(ESlateVisibility.Collapsed)
    elseif SkillName == ESkillName.SwitchWalk and self.Walk then
      self.Walk:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  elseif "UnEmpty" == StateName then
    if SkillName == ESkillName.Skill1 then
      self.SkillItems[1].CurButtonState = "Normal"
      self.SkillItems[1].Switcher:SetActiveWidgetIndex(0)
      self.SkillItems[1].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 1))
    elseif SkillName == ESkillName.Skill2 then
      self.SkillItems[2].CurButtonState = "Normal"
      self.SkillItems[2].Switcher:SetActiveWidgetIndex(0)
      self.SkillItems[2].Bg_Skill:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 1))
    elseif SkillName == ESkillName.Skill3 then
      self.SupportSkill.CurButtonState = "Normal"
      self.SupportSkill.Switcher:SetActiveWidgetIndex(0)
      self.SupportSkill.Bg:SetBrushTintColor(UE4.UUIFunctionLibrary.GetSlateColorByRGBA(1, 1, 1, 1))
    elseif SkillName == ESkillName.Fire then
      self.AtkRanged.CurButtonState = "Normal"
      self.Bullet.CurButtonState = "Normal"
      self.AtkRanged:UpdateRangeWeaponButton()
      self.Bullet:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    elseif SkillName == ESkillName.SwitchWalk and self.Walk then
      self.Walk:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  if "UnLock" == StateName then
    if SkillName == ESkillName.Attack then
      self.AtkMelee:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      if self:CheckHasExtraSlideAttack() then
        self.SlideAttack:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      else
        self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self.Jump:OnSkillActive(SkillName)
      end
    elseif SkillName == ESkillName.Jump then
      self.Jump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.Jump.CurButtonState = "Active"
      self:SetTouchItemEnabled("Jump", true)
    elseif SkillName == ESkillName.Slide then
      if self.Squat then
        self.Squat:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      end
      if self:CheckHasExtraSlide() then
        self.Slide:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      else
        self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
        if not self.OwnerPlayer or not self.OwnerPlayer.CurMount then
          self.Jump:OnSkillActive(SkillName)
        end
      end
    elseif SkillName == ESkillName.Skill1 then
      self.Skill:PlayAnimationForward(self.Skill.In)
      if self.SkillItems[1].CurButtonState == "Lock_In" then
        self.SkillItems[1].SkillInfo.NeedUnlock = true
      end
    elseif SkillName == ESkillName.Skill2 then
      if self.SkillItems[2].CurButtonState == "Lock_In" then
        self.SkillItems[2].SkillInfo.NeedUnlock = true
      end
    elseif SkillName == ESkillName.Skill3 then
      self:SetVisibleByFoldState(self.SupportSkill, UE4.ESlateVisibility.SelfHitTestInvisible)
      if not self.IsFolded then
        self.SupportSkill:PlayAnimationForward(self.SupportSkill.In)
      end
    elseif SkillName == ESkillName.Fire then
      self:SetVisibleByFoldState(self.AtkRanged, UE4.ESlateVisibility.SelfHitTestInvisible)
      if not self.SettingDisabledTags.AtkRangedLeft then
        self:SetVisibleByFoldState(self.AtkRangedLeft, UE4.ESlateVisibility.SelfHitTestInvisible)
      end
      self:SetVisibleByFoldState(self.Bullet, UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif SkillName == ESkillName.Avoid then
      self.Dodge:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    elseif SkillName == ESkillName.BulletJump then
      if self:GetCurrentMappedLayout() >= 2 then
        self.BulletJump:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
        self:SetTouchItemEnabled("BulletJump", true)
      else
        self.BulletJump:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:SetTouchItemEnabled("BulletJump", false)
      end
      self.BulletJumpLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Jump:OnSkillActive(SkillName)
    elseif SkillName == ESkillName.SwitchWalk and self.Walk then
      self.Walk:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  elseif "Lock" == StateName then
    if SkillName == ESkillName.Attack then
      self.AtkMelee:SetVisibility(UE4.ESlateVisibility.Collapsed)
      if self:CheckHasExtraSlideAttack() then
        self.SlideAttack:SetVisibility(UE4.ESlateVisibility.Collapsed)
      else
        self.Jump:OnSkillInActive(SkillName)
      end
    elseif SkillName == ESkillName.Jump then
      self.Jump:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Jump.CurButtonState = "InActive"
      self:SetTouchItemEnabled("Jump", false)
    elseif SkillName == ESkillName.Slide then
      if self.Squat then
        self.Squat:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
      if self:CheckHasExtraSlide() then
        self.Slide:SetVisibility(UE4.ESlateVisibility.Collapsed)
      elseif not self.OwnerPlayer or not self.OwnerPlayer.CurMount then
        self.Jump:OnSkillActive(SkillName)
      end
    elseif SkillName == ESkillName.Skill1 then
      self.SkillItems[1].CurButtonState = "Lock_In"
      self.SkillItems[1]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill2 then
      self.SkillItems[2].CurButtonState = "Lock_In"
      self.SkillItems[2]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill3 then
      self.SupportSkill:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif SkillName == ESkillName.Fire then
      self.AtkRanged:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.AtkRangedLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Bullet:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif SkillName == ESkillName.Avoid then
      self.Dodge:SetVisibility(UE4.ESlateVisibility.Collapsed)
    elseif SkillName == ESkillName.BulletJump then
      self.BulletJump:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self:SetTouchItemEnabled("BulletJump", false)
      self.BulletJumpLeft:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Jump:OnSkillInActive(SkillName)
    elseif SkillName == ESkillName.SwitchWalk and self.Walk then
      self.Walk:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  elseif "Ban" == StateName then
    if SkillName == ESkillName.Attack then
      self.AtkMelee.IsBan = true
      self.AtkMelee:PlayAnimationForward(self.AtkMelee.Ban)
    elseif SkillName == ESkillName.Jump then
      self.Jump:PlayAnimationForward(self.Jump.Ban)
      self.Jump.CurButtonState = "InActive"
    elseif SkillName == ESkillName.Slide then
      if self.Squat then
        self.Squat:PlayAnimationForward(self.Squat.Ban)
      end
    elseif SkillName == ESkillName.Skill1 then
      self.SkillItems[1].CurButtonState = "Ban"
      self.SkillItems[1]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill2 then
      self.SkillItems[2].CurButtonState = "Ban"
      self.SkillItems[2]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill3 then
      self.SupportSkill.CurButtonState = "Ban"
      self.SupportSkill:PlayAnimationForward(self.SupportSkill.Ban)
    elseif SkillName == ESkillName.Fire then
      self.AtkRanged.CurButtonState = "Ban"
      EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.Ban)
      EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRangedLeft, self.AtkRangedLeft.Ban)
      self.Bullet.CurButtonState = "Ban"
      self.Bullet:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Avoid then
      self.Dodge:PlayAnimationForward(self.Dodge.Ban)
      if self:CheckHasBulletJumpButton() then
        self.BulletJump:InActiveBulletJump()
      end
      if self.HasLeftBulletJump then
        self.BulletJumpLeft:InActiveBulletJump()
      end
    end
  elseif "UnBan" == StateName then
    if SkillName == ESkillName.Attack then
      self.AtkMelee.IsBan = false
      self.AtkMelee:PlayAnimationForward(self.AtkMelee.Normal)
    elseif SkillName == ESkillName.Jump then
      self.Jump:PlayAnimationForward(self.Jump.Normal)
      self.Jump.CurButtonState = "Active"
    elseif SkillName == ESkillName.Slide then
      if self.Squat then
        self.Squat:PlayAnimationForward(self.Squat.Normal)
      end
    elseif SkillName == ESkillName.Skill1 then
      self.SkillItems[1].CurButtonState = "Normal"
      self.SkillItems[1]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill2 then
      self.SkillItems[2].CurButtonState = "Normal"
      self.SkillItems[2]:PlayButtonStateAnimation()
    elseif SkillName == ESkillName.Skill3 then
      self.SupportSkill.CurButtonState = "Normal"
      self.SupportSkill:PlayAnimationForward(self.SupportSkill.Normal)
    elseif SkillName == ESkillName.Fire then
      self.AtkRanged.CurButtonState = nil
      self.AtkRanged:PlayAnimationForward(self.AtkRanged.Normal)
      self.AtkRangedLeft.CurButtonState = nil
      EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRangedLeft, self.AtkRangedLeft.Normal)
      self.Bullet:PlayAnimationForward(self.Bullet.Normal)
    elseif SkillName == ESkillName.Avoid then
      self.Dodge:PlayAnimationForward(self.Dodge.Normal)
      if self:CheckHasBulletJumpButton() then
        self.BulletJump:ActiveBulletJump()
      end
      if self.HasLeftBulletJump then
        self.BulletJumpLeft:ActiveBulletJump()
      end
    end
  elseif "Hooking" == StateName or "RegionBan" == StateName then
    if self.SkillButtons[SkillName] and not self.IsFolded then
      self.SkillButtons[SkillName]:SetRenderOpacity(0.5)
    end
  elseif ("EndHooking" == StateName or "RegionUnBan" == StateName) and self.SkillButtons[SkillName] and not self.IsFolded then
    self.SkillButtons[SkillName]:SetRenderOpacity(1)
  end
end

function WBP_Battle_Button_Phone:RefreshWeaponInfo()
  self.Bullet:UpdateBulletType()
  self.Bullet:UpdatePlayerWeaponInfo()
  self:RefreshUltimateAttackGuide()
  self.AtkRanged:UpdateWeaponIcon()
end

function WBP_Battle_Button_Phone:RefreshUltimateAttackGuide()
  local State = UltimateAttackGuideHelper:GetUltimateAttackGuideState(self.OwnerPlayer)
  local IsUltraActive = UltimateAttackGuideHelper:IsUltimateActive(self.OwnerPlayer)
  local WasUltraActive = self.IsUltraActive == true
  self.IsUltraActive = IsUltraActive
  if IsUltraActive and not WasUltraActive then
    self:StopFoldTimer()
    if self.IsFolded then
      self:ExitFoldState()
    end
  elseif not IsUltraActive and WasUltraActive then
    self:TryStartFoldTimer()
  end
  if State.IsType1 then
    self.AtkRanged:EnterUltimateBan()
  else
    self.AtkRanged:ExitUltimateBan()
  end
  local RangedNeedsEnable2 = State.IsType2 and State.MainAttackType == "Ranged"
  self.AtkRanged:OnUltimateStateChanged(RangedNeedsEnable2, false)
  local LeftRangedNeedsEnable = State.IsType1 or State.IsType2 and State.MainAttackType == "Ranged"
  self.AtkRangedLeft:OnUltimateStateChanged(LeftRangedNeedsEnable, State.IsType1)
  local MeleeNeedsEnable = State.IsType1 or State.IsType2 and State.MainAttackType == "Melee"
  self.AtkMelee:OnUltimateStateChanged(MeleeNeedsEnable, State.IsType1)
  if State.IsType1 and State.ReplaceMobileAttackButtonIcon then
    self.AtkMelee:LoadUltimateIcon(self.OwnerPlayer)
    self.AtkRangedLeft:LoadUltimateIcon(self.OwnerPlayer)
  else
    self.AtkMelee:RestoreDefaultIcon()
    self.AtkRangedLeft:RestoreDefaultIcon()
  end
  self.SkillItems[2]:OnUltimateStateChanged(State.MainAttackType ~= nil)
end

function WBP_Battle_Button_Phone:RefreshRoleTargetSkill(SkillName)
  if "Skill1" == SkillName then
    self.SkillItems[1]:RefreshButtonStyle()
  elseif "Skill2" == SkillName then
    self.SkillItems[2]:RefreshButtonStyle()
  elseif "Support" == SkillName then
    self.SupportSkill:RefreshButtonStyle()
  end
end

function WBP_Battle_Button_Phone:RefreshRoleSkillButton()
  self.SkillItems[1]:RefreshButtonStyle()
  self.SkillItems[2]:RefreshButtonStyle()
  self.SupportSkill:RefreshButtonStyle()
end

function WBP_Battle_Button_Phone:OnSkillInfosRep(Character)
  if not self.OwnerPlayer or self.OwnerPlayer ~= Character then
    return
  end
  self:RefreshRoleSkillButton()
end

function WBP_Battle_Button_Phone:UpdateSkillInfoInTimer()
  if IsValid(self.OwnerPlayer) and not self.OwnerPlayer.IsUpdatedUIInThisTick then
    self.Skill:UpdateSkillInTimer()
    if self.Squat then
      self.Squat:UpdateButtonInTimer()
    end
    if self.Walk then
      self.Walk:UpdateButtonInTimer()
    end
    local Lab = self.CachedLeftAutoBtn
    if Lab then
      if IsValid(Lab.Squat) then
        Lab.Squat:UpdateButtonInTimer()
      end
      if IsValid(Lab.Walk) then
        Lab.Walk:UpdateButtonInTimer()
      end
    end
    self.Dodge:UpdateButtonInTimer()
    self.Fly:UpdateButtonInTimer()
    self.IsCharacterInFalling = self.OwnerPlayer:CharacterInTag("Falling")
    self.OwnerPlayer.IsUpdatedUIInThisTick = true
  end
end

function WBP_Battle_Button_Phone:UpdateOtherInfoInTimer()
  if IsValid(self.OwnerPlayer) and not self.OwnerPlayer.IsUpdatedOtherUIInThisTick then
    self.SupportSkill:UpdateSkillInTimer()
    self.Bullet:UpdateButtonInTimer()
    if self.AtkRanged and self.AtkRanged.UpdateButtonInTimer then
      self.AtkRanged:UpdateButtonInTimer()
    end
    if self:CheckHasBulletJumpButton() and (not self.IsFolded or GetMappedLayout(self.CurrentLayout) >= 2) then
      self.BulletJump:UpdateButtonInTimer()
    end
    if self.HasLeftBulletJump and not self.IsFolded then
      self.BulletJumpLeft:UpdateButtonInTimer()
    end
    self:RefreshFoldStateByJetFlyState()
    self.OwnerPlayer.IsUpdatedOtherUIInThisTick = true
  end
end

function WBP_Battle_Button_Phone:OnUpdateCharSp(NowSp, OldSp, Owner)
  self.Skill:OnUpdateCharSp(NowSp, OldSp, Owner)
end

function WBP_Battle_Button_Phone:OnUpdateMaxSp(NewMaxSp)
  self.Skill:OnUpdateMaxSp(NewMaxSp)
end

function WBP_Battle_Button_Phone:OnUpdateSkillEfficiency(Owner)
  for i = 1, 2 do
    self.SkillItems[i]:OnRefreshSkillSpCost(Owner)
  end
end

function WBP_Battle_Button_Phone:OnUpdateBuffSpModify()
  for i = 1, 2 do
    self.SkillItems[i]:OnUpdateBuffSpModify()
  end
end

function WBP_Battle_Button_Phone:OnSwitchRole()
  if self.OwnerPlayer then
    self:OnUpdateCharSp(nil, nil, self.OwnerPlayer)
    self:RefreshRoleSkillButton()
    self:RefreshWeaponInfo()
    self.Fly.OwnerPlayer = self.OwnerPlayer
    self.Fly:RefreshRoleVisible()
  end
end

function WBP_Battle_Button_Phone:OnSwitchPet()
  self.SupportSkill:RefreshSupportSkillIcon()
end

function WBP_Battle_Button_Phone:TryToEnterReloadState()
  self.Bullet:TryToEnterReloadState()
end

function WBP_Battle_Button_Phone:OnSkill1InAirChanged(IsInAir)
  self.Skill.CharSkill_1:ChangeIsInAir(IsInAir)
end

function WBP_Battle_Button_Phone:OnSkill2InAirChanged(IsInAir)
  self.Skill.CharSkill_2:ChangeIsInAir(IsInAir)
end

function WBP_Battle_Button_Phone:OnLockOnButtonShowChanged(IsLooking, IsShow)
  self.AimLocked:OnLockOnButtonShowChanged(IsLooking, IsShow)
end

function WBP_Battle_Button_Phone:OnCameraLockOnChanged(IsLooking)
  self.AimLocked:OnCameraLockOnChanged(IsLooking)
end

function WBP_Battle_Button_Phone:ExecuteCheckIsSkillInUsing(Skill)
  if Skill.CombatConditionID then
    local TraceInfo = "From WBP_Battle_Button_Phone:ExecuteCheckIsSkillInUsing"
    return Battle(self):CheckConditionNew(Skill.CombatConditionID, self.OwnerPlayer, nil, TraceInfo)
  end
  return false
end

function WBP_Battle_Button_Phone:InitUnlockInfo()
  local UIUnlockRule = DataMgr.UIUnlockRule
  self:InitButtonUnlockState(UIUnlockRule.BattleWheel.UIUnlockRuleId, function()
    self.BattleMenuUnlocked = true
    self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
  end, function()
    self.BattleMenuUnlocked = false
    self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end, function()
    self.BattleMenuUnlocked = true
    self.Battle_Menu:SetVisibility(UE4.ESlateVisibility.Visible)
  end)
  self.Execute:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Battle_Button_Phone:InitButtonUnlockState(UIUnlockRuleId, UnlockingCallback, LockingCallback, FirstTimeUnlockCallback)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  if FirstTimeUnlockCallback then
    self.UnlockEvents = self.UnlockEvents or {}
    self.UnlockEvents[UIUnlockRuleId] = Avatar:BindOnUIFirstTimeUnlock(UIUnlockRuleId, FirstTimeUnlockCallback)
  end
  local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
  DebugPrint("gmy@InitButtonUnlockState Unlocked", bUnlocked)
  if bUnlocked then
    if UnlockingCallback then
      UnlockingCallback()
    end
  elseif LockingCallback then
    LockingCallback()
  end
end

function WBP_Battle_Button_Phone:OnPropEffectReplaceSkill(SkillName, PropEffectId)
  if SkillName == ESkillName.Attack or SkillName == ESkillName.HeavyAttack then
    self.AtkMelee:OnPropEffectReplaceAttack(PropEffectId)
  elseif SkillName == ESkillName.Fire or SkillName == ESkillName.HeavyShooting then
    self.AtkRanged:OnPropEffectReplaceFire(PropEffectId)
    self.SupportSkill:OnPropEffectReplaceSupport(PropEffectId)
  end
end

function WBP_Battle_Button_Phone:OnPropEffectEndReplaceSkill(SkillName)
  if SkillName == ESkillName.Attack or SkillName == ESkillName.HeavyAttack then
    self.AtkMelee:OnPropEffectEndReplaceAttack()
  elseif SkillName == ESkillName.Fire or SkillName == ESkillName.HeavyShooting then
    self.AtkRanged:OnPropEffectEndReplaceFire()
    self.SupportSkill:OnPropEffectEndReplaceSupport()
  end
end

function WBP_Battle_Button_Phone:OnEnableBattleMount(Character)
  if not Character:IsMainPlayer() then
    return
  end
  self:StopDismountFoldRetryTimer()
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_In)
  self.Jump:OnEnableBattleMount()
  self.BulletJump:OnEnableBattleMount()
  self.Fly:SetVisibility(ESlateVisibility.Collapsed)
  self:ForceExitFoldStateNoRestart()
end

function WBP_Battle_Button_Phone:OnDisableBattleMount(Character)
  if not Character:IsMainPlayer() then
    return
  end
  EMUIAnimationSubsystem:EMPlayAnimation(self, self.Mounts_Out)
  self.Jump:OnDisableBattleMount()
  self.BulletJump:OnDisableBattleMount()
  self.Fly:RefreshRoleVisible()
  self:RetryStartFoldTimerUntilDismounted()
end

function WBP_Battle_Button_Phone:RetryStartFoldTimerUntilDismounted()
  self:StopDismountFoldRetryTimer()
  if not self:IsInMountState() then
    self:TryStartFoldTimer()
    return
  end
  self.DismountFoldRetryTimer = self:AddTimer(0.2, function()
    self.DismountFoldRetryTimer = nil
    self:RetryStartFoldTimerUntilDismounted()
  end, false)
end

function WBP_Battle_Button_Phone:StopDismountFoldRetryTimer()
  if self.DismountFoldRetryTimer then
    self:RemoveTimer(self.DismountFoldRetryTimer)
    self.DismountFoldRetryTimer = nil
  end
end

function WBP_Battle_Button_Phone:OnStartMountFly()
  self.Dodge:OnStartMountFly()
  self.Jump:OnStartMountFly()
  self.BulletJump:OnStartMountFly()
  self.Fly:OnStartMountFly()
end

function WBP_Battle_Button_Phone:OnStopMountFly()
  self.Dodge:OnStopMountFly()
  self.Jump:OnStopMountFly()
  self.BulletJump:OnStopMountFly()
  self.Fly:OnStopMountFly()
end

function WBP_Battle_Button_Phone:OnSquatPressed()
  if self.Fly and self.Fly:CheckIsSkillFlying() then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_Mechanism_CannotHook"))
  end
end

function WBP_Battle_Button_Phone:OnEnterSkillFly()
  if self.Squat then
    self.Squat:PlayAnimationForward(self.Squat.Foridden)
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI and BattleMainUI.Char_Skill and BattleMainUI.Char_Skill.HookLock then
    BattleMainUI.Char_Skill.HookLock:SetRenderOpacity(0.3)
  end
  self:StopFoldTimer()
  if self.IsFolded then
    self:ExitFoldState()
  end
end

function WBP_Battle_Button_Phone:OnExitSkillFly()
  if self.Squat then
    self.Squat:PlayAnimationForward(self.Squat.Normal)
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI and BattleMainUI.Char_Skill and BattleMainUI.Char_Skill.HookLock then
    BattleMainUI.Char_Skill.HookLock:SetRenderOpacity(1)
  end
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:Destruct()
  self.Super.Destruct(self)
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  if self.UnlockEvents then
    for UIUnlockRuleId, UnlockEventKey in pairs(self.UnlockEvents) do
      Avatar:UnBindOnUIFirstTimeUnlock(UIUnlockRuleId, UnlockEventKey)
    end
  end
  self:RemoveTouchListenEvent()
end

function WBP_Battle_Button_Phone:ShowAtkMeleeForbidTips()
  UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_MELEE_FORBIDDEN"))
end

function WBP_Battle_Button_Phone:OnMobileHookShow(Hook)
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if BattleMainUI.Char_Skill.Execute.IsShow then
    BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(0)
    return
  end
  BattleMainUI.Char_Skill.Switch_Type:SetActiveWidgetIndex(1)
  Hook.InteractiveUI = BattleMainUI.Char_Skill.HookLock
  Hook.InteractiveUI:Init(Hook)
end

function WBP_Battle_Button_Phone:OnRecordButtonOptionChanged(bShow)
  local RecordNode = self.RecordPos or self.Record
  if bShow then
    RecordNode:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    RecordNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_Button_Phone:OnAutoAttackEnabledChanged(Player, bEnabled, bIsAutoOff)
  if bEnabled then
    self:ChangeSkillButtonState(ESkillName.Attack, "Ban")
  else
    self:ChangeSkillButtonState(ESkillName.Attack, "UnBan")
  end
  self:RefreshFoldStateByAutoCombatState()
  if not bIsAutoOff then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_HUDToast_AutoMelee"))
  end
end

function WBP_Battle_Button_Phone:OnAutoShootEnabledChanged(Player, bEnabled, bIsAutoOff)
  if bEnabled then
    self.AtkRanged.CurButtonState = "Ban"
    EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.Ban)
    if self.HasLeftShoot then
      self.AtkRangedLeft:SetVisibility(ESlateVisibility.Collapsed)
    end
  else
    self.AtkRanged.CurButtonState = nil
    self.AtkRanged:UpdateRangeWeaponButton()
    if self.AtkRanged.IsUltimateEnabled and self.AtkRanged.CurrentUltimateAnim then
      self.AtkRanged:StopAllAnimations()
      EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.Normal)
      EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.CurrentUltimateAnim)
    end
    if self.HasLeftShoot and not self.SettingDisabledTags.AtkRangedLeft then
      self.AtkRangedLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
  self:RefreshFoldStateByAutoCombatState()
  if not bIsAutoOff then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_HUDToast_AutoShot"))
  end
end

function WBP_Battle_Button_Phone:SyncAutoCombatVisual()
  local Player = self.OwnerPlayer
  if not IsValid(Player) then
    return
  end
  local bAutoAttack = Player:IsAutoAttackEnabled()
  DebugPrint("[SyncAutoCombatVisual] bAutoAttack=", bAutoAttack, "bAutoShoot=", Player:IsAutoShootEnabled())
  local BattleMainUI_Sync = UIManager(self):GetUIObj("BattleMain")
  local LeftAutoBtn = BattleMainUI_Sync and BattleMainUI_Sync.LeftAutoBtn
  if LeftAutoBtn and IsValid(LeftAutoBtn.AutoBattle) then
    LeftAutoBtn.AutoBattle.IsAutoAttackOn = bAutoAttack
    if bAutoAttack then
      EMUIAnimationSubsystem:EMPlayAnimation(LeftAutoBtn.AutoBattle, LeftAutoBtn.AutoBattle.Press)
    else
      EMUIAnimationSubsystem:EMPlayAnimation(LeftAutoBtn.AutoBattle, LeftAutoBtn.AutoBattle.Normal)
    end
  end
  if bAutoAttack then
    self:ChangeSkillButtonState(ESkillName.Attack, "Ban")
  else
    self:ChangeSkillButtonState(ESkillName.Attack, "UnBan")
  end
  local bAutoShoot = Player:IsAutoShootEnabled()
  if LeftAutoBtn and IsValid(LeftAutoBtn.AutoRemote) then
    LeftAutoBtn.AutoRemote.IsAutoShootOn = bAutoShoot
    if bAutoShoot then
      EMUIAnimationSubsystem:EMPlayAnimation(LeftAutoBtn.AutoRemote, LeftAutoBtn.AutoRemote.Press)
    else
      EMUIAnimationSubsystem:EMPlayAnimation(LeftAutoBtn.AutoRemote, LeftAutoBtn.AutoRemote.Normal)
    end
  end
  if bAutoShoot then
    self.AtkRanged.CurButtonState = "Ban"
    EMUIAnimationSubsystem:EMPlayAnimation(self.AtkRanged, self.AtkRanged.Ban)
    if self.HasLeftShoot then
      self.AtkRangedLeft:SetVisibility(ESlateVisibility.Collapsed)
    end
  else
    self.AtkRanged.CurButtonState = nil
    self.AtkRanged:UpdateRangeWeaponButton()
    if self.HasLeftShoot and not self.SettingDisabledTags.AtkRangedLeft then
      self.AtkRangedLeft:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
end

function WBP_Battle_Button_Phone:IsInBigWorldRegion()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  return Avatar:IsInBigWorld() and nil ~= GameState and nil ~= GameState.IsInRegion and GameState:IsInRegion()
end

function WBP_Battle_Button_Phone:IsInMountState()
  return self.OwnerPlayer ~= nil and nil ~= self.OwnerPlayer.CurMount
end

function WBP_Battle_Button_Phone:ForceExitFoldStateNoRestart()
  self:StopFoldTimer()
  if self.IsFolded then
    self.IsFolded = false
    EMUIAnimationSubsystem:EMPlayAnimation(self, self:GetFoldAnim(), EUMGSequencePlayMode.Reverse)
  end
  self:RestoreFoldHitBlock()
end

function WBP_Battle_Button_Phone:IsFoldFeatureUnlocked()
  if self.bFoldFeatureUnlocked then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsQuestFinished(FOLD_FEATURE_UNLOCK_QUEST_ID) then
    self.bFoldFeatureUnlocked = true
  end
  return self.bFoldFeatureUnlocked == true
end

function WBP_Battle_Button_Phone:IsLeftAutoBtnUnlocked()
  if self.bLeftAutoBtnUnlocked then
    return true
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsQuestFinished(LEFT_AUTO_BTN_UNLOCK_QUEST_ID) then
    self.bLeftAutoBtnUnlocked = true
  end
  return self.bLeftAutoBtnUnlocked == true
end

function WBP_Battle_Button_Phone:GetLeftAutoBtn()
  if IsValid(self.CachedLeftAutoBtn) then
    return self.CachedLeftAutoBtn
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  self.CachedLeftAutoBtn = BattleMainUI and BattleMainUI.LeftAutoBtn or nil
  return self.CachedLeftAutoBtn
end

function WBP_Battle_Button_Phone:SetLeftAutoBtnVisibility(Visibility)
  local LeftAutoBtn = self:GetLeftAutoBtn()
  if not LeftAutoBtn then
    return
  end
  LeftAutoBtn:SetVisibility(Visibility)
  if IsValid(LeftAutoBtn.AutoBattle) then
    LeftAutoBtn.AutoBattle:SetVisibility(Visibility)
  end
  if IsValid(LeftAutoBtn.AutoRemote) then
    LeftAutoBtn.AutoRemote:SetVisibility(Visibility)
  end
end

function WBP_Battle_Button_Phone:RefreshLeftAutoBtnPrologueUnlockState()
  local Visibility = self:IsLeftAutoBtnUnlocked() and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self:SetLeftAutoBtnVisibility(Visibility)
end

function WBP_Battle_Button_Phone:OnQuestFinished(QuestId)
  if QuestId == FOLD_FEATURE_UNLOCK_QUEST_ID then
    self.bFoldFeatureUnlocked = true
    self:TryStartFoldTimer()
  end
  if QuestId == LEFT_AUTO_BTN_UNLOCK_QUEST_ID then
    self.bLeftAutoBtnUnlocked = true
    self:RefreshLeftAutoBtnPrologueUnlockState()
  end
end

function WBP_Battle_Button_Phone:IsInJetFlyState()
  local Player = self.OwnerPlayer
  if not IsValid(Player) then
    return false
  end
  if Player.bInJetRush == true or true == Player.bInJetState then
    return true
  end
  if Player.IsInJetState and Player:IsInJetState() then
    return true
  end
  return false
end

function WBP_Battle_Button_Phone:IsAutoAttackFoldBlocked()
  local Player = self.OwnerPlayer
  return IsValid(Player) and Player.IsAutoAttackEnabled and Player:IsAutoAttackEnabled() == true
end

function WBP_Battle_Button_Phone:IsAutoShootFoldBlocked()
  local Player = self.OwnerPlayer
  return IsValid(Player) and Player.IsAutoShootEnabled and Player:IsAutoShootEnabled() == true
end

function WBP_Battle_Button_Phone:IsAutoCombatFoldBlocked()
  return self:IsAutoAttackFoldBlocked() or self:IsAutoShootFoldBlocked()
end

function WBP_Battle_Button_Phone:RefreshFoldStateByAutoCombatState()
  if self:IsAutoCombatFoldBlocked() then
    self:StopFoldTimer()
    if self.IsFolded then
      self:ExitFoldState()
    end
    return
  end
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:RefreshFoldStateByJetFlyState()
  local bInJetFly = self:IsInJetFlyState()
  if bInJetFly == self.bFoldBlockedByJetFly then
    return
  end
  self.bFoldBlockedByJetFly = bInJetFly
  if bInJetFly then
    self:StopFoldTimer()
    if self.IsFolded then
      self:ExitFoldState()
    end
    return
  end
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:RefreshFoldStateBySpecialQuestState()
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.InSpecialQuest then
    self:ForceExitFoldStateNoRestart()
    return
  end
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:CanEnterFoldState()
  if self:IsInMountState() then
    DebugPrint("[Fold] CanEnter=false: in Mount")
    self:ForceExitFoldStateNoRestart()
  end
  if not self.OwnerPlayer then
    DebugPrint("[Fold] CanEnter=false: no OwnerPlayer")
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar.InSpecialQuest then
    DebugPrint("[Fold] CanEnter=false: in SpecialQuest")
    self:ForceExitFoldStateNoRestart()
    return false
  end
  if not self:IsFoldFeatureUnlocked() then
    DebugPrint("[Fold] CanEnter=false: newbie guide not finished")
    return false
  end
  if not self:IsInBigWorldRegion() then
    DebugPrint("[Fold] CanEnter=false: not BigWorldRegion")
    return false
  end
  if self:IsInMountState() then
    DebugPrint("[Fold] CanEnter=false: in Mount")
    self:ForceExitFoldStateNoRestart()
    return false
  end
  if UltimateAttackGuideHelper:IsUltimateActive(self.OwnerPlayer) then
    DebugPrint("[Fold] CanEnter=false: Ultimate active")
    return false
  end
  if self:IsAutoCombatFoldBlocked() then
    DebugPrint("[Fold] CanEnter=false: AutoCombat active")
    return false
  end
  if self.AtkRanged and self.AtkRanged.IsLockingShoot then
    DebugPrint("[Fold] CanEnter=false: LockingShoot active")
    return false
  end
  if self.AtkRanged and self.AtkRanged.IsFireDown then
    DebugPrint("[Fold] CanEnter=false: FireDown active")
    return false
  end
  if self.FoldPressedSkillInputs and next(self.FoldPressedSkillInputs) ~= nil then
    DebugPrint("[Fold] CanEnter=false: SkillInput active")
    return false
  end
  if self.Fly and self.Fly:CheckIsSkillFlying() then
    DebugPrint("[Fold] CanEnter=false: Suyi flying")
    return false
  end
  if self:IsInJetFlyState() then
    DebugPrint("[Fold] CanEnter=false: JetRush/JetState active")
    return false
  end
  return true
end

function WBP_Battle_Button_Phone:SetFoldSkillInputPressed(InputKey, bPressed)
  if not InputKey then
    return
  end
  self.FoldPressedSkillInputs = self.FoldPressedSkillInputs or {}
  local WasPressed = self.FoldPressedSkillInputs[InputKey] == true
  if bPressed then
    if WasPressed then
      return
    end
    self.FoldPressedSkillInputs[InputKey] = true
    self:StopFoldTimer()
    return
  end
  if not WasPressed then
    return
  end
  self.FoldPressedSkillInputs[InputKey] = nil
  if nil == next(self.FoldPressedSkillInputs) then
    self:ResetFoldTimer()
  end
end

function WBP_Battle_Button_Phone:TryStartFoldTimer()
  if self.IsFolded then
    return
  end
  if not self:CanEnterFoldState() then
    self:StopFoldTimer()
    return
  end
  if self.FoldTimer then
    return
  end
  DebugPrint("[Fold] TryStartFoldTimer: 15s timer started")
  self.FoldTimer = self:AddTimer(15.0, self.EnterFoldState, false, 0, "FoldTimer", false)
end

function WBP_Battle_Button_Phone:ResetFoldTimer()
  self:StopFoldTimer()
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:StopFoldTimer()
  if self.FoldTimer then
    self:RemoveTimer(self.FoldTimer)
    self.FoldTimer = nil
  end
end

function WBP_Battle_Button_Phone:GetFoldAnim()
  local MappedLayout = GetMappedLayout(self.CurrentLayout)
  if 2 == MappedLayout or 3 == MappedLayout then
    return self.Fold2
  end
  return self.Fold1
end

function WBP_Battle_Button_Phone:ApplyFoldHitBlock()
  local MappedLayout = GetMappedLayout(self.CurrentLayout)
  local keepSet = {
    [self.AtkMelee] = true,
    [self.Dodge] = true
  }
  if 3 == MappedLayout then
    keepSet[self.BulletJump] = true
  elseif 2 == MappedLayout then
    keepSet[self.BulletJump] = true
    keepSet[self.Jump] = true
  else
    keepSet[self.Jump] = true
  end
  local candidates = {
    self.AtkRanged,
    self.AtkRangedLeft,
    self.Bullet,
    self.BulletJump,
    self.BulletJumpLeft,
    self.Dodge,
    self.SupportSkill,
    self.Slide,
    self.SlideAttack,
    self.Skill,
    self.BulletJumpCancelLeft,
    self.BulletJumpCancelRight,
    self.BulletJumpCancelLeft_2,
    self.BulletJumpCancelRight_2,
    self.Fly,
    self.Battle_Menu
  }
  if self.Squat then
    candidates[#candidates + 1] = self.Squat
  end
  if self.Walk then
    candidates[#candidates + 1] = self.Walk
  end
  if self.SlidingJump then
    candidates[#candidates + 1] = self.SlidingJump
  end
  local changed = {}
  for _, w in ipairs(candidates) do
    if not keepSet[w] and IsValid(w) then
      local vis = w:GetVisibility()
      if vis == ESlateVisibility.Visible or vis == ESlateVisibility.SelfHitTestInvisible then
        w:SetVisibility(ESlateVisibility.HitTestInvisible)
        changed[#changed + 1] = {widget = w, prev = vis}
      end
    end
  end
  self.FoldHitBlockList = changed
end

function WBP_Battle_Button_Phone:RestoreFoldHitBlock()
  if not self.FoldHitBlockList then
    return
  end
  for _, entry in ipairs(self.FoldHitBlockList) do
    if IsValid(entry.widget) and entry.widget:GetVisibility() == ESlateVisibility.HitTestInvisible then
      entry.widget:SetVisibility(entry.prev)
    end
  end
  self.FoldHitBlockList = nil
end

function WBP_Battle_Button_Phone:EnterFoldState()
  self.FoldTimer = nil
  if self.IsFolded then
    return
  end
  if not self:CanEnterFoldState() then
    DebugPrint("[Fold] EnterFoldState: conditions no longer met, abort")
    return
  end
  DebugPrint("[Fold] EnterFoldState: folding, Layout=", self.CurrentLayout)
  self.IsFolded = true
  EMUIAnimationSubsystem:EMPlayAnimation(self, self:GetFoldAnim())
  self:ApplyFoldHitBlock()
end

function WBP_Battle_Button_Phone:ExitFoldState()
  self:StopFoldTimer()
  if not self.IsFolded then
    return
  end
  self.IsFolded = false
  EMUIAnimationSubsystem:EMPlayAnimation(self, self:GetFoldAnim(), EUMGSequencePlayMode.Reverse)
  self:RestoreFoldHitBlock()
  self:TryStartFoldTimer()
end

function WBP_Battle_Button_Phone:OnFoldAttackPressed()
  if self.IsFolded then
    self:ExitFoldState()
  else
    self:ResetFoldTimer()
  end
end

function WBP_Battle_Button_Phone:OnFoldFirePressed()
  if self.IsFolded then
    self:ExitFoldState()
  else
    self:ResetFoldTimer()
  end
end

function WBP_Battle_Button_Phone:OnFoldSkillPressed()
  self:ResetFoldTimer()
end

function WBP_Battle_Button_Phone:OnFoldMeleeTriggered()
  if self:IsAutoAttackFoldBlocked() then
    return
  end
  if self.IsFolded then
    self:ExitFoldState()
  end
end

function WBP_Battle_Button_Phone:OnFoldFireTriggered()
  if self:IsAutoShootFoldBlocked() then
    return
  end
  if self.IsFolded then
    self:ExitFoldState()
  end
end

AssembleComponents(WBP_Battle_Button_Phone)
return WBP_Battle_Button_Phone
