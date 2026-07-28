require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.bIsFocusable = true
  self.bPlayHover = false
  self.Btn_Goto:BindEventOnClicked(self, self.OnGotoBtnClicked)
  self.Btn_Check:BindEventOnClicked(self, self.OnCheckBtnClicked)
end

function M:OnListItemObjectSet(Content)
  local Data = Content.Data
  self.WS_Type:SetActiveWidgetIndex(Data and 0 or 1)
  if not Data then
    return
  end
  self.IsVisiting = Data.IsVisiting
  self.Parent = Content.Parent
  self.Data = Content.Data
  self:Refresh()
  self:InitGamepad()
end

function M:InitGamepad()
  if self.bGamepadInited then
    return
  end
  self.bGamepadInited = true
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self.Controller_Goto:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    }
  })
  self.Controller_Check:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    }
  })
  self.Panel_Controller_Goto:SetVisibility(UE4.ESlateVisibility.Hidden)
  self.Panel_Controller_Check:SetVisibility(UE4.ESlateVisibility.Hidden)
  self:UpdateUIStyleInPlatform()
  self:AddInputMethodChangedListen()
  self:SetIsDealWithVirtualAccept(true)
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:Refresh()
  if not self.Data then
    self.WS_Type:SetActiveWidgetIndex(1)
    return
  end
  self.WS_Type:SetActiveWidgetIndex(0)
  self.Logo:Init(self.Data.LogoInfo)
  self.Text_Name:SetText(GText(self.Data.Name))
  self.Text_Level:SetText(GText(tostring(self.Data.Level)))
  self.Text_Heat:SetText(GText(tostring(self.Data.Heat)))
  local IsVisiting = self.IsVisiting
  self.WS_Btn:SetActiveWidgetIndex(IsVisiting and 1 or 0)
  self.Panel_Visiting:SetVisibility(IsVisiting and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
  if IsVisiting then
    self.Text_Visiting:SetText(GText("UI_GuildVisit"))
  end
end

function M:OnGotoBtnClicked()
  if not self.Data then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  GuildController:GetModel():RequestEnterGuildOnline(self.Data.GuildId)
end

function M:OnCheckBtnClicked()
  if not self.Data or not self.IsVisiting then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  local GuildVisitPage = UIManager(self):GetUIObj("GuildVisitPage")
  if GuildVisitPage and GuildVisitPage.SetUIVisibilityTag then
    GuildVisitPage:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, true)
  end
  
  local function OnCloseCallback()
    if IsValid(GuildVisitPage) and not GuildVisitPage:IsBeingRemoveState() then
      GuildVisitPage:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, false)
      GuildVisitPage:SetFocus()
    end
  end
  
  local CheckGuildPage = UIManager(self):LoadUINew("CheckGuildPage", self.Data.GuildId, OnCloseCallback)
end

function M:OnAddedToFocusPath()
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self.Parent:OnComponentFocusChanged(self)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self:PlayItem_UnHover()
end

function M:PlayItem_Hover(InFocusEvent)
  if not self.bPlayHover then
    self.bPlayHover = true
    self.Panel_Controller_Goto:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Controller_Check:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self:StopAllAnimations()
    self:PlayAnimation(self.Item_Hover)
  end
end

function M:PlayItem_UnHover()
  if self.bPlayHover then
    self.bPlayHover = false
    self.Panel_Controller_Goto:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.Panel_Controller_Check:SetVisibility(UE4.ESlateVisibility.Hidden)
    self:StopAllAnimations()
    self:PlayAnimation(self.Item_UnHover)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamepad and self.bPlayHover then
    self:PlayItem_UnHover()
  elseif IsGamepad and not self.bPlayHover and self.Parent.FocusItemWidget == self and UIUtils.HasAnyFocus(self.Parent.List_Guild) then
    self:PlayItem_Hover()
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonDown then
    if self.IsVisiting then
      self:OnCheckBtnClicked()
    else
      self:OnGotoBtnClicked()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

return M
