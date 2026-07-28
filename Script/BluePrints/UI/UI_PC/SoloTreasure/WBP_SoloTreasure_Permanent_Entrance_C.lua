require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local PermanentSoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.PermanentSoloTreasureDataModel")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
M.Type = {
  Illustrated = "Illustrated",
  Shop = "Shop",
  Reward = "Reward"
}

function M:Construct()
  self:PlayAnimation(self.In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
  self:BindBtnState()
end

function M:Init(Type)
  self.EntranceType = Type
  self:InitName()
  self:InitBubble()
  self:InitReddot()
end

local NameMap = {
  Illustrated = "UI_Play_TreasureHunt_TreasureArchive",
  Shop = "UI_Play_TreasureHunt_Shop",
  Reward = "UI_Play_TreasureHunt_Quest"
}

function M:InitName()
  if self.Text_Name then
    local Key = NameMap[self.EntranceType]
    self.Text_Name:SetText(Key and GText(Key) or "")
  end
end

local BubbleTimerKey = "SoloTreasure_Permanent_Entrance_Bubble"
local ResetCoinKeyByTimeType = {
  Day = "UI_Play_TreasureHunt_ResetCoin_Day",
  Hour = "UI_Play_TreasureHunt_ResetCoin_Hour",
  Min = "UI_Play_TreasureHunt_ResetCoin_Minute"
}

function M:InitBubble()
  self:RemoveTimer(BubbleTimerKey)
  if not self.Bubble then
    return
  end
  if self.EntranceType ~= M.Type.Shop then
    self.Bubble:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local SeasonId = PermanentSoloTreasureDataModel:GetCurrentSeasonId()
  local Remaining, IsPlayable = PermanentSoloTreasureDataModel:GetSeasonTimeInfo(SeasonId)
  if IsPlayable or Remaining <= 0 then
    self.Bubble:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  self.BubbleEndTime = TimeUtils.NowTime() + Remaining
  self.Bubble:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:UpdateBubbleTime()
  self:AddTimer(1, self.UpdateBubbleTime, true, 0, BubbleTimerKey)
  if self.Bubble.PlayInAndLoopAnimation then
    self.Bubble:PlayInAndLoopAnimation()
  end
end

function M:UpdateBubbleTime()
  if not self.Bubble or not self.Bubble.Text_Bubble then
    return
  end
  if TimeUtils.NowTime() >= self.BubbleEndTime then
    self:RemoveTimer(BubbleTimerKey)
    self.Bubble:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(self.BubbleEndTime)
  local Coarsest = RemainTimeDict[1]
  local Key = ResetCoinKeyByTimeType[Coarsest.TimeType] or ResetCoinKeyByTimeType.Min
  local Value = Coarsest.TimeValue
  if Coarsest.TimeType == "Min" then
    Value = math.max(1, Value)
  end
  self.Bubble.Text_Bubble:SetText(string.format(GText(Key), Value))
end

function M:BindBtnState()
  if not self.Btn_Area then
    return
  end
  if self.Btn_Area.OnHovered then
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnHovered:Add(self, self.OnBtnHovered)
  end
  if self.Btn_Area.OnUnhovered then
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
  if self.Btn_Area.OnPressed then
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnPressed:Add(self, self.OnBtnPressed)
  end
  if self.Btn_Area.OnClicked then
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
  end
end

function M:OnBtnHovered()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnBtnPressed()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnBtnClicked()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/shop_small_btn_click", nil, nil)
  local T = M.Type
  if self.EntranceType == T.Illustrated then
    self:OnIllustratedClicked()
  elseif self.EntranceType == T.Shop then
    self:OnShopClicked()
  elseif self.EntranceType == T.Reward then
    self:OnRewardClicked()
  end
end

function M:OnIllustratedClicked()
  UIManager(self):LoadUINew("SoloTreasurePermanentIllustrated")
end

function M:OnShopClicked()
  local SeasonId = PermanentSoloTreasureDataModel:GetCurrentSeasonId()
  local Row = SeasonId and PermanentSoloTreasureDataModel:GetSeasonRow(SeasonId)
  local ShopId = Row and Row.SeasonShop
  if not ShopId or ShopId <= 0 then
    return
  end
  local bJumpSuccess = PageJumpUtils:JumpToTargetPageByJumpId(ShopId)
  if bJumpSuccess then
    PermanentSoloTreasureDataModel:MarkShopEntryRead(SeasonId)
  end
end

function M:OnRewardClicked()
  SoloTreasurePermanentDataModel:OpenReward()
end

function M:InitReddot()
  local T = M.Type
  if self.EntranceType == T.Illustrated then
    ReddotManager.AddListenerEx("SoloTreasure_Permanent_Illustrated", self, function(self, Count, RdType)
      self:EMShowReddot(Count > 0, RdType, Count)
    end)
  elseif self.EntranceType == T.Shop then
    ReddotManager.AddListenerEx(PermanentSoloTreasureDataModel.REDDOT_NODE_SHOP_NEW, self, function(self, Count, RdType)
      self:EMShowReddot(Count > 0, RdType, Count)
    end)
  elseif self.EntranceType == T.Reward then
    ReddotManager.AddListenerEx("SoloTreasure_Permanent_Reward", self, function(self, Count, RdType)
      self:EMShowReddot(Count > 0, RdType, Count)
    end)
  end
end

function M:Destruct()
  self:RemoveTimer(BubbleTimerKey)
  local T = M.Type
  if self.EntranceType == T.Illustrated then
    ReddotManager.RemoveListener("SoloTreasure_Permanent_Illustrated", self)
  elseif self.EntranceType == T.Shop then
    ReddotManager.RemoveListener(PermanentSoloTreasureDataModel.REDDOT_NODE_SHOP_NEW, self)
  elseif self.EntranceType == T.Reward then
    ReddotManager.RemoveListener("SoloTreasure_Permanent_Reward", self)
  end
end

AssembleComponents(M)
return M
