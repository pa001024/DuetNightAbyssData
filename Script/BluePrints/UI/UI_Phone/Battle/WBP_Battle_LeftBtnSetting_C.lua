require("UnLua")
local UIUtils = require("Utils.UIUtils")
local BattleLeftBtnFuncConst = require("BluePrints.UI.UI_Phone.Battle.BattleLeftBtnFuncConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local FUNC_LIST = BattleLeftBtnFuncConst.FUNC_LIST
local BTN_IDX_EDIT = 1
local BTN_IDX_CONFIRM = 0

function M:Construct()
  self.BtnConfirm.Button_Area.OnClicked:Add(self, self.OnConfirmClicked)
  self.BtnEdit.Button_Area.OnClicked:Add(self, self.OnEditBtnClicked)
  self.BtnEdit.Text_Button:SetText(GText("UI_HUD_LeftBtnFold_Btn01"))
  self.BtnConfirm.Text_Button:SetText(GText("UI_HUD_LeftBtnFold_Btn02"))
  self.BtnConfirm.AudioEventPath = "event:/ui/common/click_btn_confirm"
  self.BtnConfirm.AudioPlayCase = EUIAudioPlayCase.OnMouseUp
  self.BtnEdit.AudioEventPath = "event:/ui/common/click_btn_confirm"
  self.BtnEdit.AudioPlayCase = EUIAudioPlayCase.OnMouseUp
end

function M:OpenPanel(OwnerWidget, Config)
  self.OwnerWidget = OwnerWidget
  self.SlotConfig = {
    Config[1],
    Config[2]
  }
  self.IsEditMode = false
  self.SelectedSlot = nil
  self.EditSlotConfig = nil
  self.TextTitle:SetText(GText("UI_HUD_LeftBtnFold_Tip01"))
  self.Ws_Btn:SetActiveWidgetIndex(BTN_IDX_EDIT)
  self:InitList()
end

function M:InitList()
  local OwnerPanel = self.OwnerWidget and self.OwnerWidget.OwnerPanel
  local Player = OwnerPanel and OwnerPanel.OwnerPlayer
  self.List:ClearListItems()
  for FuncId = 1, 5 do
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.FuncId = FuncId
    Obj.Name = GText(FUNC_LIST[FuncId].textmap)
    Obj.IconPath = FUNC_LIST[FuncId].iconPath
    Obj.OwnerPanel = self
    local IsActive = false
    if IsValid(Player) then
      if 1 == FuncId then
        IsActive = Player:IsAutoAttackEnabled()
      elseif 2 == FuncId then
        IsActive = Player:IsAutoShootEnabled()
      elseif 3 == FuncId then
        IsActive = Player:CharacterInTag("Crouch")
      elseif 4 == FuncId then
        local AnimInst = Player.PlayerAnimInstance
        IsActive = nil ~= AnimInst and AnimInst.IsWalking == true
      end
    end
    Obj.IsInSlot = IsActive
    Obj.EditCheckState = nil
    self.List:AddItem(Obj)
  end
  local total = #FUNC_LIST
  local remainder = total % 2
  if 0 ~= remainder then
    for i = 1, 2 - remainder do
      local Empty = NewObject(UIUtils.GetCommonItemContentClass())
      Empty.OwnerPanel = self
      self.List:AddItem(Empty)
    end
  end
end

function M:OnEditBtnClicked()
  self.IsEditMode = true
  self.SelectedSlot = nil
  self.EditSlotConfig = {
    self.SlotConfig[1],
    self.SlotConfig[2]
  }
  self.TextTitle:SetText(GText("UI_HUD_LeftBtnFold_Tip02"))
  self.Ws_Btn:SetActiveWidgetIndex(BTN_IDX_CONFIRM)
  if self.OwnerWidget and type(self.OwnerWidget.OnEnterEditMode) == "function" then
    self.OwnerWidget:OnEnterEditMode()
  end
  self:RefreshListEdit()
end

function M:RefreshListEdit()
  local Cfg = self.EditSlotConfig
  local Count = self.List:GetNumItems()
  for i = 0, Count - 1 do
    local Obj = self.List:GetItemAt(i)
    if Obj then
      local InSlot1 = Cfg[1] == Obj.FuncId
      local InSlot2 = Cfg[2] == Obj.FuncId
      local IsInSlot = InSlot1 or InSlot2
      local CheckState
      if not IsInSlot then
        CheckState = "candidate"
      elseif self.SelectedSlot == nil or 1 == self.SelectedSlot and InSlot1 or 2 == self.SelectedSlot and InSlot2 then
        CheckState = "selected"
      else
        CheckState = "other_slot"
      end
      Obj.IsInSlot = IsInSlot
      Obj.EditCheckState = CheckState
      if IsValid(Obj.EntryWidget) and type(Obj.EntryWidget.RefreshState) == "function" then
        Obj.EntryWidget:RefreshState(IsInSlot, CheckState)
      end
    end
  end
end

function M:OnSlotSelected(SlotIndex)
  self.SelectedSlot = SlotIndex
  self:RefreshListEdit()
end

function M:OnItemClicked(FuncId)
  if not self.IsEditMode then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    local Anchor = self.OwnerWidget and self.OwnerWidget:GetMenuAnchor()
    if IsValid(Anchor) then
      Anchor:Close()
    end
    self:ExecuteFunc(FuncId)
    return
  end
  if not self.SelectedSlot then
    return
  end
  local Cfg = self.EditSlotConfig
  if Cfg[self.SelectedSlot] == FuncId then
    return
  end
  local OtherSlot = 1 == self.SelectedSlot and 2 or 1
  if Cfg[OtherSlot] == FuncId then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_uncheck", nil, nil)
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_HUD_LeftBtnFold_Toast01"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_checkbox_check", nil, nil)
  Cfg[self.SelectedSlot] = FuncId
  self:RefreshListEdit()
  if self.OwnerWidget and type(self.OwnerWidget.OnEditSlotPreview) == "function" then
    self.OwnerWidget:OnEditSlotPreview(self.EditSlotConfig, self.SelectedSlot)
  end
end

function M:ExecuteFunc(FuncId)
  local OwnerPanel = self.OwnerWidget and self.OwnerWidget.OwnerPanel
  local Player = OwnerPanel and OwnerPanel.OwnerPlayer
  if not IsValid(Player) then
    return
  end
  if 1 == FuncId then
    Player:SetAutoAttackEnabled(not Player:IsAutoAttackEnabled())
  elseif 2 == FuncId then
    Player:SetAutoShootEnabled(not Player:IsAutoShootEnabled())
  elseif 3 == FuncId then
    OwnerPanel:TryToPlayTargetCommand("SwitchCrouch", false)
    OwnerPanel:TryToStopTargetCommand("SwitchCrouch", false)
  elseif 4 == FuncId then
    OwnerPanel:TryToPlayTargetCommand("SwitchWalk", false)
    OwnerPanel:TryToStopTargetCommand("SwitchWalk", false)
  elseif 5 == FuncId then
    local BattleMain = UIManager():GetUIObj("BattleMain")
    if BattleMain then
      BattleMain:OpenAppearanceGestureGruop()
    end
  end
end

function M:OnConfirmClicked()
  if self.OwnerWidget and type(self.OwnerWidget.OnSlotConfigSaved) == "function" then
    self.OwnerWidget:OnSlotConfigSaved(self.EditSlotConfig)
  end
end

function M:Destruct()
  if IsValid(self.OwnerWidget) then
    local Anchor = self.OwnerWidget:GetMenuAnchor()
    if IsValid(Anchor) then
      Anchor:SetUseApplicationMenuStack(true)
    end
  end
end

AssembleComponents(M)
return M
