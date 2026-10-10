require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

local function SplitGuildNameLetters(Name)
  local Letters = {}
  if type(Name) ~= "string" or "" == Name then
    return Letters
  end
  for _, Code in utf8.codes(Name) do
    table.insert(Letters, utf8.char(Code))
  end
  return Letters
end

local function LoadGuildLogoTexture(LogoInfo)
  local Parsed = GuildLogoInfo.Parse(LogoInfo)
  if not Parsed then
    return nil
  end
  local LogoId = tonumber(Parsed.LogoIcon) or 0
  local LogoData = DataMgr.GuildLogo and DataMgr.GuildLogo[LogoId] or nil
  if not LogoData or not LogoData.LogoPath then
    return nil
  end
  return LoadObject(LogoData.LogoPath)
end

function M:PreInitContent(Params, PopupData, Owner)
  M.Super.PreInitContent(self, Params, PopupData, Owner)
  if self.Owner then
    self.Owner.DontCloseWhenRightBtnClicked = true
  end
  self:BindDialogEvent(DialogEvent.OnRightBtnClicked, self.OnConfirmClicked)
  GuildController:UnRegisterEvent(self)
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildEditBadgeText then
      self:OnGuildEditBadgeText(...)
    end
  end)
end

function M:InitContent(Params, PopupData, Owner)
  M.Super.InitContent(self, Params, PopupData, Owner)
  local GuildInfo = Params and Params.GuildInfo or GuildController:GetModel():GetCurrGuild()
  self.GuildInfo = GuildInfo
  self.LetterContents = {}
  self.EquippedLetter = GuildInfo and GuildInfo.BadgeText or ""
  self.SelectedLetter = self.EquippedLetter
  self.SelectedIndex = 1
  if self.Text_Title then
    self.Text_Title:SetText(GText("UI_GuildEmblem_Exclusive"))
  end
  if self.Text_Desc then
    self.Text_Desc:SetText(GText("UI_GuildEmblem_SelectCharacter"))
  end
  self:RefreshLogoImage()
  self:BindListEvents()
  self:InitLetterList()
  self:RefreshPreview()
  self:RefreshConfirmBtn()
end

function M:PostInitContent(Params, PopupData, Owner)
  M.Super.PostInitContent(self, Params, PopupData, Owner)
  self:RefreshConfirmBtn()
end

function M:Destruct()
  self:UnbindListEvents()
  self:UnbindDialogEvent(DialogEvent.OnRightBtnClicked)
  GuildController:UnRegisterEvent(self)
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
  self.bIgnoreListSelection = nil
  self.LetterContents = nil
  self.GuildInfo = nil
  self.Owner = nil
end

function M:BindListEvents()
  self:UnbindListEvents()
  if not self.List then
    return
  end
  if self.List.BP_OnItemSelectionChanged then
    self.List.BP_OnItemSelectionChanged:Add(self, self.OnListItemSelectionChanged)
  end
  if self.List.OnCreateEmptyContent then
    self.List.OnCreateEmptyContent:Bind(self, self.CreateEmptyLetterContent)
  end
end

function M:UnbindListEvents()
  if not self.List then
    return
  end
  if self.List.BP_OnItemSelectionChanged then
    self.List.BP_OnItemSelectionChanged:Remove(self, self.OnListItemSelectionChanged)
  end
  if self.List.OnCreateEmptyContent then
    self.List.OnCreateEmptyContent:Unbind()
  end
end

function M:RefreshLogoImage()
  if not self.Image_Logo then
    return
  end
  local Texture = self.GuildInfo and LoadGuildLogoTexture(self.GuildInfo.LogoInfo) or nil
  if Texture and self.Image_Logo.SetBrushFromTexture then
    self.Image_Logo:SetBrushFromTexture(Texture, true)
  end
end

function M:InitLetterList()
  if not self.List or not self.List.ClearListItems then
    return
  end
  self.bIgnoreListSelection = true
  self.List:ClearListItems()
  self.LetterContents = {}
  local Name = self.GuildInfo and self.GuildInfo.Name or ""
  local Letters = SplitGuildNameLetters(Name)
  if "" == self.EquippedLetter and Letters[1] then
    self.SelectedLetter = Letters[1]
  end
  local SelectedContent
  for Index, Letter in ipairs(Letters) do
    if Letter == self.SelectedLetter then
      self.SelectedIndex = Index
      break
    end
  end
  for Index, Letter in ipairs(Letters) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.Parent = self
    Content.bEmpty = false
    Content.Letter = Letter
    if Letter == self.SelectedLetter then
      SelectedContent = Content
    end
    table.insert(self.LetterContents, Content)
    self.List:AddItem(Content)
  end
  if self.List.RequestFillEmptyContent then
    self.List:RequestFillEmptyContent()
  end
  if SelectedContent then
    if self.List.BP_SetSelectedItem then
      self.List:BP_SetSelectedItem(SelectedContent)
    elseif self.List.SetSelectedIndex then
      self.List:SetSelectedIndex(math.max((SelectedContent.Index or 1) - 1, 0))
    end
  end
  self.List:SetNavigationRuleBase(UE4.EUINavigation.Up, UE4.EUINavigationRule.Stop)
  self.List:SetNavigationRuleBase(UE4.EUINavigation.Down, UE4.EUINavigationRule.Stop)
  self.List:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self.List:SetNavigationRuleBase(UE4.EUINavigation.Right, UE4.EUINavigationRule.Stop)
  self.bIgnoreListSelection = false
end

function M:CreateEmptyLetterContent()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.bEmpty = true
  Content.Letter = ""
  Content.Parent = self
  return Content
end

function M:OnListItemSelectionChanged(Content, bIsSelected)
  if self.bIgnoreListSelection then
    return
  end
  if bIsSelected then
    self:OnLetterClicked(Content)
  end
end

function M:OnLetterClicked(Content)
  if not IsValid(self) then
    return
  end
  if not IsValid(Content) or Content.bEmpty or not Content.Letter then
    return
  end
  self:SelectLetter(Content.Letter, Content.Index)
end

function M:SelectLetter(Letter, Index)
  if type(Letter) ~= "string" then
    return
  end
  self.SelectedLetter = Letter
  if Index then
    self.SelectedIndex = Index
  end
  self:RefreshListSelection(true)
  self:RefreshPreview()
  self:RefreshConfirmBtn()
end

function M:RefreshListSelection(bPlayAnim)
  for _, ItemContent in ipairs(self.LetterContents or {}) do
    local Entry = ItemContent.SelfWidget or ItemContent.CurrentEntry
    if IsValid(Entry) and Entry.Refresh then
      local bShouldEquip = not ItemContent.bEmpty and ItemContent.Letter ~= "" and ItemContent.Letter == self.EquippedLetter
      local bShouldPreview = not ItemContent.bEmpty and not bShouldEquip and ItemContent.Index == self.SelectedIndex
      if Entry.bEquippedVisual ~= bShouldEquip or Entry.bPreviewVisual ~= bShouldPreview then
        Entry:Refresh(true == bPlayAnim)
      end
    end
  end
end

function M:RefreshPreview()
  if not self.Sign or not self.Sign.InitByGuildData then
    return
  end
  local LogoInfo = self.GuildInfo and self.GuildInfo.LogoInfo or nil
  self.Sign:InitByGuildData(LogoInfo, self.SelectedLetter)
end

function M:RefreshConfirmBtn()
  local ButtonBar = self.Owner and self.Owner.GetButtonBar and self.Owner:GetButtonBar()
  if not (ButtonBar and ButtonBar.Btn_Yes) or not ButtonBar.Btn_Yes.ForbidBtn then
    return
  end
  local bUnchanged = self.SelectedLetter == self.EquippedLetter
  ButtonBar.Btn_Yes:ForbidBtn(bUnchanged)
end

function M:OnConfirmClicked()
  if not IsValid(self) then
    return
  end
  if self.SelectedLetter == self.EquippedLetter or self.SelectedLetter == "" then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildEmblem_NoModification"))
    return
  end
  GuildController:SendGuildEditBadgeText(self.SelectedLetter)
end

function M:OnGuildEditBadgeText(Ret)
  if not IsValid(self) then
    return
  end
  if Ret and Ret ~= ErrorCode.RET_SUCCESS then
    return
  end
  self.EquippedLetter = self.SelectedLetter
  self:RefreshListSelection(true)
  self:RefreshConfirmBtn()
  if IsValid(self.Owner) then
    self.Owner:Close()
  end
end

function M:GetCurrentLetterEntry()
  local Content = self.LetterContents and self.LetterContents[self.SelectedIndex]
  local Entry = Content and (Content.SelfWidget or Content.CurrentEntry)
  if IsValid(Entry) then
    return Entry
  end
  return nil
end

function M:HandleDialogFocused()
  return self:GetCurrentLetterEntry() or self.List
end

function M:InitGamepadView()
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(true)
  end
  if not self.List then
    return
  end
  local FocusIndex = math.max((self.SelectedIndex or 1) - 1, 0)
  if self.List.NavigateToIndex then
    self.List:NavigateToIndex(FocusIndex)
  end
  if self.List.BP_CancelScrollIntoView then
    self.List:BP_CancelScrollIntoView()
  elseif self.List.CancelScrollIntoView then
    self.List:CancelScrollIntoView()
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local Entry = self:GetCurrentLetterEntry()
  if IsValid(PlayerController) then
    if Entry and Entry.SetUserFocus then
      Entry:SetUserFocus(PlayerController)
    elseif self.List.SetUserFocus then
      self.List:SetUserFocus(PlayerController)
    end
  end
end

function M:InitKeyboardView()
  if self.SetIsDealWithVirtualAccept then
    self:SetIsDealWithVirtualAccept(false)
  end
end

function M:HandleConfirmGamepadKey(InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName ~= UIConst.GamePadKey.FaceButtonBottom then
    return false
  end
  self:OnConfirmClicked()
  return true
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self:HandleConfirmGamepadKey(InKeyEvent) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:OnContentPreviewKeyDown(MyGeometry, InKeyEvent)
  return self:HandleConfirmGamepadKey(InKeyEvent)
end

return M
