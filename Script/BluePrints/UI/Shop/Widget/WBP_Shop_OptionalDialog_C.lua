require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:Construct()
  self.OptRewards = {}
  self.ParentWidget = nil
  self.OpenCallback = nil
  if self.List_Item and self.List_Item.OnCreateEmptyContent then
    self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = nil
      return Content
    end)
  end
end

function M:InitContent(Params, PopupData, Owner)
  self.Owner = Owner
  self:InitRewards(Params)
  self:InitCommonKey()
  self:InitListenEvent()
  local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
  self:RefreshOpInfoByInputDevice(CurInputDevice)
end

function M:InitRewards(Params)
  self.ParentWidget = Params.ParentWidget
  self.OpenCallback = Params.OpenCallback
  self.OptRewards = {}
  local SourceRewards = Params.OptRewards or {}
  for _, Reward in ipairs(SourceRewards) do
    if type(Reward) == "table" then
      if Reward.ResourceId then
        table.insert(self.OptRewards, {
          ResourceId = Reward.ResourceId,
          Count = Reward.Count or 1
        })
      end
    elseif type(Reward) == "number" then
      table.insert(self.OptRewards, {ResourceId = Reward, Count = 1})
    end
  end
  table.sort(self.OptRewards, function(A, B)
    return A.ResourceId < B.ResourceId
  end)
  self:InitView()
end

function M:InitView()
  self.List_Item:ClearListItems()
  for Index, RewardInfo in ipairs(self.OptRewards) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Count = RewardInfo.Count or 1
    Content.ResourceId = RewardInfo.ResourceId
    Content.ParentWidget = self
    
    function Content.AfterInitCallback(Widget)
      if 1 == Index then
        self:AddTimer(0.1, function()
          Widget:SetFocus()
        end, false)
      end
    end
    
    self.List_Item:AddItem(Content)
  end
  self.List_Item:RequestFillEmptyContent()
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:CloseSelf()
  self:Close()
  if self.RemoveFromParent then
    self:RemoveFromParent()
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  local CurrentHoveredWidget = self:GetCurrentHoverItem()
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.LeftThumb then
      if nil ~= CurrentHoveredWidget then
        CurrentHoveredWidget.Item_Optional:OpenItemMenu()
        IsEventHandled = true
      end
    elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      if nil ~= CurrentHoveredWidget then
        CurrentHoveredWidget:OnBtnOpenClicked()
        IsEventHandled = true
      end
      IsEventHandled = true
    end
  end
  return IsEventHandled
end

function M:GetCurrentHoverItem()
  local Displayed = self.List_Item:GetDisplayedEntryWidgets()
  if not Displayed or Displayed:Length() <= 0 then
    return nil
  end
  for i = 1, Displayed:Length() do
    local Entry = Displayed:GetRef(i)
    if Entry and (Entry.HasAnyFocus and Entry:HasAnyFocus() or Entry.HasAnyUserFocus and Entry:HasAnyUserFocus()) then
      return Entry
    end
  end
  return nil
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if IsUseKeyAndMouse then
    self:SwitchToPc()
  elseif CurInputDevice == ECommonInputType.Gamepad then
    self:SwitchToGamepad()
  end
end

function M:SwitchToPc()
  local Displayed = self.List_Item and self.List_Item:GetDisplayedEntryWidgets() or nil
  if not Displayed or Displayed:Length() <= 0 then
    return
  end
  for i = 1, Displayed:Length() do
    local Entry = Displayed:GetRef(i)
    if Entry and Entry.PlayAnimation and Entry.Normal then
      Entry:PlayAnimation(Entry.Normal)
    end
  end
end

function M:SwitchToGamepad()
  self.Owner:ShowGamepadShortcut(self.CheckItemBtnIdx)
  self.Owner:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
end

function M:SetDefaultFocus()
end

function M:InitCommonKey()
  self.CheckItemBtnIdx = self.Owner:InitGamepadShortcut({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_CheckDetails")
  }, 3)
end

function M:Destruct()
  if self.List_Item and self.List_Item.OnCreateEmptyContent then
    self.List_Item.OnCreateEmptyContent:Unbind()
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:OnMenuOpenChange(bIsOpen)
  if bIsOpen then
    self.Owner:HideAllGamepadShortcut()
  else
    self.Owner:ShowGamepadShortcut(self.CheckItemBtnIdx)
    self.Owner:ShowGamepadShortcut(self.Owner.GamepadCloseBtnIndex)
  end
end

return M
