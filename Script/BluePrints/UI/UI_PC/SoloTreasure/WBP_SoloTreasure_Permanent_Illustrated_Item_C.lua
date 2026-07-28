require("UnLua")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M.EItemType = {
  Small = 1,
  Medium = 2,
  Large = 3
}
M.EItemState = {UnLocked = 0, Locked = 1}
local DEFAULT_ZOOM_TABLE = {
  [M.EItemType.Small] = 1.0,
  [M.EItemType.Medium] = 1.0,
  [M.EItemType.Large] = 1.0
}
local QUALITY_BRUSH_PREFIX = "Image_Quality_"
local SEAL_COLOR_PREFIX = "Color_"

function M:Initialize(Initializer)
  self.CurType = M.EItemType.Small
  self.ItemCur = nil
  self.State = M.EItemState.Locked
  self.TreasureId = 0
  self.ShowRarityToBrushId = {
    [2] = 1,
    [4] = 2,
    [5] = 3,
    [6] = 4
  }
  self.RarityToUnlockSound = {
    [2] = "event:/ui/activity/sdc_item_unlock_green",
    [4] = "event:/ui/activity/sdc_item_unlock_purple",
    [5] = "event:/ui/activity/sdc_item_unlock_gold",
    [6] = "event:/ui/activity/sdc_item_unlock_red"
  }
end

function M:Construct()
  self:BindAnimations()
end

function M:RefreshItem(Info, bPlayAnim)
  if not self:InitItemInfo(Info) then
    return
  end
  self:StopAllAnimes()
  self:PlayAnime(bPlayAnim)
end

function M:InitItemInfo(Info)
  if nil == Info or type(Info) ~= "table" then
    DebugPrint(ErrorTag, string.format("cjh @ Illustrated_Item: RefreshItem failed, Info=%s", tostring(Info)))
    return false
  end
  self.CurType = Info.Type
  self.TreasureId = Info.TreasureId
  self.State = Info.State
  local TreasureData = DataMgr.ExtractionTreasure[self.TreasureId]
  if nil == TreasureData then
    DebugPrint(ErrorTag, string.format("cjh @ Illustrated_Item: RefreshItem failed, TreasureId=%s, TreasureData=%s", tostring(self.TreasureId), tostring(TreasureData)))
    return false
  end
  local Item_Cur
  if self.CurType == M.EItemType.Small then
    self.WS_Type:SetActiveWidgetIndex(2)
    Item_Cur = self.Item_S
  elseif self.CurType == M.EItemType.Medium then
    self.WS_Type:SetActiveWidgetIndex(1)
    Item_Cur = self.Item_M
  elseif self.CurType == M.EItemType.Large then
    self.WS_Type:SetActiveWidgetIndex(0)
    Item_Cur = self.Item_L
  end
  self.ItemCur = Item_Cur
  if self.State == M.EItemState.UnLocked then
    Item_Cur.Text_Name:SetText(GText(TreasureData.Name))
    Item_Cur.Num_Value:SetText(TreasureData.TreasureValue)
    Item_Cur.Icon_Treasure:SetColorAndOpacity(Item_Cur.Image_Normal)
  else
    Item_Cur.Text_Lock:SetText(GText("UI_Play_TreasureHunt_TreasureArchiveLocked"))
    Item_Cur.Icon_Treasure:SetColorAndOpacity(Item_Cur.Image_Lock)
  end
  local ShowRarity = self:GetShowRarity(TreasureData.TreasureRarity)
  local QualityBrushName = QUALITY_BRUSH_PREFIX .. self.ShowRarityToBrushId[ShowRarity]
  local SealColorName = SEAL_COLOR_PREFIX .. self.ShowRarityToBrushId[ShowRarity]
  if Item_Cur.Image_Quality and Item_Cur[QualityBrushName] then
    Item_Cur.Image_Quality:SetBrush(Item_Cur[QualityBrushName])
  else
    DebugPrint(ErrorTag, string.format("cjh @ Illustrated_Item: QualityBrush '%s' not found, TreasureId=%s, ShowRarity=%d", QualityBrushName, tostring(self.TreasureId), ShowRarity))
  end
  if Item_Cur[SealColorName] then
    if Item_Cur.Image_Seal then
      Item_Cur.Image_Seal:SetColorAndOpacity(Item_Cur[SealColorName])
    end
    if Item_Cur.SetFontColor then
      Item_Cur:SetFontColor(self.ShowRarityToBrushId[ShowRarity] - 1)
    end
  else
    DebugPrint(ErrorTag, string.format("cjh @ Illustrated_Item: SealColor '%s' not found, TreasureId=%s, ShowRarity=%d", SealColorName, tostring(self.TreasureId), ShowRarity))
  end
  local IconPath = self.CurType == M.EItemType.Large and TreasureData.Icon or TreasureData.SettlementIcon
  local ZoomTable = TreasureData.TreasureZoom or DEFAULT_ZOOM_TABLE
  local Zoom = ZoomTable[self.CurType] or DEFAULT_ZOOM_TABLE[self.CurType]
  local IconTexture = LoadObject(IconPath)
  if not self:SetItemCurTreasureIcon(Item_Cur, IconTexture, Zoom) then
    DebugPrint(ErrorTag, string.format("cjh @ Illustrated_Item: IconTexture Put failed, TreasureId=%s, IconPath=%s, Icon_Treasure=%s", tostring(self.TreasureId), tostring(IconPath), tostring(Item_Cur.Icon_Treasure)))
  end
  return true
end

function M:SetItemCurTreasureIcon(Item_Cur, IconTexture, Zoom)
  if nil == IconTexture or nil == Item_Cur or nil == Item_Cur.Icon_Treasure then
    return false
  end
  local TextureSize = UE4.FVector2D(IconTexture:Blueprint_GetSizeX(), IconTexture:Blueprint_GetSizeY())
  local BrushSize = TextureSize * Zoom
  Item_Cur.Icon_Treasure:SetBrushFromTexture(IconTexture)
  Item_Cur.Icon_Treasure:SetBrushSize(BrushSize)
  if Item_Cur.VX_Icon_Treasure then
    Item_Cur.VX_Icon_Treasure:SetBrushSize(BrushSize)
    local DynamicMaterial = Item_Cur.VX_Icon_Treasure:GetDynamicMaterial()
    if DynamicMaterial then
      DynamicMaterial:SetTextureParameterValue("MainTex", IconTexture)
    end
  end
  return true
end

function M:GetShowRarity(Rarity)
  local TreasureRarityInfo = DataMgr.ExtractionTreasureRarity
  if TreasureRarityInfo then
    return TreasureRarityInfo[Rarity].ShowRarity
  end
  return 2
end

function M:CallServerAlreadyDisplayNewTreasure()
  local Avatar = GWorld:GetAvatar()
  if Avatar and self.TreasureId and SoloTreasurePermanentDataModel:IsFirstShowNewTreasureIllustrated(self.TreasureId) then
    Avatar:TreasureHuntsAlreadyDisplayNewTreasure(self.TreasureId)
  end
end

function M:PlayInAnime()
  self.ItemCur:PlayAnimationForward(self.ItemCur.In)
end

function M:PlayLockInAnime()
  self.ItemCur:PlayAnimationForward(self.ItemCur.Lock_In)
end

function M:PlayUnlockAnime()
  self:CallServerAlreadyDisplayNewTreasure()
  local TreasureData = DataMgr.ExtractionTreasure[self.TreasureId]
  local ShowRarity = TreasureData and self:GetShowRarity(TreasureData.TreasureRarity) or 2
  local UnlockSound = self.RarityToUnlockSound[ShowRarity]
  if UnlockSound then
    AudioManager(self):PlayUISound(self, UnlockSound, nil, nil)
  end
  self.ItemCur:PlayAnimationForward(self.ItemCur.UnLock)
end

function M:PlayAnime(bPlayAnim)
  if bPlayAnim then
    if SoloTreasurePermanentDataModel:IsFirstShowNewTreasureIllustrated(self.TreasureId) then
      self:PlayLockInAnime()
    elseif self.State == M.EItemState.UnLocked then
      self:PlayInAnime()
    else
      self:PlayLockInAnime()
    end
  elseif self.State == M.EItemState.UnLocked then
    self:CallServerAlreadyDisplayNewTreasure()
    self.ItemCur:PlayAnimationForward(self.ItemCur.Normal)
  else
    self.ItemCur:PlayAnimationForward(self.ItemCur.Lock)
  end
end

function M:StopAllAnimes()
  if self.ItemCur == nil then
    return
  end
  self.ItemCur:StopAllAnimations()
end

function M:OnLockInAnimationFinished()
  if SoloTreasurePermanentDataModel:IsFirstShowNewTreasureIllustrated(self.TreasureId) then
    self:PlayUnlockAnime()
  end
end

function M:BindAnimations()
  self.Item_S:BindToAnimationFinished(self.Item_S.Lock_In, {
    self,
    self.OnLockInAnimationFinished
  })
  self.Item_M:BindToAnimationFinished(self.Item_M.Lock_In, {
    self,
    self.OnLockInAnimationFinished
  })
  self.Item_L:BindToAnimationFinished(self.Item_L.Lock_In, {
    self,
    self.OnLockInAnimationFinished
  })
end

return M
