require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Super.Construct(self)
  self.IsInViewMode = 0
  self.CurNum = 0
  self.MaxNum = 0
  self.Btn_Reward:BindEventOnClicked(self, self.GetAllRewards)
  self.Btn_Reward:BindEventOnClicked(self, self.PlayButtonClickSound)
  self.Btn_Reward:SetText(GText("UI_AppearanceScore_RewardGetAll"))
  self.Text_Progress:SetText(GText("UI_AppearanceScore_RewardTotalStatus"))
  self.Text_Progress:SetText(GText("UI_AppearanceScore_RewardTotalStatus"))
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
  end
  self:Init()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:AddInputMethodChangedListen()
  self:InitWidgetInfoInGamePad()
end

function M:Destruct()
  self:RemoveInputMethodChangedListen()
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self.Super.Destruct(self)
end

function M:AddInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RemoveInputMethodChangedListen()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
end

function M:Init()
  self:InitTable()
  self:PlayInAnim()
  self.FenghuaNum = 0
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self.FenghuaNum = Avatar.AppearanceScores.Total
  end
  self:InitList()
  self:InitProgress()
  self:InitArchiveReward()
end

function M:InitTable()
  self.TabConfigData = {
    TitleName = GText("UI_AppearanceScore_ScoreRewardTitle"),
    DynamicNode = {"Back", "BottomKey"},
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.OnClickBack,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
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
  self.Com_Tab:Init(self.TabConfigData)
end

function M:InitList()
  local Avatar = GWorld:GetAvatar()
  self.List_Task:ClearListItems()
  self.CurNum = 0
  self.MaxNum = 0
  local ContentTable = {}
  for Index, Info in ipairs(DataMgr.ScoreReward) do
    self.MaxNum = self.MaxNum + 1
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Owner = self
    Content.SortId = Info.SortId
    Content.RewardId = Info.RewardId
    Content.ScoreTarget = Info.ScoreTarget
    Content.ReceiveCallBackObj = self
    Content.ReceiveCallBackFunc = self.GetReward
    Content.RewardsGot = false
    Content.CanReceive = false
    Content.InProgress = true
    if Avatar and Avatar.AppearanceScoreRewards then
      if Avatar.AppearanceScoreRewards[Info.ScoreTarget] then
        Content.InProgress = false
        Content.CanReceive = false
        Content.RewardsGot = true
        self.CurNum = self.CurNum + 1
      elseif self.FenghuaNum >= Content.ScoreTarget then
        Content.RewardsGot = false
        Content.CanReceive = true
        Content.InProgress = false
        self.CurNum = self.CurNum + 1
      end
    end
    table.insert(ContentTable, Content)
  end
  table.sort(ContentTable, function(a, b)
    if a.CanReceive and not b.CanReceive then
      return true
    end
    if a.InProgress and b.RewardsGot then
      return true
    end
    if b.CanReceive and not a.CanReceive then
      return false
    end
    if b.InProgress and a.RewardsGot then
      return false
    end
    return a.SortId < b.SortId
  end)
  for Index, Content in ipairs(ContentTable) do
    Content.Index = Index
    self.List_Task:AddItem(Content)
  end
  self.List_Task:SetCurrentScrollOffset(0)
end

function M:InitProgress()
  self.Num_Progress_Now:SetText(self.CurNum)
  self.Num_Progress_Max:SetText(self.MaxNum)
  self.Progress_Main:SetPercent(self.CurNum / self.MaxNum)
  if self:CheckHaveRewardToGet() then
    self.Btn_Reward:ForbidBtn(false)
  else
    self.Btn_Reward:ForbidBtn(true)
  end
end

function M:CheckHaveRewardToGet()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  for Index, Info in ipairs(DataMgr.ScoreReward) do
    if (self.FenghuaNum or 0) >= Info.ScoreTarget and Avatar.AppearanceScoreRewards and not Avatar.AppearanceScoreRewards[Info.ScoreTarget] then
      return true
    end
  end
  return false
end

function M:InitArchiveReward()
  local SortId, ScoreTarget, MaxSortId, MaxScoreTarget
  for Index, Info in ipairs(DataMgr.ScoreReward) do
    if Info.ScoreTarget > self.FenghuaNum and Info.RewardView and (not ScoreTarget or ScoreTarget > Info.ScoreTarget) then
      SortId = Info.SortId
      ScoreTarget = Info.ScoreTarget
    end
    if Info.RewardView and (not MaxScoreTarget or MaxScoreTarget < Info.ScoreTarget) then
      MaxSortId = Info.SortId
      MaxScoreTarget = Info.ScoreTarget
    end
  end
  if not SortId then
    SortId = MaxSortId
    ScoreTarget = MaxScoreTarget
  end
  local Parame = {}
  if SortId then
    local Info = DataMgr.ScoreReward[SortId]
    Parame.Owner = self
    Parame.Title = GText(Info.CarouselTitle)
    Parame.Des = string.format(GText("UI_AppearanceScore_RewardDes"), Info.ScoreTarget)
    Parame.Icon = Info.CarouselContent
    Parame.IsHeadshot = Info.IsHeadshot
    Parame.RewardView = Info.RewardView
  end
  self.Archive_Reward:Init(Parame)
end

function M:GetReward(Content)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(Ret, RewardReturn)
      if not ErrorCode:Check(Ret) then
        return
      end
      self:InitList()
      self:InitProgress()
      self:InitArchiveReward()
      self:RefreshReddotInfo()
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
        self:NavigateToFirstDisplayedItem(self.List_Task)
      end, self)
    end
    
    Avatar:GetAppearanceScoreRewardRPC(Callback, Content.ScoreTarget)
  end
end

function M:GetAllRewards()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local function Callback(Ret, RewardReturn)
      if not ErrorCode:Check(Ret) then
        return
      end
      self:InitList()
      self:InitProgress()
      self:InitArchiveReward()
      self:RefreshReddotInfo()
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
        self:NavigateToFirstDisplayedItem(self.List_Task)
      end, self)
    end
    
    Avatar:GetAllAppearanceScoreRewardRPC(Callback)
  end
end

function M:RefreshRewardList()
  self:InitList()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      if 0 == self.IsInViewMode then
        IsEventHandled = true
        self.Btn_Reward:OnBtnClicked()
      end
    elseif InKeyName == UIConst.GamePadKey.SpecialRight then
      IsEventHandled = true
      self:SwitchSelectedMode()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      if 0 == self.IsInViewMode then
        IsEventHandled = true
        self:OnReturnKeyDown()
      else
        IsEventHandled = true
        self:SwitchSelectedMode()
      end
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnReturnKeyDown()
  UIUtils.PlayCommonBtnSe(self)
  self:OnClickBack()
end

function M:OnClickBack()
  if self:CheckIsCanCloseSelf() then
    self:PlayOutAnim()
  end
end

function M:PlayInAnim()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FenghuaRewardOpenSound", nil)
  AudioManager(self):PlayUISound(self, "event:/ui/common/skin_collecting_score_page_in", nil, nil)
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "FenghuaRewardOpenSound", {ToEnd = 1})
  if self.Out then
    self:PlayAnimationForward(self.Out)
  else
    self:Close()
  end
end

function M:Close()
  self.Super.Close(self)
end

function M:CheckIsCanCloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return false
  end
  return true
end

function M:NavigateToFirstDisplayedItem(List)
  local ItemUIs = List:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    local TargetWidget
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      local Index = Widget.Content.Index
      if Index and (not TargetWidget or Index < TargetWidget.Content.Index) then
        TargetWidget = Widget
      end
    end
    if TargetWidget then
      List:BP_NavigateToItem(TargetWidget.Content)
      return TargetWidget
    end
  end
  return List
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self:InitKeyBoardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  if self:HasAnyFocus() then
    self:NavigateToFirstDisplayedItem(self.List_Task)
  end
  self.Btn_Reward:SetGamePadIconVisible(true)
  if not self.Btn_Reward:IsBtnForbidden() then
    self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  self.Archive_Reward.List_Reward:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:InitKeyBoardView()
  self.IsInViewMode = 0
  self.Btn_Reward:SetGamePadIconVisible(false)
  if not self.Btn_Reward:IsBtnForbidden() then
    self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self.Archive_Reward.List_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitWidgetInfoInGamePad()
  self.Btn_Reward:SetGamePadImg("Y")
  if self.Archive_Reward.Key_GamePad then
    self.Archive_Reward.Key_GamePad:CreateGamepadKey("Menu")
  end
end

function M:SwitchSelectedMode()
  if 1 == self.IsInViewMode then
    self:UpdateBottomKeyInfo_Normal()
    self.Btn_Reward:SetGamePadIconVisible(true)
    self.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.Archive_Reward.List_Reward:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    self.IsInViewMode = 0
    self:SetFocus()
  elseif 0 == self.IsInViewMode then
    self:UpdateBottomKeyInfo_ViewMode()
    self.Btn_Reward:SetGamePadIconVisible(false)
    self.Archive_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Archive_Reward.List_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    self.IsInViewMode = 1
    self:FocusToRewardItem()
  end
end

function M:FocusToRewardItem()
  self.Archive_Reward.List_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
  local ItemUIs = self.Archive_Reward.List_Reward:GetDisplayedEntryWidgets()
  if ItemUIs:Length() > 0 then
    for i = 1, ItemUIs:Length() do
      local Widget = ItemUIs:GetRef(i)
      if Widget then
        self.Archive_Reward.List_Reward:SetSelectedIndex(i - 1)
        self.Archive_Reward.List_Reward:NavigateToIndex(i - 1)
        return Widget
      end
    end
  end
end

function M:BP_GetDesiredFocusTarget()
  self:NavigateToFirstDisplayedItem(self.List_Task)
  return self.List_Task
end

function M:ItemMenuAnchorChanged(IsOpen)
  if IsOpen then
    self:EnterCheckDetailMode()
  else
    self:LeaveCheckDetailMode()
  end
end

function M:EnterCheckDetailMode()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:UpdateBottomKeyInfo_Empty()
  end
end

function M:LeaveCheckDetailMode()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:UpdateBottomKeyInfo_ViewMode()
  end
end

function M:UpdateBottomKeyInfo_Empty()
  if self.Com_Tab.UpdateBottomKeyInfo then
    local BottomKeyInfo = {}
    self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function M:UpdateBottomKeyInfo_Normal()
  if self.Com_Tab.UpdateBottomKeyInfo then
    local BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
    self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function M:UpdateBottomKeyInfo_ViewMode()
  if self.Com_Tab.UpdateBottomKeyInfo then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Controller_CheckDetails"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
    self.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
  end
end

function M:RefreshReddotInfo()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if not ReddotManager.GetTreeNode("AppearanceFenghuaReward") then
      ReddotManager.AddNode("AppearanceFenghuaReward")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("AppearanceFenghuaReward")
    local DecreaseNum = 0
    for ScoreTarget, _ in pairs(CacheDetail) do
      if Avatar.AppearanceScoreRewards and Avatar.AppearanceScoreRewards[ScoreTarget] then
        CacheDetail[ScoreTarget] = nil
        DecreaseNum = DecreaseNum + 1
      end
    end
    if DecreaseNum > 0 then
      ReddotManager.DecreaseLeafNodeCount("AppearanceFenghuaReward", DecreaseNum)
    end
  end
end

function M:PlayButtonClickSound()
  AudioManager(self):PlayUISound(self, "event:/ui/common/battle_pass_btn_click_normal", nil, nil)
end

return M
