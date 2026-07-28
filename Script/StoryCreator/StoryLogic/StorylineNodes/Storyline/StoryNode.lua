local Questline = require("StoryCreator.StoryLogic.StorylineNodes.Questline.Questline")
local StoryNode = Class("StoryCreator.StoryLogic.StorylineNodes.Node")
local EMCache = require("EMCache.EMCache")

function StoryNode:Start(Context, NodeId)
  self.Questline = Questline(self.Data, Context, self)
  local Avatar = GWorld:GetAvatar()
  local Cache
  if Avatar then
    Cache = EMCache:Get(tonumber(self.Data.key), true)
  end
  if self.bIsStartChapter and self.QuestUIId and 0 ~= self.QuestUIId and nil == Cache then
    local UIInfo = DataMgr.QuestUI[self.QuestUIId]
    EMCache:Set(tonumber(self.Data.key), 1, true)
    local Obj = UIManager(GWorld.GameInstance):LoadUINew(UIInfo.UIName, UIInfo.ChapterName, UIInfo.CantoName, UIInfo.Title, UIInfo.AudioPath, function()
      if self.Questline then
        self.Questline:StartQuest(NodeId)
      end
    end)
    if Obj and Obj.Transition04_02 then
      Obj:Transition04_02(self.QuestUIId)
    end
  else
    self.Questline:StartQuest(NodeId)
  end
end

function StoryNode:FinishQuest(OutPortName, bSucceeded)
  self:Finish(OutPortName, bSucceeded)
end

function StoryNode:StopQuest(IgnoreFinishClear)
  if self.Questline then
    self.Questline:StopQuest(IgnoreFinishClear)
  end
end

function StoryNode:SuccessQuest()
  if self.Questline then
    self.Questline:SuccessQuest()
  end
end

function StoryNode:FailQuest()
  if self.Questline then
    self.Questline:FailQuest()
  end
end

function StoryNode:PrintInfo()
  if self.Questline then
    self.Questline:PrintInfo()
  end
end

function StoryNode:ToString()
  local NameStr = self.Name or "invalid_name"
  local TypeStr = self.Type or "invalid_type"
  local QuestChainIdStr = self.Context and self.Context.QuestChainId or "invalid_questchainid"
  local QuestIdStr = self.QuestId or "invalid_questid"
  local QuestDesc = self.QuestDescription or "invalid_questdescription"
  local KeyStr = self.Key or "invalid_key"
  return NameStr .. "  " .. TypeStr .. "  " .. QuestChainIdStr .. "  " .. QuestIdStr .. "  " .. QuestDesc .. "  " .. KeyStr
end

function StoryNode:GetChildNodes()
  local Questline = self.Questline or Questline(self.Data, self.Context, self)
  return Questline:GetNodes()
end

function StoryNode:StopStory()
  self.Context:StopStory()
end

function StoryNode:OnStop()
  if self.Questline then
    self.Questline:OnStop()
  end
  self.Questline = nil
end

function StoryNode:OnFinish()
  if self.Questline then
    self.Questline:OnFinish()
  end
  self.Questline = nil
end

function StoryNode:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  if self.Type == NodeType then
    table.insert(OutRunningNodeTable, self)
  end
  if self.Questline then
    self.Questline:GetRunningNodeTableByType(NodeType, OutRunningNodeTable)
  end
end

function StoryNode:IsGuideNodeRunning()
  if self.Questline then
    return self.Questline:IsGuideNodeRunning()
  end
  return false
end

return StoryNode
