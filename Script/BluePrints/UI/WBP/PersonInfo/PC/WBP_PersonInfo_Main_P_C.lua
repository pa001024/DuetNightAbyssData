require("UnLua")
local PersonInfoModel = require("BluePrints.UI.WBP.PersonInfo.PersonInfoModel")
local PersonInfoCommon = require("BluePrints.UI.WBP.PersonInfo.PersonInfoCommon")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoMainPageView"
}
local SCREENSHOT_KEY_NAME = "F"

function M:Construct()
  self.IsPC = true
  self:InitBaseView()
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Ls"}
    }
  })
  self.Key_ControllerImg:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "View"}
    }
  })
  self.Key_Guild:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.SpecialLeft
      }
    },
    bLongPress = true
  })
  self.Key_Guild:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Setting:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
      }
    }
  })
  self.Key_Setting:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if UIManager():GetUIObj("CheckGuildPage") then
    UIManager():GetUIObj("CheckGuildPage"):Close()
  end
end

function M:EnsureMainPageGamepadWidgetsInitialized()
  if self.bMainPageGamepadWidgetsInitialized then
    return
  end
  if self.Btn_Data then
    if self.Btn_Data.SetDefaultGamePadImg then
      self.Btn_Data:SetDefaultGamePadImg("Menu")
    elseif self.Btn_Data.SetGamePadImg then
      self.Btn_Data:SetGamePadImg("Menu")
    elseif self.Btn_Data.Key_GamePad and self.Btn_Data.Key_GamePad.CreateCommonKey then
      self.Btn_Data.Key_GamePad:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialRight
          }
        }
      })
    end
  end
  if PersonInfoModel:IsOwener() and self.Btn_EditShow then
    if self.Btn_EditShow.SetDefaultGamePadImg then
      self.Btn_EditShow:SetDefaultGamePadImg("Y")
    elseif self.Btn_EditShow.SetGamePadImg then
      self.Btn_EditShow:SetGamePadImg("Y")
    end
  end
  self.bMainPageGamepadWidgetsInitialized = true
end

function M:RefreshGuildGamepadKeyVisibility()
  if self.Super and self.Super.RefreshGuildGamepadKeyVisibility then
    self.Super.RefreshGuildGamepadKeyVisibility(self)
  end
  local bIsGamepad = self.CurInputDeviceType == ECommonInputType.Gamepad
  local bCanOpenGuildDetail = self.CanOpenGuildDetailByGamepad and self:CanOpenGuildDetailByGamepad()
  self.Key_Guild:SetVisibility(bIsGamepad and bCanOpenGuildDetail and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshSettingGamepadKeyVisibility()
  local bShouldShow = self.CurInputDeviceType == ECommonInputType.Gamepad and PersonInfoModel:IsOwener() and not self.IsEditOpen
  self.Key_Setting:SetVisibility(bShouldShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshMainPageShortcutVisibilityForEditList()
  local bIsGamepad = self.CurInputDeviceType == ECommonInputType.Gamepad
  local bIsEditFocused = bIsGamepad and self.IsEditOpen and self.Panel_Edit and self.Panel_Edit:HasFocusedDescendants()
  self.Key_ControllerImg:SetVisibility(bIsEditFocused and UIConst.VisibilityOp.Collapsed or bIsGamepad and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Key_Controller:SetVisibility(bIsEditFocused and UIConst.VisibilityOp.Collapsed or bIsGamepad and PersonInfoModel:IsOwener() and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Key_Guild:SetVisibility(bIsEditFocused and UIConst.VisibilityOp.Collapsed or bIsGamepad and self.CanOpenGuildDetailByGamepad and self:CanOpenGuildDetailByGamepad() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self:RefreshSettingGamepadKeyVisibility()
  if self.Btn_EditShow and self.Btn_EditShow.SetGamepadIconVisibility then
    self.Btn_EditShow:SetGamepadIconVisibility(not bIsEditFocused)
  end
  if self.Btn_Data and self.Btn_Data.SetGamepadIconVisibility then
    self.Btn_Data:SetGamepadIconVisibility(not bIsEditFocused)
  end
  if self.RootPage and self.RootPage.RefreshMainPageBottomShortcutVisibilityForEditList then
    self.RootPage:RefreshMainPageBottomShortcutVisibilityForEditList()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.IsEditOpen then
      self:OnClickEdit()
      if self.RootPage and self.IsEditOpen == false then
        self:FreshFocusLeaveEditListView()
        if not self.RootPage:FocusToSavedWidget() then
          self:SetOriginFocus()
        end
      end
      IsEventHandled = true
    end
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    self.IsGamePad = true
    IsEventHandled = self:OnGamePadDown(InKeyName)
  else
    if InKeyName == SCREENSHOT_KEY_NAME and self.RootPage and self.RootPage.OnScreenshotKeyDown then
      IsEventHandled = self.RootPage:OnScreenshotKeyDown()
    end
    if "Escape" == InKeyName and self.IsEditOpen then
      self.IsEditOpen = false
      self:PlayAnimation(self.Edit_List_Out)
      IsEventHandled = true
    end
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:FreshFocusOnEditListView()
  DebugPrint("FreshFocusOnEditListView")
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad or not self.Panel_Edit:HasFocusedDescendants() then
    return
  end
  self:RefreshMainPageShortcutVisibilityForEditList()
end

function M:FreshFocusLeaveEditListView()
  DebugPrint("FreshFocusLeaveEditListView")
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad or self.IsEditOpen == true then
    return
  end
  self:RefreshMainPageShortcutVisibilityForEditList()
end

function M:InitPage(Data)
  self:RefreshPageView(Data)
end

function M:FocusA()
  self.AvatarItem_1:setFocus()
end

function M:OnClickChangeSelectChar()
  self:SetIsDealWithVirtualAccept(true)
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad then
    self:SetIsDealWithVirtualAccept(true)
  end
end

function M:OnClickChangeSelectWeapon()
  self:SetIsDealWithVirtualAccept(true)
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self:SetIsDealWithVirtualAccept(true)
  end
end

AssembleComponents(M)
return M
