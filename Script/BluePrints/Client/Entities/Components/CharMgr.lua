local CharModel = require("BluePrints.Common.MVC.Model.CharModel")
local Component = {}

function Component:EnterWorld()
  CharModel:Init(self)
  self._CharacterAttributeSwitchMapCache = self:_CopyCharacterAttributeSwitchMap(self.CharacterAttributeSwitch)
end

function Component:LeaveWorld()
  CharModel:Destory()
  self._CharacterAttributeSwitchMapCache = nil
end

function Component:GetCharUuidByCharId(CharId)
  return CharModel:GetUuidByCharId(CharId)
end

function Component:CheckCharEnough(CheckData)
  for CharId, Count in pairs(CheckData) do
    local IsExist = false
    for key, Char in pairs(self.Chars) do
      if Char.CharId == CharId then
        IsExist = true
        break
      end
    end
    if not IsExist then
      return false
    end
  end
  return true
end

function Component:_OnPropChangeChars(Keys)
  local CharUuid = Keys and Keys[1]
  if CharUuid then
    local bHasChar = CharModel:GetCardLevelResourceByUuid(CharUuid)
    if bHasChar then
      if not self.Chars[CharUuid] then
        EventManager:FireEvent(EventID.OnCharDeleted, CharUuid)
      end
    elseif self.Chars[CharUuid] then
      CharModel:OnNewCharObtained(CharUuid)
      EventManager:FireEvent(EventID.OnNewCharObtained, CharUuid)
    end
    if "GradeLevel" == Keys[2] then
      EventManager:FireEvent(EventID.OnCharCardLevelResourcesChanged, nil, nil, CharUuid)
    end
  end
end

function Component:_OnPropChangeCommonChars(Keys)
  local CharId = Keys and Keys[1]
  if not CharId then
    return
  end
  local CommonChar = self.CommonChars[CharId]
  if not CommonChar then
    return
  end
  for SkinId, Skin in pairs(CommonChar.OwnedSkins or {}) do
    if CharModel:GetCharIdBySkinId(SkinId) == nil then
      CharModel:OnNewCharSkinObtained(SkinId, CharId)
      EventManager:FireEvent(EventID.OnNewCharSkinObtained, SkinId, CharId)
    end
  end
  for HairId, Hair in pairs(CommonChar.OwnedHairs or {}) do
    if nil == CharModel:GetCharIdByHairId(HairId) then
      CharModel:OnNewCharHairObtained(HairId, CharId)
      EventManager:FireEvent(EventID.OnNewCharHairObtained, HairId, CharId)
    end
  end
end

function Component:_OnPropChangeOtherCharSkins(Keys)
  local CharId = Keys and Keys[1]
  if not CharId then
    return
  end
  local OtherCharSkins = self.OtherCharSkins[CharId]
  if not OtherCharSkins then
    return
  end
  for _, SkinId in pairs(OtherCharSkins or {}) do
    if CharModel:GetCharIdBySkinId(SkinId) == nil then
      CharModel:OnNewCharSkinObtained(SkinId, CharId)
      EventManager:FireEvent(EventID.OnNewCharSkinObtained, SkinId, CharId)
    end
  end
end

function Component:_OnPropChangeOtherCharHairs(Keys)
  local CharId = Keys and Keys[1]
  if not CharId then
    return
  end
  local OtherCharHairs = self.OtherCharHairs[CharId]
  if not OtherCharHairs then
    return
  end
  for Hair, HairId in pairs(OtherCharHairs or {}) do
    if CharModel:GetCharIdByHairId(HairId) == nil then
      CharModel:OnNewCharHairObtained(HairId, CharId)
      EventManager:FireEvent(EventID.OnNewCharHairObtained, HairId, CharId)
    end
  end
end

function Component:_OnPropChangeCommonCharHairs(Keys)
  local HairId = Keys and Keys[1]
  if not HairId then
    return
  end
  local CommonCharHair = self.CommonCharHairs[HairId]
  if not CommonCharHair then
    return
  end
  CharModel:OnNewCharHairObtained(HairId)
  EventManager:FireEvent(EventID.OnNewCharHairObtained, HairId)
end

function Component:_OnPropChangeResources(Keys)
  local ResourceId = Keys and Keys[1]
  if ResourceId then
    local CharIds = CharModel:GetCharIdsByCardLevelResource(ResourceId, self)
    for CharId, value in pairs(CharIds or {}) do
      EventManager:FireEvent(EventID.OnCharCardLevelResourcesChanged, ResourceId, CharId, CharModel:GetUuidByCharId(CharId))
    end
  end
end

function Component:_OnPropChangeStoredCollectReward(Keys)
  local Strings = string.split(Keys and Keys[1] or "", ".")
  if #Strings > 0 then
    CharModel:OnPropChangeStoredCollectReward(Strings)
  end
end

function Component:IsCharHasReward(CharId)
  return CharModel:IsCharHasReward(CharId)
end

function Component:_OnPropChangeCharAccessorys()
  for _, AccessoryId in pairs(self.CharAccessorys) do
    if not self:IsCharAccessoryExist(AccessoryId) then
      CharModel:OnNewCharAccessoryObtained(AccessoryId)
      EventManager:FireEvent(EventID.OnNewCharAccessoryObtained, AccessoryId)
    end
  end
end

function Component:IsCharAccessoryExist(AccessoryId)
  return CharModel:IsCharAccessoryExist(AccessoryId)
end

function Component:IsCharSkinExist(SkinId)
  local CharId = CharModel:GetCharIdBySkinId(SkinId)
  if not CharId then
    for _, CharSkins in pairs(self.OtherCharSkins) do
      for _, CharSkinId in pairs(CharSkins) do
        if CharSkinId == SkinId then
          return true
        end
      end
    end
  else
    return true
  end
  return false
end

function Component:IsHeadSculptureExist(FrameID)
  for _, Value in pairs(self.HeadIconList) do
    if Value == FrameID then
      return true
    end
  end
end

function Component:ChangeChar(cb)
  local function callback(ret, ResourceReturn)
    self.logger.debug("ChangeChar", ret, ResourceReturn)
    
    cb(ret, ResourceReturn)
  end
  
  self:CallServer("ChangeChar", callback)
end

function Component:SwitchCurrentChar(CharUuid)
  self.logger.debug("SwitchCurrentChar", CharUuid)
  self:CallServerMethod("SwitchCurrentChar", CharUuid)
end

function Component:OnSwitchCurrentChar(Ret, CharUuid)
  self.logger.debug("OnSwitchCurrentChar", Ret, CharUuid)
  EventManager:FireEvent(EventID.OnSwitchCurrentChar, Ret, CharUuid)
  if Ret == ErrorCode.RET_SUCCESS then
    EventManager:FireEvent(EventID.OnSwitchRole, CharUuid)
  end
end

function Component:SwitchWeapon(WeaponTag, WeaponUuid)
  self:CallServerMethod("SwitchWeapon", WeaponTag, WeaponUuid)
end

function Component:OnSwitchWeapon(Ret, WeaponTag, WeaponUuid)
  EventManager:FireEvent(EventID.OnChangeWeapon, Ret, WeaponTag, WeaponUuid)
  if not ErrorCode:Check(Ret) then
    return
  end
  EventManager:FireEvent(EventID.OnSwitchWeapon, WeaponTag, WeaponUuid)
  print(_G.LogTag, "OnSwitchWeapon : " .. self.Weapons[WeaponUuid].WeaponId)
end

function Component:ChangeCharMod(InCallbackInfo, CharUuid, ModSuitIndex, ModSlotId, ModUuid)
  local function callback(Ret)
    self.logger.debug("ZJT_ ChangeCharMod callback", Ret)
    
    if not InCallbackInfo then
      return
    end
    local TakeOffModUuid = table.unpack(InCallbackInfo.ExParams)
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, ModSuitIndex, ModSlotId, ModUuid, TakeOffModUuid)
  end
  
  self:CallServer("ChangeCharMod", callback, CharUuid, ModSuitIndex, ModSlotId, ModUuid)
end

function Component:ExchangeCharMod(InCallbackInfo, CharUuid, ModSuitIndex, SModSlotId, TModSlotId)
  local function callback(Ret)
    self.logger.debug("ZJT_ ExchangeCharMod callback", Ret)
    
    if not InCallbackInfo then
      return
    end
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, ModSuitIndex, SModSlotId, TModSlotId)
  end
  
  self:CallServer("ExchangeCharMod", callback, CharUuid, ModSuitIndex, SModSlotId, TModSlotId)
end

function Component:TakeOffCharMod(InCallbackInfo, CharUuid, ModSuitIndex, ModSlotId)
  local function callback(Ret)
    self.logger.debug("ZJT_ TakeOffCharMod callback")
    
    if not InCallbackInfo then
      return
    end
    local TakeOffModUuid = table.unpack(InCallbackInfo.ExParams)
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, ModSuitIndex, ModSlotId, TakeOffModUuid)
  end
  
  self:CallServer("TakeOffCharMod", callback, CharUuid, ModSuitIndex, ModSlotId)
end

function Component:ChangeCharModSuit(InCallbackInfo, CharUuid, TargetModSuitIndex)
  local char = self.Chars[CharUuid]
  if char.ModSuitIndex == TargetModSuitIndex then
    return
  end
  
  local function callback(Ret)
    self.logger.debug("ChangeCharModSuit callback", Ret)
    if not InCallbackInfo then
      return
    end
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, TargetModSuitIndex)
  end
  
  self:CallServer("ChangeCharModSuit", callback, CharUuid, TargetModSuitIndex)
end

function Component:UpSkillLevel(Tag, Uuid, SkillId, CurrentLevel)
  local function callback(Ret)
    self.logger.debug("UpSkillLevel callback", Ret)
    
    EventManager:FireEvent(EventID.OnCharSkillLevelUp, Ret, SkillId, CurrentLevel, CurrentLevel + 1)
  end
  
  self:CallServer("UpSkillLevel", callback, Tag, Uuid, SkillId, CurrentLevel)
end

function Component:ActivateCharSkillTreeNode(CharUuid, TreeIndex, NodeIndex)
  self.logger.debug("ActivateCharSkillTreeNode Begin", TreeIndex, NodeIndex)
  
  local function callback(Ret)
    self.logger.debug("ActivateCharSkillTreeNode callback", Ret)
    EventManager:FireEvent(EventID.OnCharSkillTreeNodeActivated, Ret, CharUuid, TreeIndex, NodeIndex)
  end
  
  self:CallServer("ActivateCharSkillTreeNode", callback, CharUuid, TreeIndex, NodeIndex)
end

function Component:UnlockCharUsePiece(CharId, CB)
  self.logger.debug("UnlockCharUsePiece Begin", CharId)
  
  local function Callback(Ret)
    self.logger.debug("UnlockCharUsePiece Callback", Ret)
    if CB then
      CB(Ret, CharId)
    end
    EventManager:FireEvent(EventID.OnUnlockCharUsePiece, Ret, CharId)
  end
  
  self:CallServer("UnlockCharUsePiece", Callback, CharId)
end

function Component:UpCharGradeLevel(CharUuid, CurrentGradeLevel)
  local function callback(Ret)
    self.logger.debug("UpCharGradeLevel callback", Ret)
    
    EventManager:FireEvent(EventID.OnCharGradeLevelUp, Ret, CharUuid, CurrentGradeLevel)
  end
  
  self:CallServer("UpCharGradeLevel", callback, CharUuid, CurrentGradeLevel)
end

function Component:UpCharExtraGradeLevel(CharUuid)
  self.logger.debug("UpCharExtraGradeLevel begin", CommonUtils.ObjId2Str(CharUuid))
  
  local function Callback(Ret)
    self.logger.debug("UpCharExtraGradeLevel Callback", Ret)
    EventManager:FireEvent(EventID.OnCharExtraGradeLevelUp, Ret, CharUuid)
  end
  
  self:CallServer("UpCharExtraGradeLevel", Callback, CharUuid)
end

function Component:CharLevelUp(CharUuid, CurrentLevel, TargetLevel)
  self.logger.debug("CharLevelUp", CommonUtils.ObjId2Str(CharUuid), CurrentLevel, TargetLevel)
  local Char = self.Chars[CharUuid]
  if not Char then
    return
  end
  if CurrentLevel ~= Char.Level or TargetLevel <= CurrentLevel then
    return
  end
  
  local function callback(Ret)
    self.logger.debug("CharLevelUp, Ret", Ret, CommonUtils.ObjId2Str(CharUuid), CurrentLevel, TargetLevel)
    EventManager:FireEvent(EventID.OnCharLevelUp, Ret, CharUuid, CurrentLevel, TargetLevel)
  end
  
  self:CallServer("CharLevelUp", callback, CharUuid, CurrentLevel, TargetLevel)
end

function Component:CharBreakLevelUp(CharUuid, TargetBreakLevel)
  local Char = self.Chars[CharUuid]
  if not Char then
    return
  end
  if Char.EnhanceLevel + 1 ~= TargetBreakLevel then
    return
  end
  
  local function callback(Ret)
    self.logger.debug("CharBreakLevelUp, Ret", Ret, CommonUtils.ObjId2Str(CharUuid), self.Chars[CharUuid].EnhanceLevel)
    EventManager:FireEvent(EventID.OnCharBreakLevelUp, Ret, CharUuid, self.Chars[CharUuid].EnhanceLevel)
  end
  
  self:CallServer("CharBreakLevelUp", callback, CharUuid)
end

function Component:GetCurrentCharConfigID()
  DebugPrint("GetCurrentCharConfigID")
  return self.Chars[self.CurrentChar].CharId
end

function Component:GetCurrentMeleeWeaponConfigID()
  return self.Weapons[self.MeleeWeapon].WeaponId
end

function Component:GetCurrentRangedWeaponConfigID()
  return self.Weapons[self.RangedWeapon].WeaponId
end

function Component:UpdateCharModSuitName(InCallbackInfo, CharUuid, ModSuitIndex, NewName)
  local function Callback(Ret)
    self.logger.debug("UpdateCharModSuitName callback", Ret)
    
    if not InCallbackInfo then
      return
    end
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, ModSuitIndex, NewName)
  end
  
  self:CallServer("UpdateCharModSuitName", Callback, CharUuid, ModSuitIndex, NewName)
end

function Component:GetModRankData(TypeName, TargetId, CallbackInfo)
  if "Weapon" == TypeName or "UWeapon" == TypeName then
    self:CallServer("GetWeaponModRankData", function(ErrCode, Data, UserCount)
      self.logger.info("GetWeaponModRankData", ErrCode, CommonUtils.TableToString(Data), UserCount)
      CallbackInfo.Func(CallbackInfo.Obj, Data, UserCount)
    end, TargetId)
  elseif "Char" == TypeName then
    self:CallServer("GetCharModRankData", function(ErrCode, Data, UserCount)
      self.logger.info("GetCharModRankData", ErrCode, CommonUtils.TableToString(Data), UserCount)
      CallbackInfo.Func(CallbackInfo.Obj, Data, UserCount)
    end, TargetId)
  end
end

function Component:TakeOffAllCharMod(InCallbackInfo, CharUuid, ModSuitIndex)
  assert(self.Chars[CharUuid])
  
  local function Callback(Ret)
    self.logger.debug("TakeOffAllCharMod ServerCallClient", Ret)
    if not InCallbackInfo then
      return
    end
    InCallbackInfo.Func(InCallbackInfo.Obj, Ret, CharUuid, ModSuitIndex)
  end
  
  self:CallServer("TakeOffAllCharMod", Callback, CharUuid, ModSuitIndex)
end

function Component:CheckAlternativeChar(InCallback)
  local function callback(ret)
    self.logger.debug("CheckAlternativeChar Callback", ret)
    
    InCallback(ret)
  end
  
  self:CallServer("CheckAlternativeChar", callback)
end

function Component:_CopyCharacterAttributeSwitchMap(SourceMap)
  local TargetMap = {}
  for CharGroupId, CharId in pairs(SourceMap or {}) do
    TargetMap[CharGroupId] = CharId
  end
  return TargetMap
end

function Component:_BuildCharacterAttributeSwitchInfos(OldMap)
  local Infos = {}
  local CurrentMap = self.CharacterAttributeSwitch or {}
  local HandledGroups = {}
  for CharGroupId, OldCharId in pairs(OldMap or {}) do
    local NewCharId = CurrentMap[CharGroupId]
    if OldCharId ~= NewCharId then
      local OldCfg = OldCharId and DataMgr.CharacterAttributeSwitch[OldCharId] or nil
      local NewCfg = NewCharId and DataMgr.CharacterAttributeSwitch[NewCharId] or nil
      table.insert(Infos, {
        CharGroupId = CharGroupId,
        OldCharId = OldCharId,
        NewCharId = NewCharId,
        OldCharAttribute = OldCfg and OldCfg.CharAttribute or nil,
        NewCharAttribute = NewCfg and NewCfg.CharAttribute or nil,
        CurrentMapping = CurrentMap
      })
      HandledGroups[CharGroupId] = true
    end
  end
  for CharGroupId, NewCharId in pairs(CurrentMap) do
    if not HandledGroups[CharGroupId] and (OldMap or {})[CharGroupId] ~= NewCharId then
      local OldCharId = (OldMap or {})[CharGroupId]
      local OldCfg = OldCharId and DataMgr.CharacterAttributeSwitch[OldCharId] or nil
      local NewCfg = NewCharId and DataMgr.CharacterAttributeSwitch[NewCharId] or nil
      table.insert(Infos, {
        CharGroupId = CharGroupId,
        OldCharId = OldCharId,
        NewCharId = NewCharId,
        OldCharAttribute = OldCfg and OldCfg.CharAttribute or nil,
        NewCharAttribute = NewCfg and NewCfg.CharAttribute or nil,
        CurrentMapping = CurrentMap
      })
    end
  end
  return Infos
end

function Component:_DispatchCharacterAttributeSwitchEvents(OldMap)
  local SwitchInfos = self:_BuildCharacterAttributeSwitchInfos(OldMap)
  for _, SwitchInfo in ipairs(SwitchInfos) do
    self.logger.info(string.format("OnCharacterAttributeSwitched CharGroupId(%s) OldCharId(%s) NewCharId(%s)", tostring(SwitchInfo.CharGroupId), tostring(SwitchInfo.OldCharId), tostring(SwitchInfo.NewCharId)))
    EventManager:FireEvent(EventID.OnCharacterAttributeSwitched, SwitchInfo)
  end
end

function Component:SwitchCharacterAttribute(NewCharId)
  local OldCharId = AvatarUtils:GetCurrentCharIdByCharId(self, NewCharId)
  
  local function callback(ret)
    self:OnSwitchCharacterAttribute(ret, NewCharId, OldCharId)
  end
  
  self:CallServer("SwitchCharacterAttribute", callback, NewCharId)
end

function Component:OnSwitchCharacterAttribute(ret, NewCharId, OldCharId)
  self.logger.debug("SwitchCharacterAttribute ret:" .. ret)
  for CharGroupId, CharId in pairs(self.CharacterAttributeSwitch or {}) do
    self.logger.info(string.format("SwitchCharacterAttribute CharGroupId(%s) CharId(%s)", tostring(CharGroupId), tostring(CharId)))
  end
  if ret ~= ErrorCode.RET_SUCCESS then
    self.logger.info("SwitchCharacterAttribute failed", ret)
  end
  EventManager:FireEvent(EventID.OnCharAttributeSwitched, ret, NewCharId, OldCharId)
end

function Component:_OnPropChangeCharacterAttributeSwitch(Keys)
  local OldMap = self._CharacterAttributeSwitchMapCache
  if not OldMap then
    self._CharacterAttributeSwitchMapCache = self:_CopyCharacterAttributeSwitchMap(self.CharacterAttributeSwitch)
    return
  end
  self:_DispatchCharacterAttributeSwitchEvents(OldMap)
  self._CharacterAttributeSwitchMapCache = self:_CopyCharacterAttributeSwitchMap(self.CharacterAttributeSwitch)
end

return Component
