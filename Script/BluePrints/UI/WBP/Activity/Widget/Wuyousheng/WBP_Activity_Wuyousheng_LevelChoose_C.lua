require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Btn_Start.Btn_Click.OnClicked:Add(self, self.BtnStartOnClicked)
  self:InitLevelList()
  self:RefreshLevelInfo(self.DungeonList[1])
  self.Root.SelectedDungeonId = self.DungeonList[1]
end

function M:BtnStartOnClicked()
  self.Root:OpenSubUI({
    Idx = "ActivityWuyoushengTeamBuild"
  }, self.Root.SelectedDungeonId)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_Special_Right" == InKeyName then
      if not self.CurDungeonPanel.Btn_Enemy.IsPressing then
        self.CurDungeonPanel.Btn_Enemy:OnBtnPressed()
      end
    elseif "Gamepad_Special_Left" == InKeyName then
      if not self.CurDungeonPanel.Btn_Entry.IsPressing then
        self.CurDungeonPanel.Btn_Entry:OnBtnPressed()
      end
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      self:OnReturnKeyDown()
    elseif "Gamepad_FaceButton_Top" == InKeyName then
      if self.Reward and not self.Reward.IsPressing then
        self.Reward:OnBtnPressed()
      end
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      self.BtnStart:OnBtnPressed()
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      if self.Panel_Reset:IsVisible() then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
        self:ShowResetConfirmWindow()
      end
    else
      IsHandled = false
    end
  elseif "Escape" == InKeyName then
    self:OnReturnKeyDown()
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnReturnKeyDown()
  self.Root:OpenSubUI(self.PreWidgetInfo, false, self.AbyssId, true)
end

function M:SwitchIn(...)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:InitTable()
end

function M:SwitchOut()
  if not self.BindOutAnimation then
    self:BindToAnimationFinished(self.Next, {
      self,
      function()
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    })
    self.BindOutAnimation = true
  end
  self:PlayAnimation(self.Next)
end

function M:InitTable()
  self.TabConfigData = {
    TitleName = GText("UI_Title_WuyoushengEvent"),
    DynamicNode = {
      "Back",
      "BottomKey",
      "ResourceBar"
    },
    StyleName = "Text",
    OwnerPanel = self.Root,
    BackCallback = self.Root.OnReturnKeyDown,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  }
  self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:InitLevelList()
  if not self.Root or not self.Root.EventId then
    return
  end
  local EventId = self.Root.EventId
  self.DungeonList = {}
  for DungeonId, Conf in pairs(DataMgr.WuyoushengEventLevel) do
    if Conf.EventId == EventId then
      table.insert(self.DungeonList, DungeonId)
    end
  end
  table.sort(self.DungeonList, function(a, b)
    return a < b
  end)
  if self.List_LevelTab then
    self.List_LevelTab:ClearListItems()
  end
  for i = 1, #self.DungeonList, 2 do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    Content.DungeonId1 = self.DungeonList[i]
    Content.DungeonId2 = self.DungeonList[i + 1]
    self.List_LevelTab:AddItem(Content)
  end
end

function M:RefreshLevelInfo(DungeonId)
  local WuyoushengEventLevelData = DataMgr.WuyoushengEventLevel[DungeonId]
  if not WuyoushengEventLevelData then
    return
  end
  self.Text_Title:SetText(GText(WuyoushengEventLevelData.LevelName))
  self.Text_Desc:SetText(GText(WuyoushengEventLevelData.LevelDes))
  self.Text_LevelEffectDesc:SetText(GText(WuyoushengEventLevelData.LevelBuffDes))
  self.Text_GoalTitle:SetText(GText("UI_WuyoushengEvent_LevelTarget"))
  self.Text_LevelEffectTitle:SetText(GText("UI_WuyoushengEvent_LevelBuff"))
  self.Text_MonsterDetailTitle:SetText(GText("UI_WuyoushengEvent_PetDetail"))
  for i = 1, 3 do
    local GoalData = self["GoalStarItem_" .. i]
    local LevelGoalRequiredTime1 = WuyoushengEventLevelData.LevelGoalRequiredTime1[i]
    local GoalText
    if -1 == LevelGoalRequiredTime1 then
      GoalText = GText("Wuyousheng_Target_FinishLevel")
    else
      GoalText = string.format(GText("Wuyousheng_Target_LevelLimitTime"), LevelGoalRequiredTime1)
    end
    GoalData.Text_GoalDesc:SetText(GoalText)
  end
  self.MonsterList:ClearChildren()
  local PetCount = 0
  for i = 1, #WuyoushengEventLevelData.LevelPet do
    local PetId = WuyoushengEventLevelData.LevelPet[i]
    local Widget = self:CreateWidgetNew("ComItemUniversalM")
    local PetData = DataMgr.Pet[PetId]
    if PetData then
      local Content = {
        Id = PetId,
        ItemType = "Pet",
        Rarity = PetData.Rarity,
        Icon = PetData.Icon,
        IsShowDetails = true
      }
      Widget:Init(Content)
      self.MonsterList:AddChildToWrapBox(Widget)
      PetCount = PetCount + 1
    end
  end
  local ItemsPerRow = 5
  local EmptyCount = (ItemsPerRow - PetCount % ItemsPerRow) % ItemsPerRow
  if EmptyCount > 0 then
    for i = 1, EmptyCount do
      local EmptyWidget = self:CreateWidgetNew("ComItemUniversalM")
      local EmptyContent = {bEmpty = true}
      EmptyWidget:Init(EmptyContent)
      self.MonsterList:AddChildToWrapBox(EmptyWidget)
    end
  end
end

return M
