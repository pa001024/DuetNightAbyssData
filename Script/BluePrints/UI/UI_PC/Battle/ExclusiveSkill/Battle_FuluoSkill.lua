require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")
local DEFAULT_A_BUFF_ID = 110231
local DEFAULT_B_BUFF_ID = 110221
local DEFAULT_ULTIMATE_BUFF_ID = 110202
local DEFAULT_MAX_A = 42
local DEFAULT_MAX_B = 12
local SECTION_THRESHOLD = 6
local GRAY_DELAY = 2
local GRAY_TIMER_NAME = "FuluoGrayDelay"
local SECTION_NAMES = {
  "Section",
  "Section_1",
  "Section_2",
  "Section_3",
  "Section_4",
  "Section_5",
  "Section_6",
  "Section_7",
  "Section_8",
  "Section_9",
  "Section_10",
  "Section_11"
}

local function TryPlayAnimation(Widget, Animation, Reason)
  if not Widget or not Animation then
    return
  end
  DebugPrint("lgc@Battle_FuluoSkill", "PlayAnimation", Reason)
  EMUIAnimationSubsystem:EMPlayAnimation(Widget, Animation)
end

local function StopAnimation(Widget, Animation)
  if Widget and Animation then
    EMUIAnimationSubsystem:EMStopAnimation(Widget, Animation)
  end
end

function M:OnLoaded(OwnerPlayer, Params)
  self.Super.OnLoaded(self, OwnerPlayer, Params)
  Params = Params or {}
  self.Owner = OwnerPlayer
  self.ResourceABuffId = Params.ResourceABuffId or Params.BuffIdA or DEFAULT_A_BUFF_ID
  self.ResourceBBuffId = Params.ResourceBBuffId or Params.BuffIdB or DEFAULT_B_BUFF_ID
  self.UltimateBuffId = Params.UltimateBuffId or DEFAULT_ULTIMATE_BUFF_ID
  self.MaxA = Params.MaxA or self:GetBuffMaxLayer(self.ResourceABuffId) or DEFAULT_MAX_A
  self.MaxB = math.min(Params.MaxB or self:GetBuffMaxLayer(self.ResourceBBuffId) or DEFAULT_MAX_B, #SECTION_NAMES)
  if not self.SectionWidgets or 0 == #self.SectionWidgets then
    self.SectionWidgets = {}
    for _, Name in ipairs(SECTION_NAMES) do
      if self[Name] then
        table.insert(self.SectionWidgets, self[Name])
      end
    end
  end
  self.SectionStateMap = {}
  self.LastState = nil
  self:InitBuffListening(OwnerPlayer)
  self:StopTrackedAnimations()
  self:UpdateNumber(0)
  self:SetSectionCount(0)
  local InitialState = self:BuildState()
  self:ApplyState(nil, InitialState)
  self.LastState = InitialState
  TryPlayAnimation(self, self.In, "UI enter")
  self:SetForbiddenState(true)
end

function M:ReceiveOnBuffsChanged()
  if IsValid(self.Owner) then
    self:RefreshState()
  end
end

function M:Destruct()
  self:StopTrackedAnimations()
  self:FlushAnimations()
  self.Super.Destruct(self)
end

function M:GetBuffMaxLayer(BuffId)
  if DataMgr and DataMgr.Buff and DataMgr.Buff[BuffId] then
    return DataMgr.Buff[BuffId].MaxLayer
  end
end

function M:InitBuffListening(OwnerPlayer)
  local HasSetOwner = type(self.K2_SetBuffsOwner) == "function"
  local HasRegisterDelegate = "function" == type(self.RegisterOnBuffsChangedDelegate)
  if HasSetOwner then
    self:K2_SetBuffsOwner(OwnerPlayer)
  end
  if HasRegisterDelegate then
    self:RegisterOnBuffsChangedDelegate()
  end
  self.UseBuffPolling = not HasSetOwner or not HasRegisterDelegate
end

function M:RefreshState()
  local NewState = self:BuildState()
  if self.LastState and self.LastState.A == NewState.A and self.LastState.B == NewState.B and self.LastState.IsInUltimate == NewState.IsInUltimate then
    return
  end
  self:ApplyState(self.LastState, NewState)
  self.LastState = NewState
end

function M:BuildState()
  local ABuff = self:FindBuff(self.ResourceABuffId)
  local BBuff = self:FindBuff(self.ResourceBBuffId)
  local UltimateBuff = self:FindBuff(self.UltimateBuffId)
  return {
    A = math.max(ABuff and ABuff.Layer or 0, 0),
    B = math.max(math.min(BBuff and BBuff.Layer or 0, self.MaxB), 0),
    IsInUltimate = nil ~= UltimateBuff
  }
end

function M:FindBuff(BuffId)
  if not (IsValid(self.Owner) and self.Owner.BuffManager) or not self.Owner.BuffManager.Buffs then
    return nil
  end
  local Buffs = self.Owner.BuffManager.Buffs
  local Count = 0
  if type(Buffs.Length) == "function" and "function" == type(Buffs.GetRef) then
    Count = Buffs:Length()
  elseif "function" == type(Buffs.Num) and "function" == type(Buffs.GetRef) then
    Count = Buffs:Num()
  end
  if Count > 0 and "function" == type(Buffs.GetRef) then
    for Index = 1, Count do
      local Buff = Buffs:GetRef(Index)
      if IsValid(Buff) and Buff.BuffId == BuffId then
        return Buff
      end
    end
    return nil
  end
  for _, Buff in pairs(Buffs) do
    if IsValid(Buff) and Buff.BuffId == BuffId then
      return Buff
    end
  end
  return nil
end

function M:ApplyState(OldState, NewState)
  if not NewState then
    return
  end
  self:UpdateNumber(NewState.A or 0)
  local OldA = OldState and OldState.A or 0
  local OldB = OldState and OldState.B or 0
  local NewA = NewState.A
  local NewB = NewState.B
  local IsAToB = OldState and NewState.IsInUltimate and OldA > NewA and OldB < NewB
  local IsBConsumed = OldState and OldB > NewB
  local IsUltimateChanged = OldState and OldState.IsInUltimate ~= NewState.IsInUltimate
  local IsAIncreased = OldState and OldA < NewA
  local ReachedB12 = OldB < self.MaxB and NewB >= self.MaxB
  local ReachedB6 = OldB < SECTION_THRESHOLD and NewB >= SECTION_THRESHOLD and NewB < self.MaxB
  if IsAToB then
    TryPlayAnimation(self, self.A_Reduce, "A to B")
  end
  if IsBConsumed then
    TryPlayAnimation(self, self.B_Used, "B consumed")
  end
  self:SetSectionCount(NewB or 0, NewState.IsInUltimate)
  if ReachedB12 then
    TryPlayAnimation(self, self.B_12, "B reached 12")
  elseif ReachedB6 then
    TryPlayAnimation(self, self.B_6, "B reached 6")
  end
  if IsAIncreased and not IsAToB and not IsBConsumed then
    TryPlayAnimation(self, self.A_Add, "A increased")
  end
  if NewState.A > 0 then
    self:ClearGrayDelayTimer()
    if self.IsForbidden then
      self:SetForbiddenState(false)
    end
  elseif OldState and OldState.A > 0 and NewState.A <= 0 then
    self:StartGrayDelayTimer()
  end
end

function M:ClearGrayDelayTimer()
  if IsValid(self.Owner) and type(self.Owner.RemoveTimer) == "function" then
    self.Owner:RemoveTimer(GRAY_TIMER_NAME)
  end
end

function M:StartGrayDelayTimer()
  if not IsValid(self.Owner) or type(self.Owner.AddTimer) ~= "function" then
    return
  end
  self.Owner:RemoveTimer(GRAY_TIMER_NAME)
  self.Owner:AddTimer(GRAY_DELAY, function()
    if not IsValid(self) or not self.LastState then
      return
    end
    if not self.LastState.IsInUltimate and self.LastState.A <= 0 and not self.IsForbidden then
      self:SetForbiddenState(true)
    end
  end, false, 0, GRAY_TIMER_NAME)
end

function M:UpdateNumber(Value)
  if self.Num_Fuluo then
    self.Num_Fuluo:SetText(tostring(math.floor(Value or 0)))
  end
end

function M:SetSectionCount(Count, bPlayAnim)
  local ClampedCount = math.max(math.min(Count or 0, self.MaxB), 0)
  for Index, SectionWidget in ipairs(self.SectionWidgets or {}) do
    self:SetSectionState(SectionWidget, Index <= ClampedCount, bPlayAnim)
  end
end

function M:SetSectionState(SectionWidget, IsOn, IsPlayAnim)
  if not SectionWidget then
    return
  end
  local WidgetName = SectionWidget.GetName and SectionWidget:GetName() or tostring(SectionWidget)
  local PrevIsOn = self.SectionStateMap[WidgetName] or false
  local PanelOn = SectionWidget.Panel_On or SectionWidget.PanelOn or SectionWidget.panel_on or SectionWidget.panelon
  local PanelOff = SectionWidget.Panel_Off or SectionWidget.PanelOff or SectionWidget.panel_off or SectionWidget.paneloff
  if not PanelOn or not PanelOff then
    return
  end
  if IsPlayAnim then
    if not PrevIsOn and IsOn then
      PanelOn:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      PanelOff:SetVisibility(ESlateVisibility.Collapsed)
      TryPlayAnimation(SectionWidget, SectionWidget.In, "Section lit: " .. tostring(WidgetName))
    elseif PrevIsOn and not IsOn then
      TryPlayAnimation(SectionWidget, SectionWidget.Use, "Section out: " .. tostring(WidgetName))
    end
  else
    PanelOn:SetVisibility(IsOn and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
    PanelOff:SetVisibility(IsOn and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
  end
  self.SectionStateMap[WidgetName] = IsOn
end

function M:SetForbiddenState(IsForbidden, IsInit)
  if self.IsForbidden == IsForbidden and not IsInit then
    return
  end
  self.IsForbidden = IsForbidden
  if IsInit then
    return
  end
  if IsForbidden then
    TryPlayAnimation(self, self.Forbidden, "Enter forbidden")
  else
    TryPlayAnimation(self, self.Normal, "Leave forbidden")
  end
end

function M:StopTrackedAnimations()
  StopAnimation(self, self.Forbidden)
  StopAnimation(self, self.Normal)
  StopAnimation(self, self.A_Add)
  StopAnimation(self, self.A_Reduce)
  StopAnimation(self, self.B_6)
  StopAnimation(self, self.B_12)
  StopAnimation(self, self.B_Used)
end

return M
