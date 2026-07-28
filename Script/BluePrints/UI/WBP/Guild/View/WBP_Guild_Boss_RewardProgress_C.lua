require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local StageRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossStageRewardUtils")
local GuildBossRewardUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossRewardUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local REDDOT_NODE = "GuildBossProgressReward"

function M:InitProgress(Text, Progress)
  self.CurrentProgress = Progress
  self.Text_Desc:SetText(Text)
  if Progress == math.floor(Progress) then
    self.Text_Percent:SetText(tostring(math.floor(Progress)))
  else
    self.Text_Percent:SetText(string.format("%.1f", Progress))
  end
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OpenRewardProgressPanel)
  for i = 1, 5 do
    local bar = self["Bar_" .. i]
    if bar then
      local barMin = (i - 1) * 20
      local barMax = i * 20
      local barPercent
      if Progress >= barMax then
        barPercent = 1.0
      elseif Progress <= barMin then
        barPercent = 0.0
      else
        barPercent = (Progress - barMin) / 20
      end
      bar:SetPercent(barPercent)
    end
  end
  ReddotManager.AddListener(REDDOT_NODE, self, self.OnBossRewardReddotChange)
  self:SyncReddotState()
  self:OnBossRewardReddotChange(nil, nil, REDDOT_NODE)
end

function M:OnBossRewardReddotChange(Count, ReddotType, NodeName)
  if nil == Count then
    local Node = ReddotManager.GetTreeNode(REDDOT_NODE)
    Count = Node and Node.Count or 0
  end
  if self.Reddot then
    if Count > 0 then
      self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      if self.Reddot.WS_Icon then
        self.Reddot.WS_Icon:SetActiveWidgetIndex(0)
      end
    else
      self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.Btn_Click and self.Btn_Click.Key_Controller then
    self.Btn_Click.Key_Controller:SetVisibility(Count > 0 and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:SyncReddotState()
  GuildBossRewardUtils.RefreshBossStageReddot()
end

function M:Destruct()
  ReddotManager.RemoveListener(REDDOT_NODE, self)
end

function M:BuildRewardItems(IsGuildTab)
  return GuildBossRewardUtils.BuildStageRewardItems(self, IsGuildTab)
end

function M:OpenRewardProgressPanel()
  UIManager(self):LoadUINew("GuildReward", GuildBossRewardUtils.BuildGuildBossRewardParams(self, "Personal"))
end

function M:OnClaimReward(RewardItem, Content)
  GuildBossRewardUtils.OnClaimStageReward(RewardItem, Content)
end

function M:DoClaimAll(ReceiveAllParm)
  GuildBossRewardUtils.OnClaimAllStageReward(self, ReceiveAllParm)
end

return M
