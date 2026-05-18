local M = Class("BluePrints.Story.Interactive.InteractiveComponent.BP_InteractiveBaseComponent_C")
local LuaConst = require("EMLuaConst")
local SubmitPopupId = 100301
local DisplayPopupIdOwned = 100353
local DisplayPopupIdNotOwned = 100354

function M:BtnPressed(PlayerActor)
  local Owner = self:GetOwner()
  if not IsValid(Owner) then
    return
  end
  DebugPrint("BP_SubmitItemInteractiveComponent_C: BtnPressed, Open UI")
  self:OpenSubmitUI(self.SubmitId)
end

function M:InitSubmitComp(SubmitId, bIsDisplay, bDifferential)
  self.SubmitId = SubmitId
  self.bIsDisplay = bIsDisplay
  self.bDifferential = bDifferential
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
    OnSubmitConfirmed = function(Res, ItemIdx)
      if Res and self.SuccessCallback then
        self.SuccessCallback(ItemIdx)
      end
    end,
    LargeSizeItem = true
  }
  local PopupId = SubmitPopupId
  local Avatar = GWorld:GetAvatar()
  if self.bIsDisplay then
    Params.bDifferential = self.bDifferential
    if not Avatar then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_NetDelay"))
    end
    if Avatar and Avatar:CheckQuestItemsOwned(SubmitId) then
      PopupId = DisplayPopupIdOwned
      Params.DontCloseWhenRightBtnClicked = true
    else
      PopupId = DisplayPopupIdNotOwned
    end
  else
    Params.ShortText = GText("UI_SubmitItem_Confirm")
  end
  UIManager(self):ShowCommonPopupUI(PopupId, Params)
end

return M
