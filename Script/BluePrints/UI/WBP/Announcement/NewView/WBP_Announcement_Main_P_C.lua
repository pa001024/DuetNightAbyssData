require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Announcement.NewView.WBP_Announcement_Main_C"
})

function M:Construct()
  M.Super.Construct(self)
  self.WebContent:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.WebContent:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.WebContent:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.WebContent:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    self.OnWebContentNavLeft
  })
  self.WebContent:SetNavigationRuleBase(EUINavigation.Next, EUINavigationRule.Stop)
  self.WebContent:SetNavigationRuleBase(EUINavigation.Previous, EUINavigationRule.Stop)
end

function M:OnWebContentNavLeft()
  if self.CurContent and self.CurContent.Widget then
    return self.CurContent.Widget
  end
  return self.WebContent
end

function M:_CreateTabParams()
  local TabParams = {
    PlatformName = PlatformName,
    Tabs = {
      {
        Text = GText(DataMgr.NoticeTab[1].Text),
        TabId = 1,
        Icon = DataMgr.NoticeTab[1].IconPath
      },
      {
        Text = GText(DataMgr.NoticeTab[2].Text),
        TabId = 2,
        Icon = DataMgr.NoticeTab[2].IconPath
      },
      {
        Text = GText(DataMgr.NoticeTab[3].Text),
        TabId = 3,
        Icon = DataMgr.NoticeTab[3].IconPath
      }
    },
    LeftKey = "Q",
    RightKey = "E",
    LeftGamePadKey = "LeftShoulder",
    RightGamePadKey = "RightShoulder",
    ChildWidgetBPPath = "WidgetBlueprint'/Game/UI/WBP/Announcement/Widget/WBP_Announcement_TabCell.WBP_Announcement_TabCell'"
  }
  return TabParams
end

function M:InitUIInfo(...)
  M.Super.InitUIInfo(self, ...)
  self:AddTimer(0.1, function()
    self:SetFocus()
  end)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Gamepad then
    self.Key_Back:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          ClickCallback = self.Close,
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Quit")
    })
    self.Key_Fail:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          ClickCallback = self.ClickRetry,
          Owner = self
        }
      }
    })
    self.Key_Fail:SetVisibility(UIConst.VisibilityOp.Visible)
    if self.Main:IsVisible() then
      if self.CurContent and self.CurContent.Widget then
        self.CurContent.Widget:SetFocus()
      else
        self.List_Announcement:SetFocus()
      end
    end
    self.WebContent:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.WebContent:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Key_Back:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.Close,
          Owner = self
        }
      },
      Desc = GText("UI_CTL_Quit")
    })
    self.Key_Fail:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:UpdateWebOnInputTypeChange(CurInputType, CurGamepadName)
end

function M:UpdateWebOnInputTypeChange(CurInputType, CurGamepadName)
  if "Generic" == CurGamepadName then
    if CurInputType == ECommonInputType.Gamepad then
      CurGamepadName = "XboxOne"
    elseif CurInputType == ECommonInputType.MouseAndKeyboard then
      CurGamepadName = ""
    end
  end
  self.WebContent:ExecuteJavascript(string.format("setCtrlType(\"%s\")", CurGamepadName))
end

function M:OnWebContentLoadDone()
  M.Super.OnWebContentLoadDone(self)
  local CurInputType = self.GameInputModeSubsystem:GetCurrentInputType()
  local CurGamepadName = self.GameInputModeSubsystem:GetCurrentGamepadName()
  self:UpdateWebOnInputTypeChange(CurInputType, CurGamepadName)
end

function M:OnPreviewKeyDown(MyGeo, InKeyEvent)
  local HandleRes = M.Super.OnPreviewKeyDown(self, MyGeo, InKeyEvent)
  local InKey = UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bHandled = false
  if InKeyName == UIConst.GamePadKey.DPadUp then
    self.WebContent:ExecuteJavascript("announceSelect(\"up\")")
    self.WebContent:ExecuteJavascript("announceConfirm()")
    bHandled = true
  elseif InKeyName == UIConst.GamePadKey.DPadDown then
    self.WebContent:ExecuteJavascript("announceSelect(\"down\")")
    self.WebContent:ExecuteJavascript("announceConfirm()")
    bHandled = true
  end
  if bHandled then
    return UIUtils.Handled
  end
  return HandleRes
end

function M:OnKeyUp(MyGeo, InKeyEvent)
  local HandleRes = M.Super.OnKeyUp(self, MyGeo, InKeyEvent)
  local InKey = UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bHandled = false
  local bWebFocus = self.WebContent:HasAnyUserFocus() or self.WebContent:HasFocusedDescendants()
  if self.Tab_Announcement:Handle_KeyEventOnPC(InKeyName) then
    bHandled = true
  elseif self.Tab_Announcement:Handle_KeyEventOnGamePad(InKeyName) then
    bHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if bWebFocus then
      if self.CurContent and self.CurContent.Widget then
        self.CurContent.Widget:SetFocus()
        self.WebContent:ExecuteJavascript("syncIndicator(\"done\")")
      end
      bHandled = true
    else
      self:Close()
      bHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self.WebContent:ExecuteJavascript("scrollToEdge(\"top\")")
    bHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    self.WebContent:ExecuteJavascript("scrollToEdge(\"bottom\")")
    bHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if bWebFocus then
      if self.CurContent.Conf.HasLinkImage then
        UKismetSystemLibrary.LaunchURL(self.CurContent.Conf.ImageUrl)
      elseif self.CurContent.Conf.UIStyle == AnnounceCommon.ContentUIStyle.Default then
        self.WebContent:ExecuteJavascript("toggleCurGrp()")
      end
      bHandled = true
    end
    if 1 == self.WS_State:GetActiveWidgetIndex() then
      self:ClickRetry()
      bHandled = true
    end
  end
  if bHandled then
    return UIUtils.Handled
  end
  return HandleRes
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local bWebFocus = self.WebContent:HasAnyUserFocus() or self.WebContent:HasFocusedDescendants()
  if InKeyName == UIConst.GamePadKey.LeftAnalogX then
    local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if a > 0.4 then
      if bWebFocus then
        self.WebContent:ExecuteJavascript("syncIndicator(\"active\")")
        DebugPrint("Execute syncIndicator(\"active\")")
      end
    elseif a < -0.4 and not bWebFocus then
      self.WebContent:ExecuteJavascript("syncIndicator(\"done\")")
      DebugPrint("Execute syncIndicator(\"done\")")
    end
  elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
    if bWebFocus then
      self:_ScrollWebContent(InAnalogInputEvent)
    end
  elseif InKeyName == UIConst.GamePadKey.RightAnalogY and not bWebFocus then
    self:_ScrollWebContent(InAnalogInputEvent)
  end
  return UWidgetBlueprintLibrary.Unhandled()
end

function M:_ScrollWebContent(InAnalogInputEvent)
  if self.bSelectionExpand ~= self.bLastSelectionExp then
    self.WebContent:ExecuteJavascript("syncIndicator(\"active\")")
    self.bLastSelectionExp = self.bSelectionExpand
  end
  local a = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * -self.ScrollSpeed
  self.WebContent:ExecuteJavascript(string.format("handleAnalogScroll(%s)", a))
end

function M:Destruct()
  M.Super.Destruct(self)
end

return M
