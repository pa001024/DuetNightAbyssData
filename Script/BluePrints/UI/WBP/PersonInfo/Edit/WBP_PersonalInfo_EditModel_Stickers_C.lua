require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local SECTION_NAME = "Sticker"
local STICKER_ITEM_BP_PATH = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/Widget/EditModel/WBP_PersonalInfo_EditModel_StickersItem.WBP_PersonalInfo_EditModel_StickersItem'"
local NONE_STICKER_ENTRY_KEY = "__NONE_STICKER__"
local STICKER_ITEM_IN_STAGGER_INTERVAL = 0.015
local STICKER_ITEM_IN_STAGGER_TIMER_KEY = "StickerItemInStagger"

function M:Initialize(Initializer)
  self.EditRootController = nil
  self.OwnerOtherPage = nil
  self.StickerItemWidgets = {}
  self.SelectedStickerId = NONE_STICKER_ENTRY_KEY
  self.bListExpanded = false
  self.bIsListOutPlaying = false
  self.IsBindingFinished = false
  self.StickerItemInStaggerToken = 0
  self.bPendingForceScrollAfterListIn = false
end

function M:InitStickerPanel(EditRootController, OwnerOtherPage)
  self.EditRootController = EditRootController
  self.OwnerOtherPage = OwnerOtherPage
  self:_BindTitleEvents()
  self:_ApplyListCollapsedImmediate()
  self:_PlayTitleNormal()
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_PersonalPage_Sticker"))
  end
end

function M:RefreshView()
  if not self.EditRootController or not self.WrapBox_Stickers then
    return
  end
  if self.StickerItemWidgets and #self.StickerItemWidgets > 0 then
    self:_SyncDisplayedStickerItemSelect()
    return
  end
  self:_RebuildStickerList()
end

function M:_RebuildStickerList()
  self:_CancelStickerItemInStagger()
  self:_ClearStickerItems()
  self:_AddStickerItem(self:_BuildNoneStickerViewData())
  local StickerViewList = self.EditRootController:BuildStickerViewList() or {}
  for _, StickerViewData in ipairs(StickerViewList) do
    self:_AddStickerItem(StickerViewData)
  end
  self.SelectedStickerId = self:_ResolveInitialSelectedStickerId(StickerViewList)
  self:_SyncDisplayedStickerItemSelect()
  self:_CloseStickerEditIfNoneSelected()
end

function M:RequestSelectStickerItem(StickerId)
  local TargetId = self:_NormalizeStickerSelectId(StickerId)
  local Controller = self.EditRootController
  if TargetId == NONE_STICKER_ENTRY_KEY then
    if not self:_IsSameStickerSelectId(self.SelectedStickerId, TargetId) then
      self.SelectedStickerId = TargetId
      self:_SyncDisplayedStickerItemSelect()
    end
    if Controller and Controller.ClearStickerPreview then
      Controller:ClearStickerPreview()
    end
    self:_CloseStickerEditIfNoneSelected()
    return
  end
  if self:_IsSameStickerSelectId(self.SelectedStickerId, TargetId) then
    return
  end
  self.SelectedStickerId = TargetId
  self:_SyncDisplayedStickerItemSelect()
  local ViewData = self:_FindStickerViewDataById(TargetId)
  if Controller and Controller.ApplyStickerPreviewKeepingTransform then
    Controller:ApplyStickerPreviewKeepingTransform(ViewData)
  end
end

function M:SyncSelectionToStickerId(StickerId)
  self.SelectedStickerId = self:_NormalizeStickerSelectId(StickerId)
  self:_SyncDisplayedStickerItemSelect()
  self:_CloseStickerEditIfNoneSelected()
end

function M:SyncSelectionToWorkingSticker()
  local StickerViewList
  if self.EditRootController and self.EditRootController.BuildStickerViewList then
    StickerViewList = self.EditRootController:BuildStickerViewList()
  end
  local TargetId = self:_ResolveInitialSelectedStickerId(StickerViewList)
  self:SyncSelectionToStickerId(TargetId)
end

function M:RefreshCurrentSelectionVisual()
  self:_SyncDisplayedStickerItemSelect()
end

function M:FocusGamepadSelectedStickerItem(bForceScroll)
  if not self.bListExpanded then
    return false
  end
  local bListInPlaying = false
  if bForceScroll and self.List_In and self.IsAnimationPlaying then
    bListInPlaying = self:IsAnimationPlaying(self.List_In) == true
  end
  if bListInPlaying then
    self.bPendingForceScrollAfterListIn = true
    return true
  end
  local ItemWidget = self:_FindDisplayedStickerItemBySelectId(self.SelectedStickerId)
  ItemWidget = ItemWidget or self.StickerItemWidgets and self.StickerItemWidgets[1] or nil
  if not ItemWidget then
    return false
  end
  local OwnerOtherPage = self.OwnerOtherPage
  if OwnerOtherPage then
    OwnerOtherPage.bSuppressGamepadFocusFollowScroll = true
  end
  local bFocused = false
  if ItemWidget.FocusGamepadItem and ItemWidget:FocusGamepadItem() then
    bFocused = true
  elseif ItemWidget.Btn_Click and ItemWidget.Btn_Click.SetFocus then
    ItemWidget.Btn_Click:SetFocus()
    bFocused = true
  elseif ItemWidget.SetFocus then
    ItemWidget:SetFocus()
    bFocused = true
  end
  if OwnerOtherPage then
    OwnerOtherPage.bSuppressGamepadFocusFollowScroll = false
  end
  if not bFocused then
    return false
  end
  if bForceScroll then
    if self.WrapBox_Stickers and self.WrapBox_Stickers.ForceLayoutPrepass then
      self.WrapBox_Stickers:ForceLayoutPrepass()
    end
    self:ScrollGamepadFocusedWidgetIntoView(ItemWidget, true)
  else
    self:ScrollGamepadFocusedWidgetIntoView(ItemWidget, false)
  end
  return true
end

function M:ScrollGamepadFocusedWidgetIntoView(Widget, bForceScroll)
  if self.OwnerOtherPage and self.OwnerOtherPage.ScrollGamepadFocusedWidgetIntoView then
    self.OwnerOtherPage:ScrollGamepadFocusedWidgetIntoView(Widget, bForceScroll)
  end
end

function M:RequestOpenStickerEdit()
  if self.SelectedStickerId == nil or self.SelectedStickerId == NONE_STICKER_ENTRY_KEY then
    return
  end
  self:RequestOpenStickerEditById(self.SelectedStickerId)
end

function M:RequestOpenStickerEditById(StickerId)
  local TargetId = self:_NormalizeStickerSelectId(StickerId)
  if TargetId == NONE_STICKER_ENTRY_KEY then
    return
  end
  local Controller = self.EditRootController
  if not Controller or not Controller.OpenStickerEditPage then
    return
  end
  local ViewData = self:_FindStickerViewDataById(TargetId)
  Controller:OpenStickerEditPage(ViewData)
end

function M:IsStickerEntrySelected(ViewData)
  if not ViewData or self.SelectedStickerId == nil then
    return false
  end
  if nil == ViewData.StickerId then
    return self.SelectedStickerId == NONE_STICKER_ENTRY_KEY
  end
  return self:_IsSameStickerSelectId(self.SelectedStickerId, ViewData.StickerId)
end

function M:SetListExpanded(bExpanded)
  bExpanded = true == bExpanded
  if self.bListExpanded == bExpanded then
    return
  end
  self.bListExpanded = bExpanded
  if bExpanded then
    self:_PlayListIn()
  else
    self.bPendingForceScrollAfterListIn = false
    self:_CancelStickerItemInStagger()
    self:_PlayListOut()
  end
end

function M:IsListExpanded()
  return self.bListExpanded == true
end

function M:Destruct()
  self:_CancelStickerItemInStagger()
  if self.CleanTimer then
    self:CleanTimer()
  end
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
  end
  if self.List_Out then
    self:UnbindAllFromAnimationFinished(self.List_Out)
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  self:_ClearStickerItems()
  self.EditRootController = nil
  self.OwnerOtherPage = nil
  self.StickerItemWidgets = nil
  self.SelectedStickerId = nil
  self.bListExpanded = nil
  self.bIsListOutPlaying = nil
  self.IsBindingFinished = nil
  self.StickerItemInStaggerToken = nil
  self.bPendingForceScrollAfterListIn = nil
end

function M:_BindTitleEvents()
  if self.IsBindingFinished or not self.Btn_Click then
    return
  end
  local Btn = self.Btn_Click
  Btn.OnClicked:Clear()
  Btn.OnClicked:Add(self, self.OnTitleClicked)
  Btn.OnHovered:Clear()
  Btn.OnHovered:Add(self, self.OnTitleHovered)
  Btn.OnUnhovered:Clear()
  Btn.OnUnhovered:Add(self, self.OnTitleUnhovered)
  Btn.OnPressed:Clear()
  Btn.OnPressed:Add(self, self.OnTitlePressed)
  self.IsBindingFinished = true
end

function M:OnTitleClicked()
  if UIUtils.IsGamepadInput() then
    if self.bListExpanded then
      if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
        self.OwnerOtherPage:RequestToggleSection(SECTION_NAME)
      else
        self:SetListExpanded(false)
      end
      return
    end
    if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
      self.OwnerOtherPage:RequestToggleSection(SECTION_NAME, true)
      return
    end
    self:SetListExpanded(true)
    self:FocusGamepadSelectedStickerItem(true)
    return
  end
  if not self.bListExpanded and self.Click then
    self:PlayAnimation(self.Click)
  end
  if self.OwnerOtherPage and self.OwnerOtherPage.RequestToggleSection then
    self.OwnerOtherPage:RequestToggleSection(SECTION_NAME)
  end
end

function M:OnTitleHovered()
  if self.bListExpanded then
    return
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnTitleUnhovered()
  if self.bListExpanded then
    return
  end
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:BindToAnimationFinished(self.UnHover, {
      self,
      self._OnTitleUnHoverFinished
    })
    self:PlayAnimation(self.UnHover)
    return
  end
  self:_PlayTitleNormal()
end

function M:OnTitlePressed()
  if self.bListExpanded then
    return
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:_OnTitleUnHoverFinished()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
  end
  if self.bListExpanded then
    return
  end
  self:_PlayTitleNormal()
end

function M:_PlayTitleNormal()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:_PlayTitleClickHold()
  if self.UnHover then
    self:UnbindAllFromAnimationFinished(self.UnHover)
    self:StopAnimation(self.UnHover)
  end
  if self.Click then
    self:PlayAnimation(self.Click)
  end
end

function M:_PlayListIn()
  self.bIsListOutPlaying = false
  if self.List_Out then
    self:UnbindAllFromAnimationFinished(self.List_Out)
    self:StopAnimation(self.List_Out)
  end
  self:_PlayTitleClickHold()
  self:_PrepareAllStickerItemEntryIn()
  if self.WrapBox_Stickers then
    self.WrapBox_Stickers:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.List_In then
    self:StopAnimation(self.List_In)
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:BindToAnimationFinished(self.List_In, {
      self,
      self._OnListInFinished
    })
    self:PlayAnimation(self.List_In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
  end
  self:_SyncDisplayedStickerItemSelect()
  self:_PlayStickerItemInStagger()
end

function M:_OnListInFinished()
  if not IsValid(self) then
    return
  end
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:StopAnimation(self.List_In)
  end
  if not self.bPendingForceScrollAfterListIn then
    return
  end
  self.bPendingForceScrollAfterListIn = false
  if not self.bListExpanded then
    return
  end
  self:FocusGamepadSelectedStickerItem(true)
end

function M:_PlayListOut()
  self:_CancelStickerItemInStagger()
  if self.List_In then
    self:UnbindAllFromAnimationFinished(self.List_In)
    self:StopAnimation(self.List_In)
  end
  if not self.List_Out then
    self:_ApplyListCollapsedImmediate()
    self:_PlayTitleNormal()
    self:_NotifyOwnerSectionCollapsed()
    return
  end
  if self.bIsListOutPlaying then
    return
  end
  self.bIsListOutPlaying = true
  self:UnbindAllFromAnimationFinished(self.List_Out)
  self:BindToAnimationFinished(self.List_Out, {
    self,
    self._OnListOutFinished
  })
  self:PlayAnimation(self.List_Out, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, false)
end

function M:_OnListOutFinished()
  if not IsValid(self) then
    return
  end
  self.bIsListOutPlaying = false
  if self.bListExpanded then
    return
  end
  self:_ApplyListCollapsedImmediate()
  self:_PlayTitleNormal()
  self:_NotifyOwnerSectionCollapsed()
end

function M:_NotifyOwnerSectionCollapsed()
  if not IsValid(self) then
    return
  end
  local OwnerOtherPage = self.OwnerOtherPage
  if not OwnerOtherPage or not IsValid(OwnerOtherPage) then
    return
  end
  if OwnerOtherPage.OnSectionListCollapsed then
    OwnerOtherPage:OnSectionListCollapsed(SECTION_NAME)
  end
end

function M:_ApplyListCollapsedImmediate()
  if self.WrapBox_Stickers then
    self.WrapBox_Stickers:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:_ClearStickerItems()
  if self.WrapBox_Stickers then
    self.WrapBox_Stickers:ClearChildren()
  end
  self.StickerItemWidgets = {}
end

function M:_BuildNoneStickerViewData()
  return {
    StickerId = nil,
    Name = "无",
    Icon = nil,
    StickerPath = nil,
    StickerData = nil,
    IsSelected = false
  }
end

function M:_ResolveInitialSelectedStickerId(StickerViewList)
  local StickerData
  local Controller = self.EditRootController
  if Controller and Controller.GetWorkingStickerData then
    StickerData = Controller:GetWorkingStickerData()
  end
  local StickerId
  if type(StickerData) == "table" then
    StickerId = StickerData.StickerId or StickerData.Id
  elseif nil ~= StickerData then
    StickerId = StickerData
  end
  local TargetId = self:_NormalizeStickerSelectId(StickerId)
  if TargetId == NONE_STICKER_ENTRY_KEY then
    return NONE_STICKER_ENTRY_KEY
  end
  for _, StickerViewData in ipairs(StickerViewList or {}) do
    if StickerViewData and self:_IsSameStickerSelectId(StickerViewData.StickerId, TargetId) then
      return StickerViewData.StickerId
    end
  end
  return NONE_STICKER_ENTRY_KEY
end

function M:_NormalizeStickerSelectId(StickerId)
  if nil == StickerId or "" == StickerId or StickerId == NONE_STICKER_ENTRY_KEY then
    return NONE_STICKER_ENTRY_KEY
  end
  return StickerId
end

function M:_IsSameStickerSelectId(Left, Right)
  if Left == Right then
    return true
  end
  if nil == Left or nil == Right then
    return false
  end
  return tostring(Left) == tostring(Right)
end

function M:_AddStickerItem(StickerViewData)
  if not StickerViewData or not self.WrapBox_Stickers then
    return
  end
  local ItemWidget = UIManager(self):CreateWidget(STICKER_ITEM_BP_PATH)
  if not ItemWidget then
    return
  end
  self.WrapBox_Stickers:AddChildToWrapBox(ItemWidget)
  if ItemWidget.InitStickerItem then
    ItemWidget:InitStickerItem(StickerViewData, self)
  end
  self.StickerItemWidgets[#self.StickerItemWidgets + 1] = ItemWidget
end

function M:_SyncDisplayedStickerItemSelect()
  for _, ItemWidget in ipairs(self.StickerItemWidgets or {}) do
    if ItemWidget and IsValid(ItemWidget) and ItemWidget.SyncSelectFromHost then
      ItemWidget:SyncSelectFromHost()
    end
  end
end

function M:_CloseStickerEditIfNoneSelected()
  local Controller = self.EditRootController
  if not Controller then
    return
  end
  if self.SelectedStickerId == nil or self.SelectedStickerId == NONE_STICKER_ENTRY_KEY then
    if Controller.IsStickerEditPageActive and Controller:IsStickerEditPageActive() and Controller.CloseStickerEditAndReturn then
      Controller:CloseStickerEditAndReturn()
    elseif Controller.HideStickerEdit then
      Controller:HideStickerEdit()
    end
  end
end

function M:_FindDisplayedStickerItemBySelectId(SelectId)
  local TargetId = self:_NormalizeStickerSelectId(SelectId)
  for _, ItemWidget in ipairs(self.StickerItemWidgets or {}) do
    if ItemWidget and IsValid(ItemWidget) then
      local ViewData = ItemWidget.StickerViewData
      if ViewData then
        local EntryId = self:_NormalizeStickerSelectId(ViewData.StickerId)
        if self:_IsSameStickerSelectId(EntryId, TargetId) then
          return ItemWidget
        end
      end
    end
  end
  return nil
end

function M:_FindStickerViewDataById(StickerId)
  if nil == StickerId or StickerId == NONE_STICKER_ENTRY_KEY then
    return nil
  end
  for _, ItemWidget in ipairs(self.StickerItemWidgets or {}) do
    local ViewData = ItemWidget and ItemWidget.StickerViewData or nil
    if ViewData and self:_IsSameStickerSelectId(ViewData.StickerId, StickerId) then
      return ViewData
    end
  end
  return {StickerId = StickerId}
end

function M:_CancelStickerItemInStagger()
  self.StickerItemInStaggerToken = (self.StickerItemInStaggerToken or 0) + 1
  if self.RemoveTimer then
    self:RemoveTimer(STICKER_ITEM_IN_STAGGER_TIMER_KEY)
  end
end

function M:_PrepareAllStickerItemEntryIn()
  for _, ItemWidget in ipairs(self.StickerItemWidgets or {}) do
    if ItemWidget and IsValid(ItemWidget) and ItemWidget.PrepareEntryIn then
      ItemWidget:PrepareEntryIn()
    end
  end
end

function M:_PlayStickerItemInStagger()
  if not self.bListExpanded or not self.AddTimer then
    return
  end
  self:_CancelStickerItemInStagger()
  local EntryList = {}
  for _, ItemWidget in ipairs(self.StickerItemWidgets or {}) do
    if ItemWidget and IsValid(ItemWidget) then
      EntryList[#EntryList + 1] = ItemWidget
    end
  end
  if 0 == #EntryList then
    return
  end
  self:_PrepareAllStickerItemEntryIn()
  local StaggerToken = self.StickerItemInStaggerToken
  local PlayIndex = 0
  
  local function PlayNextStickerItemIn()
    if not IsValid(self) or self.StickerItemInStaggerToken ~= StaggerToken or not self.bListExpanded then
      return false
    end
    PlayIndex = PlayIndex + 1
    local Entry = EntryList[PlayIndex]
    if Entry and IsValid(Entry) and Entry.PlayEntryIn then
      Entry:PlayEntryIn()
    end
    return PlayIndex < #EntryList
  end
  
  if not PlayNextStickerItemIn() then
    return
  end
  self:AddTimer(STICKER_ITEM_IN_STAGGER_INTERVAL, function()
    if not PlayNextStickerItemIn() then
      self:RemoveTimer(STICKER_ITEM_IN_STAGGER_TIMER_KEY)
    end
  end, true, 0, STICKER_ITEM_IN_STAGGER_TIMER_KEY, true)
end

return M
