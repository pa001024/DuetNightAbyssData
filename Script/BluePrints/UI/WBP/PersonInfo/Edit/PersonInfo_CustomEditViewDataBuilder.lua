local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local M = {}

function M:BuildChoosePageViewData()
  return {
    ChooseMode = self.ActiveChooseMode,
    SelectedCharacterSlotIndex = self:GetSelectedCharacterSlotIndex(),
    SelectedItemSlotIndex = self:GetSelectedItemSlotIndex(),
    ActiveTabName = self.ActiveTabName,
    SelectedCharacterSlot = self:GetSelectedCharacterSlot(),
    SelectedItemSlot = self:GetSelectedItemSlot()
  }
end

function M:BuildEditTitleViewData()
  return self:_BuildEditTitleViewData(self:_BuildPageViewState())
end

function M:BuildChoosePreviewTitleViewData(Content)
  return self:_BuildChoosePreviewTitleViewData(self:_BuildPageViewState(), Content)
end

function M:BuildSceneSlotViewList()
  local SceneViewList = {}
  local CurrentSceneId = self:_GetCurrentSceneId()
  local UsedSceneId = self:_GetUsedSceneId()
  local SceneConfigTable = DataMgr and DataMgr.CustomScene or nil
  local SceneReddotDetail = ReddotManager.GetLeafNodeCacheDetail("PersonalInfoScene") or {}
  if not SceneConfigTable then
    return SceneViewList
  end
  for SceneId, SceneConfig in pairs(SceneConfigTable) do
    local bIsUnlocked = PersonInfoModel:HasOwnedCustomDisplayScene(SceneId)
    SceneViewList[#SceneViewList + 1] = {
      SceneId = SceneId,
      Name = SceneConfig.Name and GText(SceneConfig.Name) or tostring(SceneId),
      Icon = SceneConfig.Icon or SceneConfig.Preview or SceneConfig.Bg or SceneConfig.Texture,
      IsSelected = SceneId == CurrentSceneId,
      IsUsed = SceneId == UsedSceneId,
      IsUnlocked = bIsUnlocked,
      IsLocked = not bIsUnlocked,
      IsNew = bIsUnlocked and true == SceneReddotDetail[SceneId]
    }
  end
  table.sort(SceneViewList, function(A, B)
    return (A.SceneId or 0) < (B.SceneId or 0)
  end)
  return SceneViewList
end

function M:BuildFilterViewList()
  local FilterViewList = {}
  local FilterConfigTable = DataMgr and DataMgr.CustomFilter or nil
  if not FilterConfigTable then
    return FilterViewList
  end
  local SelectedFilterId
  if self.GetWorkingFilterData then
    local FilterData = self:GetWorkingFilterData()
    if type(FilterData) == "table" then
      SelectedFilterId = FilterData.FilterId or FilterData.Id
    elseif nil ~= FilterData then
      SelectedFilterId = FilterData
    end
  else
    SelectedFilterId = self:_GetSelectedFilterId()
  end
  local Avatar = GWorld and GWorld:GetAvatar() or nil
  local Sex = Avatar and Avatar.Sex or 1
  local IconPathSuffix = 1 == Sex and "_F" or "_M"
  for FilterId, FilterConfig in pairs(FilterConfigTable) do
    if type(FilterConfig) == "table" then
      local ResolvedId = FilterConfig.FilterId or FilterId
      local PhotoRow = DisplayConfig:GetPhotoFilterRow(FilterConfig.PPEnumID)
      local NameKey = FilterConfig.Name
      if (not NameKey or "" == NameKey) and PhotoRow then
        NameKey = PhotoRow.TextmapID
      end
      local IconPath = PhotoRow and PhotoRow.IconPath or nil
      if IconPath and "" ~= IconPath then
        IconPath = IconPath .. IconPathSuffix
      else
        IconPath = nil
      end
      FilterViewList[#FilterViewList + 1] = {
        FilterId = ResolvedId,
        Name = NameKey and GText(tostring(NameKey)) or tostring(ResolvedId),
        Icon = IconPath,
        FilterPath = FilterConfig.FilterPath,
        IsSelected = ResolvedId == SelectedFilterId,
        ForbidIntensityAdjust = FilterConfig.ForbidIntensityAdjust == true
      }
    end
  end
  table.sort(FilterViewList, function(A, B)
    return (A.FilterId or 0) < (B.FilterId or 0)
  end)
  return FilterViewList
end

function M:BuildStickerViewList()
  local StickerViewList = {}
  local StickerConfigTable = DataMgr and DataMgr.CustomStick or nil
  if not StickerConfigTable then
    return StickerViewList
  end
  local SelectedStickerId = self:_GetSelectedStickerId()
  local IsOverseaEnv = UE.AHotUpdateGameMode.IsGlobalPak()
  for StickerId, StickerConfig in pairs(StickerConfigTable) do
    if type(StickerConfig) == "table" then
      local ResolvedId = tonumber(StickerConfig.StickerId or StickerId)
      local StickerIsOversea = StickerConfig.IsOversea == true
      if ResolvedId and StickerIsOversea == IsOverseaEnv and PersonInfoModel:IsValidOwnedCustomDisplaySticker(ResolvedId) then
        local NameKey = StickerConfig.Name
        StickerViewList[#StickerViewList + 1] = {
          StickerId = ResolvedId,
          Name = NameKey and GText(NameKey) or tostring(ResolvedId),
          Icon = StickerConfig.Icon,
          StickerPath = StickerConfig.StickerPath,
          IsSelected = ResolvedId == SelectedStickerId
        }
      end
    end
  end
  table.sort(StickerViewList, function(A, B)
    return (A.StickerId or 0) < (B.StickerId or 0)
  end)
  return StickerViewList
end

function M:_GetSelectedFilterId()
  local Draft = self.DisplayEditor and self.DisplayEditor:GetDraft() or nil
  local Other = Draft and Draft.Other or nil
  local Filter = Other and Other.Filter or nil
  if type(Filter) == "table" then
    return Filter.FilterId or Filter.Id
  end
  return Filter
end

function M:_GetSelectedStickerId()
  local Draft = self.DisplayEditor and self.DisplayEditor:GetDraft() or nil
  local Other = Draft and Draft.Other or nil
  local Sticker = Other and Other.Sticker or nil
  if type(Sticker) == "table" then
    return tonumber(Sticker.StickerId or Sticker.Id)
  end
  return tonumber(Sticker)
end

function M:GetSelectedCharacterSlot()
  return self:_GetCharacterSlot(self:GetSelectedCharacterSlotIndex(), self:IsCharacterChoosePageActive())
end

function M:_GetItemSlot(SlotIndex)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 or not self.DisplayEditor then
    return nil
  end
  local Draft = self.DisplayEditor:GetDraft()
  return Draft and DisplayDraft:GetItemSlot(Draft, SlotIndex) or nil
end

function M:GetSelectedItemSlot()
  return self:_GetItemSlot(self:GetSelectedItemSlotIndex())
end

function M:HasSelectedItem()
  return DisplayDraft:IsItemSlotOccupied(self:GetSelectedItemSlot())
end

function M:BuildSelectedItemViewData()
  local SlotIndex = self:GetSelectedItemSlotIndex()
  local Slot = self:_GetItemSlot(SlotIndex)
  local ItemData = Slot and Slot.ItemData or nil
  local Transform = Slot and Slot.Transform or DisplayConfig:GetDefaultItemTransform(SlotIndex, ItemData)
  local Rotation = Slot and Slot.TransformRotation or self:_GetTransformRotation(Transform)
  local Translation = self:_GetTransformTranslation(Transform)
  return {
    SlotIndex = SlotIndex,
    ItemData = ItemData,
    Name = ItemData and ItemData.Name and GText(ItemData.Name) or "",
    Icon = ItemData and (ItemData.Icon or ItemData.IconPath) or nil,
    Rarity = ItemData and tonumber(ItemData.Rarity) or 0,
    Translation = {
      X = Translation.X or 0,
      Y = Translation.Y or 0,
      Z = Translation.Z or 0
    },
    Rotation = Rotation or {},
    TransformRange = DisplayConfig:GetItemTransformEditRange(SlotIndex, self:_GetCurrentSceneId(), Translation)
  }
end

function M:BuildItemSlotViewList()
  local bIsItemChoosePage = self:IsChoosePageActive() and self.ActiveChooseMode == "Item"
  local SelectedSlotIndex = self:GetSelectedItemSlotIndex()
  local SlotViewList = {}
  local Draft = self.DisplayEditor and self.DisplayEditor:GetDraft() or nil
  for SlotIndex = 1, DisplayConfig:GetItemSlotCount() do
    local Slot = Draft and DisplayDraft:GetItemSlot(Draft, SlotIndex) or nil
    local ItemData = Slot and Slot.ItemData or nil
    local bHasItem = DisplayDraft:IsItemSlotOccupied(Slot)
    SlotViewList[SlotIndex] = {
      SlotIndex = SlotIndex,
      SlotKind = "Item",
      IsSelected = SlotIndex == SelectedSlotIndex,
      HasCharacter = false,
      HasItem = bHasItem,
      ItemData = ItemData,
      Name = ItemData and ItemData.Name and GText(ItemData.Name) or "",
      LevelText = "",
      Icon = ItemData and (ItemData.Icon or ItemData.IconPath) or nil,
      Rarity = ItemData and tonumber(ItemData.Rarity) or 0,
      CanInteract = bHasItem or bIsItemChoosePage,
      ShowAddIcon = not bHasItem and bIsItemChoosePage,
      ShowLockIcon = false,
      UseChoosePageStyle = bIsItemChoosePage
    }
  end
  return SlotViewList
end

function M:BuildItemSlotViewData(SlotIndex)
  return self:BuildItemSlotViewList()[SlotIndex]
end

function M:BuildSelectedCharacterViewData()
  return self:_BuildSelectedCharacterViewData(self:GetSelectedCharacterSlotIndex())
end

function M:BuildSelectedPetViewData()
  return self:_BuildSelectedPetViewData(self:GetSelectedPetSlotIndex())
end

function M:BuildCharacterSlotViewList()
  return self:_BuildCharacterSlotViewList(self:GetSelectedCharacterSlotIndex(), self:IsCharacterChoosePageActive())
end

function M:BuildCharacterSlotViewData(SlotIndex)
  local SlotViewList = self:_BuildCharacterSlotViewList(self:GetSelectedCharacterSlotIndex(), self:IsCharacterChoosePageActive())
  return SlotViewList and SlotViewList[SlotIndex] or nil
end

function M:HasSelectedCharacter()
  local Slot = self:GetSelectedCharacterSlot()
  return DisplayDraft:IsCharacterSlotOccupied(Slot)
end

function M:BuildPetSlotViewList()
  return self:_BuildPetSlotViewList(self:GetSelectedPetSlotIndex())
end

function M:BuildPetSlotViewData(SlotIndex)
  local SlotViewList = self:_BuildPetSlotViewList(self:GetSelectedPetSlotIndex())
  return SlotViewList and SlotViewList[SlotIndex] or nil
end

function M:GetSelectedPetSlot()
  return self:_GetPetSlot(self:GetSelectedPetSlotIndex())
end

function M:HasSelectedPet()
  local Slot = self:GetSelectedPetSlot()
  return DisplayDraft:IsPetSlotOccupied(Slot)
end

function M:_BuildPetSlotViewList(SelectedSlotIndex)
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  local SlotCount = DisplayConfig:GetPetSlotCount()
  local SlotViewList = {}
  local bIsPetChoosePage = self.IsPetChoosePageActive and self:IsPetChoosePageActive() == true
  for SlotIndex = 1, SlotCount do
    local Slot = Draft and Draft.PetSlots and Draft.PetSlots[SlotIndex] or nil
    local PetData = Slot and Slot.PetData or nil
    local bOccupied = DisplayDraft:IsPetSlotOccupied(Slot)
    local Name = ""
    local LevelText = ""
    local Icon, Rarity
    if bOccupied and PetData then
      local PetId = PetData.PetId
      local PetCfg = PetId and DataMgr.Pet and DataMgr.Pet[PetId] or nil
      Name = PetCfg and PetCfg.Name and GText(PetCfg.Name) or ""
      local Level = PetData.Level or PetData.BattlePetLevel
      LevelText = Level and "Lv." .. tostring(Level) or ""
      Icon = PetCfg and PetCfg.Icon or nil
      Rarity = PetCfg and PetCfg.Rarity or nil
    end
    SlotViewList[SlotIndex] = {
      SlotIndex = SlotIndex,
      SlotKind = "Pet",
      IsSelected = SlotIndex == SelectedSlotIndex,
      HasCharacter = bOccupied,
      PetData = PetData,
      Name = Name,
      LevelText = LevelText,
      Icon = Icon,
      Rarity = Rarity,
      CanInteract = bOccupied or bIsPetChoosePage,
      ShowAddIcon = not bOccupied and bIsPetChoosePage,
      ShowLockIcon = false,
      UseChoosePageStyle = bIsPetChoosePage
    }
  end
  return SlotViewList
end

function M:_GetPetSlot(SlotIndex)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return nil
  end
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  if not Draft then
    return nil
  end
  return DisplayDraft:GetPetSlot(Draft, SlotIndex)
end

function M:GetSelectedCharacterWeaponData()
  local Slot = self:GetSelectedCharacterSlot()
  return Slot and Slot.WeaponData or nil
end

function M:GetSelectedCharacterActionData()
  local Slot = self:GetSelectedCharacterSlot()
  return Slot and Slot.Action or nil
end

function M:_BuildSelectedCharacterViewData(SlotIndex)
  local Slot = self:_GetCharacterSlot(SlotIndex)
  local SceneId = self:_GetCurrentSceneId()
  local Transform = self:_GetEffectiveCharacterTransform(SlotIndex, Slot, SceneId)
  local Rotation = Slot and Slot.TransformRotation or self:_GetTransformRotation(Transform)
  local Translation = self:_GetTransformTranslation(Transform)
  local TranslationData = {
    X = Translation.X or 0,
    Y = Translation.Y or 0,
    Z = Translation.Z or 0
  }
  local DefaultTranslation = DisplayConfig:GetCharacterDefaultTranslation(SlotIndex)
  local TransformRange = DisplayConfig:GetCharacterTransformEditRange(SlotIndex, SceneId, TranslationData)
  return {
    SlotIndex = SlotIndex,
    CharData = Slot and Slot.CharData or nil,
    Translation = TranslationData,
    DefaultTranslation = DefaultTranslation,
    TransformRange = TransformRange,
    Rotation = Rotation,
    SceneId = SceneId
  }
end

function M:_BuildSelectedPetViewData(SlotIndex)
  local Slot = self:_GetPetSlot(SlotIndex)
  local SceneId = self:_GetCurrentSceneId()
  local Transform = self:_GetEffectivePetTransform(SlotIndex, Slot)
  local Rotation = Slot and Slot.TransformRotation or self:_GetTransformRotation(Transform)
  local Translation = self:_GetTransformTranslation(Transform)
  local TranslationData = {
    X = Translation.X or 0,
    Y = Translation.Y or 0,
    Z = Translation.Z or 0
  }
  local DefaultTranslation = DisplayConfig:GetPetDefaultTranslation(SlotIndex)
  local TransformRange = DisplayConfig:GetPetTransformEditRange(SlotIndex, SceneId, TranslationData)
  local PetData = Slot and Slot.PetData or nil
  local PetId = PetData and PetData.PetId or nil
  local PetCfg = PetId and DataMgr.Pet and DataMgr.Pet[PetId] or nil
  local Name = ""
  if PetData and PetData.Name and "" ~= PetData.Name then
    Name = PetData.Name
  elseif PetCfg and PetCfg.Name then
    Name = GText(PetCfg.Name)
  end
  return {
    SlotIndex = SlotIndex,
    PetData = PetData,
    PetCfg = PetCfg,
    Name = Name,
    Translation = TranslationData,
    DefaultTranslation = DefaultTranslation,
    TransformRange = TransformRange,
    Rotation = Rotation,
    SceneId = SceneId
  }
end

function M:_GetEffectivePetTransform(SlotIndex, Slot)
  if Slot and Slot.Transform then
    return Slot.Transform
  end
  return DisplayConfig:GetDefaultPetTransform(SlotIndex)
end

function M:_BuildCharacterSlotViewList(SelectedSlotIndex, bIsCharacterChoosePage)
  local Draft = self.DisplayEditor:GetDraft()
  if bIsCharacterChoosePage and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  local SlotViewList = {}
  for SlotIndex = 1, 4 do
    local Slot = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
    local CharData = Slot and Slot.CharData or nil
    local Name = ""
    local LevelText = ""
    if CharData then
      local CharCfg = DataMgr.Char and DataMgr.Char[CharData.CharId] or nil
      Name = CharCfg and GText(CharCfg.CharName) or ""
      LevelText = CharData.Level and "Lv." .. tostring(CharData.Level) or ""
    end
    SlotViewList[SlotIndex] = {
      SlotIndex = SlotIndex,
      SlotKind = "Char",
      IsSelected = SlotIndex == SelectedSlotIndex,
      HasCharacter = DisplayDraft:IsValidCharacterData(CharData),
      CharData = CharData,
      Name = Name,
      LevelText = LevelText,
      Icon = CharData and DataMgr.Char and DataMgr.Char[CharData.CharId] and DataMgr.Char[CharData.CharId].Icon or nil,
      CanInteract = DisplayDraft:IsValidCharacterData(CharData) or bIsCharacterChoosePage,
      ShowAddIcon = not DisplayDraft:IsValidCharacterData(CharData) and bIsCharacterChoosePage,
      ShowLockIcon = false,
      UseChoosePageStyle = bIsCharacterChoosePage
    }
  end
  return SlotViewList
end

function M:_HasAnyOccupiedCharacterSlot()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  if self:IsCharacterChoosePageActive() and self.CharacterChooseBaseDraft ~= nil then
    Draft = self:_BuildCharacterChooseSlotDraft()
  end
  for SlotIndex = 1, 4 do
    local Slot = Draft and Draft.CharacterSlots and Draft.CharacterSlots[SlotIndex] or nil
    if DisplayDraft:IsCharacterSlotOccupied(Slot) then
      return true
    end
  end
  return false
end

function M:_BuildEditTitleViewData(ViewState)
  if ViewState and ViewState.ActiveTabName == "Item" then
    local ItemViewData = self:BuildSelectedItemViewData()
    return self:_BuildItemTitleViewData(ItemViewData.ItemData, ItemViewData.Name, ItemViewData.Rarity)
  end
  local SlotIndex = ViewState and ViewState.SelectedCharacterSlotIndex or nil
  local ActiveChooseMode = ViewState and ViewState.ActiveChooseMode or nil
  local Slot = self:_GetCharacterSlot(SlotIndex)
  local CharData = Slot and Slot.CharData or nil
  local WeaponData = Slot and Slot.WeaponData or nil
  local ActionData = Slot and Slot.Action or nil
  local CharName = self:_GetCharacterDisplayName(CharData)
  local WeaponName = self:_GetWeaponDisplayName(WeaponData)
  local ActionName = self:_GetActionDisplayName(ActionData)
  local ActionTypeText = self:_GetActionTypeDisplayText(ActionData)
  local WarningText = self:_BuildActionWarningText(ActionData, WeaponData)
  local CharTitleData = self:_BuildCharacterTitleData(CharData)
  local TitleText = self:_BuildMainTitleText(ViewState)
  local ShowActionPanel = "Weapon" == ActiveChooseMode or "Action" == ActiveChooseMode
  local InfoNameText = "Weapon" == ActiveChooseMode and WeaponName or ActionName
  local ShowWarning = "" ~= WarningText
  return {
    MainTitle = TitleText,
    CharName = CharName,
    WeaponName = WeaponName,
    ActionName = ActionName,
    ActionTypeText = ActionTypeText,
    DescText = self:_BuildTitleDescText(ViewState),
    WarningText = WarningText,
    ShowCharPanel = "" ~= CharName,
    ShowActionPanel = ShowActionPanel,
    ShowWarning = ShowWarning,
    ActionInfoText = InfoNameText,
    InfoNameText = InfoNameText,
    InfoTypeText = ActionTypeText,
    InfoDescText = ShowWarning and WarningText or ActionTypeText,
    AttributeIcon = CharTitleData.AttributeIcon,
    Rarity = CharTitleData.Rarity,
    ShowElement = CharTitleData.AttributeIcon ~= nil,
    ShowQuality = "Action" == ActiveChooseMode and self:_CanShowActionQuality(ActionData),
    ActionSwitcherIndex = "Action" == ActiveChooseMode and ActionTypeText == GText("UI_PersonalPage_DynamicAction") and 1 or 0
  }
end

function M:_BuildChoosePreviewTitleViewData(ViewState, Content)
  local ActiveChooseMode = ViewState and ViewState.ActiveChooseMode or nil
  local SlotIndex = ViewState and ViewState.SelectedCharacterSlotIndex or nil
  local TitleViewData = self:_BuildEditTitleViewData(ViewState)
  if "Item" == ActiveChooseMode then
    if not Content then
      return TitleViewData
    end
    local ItemData = Content.ItemData
    local ItemName = Content.UnitName or ItemData and ItemData.Name and GText(ItemData.Name) or tostring(Content.ItemId or "")
    return self:_BuildItemTitleViewData(ItemData, ItemName, Content.Rarity)
  end
  if "Weapon" == ActiveChooseMode then
    local CurrentSlot = self:_GetCharacterSlot(SlotIndex)
    local CurrentActionData = CurrentSlot and CurrentSlot.Action or nil
    local WarningText = self:_BuildActionWarningText(CurrentActionData, CurrentSlot and CurrentSlot.WeaponData or nil)
    local bShowWarning = "" ~= WarningText
    local CurrentWeaponData = CurrentSlot and CurrentSlot.WeaponData or nil
    local WeaponName = self:_GetWeaponDisplayName(CurrentWeaponData)
    TitleViewData.MainTitle = WeaponName
    TitleViewData.ActionInfoText = WeaponName
    TitleViewData.InfoNameText = WeaponName
    TitleViewData.InfoTypeText = ""
    TitleViewData.InfoDescText = WarningText
    TitleViewData.ActionTypeText = ""
    TitleViewData.WarningText = WarningText
    TitleViewData.ShowWarning = bShowWarning
    TitleViewData.DescText = bShowWarning and WarningText or TitleViewData.DescText
    TitleViewData.ShowActionPanel = false
    TitleViewData.ShowQuality = false
    TitleViewData.ActionSwitcherIndex = 0
    return TitleViewData
  end
  if "Action" == ActiveChooseMode and not Content then
    local CurrentSlot = self:_GetCharacterSlot(SlotIndex)
    local CurrentActionData = CurrentSlot and CurrentSlot.Action or nil
    local ActionName = self:_GetActionDisplayName(CurrentActionData)
    local ActionTypeText = self:_GetActionTypeDisplayText(CurrentActionData)
    local WarningText = self:_BuildActionWarningText(CurrentActionData, CurrentSlot and CurrentSlot.WeaponData or nil)
    local bShowWarning = "" ~= WarningText
    TitleViewData.MainTitle = ActionName
    TitleViewData.ActionInfoText = ActionName
    TitleViewData.ActionTypeText = ActionTypeText
    TitleViewData.WarningText = WarningText
    TitleViewData.ShowWarning = bShowWarning
    TitleViewData.DescText = bShowWarning and WarningText or TitleViewData.DescText
    TitleViewData.InfoNameText = ActionName
    TitleViewData.InfoTypeText = ActionTypeText
    TitleViewData.InfoDescText = bShowWarning and WarningText or ActionTypeText
    TitleViewData.ShowActionPanel = "" ~= ActionTypeText
    TitleViewData.ShowQuality = self:_CanShowActionQuality(CurrentActionData)
    TitleViewData.ActionSwitcherIndex = ActionTypeText == GText("UI_PersonalPage_DynamicAction") and 1 or 0
    return TitleViewData
  end
  if not Content then
    return TitleViewData
  end
  if "Action" == ActiveChooseMode then
    local ActionName = self:_GetChooseContentDisplayName(Content, GText("UI_PersonalPage_DefaultAction"))
    local ActionTypeText = self:_GetChooseActionTypeText(Content)
    local WarningText = self:_BuildChooseActionWarningText(Content, self:GetSelectedCharacterWeaponData())
    local bShowWarning = "" ~= WarningText
    TitleViewData.MainTitle = ActionName
    TitleViewData.ActionInfoText = ActionName
    TitleViewData.ActionTypeText = ActionTypeText
    TitleViewData.WarningText = WarningText
    TitleViewData.ShowWarning = bShowWarning
    TitleViewData.DescText = bShowWarning and WarningText or TitleViewData.DescText
    TitleViewData.InfoNameText = ActionName
    TitleViewData.InfoTypeText = ActionTypeText
    TitleViewData.InfoDescText = bShowWarning and WarningText or ActionTypeText
    TitleViewData.ShowActionPanel = "" ~= ActionTypeText
    TitleViewData.ActionSwitcherIndex = ActionTypeText == GText("UI_PersonalPage_DynamicAction") and 1 or 0
  elseif "Pet" == ActiveChooseMode then
    local PetName = Content.UnitName or self:_GetChooseContentDisplayName(Content, "")
    TitleViewData.MainTitle = PetName
    TitleViewData.CharName = PetName
    TitleViewData.InfoNameText = PetName
    TitleViewData.InfoTypeText = ""
    TitleViewData.InfoDescText = ""
    TitleViewData.DescText = ""
    TitleViewData.ShowCharPanel = "" ~= PetName
    TitleViewData.ShowActionPanel = false
    TitleViewData.ShowWarning = false
    TitleViewData.ShowQuality = false
    TitleViewData.ActionSwitcherIndex = 0
    TitleViewData.Rarity = Content.Rarity
  end
  return TitleViewData
end

function M:_BuildMainTitleText(ViewState)
  local ActiveChooseMode = ViewState and ViewState.ActiveChooseMode or nil
  local ActiveSubPageName = ViewState and ViewState.ActiveSubPageName or "CharacterMain"
  local ActiveTabName = ViewState and ViewState.ActiveTabName or "Char"
  if "StickerEdit" == ActiveSubPageName then
    return GText("UI_PersonalPage_AdjustSticker")
  end
  if "Choose" == ActiveSubPageName then
    if "Character" == ActiveChooseMode then
      return GText("UI_PersonalPage_SelectChar")
    end
    if "Weapon" == ActiveChooseMode then
      return GText("UI_PersonalPage_SetWeapon")
    end
    if "Action" == ActiveChooseMode then
      return GText("UI_PersonalPage_SetAction")
    end
    if "Pet" == ActiveChooseMode then
      return GText("UI_PersonalPage_AddGeniemon")
    end
    if "Item" == ActiveChooseMode then
      return GText("UI_PersonInfo_CustomItem")
    end
  end
  if "Scene" == ActiveTabName then
    return GText("UI_PersonalPage_Scene")
  end
  if "Other" == ActiveTabName then
    return GText("UI_PersonalPage_Others")
  end
  if "Item" == ActiveTabName then
    return GText("UI_PersonInfo_CustomItem")
  end
  return GText("UI_PersonalPage_Customize")
end

function M:_BuildItemTitleViewData(ItemData, ItemName, Rarity)
  local ResolvedName = ItemName or ""
  local ResolvedRarity = tonumber(Rarity or ItemData and ItemData.Rarity) or 0
  return {
    MainTitle = "" ~= ResolvedName and ResolvedName or GText("UI_PersonInfo_CustomItem"),
    CharName = ResolvedName,
    DescText = "",
    WarningText = "",
    ShowCharPanel = "" ~= ResolvedName,
    ShowActionPanel = false,
    ShowWarning = false,
    ShowElement = false,
    ShowQuality = ResolvedRarity > 0,
    Rarity = ResolvedRarity,
    ActionSwitcherIndex = 0
  }
end

function M:_BuildTitleDescText(ViewState)
  local ActiveChooseMode = ViewState and ViewState.ActiveChooseMode or nil
  local SlotIndex = ViewState and ViewState.SelectedCharacterSlotIndex or nil
  if "Weapon" == ActiveChooseMode then
    local Slot = self:_GetCharacterSlot(SlotIndex)
    return self:_GetWeaponDisplayName(Slot and Slot.WeaponData or nil)
  end
  if "Action" == ActiveChooseMode then
    local Slot = self:_GetCharacterSlot(SlotIndex)
    return self:_GetActionDisplayName(Slot and Slot.Action or nil)
  end
  return ""
end

function M:_GetCharacterDisplayName(CharData)
  local CharId = CharData and CharData.CharId or nil
  local CharConfig = CharId and DataMgr.Char and DataMgr.Char[CharId] or nil
  local CharNameKey = CharConfig and CharConfig.CharName or nil
  return CharNameKey and GText(CharNameKey) or ""
end

function M:_GetWeaponDisplayName(WeaponData)
  local WeaponId = WeaponData and WeaponData.WeaponId or nil
  if not WeaponId then
    return GText("UI_PersonalPage_NoWeapon")
  end
  local WeaponConfig = DataMgr.Weapon and DataMgr.Weapon[WeaponId] or nil
  local WeaponNameKey = WeaponConfig and WeaponConfig.WeaponName or nil
  return WeaponNameKey and GText(WeaponNameKey) or tostring(WeaponId)
end

function M:_GetActionDisplayName(ActionData)
  local PoseId = ActionData and ActionData.PoseId or nil
  if not PoseId then
    return GText("UI_PersonalPage_DefaultAction")
  end
  local Resource = self:_FindActionResource(ActionData)
  if Resource and Resource.ResourceName then
    return GText(Resource.ResourceName)
  end
  local GestureConfig = DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if GestureConfig and GestureConfig.Name and GestureConfig.Name ~= "" then
    return GText(GestureConfig.Name)
  end
  if GestureConfig and GestureConfig.GestureTag == "Gesture" then
    return string.format("%s#%d", GText("UI_PersonalPage_DynamicAction"), PoseId)
  end
  return string.format("%s#%d", GText("UI_PersonalPage_StaticAction"), PoseId)
end

function M:_GetActionTypeDisplayText(ActionData)
  local PoseId = ActionData and ActionData.PoseId or nil
  if not PoseId then
    return ""
  end
  local GestureConfig = DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return ""
  end
  if GestureConfig.GestureTag == "Gesture" then
    return GText("UI_PersonalPage_DynamicAction")
  end
  if GestureConfig.GestureTag == "Pose" then
    return GText("UI_PersonalPage_StaticAction")
  end
  return ""
end

function M:_BuildActionWarningText(ActionData, WeaponData)
  if not ActionData or ActionData.PoseId == nil then
    return ""
  end
  return GText("UI_PersonalPage_ActionNoWeapon")
end

function M:_IsCurrentActionUnableToShowWeapon()
  local SlotIndex = self.GetSelectedCharacterSlotIndex and self:GetSelectedCharacterSlotIndex() or nil
  local Slot = self._GetCharacterSlot and self:_GetCharacterSlot(SlotIndex) or nil
  local WarningText = self:_BuildActionWarningText(Slot and Slot.Action, Slot and Slot.WeaponData)
  return nil ~= WarningText and "" ~= WarningText
end

function M:_GetChooseContentDisplayName(Content, EmptyFallback)
  if not Content then
    return EmptyFallback or ""
  end
  local UnitName = Content.UnitName or Content.ItemName or Content.Name
  if UnitName and "" ~= UnitName then
    return UnitName
  end
  local WeaponId = Content.WeaponId or Content.UnitId
  local WeaponConfig = WeaponId and DataMgr.Weapon and DataMgr.Weapon[WeaponId] or nil
  if WeaponConfig and WeaponConfig.WeaponName then
    return GText(WeaponConfig.WeaponName)
  end
  return EmptyFallback or ""
end

function M:_GetChooseActionTypeText(Content)
  if not Content then
    return ""
  end
  if Content.IsDefaultAction == true then
    return ""
  end
  if Content.ActionCategory == "Display" or Content.ActionCategory == "Dynamic" or Content.Tag == "Gesture" then
    return GText("UI_PersonalPage_DynamicAction")
  end
  if Content.ActionCategory == "Static" or Content.Tag == "Pose" then
    return GText("UI_PersonalPage_StaticAction")
  end
  local PoseId = Content.PoseId or nil
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  if not GestureConfig then
    return ""
  end
  if "Gesture" == GestureConfig.GestureTag then
    return GText("UI_PersonalPage_DynamicAction")
  end
  if "Pose" == GestureConfig.GestureTag then
    return GText("UI_PersonalPage_StaticAction")
  end
  return ""
end

function M:_BuildChooseActionWarningText(Content, WeaponData)
  if not Content or Content.IsDefaultAction == true then
    return ""
  end
  return GText("UI_PersonalPage_ActionNoWeapon")
end

function M:_GetEffectiveCharacterTransform(SlotIndex, Slot, SceneId)
  if Slot and Slot.Transform then
    return Slot.Transform
  end
  return DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
end

function M:_GetTransformTranslation(Transform)
  return Transform and Transform.Translation or FVector(0, 0, 0)
end

function M:_GetTransformRotation(Transform)
  if Transform and Transform.Rotation and Transform.Rotation.ToRotator then
    return Transform.Rotation:ToRotator()
  end
  return FRotator(0, 0, 0)
end

function M:_BuildCharacterTitleData(CharData)
  if not CharData then
    return {AttributeIcon = nil, Rarity = nil}
  end
  local CharConfig = DataMgr.Char and DataMgr.Char[CharData.CharId] or nil
  local BattleCharConfig = DataMgr.BattleChar and DataMgr.BattleChar[CharData.CharId] or nil
  local Attribute = BattleCharConfig and BattleCharConfig.Attribute or nil
  local AttributeIcon
  if Attribute then
    local IconPath = string.format("/Game/UI/Texture/Dynamic/Atlas/Armory/T_Armory_%s.T_Armory_%s", Attribute, Attribute)
    AttributeIcon = LoadObject(IconPath)
  end
  return {
    AttributeIcon = AttributeIcon,
    Rarity = CharConfig and CharConfig.CharRarity or nil
  }
end

function M:_CanShowActionQuality(ActionData)
  local Resource = self:_FindActionResource(ActionData)
  return nil ~= Resource and nil ~= Resource.Rarity and Resource.Rarity > 0
end

function M:_FindActionResource(ActionData)
  local PoseId = ActionData and ActionData.PoseId or nil
  local GestureConfig = PoseId and DataMgr.CustomGesture and DataMgr.CustomGesture[PoseId] or nil
  local ResourceId = GestureConfig and GestureConfig.ReleaseWheel or nil
  if not ResourceId then
    return nil
  end
  return DataMgr.Resource and DataMgr.Resource[ResourceId] or nil
end

function M:_BuildPageViewState()
  return {
    ActiveTabName = self.ActiveTabName,
    ActiveSubPageName = self.ActiveSubPageName,
    ActiveChooseMode = self.ActiveChooseMode,
    ActiveCharacterPanelState = self.ActiveCharacterPanelState,
    SelectedCharacterSlotIndex = self:GetSelectedCharacterSlotIndex(),
    SelectedItemSlotIndex = self:GetSelectedItemSlotIndex()
  }
end

function M:ShouldShowCharacterDetailPanel()
  return self:IsCharacterMainPageActive() and self.ActiveCharacterPanelState == "Detail" and self:HasSelectedCharacter()
end

function M:ShouldShowPetDetailPanel()
  return self:IsPetMainPageActive() and self.ActivePetPanelState == "Detail" and self:HasSelectedPet()
end

function M:ShouldShowItemDetailPanel()
  return self:IsItemMainPageActive() and self:HasSelectedItem()
end

function M:ShouldShowEditDetailPanel()
  return self:ShouldShowCharacterDetailPanel() or self:ShouldShowPetDetailPanel() or self:ShouldShowItemDetailPanel()
end

function M:IsMobileCharacterEditToggleAvailable()
  if self:IsChoosePageActive() then
    return false
  end
  return self:ShouldShowCharacterDetailPanel() or self:ShouldShowPetDetailPanel() or self:ShouldShowItemDetailPanel()
end

function M:ShouldShowMobileCharacterEditPanel()
  return (self:ShouldShowCharacterDetailPanel() or self:ShouldShowPetDetailPanel() or self:ShouldShowItemDetailPanel()) and self:ShouldShowMobileLeftPanel()
end

function M:ShouldUseCharacterInfoSwitcher()
  return self.ActiveSubPageName == "Choose" and (self.ActiveChooseMode == "Weapon" or self.ActiveChooseMode == "Action")
end

function M:IsChooseConfirmMode()
  return self.ActiveSubPageName == "Choose" and (self.ActiveChooseMode == "Character" or self.ActiveChooseMode == "Pet" or self.ActiveChooseMode == "Item" or self.ActiveChooseMode == "Weapon" or self.ActiveChooseMode == "Action")
end

function M:CanConfirmChoosePage()
  if self.ActiveChooseMode == "Character" then
    return self:CanConfirmCharacterChoosePage()
  end
  if self.ActiveChooseMode == "Pet" then
    return self:CanConfirmPetChoosePage()
  end
  if self.ActiveChooseMode == "Item" then
    return self:CanConfirmItemChoosePage()
  end
  if self.ActiveChooseMode == "Weapon" then
    return self:CanConfirmWeaponChoosePage()
  end
  if self.ActiveChooseMode == "Action" then
    return self:CanConfirmActionChoosePage()
  end
  return false
end

function M:CanConfirmItemChoosePage()
  return self:_CanConfirmUniqueSlotChoosePage("Item", self.ItemChooseBaseDraft, "ItemSlots")
end

function M:CanConfirmCharacterChoosePage()
  if self.ActiveSubPageName ~= "Choose" or self.ActiveChooseMode ~= "Character" then
    return false
  end
  for _, _ in pairs(self.StagedCharacterChooseSelections or {}) do
    return true
  end
  return false
end

function M:CanConfirmPetChoosePage()
  return self:_CanConfirmUniqueSlotChoosePage("Pet", self.PetChooseBaseDraft, "PetSlots")
end

function M:CanConfirmWeaponChoosePage()
  if self:_IsCurrentActionUnableToShowWeapon() then
    return false
  end
  return self:_CanConfirmCharacterEquipChoosePage("Weapon", self.WeaponChooseBaseDraft)
end

function M:CanConfirmActionChoosePage()
  return self:_CanConfirmCharacterEquipChoosePage("Action", self.ActionChooseBaseDraft)
end

function M:_CanConfirmCharacterEquipChoosePage(Mode, BaseDraft)
  if self.ActiveSubPageName ~= "Choose" or self.ActiveChooseMode ~= Mode then
    return false
  end
  if not BaseDraft or not self.DisplayEditor then
    return false
  end
  local CurrentDraft = self.DisplayEditor:GetDraft()
  return not DisplayDraft:IsEquivalent(BaseDraft.CharacterSlots, CurrentDraft and CurrentDraft.CharacterSlots or nil)
end

function M:_CanConfirmUniqueSlotChoosePage(Mode, BaseDraft, SlotsField)
  if self.ActiveSubPageName ~= "Choose" or self.ActiveChooseMode ~= Mode then
    return false
  end
  if not BaseDraft or not self.DisplayEditor then
    return false
  end
  local CurrentDraft = self.DisplayEditor:GetDraft()
  return not DisplayDraft:IsEquivalent(BaseDraft[SlotsField], CurrentDraft and CurrentDraft[SlotsField] or nil)
end

function M:ShouldShowCharacterSlotArea()
  if self.ActiveSubPageName == "Scene" or self.ActiveSubPageName == "Other" or self.ActiveSubPageName == "StickerEdit" then
    return false
  end
  return self.ActiveTabName == "Char" or self.ActiveTabName == "Pet"
end

function M:ShouldShowItemSlotArea()
  return self:IsItemMainPageActive() or self:IsChoosePageActive() and self.ActiveChooseMode == "Item"
end

function M:ShouldShowSlotArea()
  return self:ShouldShowCharacterSlotArea() or self:ShouldShowItemSlotArea()
end

function M:GetExpectedSlotKind()
  if not self:ShouldShowSlotArea() then
    return nil
  end
  if self:ShouldShowItemSlotArea() then
    return "Item"
  end
  if self:IsPetPageActive() then
    return "Pet"
  end
  return "Char"
end

function M:_ShouldDefaultShowMobileLeftPanel()
  return self:IsMobileCharacterEditToggleAvailable()
end

return M
