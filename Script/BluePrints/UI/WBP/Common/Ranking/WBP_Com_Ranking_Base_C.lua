require("UnLua")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local ComRankingUtils = require("BluePrints.UI.WBP.Common.Ranking.ComRankingUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
M._components = {
  "BluePrints.UI.WBP.Armory.MainComponent.Armory_PointerInputComponent"
}
local ItemTypeEnum = ComRankingUtils.ItemType

function M:Construct()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:InitRankingEmptyContent()
end

function M:InitRankingEmptyContent()
  if self.List_Ranking and self.List_Ranking.OnCreateEmptyContent then
    self.List_Ranking.OnCreateEmptyContent:Bind(self, self.OnCreateRankingEmptyContent)
  end
end

function M:OnCreateRankingEmptyContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.Empty = true
  local TabId = self.TabId or 1
  Content.ItemType = self.ItemTypeIndex and self.ItemTypeIndex[TabId] or ItemTypeEnum.Squad
  return Content
end

function M:SelectDefaultRankEntry()
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  local Index = 0
  self.NavigatedRankIndex = Index
  self.List_Ranking:NavigateToIndex(Index)
  self:RemoveTimer("RankingSelectDefaultEntry")
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    if self.IsGamePad and self.FocusSelectedListEntry then
      self:FocusSelectedListEntry(Index, true)
    else
      local Content = self:GetRankItemContentByIndex(Index)
      if Content and not Content.Empty then
        self:OnListRankItemClicked(Content, true)
      end
    end
  end, false, 0, "RankingSelectDefaultEntry", true)
end

function M:Destruct()
  self._bRankingShown = false
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:RemoveTimer("RankingPreviewReady")
  self.bAutoSelectingRankEntry = false
  self:RemoveTimer("RankingFillEmptyContent")
  self:RemoveTimer("RankingSelectDefaultEntry")
  self:RemoveTimer("RankingSyncEntryFocus")
  self:RemoveTimer("RankingDeferredScroll")
  self:UnbindAllFromAnimationFinished(self.Out)
  if self.List_Ranking and self.List_Ranking.OnCreateEmptyContent then
    self.List_Ranking.OnCreateEmptyContent:Unbind()
  end
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.OnListViewScrolled:Clear()
  if self.ActorController then
    self.ActorController:OnDestruct()
  end
  M.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Params = (...) or {}
  self.MainTab = self.Params.MainTab or {}
  self.SelfRankInfo = self.Params.SelfRankInfo or {}
  self.TopNRankInfo = self.Params.TopNRankInfo or {}
  self.ItemTypeIndex = self.Params.ItemTypeIndex or {}
  self.TopNRankKeys = self.Params.TopNRankKeys or {}
  self.PreviewActorTabId = self.Params.PreviewActorTabId or 1
  self.SquadKey = self:GetColumnKey(self.PreviewActorTabId, 4)
  self.Avatar = GWorld:GetAvatar()
  self.IsFirstOpen = true
  self._bRankingShown = false
  self:InitMainTab()
  self:InitSubTab()
  self:InitBackground(function()
    self:NotifyRankingPreviewReady()
  end)
  self:ScheduleRankingPreviewFallback()
end

local RANKING_PREVIEW_READY_FALLBACK_SEC = 0.8
local RANKING_PREVIEW_READY_DELAY_SEC = 0.08

function M:NotifyRankingPreviewReady()
  if self._bRankingShown or not IsValid(self) then
    return
  end
  self:RemoveTimer("RankingPreviewReady")
  self:AddTimer(RANKING_PREVIEW_READY_DELAY_SEC, function()
    self:ShowRankingUI()
  end, false, 0, "RankingPreviewReady", true)
end

function M:ScheduleRankingPreviewFallback()
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:AddTimer(RANKING_PREVIEW_READY_FALLBACK_SEC, function()
    self:ShowRankingUI()
  end, false, 0, "RankingPreviewReadyFallback", true)
end

function M:ForceHideStackUnderUI()
  local UiMgr = UIManager(self)
  local UnderUI = UiMgr and UiMgr:GetUnderState()
  if not UnderUI or not IsValid(UnderUI) then
    return
  end
  if UnderUI.CancelTweenOutSystemStackChange then
    UnderUI:CancelTweenOutSystemStackChange()
  end
  if UnderUI.SetUIVisibilityTag then
    UnderUI:SetUIVisibilityTag(UIConst.CommonHideTagName.UIStackChange, true, UE4.ESlateVisibility.Collapsed)
  elseif UnderUI.SetVisibility then
    UnderUI:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:ShowRankingUI()
  if self._bRankingShown or not IsValid(self) then
    return
  end
  self._bRankingShown = true
  self:RemoveTimer("RankingPreviewReadyFallback")
  self:RemoveTimer("RankingPreviewReady")
  self:ForceHideStackUnderUI()
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayInAnimation()
end

function M:InitMainTab()
  local function CreateSubWdiget()
    local SubWidgetInfo = self.MainTab.SubWidgetInfo
    
    if SubWidgetInfo then
      self.MainTabSubWidget = UIManager(self):CreateWidget(SubWidgetInfo.WidgetPath)
      if self.MainTabSubWidget then
        self.Tab.Pos_Common:AddChild(self.MainTabSubWidget)
        if self.MainTabSubWidget.Init then
          self.MainTabSubWidget:Init({Parent = self})
        end
      end
    end
  end
  
  CreateSubWdiget()
end

function M:InitSubTab()
  if not self.Params or not self.Params.Tabs then
    return
  end
  local Tabs = self.Params.Tabs
  if #Tabs > 1 then
    self.WS_Title:SetActiveWidgetIndex(1)
    self.SubTab:Init({
      Tabs = Tabs,
      SoundFunc = function()
        AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_sort_tab", nil, nil)
      end
    })
    self.SubTab:BindEventOnTabSelected(self, self.UpdateSubTab)
    self:UpdateSubTab(nil, {TabId = 1})
    self:AddTimer(0.1, function()
      self.SubTab:SelectTab(1)
      if self.IsGamePad and self.FocusSelectedItem then
        self:FocusSelectedItem()
      elseif self.IsGamePad and self.FocusSelectedListEntry then
        self:FocusSelectedListEntry(self.NavigatedRankIndex or 0, true)
      else
        self:SetFocus()
      end
    end, nil, nil, "DelaySelectTab", true)
    if self.BlockSubTabGamepadNavigation then
      self:BlockSubTabGamepadNavigation()
    end
  else
    self.WS_Title:SetActiveWidgetIndex(0)
    self.Text_Title:SetText(GText(Tabs[1].Text))
    self:UpdateSubTab(nil, {TabId = 1})
  end
end

function M:UpdateSubTab(TabWidget, TabInfo)
  self.TabId = TabInfo.TabId or 1
  self:UpdateRankInfos(TabInfo.TabId)
  self:UpdateSelfInfos(TabInfo.TabId)
  self:UpdateHeaderInfo(TabInfo.TabId)
  self:UpdateBottomKeyOnSubTabChange()
end

function M:UpdateHeaderInfo(TabId)
  if not self.Params or not self.Params.HeaderNames then
    return
  end
  local HeaderNames = self.Params.HeaderNames[TabId]
  if not HeaderNames then
    return
  end
  local QaParams = {
    OwnerWidget = self,
    TextContent = "",
    SoundFunc = function(Obj)
      AudioManager(Obj):PlayUISound(Obj, "event:/ui/common/click_btn_small", nil, nil)
    end
  }
  self.QaWidgets = {}
  for i, NameInfo in ipairs(HeaderNames) do
    self["Text_" .. i]:SetText(GText(NameInfo.Text))
    local QaWidget = self["Btn_Qa_" .. i]
    if NameInfo.QaText and QaWidget then
      QaParams.TextContent = GText(NameInfo.QaText)
      QaWidget:Init(QaParams)
      QaWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      table.insert(self.QaWidgets, QaWidget)
    else
      QaWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
  local ActiveWidget = self.Ranking_Myself.Switcher:GetActiveWidget()
  if ActiveWidget then
    for i, _ in ipairs(HeaderNames) do
      local ActiveSlot = UE4.UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(ActiveWidget["Area_0" .. i])
      local HeaderSlot = UE4.UWidgetLayoutLibrary.SlotAsHorizontalBoxSlot(self["Area_0" .. i])
      if ActiveSlot and HeaderSlot then
        HeaderSlot:SetSize(ActiveSlot.Size)
      end
    end
  end
end

function M:UpdateRankInfos(TabId)
  TabId = TabId or 1
  local TopNInfo = self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self.WS_Type:SetActiveWidget(self.Com_Empty)
    local EmptyText = self.Params.RankEmptyText or "UI_GuildBoss_NoPlayerData"
    self.Text_Empty:SetText(GText(EmptyText))
    if self.List_Ranking then
      self.List_Ranking:ClearListItems()
    end
    self.ValidItemNum = 0
    self.LastClickedItem = nil
    return
  end
  self.WS_Type:SetActiveWidget(self.List_Ranking)
  self.List_Ranking:ClearListItems()
  self.LastClickedItem = nil
  self.bRankingListScrollReady = false
  self.PendingMyselfScrollIndex = nil
  if not self.TopNContents then
    self.TopNContents = {}
  end
  self.TopNContents[TabId] = {}
  local TopNContens = self:GetTopNContens(TabId)
  for _, Content in ipairs(TopNContens) do
    self.List_Ranking:AddItem(Content)
  end
  self:RequestFillRankingEmptyContent()
  self:SelectDefaultRankEntry()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  self.List_Ranking.OnListViewScrolled:Clear()
  self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end

function M:RequestFillRankingEmptyContent()
  if not self.List_Ranking or not self.List_Ranking.RequestFillEmptyContent then
    self:MarkRankingListScrollReady()
    return
  end
  self:RemoveTimer("RankingFillEmptyContent")
  self:AddTimer(0.1, function()
    if not IsValid(self) or not self.List_Ranking then
      return
    end
    self.List_Ranking:RequestFillEmptyContent()
    self:MarkRankingListScrollReady()
  end, false, 0, "RankingFillEmptyContent", true)
end

function M:MarkRankingListScrollReady()
  self.bRankingListScrollReady = true
  self:FlushPendingMyselfScroll()
end

function M:FlushPendingMyselfScroll()
  local Index = self.PendingMyselfScrollIndex
  if nil == Index then
    return
  end
  self.PendingMyselfScrollIndex = nil
  if not IsValid(self) or not self.List_Ranking then
    return
  end
  self:ScrollRankListToIndex(Index)
  self:ApplyRankListSelection(Index, true)
end

function M:ScrollRankListToIndex(Index)
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  Index = Index or self.NavigatedRankIndex or 0
  if Index < 0 then
    Index = 0
  end
  if Index >= self.ValidItemNum then
    Index = self.ValidItemNum - 1
  end
  if self.List_Ranking.ScrollIndexIntoView then
    self.List_Ranking:ScrollIndexIntoView(Index)
  end
  self.List_Ranking:NavigateToIndex(Index)
end

function M:GetTopNContens(TabId)
  TabId = TabId or 1
  if not self.TopNContents then
    self.TopNContents = {}
    for i = 1, #self.TopNRankInfo do
      self.TopNContents[i] = {}
    end
  end
  if not ComRankingUtils.IsEmptyTable(self.TopNContents[TabId]) then
    self.ValidItemNum = #self.TopNContents[TabId]
    return self.TopNContents[TabId]
  end
  local TopNInfo = self.TopNRankInfo[TabId]
  if not TopNInfo or ComRankingUtils.IsEmptyTable(TopNInfo) then
    self.ValidItemNum = 0
    return self.TopNContents[TabId]
  end
  local ItemType = self.ItemTypeIndex[TabId]
  local RankCount = 0
  for _, RankInfo in ipairs(TopNInfo or {}) do
    RankCount = RankCount + 1
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ParentWidget = self
    Content.ItemType = ItemType
    Content.SelfAvatar = self.Avatar
    Content.CallbackObj = self
    Content.ClickCallback = self.OnListRankItemClicked
    Content.MenuOpenCallback = self.OnHeadMenuOpenChanged
    Content.RankInfo = RankInfo
    Content.Colum03Text = self:GetColumnInfo(RankInfo, 3)
    Content.RankInfo.RankNum = RankCount
    if ItemType == ItemTypeEnum.Squad then
      Content.RoleInfo, Content.PetInfo = self:GetColumnInfo(RankInfo, 4)
    else
      Content.Colum04Text = self:GetColumnInfo(RankInfo, 4)
    end
    if RankInfo.Uid == self.Avatar.Uid then
      self.SelfRankInfo[TabId].RankNum = RankCount
    end
    table.insert(self.TopNContents[TabId], Content)
  end
  self.ValidItemNum = RankCount
  return self.TopNContents[TabId]
end

function M:GetColumnInfo(RankInfo, Column)
  local TabId = self.TabId or 1
  local ItemType = self.ItemTypeIndex[TabId]
  local Keys = self.TopNRankKeys[TabId]
  local Column03Key = self:GetColumnKey(TabId, 3) or "Score"
  local Column04Key = self:GetColumnKey(TabId, 4) or "MaxSquad"
  local TextMaps = self.Params.TopNRankTextMap and self.Params.TopNRankTextMap[TabId]
  local Column03TextMap = TextMaps and TextMaps.Column03TextMap
  local Column04TextMap = TextMaps and TextMaps.Column04TextMap
  if 3 == Column then
    local Value = RankInfo[Column03Key]
    if nil == Value then
      return nil
    end
    if not Column03TextMap then
      return Value
    end
    return string.format(GText(Column03TextMap), Value)
  elseif 4 == Column then
    if ItemType == ItemTypeEnum.Squad then
      return ComRankingUtils.GetSquadInfo(RankInfo[Column04Key])
    else
      local Value = RankInfo[Column04Key]
      if nil == Value then
        return nil
      end
      if not Column04TextMap then
        return Value
      end
      return string.format(GText(Column04TextMap), Value)
    end
  end
end

function M:GetColumnKey(TabId, Column)
  local Columns = self.TopNRankKeys[TabId]
  if not Columns then
    return
  end
  if 3 == Column then
    return Columns.Column03Key
  elseif 4 == Column then
    return Columns.Column04Key
  end
end

function M:UpdateSelfInfos(TabId)
  TabId = TabId or 1
  local SelfInfo = self.SelfRankInfo[TabId]
  if not SelfInfo or ComRankingUtils.IsEmptyTable(SelfInfo) then
    self.Ranking_Myself:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  self.Ranking_Myself:SetVisibility(UIConst.VisibilityOp.Visible)
  local Content = self:GetSelfContent(TabId)
  self.Ranking_Myself:OnListItemObjectSet(Content)
  if self.Ranking_Myself.Btn_Aera then
    self.Ranking_Myself.Btn_Aera.OnPressed:Clear()
  end
end

function M:GetSelfContent(TabId)
  TabId = TabId or 1
  if not self.SelfContents then
    self.SelfContents = {}
    for i = 1, #self.SelfRankInfo do
      self.SelfContents[i] = {}
    end
  end
  if not ComRankingUtils.IsEmptyTable(self.SelfContents[TabId]) then
    return self.SelfContents[TabId]
  end
  local CurRankInfo = self.SelfRankInfo[TabId]
  local CurItemType = self.ItemTypeIndex[TabId]
  if not CurRankInfo or nil == CurItemType then
    return
  end
  local RankInfo = {}
  RankInfo.RankNum = CurRankInfo.RankNum or -1
  RankInfo.RankNumText = CurRankInfo.RankNumText
  RankInfo.HeadIconId = self.Avatar.HeadIconId
  RankInfo.HeadFrameId = self.Avatar.HeadFrameId
  RankInfo.Level = self.Avatar.Level
  RankInfo.Nickname = self.Avatar.Nickname
  RankInfo.TitleBefore = self.Avatar.TitleBefore
  RankInfo.TitleAfter = self.Avatar.TitleAfter
  RankInfo.TitleFrame = self.Avatar.TitleFrame
  local Column03Text = self:GetColumnInfo(CurRankInfo, 3)
  if CurItemType == ItemTypeEnum.Squad then
    local RoleInfo, PetInfo = self:GetColumnInfo(CurRankInfo, 4)
    self.SelfContents[TabId].RoleInfo = RoleInfo
    self.SelfContents[TabId].PetInfo = PetInfo
  else
    self.SelfContents[TabId].Colum04Text = self:GetColumnInfo(CurRankInfo, 4)
  end
  self.SelfContents[TabId].ParentWidget = self
  self.SelfContents[TabId].ItemType = CurItemType
  self.SelfContents[TabId].RankInfo = RankInfo
  self.SelfContents[TabId].Colum03Text = Column03Text
  self.SelfContents[TabId].CallbackObj = self
  self.SelfContents[TabId].ClickCallback = self.OnMyselfButtonClicked
  return self.SelfContents[TabId]
end

function M:InitBackground(OnReady)
  local BgParams = self.Params.BgParams
  local BgWidgetPath = BgParams and BgParams.BgWidgetPath
  local HasBGWidget = BgParams and BgWidgetPath
  self.IsShowActor = not HasBGWidget
  if self.IsShowActor then
    self:InitPreviewScene(OnReady)
  else
    self:InitBackgroundImage()
    if OnReady then
      OnReady()
    end
  end
end

function M:InitBackgroundImage()
end

function M:InitPreviewScene(OnReady)
  local TopNInfo = self.TopNRankInfo[self.PreviewActorTabId] or {}
  local WeaponModel, TopOneSquad
  if not ComRankingUtils.IsEmptyTable(TopNInfo) then
    TopOneSquad = TopNInfo[1][self.SquadKey]
  end
  if not TopOneSquad or "" == TopOneSquad then
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = self.Avatar.Chars[self.Avatar.CurrentChar],
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    WeaponModel = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
  else
    local DummyAvatar = self:CreateDummyAvatarByRankInfo(TopNInfo[1])
    local _, CharModel = next(DummyAvatar.Chars)
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = CharModel,
      Avatar = DummyAvatar,
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    local _, Weapon = next(DummyAvatar.Weapons)
    WeaponModel = Weapon
  end
  self.ActorController:OnOpened()
  if WeaponModel then
    self.ActorController:ChangeWeaponModel(WeaponModel)
    local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
  if OnReady then
    local ActorControllerRef = self.ActorController
    local OriginalOnFirst = ActorControllerRef.OnFirstBecomeViewTarget
    
    function ActorControllerRef.OnFirstBecomeViewTarget()
      if OriginalOnFirst then
        OriginalOnFirst()
      end
      if IsValid(self) and not self._bRankingShown then
        OnReady()
      end
    end
    
    if ActorControllerRef.IsControled then
      OnReady()
    end
  end
end

function M:CreateDummyAvatarByRankInfo(RankInfo)
  if not RankInfo then
    return
  end
  local SquadStr = RankInfo[self.SquadKey]
  if not SquadStr or "" == SquadStr then
    return
  end
  local Squad = SerializeUtils:UnSerialize(SquadStr)
  if not Squad or ComRankingUtils.IsEmptyTable(Squad) then
    return
  end
  local CharacterInfo = Squad.AvatarInfo and Squad.AvatarInfo.CharacterInfo
  if not CharacterInfo then
    return
  end
  if ComRankingUtils.IsEmptyTable(CharacterInfo.RoleInfo) or ComRankingUtils.IsEmptyTable(CharacterInfo.MeleeWeapon) then
    return
  end
  local DummyAvatar = {}
  local Params = {
    CharInfos = {
      CharacterInfo.RoleInfo
    },
    WeaponInfos = {
      CharacterInfo.MeleeWeapon
    }
  }
  ArmoryUtils._CreateDummyAvatarCustom(DummyAvatar, Params)
  return DummyAvatar
end

function M:SwitchRankingPlayerPreview(RankInfo)
  if not self.ActorController or not RankInfo then
    return
  end
  local DummyAvatar = self:CreateDummyAvatarByRankInfo(RankInfo)
  if DummyAvatar then
    local _, CharModel = next(DummyAvatar.Chars)
    local _, WeaponModel = next(DummyAvatar.Weapons)
    local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
    self.ActorController:SetAvatar(DummyAvatar)
    self.ActorController:ChangeCharModel(CharModel)
    self.ActorController:ChangeWeaponModel(WeaponModel)
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
  if self.IsGamePad then
    if IsHovered and Item and not Item.Empty then
      self.NavigatedRankIndex = (Item.RankInfo and Item.RankInfo.RankNum or 1) - 1
      if self.LastClickedItem ~= Item then
        self:OnListRankItemClicked(Item, true)
      end
    end
    return
  end
  if Item.Empty then
    return
  end
  local ItemWidget = Item.SelfWidget
  if not ItemWidget then
    return
  end
  if self.LastClickedItem == Item then
    return
  end
  if IsHovered then
    ItemWidget:StopAnimation(ItemWidget.UnHover)
    ItemWidget:PlayAnimation(ItemWidget.Hover)
  else
    ItemWidget:StopAnimation(ItemWidget.Hover)
    ItemWidget:PlayAnimation(ItemWidget.UnHover)
  end
end

function M:OnListRankScrolled()
  if not self.LastClickedItem then
    return
  end
  local ItemWidget = self.LastClickedItem.SelfWidget
  if not ItemWidget then
    return
  end
  ItemWidget.Head_Anchor:Close()
end

function M:OnListRankItemClicked(Content, bForceRefresh)
  if Content.Empty then
    return
  end
  if not bForceRefresh and not self.bAutoSelectingRankEntry then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  end
  local bSameItem = self.LastClickedItem == Content
  if bSameItem and not bForceRefresh then
    local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    if IsGamePad and not self.bAutoSelectingRankEntry then
      self:OpenHeadMenuForRankContent(Content)
    end
    return
  end
  local ItemWidget = Content.SelfWidget or self:GetRankItemWidgetFromContent(Content)
  if not ItemWidget then
    self.LastClickedItem = Content
    if Content.RankInfo and Content.RankInfo.RankNum then
      self.NavigatedRankIndex = Content.RankInfo.RankNum - 1
    end
    return false
  end
  if self.IsShowActor then
    if not bSameItem and not self.IsFirstOpen then
      self:SwitchRankingPlayerPreview(Content.RankInfo)
    end
    self.IsFirstOpen = nil
  end
  ItemWidget:PlaySelectedAnimation()
  if self.LastClickedItem and self.LastClickedItem ~= Content then
    local LastItemWidget = self.LastClickedItem.SelfWidget
    if LastItemWidget then
      LastItemWidget:PlayNormalAnimation()
    end
  end
  self.LastClickedItem = Content
  if Content.RankInfo and Content.RankInfo.RankNum then
    self.NavigatedRankIndex = Content.RankInfo.RankNum - 1
  end
  return true
end

function M:ApplyRankListSelection(Index, bForceRefresh)
  local Content = self:GetRankItemContentByIndex(Index)
  if not Content or Content.Empty then
    return false
  end
  return self:OnListRankItemClicked(Content, false ~= bForceRefresh) == true
end

function M:GetRankItemContentByIndex(Index)
  Index = Index or self.NavigatedRankIndex or 0
  local TabId = self.TabId or 1
  local Contents = self.TopNContents and self.TopNContents[TabId]
  if Contents and Contents[Index + 1] and not Contents[Index + 1].Empty then
    return Contents[Index + 1]
  end
  if self.List_Ranking and self.List_Ranking.GetItemAt then
    local Item = self.List_Ranking:GetItemAt(Index)
    if Item and not Item.Empty then
      return Item
    end
  end
  return nil
end

function M:GetRankItemWidgetFromContent(Content)
  if not Content or Content.Empty then
    return nil
  end
  if Content.SelfWidget then
    return Content.SelfWidget
  end
  if not self.List_Ranking then
    return nil
  end
  local Index = (Content.RankInfo and Content.RankInfo.RankNum or 1) - 1
  local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Ranking, Index)
  if EntryWidget and EntryWidget.ActiveWidget then
    return EntryWidget.ActiveWidget
  end
  return EntryWidget
end

function M:OpenHeadMenuForRankContent(Content)
  if not Content or Content.Empty then
    return false
  end
  local ItemWidget = self:GetRankItemWidgetFromContent(Content)
  if ItemWidget and ItemWidget.OnHeadPlayerClicked then
    ItemWidget:OnHeadPlayerClicked()
    return true
  end
  if ItemWidget and ItemWidget.Head_Anchor then
    ItemWidget.Head_Anchor:Open(true)
    return true
  end
  return false
end

function M:FocusSelectedListEntry(Index, bSilent)
  if not (self.List_Ranking and self.ValidItemNum) or self.ValidItemNum <= 0 then
    return
  end
  Index = Index or self.NavigatedRankIndex or 0
  if Index < 0 then
    Index = 0
  end
  if Index >= self.ValidItemNum then
    Index = self.ValidItemNum - 1
  end
  if bSilent then
    self.bAutoSelectingRankEntry = true
  end
  self.NavigatedRankIndex = Index
  local bDeferScroll = self.PendingMyselfScrollIndex ~= nil
  if not bDeferScroll then
    self:ScrollRankListToIndex(Index)
  end
  local Content = self:GetRankItemContentByIndex(Index)
  local bSameItem = Content and self.LastClickedItem == Content
  local bSelectionApplied = false
  
  local function TryApplySelection()
    if not IsValid(self) then
      return
    end
    if bSilent and bSameItem then
      return
    end
    if bSelectionApplied then
      return
    end
    bSelectionApplied = self:ApplyRankListSelection(Index, true) == true
  end
  
  TryApplySelection()
  
  local function SyncEntryFocus()
    if not IsValid(self) or not self.List_Ranking then
      return
    end
    local EntryWidget = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Ranking, Index)
    if EntryWidget and EntryWidget.SetFocus then
      EntryWidget:SetFocus()
    elseif self.List_Ranking.SetFocus then
      self.List_Ranking:SetFocus()
    end
  end
  
  local function EndSilentSelect()
    if bSilent and IsValid(self) then
      self.bAutoSelectingRankEntry = false
    end
  end
  
  SyncEntryFocus()
  self:RemoveTimer("RankingSyncEntryFocus")
  self:RemoveTimer("RankingDeferredScroll")
  self:AddTimer(0, function()
    if not bDeferScroll then
      self:ScrollRankListToIndex(Index)
    end
    SyncEntryFocus()
    TryApplySelection()
    EndSilentSelect()
  end, false, 0, "RankingSyncEntryFocus", true)
  self:AddTimer(0.05, function()
    if not IsValid(self) then
      return
    end
    if not bDeferScroll then
      self:ScrollRankListToIndex(Index)
    end
    TryApplySelection()
  end, false, 0, "RankingDeferredScroll", true)
end

function M:GetLastClickedRankItemWidget()
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    Content = self:GetRankItemContentByIndex(self.NavigatedRankIndex or 0)
  end
  return self:GetRankItemWidgetFromContent(Content)
end

function M:OnListRankItemGamepadConfirm()
  local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if not IsGamePad then
    return false
  end
  local Content = self.LastClickedItem
  if not Content or Content.Empty then
    Content = self:GetRankItemContentByIndex(self.NavigatedRankIndex or 0)
  end
  return self:OpenHeadMenuForRankContent(Content)
end

function M:OnMyselfButtonClicked()
  if not self.SelfContents then
    return
  end
  local Content = self.SelfContents[self.TabId]
  local SelfRankNum = Content.RankInfo.RankNum
  if SelfRankNum and SelfRankNum >= 1 then
    if self.LastClickedItem and self.LastClickedItem.RankInfo.RankNum ~= SelfRankNum then
      local LastItemWidget = self.LastClickedItem and self.LastClickedItem.SelfWidget or nil
      if LastItemWidget then
        LastItemWidget:PlayNormalAnimation()
      end
      self.LastClickedItem = nil
    end
    local Index = SelfRankNum - 1
    local IsGamePad = self.IsGamePad or UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
    if not IsGamePad and not self.bRankingListScrollReady then
      self.PendingMyselfScrollIndex = Index
    end
    if self.FocusSelectedListEntry then
      self:FocusSelectedListEntry(Index, true)
    else
      self.List_Ranking:NavigateToIndex(SelfRankNum - 1)
      local TargetContent = self:GetRankItemContentByIndex(SelfRankNum - 1)
      if TargetContent and not TargetContent.Empty then
        self:OnListRankItemClicked(TargetContent, true)
      end
    end
  end
end

function M:TryCloseListRankItemHeadMenu()
  local ItemWidget = self:GetLastClickedRankItemWidget()
  if ItemWidget and ItemWidget.Head_Anchor and ItemWidget.Head_Anchor:IsOpen() then
    ItemWidget.Head_Anchor:Close()
    if self.FocusSelectedItem then
      self:FocusSelectedItem()
    elseif ItemWidget.SetFocus then
      ItemWidget:SetFocus()
    end
    return true
  end
  return false
end

function M:OnHeadMenuOpenChanged(bOpen)
end

function M:UpdateBottomKeyOnSubTabChange()
end

function M:PlayInAnimation()
  self:StopAllAnimations()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "GuildBossRankingIn", nil)
  self:PlayAnimation(self.In)
end

function M:PlayOutAnimation()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) or self._bIsClosing then
    return
  end
  self._bIsClosing = true
  AudioManager(self):SetEventSoundParam(self, "GuildBossRankingIn", {ToEnd = 1})
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
    self:BindToAnimationFinished(self.Out, {
      self,
      self.OnRankingOutFinished
    })
    self:PlayAnimation(self.Out)
  else
    self:OnRankingOutFinished()
  end
end

function M:OnRankingOutFinished()
  if not self._bIsClosing then
    return
  end
  self._bIsClosing = false
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BlockAllUIInput(false)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:Close()
end

function M:On_Image_Click_MouseButtonDown(MyGeometry, MouseEvent)
  return self:OnPointerDown(MyGeometry, MouseEvent)
end

function M:OnMouseWheel(MyGeometry, MouseEvent)
  return self:OnMouseWheelScroll(MyGeometry, MouseEvent)
end

function M:OnMouseButtonUp(MyGeometry, MouseEvent)
  return self:OnPointerUp(MyGeometry, MouseEvent)
end

function M:OnMouseMove(MyGeometry, MouseEvent)
  return self:OnPointerMove(MyGeometry, MouseEvent)
end

function M:OnTouchEnded(MyGeometry, InTouchEvent)
  return self:OnPointerUp(MyGeometry, InTouchEvent)
end

function M:OnTouchMoved(MyGeometry, InTouchEvent)
  return self:OnPointerMove(MyGeometry, InTouchEvent)
end

function M:OnMouseCaptureLost()
  self:OnPointerCaptureLost()
end

AssembleComponents(M)
return M
