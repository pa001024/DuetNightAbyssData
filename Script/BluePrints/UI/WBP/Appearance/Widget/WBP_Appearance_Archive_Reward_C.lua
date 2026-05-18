require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_Reward:SetText(GText("UI_AppearanceScore_RewardPreview"))
  self:GetOriginalOffsets()
end

function M:Destruct()
  self:RecoverOriginalPosition()
end

function M:GetOriginalOffsets()
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Img_Reward)
  local Offsets = CanvasSlot:GetOffsets()
  self.OriginalBottomOffset = Offsets.Bottom
  self.OriginalRightOffset = Offsets.Right
end

function M:RecoverOriginalPosition()
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Img_Reward)
  local Offsets = CanvasSlot:GetOffsets()
  Offsets.Bottom = self.OriginalBottomOffset
  Offsets.Right = self.OriginalRightOffset
  CanvasSlot:SetOffsets(Offsets)
end

function M:Init(Parame)
  self:InitOwner(Parame.Owner)
  self:InitTitle(Parame.Title, Parame.Des)
  self:InitBigReward(Parame.Icon, Parame.IsHeadshot)
  self:InitList(Parame.RewardView)
end

function M:InitOwner(Owner)
  if Owner then
    self.Owner = Owner
  end
end

function M:InitTitle(Title, Des)
  if Title then
    self.Text_Title:SetText(Title)
  end
  if Des then
    self.Text_Info:SetText(Des)
  end
end

function M:InitBigReward(IconPath, IsHeadshot)
  if IconPath then
    local ImgObj = LoadObject(IconPath)
    local ImgDynMaterial = self.Img_Reward:GetDynamicMaterial()
    if ImgDynMaterial then
      ImgDynMaterial:SetTextureParameterValue("IconTex", ImgObj)
    end
  end
  local TargetSize = self.ItemIcon
  if IsHeadshot then
    TargetSize = self.ItemHead
  end
  local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.Img_Reward)
  local Offsets = CanvasSlot:GetOffsets()
  Offsets.Bottom = self.OriginalBottomOffset * TargetSize
  Offsets.Right = self.OriginalRightOffset * TargetSize
  CanvasSlot:SetOffsets(Offsets)
end

function M:InitList(RewardViewId)
  self.List_Reward:ClearListItems()
  if RewardViewId then
    local RewardInfo = DataMgr.RewardView[RewardViewId]
    local Ids = RewardInfo.Id or {}
    local RewardCount = RewardInfo.Quantity or {}
    local TableName = RewardInfo.Type or {}
    for i = 1, #Ids do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      local ItemId = Ids[i]
      Content.IsShowDetails = true
      Content.Id = ItemId
      if RewardCount[i] then
        if #RewardCount[i] > 1 then
          Content.MaxCount = RewardCount[i][2]
        end
        Content.Count = RewardCount[i][1]
      end
      Content.Icon = ItemUtils.GetItemIconPath(ItemId, TableName[i])
      Content.Rarity = ItemUtils.GetItemRarity(ItemId, TableName[i])
      Content.ItemType = TableName[i]
      Content.OnMenuOpenChangedEvents = {
        Obj = self,
        Callback = self.ItemMenuAnchorChanged
      }
      self.List_Reward:AddItem(Content)
    end
  end
end

function M:ItemMenuAnchorChanged(IsOpen)
  if self.Owner then
    self.Owner:ItemMenuAnchorChanged(IsOpen)
  end
end

return M
