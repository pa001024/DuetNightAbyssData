require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Construct()
  rawset(self, "ClickLogics", {})
  rawset(self, "ForbidLogics", {})
  rawset(self, "IsForbidden", false)
  self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
  self:InitGamepadKey()
  self:RefreshBaseInfo()
  self:BindInputMethodChangedDelegate()
end

function M:Destruct()
  self.Button_Area.OnClicked:Remove(self, self.OnBtnClicked)
  self.ClickLogics = {}
  self.ForbidLogics = {}
  self:UnBindInputMethodChangedDelegate()
end

function M:InitGamepadKey()
  if not self.Key_GamePad or not self.Key_GamePad.CreateCommonKey then
    return
  end
  local ImgShortPath = self:GetGamepadKeyShortPath()
  if not ImgShortPath or "" == ImgShortPath then
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = ImgShortPath}
    }
  })
  self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:BindEventOnClicked(Target, Callback, ...)
  if not Target or not Callback then
    return
  end
  if not self.ClickLogics[Target] then
    self.ClickLogics[Target] = {}
  end
  table.insert(self.ClickLogics[Target], {
    Event = Callback,
    Params = {
      ...
    }
  })
end

function M:SetText(InText)
  self.Text:SetText(InText or "")
end

function M:SetForbidden(bForbidden)
  local bNewForbidden = true == bForbidden
  if self.IsForbidden == bNewForbidden then
    if bNewForbidden then
      self.Key_GamePad:DisableKey()
    else
      self.Key_GamePad:EnableKey()
    end
    return
  end
  self.IsForbidden = bNewForbidden
  self.Button_Area:SetForbidden(bNewForbidden)
  self:StopAllAnimations()
  if bNewForbidden then
    self.Key_GamePad:DisableKey()
    self:PlayAnimation(self.Forbidden)
  else
    self.Key_GamePad:EnableKey()
    self:PlayAnimation(self.Normal)
  end
end

function M:BindForbidStateExecuteEvent(Target, Callback, ...)
  if not Target or not Callback then
    return
  end
  if not self.ForbidLogics[Target] then
    self.ForbidLogics[Target] = {}
  end
  table.insert(self.ForbidLogics[Target], {
    Event = Callback,
    Params = {
      ...
    }
  })
end

function M:UnBindEventOnClickedByObj(Target)
  if not Target then
    return
  end
  self.ClickLogics[Target] = nil
  self.ForbidLogics[Target] = nil
end

function M:OnBtnClicked()
  local ExecuteLogics = self.IsForbidden and self.ForbidLogics or self.ClickLogics
  for Target, Functions in pairs(ExecuteLogics) do
    for _, Data in pairs(Functions) do
      Data.Event(Target, table.unpack(Data.Params))
    end
  end
end

function M:SetGamePadImg(ImgShortPath)
  self.GamePadKey = ImgShortPath
  self:RefreshGamepadKeyDisplay()
end

function M:SetDefaultGamePadImg(ImgShortPath)
  self.GamePadKey = ImgShortPath
  self:RefreshGamepadKeyDisplay()
end

function M:SetGamePadVisibility(Op)
  self.Key_GamePad:SetVisibility(Op)
end

function M:SetGamepadIconVisibility(bShow)
  self.bGamepadIconVisible = bShow
  self:RefreshOpInfoByInputDevice(self.CurInputDeviceType, self.CurGamepadName)
end

function M:GetGamepadKeyShortPath()
  local ShortPath = self.GamePadKey
  if nil == ShortPath then
    return nil
  end
  if type(ShortPath) == "string" then
    return ShortPath
  end
  if UE4.UKismetTextLibrary and UE4.UKismetTextLibrary.Conv_TextToString then
    return UE4.UKismetTextLibrary.Conv_TextToString(ShortPath)
  end
  return tostring(ShortPath)
end

function M:RefreshBaseInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  else
    self:RefreshOpInfoByInputDevice(nil, nil)
  end
end

function M:BindInputMethodChangedDelegate()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:UnBindInputMethodChangedDelegate()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  if not self.Key_GamePad then
    return
  end
  local ImgShortPath = self:GetGamepadKeyShortPath()
  local bShow = CurInputDevice == ECommonInputType.Gamepad and self.bGamepadIconVisible ~= false and nil ~= ImgShortPath and "" ~= ImgShortPath
  self.Key_GamePad:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshGamepadKeyDisplay()
  self:InitGamepadKey()
  self:RefreshOpInfoByInputDevice(self.CurInputDeviceType, self.CurGamepadName)
end

return M
