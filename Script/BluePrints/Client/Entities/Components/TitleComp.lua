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
end

function Component:GmGetAllTitleFrame()
  self:CallServerMethod("GmGetAllTitleFrame")
end

function Component:_OnPropChangeTitles(Keys)
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
  if Avatar then
    for FrameID, GetTime in pairs(Titles) do
      local CacheKey = FrameID
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
      if nil == CacheDetail[CacheKey] and "-1" ~= CacheKey then
        UIUtils.TryAddReddotCacheDetailNumber(CacheKey, "Title")
      end
    end
  end
  ReddotManager.IncreaseLeafNodeCount("TitleBtn", 1)
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

return Component
