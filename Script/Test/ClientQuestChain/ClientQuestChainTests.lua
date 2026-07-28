local M = Class()

function M:ReceiveStartTest()
  local function AssertTrue(Condition, Message)
    if not Condition then
      self:FinishTest(UE4.EFunctionalTestResult.Failed, Message)
      
      return false
    end
    return true
  end
  
  local function AssertEqual(Expected, Actual, Message)
    if Expected ~= Actual then
      self:FinishTest(UE4.EFunctionalTestResult.Failed, string.format("%s | Expected: %s, Actual: %s", Message, tostring(Expected), tostring(Actual)))
      return false
    end
    return true
  end
  
  local ClientQuestChain = require("BluePrints.Client.Quest.ClientQuestChain")
  local TestQuestChainId = 123456
  local MockStoryPath = "Test/ClientQuestChainTest123456.story"
  local MockDoingQuestId = 12345601
  local MockQuestChainData = {
    [TestQuestChainId] = {
      QuestChainId = TestQuestChainId,
      StoryPath = MockStoryPath,
      DoingQuestId = MockDoingQuestId
    }
  }
  local OriginalGetQuestChain = ClientQuestChain.GetQuestChain
  
  function ClientQuestChain.GetQuestChain(CQChain)
    return MockQuestChainData[CQChain.QuestChainId]
  end
  
  local function Restore()
    ClientQuestChain.GetQuestChain = OriginalGetQuestChain
  end
  
  local Chain = ClientQuestChain(TestQuestChainId)
  if not AssertTrue(nil ~= Chain, "ClientQuestChain should not be nil after creation") then
    Restore()
    return
  end
  if not AssertEqual(TestQuestChainId, Chain:GetQuestChainId(), "GetQuestChainId should match Init value") then
    Restore()
    return
  end
  if not AssertEqual(false, Chain:IsStorylineRunning(), "IsStorylineRunning should be false initially") then
    Restore()
    return
  end
  if not AssertEqual(nil, Chain:GetStoryline(), "GetStoryline should be nil initially") then
    Restore()
    return
  end
  if not AssertEqual(MockStoryPath, Chain:GetStoryPath(), "GetStoryPath should return mocked StoryPath") then
    Restore()
    return
  end
  if not AssertEqual(MockDoingQuestId, Chain:GetDoingQuestId(), "GetDoingQuestId should return mocked DoingQuestId") then
    Restore()
    return
  end
  local StartResult = Chain:StartStoryline()
  if StartResult then
    if not AssertEqual(true, Chain:IsStorylineRunning(), "IsStorylineRunning should be true after StartStoryline") then
      Restore()
      return
    end
    if not AssertTrue(nil ~= Chain:GetStoryline(), "GetStoryline should not be nil after StartStoryline") then
      Restore()
      return
    end
    local SecondStart = Chain:StartStoryline()
    if not AssertEqual(nil, SecondStart, "StartStoryline should return nil when already running") then
      Restore()
      return
    end
    Chain:StopStoryline()
    if not AssertEqual(false, Chain:IsStorylineRunning(), "IsStorylineRunning should be false after StopStoryline") then
      Restore()
      return
    end
    if not AssertEqual(nil, Chain:GetStoryline(), "GetStoryline should be nil after StopStoryline") then
      Restore()
      return
    end
    local RestartResult = Chain:RestartStoryline()
    if RestartResult then
      if not AssertEqual(true, Chain:IsStorylineRunning(), "IsStorylineRunning should be true after RestartStoryline") then
        Restore()
        return
      end
      Chain:StopStoryline()
    end
  end
  Chain:StartStoryline()
  if Chain:IsStorylineRunning() then
    local TestObj = {}
    
    local function TestFunc()
    end
    
    Chain:AddStartQuestCallback(TestObj, TestFunc)
    Chain:AddFinishQuestCallback(TestObj, TestFunc)
    local Storyline = Chain:GetStoryline()
    local StartFound = false
    local FinishFound = false
    if Storyline then
      for _, CB in ipairs(Storyline.OnStartNodeCallbacks or {}) do
        if CB.Obj == TestObj and CB.Func == TestFunc then
          StartFound = true
          break
        end
      end
      for _, CB in ipairs(Storyline.OnFinishNodeCallbacks or {}) do
        if CB.Obj == TestObj and CB.Func == TestFunc then
          FinishFound = true
          break
        end
      end
    end
    if not AssertTrue(StartFound, "Start callback should be registered in Storyline") then
      Restore()
      return
    end
    if not AssertTrue(FinishFound, "Finish callback should be registered in Storyline") then
      Restore()
      return
    end
    Chain:RemoveStartQuestCallback(TestObj)
    Chain:RemoveFinishQuestCallback(TestObj)
    StartFound = false
    FinishFound = false
    if Storyline then
      for _, CB in ipairs(Storyline.OnStartNodeCallbacks or {}) do
        if CB.Obj == TestObj then
          StartFound = true
          break
        end
      end
      for _, CB in ipairs(Storyline.OnFinishNodeCallbacks or {}) do
        if CB.Obj == TestObj then
          FinishFound = true
          break
        end
      end
    end
    if not AssertEqual(false, StartFound, "Start callback should be removed") then
      Restore()
      return
    end
    if not AssertEqual(false, FinishFound, "Finish callback should be removed") then
      Restore()
      return
    end
    Chain:StopStoryline()
  end
  Chain:StartStoryline()
  if Chain:IsStorylineRunning() then
    local FakeQuestId = 99999999
    local DoingQuestIdResult = Chain:CheckQuestIdIsInStory(MockDoingQuestId)
    local FakeQuestIdResult = Chain:CheckQuestIdIsInStory(FakeQuestId)
    if not AssertEqual(true, DoingQuestIdResult, "DoingQuestId should be existed in Story") then
      Restore()
      return
    end
    if not AssertEqual(false, FakeQuestIdResult, "FakeQuestId should not be existed in Story") then
      Restore()
      return
    end
    Chain:StopStoryline()
  end
  local NilNode = Chain:GetDoingStoryNode()
  if not AssertEqual(nil, NilNode, "GetDoingStoryNode should return nil when storyline not running") then
    Restore()
    return
  end
  Chain:StartStoryline()
  if Chain:IsStorylineRunning() then
    local DoingNode = Chain:GetDoingStoryNode()
    if not AssertTrue(nil ~= DoingNode, "GetDoingStoryNode should return StoryNode when storyline running") then
      Restore()
      return
    end
    if not AssertEqual(MockDoingQuestId, DoingNode.QuestId, "GetDoingStoryNode returned StoryNode should have correct QuestId") then
      Restore()
      return
    end
    Chain:FailDoingQuest()
    if not AssertEqual(nil, DoingNode.Questline, "FailDoingQuest should trigger FailQuest on the doing StoryNode") then
      Restore()
      return
    end
    Chain:StopStoryline()
  end
  Restore()
  self:FinishTest(UE4.EFunctionalTestResult.Succeeded, "ClientQuestChainTests: All tests passed")
end

return M
