require("UnLua")
local CameraParameterConfig = require("BluePrints.UI.WBP.Camera.Widget.Parameter.CameraParameterConfig")
local FSM = require("Blueprints.UI.FocusStateMachine")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C",
  "BluePrints.UI.KeyInputComponent"
}
local FocusStates = {Tab = "Tab", Option = "Option"}

function M:Construct()
  self.IsInited = false
  self.bIsFocusable = true
  self.Btn_Close.Btn_Close.OnClicked:Add(self, self.OnCloseClicked)
  self.FSM = FSM:New(self, {
    StateNames = FocusStates,
    OnStateChanged = self.OnFocusStateChanged,
    CheckFunction = self.IsFocusStateValid
  })
  local PhotoCameraMain = UIManager(self):GetUIObj("PhotoCameraMain")
  rawset(self, "PhotoCameraMain", PhotoCameraMain)
  rawset(self, "PhotoCameraModel", PhotoCameraMain)
  self:AddTimer(0.3, function()
    self:TryCreateRedDotInfos()
  end)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:ToggleShowHide()
  if self:IsShowed() then
    self:Hide()
  else
    self:Show()
  end
end

function M:Show()
  if not self.IsInited then
    self:CreateTabContents()
    self.TabContents[1].IsSelected = true
    self:InitTabList()
    self:OnTabSelected(self.TabContents[1])
    self.IsInited = true
  else
    self:InitOptionList(self.CurrentTabContent)
  end
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self.FSM:Clear()
  rawset(self, "bIsShowed", true)
  self.PhotoCameraMain:PlayParameterInAnim()
  self.PhotoCameraMain:OnParameterWidgetShowed()
  self:SetFocus()
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "PanelParameter_Show", nil)
end

function M:Hide()
  AudioManager(self):SetEventSoundParam(self, "PanelParameter_Show", {ToEnd = 1})
  self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  rawset(self, "bIsShowed", false)
  self.PhotoCameraMain:PlayParameterOutAnim()
  self.PhotoCameraMain:OnParameterWidgetHidden()
  self:UpdateParameterBtnRedDot()
end

function M:IsShowed()
  return rawget(self, "bIsShowed")
end

function M:CreateTabContents()
  rawset(self, "TabContents", {})
  rawset(self, "TabIdToTabContents", {})
  for _, Tab in ipairs(CameraParameterConfig.GetConfig()) do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(Obj, "Owner", self)
    rawset(Obj, "Title", GText(Tab.Title))
    rawset(Obj, "IconPath", Tab.IconPath)
    rawset(Obj, "TabId", Tab.TabId)
    rawset(Obj, "Options", Tab.Options)
    rawset(Obj, "OnClicked", self.OnTabItemClicked)
    rawset(Obj, "OnAddedToFocusPath", self.OnTabAddedToFocusPath)
    rawset(Obj, "RedDotType", self:GetTabRedDotType(Tab.TabId) or nil)
    table.insert(self.TabContents, Obj)
    self.TabIdToTabContents[Tab.TabId] = Obj
  end
end

function M:InitTabList()
  self.List_Tab:ClearListItems()
  for index, value in ipairs(self.TabContents) do
    self.List_Tab:AddItem(value)
  end
end

local function SetTabItemIsSelected(Content, IsSelected)
  if Content then
    Content.IsSelected = IsSelected
    if IsValid(Content.Widget) then
      Content.Widget:SetIsSelected(IsSelected)
    end
  end
end

function M:OnTabItemClicked(TabContent)
  self:OnTabSelected(TabContent)
end

function M:OnTabSelected(TabContent)
  if self.CurrentTabContent then
    SetTabItemIsSelected(self.CurrentTabContent, false)
  end
  self.CurrentTabContent = TabContent
  SetTabItemIsSelected(TabContent, true)
  self:InitOptionList(TabContent)
end

function M:UnBindAllOptionWidgetFocusEvent()
  local AllOptionWidgets = self.GridPanel_Parameter:GetAllChildren():ToTable() or {}
  for index, Widget in ipairs(AllOptionWidgets) do
    Widget.BP_OnAddedToFocusPath:Clear()
  end
end

function M:CreateOptionWidgets(TabContent)
  self:UnBindAllOptionWidgetFocusEvent()
  self.GridPanel_Parameter:ClearChildren()
  local UIManager = UIManager(self)
  for index, value in ipairs(TabContent.Options) do
    local WidgetPath = CameraParameterConfig.GetOptionWidgetPath(value.WidgetType)
    local Widget = UIManager:CreateWidget(WidgetPath)
    if Widget then
      rawset(Widget, "Config", value)
      self.GridPanel_Parameter:AddChild(Widget)
      Widget.BP_OnAddedToFocusPath:Add(self, self.OnOptionAddedToFocusPath)
      Widget.bIsFocusable = true
      Widget:SetTitle(GText(value.Title))
      Widget.Slot:SetRow(index - 1)
      Widget.Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    end
  end
  local AllOptionWidgets = self.GridPanel_Parameter:GetAllChildren():ToTable() or {}
  for index, Widget in ipairs(AllOptionWidgets) do
    Widget:SetNavigationRuleExplicit(UE4.EUINavigation.Right, self.List_Tab)
    Widget:SetNavigationRuleBase(UE4.EUINavigation.Left, EUINavigationRule.Stop)
    if AllOptionWidgets[index + 1] then
      Widget:SetNavigationRuleExplicit(UE4.EUINavigation.Down, AllOptionWidgets[index + 1])
    else
      Widget:SetNavigationRuleBase(UE4.EUINavigation.Down, EUINavigationRule.Stop)
    end
    if AllOptionWidgets[index - 1] then
      Widget:SetNavigationRuleExplicit(UE4.EUINavigation.Up, AllOptionWidgets[index - 1])
    else
      Widget:SetNavigationRuleBase(UE4.EUINavigation.Up, EUINavigationRule.Stop)
    end
  end
  self.List_Tab:SetNavigationRuleCustom(EUINavigation.Left, {
    self,
    function(_self)
      self.FSM:Pop()
      local State = self.FSM:Peak()
      if State.Name == FocusStates.Option and IsValid(State.Widget) and self.GridPanel_Parameter:GetChildIndex(State.Widget) >= 0 then
        return State.Widget
      end
      return self.GridPanel_Parameter:GetChildAt(0)
    end
  })
end

function M:InitOptionList(TabContent)
  self.Text_Title:SetText(TabContent.Title)
  local TabId = TabContent and TabContent.TabId or ""
  if self["InitOptionList_" .. TabId] then
    self:CreateOptionWidgets(TabContent)
    self["InitOptionList_" .. TabId](self, TabContent)
  end
end

function M:CommonInitOptionList()
  local OptionWidgets = self.GridPanel_Parameter:GetAllChildren():ToTable()
  for index, Widget in ipairs(OptionWidgets) do
    local Config = Widget.Config
    if Config and self["InitOption_" .. Config.OptionId] then
      self["InitOption_" .. Config.OptionId](self, Config, Widget)
    end
  end
end

function M:CreateOptionContentCommon(OptionConfig, Widget)
  local Content = {
    Owner = self,
    Widget = Widget,
    RedDotType = self:GetOptionRedDotType(OptionConfig.TabId, OptionConfig.OptionId)
  }
  for key, value in pairs(OptionConfig) do
    Content[key] = value
  end
  return Content
end

function M:InitOptionList_Lens(TabContent)
  self:CommonInitOptionList()
end

function M:InitOption_CameraMode(Config, Widget)
  local Content = self:CreateOptionContentCommon(Config, Widget)
  rawset(self, "CameraModeContent", Content)
  local Model = self.PhotoCameraModel
  Model:BindEventOnCameraChanged(self, self.OnCameraModeChanged)
  rawset(Content, "OnSelectionsChanged", self.OnCameraModeSelectionsChanged)
  Widget:Init(Content)
  Widget:SelectItem(Model.CurCameraIndex + 1)
  Widget.Slot:SetLayer(1)
end

function M:OnCameraModeSelectionsChanged(Idx)
  local Model = self.PhotoCameraModel
  Model:ChangeCamera(Idx - 1)
end

function M:OnCameraModeChanged()
  local Content = self.CameraModeContent
  local Model = self.PhotoCameraModel
  if Content and IsValid(Content.Widget) then
    Content.Widget:SelectItem(Model.CurCameraIndex + 1)
  end
end

function M:InitOption_CameraRoll(Config, Widget)
  rawset(self, "CameraRollWidget", Widget)
  local Model = self.PhotoCameraModel
  Model:BindEventOnRollChanged(self, self.OnCameraRollChanged)
  Model:RoundRoll()
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.Default = Model:GetRoll()
  Content.OnValueChanged = self.OnCameraRollSlideValueChanged
  Widget:Init(Content)
end

function M:OnCameraRollSlideValueChanged(CurrentValue)
  local Model = self.PhotoCameraModel
  Model:SetRoll(CurrentValue, false)
end

function M:OnCameraRollChanged(DesiredRoll)
  if not IsValid(self.CameraRollWidget) then
    return
  end
  local Model = self.PhotoCameraModel
  local Roll = Model:GetRoll()
  Roll = math.floor(Roll + 0.5)
  self.CameraRollWidget:SetValue(Roll)
end

function M:InitOption_GuideLine(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Model:BindEventOnGuideLineChanged(self, self.OnGuideLineChanged, {Content, Widget})
  rawset(self, "GuideLineContent", Content)
  Content.IsChecked = Model:GetIsShowGuideLine()
  Content.OnCheckedChanged = self.OnGuideLineCheckedChanged
  Widget:Init(Content)
end

function M:OnGuideLineChanged(IsShow, Params)
  local Content, Widget = Params[1], Params[2]
  if not Content or not IsValid(Widget) then
    return
  end
  Content.IsChecked = IsShow
  Widget:Init(Content)
end

function M:OnGuideLineCheckedChanged(IsChecked, Content)
  local Model = self.PhotoCameraModel
  Model:SetIsShowGuideLine(IsChecked)
  self:SetOptionRedDotRead(Content)
  self:OnCheckBoxOptionCheckedChanged(Content)
end

function M:InitOption_DepthOfField(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Model:BindEventOnFocusMethodChanged(self, self.OnFocusMethodChanged, {Content, Widget})
  Content.IsChecked = Model:IsFocusMethodEnabled()
  Content.OnCheckedChanged = self.OnDepthOfFieldCheckedChanged
  Widget:Init(Content)
end

function M:OnFocusMethodChanged(IsChecked, Params)
  local Content, Widget = Params[1], Params[2]
  if not Content or not IsValid(Widget) then
    return
  end
  Content.IsChecked = IsChecked
  Widget:Init(Content)
end

function M:OnDepthOfFieldCheckedChanged(IsChecked, Content)
  local Model = self.PhotoCameraModel
  Model:EnableFocusMethod(IsChecked)
  self:SetOptionRedDotRead(Content)
  self:OnCheckBoxOptionCheckedChanged(Content)
end

function M:InitOptionList_Color(TabContent)
  self:CommonInitOptionList()
end

function M:InitOption_Contrast(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.Default = Model:GetContrast()
  Content.OnValueChanged = self.OnContrastSlideValueChanged
  Widget:Init(Content)
end

function M:OnContrastSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetContrast(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_Saturation(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnSaturationSlideValueChanged
  Content.Default = Model:GetSaturation()
  Widget:Init(Content)
end

function M:OnSaturationSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetSaturation(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_Temperature(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnTemperatureSlideValueChanged
  Content.Default = Model:GetTemperature()
  Widget:Init(Content)
end

function M:OnTemperatureSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetTemperature(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_SceneColorTintR(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnSceneColorTintRSlideValueChanged
  Content.Default = Model:GetSceneColorTintR()
  Widget:Init(Content)
end

function M:OnSceneColorTintRSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetSceneColorTintR(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_SceneColorTintG(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnSceneColorTintGSlideValueChanged
  Content.Default = Model:GetSceneColorTintG()
  Widget:Init(Content)
end

function M:OnSceneColorTintGSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetSceneColorTintG(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_SceneColorTintB(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnSceneColorTintBSlideValueChanged
  Content.Default = Model:GetSceneColorTintB()
  Widget:Init(Content)
end

function M:OnSceneColorTintBSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetSceneColorTintB(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_WhiteTint(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnWhiteTintSlideValueChanged
  Content.Default = Model:GetWhiteTint()
  Widget:Init(Content)
end

function M:OnWhiteTintSlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetWhiteTint(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOptionList_Filter(TabContent)
  self:CommonInitOptionList()
end

function M:InitOption_FilterIntensity(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnValueChanged = self.OnFilterIntensitySlideValueChanged
  Content.Default = Model:GetFilterIntensity()
  Widget:Init(Content)
end

function M:OnFilterIntensitySlideValueChanged(CurrentValue, Content)
  local Model = self.PhotoCameraModel
  Model:SetFilterIntensity(CurrentValue)
  self:SetOptionRedDotRead(Content)
end

function M:InitOption_FilterList(Config, Widget)
  local Model = self.PhotoCameraModel
  local Content = self:CreateOptionContentCommon(Config, Widget)
  Content.OnItemSelectionChanged = self.OnFilterItemSelectionChanged
  Content.FilterData = Model:GetFilterData()
  Content.CurrentFilter = Model:GetFilterType()
  Content.Config = Config
  Content.RedDotInfos = self.RedDotInfos[Content.TabId][Content.OptionId]
  Widget:Init(Content)
end

function M:OnFilterItemSelectionChanged(FilterItem, OptionContent)
  local Model = self.PhotoCameraModel
  local EFilterType = FilterItem and FilterItem.Data.PPEnum
  Model:SetFilter(EFilterType)
  self:SetFilterItemRedDotRead(FilterItem, OptionContent)
end

function M:OnCloseClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", nil, nil)
  self:Hide()
end

function M:Destruct()
  self.Btn_Close.Btn_Close.OnClicked:Remove(self, self.OnCloseClicked)
  self:UnBindAllOptionWidgetFocusEvent()
end

function M:TryCreateRedDotInfos()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local NodeName = "NewCameraParameter"
  local Node = ReddotManager.GetTreeNode(NodeName)
  if not Node then
    ReddotManager.AddNode(NodeName, nil, Const.ReddotCacheType.UserCache, UIConst.RedDotType.NewRedDot)
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if not CacheDetail then
    return
  end
  self.RedDotInfos = {}
  local Config = CameraParameterConfig.GetConfig()
  for _, TabConfig in ipairs(Config) do
    self.RedDotInfos[TabConfig.TabId] = {}
    for index, Option in ipairs(TabConfig.Options) do
      if Option.NeedRedDot then
        if Option.CustomRedDot then
          self.RedDotInfos[TabConfig.TabId][Option.OptionId] = {}
          self:CreateCustomRedDotInfo(Option.OptionId, CacheDetail, self.RedDotInfos[TabConfig.TabId][Option.OptionId])
        else
          CacheDetail[Option.OptionId] = CacheDetail[Option.OptionId] or 1
          if 1 == CacheDetail[Option.OptionId] then
            self.RedDotInfos[TabConfig.TabId][Option.OptionId] = UIConst.RedDotType.NewRedDot
          end
        end
      end
    end
  end
  self:UpdateParameterBtnRedDot()
end

function M:CreateCustomRedDotInfo(OptionId, ...)
  if self["CreateCustomRedDotInfo_" .. OptionId] then
    self["CreateCustomRedDotInfo_" .. OptionId](self, OptionId, ...)
  end
end

function M:CreateCustomRedDotInfo_FilterList(OptionId, CacheDetail, OptionRedDotInfo)
  local Model = self.PhotoCameraModel
  local FilterData = Model:GetFilterData()
  CacheDetail[OptionId] = CacheDetail[OptionId] or {}
  local OptionCacheDetail = CacheDetail[OptionId]
  local HasRedDot
  for key, value in pairs(FilterData) do
    OptionCacheDetail[value.ID] = OptionCacheDetail[value.ID] or 1
    if 1 == OptionCacheDetail[value.ID] then
      OptionRedDotInfo[value.ID] = UIConst.RedDotType.NewRedDot
    end
  end
end

function M:GetTabRedDotType(TabId)
  if not self.RedDotInfos or not self.RedDotInfos[TabId] then
    return
  end
  for key, value in pairs(self.RedDotInfos[TabId]) do
    if value == UIConst.RedDotType.NewRedDot then
      return value
    end
  end
end

function M:GetOptionRedDotType(TabId, OptionId)
  if not (self.RedDotInfos and self.RedDotInfos[TabId]) or not self.RedDotInfos[TabId][OptionId] then
    return
  end
  return self.RedDotInfos[TabId][OptionId]
end

function M:UpdateParameterBtnRedDot()
  if not self.RedDotInfos then
    return
  end
  if not self.PhotoCameraModel then
    return
  end
  local HasAnyRedDot
  
  function HasAnyRedDot(RedDotInfo)
    for key, value in pairs(RedDotInfo) do
      if type(value) == "table" then
        local Res = HasAnyRedDot(value)
        if Res then
          return Res
        end
      else
        return value
      end
    end
  end
  
  local Res = HasAnyRedDot(self.RedDotInfos)
  self.PhotoCameraModel:SetParameterBtnRedDotType(Res)
end

function M:SetOptionRedDotRead(Content)
  if not (self.RedDotInfos and self.RedDotInfos[Content.TabId]) or not self.RedDotInfos[Content.TabId][Content.OptionId] then
    return
  end
  local NodeName = "NewCameraParameter"
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if not CacheDetail then
    return
  end
  CacheDetail[Content.OptionId] = 0
  self.RedDotInfos[Content.TabId][Content.OptionId] = nil
  Content.RedDotType = nil
  if IsValid(Content.Widget) then
    Content.Widget:SetRedDot(Content.RedDotType)
  end
  self:UpdateTabRedDot(Content.TabId)
end

function M:UpdateTabRedDot(TabId)
  local TabContent = self.TabIdToTabContents[TabId]
  if not TabContent then
    return
  end
  local CheckOptionRedDot
  
  function CheckOptionRedDot(RedDotInfo)
    for key, value in pairs(RedDotInfo) do
      if type(value) == "table" then
        local Res = CheckOptionRedDot(value)
        if Res then
          return Res
        end
      else
        return value
      end
    end
  end
  
  TabContent.RedDotType = CheckOptionRedDot(self.RedDotInfos[TabId])
  if IsValid(TabContent.Widget) then
    TabContent.Widget:SetRedDot(TabContent.RedDotType)
  end
end

function M:SetFilterItemRedDotRead(FilterItem, OptionContent)
  if not (self.RedDotInfos and self.RedDotInfos[OptionContent.TabId]) or not self.RedDotInfos[OptionContent.TabId][OptionContent.OptionId] then
    return
  end
  local NodeName = "NewCameraParameter"
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName)
  if not CacheDetail then
    return
  end
  if not CacheDetail[OptionContent.OptionId] then
    return
  end
  if not FilterItem.Data or not FilterItem.Data.ID then
    return
  end
  CacheDetail[OptionContent.OptionId] = CacheDetail[OptionContent.OptionId] or {}
  CacheDetail[OptionContent.OptionId][FilterItem.Data.ID] = 0
  self.RedDotInfos[OptionContent.TabId][OptionContent.OptionId][FilterItem.Data.ID] = nil
  OptionContent.RedDotType = nil
  FilterItem.RedDotType = nil
  if IsValid(OptionContent.Widget) then
    OptionContent.Widget:SetRedDot(OptionContent.RedDotType)
  end
  if IsValid(FilterItem.Widget) then
    FilterItem.Widget:SetRedDot(FilterItem.RedDotType)
  end
  self:UpdateTabRedDot(OptionContent.TabId)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  rawset(self, "IsGamePadInput", CurInputDevice == ECommonInputType.Gamepad)
  rawset(self, "CurInputDevice", CurInputDevice)
  if CurInputDevice == ECommonInputType.Gamepad or CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self:InitKeyWidget()
    self:InitKeyInputEvent()
  end
  self:UpdateKeyWidgetVisibility()
  if not rawget(self, "bInFocusPath") then
    return
  end
  if self.IsGamePadInput then
    if self:IsCurrentFocusWidgetLegal() then
      return
    end
    local Widget = self:GetDesiredFocusTarget()
    if IsValid(Widget) then
      Widget:SetFocus()
    end
  end
end

function M:UpdateKeyWidgetVisibility()
  if self.CurInputDevice == ECommonInputType.Gamepad or self.CurInputDevice == ECommonInputType.MouseAndKeyboard then
    self.Panel_Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if self.CurInputDevice == ECommonInputType.Gamepad then
      local State = self.FSM:Peak()
      if IsValid(State.Widget) and State.Widget.OnConfirmKeyDown then
        self.Key_Controller_Confirm:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      else
        self.Key_Controller_Confirm:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    else
      self.Key_Controller_Confirm:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.PhotoCameraModel:GetLockGamePause() then
      self.Key_Controller_Pause:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Key_Controller_Pause:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    self.Panel_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Controller_Pause:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitKeyWidget()
  local BackKeyInfoList, ResetKeyInfoList, PauseKeyInfoList
  if self.IsGamePadInput then
    BackKeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "B",
        Owner = self
      }
    }
    ResetKeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "X",
        Owner = self
      }
    }
    PauseKeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "View",
        Owner = self
      }
    }
  else
    BackKeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(EKeys.Escape.KeyName),
        ClickCallback = self.Hide,
        Owner = self
      }
    }
    ResetKeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(EKeys.R.KeyName),
        ClickCallback = self.OnResetKeyDown,
        Owner = self
      }
    }
    PauseKeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetKeyText(EKeys.Y.KeyName),
        ClickCallback = self.OnPauseKeyDown,
        Owner = self
      }
    }
  end
  self.Key_Controller_Back:CreateCommonKey({
    KeyInfoList = BackKeyInfoList,
    Desc = GText("UI_BACK")
  })
  self.Key_Controller_Reset:CreateCommonKey({
    KeyInfoList = ResetKeyInfoList,
    Desc = GText("UI_CTL_ResetParameters")
  })
  if PauseKeyInfoList then
    self.Key_Controller_Pause:CreateCommonKey({
      KeyInfoList = PauseKeyInfoList,
      Desc = GText("UI_CTL_On_OffTime")
    })
    self.Key_Controller_Pause:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Controller_Pause:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if rawget(self, "IsKeyWidgetInitialized") then
    return
  end
  rawset(self, "IsKeyWidgetInitialized", true)
  self.Key_Controller_Confirm:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "A",
        Owner = self
      }
    },
    Desc = GText("UI_Tips_Ensure")
  })
end

function M:InitKeyInputEvent()
  if rawget(self, "IsKeyInputEventInitialized") then
    return
  end
  rawset(self, "IsKeyInputEventInitialized", true)
  self:AddKeyDownEvent(EKeys.Escape.KeyName, self.OnHideKeyDown)
  self:AddKeyDownEvent(Const.GamepadFaceButtonRight, self.OnHideKeyDown)
  self:AddKeyDownEvent(EKeys.R.KeyName, self.OnResetKeyDown)
  self:AddKeyDownEvent(Const.GamepadFaceButtonLeft, self.OnResetKeyDown)
  self:AddKeyDownEvent(EKeys.U.KeyName, self.JustHandleKeyDown)
  self:AddKeyDownEvent(Const.GamepadRightThumbstick, self.JustHandleKeyDown)
end

function M:JustHandleKeyDown()
  return UIUtils.Handled, true
end

function M:OnHideKeyDown()
  self:Hide()
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self.PhotoCameraMain), true
end

function M:OnResetKeyDown()
  return self:ResetCurrentTabOptions()
end

function M:OnPauseKeyDown()
  if self.PhotoCameraMain.OnPuaseClicked then
    self.PhotoCameraMain:OnPuaseClicked()
  end
end

function M:ResetCurrentTabOptions(FilterFunc)
  if not self.CurrentTabContent then
    return UIUtils.Handled, true
  end
  local OptionWidgets = self.GridPanel_Parameter:GetAllChildren():ToTable() or {}
  for index, Widget in ipairs(OptionWidgets) do
    local Config = Widget.Config
    if Config then
      local OptionId = Config.OptionId
      if FilterFunc and type(FilterFunc) == "function" then
        if not FilterFunc(OptionId, Config) then
          goto lbl_61
        end
      elseif self:IsOptionSkipReset(OptionId, Config) then
        goto lbl_61
      end
      if self["ResetOption_" .. OptionId] then
        self["ResetOption_" .. OptionId](self, Widget, Config)
      end
    end
    ::lbl_61::
  end
  return UIUtils.Handled, true
end

function M:IsOptionSkipReset(OptionId, Config)
  if "CameraMode" == OptionId then
    return true
  end
  if Config and Config.bSkipReset then
    return true
  end
  return false
end

function M:ResetOption_CameraMode(Widget, Config)
end

function M:ResetOption_CameraRoll(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 0
  Model:SetRoll(Default, false)
  Widget:SetValue(Default)
end

function M:ResetOption_GuideLine(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or false
  Model:SetIsShowGuideLine(Default)
  Widget.Content.IsChecked = Default
  Widget.CheckBox:SetChecked(Default, false)
end

function M:ResetOption_DepthOfField(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or false
  Model:EnableFocusMethod(Default)
  Widget.Content.IsChecked = Default
  Widget.CheckBox:SetChecked(Default, false)
end

function M:ResetOption_Contrast(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetContrast(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_Saturation(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetSaturation(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_Temperature(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 6500
  Model:SetTemperature(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_SceneColorTintR(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetSceneColorTintR(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_SceneColorTintG(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetSceneColorTintG(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_SceneColorTintB(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetSceneColorTintB(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_WhiteTint(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 0
  Model:SetWhiteTint(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_FilterIntensity(Widget, Config)
  local Model = self.PhotoCameraModel
  local Default = Config.Default or 100
  Model:SetFilterIntensity(Default)
  Widget:SetValue(Default)
end

function M:ResetOption_FilterList(Widget, Config)
  if Widget.ItemContents and Widget.ItemContents[1] then
    Widget:OnFilterItemSelectionChanged(Widget.ItemContents[1])
  end
end

function M:OnConfirmKeyDown()
  local State = self.FSM:Peak()
  if State.Name == FocusStates.Option then
    local Widget = State.Widget
    if IsValid(Widget) and Widget.OnConfirmKeyDown then
      return Widget:OnConfirmKeyDown()
    end
  end
end

function M:IsCurrentFocusWidgetLegal()
  local Widget = self:GetDesiredFocusTarget()
  if IsValid(Widget) then
    return UIUtils.HasAnyFocus(Widget)
  end
  return false
end

function M:GetDesiredFocusTarget()
  local State = self.FSM:Peak()
  if State.Name == FocusStates.Option then
    if IsValid(State.Widget) then
      return State.Widget
    end
  elseif State.Name == FocusStates.Tab then
    self.List_Tab:BP_SetSelectedItem(State.Content)
    self.List_Tab:BP_NavigateToItem(State.Content)
    if IsValid(State.Content.Widget) then
      return State.Content.Widget
    end
    return self.List_Tab
  end
  return self.GridPanel_Parameter:GetChildAt(0)
end

function M:OnFocusStateChanged()
  local State = self.FSM:Peak()
  local StateName = State.Name
end

function M:OnAddedToFocusPath(InFocusEvent)
  rawset(self, "bInFocusPath", true)
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
end

function M:OnRemovedFromFocusPath()
  rawset(self, "bInFocusPath", false)
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:OnTabAddedToFocusPath(TabWidget, TabContent)
  if self.IsGamePadInput and TabContent ~= self.CurrentTabContent then
    self:OnTabItemClicked(TabContent)
  end
  self.FSM:Push({
    Name = FocusStates.Tab,
    Content = TabContent,
    Widget = TabWidget
  })
  self:UpdateKeyWidgetVisibility()
end

function M:OnCheckBoxOptionCheckedChanged(Content)
  if IsValid(Content.Widget) and UIUtils.HasAnyFocus(Content.Widget) then
    self.Key_Controller_Confirm:ChangeText(GText("UI_CTL_On/Off"))
  end
end

function M:OnOptionAddedToFocusPath(Widget)
  self.FSM:Clear()
  self.FSM:Push({
    Name = FocusStates.Option,
    Widget = Widget
  })
  self:UpdateKeyWidgetVisibility()
  if Widget.Content.WidgetType == "Switch" then
    self.Key_Controller_Confirm:ChangeText(GText("UI_CTL_On/Off"))
  else
    self.Key_Controller_Confirm:ChangeText(GText("UI_Tips_Ensure"))
  end
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  return UE4.UWidgetBlueprintLibrary.SetUserFocus(UE4.UWidgetBlueprintLibrary.Handled(), self:GetDesiredFocusTarget())
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  return UIUtils.Handled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if rawget(self, "bIsShowed") then
    local Reply, IsHandled = self:ProcessOnKeyDown(MyGeometry, InKeyEvent)
    if IsHandled then
      return Reply
    end
  end
  return UIUtils.Unhandled
end

AssembleComponents(M)
return M
