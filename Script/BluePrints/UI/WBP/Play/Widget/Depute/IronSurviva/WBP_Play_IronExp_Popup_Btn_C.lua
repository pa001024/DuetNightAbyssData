require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  end
  if self.New then
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Reddot then
    self.Reddot:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetData(Params)
  self.Params = Params or {}
  self:SetNewVisible(self.Params.ShowNew)
  if self.Text_Btn and self.Params.Text then
    self.Text_Btn:SetText(self.Params.Text)
  end
  if self.Image_Icon and self.Params.IconPath then
    local ImageResource = LoadObject(self.Params.IconPath)
    if ImageResource then
      local Material = self.Image_Icon:GetDynamicMaterial()
      if Material then
        Material:SetTextureParameterValue("Mask", ImageResource)
      else
        self.Image_Icon:SetBrushResourceObject(ImageResource)
      end
    end
  end
  if self.Reddot then
    local vis = self.Params.ShowReddot and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
    self.Reddot:SetVisibility(vis)
  end
  if self.Key_Btn then
    if self.Params.GamePadKey and self.Key_Btn.CreateGamepadKey then
      self.Key_Btn:CreateGamepadKey(self.Params.GamePadKey)
      self:SetGamepadKeyVisible(UIUtils.IsGamepadInput())
    else
      self.Key_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:SetGamepadKeyVisible(bShow)
  if not self.Key_Btn then
    return
  end
  if not self.Params or not self.Params.GamePadKey then
    return
  end
  self.Key_Btn:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:SetNewVisible(show)
  if not self.New then
    return
  end
  self.New:SetVisibility(show and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:IsNewVisible()
  return self.New and self.New:GetVisibility() ~= UIConst.VisibilityOp.Collapsed
end

function M:OnBtnClicked()
  if self.Params and self.Params.AudioPath then
    AudioManager(self):PlayUISound(self, self.Params.AudioPath, nil, nil)
  end
  if self:IsNewVisible() then
    self:SetNewVisible(false)
    if self.Params and type(self.Params.OnNewClicked) == "function" then
      self.Params.OnNewClicked()
    end
  end
  if self.Params and "function" == type(self.Params.OnClick) then
    self.Params.OnClick()
  end
end

return M
