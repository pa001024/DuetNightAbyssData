require("UnLua")
local HyperWeaponUtils = require("Utils.HyperWeaponUtils")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/mozhixia_open", "IncarnonTaskOpen", nil)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.CloseSelf
  })
  self.Btn_Close:Init("Close", self, self.PlayOutAnimation)
  self.Text_SmeltLevel:SetText(GText("UI_HyperWeapon_CurrentForgeLevel"))
  self.Text_LevelTask:SetText(GText("UI_HyperWeapon_ForgeLevelTask"))
  self.Text_LevelReward:SetText(GText("UI_HyperWeapon_ForgeLevelReward"))
  self.Text_Hint:SetText(GText("UI_HyperWeapon_ForgeLevelRewardLocked"))
  self.Text_Hint_1:SetText(GText("UI_EventReward_Achieved"))
  self.Text_Empty:SetText(GText("UI_HyperWeapon_ForgeLevelTaskPhaseLock"))
  self.Btn_Left:BindEventOnClicked(self, function()
    if self.TargetLevel > 1 then
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "IncarnonTaskSwitch", nil)
      self:SwitchToTagetPage(self.TargetLevel - 1)
    end
  end)
  self.Btn_Right:BindEventOnClicked(self, function()
    if self.TargetLevel < self.MaxLevel then
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", "IncarnonTaskSwitch", nil)
      self:SwitchToTagetPage(self.TargetLevel + 1)
    end
  end)
  self.Btn_Reward:SetText(GText("UI_HyperWeapon_ClaimForgeLevelReward"))
  self.Btn_Reward:BindSingleEventOnClicked(self, self.OnForgeLevelRewardClidked)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    self.GameInputModeSubsystem = GameInputModeSubsystem
  end
  self.Key_Left:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LB"}
    }
  })
  self.Key_TitleRight:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "RB"}
    }
  })
  self.Key_Left:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Key_TitleRight:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Key_LevelReward:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    }
  })
  self.BottomKeyInfo = {
    GamePadInfo = {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    GamePadInfo2 = {
      {
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    KeyBoardInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            ImgShortPath = "Esc",
            Owner = self,
            ClickCallback = self.PlayOutAnimation
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  }
  self:ResetDynamicNode()
end

function M:Destruct()
  self:UnbindAllFromAnimationFinished(self.Out)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local Params = (...)
  self.Parent = Params and Params.Parent
  self.CallbackObj = Params and Params.CallbackObj
  self.CloseCallback = Params and Params.CloseCallback
  self.WeaponId = Params and Params.WeaponId
  self.Avatar = GWorld:GetAvatar()
  self:InitPage()
  self.WB_Task:GetChildAt(0):SetFocus()
end

function M:InitPage()
  self:InitForgeLevel()
  self:SwitchToTagetPage(self.TargetLevel)
  self:ResetDynamicNode()
end

function M:InitForgeLevel()
  self.CurLevel = self.Avatar.WeaponForgeLevel
  self.MaxLevel = HyperWeaponUtils.GetMaxForgeLevel(self.WeaponId)
  self.TargetLevel = math.clamp(self.CurLevel + 1, 1, self.MaxLevel)
  self.MaxCanSeeLevel = math.clamp(self.TargetLevel, 1, self.MaxLevel)
  self.Num_Level_Now:SetText(self.CurLevel)
  self.Num_Level_Max:SetText(self.MaxLevel)
end

function M:SwitchToTagetPage(Level)
  if not Level or type(Level) ~= "number" then
    return
  end
  if Level < 1 or Level > self.MaxLevel then
    return
  end
  self.TargetLevel = Level
  self.Btn_Left:ForbidBtn(self.TargetLevel <= 1)
  self.Btn_Right:ForbidBtn(self.TargetLevel >= self.MaxLevel)
  self:UpdateLeftAndRightIcon()
  if self.LastLevel and self.LastLevel ~= self.TargetLevel then
    if self.LastLevel < self.TargetLevel then
      self:PlayAnimation(self.Card_Switch_Right)
    else
      self:PlayAnimation(self.Card_Switch_Left)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/mozhixia_page_change", nil, nil)
    self:AddTimer(0.2, function()
      self:RefreshAllInfo()
    end)
  else
    self:RefreshAllInfo()
  end
  self.LastLevel = self.TargetLevel
end

function M:RefreshAllInfo()
  self:RefreshLevelInfo()
  self:RefreshProgressBar()
  self:RefreshRewardItems()
  self:RefreshRewardBtnState()
  if self.TargetLevel <= self.MaxCanSeeLevel then
    self.WS_Task:SetActiveWidgetIndex(0)
    self:RefreshTaskItems()
    if UIUtils.IsGamepadInput() then
      self.WB_Task:GetChildAt(0):SetFocus()
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1.0)
    end
  else
    self.WS_Task:SetActiveWidgetIndex(1)
    if UIUtils.IsGamepadInput() then
      self.Panel_Empty:SetFocus()
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0.0)
    end
  end
  self:RefreshReddotInfo()
end

function M:RefreshLevelInfo()
  self.Num_Level:SetText(self.TargetLevel)
  local RewardText = string.format(GText("UI_HyperWeapon_ForgeLevelRewardDes"), self.TargetLevel)
  self.Text_Reward:SetText(RewardText)
end

function M:RefreshProgressBar()
  local TargetLevel = self.TargetLevel
  local ForgeInfo = DataMgr.ForgeLevel[TargetLevel]
  local TotalTaskCount = ForgeInfo and #ForgeInfo.ForgeLevelQuestId or 0
  local CurrentTaskCount = 0
  for _, QuestId in pairs(ForgeInfo.ForgeLevelQuestId or {}) do
    local ServerTaskInfo = self.Avatar.WeaponForgeQuests[QuestId]
    if ServerTaskInfo and ServerTaskInfo:IsComplete() then
      CurrentTaskCount = CurrentTaskCount + 1
    end
  end
  local Progress = TotalTaskCount > 0 and CurrentTaskCount / TotalTaskCount or 0
  local DynamicMaterial = self.Progress_Task:GetDynamicMaterial()
  DynamicMaterial:SetScalarParameterValue("Percent", Progress)
end

function M:RefreshRewardBtnState()
  local ForgeInfo = DataMgr.ForgeLevel[self.TargetLevel]
  if not ForgeInfo then
    return
  end
  local AllQuestDone = true
  local AllQuestRewardGot = true
  for _, QuestId in pairs(ForgeInfo.ForgeLevelQuestId or {}) do
    local ServerTaskInfo = self.Avatar.WeaponForgeQuests[QuestId]
    if not ServerTaskInfo then
      AllQuestRewardGot = false
      AllQuestDone = false
      break
    end
    if not ServerTaskInfo:IsComplete() then
      AllQuestDone = false
    end
    if not ServerTaskInfo.RewardsGot then
      AllQuestRewardGot = false
    end
  end
  if not AllQuestDone then
    self.WS_State:SetActiveWidgetIndex(0)
    return
  end
  if not AllQuestRewardGot then
    self.WS_State:SetActiveWidgetIndex(0)
    return
  end
  if self:HasForgeLevelRewardGot() then
    self.WS_State:SetActiveWidgetIndex(2)
    return
  end
  self.WS_State:SetActiveWidgetIndex(1)
end

function M:HasForgeLevelRewardGot()
  local ServerRewerdGot = self.Avatar.WeaponForgeLevelRewardGot
  return ServerRewerdGot and ServerRewerdGot[self.TargetLevel]
end

function M:RefreshRewardItems()
  local ForgeInfo = DataMgr.ForgeLevel[self.TargetLevel]
  if not ForgeInfo then
    return
  end
  local RewarId = ForgeInfo.ForgeLevelReward
  local Rewards = RewardUtils:GetRewards(RewarId, self.Avatar)
  local RewardList = ActivityCommon.GenerateAllRewardIds(Rewards)
  local HasLevelRewardGot = self:HasForgeLevelRewardGot()
  local Contents = {}
  for _, Value in pairs(RewardList) do
    local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.UnitId = ItemId
    Content.Count = ItemInfo.ItemCount or 0
    Content.Rarity = ItemInfo.Rarity or 1
    Content.IsShowDetails = true
    Content.ItemType = ItemInfo.TableName
    Content.Icon = ItemUtils.GetItemIconPath(ItemId, ItemInfo.TableName)
    Content.RewardGot = HasLevelRewardGot
    Content.UIName = "ArmoryIncarnonDetail"
    Content.OnMenuOpenChangedEvents = {
      Obj = self,
      Callback = self.OnMenuOpenChanged
    }
    table.insert(Contents, Content)
  end
  local Panel = self.WB_Item
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for i, Content in pairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:Init(Content)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    local Widget = Panel:GetChildAt(i)
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshTaskItems()
  local ForgeInfo = DataMgr.ForgeLevel[self.TargetLevel]
  if not ForgeInfo then
    return
  end
  
  local function GetSortWeight(Content)
    if Content.IsEmpty then
      return 0
    end
    local Quest = self.Avatar.WeaponForgeQuests[Content.QuestId]
    if not Quest then
      return 1
    end
    if Quest:IsComplete() then
      return Quest.RewardsGot and 1 or 3
    else
      return 2
    end
  end
  
  local Contents = {}
  local Quests = ForgeInfo.ForgeLevelQuestId or {}
  local QuestCount = #Quests
  QuestCount = math.max(QuestCount, 4)
  for i = 1, QuestCount do
    local Content = {}
    local QuestId = Quests[i]
    Content.Parent = self
    Content.QuestId = QuestId or 0
    Content.IsEmpty = not QuestId
    Content.SortWeight = GetSortWeight(Content)
    table.insert(Contents, Content)
  end
  table.sort(Contents, function(ContentA, ContentB)
    if ContentA.SortWeight ~= ContentB.SortWeight then
      return ContentA.SortWeight > ContentB.SortWeight
    end
    return ContentA.QuestId < ContentB.QuestId
  end)
  self.TaskWidgets = {}
  local Panel = self.WB_Task
  local WidgetCount = 0
  local Widget = Panel:GetChildAt(0)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  for _, Content in pairs(Contents) do
    Widget = Panel:GetChildAt(WidgetCount)
    if not Widget then
      Widget = UIManager(self):CreateWidget(WidgetClass)
      Panel:AddChild(Widget)
    end
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
    Widget:InitContent(Content)
    table.insert(self.TaskWidgets, Widget)
    WidgetCount = WidgetCount + 1
  end
  local Start, End = WidgetCount, Panel:GetChildrenCount() - 1
  for i = Start, End do
    local Widget = Panel:GetChildAt(i)
    Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  for Index = 0, WidgetCount - 1 do
    Widget = Panel:GetChildAt(Index)
    self:InitNavigation(Widget, Index, WidgetCount)
  end
end

function M:RefreshReddotInfo()
  local CurLevel = self.TargetLevel
  local ShowLeft, ShowRight = false, false
  for i = 1, self.MaxCanSeeLevel do
    local HasAnyForgeRewards = HyperWeaponUtils.HasAnyForgeRewards(i)
    if i < CurLevel then
      if not ShowLeft then
        ShowLeft = HasAnyForgeRewards
      end
    elseif i > CurLevel and not ShowRight then
      ShowRight = HasAnyForgeRewards
    end
    if ShowLeft and ShowRight then
      break
    end
  end
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  self.Reddot_Left:SetVisibility(ShowLeft and Visible or Collapsed)
  self.Reddot_Right:SetVisibility(ShowRight and Visible or Collapsed)
end

function M:OnForgeLevelRewardClidked()
  local function Callback(Ret, Rewards)
    self:BlockAllUIInput(false)
    
    if not ErrorCode:Check(Ret) then
      return
    end
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Rewards, nil, self, true)
    self.bIsInItemChooseState = false
    self:InitPage()
  end
  
  self:BlockAllUIInput(true)
  self.Avatar:WeaponForgeLevelUp(Callback)
end

function M:PopUpRewardPanel()
  local ForgeInfo = DataMgr.ForgeLevel[self.TargetLevel]
  if not ForgeInfo then
    return
  end
  local RewardId = ForgeInfo.ForgeLevelReward
  local Rewards = RewardUtils:GetRewards(RewardId, self.Avatar)
  local RewardList = ActivityCommon.GenerateAllRewardIds(Rewards)
  local AllRewards = {}
  for _, Value in pairs(RewardList) do
    local ItemId, ItemInfo = Value.ItemId, Value.ItemInfo
    if not AllRewards[ItemInfo.TableName] then
      AllRewards[ItemInfo.TableName] = {}
    end
    AllRewards[ItemInfo.TableName][ItemId] = ItemInfo.ItemCount or 0
  end
  UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, AllRewards, nil, self, true)
end

function M:PlayOutAnimation()
  self:PlayAnimation(self.Out)
  if self.CloseCallback then
    self.CloseCallback(self.CallbackObj)
  end
  AudioManager(self):SetEventSoundParam(self, "IncarnonTaskOpen", {ToEnd = 1})
end

function M:CloseSelf()
  if self.Parent then
    self.Parent:SetFocus()
  end
  self.Super.Close(self)
end

function M:BP_GetDesiredFocusTarget()
  if UIUtils.IsGamepadInput() then
    local Widget = self.WB_Task:GetChildAt(0)
    return Widget
  else
    return self
  end
end

function M:ResetDynamicNode()
  if UIUtils.IsMobileInput() then
    return
  end
  local BottomKeyInfo
  if UIUtils.IsGamepadInput() then
    if self.bIsInItemChooseState then
      BottomKeyInfo = self.BottomKeyInfo.GamePadInfo
    else
      BottomKeyInfo = self.BottomKeyInfo.GamePadInfo2
    end
  elseif UIUtils.IsKeyboardInput() then
    BottomKeyInfo = self.BottomKeyInfo.KeyBoardInfo
  end
  self.HB_Key:ClearChildren()
  self.ComKeys = {}
  for i, KeyInfo in ipairs(BottomKeyInfo) do
    DebugPrint("Yihan@ ResetDynamicNode", i, KeyInfo)
    local KeyWidget = UIManager(self):_CreateWidgetNew("ComKeyTextDesc")
    self.HB_Key:AddChild(KeyWidget)
    table.insert(self.ComKeys, KeyWidget)
    if #KeyInfo.KeyInfoList > 1 then
      KeyWidget:CreateSubKeyDesc(KeyInfo)
    else
      KeyWidget:CreateCommonKey(KeyInfo)
    end
  end
  self.HB_Key:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  elseif "Escape" == InKeyName and not self:IsAnimationPlaying(self.Out) then
    self:PlayOutAnimation()
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  DebugPrint("Yihan@ Handle_KeyDownOnGamePad", InKeyName)
  if InKeyName == UIConst.GamePadKey.LeftShoulder then
    if self.TargetLevel > 1 then
      self:SwitchToTagetPage(self.TargetLevel - 1)
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.RightShoulder then
    if self.TargetLevel < self.MaxLevel then
      self:SwitchToTagetPage(self.TargetLevel + 1)
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    return self:OnReturnKeyDown()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    if 1 == self.WS_State:GetActiveWidgetIndex() then
      self:OnForgeLevelRewardClidked()
    end
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    self.WB_Item:GetChildAt(0):SetFocus()
    self.bIsInItemChooseState = true
    self.WS_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Right:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_LevelReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1.0)
    self:ResetDynamicNode()
    return true
  end
  return false
end

function M:OnReturnKeyDown()
  if self.bIsInItemChooseState then
    self.bIsInItemChooseState = false
    self.Key_LevelReward:SetVisibility(UIConst.VisibilityOp.Visible)
    self:UpdateLeftAndRightIcon()
    self:ResetDynamicNode()
    self:NavigateToFirstTask()
    return true
  end
  if not self:IsAnimationPlaying(self.Out) then
    self:PlayOutAnimation()
  end
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1.0)
  return true
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  DebugPrint("Yihan@ RefreshOpInfoByInputDevice", CurInputDevice)
  if CurInputDevice == ECommonInputType.Gamepad then
    self.Btn_Reward:SetGamePadImg("Y")
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
  self:UpdateLeftAndRightIcon()
  self:ResetDynamicNode()
end

function M:InitGamepadView()
  self.WS_Left:SetActiveWidgetIndex(1)
  self.WS_Right:SetActiveWidgetIndex(1)
  self.Key_LevelReward:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Btn_Reward:SetGamePadIconVisible(true)
end

function M:InitKeyboardView()
  self.WS_Left:SetActiveWidgetIndex(0)
  self.WS_Right:SetActiveWidgetIndex(0)
  self.Key_LevelReward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Reward:SetGamePadIconVisible(false)
end

function M:UpdateLeftAndRightIcon()
  if not UIUtils.IsGamepadInput() then
    self.WS_Left:SetVisibility(UIConst.VisibilityOp.Visible)
    self.WS_Right:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    if 1 == self.TargetLevel then
      self.WS_Left:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.WS_Left:SetVisibility(UIConst.VisibilityOp.Visible)
    end
    if self.TargetLevel == self.MaxLevel then
      self.WS_Right:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.WS_Right:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

function M:InitNavigation(Widget, Index, WidgetCount)
  local Panel = self.WB_Task
  Widget:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function(_self)
      if Index - 1 >= 0 then
        local NextWidget = Panel:GetChildAt(Index - 1)
        if not NextWidget.Content.IsEmpty then
          return NextWidget
        else
          return EUINavigationRule.Stop
        end
      end
    end
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Right, {
    self,
    function(_self)
      if Index + 1 <= WidgetCount then
        local NextWidget = Panel:GetChildAt(Index + 1)
        if not NextWidget.Content.IsEmpty then
          return NextWidget
        else
          return EUINavigationRule.Stop
        end
      end
    end
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Up, {
    self,
    function(_self)
      if Index - 2 >= 0 then
        local NextWidget = Panel:GetChildAt(Index - 2)
        if not NextWidget.Content.IsEmpty then
          return NextWidget
        else
          return EUINavigationRule.Stop
        end
      end
    end
  })
  Widget:SetNavigationRuleCustom(EUINavigation.Down, {
    self,
    function(_self)
      if Index + 2 <= WidgetCount then
        local NextWidget = Panel:GetChildAt(Index + 2)
        if not NextWidget.Content.IsEmpty then
          return NextWidget
        else
          return EUINavigationRule.Stop
        end
      end
    end
  })
end

function M:NavigateToFirstTask()
  local Widget = self.WB_Task:GetChildAt(0)
  if self.TargetLevel <= self.MaxCanSeeLevel then
    Widget:SetFocus()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1.0)
  else
    self.Panel_Empty:SetFocus()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0.0)
  end
end

function M:OnMenuOpenChanged(IsOpen)
  if IsOpen and UIUtils.IsGamepadInput() then
    self.HB_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.HB_Key:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

return M
