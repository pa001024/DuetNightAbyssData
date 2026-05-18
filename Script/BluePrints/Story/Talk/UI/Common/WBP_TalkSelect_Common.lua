require("UnLua")
local MiscUtils = require("Utils.MiscUtils")
local Scroll_Mouse = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PC/T_Key_MouseScroll.T_Key_MouseScroll")
local Scroll_Xbox = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/XBOX/T_Key_LV.T_Key_LV")
local Scroll_PS = MiscUtils.LazyLoadObject("/Game/UI/Texture/Dynamic/Atlas/Key/PS5/T_Key_LV.T_Key_LV")

local function BuildExtraSelectable(Params)
  local function EmptyFunc()
  end
  
  local ExtraSelectable = Params and Params.ExtraSelectable or {}
  ExtraSelectable.IsEnabled = ExtraSelectable.IsEnabled or function()
    return false
  end
  ExtraSelectable.OnSelect = ExtraSelectable.OnSelect or EmptyFunc
  ExtraSelectable.OnUnselect = ExtraSelectable.OnUnselect or EmptyFunc
  ExtraSelectable.OnPressed = ExtraSelectable.OnPressed or EmptyFunc
  ExtraSelectable.OnReleased = ExtraSelectable.OnReleased or EmptyFunc
  return ExtraSelectable
end

local function BuildOnSelectionChangedFunc(Params)
  local function EmptyFunc()
  end
  
  return Params and Params.OnSelectionChanged or EmptyFunc
end

local function BuildOnItemHoveredFunc(Params)
  local function EmptyFunc()
  end
  
  return Params and Params.OnItemHovered or EmptyFunc
end

local M = Class()

function M:New()
  local Obj = setmetatable({}, {__index = M})
  return Obj
end

function M:Init(ParentWidget, Params)
  self.ItemUIPathName = Params and Params.ItemUIPathName
  self.ItemClickedInfo = nil
  self.DelayDestoryCount = 0
  self.NextUpDownSelectTime = 0
  self.UpDownSelectCooldown = 0.1
  self.ParentWidget = ParentWidget
  self.ScrollBox_TalkOptions = Params and Params.ScrollBox
  self.Img_Mouse = Params and Params.Img_Mouse
  self.CurrentSelectItemIdx = -1
  self.LastSelectItemIdx = -1
  self.bListeningUpDownEvents = false
  self.bListeningConfirmEvents = false
  self.ExtraSelectable = BuildExtraSelectable(Params)
  self.OnSelectionChangedFunc = BuildOnSelectionChangedFunc(Params)
  self.OnItemHoveredFunc = BuildOnItemHoveredFunc(Params)
  self:SwitchEnableUpDownEvents(false)
end

function M:ReceiveTick(InDeltaTime)
end

function M:BindItemClicked(InObj, InFunc)
  self.ItemClickedInfo = {}
  self.ItemClickedInfo.Obj = InObj
  self.ItemClickedInfo.Func = InFunc
end

function M:UnBindItemClicked()
  self.ItemClickedInfo = nil
end

function M:OnItemClicked(InItemIdx)
  if self.ItemClickedInfo then
    self.ItemClickedInfo.Func(self.ItemClickedInfo.Obj, InItemIdx)
  end
end

function M:OnItemClickStart()
  local ChildMaxIndex = self.ScrollBox_TalkOptions:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local Child = self.ScrollBox_TalkOptions:GetChildAt(i)
    Child:Clear()
  end
  self.ParentWidget:OnItemClickedStart()
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
  InitParams.OnItemClickedDelegate = InitParams.OnItemClickedDelegate or {
    self,
    self.OnItemClicked
  }
  InitParams.OnItemClickStartDelegate = InitParams.OnItemClickStartDelegate or {
    self,
    self.OnItemClickStart
  }
  local OriginalOnHoveredDelegate = InitParams.OnHoveredDelegate
  InitParams.OnHoveredDelegate = {
    self,
    function(_, ItemIndex)
      self:OnItemHoveredByDisplayIndex(ItemIndex)
      if OriginalOnHoveredDelegate and OriginalOnHoveredDelegate[1] and OriginalOnHoveredDelegate[2] then
        OriginalOnHoveredDelegate[2](OriginalOnHoveredDelegate[1], ItemIndex)
      end
    end
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
  self.ParentWidget:ListenForInputAction("TalkUpSelect", EInputEvent.IE_Pressed, true, {
    self.ParentWidget,
    function()
      self:UpSelectAction()
    end
  })
  self.ParentWidget:ListenForInputAction("TalkDownSelect", EInputEvent.IE_Pressed, true, {
    self.ParentWidget,
    function()
      self:DownSelectAction()
    end
  })
end

function M:UnlistenUpDownEvents()
  self.ParentWidget:StopListeningForInputAction("TalkUpSelect", EInputEvent.IE_Pressed)
  self.ParentWidget:StopListeningForInputAction("TalkDownSelect", EInputEvent.IE_Pressed)
end

function M:SwitchEnableConfirmEvents(bEnable)
  if bEnable then
    if self.bListeningConfirmEvents then
      return
    end
    self.bListeningConfirmEvents = true
    self.ParentWidget:ListenForInputAction("TalkOption", EInputEvent.IE_Pressed, true, {
      self.ParentWidget,
      function()
        self:OnCurrentItemPressed()
      end
    })
    self.ParentWidget:ListenForInputAction("TalkOption", EInputEvent.IE_Released, true, {
      self.ParentWidget,
      function()
        self:OnCurrentItemReleased()
      end
    })
  else
    if not self.bListeningConfirmEvents then
      return
    end
    self.bListeningConfirmEvents = false
    self.ParentWidget:StopListeningForInputAction("TalkOption", EInputEvent.IE_Pressed)
    self.ParentWidget:StopListeningForInputAction("TalkOption", EInputEvent.IE_Released)
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
  local CurrentTime = UE4.UGameplayStatics.GetRealTimeSeconds(self.ParentWidget)
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
    self.OnSelectionChangedFunc(self.CurrentSelectItemIdx, self.LastSelectItemIdx, true)
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
  self.OnSelectionChangedFunc(self.CurrentSelectItemIdx, self.LastSelectItemIdx, false)
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
  return self.ExtraSelectable.Widget ~= nil and self.ExtraSelectable.IsEnabled()
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

function M:GetItemByIndex(Index)
  return self.ScrollBox_TalkOptions:GetChildAt(Index)
end

function M:OnItemHovered(Index)
  self:SelectNewItem(Index)
  self.OnItemHoveredFunc(Index)
end

function M:OnItemHoveredByDisplayIndex(ItemIndex)
  self:OnItemHovered(ItemIndex - 1)
end

function M:OnExtraHovered()
  if not self:IsExtraSelectableEnabled() then
    return
  end
  local ExtraIndex = self.ScrollBox_TalkOptions:GetChildrenCount()
  self:SelectNewItem(ExtraIndex)
end

function M:TriggerExtraSelectable(bIsSelected, bIsDefault)
  if bIsSelected then
    self.ExtraSelectable.OnSelect(bIsDefault)
  else
    self.ExtraSelectable.OnUnselect()
  end
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
    self.ExtraSelectable.OnPressed()
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
    self.ExtraSelectable.OnReleased()
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
