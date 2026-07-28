require("UnLua")
local EMCache = require("EMCache.EMCache")
local MiscUtils = require("Utils.MiscUtils")
local BattleLeftBtnFuncConst = require("BluePrints.UI.UI_Phone.Battle.BattleLeftBtnFuncConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
M._components = {
  "BluePrints.UI.UI_Phone.Battle.Component.DraggableWidgetComponent"
}
local FUNC_LIST = BattleLeftBtnFuncConst.FUNC_LIST
local SETTING_PANEL_PATH = "/Game/UI/WBP/Battle/Mobile/Unit/WBP_Battle_LeftBtnSetting.WBP_Battle_LeftBtnSetting_C"
local FuncWidgetClasses = {}

local function GetFuncWidgetClass(FuncId)
  if not FuncWidgetClasses[FuncId] then
    local Info = FUNC_LIST[FuncId]
    if Info then
      FuncWidgetClasses[FuncId] = MiscUtils.LazyLoadClass(Info.path, true)
    end
  end
  local Wrap = FuncWidgetClasses[FuncId]
  return Wrap and Wrap:get()
end

local SettingPanelClassWrap

local function GetSettingPanelClass()
  if not SettingPanelClassWrap then
    SettingPanelClassWrap = MiscUtils.LazyLoadClass(SETTING_PANEL_PATH, true)
  end
  return SettingPanelClassWrap and SettingPanelClassWrap:get()
end

local function IsFuncActive(FuncId, Player)
  if not IsValid(Player) then
    return false
  end
  if 1 == FuncId then
    return Player:IsAutoAttackEnabled()
  end
  if 2 == FuncId then
    return Player:IsAutoShootEnabled()
  end
  if 3 == FuncId then
    return Player:CharacterInTag("Crouch")
  end
  if 4 == FuncId then
    local AnimInst = Player.PlayerAnimInstance
    return nil ~= AnimInst and AnimInst.IsWalking == true
  end
  return false
end

local CACHE_KEY = "LeftBtnSlotConfig"
local DEFAULT_CONFIG = {2, 3}
local BLUEPRINT_CONFIG = {2, 1}
local SOUND_NAME_EXPAND = "LeftBtnSetting_Expand"
local FUNC_WIDGET_FIELDS = {
  [1] = "AutoBattle",
  [2] = "AutoRemote",
  [3] = "Squat",
  [4] = "Walk",
  [5] = "Movement"
}

local function GetSlotWidget(self, SlotIndex)
  local Slot = 1 == SlotIndex and self.Slot1 or self.Slot2
  if not IsValid(Slot) then
    return nil
  end
  return Slot:GetChildAt(0)
end

function M:PlaySlotAnim(SlotIndex, AnimKey)
  local Widget = GetSlotWidget(self, SlotIndex)
  if not IsValid(Widget) then
    return
  end
  local Anim = Widget[AnimKey]
  if Anim then
    EMUIAnimationSubsystem:EMPlayAnimation(Widget, Anim)
  end
end

function M:Construct()
  if not IsValid(self.Slot1) then
    self.Slot1 = self.AutoRemote:GetParent()
  end
  if not IsValid(self.Slot2) then
    self.Slot2 = self.AutoBattle:GetParent()
  end
  local Config = EMCache:Get(CACHE_KEY, true) or DEFAULT_CONFIG
  self.SlotConfig = {
    Config[1],
    Config[2]
  }
  if not self.bSlotsBuilt then
    self.bSlotsBuilt = true
    if Config[1] ~= BLUEPRINT_CONFIG[1] or Config[2] ~= BLUEPRINT_CONFIG[2] then
      self:RebuildSlots(Config)
    else
      self:BindEditHandler(self.AutoRemote, 1)
      self:BindEditHandler(self.AutoBattle, 2)
    end
  else
    self:RebuildSlots(Config)
  end
  if self.Set then
    EMUIAnimationSubsystem:EMPlayAnimation(self.Set, self.Set.Normal)
    if self.Set.Button_Area then
      self.Set.Button_Area.OnClicked:Add(self, self.OnSettingBtnClicked)
    end
  end
end

function M:Destruct()
  local Anchor = self:GetMenuAnchor()
  if IsValid(Anchor) then
    Anchor.OnGetMenuContentEvent:Unbind()
    Anchor.OnMenuOpenChanged:Remove(self, self.OnSettingMenuOpenChanged)
  end
  if self.SettingJustClosedTimer then
    self:RemoveTimer(self.SettingJustClosedTimer)
    self.SettingJustClosedTimer = nil
  end
  self.SettingPanelWidget = nil
end

function M:RebuildSlots(Config)
  self:SetSlotWidget(self.Slot1, Config[1])
  self:SetSlotWidget(self.Slot2, Config[2])
  if self.OwnerPanel and type(self.OwnerPanel.SyncAutoCombatVisual) == "function" then
    self.OwnerPanel:SyncAutoCombatVisual()
  end
end

function M:SetSlotWidget(SlotContainer, FuncId)
  if not IsValid(SlotContainer) then
    return
  end
  local WidgetClass = GetFuncWidgetClass(FuncId)
  if not WidgetClass then
    DebugPrint("[LeftBtn_M] 未找到 FuncId=%d 对应的蓝图类", FuncId)
    return
  end
  local NewWidget = UIManager(self):CreateWidget(WidgetClass)
  if not IsValid(NewWidget) then
    DebugPrint("[LeftBtn_M] CreateWidget 失败, FuncId=%d", FuncId)
    return
  end
  local Old = SlotContainer:GetChildAt(0)
  if IsValid(Old) then
    Old:RemoveFromParent()
  end
  if self.OwnerPanel then
    NewWidget.OwnerPanel = self.OwnerPanel
    NewWidget.OwnerPlayer = self.OwnerPanel.OwnerPlayer
  end
  SlotContainer:AddChild(NewWidget)
  local FieldName = FUNC_WIDGET_FIELDS[FuncId]
  if FieldName then
    self[FieldName] = NewWidget
  end
  local SlotIndex = SlotContainer == self.Slot1 and 1 or 2
  self:BindEditHandler(NewWidget, SlotIndex)
end

function M:BindEditHandler(Widget, SlotIndex)
  if not IsValid(Widget) then
    return
  end
  Widget.OwnerLeftBtn = self
  if Widget.Button_Area then
    local Handler = 1 == SlotIndex and self.OnEditSlot1BtnPressed or self.OnEditSlot2BtnPressed
    Widget.Button_Area.OnClicked:Add(self, Handler)
  end
end

function M:OnEditSlot1BtnPressed()
  if not self.bEditModeActive then
    return
  end
  self:NotifySlotClicked(1)
end

function M:OnEditSlot2BtnPressed()
  if not self.bEditModeActive then
    return
  end
  self:NotifySlotClicked(2)
end

function M:NotifySlotClicked(SlotIndex, bSilent)
  if self.CurrentSelectedSlot == SlotIndex then
    return
  end
  if not bSilent then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  end
  if self.CurrentSelectedSlot then
    self:PlaySlotAnim(self.CurrentSelectedSlot, "Normal")
  end
  self.CurrentSelectedSlot = SlotIndex
  self:PlaySlotAnim(SlotIndex, "Click")
  if IsValid(self.SettingPanelWidget) and type(self.SettingPanelWidget.OnSlotSelected) == "function" then
    self.SettingPanelWidget:OnSlotSelected(SlotIndex)
  end
end

function M:SyncSlotAnims()
  local Player = self.OwnerPanel and self.OwnerPanel.OwnerPlayer
  for SlotIndex = 1, 2 do
    local FuncId = self.SlotConfig[SlotIndex]
    local AnimKey = IsFuncActive(FuncId, Player) and "Using" or "Normal"
    self:PlaySlotAnim(SlotIndex, AnimKey)
  end
end

function M:PlaySlotChangeAnim(SlotIndex)
  local Widget = GetSlotWidget(self, SlotIndex)
  if not IsValid(Widget) or not Widget.Change then
    return
  end
  Widget:UnbindAllFromAnimationFinished(Widget.Change)
  Widget:BindToAnimationFinished(Widget.Change, function()
    Widget:UnbindAllFromAnimationFinished(Widget.Change)
    if IsValid(Widget) and Widget.Click and self.CurrentSelectedSlot == SlotIndex then
      EMUIAnimationSubsystem:EMPlayAnimation(Widget, Widget.Click)
    end
  end)
  EMUIAnimationSubsystem:EMPlayAnimation(Widget, Widget.Change)
end

function M:GetMenuAnchor()
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  return BattleMainUI and BattleMainUI.BtnSetting_MenuAnchor
end

function M:InitMenuAnchor()
  local Anchor = self:GetMenuAnchor()
  if not IsValid(Anchor) then
    return
  end
  Anchor.OnGetMenuContentEvent:Unbind()
  Anchor.OnMenuOpenChanged:Remove(self, self.OnSettingMenuOpenChanged)
  Anchor.OnGetMenuContentEvent:Bind(self, self.OnGetMenuContent)
  Anchor.OnMenuOpenChanged:Add(self, self.OnSettingMenuOpenChanged)
  self.bSettingJustClosed = nil
  self.bAnchorWasOpen = nil
end

function M:OnSettingBtnClicked()
  local Anchor = self:GetMenuAnchor()
  if not IsValid(Anchor) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  if Anchor:IsOpen() then
    self:RequestClose()
    return
  end
  if self.bSettingJustClosed then
    self.bSettingJustClosed = nil
    return
  end
  self:InitMenuAnchor()
  Anchor:Open(true)
end

function M:OnGetMenuContent()
  if self.bReopeningForEditMode and IsValid(self.SettingPanelWidget) then
    return self.SettingPanelWidget
  end
  local WidgetClass = GetSettingPanelClass()
  if not WidgetClass then
    return nil
  end
  self.SettingPanelWidget = UIManager(self):CreateWidget(WidgetClass)
  if not IsValid(self.SettingPanelWidget) then
    return nil
  end
  self.SettingPanelWidget:OpenPanel(self, self.SlotConfig)
  return self.SettingPanelWidget
end

function M:OnSettingMenuOpenChanged(bIsOpen)
  if self.Set then
    if bIsOpen then
      EMUIAnimationSubsystem:EMPlayAnimation(self.Set, self.Set.Setting)
    elseif not self.bReopeningForEditMode then
      EMUIAnimationSubsystem:EMPlayAnimation(self.Set, self.Set.Normal)
    end
  end
  if bIsOpen then
    self.bPanelOpen = true
    if self.bReopeningForEditMode then
      self.bReopeningForEditMode = nil
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Setting)
      self:PlaySlotAnim(2, "Normal")
      self:NotifySlotClicked(1, true)
    else
      AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", SOUND_NAME_EXPAND, nil)
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.Use)
      self:PlaySlotAnim(1, "Normal")
      self:PlaySlotAnim(2, "Normal")
      if IsValid(self.SettingPanelWidget) and self.SettingPanelWidget.In then
        EMUIAnimationSubsystem:EMPlayAnimation(self.SettingPanelWidget, self.SettingPanelWidget.In)
      end
    end
  elseif not self.bReopeningForEditMode then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.Normal)
  end
  if not bIsOpen then
    if self.bReopeningForEditMode then
      return
    end
    AudioManager(self):SetEventSoundParam(self, SOUND_NAME_EXPAND, {ToEnd = 1})
    if self.bEditModeActive then
      self:RebuildSlots(self.SlotConfig)
    end
    self.bEditModeActive = nil
    self.bPanelOpen = nil
    self:SyncSlotAnims()
    if self.bAnchorWasOpen then
      self.bSettingJustClosed = true
      if self.SettingJustClosedTimer then
        self:RemoveTimer(self.SettingJustClosedTimer)
      end
      self.SettingJustClosedTimer = self:AddTimer(0.2, function()
        if IsValid(self) then
          self.bSettingJustClosed = false
        end
      end, false)
    end
    self.bAnchorWasOpen = nil
    self.SettingPanelWidget = nil
  else
    self.bSettingJustClosed = nil
    self.bAnchorWasOpen = true
  end
end

function M:RequestClose()
  local Anchor = self:GetMenuAnchor()
  if not IsValid(Anchor) or not Anchor:IsOpen() then
    return
  end
  local Widget = self.SettingPanelWidget
  if IsValid(Widget) and Widget.Out then
    AudioManager(self):SetEventSoundParam(self, SOUND_NAME_EXPAND, {ToEnd = 1})
    Widget:UnbindAllFromAnimationFinished(Widget.Out)
    Widget:BindToAnimationFinished(Widget.Out, function()
      Widget:UnbindAllFromAnimationFinished(Widget.Out)
      local A = self:GetMenuAnchor()
      if IsValid(A) and A:IsOpen() then
        A:Close()
      end
    end)
    EMUIAnimationSubsystem:EMPlayAnimation(Widget, Widget.Out)
  else
    Anchor:Close()
  end
end

function M:OnEnterEditMode()
  local Anchor = self:GetMenuAnchor()
  if not IsValid(Anchor) then
    return
  end
  self.bReopeningForEditMode = true
  self.bEditModeActive = true
  self.CurrentSelectedSlot = nil
  Anchor:Close()
  Anchor:SetUseApplicationMenuStack(false)
  Anchor:Open(true)
end

function M:OnEditSlotPreview(Config, SelectedSlot)
  self:SetSlotWidget(self.Slot1, Config[1])
  self:SetSlotWidget(self.Slot2, Config[2])
  if SelectedSlot then
    local OtherSlot = 1 == SelectedSlot and 2 or 1
    self:PlaySlotChangeAnim(SelectedSlot)
    self:PlaySlotAnim(OtherSlot, "Normal")
  end
end

function M:OnSlotConfigSaved(Config)
  if not Config then
    return
  end
  self.SlotConfig = {
    Config[1],
    Config[2]
  }
  EMCache:Set(CACHE_KEY, self.SlotConfig, true)
  self.bEditModeActive = nil
  self:RebuildSlots(self.SlotConfig)
  self:SyncSlotAnims()
  self:RequestClose()
end

AssembleComponents(M)
local _OrigSetDraggable = M.SetDraggable

function M:SetDraggable(bEnabled)
  local vis = bEnabled and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Visible
  for _, slot in ipairs({
    self.Slot1,
    self.Slot2
  }) do
    if IsValid(slot) then
      local w = slot:GetChildAt(0)
      if IsValid(w) and IsValid(w.Button_Area) then
        w.Button_Area:SetVisibility(vis)
      end
    end
  end
  if _OrigSetDraggable then
    _OrigSetDraggable(self, bEnabled)
  end
end

return M
