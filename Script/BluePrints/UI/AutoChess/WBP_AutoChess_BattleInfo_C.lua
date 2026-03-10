require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
end

function M:OnLoaded(...)
end

function M:InitUI()
  AudioManager(self):PlayUISound(self, "event:/ui/roguelike/affix_info_panel_show", "BattleInfoSound", nil)
  self.Key01:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
  self.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "Esc"}
    },
    Desc = GText("UI_BACK")
  })
  self:InitText()
  self:InitData()
  self:InitBtn()
  self:InitDeviceInfo()
  self:PlayAnimation(self.In)
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.NavigateWidget = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetNavigateWidget()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
    self.Key_Back:SetVisibility(ESlateVisibility.Visible)
  else
    self.Key_Back:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:InitText()
  self.Text_Title:SetText(GText("UI_AutoChess_StatisticsTitle"))
  self.Text_Monster:SetText(GText("UI_AutoChess_StatisticsMonster"))
  self.Text_Damage:SetText(GText("UI_AutoChess_StatisticsATK"))
  self.Text_Injured:SetText(GText("UI_AutoChess_StatisticsDEF"))
  self.Text_Heal:SetText(GText("UI_AutoChess_StatisticsHEAL"))
  self.Text_Tip:SetText(GText("UI_Armory_ClickEmpty"))
end

function M:InitData()
  self.BattleInfo = GWorld.GameInstance.CombatData.AutoChessBattleInfo
  local MonstersData = DataMgr.Monster
  self.MyChessBattleInfo = {}
  local TotalDamage = 0
  local TotalDamaged = 0
  local TotalHeal = 0
  for Eid, Info in pairs(self.BattleInfo.Ally) do
    if Info.UnitId then
      TotalDamage = TotalDamage + (Info.Damage or 0)
      TotalDamaged = TotalDamaged + (Info.Damaged or 0)
      TotalHeal = TotalHeal + (Info.Heal or 0)
      local MonsterInfo = MonstersData[Info.UnitId]
      local ChessInfo = {
        Eid = Eid,
        UnitId = Info.UnitId,
        Damage = Info.Damage or 0,
        Damaged = Info.Damaged or 0,
        Heal = Info.Heal or 0,
        Name = MonsterInfo and MonsterInfo.UnitName,
        Icon = self:GetIconPath(Info.UnitId)
      }
      table.insert(self.MyChessBattleInfo, ChessInfo)
    end
  end
  table.sort(self.MyChessBattleInfo, function(a, b)
    if a.Damage ~= b.Damage then
      return a.Damage > b.Damage
    end
    if a.Damaged ~= b.Damaged then
      return a.Damaged > b.Damaged
    end
    if a.Heal ~= b.Heal then
      return a.Heal > b.Heal
    end
    return a.Eid > b.Eid
  end)
  self.List_Value:ClearChildren()
  for Index, ChessInfo in ipairs(self.MyChessBattleInfo) do
    local BattleInfoItem = UIManager(self):_CreateWidgetNew("AutoChessBattleInfoItem")
    local Content = {}
    Content.Eid = ChessInfo.Eid
    Content.Name = ChessInfo.Name
    Content.Damage = ChessInfo.Damage
    Content.Damaged = ChessInfo.Damaged
    Content.Heal = ChessInfo.Heal
    Content.UnitId = ChessInfo.UnitId
    Content.Icon = ChessInfo.Icon
    Content.TotalDamage = TotalDamage
    Content.TotalDamaged = TotalDamaged
    Content.TotalHeal = TotalHeal
    Content.Owner = self
    Content.Index = Index
    self.List_Value:AddChild(BattleInfoItem)
    BattleInfoItem:InitWidgetItem(Content)
  end
  self.List_Value:SetScrollBarVisibility(ESlateVisibility.Collapsed)
  self.List_Value:SetControlScrollbarInside(false)
end

function M:SetParent(Parent)
  self.Parent = Parent
end

function M:GetIconPath(UnitId)
  local ChessData = DataMgr.CombatChessInfo
  for ChessId, Data in pairs(ChessData) do
    if Data.FriendMonsterUnitId == UnitId then
      return Data.MonsterIcon
    end
  end
end

function M:InitBtn()
  self.Btn_Close.OnClicked:Add(self, self.TryClose)
end

function M:SwitchPanelUI(CurInputDeviceType)
  if CurInputDeviceType == ECommonInputType.Gamepad then
    self.WS_Type:SetActiveWidgetIndex(1)
  else
    self.WS_Type:SetActiveWidgetIndex(0)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Right" == InKeyName or "Escape" == InKeyName then
    if not self:IsAnimationPlaying(self.Auto_In) then
      if self.Parent then
        self.Parent.BattleInfoUI = nil
        self.Parent:SetFocus()
      end
      self:TryClose()
    end
    return true
  end
  return false
end

function M:TryClose()
  AudioManager(self):SetEventSoundParam(self, "BattleInfoSound", {ToEnd = 1})
  AudioManager(self):StopSound(self, "BattleInfoSound")
  self:Close()
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  self.List_Value:SetFocus()
  self.List_Value:SetSelectItemIndex(0)
  return true
end

function M:OnFocusLost(InFocusEvent)
end

return M
