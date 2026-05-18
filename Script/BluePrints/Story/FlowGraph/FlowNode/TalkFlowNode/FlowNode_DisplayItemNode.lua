local M = Class("BluePrints.Story.FlowGraph.FlowNode.TalkFlowNode.FlowNode_TalkNodeBase")
local DisplayPopupIdOwned = 100353
local DisplayPopupIdNotOwned = 100354
local FlowLogType = UE.EStoryLogType.TalkFlow

function M:Start()
  self:OpenDisplayUI(self.SubmitId)
end

function M:K2_Cleanup()
end

function M:CanSkip()
  return false
end

function M:OpenDisplayUI(SubmitId)
  self.bHandled = false
  DebugPrint("FlowNode_DisplayItemNode: Open UI for SubmitId", SubmitId)
  
  local function CancelCallback()
    DebugPrint("FlowNode_DisplayItemNode:CancelCallback", self.DifferentialResultPinNames and self.DifferentialResultPinNames:Num())
    if self.bHandled then
      return
    end
    self.bHandled = true
    self:FinishCancel()
  end
  
  local Params = {
    SubmitId = SubmitId,
    bDifferential = self.bDifferential,
    OnSubmitConfirmed = function(Res, ItemIdx)
      if self.bHandled then
        return
      end
      if Res then
        self.bHandled = true
        self:HandleDisplayOutport(ItemIdx)
      end
    end,
    LeftCallbackFunction = CancelCallback,
    CloseBtnCallbackFunction = CancelCallback,
    LargeSizeItem = true
  }
  local PopupId = DisplayPopupIdOwned
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_NetDelay"))
  end
  if Avatar and Avatar:CheckQuestItemsOwned(SubmitId) then
    Params.DontCloseWhenRightBtnClicked = true
  else
    PopupId = DisplayPopupIdNotOwned
    Params.RightCallbackFunction = Params.LeftCallbackFunction
  end
  UIManager(self):ShowCommonPopupUI(PopupId, Params)
end

function M:HandleDisplayOutport(ItemIdx)
  if self.bDifferential == false then
    self:FinishAccept()
    return
  end
  local PinNames = self.DifferentialResultPinNames
  DebugPrint("FlowNode_DisplayItemNode:OnSubmitConfirmed", ItemIdx, PinNames and PinNames:Num())
  if not PinNames or ItemIdx > PinNames:Num() then
    local Message = string.format("引脚不存在，引脚序号：%d", ItemIdx)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, FlowLogType, "展示物品失败/引脚不存在", Message)
    return
  end
  self:FinishDifferentialResult(ItemIdx - 1)
end

return M
