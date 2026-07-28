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
  self.Parent.bIsDragActor = true
  self.bIsDragActor = true
end

function M:OnBtnReleased()
  Utils.ScreenPrint("WBP_Guild_Construct_BtnDrag_C:BtnReleased")
  self.Parent.bIsDragActor = false
  self.bIsDragActor = false
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  Utils.ScreenPrint("WBP_Guild_Construct_BtnDrag_C:OnMouseButtonDown")
  self.Parent.bIsDragActor = true
  self.bIsDragActor = true
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  Utils.ScreenPrint("WBP_Guild_Construct_BtnDrag_C:OnMouseButtonUp")
  self.Parent.bIsDragActor = false
  self.bIsDragActor = false
  return UE4.UWidgetBlueprintLibrary.Unhandled()
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
