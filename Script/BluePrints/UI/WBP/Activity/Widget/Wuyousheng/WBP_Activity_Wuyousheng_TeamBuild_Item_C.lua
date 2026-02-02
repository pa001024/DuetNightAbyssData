require("UnLua")
local ReddotManager = require("BluePrints.UI.Reddot.ReddotManager")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(ItemObject)
  if not ItemObject then
    return
  end
  ItemObject.UI = self
  self.ItemObject = ItemObject
  self.Com_Item:OnListItemObjectSet(ItemObject)
  self.Item_Conflict.Text_Conflict:SetText(GText("UI_Wuyousheng_CharConflict"))
  if ItemObject.IsEmpty then
    self.WS_Item:SetActiveWidgetIndex(1)
  else
    self.WS_Item:SetActiveWidgetIndex(0)
    if ItemObject.Level then
      self.Item_TryOut.Com_Item_Level.Text_Lv:SetText(ItemObject.Level)
    else
      self.Item_TryOut.Com_Item_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if ItemObject.IsTryout and ItemObject.Tag ~= "Pet" then
      self.Item_TryOut.Text_TryOut:SetText(GText("UI_Wuyousheng_ArmoryTrial"))
      self.Item_TryOut.Text_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Item_TryOut.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Item_TryOut.Text_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Item_TryOut.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:UpdateTryoutReddot()
    self:SetConflict(false)
  end
end

function M:SetItemSelect(IsSelected)
  self.bSelectTag = IsSelected
  self.Com_Item.bSelectTag = IsSelected
  self.Com_Item:SetItemSelect(IsSelected)
end

function M:SetConflict()
  if self.ItemObject.IsConflict then
    self.Item_Conflict:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Item_Conflict:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:BP_OnEntryReleased()
  if self.Com_Item and self.Com_Item.BP_OnEntryReleased then
    self.Com_Item:BP_OnEntryReleased()
  end
end

function M:OnItemClick()
  local ItemObject = self.ItemObject
  if ItemObject and ItemObject.IsTryout then
    self:MarkTryoutReddotRead()
  end
end

function M:UpdateTryoutReddot()
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  local ItemObject = self.ItemObject
  if not ItemObject or not ItemObject.IsTryout then
    return
  end
  local Type = ItemObject.Type or ItemObject.Tag or ""
  local Id = ItemObject.UnitId or ItemObject.Uuid
  if not Id then
    return
  end
  local CacheKey = Type .. "_" .. tostring(Id)
  local NodeName = "WuyoushengTryoutItem"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNodeEx(NodeName)
  end
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    return
  end
  local Cache
  if LeafNode.CacheType == Const.ReddotCacheType.NoneCache then
    Cache = LeafNode.Cache
  else
    local CacheType = LeafNode.CacheType
    local CacheContainer = ReddotManager._GetCache(CacheType)
    if CacheContainer then
      if not CacheContainer[NodeName] then
        CacheContainer[NodeName] = {
          Count = 0,
          Detail = {}
        }
      end
      Cache = CacheContainer[NodeName]
    end
  end
  if not Cache or not Cache.Detail then
    return
  end
  local CacheDetail = Cache.Detail
  if nil == CacheDetail[CacheKey] or 1 == CacheDetail[CacheKey] then
    DebugPrint("JLy 显示红点")
    CacheDetail[CacheKey] = 0
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    DebugPrint("JLy 隐藏红点")
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:MarkTryoutReddotRead()
  local ItemObject = self.ItemObject
  if not ItemObject or not ItemObject.IsTryout then
    return
  end
  local Type = ItemObject.Type or ItemObject.Tag or ""
  local Id = ItemObject.UnitId or ItemObject.Uuid
  if not Id then
    return
  end
  local CacheKey = Type .. "_" .. tostring(Id)
  local NodeName = "WuyoushengTryoutItem"
  if not ReddotManager.GetTreeNode(NodeName) then
    ReddotManager.AddNodeEx(NodeName)
  end
  local LeafNode = ReddotManager.LeafNodes[NodeName]
  if not LeafNode then
    return
  end
  local Cache
  if LeafNode.CacheType == Const.ReddotCacheType.NoneCache then
    Cache = LeafNode.Cache
  else
    local CacheType = LeafNode.CacheType
    local CacheContainer = ReddotManager._GetCache(CacheType)
    if CacheContainer then
      if not CacheContainer[NodeName] then
        CacheContainer[NodeName] = {
          Count = 0,
          Detail = {}
        }
      end
      Cache = CacheContainer[NodeName]
    end
  end
  if not Cache or not Cache.Detail then
    return
  end
  local CacheDetail = Cache.Detail
  if 1 == CacheDetail[CacheKey] or 0 == CacheDetail[CacheKey] then
    CacheDetail[CacheKey] = 0
    DebugPrint("JLy 隐藏红点")
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
