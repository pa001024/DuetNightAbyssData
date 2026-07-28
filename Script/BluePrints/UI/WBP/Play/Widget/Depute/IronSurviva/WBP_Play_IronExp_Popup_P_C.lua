require("UnLua")
local ItemUtils = require("Utils.ItemUtils")
local PageJumpUtils = require("Utils.PageJumpUtils")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local EMCache = require("EMCache.EMCache")
local M = Class("BluePrints.UI.BP_UIState_C")
local IRON_SHOP_TYPE = "IronModeShop"
local IRON_BTN_NEW_CACHE_KEY = {
  Forge = "IronExpBtnForgeClicked",
  Decompose = "IronExpBtnDecomposeClicked",
  Shop = "IronExpBtnShopClicked"
}
local IRON_BTN_ICON_PATH = {
  Forge = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Forging.T_Entrance_Forging'",
  Decompose = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Breakdown.T_Entrance_Breakdown'",
  Shop = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Entrance/T_Entrance_Store.T_Entrance_Store'"
}
local GPAD_STATE_LIST = 1
local GPAD_STATE_SORT = 2
local GPAD_STATE_REWARD = 3
local GPAD_STATE_REWARD_INNER = 4
local GPAD_STATE_DECOMPOSE = 5

function M:Construct()
  M.Super.Construct(self)
  self:AddInputMethodChangedListen()
  self:AddDispatcher(EventID.OnJumpToPage, self, self.OnJumpToPage)
  self:AddDispatcher(EventID.OnJumpBackToPage, self, self.OnJumpBackToPage)
  self.Btn_Cancel:BindEventOnClicked(self, self.OnBtnCancelClicked)
  self.Btn_Start:BindEventOnClicked(self, self.OnBtnStartClicked)
  self.Btn_Start:BindForbidStateExecuteEvent(self, self.OnBtnStartClicked)
  self.Btn_Cancel.AudioEventPath = "event:/ui/common/click_btn_cancel"
  self.Btn_Start.AudioEventPath = "event:/ui/common/click_btn_confirm"
  self.Btn_Cancel:SetText(GText("AFDayEvent_Photo_Cancel"))
  self.Btn_Start:SetText(GText("DUNGEONSINGLE"))
  self.Btn_Cancel:SetPCImg("Escape")
  self.Btn_Start:SetPCImg("SpaceBar")
  self.Btn_Cancel:SetDefaultGamePadImg("B")
  self.Btn_Start:SetDefaultGamePadImg("A")
  self.Btn_Start:ForbidBtn(true)
  self.SelectedTicketId = nil
  self.SelectedTicketLevel = 0
  self.SelectedTicketUid = nil
  self.AllTicketContents = {}
  self.GPadFocusState = GPAD_STATE_LIST
  self.List_Item.OnCreateEmptyContent:Bind(self, function(self)
    local content = NewObject(UIUtils.GetCommonItemContentClass())
    content.ItemType = "EmptyGrid"
    content.StuffType = "EmptyGrid"
    content.ParentWidget = self
    return content
  end)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Com_Sort:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.Sift:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.Com_Sort:BindEventOnSortTypeChanged(self, self.OnSortTypeChanged)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Reward:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
end

function M:OnLoaded(Params)
  if not Params then
    return
  end
  self:SetFocus()
  self.DungeonId = Params.DungeonId
  self.StartCallback = Params.StartCallback
  self.ParentWidget = Params.ParentWidget
  self.HideIronBtns = Params.HideIronBtns
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  if not IronDungeonData then
    return
  end
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/shenjingluopanel_show", "IronExpShow", nil)
  self.Text_ListTitle:SetText(GText("UI_IronSurvival_ExpeditionReward"))
  self.Text_DetailTitle:SetText(GText("UI_IronSurvival_SelectExpeditionProof"))
  self.Text_DetailTitleTips:SetText(GText("UI_IronSurvival_UpgradeExpeditionProof"))
  self:InitRoundData(IronDungeonData)
  self:InitRewardList()
  self:InitCertificateList()
  self:InitIronBtns(IronDungeonData)
  self:InitSort()
  self:InitSift()
  self:AddTimer(0.016, function()
    self:RefreshCertificateList()
  end, false, 0, nil, true)
  self:RefreshBySelectedTicket()
  if IsValid(self.Com_MidKeyTips) then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if UIUtils.IsGamepadInput() then
    self:GamepadFocusListFirst()
  end
end

function M:InitRoundData(IronDungeonData)
  local RewardView = IronDungeonData.IronRoundsRewardView or {}
  local keys = {}
  for roundKey in pairs(RewardView) do
    table.insert(keys, roundKey)
  end
  table.sort(keys)
  self.RoundKeyOrder = keys
  self.RoundLevelDisplay = {}
  for _, roundKey in ipairs(keys) do
    self.RoundLevelDisplay[roundKey] = "Lv." .. roundKey
  end
end

function M:InitRewardList()
  self.List_Reward:ClearListItems()
  self.RewardContents = {}
end

function M:GetAllowedTicketIdSet()
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local ticketIds = IronDungeonData and IronDungeonData.IronTicketId
  if not ticketIds or 0 == #ticketIds then
    return nil
  end
  local AllowedSet = {}
  for _, tid in ipairs(ticketIds) do
    AllowedSet[tid] = true
  end
  return AllowedSet
end

function M:InitCertificateList()
  self.AllTicketData = {}
  self.AllTicketContents = {}
  self.SelectedTicketId = nil
  self.SelectedTicketLevel = 0
  self.SelectedTicketUid = nil
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.IronSurvivalTicket then
    self:ShowNotOwnedState()
    return
  end
  local hasAny = false
  local firstOwnedId
  local firstOwnedLevel = 0
  local firstOwnedUid
  local AllowedSet = self:GetAllowedTicketIdSet()
  for _, ticket in pairs(Avatar.IronSurvivalTicket) do
    local ticketId = ticket.TicketId
    local level = ticket.Level
    if not ticketId or not level then
    elseif AllowedSet and not AllowedSet[ticketId] then
    else
      local ironTicketInfo = DataMgr.IronTicket[ticketId]
      if ironTicketInfo then
        hasAny = true
        local realLevel = tonumber(level) or ironTicketInfo.Level
        local bMaxLevel = self:IsTicketMaxLevel(ticketId, realLevel)
        table.insert(self.AllTicketData, {
          TicketId = ticketId,
          Level = realLevel,
          Uid = ticket.Uid,
          Rarity = ironTicketInfo.Rarity or 1,
          Icon = bMaxLevel and (ironTicketInfo.MaxIcon or ItemUtils.GetItemIconPath(ticketId, "IronTicket")) or ItemUtils.GetItemIconPath(ticketId, "IronTicket"),
          bMaxLevel = bMaxLevel
        })
      end
    end
  end
  table.sort(self.AllTicketData, function(a, b)
    if (a.bMaxLevel or false) ~= (b.bMaxLevel or false) then
      return not a.bMaxLevel
    end
    return a.Level > b.Level
  end)
  if hasAny then
    firstOwnedId = self.AllTicketData[1].TicketId
    firstOwnedLevel = self.AllTicketData[1].Level
    firstOwnedUid = self.AllTicketData[1].Uid
  end
  if not hasAny then
    self:ShowNotOwnedState()
  else
    self.SelectedTicketId = firstOwnedId
    self.SelectedTicketLevel = firstOwnedLevel
    self.SelectedTicketUid = firstOwnedUid
    self.bSelectedTicketBlocked = self:IsTicketBlocked(firstOwnedId, firstOwnedLevel)
    self.Btn_Start:ForbidBtn(self.bSelectedTicketBlocked)
  end
  if self.List_Item.BP_OnItemSelectionChanged then
    self.List_Item.BP_OnItemSelectionChanged:Remove(self, self.OnListItemSelectionChanged)
    self.List_Item.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
  end
end

function M:IsTicketMaxLevel(ticketId, level)
  local info = DataMgr.IronTicket[ticketId]
  if not (info and info.MaxLevel) or not level then
    return false
  end
  return level >= info.MaxLevel
end

function M:IsTicketBlocked(ticketId, level)
  if self:IsTicketMaxLevel(ticketId, level) then
    return true
  end
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local ticketIds = IronDungeonData and IronDungeonData.IronTicketId
  local availLevels = IronDungeonData and IronDungeonData.AvailableTicketLevel
  if ticketIds and availLevels then
    for i, tid in ipairs(ticketIds) do
      if tid == ticketId then
        local limit = availLevels[i]
        if limit and level and level > limit then
          return true
        end
        break
      end
    end
  end
  return false
end

function M:OnListItemSelectionChanged(SelectItem, bIsSelect)
  if not bIsSelect then
    return
  end
  if not UIUtils.IsGamepadInput() then
    return
  end
  if not SelectItem or not SelectItem.TicketId then
    return
  end
  self.GamepadPointedContent = SelectItem
  if self.bDecomposeMode then
    return
  end
  self:OnTicketSelected(SelectItem.TicketId, SelectItem.Level, SelectItem.Uid)
end

function M:InitIronBtns(IronDungeonData)
  if not self.Group_IronBtn then
    return
  end
  if self.HideIronBtns then
    self.Group_IronBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  else
    self.Group_IronBtn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Group_Sell then
    self.Group_Sell:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.bDecomposeMode = false
  local firstTicketId = IronDungeonData and IronDungeonData.IronTicketId and IronDungeonData.IronTicketId[1]
  self.ForgeTicketId = firstTicketId
  if self.Btn_IronExp01 then
    self.Btn_IronExp01:SetData({
      ShowNew = self:IsIronBtnNew("Forge"),
      AudioPath = "event:/ui/common/click_btn_confirm",
      OnNewClicked = function()
        self:MarkIronBtnClicked("Forge")
      end,
      OnClick = function()
        self:OnForgeBtnClicked(firstTicketId)
      end,
      GamePadKey = UIConst.GamePadImgKey.RightThumb,
      Text = GText("UI_IronTicket_Forge"),
      IconPath = IRON_BTN_ICON_PATH.Forge
    })
  end
  if self.Btn_IronExp02 then
    self.Btn_IronExp02:SetData({
      ShowNew = self:IsIronBtnNew("Decompose"),
      AudioPath = "event:/ui/common/click_btn_confirm",
      OnNewClicked = function()
        self:MarkIronBtnClicked("Decompose")
      end,
      OnClick = function()
        self:OnDecomposeBtnClicked()
      end,
      GamePadKey = UIConst.GamePadImgKey.FaceButtonLeft,
      Text = GText("UI_IronTicket_Decompose"),
      IconPath = IRON_BTN_ICON_PATH.Decompose
    })
  end
  if self.Btn_IronExp03 then
    self.Btn_IronExp03:SetData({
      ShowNew = self:IsIronBtnNew("Shop"),
      AudioPath = "event:/ui/common/click_btn_confirm",
      OnNewClicked = function()
        self:MarkIronBtnClicked("Shop")
      end,
      OnClick = function()
        self:OnShopBtnClicked()
      end,
      GamePadKey = UIConst.GamePadImgKey.FaceButtonTop,
      Text = GText("UI_IronTicket_Shop"),
      IconPath = IRON_BTN_ICON_PATH.Shop
    })
  end
end

function M:IsIronBtnNew(key)
  local cacheKey = IRON_BTN_NEW_CACHE_KEY[key]
  if not cacheKey then
    return false
  end
  return not EMCache:Get(cacheKey, true)
end

function M:MarkIronBtnClicked(key)
  local cacheKey = IRON_BTN_NEW_CACHE_KEY[key]
  if not cacheKey then
    return
  end
  EMCache:Set(cacheKey, true, true)
end

function M:OnForgeBtnClicked(firstTicketId)
  if not firstTicketId then
    return
  end
  local DraftMap = DataMgr.Item2DraftIdMap and DataMgr.Item2DraftIdMap.IronTicket
  local Entry = DraftMap and DraftMap[firstTicketId]
  if not (Entry and Entry.DraftIds) or not Entry.DraftIds[1] then
    return
  end
  local DraftId = Entry.DraftIds[1]
  local PlayerAvatar = GWorld:GetAvatar()
  local AvatarDrafts = PlayerAvatar and PlayerAvatar.Drafts
  local DraftCfg = DataMgr.Draft[DraftId]
  local bHasDraft = AvatarDrafts and AvatarDrafts[DraftId]
  if not bHasDraft and DraftCfg and not DraftCfg.NotDraftTree then
    PageJumpUtils:JumpToForgeCompendiumPathByDraftId(DraftId)
  else
    PageJumpUtils:JumpToForgePageByDraftId(DraftId)
  end
end

function M:OnDecomposeBtnClicked()
  self:EnterDecomposeMode()
end

function M:CollectBreakDownStuffList()
  local list = {}
  for _, data in ipairs(self.AllTicketData or {}) do
    local info = DataMgr.IronTicket[data.TicketId]
    local minLv = info and info.BreakDownLevelLimit
    if minLv and minLv <= data.Level then
      table.insert(list, {
        Uuid = data.Uid,
        StuffId = data.TicketId,
        StuffType = BagCommon.StuffType.IronTicket,
        StuffIcon = ItemUtils.GetItemIconPath(data.TicketId, "IronTicket"),
        Level = data.Level,
        Rarity = data.Rarity,
        StuffCount = 1
      })
    end
  end
  return list
end

function M:OnDecomposeRemove(_, uid)
  if not uid then
    return
  end
  if self.DecomposeSelectedUids then
    self.DecomposeSelectedUids[uid] = nil
  end
  if self.AllTicketContents then
    for _, content in ipairs(self.AllTicketContents) do
      if content.Uid == uid then
        content.IsSelect = false
        if content.SelfWidget then
          content.SelfWidget:SetSelected(false)
          content.SelfWidget:ApplyIronTicketVisual()
        end
        break
      end
    end
  end
end

function M:OnConfirmBreakDown(_, NeedDealWithStuffData, _)
  local TicketUids = {}
  for uid, _ in pairs(NeedDealWithStuffData or {}) do
    table.insert(TicketUids, uid)
  end
  if 0 == #TicketUids then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.BreakDownIronTickets then
    return
  end
  Avatar:BreakDownIronTickets(function(ret)
    if 0 ~= ret then
      return
    end
    local sell = self.IronExp_Popup_Sell
    
    local function AfterCleanup()
      self:InitCertificateList()
      self:RefreshCertificateList()
      self:RefreshBySelectedTicket()
    end
    
    if sell and sell.ShowGetItemPage and sell.AllRewardContentList then
      local AllRewards = {}
      for _, v in ipairs(sell.AllRewardContentList) do
        local Key = (v.ItemType or BagCommon.StuffType.Resource) .. "s"
        AllRewards[Key] = AllRewards[Key] or {}
        AllRewards[Key][v.Id] = (AllRewards[Key][v.Id] or 0) + (v.Count or 0)
      end
      sell:ShowGetItemPage(AllRewards, function()
        self:BeginExitDecomposeMode(AfterCleanup)
      end)
    else
      self:BeginExitDecomposeMode(AfterCleanup)
    end
  end, TicketUids)
end

function M:SetFocus_Lua()
  if self.bDecomposeMode and UIUtils.IsGamepadInput() then
    if self._bJustUncollapsed then
      self:AddTimer(0.016, function()
        self.GPadFocusState = GPAD_STATE_DECOMPOSE
        self.List_Item:SetFocus()
        self:RefreshMidKeyTips()
      end, false, 0, nil, true)
    else
      self.GPadFocusState = GPAD_STATE_DECOMPOSE
      self.List_Item:SetFocus()
      self:RefreshMidKeyTips()
    end
    return
  end
  self:SetFocus()
end

function M:RefreshBottomKeyInfo(_)
  self:RefreshDecomposeBottomKey()
end

function M:GetStuffSaleCondition()
  return false, nil
end

function M:OnRefreshSaleSelectNum(_, _)
end

function M:BuildTicketStuffData(Content)
  return {
    Uuid = Content.Uid,
    StuffId = Content.TicketId,
    StuffType = BagCommon.StuffType.IronTicket,
    StuffIcon = ItemUtils.GetItemIconPath(Content.TicketId, "IronTicket"),
    Level = Content.Level,
    Rarity = Content.Rarity,
    StuffCount = 1
  }
end

function M:OnDecomposeTicketClicked(Content, bForceRemove)
  if not Content or not Content.TicketId then
    return
  end
  self:RefreshBySelectedTicket(false, Content.Level, Content.TicketId)
  local info = DataMgr.IronTicket[Content.TicketId]
  local minLv = info and info.BreakDownLevelLimit
  if not minLv or Content.Level and minLv > Content.Level then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_IronSurvival_TicketBreakDownLevelLow"))
    return
  end
  self.DecomposeSelectedUids = self.DecomposeSelectedUids or {}
  local sellView = self.IronExp_Popup_Sell
  if not sellView then
    return
  end
  local bAlreadySelected = self.DecomposeSelectedUids[Content.Uid] and true or false
  if bForceRemove then
    if not bAlreadySelected then
      return
    end
    self.DecomposeSelectedUids[Content.Uid] = nil
    Content.IsSelect = false
    if Content.SelfWidget then
      Content.SelfWidget:SetSelected(false)
      Content.SelfWidget:ApplyIronTicketVisual()
    end
    if sellView.RemoveBagItemInList then
      sellView:RemoveBagItemInList(Content.Uid)
    end
    return
  end
  if bAlreadySelected then
    return
  end
  self.DecomposeSelectedUids[Content.Uid] = true
  Content.IsSelect = true
  if Content.SelfWidget then
    Content.SelfWidget:SetSelected(true)
    Content.SelfWidget:ApplyIronTicketVisual()
  end
  if sellView.AddBagItemToList then
    sellView:AddBagItemToList(self:BuildTicketStuffData(Content))
  end
end

function M:EnterDecomposeMode()
  if not self.Group_Sell then
    return
  end
  self.bDecomposeMode = true
  self._bExitingDecompose = false
  self.DecomposeSelectedUids = {}
  local InitStuffData
  if self.SelectedTicketUid then
    for _, data in ipairs(self.AllTicketData or {}) do
      if data.Uid == self.SelectedTicketUid then
        local info = DataMgr.IronTicket[data.TicketId]
        local minLv = info and info.BreakDownLevelLimit
        if minLv and data.Level and minLv <= data.Level then
          self.DecomposeSelectedUids[data.Uid] = true
          InitStuffData = self:BuildTicketStuffData(data)
        end
        break
      end
    end
  end
  self.Btn_Cancel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Start:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Group_IronBtn then
    self.Group_IronBtn:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Group_Sell:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if not self.IronExp_Popup_Sell then
    return
  end
  self:PlayAnimation(self.Sell_In)
  self.IronExp_Popup_Sell:OnLoaded(self, function()
    self:ExitDecomposeMode()
  end, function(p, uid)
    self:OnDecomposeRemove(p, uid)
  end, function(p, needData, needCount)
    self:OnConfirmBreakDown(p, needData, needCount)
  end, InitStuffData, BagCommon.BagItemSelectOpMode.ResolveMode, true)
  self:SortTicketContents()
  self:RefreshCertificateList()
  self:RefreshDecomposeBottomKey()
  if UIUtils.IsGamepadInput() then
    if self.FocusedRewardEntry and self.FocusedRewardEntry.Normal then
      self.FocusedRewardEntry:PlayAnimation(self.FocusedRewardEntry.Normal)
    end
    self:SetAllRewardInnerListsInteractive(true)
    self.GPadFocusState = GPAD_STATE_DECOMPOSE
    self.List_Item:SetFocus()
    self:RefreshMidKeyTips()
  end
end

function M:RefreshDecomposeBottomKey()
  local sell = self.IronExp_Popup_Sell
  if not self.bDecomposeMode or not sell then
    return
  end
  local bGamepad = UIUtils.IsGamepadInput()
  if not sell.WS_Close then
    return
  end
  if bGamepad and sell.CurFocusWidget == "GetItemBox" then
    sell.WS_Close:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  sell.WS_Close:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  sell.WS_Close:SetActiveWidgetIndex(bGamepad and 1 or 0)
  if bGamepad and sell.Com_KeyTips then
    local bListFocused = sell.CurFocusWidget == "ToSellListView"
    local keyInfo = {
      {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "X"}
        },
        Desc = GText("UI_CTL_Remove")
      }
    }
    if not bListFocused then
      table.insert(keyInfo, {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_CTL_Select")
      })
    end
    table.insert(keyInfo, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK")
    })
    sell.Com_KeyTips:UpdateKeyInfo(keyInfo)
  end
end

function M:PlaySellOutAnim()
  if self._bExitingDecompose then
    return
  end
  self._bExitingDecompose = true
  self:PlayAnimation(self.Sell_Out)
end

function M:BeginExitDecomposeMode(AfterCleanup)
  if not self.bDecomposeMode then
    if AfterCleanup then
      AfterCleanup()
    end
    return
  end
  if self._bExitingDecompose then
    return
  end
  self._pendingExitCleanup = AfterCleanup
  self:PlaySellOutAnim()
  local sell = self.IronExp_Popup_Sell
  if sell and sell.PlayOutAnim then
    sell:PlayOutAnim()
  else
    self:ExitDecomposeMode()
  end
end

function M:ExitDecomposeMode()
  self.bDecomposeMode = false
  self._bExitingDecompose = false
  self.Btn_Cancel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Start:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Group_IronBtn then
    self.Group_IronBtn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.AllTicketContents then
    for _, content in ipairs(self.AllTicketContents) do
      if self.DecomposeSelectedUids and self.DecomposeSelectedUids[content.Uid] then
        content.IsSelect = false
        if content.SelfWidget then
          content.SelfWidget:SetSelected(false)
        end
      end
      content.bDecomposeLowLevel = nil
      if content.SelfWidget and content.SelfWidget.SetIronDecomposeState then
        content.SelfWidget:SetIronDecomposeState(false)
      end
    end
  end
  self.DecomposeSelectedUids = {}
  if self.Group_Sell then
    self.Group_Sell:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.SelectedTicketUid and self.AllTicketContents then
    for _, content in ipairs(self.AllTicketContents) do
      local sel = content.Uid == self.SelectedTicketUid
      content.IsSelect = sel
      if content.SelfWidget then
        content.SelfWidget:SetSelected(sel)
      end
    end
  end
  if UIUtils.IsGamepadInput() then
    self:AddTimer(0.016, function()
      self:GamepadFocusListFirst()
    end, false, 0, nil, true)
  else
    self:SetFocus()
  end
  if self._pendingExitCleanup then
    local AfterCleanup = self._pendingExitCleanup
    self._pendingExitCleanup = nil
    AfterCleanup()
  end
end

function M:OnShopBtnClicked()
  if not IRON_SHOP_TYPE or not DataMgr.Shop[IRON_SHOP_TYPE] then
    DebugPrint("[IronExp] 深境商店 ShopType 未配置，跳转跳过")
    return
  end
  PageJumpUtils:JumpToShopPage(nil, nil, nil, IRON_SHOP_TYPE)
end

function M:OnJumpToPage(_, ToPage)
  if ToPage and self:IsVisible() then
    self.JumpToPage = ToPage
    self:RemoveTimer("StaggerList")
    self.List_Item:ClearListItems()
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self._bJustUncollapsed = false
  end
end

function M:OnJumpBackToPage(FromPage)
  if self.JumpToPage and self.JumpToPage == FromPage then
    self.JumpToPage = nil
    self:SetVisibility(UIConst.VisibilityOp.Visible)
    self:PlayAnimation(self.In)
    self._bJustUncollapsed = true
    self:AddTimer(0.016, function()
      self:InitCertificateList()
      self:RefreshCertificateList()
      self:RefreshBySelectedTicket()
      if UIUtils.IsGamepadInput() then
        self:GamepadFocusListFirst()
      else
        self:SetFocus()
      end
    end, false, 0, nil, true)
  end
end

function M:InitSort()
  self.SortType = CommonConst.DESC
  self.Com_Sort:Init(self, {
    "UI_LEVEL_SELECT"
  }, CommonConst.DESC, {
    OnGetBackFocusWidget = function()
      if self.bDecomposeMode then
        self.GPadFocusState = GPAD_STATE_DECOMPOSE
        self.List_Item:SetFocus()
        self:RefreshMidKeyTips()
        return self.List_Item
      end
      self:GamepadFocusListFirst()
      return self.List_Item
    end
  })
end

function M:OnSortTypeChanged(sortType)
  self.SortType = sortType
  self:SortTicketContents()
  self:RefreshCertificateList()
end

function M:SortTicketContents()
  table.sort(self.AllTicketData, function(a, b)
    if not self.bDecomposeMode and (a.bMaxLevel or false) ~= (b.bMaxLevel or false) then
      return not a.bMaxLevel
    end
    if self.SortType == CommonConst.ASC then
      return a.Level < b.Level
    else
      return a.Level > b.Level
    end
  end)
end

function M:RefreshCertificateList()
  if not self.AllTicketData or 0 == #self.AllTicketData then
    self:ShowNotOwnedState()
    return
  end
  local itemsToAdd = {}
  for _, data in ipairs(self.AllTicketData) do
    table.insert(itemsToAdd, data)
  end
  itemsToAdd = self:FilterTicketsBySift(itemsToAdd)
  self.AllTicketContents = {}
  self.List_Item:ClearListItems()
  if 0 == #itemsToAdd then
    self.SelectedTicketUid = nil
    self.SelectedTicketId = nil
    self.SelectedTicketLevel = 0
    self.Btn_Start:ForbidBtn(true)
    self:RefreshBySelectedTicket()
    self.List_Item:RequestFillEmptyContent()
    return
  end
  if self.SelectedTicketUid then
    local stillInRange = false
    for _, data in ipairs(itemsToAdd) do
      if data.Uid == self.SelectedTicketUid then
        stillInRange = true
        break
      end
    end
    if not stillInRange then
      self.SelectedTicketUid = nil
      self.SelectedTicketId = nil
      self.SelectedTicketLevel = 0
      self.Btn_Start:ForbidBtn(true)
      self:RefreshBySelectedTicket()
    end
  end
  self:RemoveTimer("StaggerList")
  local cols = 1
  local listSize = UIManager(self):GetWidgetRenderSize(self.List_Item)
  local entryW = self.List_Item:GetEntryWidth()
  if listSize and listSize.X > 0 and entryW and entryW > 0 then
    cols = math.max(1, math.floor(listSize.X / entryW))
  end
  local idx = 0
  local total = #itemsToAdd
  self:AddTimer(0.05, function()
    for _ = 1, cols do
      idx = idx + 1
      local data = itemsToAdd[idx]
      if not data then
        break
      end
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.Id = data.TicketId
      ItemContent.StuffId = data.TicketId
      ItemContent.ItemType = "IronTicket"
      ItemContent.StuffType = "IronTicket"
      ItemContent.Rarity = data.Rarity
      ItemContent.Icon = data.Icon
      ItemContent.UIName = "StyleOfPlay"
      ItemContent.ParentWidget = self
      ItemContent.bShowNotHaveStyle = false
      ItemContent.Level = data.Level
      ItemContent.TicketId = data.TicketId
      ItemContent.Uid = data.Uid
      ItemContent.bTicketMaxLevel = data.bMaxLevel
      if self.bDecomposeMode then
        local info = DataMgr.IronTicket[data.TicketId]
        local minLv = info and info.BreakDownLevelLimit
        ItemContent.bDecomposeMode = true
        ItemContent.bDecomposeLowLevel = not minLv or data.Level and minLv > data.Level or false
        ItemContent.IsSelect = self.DecomposeSelectedUids and self.DecomposeSelectedUids[data.Uid] or false
      else
        ItemContent.IsSelect = data.Uid == self.SelectedTicketUid
      end
      
      function ItemContent.ClickCallback(ParentWidget, Content)
        if ParentWidget.bDecomposeMode then
          ParentWidget:OnDecomposeTicketClicked(Content)
          return
        end
        ParentWidget:OnTicketSelected(Content.TicketId, Content.Level, Content.Uid)
        if UIUtils.IsGamepadInput() then
          ParentWidget:OnBtnStartClicked()
        end
      end
      
      table.insert(self.AllTicketContents, ItemContent)
      self.List_Item:AddItem(ItemContent)
      if 1 == idx and not self.SelectedTicketUid and not self.bDecomposeMode then
        self:OnTicketSelected(data.TicketId, data.Level, data.Uid)
      end
    end
    if idx >= total then
      self:RemoveTimer("StaggerList")
      self.List_Item:RequestFillEmptyContent()
      if UIUtils.IsGamepadInput() and (self.GPadFocusState == GPAD_STATE_LIST or self.GPadFocusState == GPAD_STATE_DECOMPOSE) then
        self.List_Item:NavigateToIndex(0)
        self.List_Item:SetFocus()
      end
    end
  end, true, 0, "StaggerList")
end

function M:InitSift()
  if not self.Sift then
    return
  end
  local selectionDatas = {}
  local selectionText = {}
  for i, roundKey in ipairs(self.RoundKeyOrder) do
    local nextKey = self.RoundKeyOrder[i + 1]
    local idx = #selectionDatas + 1
    selectionDatas[idx] = tostring(roundKey)
    if nextKey then
      selectionText[idx] = "Lv." .. roundKey .. "~" .. nextKey
    else
      selectionText[idx] = "Lv." .. roundKey
    end
  end
  local itemDatas = {
    {
      HasSelectAll = true,
      Id = 1,
      SelectionDatas = selectionDatas,
      SelectionField = {"Level"},
      SelectionText = selectionText,
      Title = "UI_LEVEL_SELECT"
    }
  }
  self.Sift:SetGamepadKeyVisibility(UIConst.VisibilityOp.Collapsed)
  self.Sift:SetItemDatas(itemDatas)
  self.Sift:BindEventOnSelectionsChanged(self, self.OnSiftSelectionsChanged)
  self.SiftFilterRanges = {}
end

function M:OnSiftSelectionsChanged(selectedItems, itemDatas)
  self.SiftFilterRanges = {}
  if selectedItems and next(selectedItems) then
    local dimSelections = selectedItems[1]
    local dimData = itemDatas and itemDatas[1]
    if dimSelections and dimData then
      for _, valueIdx in pairs(dimSelections) do
        local roundKey = tonumber(dimData.SelectionDatas[valueIdx])
        if roundKey then
          table.insert(self.SiftFilterRanges, roundKey)
        end
      end
    end
  end
  self:RefreshCertificateList()
end

function M:FilterTicketsBySift(tickets)
  if not self.SiftFilterRanges or 0 == #self.SiftFilterRanges then
    return tickets
  end
  local result = {}
  for _, ticket in ipairs(tickets) do
    for _, roundKey in ipairs(self.SiftFilterRanges) do
      local nextKey
      for i, rk in ipairs(self.RoundKeyOrder) do
        if tonumber(rk) == roundKey then
          nextKey = tonumber(self.RoundKeyOrder[i + 1])
          break
        end
      end
      local inRange = nextKey and roundKey <= ticket.Level and nextKey > ticket.Level or not nextKey and roundKey <= ticket.Level
      if inRange then
        table.insert(result, ticket)
        break
      end
    end
  end
  return result
end

function M:OnTicketSelected(ticketId, ticketLevel, uid)
  local isSame = self.SelectedTicketUid == uid
  self.SelectedTicketId = ticketId
  self.SelectedTicketLevel = ticketLevel
  self.SelectedTicketUid = uid
  self.bSelectedTicketBlocked = self:IsTicketBlocked(ticketId, ticketLevel)
  self.Btn_Start:ForbidBtn(self.bSelectedTicketBlocked)
  for _, content in ipairs(self.AllTicketContents) do
    local shouldSelect = content.Uid == uid
    if content.IsSelect ~= shouldSelect then
      content.IsSelect = shouldSelect
      if content.SelfWidget then
        content.SelfWidget:SetSelected(shouldSelect)
      end
    end
  end
  if not isSame then
    self:RefreshBySelectedTicket(true)
  end
end

function M:RefreshBySelectedTicket(playChangeAnim, overrideLevel, overrideTicketId)
  local selectedLevel = overrideLevel or self.SelectedTicketLevel or 0
  local ticketId = overrideTicketId or self.SelectedTicketId
  local bSelectedMaxLevel = ticketId and self:IsTicketMaxLevel(ticketId, selectedLevel) or false
  if bSelectedMaxLevel then
    self.PrevBottomRoundKey = nil
    self:RefreshRewardListByTicket(selectedLevel, false, playChangeAnim, true)
    return
  end
  local unlockCount = 0
  for _, roundKey in ipairs(self.RoundKeyOrder) do
    if roundKey <= selectedLevel then
      unlockCount = unlockCount + 1
    end
  end
  local bottomRoundKey = unlockCount > 0 and self.RoundKeyOrder[unlockCount] or nil
  local playUnlockAnim = bottomRoundKey ~= self.PrevBottomRoundKey
  self.PrevBottomRoundKey = bottomRoundKey
  self:RefreshRewardListByTicket(selectedLevel, playUnlockAnim, playChangeAnim)
end

function M:RefreshRewardListByTicket(selectedLevel, playUnlockAnim, playChangeAnim, bMaxLevel)
  self.List_Reward:ClearListItems()
  self.RewardContents = {}
  self.FocusedRewardEntry = nil
  self.IsBlockingRewardInner = false
  local totalTiers = #self.RoundKeyOrder
  if 0 == totalTiers then
    return
  end
  if bMaxLevel then
    self.RewardEmptyStateCount = math.min(totalTiers, 4)
    for _ = 1, self.RewardEmptyStateCount do
      local emptyContent = NewObject(UIUtils.GetCommonItemContentClass())
      emptyContent.IsEmptyState = true
      emptyContent.ParentWidget = self
      emptyContent.RewardListIndex = self.List_Reward:GetNumItems()
      self.List_Reward:AddItem(emptyContent)
    end
    self:RemoveTimer("UnlockAnim")
    if playChangeAnim and self.Change then
      self:StopAnimation(self.Change)
      self:PlayAnimation(self.Change)
    end
    return
  end
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local RewardView = IronDungeonData and IronDungeonData.IronRoundsRewardView or {}
  local unlockCount = 0
  for _, roundKey in ipairs(self.RoundKeyOrder) do
    if selectedLevel >= roundKey then
      unlockCount = unlockCount + 1
    end
  end
  local bottomRoundKey = unlockCount > 0 and self.RoundKeyOrder[unlockCount] or nil
  self.RewardEmptyStateCount = 0
  if unlockCount > 0 then
    local lockedCount = totalTiers - unlockCount
    local maxDisplayRows = math.min(totalTiers, 4)
    local emptyCount = math.max(0, maxDisplayRows - lockedCount - 1)
    self.RewardEmptyStateCount = emptyCount
    for _ = 1, emptyCount do
      local emptyContent = NewObject(UIUtils.GetCommonItemContentClass())
      emptyContent.IsEmptyState = true
      emptyContent.ParentWidget = self
      emptyContent.RewardListIndex = self.List_Reward:GetNumItems()
      self.List_Reward:AddItem(emptyContent)
    end
  end
  local sortedDesc = {}
  for _, rk in ipairs(self.RoundKeyOrder) do
    table.insert(sortedDesc, rk)
  end
  table.sort(sortedDesc, function(a, b)
    return b < a
  end)
  
  local function buildRewardViewIds(targetKey)
    local ids = {}
    for _, rk in ipairs(self.RoundKeyOrder) do
      if rk <= targetKey and RewardView[rk] then
        table.insert(ids, RewardView[rk])
      end
    end
    return ids
  end
  
  for _, roundKey in ipairs(sortedDesc) do
    if roundKey > (bottomRoundKey or 0) then
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.LvText = self.RoundLevelDisplay[roundKey] or "Lv." .. roundKey
      ItemContent.RewardViewId = RewardView[roundKey]
      ItemContent.RewardViewIds = buildRewardViewIds(roundKey)
      ItemContent.RoundKey = roundKey
      ItemContent.IsUnlocked = false
      ItemContent.PlayUnlockAnim = false
      ItemContent.IsEmptyState = false
      ItemContent.ParentWidget = self
      ItemContent.RewardListIndex = self.List_Reward:GetNumItems()
      table.insert(self.RewardContents, ItemContent)
      self.List_Reward:AddItem(ItemContent)
    end
  end
  if bottomRoundKey then
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.LvText = self.RoundLevelDisplay[bottomRoundKey] or "Lv." .. bottomRoundKey
    ItemContent.RewardViewId = RewardView[bottomRoundKey]
    ItemContent.RewardViewIds = buildRewardViewIds(bottomRoundKey)
    ItemContent.RoundKey = bottomRoundKey
    ItemContent.IsUnlocked = true
    ItemContent.PlayUnlockAnim = playUnlockAnim
    ItemContent.IsEmptyState = false
    ItemContent.ParentWidget = self
    ItemContent.RewardListIndex = self.List_Reward:GetNumItems()
    table.insert(self.RewardContents, ItemContent)
    self.List_Reward:AddItem(ItemContent)
  end
  self:RemoveTimer("UnlockAnim")
  local unlockDelay = 0.05
  if playChangeAnim and self.Change then
    self:StopAnimation(self.Change)
    self:PlayAnimation(self.Change)
  end
  if playUnlockAnim then
    self:AddTimer(unlockDelay, function()
      self:TriggerUnlockAnimation()
    end, false, 0, "UnlockAnim", true)
  end
  self:AddTimer(0.016, function()
    self.List_Reward:ScrollToBottom()
  end, false, 0, nil, true)
end

function M:TriggerUnlockAnimation()
  local numItems = self.List_Reward:GetNumItems()
  if numItems <= 0 then
    return
  end
  local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
  if not (entry and entry.Content) or not entry.Content.IsUnlocked then
    return
  end
  entry:PlayAnimation(entry.UnLock)
  if entry.Up_Glow then
    entry:PlayAnimation(entry.Up_Glow)
  end
end

function M:ShowNotOwnedState()
  self.SelectedTicketLevel = 0
  self.Btn_Start:ForbidBtn(true)
  self.List_Item:ClearListItems()
  local IronDungeonData = DataMgr.IronSurvivalDungeon[self.DungeonId]
  local firstTicketId
  if IronDungeonData and IronDungeonData.IronTicketId then
    firstTicketId = IronDungeonData.IronTicketId[1]
  end
  if firstTicketId and DataMgr.IronTicket[firstTicketId] then
    local ironTicketInfo = DataMgr.IronTicket[firstTicketId]
    local lockedContent = NewObject(UIUtils.GetCommonItemContentClass())
    lockedContent.Id = firstTicketId
    lockedContent.StuffId = firstTicketId
    lockedContent.ItemType = "IronTicket"
    lockedContent.StuffType = "IronTicket"
    lockedContent.Rarity = ironTicketInfo.Rarity or 1
    lockedContent.Icon = ItemUtils.GetItemIconPath(firstTicketId, "IronTicket")
    lockedContent.UIName = "StyleOfPlay"
    lockedContent.ParentWidget = self
    lockedContent.bShowNotHaveStyle = true
    lockedContent.JumpReturnCallBack = {
      CallBackObj = self,
      CallBack = function()
        self:Close()
      end
    }
    
    function lockedContent.ClickCallback(_, Content)
      local selfWidget = Content.SelfWidget
      if not selfWidget then
        return
      end
      selfWidget:OpenItemMenu()
    end
    
    self.List_Item:AddItem(lockedContent)
  end
  self.List_Item:RequestFillEmptyContent()
  self:RefreshBySelectedTicket()
end

function M:RefreshMidKeyTips()
  if not IsValid(self.Com_MidKeyTips) then
    return
  end
  if not UIUtils.IsGamepadInput() then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  local tips = {}
  if self.GPadFocusState == GPAD_STATE_DECOMPOSE then
  elseif self.GPadFocusState == GPAD_STATE_LIST then
    table.insert(tips, {
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      },
      Desc = GText("UI_Controller_CheckDetails")
    })
  end
  if #tips > 0 then
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Com_MidKeyTips:UpdateKeyInfo(tips)
  else
    self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:SetAllRewardInnerListsInteractive(interactive)
  self.IsBlockingRewardInner = not interactive
  if not self.RewardContents then
    return
  end
  local vis = interactive and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.HitTestInvisible
  local emptyCount = self.RewardEmptyStateCount or 0
  for i = 1, #self.RewardContents do
    local listIdx = emptyCount + (i - 1)
    local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, listIdx)
    if entry and entry.List_Item then
      entry.List_Item:SetVisibility(vis)
    end
  end
end

function M:SetRightSideGamepadHintsVisible(visible)
  if not UIUtils.IsGamepadInput() then
    return
  end
  local vis = visible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
  self.Btn_Cancel:SetGamePadVisibility(vis)
  self.Btn_Start:SetGamePadVisibility(vis)
  if self.Com_Sort then
    self.Com_Sort:SetControllerKeyHidden(not visible)
  end
end

function M:RefreshIronBtnGamepadKeys(bShow)
  for _, btn in ipairs({
    self.Btn_IronExp01,
    self.Btn_IronExp02,
    self.Btn_IronExp03
  }) do
    if btn and btn.SetGamepadKeyVisible then
      btn:SetGamepadKeyVisible(bShow)
    end
  end
end

function M:GamepadFocusRewardUnlocked()
  if not self.SelectedTicketLevel or self.SelectedTicketLevel <= 0 then
    return
  end
  local numItems = self.List_Reward:GetNumItems()
  if numItems <= 0 then
    return
  end
  local unlockedIndex = numItems - 1
  local unlockedEntry = self:FocusRewardEntryByIndex(unlockedIndex)
  if unlockedEntry then
    self:SetAllRewardInnerListsInteractive(false)
    self.GPadFocusState = GPAD_STATE_REWARD
    self.FocusedRewardEntry = unlockedEntry
    unlockedEntry:SetFocus()
    self:RefreshMidKeyTips()
    self:SetRightSideGamepadHintsVisible(false)
  end
end

function M:GamepadFocusListFirst()
  if self.FocusedRewardEntry and self.FocusedRewardEntry.Normal then
    self.FocusedRewardEntry:PlayAnimation(self.FocusedRewardEntry.Normal)
  end
  self:SetAllRewardInnerListsInteractive(true)
  self.GPadFocusState = GPAD_STATE_LIST
  self.List_Item:SetFocus()
  self:RefreshMidKeyTips()
  self:SetRightSideGamepadHintsVisible(true)
end

function M:OnRewardEntryFocused(entry)
  if self.GPadFocusState == GPAD_STATE_REWARD or self.GPadFocusState == GPAD_STATE_REWARD_INNER then
    self.FocusedRewardEntry = entry
    if entry.Content and self.List_Reward then
      self.List_Reward:BP_ScrollItemIntoView(entry.Content)
    end
  end
end

function M:FocusRewardEntryByIndex(index)
  if not self.List_Reward then
    return nil
  end
  local numItems = self.List_Reward:GetNumItems()
  if not index or index < 0 or index >= numItems then
    return self.FocusedRewardEntry
  end
  local content = self.List_Reward:GetItemAt(index)
  if content and content.IsEmptyState then
    return self.FocusedRewardEntry
  end
  self.List_Reward:NavigateToIndex(index)
  if content then
    self.List_Reward:BP_ScrollItemIntoView(content)
  end
  local entry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, index)
  if entry then
    self.FocusedRewardEntry = entry
    return entry
  end
  return content and content.SelfWidget or self.FocusedRewardEntry
end

function M:GamepadFocusRewardInner()
  local focusedEntry = self.FocusedRewardEntry
  if not focusedEntry then
    local numItems = self.List_Reward:GetNumItems()
    if numItems > 0 then
      focusedEntry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
    end
  end
  if not focusedEntry or not focusedEntry.List_Item then
    return
  end
  focusedEntry.List_Item:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  focusedEntry.List_Item:SetFocus()
  self.GPadFocusState = GPAD_STATE_REWARD_INNER
  self:RefreshMidKeyTips()
end

function M:GamepadExitRewardInner()
  self.GPadFocusState = GPAD_STATE_REWARD
  if self.FocusedRewardEntry and self.FocusedRewardEntry.List_Item then
    self.FocusedRewardEntry.List_Item:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.FocusedRewardEntry then
    self.FocusedRewardEntry:SetFocus()
  else
    local numItems = self.List_Reward:GetNumItems()
    if numItems > 0 and self.SelectedTicketLevel and self.SelectedTicketLevel > 0 then
      local unlockedEntry = UE4.URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Reward, numItems - 1)
      if unlockedEntry then
        self.FocusedRewardEntry = unlockedEntry
        unlockedEntry:SetFocus()
      end
    end
  end
  self:RefreshMidKeyTips()
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if self.bDecomposeMode then
    local sellView = self.IronExp_Popup_Sell
    if sellView and sellView.bIsOpenList then
      return false
    end
    if "Gamepad_FaceButton_Right" == InKeyName then
      self:BeginExitDecomposeMode()
      IsEventHandled = true
    elseif "Gamepad_FaceButton_Top" == InKeyName then
      if self.IronExp_Popup_Sell and self.IronExp_Popup_Sell.TryToBreakDownIronTickets then
        self.IronExp_Popup_Sell:TryToBreakDownIronTickets()
      end
      IsEventHandled = true
    elseif "Gamepad_FaceButton_Left" == InKeyName then
      local pointed = self.GamepadPointedContent
      if pointed and pointed.Uid and self.DecomposeSelectedUids and self.DecomposeSelectedUids[pointed.Uid] then
        self:OnDecomposeTicketClicked(pointed, true)
      end
      IsEventHandled = true
    elseif "Gamepad_Special_Right" == InKeyName then
      local sell = self.IronExp_Popup_Sell
      if sell and sell.ClickToOpenStuffList then
        local bExpanding = not sell.bIsOpenList
        sell.CurFocusWidget = bExpanding and "ToSellListView" or "DefaultWidget"
        sell:ClickToOpenStuffList()
        if bExpanding and sell.List_Item then
          sell.List_Item:SetFocus()
        end
        self:RefreshDecomposeBottomKey()
      end
      IsEventHandled = true
    elseif "Gamepad_RightThumbstick" == InKeyName then
      local sell = self.IronExp_Popup_Sell
      if sell and sell.ItemBox then
        local child = sell.ItemBox:GetChildAt(0)
        if child then
          sell.CurFocusWidget = "GetItemBox"
          child:SetFocus()
          self:RefreshDecomposeBottomKey()
          if sell.UpdateUIStyleInPlatform then
            sell:UpdateUIStyleInPlatform(false)
          end
        end
      end
      IsEventHandled = true
    elseif "Gamepad_LeftThumbstick" == InKeyName then
      self.GPadFocusState = GPAD_STATE_SORT
      self.Com_Sort:SetFocus()
      IsEventHandled = true
    end
    return IsEventHandled
  end
  if self.GPadFocusState == GPAD_STATE_LIST then
    if "Gamepad_FaceButton_Left" == InKeyName then
      self:OnDecomposeBtnClicked()
      return true
    elseif "Gamepad_FaceButton_Top" == InKeyName then
      self:OnShopBtnClicked()
      return true
    elseif "Gamepad_RightThumbstick" == InKeyName then
      self:OnForgeBtnClicked(self.ForgeTicketId)
      return true
    end
  end
  if "Gamepad_LeftThumbstick" == InKeyName then
    if self.GPadFocusState == GPAD_STATE_REWARD then
      self:GamepadFocusRewardInner()
    elseif self.GPadFocusState == GPAD_STATE_REWARD_INNER then
      self:GamepadExitRewardInner()
    else
      self.GPadFocusState = GPAD_STATE_SORT
      self.Com_Sort:SetFocus()
      self:RefreshMidKeyTips()
    end
    IsEventHandled = true
  elseif "Gamepad_Special_Left" == InKeyName then
    self:GamepadFocusRewardUnlocked()
    IsEventHandled = true
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.GPadFocusState == GPAD_STATE_REWARD_INNER then
      self:GamepadExitRewardInner()
    elseif self.GPadFocusState ~= GPAD_STATE_LIST then
      self:GamepadFocusListFirst()
    else
      self:OnBtnCancelClicked()
    end
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    if self.bDecomposeMode then
      self:BeginExitDecomposeMode()
    else
      self:OnBtnCancelClicked()
    end
    IsEventHandled = true
  elseif "SpaceBar" == InKeyName then
    if not self.bDecomposeMode then
      self:OnBtnStartClicked()
    end
    IsEventHandled = true
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:OnBtnCancelClicked()
  self:Close()
  if IsValid(self.ParentWidget) and self.ParentWidget.FocusIronExpTitle then
    self.ParentWidget:FocusIronExpTitle()
  end
end

function M:OnBtnStartClicked()
  if not self.SelectedTicketUid then
    return
  end
  if self.bSelectedTicketBlocked then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Toast_MaxTicketLevel"))
    return
  end
  if type(self.StartCallback) == "function" then
    self.StartCallback(self.SelectedTicketUid, self.SelectedTicketLevel)
  end
  self:Close()
  if IsValid(self.ParentWidget) and self.ParentWidget.FocusIronExpTitle then
    self.ParentWidget:FocusIronExpTitle()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsGamepad = CurInputDevice == ECommonInputType.Gamepad
  self:RefreshIronBtnGamepadKeys(IsGamepad)
  if IsGamepad and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    if self.bDecomposeMode then
      local sell = self.IronExp_Popup_Sell
      if sell and sell.bIsOpenList and sell.List_Item then
        sell.CurFocusWidget = "ToSellListView"
        sell.List_Item:SetFocus()
      else
        self.GPadFocusState = GPAD_STATE_DECOMPOSE
        self.List_Item:SetFocus()
        self:RefreshMidKeyTips()
      end
    else
      self:GamepadFocusListFirst()
    end
  elseif not IsGamepad then
    if IsValid(self.Com_MidKeyTips) then
      self.Com_MidKeyTips:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.FocusedRewardEntry and self.FocusedRewardEntry.Normal then
      self.FocusedRewardEntry:PlayAnimation(self.FocusedRewardEntry.Normal)
    end
    self:SetAllRewardInnerListsInteractive(true)
    if not self.bDecomposeMode then
      self.GPadFocusState = GPAD_STATE_LIST
    end
  end
  if self.bDecomposeMode then
    self:RefreshDecomposeBottomKey()
    local sell = self.IronExp_Popup_Sell
    if sell and sell.OnUpdateUIStyleByInputTypeChange then
      sell:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
    end
  end
  self.Super.RefreshOpInfoByInputDevice(self, CurInputDevice, CurGamepadName)
end

function M:Destruct()
  self.Super.Destruct(self)
  AudioManager(self):SetEventSoundParam(self, "IronExpShow", {ToEnd = 1})
  self:RemoveTimer("StaggerList")
  self:RemoveTimer("UnlockAnim")
  if self.Sift then
    self.Sift:Close()
  end
end

return M
