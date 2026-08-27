require("UnLua")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnBtnPressed()
  Utils.ScreenPrint("WBP_Guild_Construct_BtnDrag_C:BtnPressed")
  self.bIsDragActor = true
end

function M:OnBtnReleased()
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.Parent then
    return self.Parent:OnMouseButtonDown(MyGeometry, MouseEvent)
  end
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self.Parent then
    return self.Parent:OnMouseButtonUp(MyGeometry, MouseEvent)
  end
end

function M:InitOperation()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.ActorId = self.GuildManager:GetSelectedActorGuild()
end

function M:GetActorLocation()
  local State = self.GuildManager:GetActorState(self.ActorId)
  return State.LocalLocation
end

function M:InitParent(ParentTest)
  self.Parent = ParentTest
end

function M:RefreshData()
  self:InitOperation()
end

return M
