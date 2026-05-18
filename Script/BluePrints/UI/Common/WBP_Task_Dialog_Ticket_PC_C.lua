require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
end

function M:Destruct()
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.Params = Params
  self.IsShowingTip = false
  self:InitTips(Params.bDifferential)
  self:InitItemList(Params.SubmitId)
  self:BindOnDisplayConfirmed(Params.SubmitId)
end

function M:InitTips(bShow)
  if bShow then
    self.Owner:ShowDialogTip(1)
  else
    self.Owner:HideDialogTip(1)
  end
end

function M:InitItemList(SubmitId)
  self.DisplayItems = {}
  if not SubmitId then
    DebugPrint("展示物品弹窗: SubmitId is nil")
    return
  end
  local SubmitData = DataMgr.QuestTurnInItem[SubmitId]
  if not SubmitData then
    DebugPrint("展示物品弹窗: SubmitData not found for SubmitId", SubmitId)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not SubmitData.ItemIds then
    return
  end
  local DisplayItems = {}
  for i, ItemId in ipairs(SubmitData.ItemIds) do
    local Count = SubmitData.ItemCounts[i] or 1
    local HasCount = Avatar:GetResourceNum(ItemId)
    table.insert(DisplayItems, {
      ItemId = ItemId,
      SourceIndex = i,
      IsEnough = Count <= HasCount
    })
  end
  table.sort(DisplayItems, function(a, b)
    if a.IsEnough ~= b.IsEnough then
      return a.IsEnough
    end
    return a.SourceIndex < b.SourceIndex
  end)
  self.DisplayItems = DisplayItems
  self.DefaultSelectItemIdx = 1
  for i, ItemData in ipairs(DisplayItems) do
    if ItemData.IsEnough then
      self.DefaultSelectItemIdx = i
      break
    end
  end
  self.ItemIdx = self.DefaultSelectItemIdx
  for i, ItemData in ipairs(DisplayItems) do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEnough = ItemData.IsEnough
    
    function Obj.OnClicked(EntryUI, bSelected, bNotPlayAnim)
      self:OnItemClicked(EntryUI, bSelected, bNotPlayAnim)
    end
    
    Obj.ItemIdx = i
    Obj.ItemId = ItemData.ItemId
    Obj.ItemType = "Resource"
    Obj.Parent = self
    Obj.Owner = self.Owner
    self.List_Item:AddItem(Obj)
  end
  self.List_Item:SetControlScrollbarInside(true)
end

function M:OnContentFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and IsValid(self.List_Item) and not self.List_Item:HasAnyUserFocus() and not self.List_Item:HasFocusedDescendants() then
    local CurrentItemIdx = math.max(0, (self.ItemIdx or 1) - 1)
    self.List_Item:NavigateToIndex(CurrentItemIdx)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and IsValid(self.List_Item) and not self.List_Item:HasAnyUserFocus() and not self.List_Item:HasFocusedDescendants() then
    local CurrentItemIdx = math.max(0, (self.ItemIdx or 1) - 1)
    self.List_Item:NavigateToIndex(CurrentItemIdx)
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:PostInitContent(Params, PopupData, Owner)
  self:AddTimer(0.01, function()
    local DefaultIndex = math.max(0, (self.DefaultSelectItemIdx or 1) - 1)
    local DefaultEntryUI = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, DefaultIndex)
    if IsValid(DefaultEntryUI) then
      DefaultEntryUI:RealClicked(true)
    end
    if IsValid(self.List_Item) then
      local CurrentItemIdx = math.max(0, (self.ItemIdx or 1) - 1)
      self.List_Item:NavigateToIndex(CurrentItemIdx)
    end
  end, nil, nil, nil, true)
end

function M:InitGamepadView()
  self:EnterNormalGamepadState()
end

function M:InitKeyboardView()
  self.IsShowingTip = false
  self:HideAllGamepadShortcut()
  self:SetGamepadBtnKeyVisibility(true)
end

function M:EnterNormalGamepadState()
  self.IsShowingTip = false
  self:HideAllGamepadShortcut()
  self.GamepadCheckItemKeyInfo = self:ShowGamepadShortcutBtn({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
      }
    },
    Desc = GText("UI_Controller_CheckItems")
  })
  if IsValid(self.List_Item) then
    local CurrentItemIdx = math.max(0, (self.ItemIdx or 1) - 1)
    self.List_Item:NavigateToIndex(CurrentItemIdx)
  end
  self:SetGamepadBtnKeyVisibility(true)
end

function M:OnItemMenuOpenChanged(IsOpen)
  if not UIUtils.IsGamepadInput() then
    return
  end
  self.IsShowingTip = IsOpen
  if IsOpen then
    self:HideAllGamepadShortcut()
    self:SetGamepadBtnKeyVisibility(false)
  else
    self:HideAllGamepadShortcut()
    self.GamepadCheckItemKeyInfo = self:ShowGamepadShortcutBtn({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.LeftThumb
        }
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
    self:SetGamepadBtnKeyVisibility(true)
  end
end

function M:OnItemClicked(EntryUI, bSelected, bNotPlaySound)
  if IsValid(EntryUI) then
    if bSelected then
      local OldItemIdx = self.ItemIdx
      local NewItemIdx = EntryUI.ItemIdx
      if OldItemIdx and NewItemIdx and OldItemIdx ~= NewItemIdx and IsValid(self.List_Item) then
        local OldEntryUI = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Item, math.max(0, OldItemIdx - 1))
        if IsValid(OldEntryUI) and OldEntryUI ~= EntryUI then
          OldEntryUI:OnCellUnSelect()
        end
      end
      if not bNotPlaySound then
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
      end
      self.ItemId = EntryUI.ItemId
      self.ItemIdx = EntryUI.ItemIdx
    else
      AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_disable", nil, nil)
    end
  end
end

function M:ScrollTicketIntoView(ItemIdx, EntryUI)
  if not IsValid(self.List_Item) then
    return
  end
  local Index = math.max(0, (ItemIdx or 1) - 1)
  self.List_Item:ScrollIndexIntoView(Index)
end

function M:BindOnDisplayConfirmed(SubmitId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_NetDelay"))
    return
  end
  if not Avatar:CheckQuestItemsOwned(SubmitId) then
    return
  end
  local SubmitCallback = self.Params.OnSubmitConfirmed
  local OriginalCallback = self.Owner.RightBtnClickedCallback
  local OriginalPopupData = self.Owner.PopupData
  
  function self.Owner.RightBtnClickedCallback()
    local Data = self.Owner:PackageResult()
    if OriginalCallback then
      OriginalCallback(self.RightBtnCallbackObj, Data, self.Owner)
    end
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_Toast_NetDelay"))
      return
    end
    self.Owner.PopupData = setmetatable({}, {
      __index = self.PopupData
    })
    self.Owner.PopupData.YesButtonForbiddenToast = nil
    self.Owner:ForbidRightBtn(true)
    local SelectedId = self.ItemId
    local SelectedIdx = self.ItemIdx or 1
    local SelectedItem = self.DisplayItems and self.DisplayItems[SelectedIdx]
    local SourceIndex = SelectedItem and SelectedItem.SourceIndex
    SourceIndex = SourceIndex or SelectedIdx
    Avatar:ShowQuestItems(SubmitId, SelectedId, function(Ret)
      if SubmitCallback then
        SubmitCallback(Ret, SourceIndex)
      end
      if true == Ret then
        DebugPrint("DisplayItem: SubmitSuccess")
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_COMMONPOP_1000353_ShowItemSuccess"))
        self.Owner:OnClose()
      else
        self.Owner:ForbidRightBtn(false)
      end
      self.Owner.PopupData = OriginalPopupData
    end)
  end
end

function M:PackageData()
  return {
    ItemIdx = self.ItemIdx and self.DisplayItems and self.DisplayItems[self.ItemIdx] and self.DisplayItems[self.ItemIdx].SourceIndex or self.ItemIdx
  }
end

return M
