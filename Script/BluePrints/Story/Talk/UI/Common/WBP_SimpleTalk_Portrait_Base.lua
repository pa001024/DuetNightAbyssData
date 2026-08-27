require("UnLua")
require("DataMgr")
local WikiController = require("BluePrints.UI.WBP.Wiki.WikiController")
local WBP_SimpleTalk_Portrait = Class("BluePrints.Story.Talk.UI.BP_TalkBaseUINew_C")
WBP_SimpleTalk_Portrait._components = {
  "BluePrints.Story.Talk.UI.Component.ImpressionComponent",
  "BluePrints.Story.Talk.UI.Component.PortraitComponent"
}
local EImpressionButtonState = require("BluePrints.UI.UI_PC.Impression.ImpressionConst").EImpressionButtonState
local ETalkOptionType = require("BluePrints.Story.Talk.Model.TalkOptionData").ETalkOptionType
local ImpressionModel = require("BluePrints.Story.Talk.Model.ImpressionModel")
local TalkUtils = require("BluePrints.Story.Talk.View.TalkUtils")
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
  self:InitEvent_ImpressionComp()
end

function WBP_SimpleTalk_Portrait:SwitchBindAnimationEvents(bBind)
  self:SwitchBindOptionAnimationEvents(bBind)
  self:SwitchBindExitAnimationEvents(bBind)
end

function WBP_SimpleTalk_Portrait:GetImpressionItemUIPath()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:GetImpressionItemUIPath")
  return nil
end

function WBP_SimpleTalk_Portrait:BuildExitSelectableConfig()
  return {
    Widget = self.Button_Area,
    IsEnabled = function()
      return self:IsExitButtonHidden()
    end,
    OnSelect = function()
      self:OnExitButtonSelected(true)
    end,
    OnUnselect = function()
      self:OnExitButtonSelected(false)
    end,
    OnPressed = function()
      self:OnExitButtonPressed()
    end,
    OnReleased = function()
      self:OnExitButtonClicked()
    end
  }
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
    Img_Mouse = self.Img_Mouse,
    ScrollBox = self.ScrollBox_Items,
    ItemUIPathName = self.ImpressionItemUIPathName,
    ExtraSelectable = self:BuildExitSelectableConfig(),
    OnSelectionChanged = function(CurrentIndex)
      self:OnOptionListSelectionChanged(CurrentIndex)
    end,
    OnItemHovered = function(Index)
      self:OnImpressionItemHovered(Index + 1)
    end
  }
end

function WBP_SimpleTalk_Portrait:InitData_Lua()
  DebugPrint("WBP_SimpleTalk_Portrait:InitData_Lua")
  self.SelectImpressionItemIndex = nil
  self.OptionMaxNum = -1
  self.bIsTextBorderHidden = true
  self.ImpressionItemUIPathName = self:GetImpressionItemUIPath()
  self:InitData_ImpressionComp()
  self:InitComps()
end

function WBP_SimpleTalk_Portrait:InitComps()
  self.OptionComp = TalkOptionComponent:New()
  self.OptionComp:Init(self, self:BuildOptionCompInitParams())
end

function WBP_SimpleTalk_Portrait:InitTypingText()
  self.TypingText:SetTypingSpeed(0.5)
  self:SwitchBindTypingTextOnFinishEvent(true, self, self.OnWholeDialogueTypingFinished)
end

function WBP_SimpleTalk_Portrait:InitGText()
  DebugPrint("WBP_SimpleTalk_Portrait:InitGText")
  self.Text_TipsTitle:SetText(GText("Impression_Repeat_Dice"))
  self.Text_Button:SetText(GText("Impression_UI_Back"))
end

function WBP_SimpleTalk_Portrait:InitVisibility()
  DebugPrint("WBP_SimpleTalk_Portrait:InitVisibility")
  self:InitVisibility_ImpressionComp()
  self.NpcNameText:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Icon_Arrow:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self:SetTextBorderHidden(true)
  self:ShowAutoPlayButton(false)
  self:ShowConfirmButton(false)
  self:ShowReviewButton(false)
  self:ShowSkipButton(false)
  self:ShowWikiButton(false)
  self:SwitchShowOptionUI(false)
end

function WBP_SimpleTalk_Portrait:BuildImpressionOptionItemDatas(OptionData, TalkTriggerId, ImpressionAreaId)
  local OptionState = self:GetOptionState(OptionData, ImpressionAreaId)
  local ImpressionDone = false
  DebugPrint("WBP_SimpleTalk_Portrait:BuildImpressionOptionItemDatas", OptionState)
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
        },
        OnHoveredDelegate = {
          self,
          self.OnImpressionItemHovered
        },
        OnUnhoveredDelegate = {
          self,
          self.OnImpressionItemUnhovered
        },
        OnClickedDelegate = {
          self,
          self.OnImpressionItemClicked
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
          },
          OnHoveredDelegate = {
            self,
            self.OnImpressionItemHovered
          },
          OnUnhoveredDelegate = {
            self,
            self.OnImpressionItemUnhovered
          },
          OnClickedDelegate = {
            self,
            self.OnImpressionItemClicked
          }
        }
      end
    end
  end
  self.OptionMaxNum = #OptionItemDatas
  return OptionItemDatas
end

function WBP_SimpleTalk_Portrait:InitOptions(OptionData, TalkTriggerId, ImpressionAreaId, OnOptionItemClicked)
  self.OptionComp:ClearListItems()
  local OptionItemDatas = self:BuildImpressionOptionItemDatas(OptionData, TalkTriggerId, ImpressionAreaId)
  self.OptionComp:AddItems(OptionItemDatas)
end

function WBP_SimpleTalk_Portrait:InitPlayKey()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:InitPlayKey")
end

function WBP_SimpleTalk_Portrait:InitAutoPlay()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:InitAutoPlay")
end

function WBP_SimpleTalk_Portrait:SwitchBindExitButtonEvents(bBind)
  DebugPrint("WBP_SimpleTalk_Portrait:SwitchBindExitButtonEvents", bBind)
  if bBind then
    self.Button_Area.OnClicked:Add(self, self.OnExitButtonClicked)
    self.Button_Area.OnHovered:Add(self, self.OnExitButtonHovered)
    self.Button_Area.OnUnhovered:Add(self, self.OnExitButtonUnhovered)
    self.Button_Area.OnPressed:Add(self, self.OnExitButtonPressed)
    self.Button_Area.OnReleased:Add(self, self.OnExitButtonReleased)
  else
    self.Button_Area.OnClicked:Remove(self, self.OnExitButtonClicked)
    self.Button_Area.OnHovered:Remove(self, self.OnExitButtonHovered)
    self.Button_Area.OnUnhovered:Remove(self, self.OnExitButtonUnhovered)
    self.Button_Area.OnPressed:Remove(self, self.OnExitButtonPressed)
    self.Button_Area.OnReleased:Remove(self, self.OnExitButtonReleased)
  end
end

function WBP_SimpleTalk_Portrait:SwitchBindExitAnimationEvents(bBind)
  if bBind then
    self:BindToAnimationFinished(self.BtnQuit_Click, {
      self,
      self.OnExitButtonClickAnimFinished
    })
  else
    self:UnbindFromAnimationFinished(self.BtnQuit_Click, {
      self,
      self.OnExitButtonClickAnimFinished
    })
  end
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

function WBP_SimpleTalk_Portrait:SwitchEnableImpressionItemClick(bBind)
  DebugPrint("WBP_SimpleTalk_Portrait:SwitchBindImpressionItemButtonEvents", bBind)
  local ChildMaxIndex = self.ScrollBox_Items:GetChildrenCount() - 1
  for i = 0, ChildMaxIndex do
    local ImpressionItem = self.ScrollBox_Items:GetChildAt(i)
    if ImpressionItem then
      ImpressionItem:SwitchEnableClickEvents(bBind)
    end
  end
end

function WBP_SimpleTalk_Portrait:SwitchEnableItemEvents(Enable)
  self.OptionComp:SwitchEnableConfirmEvents(Enable)
end

function WBP_SimpleTalk_Portrait:SwitchEnableMouseWheelEvents(Enable)
  DebugPrint("WBP_SimpleTalk_Portrait:SetMouseWheelEventEnable", Enable)
  self.OptionComp:SwitchEnableUpDownEvents(Enable)
end

function WBP_SimpleTalk_Portrait:SwitchEnableOptionClick(bIsEnable)
  DebugPrint("WBP_SimpleTalk_Portrait:SetOptionClickEnable", bIsEnable)
  self:SwitchBindExitButtonEvents(bIsEnable)
  self:SwitchEnableImpressionItemClick(bIsEnable)
  self:SwitchEnableItemEvents(bIsEnable)
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
  self:PlayAnimation(self.Dialog_In)
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
  self:OnPreExit_ImpressionComp()
  self:SwitchEnableSkipButton(false)
  self:SwitchEnableReviewButton(false)
  self:SwitchEnableAutoPlayButton(false)
  self:ClearOptions()
  self:StopAllAnimations()
  self:PlayAnimation(self.Dialog_Out)
  WBP_SimpleTalk_Portrait.Super.PreExitTalkTask(self, TalkTask, TalkData, OnPreExitTalkTaskFinished, OutType, OutTime)
end

function WBP_SimpleTalk_Portrait:PlayDialogue(TalkTask, DialogueData, TaskData, bSkip)
  DebugPrint("WBP_SimpleTalk_Portrait:PlayDialogue", TalkTask, DialogueData, TaskData)
  self:StopTypingAudio()
  self:InitDialogueData(DialogueData)
  self:OnDialogueStarted_PortraitComp(DialogueData)
  self:SetTalkActorName(DialogueData)
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
  self:OnTalkAudioStateChanged_PortraitComp(AudioState)
end

function WBP_SimpleTalk_Portrait:OnOptionItemEnd(ItemIdx, SpecifyFinishType)
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionItemEnd")
  
  function self.OnOptionOutAnimationFinishedCallback()
    if self.OnOptionItemClicked then
      self.OnOptionItemClicked(ItemIdx, SpecifyFinishType)
    end
    self.OnOptionItemClicked = nil
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
  if bShow then
    self.Group_Button:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Group_Button:SetVisibility(ESlateVisibility.Collapsed)
  end
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

function WBP_SimpleTalk_Portrait:IsExitButtonHidden()
  return self.Group_Button:GetVisibility() ~= ESlateVisibility.Collapsed
end

function WBP_SimpleTalk_Portrait:SwitchShowOptionUI(bShow)
  if bShow then
    self.VB_GroupItem:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.VB_GroupItem:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_SimpleTalk_Portrait:InitOptionData(TalkTask, OptionData, OnOptionItemClicked)
  self.TalkTask = TalkTask
  self.OptionData = OptionData
  self.OptionMaxNum = #OptionData.Options
  self.OnOptionItemClicked = OnOptionItemClicked
end

function WBP_SimpleTalk_Portrait:ShowOptions(TalkTask, OptionData, OnOptionItemClicked)
  DebugPrint("WBP_SimpleTalk_Portrait:ShowOptions", TalkTask, OptionData, OnOptionItemClicked)
  self:TryHideLastDialoguePic()
  self:StopTypingAudio()
  self:InitOptionData(TalkTask, OptionData, OnOptionItemClicked)
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

function WBP_SimpleTalk_Portrait:SetExitButtonNormal()
  self:PlayAnimation(self.BtnQuit_Normal)
end

function WBP_SimpleTalk_Portrait:SetTalkActorName(DialogueData)
  local Name = DialogueData.TalkActorName
  if not Name then
    local TalkActorData = DialogueData.TalkActorData
    if TalkActorData then
      Name = TalkUtils:GetTalkActorName(TalkActorData.TalkActorType, TalkActorData.TalkActorId)
    else
      Name = TalkUtils:GetTalkActorName("Npc", DialogueData.TalkActorId)
    end
  end
  local Name = GText(Name)
  self.NpcNameText:SetText(Name)
end

function WBP_SimpleTalk_Portrait:SetTextBorderHidden(bHidden)
  if bHidden then
    self.Group_Dialog:SetVisibility(ESlateVisibility.Collapsed)
  else
    self.Group_Dialog:SetVisibility(ESlateVisibility.HitTestInvisible)
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

function WBP_SimpleTalk_Portrait:OnExitButtonSelected(bIsSelect)
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonSelected", bIsSelect)
  self.bExitButtonSelect = bIsSelect
  if bIsSelect then
    self:PlayExitButtonHoveredPerformance()
  else
    self:PlayExitButtonUnhoveredPerformance()
  end
  self:OnExitButtonSelectedPlatform(bIsSelect)
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

function WBP_SimpleTalk_Portrait:OnExitButtonClicked()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonClicked")
  self:SwitchEnableOptionClick(false)
  self:PlayAnimation(self.BtnQuit_Click)
  self:OnFocusLost_ImpressionComp()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_return", "", nil)
end

function WBP_SimpleTalk_Portrait:OnExitButtonHovered()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonHovered")
  self.OptionComp:OnExtraHovered()
end

function WBP_SimpleTalk_Portrait:OnExitButtonUnhovered()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonUnhovered")
end

function WBP_SimpleTalk_Portrait:PlayExitButtonHoveredPerformance()
  DebugPrint("WBP_SimpleTalk_Portrait:PlayExitButtonHoveredPerformance")
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_add", "", nil)
  self:PlayExitButtonHoveredPerformanceByPlatform()
end

function WBP_SimpleTalk_Portrait:PlayExitButtonUnhoveredPerformance()
  DebugPrint("WBP_SimpleTalk_Portrait:PlayExitButtonUnhoveredPerformance")
  self:PlayExitButtonUnhoveredPerformanceByPlatform()
end

function WBP_SimpleTalk_Portrait:OnExitButtonPressed()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonPressed")
  self:PlayAnimation(self.BtnQuit_Press)
end

function WBP_SimpleTalk_Portrait:OnExitButtonReleased()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonReleased")
  self:OnExitButtonReleasedByPlatform()
end

function WBP_SimpleTalk_Portrait:OnExitButtonClickAnimFinished()
  DebugPrint("WBP_SimpleTalk_Portrait:OnExitButtonClickAnimFinished")
  self:StopAllAnimations()
  
  function self.OnOptionOutAnimationFinishedCallback()
    self:StopStoryLine()
  end
  
  self:PlayAnimation(self.Option_Out)
end

function WBP_SimpleTalk_Portrait:StopStoryLine()
  DebugPrint("WBP_SimpleTalk_Portrait:StopStoryLine")
  self.StopStoryline_Delegate:Fire()
end

function WBP_SimpleTalk_Portrait:OnImpressionItemHovered(ItemIndex)
end

function WBP_SimpleTalk_Portrait:OnImpressionItemUnhovered(ItemIndex)
end

function WBP_SimpleTalk_Portrait:OnImpressionItemClicked(Item)
  DebugPrint("WBP_SimpleTalk_Portrait:OnClickedItem", Item.State)
  self:StopAllAnimations()
  if Item.State == EImpressionButtonState.Enabled then
    self:SwitchEnableOptionClick(false)
    self:OnFocusLost_ImpressionComp()
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

function WBP_SimpleTalk_Portrait:GetCurrentImpressionItem()
  if not self.SelectImpressionItemIndex then
    return nil
  end
  if self.SelectImpressionItemIndex > self.OptionMaxNum then
    return self.Button_Area
  else
    return self.OptionComp:GetItemByIndex(self.SelectImpressionItemIndex - 1)
  end
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
  self.OptionComp:SetDefaultItem()
  self:SetExitButtonNormal()
  self:SwitchShowOptionUI(true)
  self:SetTipImageHidden(true)
  self:ChangeExitButtonVisibilityFromOptionType(self.OptionData)
  self:ChangeImgMouseVisibility(self.OptionData)
  self:OnDisplayStarted_ImpressionComp()
end

function WBP_SimpleTalk_Portrait:OnOptionInAnimationFinished()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionInAnimationFinished")
  self:SwitchEnableOptionClick(true)
  self:SwitchEnableMouseWheelEvents(true)
end

function WBP_SimpleTalk_Portrait:OnOptionOutAnimationStarted()
  DebugPrint("WBP_SimpleTalk_Portrait:OnOptionOutAnimationStarted", self.OnOptionOutAnimationFinishedCallback)
  self:SwitchEnableOptionClick(false)
  self:SwitchEnableMouseWheelEvents(false)
  self:SwitchShowOptionUI(false)
  self:OnDisplayEnded_ImpressionComp()
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

function WBP_SimpleTalk_Portrait:AdaptPlatform()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:AdaptPlatform")
end

function WBP_SimpleTalk_Portrait:OnExitButtonSelectedPlatform(bIsSelect)
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:OnExitButtonSelectedPlatform", bIsSelect)
end

function WBP_SimpleTalk_Portrait:OnExitButtonReleasedByPlatform()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:OnExitButtonReleasedByPlatform")
end

function WBP_SimpleTalk_Portrait:PlayExitButtonHoveredPerformanceByPlatform()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:PlayExitButtonHoveredPerformanceByPlatform")
end

function WBP_SimpleTalk_Portrait:PlayExitButtonUnhoveredPerformanceByPlatform()
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:PlayExitButtonUnhoveredPerformanceByPlatform")
end

function WBP_SimpleTalk_Portrait:ChangeImgMouseVisibility(OptionData)
  DebugPrint("Error: 未实现的函数WBP_SimpleTalk_Portrait:ChangeImgMouseVisibility")
end

function WBP_SimpleTalk_Portrait:Destruct()
  self:OnDestruct_ImpressionComp()
  self.OptionComp = nil
  WBP_SimpleTalk_Portrait.Super.Destruct(self)
end

AssembleComponents(WBP_SimpleTalk_Portrait)
return WBP_SimpleTalk_Portrait
