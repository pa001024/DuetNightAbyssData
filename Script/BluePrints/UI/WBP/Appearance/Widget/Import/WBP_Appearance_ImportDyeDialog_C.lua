require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

local function ImportDyeDialogScreenPrint(Message)
  ScreenPrint("[AppearanceImportDyeDialog] " .. tostring(Message))
end

local function BuildPopupItemContent(Owner, Source)
  if not Source then
    return nil
  end
  local Content = NewObject(UIUtils.GetCommonItemContentClass(), Owner)
  Content.Type = Source.Type or Source.ItemType
  Content.ItemType = Source.ItemType or Source.Type
  Content.UnitId = Source.UnitId or Source.Id
  Content.Id = Source.Id or Source.UnitId
  Content.Icon = Source.Icon
  Content.Rarity = Source.Rarity
  Content.Count = Source.Count
  Content.NeedCount = nil
  Content.NotEnoughCount = nil
  Content.Name = Source.Name
  Content.GradeLevel = Source.GradeLevel
  Content.EnhanceLevel = Source.EnhanceLevel
  Content.Quality = Source.Quality
  Content.UIName = Source.UIName
  Content.Tips = Source.Tips
  Content.UseEffectType = Source.UseEffectType
  Content.StateTagInfo = Source.StateTagInfo
  Content.Cost = nil
  Content.IsEmpty = Source.IsEmpty == true
  Content.ParentWidget = Owner
  Content.Owner = Owner
  Content.IsShowDetails = true
  Content.OnMenuOpenChangedEvents = {
    Obj = Owner,
    Callback = Owner.OnItemTipsOpenChanged
  }
  return Content
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.Parent = Params.Parent
  self.ShortText = Params.ShortText or ""
  self.Data = Params.DyeDialogData or {
    ImportableItems = {},
    UnableItems = {}
  }
  self.CurrentAppearanceTotalScore = tonumber(Params.CurrentAppearanceTotalScore) or 0
  self.FinalImportAppearanceTotalScore = tonumber(Params.FinalImportAppearanceTotalScore) or 0
  self.CurrentAppearanceDyeScore = tonumber(Params.CurrentAppearanceDyeScore) or 0
  self.FinalImportAppearanceDyeScore = tonumber(Params.FinalImportAppearanceDyeScore) or 0
  self.AppearanceScoreChangeText = Params.AppearanceScoreChangeText or ""
  self.DyeScoreChangeText = Params.DyeScoreChangeText or ""
  self:RefreshItems()
  self:RefreshScoreTip()
  self:InitGamepadView()
end

function M:RefreshItems()
  local HasImportableItems = type(self.Data.ImportableItems) == "table" and #self.Data.ImportableItems > 0
  local HasUnableItems = "table" == type(self.Data.UnableItems) and #self.Data.UnableItems > 0
  self.Text_Import:SetText(self.ShortText ~= "" and self.ShortText or GText("UI_AppearanceScore_DyeImportConfirm"))
  self.Text_Import:SetVisibility(HasImportableItems and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.Text_Import_Unable:SetText(GText("UI_AppearanceScore_ImportLack"))
  self.Text_Import_Unable:SetVisibility(HasUnableItems and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self:RefreshItemList(self.List_ImportItem, self.Data.ImportableItems, "Importable")
  self:RefreshItemList(self.List_ImportItem_Unable, self.Data.UnableItems, "Unable")
end

function M:RefreshScoreTip()
  local CurrentScore = self.CurrentAppearanceTotalScore or 0
  local PreviewScore = self.FinalImportAppearanceTotalScore or 0
  local NeedShow = CurrentScore ~= PreviewScore
  self.Panel_Tip:SetVisibility(NeedShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  if not NeedShow then
    return
  end
  self.Text_Fenghua:SetText(GText("UI_AppearanceScore_ScoreName"))
  self.Num_Fenghua_Now:SetText(tostring(CurrentScore))
  self.Num_Fenghua_Preview:SetText(tostring(PreviewScore))
  local NeedShowArrow = CurrentScore ~= PreviewScore
  self.Arrow:SetVisibility(NeedShowArrow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  self.AddArrow:SetVisibility(CurrentScore < PreviewScore and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:RefreshItemList(ListWidget, DataList, GroupName)
  if not IsValid(ListWidget) then
    ImportDyeDialogScreenPrint("refresh item list warning: missing list widget, Group=" .. tostring(GroupName))
    return
  end
  if ListWidget.ClearListItems then
    ListWidget:ClearListItems()
  end
  if type(DataList) ~= "table" or 0 == #DataList then
    ListWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  ListWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  for Index, Content in ipairs(DataList) do
    local PreparedContent = BuildPopupItemContent(self, Content)
    if PreparedContent and ListWidget.AddItem then
      ListWidget:AddItem(PreparedContent)
    else
      ImportDyeDialogScreenPrint("refresh item list warning: add item failed, Group=" .. tostring(GroupName) .. ", Index=" .. tostring(Index))
    end
  end
  if ListWidget.RequestRefresh then
    ListWidget:RequestRefresh()
  elseif ListWidget.RegenerateAllEntries then
    ListWidget:RegenerateAllEntries()
  end
end

function M:InitGamepadView()
  if self.bImportDyeDialogGamepadInited or not self.Owner then
    return
  end
  self.bImportDyeDialogGamepadInited = true
  if self.Owner.InitGamepadShortcut then
    self.ViewItemShortcutIdx = self.Owner:InitGamepadShortcut({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    }, 3)
    self.ViewByAKeyShortcutIdx = self.Owner:InitGamepadShortcut({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    }, 1)
    self.BackByBKeyShortcutIdx = self.Owner:InitGamepadShortcut({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    }, 2)
  end
  self:SwitchToNormalGamepadShortcutMode()
end

function M:SwitchToNormalGamepadShortcutMode()
  if not self.Owner then
    return
  end
  self.bInDetailViewMode = false
  if self.Owner.HideAllGamepadShortcut then
    self.Owner:HideAllGamepadShortcut()
  end
  if self.ViewItemShortcutIdx and self.Owner.ShowGamepadShortcut then
    self.Owner:ShowGamepadShortcut(self.ViewItemShortcutIdx)
  end
  if self.Owner.SetGamepadBtnKeyVisibility then
    self.Owner:SetGamepadBtnKeyVisibility(true)
  end
end

function M:SwitchToDetailGamepadShortcutMode()
  if not self.Owner then
    return
  end
  self.bInDetailViewMode = true
  if self.Owner.SetGamepadBtnKeyVisibility then
    self.Owner:SetGamepadBtnKeyVisibility(false)
  end
  if self.Owner.HideAllGamepadShortcut then
    self.Owner:HideAllGamepadShortcut()
  end
  if self.ViewByAKeyShortcutIdx and self.Owner.ShowGamepadShortcut then
    self.Owner:ShowGamepadShortcut(self.ViewByAKeyShortcutIdx)
  end
  if self.BackByBKeyShortcutIdx and self.Owner.ShowGamepadShortcut then
    self.Owner:ShowGamepadShortcut(self.BackByBKeyShortcutIdx)
  end
end

function M:GetFirstFocusableItemList()
  if IsValid(self.List_ImportItem) and self.List_ImportItem:GetVisibility() ~= UIConst.VisibilityOp.Collapsed and self.List_ImportItem.GetNumItems and self.List_ImportItem:GetNumItems() > 0 then
    return self.List_ImportItem
  end
  if IsValid(self.List_ImportItem_Unable) and self.List_ImportItem_Unable:GetVisibility() ~= UIConst.VisibilityOp.Collapsed and self.List_ImportItem_Unable.GetNumItems and self.List_ImportItem_Unable:GetNumItems() > 0 then
    return self.List_ImportItem_Unable
  end
  return nil
end

function M:FocusFirstDyeDialogItem()
  local ListWidget = self:GetFirstFocusableItemList()
  if not IsValid(ListWidget) then
    return false
  end
  if ListWidget.NavigateToIndex then
    ListWidget:NavigateToIndex(0)
    return true
  end
  if ListWidget.GetItemAt and ListWidget.BP_NavigateToItem then
    local Item = ListWidget:GetItemAt(0)
    if Item then
      ListWidget:BP_NavigateToItem(Item)
      return true
    end
  end
  if ListWidget.SetFocus then
    ListWidget:SetFocus()
    return true
  end
  return false
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    if self:FocusFirstDyeDialogItem() then
      self:SwitchToDetailGamepadShortcutMode()
    end
    return true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.bInDetailViewMode and self:HasFocusedDescendants() then
    self:SwitchToNormalGamepadShortcutMode()
    if self.Owner and self.Owner.SetFocus then
      self.Owner:SetFocus()
    end
    return true
  end
  return false
end

function M:OnItemTipsOpenChanged(bIsOpen, Content)
  if not self.Owner then
    return
  end
  if bIsOpen then
    if self.Owner.HideAllGamepadShortcut then
      self.Owner:HideAllGamepadShortcut()
    end
    if self.Owner.SetGamepadBtnKeyVisibility then
      self.Owner:SetGamepadBtnKeyVisibility(false)
    end
    if self.BackByBKeyShortcutIdx and self.Owner.ShowGamepadShortcut then
      self.Owner:ShowGamepadShortcut(self.BackByBKeyShortcutIdx)
    end
  elseif self.bInDetailViewMode then
    self:SwitchToDetailGamepadShortcutMode()
  else
    self:SwitchToNormalGamepadShortcutMode()
  end
end

return M
