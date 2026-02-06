require("UnLua")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class("BluePrints.UI.BP_UIState_C")
local Const = CommonConst.AutoChess

function M:OnLoaded(...)
  self:SetText()
  self:CountGamepadOnlyUI()
  self:BindCallBack()
  self.UIManager = UGameplayStatics.GetGameInstance(self):GetGameUIManager()
  self.GameMode = UGameplayStatics.GetGameMode(self)
  if self.GameMode and self.GameMode.PreInitInfo then
    self.MissionId = self.GameMode.PreInitInfo.MissionId
  end
  self.TotalCountDownTime = self.GameMode.CountDownTime
  self.CountDownInterval = 0.01
  self.CountDownTimerName = "AutoChessMotivateCountDown"
  self.MotivateBar = self.DuelScreen.DuelBar
  self.bChessBoardFull = false
  self.ChessNum = 0
  self.TotalDeployCost = DataMgr.AutoChessMission[self.MissionId] and DataMgr.AutoChessMission[self.MissionId].DeployCost
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self.RandomFactor = Avatar.AutoChess.RandomFactor
  else
    DebugPrint("WBP_AutoChessBattlePage:OnLoaded 无法从服务端拿到RandomFactor，采用原固定费用")
  end
  if self.RandomFactor then
    self.RandomCostFactor = DataMgr.AutoChessMission[self.MissionId] and DataMgr.AutoChessMission[self.MissionId].RandomCostFactor
    if not self.RandomCostFactor then
      self.RandomCostFactor = 1
    end
    self.TotalDeployCost = self.TotalDeployCost - math.ceil(self.RandomFactor * self.RandomCostFactor)
  end
  self.UsedDeployCost = 0
  self.Text_Max:SetText(self.TotalDeployCost)
  self:UpdateDeployCost(true, 0, 0)
  self:SetInputModeCustom(true)
  self:InitButtonGamepadView()
  self:InitBuffUI()
  self:PlayAnimation(self.In)
  self.SelectChessCardId = nil
  self.SelectCubeIndex = nil
  self.SelectChessId = nil
  self.PickCubeIndex = nil
  self.bDeploying = true
  self.GamepadCubeIndex = nil
  self.bGamepadCubeEnemy = nil
  self.LastGamepadMoveTime = nil
  self:HideChessInfo()
  self.AutoChessFormation = nil
  self.Index2CubeInfo = {}
  self.Index2EnemyCubeInfo = {}
  self.EnemyChessEquips = {}
  self.CameraPawn = nil
  self.GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  self.GameInstance.bAutoChessDeploying = true
  self.bBannedEnemy = false
  self:ListenForInputAction("OpenMenu", EInputEvent.IE_Pressed, true, {
    self,
    self.ProcessExit
  })
  self:ListenForInputAction("OpenMenu", EInputEvent.IE_Released, true, {
    self,
    self.ProcessExitRelease
  })
  self.List_Chess:ClearListItems()
  local ResDeployCost = self.TotalDeployCost - self.UsedDeployCost
  local ChessDatas = Model:GetChessData()
  for _, ChessData in ipairs(ChessDatas) do
    if not ChessData.Locked then
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.Data = ChessData
      ItemContent.bInGame = true
      ItemContent.bForbidden = ResDeployCost < ChessData.TotalCost or self.bChessBoardFull
      ItemContent.InGameCost = self:GetChessCost(ChessData.Id)
      
      function ItemContent.OnBtnClickedCallback(ChessId)
        self:PlaySound("event:/ui/activity/auto_chess_icon_btn_click")
        self:SelectChessCard(ChessId, false)
      end
      
      function ItemContent.OnFocusReceivedCallback(FocusChessCardId)
        self.FocusChessCardId = FocusChessCardId
        DebugPrint("FocusChessCardId = ", self.FocusChessCardId)
      end
      
      self.List_Chess:AddItem(ItemContent)
    end
  end
  self.FocusChessCardId = ChessDatas[1].Id
  EventManager:AddEvent(EventID.OnDungeonEscClose, self, self.OnDungeonEscClose)
  self.bNoFocus = false
  self.FocusState = Const.GamepadFocusState.Focus1
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:Close()
  EventManager:RemoveEvent(EventID.OnDungeonEscClose, self)
  self:RemoveTimer(self.CountDownTimerName)
  self:StopListeningForInputAction("OpenMenu", EInputEvent.IE_Released)
  self.Super.Close(self)
end

function M:OnDungeonEscClose()
  self.bNoFocus = false
  if self.WS_Battle_Controller then
    self.WS_Battle_Controller:SetVisibility(ESlateVisibility.Visible)
  end
end

function M:BanEmemy(bFlag)
  self.bBannedEnemy = bFlag
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.BanEnemy, bFlag)
end

function M:SelectChessCard(ChessId, bNoToast)
  self:ExitChessBoard()
  local Entry = self:GetChessItemEntryByChessId(ChessId)
  if not Entry then
    return
  end
  if Entry.Content.bForbidden == true then
    self.SelectChessCardId = nil
    if not bNoToast then
      self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_NoCostToast"))
    end
    if self.UsedDeployCost > self.TotalDeployCost then
      self:PlayAnimation(self.Cost_Warning)
    else
      self:PlayAnimationReverse(self.Cost_Warning)
    end
    return
  end
  if ChessId == self.SelectChessCardId then
    Entry.Content.IsSelected = false
    Entry:SetSelected(false)
    self.SelectChessCardId = nil
    EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
    self:ShowTips(false)
    self:BanEmemy(false)
    self:HideChessInfo()
    return
  end
  if self.SelectChessCardId then
    local OldEntry = self:GetChessItemEntryByChessId(self.SelectChessCardId)
    if OldEntry then
      OldEntry.Content.IsSelected = false
      OldEntry:SetSelected(false)
    end
    local OldContent = self:GetChessItemContentByChessId(self.SelectChessCardId)
    if OldContent then
      OldContent.IsSelected = false
    end
  end
  self.SelectChessCardId = ChessId
  Entry.Content.IsSelected = true
  Entry:SetSelected(true)
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.CanPutin)
  self:ShowTips(true, Const.DeployState.Place)
  self:BanEmemy(true)
  self:ShowChessInfo(self.SelectChessCardId, false, true)
  self:SetFocusState(Const.GamepadFocusState.Focus3)
end

function M:ExitChessBoard()
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Xuanzhong)
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
  self:HideChessInfo()
  self:ShowTips(false)
  if self.PickCubeIndex then
    self.AutoChessFormation:OnCubeMonsterSelected(self.PickCubeIndex, false)
    self.PickCubeIndex = nil
  end
  self:BanEmemy(false)
end

function M:ShowTips(bFlag, Mode)
  if bFlag then
    self.Tips:SetVisibility(ESlateVisibility.Visible)
    self.Tips:PlayAnimation(self.Tips.In)
    self:UpdateTipsText(Mode)
    self:UpdateTipsKey()
  elseif self.bShowTips == true then
    self.Tips:PlayAnimation(self.Tips.Out)
  end
  self.bShowTips = bFlag
end

function M:UpdateTipsText(Mode)
  if self.Tips then
    if self.Tips.Text_Tips then
      if Mode == Const.DeployState.Place then
        self.Tips.Text_Tips:SetText(GText("UI_AutoChess_PlaceToast"))
      elseif Mode == Const.DeployState.Move then
        self.Tips.Text_Tips:SetText(GText("UI_AutoChess_ReplaceToast"))
      end
    end
    if self.Tips.Text_01 then
      if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
        self.Tips.Text_01:SetText(GText("UI_AutoChess_Cancel3"))
      else
        self.Tips.Text_01:SetText(GText("UI_AutoChess_Cancel1"))
      end
    end
    if self.Tips.Text_02 then
      self.Tips.Text_02:SetText(GText("UI_AutoChess_Cancel2"))
    end
  end
end

function M:UpdateTipsKey()
  if self.Tips and self.Tips.Key_1 then
    local WrapBox = self.Tips.Key_1
    local DeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
    WrapBox:ClearChildren()
    if DeviceType == ECommonInputType.Gamepad then
      local Key = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyImg.WBP_Com_KeyImg", false)
      WrapBox:AddChild(Key)
      Key:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        }
      })
    elseif DeviceType == ECommonInputType.MouseAndKeyboard then
      local Key = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText", false)
      WrapBox:AddChild(Key)
      Key:CreateCommonKey({
        KeyInfoList = {
          {Type = "Text", Text = "Esc"}
        }
      })
    end
  end
end

function M:ShowChessInfo(CombatChessId, bIsEnemy, bIsCard)
  local CombatChessInfo = DataMgr.CombatChessInfo[CombatChessId]
  local CombatChessName = CombatChessInfo.CombatChessName
  self.MonsterInfo.Text_Name:SetText(GText(CombatChessName))
  if CombatChessInfo.PositionIcon then
    local ImgType = LoadObject(CombatChessInfo.PositionIcon)
    self.MonsterInfo.Icon_Type.Icon:SetBrushFromTexture(ImgType)
  end
  local ChessData = Model:GetMonsterInfoByCombatId(CombatChessId)
  self.MonsterInfo.Value_01:InitView(GText("UI_AutoChess_MonsterProp1"), ChessData.Atk)
  self.MonsterInfo.Value_02:InitView(GText("UI_AutoChess_MonsterProp2"), ChessData.MaxHp)
  self.MonsterInfo.Value_03:InitView(GText("UI_AutoChess_MonsterProp3"), ChessData.Def)
  self.MonsterInfo.Value_04:InitView(GText("UI_AutoChess_MonsterProp4"), ChessData.MaxEs)
  local RobotEquip = DataMgr.RobotEquip
  local ChessEquips = self:GetChessEquips(CombatChessId, bIsEnemy)
  self.List_EquipmentEffect:ClearListItems()
  local EquipsCount = #ChessEquips
  if EquipsCount > 0 then
    self.VBox_Equipment:SetVisibility(ESlateVisibility.Visible)
    for _, EquipId in pairs(ChessEquips) do
      local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
      ItemContent.Text_Name = GText(RobotEquip[EquipId].EquipName)
      ItemContent.Text_Desc = GText(Model:CalcEquipExtraDesc(EquipId))
      self.List_EquipmentEffect:AddItem(ItemContent)
    end
  else
    self.VBox_Equipment:SetVisibility(ESlateVisibility.Collapsed)
  end
  if not bIsEnemy and not bIsCard then
    self.Btn_Delete:SetVisibility(ESlateVisibility.Visible)
    self.Btn_Delete:PlayAnimation(self.Btn_Delete.In)
  else
    self.Btn_Delete:SetVisibility(ESlateVisibility.Collapsed)
  end
  self:PlayAnimation(self.MonsterInfo_In)
  self:AdjustScrollable()
end

function M:HideChessInfo()
  if self.Panel_MonsterInfo:GetVisibility() ~= ESlateVisibility.Collapsed then
    self:PlayAnimation(self.MonsterInfo_Out)
  end
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Xuanzhong)
end

function M:GetChessItemEntryByChessId(ChessId)
  local AllDisplayedEntries = self.List_Chess:GetDisplayedEntryWidgets()
  for _, Entry in pairs(AllDisplayedEntries) do
    if Entry.Content.Data and Entry.Content.Data.Id == ChessId then
      return Entry
    end
  end
  return nil
end

function M:GetChessItemContentByChessId(ChessId)
  for _, Content in pairs(self.List_Chess:GetListItems()) do
    if not Content or not Content.Data then
      return
    end
    if ChessId == Content.Data.Id then
      return Content
    end
  end
  return nil
end

function M:InitBuffUI()
  if self.MissionId then
    if self.Buff then
      self.Buff:ShowBuff(self.MissionId)
    end
  else
    DebugPrint("-----------MissionId nil------------")
  end
end

function M:SetInputModeCustom(Flag)
  local CurDeviceType = CommonUtils.GetDeviceTypeByPlatformName(self)
  if not self.GameInputModeSubsystem then
    self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  end
  local UINameText = Const.InputMode
  if Flag then
    local Params = FGameInputModeParams()
    if self.bIsFocusable then
      Params.WidgetToFocus = self
    end
    if CurDeviceType == CommonConst.CLIENT_DEVICE_TYPE.PC then
      Params.bShowMouseCursor = true
    end
    Params.MouseLockMode = EMouseLockMode.DoNotLock
    self.GameInputModeSubsystem:EnableInputMode(UINameText, EGameInputMode.GameAndUI, Params)
  else
    self.GameInputModeSubsystem:DisableInputMode(UINameText)
  end
end

function M:ProcessExit()
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.MouseAndKeyboard then
    if self.SelectChessCardId then
      self:SelectChessCard(self.SelectChessCardId, true)
    elseif self.PickCubeIndex then
      self:ExitPick()
    else
      self:OnClickExit()
    end
  elseif self.Btn_Explanation then
    local PressKey = self.Btn_Explanation.Com_KeyImg
    PressKey:AddExecuteLogic(self, self.ShowGuide)
    PressKey:OnButtonPressed(nil, true, 0, 0.5)
    self.LongPressDuration = PressKey.LongPressDuration or 0.8
    self.PressStartTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  end
end

function M:ProcessExitRelease()
  if self.Btn_Explanation then
    local PressKey = self.Btn_Explanation.Com_KeyImg
    PressKey:OnButtonReleased()
  end
  if self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad and self.PressStartTime then
    local PassTime = UE4.UGameplayStatics.GetTimeSeconds(self) - self.PressStartTime
    if PassTime < self.LongPressDuration - 0.01 then
      self:OnClickExit()
    end
  end
end

function M:OnClickExit()
  if self.bDeploying then
    local Params = {}
    
    function Params.RightCallbackFunction()
      self.bNoFocus = false
      self:SetInputModeCustom(false)
      local Avatar = GWorld:GetAvatar()
      if Avatar then
        Avatar:ExitBattle(false, true)
      end
    end
    
    function Params.LeftCallbackFunction()
      self.bNoFocus = false
    end
    
    self.bNoFocus = true
    self.UIManager:ShowCommonPopupUI(100096, Params, self)
  else
    if self.WS_Battle_Controller then
      self.WS_Battle_Controller:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.bNoFocus = true
    UIUtils.OpenEsc()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.bDeploying and (self.FocusState == Const.GamepadFocusState.Focus2 or self.FocusState == Const.GamepadFocusState.Focus3) then
    if InKeyName == UIConst.GamePadKey.LeftAnalogX then
      local DeltaOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
      if DeltaOffset <= -Const.JoystickThreshold then
        self:GamepadMove({-1, 0})
      elseif DeltaOffset >= Const.JoystickThreshold then
        self:GamepadMove({1, 0})
      end
    elseif InKeyName == UIConst.GamePadKey.LeftAnalogY then
      local DeltaOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
      if DeltaOffset <= -Const.JoystickThreshold then
        self:GamepadMove({0, 1})
      elseif DeltaOffset >= Const.JoystickThreshold then
        self:GamepadMove({0, -1})
      end
    elseif InKeyName == UIConst.GamePadKey.RightAnalogY then
      local AddOffset = UE4.UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
      local CurScrollOffset = self.List_EquipmentEffect:GetScrollOffset()
      local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.List_EquipmentEffect:GetScrollOffsetOfEnd())
      self.List_EquipmentEffect:SetScrollOffset(ScrollOffset)
    end
  end
  return UIUtils.Unhandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and not IsEventHandled and self.bDeploying and self.FocusState == Const.GamepadFocusState.Focus1 and InKeyName == UIConst.GamePadKey.SpecialLeft then
    if self.Buff and self.MissionId then
      self.Buff:ShowBuffDetail()
    end
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.SpecialRight then
      self:ProcessExit()
      IsEventHandled = true
    elseif InKeyName == UIConst.GamePadKey.LeftShoulder and self.BattleStatisticsTips:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      IsEventHandled = true
      self.BattleStatisticsTips:AllyFight_OnClicked()
    elseif InKeyName == UIConst.GamePadKey.RightShoulder and self.BattleStatisticsTips:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
      IsEventHandled = true
      self.BattleStatisticsTips:EnemyFight_OnClicked()
    end
    if not IsEventHandled and self.bDeploying and self.FocusState == Const.GamepadFocusState.Focus1 then
      if InKeyName == UIConst.GamePadKey.RightThumb then
        self:ResetLineup()
        IsEventHandled = true
      elseif self.bDeploying and InKeyName == UIConst.GamePadKey.FaceButtonTop then
        self:PresetLineup()
        IsEventHandled = true
      elseif self.bDeploying and InKeyName == UIConst.GamePadKey.FaceButtonLeft then
        self:TryStartBattle()
        IsEventHandled = true
      elseif self.bDeploying and InKeyName == UIConst.GamePadKey.LeftThumb then
        self:SetFocusState(Const.GamepadFocusState.Focus2)
        IsEventHandled = true
      end
    end
    if not IsEventHandled and self.bDeploying and (self.FocusState == Const.GamepadFocusState.Focus2 or self.FocusState == Const.GamepadFocusState.Focus3) then
      if InKeyName == UIConst.GamePadKey.FaceButtonRight then
        self:SetFocusState(Const.GamepadFocusState.Focus1)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.GamepadCubeIndex, self.bGamepadCubeEnemy)
        self:SelectChessCard(self.SelectChessCardId, true)
        if self.PickCubeIndex then
          self:ExitPick()
        end
        self:RecoverListFocus()
        IsEventHandled = true
      elseif InKeyName == UIConst.GamePadKey.FaceButtonBottom then
        local CubeIndex = self.GamepadCubeIndex
        local bIsEnemy = self.bGamepadCubeEnemy
        local HadPlacedChess = false
        if not bIsEnemy and self.SelectChessCardId then
          if self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
            if self:DeploySelfMonster(CubeIndex) then
              self.SelectChessId = self.SelectChessCardId
              self:SelectChessCard(self.SelectChessCardId, true)
              self:SetFocusState(Const.GamepadFocusState.Focus1)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, CubeIndex, bIsEnemy)
              HadPlacedChess = true
            end
          else
            self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_CantPlaceToast"))
            EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Forbid, CubeIndex)
          end
        end
        if (bIsEnemy or not self.SelectChessCardId) and not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
          self.SelectChessId = self:GetChessByCubeIndex(CubeIndex, bIsEnemy)
        end
        if not bIsEnemy and not self.SelectChessCardId and not HadPlacedChess then
          if not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
            if not self.PickCubeIndex then
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.CanChange, CubeIndex)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Xuanzhong, CubeIndex, bIsEnemy)
              self.AutoChessFormation:OnCubeMonsterSelected(CubeIndex, true)
              self.PickCubeIndex = CubeIndex
              self:ShowTips(true, Const.DeployState.Move)
              self:BanEmemy(true)
            elseif self.PickCubeIndex and self.PickCubeIndex == CubeIndex then
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
              self.AutoChessFormation:OnCubeMonsterSelected(CubeIndex, false)
              self.PickCubeIndex = nil
              self:ShowTips(false)
              self:BanEmemy(false)
            elseif self.PickCubeIndex and self.PickCubeIndex ~= CubeIndex then
              self.SelectChessId = self:GetChessByCubeIndex(self.PickCubeIndex, false)
              self:ShowChessInfo(self.SelectChessId, false, false)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.PickCubeIndex, bIsEnemy)
              self.AutoChessFormation:SwitchMonsterPosition(self.PickCubeIndex, CubeIndex)
              self.PickCubeIndex = nil
              self:ShowTips(false)
              self:BanEmemy(false)
            end
          else
            self:HideChessInfo()
            if self.PickCubeIndex and self.PickCubeIndex ~= CubeIndex then
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
              EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.PickCubeIndex, bIsEnemy)
              self.AutoChessFormation:SwitchMonsterPosition(self.PickCubeIndex, CubeIndex)
              self.PickCubeIndex = nil
              self:ShowTips(false)
              self:BanEmemy(false)
            end
          end
        end
        IsEventHandled = true
      elseif InKeyName == UIConst.GamePadKey.RightThumb and self.Panel_MonsterInfo:GetVisibility() ~= ESlateVisibility.Collapsed then
        self.SelectCubeIndex = self.GamepadCubeIndex
        self:DeleteSelectedChess()
        IsEventHandled = true
      end
    end
  elseif "Escape" == InKeyName then
    self:ProcessExit()
    IsEventHandled = true
  elseif "Q" == InKeyName and self.BattleStatisticsTips:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
    self.BattleStatisticsTips:AllyFight_OnClicked()
    IsEventHandled = true
  elseif "E" == InKeyName and self.BattleStatisticsTips:GetVisibility() ~= UIConst.VisibilityOp.Collapsed then
    self.BattleStatisticsTips:EnemyFight_OnClicked()
    IsEventHandled = true
  end
  return IsEventHandled and UIUtils.Handled or UIUtils.Unhandled
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == UIConst.GamePadKey.SpecialRight then
    self:ProcessExitRelease()
    IsEventHandled = true
  end
  return IsEventHandled and UIUtils.Handled or UIUtils.Unhandled
end

function M:BindCallBack()
  if self.Btn_Exit and self.Btn_Exit.Btn_Click then
    self.Btn_Exit.Btn_Click.OnClicked:Add(self, self.OnClickExit)
  end
  if self.Btn_Start and self.Btn_Start.Btn_Click then
    self.Btn_Start.Btn_Click.OnClicked:Add(self, self.TryStartBattle)
  end
  if self.Btn_Reset and self.Btn_Reset.Btn_Click then
    self.Btn_Reset.Btn_Click.OnClicked:Add(self, self.ResetLineup)
  end
  if self.Btn_Preset and self.Btn_Preset.Btn_Click then
    self.Btn_Preset.Btn_Click.OnClicked:Add(self, self.PresetLineup)
  end
  if self.Btn_Delete and self.Btn_Delete.Btn_Click then
    self.Btn_Delete.Btn_Click.OnClicked:Add(self, self.DeleteSelectedChess)
  end
  if self.Btn_Explanation and self.Btn_Explanation.Btn_Area then
    self.Btn_Explanation.Btn_Area.OnClicked:Add(self, self.ShowGuide)
  end
end

function M:ShowGuide(bFirst)
  if bFirst then
    SystemGuideManager:RunGuideById(2088)
  else
    GWorld.StoryMgr:RunStory("Guide/Guide_AutoChess_Battle.story", nil, nil, nil, nil)
  end
end

function M:DeleteSelectedChess()
  if not self.SelectCubeIndex then
    return
  end
  local DeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  local bIsGamepad = DeviceType == ECommonInputType.Gamepad
  if bIsGamepad then
    if self.bGamepadCubeEnemy then
      return
    end
    if self:IsSpecifyChessEmpty(self.GamepadCubeIndex, self.bGamepadCubeEnemy) then
      return
    end
    self.SelectChessId = self:GetChessByCubeIndex(self.GamepadCubeIndex, self.bGamepadCubeEnemy)
  end
  EventManager:FireEvent(EventID.OnAutoChessRemoveMonster, self.SelectCubeIndex, false)
  if self.SelectChessId then
    local DeployCost = self:GetChessCost(self.SelectChessId)
    self:UpdateDeployCost(false, -DeployCost, -1)
  end
  self:HideChessInfo()
  self:ExitPick()
  self:BanEmemy(false)
  if bIsGamepad then
    EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, self.SelectCubeIndex, false)
  else
    EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.SelectCubeIndex, false)
  end
end

function M:UpdateDeployCost(bDirectSet, CostChange, ChessNumChange)
  local bSuccess = true
  local PreUsedDeployCost = self.UsedDeployCost
  if bDirectSet then
    self.UsedDeployCost = CostChange
    if self.UsedDeployCost > self.TotalDeployCost then
      self:PlayAnimation(self.Cost_Warning)
    end
  else
    local Tmp = self.UsedDeployCost + CostChange
    if Tmp > self.TotalDeployCost and CostChange > 0 then
      bSuccess = false
    else
      self.UsedDeployCost = Tmp
    end
  end
  if PreUsedDeployCost > self.TotalDeployCost and self.UsedDeployCost <= self.TotalDeployCost then
    self:PlayAnimationReverse(self.Cost_Warning)
  end
  DebugPrint(string.format("UpdateDeployCost   UsedDeployCost:%d TotalDeployCost:%d", self.UsedDeployCost, self.TotalDeployCost))
  if self.UsedDeployCost < 0 then
    self.UsedDeployCost = 0
  end
  self.Text_Now:SetText(self.UsedDeployCost)
  if self.UsedDeployCost > 0 then
    self.Btn_Start.Btn_Click:SetForbidden(false)
    self.Btn_Reset.Btn_Click:SetForbidden(false)
  else
    self.Btn_Start.Btn_Click:SetForbidden(true)
    self.Btn_Reset.Btn_Click:SetForbidden(true)
  end
  if bSuccess then
    if bDirectSet then
      self.ChessNum = ChessNumChange
    else
      self.ChessNum = self.ChessNum + ChessNumChange
    end
    if self.ChessNum == Const.MaxChessNum then
      self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_MonsterOverflow"))
      self.bChessBoardFull = true
    else
      self.bChessBoardFull = false
    end
  end
  local ResDeployCost = self.TotalDeployCost - self.UsedDeployCost
  for _, Entry in pairs(self.List_Chess:GetDisplayedEntryWidgets()) do
    if Entry and Entry.Content and Entry.Content.Data then
      local ChessCost = Entry.Content.Data.TotalCost
      local bForbidden = ResDeployCost < ChessCost or self.bChessBoardFull
      Entry:SetForbidden(bForbidden)
      if true == bForbidden then
        Entry:SetSelected(false)
      end
    end
  end
  for _, Content in pairs(self.List_Chess:GetListItems()) do
    if Content and Content.Data then
      local ChessCost = Content.Data.TotalCost
      local bForbidden = ResDeployCost < ChessCost or self.bChessBoardFull
      Content.bForbidden = bForbidden
      if true == bForbidden then
        Content.IsSelected = false
      end
    end
  end
  self.List_Chess.OnCreateEmptyContent:Bind(self, function(self)
    local ItemContent = NewObject(UIUtils.GetCommonItemContentClass())
    ItemContent.IsEmpty = true
    return ItemContent
  end)
  self.List_Chess:RequestFillEmptyContent()
  return bSuccess
end

function M:RecoverListFocus()
  local bSuccess = false
  local AllDisplayedEntries = self.List_Chess:GetDisplayedEntryWidgets()
  for _, Entry in pairs(AllDisplayedEntries) do
    if not (Entry and Entry.Content) or not Entry.Content.Data then
      return
    end
    local ChessId = Entry.Content.Data.Id
    if ChessId and ChessId == self.FocusChessCardId and not Entry:HasFocusedDescendants() and not Entry:HasAnyUserFocus() then
      bSuccess = true
      Entry:SetFocus()
      if not Entry.Content.bForbidden then
        Entry:StopAllAnimations()
        Entry:PlayAnimation(Entry.Hover)
      end
    end
  end
  if not bSuccess then
    self:AddTimer(0.001, self.RecoverListFocus, false, 0, "WBP_AutoChessBattlePage_RecoverListFocus")
  end
end

function M:ResetLineup()
  self:PlaySound("event:/ui/activity/sub_btn_click")
  if self.Btn_Reset.Btn_Click:GetForbidden() then
    self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_EmptyResetToast"))
    return
  end
  local Params = {}
  
  function Params.RightCallbackFunction()
    self.bNoFocus = false
    self:ExitPick()
    for CubeIndex = 0, Const.MaxChessNum - 1 do
      EventManager:FireEvent(EventID.OnAutoChessRemoveMonster, CubeIndex, false)
    end
    self:UpdateDeployCost(true, 0, 0)
    self:ExitChessBoard()
    self:AddTimer(0.3, function()
      self:SetFocusState(Const.GamepadFocusState.Focus1)
    end, false, 0, "WBP_AutoChessBattlePage_SetFocus_AfterResetLineup", true)
    self:PlaySound("event:/ui/activity/auto_chess_cell_click_remove")
  end
  
  function Params.LeftCallbackFunction()
    self.bNoFocus = false
  end
  
  self.bNoFocus = true
  self.UIManager:ShowCommonPopupUI(100294, Params, self)
end

function M:PresetLineup()
  self:PlaySound("event:/ui/activity/sub_btn_click")
  UIManager(self.Player):LoadUINew("AutoChessPresetPage", self)
end

function M:SetLineup(InfoList)
  for CubeIndex = 0, Const.MaxChessNum - 1 do
    EventManager:FireEvent(EventID.OnAutoChessRemoveMonster, CubeIndex, false)
  end
  local Cost = 0
  local ChessCount = 0
  for CubeIndex, CombatChessId in pairs(InfoList) do
    local CubeIndex = CubeIndex - 1
    Cost = Cost + self:GetChessCost(CombatChessId)
    EventManager:FireEvent(EventID.OnAutoChessCreateMonster, CombatChessId, CubeIndex, false, self:GetChessEquips(CombatChessId, false))
    ChessCount = ChessCount + 1
  end
  self:UpdateDeployCost(true, Cost, ChessCount)
end

function M:GetChessCost(CombatChessId)
  local Cost = 0
  Cost = Cost + DataMgr.CombatChessInfo[CombatChessId].DeployCost
  local ChessEquips = self:GetChessEquips(CombatChessId, false)
  for _, EquipId in pairs(ChessEquips) do
    Cost = Cost + DataMgr.RobotEquip[EquipId].DeployCost
  end
  return Cost
end

function M:GetChessEquips(ChessId, bIsEnemy)
  local Equips
  if bIsEnemy then
    Equips = self.EnemyChessEquips[ChessId]
  else
    Equips = Model:GetMonsterEquipInfo(ChessId)
  end
  return Equips
end

function M:ActivateMonsters(IndexTable)
  if not IndexTable then
    return
  end
  for Index, Info in pairs(IndexTable) do
    if Info and Info.Eid then
      local Monster = Battle(self):GetEntity(Info.Eid)
      if Monster then
        Monster.EMActorDestroyDelegates:Add(self, self.OnMonsterDead)
        Monster:StartBT()
      end
    end
  end
end

function M:TryStartBattle()
  self:PlaySound("event:/ui/activity/auto_chess_main_level_btn_click")
  if self.Btn_Start.Btn_Click:GetForbidden() then
    self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_NoMonsterToast"))
    return
  end
  if self.UsedDeployCost > self.TotalDeployCost then
    self:PlayAnimation(self.Cost_Warning)
    self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_IllegalToast"))
    return
  end
  local SavedSquadInfo = {}
  for Index, value in pairs(self.Index2CubeInfo) do
    SavedSquadInfo[Index + 1] = value.CombatChessId
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  Avatar:AutoChessCombatStart(function(Ret)
    if 0 ~= Ret then
      self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_IllegalToast"))
    else
      local Params = {}
      
      function Params.RightCallbackFunction()
        self.bNoFocus = false
        self:RealStartBattle()
      end
      
      function Params.LeftCallbackFunction()
        self.bNoFocus = false
      end
      
      self.bNoFocus = true
      self.UIManager:ShowCommonPopupUI(100295, Params, self)
    end
  end, SavedSquadInfo)
end

function M:RealStartBattle()
  self.GameInstance.bAutoChessDeploying = false
  self.bDeploying = false
  self.CameraPawn:SwitchInputState(true)
  self:ExitPick()
  self:PlayAnimation(self.StartOut)
  self:SetInputModeCustom(false)
  self.GameMode:TriggerDungeonComponentFun("DisableCubeInteraction")
  self:ActivateMonsters(self.Index2CubeInfo)
  self:ActivateMonsters(self.Index2EnemyCubeInfo)
  EventManager:FireEvent(EventID.OnAutoChessBattleStart)
  self.Toast_Start:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Toast_Start:PlayAnimation(self.Toast_Start.In)
  self:PlaySound("event:/ui/activity/auto_chess_game_start_in")
  self.CountDownStartTime = URuntimeCommonFunctionLibrary.GetTimeSeconds(self)
  self:AddTimer(self.CountDownInterval, function()
    self:MotivateCountDown()
  end, true, 0, self.CountDownTimerName)
  self:ShowTimeText(self.TotalCountDownTime)
end

function M:MotivateCountDown()
  local CountDownNowTime = URuntimeCommonFunctionLibrary.GetTimeSeconds(self)
  local TimeRes = self.TotalCountDownTime - (CountDownNowTime - self.CountDownStartTime)
  if TimeRes < 0 then
    self:ShowTimeText(0)
    self:RemoveTimer(self.CountDownTimerName)
    EventManager:FireEvent(EventID.OnAutoChessMotivateStart)
    self:StartMotivate()
    return
  end
  self:ShowTimeText(TimeRes)
end

function M:ShowTimeText(Time)
  if self.CountDown and self.CountDown.Text_CountDown then
    local sec = math.floor(Time)
    local min = math.floor(sec / 60)
    sec = sec % 60
    local Tmp = string.format("%02d:%02d", min, sec)
    self.CountDown.Text_CountDown:SetText(Tmp)
  end
end

function M:StartMotivate()
  self:PlaySound("event:/ui/activity/auto_chess_game_last_stage_in")
  self.CountDown:SetVisibility(ESlateVisibility.Collapsed)
  self.Toast_Duel:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Toast_Duel:PlayAnimation(self.Toast_Duel.In)
  self.DuelScreen:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.DuelScreen:PlayAnimation(self.DuelScreen.In)
  self.MotivateBar:SetVisibility(ESlateVisibility.Collapsed)
end

function M:InitButtonGamepadView()
  self.Btn_Exit.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Menu"}
    }
  })
  if self.Buff and self.Buff.Key_CheckBuff then
    self.Buff.Key_CheckBuff:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "View"}
      }
    })
  end
  if self.Btn_Start and self.Btn_Start.Key_Controller then
    self.Btn_Start.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
  end
  if self.Btn_Preset and self.Btn_Preset.Key_Controller then
    self.Btn_Preset.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
  end
  if self.Btn_Reset and self.Btn_Reset.Key_Controller then
    self.Btn_Reset.Key_Controller:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      }
    })
  end
  if self.Btn_Delete and self.Btn_Delete.Key_GamePad then
    self.Btn_Delete.Key_GamePad:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      }
    })
  end
  if self.Key_MonsterInfo then
    self.Key_MonsterInfo:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RV"}
      }
    })
  end
  if self.WBox_Controller_Chess then
    if self.Key_Chess_Edit then
      self.Key_Chess_Edit:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LS"}
        },
        bLongPress = false,
        Desc = GText("UI_CTL_EditChess")
      })
    end
    if self.Key_Chess_Move then
      self.Key_Chess_Move:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "LV"}
        },
        bLongPress = false,
        Desc = GText("UI_CTL_Move")
      })
    end
    if self.Key_Chess_Back then
      self.Key_Chess_Back:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        bLongPress = false,
        Desc = GText("UI_BACK")
      })
    end
    if self.Key_Chess_Confirm then
      self.Key_Chess_Confirm:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        bLongPress = false,
        Desc = GText("UI_CONFIRM_SELECTION")
      })
    end
  end
  if self.WBox_Key then
    local WrapBox = self.WBox_Key
    WrapBox:ClearChildren()
    local Key1 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText", false)
    WrapBox:AddChild(Key1)
    Key1:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "W"}
      }
    })
    local Key2 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyOr.WBP_Com_KeyOr", false)
    WrapBox:AddChild(Key2)
    local Key3 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key3)
    Key3:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "S"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_MoveLR")
    })
    local Key4 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyText.WBP_Com_KeyText", false)
    WrapBox:AddChild(Key4)
    Key4:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "A"}
      }
    })
    local Key5 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyOr.WBP_Com_KeyOr", false)
    WrapBox:AddChild(Key5)
    local Key6 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key6)
    Key6:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "D"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_MoveTB")
    })
    local Key7 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key7)
    Key7:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Mouse_Button"
        }
      },
      bLongPress = false,
      Desc = GText("UI_CTL_ZoomInOut")
    })
    local Key8 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key8)
    Key8:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = "Esc"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Pause")
    })
  end
  if self.WBox_Battle_Controller then
    local WrapBox = self.WBox_Battle_Controller
    WrapBox:ClearChildren()
    local Key1 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key1)
    Key1:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "R"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Move")
    })
    local Key2 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key2)
    Key2:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "L"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Camera")
    })
    local Key3 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyImg.WBP_Com_KeyImg", false)
    WrapBox:AddChild(Key3)
    Key3:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LT"}
      }
    })
    local Key4 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyOr.WBP_Com_KeyOr", false)
    WrapBox:AddChild(Key4)
    local Key5 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key5)
    Key5:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RT"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_ZoomInOut")
    })
    local Key6 = self.UIManager:CreateWidget("/Game/UI/WBP/Common/Key/WBP_Com_KeyTextDesc.WBP_Com_KeyTextDesc", false)
    WrapBox:AddChild(Key6)
    Key6:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Menu"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Pause")
    })
    if self.Btn_Explanation and self.Btn_Explanation.Com_KeyImg then
      self.Btn_Explanation.Com_KeyImg:CreateCommonKey({
        KeyInfoList = {
          {Type = "Img", ImgShortPath = "Menu"}
        },
        bLongPress = true
      })
    end
  end
end

function M:SetFocusState(NewFocusState)
  local DeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  local bIsGamepad = DeviceType == ECommonInputType.Gamepad
  if self.WBox_Controller_Chess then
    if bIsGamepad then
      if NewFocusState == Const.GamepadFocusState.Focus1 then
        self:AddTimer(0.1, function()
          self:RecoverListFocus()
        end, false, 0, "WBP_AutoChessBattlePage_SetFocus1", true)
        self.Key_Chess_Edit:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Chess_Move:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Chess_Back:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Chess_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      elseif NewFocusState == Const.GamepadFocusState.Focus2 then
        self:AddTimer(0.1, self.SetFocus, false, 0, "WBP_AutoChessBattlePage_SetFocus2", true)
        self:GamepadLocate(0, false)
        self.Key_Chess_Edit:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Chess_Move:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Chess_Back:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Chess_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      elseif NewFocusState == Const.GamepadFocusState.Focus3 then
        self:AddTimer(0.1, self.SetFocus, false, 0, "WBP_AutoChessBattlePage_SetFocus3", true)
        self:GamepadLocateSelfFirstEmpty()
        self.Key_Chess_Edit:SetVisibility(ESlateVisibility.Collapsed)
        self.Key_Chess_Move:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Chess_Back:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
        self.Key_Chess_Confirm:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      end
    else
      self.Key_Chess_Edit:SetVisibility(ESlateVisibility.Collapsed)
      self.Key_Chess_Move:SetVisibility(ESlateVisibility.Collapsed)
      self.Key_Chess_Back:SetVisibility(ESlateVisibility.Collapsed)
      self.Key_Chess_Confirm:SetVisibility(ESlateVisibility.Collapsed)
    end
  end
  self.FocusState = NewFocusState
  self:SetGamepadOnlyUIVisibilityDueToFocusState(bIsGamepad)
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.Btn_Explanation then
    local PressKey = self.Btn_Explanation.Com_KeyImg
    PressKey:OnButtonReleased()
  end
  self:SetFocusState(self.FocusState)
end

function M:CountGamepadOnlyUI()
  self.GamepadOnly_UI = {}
  if self.WBox_Controller_Chess then
    table.insert(self.GamepadOnly_UI, self.WBox_Controller_Chess)
  end
  if self.Btn_Exit and self.Btn_Exit.Key_Controller then
    table.insert(self.GamepadOnly_UI, self.Btn_Exit.Key_Controller)
  end
  if self.Btn_Delete and self.Btn_Delete.Key_GamePad then
    table.insert(self.GamepadOnly_UI, self.Btn_Delete.Key_GamePad)
  end
end

function M:SetGamepadOnlyUIVisibility(bFlag)
  local Visibility = bFlag and ESlateVisibility.Visible or ESlateVisibility.Collapsed
  for _, v in pairs(self.GamepadOnly_UI) do
    if v.SetVisibility then
      v:SetVisibility(Visibility)
    end
  end
end

function M:SetGamepadOnlyUIVisibilityDueToFocusState(bIsGamepad)
  local Visibility = self.FocusState == Const.GamepadFocusState.Focus1 and bIsGamepad and ESlateVisibility.Visible or ESlateVisibility.Collapsed
  if self.Btn_Start and self.Btn_Start.Key_Controller then
    self.Btn_Start.Key_Controller:SetVisibility(Visibility)
  end
  if self.Btn_Preset and self.Btn_Preset.Key_Controller then
    self.Btn_Preset.Key_Controller:SetVisibility(Visibility)
  end
  if self.Btn_Reset and self.Btn_Reset.Key_Controller then
    self.Btn_Reset.Key_Controller:SetVisibility(Visibility)
  end
  if self.Buff and self.Buff.WS_Controller then
    if not bIsGamepad then
      self.Buff.WS_Controller:SetVisibility(ESlateVisibility.Visible)
    else
      self.Buff.WS_Controller:SetVisibility(Visibility)
    end
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.BattleStatisticsTips then
    self.BattleStatisticsTips:RefreshUIInfoOnUpdateDevice()
  end
  if not self:HasFocusedDescendants() and not self:HasAnyFocus() and self.bNoFocus then
    return
  end
  if self.bDeploying then
    self:UpdateTipsKey()
  end
  self:SetFocusState(self.FocusState)
  if CurInputDevice == ECommonInputType.Gamepad then
    self:SetGamepadOnlyUIVisibility(true)
    if self.Buff and self.Buff.WS_Controller then
      self.Buff.WS_Controller:SetActiveWidgetIndex(1)
    end
    if self.Btn_Explanation and self.Btn_Explanation.WidgetSwitcher_0 then
      self.Btn_Explanation.WidgetSwitcher_0:SetActiveWidgetIndex(1)
    end
    if self.WS_Battle_Controller then
      self.WS_Battle_Controller:SetActiveWidgetIndex(1)
    end
  else
    self:SetGamepadOnlyUIVisibility(false)
    if self.Buff and self.Buff.WS_Controller then
      self.Buff.WS_Controller:SetVisibility(ESlateVisibility.Visible)
      self.Buff.WS_Controller:SetActiveWidgetIndex(0)
    end
    if self.Btn_Explanation and self.Btn_Explanation.WidgetSwitcher_0 then
      self.Btn_Explanation.WidgetSwitcher_0:SetActiveWidgetIndex(0)
    end
    if self.GamepadCubeIndex and (self.GamepadCubeIndex ~= self.PickCubeIndex or self.bGamepadCubeEnemy ~= false) then
      EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.GamepadCubeIndex, self.bGamepadCubeEnemy)
      self.GamepadCubeIndex = nil
      self.bGamepadCubeEnemy = nil
    end
    if self.WS_Battle_Controller then
      self.WS_Battle_Controller:SetActiveWidgetIndex(0)
    end
  end
end

function M:SetText()
  if self.Btn_Reset and self.Btn_Reset.Text_Name then
    self.Btn_Reset.Text_Name:SetText(GText("UI_AutoChess_Reset"))
  end
  if self.Btn_Preset and self.Btn_Preset.Text_Name then
    self.Btn_Preset.Text_Name:SetText(GText("UI_AutoChess_Preset"))
  end
  if self.Btn_Start and self.Btn_Start.Text then
    self.Btn_Start.Text:SetText(GText("UI_AutoChess_Begin"))
  end
  if self.Buff and self.Buff.Text_Buff then
    self.Buff.Text_Buff:SetText(GText("UI_AutoChess_CurrentBuff"))
  end
  if self.Toast_Start and self.Toast_Start.Text_Start then
    self.Toast_Start.Text_Start:SetText(GText("UI_AutoChess_FightTips"))
  end
  if self.Toast_Duel and self.Toast_Duel.Text_Start then
    self.Toast_Duel.Text_Start:SetText(GText("UI_AutoChess_FinalTime"))
  end
  if self.CountDown and self.CountDown.Text_Title then
    self.CountDown.Text_Title:SetText(GText("UI_AutoChess_RemainTime"))
  end
  if self.Btn_Delete and self.Btn_Delete.Text_Button then
    self.Btn_Delete.Text_Button:SetText(GText("UI_AutoChess_DeleteMonster"))
  end
  if self.Btn_Explanation and self.Btn_Explanation.Tex_Explanation then
    self.Btn_Explanation.Tex_Explanation:SetText(GText("UI_AutoChess_GuideReplay"))
  end
end

function M:IsSpecifyChessEmpty(CubeIndex, bIsEnemy)
  if bIsEnemy then
    return self.Index2EnemyCubeInfo[CubeIndex] == nil
  else
    return nil == self.Index2CubeInfo[CubeIndex]
  end
end

function M:GetChessByCubeIndex(CubeIndex, bIsEnemy)
  if bIsEnemy then
    return self.Index2EnemyCubeInfo[CubeIndex].CombatChessId
  else
    return self.Index2CubeInfo[CubeIndex].CombatChessId
  end
end

function M:ClickChess(CubeIndex, bIsEnemy, CubeActor, ButtonOrNil)
  self.SelectCubeIndex = CubeIndex
  local HadPlacedChess = false
  if not bIsEnemy and self.SelectChessCardId then
    if self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
      if self:DeploySelfMonster(CubeIndex) then
        self.SelectChessId = self.SelectChessCardId
        self:SelectChessCard(self.SelectChessCardId, true)
        HadPlacedChess = true
      end
    else
      self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_CantPlaceToast"))
      EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Forbid, CubeIndex)
    end
  end
  if (bIsEnemy or not self.SelectChessCardId) and not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
    self.SelectChessId = self:GetChessByCubeIndex(CubeIndex, bIsEnemy)
  end
  if not bIsEnemy and not self.SelectChessCardId and not HadPlacedChess then
    if not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
      if not self.PickCubeIndex then
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.CanChange, CubeIndex)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Xuanzhong, CubeIndex, bIsEnemy)
        self.AutoChessFormation:OnCubeMonsterSelected(CubeIndex, true)
        self.PickCubeIndex = CubeIndex
        self:ShowTips(true, Const.DeployState.Move)
        self.SelectChessId = self:GetChessByCubeIndex(CubeIndex, false)
        self:ShowChessInfo(self.SelectChessId, false, false)
        self:BanEmemy(true)
        self:SetFocusState(Const.GamepadFocusState.Focus2)
      elseif self.PickCubeIndex and self.PickCubeIndex == CubeIndex then
        self:HideChessInfo()
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
        self.AutoChessFormation:OnCubeMonsterSelected(CubeIndex, false)
        self.PickCubeIndex = nil
        self:ShowTips(false)
        self:BanEmemy(false)
        self:SetFocusState(Const.GamepadFocusState.Focus1)
      elseif self.PickCubeIndex and self.PickCubeIndex ~= CubeIndex then
        self:HideChessInfo()
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.PickCubeIndex, bIsEnemy)
        self.AutoChessFormation:SwitchMonsterPosition(self.PickCubeIndex, CubeIndex)
        self.PickCubeIndex = nil
        self:ShowTips(false)
        self:BanEmemy(false)
        self:SetFocusState(Const.GamepadFocusState.Focus1)
      end
    else
      self:HideChessInfo()
      if self.PickCubeIndex and self.PickCubeIndex ~= CubeIndex then
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
        EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.PickCubeIndex, bIsEnemy)
        self.AutoChessFormation:SwitchMonsterPosition(self.PickCubeIndex, CubeIndex)
        self.PickCubeIndex = nil
        self:ShowTips(false)
        self:BanEmemy(false)
        self:SetFocusState(Const.GamepadFocusState.Focus1)
      end
    end
  end
  if bIsEnemy then
    if not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
      EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Xuanzhong, CubeIndex, bIsEnemy)
      self.SelectChessId = self:GetChessByCubeIndex(CubeIndex, true)
      self:ShowChessInfo(self.SelectChessId, true, false)
    else
      self:HideChessInfo()
    end
    self:SetFocusState(Const.GamepadFocusState.Focus1)
  end
end

function M:ExitPick()
  if self.PickCubeIndex then
    EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.InitEffect)
    self.AutoChessFormation:OnCubeMonsterSelected(self.PickCubeIndex, false)
    self.PickCubeIndex = nil
    self:ShowTips(false)
    self:HideChessInfo()
  end
end

function M:DeploySelfMonster(CubeIndex)
  if not self:IsSpecifyChessEmpty(CubeIndex, false) then
    return
  end
  if not self.SelectChessCardId then
    return false
  end
  local DeployCost = self:GetChessCost(self.SelectChessCardId)
  if not self:UpdateDeployCost(false, DeployCost, 1) then
    return false
  end
  EventManager:FireEvent(EventID.OnAutoChessCreateMonster, self.SelectChessCardId, CubeIndex, false, self:GetChessEquips(self.SelectChessCardId, false))
  return true
end

function M:OnMonsterDead(Unit)
  EventManager:FireEvent(EventID.OnCheckIsGameOver, Unit)
end

function M:GamepadLocate(CubeIndex, bIsEnemy)
  if self.GamepadCubeIndex then
    EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.UnHover, self.GamepadCubeIndex, self.bGamepadCubeEnemy)
  end
  if not self:IsSpecifyChessEmpty(CubeIndex, bIsEnemy) then
    self.SelectChessId = self:GetChessByCubeIndex(CubeIndex, bIsEnemy)
    self:ShowChessInfo(self.SelectChessId, bIsEnemy, false)
  else
    self:HideChessInfo()
  end
  EventManager:FireEvent(EventID.OnAutoChessCubeChangeState, Const.CubeState.Hover, CubeIndex, bIsEnemy)
  self.GamepadCubeIndex = CubeIndex
  self.bGamepadCubeEnemy = bIsEnemy
  local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  self.LastGamepadMoveTime = NowTime
end

function M:Coordinate2CubeIndex(x, y)
  local CubeIndex
  if y >= 0 then
    CubeIndex = x + y * Const.BoardWidth
  else
    CubeIndex = self:GetMirrorIndex(x + math.abs(y + 1) * Const.BoardWidth)
  end
  return CubeIndex
end

function M:GetMirrorIndex(n)
  local block = math.floor(n / Const.BoardWidth)
  local offset = n % Const.BoardWidth
  return block * Const.BoardWidth + (Const.BoardWidth - 1 - offset)
end

function M:CubeIndex2Coordinate(CubeIndex, bIsEnemy)
  local x, y
  if not bIsEnemy then
    x = CubeIndex % Const.BoardWidth
    y = math.floor(CubeIndex / Const.BoardWidth)
  else
    CubeIndex = self:GetMirrorIndex(CubeIndex)
    x = CubeIndex % Const.BoardWidth
    y = -math.floor(CubeIndex / Const.BoardWidth) - 1
  end
  return {x, y}
end

function M:GamepadMove(DirectionVec)
  if not self.GamepadCubeIndex then
    return
  end
  local NowTime = UE4.UGameplayStatics.GetTimeSeconds(self)
  if self.LastGamepadMoveTime and NowTime - self.LastGamepadMoveTime < Const.GamepadMoveMinDeltaTime then
    return
  else
    self.LastGamepadMoveTime = NowTime
  end
  DebugPrint("BeforeGamepadMove: ", DirectionVec[1], " ", DirectionVec[2], " ", self.GamepadCubeIndex, " ", self.bGamepadCubeEnemy)
  local Coordinate = self:CubeIndex2Coordinate(self.GamepadCubeIndex, self.bGamepadCubeEnemy)
  local x = Coordinate[1] + DirectionVec[1]
  local y = Coordinate[2] + DirectionVec[2]
  if self.FocusState == Const.GamepadFocusState.Focus2 then
    if x >= Const.BoardWidth or x <= -1 or y >= Const.BoardHeight or y <= -Const.BoardHeight - 1 then
      return
    end
  elseif self.FocusState == Const.GamepadFocusState.Focus3 and (x >= Const.BoardWidth or x <= -1 or y >= Const.BoardHeight or y <= -1) then
    return
  end
  self:GamepadLocate(self:Coordinate2CubeIndex(x, y), y < 0)
  DebugPrint("AfterGamepadMove: ", self.GamepadCubeIndex, " ", self.bGamepadCubeEnemy)
end

function M:GamepadLocateSelfFirstEmpty()
  for CubeIndex = 0, Const.MaxChessNum - 1 do
    if self:IsSpecifyChessEmpty(CubeIndex, false) then
      self:GamepadLocate(CubeIndex, false)
      return
    end
  end
  self.UIManager:ShowUITip("CommonToastMain", GText("UI_AutoChess_MonsterOverflow"))
  self.bChessBoardFull = true
end

function M:AdjustScrollable()
  local ContentHeight = self.List_EquipmentEffect:GetDesiredSize().Y
  local VisibleHeight = USlateBlueprintLibrary.GetLocalSize(self.List_EquipmentEffect:GetTickSpaceGeometry()).Y
  self.LastVisibleHeight = self.LastVisibleHeight or VisibleHeight
  if 0 == VisibleHeight then
    self:AddTimer(0.001, self.AdjustScrollable, false, 0, "WBP_AutoChessBattlePage_AdjustScrollable", true)
    return
  elseif math.abs(VisibleHeight - self.LastVisibleHeight) > 0.001 then
    self.LastVisibleHeight = VisibleHeight
    self:AddTimer(0.001, self.AdjustScrollable, false, 0, "WBP_AutoChessBattlePage_AdjustScrollable", true)
    return
  end
  if ContentHeight - VisibleHeight > 0.001 then
    self.List_EquipmentEffect:DisableScroll(false)
    if self.Key_MonsterInfo and self.GameInputModeSubsystem:GetCurrentInputType() == ECommonInputType.Gamepad then
      self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Visible)
    end
  else
    if self.Key_MonsterInfo then
      self.Key_MonsterInfo:SetVisibility(ESlateVisibility.Collapsed)
    end
    self.List_EquipmentEffect:DisableScroll(true)
  end
end

function M:PlaySound(SoundEvent)
  AudioManager(self):PlayUISound(self, SoundEvent, nil, nil)
end

return M
