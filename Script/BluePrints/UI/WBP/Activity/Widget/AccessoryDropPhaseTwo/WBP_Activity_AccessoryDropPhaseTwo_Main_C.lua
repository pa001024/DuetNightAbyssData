require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnPressESC()
  self:Close()
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  self:SetDefaultFocus()
end

function M:Construct()
  self.List_Task = self.TaskList.ListTask
  self:InitView()
  self:SetDefaultFocus()
  self.SelectTaskItem = nil
  self.List_Task:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Task:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:Destruct()
  self:RemoveTimer("UpdateTime")
end

function M:RefreshUI()
  self:InitView(self.ActivityConfigData, self.PageConfigData, true)
end

function M:InitView()
  self.EventId = 10302002
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
  self.AccessDropConfig = self:GetAccessDropConfig()
  local AccessoryDrop = Avatar.AccessoryDrops[self.EventId]
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  self.TaskTitle.TextTitle:SetText(GText("Event_FreeAppearance2_GetCoin"))
  self.TaskTitle.TextTips:SetText(GText("Event_FreeAppearance2_GetCoinDes"))
  self.GachaNum.Text_Num:SetText(GText(tostring(AccessoryDrop.CurDropBoxNum)))
  self.GachaNum.Text_Total:SetText(GText(tostring(self.AccessDropConfig.BoxMaximum)))
  if AccessoryDrop.CurDropBoxNum == self.AccessDropConfig.BoxMaximum then
    self.GachaNum.Max.Text_Max:SetText(GText(tostring("Event_FreeAppearance_tips03")))
    self.GachaNum.Max:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.GachaNum.Text_x:SetColorAndOpacity(self.GachaNum.Color_Max)
    self.GachaNum.Text_Num:SetColorAndOpacity(self.GachaNum.Color_Max)
    if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips05"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  else
    self.GachaNum.Max:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.GachaNum.Text_x:SetColorAndOpacity(self.GachaNum.Color_Normal)
    self.GachaNum.Text_Num:SetColorAndOpacity(self.GachaNum.Color_Normal)
    if 0 ~= AccessoryDrop.CurDropBoxNum then
      if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
        self.Tips.Text_Tips01:SetText("")
        self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
        self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      else
        self.Tips.Text_Tips01:SetText("")
        self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Tips.Time:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
        self.Tips.Text_Tips02:SetText(string.format(GText("Event_FreeAppearance_tips04"), self.AccessDropConfig.BoxPerDay))
        self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      end
    elseif nextAddDropBoxNumTime > ActivityConfigData.EventEndTime then
      self.Tips.Text_Tips01:SetText("")
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips08"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    else
      self.Tips.Text_Tips01:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Tips.Time:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self.Tips.Text_Tips02:SetText(GText("Event_FreeAppearance_tips07"))
      self.Tips.Text_Tips02:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
    self:UpdateTime()
  end
  self.Btn_Open:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  self.Btn_Open.Icon_Coin.ItemDetails_MenuAnchor:SetLastFocusWidget(self.Btn_Open)
  self.Btn_Shop:InitView(self.AccessDropConfig, AccessoryDrop, IsRefresh)
  if not IsRefresh then
    self.Btn_Open:SetOpenFunc({
      Func = self.OpenBox,
      Obj = self
    })
    self:PlayAnimation(self.In)
    self.BG:PlayAnimationIn()
    self:AddTimer(1.0, self.UpdateTime, true, 0, "UpdateTime", true)
  end
  self.List_Task.BP_OnItemSelectionChanged:Add(self, self.OnTaskSelectItemChanged)
  self.List_Task.BP_OnItemClicked:Add(self, self.OnTaskItemClicked)
  self.List_Task.BP_OnEntryInitialized:Add(self, self.OnEntryInitialized)
  self:ShowListTask()
  self:InitTab()
end

function M:UpdateTime()
  local AccessoryDrop = GWorld:GetAvatar().AccessoryDrops[self.EventId]
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  self.nextAddDropBoxNumTime = nextAddDropBoxNumTime
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(nextAddDropBoxNumTime, TimeUtils.NowTime())
  self.Tips.Time:SetTimeText("", RemainTimeDict)
  self.Btn_Shop:UpdateTime()
end

function M:GetAccessDropConfig()
  return DataMgr.BoxDrop[self.EventId]
end

function M:OpenBox()
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  local CallbackInfo = {
    Func = function(_Self, Rewards)
      local RedDotName = DataMgr.EventMain[self.EventId].ReddotNode
      ReddotManager.DecreaseLeafNodeCount(RedDotName, 1, {
        CacheKey = "Red",
        EventId = self.EventId
      })
      self.BG:PlayOpenAnim(Rewards, {
        Func = self.PlayAnimationOpenCallback,
        Obj = self
      }, {
        Func = self.OpenRewardViewCallback,
        Obj = self
      })
      AudioManager(self):PlayUISound(self, "event:/ui/activity/fengrao02_box_open", nil, nil)
    end,
    Obj = self
  }
  self.Bg:PlayAnimation(self.Open)
  GWorld:GetAvatar():OpenAccesorryBox(CallbackInfo)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/fengrao02_click", nil, nil)
end

function M:OpenRewardViewCallback()
  self:BlockAllUIInput(false)
end

function M:PlayAnimationOpenCallback()
  self:PlayAnimation(self.Change)
  self:RefreshUI()
  self:SetDefaultFocus()
end

function M:ShowResourceInfo()
  if 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
    return self.Btn_Open:OnResourceClick()
  end
  return false
end

function M:OnEntryInitialized(SelectItem)
  local CommonQuestConfig = DataMgr.CommonQuestDetail[SelectItem.QuestId]
  if SelectItem.RewardsGot then
  else
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

function M:ShowListTask()
  self.List_Task:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  local GuildTasks = Avatar.CommonQuestActivity[self.EventId]
  self.SelectTaskItem = next(GuildTasks)
  for QuestId, QuestCounter in pairs(GuildTasks or {}) do
    local ItemObject = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObject.Index = 1
    ItemObject.QuestId = QuestCounter.UniqueID
    ItemObject.Parent = self
    ItemObject.Progress = QuestCounter.Progress
    ItemObject.Target = QuestCounter.Target
    ItemObject.RewardsGot = QuestCounter.RewardsGot
    self.List_Task:AddItem(ItemObject)
  end
end

function M:InitTab()
  local TitleName = GText("Event_Title_103020")
  local ResourceId = DataMgr.BoxDrop[self.EventId].BoxCoinId
  local BoxCoin = GWorld:GetAvatar().Resources[ResourceId]
  if UIUtils.IsPCInput() then
    self.WBP_Com_Tab_P:Init({
      DynamicNode = {
        "Back",
        "ResourceBar",
        "BottomKey"
      },
      OverridenTopResouces = {ResourceId},
      TitleName = TitleName,
      StyleName = "Text",
      OwnerPanel = self,
      LastFocusWidget = self.List_Task,
      BackCallback = self.OnPressESC,
      BottomKeyInfo = {
        {
          KeyInfoList = {
            {
              Type = "Text",
              Text = "Esc",
              ClickCallback = self.OnPressESC,
              Owner = self
            }
          },
          GamePadInfoList = {
            {
              Type = "Img",
              ImgShortPath = "B",
              ClickCallback = self.OnPressESC,
              Owner = self
            }
          },
          Desc = GText("UI_BACK")
        }
      }
    })
  elseif UIUtils.IsMobileInput() then
    self.WBP_Com_Tab_M:Init({
      DynamicNode = {
        "Back",
        "ResourceBar"
      },
      OverridenTopResouces = {ResourceId},
      TitleName = TitleName,
      StyleName = "Text",
      OwnerPanel = self,
      LastFocusWidget = self.List_Task,
      BackCallback = self.OnPressESC
    })
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandle = false
  if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.Btn_Shop:GoToShopClick()
    IsHandle = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:Close()
    IsHandle = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if not self.OnStuffDetailOpen and 0 == self.Btn_Open.WS_Type:GetActiveWidgetIndex() then
      self.Btn_Open:OnClicked()
      IsHandle = true
    end
  elseif InKeyName == UIConst.GamePadKey.DPadRight then
    IsHandle = self:ShowResourceInfo()
  elseif "Escape" == InKeyName then
    self:Close()
    IsHandle = true
  elseif InKeyName == UIConst.GamePadKey.RightThumb then
    local IsEventHandled = self.WBP_Com_Tab_P:Handle_KeyEventOnGamePad(InKeyName) or false
    if IsEventHandled then
      IsHandle = true
    end
  end
  if IsHandle then
    return UIUtils.Handled
  else
    return UIUtils.Unhandled
  end
end

function M:OnUpdateUIStyleByInputTypeChange(NewGameInputType, NewGamepadName)
  self.Btn_Open:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad then
    self.Btn_Open:SetFocus()
    self:SetDefaultFocus()
    local len = self.List_Task:GetNumItems()
    for index = 0, len - 1 do
      local Item = self.List_Task:GetItemAt(index)
      if Item and Item.SelfWidget then
        if Item == self.SelectTaskItem then
          Item.SelfWidget:SetGoGamepadIconVisible(true)
        else
          Item.SelfWidget:SetGoGamepadIconVisible(false)
        end
      end
    end
  else
    local len = self.List_Task:GetNumItems()
    for index = 0, len - 1 do
      local Item = self.List_Task:GetItemAt(index)
      if Item and Item.SelfWidget then
        Item.SelfWidget:SetGoGamepadIconVisible(false)
      end
    end
  end
end

function M:SetDefaultFocus()
  self.List_Task:SetFocus()
end

function M:OnFocusReceived()
  self.List_Task:SetFocus()
end

return M
