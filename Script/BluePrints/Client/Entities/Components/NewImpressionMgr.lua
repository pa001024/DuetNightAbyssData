local Component = {}
local TimerMgr = require("BluePrints.Common.TimerMgr")
local ImpressionController = require("BluePrints.Story.Talk.Controller.ImpressionController")
local LocalTimeOut = 10

function Component:OnLoginSuccess()
  ImpressionController:Init()
end

function Component:LeaveWorld()
  ImpressionController:Destory()
end

function Component:ImpressionCheckByEnumId_New(DialogueChain, CurrentDialogueId, TalkTriggerId, ImpressionAreaId, DiceNum, ClientDelegate, CheckInfo, UsingGM, bTalkOptions)
  local DialogueChain = DialogueChain or {}
  DialogueChain = CommonUtils.CopyTable(DialogueChain)
  table.insert(DialogueChain, CurrentDialogueId)
  local Params = {
    CurrentDialogueId = CurrentDialogueId,
    TalkTriggerId = TalkTriggerId,
    Type = "Check",
    CheckInfo = CheckInfo
  }
  
  local function Callback(Ret, IsCheckSuccess, rand1, rand2, Rewards)
    self.logger.info("ZJT_ 11111111111111111111 ImpressionCheckByEnumId_New ", Ret, IsCheckSuccess, rand1, rand2, Rewards, CurrentDialogueId)
    if ClientDelegate and ClientDelegate[1] then
      TimerMgr.RemoveTimer(ClientDelegate[1], "ImpressionCheck", true)
    end
    Params.Rewards = Rewards
    if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
      ClientDelegate[2](ClientDelegate[1], Ret, IsCheckSuccess, rand1, rand2, Params, DialogueChain)
    end
    EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "Impression", TalkTriggerId)
    EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "Impression", TalkTriggerId)
    EventManager:FireEvent(EventID.TriggerFlexibleActive, "Impression")
  end
  
  if UsingGM then
    Callback(0, true, 9, 9)
    return
  end
  self:CallServer("ImpressionCheckByEnumId_New", Callback, DialogueChain, DiceNum)
  if ClientDelegate and ClientDelegate[1] and ClientDelegate[3] then
    TimerMgr.AddTimer(ClientDelegate[1], LocalTimeOut, ClientDelegate[3], false, 0, "ImpressionCheck", true, DialogueChain)
  end
end

function Component:ImpressionAddByEnumId_New(DialogueChain, CurrentDialogueId, ClientDelegate, UsingGM)
  local DialogueChain = DialogueChain and CommonUtils.CopyTable(DialogueChain) or {}
  table.insert(DialogueChain, CurrentDialogueId)
  
  local function Callback(Ret)
    self.logger.info("ZJT_ 11111111111111111111 ImpressionAddByEnumId_New ", Ret, CurrentDialogueId)
    if ClientDelegate and ClientDelegate[1] then
      TimerMgr.RemoveTimer(ClientDelegate[1], "ImpressionPlus", true)
    end
    if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
      ClientDelegate[2](ClientDelegate[1], Ret, DialogueChain)
    end
  end
  
  if UsingGM then
    Callback(0)
    return
  end
  self:CallServer("ImpressionAddByEnumId_New", Callback, DialogueChain)
  if ClientDelegate and ClientDelegate[1] and ClientDelegate[3] then
    TimerMgr.AddTimer(ClientDelegate[1], LocalTimeOut, ClientDelegate[3], false, 0, "ImpressionPlus", true, DialogueChain)
  end
end

function Component:SetTalkTriggerComplete_New(TalkTriggerId, ClientDelegate)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
  Player:SetCanInteractiveTrigger(false)
  Player:DisablePlayerInputInDeliver(true)
  
  local function Callback(Ret, Rewards)
    self.logger.info("ZJT_ 11111111111111111111 SetTalkTriggerComplete_New ", Ret, TalkTriggerId)
    EventManager:FireEvent(EventID.SetNpcFlexibShowOrHideDynamic, "Impression", TalkTriggerId)
    EventManager:FireEvent(EventID.SetCustomNpcFlexibShowOrHideDynamic, "Impression", TalkTriggerId)
    EventManager:FireEvent(EventID.TriggerFlexibleActive, "Impression")
    if ErrorCode:Check(Ret) then
      EventManager:FireEvent(EventID.OnImprTalkTriggerComplete, TalkTriggerId)
      local TalkTriggerInfo = DataMgr.TalkTrigger[TalkTriggerId]
      local RewardId = TalkTriggerInfo.RewardId
      local rewardData = DataMgr.Reward[RewardId]
      local Player = UE4.UGameplayStatics.GetPlayerCharacter(GWorld.GameInstance, 0)
      if rewardData then
        local function func()
          Player:SetCanInteractiveTrigger(true)
          
          Player:DisablePlayerInputInDeliver(false)
          local GameInstance = GWorld.GameInstance
          local UIManager = GameInstance:GetGameUIManager()
          local UI = UIManager:GetUI("GetItemPage")
          if UI then
            UI:BindActionOnClosed()
          end
        end
        
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(rewardData.Type[1], rewardData.Id[1], rewardData.Count[1][1], Rewards, false, func, self, false)
      else
        Player:SetCanInteractiveTrigger(true)
        Player:DisablePlayerInputInDeliver(false)
      end
    else
      Player:SetCanInteractiveTrigger(true)
      Player:DisablePlayerInputInDeliver(false)
    end
    Player:RemoveTimer("ImpressionMgrResumeInteractive", true)
    if ClientDelegate and ClientDelegate[1] and ClientDelegate[2] then
      ClientDelegate[2](ClientDelegate[1])
    end
  end
  
  self:CallServer("SetTalkTriggerComplete_New", Callback, TalkTriggerId)
end

function Component:GMAddImpressionPreNode(PreDialogueId)
  local function Callback(Ret)
    self.logger.info("ZJT_ 11111111111111111111 AddImpressionPreNode ", Ret, PreDialogueId)
  end
  
  self:CallServer("GMAddImpressionPreNode", Callback, PreDialogueId)
end

return Component
