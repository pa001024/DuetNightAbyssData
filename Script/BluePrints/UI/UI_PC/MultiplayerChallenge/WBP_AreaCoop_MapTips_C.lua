require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local AreaCoopLevelChooseModel = require("BluePrints.UI.UI_PC.MultiplayerChallenge.AreaCoop_LevelChoose_Model")

function M:Construct()
  self.Text_Coop:SetText(GText("UI_AreaCoop_Challenge_Coop"))
  self.Text_Monster:SetText(GText("UI_DUNGEON_MonsterType"))
  self.Text_BossRewards:SetText(GText("UI_HardBoss_Preview"))
  if self.Text_EliteTitle then
    self.Text_EliteTitle:SetText(GText("UI_Dungeon_SpecialMonster"))
  end
  self.EliteItem.ParentPage = self
  self.bFocusList_EliteProp = false
  self.Common_Button_Text_PC:SetText(GText("UI_HardBoss_Toward"))
  self.Common_Button_Text_PC:BindSingleEventOnClicked(self, self.OnGoClicked)
  if self.Key_Scroll and self.Key_Scroll.CreateCommonKey then
    self.Key_Scroll:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      },
      Desc = GText("UI_Controller_Check")
    })
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitListenEvent()
end

function M:Destruct()
  self:ClearListenEvent()
end

function M:Refresh(ChallengeId)
  local ChallengeData = DataMgr.MultiplayerChallenge[ChallengeId]
  if not ChallengeData then
    return
  end
  self.CurChallengeId = ChallengeId
  self.CurTeleportId = ChallengeData.TeleportId
  self:RefreshText(ChallengeData)
  self:RefreshMonsterList(ChallengeData)
  self:RefreshRewardsList(ChallengeData)
  self.EMScrollBox_1:ScrollToStart()
end

function M:RefreshText(ChallengeData)
  local TitleName = DataMgr.MultiplayerChallenge[self.CurChallengeId].TitleName
  local TeleportName = DataMgr.MultiplayerChallenge[self.CurChallengeId].TeleportName
  local ChallengeName = ChallengeData.ChallengeName
  self.Text_BossName:SetText(GText(TeleportName))
  self.Text_BossLevel:SetText(GText(TitleName))
  self.Text_BossDetail:SetText(GText(ChallengeName))
  local BossImageTexturePath = ChallengeData.ImgPath
  if self.ApplyBossImageByTexturePath then
    self:ApplyBossImageByTexturePath(BossImageTexturePath)
  end
end

function M:RefreshRewardsList(ChallengeData)
  if not self.ListView_Rewards then
    return
  end
  self.ListView_Rewards:ClearListItems()
  local DungeonIdList = ChallengeData.DungeonId
  if not DungeonIdList or 0 == #DungeonIdList then
    self.ListView_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local AllRewardViewIds = {}
  for _, DungeonId in ipairs(DungeonIdList) do
    local DungeonData = DataMgr.Dungeon[DungeonId]
    if DungeonData then
      local RewardViewId = DungeonData.DungeonRewardView or DungeonData.RewardView
      if RewardViewId then
        table.insert(AllRewardViewIds, RewardViewId)
      end
    end
  end
  if 0 == #AllRewardViewIds then
    self.ListView_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local AllRewardInfo = {}
  for _, RewardViewId in ipairs(AllRewardViewIds) do
    local RewardInfo = DataMgr.RewardView[RewardViewId]
    if RewardInfo then
      local Ids = RewardInfo.Id or {}
      local Types = RewardInfo.Type or {}
      for i = 1, #Ids do
        local ItemId = Ids[i]
        local Type = Types[i]
        local key = tostring(ItemId) .. ":" .. tostring(Type)
        if not AllRewardInfo[key] then
          local Content = NewObject(UIUtils.GetCommonItemContentClass())
          Content.UIName = "AreaCoopMapTips"
          Content.IsShowDetails = true
          Content.Id = ItemId
          Content.Icon = ItemUtils.GetItemIconPath(ItemId, Type)
          Content.Rarity = ItemUtils.GetItemRarity(ItemId, Type)
          Content.ItemType = Type
          AllRewardInfo[key] = Content
        end
      end
    end
  end
  local SortedAllRewardInfo = {}
  for _, RewardContent in pairs(AllRewardInfo) do
    table.insert(SortedAllRewardInfo, RewardContent)
  end
  table.sort(SortedAllRewardInfo, function(a, b)
    if a.Rarity == b.Rarity then
      return a.Id > b.Id
    else
      return a.Rarity > b.Rarity
    end
  end)
  if table.isempty(SortedAllRewardInfo) then
    self.ListView_Rewards:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.ListView_Rewards:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    for _, RewardContent in ipairs(SortedAllRewardInfo) do
      RewardContent.OnAddedToFocusPathEvent = {
        Obj = RewardContent,
        Callback = function(Content)
          self:OnItemFocus(Content)
        end
      }
      RewardContent.List = self.ListView_Rewards
      self.ListView_Rewards:AddItem(RewardContent)
    end
  end
end

function M:RefreshMonsterList(ChallengeData)
  if not self.ListView_Monster then
    return
  end
  local DungeonIdList = ChallengeData.DungeonId
  if not DungeonIdList or 0 == #DungeonIdList then
    self.ListView_Monster:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local LastDungeonId = DungeonIdList[#DungeonIdList]
  self.CurSelectedDungeonId = LastDungeonId
  local MonsterPreview = AreaCoopLevelChooseModel:GetMonsterPreviewData(LastDungeonId)
  if not (MonsterPreview and MonsterPreview.List) or 0 == #MonsterPreview.List then
    self.ListView_Monster:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.MonsterWeaknessIcon = MonsterPreview.WeaknessIcon or {}
  self.ListView_Monster:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.ListView_Monster.ClearListItems then
    self.ListView_Monster:ClearListItems()
  end
  self.MonsterIdToItem = {}
  self.DisplayMonsters = MonsterPreview.List
  self.MonsterIdToIndex = {}
  for i, id in ipairs(self.DisplayMonsters) do
    self.MonsterIdToIndex[id] = i
  end
  self.NowSelectingIndex = 1
  local MonsterItemContentClass = LoadClass("/Game/UI/WBP/Play/Widget/Depute/MonsterInfo_Tab_Item_Content.MonsterInfo_Tab_Item_Content")
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  for _, MonsterId in ipairs(MonsterPreview.List) do
    local MonsterData = DataMgr.Monster[MonsterId]
    if MonsterData and GameState and GameState.IsUnitRelease and GameState.IsUnitRelease(MonsterId) then
      local Content = NewObject(MonsterItemContentClass)
      Content.ParentWidget = self
      Content.MonsterId = MonsterId
      Content.DisableSelect = true
      Content.SoundEvent = "event:/ui/common/click_mid"
      Content.WeaknessIcon = self.MonsterWeaknessIcon[MonsterId]
      Content.NeedFocusable = true
      Content.OnAddedToFocusPathEvent = {
        Obj = Content,
        Callback = function(Content)
          self:OnItemFocus(Content)
        end
      }
      Content.List = self.ListView_Monster
      self.ListView_Monster:AddItem(Content)
    end
  end
  if self.CurSelectedDungeonId then
    self:InitEliteItem(self.CurSelectedDungeonId)
  end
end

function M:ClosePanel(IsImmediately)
  if self.ChanllengeTips and self.ChanllengeTips:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
    if IsImmediately then
      self.ChanllengeTips:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.ChanllengeTips:PlayAnimation(self.ChanllengeTips.Out)
      return true
    end
  end
end

function M:CloseStyleOfPlay()
  local StyleOfPlay = UIManager(self):GetUIObj("StyleOfPlay")
  if StyleOfPlay then
    StyleOfPlay:PlayOutAnim()
  end
end

function M:OnGoClicked()
  self:CloseStyleOfPlay()
  if self.Parent and self.Parent.OnConveyClicked then
    self.Parent:OnConveyClicked(true)
  else
    ScreenPrint("AreaCoop_MapTips: OnGoClicked without valid CurTeleportId")
  end
  if self.Parent and self.Parent.MainMap then
    return
  end
  if not self.CurTeleportId then
    return
  end
end

function M:SetTabItemSelection(Item)
  if self.SelectingItem and self.SelectingItem ~= Item and self.SelectingItem.CancelTabSelect then
    self.SelectingItem:CancelTabSelect()
  end
  self.SelectingItem = Item
end

function M:SelectMonsterInfoItem(MonsterId)
  if not self.DisplayMonsters or 0 == #self.DisplayMonsters then
    return
  end
  local index = self.MonsterIdToIndex and self.MonsterIdToIndex[MonsterId]
  if not index then
    for i, id in ipairs(self.DisplayMonsters) do
      if id == MonsterId then
        index = i
        break
      end
    end
  end
  if index then
    self.NowSelectingIndex = index
  end
  local TabWidget = self.MonsterIdToItem and self.MonsterIdToItem[MonsterId]
  if TabWidget and TabWidget.ForceToSelection then
    TabWidget:ForceToSelection()
  else
    self.NeedSelectMonsterId = MonsterId
  end
  UIManager(self):LoadUINew("MonsterDetailInfo", self.CurSelectedDungeonId, self, MonsterId)
end

function M:ApplyBossImageByTexturePath(TexturePath)
  local IconPath = TexturePath
  if nil ~= IconPath then
    local ImageObject = LoadObject(IconPath)
    if not ImageObject:IsA(UE4.UTexture2D) then
      DebugPrint("IconPath需要纹理类型: 请检查填的路径: " .. tostring(ImageObject))
      return
    else
    end
    local ImgMat = self.Image_LinShiImage:GetDynamicMaterial()
    ImgMat:SetTextureParameterValue("IconMap", ImageObject)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY and self.EMScrollBox_1 and self.EMScrollBox_1.GetScrollOffset and not self.EMScrollBox_1:HasFocusedDescendants() then
    local Delta = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    if nil ~= Delta then
      local DeltaOffset = -1 * Delta * 20
      self:AddDeltaOffset(DeltaOffset)
    end
  end
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_RightThumbstick" == InKeyName then
      if self.ListView_Monster and self.ListView_Monster:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
        IsEventHandled = true
        self:EnterSelectMode(self.ListView_Monster)
      end
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      if self.ListView_Rewards and self.ListView_Rewards:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
        IsEventHandled = true
        self:EnterSelectMode(self.EliteItem.List_EliteProp)
      end
    elseif "Gamepad_FaceButton_Right" == InKeyName then
      if self.IsInSelectState then
        IsEventHandled = true
        self:LeaveSelectMode()
      else
        IsEventHandled = true
        self.Parent:ClosePanel()
      end
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      if self.IsInSelectState then
        IsEventHandled = true
        self:LeaveSelectMode()
      end
    elseif "Gamepad_FaceButton_Bottom" == InKeyName and not self.IsInSelectState then
      IsEventHandled = true
      self.Common_Button_Text_PC:OnBtnClicked()
    end
  end
  if IsEventHandled then
    DebugPrint("AreaCoop_MapTips: OnKeyDown handled: " .. tostring(InKeyName))
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    DebugPrint("AreaCoop_MapTips: OnKeyDown unhandled: " .. tostring(InKeyName))
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    self:InitKeyboardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:SetFocus()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  if self.Key_Scroll then
    if self.Key_Scroll.SetGamePadVisibility then
      self.Key_Scroll:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    elseif self.Key_Scroll.SetVisibility then
      self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:InitKeyboardView()
  self:LeaveSelectMode()
  self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Key_Scroll then
    if self.Key_Scroll.SetGamePadVisibility then
      self.Key_Scroll:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    elseif self.Key_Scroll.SetVisibility then
      self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function M:EnterSelectMode(ListView)
  if self.IsInSelectState then
    self:LeaveSelectMode()
  end
  self:SetectFirstItem(ListView)
  self.IsInSelectState = true
  self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:LeaveSelectMode()
  if not self.IsInSelectState then
    return
  end
  self:SetFocus()
  self.IsInSelectState = false
  self.Common_Button_Text_PC:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Key_Scroll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:SetectFirstItem(List)
  if List:HasAnyUserFocus() or List:HasFocusedDescendants() then
    return
  end
  if List then
    if List:GetNumItems() > 0 then
      local Item = List:GetItemAt(0)
      if Item then
        List:BP_NavigateToItem(Item)
        if Item.SelfWidget then
          Item.SelfWidget:SetFocus()
          self:ScrollItemIntoView(Item.SelfWidget)
        else
          local Widgets = List:GetDisplayedEntryWidgets(Item)
          if Widgets and Widgets:Num() > 0 then
            Widgets[1]:SetFocus()
            self:ScrollItemIntoView(Widgets[1])
          end
        end
      end
    else
      List:SetFocus()
      self:ScrollItemIntoView(List)
    end
  end
end

function M:MonsterNavigationDown()
  DebugPrint("MonsterNavigationDown")
  if self.ListView_Monster and self.ListView_Monster:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
    self:SetectFirstItem(self.ListView_Monster)
  end
end

function M:RewardNavigationUp()
  DebugPrint("RewardNavigationUp")
  if self.ListView_Rewards and self.ListView_Rewards:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
    self:SetectFirstItem(self.ListView_Rewards)
  end
end

function M:InitEliteItem(DungeonId)
  if not self.EliteItem then
    return
  end
  local DungeonData = DataMgr.Dungeon[DungeonId]
  if not DungeonData then
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local MonIds = DataMgr.ModDungeon2RewardId[DungeonId]
  if not MonIds or 0 == #MonIds then
    ScreenPrint("没找到对应地牢的精英怪物ID" .. tostring(DungeonId))
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local MonRewardId = MonIds[1]
  local MonRewardData = DataMgr.ModDungeonMonReward[MonRewardId]
  if not MonRewardData then
    self.EliteItem:SetVisibility(UE4.ESlateVisibility.Collapsed)
    return
  end
  local Content = {
    DungeonData = DungeonData,
    MonRewardData = MonRewardData,
    ParentWidget = self
  }
  self.EliteItem:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.EliteItem:OnListItemObjectSet(Content)
end

function M:OnNavigationDownInScrollBox()
  DebugPrint("OnNavigationDownInScrollBox")
  local eliteList = self.EliteItem and self.EliteItem.List_EliteProp
  local rewardList = self.ListView_Rewards
  local monsterList = self.ListView_Monster
  
  local function widgetHasFocus(w)
    return w and (w:HasAnyUserFocus() or w:HasFocusedDescendants())
  end
  
  local function listIsUsable(list)
    return list and list.GetVisibility and list:GetVisibility() ~= UIConst.VisibilityOp.Collapsed and list.GetNumItems and list:GetNumItems() > 0
  end
  
  local current
  if widgetHasFocus(eliteList) then
    current = "elite"
  elseif widgetHasFocus(rewardList) then
    current = "reward"
  elseif widgetHasFocus(monsterList) then
    current = "monster"
  end
  local candidates = {}
  if "elite" == current then
    candidates = {rewardList, monsterList}
  elseif "reward" == current then
    candidates = {monsterList}
  elseif "monster" == current then
    return
  else
    candidates = {
      eliteList,
      rewardList,
      monsterList
    }
  end
  for _, list in ipairs(candidates) do
    if listIsUsable(list) then
      self:SetectFirstItem(list)
      return
    end
  end
end

function M:OnNavigationUpInScrollBox()
  DebugPrint("OnNavigationUpInScrollBox")
  local eliteList = self.EliteItem and self.EliteItem.List_EliteProp
  local rewardList = self.ListView_Rewards
  local monsterList = self.ListView_Monster
  if monsterList and (monsterList:HasAnyUserFocus() or monsterList:HasFocusedDescendants()) then
    if rewardList and rewardList:GetNumItems() > 0 then
      self:SetectFirstItem(rewardList)
      return
    end
    if eliteList and eliteList:GetNumItems() > 0 then
      self:SetectFirstItem(eliteList)
      return
    end
    return
  elseif rewardList and (rewardList:HasAnyUserFocus() or rewardList:HasFocusedDescendants()) then
    if eliteList and eliteList:GetNumItems() > 0 then
      self:SetectFirstItem(eliteList)
      return
    end
    return
  elseif eliteList and (eliteList:HasAnyUserFocus() or eliteList:HasFocusedDescendants()) then
    return
  else
    if monsterList and monsterList:GetNumItems() > 0 then
      self:SetectFirstItem(monsterList)
      return
    end
    if rewardList and rewardList:GetNumItems() > 0 then
      self:SetectFirstItem(rewardList)
      return
    end
    if eliteList and eliteList:GetNumItems() > 0 then
      self:SetectFirstItem(eliteList)
      return
    end
    return
  end
end

function M:AddDeltaOffset(DeltaOffset)
  if not (self.EMScrollBox_1 and self.EMScrollBox_1.GetScrollOffset) or not self.EMScrollBox_1.SetScrollOffset then
    return
  end
  local CurrentOffset = self.EMScrollBox_1:GetScrollOffset()
  local EndOffset = 0
  if self.EMScrollBox_1.GetScrollOffsetOfEnd then
    EndOffset = self.EMScrollBox_1:GetScrollOffsetOfEnd()
  else
    EndOffset = CurrentOffset + math.abs(DeltaOffset or 0) + 1000
  end
  local NextOffset = math.min(math.max(CurrentOffset + (DeltaOffset or 0), 0), EndOffset)
  self.EMScrollBox_1:SetScrollOffset(NextOffset)
end

function M:ScrollItemIntoView(targetWidget)
  DebugPrint("ScrollItemIntoView", targetWidget)
  if not (targetWidget and self.EMScrollBox_1) or not self.EMScrollBox_1.ScrollWidgetIntoView then
    return
  end
  local widgetToScroll = targetWidget
  if widgetToScroll.SelfWidget then
    widgetToScroll = widgetToScroll.SelfWidget
  end
  self.EMScrollBox_1:ScrollWidgetIntoView(widgetToScroll, true, UE4.EDescendantScrollDestination.IntoView, 24.0)
end

function M:OnItemFocus(Content)
  DebugPrint("OnItemFocus")
  if not Content.SelfWidget then
    return
  end
  self:ScrollItemIntoView(Content.SelfWidget)
  if self.FocusList ~= Content.List then
    self.FocusList = Content.List
    self.FocusList:BP_SetSelectedItem(Content)
  end
end

return M
