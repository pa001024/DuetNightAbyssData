require("UnLua")
local Component = {}

function Component:InitSubWidgetManager(RootWidget, MainTabId)
  self.Group_Root = RootWidget
  self.MainTabId = MainTabId
  self.SubUI = {}
  self.CurSubUI = nil
  self.CurTabId = nil
end

function Component:OpenSubUI(WidgetInfo, ...)
  local TabId
  if WidgetInfo and WidgetInfo.Idx then
    TabId = WidgetInfo.Idx
  end
  if self.CurTabId == TabId then
    return self.CurSubUI
  end
  if self.CurSubUI and self.CurSubUI.SwitchOut then
    self.CurSubUI:SwitchOut(...)
  end
  if TabId then
    if not self.SubUI[TabId] then
      if TabId ~= self.MainTabId then
        local Widget = self:CreateWidgetNew(TabId)
        if Widget then
          Widget.Root = self
          Widget.WidgetInfo = WidgetInfo
          if self.CurSubUI then
            Widget.PreWidgetInfo = self.CurSubUI.WidgetInfo
          end
          if self.Group_Root.AddChildToOverlay then
            self.Group_Root:AddChildToOverlay(Widget)
            local OverlaySlot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(Widget)
            if OverlaySlot then
              OverlaySlot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
              OverlaySlot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
              OverlaySlot:SetPadding(FMargin(0, 0, 0, 0))
            end
          else
            self.Group_Root:AddChild(Widget)
            local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Widget)
            if CanvasSlot then
              local Anchors = FAnchors()
              Anchors.Minimum = FVector2D(0, 0)
              Anchors.Maximum = FVector2D(1, 1)
              CanvasSlot:SetOffsets(FMargin(0, 0, 0, 0))
              CanvasSlot:SetAnchors(Anchors)
            end
          end
          self.SubUI[TabId] = Widget
        end
      else
        local Widget = self
        Widget.Root = self
        Widget.WidgetInfo = WidgetInfo
        self.SubUI[TabId] = Widget
      end
    end
    self.CurTabId = TabId
    self.CurSubUI = self.SubUI[TabId]
    if self.CurSubUI and self.CurSubUI.SwitchIn then
      self.CurSubUI:SwitchIn(...)
      if self.CurSubUI.SetFocus then
        self.CurSubUI:SetFocus()
      end
    end
  else
    self:OnCloseAll()
  end
  return self.CurSubUI
end

function Component:ReturnPreWidget()
  if not self.CurSubUI or not self.CurSubUI.PreWidgetInfo then
    if self.OnCloseAll then
      self:OnCloseAll()
    end
  elseif self.CurSubUI then
    self:OpenSubUI(self.CurSubUI.PreWidgetInfo)
  end
end

function Component:OnClickBack()
  if self.CurSubUI and self.CurSubUI ~= self and self.CurSubUI.OnReturnKeyDown then
    self.CurSubUI:OnReturnKeyDown()
  else
    self:ReturnPreWidget()
  end
end

function Component:OnReturnKeyDown()
  UIUtils.PlayCommonBtnSe(self)
  self:OnClickBack()
end

function Component:BP_GetDesiredFocusTarget()
  if self.CurSubUI == self then
    if self.GetDesiredFocusTarget_Main then
      return self:GetDesiredFocusTarget_Main()
    else
      return self
    end
  else
    return self.CurSubUI
  end
end

function Component:ClearAllSubUI()
  if self.SubUI then
    for _, Widget in pairs(self.SubUI) do
      if Widget ~= self then
        Widget:RemoveFromParent()
      end
    end
  end
  self.SubUI = {}
  self.CurSubUI = nil
  self.CurTabId = nil
end

function Component:GetCurrentSubUI()
  return self.CurSubUI
end

function Component:GetCurrentTabId()
  return self.CurTabId
end

function Component:InitOtherPageTab(TabConfigData, DontPlayInAnim, Object, Callback)
  self.Com_Tab:Init(TabConfigData, DontPlayInAnim)
  self.Com_Tab:BindEventOnTabSelected(Object, Callback)
end

return Component
