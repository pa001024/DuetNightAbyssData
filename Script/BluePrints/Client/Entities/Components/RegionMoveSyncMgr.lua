local Decorator = require("BluePrints.Client.Wrapper.Decorator")
local Component = {}
local LuaConst = require("EMLuaConst")

local function ClearMountPassengerData(MountData)
  if not MountData then
    return
  end
  MountData.IsMountPassenger = nil
  MountData.PassengerDriverEid = nil
  MountData.PassengerSocketName = nil
end

local function CopyMountPassengerData(ToMountData, FromMountData)
  if not ToMountData or not FromMountData then
    return
  end
  if not LuaConst.bEnableMountPassenger then
    ClearMountPassengerData(ToMountData)
    return
  end
  ToMountData.PassengerDriverEid = FromMountData.PassengerDriverEid or FromMountData.DriverEid or FromMountData.OwnerEid
  ToMountData.PassengerSocketName = FromMountData.PassengerSocketName or FromMountData.SocketName or FromMountData.AttachSocket
  if FromMountData.IsMountPassenger ~= nil then
    ToMountData.IsMountPassenger = FromMountData.IsMountPassenger == true or type(FromMountData.IsMountPassenger) == "number" and 0 ~= FromMountData.IsMountPassenger
  else
    ToMountData.IsMountPassenger = ToMountData.PassengerDriverEid ~= nil and 0 ~= ToMountData.PassengerDriverEid
  end
end

local function ToBoolFlag(Value)
  if nil == Value then
    return nil
  end
  if type(Value) == "number" then
    return 0 ~= Value
  end
  return true == Value
end

local function GetOnlineChar(ComponentSelf, ObjId)
  if ObjId == ComponentSelf.Eid then
    return UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  end
  return ComponentSelf:GetBornedChar(ObjId)
end

local function GetPassengerObjId(Message, DefaultObjId)
  if not Message then
    return DefaultObjId
  end
  return Message.PassengerEid or Message.PassengerId or Message.PassengerObjId or Message.RequestEid or DefaultObjId
end

local function GetDriverObjId(Message)
  if not Message then
    return nil
  end
  return Message.PassengerDriverEid or Message.DriverEid or Message.OwnerEid or Message.Sender
end

local function GetPassengerSocketName(Message)
  if not Message then
    return nil
  end
  return Message.PassengerSocketName or Message.SocketName or Message.AttachSocket
end

local function GetRideOnState(Message, DefaultState)
  if not Message then
    return DefaultState
  end
  local IsRideOn = ToBoolFlag(Message.IsRideOn)
  if nil == IsRideOn and nil ~= Message.IsMountPassenger then
    IsRideOn = ToBoolFlag(Message.IsMountPassenger)
  end
  if nil == IsRideOn and nil ~= Message.State then
    IsRideOn = 0 ~= Message.State
  end
  if nil == IsRideOn then
    IsRideOn = DefaultState
  end
  return IsRideOn
end

function Component:InitMoveSyncMgr()
  self.OtherRoleInfo = {}
  self.LocalMountPassengerInfo = nil
end

function Component:DestoryAllOthers()
  if not self.OtherRoleInfo then
    return
  end
  for k, v in pairs(self.OtherRoleInfo) do
    self:RegionSyncRemoveRoleAndDestroy(v.ObjectId, v)
  end
  self.OtherRoleInfo = {}
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

function Component:HandleActionPack(ObjId, MoveInfo)
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
end

function Component:HandleHidePack(ObjId, MoveInfo)
  print(_G.LogTag, "ReceiveHideInfo_LuaHandleHidePack", MoveInfo.ActorVisible)
  local Player = self:GetBornedChar(ObjId)
  if Player then
    Player:ReceiveHideInfo_Lua(MoveInfo)
  end
end

function Component:ReceiveStopActionPack(ObjId, SyncInfo)
  local RoleInfo = self:GetRoleInfo(ObjId)
  if RoleInfo and SyncInfo.ActionBaseInfo then
    local CrouchInt = SyncInfo.ActionBaseInfo.IsCrouching
    RoleInfo.IsCrouching = nil ~= CrouchInt and CrouchInt > 0.1
  end
  local Player = self:GetBornedChar(ObjId)
  if Player then
    Player:ReceiveStopActionInfo_Lua(SyncInfo)
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
  TempRoleInfo.HairId = CharInfo.HairId
  TempRoleInfo.Uid = RoleInfo.AvatarInfo.Uid
  TempRoleInfo.AppearanceSuit = {}
  TempRoleInfo.CurrentPet = RoleInfo.CurrentPet
  TempRoleInfo.ShowPet = RoleInfo.ShowPet
  TempRoleInfo.CurResourceId = RoleInfo.CurResourceId
  TempRoleInfo.CurrentState = RoleInfo.CurrentState
  TempRoleInfo.MountDatas = {}
  local MountData = TempRoleInfo.MountDatas
  MountData.MountId = RoleInfo.MountDatas.MountId
  MountData.MountState = RoleInfo.MountDatas.MountState
  CopyMountPassengerData(MountData, RoleInfo.MountDatas)
  local InResource = TempRoleInfo.CurResourceId and 0 ~= TempRoleInfo.CurResourceId
  local InState = TempRoleInfo.CurrentState and 0 ~= TempRoleInfo.CurrentState
  local InMount = TempRoleInfo.MountDatas and TempRoleInfo.MountDatas.MountId and 0 ~= TempRoleInfo.MountDatas.MountId
  if InResource or InState or InMount then
    TempRoleInfo.IsCrouching = false
  end
  local SuitTalble = TempRoleInfo.AppearanceSuit
  SuitTalble.IsCornerVisible = CharInfo.IsCornerVisible
  SuitTalble.IsShowPartMesh = CharInfo.IsShowPartMesh
  SuitTalble.AccessorySuit = CharInfo.AccessorySuit
  SuitTalble.Colors = CharInfo.Colors
  SuitTalble.SkinId = CharInfo.SkinId
  SuitTalble.HairId = CharInfo.HairId
  SuitTalble.SkinLevel = CharInfo.SkinLevel
  SuitTalble.HairColors = CharInfo.HairColors
  SuitTalble.AccessoryCustomParams = CharInfo.AccessoryCustomParams
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
  SuitTalble.SkinLevel = CharInfo.SkinLevel
  SuitTalble.HairId = CharInfo.HairId
  SuitTalble.HairColors = CharInfo.HairColors
  SuitTalble.AccessoryCustomParams = CharInfo.AccessoryCustomParams
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
  TempRoleInfo.ReInit = true
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
  if MoveInfo.ActionBaseInfo then
    local CrouchInt = MoveInfo.ActionBaseInfo.IsCrouching
    TempRoleInfo.IsCrouching = nil ~= CrouchInt and CrouchInt > 0.1
    print(_G.LogTag, "RegionPlayerInitInfo Spawn Other Player Character Success", TempRoleInfo.IsCrouching, CrouchInt)
  end
  MoveInfo.IsCrouching = TempRoleInfo.IsCrouching
  local BornedChar = RegionSycnSubsys:GetBornedChar(ObjIdStr)
  if not BornedChar then
    self.logger.error("Character is not Created yet", ObjId)
    return
  end
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
  if RegionSycnSubsys:ObjIdValidation(ObjIdStr) then
    RegionSycnSubsys:RemoveRoleBornInfo(ObjIdStr, true)
  end
  local TempRoleInfo = self.OtherRoleInfo[ObjId]
  if TempRoleInfo then
    EventManager:FireEvent(EventID.OnlineRemoveOtherPlayer, TempRoleInfo.Uid)
    self.OtherRoleInfo[ObjId] = nil
  end
  if TempRoleInfo then
    EventManager:FireEvent(EventID.RemoveRegionIndicatorInfo, TempRoleInfo.Uid)
  end
end

function Component:RegionSyncGetOnlineChar(ObjId)
  return GetOnlineChar(self, ObjId)
end

function Component:RegionSyncCacheMountPassengerState(PassengerObjId, DriverObjId, bRideOn, SocketName)
  if not PassengerObjId then
    return
  end
  if PassengerObjId == self.Eid then
    if not LuaConst.bEnableMountPassenger then
      self.LocalMountPassengerInfo = nil
      return
    end
    self.LocalMountPassengerInfo = self.LocalMountPassengerInfo or {}
    self.LocalMountPassengerInfo.IsMountPassenger = true == bRideOn and nil ~= DriverObjId and 0 ~= DriverObjId
    self.LocalMountPassengerInfo.PassengerDriverEid = self.LocalMountPassengerInfo.IsMountPassenger and DriverObjId or nil
    self.LocalMountPassengerInfo.PassengerSocketName = self.LocalMountPassengerInfo.IsMountPassenger and SocketName or nil
    return
  end
  local TempRoleInfo = self:GetRoleInfo(PassengerObjId)
  if not TempRoleInfo then
    return
  end
  TempRoleInfo.MountDatas = TempRoleInfo.MountDatas or {}
  if not LuaConst.bEnableMountPassenger then
    ClearMountPassengerData(TempRoleInfo.MountDatas)
    return
  end
  TempRoleInfo.MountDatas.IsMountPassenger = true == bRideOn and nil ~= DriverObjId and 0 ~= DriverObjId
  TempRoleInfo.MountDatas.PassengerDriverEid = TempRoleInfo.MountDatas.IsMountPassenger and DriverObjId or nil
  TempRoleInfo.MountDatas.PassengerSocketName = TempRoleInfo.MountDatas.IsMountPassenger and SocketName or nil
  if TempRoleInfo.MountDatas.IsMountPassenger then
    TempRoleInfo.IsCrouching = false
  end
end

function Component:RegionSyncApplyMountPassengerState(PassengerObjId, DriverObjId, bRideOn, SocketName)
  if not PassengerObjId then
    return
  end
  if not LuaConst.bEnableMountPassenger then
    self:RegionSyncCacheMountPassengerState(PassengerObjId, nil, false)
    return
  end
  self:RegionSyncCacheMountPassengerState(PassengerObjId, DriverObjId, bRideOn, SocketName)
  local Passenger = GetOnlineChar(self, PassengerObjId)
  if not Passenger then
    return
  end
  if not (false ~= bRideOn and DriverObjId) or 0 == DriverObjId then
    Passenger:ReceiveMountPassengerState_Lua(false)
    return
  end
  local Driver = GetOnlineChar(self, DriverObjId)
  if Driver then
    Passenger:ReceiveMountPassengerState_Lua(true, Driver, SocketName)
  end
end

function Component:RegionSyncHandleMountPassengerChange(Message)
  if not LuaConst.bEnableMountPassenger then
    return
  end
  local PassengerObjId = GetPassengerObjId(Message)
  if not PassengerObjId then
    return
  end
  local DriverObjId = GetDriverObjId(Message)
  local bRideOn = GetRideOnState(Message, true)
  local SocketName = GetPassengerSocketName(Message)
  self:RegionSyncApplyMountPassengerState(PassengerObjId, DriverObjId, bRideOn, SocketName)
end

function Component:RegionSyncHandleMountPassengerRideOn(Message)
  if not LuaConst.bEnableMountPassenger then
    return
  end
  local PassengerObjId = GetPassengerObjId(Message)
  if not PassengerObjId then
    return
  end
  self:RegionSyncApplyMountPassengerState(PassengerObjId, GetDriverObjId(Message), true, GetPassengerSocketName(Message))
end

function Component:RegionSyncHandleMountPassengerRideOff(Message)
  if not LuaConst.bEnableMountPassenger then
    return
  end
  local PassengerObjId = GetPassengerObjId(Message, self.Eid)
  if not PassengerObjId then
    return
  end
  self:RegionSyncApplyMountPassengerState(PassengerObjId, GetDriverObjId(Message), false, GetPassengerSocketName(Message))
end

function Component:RegionSyncClearMountPassengersByDriver(DriverObjId)
  if not LuaConst.bEnableMountPassenger then
    return
  end
  if not DriverObjId then
    return
  end
  for PassengerObjId, OtherRoleInfo in pairs(self.OtherRoleInfo or {}) do
    if OtherRoleInfo.MountDatas and OtherRoleInfo.MountDatas.PassengerDriverEid == DriverObjId then
      self:RegionSyncApplyMountPassengerState(PassengerObjId, DriverObjId, false)
    end
  end
  if self.Eid ~= DriverObjId then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if Player and (Player.PassengerMountDriver and Player.PassengerMountDriver.Eid == DriverObjId or self.LocalMountPassengerInfo and self.LocalMountPassengerInfo.PassengerDriverEid == DriverObjId) then
      self:RegionSyncCacheMountPassengerState(self.Eid, DriverObjId, false)
      Player:ReceiveMountPassengerState_Lua(false)
    end
  end
end

function Component:RegionSyncRetryAttachMountPassengers(DriverObjId)
  if not LuaConst.bEnableMountPassenger then
    return
  end
  if not DriverObjId then
    return
  end
  local Driver = GetOnlineChar(self, DriverObjId)
  if not Driver then
    return
  end
  for PassengerObjId, OtherRoleInfo in pairs(self.OtherRoleInfo or {}) do
    if OtherRoleInfo.MountDatas and OtherRoleInfo.MountDatas.IsMountPassenger and OtherRoleInfo.MountDatas.PassengerDriverEid == DriverObjId then
      local Passenger = GetOnlineChar(self, PassengerObjId)
      if Passenger then
        Passenger:ReceiveMountPassengerState_Lua(true, Driver, OtherRoleInfo.MountDatas.PassengerSocketName)
      end
    end
  end
  if self.LocalMountPassengerInfo and self.LocalMountPassengerInfo.IsMountPassenger and self.LocalMountPassengerInfo.PassengerDriverEid == DriverObjId then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if Player then
      Player:ReceiveMountPassengerState_Lua(true, Driver, self.LocalMountPassengerInfo.PassengerSocketName)
    end
  end
end

return Component
