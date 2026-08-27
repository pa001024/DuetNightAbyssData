require("UnLua")
local WBP_BuffBar_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_BuffBar_C:Initialize(Initializer)
  self.Super.Initialize(self)
end

function WBP_BuffBar_C:ReInit()
  self.ChaosBuffId = nil
  self.ChaosProgress = nil
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:StopAllAnimations()
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_BuffBar_C:RefreshChaosBuff(BuffData, IsNewBuff, IsLayerReduced, IsLayerIncreased)
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
    self:StopAnimation(self.Out)
  end
  local BuffConfig = DataMgr.Buff[BuffData.BuffId]
  if not BuffConfig then
    return
  end
  local BuffElement = BuffConfig and BuffConfig.BPVars and BuffConfig.BPVars.Element
  local DynamicMaterial = self.Image_Progress:GetDynamicMaterial()
  local Progress = BuffData.Layer / math.max(BuffConfig.MaxLayer or 1, 1)
  Progress = math.max(0, math.min(Progress, 1))
  if not self.ChaosProgress or self.ChaosProgress ~= Progress then
    if DynamicMaterial then
      DynamicMaterial:SetScalarParameterValue("Percent", Progress)
    end
    if Progress >= 1 then
      if self.TopMask then
        self.TopMask:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    else
      local TransformAngle = -360 * Progress
      if self.TopProgress then
        self.TopProgress:SetRenderTransformAngle(TransformAngle)
      end
      if self.TopMask then
        self.TopMask:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        if TransformAngle < -30 then
          self.TopMask:SetClipping(EWidgetClipping.Inherit)
        else
          self.TopMask:SetClipping(EWidgetClipping.ClipToBounds)
        end
      end
    end
    self.ChaosProgress = Progress
  end
  if not self.ChaosBuffId or self.ChaosBuffId ~= BuffData.BuffId then
    local ProgressColor = BuffElement and self["ProgressColor_" .. BuffElement]
    if ProgressColor then
      self.Image_Progress:SetColorAndOpacity(ProgressColor)
    end
    local BuffIconPath
    if BuffElement then
      local IconName = "Armory_" .. BuffElement
      BuffIconPath = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    else
      BuffIconPath = "/Game/UI/Texture/Dynamic/Atlas/Buff/T_Buff_Damage_Up.T_Buff_Damage_Up"
    end
    local ElementIcon = BuffIconPath and LoadObject(BuffIconPath)
    if not ElementIcon then
      return
    end
    self.Image_Icon:SetBrushResourceObject(ElementIcon)
    self.ChaosBuffId = BuffData.BuffId
  end
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsNewBuff and self.In then
    self:StopAnimation(self.In)
    self:PlayAnimation(self.In)
  elseif IsLayerReduced and self.Warning then
    self:StopAnimation(self.Warning)
    self:PlayAnimation(self.Warning)
  elseif IsLayerIncreased and self.Add then
    self:StopAnimation(self.Add)
    self:PlayAnimation(self.Add)
  end
end

function WBP_BuffBar_C:OnChaosBuffRemoved(RemoveCallback)
  local DynamicMaterial = self.Image_Progress:GetDynamicMaterial()
  if DynamicMaterial then
    DynamicMaterial:SetScalarParameterValue("Percent", 0)
  end
  if self.TopProgress then
    self.TopProgress:SetRenderTransformAngle(-0.1)
  end
  if self.TopMask then
    self.TopMask:SetClipping(EWidgetClipping.ClipToBounds)
  end
  self.ChaosProgress = 0
  if not self.Out then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    RemoveCallback()
    return
  end
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.Out)
      self:SetVisibility(UIConst.VisibilityOp.Collapsed)
      RemoveCallback()
    end
  })
  self:PlayAnimation(self.Out)
end

return WBP_BuffBar_C
