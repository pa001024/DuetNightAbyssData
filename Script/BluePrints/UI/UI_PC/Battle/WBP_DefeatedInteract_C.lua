require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize(Initializer)
end

function M:Construct()
  self:SetKeyMap(true)
  self.Anchor:ClearChildren()
  self.ExecuteItems = {}
  self.RecycleExecuteItem = {}
end

function M:RefreshOpInfoByInputDevice()
  for _, Widget in pairs(self.ExecuteItems) do
    Widget:RefreshInfoByDevice()
  end
end

function M:InitDefeatedCharacter(InCharacter)
  if 0 == #self.RecycleExecuteItem then
    local Widget = UIManager(self):_CreateWidgetNew("ExecuteItem")
    Widget:InitDefeatedCharacter(InCharacter, self)
    self.Anchor:AddChild(Widget)
    self.ExecuteItems[InCharacter] = Widget
  else
    local Widget = self.RecycleExecuteItem[#self.RecycleExecuteItem]
    table.remove(self.RecycleExecuteItem, #self.RecycleExecuteItem)
    Widget:InitDefeatedCharacter(InCharacter, self)
    self.ExecuteItems[InCharacter] = Widget
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
  if TargetWidget then
    TargetWidget:PressedSelectAction()
  end
  self.TargetWidget = TargetWidget
end

function M:ReleasedSelectAction()
  if not self.TargetWidget then
    return
  end
  self.TargetWidget:ReleasedSelectAction()
end

function M:CloseExecuteItem(DefeatedCharacter)
  local Widget = self.ExecuteItems and self.ExecuteItems[DefeatedCharacter]
  if not Widget then
    return
  end
  Widget.IsForcedClosed = true
  Widget:StopAllAnimations()
  Widget:ChangeUIDefeatedState(false)
  Widget:HideExecuteItem()
  table.insert(self.RecycleExecuteItem, Widget)
  self.ExecuteItems[DefeatedCharacter] = nil
  Widget.IsForcedClosed = false
  local Count = CommonUtils.TableLength(self.ExecuteItems)
  if 0 == Count then
    self:Close()
  end
end

function M:RemoveExecuteItem(DefeatedCharacter, BtnAnim)
  if not self.ExecuteItems or not self.ExecuteItems[DefeatedCharacter] then
    return
  end
  local Widget = self.ExecuteItems[DefeatedCharacter]
  Widget:StopAllAnimations()
  Widget:PlayAnimation(Widget[BtnAnim])
  Widget:TryShowPhoneUI(false)
end

function M:RecycleExecuteWidget(DefeatedCharacter)
  if not self.ExecuteItems or not self.ExecuteItems[DefeatedCharacter] then
    return
  end
  local ExecuteWidget = self.ExecuteItems[DefeatedCharacter]
  ExecuteWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ExecuteItems[DefeatedCharacter] = nil
  table.insert(self.RecycleExecuteItem, ExecuteWidget)
  local Count = CommonUtils.TableLength(self.ExecuteItems)
  if 0 == Count then
    self:Close()
  end
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
  self.Anchor:ClearChildren()
  self.ExecuteItems = {}
  self.RecycleExecuteItem = {}
  self:ClosePhoneUI()
  self.Super.Close(self)
end

return M
