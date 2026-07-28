local SettingUtils = require("Utils.SettingUtils")
local BattleHUDCommonConst = require("BluePrints.UI.UI_Phone.Battle.BattleHUDCommonConst")
local Component = {}
local SignBoardBubbleTalkController = require("BluePrints.UI.WBP.SignBoardBubble.SignBoardBubbleTalkController")
local StoryInteractiveController = require("BluePrints.UI.WBP.StoryInteractive.StoryInteractiveController")
local TOTAL_MOBILE_HUD_PLAN_COUNT = BattleHUDCommonConst.TOTAL_MOBILE_HUD_PLAN_COUNT
local TRIAL_LAYOUT_PLAN_INDEX = BattleHUDCommonConst.TRIAL_LAYOUT_PLAN_INDEX
local LAYOUT_ENTRY_CONFIG = {
  [1] = {
    RecordPlanIndex = 1,
    PlanList = {
      1,
      3,
      5
    }
  },
  [2] = {
    RecordPlanIndex = 2,
    PlanList = {
      2,
      4,
      6
    }
  },
  [3] = {
    RecordPlanIndex = 7,
    PlanList = {
      7,
      8,
      9
    }
  }
}

local function GetLayoutEntryIndexByPlanIndex(PlanIndex)
  for LayoutEntryIndex, LayoutConfig in pairs(LAYOUT_ENTRY_CONFIG) do
    for _, LayoutPlanIndex in ipairs(LayoutConfig.PlanList) do
      if LayoutPlanIndex == PlanIndex then
        return LayoutEntryIndex
      end
    end
  end
  return nil
end

local function GetLayoutPlanListByEntry(LayoutEntryIndex)
  local LayoutConfig = LAYOUT_ENTRY_CONFIG[LayoutEntryIndex]
  return LayoutConfig and LayoutConfig.PlanList or nil
end

local function GetDefaultMobileHudPlanName(PlanIndex)
  if PlanIndex == TRIAL_LAYOUT_PLAN_INDEX then
    return "Layout_" .. PlanIndex
  end
  local LayoutEntryIndex = GetLayoutEntryIndexByPlanIndex(PlanIndex)
  if not LayoutEntryIndex then
    return "Layout_" .. PlanIndex
  end
  local LayoutPlanList = GetLayoutPlanListByEntry(LayoutEntryIndex)
  if not LayoutPlanList then
    return "Layout_" .. PlanIndex
  end
  local SlotIndex
  for Index, LayoutPlanIndex in ipairs(LayoutPlanList) do
    if LayoutPlanIndex == PlanIndex then
      SlotIndex = Index
      break
    end
  end
  if not SlotIndex then
    return "Layout_" .. PlanIndex
  end
  return GText("UI_CustomLayout_DefaultPlanName" .. tostring(SlotIndex))
end

function Component:GetExpectedMobileHudPlanCount()
  return TOTAL_MOBILE_HUD_PLAN_COUNT
end

function Component:GetTrialMobileHudPlanIndex()
  return TRIAL_LAYOUT_PLAN_INDEX
end

function Component:GetLayoutEntryIndexByPlanIndex(PlanIndex)
  return GetLayoutEntryIndexByPlanIndex(PlanIndex)
end

function Component:GetDefaultMobileHudPlanName(PlanIndex)
  return GetDefaultMobileHudPlanName(PlanIndex)
end

function Component:GetLayoutRecordPlanIndex(LayoutEntryIndex)
  local LayoutConfig = LAYOUT_ENTRY_CONFIG[LayoutEntryIndex]
  return LayoutConfig and LayoutConfig.RecordPlanIndex or nil
end

function Component:GetLayoutPlanListByEntry(LayoutEntryIndex)
  local LayoutPlanList = GetLayoutPlanListByEntry(LayoutEntryIndex)
  if not LayoutPlanList then
    return nil
  end
  local Result = {}
  for Index, PlanIndex in ipairs(LayoutPlanList) do
    Result[Index] = PlanIndex
  end
  return Result
end

function Component:EnterWorld(...)
  SignBoardBubbleTalkController:Init()
  StoryInteractiveController:Init()
  self:InitReddotTrees()
  local PlanCount = self:GetMobileHudPlanCount()
  if PlanCount < TOTAL_MOBILE_HUD_PLAN_COUNT then
    for i = 1, TOTAL_MOBILE_HUD_PLAN_COUNT - PlanCount do
      local PlanIndex = i + PlanCount
      local DefaultPlanName = GetDefaultMobileHudPlanName(PlanIndex)
      self:AddMobileHudPlan({HudPlanName = DefaultPlanName})
    end
  end
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
  ReddotManager.ClearLeafNodeCount("Setting_Service")
  local HasCustomerServiceRedDot = self:CheckCustomerServiceRedDot()
  if HasCustomerServiceRedDot then
    ReddotManager.IncreaseLeafNodeCount("Setting_Service", 1)
  end
  ReddotManager.ClearLeafNodeCount("Setting_SecPassword")
  local GachaKey = "SecPasswordNew"
  local SecPasswordNewCache = EMCache:Get(GachaKey, true)
  if nil == SecPasswordNewCache then
    ReddotManager.IncreaseLeafNodeCount("Setting_SecPassword", 1)
  end
  local IsFirstShow = EMCache:Get("FirstOpenMobileLayoutPlan", true)
  if nil == IsFirstShow then
    EMCache:Set("FirstOpenMobileLayoutPlan", true, true)
    if UIUtils.IsMobileInput() then
      ReddotManager.ClearLeafNodeCount("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn")
      ReddotManager.IncreaseLeafNodeCount("Setting_Control_Setting_SaveBulletJumpCamAdjustBtn", 1)
      ReddotManager.ClearLeafNodeCount("Setting_Control_Setting_SaveAutoBulletJumpCamBtn")
      ReddotManager.IncreaseLeafNodeCount("Setting_Control_Setting_SaveAutoBulletJumpCamBtn", 1)
      ReddotManager.ClearLeafNodeCount("Setting_Control_Setting_MoveModelBtn")
      ReddotManager.IncreaseLeafNodeCount("Setting_Control_Setting_MoveModelBtn", 1)
      ReddotManager.ClearLeafNodeCount("Setting_Control_TrailBtn")
      ReddotManager.IncreaseLeafNodeCount("Setting_Control_TrailBtn", 1)
      ReddotManager.ClearLeafNodeCount("Setting_Control_AddBtn")
      ReddotManager.IncreaseLeafNodeCount("Setting_Control_AddBtn", 1)
    end
  end
end

function Component:InitGameSetting()
  self:CheckActionMappingAdd()
  self:CheckActionMappingWithAvatar()
end

local function ResolveAxisActionName(AxisName, Scale)
  local AxisMap = DataMgr.AxisName2ActionName[AxisName]
  if not AxisMap then
    return nil
  end
  local ScaleStr = tostring(Scale)
  local ActionName = AxisMap[ScaleStr]
  if ActionName then
    return ActionName
  end
  local ScaleNum = tonumber(ScaleStr)
  if not ScaleNum then
    return nil
  end
  local ScaleInt = math.floor(ScaleNum)
  ActionName = AxisMap[tostring(ScaleInt)]
  if ActionName then
    return ActionName
  end
  ActionName = AxisMap[string.format("%.1f", ScaleNum)]
  if ActionName then
    return ActionName
  end
  return nil
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
      local ActionName = ResolveAxisActionName(v.AxisName, v.Scale)
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
        NewEngineMapping.AxisName = Data.AxisActionName
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
      local ActionName = ResolveAxisActionName(v.AxisName, v.Scale)
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

function Component:UpdateMobileHudPlan(PlanIndex, PlanInfo, IsChangeName)
  self.logger.debug("UpdateMobileHudPlan Begin", PlanIndex)
  
  local function Callback(Ret)
    EventManager:FireEvent(EventID.OnMobileHudPlanChanged, "Update", PlanIndex, PlanInfo, IsChangeName)
    self.logger.debug("UpdateMobileHudPlan Callback", Ret, PlanIndex)
  end
  
  self:CallServer("UpdateMobileHudPlan", Callback, PlanIndex, PlanInfo)
end

function Component:RecordLayoutIndexToMappedPlan(NewPlanIndex)
  local LayoutEntryIndex = GetLayoutEntryIndexByPlanIndex(NewPlanIndex)
  if not LayoutEntryIndex then
    self.logger.debug("RecordLayoutIndexToMappedPlan Skip", NewPlanIndex)
    return
  end
  local MappedPlanIndex = self:GetLayoutRecordPlanIndex(LayoutEntryIndex)
  if not MappedPlanIndex then
    self.logger.debug("RecordLayoutIndexToMappedPlan MissingRecordPlanIndex", LayoutEntryIndex, NewPlanIndex)
    return
  end
  local ExistingPlan = self:GetMobileHudPlan(MappedPlanIndex) or {}
  local UpdatedPlan = {}
  for k, v in pairs(ExistingPlan) do
    UpdatedPlan[k] = v
  end
  UpdatedPlan.CurrentLayout = NewPlanIndex
  self.logger.debug("RecordLayoutIndexToMappedPlan Begin", MappedPlanIndex, "NewPlanIndex", NewPlanIndex)
  
  local function Callback(Ret)
    self.logger.debug("RecordLayoutIndexToMappedPlan Callback", Ret, MappedPlanIndex, "NewPlanIndex", NewPlanIndex)
  end
  
  self:CallServer("UpdateMobileHudPlan", Callback, MappedPlanIndex, UpdatedPlan)
end

function Component:GetMappedPlanCurrentLayout()
  local Plan1RecordPlanIndex = self:GetLayoutRecordPlanIndex(1)
  local Plan2RecordPlanIndex = self:GetLayoutRecordPlanIndex(2)
  local Plan3RecordPlanIndex = self:GetLayoutRecordPlanIndex(3)
  local Plan1 = self:GetMobileHudPlan(Plan1RecordPlanIndex)
  local Plan2 = self:GetMobileHudPlan(Plan2RecordPlanIndex)
  local Plan3 = self:GetMobileHudPlan(Plan3RecordPlanIndex)
  local Plan1CurrentLayout = Plan1 and Plan1.CurrentLayout or Plan1RecordPlanIndex
  local Plan2CurrentLayout = Plan2 and Plan2.CurrentLayout or Plan2RecordPlanIndex
  local Plan3CurrentLayout = Plan3 and Plan3.CurrentLayout or Plan3RecordPlanIndex
  return Plan1CurrentLayout, Plan2CurrentLayout, Plan3CurrentLayout
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
  self.logger.debug("OnReceiveCustomerServiceRedDot", self.DataStatistics.CustomerServiceRedDot)
  ReddotManager.IncreaseLeafNodeCount("Setting_Service", 1)
end

function Component:ClearCustomerServiceRedDot()
  self.logger.debug("ClearCustomerServiceRedDot Begin", self.DataStatistics.CustomerServiceRedDot)
  
  local function Callback(Ret)
    self.logger.debug("ClearCustomerServiceRedDot Callback", Ret, self.DataStatistics.CustomerServiceRedDot)
  end
  
  self:CallServer("ClearCustomerServiceRedDot", Callback)
end

function Component:CheckCustomerServiceRedDot()
  if self.DataStatistics.CustomerServiceRedDot then
    return true
  end
  return false
end

function Component:GetInteractTriggerReward(InteractTriggerId)
  self.logger.debug("GetInteractTriggerReward Begin", InteractTriggerId, self.InteractTriggerRewardRecords[InteractTriggerId])
  
  local function Callback(Ret, Rewards)
    self.logger.debug("GetInteractTriggerReward Callback", Ret, InteractTriggerId)
    if ErrorCode:Check(Ret) then
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, nil, self, false)
    end
  end
  
  self:CallServer("GetInteractTriggerReward", Callback, InteractTriggerId)
end

function Component:CheckInteractTriggerRewardIsGot(InteractTriggerId)
  if self.InteractTriggerRewardRecords and self.InteractTriggerRewardRecords[InteractTriggerId] then
    return true
  end
  return false
end

return Component
