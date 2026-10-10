require("UnLua")
require("DataMgr")
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local Component = Class("BluePrints.UI.BP_EMUserWidget_C")

function Component:Event_InitData()
  self.bDimensionGraphInited = false
  self.bImpressionMapVisibility = false
end

function Component:Event_InitVisibility()
  self:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_DimensionDrawArea:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:Event_AdaptPlatform(IsMobile)
  self.bIsMobile = IsMobile
  if IsMobile then
    self.Btn_DimensionDrawArea.Key_Dimension:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function Component:Event_InitUI(Owner)
  self:InitEvents()
  if self.bIsMobile then
    return
  end
  Owner:AddLSFocusTarget(self.Btn_DimensionDrawArea.Key_Dimension, self.Btn_DimensionDrawArea, "Menu", true)
end

function Component:Event_DisplayStarted()
  self:TryDisplayImpressionDimension(self.ImpressionAreaId, self.OptionData)
end

function Component:Event_DisplayEnded()
  self:CloseImpressionMap()
  self:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_DimensionDrawArea:SetVisibility(ESlateVisibility.Collapsed)
  if self.DimensionGraph then
    self.DimensionGraph:StopLoop()
  end
end

function Component:Event_PreExit()
  if not self.DimensionGraph then
    return
  end
  self.DimensionGraph:UnbindFromAnimationStarted(self.DimensionGraph.In, {
    self,
    self.OnDetails_InStarted
  })
  self.DimensionGraph:UnbindFromAnimationFinished(self.DimensionGraph.Out, {
    self,
    self.OnDetails_OutFinished
  })
end

function Component:Event_Destruct()
  self.Btn_DimensionDrawArea:UnBindEventOnClicked(self, self.SwitchShowImpressionMap)
  self.Btn_DimensionFullClose.OnClicked:Clear()
end

function Component:Event_FocusLost()
  self:CloseImpressionMap()
end

function Component:InitEvents()
  self.Btn_DimensionDrawArea:BindEventOnClicked(self, self.SwitchShowImpressionMap)
  self.Btn_DimensionFullClose.OnClicked:Add(self, self.SwitchShowImpressionMap)
end

function Component:TryDisplayImpressionDimension(ImpressionAreaId, OptionData)
  local OptionType = OptionData and OptionData.OptionType
  if ImpressionAreaId and (OptionType == ETalkOptionType.Plus or OptionType == ETalkOptionType.Check) then
    self:InitDimensionGraph(ImpressionAreaId)
    self.Btn_DimensionDrawArea:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Btn_DimensionDrawArea:Init(ImpressionAreaId)
  end
end

function Component:InitDimensionGraph(ImpressionAreaId)
  if self.bDimensionGraphInited then
    self.DimensionGraph:Init(ImpressionAreaId, self.TalkTask.TaskData.UsingGM)
    return
  end
  self.DimensionGraph = self.BP_DimensionDrawArea
  local RegionInfo = DataMgr.ImpressionRegion[ImpressionAreaId]
  if RegionInfo and RegionInfo.UIName then
    local Widget = self:CreateWidgetNew(RegionInfo.UIName)
    if Widget then
      self.Group_Anchor:ClearChildren()
      self.Group_Anchor:AddChild(Widget)
      self.DimensionGraph = Widget
    end
  end
  self.DimensionGraph:Init(ImpressionAreaId, self.TalkTask.TaskData.UsingGM)
  self.DimensionGraph:BindToAnimationStarted(self.DimensionGraph.In, {
    self,
    self.OnDetails_InStarted
  })
  self.DimensionGraph:BindToAnimationFinished(self.DimensionGraph.Out, {
    self,
    self.OnDetails_OutFinished
  })
  self.bDimensionGraphInited = true
end

function Component:OnDetails_InStarted()
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function Component:OnDetails_OutFinished()
  self:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:BindOnImpressionMapVisibilityChanged(Obj, Func)
  self.OnMapVisChangedObj = Obj
  self.OnMapVisChangedFunc = Func
end

function Component:SwitchShowImpressionMap()
  self.bImpressionMapVisibility = not self.bImpressionMapVisibility
  if self.OnMapVisChangedFunc then
    self.OnMapVisChangedFunc(self.OnMapVisChangedObj, self.bImpressionMapVisibility)
  end
  if self.DimensionGraph then
    self.DimensionGraph:SwitchActive(self.bImpressionMapVisibility)
  end
  self.Btn_DimensionFullClose:SetVisibility(self.bImpressionMapVisibility and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

function Component:CloseImpressionMap()
  if self.bImpressionMapVisibility then
    self:SwitchShowImpressionMap()
  end
end

return Component
