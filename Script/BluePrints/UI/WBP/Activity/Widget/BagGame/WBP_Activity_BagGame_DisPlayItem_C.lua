require("UnLua")
local BagGameModel = require("BluePrints.UI.WBP.Activity.Widget.BagGame.BagGameModel")
local Const = UIConst.GamePadKey
local ItemType = BagGameModel.ItemType
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.Activity.Widget.BagGame.Activity_BagGame_DragComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self.Switch_Type:SetVisibility(UIConst.VisibilityOp.Visible)
  self.Text_Score01:SetText(GText("UI_GameEvent_BagGame_ItemScore"))
  self.Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self:Init(Content, Content.PlayScreen)
  if self.IsEmpty then
    return
  end
  local SwitchIndex = Content.SwitchIndex or 0
  self.Switch_Type:SetActiveWidgetIndex(SwitchIndex)
  if self.Overlay_Icon then
    if 2 == SwitchIndex then
      self.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  self:SetCallbacks({
    OnDragDetectedCallback = function(self, PointerEvent, Operation)
      Content.SwitchIndex = 1
      self.Switch_Type:SetActiveWidgetIndex(1)
      if Operation and Operation.DefaultDragVisual and Operation.DefaultDragVisual.SetItemSize then
        Operation.DefaultDragVisual:SetItemSize()
      end
      if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
        self.PlayScreen:OnDragStateChanged(true)
      end
    end,
    OnDragCancelCallback = function(self, PointerEvent, Operation)
      Content.SwitchIndex = 0
      local Screen = self.PlayScreen or Content.PlayScreen
      if Screen then
        Screen:SetDisPlayItemSwitchIndex(Content.DisPlayItemId, 0)
        Screen:OnDragStateChanged(false)
      else
        self.Switch_Type:SetActiveWidgetIndex(0)
      end
    end
  })
end

function M:BP_OnEntryReleased()
end

function M:SyncDisplayFromContent()
  if not self.Content then
    return
  end
  if self.IsEmpty then
    return
  end
  local Content = self.Content
  if Content.ItemType == ItemType.Gun then
    self:SetAmmoNumber(Content.CurrentAmmo or 0, Content.MaxAmmo or 0)
  elseif Content.ItemType == ItemType.Ammo then
    self:SetStackNumber(Content.CurrentStack or 0)
  else
    self:SetStackNumber(Content.CurrentStack or 0)
  end
  local DisplayScore = BagGameModel:CalculateItemBaseScore({
    BasicPoint = Content.BasicPoint or 0,
    ItemType = Content.ItemType,
    CurrentAmmo = Content.CurrentAmmo or 0,
    CurrentStack = Content.CurrentStack or 0
  })
  self:SetScoreNumber(DisplayScore)
  local SwitchIndex = Content.SwitchIndex or 0
  self.Switch_Type:SetActiveWidgetIndex(SwitchIndex)
  if self.Overlay_Icon then
    if 2 == SwitchIndex then
      self.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:SetItemIconByPath(GUIPath)
  if not self.Image_Icon or type(GUIPath) ~= "string" or "" == GUIPath then
    return
  end
  local IconObj = LoadObject(GUIPath)
  if not IconObj then
    return
  end
  local Material = self.Image_Icon:GetDynamicMaterial()
  if Material then
    Material:SetTextureParameterValue("IconTex", IconObj)
  else
    self.Image_Icon:SetBrushResourceObject(IconObj)
  end
  if IconObj.SourceDimension then
    self.Image_Icon:SetBrushSize(IconObj.SourceDimension)
  elseif IconObj.Blueprint_GetSizeX and IconObj.Blueprint_GetSizeY then
    local textureSize = UE4.FVector2D(IconObj:Blueprint_GetSizeX(), IconObj:Blueprint_GetSizeY())
    self.Image_Icon:SetBrushSize(textureSize)
  end
end

function M:SetIconMirror(IsMirror)
  if not self.Image_Icon then
    return
  end
  local ScaleX = IsMirror and -1 or 1
  self.Image_Icon:SetRenderScale(FVector2D(ScaleX, 1))
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if self.IsEmpty then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local MouseButton = UE4.UKismetInputLibrary.PointerEvent_GetEffectingButton(MouseEvent)
  if MouseButton.KeyName == "LeftMouseButton" then
    local Reply = UE4.UWidgetBlueprintLibrary.DetectDragIfPressed(MouseEvent, self, UE.EKeys.LeftMouseButton)
    return Reply
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:Init(Content, PlayScreen)
  self.Content = Content
  self.PlayScreen = PlayScreen
  self.IsEmpty = Content.IsEmpty or false
  if self.IsEmpty then
    self.DisPlayItemId = nil
    self.Switch_Type:SetActiveWidgetIndex(2)
    if self.Overlay_Icon then
      self.Overlay_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  self.TemplateId = Content.TemplateId
  self.ItemId = Content.ItemId
  self.ItemType = Content.ItemType
  self.bIsOtherType = self.ItemType == ItemType.Other
  self.ItemName = Content.ItemName
  self.BasicPoint = Content.BasicPoint or 0
  self.GUIPath = Content.GUIPath
  self:SetItemIconByPath(self.GUIPath)
  self.CurrentAmmo = Content.CurrentAmmo or 0
  self.MaxAmmo = Content.MaxAmmo or 0
  self.CurrentStack = Content.CurrentStack or 0
  self.MaxStack = Content.MaxStack or 0
  self.IsMirror = Content.IsMirror or false
  self:SetIconMirror(self.IsMirror)
  self.DisPlayItemId = Content.DisPlayItemId or Content.TemplateId or Content.Id
  if self.ItemType == ItemType.Gun then
    if self.Image_Ammo then
      self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self:SetAmmoNumber(self.CurrentAmmo, self.MaxAmmo)
  elseif self.ItemType == ItemType.Ammo then
    if self.Image_Ammo then
      self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self:SetStackNumber(self.CurrentStack)
  else
    if self.Image_Ammo then
      self.Image_Ammo:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:SetStackNumber(self.CurrentStack)
  end
  local DisplayScore = BagGameModel:CalculateItemBaseScore({
    BasicPoint = self.BasicPoint,
    ItemType = self.ItemType,
    CurrentAmmo = self.CurrentAmmo,
    CurrentStack = self.CurrentStack
  })
  self:SetScoreNumber(DisplayScore)
  if Content.ShapeOffsets then
    self.ShapeOffsets = Content.ShapeOffsets
  elseif Content.ItemGrid then
    self.ShapeOffsets = self:ParseItemGrid(Content.ItemGrid)
  else
    self.ShapeOffsets = {
      {0, 0}
    }
  end
  self:SetShapeView()
  self:SetCallbacks({
    OnDragDetectedCallback = function(self, PointerEvent, Operation)
      self.Switch_Type:SetActiveWidgetIndex(1)
      if Operation and Operation.DefaultDragVisual and Operation.DefaultDragVisual.SetItemSize then
        Operation.DefaultDragVisual:SetItemSize()
      end
      if self.PlayScreen and self.PlayScreen.OnDragStateChanged then
        self.PlayScreen:OnDragStateChanged(true)
      end
    end,
    OnDragCancelCallback = function(self, PointerEvent, Operation)
      if self.Content then
        self.Content.SwitchIndex = 0
      end
      local Screen = not self.PlayScreen and self.Content and self.Content.PlayScreen
      if Screen then
        local ItemId = not self.DisPlayItemId and self.Content and self.Content.DisPlayItemId
        if ItemId then
          Screen:SetDisPlayItemSwitchIndex(ItemId, 0)
        end
        Screen:OnDragStateChanged(false)
      else
        self.Switch_Type:SetActiveWidgetIndex(0)
      end
    end
  })
end

function M:ParseItemGrid(ItemGrid)
  return BagGameModel:ParseItemGrid(ItemGrid)
end

function M:SetShapeView()
  if not self.ShapeOffsets then
    return
  end
  local SHAPE_SIZE = 5
  local ShapeMap = {}
  for _, Offset in ipairs(self.ShapeOffsets) do
    local Row = Offset[1]
    local Col = Offset[2]
    local Key = Row .. "_" .. Col
    ShapeMap[Key] = true
  end
  for Row = 0, SHAPE_SIZE - 1 do
    for Col = 0, SHAPE_SIZE - 1 do
      local Index = Row * SHAPE_SIZE + Col
      local IconBg = self["PlayItemIconBg_" .. Index]
      if IconBg then
        local Key = Row .. "_" .. Col
        if ShapeMap[Key] then
          IconBg:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        else
          IconBg:SetVisibility(UIConst.VisibilityOp.Hidden)
        end
      end
    end
  end
end

function M:SetStackNumber(StackNum)
  self.StackNumber = StackNum or 0
  self.CurrentStack = self.StackNumber
  if self.bIsOtherType then
    self.Text_Lable:SetText("x" .. tostring(self.StackNumber))
  else
    self.Text_Lable:SetText(self.StackNumber)
  end
end

function M:SetAmmoNumber(CurrentNum, MaxNum)
  self.CurrentNum = CurrentNum or 0
  self.MaxNum = MaxNum or 0
  self.CurrentAmmo = self.CurrentNum
  self.MaxAmmo = self.MaxNum
  if self.MaxNum > 0 then
    self.Text_Lable:SetText(self.CurrentNum .. "/" .. self.MaxNum)
  else
    self.Text_Lable:SetText(self.CurrentNum)
  end
end

function M:GetDragSyncData()
  return {
    TemplateId = self.TemplateId,
    ItemType = self.ItemType,
    GUIPath = self.GUIPath,
    CurrentAmmo = self.CurrentAmmo or self.CurrentNum or 0,
    MaxAmmo = self.MaxAmmo or self.MaxNum or 0,
    CurrentStack = self.CurrentStack or self.StackNumber or 0,
    MaxStack = self.MaxStack or 0,
    IsMirror = self.IsMirror or false
  }
end

function M:SetScoreNumber(ScoreNum)
  self.Text_ScoreNum:SetText(ScoreNum)
end

function M:OnDragDetected(MyGeometry, PointerEvent)
  if self.IsEmpty then
    return nil
  end
  if self.Content and 2 == self.Content.SwitchIndex then
    return nil
  end
  if self.PlayScreen and self.PlayScreen:HasUnconfirmedItem() then
    self.PlayScreen:ShowCannotDragToast()
    return nil
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/activity/auto_chess_cell_click_remove", nil, nil)
  return self:OnDragDetectedComponent(MyGeometry, PointerEvent, self.DisPlayItemId, self.ShapeOffsets)
end

function M:OnDragLeave(MyGeometry, PointerEvent, Operation)
end

function M:OnDragCancelled(PointerEvent, Operation)
  if Operation and Operation.Tag == "BagGameDisPlayItem" and self.OnDragCancelCallback then
    self.OnDragCancelCallback(self, PointerEvent, Operation)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= Const.FaceButtonBottom then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  if not (not self.IsEmpty and self.PlayScreen) or self.PlayScreen._GamepadState ~= "SCROLL" then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  self.PlayScreen:HandleGamepadInput(InKeyName)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnDrop(MyGeometry, PointerEvent, Operation)
  if not Operation or Operation.Tag ~= "BagGameDisPlayItem" then
    return false
  end
  local DragUI = Operation.DefaultDragVisual
  local Screen = not self.PlayScreen and self.Content and self.Content.PlayScreen
  if DragUI and Screen then
    if DragUI.DisPlayItemId then
      Screen:SetDisPlayItemSwitchIndex(DragUI.DisPlayItemId, 0)
    end
    Screen:DeactivateShapeArea()
    Screen:OnDragStateChanged(false)
  end
  return true
end

return M
