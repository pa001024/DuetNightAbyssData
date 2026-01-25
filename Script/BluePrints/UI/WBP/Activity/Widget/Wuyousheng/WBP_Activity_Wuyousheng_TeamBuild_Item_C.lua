require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnListItemObjectSet(ItemObject)
  if not ItemObject then
    return
  end
  if ItemObject.IsEmpty then
    self.WS_Item:SetActiveWidgetIndex(1)
  else
    self.Com_Item:OnListItemObjectSet(ItemObject)
    self.WS_Item:SetActiveWidgetIndex(0)
    local TryOutWidget = self:CreateWidgetNew("Wuyousheng_Build_Item_TryOut")
    if ItemObject.Level then
      TryOutWidget.Com_Item_Level.Text_Lv:SetText(ItemObject.Level)
    else
      TryOutWidget.Com_Item_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if ItemObject.IsTryout then
      TryOutWidget.Text_TryOut:SetText(GText("Wuyousheng_Build_Item_TryOut"))
      TryOutWidget.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      TryOutWidget.Text_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
      TryOutWidget.SizeBox_TryOut:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self.Com_Item:AddWidgetToNode(TryOutWidget)
  end
end

return M
