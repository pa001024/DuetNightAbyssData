local Component = {}

local function GetOrAddTreeNode(NodeName)
  local Node = ReddotManager.GetTreeNode(NodeName)
  if not Node then
    ReddotManager.AddNode(NodeName)
  end
  return Node
end

function Component:AddCharAppearanceRedDotListen(Callback, CharId, NeedRemoveOldListener)
  if self.IsPreviewMode or self.NoReddot then
    return
  end
  if NeedRemoveOldListener then
    self:RemoveCharAppearanceRedDotListen()
  end
  local NodeName = "CharAppearance" .. CharId
  if not self.CharAppearanceNodeNames then
    self.CharAppearanceNodeNames = {}
  end
  local Avatar = GWorld:GetAvatar()
  local CommonChar = Avatar and Avatar.CommonChars[CharId]
  if not CommonChar then
    return
  end
  local LeafNodes = {}
  for _, Type in pairs(CommonConst.CharAccessoryTypes) do
    if Type ~= CommonConst.CharAccessoryTypes.MVP then
      local LeafNodeName = CommonConst.DataType.CharAccessory .. Type
      LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
      for key, Skin in pairs(CommonChar.OwnedSkins) do
        LeafNodeName = LeafNodeName .. Skin.SkinId
        LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
      end
    end
  end
  if not self.CharAppearanceNodeNames[NodeName] and not IsEmptyTable(LeafNodes) then
    ReddotManager.AddListener(NodeName, self, Callback, LeafNodes)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
  NodeName = CommonConst.DataType.CharAccessory .. CommonConst.CharAccessoryTypes.MVP
  if GetOrAddTreeNode(NodeName) then
    ReddotManager.AddListener(NodeName, self, Callback, nil, true)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
  NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. CharId
  if GetOrAddTreeNode(NodeName) then
    ReddotManager.AddListener(NodeName, self, Callback, nil, true)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
  NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. "LevelUp" .. CharId
  if GetOrAddTreeNode(NodeName) then
    ReddotManager.AddListener(NodeName, self, Callback, nil, true)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
  NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair .. CharId
  if GetOrAddTreeNode(NodeName) then
    ReddotManager.AddListener(NodeName, self, Callback, nil, true)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
  NodeName = CommonConst.DataType.Char .. CommonConst.DataType.Hair
  if GetOrAddTreeNode(NodeName) then
    ReddotManager.AddListener(NodeName, self, Callback, nil, true)
    self.CharAppearanceNodeNames[NodeName] = 1
  end
end

function Component:RemoveCharAppearanceRedDotListen()
  if self.IsPreviewMode or self.NoReddot then
    return
  end
  self:_RemoveRedDotListenerCommon("CharAppearance")
end

function Component:_RemoveRedDotListenerCommon(Tag)
  if not self[Tag .. "NodeNames"] then
    return
  end
  for NodeName, _ in pairs(self[Tag .. "NodeNames"] or {}) do
    ReddotManager.RemoveListener(NodeName, self)
  end
  self[Tag .. "NodeNames"] = nil
end

return Component
