require("UnLua")
local Const = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseConst")
local SpliseMultiplierBase = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseMultiplierBase")
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:OnLoaded(OwnerPlayer, Params)
  self.Super.OnLoaded(self)
  self.OwnerPlayer = OwnerPlayer
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:InitBattleCharUI(CharUIId, GradeLevel)
  self:UnbindSpliseUltiFeedback()
  self.AmmoBarRequest = nil
  self:RemoveTimer("WaitMultiplierLoad")
  self:RemoveTimer("OutAnimFinished")
  self:RemoveTimer("ScopeOutAnim")
  self:RemoveTimer("UpdateScopeDisplay")
  self.MultiplierReleased = false
  self.FeedbackHandledFrameByType = {}
  local Request = {}
  self.MultiplierRequest = Request
  self.bScoping = nil
  self.bChargeFull = nil
  self.DisplayProgress = nil
  self.LastChargeText = nil
  self.LastChargeTextProgress = nil
  self.LastAppliedChargeProgress = nil
  self.bChargeMaterialChecked = false
  self.ChargeMID = nil
  self:LeaveUltReload()
  self:StopAllAnimations()
  self.Super.InitBattleCharUI(self, CharUIId, GradeLevel)
  self.BattleInstance = nil
  self.OwnerEid = self.OwnerPlayer.Eid
  local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]
  local SkinProfileName = Const.Skin.ProfileByCharUIId[CharUIId] or Const.Skin.ProfileBySkinId[self.OwnerPlayer.CurrentSkinId] or Const.Skin.DefaultProfile
  self.SkinProfile = Const.Skin.Profiles[SkinProfileName] or Const.Skin.Profiles[Const.Skin.DefaultProfile]
  self.MultiplierUIName = self.SkinProfile.MultiplierUIName or Const.Multiplier.UIName
  self.bEnableKillFeedback = self.SkinProfile.EnableKillFeedback == true
  self.BuffId = CharUIInfo.TriggerBuffId or Const.Charge.UltBuffId
  self.bIsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC"
  self.DialConfig = self.bIsMobile and Const.Multiplier.DialConfig.Mobile or Const.Multiplier.DialConfig.PC
  self:SetWeaponShootHintCovered(false)
  self:K2_SetBuffsOwner(self.OwnerPlayer)
  self:RegisterOnBuffsChangedDelegate()
  self:CreateMultiplierEntries()
  local PassiveClient = IsValid(self.OwnerPlayer) and self.OwnerPlayer:GetPassiveEffectClient()
  self.PassiveClient = PassiveClient
  self:BindSpliseUltiFeedback()
  local PerKillCount = IsValid(PassiveClient) and PassiveClient.PerKillCount
  self.PerKillCount = type(PerKillCount) == "number" and PerKillCount > 0 and PerKillCount or nil
  if self.Kill and self.Kill.SetLeafSoundEvent then
    self.Kill:SetLeafSoundEvent(self.SkinProfile.LeafSoundEvent)
  end
  self:ResetKillState()
  self:ReceiveOnBuffsChanged()
  if not self.bIsMobile and (self.WS_Key or self.WS_Shoot) then
    EventManager:RemoveEvent(EventID.OnChangeKeyBoardSet, self)
    if self.WS_Shoot then
      EventManager:AddEvent(EventID.OnChangeKeyBoardSet, self, self.RefreshShootKeyHints)
    end
    EventManager:RemoveEvent(EventID.OnSwitchGamepadSet, self)
    EventManager:AddEvent(EventID.OnSwitchGamepadSet, self, self.RefreshPCKeyHints)
    if not self.GameInputModeSubsystem then
      local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
      self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
    end
    if IsValid(self.GameInputModeSubsystem) then
      self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SwitchZoomKeyPage)
      self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SwitchZoomKeyPage)
    end
    self:RefreshPCKeyHints()
  end
  if self.bIsMobile then
    local UIMgr = UIManager(self)
    local MultiplierUIName = self.MultiplierUIName
    if UIMgr and UIMgr.LoadUIAsync then
      local function OnMultiplierLoaded(UIObj)
        if not IsValid(self) or self.MultiplierRequest ~= Request or self.MultiplierReleased or not IsValid(self.OwnerPlayer) then
          return
        end
        if not IsValid(UIObj) then
          return
        end
        self.MultiplierUI = UIObj
        UIObj:InitMultiplier(self.OwnerPlayer)
        UIObj:SetScopeActive(self.bScoping)
      end
      
      local function TryLoadMultiplier()
        if not IsValid(self) or self.MultiplierRequest ~= Request or self.MultiplierReleased or not IsValid(self.OwnerPlayer) then
          return
        end
        if UIMgr:GetUIObjIsAsyncLoading(MultiplierUIName) then
          self:AddTimer(Const.Multiplier.UpdateInterval, TryLoadMultiplier, false, 0, "WaitMultiplierLoad", true)
          return
        end
        local Existing = UIMgr:GetUIObj(MultiplierUIName)
        if IsValid(Existing) then
          OnMultiplierLoaded(Existing)
        else
          local Loaded = UIMgr:LoadUIAsync(MultiplierUIName, OnMultiplierLoaded)
          if IsValid(Loaded) and self.MultiplierUI ~= Loaded then
            OnMultiplierLoaded(Loaded)
          end
        end
      end
      
      TryLoadMultiplier()
    end
  end
  self:AddTimer(Const.Kill.UpdateInterval, self.UpdateKillCount, true, 0, "UpdateKillCount")
end

function M:BindSpliseUltiFeedback()
  local PassiveClient = self.PassiveClient
  local Dispatcher = IsValid(PassiveClient) and PassiveClient.OnSpliseUltiUIFeedback
  if not Dispatcher then
    return
  end
  Dispatcher:Remove(self, self.HandleSpliseUltiUIFeedback)
  Dispatcher:Add(self, self.HandleSpliseUltiUIFeedback)
end

function M:UnbindSpliseUltiFeedback()
  local PassiveClient = self.PassiveClient
  local Dispatcher = IsValid(PassiveClient) and PassiveClient.OnSpliseUltiUIFeedback
  if Dispatcher then
    Dispatcher:Remove(self, self.HandleSpliseUltiUIFeedback)
  end
  self.PassiveClient = nil
end

function M:StopSpliseUltiFeedbackAnimation(Animation)
  if not Animation then
    return
  end
  if self:IsAnimationPlaying(Animation) and self.SetAnimationCurrentTime and Animation.GetEndTime then
    local EndTime = Animation:GetEndTime()
    if EndTime and EndTime > 0 then
      self:SetAnimationCurrentTime(Animation, math.max(EndTime - Const.Feedback.ResetTailOffset, 0))
    end
  end
  self:StopAnimation(Animation)
end

function M:StopSpliseUltiFeedback()
  self:StopSpliseUltiFeedbackAnimation(self.Hit)
  self:StopSpliseUltiFeedbackAnimation(self.MakeKill)
end

function M:HandleSpliseUltiUIFeedback(FeedbackType)
  if self.MultiplierReleased then
    return
  end
  local Animation
  if FeedbackType == Const.Feedback.Type.Kill then
    if not self.bEnableKillFeedback then
      return
    end
    Animation = self.MakeKill
  elseif FeedbackType == Const.Feedback.Type.Hit then
    Animation = self.Hit
  else
    return
  end
  local Frame = UE4.UKismetSystemLibrary.GetFrameCount()
  if self.FeedbackHandledFrameByType[FeedbackType] == Frame then
    return
  end
  self.FeedbackHandledFrameByType[FeedbackType] = Frame
  self:StopSpliseUltiFeedbackAnimation(Animation)
  if Animation then
    self:PlayAnimation(Animation)
  end
end

function M:GetBattleInstance()
  local BattleIns = self.BattleInstance
  if not IsValid(BattleIns) then
    BattleIns = IsValid(self.OwnerPlayer) and Battle(self.OwnerPlayer)
    self.BattleInstance = BattleIns
    if not IsValid(BattleIns) then
      return nil
    end
  end
  return BattleIns
end

function M:GetAimIndicator()
  local UIMgr = UIManager(self)
  local BattleMain = UIMgr and UIMgr.GetUIObj and UIMgr:GetUIObj("BattleMain")
  if BattleMain and BattleMain.GetTakeAimIndicator then
    return BattleMain:GetTakeAimIndicator()
  end
end

function M:RequestUltAmmoBar()
  local Indicator = self:GetAimIndicator()
  if not IsValid(Indicator) or not IsValid(Indicator.Panel_Ammo) then
    return
  end
  if IsValid(Indicator.Panel_Ammo_Bar) then
    return
  end
  if self.AmmoBarRequest and self.AmmoBarRequest.Indicator == Indicator then
    return
  end
  local Config = DataMgr.WidgetUI[Const.Reload.AmmoWidgetName]
  if not Config then
    return
  end
  local Path = self.bIsMobile and (Config.MobileBPPath or Config.BPPath) or Config.BPPath
  if not Path then
    return
  end
  local Request = {Indicator = Indicator}
  self.AmmoBarRequest = Request
  local Handle = UE4.UResourceLibrary.LoadClassAsync(self, Path, {
    self,
    function(_, WidgetClass)
      if not IsValid(self) or self.AmmoBarRequest ~= Request then
        return
      end
      self.AmmoBarRequest = nil
      if not (not self.MultiplierReleased and IsValid(self.OwnerPlayer) and IsValid(Indicator) and self:GetAimIndicator() == Indicator and IsValid(Indicator.Panel_Ammo)) or not IsValid(WidgetClass) then
        return
      end
      if IsValid(Indicator.Panel_Ammo_Bar) then
        return
      end
      local Widget = UE4.UWidgetBlueprintLibrary.Create(Indicator, WidgetClass)
      if not IsValid(Widget) then
        return
      end
      Widget:Init(Indicator)
      Indicator.Panel_Ammo_Bar = Widget
      Indicator.Panel_Ammo:AddChild(Widget)
      Widget:RemoveTimer("WaitingFlagTimer")
      Widget.WaitingFlag = true
      Widget:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  })
  if self.AmmoBarRequest == Request and not UE4.UResourceLibrary.IsValidResource(self, Handle) then
    self.AmmoBarRequest = nil
  end
end

function M:UpdateUltAmmoBar(Indicator, Percent)
  local AmmoBar = Indicator.Panel_Ammo_Bar
  if not IsValid(AmmoBar) then
    return
  end
  if self.ReloadAmmoBar ~= AmmoBar then
    AmmoBar.BarColor = "Lack"
    AmmoBar:PlayBulletLackAnim(true)
    AmmoBar:AmmoBarOutLineSetRenderOpacity(1)
    Indicator.AmmoBarStyle = "Bar"
    Indicator:SwitchAmmoBar()
    self.ReloadAmmoBar = AmmoBar
    AmmoBar:SwitchIn()
  end
  AmmoBar:SetAmmoBarPercent(Percent)
end

function M:EnterUltReload()
  if self.bUltReloading then
    return
  end
  local Indicator = self:GetAimIndicator()
  if not IsValid(Indicator) then
    return
  end
  self:RequestUltAmmoBar()
  self.bUltReloading = true
  self.ReloadIndicator = Indicator
  local MontageTime = Indicator:GetFirstReloadAnimPlayTime()
  self.ReloadDuration = MontageTime and MontageTime > 0 and MontageTime or Const.Reload.Duration
  Indicator.CurState = "Reload"
  Indicator:SwitchAimStar("BulletReload")
  self.ReloadElapsed = 0
  self:UpdateUltAmmoBar(Indicator, 0)
  self:AddTimer(Const.Reload.UpdateInterval, function()
    if not IsValid(Indicator) then
      self:LeaveUltReload()
      return
    end
    local SkillSpeed = 1
    local OwnerPlayer = Indicator.OwnerPlayer
    if IsValid(OwnerPlayer) and OwnerPlayer.SkillTimeline and IsValid(OwnerPlayer.SkillTimeline.CurrentSkillNode) then
      SkillSpeed = OwnerPlayer.SkillTimeline.CurrentSkillNode.AnimPlayRate or 1
    end
    self.ReloadElapsed = self.ReloadElapsed + Const.Reload.UpdateInterval * SkillSpeed
    local P = self.ReloadElapsed / self.ReloadDuration
    if P >= Const.Reload.HidePercent or IsValid(Indicator.CurrentWeapon) and Indicator.CurrentWeapon:GetAttr("MagazineBulletNum") > 0 then
      self:LeaveUltReload()
      return
    end
    self:UpdateUltAmmoBar(Indicator, P)
  end, true, 0, "UltReloadTick")
end

function M:LeaveUltReload()
  self:RemoveTimer("UltReloadTick")
  if not self.bUltReloading then
    return
  end
  self.bUltReloading = false
  local Indicator = self.ReloadIndicator
  self.ReloadIndicator = nil
  self.ReloadAmmoBar = nil
  if IsValid(Indicator) then
    Indicator.CurState = "Normal"
    Indicator:SwitchAimStar()
    if IsValid(Indicator.AmmoBarPanel) then
      Indicator.AmmoBarPanel:SwitchOut()
    end
  end
end

function M:RefreshPCKeyHints()
  self:RefreshZoomKeyHints()
  self:RefreshShootKeyHints()
  self:SwitchZoomKeyPage()
end

function M:RefreshZoomKeyHints()
  if not self.WS_Key then
    return
  end
  if self.Key_Down then
    self.Key_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Key_Up then
    self.Key_Up:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = Const.Input.MouseIcon
        }
      }
    })
  end
  if self.Controller_Down then
    self.Controller_Down:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Controller_Up then
    local IconList = UIUtils.GetIconListByActionName(Const.Input.Actions.Up)
    if IconList and #IconList > 0 then
      self.Controller_Up:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = IconList[1]
          },
          {
            Type = "Img",
            ImgShortPath = Const.Input.GamepadDirectionIcon
          }
        }
      })
    end
  end
end

local function CreateActionKeyHint(Widget, ActionName, DescriptionKey, bGamepad)
  if not Widget then
    return
  end
  local KeyInfoList = {}
  if bGamepad then
    local Icons = UIUtils.GetIconListByActionName(ActionName)
    if not Icons or 0 == #Icons then
      return
    end
    for _, Icon in ipairs(Icons) do
      KeyInfoList[#KeyInfoList + 1] = {Type = "Img", ImgShortPath = Icon}
    end
  else
    local KeyName = CommonUtils:GetActionMappingKeyName(ActionName)
    if not KeyName or "" == KeyName then
      return
    end
    KeyInfoList[1] = {Type = "Text", Text = KeyName}
  end
  Widget:CreateCommonKey({
    KeyInfoList = KeyInfoList,
    Desc = GText(DescriptionKey)
  })
end

function M:RefreshShootKeyHints()
  if not self.WS_Shoot then
    return
  end
  local Actions = Const.Input.Actions
  local Descriptions = Const.Input.Descriptions
  CreateActionKeyHint(self.Key_Shoot, Actions.ShootKey, Descriptions.Shoot, false)
  CreateActionKeyHint(self.Key_Exit, Actions.ExitKey, Descriptions.Exit, false)
  CreateActionKeyHint(self.Controller_Shoot, Actions.ShootKey, Descriptions.Shoot, true)
  CreateActionKeyHint(self.Controller_Exit, Actions.ExitKey, Descriptions.Exit, true)
end

function M:SwitchZoomKeyPage()
  if not self.WS_Key and not self.WS_Shoot then
    return
  end
  if not self.GameInputModeSubsystem then
    local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  end
  local InputType = IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem:GetCurrentInputType() or ECommonInputType.MouseAndKeyboard
  local Page = InputType == ECommonInputType.Gamepad and Const.Input.Pages.Gamepad or Const.Input.Pages.Keyboard
  if self.WS_Key then
    self.WS_Key:SetActiveWidgetIndex(Page)
  end
  if self.WS_Shoot then
    self.WS_Shoot:SetActiveWidgetIndex(Page)
  end
end

function M:SetWeaponShootHintCovered(bCovered)
  if self.bIsMobile then
    return
  end
  local UIMgr = UIManager(self)
  local BattleMain = UIMgr and UIMgr.GetUIObj and UIMgr:GetUIObj("BattleMain")
  if IsValid(BattleMain) and BattleMain.SetWeaponShootHintCovered then
    BattleMain:SetWeaponShootHintCovered(Const.Input.WeaponShootHintSource, bCovered and self.WS_Shoot ~= nil)
  end
end

function M:ReceiveOnBuffsChanged()
  local Buffs = self.OwnerPlayer.BuffManager.Buffs
  local HasScopeBuff = false
  local HasUltBuff = false
  for _, Buff in pairs(Buffs) do
    if IsValid(Buff) then
      if Buff.BuffId == Const.Charge.ScopeBuffId then
        HasScopeBuff = true
      elseif self.BuffId and Buff.BuffId == self.BuffId then
        HasUltBuff = true
      end
    end
  end
  self.bUltActive = HasUltBuff
  local bScopeChanged = self.bScoping ~= HasScopeBuff
  self:SwitchCrossHairState(HasScopeBuff)
  if bScopeChanged and self.bIsMobile then
    self:AddTimer(Const.Input.MobileGuideRefreshDelay, function()
      if not IsValid(self) or self.MultiplierReleased or not IsValid(self.OwnerPlayer) then
        return
      end
      local UIMgr = UIManager(self)
      local BattleMain = UIMgr and UIMgr.GetUIObj and UIMgr:GetUIObj("BattleMain")
      local MobileSkillPanel = BattleMain and BattleMain.Char_Skill
      if MobileSkillPanel and MobileSkillPanel.RefreshUltimateAttackGuide then
        MobileSkillPanel:RefreshUltimateAttackGuide()
      end
    end, false, 0, "RefreshMobileAttackGuide")
  end
  self:RefreshChargeFullState(bScopeChanged)
end

function M:SwitchCrossHairState(bScoping)
  if self.bScoping == bScoping then
    return
  end
  local WasScoping = self.bScoping
  self.bScoping = bScoping
  self:RemoveTimer("UpdateScopeDisplay")
  if self.In then
    self:StopAnimation(self.In)
  end
  self:StopChargeAnimations()
  if bScoping then
    self.LastAppliedChargeProgress = nil
    self:LeaveUltReload()
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:SetWeaponShootHintCovered(true)
    if self.Out then
      self:StopAnimation(self.Out)
    end
    if self.In then
      self:PlayAnimation(self.In)
    end
  elseif WasScoping and self.bUltActive then
    self:EnterUltReload()
    if self.Out then
      self:PlayAnimation(self.Out)
      self:AddTimer(self.Out:GetEndTime(), function()
        if not self.bScoping then
          self:SetVisibility(UE4.ESlateVisibility.Collapsed)
          self:SetWeaponShootHintCovered(false)
        end
      end, false, 0, "ScopeOutAnim")
    else
      self:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self:SetWeaponShootHintCovered(false)
    end
  else
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self:SetWeaponShootHintCovered(false)
  end
  if IsValid(self.MultiplierUI) then
    self.MultiplierUI:SetScopeActive(bScoping)
  end
  if bScoping then
    self:AddTimer(Const.Charge.UpdateInterval, self.UpdateScopeDisplay, true, 0, "UpdateScopeDisplay")
  end
end

function M:RefreshChargeFullState(bForceRefresh)
  if not IsValid(self.OwnerPlayer) then
    return
  end
  local BattleIns = self:GetBattleInstance()
  if not BattleIns then
    return
  end
  local Percent = UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Charge.DataSetKey)
  self:SwitchChargeFullState(Percent >= 100, bForceRefresh)
end

function M:StopChargeAnimations()
  if self.ChargeNormal then
    self:StopAnimation(self.ChargeNormal)
  end
  if self.ChargeFinsh then
    self:StopAnimation(self.ChargeFinsh)
  end
  local Glow = self.VX_CrossHair_Circle_Glow5
  if not IsValid(Glow) and self.GetWidgetFromName then
    Glow = self:GetWidgetFromName("VX_CrossHair_Circle_Glow5")
  end
  if IsValid(Glow) then
    Glow:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:SwitchChargeFullState(bFull, bForceRefresh)
  if self.bChargeFull == bFull and not bForceRefresh then
    return
  end
  self.bChargeFull = bFull
  self:StopChargeAnimations()
  if not self.bScoping or self.MultiplierReleased then
    return
  end
  if bFull then
    if self.ChargeFinsh then
      self:PlayAnimation(self.ChargeFinsh, 0, 0)
    end
  elseif self.ChargeNormal then
    self:PlayAnimation(self.ChargeNormal)
  end
end

function M:UpdateScopeDisplay()
  if not self.bScoping or self.MultiplierReleased then
    return
  end
  local BattleIns = self:GetBattleInstance()
  if not BattleIns then
    return
  end
  self:UpdateChargeRing(BattleIns)
  self:UpdateMultiplier(BattleIns)
end

function M:CreateMultiplierEntries()
  SpliseMultiplierBase.CreateMultiplierEntries(self)
end

function M:UpdateMultiplier(BattleIns)
  if not self.MultiplierEntries or not self.DynamicEntryBox_Multiplier then
    return
  end
  local Multi = UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Multiplier.DataSetKey)
  local Index = SpliseMultiplierBase.GetMultiplierIndex(Multi, self.DialConfig.ReverseSlots)
  SpliseMultiplierBase.UpdateDial(self, Index)
end

function M:ResetKillState()
  local BattleIns = self:GetBattleInstance()
  self.KillBase = BattleIns and UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Kill.DataSetKey) or 0
  self.LastKillCount = 0
  self.KillRank = 0
  if self.Kill then
    self.Kill:SetKillInfo(0, 0, true)
  end
end

function M:UpdateKillCount()
  if not (not self.MultiplierReleased and self.Kill) or not IsValid(self.OwnerPlayer) then
    return
  end
  local BattleIns = self:GetBattleInstance()
  if not BattleIns then
    return
  end
  local Count = math.floor(UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Kill.DataSetKey) + 0.5) - math.floor(self.KillBase + 0.5)
  if Count < 0 then
    Count = 0
  end
  if Count == self.LastKillCount then
    return
  end
  local LitCount = self.KillRank or 0
  if self.PerKillCount then
    LitCount = math.min(math.floor(Count / self.PerKillCount), #Const.Kill.Points)
  end
  self.LastKillCount = Count
  self.KillRank = LitCount
  self.Kill:SetKillInfo(Count, LitCount)
end

function M:UpdateChargeRing(BattleIns)
  local ChargeImage = self.CrossHair_Inner
  if not ChargeImage then
    return
  end
  local Percent = UE4.UDataSetFunctionLibrary.GetFloat_ByEid(BattleIns, self.OwnerEid, Const.Charge.DataSetKey)
  self:SwitchChargeFullState(Percent >= 100)
  local TargetProgress = Percent / 100
  if TargetProgress < 0 then
    TargetProgress = 0
  elseif TargetProgress > 1 then
    TargetProgress = 1
  end
  self.DisplayProgress = self.DisplayProgress or TargetProgress
  if TargetProgress < self.DisplayProgress then
    self.DisplayProgress = self.DisplayProgress + (TargetProgress - self.DisplayProgress) * Const.Charge.ResetSmooth
  else
    self.DisplayProgress = self.DisplayProgress + (TargetProgress - self.DisplayProgress) * Const.Charge.Smooth
  end
  if math.abs(TargetProgress - self.DisplayProgress) <= Const.Charge.ProgressTolerance then
    self.DisplayProgress = TargetProgress
  end
  local Progress = self.DisplayProgress
  if not self.bChargeMaterialChecked then
    self.bChargeMaterialChecked = true
    if ChargeImage.GetDynamicMaterial then
      self.ChargeMID = ChargeImage:GetDynamicMaterial()
    end
    if self.ChargeMID and self.bIsMobile then
      ChargeImage:SetRenderScale(FVector2D(1, 1))
    end
  end
  if self.LastAppliedChargeProgress ~= Progress then
    self.LastAppliedChargeProgress = Progress
    if self.ChargeMID then
      local Radius = Const.Charge.RadiusMax - (Const.Charge.RadiusMax - Const.Charge.RadiusMin) * Progress
      self.ChargeMID:SetScalarParameterValue(Const.Charge.OutsideParameter, Radius)
      self.ChargeMID:SetScalarParameterValue(Const.Charge.InsideParameter, Radius - Const.Charge.Width)
    elseif self.bIsMobile then
      local Scale = 1.0 - (1.0 - Const.Charge.ScaleMin) * Progress
      ChargeImage:SetRenderScale(FVector2D(Scale, Scale))
    end
  end
  local ChargeText = self.Text_Num
  if ChargeText and self.LastChargeTextProgress ~= TargetProgress then
    self.LastChargeTextProgress = TargetProgress
    local Text = string.format("%.0f", TargetProgress * 100)
    if self.LastChargeText ~= Text then
      self.LastChargeText = Text
      ChargeText:SetText(Text)
    end
  end
end

function M:RemoveSelf()
  self.MultiplierReleased = true
  self:UnbindSpliseUltiFeedback()
  self:StopSpliseUltiFeedback()
  self:StopChargeAnimations()
  self:RemoveTimer("WaitMultiplierLoad")
  self:RemoveTimer("RefreshMobileAttackGuide")
  if self.Kill then
    self.Kill:StopKillAnimations()
  end
  self.AmmoBarRequest = nil
  self:UnRegisterOnBuffsChangedDelegate()
  EventManager:RemoveEvent(EventID.OnChangeKeyBoardSet, self)
  EventManager:RemoveEvent(EventID.OnSwitchGamepadSet, self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SwitchZoomKeyPage)
  end
  self:LeaveUltReload()
  self.MultiplierRequest = nil
  if IsValid(self.MultiplierUI) then
    self.MultiplierUI:SetScopeActive(false)
  end
  if self.bIsMobile then
    self.MultiplierUI = nil
    local UIMgr = UIManager(self)
    if UIMgr and UIMgr.UnLoadUI and self.MultiplierUIName then
      UIMgr:UnLoadUI(self.MultiplierUIName)
    end
  end
  self:RemoveTimer("UpdateScopeDisplay")
  self:RemoveTimer("UpdateKillCount")
  self:RemoveTimer("ScopeOutAnim")
  self.BattleInstance = nil
  self.OwnerEid = nil
  self.FeedbackHandledFrameByType = nil
  self.SkinProfile = nil
  self.bEnableKillFeedback = nil
  if self.Out then
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
    local EndTime = self.Out:GetEndTime()
    self:AddTimer(EndTime, function()
      self:SetWeaponShootHintCovered(false)
      self:Close()
    end, false, 0, "OutAnimFinished")
  else
    self:SetWeaponShootHintCovered(false)
    self:Close()
  end
end

return M
