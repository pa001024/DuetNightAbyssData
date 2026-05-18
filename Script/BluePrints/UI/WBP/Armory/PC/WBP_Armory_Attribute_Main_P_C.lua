require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Armory.Widget.Attribute.WBP_Armory_Attribute_Main_Base_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.KeyInputComponent"
}

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  self.WBP_Com_Tab_P:Init({
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "LV"}
        },
        Desc = GText("UI_Controller_Switch")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = CommonUtils:GetKeyText("Escape"),
            ClickCallback = self.OnBackKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnBackKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    BackCallback = self.OnBackBtnClicked,
    OwnerPanel = self,
    TitleName = GText("UI_Switch_Attribute")
  }, true)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self.WBP_Armory_Attribute_Main.bIsFocusable = true
  self:SetIsDealWithVirtualAccept(true)
  self:AddKeyDownEvent(EKeys.Escape.KeyName, self.OnBackKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonRight, self.OnBackKeyDown)
  self:AddKeyDownEvent(UIConst.GamePadKey.FaceButtonBottom, self.OnConfirmKeyDown)
end

function M:OnBackKeyDown()
  self:OnBackBtnClicked()
end

function M:OnConfirmKeyDown()
  self.WBP_Armory_Attribute_Main:OnBtnClick()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return Reply
  end
  return UIUtils.Handled
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.WBP_Armory_Attribute_Main:SetFocus()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self.WBP_Armory_Attribute_Main)
end

AssembleComponents(M)
return M
