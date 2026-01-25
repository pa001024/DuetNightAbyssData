local ReddotTreeNode = Class()

function ReddotTreeNode.New(Class)
  local NewObj = {}
  NewObj = setmetatable(NewObj, Class)
  NewObj:Init()
  return NewObj
end

function ReddotTreeNode:Init()
  self.Name = nil
  self.Count = 0
  self.Parents = {}
  self.Children = {}
  self.OnCountChange = {}
  self.LeafChildrens = {}
  self.CacheType = nil
  self.ReddotType = nil
  self.Conf = nil
  self.Cache = nil
  self.bInvokeEveryTime = false
end

function ReddotTreeNode:AddChild(Name, Node, IsLeaf, RdType, CacheType, Cache, NodeModuleName)
  if self.Children[Name] then
    return self.Children[Name]
  end
  if self.Name ~= "Root" and Node then
    self.Children[Name] = Node
    Node.Parents[self.Name] = self
    if Node.Parents.Root and self.Name ~= "Root" then
      Node.Parents.Root.Children[Name] = nil
      Node.Parents.Root = nil
    end
    if IsLeaf then
      self:AddLeafChild(Node)
    elseif self.Name ~= "Root" then
      for Name, LeafChild in pairs(Node.LeafChildrens) do
        self:AddLeafChild(LeafChild)
      end
    end
    Node:UpdateRdType()
    return Node
  end
  local Conf = DataMgr.ReddotNode[Name]
  if nil == Node then
    local ReddotTreeNodeClass
    if not NodeModuleName and Conf then
      NodeModuleName = Conf.NodeModuleName
      self.NodeModuleName = NodeModuleName
    end
    if NodeModuleName then
      ReddotTreeNodeClass = require("BluePrints.UI.Reddot.Child." .. NodeModuleName)
    end
    if ReddotTreeNodeClass then
      Node = ReddotTreeNodeClass:New()
    else
      Node = ReddotTreeNode:New()
    end
  end
  Node.Name = Name
  Node.Conf = Conf
  if Conf then
    Node.bInvokeEveryTime = Conf.bInvokeEveryTime
  end
  self.Children[Name] = Node
  Node.Parents[self.Name] = self
  if Node.Parents.Root and self.Name ~= "Root" then
    Node.Parents.Root.Children[Name] = nil
    Node.Parents.Root = nil
  end
  if IsLeaf then
    if CacheType then
      Node.CacheType = CacheType
      Node.ReddotType = RdType or EReddotType.New
    end
    if Node.Conf then
      Node.CacheType = Node.Conf.CacheType or Const.ReddotCacheType.NoneCache
      Node.ReddotType = Node.Conf.Type or RdType
    end
  else
    Node.CacheType = Const.ReddotCacheType.NoneCache
  end
  if not Node.Cache and IsLeaf then
    local NodeCache = Cache and Cache[Name] or {
      Count = 0,
      Detail = {}
    }
    local Avatar = GWorld:GetAvatar()
    if Node.Conf and Node.Conf.RuleId and Avatar and not Avatar:CheckUIUnlocked(Node.Conf.RuleId) then
      NodeCache = {
        Count = 0,
        Detail = {}
      }
      Node.Cache = NodeCache
      if not Node.UIUnlockKey then
        Node.UIUnlockKey = Avatar:BindOnUIFirstTimeUnlock(Node.Conf.RuleId, function()
          Avatar.SystemStates[Node.Conf.RuleId] = 1
          Node:InitNodeCache()
          Node:UpdateParentsCount()
          Avatar:UnBindOnUIFirstTimeUnlock(Node.Conf.RuleId, Node.UIUnlockKey)
          Node.UIUnlockKey = nil
        end)
      end
      if Cache then
        Cache[Name] = NodeCache
      end
      self:AddLeafChild(Node)
      Node:UpdateRdType()
      return Node
    end
    Node.Cache = NodeCache
    Node:InitNodeCache()
    if Cache then
      Cache[Name] = NodeCache
    end
  end
  if IsLeaf then
    self:AddLeafChild(Node)
  elseif self.Name ~= "Root" then
    for Name, LeafChild in pairs(Node.LeafChildrens) do
      self:AddLeafChild(LeafChild)
    end
  end
  Node:UpdateRdType()
  return Node
end

function ReddotTreeNode:InitNodeCache()
  self:OnInitNodeCache(self.Cache)
  if self.Cache.Count > 0 then
    self:IncreaseCount(self.Cache.Count)
  else
    self.Cache.Count = 0
    self.Count = 0
  end
end

function ReddotTreeNode:UpdateRdType()
  if self.Name ~= "Root" and 0 ~= self.Count and not IsEmptyTable(self.LeafChildrens) then
    local bFoundOneCount = false
    local bFoundOneNormal = false
    local bFoundOneNew = false
    local bFoundOneGray = false
    for Name, Node in pairs(self.LeafChildrens) do
      if 0 == Node.Count then
      else
        if Node.ReddotType == EReddotType.Num then
          bFoundOneCount = true
        end
        if Node.ReddotType == EReddotType.Normal then
          bFoundOneNormal = true
        end
        if Node.ReddotType == EReddotType.New then
          bFoundOneNew = true
        end
        if Node.ReddotType == EReddotType.Gray then
          bFoundOneGray = true
        end
      end
    end
    local LastRdType = self.ReddotType
    if bFoundOneCount then
      self.ReddotType = EReddotType.Num
    elseif bFoundOneNormal then
      self.ReddotType = EReddotType.Normal
    elseif bFoundOneNew then
      self.ReddotType = EReddotType.New
    elseif bFoundOneGray then
      self.ReddotType = EReddotType.Gray
    end
    self:OverrideSelfRdType()
    if LastRdType and LastRdType ~= self.ReddotType then
      ReddotManager.TryInvokeEvent(self, self.Count, true)
    end
    DebugPrint(DebugTag, "ReddotTreeNode:SetUpRdType  更新红点类型", self.Name, self.ReddotType)
  end
  for Name, Parent in pairs(self.Parents) do
    if Parent and "Root" ~= Name then
      Parent:UpdateRdType()
    end
  end
end

function ReddotTreeNode:GetChild(Name)
  local Node = self.Children[Name]
  return Node
end

function ReddotTreeNode:IsLeaf()
  return not next(self.Children)
end

function ReddotTreeNode:AddLeafChild(Node)
  if IsEmptyTable(Node.Children) then
    assert(true, "[laixiaoyang]ReddotTreeNode:AddLeafChild: 只能添加叶子节点，错误的节点名" .. Node.Name)
  end
  if not self.LeafChildrens[Node.Name] then
    self.LeafChildrens[Node.Name] = Node
    self.Count = self.Count + Node.Count
  end
  if IsEmptyTable(self.Parents) then
    return
  end
  for Name, Parent in pairs(self.Parents) do
    if Parent and "Root" ~= Name then
      Parent:AddLeafChild(Node)
    end
  end
end

function ReddotTreeNode:Dispose()
  if not self.Name then
    return
  end
  for _, Node in pairs(self.Children) do
    if Node then
      Node:Dispose()
    end
  end
  if self.UIUnlockKey then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      Avatar:UnBindOnUIFirstTimeUnlock(self.Conf.RuleId, self.UIUnlockKey)
    end
    self.UIUnlockKey = nil
  end
  self:OnDisposeNode()
  self.OnCountChange = {}
  self.Parents = {}
  self.Children = {}
  self.LeafChildrens = {}
  self.Count = 0
end

function ReddotTreeNode:AddOnCountChangeCb(Obj, Callback)
  Obj.ReddotNodeIns = self
  self.OnCountChange[Obj] = Callback
  if not IsEmptyTable(self.Children) then
    self:UpdateRdType()
  end
  self:TryFireOnCountChange(self.Count, true)
end

function ReddotTreeNode:HadAddChangeCb(Obj)
  return self.OnCountChange[Obj] ~= nil
end

function ReddotTreeNode:RemoveOnCountChangeCb(Obj)
  Obj.ReddotNodeIns = nil
  self.OnCountChange[Obj] = nil
end

function ReddotTreeNode:CleanOnCountChangeCb()
  for Obj, Func in pairs(self.OnCountChange) do
    Obj.ReddotNodeIns = nil
  end
  self.OnCountChange = {}
end

function ReddotTreeNode:TryFireOnCountChange(OldCount, Force)
  if OldCount == self.Count and not Force then
    return
  end
  for Obj, Callback in pairs(self.OnCountChange) do
    if Callback and Obj and (not Obj.Object or Obj.Object and IsValid(Obj)) then
      Callback(Obj, self.Count, self.ReddotType, self.Name)
    elseif Obj.Object and IsValid(Obj) == false then
      DebugPrint(ErrorTag, "[laixiaoyang]ReddotTreeNode:TryFireOnCountChange,NodeName: " .. self.Name, " Delegate Obj Is Invalid!!!! You must call ReddotManager.RemoveListener before Your Obj Destruct!!!!!!")
      Obj.ReddotNodeIns = nil
      self.OnCountChange[Obj] = nil
    end
  end
  return
end

function ReddotTreeNode:IncreaseCount(AddValue, CacheDetailChangedParams)
  if self.UIUnlockKey then
    DebugPrint("[laixiaoyang][ReddotTree][IncreaseCount]节点" .. self.Name .. "还没有解锁")
    return false
  end
  if self.Count < 0 then
    DebugPrint(Traceback(ErrorTag, "[laixiaoyang][ReddotTree][IncreaseCount]节点" .. self.Name .. "的计数值不能小于0", false))
    return false
  end
  if not IsEmptyTable(self.Children) then
    DebugPrint(Traceback(ErrorTag, "[laixiaoyang][ReddotTree][IncreaseCount]节点" .. self.Name .. "非叶子节点，不能主动增加计数", false))
    return false
  end
  if nil == AddValue then
    AddValue = 1
  end
  if not self:OnIncreaseJudge(AddValue, CacheDetailChangedParams) then
    DebugPrint(WarningTag, "ReddotTreeNode:IncreaseCount 不符合红点计数增加的条件", self.Name)
    return false
  end
  local OldCount = self.Count
  self.Count = self.Count + AddValue
  if self.CacheType ~= Const.ReddotCacheType.NoneCache then
    self:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
  end
  if self.Cache then
    self.Cache.Count = self.Count
  end
  if self.ReddotType ~= EReddotType.Num and not self.bInvokeEveryTime then
    if 0 == OldCount and 0 ~= self.Count or 0 ~= OldCount and 0 == self.Count then
      self:UpdateParentsCount()
      ReddotManager.TryInvokeEvent(self, OldCount)
    end
  else
    self:UpdateParentsCount()
    ReddotManager.TryInvokeEvent(self, OldCount)
  end
  return true
end

function ReddotTreeNode:OnIncreaseCount(AddValue, CacheDetailChangedParams, OldCount)
end

function ReddotTreeNode:OverrideSelfRdType()
end

function ReddotTreeNode:OnInitNodeCache(NodeCache)
end

function ReddotTreeNode:OnDisposeNode()
end

function ReddotTreeNode:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
end

function ReddotTreeNode:OnIncreaseJudge(AddValue, CacheDetailChangedParams)
  return true
end

function ReddotTreeNode:OnDecreaseJudge(SubValue, CacheDetailChangedParams)
  return true
end

function ReddotTreeNode:DecreaseCount(SubValue, CacheDetailChangedParams)
  if self.UIUnlockKey then
    DebugPrint("[laixiaoyang][ReddotTree][IncreaseCount]节点" .. self.Name .. "还没有解锁")
    return false
  end
  if self.Count <= 0 then
    DebugPrint(DebugTag, "[laixiaoyang][ReddotTree][DecreaseCount]节点" .. self.Name .. "的计数值为0", false)
    return false
  end
  if not IsEmptyTable(self.Children) then
    DebugPrint(Traceback(ErrorTag, "[laixiaoyang][ReddotTree][DecreaseCount]节点" .. self.Name .. "非叶子节点，不能主动减少计数", false))
    return false
  end
  if nil == SubValue then
    SubValue = 1
  end
  if not self:OnDecreaseJudge(SubValue, CacheDetailChangedParams) then
    DebugPrint(DebugTag, "ReddotTreeNode:DecreaseCount 不符合红点计数减少的条件", self.Name)
    return false
  end
  local OldCount = self.Count
  self.Count = self.Count - SubValue
  if self.CacheType ~= Const.ReddotCacheType.NoneCache then
    self:OnDecreaseCount(SubValue, CacheDetailChangedParams, OldCount)
  end
  if self.Cache then
    self.Cache.Count = self.Count
  end
  if self.ReddotType ~= EReddotType.Num and not self.bInvokeEveryTime then
    if 0 == OldCount and 0 ~= self.Count or 0 ~= OldCount and 0 == self.Count then
      self:UpdateParentsCount()
      ReddotManager.TryInvokeEvent(self, OldCount)
    end
  else
    self:UpdateParentsCount()
    ReddotManager.TryInvokeEvent(self, OldCount)
  end
  return true
end

function ReddotTreeNode:GetNodeCount()
  if not next(self.LeafChildrens) then
    return self.Count
  end
  local TempCount = 0
  for _, Child in pairs(self.LeafChildrens) do
    if not Child then
    else
      TempCount = TempCount + Child.Count
    end
  end
  if TempCount ~= self.Count then
    local OldCount = self.Count
    self.Count = TempCount
    if self.ReddotType ~= EReddotType.Num and not self.bInvokeEveryTime then
      if 0 == OldCount and 0 ~= self.Count or 0 ~= OldCount and 0 == self.Count then
        self:UpdateRdType()
        ReddotManager.TryInvokeEvent(self, OldCount)
      end
    else
      self:UpdateRdType()
      ReddotManager.TryInvokeEvent(self, OldCount)
    end
  end
  return self.Count
end

function ReddotTreeNode:UpdateParentsCount()
  if IsEmptyTable(self.Parents) then
    return
  end
  for Name, Parent in pairs(self.Parents) do
    if "Root" == Name then
    elseif Parent then
      Parent:GetNodeCount()
      Parent:UpdateParentsCount()
    end
  end
end

return ReddotTreeNode
