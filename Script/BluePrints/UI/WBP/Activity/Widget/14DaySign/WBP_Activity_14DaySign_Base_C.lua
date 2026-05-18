require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityCommon = require("BluePrints.UI.WBP.Activity.ActivityCommon")
local DEFAULT_TITLE_BP = "/Game/UI/WBP/Activity/Widget/14DaySign/WBP_Activity_14DaySign_Title.WBP_Activity_14DaySign_Title"
local DEFAULT_ITEMS_BP = "/Game/UI/WBP/Activity/Widget/14DaySign/WBP_Activity_14DaySign_Items.WBP_Activity_14DaySign_Items"
local DEFAULT_SUBTITLE_BP = "/Game/UI/WBP/Activity/Widget/14DaySign/WBP_Activity_14DaySign_SubTitleItem.WBP_Activity_14DaySign_SubTitleItem"
local EnumPlayerSignRewardState = ActivityUtils.EnumPlayerSignRewardState
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})

local function SafeBindClick(Widget, Obj, Func)
  if not Widget or not Func then
    return
  end
  if Widget.UnBindEventOnClicked and Widget.BindEventOnClicked then
    Widget:UnBindEventOnClicked(Obj, Func)
    Widget:BindEventOnClicked(Obj, Func)
    return
  end
  if Widget.OnClicked then
    Widget.OnClicked:Clear()
    Widget.OnClicked:Add(Obj, Func)
    return
  end
  if Widget.Button_Area and Widget.Button_Area.OnClicked then
    Widget.Button_Area.OnClicked:Clear()
    Widget.Button_Area.OnClicked:Add(Obj, Func)
  end
end

local function NormalizeBigRewardConfig(BigRewardDays)
  local Result = {}
  for _, Value in pairs(BigRewardDays or {}) do
    if type(Value) == "table" then
      local Day = Value.Day or Value.RewardDay or Value.Index
      local BigRewardId = Value.BigRewardId or Value.KeyId or Value.Id
      if not Day or not BigRewardId then
        for Key, InnerValue in pairs(Value) do
          if type(Key) == "number" and type(InnerValue) == "number" then
            Day = Key
            BigRewardId = InnerValue
            break
          end
        end
      end
      if Day and BigRewardId then
        Result[Day] = BigRewardId
      end
    end
  end
  return Result
end

function M:Initialize(Initializer)
  self.OwnerPlayer = nil
  self.CurActivityId = nil
  self.ParentTabId = nil
  self.ParentWidget = nil
  self.ActivityConfigData = nil
  self.PageConfigData = nil
  self.ActivityTitle = nil
  self.BigRewardInfos = {}
  self.BigRewardDayMap = {}
  self.AllSignInfo = {}
  self.CurrentBigRewardIndex = nil
  self.bBlockInputDuringIntro = false
  self.PendingBigRewardIconPath = nil
  self.FinishCondition = nil
  self.IsComplete = false
end

function M:GetPageName()
  return DataMgr.EventTab[self.ParentTabId].EventTabName
end

function M:GetActivityId()
  return self.CurActivityId
end

function M:GetParentTabId()
  return self.ParentTabId
end

function M:ResetVariable()
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
end

function M:InitPage(ActivityId, ParentTabId, AllActivityId, ParentWidget)
  self.CurActivityId = ActivityId
  self.ParentTabId = ParentTabId
  self.ParentWidget = ParentWidget
  self.ActivityConfigData = DataMgr.EventMain[self.CurActivityId]
  self.PageConfigData = DataMgr.DailyLogin[self.CurActivityId]
  if not self.ActivityConfigData or not self.PageConfigData then
    return
  end
  self.ActivityEndTime = self.ActivityConfigData.EventEndTime or self.ActivityConfigData.PermanenEventTime
  self.RewardEndTime = self.ActivityConfigData.RewardEndTime
  self.FinishCondition = self.ActivityConfigData.EventEndCondition
  self.BigRewardDayMap = NormalizeBigRewardConfig(self.PageConfigData.BigRewardDays)
  self:CollectAllSignInfo()
  self:RefreshPageStaticView()
  self:RefreshPageDynamicView(true)
  if self.SignItemsWidget and self.SignItemsWidget.ScrollToProgressReward then
    self.SignItemsWidget:ScrollToProgressReward(self.AllSignInfo)
  end
end

function M:CollectAllSignInfo()
  self.AllSignInfo = {}
  local PlayerAvatar = GWorld:GetAvatar()
  local DailyLoginServerData = PlayerAvatar and PlayerAvatar.DailyLogin[self.CurActivityId]
  for Index = 1, self.PageConfigData and self.PageConfigData.LoginDuration or 0 do
    self.AllSignInfo[Index] = ActivityUtils.GetCurSignRewardState(Index, DailyLoginServerData)
  end
end

function M:RefreshCompleteState()
  local Avatar = GWorld:GetAvatar()
  self.IsComplete = Avatar and self.FinishCondition and ConditionUtils.CheckCondition(Avatar, self.FinishCondition) or false
end

function M:InitTimeInfo()
  local TimeWidget = self.Activity_Time and self.Activity_Time.Com_Time
  if (self.ActivityEndTime ~= nil or nil ~= self.RewardEndTime or self.IsComplete) and TimeWidget then
    local bCheckNextDayFiveStamp = true
    ActivityUtils.RefreshLeftTime(self, TimeWidget, bCheckNextDayFiveStamp)
    self:AddTimer(1.0, ActivityUtils.RefreshLeftTime, true, 0, "RefreshLeftTime", true, TimeWidget, bCheckNextDayFiveStamp)
  elseif self.Activity_Time and self.Activity_Time.Com_Time then
    ActivityUtils.SetLeftTimeView(self.Activity_Time.Com_Time, true)
  end
end

function M:PlayFadeIn()
  if self.In then
    self.bBlockInputDuringIntro = true
    self:UnbindAllFromAnimationFinished(self.In)
    self:BindToAnimationFinished(self.In, {
      self,
      self.OnFadeInFinished
    })
    self:PlayAnimation(self.In)
  elseif self.Loop then
    self.bBlockInputDuringIntro = false
    self:PlayAnimation(self.Loop, 0, 0)
  else
    self.bBlockInputDuringIntro = false
  end
  if self.ActivityTitle and self.ActivityTitle.In then
    self.ActivityTitle:PlayAnimationForward(self.ActivityTitle.In)
  end
end

function M:OnFadeInFinished()
  self:UnbindAllFromAnimationFinished(self.In)
  self.bBlockInputDuringIntro = false
  if self.Loop then
    self:PlayAnimation(self.Loop, 0, 0)
  end
end

function M:StopLoopAnimation()
  if self.Loop and self.StopAnimation then
    self:StopAnimation(self.Loop)
  end
end

function M:PlayFadeOut(IsRemoveFromParent)
  self:StopLoopAnimation()
  if self.Out then
    self:PlayAnimation(self.Out)
    if IsRemoveFromParent then
      self:BindToAnimationFinished(self.Out, {
        self,
        self.RemoveFromParent
      })
    end
  elseif IsRemoveFromParent then
    self:RemoveFromParent()
  end
end

function M:HidePage(IsNeedPlayOutAnim)
  if IsNeedPlayOutAnim then
    self:PlayFadeOut()
  else
    self:StopLoopAnimation()
  end
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowPage(IsNeedPlayInAnim)
  if IsNeedPlayInAnim then
    self:PlayFadeIn()
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:IsPageInVisible()
  return self:IsVisible()
end

function M:IsInputBlockedDuringIntro()
  return self.bBlockInputDuringIntro == true
end

function M:RefreshPageStaticView()
  self:InitTitleWidget()
  self:InitItemsWidget()
  self:InitSubTitleWidget()
  if self.Text_Desc then
    self.Text_Desc:SetText(GText(self.ActivityConfigData.EventDes or ""))
  end
  if self.Text_Desc_White then
    self.Text_Desc_White:SetText(GText(self.ActivityConfigData.EventDes or ""))
  end
  if self.SignItemsWidget and self.SignItemsWidget.InitRewardInfo then
    self.SignItemsWidget:InitRewardInfo(self.PageConfigData, self, self.AllSignInfo, self.BigRewardDayMap)
  end
  if self.SubTitleWidget and self.SubTitleWidget.InitOwner then
    self.SubTitleWidget:InitOwner(self)
  end
  if self.Btn_Left then
    self.Btn_Left:BindEventOnClicked(self, self.OnClickLeftBigReward)
  end
  if self.Key_Left then
    self.Key_Left:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LT"}
      }
    })
  end
  if self.Btn_Right then
    self.Btn_Right:BindEventOnClicked(self, self.OnClickRightBigReward)
  end
  if self.Key_Right then
    self.Key_Right:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RT"}
      }
    })
  end
  if self.Btn_Reward and self.Btn_Reward.Btn_TrainingLevelGetAll and self.Btn_Reward.Text_TrainingLevelGetAll then
    self.Btn_Reward.Btn_TrainingLevelGetAll.OnClicked:Clear()
    self.Btn_Reward.Btn_TrainingLevelGetAll.OnClicked:Add(self, self.OnClickGetAllReward)
    self.Btn_Reward.Text_TrainingLevelGetAll:SetText(GText("UI_Mail_Recieveall"))
    if self.Btn_Reward.Key_GetAll then
      self.Btn_Reward.Key_GetAll:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Y"}
        }
      })
    end
  else
    SafeBindClick(self.Btn_Reward, self, self.OnClickGetAllReward)
  end
  if self.ActivityTitle and self.ActivityTitle.Activity_Time then
    SafeBindClick(self.ActivityTitle.Activity_Time.Btn_Detail, self, self.ViewInfoBtnClick)
  end
  if self.Com_BtnExplanation then
    self.Com_BtnExplanation:Init({
      ClickCallback = self.ViewInfoBtnClick,
      OwnerWidget = self,
      Desc = "UI_Common_Rule",
      SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
      end
    })
  end
  if self.Group_ActivityQa then
    local HasEventRule = self.ActivityConfigData and self.ActivityConfigData.EventRule
    self.Group_ActivityQa:SetVisibility(HasEventRule and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitTitleWidget()
  local TitleBP = self.ActivityConfigData.EventNameBPPath or DEFAULT_TITLE_BP
  if self.Title then
    self.Title:ClearChildren()
    self.ActivityTitle = UIManager(self):CreateWidget(TitleBP)
    self.Title:AddChildToOverlay(self.ActivityTitle)
  end
  if not self.ActivityTitle then
    return
  end
  if self.ActivityTitle.Text_Title then
    self.ActivityTitle.Text_Title:SetText(GText(self.ActivityConfigData.EventName or ""))
  end
  ActivityUtils.SetUpJustifyOfJap(self.ActivityTitle.Text_ActivityDesc, self.ActivityTitle.Text_ActivityDesc_White)
end

function M:InitItemsWidget()
  local ItemsBP = self.PageConfigData and self.PageConfigData.RewardBannerBP or DEFAULT_ITEMS_BP
  if self.Group_ItemAnchor then
    self.Group_ItemAnchor:ClearChildren()
    self.SignItemsWidget = UIManager(self):CreateWidget(ItemsBP)
    if self.SignItemsWidget then
      local Slot = self.Group_ItemAnchor:AddChildToOverlay(self.SignItemsWidget)
      if Slot then
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      end
    end
  else
    self.SignItemsWidget = self.WBP_Activity_14DaySign_Items or self.SignItemsWidget
  end
end

function M:InitSubTitleWidget()
  local SubTitleBP = self.PageConfigData and self.PageConfigData.BigRewardBP or DEFAULT_SUBTITLE_BP
  if self.Group_SubTitleAnchor then
    self.Group_SubTitleAnchor:ClearChildren()
    self.SubTitleWidget = UIManager(self):CreateWidget(SubTitleBP)
    if self.SubTitleWidget then
      local Slot = self.Group_SubTitleAnchor:AddChildToOverlay(self.SubTitleWidget)
      if Slot then
        Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
        Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      end
    end
  else
    self.SubTitleWidget = self.WBP_Activity_14DaySign_SubTitleItem or self.SubTitleWidget
  end
end

function M:BuildBigRewardInfos()
  self.BigRewardInfos = {}
  for Day, BigRewardId in pairs(self.BigRewardDayMap or {}) do
    local BigRewardConfig = DataMgr.LoginBigReward[BigRewardId]
    local RewardId = self.PageConfigData.EventReward and self.PageConfigData.EventReward[Day]
    local RewardState = self.AllSignInfo[Day] or EnumPlayerSignRewardState.NotSign
    local Info = {
      Day = Day,
      BigRewardId = BigRewardId,
      RewardId = RewardId,
      RewardState = RewardState,
      RewardType = BigRewardConfig and BigRewardConfig.RewardType or nil,
      DetailId = BigRewardConfig and BigRewardConfig.DetailId or nil,
      RewardBigIcon = BigRewardConfig and BigRewardConfig.RewardBigIcon or nil
    }
    if self.SubTitleWidget and self.SubTitleWidget.BuildDisplayInfo then
      self.SubTitleWidget:BuildDisplayInfo(Info)
    end
    table.insert(self.BigRewardInfos, Info)
  end
  table.sort(self.BigRewardInfos, function(A, B)
    return A.Day < B.Day
  end)
end

function M:GetDefaultBigRewardIndex()
  local LastIndex
  for Index, Info in ipairs(self.BigRewardInfos) do
    LastIndex = Index
    if Info.RewardState ~= EnumPlayerSignRewardState.Completed then
      return Index
    end
  end
  return LastIndex or 1
end

function M:RefreshPageDynamicView(IsForceRefresh, KeepCurrentBigReward)
  self:RefreshCompleteState()
  self:InitTimeInfo()
  if self.SignItemsWidget and self.SignItemsWidget.RefreshRewardStates then
    self.SignItemsWidget:RefreshRewardStates(self.PageConfigData, self, self.AllSignInfo, self.BigRewardDayMap)
  end
  self:BuildBigRewardInfos()
  local TargetIndex = self:GetDefaultBigRewardIndex()
  if KeepCurrentBigReward and self.CurrentBigRewardIndex and #self.BigRewardInfos > 0 then
    TargetIndex = math.max(1, math.min(self.CurrentBigRewardIndex, #self.BigRewardInfos))
  end
  self:SetBigRewardPreview(TargetIndex, nil, IsForceRefresh)
  self:RefreshGetAllRewardState()
  for _, State in pairs(self.AllSignInfo or {}) do
    if State == EnumPlayerSignRewardState.SignedNotRecv then
      ActivityUtils.TryAddActivityReddotCommon("Red", self.CurActivityId)
      break
    end
  end
end

function M:SetBigRewardPreview(TargetIndex, Direction, IsForceRefresh)
  if #self.BigRewardInfos <= 0 then
    return
  end
  TargetIndex = math.max(1, math.min(TargetIndex or 1, #self.BigRewardInfos))
  local OldIndex = self.CurrentBigRewardIndex or TargetIndex
  self.CurrentBigRewardIndex = TargetIndex
  local Info = self.BigRewardInfos[TargetIndex]
  if not Info then
    return
  end
  self.PendingBigRewardIconPath = Info.RewardBigIcon
  if self.SubTitleWidget and self.SubTitleWidget.RefreshWithData then
    self.SubTitleWidget:RefreshWithData(Info, Direction, UIUtils.IsGamepadInput())
  end
  if IsForceRefresh or not Direction then
    self:Change_Icon()
  end
  if not IsForceRefresh then
    if "Left" == Direction and self.Change_L then
      self:PlayAnimation(self.Change_L)
    elseif "Right" == Direction and self.Change_R then
      self:PlayAnimation(self.Change_R)
    elseif OldIndex ~= TargetIndex and self.Change_R then
      self:PlayAnimation(self.Change_R)
    end
  end
  self:RefreshArrowState()
end

function M:Change_Icon()
  if not self.Image_Icon or not self.PendingBigRewardIconPath then
    return
  end
  local Icon = LoadObject(self.PendingBigRewardIconPath)
  if Icon then
    self.Image_Icon:SetBrushResourceObject(Icon)
  end
end

function M:Play_Name_In()
  if self.SubTitleWidget and self.SubTitleWidget.WBP_Activity_14DaySign_SubTitleItem_In then
    self.SubTitleWidget:WBP_Activity_14DaySign_SubTitleItem_In()
  end
end

function M:RefreshArrowState()
  local IsSingle = #self.BigRewardInfos <= 1
  local CanClickLeft = not IsSingle and self.CurrentBigRewardIndex > 1
  local CanClickRight = not IsSingle and self.CurrentBigRewardIndex < #self.BigRewardInfos
  local ShowGamePadKey = UIUtils.IsGamepadInput()
  if self.Btn_Left then
    if self.Btn_Left.ForbidBtn then
      self.Btn_Left:ForbidBtn(not CanClickLeft)
    end
    self.Btn_Left:SetVisibility(CanClickLeft and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Key_Left then
    self.Key_Left:SetVisibility(ShowGamePadKey and CanClickLeft and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Right then
    if self.Btn_Right.ForbidBtn then
      self.Btn_Right:ForbidBtn(not CanClickRight)
    end
    self.Btn_Right:SetVisibility(CanClickRight and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Key_Right then
    self.Key_Right:SetVisibility(ShowGamePadKey and CanClickRight and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:UpdatePage(OperateSrc)
  local IsRefreshCacheServerData = OperateSrc == ActivityCommon.AllUpdateTag.ActivityTab
  local KeepCurrentBigReward = "BackToPageWithJump" == OperateSrc
  if IsRefreshCacheServerData then
    self:CollectAllSignInfo()
  end
  self:ResetVariable()
  self:RefreshPageDynamicView(true, KeepCurrentBigReward)
  if self.SignItemsWidget and self.SignItemsWidget.ScrollToProgressReward then
    self.SignItemsWidget:ScrollToProgressReward(self.AllSignInfo)
  end
end

function M:GetPageConfigData()
  return DataMgr.DailyLogin[self.CurActivityId]
end

function M:RefreshItemStyleByAction(ActionName, EventId, RewardIndex)
  if "SignGetReward" ~= ActionName or EventId ~= self.CurActivityId then
    return
  end
  local PlayerAvatar = GWorld:GetAvatar()
  local DailyLoginServerData = PlayerAvatar and PlayerAvatar.DailyLogin[EventId]
  self.AllSignInfo[RewardIndex] = ActivityUtils.GetCurSignRewardState(RewardIndex, DailyLoginServerData)
  if self.SignItemsWidget and self.SignItemsWidget.RefreshItemStyle then
    self.SignItemsWidget:RefreshItemStyle(RewardIndex, self.AllSignInfo[RewardIndex])
  end
  local OldIndex = self.CurrentBigRewardIndex or 1
  self:BuildBigRewardInfos()
  local NewIndex = self:GetDefaultBigRewardIndex()
  local Direction
  if OldIndex > NewIndex then
    Direction = "Left"
  elseif OldIndex < NewIndex then
    Direction = "Right"
  end
  self:SetBigRewardPreview(NewIndex, Direction, false)
  self:RefreshGetAllRewardState()
  self:RefreshCompleteState()
  self:InitTimeInfo()
end

function M:CleanSelf(bIsRemoveSelf)
  self:StopLoopAnimation()
  self:RemoveTimer("RefreshLeftTime")
  if bIsRemoveSelf then
    self:RemoveFromParent()
  end
end

function M:GetCurFocusWidgetInfo()
  return self.FocusWidgetName, self.FocusWidgetWidget
end

function M:IsCanChangeToGamePadViewMode()
  return true
end

function M:OnUpdateSubUIViewStyle(IsUseGamePad, bIsWithButton)
  IsUseGamePad = IsUseGamePad and self:IsCanChangeToGamePadViewMode()
  if self.Com_BtnExplanation then
    self.Com_BtnExplanation:UpdateUIStyleInPlatform(IsUseGamePad)
  end
  if self.Btn_Reward and self.Btn_Reward.Key_GetAll then
    self.Btn_Reward.Key_GetAll:SetVisibility(IsUseGamePad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.SubTitleWidget and self.SubTitleWidget.RefreshInputStyle then
    self.SubTitleWidget:RefreshInputStyle(IsUseGamePad)
  end
  if self.SignItemsWidget and self.SignItemsWidget.RefreshInputStyle then
    self.SignItemsWidget:RefreshInputStyle(IsUseGamePad)
  end
  if not IsUseGamePad then
    local CanGetAnyReward = false
    for _, RewardState in pairs(self.AllSignInfo or {}) do
      if RewardState == EnumPlayerSignRewardState.SignedNotRecv then
        CanGetAnyReward = true
        break
      end
    end
    if CanGetAnyReward then
      self:UpdateParentActivityKeyTips("GetAllReward", nil, true)
    else
      self:UpdateParentActivityKeyTips(nil, nil, true)
    end
  end
  self:RefreshArrowState()
end

function M:EnterRewardViewMode()
  self:UpdateParentActivityKeyTips("ACheckRewardView", self.SignItemsWidget)
  if self.SignItemsWidget then
    self.SignItemsWidget:SetFocus()
    return true
  end
  return false
end

function M:LeaveRewardViewMode()
  if self.FocusWidgetWidget == nil then
    return false
  end
  self.FocusWidgetName = nil
  self.FocusWidgetWidget = nil
  if self.UpdateParentActivityKeyTips then
    self:UpdateParentActivityKeyTips("CheckRewardView", nil, true)
  end
  self:OnUpdateSubUIViewStyle(true, true)
  self.IsInStuffViewMode = false
  return true
end

function M:UpdateParentActivityKeyTips(FocusWidgetName, FocusWidgetWidget, bIsFocusToParent)
  self.FocusWidgetName = FocusWidgetName
  self.FocusWidgetWidget = FocusWidgetWidget
  if self.ParentWidget then
    self.ParentWidget:UpdateActivityKeyTips(FocusWidgetName, FocusWidgetWidget)
    if bIsFocusToParent then
      self.ParentWidget:SetFocus()
    end
  end
end

function M:GetDefaultBottomTips()
  return {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckReward")
    },
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Close")
    }
  }
end

function M:ViewInfoBtnClick()
  if not self.ActivityConfigData or not self.ActivityConfigData.EventRule then
    DebugPrint("ViewInfoBtn Click, EventRule is nil, EventId is", self.CurActivityId)
    return
  end
  UIManager(self):ShowCommonPopupUI(100192, {
    ShortText = GText(self.ActivityConfigData.EventRule)
  }, self)
end

function M:CanOpenPreviewByGamePad()
  return self.SubTitleWidget and self.SubTitleWidget.CanOpenPreview and self.SubTitleWidget:CanOpenPreview()
end

function M:TryOpenPreviewByGamePad()
  if not self:CanOpenPreviewByGamePad() then
    return false
  end
  self.SubTitleWidget:OpenPreview()
  return true
end

function M:CanSwitchBigRewardByInput()
  return not self.SubTitleWidget or not self.SubTitleWidget.CanSwitchBigReward or not not self.SubTitleWidget:CanSwitchBigReward()
end

function M:CanOpenActivityRuleByGamePad()
  return self.ActivityConfigData and self.ActivityConfigData.EventRule and self.Com_BtnExplanation and self.Com_BtnExplanation:IsVisible()
end

function M:RefreshGetAllRewardState()
  if not self.Btn_Reward then
    return
  end
  local CanGetAnyReward = false
  for _, RewardState in pairs(self.AllSignInfo or {}) do
    if RewardState == EnumPlayerSignRewardState.SignedNotRecv then
      CanGetAnyReward = true
      break
    end
  end
  local ReceiveBtn = self.Btn_Reward.Btn_TrainingLevelGetAll or self.Btn_Reward
  if ReceiveBtn and ReceiveBtn.SetForbidden then
    ReceiveBtn:SetForbidden(not CanGetAnyReward)
  elseif ReceiveBtn and ReceiveBtn.ForbidBtn then
    ReceiveBtn:ForbidBtn(not CanGetAnyReward)
  end
  if self.Btn_Reward.Key_GetAll then
    self.Btn_Reward.Key_GetAll:SetVisibility(UIUtils.IsGamepadInput() and CanGetAnyReward and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
  end
  self.Btn_Reward:SetVisibility(CanGetAnyReward and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if self.UpdateParentActivityKeyTips and UIUtils.IsKeyboardInput() then
    if CanGetAnyReward then
      self:UpdateParentActivityKeyTips("GetAllReward")
    else
      self:UpdateParentActivityKeyTips()
    end
  end
end

function M:OnClickGetAllReward()
  local PlayerAvatar = GWorld:GetAvatar()
  if not PlayerAvatar then
    return
  end
  local CanGetAnyReward = false
  for _, RewardState in pairs(self.AllSignInfo or {}) do
    if RewardState == EnumPlayerSignRewardState.SignedNotRecv then
      CanGetAnyReward = true
      break
    end
  end
  if not CanGetAnyReward then
    return
  end
  
  local function Callback(Ret, Rewards)
    if Ret == ErrorCode.RET_SUCCESS then
      UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Rewards, false, function()
        self:CollectAllSignInfo()
        self:RefreshPageDynamicView(true)
      end, nil, nil)
      ActivityUtils.TrySubActivityReddotCommon("Red", self.CurActivityId)
    end
  end
  
  AudioManager(self):PlayUISound(self, "event:/ui/activity/confirm_click", nil, nil)
  PlayerAvatar:DailyLoginGetRewardAuto(self.CurActivityId, Callback, self.CurActivityId)
end

function M:OnSpaceBarKeyDown()
  if self:IsInputBlockedDuringIntro() then
    return
  end
  self:OnClickGetAllReward()
end

function M:OnClickLeftBigReward()
  if self:IsInputBlockedDuringIntro() then
    return
  end
  if not self:CanSwitchBigRewardByInput() then
    return
  end
  if not self.CurrentBigRewardIndex or self.CurrentBigRewardIndex <= 1 then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
  self:SetBigRewardPreview(self.CurrentBigRewardIndex - 1, "Left", false)
end

function M:OnClickRightBigReward()
  if self:IsInputBlockedDuringIntro() then
    return
  end
  if not self:CanSwitchBigRewardByInput() then
    return
  end
  if not self.CurrentBigRewardIndex or self.CurrentBigRewardIndex >= #self.BigRewardInfos then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", nil, nil)
  self:SetBigRewardPreview(self.CurrentBigRewardIndex + 1, "Right", false)
end

function M:HandleKeyDownInPage(MyGeometry, InKeyEvent)
  if self:IsInputBlockedDuringIntro() then
    return false
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return self:OnGamePadButtonDown(InKeyName)
  end
  return false
end

function M:OnGamePadButtonDown(InKeyName)
  return self:Handle_KeyDownOnGamePad(InKeyName)
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  if self:IsInputBlockedDuringIntro() then
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    return self:LeaveRewardViewMode()
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    return self:EnterRewardViewMode()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnClickGetAllReward()
    return true
  end
  if InKeyName == UIConst.GamePadKey.SpecialLeft then
    return self:TryOpenPreviewByGamePad()
  end
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    if self:CanOpenActivityRuleByGamePad() then
      self:ViewInfoBtnClick()
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold then
    if self.CurrentBigRewardIndex and self.CurrentBigRewardIndex > 1 then
      self:OnClickLeftBigReward()
      return true
    end
    return false
  end
  if InKeyName == UIConst.GamePadKey.RightTriggerThreshold then
    if self.CurrentBigRewardIndex and self.CurrentBigRewardIndex < #self.BigRewardInfos then
      self:OnClickRightBigReward()
      return true
    end
    return false
  end
  return false
end

function M:HandlePreviewKeyDownInPage(MyGeometry, InKeyEvent)
  if self:IsInputBlockedDuringIntro() then
    return false
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "SpaceBar" == InKeyName then
    self:OnSpaceBarKeyDown()
    return true
  end
  return false
end

function M:OnSubTabNavigationRight()
end

return M
