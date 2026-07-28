require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Reddot_Count = 0
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
  ReddotManager.AddListenerEx("GuildBossProgressReward", self, self.RefreshGuildBossProgressRewardReddot)
end

function M:Destruct()
  ReddotManager.RemoveListener("GuildBossProgressReward", self)
end

function M:RefreshGuildBossProgressRewardReddot(Count)
  self.Reddot_Count = Count
  self:RefreshReddot()
end

function M:RefreshReddot()
  if self.State == "Active" and self.Reddot_Count > 0 then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  local BossInfo = Content.BossInfo
  if not BossInfo and Content.BossId then
    BossInfo = DataMgr.GuildBossInfo[Content.BossId]
  end
  if BossInfo and BossInfo.TabImgBPPath and self.Image_Boss then
    local Texture = LoadObject(BossInfo.TabImgBPPath)
    self.Image_Boss:GetDynamicMaterial():SetTextureParameterValue("MainTex", Texture)
  end
  self:RefreshLockPanel()
  if self.Content.IsSelected then
    self:PlayAnimation(self.Click)
    self.Content.Parent.SelectedBossTabUI = self
    self.Content.Parent.SelectedBossId = self.Content.BossId
    self.Content.Parent:RefreshBossInfo(self.Content.BossId)
  else
    self:PlayAnimation(self.Normal)
  end
  self:RefreshReddot()
end

function M:RefreshLockPanel()
  if not self.Content or not self.Panel_Lock then
    return
  end
  local RefreshInfo = self.Content.RefreshInfo
  local Index = self.Content.Index
  if not RefreshInfo or not Index then
    self.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local State, RemainSec = GuildBossUtils.GetBossSlotState(RefreshInfo, Index)
  self.State = State
  if "Active" == State then
    self.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Panel_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if not self.Text_Lock then
    return
  end
  if "Ended" == State then
    self.Text_Lock:SetText(GText("UI_GuildBoss_Completed"))
  else
    self.Text_Lock:SetText(string.format(GText("UI_GuildBoss_OpenInTime"), UIUtils.FormatRemainDurationCoarseLoc(RemainSec)))
  end
end

function M:OnClicked()
  if not self.Content or not self.Content.Parent then
    return
  end
  self.Content.Parent:RefreshBossInfo(self.Content.BossId)
  if UIUtils.IsGamepadInput() then
    self.Content.Parent:OnBossTabClicked()
  end
  self:PlayClickAnimation()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.IsGamepadInput() then
    self.Content.Parent:RefreshBossInfo(self.Content.BossId)
    self:PlayClickAnimation()
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:PlayClickAnimation()
  if self.Content.Parent.SelectedBossId ~= self.Content.BossId then
    local PrevTabUI = self.Content.Parent.SelectedBossTabUI
    if PrevTabUI then
      PrevTabUI:StopAnimation(PrevTabUI.Click)
      PrevTabUI:StopAnimation(PrevTabUI.Lock_Click)
      PrevTabUI:PlayAnimation(PrevTabUI.Normal)
    end
    self.Content.Parent.SelectedBossTabUI = self
    if self.State == "Active" then
      self:PlayAnimation(self.Click)
    else
      self:PlayAnimation(self.Lock_Click)
    end
    self.Content.Parent.SelectedBossId = self.Content.BossId
  end
end

return M
