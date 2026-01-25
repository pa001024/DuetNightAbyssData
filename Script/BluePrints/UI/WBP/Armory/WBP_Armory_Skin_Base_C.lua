require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local M = Class("BluePrints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent",
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_ReddotTree_Component",
  "BluePrints.UI.WBP.Armory.ActorController.PreviewActorComponent"
}
local GoToShopState = {
  CanGoToShop = "CanGoToShop",
  ItemIdNil = "ItemIdNil",
  ItemNotExist = "ItemNotExist",
  ItemNotOnSale = "ItemNotOnSale",
  SkinNotValid = "SkinNotValid"
}

function M:Construct()
  M.Super.Construct(self)
  self:UnbindAllFromAnimationFinished(self.In)
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.In, {
    self,
    self.OnInAnimFinished
  })
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimFinished
  })
  self.Image_Click.OnMouseButtonDownEvent:Unbind()
  self.Image_Click.OnMouseButtonDownEvent:Bind(self, self.On_Image_Click_MouseButtonDown)
  self:AddDispatcher(EventID.OnCharAccessorySetted, self, self.OnCharAccessoryChanged)
  self:AddDispatcher(EventID.OnCharAccessoryRemoved, self, self.OnCharAccessoryChanged)
  self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAppearanceChanged)
  self:AddDispatcher(EventID.OnCharShowPartMesh, self, self.OnCharShowPartMesh)
  self:AddDispatcher(EventID.OnCharCornerVisibilityChanged, self, self.OnCharCornerVisibilityChanged)
  self:AddDispatcher(EventID.OnCharSkinChanged, self, self.OnCharSkinChanged)
  self:AddDispatcher(EventID.OnNewCharSkinObtained, self, self.OnNewCharSkinObtained)
  self:AddDispatcher(EventID.OnNewCharAccessoryObtained, self, self.OnNewCharAccessoryObtained)
  self:AddDispatcher(EventID.OnWeaponAccessoryChanged, self, self.OnWeaponAccessoryChanged)
  self:AddDispatcher(EventID.OnWeaponSkinChanged, self, self.OnWeaponSkinChanged)
  self:AddDispatcher(EventID.OnPurchaseShopItem, self, self.OnPurchaseShopItem)
  self:AddDispatcher(EventID.OnWeaponColorsChanged, self, self.OnWeaponColorsChanged)
  self:AddDispatcher(EventID.OnNewWeaponSkinObtained, self, self.OnNewWeaponSkinObtained)
  self:AddDispatcher(EventID.OnNewWeaponAccessoryObtained, self, self.OnNewWeaponAccessoryObtained)
  self.List_Accessory.BP_OnItemClicked:Clear()
  self.List_Accessory.BP_OnItemClicked:Add(self, self.OnAccessoryItemClicked)
  self.List_Accessory.OnCreateEmptyContent:Bind(self, function(self)
    return NewObject(UIUtils.GetCommonItemContentClass())
  end)
  self.List_Skin.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    rawset(Obj, "IsEmpty", true)
    return Obj
  end)
  rawset(self, "BtnWidgetState", {
    Unequipped = 0,
    Equipped = 1,
    Locked = 2
  })
  rawset(self, "SkinTabIdx", 1)
  rawset(self, "AccessoryTabIdx", 2)
  rawset(self, "TopTabs", {
    {
      Text = GText(DataMgr.AppearanceTab[self.SkinTabIdx].Text),
      IconPath = DataMgr.AppearanceTab[self.SkinTabIdx].IconPath
    },
    {
      Text = GText(DataMgr.AppearanceTab[self.AccessoryTabIdx].Text),
      IconPath = DataMgr.AppearanceTab[self.AccessoryTabIdx].IconPath
    }
  })
  rawset(self, "TabConfig", {
    TitleName = GText("UI_Armory_Appearance"),
    LeftKey = self.TabLeftKey,
    RightKey = self.TabRightKey,
    Tabs = self.TopTabs,
    StyleName = self.TabStyleName,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {},
    BackCallback = self.OnBackKeyDown,
    OwnerPanel = self
  })
  rawset(self, "NoneAccessoryId", DataMgr.GlobalConstant.EmptyCharAccessoryID.ConstantValue)
  self.Btn_Dye:BindEventOnClicked(self, self.OnDyeBtnClicked)
end

function M:AddTopTabReddotListen()
  if self.NoReddot then
    return
  end
  
  local function SetTopTabReddot(TabIdx, IsNew)
    local Content = self.TopTabs[TabIdx]
    Content.IsNew = IsNew
    if IsValid(Content.UI) then
      Content.UI:SetReddot(Content.IsNew)
    end
  end
  
  if self.Type == CommonConst.ArmoryType.Char then
    self:AddCharAppearanceReddotListen(function()
      local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. self.Target.CharId
      local NewSkinNode = ReddotManager.GetTreeNode(LeafNodeName)
      local NewSkinCount = NewSkinNode and NewSkinNode.Count or 0
      local Avatar = GWorld:GetAvatar()
      local CommonChar = Avatar.CommonChars[self.Target.CharId]
      if not CommonChar then
        return
      end
      local NewAccessoryCount = 0
      for _, Type in pairs(CommonConst.CharAccessoryTypes) do
        local LeafNodeName = CommonConst.DataType.CharAccessory .. Type
        local NewAccessoryNode = ReddotManager.GetTreeNode(LeafNodeName)
        NewAccessoryCount = NewAccessoryCount + (NewAccessoryNode and NewAccessoryNode.Count or 0)
        for key, Skin in pairs(CommonChar.OwnedSkins) do
          LeafNodeName = LeafNodeName .. Skin.SkinId
          NewAccessoryNode = ReddotManager.GetTreeNode(LeafNodeName)
          NewAccessoryCount = NewAccessoryCount + (NewAccessoryNode and NewAccessoryNode.Count or 0)
        end
      end
      SetTopTabReddot(1, NewSkinCount > 0)
      SetTopTabReddot(2, NewAccessoryCount > 0)
    end, self.Target.CharId)
  else
    self:AddWeaponAppearanceReddotListen(function()
      local NewSkinCount = 0
      local Data = DataMgr.Weapon[self.Target.WeaponId]
      if Data and Data.SkinApplicationType then
        for _, value in pairs(Data.SkinApplicationType) do
          local NodeName = CommonConst.DataType.WeaponSkin .. (value or "")
          local NewSkinNode = ReddotManager.GetTreeNode(NodeName)
          NewSkinCount = NewSkinCount + (NewSkinNode and NewSkinNode.Count or 0)
        end
      end
      local NewAccessoryNode = ReddotManager.GetTreeNode(CommonConst.DataType.WeaponAccessory)
      local NewAccessoryCount = NewAccessoryNode and NewAccessoryNode.Count or 0
      SetTopTabReddot(1, NewSkinCount > 0)
      SetTopTabReddot(2, NewAccessoryCount > 0)
    end, self.Target.WeaponId)
  end
end

function M:OnNewCharSkinObtained(SkinId, CharId)
  self:AddTimer(0.01, function()
    self:OnNewSkinObtained(SkinId)
  end)
end

function M:OnNewCharAccessoryObtained(AccessoryId)
  self:AddTimer(0.01, function()
    self:OnNewAccessoryObtained(AccessoryId)
  end)
end

function M:OnNewAccessoryObtained(AccessoryId)
  if not self.Map_AccessoryContents then
    return
  end
  local Content = self.Map_AccessoryContents[AccessoryId]
  if not Content then
    return
  end
  Content.IsHide = nil
  if self.NoReddot then
    Content.RedDotType = nil
  else
    Content.RedDotType = UIConst.RedDotType.NewRedDot
  end
  Content.LockType = nil
  if Content.SelfWidget then
    Content.SelfWidget:SetRedDot(Content.RedDotType)
    Content.SelfWidget:SetLock(Content.LockType)
  end
  if Content == self.ComparedContent then
    self:UpdateAccessoryDetails(self.ComparedContent)
  end
  if self.Type == CommonConst.ArmoryType.Char then
    self:CheckCharAccessoryContentReddot(AccessoryId)
    self:InitCharAccessoryList()
  else
    self:CheckWeaponAccessoryContentReddot(AccessoryId)
    self:InitWeaponAccessoryList()
  end
end

function M:OnNewWeaponAccessoryObtained(AccessoryId)
  self:AddTimer(0.1, function()
    self:OnNewAccessoryObtained(AccessoryId)
  end)
end

function M:OnNewWeaponSkinObtained(SkinId)
  self:AddTimer(0.1, function()
    self:OnNewSkinObtained(SkinId)
  end)
end

function M:OnNewSkinObtained(SkinId)
  local Content = self.SkinMap[SkinId]
  if Content then
    Content.LockType = nil
    if not self.NoReddot then
      Content.IsNew = true
    end
    if Content.Widget then
      Content.Widget.LockType = Content.LockType
      Content.Widget:SetReddot(Content.IsNew)
      Content.Widget:InitTextStyle()
    end
    if self.SelectedSkinId == SkinId then
      self:UpdateSkinDetails(Content)
    end
  end
end

function M:RemoveTopTabReddotListen()
  if self.NoReddot then
    return
  end
  self:RemoveCharAppearanceReddotListen()
  self:RemoveWeaponAppearanceReddotListen()
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
    self:OnHideUIKeyDown()
  end
end

function M:OnBackKeyDown()
  if self.bSelfHidden then
    return self:OnHideUIKeyDown()
  else
    if self.CurrentTopTabIdx ~= self.SkinTabIdx and self.IsAccessoryContentsCreated then
      self:RecoverAccessory()
    end
    if self.OpenPreviewDyeFromChat then
      if self.ActorController then
        self.ActorController:OnClosed()
      end
      self:Close()
    else
      self:PlayOutAnim()
    end
  end
end

function M:OnConfirmBtnClicked()
  if self.CurrentTopTabIdx == self.SkinTabIdx then
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_btn_confirm", nil, nil)
  else
    AudioManager(self):PlayUISound(nil, "event:/ui/common/role_replace", nil, nil)
  end
  if self.Type == CommonConst.ArmoryType.Char then
    if self.CurrentTopTabIdx == self.SkinTabIdx and not self.CurrentLockContent then
      self:OnCharSkinConfirmBtnClicked()
    elseif self.CurrentTopTabIdx == self.SkinTabIdx and self.CurrentLockContent then
      self:OnCharSkinGoToShopBtnClicked()
    else
      self:OnCharAccessoryConfirmBtnClicked()
    end
  elseif self.CurrentTopTabIdx == self.SkinTabIdx and not self.CurrentLockContent then
    self:OnWeaponSkinConfirmBtnClicked()
  elseif self.CurrentTopTabIdx == self.SkinTabIdx and self.CurrentLockContent then
    self:OnWeaponSkinGoToShopBtnClicked()
  else
    self:OnWeaponAccessoryConfirmBtnClicked()
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

function M:OnDyeBtnClicked()
  local Content = self.SkinMap[self.SelectedSkinId]
  if not self.IsTargetUnowned and Content.bDyeable and not Content.LockType then
    self:OpenDye()
  end
end

function M:InitUIInfo(Name, IsInUIMode, EventList, Params)
  M.Super.InitUIInfo(self, Name, IsInUIMode, EventList, Params)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SkinOpen", nil)
  Params = Params or {}
  self.Params = Params
  self.SelectedSkinId = nil
  self.Target = Params.Target
  self.Type = Params.Type
  self.OnCloseCallback = Params.OnCloseCallback
  self.Parent = Params.Parent
  self.IsTargetUnowned = Params.IsTargetUnowned
  self.IsCharacterTrialMode = Params.IsCharacterTrialMode
  self.IsPreviewMode = Params.IsPreviewMode
  self.NoReddot = self.IsPreviewMode or self.IsCharacterTrialMode or self.IsTargetUnowned
  self.OpenPreviewDyeFromChat = Params.OpenPreviewDyeFromChat
  self.OpenPreviewDyeFromShopItem = Params.OpenPreviewDyeFromShopItem
  self.OpenPreviewDyeFromChatColors = Params.Colors
  if self.Parent and self.Parent.ActorController then
    self.ActorController = self.Parent.ActorController
  end
  self.UIName = self:GetUIConfigName()
  if not self.ActorController then
    self.InAnimStyle = 1
  end
  if not self.InAnimStyle then
    self:Init(Params)
  end
  self:PlayInAnim()
end

function M:Init(Params)
  if not self.ActorController then
    self.IsPreviewMode = true
    self.Target = self:CreatePreviewTargetData(Params)
    Params.Target = self.Target
    Params.EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    Params.ViewUI = self
    self.ActorController = self:CreatePreviewActor(Params)
    self.ActorController:OnOpened()
    self.TabConfig.Tabs = nil
    self.TabConfig.LeftKey = nil
    self.TabConfig.RightKey = nil
  end
  if self.IsPreviewMode or self.IsCharacterTrialMode then
    self.TabConfig.DynamicNode = {"Back", "BottomKey"}
  end
  if self.IsPreviewMode then
    self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.WidgetSwitcher_BtnState:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.IsSkinWidgetNotReady = true
  self.Tab_Skin:Init(self.TabConfig)
  self.AppearanceSutiIndex = self.Target.CurrentAppearanceIndex
  local AppearanceSuit = self.Target:GetAppearance(self.AppearanceSutiIndex)
  self.SelectedSkinId = AppearanceSuit.SkinId
  self.JumpToCharAccessoryType = Params.AccessoryType
  self.Tab_Skin:BindEventOnTabSelected(nil, nil)
  if Params.AccessoryId or Params.AccessoryType then
    self.JumpToAccessoryId = Params.AccessoryId
    self.Tab_Skin:SelectTab(self.AccessoryTabIdx)
    self:OnTopTabSelected({
      Idx = self.AccessoryTabIdx
    })
  else
    self.JumpToSkinId = Params.SkinId
    self.Tab_Skin:SelectTab(self.SkinTabIdx)
    self:OnTopTabSelected({
      Idx = self.SkinTabIdx
    })
  end
  self.Tab_Skin:BindEventOnTabSelected(self, self.OnTopTabSelected)
  self:AddTopTabReddotListen()
  if self.OpenPreviewDyeFromChat then
    self:BlockAllUIInput(true)
    self:AddTimer(0.1, function()
      if not self then
        return
      end
      self:StopAllAnimations()
      self:OpenDye()
    end, false, 0, "OpenDye")
    self:AddTimer(0.2, function()
      if not self then
        return
      end
      self:BlockAllUIInput(false)
    end, false, 0, "UnBlockAllUIInput")
  end
  self:OnInited()
end

function M:OnInited()
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
end

function M:OnTopTabSelected(TabWidget, Content)
  self.CurrentTopTabIdx = TabWidget.Idx
  if self.ActorController then
    self.ActorController:UpdateCameraPPSetting()
  end
  if self.Type == CommonConst.ArmoryType.Char then
    if self.CurrentTopTabIdx == self.SkinTabIdx then
      if self.IsAccessoryContentsCreated then
        self:RecoverAccessory()
      end
      self:InitCharSkin()
    else
      if self.ActorController then
        self.ActorController:UpdateCameraPPSetting({IsAccessoryPPSetting = true})
      end
      self.Tab_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
      self:InitCharAccessory()
    end
  elseif self.CurrentTopTabIdx == self.SkinTabIdx then
    if self.IsAccessoryContentsCreated then
      self:RecoverAccessory()
    end
    self:InitWeaponSkin()
  else
    self.Tab_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:InitWeaponAccessory()
  end
end

function M:InitSkinList()
  if self.SkinArray == nil then
    return
  end
  self.List_Skin:ClearListItems()
  for index, value in ipairs(self.SkinArray) do
    rawset(value, "Idx", index)
    rawset(value, "IsCurrentUse", self.SkinArray[index].SkinId == self.CurrentSkinContent.SkinId)
    self.List_Skin:AddItem(value)
  end
  self.List_Skin:RequestFillEmptyContent()
end

function M:OnSkinListEntryReleased(Widget)
  self:DelayUpdateListArrow()
end

function M:OnSkinListEntryGenerated(Widget)
  self:DelayUpdateListArrow()
end

function M:OnAccessoryListEntryGenerated(Widget)
  self:DelayUpdateListArrow()
end

function M:OnAccessoryListEntryReleased(Widget)
  self:DelayUpdateListArrow()
end

function M:DelayUpdateListArrow()
  self:AddTimer(0.2, function()
    self:UpdateListArrow()
  end)
end

function M:UpdateListArrow()
  local ListWidget, ItemsPerLine, ArrowUp, ArrowDown
  if self.CurrentTopTabIdx == self.SkinTabIdx then
    ListWidget = self.List_Skin
    ArrowUp = self.List_Arrow_Up
    ArrowDown = self.List_Arrow_Down
  else
    ListWidget = self.List_Accessory
    ArrowUp = self.List_Arrow_Up_1
    ArrowDown = self.List_Arrow_Down_1
  end
  local Len = ListWidget:GetNumItems()
  ItemsPerLine = ListWidget:GetNumItemsPerLine()
  local MinEntryIdx, MaxEntryIdx = UIUtils.GetMinAndMaxDisplayedItemIndex(ListWidget)
  if ItemsPerLine < MinEntryIdx then
    ArrowUp:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    ArrowUp:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if Len > MaxEntryIdx then
    ArrowDown:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    ArrowDown:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SelectSkinById(SkinId)
  SkinId = SkinId or self.CurrentSkinContent.SkinId
  self:SelectSkinByContent(self.SkinMap[SkinId])
end

function M:SelectSkinByContent(Content)
  if not Content then
    return
  end
  local SelectedContent = self.SkinMap[self.SelectedSkinId]
  if SelectedContent then
    SelectedContent.IsSelect = false
    if SelectedContent.Widget then
      SelectedContent.Widget:SetIsSelected(SelectedContent.IsSelect)
    end
  end
  SelectedContent = Content
  if SelectedContent then
    SelectedContent.IsSelect = true
    if SelectedContent.Widget then
      SelectedContent.Widget:SetIsSelected(SelectedContent.IsSelect)
    end
  end
  self:UpdateSkinDetails(Content)
end

function M:UpdateSkinDetails(Content)
  if not Content then
    return
  end
  if Content.SkinId ~= self.SelectedSkinId and not self:IsAnimationPlaying(self.In) then
    self:PlayAnimation(self.Change)
  end
  self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.SelectedSkinId = Content.SkinId
  if Content.Name and Content.Name ~= "" then
    self.VB_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.VB_Info:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  local SkinNameFont = {
    nil,
    nil,
    "Font_Blue",
    "Font_Purple",
    "Font_Gold",
    "Font_Red"
  }
  if Content.Rarity and SkinNameFont[Content.Rarity] and self[SkinNameFont[Content.Rarity]] then
    self.Text_Name:SetFont(self[SkinNameFont[Content.Rarity]])
  end
  self.Text_Name:SetText(Content.Name)
  self.Text_Info:SetText(Content.Text)
  self.Text_SkinName_World:SetText(Content.Name_World)
  self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.Tag_Quality:SetVisibility(ESlateVisibility.Collapsed)
  if Content.ElementType then
    local IconName = "Armory_" .. Content.ElementType
    local AttributeIcon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName)
    self.Image_Element:SetBrushResourceObject(AttributeIcon)
    self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Content.WeaponTypeIcon then
    local TagIcon = LoadObject(Content.WeaponTypeIcon)
    self.Image_Element:SetBrushResourceObject(TagIcon)
    self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Content.CharName then
    self.Text_CharName:SetText(Content.CharName)
  else
    self.Text_CharName:SetText("")
  end
  if Content.NotOwned then
    self.Text_Char_None:SetText(GText("UI_SkinPreview_CharNotOwned"))
    self.Text_Char_None:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Content.Rarity then
    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tag_Quality:Init(Content.Rarity)
  end
  self:UpdateSkinVideo(self.SelectedSkinId)
  self:UpdateFunctionBtn(Content)
  self:UpdateActorAppearance(self.SelectedSkinId)
  if Content.IsNew and not self.NoReddot then
    ArmoryUtils:SetItemReddotRead(Content, true)
  end
end

function M:UpdateSkinVideo(SkinId)
  local Data = DataMgr.Skin[SkinId]
  if not (Data and 1 == Data.GetDisplayType and Data.DisplayPath) or not Data.VideoCover then
    self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  rawset(self, "SkinData", Data)
  self.Panel_Video:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local VideoCover = LoadObject(Data.VideoCover)
  if VideoCover then
    self.Img_Video:SetBrushResourceObject(VideoCover)
  end
  self.Btn_Play.Btn_Area.OnClicked:Clear()
  self.Btn_Play.Btn_Area.OnClicked:Add(self, self.OpenSkinVideo)
end

function M:OpenSkinVideo()
  local Data = rawget(self, "SkinData") or {}
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  local SkinVideo = UIManager(self):LoadUINew("ArmorySkinVideo", {
    Path = Data.DisplayPath,
    SoundPath = Data.GetSoundPath,
    DestructCB = function()
      self:SetFocus()
    end
  })
  if SkinVideo then
    SkinVideo:SetFocus()
  end
end

function M:UpdateFunctionBtn(Content)
  if not self.IsTargetUnowned and not self.IsPreviewMode and not self.IsCharacterTrialMode and Content.bDyeable and not Content.LockType then
    self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_Function:UnBindEventOnClickedByObj(self)
  self.CurrentLockContent = nil
  if self.CurrentSkinContent == Content then
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
    if self.IsTargetUnowned then
      self.Text_Desc:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
    else
      self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))
    end
  else
    if Content.LockType then
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
      self.CurrentLockContent = Content
      local CurGoToShopState = self:CheckSkinGoToShopState()
      if CurGoToShopState == GoToShopState.CanGoToShop then
        self.Btn_Function:SetText(GText("UI_Skin_GotoBuy"))
        self.Btn_Function:ForbidBtn(false)
      elseif CurGoToShopState == GoToShopState.ItemNotOnSale then
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        self.Text_Desc:SetText(GText("UI_Skin_CannotBuy"))
      elseif CurGoToShopState == GoToShopState.ItemIdNil or CurGoToShopState == GoToShopState.ItemNotExist or CurGoToShopState == GoToShopState.SkinNotValid then
        self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
        self.Text_Desc:SetText(GText("UI_Skin_CannotBuy"))
      end
    else
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
      if self.IsTargetUnowned then
        self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
        self.Btn_Function:ForbidBtn(true)
      else
        self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
        self.Btn_Function:ForbidBtn(false)
      end
    end
    self.Btn_Function:BindEventOnClicked(self, self.OnConfirmBtnClicked)
    self.ConfirmBtnFunc = self.OnConfirmBtnClicked
  end
  if self.IsCharacterTrialMode then
    if self.CurrentSkinContent == Content then
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
      self.Text_Desc:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
    elseif Content.LockType then
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
      self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
      self.Btn_Function:ForbidBtn(true)
    else
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
      self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
      self.Btn_Function:ForbidBtn(true)
    end
  end
end

function M:UpdateActorAppearance(SkinId)
  self:UpdateActorSkin(SkinId)
  self:UpdateActorColors(SkinId)
end

function M:UpdatePartMesh(SkinId)
  if self.Type ~= CommonConst.ArmoryType.Char or not self.ActorController then
    return
  end
  local Avatar = ArmoryUtils:GetAvatar()
  local Skin = self.Target:GetSkin(SkinId or self.Target:GetAppearance().SkinId, Avatar)
  self.ActorController:ShowPartMesh(Skin and Skin.IsShowPartMesh)
end

function M:UpdateActorSkin(SkinId)
  if self.Type == CommonConst.ArmoryType.Char then
    if not self.ActorController then
      return
    end
    local AppearanceSuitInfo = self.Target:DumpAppearanceSuit(ArmoryUtils:GetAvatar(), self.AppearanceSutiIndex)
    AppearanceSuitInfo.SkinId = SkinId
    AppearanceSuitInfo.Colors = self.Target:DumpColors(ArmoryUtils:GetAvatar(), SkinId)
    self.ActorController:ChangeCharAppearance(AppearanceSuitInfo)
    if SkinId ~= self.LastCharSkinId then
      self.ActorController.DelayFrame = 30
      self.ActorController.bPlaySameMontage = true
    end
    self.LastCharSkinId = SkinId
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, "", "", "")
  else
    self.ActorController:ChangeWeaponSkin(SkinId)
  end
end

function M:UpdateActorColors(SkinId)
  if self.Type == CommonConst.ArmoryType.Char then
  else
    local ColorInfo = self.Target:DumpColors(SkinId)
    self.ActorController:ChangeWeaponColor(ColorInfo)
  end
end

function M:InitCharSkin()
  if self.ActorController then
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, "", "", "")
    self.ActorController:HidePlayerActor(self.UIName, false)
  end
  local SkinId = self.JumpToSkinId or self.SelectedSkinId
  if self.JumpToSkinId then
    self.LastCharSkinId = self.JumpToSkinId
  end
  self.JumpToSkinId = nil
  self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  self:InitCharSkinList(self.Target)
  self:SelectSkinById(SkinId)
  self:AddTimer(0.01, function()
    self.IsSkinWidgetNotReady = false
  end)
end

function M:InitCharSkinList(Char)
  if self.bCharSkinListInited then
    return
  end
  rawset(self, "bCharSkinListInited", true)
  rawset(self, "SkinMap", {})
  rawset(self, "SkinArray", {})
  local Avatar = GWorld:GetAvatar()
  local DefaultSkinId = Char:GetDefaultSkinId()
  rawset(self, "DefaultSkinId", DefaultSkinId)
  local LeafNodeName = CommonConst.DataType.Char .. CommonConst.DataType.Skin .. Char.CharId
  local CacheDetail = {}
  if not self.NoReddot then
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeName) or {}
  end
  local OtherCharSkins = Avatar.OtherCharSkins[Char.CharId] or {}
  local OtherOwnedSkins = {}
  for key, value in pairs(OtherCharSkins) do
    OtherOwnedSkins[value] = true
  end
  for SkinId, Data in pairs(DataMgr.Skin) do
    if Data.CharId == Char.CharId then
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      rawset(Obj, "IsCharacterTrialMode", self.IsCharacterTrialMode)
      rawset(Obj, "SkinId", SkinId)
      rawset(Obj, "ItemId", SkinId)
      rawset(Obj, "IconPath", Data.LongIcon)
      rawset(Obj, "Rarity", Data.Rarity)
      rawset(Obj, "Name", GText(Data.SkinName))
      rawset(Obj, "Name_World", EnText(Data.SkinName))
      rawset(Obj, "Rarity", Data.Rarity)
      rawset(Obj, "Text", GText(Data.SkinDescribe))
      rawset(Obj, "CharId", Char.CharId)
      rawset(Obj, "ItemType", CommonConst.DataType.Skin)
      rawset(Obj, "Owner", self)
      rawset(Obj, "OnClicked", self.OnSkinItemClicked)
      rawset(Obj, "bDyeable", SkinId ~= DefaultSkinId)
      rawset(Obj, "IsNew", 1 == CacheDetail[SkinId])
      rawset(Obj, "IsTargetUnowned", self.IsTargetUnowned)
      if Char:GetSkin(SkinId, Avatar) then
        rawset(Obj, "LockType", false)
      elseif OtherOwnedSkins[SkinId] then
        rawset(Obj, "LockType", false)
      else
        rawset(Obj, "LockType", SkinId ~= DefaultSkinId)
      end
      if Obj.LockType and not CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.Skin, SkinId) then
      else
        local CharInfo = DataMgr.BattleChar[Data.CharId]
        if CharInfo then
          rawset(Obj, "ElementType", CharInfo.Attribute)
          rawset(Obj, "CharName", GText(CharInfo.CharName))
        end
        if Avatar and not Avatar:CheckCharEnough({
          [Data.CharId] = 1
        }) then
          rawset(Obj, "NotOwned", true)
        end
        rawset(Obj, "IsEquipped", false)
        self.SkinMap[SkinId] = Obj
        self:OnSkinContentCreated(Obj)
        table.insert(self.SkinArray, Obj)
      end
    end
  end
  table.sort(self.SkinArray, function(a, b)
    return a.SkinId < b.SkinId
  end)
  local AppearanceSuit = Char:GetAppearance()
  local SkinId = AppearanceSuit and AppearanceSuit.SkinId
  SkinId = SkinId or DefaultSkinId
  if SkinId and self.SkinMap[SkinId] then
    self.CurrentSkinContent = self.SkinMap[SkinId]
    self.CurrentSkinContent.IsEquipped = true
  end
  self:InitSkinList()
end

function M:OnSkinContentCreated()
end

function M:OnCharSkinConfirmBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ChangeCharAppearanceSkin(self.Target.Uuid, self.AppearanceSutiIndex, self.SelectedSkinId)
end

function M:CheckSkinGoToShopState()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return GoToShopState.SkinNotValid
  end
  local SkinInfo
  if self.Type == CommonConst.ArmoryType.Char then
    SkinInfo = DataMgr.Skin[self.SelectedSkinId]
  else
    SkinInfo = DataMgr.WeaponSkin[self.SelectedSkinId]
  end
  if not SkinInfo then
    return GoToShopState.SkinNotValid
  end
  local ItemIds = SkinInfo.GoShopTypeId
  if not ItemIds or not next(ItemIds) then
    return GoToShopState.ItemIdNil
  end
  local AllNotExist = true
  for _, ItemId in ipairs(ItemIds) do
    if DataMgr.ShopItem[ItemId] then
      AllNotExist = false
      break
    end
  end
  if AllNotExist then
    return GoToShopState.ItemNotExist
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local AllInvalid = true
    for _, ItemId in ipairs(ItemIds) do
      if Avatar:CheckIsEffective(ItemId) then
        AllInvalid = false
        break
      end
    end
    if AllInvalid then
      return GoToShopState.ItemNotOnSale
    end
  end
  return GoToShopState.CanGoToShop
end

function M:OnCharSkinGoToShopBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  local SkinInfo = DataMgr.Skin[self.SelectedSkinId]
  if not SkinInfo then
    return
  end
  local ItemIds = SkinInfo.GoShopTypeId
  if not ItemIds or not next(ItemIds) then
    return
  end
  for _, ItemId in ipairs(ItemIds) do
    local ShopItemData = DataMgr.ShopItem[ItemId]
    if ShopItemData then
      local bSuccess, JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType, "Shop", ShopItemData.TypeId)
      if bSuccess and JumpToPage then
        JumpToPage()
        return
      end
    end
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("皮肤表对应的商品Id可能没配对,麻烦策划检查一下"))
end

function M:OnWeaponSkinGoToShopBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  local SkinInfo = DataMgr.WeaponSkin[self.SelectedSkinId]
  if not SkinInfo then
    return
  end
  local ItemIds = SkinInfo.GoShopTypeId
  if not ItemIds or not next(ItemIds) then
    return
  end
  for _, ItemId in ipairs(ItemIds) do
    local ShopItemData = DataMgr.ShopItem[ItemId]
    if ShopItemData then
      local bSuccess, JumpToPage = PageJumpUtils:CreateJumpToShopAccess(ShopItemData.ItemType, "Shop", ShopItemData.TypeId)
      if bSuccess and JumpToPage then
        JumpToPage()
        return
      end
    end
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("皮肤表对应的商品Id可能没配对,麻烦策划检查一下"))
end

function M:OnCharSkinChanged(Ret, CharUuid, AppearanceIndex, SkinId)
  self:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:ResetTarget()
  if self.CurrentSkinContent then
    self:SetSkinIsCurrentUse(self.CurrentSkinContent, false)
  end
  self.CurrentSkinContent = self.SkinMap[SkinId]
  self:SetSkinIsCurrentUse(self.CurrentSkinContent, true)
  self:UpdateFunctionBtn(self.CurrentSkinContent)
end

function M:SetSkinIsCurrentUse(Content, IsCurrentUse)
  if not Content then
    return
  end
  Content.IsCurrentUse = IsCurrentUse
  if Content.Widget then
    Content.Widget:SetIsCurrentUse(Content.IsCurrentUse)
  end
end

function M:InitCharAccessory()
  self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  self:CreateCharAccessoryTabInfo()
  self:CreateCharAccessoryContents(self.Target, self.SelectedSkinId)
  self:CharAccessoryJumpTo()
end

function M:CharAccessoryJumpTo()
  local AccessoryId, AccessoryType = self.JumpToAccessoryId, self.JumpToCharAccessoryType
  local Content = self.Map_AccessoryContents[AccessoryId]
  if Content then
    local AccessoryTab = self.AccessoryTabsMap[Content.AccessoryType]
    if AccessoryTab then
      self.Tab_Accessory:SelectTab(AccessoryTab.Idx)
      return
    end
  else
    local AccessoryTab = self.AccessoryTabsMap[AccessoryType]
    if AccessoryTab then
      self.Tab_Accessory:SelectTab(AccessoryTab.Idx)
      return
    end
  end
  self.Tab_Accessory:SelectTab(1)
end

function M:CreateCharAccessoryTabInfo(Recreate)
  if rawget(self, "IsAccessoryTabInited") and not Recreate then
    return
  end
  rawset(self, "IsAccessoryTabInited", true)
  rawset(self, "CurrentAccessoryTabIdx", nil)
  rawset(self, "AccessoryTypes", {
    CommonConst.CharAccessoryTypes.Head,
    CommonConst.CharAccessoryTypes.Face,
    CommonConst.CharAccessoryTypes.Waist,
    CommonConst.CharAccessoryTypes.Back,
    CommonConst.CharAccessoryTypes.FX_Dead,
    CommonConst.CharAccessoryTypes.FX_Teleport,
    CommonConst.CharAccessoryTypes.FX_Footprint,
    CommonConst.CharAccessoryTypes.FX_Body,
    CommonConst.CharAccessoryTypes.FX_PlungingATK,
    CommonConst.CharAccessoryTypes.FX_HelixLeap
  })
  rawset(self, "FXAccessoryTypes", {
    [CommonConst.CharAccessoryTypes.FX_Dead] = true,
    [CommonConst.CharAccessoryTypes.FX_Teleport] = true,
    [CommonConst.CharAccessoryTypes.FX_Footprint] = true,
    [CommonConst.CharAccessoryTypes.FX_PlungingATK] = true,
    [CommonConst.CharAccessoryTypes.FX_HelixLeap] = true
  })
  rawset(self, "AttachableFXAccessoryTypes", {
    [CommonConst.CharAccessoryTypes.FX_Footprint] = true
  })
  rawset(self, "HidePlayerAccessoryTypes", {
    [CommonConst.CharAccessoryTypes.FX_Dead] = true,
    [CommonConst.CharAccessoryTypes.FX_Footprint] = true
  })
  rawset(self, "AccessoryTabsMap", {})
  rawset(self, "AccessoryTabsArray", {})
  for i, value in ipairs(self.AccessoryTypes) do
    local Tab = {
      Owner = self,
      AccessoryType = value,
      Text = "",
      Idx = i,
      IconPath = "/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_" .. value .. ".T_Tab_Fashion_" .. value
    }
    self.AccessoryTabsMap[Tab.AccessoryType] = Tab
    table.insert(self.AccessoryTabsArray, Tab)
    self:OnAccessoryTabContentCreated(Tab)
  end
  rawset(self, "TabConfigData", {
    ChildWidgetName = "TabSubIconItem",
    Tabs = self.AccessoryTabsArray,
    SoundFunc = function(self)
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
    end,
    SoundFuncReceiver = self
  })
  self.Tab_Accessory:Init(self.TabConfigData)
  self.Tab_Accessory:BindEventOnTabSelected(self, self.OnCharAccessoryTabClicked)
end

function M:OnAccessoryTabContentCreated(Content)
end

function M:CreateCharAccessoryContents(Char, SkinId, bRecreate)
  self.IsAccessoryContentsCreated = true
  self.CurrentContent = nil
  self.ComparedContent = nil
  rawset(self, "NoneAccessory", NewObject(UIUtils.GetCommonItemContentClass()))
  rawset(self.NoneAccessory, "Id", self.NoneAccessoryId)
  rawset(self.NoneAccessory, "AccessoryId", self.NoneAccessoryId)
  rawset(self.NoneAccessory, "Parent", self)
  rawset(self.NoneAccessory, "Icon", UIUtils.GetNoneAccessoryIconPath())
  rawset(self.NoneAccessory, "ItemType", CommonConst.DataType.CharAccessory)
  self.BP_AccessoryContents:Clear()
  self.BP_AccessoryContents:Add(self.NoneAccessory)
  rawset(self, "Map_AccessoryContents", {})
  rawset(self, "DefaultCharAccessoryIds", ArmoryUtils:GetDefaultCharAccessoryIds())
  local Avatar = GWorld:GetAvatar()
  for AccessoryId, Data in pairs(DataMgr.CharAccessory) do
    local Content = self:CreateCharAccessoryContent(Data)
    if Content and (Avatar.CharAccessorys[AccessoryId] or CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.CharAccessory, AccessoryId)) then
      Content.SoundDataName = "CharAccessory"
      self.BP_AccessoryContents:Add(Content)
      self.Map_AccessoryContents[AccessoryId] = Content
    end
  end
  rawset(self, "PartMeshAccessory", nil)
  rawset(self, "HornAccessory", nil)
  local AppearanceSuit = Char:GetAppearance()
  local Skin = Char:GetSkin(SkinId or AppearanceSuit.SkinId, Avatar)
  for _, Data in pairs(DataMgr.CharPartMesh) do
    local Content = self:CreateCharAccessoryContent(Data)
    if Content then
      Content.SoundDataName = "CharPartMesh"
      self.BP_AccessoryContents:Add(Content)
      self.Map_AccessoryContents[Data.AccessoryId] = Content
      if Content.PartName == "PartMesh" then
        rawset(self, "PartMeshAccessory", Content)
        rawset(Content, "bSelectTag", false)
        if Skin then
          if AppearanceSuit.Accessory[CommonConst.NewCharAccessoryTypes[Content.AccessoryType]] <= 0 then
            rawset(Content, "bSelectTag", Skin.IsShowPartMesh)
          else
            rawset(Content, "bSelectTag", false)
          end
          rawset(Content, "LockType", nil)
        else
          rawset(Content, "LockType", 2)
        end
      elseif Content.PartName == "Horn" then
        self.HornAccessory = Content
        self.HornAccessory.bSelectTag = AppearanceSuit.IsCornerVisible
        self.HornAccessory.LockType = nil
      end
    end
  end
  for _, AccessoryId in pairs(Avatar.CharAccessorys) do
    local Content = self.Map_AccessoryContents[AccessoryId]
    if Content then
      Content.IsHide = nil
      Content.LockType = nil
    end
  end
  for _, AccessoryId in pairs(Avatar.CharAccessorys) do
    self:CheckCharAccessoryContentReddot(AccessoryId)
  end
  self:AddAccessoryTabReddotListen()
  local CharAccessory = AppearanceSuit.Accessory
  for _, AccessoryType in ipairs(self.AccessoryTypes) do
    local AccessoryTypeIndex = CommonConst.NewCharAccessoryTypes[AccessoryType]
    if AccessoryTypeIndex then
      local AccessoryId = CharAccessory[AccessoryTypeIndex] or -1
      if AccessoryId == self.NoneAccessoryId then
        self[AccessoryType .. "Content"] = self.NoneAccessory
      else
        self[AccessoryType .. "Content"] = self.Map_AccessoryContents[AccessoryId]
      end
    end
  end
  if self.PartMeshAccessory and self.PartMeshAccessory.bSelectTag then
    self[self.PartMeshAccessory.AccessoryType .. "Content"] = self.PartMeshAccessory
  end
  if self.HornAccessory and self.HornAccessory.bSelectTag then
    self[self.HornAccessory.AccessoryType .. "Content"] = self.HornAccessory
  end
  for _, AccessoryType in ipairs(self.AccessoryTypes) do
    if self[AccessoryType .. "Content"] then
      self[AccessoryType .. "Content"].bSelectTag = true
    end
  end
end

function M:CheckCharAccessoryContentReddot(AccessoryId)
  if self.NoReddot then
    return
  end
  local Content = self.Map_AccessoryContents[AccessoryId]
  if not Content then
    return
  end
  local CharAccessoryData = DataMgr.CharAccessory[AccessoryId]
  if CharAccessoryData and CharAccessoryData.AccessoryType then
    local NodeName = CommonConst.DataType.CharAccessory .. CharAccessoryData.AccessoryType
    for _, _SkinId in ipairs(CharAccessoryData.Skin or {""}) do
      if ReddotManager.GetTreeNode(NodeName .. _SkinId) then
        local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(NodeName .. _SkinId)
        Content.RedDotType = 1 == CacheDetail[AccessoryId] and UIConst.RedDotType.NewRedDot
        if Content.RedDotType then
          self.AccessoryTabsMap[CharAccessoryData.AccessoryType].IsNew = true
          break
        end
      end
    end
  end
end

function M:CreateCharAccessoryContent(Data)
  if Data.AccessoryType then
    if Data.AccessoryId == self.DefaultCharAccessoryIds[Data.AccessoryType] then
      return
    end
    local bCreateContent = true
    if Data.Skin then
      bCreateContent = false
      local SkinId = self.SelectedSkinId
      for _, Id in ipairs(Data.Skin) do
        if Id == SkinId then
          bCreateContent = true
          break
        end
      end
    end
    if bCreateContent then
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      rawset(Obj, "ItemType", CommonConst.DataType.CharAccessory)
      rawset(Obj, "Icon", Data.Icon or "")
      rawset(Obj, "Id", Data.AccessoryId)
      rawset(Obj, "AccessoryId", Data.AccessoryId)
      rawset(Obj, "SortPriority", Data.SortPriority or 0)
      rawset(Obj, "IsHide", Data.IsHide)
      rawset(Obj, "LockType", 2)
      rawset(Obj, "Rarity", Data.Rarity or 0)
      rawset(Obj, "bSelectTag", false)
      rawset(Obj, "IsSelect", false)
      rawset(Obj, "AccessoryType", Data.AccessoryType)
      rawset(Obj, "PartName", Data.PartName)
      rawset(Obj, "UnlockOptionText", GText(Data.UnlockOption or ""))
      rawset(Obj, "Parent", self)
      return Obj
    end
  end
end

function M:AddAccessoryTabReddotListen()
  if self.NoReddot then
    return
  end
  local SkinId = self.SelectedSkinId
  if not self.TabNodeNames then
    self.TabNodeNames = {}
  end
  for AccessoryType, Tab in pairs(self.AccessoryTabsMap) do
    local NodeName = AccessoryType
    local LeafNodes = {}
    local LeafNodeName = CommonConst.DataType.CharAccessory .. AccessoryType
    LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
    LeafNodeName = LeafNodeName .. SkinId
    LeafNodes[LeafNodeName] = ReddotManager.GetTreeNode(LeafNodeName) and 1 or nil
    if not self.TabNodeNames[NodeName] and not IsEmptyTable(LeafNodes) then
      ReddotManager.AddListener(NodeName, self, function(self, Count)
        Tab.IsNew = Count > 0
        if Tab.UI then
          Tab.UI:SetReddot(Tab.IsNew)
        end
      end, LeafNodes)
      self.TabNodeNames[NodeName] = 1
    end
  end
end

function M:RemoveAccessoryTabReddotListen()
  if self.NoReddot then
    return
  end
  for NodeName, _ in pairs(self.TabNodeNames or {}) do
    ReddotManager.RemoveListener(NodeName, self)
  end
  self.TabNodeNames = nil
end

function M:SetCurrentTabItemsReddotsRead()
  if self.NoReddot then
    return
  end
  if self.FilteredContents then
    for key, Content in pairs(self.FilteredContents) do
      if Content.RedDotType then
        ArmoryUtils:SetItemReddotRead(Content, true)
      end
    end
  end
end

function M:OnCharAccessoryTabClicked(TabWidget)
  local Tab = self.AccessoryTabsArray[TabWidget.Idx]
  if self.ActorController then
    self.ActorController:ResetActorRotation()
    if self.HidePlayerAccessoryTypes[Tab.AccessoryType] then
      self.ActorController:HidePlayerActor(self.UIName, true)
    else
      self.ActorController:HidePlayerActor(self.UIName, false)
    end
  end
  self:RecoverAccessory()
  self:SetCurrentTabItemsReddotsRead()
  self.CurrentAccessoryTabIdx = Tab.Idx
  self.CurrentAccessoryTabWidget = TabWidget
  self.NoneAccessory.bSelectTag = false
  self.NoneAccessory.IsSelect = false
  self.NoneAccessory.AccessoryType = Tab.AccessoryType
  self.NoneAccessory.Id = self.DefaultCharAccessoryIds[Tab.AccessoryType] or self.NoneAccessoryId
  self.NoneAccessory.AccessoryId = self.NoneAccessory.Id
  self.CurrentContent = self.NoneAccessory
  if self.ComparedContent then
    self.ComparedContent.IsSelect = false
  end
  self.ComparedContent = nil
  self:InitCharAccessoryList()
  self.JumpToAccessoryId = nil
  self.JumpToCharAccessoryType = nil
  self.CurrentContent.bSelectTag = true
  self.ComparedContent = self.ComparedContent or self.CurrentContent
  self.CurrentContent.IsSelect = true
  self:SelectAccessoryItem(self.ComparedContent)
  if self.NoneAccessory.SelfWidget then
    self.NoneAccessory.SelfWidget:OnListItemObjectSet(self.NoneAccessory)
  end
  self.List_Accessory:BP_ScrollItemIntoView(self.CurrentContent)
end

function M:InitCharAccessoryList()
  local Tab = self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
  local Len = self.BP_AccessoryContents:Length()
  local FilteredContents = {}
  for i = 1, Len do
    local Content = self.BP_AccessoryContents[i]
    if Content.AccessoryId and Content.AccessoryType == Tab.AccessoryType and Content.AccessoryId ~= self.NoneAccessory.Id and not Content.IsHide then
      table.insert(FilteredContents, Content)
    end
  end
  self:InitList(FilteredContents)
end

function M:InitList(FilteredContents)
  self.FilteredContents = FilteredContents
  self.List_Accessory:ClearListItems()
  table.sort(FilteredContents, function(a, b)
    if a.LockType and b.LockType or not a.LockType and not b.LockType then
      if a.SortPriority == b.SortPriority then
        return a.AccessoryId > b.AccessoryId
      end
      return a.SortPriority > b.SortPriority
    else
      return b.LockType
    end
  end)
  self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
  self.List_Accessory:AddItem(self.NoneAccessory)
  for _, Content in ipairs(FilteredContents) do
    if self.JumpToAccessoryId and self.JumpToAccessoryId == Content.AccessoryId then
      self.ComparedContent = Content
    end
    if Content.bSelectTag then
      self.CurrentContent = Content
      if self.IsCharacterTrialMode then
        Content.TryOutText = GText("UI_CharPreview_Accessory_In_Trial")
      end
    end
    self.List_Accessory:AddItem(Content)
  end
  self.List_Accessory:RequestFillEmptyContent()
  self.List_Accessory:RequestPlayEntriesAnim()
end

function M:RecoverAccessory()
  if self.Type == CommonConst.ArmoryType.Char then
    self.ActorController:DestoryCreature(CommonConst.CharAccessoryTypes.FX_Dead)
    self.ActorController:StopPlayerFX()
    self.ActorController:StopPlayerMontage()
    self.ActorController:DestoryPlayerMeleeWeapon()
  end
  if not self.ComparedContent or self.ComparedContent == self.CurrentContent then
    return
  end
  if self.Type == CommonConst.ArmoryType.Char then
    local AccessoryType = self.ComparedContent.AccessoryType
    if self.FXAccessoryTypes[AccessoryType] and not self.AttachableFXAccessoryTypes[AccessoryType] then
      return
    end
    self.ActorController:ChangeCharAccessory(self.CurrentContent.AccessoryId, AccessoryType)
  else
    self.ActorController:ChangeWeaponAccessory(self.CurrentContent.AccessoryId)
  end
end

function M:OnAccessoryItemClicked(Content)
  self:TrySelectAccessoryItem(Content)
end

function M:OnAccessoryListSelectionChanged(Content, IsSelected)
end

function M:TrySelectAccessoryItem(Content)
  if not Content.Icon then
    return
  end
  if self.ComparedContent == Content and not CommonConst.ActionAccessoryTypes[Content.AccessoryType] then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
  if Content.AccessoryId then
    AudioManager(self):PlayItemSound(self, Content.AccessoryId, "Equip", Content.SoundDataName)
  end
  self:SelectAccessoryItem(Content)
end

function M:SelectAccessoryItem(Content)
  ArmoryUtils:SetItemIsSelected(self.ComparedContent, false)
  self.ComparedContent = Content
  ArmoryUtils:SetItemIsSelected(self.ComparedContent, true)
  self:UpdateAccessoryDetails(Content)
  if self.Type == CommonConst.ArmoryType.Char then
    self.ActorController:StopPlayerFX()
    self.ActorController:StopPlayerMontage()
    local AccessoryType = Content.AccessoryType
    if self.FXAccessoryTypes[AccessoryType] then
      self.ActorController:ShowPlayerFXAccessory(Content.AccessoryId, AccessoryType)
      if self.AttachableFXAccessoryTypes[AccessoryType] then
        self.ActorController:ChangeCharAccessory(Content.AccessoryId, AccessoryType)
      end
    else
      self.ActorController:ChangeCharAccessory(Content.AccessoryId, AccessoryType)
    end
  else
    self.ActorController:ChangeWeaponAccessory(Content.AccessoryId)
  end
end

function M:OnCharAccessoryConfirmBtnClicked()
  if not self.ComparedContent then
    return
  end
  if self.ComparedContent.LockType then
    return
  end
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  if self.ComparedContent == self.NoneAccessory then
    if self.CurrentContent == self.PartMeshAccessory then
      Avatar:SetCharSkinShowPart(self.Target.Uuid, self.SelectedSkinId, false)
    elseif self.CurrentContent == self.HornAccessory then
      Avatar:SetCharCornerVisibility(self.Target.Uuid, self.AppearanceSutiIndex, false)
    else
      Avatar:RemoveCharAppearanceAccessory(self.Target.Uuid, self.AppearanceSutiIndex, self.CurrentContent.AccessoryId)
    end
  elseif self.ComparedContent == self.PartMeshAccessory then
    Avatar:SetCharSkinShowPart(self.Target.Uuid, self.SelectedSkinId, true)
  elseif self.ComparedContent == self.HornAccessory then
    Avatar:SetCharCornerVisibility(self.Target.Uuid, self.AppearanceSutiIndex, true)
  else
    Avatar:SetCharAppearanceAccessory(self.Target.Uuid, self.AppearanceSutiIndex, self.ComparedContent.AccessoryId)
  end
end

function M:OnCharAccessoryChanged(Ret, CharUuid, CharAccessoryIndex)
  self:BlockAllUIInput(false)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    self.Target = Avatar.Chars[CharUuid]
    self:OnEquipedCharAccessoryContentChanged()
    self:UpdateAccessoryDetails(self.CurrentContent)
  else
    UIManager(self):ShowError(Ret, 1.5)
  end
end

function M:OnCharAppearanceChanged(Ret, CharUuid, CharAccessoryIndex)
  self:BlockAllUIInput(false)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    self.Target = Avatar.Chars[CharUuid]
  else
    UIManager(self):ShowError(Ret, 1.5)
  end
end

function M:OnCharShowPartMesh(Ret, CharUuid, CharAccessorySuitIndex, IsShowPartMesh)
  self:BlockAllUIInput(false)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    self.Target = Avatar.Chars[CharUuid]
    self:OnEquipedCharAccessoryContentChanged()
    self:UpdateAccessoryDetails(self.CurrentContent)
  else
    UIManager(self):ShowError(Ret, 1.5)
  end
end

function M:OnCharCornerVisibilityChanged(Ret, CharUuid)
  self:BlockAllUIInput(false)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    self.Target = Avatar.Chars[CharUuid]
    self:OnEquipedCharAccessoryContentChanged()
    self:UpdateAccessoryDetails(self.CurrentContent)
  else
    UIManager(self):ShowError(Ret, 1.5)
  end
end

function M:InitWeaponSkin()
  local SkinId = self.JumpToSkinId or self.SelectedSkinId
  self.JumpToSkinId = nil
  self.WidgetSwitcher_State:SetActiveWidgetIndex(1)
  self:InitWeaponSkinList()
  self:SelectSkinById(SkinId)
  self:AddTimer(0.01, function()
    self.IsSkinWidgetNotReady = false
  end)
end

function M:InitWeaponSkinList()
  if self.bWeaponSkinListInited then
    return
  end
  self.bWeaponSkinListInited = true
  self.SkinMap = {}
  self.SkinArray = {}
  local Avatar = GWorld:GetAvatar()
  local CurWeaponId = self.Target.WeaponId
  local CurSkin = self.Target:GetCurrentSkin() or {}
  local CurSkinId = CurSkin.SkinId or CurWeaponId
  local LeafNodeNamePre = CommonConst.DataType.WeaponSkin
  for SkinId, Data in pairs(DataMgr.WeaponSkin) do
    if UIUtils.CanApplyWeaponSkin(CurWeaponId, Data.ApplicationType) then
      local CacheDetail = {}
      if not self.NoReddot then
        CacheDetail = ReddotManager.GetLeafNodeCacheDetail(LeafNodeNamePre .. (Data.ApplicationType or "")) or {}
      end
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      rawset(Obj, "SkinId", Data.SkinID)
      rawset(Obj, "ItemId", Data.SkinID)
      rawset(Obj, "IconPath", Data.LongIcon)
      rawset(Obj, "Name", GText(Data.Name))
      rawset(Obj, "Name_World", EnText(Data.Name))
      rawset(Obj, "Rarity", Data.Rarity)
      rawset(Obj, "Text", GText(Data.Dec))
      rawset(Obj, "Owner", self)
      rawset(Obj, "OnClicked", self.OnSkinItemClicked)
      rawset(Obj, "bDyeable", true)
      rawset(Obj, "IsNew", 1 == CacheDetail[SkinId])
      rawset(Obj, "ItemType", CommonConst.DataType.WeaponSkin)
      rawset(Obj, "IsTargetUnowned", self.IsTargetUnowned)
      rawset(Obj, "SkinId", Data.SkinID)
      if Avatar.OwnedWeaponSkins[SkinId] then
        rawset(Obj, "LockType", false)
      else
        rawset(Obj, "LockType", SkinId ~= CurWeaponId)
      end
      if Obj.LockType and not CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.WeaponSkin, SkinId) then
      else
        local WeaponTypeInfo = DataMgr.WeaponTypeContrast[Data.ApplicationType]
        if WeaponTypeInfo then
          rawset(Obj, "CharName", string.format(GText("UI_SkinPreview_WeaponType"), GText(WeaponTypeInfo.WeaponTagTextmap)))
          rawset(Obj, "WeaponTypeIcon", WeaponTypeInfo.Icon)
        end
        self.SkinMap[Obj.SkinId] = Obj
        table.insert(self.SkinArray, Obj)
        self:OnSkinContentCreated(Obj)
      end
    end
  end
  table.sort(self.SkinArray, function(a, b)
    return a.SkinId < b.SkinId
  end)
  local WeaponData = self.Target:Data()
  local DefaultSkin = NewObject(UIUtils.GetCommonItemContentClass())
  rawset(DefaultSkin, "SkinId", CurWeaponId)
  rawset(DefaultSkin, "IconPath", WeaponData.LongIcon or WeaponData.GachaIcon)
  rawset(DefaultSkin, "Owner", self)
  rawset(DefaultSkin, "OnClicked", self.OnSkinItemClicked)
  rawset(DefaultSkin, "bDyeable", true)
  rawset(DefaultSkin, "IsTargetUnowned", self.IsTargetUnowned)
  self.SkinMap[DefaultSkin.SkinId] = DefaultSkin
  table.insert(self.SkinArray, 1, DefaultSkin)
  self:OnSkinContentCreated(DefaultSkin)
  if CurSkinId and self.SkinMap[CurSkinId] then
    self.CurrentSkinContent = self.SkinMap[CurSkinId]
    self.CurrentSkinContent.IsEquipped = true
  end
  self:InitSkinList()
end

function M:OnWeaponSkinChanged(Ret, WeaponUuid, SkinId)
  self:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:ResetTarget()
  if self.CurrentSkinContent then
    self:SetSkinIsCurrentUse(self.CurrentSkinContent, false)
  end
  self.CurrentSkinContent = self.SkinMap[SkinId]
  self:SetSkinIsCurrentUse(self.CurrentSkinContent, true)
  self:UpdateFunctionBtn(self.CurrentSkinContent)
end

function M:OnWeaponSkinConfirmBtnClicked()
  if not self.SelectedSkinId or self.SelectedSkinId <= 0 then
    return
  end
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  Avatar:ChangeWeaponAppearanceSkin(self.Target.Uuid, self.SelectedSkinId)
end

function M:InitWeaponAccessory()
  self.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  self:CreateWeaponAccessoryContents(self.Target)
  if self.ArmoryHelper then
    self.ArmoryHelper:ResetRotation()
  end
  self.NoneAccessory.bSelectTag = false
  self.NoneAccessory.IsSelect = false
  self.CurrentContent = self.NoneAccessory
  if #self.Array_WeaponAccessoryContents <= 0 then
    self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:UpdateAccessoryDetails(self.CurrentContent)
    return
  end
  if self.ComparedContent then
    self.ComparedContent.IsSelect = false
  end
  self.ComparedContent = nil
  self:InitWeaponAccessoryList()
  self:SelectAccessoryItem(self.ComparedContent)
  self.List_Accessory:BP_ScrollItemIntoView(self.ComparedContent)
end

local function AddWeaponAccessoryContent(self, AccessoryId)
  local Data = DataMgr.WeaponAccessory[AccessoryId]
  local Content = self:CreateWeaponAccessoryContent(Data)
  if Content then
    Content.SoundDataName = "WeaponAccessory"
    self.BP_AccessoryContents:Add(Content)
    self.Map_AccessoryContents[AccessoryId] = Content
    table.insert(self.Array_WeaponAccessoryContents, Content)
    self:CheckWeaponAccessoryContentReddot(AccessoryId)
    self:OnAccessoryContentCreated(Content)
  end
end

function M:CheckWeaponAccessoryContentReddot(AccessoryId)
  if self.NoReddot then
    return
  end
  local Content = self.Map_AccessoryContents[AccessoryId]
  if not Content then
    return
  end
  local CacheDetail = {}
  local ReddotName = CommonConst.DataType.WeaponAccessory
  if ReddotManager.GetTreeNode(ReddotName) then
    CacheDetail = ReddotManager.GetLeafNodeCacheDetail(CommonConst.DataType.WeaponAccessory) or {}
  end
  Content.RedDotType = 1 == CacheDetail[AccessoryId] and UIConst.RedDotType.NewRedDot
end

function M:CreateWeaponAccessoryContents(Weapon, bRecreate)
  if self.IsAccessoryContentsCreated and not bRecreate then
    return
  end
  self.IsAccessoryContentsCreated = true
  self.CurrentContent = nil
  self.ComparedContent = nil
  self.NoneAccessory = NewObject(UIUtils.GetCommonItemContentClass())
  self.NoneAccessory.Id = -1
  self.NoneAccessory.Parent = self
  self.NoneAccessory.Icon = UIUtils.GetNoneAccessoryIconPath()
  self.NoneAccessory.ItemType = CommonConst.DataType.WeaponAccessory
  self.BP_AccessoryContents:Clear()
  self.BP_AccessoryContents:Add(self.NoneAccessory)
  self:OnAccessoryContentCreated(self.NoneAccessory)
  self.Map_AccessoryContents = {}
  self.Array_WeaponAccessoryContents = {}
  local Avatar = GWorld:GetAvatar()
  for AccessoryId, Data in pairs(DataMgr.WeaponAccessory) do
    if Avatar.WeaponAccessorys[AccessoryId] or CommonUtils.IsCurrentVersionRealease(CommonConst.DataType.WeaponAccessory, AccessoryId) then
      AddWeaponAccessoryContent(self, AccessoryId)
    end
  end
  for key, AccessoryId in pairs(Avatar.WeaponAccessorys) do
    local Content = self.Map_AccessoryContents[AccessoryId]
    if Content then
      Content.IsHide = nil
      Content.LockType = nil
    end
  end
  local AppearanceSuit = Weapon:GetAppearance()
  for _, AccessoryId in pairs(AppearanceSuit.Accessory) do
    local Content = self.Map_AccessoryContents[AccessoryId]
    if Content then
      Content.bSelectTag = true
    end
  end
end

function M:OnAccessoryContentCreated(Content)
end

function M:CreateWeaponAccessoryContent(Data)
  local Obj = NewObject(UIUtils.GetCommonItemContentClass())
  Obj.ItemType = CommonConst.DataType.WeaponAccessory
  Obj.Icon = Data.Icon or ""
  Obj.Id = Data.WeaponAccessoryId
  Obj.AccessoryId = Data.WeaponAccessoryId
  Obj.SortPriority = Data.SortPriority or 0
  Obj.LockType = 2
  Obj.IsHide = Data.IsHide
  Obj.bSelectTag = false
  Obj.IsSelect = false
  Obj.UnlockOptionText = GText(Data.UnlockOption or "")
  Obj.Parent = self
  Obj.Rarity = Data.Rarity or 0
  return Obj
end

function M:InitWeaponAccessoryList()
  self.List_Accessory:ClearListItems()
  table.sort(self.Array_WeaponAccessoryContents, function(a, b)
    if a.LockType and b.LockType or not a.LockType and not b.LockType then
      if a.SortPriority == b.SortPriority then
        return a.AccessoryId > b.AccessoryId
      end
      return a.SortPriority > b.SortPriority
    else
      return b.LockType
    end
  end)
  self.List_Accessory:AddItem(self.NoneAccessory)
  self.List_Accessory:SetVisibility(UIConst.VisibilityOp.Visible)
  self.FilteredContents = {}
  for _, Content in ipairs(self.Array_WeaponAccessoryContents) do
    if not Content.IsHide then
      if self.JumpToAccessoryId and self.JumpToAccessoryId == Content.AccessoryId then
        self.ComparedContent = Content
      end
      if Content.bSelectTag then
        self.CurrentContent = Content
      end
      self.List_Accessory:AddItem(Content)
      table.insert(self.FilteredContents, Content)
    end
  end
  self.JumpToAccessoryId = nil
  self.CurrentContent.bSelectTag = true
  self.ComparedContent = self.ComparedContent or self.CurrentContent
  self.ComparedContent.IsSelect = true
end

function M:OnWeaponAccessoryConfirmBtnClicked()
  if not self.ComparedContent then
    return
  end
  if self.ComparedContent.LockType then
    return
  end
  self:BlockAllUIInput(true)
  local Avatar = GWorld:GetAvatar()
  if self.ComparedContent.AccessoryId then
    Avatar:ChangeWeaponAppearanceAccessory(self.Target.Uuid, self.ComparedContent.AccessoryId)
  else
    Avatar:ChangeWeaponAppearanceAccessory(self.Target.Uuid, -1)
  end
end

function M:OnWeaponAccessoryChanged(Ret, WeaponUuid, AccessoryId)
  self:BlockAllUIInput(false)
  if not ErrorCode:Check(Ret) then
    return
  end
  self:ResetTarget()
  self:OnEquipedCharAccessoryContentChanged()
  self:UpdateAccessoryDetails(self.CurrentContent)
end

function M:IsNoneAccessory(Content)
end

function M:UpdateAccessoryDetails(Content)
  if self.Type == "Char" then
    local AccessoryType
    if self.CurrentAccessoryTabIdx then
      local CurrentTab = self.AccessoryTabsArray[self.CurrentAccessoryTabIdx]
      AccessoryType = CurrentTab and CurrentTab.AccessoryType
    end
    self:UpdateAccessoryCamera(Content.AccessoryId, AccessoryType)
  end
  self.Panel_Dye:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Video:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Function:UnBindEventOnClickedByObj(self)
  if self.CurrentContent == Content then
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Equipped)
    self.Text_Desc:SetText(GText("UI_Accessory_Equipped"))
    if self.IsCharacterTrialMode or self.IsTargetUnowned then
      self.Btn_Function:SetText(GText("UI_CharPreview_Accessory_In_Trial"))
    end
  elseif Content.LockType then
    local ShopItemId = self:GetShopItemByAccessoryId(Content.AccessoryId)
    local ShopItemData = ShopItemId and DataMgr.ShopItem[ShopItemId]
    local CanBuy = false
    local Price
    if ShopItemData then
      Price = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
      ShopItemData = setmetatable({}, {__index = ShopItemData})
      local CanPurchase = ShopUtils:CanPurchase(ShopItemData, ShopItemData.PriceType, Price)
      CanBuy = ShopUtils:GetShopItemCanShow(ShopItemId) and CanPurchase
    end
    if CanBuy then
      if not self.IsPreviewMode then
        self.Panel_Buy:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
      self.Btn_Function:SetText(GText("UI_SHOP_PURCHASE"))
      local ShopItemData = DataMgr.ShopItem[ShopItemId]
      local PriceType = ShopItemData.PriceType
      local Avatar = GWorld:GetAvatar()
      local ResourceCount = Avatar.Resources[PriceType] and Avatar.Resources[PriceType].Count or 0
      local FakeDenominator
      if Price > ResourceCount then
        FakeDenominator = Price + ResourceCount
      else
        FakeDenominator = Price
      end
      self.WBP_Com_Cost:InitContent({
        ResourceId = ShopItemData.PriceType,
        Denominator = FakeDenominator,
        Numerator = Price
      })
      if Price > ResourceCount then
        self.Btn_Function:ForbidBtn(true)
      else
        self.Btn_Function:ForbidBtn(false)
        self.Btn_Function:BindEventOnClicked(self, self.OnBuyBtnClicked)
        self.ConfirmBtnFunc = self.OnBuyBtnClicked
      end
    else
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
      if Content.UnlockOptionText and Content.UnlockOptionText ~= "" then
        self.Text_Lock:SetText(Content.UnlockOptionText)
        self.Btn_Function:ForbidBtn(true)
      else
        self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
        self.Btn_Function:ForbidBtn(true)
      end
    end
    if self.IsCharacterTrialMode then
      self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Locked)
      if Content.UnlockOptionText and Content.UnlockOptionText ~= "" then
        self.Text_Lock:SetText(Content.UnlockOptionText)
      else
        self.Text_Lock:SetText(GText("UI_Aaccessory_Locked"))
      end
    end
  else
    self.WidgetSwitcher_BtnState:SetActiveWidgetIndex(self.BtnWidgetState.Unequipped)
    self.Btn_Function:SetText(GText("UI_Accessory_Equip"))
    self.Btn_Function:BindEventOnClicked(self, self.OnConfirmBtnClicked)
    self.ConfirmBtnFunc = self.OnConfirmBtnClicked
    self.Btn_Function:ForbidBtn(false)
    if self.IsCharacterTrialMode or self.IsTargetUnowned then
      self.Btn_Function:SetText(GText("UI_CharPreview_Cannot_Equip"))
      self.Btn_Function:ForbidBtn(true)
    end
  end
  if Content == self.NoneAccessory then
    self.VB_Info:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Tag_Quality:SetVisibility(ESlateVisibility.Collapsed)
    return
  end
  self.VB_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local Data
  if self.Type == CommonConst.ArmoryType.Char then
    Data = DataMgr.CharAccessory[Content.AccessoryId] or DataMgr.CharPartMesh[Content.AccessoryId]
    self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap[Data.AccessoryType] or ""))
  else
    Data = DataMgr.WeaponAccessory[Content.AccessoryId]
    self.Text_CharName:SetText(GText(UIConst.AccessoryTypeTextMap.WeaponAccessory))
  end
  local SkinNameFont = {
    nil,
    nil,
    "Font_Blue",
    "Font_Purple",
    "Font_Gold",
    "Font_Red"
  }
  if Data.Rarity and SkinNameFont[Data.Rarity] and self[SkinNameFont[Data.Rarity]] then
    self.Text_Name:SetFont(self[SkinNameFont[Data.Rarity]])
  end
  self.Text_Name:SetText(GText(Data.Name))
  self.Text_Info:SetText(GText(Data.Des))
  self.Text_SkinName_World:SetText(EnText(Data.Name))
  self.Text_Char_None:SetVisibility(ESlateVisibility.Collapsed)
  self.Image_Element:SetVisibility(ESlateVisibility.Collapsed)
  self.Tag_Quality:SetVisibility(ESlateVisibility.Collapsed)
  local AccessoryIconPath = ArmoryUtils:GetCharNoneAccessoryIconPaths()[Data.AccessoryType]
  if AccessoryIconPath then
    local AccessoryIcon = LoadObject(AccessoryIconPath)
    self.Image_Element:SetBrushResourceObject(AccessoryIcon)
    self.Image_Element:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  if Data.Rarity then
    self.Tag_Quality:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Tag_Quality:Init(Data.Rarity)
  end
  if not self:IsAnimationPlaying(self.In) then
    self:PlayAnimation(self.Change)
  end
  if Content ~= self.NoneAccessory and Content.RedDotType and not self.NoReddot then
    ArmoryUtils:SetItemReddotRead(Content, true)
  end
end

function M:OnBuyBtnClicked()
  local ShopItemId = self:GetShopItemByAccessoryId(self.ComparedContent.AccessoryId)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  local Price = ShopUtils:GetShopItemPrice(ShopItemData.ItemId)
  UIManager(self):ShowCommonPopupUI(100041, {
    ShopItemData = ShopItemData,
    ShopType = 0,
    Funds = {
      {
        FundId = ShopItemData.PriceType,
        FundNeed = Price
      }
    },
    ShowParentTabCoin = true,
    RightCallbackObj = self,
    RightCallbackFunction = self.PurchaseAccessory
  }, self)
end

function M:PurchaseAccessory()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local ShopItemId = self:GetShopItemByAccessoryId(self.ComparedContent.AccessoryId)
  local ShopItemData = DataMgr.ShopItem[ShopItemId]
  if not ShopItemData then
    return
  end
  self:BlockAllUIInput(true)
  Avatar:PurchaseShopItem(ShopItemData.ItemId, 1)
end

function M:OnPurchaseShopItem(Ret)
  self:BlockAllUIInput(false)
  if Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
end

function M:OnWeaponColorsChanged()
  self:ResetTarget()
end

function M:OnEquipedCharAccessoryContentChanged()
  ArmoryUtils:SetItemSelectTag(self.CurrentContent, false)
  ArmoryUtils:SetItemSelectTag(self.ComparedContent, true)
  self.CurrentContent = self.ComparedContent
  if self.CurrentContent.AccessoryType then
    self[self.CurrentContent.AccessoryType .. "Content"] = self.CurrentContent
  end
end

function M:GetShopItemByAccessoryId(AccessoryId)
  local ItemType = self.Type .. "Accessory"
  local Data = DataMgr.TypeId2ShopItem[ItemType]
  return Data and Data[AccessoryId] and Data[AccessoryId][1]
end

function M:OnHideUIKeyDown()
  self.bSelfHidden = not self.bSelfHidden
  if self.bSelfHidden then
    self:SetRenderOpacity(0)
    self.Image_Click.Slot:SetZOrder(10)
  else
    self:SetRenderOpacity(1)
    self.Image_Click.Slot:SetZOrder(-1)
  end
end

function M:ResetTarget()
  if self.IsPreviewMode then
    return
  end
  local Avatar = ArmoryUtils:GetAvatar()
  if self.Type == CommonConst.ArmoryType.Char then
    self.Target = Avatar.Chars[self.Target.Uuid] or self.Target
  else
    self.Target = Avatar.Weapons[self.Target.Uuid] or self.Target
  end
end

function M:OpenDye()
  local Params = {
    Target = self.Target,
    Type = self.Type,
    SkinId = self.SelectedSkinId,
    IsPreviewMode = self.IsPreviewMode,
    Parent = self,
    OnCloseCallback = function()
      self:ResetTarget()
    end
  }
  if Params.Target and 1 == Params.Target.Uuid then
    Params.Target.Uuid = Params.SkinId
    local RealAvatar = ArmoryUtils:GetAvatar()
    if RealAvatar and self.Type == CommonConst.ArmoryType.Char and RealAvatar.Chars then
      for CharUuid, RealChar in pairs(RealAvatar.Chars) do
        if RealChar.CharId == Params.Target.CharId then
          Params.Target = RealChar
          Params.bRealCharOrWeapon = true
          break
        end
      end
    elseif self.Type == CommonConst.ArmoryType.Weapon and RealAvatar.Weapons then
      for WeaponUuid, RealWeapon in pairs(RealAvatar.Weapons) do
        if RealWeapon.WeaponId == Params.Target.WeaponId then
          Params.Target = RealWeapon
          Params.bRealCharOrWeapon = true
          break
        end
      end
    end
  elseif Params.Target and 1 ~= Params.Target.Uuid then
    Params.bRealCharOrWeapon = true
  end
  local UIConfig = DataMgr.SystemUI.ArmoryDye
  if self.Parent then
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, self:GetZOrder(), Params)
  else
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, 100, Params)
  end
end

function M:PlayInAnim()
  self:BlockAllUIInput(true)
  if self.InAnimStyle then
    self.ComBgSwitch = self:CreateWidgetNew("ComBgSwitch")
    if self.ComBgSwitch then
      self.ComBgSwitch:AddToViewport(self:GetZOrder())
      self.ComBgSwitch:PlayAnimation(self.ComBgSwitch.In)
      self.ComBgSwitch:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
      self:SetRenderOpacity(0)
      self:AddTimer(0.3, function()
        self:SetRenderOpacity(1)
        self:Init(self.Params)
        self:StopAnimation(self.Out)
        self:PlayAnimation(self.In)
      end, false, 0, "DelayInit")
    end
  else
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
  end
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
  if self.IsPreviewMode and self.ActorController then
    self.ActorController:OnClosed()
  end
  AudioManager(self):SetEventSoundParam(self, "SkinOpen", {ToEnd = 1})
  self:BlockAllUIInput(true)
end

function M:OnInAnimFinished()
  self:BlockAllUIInput(false)
end

function M:OnOutAnimFinished()
  self:Close()
end

function M:RealClose()
  M.Super.RealClose(self)
  if self.OnCloseCallback then
    self.OnCloseCallback(self.Parent)
  end
end

function M:Destruct()
  M.Super.Destruct(self)
  self:RemoveAccessoryTabReddotListen()
  if self.ActorController then
    self.ActorController:HidePlayerActor(self.UIName, false)
    self.ActorController:UpdateCameraPPSetting()
  end
  self:RemoveTimer("DelayInit")
  if IsValid(self.ComBgSwitch) then
    self.ComBgSwitch:RemoveFromParent()
  end
  self:RemoveTopTabReddotListen()
  if self.CurrentSkinContent and not self.IsPreviewMode then
    self:UpdateActorAppearance(self.CurrentSkinContent.SkinId)
  end
end

AssembleComponents(M)
return M
