require("UnLua")
local WBP_Forging_Convert_Main_C = Class("BluePrints.UI.BP_UIState_C")
local ForgeConst = require("Blueprints.UI.Forge.ForgeConst")
local ForgeModel = require("Blueprints.UI.Forge.ForgeDataModel")
local ControllerFSM = require("Blueprints.UI.ControllerFSM")
WBP_Forging_Convert_Main_C._components = {
  "BluePrints.UI.UI_PC.Common.HorizontalListViewResizeComp",
  "BluePrints.UI.Forge.Convert.WBP_Forging_Convert_Main_GamePadCompoment"
}
local CompendiumState = {NormalPage = 1, FocusSort = 2}

function WBP_Forging_Convert_Main_C:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.KeyboardKeyConfig = {
    [ForgeConst.BottomKeyTypes.BottomKey_Keyboard_Esc] = {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          Owner = self,
          ClickCallback = self.OnClose
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  self.GamepadKeyCofig = {
    [ForgeConst.BottomKeyTypes.BottomKey_Back] = {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonRight,
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    },
    [ForgeConst.BottomKeyTypes.BottomKey_Confirm] = {
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonBottom,
          Owner = self
        }
      },
      Desc = GText("UI_Tips_Ensure")
    }
  }
  self.MaterialSlot = {}
  self:InitListenEvent()
  self:InitUI()
  self:InitKeySetting()
  self:InitTab()
  self:ShowItemDetailsPanel(false)
  self.WBP_Forging_Convert:InitSlider()
  self.EMList:SetScrollbarVisibility(UE4.ESlateVisibility.Collapsed)
  self.EMList:SetControlScrollbarInside(true)
  self:PlayAnimation(self.In)
  self.Com_Tab:PlayInAnim()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "ForgeConvertIn", nil)
end

function WBP_Forging_Convert_Main_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() ~= UE4.ESlateVisibility.Visible then
    if InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.DPadRight then
      IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() == UE4.ESlateVisibility.Visible then
      IsHandled = self:OnGamepadAclick()
    end
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Forging_Convert_Main_C:OnGamepadAclick()
  if self.WBP_Forging_Convert_PopUp_Choose:GetVisibility() == UE4.ESlateVisibility.Visible then
    return false
  end
  if self.WBP_Forging_Convert.WBP_Com_Slider:GetVisibility() ~= UE4.ESlateVisibility.Visible then
    return false
  end
  local Btn = self.WBP_Forging_Convert.WBP_Com_BtnText01
  if Btn and Btn.IsForbidden then
    self.WBP_Forging_Convert:OnConfirmBtnForbidClicked()
    return true
  end
  self.WBP_Forging_Convert:OnConfirmConvertClicked()
  return true
end

function WBP_Forging_Convert_Main_C:OnKeyDown(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  DebugPrint("Yihan@ OnKeyDown", InKey, InKeyName)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  elseif self.KeyDownEvent[InKeyName] then
    self.KeyDownEvent[InKeyName](self)
    IsHandled = true
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Forging_Convert_Main_C:OnKeyUp(MyGeometry, InKeyEvent)
  if CommonUtils:IfExistSystemGuideUI(self) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  DebugPrint("yeke@ OnKeyUp", InKey, InKeyName)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:Handle_KeyUpOnGamePad(InKeyName)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function WBP_Forging_Convert_Main_C:InitUI()
  self.WBP_Forging_Convert_PopUp_Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_Forging_Convert_Main_C:InitListenEvent()
  DebugPrint("Yihan@ InitListenEvent")
  self.EMList.BP_OnItemClicked:Add(self, self.OnEMListItemClicked)
  self.Btn_Close_Tips.OnClicked:Add(self, self.OnBackgroundClicked)
  self.WBP_Forging_Convert_PopUp_Choose:SetConfirmCallback(self, self.UpdateConvertMaterial)
  self.WBP_Forging_Convert:SetClearAllCallback(self, self.ClearAllMaterial)
  self.WBP_Forging_Convert:SetShowChooseUICallback(self, self.ShowChooseUI)
end

function WBP_Forging_Convert_Main_C:InitKeySetting()
  DebugPrint("Yihan@ InitKeySetting")
  self.SwitchTab_LeftKey = "Q"
  self.SwitchTab_RightKey = "E"
  self.EscapeKey = "Escape"
  self.KeyDownEvent = {}
  self.KeyDownEvent[self.EscapeKey] = self.OnReturnKeyDown
  self.KeyDownEvent[self.SwitchTab_LeftKey] = function()
    self.Com_Tab:TabToLeft()
  end
  self.KeyDownEvent[self.SwitchTab_RightKey] = function()
    self.Com_Tab:TabToRight()
  end
end

function WBP_Forging_Convert_Main_C:InitTab()
  local AllTabInfo = {}
  self.TabIdx2DataIdx = {}
  self.TabIdx2TabType = {}
  for i = 1, #DataMgr.RecastingTab do
    table.insert(self.TabIdx2DataIdx, i)
  end
  table.sort(self.TabIdx2DataIdx, function(DataIdx_1, DataIdx_2)
    return DataMgr.RecastingTab[DataIdx_1].Sequence > DataMgr.RecastingTab[DataIdx_2].Sequence
  end)
  for TabIdx = 1, #DataMgr.RecastingTab do
    local DataIdx = self.TabIdx2DataIdx[TabIdx]
    local TabData = DataMgr.RecastingTab[DataIdx]
    self.TabIdx2TabType[TabIdx] = TabData.ProductType
    table.insert(AllTabInfo, {
      Text = GText(TabData.TabName),
      TabId = TabIdx,
      IconPath = TabData.Icon
    })
  end
  local TabConfigData = {
    TitleName = GText("UI_Convert"),
    LeftKey = "Q",
    RightKey = "E",
    StyleName = "Text",
    Tabs = AllTabInfo,
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BackCallback = self.OnClose,
    LastFocusWidget = self.EMList,
    GetReplyOnBack = self:Create_GetReplyOnBack(),
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = self,
    OverridenTopResouces = {101}
  }
  self.Com_Tab:Init(TabConfigData)
  self.Com_Tab:BindEventOnTabSelected(self, self.OnTabItemSelected)
  self.Com_Tab:SelectTab(1)
end

function WBP_Forging_Convert_Main_C:OnTabItemSelected(TabWidget)
  local PrevTabType = self:GetCurrentTabType()
  self.TabIndex = TabWidget.Idx
  self:InitLeftList()
  if self.IsNavigatingToTargetConvert then
    return
  end
  self:ChooseDefault()
  self:NavigateToFirstEntry()
end

function WBP_Forging_Convert_Main_C:NavigateToFirstEntry()
  self:AddTimer(0.2, function()
    if self.IsNavigatingToTargetConvert then
      return
    end
    local ForgeItemWidgets = self.EMList:GetDisplayedEntryWidgets()
    local AllItemsNum = self.EMList:GetNumItems()
    local ForgeItemWidgetsNum = ForgeItemWidgets:Num()
    local MinIndex = -1
    for Index = 1, ForgeItemWidgetsNum do
      local Entry = ForgeItemWidgets:GetRef(Index)
      local EntryIndex = self.EMList:GetIndexForItem(Entry.Content)
      if -1 ~= EntryIndex then
        if -1 == MinIndex then
          MinIndex = EntryIndex
        else
          MinIndex = math.min(MinIndex, EntryIndex)
        end
      end
    end
    MinIndex = math.clamp(MinIndex, 0, AllItemsNum - 1)
    if not CommonUtils:IfExistSystemGuideUI(self) then
      self.EMList:NavigateToIndex(MinIndex)
      self.EMList:SetFocus()
    end
  end)
end

function WBP_Forging_Convert_Main_C:GetCurrentTabType()
  local TabType = self.TabIdx2TabType[self.TabIndex]
  return TabType
end

function WBP_Forging_Convert_Main_C:InitLeftList()
  DebugPrint("Yihan@ InitLeftList")
  local ConvertData = DataMgr.Convert
  if not ConvertData then
    return
  end
  local sortHelper = {}
  local TabType = self:GetCurrentTabType()
  for id, Data in pairs(ConvertData) do
    local ProductId
    if "All" == TabType or Data.ProductTipsType == TabType then
      if Data.ProductType == CommonConst.ArmoryType.Mod then
        ProductId = Data.ModConvertResource
      else
        ProductId = Data.ProductId
      end
      if ProductId then
        table.insert(sortHelper, {id = id, Data = Data})
      end
    end
  end
  table.sort(sortHelper, function(a, b)
    return a.Data.SortPriority > b.Data.SortPriority
  end)
  self.EMList:ClearListItems()
  for Index, item in ipairs(sortHelper) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Position = Index
    Content.Idx = item.id
    Content.bActivate = true
    Content.bGolden = false
    Content.ItemData = item.Data
    Content.ConvertId = item.id
    local ResourceId, ItemType, ProductType
    if Content.ItemData.ProductType == CommonConst.ArmoryType.Mod then
      ResourceId = Content.ItemData.ModConvertResource
    else
      ResourceId = Content.ItemData.ProductId
    end
    local ResourceData = DataMgr.Resource[ResourceId]
    Content.Id = ResourceId
    Content.ItemType = "Resource"
    Content.ProductType = item.Data.ProductType
    Content.Rarity = ResourceData.Rarity
    Content.Icon = ResourceData.Icon
    Content.NotInteractive = true
    Content.ResourceName = ResourceData.ResourceName
    Content.ResourseCount = self:GetHaveCount(ResourceId)
    Content.Parent = self
    Content.IsNew = self:ItemIsNew(item.id)
    self.EMList:AddItem(Content)
  end
end

function WBP_Forging_Convert_Main_C:ItemIsNew(ConvertId)
  local ConvertReddotDetails = ReddotManager.GetLeafNodeCacheDetail("ForgeConvert")
  for _, Details in pairs(ConvertReddotDetails) do
    if ConvertId == Details.Id and Details.IsClicked then
      return false
    end
  end
  return true
end

function WBP_Forging_Convert_Main_C:GetHaveCount(ResourceId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 0
  end
  return Avatar:GetResourceNum(ResourceId)
end

function WBP_Forging_Convert_Main_C:RefreshItemDetails()
  if self.CurItemDetails ~= self.CurListItem or not self.bItemDetailsShowed then
    self.CurItemDetails = self.CurListItem
    self:ShowItemDetailsPanel(true)
    local ItemDetailParam = {}
    ItemDetailParam.ItemId = self.CurListItem.Id
    ItemDetailParam.ItemType = self.CurListItem.ItemType
    ItemDetailParam.bHideGamePad = false
    self.Tips_Item:PlayAnimation(self.Tips_Item.Change)
    self.Tips_Item:RefreshItemInfo(ItemDetailParam, false)
  end
end

function WBP_Forging_Convert_Main_C:OnBackgroundClicked()
  if self.bItemDetailsShowed then
    self:ShowItemDetailsPanel(false)
  end
end

function WBP_Forging_Convert_Main_C:UpdateConvertMaterial(ChoosedTbl, IsShow)
  self.WBP_Forging_Convert:UpdateMaterialSlot(ChoosedTbl, IsShow)
  self.WBP_Forging_Convert:UpdateBottomState(ChoosedTbl)
  self.WBP_Forging_Convert:InitSliderValue()
end

function WBP_Forging_Convert_Main_C:ClearAllMaterial()
  self.WBP_Forging_Convert:InitMaterialSlot()
  self.WBP_Forging_Convert_PopUp_Choose:InitAll(self.CurListItem)
end

function WBP_Forging_Convert_Main_C:ShowChooseUI(ChoosedMaterialTbl)
  DebugPrint("Yihan@ WBP_Forging_Convert_C:ShowChooseUI", ChoosedMaterialTbl)
  self.WBP_Forging_Convert_PopUp_Choose:ShowChooseUI(true)
  DebugPrint("Yihan@ WBP_Forging_Convert_PopUp_Choose_C:ShowChooseUI", self.CurListItem.Idx)
  self.WBP_Forging_Convert_PopUp_Choose:ShowAllMaterial(self.CurListItem, ChoosedMaterialTbl)
end

function WBP_Forging_Convert_Main_C:SelectEMListItem(Item)
  if not Item then
    return
  end
  DebugPrint("Yihan@ WBP_Forging_Convert_C:SelectEMListItem", Item)
  if self.WBP_Forging_Convert.bInMixAnimation or self.CurListItem == Item then
    return
  end
  self.WBP_Forging_Convert:UpdateForingConvertContent(Item)
  self.WBP_Forging_Convert:InitMaterialSlot()
  self.WBP_Forging_Convert:ClearMergeTbl()
  self.WBP_Forging_Convert_PopUp_Choose:InitAll(Item)
  self.WBP_Forging_Convert:UpdateBottomState({})
  local CurWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(Item))
  if self:ItemIsNew(Item.Idx) then
    local ConvertReddotDetails = ReddotManager.GetLeafNodeCacheDetail("ForgeConvert")
    for _, Details in pairs(ConvertReddotDetails) do
      if Item.Idx == Details.Id then
        Details.IsClicked = true
      end
    end
    ReddotManager.DecreaseLeafNodeCount("ForgeConvert")
    if CurWidget then
      Item.IsNew = false
      CurWidget:SetNewIcon(Item.IsNew)
    end
  end
  if CurWidget then
    CurWidget:SetSelected(true)
  end
  Item.IsSelect = true
  if self.CurListItem then
    local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(self.CurListItem))
    if PrevWidget then
      PrevWidget:SetSelected(false)
    end
    self.CurListItem.IsSelect = false
  end
  self.EMList:BP_ClearSelection()
  self.EMList:BP_SetItemSelection(Item, true)
  self.CurListItem = Item
  return true
end

function WBP_Forging_Convert_Main_C:OnEMListItemClicked(Item)
  if not self:SelectEMListItem(Item) then
    return
  end
  AudioManager(self):PlayItemSound(self, Item.Id, "Click", Item.ItemType)
end

function WBP_Forging_Convert_Main_C:OnClose()
  DebugPrint("Yihan@ OnClose")
  if self:IsAnimationPlaying(self.In) or self.WBP_Forging_Convert.bInMixAnimation then
    return
  end
  if self.IsClosing then
    return
  end
  if self.bItemDetailsShowed then
    self:ShowItemDetailsPanel(false)
  else
    self.IsClosing = true
    self:PlayAnimation(self.Out)
    self:ClearChoosedState()
    ForgeModel:ClearConvertNewRedDots()
    AudioManager(self):SetEventSoundParam(self, "ForgeConvertIn", {ToEnd = 1})
  end
end

function WBP_Forging_Convert_Main_C:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  end
end

function WBP_Forging_Convert_Main_C:ChooseDefault()
  local ListItems = self.EMList:GetListItems()
  if ListItems:Num() <= 0 then
    return
  end
  local ListItem = ListItems:GetRef(1)
  self:SelectEMListItem(ListItem)
end

function WBP_Forging_Convert_Main_C:ClearChoosedState()
  local ListItems = self.EMList:GetListItems()
  local ListItemsNum = ListItems:Num()
  for i = 1, ListItemsNum do
    local ListItem = ListItems:GetRef(i)
    local PrevWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.EMList, self.EMList:GetIndexForItem(ListItem))
    if PrevWidget then
      PrevWidget:SetSelected(false)
    end
    self.CurListItem.IsSelect = false
  end
end

function WBP_Forging_Convert_Main_C:ShowItemDetailsPanel(bIsShow)
  if bIsShow then
    self.Tips_Item:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Btn_Close_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
    self.bItemDetailsShowed = true
    self.Tips_Item.ParentWidget = self
    if UIUtils.IsGamepadInput() then
      self.Tips_Item:SetFocus()
      self:UpdateGamePadUIOnTipsChanged(true)
      self:UpdateGamepadBottomKeyInfo({
        ForgeConst.BottomKeyTypes.BottomKey_Back
      })
    end
  else
    self.Tips_Item:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.Btn_Close_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.WBP_Forging_Convert.Shop:PlayerUnHoverAnimation()
    self.bItemDetailsShowed = false
    if UIUtils.IsGamepadInput() then
      self:UpdateGamePadUIOnTipsChanged(false)
      self:SetFocus_Lua()
      self:EnterState_Normal()
    end
  end
end

function WBP_Forging_Convert_Main_C:InitUsedByJumpPage()
  self:InitUI()
  self:InitLeftList()
  self:ShowItemDetailsPanel(false)
  self:AddTimer(0.01, function()
    self:ChooseDefault()
    self:RemoveTimer("TimeToLoadList")
  end, false, 0, "TimeToLoadList")
end

function WBP_Forging_Convert_Main_C:OnReturnKeyDown()
  self:OnClose()
end

function WBP_Forging_Convert_Main_C:NavigateToTab(TabIndex)
  if self.TabIndex == TabIndex then
    return
  end
  self.Com_Tab:SelectTab(TabIndex)
end

function WBP_Forging_Convert_Main_C:CancelNavigateToTargetConvert()
  if self.NavigateToTargetConvertTimer then
    self:RemoveTimer(self.NavigateToTargetConvertTimer)
    self.NavigateToTargetConvertTimer = nil
  end
  if self.NavigateToTargetConvertFocusTimer then
    self:RemoveTimer(self.NavigateToTargetConvertFocusTimer)
    self.NavigateToTargetConvertFocusTimer = nil
  end
  self.TargetConvertId = nil
  self.IsNavigatingToTargetConvert = false
end

function WBP_Forging_Convert_Main_C:NavigateToTargetConvert(ConvertId)
  ConvertId = tonumber(ConvertId) or ConvertId
  if not DataMgr.Convert or not DataMgr.Convert[ConvertId] then
    DebugPrint("NavigateToTargetConvert：找不到ConvertId", ConvertId)
    return false
  end
  self.WBP_Forging_Convert:ClearMergeTbl()
  self:ClearAllMaterial()
  self.WBP_Forging_Convert:UpdateBottomState({})
  self.WBP_Forging_Convert:InitSliderValue()
  self.WBP_Forging_Convert:UpdateTextPanel()
  self:ShowItemDetailsPanel(false)
  self.WBP_Forging_Convert_PopUp_Choose:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:CancelNavigateToTargetConvert()
  self.TargetConvertId = ConvertId
  self.IsNavigatingToTargetConvert = true
  self:NavigateToTab(1)
  self.NavigateToTargetConvertTimer = self:AddTimer(0.3, function()
    self.NavigateToTargetConvertTimer = nil
    if not self.IsNavigatingToTargetConvert then
      return
    end
    local ListItems = self.EMList:GetListItems()
    local ListItemsNum = ListItems:Num()
    local TargetObject
    local TargetIndex = -1
    for i = 1, ListItemsNum do
      local ListItem = ListItems:GetRef(i)
      if ListItem.ConvertId == ConvertId or ListItem.Idx == ConvertId then
        TargetObject = ListItem
        TargetIndex = i - 1
        break
      end
    end
    if not TargetObject then
      self:CancelNavigateToTargetConvert()
      self:ChooseDefault()
      self:NavigateToFirstEntry()
      return
    end
    local IsGamepad = UIUtils.IsGamepadInput()
    if IsGamepad then
      self.EMList:NavigateToIndex(TargetIndex)
    else
      self.EMList:ScrollIndexIntoView(TargetIndex)
    end
    self:SelectEMListItem(TargetObject)
    self.NavigateToTargetConvertFocusTimer = self:AddTimer(0.1, function()
      self.NavigateToTargetConvertFocusTimer = nil
      if not self.IsNavigatingToTargetConvert then
        return
      end
      local CurrentIndex = self.EMList:GetIndexForItem(TargetObject)
      if IsGamepad and CurrentIndex >= 0 then
        self.EMList:NavigateToIndex(CurrentIndex)
        self.EMList:SetFocus()
      end
      self.TargetConvertId = nil
      self.IsNavigatingToTargetConvert = false
    end)
  end)
  return true
end

function WBP_Forging_Convert_Main_C:Destruct()
  DebugPrint("Yihan@ WBP_Forging_Convert_Main_C Destruct")
  self:CancelNavigateToTargetConvert()
end

AssembleComponents(WBP_Forging_Convert_Main_C)
return WBP_Forging_Convert_Main_C
