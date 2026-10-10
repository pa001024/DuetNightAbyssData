require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local EImpressionButtonState = require("BluePrints.UI.UI_PC.Impression.ImpressionConst").EImpressionButtonState
local Scroll_Mouse = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PC/T_Key_MouseScroll.T_Key_MouseScroll")
local Scroll_Xbox = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_LV.T_Key_LV")
local Scroll_PS = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_LV.T_Key_LV")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Event_InitUI(Params)
  Params = Params or {}
  self.ItemUIPathName = Params.ItemUIPathName
  self.DelayDestoryCount = 0
  self.NextUpDownSelectTime = 0
  self.UpDownSelectCooldown = 0.1
  self.ScrollBox_TalkOptions = self.ScrollBox_Items
  self.CurrentSelectItemIdx = -1
  self.LastSelectItemIdx = -1
  self.bListeningUpDownEvents = false
  self.bListeningConfirmEvents = false
  self.OnItemClickFunc = Params.OnItemClicked
  self.OnItemClickStartFunc = Params.OnItemClickStart
  self.OnItemHoveredFunc = Params.OnItemHovered
  self.OnItemUnhoveredFunc = Params.OnItemUnhovered
  self.OnSelectionChangedFunc = Params.OnSelectionChanged
  self:ShowCostGroup(false)
  self:InitExitButton(Params)
  if self.bIsMobile then
    return
  end
  self.Key_PickUp:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetActionMappingKeyName("TalkOption")
      }
    }
  })
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = CommonUtils:GetKeyText(CommonUtils:GetActionMappingKeyName("TalkOption", true))
      }
    }
  })
  self.KeyNode:SetVisibility(ESlateVisibility.Collapsed)
end

function M:Event_InitVisibility()
  self:SwitchShowOptionUI(false)
end

function M:Event_RegisterFocusTarget(Owner)
  Owner:AddLSFocusTarget(self.Com_Cost.Key, self.Com_Cost, "RS", true)
end

function M:Event_DisplayStarted(OptionType, ImpressionAreaId, bIsRetryCheck)
  self:SwitchEnableInteraction(false)
  self:SwitchShowOptionUI(true)
  self:SetDefaultItem()
  self:SetExitButtonNormal()
  self:ShowCostGroup(false)
  if not bIsRetryCheck or OptionType ~= ETalkOptionType.Check then
    return
  end
  local Ret = ImpressionModel:CanImpressionCheck(ImpressionAreaId)
  local ImpressionResourceInfo = DataMgr.ImpressionResource[ImpressionAreaId]
  self.Com_Cost:InitContent({
    ResourceId = ImpressionResourceInfo.ResourceId,
    bShowDenominator = true,
    Numerator = Ret.ResourceCount or 0,
    Denominator = Ret.Cost,
    KeyIconName = "RS",
    UIName = "ImpressionMainUI"
  })
  self:ShowCostGroup(true)
end

function M:Event_DisplayStartFinished()
  self:SwitchEnableInteraction(true)
end

function M:Event_DisplayEnded()
  self:SwitchEnableInteraction(false)
  self:SwitchShowOptionUI(false)
  self:ShowCostGroup(false)
end

function M:Event_UpdateKeyImg(IsGamePad, GamepadName)
  self.WS_Node:SetActiveWidgetIndex(IsGamePad and 1 or 0)
  self:UpdateKeyImg(IsGamePad, GamepadName)
end

function M:Event_InitGText()
  self.Text_TipsTitle:SetText(GText("Impression_Repeat_Dice"))
  self.Text_Button:SetText(GText("Impression_UI_Back"))
end

function M:Event_AdaptPlatform(IsMobile)
  self.bIsMobile = IsMobile
  self.Static_GroupKeyNode:SetVisibility(IsMobile and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
  self.Img_Mouse:SetVisibility(IsMobile and ESlateVisibility.Collapsed or ESlateVisibility.HitTestInvisible)
end

function M:Event_ChangeImgMouseVisibility(OptionData, OptionMaxNum)
  if self.bIsMobile then
    return
  end
  if OptionData and (OptionData.OptionType == ETalkOptionType.Check or OptionMaxNum >= 2) then
    self.Img_Mouse:SetVisibility(ESlateVisibility.HitTestInvisible)
    return
  end
  self.Img_Mouse:SetVisibility(ESlateVisibility.Collapsed)
end

function M:Event_InitItems(OptionItemDatas)
  self:ClearListItems()
  self:AddItems(OptionItemDatas)
end

function M:InitExitButton(Params)
  Params = Params or {}
  self.OnExitClickedFunc = Params.OnExitClicked or function()
  end
  self.OnExitClickAnimationFinishedFunc = Params.OnExitClickAnimationFinished or function()
  end
  self.ExtraSelectable = {
    Widget = self.Button_Area,
    IsEnabled = function()
      return self.Group_Button:GetVisibility() ~= ESlateVisibility.Collapsed
    end,
    OnSelect = function()
      self:OnExitButtonSelected(true)
    end,
    OnUnselect = function()
      self:OnExitButtonSelected(false)
    end,
    OnPressed = function()
      self:OnExitButtonPressed()
    end,
    OnReleased = function()
      self:OnExitButtonClicked()
    end
  }
  self:BindToAnimationFinished(self.BtnQuit_Click, {
    self,
    self.OnExitButtonClickAnimFinished
  })
end

function M:IsTipsOpen()
  return self.Com_Cost:HasFocusedDescendants() or self.Com_Cost:HasAnyUserFocus()
end

function M:ShowCostGroup(bShow)
  self.Group_Cost:SetVisibility(bShow and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:OnExitButtonSelected(bIsSelect)
  self.bExitButtonSelect = bIsSelect
  if self.bIsMobile then
    return
  end
  self.KeyNode:SetVisibility(bIsSelect and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  if bIsSelect then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", "", nil)
    self:StopAnimation(self.BtnQuit_UnHover)
    self:PlayAnimation(self.BtnQuit_Hover, 0, 1)
  else
    self:StopAnimation(self.BtnQuit_Hover)
    self:PlayAnimation(self.BtnQuit_UnHover)
  end
end

function M:OnExitButtonPressed()
  self:PlayAnimation(self.BtnQuit_Press)
end

function M:OnExitButtonReleased()
  if self.bIsMobile then
    self:PlayAnimation(self.BtnQuit_Normal)
    return
  end
  if self.bExitButtonSelect then
    self:PlayAnimation(self.BtnQuit_Hover, 0, 1)
  end
end

function M:OnExitButtonClicked()
  self:SwitchEnableInteraction(false)
  self:PlayAnimation(self.BtnQuit_Click)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", "", nil)
  self.OnExitClickedFunc()
end

function M:OnExitButtonHovered()
  self:OnExtraHovered()
end

function M:OnExitButtonUnhovered()
end

function M:OnExitButtonClickAnimFinished()
  self:StopAllAnimations()
  self.OnExitClickAnimationFinishedFunc()
end

function M:SwitchEnableInteraction(bEnable)
  self:SwitchBindExitButtonEvents(bEnable)
  self:SwitchEnableImpressionItemClick(bEnable)
  self:SwitchEnableConfirmEvents(bEnable)
  self:SwitchEnableUpDownEvents(bEnable)
end

function M:SwitchBindExitButtonEvents(bBind)
  if bBind then
    self.Button_Area.OnClicked:Add(self, self.OnExitButtonClicked)
    self.Button_Area.OnHovered:Add(self, self.OnExitButtonHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnExitButtonUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnExitButtonPressed)
    self.Button_Area.OnReleased:Add(self, self.OnExitButtonReleased)
  else
    self.Button_Area.OnClicked:Remove(self, self.OnExitButtonClicked)
    self.Button_Area.OnHovered:Remove(self, self.OnExitButtonHovered)
    self.Button_Area.OnUnhovered:Remove(self, self.OnExitButtonUnhovered)
    self.Button_Area.OnPressed:Remove(self, self.OnExitButtonPressed)
    self.Button_Area.OnReleased:Remove(self, self.OnExitButtonReleased)
  end
end

function M:SetExitButtonNormal()
  self:PlayAnimation(self.BtnQuit_Normal)
end

function M:ShowExitButton(bShow)
  self.Group_Button:SetVisibility(bShow and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:GetItemByDisplayIndex(ItemIndex, OptionMaxNum)
  if OptionMaxNum < ItemIndex then
    return self.Button_Area
  end
  return self:GetItemByIndex(ItemIndex - 1)
end

function M:ReceiveTick(InDeltaTime)
end

function M:OnItemClicked(InItem)
  if InItem.State == EImpressionButtonState.Enabled then
    self:SwitchEnableInteraction(false)
  end
  if self.OnItemClickFunc then
    self.OnItemClickFunc(InItem)
  end
end

function M:OnItemClickStart(InItem)
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    Child:Clear()
  end
  if self.OnItemClickStartFunc then
    self.OnItemClickStartFunc(InItem)
  end
end

function M:AddItem(InItem)
  local UIManager = UIManager(GWorld.GameInstance)
  local OptionStyle = InItem.OptionStyle ~= "" and InItem.OptionStyle
  local ItemUI = UIManager:CreateWidget(OptionStyle or self.ItemUIPathName)
  self.ScrollBox_TalkOptions:AddChild(ItemUI)
  local ListIdx = self:GetItemIndex(ItemUI)
  local InitParams = {}
  for Key, Value in pairs(InItem) do
    InitParams[Key] = Value
  end
  InitParams.SelectUI = InitParams.SelectUI or self
  InitParams.OptionText = InitParams.OptionText or InitParams.Text
  InitParams.OptionIdx = InitParams.OptionIdx or InitParams.Index
  InitParams.ListIdx = ListIdx
  InitParams.OnClickedDelegate = {
    self,
    self.OnItemClicked
  }
  InitParams.OnClickStartDelegate = {
    self,
    self.OnItemClickStart
  }
  InitParams.OnHoveredDelegate = {
    self,
    self.OnItemHoveredByDisplayIndex
  }
  InitParams.OnUnhoveredDelegate = {
    self,
    self.OnItemUnhoveredByDisplayIndex
  }
  ItemUI:Init(InitParams)
end

function M:AddItems(InItems)
  if not InItems then
    return
  end
  for _, InItem in ipairs(InItems) do
    self:AddItem(InItem)
  end
end

function M:SetItemsVisibility(InVisibility)
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    Child:SetVisibility(InVisibility)
  end
end

function M:ClearListItems()
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    if Child and Child.Clear then
      Child:Clear()
    end
  end
  self.ScrollBox_TalkOptions:ClearChildren()
  self.CurrentSelectItemIdx = -1
  self.LastSelectItemIdx = -1
  self.NextUpDownSelectTime = 0
  self:SwitchEnableUpDownEvents(false)
  self:SwitchEnableConfirmEvents(false)
end

function M:SwitchEnableUpDownEvents(bEnable)
  if bEnable then
    if self.bListeningUpDownEvents then
      return
    end
    self.bListeningUpDownEvents = true
    self:ListenUpDownEvents()
  else
    if not self.bListeningUpDownEvents then
      return
    end
    self.bListeningUpDownEvents = false
    self:UnlistenUpDownEvents()
  end
end

function M:ListenUpDownEvents()
  self:ListenForInputAction("TalkUpSelect", EInputEvent.IE_Pressed, true, {
    self,
    function()
      self:UpSelectAction()
    end
  })
  self:ListenForInputAction("TalkDownSelect", EInputEvent.IE_Pressed, true, {
    self,
    function()
      self:DownSelectAction()
    end
  })
end

function M:UnlistenUpDownEvents()
  self:StopListeningForInputAction("TalkUpSelect", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TalkDownSelect", EInputEvent.IE_Pressed)
end

function M:SwitchEnableConfirmEvents(bEnable)
  if bEnable then
    if self.bListeningConfirmEvents then
      return
    end
    self.bListeningConfirmEvents = true
    self:ListenForInputAction("TalkOption", EInputEvent.IE_Pressed, true, {
      self,
      function()
        self:OnCurrentItemPressed()
      end
    })
    self:ListenForInputAction("TalkOption", EInputEvent.IE_Released, true, {
      self,
      function()
        self:OnCurrentItemReleased()
      end
    })
  else
    if not self.bListeningConfirmEvents then
      return
    end
    self.bListeningConfirmEvents = false
    self:StopListeningForInputAction("TalkOption", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("TalkOption", EInputEvent.IE_Released)
  end
end

function M:UpdateImgMouse()
  if not self.Img_Mouse then
    return
  end
  if CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance) == "Mobile" then
    return
  end
  local TalkOptionNum = self:GetMaxSelectableIndex() + 1
  if TalkOptionNum < 2 then
    self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Img_Mouse:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:UpSelectAction()
  self:SwitchUpDownSelectAction(true)
end

function M:DownSelectAction()
  self:SwitchUpDownSelectAction(false)
end

function M:SwitchUpDownSelectAction(bUp)
  local CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  if CurrentTime < self.NextUpDownSelectTime then
    return
  end
  local TargetIdx = self:GetTargetSelectIdx(bUp)
  if not self:CheckTargetSelectIdx(TargetIdx) then
    return
  end
  self.NextUpDownSelectTime = CurrentTime + self.UpDownSelectCooldown
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", "", nil)
  self:SelectNewItem(TargetIdx)
end

function M:GetTargetSelectIdx(bUp)
  if bUp then
    return self.CurrentSelectItemIdx - 1
  else
    return self.CurrentSelectItemIdx + 1
  end
end

function M:CheckTargetSelectIdx(TargetIdx)
  local MaxIdx = self:GetMaxSelectableIndex()
  if TargetIdx < 0 or TargetIdx > MaxIdx then
    return false
  end
  return true
end

function M:SelectNewItem(NewItemIdx, bIsDefault)
  if bIsDefault then
    self.CurrentSelectItemIdx = NewItemIdx
    self:TriggerSelectByIndex(self.CurrentSelectItemIdx, true, true)
    self:ScrollIndexIntoView(self.CurrentSelectItemIdx)
    if self.OnSelectionChangedFunc then
      self.OnSelectionChangedFunc(self.CurrentSelectItemIdx, self.LastSelectItemIdx, true)
    end
    return
  end
  if self.CurrentSelectItemIdx == NewItemIdx then
    return
  end
  self.LastSelectItemIdx = self.CurrentSelectItemIdx
  self.CurrentSelectItemIdx = NewItemIdx
  self:TriggerSelectByIndex(self.LastSelectItemIdx, false)
  self:TriggerSelectByIndex(self.CurrentSelectItemIdx, true)
  self:ScrollIndexIntoView(self.CurrentSelectItemIdx)
  if self.OnSelectionChangedFunc then
    self.OnSelectionChangedFunc(self.CurrentSelectItemIdx, self.LastSelectItemIdx, false)
  end
end

function M:SwitchItemSelected(ItemUI, bIsSelected, bIsDefault)
  if not ItemUI then
    return
  end
  if bIsSelected then
    ItemUI:OnSelectItem(bIsDefault)
  else
    ItemUI:OnUnselectItem()
  end
end

function M:IsExtraSelectableEnabled()
  return self.Group_Button:GetVisibility() ~= ESlateVisibility.Collapsed
end

function M:IsExtraIndex(Index)
  if not self:IsExtraSelectableEnabled() then
    return false
  end
  return Index == self.ScrollBox_TalkOptions:GetChildrenCount()
end

function M:GetMaxSelectableIndex()
  local MaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  if self:IsExtraSelectableEnabled() then
    MaxIndex = MaxIndex + 1
  end
  return MaxIndex
end

function M:SwitchEnableImpressionItemClick(bBind)
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local ImpressionItem = self.ScrollBox_TalkOptions:GetChildAt(i)
    if ImpressionItem then
      ImpressionItem:SwitchEnableClickEvents(bBind)
    end
  end
end

function M:SwitchShowOptionUI(bShow)
  if bShow then
    self.VB_GroupItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.VB_GroupItem:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:GetItemByIndex(Index)
  return self.ScrollBox_TalkOptions:GetChildAt(Index)
end

function M:OnItemHovered(Index)
  self:SelectNewItem(Index)
  if self.OnItemHoveredFunc then
    self.OnItemHoveredFunc(Index)
  end
end

function M:OnItemHoveredByDisplayIndex(ItemIndex)
  self:OnItemHovered(ItemIndex - 1)
end

function M:OnItemUnhovered(Index)
  if self.OnItemUnhoveredFunc then
    self.OnItemUnhoveredFunc(Index)
  end
end

function M:OnItemUnhoveredByDisplayIndex(ItemIndex)
  self:OnItemUnhovered(ItemIndex - 1)
end

function M:OnExtraHovered()
  if not self:IsExtraSelectableEnabled() then
    return
  end
  local ExtraIndex = self.ScrollBox_TalkOptions:GetChildrenCount()
  self:SelectNewItem(ExtraIndex)
end

function M:TriggerExtraSelectable(bIsSelected, bIsDefault)
  self:OnExitButtonSelected(bIsSelected)
end

function M:TriggerSelectByIndex(Index, bIsSelected, bIsDefault)
  if self:IsExtraIndex(Index) then
    self:TriggerExtraSelectable(bIsSelected, bIsDefault)
    return
  end
  self:SwitchItemSelected(self:GetItemByIndex(Index), bIsSelected, bIsDefault)
end

function M:ScrollIndexIntoView(Index)
  if self:IsExtraIndex(Index) then
    return
  end
  local Item = self:GetItemByIndex(Index)
  if Item then
    self.ScrollBox_TalkOptions:ScrollWidgetIntoView(Item, true)
  end
end

function M:OnCurrentItemPressed()
  if self.CurrentSelectItemIdx < 0 then
    return
  end
  if self:IsExtraIndex(self.CurrentSelectItemIdx) then
    self:OnExitButtonPressed()
    return
  end
  local Item = self:GetItemByIndex(self.CurrentSelectItemIdx)
  if Item and Item.OnPressed then
    Item:OnPressed()
  end
end

function M:OnCurrentItemReleased()
  if self.CurrentSelectItemIdx < 0 then
    return
  end
  if self:IsExtraIndex(self.CurrentSelectItemIdx) then
    self:OnExitButtonClicked()
    return
  end
  local Item = self:GetItemByIndex(self.CurrentSelectItemIdx)
  if Item and Item.OnClicked then
    Item:OnClicked()
  end
end

function M:SetDefaultItem()
  self:SelectNewItem(0, true)
end

function M:GetItemIndex(Item)
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    if Child == Item then
      return i
    end
  end
  return -1
end

function M:GetCurrentItem()
  return self:GetItemByIndex(self.CurrentSelectItemIdx)
end

function M:UpdateKeyImg(IsGamePad, GamepadName)
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    if Child then
      Child:UpdateKeyImg(IsGamePad)
    end
  end
  if self.Img_Mouse then
    if IsGamePad then
      if "XBOX" == GamepadName then
        self.Img_Mouse:SetBrushResourceObject(Scroll_Xbox:get())
      else
        self.Img_Mouse:SetBrushResourceObject(Scroll_PS:get())
      end
    else
      self.Img_Mouse:SetBrushResourceObject(Scroll_Mouse:get())
    end
  end
end

return M
