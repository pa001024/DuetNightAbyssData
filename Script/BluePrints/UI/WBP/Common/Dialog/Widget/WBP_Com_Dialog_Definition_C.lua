require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  local WidgetCount = 0
  local Panel = self.WB_Definition
  local Widget = Panel:GetChildAt(0)
  if not Widget then
    return
  end
  local UIManager = UIManager(self)
  local WidgetClass = UGameplayStatics.GetObjectClass(Widget)
  local Contents = {}
  local DefinitionItems = Params and Params.DefinitionItems or {}
  for _, PData in pairs(DefinitionItems) do
    local Content = {
      Index = PData.Index or 0
    }
    Content.Name = GText(PData.Name)
    Content.Des = GText(PData.Des)
    table.insert(Contents, Content)
  end
  table.sort(Contents, function(a, b)
    return a.Index < b.Index
  end)
  Panel:ClearChildren()
  for _, Content in ipairs(Contents) do
    local Widget = UIManager:CreateWidget(WidgetClass)
    Content.Widget = Widget
    Panel:AddChild(Widget)
    Widget:OnListItemObjectSet(Content)
  end
  if Params and Params.CurrentItemIndex then
    self:SetHighLightItem(Params.CurrentItemIndex)
  end
  self:AddTimer(0.1, function()
    self:UpdateScrollHint()
  end)
end

function M:SetHighLightItem(Index)
  local Panel = self.WB_Definition
  local Item = Panel:GetChildAt(Index)
  if Item then
    self:AddTimer(0.1, function()
      self.EMScrollBox:ScrollWidgetIntoView(Item.Widget, true, UE4.EDescendantScrollDestination.IntoView)
      Item:SetHighLight(true)
    end)
  end
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.EMScrollBox:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.EMScrollBox:GetScrollOffsetOfEnd())
    self.EMScrollBox:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function M:UpdateScrollHint()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  local bCanScroll = UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox)
  if bCanScroll then
    self:InitHintGamepadBtn()
  end
end

function M:InitHintGamepadBtn()
  self.Owner.Gamepad_Shortcut01:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("RV", self.CurGamepadName)
      }
    },
    Desc = GText("UI_Controller_Slide")
  })
  self.Owner.Gamepad_Shortcut01:SetVisibility(UIConst.VisibilityOp.Visible)
end

return M
