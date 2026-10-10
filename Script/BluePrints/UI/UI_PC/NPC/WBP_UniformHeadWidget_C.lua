require("UnLua")
local Processors = require("BluePrints.UI.UI_PC.NPC.HeadUIProcessors")
local M = Class({
  "Blueprints.UI.BP_UIState_C"
})

function M:Initialize(Initializer)
  self.Super.Initialize(self, Initializer)
end

function M:Construct(...)
  M.Super.Construct(self, ...)
  self:InitSubWidgets()
end

function M:InitSubWidgets()
  if self.Processors then
    return
  end
  local Bubble = Processors.BubbleProcessor.new(self)
  self.Processors = {
    Name = Processors.NameProcessor.new(self),
    Long_Bubble = Bubble,
    Short_Bubble = Bubble,
    Impression = Processors.ImpressionProcessor.new(self),
    HeadIcon = Processors.HeadIconProcessor.new(self),
    NpcSideIndicator = Processors.GuidePointProcessor.new(self),
    Title = Processors.TitleProcessor.new(self),
    Bubble_Reward = Processors.RewardProcessor.new(self),
    Bubble_Emoji = Processors.EmojiProcessor.new(self)
  }
  self.ActiveCount = 0
  DebugPrint("[HeadUI] InitSubWidgets: processors registered", self)
end

function M:EnableWidget(WidgetName, ...)
  local P = self.Processors[WidgetName]
  if not P then
    DebugPrint("[HeadUI] EnableWidget: no processor for", WidgetName)
    return
  end
  local Was = P.bActive
  P:Enable(WidgetName, ...)
  if P.bActive ~= Was then
    self.ActiveCount = self.ActiveCount + (P.bActive and 1 or -1)
    self:NotifyActiveCountChanged(self.ActiveCount)
  end
  DebugPrint("[HeadUI] EnableWidget:", WidgetName, "bActive:", Was, "->", P.bActive, "ActiveCount:", self.ActiveCount)
end

function M:DisableWidget(WidgetName)
  local P = self.Processors[WidgetName]
  if not P then
    return
  end
  local Was = P.bActive
  P:Disable()
  if P.bActive ~= Was then
    self.ActiveCount = self.ActiveCount + (P.bActive and 1 or -1)
    self:NotifyActiveCountChanged(self.ActiveCount)
  end
  DebugPrint("[HeadUI] DisableWidget:", WidgetName, "bActive:", Was, "->", P.bActive, "ActiveCount:", self.ActiveCount)
end

function M:OnSubWidgetHideTagChanged(WidgetName, bHidden)
  DebugPrint("[HeadUI] OnSubWidgetHideTagChanged:", WidgetName, "bHidden:", bHidden)
  local P = self.Processors[WidgetName]
  if P then
    P:SetHidden(bHidden)
  end
end

function M:ResetForPool()
  DebugPrint("[HeadUI] ResetForPool: reset processors + ActiveCount", self)
  local seen = {}
  for _, P in pairs(self.Processors or {}) do
    if not seen[P] then
      seen[P] = true
      P:Reset()
    end
  end
  self.ActiveCount = 0
  self.Overridden.ResetForPool(self)
end

return M
