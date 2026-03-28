require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsPlaceholder = false
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
  ReddotManager.RemoveListener("BagGameNew", self)
  self.Owner = Content.Owner
  self.Content = Content
  self.Widget = self
  if Content.IsPlaceholder then
    self:ShowPlaceholder()
    return
  end
  self.bIsPlaceholder = false
  self.Index = Content.Id
  self:InitData(Content)
  self:InitView(Content)
  ReddotManager.AddListenerEx("BagGameNew", self, self.UpdateBagGameNewReddot)
end

function M:BP_OnEntryReleased()
  ReddotManager.RemoveListener("BagGameNew", self)
end

function M:UpdateBagGameNewReddot(Count, RdType, Name)
  if not self.New then
    return
  end
  if BagGameModel:IsActivityEnded() then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if not self.Content or not self.Content.LevelId then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local NewCacheDetail = ReddotManager.GetLeafNodeCacheDetail("BagGameNew")
  if NewCacheDetail and NewCacheDetail[self.Content.LevelId] == true then
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitData(Content)
end

function M:InitView(Content)
  self.Switch_Style:SetActiveWidgetIndex(1)
  self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local FinishCount = 0
  if Content.TargetScore then
    for i, TargetScore in ipairs(Content.TargetScore) do
      local IsFinish = Content.PlayerScore and TargetScore <= Content.PlayerScore
      if IsFinish then
        FinishCount = FinishCount + 1
      end
    end
  end
  local RomanIndex = BagGameModel:ConvertIndex2Roman(self.Index)
  self:Set_NumandStart(RomanIndex, FinishCount)
  self:UpdateSmallStarCount(FinishCount)
  self:UpdateLockState(FinishCount)
  self:UpdateFinishState(FinishCount)
  self.Text_CenterNum_Check:SetText(RomanIndex)
  self.Text_CenterNum_Lock:SetText(RomanIndex)
end

function M:UpdateSmallStarCount(FinishCount)
  for i = 1, 3 do
    local SmallStar = self["Image_Star0" .. i]
    if SmallStar then
      if i <= FinishCount then
        SmallStar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      else
        SmallStar:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    end
  end
end

function M:UpdateLockState()
  local bUnlocked = true
  if self.Index and self.Index > 1 then
    bUnlocked = false
    if self.Owner and self.Owner.OriginalDataList then
      local PrevInfo = self.Owner.OriginalDataList[self.Index - 1]
      if PrevInfo then
        local PrevFinishCount = 0
        if PrevInfo.PlayerScore ~= nil and PrevInfo.TargetScore then
          for _, TargetScore in ipairs(PrevInfo.TargetScore) do
            if TargetScore <= PrevInfo.PlayerScore then
              PrevFinishCount = PrevFinishCount + 1
            end
          end
        else
          PrevFinishCount = BagGameModel:GetPlayerStarCount(PrevInfo.LevelId)
        end
        bUnlocked = PrevFinishCount > 0
      end
    end
  end
  if bUnlocked and self.Owner and self.Owner.IsSelectedLevelUnlockTimeReached then
    bUnlocked = self.Owner:IsSelectedLevelUnlockTimeReached(self.Content)
  end
  self.bUnlocked = bUnlocked
  if self.Overlay_Lock then
    if bUnlocked then
      self.Overlay_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Overlay_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:UpdateFinishState(FinishCount)
  local bFinished = FinishCount >= 3
  if self.Overlay_Check then
    if bFinished then
      self.Overlay_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Overlay_Check:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:ShowPlaceholder()
  self.bIsPlaceholder = true
  self.bIsSelected = false
  self.Switch_Change:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Switch_Style:SetActiveWidgetIndex(0)
end

function M:OnCenterLBtnClicked()
  if self.Owner and self.Owner.ScrollToPreviousItem then
    self.Owner:ScrollToPreviousItem()
  end
end

function M:OnCenterRBtnClicked()
  if self.Owner and self.Owner.ScrollToNextItem then
    self.Owner:ScrollToNextItem()
  end
end

function M:PlaySelected()
  if self.bIsPlaceholder then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/weimangzhencang_level_select_btn_in", nil, nil)
  self.Switch_Change:SetActiveWidgetIndex(self.bUnlocked and 0 or 1)
  self.PanalS:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Change then
    self:PlayAnimation(self.Change)
  end
  self.bIsSelected = true
end

function M:PlayUnselected()
  if self.bIsPlaceholder then
    return
  end
  self.PanalS:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Change then
    self:PlayAnimationReverse(self.Change)
  end
  self.bIsSelected = false
end

return M
