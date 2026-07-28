require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local DisplayConfig = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayConfig")
local DisplayDraft = require("BluePrints.UI.WBP.PersonInfo.Showcase.PersonInfo_DisplayDraft")
local M = {}
M.CharacterEditPanelBPPath = "WidgetBlueprint'/Game/UI/WBP/PersonalInfo/PC/WBP_PersonalInfo_EditModel_P.WBP_PersonalInfo_EditModel_P'"

function M:New(OwnerWidget)
  local Obj = {}
  self.__index = self
  setmetatable(Obj, self)
  Obj:Init(OwnerWidget)
  return Obj
end

function M:Init(OwnerWidget)
  self.OwnerWidget = OwnerWidget
  self.MainPageView = nil
  self.DisplayController = nil
  self.DisplayEditor = nil
  self.CharacterEditPanel = nil
  self.SelectedCharacterSlotIndex = 1
  self.ValidCharacterSlotIndices = {}
  self.ActiveTabName = "Char"
  self.IsSaving = false
end

function M:InitRoot(TabName)
  self.ActiveTabName = TabName or "Char"
  self:_BindRuntimeContext()
  self:_LoadInitialDraftFromMainPage()
  self:_InitSelectedCharacterSlotIndex()
  self:_CreateCharacterEditPanelIfNeeded()
  self:RefreshRootView()
end

function M:OnDestruct()
  self.CharacterEditPanel = nil
  self.DisplayEditor = nil
  self.DisplayController = nil
  self.MainPageView = nil
  self.OwnerWidget = nil
end

function M:RefreshRootView()
  if self.CharacterEditPanel and self.CharacterEditPanel.RefreshView then
    self.CharacterEditPanel:RefreshView()
  end
end

function M:SetSelectedCharacterSlotIndex(SlotIndex)
  if type(SlotIndex) ~= "number" or SlotIndex <= 0 then
    return
  end
  self.SelectedCharacterSlotIndex = SlotIndex
  if self.DisplayController and self.DisplayController.SetFocusCharacterSlot then
    self.DisplayController:SetFocusCharacterSlot(SlotIndex)
  end
  self:RefreshRootView()
end

function M:GetSelectedCharacterSlotIndex()
  return self.SelectedCharacterSlotIndex or 1
end

function M:GetDisplayEditor()
  return self.DisplayEditor
end

function M:UndoEdit()
  if not self.DisplayEditor or not self.DisplayEditor.Undo then
    return false
  end
  local bSuccess = self.DisplayEditor:Undo()
  if bSuccess then
    self:RefreshRootView()
  end
  return bSuccess
end

function M:RedoEdit()
  if not self.DisplayEditor or not self.DisplayEditor.Redo then
    return false
  end
  local bSuccess = self.DisplayEditor:Redo()
  if bSuccess then
    self:RefreshRootView()
  end
  return bSuccess
end

function M:SaveEditAndClose()
  if self.IsSaving or not self.DisplayEditor then
    return false
  end
  self.IsSaving = true
  local bStarted = PersonInfoModel:SaveCustomDisplayDraft(self.DisplayEditor, function(Ret)
    self.IsSaving = false
    if ErrorCode and ErrorCode.Check and ErrorCode:Check(Ret) then
      UIManager(self.OwnerWidget):ShowUITip("CommonToastMain", GText("UI_PersonInfo_Saved"))
      PersonInfoController:CloseEditView()
    end
  end)
  if not bStarted then
    self.IsSaving = false
  end
  return bStarted
end

function M:GetSelectedCharacterSlot()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  if not Draft or not Draft.CharacterSlots then
    return nil
  end
  return Draft.CharacterSlots[self:GetSelectedCharacterSlotIndex()]
end

function M:BuildSelectedCharacterViewData()
  local Slot = self:GetSelectedCharacterSlot()
  local SceneId = self:_GetCurrentSceneId()
  local Transform = self:_GetEffectiveCharacterTransform(self:GetSelectedCharacterSlotIndex(), Slot, SceneId)
  local Rotation = self:_GetTransformRotation(Transform)
  local Translation = self:_GetTransformTranslation(Transform)
  return {
    SlotIndex = self:GetSelectedCharacterSlotIndex(),
    CharData = Slot and Slot.CharData or nil,
    Translation = Translation,
    Rotation = Rotation,
    SceneId = SceneId
  }
end

function M:BuildCharacterSlotViewList()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
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
      IsSelected = SlotIndex == self:GetSelectedCharacterSlotIndex(),
      HasCharacter = DisplayDraft:IsValidCharacterData(CharData),
      CharData = CharData,
      Name = Name,
      LevelText = LevelText
    }
  end
  return SlotViewList
end

function M:BeginCharacterTransformPreview()
  if not self.DisplayEditor or not self.DisplayEditor.BeginPreviewTransaction then
    return false
  end
  local TransactionKey = "character_transform_" .. tostring(self:GetSelectedCharacterSlotIndex())
  return self.DisplayEditor:BeginPreviewTransaction(TransactionKey)
end

function M:CommitCharacterTransformPreview()
  if not self.DisplayEditor or not self.DisplayEditor.CommitPreviewTransaction then
    return false
  end
  local bCommitted = self.DisplayEditor:CommitPreviewTransaction()
  if bCommitted then
    self:RefreshRootView()
  end
  return bCommitted
end

function M:PreviewCharacterTransform(TransformData)
  if not self.DisplayEditor or not self.DisplayEditor.SetCharacterTransform then
    return false
  end
  local Transform = self:_BuildTransformFromEditData(self:GetSelectedCharacterSlotIndex(), TransformData)
  self.DisplayEditor:SetCharacterTransform(self:GetSelectedCharacterSlotIndex(), Transform)
  return true
end

function M:_BindRuntimeContext()
  self.MainPageView = self.OwnerWidget and self.OwnerWidget.Root and self.OwnerWidget.Root.PersonInfoMainPage or nil
  self.DisplayController = self.MainPageView and self.MainPageView.ActorController or nil
  self.DisplayEditor = self.DisplayController and self.DisplayController.GetEditor and self.DisplayController:GetEditor() or nil
end

function M:_LoadInitialDraftFromMainPage()
  if not self.MainPageView or not self.DisplayEditor then
    return
  end
  if self.MainPageView.BuildMultiCharacterPreviewDraft then
    local Draft, ValidIndices = self.MainPageView:BuildMultiCharacterPreviewDraft()
    if Draft then
      self.DisplayEditor:SetDraft(Draft)
      self.ValidCharacterSlotIndices = ValidIndices or {}
    end
  end
end

function M:_InitSelectedCharacterSlotIndex()
  local SelectedIndex = self.MainPageView and self.MainPageView.SelectCharIndex or nil
  if type(SelectedIndex) == "number" and SelectedIndex > 0 then
    self.SelectedCharacterSlotIndex = SelectedIndex
  elseif self.ValidCharacterSlotIndices[1] then
    self.SelectedCharacterSlotIndex = self.ValidCharacterSlotIndices[1]
  else
    self.SelectedCharacterSlotIndex = 1
  end
  if self.DisplayController and self.DisplayController.SetFocusCharacterSlot then
    self.DisplayController:SetFocusCharacterSlot(self.SelectedCharacterSlotIndex)
  end
end

function M:_CreateCharacterEditPanelIfNeeded()
  if self.CharacterEditPanel ~= nil then
    return
  end
  local Panel = UIManager(self.OwnerWidget):CreateWidget(M.CharacterEditPanelBPPath)
  if not Panel then
    return
  end
  self.CharacterEditPanel = Panel
  if self.OwnerWidget and self.OwnerWidget.Root and self.OwnerWidget.Root.Content then
    self.OwnerWidget.Root.Content:AddChildToOverlay(Panel)
  end
  if Panel.InitCharacterEditPanel then
    Panel:InitCharacterEditPanel(self)
  end
end

function M:_GetCurrentSceneId()
  local Draft = self.DisplayEditor and self.DisplayEditor.GetDraft and self.DisplayEditor:GetDraft() or nil
  return Draft and Draft.Scene and Draft.Scene.SceneId or PersonInfoModel:GetCustomDisplaySceneId()
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

function M:_BuildTransformFromEditData(SlotIndex, TransformData)
  local SceneId = self:_GetCurrentSceneId()
  local BaseTransform = DisplayConfig:GetDefaultCharacterTransform(SlotIndex, SceneId)
  local Scale = BaseTransform and BaseTransform.Scale3D or FVector(1, 1, 1)
  local Rotation = FRotator(TransformData.Pitch or 0, TransformData.Yaw or 0, TransformData.Roll or 0)
  local Translation = FVector(TransformData.X or 0, TransformData.Y or 0, TransformData.Z or 0)
  return FTransform(Rotation:ToQuat(), Translation, Scale)
end

return M
