require("UnLua")
local BP_HeadWidgetComponent_C = Class("BluePrints.Common.TimerMgr")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local Const = require("Const")

function BP_HeadWidgetComponent_C:Initialize(Initializer)
  self.OwnerLocation = nil
  self.State = 0
end

function BP_HeadWidgetComponent_C:ReceiveBeginPlay()
  self.Owner = self:GetOwner()
  self.WidgetRegistryKey = self.Owner
  UIManager(self):AddWidgetComponentToList(self.WidgetRegistryKey, "NPCHeadWidget", self)
  self.Overridden.ReceiveBeginPlay(self)
end

function BP_HeadWidgetComponent_C:ReceiveEndPlay(EndPlayReason)
  UIManager(self):RemoveWidgetComponentToList(self.WidgetRegistryKey, "NPCHeadWidget")
  self.WidgetRegistryKey = nil
  self.Owner = nil
end

function BP_HeadWidgetComponent_C:SetWidgetHiddenByTag(bHidden, Tag)
  self:SetUniformWidgetHideTag(bHidden, Tag)
end

local function CalculateBubbleTime(Text, bShortBubble)
  local Language = CommonConst.SystemLanguage
  local Size = 3.0
  if Language == CommonConst.SystemLanguages.EN then
    Size = 2.0
  end
  local Len = string.len(Text) / 3.0
  local LineCount = Len / (bShortBubble and 10 or 22)
  return math.max(LineCount * Const.BubbleTimePerLine, Const.BubbleTimePerLine)
end

function BP_HeadWidgetComponent_C:EnableBubbleWidget(TextMapId, Time, bShortBubble)
  local WidgetName = "Long_Bubble"
  if bShortBubble then
    WidgetName = "Short_Bubble"
  end
  self:DisableBubbleTyped(WidgetName)
  if self.DisableBubbleTimer then
    self:RemoveTimer(self.DisableBubbleTimer)
    self.DisableBubbleTimer = nil
  end
  local Text = GText(TextMapId)
  if Time and Time < 0 then
    Time = CalculateBubbleTime(Text, bShortBubble)
  end
  self:EnableBubbleTyped(Text, WidgetName)
  if Time and Time >= 0 then
    self.DisableBubbleTimer = self:AddTimer(Time, function()
      self:DisableBubbleTyped(WidgetName)
    end, false)
  end
end

return BP_HeadWidgetComponent_C
