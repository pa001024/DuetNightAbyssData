require("UnLua")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local UIUtils = require("Utils.UIUtils")
local TeamSelectComponent = require("BluePrints.UI.UI_PC.Common.TeamSelectComponent")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local NullUUid = CommonConst.AbyssTeamNoChar
local NullUnitId = CommonConst.AbyssTeamNoPet
M._components = {
  "BluePrints.UI.UI_PC.Common.TeamSelectComponent"
}
M.ESlotName = TeamSelectComponent.ESlotName
M.SlotName2Type = TeamSelectComponent.SlotName2Type
M.SlotType2DataType = TeamSelectComponent.SlotType2DataType
M.SlotName2TextMap = {
  [M.ESlotName.Char] = GText("UI_Armory_Char"),
  [M.ESlotName.Pet] = GText("MAIN_UI_PET"),
  [M.ESlotName.RangedWeapon] = GText("Ranged") .. GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
  [M.ESlotName.MeleeWeapon] = GText("Melee") .. GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
  [M.ESlotName.Phantom1] = GText("UI_STAT_Sigil") .. "1",
  [M.ESlotName.PhantomWeapon1] = GText("UI_STAT_Sigil") .. "1" .. GText("UI_SHOP_SUBTAB_NAME_WEAPON"),
  [M.ESlotName.Phantom2] = GText("UI_STAT_Sigil") .. "2",
  [M.ESlotName.PhantomWeapon2] = GText("UI_STAT_Sigil") .. "2" .. GText("UI_SHOP_SUBTAB_NAME_WEAPON")
}
local SlotOrder = {
  [1] = "Char",
  [2] = "MeleeWeapon",
  [3] = "RangedWeapon",
  [4] = "Phantom1",
  [5] = "PhantomWeapon1",
  [6] = "Phantom2",
  [7] = "PhantomWeapon2"
}

function M:Construct()
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  if self.List_Lineup then
    self.TypeTabs = {
      [self.SlotName2Type[self.ESlotName.RangedWeapon]] = self.List_Lineup.Type_Range,
      [self.SlotName2Type[self.ESlotName.MeleeWeapon]] = self.List_Lineup.Type_Melee
    }
    if self.List_Lineup.Type_Range then
      self.List_Lineup.Type_Range:Init(self.SlotName2Type[self.ESlotName.RangedWeapon], self)
    end
    if self.List_Lineup.Type_Melee then
      self.List_Lineup.Type_Melee:Init(self.SlotName2Type[self.ESlotName.MeleeWeapon], self)
    end
    if self.List_Lineup.Tab_Primary then
      self.List_Lineup.Tab_Primary:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
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
  self:SetOnSavedStateChangedCallback(function(Component, bSaved)
  end)
  self.Btn_Clear.Text_Btn:SetText(GText("ModFilter_ClearAll"))
  self.Btn_Clear.Btn_Click.OnClicked:Add(self, self.OnClearClicked)
  self.Btn_SwitchMod.Text_Btn:SetText(GText("UI_SHOP_SUBTAB_NAME_MOD"))
  self.Btn_SwitchMod.Btn_Click.OnClicked:Add(self, self.OnSwithcModClicked)
end

function M:OnClearClicked()
  self:ClearAllSlots()
end

function M:IsLineupValid()
  local HasOwnedItem = false
  for EName, SlotName in ipairs(SlotOrder) do
    local Slot = self.Slots[EName]
    if Slot and not Slot.IsEmpty and not self:IsTrialItem(Slot.Uuid) then
      HasOwnedItem = true
      break
    end
  end
  return HasOwnedItem
end

function M:OnSwithcModClicked()
  local HasAnyItem = false
  for EName, SlotName in ipairs(SlotOrder) do
    local Slot = self.Slots[EName]
    if Slot and not Slot.IsEmpty then
      HasAnyItem = true
      break
    end
  end
  if not HasAnyItem then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_TeamBuild_EmptyLineup"))
    return
  end
  if not self:IsLineupValid() then
    UIManager():ShowUITip(UIConst.Tip_CommonToast, GText("UI_Wuyousheng_TeamBuild_EmptyLineup"))
    return
  end
  local ZOrder = self.Root:GetZOrder()
  local Target = self.ComparedTarget or self.Target
  local TabExInfos = {}
  local Uuids = {}
  local Type = "Null"
  local Tag = "Null"
  Type = self:GetCurModType()
  for EName, SlotName in ipairs(SlotOrder) do
    local Slot = self.Slots[EName]
    if Slot and not Slot.IsEmpty then
      if EName == self.CurSlotName then
        Tag = SlotName
        if "MeleeWeapon" == Tag then
          Tag = "Melee"
        elseif "RangedWeapon" == Tag then
          Tag = "Ranged"
        end
      end
      table.insert(Uuids, Slot.Uuid)
      if "Char" == SlotName then
        local MainChar = GWorld:GetAvatar().Chars[Slot.Uuid]
        if MainChar then
          for _, Uuid in ipairs(MainChar.UWeaponEids or {}) do
            table.insert(Uuids, Uuid)
          end
        end
      end
      if "Phantom1" == SlotName or "Phantom2" == SlotName then
        TabExInfos[Slot.Uuid] = {TeamIdx = 1, Tag = SlotName}
      end
      if "PhantomWeapon1" == SlotName or "PhantomWeapon2" == SlotName then
        local PhantomSlotName = string.gsub(SlotName, "Weapon", "")
        local PhantomSlotEnum = self.ESlotName[PhantomSlotName]
        local OwnerCharUuid = self.Slots[PhantomSlotEnum] and self.Slots[PhantomSlotEnum].Uuid
        if OwnerCharUuid then
          TabExInfos[Slot.Uuid] = {
            Tag = SlotName,
            OwnerChar = GWorld:GetAvatar().Chars[OwnerCharUuid],
            IsPhantom = true
          }
        end
      end
    end
  end
  if "Null" == Tag then
    for EName, SlotName in ipairs(SlotOrder) do
      local Slot = self.Slots[EName]
      if Slot and not Slot.IsEmpty then
        Tag = SlotName
        if "MeleeWeapon" == Tag then
          Tag = "Melee"
        elseif "RangedWeapon" == Tag then
          Tag = "Ranged"
        end
        Type = self:GetModType(EName)
        break
      end
    end
  end
  local FakeReplaceChar = {
    BattleData = function()
      return {}
    end
  }
  local ModUI = ModController:OpenView(ModCommon.AbyssMod, Type, Tag, Uuids, TabExInfos, {
    Func = self.OnModClosed,
    Obj = self
  }, ModCommon.MainUICase.Normal, FakeReplaceChar)
  if ModUI then
    if "Melee" == Tag or "Ranged" == Tag then
      Tag = Tag .. "Weapon"
    end
    ModUI.List_Role:NavigateToIndex(self.ESlotName[Tag] - 1)
  end
end

function M:GetCurModType()
  return self.SlotType2DataType[self.SlotName2Type[self.CurSlotName]]
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
  self:ClearAllSlots()
  TeamSelectComponent.InitWidget(self)
end

function M:CheckUnit(UnitId)
  if type(UnitId) == "number" then
    return UnitId ~= NullUnitId
  else
    return UnitId ~= NullUUid
  end
end

function M:Enter(DungeonId)
  self.Saved = true
  self.InList = nil
  self.ReturnPressed = false
  self.bItemDetailsShowed = false
  if DungeonId then
    self.TeamInfos = nil
    self.LevelIndex = nil
  else
    self.TeamInfos = nil
    self.LevelIndex = nil
  end
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
  end
  if TrialData then
    self.TrialData = TrialData
    if self.CharItemContentsMap then
      self:CharMain_CreateItemContents()
    end
    if self.MeleeItemContentsMap then
      self.WeaponTag = CommonConst.ArmoryTag.Melee
      self:WeaponMain_CreateItemContents()
    end
    if self.RangedItemContentsMap then
      self.WeaponTag = CommonConst.ArmoryTag.Ranged
      self:WeaponMain_CreateItemContents()
    end
    if self.PetItemContentsMap then
      self:PetMain_CreateItemContents()
    end
  end
  if LevelInfo then
    self:InitDungeons(LevelInfo.DungeonIds, SelectedDungeon)
  else
    self:InitDungeons(nil, SelectedDungeon)
  end
  self:InitDetailPanels()
  local SelectedSlot = SelectedSlot or self.ESlotName.Char
  self:OnSlotClicked(SelectedSlot)
end

function M:InitDungeons(DungeonIds, SelectedDungeon)
  if not DungeonIds or type(DungeonIds) ~= "table" then
    DebugPrint("lhr@M:Enter, 副本Id无效")
    return
  end
  self.DungeonIds = DungeonIds
  if self.Team_Detail2 then
    self.Team_Detail2:SetVisibility(UE4.ESlateVisibility.Collapsed)
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
  local TeamInfo = self.TeamInfos[1]
  if not TeamInfo then
    self:ClearAllSlots()
    return
  end
  for SlotName, EName in pairs(self.ESlotName) do
    if "Null" ~= SlotName then
      local Uuid = TeamInfo[SlotName]
      if Uuid and self:CheckUnit(Uuid) then
        local SlotType = self.SlotName2Type[EName]
        local DataType = self.SlotType2DataType[SlotType]
        local Unit = Avatar[DataType .. "s"][Uuid]
        if not Unit then
          GWorld.logger.error("M:InitDetailPanels@该Uuid对应的物品已失效" .. CommonUtils.ObjId2Str(Uuid))
        end
        local UnitData = Unit and Unit:Data()
        local Content = {
          Type = DataType,
          Icon = UnitData and UnitData.Icon,
          Rarity = UnitData and (UnitData.Rarity or UnitData[DataType .. "Rarity"]),
          GachaIcon = UnitData and UnitData.GachaIcon,
          Uuid = Uuid
        }
        if "Weapon" == DataType then
          local Tags = {
            CommonConst.ArmoryTag.Melee,
            CommonConst.ArmoryTag.Ranged
          }
          for _, WeaponTag in pairs(Tags) do
            if Unit and Unit:HasTag(WeaponTag) then
              Content.Tag = WeaponTag
              self:CallFunctionByName(WeaponTag .. "Main_Init")
              break
            end
          end
        else
          self:CallFunctionByName(SlotType .. "Main_Init")
        end
        local SlotWidget = self.Slots[EName]
        if SlotWidget and SlotWidget.Update then
          SlotWidget:Update(Content)
        end
      end
    end
  end
end

function M:SlotSelectionChanged(SlotName, DungeonIndex, bToList)
  self:OnSlotClicked(SlotName)
end

function M:SaveLineup()
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
  self:Enter(DungeonId)
end

function M:SwitchOut()
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

AssembleComponents(M)
return M
