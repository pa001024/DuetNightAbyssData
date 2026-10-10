local Host = {}
local STICKERS_EDIT_BP_PATH = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/EditModel/WBP_PersonalInfo_EditModel_StickersEdit.WBP_PersonalInfo_EditModel_StickersEdit'"

function Host:_ResolveStickerPreviewController()
  return self.EditRootController or self.RootEditPage
end

function Host:_ResolveStickerHostCanvas()
  if self.GetStickerPreviewHostCanvas then
    local Canvas = self:GetStickerPreviewHostCanvas()
    if Canvas then
      return Canvas
    end
  end
  return self.Group_Stickers
end

function Host:_ApplyStickerPreviewCanvasSlot(EditWidget)
  if not EditWidget then
    return
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(EditWidget)
  if not Slot then
    return
  end
  local Anchors = UE4.FAnchors()
  Anchors.Minimum = FVector2D(0.5, 0.5)
  Anchors.Maximum = FVector2D(0.5, 0.5)
  Slot:SetAnchors(Anchors)
  Slot:SetAlignment(FVector2D(0.5, 0.5))
  Slot:SetPosition(FVector2D(0, 0))
  if Slot.SetAutoSize then
    Slot:SetAutoSize(true)
  end
end

function Host:ShowConfirmedStickerPreview(StickerData)
  local HostCanvas = self:_ResolveStickerHostCanvas()
  if not HostCanvas or type(StickerData) ~= "table" then
    return
  end
  if StickerData.StickerId == nil or StickerData.StickerId == "" then
    self:ClearConfirmedStickerPreview()
    return
  end
  self:ClearConfirmedStickerPreview()
  HostCanvas = self:_ResolveStickerHostCanvas()
  if not HostCanvas then
    return
  end
  local Widget = UIManager(self):CreateWidget(STICKERS_EDIT_BP_PATH)
  if not Widget then
    return
  end
  HostCanvas:AddChildToCanvas(Widget)
  self:_ApplyStickerPreviewCanvasSlot(Widget)
  if Widget.InitStickerDisplay then
    Widget:InitStickerDisplay(StickerData, self)
  end
  self.ConfirmedStickerWidget = Widget
  HostCanvas:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function Host:ClearConfirmedStickerPreview()
  if self.ConfirmedStickerWidget and IsValid(self.ConfirmedStickerWidget) then
    self.ConfirmedStickerWidget:RemoveFromParent()
  end
  self.ConfirmedStickerWidget = nil
  local HostCanvas = self:_ResolveStickerHostCanvas()
  if HostCanvas then
    HostCanvas:ClearChildren()
    HostCanvas:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function Host:RefreshConfirmedStickerPreviewFromDraft()
  local Controller = self:_ResolveStickerPreviewController()
  local StickerData
  if Controller and Controller.GetWorkingStickerData then
    StickerData = Controller:GetWorkingStickerData()
  elseif self.GetWorkingStickerData then
    StickerData = self:GetWorkingStickerData()
  elseif self.GetStickerData then
    StickerData = self:GetStickerData()
  end
  if type(StickerData) == "table" and StickerData.StickerId ~= nil and StickerData.StickerId ~= "" then
    self:ShowConfirmedStickerPreview(StickerData)
  else
    self:ClearConfirmedStickerPreview()
  end
end

function Host.BindMethods(Target)
  if type(Target) ~= "table" then
    return
  end
  Target._ResolveStickerPreviewController = Host._ResolveStickerPreviewController
  Target._ResolveStickerHostCanvas = Host._ResolveStickerHostCanvas
  Target._ApplyStickerPreviewCanvasSlot = Host._ApplyStickerPreviewCanvasSlot
  Target.ShowConfirmedStickerPreview = Host.ShowConfirmedStickerPreview
  Target.ClearConfirmedStickerPreview = Host.ClearConfirmedStickerPreview
  Target.RefreshConfirmedStickerPreviewFromDraft = Host.RefreshConfirmedStickerPreviewFromDraft
end

return Host
