require("UnLua")
local UIUtils = require("Utils.UIUtils")
local WBP_Battle_Track_Skill_P_C = Class("BluePrints.UI.BP_UIState_C")
local UpdateTimerKey = "UpdateTrackSkillInTimer"
local RefreshTrackKeyForbiddenDelayKey = "RefreshTrackKeyForbiddenDelay"
local TRACK_ATTACK_SKILL_NAME = "Attack"

local function GetKeyboardKey(ActionName, Fallback)
  local Avatar = GWorld and GWorld:GetAvatar()
  if Avatar and Avatar.ActionMapping and Avatar.ActionMapping[ActionName] then
    return Avatar.ActionMapping[ActionName]
  end
  if DataMgr and DataMgr.KeyBoardMap and DataMgr.KeyBoardMap[ActionName] then
    return DataMgr.KeyBoardMap[ActionName].Key or Fallback
  end
  return Fallback
end

local function GetActionKeyText(ActionName, Fallback)
  local KeyName = CommonUtils:GetActionMappingKeyName(ActionName)
  if KeyName and "" ~= KeyName then
    return KeyName
  end
  return GetKeyboardKey(ActionName, Fallback)
end

local function GetActionIcon(ActionName, Index, Fallback)
  local Icons = UIUtils.GetIconListByActionName(ActionName)
  if Icons then
    return Icons[Index] or Icons[1] or Fallback
  end
  return Fallback
end

local function GetCurrentSlideMech(Player)
  if IsValid(Player) and type(Player.GetCurrentSlideMech) == "function" then
    return Player:GetCurrentSlideMech()
  end
  return nil
end

local function IsTurnForbidden(Player)
  local Mech = GetCurrentSlideMech(Player)
  if not Mech then
    return true
  end
  return not Mech.AllowTurn
end

local function IsLeaveForbidden(Player)
  local Mech = GetCurrentSlideMech(Player)
  if not Mech then
    return true
  end
  return not Mech.CanExit
end

local function CreateTextKey(Widget, Text, Desc, bLongPress)
  if not IsValid(Widget) then
    return
  end
  Widget:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = Text}
    },
    Desc = Desc,
    bLongPress = true == bLongPress,
    bBattleKey = true
  })
end

local function CreateDoubleTextKey(Widget, FirstText, SecondText, Desc)
  if not IsValid(Widget) then
    return
  end
  Widget:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = FirstText},
      {Type = "Or"},
      {Type = "Text", Text = SecondText}
    },
    Desc = Desc,
    bButton = false,
    bBattleKey = true
  })
end

local function CreateImgKey(Widget, ImgShortPath, Desc, bLongPress)
  if not IsValid(Widget) then
    return
  end
  Widget:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = ImgShortPath}
    },
    Desc = Desc,
    bLongPress = true == bLongPress
  })
end

local function CreateDoubleImgKey(Widget, FirstImgShortPath, SecondImgShortPath, Desc)
  if not IsValid(Widget) then
    return
  end
  Widget:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = FirstImgShortPath},
      {Type = "Or"},
      {Type = "Img", ImgShortPath = SecondImgShortPath}
    },
    Desc = Desc,
    bButton = false
  })
end

function WBP_Battle_Track_Skill_P_C:Initialize(Initializer)
  self.Super.Initialize(self)
  self.BattleMain = nil
  self.OwnerPlayer = nil
  self.bTrackHUDInited = false
  self.bListenInputMethodChanged = false
end

function WBP_Battle_Track_Skill_P_C:Construct()
  self.Super.Construct(self)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Battle_Track_Skill_P_C:Destruct()
  self:StopUpdateTimer()
  self:StopTrackListeningInput()
  self:RemoveTrackSkillListeningInput()
  if self:IsExistTimer(RefreshTrackKeyForbiddenDelayKey) then
    self:RemoveTimer(RefreshTrackKeyForbiddenDelayKey)
  end
  if self.GameInputModeSubsystem and self.bListenInputMethodChanged then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshInputType)
    self.bListenInputMethodChanged = false
  end
  WBP_Battle_Track_Skill_P_C.Super.Destruct(self)
end

function WBP_Battle_Track_Skill_P_C:InitWithBattleMain(BattleMain)
  if self.bTrackHUDInited then
    return
  end
  self.bTrackHUDInited = true
  self.BattleMain = BattleMain
  self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self:InitListenEvent()
  self:InitKeyTips()
  self:InitTrackSkillButton()
  self:RefreshInputType(UIUtils.UtilsGetCurrentInputType())
end

function WBP_Battle_Track_Skill_P_C:InitListenEvent()
  self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
  self:AddDispatcher(EventID.OnSkillInfosRep, self, self.OnSkillInfosRep)
  self:AddDispatcher(EventID.OnSkill1InAirChanged, self, self.OnSkill1InAirChanged)
  self:AddDispatcher(EventID.UpdateSkillEfficiency, self, self.OnUpdateSkillEfficiency)
  self:AddDispatcher(EventID.OnBuffSpModify, self, self.OnUpdateBuffSpModify)
  self:AddDispatcher(EventID.OnChangeKeyBoardSet, self, self.OnKeyBoardSetChanged)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if self.GameInputModeSubsystem and not self.bListenInputMethodChanged then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInputType)
    self.bListenInputMethodChanged = true
  end
end

function WBP_Battle_Track_Skill_P_C:InitKeyTips()
  local SlideKey = GetActionKeyText("Slide", "Ctrl")
  local SwitchTrackLeftKey = GetActionKeyText("ChangeSlideMechLeft", "A")
  local SwitchTrackRightKey = GetActionKeyText("ChangeSlideMechRight", "D")
  local TurnKey = GetActionKeyText("SlideMechTurn", "V")
  local LeaveKey = GetActionKeyText("Interactive", "F")
  local TrackSildeDesc = GText("UI_Track_Slide")
  local TrackSwitchDesc = GText("UI_Track_SwitchSlide")
  local TrackTurnDesc = GText("UI_Track_Reverse")
  local TrackLeaveDesc = GText("UI_Track_Leave")
  CreateTextKey(self.Key_Slider_PC, SlideKey, TrackSildeDesc)
  CreateDoubleTextKey(self.Key_SwitchTrack_PC, SwitchTrackLeftKey, SwitchTrackRightKey, TrackSwitchDesc)
  CreateTextKey(self.Key_Turn_PC, TurnKey, TrackTurnDesc)
  CreateTextKey(self.Key_Leave_PC, LeaveKey, TrackLeaveDesc)
  local SkillIcon = GetActionIcon("Skill1", 2, UIConst.GamePadImgKey.LeftShoulder)
  local SlideIcon = GetActionIcon("Slide", 1, UIConst.GamePadImgKey.FaceButtonBottom)
  local SwitchLeftIcon = GetActionIcon("ChangeSlideMechLeft", 1, UIConst.GamePadImgKey.LeftTriggerThreshold)
  local SwitchRightIcon = GetActionIcon("ChangeSlideMechRight", 1, UIConst.GamePadImgKey.RightTriggerThreshold)
  local TurnIcon = GetActionIcon("SlideMechTurn", 1, UIConst.GamePadImgKey.DPadDown)
  local LeaveIcon = GetActionIcon("Interactive", 1, UIConst.GamePadImgKey.FaceButtonRight)
  CreateImgKey(self.Key_Skill, SkillIcon)
  CreateImgKey(self.Key_Slider_GamePad, SlideIcon, TrackSildeDesc)
  CreateDoubleImgKey(self.Key_SwitchTrack_GamePad, SwitchLeftIcon, SwitchRightIcon, TrackSwitchDesc)
  CreateImgKey(self.Key_Turn_GamePad, TurnIcon, TrackTurnDesc)
  CreateImgKey(self.Key_Leave_GamePad, LeaveIcon, TrackLeaveDesc)
end

function WBP_Battle_Track_Skill_P_C:OnKeyBoardSetChanged()
  if not IsValid(self.Battle_Skill_Track) then
    return
  end
  local KeyName = CommonUtils:GetActionMappingKeyName(TRACK_ATTACK_SKILL_NAME)
  self.Battle_Skill_Track.Common_Key_PC:SetImage("Text", KeyName)
end

function WBP_Battle_Track_Skill_P_C:InitTrackSkillButton()
  self.Battle_Skill_Track:InitTrackItem()
  self:RefreshTrackSkillButton()
end

function WBP_Battle_Track_Skill_P_C:OnEnterSlideMech(Player, SlideMechEid, Reason)
  self.OwnerPlayer = IsValid(Player) and Player or UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:RefreshTrackSkillButton()
  self:StartUpdateTimer()
  if IsValid(self.Key_Leave_PC) then
    self.Key_Leave_PC:EnableKey()
  end
  if IsValid(self.Key_Leave_GamePad) then
    self.Key_Leave_GamePad:EnableKey()
  end
  self:RefreshTrackKeyForbiddenState()
  self:StartTrackListeningInput()
end

function WBP_Battle_Track_Skill_P_C:OnLeaveSlideMech(Player, SlideMechEid, Reason)
  self:StopTrackListeningInput()
  self:StopUpdateTimer()
  self:RemoveTrackSkillListeningInput()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Battle_Track_Skill_P_C:StartTrackListeningInput()
  self:BindLeaveSlideMechInput()
  self:BindSlideMechTurnInput()
  self:BindChangeSlideMechInput()
end

function WBP_Battle_Track_Skill_P_C:StopTrackListeningInput()
  self:UnbindLeaveSlideMechInput()
  self:UnbindSlideMechTurnInput()
  self:UnbindChangeSlideMechInput()
end

function WBP_Battle_Track_Skill_P_C:BindLeaveSlideMechInput()
  if not self:IsListeningForInputAction("Interactive") then
    self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {
      self,
      self.OnLeaveSlideMechKeyPressed
    })
  end
end

function WBP_Battle_Track_Skill_P_C:UnbindLeaveSlideMechInput()
  if self:IsListeningForInputAction("Interactive") then
    self:StopListeningForInputAction("Interactive", EInputEvent.IE_Pressed)
  end
  if IsValid(self.Key_Leave_PC) then
    self.Key_Leave_PC:OnButtonReleased()
  end
  if IsValid(self.Key_Leave_GamePad) then
    self.Key_Leave_GamePad:OnButtonReleased()
  end
end

function WBP_Battle_Track_Skill_P_C:OnLeaveSlideMechKeyPressed()
  if IsLeaveForbidden(self.OwnerPlayer) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_Toast04"), 1.5)
    return
  end
  if type(self.OwnerPlayer.TryLeaveSlideMech) == "function" then
    self.OwnerPlayer:TryLeaveSlideMech()
  end
end

function WBP_Battle_Track_Skill_P_C:BindSlideMechTurnInput()
  if not self:IsListeningForInputAction("SlideMechTurn") then
    self:ListenForInputAction("SlideMechTurn", EInputEvent.IE_Pressed, true, {
      self,
      self.OnSlideMechTurnPressed
    })
  end
end

function WBP_Battle_Track_Skill_P_C:UnbindSlideMechTurnInput()
  if self:IsListeningForInputAction("SlideMechTurn") then
    self:StopListeningForInputAction("SlideMechTurn", EInputEvent.IE_Pressed)
  end
end

function WBP_Battle_Track_Skill_P_C:OnSlideMechTurnPressed()
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if IsTurnForbidden(self.OwnerPlayer) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Track_Toast03"), 1.5)
    return
  end
  if type(self.OwnerPlayer.PressSlideMechTurn) == "function" then
    self.OwnerPlayer:PressSlideMechTurn()
  end
end

function WBP_Battle_Track_Skill_P_C:BindChangeSlideMechInput()
  if not self:IsListeningForInputAction("ChangeSlideMechLeft") then
    self:ListenForInputAction("ChangeSlideMechLeft", EInputEvent.IE_Pressed, true, {
      self,
      self.OnChangeSlideMechLeftPressed
    })
    self:ListenForInputAction("ChangeSlideMechLeft", EInputEvent.IE_Released, true, {
      self,
      self.OnChangeSlideMechLeftReleased
    })
  end
  if not self:IsListeningForInputAction("ChangeSlideMechRight") then
    self:ListenForInputAction("ChangeSlideMechRight", EInputEvent.IE_Pressed, true, {
      self,
      self.OnChangeSlideMechRightPressed
    })
    self:ListenForInputAction("ChangeSlideMechRight", EInputEvent.IE_Released, true, {
      self,
      self.OnChangeSlideMechRightReleased
    })
  end
end

function WBP_Battle_Track_Skill_P_C:UnbindChangeSlideMechInput()
  if self:IsListeningForInputAction("ChangeSlideMechLeft") then
    self:StopListeningForInputAction("ChangeSlideMechLeft", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("ChangeSlideMechLeft", EInputEvent.IE_Released)
  end
  if self:IsListeningForInputAction("ChangeSlideMechRight") then
    self:StopListeningForInputAction("ChangeSlideMechRight", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("ChangeSlideMechRight", EInputEvent.IE_Released)
  end
end

function WBP_Battle_Track_Skill_P_C:TrySwitchSlideMech(Val)
  if not IsValid(self.OwnerPlayer) or not self.OwnerPlayer.IsInSlideMech then
    return
  end
  if type(self.OwnerPlayer.SwitchSlideMech) == "function" then
    self.OwnerPlayer:SwitchSlideMech(Val)
  end
end

function WBP_Battle_Track_Skill_P_C:OnChangeSlideMechLeftPressed()
  self:TrySwitchSlideMech(-1.0)
end

function WBP_Battle_Track_Skill_P_C:OnChangeSlideMechLeftReleased()
  self:TrySwitchSlideMech(0.0)
end

function WBP_Battle_Track_Skill_P_C:OnChangeSlideMechRightPressed()
  self:TrySwitchSlideMech(1.0)
end

function WBP_Battle_Track_Skill_P_C:OnChangeSlideMechRightReleased()
  self:TrySwitchSlideMech(0.0)
end

function WBP_Battle_Track_Skill_P_C:RefreshInputType(CurInputType, CurGamepadName)
  if not IsValid(self.Switcher_Key) then
    return
  end
  if self.AddTimer and not self:IsExistTimer(RefreshTrackKeyForbiddenDelayKey) then
    self:AddTimer(0.1, self.RefreshTrackKeyForbiddenState, false, 0, RefreshTrackKeyForbiddenDelayKey)
  else
    self:RefreshTrackKeyForbiddenState()
  end
  if CurInputType == ECommonInputType.Gamepad then
    self.Switcher_Key:SetActiveWidgetIndex(1)
    if IsValid(self.Battle_Skill_Track) and IsValid(self.Battle_Skill_Track.WidgetSwitcher_0) then
      self.Battle_Skill_Track.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    end
  else
    self.Switcher_Key:SetActiveWidgetIndex(0)
    if IsValid(self.Battle_Skill_Track) and IsValid(self.Battle_Skill_Track.WidgetSwitcher_0) then
      self.Battle_Skill_Track.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
  end
end

function WBP_Battle_Track_Skill_P_C:RefreshTrackKeyForbiddenState()
  if not IsValid(self.OwnerPlayer) then
    self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  end
  if not IsValid(self.OwnerPlayer) then
    return
  end
  local bTurnForbidden = IsTurnForbidden(self.OwnerPlayer)
  local bLeaveForbidden = IsLeaveForbidden(self.OwnerPlayer)
  self:SetTrackKeyForbidden(self.Key_Turn_PC, bTurnForbidden)
  self:SetTrackKeyForbidden(self.Key_Turn_GamePad, bTurnForbidden)
  self:SetTrackKeyForbidden(self.Key_Leave_PC, bLeaveForbidden)
  self:SetTrackKeyForbidden(self.Key_Leave_GamePad, bLeaveForbidden)
end

function WBP_Battle_Track_Skill_P_C:SetTrackKeyForbidden(Key, bForbidden)
  if IsValid(Key) and type(Key.SetForbidKey) == "function" then
    Key:SetForbidKey(true == bForbidden, true)
  end
end

function WBP_Battle_Track_Skill_P_C:RefreshTrackSkillButton()
  if not IsValid(self.OwnerPlayer) then
    self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  end
  if not IsValid(self.OwnerPlayer) or not IsValid(self.Battle_Skill_Track) then
    return
  end
  local SkillId = self.OwnerPlayer:GetSkillByType(UE.ESkillType.Skill1)
  local Skill = self.OwnerPlayer:GetSkill(SkillId)
  if type(self.Battle_Skill_Track.RefreshButtonStyle) == "function" then
    self:RemoveTrackSkillListeningInput()
    self.Battle_Skill_Track:RefreshButtonStyle(TRACK_ATTACK_SKILL_NAME, Skill, ESkillName.Skill1, self.OwnerPlayer)
  end
end

function WBP_Battle_Track_Skill_P_C:UpdateTrackSkillInTimer()
  if not IsValid(self.Battle_Skill_Track) then
    return
  end
  if type(self.Battle_Skill_Track.RefreshSkillStyleInTimer) == "function" then
    self.Battle_Skill_Track:RefreshSkillStyleInTimer(TRACK_ATTACK_SKILL_NAME)
  end
end

function WBP_Battle_Track_Skill_P_C:StartUpdateTimer()
  if not self:IsExistTimer(UpdateTimerKey) then
    self:AddTimer(0.1, self.UpdateTrackSkillInTimer, true, 0, UpdateTimerKey, false)
  end
end

function WBP_Battle_Track_Skill_P_C:StopUpdateTimer()
  if self:IsExistTimer(UpdateTimerKey) then
    self:RemoveTimer(UpdateTimerKey)
  end
end

function WBP_Battle_Track_Skill_P_C:RemoveTrackSkillListeningInput()
  if IsValid(self.Battle_Skill_Track) and type(self.Battle_Skill_Track.RemoveAllListenInput) == "function" then
    self.Battle_Skill_Track:RemoveAllListenInput()
  end
end

function WBP_Battle_Track_Skill_P_C:OnSwitchRole()
  self.OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self:RefreshTrackSkillButton()
  self:InitKeyTips()
  self:RefreshTrackKeyForbiddenState()
  if self:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
    self:StartTrackListeningInput()
  end
end

function WBP_Battle_Track_Skill_P_C:OnSkillInfosRep(Character)
  if not IsValid(self.OwnerPlayer) or self.OwnerPlayer ~= Character then
    return
  end
  self:RefreshTrackSkillButton()
end

function WBP_Battle_Track_Skill_P_C:OnSkill1InAirChanged(IsInAir)
  if IsValid(self.Battle_Skill_Track) and type(self.Battle_Skill_Track.ChangeIsInAir) == "function" then
    self.Battle_Skill_Track:ChangeIsInAir(IsInAir)
  end
end

function WBP_Battle_Track_Skill_P_C:OnUpdateSkillEfficiency(Owner)
  if not IsValid(self.OwnerPlayer) or Owner and Owner ~= self.OwnerPlayer then
    return
  end
  if IsValid(self.Battle_Skill_Track) and type(self.Battle_Skill_Track.UpdateSkillEfficiency) == "function" then
    self.Battle_Skill_Track:UpdateSkillEfficiency("Skill1", self.OwnerPlayer:GetAttr("Sp"))
  end
end

function WBP_Battle_Track_Skill_P_C:OnUpdateBuffSpModify()
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if IsValid(self.Battle_Skill_Track) and type(self.Battle_Skill_Track.UpdateBuffSpModify) == "function" then
    self.Battle_Skill_Track:UpdateBuffSpModify("Skill1", self.OwnerPlayer:GetAttr("Sp"))
  end
end

return WBP_Battle_Track_Skill_P_C
