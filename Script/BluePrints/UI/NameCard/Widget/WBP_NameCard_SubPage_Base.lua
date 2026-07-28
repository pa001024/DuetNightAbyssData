require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
M._components = {
  "BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_GamepadComp"
}
AssembleComponents(M)

function M:Construct()
  self.BgType = nil
  self.SelectedBgId = nil
  self.CurrentEffectiveBgId = nil
  self.BackgroundList = {}
  self.ListenedReddot = false
  self.SetBgRequestId = 0
  if self.List_NameCard and self.List_NameCard.OnCreateEmptyContent then
    self.List_NameCard.OnCreateEmptyContent:Unbind()
    self.List_NameCard.OnCreateEmptyContent:Bind(self, function(self)
      local Obj = NewObject(UIUtils.GetCommonItemContentClass())
      Obj.IsEmpty = true
      return Obj
    end)
  end
  if self.Btn_Confirm then
    self.Btn_Confirm:UnBindEventOnClicked(self, self.OnBtnConfirmClicked)
    self.Btn_Confirm:BindEventOnClicked(self, self.OnBtnConfirmClicked)
  end
  if self.Text_Used then
    self.Text_Used:SetText(GText("UI_Background_InUse"))
  end
  if self.Btn_Confirm then
    self.Btn_Confirm:SetText(GText("UI_Background_SetAsCard"))
  end
  if self.Text_Lock then
    self.Text_Lock:SetText(GText(""))
  end
end

function M:Init(Params)
  if not Params or not Params.BgType then
    return
  end
  self.BgType = Params.BgType
  self:LoadBackgroundData()
  self:InitSelectedBgId()
  self:FillList()
  self:InitPreview()
  self:UpdatePreview(self.SelectedBgId, true)
  self:UpdateButtonState(self.SelectedBgId)
  self:AddReddotListener(self:GetReddotName(), self.OnReddotChange)
end

function M:RefreshList()
  self:InitSelectedBgId()
  self:FillList()
  self:InitPreview()
  self:UpdatePreview(self.SelectedBgId, true)
  self:UpdateButtonState(self.SelectedBgId)
end

function M:InitSelectedBgId()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self.SelectedBgId = -1
    self.CurrentEffectiveBgId = -1
    return
  end
  local currentBgId
  if Avatar.PersonalInfo and Avatar.PersonalInfo.BackgroundIds then
    currentBgId = Avatar.PersonalInfo.BackgroundIds[self.BgType]
  end
  if nil == currentBgId then
    currentBgId = -1
  elseif currentBgId == CommonConst.DefaultNoBackground then
    currentBgId = -1
  end
  self.SelectedBgId = currentBgId
  self.CurrentEffectiveBgId = currentBgId
end

function M:LoadBackgroundData()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.BackgroundList = {}
  local defaultItem = {
    BgId = -1,
    Name = GText("UI_NameCard_Default") or "默认",
    Icon = nil,
    IsOwned = true,
    Config = nil
  }
  table.insert(self.BackgroundList, defaultItem)
  local ownedBgIds = Avatar.BackgroundList or {}
  local ownedMap = {}
  for _, bgId in ipairs(ownedBgIds) do
    ownedMap[bgId] = true
  end
  for bgId, cfg in pairs(DataMgr.Background) do
    if cfg then
      local itemData = {
        BgId = bgId,
        Name = cfg.Name,
        Icon = cfg.BigIcon,
        IsOwned = ownedMap[bgId] or false,
        Config = cfg
      }
      table.insert(self.BackgroundList, itemData)
    end
  end
  table.sort(self.BackgroundList, function(a, b)
    if -1 == a.BgId then
      return true
    end
    if -1 == b.BgId then
      return false
    end
    if a.IsOwned ~= b.IsOwned then
      return a.IsOwned
    end
    return a.BgId < b.BgId
  end)
end

function M:FillList()
  self.List_NameCard:ClearListItems()
  for _, itemData in ipairs(self.BackgroundList) do
    local ContentObj = NewObject(UIUtils.GetCommonItemContentClass())
    ContentObj.ItemData = itemData
    ContentObj.ParentWidget = self
    self.List_NameCard:AddItem(ContentObj)
  end
  self.List_NameCard:RequestFillEmptyContent()
end

function M:InitPreview()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:SetPlayerBasicInfo(Avatar)
end

function M:SetPlayerBasicInfo(Avatar)
  error("SetPlayerBasicInfo must be overridden by subclass")
end

function M:SetDescriptionTexts(title, desc)
  if self.Text_DescTitle then
    if title then
      self.Text_DescTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Text_DescTitle:SetText(GText(title))
    else
      self.Text_DescTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  if self.Text_Desc then
    if desc then
      self.Text_Desc:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Text_Desc:SetText(GText(desc))
    else
      self.Text_Desc:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:UpdatePreview(BgId, bSkipChangeAnim)
  if -1 == BgId then
    self:SetDescriptionTexts(nil, nil)
    if self.BgType == CommonConst.PersonalInfoBgType.Esc then
      self.WS_Img:SetActiveWidgetIndex(0)
    elseif self.BgType == CommonConst.PersonalInfoBgType.PersonalInfo then
      self.Img_Color:SetVisibility(UIConst.VisibilityOp.Collapsed)
    elseif self.BgType == CommonConst.PersonalInfoBgType.Friend then
      self.Img_Color:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if bSkipChangeAnim or self:IsAnimationPlaying(self.In) then
      return
    end
    self:StopAnimation(self.Change)
    self:PlayAnimation(self.Change)
    return
  end
  local cfg = DataMgr.Background[BgId]
  if not cfg then
    self:SetDescriptionTexts(nil, nil)
    return
  end
  self:SetDescriptionTexts(cfg.Name, cfg.Des)
  local bgPath
  if self.BgType == CommonConst.PersonalInfoBgType.Esc then
    bgPath = cfg.EscWidget
  elseif self.BgType == CommonConst.PersonalInfoBgType.PersonalInfo then
    bgPath = cfg.PersonalInfoWidget
  elseif self.BgType == CommonConst.PersonalInfoBgType.Friend then
    bgPath = cfg.FriendWidget
  end
  if self.BgType == CommonConst.PersonalInfoBgType.Esc then
    self.WS_Img:SetActiveWidgetIndex(1)
    self.WS_Img:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  elseif self.BgType == CommonConst.PersonalInfoBgType.PersonalInfo then
    self.Img_Color:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  elseif self.BgType == CommonConst.PersonalInfoBgType.Friend then
    self.Img_Color:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if not bgPath then
    return
  end
  local Image = LoadObject(bgPath)
  if Image then
    local DynamicMaterial = self.Img_Color:GetDynamicMaterial()
    if DynamicMaterial then
      DynamicMaterial:SetTextureParameterValue("MainTex", Image)
    end
  end
  if bSkipChangeAnim or self:IsAnimationPlaying(self.In) then
    return
  end
  self:StopAnimation(self.Change)
  self:PlayAnimation(self.Change)
end

function M:OnListItemClicked(BgId)
  self:ResetAllItemsClickState(BgId)
  self.SelectedBgId = BgId
  self:UpdatePreview(BgId)
  self:UpdateButtonState(BgId)
  UIUtils.TrySubReddotCacheDetailNumber(BgId, self:GetReddotName())
end

function M:ResetAllItemsClickState(exceptBgId)
  local displayedWidgets = self.List_NameCard:GetDisplayedEntryWidgets()
  for i = 1, displayedWidgets:Length() do
    local widget = displayedWidgets:GetRef(i)
    if widget and widget.ItemData and widget.ItemData.BgId ~= exceptBgId and widget.ResetClickState then
      widget:ResetClickState()
    end
  end
end

function M:UpdateButtonState(BgId)
  if not self.WS_Btn then
    return
  end
  local itemData
  for _, item in ipairs(self.BackgroundList) do
    if item.BgId == BgId then
      itemData = item
      break
    end
  end
  if not itemData then
    return
  end
  if BgId == self.CurrentEffectiveBgId then
    self.WS_Btn:SetActiveWidgetIndex(0)
  elseif itemData.IsOwned then
    self.WS_Btn:SetActiveWidgetIndex(1)
  else
    if self.Text_Lock and itemData.Config and itemData.Config.AccessText then
      self.Text_Lock:SetText(GText(itemData.Config.AccessText))
    end
    self.WS_Btn:SetActiveWidgetIndex(2)
  end
end

function M:OnBtnConfirmClicked()
  if not self.SelectedBgId then
    return
  end
  if self.SelectedBgId == self.CurrentEffectiveBgId then
    return
  end
  local itemData
  for _, item in ipairs(self.BackgroundList) do
    if item.BgId == self.SelectedBgId then
      itemData = item
      break
    end
  end
  if not itemData then
    return
  end
  if not itemData.IsOwned then
    return
  end
  local bgIdToSend = self.SelectedBgId
  if -1 == self.SelectedBgId then
    bgIdToSend = CommonConst.DefaultNoBackground
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.SetBgRequestId = self.SetBgRequestId + 1
  local requestId = self.SetBgRequestId
  Avatar:SetPersonalInfoBg(function(Ret)
    if 0 == Ret then
      UIManager(self):ShowUITip("CommonToastMain", GText("UI_Background_ChangeSuccess"), 1.5)
      if not IsValid(self) or requestId ~= self.SetBgRequestId then
        return
      end
      self.CurrentEffectiveBgId = bgIdToSend
      self:UpdateButtonState(self.SelectedBgId)
      self:UpdateAllItemsSelectedState()
      EventManager:FireEvent(EventID.OnPersonalInfoBgChanged, self.BgType, bgIdToSend)
      AudioManager(self):PlayUISound(self, "event:/ui/common/role_replace", nil, nil)
    else
      UIManager(self):ShowError(Ret, 1.0, "CommonToastMain")
    end
  end, self.BgType, bgIdToSend)
end

function M:UpdateAllItemsSelectedState()
  local displayedWidgets = self.List_NameCard:GetDisplayedEntryWidgets()
  if not displayedWidgets then
    return
  end
  for i = 1, displayedWidgets:Length() do
    local widget = displayedWidgets:GetRef(i)
    if widget and widget.SetSelected and widget.ItemData then
      local shouldSelect = widget.ItemData.BgId == self.CurrentEffectiveBgId
      widget.IsSelected = shouldSelect
      widget:SetSelected(shouldSelect)
    end
  end
end

function M:GetReddotName()
  if self.BgType == CommonConst.PersonalInfoBgType.Esc then
    return "NameCard_Esc"
  elseif self.BgType == CommonConst.PersonalInfoBgType.PersonalInfo then
    return "NameCard_PersonalInfo"
  elseif self.BgType == CommonConst.PersonalInfoBgType.Friend then
    return "NameCard_Friend"
  end
  return ""
end

function M:AddReddotListener(ReddotNodeName, func)
  if self.ListenedReddot then
    local RootNode = ReddotManager.GetTreeNode(ReddotNodeName)
    func(self, RootNode.Count)
    return
  end
  self:RemoveReddotListener(ReddotNodeName)
  ReddotManager.AddListener(ReddotNodeName, self, func)
  self.ListenedReddot = true
end

function M:RemoveReddotListener(ReddotNodeName)
  if self.ListenedReddot then
    ReddotManager.RemoveListener(ReddotNodeName, self)
    self.ListenedReddot = false
  end
end

function M:OnReddotChange(Count)
  local hasReddot = self:CheckAnyItemHasReddot()
  self:NotifyParentUpdateTabReddot(hasReddot)
end

function M:CheckAnyItemHasReddot()
  local ReddotName = self:GetReddotName()
  if not ReddotName or "" == ReddotName then
    return false
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail(ReddotName)
  if not CacheDetail then
    return false
  end
  local RootNode = ReddotManager.GetTreeNode(ReddotName)
  if not RootNode or RootNode.Count <= 0 then
    return false
  end
  for _, itemData in ipairs(self.BackgroundList) do
    if -1 ~= itemData.BgId and CacheDetail[itemData.BgId] then
      return true
    end
  end
  return false
end

function M:NotifyParentUpdateTabReddot(hasReddot)
  if self.ParentWidget and self.ParentWidget.UpdateTabReddot then
    self.ParentWidget:UpdateTabReddot(self.BgType, hasReddot)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:HandleGamepadInput(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:Destruct()
  self:RemoveReddotListener(self:GetReddotName())
  if self.Btn_Confirm and self.Btn_Confirm.UnBindEventOnClicked then
    self.Btn_Confirm:UnBindEventOnClicked(self, self.OnBtnConfirmClicked)
  end
  if self.List_NameCard and self.List_NameCard.OnCreateEmptyContent then
    self.List_NameCard.OnCreateEmptyContent:Unbind()
  end
end

return M
