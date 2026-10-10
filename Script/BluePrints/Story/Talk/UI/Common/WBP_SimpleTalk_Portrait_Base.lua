require("UnLua")
require("DataMgr")
local WikiController = require("BluePrints.UI.WBP.Wiki.WikiController")
local WBP_SimpleTalk_Portrait = Class("BluePrints.Story.Talk.UI.BP_TalkBaseUINew_C")
local EImpressionButtonState = require("BluePrints.UI.UI_PC.Impression.ImpressionConst").EImpressionButtonState
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
local FNpcDataManager = require("BluePrints.Managers.NpcDataManager")
local TalkOptionComponent = require("BluePrints.Story.Talk.UI.Component.TalkOptionComponent")
local ImpressionItemHideUITag = require("BluePrints.UI.UI_PC.Impression.ImpressionConst").ImpressionItemHideUITag

function WBP_SimpleTalk_Portrait:Construct()
  WBP_SimpleTalk_Portrait.Super.Construct(self)
  self:SetStoryInputModeEnabled(true)
end

function WBP_SimpleTalk_Portrait:OnLoaded(...)
  WBP_SimpleTalk_Portrait.Super.OnLoaded(self, ...)
  DebugPrint("WBP_SimpleTalk_Portrait:OnLoaded")
  self.WikiEntryIds = {}
  self:InitImpressionUI()
end

function WBP_SimpleTalk_Portrait:InitImpressionUI()
  DebugPrint("WBP_SimpleTalk_Portrait:InitImpressionUI")
  self:InitData_Lua()
  self:InitVisibility()
  self:InitGText()
  self:InitTypingText()
  self:AdaptPlatform()
  self:ShowSkipButton(false)
  self:ShowReviewButton(false)
  self:ShowConfirmButton(false)
  self:ShowAutoPlayButton(false)
  self:SwitchBindAnimationEvents(true)
  self.OptionComp:Event_InitUI(self:BuildOptionCompInitParams())
  self.DimensionComp:Event_InitUI(self)
end

function WBP_SimpleTalk_Portrait:SwitchBindAnimationEvents(bBind)
  self:SwitchBindOptionAnimationEvents(bBind)
end

function WBP_SimpleTalk_Portrait:GetImpressionItemUIPath()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:GetImpressionItemUIPath")
  return nil
end

function WBP_SimpleTalk_Portrait:OnOptionListSelectionChanged(CurrentIndex)
  if CurrentIndex < 0 then
    self.SelectImpressionItemIndex = nil
    return
  end
  self.SelectImpressionItemIndex = CurrentIndex + 1
end

function WBP_SimpleTalk_Portrait:BuildOptionCompInitParams()
  return {
    ItemUIPathName = self.ImpressionItemUIPathName,
    OnExitClicked = function()
      self.DimensionComp:Event_FocusLost()
    end,
    OnExitClickAnimationFinished = function()
      function self.OnOptionOutAnimationFinishedCallback()
        self:StopStoryLine()
      end
      
      self:PlayAnimation(self.Option_Out)
    end,
    OnItemClicked = function(Item)
      self:OnOptionItemClicked(Item)
    end,
    OnSelectionChanged = function(CurrentIndex)
      self:OnOptionListSelectionChanged(CurrentIndex)
    end,
    OnItemHovered = function(Index)
      self:OnOptionItemHovered(Index + 1)
    end,
    OnItemUnhovered = function(Index)
      self:OnOptionItemUnhovered(Index + 1)
    end
  }
end

function WBP_SimpleTalk_Portrait:InitData_Lua()
  DebugPrint("WBP_SimpleTalk_Portrait:InitData_Lua")
  self.SelectImpressionItemIndex = nil
  self.OptionMaxNum = -1
  self.bIsTextBorderHidden = nil
  self.ImpressionItemUIPathName = self:GetImpressionItemUIPath()
  self:InitComps()
  self.DimensionComp:Event_InitData()
end

function WBP_SimpleTalk_Portrait:InitComps()
  self.PortraitComp = self.Avatar
  self.OptionComp = self.DialogueOption
  self.DimensionComp = self.Dimension
  self.DimensionComp:BindOnImpressionMapVisibilityChanged(self, self.SwitchDimensionBg)
end

function WBP_SimpleTalk_Portrait:InitTypingText()
  self.TypingText:SetTypingSpeed(0.5)
  self:SwitchBindTypingTextOnFinishEvent(true, self, self.OnWholeDialogueTypingFinished)
end

function WBP_SimpleTalk_Portrait:InitGText()
  DebugPrint("WBP_SimpleTalk_Portrait:InitGText")
  self.OptionComp:Event_InitGText()
end

function WBP_SimpleTalk_Portrait:InitVisibility()
  DebugPrint("WBP_SimpleTalk_Portrait:InitVisibility")
  self.OptionComp:Event_InitVisibility()
  self.DimensionComp:Event_InitVisibility()
  self.NpcNameText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Icon_Arrow:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:SetTextBorderHidden(true, true)
  self:ShowAutoPlayButton(false)
  self:ShowConfirmButton(false)
  self:ShowReviewButton(false)
  self:ShowSkipButton(false)
  self:ShowWikiButton(false)
end

function WBP_SimpleTalk_Portrait:BuildOptionItemDatas(OptionData, TalkTriggerId, ImpressionAreaId)
  local OptionState = self:GetOptionState(OptionData, ImpressionAreaId)
  local ImpressionDone = false
  DebugPrint("WBP_SimpleTalk_Portrait:BuildOptionItemDatas", OptionState)
  local OptionItemDatas = {}
  local SavedOptions = OptionData.SavedOptions
  local OptionId2Idx = OptionData.OptionId2Idx
  if next(SavedOptions) ~= nil then
    ImpressionDone = true
    self.OptionMaxNum = #SavedOptions
  end
  if not ImpressionDone then
    for i, Option in ipairs(OptionData.Options or {}) do
      local CallbackOptionIndex = i
      OptionItemDatas[#OptionItemDatas + 1] = {
        ImpressionUI = self,
        ItemIndex = #OptionItemDatas + 1,
        TalkTriggerId = TalkTriggerId,
        OptionState = OptionState,
        OptionType = OptionData.OptionType,
        Option = Option,
        OptionStyle = Option.OptionStyle or self.ImpressionItemUIPathName,
        UsingGM = self.TalkTask.TaskData.UsingGM,
        IsSelected = Option.bIsSelected,
        OnItemHandleEndDelegate = function(SpecifyFinishType)
          self:OnOptionItemEnd(CallbackOptionIndex, SpecifyFinishType)
        end,
        OnBeginShowCheckOrPlusUIDelegate = {
          self,
          self.OnBeginShowCheckOrPlusUI
        },
        OnEndShowCheckOrPlusUIDelegate = {
          self,
          self.OnEndShowCheckOrPlusUI
        },
        OnInterruptedExitDelegate = {
          self,
          self.StopStoryLine
        }
      }
    end
  else
    for _, SavedOptionId in ipairs(SavedOptions or {}) do
      local OptionIdx = OptionId2Idx[SavedOptionId]
      local Option = OptionData.Options[OptionIdx]
      if Option then
        local CallbackOptionIndex = OptionIdx
        OptionItemDatas[#OptionItemDatas + 1] = {
          ImpressionUI = self,
          ItemIndex = #OptionItemDatas + 1,
          TalkTriggerId = TalkTriggerId,
          OptionState = OptionState,
          OptionType = ETalkOptionType.Normal,
          Option = Option,
          OptionStyle = Option.OptionStyle or self.ImpressionItemUIPathName,
          UsingGM = self.TalkTask.TaskData.UsingGM,
          IsSelected = Option.bIsSelected,
          OnItemHandleEndDelegate = function(SpecifyFinishType)
            self:OnOptionItemEnd(CallbackOptionIndex, SpecifyFinishType)
          end,
          OnBeginShowCheckOrPlusUIDelegate = {
            self,
            self.OnBeginShowCheckOrPlusUI
          },
          OnEndShowCheckOrPlusUIDelegate = {
            self,
            self.OnEndShowCheckOrPlusUI
          },
          OnInterruptedExitDelegate = {
            self,
            self.StopStoryLine
          }
        }
      end
    end
  end
  self.OptionMaxNum = #OptionItemDatas
  return OptionItemDatas
end

function WBP_SimpleTalk_Portrait:InitOptions(OptionData, TalkTriggerId, ImpressionAreaId)
  local OptionItemDatas = self:BuildOptionItemDatas(OptionData, TalkTriggerId, ImpressionAreaId)
  self.OptionComp:Event_InitItems(OptionItemDatas)
end

function WBP_SimpleTalk_Portrait:InitPlayKey()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:InitPlayKey")
end

function WBP_SimpleTalk_Portrait:InitAutoPlay()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:InitAutoPlay")
end

function WBP_SimpleTalk_Portrait:SwitchBindTypingTextOnFinishEvent(bBind, Obj, Func)
  if bBind then
    self.TypingText:BindEventOnFinished(Obj, Func)
  else
    self.TypingText:UnBindEventOnFinished()
  end
end

function WBP_SimpleTalk_Portrait:SwitchBindOptionAnimationEvents(bBind)
  if bBind then
    self:BindToAnimationFinished(self.Option_In, {
      self,
      self.OnOptionInAnimationFinished
    })
    self:BindToAnimationFinished(self.Option_Out, {
      self,
      self.OnOptionOutAnimationFinished
    })
    self:BindToAnimationStarted(self.Option_Out, {
      self,
      self.OnOptionOutAnimationStarted
    })
    self:BindToAnimationStarted(self.Option_In, {
      self,
      self.OnOptionInAnimationStarted
    })
  else
    self:UnbindFromAnimationFinished(self.Option_In, {
      self,
      self.OnOptionInAnimationFinished
    })
    self:UnbindFromAnimationFinished(self.Option_Out, {
      self,
      self.OnOptionOutAnimationFinished
    })
    self:UnbindFromAnimationStarted(self.Option_In, {
      self,
      self.OnOptionInAnimationStarted
    })
    self:UnbindFromAnimationStarted(self.Option_Out, {
      self,
      self.OnOptionOutAnimationStarted
    })
  end
end

function WBP_SimpleTalk_Portrait:PreEnterTalkTask(TalkTask, TaskData, OnPreEnterTalkTaskFinished)
  DebugPrint("WBP_SimpleTalk_Portrait:PreEnterTalkTask")
  WBP_SimpleTalk_Portrait.Super.PreEnterTalkTask(self, TalkTask, TaskData, OnPreEnterTalkTaskFinished)
end

function WBP_SimpleTalk_Portrait:PostEnterTalkTask(TalkTask, TaskData, OnPostEnterTalkTaskFinished)
  self.HasShowWikiButton = false
  DebugPrint("WBP_SimpleTalk_Portrait:PostEnterTalkTask")
  self:RecordData(TaskData)
  self:SwitchEnableWikiButton(false)
  self:SwitchEnableSkipButton(self.bDefaultShowSkipButton)
  self:SwitchEnableReviewButton(self.bDefaultShowReviewButton)
  self:SwitchEnableAutoPlayButton(self.bDefaultShowAutoPlayButton)
  self:InitPlayKey()
  self:InitAutoPlay()
  WBP_SimpleTalk_Portrait.Super.PostEnterTalkTask(self, TalkTask, TaskData, OnPostEnterTalkTaskFinished)
end

function WBP_SimpleTalk_Portrait:RecordData(TaskData)
  self.bDefaultShowAutoPlayButton = TaskData.bShowAutoPlayButton or false
  self.bDefaultShowReviewButton = TaskData.bShowReviewButton or false
  self.bDefaultShowSkipButton = TaskData.bShowSkipButton or false
  self.bDefaultShowWikiButton = TaskData.bShowWikiButton or false
end

function WBP_SimpleTalk_Portrait:PreExitTalkTask(TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
  DebugPrint("WBP_SimpleTalk_Portrait:PreExitTalkTask", TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
  self:TryHideLastDialoguePic()
  self:SetRecallGraphHidden()
  self:StopTypingAudio()
  self:SwitchEnableWikiButton(false)
  self:SwitchBindAnimationEvents(false)
  self.DimensionComp:Event_PreExit()
  self:SwitchEnableSkipButton(false)
  self:SwitchEnableReviewButton(false)
  self:SwitchEnableAutoPlayButton(false)
  self:ClearOptions()
  self:StopAllAnimations()
  WBP_SimpleTalk_Portrait.Super.PreExitTalkTask(self, TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
end

function WBP_SimpleTalk_Portrait:PlayDialogue(TalkTask, DialogueData, TaskData, bSkip)
  DebugPrint("WBP_SimpleTalk_Portrait:PlayDialogue", TalkTask, DialogueData, TaskData)
  self:StopTypingAudio()
  self:InitDialogueData(DialogueData)
  local DialogueRow = DataMgr.Dialogue[DialogueData.DialogueId]
  local bSpeakerExists = nil ~= DialogueRow and (nil ~= DialogueRow.SpeakNpcId or not string.isempty(DialogueRow.SpeakNpcName))
  local PortraitFacialRow
  if 0 ~= DialogueData.TalkActorId then
    PortraitFacialRow = FNpcDataManager:GetPortraitFacialRow(DialogueData.TalkActorId, DialogueData.PortraitFacialType)
  end
  self.PortraitComp:SetFacial(bSpeakerExists, PortraitFacialRow)
  self:SetTalkActorName(DialogueData)
  self:SetTypingTextAlignment(DialogueData)
  self.TypingText:Typing(DialogueData.Content)
  self:TryPlayDialogueTypingAudio(DialogueData)
  self:SwitchHideDialoguePanel(false)
  if DialogueData.DialogueId and DataMgr.Dialogue[DialogueData.DialogueId].RelatedWikiId then
    for index, value in pairs(DataMgr.Dialogue[DialogueData.DialogueId].RelatedWikiId) do
      table.insert(self.WikiEntryIds, value)
    end
    self:TryShowWikiButton(TalkTask)
  end
  
  local function Callback()
    if DialogueData.DialoguePanelType == "Voiceover" then
      self.bUseVoiceover = true
      self:SetTipImageHidden(false)
      self:SetTextBorderHidden(false)
      self:SwitchEnableTalkClick(true)
      self.NpcNameText:SetVisibility(ESlateVisibility.Collapsed)
    else
      if self.bUseVoiceover then
        self.bUseVoiceover = false
        self.NpcNameText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      end
      if DialogueData.DialoguePanelType == "None" then
        self:SetTipImageHidden(true)
        self:SetTextBorderHidden(true)
        self:SwitchEnableTalkClick(false)
        self.WholeDialogueTypingFinished_Delegate:Fire(true)
      else
        self:SetTipImageHidden(false)
        self:SetTextBorderHidden(false)
        self:SwitchEnableTalkClick(true)
      end
      if DialogueData.DialoguePanelType == "AllHide" then
        self:SetVisibility(ESlateVisibility.Collapsed)
        self:SetTipImageHidden(true)
        self:SetTextBorderHidden(true)
        self:SwitchEnableTalkClick(false)
        self.WholeDialogueTypingFinished_Delegate:Fire(true)
      end
    end
  end
  
  self:TryHideLastDialoguePic()
  if DialogueData.DialogueGraphPath then
    self:OnPlayRecallGraph(DialogueData, bSkip)
    Callback()
  else
    self:OnNotPlayRecallGraph()
    self:TryShowDialoguePic(DialogueData)
    if self.bShowingRecall then
      self.bShowingRecall = false
      self:DelayPlayRecallAnim(false)
      Callback()
    else
      Callback()
    end
  end
end

function WBP_SimpleTalk_Portrait:OnTalkAudioStateChanged(AudioState)
  if "Play" == AudioState then
    self.PortraitComp:SetMouthState(self.PortraitComp.EMouthState.Speak)
  else
    self.PortraitComp:SetMouthState(self.PortraitComp.EMouthState.Idle)
  end
end

function WBP_SimpleTalk_Portrait:OnOptionItemEnd(ItemIdx, SpecifyFinishType)
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionItemEnd")
  
  function self.OnOptionOutAnimationFinishedCallback()
    if self.OptionChosenCallback then
      self.OptionChosenCallback(ItemIdx, SpecifyFinishType)
    end
    self.OptionChosenCallback = nil
  end
  
  self:ResetNormalButton()
  self:PlayAnimation(self.Option_Out)
end

function WBP_SimpleTalk_Portrait:ResetNormalButton()
  self:SwitchEnableSkipButton(self.bDefaultShowSkipButton)
  self:SwitchEnableReviewButton(self.bDefaultShowReviewButton)
  self:SwitchEnableAutoPlayButton(self.bDefaultShowAutoPlayButton)
  if self.HasShowWikiButton then
    self:SwitchEnableWikiButton(self.bDefaultShowWikiButton)
  end
end

function WBP_SimpleTalk_Portrait:OnBeginShowCheckOrPlusUI()
  DebugPrint("WBP_SimpleTalk_Portrait:OnBeginShowCheckOrPlusUI")
  self:Hide(ImpressionItemHideUITag)
  self:SetTipImageHidden(true)
  self:SetTextBorderHidden(true)
end

function WBP_SimpleTalk_Portrait:OnEndShowCheckOrPlusUI()
  DebugPrint("WBP_SimpleTalk_Portrait:OnEndShowCheckOrPlusUI")
  self:Show(ImpressionItemHideUITag)
end

function WBP_SimpleTalk_Portrait:OnUpSelectItem()
  self.OptionComp:UpSelectAction()
end

function WBP_SimpleTalk_Portrait:OnDownSelectItem()
  self.OptionComp:DownSelectAction()
end

function WBP_SimpleTalk_Portrait:SwithShowExitButton(bShow)
  self.OptionComp:ShowExitButton(bShow)
end

function WBP_SimpleTalk_Portrait:ChangeExitButtonVisibilityFromOptionType(OptionData)
  if OptionData.OptionType == ETalkOptionType.Check then
    self:SwithShowExitButton(true)
  else
    self:SwithShowExitButton(false)
  end
end

function WBP_SimpleTalk_Portrait:IsOptionCanCheck(ImpressionAreaId, OptionData)
  local bCanCheck = true
  local OptionType = OptionData.OptionType
  if OptionType == ETalkOptionType.Check and self:IsRetryCheck(OptionData) then
    return ImpressionModel:CanImpressionCheck(ImpressionAreaId).bCanCheck
  end
  return bCanCheck
end

function WBP_SimpleTalk_Portrait:IsRetryCheck(OptionData)
  if not ImpressionModel:IsValid() then
    return false
  end
  local Options = OptionData.Options
  if not Options then
    return false
  end
  for _, Option in pairs(Options) do
    local DialogueId = Option.OptionId
    if ImpressionModel:IsImpressionCheckFailure(DialogueId) then
      return true
    end
  end
  return false
end

function WBP_SimpleTalk_Portrait:GetOptionState(OptionData, ImpressionAreaId)
  local OptionState = EImpressionButtonState.Enabled
  local bCanCheck = self:IsOptionCanCheck(ImpressionAreaId, OptionData)
  if not bCanCheck then
    OptionState = EImpressionButtonState.Disabled
  end
  return OptionState
end

function WBP_SimpleTalk_Portrait:GetOptionImpressionAreaId(OptionData)
  local ImpressionAreaId
  local OptionType = OptionData.OptionType
  if OptionType == ETalkOptionType.Plus then
    local PlusId = OptionData.Options[1].PlusId
    local PlusData = DataMgr.ImpressionPlus[PlusId]
    if PlusData then
      ImpressionAreaId = PlusData.RegionId
    else
      local Title = "印象加值Id不存在"
      local Message = string.format("加值Id: %s 在ImpressionPlus表中不存在，请检查配置", tostring(PlusId))
      UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Impression, Title, Message)
      return nil, false
    end
  elseif OptionType == ETalkOptionType.Check then
    local CheckId = OptionData.Options[1].CheckId
    local CheckData = DataMgr.ImpressionCheck[CheckId]
    if CheckData then
      ImpressionAreaId = CheckData.RegionId
    else
      local Title = "印象检定Id不存在"
      local Message = string.format("检定Id: %s 在ImpressionCheck表中不存在，请检查配置", tostring(CheckId))
      UStoryLogUtils.PrintToFeiShu(self, UE.EStoryLogType.Impression, Title, Message)
      return nil, false
    end
  end
  return ImpressionAreaId, true
end

function WBP_SimpleTalk_Portrait:GetCurrentSelectIndex()
  return self.SelectImpressionItemIndex
end

function WBP_SimpleTalk_Portrait:InitOptionData(TalkTask, OptionData, OptionChosenCallback)
  self.TalkTask = TalkTask
  self.OptionData = OptionData
  self.OptionMaxNum = #OptionData.Options
  self.OptionChosenCallback = OptionChosenCallback
end

function WBP_SimpleTalk_Portrait:ShowOptions(TalkTask, OptionData, OptionChosenCallback)
  DebugPrint("WBP_SimpleTalk_Portrait:ShowOptions", TalkTask, OptionData, OptionChosenCallback)
  self:TryHideLastDialoguePic()
  self:StopTypingAudio()
  self:InitOptionData(TalkTask, OptionData, OptionChosenCallback)
  self:PlayAnimation(self.Option_In)
  local OptionType = OptionData.OptionType
  if OptionType == ETalkOptionType.Plus or OptionType == ETalkOptionType.Check then
    EventManager:FireEvent(EventID.ImpressionTalk)
  end
end

function WBP_SimpleTalk_Portrait:ClearOptions()
  DebugPrint("WBP_SimpleTalk_Portrait:ClearOptions")
  self.OptionComp:ClearListItems()
  self.SelectImpressionItemIndex = nil
end

function WBP_SimpleTalk_Portrait:GetTalkActorName(DialogueData)
  local Name = DialogueData.TalkActorName
  if not Name then
    local TalkActorData = DialogueData.TalkActorData
    if TalkActorData then
      Name = TalkUtils:GetTalkActorName(TalkActorData.TalkActorType, TalkActorData.TalkActorId)
    else
      Name = TalkUtils:GetTalkActorName("Npc", DialogueData.TalkActorId)
    end
  end
  return GText(Name)
end

function WBP_SimpleTalk_Portrait:SetTalkActorName(DialogueData)
  self.NpcNameText:SetText(self:GetTalkActorName(DialogueData))
end

function WBP_SimpleTalk_Portrait:SetTypingTextAlignment(DialogueData)
  local Alignment = EHorizontalAlignment.HAlign_Center
  if not string.isempty(self:GetTalkActorName(DialogueData)) then
    Alignment = EHorizontalAlignment.HAlign_Left
  end
  self.TypingText:SetHorizontalAlignment(Alignment)
end

function WBP_SimpleTalk_Portrait:SetTextBorderHidden(bHidden, bImmediate)
  if self.bIsTextBorderHidden == bHidden then
    return
  end
  self.bIsTextBorderHidden = bHidden
  if bImmediate then
    local PlayMode = bHidden and EUMGSequencePlayMode.Reverse or EUMGSequencePlayMode.Forward
    self:PlayAnimation(self.Dialog_In, self.Dialog_In:GetEndTime(), 1, PlayMode)
  elseif bHidden then
    self:PlayAnimationReverse(self.Dialog_In)
  else
    self:PlayAnimationForward(self.Dialog_In)
  end
end

function WBP_SimpleTalk_Portrait:ToPageEnd()
  self.TypingText:ToPageEnd()
end

function WBP_SimpleTalk_Portrait:HasPageTypingFinished()
  return self.TypingText:IsPageEnd()
end

function WBP_SimpleTalk_Portrait:HasWholeDialogueTypingFinished()
  return self.TypingText:IsFinished()
end

function WBP_SimpleTalk_Portrait:TryPlayDialogueTypingAudio(DialogueData)
  if DialogueData and not DialogueData.VoiceName then
    AudioManager(self):PlayUISound(self, "event:/ui/common/dialog_type", "TypingAudioKey", nil)
    self.TypingText:BindEventOnPageEnd(self, self.StopTypingAudio)
  end
end

function WBP_SimpleTalk_Portrait:StopTypingAudio()
  AudioManager(self):StopSound(self, "TypingAudioKey")
  self.TypingText:UnBindEventOnPageEnd()
end

function WBP_SimpleTalk_Portrait:SwitchEnableTalkClick(bEnable)
  DebugPrint("WBP_SimpleTalk_Portrait:SwitchEnableTalkClick", bEnable)
  self:SwitchEnableConfirmButton(bEnable)
  self:StopListeningForInputAction("TalkClick", EInputEvent.IE_Pressed)
  self:StopListeningForInputAction("TalkClick", EInputEvent.IE_Released)
  if bEnable then
    self:ListenForInputAction("TalkClick", EInputEvent.IE_Pressed, false, {
      self,
      self.OnTalkClickPressed
    })
    self:ListenForInputAction("TalkClick", EInputEvent.IE_Released, false, {
      self,
      self.OnTalkClickReleased
    })
    self:ListenForInputAction("TalkClick", EInputEvent.IE_Pressed, false, {
      self,
      self.ActiveUI
    })
    self:ListenForInputAction("TalkClick", EInputEvent.IE_Released, false, {
      self,
      self.ActiveUI
    })
  end
end

function WBP_SimpleTalk_Portrait:SetTipImageHidden(bHidden)
  DebugPrint("WBP_SimpleTalk_Portrait:SetTipImageHidden", bHidden)
  self.WS_Type:SetVisibility(bHidden and ESlateVisibility.Collapsed or ESlateVisibility.SelfHitTestInvisible)
end

function WBP_SimpleTalk_Portrait:SwitchDimensionBg(bShow)
  if bShow then
    self:StopAnimation(self.BtnBg_Out)
    self:StopAnimation(self.BtnBg_In)
    self:PlayAnimation(self.BtnBg_In)
  else
    self:StopAnimation(self.BtnBg_Out)
    self:StopAnimation(self.BtnBg_In)
    self:PlayAnimation(self.BtnBg_Out)
  end
end

function WBP_SimpleTalk_Portrait:StopStoryLine()
  DebugPrint("WBP_SimpleTalk_Portrait:StopStoryLine")
  self.StopStoryline_Delegate:Fire()
end

function WBP_SimpleTalk_Portrait:OnOptionItemHovered(ItemIndex)
end

function WBP_SimpleTalk_Portrait:OnOptionItemUnhovered(ItemIndex)
end

function WBP_SimpleTalk_Portrait:OnOptionItemClicked(Item)
  DebugPrint("WBP_SimpleTalk_Portrait:OnClickedItem", Item.State)
  self:StopAllAnimations()
  if Item.State == EImpressionButtonState.Enabled then
    self.DimensionComp:Event_FocusLost()
    if self.OptionData.OptionType == ETalkOptionType.Check then
      local Options = {}
      for i, Option in ipairs(self.OptionData.Options) do
        table.insert(Options, Option.OptionId)
      end
      local OptionData = {
        bImpression = true,
        OptionType = "Check",
        Options = Options,
        VisitedOptions = {},
        SelectedOption = Item.Option.OptionId
      }
      self.TalkTask.DialogueRecordComponent:OnOptionRecord(OptionData.SelectedOption, OptionData, true)
    end
    self:SwitchEnableReviewButton(false)
    self:SwitchEnableWikiButton(false)
  end
end

function WBP_SimpleTalk_Portrait:GetCurrentOptionItem()
  if not self.SelectImpressionItemIndex then
    return nil
  end
  return self.OptionComp:GetItemByDisplayIndex(self.SelectImpressionItemIndex, self.OptionMaxNum)
end

function WBP_SimpleTalk_Portrait:OnOptionInAnimationStarted()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionInAnimationStarted")
  self.SelectImpressionItemIndex = nil
  local TalkTriggerId = self.TalkTask.TaskData.TalkTriggerId
  local ImpressionAreaId, Ret = self:GetOptionImpressionAreaId(self.OptionData)
  if not Ret then
    return
  end
  self.ImpressionAreaId = ImpressionAreaId
  self:InitOptions(self.OptionData, TalkTriggerId, ImpressionAreaId)
  self:SwitchEnableTalkClick(false)
  self:SwitchEnableAutoPlayButton(false)
  self:SwitchEnableSkipButton(false)
  self:SetTipImageHidden(true)
  self:ChangeExitButtonVisibilityFromOptionType(self.OptionData)
  self:ChangeImgMouseVisibility(self.OptionData)
  self.OptionComp:Event_DisplayStarted(self.OptionData.OptionType, ImpressionAreaId, self:IsRetryCheck(self.OptionData))
  self.DimensionComp:Event_DisplayStarted()
end

function WBP_SimpleTalk_Portrait:OnOptionInAnimationFinished()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionInAnimationFinished")
  self.OptionComp:Event_DisplayStartFinished()
end

function WBP_SimpleTalk_Portrait:OnOptionOutAnimationStarted()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionOutAnimationStarted", self.OnOptionOutAnimationFinishedCallback)
  self.OptionComp:Event_DisplayEnded()
  self.DimensionComp:Event_DisplayEnded()
  if self.OnOptionOutAnimationFinishedCallback then
    self.OnOptionOutAnimationFinishedCallback()
    self.OnOptionOutAnimationFinishedCallback = nil
  end
  self.SelectImpressionItemIndex = nil
end

function WBP_SimpleTalk_Portrait:IsExitButtonSelect()
  return self.bExitButtonSelect
end

function WBP_SimpleTalk_Portrait:OnOptionOutAnimationFinished()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionOutAnimationFinished")
end

function WBP_SimpleTalk_Portrait:OnUseOtherUIPlayDialogue()
  self:SwitchHideDialoguePanel(true)
  self:TryHideLastDialoguePic()
end

function WBP_SimpleTalk_Portrait:SwitchHideDialoguePanel(bHide)
  self:SetTextBorderHidden(bHide)
end

function WBP_SimpleTalk_Portrait:ChangeImgMouseVisibility(OptionData)
  self.OptionComp:Event_ChangeImgMouseVisibility(OptionData, self.OptionMaxNum)
end

function WBP_SimpleTalk_Portrait:AdaptPlatform()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:AdaptPlatform")
end

function WBP_SimpleTalk_Portrait:Destruct()
  self.DimensionComp:Event_Destruct()
  self.OptionComp = nil
  WBP_SimpleTalk_Portrait.Super.Destruct(self)
end

AssembleComponents(WBP_SimpleTalk_Portrait)
return WBP_SimpleTalk_Portrait
