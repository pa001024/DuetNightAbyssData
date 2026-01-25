require("UnLua")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}

function M:Construct()
  EventManager:AddEvent(EventID.MountsItemOnClick, self, self.MountsItemOnClick)
  if not self.IsBind then
    self.IsBind = true
    self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
  end
end

function M:MountsItemOnClick(SelectMountId)
  if self.DisplayMountId == SelectMountId then
    return
  end
  self.DisplayMountId = SelectMountId
  self:RefreshMountModel()
  self:InitMountInfoUI()
end

function M:GetDisplayMountId()
  return self.DisplayMountId
end

function M:SetFocus_Lua()
  if self.IsFocusItemDetail then
    self.WBP_MountsMain_Item02.WBP_Com_Tips_AccessItem:SetFocus()
  elseif self.IsFocusSortList then
    self.Common_Sort_List:SetFocus()
  else
    self.ListView_Items:SetFocus()
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self:RefreshMountMainFocus()
  return UIUtils.Handle
end

function M:OnLoaded(...)
  self.bSelfHidden = false
  self.IsFocusSortList = false
  self.IsRiderMount = false
  self.IsPlayOut = false
  self:InitCommonTab()
  self:InitMountsList()
  self:CreateMount()
  self:InitMountInfoUI()
  self:PlayAnimation(self.In)
  if self.WBP_MountsMainBtn then
    self.WBP_MountsMainBtn.Btn_Hide:BindEvents(self, {
      OnClicked = self.HideMountUI
    })
    self.WBP_MountsMainBtn.Btn_Riding:BindEvents(self, {
      OnClicked = self.RiderMount
    })
  end
  self:RefreshMountMainFocus(true)
  self:OnUpdateUIStyleByInputTypeChange()
end

function M:InitCommonTab()
  self.Com_Tab:Init({
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {},
    TitleName = GText("UI_Mount"),
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
  self.Key_Method:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  self.WBP_MountsMain_Item02.Key_Method:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Right"}
    }
  })
end

function M:InitItemDetailAccessTab()
  self.Com_Tab:UpdateBottomKeyInfo({
    {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Ensure"),
      bLongPress = false
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  })
end

function M:InitMountBottomTab()
  self.Com_Tab:UpdateBottomKeyInfo({
    {
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "R",
          ClickCallback = self.RiderMount,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      },
      Desc = GText("骑乘/离开")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = CommonUtils:GetKeyText("U"),
          ClickCallback = self.HideMountUI,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      },
      Desc = GText("UI_Dye_HideUI")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = CommonUtils:GetKeyText("Mouse_Button"),
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Or",
          ImgShortPath = "RT",
          Owner = self
        },
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
      Desc = GText("UI_Dye_Zoom")
    },
    {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "RH"}
      },
      Desc = GText("UI_CTL_RotatePreview")
    },
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }
  })
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  local IsGamePad = GameInputModeSubsystem and GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad
  if IsGamePad then
    self.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RiderMount()
  self.IsRiderMount = not self.IsRiderMount
  if self.IsRiderMount then
    self.ActorController:HidePlayerOnMount(false)
  else
    self.ActorController:HidePlayerOnMount(true)
  end
end

function M:HideMountUI()
  self.bSelfHidden = not self.bSelfHidden
  if self.bSelfHidden then
    self.Image_Click.Slot:SetZOrder(10)
    self:SetFocus()
    self:SetRenderOpacity(0)
  else
    self.Image_Click.Slot:SetZOrder(-1)
    self:SetRenderOpacity(1)
    if self.IsFocusItemDetail then
      self.WBP_MountsMain_Item02.WBP_Com_Tips_AccessItem:SetFocus()
    elseif self.IsFocusSortList then
      self.Common_Sort_List:SetFocus()
    else
      self.ListView_Items:SetFocus()
    end
  end
end

function M:OnCameraScrollBackwardKeyDown()
  self:ScrollCamera(1)
end

function M:OnCameraScrollForwardKeyDown()
  self:ScrollCamera(-1)
end

function M:ScrollCamera(DeltaMove)
  if self.ActorController then
    self.ActorController:OnScrolling(DeltaMove)
  end
end

function M:SortMountListForNormal(SortType)
  if not self.MountContents then
    return
  end
  SortType = SortType or CommonConst.DESC
  if SortType == CommonConst.DESC then
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        return MountA.SortPriority > MountB.SortPriority
      end
      return MountA.HasMount
    end)
  else
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        return MountA.SortPriority < MountB.SortPriority
      end
      return not MountA.HasMount
    end)
  end
end

function M:SortMountListForRarity(SortType)
  if not self.MountContents then
    return
  end
  SortType = SortType or CommonConst.DESC
  if SortType == CommonConst.DESC then
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.MountRarity ~= MountB.MountRarity then
          return MountA.MountRarity > MountB.MountRarity
        end
        return MountA.SortPriority > MountB.SortPriority
      end
      return MountA.HasMount
    end)
  else
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.MountRarity ~= MountB.MountRarity then
          return MountA.MountRarity < MountB.MountRarity
        end
        return MountA.SortPriority < MountB.SortPriority
      end
      return not MountA.HasMount
    end)
  end
  self:RefreshMountList()
end

function M:InitMountsList()
  self.ListView_Items:ClearListItems()
  self.MountContents = nil
  self.DisplayMountId = nil
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MountConfigData = DataMgr.Mount or {}
  local MountContents = {}
  for _, MountData in pairs(MountConfigData) do
    local MountContent = NewObject(UIUtils.GetCommonItemContentClass())
    MountContent.MountId = MountData.MountId
    MountContent.HasMount = Avatar:HasMountById(MountData.MountId)
    MountContent.MountId = MountData.MountId
    MountContent.SortPriority = MountData.SortPriority
    MountContent.MountRarity = MountData.MountRarity
    table.insert(MountContents, MountContent)
  end
  if 0 == #MountContents then
    return
  end
  self.MountContents = MountContents
  self:SortMountListForNormal()
  self.DisplayMountId = MountContents[1].MountId
  self:RefreshMountList()
  self.SortByFunction = {
    [1] = self.SortMountListForNormal,
    [2] = self.SortMountListForRarity
  }
  self.Common_Sort_List:Init(self, {
    GText("UI_Select_Default"),
    GText("UI_Select_Unique")
  }, CommonConst.DESC, {
    OnGetBackFocusWidget = function()
      self.IsFocusSortList = false
      return self.ListView_Items
    end
  })
  self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.MountsMainOnSelectionsChanged)
  self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.MountsMainOnSortTypeChanged)
end

function M:RefreshMountList()
  self.ListView_Items:ClearListItems()
  for Index, MountContent in ipairs(self.MountContents) do
    MountContent.ItemIndex = Index
    MountContent.MountsMain = self
    self.ListView_Items:AddItem(MountContent)
  end
  self.ListView_Items.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
end

function M:MountsMainOnSelectionsChanged(SortBy, SortType)
  self.SortByFunction[SortBy](self, SortType)
  self:RefreshMountList()
end

function M:MountsMainOnSortTypeChanged(SortType, SortBy)
  self.SortByFunction[SortBy](self, SortType)
  self:RefreshMountList()
end

function M:CreateMount()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.ActorController then
    return
  end
  self.ActorController = ActorController:New({
    ViewUI = self,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    Char = Avatar.Chars[Avatar.CurrentChar]
  })
  self.ActorController:OnOpened()
  self.ActorController:SetArmoryCameraTag(CommonConst.ArmoryType.Char)
  self.ActorController:HidePlayerOnMount(true)
  self.ActorController:CreateMount(self.DisplayMountId)
end

function M:RefreshMountModel()
  if not self.ActorController then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ActorController:DestroyMount()
  self.ActorController:CreateMount(self.DisplayMountId)
end

function M:InitMountInfoUI()
  if not self.DisplayMountId then
    return
  end
  local MountConfig = DataMgr.Mount[self.DisplayMountId]
  self.Tag_Quality:Init(MountConfig.MountRarity)
  self.Text_SkinName:SetText(GText(MountConfig.MountName))
  self.Text_Info:SetText(GText(MountConfig.MountDes))
  self.WBP_MountsMain_Item02.Text_Message:SetText(GText(MountConfig.UseLimitDes))
  self.WBP_MountsMain_Item02.Method:ClearChildren()
  if MountConfig.AccessKey then
    for _, Access in pairs(MountConfig.AccessKey) do
      PageJumpUtils:GetItemAccess(self.WBP_MountsMain_Item02, self.DisplayMountId, "Resource", Access, "MountsMain", function()
        self:RefreshItemDetailFocus()
      end)
    end
  end
  PageJumpUtils:SortAccessItem(self.WBP_MountsMain_Item02.Method)
end

function M:Destruct()
  if self.ActorController then
    self.ActorController:DestroyMount()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
  EventManager:RemoveEvent(EventID.MountsItemOnClick, self)
  self.Super.Destruct(self)
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and "Gamepad_DPad_Right" == InKeyName then
    self:RefreshItemDetailFocus()
    IsHandled = true
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:RefreshMountMainFocus(IsInit)
  if self.bSelfHidden then
    return
  end
  if not self.IsFocusItemDetail and not IsInit then
    return
  end
  self.IsFocusItemDetail = false
  self.ListView_Items:SetFocus()
  self:InitMountBottomTab()
  self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:RefreshItemDetailFocus()
  if self.IsFocusItemDetail or 0 == self.WBP_MountsMain_Item02.Method:GetChildrenCount() then
    return
  end
  self.WBP_MountsMain_Item02.WBP_Com_Tips_AccessItem:SetFocus()
  self.WBP_MountsMain_Item02.Key_Method:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:InitItemDetailAccessTab()
  self.IsFocusItemDetail = true
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName then
    self:CloseSelf()
  elseif "R" == InKeyName then
    self:RiderMount()
  elseif "Gamepad_RightThumbstick" == InKeyName and not self.IsFocusItemDetail then
    self:RiderMount()
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.IsFocusItemDetail then
      self:RefreshMountMainFocus()
    else
      self:CloseSelf()
    end
  elseif "U" == InKeyName then
    self:HideMountUI()
  elseif "Gamepad_FaceButton_Left" == InKeyName and not self.IsFocusItemDetail then
    self:HideMountUI()
  elseif "Gamepad_LeftThumbstick" == InKeyName and not self.IsFocusItemDetail then
    self.Common_Sort_List:SetFocus()
    self.IsFocusSortList = true
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnRepeatKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftTriggerThreshold and not self.IsFocusItemDetail then
    self:OnCameraScrollBackwardKeyDown()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.RightTriggerThreshold and not self.IsFocusItemDetail then
    self:OnCameraScrollForwardKeyDown()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self:Close()
    self.IsPlayOut = false
  end
end

function M:CloseSelf()
  if self.IsPlayOut then
    return
  end
  self.IsPlayOut = true
  self:PlayAnimation(self.Out)
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
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

function M:OnBackgroundClicked()
  if self.bSelfHidden then
    self:HideMountUI()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName and not self.IsFocusItemDetail then
    if self.ActorController then
      local DeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 10
      self.ActorController:OnDragging({X = DeltaX})
    end
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

AssembleComponents(M)
return M
