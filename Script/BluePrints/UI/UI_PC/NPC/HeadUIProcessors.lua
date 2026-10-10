require("UnLua")
local HeadUIProcessor = {}
HeadUIProcessor.__index = HeadUIProcessor

function HeadUIProcessor.new(Class, host)
  local p = setmetatable({
    Host = host,
    bActive = false,
    bHiddenByTag = false
  }, Class)
  p:Init()
  return p
end

function HeadUIProcessor:Init()
end

function HeadUIProcessor:Enable(...)
end

function HeadUIProcessor:Disable()
end

function HeadUIProcessor:SetHidden(bHidden)
end

function HeadUIProcessor:Reset()
  self.bActive = false
  self.bHiddenByTag = false
end

local TransitiveProcessor = setmetatable({}, {__index = HeadUIProcessor})
TransitiveProcessor.__index = TransitiveProcessor

function TransitiveProcessor:Enable(WidgetName, ...)
  DebugPrint("[HeadUI] Trans Enable:", WidgetName, "bHiddenByTag:", self.bHiddenByTag)
  self.bActive = true
  self.Child:OnEnabled(...)
  self:ApplyHideTagIfActive()
end

function TransitiveProcessor:Disable()
  self.Child:OnDisabled()
  self.bActive = false
end

function TransitiveProcessor:Reset()
  self.Child:ResetForPool()
  HeadUIProcessor.Reset(self)
end

function TransitiveProcessor:SetHidden(bHidden)
  self.bHiddenByTag = bHidden
  self:ApplyHideTagIfActive()
end

function TransitiveProcessor:ApplyHideTagIfActive()
  if not self.bActive or not self.Child then
    return
  end
  local Vis = self.bHiddenByTag and "Collapsed" or "SelfHitTestInvisible"
  if self.bHiddenByTag then
    self.Child:SetVisibility(UE.ESlateVisibility.Collapsed)
  else
    self.Child:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  DebugPrint("[HeadUI] Trans ApplyHide: vis=", Vis, "bActive=", self.bActive)
end

local NameProcessor = setmetatable({}, {__index = TransitiveProcessor})
NameProcessor.__index = NameProcessor

function NameProcessor.new(host)
  return HeadUIProcessor.new(NameProcessor, host)
end

function NameProcessor:Init()
  self.Child = self.Host.Npc_Name_PC
  self.Child:Init(self.Host)
end

local ImpressionProcessor = setmetatable({}, {__index = TransitiveProcessor})
ImpressionProcessor.__index = ImpressionProcessor

function ImpressionProcessor.new(host)
  return HeadUIProcessor.new(ImpressionProcessor, host)
end

function ImpressionProcessor:Init()
  self.Child = self.Host.NPC_Impression
  self.Child:Init(self.Host)
end

local HeadIconProcessor = setmetatable({}, {__index = TransitiveProcessor})
HeadIconProcessor.__index = HeadIconProcessor

function HeadIconProcessor.new(host)
  return HeadUIProcessor.new(HeadIconProcessor, host)
end

function HeadIconProcessor:Init()
  self.Child = self.Host.NPC_ImpressionShop
  self.Child:Init(self.Host)
end

local GuidePointProcessor = setmetatable({}, {__index = TransitiveProcessor})
GuidePointProcessor.__index = GuidePointProcessor

function GuidePointProcessor.new(host)
  return HeadUIProcessor.new(GuidePointProcessor, host)
end

function GuidePointProcessor:Init()
  self.Child = self.Host.Com_GuidePoint
  self.Child:InitNpcSideQuestBubble(self.Host)
end

local BubbleProcessor = setmetatable({}, {__index = HeadUIProcessor})
BubbleProcessor.__index = BubbleProcessor

function BubbleProcessor.new(host)
  return HeadUIProcessor.new(BubbleProcessor, host)
end

function BubbleProcessor:Init()
  self.Switcher = self.Host.NPC_Bubble_Switcher
  self.Host.NPC_Bubble_Short:Init(self.Host)
  self.Host.NPC_Bubble_Long:Init(self.Host)
  self.CurrentType = nil
end

function BubbleProcessor:Enable(WidgetName, Content, Style)
  local BubbleType = WidgetName
  if self.CurrentType == BubbleType then
    DebugPrint("[HeadUI] Bubble Enable: same type, skip:", BubbleType)
    return
  end
  DebugPrint("[HeadUI] Bubble Enable:", BubbleType, "prev:", self.CurrentType, "bHiddenByTag:", self.bHiddenByTag)
  if self.CurrentType then
    self.Switcher:GetActiveWidget():OnDisabled()
  end
  local idx = "Short_Bubble" == BubbleType and 1 or 0
  self.Switcher:SetActiveWidgetIndex(idx)
  self.Switcher:GetActiveWidget():OnEnabled(Content, Style)
  self.CurrentType = BubbleType
  self.bActive = true
  self:ApplyHideTagIfActive()
end

function BubbleProcessor:Disable()
  if not self.CurrentType then
    return
  end
  self.Switcher:GetActiveWidget():OnDisabled()
  self.CurrentType = nil
  self.bActive = false
end

function BubbleProcessor:SetHidden(bHidden)
  self.bHiddenByTag = bHidden
  self:ApplyHideTagIfActive()
end

function BubbleProcessor:ApplyHideTagIfActive()
  if not self.bActive then
    return
  end
  local Widget = self.Switcher:GetActiveWidget()
  if not Widget then
    return
  end
  local Vis = self.bHiddenByTag and "Collapsed" or "SelfHitTestInvisible"
  if self.bHiddenByTag then
    Widget:SetVisibility(UE.ESlateVisibility.Collapsed)
  else
    Widget:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  DebugPrint("[HeadUI] Bubble ApplyHide: type=", self.CurrentType, "vis=", Vis)
end

function BubbleProcessor:Reset()
  self.Host.NPC_Bubble_Long:ResetForPool()
  self.Host.NPC_Bubble_Short:ResetForPool()
  self.CurrentType = nil
  HeadUIProcessor.Reset(self)
end

local TitleProcessor = setmetatable({}, {__index = HeadUIProcessor})
TitleProcessor.__index = TitleProcessor

function TitleProcessor.new(host)
  return HeadUIProcessor.new(TitleProcessor, host)
end

function TitleProcessor:Init()
  self.Title = self.Host.Title
  self.Title:SetVisibility(UE.ESlateVisibility.Collapsed)
  self.UnhiddenVisibility = UE.ESlateVisibility.Collapsed
end

function TitleProcessor:Enable(WidgetName, TitlePrefix, TitleSuffix, TitleFrameId)
  DebugPrint("[HeadUI] Title Enable: prefix=", TitlePrefix, "suffix=", TitleSuffix, "frame=", TitleFrameId, "bHiddenByTag:", self.bHiddenByTag)
  UIUtils.SetTitle(self.Title, {
    TitleBefore = TitlePrefix,
    TitleAfter = TitleSuffix,
    TitleFrame = TitleFrameId
  }, true)
  self.UnhiddenVisibility = self.Title:GetVisibility()
  self.bActive = self.UnhiddenVisibility ~= UE.ESlateVisibility.Collapsed
  self:ApplyHideTagIfActive()
end

function TitleProcessor:Disable()
  self.Title:SetVisibility(UE.ESlateVisibility.Collapsed)
  self.bActive = false
end

function TitleProcessor:SetHidden(bHidden)
  self.bHiddenByTag = bHidden
  self:ApplyHideTagIfActive()
end

function TitleProcessor:ApplyHideTagIfActive()
  if not self.bActive then
    return
  end
  local Visibility = self.bHiddenByTag and UE.ESlateVisibility.Collapsed or self.UnhiddenVisibility
  self.Title:SetVisibility(Visibility)
  DebugPrint("[HeadUI] Title ApplyHide: hidden=", self.bHiddenByTag)
end

function TitleProcessor:Reset()
  self.Title:ClearChildren()
  self.Title:SetVisibility(UE.ESlateVisibility.Collapsed)
  self.UnhiddenVisibility = UE.ESlateVisibility.Collapsed
  self.bActive = false
  self.bHiddenByTag = false
end

local DynamicProcessor = setmetatable({}, {__index = HeadUIProcessor})
DynamicProcessor.__index = DynamicProcessor

function DynamicProcessor:Enable(WidgetName, ...)
  DebugPrint("[HeadUI] Dynamic Enable:", WidgetName, "hasChild:", self.Child ~= nil, "bHiddenByTag:", self.bHiddenByTag)
  if not self.Child then
    local Class = self.Host:GetExternWidgetClass(WidgetName)
    if not Class then
      DebugPrint("[HeadUI] Dynamic Enable: no ExternWidgetClass for", WidgetName)
      return
    end
    local Child = UIManager(self.Host):CreateWidget(Class)
    if not IsValid(Child) then
      return
    end
    self.Child = Child
    self:AddToParent(Child)
    Child:Init(self.Host)
  end
  self.Host.Pos_Bubble:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  self.Child:OnEnabled(...)
  self.bActive = true
  self:ApplyHideTagIfActive()
end

function DynamicProcessor:Disable()
  if self.Child then
    self.Child:OnDisabled()
  end
  self.bActive = false
end

function DynamicProcessor:SetHidden(bHidden)
  self.bHiddenByTag = bHidden
  self:ApplyHideTagIfActive()
end

function DynamicProcessor:ApplyHideTagIfActive()
  if not self.bActive or not self.Child then
    return
  end
  local Vis = self.bHiddenByTag and "Collapsed" or "SelfHitTestInvisible"
  if self.bHiddenByTag then
    self.Child:SetVisibility(UE.ESlateVisibility.Collapsed)
  else
    self.Child:SetVisibility(UE.ESlateVisibility.SelfHitTestInvisible)
  end
  DebugPrint("[HeadUI] Dynamic ApplyHide: vis=", Vis)
end

function DynamicProcessor:Reset()
  if self.Child then
    self.Child:ResetForPool()
    self.Child:RemoveFromParent()
    self.Child = nil
  end
  self.Host.Pos_Bubble:SetVisibility(UE.ESlateVisibility.Collapsed)
  HeadUIProcessor.Reset(self)
end

local RewardProcessor = setmetatable({}, {__index = DynamicProcessor})
RewardProcessor.__index = RewardProcessor

function RewardProcessor.new(host)
  return HeadUIProcessor.new(RewardProcessor, host)
end

function RewardProcessor:Init()
  self.Child = nil
end

function RewardProcessor:AddToParent(Child)
  self.Host.Pos_Bubble:AddChildToOverlay(Child)
end

local EmojiProcessor = setmetatable({}, {__index = DynamicProcessor})
EmojiProcessor.__index = EmojiProcessor

function EmojiProcessor.new(host)
  return HeadUIProcessor.new(EmojiProcessor, host)
end

function EmojiProcessor:Init()
  self.Child = nil
end

function EmojiProcessor:AddToParent(Child)
  self.Host.Pos_Bubble:AddChildToOverlay(Child)
end

return {
  NameProcessor = NameProcessor,
  ImpressionProcessor = ImpressionProcessor,
  HeadIconProcessor = HeadIconProcessor,
  GuidePointProcessor = GuidePointProcessor,
  BubbleProcessor = BubbleProcessor,
  TitleProcessor = TitleProcessor,
  RewardProcessor = RewardProcessor,
  EmojiProcessor = EmojiProcessor
}
