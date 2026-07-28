require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local AutoChessConst = require("BluePrints.UI.AutoChess.AutoChessConst")
local View = Class({
  "BluePrints.UI.BP_UIState_C",
  "Blueprints.UI.AutoChess.AutoChessPageInterface",
  "BluePrints.Common.TimerMgr"
})
local LevelState = {
  Pass = 0,
  UnPass = 1,
  UnLock = 2
}
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")

function View:Construct()
  self:AddDispatcher(EventID.OnChallengeBuffChange, self, self.OnChallengeBuffChange)
end

function View:OnChallengeBuffChange()
  self:UpdateRandomDetail()
end

function View:InitView(Type, MissionId, IsWin, First)
  DebugPrint("Tianyi@ AutoChessLevelSelectPage InitView, Type: " .. tostring(Type))
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "SelectOpen", nil)
  self.Type = Type
  self.SelectedItem = nil
  self.LinearList = {}
  for _, Id in ipairs(DataMgr.AutoChessConstant[AutoChessConst.ActiveId].EventMissionId) do
    local Info = DataMgr.AutoChessMission[Id]
    if 1 == Info.MissionType then
      table.insert(self.LinearList, Id)
    end
  end
  if Type == AutoChessConst.LevelSelectType.Linear then
    if MissionId and IsWin and First then
      local Rank = DataMgr.AutoChessMission[MissionId].UnlockRankID
      if Rank then
        UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("UI_AutoChess_RankUpToast"))
      end
    end
    self.WS_Type:SetActiveWidgetIndex(0)
    self.BG:PlayAnimation(self.BG.BG01_In)
    self:AddTimer(0.01, function()
      self:InitListView()
      self:LinearInit()
      self:InitLinearRank()
    end, false, 0, nil, true)
  elseif Type == AutoChessConst.LevelSelectType.Random then
    self.WS_Type:SetActiveWidgetIndex(1)
    self.BG:PlayAnimation(self.BG.BG02_In)
    self:RandomInit()
  end
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  if self.Details then
    self.Details:SetCallbacks({
      OnChallenge = function()
        self:OnClickEnter()
      end,
      OnRefresh = function()
        self:OnClickRefresh()
      end
    })
  end
  self:InitGamePad()
end

function View:BindEvents()
  self.List_Linear.OnUserScrolled:Add(self, self.OnUserScrolled)
  self.List_Linear.OnMouseButtonUp:Add(self, self.ScrollBoxOnMouseButtonUp)
  self.Arrow_R.Btn_Click.OnClicked:Add(self, self.OnBtnRClicked)
  self.Arrow_L.Btn_Click.OnClicked:Add(self, self.OnBtnLClicked)
end

function View:LinearInit()
  self:AddEmptySlot()
  self.Length = #self.LinearList
  for Index, Id in pairs(self.LinearList) do
    local Obj = self:CreateWidgetNew("AutoChessLinearLevel")
    if not self.ItemSizeX then
      local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(Obj.BG)
      self.ItemSizeX = CanvasSlot:GetSize().X
    end
    if not self.SumDistance then
      self:CalculateSumDistance()
    end
    local Param = {}
    if Index < self.Length then
      Param.NextState = self:GetState(self.LinearList[Index + 1])
    end
    Param.Id = Id
    Param.Index = Index
    Param.bFinal = Index == self.Length
    Param.State = self:GetState(Id)
    Param.Parent = self
    Obj:Init(Param, self)
    Obj:BindEventOnClicked(self, self.UpdateSelectedInfo, Obj)
    self.List_Linear:AddChild(Obj)
  end
  self:AddEmptySlot()
  self.List_Linear:SetScrollOffset(0)
  self.SelectedItem = self:FindFirstItem()
  if self.SelectedItem then
    self:UpdateSelectedInfo(self.SelectedItem, nil, false)
  end
end

function View:FindFirstItem()
  local AllChildren = self.List_Linear:GetAllChildren()
  for i = 1, AllChildren:Length() do
    local ChildItem = AllChildren:GetRef(i)
    if ChildItem.State and ChildItem.State == LevelState.UnPass then
      return ChildItem
    end
  end
  for i = AllChildren:Length(), 1, -1 do
    local ChildItem = AllChildren:GetRef(i)
    if ChildItem.State and ChildItem.State == LevelState.Pass then
      return ChildItem
    end
  end
end

function View:OnBtnRClicked()
  local NextIndex = self.SelectedItem.Index + 1
  if NextIndex <= self.Length then
    self:SelectItem(NextIndex)
  end
end

function View:OnBtnLClicked()
  local NextIndex = self.SelectedItem.Index - 1
  if NextIndex >= 1 then
    self:SelectItem(NextIndex)
  end
end

function View:RandomInit()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.RandomId = Avatar.AutoChess.RandomMissionId
  local DungeonId = DataMgr.AutoChessMission[self.RandomId].DungeonId
  self.Level_Random.Text_Name:SetText(GText(DataMgr.Dungeon[DungeonId].DungeonName))
  if self.Level then
    self.Level:SetCallbacks({
      OnBuffEdit = function()
        self:OnClickBuffEdit()
      end,
      OnWeatherEdit = function()
        self:OnClickWeatherEdit()
      end
    })
  end
  self:UpdateRandomDetail()
end

function View:AddEmptySlot()
  local Obj = self:CreateWidgetNew("AutoChessLinearLevel")
  local Param = {}
  Param.Id = -1
  Param.Index = 0
  Param.Size = self.ListSizeX
  Obj:Init(Param)
  self.List_Linear:AddChild(Obj)
end

function View:InitListView()
  self.ChangeSpeedSlow = 5
  if not self.ListSizeX then
    local HpBarGeometry = self.Panel_List_Cut:GetTickSpaceGeometry()
    local Size = UE4.USlateBlueprintLibrary.GetLocalSize(HpBarGeometry)
    self.ListSizeX = Size.X
  end
end

function View:CalculateSumDistance()
  self.SumDistance = (self.Length - 1) * self.ItemSizeX
end

function View:GetTargetIndex(Offset)
  local EndOffset = self.List_Linear:GetScrollOffsetOfEnd()
  local EachItemOffset = EndOffset / (self.Length - 1)
  return math.floor((Offset + EachItemOffset / 2) / EachItemOffset) + 1
end

function View:GetTargetOffsetByIndex(Index)
  local EndOffset = self.List_Linear:GetScrollOffsetOfEnd()
  return (Index - 1) * (EndOffset / (self.Length - 1))
end

function View:OnUserScrolled(CurrentOffset)
  self:ScrolledTo(CurrentOffset, false)
  if not self.DragScrollBox then
    self:AddTimer(0.3, self.ScrollBoxOnMouseButtonUp, false, 0, "ScrollBoxUserScrolledEnd", true)
  end
end

function View:ScrolledTo(CurrentOffset, isAutoScroll)
  if false == isAutoScroll then
    local TargetIndex = self:GetTargetIndex(CurrentOffset)
    if self.SelectedItem.Index ~= TargetIndex then
      local Item = self.List_Linear:GetChildAt(TargetIndex)
      if Item then
        Item:OnCellClicked(nil, true)
      end
    end
  end
end

function View:ScrollBoxOnMouseButtonUp(Geometry, MouseEvent)
  self.DragScrollBox = false
  self.List_Linear:EndInertialScrolling()
  local CurrentOffset = self.List_Linear:GetScrollOffset()
  local TargetIndex = self:GetTargetIndex(CurrentOffset)
  if self.SelectedItem.Index ~= TargetIndex then
    self:SelectItem(TargetIndex)
  else
    local TargetOffset = self:GetTargetOffsetByIndex(TargetIndex)
    self:ScrollToTargetOffset(CurrentOffset, TargetOffset, self.ChangeSpeedSlow)
  end
end

function View:SelectItem(Index)
  local Item = self.List_Linear:GetChildAt(Index)
  if Item then
    Item:OnCellClicked()
  end
end

function View:ScrollToTargetOffset(CurrentOffset, TargetOffset, ChangeSpeed)
  self.List_Linear:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.LerpAlpha = 0
  self.ScrollTimer = self:AddTimer(0.033, function(_, DeltaTime)
    self.LerpAlpha = self.LerpAlpha + ChangeSpeed * DeltaTime
    if self.LerpAlpha >= 1 then
      self.LerpAlpha = 1
      self.List_Linear:SetScrollOffset(TargetOffset)
      self:ScrolledTo(TargetOffset)
      self.List_Linear:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self:RemoveTimer(self.ScrollTimer)
      self.ScrollTimer = nil
      return
    end
    local Offset = UE4.UKismetMathLibrary.Lerp(CurrentOffset, TargetOffset, self.LerpAlpha)
    self.List_Linear:SetScrollOffset(Offset)
    self:ScrolledTo(Offset)
  end, true, 0, "UpdateOffset", true, 0.033)
end

function View:Destruct()
  self.Super.Destruct(self)
  self:RemoveTimer("ScrollBoxUserScrolledEnd")
end

function View:UpdateSelectedInfo(ExperienceItem, Speed, isDragSelect)
  Speed = Speed or self.ChangeSpeedSlow
  if self.SelectedItem and self.SelectedItem ~= ExperienceItem then
    self.SelectedItem:OnUnSelected()
  end
  self.SelectedItem = ExperienceItem
  self.SelectedItem:OnSelected()
  self:AddTimer(0.01, function()
    local CurrentOffset = self.List_Linear:GetScrollOffset()
    local TargetOffset = self:GetTargetOffsetByIndex(self.SelectedItem.Index)
    if true ~= isDragSelect then
      self:ScrollToTargetOffset(CurrentOffset, TargetOffset, Speed)
    end
  end, false, 0, nil, true)
  self:UpdateArrow()
  self:UpdateLinearDetail()
end

function View:UpdateArrow()
  if 1 == self.SelectedItem.Index then
    self.Arrow_L:PlayAnimation(self.Arrow_L.Foridden)
  else
    self.Arrow_L:PlayAnimation(self.Arrow_L.Normal)
  end
  if self.SelectedItem.Index == self.Length then
    self.Arrow_R:PlayAnimation(self.Arrow_R.Foridden)
  else
    self.Arrow_R:PlayAnimation(self.Arrow_R.Normal)
  end
end

function View:UpdateLinearDetail()
  local Info = DataMgr.AutoChessMission[self.SelectedItem.Id]
  self.Details:RefreshLinear(Info, self.SelectedItem.State, self.SelectedItem)
end

function View:OnClickBuff()
  local MissionId
  if self.SelectedItem then
    if self.SelectedItem.State == LevelState.UnLock then
      return
    end
    MissionId = self.SelectedItem.Id
  else
    MissionId = self.RandomId
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  UIManager(self):LoadUINew("AutoChessBuffDetail", MissionId)
end

function View:OnClickMonster()
  local MissionId
  if self.SelectedItem then
    if self.SelectedItem.State == LevelState.UnLock then
      return
    end
    MissionId = self.SelectedItem.Id
  else
    MissionId = self.RandomId
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  UIManager(self):LoadUINew("AutoChessDeputeMonsterInfoUI", MissionId)
end

function View:OnClickBuffEdit()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  local InitParams = {bSkipConfirmSave = true}
  UIManager(self):LoadUINew("AutoChessShareBuff", InitParams)
end

function View:OnClickWeatherEdit()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  UIManager(self):ShowCommonPopupUI(100402, {}, self)
end

function View:UpdateRandomDetail()
  if self.Type ~= AutoChessConst.LevelSelectType.Random then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Info = DataMgr.AutoChessMission[self.RandomId]
  self.Details:RefreshRandom(Info, Avatar, self.RandomId)
  if self.Level then
    self.Level:Refresh(self.RandomId)
  end
end

function View:InitLinearRank()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Rank = Avatar.AutoChess.RankLevel
  local Info = DataMgr.AutoChessPoint[Rank]
  self.Rank.Icon_Rank:SetBrushResourceObject(LoadObject(Info.RankIcon))
  self.Rank.Text_Rank:SetText(GText(Info.RankName))
  self.Rank.Text_Exp:SetText(Avatar.AutoChess.RankScore .. "/" .. Info.RankMaxPoint)
end

function View:OnClickEnter()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Info, ChessMissionId
  if self.Type == AutoChessConst.LevelSelectType.Linear then
    if self.SelectedItem.State == LevelState.UnLock then
      return
    end
    if Model:CheckLinearIsNew(self.SelectedItem.Id) then
      Model:DecreaseLinearReddotById(self.SelectedItem.Id)
    end
    Info = DataMgr.AutoChessMission[self.SelectedItem.Id]
    ChessMissionId = self.SelectedItem.Id
  else
    Info = DataMgr.AutoChessMission[self.RandomId]
    ChessMissionId = self.RandomId
  end
  local CustomParams = {}
  CustomParams.MissionId = ChessMissionId
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_confirm", nil, nil)
  Avatar:EnterEventDungeon(nil, Info.DungeonId, nil, AutoChessConst.ActiveId, CustomParams)
end

function View:OnClickRefresh()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if Avatar.AutoChess.RefreshCount >= DataMgr.GlobalConstant.AUTO_CHESS_MAX_REFRESH.ConstantValue then
    return
  end
  
  local function func()
    self:RandomInit()
  end
  
  Avatar:RefreshRandomMission(func)
end

function View:GetState(Id)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Info = DataMgr.AutoChessMission[Id]
  if Avatar.Dungeons[Info.DungeonId] and Avatar.Dungeons[Info.DungeonId].IsPass then
    return LevelState.Pass
  end
  local TimeUnlock = self:CheckUnlockDay(Info)
  local bPrePass = false
  if Info.UnlockMissionId then
    local PreDungeonId = DataMgr.AutoChessMission[Info.UnlockMissionId].DungeonId
    if Avatar.Dungeons[PreDungeonId] and Avatar.Dungeons[PreDungeonId].IsPass then
      bPrePass = true
    else
      bPrePass = false
    end
  end
  if not Info.UnlockDay and not Info.UnlockMissionId then
    return LevelState.UnPass
  end
  if Info.UnlockDay and not Info.UnlockMissionId then
    if TimeUnlock then
      return LevelState.UnPass
    else
      return LevelState.UnLock
    end
  elseif not Info.UnlockDay and Info.UnlockMissionId then
    if bPrePass then
      return LevelState.UnPass
    else
      return LevelState.UnLock
    end
  elseif Info.UnlockDay and Info.UnlockMissionId then
    if TimeUnlock and bPrePass then
      return LevelState.UnPass
    else
      return LevelState.UnLock
    end
  end
end

function View:CheckUnlockDay(Info)
  local UnlockDay = Info.UnlockDay
  if not UnlockDay then
    return true
  end
  local EventStartTime = DataMgr.EventMain[AutoChessConst.ActiveId].EventStartTime
  local StartTimestamp = EventStartTime:GetTime()
  local CurrentTime = TimeUtils.NowTime()
  local StartDate = os.date("*t", StartTimestamp)
  local RefreshHour = TimeUtils.RefreshHMS[1] or 5
  local RefreshMin = TimeUtils.RefreshHMS[2] or 0
  local RefreshSec = TimeUtils.RefreshHMS[3] or 0
  local FirstRefreshTime = os.time({
    year = StartDate.year,
    month = StartDate.month,
    day = StartDate.day,
    hour = RefreshHour,
    min = RefreshMin,
    sec = RefreshSec
  })
  if StartTimestamp >= FirstRefreshTime then
    FirstRefreshTime = FirstRefreshTime + 86400
  end
  local UnlockTime = FirstRefreshTime + (UnlockDay - 2) * 86400
  if CurrentTime < UnlockTime then
    return false
  end
  return true
end

function View:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  if IsUseKeyAndMouse then
    self.UsingGamepad = false
    self:ShowOrHideGamePad(false)
  else
    self.UsingGamepad = true
    self:ShowOrHideGamePad(true)
    if self:IsVisible() then
      self:SetFocus()
    end
  end
end

function View:InitGamePad()
  if self.Controller_L then
    self.Controller_L:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LB"}
      }
    })
  end
  if self.Controller_R then
    self.Controller_R:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RB"}
      }
    })
  end
  if self.Details then
    self.Details:InitGamePad()
  end
end

function View:ShowOrHideGamePad(bShow)
  if bShow then
    if self.WS_L then
      self.WS_L:SetActiveWidgetIndex(1)
    end
    if self.WS_R then
      self.WS_R:SetActiveWidgetIndex(1)
    end
  else
    if self.WS_L then
      self.WS_L:SetActiveWidgetIndex(0)
    end
    if self.WS_R then
      self.WS_R:SetActiveWidgetIndex(0)
    end
  end
  self.Details:ShowOrHideGamePad(bShow)
  if self.Type == AutoChessConst.LevelSelectType.Random then
    self.Level:ShowOrHideGamePad(bShow)
  end
end

function View:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftShoulder" == InKeyName then
    if self.Type == AutoChessConst.LevelSelectType.Linear then
      self:OnBtnLClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Gamepad_RightShoulder" == InKeyName then
    if self.Type == AutoChessConst.LevelSelectType.Linear then
      self:OnBtnRClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Gamepad_DPad_Down" == InKeyName then
    self:OnClickBuff()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_DPad_Up" == InKeyName then
    self:OnClickMonster()
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    if self.SelectedItem and self.SelectedItem.State == LevelState.UnLock then
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
    self:ShowOrHideGamePad(false)
    if self.Details then
      self.Details:SetRewardListFocus()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    if self.Type == AutoChessConst.LevelSelectType.Random then
      self:OnClickRefresh()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    if (not self.Details or not self.Details:HasRewardListFocus()) and self.Type == AutoChessConst.LevelSelectType.Random then
      self:OnClickBuffEdit()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Gamepad_RightThumbstick" == InKeyName then
    if (not self.Details or not self.Details:HasRewardListFocus()) and self.Type == AutoChessConst.LevelSelectType.Random then
      self:OnClickWeatherEdit()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  elseif "Gamepad_FaceButton_Right" == InKeyName then
    if self.Details and self.Details:HasRewardListFocus() then
      self:SetFocus()
      self:ShowOrHideGamePad(true)
      return UE4.UWidgetBlueprintLibrary.Handled()
    else
      return UE4.UWidgetBlueprintLibrary.Unhandled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == InKeyName then
    self:OnClickEnter()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function View:OnFocusReceived(MyGeometry, InFocusEvent)
  self:SetFocus()
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function View:OnPagePoped()
  if self.Type == AutoChessConst.LevelSelectType.Linear then
    Model:DecreaseLinearReddotById()
  end
  AudioManager(self):SetEventSoundParam(self, "SelectOpen", {ToEnd = 1})
end

return View
