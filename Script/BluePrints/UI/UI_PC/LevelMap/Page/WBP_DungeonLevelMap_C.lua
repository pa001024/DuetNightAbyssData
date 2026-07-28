require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, RegionID, ...)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, RegionID, ...)
  self.BackBtn = UIManager(self):CreateWidget("/Game/UI/WBP/Activity/Widget/SoloTreasure/Map/WBP_Activity_SoloTreasure_Map_BtnExit.WBP_Activity_SoloTreasure_Map_BtnExit")
  self.Pos_SoloTreasure_Exit:AddChild(self.BackBtn)
  self.BackBtn.Btn_Click.OnClicked:Add(self, self.OnUIReturnKeyDown)
  self.RealWildMap = UIManager(self):CreateWidget("/Game/UI/WBP/Map/Widget/RegionMap/WBP_Map_Region.WBP_Map_Region_C")
  self.WildMap:AddChild(self.RealWildMap)
  self.RealWildMap:InitInDungeon(RegionID, self, false)
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.RealWildMap)
  if CanvasSlot then
    CanvasSlot:SetOffsets(FMargin())
    local Anchors = CanvasSlot:GetAnchors()
    Anchors.Minimum = FVector2D(0, 0)
    Anchors.Maximum = FVector2D(1, 1)
    CanvasSlot:SetAnchors(Anchors)
  end
  self.RealWildMap:SetFocus()
  self.Tab:SetVisibility(ESlateVisibility.Collapsed)
  self.SliderPecent = 1
  local ConfigData = {
    InitValue = self.SliderPecent * 100,
    ClickInterval = 10,
    MinValue = 0,
    MaxValue = 100,
    OwnerPanel = self,
    AddBtnCallback = self.OnClickSliderAddorMinus,
    MinusBtnCallback = self.OnClickSliderAddorMinus,
    SliderChangeCallback = self.OnPlayerChangeSlider,
    PlatformName = CommonUtils.GetDeviceTypeByPlatformName(self),
    ForbidGamePadLTRTKey = true
  }
  self.Slider_Zoom:Init(ConfigData)
  self.WildMapKeys = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          ImgShortPath = "Mouse_Button"
        }
      },
      Desc = GText("UI_RegionMap_Scale")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          ImgShortPath = "SpaceBar",
          Owner = self,
          ClickCallback = self.OnSpaceDown
        }
      },
      Desc = GText("UI_Extraction_TM_2")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "V",
          Owner = self,
          ClickCallback = self.GoToCurrentPosition
        }
      },
      Desc = GText("UI_RegionMap_GotoCurrentPosition")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          Owner = self,
          ClickCallback = self.OnUIReturnKeyDown
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.WildMapGamePadKeys = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_RegionMap_GotoCurrentPosition")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  }
  self.WildMapGamePadEnsureKeys = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Tips_Ensure")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_RegionMap_GotoCurrentPosition")
    },
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  }
  self.BackKey = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          Owner = self,
          ClickCallback = self.OnUIReturnKeyDown
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.BackGamePadKey = {
    {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  }
  self.WildMapKeysShow = true
  self:UpdateWildMapKeys()
  EventManager:FireEvent(EventID.ShowCountDownTips)
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnClicked:Add(self, self.OnAreaClicked)
end

function M:OnUIReturnKeyDown()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
  self:OnReturnKeyDown()
end

function M:OnReturnKeyDown()
  if self:IsInteractiveOpen() then
    self:OnAreaClicked()
    self.RealWildMap:SetFocus()
    return
  end
  self:PlayOutAnim()
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.Auto_In) or self:IsAnimationPlaying(self.Auto_Out) then
    return
  end
  if self.RealWildMap then
    self.RealWildMap:PlayCloseAnimation()
  end
  AudioManager(self):SetEventSoundParam(self, "MapOpen", {ToEnd = 1})
  self:Close()
end

function M:ShoworHideBottomTab(bShow)
  if not self.DeviceInPc then
    return
  end
  if bShow then
    self.Tab_Bottom:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Tab_Bottom:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:ShoworHideTopTab(bShow)
end

function M:GetTabTopHeight()
  if self.Tab_Top and self.Tab_Top.Slot then
    return self.Tab_Top.Slot:GetSize().Y
  end
  return 0
end

function M:SetSliderZoomVisible(Visible)
  if not self.Slider_Zoom then
    return
  end
  self.Slider_Zoom:SetVisibility(Visible and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:BindAutoOutOnFinished(Callback)
  if self.Auto_Out then
    self:BindToAnimationFinished(self.Auto_Out, Callback)
  end
end

function M:UpdateWildMapKeys()
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "PC" then
    return
  end
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
    self.Key_Tip:UpdateKeyInfo((not self.WildMapKeysShow or self:IsInteractiveOpen()) and self.BackGamePadKey or self.WildMapGamePadKeys)
  else
    self.Key_Tip:UpdateKeyInfo((not self.WildMapKeysShow or self:IsInteractiveOpen()) and self.BackKey or self.WildMapKeys)
  end
end

function M:OnMouseWheelTurned(Percent)
  if self.RealWildMap then
    self.SliderPecent = Percent
  end
  self.Slider_Zoom:OnSliderValueChanged(Percent)
  AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
end

function M:OnClickSliderAddorMinus(CurrentCount, OldNumberValue)
  self.SliderPecent = CurrentCount / 100
  if self.RealWildMap then
    self.RealWildMap:OnScaleChange(self.SliderPecent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
  end
end

function M:OnPlayerChangeSlider(Value)
  self.SliderPecent = Value / 100
  if self.RealWildMap then
    self.RealWildMap:OnScaleChange(self.SliderPecent)
    AudioManager(self):PlayUISound(self, "event:/ui/common/map_process_bar_drag", nil, nil)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight or "M" == InKeyName then
    self:OnReturnKeyDown()
    return UWidgetBlueprintLibrary.Handled()
  end
end

function M:OnSpaceDown()
  if self.RealWildMap then
    self.RealWildMap:OpenKeyLocPanel()
  end
end

function M:RealClose()
  if self.RealWildMap then
    self.RealWildMap:RemoveFromParent()
  end
  M.Super.RealClose(self)
end

function M:IsInteractiveOpen()
  return false
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if self.LastInputDevice == CurInputDevice then
    return
  end
  self.LastInputDevice = CurInputDevice
  self:UpdateWildMapKeys()
  if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
    if self.RealWildMap then
      self.RealWildMap:SetFocus()
    end
  else
    local TopUI = UIManager(self):GetLastestAndFocusableUIWidgetObj()
    TopUI:SetFocus()
  end
end

function M:GoToCurrentPosition()
  self.RealWildMap:GoToCurrentPosition()
end

function M:AddChildToConvey(Widget)
  if self.Convey then
    self.Convey:AddChild(Widget)
  elseif self.RealWildMap and self.RealWildMap.Convey then
    self.RealWildMap.Convey:AddChild(Widget)
  end
end

function M:AddChildToPosSoloTreasureKeyLocation(Widget)
  if self.Pos_SoloTreasure_KeyLocation then
    self.Pos_SoloTreasure_KeyLocation:AddChild(Widget)
  elseif self.RealWildMap and self.RealWildMap.Pos_SoloTreasure_KeyLocation then
    self.RealWildMap.Pos_SoloTreasure_KeyLocation:AddChild(Widget)
  end
end

function M:OpenSelectList(SelectTable)
  if self.ScrollBox_Interactive:GetChildrenCount() > 0 then
    return
  end
  self.Panel_Interactive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.ScrollBox_Interactive:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Interactive_Locate:SetVisibility(ESlateVisibility.Collapsed)
  self:AddTimer(0.001, function()
    local ItemSize = FVector2D(612, 60)
    local AbsolutePosition = UUIFunctionLibrary.GetGeometryAbsolutePosition(SelectTable[1]:GetCachedGeometry())
    local LocalPosition = USlateBlueprintLibrary.AbsoluteToLocal(self.Panel_Interactive:GetCachedGeometry(), AbsolutePosition)
    local MaxSize = self.RealWildMap:GetMaxSize()
    local Alignment = self.Overlay_Interactive.Slot:GetAlignment()
    if LocalPosition.Y + #SelectTable * ItemSize.Y >= MaxSize.Y then
      Alignment:Set(0, 1)
    else
      Alignment:Set(0, 0)
    end
    if LocalPosition.X + SelectTable[1]:GetDesiredSize().X + ItemSize.X > MaxSize.X then
      Alignment:Set(1, Alignment.Y)
    else
      LocalPosition:Set(LocalPosition.X + SelectTable[1]:GetDesiredSize().X, LocalPosition.Y)
      Alignment:Set(0, Alignment.Y)
    end
    self.Overlay_Interactive.Slot:SetAlignment(Alignment)
    self.Overlay_Interactive:SetRenderTranslation(LocalPosition)
  end)
  self.Img_Mouse:SetVisibility(ESlateVisibility.Collapsed)
  for i = 1, #SelectTable do
    local Item = UIManager(self):_CreateWidgetNew("RegionMapSelectItem")
    self.ScrollBox_Interactive:AddChild(Item)
    Item:Init(SelectTable[i], self)
    if 1 == i then
      Item:SetFocus()
    end
  end
  self:UpdateWildMapKeys()
end

function M:OnAreaClicked()
  if self:IsInteractiveOpen() and not self.AreaClicked then
    self.AreaClicked = true
    for _, Child in pairs(self.ScrollBox_Interactive:GetAllChildren():ToTable()) do
      Child:PlayAnimation(Child.Out)
    end
    for _, Child in pairs(self.Interactive_Locate.Wbox:GetAllChildren():ToTable()) do
      Child:PlayAnimation(Child.Out)
    end
    self.RealWildMap:ClosePanel(false)
    self:AddTimer(0.2, function()
      self.AreaClicked = false
      self.ScrollBox_Interactive:ClearChildren()
      self.Panel_Interactive:SetVisibility(ESlateVisibility.Collapsed)
      self:UpdateWildMapKeys()
    end)
  end
end

function M:IsInteractiveOpen()
  return self.Panel_Interactive:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.RealWildMap then
    self.RealWildMap:SetFocus()
  end
end

return M
