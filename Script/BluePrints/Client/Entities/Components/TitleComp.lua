local Component = {}

function Component:EnterWorld()
  self:InitReddots()
end

function Component:LeaveWorld()
  self:ClearEvent()
end

function Component:ChangeTitleBefore(TargetTitleId)
  local function Callback(Ret)
    ScreenPrint(" Ret为" .. Ret .. "服务端更改前缀称号" .. (self.TitleBefore or " 空 ") .. "  变成了  " .. (TargetTitleId or " 空 "))
    
    EventManager:FireEvent(EventID.OnChangeTitle, self.TitleBefore, self.TitleAfter, self.TitleFrame)
  end
  
  self:CallServer("ChangeTitleBefore", Callback, self.TitleBefore, TargetTitleId)
end

function Component:ChangeTitleAfter(TargetTitleId)
  local function Callback(Ret)
    ScreenPrint(" Ret为" .. Ret .. "服务端更改后缀称号" .. (self.TitleAfter or " 空 ") .. "  变成了  " .. (TargetTitleId or " 空 "))
    
    EventManager:FireEvent(EventID.OnChangeTitle, self.TitleBefore, self.TitleAfter, self.TitleFrame)
  end
  
  self:CallServer("ChangeTitleAfter", Callback, self.TitleAfter, TargetTitleId)
end

function Component:ChangeTitleFrame(TitleFrameId)
  local function Callback(Ret)
    ScreenPrint(" Ret为" .. Ret .. "服务端更改称号框 " .. (self.TitleFrame or " 空 ") .. "  变成了  " .. (TitleFrameId or " 空 "))
    
    EventManager:FireEvent(EventID.OnChangeTitle, self.TitleBefore, self.TitleAfter, self.TitleFrame)
  end
  
  self:CallServer("ChangeTitleFrame", Callback, self.TitleFrame, TitleFrameId)
end

function Component:GmGetAllTitle()
  self:CallServerMethod("GmGetAllTitle")
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "sgm aat", nil)
end

function Component:GmGetAllTitleFrame()
  self:CallServerMethod("GmGetAllTitleFrame")
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(GWorld.GameInstance, "sgm aatf", nil)
end

function Component:_OnPropChangeTitles(Keys)
  self:ReconcileExpiredLimitedTitleReddots()
  EventManager:FireEvent(EventID.OnGetTitle, self.Titles)
end

function Component:_OnPropChangeTitleFrames(Keys)
  EventManager:FireEvent(EventID.OnGetTitleFrame, self.TitleFrames)
end

function Component:OnGetTitleFrame(TitleFrames)
  DebugPrint("yklua OnGetTitle")
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    for FrameID, GetTime in pairs(TitleFrames) do
      local CacheKey = FrameID
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("TitleFrame")
      if nil == CacheDetail[CacheKey] and "-1" ~= CacheKey and 10001 ~= FrameID then
        UIUtils.TryAddReddotCacheDetailNumber(CacheKey, "TitleFrame")
      end
    end
  end
  ReddotManager.IncreaseLeafNodeCount("TitleBtn", 1)
end

function Component:OnGetTitle(Titles)
  local Avatar = GWorld:GetAvatar()
  local bAdded = false
  if Avatar then
    for FrameID, GetTime in pairs(Titles) do
      local CacheKey = FrameID
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
      if nil == CacheDetail[CacheKey] and "-1" ~= CacheKey then
        UIUtils.TryAddReddotCacheDetailNumber(CacheKey, "Title")
        bAdded = true
      end
    end
  end
  if bAdded then
    ReddotManager.IncreaseLeafNodeCount("TitleBtn", 1)
  end
end

function Component:InitReddots()
  EventManager:AddEvent(EventID.OnGetTitle, self, self.OnGetTitle)
  EventManager:AddEvent(EventID.OnGetTitleFrame, self, self.OnGetTitleFrame)
  local Node = ReddotManager.GetTreeNode("TitleBtn")
  Node = Node or ReddotManager.AddNodeEx("TitleBtn", nil, 1)
  Node = ReddotManager.GetTreeNode("TitleTab")
  Node = Node or ReddotManager.AddNodeEx("TitleTab", nil, 1)
  Node = ReddotManager.GetTreeNode("TitleFrameTab")
  Node = Node or ReddotManager.AddNodeEx("TitleFrameTab", nil, 1)
  self:ReconcileExpiredLimitedTitleReddots()
end

function Component:ClearEvent()
  EventManager:RemoveEvent(EventID.OnGetTitle, self)
  EventManager:RemoveEvent(EventID.OnGetTitleFrame, self)
end

function Component:CheckTitleEnough(CheckData)
  for TitleId, _ in pairs(CheckData) do
    if not self.Titles[TitleId] then
      return false
    end
  end
  return true
end

function Component:CheckTitleFrameEnough(CheckData)
  for TitleFrameId, _ in pairs(CheckData) do
    if not self.TitleFrames[TitleFrameId] then
      return false
    end
  end
  return true
end

function Component:IsLimitedTitleExpired(TitleId)
  if not TitleId or -1 == TitleId then
    return false
  end
  local LimitedTypeData = DataMgr.LimitedTimeResource.Title
  if not LimitedTypeData or not LimitedTypeData[TitleId] then
    return false
  end
  local EndTime = self:GetLimitedTitleEndTime(TitleId)
  if not EndTime then
    return true
  end
  return EndTime <= TimeUtils.NowTime()
end

function Component:GetLimitedTitleEndTime(TitleId)
  if not TitleId or -1 == TitleId then
    return nil
  end
  local LimitedTypeData = DataMgr.LimitedTimeResource.Title
  if not LimitedTypeData or not LimitedTypeData[TitleId] then
    return nil
  end
  local EndTime
  if self.LimitedItems then
    local LimitedItem = self.LimitedItems:GetLimitedItem("Title", TitleId)
    if LimitedItem and LimitedItem.EndTime then
      EndTime = LimitedItem.EndTime
    end
  end
  if not EndTime then
    local LimitedInfo = ItemUtils.GetItemLimitedInfo(TitleId, "Title")
    EndTime = LimitedInfo and LimitedInfo.EndTime
  end
  if type(EndTime) == "table" and EndTime.GetTime then
    EndTime = EndTime.GetTime()
  end
  return EndTime
end

function Component:GetTitleReddotCacheEntry(CacheDetail, TitleId)
  if nil ~= CacheDetail[TitleId] then
    return TitleId, CacheDetail[TitleId]
  end
  local StringKey = tostring(TitleId)
  if nil ~= CacheDetail[StringKey] then
    return StringKey, CacheDetail[StringKey]
  end
  return TitleId, nil
end

function Component:CollectExpiredLimitedTitleIdsFromReddot()
  local TitleIds = {}
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
  if not CacheDetail then
    return TitleIds, CacheDetail
  end
  local LimitedTypeData = DataMgr.LimitedTimeResource.Title
  if not LimitedTypeData then
    return TitleIds, CacheDetail
  end
  local Titles = self.Titles
  if not Titles then
    return TitleIds, CacheDetail
  end
  local Seen = {}
  for CacheKey, _ in pairs(CacheDetail) do
    local TitleId = tonumber(CacheKey)
    if TitleId and -1 ~= TitleId and not Seen[TitleId] and not Titles[TitleId] and LimitedTypeData[TitleId] then
      Seen[TitleId] = true
      table.insert(TitleIds, TitleId)
    end
  end
  table.sort(TitleIds)
  return TitleIds, CacheDetail
end

function Component:SubExpiredLimitedTitleReddotFlags(CacheDetail, TitleIds)
  for _, TitleId in ipairs(TitleIds) do
    local CacheKey, Flag = self:GetTitleReddotCacheEntry(CacheDetail, TitleId)
    if Flag then
      UIUtils.TrySubReddotCacheDetailNumber(CacheKey, "Title")
    end
  end
end

function Component:ReconcileExpiredLimitedTitleReddots()
  local TitleIds, CacheDetail = self:CollectExpiredLimitedTitleIdsFromReddot()
  if not CacheDetail then
    return
  end
  self:SubExpiredLimitedTitleReddotFlags(CacheDetail, TitleIds)
end

function Component:CollectAndClearExpiredLimitedTitleReddots()
  local TitleIds, CacheDetail = self:CollectExpiredLimitedTitleIdsFromReddot()
  if CacheDetail then
    self:SubExpiredLimitedTitleReddotFlags(CacheDetail, TitleIds)
    for _, TitleId in ipairs(TitleIds) do
      CacheDetail[TitleId] = nil
      CacheDetail[tostring(TitleId)] = nil
    end
  end
  return TitleIds
end

function Component:UnequipExpiredWornLimitedTitles()
  if self:IsLimitedTitleExpired(self.TitleBefore) then
    self:ChangeTitleBefore(-1)
  end
  if self:IsLimitedTitleExpired(self.TitleAfter) then
    self:ChangeTitleAfter(-1)
  end
end

function Component:TryOpenTitleSettingPopup(OwnerWidget, PopupParams)
  if not IsValid(OwnerWidget) then
    return
  end
  self:UnequipExpiredWornLimitedTitles()
  local TitleIds = self:CollectAndClearExpiredLimitedTitleReddots()
  if 0 == #TitleIds then
    UIManager(OwnerWidget):ShowCommonPopupUI(100239, PopupParams, OwnerWidget)
    return
  end
  local Names = {}
  for _, TitleId in ipairs(TitleIds) do
    local TitleData = DataMgr.Title[TitleId]
    if TitleData then
      table.insert(Names, GText(TitleData.Name))
    end
  end
  UIManager(OwnerWidget):ShowCommonPopupUI(100438, {
    ShortText = string.format(GText("UI_Title_LimitTime_Tips"), table.concat(Names, "，")),
    OnCloseCallbackObj = OwnerWidget,
    OnCloseCallbackFunction = function(CallbackObj)
      if not IsValid(CallbackObj) then
        return
      end
      UIManager(CallbackObj):ShowCommonPopupUI(100239, PopupParams, CallbackObj)
    end
  }, OwnerWidget)
end

return Component
