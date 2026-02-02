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
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Param1, Param2)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Param1, Param2)
  if Param2 and Param2[1] then
    local Index = tonumber(Param2[1]) or 1
    self.ListView_Left:NavigateToIndex(Index - 1)
  end
  self:InitPhotoProgress()
  self:InitPhotoList()
  self:PlayAnimation(self.In)
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
  self:PlayAnimation(self.Out)
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddTimer(0.2, function()
    self:Close()
  end)
end

function M:AddReddotListen()
end

function M:RemoveReddotListen()
  ActivityReddotHelper.RemoveReddotListenByEventId(self.CurActivityId, self)
end

function M:InitCommonTab()
  self.Tab:Init(self.TabConfigData, true)
end

function M:InitPhotoProgress()
  self.Text_Title:SetText(GText("拍照进度（未配）"))
  local CurCount = #self.Avatar.PhotoActRewardGot
  local TotalCount = #DataMgr.PhotoEvent[self.EventId]
  self.Text_TitleNum01:SetText(CurCount)
  self.Text_TitleNum02:SetText("/" .. TotalCount)
end

function M:InitPhotoList()
  self.ListView_Left:ClearListItems()
  self.PhotoItemContents = self:CreatePhotoContent()
  for _, Content in pairs(self.PhotoItemContents or {}) do
    self.ListView_Left:AddItem(Content)
  end
  self.PhotoItemCount = #self.PhotoItemContents
  self.ListView_Left:NavigateToIndex(0)
  self.ListView_Left.BP_OnItemClicked:Clear()
  self.ListView_Left.BP_OnItemClicked:Add(self, self.OnPhotoItemClicked)
  self.ListView_Left.BP_OnItemIsHoveredChanged:Clear()
  self.ListView_Left.BP_OnItemIsHoveredChanged:Add(self, self.OnPhotoItemIsHoveredChanged)
end

function M:CreatePhotoContent()
  if not self.Avatar then
    return
  end
  local PhotoItemContents = {}
  for _, Data in pairs(DataMgr.PhotoEvent[self.EventId] or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    Content.Index = Data.PhotoTaskId
    Content.QuestChainId = Data.QuestChain
    Content.PhotoPath = Data.PhotoView
    Content.RewardId = Data.RewardView
    Content.RewardGot = self.Avatar.PhotoActRewardGot[Data.PhotoTaskId]
    local QuestChain = self.Avatar.QuestChains[Data.QuestChain]
    Content.QuestState = QuestChain and QuestChain.State or 0
    if Content.QuestState == self.QCS.lock then
      Content.UnlockTime = Data.StartTime
    end
    self:OnPhotoListContentCreated(Content)
    table.insert(PhotoItemContents, Content)
  end
  
  local function GetSortWeidget(Content)
    if Content.QuestState == self.QCS.finish then
      return Content.RewardGot and 3 or 4
    elseif Content.QuestState == self.QCS.unlock or Content.QuestState == self.QCS.doing then
      return 2
    end
    return 1
  end
  
  table.sort(PhotoItemContents, function(a, b)
    local weightA = GetSortWeidget(a)
    local weightB = GetSortWeidget(b)
    if weightA ~= weightB then
      return weightA > weightB
    else
      return a.Index < b.Index
    end
  end)
  return PhotoItemContents
end

function M:OnPhotoItemClicked(Content)
  if self.ContentClicked == Content then
    return
  end
  local ItemWidget = Content.SelfWidget
  if not ItemWidget then
    return
  end
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
  self:OnPhotoListItemAddedToFocusPath(Content)
  self.ScrollBox_Message:ScrollToStart()
  if self.IsGamepadInput then
    self:UpdateBottomKeyInfo()
  end
  self:RefreshMainPhotoView(Content)
end

function M:RefreshMainPhotoView(Content)
  if Content.QuestState ~= self.QCS.lock then
    self.List_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Switch_Btn:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_PhotoTitle:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Text_Message:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.List_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Switch_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_PhotoTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Text_Message:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if Content.QuestState == self.QCS.finish then
    self.Text_PhotoTitle:SetText(GText("与赛琪相遇 + " .. Content.Index))
    local TestMessage = ""
    self.Text_Message:SetText(GText(TestMessage .. Content.Index))
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(0)
    self.WBP_BG.Image_Normal:SetBrushFromTexture(Content.Texture)
    self:RefreshRewardList(Content.RewardId)
    if Content.RewardGot then
      self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
      self.Text_PhotoDis:SetText(GText("已领取（未配）"))
    else
      self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
      self.Text_Photo:SetText(GText("领取奖励（未配）"))
    end
  elseif Content.QuestState == self.QCS.unlock or Content.QuestState == self.QCS.doing then
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(1)
    self.WBP_BG.Image_None:SetBrushFromTexture(Content.Texture)
    self.Switch_Btn:SetActiveWidget(self.Btn_Photo)
    self.Text_Photo:SetText(GText("前往拍照（未配）"))
  else
    self.WBP_BG.Switch_Type:SetActiveWidgetIndex(2)
    self.WBP_BG.Text_Lock:SetText(Content.RemainTimeText)
  end
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

function M:RefreshRewardList(RewardID)
  local RewardList = RewardUtils:GetRewardViewInfoById(RewardID)
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
  if self.ContentClicked and self.ContentClicked.QuestState ~= self.QCS.finish then
    local QuestChainId = self.ContentClicked.QuestChainId
    if not self.Avatar.QuestChains[QuestChainId] then
      return
    end
    local MainMap = UIManager(self):LoadUINew("LevelMapMain", true)
    if MainMap then
      local DoingQuestId = self.Avatar.QuestChains[QuestChainId].DoingQuestId
      local TargetSubRegionId = MissionIndicatorManager:GetTargetTaskSubRegionId(QuestChainId, DoingQuestId)
      MainMap.RealWildMap:ChangeRegionForSmartIndicator(TargetSubRegionId, QuestChainId)
    end
    return
  end
  
  local function Callback(ErrCode, Rewards)
    self:BlockAllUIInput(false)
    if not ErrorCode:Check(ErrCode) then
      return
    end
    if self.IsGamepadInput then
      self:AddTimer(0.8, function()
        UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Rewards, self.PlayOutAnim, self, true)
      end)
    else
      UIManager(self):LoadUINew("GetItemPage", nil, nil, nil, Rewards, self.PlayOutAnim, self, true)
    end
    self.ContentClicked.RewardGot = true
    self.Switch_Btn:SetActiveWidget(self.Btn_PhotoDis)
    self.Text_PhotoDis:SetText(GText("已领取（未配）"))
  end
  
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
