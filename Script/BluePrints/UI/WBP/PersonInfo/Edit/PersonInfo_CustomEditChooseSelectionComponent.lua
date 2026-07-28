require("UnLua")
local Component = {}

function Component:_InitChooseSelectionState()
  self.SelectedContent = nil
end

function Component:GetSelectedContent()
  return self.SelectedContent
end

function Component:SetSelectedContent(Content)
  local PreviousSelectedContent = self.SelectedContent
  if PreviousSelectedContent == Content then
    return
  end
  self.SelectedContent = Content
  self.LastSelectedContent = Content
  self.LastSelectedListContent = Content
  self:_RefreshContentSelectedState(PreviousSelectedContent)
  self:_RefreshContentSelectedState(Content)
end

function Component:ClearSelectedContent()
  self:SetSelectedContent(nil)
end

function Component:IsSelectedContent(Content)
  return nil ~= Content and self.SelectedContent == Content
end

function Component:_RefreshContentSelectedState(Content)
  if not Content then
    return
  end
  local EntryWidget = self:_GetChooseEntryWidget(Content)
  if not EntryWidget then
    return
  end
  self:RefreshEntryVisual(Content, EntryWidget)
end

return Component
