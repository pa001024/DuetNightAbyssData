local M = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")
local LuaConst = require("EMLuaConst")
local PopupId = 100301

function M:BtnPressed(PlayerActor)
  local Owner = self:GetOwner()
  if not IsValid(Owner) then
    return
  end
  DebugPrint("BP_SubmitItemInteractiveComponent_C: BtnPressed, Open UI")
  self:OpenSubmitUI(self.SubmitId)
end

function M:SetSubmitId(SubmitId)
  self.SubmitId = SubmitId
end

function M:BindSuccessCallback(SuccessCallback)
  self.SuccessCallback = SuccessCallback
end

function M:IsCanInteractive(PlayerActor)
  if not IsValid(PlayerActor) then
    return false
  end
  if self.InteractiveDistance and self.InteractiveDistance > 0 then
    if LuaConst.OpenComputeInteractive then
      return self:GetDistanceCheckResult()
    end
    return self:DistanceCheckComponent(PlayerActor, self.InteractiveDistance)
  end
  return true
end

function M:OpenSubmitUI(SubmitId)
  DebugPrint("BP_SubmitItemInteractiveComponent_C: Open UI for SubmitId", SubmitId)
  local Params = {
    SubmitId = SubmitId,
    ItemList = {},
    OnSubmitConfirmed = function(Res)
      if Res and self.SuccessCallback then
        self.SuccessCallback()
      end
    end,
    DontCloseWhenRightBtnClicked = true,
    ShortText = GText("UI_SubmitItem_Confirm"),
    LargeSizeItem = true
  }
  UIManager(self):ShowCommonPopupUI(PopupId, Params)
end

return M
