local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local Component = {}

function Component:InitData_ImpressionComp()
  self.bDimensionGraphInited = false
  self.bImpressionMapVisibility = false
end

function Component:InitVisibility_ImpressionComp()
  self.Group_Dimension:SetVisibility(ESlateVisibility.Collapsed)
  self.Btn_DimensionDrawArea:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:InitEvent_ImpressionComp()
  self.Btn_DimensionDrawArea:BindEventOnClicked(self, self.SwitchShowImpressionMap)
  self.Btn_DimensionFullClose.OnClicked:Add(self, self.SwitchShowImpressionMap)
end

function Component:OnDisplayStarted_ImpressionComp()
  local ImpressionAreaId = self.ImpressionAreaId
  if not ImpressionAreaId then
    return
  end
  local bIsRetryCheck = self:IsRetryCheck(self.OptionData)
  self:TryDisplayCostGroup(self.OptionData.OptionType, ImpressionAreaId, bIsRetryCheck)
  self:TryDisplayImpressionDimension(ImpressionAreaId, self.OptionData)
end

function Component:OnDisplayEnded_ImpressionComp()
  self:CloseImpressionMap()
  self.Btn_DimensionDrawArea:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Dimension:SetVisibility(ESlateVisibility.Collapsed)
  self.Group_Cost:SetVisibility(ESlateVisibility.Collapsed)
  if self.DimensionGraph then
    self.DimensionGraph:StopLoop()
  end
end

function Component:OnPreExit_ImpressionComp()
  if self.DimensionGraph then
    self.DimensionGraph:UnbindFromAnimationStarted(self.DimensionGraph.In, {
      self,
      self.OnDetails_InStarted
    })
    self.DimensionGraph:UnbindFromAnimationFinished(self.DimensionGraph.Out, {
      self,
      self.OnDetails_OutFinished
    })
  end
end

function Component:OnDestruct_ImpressionComp()
  self.Btn_DimensionDrawArea:UnBindEventOnClicked(self, self.SwitchShowImpressionMap)
  self.Btn_DimensionFullClose.OnClicked:Clear()
end

function Component:OnFocusLost_ImpressionComp()
  self:CloseImpressionMap()
end

function Component:TryDisplayCostGroup(OptionType, ImpressionAreaId, bIsRetryCheck)
  self.Group_Cost:SetVisibility(ESlateVisibility.Collapsed)
  if bIsRetryCheck and OptionType == ETalkOptionType.Check then
    local Ret = ImpressionModel:CanImpressionCheck(ImpressionAreaId)
    local ResourceInfo = DataMgr.ImpressionResource[ImpressionAreaId]
    self.Com_Cost:InitContent({
      ResourceId = ResourceInfo.ResourceId,
      bShowDenominator = true,
      Numerator = Ret.ResourceCount or 0,
      Denominator = Ret.Cost,
      KeyIconName = "RS",
      UIName = "ImpressionMainUI"
    })
    self.Group_Cost:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
end

function Component:TryDisplayImpressionDimension(ImpressionAreaId, OptionData)
  local OptionType = OptionData.OptionType
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
  self.Group_Dimension:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function Component:OnDetails_OutFinished()
  self.Group_Dimension:SetVisibility(ESlateVisibility.Collapsed)
end

function Component:SwitchShowImpressionMap()
  self.bImpressionMapVisibility = not self.bImpressionMapVisibility
  self:SwitchDimensionBg(self.bImpressionMapVisibility)
  self.DimensionGraph:SwitchActive(self.bImpressionMapVisibility)
  self.Btn_DimensionFullClose:SetVisibility(self.bImpressionMapVisibility and ESlateVisibility.Visible or ESlateVisibility.Collapsed)
end

function Component:CloseImpressionMap()
  if self.bImpressionMapVisibility then
    self:SwitchShowImpressionMap()
  end
end

return Component
