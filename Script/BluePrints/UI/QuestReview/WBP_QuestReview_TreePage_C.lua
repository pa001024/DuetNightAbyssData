require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  self.OwnerRoot = nil
  self.QuestReviewId = nil
  self:BindToAnimationFinished(self.Out, {
    self,
    self.HideSelf
  })
end

function M:Init(OwnerRoot, QuestReviewId)
  self.OwnerRoot = OwnerRoot
  self.QuestReviewId = QuestReviewId
end

function M:SwitchIn()
  if self:IsAnimationPlaying(self.Out) then
    self:StopAnimation(self.Out)
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:SetFocus()
end

function M:SwitchOut()
  self:PlayAnimation(self.Out)
end

function M:InitGamepadView()
  self:SetFocus()
end

function M:InitKeyboardView()
  self:SetFocus()
end

function M:HandleKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight and self.OwnerRoot then
      self.OwnerRoot:BackToMainPage()
      IsEventHandled = true
    end
  elseif "Escape" == InKeyName and self.OwnerRoot then
    self.OwnerRoot:BackToMainPage()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:HideSelf()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:Destruct()
  self.OwnerRoot = nil
  self.QuestReviewId = nil
  self:UnbindAllFromAnimationFinished(self.Out)
end

return M
