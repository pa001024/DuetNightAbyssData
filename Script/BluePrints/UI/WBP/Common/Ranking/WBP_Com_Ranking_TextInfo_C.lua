require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function DisableTextAutoWrap(TextBlock)
  if TextBlock and TextBlock.SetAutoWrapText then
    TextBlock:SetAutoWrapText(false)
  end
end

function M:Init(Data)
  Data = Data or {}
  if not self._bAutoWrapDisabled then
    self._bAutoWrapDisabled = true
    DisableTextAutoWrap(self.Text_Score_1)
    DisableTextAutoWrap(self.Text_Score_2)
  end
  local Text1 = Data.Text1
  local Text2 = Data.Text2
  local bHasText1 = nil ~= Text1 and "" ~= Text1
  local bHasText2 = nil ~= Text2 and "" ~= Text2
  local bHasValue = bHasText1 or bHasText2
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(bHasValue and 0 or 1)
  end
  if not bHasValue then
    return
  end
  if self.Text_Score_1 then
    if bHasText1 then
      self.Text_Score_1:SetText(tostring(Text1))
      self.Text_Score_1:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Text_Score_1:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.Text_Score_2 then
    if bHasText2 then
      self.Text_Score_2:SetText(tostring(Text2))
      self.Text_Score_2:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.Text_Score_2:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

return M
