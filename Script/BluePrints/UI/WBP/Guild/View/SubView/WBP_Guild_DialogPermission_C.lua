require("UnLua")
local UIUtils = require("Utils.UIUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildPermissionUtils = require("BluePrints.UI.WBP.Guild.Common.GuildPermissionUtils")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self._Saving = false
  self.Button_Close.OnClicked:Add(self, self.OnCloseClicked)
  self.Btn_Quit:BindEventOnClicked(self, self.OnCancelClicked)
  self.Btn_Yes:BindEventOnClicked(self, self.OnSaveClicked)
  self.Btn_Yes:BindForbidStateExecuteEvent(self, self.OnSaveClickedForbidden)
  self.Btn_Close:BindEventOnClicked(self, self.OnBtnCloseClicked)
end

function M:Destruct()
  self.Button_Close.OnClicked:Remove(self, self.OnCloseClicked)
  self.Btn_Quit:UnBindEventOnClicked(self, self.OnCancelClicked)
  self.Btn_Yes:UnBindEventOnClicked(self, self.OnSaveClicked)
  self.Btn_Close:UnBindEventOnClicked(self, self.OnBtnCloseClicked)
end

function M:OnLoaded()
  self:InitPermissionDialog()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:AddTimer(0.2, function()
    self:SetDefaultFocusButton()
    self:RefreshGamepadNavigation()
  end)
end

function M:InitPermissionDialog()
  local guild = GuildController:GetModel():GetCurrGuild()
  if not guild then
    self:CloseDialog()
    return
  end
  local Avatar = GWorld:GetAvatar()
  local mem = Avatar and GuildController:GetModel():GetCurrMember(Avatar.Uid)
  self.ViewerTitle = mem and mem.Title or 0
  self.bCanEdit = self.ViewerTitle == GuildPermissionUtils.TitlePresident or self.ViewerTitle == GuildPermissionUtils.TitleVicePresident
  self.WS_Bottom:SetActiveWidgetIndex(self.bCanEdit and 1 or 0)
  self.Text_Tip:SetText(GText("UI_Armory_ClickEmpty"))
  self.Text_Title:SetText(GText("UI_MemberPermissions"))
  self.Btn_Yes:SetText(GText("UI_GuildMemberEditConfirm"))
  self.Btn_Quit:SetText(GText("UI_GuildMemberEditCancel"))
  self:RefreshColumnHeaders(guild)
  self.InitialClosed = GuildPermissionUtils.CloneClosedDraft(guild.ClosedPermission)
  self.DraftClosed = self:CopyDraft(self.InitialClosed)
  self:RebuildList()
  self:UpdateSaveButtonState()
  if self.In then
    self:PlayAnimation(self.In)
  end
  self.Btn_Yes:SetGamePadImg("X")
  self.Btn_Quit:SetGamePadImg("B")
  self.Controller_Select:CreateCommonKey({
    KeyInfoList = {
      {ImgShortPath = "A", Type = "Img"}
    },
    Desc = GText("UI_CTL_Select")
  })
  self.Controller_Close:CreateCommonKey({
    KeyInfoList = {
      {ImgShortPath = "B", Type = "Img"}
    },
    Desc = GText("UI_Controller_Close")
  })
end

function M:CopyDraft(src)
  local out = {}
  for t = 1, GuildPermissionUtils.TitleVicePresident do
    out[t] = {}
    if src[t] then
      for k, v in pairs(src[t]) do
        if v then
          out[t][k] = true
        end
      end
    end
  end
  return out
end

function M:RefreshColumnHeaders(guild)
  local counts = {}
  for _, m in ipairs(guild.Members or {}) do
    local tid = m.Title
    counts[tid] = (counts[tid] or 0) + 1
  end
  
  local function formatHeader(titleId)
    local cfg = DataMgr.GuildTitle and DataMgr.GuildTitle[titleId]
    local name = cfg and cfg.TitleName and GText(cfg.TitleName) or tostring(titleId)
    local n = counts[titleId] or 0
    local lim = cfg and cfg.LimitCount
    if lim and lim > 0 then
      return string.format("%s (%d/%d)", name, n, lim)
    end
    return string.format("%s (%d)", name, n)
  end
  
  self.Text_President:SetText(formatHeader(GuildPermissionUtils.TitlePresident))
  self.Text_Vice:SetText(formatHeader(GuildPermissionUtils.TitleVicePresident))
  self.Text_Admin:SetText(formatHeader(GuildPermissionUtils.TitleManager))
  self.Text_Premium:SetText(formatHeader(GuildPermissionUtils.TitleDeacon))
  self.Text_Member:SetText(formatHeader(GuildPermissionUtils.TitleMember))
end

function M:RebuildList()
  self.List_Permission:ClearListItems()
  local classPath = UIUtils.GetCommonItemContentClass()
  for i, row in ipairs(GuildPermissionUtils.PERMISSION_ROWS) do
    local o = NewObject(classPath)
    o.PermissionKey = row.Key
    o.LocKey = row.LocKey
    o.Dialog = self
    o.Index = i
    self.List_Permission:AddItem(o)
  end
end

function M:IsPermissionCellInteractive(targetTitle, permKey)
  local eligible = GuildPermissionUtils.IsEligibleByTable(targetTitle, permKey)
  return self.bCanEdit and eligible and targetTitle < GuildPermissionUtils.TitlePresident and GuildPermissionUtils.CanEditColumn(self.ViewerTitle, targetTitle)
end

function M:GetPermissionEntryWidgets()
  if not self.List_Permission or not self.List_Permission.GetDisplayedEntryWidgets then
    return {}
  end
  local disp = self.List_Permission:GetDisplayedEntryWidgets()
  if not disp then
    return {}
  end
  if disp.ToTable then
    return disp:ToTable() or {}
  end
  local out = {}
  for _, w in pairs(disp) do
    table.insert(out, w)
  end
  return out
end

function M:GetFirstInteractiveFocusButton()
  local entries = self:GetPermissionEntryWidgets()
  for _, rowWidget in ipairs(entries) do
    local content = rowWidget.Content
    if content and content.PermissionKey then
      local permKey = content.PermissionKey
      local boxes = rowWidget.GetCheckBoxes and rowWidget:GetCheckBoxes() or {}
      for i, targetTitle in ipairs(GuildPermissionUtils.COLUMN_TITLES) do
        if self:IsPermissionCellInteractive(targetTitle, permKey) then
          local cb = boxes[i]
          local btn = cb and (cb.GetFocusButton and cb:GetFocusButton() or cb.Btn_Click)
          if btn then
            return btn
          end
        end
      end
    end
  end
  return nil
end

function M:RefreshGamepadNavigation()
  if not self.bCanEdit then
    return
  end
  local entries = self:GetPermissionEntryWidgets()
  local nRows = #entries
  if 0 == nRows then
    return
  end
  local t = {}
  for r = 1, nRows do
    t[r] = {}
  end
  for r, rowWidget in ipairs(entries) do
    local content = rowWidget.Content
    if content and content.PermissionKey then
      local permKey = content.PermissionKey
      local boxes = rowWidget.GetCheckBoxes and rowWidget:GetCheckBoxes() or {}
      for i, targetTitle in ipairs(GuildPermissionUtils.COLUMN_TITLES) do
        if self:IsPermissionCellInteractive(targetTitle, permKey) then
          local cb = boxes[i]
          local btn = cb and (cb.GetFocusButton and cb:GetFocusButton() or cb.Btn_Click)
          if btn and IsValid(btn) then
            t[r][i] = btn
          end
        end
      end
    end
  end
  
  local function neighborUp(r, c)
    for nr = r - 1, 1, -1 do
      if t[nr][c] then
        return t[nr][c]
      end
    end
    return nil
  end
  
  local function neighborDown(r, c)
    for nr = r + 1, nRows do
      if t[nr][c] then
        return t[nr][c]
      end
    end
    return nil
  end
  
  local function neighborLeft(r, c)
    for nc = c - 1, 1, -1 do
      if t[r][nc] then
        return t[r][nc]
      end
    end
    return nil
  end
  
  local function neighborRight(r, c)
    for nc = c + 1, #GuildPermissionUtils.COLUMN_TITLES do
      if t[r][nc] then
        return t[r][nc]
      end
    end
    return nil
  end
  
  for r = 1, nRows do
    for c = 1, #GuildPermissionUtils.COLUMN_TITLES do
      local btn = t[r][c]
      if btn then
        local nu, nd, nl, nr = neighborUp(r, c), neighborDown(r, c), neighborLeft(r, c), neighborRight(r, c)
        if nu then
          btn:SetNavigationRuleExplicit(EUINavigation.Up, nu)
        else
          btn:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
        end
        if nd then
          btn:SetNavigationRuleExplicit(EUINavigation.Down, nd)
        else
          btn:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
        end
        if nl then
          btn:SetNavigationRuleExplicit(EUINavigation.Left, nl)
        else
          btn:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
        end
        if nr then
          btn:SetNavigationRuleExplicit(EUINavigation.Right, nr)
        else
          btn:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
        end
      end
    end
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if ModController and ModController:IsMobile() then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self.CurGamepadName = CurGamepadName
  if CurInputDevice == ECommonInputType.Gamepad then
    if not self.bCanEdit then
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
    else
      self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
      self:RefreshGamepadNavigation()
    end
    self:SetDefaultFocusButton()
    self.Controller_Select:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Controller:SetActiveWidgetIndex(1)
  else
    self.Controller_Select:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.WS_Controller:SetActiveWidgetIndex(0)
  end
end

function M:SetDefaultFocusButton()
  local btn = self:GetFirstInteractiveFocusButton()
  if btn then
    btn:SetFocus()
  else
    self.Button_Close:SetFocus()
  end
end

function M:RefreshPermissionRow(rowWidget)
  local content = rowWidget.Content
  if not content or not content.PermissionKey then
    return
  end
  local permKey = content.PermissionKey
  local boxes = rowWidget.GetCheckBoxes and rowWidget:GetCheckBoxes() or {}
  for i, targetTitle in ipairs(GuildPermissionUtils.COLUMN_TITLES) do
    local cb = boxes[i]
    if cb and cb.SetCellState and cb.SetToggleHandler then
      local eligible = GuildPermissionUtils.IsEligibleByTable(targetTitle, permKey)
      local effective
      if targetTitle == GuildPermissionUtils.TitlePresident then
        effective = eligible
      else
        effective = GuildPermissionUtils.DraftEffective(self.DraftClosed, targetTitle, permKey)
      end
      local showDash = not eligible
      local interactive = self:IsPermissionCellInteractive(targetTitle, permKey)
      cb:SetCellState(interactive, showDash, effective)
      local dialog = self
      local tTitle = targetTitle
      local pKey = permKey
      cb:SetToggleHandler(function()
        dialog:OnToggleCell(tTitle, pKey)
      end)
    end
  end
end

function M:OnToggleCell(targetTitle, permKey)
  if self._Saving or not self.bCanEdit then
    return
  end
  if self.ViewerTitle == targetTitle then
    return
  end
  if not GuildPermissionUtils.CanEditColumn(self.ViewerTitle, targetTitle) then
    return
  end
  if not GuildPermissionUtils.IsEligibleByTable(targetTitle, permKey) then
    return
  end
  if not self.DraftClosed[targetTitle] then
    self.DraftClosed[targetTitle] = {}
  end
  local row = self.DraftClosed[targetTitle]
  local curEff = GuildPermissionUtils.DraftEffective(self.DraftClosed, targetTitle, permKey)
  if curEff then
    row[permKey] = true
  else
    row[permKey] = nil
  end
  self:UpdateSaveButtonState()
end

function M:IsDirty()
  for t = 1, GuildPermissionUtils.TitleVicePresident do
    for _, row in ipairs(GuildPermissionUtils.PERMISSION_ROWS) do
      local k = row.Key
      if GuildPermissionUtils.IsEligibleByTable(t, k) then
        local a = self.InitialClosed[t] and self.InitialClosed[t][k]
        local b = self.DraftClosed[t] and self.DraftClosed[t][k]
        local fa, fb = a and true or false, b and true or false
        if fa ~= fb then
          return true
        end
      end
    end
  end
  return false
end

function M:UpdateSaveButtonState()
  if not self.bCanEdit then
    return
  end
  local dirty = self:IsDirty()
  self.Btn_Yes:ForbidBtn(not dirty)
end

function M:BuildChangeList()
  local list = {}
  for t = 1, GuildPermissionUtils.TitleVicePresident do
    for _, row in ipairs(GuildPermissionUtils.PERMISSION_ROWS) do
      local k = row.Key
      if GuildPermissionUtils.IsEligibleByTable(t, k) then
        local a = self.InitialClosed[t] and self.InitialClosed[t][k]
        local b = self.DraftClosed[t] and self.DraftClosed[t][k]
        local fa, fb = a and true or false, b and true or false
        if fa ~= fb then
          table.insert(list, {
            Title = t,
            Permission = k,
            IsOpen = not fb
          })
        end
      end
    end
  end
  return list
end

function M:OnSaveClicked()
  if not self.bCanEdit or self._Saving then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local changes = self:BuildChangeList()
  if not changes or 0 == #changes then
    return
  end
  self._Saving = true
  local dialog = self
  local total = #changes
  local done = 0
  local anyFail = false
  
  local function onResult(Ret)
    if anyFail then
      return
    end
    if Ret ~= ErrorCode.RET_SUCCESS then
      anyFail = true
      dialog._Saving = false
      return
    end
    done = done + 1
    if done >= total then
      dialog._Saving = false
      dialog.InitialClosed = dialog:CopyDraft(dialog.DraftClosed)
      UIManager(dialog):ShowUITip(UIConst.Tip_CommonToast, GText("UI_EditSuccessful"))
      dialog:UpdateSaveButtonState()
    end
  end
  
  for _, one in ipairs(changes) do
    GuildController:SendGuildSetPermissionSwitch(one.Title, one.Permission, one.IsOpen, onResult)
  end
end

function M:OnSaveClickedForbidden()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_GuildPermission_NoChange"))
end

function M:OnCancelClicked()
  if self._Saving then
    return
  end
  self:CloseDialog()
end

function M:OnCloseClicked()
  if self.bCanEdit then
    return
  end
  self:CloseDialog()
end

function M:CloseDialog()
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:Close()
  end
end

function M:OnBtnCloseClicked()
  self:CloseDialog()
end

function M:BP_GetDesiredFocusTarget()
  if not UIUtils.IsGamepadInput() then
    return nil
  end
  if not self.bCanEdit then
    return self
  end
  return self:GetFirstInteractiveFocusButton()
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and UIUtils.IsGamepadInput() then
    if "Gamepad_FaceButton_Right" == InKeyName then
      self:OnCancelClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    elseif "Gamepad_FaceButton_Left" == InKeyName and self.bCanEdit then
      if self.Btn_Yes:IsBtnForbidden() then
        self:OnSaveClickedForbidden()
      else
        self:OnSaveClicked()
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Escape" == InKeyName then
    self:OnCancelClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

return M
