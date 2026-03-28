require("UnLua")
local MaterialImg = {
  [1] = "Texture2D'/Game/UI/WBP/Common/VX/Fame/MI_Fame_Cu.MI_Fame_Cu'",
  [2] = "Texture2D'/Game/UI/WBP/Common/VX/Fame/MI_Fame_Au.MI_Fame_Au'",
  [3] = "Texture2D'/Game/UI/WBP/Common/VX/UIVX/Texture/Surface/VX_T_Surface_0010.VX_T_Surface_0010'"
}
local MaterialTex_A = {
  [1] = 2,
  [2] = 2,
  [3] = 3
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Button.OnClicked:Add(self, self.OnBtnClicked)
  self.Button.OnHovered:Add(self, self.OnBtnHovered)
  self.Button.OnUnhovered:Add(self, self.OnBtnUnhovered)
end

function M:Destruct()
  self.Button.OnClicked:Remove(self, self.OnBtnClicked)
  self.Button.OnHovered:Remove(self, self.OnBtnHovered)
  self.Button.OnUnhovered:Remove(self, self.OnBtnUnhovered)
end

function M:Init(Content)
  rawset(self, "TaskLevel", Content.TaskLevel)
  rawset(self, "TaskName", Content.TaskName)
  rawset(self, "CurrentTaskLevel", Content.CurrentTaskLevel)
  rawset(self, "Parent", Content.Parent)
  rawset(self, "BtnClickedCallBack", Content.BtnClickedCallBack)
  rawset(self, "MaxTaskLevel", Content.MaxTaskLevel)
  self.TextLevel:SetText(self.TaskLevel)
  self.TextTaskName:SetText(self.TaskName)
  self:RefreshState(self.CurrentTaskLevel)
end

function M:RefreshState(CurrentTaskLevel)
  self.CurrentTaskLevel = CurrentTaskLevel
  if self.CurrentTaskLevel == self.TaskLevel then
    if self.MaxTaskLevel == self.TaskLevel then
      self:PlayAnimation(self.UnLock_Normal)
    else
      self:PlayAnimation(self.Done)
    end
    self:PlayAnimation(self.Click)
  elseif self.MaxTaskLevel < self.TaskLevel then
    self:PlayAnimation(self.Lock)
    self:PlayAnimation(self.Normal)
  elseif self.MaxTaskLevel == self.TaskLevel then
    self:PlayAnimation(self.UnLock_Normal)
    self:PlayAnimation(self.Normal)
  else
    self:PlayAnimation(self.Done)
    self:PlayAnimation(self.Normal)
  end
  local TextMainColor = self["ImgColor_0" .. self.TaskLevel]
  local TextDynamicMaterial = self.TextLevel:GetDynamicFontMaterial()
  if TextDynamicMaterial then
    TextDynamicMaterial:SetVectorParameterValue("MainColor", TextMainColor)
  end
  local AddTex_A = MaterialTex_A[self.TaskLevel]
  local BgDynamicMaterial = self.Tilte_Bg:GetDynamicMaterial()
  if BgDynamicMaterial then
    BgDynamicMaterial:SetVectorParameterValue("MainColor", TextMainColor)
    BgDynamicMaterial:SetScalarParameterValue("AddTex_A", AddTex_A)
  end
end

function M:ShowRedDot(bShow)
  self.Reddot:SetVisibility(bShow and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
end

function M:OnAnimationFinished(InAnimation)
end

function M:OnBtnHovered()
  if self.MaxTaskLevel >= self.TaskLevel then
    rawset(self, "bHovered", true)
    self:PlayAnimation(self.Hover)
  end
end

function M:OnBtnUnhovered()
  if self.MaxTaskLevel >= self.TaskLevel then
    rawset(self, "bHovered", false)
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnBtnClicked()
  if self.MaxTaskLevel >= self.TaskLevel then
    if self.BtnClickedCallBack then
      self.BtnClickedCallBack(self.Parent, self.TaskLevel)
    end
    self:PlayAnimation(self.Click)
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(string.format("RecurringTask_Rarity%d_Locked", self.TaskLevel)))
  end
end

return M
