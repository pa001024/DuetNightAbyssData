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
  if self.Owner.Eid then
    UIManager(self):AddWidgetComponentToList(self.Owner.Eid, "NPCHeadWidget", self)
  else
    UIManager(self):AddWidgetComponentToList(self.Owner, "NPCHeadWidget", self)
  end
  self.Overridden.ReceiveBeginPlay(self)
end

function BP_HeadWidgetComponent_C:ReceiveEndPlay(EndPlayReason)
  UIManager(self):RemoveWidgetComponentToList(self.Owner.Eid, "NPCHeadWidget")
  self:TryReleaseWidgetInternal()
  self.Owner = nil
end

function BP_HeadWidgetComponent_C:EnableWidget(WidgetName, ...)
  local Widget = self:GetOrCreateWidget(WidgetName)
  if not IsValid(Widget) then
    return
  end
  Widget:EnableWidget(WidgetName, ...)
end

function BP_HeadWidgetComponent_C:DisableWidget(WidgetName, ...)
  local Widget = self:GetWidget()
  if Widget then
    Widget:DisableWidget(WidgetName, ...)
  end
end

function BP_HeadWidgetComponent_C:NeedForceInit()
  return 0 == self.StateCount
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
  self:DisableWidget(WidgetName)
  if self.DisableBubbleTimer then
    self:RemoveTimer(self.DisableBubbleTimer)
    self.DisableBubbleTimer = nil
  end
  local Text = GText(TextMapId)
  if Time and Time < 0 then
    Time = CalculateBubbleTime(Text, bShortBubble)
  end
  self:EnableWidget(WidgetName, Text, nil, Time)
  if Time and Time >= 0 then
    self.DisableBubbleTimer = self:AddTimer(Time, function()
      self:DisableWidget(WidgetName)
    end, false)
  end
end

return BP_HeadWidgetComponent_C
