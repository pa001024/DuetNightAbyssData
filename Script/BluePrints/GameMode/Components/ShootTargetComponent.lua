require("UnLua")
local M = {}
local NORMAL_SHOOT_TARGET_POPUP_ID = 100428
local STORY_SHOOT_TARGET_POPUP_ID = 100429
local SHOOT_TARGET_INACTIVE_SKILLS = {
  ESkillName.Attack,
  ESkillName.Jump,
  ESkillName.Slide,
  ESkillName.BulletJump,
  ESkillName.SecondJump,
  ESkillName.Skill1,
  ESkillName.Skill2,
  ESkillName.Skill3,
  ESkillName.Avoid,
  ESkillName.HeavyAttack,
  ESkillName.Interactive,
  ESkillName.FallAttack,
  ESkillName.SlideAttack,
  ESkillName.Crouch,
  ESkillName.SwitchMasterOrHero,
  ESkillName.SwitchWalk
}

local function IsValidShootTargetTextKey(TextKey)
  return nil ~= TextKey and "" ~= TextKey and tostring(TextKey) ~= "-1"
end

local function GetShootTargetDetailTextKeys(TextHint2)
  local TextKeys = {}
  if not IsValidShootTargetTextKey(TextHint2) then
    return TextKeys
  end
  for TextKey in tostring(TextHint2):gmatch("[^,]+") do
    TextKey = TextKey:match("^%s*(.-)%s*$")
    if IsValidShootTargetTextKey(TextKey) then
      table.insert(TextKeys, TextKey)
    end
  end
  return TextKeys
end

function M:_GetShootTargetConfig(GameId)
  if not DataMgr or not DataMgr.ExploreShootingID then
    return nil
  end
  return DataMgr.ExploreShootingID[tonumber(GameId) or GameId]
end

function M:_ShowShootTargetInstructionPopup(Config)
  if not Config then
    return false
  end
  local PopupId = Config.StoryMode and STORY_SHOOT_TARGET_POPUP_ID or NORMAL_SHOOT_TARGET_POPUP_ID
  if not (DataMgr and DataMgr.CommonPopupUIContext) or not DataMgr.CommonPopupUIContext[PopupId] then
    DebugPrint("ShootTargetComponent CommonPopupUIContext config not found", PopupId)
    return false
  end
  local Params = {}
  if IsValidShootTargetTextKey(Config.TextName) then
    Params.Title = GText(Config.TextName)
  end
  local DescriptionText
  if IsValidShootTargetTextKey(Config.TextHint) then
    DescriptionText = GText(Config.TextHint)
  end
  local DetailTexts = {}
  for _, TextKey in ipairs(GetShootTargetDetailTextKeys(Config.TextHint2)) do
    table.insert(DetailTexts, GText(TextKey))
  end
  local BodyText = DescriptionText or ""
  if #DetailTexts > 0 then
    local DetailText = table.concat(DetailTexts, "\n")
    BodyText = "" ~= BodyText and BodyText .. [[


]] .. DetailText or DetailText
  end
  if "" ~= BodyText then
    Params.ShortText = BodyText
    Params.LongText = BodyText
  end
  local UIManagerComponent = UIManager(self)
  if not UIManagerComponent or not UIManagerComponent.ShowCommonPopupUI then
    DebugPrint("ShootTargetComponent UIManager not found")
    return false
  end
  UIManagerComponent:ShowCommonPopupUI(PopupId, Params)
  return true
end

function M:_BindShootTargetEvents()
  EventManager:RemoveEvent(EventID.AddShootTargetScore, self)
  EventManager:RemoveEvent(EventID.EndShootTargetGame, self)
  EventManager:AddEvent(EventID.AddShootTargetScore, self, self.OnAddShootTargetScore)
  EventManager:AddEvent(EventID.EndShootTargetGame, self, self.EndShootTargetGame)
end

function M:_UnbindShootTargetEvents()
  EventManager:RemoveEvent(EventID.AddShootTargetScore, self)
  EventManager:RemoveEvent(EventID.EndShootTargetGame, self)
end

function M:_IsShootTargetSessionMatched(SessionId)
  if nil == SessionId then
    return true
  end
  local Session = self.ShootTargetSession
  if not Session then
    return false
  end
  return tostring(SessionId) == tostring(Session.SessionId)
end

function M:IsShootTargetGameActive()
  return self.ShootTargetSession ~= nil
end

function M:GetShootTargetScore()
  return self.ShootTargetSession and self.ShootTargetSession.Score or 0
end

function M:_GetShootTargetPlayer(PlayerEid)
  if PlayerEid and 0 ~= PlayerEid then
    local BattleInstance = Battle(self)
    local Player = BattleInstance and BattleInstance:GetEntity(PlayerEid) or nil
    if Player then
      return Player
    end
  end
  return UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
end

function M:_LockShootTargetMovement(Session)
  if not Session then
    return false, "shoot target session not found"
  end
  if Session.MoveInputIgnored then
    return true
  end
  local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
  local Controller = Player and Player:GetController() or nil
  if not Controller or not Controller.SetIgnoreMoveInput then
    return false, "shoot target player controller not found"
  end
  Controller:SetIgnoreMoveInput(true)
  Session.MoveInputIgnored = true
  Session.MoveInputController = Controller
  Session.ShootTargetInactivatedSkills = {}
  local SkillNamesArray = TArray(0)
  for _, SkillName in ipairs(SHOOT_TARGET_INACTIVE_SKILLS) do
    if not Controller:CheckSkillInActive(SkillName) then
      table.insert(Session.ShootTargetInactivatedSkills, SkillName)
      SkillNamesArray:Add(SkillName)
    end
  end
  if #Session.ShootTargetInactivatedSkills > 0 then
    Controller:InActiveSkills(SkillNamesArray, "Lock")
  end
  local MoveComponent = Player.CharacterMovement or Player:GetMovementComponent()
  if MoveComponent then
    MoveComponent:StopMovementImmediately()
    MoveComponent:ConsumeInputVector()
  end
  return true
end

function M:_UnlockShootTargetMovement(Session)
  if not Session then
    return
  end
  local Controller = Session.MoveInputController
  if not Controller then
    local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
    Controller = Player and Player:GetController() or UE4.UGameplayStatics.GetPlayerController(self, 0)
  end
  if Session.MoveInputIgnored and Controller and Controller.SetIgnoreMoveInput then
    Controller:SetIgnoreMoveInput(false)
  end
  local InactivatedSkills = Session.ShootTargetInactivatedSkills or {}
  if Controller and Controller.ActiveSkills and #InactivatedSkills > 0 then
    local SkillNamesArray = TArray(0)
    for _, SkillName in ipairs(InactivatedSkills) do
      SkillNamesArray:Add(SkillName)
    end
    Controller:ActiveSkills(SkillNamesArray, "UnLock")
  end
  Session.MoveInputIgnored = false
  Session.MoveInputController = nil
  Session.ShootTargetInactivatedSkills = nil
end

function M:_CaptureShootTargetFire(Session, Player)
  if not Session then
    return false, "shoot target session not found"
  end
  if Session.FireSkillPrepared then
    return true
  end
  Player = Player or self:_GetShootTargetPlayer(Session.PlayerEid)
  local Controller = Player and Player:GetController() or nil
  if not (Controller and Controller.CheckSkillInActive and Controller.CheckSkillIsBan) or not Controller.ActiveSkills then
    return false, "shoot target player controller does not support fire skill control"
  end
  local FireSkill = ESkillName.Fire
  Session.FireSkillController = Controller
  Session.FireSkillWasBanned = Controller:CheckSkillIsBan(FireSkill) == true
  Session.FireSkillWasInactive = Controller:CheckSkillInActive(FireSkill) == true
  Session.OriginalFireSkillState = Controller.GetSkillState and Controller:GetSkillState(FireSkill) or nil
  Session.FireSkillPrepared = true
  return true
end

function M:_EnableShootTargetFire(Session)
  local bCaptured, CaptureError = self:_CaptureShootTargetFire(Session)
  if not bCaptured then
    return false, CaptureError
  end
  local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
  local Controller = Player and Player:GetController() or Session.FireSkillController
  if not Controller then
    return false, "shoot target player controller not found"
  end
  Session.FireSkillController = Controller
  local FireSkill = ESkillName.Fire
  local bCurrentlyBanned = Controller:CheckSkillIsBan(FireSkill) == true
  local bCurrentlyInactive = true == Controller:CheckSkillInActive(FireSkill)
  if not bCurrentlyBanned and not bCurrentlyInactive then
    return true
  end
  local SkillNamesArray = TArray(0)
  SkillNamesArray:Add(FireSkill)
  Controller:ActiveSkills(SkillNamesArray, bCurrentlyBanned and "UnBan" or "UnLock")
  if Controller:CheckSkillInActive(FireSkill) or Controller:CheckSkillIsBan(FireSkill) then
    return false, "shoot target fire skill could not be activated"
  end
  return true
end

function M:_RestoreShootTargetFire(Session)
  if not Session or not Session.FireSkillPrepared then
    return
  end
  local Controller = Session.FireSkillController
  if not Controller then
    local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
    Controller = Player and Player:GetController() or UE4.UGameplayStatics.GetPlayerController(self, 0)
  end
  if Controller then
    local SkillNamesArray = TArray(0)
    SkillNamesArray:Add(ESkillName.Fire)
    local OriginalState = Session.OriginalFireSkillState
    if Session.FireSkillWasInactive and Controller.InActiveSkills then
      Controller:InActiveSkills(SkillNamesArray, OriginalState or "Lock")
    end
    if Session.FireSkillWasBanned and Controller.BanSkills then
      Controller:BanSkills(SkillNamesArray, OriginalState or "Ban")
    end
  end
  Session.FireSkillController = nil
  Session.FireSkillWasBanned = nil
  Session.FireSkillWasInactive = nil
  Session.OriginalFireSkillState = nil
  Session.FireSkillPrepared = false
end

function M:_ChangeShootTargetRole(Player, RoleId, AvatarInfo)
  if not Player or not Player.ChangeRole then
    return false
  end
  local MechanismEid = Player.MechanismEid or 0
  if Player.SetMechanismEid then
    Player:SetMechanismEid(0, false)
  end
  Player:ChangeRole(RoleId, AvatarInfo)
  if Player.SetMechanismEid and 0 ~= MechanismEid then
    Player:SetMechanismEid(MechanismEid, false)
  end
  return true
end

function M:_EnterShootTargetRole(Session, Config)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false, "shoot target avatar not found"
  end
  local RoleIds = Config and Config.RoleID
  local RoleIndex = 1 == Avatar.WeitaSex and 1 or 2
  local RoleId = tonumber(RoleIds and RoleIds[RoleIndex]) or 0
  Session.RoleId = RoleId
  if RoleId <= 0 then
    return true
  end
  if not DataMgr.BattleChar or not DataMgr.BattleChar[RoleId] then
    return false, "BattleChar config not found: " .. tostring(RoleId)
  end
  local Player = self:_GetShootTargetPlayer()
  if not Player then
    return false, "shoot target player not found"
  end
  Session.PlayerEid = Player.Eid or 0
  Session.OriginalRoleId = Player.CurrentRoleId
  Session.OriginalQuestRoleId = tonumber(Player.AvatarQuestRoleID) or 0
  local Controller = Player:GetController()
  local AvatarInfo
  if 0 ~= Session.OriginalQuestRoleId then
    AvatarInfo = AvatarUtils:GetBattleInfoByQuestRoleId(Session.OriginalQuestRoleId, Avatar)
    if AvatarInfo and AvatarInfo.RoleInfo then
      AvatarInfo.RoleInfo.AvatarQuestRoleID = Session.OriginalQuestRoleId
    end
  else
    AvatarInfo = Controller and Controller:GetAvatarInfo() or nil
  end
  AvatarInfo = AvatarInfo and CommonUtils.DeepCopy(AvatarInfo) or nil
  if AvatarInfo and Player.GetBattleExtraInfo then
    AvatarInfo = AvatarUtils:UpdateBattleInfo(AvatarInfo, Player:GetBattleExtraInfo())
  end
  Session.OriginalAvatarInfo = AvatarInfo
  local bFireCaptured, FireError = self:_CaptureShootTargetFire(Session, Player)
  if not bFireCaptured then
    return false, FireError
  end
  Session.RoleChanged = Session.OriginalRoleId ~= RoleId
  if Session.RoleChanged and not self:_ChangeShootTargetRole(Player, RoleId) then
    Session.RoleChanged = false
    return false, "shoot target player does not support ChangeRole"
  end
  return true
end

function M:_RestoreShootTargetRole(Session)
  if not Session or not Session.RoleChanged then
    return
  end
  local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
  if Player then
    local RestoreRoleId = Session.OriginalRoleId
    if 0 ~= (Session.OriginalQuestRoleId or 0) then
      RestoreRoleId = nil
    end
    self:_ChangeShootTargetRole(Player, RestoreRoleId, Session.OriginalAvatarInfo)
  end
  Session.RoleChanged = false
  Session.OriginalRoleId = nil
  Session.OriginalQuestRoleId = nil
  Session.OriginalAvatarInfo = nil
end

function M:_EnableShootTargetUnlimitedAmmo(Session)
  if not Session or Session.ReserveAmmoOverridden then
    return
  end
  local Player = self:_GetShootTargetPlayer(Session.PlayerEid)
  local RangedWeapon = Player and Player.RangedWeapon or nil
  if not (IsValid(RangedWeapon) and RangedWeapon.GetAttr) or not RangedWeapon.SetAttr then
    DebugPrint("ShootTargetComponent ranged weapon not ready, unlimited ammo was not applied")
    return
  end
  Session.RangedWeapon = RangedWeapon
  Session.OriginalBulletMax = RangedWeapon:GetAttr("BulletMax")
  Session.OriginalReserveBulletNum = RangedWeapon:GetAttr("BulletNum")
  Session.ReserveAmmoOverridden = true
  RangedWeapon:SetAttr("BulletMax", -1)
  RangedWeapon:SetAttr("BulletNum", -1)
end

function M:_RestoreShootTargetAmmo(Session)
  if not Session or not Session.ReserveAmmoOverridden then
    return
  end
  local RangedWeapon = Session.RangedWeapon
  if IsValid(RangedWeapon) and RangedWeapon.SetAttr then
    if Session.OriginalBulletMax ~= nil then
      RangedWeapon:SetAttr("BulletMax", Session.OriginalBulletMax)
    end
    if nil ~= Session.OriginalReserveBulletNum then
      RangedWeapon:SetAttr("BulletNum", Session.OriginalReserveBulletNum)
    end
  end
  Session.RangedWeapon = nil
  Session.OriginalBulletMax = nil
  Session.OriginalReserveBulletNum = nil
  Session.ReserveAmmoOverridden = false
end

function M:StartShootTargetGame(GameId, ExploreGroupId)
  if not IsStandAlone(self) then
    return nil, "ShootTargetComponent only supports Standalone"
  end
  if self:IsShootTargetGameActive() then
    return nil, "ShootTarget game is already active"
  end
  GameId = tonumber(GameId) or GameId
  local Config = self:_GetShootTargetConfig(GameId)
  if not Config then
    return nil, "ExploreShootingID config not found: " .. tostring(GameId)
  end
  local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
  local ActiveExploreGroupId = GameState and GameState.ActiveLimitTimeExploreGroup or 0
  local bStartedByActiveExploreGroup = nil ~= ExploreGroupId and tostring(ActiveExploreGroupId) == tostring(ExploreGroupId)
  if 0 ~= ActiveExploreGroupId and not bStartedByActiveExploreGroup then
    return nil, "another limit-time explore group is active: " .. tostring(ActiveExploreGroupId)
  end
  self.ShootTargetSessionSerial = (self.ShootTargetSessionSerial or 0) + 1
  self.ShootTargetSession = {
    SessionId = self.ShootTargetSessionSerial,
    GameId = GameId,
    ExploreGroupId = ExploreGroupId,
    Score = 0
  }
  local bRoleEntered, RoleError = self:_EnterShootTargetRole(self.ShootTargetSession, Config)
  if not bRoleEntered then
    self.ShootTargetSession = nil
    return nil, RoleError
  end
  local bFireEnabled, FireError = self:_EnableShootTargetFire(self.ShootTargetSession)
  if not bFireEnabled then
    self:_RestoreShootTargetRole(self.ShootTargetSession)
    self:_RestoreShootTargetFire(self.ShootTargetSession)
    self.ShootTargetSession = nil
    return nil, FireError
  end
  self:_EnableShootTargetUnlimitedAmmo(self.ShootTargetSession)
  local bMovementLocked, MovementError = self:_LockShootTargetMovement(self.ShootTargetSession)
  if not bMovementLocked then
    self:_RestoreShootTargetAmmo(self.ShootTargetSession)
    self:_RestoreShootTargetRole(self.ShootTargetSession)
    self:_RestoreShootTargetFire(self.ShootTargetSession)
    self.ShootTargetSession = nil
    return nil, MovementError
  end
  self:_BindShootTargetEvents()
  EventManager:FireEvent(EventID.OnShootTargetStart)
  EventManager:FireEvent(EventID.InitShootTargetUI, true)
  EventManager:FireEvent(EventID.OnShootTargetEnter, Config.RatingRange, Config.TextHint2)
  self:_ShowShootTargetInstructionPopup(Config)
  DebugPrint("ShootTargetComponent StartShootTargetGame", self.ShootTargetSession.SessionId, GameId, ExploreGroupId)
  return self.ShootTargetSession.SessionId
end

function M:OnAddShootTargetScore(AddScore, SessionId)
  local Session = self.ShootTargetSession
  AddScore = tonumber(AddScore)
  if not (Session and AddScore) or 0 == AddScore then
    return nil
  end
  if not self:_IsShootTargetSessionMatched(SessionId) then
    return nil
  end
  Session.Score = math.max(0, Session.Score + AddScore)
  EventManager:FireEvent(EventID.OnShootTargetScoreChanged, Session.Score, Session.SessionId)
  return Session.Score
end

function M:ResetShootTargetGame(SessionId)
  local Session = self.ShootTargetSession
  if not Session or not self:_IsShootTargetSessionMatched(SessionId) then
    return false
  end
  local Config = self:_GetShootTargetConfig(Session.GameId)
  if not Config then
    return false
  end
  Session.Score = 0
  EventManager:FireEvent(EventID.OnShootTargetEnter, Config.RatingRange, Config.TextHint2)
  EventManager:FireEvent(EventID.OnShootTargetScoreChanged, Session.Score, Session.SessionId)
  DebugPrint("ShootTargetComponent ResetShootTargetGame", Session.SessionId, Session.GameId)
  return true
end

function M:EndShootTargetGame(SessionId)
  local Session = self.ShootTargetSession
  if not Session or not self:_IsShootTargetSessionMatched(SessionId) then
    return false
  end
  local EndedSessionId = Session.SessionId
  local GameId = Session.GameId
  local Score = Session.Score
  self.ShootTargetSession = nil
  self:_UnbindShootTargetEvents()
  self:_RestoreShootTargetAmmo(Session)
  EventManager:FireEvent(EventID.InitShootTargetUI, false)
  self:_UnlockShootTargetMovement(Session)
  self:_RestoreShootTargetRole(Session)
  self:_RestoreShootTargetFire(Session)
  DebugPrint("ShootTargetComponent EndShootTargetGame", EndedSessionId, GameId, Score)
  return true
end

function M:CleanupShootTargetGame()
  local Session = self.ShootTargetSession
  self.ShootTargetSession = nil
  self:_UnbindShootTargetEvents()
  self:_UnlockShootTargetMovement(Session)
  self:_RestoreShootTargetAmmo(Session)
  self:_RestoreShootTargetRole(Session)
  self:_RestoreShootTargetFire(Session)
end

function M:AddShootTargetScoreByGameMode(DeltaScore)
  local NewScore = self:OnAddShootTargetScore(DeltaScore, nil)
  if nil == NewScore then
    return -1
  end
  return NewScore
end

function M:ResetShootTargetGameByGameMode()
  return self:ResetShootTargetGame(nil)
end

function M:EndShootTargetGameByGameMode()
  return self:EndShootTargetGame(nil)
end

function M:AbortShootTargetGameByGameMode()
  local Session = self.ShootTargetSession
  if not Session then
    return false
  end
  local ExploreGroupId = Session.ExploreGroupId
  if nil ~= ExploreGroupId then
    local GameState = self.EMGameState or UE4.UGameplayStatics.GetGameState(self)
    local ExploreGroup = GameState and GameState.ExploreGroupMap and GameState.ExploreGroupMap:FindRef(tonumber(ExploreGroupId) or ExploreGroupId)
    if ExploreGroup and ExploreGroup.FailLimitExplore then
      ExploreGroup:FailLimitExplore()
      return true
    end
    DebugPrint("ShootTargetComponent active ExploreGroup not found", ExploreGroupId)
  end
  return self:EndShootTargetGame(Session.SessionId)
end

return M
