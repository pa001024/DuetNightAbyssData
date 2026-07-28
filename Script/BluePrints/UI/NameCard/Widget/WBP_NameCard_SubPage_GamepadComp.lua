local Component = {}

function Component:SetGamepadDefaultFocus(AfterNavigateCallback)
  if self.List_NameCard and self.BackgroundList then
    self:AddTimer(0.01, function()
      local targetIndex = 0
      for i, itemData in ipairs(self.BackgroundList) do
        if itemData.BgId == self.CurrentEffectiveBgId then
          targetIndex = i - 1
          break
        end
      end
      self.List_NameCard:NavigateToIndex(targetIndex)
      if AfterNavigateCallback then
        self:AddTimer(0.01, AfterNavigateCallback)
      end
    end)
  end
end

function Component:HandleGamepadInput(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.Btn_Confirm then
    self:OnBtnConfirmClicked()
    return true
  end
  return false
end

return Component
