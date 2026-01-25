local Decorator = require("BluePrints.Client.Wrapper.Decorator")
local Component = {}
local LuaConst = require("EMLuaConst")

function Component:InitMoveSyncMgr()
  self.OtherRoleInfo = {}
end

function Component:AddRoleToCreate(ObjId, RoleInfo)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncAddRoleToCreate(ObjId, RoleInfo)
    return
  end
  if not ObjId then
    self.logger.debug("EnterWorldRole is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if TempRoleInfo then
    self.logger.debug("There alreay has same avatar in this region ", ObjId)
    return
  end
  self.OtherRoleInfo[ObjId] = {}
  self.RoleUseTargetParam[ObjId] = {}
  local CharInfo = RoleInfo.CharInfo
  TempRoleInfo.ObjectId = ObjId
  TempRoleInfo.CharId = CharInfo.CharId
  TempRoleInfo.BornState = Const.UnBorn
  TempRoleInfo.Uid = RoleInfo.AvatarInfo.Uid
  TempRoleInfo.AppearanceSuit = {}
  local SuitTalble = TempRoleInfo.AppearanceSuit
  SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
  SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
  SuitTalble.AccessorySuit = CharInfo.AccessorySuit
  SuitTalble.Colors = CharInfo.Colors
  SuitTalble.SkinId = CharInfo.SkinId
  TempRoleInfo.RegionWeaponInfo = RoleInfo.WeaponInfo
  TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon
  print(_G.LogTag, " TempRoleInfo.AppearanceSuit", TempRoleInfo.AppearanceSuit)
  PrintTable({AddRoleToCreate_RoleInfo = RoleInfo, AvatarId = ObjId}, 100)
end

function Component:RemoveRoleInfoAndDestroy(ObjId, RoleInfo)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncRemoveRoleAndDestroy(ObjId, RoleInfo)
    return
  end
  if not ObjId then
    self.logger.debug("[RegionOnline] LeaveWorldRole is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if not TempRoleInfo then
    self.logger.debug("[RegionOnline] There is no avatar in this region ", ObjId)
    return
  end
  if TempRoleInfo.CharEid then
    local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if MainPlayer then
      MainPlayer:RemovePlayerToInteract(TempRoleInfo.CharEid)
    end
  end
  if TempRoleInfo.BornState == Const.UnBorn then
    self.OtherRoleInfo[ObjId] = nil
    return
  end
  TempRoleInfo.BornState = Const.ShouldDetory
  if TempRoleInfo.BornState == Const.Borning then
    return
  end
  if not TempRoleInfo.CharEid then
    return
  end
  local Player = Battle(self):GetEntity(TempRoleInfo.CharEid)
  EventManager:FireEvent(EventID.OnlineRemoveOtherPlayer, TempRoleInfo.Uid)
  if Player then
    Player:K2_DestroyActor()
  end
  self.OtherRoleInfo[ObjId] = nil
  self.RoleUseTargetParam[ObjId] = nil
  EventManager:FireEvent(EventID.RemoveRegionIndicatorInfo, TempRoleInfo.Uid)
end

function Component:DestoryAllOthers()
  if not self.OtherRoleInfo then
    return
  end
  for k, v in pairs(self.OtherRoleInfo) do
    self:RemoveRoleInfoAndDestroy(v.ObjectId, v)
  end
end

function Component:NotifyCharacterStartSync(RegionOnlineId)
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  if RegionSycnSubsys then
    RegionSycnSubsys.RegionOnlineId = RegionOnlineId
    RegionSycnSubsys:ClearAllRoleBornInfo()
  end
  NPCCreateSubSystem(GameInstance):SetIsOnlineState(true, RegionOnlineId)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  if Player then
    Player:EnableRegionSync(true, RegionOnlineId)
  end
  local OldState = self.IsInRegionOnline
  EventManager:FireEvent(EventID.OnlineRegionChange, OldState, true)
end

function Component:NotifyCharacterEndSync(...)
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  if RegionSycnSubsys then
    RegionSycnSubsys.RegionOnlineId = 0
  end
  NPCCreateSubSystem(GameInstance):SetIsOnlineState(false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  if Player then
    Player:EnableRegionSync(false, 0)
  end
  local OldState = self.IsInRegionOnline
  EventManager:FireEvent(EventID.OnlineRegionChange, OldState, false)
end

function Component:SendSyncInfo(SyncInfo, ActionBaseInfo)
  SyncInfo.ActionBaseInfo = ActionBaseInfo
  self:UploadPlayerMessage(self.CurrentOnlineType, SyncInfo)
end

function Component:HandChangeRoleInfo(ObjId, RoleInfo)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncChangeRoleInfo(ObjId, RoleInfo)
    return
  end
  if not ObjId then
    self.logger.debug("[RegionOnline] HandChangeRoleInfo is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if not TempRoleInfo then
    self.logger.debug("[RegionOnline] There is no avatar in this region ", ObjId)
    return
  end
  if not TempRoleInfo.BornState then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  if TempRoleInfo.BornState < Const.Borning then
    return
  end
  if TempRoleInfo.BornState < Const.Bonred then
    return
  end
  if not TempRoleInfo.CharEid then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  local Player = Battle(self):GetEntity(TempRoleInfo.CharEid)
  if not Player then
    self.logger.error("[RegionOnline] Role Doesn't exist In This World ", ObjId)
    return
  end
  if not Player.InitCharacterInfo then
    self.logger.error("[RegionOnline] It's not a character ", ObjId)
    return
  end
  local CharInfo = RoleInfo.CharInfo
  TempRoleInfo.CharId = CharInfo.CharId
  TempRoleInfo.AppearanceSuit = {}
  local SuitTalble = TempRoleInfo.AppearanceSuit
  SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
  SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
  SuitTalble.AccessorySuit = CharInfo.AccessorySuit
  SuitTalble.Colors = CharInfo.Colors
  SuitTalble.SkinId = CharInfo.SkinId
  local Info = {}
  Info.RoleId = TempRoleInfo.CharId
  Info.SkinId = TempRoleInfo.SkinId
  Info.FromOtherWorld = true
  Info.AppearanceSuit = TempRoleInfo.AppearanceSuit
  print(_G.LogTag, " HandChangeRoleInfo", TempRoleInfo.AppearanceSuit)
  Player:InitCharacterInfoForRegionPlayer(Info)
  if Player.MeleeWeapon then
    Player:ChangeUsingWeaponByType("Melee")
  end
end

function Component:HandleSwitchWeapon(ObjId, Message, Type)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncChangeWeaponInfo(ObjId, Message, Type)
    return
  end
  if not ObjId then
    self.logger.debug("[RegionOnline] HandleChangeUsingWeaponType is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if not TempRoleInfo then
    self.logger.debug("[RegionOnline] There is no avatar in this region ", ObjId)
    return
  end
  if not TempRoleInfo.BornState then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  if TempRoleInfo.BornState < Const.Borning then
    return
  end
  if TempRoleInfo.BornState < Const.Bonred then
    return
  end
  if not TempRoleInfo.CharEid then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  local Player = Battle(self):GetEntity(TempRoleInfo.CharEid)
  if not Player then
    self.logger.error("[RegionOnline] Role Doesn't exist In This World ", ObjId)
    return
  end
  if not Player.ServerSetUpWeapons then
    self.logger.error("[RegionOnline] It's not a character ", ObjId)
    return
  end
  if Player[Type .. "Weapon"] then
    Player:RemoveWeaponWithId(Player[Type .. "Weapon"].WeaponId)
  end
  local TempWeaponInfo = {}
  Utils.FormatWeaponInfo(TempWeaponInfo, Message.WeaponInfo)
  print(_G.LogTag, " HandleChangeUsingWeaponType", "ServerSetUp" .. Type .. "Weapon", Player["ServerSetUp" .. Type .. "Weapon"])
  Player["ServerSetUp" .. Type .. "Weapon"](Player, TempWeaponInfo)
  Player:ChangeUsingWeaponByType("Melee")
end

function Component:HandleChangeUsingWeaponType(ObjId, RoleInfo)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncChangeUsingWeaponType(ObjId, RoleInfo)
    return
  end
  if not ObjId then
    self.logger.debug("[RegionOnline] HandleChangeUsingWeaponType is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if not TempRoleInfo then
    self.logger.debug("[RegionOnline] There is no avatar in this region ", ObjId)
    return
  end
  if not TempRoleInfo.BornState then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  if TempRoleInfo.BornState < Const.Borning then
    return
  end
  if TempRoleInfo.BornState < Const.Bonred then
    return
  end
  if not TempRoleInfo.CharEid then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  local Player = Battle(self):GetEntity(TempRoleInfo.CharEid)
  if not Player then
    self.logger.error("[RegionOnline] Role Doesn't exist In This World ", ObjId)
    return
  end
  if not Player.ChangeUsingWeaponByType then
    self.logger.error("[RegionOnline] It's not a character ", ObjId)
    return
  end
  if RoleInfo.ShowWeapon and Player[RoleInfo.ShowWeapon .. "Weapon"] then
    Player:ChangeUsingWeaponByType(RoleInfo.ShowWeapon)
  end
end

function Component:HandleMovePack(ObjId, MoveInfo)
  if LuaConst.RegionSyncSubsysEnable then
    self:RegionSyncUpdateMoveInfo(ObjId, MoveInfo)
    return
  end
  if not ObjId then
    self.logger.debug("[RegionOnline] MovePack is Illegal ObjectId is nil")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if not TempRoleInfo then
    self.logger.debug("[RegionOnline] There is no avatar in this region ", ObjId)
    return
  end
  if not TempRoleInfo.BornState then
    self.logger.error("[RegionOnline] Role Havent create yet ", ObjId)
    return
  end
  if TempRoleInfo.BornState == Const.ShouldDetory then
    return
  end
  if TempRoleInfo.BornState < Const.Borning then
    self:SpawnOtherRole(ObjId, MoveInfo)
    return
  end
  if TempRoleInfo.BornState < Const.Bonred then
    return
  end
  local sender_info = self.RegionAvatars[ObjId]
  local Player = Battle(self):GetEntity(TempRoleInfo.CharEid)
  local GameInstance = GWorld.GameInstance
  local MainPlayer = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  if Player then
    Player:PackSyncInfo(MoveInfo, MainPlayer)
    if Player.CurResourceId == MoveInfo.ExpressionId then
      return
    end
    if MoveInfo.ExpressionId then
      Player.CurResourceId = MoveInfo.ExpressionId
    end
  elseif GameInstance and GameInstance.bRegionClientOnlyShowUI then
    GameInstance:SyncPlayerHeadUI(TempRoleInfo.CharEid, FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z))
  end
end

function Component:HandleActionPack(ObjId, MoveInfo)
  if LuaConst.RegionSyncSubsysEnable then
    local RoleInfo = self:GetRoleInfo(ObjId)
    if RoleInfo and MoveInfo.ActionBaseInfo then
      local CrouchInt = MoveInfo.ActionBaseInfo.IsCrouching
      RoleInfo.IsCrouching = nil ~= CrouchInt and CrouchInt > 0.1
      print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success", RoleInfo.IsCrouching, CrouchInt)
    end
    local Player = self:GetBornedChar(ObjId)
    if not Player then
      return
    end
    print(_G.LogTag, " HandleActionPack", "IsCrouching", Player)
    if MoveInfo.ActionBaseInfo then
      Player:UpdateActionLocAndRot(MoveInfo)
    end
    local IsStateFeature = Player:IsStateFeature(MoveInfo)
    Player:CacheAction("ReceivePrepareInfo_Lua", MoveInfo)
    if Player:CanRegionSyncDoAction_Immeditately() or IsStateFeature then
      print(_G.LogTag, "[RegionOnline] DoRegionCacheAction DoAction_Immeditately", IsStateFeature, MoveInfo.ClassName)
      Player:DoRegionCacheAction()
    else
      print(_G.LogTag, "[RegionOnline] DoRegionCacheAction CacheAction", MoveInfo.ClassName)
    end
    return
  end
end

function Component:HandleHidePack(ObjId, MoveInfo)
  if LuaConst.RegionSyncSubsysEnable then
    print(_G.LogTag, "ReceiveHideInfo_LuaHandleHidePack", MoveInfo.ActorVisible)
    local Player = self:GetBornedChar(ObjId)
    if Player then
      Player:ReceiveHideInfo_Lua(MoveInfo)
    end
    return
  end
end

function Component:ReceiveStopActionPack(ObjId, SyncInfo)
  if LuaConst.RegionSyncSubsysEnable then
    local RoleInfo = self:GetRoleInfo(ObjId)
    if RoleInfo and SyncInfo.ActionBaseInfo then
      local CrouchInt = SyncInfo.ActionBaseInfo.IsCrouching
      RoleInfo.IsCrouching = nil ~= CrouchInt and CrouchInt > 0.1
    end
    local Player = self:GetBornedChar(ObjId)
    if Player then
      Player:ReceiveStopActionInfo_Lua(SyncInfo)
    end
    return
  end
end

function Component:SpawnOtherRole(ObjId, MoveInfo)
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  local GameInstance = GWorld.GameInstance
  print(_G.LogTag, " SpawnOtherRole", GameInstance.OtherRoleCanCreatePerTick)
  if GameInstance.OtherRoleCanCreatePerTick and GameInstance.OtherRoleCanCreatePerTick <= 0 then
    return
  end
  TempRoleInfo.BornState = Const.Borning
  GameInstance:SpawnOtherRole(ObjId, TempRoleInfo, MoveInfo)
  if GameInstance.OtherRoleCanCreatePerTick then
    GameInstance.OtherRoleCanCreatePerTick = GameInstance.OtherRoleCanCreatePerTick - 1
  end
end

function Component:RegionSyncSystemValid(ObjId)
  if not ObjId then
    self.logger.error("[RegionOnline] EnterWorldRole is Illegal ObjectId is nil")
    return false
  end
  local GameInstance = GWorld.GameInstance
  if not GameInstance then
    self.logger.error("[RegionOnline] Game Not Start Yet, GameInstance is nil")
    return false
  end
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  if not RegionSycnSubsys then
    self.logger.error("[RegionOnline] RegionSycnSubsys is nil")
    return false
  end
  return true
end

function Component:RegionSyncAddRoleToCreate(ObjId, RoleInfo)
  DebugPrint("[RegionOnline] RegionSyncAddRoleToCreate", ObjId, RoleInfo)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:CanAddThisRole(ObjIdStr) then
    self.logger.error("[RegionOnline] RegionSycnSubsys:CanAddThisRole is false")
    return
  end
  local Location = Const.ZeroVector
  local Rotation = Const.ZeroRotator
  if RoleInfo.ActionBaseInfo and RoleInfo.ActionBaseInfo.Location then
    Location = FVector(RoleInfo.ActionBaseInfo.Location.X, RoleInfo.ActionBaseInfo.Location.Y, RoleInfo.ActionBaseInfo.Location.Z)
  end
  if RoleInfo.ActionBaseInfo and RoleInfo.ActionBaseInfo.Rotation then
    Rotation = FRotator(RoleInfo.ActionBaseInfo.Rotation.Pitch, RoleInfo.ActionBaseInfo.Rotation.Yaw, RoleInfo.ActionBaseInfo.Rotation.Roll)
  end
  local bIsTeamMember = false
  if TeamController and TeamController:GetModel() then
    local Team = TeamController:GetModel():GetTeam() or {}
    for _, TeamMember in pairs(Team.Members or {}) do
      if TeamMember and TeamMember.Eid == ObjId then
        bIsTeamMember = true
        break
      end
    end
  end
  DebugPrint("[RegionOnline] RegionSyncUpdate AddRoleToCreate At ", ObjId, Location, Rotation)
  RegionSycnSubsys:AddRoleToRegionSys(ObjIdStr, Location, Rotation, bIsTeamMember)
  self.OtherRoleInfo[ObjId] = {}
  local CharInfo = RoleInfo.CharInfo
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  TempRoleInfo.IsCrouching = false
  if RoleInfo.ActionBaseInfo then
    local CrouchInt = RoleInfo.ActionBaseInfo.IsCrouching
    TempRoleInfo.IsCrouching = nil ~= CrouchInt and CrouchInt > 0.1
    print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success", TempRoleInfo.IsCrouching, CrouchInt)
    TempRoleInfo.ForceSyncLocation = RoleInfo.ActionBaseInfo.ForceSyncLocation
  end
  TempRoleInfo.FromOtherWorld = true
  TempRoleInfo.ObjectId = ObjId
  TempRoleInfo.RoleId = CharInfo.CharId
  TempRoleInfo.SkinId = CharInfo.SkinId
  TempRoleInfo.Uid = RoleInfo.AvatarInfo.Uid
  TempRoleInfo.AppearanceSuit = {}
  TempRoleInfo.CurrentPet = RoleInfo.CurrentPet
  TempRoleInfo.CurResourceId = RoleInfo.CurResourceId
  TempRoleInfo.CurrentState = RoleInfo.CurrentState
  TempRoleInfo.MountDatas = {}
  local MountData = TempRoleInfo.MountDatas
  MountData.MountId = RoleInfo.MountDatas.MountId
  MountData.MountState = RoleInfo.MountDatas.MountState
  local SuitTalble = TempRoleInfo.AppearanceSuit
  SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
  SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
  SuitTalble.AccessorySuit = CharInfo.AccessorySuit
  SuitTalble.Colors = CharInfo.Colors
  SuitTalble.SkinId = CharInfo.SkinId
  if RoleInfo.WeaponInfo then
    local MeleeWeapon = {}
    if RoleInfo.WeaponInfo.MeleeWeapon then
      Utils.FormatWeaponInfo(MeleeWeapon, RoleInfo.WeaponInfo.MeleeWeapon)
    end
    TempRoleInfo.MeleeWeapon = MeleeWeapon
    local RangedWeapon = {}
    if RoleInfo.WeaponInfo.RangedWeapon then
      Utils.FormatWeaponInfo(RangedWeapon, RoleInfo.WeaponInfo.RangedWeapon)
    end
    TempRoleInfo.RangedWeapon = RangedWeapon
  end
  TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon
  PrintTable({
    CZC_AddRoleToCreate_RoleInfo = TempRoleInfo,
    RoleInfo = RoleInfo,
    AvatarId = ObjId
  }, 100)
end

function Component:RegionSyncChangeRoleInfo(ObjId, RoleInfo)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
    return
  end
  if not self.OtherRoleInfo[ObjId] then
    self.logger.error("Init Info is empty ", ObjId)
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  local CharInfo = RoleInfo.CharInfo
  TempRoleInfo.ObjectId = ObjId
  TempRoleInfo.RoleId = CharInfo.CharId
  TempRoleInfo.SkinId = CharInfo.SkinId
  TempRoleInfo.AppearanceSuit = {}
  local SuitTalble = TempRoleInfo.AppearanceSuit
  SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
  SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
  SuitTalble.AccessorySuit = CharInfo.AccessorySuit
  SuitTalble.Colors = CharInfo.Colors
  SuitTalble.SkinId = CharInfo.SkinId
  if RoleInfo.WeaponInfo then
    local MeleeWeapon = {}
    if RoleInfo.WeaponInfo.MeleeWeapon then
      Utils.FormatWeaponInfo(MeleeWeapon, RoleInfo.WeaponInfo.MeleeWeapon)
    end
    TempRoleInfo.MeleeWeapon = MeleeWeapon
    local RangedWeapon = {}
    if RoleInfo.WeaponInfo.RangedWeapon then
      Utils.FormatWeaponInfo(RangedWeapon, RoleInfo.WeaponInfo.RangedWeapon)
    end
    TempRoleInfo.RangedWeapon = RangedWeapon
  end
  TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon or "Melee"
  TempRoleInfo.IsCrouching = false
  PrintTable({
    RoleInfoUpdated = TempRoleInfo,
    AvatarId = ObjId,
    BornState = RegionSycnSubsys:GetRoleBornState(ObjIdStr)
  }, 100)
  if RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WatiForPreload then
    return
  end
  RegionSycnSubsys:OnRoleInfoNeedUpdate(ObjIdStr)
end

function Component:RegionSyncChangeWeaponInfo(ObjId, Message, Type)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
    return
  end
  if not self.OtherRoleInfo[ObjId] then
    self.logger.error("Init Info is empty ", ObjId)
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if Message.WeaponInfo then
    local TempWeaponInfo = {}
    Utils.FormatWeaponInfo(TempWeaponInfo, Message.WeaponInfo)
    TempRoleInfo[Type .. "Weapon"] = TempWeaponInfo
  end
  TempRoleInfo.ShowWeapon = "Melee"
  PrintTable({
    WeaponInfoUpdated = TempRoleInfo,
    AvatarId = ObjId,
    BornState = RegionSycnSubsys:GetRoleBornState(ObjIdStr)
  }, 100)
  if RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WatiForPreload then
    return
  end
  RegionSycnSubsys:OnRoleInfoNeedUpdate(ObjIdStr)
end

function Component:RegionSyncChangeUsingWeaponType(ObjId, RoleInfo)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
    return
  end
  if not self.OtherRoleInfo[ObjId] then
    self.logger.error("Init Info is empty ", ObjId)
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  TempRoleInfo.ShowWeapon = RoleInfo.ShowWeapon
  if RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WaitForBorn then
    return
  end
  local BornedChar = RegionSycnSubsys:GetBornedChar(ObjIdStr)
  if not BornedChar then
    self.logger.error("Character is not Created yet", ObjId)
    return
  end
  if not BornedChar[RoleInfo.ShowWeapon .. "Weapon"] then
    self.logger.error("Character Doesn't have this weapon ", RoleInfo.ShowWeapon, ObjId)
    return
  end
  BornedChar:ChangeUsingWeaponByType(RoleInfo.ShowWeapon)
end

function Component:RegionSyncUpdateMoveInfo(ObjId, MoveInfo)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if TempRoleInfo then
    TempRoleInfo.CurResourceId = MoveInfo.CurResourceId
  end
  local ActorLoc = FVector(MoveInfo.Location.X, MoveInfo.Location.Y, MoveInfo.Location.Z)
  local ActorRot = FRotator(MoveInfo.Rotation.Pitch, MoveInfo.Rotation.Yaw, MoveInfo.Rotation.Roll)
  RegionSycnSubsys:UpdateRoleLocAndRot(ObjIdStr, ActorLoc, ActorRot)
  if RegionSycnSubsys:GetRoleBornState(ObjIdStr) <= UE4.ERegionCharBornState.EBS_WaitForBorn then
    return
  end
  local BornedChar = RegionSycnSubsys:GetBornedChar(ObjIdStr)
  if not BornedChar then
    self.logger.error("Character is not Created yet", ObjId)
    return
  end
  MoveInfo.IsCrouching = TempRoleInfo.IsCrouching
  BornedChar:UpdateCharacterMoveInfo(MoveInfo)
  if RegionSycnSubsys.LocalPlayerChar then
    RegionSycnSubsys.LocalPlayerChar:CanPlayerBeInterCandidate(BornedChar.Eid, ActorLoc)
  end
end

function Component:RegionSyncRemoveRoleAndDestroy(ObjId, RoleInfo)
  if not self:RegionSyncSystemValid(ObjId) then
    return
  end
  local GameInstance = GWorld.GameInstance
  local RegionSycnSubsys = UE4.URegionSyncSubsystem.GetInstance(GameInstance)
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  if not RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    self.logger.error("RegionSycnSubsys:ObjIdValidation is false")
    return
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if TempRoleInfo then
    EventManager:FireEvent(EventID.OnlineRemoveOtherPlayer, TempRoleInfo.Uid)
    self.OtherRoleInfo[ObjId] = nil
  end
  RegionSycnSubsys:RemoveRoleBornInfo(ObjIdStr, true)
  if TempRoleInfo then
    EventManager:FireEvent(EventID.RemoveRegionIndicatorInfo, TempRoleInfo.Uid)
  end
end

return Component
