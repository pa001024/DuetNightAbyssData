require("UnLua")
local EventVersionUtils = require("BluePrints.UI.WBP.Activity.EventVersionUtils")
local ActivityUtils = require("BluePrints.UI.WBP.Activity.ActivityUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local PREVIEW_STATE_LOCK = 0
local PREVIEW_STATE_ING = 1
local PREVIEW_STATE_ENDED = 2
local CHANGE_LOCK = 0
local CHANGE_ING = 1
local CHANGE_DONE = 2

local function EventIdBelongsToTabRow(eventId, idList)
  if not eventId or not idList then
    return false
  end
  for i = 1, #idList do
    if idList[i] == eventId then
      return true
    end
  end
  return false
end

local function FindEventTabBgPathByEventId(eventId)
  if not eventId then
    return nil, nil
  end
  local eventTab = DataMgr.EventTab
  if not eventTab then
    return nil, nil
  end
  for _, row in pairs(eventTab) do
    if row and EventIdBelongsToTabRow(eventId, row.EventId) then
      local p = row.EventTabBg
      if type(p) == "string" and "" ~= p then
        return p, row.EventTabId
      end
    end
  end
  return nil, nil
end

local function FindEventTabNameKeyByEventId(eventId)
  if not eventId then
    return nil
  end
  local eventTab = DataMgr.EventTab
  if not eventTab then
    return nil
  end
  for _, row in pairs(eventTab) do
    if row and EventIdBelongsToTabRow(eventId, row.EventId) then
      local n = row.EventTabName
      if type(n) == "string" and "" ~= n then
        return n
      end
      return nil
    end
  end
  return nil
end

function M:Construct()
  self.Btn_Jump.Button_Area.OnClicked:Add(self, self.OnClickedJump)
  self:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Key_ItemRewards:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
      }
    }
  })
  self.Btn_Jump:SetGamepadIconVisibility(false)
  self.Btn_Jump:SetGamePadImg("A")
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(InputType, GamepadName)
  if InputType ~= ECommonInputType.Gamepad then
    self:OnItemSelectionChanged(false)
    if self.IsSelected then
      self:PlayAnimation(self.Unhover)
    end
  elseif InputType == ECommonInputType.Gamepad and self.IsSelected then
    self:OnItemSelectionChanged(true)
    self:PlayAnimation(self.Hover)
  end
end

function M:ClearBtnJumpNewReddot()
  if self.Btn_Jump and self.Btn_Jump.SetReddot then
    self.Btn_Jump:SetReddot(false, false, false)
  end
end

function M:RefreshBtnJumpNewReddot()
  if not (self.Btn_Jump and self.Btn_Jump.SetReddot) or not self.EventId then
    return
  end
  local cfg = DataMgr.EventMain[self.EventId]
  if not cfg or type(cfg.ReddotNode) ~= "string" or cfg.ReddotNode == "" then
    self.Btn_Jump:SetReddot(false, false, false)
    return
  end
  local bShowNew = EventVersionUtils.EventHasLeafNewReddot(self.EventId)
  self.Btn_Jump:SetReddot(bShowNew and true or false, false, false)
end

function M:OnClickedJump()
  if not ActivityUtils.CheckEventIsOpen(self.EventId) then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Locked_Des_GameEvent"))
    return
  end
  local ActivityLimitTimeRewardPreview = UIManager(self):GetUI("ActivityLimitTimeRewardPreview")
  if ActivityLimitTimeRewardPreview then
    ActivityLimitTimeRewardPreview:Close()
  end
  local path, tabId = FindEventTabBgPathByEventId(self.EventId)
  PageJumpUtils:JumpToEventPage(tabId)
end

function M:ApplyEventTabBgToItemIcon(eventId)
  if not self.Image_Icon then
    return
  end
  local path = FindEventTabBgPathByEventId(eventId)
  if not path then
    self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local tex = LoadObject(path)
  if not tex then
    self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local IconDynaMaterial = self.Image_Icon:GetDynamicMaterial()
  IconDynaMaterial:SetTextureParameterValue("IconMap", tex)
  self.Image_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:ApplyPreviewState(ListItemObject)
  local state = ListItemObject.PreviewState or PREVIEW_STATE_LOCK
  local eventId = ListItemObject.EventId
  local cfg = eventId and DataMgr.EventMain[eventId]
  local bActivitySucc = ListItemObject.bActivitySucc and true or false
  local changeIndex
  if state == PREVIEW_STATE_LOCK then
    changeIndex = CHANGE_LOCK
    self.Text_Lock:SetText(GText("UI_Event_Btn_ToBegin"))
  elseif state == PREVIEW_STATE_ING then
    changeIndex = bActivitySucc and CHANGE_DONE or CHANGE_ING
  else
    changeIndex = bActivitySucc and CHANGE_DONE or CHANGE_LOCK
    self.Text_Lock:SetText(GText("UI_Event_Btn_TimeOver"))
  end
  self.Change:SetActiveWidgetIndex(changeIndex)
  if state == PREVIEW_STATE_ENDED then
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return bActivitySucc
  end
  self.HB_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if not cfg then
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return bActivitySucc
  end
  local targetTime, titleText
  if state == PREVIEW_STATE_LOCK then
    targetTime = cfg.EventStartTime
  else
    targetTime = cfg.EventEndTime or cfg.PermanenEventTime
  end
  if not targetTime then
    self.HB_Time:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return bActivitySucc
  end
  local dict = UIUtils.GetLeftTimeStrStyle2(targetTime)
  self.Com_Time:SetTimeText(titleText, dict)
  self.Com_Time.Text_TimeTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  return bActivitySucc
end

function M:FillItemRewardsList(previewRewardId, bHasGot)
  self.List_ItemRewards:ClearListItems()
  if not previewRewardId then
    self.IsRewardListEmpty = true
    previewRewardId = 0
  end
  local rewardInfo = DataMgr.RewardView[previewRewardId]
  if not rewardInfo then
    self.IsRewardListEmpty = true
    rewardInfo = {}
  end
  self.List_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  local rewardIds = rewardInfo.Id or {}
  local rewardCounts = rewardInfo.Quantity or {}
  local rewardTypes = rewardInfo.Type or {}
  for i = 1, #rewardIds do
    local itemId = rewardIds[i]
    local itemType = rewardTypes[i]
    local count = RewardUtils:GetCount(rewardCounts[i])
    if count <= 0 then
      count = nil
    end
    local rarity = ItemUtils.GetItemRarity(itemId, itemType)
    local dm = itemType and DataMgr[itemType]
    local row = dm and dm[itemId]
    if row then
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = itemId
      Content.ItemType = itemType
      Content.Count = count
      Content.Rarity = rarity
      Content.Icon = row.Icon
      Content.IsShowDetails = true
      Content.ParentWidget = self
      Content.bHasGot = bHasGot and true or false
      self.List_ItemRewards:AddItem(Content)
    end
  end
  if #rewardIds < 4 then
    for i = #rewardIds + 1, 4 do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = 0
      self.List_ItemRewards:AddItem(Content)
    end
  end
end

function M:OnListItemObjectSet(ListItemObject)
  self.ListItemObject = ListItemObject
  self.ListItemObject.UI = self
  self:ClearBtnJumpNewReddot()
  if not ListItemObject then
    return
  end
  self.EventId = ListItemObject.EventId
  local eventId = ListItemObject.EventId
  if not eventId or 0 == eventId then
    return
  end
  local cfg = DataMgr.EventMain[eventId]
  if not cfg then
    return
  end
  local titleKey = FindEventTabNameKeyByEventId(eventId) or cfg.EventName
  self.Text_ItemTitle:SetText(GText(titleKey))
  self:ApplyEventTabBgToItemIcon(eventId)
  local bRewardHasGot = self:ApplyPreviewState(ListItemObject)
  local collRow = DataMgr.LimitEventRewardCollection and DataMgr.LimitEventRewardCollection[eventId]
  local previewRewardId = collRow and collRow.RewardId
  self:FillItemRewardsList(previewRewardId, bRewardHasGot)
  self.Btn_Jump:SetText(GText("UI_Event_Btn_Goto"))
  self:RefreshBtnJumpNewReddot()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if "Gamepad_LeftThumbstick" == InKeyName and not self.IsRewardListEmpty then
    self.List_ItemRewards:SetFocus()
    self.ListItemObject.ParentWidget.IsFocusOnRewardItem = true
    self:OnItemSelectionChanged(false)
    self.ListItemObject.ParentWidget.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif "Gamepad_FaceButton_Bottom" == InKeyName and not self.ListItemObject.ParentWidget.IsFocusOnRewardItem then
    if self.ListItemObject.PreviewState ~= PREVIEW_STATE_ING then
      return UE4.UWidgetBlueprintLibrary.UnHandled()
    end
    self:OnClickedJump()
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnItemSelectionChanged(IsSelected)
  self.bIsSelected = IsSelected
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    if IsSelected then
      self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      if self.IsRewardListEmpty then
        self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      self.Btn_Jump:SetGamepadIconVisibility(true)
    else
      self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Btn_Jump:SetGamepadIconVisibility(false)
    end
  else
    self.Key_ItemRewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Jump:SetGamepadIconVisibility(false)
  end
end

function M:OnAddedToFocusPath(InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:OnItemSelectionChanged(true)
    local parentWidget = self.ListItemObject.ParentWidget
    local parentSectionContent = self.ListItemObject.Parent.ListItemObject
    parentWidget.LastFocusItem = self
    parentWidget.LastFocusSection = parentSectionContent
    parentWidget.LastFocusIndex[parentSectionContent.Index] = self.ListItemObject.Index
    parentWidget.Scroll:ScrollWidgetIntoView(self, true, UE4.EDescendantScrollDestination.IntoView)
    self.IsSelected = true
    self.ListItemObject.IsSelected = true
    self:PlayAnimation(self.Hover)
  end
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    self:OnItemSelectionChanged(false)
    self.IsSelected = false
    self.ListItemObject.IsSelected = false
    self:PlayAnimation(self.Unhover)
  end
end

return M
