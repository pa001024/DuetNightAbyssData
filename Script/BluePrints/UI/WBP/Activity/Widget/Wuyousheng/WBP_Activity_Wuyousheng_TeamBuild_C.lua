require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local UIUtils = require("Utils.UIUtils")
local TeamSelectComponent = require("BluePrints.UI.UI_PC.Common.TeamSelectComponent")
local SquadPresetUtils = require("Utils.SquadPresetUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet
M._components = {
  "BluePrints.UI.UI_PC.Common.TeamSelectComponent",
  "BluePrints.UI.WBP.Activity.Widget.Wuyousheng.WBP_Activity_Wuyousheng_TeamBuild_GamepadComp"
}
M.ESlotName = TeamSelectComponent.ESlotName
M.SlotName2Type = TeamSelectComponent.SlotName2Type
M.SlotType2DataType = TeamSelectComponent.SlotType2DataType
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
  self.List_Select.OnCreateEmptyContent:Unbind()
  self.List_Select.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    return Obj
  end)
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  self.TypeTabs = {
    [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.Type_Range,
    [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.Type_Melee
  }
  self.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
  self.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
  self.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self:InitItemDetailWidget()
  local Slots = {
    [self.ESlotName.Char] = self.Character,
    [self.ESlotName.MeleeWeapon] = self.Melee,
    [self.ESlotName.RangedWeapon] = self.Ranged,
    [self.ESlotName.Pet] = self.Pet,
    [self.ESlotName.Phantom1] = self.Head_Phantom01,
    [self.ESlotName.PhantomWeapon1] = self.Weapon_Phantom01,
    [self.ESlotName.Phantom2] = self.Head_Phantom02,
    [self.ESlotName.PhantomWeapon2] = self.Weapon_Phantom02
  }
  self:InitTeamSelect(Slots, self.List_Select, self.Sort, self.EMListView_Filter, self.ItemDetailsWidget, self.Pos_Tip, nil)
  self.Btn_Clear.Text_Btn:SetText(GText("ModFilter_ClearAll"))
  self.Btn_Clear.Btn_Click.OnClicked:Add(self, self.OnClearClicked)
  self.Btn_Clear.Btn_Click.OnPressed:Add(self, self.OnClearPressed)
  self.Btn_SwitchMod.Text_Btn:SetText(GText("UI_SHOP_SUBTAB_NAME_MOD"))
  self.Btn_SwitchMod.Btn_Click.OnClicked:Add(self, self.OnSwitchModClicked)
  self.Btn_SwitchMod.Btn_Click.OnPressed:Add(self, self.OnSwitchModPressed)
  self.Btn_Save.Text_Btn:SetText(GText("UI_WuyoushengEvent_GoToDungeon"))
  self.Btn_Save.Btn_Click.OnClicked:Add(self, self.OnSaveClicked)
  self.Btn_Save.Btn_Click.OnPressed:Add(self, self.OnSavePressed)
  self.Btn_Click.OnClicked:Add(self, self.OnBackgroundClicked)
  self.Btn_Click:SetTouchMethod(UE4.EButtonTouchMethod.Down)
  self.Text_DescTitle:SetText(GText("UI_WuyoushengEvent_LevelBuff"))
  self.Text_BuildTitle:SetText(GText("UI_WuyoushengEvent_EditTeam"))
  self.Text_ActivitySign:SetText(GText("UI_Wuyousheng_ArmoryEventOnly"))
  self.Text_Phantom01:SetText(GText("UI_STAT_Sigil"))
  self.Text_Phantom02:SetText(GText("UI_STAT_Sigil"))
  self:InitGamePad()
  self:InitNavigation()
  self:InitItemDetailWidget()
  self:AddTimer(0.1, function()
    self:OnUpdateUIStyleByInputTypeChange(self.Root.CurInputDevice, self.Root.CurGamepadName)
  end)
  self.LastCanSave = false
end

function M:OnClearClicked()
  self:ClearAllSlots()
  self:OnLeftItemContentChanged()
end

function M:OnClearPressed()
  if self.Btn_Clear.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

function M:OnSwitchModPressed()
  if self.Btn_SwitchMod.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_common", nil, nil)
end

function M:CheckTeamStatus()
  local HasAnyItem = false
  local HasAnySelfItem = false
  local Uuids = {}
  local Type = "Null"
  local Tag
  for _, SlotName in ipairs(SlotOrder) do
    local TempSlotName = SlotName
    if "Melee" == TempSlotName then
      TempSlotName = "MeleeWeapon"
    end
    if "Ranged" == TempSlotName then
      TempSlotName = "RangedWeapon"
    end
    local EName = self.ESlotName[TempSlotName]
    local Slot = self.Slots[EName]
    if Slot and not Slot.IsEmpty then
      HasAnyItem = true
      if not Slot.IsTryout then
        HasAnySelfItem = true
        table.insert(Uuids, Slot.Uuid)
        if "Null" == Type then
          Type = Slot.Type
          if "Weapon" == Type then
            Type = Slot.Content.Tag
          end
        end
        if not Tag then
          Tag = SlotName
          if "Melee" == Type or "Ranged" == Type then
            Tag = Type
          end
          if "Phantom1" == Tag or "Phantom2" == Tag then
            Tag = "Char"
          end
        end
      end
    end
  end
  return HasAnyItem, HasAnySelfItem, Uuids, Type, Tag
end

function M:OnSwitchModClicked()
  local HasAnyItem, HasAnySelfItem, Uuids, Type, Tag = self:CheckTeamStatus()
  if not HasAnyItem then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_EmptyTeam"))
    return
  end
  if not HasAnySelfItem then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_BanTrialModEdit"))
    return
  end
  local FakeReplaceChar = {
    BattleData = function()
      return {}
    end
  }
  local ModUI = ModController:OpenView(ModCommon.WuyoushengMod, Type, Tag, Uuids, nil, {
    Func = self.OnModClosed,
    Obj = self
  }, ModCommon.MainUICase.Normal, FakeReplaceChar)
end

function M:GetModType(SlotName)
  return self.SlotType2DataType[self.SlotName2Type[SlotName]]
end

function M:OnModClosed(...)
end

function M:InitWidget()
  self.bInList = false
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("jly@阵容配置界面Avatar获取失败")
    return
  end
  TeamSelectComponent.InitWidget(self)
end

function M:GetCurrentSquad()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local Squad = {}
  local ENameToSlotName = {}
  for SlotName, EName in pairs(self.ESlotName) do
    if type(EName) == "number" then
      ENameToSlotName[EName] = SlotName
    end
  end
  if self.Slots then
    for EName, Slot in pairs(self.Slots) do
      if not Slot or Slot.IsEmpty then
      else
        local SlotName = ENameToSlotName[EName]
        if not SlotName then
        else
          local SlotInfo = {}
          local IsTryout = Slot.IsTryout or false
          local SlotType = self.SlotName2Type[EName]
          local DataType = self.SlotType2DataType[SlotType]
          if IsTryout then
            SlotInfo.Id = Slot.UnitId
            SlotInfo.bTrial = true
          else
            if not Slot.Uuid then
              goto lbl_104
            end
            SlotInfo.Id = Slot.Uuid
            SlotInfo.bTrial = false
            if "Char" == DataType then
              local Char = Avatar.Chars[Slot.Uuid]
              if Char and Char.ModSuitIndex then
                SlotInfo.ModIndex = Char.ModSuitIndex
              end
            elseif "Weapon" == DataType then
              local Weapon = Avatar.Weapons[Slot.Uuid]
              if Weapon and Weapon.ModSuitIndex then
                SlotInfo.ModIndex = Weapon.ModSuitIndex
              end
            elseif "Pet" == DataType then
              local Pet = Avatar.Pets[Slot.Uuid]
              if Pet and Pet.ModSuitIndex then
                SlotInfo.ModIndex = Pet.ModSuitIndex
              end
            end
          end
          Squad[SlotName] = SlotInfo
        end
      end
      ::lbl_104::
    end
  end
  return Squad
end

local function DeepEqualTable(t1, t2, visited)
  visited = visited or {}
  if t1 == t2 then
    return true
  end
  local type1 = type(t1)
  local type2 = type(t2)
  if type1 ~= type2 then
    return false
  end
  if "table" ~= type1 then
    return t1 == t2
  end
  local key1 = tostring(t1)
  local key2 = tostring(t2)
  local visitKey = key1 .. "|" .. key2
  if visited[visitKey] then
    return true
  end
  visited[visitKey] = true
  local count1 = 0
  local count2 = 0
  for _ in pairs(t1) do
    count1 = count1 + 1
  end
  for _ in pairs(t2) do
    count2 = count2 + 1
  end
  if count1 ~= count2 then
    return false
  end
  for k, v1 in pairs(t1) do
    local v2 = t2[k]
    if nil == v2 then
      return false
    end
    if type(v1) == "table" and type(v2) == "table" then
      if not DeepEqualTable(v1, v2, visited) then
        return false
      end
    elseif v1 ~= v2 then
      return false
    end
  end
  return true
end

local function IsSquadEmpty(Squad)
  if not Squad then
    return true
  end
  for _ in pairs(Squad) do
    return false
  end
  return true
end

function M:IsSquadEqual(Squad1, Squad2)
  if not Squad1 and not Squad2 then
    return true
  end
  if not Squad1 then
    return IsSquadEmpty(Squad2)
  end
  if not Squad2 then
    return IsSquadEmpty(Squad1)
  end
  return DeepEqualTable(Squad1, Squad2)
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
    DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - EventId无效")
    if Callback then
      Callback(false)
    end
    return
  end
  local CurrentSquad = self:GetCurrentSquad()
  
  local function OnSaveCallback(ErrCode, Ret)
    if 0 == ErrCode then
      self.InitialSquad = CurrentSquad
      DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - 保存成功")
    else
      DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:SaveSquadToServer - 保存失败", ErrorCode:Name(ErrCode))
    end
    if Callback then
      Callback(0 == ErrCode)
    end
  end
  
  Avatar:WuyoushengSetSquad(EventId, self.DungeonId, CurrentSquad, OnSaveCallback)
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
  for SlotName, EName in pairs(self.ESlotName) do
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
      elseif Content then
        if SlotInfo.ModIndex then
          Content.ModSuitIndex = SlotInfo.ModIndex
        end
        self:UpdateSlot(EName, Content)
      end
    end
  end
end

function M:SlotSelectionChanged(SlotName, DungeonIndex, bToList)
  self:OnSlotClicked(SlotName)
end

function M:OnReturnKeyDown()
  if self.Root then
    self.Root:OpenSubUI(self.PreWidgetInfo, true)
  end
end

function M:SwitchIn(...)
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  self:InitTable()
  local DungeonId = (...)
  self:AddTimer(0.1, function()
    self:Enter(DungeonId)
  end)
  self.Root.RewardText:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function M:Enter(DungeonId)
  self.DungeonId = DungeonId
  local EventId = self.Root and self.Root.EventId
  if not EventId then
    DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - EventId无效")
  end
  if not self.DungeonId then
    DebugPrint("WBP_Activity_Wuyousheng_TeamBuild_C:Enter - DungeonId无效")
  end
  local SavedSquad
  if DungeonId and EventId then
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.WuyoushengActivity then
      local WuyoushengData = Avatar.WuyoushengActivity[EventId]
      if WuyoushengData then
        SavedSquad = WuyoushengData:GetSquadInfo(DungeonId)
      end
    end
  end
  local Avatar = GWorld:GetAvatar()
  SquadPresetUtils.FixMainPlayerInProps(Avatar, SavedSquad)
  self.TeamInfos = SavedSquad
  self.InitialSquad = SavedSquad
  self:InitWidget()
  local TrialData
  local LevelConfig = DataMgr.WuyoushengEventLevel[DungeonId]
  if LevelConfig then
    TrialData = {
      TrialChars = LevelConfig.LevelTrialChar or {},
      TrialMeleeWeapons = LevelConfig.LevelTrialMeleeWeapon or {},
      TrialRangedWeapons = LevelConfig.LevelTriaRangedlWeapon or {},
      TrialPets = LevelConfig.LevelPet or {},
      ShowOwned = {
        Chars = true,
        Weapons = true,
        Pets = false
      }
    }
    if LevelConfig.LevelBuffDes then
      self.Text_LevelDesc:SetText(GText(LevelConfig.LevelBuffDes))
    end
  end
  if TrialData then
    self.TrialData = TrialData
    self:CharMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Melee
    self:WeaponMain_Init()
    self.WeaponTag = CommonConst.ArmoryTag.Ranged
    self:WeaponMain_Init()
    self:PetMain_Init()
  end
  self:InitDetailPanels()
  local SelectedSlot = self.ESlotName.Char
  self:OnSlotClicked(SelectedSlot)
  self:OnLeftItemContentChanged()
end

function M:SwitchOut()
  local CurrentSquad = self:GetCurrentSquad()
  local SquadChanged = not self:IsSquadEqual(self.InitialSquad, CurrentSquad)
  if SquadChanged then
    local Params = {
      ShortText = GText("UI_CommonPopup_SaveLayout_Content"),
      LeftCallbackObj = self,
      LeftCallbackFunction = function(Obj)
        Obj:DoSwitchOut()
      end,
      RightCallbackObj = self,
      RightCallbackFunction = function(Obj)
        Obj:SaveSquadToServer(function(Success)
          Obj:DoSwitchOut()
        end)
      end,
      CloseBtnCallbackObj = self,
      CloseBtnCallbackFunction = function(Obj)
        Obj:DoSwitchOut()
      end
    }
    local PopupUI = UIManager(self):ShowCommonPopupUI(100160, Params)
    if PopupUI then
      self:AddTimer(0.1, function()
        PopupUI:SetFocus()
      end)
    end
  else
    self:DoSwitchOut()
  end
end

function M:DoSwitchOut()
  if not self.BindOutAnimation then
    self:BindToAnimationFinished(self.Out, {
      self,
      function()
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    })
    self.BindOutAnimation = true
  end
  self:PlayAnimation(self.Out)
  self:ClearAllSlots()
end

function M:InitTable()
  self.TabConfigData = {
    TitleName = GText("UI_Title_WuyoushengEvent"),
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

function M:UpdateListSelect(SlotName)
  if 8 == SlotName then
    self.Group_ActivitySign:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Tab_Sub:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Group_ActivitySign:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab_Sub:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
end

function M:OnSaveClicked()
  if not self:CheckTeamCondition() then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_NotMeetBattleRequirement"))
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
        Type = "MonsterRush",
        EventId = self.Root.EventId,
        CurTabIndex = CurTabIndex,
        DungeonId = self.DungeonId
      }
      GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
    end
  end
  
  self:SaveSquadToServer(function(Success)
    if Success then
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:EnterEventDungeon(Callback, self.DungeonId, nil, self.Root.EventId, nil)
      end
    else
      UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_Toast_SaveFailed"))
    end
  end)
end

function M:OnSavePressed()
  if self.Btn_Save.Btn_Click:GetForbidden() then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/wuyoudaguai_btn_click_enter_game", nil, nil)
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

function M:GetZOrder()
  return self.Root:GetZOrder()
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = true
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleGamepadInput(InKeyName)
  elseif "Escape" == InKeyName then
    self:OnReturnKeyDown()
  elseif "Q" == InKeyName and self.IsTabPrimaryVisible then
    self.Type_Melee:OnBtnClicked()
    IsHandled = true
  elseif "E" == InKeyName and self.IsTabPrimaryVisible then
    self.Type_Range:OnBtnClicked()
    IsHandled = true
  else
    IsHandled = false
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnLeftItemContentChanged()
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
  local HasAnyItemForMod, HasAnySelfItem = self:CheckTeamStatus()
  self.Btn_SwitchMod.Btn_Click:SetForbidden(not HasAnyItemForMod or not HasAnySelfItem)
  local CanSave = self:CheckTeamCondition()
  self.Btn_Save.Btn_Click:SetForbidden(not CanSave)
  if self.LastCanSave ~= CanSave then
    self.LastCanSave = CanSave
    if CanSave then
      self.Btn_Save:PlayAnimation(self.Btn_Save.Remind)
    end
  end
end

function M:OnBackgroundClicked()
  if self.bItemDetailsShowed then
    self:ShowItemDetails(false)
  end
end

AssembleComponents(M)
return M
