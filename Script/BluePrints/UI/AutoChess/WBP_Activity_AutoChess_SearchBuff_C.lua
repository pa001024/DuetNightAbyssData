require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.BuffImages = {}
  self:BindEvents()
  self.TextEmpty:SetText(GText("UI_AutoChess_NeedChooseBuff"))
end

function M:BindEvents()
  if self.Btn_Cancel then
    self.Btn_Cancel.OnClicked:Clear()
    self.Btn_Cancel.OnClicked:Add(self, self.OnBtnCancelClicked)
  end
end

function M:Refresh(BuffList, SizeBoxSizeX)
  self.BuffList = BuffList or {}
  self:ClearBuffImages()
  local bHasBuff = #self.BuffList > 0
  if self.TextEmpty then
    self.TextEmpty:SetVisibility(bHasBuff and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  local ImageTotalSize = 0
  local HBOffset = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.HB_Text):GetOffsets()
  local HBTextSize = SizeBoxSizeX - HBOffset.Left - HBOffset.Right
  local OneImageSize = self.Image_BUff.Brush.ImageSize.X + self.HB_Text.InnerSlotPadding.X
  if self.Image_BUff then
    self.Image_BUff:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  for _, BuffId in ipairs(self.BuffList) do
    if (HBTextSize - ImageTotalSize) / OneImageSize >= 1 then
      self:AddBuffImage(BuffId)
      ImageTotalSize = ImageTotalSize + OneImageSize
      self.Image_More:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Image_More:SetVisibility(UIConst.VisibilityOp.Visible)
    end
  end
end

function M:AddBuffImage(BuffId)
  local BuffData = DataMgr.ChallengeBuff[BuffId]
  local IconPath = BuffData and BuffData.BuffIcon
  if not IconPath or not self.Image_BUff then
    return
  end
  local NewImage = self:CopyImage(self.Image_BUff)
  if not NewImage then
    return
  end
  local Icon = LoadObject(IconPath)
  if Icon then
    NewImage:SetBrushFromTexture(Icon)
  end
  NewImage:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.HB_Text then
    self.HB_Text:AddChild(NewImage)
  end
  table.insert(self.BuffImages, NewImage)
end

function M:CopyImage(InImage)
  if not InImage then
    return nil
  end
  local Image = NewObject(UE4.UImage)
  Image.bUsing4KImageDesign = InImage.bUsing4KImageDesign
  Image:SetBrush(InImage.Brush)
  Image:SetColorAndOpacity(InImage.ColorAndOpacity)
  return Image
end

function M:ClearBuffImages()
  for _, Img in ipairs(self.BuffImages or {}) do
    if IsValid(Img) then
      Img:RemoveFromParent()
    end
  end
  self.BuffImages = {}
end

function M:OnBtnCancelClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  
  local function OnBuffEdited()
    local OwnerPanel = self.Owner
    if OwnerPanel and OwnerPanel.RefreshBuffs then
      OwnerPanel:RefreshBuffs()
    end
  end
  
  local InitParams = {bSkipConfirmSave = false, bShowTitleTips = false}
  UIManager(self):LoadUINew("AutoChessShareBuff", InitParams, self.SquadIdx, OnBuffEdited)
end

function M:SetSquadIdx(SquadIdx)
  self.SquadIdx = SquadIdx
end

function M:Destruct()
  self:ClearBuffImages()
end

return M
