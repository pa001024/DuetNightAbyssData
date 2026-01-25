require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Super.Construct(self)
  self.List_Weekly:ClearListItems()
  self:AddInputMethodChangedListen()
  self:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Weekly:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Weekly:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Weekly:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Weekly:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Btn_ShopExChange:SetGamePadImg("Y")
  self.List_Weekly.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.IsEmpty = true
    return Content
  end)
  self.Btn_ShopExChange:SetText(GText("UI_WeeklyDungeon_Goto"))
  self.Btn_ShopExChange.Button_Area.OnClicked:Add(self, self.OnGoToSystem)
end

function M:Destruct()
  self.List_Weekly.OnCreateEmptyContent:Unbind()
end

function M:InitContent(Parent)
  self:PlayAnimation(self.Switch)
  local DungeonData = CommonUtils.DeepCopy(DataMgr.WeeklySelectDungeon)
  table.sort(DungeonData, function(A, B)
    return A.Sequence < B.Sequence
  end)
  self.Parent = Parent
  self:UpdatKeyDisplay()
  self.List_Weekly:SetScrollbarVisibility(UIConst.VisibilityOp.Visible)
  for i = 1, #DungeonData do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ChapterId = DungeonData[i].ChapterId
    Content.Parent = Parent
    Content.DeputeWeekly = self
    Content.IsEmpty = false
    self.List_Weekly:AddItem(Content)
  end
  if CommonUtils.GetDeviceTypeByPlatformName() == "Mobile" then
    self.List_Weekly:SetScrollbarVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.List_Weekly:SetControlScrollbarInside(false)
  else
    self.List_Weekly:SetControlScrollbarInside(true)
  end
  self.List_Weekly:NavigateToIndex(0)
  self.List_Weekly:RequestFillEmptyContent()
  self.List_Weekly:RequestPlayEntriesAnim()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local WeeklyDungeonRewardLeft = Avatar.WeeklyDungeonRewardLeft
  self.Text_WeeklyDescNumNow:SetText(WeeklyDungeonRewardLeft)
  self.Text_WeeklyDescNumTotal:SetText(DataMgr.GlobalConstant.DungeonRewardRefresh.ConstantValue)
  if WeeklyDungeonRewardLeft > 0 then
    if self.ColorNowNormal then
      self.Text_WeeklyDescNumNow:SetColorAndOpacity(self.ColorNowNormal)
    else
      self.Text_WeeklyDescNumNow:SetColorAndOpacity(self.ColorNowEmpty)
    end
  end
  self.Text_WeeklyDescNumTitle:SetText(GText("UI_WeeklyDungeon_ChancesRemain"))
end

function M:SetBtn_ShopExChangeState(bGamePad)
  if bGamePad then
    self.Btn_ShopExChange:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Btn_ShopExChange:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:CreateAndAddEmptyItem()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.IsEmpty = true
  self.List_Weekly:AddItem(Content)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if IsUseKeyAndMouse then
    return
  elseif self:HasFocusedDescendants() or self:HasAnyUserFocus() then
    self.List_Weekly:NavigateToIndex(0)
  end
end

function M:UpdatKeyDisplay()
  local Item = UIManager(self):GetUIObj("StyleOfPlay")
  if not Item then
    return
  end
  local BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.Parent.CloseSelf,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    }
  }
  Item:UpdateOtherPageTab(BottomKeyInfo)
end

function M:OnGoToSystem()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  PageJumpUtils:JumpToShopPage(nil, nil, nil, "WeeklyDungeonShop")
end

return M
