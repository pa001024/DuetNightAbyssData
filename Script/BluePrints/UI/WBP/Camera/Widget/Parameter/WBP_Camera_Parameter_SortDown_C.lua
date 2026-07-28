require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Camera.Widget.Parameter.Camera_Parameter_Widget_Base"
})

function M:Construct()
  M.Super.Construct(self)
  self.Sort_Down:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
  self.Sort_Down:SetShowGamePadKey(false)
end

function M:SetTitle(Text)
  self.Text:SetText(Text)
end

function M:Init(Content)
  M.Super.Init(self, Content)
  local SortBy_List = {}
  for index, value in ipairs(Content.Options) do
    table.insert(SortBy_List, GText(value))
  end
  self.Sort_Down:Init(SortBy_List, nil, self)
end

function M:SelectItem(Idx, bNotifyEvent)
  if bNotifyEvent then
    self.Sort_Down:SelectItem(Idx)
  else
    self.Sort_Down:BindEventOnSelectionsChanged(nil, nil)
    self.Sort_Down:SelectItem(Idx)
    self.Sort_Down:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
  end
end

function M:OnSelectionsChanged(Index)
  local Content = self.Content
  if Content and Content.OnSelectionsChanged then
    Content.OnSelectionsChanged(Content.Owner, Index, Content)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    return self:OnConfirmKeyDown()
  end
  return UIUtils.Unhandled, false
end

function M:OnConfirmKeyDown()
  self.Sort_Down:Activate()
  return UIUtils.Handled, true
end

return M
