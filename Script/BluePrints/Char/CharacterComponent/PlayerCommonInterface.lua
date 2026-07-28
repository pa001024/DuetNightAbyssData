local EMCache = require("EMCache.EMCache")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local MiscUtils = require("Utils.MiscUtils")
local OnlineActionModel = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionModel")
local PlayerCommonInterface = {}

function PlayerCommonInterface:PlayerCharacterInitialize()
  self.bWeaponByHand = false
  self.WeaponPos = Const.Shoulder
  self.bGotControllerPitchInput = false
  self.bGotControllerYawInput = false
  self.fNoControlRotationInputTime = 0.0
  self:InitActionLogicParamas()
  self.LookAtTag = self:AddOneSwitchTag(self.OnSetLookAtTag)
  self.bForbidInteractiveTrigger = false
  self:UpdateCameraSensitivityFromCache()
  self:SetPlayerCameraSensitivityByType("Normal")
end

function PlayerCommonInterface:PrintCameraSensitivity(self)
  DebugPrint("Tianyi@ Current Pitch Sensivity: " .. tostring(self.CameraPitchSensitivity) .. " Current Yaw Sensivity: " .. tostring(self.CameraYawSensitivity))
  DebugPrint("Tianyi@ CameraPitchSensitivity_Normal: " .. tostring(self.CameraPitchSensitivity_Normal) .. " CameraYawSensitivity_Normal: " .. tostring(self.CameraYawSensitivity_Normal))
  DebugPrint("Tianyi@ CameraPitchSensitivity_Shoot: " .. tostring(self.CameraPitchSensitivity_Shoot) .. " CameraYawSensitivity_Shoot: " .. tostring(self.CameraYawSensitivity_Shoot))
  DebugPrint("Tianyi@ GamepadCameraPitchSensitivity_Normal: " .. tostring(self.GamepadCameraPitchSensitivity_Normal) .. " GamepadCameraYawSensitivity_Normal: " .. tostring(self.GamepadCameraYawSensitivity_Normal))
  DebugPrint("Tianyi@ GamepadCameraPitchSensitivity_Shoot: " .. tostring(self.GamepadCameraPitchSensitivity_Shoot) .. " GamepadCameraYawSensitivity_Shoot: " .. tostring(self.GamepadCameraYawSensitivity_Shoot))
  DebugPrint("Tianyi@ TurnSpeedPitch: " .. tostring(self.TurnSpeedPitch))
  DebugPrint("Tianyi@ TurnSpeedYaw: " .. tostring(self.TurnSpeedYaw))
end

function PlayerCommonInterface:SetPlayerCameraSensitivityByType(Type, bController)
  if "Normal" == Type then
    if UIUtils.IsGamepadInput() then
      self.CameraPitchSensitivity = self.GamepadCameraPitchSensitivity_Normal
      self.CameraYawSensitivity = self.GamepadCameraYawSensitivity_Normal
    else
      self.CameraPitchSensitivity = self.CameraPitchSensitivity_Normal
      self.CameraYawSensitivity = self.CameraYawSensitivity_Normal
    end
  elseif "Shooting" == Type then
    if UIUtils.IsGamepadInput() then
      self.CameraPitchSensitivity = self.GamepadCameraPitchSensitivity_Shoot
      self.CameraYawSensitivity = self.GamepadCameraYawSensitivity_Shoot
    else
      self.CameraPitchSensitivity = self.CameraPitchSensitivity_Shoot
      self.CameraYawSensitivity = self.CameraYawSensitivity_Shoot
    end
  end
end

function PlayerCommonInterface:SetPlayerCameraSensitivityCannon()
  self.CameraPitchSensitivity_Normal = self.CameraPitchSensitivity_Shoot
  self.CameraYawSensitivity_Normal = self.CameraYawSensitivity_Shoot
  self.GamepadCameraPitchSensitivity_Normal = self.GamepadCameraPitchSensitivity_Shoot
  self.GamepadCameraYawSensitivity_Normal = self.GamepadCameraYawSensitivity_Shoot
end

function PlayerCommonInterface:UpdateGamePadCameraSensitivityFromCache()
  local CachedCameraPitch = EMCache:Get("GamepadCameraPitch")
  if not CachedCameraPitch then
    local DefaultValue = tonumber(DataMgr.Option.GamePadVerticalSensitivity.DefaultValue or 1.0) / (DataMgr.Option.GamePadVerticalSensitivity.ScrollMappingScale or 1.0)
    EMCache:Set("GamepadCameraPitch", DefaultValue)
    CachedCameraPitch = DefaultValue
  end
  self.GamepadCameraPitchSensitivity_Normal = CachedCameraPitch
  local CachedCameraPitchOnShoot = EMCache:Get("GamepadCameraPitchOnShoot")
  if not CachedCameraPitchOnShoot then
    local DefaultValue = tonumber(DataMgr.Option.GamePadVerticalSensitivityOnShooting.DefaultValue or 1.0) / (DataMgr.Option.GamePadVerticalSensitivityOnShooting.ScrollMappingScale or 1.0)
    EMCache:Set("GamepadCameraPitchOnShoot", DefaultValue)
    CachedCameraPitchOnShoot = DefaultValue
  end
  self.GamepadCameraPitchSensitivity_Shoot = CachedCameraPitchOnShoot
  local CachedCameraYaw = EMCache:Get("GamepadCameraYaw")
  if not CachedCameraYaw then
    local DefaultValue = tonumber(DataMgr.Option.GamePadHorizontalSensitivity.DefaultValue or 1.0) / (DataMgr.Option.GamePadHorizontalSensitivity.ScrollMappingScale or 1.0)
    EMCache:Set("GamepadCameraYaw", DefaultValue)
    CachedCameraYaw = DefaultValue
  end
  self.GamepadCameraYawSensitivity_Normal = CachedCameraYaw
  local CachedCameraYawOnShoot = EMCache:Get("GamepadCameraYawOnShoot")
  if not CachedCameraYawOnShoot then
    local DefaultValue = tonumber(DataMgr.Option.GamePadHorizontalSensitivityOnShooting.DefaultValue or 1.0) / (DataMgr.Option.GamePadHorizontalSensitivityOnShooting.ScrollMappingScale or 1.0)
    EMCache:Set("GamepadCameraYawOnShoot", DefaultValue)
    CachedCameraYawOnShoot = DefaultValue
  end
  self.GamepadCameraYawSensitivity_Shoot = CachedCameraYawOnShoot
end

function PlayerCommonInterface:UpdateKeyBoardCameraSensitivityFromCache()
  local CachedCameraPitch = EMCache:Get("CameraPitch")
  if not CachedCameraPitch then
    local DefaultValue = tonumber(DataMgr.Option.VerticalSensitivity.DefaultValue or 1.0) / (DataMgr.Option.VerticalSensitivity.ScrollMappingScale or 1.0)
    EMCache:Set("CameraPitch", DefaultValue)
    CachedCameraPitch = DefaultValue
  end
  self.CameraPitchSensitivity_Normal = CachedCameraPitch
  local CachedCameraPitchOnShoot = EMCache:Get("CameraPitchOnShoot")
  if not CachedCameraPitchOnShoot then
    local DefaultValue = tonumber(DataMgr.Option.VerticalSensitivityOnShooting.DefaultValue or 1.0) / (DataMgr.Option.VerticalSensitivityOnShooting.ScrollMappingScale or 1.0)
    EMCache:Set("CameraPitchOnShoot", DefaultValue)
    CachedCameraPitchOnShoot = DefaultValue
  end
  self.CameraPitchSensitivity_Shoot = CachedCameraPitchOnShoot
  local CachedCameraYaw = EMCache:Get("CameraYaw")
  if not CachedCameraYaw then
    local DefaultValue = tonumber(DataMgr.Option.HorizontalSensitivity.DefaultValue or 1.0) / (DataMgr.Option.HorizontalSensitivity.ScrollMappingScale or 1.0)
    EMCache:Set("CameraYaw", DefaultValue)
    CachedCameraYaw = DefaultValue
  end
  self.CameraYawSensitivity_Normal = CachedCameraYaw
  local CachedCameraYawOnShoot = EMCache:Get("CameraYawOnShoot")
  if not CachedCameraYawOnShoot then
    local DefaultValue = tonumber(DataMgr.Option.HorizontalSensitivityOnShooting.DefaultValue or 1.0) / (DataMgr.Option.HorizontalSensitivityOnShooting.ScrollMappingScale or 1.0)
    EMCache:Set("CameraYawOnShoot", DefaultValue)
    CachedCameraYawOnShoot = DefaultValue
  end
  self.CameraYawSensitivity_Shoot = CachedCameraYawOnShoot
end

function PlayerCommonInterface:UpdateCameraSensitivityFromCache(Type, bController)
  self:UpdateGamePadCameraSensitivityFromCache()
  self:UpdateKeyBoardCameraSensitivityFromCache()
end

function PlayerCommonInterface:BeforeBeginPlay()
  self.CheckAnimNotifyOnZeroFrame = false
  self.MaxSafeLocations = 10
end

function PlayerCommonInterface:AfterBeginPlay()
  self.WeaponPos = Const.Shoulder
  if self.PlayerAnimInstance then
    self.PlayerAnimInstance.WeaponPos = self.WeaponPos
  end
  self:SetupActionGroups()
  self:InitPostProcessSettings()
end

function PlayerCommonInterface:LoadFinished()
  print("LoadFinished")
end

function PlayerCommonInterface:LatenTick(DeltaSeconds)
end

function PlayerCommonInterface:ProcessItemsOnTouchTick()
  self:ProcessItemsOnTouch()
end

function PlayerCommonInterface:ReturnIdle(FromNoAsset)
  self:SetCharacterTagIdle()
  self.KeepWeaponOnHand = false
  self:ServerSetCharacterTag("Idle")
end

function PlayerCommonInterface:SetLogMask(MaskName)
  print("LogInfo", MaskName)
  _G.LogTag = MaskName
end

function PlayerCommonInterface:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
  if self.PlayerAnimInstance then
    self.PlayerAnimInstance:SetEmoIdleEnabled(IsEnable, IsChangeRefreshNow)
  end
end

function PlayerCommonInterface:KawaiiSwitch(Enabled)
  if self.PlayerAnimInstance then
    self.PlayerAnimInstance:EnableKawaiiSettings(Enabled)
  end
end

function PlayerCommonInterface:StopArmoryIdle()
  self:ShouldEnableHandIk()
  self.PlayerAnimInstance:Montage_StopSlotByName(0, "ArmoryIdle")
end

function PlayerCommonInterface:SetArmoryIdleTag(bHideUntilLoop)
  if not self.PlayerAnimInstance then
    return
  end
  self:ShouldEnableHandIk()
  local TargetIdleTag
  if self.IsEnterArmory then
    if Const.ArmoryIdleTags[self.IsEnterArmory] then
      TargetIdleTag = Const.ArmoryIdleTags[self.IsEnterArmory]
    elseif Const.ArmoryWeaponIdleTags[self.IsEnterArmory] then
      local WeaponTag = Const.ArmoryWeaponIdleTag2WeaponType[self.IsEnterArmory]
      TargetIdleTag = self.IsEnterArmory .. "_" .. self:GetUsingWeaponType(WeaponTag)
    else
      TargetIdleTag = self:GetUsingWeaponType(self.IsEnterArmory)
    end
  end
  self.PlayerAnimInstance:SetArmoryIdleTag(bHideUntilLoop, TargetIdleTag)
end

function PlayerCommonInterface:CancelSkill(JumpStage, bStillHoldFire)
end

function PlayerCommonInterface:CalcVectorAngle(Vector1, Vector2)
  Vector1:Normalize()
  Vector2:Normalize()
  local DotResult = Vector1:Dot(Vector2)
  local CosToAngle = UE4.UKismetMathLibrary.DegAcos(DotResult)
  return CosToAngle
end

function PlayerCommonInterface:IsLocalPlayer()
  if URuntimeCommonFunctionLibrary.ObjIsChildOf(self:GetController(), APlayerController) and (IsStandAlone(self) or MiscUtils.IsAutonomousProxy(self)) then
    return true
  end
  return false
end

function PlayerCommonInterface:UpdatePlayerTaskInfo()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local SceneComponentMgr = GameInstance:GetSceneManager()
  if nil == SceneComponentMgr or nil == UIManager then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local TaskBarWidget
  local BattleMainUI = UIManager:GetUIObj("BattleMain")
  if nil ~= BattleMainUI and nil ~= BattleMainUI.Pos_TaskBar and 0 == BattleMainUI.Pos_TaskBar:GetChildrenCount() then
    TaskBarWidget = BattleMainUI:CreateWidgetNew("TaskBar")
    if nil ~= TaskBarWidget then
      BattleMainUI.Pos_TaskBar:AddChildToOverlay(TaskBarWidget)
    end
    local QuestChain = Avatar.QuestChains[Avatar.TrackingQuestChainId]
    if not QuestChain or QuestChain and QuestChain:IsFinish() then
      BattleMainUI.Pos_TaskBar:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  elseif nil ~= BattleMainUI and nil ~= BattleMainUI.Pos_TaskBar then
    TaskBarWidget = BattleMainUI.Pos_TaskBar:GetChildAt(0)
  end
  local UnlockMainStoryChain = TaskUtils:GetUnlockMainStory()
  if UnlockMainStoryChain then
    if TaskBarWidget then
      TaskBarWidget:UpdateUnlockMainStory(UnlockMainStoryChain)
    end
  elseif TaskBarWidget then
    TaskBarWidget.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local IconTexture = TaskUtils:GetIconTextureByTrackQuestChainType()
  if IconTexture and TaskBarWidget then
    TaskBarWidget.Icon_GuidePoint:SetBrushResourceObject(IconTexture)
  end
end

function PlayerCommonInterface:InitSceneStartUI()
end

function PlayerCommonInterface:UpdatePlayerBloodEffectInfo()
end

function PlayerCommonInterface:Landed()
  if not self:PlayerLanded() then
    return
  end
  self.Super.Landed(self)
  if self:CharacterInTag("LandHeavy") then
    return
  end
end

function PlayerCommonInterface:Impending()
  if not self:PlayerImpending() then
    return
  end
end

function PlayerCommonInterface:StartSlide()
end

function PlayerCommonInterface:EnterHitFlyTag()
  if self.PlayerAnimInstance then
    self:SetCurrentJumpState(Const.NormalState)
    self:SetRotationRate("OnGround")
  end
end

function PlayerCommonInterface:GetDamageInstigatorCurrentAngle(Attacker)
end

function PlayerCommonInterface:TryToUpdateScreenEffect(DamageFrom, EnergyShieldReduce)
end

function PlayerCommonInterface:SkillEnd(Owner, SkillId)
end

function PlayerCommonInterface:PressFire()
end

function PlayerCommonInterface:ResetJumpState(KeepJumpCount)
  self:SetCurrentJumpState(Const.NormalState)
  if not KeepJumpCount then
    self.JumpCount = 0
    self.BulletJumpCount = 0
  end
  self.AutoSyncProp.IsBulletJumping = false
  self.StartBulletJumpTime = -1
  self.ForbidSlide = false
  local Movement = self:GetMovementComponent()
  self.ForbidOrient = false
  self:ChangeOrientControll()
  self:ResetCapRot()
end

function PlayerCommonInterface:ResetJumpState_Lua()
  if self.LuaTimerHandles.BulletJump then
    self:RemoveTimer(self.LuaTimerHandles.BulletJump)
    self.LuaTimerHandles.BulletJump = nil
  end
  if self.BulletJumpDirectionInfo then
    self.BulletJumpDirectionInfo = nil
  end
  self.AutoSyncProp.IsBulletJumping = false
end

function PlayerCommonInterface:ReleaseFire()
end

function PlayerCommonInterface:StopFire(bStillHoldFire)
end

function PlayerCommonInterface:EnterWalkingTag()
  self:SetRotationRate("OnGround")
  if not self:IsAnimCrouch() then
  end
end

function PlayerCommonInterface:CheckKeepBoneHit()
end

function PlayerCommonInterface:ApplyEffectBoneHit(DamageCauser, EffectParamentTable)
end

function PlayerCommonInterface:EndBoneHit()
  self.PlayerAnimInstance.InBoneHit = false
end

function PlayerCommonInterface:ChangeToNewWeapon(WeaponId)
  local WeaponData = DataMgr.BattleWeapon[WeaponId]
  if not WeaponData then
    ScreenPrint("请输入正确的武器编号:" .. tostring(WeaponId))
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    ScreenPrint("连接服务器情况下，请在军械库更换武器")
    return
  end
  if not IsAuthority(self) then
    ScreenPrint("多人联机模式不能换武器")
    return
  end
  
  local function HasTag(WeaponData, Tag)
    local WeaponTag = WeaponData.WeaponTag
    if not WeaponTag then
      return false
    end
    for _, _Tag in pairs(WeaponTag) do
      if Tag == _Tag then
        return true
      end
    end
    return false
  end
  
  if HasTag(WeaponData, "Ultra") then
    ScreenPrint("无法更换显赫武器")
    return
  end
  if HasTag(WeaponData, "Condemn") then
    ScreenPrint("无法更换处刑武器")
    return
  end
  local IsMelee = HasTag(WeaponData, "Melee")
  local NewWeapons = {}
  table.insert(NewWeapons, {WeaponId = WeaponId, Weight = 1.5})
  for _WeaponId, _Weapon in pairs(self.Weapons) do
    if not _Weapon.IsChild then
      if _Weapon:HasTag("Ultra") or _Weapon:HasTag("Condemn") then
        table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 3})
      elseif IsMelee then
        if not _Weapon:HasTag("Melee") then
          table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 2})
        end
      elseif not _Weapon:HasTag("Ranged") then
        table.insert(NewWeapons, {WeaponId = _WeaponId, Weight = 1})
      end
    end
  end
  table.sort(NewWeapons, function(a, b)
    return a.Weight < b.Weight
  end)
  local CurSkill = self:GetCurrentSkill()
  if CurSkill then
    self:StopSkill(UE.ESkillStopReason.ForceCancel)
  end
  self:ClearWeapon()
  for _, WeaponInfo in pairs(NewWeapons) do
    local Weapon = self:AddWeapon(WeaponInfo.WeaponId)
    Weapon:UnBindWeaponFromHand()
    Weapon:ShouldHideWeapon(true, true)
    Weapon:UnBindWeaponFromHand()
  end
  self:ChangeUsingWeaponByType("Melee")
end

function PlayerCommonInterface:AnimIdleStart()
end

function PlayerCommonInterface:StartJump()
  self:PlayerDoJump()
  if self.NeedJumpEvent then
    EventManager:FireEvent(EventID.OnJumpPressed)
  end
end

function PlayerCommonInterface:SetDebugDrawTest(Debugable)
  _G.DrawDebugTest = Debugable
end

function PlayerCommonInterface:SetCanInteractiveTrigger(bIsCanTrigger, Tag)
  local Tag = Tag or "Default"
  self.DisableInteractiveTriggerTagMap = self.DisableInteractiveTriggerTagMap or {}
  if bIsCanTrigger then
    self.DisableInteractiveTriggerTagMap[Tag] = nil
  else
    self.DisableInteractiveTriggerTagMap[Tag] = true
  end
  local bForbidInteractiveTrigger = nil ~= next(self.DisableInteractiveTriggerTagMap)
  if self.bForbidInteractiveTrigger == bForbidInteractiveTrigger then
    return
  end
  self.bForbidInteractiveTrigger = bForbidInteractiveTrigger
  if self.InteractiveTriggerComponent then
    self.InteractiveTriggerComponent:SetIsCanTrigger(not bForbidInteractiveTrigger)
  end
end

function PlayerCommonInterface:CheckCanInteractiveTrigger()
  return not self.bForbidInteractiveTrigger
end

function PlayerCommonInterface:RefreshRegionNameInfo(UId, ObjId)
  local Name = ""
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local RegionAvatars = Avatar.RegionAvatars or {}
    local OtherAvatar = RegionAvatars[ObjId]
    Name = OtherAvatar and OtherAvatar.AvatarInfo.Nickname
  end
  local Member, Pos = TeamController:GetModel():GetTeamMember(UId)
  self:EnableHeadWidget("Name", false)
  local Style = "Player"
  if 0 == Pos or not Pos then
    Style = nil
  end
  self:EnableHeadWidget("Name", true, Name, Style, Pos)
  self:RefreshAutoOnlineActionTagByRegionState(ObjId)
end

function PlayerCommonInterface:GetRegionOnlineCharObjId()
  if self.RegionInterComp and self.RegionInterComp.CharObjId then
    return self.RegionInterComp.CharObjId
  end
  if self.RegionInterAddFriendComp and self.RegionInterAddFriendComp.CharObjId then
    return self.RegionInterAddFriendComp.CharObjId
  end
  if self.RegionInterInviteTeamComp and self.RegionInterInviteTeamComp.CharObjId then
    return self.RegionInterInviteTeamComp.CharObjId
  end
  if self.RegionInterPersonInfoComp and self.RegionInterPersonInfoComp.CharObjId then
    return self.RegionInterPersonInfoComp.CharObjId
  end
  return nil
end

function PlayerCommonInterface:GetRegionNameWidget()
  local HeadWidgetComponent = self:GetHeadWidgetComponent()
  local TargetObjId = self:GetRegionOnlineCharObjId()
  if not HeadWidgetComponent and TargetObjId then
    local RegionSyncSubsys = UE4.URegionSyncSubsystem.GetInstance(GWorld.GameInstance)
    if RegionSyncSubsys then
      HeadWidgetComponent = RegionSyncSubsys:GetPlayerHeadWidgetComp(CommonUtils.ObjId2Str(TargetObjId))
      DebugPrint("GetRegionNameWidget fallback RegionSyncSubsys", self, self and self.Eid, TargetObjId, HeadWidgetComponent)
    end
  end
  if not HeadWidgetComponent then
    DebugPrint("GetRegionNameWidget no head widget comp", self, self and self.Eid, TargetObjId)
    return nil
  end
  local UniformWidget = HeadWidgetComponent:GetWidget()
  if not UniformWidget then
    DebugPrint("GetRegionNameWidget no uniform widget", self, self and self.Eid, TargetObjId, HeadWidgetComponent)
    return nil
  end
  return UniformWidget.Npc_Name_PC
end

function PlayerCommonInterface:CanRefreshRegionAutoOnlineActionTag()
  return self:IsMainPlayer() or self.FromOtherWorld == true
end

function PlayerCommonInterface:ShouldHideAutoOnlineActionTagByResourceId(ResourceId)
  if not ResourceId or 0 == ResourceId then
    return false
  end
  local ResourceInfo = DataMgr.Resource and DataMgr.Resource[ResourceId]
  if not ResourceInfo then
    DebugPrint("AutoTag resource missing", self, ResourceId)
    return false
  end
  local bHide = 1 == ResourceInfo.InteractPlayerNum
  DebugPrint("AutoTag resource interact count", self, ResourceId, ResourceInfo.InteractPlayerNum, bHide)
  return bHide
end

function PlayerCommonInterface:GetAutoOnlineActionTagResourceId(RoleInfo, RegionOnlineItem)
  if not RegionOnlineItem then
    local UseTargetParam = RoleInfo and RoleInfo.UseTargetParam or nil
    local ResourceId = UseTargetParam and UseTargetParam.ResourceId or nil
    if ResourceId and 0 ~= ResourceId then
      return ResourceId
    end
    return nil
  end
  for UniqueId, ItemData in pairs(RegionOnlineItem) do
    local ResourceId = ItemData and ItemData.ResourceId or nil
    if ResourceId and 0 ~= ResourceId then
      return ResourceId
    end
    if UniqueId and 0 ~= UniqueId then
      ResourceId = OnlineActionModel:GetResourceIdByUniqueId(UniqueId)
      if ResourceId and 0 ~= ResourceId then
        return ResourceId
      end
    end
  end
  local UseTargetParam = RoleInfo and RoleInfo.UseTargetParam or nil
  local ResourceId = UseTargetParam and UseTargetParam.ResourceId or nil
  if ResourceId and 0 ~= ResourceId then
    return ResourceId
  end
  return nil
end

function PlayerCommonInterface:ShouldShowAutoOnlineActionTagByRegionState(ObjId)
  if not self:CanRefreshRegionAutoOnlineActionTag() then
    DebugPrint("ShouldShow false neither main nor other world", self, self and self.Eid, self and self.FromOtherWorld)
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.IsInRegionOnline then
    DebugPrint("ShouldShow false not in region online", self, Avatar, Avatar and Avatar.IsInRegionOnline)
    return false
  end
  local TargetObjId = ObjId or self:GetRegionOnlineCharObjId()
  if not TargetObjId then
    DebugPrint("ShouldShow false no target objid", self, ObjId)
    return false
  end
  if TargetObjId == Avatar.Eid then
    if Avatar.AutoAgreeInvite ~= true then
      DebugPrint("ShouldShow self false auto agree off", self, TargetObjId, Avatar.AutoAgreeInvite)
      return false
    end
    local ActionUniqueId = OnlineActionModel:GetActionUniqueId()
    local HasOwnerMechanism = nil ~= ActionUniqueId and 0 ~= ActionUniqueId
    local ResourceId = HasOwnerMechanism and OnlineActionModel:GetResourceIdByUniqueId(ActionUniqueId) or nil
    if HasOwnerMechanism and self:ShouldHideAutoOnlineActionTagByResourceId(ResourceId) then
      DebugPrint("ShouldShow self false single interact resource", self, TargetObjId, ActionUniqueId, ResourceId)
      return false
    end
    DebugPrint("ShouldShow self final", self, TargetObjId, ActionUniqueId, ResourceId, HasOwnerMechanism)
    return HasOwnerMechanism
  end
  local RegionAvatars = Avatar.RegionAvatars or {}
  local AvatarData = RegionAvatars[TargetObjId]
  if not AvatarData or AvatarData.AutoAgreeInvite ~= true then
    DebugPrint("ShouldShow false auto agree off or no avatar data", self, TargetObjId, AvatarData and AvatarData.AutoAgreeInvite)
    return false
  end
  local RoleInfo = Avatar.GetRoleInfo and Avatar:GetRoleInfo(TargetObjId) or nil
  local CurrentState = RoleInfo and RoleInfo.CurrentState or nil
  local RegionOnlineItem = AvatarData.RegionOnlineItem
  local ResourceId = self:GetAutoOnlineActionTagResourceId(RoleInfo, RegionOnlineItem)
  local HasOwnerMechanism = RegionOnlineItem and nil ~= next(RegionOnlineItem)
  local IsUsingWheel = CurrentState == CommonConst.OnlineState.UseWheel
  local HasGestureResource = nil ~= ResourceId and 0 ~= ResourceId
  if HasOwnerMechanism and self:ShouldHideAutoOnlineActionTagByResourceId(ResourceId) then
    DebugPrint("ShouldShow false single interact resource", self, TargetObjId, CurrentState, ResourceId)
    return false
  end
  local bShow = HasOwnerMechanism and (IsUsingWheel or HasGestureResource)
  DebugPrint("ShouldShow final", self, TargetObjId, HasOwnerMechanism, CurrentState, ResourceId, bShow)
  return bShow
end

function PlayerCommonInterface:RefreshAutoOnlineActionTagByRegionState(ObjId)
  if not self:CanRefreshRegionAutoOnlineActionTag() then
    DebugPrint("Refresh skip neither main nor other world", self, self and self.Eid, self and self.FromOtherWorld)
    return
  end
  local NameWidget = self:GetRegionNameWidget()
  if not NameWidget then
    DebugPrint("Refresh skip no name widget", self, self and self.Eid, ObjId)
    return
  end
  local bShow = self:ShouldShowAutoOnlineActionTagByRegionState(ObjId)
  DebugPrint("Refresh result", self, self and self.Eid, ObjId, bShow)
  NameWidget:RefreshAutoOnlineActionTagVisible(bShow)
end

function PlayerCommonInterface:RefreshTitleInfo(ObjId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local RegionAvatars = Avatar.RegionAvatars or {}
  local OtherAvatar = RegionAvatars[ObjId]
  if not OtherAvatar or not OtherAvatar.AvatarInfo then
    return
  end
  local PrefixId = OtherAvatar.AvatarInfo.TitleBefore
  local SuffixId = OtherAvatar.AvatarInfo.TitleAfter
  local TitleFrameId = OtherAvatar.AvatarInfo.TitleFrame
  print(_G.LogTag, "RefreshTitleInfo", PrefixId, SuffixId, TitleFrameId)
  self:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
end

function PlayerCommonInterface:EnableTitle(PrefixId, SuffixId, TitleFrameId)
  self:EnableHeadWidget("Title", true, PrefixId, SuffixId, TitleFrameId)
end

function PlayerCommonInterface:DisableTitle()
  self:EnableHeadWidget("Title", false)
end

function PlayerCommonInterface:RefreshTitle(PrefixId, SuffixId, TitleFrameId)
  self:DisableTitle()
  self:EnableTitle(PrefixId, SuffixId, TitleFrameId)
end

function PlayerCommonInterface:PlayEmoji(EmojiPath)
  self:EnableHeadWidget("Bubble_Emoji", true, EmojiPath)
end

function PlayerCommonInterface:StopEmoji()
  self:EnableHeadWidget("Bubble_Emoji", false)
end

function PlayerCommonInterface:InitBattleWheelForbidGroup()
  local ActionAllow = {
    W = true,
    A = true,
    S = true,
    D = true,
    OpenBattleWheel = true,
    Fire = true
  }
  local KeyboardMap = DataMgr.KeyboardMap
  for ActionName, _ in pairs(KeyboardMap) do
    if not ActionAllow[ActionName] then
      self:AddToActionGroups("BattleWheelForbid", ActionName)
    end
  end
end

function PlayerCommonInterface:DisablePlayerInputInDeliver(bDisable)
  UIManager(self):SetBannedActionCallback("InDeliver", bDisable)
end

return PlayerCommonInterface
