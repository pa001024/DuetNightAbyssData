require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local AppearanceImportModel = require("BluePrints.UI.WBP.Appearance.AppearanceImportModel")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent",
  "BluePrints.UI.WBP.Appearance.PC.WBP_Appearance_Import_GamePadCompoment"
}
local RefreshSharerTitleWidget, RefreshPreviewCharIcon

function M:Construct()
  M.Super.Construct(self)
  self.bIsFocusable = true
  self.CurInputType = self.GameInputModeSubsystem and self.GameInputModeSubsystem.GetCurrentInputType and self.GameInputModeSubsystem:GetCurrentInputType() or nil
  self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
  self.PlatformName = self.IsPC and "PC" or "Mobile"
  self.bSelfHidden = false
  self.bCommonTabInited = false
  self.WindowWidget = nil
  self.Model = nil
  self.CurrentPreviewAppearanceInfo = nil
  self.OnCloseCallback = nil
  self.CloseCallbackParent = nil
  self:CreateKeySetting()
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
  end
  if self.IMG_Click and self.IMG_Click.OnMouseButtonDownEvent then
    self.IMG_Click.OnMouseButtonDownEvent:Unbind()
    self.IMG_Click.OnMouseButtonDownEvent:Bind(self, self.On_IMG_Click_MouseButtonDown)
  else
    RedPrint("[外观导入] 构造警告：缺少 IMG_Click，无法拖拽旋转预览角色")
  end
  self.Btn_Import:BindEventOnClicked(self, self.OnOpenImportWindowClicked)
  self.List_Appearance.GridPanel_Char:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:Destruct()
  self:DestroyImportWindow()
  self:DestroyActorController()
  if self.Model and self.Model.DummyAvatar then
    ArmoryUtils:SetTemporaryAvatar(nil)
  end
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  self.Params = Params or {}
  self.OnCloseCallback = self.Params.OnCloseCallback
  self.CloseCallbackParent = self.Params.Parent
  self.Model = AppearanceImportModel:New(self, self.Params)
  if not self.Model:IsValid() then
    RedPrint("[外观导入] 初始化界面失败：" .. tostring(self.Model:GetErrorText() or "导入模型无效"))
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, self.Model:GetErrorText() or GText("UI_COMMONPOP_TITLE_100059"))
    self:Close()
    return
  end
  self:InitCommonTab()
  self:RefreshSharerBasicInfo()
  self:InitPreviewActor()
  self:RefreshSharerAppearanceStructure()
  self:InitImportWindow()
  if self.InitImportGamepadWidgets then
    self:InitImportGamepadWidgets()
  end
  self:RefreshMainImportButtonState()
  self:PlayInAnim()
  self:AddTimer(0, function()
    if IsValid(self) then
      self:SetFocus()
    end
  end)
end

function M:InitBaseInfo()
  self:RefreshSharerBasicInfo()
  self:RefreshSharerAppearanceStructure()
end

function M:RefreshSharerBasicInfo()
  if not self.Model then
    RedPrint("[外观导入] 刷新分享者信息失败：导入模型为空")
    return
  end
  if self.Text_Name then
    self.Text_Name:SetText(self.Model:GetSharerDisplayName())
  end
  if self.Text_Level then
    self.Text_Level:SetText(self.Model:GetSharerDisplayLevel())
  end
  local SharerInfo = self.Model:GetSharerInfo() or {}
  if self.Head_Player then
    if SharerInfo.HeadIconId and SharerInfo.HeadIconId > 0 and self.Head_Player.SetHeadIconById then
      self.Head_Player:SetHeadIconById(SharerInfo.HeadIconId)
    end
    if SharerInfo.HeadFrameId and SharerInfo.HeadFrameId > 0 and self.Head_Player.SetHeadFrame then
      self.Head_Player:SetHeadFrame(SharerInfo.HeadFrameId)
    end
  else
    RedPrint("[外观导入] 刷新分享者信息警告：Head_Player 为空")
  end
  if self.WS_Title and self.Overlay_Title then
    RefreshSharerTitleWidget(self, SharerInfo)
  else
    RedPrint("[外观导入] 刷新分享者信息警告：称号控件不完整")
  end
end

function M:RefreshSharerAppearanceStructure()
  if not self.Model then
    RedPrint("[外观导入] 刷新外观结构失败：导入模型为空")
    return
  end
  if self.Text_Avatar then
    self.Text_Avatar:SetText(self.Model:GetPreviewCharDisplayName())
  end
  RefreshPreviewCharIcon(self, self.Model:GetPreviewCharId())
  if not self.List_Appearance then
    RedPrint("[外观导入] 刷新外观结构失败：List_Appearance 为空")
    return
  end
  local PreviewMainModel = self.Model:GetPreviewMainModel()
  if not PreviewMainModel then
    RedPrint("[外观导入] 刷新外观结构失败：预览主模型为空")
    return
  end
  if not self.List_Appearance.Init then
    RedPrint("[外观导入] 刷新外观结构失败：List_Appearance 缺少 Init")
    return
  end
  self.List_Appearance:Init(PreviewMainModel, {
    Parent = self,
    IsPreviewMode = true,
    IsTargetUnowned = false,
    OverrideAppearanceSuit = self.Model:GetPreviewAppearanceInfo(),
    AppearanceOwnershipChecker = function(_, TipType, ItemId)
      if not self.Model then
        return true
      end
      return self.Model:IsAppearancePartOwned(TipType, ItemId)
    end,
    OnCloseCallback = function()
      self:RefreshSharerAppearanceStructure()
      self:RefreshPreviewAppearance()
    end
  })
end

function M:InitPreviewActor()
  if not self.Model then
    RedPrint("[外观导入] 初始化预览角色中止：导入模型为空")
    return
  end
  local DummyAvatar = self.Model:GetPreviewDummyAvatar()
  local DummyChar = self.Model:GetPreviewDummyChar()
  if DummyAvatar then
    ArmoryUtils:SetTemporaryAvatar(DummyAvatar)
  else
    RedPrint("[外观导入] 初始化预览角色警告：DummyAvatar 为空")
  end
  if not DummyChar then
    RedPrint("[外观导入] 初始化预览角色警告：DummyChar 为空")
  end
  self.ActorController = ActorController:New({
    ViewUI = self,
    IsPreviewMode = true,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    Char = DummyChar,
    bNeedEndCamera = false
  })
  if self.ActorController then
    self.ActorController:OnOpened()
    self:RefreshPreviewAppearance()
  else
    RedPrint("[外观导入] 初始化预览角色失败：ActorController 创建失败")
  end
end

function M:RefreshPreviewAppearance()
  if self.ActorController and self.Model then
    self.CurrentPreviewAppearanceInfo = self.Model:GetPreviewAppearanceInfo()
    if self.CurrentPreviewAppearanceInfo then
      self.ActorController:ChangeCharAppearance(self.CurrentPreviewAppearanceInfo)
      self.ActorController:ResetActorRotation()
      self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, CommonConst.ArmoryTag.Appearance)
      self:RefreshBottomKeyInfo()
    end
  end
end

function M:InitImportWindow()
  local Window = self.ImportWindow
  if not IsValid(Window) then
    RedPrint("[外观导入] 初始化导入窗口失败：ImportWindow 无效")
    return
  end
  self.WindowWidget = Window
  if Window.Init and Window.Parent ~= self then
    Window:Init({
      Parent = self,
      Model = self.Model
    })
  else
    Window.Parent = self
    Window.Model = self.Model
    if not Window.Init then
      RedPrint("[外观导入] 初始化导入窗口失败：ImportWindow 缺少 Init")
    end
  end
end

function M:DestroyImportWindow()
  if IsValid(self.WindowWidget) then
    if self.WindowWidget.HideWindow then
      self.WindowWidget:HideWindow(true)
    end
    self.WindowWidget.Parent = nil
    self.WindowWidget.Model = nil
  end
  self.WindowWidget = nil
end

function M:DestroyActorController()
  if self.ActorController then
    self.ActorController:HidePlayerActor("AppearanceImport", false)
    self.ActorController:UpdateCameraPPSetting()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
end

function M:RefreshMainImportButtonState()
  local CanOpenImportWindow = self.Model and self.Model:CanOpenImportWindow() or false
  self.Btn_Import:SetText(GText(CanOpenImportWindow and "UI_AppearanceScore_Import" or "UI_AppearanceScore_NotHoldChar"))
  self.Btn_Import:ForbidBtn(not CanOpenImportWindow)
end

function M:IsImportWindowOpen()
  return IsValid(self.WindowWidget) and self.WindowWidget.IsWindowOpen and self.WindowWidget:IsWindowOpen()
end

function M:OpenImportWindow()
  if not self.Model then
    RedPrint("[外观导入] 打开导入窗口失败：导入模型为空")
    return
  end
  if not self.Model:CanOpenImportWindow() then
    return
  end
  if not IsValid(self.WindowWidget) then
    RedPrint("[外观导入] 打开导入窗口失败：WindowWidget 无效")
    return
  end
  if self.WindowWidget.ShowWindow then
    self.WindowWidget:ShowWindow()
  elseif self.WindowWidget.SetVisibility then
    self.WindowWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.IsGamepadInput and self.OnImportWindowOpenedByGamepad then
    self:OnImportWindowOpenedByGamepad()
  end
end

function M:CloseImportWindow()
  if not IsValid(self.WindowWidget) then
    return
  end
  if self.WindowWidget.RequestClose then
    self.WindowWidget:RequestClose()
  elseif self.WindowWidget.HideWindow then
    self.WindowWidget:HideWindow(true)
  elseif self.WindowWidget.SetVisibility then
    self.WindowWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.IsGamepadInput and self.OnImportWindowClosedByGamepad then
    self:OnImportWindowClosedByGamepad()
  end
end

function M:OnOpenImportWindowClicked()
  self:OpenImportWindow()
end

function M:OnImportClicked()
  if not self.Model then
    RedPrint("[外观导入] 点击导入中止：导入模型为空")
    return
  end
  if not self.Model:CanStartImport() then
    RedPrint("[外观导入] 点击导入被拦截：" .. tostring(self.Model:GetWarningText()))
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, self.Model:GetWarningText() ~= "" and self.Model:GetWarningText() or GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  if self.Model:NeedShowDyeImportConfirm() and IsValid(self.WindowWidget) and self.WindowWidget.OpenDyeDialog then
    self.WindowWidget:OpenDyeDialog(function()
      self:ExecuteImport()
    end)
    return
  end
  self:ExecuteImport()
end

function M:ExecuteImport()
  if not self.Model then
    RedPrint("[外观导入] 执行导入中止：导入模型为空")
    return
  end
  self.Model:ApplyImport(function(IsSuccess)
    if IsSuccess then
      self:CloseImportWindow()
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AppearanceScore_ImportCompleteToast"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    end
  end)
end

function M:CreateKeySetting()
  self.HideUIKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText("U"),
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        ClickCallback = self.OnHideUIKeyDown,
        Owner = self
      }
    },
    Desc = GText("UI_Dye_HideUI")
  }
  self.ZoomKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = "Mouse_Button",
        Owner = self
      }
    },
    GamePadInfoList = {
      {Type = "Or"},
      GamePadSubKeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "LT",
          Owner = self
        },
        {
          Type = "Img",
          ImgShortPath = "RT",
          Owner = self
        }
      }
    },
    Desc = GText("UI_Dye_Zoom"),
    bLongPress = false
  }
  self.RightThumbstickAnalogBottomKeyInfoList = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "RH"}
    },
    Desc = GText("UI_CTL_RotatePreview")
  }
  self.ESCKeyInfoList = {
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(EKeys.Escape.KeyName),
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
  self.BottomKeyInfoList = {
    self.HideUIKeyInfoList,
    self.ZoomKeyInfoList,
    self.RightThumbstickAnalogBottomKeyInfoList,
    self.ESCKeyInfoList
  }
end

function M:InitCommonTab()
  if not self.Com_Tab then
    RedPrint("[外观导入] 初始化通用页签失败：Com_Tab 为空")
    return
  end
  self:CreateKeySetting()
  self.Com_Tab:Init({
    PlatformName = self.PlatformName,
    TitleName = GText("UI_AppearanceScore_Import"),
    LeftKey = "NotShow",
    RightKey = "NotShow",
    GamePadLeftKey = "NotShow",
    GamePadRightKey = "NotShow",
    DynamicNode = {"Back", "BottomKey"},
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.TryClose,
    BottomKeyInfo = self.BottomKeyInfoList
  }, true)
  self.bCommonTabInited = true
  self:RefreshComTabTitle()
  if self.Com_Tab.SetBottomKeyInfoVisible then
    self.Com_Tab:SetBottomKeyInfoVisible(self.IsPC)
  end
end

function M:RefreshComTabTitle()
  if not self.Com_Tab then
    return
  end
  local TitleText = GText("UI_AppearanceScore_Import")
  if self.Com_Tab.UpdateTopTitle then
    self.Com_Tab:UpdateTopTitle(TitleText)
    return
  end
  if self.Com_Tab.Text_Title and self.Com_Tab.Text_Title.SetText then
    self.Com_Tab.Text_Title:SetText(TitleText)
    if self.Com_Tab.Text_Title.SetVisibility then
      self.Com_Tab.Text_Title:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    return
  end
  if self.Com_Tab.Title_Tab and self.Com_Tab.Title_Tab.SetText then
    self.Com_Tab.Title_Tab:SetText(TitleText)
    if self.Com_Tab.Title_Tab.SetVisibility then
      self.Com_Tab.Title_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  if self.Com_Tab.Panel_Tab and self.Com_Tab.Panel_Tab.SetVisibility then
    self.Com_Tab.Panel_Tab:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:RefreshBottomKeyInfo()
  if not self.Com_Tab then
    RedPrint("[外观导入] 刷新底部按键信息失败：Com_Tab 为空")
    return
  end
  if not self.BottomKeyInfoList then
    self:CreateKeySetting()
  end
  if self.IsPC and self.IsGamepadInput and self.RefreshImportBottomKeyInfo then
    self:RefreshImportBottomKeyInfo()
    return
  end
  if self.Com_Tab.UpdateBottomKeyInfo then
    self.Com_Tab:UpdateBottomKeyInfo(self.BottomKeyInfoList)
  elseif self.IsPC then
    RedPrint("[外观导入] 刷新底部按键信息失败：Com_Tab 缺少 UpdateBottomKeyInfo")
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self.CurInputType = CurInputType
  self.IsPC = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
  self.PlatformName = self.IsPC and "PC" or "Mobile"
  self.EnableMouseWheel = self.IsPC
  if not self.Com_Tab then
    return
  end
  if not self.bCommonTabInited then
    self:InitCommonTab()
  end
  if self.Com_Tab.SetBottomKeyInfoVisible then
    self.Com_Tab:SetBottomKeyInfoVisible(self.IsPC)
  end
  if self.OnImportInputTypeChanged then
    self:OnImportInputTypeChanged(CurInputType, CurGamepadName)
  end
  self:RefreshComTabTitle()
  self:RefreshBottomKeyInfo()
end

function M:OnBackKeyDown()
  self:TryClose()
  return UIUtils.Handled, true
end

function M:OnHideUIKeyDown()
  if not self.IsPC then
    return UIUtils.Unhandled, false
  end
  self.bSelfHidden = not self.bSelfHidden
  if self.IMG_Click and self.IMG_Click.Slot and self.IMG_Click.Slot.SetZOrder then
    self.IMG_Click.Slot:SetZOrder(self.bSelfHidden and 10 or -1)
  end
  self:SetRenderOpacity(self.bSelfHidden and 0 or 1)
  self:SetFocus()
  return UIUtils.Handled, true
end

function M:OnBackgroundClicked()
  if self.bSelfHidden then
    self:OnHideUIKeyDown()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if not self.IsPC then
    return UIUtils.Unhandled
  end
  if self.HandleImportKeyDown then
    local Reply, IsHandled = self:HandleImportKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  if not self.IsPC then
    return UIUtils.Unhandled
  end
  if self.HandleImportRepeatKeyDown then
    local Reply, IsHandled = self:HandleImportRepeatKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not self.IsPC then
    return UIUtils.Unhandled
  end
  if self.HandleImportAnalogValueChanged then
    local Reply, IsHandled = self:HandleImportAnalogValueChanged(MyGeometry, InAnalogInputEvent)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.HandleImportFocusReceived then
    return self:HandleImportFocusReceived(MyGeometry, InFocusEvent)
  end
  return M.Super.OnFocusReceived(self, MyGeometry, InFocusEvent)
end

function M:PlayInAnim()
  if self.In then
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
  end
end

function M:PlayOutAnim()
  if self.Out then
    self:StopAnimation(self.In)
    self:PlayAnimation(self.Out)
  else
    self:Close()
  end
end

function M:TryClose()
  if self:IsImportWindowOpen() then
    self:CloseImportWindow()
    return
  end
  self:PlayOutAnim()
end

function M:RealClose()
  M.Super.RealClose(self)
  if self.OnCloseCallback then
    self.OnCloseCallback(self.CloseCallbackParent)
  end
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:On_IMG_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

function RefreshSharerTitleWidget(OwnerWidget, SharerInfo)
  if not OwnerWidget.WS_Title or not OwnerWidget.Overlay_Title then
    return
  end
  local TitleBefore = SharerInfo and SharerInfo.TitleBefore or nil
  local TitleAfter = SharerInfo and SharerInfo.TitleAfter or nil
  local HasTitle = (nil ~= TitleBefore or nil ~= TitleAfter) and (not TitleBefore or not (TitleBefore < 0) or not TitleAfter or not (TitleAfter < 0))
  if OwnerWidget.Overlay_Title.ClearChildren then
    OwnerWidget.Overlay_Title:ClearChildren()
  end
  if not HasTitle then
    OwnerWidget.WS_Title:SetActiveWidgetIndex(1)
    return
  end
  OwnerWidget.WS_Title:SetActiveWidgetIndex(0)
  local TitleFrame = SharerInfo and SharerInfo.TitleFrame or nil
  if not TitleFrame or TitleFrame < 0 then
    TitleFrame = 10001
  end
  local TitleFrameWidget = UIManager(OwnerWidget):LoadTitleFrameWidget(TitleFrame)
  if not TitleFrameWidget then
    RedPrint("[外观导入] 加载分享者称号框失败，TitleFrame=" .. tostring(TitleFrame))
    return
  end
  OwnerWidget.Overlay_Title:AddChildToOverlay(TitleFrameWidget)
  TitleFrameWidget:SetTitleContent(TitleBefore, TitleAfter)
end

function RefreshPreviewCharIcon(OwnerWidget, CharId)
  local CharData = DataMgr.Char and DataMgr.Char[CharId] or nil
  if not CharData then
    RedPrint("[外观导入] 刷新预览角色头像失败，缺少角色配置，CharId=" .. tostring(CharId))
    return
  end
  if OwnerWidget.Icon_Avatar then
    local Path = "/Game/UI/Texture/Dynamic/Image/Head/Mini/T_Normal_Mini_" .. CharData.GUIPathVariable
    OwnerWidget.Icon_Avatar:SetBrushResourceObject(LoadObject(Path))
  end
end

AssembleComponents(M)
return M
