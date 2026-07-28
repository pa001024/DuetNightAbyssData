local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local M = {}

function M:BuildChoosePageViewData()
  return {
    ChooseMode = self.ActiveChooseMode,
    SelectedCharacterSlotIndex = self:GetSelectedCharacterSlotIndex(),
    ActiveTabName = self.ActiveTabName,
    SelectedCharacterSlot = self:GetSelectedCharacterSlot()
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

function M:GetSelectedCharacterSlot()
  return self:_GetCharacterSlot(self:GetSelectedCharacterSlotIndex(), self:IsCharacterChoosePageActive())
end

function M:BuildSelectedCharacterViewData()
  return self:_BuildSelectedCharacterViewData(self:GetSelectedCharacterSlotIndex())
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
  end
  return TitleViewData
end

function M:_BuildMainTitleText(ViewState)
  local ActiveChooseMode = ViewState and ViewState.ActiveChooseMode or nil
  local ActiveSubPageName = ViewState and ViewState.ActiveSubPageName or "CharacterMain"
  local ActiveTabName = ViewState and ViewState.ActiveTabName or "Char"
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
  end
  if "Scene" == ActiveTabName then
    return GText("UI_PersonalPage_Scene")
  end
  return GText("UI_PersonalPage_Customize")
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
    SelectedCharacterSlotIndex = self:GetSelectedCharacterSlotIndex()
  }
end

function M:ShouldShowCharacterDetailPanel()
  return self:IsCharacterMainPageActive() and self.ActiveCharacterPanelState == "Detail" and self:HasSelectedCharacter()
end

function M:IsMobileCharacterEditToggleAvailable()
  if self:IsChoosePageActive() then
    return false
  end
  return self:ShouldShowCharacterDetailPanel()
end

function M:ShouldShowMobileCharacterEditPanel()
  return self:ShouldShowCharacterDetailPanel() and self:ShouldShowMobileLeftPanel()
end

function M:ShouldUseCharacterInfoSwitcher()
  return self.ActiveSubPageName == "Choose" and (self.ActiveChooseMode == "Weapon" or self.ActiveChooseMode == "Action")
end

function M:IsChooseConfirmMode()
  return self.ActiveSubPageName == "Choose" and self.ActiveChooseMode == "Character"
end

function M:CanConfirmCharacterChoosePage()
  if not self:IsChooseConfirmMode() then
    return false
  end
  for _, _ in pairs(self.StagedCharacterChooseSelections or {}) do
    return true
  end
  return false
end

function M:ShouldShowCharacterSlotArea()
  return self.ActiveTabName == "Char" and self.ActiveSubPageName ~= "Scene"
end

function M:_ShouldDefaultShowMobileLeftPanel()
  return self:IsMobileCharacterEditToggleAvailable()
end

return M
