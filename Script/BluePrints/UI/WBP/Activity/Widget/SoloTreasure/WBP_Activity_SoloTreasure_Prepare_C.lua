require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet
local SquadBuildComponent = require("BluePrints.UI.UI_PC.Common.SquadBuildComponent")
local SoloTreasureUtils = require("BluePrints.UI.WBP.SoloTreasure.Widget.SoloTreasureUtils")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local EMCache = require("EMCache.EMCache")
local TimeUtils = require("Utils.TimeUtils")
local CommonUtils = require("Utils.CommonUtils")
M._components = {
  "BluePrints.UI.UI_PC.Common.SquadBuildComponent",
  "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_SoloTreasure_Prepare_GamepadComp"
}
M.ESlotName = SquadBuildComponent.ESlotName
M.SlotName2Type = SquadBuildComponent.SlotName2Type
M.SlotNameOrder = SquadBuildComponent.SlotNameOrder
M.SlotType2DataType = SquadBuildComponent.SlotType2DataType
M.EUIType = {Listing = 1, Bag = 2}
M.EDungeonType = {Repeat = 1, Story = 2}
local EnterDungeonDontRemindTimeStamp = "SoloTreasure_EnterDungeon_DontRemind_TimeStamp"
local SlotOrder = {
  [1] = "Char",
  [2] = "Melee",
  [3] = "Ranged",
  [4] = "Phantom1",
  [5] = "PhantomWeapon1",
  [6] = "Phantom2",
  [7] = "PhantomWeapon2"
}

function M:Construct()
  self.Listing.TileView_Select_Role.OnCreateEmptyContent:Unbind()
  self.Listing.TileView_Select_Role.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  local Slots = {
    [self.ESlotName.Char] = self.Build.Character,
    [self.ESlotName.MeleeWeapon] = self.Build.Melee,
    [self.ESlotName.RangedWeapon] = self.Build.Ranged,
    [self.ESlotName.Pet] = self.Build.Pet,
    [self.ESlotName.Phantom1] = self.Build.Head_Phantom01,
    [self.ESlotName.PhantomWeapon1] = self.Build.Weapon_Phantom01,
    [self.ESlotName.Phantom2] = self.Build.Head_Phantom02,
    [self.ESlotName.PhantomWeapon2] = self.Build.Weapon_Phantom02
  }
  self:InitSquadBuildWidget(Slots, self.Listing.TileView_Select_Role, self.Listing.Sort, self.Listing.EMListView_Filter, self.Pos_Tip, self.Listing.Tab_Primary, self.Listing.Empty, self.Listing.Text_Empty, self.Listing.Type_Range, self.Listing.Type_Melee, self, self.Listing.Panel_FilterTab)
  self:InitSquadBuildData(nil)
  self.Build.Bag.Btn_Click.OnClicked:Add(self, self.OnBagClicked)
  self:InitTextMap()
  self.Btn_Clear.Btn_Click.OnClicked:Add(self, self.OnClearClicked)
  self.Btn_Clear.Btn_Click.OnPressed:Add(self, self.OnClearPressed)
  self.Btn_Start.Btn_Click.OnClicked:Add(self, self.OnStartClicked)
  self.Btn_Start.Btn_Click.OnPressed:Add(self, self.OnStartPressed)
  self.Preview.Btn_Bag.Btn_Click.OnClicked:Add(self, self.OnPreviewBagClicked)
  self.Preview.Btn_Bag.Btn_Click.OnPressed:Add(self, self.OnPreviewBagPressed)
  self:InitGamePad()
  self:InitNavigation()
  self.List_Bag.OnCreateEmptyContent:Bind(self, function()
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.SoloTreasureCurrentId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  self.SoloTreasureTicketResourceId = DataMgr.GlobalConstant.SoloTreasureTicketResourceId.ConstantValue
  self.SoloTreasureTicketShopId = DataMgr.GlobalConstant.SoloTreasureTicketShopId.ConstantValue
end

function M:Destruct()
  self.List_Bag.OnCreateEmptyContent:Unbind()
  self:DestroyActorController()
end

function M:InitTextMap()
  local BuildWidget = self.Build
  BuildWidget.Text_CostDesc:SetText(GText("UI_SoloTreasureEvent_EntryCost"))
  BuildWidget.Text_BagCostDesc:SetText(GText("UI_SoloTreasureEvent_BagCost"))
  BuildWidget.Text_Total:SetText(GText("UI_SoloTreasureEvent_TotalCost"))
  BuildWidget.Text_Tip:SetText(GText("UI_SoloTreasureEvent_NoReturnTips"))
  self.Btn_Clear.Text_Button:SetText(GText("UI_SoloTreasureEvent_CleanUpSet"))
  self.Btn_Start.Text_Button:SetText(GText("UI_SoloTreasureEvent_EntryDungeon"))
  self.Build.Text_Character:SetText(GText("UI_Armory_Char"))
  self.Build.Text_Phantom:SetText(GText("UI_Shadow_Name"))
  self.Preview.Text_Tips:SetText(GText("UI_SoloTreasure_BagLocked"))
end

function M:SwitchIn(...)
  self.Build.Bag:PlayAnimation(self.Build.Bag.Normal)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:InitTable()
  self.DungeonType, self.DungeonId, self.IsHardMode = ...
  if self.IsHardMode == nil then
    self.IsHardMode = false
  end
  self:CreateActorController()
  self:Enter(self.DungeonType, self.DungeonId, self.IsHardMode)
  self:SwitchUIType(self.EUIType.Listing)
  self:AddTimer(0.1, function()
    self:SetDefaultFocus()
  end)
  self:OnUpdateUIStyleByInputTypeChange(self.Root.GameInputModeSubsystem:GetCurrentInputType(), self.Root.GameInputModeSubsystem:GetCurrentGamepadName())
end

function M:SwitchOutWithCallback(Callback, ...)
  self.SwitchOutCallback = Callback
  local CurrentSquad = self:GetCurrentSquad()
  CurrentSquad.BagIndex = self.ChooseBagContent.Index
  local SquadChanged = not self:IsSquadEqual(self.TeamInfos, CurrentSquad)
  if SquadChanged then
    local Params = {
      ShortText = GText("UI_CommonPopup_SaveLayout_Content"),
      LeftCallbackObj = self,
      LeftCallbackFunction = function(Obj)
        Obj:AddTimer(0.1, function()
          Obj:DoSwitchOut()
        end)
      end,
      RightCallbackObj = self,
      RightCallbackFunction = function(Obj)
        Obj:SaveSquadToServer(function(Success)
          Obj:DoSwitchOut()
        end)
      end
    }
    local PopupUI = UIManager(self):ShowCommonPopupUI(100323, Params)
    if PopupUI then
      self:AddTimer(0.1, function()
        PopupUI:SetFocus()
      end)
    end
  else
    self:DoSwitchOut()
  end
end

function M:SaveSquadToServer(Callback)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    if Callback then
      Callback(false)
    end
    return
  end
  local EventId = self.Root and self.Root.EventId
  if not EventId then
    DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:SaveSquadToServer - EventId无效")
    if Callback then
      Callback(false)
    end
    return
  end
  local CurrentSquad = self:GetCurrentSquad()
  if not CurrentSquad then
    DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:SaveSquadToServer - 阵容数据无效")
    if Callback then
      Callback(false)
    end
    return
  end
  CurrentSquad.BagIndex = self.ChooseBagContent.Index
  Avatar:SetTreasureHuntSquad(EventId, self.DungeonId, CurrentSquad, self.IsHardMode, Callback)
end

function M:DoSwitchOut()
  if not self.BindOutAnimation then
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
        self:DestroyActorController()
        if self.SwitchOutCallback then
          local Callback = self.SwitchOutCallback
          self.SwitchOutCallback = nil
          Callback()
        end
      end
    })
    self.BindOutAnimation = true
  end
  self:PlayAnimation(self.Out)
  self:ClearAllSlots()
  self.LastSelectedBagItemUIIndex = nil
  self.ChooseBagIndex = nil
end

function M:InitTable()
  self.TabConfigData = {
    OverridenTopResouces = {
      self.SoloTreasureCurrentId,
      self.SoloTreasureTicketResourceId
    },
    TitleName = GText("UI_SoloTreasureEvent_ArmorySet"),
    DynamicNode = {
      "Back",
      "BottomKey",
      "ResourceBar"
    },
    StyleName = "Text",
    OwnerPanel = self.Root,
    BackCallback = self.Root.OnReturnKeyDown,
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  }
  self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
end

function M:OnBagClicked()
  local PreSlotName = self.CurSlotName
  if PreSlotName ~= self.ESlotName.Null and self.Slots[PreSlotName] and self.Slots[PreSlotName].SetIsChecked then
    self.Slots[PreSlotName]:SetIsChecked(false)
  end
  self:SwitchUIType(self.EUIType.Bag)
end

function M:UpdateListSelect(SlotName)
  self:SwitchUIType(self.EUIType.Listing)
  if self.IsUseGamePad then
    if self.bListEmpty then
      self:ChangeFocusMode(3)
      self.EMListView_Filter:SetFocus()
    else
      self:ChangeFocusMode(2)
      self:AddTimer(0.1, function()
        DebugPrint("jly@UpdateListSelect")
        self.Listing.TileView_Select_Role:SetFocus()
      end)
    end
  end
end

function M:OnClearClicked()
  if self.Btn_Clear.Btn_Click:GetForbidden() then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreasure_ArmoryEmptyComponent"))
    return
  end
  local Params = {
    LeftCallbackObj = self,
    LeftCallbackFunction = function(Obj)
    end,
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj)
      Obj:DoClearSlots()
    end,
    CloseBtnCallbackObj = self,
    CloseBtnCallbackFunction = function(Obj)
    end
  }
  local PopupUI = UIManager(self):ShowCommonPopupUI(100318, Params)
  if PopupUI then
    self:AddTimer(0.1, function()
      PopupUI:SetFocus()
    end)
  end
end

function M:DoClearSlots()
  self:ClearAllSlots()
  self:UpdateActionButtonsState()
end

function M:OnStartClicked()
  if self.Btn_Start.Btn_Click:GetForbidden() then
    local CanStart, ErrorMsg = self:CheckCanStart()
    if -1 == ErrorMsg then
      local Params = {}
      
      function Params.RightCallbackFunction()
        local ShopItemId = self.SoloTreasureTicketShopId
        local SubTabId = DataMgr.ShopItem[ShopItemId].SubTabId
        local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
        self.List_Bag:ClearListItems()
        PageJumpUtils:JumpToShopPage(MainTabId, SubTabId, ShopItemId, "SoloTreasureShop", function()
          self:UpdateActionButtonsState()
          self:UpdateChooseBagUI()
        end, self)
      end
      
      UIManager(self):ShowCommonPopupUI(100339, Params)
      return
    end
    if not CanStart then
      UIManager():ShowUITip(UIConst.Tip_CommonToast, ErrorMsg)
      self:PlayFlashRedAnimForEmptySlots()
    end
    return
  end
  local LastRemindTimeStamp = EMCache:Get(EnterDungeonDontRemindTimeStamp, true)
  if LastRemindTimeStamp and LastRemindTimeStamp > TimeUtils.TimestampLastClock(0) then
    self:EnterEventDungeon()
    return
  end
  local Params = {
    LeftCallbackObj = self,
    LeftCallbackFunction = function(Obj)
    end,
    RightCallbackObj = self,
    RightCallbackFunction = function(Obj, Data)
      self:UpdatePopupSelectedInfo(Data, EnterDungeonDontRemindTimeStamp)
      Obj:EnterEventDungeon()
    end,
    CloseBtnCallbackObj = self,
    CloseBtnCallbackFunction = function(Obj)
    end
  }
  local PopupUI = UIManager(self):ShowCommonPopupUI(100317, Params)
  if PopupUI then
    self:AddTimer(0.1, function()
      PopupUI:SetFocus()
    end)
  end
end

function M:EnterEventDungeon()
  self:SaveSquadToServer(function(SaveRet)
    if SaveRet ~= ErrorCode.RET_SUCCESS then
      DebugPrint("WBP_Activity_SoloTreasure_Prepare_C:EnterEventDungeon - 保存阵容失败")
      UIManager():ShowUITip(UIConst.Tip_CommonToast, ErrorCode:GetText(SaveRet))
      return
    end
    
    local function Callback(Ret)
      if Ret == ErrorCode.RET_SUCCESS then
        local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
        local CurTabIndex = 1
        if ActivityMain then
          CurTabIndex = ActivityMain.CurTabId
        end
        local ExitDungeonInfo = {
          Type = "SoloTreasure",
          EventId = self.Root.EventId,
          CurTabIndex = CurTabIndex,
          DungeonId = self.DungeonId
        }
        GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
      else
        UIManager():ShowUITip(UIConst.Tip_CommonToast, ErrorCode:GetText(Ret))
      end
    end
    
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local IsStory = self.DungeonType == self.EDungeonType.Story
      local IsEasy = not self.IsHardMode
      Avatar:EnterSoloTreasure(self.DungeonId, self.Root.EventId, nil, IsStory, IsEasy, Callback)
    end
  end)
end

function M:UpdatePopupSelectedInfo(Data, CacheKey)
  local IsSelected = Data.SelectHint.IsSelected
  if IsSelected then
    local NowTime = TimeUtils.NowTime()
    EMCache:Set(CacheKey, NowTime, true)
  end
end

function M:OnClearPressed()
  if self.Btn_Clear.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_cancel", nil, nil)
end

function M:OnStartPressed()
  if self.Btn_Start.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_confirm", nil, nil)
end

function M:OnPreviewBagClicked()
  if self.Preview.Btn_Bag.Btn_Click:GetForbidden() then
    return
  end
  local ShopItemId = self.SelectBagContent.ShopItemId
  if self.SelectBagContent.IsLock then
    local SubTabId = DataMgr.ShopItem[ShopItemId].SubTabId
    local MainTabId = DataMgr.ShopTabSub[SubTabId].MainTabId
    PageJumpUtils:JumpToShopPage(MainTabId, SubTabId, ShopItemId, "SoloTreasureShop", function()
    end, self)
  else
    self.LastSelectedBagItemUI:SetIsChosen(true)
    self.Preview.Btn_Bag.Btn_Click:SetForbidden(true)
    self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_BagInUse"))
    self:OnChooseBag(self.SelectBagContent)
  end
end

function M:OnPreviewBagPressed()
  if self.Preview.Btn_Bag.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_normal_btn_click_confirm", nil, nil)
end

function M:SwitchUIType(UIType)
  if self.IsUseGamePad and UIType == self.EUIType.Bag then
    self:ChangeFocusMode(6)
    if self.CurUIType == self.EUIType.Listing then
      self:AddTimer(0.2, function()
        self.List_Bag:SetFocus()
      end)
    else
      self.List_Bag:SetFocus()
    end
  end
  if self.CurUIType == UIType then
    return
  end
  self.CurUIType = UIType
  if UIType == self.EUIType.Listing then
    self:PlayAnimation(self.Left_Listing_In)
    self.Build.Bag:SetIsChecked(false)
    self.Build.Bag:SetVisibility(UE4.ESlateVisibility.Visible)
  elseif UIType == self.EUIType.Bag then
    self:PlayAnimation(self.Left_Bag_In)
    self.Build.Bag:SetIsChecked(true)
    self.CurSlotName = "Bag"
    self.Build.Bag:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  end
end

function M:Enter(DungeonType, DungeonId, IsHardMode)
  self.DungeonType = DungeonType
  self.DungeonId = DungeonId
  self.IsHardMode = IsHardMode
  local EventId = self.Root and self.Root.EventId
  if not EventId then
    DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - EventId无效")
  end
  if not self.DungeonId then
    DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - DungeonId无效")
  end
  self:CalculateModeFee()
  self:UpdateModeUI()
  local SavedSquad
  if DungeonId and EventId then
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.TreasureHunts then
      local TreasureHuntData = Avatar.TreasureHunts[EventId]
      if TreasureHuntData then
        SavedSquad = TreasureHuntData:GetSquadInfo(DungeonId, self.IsHardMode)
      end
    end
  end
  if nil == SavedSquad then
    SavedSquad = {BagIndex = 1}
  end
  self.TeamInfos = SavedSquad
  self:InitWidget()
  self:InitDungeonData(DungeonType, DungeonId)
  self:InitDetailPanels()
  local SelectedSlot = self.ESlotName.Char
  self:OnSlotClicked(SelectedSlot, true)
  self.FocusWidget = self.Build.Character
  self:UpdateActionButtonsState()
  if IsHardMode then
    self.Slots[self.ESlotName.Phantom1]:SetLockState(true)
    self.Slots[self.ESlotName.Phantom2]:SetLockState(true)
    self.Slots[self.ESlotName.PhantomWeapon1]:SetLockState(true)
    self.Slots[self.ESlotName.PhantomWeapon2]:SetLockState(true)
  else
    self.Slots[self.ESlotName.Phantom1]:SetLockState(false)
    self.Slots[self.ESlotName.Phantom2]:SetLockState(false)
    self.Slots[self.ESlotName.PhantomWeapon1]:SetLockState(false)
    self.Slots[self.ESlotName.PhantomWeapon2]:SetLockState(false)
  end
end

function M:InitDungeonData(DungeonType, DungeonId)
  if not DungeonId then
    return
  end
  local TrialData, LimitData, LevelConfig
  if DungeonType == self.EDungeonType.Story then
    LevelConfig = DataMgr.TreasureHuntStoryDungeon[DungeonId]
  elseif DungeonType == self.EDungeonType.Repeat then
    LevelConfig = DataMgr.TreasureHuntRepeatDungeon[DungeonId]
  end
  if not LevelConfig then
    return
  end
  self:InitBagList(LevelConfig.LevelBackPack)
  local TrialMeleeWeapons, TrialRangedWeapons = self:GetWeaponTypeList(LevelConfig.TrialWeapon)
  TrialData = {
    TrialChars = LevelConfig.TrialCharacter or {},
    TrialMeleeWeapons = TrialMeleeWeapons,
    TrialRangedWeapons = TrialRangedWeapons,
    TrialPets = LevelConfig.TrialPet or {},
    ShowOwned = {
      Chars = true,
      Weapons = true,
      Pets = DungeonType == self.EDungeonType.Repeat
    }
  }
  if DungeonType == self.EDungeonType.Story then
    if -1 == TrialData.TrialPets[1] then
      TrialData.ShowOwned.Pets = true
      TrialData.TrialPets = {}
    end
    local LimitMeleeWeapons, LimitRangedWeapons = self:GetWeaponTypeList(LevelConfig.LimitWeapon)
    LimitData = {
      LimitCharacters = LevelConfig.LimitCharacter or {},
      LimitMeleeWeapons = LimitMeleeWeapons,
      LimitRangedWeapons = LimitRangedWeapons,
      LimitPets = LevelConfig.LimitPet or {}
    }
  end
  if TrialData then
    self.TrialData = TrialData
    self.LimitData = LimitData
    self:CharMain_Init(true)
    self:MeleeMain_Init(true)
    self:RangedMain_Init(true)
    self:PetMain_Init(true)
  end
end

function M:InitDetailPanels()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("M:InitDetailPanels, 配置面板初始化失败，Avatar无效")
    return
  end
  if not self.TeamInfos then
    self:ClearAllSlots()
    return
  end
  local Squad = self.TeamInfos
  for _, SlotName in ipairs(self.SlotNameOrder) do
    local EName = self.ESlotName[SlotName]
    if not EName then
    else
      local SlotInfo = Squad[SlotName]
      if not SlotInfo or not SlotInfo.Id then
      else
        local Id = SlotInfo.Id
        local IsTryout = SlotInfo.bTrial or false
        local SlotType = self.SlotName2Type[EName]
        local DataType = self.SlotType2DataType[SlotType]
        local Content
        if "Char" == SlotName or "Phantom1" == SlotName or "Phantom2" == SlotName then
          Content = self.CharItemContentsMap[Id]
        elseif "MeleeWeapon" == SlotName or "RangedWeapon" == SlotName or "PhantomWeapon1" == SlotName or "PhantomWeapon2" == SlotName then
          local WeaponTag = "RangedWeapon" == SlotName and CommonConst.ArmoryTag.Ranged or CommonConst.ArmoryTag.Melee
          Content = self[WeaponTag .. "ItemContentsMap"][Id]
          if nil == Content then
            Content = self.RangedItemContentsMap[Id]
          end
        elseif "Pet" == SlotName then
          Content = self.PetItemContentsMap[Id]
        end
        if not IsTryout then
          local Unit = Avatar[DataType .. "s"][Id]
          if not Unit then
            GWorld.logger.error("M:InitDetailPanels@该Id对应的物品已失效" .. CommonUtils.ObjId2Str(Id))
        end
        else
          if SlotInfo.ModIndex then
            Content.ModSuitIndex = SlotInfo.ModIndex
          end
          if Content then
            self:UpdateSlot(EName, Content)
          end
        end
      end
    end
  end
end

function M:OnLeftItemContentChanged()
  self:UpdateActionButtonsState()
end

function M:InitBagList(LevelBackPack)
  self.List_Bag:ClearListItems()
  local Avatar = GWorld:GetAvatar()
  local ChooseBagIndex = self.TeamInfos and self.TeamInfos.BagIndex or 1
  if self.ChooseBagIndex then
    ChooseBagIndex = self.ChooseBagIndex
  end
  local SelectBagIndex = self.LastSelectedBagItemUIIndex or ChooseBagIndex
  for i = 1, #LevelBackPack do
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    local BagID = LevelBackPack[i]
    local BagData = DataMgr.ExtractionTreasureBag[BagID]
    ItemContent.Price = BagData.Price
    ItemContent.Shape = BagData.Shape
    ItemContent.Index = i
    ItemContent.ParentWidget = self
    ItemContent.Name = BagData.Name
    ItemContent.ShapeType = BagData.ShapeType
    ItemContent.Shape = BagData.Shape
    ItemContent.ShopItemId = BagData.ShopItemId
    ItemContent.Condition = BagData.EventUnlockCondition
    ItemContent.IsSelected = i == SelectBagIndex
    ItemContent.IsChosen = i == ChooseBagIndex
    if ItemContent.Condition then
      if ConditionUtils.CheckCondition(Avatar, ItemContent.Condition) == false then
        ItemContent.IsLock = true
      else
        ItemContent.IsLock = false
      end
    else
      ItemContent.IsLock = false
    end
    self.List_Bag:AddItem(ItemContent)
    if i == SelectBagIndex then
      self:OnSelectBag(ItemContent)
    end
    if i == ChooseBagIndex then
      self:OnChooseBag(ItemContent)
    end
  end
  self.List_Bag:RequestFillEmptyContent()
end

function M:CalculateModeFee()
  if self.DungeonType == self.EDungeonType.Story then
    local LevelConfig = DataMgr.TreasureHuntStoryDungeon[self.DungeonId]
    local ModeFee = LevelConfig.Fee
    self.ModeFee = ModeFee
    self.ModeType = self.SoloTreasureCurrentId
  elseif self.DungeonType == self.EDungeonType.Repeat then
    local LevelConfig = DataMgr.TreasureHuntRepeatDungeon[self.DungeonId]
    local ModeFee = 0
    if self.IsHardMode then
      ModeFee = LevelConfig.HardModeFee
    else
      ModeFee = LevelConfig.EasyModeFee
    end
    self.ModeType = LevelConfig.FeeResource
    self.ModeFee = ModeFee
  end
end

function M:UpdateModeUI()
  local ResourceIcon
  if self.ModeType == self.SoloTreasureCurrentId then
    self.Build.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.Visible)
    ResourceIcon = DataMgr.Resource[self.SoloTreasureCurrentId].Icon
  elseif self.ModeType == self.SoloTreasureTicketResourceId then
    self.Build.Panel_Bottom:SetVisibility(UE4.ESlateVisibility.Collapsed)
    ResourceIcon = DataMgr.Resource[self.SoloTreasureTicketResourceId].Icon
  end
  self.Build.Icon_Cost:SetBrushFromTexture(LoadObject(ResourceIcon))
end

function M:OnSelectBag(Content)
  self.SelectBagContent = Content
  self:UpdatePreviewUI()
end

function M:OnChooseBag(Content)
  self.ChooseBagContent = Content
  self.ChooseBagIndex = Content.Index
  self:UpdateChooseBagUI()
  self:UpdateActionButtonsState()
end

function M:UpdateChooseBagUI()
  local BuildWidget = self.Build
  if self.ModeFee == nil then
    self.ModeFee = 0
  end
  BuildWidget.Bag.Text_Num:SetText(self.ChooseBagContent.Index)
  BuildWidget.Bag.Text_Cost:SetText(self.ChooseBagContent.Price)
  BuildWidget.Text_Cost:SetText(self.ModeFee)
  BuildWidget.Text_BagCost:SetText(self.ChooseBagContent.Price)
  self.TotalCost = self.ModeFee + self.ChooseBagContent.Price
  if self.ModeType == self.SoloTreasureTicketResourceId then
    self.TotalCost = self.ChooseBagContent.Price
  end
  BuildWidget.Text_TotalCost:SetText(self.TotalCost)
  local Avatar = GWorld:GetAvatar()
  local PlayerResourceAmount = 0
  local PlayerTicketResourceAmount = 0
  if Avatar and self.SoloTreasureCurrentId then
    PlayerResourceAmount = Avatar:GetResourceNum(self.SoloTreasureCurrentId)
    PlayerTicketResourceAmount = Avatar:GetResourceNum(self.SoloTreasureTicketResourceId)
  end
  local ColorWhite = FSlateColor()
  local ColorRed = FSlateColor()
  ColorWhite.SpecifiedColor.R = 1.0
  ColorWhite.SpecifiedColor.G = 1.0
  ColorWhite.SpecifiedColor.B = 1.0
  ColorRed.SpecifiedColor.R = 1.0
  ColorRed.SpecifiedColor.G = 0.0
  ColorRed.SpecifiedColor.B = 0.0
  if PlayerResourceAmount < self.TotalCost then
    BuildWidget.Text_TotalCost:SetColorAndOpacity(ColorRed)
  else
    BuildWidget.Text_TotalCost:SetColorAndOpacity(ColorWhite)
  end
  if self.ModeType == self.SoloTreasureTicketResourceId and PlayerTicketResourceAmount < self.ModeFee then
    BuildWidget.Text_Cost:SetColorAndOpacity(ColorRed)
  else
    BuildWidget.Text_Cost:SetColorAndOpacity(ColorWhite)
  end
  if self.ModeType == self.SoloTreasureTicketResourceId and PlayerResourceAmount < self.ChooseBagContent.Price then
    BuildWidget.Text_BagCost:SetColorAndOpacity(ColorRed)
  else
    BuildWidget.Text_BagCost:SetColorAndOpacity(ColorWhite)
  end
  BuildWidget.Bag.Text_Title:SetText(GText(self.ChooseBagContent.Name))
  local BagIconName = string.format("Texture2D'/Game/UI/Texture/Dynamic/Image/Prop/Activity/SoloTreasure/T_Activity_SoloTreasure_BagSign0%s.T_Activity_SoloTreasure_BagSign0%s'", self.ChooseBagContent.Index, self.ChooseBagContent.Index)
  local BagIcon = LoadObject(BagIconName)
  if BagIcon then
    BuildWidget.Bag.Icon_Bag:SetBrushFromTexture(BagIcon)
  end
end

function M:UpdatePreviewUI()
  SoloTreasureUtils:InitBagUI(self.Preview, self.SelectBagContent.ShapeType, self.SelectBagContent.Shape)
  self.Preview:BindToAnimationFinished(self.Preview.In, {
    self,
    self.OnInAnimationFinished
  })
  self.Preview:PlayAnimation(self.Preview.In)
  local IsLock = self.SelectBagContent.IsLock
  local IsChosen = self.SelectBagContent.IsChosen
  self.Preview.Btn_Bag.Btn_Click:SetForbidden(false)
  if IsLock then
    self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Visible)
    self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_GoToUnlockBag"))
  elseif IsChosen then
    self.Preview.Btn_Bag.Btn_Click:SetForbidden(true)
    self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_BagInUse"))
  else
    self.Preview.Panel_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Preview.Btn_Bag.Text_Button:SetText(GText("UI_SoloTreasure_UseBag"))
  end
end

function M:OnInAnimationFinished()
  if self.CurInputDeviceType ~= ECommonInputType.Gamepad or 6 ~= self.FocusMode then
    return
  end
  self.Preview:UnbindAllFromAnimationFinished(self.Preview.In)
  local BottomKeyInfo = {}
  DebugPrint("thy   OnInAnimationFinished JLy", self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd())
  if self.Preview.EMScrollBox_1:GetScrollOffsetOfEnd() > 0 then
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "RV"}
        },
        Desc = GText("UI_Controller_Slide"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
    self.Preview.EMScrollBox_1:SetScrollBarVisibility(UE4.ESlateVisibility.Visible)
    self.Preview.EMScrollBox_1:SetAlwaysShowScrollbar(true)
  else
    BottomKeyInfo = {
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.Root.OnReturnKeyDown,
            Owner = self.Root
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
    self.Preview.EMScrollBox_1:SetAlwaysShowScrollbar(false)
  end
  self.Root.Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
end

function M:CreateActorController()
  if self.ActorController then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Char
  if self.TeamInfos and self.TeamInfos.Char and Avatar.Chars[self.TeamInfos.Char] then
    Char = Avatar.Chars[self.TeamInfos.Char]
  elseif Avatar.CurrentChar and Avatar.Chars[Avatar.CurrentChar] then
    Char = Avatar.Chars[Avatar.CurrentChar]
  end
  local SoloTreasureSkyBoxColorIndex = DataMgr.GlobalConstant.SoloTreasureSkyBoxColorIndex.ConstantValue or 0
  self.ActorController = ActorController:New({
    ViewUI = self.Root,
    IsPreviewMode = true,
    Char = Char,
    bNeedEndCamera = false,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon,
    SkyBoxIndex = SoloTreasureSkyBoxColorIndex
  })
  if self.ActorController then
    self.ActorController:OnOpened(0)
    self.ActorController:FixedCameraTransTimeOnce(0)
    self.ActorController:SetMontageAndCamera(CommonConst.ArmoryType.Char, nil, nil)
  end
  self.ActorController:HidePlayerActor("SuqadRole", true)
end

function M:DestroyActorController()
  if self.ActorController then
    self.ActorController:OnClosed()
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleGamepadInput(InKeyName)
  elseif "Escape" == InKeyName then
    self:OnReturnKeyDown()
  elseif "Q" == InKeyName and self.IsTabPrimaryVisible then
    self.Listing.Type_Melee:OnBtnClicked()
    IsHandled = true
  elseif "E" == InKeyName and self.IsTabPrimaryVisible then
    self.Listing.Type_Range:OnBtnClicked()
    IsHandled = true
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnReturnKeyDown()
  if self.IsTipsOpen then
    self:CloseTips()
    return
  end
  if self.Root then
    self.Root:OpenSubUI(self.PreWidgetInfo, self.DungeonType)
  end
end

function M:UpdateActionButtonsState()
  local HasAnyItem = false
  if self.Slots then
    for EName, Slot in pairs(self.Slots) do
      if Slot and not Slot.IsEmpty then
        HasAnyItem = true
        break
      end
    end
  end
  self.Btn_Clear.Btn_Click:SetForbidden(not HasAnyItem)
  local CanStart = self:CheckCanStart()
  self.Btn_Start.Btn_Click:SetForbidden(not CanStart)
end

function M:CheckCanStart()
  local CanStart = self:CheckTeamCondition()
  if not CanStart then
    return false, GText("UI_SoloTreasure_ArmoryLackNecessaryComponent")
  end
  local SoloTreasureCurrent = self.SoloTreasureCurrentId
  local Avatar = GWorld:GetAvatar()
  local PlayerResourceAmount = 0
  if Avatar and SoloTreasureCurrent then
    PlayerResourceAmount = Avatar:GetResourceNum(SoloTreasureCurrent)
  end
  if self.ModeType == self.SoloTreasureTicketResourceId then
    local PlayerTicketResourceAmount = Avatar:GetResourceNum(self.SoloTreasureTicketResourceId)
    if PlayerTicketResourceAmount < self.ModeFee then
      return false, -1
    end
  end
  if PlayerResourceAmount < self.TotalCost then
    return false, GText("UI_SoloTreasure_ArmoryLackEntryFee")
  end
  return true, nil
end

function M:CheckTeamCondition()
  if self.Slots[self.ESlotName.Char] and self.Slots[self.ESlotName.Char].IsEmpty then
    return false
  end
  if self.Slots[self.ESlotName.MeleeWeapon] and self.Slots[self.ESlotName.MeleeWeapon].IsEmpty then
    return false
  end
  if self.Slots[self.ESlotName.RangedWeapon] and self.Slots[self.ESlotName.RangedWeapon].IsEmpty then
    return false
  end
  if self.Slots[self.ESlotName.Pet] and self.Slots[self.ESlotName.Pet].IsEmpty then
    return false
  end
  local isEmptyPhantom1 = self.Slots[self.ESlotName.Phantom1].IsEmpty
  local isEmptyPhantomWeapon1 = self.Slots[self.ESlotName.PhantomWeapon1].IsEmpty
  local isEmptyPhantom2 = self.Slots[self.ESlotName.Phantom2].IsEmpty
  local isEmptyPhantomWeapon2 = self.Slots[self.ESlotName.PhantomWeapon2].IsEmpty
  if isEmptyPhantom1 ~= isEmptyPhantomWeapon1 or isEmptyPhantom2 ~= isEmptyPhantomWeapon2 then
    return false
  end
  return true
end

function M:PlayFlashRedAnimForEmptySlots()
  local RequiredSlots = {
    {
      SlotName = self.ESlotName.Char,
      Name = "Char"
    },
    {
      SlotName = self.ESlotName.MeleeWeapon,
      Name = "MeleeWeapon"
    },
    {
      SlotName = self.ESlotName.RangedWeapon,
      Name = "RangedWeapon"
    },
    {
      SlotName = self.ESlotName.Pet,
      Name = "Pet"
    }
  }
  for _, SlotInfo in ipairs(RequiredSlots) do
    local SlotWidget = self.Slots[SlotInfo.SlotName]
    if SlotWidget and SlotWidget.IsEmpty and SlotWidget.PlayFlashRedAnim then
      SlotWidget:PlayFlashRedAnim()
    end
  end
  local Phantom1Slot = self.Slots[self.ESlotName.Phantom1]
  if Phantom1Slot and not Phantom1Slot.IsEmpty then
    local PhantomWeapon1Slot = self.Slots[self.ESlotName.PhantomWeapon1]
    if PhantomWeapon1Slot and PhantomWeapon1Slot.IsEmpty and PhantomWeapon1Slot.PlayFlashRedAnim then
      PhantomWeapon1Slot:PlayFlashRedAnim()
    end
  end
  local Phantom2Slot = self.Slots[self.ESlotName.Phantom2]
  if Phantom2Slot and not Phantom2Slot.IsEmpty then
    local PhantomWeapon2Slot = self.Slots[self.ESlotName.PhantomWeapon2]
    if PhantomWeapon2Slot and PhantomWeapon2Slot.IsEmpty and PhantomWeapon2Slot.PlayFlashRedAnim then
      PhantomWeapon2Slot:PlayFlashRedAnim()
    end
  end
end

function M:OnMouseButtonDown(MyGeometry, MouseEvent)
  if UKismetInputLibrary.PointerEvent_IsMouseButtonDown(MouseEvent, EKeys.LeftMouseButton) then
    self:CloseTips()
  end
end

function M:ReceiveEnterStateSelf(StackAction)
  if 1 == StackAction then
    self:InitDungeonData(self.DungeonType, self.DungeonId)
    self:ReInitListItems()
    self.TeamInfos = self:GetCurrentSquad()
    self:InitDetailPanels()
    self:RestoreFocusOnReturn()
    local HasItemRemoved = false
    local SlotNamesToCheck = {
      "MeleeWeapon",
      "RangedWeapon",
      "PhantomWeapon1",
      "PhantomWeapon2",
      "Pet"
    }
    for _, SlotName in ipairs(SlotNamesToCheck) do
      local SlotEnumName = self.ESlotName[SlotName]
      if not SlotEnumName then
      else
        local SlotWidget = self.Slots[SlotEnumName]
        if not SlotWidget or SlotWidget.IsEmpty then
        else
          local SlotContent = SlotWidget.Content
          if not SlotContent or not SlotContent.Uuid then
          elseif SlotContent.IsTryout then
          else
            local ContentExists = false
            if "MeleeWeapon" == SlotName then
              ContentExists = self.MeleeItemContentsMap[SlotContent.Uuid] ~= nil
            elseif "RangedWeapon" == SlotName then
              ContentExists = nil ~= self.RangedItemContentsMap[SlotContent.Uuid]
            elseif "PhantomWeapon1" == SlotName or "PhantomWeapon2" == SlotName then
              ContentExists = self.MeleeItemContentsMap and self.MeleeItemContentsMap[SlotContent.Uuid] ~= nil
            elseif "Pet" == SlotName then
              ContentExists = self.PetItemContentsMap and nil ~= self.PetItemContentsMap[SlotContent.Uuid]
            end
            if not ContentExists then
              self:ClearSlot(SlotEnumName)
              if self.TeamInfos then
                self.TeamInfos[SlotName] = nil
              end
              HasItemRemoved = true
            end
          end
        end
      end
    end
    if HasItemRemoved then
      UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_SoloTreasureEvent_WeaponNotExist"))
      self:UpdateActionButtonsState()
    end
    self:UpdateSquadModels()
  end
end

AssembleComponents(M)
return M
