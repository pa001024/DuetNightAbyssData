require("UnLua")
local TeamHallCommon = require("BluePrints.UI.WBP.TeamHall.TeamHallCommon")
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local TeamHallRecruitModel = require("BluePrints.UI.WBP.TeamHall.TeamHallRecruitModel")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")
M._components = {
  "BluePrints.UI.WBP.Team.View.WBP_Team_Recruit_GamePadCompoment"
}
local SignItemAssetPath = "/Game/UI/WBP/Team/Widget/Recruit/WBP_Team_Recruit_SignItem.WBP_Team_Recruit_SignItem"

local function GetTagMaxCount()
  local Config = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.TeamHallTagMaxNum
  return Config and tonumber(Config.ConstantValue) or TeamHallRecruitModel.MaxTagSlotCount
end

local function GetVisibleType(Name)
  return CommonConst and CommonConst.TeamHallVisibleType and CommonConst.TeamHallVisibleType[Name]
end

local function GetTagKey(Tag)
  if type(Tag) ~= "table" then
    return nil
  end
  if Tag.Kind == "Preset" then
    return "P:" .. tostring(Tag.Value)
  end
  if Tag.Kind == "Custom" then
    return "C:" .. tostring(Tag.Value)
  end
  return nil
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.Draft = TeamHallRecruitModel.LoadDraft()
  self.bEditingCustomTags = false
  self.bRequestingPublish = false
  self.bCustomTagDialogOpenPending = false
  self.DataVersion = (self.DataVersion or 0) + 1
  self.WrapList:ClearChildren()
  self:InitRecruitGamepadState()
  if self.Owner then
    self.Owner.DontCloseWhenRightBtnClicked = true
  end
  self:BindEvents()
  self:RefreshAll()
end

function M:Destruct()
  self.DataVersion = (self.DataVersion or 0) + 1
  self.bCustomTagDialogOpenPending = false
  self:CleanupRecruitGamepadState()
  self:UnbindEvents()
  self.Owner = nil
  self.Draft = nil
  self.SignWidgets = nil
  M.Super.Destruct(self)
end

function M:BindEvents()
  self.Btn_Edit:UnBindEventOnClickedByObj(self)
  self.Btn_Edit:BindEventOnClicked(self, self.OnSignEditClicked)
  self.Btn_Edit:BindForbidStateExecuteEvent(self, self.OnSignEditForbidden)
  self.Btn_SignDone:UnBindEventOnClickedByObj(self)
  self.Btn_SignDone:BindEventOnClicked(self, self.OnSignDoneClicked)
  self.Com_CheckBox_Open:UnBindEventOnClickedByObj(self)
  self.Com_CheckBox_Friend:UnBindEventOnClickedByObj(self)
  self.Com_CheckBox_Guild:UnBindEventOnClickedByObj(self)
  self.Com_CheckBox_Open:BindEventOnClicked({
    Inst = self,
    Func = self.OnPublicVisibilityChanged
  })
  self.Com_CheckBox_Friend:BindEventOnClicked({
    Inst = self,
    Func = self.OnFriendVisibilityChanged
  })
  self.Com_CheckBox_Guild:BindEventOnClicked({
    Inst = self,
    Func = self.OnGuildVisibilityChanged
  })
end

function M:UnbindEvents()
  if self.Btn_Edit then
    self.Btn_Edit:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_SignDone then
    self.Btn_SignDone:UnBindEventOnClickedByObj(self)
  end
  for _, CheckBox in ipairs({
    self.Com_CheckBox_Open,
    self.Com_CheckBox_Friend,
    self.Com_CheckBox_Guild
  }) do
    if CheckBox then
      CheckBox:UnBindEventOnClickedByObj(self)
    end
  end
end

function M:ShowTip(TextKey)
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText(TextKey))
end

function M:RefreshAll()
  if not self.Draft then
    self:ShowTip("UI_TeamRecruitCancelled")
    return
  end
  self.Text_TargetTitle:SetText(GText("UI_TeamTarget"))
  self.Text_LevelTitle:SetText(GText("UI_TeamObjectiveDifficulty"))
  self.Text_VisibilityTitle:SetText(GText("UI_TeamRoomStatus"))
  self.Text_SignTitle:SetText(GText("UI_TeamRecruitTag"))
  self.Text_CheckBox_Open:SetText(GText("UI_TeamPublic"))
  self.Text_CheckBox_Friend:SetText(GText("UI_TeamFriendsOnly"))
  self.Text_CheckBox_Guild:SetText(GText("UI_TeamGuildMembersOnly"))
  self.Text_Desc:SetText(GText("UI_TeamRecruitAutoEndAfter"))
  self.Com_SortDownTarget:InitTarget(TeamHallRecruitModel.GetFirstTypeOptions(), TeamHallRecruitModel.GetSecondTypeOptions, self.Draft.FirstType, self.Draft.SecondType, self, self.OnTargetSelected)
  self.Com_SortDownLevel:InitSingle(TeamHallRecruitModel.GetDungeonLevelOptions(self.Draft.SecondType), self.Draft.DungeonLevel, self, self.OnDungeonLevelSelected)
  self:RefreshVisibility()
  self:RefreshSignItems()
end

function M:RefreshVisibility()
  local VisibleSet = {}
  for _, VisibleType in ipairs(self.Draft.VisibleTypes or {}) do
    VisibleSet[VisibleType] = true
  end
  self.bRefreshingVisibility = true
  self.Com_CheckBox_Open:SetIsChecked(true == VisibleSet[GetVisibleType("Public")], false)
  self.Com_CheckBox_Friend:SetIsChecked(true == VisibleSet[GetVisibleType("Friend")], false)
  self.Com_CheckBox_Guild:SetIsChecked(true == VisibleSet[GetVisibleType("Guild")], false)
  self.bRefreshingVisibility = false
end

function M:BuildSignItemData()
  local Items = {}
  local SelectedSet = {}
  for _, Tag in ipairs(self.Draft.SelectedTags or {}) do
    local Key = GetTagKey(Tag)
    if Key then
      SelectedSet[Key] = true
    end
  end
  for _, Option in ipairs(TeamHallRecruitModel.GetPresetTagOptions(self.Draft.SecondType)) do
    Items[#Items + 1] = {
      Kind = "Preset",
      Value = Option.Id,
      Text = GText(Option.TextKey),
      Selected = true == SelectedSet["P:" .. tostring(Option.Id)],
      Disabled = self.bEditingCustomTags
    }
  end
  for _, Text in ipairs(self.Draft.CustomTagOptions or {}) do
    Items[#Items + 1] = {
      Kind = "Custom",
      Value = Text,
      Text = Text,
      Selected = true == SelectedSet["C:" .. Text],
      Editing = self.bEditingCustomTags
    }
  end
  local TagCount = #Items
  local TagMaxCount = GetTagMaxCount()
  if not self.bEditingCustomTags and #(self.Draft.CustomTagOptions or {}) < TeamHallRecruitModel.MaxCustomTagCount then
    Items[#Items + 1] = {Kind = "Add"}
  end
  while TagMaxCount > #Items do
    Items[#Items + 1] = {Kind = "Empty"}
  end
  return Items, TagCount, TagMaxCount
end

function M:RefreshSignItems()
  local ItemDataList, TagCount, TagMaxCount = self:BuildSignItemData()
  self.WrapList:ClearChildren()
  self.SignWidgets = {}
  for _, Data in ipairs(ItemDataList) do
    local Widget = UIManager(self):CreateWidget(SignItemAssetPath, false)
    if Widget then
      self.WrapList:AddChildToWrapBox(Widget)
      Widget:InitData(Data, self)
      self.SignWidgets[#self.SignWidgets + 1] = Widget
    end
  end
  self.Text_SignNum:SetText(tostring(TagCount))
  self.Text_SignNum_Total:SetText("/" .. tostring(TagMaxCount))
  self.WS_Sign:SetActiveWidgetIndex(self.bEditingCustomTags and 1 or 0)
  self.Btn_Edit:ForbidBtn(0 == #(self.Draft.CustomTagOptions or {}))
  self.Btn_SignDone:SetText(GText("UI_TeamComplete"))
  self.Btn_SignDone:ForbidBtn(false)
  if self.Btn_SignDone.WS_Key then
    self.Btn_SignDone.WS_Key:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:OnRecruitSignItemsRefreshed()
end

function M:OnTargetSelected(FirstType, SecondType)
  local NewDraft = TeamHallRecruitModel.ChangeTarget(self.Draft, FirstType, SecondType)
  if NewDraft then
    self.Draft = NewDraft
    self:RefreshAll()
  end
end

function M:OnDungeonLevelSelected(DungeonLevelIndex)
  local NewDraft = TeamHallRecruitModel.ChangeDungeonLevel(self.Draft, DungeonLevelIndex)
  if NewDraft then
    self.Draft = NewDraft
    self:RefreshAll()
  end
end

function M:OnPublicVisibilityChanged(bChecked)
  self:OnVisibilityChanged(GetVisibleType("Public"), bChecked)
end

function M:OnFriendVisibilityChanged(bChecked)
  self:OnVisibilityChanged(GetVisibleType("Friend"), bChecked)
end

function M:OnGuildVisibilityChanged(bChecked)
  self:OnVisibilityChanged(GetVisibleType("Guild"), bChecked)
end

function M:OnVisibilityChanged(VisibleType, bChecked)
  if self.bRefreshingVisibility or not VisibleType then
    return
  end
  local Selected = {}
  for _, Value in ipairs(self.Draft.VisibleTypes or {}) do
    Selected[Value] = true
  end
  if not bChecked and Selected[VisibleType] then
    local Count = 0
    for _, bSelected in pairs(Selected) do
      if bSelected then
        Count = Count + 1
      end
    end
    if Count <= 1 then
      self:ShowTip("UI_TeamSelectAtLeastOne")
      self:RefreshVisibility()
      return
    end
    Selected[VisibleType] = nil
  elseif bChecked then
    if VisibleType == GetVisibleType("Public") then
      Selected = {
        [VisibleType] = true
      }
    else
      Selected[GetVisibleType("Public")] = nil
      Selected[VisibleType] = true
    end
  end
  local Values = {}
  for Value, bSelected in pairs(Selected) do
    if bSelected then
      Values[#Values + 1] = Value
    end
  end
  self.Draft.VisibleTypes = TeamHallRecruitModel.NormalizeVisibleTypes(Values)
  self:RefreshVisibility()
end

function M:OnRecruitSignItemClicked(Data)
  if not Data then
    return
  end
  if Data.Kind == "Add" then
    self:OpenCustomTagDialog()
    return
  end
  if Data.Kind == "Custom" and self.bEditingCustomTags then
    self:DeleteCustomTag(Data.Value)
    return
  end
  if Data.Kind == "Preset" or Data.Kind == "Custom" then
    self:ToggleSelectedTag(Data)
  end
end

function M:ToggleSelectedTag(Data)
  local Key = GetTagKey(Data)
  if not Key then
    return
  end
  local RestoreToken = self.bRecruitGamepadViewActive and self:CaptureRecruitFocusToken() or nil
  local SelectedTags = self.Draft.SelectedTags
  for Index, Tag in ipairs(SelectedTags) do
    if GetTagKey(Tag) == Key then
      table.remove(SelectedTags, Index)
      self:RefreshSignItems()
      self:RestoreRecruitFocusAfterSignRefresh(RestoreToken)
      return
    end
  end
  if #SelectedTags >= TeamHallRecruitModel.MaxSelectedTagCount then
    self:ShowTip("UI_TeamSelectAtMostTwo")
    return
  end
  SelectedTags[#SelectedTags + 1] = {
    Kind = Data.Kind,
    Value = Data.Value
  }
  self:RefreshSignItems()
  self:RestoreRecruitFocusAfterSignRefresh(RestoreToken)
end

function M:OnSignEditClicked()
  self:EnterCustomTagEditMode()
end

function M:OnSignDoneClicked()
  self:ExitCustomTagEditMode()
end

function M:OnSignEditForbidden()
  self:ShowTip("UI_TeamNoCustomTagCreated")
end

function M:OpenCustomTagDialog()
  if self.bCustomTagDialogOpenPending or self.bEditingCustomTags or #(self.Draft.CustomTagOptions or {}) >= TeamHallRecruitModel.MaxCustomTagCount then
    return false
  end
  self.bCustomTagDialogOpenPending = true
  local DataVersion = self.DataVersion
  
  local function ClearOpenPending()
    if IsValid(self) and self.DataVersion == DataVersion then
      self.bCustomTagDialogOpenPending = false
    end
  end
  
  self.CustomTagDialogFocusToken = self.bRecruitGamepadViewActive and self:CaptureRecruitFocusToken() or nil
  local PopupUI = UIManager(self):ShowCommonPopupUI_Suspend(TeamHallCommon.Recruit.CustomTagPopupId, {
    UseGenaral = true,
    DontPlayOutAnimation = true,
    MultilineType = 1,
    TextLenMax = TeamHallRecruitModel.MaxCustomTagTextLength,
    HintText = GText("UI_PleaseInputTag"),
    ExtraCheckFunc = function(_, InputWidget, Text)
      local TrimmedText = TeamHallRecruitModel.TrimCustomTagText(Text)
      if TeamHallRecruitModel.IsCustomTagTextValid(TrimmedText) then
        return true
      end
      local TextLength = TeamHallRecruitModel.GetCustomTagTextLength(TrimmedText)
      local TipText = TextLength and TextLength > TeamHallRecruitModel.MaxCustomTagTextLength and GText("UI_REGISTER_OVERLENGTH") or GText("UI_REGISTER_ILLEGALINPUT")
      InputWidget.Common_EditText:ShowTips(TipText, 1)
      return false
    end,
    OnSDKChecked = function(bSuccess, _, Text)
      if bSuccess and IsValid(self) then
        self:AddCustomTag(Text)
      end
    end
  }, self)
  if not PopupUI then
    ClearOpenPending()
    return false
  end
  if self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(ClearOpenPending, 1)
  else
    ClearOpenPending()
  end
  return true
end

function M:AddCustomTag(Text)
  local TrimmedText = TeamHallRecruitModel.TrimCustomTagText(Text)
  if not TeamHallRecruitModel.IsCustomTagTextValid(TrimmedText) then
    return
  end
  for _, ExistingText in ipairs(self.Draft.CustomTagOptions or {}) do
    if ExistingText == TrimmedText then
      return
    end
  end
  if #(self.Draft.CustomTagOptions or {}) >= TeamHallRecruitModel.MaxCustomTagCount then
    return
  end
  local RestoreToken = self.CustomTagDialogFocusToken
  self.CustomTagDialogFocusToken = nil
  self.Draft.CustomTagOptions[#self.Draft.CustomTagOptions + 1] = TrimmedText
  self.Draft = TeamHallRecruitModel.NormalizeDraft(self.Draft) or self.Draft
  self:RefreshSignItems()
  self:RestoreRecruitFocusAfterSignRefresh(RestoreToken)
end

function M:DeleteCustomTag(Text)
  for Index, ExistingText in ipairs(self.Draft.CustomTagOptions or {}) do
    if ExistingText == Text then
      table.remove(self.Draft.CustomTagOptions, Index)
      break
    end
  end
  for Index = #self.Draft.SelectedTags, 1, -1 do
    local Tag = self.Draft.SelectedTags[Index]
    if Tag.Kind == "Custom" and Tag.Value == Text then
      table.remove(self.Draft.SelectedTags, Index)
    end
  end
  self.Draft = TeamHallRecruitModel.NormalizeDraft(self.Draft) or self.Draft
  self:RefreshSignItems()
end

function M:RequestPublish()
  if self.bEditingCustomTags or self.bRecruitEditExitPending or self.bRequestingPublish or not self.Draft then
    return false
  end
  local RecruitmentInfo = TeamHallRecruitModel.BuildRecruitmentInfo(self.Draft)
  local PersistedSnapshot = TeamHallRecruitModel.BuildPersistedSnapshot(self.Draft)
  if not RecruitmentInfo or not PersistedSnapshot then
    self:ShowTip("UI_TeamRecruitCancelled")
    return false
  end
  self.bRequestingPublish = true
  if self.Owner then
    self.Owner:ForbidRightBtn(true)
  end
  local RequestVersion = self.DataVersion
  local bCompleted = false
  
  local function Complete(bSuccess)
    if bCompleted then
      return
    end
    bCompleted = true
    if not IsValid(self) or self.DataVersion ~= RequestVersion then
      return
    end
    self.bRequestingPublish = false
    if self.Owner then
      self.Owner:ForbidRightBtn(false)
    end
    if bSuccess then
      AudioManager(self):PlayUISound(self, "event:/ui/common/connect_hall_recruit_send", nil, nil)
    end
    if bSuccess and self.Owner then
      self.Owner:OnClose()
    end
  end
  
  local bRequestStarted = TeamHallController:PublishRecruitment(RecruitmentInfo, PersistedSnapshot, Complete)
  if not bRequestStarted then
    Complete(false)
  end
  return bRequestStarted
end

function M:OnContentMouseButtonDown(_MyGeometry, _InPointerEvent)
  self:CloseOpenedRecruitSortDowns(false)
  return false
end

function M:HandleDialogFocused()
  return self:GetRecruitDesiredFocusTarget()
end

AssembleComponents(M)

function M:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  return self:HandleRecruitGamepadKey(MyGeometry, InKeyEvent)
end

return M
