require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  M.Super.Construct(self)
  self:InitListenEvent()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.List_Gift:SetScrollBarVisibility(UIConst.VisibilityOp.Hidden)
    self.List_Gift:SetControlScrollbarInside(true)
  end
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self:ShowGamepadABtn(true)
  local PackDetail = DataMgr.Reward[Params.PackId].Id
  local Types = DataMgr.Reward[Params.PackId].Type
  local Counts = DataMgr.Reward[Params.PackId].Count
  local Rates = DataMgr.Reward[Params.PackId].Param
  self.Text_Title:SetText(GText("UI_Dispatch_OpenPackObtain"))
  for key, value in pairs(PackDetail) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Id = value
    Content.Type = Types[key]
    Content.Count = Counts[key]
    Content.Owner = self
    Content.Rate = math.floor(Rates[key] / 10000 * 100)
    self.List_Gift:AddItem(Content)
  end
  self.List_Gift:SetFocus()
  self.List_Gift:NavigateToIndex(0)
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
  else
    self.UsingGamepad = true
    self.List_Gift:NavigateToIndex(0)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightY" == InKeyName then
    local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:ShowGamepadABtn(bIsShow)
  if bIsShow then
    self.GamepadCheckItemKeyInfo = self.GamepadCheckItemKeyInfo or self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom
        }
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
  elseif self.GamepadCheckItemKeyInfo then
    self.GamepadCheckItemKeyInfo = nil
  end
end

return M
