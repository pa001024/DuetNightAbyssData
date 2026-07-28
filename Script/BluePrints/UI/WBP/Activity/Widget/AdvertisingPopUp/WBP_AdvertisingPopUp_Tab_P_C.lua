require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local ActivityReddotHelper = require("BluePrints.UI.WBP.Activity.ActivityReddotHelper")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(Info, ParentWidget)
  self.CurIndex = Info.Index
  self.PopId = Info.PopId
  self.CharId = Info.CharId
  self.ClickCallback = Info.ClickCallback
  self.ParentWidget = ParentWidget
  local PopInfo = DataMgr.LoginPopUp[self.PopId]
  self.PopInfo = PopInfo
  local IconPath = PopInfo and PopInfo.TabBp or "Texture2D'/Game/UI/Texture/Dynamic/Image/Activity/T_Activity_Tab_Head_TryOut_Baiheng01.T_Activity_Tab_Head_TryOut_Baiheng01'"
  if IconPath then
    local Image = LoadObject(IconPath)
    if Image then
      local DynamicMaterial = self.Image_Head:GetDynamicMaterial()
      DynamicMaterial:SetTextureParameterValue("IconMap", Image)
    end
  end
  self:SetIsSelected(Info.bIsSelected)
  self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Click.OnCheckStateChanged:Clear()
  self.Btn_Click.OnCheckStateChanged:Add(self, self.OnBtnStateChange)
  self.Btn_Click.OnHovered:Clear()
  self.Btn_Click.OnHovered:Add(self, self.OnBtnHover)
  self.Btn_Click.OnUnHovered:Clear()
  self.Btn_Click.OnUnHovered:Add(self, self.OnBtnUnHover)
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
end

function M:GetPopInfo()
  if self.PopInfo then
    return self.PopInfo
  end
  local PopInfo = DataMgr.LoginPopUp[self.PopId]
  self.PopInfo = PopInfo or {}
  return self.PopInfo
end

function M:OnBtnClick()
  if self.bIsSelected then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sub_btn_click", nil, nil)
end

function M:SetReddotNew(bShow)
  if not bShow then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:SetIsSelected(bIsSelected)
  self.bIsSelected = bIsSelected
  self.Btn_Click:SetChecked(bIsSelected)
  if bIsSelected then
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Btn_Click:SetVisibility(UIConst.VisibilityOp.Visible)
    self:PlayAnimation(self.Normal)
  end
end

function M:SetReddot(bShowRed)
  if bShowRed then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnBtnStateChange(IsChecked)
  if IsChecked and self.ClickCallback then
    DebugPrint("Tab Clicked, Index = " .. self.CurIndex)
    self.ClickCallback(self.ParentWidget, self.CurIndex)
  end
end

function M:OnBtnHover()
  if self.bIsSelected then
    return
  end
  self:PlayAnimationForward(self.Hover)
end

function M:OnBtnUnHover()
  if self.bIsSelected then
    return
  end
  self:PlayAnimationForward(self.UnHover)
end

function M:Destruct()
  if self.ActivityId then
    ActivityReddotHelper.RemoveReddotListenByEventId(self.ActivityId, self)
  end
end

return M
