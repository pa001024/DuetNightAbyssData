require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.Btn_Click:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Click.OnPressed:Add(self, self.OnBtnPressed)
  self.Btn_Click.OnReleased:Add(self, self.OnBtnReleased)
  self.Btn_Click.OnClicked:Add(self, self.OnMouseButtonDown)
end

function M:OnPressed()
  Utils.ScreenPrint("pressed")
end

function M:OnBtnPressed()
  self.bPressed = true
  Utils.ScreenPrint("BtnPressed")
end

function M:OnBtnReleased()
  self.bPressed = false
  Utils.ScreenPrint("BtnReleased")
end

function M:TestClick()
  Utils.ScreenPrint("2")
end

function M:GetGuildManager()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  return GameMode and GameMode:GetGuildConstructManager()
end

function M:GetOwnedCount(UnitId)
  local GuildManager = self:GetGuildManager()
  if not GuildManager or not GuildManager.GuildItemCount then
    return 0
  end
  local ItemCount = GuildManager.GuildItemCount[UnitId]
  return ItemCount and ItemCount.TotalCount or 0
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.UnitId = Content.UnitId
  self.Count = self:GetOwnedCount(Content.UnitId)
  self.PlacedCallBack = Content.PlacedCallBack
  local Name = Content.Name
  local IconPath = Content.Icon
  local Count = self.Count
  UResourceLibrary.LoadObjectAsync(self, IconPath, {
    self,
    function(_, Icon)
      self.Icon:SetBrushResourceObject(Icon)
    end
  })
  self.Text_Name:SetText(GText(Name))
  if Count <= 1 then
    self:PlayAnimation(self.Lock)
    return
  end
  self:PlayAnimation(self.In)
  self.Text_Num:SetText(tostring(Count))
end

function M:RefreshCount(Count)
  self.Count = Count or self:GetOwnedCount(self.UnitId)
  if self.Content then
    self.Content.Count = self.Count
  end
  if self.Count <= 1 then
    self:PlayAnimation(self.Lock)
    self.Text_Num:SetText(tostring(self.Count))
    return
  end
  self:PlayAnimation(self.In)
  self.Text_Num:SetText(tostring(self.Count))
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  if self.ItemDetailsMenuAnchor then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    local GuildManager = GameMode and GameMode.GetGuildConstructManager and GameMode:GetGuildConstructManager()
    local Content = {
      ItemType = "GuildConstruct",
      bHideGamePad = true,
      UnitId = self.UnitId,
      LeftNum = self.Count,
      PlacedNum = GuildManager and GuildManager:GetSceneActorCountByUnitId(self.UnitId) or 0,
      MenuPlacement = EMenuPlacement.MenuPlacement_AboveAnchor,
      PlaceCallback = self.PlacedCallBack
    }
    self.ItemDetailsMenuAnchor:OpenItemDetailsWidget(false, Content)
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.RightMouseButton) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  return UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE4.EKeys.LeftMouseButton)
end

function M:CreatePayload()
  local Payload = NewObject(UIUtils.GetCommonItemContentClass())
  Payload.UnitId = self.UnitId
  return Payload
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  local Op = NewObject(UIUtils.GetCommonDragDropOperationClass())
  Op.Tag = "WBP_Com_Item_Universal_L_C"
  Op.DefaultDragVisual = self
  Op.Pivot = UE4.EDragPivot.MouseDown
  Op.Payload = self:CreatePayload()
  return Op
end

return M
