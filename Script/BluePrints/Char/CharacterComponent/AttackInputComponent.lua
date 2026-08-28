local SkillUtils = require("Utils.SkillUtils")
local BattleEventName = require("BluePrints/Combat/BattleEvents/BattleEventName")
local Component = {}
local SkillTypeCache = {}
local SkillNameCache = {}

local function GetSkillTypeCache(SkillTypeName)
  local SkillType = rawget(SkillTypeCache, SkillTypeName)
  if nil == SkillType then
    SkillType = UE.ESkillType[SkillTypeName]
    if nil ~= SkillType then
      rawset(SkillTypeCache, SkillTypeName, SkillType)
    end
  end
  return SkillType
end

local function GetSkillNameCache(SkillNameStr)
  local SkillNameEnum = rawget(SkillNameCache, SkillNameStr)
  if nil == SkillNameEnum then
    SkillNameEnum = ESkillName[SkillNameStr]
    if nil ~= SkillNameEnum then
      rawset(SkillNameCache, SkillNameStr, SkillNameEnum)
    end
  end
  return SkillNameEnum
end

local SkillType = setmetatable({}, {
  __index = function(self, SkillTypeName)
    local SkillTypeEnum = GetSkillTypeCache(SkillTypeName)
    if nil ~= SkillTypeEnum then
      rawset(self, SkillTypeName, SkillTypeEnum)
    end
    return SkillTypeEnum
  end
})
local SkillName = setmetatable({}, {
  __index = function(self, SkillNameStr)
    local SkillNameEnum = GetSkillNameCache(SkillNameStr)
    if nil ~= SkillNameEnum then
      rawset(self, SkillNameStr, SkillNameEnum)
    end
    return SkillNameEnum
  end
})
local CanCheckShootTag = {
  Idle = 1,
  Crouch = 1,
  Falling = 1
}

function Component:CheckHasHoldingShooting()
  local HeavyShootingSkill = self:GetSkillByType(SkillType.HeavyShooting)
  return self.bHoldingShooting and self.CurrentSkillId ~= HeavyShootingSkill
end

function Component:CheckHasHoldingShootingSkill()
  local HeavyShootingSkill = self:GetSkillByType(SkillType.HeavyShooting)
  return HeavyShootingSkill > 0 and self.bPressedFire
end

function Component:PressSkill3()
  if self:CheckSkillOccupiedByProp(SkillName.Skill3) and self.PropEffectComponent.CurrentPropEffect then
    self.PropEffectComponent.CurrentPropEffect:OnSkill3Pressed()
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local UIUnlockRule = DataMgr.UIUnlockRule
    local UIUnlockRuleId = UIUnlockRule.PetSkill.UIUnlockRuleId
    local bUnlocked = Avatar:CheckUIUnlocked(UIUnlockRuleId)
    if not bUnlocked then
      UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, UIUnlockRule.PetSkill.UIUnlockDesc)
      return
    end
  end
  if self:CheckSkillIsBan(SkillName.Skill3) then
    local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    return
  end
  if self:CheckForbidInput() or self:CheckSkillInActive(SkillName.Skill3) then
    return
  end
  if self:IsDisableSkillType(SkillType.Skill3) then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    return
  end
  self:SupportSkill()
  if self.NeedSkill3Event then
    EventManager:FireEvent(EventID.OnSkill3Pressed)
  end
end

function Component:CheckChangeRoleInMainCityNotInCdTime()
  local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  if self.SupportUseTimeStamp == nil then
    self.SupportUseTimeStamp = NowTime
    return true
  end
  local IsCanUse = NowTime - self.SupportUseTimeStamp >= 1
  if IsCanUse then
    self.SupportUseTimeStamp = NowTime
  end
  return IsCanUse
end

function Component:SupportSkill()
  local SupportSKill = self:GetSkillByType(SkillType.Support)
  if nil == SupportSKill then
    return false
  end
  Battle(self):TriggerBattleEvent(BattleEventName.BeforeSupportSkill, self)
  local Success = self:UseSkill(SupportSKill, 0)
  if Success then
    self:RemoveInputCache("Support")
    local BattlePet = self:GetBattlePet()
    Battle(self):TriggerBattleEvent(BattleEventName.AfterSupportSkill, self)
    EventManager:FireEvent(EventID.OnTheaterPerform, BattlePet.PetId)
    if BattlePet then
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      local SceneMgrComponent = GameInstance:GetSceneManager()
      if IsValid(SceneMgrComponent) and SceneMgrComponent.NearestPetGuideEid and SceneMgrComponent.NearestPetGuideEid > 0 then
        local TargetEid = SceneMgrComponent.NearestPetGuideEid
        local TargetActor = Battle(self):GetEntity(TargetEid)
        if IsValid(TargetActor) then
          local TargetLocation = TargetActor:K2_GetActorLocation()
          local TargetRotation = TargetActor:K2_GetActorRotation()
          self:K2_TeleportTo(TargetLocation, TargetRotation, false, nil, false)
        end
      end
    end
  end
end

function Component:Reload()
  if self.NeedChargeBulletEvent then
    EventManager:FireEvent(EventID.OnChargeBulletPressed)
  end
  local ReloadSkillId = self:GetSkillByType(SkillType.Reload)
  if nil == ReloadSkillId then
    return false
  end
  if not self:CheckCanSkillCancel(ReloadSkillId) and self:CheckForbidInput() then
    return
  end
  if self:CheckSkillIsBan(SkillName.Fire) then
    local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_RANGED_FORBIDDEN"))
    return
  end
  if not self:CheckCanShoot(true) or self:CheckSkillInActive(SkillName.Fire) then
    return
  end
  local ReloadSkill = self:GetSkill(ReloadSkillId)
  if not ReloadSkill then
    return
  end
  local FireSkillId = self:GetSkillByType(SkillType.Shooting)
  local FireSkill = self:GetSkill(FireSkillId)
  if FireSkill and FireSkill.Weapon ~= ReloadSkill.Weapon then
    return
  end
  local IsInShoot = self.CurrentSkillId == FireSkillId
  local IsCrouchng = self.PlayerAnimInstance and not self.PlayerAnimInstance.IsCrouching
  if not IsInShoot and IsCrouchng then
    self.CanReloadWithoutShoot = true
  end
  local Success = self:UseSkill(ReloadSkillId, 0)
  self.CanReloadWithoutShoot = false
  if Success then
    self:RemoveInputCache("Reload")
  end
end

function Component:IsSkillDown()
  return self.bPressedAttack or self.bPressedFire or self.bPressedSkill1 or self.bPressedSkill2
end

function Component:InputCacheUseHoldAttackSkill()
  local HoldAttackSkill = self:GetSkillByType(SkillType.HeavyAttack)
  if nil == HoldAttackSkill then
    self:RemoveInputCache("AttackHold")
    return
  end
  local Success = self:UseSkill(HoldAttackSkill, 0)
  if Success then
    self:RemoveInputCache("AttackHold")
  end
end

function Component:PressSkill1()
  local NormalSKill = self:GetSkillByType(SkillType.Skill1)
  if not NormalSKill then
    self:RemoveInputCache("Skill1")
    return
  end
  if self:CheckSkillIsBan(SkillName.Skill1) then
    local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    self:RemoveInputCache("Skill1")
    return
  end
  if self:IsDisableSkillType(SkillType.Skill1) then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    self:RemoveInputCache("Skill1")
    return
  end
  if not self:CheckCanSkillCancel(NormalSKill) and self:CheckForbidInput() or self:CheckSkillInActive(SkillName.Skill1) then
    self:RemoveInputCache("Skill1")
    return
  end
  self:PressSkill(NormalSKill, "Skill1")
  if self.NeedSkill1Event then
    EventManager:FireEvent(EventID.OnSkill1Pressed)
  end
end

function Component:PressSkill2()
  local UltraSKill = self:GetSkillByType(SkillType.Skill2)
  if not UltraSKill then
    self:RemoveInputCache("Skill2")
    return
  end
  if self:CheckSkillIsBan(SkillName.Skill2) and not self.CurrentMasterBan then
    local _ = not self.CurrentMasterBan and UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    self:RemoveInputCache("Skill2")
    return
  end
  if self:IsDisableSkillType(SkillType.Skill2) then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    self:RemoveInputCache("Skill2")
    return
  end
  if not self:CheckCanSkillCancel(UltraSKill) and self:CheckForbidInput() or self:CheckSkillInActive(SkillName.Skill2) then
    self:RemoveInputCache("Skill2")
    return
  end
  self:PressSkill(UltraSKill, "Skill2")
  if self.NeedSkill2Event then
    EventManager:FireEvent(EventID.OnSkill2Pressed)
  end
end

function Component:InputCacheUseHoldSkill(SkillId, SkillName)
  if not SkillId then
    self:RemoveInputCache(SkillName .. "Hold")
    return
  end
  local Skill = self:GetSkill(SkillId)
  if not Skill or 0 == Skill.LongPressSkill then
    self:RemoveInputCache(SkillName .. "Hold")
    return
  end
  local Success = self:UseSkill(Skill.LongPressSkill, 0)
  if Success then
    self:RemoveInputCache(SkillName .. "Hold")
  end
end

function Component:ReleaseSkill1()
  local NormalSKill = self:GetSkillByType(SkillType.Skill1)
  if not NormalSKill then
    self:ResetAttackProperty("Skill1")
    return
  end
  if not self:CheckCanSkillCancel(NormalSKill) and self:CheckForbidInput() or self:CheckSkillInActive(SkillName.Skill1) then
    self:ResetAttackProperty("Skill1")
    return
  end
  local Skill = self:GetSkill(NormalSKill)
  self:ReleaseSkill(NormalSKill, "Skill1")
end

function Component:ReleaseSkill2()
  local UltraSKill = self:GetSkillByType(SkillType.Skill2)
  if not UltraSKill then
    self:ResetAttackProperty("Skill2")
    return
  end
  if not self:CheckCanSkillCancel(UltraSKill) and self:CheckForbidInput() or self:CheckSkillInActive(SkillName.Skill2) then
    self:ResetAttackProperty("Skill2")
    return
  end
  local Skill = self:GetSkill(UltraSKill)
  self:ReleaseSkill(UltraSKill, "Skill2")
end

function Component:InputCacheUseSkill(SkillId, InputSkillName)
  if not SkillId or not self:CheckCanSkillCancel(SkillId) and self:CheckForbidInput() or self:CheckSkillInActive(GetSkillNameCache(InputSkillName)) then
    self:RemoveInputCache(InputSkillName)
    return
  end
  local Success = self:UseSkill(SkillId, 0)
  if Success then
    self:RemoveInputCache(InputSkillName)
  end
end

function Component:UsePenalizeSkill(Eid)
  self.CondemnMonsterEid = Eid
  local Success = self:UseSkill(self:GetSkillByType(SkillType.Condemn), 0)
  return Success
end

local InputInfoTemplate = {
  ReMappingActionName = "",
  OriginKeyState = EInputEvent.IE_Released,
  Init = function(self, ReMappingActionName, OriginKeyState, MappedKeyState)
    self.ReMappingActionName = ReMappingActionName
    self.OriginKeyState = OriginKeyState or EInputEvent.IE_Released
  end
}

function Component:InitReplaceGamepadSet(KeySet)
  self.BattleMapping:Clear()
  self.SystemMapping:Clear()
  self.BattleInputMappingKey:Clear()
  self.SystemInputMappingKey:Clear()
  self.StopListenWhenPressUseSkill:Clear()
  self.StopListenWhenReleaseUseSkill:Clear()
  self.InputSetting = UE4.UInputSettings.GetInputSettings()
  local ActionMappings = self.InputSetting.ActionMappings:ToTable()
  local GamepadSet = DataMgr.GamepadMap
  for _, UserData in ipairs(ActionMappings) do
    if UserData.ActionName == "GamepadUseSkill" then
      self.GamepadUseSkillKey = UserData.Key
    end
    if UserData.ActionName == "GamepadOpenSystem" then
      self.GamepadOpenSystemKey = UserData.Key
    end
    if string.find(UserData.Key.KeyName, "Gamepad") then
      DebugPrint("@zyh222", UserData.ActionName, UserData.Key.KeyName)
    end
  end
  for ActionName, ActionData in pairs(GamepadSet) do
    if ActionData.BattleInput and ActionData.BattleInput[KeySet] then
      self.BattleMapping:Add(ActionData.BattleInput[KeySet], ActionName)
      for _, UserData in ipairs(ActionMappings) do
        local Res = string.find(UserData.Key.KeyName, "Gamepad")
        if (UserData.ActionName == ActionData.BattleInput[KeySet] or UserData.ActionName == ActionData.ActionName) and Res then
          DebugPrint("@zyh ReplaceUseSkill", UserData.ActionName, UserData.Key.KeyName)
          self.BattleInputMappingKey:Add(ActionData.BattleInput[KeySet], UserData)
        end
      end
    end
  end
  for ActionName, ActionData in pairs(GamepadSet) do
    if ActionData.SystemInput and ActionData.SystemInput[KeySet] then
      self.SystemMapping:Add(ActionData.SystemInput[KeySet], ActionName)
      for _, UserData in ipairs(ActionMappings) do
        local Res = string.find(UserData.Key.KeyName, "Gamepad")
        if UserData.ActionName == ActionData.SystemInput[KeySet] and Res then
          DebugPrint("@zyh ReplaceOpenSystem", UserData.ActionName, UserData.Key.KeyName)
          self.SystemInputMappingKey:Add(ActionData.SystemInput[KeySet], UserData)
        end
      end
    end
  end
end

function Component:InitGamepadSet(KeySet)
  local NameMapping = {}
  local CurrentKeyMapping = {}
  self.ActionToGamepadIcon = {}
  self.InputSetting = UE4.UInputSettings.GetInputSettings()
  if not self.InputSetting then
    DebugPrint("@@zyh 获取InputSetting失败")
    return
  end
  local ActionMappings = self.InputSetting.ActionMappings:ToTable()
  local GamepadSet = DataMgr.GamepadMap
  for _, UserData in ipairs(ActionMappings) do
    local ActionName = UserData.ActionName
    if GamepadSet[ActionName] and GamepadSet[ActionName].GamepadKey and GamepadSet[ActionName].GamepadKey[KeySet] then
      local KeyName = "Gamepad_" .. GamepadSet[ActionName].GamepadKey[KeySet]
      if string.find(UserData.Key.KeyName, "Gamepad") and UserData.Key.KeyName ~= KeyName then
        self.InputSetting:RemoveActionMapping(UserData)
      end
      local NewKey = UE4.EKeys[KeyName]
      UserData.Key = NewKey
      self.InputSetting:AddActionMapping(UserData)
    elseif GamepadSet[ActionName] and (not GamepadSet[ActionName].GamepadKey or not GamepadSet[ActionName].GamepadKey[KeySet]) and string.find(UserData.Key.KeyName, "Gamepad") then
      self.InputSetting:RemoveActionMapping(UserData)
    end
  end
  ActionMappings = self.InputSetting.ActionMappings:ToTable()
  for ActionName, ActionData in pairs(GamepadSet) do
    if ActionData.GamepadKey and ActionData.GamepadKey[KeySet] then
      NameMapping[ActionName] = "Gamepad_" .. ActionData.GamepadKey[KeySet]
      for _, UserData in ipairs(ActionMappings) do
        local Res = string.find(UserData.Key.KeyName, "Gamepad")
        if UserData.ActionName == ActionName and Res then
          if not CurrentKeyMapping[ActionName] then
            CurrentKeyMapping[ActionName] = {UserData}
          else
            table.insert(CurrentKeyMapping[ActionName], UserData)
          end
        end
      end
    end
  end
  for ActionName, KeyName in pairs(NameMapping) do
    if CurrentKeyMapping[ActionName] then
      for _, UserData in ipairs(CurrentKeyMapping[ActionName]) do
        DebugPrint("@zyh 被删掉的映射", UserData.ActionName, UserData.Key.KeyName)
        self.InputSetting:RemoveActionMapping(UserData)
      end
    end
  end
  for ActionName, ActionData in pairs(GamepadSet) do
    if ActionData.GamepadKey and ActionData.GamepadKey[KeySet] then
      local KeyName = "Gamepad_" .. ActionData.GamepadKey[KeySet]
      DebugPrint("@zyh 添加的映射关系", ActionName, KeyName)
      local FInputActionKeyMapping = UE4.FInputActionKeyMapping()
      FInputActionKeyMapping.ActionName = ActionName
      FInputActionKeyMapping.Key = UE4.EKeys[KeyName]
      self.InputSetting:AddActionMapping(FInputActionKeyMapping)
    end
  end
  self.InputSetting:SaveKeyMappings()
  ActionMappings = self.InputSetting.ActionMappings:ToTable()
  for _, UserData in ipairs(ActionMappings) do
    if string.find(UserData.Key.KeyName, "Gamepad") then
      DebugPrint("@zyh111", UserData.ActionName, UserData.Key.KeyName)
    end
  end
end

return Component
