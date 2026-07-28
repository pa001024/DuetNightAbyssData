require("UnLua")
require("Utils.UIUtils")
require("DataMgr")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local SortType = {Name = 1, ConsumeValue = 2}
local SortTexts = {
  GText("UI_ComponentName"),
  GText("UI_ConsumptionValue")
}

function M:Construct()
  self.bIsFocusable = true
end

function M:Init(Parent)
  self.Parent = Parent
  self.SearchText = ""
  self.ComponentItems = {}
  self.SelectedItemData = nil
  self.SelectedItemWidget = nil
  self.Text_Title:SetText(GText("UI_ComponentList"))
  self.Text_Cost:SetText(GText("UI_PerformanceCost"))
  self.Text_Name:SetText(GText("UI_ComponentName"))
  self.Text_CostNum:SetText(GText("UI_ConsumptionValue"))
  self:InitSort()
  self:InitInput()
  self:InitGamepad()
  self:AddInputMethodChangedListen()
  self:RefreshList(true)
end

function M:GetZOrder()
  return self.Parent:GetZOrder()
end

function M:InitSort()
  if not self.Sort then
    return
  end
  self.Sort:Init(self, SortTexts, CommonConst.ASC, {
    OnListClosed = function()
      self.Input:SetGamePadKey("X", "RS")
    end,
    OnListOpened = function()
      self.Input:SetGamePadKey()
    end,
    OnGetBackFocusWidget = function()
      return self:BP_GetDesiredFocusTarget()
    end
  })
  self.Sort:BindEventOnSelectionsChanged(self, self.OnSortChanged)
  self.Sort:BindEventOnSortTypeChanged(self, self.OnSortChanged)
  if self.Sort.SetGamepadKey then
    self.Sort:SetGamepadKey("LS")
  end
end

function M:InitInput()
  if not self.Input then
    return
  end
  rawset(self.Input, "CursorLineIdx", self.Input.CursorLineIdx or 0)
  rawset(self.Input, "CursorOffset", self.Input.CursorOffset or 0)
  self.Input:Init({
    Owner = self,
    HintText = GText("UI_Search"),
    TextLimit = 20,
    Events = {
      OnTextChanged = self.OnSearchTextChanged,
      OnTextCommitted = self.OnSearchTextCommitted
    }
  })
  self.Input:SetGamePadKey("X", "RS")
end

function M:InitGamepad()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self:SetFocus()
  self.CurInputDevice = UIUtils.UtilsGetCurrentInputType()
  if self.Controller_Confirm then
    self.Controller_Confirm:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "A",
          Pwner = self
        }
      },
      Desc = GText("UI_Tips_Ensure")
    })
  end
  if self.Controller_Back then
    self.Controller_Back:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          Pwner = self
        }
      },
      Desc = GText("UI_BACK")
    })
  end
  self:UpdateUIStyleInPlatform()
  self.Com_Empty.bIsFocusable = true
  self.Com_Empty:SetIsShowNavigateGuide(false)
  self.Com_Empty:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Com_Empty:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Component:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Component:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
end

function M:RefreshUI()
  self:RefreshList(true)
  self.List_Component:SetFocus()
end

function M:OnSearchTextChanged(Text)
  self.SearchText = Text or ""
  self:RefreshList(false)
end

function M:OnSearchTextCommitted(Text)
  if self.SearchText == Text then
    return
  end
  self.SearchText = Text or ""
  self:RefreshList(true)
end

function M:OnSortChanged()
  self:RefreshList(true)
end

function M:BP_GetDesiredFocusTarget()
  if self.FocusItemWidget then
    return self.FocusItemWidget
  end
  if 0 == self.WS_List:GetActiveWidgetIndex() then
    return self.List_Component
  end
  return self.Com_Empty
end

function M:OpenSortByGamepad()
  if not self.Sort then
    return
  end
  self.Sort:SetFocus()
  self.Sort:ListOpenBtnClicked()
end

function M:FocusInputByGamepad()
  if not self.Input then
    return
  end
  self.Input:SetFocus()
  if self.Input.FocusInputField then
    self.Input:FocusInputField()
  end
end

function M:ClearSearchByGamepad()
  self.SearchText = ""
  if self.Input then
    if self.Input.OnDeleteBtnClicked then
      self.Input:OnDeleteBtnClicked()
    elseif self.Input.ClearText then
      self.Input:ClearText()
    else
      self.Input:SetText("")
    end
  else
    self:RefreshList(false)
  end
end

function M:CloseByGamepad()
  self.Parent:CloseSidePanel()
end

function M:GetFallbackComponentItems()
  return {
    {
      UnitId = 900001,
      ActorId = "TestComponent_001",
      Name = "石块1",
      ConsumeValue = 120
    },
    {
      UnitId = 900002,
      ActorId = "TestComponent_002",
      Name = "石块2",
      ConsumeValue = 80
    },
    {
      UnitId = 900003,
      ActorId = "TestComponent_003",
      Name = "悬挂灯组",
      ConsumeValue = 35
    },
    {
      UnitId = 900005,
      ActorId = "TestComponent_005",
      Name = "盆栽组合",
      ConsumeValue = 20
    }
  }
end

function M:GetGuildManager()
  if self.Parent and self.Parent.GuildManager then
    return self.Parent.GuildManager
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode and GameMode.GetGuildConstructManager then
    return GameMode:GetGuildConstructManager()
  end
end

function M:GetPlacedActorStates()
  local GuildManager = self:GetGuildManager()
  if not GuildManager then
    return nil
  end
  local StateGetters = {
    "GetAllActorStates",
    "GetActorStates",
    "GetAllConstructActorStates",
    "GetPlacedActorStates"
  }
  for _, FuncName in ipairs(StateGetters) do
    local Func = GuildManager[FuncName]
    if Func then
      local States = Func(GuildManager)
      if States then
        return States
      end
    end
  end
  local IdGetters = {
    "GetAllActorIds",
    "GetActorIds",
    "GetPlacedActorIds"
  }
  for _, FuncName in ipairs(IdGetters) do
    local Func = GuildManager[FuncName]
    if Func then
      local ActorIds = Func(GuildManager)
      if ActorIds then
        local States = {}
        local IdList = ActorIds.ToTable and ActorIds:ToTable() or ActorIds
        for _, ActorId in pairs(IdList) do
          local ActorState, bOK = GuildManager:GetActorState(ActorId)
          if false ~= bOK and ActorState then
            table.insert(States, ActorState)
          end
        end
        return States
      end
    end
  end
end

function M:GetConsumeValue(UnitId, GuildItemData)
  if not GuildItemData then
    return 0
  end
  return GuildItemData.PerformanceCost or GuildItemData.PerformanceValue or GuildItemData.Performance or GuildItemData.Cost or GuildItemData.PerformanceCost or 0
end

function M:BuildItemData(ActorState)
  if not ActorState or not ActorState.UnitId then
    return nil
  end
  local UnitId = ActorState.UnitId
  local GuildItemData = DataMgr.GuildItem and DataMgr.GuildItem[UnitId]
  if not GuildItemData then
    return nil
  end
  return {
    UnitId = UnitId,
    ActorId = ActorState.ActorId or ActorState.Guid or ActorState.Id,
    Name = GuildItemData.Name,
    ConsumeValue = self:GetConsumeValue(UnitId, GuildItemData)
  }
end

function M:GetComponentItems()
  local Items
  if self.Parent and self.Parent.GetComponentListItems then
    Items = self.Parent:GetComponentListItems()
  end
  if not Items then
    local ActorStates = self:GetPlacedActorStates()
    if ActorStates then
      Items = {}
      local StateList = ActorStates.ToTable and ActorStates:ToTable() or ActorStates
      for _, ActorState in pairs(StateList) do
        local ItemData = self:BuildItemData(ActorState)
        if ItemData then
          table.insert(Items, ItemData)
        end
      end
    end
  end
  local NormalizedItems = self:NormalizeComponentItems(Items or {})
  if #NormalizedItems <= 0 then
    return self:NormalizeComponentItems(self:GetFallbackComponentItems())
  end
  return NormalizedItems
end

function M:NormalizeComponentItems(ComponentItems)
  local Items = {}
  local ItemList = ComponentItems.ToTable and ComponentItems:ToTable() or ComponentItems
  for _, ItemData in pairs(ItemList or {}) do
    local NormalizedItem = self:NormalizeItemData(ItemData)
    if NormalizedItem then
      NormalizedItem.SortIndex = #Items + 1
      table.insert(Items, NormalizedItem)
    end
  end
  return Items
end

function M:NormalizeItemData(ItemData)
  if not ItemData then
    return nil
  end
  if ItemData.UnitId and (not ItemData.Name or ItemData.ConsumeValue == nil) then
    local GuildItemData = DataMgr.GuildItem and DataMgr.GuildItem[ItemData.UnitId]
    ItemData.Name = ItemData.Name or GuildItemData and GuildItemData.Name or ""
    ItemData.ConsumeValue = ItemData.ConsumeValue or self:GetConsumeValue(ItemData.UnitId, GuildItemData)
  end
  ItemData.Name = ItemData.Name or ""
  ItemData.ConsumeValue = tonumber(ItemData.ConsumeValue) or 0
  return ItemData
end

function M:MatchSearch(ItemData)
  if not self.SearchText or self.SearchText == "" then
    return true
  end
  local Name = ItemData.Name or ""
  if CommonUtils and CommonUtils.CheckFuzzySearchWithSinglePhase then
    return CommonUtils.CheckFuzzySearchWithSinglePhase({Name}, self.SearchText, false)
  end
  return string.find(Name, self.SearchText, 1, true) ~= nil
end

function M:GetFilteredItems(ComponentItems)
  local FilteredItems = {}
  for _, ItemData in ipairs(ComponentItems or {}) do
    if self:MatchSearch(ItemData) then
      table.insert(FilteredItems, ItemData)
    end
  end
  return FilteredItems
end

function M:SortItems(ComponentItems)
  if not self.Sort then
    return
  end
  local SortBy, CurSortType = self.Sort:GetSortInfos()
  local bAsc = CurSortType == CommonConst.ASC
  table.sort(ComponentItems, function(A, B)
    if SortBy == SortType.ConsumeValue then
      if A.ConsumeValue ~= B.ConsumeValue then
        if bAsc then
          return A.ConsumeValue < B.ConsumeValue
        end
        return A.ConsumeValue > B.ConsumeValue
      end
    else
      local NameA = tostring(A.Name or "")
      local NameB = tostring(B.Name or "")
      if NameA ~= NameB then
        if bAsc then
          return NameA < NameB
        end
        return NameA > NameB
      end
    end
    local UnitIdA = tonumber(A.UnitId) or 0
    local UnitIdB = tonumber(B.UnitId) or 0
    if UnitIdA ~= UnitIdB then
      return UnitIdA < UnitIdB
    end
    return (A.SortIndex or 0) < (B.SortIndex or 0)
  end)
end

function M:RefreshEmptyState(ShowCount)
  if ShowCount > 0 then
    self.WS_List:SetActiveWidgetIndex(0)
    return
  end
  self.WS_List:SetActiveWidgetIndex(1)
  if self.SearchText and self.SearchText ~= "" then
    self.Text_Empty:SetText(GText("UI_ComponentNotFound"))
  else
    self.Text_Empty:SetText(GText("UI_BAG_EMPTY"))
  end
end

function M:RefreshCost(ComponentItems)
  local ConsumeValue = 0
  for _, ItemData in ipairs(ComponentItems or {}) do
    ConsumeValue = ConsumeValue + (ItemData.ConsumeValue or 0)
  end
  local TotalValue = self:GetTotalConsumeValueLimit()
  self.Text_Now:SetText(ConsumeValue)
  self.Text_Total:SetText(TotalValue)
  if self.Text_Now.SetColorAndOpacity and self.Color_Red and ConsumeValue >= TotalValue then
    self.Text_Now:SetColorAndOpacity(self.Color_Red)
  elseif self.Text_Now.SetColorAndOpacity and self.Color_Orange then
    self.Text_Now:SetColorAndOpacity(self.Color_Orange)
  end
end

function M:GetTotalConsumeValueLimit()
  if self.Parent and self.Parent.GetTotalConsumeValueLimit then
    return self.Parent:GetTotalConsumeValueLimit()
  end
  local GuildManager = self:GetGuildManager()
  if GuildManager and GuildManager.GetPerformanceLimit then
    return GuildManager:GetPerformanceLimit()
  end
  return 60000
end

function M:OnComponentItemClicked(ItemData, ItemWidget, IsSelected)
  if self.SelectedItemWidget and self.SelectedItemWidget ~= ItemWidget then
    self.SelectedItemWidget:SetExpanded(false)
  end
  self.SelectedItemData = IsSelected and ItemData
  self.SelectedItemWidget = IsSelected and ItemWidget
end

function M:OnComponentFocusChanged(ItemWidget)
  if self.FocusItemWidget and self.FocusItemWidget ~= ItemWidget then
    self.FocusItemWidget:PlayItem_UnHover()
  end
  self.FocusItemWidget = ItemWidget
  self.FocusItemWidget:PlayItem_Hover()
end

function M:OnComponentTakeBackClicked(ItemData)
  if self.Parent and self.Parent.OnComponentTakeBackClicked then
    self.Parent:OnComponentTakeBackClicked(ItemData)
  else
    ScreenPrint("组件收回接口未接入：" .. tostring(ItemData and ItemData.Name or ""))
  end
end

function M:OnComponentEditClicked(ItemData)
  if self.Parent and self.Parent.OnComponentEditClicked then
    ScreenPrint("当前为测试数据：无法编辑")
    return
  end
  if self.Parent and self.Parent.CloseSidePanel then
    self.Parent:CloseSidePanel()
  end
  if self.Parent and self.Parent.SelectActor and ItemData and ItemData.ActorId then
    self.Parent:SelectActor(ItemData.ActorId)
  end
end

function M:RefreshList()
  self.FocusItemWidget = nil
  self.List_Component:ClearListItems()
  self.ComponentItems = self:GetComponentItems()
  self:RefreshCost(self.ComponentItems)
  local ShowItems = self:GetFilteredItems(self.ComponentItems)
  self:SortItems(ShowItems)
  for _, ItemData in ipairs(ShowItems) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ItemData = ItemData
    Content.UnitId = ItemData.UnitId
    Content.Parent = self
    self.List_Component:AddItem(Content)
  end
  self:RefreshEmptyState(#ShowItems)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if not self:IsVisible() then
    return
  end
  local PrevInputDevice = self.CurInputDevice
  self.CurInputDevice = CurInputDevice
  self.CurGamepadName = CurGamepadName
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  if self.Mobile then
    return
  end
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if IsGamepad and UIUtils.HasAnyFocus(self) then
    local FocusWidget = self:BP_GetDesiredFocusTarget()
    FocusWidget:SetFocus()
  end
  if self.Panel_Controller then
    self.Panel_Controller:SetVisibility(IsGamepad and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  end
end

function M:AddInputMethodChangedListen()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == Const.GamepadFaceButtonRight then
    if UIUtils.HasAnyFocus(self.WS_List) then
      self:CloseByGamepad()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif InKeyName == Const.GamepadLeftThumbstick then
    self:OpenSortByGamepad()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    self:FocusInputByGamepad()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif InKeyName == Const.GamepadRightThumbstick then
    self:ClearSearchByGamepad()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
