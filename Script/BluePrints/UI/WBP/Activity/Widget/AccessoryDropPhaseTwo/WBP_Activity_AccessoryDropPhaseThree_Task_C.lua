require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self:InitView()
  self:SetDefaultFocus()
  self.SelectTaskItem = nil
  self.List_Task:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_Close.btn_return.OnClicked:Add(self, self.OnCloseSelf)
  self.Btn_Close.btn_close.OnClicked:Add(self, self.OnCloseSelf)
  self.Text_Title:SetText(GText("Event_FreeAppearance2_GetCoin"))
  self.Text_Tip:SetText(GText("Event_FreeAppearance2_GetCoinDes"))
  self.Controller_1:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_CheckReward")
  })
  self.Controller_2:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_Controller_Close")
  })
end

function M:RefreshBottonKey()
  if not (self.SelectTaskItem and self.SelectTaskItem.SelfWidget) or self.SelectTaskItem.SelfWidget.FocusItem then
    self.Controller_1:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
    self.Controller_2:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
  else
    self.Controller_1:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckReward")
    })
    self.Controller_2:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_Controller_Close")
    })
  end
end

function M:InitView()
  self.EventId = 10302004
  local ActivityConfigData = DataMgr.EventMain[self.EventId]
  self.ActivityConfigData = ActivityConfigData
  self.CurActivityId = ActivityConfigData.EventId
  self.PageConfigData = DataMgr.EventPortal[self.EventId]
  local IsRefresh = false
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    local RedDotName = DataMgr.EventMain[self.EventId].ReddotNode
    ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {
      CacheKey = "Red",
      EventId = self.EventId
    })
    return 0
  end
  self.List_Task.BP_OnItemSelectionChanged:Add(self, self.OnTaskSelectItemChanged)
  self.List_Task.BP_OnItemClicked:Add(self, self.OnTaskItemClicked)
  self:ShowListTask()
  self:RefreshBottonKey()
end

function M:ShowListTask()
  self.List_Task:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  local FinshQuests = {}
  local GuildTasks = Avatar.CommonQuestActivity[self.EventId]
  if not GuildTasks then
    return
  end
  self.SelectTaskItem = next(GuildTasks)
  for QuestId, QuestCounter in pairs(GuildTasks or {}) do
    local ItemObject = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObject.Index = 1
    ItemObject.QuestId = QuestCounter.UniqueID
    ItemObject.Parent = self
    ItemObject.Progress = QuestCounter.Progress
    ItemObject.Target = QuestCounter.Target
    ItemObject.RewardsGot = QuestCounter.RewardsGot
    if QuestCounter.Progress >= QuestCounter.Target then
      table.insert(FinshQuests, ItemObject)
    else
      self.List_Task:AddItem(ItemObject)
    end
  end
  for Index, FinshQuest in pairs(FinshQuests or {}) do
    self.List_Task:AddItem(FinshQuest)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandle = false
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:OnCloseSelf()
  elseif "Escape" == InKeyName then
    self:OnCloseSelf()
  end
  if IsHandle then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:OnUpdateUIStyleByInputTypeChange(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad then
    self:SetDefaultFocus()
    self.WBox_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Controller_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Controller_2:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.WBox_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Controller_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Controller_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnTaskItemClicked(SelectItem)
  if UIUtils.IsGamepadInput() and self.SelectTaskItem and self.SelectTaskItem.SelfWidget then
    self.SelectTaskItem.SelfWidget:GoToSystem()
  end
end

function M:OnTaskSelectItemChanged(SelectItem)
  if self.SelectTaskItem and self.SelectTaskItem.SelfWidget then
    self.SelectTaskItem.SelfWidget:SetGoGamepadIconVisible(false)
  end
  self.SelectTaskItem = SelectItem
  if self.SelectTaskItem and self.SelectTaskItem.SelfWidget then
    self.SelectTaskItem.SelfWidget:SetGoGamepadIconVisible(true)
  end
end

function M:SetDefaultFocus()
  self.List_Task:SetFocus()
end

function M:OnFocusReceived()
  self.List_Task:SetFocus()
end

function M:OnCloseSelf()
  self:Close()
end

return M
