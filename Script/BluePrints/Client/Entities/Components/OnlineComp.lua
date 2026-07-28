local pb = require("pb")
local Decorator = require("BluePrints.Client.Wrapper.Decorator")
local LuaConst = require("EMLuaConst")
local MessageTypeToFunc = {
  EnterRegionOnline = "HandleEnterRegionOnline",
  LeaveRegionOnline = "HandleLeaveRegionOnline",
  Move = "HandleMove",
  Action = "HandleAction",
  StopAction = "HandleStopAction",
  Hide = "HandleHide",
  NicknameChange = "HandleNicknameChange",
  LevelChange = "HandleLevelChange",
  CurrentPetChange = "HandleCurrentPetChange",
  CharInfoChange = "HandleCharInfoChange",
  UseExpression = "HandleUseExpression",
  TitleChange = "HandleTitleChange",
  OnLeaveRegionOnlineItem = "HandleOnLeaveRegionOnlineItem",
  OnUseRegionOnlineItem = "HandleOnUseRegionOnlineItem",
  OnChangeRegionOnlineItemState = "HandleOnChangeRegionOnlineItemState",
  OnDeadRegionOnlineItem = "HandleOnDeadRegionOnlineItem",
  OnUseCreateMount = "HandleOnUseCreateMount",
  OnDeadRegionOnlineMount = "HandleOnDeadRegionOnlineMount",
  OnChangeRegionOnlineMount = "HandleOnChangeRegionOnlineMount",
  ShareMountDatasChange = "HandleShareMountDatasChange",
  SwitchMeleeWeapon = "HandleSwitchMeleeWeapon",
  SwitchRangedWeapon = "HandleSwitchRangedWeapon",
  SwitchShowWeapon = "HandleSwitchShowWeapon",
  SwitchShowPet = "HandleSwitchShowPet",
  UseGouSuo = "HandleUseGouSuo",
  SwitchOnlineState = "HandleSwitchOnlineState",
  HeadFrame = "HandleHeadFrame",
  HeadIcon = "HandleHeadIcon",
  TransformAFDay = "HandleTransformAFDay",
  HyperWeaponLevelUp = "HandleHyperWeaponLevelUp",
  SwitchAutoAgreeInvite = "HandleSwitchAutoAgreeInvite",
  GuildRegionOnlineHeatSync = "HandleGuildRegionOnlineHeatSync"
}
local Component = {}

local function GetOnlineChar(ComponentSelf, ObjId)
  if ObjId == ComponentSelf.Eid then
    return UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  end
  return ComponentSelf:GetBornedChar(ObjId)
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

function Component:EnterWorld()
  self.IsInRegionOnline = false
  self.CurrentOnlineType = -1
  self.PreEnterSubRegionId = -1
  self.CurrentGuildId = nil
  self.RegionAvatars = {}
  self:InitMoveSyncMgr()
  self:InitGuildExhibitMgr()
end

function Component:RequestEnterOnline(online_type, ShowWeapon, CurrentState, PlayerInfo)
  self.logger.debug("[OnlineComp] CZC RequestEnterOnline: " .. online_type, self.IsInRegionOnline)
  self.PreEnterSubRegionId = online_type
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local MountInfo = {
    MountId = Player.CurrentMountId,
    MountState = 0
  }
  if LuaConst.bEnableMountPassenger then
    MountInfo.IsMountPassenger = Player:IsMountPassenger()
    MountInfo.PassengerDriverEid = Player.PassengerMountDriver and Player.PassengerMountDriver.Eid or 0
  end
  local RegionPlayerInfo = {
    MountInfo = MountInfo,
    WeaponInfo = {
      ShowWeapon = ShowWeapon or CommonConst.OnlineShowWeapon.Melee
    },
    UseMechanism = {UseState = 0, UniqueId = 0},
    CurrentState = CurrentState or CommonConst.OnlineState.Normal,
    UseTargetParam = {},
    ActionBaseInfo = Player:GetPlayerLocationAndRotation()
  }
  self:CallServerMethod("RequestEnterOnline", online_type, RegionPlayerInfo)
end

function Component:RequestEnterGuildOnline(GuildId, ShowWeapon, CurrentState, StartPointIndex)
  self.logger.debug("[OnlineComp] CZC RequestEnterGuildOnline: " .. tostring(GuildId), self.IsInRegionOnline)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local RegionPlayerInfo = {
    MountInfo = {
      MountId = Player.CurrentMountId,
      MountState = 0
    },
    WeaponInfo = {
      ShowWeapon = ShowWeapon or CommonConst.OnlineShowWeapon.Melee
    },
    UseMechanism = {UseState = 0, UniqueId = 0},
    CurrentState = CurrentState or CommonConst.OnlineState.Normal,
    UseTargetParam = {},
    ActionBaseInfo = Player:GetPlayerLocationAndRotation()
  }
  self:CallServerMethod("RequestEnterGuildOnline", GuildId, StartPointIndex or 1, RegionPlayerInfo)
end

function Component:OnRequestEnterOnline(online_type, ret, others, GlobalRegionItemCache, online_id)
  self.logger.debug("[OnlineComp] CZC OnRequestEnterOnline: " .. online_type .. " ret: " .. ret .. " online_id" .. (online_id or "nil"))
  if ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  self:NotifyCharacterStartSync(online_type)
  self.IsInRegionOnline = true
  self.PreEnterSubRegionId = -1
  self.RegionAvatars = others
  self.CurrentOnlineType = online_type
  self.GlobalRegionItemCache = GlobalRegionItemCache
  self:InitMechanismUser(GlobalRegionItemCache)
  if not others then
    return
  end
  PrintTable({OnRequestEnterOnline_others = others, GlobalRegionItemCache = GlobalRegionItemCache}, 10)
  for i, v in pairs(others) do
    self:RegionSyncAddRoleToCreate(i, v)
    self:InitOnlineStateData(i, v)
  end
  self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = true
  if ChatController then
    ChatController:SendRequestEnterChatChannel(ChatCommon.ChannelDef.Region, online_id, online_type)
  end
  local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  OnlineActionController:Init(true)
end

function Component:OnRequestEnterGuildOnline(GuildId, online_type, ret, others, GlobalRegionItemCache, online_id)
  self.logger.debug("[OnlineComp] CZC OnRequestEnterGuildOnline: GuildId=" .. tostring(GuildId) .. " online_type=" .. online_type .. " ret=" .. ret .. " online_id=" .. (online_id or "nil"))
  if ret ~= ErrorCode.RET_SUCCESS then
    if ChatController then
      ChatController:CheckError(ret, true)
    end
    return
  end
  online_type = tonumber(online_type .. GuildId)
  self.IsInRegionOnline = true
  self.CurrentGuildId = GuildId
  self.CurrentGuildOnlineHeat = 0
  self.CurrentGuildOnlineHeatSnapshot = nil
  self.PreEnterSubRegionId = -1
  self.RegionAvatars = others
  self.CurrentOnlineType = online_type
  self.GlobalRegionItemCache = GlobalRegionItemCache
  PrintTable({OnRequestEnterGuildOnline_others = others, GlobalRegionItemCache = GlobalRegionItemCache}, 10)
  if not self.InWorldChatChannel then
    self.InWorldChatChannel = {}
  end
  self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = true
end

function Component:RequestLeaveGuildOnline(GuildId)
  self.logger.debug("[OnlineComp] RequestLeaveOnline: " .. GuildId)
  self:CallServerMethod("RequestLeaveGuildOnline", GuildId)
end

function Component:OnRequestLeaveGuildOnline(GuildId, online_type, ret)
  self.logger.debug("[OnlineComp] OnRequestLeaveOnline: " .. online_type .. " ret: " .. ret, GuildId)
  if ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  self.CurrentGuildId = nil
  self.CurrentGuildOnlineHeat = 0
  self.CurrentGuildOnlineHeatSnapshot = nil
  self.IsInRegionOnline = false
  self.RegionAvatars = {}
  self.CurrentOnlineType = -1
  self.PreEnterSubRegionId = -1
  self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = false
end

function Component:ActiveSwitchToRegionOnlineChannel(online_type, online_id, ShowWeapon, CurrentState, PlayerInfo)
  self.logger.debug("[OnlineComp] CZC ActiveSwitchToRegionOnlineChannel: " .. online_type, online_id, self.IsInRegionOnline)
  self.PreEnterSubRegionId = online_type
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local MountInfo = {
    MountId = Player.CurrentMountId,
    MountState = 0
  }
  if LuaConst.bEnableMountPassenger then
    MountInfo.IsMountPassenger = Player:IsMountPassenger()
    MountInfo.PassengerDriverEid = Player.PassengerMountDriver and Player.PassengerMountDriver.Eid or 0
  end
  local RegionPlayerInfo = {
    MountInfo = MountInfo,
    WeaponInfo = {
      ShowWeapon = ShowWeapon or CommonConst.OnlineShowWeapon.Melee
    },
    UseMechanism = {UseState = 0, UniqueId = 0},
    CurrentState = CurrentState or CommonConst.OnlineState.Normal,
    UseTargetParam = {},
    ActionBaseInfo = Player:GetPlayerLocationAndRotation()
  }
  self:CallServerMethod("ActiveSwitchToRegionOnlineChannel", online_type, online_id, RegionPlayerInfo)
end

function Component:OnActiveSwitchToRegionOnlineChannel(online_type, online_id, ret, others, GlobalRegionItemCache)
  self.logger.debug(string.format("[OnlineComp] CZC OnActiveSwitchToRegionOnlineChannel: %s, id: %s ret: %s", online_type, online_id, ret))
  if ret ~= ErrorCode.RET_SUCCESS then
    if ChatController then
      ChatController:CheckError(ret, true)
    end
    return
  end
  self:NotifyCharacterStartSync(online_type)
  self.IsInRegionOnline = true
  self.PreEnterSubRegionId = -1
  self.RegionAvatars = others
  self.CurrentOnlineType = online_type
  self.GlobalRegionItemCache = GlobalRegionItemCache
  self:InitMechanismUser(GlobalRegionItemCache)
  if not others then
    return
  end
  PrintTable({OnRequestEnterOnline_others = others, GlobalRegionItemCache = GlobalRegionItemCache}, 10)
  for i, v in pairs(others) do
    self:RegionSyncAddRoleToCreate(i, v)
    self:InitOnlineStateData(i, v)
  end
  self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = true
  if ChatController then
    ChatController:SendRequestEnterChatChannel(ChatCommon.ChannelDef.Region, online_id, online_type)
  end
  local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  OnlineActionController:Init(true)
end

function Component:RequestLeaveOnline(online_type)
  self.logger.debug("[OnlineComp] CZC RequestLeaveOnline: " .. online_type)
  self:CallServerMethod("RequestLeaveOnline", online_type)
end

function Component:OnRequestLeaveOnline(online_type, ret)
  self.logger.debug("[OnlineComp] CZC OnRequestLeaveOnline: " .. online_type .. " ret: " .. ret)
  if ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  self:DestoryAllOthers()
  self:NotifyCharacterEndSync()
  self.IsInRegionOnline = false
  self.RegionAvatars = {}
  self.CurrentOnlineType = -1
  self.PreEnterSubRegionId = -1
  self.InWorldChatChannel[CommonConst.ChatChannel.RegionOnline] = false
  if ChatController then
    ChatController:SendRequestLeaveChatChannel(ChatCommon.ChannelDef.Region)
  end
  local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  if OnlineActionController then
    OnlineActionController:Destory()
  end
end

function Component:UseExpression(online_type, expression_id)
  DebugPrint("gmy@OnlineComp Component:UseExpression", online_type, expression_id)
end

function Component:GetActionMessage(real_message, message)
  for k, v in pairs(message.IntMap) do
    message[k] = v
  end
  for k, v in pairs(message.FloatMap) do
    message[k] = v
  end
  for k, v in pairs(message.EnumMap) do
    message[k] = v
  end
  for k, v in pairs(message.VectorMap) do
    message[k] = v
  end
  for k, v in pairs(message.RotatorMap) do
    message[k] = v
  end
  message.IntMap = nil
  message.FloatMap = nil
  message.EnumMap = nil
  message.VectorMap = nil
  message.RotatorMap = nil
  real_message.Action = message
end

function Component:UploadPlayerMessage(online_type, message)
  if not CommonConst.OnlineClientMessageType[message.Type] then
    return
  end
  local real_message = {}
  real_message.Type = message.Type
  if message.Type == "Action" and not message.UsingActionNew then
    self:GetActionMessage(real_message, message)
  else
    real_message[message.Type] = message
  end
  local message_str = pb.encode(".OnlineClientMessage", real_message)
  
  local function callback(ret)
  end
  
  self:CallServer("UploadPlayerOnlineClientMessage", callback, online_type, message_str)
end

function Component:RegionOnlineRequests(normal_messages, pb_messages)
  for i, message in ipairs(normal_messages) do
    self:HandleSingleRegionOnlineRequest(message)
  end
  for i, message_str in ipairs(pb_messages) do
    local message = pb.decode(".OnlineClientMessage", message_str)
    local real_message = message[message.Type]
    if real_message then
      real_message.Sender = message.Sender
      self:HandleSingleRegionOnlineRequest(real_message)
    end
  end
end

function Component:HandleSingleRegionOnlineRequest(message)
  local MType = message.Type
  local func = MessageTypeToFunc[MType]
  if func and self[func] then
    self[func](self, message)
  end
end

function Component:HandleGuildRegionOnlineHeatSync(message)
  local GuildId = tonumber(message.GuildId) or 0
  if GuildId <= 0 or tonumber(self.CurrentGuildId or 0) ~= GuildId then
    self.logger.debug("HandleGuildRegionOnlineHeatSync skip", GuildId, self.CurrentGuildId)
    return
  end
  self.CurrentGuildOnlineHeat = math.max(0, math.floor(tonumber(message.CurrentHeat) or 0))
  self.CurrentGuildOnlineHeatSnapshot = message.HeatSnapshot or {}
  self.logger.debug("HandleGuildRegionOnlineHeatSync", GuildId, self.CurrentGuildOnlineHeat, message.Reason)
end

function Component:HandleEnterRegionOnline(message)
  PrintTable({HandleEnterRegionOnline = message}, 10)
  self:RegionSyncAddRoleToCreate(message.Sender, message)
  self:InitOnlineStateData(message.Sender, message)
  self.RegionAvatars[message.Sender] = {
    CharInfo = message.CharInfo,
    CurrentPet = message.CurrentPet,
    ShowPet = message.ShowPet,
    AvatarInfo = message.AvatarInfo,
    RegionOnlineItem = message.RegionOnlineItem,
    GlobalRegionItemCache = message.GlobalRegionItemCache,
    AutoAgreeInvite = message.AutoAgreeInvite,
    MountDatas = message.MountDatas,
    ActionBaseInfo = message.ActionBaseInfo
  }
  DebugPrint("HandleEnterRegionOnline", message.Sender, message.AutoAgreeInvite, message.RegionOnlineItem, self.RegionAvatars[message.Sender])
  self:InitMechanismUser(message.GlobalRegionItemCache)
end

function Component:HandleLeaveRegionOnline(message)
  PrintTable({HandleLeaveRegionOnline = message}, 10)
  DebugPrint("HandleLeaveRegionOnline", message.Sender)
  self:HandleLeaveRegionMechanism(message)
  self:RegionSyncRemoveRoleAndDestroy(message.Sender, message)
  self.RegionAvatars[message.Sender] = nil
  if self.DeliveryStates then
    self.DeliveryStates[message.Sender] = nil
  end
end

function Component:HandleSwitchMeleeWeapon(message)
  PrintTable({HandleSwitchMeleeWeapon = message}, 10)
  self:RegionSyncChangeWeaponInfo(message.Sender, message, "Melee")
end

function Component:HandleSwitchRangedWeapon(message)
  PrintTable({HandleSwitchRangedWeapon = message}, 10)
  self:RegionSyncChangeWeaponInfo(message.Sender, message, "Ranged")
end

function Component:HandleSwitchShowWeapon(message)
  PrintTable({HandleSwitchShowWeapon = message}, 10)
  self:RegionSyncChangeUsingWeaponType(message.Sender, message)
end

function Component:HandleSwitchShowPet(message)
  PrintTable({HandleSwitchShowPet = message}, 10)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.ShowPet = message.ShowPet
  end
  local RoleInfo = self:GetRoleInfo(message.Sender)
  if RoleInfo then
    RoleInfo.ShowPet = message.ShowPet
  end
end

function Component:HandleSwitchAutoAgreeInvite(message)
  PrintTable({HandleSwitchAutoAgreeInvite = message}, 10)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.AutoAgreeInvite = message.AutoAgreeInvite
  end
  DebugPrint("HandleSwitchAutoAgreeInvite", message.Sender, message.AutoAgreeInvite, SenderInfo)
  self:RefreshRegionOnlineAutoActionTag(message.Sender)
end

function Component:InitOnlineStateData(ObjId, RoleInfo)
  DebugPrint("gmy@OnlineComp Component:InitOnlineStateData", ObjId, RoleInfo, RoleInfo.AFDayTransformId)
  self.RoleUseTargetParam = self.RoleUseTargetParam or {}
  self.RoleUseTargetParam[ObjId] = RoleInfo.UseTargetParam
  self.DeliveryStates = self.DeliveryStates or {}
  if RoleInfo.CurrentState == CommonConst.OnlineState.UseDelivery then
    self.DeliveryStates[ObjId] = true
  else
    self.DeliveryStates[ObjId] = false
  end
  self.AFDayTransformId = RoleInfo.AFDayTransformId or -1
end

function Component:HandleSwitchOnlineState(Message)
  PrintTable({HandleSwitchOnlineState = Message}, 10)
  local TempRoleInfo = self:GetRoleInfo(Message.Sender)
  if TempRoleInfo then
    TempRoleInfo.CurrentState = Message.State or CommonConst.OnlineState.Normal
    TempRoleInfo.UseTargetParam = Message.UseTargetParam or {}
    TempRoleInfo.IsCrouching = false
  end
  self.RoleUseTargetParam = self.RoleUseTargetParam or {}
  self.RoleUseTargetParam[Message.Sender] = Message.UseTargetParam or {}
  DebugPrint("HandleSwitchOnlineState", Message.Sender, Message.State, Message.UseTargetParam and Message.UseTargetParam.ResourceId)
  local Player = self:GetBornedChar(Message.Sender)
  if Player then
    Player.OtherWorldCrouching = false
    Player:SetCrouch(false)
  end
  self:HandleGestureState(Message, false)
  self:HandleFish(Message)
  self:HandleDelivery(Message)
  self:RefreshRegionOnlineAutoActionTag(Message.Sender)
end

function Component:InitOnlineStateAfterBorn(ObjId, RoleInfo)
  DebugPrint("gmy@OnlineComp Component:InitOnlineStateAfterBorn", ObjId, RoleInfo)
  if self.RoleUseTargetParam then
    local UseTargetParam = self.RoleUseTargetParam[ObjId]
    local TempRoleInfo = self:GetRoleInfo(ObjId)
    if TempRoleInfo then
      TempRoleInfo.IsCrouching = false
    end
    local Player = self:GetBornedChar(ObjId)
    if Player then
      Player.OtherWorldCrouching = false
      Player:SetCrouch(false)
    end
    self:HandleGestureState({Sender = ObjId, UseTargetParam = UseTargetParam}, true)
    self:HandleFish({Sender = ObjId, UseTargetParam = UseTargetParam})
    self:HandleTransformAFDay({
      Sender = ObjId,
      TransformID = self.AFDayTransformId or -1
    })
  end
  self:HandleMechanism(self.RegionAvatars, self.GlobalRegionItemCache, ObjId)
  self:TryPlayEndDelivery(ObjId, RoleInfo)
end

function Component:HandleGestureState(Message, bIsInit)
  DebugPrint("gmy@OnlineComp Component:HandleGestureState", Message.Sender, Message.UseTargetParam, Message.UseTargetParam and Message.UseTargetParam.ResourceId)
  if Message and Message.UseTargetParam and Message.UseTargetParam.ResourceId then
    local ResourceId = Message.UseTargetParam.ResourceId
    local Player = self:GetBornedChar(Message.Sender)
    DebugPrint("gmy@OnlineComp Component:HandleGestureState2", ResourceId, Player, Player and Player:GetName(), Player and Player.CurResourceId, Message.Sender, Message.State, Message.UseTargetParam)
    if bIsInit then
      local ResourceInfo = DataMgr.Resource[ResourceId]
      local ResourceIsMountId
      if ResourceInfo then
        ResourceIsMountId = self:ResourceIsMount(ResourceInfo)
      end
      if ResourceIsMountId then
        return
      end
    end
    if Player then
      local ResourceInfo = DataMgr.Resource[ResourceId]
      if ResourceInfo then
        DebugPrint("gmy@OnlineComp Component:HandleGestureState3", ResourceId, Player.CurResourceId)
        local ActionBaseInfo = Message.ActionBaseInfo
        if ActionBaseInfo then
          local Loc = ActionBaseInfo.Location
          local Rot = ActionBaseInfo.Rotation
          PrintTable({
            HandleGestureState = {Loc = Loc, Rot = Rot}
          }, 10)
          Player:K2_SetActorLocationAndRotation(FVector(Loc.X, Loc.Y, Loc.Z), FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll), false, nil, false)
        end
        local ArmoryActionId = ResourceInfo.PlayArmoryAnim
        if ArmoryActionId then
          local ActionName = Const.ArmoryActionIdToArmoryTag[ArmoryActionId]
          if ActionName == Const.Melee then
            local WeaponInfo = Player.WeaponInfo and Player.WeaponInfo.MeleeWeapon
            if WeaponInfo then
              local WeaponId = WeaponInfo.WeaponId
              if Player.MeleeWeapon and Player.MeleeWeapon.WeaponId ~= WeaponId then
                Player.Weapons:Remove(WeaponId)
                Player.MeleeWeapon:Destroy()
                Player.MeleeWeapon = nil
              end
              if Player.MeleeWeapon == nil then
                Player.MeleeWeapon = Player:SpawnShowWeapon(WeaponId, nil, nil, nil, WeaponInfo.AppearanceInfo, WeaponInfo)
                Player:RawAddWeapon(Player.MeleeWeapon)
              end
            end
          elseif ActionName == Const.Ranged then
            local WeaponInfo = Player.WeaponInfo and Player.WeaponInfo.RangedWeapon
            if WeaponInfo then
              local WeaponId = WeaponInfo.WeaponId
              if Player.RangedWeapon and Player.RangedWeapon.WeaponId ~= WeaponId then
                Player.Weapons:Remove(WeaponId)
                Player.RangedWeapon:Destroy()
                Player.RangedWeapon = nil
              end
              if nil == Player.RangedWeapon then
                Player.RangedWeapon = Player:SpawnShowWeapon(WeaponId, nil, nil, nil, WeaponInfo.AppearanceInfo, WeaponInfo)
                Player:RawAddWeapon(Player.RangedWeapon)
              end
            end
          end
        end
        if bIsInit then
          Player:InitShowResourceBPFunction(ResourceId)
        else
          Player:InvokeResourceBPFunction(ResourceId)
        end
      else
        DebugPrint("gmy@OnlineComp Component:HandleGestureState ResetIdleTag", Player.PlayerAnimInstance)
        if Player.PlayerAnimInstance then
          Player.PlayerAnimInstance:ResetIdleTag()
        end
      end
      Player.CurResourceId = ResourceId
    end
  end
end

function Component:HandleMove(message)
  local sender_info = self.RegionAvatars[message.Sender]
  if sender_info and 0 ~= sender_info.CurResourceId and 0 == message.CurResourceId then
    sender_info.CurResourceId = 0
    sender_info.WeaponInfo = nil
  end
  self:RegionSyncUpdateMoveInfo(message.Sender, message)
end

function Component:HandleAction(message)
  self:HandleActionPack(message.Sender, message)
end

function Component:HandleHide(message)
  self:HandleHidePack(message.Sender, message)
end

function Component:HandleStopAction(message)
  self:ReceiveStopActionPack(message.Sender, message)
end

function Component:HandleNicknameChange(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.AvatarInfo.Nickname = message.Nickname
    EventManager:FireEvent(EventID.OnlineRegionNickNameChange, message.Sender, SenderInfo.AvatarInfo.Uid)
  end
end

function Component:HandleHeadFrame(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.AvatarInfo.HeadFrameId = message.HeadFrameId
  end
end

function Component:HandleHeadIcon(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.AvatarInfo.HeadIconId = message.HeadIconId
  end
end

function Component:HandleTransformAFDay(message)
  DebugPrint("gmy@OnlineComp Component:HandleTransformAFDay", message.Sender, message.TransformID)
  PrintTable({HandleTransformAFDay_Msg = message}, 5)
  local Eid = message.Sender
  local Player = self:GetBornedChar(Eid)
  if nil == Player then
    DebugPrint("gmy@OnlineComp Component:HandleTransformAFDay", "Player is nil for Eid:", message.Sender)
    return
  end
  local TransformID = message.TransformID
  if TransformID <= 0 then
    Player:CancelAFDTransform()
  else
    Player:ApplyAFDTransform(TransformID)
  end
end

function Component:HandleLevelChange(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.AvatarInfo.Level = message.Level
  end
end

function Component:HandleCurrentPetChange(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.CurrentPet = message.CurrentPet
  end
  local RoleInfo = self:GetRoleInfo(message.Sender)
  if RoleInfo then
    RoleInfo.CurrentPet = message.CurrentPet
  end
end

function Component:HandleCharInfoChange(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.CharInfo = message.CharInfo
  end
  self:RegionSyncChangeRoleInfo(message.Sender, message)
end

function Component:HandleTitleChange(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    if message.TitleBefore then
      SenderInfo.AvatarInfo.TitleBefore = message.TitleBefore
    end
    if message.TitleAfter then
      SenderInfo.AvatarInfo.TitleAfter = message.TitleAfter
    end
    if message.TitleFrame then
      SenderInfo.AvatarInfo.TitleFrame = message.TitleFrame
    end
  end
  if SenderInfo then
    EventManager:FireEvent(EventID.OnlineRegionTitleChange, message.Sender, SenderInfo.AvatarInfo.Uid, SenderInfo.AvatarInfo.TitleBefore, SenderInfo.AvatarInfo.TitleAfter, SenderInfo.AvatarInfo.TitleFrame)
  end
end

function Component:HandleMechanism(RegionAvatars, GlobalRegionItemCache, AvatarEid)
  local Player = self:GetBornedChar(AvatarEid)
  local Avatar = RegionAvatars[AvatarEid]
  local RegionOnlineItem = Avatar.RegionOnlineItem
  print(_G.LogTag, "LXZ HandleMechanism222", RegionOnlineItem, Player:GetName())
  PrintTable(RegionOnlineItem, 10)
  if RegionOnlineItem then
    for UniqueId, message in pairs(RegionOnlineItem) do
      if message.StateComponent then
        for PointIdx, Table in pairs(message.StateComponent) do
          if Table.UseEid then
            self:UpdateMechanismUser(UniqueId, PointIdx, Table.UseEid, true)
          end
        end
      end
      local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
      local Mechanism = self:TryFindMechanismByUniqueId(UniqueId)
      if not Mechanism then
        local Loc = message.Location
        local Rot = message.Rotation
        local Context = AEventMgr.CreateUnitContext()
        Context.UnitType = "Mechanism"
        Context.UnitId = message.UnitId
        Context.Loc = FVector(Loc.X, Loc.Y, Loc.Z)
        Context.Rotation = FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll)
        local Sender = CommonUtils.ObjId2Str(message.OwnerAvatarEid)
        Context.NameParams:Add("Sender", Sender)
        Context.NameParams:Add("UniqueId", UniqueId)
        GameState.EventMgr:CreateUnitNew(Context, true)
      else
        local Mechanism = self:TryFindMechanismByUniqueId(UniqueId)
        if Player and Mechanism and message.StateComponent then
          for PointIdx, Table in pairs(message.StateComponent) do
            if Table.UseEid == AvatarEid then
              local InteractiveComp = Mechanism.ChestInteractiveComponent
              Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, PointIdx)
            end
          end
        end
      end
      PrintTable(message, 10)
    end
  end
  local DataTable = self:GetMechanismUser(AvatarEid)
  print(_G.LogTag, "LXZ HandleMechanism", DataTable)
  if DataTable and DataTable.UniqueId and DataTable.PointIdx then
    local Mechanism = self:TryFindMechanismByUniqueId(DataTable.UniqueId)
    print(_G.LogTag, "LXZ HandleMechanism111", Mechanism)
    if Player and Mechanism then
      local InteractiveComp = Mechanism.ChestInteractiveComponent
      Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, DataTable.PointIdx)
    end
  end
  self:RefreshRegionOnlineAutoActionTag(AvatarEid)
end

function Component:HandleLeaveRegionMechanism(message)
  print(_G.LogTag, "LXZ HandleLeaveRegionMechanism")
  PrintTable(message, 10)
  if message.Sender == self.Eid then
    return
  end
  local Table = self:GetMechanismUser(message.Sender)
  if Table and Table.UniqueId and Table.PointIdx then
    self:RealDeInteractive({
      UniqueId = Table.UniqueId,
      InteractiveId = Table.PointIdx,
      Sender = message.Sender
    })
  end
  if Table and Table.UniqueId then
    self:RealDeadRegionOnlineItem(Table.UniqueId, message.Sender, true)
  end
end

function Component:InitMechanismUser(GlobalRegionItemCache)
  print(_G.LogTag, "LXZ HandleMechanism InitMechanismUser", GlobalRegionItemCache)
  PrintTable(GlobalRegionItemCache, 10)
  for i, ItemCache in pairs(GlobalRegionItemCache) do
    local UniqueId = ItemCache.UniqueId
    local StateComponent = ItemCache.StateComponent
    if UniqueId and StateComponent then
      for PointIdx, UserTable in pairs(StateComponent) do
        print(_G.LogTag, "LXZ HandleMechanism InitMechanismUser222", PointIdx)
        if UserTable.UseEid then
          self:UpdateMechanismUser(UniqueId, PointIdx, UserTable.UseEid, true)
        end
      end
    end
  end
end

function Component:UpdateMechanismUser(InUniqueId, PointIdx, AvatarEid, bAdd)
  local UserAvatarEid = CommonUtils.ObjId2Str(AvatarEid)
  local UniqueId = InUniqueId
  print(_G.LogTag, "LXZ HandleMechanism UpdateMechanismUser", InUniqueId, UniqueId, PointIdx, UserAvatarEid, bAdd)
  if not self.Mechanism2User then
    self.Mechanism2User = {}
  end
  if not self.User2Mechanism then
    self.User2Mechanism = {}
  end
  if not self.Mechanism2User[UniqueId] then
    self.Mechanism2User[UniqueId] = {}
  end
  if bAdd then
    print(_G.LogTag, "LXZ HandleMechanism UpdateMechanismUser222", UniqueId, PointIdx, UserAvatarEid, bAdd)
    self.User2Mechanism[UserAvatarEid] = {UniqueId = UniqueId, PointIdx = PointIdx}
    self.Mechanism2User[UniqueId][PointIdx] = UserAvatarEid
  else
    self.User2Mechanism[UserAvatarEid] = nil
    self.Mechanism2User[UniqueId][PointIdx] = nil
  end
end

function Component:GetRegionOnlineInteractionUserEid(message)
  return message and (message.RequestEid or message.Sender) or nil
end

function Component:HasOtherRegionOnlineInteractor(UniqueId)
  if not UniqueId or not self.Mechanism2User then
    return false
  end
  local MechanismUserMap = self.Mechanism2User[UniqueId]
  MechanismUserMap = MechanismUserMap or self.Mechanism2User[tostring(UniqueId)]
  if not MechanismUserMap then
    return false
  end
  local SelfEid = self.Eid and CommonUtils.ObjId2Str(self.Eid) or nil
  for _, AvatarEid in pairs(MechanismUserMap) do
    if AvatarEid and tostring(AvatarEid) ~= tostring(SelfEid) then
      return true
    end
  end
  return false
end

function Component:FireRegionOnlineInteractionChangedEvent(UniqueId, InteractiveId, SenderEid, bInteractive, bHasOtherInteractor)
  if not (EventManager and EventID) or not EventID.OnRegionOnlineInteractionChanged then
    return
  end
  if nil == bHasOtherInteractor then
    bHasOtherInteractor = self:HasOtherRegionOnlineInteractor(UniqueId)
  end
  EventManager:FireEvent(EventID.OnRegionOnlineInteractionChanged, UniqueId, InteractiveId, SenderEid, true == bInteractive, true == bHasOtherInteractor)
end

function Component:GetMechanismUser(AvatarEid)
  print(_G.LogTag, "LXZ GetMechanismUser")
  if not self.User2Mechanism then
    return nil
  end
  local UserAvatarEid = CommonUtils.ObjId2Str(AvatarEid)
  print(_G.LogTag, "LXZ GetMechanismUser111", UserAvatarEid, self.User2Mechanism[UserAvatarEid])
  PrintTable({
    self.User2Mechanism
  }, 3)
  return self.User2Mechanism[UserAvatarEid]
end

function Component:TryFindMechanismByUniqueId(UniqueId)
  local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Mechanism = GameState.RegionOnlineMechanismMap:Find(UniqueId)
  if Mechanism then
    return Mechanism
  end
  local bInMobile = CommonUtils.GetRuntimePlatform(GWorld.GameInstance) == "Mobile"
  local SeatName2UniqueIdData = require("Datas.Seat_Data.SeatName2UniqueId")
  local RegionId = DataMgr.SubRegion[self.CurrentRegionId].RegionId
  if bInMobile then
    print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState InMobile", UniqueId)
    local PCUniqueIdData = require("Datas.Seat_Data." .. RegionId)
    if PCUniqueIdData[UniqueId] then
      local Name = PCUniqueIdData[UniqueId][999]
      local SeatNameData = SeatName2UniqueIdData[Name]
      print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState InMobile222", UniqueId, Name, SeatNameData)
      if SeatNameData and SeatNameData[1] then
        Mechanism = GameState.RegionOnlineMechanismMap:Find(SeatNameData[1])
        print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState InMobile333", UniqueId, SeatNameData[0], Mechanism)
      end
    end
  else
    local MobileUniqueIdData = require("Datas.Seat_Data." .. RegionId .. "_Mobile")
    if MobileUniqueIdData[UniqueId] then
      local Name = MobileUniqueIdData[UniqueId][999]
      local SeatNameData = SeatName2UniqueIdData[Name]
      if SeatNameData and SeatNameData[0] then
        Mechanism = GameState.RegionOnlineMechanismMap:Find(SeatNameData[0])
      end
    end
  end
  return Mechanism
end

function Component:HandleFish(message)
  if message and message.UseTargetParam then
    local TempRoleInfo = self:GetRoleInfo(message.Sender)
    if TempRoleInfo then
      TempRoleInfo.IsCrouching = false
    end
    local Player = self:GetBornedChar(message.Sender)
    if Player then
      local FishRodId = message.UseTargetParam.FishingRodId
      if FishRodId and 0 ~= FishRodId then
        local Creatures = Player:GetEffectCreatureByTag("Fish")
        if 0 == Creatures:Length() then
          local CreatorId = message.UseTargetParam.CreatorId
          if CreatorId and 0 ~= CreatorId then
            local GameState = UE4.UGameplayStatics.GetGameState(self)
            local Creator = GameState.StaticCreatorMap:Find(CreatorId)
            local FishingSpot
            if Creator and Creator.ChildEids:Length() > 0 then
              FishingSpot = GameState.Battle:GetEntity(Creator.ChildEids:GetRef(1))
            else
              FishingSpot = GameState.ManualActiveCombat:Find(CreatorId)
            end
            if FishingSpot then
              FishingSpot:SetFishingSpotLocation(Player)
            end
          end
          Player:AsyncCreateEffectCreature(30101, FTransform(), true, nil)
        end
        
        local function UpdateFishingRod()
          self:UpdateFishingRodModelId(Player, FishRodId)
        end
        
        Player:AddTimer(0.1, UpdateFishingRod, true, -0.1, "UpdateFishingRodModelId", false, FishRodId)
      end
      local FishId = message.UseTargetParam.FishId
      if FishId and 0 ~= FishId then
        local MontageData = DataMgr.FishingMontage[FishId]
        if MontageData and MontageData.MontageName then
          if Player.FishMontageId ~= FishId then
            Player.FishMontageId = FishId
            Player:PlayActionMontage("Interactive/Fishing", MontageData.MontageName, {}, false)
          end
        else
          local AnimInstance = Player.Mesh:GetAnimInstance()
          local Montage = AnimInstance:GetCurrentActiveMontage()
          if Montage then
            AnimInstance:Montage_Stop(0, Montage)
            Player:RemoveTimer("UpdateFishingRodModelId")
            Player:RemoveEffectCreature(30101)
          end
          Player.FishMontageId = FishId
        end
      end
    end
  end
end

function Component:UpdateFishingRodModelId(Player, FishingRodId)
  local IdList = DataMgr.FishingRod[FishingRodId].EffectCreatureId
  local Creatures = Player:GetEffectCreatureByTag("Fish")
  if 0 == Creatures:Length() then
    return
  end
  Player:RemoveTimer("UpdateFishingRodModelId")
  for i, Id in pairs(IdList) do
    for j, Creature in pairs(Creatures) do
      if Id == Creature.EffectCreatureId then
        local FishingRodData = DataMgr.FishingRod[FishingRodId]
        local ModelId = FishingRodData.MeshResourceId
        local MaterialPath = FishingRodData.MaterialPath
        local MaterialParam = FishingRodData.MaterialParam
        Player:UpdateEffectCreatureModel(Id, ModelId)
        local EffectId = FishingRodData.EffectId
        if Creature.FishingRodEffectId ~= EffectId then
          Creature.FXComponent:StopEffectByID(Creature.FishingRodEffectId, true)
          Creature.FishingRodEffectId = EffectId
          Creature.FXComponent:PlayEffectByID(EffectId)
        end
        self:UpdateFishingRodMaterial(Player, Id, MaterialPath, MaterialParam)
      end
    end
  end
end

function Component:UpdateFishingRodMaterial(Player, EffectCreatureId, MaterialPath, MaterialParam)
  local EffectCreatures = Player:GetEffectCreatureById(EffectCreatureId)
  for i = EffectCreatures:Num(), 1, -1 do
    local EffectCreature = EffectCreatures:GetRef(i)
    if IsValid(EffectCreature) then
      if MaterialPath then
        local Material = LoadObject(MaterialPath)
        EffectCreature.SkeletalMesh:SetMaterial(0, Material)
      end
      EffectCreature.FishMaterial = EffectCreature.SkeletalMesh:CreateAndSetMaterialInstanceDynamic(0)
      EffectCreature.SkeletalMesh:SetMaterial(0, EffectCreature.FishMaterial)
      if MaterialParam then
        EffectCreature.FishMaterial:SetScalarParameterValue("PartSelect", MaterialParam)
      end
    end
  end
end

function Component:HandleDelivery(Message)
  if Message.State == CommonConst.OnlineState.UseDelivery then
    if self.DeliveryStates then
      self.DeliveryStates[Message.Sender] = true
    end
    DebugPrint("zwk Component:HandleSwitchOnlineState BeginDelivery")
    local TempRoleInfo = self.OtherRoleInfo[Message.Sender]
    if TempRoleInfo then
      TempRoleInfo.IsCrouching = false
      local Player = self:GetBornedChar(Message.Sender)
      if Player then
        local function HidePlayer()
          Player:SetActorHideTag("DeliveryMontage", true)
        end
        
        local AllCallback = {OnNotifyBegin = HidePlayer}
        Player:InitCharacterInfo(Player.InfoForInit)
        Player:ResetIdle()
        Player:PlayTeleportAction(AllCallback, false, true, false)
        Player:AddTimer(3, HidePlayer, false, 0, "DeliveryHide_" .. Message.Sender)
      end
    end
  elseif Message.State == CommonConst.OnlineState.Normal and Message.PreState == CommonConst.OnlineState.UseDelivery then
    DebugPrint("zwk Component:HandleSwitchOnlineState EndDelivery")
    self:PlayEndDelivery(Message.Sender)
  end
end

function Component:PlayEndDelivery(Sender)
  local TempRoleInfo = self.OtherRoleInfo[Sender]
  if TempRoleInfo then
    local Player = self:GetBornedChar(Sender)
    if Player and self.DeliveryStates and self.DeliveryStates[Sender] then
      DebugPrint("zwk Component:HandleSwitchOnlineState 播放落地动作 ", Player:GetName(), self.DeliveryStates)
      Player:RemoveTimer("DeliveryHide_" .. Sender)
      Player:SetActorHideTag("DeliveryMontage", false)
      local AllCallback = {}
      Player:PlayTeleportAction(AllCallback, false, true, false)
      Player.Mesh:GetAnimInstance():Montage_JumpToSection("End")
      if self.DeliveryStates then
        self.DeliveryStates[Sender] = false
      end
    end
  end
end

function Component:TryPlayEndDelivery(ObjId, RoleInfo)
  if self.DeliveryStates and self.DeliveryStates[ObjId] then
    self:PlayEndDelivery(ObjId)
  end
end

function Component:RequestDeadRegionOnlineItem(online_type, SenderEid, UniqueId)
  print(_G.LogTag, "LXZ RequestDeadRegionOnlineItem2222")
  
  local function Callback(Ret)
    self.logger.debug("ZJT_ RequestDeadRegionOnlineItem ", Ret, online_type, UniqueId)
    if 0 == Ret then
      self:RealDeadRegionOnlineItem(UniqueId, SenderEid, false)
    end
  end
  
  self:CallServer("RequestDeadRegionOnlineItem", Callback, online_type, UniqueId)
end

function Component:RequestChangeRegionOnlineItemState(online_type, UniqueId, OwnerEid, InteractiveId, NewState, IsGlobal, bInMobile)
  GreenPrint("客户端发起联机动作申请 RequestChangeRegionOnlineItemState", "online_type：", online_type, "，UniqueId：", UniqueId, "，OwnerEid：", CommonUtils.ObjId2Str(OwnerEid), "，InteractiveId：", InteractiveId, "，NewState：", NewState)
  self.logger.debug("ZJT_ RequestChangeRegionOnlineItemState ", online_type, UniqueId, OwnerEid, InteractiveId, NewState, CommonUtils.ObjId2Str(OwnerEid))
  
  local function Callback(Ret, Message)
    local Player = UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
    if Player then
      Player.WaitRegionOnlineSeatCB = false
    end
    if 0 == Ret then
      EventManager:FireEvent(EventID.OnReceivedOnlineActionApplicationAgree, OwnerEid, UniqueId, InteractiveId)
      local message = {
        UniqueId = UniqueId,
        InteractiveId = InteractiveId,
        Sender = Message.SenderEid,
        RequestEid = Message.SenderEid,
        IsGlobalOnlineItem = IsGlobal
      }
      self:RealInteractive(message)
      GreenPrint("联机动作申请成功")
    elseif 52015 == Ret or 52025 == Ret then
      GreenPrint("联机动作申请超时拒绝")
      EventManager:FireEvent(EventID.OnReceivedOnlineActionApplicationReject, OwnerEid, UniqueId, InteractiveId)
    else
      RedPrint("联机动作申请失败", "错误码：", Ret)
    end
    self.logger.debug("ZJT_ RequestChangeRegionOnlineItemState Callback ", Ret, online_type, UniqueId, OwnerEid, InteractiveId, NewState)
  end
  
  self:CallServer("RequestChangeRegionOnlineItemState", Callback, online_type, UniqueId, OwnerEid, InteractiveId, NewState, bInMobile)
end

function Component:RequestLeaveRegionOnlineItem(online_type, UniqueId, OwnerEid, InteractiveId, bInMobile)
  self.logger.debug("ZJT_ RequestLeaveRegionOnlineItem ", online_type, UniqueId, CommonUtils.ObjId2Str(OwnerEid), InteractiveId, CommonUtils.ObjId2Str(OwnerEid))
  
  local function Callback(Ret)
    self.logger.debug("ZJT_ RequestLeaveRegionOnlineItem CallBack ", Ret, online_type, UniqueId, OwnerEid, InteractiveId)
    if 0 == Ret then
      local message = {
        Sender = self.Eid,
        UniqueId = UniqueId,
        InteractiveId = InteractiveId
      }
      self:RealDeInteractive(message)
    end
  end
  
  self:CallServer("RequestLeaveRegionOnlineItem", Callback, online_type, UniqueId, OwnerEid, InteractiveId, bInMobile)
end

function Component:RequestUseOwnerRegionOnlineItem(RequestEid, UniqueId, InteractiveId)
  GreenPrint("收到申请 RequestUseOwnerRegionOnlineItem", "RequestEid：", CommonUtils.ObjId2Str(RequestEid), "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
  EventManager:FireEvent(EventID.ReceivedOthersOnlineActionApplication, RequestEid, UniqueId, InteractiveId)
  self.logger.debug("ZJT_ 111 RequestUseOwnerRegionOnlineItem ", CommonUtils.ObjId2Str(RequestEid))
end

function Component:OnRequestUseOwnerRegionOnlineItem(RequestEid, RequestRes, UniqueId, InteractiveId)
  GreenPrint("回复申请 OnRequestUseOwnerRegionOnlineItem", "RequestEid：", CommonUtils.ObjId2Str(RequestEid), "，RequestRes：", RequestRes, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
  
  local function Callback(Ret, RequestEid, RequestRes, UniqueId, InteractiveId)
    if 0 == Ret then
      GreenPrint("回复申请 OnRequestUseOwnerRegionOnlineItem 服务端返回结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
    else
      RedPrint("回复申请 OnRequestUseOwnerRegionOnlineItem 服务端返回结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
    end
    self.logger.debug("ZJT_ OnRequestUseOwnerRegionOnlineItem ", Ret, self.CurrentOnlineType, RequestRes, UniqueId, InteractiveId)
    if 0 ~= Ret then
      local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
      OnlineActionController:ShowToastByErrorCode(Ret, false)
    end
  end
  
  self:CallServer("OnRequestUseOwnerRegionOnlineItem", Callback, self.CurrentOnlineType, RequestEid, RequestRes, UniqueId, InteractiveId)
end

function Component:UseCreateMechanism(online_type, ResourceId, UnitId, CreateMechanism)
  CreateMechanism = CreateMechanism or {}
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  local Location = Player:GetRecentSafeLocation()
  Location.Z = Location.Z - Player.CapsuleComponent:GetScaledCapsuleHalfHeight()
  local PlayerLocation = CommonUtils.LocationToTable(Location)
  local PlayerRotation = CommonUtils.RotationToTable(Player:K2_GetActorRotation())
  local CreateMechanismInfo = {
    ResourceId = ResourceId,
    UnitId = UnitId,
    Location = PlayerLocation,
    Rotation = PlayerRotation,
    CreateMechanism = CreateMechanism,
    UnitType = "Mechanism"
  }
  
  local function Callback(Ret, UniqueId)
    local IdleTagName = "nil"
    if Player and Player.PlayerAnimInstance then
      IdleTagName = tostring(Player.PlayerAnimInstance.IdleTagName)
    end
    self.logger.debug("ZJT_ UseCreateMechanism Callback ", Ret, online_type, ResourceId, UniqueId, "IdleTagName", IdleTagName)
    if 0 == Ret then
      CreateMechanismInfo.Sender = self.Eid
      CreateMechanismInfo.UniqueId = UniqueId
      if Player.PlayerAnimInstance and Player.PlayerAnimInstance.IdleTagName == "Gesture01_Idle" then
        self:RealCreateMechanism(CreateMechanismInfo)
        local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
        OnlineActionController:OnCreatOnlineAction(UniqueId)
      else
        self.logger.debug("ZJT_ UseCreateMechanism SkipOnCreatOnlineAction ", UniqueId, "IdleTagName", IdleTagName)
        self:RequestDeadRegionOnlineItem(self.CurrentOnlineType, self.Eid, UniqueId)
      end
    end
    self.logger.debug("ZJT_ UseCreateMechanism ", Ret, online_type, ResourceId, UniqueId)
  end
  
  self:CallServer("UseCreateMechanism", Callback, online_type, CreateMechanismInfo)
end

function Component:SwitchOnlineState(online_type, NewState, UseTargetParam, IsUpdateState)
  if nil == IsUpdateState then
    IsUpdateState = true
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  if self.IsInRegionOnline then
    Player.CurrentOnlineState = NewState or CommonConst.OnlineState.Normal
  end
  local Message = {
    Type = "SwitchOnlineState",
    State = NewState or CommonConst.OnlineState.Normal,
    UseTargetParam = UseTargetParam or {},
    IsUpdateState = IsUpdateState,
    ActionBaseInfo = Player:GetPlayerLocationAndRotation()
  }
  DebugPrint("gmy@OnlineComp Component:SwitchOnlineState", NewState)
  self:UploadPlayerMessage(online_type, Message)
end

function Component:UseGouSuoMessage(online_type, CreatorId)
  local Message = {Type = "UseGouSuo", CreatorId = CreatorId}
  self:UploadPlayerMessage(online_type, Message)
end

function Component:HandleUseGouSuo(Message)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Creator = GameState.StaticCreatorMap:FindRef(Message.CreatorId)
  if not Creator then
    return
  end
  local Player = self:GetBornedChar(Message.Sender)
  if not Player then
    return
  end
  for i = 1, Creator.ChildEids:Length() do
    local Eid = Creator.ChildEids:GetRef(i)
    local Hook = GameState.Battle:GetEntity(Eid)
    if Hook then
      Hook.HookInteractiveComponent:StartInteractive(Player)
    end
  end
end

function Component:RequestUseCreateMount(online_type, ResourceId, MountId, UseState)
  local function Callback(Ret)
    self.logger.debug("ZJT_ RequestUseCreateMount ", Ret)
  end
  
  self:CallServer("RequestUseCreateMount", Callback, online_type, ResourceId, MountId, UseState)
end

function Component:RequestHostInvitationOther(InvitationEid, UniqueId, InteractiveId, NewState)
  GreenPrint("客户端发起邀请 RequestHostInvitationOther", "InvitationEid：", CommonUtils.ObjId2Str(InvitationEid), "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId, "，NewState：", NewState)
  
  local function Callback(Ret)
    if 52015 == Ret or 52025 == Ret then
      GreenPrint("客户端发起邀请结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId, "，NewState：", NewState)
      EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationReject, InvitationEid, UniqueId, InteractiveId, NewState)
    elseif 0 == Ret then
      GreenPrint("客户端发起邀请结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId, "，NewState：", NewState)
      EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationAgree, InvitationEid, UniqueId, InteractiveId, NewState)
    elseif 52024 == Ret then
      GreenPrint("客户端发起邀请结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId, "，NewState：", NewState)
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invite_Inviting"))
    else
      RedPrint("客户端发起邀请结果 未知错误", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId, "，NewState：", NewState)
    end
    self.logger.debug("ZJT_ RequestHostInvitationOther ", Ret)
  end
  
  self:CallServer("RequestHostInvitationOther", Callback, self.CurrentOnlineType, self.Eid, InvitationEid, UniqueId, InteractiveId, NewState or 1)
end

function Component:OnRequestOtherUserRegionOnlineItem(InviterEid, RequestRes, UniqueId, InteractiveId)
  GreenPrint("回复邀请 OnRequestOtherUserRegionOnlineItem", "InviterEid：", CommonUtils.ObjId2Str(InviterEid), "，RequestRes：", RequestRes, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
  
  local function Callback(Ret)
    if 0 == Ret then
      GreenPrint("回复邀请结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
    else
      RedPrint("回复邀请结果", "Ret：", Ret, "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
    end
    self.logger.debug("ZJT_ OnRequestOtherUserRegionOnlineItem ", Ret, self.CurrentOnlineType, RequestRes)
    if 0 == Ret then
      local message = {
        UniqueId = UniqueId,
        InteractiveId = InteractiveId,
        Sender = self.Eid,
        RequestEid = self.Eid,
        IsGlobalOnlineItem = false
      }
      self:RealInteractive(message)
      EventManager:FireEvent(EventID.OnReceivedOnlineActionInvitationAgree, InviterEid, UniqueId, InteractiveId)
    else
      local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
      OnlineActionController:ShowToastByErrorCode(Ret, true)
    end
  end
  
  self:CallServer("OnRequestOtherUserOnlineItem", Callback, self.CurrentOnlineType, InviterEid, RequestRes, UniqueId, InteractiveId)
end

function Component:RequestOtherUserRegionOnlineItem(OwnerEid, UniqueId, InteractiveId)
  GreenPrint("客户端收到邀请 RequestOtherUserRegionOnlineItem", "OwnerEid：", CommonUtils.ObjId2Str(OwnerEid), "，UniqueId：", UniqueId, "，InteractiveId：", InteractiveId)
  EventManager:FireEvent(EventID.ReceivedOthersOnlineActionInvitation, OwnerEid, UniqueId, InteractiveId)
end

function Component:RequestDeadRegionOnlineMount(online_type, MountId)
  local function Callback(Ret)
    self.logger.debug("ZJT_ RequestDeadRegionOnlineMount ", Ret)
  end
  
  self:CallServer("RequestDeadRegionOnlineMount", Callback, online_type, MountId)
end

function Component:RequestChangeRegionOnlineMount(online_type, MountId, MountState)
  local function Callback(Ret)
    self.logger.debug("ZJT_ RequestDeadRegionOnlineMount ", Ret)
  end
  
  self:CallServer("RequestDeadRegionOnlineMount", Callback, online_type, MountId, MountState)
end

function Component:HandleOnChangeRegionOnlineMount(Message)
  PrintTable({OnChangeRegionOnlineMount = Message}, 10)
end

function Component:RequestSendSuccess(Type)
  self.logger.debug("ZJT_ 请求发送成功 ", Type)
  if "OtherUser" == Type then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RegionOnline_Invitation_Sent"))
    return
  end
  if "UseOwner" == Type then
    return
  end
end

function Component:HandleShareMountDatasChange(Message)
  PrintTable({ShareMountDatasChange = Message}, 10)
  self:RegionSyncHandleMountPassengerChange(Message)
end

function Component:HandleOnDeadRegionOnlineMount(Message)
  PrintTable({OnDeadRegionOnlineMount = Message}, 10)
  PrintTable({Message = Message}, 10)
  if Message.Sender == self.Eid then
    return
  end
  local ObjId = Message.Sender
  local TempRoleInfo = self:GetRoleInfo(ObjId)
  if not TempRoleInfo then
    print(_G.LogTag, "Not a legal roleinfo")
    return
  end
  if not TempRoleInfo.MountDatas then
    print(_G.LogTag, "TempRoleInfo.MountDatas not exist")
    return
  end
  TempRoleInfo.MountDatas.MountId = 0
end

function Component:HandleOnUseCreateMount(Message)
  PrintTable({OnUseCreateMount = Message}, 10)
  PrintTable({Message = Message}, 10)
  if Message.Sender == self.Eid then
    return
  end
  local ObjId = Message.Sender
  local TempRoleInfo = self:GetRoleInfo(ObjId)
  if not TempRoleInfo then
    print(_G.LogTag, "Not a legal roleinfo")
    return
  end
  if not TempRoleInfo.MountDatas then
    print(_G.LogTag, "TempRoleInfo.MountDatas not exist")
    return
  end
  TempRoleInfo.MountDatas.MountId = Message.MountId or 0
end

function Component:HandleOnLeaveRegionOnlineItem(message)
  self.logger.debug("ZJT_ HandleOnLeaveRegionOnlineItem " .. CommonUtils.ObjId2Str(self.Eid))
  PrintTable({message = message}, 10)
  self:RealDeInteractive(message)
  self:RefreshRegionOnlineAutoActionTag(message.Sender)
end

function Component:HandleOnUseRegionOnlineItem(message)
  self.logger.debug("ZJT_ HandleOnUseRegionOnlineItem ")
  PrintTable({message = message}, 10)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo then
    SenderInfo.RegionOnlineItem = SenderInfo.RegionOnlineItem or {}
    SenderInfo.RegionOnlineItem[message.UniqueId] = message
  end
  DebugPrint("HandleOnUseRegionOnlineItem", message.Sender, message.UniqueId, SenderInfo and SenderInfo.AutoAgreeInvite, SenderInfo and SenderInfo.RegionOnlineItem)
  self:RealCreateMechanism(message)
  self:RefreshRegionOnlineAutoActionTag(message.Sender)
end

function Component:HandleOnChangeRegionOnlineItemState(message)
  PrintTable({message = message}, 10)
  self:RealInteractive(message)
  self:RefreshRegionOnlineAutoActionTag(message.Sender)
end

function Component:HandleOnDeadRegionOnlineItem(message)
  print(_G.LogTag, "LXZ RequestDeadRegionOnlineItem3333")
  self.logger.debug("ZJT_ HandleOnDeadRegionOnlineItem ")
  PrintTable({message = message}, 10)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if SenderInfo and SenderInfo.RegionOnlineItem then
    SenderInfo.RegionOnlineItem[message.UniqueId] = nil
  end
  DebugPrint("HandleOnDeadRegionOnlineItem", message.Sender, message.UniqueId, SenderInfo and SenderInfo.AutoAgreeInvite, SenderInfo and SenderInfo.RegionOnlineItem)
  self:RealDeadRegionOnlineItem(message.UniqueId, message.Sender, false)
  self:RefreshRegionOnlineAutoActionTag(message.Sender)
end

function Component:HandleHyperWeaponLevelUp(message)
  local SenderInfo = self.RegionAvatars[message.Sender]
  if not SenderInfo then
    return
  end
  local Uid = SenderInfo.AvatarInfo.Uid
  local GameInstance = GWorld.GameInstance
  if not GameInstance then
    return
  end
  local ScenceManager = GameInstance:GetSceneManager()
  if not ScenceManager then
    return
  end
  local RegionOnlineCharacterInfo = ScenceManager.RegionOnlineCharacterInfo
  if not RegionOnlineCharacterInfo then
    return
  end
  local Eid = RegionOnlineCharacterInfo[Uid]
  local Battle = Battle(GWorld.GameInstance)
  local Player = Eid and Battle:GetEntity(Eid)
  if not Player then
    return
  end
  local WeaponBase = message.bMelee and Player.MeleeWeapon or Player.RangedWeapon
  if not WeaponBase or not IsValid(WeaponBase) then
    return
  end
  if not WeaponBase:IsHyperWeapon() then
    return
  end
  if WeaponBase.WeaponFashion then
    WeaponBase.WeaponFashion:ApplyHyperWeaponMaterialEffect(message.HyperCardLevel or 0)
  end
end

function Component:RealCreateMechanism(message)
  local Loc = message.Location
  local Rot = message.Rotation
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Context = AEventMgr.CreateUnitContext()
  Context.UnitType = "Mechanism"
  Context.UnitId = message.UnitId
  Context.Loc = FVector(Loc.X, Loc.Y, Loc.Z)
  Context.Rotation = FRotator(Rot.Pitch, Rot.Yaw, Rot.Roll)
  local Sender = CommonUtils.ObjId2Str(message.Sender)
  local ResourceId = message.ResourceId
  Context.NameParams:Add("Sender", Sender)
  Context.NameParams:Add("UniqueId", message.UniqueId)
  Context.IntParams:Add("ResourceId", ResourceId)
  print(_G.LogTag, "LXZ ResourceUseEffectCreateMechanism Real", Context.UnitId, Sender, self.Eid)
  GameState.EventMgr:CreateUnitNew(Context, true)
  GameState:RegisterPlayerMechanismRegionOnline(Sender, message.UniqueId)
end

function Component:RealInteractive(message)
  PrintTable(message, 10)
  local InteractionUserEid = self:GetRegionOnlineInteractionUserEid(message)
  self:UpdateMechanismUser(message.UniqueId, message.InteractiveId, InteractionUserEid, true)
  self:FireRegionOnlineInteractionChangedEvent(message.UniqueId, message.InteractiveId, InteractionUserEid, true)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Player
  if message.RequestEid then
    if message.RequestEid == self.Eid then
      Player = UGameplayStatics.GetPlayerCharacter(GameState, 0)
    else
      Player = self:GetBornedChar(message.RequestEid)
    end
  else
    Player = self:GetBornedChar(message.Sender)
  end
  local Mechanism = self:TryFindMechanismByUniqueId(message.UniqueId)
  print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState111", message.UniqueId, Mechanism, message.IsGlobalOnlineItem)
  if message.Sender == self.Eid then
    if not (Player and Mechanism) or not Mechanism:IsCanOnlineInteractive(Player) then
      local bInMobile = CommonUtils.GetRuntimePlatform(GWorld.GameInstance) == "Mobile"
      self:RequestLeaveRegionOnlineItem(self.CurrentOnlineType, message.UniqueId, self.Eid, message.InteractiveId, bInMobile)
      return
    end
    local InteractiveComp = Mechanism.ChestInteractiveComponent
    print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState222", Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, message.InteractiveId)
    Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, message.InteractiveId)
  else
    if not Mechanism then
      return
    end
    local InteractiveComp = Mechanism.ChestInteractiveComponent
    print(_G.LogTag, "LXZ HandleOnChangeRegionOnlineItemState333", Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, message.InteractiveId)
    Player:InteractiveMechanism(Mechanism.Eid, Player.Eid, InteractiveComp.NextStateId, InteractiveComp.CommonUIConfirmID, true, message.InteractiveId)
  end
end

function Component:RealDeInteractive(message)
  local InteractionUserEid = self:GetRegionOnlineInteractionUserEid(message)
  self:UpdateMechanismUser(message.UniqueId, message.InteractiveId, InteractionUserEid, false)
  self:FireRegionOnlineInteractionChangedEvent(message.UniqueId, message.InteractiveId, InteractionUserEid, false)
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  local Player = self:GetBornedChar(InteractionUserEid)
  if InteractionUserEid == self.Eid then
    Player = UGameplayStatics.GetPlayerCharacter(GameState, 0)
  end
  local Mechanism = self:TryFindMechanismByUniqueId(message.UniqueId)
  print(_G.LogTag, "LXZ HandleOnLeaveRegionOnlineItem RealDeInteractive", message.UniqueId)
  if not Player then
    return
  end
  if not Mechanism then
    return
  end
  print(_G.LogTag, "LXZ HandleOnLeaveRegionOnlineItem RealDeInteractive", message.UniqueId, Mechanism:GetName(), Player:GetName())
  local InteractiveComp = Mechanism.ChestInteractiveComponent
  Player:DeInteractiveMechanism(Mechanism.Eid, Player.Eid, 0, true, InteractiveComp.NextStateId, true, message.InteractiveId)
end

function Component:RealDeadRegionOnlineItem(UniqueId, SenderEid, bAllClear)
  local GameState = UGameplayStatics.GetGameState(GWorld.GameInstance)
  local AvatarEid = CommonUtils.ObjId2Str(SenderEid)
  if not bAllClear then
    GameState:RemoveMechanismRegionOnline(UniqueId, EDestroyReason.OwnerTagChange)
    GameState:RemovePlayerMechanismRegionOnline(AvatarEid, UniqueId, false)
    self:FireRegionOnlineInteractionChangedEvent(UniqueId, nil, SenderEid, false, false)
  else
    local UniqueIdList = GameState.PlayerRegionOnlineMechanismMap:Find(AvatarEid)
    if not UniqueIdList then
      self:FireRegionOnlineInteractionChangedEvent(UniqueId, nil, SenderEid, false, false)
      return
    end
    local DeadUniqueIds = {}
    for i, MechanismUniqueId in pairs(UniqueIdList.Array) do
      DeadUniqueIds[#DeadUniqueIds + 1] = MechanismUniqueId
      GameState:RemoveMechanismRegionOnline(MechanismUniqueId, EDestroyReason.OwnerLeaveRegion)
    end
    GameState:RemovePlayerMechanismRegionOnline(AvatarEid, "", true)
    for _, MechanismUniqueId in ipairs(DeadUniqueIds) do
      self:FireRegionOnlineInteractionChangedEvent(MechanismUniqueId, nil, SenderEid, false, false)
    end
  end
end

function Component:GetBornedChar(ObjId)
  local RegionSycnSubsystem = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
  if not RegionSycnSubsystem then
    return nil
  end
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  local BornedChar = RegionSycnSubsystem:GetBornedChar(ObjIdStr)
  return BornedChar
end

function Component:GetRoleInfo(ObjId)
  return self.OtherRoleInfo[ObjId]
end

function Component:GetRoleBornedEid(ObjId)
  local RegionSycnSubsystem = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
  if not RegionSycnSubsystem then
    return nil
  end
  local ObjIdStr = CommonUtils.ObjId2Str(ObjId)
  local Eid = RegionSycnSubsystem:GetEntityEid(ObjIdStr)
  return Eid
end

function Component:UpdateTotalOnlineTime()
  self.logger.debug("ZJT_ UpdateTotalOnlineTime ", self.TotalRegionOnlineTime)
end

function Component:RegionOnlineTransformAFDay(TransformId)
  DebugPrint("gmy@OnlineComp Component:RegionOnlineTransformAFDay", TransformId)
  if not self.IsInRegionOnline then
    return
  end
  
  local function Callback(Ret)
    DebugPrint("gmy@OnlineComp Callback", Ret)
  end
  
  self:CallServer("RegionOnlineTransformAFDay", Callback, TransformId)
end

function Component:QueryRegionOnlineChannelState(online_type, ids)
  local function callback(ret, info)
    if ChatController then
      ChatController:RecvChatChannelPlayerCountInfo(online_type, info)
    end
  end
  
  self:CallServer("QueryRegionOnlineChannelState", callback, online_type, ids)
end

function Component:QueryAllRegionOnlineChannelState(online_type)
  local function callback(ret, info)
    if ChatController then
      ChatController:RecvAllChatChannelPlayerCountInfo(online_type, info)
    end
  end
  
  self:CallServer("QueryAllRegionOnlineChannelState", callback, online_type)
end

function Component:QueryRegionOnlineChannelCount(online_type)
  local function callback(ret, info)
  end
  
  self:CallServer("QueryRegionOnlineChannelCount", callback, online_type)
end

function Component:RefreshRegionOnlineAutoActionTag(ObjId)
  local Player
  if ObjId == self.Eid then
    Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  else
    Player = self:GetBornedChar(ObjId)
  end
  DebugPrint("RefreshRegionOnlineAutoActionTag", ObjId, Player, Player and Player.Eid, Player and Player:GetName())
  if not Player or not Player.RefreshAutoOnlineActionTagByRegionState then
    DebugPrint("RefreshRegionOnlineAutoActionTag skip invalid player", ObjId, Player)
    return
  end
  Player:RefreshAutoOnlineActionTagByRegionState(ObjId)
end

function Component:SetAutoAgreeInvite(bEnable)
  DebugPrint("SetAutoAgreeInvite request", self.Eid, bEnable)
  
  local function callback(ret)
    DebugPrint("SetAutoAgreeInvite callback", self.Eid, bEnable, ret)
    self.logger.debug("SetAutoAgreeInvite result", ret)
  end
  
  self:CallServer("SetAutoAgreeInvite", callback, bEnable)
end

return Component
