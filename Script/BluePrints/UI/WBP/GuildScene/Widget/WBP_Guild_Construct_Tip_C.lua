require("UnLua")
require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  self.bIsFocusable = true
  self.bIsDealWithVirtualAccept = true
end

function M:Destruct()
end

function M:InitItemInfo(ItemType, ItemId, Uuid, Content)
  self.ItemType = ItemType
  self.ItemId = ItemId
  self.Uuid = Uuid
  self.Content = Content
  local ItemData = DataMgr.GuildItem and DataMgr.GuildItem[ItemId]
  if not ItemData then
    return
  end
  self.ItemData = ItemData
  self.IsUnLock = true
  if ItemData.LevelLimit then
    local GuildInfo = GuildController:GetModel():GetCurrGuild()
    local Level = GuildInfo and GuildInfo.Level and GuildInfo.Level or 1
    self.IsUnLock = Level >= ItemData.LevelLimit
    self.GuildInfo = GuildInfo
  end
  self:InitUIWidget()
  self:RefreshUI()
  self:BindButtonEvents()
  self:InitGamepad()
end

function M:InitUIWidget()
  self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
  self.Text_Hold01:SetText(GText("UI_Consumable_HasGot"))
  self.Btn_Place:SetText(GText("UI_PlaceComponent"))
  self.Btn_Lock:SetText(GText("GuildLv_Insufficient"))
  self.Btn_Lock:SetGamepadIconVisibility(false)
  self:InitDescScrollHeight()
end

function M:RefreshUI()
  if not self.ItemData then
    return
  end
  self.Text_ItemName:SetText(GText(self.ItemData.Name))
  if self.ItemData.Icon then
    local IconTexture = LoadObject(self.ItemData.Icon)
    if IconTexture then
      self.Icon_Item:SetBrushFromTexture(IconTexture)
    end
  end
  self.WS_Btn:SetActiveWidgetIndex(self.IsUnLock and 0 or 1)
  self.WS_Show:SetActiveWidgetIndex(self.IsUnLock and 0 or 1)
  if self.IsUnLock and self.Content and self.Content.LeftNum then
    self.Text_Hold02:SetText(" " .. self.Content.LeftNum)
  end
  self.Text_LongDescribe:SetText(GText(self.ItemData.Desc))
  self:InitPlacedLine()
  self:InitDataDetails()
end

function M:InitDescScrollHeight()
  self.ScrollHeight = nil
  self.SizeBox_Desc:SetMaxDesiredHeight(200)
  self:AddTimer(0.01, function()
    self:ApplyDescScrollHeight()
  end)
end

function M:ApplyDescScrollHeight()
  local ParentWidget = self.ParentWidget
  if not (ParentWidget and ParentWidget.EMScrollBox_1) or not self.SizeBox_Desc then
    return
  end
  self.SizeBox:ClearHeightOverride()
  self.SizeBox:ClearMaxDesiredHeight()
  self:ForceLayoutPrepass()
  ParentWidget:ForceLayoutPrepass()
  local ScrollHeight = ParentWidget.EMScrollBox_1:GetDesiredSize().Y - ParentWidget.SizeBox:GetDesiredSize().Y
  if ParentWidget.Panel_Extra and ParentWidget.Panel_Extra:IsVisible() then
    ScrollHeight = ScrollHeight + ParentWidget.Panel_Extra:GetDesiredSize().Y
  end
  if ParentWidget.Panel_Controller and ParentWidget.Panel_Controller:IsVisible() then
    ScrollHeight = ScrollHeight + ParentWidget.Panel_Controller:GetDesiredSize().Y
  end
  if ScrollHeight > 0 then
    local DescDesiredHeight = self.SizeBox_Desc:GetDesiredSize().Y - ScrollHeight - 3
    if DescDesiredHeight > 0 then
      self:InitScrollDesc(DescDesiredHeight)
    end
  end
end

function M:InitScrollDesc(DescDesiredHeight)
  self.Key_Confirm:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "RV",
        Owner = self
      }
    },
    Desc = GText("UI_Controller_Slide")
  })
  self.Key_Confirm:SetVisibility(UE4.ESlateVisibility.Visible)
  self.ScrollBox_Desc:ScrollToStart()
  self.SizeBox_Desc:SetMaxDesiredHeight(DescDesiredHeight)
  self:SetFocus()
end

function M:InitPlacedLine()
  if not self.Content.PlacedNum or 0 == self.Content.PlacedNum then
    return
  end
  local PlacedNum = self.Content.PlacedNum
  local ComponentTypeObj
  for _, v in pairs(DataMgr.GuildEntranceCompType or {}) do
    if PlacedNum < v.LimitNum then
      ComponentTypeObj = v
      break
    end
  end
  if not ComponentTypeObj or not ComponentTypeObj.LimitNum then
    return
  end
  local IsLimited = PlacedNum >= ComponentTypeObj.LimitNum
  local Text_PlacedLine = string.format(GText("UI_ComponentCount"), tostring(ComponentTypeObj.TypeName or "")) .. PlacedNum .. "/" .. ComponentTypeObj.LimitNum
  local Text_Widget = IsLimited and self.Line.Text_Max or self.Line.Text_Level
  self.Line.Switch_Text:SetActiveWidgetIndex(IsLimited and 2 or 0)
  Text_Widget:SetText(GText(Text_PlacedLine))
end

function M:InitDataDetails()
  if not self.DataDetails or not self.ItemData then
    return
  end
  self.Panel_InfoData:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.DataDetails:ClearChildren()
  local Properties = {
    {
      Name = "UI_GuildLevelRequirement",
      Value = "Lv." .. tostring(self.ItemData.LevelLimit)
    },
    {
      Name = "UI_PerformanceCost",
      Value = tostring(self.ItemData.Cost)
    }
  }
  for i, Prop in ipairs(Properties) do
    local PropertyItem = UIManager(self):_CreateWidgetNew("WeaponItemDetailItems")
    PropertyItem.Text_Property:SetText(GText(Prop.Name))
    PropertyItem.Text_Num:SetText(Prop.Value)
    if 1 == i % 2 then
      PropertyItem.Bg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      PropertyItem.Bg:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.DataDetails:AddChildToVerticalBox(PropertyItem)
  end
end

function M:BindButtonEvents()
  self.Btn_Shop.Button_Area.OnClicked:Clear()
  self.Btn_Place.Button_Area.OnClicked:Clear()
  self.Btn_Shop.Button_Area.OnClicked:Add(self, self.OnShopClicked)
  self.Btn_Place.Button_Area.OnClicked:Add(self, self.OnPlaceClicked)
end

function M:InitGamepad()
  self:SetOwnerGamepadPromptVisible(false)
  self:InitControllerKey()
  self:BindParentKeyDownEvent()
  self:AddInputMethodChangedListen()
  self:UpdateUIStyleInPlatform()
  self:SetIsShowNavigateGuide(false)
end

function M:BindParentKeyDownEvent()
  if not self.ParentWidget then
    return
  end
  self.ParentWidget.KeyDownEvent = {
    Obj = self,
    Callback = self.OnKeyDown
  }
  self.ParentWidget.HandleKeyDown = true
end

function M:InitControllerKey()
  self.Controller_Shop:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        Owner = self
      }
    },
    Desc = GText("UI_Tips_Close")
  })
  self.Btn_Place:SetGamePadImg("A")
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:BP_GetDesiredFocusTarget()
  return self
end

function M:UpdateUIStyleInPlatform()
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if IsGamepad and UIUtils.HasAnyFocus(self.ParentWidget) then
    self:SetFocus()
  end
  local GamepadVisibility = IsGamepad and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed
  self.Panel_Controller:SetVisibility(GamepadVisibility)
  self.Panel_Controller_Shop:SetVisibility(GamepadVisibility)
end

function M:SetOwnerGamepadPromptVisible(bVisible)
  local OwnerWidget = self.Content and self.Content.OwnerWidget
  local Parent = self.Content and self.Content.OwnerPanel
  if OwnerWidget and OwnerWidget.SetTipsModalOpened then
    OwnerWidget:SetTipsModalOpened(not bVisible)
  end
  if Parent and Parent.SetTipsModalOpened then
    Parent:SetTipsModalOpened(not bVisible)
  end
end

function M:OnShopClicked()
  local Params = {}
  Params.ItemData = {
    ID = self.ItemData.ItemID or self.ItemData.ID or self.ItemId,
    ComponentName = self.ItemData.Name,
    ComponentDesc = self.ItemData.Desc,
    PicAlbum = self.ItemData.Icon,
    ConsumeCurrency = CommonConst.GuildFundsCoin,
    ConsumeNum = self.ItemData.Cost or self.ItemData.PerformanceCost or self.ItemData.ConsumeValue,
    SourceData = self.ItemData
  }
  UIManager(self):ShowCommonPopupUI(100384, Params, self)
end

function M:OnPlaceClicked()
  if self.Content and self.Content.PlaceCallback then
    self.Content.PlaceCallback(self, self.ItemId)
  end
end

function M:CloseWidget()
  self:SetOwnerGamepadPromptVisible(true)
  local DetailsPanel = self.ParentWidget
  if DetailsPanel and DetailsPanel.ParentWidget and DetailsPanel.ParentWidget.CloseItemDetailsWidget then
    DetailsPanel.ParentWidget:CloseItemDetailsWidget(true)
  elseif DetailsPanel and DetailsPanel.Parent and DetailsPanel.Parent.Close then
    DetailsPanel.Parent:Close()
  elseif self.Close then
    self:Close()
  end
end

function M:OnGamePadDown(InKeyName)
  if InKeyName == Const.GamepadFaceButtonDown then
    self:OnPlaceClicked()
    return true
  elseif InKeyName == Const.GamepadFaceButtonRight then
    self:CloseWidget()
    return true
  elseif InKeyName == Const.GamepadFaceButtonUp then
    self:OnShopClicked()
    return true
  end
  return false
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:OnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.ScrollBox_Desc:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.ScrollBox_Desc:GetScrollOffsetOfEnd())
    self.ScrollBox_Desc:SetScrollOffset(NextOffset)
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

return M
