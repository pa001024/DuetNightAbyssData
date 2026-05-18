require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local AppearanceUtils = require("BluePrints.UI.WBP.Appearance.AppearanceUtils")
local AppearanceMainModel = require("BluePrints.UI.WBP.Appearance.AppearanceMainModel")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent"
}

function M:Construct()
  M.Super.Construct(self)
  self.IMG_Click.OnMouseButtonDownEvent:Unbind()
  self.IMG_Click.OnMouseButtonDownEvent:Bind(self, self.On_IMG_Click_MouseButtonDown)
  rawset(self, "MainWidgets", {})
  self.Panel_Part:ClearChildren()
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.CurMainWidget then
    self.CurMainWidget:ReceiveEnterState(StackAction)
  end
end

function M:ReceiveExitState(StackAction)
  M.Super.ReceiveExitState(self, StackAction)
  if self.CurMainWidget then
    self.CurMainWidget:ReceiveExitState(StackAction)
  end
end

function M:On_IMG_Click_MouseButtonDown(MyGeometry, MouseEvent)
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
    return self:OnHideUIKeyDown()
  end
  if self.CurMainWidget then
    self.CurMainWidget:OnBackgroundClicked()
  end
end

function M:OnBackKeyDown()
  return self:TryClose()
end

function M:TryClose()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  if self.bSelfHidden then
    return self:OnHideUIKeyDown()
  else
    self:PlayOutAnim()
  end
end

function M:OnLeftConfirmBtnClicked()
  AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
end

function M:OnRightConfirmBtnClicked()
  if self.CurrentMainTabIdx == self.SkinTabIdx then
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
  else
    AudioManager(self):PlayUISound(nil, "event:/ui/common/role_replace", nil, nil)
  end
end

function M:OnSkinItemClicked(Content)
  local SelectedContent = self.SkinMap[self.SelectedSkinId]
  if Content == SelectedContent then
    return
  end
  self:SelectSkinByContent(Content)
end

function M:OnSkinListSelectionChanged(Content, IsSelected)
end

function M:OnMVPListSelectionChanged(Content, IsSelected)
end

function M:OnDyeBtnClicked()
  self:OpenDye()
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SkinOpen", nil)
  Params = Params or {}
  rawset(self, "Params", Params)
  rawset(self, "ParentActorController", Params.ActorController)
  rawset(self, "JumpToMainTabName", Params.MainTabName or AppearanceUtils.AppearanceMainTabNames.Char)
  rawset(self, "OnCloseCallback", Params.OnCloseCallback)
  rawset(self, "Parent", Params.Parent)
  rawset(self, "IsCharacterTrialMode", Params.IsCharacterTrialMode or false)
  rawset(self, "IsPreviewMode", Params.IsPreviewMode or false)
  rawset(self, "UseTemporaryAvatar", Params.UseTemporaryAvatar or false)
  rawset(self, "UIName", self:GetUIConfigName())
  rawset(self, "InAnimStyle", 1)
  rawset(self, "OutAnimStyle", Params.OutAnimStyle or 1)
  if not self.InAnimStyle then
    self:Init(Params)
  end
  self:PlayInAnim()
end

function M:Init(Params)
  if Params.UseTemporaryAvatar and Params.TemporaryAvatar then
    ArmoryUtils:SetTemporaryAvatar(Params.TemporaryAvatar)
  end
  self.MainModel = AppearanceMainModel:New(self, {
    CharUuids = Params.CharUuids,
    DoNotSort = Params.DoNotSort,
    IsPreviewMode = Params.IsPreviewMode,
    InitialOrderCharUuids = Params.InitialOrderCharUuids,
    OnCharContentCreated = self.OnCharContentCreated
  })
  self.MainModel:CreateMainTabConfig()
  self.Com_Tab:Init(self.MainModel:GetMainTabConfig())
  self.CurChar = nil
  local CurContent
  if Params.CharUuid then
    CurContent = self.MainModel:GetCharContentByUuid(Params.CharUuid)
  end
  if nil == CurContent and Params.CharId then
    CurContent = self.MainModel:GetCharContentByCharId(Params.CharId) or self.MainModel:GetUnownedCharContentByCharId(Params.CharId)
  end
  if nil == CurContent then
    CurContent = self.MainModel:GetSelectedCharContent()
  end
  if nil == CurContent then
    DebugPrint("Error: CY@ 角色信息创建失败!\n")
    self:Close()
    return
  end
  self.CurCharContent = CurContent
  self.MainModel:SetSelectedCharContent(self.CurCharContent)
  self.ActorController = ActorController:New({
    ViewUI = self,
    IsPreviewMode = Params.IsPreviewMode,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    Char = self.MainModel:GetSelectedChar(),
    bNeedEndCamera = false
  })
  if self.ActorController then
    self.ActorController:OnOpened()
    if Params.ChatAppearancePreviewInfo and Params.ChatAppearancePreviewInfo.AppearanceInfo then
      self.ActorController:ChangeCharAppearance(Params.ChatAppearancePreviewInfo.AppearanceInfo)
    end
  end
  self:BlockAllUIInput(true, "WaitForActorInit")
  self:AddTimer(0.03, function()
    self:BlockAllUIInput(false, "WaitForActorInit")
    self.Com_Tab:BindEventOnTabSelected(nil, nil)
    local MainTabIdx = self.MainModel:GetMainTabIdxByName(rawget(self, "JumpToMainTabName")) or 1
    rawset(self, "JumpToMainTabName", nil)
    local Tab = self.MainModel:GetMainTabContentByIdx(MainTabIdx)
    self.Com_Tab:SelectTab(MainTabIdx)
    self.Com_Tab:BindEventOnTabSelected(self, self.OnMainTabSelected)
    if Params.SkinId or Params.HairId or Params.AccessoryId or Params.AccessoryType then
      self.JumpParams = {
        SkinId = Params.SkinId,
        HairId = Params.HairId,
        AccessoryId = Params.AccessoryId,
        AccessoryType = Params.AccessoryType
      }
    end
    self:OnMainTabSelected({Idx = MainTabIdx}, Tab)
    self:AddMainTabReddotListen()
  end)
end

function M:OnMainTabSelected(TabWidget, TabContent)
  self.CurrentMainTabIdx = TabWidget.Idx
  local FormTab = self.MainModel:GetCurrentMainTab()
  if FormTab then
    local MainWidget = self.MainWidgets[self.MainModel:GetCurrentMainTab().Name]
    if MainWidget then
      MainWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
      MainWidget:OnTabChangeToOther()
    end
  end
  self.MainModel:SetCurrentMainTabName(TabContent.Name)
  local Widget = self:GetOrCreateMainWidget(TabContent)
  self.CurMainWidget = Widget
  Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  Widget:OnTabChangeToSelf()
  Widget:SetFocus()
  local JumpParams = self.JumpParams
  self.JumpParams = nil
  if JumpParams then
    Widget:JumpLogic(JumpParams)
  end
end

function M:GetOrCreateMainWidget(TabContent)
  local Widget = self.MainWidgets[TabContent.Name]
  if Widget then
    return Widget
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  local WidgetPath = TabContent.WidgetPath
  if UIManager and WidgetPath then
    Widget = UIManager:CreateWidget(WidgetPath, false)
    if Widget then
      self.Panel_Part:AddChild(Widget)
      Widget.bIsFocusable = true
      local CanvasSlot = Widget.Slot
      local Anchors = FAnchors()
      Anchors.Minimum = FVector2D(0, 0)
      Anchors.Maximum = FVector2D(1, 1)
      CanvasSlot:SetAnchors(Anchors)
      CanvasSlot:SetOffsets(FMargin(0, 0, 0, 0))
      self.MainWidgets[TabContent.Name] = Widget
    end
  end
  if Widget and Widget.Init then
    local Params = {}
    for key, value in pairs(self.Params) do
      Params[key] = value
    end
    Params.Parent = self
    Params.Tag = TabContent.Tag
    self:ModifyMainWidgetInitParams(Params)
    Widget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    Widget:Init(Params)
  end
  return Widget
end

function M:ModifyMainWidgetInitParams()
end

function M:UpdateMainTabs(MainTabs)
  self.MainModel:GetMainTabConfig().ForceHideTabs = #MainTabs <= 1
  self.Com_Tab:UpdateTabs(MainTabs)
end

function M:OnHideUIKeyDown()
  self.bSelfHidden = not self.bSelfHidden
  if self.bSelfHidden then
    self:SetRenderOpacity(0)
    self.IMG_Click.Slot:SetZOrder(10)
  else
    self:SetRenderOpacity(1)
    self.IMG_Click.Slot:SetZOrder(-1)
  end
end

function M:PlayInAnim()
  if self.InAnimStyle then
    self.Com_Tab:PlayInAnim()
    self.ComBgSwitch = self:CreateWidgetNew("ComBgSwitch")
    if self.ComBgSwitch then
      self.ComBgSwitch:AddToViewport(self:GetZOrder())
      self.ComBgSwitch:PlayAnimation(self.ComBgSwitch.In)
      self.ComBgSwitch:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self:SetRenderOpacity(0)
      self:AddTimer(0.3, function()
        self:SetRenderOpacity(1)
        self:Init(self.Params)
      end, false, 0, "DelayInit")
    end
  else
    self.Com_Tab:PlayInAnim()
  end
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:AddTimer(0.3, function()
    self:BlockAllUIInput(false, "SP_DisplayOnly")
  end)
end

function M:PlayOutAnim()
  if self.CurMainWidget and self.CurMainWidget.OnClose then
    self.CurMainWidget:OnClose()
  end
  AudioManager(self):SetEventSoundParam(self, "SkinOpen", {ToEnd = 1})
  local Duration = self.Com_Tab:PlayOutAnim() or 0
  if 1 == self.OutAnimStyle and Duration > 0 then
    self:BlockAllUIInput(true, "SP_DisplayOnly")
    self:AddTimer(Duration + 0.1, function()
      self:Close()
    end)
  else
    self:Close()
  end
end

function M:Close()
  if self.ParentActorController then
    local ParentActorController = self.ParentActorController
    if ParentActorController.LastCharModelInfo and ParentActorController.LastCharModelInfo.Uuid == ParentActorController.CurrentCharInfo.Uuid then
      ParentActorController.LastCharAppearanceInfo = self.ActorController.CurrentCharAppearanceInfo
    end
    if ParentActorController.CurrentWeaponInfo and ParentActorController.LastWeaponInfo.Uuid == ParentActorController.CurrentWeaponInfo.Uuid then
      ParentActorController.LastWeaponAppearanceInfo = self.ActorController.CurrentWeaponAppearanceInfo
    end
  end
  self:DestroyActorController()
  M.Super.Close(self)
end

function M:RealClose()
  M.Super.RealClose(self)
  if self.OnCloseCallback then
    self.OnCloseCallback(self.Parent)
  end
end

function M:DestroyActorController()
  if self.ActorController then
    self.ActorController:HidePlayerActor(self.UIName, false)
    self.ActorController:UpdateCameraPPSetting()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
  if self.UseTemporaryAvatar then
    ArmoryUtils:SetTemporaryAvatar(nil)
  end
end

function M:Destruct()
  self.Panel_Part:ClearChildren()
  self.MainModel:Destroy()
  self:DestroyActorController()
  self:RemoveTimer("DelayInit")
  if IsValid(self.ComBgSwitch) then
    self.ComBgSwitch:RemoveFromParent()
  end
  self:RemoveMainTabReddotListen()
  M.Super.Destruct(self)
end

function M:AddMainTabReddotListen()
  if self.IsPreviewMode then
    return
  end
  self:RemoveMainTabReddotListen()
  self.MainTabReddotNodeNames = {}
  local TabConfig = self.MainModel:GetMainTabConfig()
  
  local function ListenerFunc()
    self:UpdateMainTabReddots()
  end
  
  local NodeNames = {
    "NewCharAppearance",
    "CharSkinLevelUp",
    "AppearanceArchiveReward",
    "NewMeleeAppearance",
    "NewRangedAppearance"
  }
  for _, NodeName in ipairs(NodeNames) do
    if ReddotManager.GetTreeNode(NodeName) then
      ReddotManager.AddListener(NodeName, self, ListenerFunc, nil, true)
      self.MainTabReddotNodeNames[NodeName] = 1
    end
  end
  self:UpdateMainTabReddots()
end

function M:RemoveMainTabReddotListen()
  if not self.MainTabReddotNodeNames then
    return
  end
  for NodeName, _ in pairs(self.MainTabReddotNodeNames) do
    ReddotManager.RemoveListener(NodeName, self)
  end
  self.MainTabReddotNodeNames = nil
end

function M:UpdateMainTabReddots()
  local TabConfig = self.MainModel:GetMainTabConfig()
  if not TabConfig or not TabConfig.Tabs then
    return
  end
  for Idx, TabContent in ipairs(TabConfig.Tabs) do
    if TabContent.CheckReddot then
      local IsNew, IsCommon = TabContent.CheckReddot({})
      TabContent.IsNew = IsNew
      TabContent.Upgradeable = IsCommon
      local TabWidget = TabContent.UI or TabContent.Widget
      if IsValid(TabWidget) and TabWidget.SetReddot then
        TabWidget:SetReddot(IsNew and not IsCommon, IsCommon)
      end
    end
  end
end

AssembleComponents(M)
return M
