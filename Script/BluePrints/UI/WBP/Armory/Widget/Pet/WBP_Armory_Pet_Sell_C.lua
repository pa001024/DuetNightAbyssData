require("UnLua")
local BagSell = require("BluePrints.UI.WBP.Bag.Widget.WBP_Bag_Sell_View_C")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local insert = table.insert
local ipairs = _ENV.ipairs
local M = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.UI.WBP.Bag.Widget.WBP_Bag_Sell_View_C"
})

function M:Initialize(Initializer)
  BagSell.Initialize(self, Initializer)
  self.bReconcilingSelection = false
end

function M:Init(Parent)
  BagSell.OnLoaded(self, Parent, nil, Parent.OnSelectedPetRemoved, nil, nil, BagCommon.BagItemSelectOpMode.ResolveMode)
  self:AddInputMethodChangedListen()
  self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
end

function M:InitListenEvent()
end

function M:RefreshBaseInfo()
  self.ItemBox:ClearChildren()
  local OverflowBox = self.ItemBox_Overflow or self.ItemBox_overflow
  OverflowBox:ClearChildren()
  self.Panel_KeyCount:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Overflow:SetVisibility(UIConst.VisibilityOp.Collapsed)
  OverflowBox:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Select:SetText(GText("UI_Bag_Sell_Select"))
  self.Text_Empty:SetText(GText("UI_Pet_Decompose_NotChoose"))
  self.Button_Purchase:SetText(GText("UI_Pet_DecomposeBtn"))
  self.Button_Purchase:SetGamePadImg("Y")
  
  function self.Button_Purchase.ForbidSoundFunc()
  end
  
  self.Button_Purchase:BindEventOnClicked(self, self.TryToResolveStuff)
  self.Button_List:BindEventOnClicked(self, self.ClickToOpenStuffList)
  self.Back_Area.OnClicked:Add(self, self.ClickToOpenStuffList)
  self.Btn_Back:BindEventOnClicked(self.ParentWidget, self.ParentWidget.BeginExitDecomposeMode)
  self.List_Item.BP_OnEntryInitialized:Add(self, self.OnPetEntryInitialized)
  self.List_Item.BP_OnItemClicked:Add(self, self.OnPetMinusClicked)
  self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnSelectStuffItemChanged)
  if self.Key_Check then
    self.Key_Check:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      }
    })
    self.Key_View:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      }
    })
  end
  self.Panel_Sell_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:RefreshRewardInfo()
  self:RefreshKeyCount()
end

function M:FillWithWeaponResolveData(Pet)
  if self.NeedDealWithStuffData[Pet.UniqueId] then
    return
  end
  local Content = ArmoryUtils:NewPetItemContentWithEntry(Pet)
  Content.bAllUseAsyncLoadWidget = false
  Content.bMinus = true
  Content.RedDotType = nil
  Content.GridIndex = self.CurStuffCountInList + 1
  self.NeedDealWithStuffData[Content.Uuid] = Content
  self.NeedDealWithStuffCount[Content.Uuid] = 1
  self.List_Item:AddItem(Content)
  self.CurStuffCountInList = self.CurStuffCountInList + 1
end

function M:ReconcilePetSelection(SelectedIds)
  local Contents = {}
  local Removed = false
  for Index = 0, self.List_Item:GetNumItems() - 1 do
    local Content = self.List_Item:GetItemAt(Index)
    if SelectedIds[Content.Uuid] then
      insert(Contents, Content)
    else
      Removed = true
      Content.IsSelect = false
      self.NeedDealWithStuffData[Content.Uuid] = nil
      self.NeedDealWithStuffCount[Content.Uuid] = nil
      self.AllTypeRewardsInfo[Content.Uuid] = nil
    end
  end
  if not Removed then
    return
  end
  local Current = self.CurSelectStuffContentInList
  if not Current or not SelectedIds[Current.Uuid] then
    Current = Contents[1]
  end
  local ScrollOffset = self.List_Item:GetScrollOffset()
  self.bReconcilingSelection = true
  self.CurStuffCountInList = #Contents
  self.CurSelectStuffContentInList = Current
  self.CurSelectGridIndex = nil
  self.List_Item:ClearListItems()
  for Index, Content in ipairs(Contents) do
    Content.GridIndex = Index
    Content.IsSelect = Content == Current
    if Content.IsSelect then
      self.CurSelectGridIndex = Index
    end
    self.List_Item:AddItem(Content)
  end
  if Current then
    self.List_Item:BP_SetSelectedItem(Current)
  end
  self.List_Item:BP_CancelScrollIntoView()
  self.List_Item:SetScrollOffset(ScrollOffset)
  self.bReconcilingSelection = false
end

function M:OnSelectStuffItemChanged(SelectItem, bIsSelect)
  if self.bReconcilingSelection then
    return
  end
  BagSell.OnSelectStuffItemChanged(self, SelectItem, bIsSelect)
end

function M:OnPetEntryInitialized(Content, Widget)
  Widget:SetItemMinus(true)
  if Widget.MinusWidget then
    Widget.MinusWidget.Btn_Minus:BindSingleEventOnClicked(self, self.OnPetMinusClicked, Content)
  end
end

function M:OnPetMinusClicked(Content)
  if self.ParentWidget:IsBusy() then
    return
  end
  self:RemoveBagItemInList(Content.Uuid)
  self:RefreshKeyCount()
end

function M:RefreshRewardInfo()
  self.AllRewardContentList = {}
  for _, Reward in ipairs(self.ParentWidget.PreviewRewards or {}) do
    local ItemType = Reward.StuffType
    local ItemId = Reward.StuffId
    local ItemData = DataMgr[ItemType] and DataMgr[ItemType][ItemId]
    if ItemData and Reward.Count and Reward.Count > 0 then
      insert(self.AllRewardContentList, {
        Id = ItemId,
        Icon = Reward.StuffIcon,
        ParentWidget = self,
        ItemType = ItemType,
        Rarity = Reward.Rarity or 0,
        IsShowDetails = true,
        UIName = BagCommon.BagStuffSelectUIName,
        Count = Reward.Count
      })
    end
  end
  local AllChildren = self.ItemBox:GetAllChildren()
  for Index, Content in ipairs(self.AllRewardContentList) do
    local Widget = self.ItemBox:GetChildAt(Index - 1)
    if not Widget then
      Widget = UIManager(self):_CreateWidgetNew("ComItemUniversalS")
      self.ItemBox:AddChild(Widget)
    end
    Widget:Init(Content)
    Widget:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  for Index = #self.AllRewardContentList + 1, AllChildren:Length() do
    local Widget = self.ItemBox:GetChildAt(Index - 1)
    if Widget then
      Widget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  local HasReward = #self.AllRewardContentList > 0
  self.Text_Total:SetText(GText("UI_Bag_Decompose_Expect"))
  self.Text_Total:SetVisibility(HasReward and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Panel_Total:SetVisibility(HasReward and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if HasReward then
    self:SetNavigationRuleForRewardItem(#self.AllRewardContentList)
  end
  self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
end

function M:RefreshKeyCount()
  self.Num_Select:SetText(tostring(self.CurStuffCountInList))
  self.Num_Select_Max:SetText(tostring(self.ParentWidget.TotalPetCount))
  self.Button_Purchase:ForbidBtn(not self.ParentWidget:CanSubmit())
  self.Panel_Empty:SetVisibility(0 == self.CurStuffCountInList and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:TryToResolveStuff()
  if self.ParentWidget:CanSubmit() then
    self.ParentWidget:TryConfirmDecompose()
  end
end

function M:ClickToOpenStuffList()
  if self.ParentWidget:IsBusy() or self:IsAnimationPlaying(self.OpenList) or self:IsAnimationPlaying(self.CloseList) then
    return
  end
  if self.bIsOpenList then
    self.bIsOpenList = false
    self.ParentWidget:SetFocus_Lua()
    self:UnbindAllFromAnimationFinished(self.CloseList)
    self:BindToAnimationFinished(self.CloseList, {
      self,
      function()
        self.List_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
        self.Panel_Sell_List:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
    })
    self:PlayAnimationForward(self.CloseList)
  elseif self.CurStuffCountInList > 0 then
    self.List_Item:SetVisibility(UIConst.VisibilityOp.Visible)
    self.Panel_Sell_List:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self:UnbindAllFromAnimationFinished(self.OpenList)
    self:BindToAnimationFinished(self.OpenList, {
      self,
      function()
        self.bIsOpenList = true
        self:SetFocus_Lua()
      end
    })
    self:PlayAnimationForward(self.OpenList)
  end
end

function M:PlayOutAnim()
  self.bIsOpenList = self.bIsOpenList or self:IsAnimationPlaying(self.OpenList)
  self:UnbindAllFromAnimationFinished(self.OpenList)
  self:StopAnimation(self.OpenList)
  BagSell.PlayOutAnim(self)
end

function M:SetFocus_Lua()
  if self.bIsOpenList and self.CurStuffCountInList > 0 then
    local Content = self.CurSelectStuffContentInList or self.List_Item:GetItemAt(0)
    self.List_Item:BP_CancelScrollIntoView()
    self.List_Item:BP_SetSelectedItem(Content)
    self.List_Item:BP_NavigateToItem(Content)
    self.List_Item:SetFocus()
  else
    self.ParentWidget:SetFocus_Lua()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  return self.ParentWidget:OnKeyDown(MyGeometry, InKeyEvent)
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  return UIUtils.UnHandled
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:UpdateUIStyleInPlatform(CurInputType == ECommonInputType.Gamepad)
end

function M:UpdateUIStyleInPlatform(IsUseGamePad)
  if self.Key_View then
    self.Key_View:SetVisibility(IsUseGamePad and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    self.Key_Check:SetVisibility(IsUseGamePad and #self.AllRewardContentList > 0 and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:Close()
  self.ParentWidget:FinishClose()
end

function M:Destruct()
  self.bReconcilingSelection = false
  self:RemoveInputMethodChangedListen()
  M.Super.Destruct(self)
end

return M
