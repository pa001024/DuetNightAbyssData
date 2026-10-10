require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize(Initializer)
end

function M:Construct()
  self:SetKeyMap(true)
  self.Anchor:ClearChildren()
  self.ExecuteItems = {}
  self.RecycleExecuteItem = {}
  self.PendingExecuteItems = {}
  self.TargetWidget = nil
  self.TargetCharacter = nil
end

function M:RefreshOpInfoByInputDevice()
  for _, Widget in pairs(self.ExecuteItems) do
    Widget:RefreshInfoByDevice()
  end
end

function M:InitDefeatedCharacter(InCharacter)
  if self.ExecuteItems[InCharacter] or self.PendingExecuteItems[InCharacter] then
    return
  end
  if 0 == #self.RecycleExecuteItem then
    local PendingRequest = {}
    self.PendingExecuteItems[InCharacter] = PendingRequest
    UIManager(self):CreateWidgetAsync("ExecuteItem", function(Widget)
      if not IsValid(self) or self.PendingExecuteItems[InCharacter] ~= PendingRequest then
        return
      end
      self.PendingExecuteItems[InCharacter] = nil
      if not (IsValid(InCharacter) and Widget) or self.ExecuteItems[InCharacter] then
        self:TryCloseIfExecuteItemsEmpty()
        return
      end
      Widget:InitDefeatedCharacter(InCharacter, self)
      self.Anchor:AddChild(Widget)
      self.ExecuteItems[InCharacter] = Widget
    end)
  else
    local Widget = self.RecycleExecuteItem[#self.RecycleExecuteItem]
    table.remove(self.RecycleExecuteItem, #self.RecycleExecuteItem)
    Widget:InitDefeatedCharacter(InCharacter, self)
    self.ExecuteItems[InCharacter] = Widget
  end
end

function M:IsExecuteItemEmpty()
  return not next(self.ExecuteItems or {}) and not next(self.PendingExecuteItems or {})
end

function M:TryCloseIfExecuteItemsEmpty()
  if self:IsExecuteItemEmpty() then
    self:Close()
  end
end

function M:Tick(MyGeometry, InDeltaTime)
  for _, Widget in pairs(self.ExecuteItems) do
    Widget:UpdateScreenLocation(InDeltaTime)
  end
end

function M:SetKeyMap(IsSet)
  if IsSet == self.IsSetedKeyMap then
    return
  end
  self.IsSetedKeyMap = IsSet
  if IsSet then
    self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {
      self,
      self.PressedSelectAction
    })
    self:ListenForInputAction("Interactive", EInputEvent.IE_Released, true, {
      self,
      self.ReleasedSelectAction
    })
  else
    self:StopListeningForAllInputActions()
  end
end

function M:OnClick()
  self:PressedSelectAction()
  self:ReleasedSelectAction()
end

function M:ChangeUIDefeatedState(DefeatedCharacter, bCanExecute)
  if not self.ExecuteItems or not self.ExecuteItems[DefeatedCharacter] then
    return
  end
  self.ExecuteItems[DefeatedCharacter]:ChangeUIDefeatedState(bCanExecute)
end

function M:PressedSelectAction()
  local Role = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Role then
    return
  end
  local TargetWidget, Distance
  for Character, Widget in pairs(self.ExecuteItems) do
    if Widget.bCanExecute then
      if not TargetWidget then
        TargetWidget = Widget
        Distance = UE4.UKismetMathLibrary.Vector_Distance(Role:K2_GetActorLocation(), Character:K2_GetActorLocation())
      else
        local Dist = UE4.UKismetMathLibrary.Vector_Distance(Role:K2_GetActorLocation(), Character:K2_GetActorLocation())
        if Distance > Dist then
          Distance = Dist
          TargetWidget = Widget
        end
      end
    end
  end
  self.TargetWidget = TargetWidget
  self.TargetCharacter = TargetWidget and TargetWidget.DefeatedCharacter
  if TargetWidget then
    TargetWidget:PressedSelectAction()
  end
end

function M:ReleasedSelectAction()
  local TargetWidget = self.TargetWidget
  local TargetCharacter = self.TargetCharacter
  self.TargetWidget = nil
  self.TargetCharacter = nil
  if not TargetWidget then
    return
  end
  local IsActiveTarget = TargetCharacter and TargetWidget.DefeatedCharacter == TargetCharacter and self.ExecuteItems and self.ExecuteItems[TargetCharacter] == TargetWidget
  if IsActiveTarget then
    TargetWidget:ReleasedSelectAction()
  end
end

function M:CloseExecuteItem(DefeatedCharacter)
  self.PendingExecuteItems[DefeatedCharacter] = nil
  local Widget = self.ExecuteItems and self.ExecuteItems[DefeatedCharacter]
  if not Widget then
    self:TryCloseIfExecuteItemsEmpty()
    return
  end
  Widget:ChangeUIDefeatedState(false)
  self:RecycleExecuteWidget(DefeatedCharacter)
end

function M:RemoveExecuteItem(DefeatedCharacter, BtnAnim)
  self.PendingExecuteItems[DefeatedCharacter] = nil
  if not self.ExecuteItems or not self.ExecuteItems[DefeatedCharacter] then
    self:TryCloseIfExecuteItemsEmpty()
    return
  end
  local Widget = self.ExecuteItems[DefeatedCharacter]
  Widget:StopAllAnimations()
  Widget:PlayAnimation(Widget[BtnAnim])
  Widget:TryShowPhoneUI(false)
end

function M:RecycleExecuteWidget(DefeatedCharacter)
  self.PendingExecuteItems[DefeatedCharacter] = nil
  if not self.ExecuteItems or not self.ExecuteItems[DefeatedCharacter] then
    self:TryCloseIfExecuteItemsEmpty()
    return
  end
  local ExecuteWidget = self.ExecuteItems[DefeatedCharacter]
  if self.TargetWidget == ExecuteWidget then
    self.TargetWidget = nil
    self.TargetCharacter = nil
  end
  if not ExecuteWidget:PrepareForRecycle() then
    return
  end
  ExecuteWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ExecuteItems[DefeatedCharacter] = nil
  table.insert(self.RecycleExecuteItem, ExecuteWidget)
  self:TryCloseIfExecuteItemsEmpty()
end

function M:ClosePhoneUI()
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    return
  end
  local BattleMainUI = UIManager(self):GetUIObj("BattleMain")
  if not BattleMainUI or not BattleMainUI.Char_Skill then
    return
  end
  local PhoneExecute = BattleMainUI.Char_Skill.Execute
  PhoneExecute:DirectlyClose()
end

function M:Close()
  for _, Widget in pairs(self.ExecuteItems or {}) do
    Widget:PrepareForRecycle()
  end
  self.TargetWidget = nil
  self.TargetCharacter = nil
  self.Anchor:ClearChildren()
  self.ExecuteItems = {}
  self.RecycleExecuteItem = {}
  self.PendingExecuteItems = {}
  self:ClosePhoneUI()
  self.Super.Close(self)
end

return M
