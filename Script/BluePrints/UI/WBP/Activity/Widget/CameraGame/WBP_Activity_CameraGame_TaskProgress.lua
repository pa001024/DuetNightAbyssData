require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_Title:SetText(GText("拍摄进度（未配）"))
  self.Btn_Area.OnClicked:Add(self, self.OnButtonClicked)
end

function M:Destruct()
end

function M:Update()
  self:PlayAnimation(self.In)
end

function M:InitPage(EventId)
  self:PlayAnimation(self.In)
  self:InitPhotoProgress(EventId)
end

function M:InitPhotoProgress(EventId)
  local Avatar = GWorld:GetAvatar()
  local CurCount = #Avatar.PhotoActRewardGot
  local TotalCount = #DataMgr.PhotoEvent[EventId]
  self.Text_Num01:SetText(CurCount)
  self.Text_Num02:SetText("/" .. TotalCount)
end

function M:OnButtonClicked()
  if self.ParentWidget and self.ParentWidget.GoToTargetPageClick then
    self.ParentWidget:GoToTargetPageClick()
  end
end

return M
