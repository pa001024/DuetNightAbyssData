require("UnLua")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local StuffIconObject = require("BluePrints.UI.WBP.Bag.Widget.BagStuffIconObject")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.PackageKey = "OptionalAvatar"
  self.OptionalItemsList = Params.OptionalItemsList
  self.ChooseCallbackFunction = Params.ChooseCallbackFunction
  self.FunctionCallbackObj = Params.FunctionCallbackObj
  self.OriginalTips = Params.Tips
  self.CurrentChooseWidget = nil
  self.AllItemsWidget = {}
  self.ParentWidget = Params.ParentWidget
  self.CurrentChooseInfo = Params.ParentWidget.CurrentChooseInfo or nil
  self.ResourceId = Params.ResourceId
  self.IsLimitedPrizePool = Params.IsLimitedPrizePool or false
  self.RestoreSelectIndex = Params.RestoreSelectIndex
  self.OriginSelectIndex = Params.SelectedIndex
  self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_CheckDetails")
  })
  if self.IsLimitedPrizePool then
    self:InitLimitedPrizePoolItemsInfo()
  else
    self:InitAllOptionalItemsInfo()
  end
  self.Owner:ShowDialogTip(1)
end

function M:InitAllOptionalItemsInfo()
  self.WB_Avatar:ClearChildren()
  for i, v in ipairs(self.OptionalItemsList) do
    v.__idx = i
  end
  table.sort(self.OptionalItemsList, function(a, b)
    local aNot = 0 == (a.HaveCountNumber or 0)
    local bNot = 0 == (b.HaveCountNumber or 0)
    if aNot ~= bNot then
      return aNot
    end
    return a.__idx < b.__idx
  end)
  for _, v in ipairs(self.OptionalItemsList) do
    v.__idx = nil
  end
  for Index, ItemInfo in ipairs(self.OptionalItemsList) do
    ItemInfo.Index = Index
    local Item = self:CreateWidgetNew("ComOptionalAvatarItem")
    self.WB_Avatar:AddChildToWrapBox(Item)
    Item:Init(ItemInfo.StuffType, ItemInfo, self.ChangeChooseClickCallback, self)
    table.insert(self.AllItemsWidget, Item)
  end
  local AllCanNavigateCount = #self.AllItemsWidget
  for Idx, TargetWidget in ipairs(self.AllItemsWidget) do
    if TargetWidget then
      TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      if 1 == Idx then
        TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
      elseif Idx == AllCanNavigateCount then
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
        TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      else
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
      end
    end
  end
  if self.CurrentChooseInfo then
    self:ResetChooseInfo()
  end
end

function M:InitLimitedPrizePoolItemsInfo()
  self.WB_Avatar:ClearChildren()
  for i, v in ipairs(self.OptionalItemsList) do
    v.__idx = i
  end
  table.sort(self.OptionalItemsList, function(a, b)
    local aNot = 0 == (a.HaveCountNumber or 0)
    local bNot = 0 == (b.HaveCountNumber or 0)
    if aNot ~= bNot then
      return aNot
    end
    return a.__idx < b.__idx
  end)
  for _, v in ipairs(self.OptionalItemsList) do
    v.__idx = nil
  end
  local RestoreChooseItem
  for Index, ItemInfo in ipairs(self.OptionalItemsList) do
    ItemInfo.Index = Index
    local Item = self:CreateWidgetNew("ComOptionalAvatarItem")
    self.WB_Avatar:AddChildToWrapBox(Item)
    Item:Init(BagCommon.OptionalItemType.LimitedPrizePool, ItemInfo, self.ChangeChooseClickCallback, self)
    if self.RestoreSelectIndex then
      if self.RestoreSelectIndex == Index then
        RestoreChooseItem = Item
      end
    elseif self.OriginSelectIndex and self.OriginSelectIndex == ItemInfo.OriginalIndex then
      RestoreChooseItem = Item
    end
    table.insert(self.AllItemsWidget, Item)
  end
  local AllCanNavigateCount = #self.AllItemsWidget
  for Idx, TargetWidget in ipairs(self.AllItemsWidget) do
    if TargetWidget then
      TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
      TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
      if 1 == Idx then
        TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
      elseif Idx == AllCanNavigateCount then
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
        TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
      else
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Idx - 1])
        TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Idx + 1])
      end
    end
  end
  if self.CurrentChooseInfo then
    self:ResetChooseInfo()
  end
  self:AddTimer(0.1, function()
    if RestoreChooseItem then
      if UIUtils.IsGamepadInput() then
        RestoreChooseItem:OnBtnChooseHovered()
        RestoreChooseItem:OnBtnChooseClicked()
        RestoreChooseItem:SetFocus()
      else
        RestoreChooseItem:OnBtnChooseClicked()
      end
    end
  end)
end

function M:ChangeChooseClickCallback(bSelectState, ChooseInfo)
  if self.CurrentChooseWidget then
    self.CurrentChooseWidget:SetSelected(false)
  end
  self.CurrentChooseInfo = ChooseInfo
  local IsForbid = ChooseInfo and ChooseInfo.IsForbidLimitPrize
  if IsForbid then
    self.CurrentChooseWidget = ChooseInfo.ChooseWidget
    self.Owner:ForbidRightBtn(true)
    self.Owner:HideDialogTip(2)
    self.Owner:ShowDialogTip(1)
  elseif bSelectState then
    self.CurrentChooseWidget = ChooseInfo.ChooseWidget
    self.CurrentChooseWidget:SetSelected(true)
    if type(self.ChooseCallbackFunction) == "function" then
      self.ChooseCallbackFunction(self.FunctionCallbackObj, self.CurrentChooseInfo)
    end
    self.Owner:ForbidRightBtn(false)
    if self.CurrentChooseInfo.ResourceId then
      local ResourceData = DataMgr.Resource[self.CurrentChooseInfo.ResourceId]
      local ResourceName = ResourceData and ResourceData.ResourceName
      local Funds = {}
      Funds[1] = {}
      Funds[1].FundId = self.ResourceId
      Funds[1].FundNeed = 1
      Funds[1].CostText = GText("UI_Armory_Trace_Cost")
      self:AddDelayFrameFunc(function()
        self:BroadcastDialogEvent("UpdateFunds", {Funds = Funds})
        self.Owner:HideDialogTip(1, false)
        self.Owner:ShowDialogTip(2)
      end, 1)
    end
  else
    self.CurrentChooseWidget = nil
    self.Owner:ForbidRightBtn(true)
    self.Owner:HideDialogTip(2)
    self.Owner:ShowDialogTip(1)
  end
end

function M:StoreChooseInfo()
  if not self.ParentWidget then
    return
  end
  local CurrentSelectIndex
  if self.CurrentChooseWidget and self.CurrentChooseInfo then
    CurrentSelectIndex = self.CurrentChooseInfo.Index
  end
  self.ParentWidget.SelectWidgetChooseIndex = CurrentSelectIndex
end

function M:ResetChooseInfo()
  local ChooseWidget = self.AllItemsWidget[self.CurrentChooseInfo.ChooseIndex]
  ChooseWidget:OnBtnChooseClicked()
end

function M:IsForbiddenChoose()
  if self.IsLimitedPrizePool then
    for _, ItemInfo in ipairs(self.OptionalItemsList) do
      if 0 == (ItemInfo.HaveCountNumber or 0) then
        return true
      end
    end
  end
  return false
end

function M:ScrollToTargetItem(TargetItem)
  self.ScrollBox_Avatar:ScrollWidgetIntoView(TargetItem)
end

function M:BP_GetDesiredFocusTarget()
  return self.CurrentChooseWidget or self.ScrollBox_Avatar
end

function M:OnBtnYes()
  if self.Owner then
    if self.CurrentChooseInfo == nil then
      self.Owner:OnForbiddenRightBtnClicked()
    elseif self.CurrentChooseWidget and self.CurrentChooseWidget.IsForbidChoose then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_LimitedPrizePool_AlreadyGet"))
    else
      self.Owner:OnRightBtnClicked()
    end
  end
end

function M:HideSelf(bIsHide, IsNeedFocus)
  if self.Owner then
    if bIsHide then
      self.Owner:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    if IsNeedFocus then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
      self:AddTimer(0.6, function()
        self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
        self:SetFocus()
      end)
    end
  end
end

function M:CloseDialog()
  if self.Owner then
    self.Owner:Close()
  end
end

function M:PackageData()
  local PackageInfo = {}
  PackageInfo.Count = 0
  PackageInfo.SelectedId = self.CurrentChooseInfo and self.CurrentChooseInfo.ChooseId
  return PackageInfo
end

function M:GetCurrentHoverItem()
  local TargetWidget
  local AllChildren = self.WB_Avatar:GetAllChildren()
  for i = 1, AllChildren:Length() do
    local ChildItem = AllChildren:GetRef(i)
    if ChildItem:CheckIsInHovered() then
      TargetWidget = ChildItem
      break
    end
  end
  return TargetWidget
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.LeftThumb then
      local CurrentHoveredWidget = self:GetCurrentHoverItem()
      if nil ~= CurrentHoveredWidget then
        CurrentHoveredWidget:OnBtnCheckClicked()
        IsEventHandled = true
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:OnBtnYes()
      local ButtonBar = self.Owner:GetButtonBar()
      ButtonBar:SimulateRightBtnClick()
      IsEventHandled = true
    end
  end
  return IsEventHandled
end

return M
