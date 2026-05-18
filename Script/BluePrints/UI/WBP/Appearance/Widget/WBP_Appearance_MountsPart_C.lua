require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Appearance.WBP_Appearance_MainWidget_Base_C"
})
M._components = {
  "BluePrints.UI.WBP.Appearance.Widget.WBP_Appearance_MountsPart_GamePadCompoment"
}
local SkinNameFont = {
  nil,
  nil,
  "Font_Blue",
  "Font_Purple",
  "Font_Gold",
  "Font_Red"
}

local function GetMountAppearanceScore(MountId, MountConfig)
  for _, ScoreInfo in pairs(DataMgr.AppearanceSingleScore or {}) do
    if ScoreInfo.Type == "Mount" and ScoreInfo.Id == MountId then
      return ScoreInfo.Score or 0
    end
  end
  local Rarity = MountConfig and MountConfig.MountRarity
  for _, ScoreInfo in pairs(DataMgr.AppearanceScore or {}) do
    if ScoreInfo.Type == "Mount" and ScoreInfo.Rarity == Rarity then
      return ScoreInfo.Score or 0
    end
  end
  return 0
end

function M:Construct()
  M.Super.Construct(self)
  self.bIsFocusable = true
  self:AddDispatcher(EventID.OnGetLicense, self, self.OnGetLicense)
  self:AddDispatcher(EventID.MountsItemOnClick, self, self.OnMountsItemClicked)
end

function M:Destruct()
end

function M:Init(Params)
  self.Parent = Params.Parent
  self.MainModel = self.Parent.MainModel
  self.ActorController = self.Parent.ActorController
  self.IsPC = self.Parent and self.Parent.IsPC
  self.Type = CommonConst.ArmoryType.Mount
  self.IsRiderMount = true
  self.ArmoryRotation = nil
  self.MountContents = {}
  self.AllMethodSubWidgetList = {}
  self.bCanShowMethodDetail = false
  self.SortByFunction = {
    [1] = self.SortMountListForNormal,
    [2] = self.SortMountListForRarity
  }
  self.ListView_Items = self.List_Item
  self.Common_Sort_List = self.Com_Sort
  self:InitMobileMountButtons()
  self:InitMountsList()
  self:InitSortList()
  if self.InitMountGamepadWidgets then
    self:InitMountGamepadWidgets()
  end
  if not self.DisplayMountId and self.MountContents[1] then
    self.DisplayMountId = self.MountContents[1].MountId
  end
  self:RefreshMountList()
  self:PlayInAnim()
  self:RefreshMountPreview()
  self:InitMountInfoUI()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  self:RefreshMobileMountButtons()
  if self.OnMountInputTypeChanged then
    self:OnMountInputTypeChanged(CurInputDevice, CurGamepadName)
  end
end

function M:ToggleHideUI()
  if not self.Parent then
    return
  end
  self.Parent:OnHideUIKeyDown()
  self:RefreshMobileMountButtons()
  if self.OnMountHideStateChanged then
    self:OnMountHideStateChanged()
  end
end

function M:RefreshParentHideButton(bInMountTab)
  if not self.Parent or not self.Parent.Btn_Visible then
    return
  end
  local IsInMountTab = true == bInMountTab
  local ShouldShowParentHideButton = true == self.IsPC or not IsInMountTab
  self.Parent.Btn_Visible:SetVisibility(ShouldShowParentHideButton and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:InitMobileMountButtons()
  if not self.Btn_Mounts then
    return
  end
  if self.Btn_Mounts.Btn_Hide and self.Btn_Mounts.Btn_Hide.BindEvents then
    self.Btn_Mounts.Btn_Hide:BindEvents(self, {
      OnClicked = self.ToggleHideUI
    })
  end
  if self.Btn_Mounts.Btn_Riding and self.Btn_Mounts.Btn_Riding.BindEvents then
    self.Btn_Mounts.Btn_Riding:BindEvents(self, {
      OnClicked = self.ToggleRiderMount
    })
  end
  self:RefreshMobileMountButtons()
  self:RefreshMobileMountRidingIcon()
end

function M:RefreshMobileMountButtons()
  if not self.Btn_Mounts then
    return
  end
  local ShouldShow = self.IsPC ~= true and self.Parent
  self.Btn_Mounts:SetVisibility(ShouldShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshMobileMountRidingIcon()
  if not (self.Btn_Mounts and self.Btn_Mounts.Btn_Riding) or not self.Btn_Mounts.Btn_Riding.ChangeMountIcon then
    return
  end
  self.Btn_Mounts.Btn_Riding:ChangeMountIcon(not self.IsRiderMount)
end

function M:OnGetLicense()
  self:InitLicenseRedDot()
end

function M:GetDisplayMountId()
  return self.DisplayMountId
end

function M:GetZOrder()
  if self.Parent and self.Parent.GetZOrder then
    return self.Parent:GetZOrder()
  end
  if self.Root and self.Root.GetZOrder then
    return self.Root:GetZOrder()
  end
  return 0
end

function M:OnMountsItemClicked(SelectMountId)
  if not SelectMountId or self.DisplayMountId == SelectMountId then
    return
  end
  self.DisplayMountId = SelectMountId
  self:RefreshMountPreview()
  self:InitMountInfoUI()
end

function M:InitSortList()
  self.Common_Sort_List:Init(self, {
    GText("UI_Select_Default"),
    GText("UI_Select_Unique")
  }, CommonConst.DESC, {
    OnGetBackFocusWidget = function()
      if self.OnSortBackToMainState then
        self:OnSortBackToMainState()
      end
      return self.ListView_Items
    end
  })
  self.Common_Sort_List:BindEventOnSelectionsChanged(self, self.OnSelectionsChanged)
  self.Common_Sort_List:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
end

function M:OnSelectionsChanged(SortBy, SortType)
  local SortFunc = self.SortByFunction[SortBy]
  if SortFunc then
    SortFunc(self, SortType)
    self:RefreshMountList()
  end
end

function M:OnSortTypeChanged(SortType, SortBy)
  local SortFunc = self.SortByFunction[SortBy]
  if SortFunc then
    SortFunc(self, SortType)
    self:RefreshMountList()
  end
end

function M:InitMountsList()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.ListView_Items:ClearListItems()
  self.MountContents = {}
  for _, MountData in pairs(DataMgr.Mount or {}) do
    local MountContent = NewObject(UIUtils.GetCommonItemContentClass())
    MountContent.MountId = MountData.MountId
    MountContent.HasMount = Avatar:HasMountById(MountData.MountId)
    MountContent.SortPriority = MountData.SortPriority
    MountContent.MountRarity = MountData.MountRarity
    MountContent.MountsMain = self
    table.insert(self.MountContents, MountContent)
  end
  if 0 == #self.MountContents then
    return
  end
  self:SortMountListForNormal()
  self.DisplayMountId = self.DisplayMountId or self.MountContents[1].MountId
end

function M:SortMountListForNormal(SortType)
  SortType = SortType or CommonConst.DESC
  if SortType == CommonConst.DESC then
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.SortPriority ~= MountB.SortPriority then
          return MountA.SortPriority > MountB.SortPriority
        end
        return MountA.MountId > MountB.MountId
      end
      return MountA.HasMount
    end)
  else
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.SortPriority ~= MountB.SortPriority then
          return MountA.SortPriority < MountB.SortPriority
        end
        return MountA.MountId < MountB.MountId
      end
      return not MountA.HasMount
    end)
  end
end

function M:SortMountListForRarity(SortType)
  SortType = SortType or CommonConst.DESC
  if SortType == CommonConst.DESC then
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.MountRarity ~= MountB.MountRarity then
          return MountA.MountRarity > MountB.MountRarity
        end
        if MountA.SortPriority ~= MountB.SortPriority then
          return MountA.SortPriority > MountB.SortPriority
        end
        return MountA.MountId > MountB.MountId
      end
      return MountA.HasMount
    end)
  else
    table.sort(self.MountContents, function(MountA, MountB)
      if MountA.HasMount == MountB.HasMount then
        if MountA.MountRarity ~= MountB.MountRarity then
          return MountA.MountRarity < MountB.MountRarity
        end
        if MountA.SortPriority ~= MountB.SortPriority then
          return MountA.SortPriority < MountB.SortPriority
        end
        return MountA.MountId < MountB.MountId
      end
      return not MountA.HasMount
    end)
  end
end

function M:RefreshMountList()
  self.ListView_Items:ClearListItems()
  local MountSelectIndex
  for Index, MountContent in ipairs(self.MountContents) do
    MountContent.ItemIndex = Index
    MountContent.MountsMain = self
    self.ListView_Items:AddItem(MountContent)
    if MountContent.MountId == self.DisplayMountId and not MountSelectIndex then
      MountSelectIndex = Index
    end
  end
  if MountSelectIndex and self.ListView_Items.NavigateToIndex then
    self.ListView_Items:NavigateToIndex(MountSelectIndex - 1)
  end
  if self.ListView_Items.OnCreateEmptyContent then
    self.ListView_Items.OnCreateEmptyContent:Bind(self, function()
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      Obj.IsEmpty = true
      return Obj
    end)
  end
  if self.ListView_Items.RequestFillEmptyContent then
    self.ListView_Items:RequestFillEmptyContent()
  end
  if self.RefreshMountGamepadFocus then
    self:RefreshMountGamepadFocus()
  end
end

function M:RefreshMountPreview()
  if not self.ActorController or not self.DisplayMountId then
    return
  end
  if not self.ArmoryRotation then
    self.ArmoryRotation = self.ActorController:GetArmoryPlayerRotation()
  end
  self.ActorController:SetArmoryPlayerRotation(self.ArmoryRotation)
  self.ActorController:DestroyMount()
  self.ActorController:HidePlayerOnMount(not self.IsRiderMount)
  self.ActorController:CreateMount(self.DisplayMountId)
  local MountData = DataMgr.Mount[self.DisplayMountId]
  if MountData then
    self.ActorController:SetArmoryCameraTag("Mount", "", "", "")
  end
end

function M:DestroyPreviewMount()
  if self.ActorController then
    self.ArmoryRotation = self.ActorController:GetArmoryPlayerRotation()
    self.ActorController:DestroyMount()
  end
end

function M:ToggleRiderMount()
  self.IsRiderMount = not self.IsRiderMount
  if self.ActorController then
    self.ActorController:HidePlayerOnMount(not self.IsRiderMount)
  end
  self:RefreshMobileMountRidingIcon()
end

function M:InitMountInfoUI()
  if not self.DisplayMountId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MountConfig = DataMgr.Mount[self.DisplayMountId]
  if not MountConfig then
    return
  end
  local HasMount = Avatar:HasMountById(self.DisplayMountId)
  local AppearanceScore = GetMountAppearanceScore(self.DisplayMountId, MountConfig)
  self.Tag_Quality:Init(MountConfig.MountRarity)
  self.Text_Name:SetText(GText(MountConfig.MountName))
  self.Text_Info:SetText(GText(MountConfig.MountDes))
  self.Text_Fenghua:SetText(GText("UI_AppearanceScore_ScoreName"))
  self.Num_Fenghua:SetText(AppearanceScore)
  local FontName = MountConfig.MountRarity and SkinNameFont[MountConfig.MountRarity]
  if self.Text_Name and FontName and self[FontName] then
    self.Text_Name:SetFont(self[FontName])
  end
  self.Text_Method:SetText(GText("UI_Tips_Obtining"))
  self.Text_Method_World:SetText(MountConfig.UseLimitDes and GText(MountConfig.UseLimitDes) or "")
  self.Text_Method_World:SetVisibility(MountConfig.UseLimitDes and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Method:ClearChildren()
  self.AllMethodSubWidgetList = {}
  if MountConfig.AccessKey then
    for _, Access in pairs(MountConfig.AccessKey) do
      PageJumpUtils:GetItemAccess(self, self.DisplayMountId, "Mount", Access, "MountsMain")
    end
  end
  PageJumpUtils:SortAccessItem(self.Method)
  local ChildrenCount = self.Method:GetChildrenCount()
  local IsHideMethod = 0 == ChildrenCount or not MountConfig.AccessKey
  self.bCanShowMethodDetail = not IsHideMethod and not HasMount
  self.HB_Method:SetVisibility(self.bCanShowMethodDetail and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Method:SetVisibility(self.bCanShowMethodDetail and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Text_Method:SetVisibility(IsHideMethod and UIConst.VisibilityOp.Collapsed or UIConst.VisibilityOp.SelfHitTestInvisible)
  for i = 1, ChildrenCount do
    local TestWidget = self.Method:GetChildAt(i - 1)
    if TestWidget and not TestWidget.IsText then
      TestWidget:SetNavigationRuleCustom(EUINavigation.Left, {
        self,
        function()
          return TestWidget
        end
      })
      TestWidget:SetNavigationRuleCustom(EUINavigation.Right, {
        self,
        function()
          return TestWidget
        end
      })
      table.insert(self.AllMethodSubWidgetList, TestWidget)
    end
  end
  self.VB_Info:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.OnMountInfoChanged then
    self:OnMountInfoChanged()
  end
end

function M:InitLicenseRedDot()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.DisplayMountId and DataMgr.Mount[self.DisplayMountId] then
    self.Text_Fenghua:SetText(GText("UI_AppearanceScore_ScoreName"))
    self.Num_Fenghua:SetText(GetMountAppearanceScore(self.DisplayMountId, DataMgr.Mount[self.DisplayMountId]))
  end
end

function M:OnBackgroundClicked()
  if self.OnMountBackgroundClicked then
    self:OnMountBackgroundClicked()
  end
end

function M:OnParentKeyDown(MyGeometry, InKeyEvent)
  if self.HandleMountKeyDown then
    return self:HandleMountKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled, false
end

function M:OnParentKeyUp(MyGeometry, InKeyEvent)
  if self.HandleMountKeyUp then
    return self:HandleMountKeyUp(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled, false
end

function M:OnParentRepeatKeyDown(MyGeometry, InKeyEvent)
  if self.HandleMountRepeatKeyDown then
    return self:HandleMountRepeatKeyDown(MyGeometry, InKeyEvent)
  end
  return UIUtils.Unhandled, false
end

function M:OnParentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.HandleMountAnalogValueChanged then
    return self:HandleMountAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  end
  return UIUtils.Unhandled, false
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.HandleMountFocusReceived then
    return self:HandleMountFocusReceived(MyGeometry, InFocusEvent)
  end
  return UIUtils.Handled
end

function M:OnTabChangeToOther()
  self:RefreshParentHideButton(false)
  if self.ActorController and self.ActorController.CancelPendingDelayFramePreview then
    self.ActorController:CancelPendingDelayFramePreview()
  end
  self:DestroyPreviewMount()
  self:PlayOutAnim()
end

function M:OnTabChangeToSelf()
  self:PlayInAnim()
  self:RefreshMountPreview()
  self:InitMountInfoUI()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
  self:RefreshMobileMountButtons()
  self:RefreshMobileMountRidingIcon()
  self:RefreshParentHideButton(true)
end

function M:OnClose()
  self:PlayOutAnim()
end

function M:PlayInAnim()
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
end

AssembleComponents(M)
return M
