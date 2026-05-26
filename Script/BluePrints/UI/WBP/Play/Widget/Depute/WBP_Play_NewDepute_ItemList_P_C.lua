require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Construct()
  self:AddInputMethodChangedListen()
  self.List_IronExp.OnCreateEmptyContent:Bind(self, self.CreateIronExpEmptyContent)
  self.Iron_SwitchTab:SetConfig({
    CacheKey = "Is_IronSurvival_SwitchTab",
    EventId = EventID.IronSurvivalSwitchTab,
    TextOn = "UI_DUNGEON_MODE_IRONMODE",
    TextOff = "UI_DUNGEON_MODE_NORMALMODE",
    UnlockRuleId = "IronMode",
    OnCheckLocked = function()
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        return not Avatar:CheckUIUnlocked("IronMode")
      end
      return false
    end
  })
  self:AddDispatcher(EventID.IronSurvivalSwitchTab, self, self.OnIronSwitchTab)
  if self.Text_Qa then
    self.Text_Qa:SetText(GText("UI_DUNGEON_MODE_IRONMODE"))
  end
  if self.Btn_Qa then
    self.Btn_Qa:BindEventOnClicked(self, self.OnOpenDeputeQaPopup)
  end
  self:AddDispatcher(EventID.NightBookSpecialRightUp, self, self.OnGamepadMenuPressed)
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.WS_Qa then
    self.WS_Qa:SetActiveWidgetIndex(IsGamepad and 1 or 0)
  end
  if IsGamepad and self.Key_Qa then
    self.Key_Qa:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = "Menu",
          Owner = self
        }
      }
    })
  end
  if not IsGamepad then
    self.Iron_SwitchTab.Key_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:InitContent(Parent)
  self.Parent = Parent
  self.IronExpLoaded = false
  local IsOn = EMCache:Get("Is_IronSurvival_SwitchTab", true) or false
  self.WS_List:SetActiveWidgetIndex(IsOn and 1 or 0)
  self:LoadDeputeList(Parent)
  if IsOn then
    self:LoadIronExpList(Parent)
    self.IronExpLoaded = true
  end
end

function M:OnIronSwitchTab(IsOn)
  self.WS_List:SetActiveWidgetIndex(IsOn and 1 or 0)
  if IsOn and not self.IronExpLoaded then
    self:LoadIronExpList(self.Parent)
    self.IronExpLoaded = true
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    local ActiveList = IsOn and self.List_IronExp or self.List_Depute
    ActiveList:NavigateToIndex(0)
  end
end

function M:LoadDeputeList(Parent)
  self.List_Depute:ClearListItems()
  local DungeonData = {}
  for _, v in pairs(DataMgr.SelectDungeon) do
    if not v.IronSurvival then
      table.insert(DungeonData, CommonUtils.DeepCopy(v))
    end
  end
  table.sort(DungeonData, function(A, B)
    return A.Sequence < B.Sequence
  end)
  self:LoadItemsToList(self.List_Depute, DungeonData, Parent)
end

function M:LoadIronExpList(Parent)
  self.List_IronExp:ClearListItems()
  local IronData = {}
  for _, v in pairs(DataMgr.SelectDungeon) do
    if v.IronSurvival then
      table.insert(IronData, CommonUtils.DeepCopy(v))
    end
  end
  table.sort(IronData, function(A, B)
    return A.Sequence < B.Sequence
  end)
  self:LoadItemsToList(self.List_IronExp, IronData, Parent)
  self:AddTimer(self.IntervalTime * (#IronData + 1), function()
    self.List_IronExp:RequestFillEmptyContent()
  end, false, 0, nil, true)
end

function M:CreateIronExpEmptyContent()
  local Content = NewObject(self.LevelCellContentClass)
  Content.IsEmpty = true
  return Content
end

function M:LoadItemsToList(List, DungeonData, Parent)
  local IsMobile = CommonUtils.GetDeviceTypeByPlatformName() == "Mobile"
  List:SetScrollbarVisibility(UIConst.VisibilityOp.Visible)
  local loadedItemCount = 0
  for i = 1, #DungeonData do
    self:AddTimer(self.IntervalTime * i, function()
      local Content = NewObject(self.LevelCellContentClass)
      Content.ChapterId = DungeonData[i].ChapterId
      Content.Parent = Parent
      List:AddItem(Content)
      if IsMobile then
        List:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
        List:SetControlScrollbarInside(false)
      else
        List:SetControlScrollbarInside(true)
      end
      loadedItemCount = loadedItemCount + 1
      if loadedItemCount > 0 then
        List:NavigateToIndex(0)
      end
    end, false, 0, nil, true)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, _)
  if CurInputDevice == ECommonInputType.Touch then
    if self.WS_Qa then
      self.WS_Qa:SetActiveWidgetIndex(0)
    end
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.Iron_SwitchTab.Key_01:SetVisibility(UE4.ESlateVisibility.Collapsed)
    if self.WS_Qa then
      self.WS_Qa:SetActiveWidgetIndex(0)
    end
    return
  else
    if self.WS_Qa then
      self.WS_Qa:SetActiveWidgetIndex(1)
    end
    if self.Key_Qa then
      self.Key_Qa:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = "Menu",
            Owner = self
          }
        }
      })
    end
    local IsOn = EMCache:Get("Is_IronSurvival_SwitchTab", true) or false
    local ActiveList = IsOn and self.List_IronExp or self.List_Depute
    if self:HasFocusedDescendants() or self:HasAnyUserFocus() then
      ActiveList:NavigateToIndex(0)
    end
  end
end

function M:OnOpenDeputeQaPopup()
  UIManager(self):ShowCommonPopupUI(UIConst.DeputeDetailPopupInfoId)
end

function M:OnGamepadMenuPressed()
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  if not self:HasFocusedDescendants() and not self:HasAnyUserFocus() then
    return
  end
  self:OnOpenDeputeQaPopup()
end

return M
