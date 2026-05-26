local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
M._components = {
  "BluePrints.UI.WBP.Appearance.AppearanceRedDotTreeComponent"
}

function M:Init()
  M.Super.Init(self)
  self:RegisterEvent()
  self:RegisterGroupCharNodeListeners()
  self:UpdateCurrentCharReddotCount()
end

function M:RegisterEvent()
  EventManager:AddEvent(EventID.OnCharAttributeSwitched, self, self.OnCharAttributeSwitched)
  EventManager:AddEvent(EventID.OnNewCharSkinObtained, self, self.OnNewCharSkinObtained)
  EventManager:AddEvent(EventID.OnNewCharHairObtained, self, self.OnNewCharHairObtained)
  EventManager:AddEvent(EventID.OnNewCharObtained, self, self.OnNewCharObtained)
end

function M:UnRegisterEvent()
  EventManager:RemoveEvent(EventID.OnCharAttributeSwitched, self, self.OnCharAttributeSwitched)
  EventManager:RemoveEvent(EventID.OnNewCharSkinObtained, self, self.OnNewCharSkinObtained)
  EventManager:RemoveEvent(EventID.OnNewCharHairObtained, self, self.OnNewCharHairObtained)
  EventManager:RemoveEvent(EventID.OnNewCharObtained, self, self.OnNewCharObtained)
end

function M:RegisterGroupCharNodeListeners()
  for CharId, AttrSwitch in pairs(DataMgr.CharacterAttributeSwitch or {}) do
    if AttrSwitch.CharGroupId then
      self:AddCharAppearanceRedDotListen(self.CharGroupNewAppearanceCountChanged, CharId)
    end
  end
end

function M:UnRegisterGroupCharNodeListeners()
  self:RemoveCharAppearanceRedDotListen()
end

function M:CharGroupNewAppearanceCountChanged(Obj, Count, ReddotType, NodeName)
  self:UpdateCurrentCharReddotCount()
end

function M:OnDisposeNode()
  self:UnRegisterEvent()
  self:UnRegisterGroupCharNodeListeners()
end

function M:OnCharAttributeSwitched()
  self:UpdateCurrentCharReddotCount()
end

function M:OnNewCharSkinObtained(SkinId, CharId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar:GetCharUuidByCharId(CharId) then
    return
  end
  self:OnCharAppearanceChanged(CharId)
end

function M:OnNewCharHairObtained(HairId, CharId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not Avatar:GetCharUuidByCharId(CharId) then
    return
  end
  self:OnCharAppearanceChanged(CharId)
end

function M:OnNewCharObtained(CharUuid)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char = Avatar.Chars[CharUuid]
  local CharId = Char and Char.CharId
  local CharGroupId = DataMgr.CharacterAttributeSwitch[CharId] and DataMgr.CharacterAttributeSwitch[CharId].CharGroupId
  if CharGroupId then
    self:AddCharAppearanceRedDotListen(self.CharGroupNewAppearanceCountChanged, CharId)
  end
end

function M:OnCharAppearanceChanged(CharId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CharGroupId = DataMgr.CharacterAttributeSwitch[CharId] and DataMgr.CharacterAttributeSwitch[CharId].CharGroupId
  if CharGroupId then
    local CurrentCharId = AvatarUtils:GetCurrentCharIdByGroupId(Avatar, CharGroupId)
    if CurrentCharId == CharId then
      self:UpdateCurrentCharReddotCount()
    end
  else
    self:UpdateCurrentCharReddotCount()
  end
end

function M:UpdateCurrentCharReddotCount()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ProcessedGroups = {}
  for CharId, AttrSwitch in pairs(DataMgr.CharacterAttributeSwitch or {}) do
    local CharGroupId = AttrSwitch.CharGroupId
    if CharGroupId and Avatar:GetCharUuidByCharId(CharId) and not ProcessedGroups[CharGroupId] then
      local CurrentCharId = AvatarUtils:GetCurrentCharIdByGroupId(Avatar, CharGroupId)
      local CharGroupNodeName = "CharGroupNewAppearance" .. CharGroupId
      local CharGroupNode = ReddotManager.GetTreeNode(CharGroupNodeName)
      if not CharGroupNode then
        ReddotManager.AddNode(CharGroupNodeName)
        CharGroupNode = ReddotManager.GetTreeNode(CharGroupNodeName)
      end
      if CharGroupNode then
        local OldCount = CharGroupNode.Count
        CharGroupNode.Count = self:GetCharAppearanceReddotCount(CurrentCharId)
        CharGroupNode:UpdateParentsCount()
        ReddotManager.TryInvokeEvent(CharGroupNode, OldCount)
      end
      ProcessedGroups[CharGroupId] = true
    end
  end
end

function M:GetCharAppearanceReddotCount(CharId)
  local Count = 0
  local SkinNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
  local SkinNode = ReddotManager.GetTreeNode(SkinNodeName)
  if SkinNode then
    Count = Count + SkinNode.Count
  end
  local HairNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
  local HairNode = ReddotManager.GetTreeNode(HairNodeName)
  if HairNode then
    Count = Count + HairNode.Count
  end
  return Count
end

function M:ClearNodeCache()
end

AssembleComponents(M)
return M
