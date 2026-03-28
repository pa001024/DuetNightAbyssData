require("UnLua")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local CameraGameUtils = require("BluePrints.UI.WBP.Activity.PC.CameraGame.CameraGameUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self:InitCommonTab()
  self.Btn_Photo.OnClicked:Add(self, self.OnRewardAndPhotoButtonClicked)
  self.Avatar = GWorld:GetAvatar()
  self.QCS = CommonConst.QuestChainState
  self.EventId = CameraGameUtils.GetEventId()
  self.ReddotType = CameraGameUtils.ReddotType
  self.ReddotNodeName = ActivityReddotHelper.GetEventMainNodeName(self.EventId)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Param1, Param2)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Param1, Param2)
  if Param2 and Param2[1] then
    local Index = tonumber(Param2[1]) or 1
    self.ListView_Left:NavigateToIndex(Index - 1)
  end
  CameraGameUtils.RefreshReddot(self.EventId)
  self:InitPhotoProgress()
  self:InitPhotoList()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_sub_page_in", nil, nil)
  self:AddReddotListen()
end

function M:Destruct()
  self:RemoveReddotListen()
  M.Super.Destruct(self)
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:PlayAnimation(self.Out)
  local PreviousUI = UIManager():GetUnderState()
  if PreviousUI then
    local PreviousUIName = PreviousUI:GetName()
    if "ActivityMain" == PreviousUIName then
      EventManager:FireEvent(EventID.OnReturnToActivityEntry)
      EventManager:FireEvent(EventID.OnActivityEntryShowVisible)
    end
  end
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  end
end

function M:AddReddotListen()
  ActivityReddotHelper.AddReddotListenByEventId(self.EventId, {
    Obj = self,
    Func = function(self, Count, RdType, RdName)
      local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNodeName)
      if not CacheDetail then
        return
      end
      for _, Content in pairs(self.PhotoItemContents) do
        Content.ReddotType = CacheDetail[Content.QuestChainId] or self.ReddotType.NONE
        if Content.SelfWidget then
          Content.SelfWidget:UpdateReddot()
        end
      end
    end
  })
end

function M:RemoveReddotListen()
  ActivityReddotHelper.RemoveReddotListenByEventId(self.EventId, self)
end

function M:InitCommonTab()
  self.Tab:Init(self.TabConfigData, true)
end

function M:InitPhotoProgress()
  self.Text_Title:SetText(GText("UI_PhotoEvent_Progress"))
  local CurCount, TotalCount = CameraGameUtils.GetPhotoProgress()
  self.Text_TitleNum01:SetText(CurCount)
  self.Text_TitleNum02:SetText("/" .. TotalCount)
end

function M:InitPhotoList()
  local function GetSortWeight(Content)
    if Content.QuestState == self.QCS.finish then
      return Content.RewardGot and 1 or 4
    elseif Content.QuestState == self.QCS.unlock or Content.QuestState == self.QCS.doing then
      return 3
    end
    return 1
  end
  
  self.ListView_Left:ClearListItems()
  self:CreatePhotoContent()
  self.PhotoItemContents = self.PhotoItemContents or {}
  local SelectedIndex = 0
  local SelectedWeight = 1
  for Index, Content in pairs(self.PhotoItemContents) do
    Content.Index = Index
    local Weight = GetSortWeight(Content)
    if SelectedWeight < Weight then
      SelectedIndex = Index - 1
      SelectedWeight = Weight
    end
    self.ListView_Left:AddItem(Content)
  end
  self.PhotoItemCount = #self.PhotoItemContents
  self.ListView_Left:NavigateToIndex(SelectedIndex)
  self.ListView_Left.BP_OnItemClicked:Clear()
  self.ListView_Left.BP_OnItemClicked:Add(self, self.OnPhotoItemClicked)
  self.ListView_Left.BP_OnItemIsHoveredChanged:Clear()
  self.ListView_Left.BP_OnItemIsHoveredChanged:Add(self, self.OnPhotoItemIsHoveredChanged)
end

function M:CreatePhotoContent()
  if not self.Avatar then
    return
  end
  
  local function GetReddotType(QuestChainId)
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(self.ReddotNodeName)
    if not CacheDetail then
      return self.ReddotType.NONE
    end
    return CacheDetail[QuestChainId]
  end
  
  self.PhotoItemContents = {}
  for _, Data in pairs(DataMgr.PhotoEvent[self.EventId] or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    Content.Index = Data.PhotoTaskId
    Content.PhotoTaskId = Data.PhotoTaskId
    Content.QuestChainId = Data.QuestChain
    Content.PhotoPath = Data.PhotoView
    Content.RewardId = Data.RewardView
    Content.RewardGot = self.Avatar.PhotoActRewardGot[Data.QuestChain]
    Content.ReddotType = GetReddotType(Data.QuestChain)
    Content.TextTitle = Data.Content1
    Content.TextContent = Data.Content2
    local QuestChain = self.Avatar.QuestChains[Data.QuestChain]
    Content.QuestState = QuestChain and QuestChain.State or self.QCS.lock
    Content.UnlockTime = Data.StartTime and Data.StartTime:GetTime()
    self:OnPhotoListContentCreated(Content)
    table.insert(self.PhotoItemContents, Content)
  end
  
  local function GetSortWeight(Content)
    if Content.QuestState == self.QCS.finish then
      return Content.RewardGot and 3 or 4
    elseif Content.QuestState == self.QCS.unlock or Content.QuestState == self.QCS.doing then
      return 2
    end
    return 1
  end
  
  table.sort(self.PhotoItemContents, function(a, b)
    local weightA = GetSortWeight(a)
    local weightB = GetSortWeight(b)
    if weightA ~= weightB then
      return weightA > weightB
    else
      return a.Index < b.Index
    end
  end)
end

function M:CancelNewReddot(Content)
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CameraGameUtils.ReddotNodeName)
  if not CacheDetail then
    return
  end
  local QuestChainId = Content.QuestChainId
  if CacheDetail[QuestChainId] ~= self.ReddotType.NEW then
    return
  end
  CacheDetail[QuestChainId] = self.ReddotType.SEEN
  ReddotManager.DecreaseLeafNodeCount(CameraGameUtils.ReddotNodeName)
end

function M:OnPhotoItemClicked(Content)
  if self.ContentClicked == Content then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/camera_photo_click", nil, nil)
  local ItemWidget = Content.SelfWidget
  if not ItemWidget then
    return
  end
  self:CancelNewReddot(Content)
  ItemWidget:StopAnimation(ItemWidget.Normal)
  ItemWidget:PlayAnimation(ItemWidget.Click)
  if self.ContentClicked then
    local LastItemWidget = self.ContentClicked.SelfWidget
    if LastItemWidget then
      LastItemWidget:StopAnimation(LastItemWidget.Click)
      LastItemWidget:PlayAnimation(LastItemWidget.Normal)
    end
  end
  self.ContentClicked = Content
  self.CurQuestState = Content.QuestState
  self:OnPhotoListItemAddedToFocusPath(Content)
  self.ScrollBox_Message:ScrollToStart()
  if self.IsGamepadInput then
    self:UpdateBottomKeyInfo()
  end
  self.WBP_BG:PlayAnimation(self.WBP_BG.Refresh)
  self:AddTimer(0.1, function()
    self:RefreshMainPhotoView(Content)
  end)
end

function M:RefreshMainPhotoView(Content)
  local Visibility = UIConst.VisibilityOp.Visible
  if Content.QuestState == self.QCS.lock then
    Visibility = UIConst.VisibilityOp.Collapsed
  end
  self.List_Reward:SetVisibility(Visibility)
  self.Switch_Btn:SetVisibility(Visibility)
  self.Text_PhotoTitle:SetVisibility(Visibility)
  self.Text_Message:SetVisibility(Visibility)
  if Content.QuestState == self.QCS.finish then
    self.Text_PhotoTitle:SetText(GText(Content.TextTitle))
    self.Text_Message:SetText(GText(Content.TextContent))
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(0)
    self.WBP_BG.Image_Normal:SetBrushFromTexture(Content.Texture)
    self:RefreshRewardList()
    if Content.RewardGot then
      self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
      self.Text_PhotoDis:SetText(GText("UI_Reward_Received"))
    else
      self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
      self.Text_Photo:SetText(GText("UI_Mail_Recieve"))
    end
  elseif Content.QuestState == self.QCS.unlock or Content.QuestState == self.QCS.doing then
    self.Text_PhotoTitle:SetText(GText(Content.TextTitle))
    self.Text_Message:SetText(GText(Content.TextContent))
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(1)
    self.WBP_BG.Image_None:SetBrushFromTexture(Content.Texture)
    self:RefreshRewardList()
    self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
    self.Text_Photo:SetText(GText("UI_PhotoEvent_Goto"))
  else
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(2)
    local IsSucccess = self:SetUnlockTimeText(Content)
    if not IsSucccess then
      self:SetUnlockConditionText(Content)
    end
  end
end

function M:SetUnlockTimeText(Content)
  if not Content or not Content.UnlockTime then
    return false
  end
  local TimeDict, _ = UIUtils.GetLeftTimeStrStyle2(Content.UnlockTime)
  if not TimeDict then
    return false
  end
  local ZeroCount = 0
  local RemainTimeText = ""
  for TimeCount, ThisTimeInfo in ipairs(TimeDict) do
    if TimeCount > 2 then
      DebugPrint("CameraGame: WBP_Com_Time SetTimeText TimeCount too much, 2 need but get more")
      break
    end
    RemainTimeText = string.format("%s%02d%s", RemainTimeText, ThisTimeInfo.TimeValue, GText("UI_GameEvent_TimeRemain_" .. ThisTimeInfo.TimeType))
    if 0 == ThisTimeInfo.TimeValue then
      ZeroCount = ZeroCount + 1
    end
  end
  if ZeroCount > 1 then
    return false
  end
  RemainTimeText = string.format(GText("UI_PhotoEvent_Unlock"), RemainTimeText)
  self.WBP_BG.Text_Lock:SetText(RemainTimeText)
  return true
end

function M:SetUnlockConditionText(Content)
  if not Content or not Content.QuestChainId then
    return
  end
  local EventData = DataMgr.PhotoEvent[self.EventId]
  if not EventData then
    return
  end
  local QuestData = EventData[Content.PhotoTaskId]
  if not QuestData then
    return
  end
  local ConditionText = string.format(GText("UI_PhotoEvent_Quest"), GText(QuestData.Content3))
  self.WBP_BG.Text_Lock:SetText(ConditionText)
end

function M:OnPhotoItemIsHoveredChanged(Content, IsHovered)
  if self.IsGamepadInput then
    return
  end
  local ItemWidget = Content.SelfWidget
  if not ItemWidget then
    return
  end
  if self.ContentClicked == Content then
    return
  end
  if IsHovered then
    ItemWidget:StopAnimation(ItemWidget.UnHover)
    ItemWidget:PlayAnimation(ItemWidget.Hover)
  else
    ItemWidget:StopAnimation(ItemWidget.Hover)
    ItemWidget:PlayAnimation(ItemWidget.UnHover)
  end
end

function M:RefreshRewardList()
  local PhotoContent = self.ContentClicked
  if not PhotoContent then
    return
  end
  local RewardList = RewardUtils:GetRewardViewInfoById(PhotoContent.RewardId)
  if not RewardList or 0 == #RewardList then
    return
  end
  self.List_Reward:ClearListItems()
  for _, RewardInfo in pairs(RewardList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemType = RewardInfo.Type
    Content.UnitId = RewardInfo.Id
    Content.Rarity = RewardInfo.Rarity or 1
    Content.Icon = ItemUtils.GetItemIconPath(RewardInfo.Id, RewardInfo.Type)
    Content.IsShowDetails = true
    Content.IsSelect = false
    Content.bHasGot = PhotoContent.RewardGot
    Content.UIName = "ActivityCamreaGame"
    if RewardInfo.Quantity then
      if #RewardInfo.Quantity > 1 then
        Content.Count = RewardInfo.Quantity[1]
        Content.MaxCount = RewardInfo.Quantity[2]
      else
        Content.Count = RewardInfo.Quantity[1]
      end
    end
    self:OnRewardListContentCreated(Content)
    self.List_Reward:AddItem(Content)
  end
  self.List_Reward:ScrollIndexIntoView(0)
end

function M:OnRewardAndPhotoButtonClicked()
  if not self.ContentClicked then
    return
  end
  if self.ContentClicked.QuestState ~= self.QCS.finish then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/sub_btn_click", nil, nil)
    local QuestChainId = self.ContentClicked.QuestChainId
    if not self.Avatar.QuestChains[QuestChainId] then
      return
    end
    local RegionPointId
    for key, _ in pairs(DataMgr.PhotoEvent) do
      for key, value in pairs(_) do
        if value.QuestChain == QuestChainId then
          RegionPointId = value.RegionPoint
          break
        end
      end
    end
    if not RegionPointId then
      return
    end
    local SubRegionId = DataMgr.RegionPoint[RegionPointId].SubRegion
    local RegionId = DataMgr.SubRegion[SubRegionId].RegionId
    self:AddTimer(0.1, function()
      local MainMap = UIManager(self):LoadUINew("LevelMapMain", false, RegionId, "RegionPoint", RegionPointId)
    end)
    return
  end
  if self.Avatar.PhotoActRewardGot[self.ContentClicked.QuestChainId] then
    return
  end
  
  local function Callback(ErrCode, Rewards)
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Rewards, self.PlayOutAnim, self, true)
    self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
    self.Text_PhotoDis:SetText(GText("UI_Reward_Received"))
    self.ContentClicked.RewardGot = true
    self:RefreshRewardList()
  end
  
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sub_btn_click", nil, nil)
  self:BlockAllUIInput(true)
  self.Avatar:GetPhotoQuestFinishReward(Callback, self.ContentClicked.QuestChainId)
end

function M:OnPhotoListContentCreated(Content)
end

function M:OnRewardListContentCreated(Content)
end

function M:OnPhotoListItemAddedToFocusPath(Content)
end

function M:UpdateBottomKeyInfo()
end

return M
