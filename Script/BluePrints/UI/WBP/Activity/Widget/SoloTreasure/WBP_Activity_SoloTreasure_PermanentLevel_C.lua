require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local PermanentSoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.PermanentSoloTreasureDataModel")
local UIUtils = require("Utils.UIUtils")
local TimeUtils = require("Utils.TimeUtils")
M._components = {
  "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_SoloTreasure_PermanentLevel_GamepadComp",
  "BluePrints.UI.WBP.Activity.Widget.SoloTreasure.WBP_Activity_Solotreasure_Level_LoadSceneComp"
}
M.LevelLockType = {
  None = 0,
  Time = 1,
  Condition = 2
}

function M:Construct()
  self.LevelDetails.Btn_Prepare.Button_Area.OnClicked:Add(self, self.OnPrepareClicked)
  self.LevelDetails.Btn_Qa_CoinTip.Btn_Click.OnClicked:Add(self, self.OnCoinTip)
  self:InitGamePad()
  MissionIndicatorManager:TriggerAllIndicatorVisible(false)
end

function M:Destruct()
  if self.ActorController then
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
  MissionIndicatorManager:TriggerAllIndicatorVisible(true)
end

function M:SetEntranceButtonsVisible(bVisible)
  local V = bVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  if self.Root then
    if self.Root.Entrance_Illustrated then
      self.Root.Entrance_Illustrated:SetVisibility(V)
    end
    if self.Root.Entrance_Shop then
      self.Root.Entrance_Shop:SetVisibility(V)
    end
    if self.Root.Entrance_Reward then
      self.Root.Entrance_Reward:SetVisibility(V)
    end
  end
end

function M:SwitchIn(Mode, bIsDifficult, EventDugeonId)
  self.SeasonId = PermanentSoloTreasureDataModel:GetCurrentSeasonId()
  self.EventId = PermanentSoloTreasureDataModel:GetSeasonEventId(self.SeasonId)
  if self.Root then
    self.Root.EventId = self.EventId
  end
  self.DefaultEventDugeonId = EventDugeonId
  if nil ~= bIsDifficult and not self.bReturningFromPrepare then
    self.InitialDifficulty = (true == bIsDifficult or "true" == bIsDifficult) and "Hard" or "Normal"
    self.CurDifficulty = self.InitialDifficulty
  end
  self:SetEntranceButtonsVisible(true)
  self:LoadDataFromModel()
  self:LoadPermanentSkyBoxScene()
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_main_page_in", nil, nil)
  self:InitStaticUI()
  self:InitTable()
  self:InitSelectLevelList()
  self:InitDifficultyDropdown()
  PermanentSoloTreasureDataModel:RefreshLevelListNewReddot(self.SeasonId)
  if self.Title and self.SeasonId then
    self.Title:Init(self.SeasonId)
  end
end

function M:SwitchOut()
  self:SetEntranceButtonsVisible(false)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if self.ActorController then
    self.ActorController:OnDestruct()
    self.ActorController = nil
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if self.bClosing then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleGamepadInput(MyGeometry, InKeyEvent)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnReturnKeyDown()
  if self.bClosing then
    return
  end
  self.bClosing = true
  if self.Out then
    self:PlayAnimation(self.Out)
  else
    self.bClosing = false
    if self.Root and self.Root.OnCloseAll then
      self.Root:OnCloseAll()
    end
  end
end

function M:OnAnimationFinished(Animation)
  if Animation == self.Out then
    self.bClosing = false
    if self.Root and self.Root.OnCloseAll then
      self.Root:OnCloseAll()
    end
  end
end

local SoloSequencePath = "/Game/UI/Sequence/SQ_FengXiang_GUI4.SQ_FengXiang_GUI4"

function M:LoadPermanentSkyBoxScene()
  self:CreateActorController()
  if not self.ActorController then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local CharId = DataMgr.Player2RoleId.Player[Avatar.Sex]
  if CharId then
    self.ActorController:ChangeCharModel({CharId = CharId}, true, true)
    self.ActorController:ChangeCharAppearance({})
  end
  if self.ActorController.TryCreateSequenceActorController then
    self.ActorController:TryCreateSequenceActorController()
  end
  self.ActorController:PlaySequence({
    SequencePath = SoloSequencePath,
    MontagePath = "Story_Fengxiang_Montage",
    ActorRotation = FRotator(0, -68.31257629999999, 0)
  })
end

function M:LoadDataFromModel()
  if not self.SeasonId then
    return
  end
  self.LevelData = PermanentSoloTreasureDataModel:GetRepeatLevelDataBySeasonId(self.SeasonId)
end

function M:ReceiveEnterStateSelf(StackAction)
  if self.Root and self.Root.GetCurrentSubUI and self.Root:GetCurrentSubUI() ~= self then
    return
  end
  if self.ActorController and self.ActorController:HasLastSequenceInfo() then
    self.ActorController:ReplaySequence()
    self.ActorController:ClearLastSequenceInfo()
  else
    self:LoadPermanentSkyBoxScene()
  end
  if UIUtils.IsGamepadInput() and self.CurrentIndex then
    self:SetFocusState(self.FocusState.Focus1)
    local Entry = self:GetEntryByIndex(self.CurrentIndex)
    if Entry then
      Entry:SetFocus()
    end
  end
end

function M:ReceiveExitStateSelf(StackAction)
  if self.ActorController then
    self.ActorController:StopSequence()
  end
end

function M:InitStaticUI()
  if not self.LevelDetails then
    return
  end
  if self.LevelDetails.Text_Desc then
    self.LevelDetails.Text_Desc:SetText(GText("UI_SoloTreasure_LevelDes"))
  end
  if self.LevelDetails.Text_TimeDesc then
    self.LevelDetails.Text_TimeDesc:SetText(GText("UI_SoloTreasure_LimitTime"))
  end
  if self.LevelDetails.Text_CostDesc then
    self.LevelDetails.Text_CostDesc:SetText(GText("UI_SoloTreasureEvent_EntryCost"))
  end
  if self.LevelDetails.Btn_Prepare.Text_Button then
    self.LevelDetails.Btn_Prepare.Text_Button:SetText(GText("UI_SoloTreasureEvent_EntryArmory"))
    self.LevelDetails.Btn_Prepare:BindPrepareBtnState()
  end
  if self.LevelDetails.WS_Type then
    local bPlayable = PermanentSoloTreasureDataModel:IsSeasonPlayable(self.SeasonId)
    self.bSeasonClosed = not bPlayable
    self.LevelDetails.WS_Type:SetActiveWidgetIndex(bPlayable and 0 or 1)
    if self.LevelDetails.Text_Forbid then
      self.LevelDetails.Text_Forbid:SetText(GText("UI_Play_TreasureHunt_DungeonClosed"))
    end
    if self.LevelDetails.Panel_CostInfo then
      self.LevelDetails.Panel_CostInfo:SetVisibility(bPlayable and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
    end
  end
end

function M:InitTable()
  self.bCanShowRV = false
  self.TabConfigData = {
    TitleName = GText("UI_SoloTreasure_LevelChooseTitle"),
    DynamicNode = {
      "Back",
      "BottomKey",
      "ResourceBar"
    },
    StyleName = "Text",
    OwnerPanel = self.Root,
    BackCallback = self.Root and self.Root.OnReturnKeyDown
  }
  self.TabConfigData.BottomKeyInfo = {
    {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.Root and self.Root.OnReturnKeyDown,
          Owner = self.Root
        }
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("UI_BACK"),
      bLongPress = false
    }
  }
  self:SetFocusState(self.FocusState.Focus1)
  if self.Root and type(self.Root.InitOtherPageTab) == "function" then
    self.Root:InitOtherPageTab(self.TabConfigData, nil, true)
  end
end

function M:InitSelectLevelList()
  if not self.List_Level then
    return
  end
  self.List_Level:ClearListItems()
  if not self.LevelData or 0 == #self.LevelData then
    return
  end
  local LatestUnlockedIndex, TargetIndex
  local PrevSelectedIndex = self.CurrentIndex
  for Index = 1, #self.LevelData do
    local Row = self.LevelData[Index]
    local LevelObj = NewObject(UIUtils.GetCommonItemContentClass())
    LevelObj.Index = Index
    LevelObj.DungeonName = Row.DungeonName
    LevelObj.EventDungeonId = Row.EventDugeonId
    LevelObj.UnlockDate = Row.UnlockDate
    LevelObj.DungeonImage = Row.DungeonImage
    LevelObj.IsSelected = false
    LevelObj.Parent = self
    LevelObj.bIsExtraLevel = self:IsExtraLevelRow(Row)
    local LockType, Remain = self:GetLevelLockInfo(Row)
    LevelObj.LockType = LockType
    LevelObj.RemainSeconds = Remain
    LevelObj.bForbidden = LockType ~= self.LevelLockType.None
    if not LevelObj.bForbidden then
      LatestUnlockedIndex = Index
    end
    LevelObj.EventId = PermanentSoloTreasureDataModel:GetSeasonEventId(self.SeasonId)
    LevelObj.ReddotNode = "SoloTreasure_Permanent_LevelListView"
    
    function LevelObj.IsReadCallback(EventId, Idx)
      return PermanentSoloTreasureDataModel:IsLevelEntryRead(EventId, Idx)
    end
    
    function LevelObj.OnBtnClickedCallback(Idx)
      self:OnLevelBtnClicked(Idx)
    end
    
    function LevelObj.OnFocusReceivedCallback(EntryWidget)
      if UIUtils.IsGamepadInput() then
        self.CurrentIndex = Index
        if EntryWidget then
          self.LastFocusWidget = EntryWidget
        end
        if not LevelObj.bForbidden then
          self:SelectLevelItem(Index)
        end
      end
    end
    
    self.List_Level:AddItem(LevelObj)
  end
  if self.DefaultEventDugeonId then
    local Idx = self:FindIndexByEventDungeonId(self.DefaultEventDugeonId)
    if Idx then
      TargetIndex = Idx
    end
    self.DefaultEventDugeonId = nil
  elseif PrevSelectedIndex then
    local PrevObj = PrevSelectedIndex and self.List_Level:GetItemAt(PrevSelectedIndex - 1)
    if PrevObj and not PrevObj.bForbidden then
      TargetIndex = PrevSelectedIndex
    else
      TargetIndex = LatestUnlockedIndex or 1
    end
  else
    TargetIndex = LatestUnlockedIndex or 1
  end
  self.LatestUnlockedIndex = LatestUnlockedIndex or 1
  self.CurrentIndex = TargetIndex
  self.OldIndex = 0
  local Obj = self.List_Level:GetItemAt(TargetIndex - 1)
  if Obj then
    Obj.IsSelected = true
  end
  self:SelectLevelItem(self.CurrentIndex)
end

function M:FindIndexByEventDungeonId(EventDugeonId)
  if not EventDugeonId or not self.LevelData then
    return nil
  end
  for i, Row in ipairs(self.LevelData) do
    if Row.EventDugeonId == EventDugeonId then
      return i
    end
  end
  return nil
end

function M:SelectLevelItem(Index)
  if not (Index and self.LevelData) or not self.LevelData[Index] then
    return
  end
  local Row = self.LevelData[Index]
  local bIsExtraLevel = self:IsExtraLevelRow(Row)
  self.CurEventDungeonId = Row.EventDugeonId
  local PrevIndex = self.OldIndex
  if self.OldIndex ~= Index then
    self:RefreshDungeonDetail(Index, bIsExtraLevel)
    self:RefreshDifficultyAreaByRow(Row)
    self:ChangeHightlight(Index, PrevIndex)
  end
  self.OldIndex = Index
  self.List_Level:SetSelectedIndex(Index - 1)
  self.List_Level:NavigateToIndex(Index - 1)
  PermanentSoloTreasureDataModel:MarkLevelEntryRead(self.SeasonId, Index)
end

function M:RefreshDungeonDetail(Index, bIsExtraLevel)
  self.LevelDetails:PlayAnimation(self.LevelDetails.Refresh)
  if not self.LevelData then
    return
  end
  local TargetRow = self.LevelData[Index]
  if self.LevelDetails.Text_Info then
    self.LevelDetails.Text_Info:SetText(GText(TargetRow.DungeonDes))
  end
  if self.LevelDetails.Text_Map then
    self.LevelDetails.Text_Map:SetText(GText(TargetRow.DungeonName))
  end
  if self.LevelDetails.Img_Map and TargetRow.DungeonImage then
    local MapImgObj = LoadObject(TargetRow.DungeonImage)
    if MapImgObj then
      self.LevelDetails.Img_Map:SetBrushFromTexture(MapImgObj)
    end
  end
  local ResourceId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  if bIsExtraLevel then
    self.bCanShowRuleTip = true
    self.LevelDetails.Panel_CoinTip:SetVisibility(UE4.ESlateVisibility.Visible)
    self.LevelDetails.Text_CoinTip:SetText(GText("UI_SoloTreasure_TicketLevelDes"))
    ResourceId = DataMgr.GlobalConstant.SoloTreasureTicketResourceId.ConstantValue
  else
    self.bCanShowRuleTip = false
    if self.LevelDetails.Panel_CoinTip then
      self.LevelDetails.Panel_CoinTip:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  local CoinIconPath = DataMgr.Resource[ResourceId].Icon
  local CoinObj = LoadObject(CoinIconPath)
  if CoinObj then
    self.LevelDetails.Icon_Cost:SetBrushFromTexture(CoinObj)
  end
end

function M:ChangeHightlight(NewLevelIndex, OldLevelIndex)
  local NewLevelData = self.List_Level:GetItemAt(NewLevelIndex - 1)
  local OldLevelData = self.List_Level:GetItemAt(OldLevelIndex - 1)
  if OldLevelData and not OldLevelData.bForbidden then
    OldLevelData.IsSelected = false
  end
  if NewLevelData and not NewLevelData.bForbidden then
    NewLevelData.IsSelected = true
  end
  local OldEntry = self:GetEntryByIndex(OldLevelIndex)
  local NewEntry = self:GetEntryByIndex(NewLevelIndex)
  if OldEntry and not OldLevelData.bForbidden then
    OldEntry:SetSelected(OldLevelData.IsSelected)
  end
  if NewEntry and not NewLevelData.bForbidden then
    NewEntry:SetSelected(NewLevelData.IsSelected)
  end
end

function M:GetEntryByIndex(Index)
  local AllEntries = self.List_Level:GetDisplayedEntryWidgets()
  for _, Entry in pairs(AllEntries) do
    if Index == Entry.Content.Index then
      return Entry
    end
  end
  return nil
end

function M:OnLevelBtnClicked(Index)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/sdc_chapter_btn_click", nil, nil)
  self.CurrentIndex = Index
  self:SelectLevelItem(Index)
end

function M:InitDifficultyDropdown()
  local DifficultyList = {
    "UI_SoloTreasure_NormalMode",
    "UI_SoloTreasure_HardMode"
  }
  self.LevelDetails.Btn_Difficulty:Init(DifficultyList, "X", self)
  self.LevelDetails.Btn_Difficulty:BindEventOnSelectionsChanged(self, self.OnDifficultyChanged)
  if self.InitialDifficulty and self.CurDifficulty then
    local Idx = self.CurDifficulty == "Hard" and 2 or 1
    self.LevelDetails.Btn_Difficulty:SelectItem(Idx)
  else
    self.LevelDetails.Btn_Difficulty:SelectItem(1)
  end
  self.InitialDifficulty = nil
end

function M:RefreshDifficultyAreaByRow(Row)
  if not self.LevelDetails or not self.LevelDetails.Btn_Difficulty then
    return
  end
  local bHasDropdown = self:HasDifficultyDropdown(Row)
  self.bHasDifficultyDropdown = bHasDropdown
  self.LevelDetails.Btn_Difficulty:SetVisibility(bHasDropdown and UE4.ESlateVisibility.Visible or UE4.ESlateVisibility.Collapsed)
  if bHasDropdown then
    if not self.CurDifficulty then
      self.CurDifficulty = "Normal"
    end
    local Idx = self.CurDifficulty == "Hard" and 2 or 1
    self.LevelDetails.Btn_Difficulty:SelectItem(Idx)
    self:RefreshTimeAndCostByDifficulty(self.CurDifficulty)
  else
    local Fee, DungeonId = 0
    if self:IsValidCell(Row.EasyModeFee) and self:IsValidCell(Row.EasyDungeonId) then
      Fee = Row.EasyModeFee
      DungeonId = Row.EasyDungeonId
    elseif self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId) then
      Fee = Row.HardModeFee
      DungeonId = Row.HardDungeonId
    end
    if DungeonId then
      local TimeStr = self:FormatTimeMS(PermanentSoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId))
      if self.LevelDetails.Text_Cost then
        self.LevelDetails.Text_Cost:SetText(tostring(Fee))
      end
      if self.LevelDetails.Text_Time then
        self.LevelDetails.Text_Time:SetText(TimeStr)
      end
    end
  end
end

function M:OnDifficultyChanged(SortIndex)
  local Row = self.LevelData and self.LevelData[self.CurrentIndex]
  if Row and not self:HasDifficultyDropdown(Row) then
    return
  end
  self.CurDifficulty = 1 == SortIndex and "Normal" or "Hard"
  self:RefreshTimeAndCostByDifficulty(self.CurDifficulty)
end

function M:RefreshTimeAndCostByDifficulty(Difficulty)
  if not self.CurEventDungeonId then
    return
  end
  local isHard = "Hard" == Difficulty
  local TargetRow
  for _, Row in ipairs(self.LevelData) do
    if Row.EventDugeonId == self.CurEventDungeonId then
      TargetRow = Row
      break
    end
  end
  if not TargetRow then
    return
  end
  local Fee = isHard and TargetRow.HardModeFee or TargetRow.EasyModeFee
  local DungeonId = isHard and TargetRow.HardDungeonId or TargetRow.EasyDungeonId
  local TimeStr = self:FormatTimeMS(PermanentSoloTreasureDataModel:GetDungeonGameTotalTime(DungeonId))
  if self.LevelDetails.Text_Cost then
    self.LevelDetails.Text_Cost:SetText(tostring(Fee))
  end
  if self.LevelDetails.Text_Time then
    self.LevelDetails.Text_Time:SetText(TimeStr)
  end
end

function M:IsDifficult()
  local Row = self.LevelData and self.LevelData[self.CurrentIndex]
  if not Row then
    return nil
  end
  if self:HasDifficultyDropdown(Row) then
    return self.CurDifficulty == "Hard"
  end
  if self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId) then
    return true
  end
  return false
end

function M:OnPrepareClicked()
  if self.bSeasonClosed then
    return
  end
  local bIsDifficult = self:IsDifficult()
  AudioManager(self):PlayUISound(self.LevelDetails.Btn_Prepare, "event:/ui/activity/sdc_normal_btn_click_confirm", nil, nil)
  local Row = self.LevelData and self.LevelData[self.CurrentIndex]
  local DungeonId = Row and (bIsDifficult and Row.HardDungeonId or Row.EasyDungeonId or Row.HardDungeonId)
  if DungeonId and not self:EnsureOptionalPatchDownloaded(DungeonId) then
    return
  end
  DebugPrint("------------------[常驻选关] 当前关卡：", self.CurEventDungeonId)
  self.Root:OpenSubUI({
    Idx = "ActivitySoloTreasurePrepare"
  }, 1, self.CurEventDungeonId, bIsDifficult)
end

function M:OnCoinTip()
  AudioManager(self):PlayUISound(self.LevelDetails.Btn_Qa_CoinTip, "event:/ui/common/click_btn_small", nil, nil)
  self:OnRuleTipPressed()
end

function M:EnsureOptionalPatchDownloaded(DungeonId)
  local PatchCond = DataMgr.DungeonPatchCondition and DataMgr.DungeonPatchCondition[DungeonId]
  local NecessaryPatch = PatchCond and PatchCond.NecessaryPatch
  if not NecessaryPatch or 0 == #NecessaryPatch then
    return true
  end
  local HotUpdateSubsystem = UE4.USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, UE4.UHotUpdateSubsystem)
  if not HotUpdateSubsystem then
    return true
  end
  if not HotUpdateSubsystem:IsAllPatchOptionalSignsDownloaded(NecessaryPatch) then
    UIManager(self):LoadUINew("OptionalPatch", NecessaryPatch)
    return false
  end
  return true
end

function M:IsValidCell(Value)
  if nil == Value then
    return false
  end
  if type(Value) == "string" then
    return "" ~= Value
  end
  return true
end

function M:HasDifficultyDropdown(Row)
  if not Row then
    return false
  end
  return self:IsValidCell(Row.EasyModeFee) and self:IsValidCell(Row.EasyDungeonId) and self:IsValidCell(Row.HardModeFee) and self:IsValidCell(Row.HardDungeonId)
end

function M:IsExtraLevelRow(Row)
  if not Row then
    return false
  end
  return self:IsValidCell(Row.EasyScoreToResource) and self:IsValidCell(Row.EasyMaxConvertResource) and self:IsValidCell(Row.HardScoreToResource) and self:IsValidCell(Row.HardMaxConvertResource)
end

function M:GetLevelLockInfo(Row)
  if Row.UnlockDate and TimeUtils.NowTime() < Row.UnlockDate then
    return self.LevelLockType.Time, math.max(0, Row.UnlockDate - TimeUtils.NowTime())
  end
  local Avatar = GWorld:GetAvatar()
  if not ConditionUtils.CheckCondition(Avatar, Row.UnlockCondition) then
    return self.LevelLockType.Condition, 0
  end
  return self.LevelLockType.None, 0
end

function M:FormatTimeMS(totalSeconds)
  if not totalSeconds or totalSeconds < 0 then
    return "0:00"
  end
  local minutes = math.floor(totalSeconds / 60)
  local seconds = totalSeconds % 60
  return string.format("%d:%02d", minutes, seconds)
end

function M:ShowLockedToastByObj(LevelObj)
  if not LevelObj then
    return
  end
  UIManager(self):ShowUITip(UIConst.Tip_CommonTop, "完成前置关卡后解锁（待包装）")
end

function M:FormatRemainTimeForToast(sec)
  sec = math.max(0, math.floor(tonumber(sec) or 0))
  local day = math.floor(sec / 86400)
  local hour = math.floor(sec % 86400 / 3600)
  local min = math.floor(sec % 3600 / 60)
  if day > 0 then
    return string.format("%s%s", string.format(GText("UI_Time_Day"), day), string.format(GText("UI_Time_Hour"), hour))
  elseif hour > 0 then
    return string.format("%s%s", string.format(GText("UI_Time_Hour"), hour), string.format(GText("UI_Time_Minute"), min))
  else
    return string.format(GText("UI_Time_Minute"), math.max(1, min))
  end
end

AssembleComponents(M)
return M
