require("UnLua")
local UIUtils = require("Utils.UIUtils")
local ChatCommon = require("BluePrints.UI.WBP.Chat.ChatCommon")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")
local AllPlayerBloodState = require("BluePrints.UI.BloodBar.BloodBarUtils").AllBloodState
local EMCache = require("EMCache.EMCache")
local WBP_Battle_C = Class("BluePrints.UI.BP_UIState_C")
WBP_Battle_C._components = {
  "BluePrints.UI.WBP.Chat.View.WBP_Battle_C_ChatComp",
  "BluePrints.UI.WBP.Team.View.WBP_Battle_C_TeamComp"
}

function WBP_Battle_C:Construct()
  WBP_Battle_C.Super.Construct(self)
  if self.Platform == nil then
    self.Platform = CommonUtils.GetDeviceTypeByPlatformName(self)
  end
  self.OnVisibilityChanged:Add(self, function(self, Visibility)
    if self:IsVisible() then
      UIManager():TryResumeAfterLoadingMgr({
        "TriggerGuide",
        "MainLineQuest",
        "DynamicQuest"
      })
      self:_RefreshEscReddot()
    end
  end)
  self.ColorAndOpacityDelegate:Bind(self, function(self)
    if 1 == self.ColorAndOpacity.SpecifiedColor.A then
      UIManager():TryResumeAfterLoadingMgr({
        "TriggerGuide",
        "MainLineQuest",
        "DynamicQuest"
      })
      self:_RefreshEscReddot()
    end
  end)
  self.PlayInOutSystems = {}
end

function WBP_Battle_C:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self:TryRecoverUI()
  self:InitUID()
  self:InitChat()
  self:InitTeam()
  self:ListenForInputAction("OpenArmory", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenArmory
  })
  self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenBag
  })
  self:ListenForInputAction("OpenPlay", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenPlay
  })
  self:ListenForInputAction("OpenTask", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenTaskPanel
  })
  self:ListenForInputAction("OpenMenu", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenCommonSetup
  })
  self:ListenForInputAction("OpenGuideBook", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenGuideBook
  })
  self:ListenForInputAction("OpenEvent", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenEvent
  })
  self:ListenForInputAction("OpenForge", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenForge
  })
  self:ListenForInputAction("OpenGacha", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenGacha
  })
  self:ListenForInputAction("OpenBattlePass", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenBattlePass
  })
  self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Pressed, false, {
    self,
    self.ShowSystemEntrance
  })
  self:ListenForInputAction("GamepadOpenSystem", EInputEvent.IE_Released, false, {
    self,
    self.CloseSystemEntrance
  })
  self:AddDispatcher(EventID.ShowTeammateBloodUI, self, self.AddTeammateUI)
  self:AddDispatcher(EventID.CloseTeammateBloodUI, self, self.RemoveTeammateUI)
  self:AddDispatcher(EventID.OnMainUIReddotUpdate, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.OnCompleteProduce, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.OnBlueComplete, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.OnAchvRedPoint, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.CharDie, self, self.OnTeammateDie)
  self:AddDispatcher(EventID.CharRecover, self, self.OnTeammateRecovery)
  self:AddDispatcher(EventID.OnGotTopicReward, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.OnReceiveNewQuest, self, self.UpdateRedDotStates)
  self:AddDispatcher(EventID.UnLoadUI, self, self.OnSystemUIUnLoad)
  self:AddDispatcher(EventID.OnChangeKeyBoardSet, self, self.InitBtnList)
  self:AddDispatcher(EventID.OnSwitchRole, self, self.OnSwitchRole)
  self:AddDispatcher(EventID.OnHomeBaseBtnPlayAnim, self, self.OnHomeBaseBtnPlayAnim)
  self:AddDispatcher(EventID.ShowOrHideMainPlayerBloodUI, self, self.ShowOrHideMainPlayerBloodUI)
  self:AddDispatcher(EventID.EndRougeCanonMiniGame, self, self.OnEndRougeCanonMiniGame)
  self:AddDispatcher(EventID.OnTempleRightUI, self, self.OnTempleRightUI)
  self:AddDispatcher(EventID.OnPartyProgressStart, self, self.OnPartyProgressStart)
  self:AddDispatcher(EventID.OnModBookQuestFinished, self, self.OnModBookQuestFinished)
  self:AddDispatcher(EventID.OnNotifyShowLargeCountDown, self, self.OnNotifyShowLargeCountDown)
  self:AddDispatcher(EventID.OnNewDetectiveQuestion, self, self.OnNewDetectiveQuestion)
  self:AddDispatcher(EventID.OnHomeBaseeBtnShowNewClue, self, self.OnHomeBaseeBtnShowNewClue)
  self:AddDispatcher(EventID.OnEnableGuideBookKey, self, self.EnableGuideBookKey)
  self:AddDispatcher(EventID.OnTheaterJoinPerformGame, self, self.TheaterJoinPerformGame)
  self:AddDispatcher(EventID.OnTheaterPerformGameStart, self, self.TheaterPerformGameStart)
  self:AddDispatcher(EventID.OnTheaterPerformGameNotice, self, self.OnTheaterPerformGameNotice)
  self:AddDispatcher(EventID.OnTeleportReady, self, self.TeleportReady)
  local NodeName = DataMgr.ReddotNode.Quest.Name
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    ReddotManager.AddListenerEx(NodeName, self, function(self, Count, RdType, RdName)
      if Count > 0 then
        self.Btn_Task.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
      else
        self.Btn_Task.Common_Item_Subsize_New_PC:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    end)
  end
  if not self:InitWithMainCharacter() then
    self:AddDispatcher(EventID.CloseLoading, self, self.InitWithMainCharacter)
  end
  self.SystemHideTags = {}
  self.IsPlayOutAnim = false
  self.HideGuideBookBtn = false
  self.HideSystemEntrance = false
  self:InitConditionMapSystem()
  self.VB_Teammate_Phantom:ClearChildren()
  self.VB_Teammate_Phantom:SetVisibility(UE4.ESlateVisibility.Collapsed)
  if self.Battle_Char_PC_0 then
    self.Battle_Char_PC_0:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.Char_Skill:InitSkillAfterCharInitReady()
  else
    self.Char_Skill:InitSkillAfterCharInitReady()
  end
  self.PlayerBloodBar = self.HUD_MainBar
  self.Battle_Map.Battle = self
  self.Map_Img:SetVisibility(ESlateVisibility.Collapsed)
  self:PlayAnimation(self.CollapsedMap)
  self.Battle_Map:SetVisibility(0)
  if self.Btn_Close then
    self.Btn_Close.OnClicked:Clear()
    self.Btn_Close.OnClicked:Add(self, self.OnBattleMapClose)
  end
  self:SetOverrideInfo(self.SizeMap_Original, self.Task_Normal)
  self.RetainerBox_0:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Task:ClearChildren()
  self.Pos_Weekly:ClearChildren()
  self.Pos_Abyss_CountDown:ClearChildren()
  self.Pos_Abyss_CountDown_1:ClearChildren()
  self.Pos_ModAchive:ClearChildren()
  self.Pos_TempleProgress:ClearChildren()
  self.Pos_Weekly_Buff:ClearChildren()
  self.Pos_GuildWarScore:ClearChildren()
  self.Pos_LowHealth:ClearChildren()
  self.Pos_Rouge_CountDown:ClearChildren()
  self.Pos_TempleRight:ClearChildren()
  self.TeammateEidSet = {}
  self:HidePlayerDeadUI()
  self:InitKeyTip()
  self:HideDynamicEventUI()
  self:CreatTakeAimIndicator()
  self.Btn_Task.IsBtnTask = true
  self:InitGameJumpWord()
  self:CheckTheaterEventState()
end

function WBP_Battle_C:GetOrAddWidget(WidgetName, NodeToAdd)
  local Widget = NodeToAdd:GetChildAt(0)
  if Widget then
    return Widget
  end
  local Widget = self:CreateWidgetNew(WidgetName)
  if Widget then
    NodeToAdd:AddChild(Widget)
    NodeToAdd:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    DebugPrint("CreateWidget failed! Widget name: ", WidgetName)
  end
  return Widget
end

function WBP_Battle_C:GetWidget(WidgetName, NodeToAdd)
  local Widget = NodeToAdd:GetChildAt(0)
  return Widget
end

function WBP_Battle_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
  self.CurGamepadName = UIUtils.UtilsGetCurrentGamepadName()
  self:InitKeyTip()
end

function WBP_Battle_C:InitWithMainCharacter()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not Player then
    return false
  end
  self.HUD_MainBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.HUD_MainBar:InitConfig(Player)
  self:AddTimer(0.5, function()
    if not Player:CheckCanChangeToMaster() then
      self:ShowOrHideMainPlayerBloodUI(true, "ChangeRoleToMaster")
    end
  end, false)
  self:InitDataPhone()
  return true
end

function WBP_Battle_C:GetOrAddDynamicEventWidget()
  self.Pos_DynamicEvent:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  return self:GetOrAddWidget("DynamicEvent", self.Pos_DynamicEvent)
end

function WBP_Battle_C:GetDynamicEventWidget()
  return self:GetWidget("DynamicEvent", self.Pos_DynamicEvent)
end

function WBP_Battle_C:AddTempleRightKeyTextDesc()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local TempleData = DataMgr.Temple[GameState.DungeonId]
  local FbdRule = TempleData.FbdRule
  self.ForbidInfo = self:TempleForbidSkills(FbdRule)
  if not self.ForbidInfo then
    return
  end
  for i = 1, #self.ForbidInfo do
    local RightKeyTextDescData = NewObject(UE4.LoadClass(UIConst.DUNGEONCOMRIGHTKEYTEXTDESCDATA))
    RightKeyTextDescData.Owner = self
    RightKeyTextDescData.Index = i
    self.List_TrainingSetting:AddItem(RightKeyTextDescData)
  end
end

function WBP_Battle_C:InitTrainingKeyTip()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if Player.UIModePlatform == "PC" then
    local KeyDescWidget = self:GetOrAddWidget("TrainingSetting_P", self.Task)
    KeyDescWidget:InitView()
    self:AddTrainingRightKeyListeners()
  else
    local TrainingSetting = self:GetOrAddWidget("TrainingSetting_M", self.Task)
    TrainingSetting.Parent = self
    TrainingSetting:InitView()
  end
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar:SetUIVisibilityTag("Training", true)
  end
end

function WBP_Battle_C:InitTrailKeyTip()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if Player.UIModePlatform == "PC" then
    local CurInputDeviceType = UIUtils.UtilsGetCurrentInputType()
    if CurInputDeviceType == UE4.ECommonInputType.Gamepad then
      local KeyDescWidget = self:GetOrAddWidget("BattleKeyDescList", self.Pos_KeyTip)
      local CommonKeyDatas = {
        {
          Type = "Img",
          DescText = GText("UI_Keyboard_Map_OpenArmory"),
          ImgShortPath = UIUtils.GetIconListByActionName("OpenArmory")
        },
        {
          Type = "Img",
          DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
          ImgShortPath = UIUtils.GetIconListByActionName("TrainingCharacterSkills")
        }
      }
      KeyDescWidget:InitKey(CommonKeyDatas)
      self:AddTrialRightKeyListeners()
    else
      local KeyDescWidget = self:GetOrAddWidget("BattleKeyDescList", self.Pos_KeyTip)
      if KeyDescWidget then
        KeyDescWidget:SetVisibility(UE4.ESlateVisibility.Visible)
        local CommonKeyDatas = {}
        self:AddTrialRightKeyListeners()
        local Data = DataMgr.KeyboardMap.TrainingCharacterSkills
        local KeyText = "F2"
        if Data then
          local KeyText = Data.Key
        end
        table.insert(CommonKeyDatas, {
          Type = "Text",
          Text = KeyText,
          DescText = GText("UI_DUNGEON_DES_TRAINING_2"),
          CallbackObj = self,
          CallbackFunc = self.TrialCharacterSkills
        })
        KeyDescWidget:InitKey(CommonKeyDatas)
      end
    end
  else
  end
end

function WBP_Battle_C:UnInitTrainingKeyTip()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Pos_KeyTip:ClearChildren()
  if Player.UIModePlatform == "Mobile" then
    self.Pos_Training:ClearChildren()
  end
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar:SetUIVisibilityTag("Training", false)
  end
end

function WBP_Battle_C:UnInitTrialKeyTip()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Pos_KeyTip:ClearChildren()
  if Player.UIModePlatform == "Mobile" then
    self.Pos_Training:ClearChildren()
  end
end

function WBP_Battle_C:UnInitTemple()
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar:SetUIVisibilityTag("Temple", false)
    TaskBar:SetUIVisibilityTag("Party", false)
  end
end

function WBP_Battle_C:InitKeyTip()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Training" then
    self:InitTrainingKeyTip()
  elseif nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Temple" then
    self:AddDispatcher(EventID.OnTempleEnter, self, self.OnTempleEnter)
    self:AddDispatcher(EventID.OnTempleDelayStart, self, self.OnTempleDelayStart)
    self:AddDispatcher(EventID.OnTempleDelayEnd, self, self.OnTempleDelayEnd)
  elseif nil ~= GameState and GameState.GameModeType == "Party" then
    self:OnPartyEnter()
  elseif nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Rouge" then
    self:AddRougeKeyListeners()
  elseif GameState.GameModeType == "Trial" then
    self:InitTrailKeyTip()
    self.bInTrial = true
  else
    self:UnInitTrainingKeyTip()
    self:UnInitTrialKeyTip()
    self:UnInitTemple()
  end
  self:InitChatKeyTip()
end

function WBP_Battle_C:InitCommonKey(CommonKey, Index)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Training" then
    local DescTest = ""
    if 1 == Index then
      DescTest = "F4"
    elseif 2 == Index then
      DescTest = "F1"
    elseif 3 == Index then
      DescTest = "F5"
    end
    CommonKey:CreateCommonKey({
      KeyInfoList = {
        {Type = "Text", Text = DescTest}
      },
      bLongPress = false,
      Desc = GText("UI_DUNGEON_DES_TRAINING_" .. Index)
    })
    CommonKey:AddExecuteLogic(self, function()
      self:OnTrainingRightKeyClicked(Index)
    end)
  end
  if nil ~= GameMode and nil ~= GameState and GameState.GameModeType == "Temple" then
    CommonKey:CreateCommonKey({
      KeyInfoList = {
        {
          Type = self.ForbidInfo[Index][2],
          Text = self.ForbidInfo[Index][3],
          ImgShortPath = self.ForbidInfo[Index][3]
        }
      },
      bLongPress = false,
      Desc = GText(self.ForbidInfo[Index][1])
    })
    CommonKey:ShowBanImg()
    CommonKey:DisableKey()
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    if Player.UIModePlatform == "Mobile" then
      CommonKey:MobileBanTextImg()
    end
  end
end

function WBP_Battle_C:SetOverrideInfo(MapWidth, PaddingTop)
  if self.SizeBox_Map then
    self.SizeBox_Map:SetWidthOverride(MapWidth)
  end
  if not self.Task then
    return
  end
  self.Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(self.Task)
  if Slot then
    local Padding = Slot.Padding
    Padding.Top = PaddingTop
    Slot:SetPadding(Padding)
  end
end

function WBP_Battle_C:TempleForbidSkills(FbdRule)
  if not FbdRule then
    return
  end
  local KeyboardMap = DataMgr.KeyboardMap
  local ForbidInfo = {}
  if FbdRule.NoSkill and 0 ~= FbdRule.NoSkill then
    table.insert(ForbidInfo, {
      KeyboardMap.Skill1.ActionNameText,
      "Text",
      KeyboardMap.Skill1.Key
    })
    table.insert(ForbidInfo, {
      KeyboardMap.Skill2.ActionNameText,
      "Text",
      KeyboardMap.Skill2.Key
    })
    table.insert(ForbidInfo, {
      KeyboardMap.Skill3.ActionNameText,
      "Text",
      KeyboardMap.Skill3.Key
    })
  end
  if FbdRule.NoMelee and 0 ~= FbdRule.NoMelee then
    table.insert(ForbidInfo, {
      KeyboardMap.Attack.ActionNameText,
      "Img",
      KeyboardMap.Attack.Key
    })
  end
  if FbdRule.NoRanged and 0 ~= FbdRule.NoRanged then
    table.insert(ForbidInfo, {
      KeyboardMap.Fire.ActionNameText,
      "Img",
      KeyboardMap.Fire.Key
    })
  end
  if FbdRule.NoBattleWheel and 0 ~= FbdRule.NoBattleWheel then
    table.insert(ForbidInfo, {
      KeyboardMap.OpenBattleWheel.ActionNameText,
      "Text",
      KeyboardMap.OpenBattleWheel.Key
    })
  end
  return ForbidInfo
end

function WBP_Battle_C:AddTrainingRightKeyListeners()
  if self.IsInTraining then
    return
  end
  self:ListenForInputAction("TrainingOpenSetup", EInputEvent.IE_Pressed, true, {
    self,
    self.TrainingOpenSetup
  })
  self:ListenForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed, true, {
    self,
    self.TrainingCharacterSkills
  })
  self:ListenForInputAction("TrainingKillMonsters", EInputEvent.IE_Pressed, true, {
    self,
    self.TrainingKillMonsters
  })
  self:ListenForInputAction("TrainingInvincible", EInputEvent.IE_Pressed, true, {
    self,
    self.TrainingSetPlayerInvincible
  })
  self:ListenForInputAction("TrainingMonstersActive", EInputEvent.IE_Pressed, true, {
    self,
    self.TrainingDisableMonsterAI
  })
  self:StopListeningForInputAction("OpenEvent", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenBattlePass", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenGacha", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenBag", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenPlay", EInputEvent.IE_Pressed)
  self.IsInTraining = true
end

function WBP_Battle_C:RemoveTrainingRightKeyListeners()
  self:StopListeningForInputAction("TrainingOpenSetup", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TrainingKillMonsters", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TrainingInvincible", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TrainingMonstersActive", EInputEvent.IE_Pressed)
  self:ListenForInputAction("OpenBattlePass", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenBattlePass
  })
  self:ListenForInputAction("OpenGacha", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenGacha
  })
  self:ListenForInputAction("OpenEvent", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenEvent
  })
  self:ListenForInputAction("OpenBag", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenBag
  })
  self:ListenForInputAction("OpenPlay", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenPlay
  })
end

function WBP_Battle_C:AddRougeKeyListeners()
  self:RemoveRougeKeyListeners()
  self:ListenForInputAction("RougeOpenBag", EInputEvent.IE_Pressed, false, {
    self,
    self.OpenRogueShop
  })
end

function WBP_Battle_C:RemoveRougeKeyListeners()
  self:StopListeningForInputAction("RougeOpenBag", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:OnTrainingRightKeyClicked(Index)
  if 1 == Index then
    self:TrainingOpenSetup()
  elseif 2 == Index then
    self:TrainingCharacterSkills()
  elseif 3 == Index then
    self:TrainingKillMonsters()
  end
end

function WBP_Battle_C:AddTrialRightKeyListeners()
  self:RemoveTrialRightKeyListeners()
  self:ListenForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed, false, {
    self,
    self.TrialCharacterSkills
  })
  self:ListenForInputAction("OpenTask", EInputEvent.IE_Pressed, false, {
    self,
    self.TrialCharacterSkills
  })
end

function WBP_Battle_C:RemoveTrialRightKeyListeners()
  self:StopListeningForInputAction("TrainingCharacterSkills", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("OpenTask", EInputEvent.IE_Pressed)
end

function WBP_Battle_C:OnTrialRightKeyClicked(Index)
  if 2 == Index then
    self:TrialCharacterSkills()
  end
end

function WBP_Battle_C:TrialCharacterSkills()
  UIUtils.LoadPreviewSkillDetails(self, {
    OnClosedCallback = function()
      self:PlayInAnim()
    end
  })
end

function WBP_Battle_C:OnTempleEnter()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if nil == UIManager then
    return
  end
  local UIManager = GameInstance:GetGameUIManager()
  local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
  if GuideCountDownFloat then
    GuideCountDownFloat:OnCountDownEnd()
    GuideCountDownFloat:Close()
  end
  GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
  GuideCountDownFloat:SetVisibility(ESlateVisibility.Collapsed)
  self:AddTimer(1, self.ShowCountDown, false, 0, "ShowCountDown", nil, GuideCountDownFloat, 4)
  self.Pos_TaskBar:SetVisibility(ESlateVisibility.Collapsed)
  self.Pos_DynamicEvent:SetVisibility(ESlateVisibility.Collapsed)
end

function WBP_Battle_C:ShowCountDown(Widget, Count, bShowZeroText)
  Widget:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  Widget:InitTempleCountDown(Count, bShowZeroText)
end

function WBP_Battle_C:OnTempleDelayStart(Duration, Title, RedCountdownTime)
  DebugPrint("zwk OnTempleDelayStart", Duration, Title, RedCountdownTime)
  self.Pos_TempleTime:ClearChildren()
  self.CurDelayUI = self:CreateWidgetNew("DungeonTempleTime")
  self.Pos_TempleTime:AddChild(self.CurDelayUI)
  self.Pos_TempleTime:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.CurDelayUI:InitTempleDelayTimeUI(Title, Duration, RedCountdownTime)
end

function WBP_Battle_C:OnTempleDelayEnd()
  DebugPrint("zwk OnTempleDelayEnd")
  if self.CurDelayUI then
    self.CurDelayUI:CloseDungeonUI()
  end
end

function WBP_Battle_C:GetTrainingComp()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if GameMode then
    return GameMode:GetDungeonComponent()
  end
  return nil
end

function WBP_Battle_C:TrainingOpenSetup()
  self:GetTrainingComp():TrainingOpenSetup()
end

function WBP_Battle_C:TrainingCharacterSkills()
  self:GetTrainingComp():TrainingCharacterSkills()
end

function WBP_Battle_C:TrainingKillMonsters()
  AudioManager(self):PlayUISound(self, "event:/ui/common/btn_killer_all", nil, nil)
  self:GetTrainingComp():TrainingKillMonsters()
end

function WBP_Battle_C:TrainingSetPlayerInvincible()
  self:GetTrainingComp():TrainingSetPlayerInvincible()
end

function WBP_Battle_C:TrainingDisableMonsterAI()
  self:GetTrainingComp():TrainingDisableMonsterAI()
end

function WBP_Battle_C:InitUID()
  self.Text_BottomTips:SetText(GText("UI_Loading_Testing"))
  local Avatar = GWorld:GetAvatar()
  if Avatar and 0 ~= Avatar.Uid then
    self.UID:SetUid()
    self.UID:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.UID:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_C:InitEsc()
  self.Btn_Esc.bForceInvisible = nil
  self.Btn_Esc.Btn_top.OnClicked:Add(self, self.OpenCommonSetup)
  self.Btn_Esc:LoadImage(11)
  self:_RefreshEscReddot()
end

function WBP_Battle_C:Destruct()
  for Eid, TeammateUI in pairs(self.TeammateEidSet or {}) do
    self:RemoveTeammateUI(Eid, TeammateUI)
  end
  self.TeammateEidSet = {}
  self:EndAim()
  self:EndChat()
  self:EndTeam()
  self:RemoveTrainingRightKeyListeners()
  self:RemoveTrialRightKeyListeners()
  self:RemoveRougeKeyListeners()
  local NodeName = DataMgr.ReddotNode.Quest.NodeName
  ReddotManager.RemoveListener(NodeName, self)
  WBP_Battle_C.Super.Destruct(self)
end

function WBP_Battle_C:InitDataPhone()
  if self.Battery then
    self.Battery.HB_Battery:SetVisibility(not UUCloudGameInstanceSubsystem.IsCloudGame() and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player.UIModePlatform ~= "Mobile" then
    return
  end
  self.WifiImage = {
    self.Battery.Wifi_1,
    self.Battery.Wifi_2,
    self.Battery.Wifi_3
  }
  self.DataImage = {
    self.Battery.Image_Net_1,
    self.Battery.Image_Net_2,
    self.Battery.Image_Net_3,
    self.Battery.Image_Net_4
  }
  if not GWorld.IsDev then
    self.Btn_GM:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_GM:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:SetBattery(UE4.UUIFunctionLibrary.GetBatteryLevel())
  self:UpdateSignalStrength()
  self:AddTimer(5, self.UpdateDataPhone, true)
end

function WBP_Battle_C:UpdateDataPhone()
  self:SetBattery(UE4.UUIFunctionLibrary.GetBatteryLevel(), self.BatteryLevel)
  self:UpdateSignalStrength(self.SignalStrength)
end

function WBP_Battle_C:SetBattery(BatteryLevel, LastBatteryLevel)
  if BatteryLevel and not LastBatteryLevel then
    if BatteryLevel <= 20 then
      self.Battery:PlayAnimation(self.Battery.Low_Battery)
    else
      self.Battery:PlayAnimationReverse(self.Battery.Low_Battery)
    end
  elseif BatteryLevel <= 20 and LastBatteryLevel > 20 then
    self.Battery:PlayAnimation(self.Battery.Low_Battery)
  elseif BatteryLevel > 20 and LastBatteryLevel <= 20 then
    self.Battery:PlayAnimationReverse(self.Battery.Low_Battery)
  end
  if not self.BatteryLevel or BatteryLevel ~= self.BatteryLevel then
    self.Battery.Num_Battery:SetText(BatteryLevel .. "%")
    self.Battery.ProgressBar_Battery:SetPercent(BatteryLevel / 100)
    self.BatteryLevel = BatteryLevel
  end
end

function WBP_Battle_C:UpdateSignalStrength(LastSignalStrength)
  local IsConnectWifi = UE4.UMobilePatchingLibrary.HasActiveWiFiConnection()
  self.Battery.Switcher_Net:SetActiveWidgetIndex(IsConnectWifi and 1 or 0)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local PlayerState = Player:GetController().PlayerState
  if not PlayerState then
    DebugPrint(ErrorTag, "xuxiangnan::PlayerState获取失败，拿不到正确ping值")
    return
  end
  local Ping = PlayerState:GetPlayerPing()
  self.Battery.Num_Net:SetText(Ping)
  local Strength = 5
  for i = 1, #Const.SignalStrength do
    if Ping <= Const.SignalStrength[i] then
      Strength = Strength - i
      break
    end
  end
  for i = 2, #self.WifiImage do
    self.WifiImage[i]:SetVisibility(IsConnectWifi and i <= Strength and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  for i = 2, #self.DataImage do
    self.DataImage[i]:SetVisibility(not IsConnectWifi and i <= Strength and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if not LastSignalStrength then
    if Strength <= 2 then
      self.Battery:PlayAnimation(self.Battery.Low_Net)
    else
      self.Battery:PlayAnimationReverse(self.Battery.Low_Net)
    end
  elseif Strength <= 2 and self.SignalStrength > 2 then
    self.Battery:PlayAnimation(self.Battery.Low_Net)
  elseif Strength > 2 and self.SignalStrength <= 2 then
    self.Battery:PlayAnimationReverse(self.Battery.Low_Net)
  end
  self.SignalStrength = Strength
end

function WBP_Battle_C:ExitHardBossBattle()
  local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
  if CommonDialog then
    CommonDialog:Close()
  end
  self:SetInputUIOnly(false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsStandAlone(Player) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(Player)
    GameMode:SetGamePaused(UIConst.CommonSetUP, false)
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:ExitBattle(false, true)
  end
end

function WBP_Battle_C:ExitHardBattle()
  local CommonDialog = UIManager(self):GetUIObj("CommonDialog")
  if CommonDialog then
    CommonDialog:Close()
  end
  self:SetInputUIOnly(false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsStandAlone(Player) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(Player)
    GameMode:SetGamePaused(UIConst.CommonSetUP, false)
  end
  DebugPrint("gyy@SpecialQuestFail,ExitSpecialQuest")
  EventManager:FireEvent(EventID.OnSpecialQuestFail, "Exit")
end

function WBP_Battle_C:ContinueBattle()
  self:SetInputUIOnly(false)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsStandAlone(Player) then
    local GameMode = UE4.UGameplayStatics.GetGameMode(Player)
    GameMode:SetGamePaused(UIConst.CommonSetUP, false)
  end
end

function WBP_Battle_C:OpenCommonSetup()
  if TeamController:IsTeamPopupBarOpenInGamepad() then
    return
  end
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad and self:GetOnlineActionBtn() then
    self:OnPressGamePadRightSpecial()
    return
  end
  self:OpenSystemByAction("OpenCommonSetup")
end

function WBP_Battle_C:OnPressGamePadRightSpecial()
  DebugPrint("正在打开多人动作界面")
  local OnlineActionBtn = self:GetOnlineActionBtn()
  if OnlineActionBtn then
    UIUtils:LongPressKey(OnlineActionBtn.Key_OnlineAction_GamePad, function()
      local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
      OnlineActionController:OpenView()
    end, 1)
    return
  end
end

function WBP_Battle_C:OnReleaseGmaePadRightSpecial()
  local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  if OnlineActionController.MainPage and OnlineActionController.MainPage:IsVisible() then
  else
    local OnlineActionBtn = self:GetOnlineActionBtn()
    if OnlineActionBtn then
      UIUtils:StopLongPressKey(OnlineActionBtn.Key_OnlineAction_GamePad)
    end
    self:OpenSystemByAction("OpenCommonSetup")
  end
end

function WBP_Battle_C:GetOnlineActionBtn()
  local OnlineActionController = require("BluePrints.UI.WBP.BattleOnlineAction.OnlineActionController")
  local OnlineActionBtn = OnlineActionController.OnlineActionBtn or self.OnlineActionBtn
  if IsValid(OnlineActionBtn) and OnlineActionBtn:IsVisible() then
    return OnlineActionBtn
  end
  return false
end

function WBP_Battle_C:OpenSystemEntrance()
  self:OpenSystemByAction("OpenSystemEntrance")
end

function WBP_Battle_C:CloseSystemEntrance()
  self:OpenSystemByAction("CloseSystemEntrance")
end

function WBP_Battle_C:ShowSystemEntrance()
  self.IsShowSystemEntrance = true
  for i = 0, self.ListView:GetNumItems() - 1 do
    local Item = self.ListView:GetItemAt(i)
    if Item then
      Item.SelfWidget:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
    end
  end
  self.Btn_Task:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
end

function WBP_Battle_C:CloseSystemEntrance()
  self.IsShowSystemEntrance = false
  for i = 0, self.ListView:GetNumItems() - 1 do
    local Item = self.ListView:GetItemAt(i)
    if Item then
      Item.SelfWidget:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
    end
  end
  self.Btn_Task:ShowSystemEntranceOnGamePadInput(self.IsShowSystemEntrance)
end

function WBP_Battle_C:OpenArmory()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState.GameModeType == "Trial" then
    local GameMode = UE4.UGameplayStatics.GetGameMode(self)
    if GameMode then
      GameMode:TriggerDungeonComponentFun("ShowArmory")
    end
  else
    self:OpenSystemByAction("OpenArmory")
  end
end

function WBP_Battle_C:OpenBag()
  self:OpenSystemByAction("OpenBag")
end

function WBP_Battle_C:OpenPlay()
  self:OpenSystemByAction("OpenPlay")
end

function WBP_Battle_C:OpenTaskPanel()
  self:OpenSystemByAction("OpenTask")
end

function WBP_Battle_C:OpenGuideBook()
  self:OpenSystemByAction("OpenGuideBook")
end

function WBP_Battle_C:OpenBattlePass()
  self:OpenSystemByAction("OpenBattlePass")
end

function WBP_Battle_C:OpenEvent()
  self:OpenSystemByAction("OpenEvent")
end

function WBP_Battle_C:OpenForge()
  self:OpenSystemByAction("OpenForge")
end

function WBP_Battle_C:OpenGacha()
  self:OpenSystemByAction("OpenGacha")
end

function WBP_Battle_C:OpenRogueShop()
  local UIManager = self:GetGameInstance():GetGameUIManager()
  UIManager:LoadUINew("RougeBag")
end

function WBP_Battle_C:OpenSystemByAction(ActionName, bEscMenu, ...)
  if not UIManager(self):TryOpenSystem("BattleHUD") then
    return
  end
  local FrameCount = UKismetSystemLibrary.GetFrameCount()
  if self.FrameCount == FrameCount then
    return
  end
  self.FrameCount = FrameCount
  if "OpenCommonSetup" == ActionName then
    UIUtils.OpenEsc()
    return
  elseif "OpenSystemEntrance" == ActionName then
    self:ShowSystemEntrance()
    return
  elseif "CloseSystemEntrance" == ActionName then
    self:CloseSystemEntrance()
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsInHardBoss() and "OpenChat" ~= ActionName then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Player:CheckForbidTags(ActionName) then
    return
  end
  if (self:IsPlayingAnimation(self.Out) or self:IsPlayingAnimation(self.In)) and not Player.IsImmersionModel then
    return
  end
  local SystemId
  for EnterId, SystemData in pairs(DataMgr.MainUI) do
    local SystemAction = SystemData.ActionName
    if SystemAction and SystemAction == ActionName then
      SystemId = EnterId
    end
  end
  if nil ~= SystemId then
    AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_system_entrance", nil, nil)
    UIUtils.OpenSystem(SystemId, bEscMenu, ...)
  end
end

function WBP_Battle_C:AddTeammateUI(Eid, bIsPlayer, Entity)
  if GameState(self).GameModeType == "Party" then
    DebugPrint("TeamSyncDebug  Party模式不创建队友血条UI", Eid)
    return
  end
  DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 有角色产生，魅影或玩家", bIsPlayer, Eid)
  if GameState(self):GetPhantomState(Eid) then
    DebugPrint("TeamSyncDebug  PhantomArray存在该魅影，看一下OwnerEid,", GameState(self):GetPhantomState(Eid).OwnerEid)
  end
  Entity = Entity or Battle(self):GetEntity(Eid)
  if self.TeammateEidSet[Eid] then
    if Entity and Entity.TeammateUI then
      Entity.TeammateUI:ReInit()
      self.TeammateEidSet[Eid] = Entity.TeammateUI
    end
    return
  end
  if self:AddBattleTeamBloodBar(Eid, bIsPlayer, Entity) then
    if bIsPlayer then
      return
    end
    if not bIsPlayer then
      local MainPlayer = GWorld:GetMainPlayer()
      local PhantomState = Entity and Entity.PhantomState or GameState(self):GetPhantomState(Eid)
      if not PhantomState then
        Utils.Traceback(WarningTag, LXYTag .. "TeamSyncDebug  AddTeammateUI  拿不到PhantomState直接返回")
        return
      end
      local OwnerEid = PhantomState.OwnerEid
      if not OwnerEid then
        Utils.Traceback(WarningTag, LXYTag .. "TeamSyncDebug非常怀疑魅影的初始化流程有时序问题..")
        return
      end
      if OwnerEid ~= MainPlayer.Eid then
        return
      end
    end
  end
  if not IsValid(Entity) or Entity.IsSimplePlayer or Entity.IsHostage or Entity.FromOtherWorld then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if Entity.Eid == Player.Eid then
    DebugPrint(DebugTag, LXYTag, "TeamSyncDebug 自身不应该产生血条", Player.Eid)
    return
  end
  local TeammateUI = self:CreateWidgetNew("TeammateBloodBar")
  TeammateUI:InitConfig(Entity)
  Entity.TeammateUI = TeammateUI
  Entity:SetTeammateUI(TeammateUI)
  self.VB_Teammate_Phantom:AddChildToVerticalBox(TeammateUI)
  local VBSlot = UE4.UWidgetLayoutLibrary.SlotAsVerticalBoxSlot(TeammateUI)
  if VBSlot then
    local Margin = FMargin(0, 0, 0, 0)
    local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
    if "PC" == Platform then
      Margin.Top = 10
    end
    VBSlot:SetPadding(Margin)
  end
  if not next(self.TeammateEidSet) then
    self:Show1PTagBar(true)
    self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.TeammateEidSet[Eid] = TeammateUI
end

function WBP_Battle_C:RemoveTeammateUI(Eid, TeammateBloodBarUI)
  if self:RemoveBattleTeamBloodBar(Eid) then
    return
  end
  if not TeammateBloodBarUI then
    return
  end
  TeammateBloodBarUI:BindToAnimationFinished(TeammateBloodBarUI.Out, {
    TeammateBloodBarUI,
    function()
      TeammateBloodBarUI:UnbindAllFromAnimationFinished(TeammateBloodBarUI.Out)
      self.VB_Teammate_Phantom:RemoveChild(TeammateBloodBarUI)
    end
  })
  TeammateBloodBarUI:PlayAnimation(TeammateBloodBarUI.Out)
  self.TeammateEidSet[TeammateBloodBarUI.Eid] = nil
  if not next(self.TeammateEidSet) then
    self:Show1PTagBar(false)
    self.VB_Teammate_Phantom:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Battle_C:UpdateRedDotStates()
  DebugPrint("Tianyi@ UpdateRedDotStates")
  local EntryList = self.ListView:GetDisplayedEntryWidgets():ToTable()
  for _, v in ipairs(EntryList) do
    v:UpdateRedDot()
  end
  self.Btn_Task:RefreshNewClueUI()
end

function WBP_Battle_C:InitConditionMapSystem()
  self.BattleEntry = self:CreateWidgetNew("BattleEntry")
  self.Pos_Entry:ClearChildren()
  self.Pos_Entry:AddChild(self.BattleEntry)
  self.ListView = self.BattleEntry.List_Entry
  self.ListView:DisableScroll(true)
  self.ConditionMapping = {}
  self.SignBoardNpcLoadComplete = false
  for SystemId, Data in pairs(DataMgr.MainUI) do
    local ConditionId = Data.ShowCondition
    if ConditionId then
      self.ConditionMapping[ConditionId] = true
    end
  end
  self:AddDispatcher(EventID.ConditionComplete, self, self.OnConditionComplete)
  self:AddDispatcher(EventID.OnAvatarStatusUpdate, self, self.OnAvatarStatusUpdate)
end

function WBP_Battle_C:OnConditionComplete(ConditionId)
  if 0 == #self.ConditionMapping then
    return
  end
  if self.ConditionMapping[ConditionId] then
    self:InitMainUIInBigWorld()
  end
end

function WBP_Battle_C:OnAvatarStatusUpdate(OldStatus, NewStatus)
  self:InitMainUIInBigWorld()
end

function WBP_Battle_C:InitMainUIInBigWorld()
  self.IsInHomebase = false
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:CheckSubRegionType(Avatar:GetCurrentRegionId(), CommonConst.SubRegionType.Home) and Avatar:IsInBigWorld() then
    self.IsInHomebase = true
    self:InitHomeBaseMain()
  else
    self:InitBtnList()
  end
end

function WBP_Battle_C:InitHomeBaseMain()
  self:InitBtnList()
  if not self.SignBoardNpcLoadComplete then
    self:TriggerSignBoardNpc()
    self:AddDispatcher(EventID.OnCharAppearanceChanged, self, self.OnCharAccessoryChange)
    self:AddDispatcher(EventID.OnCharAccessorySetted, self, self.OnCharAccessoryChange)
    self:AddDispatcher(EventID.OnCharAccessoryRemoved, self, self.OnCharAccessoryChange)
    self:AddDispatcher(EventID.OnCharShowPartMesh, self, self.OnCharAccessoryChange)
    self:AddDispatcher(EventID.OnCharCornerVisibilityChanged, self, self.OnCharAccessoryChange)
    self:AddDispatcher(EventID.OnCharSkinChanged, self, self.OnCharSkinChange)
    self:AddDispatcher(EventID.OnCharColorsChanged, self, self.OnCharColorsChanged)
    self:AddDispatcher(EventID.OnWindowResized, self, function(self)
      self.bRebuildChatSimple = true
    end)
  end
end

function WBP_Battle_C:InitBtnList()
  local SystemData = DataMgr.MainUI
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self.SystemUnlockList = {}
  self.SystemSortList = {}
  self.SystemUnlockNums = 0
  for index, Data in pairs(SystemData) do
    table.insert(self.SystemSortList, {
      Id = index,
      Sequence = Data.Sequence or 0
    })
    if Data.ShowCondition ~= nil then
      local ConditionSucc = ConditionUtils.CheckCondition(Avatar, Data.ShowCondition)
      if ConditionSucc then
        self.SystemUnlockList[index] = false
        local RuleName = Data.UIUnlockRuleName
        if nil == RuleName then
          self.SystemUnlockList[index] = true
        else
          self.SystemUnlockList[index] = self:CheckUIUnlock(RuleName)
        end
      end
    end
  end
  self:InitSystemEntrance()
  if self.Btn_GuideBook then
    self:InitGuideBookBtn()
  end
  if self.Btn_Task then
    self:InitTaskPanelBtn()
  end
  self:InitEsc()
end

function WBP_Battle_C:InitGuideBookBtn()
  local SystemData = DataMgr.MainUI[13]
  if self:CheckUIUnlock(SystemData.UIUnlockRuleName) then
    self.Btn_GuideBook:LoadImage(13)
    self.Btn_GuideBook.Btn_top.OnClicked:Add(self, self.OpenGuideBook)
    if not self.HideGuideBookBtn then
      self.Btn_GuideBook:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  else
    self.Btn_GuideBook:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_C:InitTaskPanelBtn()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local GameState = UE4.URuntimeCommonFunctionLibrary.GetCurrentGameState(self)
  local IsHide = false
  local IsInRouge = Avatar:IsInRougeLike()
  local IsInDG = false
  if GameState then
    IsInDG = GameState:IsInDungeon()
  end
  local IsInHB = Avatar:IsInHardBoss()
  local IsInSQ = Avatar:IsInSpecialQuest()
  IsHide = IsInRouge or IsInDG or IsInHB or IsInSQ
  local SystemData = DataMgr.MainUI[9]
  if not IsHide then
    if SystemData.ShowCondition then
      local ConditionSucc = ConditionUtils.CheckCondition(Avatar, SystemData.ShowCondition)
      if not ConditionSucc then
        self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
        return
      end
    end
    if self:CheckUIUnlock(SystemData.UIUnlockRuleName) then
      self.Btn_Task:LoadImage(9)
      self.Btn_Task.Btn_top.OnClicked:Add(self, self.OpenTaskPanel)
      self.Btn_Task:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
    end
  else
    self.Btn_Task:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_C:CheckUIUnlock(RuleName)
  local UIUnlockRule = DataMgr.UIUnlockRule
  local UIUnlockRuleId = UIUnlockRule[RuleName].UIUnlockRuleId
  local Avatar = GWorld:GetAvatar()
  if Avatar and UIUnlockRuleId then
    return Avatar:CheckUIUnlocked(UIUnlockRuleId)
  else
    return true
  end
end

function WBP_Battle_C:InitSystemEntrance()
  local ClassPath = UE4.LoadClass("/Game/UI/WBP/Battle/Widget/WBP_Main_Btnlist_Content.WBP_Main_Btnlist_Content_C")
  self.ListView:ClearListItems()
  table.sort(self.SystemSortList, function(Data1, Data2)
    return Data1.Sequence > Data2.Sequence
  end)
  local Avatar = GWorld:GetAvatar()
  for Key, Value in pairs(self.SystemSortList) do
    local MainUIConfig = DataMgr.MainUI[Value.Id]
    if MainUIConfig and UIUtils.CheckCdnHide(MainUIConfig.SystemUIName) then
    elseif self.SystemUnlockList[Value.Id] then
      self.SystemUnlockNums = self.SystemUnlockNums + 1
      local Content = NewObject(ClassPath)
      Content.BtnId = Value.Id
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      if self.bInTrial then
        Content.bForbidReddot = true
        DebugPrint("yeke::trial模式不显示红点")
      end
      self.ListView:AddItem(Content)
    end
  end
  if not self.HideSystemEntrance then
    if 0 == self.SystemUnlockNums then
      self.Pos_Entry:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
      self.Pos_Entry:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
end

function WBP_Battle_C:TriggerSignBoardNpc()
  local Avatar = GWorld:GetAvatar()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local CreatorMap = GameState.StaticCreatorMap:ToTable()
  local DisplayName = {
    "ShowNpc" .. string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE1.TextMapId, -7),
    "ShowNpc" .. string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE2.TextMapId, -7),
    "ShowNpc" .. string.sub(DataMgr.TextMap.UI_SHOWNPC_NAME_SCENE3.TextMapId, -7)
  }
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.NpcStaticCreator = {}
  for i = 1, #DisplayName do
    for _, StaticCreator in pairs(CreatorMap) do
      if StaticCreator.UnitType == "Npc" and string.lower(StaticCreator.DisplayName) == string.lower(DisplayName[i]) then
        self.NpcStaticCreator[i] = StaticCreator
        if Avatar.SignBoardNpc[i] ~= CommonConst.SignBoardUnset then
          StaticCreator.UnitId = Avatar.SignBoardNpc[i]
          local StaticIds = TArray(0)
          StaticIds:Add(StaticCreator.StaticCreatorId)
          GameMode:TriggerActiveStaticCreator(StaticIds)
        end
        break
      end
    end
  end
  self:SetSignBoardNpcIdle()
end

local NpcLogType = UE.EStoryLogType.NPC

function WBP_Battle_C:SetSignBoardNpcIdle()
  local Avatar = GWorld:GetAvatar()
  if nil == Avatar then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  for key, value in pairs(Avatar.SignBoardNpc) do
    if value ~= CommonConst.SignBoardUnset then
      local NpcInfo = DataMgr.Npc[value]
      if NpcInfo and NpcInfo.ShowAnimationId then
        local ShowAnimation = NpcInfo.ShowAnimationId
        local ShowAnimationId = ShowAnimation[key]
        GameState:GetNpcInfoAsync(value, function(Npc)
          if not IsValid(Npc) then
            UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, NpcLogType, "看板娘Npc加载失败", string.format("NpcId: %d 加载失败，确认下是该看板娘被删除或者其他原因", value or -1))
            return
          end
          Npc:InitNpcAccessories(NpcInfo.CharId)
          if "Sit" == ShowAnimationId and key ~= CommonConst.SignBoardThird then
            Npc:SetSitPoseInteractive()
          else
            Npc:SetIdlePose(false)
          end
          local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
          if IsValid(GameInstance) then
            local Tag = GameInstance:GetGlobalGameUITag()
            if not Tag or "" == Tag then
              Tag = "None"
            end
            GameInstance:TriggerAllNpcPauseAndHide(Tag)
          end
        end)
      end
    end
  end
  self.SignBoardNpcLoadComplete = true
end

function WBP_Battle_C:OnCharAccessoryChange(Ret, CharUuid)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local Char = Avatar.Chars[CharUuid]
    if not Char then
      return
    end
    local CharId = Char.CharId
    for key, NpcId in pairs(Avatar.SignBoardNpc) do
      if NpcId ~= CommonConst.SignBoardUnset then
        local NpcInfo = DataMgr.Npc[NpcId]
        if NpcInfo and NpcInfo.CharId and NpcInfo.CharId == CharId then
          local GameInstance = GWorld.GameInstance
          local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
          GameState:GetNpcInfoAsync(NpcId, function(Npc)
            if not IsValid(Npc) then
              return
            end
            Npc:RefreshNpcAccessories(Char)
          end)
          break
        end
      end
    end
  end
end

function WBP_Battle_C:OnCharColorsChanged(Ret, SkinId)
  if Ret == ErrorCode.RET_SUCCESS then
    local SkinInfo = DataMgr.Skin[SkinId]
    if not SkinInfo then
      return
    end
    local CharId = SkinInfo.CharId
    self:UpdateSignBoardNpcSkin(CharId)
  end
end

function WBP_Battle_C:OnCharSkinChange(Ret, CharUuid)
  if Ret == ErrorCode.RET_SUCCESS then
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local Char = Avatar.Chars[CharUuid]
    if not Char then
      return
    end
    local CharId = Char.CharId
    self:UpdateSignBoardNpcSkin(CharId)
  end
end

function WBP_Battle_C:UpdateSignBoardNpcSkin(CharId)
  local Avatar = GWorld:GetAvatar()
  local CharAvatar
  for key, Char in pairs(Avatar.Chars) do
    if Char.CharId == CharId then
      CharAvatar = Char
      break
    end
  end
  for key, NpcId in pairs(Avatar.SignBoardNpc) do
    if NpcId ~= CommonConst.SignBoardUnset then
      local NpcInfo = DataMgr.Npc[NpcId]
      if NpcInfo and NpcInfo.CharId and NpcInfo.CharId == CharId then
        local GameInstance = GWorld.GameInstance
        local GameState = UE4.UGameplayStatics.GetGameState(GameInstance)
        if NpcInfo.ShowAnimationId then
          local ShowAnimation = NpcInfo.ShowAnimationId
          local ShowAnimationId = ShowAnimation[key]
          GameState:GetNpcInfoAsync(NpcId, function(Npc)
            if not IsValid(Npc) then
              return
            end
            Npc:SetIdlePose(false)
            Npc:RefreshNpcAccessories(CharAvatar)
            if "Sit" == ShowAnimationId and key ~= CommonConst.SignBoardThird then
              Npc:SetSitPoseInteractive()
            end
          end)
        end
        break
      end
    end
  end
end

function WBP_Battle_C:OnHomeBaseBtnPlayAnim(UIName, AnimationName)
  self:AddTimer(0.01, function()
    local EntryList = self.ListView:GetDisplayedEntryWidgets():ToTable()
    for _, v in ipairs(EntryList) do
      v:OnHomeBaseBtnPlayAnim(UIName, AnimationName)
    end
  end, nil, nil, nil, false)
end

function WBP_Battle_C:OnSwitchRole()
  for i = 0, self.ListView:GetNumItems() - 1 do
    local Item = self.ListView:GetItemAt(i)
    if Item and Item.BtnId == CommonConst.ArmoryEnterId and Item.SelfWidget then
      Item.SelfWidget:UpdateArmoryIcon()
    end
  end
end

function WBP_Battle_C:OnSystemUIUnLoad(UIName)
  self:RemovePlayInOutSystems(UIName)
  local SystemUIConfig = DataMgr.SystemUI[UIName]
  if SystemUIConfig and SystemUIConfig.IsHideBattleUnit and SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAll and SystemUIConfig.IsHideBattleUnit ~= UIConst.EnumHideBattleUnitStyle.NormalShowAndHideAllExceptSelf then
    return
  end
  if 0 ~= UIManager(self).States:Num() then
    return
  end
  self:UnLoadSystem(UIName)
end

function WBP_Battle_C:UnLoadSystem(UIName)
  local SystemInfo, IsPlayInAnim = DataMgr.MainUI, false
  self:RemovePlayInOutSystems(UIName)
  for SystemId, Info in pairs(SystemInfo) do
    if self:CheckNeedPlayInOutAnim(SystemId) then
      local SystemName = Info.SystemUIName
      if SystemName and SystemName == UIName then
        local MenuWorld = UIManager(self):GetUIObj(UIConst.MenuWorld)
        if MenuWorld then
          return false
        end
        IsPlayInAnim = self:TryRecoverUI()
        break
      end
    end
  end
  self:InitChatSimple()
  return IsPlayInAnim
end

function WBP_Battle_C:CheckNeedPlayInOutAnim(SystemId)
  if SystemId == CommonConst.ArmoryEnterId then
    return false
  elseif SystemId == ChatCommon.MainUIId then
    return false
  end
  return true
end

function WBP_Battle_C:TryRecoverUI()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if IsValid(Player) and Player.IsImmersionModel then
    self:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return false
  end
  if self:CheckPlayInOutSystems() then
    return
  end
  self:PlayInAnim()
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  return true
end

function WBP_Battle_C:PlayInAnim()
  if self:CheckPlayInOutSystems() then
    return
  end
  DebugPrint("-----Jzn---主界面 in-------")
  self:SetUIVisibilityTag("PlayBattleAni", false)
  self:UnbindAllFromAnimationFinished(self.In)
  
  local function ShowSelf()
    self:UnbindAllFromAnimationFinished(self.In)
  end
  
  self:BindToAnimationFinished(self.In, {self, ShowSelf})
  self:StopAnimation(self.Out)
  self:PlayAnimation(self.In)
  self.IsPlayOutAnim = false
  local Widget = self.Pos_Instruction_Mod:GetChildAt(0)
  if Widget and Widget:GetVisibility() ~= UE4.ESlateVisibility.Collapsed then
    Widget:TryGetReward()
  end
end

function WBP_Battle_C:_RefreshEscReddot()
  local Node = ReddotManager.GetTreeNode("BattleMainMenu")
  if Node then
    Node:TryFireOnCountChange(Node.Count, true)
  end
  local ActiNode = ReddotManager.GetTreeNode("ActivityHub")
  if ActiNode then
    local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
    ActivityUtils.RefreshActivityReddotNode()
  end
end

function WBP_Battle_C:AddPlayInOutSystems(UIName)
  if nil == UIName then
    return
  end
  if nil == self.PlayInOutSystems then
    self.PlayInOutSystems = {}
  end
  self.PlayInOutSystems[UIName] = true
end

function WBP_Battle_C:RemovePlayInOutSystems(UIName)
  if nil == UIName then
    return
  end
  if self.PlayInOutSystems[UIName] then
    self.PlayInOutSystems[UIName] = false
  end
  return true
end

function WBP_Battle_C:CheckPlayInOutSystems()
  for SystemUI, bDontPlayIn in pairs(self.PlayInOutSystems) do
    if bDontPlayIn then
      DebugPrint("--jzn---系统" .. SystemUI .. "还未关闭,无需播放主界面的In")
      return true
    end
  end
  self.PlayInOutSystems = {}
  return false
end

function WBP_Battle_C:PlayOutAnim(Obj, Func, SystemUIName)
  DebugPrint("-----Jzn---主界面 out-------")
  self:SetUIVisibilityTag("PlayBattleAni", true)
  self:StopAnimation(self.In)
  self:PlayAnimation(self.Out)
  self.IsPlayOutAnim = true
  self:UnbindAllFromAnimationFinished(self.Out)
  self:AddPlayInOutSystems(SystemUIName)
  if Obj and Func then
    Func(Obj)
  end
  
  local function HideSelf()
    self.IsPlayOutAnim = false
    self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  
  self:BindToAnimationFinished(self.Out, {self, HideSelf})
end

function WBP_Battle_C:PlayDeathMaskIn()
  local Mask_Death = self:GetOrAddWidget("DeathMask", self.Pos_Death)
  if Mask_Death then
    Mask_Death:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    Mask_Death:PlayAnimation(Mask_Death.Mask_Death_In)
  end
end

function WBP_Battle_C:PlayDeathMaskOut()
  local Mask_Death = self:GetOrAddWidget("DeathMask", self.Pos_Death)
  if Mask_Death then
    local Visibility = Mask_Death.Panel_Death:GetVisibility()
    if Visibility == UE4.ESlateVisibility.Visible then
      Mask_Death.Panel_Death:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      Mask_Death:PlayAnimation(Mask_Death.Mask_Death_Out)
    else
      Mask_Death:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function WBP_Battle_C:ShowPlayerDeadUI()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local ResurgenceUIName = Player:GetCurRecoveryUIName()
  local BattleResurgenceUI = UIManager(self):GetUI(ResurgenceUIName)
  if BattleResurgenceUI then
    self:ShowOrHideMainPlayerBloodUI(false, "Dead")
    self:HideSubSystem("Char_Skill", "Dead", true)
    if self.TakeAimIndicator then
      self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    self:ShowOrHideTeamDataTag(false)
  end
  if self.HBox then
    self.HBox:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.IsShowingTeleportUI == true then
    self:StopTeleportInDungeon(true)
  end
end

function WBP_Battle_C:HidePlayerDeadUI()
  self:ShowOrHideMainPlayerBloodUI(true, "Dead")
  self:HideSubSystem("Char_Skill", "Dead", false)
  local OwnerPlayer = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  self.Char_Skill:OnUpdateCharSp(nil, OwnerPlayer)
  if self.HBox then
    self.HBox:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.TakeAimIndicator then
    self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    self.TakeAimIndicator:RefreshUIShowPage()
  end
  local PlayerAvatar, IsNeedShowTeamTag = GWorld:GetAvatar(), false
  if nil ~= PlayerAvatar then
    if not GWorld:IsStandAlone() then
      IsNeedShowTeamTag = GameState(self).PlayerArray:Num() > 1
    else
      local TeamModelData = TeamController:GetModel()
      local TeamAvatarData = TeamModelData:GetTeam()
      local TeamNumber = nil == TeamAvatarData and 0 or #TeamAvatarData.Members
      IsNeedShowTeamTag = TeamNumber > 1
    end
  end
  self:ShowOrHideTeamDataTag(IsNeedShowTeamTag)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local ResurgenceUIName = Player:GetCurRecoveryUIName()
  local BattleResurgenceUI = UIManager(self):GetUI(ResurgenceUIName)
  if BattleResurgenceUI then
    BattleResurgenceUI:Close()
  end
  if self.IsShowingTeleportUI == true then
    self:TeleportReady()
  end
end

function WBP_Battle_C:ShowBattleFortUI()
  local BattleFortUI = UIManager(self):GetUI("BattleFort")
  if BattleFortUI then
    if BattleFortUI.HideUITable then
      for Name, _ in pairs(BattleFortUI.HideUITable) do
        self:HideSubSystem(Name, "BattleFort", true)
        if "Pos_Entry" == Name then
          self.HideSystemEntrance = true
        elseif "Btn_GuideBook" == Name then
          self.HideGuideBookBtn = true
        end
      end
    end
    self:ShowOrHideMainPlayerBloodUI(false, "BattleFort")
    if self.TakeAimIndicator then
      self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
    if IsValid(self.Joystick) then
      self.Joystick:SetTouchVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
end

function WBP_Battle_C:HideBattleFortUI()
  local BattleFortUI = UIManager(self):GetUI("BattleFort")
  if BattleFortUI then
    if BattleFortUI.HideUITable then
      for Name, VisibleState in pairs(BattleFortUI.HideUITable) do
        self:HideSubSystem(Name, "BattleFort", false)
        if "Pos_Entry" == Name then
          self.HideSystemEntrance = false
        elseif "Btn_GuideBook" == Name then
          self.HideGuideBookBtn = false
        end
      end
    end
    self:ShowOrHideMainPlayerBloodUI(true, "BattleFort")
    if self.TakeAimIndicator then
      self.TakeAimIndicator:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
      self.TakeAimIndicator:RefreshUIShowPage()
    end
    if IsValid(self.Joystick) then
      self.Joystick:SetTouchVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
    self:InitBtnList()
  end
end

function WBP_Battle_C:ShowFeinaEventHUD()
  local FeinaEventHUD = UIManager(self):LoadUINew("FeinaEventHUD")
  if FeinaEventHUD then
    if FeinaEventHUD.HideUITable then
      for Name, _ in pairs(FeinaEventHUD.HideUITable) do
        self:HideSubSystem(Name, "FeinaEvent", true)
        if "Pos_Entry" == Name then
          self.HideSystemEntrance = true
        elseif "Btn_GuideBook" == Name then
          self.HideGuideBookBtn = true
        end
      end
    end
    self:ShowOrHideMainPlayerBloodUI(false, "FeinaEvent")
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
      TaskBar:SetUIVisibilityTag("FeinaEvent", true)
    end
  end
end

function WBP_Battle_C:HideFeinaEventHUD()
  local FeinaEventHUD = UIManager(self):GetUI("FeinaEventHUD")
  if FeinaEventHUD then
    if FeinaEventHUD.HideUITable then
      for Name, _ in pairs(FeinaEventHUD.HideUITable) do
        self:HideSubSystem(Name, "FeinaEvent", false)
        if "Pos_Entry" == Name then
          self.HideSystemEntrance = false
        elseif "Btn_GuideBook" == Name then
          self.HideGuideBookBtn = false
        end
      end
    end
    self:ShowOrHideMainPlayerBloodUI(false, "FeinaEvent")
    local TaskBar = TaskUtils:GetTaskBarWidget()
    if TaskBar then
      TaskBar:SetUIVisibilityTag("FeinaEvent", false)
    end
    self:InitBtnList()
  end
end

function WBP_Battle_C:ShowOrHideMainPlayerBloodUI(bIsShow, Tag)
  DebugPrint("WBP_Battle_C:ShowOrHideMainPlayerBloodUI", bIsShow, Tag)
  if self.HUD_MainBar then
    self.HUD_MainBar:SetUIVisibilityTag(Tag, not bIsShow)
  end
end

function WBP_Battle_C:ShowOrHideTeamDataTag(bIsShowTag)
  local TargetWidgetNode
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    TargetWidgetNode = nil
  else
    TargetWidgetNode = self.VB_Tag
  end
  if not TargetWidgetNode then
    return
  end
  if bIsShowTag then
    if not TargetWidgetNode:IsVisible() then
      TargetWidgetNode:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  elseif TargetWidgetNode:IsVisible() then
    TargetWidgetNode:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_C:SetUIVisibilityTag(HideTag, Invisible)
  if not IsValid(self) then
    return
  end
  if self.HideTags == nil then
    self.HideTags = {}
  end
  if Invisible then
    self.HideTags[HideTag] = 1
  else
    self.HideTags[HideTag] = nil
  end
  local IsHide = not IsEmptyTable(self.HideTags)
  local IsShippingPackage = UE4.UKismetSystemLibrary.IsPackagedForDistribution()
  if IsHide then
    if IsShippingPackage and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
      self:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Panel_Content:SetVisibility(UE4.ESlateVisibility.Collapsed)
      SystemGuideManager:HideUIEvent(self.WidgetName)
    else
      SystemGuideManager:HideUIEvent(self.WidgetName)
      if self:GetVisibility() ~= ESlateVisibility.Collapsed then
        self:SetVisibility(UE4.ESlateVisibility.Collapsed)
      end
    end
  elseif IsShippingPackage and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    self.Panel_Content:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    SystemGuideManager:ShowUIEvent(self.WidgetName)
  else
    if self:GetVisibility() == UE4.ESlateVisibility.Visibie or self:GetVisibility() == UE4.ESlateVisibility.SelfHitTestInvisible then
      SystemGuideManager:ShowUIEvent(self.WidgetName)
    end
    if self:GetVisibility() ~= UE4.ESlateVisibility.SelfHitTestInvisible then
      self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      SystemGuideManager:ShowUIEvent(self.WidgetName)
    end
  end
end

function WBP_Battle_C:OnBattleMapClose()
  self.Battle_Map:OnClickClose()
end

function WBP_Battle_C:SetVisibility(InVisibility)
  self.Overridden.SetVisibility(self, InVisibility)
  if IsValid(self.Joystick) then
    self.Joystick:SetTouchVisibilityFromBattle(InVisibility)
  elseif CommonUtils:GetDeviceTypeByPlatformName(self) == CommonConst.CLIENT_DEVICE_TYPE.MOBILE then
    UIManager(self):ShowUIError(UIConst.ErrorCategory.HUD, "Hy@== 主界面虚拟摇杆无效了Joystick 不存在, 摇杆表现可能受影响")
  end
end

function WBP_Battle_C:ShowInstructionInfo(ActionName, IsHide)
  local Platform = CommonUtils:GetDeviceTypeByPlatformName(self)
  self.Pos_Instruction:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  local Instruction = self.Pos_Instruction:GetChildAt(0)
  if "PC" == Platform then
    if nil == Instruction then
      Instruction = self:GetOrAddWidget("InstructionPC", self.Pos_Instruction)
      if Instruction then
        Instruction:HideAllText()
      end
    end
  elseif nil == Instruction then
    Instruction = self:GetOrAddWidget("InstructionMobile", self.Pos_Instruction)
    if Instruction then
      Instruction:HideAllText()
    end
  end
  if Instruction then
    DebugPrint(ActionName, "===ShowInstructionInfo=============================")
    if IsHide then
      Instruction:HideActionText(ActionName)
    else
      Instruction:ShowActionText(ActionName)
    end
  end
end

function WBP_Battle_C:HideDynamicEventUI()
  local DynWidget = self:GetOrAddDynamicEventWidget()
  if DynWidget then
    DynWidget:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function WBP_Battle_C:OnTeammateDie(TargetEid)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Teammate = Battle(self):GetEntity(TargetEid)
  if Player.Eid ~= TargetEid then
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATEDEAD"), UIUtils.GetCharName(Teammate)))
  end
end

function WBP_Battle_C:OnTeammateRecovery(TargetEid)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  local Teammate = Battle(self):GetEntity(TargetEid)
  if Player.Eid ~= TargetEid then
    if Teammate:IsPhantom() then
      UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATERECOVERY"), UIUtils.GetCharName(Teammate)))
    elseif Teammate:IsPlayer() then
      local GameState = UE4.UGameplayStatics.GetGameState(self)
      for key, value in pairs(GameState.PlayerArray) do
        if value == Teammate.PlayerState then
          UIManager(self):ShowUITip(UIConst.Tip_CommonTop, string.format(GText("BATTLE_RECOVERY_TEAMMATERECOVERY"), UIUtils.GetCharName(Teammate)))
        end
      end
    end
  end
end

function WBP_Battle_C:CreatTakeAimIndicator()
  self.TakeAimIndicator = self:CreateWidgetNew("TakeAimIndicator")
  if self.TakeAimIndicator then
    local Slot = self.Pos_Aim:AddChildToOverlay(self.TakeAimIndicator)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.TakeAimIndicator:Init(Player)
    self.Pos_Aim:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  end
end

function WBP_Battle_C:EndAim()
  self.Pos_Aim:ClearChildren()
end

function WBP_Battle_C:GetTakeAimIndicator()
  return self.TakeAimIndicator
end

function WBP_Battle_C:OnKeyDown(MyGeometry, InKeyEvent)
  return UIUtils.Unhandled
end

function WBP_Battle_C:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.DPadDown or InKeyName == UIConst.GamePadKey.DPadUp or InKeyName == UIConst.GamePadKey.DPadRight or InKeyName == UIConst.GamePadKey.DPadLeft then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

function WBP_Battle_C:StartRougeCanonCountDown()
  self.Pos_Rouge_CountDown:ClearChildren()
  self.RougeGameCountDown = self:CreateWidgetNew("RougeGameCountDown")
  self.Pos_Rouge_CountDown:AddChild(self.RougeGameCountDown)
  self.RougeGameCountDown:InitRougeGameCountDown()
  self.Pos_Rouge_CountDown:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function WBP_Battle_C:RefreshRougeGameCountDown(Time)
  if self.RougeGameCountDown then
    self.RougeGameCountDown:RefreshTime(Time)
  end
end

function WBP_Battle_C:OnEndRougeCanonMiniGame()
  self.Pos_Rouge_CountDown:ClearChildren()
  self.Pos_Rouge_CountDown:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Battle_C:HideSubSystem(Name, HideTag, IsHide)
  if not HideTag or not Name then
    return
  end
  if self[Name] then
    if not self.SystemHideTags[Name] then
      self.SystemHideTags[Name] = {}
    end
    local Tags = self.SystemHideTags[Name]
    if IsHide then
      Tags[HideTag] = 1
    else
      Tags[HideTag] = nil
    end
    if IsEmptyTable(Tags) then
      self[Name]:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self[Name]:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function WBP_Battle_C:SetSubSystemVisibility(Name, Visibility)
  if self[Name] and not self:IsSubSystemHide(Name) then
    self[Name]:SetVisibility(Visibility)
  end
end

function WBP_Battle_C:IsSubSystemHide(Name)
  if not Name or not self[Name] then
    DebugPrint("System Does Not Exist. Name: ", Name)
    return
  end
  local Tags = self.SystemHideTags[Name]
  if not Tags or IsEmptyTable(Tags) then
    return false
  else
    return true
  end
end

function WBP_Battle_C:OnTempleRightUI()
  self.Group_Temple:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Pos_TempleRight:ClearChildren()
  self.TempleRightUI = self:CreateWidgetNew("DungeonTempleRight")
  self.TempleRightUI:ConstructInfo()
  self.Pos_TempleRight:AddChild(self.TempleRightUI)
  self.Pos_TempleRight:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar:SetUIVisibilityTag("Temple", true)
  end
end

function WBP_Battle_C:OnPartyEnter()
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar:SetUIVisibilityTag("Party", true)
  end
end

function WBP_Battle_C:OnPartyProgressStart()
  self.PartyProgress = self:CreateWidgetNew("PartyProgress")
  self.PartyProgress:ConstructInfo()
  self.Pos_TempleProgress:AddChild(self.PartyProgress)
end

function WBP_Battle_C:OnModBookQuestFinished(QuestId)
  DebugPrint("zwk OnModBookQuestFinished", QuestId)
  if not self.ModArchives then
    self.ModArchives = TArray(0)
  end
  self.ModArchives:Add(QuestId)
  if self.ModArchives:Length() > 0 and self.ModArchives:GetRef(1) == QuestId then
    self:ShowModBookTips(QuestId)
  end
end

function WBP_Battle_C:ShowModBookTips(QuestId)
  UIManager(self):LoadUINew("ModArchiveTaskTips", self, QuestId)
end

function WBP_Battle_C:OnPreModArchiveFinished(QuestId)
  if self.ModArchives then
    self.ModArchives:RemoveItem(QuestId)
  end
  if self.ModArchives:Length() > 0 then
    local QuestId = self.ModArchives:GetRef(1)
    self:ShowModBookTips(QuestId)
  end
end

function WBP_Battle_C:OnNotifyShowLargeCountDown(Count, bShowZeroText)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local UIManager = GameInstance:GetGameUIManager()
  if nil == UIManager then
    return
  end
  local UIManager = GameInstance:GetGameUIManager()
  local GuideCountDownFloat = UIManager:GetUIObj("GuideCountDown")
  if GuideCountDownFloat then
    GuideCountDownFloat:OnCountDownEnd()
    GuideCountDownFloat:Close()
  end
  GuideCountDownFloat = UIManager:LoadUINew("GuideCountDown")
  GuideCountDownFloat:SetVisibility(ESlateVisibility.Collapsed)
  self:ShowCountDown(GuideCountDownFloat, Count + 1, bShowZeroText)
end

function WBP_Battle_C:EMAfterInitialize()
  WBP_Battle_C.Super.EMAfterInitialize(self)
  self.Platform = CommonUtils.GetDeviceTypeByPlatformName(GWorld.GameInstance)
  if self.Platform == CommonConst.CLIENT_DEVICE_TYPE.MOBILE then
    if UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.MOBILE].UI_WRAPPING_WITH_INVALIDBOX then
    end
    if UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.MOBILE].UI_WRAPPING_WITH_RETAINERBOX then
      local IsShippingPackage = UE4.UKismetSystemLibrary.IsPackagedForDistribution()
      if IsShippingPackage then
        self:ArrangeSingleWidgetWithRetainerBox(self.Pos_TaskBar, "CustomRetainerBox_TaskBar", 1, 10)
      end
      self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Drops, "CustomRetainerBox_CommonDrops", 2, 10)
      self:ArrangeSingleWidgetWithRetainerBox(self.Char_Skill, "CustomRetainerBox_Skill", 1, 3)
      self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Entry, "CustomRetainerBox_Entry", 3, 15)
    end
  elseif self.Platform == CommonConst.CLIENT_DEVICE_TYPE.PC and UIConst.OptimizeSwitch[CommonConst.CLIENT_DEVICE_TYPE.PC].UI_WRAPPING_WITH_RETAINERBOX then
    self:ArrangeSingleWidgetWithRetainerBox(self.Pos_Drops, "CustomRetainerBox_CommonDrops", 1, 10)
    self:ArrangeSingleWidgetWithRetainerBox(self.Pos_SpecialDrops, "CustomRetainerBox_SpecialDrops", 5, 10)
    self:ArrangeSingleWidgetWithRetainerBox(self.Char_Skill, "CustomRetainerBox_Skill", 2, 10)
  end
end

function WBP_Battle_C:OnHomeBaseeBtnShowNewClue(UIName)
  self:AddTimer(5, function()
    self.Btn_Task:OnHomeBaseeBtnShowNewClue(UIName)
  end, nil, nil, nil, false)
end

function WBP_Battle_C:OnNewDetectiveQuestion(Question, IsFinished)
  local QuestionData = DataMgr.DetectiveQuestion[Question]
  if not QuestionData then
    return
  end
  if QuestionData.ParentQuestionID then
    return
  end
  local ReasoningToast
  self:AddTimer(1, function()
    ReasoningToast = UIManager(self):CreateWidget("WidgetBlueprint'/Game/UI/WBP/Reasoning/Widget/WBP_Reasoning_Toast.WBP_Reasoning_Toast'", true)
    ReasoningToast.Text_Title:SetText(GText(QuestionData.Tips))
    ReasoningToast.Text_Status:SetText(GText("Minigame_Textmap_100301"))
    if IsFinished then
      ReasoningToast.Text_Status:SetText(GText("Minigame_Textmap_100302"))
    end
    ReasoningToast:PlayAnimation(ReasoningToast.In)
    AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_toast", nil, nil)
  end, nil, nil, nil, false)
  self:AddTimer(3, function()
    ReasoningToast:PlayAnimation(ReasoningToast.Out)
  end, nil, nil, nil, false)
end

function WBP_Battle_C:CreateFortBack()
  self.Pos_FortBack:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Pos_FortBack:ClearChildren()
  local FortBackKey = self:GetOrAddWidget("FortBackKey", self.Pos_FortBack)
  return FortBackKey
end

function WBP_Battle_C:DestoryFortBack()
  self.Pos_FortBack:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Pos_FortBack:ClearChildren()
end

function WBP_Battle_C:EnableGuideBookKey(bEnable)
  if bEnable then
    self:ListenForInputAction("OpenGuideBook", EInputEvent.IE_Pressed, false, {
      self,
      self.OpenGuideBook
    })
  else
    self:StopListeningForInputAction("OpenGuideBook", EInputEvent.IE_Pressed)
  end
end

function WBP_Battle_C:InitGameJumpWord()
  local JumpWordManager = USubsystemBlueprintLibrary.GetWorldSubsystem(self, UJumpWordManager)
  if JumpWordManager then
    local OptionName1 = "DamageTextAmount"
    local GameDamageTextAmount = EMCache:Get(OptionName1)
    if nil == GameDamageTextAmount then
      local OptionInfo = DataMgr.Option[OptionName1]
      local DefaultSize = OptionInfo.DefaultValue
      if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM then
        DefaultSize = OptionInfo.DefaultValueM
      end
      GameDamageTextAmount = DefaultSize / OptionInfo.ScrollMappingScale
      EMCache:Set(OptionName1, GameDamageTextAmount)
    end
    JumpWordManager:SetMaxJumpWordCountRatio(GameDamageTextAmount)
    local OptionName2 = "DamageTextScale"
    local GameDamageTextScale = EMCache:Get(OptionName2)
    if nil == GameDamageTextScale then
      local OptionInfo = DataMgr.Option[OptionName2]
      local DefaultSize = OptionInfo.DefaultValue
      if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" and OptionInfo.DefaultValueM then
        DefaultSize = OptionInfo.DefaultValueM
      end
      GameDamageTextScale = DefaultSize / OptionInfo.ScrollMappingScale
      EMCache:Set(OptionName2, GameDamageTextScale)
    end
    JumpWordManager:SetJumpWordSize(tonumber(GameDamageTextScale))
  end
end

function WBP_Battle_C:CheckTheaterEventState()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Cb(ErrCode, Ret)
    if Ret.IsJoin == true and 0 == ErrCode and (0 == Ret.State or 1 == Ret.State) then
      self:TheaterJoinPerformGame()
    end
  end
  
  Avatar:TheaterPerformStateGet(Cb)
end

function WBP_Battle_C:TheaterJoinPerformGame()
  if self.TheaterCheckTimer then
    self:RemoveTimer(self.TheaterCheckTimer)
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  
  local function Cb(ErrCode, Ret)
    if 1 == Ret.State then
      self:TheaterPerformGameStart(CommonConst.TheaterEventId, Ret.PerformList)
      return
    end
  end
  
  Avatar:TheaterPerformStateGet(Cb)
  self.TheaterTaskTime = UIManager(self):LoadUINew("TheaterTaskTime")
  self.Task:AddChild(self.TheaterTaskTime)
  self.TheaterTaskTime.IsInit = true
  self.JoinTheaterGame = true
  self.TheaterCheckTimer = self:AddTimer(1.0, function()
    self:CheckTheaterStartTime()
  end, true, 0, "TheaterTimeCheck", true)
end

function WBP_Battle_C:CheckTheaterStartTime()
  local CurrentTime = TimeUtils.NowTime()
  local CurrentDateTime = os.date("*t", CurrentTime)
  local Minutes = CurrentDateTime.min
  local Seconds = CurrentDateTime.sec
  local IsExactStartTime = 0 == Minutes and 0 == Seconds or 30 == Minutes and 0 == Seconds
  if IsExactStartTime and self.TheaterCheckTimer then
    self:RemoveTimer(self.TheaterCheckTimer)
    self.TheaterCheckTimer = nil
  end
end

function WBP_Battle_C:OnTheaterPerformGameNotice(EventId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
  if GameState:IsInRegion() and Avatar.CurrentRegionId ~= 101901 then
    for i = 0, self.ListView:GetNumItems() - 1 do
      local Item = self.ListView:GetItemAt(i)
      if Item and 19 == Item.BtnId and Item.SelfWidget then
        Item.SelfWidget:RefreshNewTheaterUI()
      end
    end
  end
end

function WBP_Battle_C:TheaterPerformGameStart(EventId, PerformList)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if self.TheaterTaskTime then
    self.Task:RemoveChild(self.TheaterTaskTime)
    self.TheaterTaskTime:Close()
  end
  self.TheaterToast = nil
  self.Pos_Rouge_CountDown:ClearChildren()
  
  local function Cb(ErrCode, Ret)
    if 0 == ErrCode and Ret.IsJoin == true then
      local Avatar = GWorld:GetAvatar()
      if not Avatar then
        return
      end
      local GameState = UE4.UGameplayStatics.GetGameState(GWorld.GameInstance)
      local RegionId = Avatar.CurrentRegionId
      if not GameState:IsInRegion() or 101901 ~= RegionId then
        DebugPrint("ayff test 当前不在剧院区域 RegionId:", RegionId)
        return
      end
      self.TheaterToast = UIManager(self):LoadUINew("TheaterToast")
      self.TheaterToast.ParentWidget = self
      self.Pos_Rouge_CountDown:AddChild(self.TheaterToast)
      self.Pos_Rouge_CountDown:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.TheaterToast.IsInit = true
      self.TheaterToast:UpdatePerformList(PerformList)
    end
  end
  
  Avatar:TheaterPerformStateGet(Cb)
end

function WBP_Battle_C:TeleportReady(IsEnd)
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    if IsEnd and true == IsEnd then
      self:StopTeleportInDungeon(true)
      return
    end
    TaskBar:SetTeleportBubble(true)
    self.IsShowingTeleportUI = true
    if TaskBar.Platform == "Mobile" then
      TaskBar.WBP_Btn_Tips3:SetVisibility(UE4.ESlateVisibility.Visable)
      TaskBar.WBP_Btn_Tips3.Text_Button:SetText(GText("DUNGEON_TELEPORT"))
      TaskBar.WBP_Btn_Tips3.Button_Area.OnClicked:Clear()
      
      local function OnTaskBarClicked()
        local CommonDialogParams = {
          RightCallbackFunction = function()
            TaskBar:PlayAnimation(TaskBar.Transmit_Out)
            local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
            if Player then
              Player.RPCComponent:NotifyServerStartDelivery()
            end
          end,
          LeftCallbackFunction = nil,
          CloseBtnCallbackFunction = nil,
          AutoFocus = true
        }
        TaskBar:RefreshTeleportBubble(true)
        UIManager(self):ShowCommonPopupUI(100267, CommonDialogParams, self)
      end
      
      TaskBar.WBP_Btn_Tips3.Button_Area.OnClicked:Add(self, OnTaskBarClicked)
    elseif TaskBar.Platform == "PC" then
      TaskBar.Text_Tips04:SetText(GText("DUNGEON_TELEPORT_LONGPRESS"))
      self:ListenForInputAction("Recovery", EInputEvent.IE_Pressed, false, {
        self,
        self.StartTeleportInDungeon
      })
      self:ListenForInputAction("Recovery", EInputEvent.IE_Released, false, {
        self,
        self.TeleportRelease
      })
    end
  end
end

function WBP_Battle_C:StartTeleportInDungeon()
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar.Key_Tips03:AddExecuteLogic(self, self.StopTeleportInDungeon)
    local PressTime = DataMgr.GlobalConstant.TeleportPressTime.ConstantValue or 1
    TaskBar.Key_Tips03:OnButtonPressed(nil, true, 0, PressTime)
    TaskBar.Key_Controller_Tips03:OnButtonPressed(nil, true, 0, PressTime)
    TaskBar:RefreshTeleportBubble(true)
  end
  DebugPrint("ayff test press teleport button")
end

function WBP_Battle_C:StopTeleportInDungeon(ForceHide)
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    self.IsShowingTeleportUI = false
    if true == ForceHide then
      TaskBar:PlayAnimation(TaskBar.Transmit_Out)
      self:StopListeningForInputAction("Recovery", EInputEvent.IE_Pressed)
      self:StopListeningForInputAction("Recovery", EInputEvent.IE_Released)
      return
    end
    TaskBar:PlayAnimation(TaskBar.Transmit_Out)
    self:StopListeningForInputAction("Recovery", EInputEvent.IE_Pressed)
    self:StopListeningForInputAction("Recovery", EInputEvent.IE_Released)
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Tag = Player:GetCharacterTag()
    if "Hook" == Tag or "HitFly" == Tag then
      DebugPrint("ayff test 传送中断，角色处于钩锁或被击飞状态，无法传送")
    else
      local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
      GameInstance.ShouldStopHookInDungeonDelivery = true
      Player.RPCComponent:NotifyServerStartDelivery()
    end
  end
  DebugPrint("ayff test release teleport button")
end

function WBP_Battle_C:TeleportRelease()
  local TaskBar = TaskUtils:GetTaskBarWidget()
  if TaskBar then
    TaskBar.Key_Tips03:OnButtonReleased()
    TaskBar.Key_Controller_Tips03:OnButtonReleased()
  end
end

AssembleComponents(WBP_Battle_C)
return WBP_Battle_C
