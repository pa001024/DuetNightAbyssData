require("UnLua")
local JJGameModel = require("BluePrints.UI.WBP.ActivityJJGame.JJGameModel")
local JJGameController = require("BluePrints.UI.WBP.ActivityJJGame.JJGameController")
local NormalTaskNewReddotName = JJGameModel.NormalTaskNewReddotName
local NormalTaskBPPath = "/Game/UI/WBP/Activity/Widget/JJGame/Normal/WBP_Activity_JJGame_NormalSubItem.WBP_Activity_JJGame_NormalSubItem"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.MidTermConst = DataMgr.MidTermGoalConstant
  self.MidTermGoalEventId = self.MidTermConst.MidTermGoalEventId.ConstantValue
  self.List_Task:SetAllowOverscroll(false)
  self.List_Task:DisAbleScroll(true)
  self.List_Task.BP_OnEntryInitialized:Add(self, self.OnListTaskEntryInitialized)
end

function M:Destruct()
  if self.HasNewTask then
    self:TryClearNormalTaskNewReddot()
  end
end

function M:Init(TaskConfig)
  self.TaskConfig = TaskConfig
  self.Owner = TaskConfig.Owner
  self.JJGameBase = self.Owner.Owner
  self.EventDay = TaskConfig.EventDay
  self.YesterdayRewardGot = TaskConfig.YesterdayRewardGot
  self.Text_Title:SetText(GText(TaskConfig.Name))
  self._Avatar = GWorld:GetAvatar()
  self:UpdateTaskList()
  self:UpdateNormalTaskTabNewReddot()
end

function M:UpdateNormalTaskTabNewReddot()
  if not self.Owner then
    return
  end
  if self.HasNewTask then
    self.Owner.Owner.Com_Tab:ShowTabRedDot(1, true)
  else
    self.Owner.Owner.Com_Tab:ShowTabRedDot(1, false)
  end
end

function M:UpdateTaskList()
  self.List_Task:ClearListItems()
  self.TaskContentList = {}
  local Model = JJGameController:RefreshModel()
  self.MidTermGoals = Model.MidTermGoals
  local Entries = Model:BuildNormalTaskEntries(self.TaskConfig.TaskType, self.EventDay, self.YesterdayRewardGot)
  for _, Entry in ipairs(Entries) do
    local TaskItem = self:NewItemContent(Entry.TaskType, Entry.Id, Entry.Point, Entry.Desc)
    TaskItem.TaskProp = Entry.TaskProp
    TaskItem.TaskConfig = Entry.TaskConfig
    table.insert(self.TaskContentList, TaskItem)
    self.List_Task:AddItem(TaskItem)
  end
  self.List_Task:RequestPlayEntriesAnim()
  self:TryIncreaceNormalTaskNewReddot()
end

function M:OnListTaskEntryInitialized()
  if self.TaskConfig.Name == "UI_Event_MidTerm_DailyTask" then
    local FirstItem = self.List_Task:GetItemAt(0)
    if FirstItem and FirstItem.SelfWidget and IsValid(FirstItem.SelfWidget) then
      FirstItem.SelfWidget:SetFocus()
    else
      self.List_Task:SetFocus()
    end
  end
end

function M:SortTaskList(TaskList)
  return JJGameController:RefreshModel():GetSortedTaskList(TaskList)
end

function M:TryIncreaceNormalTaskNewReddot()
  self.HasNewTask = false
  local Model = JJGameController:RefreshModel()
  if TimeUtils.NowTime() > Model.EventEndTime then
    return
  end
  for _, TaskItem in pairs(self.TaskContentList) do
    JJGameController:TryIncreaseNormalTaskNewReddot(TaskItem.TaskProp.UniqueID)
    local CacheData = ReddotManager.GetLeafNodeCacheDetail(NormalTaskNewReddotName)
    if CacheData and CacheData[TaskItem.TaskProp.UniqueID] == true then
      self.HasNewTask = true
    end
  end
end

function M:TryClearNormalTaskNewReddot()
  JJGameController:ClearNormalTaskNewReddot(false)
  self.HasNewTask = false
end

function M:NewItemContent(TaskType, TaskId, TaskPoint, TaskDes)
  local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
  ItemContent.Owner = self
  ItemContent.TaskType = TaskType
  ItemContent.Id = TaskId
  ItemContent.Point = TaskPoint
  ItemContent.Desc = TaskDes
  ItemContent.YesterdayRewardGot = self.YesterdayRewardGot
  return ItemContent
end

function M:OnAchvFinished(TaskId)
  if not self.TaskContentList then
    return
  end
  for _, TaskItem in pairs(self.TaskContentList) do
    if TaskItem.SelfWidget and IsValid(TaskItem.SelfWidget) and TaskItem.SelfWidget.OnAchvFinished then
      TaskItem.SelfWidget:OnAchvFinished(TaskId)
    end
  end
end

function M:OnMidTermTaskProgressChange(TaskId, Progress)
  if not self.TaskContentList then
    return
  end
  for _, TaskItem in pairs(self.TaskContentList) do
    if TaskItem.SelfWidget and IsValid(TaskItem.SelfWidget) and TaskItem.SelfWidget.OnMidTermTaskProgressChange then
      TaskItem.SelfWidget:OnMidTermTaskProgressChange(TaskId, Progress)
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:BP_GetDesiredFocusTarget()
end

return M
