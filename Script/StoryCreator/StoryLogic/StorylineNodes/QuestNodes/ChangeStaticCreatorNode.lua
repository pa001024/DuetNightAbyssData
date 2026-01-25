local EActorEventType = require("StoryCreator.StoryLogic.StorylineUtils").EActorEventType
local QuestNodeUtils = require("StoryCreator.StoryLogic.QuestNodeUtils")
local ChangeStaticCreatorNode = Class("StoryCreator.StoryLogic.StorylineNodes.Questline.QuestNode")

function ChangeStaticCreatorNode:Init()
  self.ActiveEnable = false
  self.EnableBlackScreenSync = false
  self.EnableFadeIn = false
  self.EnableFadeOut = false
  self.StaticCreatorIdList = {}
  self.NewTargetPointName = ""
  self.AssureTimerHandle = ""
  self.TempPrintInfo = {}
end

function ChangeStaticCreatorNode:Start(Context)
  self.Context = Context
  if not self:IsAllStaticCreatorValid() then
    self:PrintErrorlog("填入静态点Id不存在，节点中断！")
    return
  end
  if not self.EnableBlackScreenSync then
    self:ChangeStaticCreatorState()
    return
  end
  if self.EnableFadeIn then
    DebugPrint("ChangeStaticCreatorNode: 黑屏开启")
    self:PlayBlackUIIn()
  else
    if self.EnableFadeOut then
      self:DirectShowBlackUI()
    end
    self:ChangeStaticCreatorState()
  end
end

function ChangeStaticCreatorNode:ChangeStaticCreatorState()
  DebugPrint("------------ ChangeStaticCreatorNode ------------------")
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  assert(IsValid(GameMode), "GameMode is not valid!")
  if not IsValid(GameMode) then
    return
  end
  if self.EnableBlackScreenSync then
    self:AddAssureTimer()
  end
  self.ActivedMonsterCount = 0
  
  local function LoadFinishCallback(SelfNode, Info)
    self.ActivedMonsterCount = self.ActivedMonsterCount + 1
    if Info.Actor then
      DebugPrint("ChangeStaticCreatorNode 接收到回调. 目前收到的回调总数:", self.ActivedMonsterCount, " CreatorId", Info.Actor.CreatorId, "Eid", Info.Actor.Eid, "UnitId", Info.Actor.UnitId, "Name", Info.Actor:GetName())
    else
      DebugPrint("ChangeStaticCreatorNode 接收到回调. 目前收到的回调总数:", self.ActivedMonsterCount)
    end
    if self.ActivedMonsterCount == #self.StaticCreatorIdList then
      GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
      self:FinishAction()
    end
  end
  
  if self.ActiveEnable then
    if self.EnableBlackScreenSync then
      local function BindEventAndTrigger()
        DebugPrint("ChangeStaticCreatorNode 生成/销毁刷新点: 绑定事件并激活静态点")
        
        local IsAllLevelLoaded = self:IsAllLevelLoaded()
        if IsAllLevelLoaded then
          for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
            GWorld.StoryMgr:BindStaticCreatorActorEvent(StaticCreatorId, EActorEventType.OnCreated, self, LoadFinishCallback)
          end
        end
        QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorIdList)
        if not IsAllLevelLoaded then
          self:PrintErrorlog("静态点激活前检测到关卡未加载，黑屏直接关闭，节点完成！")
          self:DirectCloseBlackUI()
          self:Finish()
        end
      end
      
      local NewTargetPoint = GameMode.EMGameState:GetTargetPoint(self.NewTargetPointName)
      if self.NewTargetPointName == nil or self.NewTargetPointName == "" or not IsValid(NewTargetPoint) then
        BindEventAndTrigger()
      else
        local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
        if GameMode:GetWCSubSystem() then
          DebugPrint("ChangeStaticCreatorNode 生成/销毁刷新点: 开始传送至目标点", self.NewTargetPointName)
          GameMode:GetWCSubSystem():RequestAsyncTravel(Player, NewTargetPoint:GetTransform(), {
            GWorld.GameInstance,
            BindEventAndTrigger
          }, true)
        else
          DebugPrint("Warning ChangeStaticCreatorNode 生成/销毁刷新点: 此区域没有WC")
          GameMode:EMSetActorLocationAndRotation(0, self.NewTargetPointName, true)
          BindEventAndTrigger()
        end
      end
    else
      QuestNodeUtils.STLTriggerActiveStaticCreator(self, self.StaticCreatorIdList)
      self:FinishAction()
    end
  else
    local StaticCreatorArray = TArray(0)
    for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
      StaticCreatorArray:Add(StaticCreatorId)
    end
    GameMode:TriggerInactiveStaticCreator(StaticCreatorArray, false, EDestroyReason.StoryLine)
    self:FinishAction()
  end
end

function ChangeStaticCreatorNode:FinishAction()
  if not self.EnableBlackScreenSync then
    self:Finish()
    return
  end
  if self.EnableFadeOut then
    DebugPrint("ChangeStaticCreatorNode: 黑屏结束")
    self:PlayBlackUIOut()
  else
    if self.EnableFadeIn then
      self:DirectCloseBlackUI()
    end
    self:Finish()
  end
end

function ChangeStaticCreatorNode:Clear()
  DebugPrint("ChangeStaticCreatorNode: Clear")
  GWorld.GameInstance:RemoveTimer(self.AssureTimerHandle)
  self:DirectCloseBlackUI()
  if self.EnableBlackScreenSync then
    for index, StaticCreatorId in pairs(self.StaticCreatorIdList) do
      GWorld.StoryMgr:UnbindStaticCreatorActorEventByType(StaticCreatorId, EActorEventType.OnCreated)
    end
  end
end

function ChangeStaticCreatorNode:IsAllStaticCreatorValid()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  for _, CreatorId in pairs(self.StaticCreatorIdList) do
    local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
    if not IsValid(Creator) then
      ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: 填入的静态点Id【" .. tostring(CreatorId) .. "】找不到静态点，请检查！")
      table.insert(self.TempPrintInfo, CreatorId)
      return false
    end
  end
  return true
end

function ChangeStaticCreatorNode:IsAllLevelLoaded()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  for _, CreatorId in pairs(self.StaticCreatorIdList) do
    local Creator = GameMode.EMGameState:GetStaticCreatorInfo(CreatorId)
    if not GameMode:CheckLevelLoadedByActor(Creator) then
      ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: 填入的静态点Id【" .. tostring(CreatorId) .. "】所在关卡没有被加载，请检查！")
      table.insert(self.TempPrintInfo, CreatorId)
      return false
    end
  end
  return true
end

function ChangeStaticCreatorNode:PlayBlackUIIn()
  local Params = {}
  Params.BlackScreenHandle = "ChangeStaticCreatorNode" .. self.Key
  Params.InAnimationObj = self
  Params.InAnimationCallback = self.ChangeStaticCreatorState
  Params.InAnimationPlayTime = 1
  Params.OutAnimationObj = self
  Params.OutAnimationCallback = self.Finish
  Params.OutAnimationPlayTime = 1
  UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

function ChangeStaticCreatorNode:PlayBlackUIOut()
  UIManager(GWorld.GameInstance):HideCommonBlackScreen("ChangeStaticCreatorNode" .. self.Key)
end

function ChangeStaticCreatorNode:DirectShowBlackUI()
  local Params = {}
  Params.BlackScreenHandle = "ChangeStaticCreatorNode" .. self.Key
  Params.InAnimationPlayTime = 0
  Params.OutAnimationObj = self
  Params.OutAnimationCallback = self.Finish
  Params.OutAnimationPlayTime = 1
  UIManager(GWorld.GameInstance):ShowCommonBlackScreen(Params)
end

function ChangeStaticCreatorNode:DirectCloseBlackUI()
  UIManager(GWorld.GameInstance):CloseCommonBlackScreenWithoutCB("ChangeStaticCreatorNode" .. self.Key)
end

function ChangeStaticCreatorNode:AddAssureTimer()
  local function OnAssureTimerEnd()
    self:PrintErrorlog("黑屏时间过长，触发保底后节点完成！")
    
    self:DirectCloseBlackUI()
    self:Finish()
  end
  
  self.AssureTimerHandle = "ChangeStaticCreatorNodeAssureTimer" .. self.Key
  GWorld.GameInstance:AddTimer(5, OnAssureTimerEnd, false, 0, self.AssureTimerHandle)
end

function ChangeStaticCreatorNode:PrintErrorlog(Msg)
  ScreenPrint("Error! ChangeStaticCreatorNode 生成/销毁刷新点: ", Msg)
  local Message = "ChangeStaticCreatorNode " .. Msg .. "\t" .. table.concat(self.TempPrintInfo, ",") .. "\n====STL信息========" .. [[

FileName:	]] .. self.Context.FileName .. [[

QuestChainId:	]] .. self.Context.QuestChainId .. [[

QuestId:	]] .. self.Context.QuestId .. [[

StoryNodeKey:	]] .. self.Context.Data.key .. [[

Key:	]] .. self.Key .. "\n====节点配置信息========" .. "\n生成/销毁:\t" .. tostring(self.ActiveEnable) .. "\n启用黑屏同步:\t" .. tostring(self.EnableBlackScreenSync) .. "\n启用淡入黑屏:\t" .. tostring(self.EnableFadeIn) .. "\n启用淡出黑屏:\t" .. tostring(self.EnableFadeOut) .. "\n静态点Id列表:\t" .. table.concat(self.StaticCreatorIdList, ",") .. "\n目标点名称:\t" .. tostring(self.NewTargetPointName)
  UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Quest, "生成/销毁刷新点节点出错", Message)
  self.TempPrintInfo = {}
end

return ChangeStaticCreatorNode
