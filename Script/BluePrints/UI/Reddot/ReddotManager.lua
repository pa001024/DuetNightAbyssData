local ReddotTreeNode = require("BluePrints.UI.Reddot.ReddotTreeNode")
local EMCache = require("EMCache.EMCache")
local CommonUtils = require("Utils.CommonUtils")
local StlLib = require("BluePrints.Common.DataStructure")
local Deque = StlLib.Deque
local ReddotManager = {}
ReddotManager.CacheKey = "ReddotCache"

function ReddotManager._Init()
  if ReddotManager.Root then
    return
  end
  DebugPrint("ReddotManager.Init")
  ReddotManager.Root = ReddotTreeNode:New()
  ReddotManager.Root.Name = "Root"
  ReddotManager.CommonCache = nil
  ReddotManager.UserCache = nil
  ReddotManager.CurrentUserId = nil
  ReddotManager.LeafNodes = {}
  ReddotManager.NonLeafNodes = {}
  ReddotManager._EventTickQueue = Deque.New()
  ReddotManager._EventTicker = nil
end

function ReddotManager.TryInvokeEvent(Node, Count, bForce)
  if table.isempty(Node.OnCountChange) then
    return
  end
  local bEmpty = ReddotManager._EventTickQueue:IsEmpty()
  ReddotManager._EventTickQueue:PushFront({
    _Node = Node,
    _Count = Count,
    _bForce = bForce
  })
  if GWorld.GameInstance:IsExistTimer(ReddotManager._EventTicker) then
    if bEmpty and not ReddotManager._EventTickQueue:IsEmpty() then
      GWorld.GameInstance:UnPauseTimer(ReddotManager._EventTicker)
    end
    return
  end
  local _, TickerKey = GWorld.GameInstance:AddTimer(0.01, function()
    local Params = ReddotManager._EventTickQueue:PopBack()
    if Params and Params._Node and Params._Count then
      Params._Node:TryFireOnCountChange(Params._Count, Params._bForce)
    end
    if ReddotManager._EventTickQueue:IsEmpty() then
      GWorld.GameInstance:PauseTimer(ReddotManager._EventTicker)
      return
    end
  end, true, 0, nil, true)
  ReddotManager._EventTicker = TickerKey
end

function ReddotManager.Test()
  local AAA = ReddotManager.AddNode("AAA", nil, 0)
  ReddotManager.IncreaseLeafNodeCount("AAA")
  local BBB = ReddotManager.AddNode("BBB", nil, 0)
  ReddotManager.IncreaseLeafNodeCount("BBB")
  local CCC = ReddotManager.AddNode("CCC", {AAA = 0, BBB = 0}, 0)
  local DDD = ReddotManager.AddNode("DDD", nil, 0)
  ReddotManager.IncreaseLeafNodeCount("DDD")
  local EEE = ReddotManager.AddNode("EEE", {CCC = 0, DDD = 0}, 0)
  ReddotManager.AddNode("EEE", {CCC = 0, DDD = 0}, 0)
  assert(EEE.Count == CCC.Count + DDD.Count, "Test Fail!!!!")
end

function ReddotManager._Close()
  DebugPrint("ReddotManager.Close")
  if ReddotManager.Root then
    ReddotManager.Root:Dispose()
  end
  ReddotManager.LeafNodes = {}
  ReddotManager.NonLeafNodes = {}
  if ReddotManager.CommonCache then
    EMCache:Set(ReddotManager.CacheKey, ReddotManager.CommonCache, false)
    ReddotManager.CommonCache = nil
  end
  if ReddotManager.UserCache then
    EMCache:Set(ReddotManager.CacheKey, ReddotManager.UserCache, true)
    ReddotManager.UserCache = nil
  end
  ReddotManager.CurrentUserId = nil
  if GWorld.GameInstance:IsExistTimer(ReddotManager._EventTicker) then
    GWorld.GameInstance:RemoveTimer(ReddotManager._EventTicker)
    ReddotManager._EventTicker = nil
  end
  if ReddotManager._EventTickQueue then
    ReddotManager._EventTickQueue:Init()
  end
end

function ReddotManager._GetCache(CacheType)
  if CacheType == Const.ReddotCacheType.UserCache then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      GWorld.logger.error("ReddotManager._GetCache  禁止在Avatar不存在的情况下访问用户缓存")
      Traceback(ErrorTag)
      return
    end
    local UserId = Avatar.Account
    local HostNum = Avatar.Hostnum
    if UserId ~= ReddotManager.CurrentUserId or ReddotManager.CurrentHost ~= HostNum then
      ReddotManager.UserCache = nil
      ReddotManager.CurrentUserId = UserId
      ReddotManager.CurrentHost = HostNum
    end
    if not ReddotManager.UserCache then
      ReddotManager.UserCache = EMCache:Get(ReddotManager.CacheKey, true) or {}
      EMCache:Set(ReddotManager.CacheKey, ReddotManager.UserCache, true)
    end
    return ReddotManager.UserCache
  elseif CacheType == Const.ReddotCacheType.CommonCache then
    if not ReddotManager.CommonCache then
      ReddotManager.CommonCache = EMCache:Get(ReddotManager.CacheKey, false) or {}
      EMCache:Set(ReddotManager.CacheKey, ReddotManager.CommonCache, false)
    end
    return ReddotManager.CommonCache
  elseif CacheType == Const.ReddotCacheType.NoneCache then
    return nil
  end
end

function ReddotManager.GetTreeNode(NodeName)
  local CacheNode = ReddotManager.LeafNodes[NodeName] or ReddotManager.NonLeafNodes[NodeName]
  if CacheNode then
    return CacheNode
  end
  return nil
end

function ReddotManager._MakeChildNodesData(ChildNodes, ChildName, Node)
  local ChildNodeConf = DataMgr.ReddotNode[ChildName]
  ChildNodes[ChildName] = {}
  if ChildNodeConf then
    if ChildNodeConf.IsLeaf then
      ChildNodes[ChildName].CacheType = ChildNodeConf.CacheType or Const.ReddotCacheType.NoneCache
      ChildNodes[ChildName].ReddotType = ChildNodeConf.Type or EReddotType.Normal
    else
      ChildNodes[ChildName].CacheType = Const.ReddotCacheType.NoneCache
    end
    ChildNodes[ChildName].NodeModuleName = ChildNodeConf.NodeModuleName
  end
  if Node then
    ChildNodes[ChildName].CacheType = Node.CacheType
    ChildNodes[ChildName].ReddotType = Node.ReddotType
  end
end

function ReddotManager._AddNode(NodeName, ChildNodes, ParentNode, CacheType, RdType, NodeModuleName)
  ChildNodes = ChildNodes or {}
  local IsLeaf = false
  local NodeConf = DataMgr.ReddotNode[NodeName]
  if NodeConf then
    IsLeaf = NodeConf.IsLeaf
    if NodeConf.IsLeaf then
      CacheType = NodeConf.CacheType or Const.ReddotCacheType.NoneCache
    else
      CacheType = Const.ReddotCacheType.NoneCache
    end
    if next(ChildNodes) == nil then
      for _, Child in ipairs(NodeConf.Childs or {}) do
        ReddotManager._MakeChildNodesData(ChildNodes, Child)
      end
    end
  else
    IsLeaf = next(ChildNodes) == nil
    if nil == CacheType and next(ChildNodes) == nil then
      CacheType = Const.ReddotCacheType.NoneCache
    end
  end
  if IsLeaf and next(ChildNodes) then
    GWorld.logger.error("ReddotManager._AddNode 该节点为叶子节点不能拥有子节点！！！" .. NodeName)
    Traceback(ErrorTag)
    return
  end
  local TempNode = ReddotManager.GetTreeNode(NodeName)
  if TempNode then
    IsLeaf = IsEmptyTable(TempNode.Children)
  end
  local Cache
  if IsLeaf then
    Cache = IsLeaf and ReddotManager._GetCache(CacheType)
  end
  TempNode = ParentNode:AddChild(NodeName, TempNode, IsLeaf, RdType, CacheType, Cache, NodeModuleName)
  if ReddotManager.LeafNodes[NodeName] then
    return TempNode
  end
  if IsLeaf then
    ReddotManager.LeafNodes[NodeName] = TempNode
  elseif not IsLeaf then
    for ChildNodeName, Value in pairs(ChildNodes) do
      local _CacheType = Value.CacheType
      local _RdType = Value.ReddotType
      local _NodeModuleName = Value.NodeModuleName
      local NodeIns = ReddotManager.GetTreeNode(ChildNodeName)
      local ChildNodeConf = DataMgr.ReddotNode[ChildNodeName]
      if ChildNodeConf then
        if ChildNodeConf.IsLeaf then
          _CacheType = ChildNodeConf.CacheType or Const.ReddotCacheType.NoneCache
          _RdType = ChildNodeConf.Type or EReddotType.Normal
        else
          _CacheType = Const.ReddotCacheType.NoneCache
        end
        _NodeModuleName = ChildNodeConf.NodeModuleName
      end
      if NodeIns then
        _CacheType = NodeIns.CacheType
        _RdType = NodeIns.ReddotType
        _NodeModuleName = NodeIns.NodeModuleName
      end
      if NodeIns or ChildNodeConf then
        local SubChildNodes = {}
        local NonLeafNodeIns = ReddotManager.NonLeafNodes[ChildNodeName]
        if NonLeafNodeIns then
          for NodeName, Node in pairs(NonLeafNodeIns.Children) do
            ReddotManager._MakeChildNodesData(SubChildNodes, NodeName, Node)
          end
        end
        ReddotManager._AddNode(ChildNodeName, SubChildNodes, TempNode, _CacheType, _RdType, _NodeModuleName)
      else
        GWorld.logger.error("ReddotManager._AddNode 节点 " .. ChildNodeName .. " 尚未创建，检查业务层是否有时序问题，动态创建的节点需要子节点优先")
        Traceback(ErrorTag)
        return
      end
    end
    TempNode:GetNodeCount()
    ReddotManager.NonLeafNodes[NodeName] = TempNode
  end
  return TempNode
end

function ReddotManager.AddNode(NodeName, ChildNodeCacheTypes, CacheType, RdType, NodeModuleName)
  if true == CacheType then
    CacheType = Const.ReddotCacheType.UserCache
  end
  if false == CacheType then
    CacheType = Const.ReddotCacheType.CommonCache
  end
  if nil == CacheType then
    CacheType = Const.ReddotCacheType.NoneCache
  end
  local ChildNodes = {}
  for Name, Val in pairs(ChildNodeCacheTypes or {}) do
    if true == Val then
      Val = Const.ReddotCacheType.UserCache
    end
    if false == Val then
      Val = Const.ReddotCacheType.CommonCache
    end
    if nil == Val then
      Val = Const.ReddotCacheType.NoneCache
    end
    ChildNodes[Name] = {
      CacheType = Val,
      ReddotType = EReddotType.Normal
    }
  end
  return ReddotManager._AddNode(NodeName, ChildNodes, ReddotManager.Root, CacheType, RdType, NodeModuleName)
end

function ReddotManager.AddNodeEx(NodeName, ChildNodes, CacheType, RdType, NodeModuleName)
  return ReddotManager._AddNode(NodeName, ChildNodes, ReddotManager.Root, CacheType, RdType, NodeModuleName)
end

function ReddotManager.AddListenerEx(NodeName, Obj, CallBack, ChildNodes, CacheType, RdType, NodeModuleName)
  if ChildNodes and ChildNodes[NodeName] then
    GWorld.logger.error("ReddotManager.AddListener: ChildNodes里不能包含" .. NodeName)
    Traceback(ErrorTag)
    return
  end
  local TempNode = ReddotManager.GetTreeNode(NodeName)
  TempNode = TempNode or ReddotManager.AddNodeEx(NodeName, ChildNodes, CacheType, RdType, NodeModuleName)
  if not TempNode then
    GWorld.logger.error("ReddotManager.AddListener: 该节点尚未创建，检查业务层是否有时序问题 " .. NodeName)
    Traceback(ErrorTag)
    return
  end
  TempNode:AddOnCountChangeCb(Obj, CallBack)
end

function ReddotManager.AddListener(NodeName, Obj, CallBack, ChildNodeCacheTypes, CacheType, RdType)
  if ChildNodeCacheTypes and ChildNodeCacheTypes[NodeName] then
    GWorld.logger.error("ReddotManager.AddListener: ChildNodes里不能包含" .. NodeName)
    Traceback(ErrorTag)
    return
  end
  local TempNode = ReddotManager.GetTreeNode(NodeName)
  TempNode = TempNode or ReddotManager.AddNode(NodeName, ChildNodeCacheTypes, CacheType, RdType)
  if not TempNode then
    GWorld.logger.error("ReddotManager.AddListener: 该节点尚未创建，检查业务层是否有时序问题 " .. NodeName)
    Traceback(ErrorTag)
    return
  end
  TempNode:AddOnCountChangeCb(Obj, CallBack)
end

function ReddotManager.RemoveListener(NodeName, Obj)
  local TempNode = ReddotManager.GetTreeNode(NodeName)
  if not TempNode then
    return
  end
  TempNode:RemoveOnCountChangeCb(Obj)
end

function ReddotManager.RemoveAllListener(NodeName)
  local TempNode = ReddotManager.GetTreeNode(NodeName)
  if not TempNode then
    return
  end
  TempNode:CleanOnCountChangeCb()
end

function ReddotManager.ClearLeafNodeCount(NodeName, bClearCacheDetail, CacheDetailChangedParams)
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    GWorld.logger.error("ReddotManager.ClearLeafNodeCount: 该节点尚未创建，检查业务层是否有时序问题 " .. NodeName)
    Traceback(ErrorTag)
    return
  end
  if LeafNode.Count > 0 and LeafNode:DecreaseCount(LeafNode.Count, CacheDetailChangedParams) then
    local NodeCache = ReddotManager._GetLeafNodeCache(NodeName)
    NodeCache.Count = 0
    if bClearCacheDetail then
      NodeCache.Detail = {}
    end
  end
end

function ReddotManager.IncreaseLeafNodeCount(NodeName, AddValue, CacheDetailChangedParams)
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    GWorld.logger.error("ReddotManager.IncreaseLeafNodeCount: 该节点尚未创建，检查业务层是否有时序问题 " .. NodeName)
    Traceback(ErrorTag)
    return
  end
  if nil == AddValue then
    AddValue = 1
  end
  return LeafNode:IncreaseCount(AddValue, CacheDetailChangedParams)
end

function ReddotManager.DecreaseLeafNodeCount(NodeName, SubValue, CacheDetailChangedParams)
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    GWorld.logger.error("ReddotManager.DecreaseLeafNodeCount: 该节点尚未创建，检查业务层是否有时序问题 " .. NodeName)
    Traceback(ErrorTag)
    return
  end
  if nil == SubValue then
    SubValue = 1
  end
  return LeafNode:DecreaseCount(SubValue, CacheDetailChangedParams)
end

function ReddotManager.GetLeafNodeCacheDetail(NodeName)
  local Cache = ReddotManager._GetLeafNodeCache(NodeName)
  if Cache then
    return Cache.Detail
  end
end

function ReddotManager._GetLeafNodeCache(NodeName)
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    DebugPrint(WarningTag, "红点对象不存在，拿不到缓存数据", NodeName)
    return {Detail = nil}
  end
  if LeafNode.CacheType == Const.ReddotCacheType.NoneCache then
    if LeafNode.Cache then
      return LeafNode.Cache
    else
      return {Detail = nil}
    end
  end
  local CacheType = LeafNode.CacheType
  local Cache = ReddotManager._GetCache(CacheType)
  if Cache then
    return Cache[NodeName] or {Detail = nil}
  else
    return {Detail = nil}
  end
end

function ReddotManager.PrintNodeTree(NodeName)
  DebugPrint("--------- ReddotManager.PrintNodeTree: " .. NodeName)
  
  local function PrintNode(node, indent, isLast)
    if not node then
      return
    end
    local prefix = string.rep("│   ", indent - 1)
    if indent > 0 then
      prefix = prefix .. (isLast and "└── " or "├── ")
    end
    print(prefix .. node.Name .. " (Count: " .. (node.Count or 0) .. ")")
    local children = node.Children or {}
    local childCount = 0
    for _ in pairs(children) do
      childCount = childCount + 1
    end
    local i = 0
    for _, child in pairs(children) do
      i = i + 1
      PrintNode(child, indent + 1, i == childCount)
    end
  end
  
  local RootNode = ReddotManager.GetTreeNode(NodeName)
  if not RootNode then
    print("Node not found: " .. NodeName)
    return
  end
  PrintNode(RootNode, 0, true)
end

return ReddotManager
