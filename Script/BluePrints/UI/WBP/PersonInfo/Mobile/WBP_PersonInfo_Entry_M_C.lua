require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = require("BluePrints.UI.WBP.PersonInfo.PersonInfoModel")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoEntryBaseView",
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoScreenshotComponent"
}

function M:InitTabInfo()
  self.Com_Tab_M:Init({
    Tabs = {},
    DynamicNode = {
      "Back",
      "Tip",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    StyleName = "Text",
    OwnerPanel = self,
    TitleName = GText("UI_PersonInfo_Name"),
    BackCallback = self.OnReturnKeyDown
  })
end

function M:Close()
  M.Super.Close(self)
end

function M:InitListenEvent()
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self:InitListenEvent()
  self.Com_BtnCamera:UnBindEventOnClickedByObj(self)
  self.Com_BtnCamera:BindEventOnClicked(self, self.OnScreenshotKeyDown)
  self.Com_BtnVisible.Button_Area.OnClicked:Add(self, self.OnBtnVisibleClick)
end

function M:RefreshBaseInfo()
  local PageData = {}
  self.PersonInfoMainPage = self:CreatePersonInfoMainPage({
    PCBluePrint = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Mobile/WBP_PersonalInfo_Main_M.WBP_PersonalInfo_Main_M'"
  })
  if self.PersonInfoMainPage then
    self.PersonInfoMainPage:PlayAnimation(self.PersonInfoMainPage.In)
  end
  self.Com_BtnCamera:SetVisibility(PersonInfoModel:IsOwener() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Com_BtnVisible:SetVisibility(PersonInfoModel:IsOwener() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self:SetFocus()
end

function M:OnReturnKeyDown()
  if not self:CheckIsCanCloseSelf() then
    return
  end
  self:PlayOutAnim()
end

function M:OnReturnKeyDown()
  if self:CheckIsCanCloseSelf() then
    self:PlayOutAnim()
  end
end

function M:Hideui()
  PersonInfoController:SetMainPageUIHidden(true)
  self.MainPageItem:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:PlayAnimation(self.HideUi)
end

function M:Recoverui()
  PersonInfoController:SetMainPageUIHidden(false)
  self.MainPageItem:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:PlayAnimation(self.ShowUi)
end

function M:OnBtnVisibleClick()
  local bIsHide = not PersonInfoController:IsMainPageUIHidden()
  PersonInfoController:SetMainPageUIHidden(bIsHide)
  if bIsHide then
    self:Hideui()
  else
    self:Recoverui()
  end
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  if PersonInfoController:IsMainPageUIHidden() then
    self:Recoverui()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.bScreenshotWidgetShow and IsValid(self.ScreenshotWidget) then
    self.ScreenshotWidget:OnKeyDown(MyGeometry, InKeyEvent)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" ~= InKeyName then
  end
  self:OnReturnKeyDown()
  IsEventHandled = true
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
  return IsEventHandled
end

function M:Handle_KeyDownOnGamePad()
  return true
end

AssembleComponents(M)
return M
