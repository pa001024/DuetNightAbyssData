local M = Class()

function M:Initialize(Initializer)
  rawset(self, "FilterInfos", {})
end

function M:ReceiveEndPlay(...)
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.SeparateTranslucency 1", nil)
end

function M:K2_OnEndViewTarget(PC)
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.SeparateTranslucency 1", nil)
end

function M:K2_OnBecomeViewTarget(PC)
  UE4.UKismetSystemLibrary.ExecuteConsoleCommand(self, "r.SeparateTranslucency 0", nil)
end

function M:EnableFocusMethod(bEnable)
  local Camera = self:GetActiveCamera()
  Camera.FocusSettings.FocusMethod = bEnable and ECameraFocusMethod.Manual or ECameraFocusMethod.Disable
end

function M:IsFocusMethodEnabled()
  local Camera = self:GetActiveCamera()
  return Camera.FocusSettings.FocusMethod ~= ECameraFocusMethod.Disable
end

function M:GetFocusDistance()
  local Camera = self:GetActiveCamera()
  return Camera.FocusSettings.ManualFocusDistance
end

function M:SetFocusDistance(FocusDistance)
  local Camera = self:GetActiveCamera()
  Camera.FocusSettings.ManualFocusDistance = FocusDistance
end

function M:GetAperture()
  local Camera = self:GetActiveCamera()
  return Camera.CurrentAperture
end

function M:SetAperture(Aperture)
  local Camera = self:GetActiveCamera()
  Camera.CurrentAperture = Aperture
end

function M:GetContrast()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.ColorContrast.X
end

function M:SetContrast(Contrast)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_ColorContrast = true
  Camera.PostProcessSettings.ColorContrast.X = Contrast
  Camera.PostProcessSettings.ColorContrast.Y = Contrast
  Camera.PostProcessSettings.ColorContrast.Z = Contrast
end

function M:GetSaturation()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.ColorSaturation.X
end

function M:SetSaturation(Saturation)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_ColorSaturation = true
  Camera.PostProcessSettings.ColorSaturation.X = Saturation
  Camera.PostProcessSettings.ColorSaturation.Y = Saturation
  Camera.PostProcessSettings.ColorSaturation.Z = Saturation
end

function M:GetTemperature()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.WhiteTemp
end

function M:SetTemperature(Temperature)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_WhiteTemp = true
  Camera.PostProcessSettings.WhiteTemp = Temperature
end

function M:GetSceneColorTintR()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.SceneColorTint.R
end

function M:SetSceneColorTintR(R)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_SceneColorTint = true
  Camera.PostProcessSettings.SceneColorTint.R = R
end

function M:GetSceneColorTintG()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.SceneColorTint.G
end

function M:SetSceneColorTintG(G)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_SceneColorTint = true
  Camera.PostProcessSettings.SceneColorTint.G = G
end

function M:GetSceneColorTintB()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.SceneColorTint.B
end

function M:SetSceneColorTintB(B)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_SceneColorTint = true
  Camera.PostProcessSettings.SceneColorTint.B = B
end

function M:GetWhiteTint()
  local Camera = self:GetActiveCamera()
  return Camera.PostProcessSettings.ColorOffset.X
end

function M:SetWhiteTint(WhiteTint)
  local Camera = self:GetActiveCamera()
  Camera.PostProcessSettings.bOverride_WhiteTint = true
  Camera.PostProcessSettings.WhiteTint = WhiteTint
end

function M:GetFilterIntensity(FilterType)
  local Camera = self:GetActiveCamera()
  self.FilterInfos[Camera] = self.FilterInfos[Camera] or {}
  self.FilterInfos[Camera].Intensities = self.FilterInfos[Camera].Intensities or {}
  FilterType = FilterType or self:GetFilterType()
  return self.FilterInfos[Camera].Intensities[FilterType] or 1
end

function M:SetFilterIntensity(Intensity)
  local Camera = self:GetActiveCamera()
  local CurrentFilterType = self:GetFilterType()
  self:SetFilter(nil)
  self.FilterInfos[Camera] = self.FilterInfos[Camera] or {}
  self.FilterInfos[Camera].Intensities = self.FilterInfos[Camera].Intensities or {}
  self.FilterInfos[Camera].Intensities[CurrentFilterType] = Intensity
  self.FilterInfos[Camera].FilterType = CurrentFilterType
  self:UpdateCurrentFilter()
end

function M:SetFilter(FilterType)
  local Camera = self:GetActiveCamera()
  self.FilterInfos[Camera] = self.FilterInfos[Camera] or {}
  self.FilterInfos[Camera].FilterType = FilterType or -1
  self:UpdateCurrentFilter()
end

function M:GetFilterType()
  local Camera = self:GetActiveCamera()
  self.FilterInfos[Camera] = self.FilterInfos[Camera] or {}
  return self.FilterInfos[Camera].FilterType or -1
end

function M:UpdateCurrentFilter()
  local Camera = self:GetActiveCamera()
  local FilterType = self:GetFilterType()
  local Intensity = self:GetFilterIntensity(FilterType)
  local UPostProcessFunctionLibrary = LoadClass(Const.PostProcessFunctionLibraryPath)
  local OldMI = self.SimplePPMaterial:Find(Camera)
  if OldMI then
    UPostProcessFunctionLibrary.ClearSimplePostProcess(OldMI, Camera, Intensity)
    self.SimplePPMaterial:Remove(Camera)
    Camera.PostProcessSettings.WeightedBlendables.Array:Clear()
  end
  if FilterType and FilterType >= 0 then
    local MI = UPostProcessFunctionLibrary.SimplePostProcess(FilterType, Camera, Intensity)
    self.SimplePPMaterial:Add(Camera, MI)
  end
end

function M:GetFilterData()
  if self.Lua_FilterData then
    return self.Lua_FilterData
  end
  self.Lua_FilterData = {}
  local AllRowNames = UDataTableFunctionLibrary.GetDataTableRowNames(self.BP_FilterData)
  if not AllRowNames then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local Sex = Avatar and Avatar.Sex or 1
  local IconPathSuffix = 1 == Sex and "_F" or "_M"
  for i, value in ipairs(AllRowNames:ToTable()) do
    local Res = self:GetFilterDataByRowName(value)
    if Res then
      table.insert(self.Lua_FilterData, {
        ID = Res.ID,
        PPEnum = Res.PPEnum,
        IconPath = Res.IconPath and Res.IconPath .. IconPathSuffix,
        TextmapID = Res.TextmapID,
        Step = Res.Step and Res.Step > 0 and Res.Step or 1
      })
    end
  end
  return self.Lua_FilterData
end

return M
