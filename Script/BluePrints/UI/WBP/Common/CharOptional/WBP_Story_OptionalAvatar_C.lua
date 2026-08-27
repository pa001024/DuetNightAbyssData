require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local ItemInStartDelay = 0.5
local ItemInInterval = 0.015
local ItemInTimerKey = "OptionalAvatarItemIn"

function M:OnLoaded(Params)
  M.Super.OnLoaded(self, Params)
  self.CurrentChooseWidget = nil
  self.CurrentChooseInfo = nil
  self.AllItemsWidget = {}
  self.CloseChoosePageFun = Params.CloseChoosePageFun
  self.Btn_Get:UnBindEventOnClicked(self, self.OpenConfirmPopUI)
  self.Btn_Get:BindEventOnClicked(self, self.OpenConfirmPopUI)
  self.Key_Check_GamePad:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "LS"}
    },
    Desc = GText("UI_Controller_CheckDetails")
  })
  self:InitFreshmenGiftContent()
  self:InitAllOptionalItemsInfo()
  self.Btn_Get:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Text_Title:SetText(GText("Freshmen_Gift"))
  self.Text_Tip:SetText(GText("Choose_Character"))
  self:PlayAnimationIn()
end

function M:InitFreshmenGiftContent()
  self.OptionalItemsList = {}
  for _, Data in pairs(DataMgr.FreshmenGift) do
    local CharId = Data.CharId
    local CharData = DataMgr.Char[CharId]
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.StuffId = CharId
    Content.SortPriority = Data.SortPriority or 0
    Content.StuffIcon = CharData.Icon
    Content.StuffName = GText(CharData.CharName)
    local BattleCharData = DataMgr.BattleChar and DataMgr.BattleChar[CharId]
    local Attribute = BattleCharData and BattleCharData.Attribute
    if Attribute then
      local IconName = "Armory_" .. Attribute
      Content.AttrIcon = "/Game/UI/Texture/Dynamic/Atlas/Armory/T_" .. IconName .. ".T_" .. IconName
    end
    table.insert(self.OptionalItemsList, Content)
  end
  table.sort(self.OptionalItemsList, function(A, B)
    if A.SortPriority ~= B.SortPriority then
      return A.SortPriority > B.SortPriority
    end
    return A.StuffId < B.StuffId
  end)
end

function M:InitAllOptionalItemsInfo()
  self.WB_Avatar:ClearChildren()
  for _, ItemInfo in ipairs(self.OptionalItemsList) do
    local Item = self:CreateWidgetNew("StoryOptionalAvatarItem")
    Item:SetVisibility(UE4.ESlateVisibility.Hidden)
    self.WB_Avatar:AddChildToWrapBox(Item)
    Item:Init(ItemInfo, self.ChangeChooseClickCallback, self)
    table.insert(self.AllItemsWidget, Item)
  end
  local ItemCount = #self.AllItemsWidget
  for Index, TargetWidget in ipairs(self.AllItemsWidget) do
    TargetWidget:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
    TargetWidget:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
    if 1 == Index then
      TargetWidget:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
    else
      TargetWidget:SetNavigationRuleExplicit(EUINavigation.Left, self.AllItemsWidget[Index - 1])
    end
    if Index == ItemCount then
      TargetWidget:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
    else
      TargetWidget:SetNavigationRuleExplicit(EUINavigation.Right, self.AllItemsWidget[Index + 1])
    end
  end
end

function M:ChangeChooseClickCallback(bSelectState, ChooseInfo)
  if self.CurrentChooseWidget then
    self.CurrentChooseWidget:SetSelected(false)
  end
  self.CurrentChooseInfo = bSelectState and ChooseInfo or nil
  if bSelectState then
    self.CurrentChooseWidget = ChooseInfo.ChooseWidget
    self.CurrentChooseWidget:SetSelected(true)
    self.Btn_Get:PlayAnimationIn()
  else
    self.CurrentChooseWidget = nil
    self.Btn_Get:PlayAnimationOut()
  end
end

function M:RefreshCurrentPlayerRole()
  local Avatar = GWorld:GetAvatar()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local AvatarInfo = AvatarUtils:GetDefaultBattleInfo(Avatar)
  local PlayerController = Player:GetController()
  PlayerController:SetAvatarInfo(CommonUtils.ObjId2Str(Avatar.Eid), AvatarInfo)
  Player:ChangeRole(nil, AvatarInfo)
  Player:CreateAutoAssistPhantoms(true)
end

function M:FinishChoosePage()
  self.CloseChoosePageFun()
  self:Close()
end

function M:OnFreshmenGiftSwitchCurrentChar(Ret, CharUuid)
  if CharUuid ~= self.PendingSwitchCharUuid then
    return
  end
  self:RemoveDispatcher(EventID.OnSwitchCurrentChar)
  self.PendingSwitchCharUuid = nil
  if not ErrorCode:Check(Ret) then
    self:StopAnimation(self.Out)
    self:PlayAnimation(self.In)
    return
  end
  self:RefreshCurrentPlayerRole()
  local CharId = GWorld:GetAvatar().Chars[CharUuid].CharId
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format(GText("Pal_Canbechanged"), GText(DataMgr.Char[CharId].CharName)))
  self:FinishChoosePage()
end

function M:SwitchCurrentCharAndRefresh(CharId)
  local Avatar = GWorld:GetAvatar()
  local CharUuid = Avatar:GetCharUuidByCharId(CharId)
  if CharUuid == Avatar.CurrentChar then
    self:RefreshCurrentPlayerRole()
    self:FinishChoosePage()
    return
  end
  self.PendingSwitchCharUuid = CharUuid
  self:RemoveDispatcher(EventID.OnSwitchCurrentChar)
  self:AddDispatcher(EventID.OnSwitchCurrentChar, self, self.OnFreshmenGiftSwitchCurrentChar)
  Avatar:SwitchCurrentChar(CharUuid)
end

function M:OpenConfirmPopUI()
  if not self.CurrentChooseInfo then
    return
  end
  local SelectedCharId = self.CurrentChooseInfo.ChooseId
  local ConfirmParams = {
    AutoFocus = true,
    ShortTextParams = {
      GText(DataMgr.Char[SelectedCharId].CharName)
    }
  }
  
  function ConfirmParams.RightCallbackFunction(_, _, ConfirmPopUI)
    local Avatar = GWorld:GetAvatar()
    Avatar:FreshmenGiftGetReward(SelectedCharId, function(Ret, CharId)
      if not ErrorCode:Check(Ret) then
        return
      end
      ConfirmPopUI:RemoveFirstItemInPopupQueue()
      self:PlayAnimationOut()
      UIUtils.ShowGetCharWeaponPage({
        Chars = {
          [CharId] = 1
        }
      }, function()
        self:SwitchCurrentCharAndRefresh(CharId)
      end, self, nil)
    end)
  end
  
  self:AddDelayFrameFunc(function()
    UIManager(self):ShowCommonPopupUI(100417, ConfirmParams, self)
  end, 1)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
end

function M:RefreshGamepadShortcutVisible(CurrentHoveredWidget)
  CurrentHoveredWidget = CurrentHoveredWidget or self:GetCurrentHoverItem()
  local bCanCheckDetails = not CurrentHoveredWidget or CurrentHoveredWidget:CanCheckDetails()
  local bShowGamepadBtnKey = UIUtils.IsGamepadInput()
  local Visibility = bShowGamepadBtnKey and bCanCheckDetails and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self.Key_Check_GamePad:SetVisibility(Visibility)
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:RefreshGamepadShortcutVisible()
end

function M:ScrollToTargetItem(TargetItem)
  self.ScrollBox_Avatar:ScrollWidgetIntoView(TargetItem)
end

function M:BP_GetDesiredFocusTarget()
  return self.CurrentChooseWidget or self.ScrollBox_Avatar
end

function M:OnBtnYes()
  if not self.CurrentChooseInfo then
    return
  end
  self.Btn_Get:OnBtnClicked()
end

function M:GetCurrentHoverItem()
  local AllChildren = self.WB_Avatar:GetAllChildren()
  for Index = 1, AllChildren:Length() do
    local ChildItem = AllChildren:GetRef(Index)
    if ChildItem:CheckIsInHovered() then
      return ChildItem
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    local CurrentFocusWidget = self.CurrentChooseWidget
    if CurrentFocusWidget and CurrentFocusWidget:CanCheckDetails() then
      CurrentFocusWidget:OnBtnCheckClicked()
      return UIUtils.Handled
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom and self.CurrentChooseInfo then
    self:OnBtnYes()
    return UIUtils.Handled
  end
  return M.Super.OnKeyDown(self, MyGeometry, InKeyEvent)
end

function M:PlayAnimationIn()
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/role_gift_pack_in_new", nil, nil)
  self:PlayItemInSequence()
end

function M:PlayAnimationOut()
  self:RemoveTimer(ItemInTimerKey)
  self:PlayAnimation(self.Out)
end

function M:PlayItemInSequence()
  self:RemoveTimer(ItemInTimerKey)
  local ItemCount = #self.AllItemsWidget
  if 0 == ItemCount then
    return
  end
  local PlayIndex = 0
  self:AddTimer(ItemInInterval, function()
    PlayIndex = PlayIndex + 1
    local Item = self.AllItemsWidget[PlayIndex]
    if IsValid(Item) then
      Item:PlayAnimationIn()
    end
    if PlayIndex >= ItemCount then
      self:RemoveTimer(ItemInTimerKey)
    end
  end, true, ItemInStartDelay, ItemInTimerKey)
end

return M
