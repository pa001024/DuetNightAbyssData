require("UnLua")
require("DataMgr")
local EMCache = require("EMCache.EMCache")
local ClientEventUtils = require("BluePrints.Common.ClientEvent.ClientEventUtils")
local SpecialLoadingRule = require("Utils.LoadingUtils")
local WBP_CommonChangeSceneBg_C = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
WBP_CommonChangeSceneBg_C._components = {
  "BluePrints.UI.WidgetComponent.ChangeTextToKeyInfoComponent"
}

function WBP_CommonChangeSceneBg_C:Initialize(Initializer)
end

function WBP_CommonChangeSceneBg_C:OnShowLoading()
  self.NowLoadLevelName = nil
  self.NowLoadAssetId = nil
  self.IsRandomScene = true
  self.NowPercentNum = 0.0
  self.QueenShow = {}
  self.Index = 1
  self.CurrentIndex = 0
  self.Next = 0
  self.DynamicFunc = {}
  self.ShowTipsInterval = Const.LoadingTipsInterval
  self.WidgetLoading = nil
  self.bIsInLoading = true
  DebugPrint(WarningTag, LXYTag, "Loading界面打开....")
  UIManager():DestroyAfterLoadingMgr()
  EventManager:FireEvent(EventID.InLoading)
  if GWorld:GetAvatar() then
    EMCache:SaveUser()
  end
  EMCache:SaveCommon()
  print(_G.LogTag, "SetSyncLoaderOptimization False")
  GWorld.GameInstance:SetSyncLoaderOptimization(false)
  local SpecialQuestEvent = ClientEventUtils:GetCurrentEvent()
  if SpecialQuestEvent then
    SpecialQuestEvent:HandleInLoading()
  end
  GWorld.StoryMgr:HandleInLoading()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if PlayerCharacter then
    PlayerCharacter:SetCanInteractiveTrigger(false, "Loading")
  end
  local GameInputSubsystem = USubsystemBlueprintLibrary.GetLocalPlayerSubsystem(self, UGameInputModeSubsystem)
  if GameInputSubsystem then
    GameInputSubsystem:DisableInputMode("Talk")
  end
  local isDungeonData = true
  self.bEnableTick = true
  self:ConstructSoundFunc()
  local SojournsGameInstanceSubsystem = USubsystemBlueprintLibrary.GetGameInstanceSubsystem(self, USojournsGameInstanceSubsystem)
  self:SetIsShowNavigateGuide(false)
  if SojournsGameInstanceSubsystem and SojournsGameInstanceSubsystem:IsInInvitation() then
    self:PlayAnimation(self.In)
    self.WidgetSwitcher_Root:SetActiveWidgetIndex(1)
    local Widget = UIManager(self):_CreateWidgetNew("InvitationLoading")
    self.InvitationRoot:ClearChildren()
    local Slot = self.InvitationRoot:AddChildToOverlay(Widget)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    Widget:PlayAnimation(Widget.In)
    local PartyNpcData = SojournsGameInstanceSubsystem.PartyNPCData
    assert(PartyNpcData, "PartyNpcData is nil")
    local BattleCharData = DataMgr.BattleChar[PartyNpcData.CharId]
    assert(BattleCharData, "BattleCharData is nil" .. PartyNpcData.CharId)
    Widget.Text_CharacterName:SetText(GText(BattleCharData.CharName))
    Widget.WorldText_Name:SetText(EnText(BattleCharData.CharName))
    local IconDynaMaterial = Widget.Icon_Avatar:GetDynamicMaterial()
    IconDynaMaterial:SetTextureParameterValue("Mask", LoadObject(PartyNpcData.AvatarIconPath))
    local PartyTopicData = SojournsGameInstanceSubsystem.PartyTopicData
    assert(PartyTopicData, "PartyTopicData is nil")
    Widget.Text_TopicName:SetText(GText(PartyTopicData.PartyTopicName))
  else
    self.WidgetSwitcher_Root:SetActiveWidgetIndex(0)
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      self.Text_Uid:SetText(string.format("UID:%s", tostring(Avatar.Uid)))
    end
    self:SetRandomTips()
    self:UpdateShowUI()
    self:PlayAnimation(self.In)
    self:PlayAnimation(self.Loop, 0, 0)
    local DungeonData = DataMgr.Dungeon[WorldTravelSubsystem():GetCurrentSceneId()]
    local LoginPage = UIManager(self):GetUIObj("LoginMainPage")
    if LoginPage then
      self.IsFromLoginPage = true
      self.Panel_Bg:SetContent(UIManager(self):CreateWidget(Const.LoadingBgBluePrint))
    elseif not DungeonData then
      isDungeonData = false
    elseif DungeonData.DungeonUIBG then
      self.Panel_Bg:SetContent(UIManager(self):CreateWidget(DungeonData.DungeonUIBG))
    end
    if self.Panel_Bg:GetContent() and self.Panel_Bg:GetContent().In_Loading then
      self.Panel_Bg:GetContent():PlayAnimation(self.Panel_Bg:GetContent().In_Loading)
    end
    self.Text_BottomTips:SetText(GText("UI_Loading_Testing"))
  end
  if not isDungeonData then
    self.WidgetSwitcher_Root:SetActiveWidgetIndex(1)
    local LoadingData, SpecialLoadingBp = SpecialLoadingRule:GetLoadingBpPath(true)
    if SpecialLoadingBp then
      self.WidgetLoading = UIManager(self):CreateWidget(SpecialLoadingBp)
      if self.WidgetLoading.InitLoadingData then
        self.WidgetLoading:InitLoadingData(LoadingData, self)
      end
    else
      self.WidgetLoading = UIManager(self):_CreateWidgetNew("ComLoadingXiaoBai")
    end
    local Widget = self.WidgetLoading
    self.InvitationRoot:ClearChildren()
    local Slot = self.InvitationRoot:AddChildToOverlay(Widget)
    Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
    self:UpdateShowUI()
  end
  local GameInputSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputSubsystem) then
    local Params = FGameInputModeParams()
    Params.bShowMouseCursor = false
    Params.MouseLockMode = EMouseLockMode.DoNotLock
    GameInputSubsystem:EnableInputMode("CommonChangeScene", EGameInputMode.UI, Params)
  end
  self:SetMouseCursorVisable(false)
  self.bShowThisFrame = true
end

function WBP_CommonChangeSceneBg_C:Construct()
  self.Overridden.Construct(self)
  UIManager(self):GetGameInputModeSubsystem().OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  self.Button_461.OnClicked:Add(self, self.SetRandomTips)
  self:SetFocus()
  self:UpdateUIStyleInPlatform(UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad)
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.CurrentInputDevice = {"GamepadKey"}
  else
    self.CurrentInputDevice = {
      "KeyboardKey",
      "MouseButton"
    }
  end
end

function WBP_CommonChangeSceneBg_C:ConstructSoundFunc()
  AudioManager(self):PlayUISound(self, "event:/ui/common/loading_common", "Loading", nil)
  AudioManager(self):PausePlayBGMCauseIsLoadingOrBlackScreen()
  AudioManager(self):AddAuANotifyForbidTag("LoadingUI")
end

function WBP_CommonChangeSceneBg_C:Destruct()
  DebugPrint(WarningTag, LXYTag, "Loading界面应该销毁了")
  self.Overridden.Destruct(self)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem and GameInputModeSubsystem.OnInputMethodChanged then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self:DestructSoundFunc()
end

local EMCache = require("EMCache.EMCache")

function WBP_CommonChangeSceneBg_C:DestructSoundFunc()
  AudioManager(self):SetEventSoundParam(self, "Loading", {ToEnd = 1})
  AudioManager(self):ResumePlayBGMCauseIsLoadingOrBlackScreen()
  AudioManager(self):RemoveAuANotifyForbidTag("LoadingUI")
end

function WBP_CommonChangeSceneBg_C:Tick(MyGeometry, InDeltaTime)
  if not self.bEnableTick then
    return
  end
  self.Overridden.Tick(self, MyGeometry, InDeltaTime)
  self.bShowThisFrame = false
  local PlayerController = UGameplayStatics.GetPlayerController(self, 0)
  if PlayerController and not self.bReset then
    self.bReset = true
  end
  if not PlayerController then
    self.bReset = false
  end
  self.ShowTipsInterval = self.ShowTipsInterval - InDeltaTime
  if self.ShowTipsInterval <= 0 then
    self:SetRandomTips()
    if self.WidgetLoading and self.WidgetLoading.SetRandomTips then
      self.WidgetLoading:SetRandomTips()
    end
  end
  if self.NowPercentNum >= 100 then
    self.NowPercentNum = 100
    self:UpdateShowUI()
    self:Close()
    return
  end
  if math.abs(self.NowPercentNum - self.Next) < 0.1 or self.NowPercentNum >= self.Next then
    local NextNum = self:RemoveQueen()
    if NextNum > 0 then
      self.Next = NextNum
    end
  end
  if self.NowPercentNum <= self.Next then
    self.NowPercentNum = math.min(self.NowPercentNum + InDeltaTime * 100, self.Next)
  end
  self:UpdateShowUI()
end

function WBP_CommonChangeSceneBg_C:UpdateShowUI()
  self.ProgressBar:SetPercent(self.NowPercentNum / 100)
  if self.NowPercentNum >= 100 then
    self.NowPercentNum = 100
  end
  self.Progress_Text_Bar:SetText(string.format("%.0f", self.NowPercentNum))
  if self.WidgetLoading then
    if self.WidgetLoading.UpdateProgressBar then
      self.WidgetLoading:UpdateProgressBar(self.NowPercentNum)
    else
      self.WidgetLoading.ProgressBar:SetPercent(self.NowPercentNum / 100)
      self.WidgetLoading.Text_Progress:SetText(string.format("%.0f", self.NowPercentNum))
      self.WidgetLoading.Text_Progress_Back:SetText(string.format("%.0f", self.NowPercentNum))
    end
  end
end

function WBP_CommonChangeSceneBg_C:AddQuene(Progress)
  table.insert(self.QueenShow, Progress)
  DebugPrint("SL_LoadingDBG", "AddQuene: +", Progress, "  QueueLen =", #self.QueenShow)
  if Progress >= 100 then
    DebugPrint(WarningTag, LXYTag, "Loading进度应该结束了才对")
  end
end

function WBP_CommonChangeSceneBg_C:RemoveQueen()
  local NextNum = 0
  if not self.QueenShow[self.Index] then
    return 0
  end
  NextNum = self.QueenShow[self.Index]
  self.CurrentIndex = self.Index
  self.Index = self.Index + 1
  if self.WidgetLoading then
    DebugPrint("SL_LoadingDBG", "RemoveQueen: pop=", NextNum, " NewIndex=", self.Index, "UIName = ", self.WidgetLoading:GetName())
  end
  return NextNum
end

function WBP_CommonChangeSceneBg_C:AddDynamic(FuncName)
  if type(FuncName) == "function" then
    table.insert(self.DynamicFunc, FuncName)
  end
end

function WBP_CommonChangeSceneBg_C:ExeDyanmicFunc()
  for _, func in ipairs(self.DynamicFunc) do
    func()
  end
  self:ClearDynamicFunc()
end

function WBP_CommonChangeSceneBg_C:ClearDynamicFunc()
  self.DynamicFunc = {}
end

function WBP_CommonChangeSceneBg_C:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  return UE4.UWidgetBlueprintLibrary.Handled()
end

function WBP_CommonChangeSceneBg_C:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if not self.Com_KeyTitle then
    return
  end
  if IsUseKeyAndMouse then
    self.Com_KeyTitle:SetVisibility(ESlateVisibility.Collapsed)
    self.CurrentInputDevice = {
      "KeyboardKey",
      "MouseButton"
    }
  else
    self.CurrentInputDevice = {"GamepadKey"}
    self.Com_KeyTitle:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Com_KeyTitle:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      bLongPress = false,
      Desc = GText("UI_CTL_Loading_Next")
    })
  end
end

function WBP_CommonChangeSceneBg_C:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  self:SetRandomTips()
end

function WBP_CommonChangeSceneBg_C:GetSceneLoadProgress()
  if self.IsRandomScene then
    if self.NowPercentNum >= 100.0 then
      self:Close()
    end
  elseif self.NowLoadLevelName ~= nil and nil ~= self.NowLoadAssetId then
    self.NowPercentNum = UE4.UResourceLibrary.GetLoadProgress(self, self.NowLoadLevelName, self.NowLoadAssetId)
  end
  return self.NowPercentNum / 100.0
end

function WBP_CommonChangeSceneBg_C:SetRandomTips()
  self.ShowTipsInterval = Const.LoadingTipsInterval
  local RandomTips = self:GetRandomLoadingTips()
  self.Text_Title:SetText(RandomTips.Title)
  local Messages = self:GetFinalContentText(RandomTips.Message, self.CurrentInputDevice)
  self.Text_Message:SetText(Messages)
end

function WBP_CommonChangeSceneBg_C:SetCommonKey(CommonKeyUI, KeyInfo)
  local ActionName = string.sub(KeyInfo, 2, -2)
  local Key, KeyType = self:GetKeyName(ActionName)
  if "ControlAngle" == ActionName then
    CommonKeyUI:SetImgByFullPath("Texture2D'/Game/UI/UI_PNG/Common/Key/Icon_Mouse_Button.Icon_Mouse_Button'")
    return
  end
  if "ControlMove" == ActionName then
    CommonKeyUI:SetTextInfo("WASD")
    return
  end
  if "KeyboardKey" == KeyType then
    CommonKeyUI:SetTextInfo(Key)
  elseif "MouseButton" == KeyType or "GamepadKey" == KeyType then
    CommonKeyUI:SetImgInfo(Key)
  end
end

function WBP_CommonChangeSceneBg_C:GetRandomLoadingTips()
  if not self.TipsPoolByPlatform then
    self.TipsPoolByPlatform = {
      PC = {},
      Mobile = {},
      Gamepad = {}
    }
    local TipsTable = DataMgr.Message
    for _, v in pairs(TipsTable) do
      if v.MessageType == "LoadingText" then
        if v.MessageContentPC then
          table.insert(self.TipsPoolByPlatform.PC, {
            Title = GText(v.MessageTitlePC or ""),
            Message = GText(v.MessageContentPC)
          })
        end
        if v.MessageContentPhone then
          table.insert(self.TipsPoolByPlatform.Mobile, {
            Title = GText(v.MessageTitlePC or ""),
            Message = GText(v.MessageContentPhone)
          })
        end
        local gamepadMsg = v.MessageContentGamePad or v.MessageContentPC
        if gamepadMsg then
          table.insert(self.TipsPoolByPlatform.Gamepad, {
            Title = GText(v.MessageTitlePC or ""),
            Message = GText(gamepadMsg)
          })
        end
      end
    end
  end
  local TipsList
  if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
    TipsList = self.TipsPoolByPlatform.Gamepad
  elseif "PC" == CommonUtils.GetDeviceTypeByPlatformName(self) then
    TipsList = self.TipsPoolByPlatform.PC
  elseif "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self) then
    TipsList = self.TipsPoolByPlatform.Mobile
  end
  if not TipsList or 0 == #TipsList then
    return {Title = "", Message = ""}
  end
  local RandomIndex = math.random(1, #TipsList)
  return TipsList[RandomIndex]
end

function WBP_CommonChangeSceneBg_C:RealCloseLoading()
  local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  EventManager:FireEvent(EventID.CloseLoading, PlayerCharacter and PlayerCharacter.Eid)
  self.bIsInLoading = nil
  if self.WidgetLoading then
    self.bEnableTick = false
    DebugPrint("SL_LoadingDBG 关闭当前Loading  UIName :", self.WidgetLoading:GetName())
    if self.WidgetLoading.Out then
      self.WidgetLoading:UnbindAllFromAnimationFinished(self.WidgetLoading.Out)
      self.WidgetLoading:BindToAnimationFinished(self.WidgetLoading.Out, {
        self,
        self.OnOutAnimationFinished
      })
      self.WidgetLoading:PlayAnimation(self.WidgetLoading.Out)
    else
      self:OnOutAnimationFinished()
    end
  elseif not self.bShowThisFrame then
    GWorld.GameInstance:CloseLoadingUI()
    UIManager(self):LaunchAfterLoadingMgr()
  end
  self:SetMouseCursorVisable(true)
end

function WBP_CommonChangeSceneBg_C:Close()
  self:ExeDyanmicFunc()
  self:RealCloseLoading()
end

function WBP_CommonChangeSceneBg_C:OnLevelRemovedFromWorld_Lua()
  self.bReset = false
end

function WBP_CommonChangeSceneBg_C:OnOutAnimationFinished()
  if not self.WidgetLoading then
    return
  end
  if not self.bShowThisFrame then
    DebugPrint("SL_LoadingDBG OnOutAnimationFinished 销毁当前Loading  UIName :", self.WidgetLoading:GetName())
    GWorld.GameInstance:CloseLoadingUI()
    UIManager(self):LaunchAfterLoadingMgr()
  end
end

AssembleComponents(WBP_CommonChangeSceneBg_C)
return WBP_CommonChangeSceneBg_C
