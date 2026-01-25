local SettingUtils = require("Utils.SettingUtils")
local Component = {}
local SignBoardBubbleTalkController = require("BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkController")
local StoryInteractiveController = require("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveController")

function Component:EnterWorld(...)
  SignBoardBubbleTalkController:Init()
  StoryInteractiveController:Init()
  self:InitReddotTrees()
end

function Component:LeaveWorld(...)
  SignBoardBubbleTalkController:Destory()
  StoryInteractiveController:Destory()
end

function Component:InitReddotTrees()
  ReddotManager.AddNodeEx("Setting_Root")
  if SettingUtils.IsShowRedDotForLayoutPlan() then
    ReddotManager.IncreaseLeafNodeCount("Setting_Layout", 1)
  end
end

function Component:InitGameSetting()
  self:CheckActionMappingAdd()
  self:CheckActionMappingWithAvatar()
end

function Component:CheckActionMappingAdd()
  local InputSetting = UE4.UInputSettings.GetInputSettings()
  local ActionMappings = InputSetting.ActionMappings:ToTable()
  local EngineActionMappings = {}
  local KeyInfo = DataMgr.KeyboardMap
  for k, v in ipairs(ActionMappings) do
    local Res = string.find(v.Key.KeyName, "Gamepad")
    local KeyData = DataMgr.KeyboardMap[v.ActionName]
    if nil == Res and KeyData and KeyData.IsShowInSetting then
      EngineActionMappings[v.ActionName] = v
    end
  end
  local AxisMappings = InputSetting.AxisMappings:ToTable()
  for k, v in ipairs(AxisMappings) do
    local Res = string.find(v.Key.KeyName, "Gamepad")
    local Res2 = string.find(v.AxisName, "Talk")
    if nil == Res2 and nil == Res and DataMgr.AxisName2ActionName[v.AxisName] then
      local Scale = tostring(v.Scale)
      local ActionName = DataMgr.AxisName2ActionName[v.AxisName][Scale]
      if ActionName then
        EngineActionMappings[ActionName] = v
      end
    end
  end
  for Action, Data in pairs(KeyInfo) do
    local EngineAction = EngineActionMappings[Action]
    if nil == EngineAction then
      if Data.AxisActionName then
        local Scale = tonumber(Data.Scale)
        local NewEngineMapping = UE4.FInputAxisKeyMapping()
        NewEngineMapping.Key = UE4.EKeys[Data.Key]
        NewEngineMapping.ActionName = Data.AxisActionName
        NewEngineMapping.Scale = Scale
        InputSetting:AddAxisMapping(NewEngineMapping)
      else
        local NewEngineMapping = UE4.FInputActionKeyMapping()
        NewEngineMapping.Key = UE4.EKeys[Data.Key]
        NewEngineMapping.ActionName = Action
        InputSetting:AddActionMapping(NewEngineMapping)
      end
    end
  end
  InputSetting:SaveKeyMappings()
end

function Component:CheckActionMappingWithAvatar()
  local InputSetting = UE4.UInputSettings.GetInputSettings()
  local ActionMappings = InputSetting.ActionMappings:ToTable()
  local EngineActionMappings = {}
  local KeyInfo = DataMgr.KeyboardMap
  for k, v in ipairs(ActionMappings) do
    local Res = string.find(v.Key.KeyName, "Gamepad")
    local KeyData = DataMgr.KeyboardMap[v.ActionName]
    if nil == Res and KeyData and KeyData.IsShowInSetting then
      EngineActionMappings[v.ActionName] = v
    end
  end
  local AxisMappings = InputSetting.AxisMappings:ToTable()
  for k, v in ipairs(AxisMappings) do
    local Res = string.find(v.Key.KeyName, "Gamepad")
    local Res2 = string.find(v.AxisName, "Talk")
    if nil == Res2 and nil == Res and DataMgr.AxisName2ActionName[v.AxisName] then
      local Scale = tostring(v.Scale)
      local ActionName = DataMgr.AxisName2ActionName[v.AxisName][Scale]
      if ActionName then
        EngineActionMappings[ActionName] = v
      end
    end
  end
  local AddActionList = {}
  if 0 == self.ActionMapping:Length() then
    for Action, Data in pairs(KeyInfo) do
      local EngineAction = EngineActionMappings[Action]
      if Data.CanChanged then
        if Data.AxisActionName then
          if EngineAction and EngineAction.Key.KeyName ~= Data.Key then
            local NewKey = UE4.EKeys[Data.Key]
            if NewKey then
              InputSetting:RemoveAxisMapping(EngineAction)
              EngineAction.Key = NewKey
              local Scale = tonumber(Data.Scale)
              EngineAction.Scale = Scale
              table.insert(AddActionList, EngineAction)
            end
          end
        elseif EngineAction and EngineAction.Key.KeyName ~= Data.Key then
          InputSetting:RemoveActionMapping(EngineAction)
          local NewKey = UE4.EKeys[Data.Key]
          if NewKey then
            EngineAction.Key = NewKey
            InputSetting:AddActionMapping(EngineAction)
          end
        end
      end
    end
  else
    for Action, Key in pairs(self.ActionMapping) do
      local EngineAction = EngineActionMappings[Action]
      local ActionInfo = DataMgr.KeyboardMap[Action]
      if ActionInfo and ActionInfo.AxisActionName then
        if EngineAction and EngineAction.Key.KeyName ~= Key then
          local NewKey = UE4.EKeys[Key]
          if NewKey then
            InputSetting:RemoveAxisMapping(EngineAction)
            EngineAction.Key = NewKey
            local Scale = tonumber(ActionInfo.Scale)
            EngineAction.Scale = Scale
            table.insert(AddActionList, EngineAction)
          end
        end
      elseif EngineAction and EngineAction.Key.KeyName ~= Key then
        InputSetting:RemoveActionMapping(EngineAction)
        local NewKey = UE4.EKeys[Key]
        if NewKey then
          EngineAction.Key = NewKey
          InputSetting:AddActionMapping(EngineAction)
        end
      end
    end
  end
  for _, value in pairs(AddActionList) do
    InputSetting:AddAxisMapping(value)
  end
  InputSetting:SaveKeyMappings()
end

function Component:UpdateSignBoardNpc(SignBoard, NpcId)
  local function callback(Ret)
    self.logger.debug("UpdateSignBoardNpc", Ret, SignBoard, NpcId)
    
    EventManager:FireEvent(EventID.UpdateSignBoardNpc, Ret, SignBoard, NpcId)
  end
  
  self:CallServer("UpdateSignBoardNpc", callback, SignBoard, NpcId)
end

function Component:UpdateActionMapping(ActionMapping)
  local function callback(Ret)
    self.logger.debug("UpdateActionMapping", Ret, ActionMapping)
    
    EventManager:FireEvent(EventID.OnUpdateActionMapping, Ret, ActionMapping)
  end
  
  self:CallServer("UpdateActionMapping", callback, ActionMapping)
end

function Component:CheckSignBoardNpcDailyTalkIsLimit(NpcId)
  if not NpcId or not DataMgr.Npc[NpcId] then
    return false
  end
  local NpcInfo = DataMgr.Npc[NpcId]
  local CharId = NpcInfo.CharId
  if not CharId or not self.CommonChars[CharId] then
    return false
  end
  local CommonChar = self.CommonChars[CharId]
  if CommonChar.DailySignBoardNpcTalkCount >= DataMgr.GlobalConstant.IndividualLongIdleTalkTimes.ConstantValue then
    return false
  end
  if self.TotalSignBoardNpcDailyTalkCount >= DataMgr.GlobalConstant.LongIdleTalkTimes.ConstantValue then
    return false
  end
  return true
end

function Component:TriggerAddSignBoardNpcDailyTalk(NpcId, callback)
  self.logger.debug("TriggerAddSignBoardNpcDailyTalk Begin", NpcId)
  
  local function Callback(Ret)
    self.logger.debug("TriggerAddSignBoardNpcDailyTalk Callback", NpcId, Ret)
    if callback then
      callback(Ret == ErrorCode.RET_SUCCESS)
    end
  end
  
  self:CallServer("TriggerAddSignBoardNpcDailyTalk", Callback, NpcId)
end

function Component:CheckSignBoardNpcTalkIsRecord(NpcId, DialogueId)
  if not NpcId or not DataMgr.Npc[NpcId] then
    return false
  end
  local DialogueInfo = DataMgr.Dialogue_TextMapContent[DialogueId]
  if not DialogueInfo or not DialogueInfo.SpeakNpcId then
    return false
  end
  local SpeakNpcId = DialogueInfo.SpeakNpcId
  if SpeakNpcId ~= NpcId then
    return false
  end
  local NpcInfo = DataMgr.Npc[NpcId]
  local CharId = NpcInfo.CharId
  if not CharId or not self.CommonChars[CharId] then
    return false
  end
  local CommonChar = self.CommonChars[CharId]
  if CommonUtils.HasValue(CommonChar.SignBoardNpcAlreadyTalkList, DialogueId) then
    return true
  end
  return false
end

function Component:CheckSignBoardNpcTalkValid(NpcId, DialogueId)
  if not NpcId or not DataMgr.Npc[NpcId] then
    return false
  end
  local DialogueInfo = DataMgr.Dialogue[DialogueId]
  if not DialogueInfo or not DialogueInfo.SpeakNpcId then
    return false
  end
  if not DialogueInfo or not DialogueInfo.SpeakNpcId then
    return false
  end
  if DialogueInfo.SpeakNpcId ~= NpcId then
    return false
  end
  return true
end

function Component:TriggerRecordSignBoardNpcTalk(NpcId, DialogueId)
  self.logger.debug("TriggerRecordSignBoardNpcTalk Begin", NpcId, DialogueId)
  
  local function Callback(Ret)
    self.logger.debug("TriggerRecordSignBoardNpcTalk Callback", NpcId, DialogueId, Ret)
  end
  
  self:CallServer("TriggerRecordSignBoardNpcTalk", Callback, NpcId, DialogueId)
end

function Component:GetCurrentMobileHudPlanIndex()
  return self.CurrentMobileHudPlan
end

function Component:GetMobileHudPlan(PlanIndex)
  local Index = PlanIndex or self.CurrentMobileHudPlan
  local Plan = self.MobileHudPlans[Index]
  if not Plan then
    return nil
  end
  return SerializeUtils:UnSerialize(Plan)
end

function Component:GetMobileHudPlanCount()
  return self.MobileHudPlans:Length()
end

function Component:SwitchMobileHudPlan(NewPlanIndex)
  self.logger.debug("SwitchMobileHudPlan Begin", self.CurrentMobileHudPlan, NewPlanIndex)
  
  local function Callback(Ret)
    self.logger.debug("SwitchMobileHudPlan Callback", Ret, self.CurrentMobileHudPlan, NewPlanIndex)
  end
  
  self:CallServer("SwitchMobileHudPlan", Callback, NewPlanIndex)
end

function Component:UpdateMobileHudPlan(PlanIndex, PlanInfo)
  self.logger.debug("UpdateMobileHudPlan Begin", PlanIndex)
  
  local function Callback(Ret)
    EventManager:FireEvent(EventID.OnMobileHudPlanChanged, "Update", PlanIndex, PlanInfo)
    self.logger.debug("UpdateMobileHudPlan Callback", Ret, PlanIndex)
  end
  
  self:CallServer("UpdateMobileHudPlan", Callback, PlanIndex, PlanInfo)
end

function Component:AddMobileHudPlan(PlanInfo)
  self.logger.debug("AddMobileHudPlan Begin")
  
  local function Callback(Ret)
    self.logger.debug("AddMobileHudPlan Callback", Ret)
  end
  
  self:CallServer("AddMobileHudPlan", Callback, PlanInfo)
end

function Component:RemoveMobileHudPlan(PlanIndex)
  self.logger.debug("RemoveMobileHudPlan Begin", self.CurrentMobileHudPlan, PlanIndex)
  
  local function Callback(Ret)
    self.logger.debug("RemoveMobileHudPlan Callback", Ret, PlanIndex)
  end
  
  self:CallServer("RemoveMobileHudPlan", Callback, PlanIndex)
end

function Component:InitMobileHudPlan(PlanIndex)
  self.logger.debug("InitMobileHudPlan Begin", self.CurrentMobileHudPlan, PlanIndex)
  
  local function Callback(Ret)
    self.logger.debug("InitMobileHudPlan Callback", Ret, PlanIndex)
  end
  
  self:CallServer("InitMobileHudPlan", Callback, PlanIndex)
end

function Component:OnReceiveCustomerServiceRedDot()
  self.logger.debug("OnReceiveCustomerServiceRedDot")
  ReddotManager.IncreaseLeafNodeCount("Setting_Service", 1)
end

return Component
