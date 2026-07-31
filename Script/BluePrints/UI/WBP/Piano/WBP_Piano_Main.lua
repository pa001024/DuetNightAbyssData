require("UnLua")
require("DataMgr")
local EMCache = require("EMCache.EMCache")
local PianoSceneUtils = require("BluePrints.UI.WBP.Piano.PianoSceneUtils")
local UIUtils = require("Utils.UIUtils")
local WBP_Piano_Main = Class("BluePrints.UI.BP_UIState_C")
local PIANO_DEFAULT_SCENE_BG = "/Game/UI/UI_PC/LevelSelect/LevelSelect_Bg/LevelSelect_Bg_Piano.LevelSelect_Bg_Piano"
local PIANO_HOME_SCENE_BG = PIANO_DEFAULT_SCENE_BG
local PIANO_DUNGEON_MUSIC_NAME_KEY = "UI_ChangeBGM_Dungeon_Name"
local PIANO_DUNGEON_MUSIC_DES_KEY = "UI_ChangeBGM_Dungeon_Des"
local PIANO_BGM_MUTE_EVENT = "event:/bgm/mute"
local PIANO_TAB_BACK_WIDGET_PATH = "/Game/UI/WBP/Common/Tab/Mobile/WBP_Com_TabBack_M.WBP_Com_TabBack_M"

function WBP_Piano_Main:OnLoaded(...)
  WBP_Piano_Main.Super.OnLoaded(self, ...)
  self:PlayAnimation(self.In)
  self.isPC = CommonUtils.GetDeviceTypeByPlatformName() == "PC"
  self.InputDevice = UIUtils.UtilsGetCurrentInputType()
  self.IsClosing = false
  self.BtnMusicCanClick = false
  self:AddDispatcher(EventID.ChangeMusicItemNewState, self, self.OnMusicItemNewStateChange)
  self:OnLoaded_InitParam()
  self:OnLoaded_ParseOpenContext(...)
  self:OnLoaded_GetData()
  self:OnLoaded_InitUI()
  self:BindInputMethodChangedDelegate()
  self.List_Album:SetNavigationRuleCustom(UE4.EUINavigation.Right, {
    self,
    self.List_Album_NavRight
  })
  self.List_Music:SetNavigationRuleCustom(UE4.EUINavigation.Left, {
    self,
    self.List_Music_NavLeft
  })
  AudioManager(self):PlayUISound(self, "event:/ui/common/music_savor_open", "PianoSystemOpen", nil)
  self.Book = UE4.UGameplayStatics.GetActorOfClass(self, LoadClass("/Game/AssetDesign/Level/Prop/BP_PianoTab.BP_PianoTab"))
  self.IsFirstOpen = true
  self:AddTimer(0.05, function()
    self.List_Album:ScrollIndexIntoView(self.Init_Select_ItemIndex)
    self.List_Music:ScrollIndexIntoView(self.Init_Select_MusicIndex)
    if self.InputDevice == ECommonInputType.Gamepad then
      self:HandleGamepadRefocus()
    end
  end)
end

function WBP_Piano_Main:Close()
  self.IsClosing = true
  if self.PendingSelectMusicTimer then
    self:RemoveTimer(self.PendingSelectMusicTimer)
    self.PendingSelectMusicTimer = nil
  end
  self:CloseSwitchScenePanel()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GWorld.GameInstance, 0)
  local Player = PlayerController:GetMyPawn()
  local Eid = Player.MechanismEid
  local Mechanism = Battle(self):GetEntity(Eid)
  if Mechanism then
    Mechanism:EndInteractive(Player, true)
  end
  AudioManager(self):PlayCustomBGM(DataMgr.Music[self.CurrentHomeBaseBGM].Event)
  AudioManager(self):StopPianoSystemBGM()
  self:PlayAnimation(self.Out)
  AudioManager(self):SetEventSoundParam(self, "PianoSystemOpen", {ToEnd = 1})
  WBP_Piano_Main.Super.Close(self)
end

function WBP_Piano_Main:SaveCacheData()
  local ReadMusicItemIds = EMCache:Get("PianoSystem_ReadMusicIds", true) or {}
  for NeedStoreMusicId, _ in pairs(self.ReadMusicItems) do
    ReadMusicItemIds[NeedStoreMusicId] = 1
  end
  EMCache:Set("PianoSystem_ReadMusicIds", ReadMusicItemIds, true)
  self:SavePianoSceneCache()
end

function WBP_Piano_Main:GetDungeonBgmEnabledForChapter(ChapterId)
  return PianoSceneUtils.IsDungeonBgmEnabledForChapter(ChapterId, self.DungeonBgmDisabledByChapter)
end

function WBP_Piano_Main:SetDungeonBgmEnabledForChapter(ChapterId, bEnabled)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return
  end
  if bEnabled then
    self.DungeonBgmDisabledByChapter[ChapterId] = nil
    self.DungeonBgmDisabledByChapter[tostring(ChapterId)] = nil
  else
    self.DungeonBgmDisabledByChapter[ChapterId] = true
  end
end

function WBP_Piano_Main:LoadPianoSceneCache()
  self.DungeonBgmDisabledByChapter = PianoSceneUtils.LoadDungeonBgmDisabledChapters()
  self.ChapterCustomBGM = PianoSceneUtils.LoadChapterCustomBGM()
end

function WBP_Piano_Main:SavePianoSceneCache()
  PianoSceneUtils.SaveDungeonBgmDisabledChapters(self.DungeonBgmDisabledByChapter)
  PianoSceneUtils.SaveChapterCustomBGM(self.ChapterCustomBGM)
end

function WBP_Piano_Main:InitCurrentSceneFromOpenContext()
  if self.bHomeInteractOpen or self.bShowHomeSceneBg then
    self.CurrentScene = nil
    self.DungeonBgmEnabled = true
    return
  end
  local ChapterId = PianoSceneUtils.NormalizeChapterId(self:GetPianoOpenContextSceneId())
  self.CurrentScene = ChapterId
  self.DungeonBgmEnabled = nil == ChapterId or self:GetDungeonBgmEnabledForChapter(ChapterId)
end

function WBP_Piano_Main:ShouldAllowDungeonBgmPlayback()
  if not self:IsDungeonSceneMode() then
    return true
  end
  return self.DungeonBgmEnabled ~= false
end

function WBP_Piano_Main:PlayCurrentMusicSelection(bSyncItemUI)
  local bAllowPreviewAudio = self:ShouldAllowDungeonBgmPlayback()
  if self.Cur_PlayDungeonBgmEvent then
    if bAllowPreviewAudio then
      AudioManager(self):PlayPianoSystemBGM(self.Cur_PlayDungeonBgmEvent)
    else
      AudioManager(self):PlayPianoSystemBGM(PIANO_BGM_MUTE_EVENT)
    end
  elseif self.Cur_PlayMusicId and DataMgr.Music[self.Cur_PlayMusicId] then
    if bAllowPreviewAudio then
      AudioManager(self):PlayPianoSystemBGM(DataMgr.Music[self.Cur_PlayMusicId].Event)
    else
      AudioManager(self):PlayPianoSystemBGM(PIANO_BGM_MUTE_EVENT)
    end
  elseif not bAllowPreviewAudio and self:IsDungeonSceneMode() then
    AudioManager(self):PlayPianoSystemBGM(PIANO_BGM_MUTE_EVENT)
  end
  if not bSyncItemUI then
    return
  end
  if self.Cur_PlayDungeonBgmEvent then
    EventManager:FireEvent(EventID.ChangePlayedMusicItem, self.Cur_PlayDungeonBgmEvent)
  elseif self.Cur_PlayMusicId then
    EventManager:FireEvent(EventID.ChangePlayedMusicItem, self.Cur_PlayMusicId)
  end
end

function WBP_Piano_Main:ApplyDungeonBgmPlaybackState()
  self:PlayCurrentMusicSelection(true)
end

function WBP_Piano_Main:SyncPlayStateForCurrentScene()
  if self:IsDungeonSceneMode() then
    local CustomMusicId = PianoSceneUtils.GetChapterCustomMusicId(self.CurrentScene, self.ChapterCustomBGM)
    if CustomMusicId and CustomMusicId > 0 then
      self.Cur_PlayDungeonBgmEvent = nil
      self.Cur_PlayMusicId = CustomMusicId
      self.Cur_SelectMusicId = CustomMusicId
    else
      self.Cur_PlayDungeonBgmEvent = self:GetChapterDungeonBgmEvent(self.CurrentScene)
      self.Cur_PlayMusicId = nil
      self.Cur_SelectMusicId = 0
    end
  else
    self.Cur_PlayDungeonBgmEvent = nil
    self.Cur_PlayMusicId = self.CurrentHomeBaseBGM
    self.Cur_SelectMusicId = self.CurrentHomeBaseBGM
  end
  self:ApplyDungeonBgmPlaybackState()
end

function WBP_Piano_Main:Destruct()
  self:SaveCacheData()
  self.UnLockMusicScores = nil
  self.UnLockMusicScoreToItems = nil
  self.UnLockMusicScoreToItems_Sort = nil
  self.AllMusicScoreToMusic = nil
  self.CurrentDungeonBgmEvent = nil
  self.Cur_PlayDungeonBgmEvent = nil
  self.UnreadMusicItems = nil
  self.ReadMusicItems = nil
  self.MusicScoreUnreadNum = nil
  self.CurrentSelectMusicScore = nil
  self.List_Album:ClearListItems()
  self.List_Music:ClearListItems()
  self.Btn_Music.OnClicked:Remove(self, self.OnBtnClicked)
  self.Btn_SwitchScene.Button_Area.OnClicked:Remove(self, self.OnBtnSwitchSceneClicked)
  self:UnbindChangeMusicBtns()
  self:UnBindInputMethodChangedDelegate()
  self:ListMusicUnBindSelectChangeDelegate()
  WBP_Piano_Main.Super.Destruct(self)
end

function WBP_Piano_Main:OnEndClose()
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:RemovePlayInOutSystems("PianoSystem")
  end
  UIUtils.PlayBattleMainInAnim()
end

function WBP_Piano_Main:OnLoaded_InitParam()
  self.UnLockMusicScores = {}
  self.UnLockMusicScoreToItems = {}
  self.UnLockMusicScoreToItems_Sort = {}
  self.AllMusicScoreToMusic = {}
  self.CurrentHomeBaseBGM = 0
  self.Cur_SelectMusicId = nil
  self.Cur_PlayMusicId = nil
  self.Init_Select_ItemIndex = nil
  self.Init_Select_MusicIndex = nil
  self.Cur_ListSelectIndex = nil
  self.Cur_ListHoverIndex = nil
  self.Cur_AlbumHoverIndex = nil
  self.GamepadFocusArea = "Album"
  self.PendingMusicListIndex = nil
  self.PendingDefaultSelectIndex = nil
  self.UnreadMusicItems = {}
  self.ReadMusicItems = {}
  self.MusicScoreUnreadNum = {}
  self.CurrentSelectMusicScore = nil
  self.IsShowingLockText = nil
  self.BtnMusic_IsSet = nil
  self.TextShowNeedForceUpdate = false
  self.CurrentScene = nil
  self.DungeonBgmEnabled = true
  self.DungeonBgmDisabledByChapter = {}
  self.ChapterCustomBGM = {}
  self.CurrentSceneBgPath = nil
  self.CurrentSceneBgWidget = nil
  self.DisplayedScene = nil
  self.bHomeInteractOpen = false
  self.bShowHomeSceneBg = false
  self.CurrentDungeonBgmEvent = nil
  self.Cur_PlayDungeonBgmEvent = nil
end

function WBP_Piano_Main:OnLoaded_ParseOpenContext(...)
  local OpenArg = select(1, ...)
  if type(OpenArg) ~= "table" then
    return
  end
  if OpenArg.bHomeInteractOpen then
    self.bHomeInteractOpen = true
  end
  if OpenArg.bShowHomeSceneBg then
    self.bShowHomeSceneBg = true
  end
end

function WBP_Piano_Main:OnLoaded_GetData()
  self:GetMusicScoreToMusicDatas()
  self:GetAvatarUnLockMusic()
  self:LoadPianoSceneCache()
  self:InitCurrentSceneFromOpenContext()
end

function WBP_Piano_Main:OnLoaded_InitUI()
  self:InitAlbumListDisplay()
  self:InitOtherWidget()
  self:RefreshSceneDisplay()
  if self:IsDungeonSceneMode() then
    self:SyncPlayStateForCurrentScene()
  end
  self:SelectAlbumForCurrentScene()
end

function WBP_Piano_Main:InitAlbumListDisplay()
  if self.List_Item then
    self.List_Item:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.List_Item:ClearListItems()
  end
  if self.List_Album then
    self.List_Album:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function WBP_Piano_Main:GetMusicScoreToMusicDatas()
  for MusicId, MusicInfo in pairs(DataMgr.Music) do
    if not self.AllMusicScoreToMusic[MusicInfo.MusicScoreId] then
      self.AllMusicScoreToMusic[MusicInfo.MusicScoreId] = {}
    end
    table.insert(self.AllMusicScoreToMusic[MusicInfo.MusicScoreId], MusicId)
  end
  for _, MusicIds in pairs(self.AllMusicScoreToMusic) do
    table.sort(MusicIds, function(a, b)
      return a < b
    end)
  end
end

function WBP_Piano_Main:GetHomeBaseMusicInfo()
  return DataMgr.Music[self.CurrentHomeBaseBGM]
end

function WBP_Piano_Main:IsDungeonMusicScore(MusicScoreId)
  local ScoreInfo = DataMgr.MusicScore[MusicScoreId]
  return nil ~= ScoreInfo and ScoreInfo.IsDungeon == true
end

function WBP_Piano_Main:GetDungeonMusicScoreId()
  local FirstId
  for MusicScoreId, ScoreInfo in pairs(DataMgr.MusicScore or {}) do
    if ScoreInfo and ScoreInfo.IsDungeon == true and (nil == FirstId or MusicScoreId < FirstId) then
      FirstId = MusicScoreId
    end
  end
  return FirstId
end

function WBP_Piano_Main:ShouldShowMusicScoreInList(MusicScoreId)
  if not self:IsDungeonMusicScore(MusicScoreId) then
    return true
  end
  return self:IsDungeonSceneMode() and MusicScoreId == self:GetDungeonMusicScoreId()
end

function WBP_Piano_Main:GetDungeonBgmEventForMusicItem(Item)
  if Item and Item.DungeonBgmEvent ~= nil then
    return Item.DungeonBgmEvent
  end
  return self.CurrentDungeonBgmEvent
end

function WBP_Piano_Main:IsDungeonDynamicMusicItem(Item)
  if not Item then
    return false
  end
  if Item.bIsDungeonDynamicTrack == true then
    return true
  end
  return 0 == Item.MusicId and self:GetDungeonBgmEventForMusicItem(Item) ~= nil
end

function WBP_Piano_Main:IsSameDungeonBgmEvent(EventA, EventB)
  if nil == EventA or nil == EventB then
    return false
  end
  return tostring(EventA) == tostring(EventB)
end

function WBP_Piano_Main:IsMusicListItemCurrentlyPlaying(Item)
  if not Item or Item.bIsLocked then
    return false
  end
  if self:IsDungeonDynamicMusicItem(Item) then
    if not self.Cur_PlayDungeonBgmEvent then
      return false
    end
    return self:IsSameDungeonBgmEvent(self:GetDungeonBgmEventForMusicItem(Item), self.Cur_PlayDungeonBgmEvent)
  end
  return Item.MusicId ~= nil and Item.MusicId == self.Cur_PlayMusicId
end

function WBP_Piano_Main:GetChapterDungeonBgmEvent(ChapterId)
  local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[ChapterId]
  local DungeonId = ChapterCfg and ChapterCfg.DungeonList and ChapterCfg.DungeonList[1]
  local DungeonCfg = DungeonId and DataMgr.Dungeon[DungeonId]
  return DungeonCfg and DungeonCfg.DungeonBGM
end

function WBP_Piano_Main:GetAvatarUnLockMusic()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    self:Close()
    return
  end
  self.CurrentHomeBaseBGM = Avatar.HomeBaseBGM
  self.Cur_SelectMusicId = self.CurrentHomeBaseBGM
  self.Cur_PlayMusicId = self.CurrentHomeBaseBGM
  local ReadMusicItemIds = EMCache:Get("PianoSystem_ReadMusicIds", true)
  local UnLockMusicScoreId
  local MarkUnLockMusicScore = {}
  for UnLockMusicId, _ in pairs(Avatar.BGMs) do
    UnLockMusicScoreId = DataMgr.Music[UnLockMusicId].MusicScoreId
    if not MarkUnLockMusicScore[UnLockMusicScoreId] then
      MarkUnLockMusicScore[UnLockMusicScoreId] = 1
      table.insert(self.UnLockMusicScores, UnLockMusicScoreId)
      self.UnLockMusicScoreToItems[UnLockMusicScoreId] = {}
      self.UnLockMusicScoreToItems_Sort[UnLockMusicScoreId] = {}
      self.MusicScoreUnreadNum[UnLockMusicScoreId] = 0
    end
    self.UnLockMusicScoreToItems[UnLockMusicScoreId][UnLockMusicId] = 1
    table.insert(self.UnLockMusicScoreToItems_Sort[UnLockMusicScoreId], UnLockMusicId)
    if not ReadMusicItemIds or not ReadMusicItemIds[UnLockMusicId] then
      self.UnreadMusicItems[UnLockMusicId] = 1
      self.MusicScoreUnreadNum[UnLockMusicScoreId] = self.MusicScoreUnreadNum[UnLockMusicScoreId] + 1
    end
  end
  table.sort(self.UnLockMusicScores, function(a, b)
    return a < b
  end)
  for _, MusicIds in pairs(self.UnLockMusicScoreToItems_Sort) do
    table.sort(MusicIds, function(a, b)
      return a < b
    end)
  end
end

function WBP_Piano_Main:GetPianoSceneConfig(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    return {BgWidgetPath = PIANO_HOME_SCENE_BG}
  end
  ChapterId = PianoSceneUtils.ResolvePianoSceneDisplayChapterId(ChapterId)
  local ChapterCfg = DataMgr.SelectDungeon and DataMgr.SelectDungeon[ChapterId]
  local BgWidgetPath = PIANO_DEFAULT_SCENE_BG
  if ChapterCfg and ChapterCfg.DungeonList and ChapterCfg.DungeonList[1] then
    local DungeonCfg = DataMgr.Dungeon[ChapterCfg.DungeonList[1]]
    if DungeonCfg and DungeonCfg.DungeonUIBG then
      BgWidgetPath = DungeonCfg.DungeonUIBG
    end
  end
  return {BgWidgetPath = BgWidgetPath}
end

function WBP_Piano_Main:RefreshDungeonSceneMusicData(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not ChapterId then
    self.CurrentDungeonBgmEvent = nil
    return
  end
  self.CurrentDungeonBgmEvent = self:GetChapterDungeonBgmEvent(ChapterId)
  if not self.CurrentDungeonBgmEvent then
    Utils.ScreenPrint(string.format("Piano: ChapterId=%s 无 DungeonBGM 配置", tostring(ChapterId)))
  end
end

function WBP_Piano_Main:IsDungeonSceneMode()
  return PianoSceneUtils.NormalizeChapterId(self.CurrentScene) ~= nil
end

function WBP_Piano_Main:ShouldShowSceneBackground()
  return self:ShouldShowSceneBackgroundForChapter(self.CurrentScene)
end

function WBP_Piano_Main:ShouldShowSceneBackgroundForChapter(ChapterId)
  if PianoSceneUtils.NormalizeChapterId(ChapterId) ~= nil then
    return true
  end
  return self.bShowHomeSceneBg == true
end

function WBP_Piano_Main:OnPianoSceneChanged(ChapterId)
  ChapterId = PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(ChapterId)
  local OldChapterId = PianoSceneUtils.NormalizeChapterId(self.CurrentScene)
  if nil ~= OldChapterId then
    self:SetDungeonBgmEnabledForChapter(OldChapterId, self.DungeonBgmEnabled)
  end
  self.CurrentScene = ChapterId
  if nil == ChapterId then
    self.bShowHomeSceneBg = true
    self.DungeonBgmEnabled = true
  else
    self.DungeonBgmEnabled = self:GetDungeonBgmEnabledForChapter(ChapterId)
  end
  self:RefreshSceneDataDisplay()
  self:PlaySceneSwitchTransition()
  self:SyncPlayStateForCurrentScene()
  self.BtnMusic_IsSet = nil
  self.TextShowNeedForceUpdate = true
  self:SelectAlbumForCurrentScene()
  self:RefreshDescribeForCurrentPlayState()
  self.TextShowNeedForceUpdate = false
  self:RefreshHomeMusicBtnVisibility()
  self:RefreshBGMSwitchVisibility()
  self:SavePianoSceneCache()
end

function WBP_Piano_Main:RefreshSceneDisplay()
  self:RefreshSceneDataDisplay()
  self:RefreshSceneVisualInfo(self.CurrentScene, true)
  self:RefreshBGMSwitchVisibility()
end

function WBP_Piano_Main:RefreshSceneDataDisplay()
  self:RefreshDungeonSceneMusicData(self.CurrentScene)
  self:RebuildListItem()
  self:RefreshHomeMusicBtnVisibility()
end

function WBP_Piano_Main:GetSwitchSceneAnim()
  return self.Swtich_Sence or self.Switch_Scene
end

function WBP_Piano_Main:PlaySceneSwitchTransition()
  local SwitchSceneAnim = self:GetSwitchSceneAnim()
  if SwitchSceneAnim then
    if self:IsAnimationPlaying(SwitchSceneAnim) then
      self:StopAnimation(SwitchSceneAnim)
    end
    self:PlayAnimation(SwitchSceneAnim)
    return
  end
  self:RefreshSceneVisualInfo(self.CurrentScene, false)
end

function WBP_Piano_Main:Change_Info()
  self:RefreshSceneVisualInfo(self.CurrentScene, false)
end

function WBP_Piano_Main:RefreshSceneVisualInfo(ChapterId, bPlayBgInAnim)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  self.DisplayedScene = ChapterId
  self:RefreshSceneBackground(ChapterId, bPlayBgInAnim)
  self:RefreshSceneInfoText(ChapterId)
end

function WBP_Piano_Main:SelectAlbumForCurrentScene()
  local TargetMusicScoreId
  if self:IsDungeonSceneMode() then
    TargetMusicScoreId = self:GetDungeonMusicScoreId()
    if not TargetMusicScoreId then
      Utils.ScreenPrint("Piano: MusicScore 中未配置 IsDungeon 副本乐谱")
      return
    end
  else
    local MusicInfo = self:GetHomeBaseMusicInfo()
    TargetMusicScoreId = MusicInfo and MusicInfo.MusicScoreId
    if not TargetMusicScoreId then
      return
    end
  end
  if not self:SelectAlbumByMusicScoreId(TargetMusicScoreId) and not self:IsDungeonSceneMode() and self.Init_Select_ItemIndex ~= nil then
    self:OnSelectMusicScoreChanged(self.Init_Select_ItemIndex)
  end
end

function WBP_Piano_Main:SelectAlbumByMusicScoreId(MusicScoreId)
  local ItemCount = self.List_Album:GetNumItems()
  for i = 0, ItemCount - 1 do
    local SelectItem = self.List_Album:GetItemAt(i)
    if SelectItem and SelectItem.MusicScoreId == MusicScoreId then
      self:OnSelectMusicScoreChanged(i)
      return true
    end
  end
  return false
end

function WBP_Piano_Main:RefreshSceneBackground(ChapterId, bPlayBgInAnim)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if not self.Panel_Scene then
    return
  end
  if not self:ShouldShowSceneBackgroundForChapter(ChapterId) then
    self.Panel_Scene:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.CurrentSceneBgPath = nil
    self.CurrentSceneBgWidget = nil
    return
  end
  local SceneConfig = self:GetPianoSceneConfig(ChapterId)
  local BgWidgetPath = SceneConfig and SceneConfig.BgWidgetPath
  if not BgWidgetPath then
    self.Panel_Scene:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.CurrentSceneBgPath = nil
    self.CurrentSceneBgWidget = nil
    return
  end
  self.Panel_Scene:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.CurrentSceneBgPath ~= BgWidgetPath then
    self.CurrentSceneBgPath = BgWidgetPath
    local BgWidget = UIManager(self):CreateWidget(BgWidgetPath)
    if not BgWidget then
      return
    end
    self.CurrentSceneBgWidget = BgWidget
    if self.Panel_Scene.SetContent then
      self.Panel_Scene:SetContent(BgWidget)
    end
    if BgWidget.Loop then
      BgWidget:PlayAnimation(BgWidget.Loop, 0, 0)
    end
  end
  if false ~= bPlayBgInAnim and self.CurrentSceneBgWidget and self.CurrentSceneBgWidget.In then
    self.CurrentSceneBgWidget:PlayAnimation(self.CurrentSceneBgWidget.In)
  end
end

function WBP_Piano_Main:RefreshSceneInfoText(ChapterId)
  ChapterId = PianoSceneUtils.NormalizeChapterId(ChapterId)
  if self.Text_Now then
    self.Text_Now:SetText(GText("UI_ChangeBGM_CurrentScene"))
  end
  if not self.Text_Scene then
    return
  end
  if PianoSceneUtils.IsHomeSceneId(ChapterId) then
    self.Text_Scene:SetText(GText("UI_SUBREGION_NAME_210101"))
    return
  end
  local NameKey = PianoSceneUtils.GetChapterDisplayNameKey(ChapterId)
  if NameKey then
    self.Text_Scene:SetText(GText(NameKey))
  end
end

function WBP_Piano_Main:BindChangeMusicBtns()
  if self.Btn_SwitchMusic and self.Btn_SwitchMusic.BindEventOnClicked then
    self.Btn_SwitchMusic:UnBindEventOnClickedByObj(self)
    self.Btn_SwitchMusic:BindEventOnClicked(self, self.OnSwitchMusicClicked)
  end
  if self.Btn_ResetMusic and self.Btn_ResetMusic.BindEventOnClicked then
    self.Btn_ResetMusic:UnBindEventOnClickedByObj(self)
    self.Btn_ResetMusic:BindEventOnClicked(self, self.OnResetDefaultMusicClicked)
  end
end

function WBP_Piano_Main:UnbindChangeMusicBtns()
  if self.Btn_SwitchMusic and self.Btn_SwitchMusic.UnBindEventOnClickedByObj then
    self.Btn_SwitchMusic:UnBindEventOnClickedByObj(self)
  end
  if self.Btn_ResetMusic and self.Btn_ResetMusic.UnBindEventOnClickedByObj then
    self.Btn_ResetMusic:UnBindEventOnClickedByObj(self)
  end
end

function WBP_Piano_Main:OnDungeonBgmCheckStateChanged(bChecked)
  self.DungeonBgmEnabled = bChecked
  if self:IsDungeonSceneMode() then
    self:SetDungeonBgmEnabledForChapter(self.CurrentScene, bChecked)
    self:SavePianoSceneCache()
  end
  self:ApplyDungeonBgmPlaybackState()
  self:RefreshSwitchMusicBtnVisual()
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:OnSwitchMusicClicked()
  if not self:ShouldShowDungeonBgmSwitch() then
    return
  end
  local bNewEnabled = self.DungeonBgmEnabled == false
  if bNewEnabled then
    AudioManager(self):PlayUISound(self, "event:/ui/common/switch_on", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/switch_off", nil, nil)
  end
  self:OnDungeonBgmCheckStateChanged(bNewEnabled)
end

function WBP_Piano_Main:RefreshSwitchMusicBtnVisual()
  if not self.Btn_SwitchMusic then
    return
  end
  local bEnabled = self.DungeonBgmEnabled ~= false
  local ActiveIndex = bEnabled and 0 or 1
  if self.Btn_SwitchMusic.WS_Switch and self.Btn_SwitchMusic.WS_Switch.SetActiveWidgetIndex then
    self.Btn_SwitchMusic.WS_Switch:SetActiveWidgetIndex(ActiveIndex)
  elseif self.Btn_SwitchMusic.WS_Icon and self.Btn_SwitchMusic.WS_Icon.SetActiveWidgetIndex then
    self.Btn_SwitchMusic.WS_Icon:SetActiveWidgetIndex(ActiveIndex)
  elseif self.Btn_SwitchMusic.SetHoldUpAnim then
    self.Btn_SwitchMusic:SetHoldUpAnim(not bEnabled)
  end
end

function WBP_Piano_Main:IsChapterUsingDefaultBgm()
  return 0 == self:GetChapterStoredMusicId()
end

function WBP_Piano_Main:RefreshResetMusicBtnState()
  if not self.Btn_ResetMusic or not self.Btn_ResetMusic.ForbidBtn then
    return
  end
  self.Btn_ResetMusic:ForbidBtn(self:IsChapterUsingDefaultBgm())
end

function WBP_Piano_Main:OnResetDefaultMusicClicked()
  if self.IsClosing or not self:IsDungeonSceneMode() then
    return
  end
  if self:IsChapterUsingDefaultBgm() then
    return
  end
  PianoSceneUtils.SetChapterCustomMusicId(self.CurrentScene, 0, self.ChapterCustomBGM)
  self:SavePianoSceneCache()
  EventManager:FireEvent(EventID.ChangeStoredChapterBGM, self.CurrentScene, 0)
  self:SyncPlayStateForCurrentScene()
  UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_ChangeBGM_Toast_Reset"), 5)
  self:RefreshResetMusicBtnState()
  self:RefreshBtnMusicStateForCurrentSelection()
end

function WBP_Piano_Main:ShouldShowDungeonBgmSwitch()
  return self:IsDungeonSceneMode()
end

function WBP_Piano_Main:RefreshBGMSwitchVisibility()
  local bShow = self:ShouldShowDungeonBgmSwitch()
  if self.VB_ChangeMusic then
    self.VB_ChangeMusic:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Panel_CloseMusic then
    self.Panel_CloseMusic:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if bShow then
    self:RefreshSwitchMusicBtnVisual()
    self:RefreshResetMusicBtnState()
  end
  self:RefreshCloseMusicGamepadKey()
  self:RefreshResetMusicGamepadKey()
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:RefreshHomeMusicBtnVisibility()
  self:UpdateBtnVisbility()
end

function WBP_Piano_Main:GetMusicScoreDisplayName(MusicScoreId)
  local MusicScoreInfo = DataMgr.MusicScore[MusicScoreId]
  return MusicScoreInfo and MusicScoreInfo.MusicScoreName
end

function WBP_Piano_Main:GetPreviewMusicScoreIdForScene(SceneId)
  if PianoSceneUtils.IsHomeSceneId(SceneId) then
    local MusicInfo = self:GetHomeBaseMusicInfo()
    return MusicInfo and MusicInfo.MusicScoreId
  end
  return self:GetDungeonMusicScoreId()
end

function WBP_Piano_Main:GetPreviewMusicDisplayNameKeyForScene(SceneId)
  if PianoSceneUtils.IsHomeSceneId(SceneId) then
    local MusicInfo = self:GetHomeBaseMusicInfo()
    return MusicInfo and MusicInfo.MusicName
  end
  local CustomMusicId = PianoSceneUtils.GetChapterCustomMusicId(SceneId, self.ChapterCustomBGM)
  if CustomMusicId and CustomMusicId > 0 then
    local MusicInfo = DataMgr.Music[CustomMusicId]
    return MusicInfo and MusicInfo.MusicName
  end
  return PIANO_DUNGEON_MUSIC_NAME_KEY
end

function WBP_Piano_Main:CreateMusicScoreListItem(MusicScoreId, Index, bIsLocked)
  local NewMusicScoreData = NewObject(UE4.LoadClass(UIConst.PianoMusicScoreData))
  NewMusicScoreData.Owner = self
  NewMusicScoreData.MusicScoreId = MusicScoreId
  NewMusicScoreData.bIsLocked = bIsLocked
  NewMusicScoreData.Index = Index
  NewMusicScoreData.ReddotNum = self.MusicScoreUnreadNum[MusicScoreId] or 0
  NewMusicScoreData.bIsEmptyMusicScore = false
  NewMusicScoreData.bIsDungeonAlbum = self:IsDungeonMusicScore(MusicScoreId)
  self.List_Album:AddItem(NewMusicScoreData)
  return NewMusicScoreData
end

function WBP_Piano_Main:RebuildListItem()
  self.List_Album:ClearListItems()
  local AllMusicScoreInfos = DataMgr.MusicScore
  local MusicScoreIndex = 0
  local MusicScoreMarkTable = {}
  local HomeMusicInfo = self:GetHomeBaseMusicInfo()
  local CurHomeBaseBGMMusicScoreId = HomeMusicInfo and HomeMusicInfo.MusicScoreId
  local DungeonMusicScoreId = self:GetDungeonMusicScoreId()
  if self:IsDungeonSceneMode() and DungeonMusicScoreId then
    MusicScoreMarkTable[DungeonMusicScoreId] = 1
    self:CreateMusicScoreListItem(DungeonMusicScoreId, MusicScoreIndex, false)
    MusicScoreIndex = MusicScoreIndex + 1
  end
  for _, UnLockMusicScoreId in pairs(self.UnLockMusicScores) do
    if not self:ShouldShowMusicScoreInList(UnLockMusicScoreId) then
    else
      MusicScoreMarkTable[UnLockMusicScoreId] = 1
      self:CreateMusicScoreListItem(UnLockMusicScoreId, MusicScoreIndex, false)
      if not self:IsDungeonSceneMode() and UnLockMusicScoreId == CurHomeBaseBGMMusicScoreId then
        self.Init_Select_ItemIndex = MusicScoreIndex
      end
      MusicScoreIndex = MusicScoreIndex + 1
    end
  end
  for MusicScoreId, _ in pairs(AllMusicScoreInfos) do
    if MusicScoreMarkTable[MusicScoreId] or not self:ShouldShowMusicScoreInList(MusicScoreId) then
    else
      self:CreateMusicScoreListItem(MusicScoreId, MusicScoreIndex, true)
      MusicScoreIndex = MusicScoreIndex + 1
    end
  end
  if MusicScoreIndex < 3 then
    local ExtraMusicItemNum = 3 - MusicScoreIndex
    for i = 1, ExtraMusicItemNum do
      local NewMusicScoreData = NewObject(UE4.LoadClass(UIConst.PianoMusicScoreData))
      NewMusicScoreData.bIsEmptyMusicScore = true
      self.List_Album:AddItem(NewMusicScoreData)
    end
  end
end

function WBP_Piano_Main:InitOtherWidget()
  if self.Key_GamePad then
    self.Key_GamePad:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          Text = nil,
          ImgShortPath = "Y"
        }
      }
    })
  end
  if self.Key_SwitchScene then
    self.Key_SwitchScene:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
  end
  if self.Key_CloseMusic then
    self.Key_CloseMusic:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  end
  if self.Key_ResetMusic then
    self.Key_ResetMusic:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  end
  if self.Text_CloseMusic then
    self.Text_CloseMusic:SetText(GText("UI_CTL_On_OffBGM"))
  end
  if self.Text_ResetMusic then
    self.Text_ResetMusic:SetText(GText("UI_CTL_ChangeBMG_Reset"))
  end
  self.Btn_Music.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_SwitchScene.Button_Area.OnClicked:Add(self, self.OnBtnSwitchSceneClicked)
  self:BindChangeMusicBtns()
  self:InitCommonTab()
end

function WBP_Piano_Main:ReplacePianoTabBackWidget()
  if not self.isPC then
    return
  end
  local Tab = self.Tab_Piano
  if not (IsValid(Tab) and IsValid(Tab.Panel_Back)) or not IsValid(Tab.BackWidget) then
    return
  end
  Tab.BackWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if not IsValid(self.PianoTabBackWidget) then
    self.PianoTabBackWidget = UIManager(self):CreateWidget(PIANO_TAB_BACK_WIDGET_PATH, false)
  end
  local DisplayBack = self.PianoTabBackWidget
  if not IsValid(DisplayBack) then
    return
  end
  if DisplayBack:GetParent() ~= Tab.Panel_Back then
    Tab.Panel_Back:AddChild(DisplayBack)
  end
  DisplayBack:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if DisplayBack.Btn_Back then
    DisplayBack.Btn_Back.OnClicked:Clear()
    DisplayBack.Btn_Back.OnClicked:Add(Tab, Tab.OnReturnClick)
  end
  Tab.Panel_Back:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function WBP_Piano_Main:InitCommonTab()
  self.KeyboardBottomKeyInfo = {
    {
      KeyInfoList = {
        {Type = "Text", Text = "Esc"}
      },
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "B"}
      },
      Desc = GText("HomePiano_GoBack")
    }
  }
  local TabConfigData = {
    TitleName = GText("HomePiano_HomePiano"),
    BackCallback = self.Close,
    OwnerPanel = self,
    DynamicNode = {"Back", "BottomKey"}
  }
  if self.isPC then
    TabConfigData.BottomKeyInfo = self.KeyboardBottomKeyInfo
  end
  self.Tab_Piano:Init(TabConfigData)
  self:ReplacePianoTabBackWidget()
  self:RefreshIconAndGamePadVisibility()
end

function WBP_Piano_Main:UpdateMusicScoreTitle(MusicScoreId)
  local NameKey = self:GetMusicScoreDisplayName(MusicScoreId)
  if NameKey and self.Text_Title then
    self.Text_Title:SetText(GText(NameKey))
  end
end

function WBP_Piano_Main:OnSelectMusicScoreChanged(NewIndex)
  if self.IsClosing then
    return
  end
  local SelectItem = self.List_Album:GetItemAt(NewIndex)
  if not SelectItem then
    return
  end
  self:ClearAlbumListHoverVisual()
  self.CurrentSelectMusicScore = SelectItem.MusicScoreId
  self:UpdateMusicScoreTitle(SelectItem.MusicScoreId)
  EventManager:FireEvent(EventID.ChangeSelectMusicScore, SelectItem.MusicScoreId)
  self.Cur_ListSelectIndex = nil
  self.Cur_ListHoverIndex = nil
  self:UpdateListMusic(SelectItem.MusicScoreId)
  self:SelectDefaultMusicItemAfterListUpdate()
  self:RefreshBGMSwitchVisibility()
end

function WBP_Piano_Main:CreateMusicListItem(MusicId, MusicIndex, bIsLocked, NeedReddot)
  local Data = NewObject(UE4.LoadClass(UIConst.PianoMusicItemData))
  Data.Owner = self
  Data.MusicId = MusicId
  Data.bIsLocked = bIsLocked
  Data.Index = MusicIndex
  Data.NeedReddot = NeedReddot or false
  self.List_Music:AddItem(Data)
  return Data
end

function WBP_Piano_Main:AddDungeonDynamicMusicListItem(MusicIndex)
  if not self.CurrentDungeonBgmEvent then
    return
  end
  local Data = NewObject(UE4.LoadClass(UIConst.PianoMusicItemData))
  Data.Owner = self
  Data.MusicId = 0
  Data.bIsLocked = false
  Data.Index = MusicIndex
  Data.NeedReddot = false
  Data.bIsDungeonDynamicTrack = true
  Data.DungeonBgmEvent = self.CurrentDungeonBgmEvent
  Data.DungeonMusicNameKey = PIANO_DUNGEON_MUSIC_NAME_KEY
  Data.DungeonMusicDesKey = PIANO_DUNGEON_MUSIC_DES_KEY
  self.List_Music:AddItem(Data)
end

function WBP_Piano_Main:CalcDefaultMusicListIndexForScore(NewMusicScoreId)
  if self:IsDungeonMusicScore(NewMusicScoreId) then
    return 0
  end
  local TargetStoredMusicId = self:IsDungeonSceneMode() and self:GetChapterStoredMusicId() or self.CurrentHomeBaseBGM
  if TargetStoredMusicId > 0 and self.UnLockMusicScoreToItems[NewMusicScoreId] then
    local MusicIndex = 0
    for _, UnLockMusicId in pairs(self.UnLockMusicScoreToItems_Sort[NewMusicScoreId]) do
      if UnLockMusicId == TargetStoredMusicId then
        return MusicIndex
      end
      MusicIndex = MusicIndex + 1
    end
  end
  return 0
end

function WBP_Piano_Main:UpdateListMusic(NewMusicScoreId)
  self.List_Music:ClearListItems()
  self.PendingDefaultSelectIndex = nil
  self.Init_Select_MusicIndex = 0
  if self.InputDevice ~= ECommonInputType.Gamepad or self.GamepadFocusArea ~= "Album" then
    self.PendingDefaultSelectIndex = self:CalcDefaultMusicListIndexForScore(NewMusicScoreId)
  end
  local MusicIndex = 0
  if self:IsDungeonMusicScore(NewMusicScoreId) then
    self:AddDungeonDynamicMusicListItem(MusicIndex)
    return
  end
  if self.UnLockMusicScoreToItems[NewMusicScoreId] then
    local TargetStoredMusicId = self:IsDungeonSceneMode() and self:GetChapterStoredMusicId() or self.CurrentHomeBaseBGM
    for _, UnLockMusicId in pairs(self.UnLockMusicScoreToItems_Sort[NewMusicScoreId]) do
      self:CreateMusicListItem(UnLockMusicId, MusicIndex, false, self.UnreadMusicItems[UnLockMusicId])
      if TargetStoredMusicId > 0 and UnLockMusicId == TargetStoredMusicId then
        self.Init_Select_MusicIndex = MusicIndex
      end
      MusicIndex = MusicIndex + 1
    end
  end
  for _, MusicId in pairs(self.AllMusicScoreToMusic[NewMusicScoreId]) do
    if not self.UnLockMusicScoreToItems[NewMusicScoreId][MusicId] then
      self:CreateMusicListItem(MusicId, MusicIndex, true, false)
      MusicIndex = MusicIndex + 1
    end
  end
end

function WBP_Piano_Main:GetMusicListFocusIndex()
  if self.InputDevice == ECommonInputType.Gamepad and self.GamepadFocusArea == "Music" then
    return self.Cur_ListHoverIndex
  end
  return self.Cur_ListSelectIndex
end

function WBP_Piano_Main:ChangeCurrentSelectMusicItem(NewIndex)
  if self.IsClosing then
    return
  end
  local SelectItem = self.List_Music:GetItemAt(NewIndex)
  if not SelectItem then
    return
  end
  local bSameSelection = self.Cur_ListSelectIndex == NewIndex and not self.TextShowNeedForceUpdate
  if self:IsDungeonDynamicMusicItem(SelectItem) then
    if bSameSelection then
      bSameSelection = 0 == self.Cur_SelectMusicId
    end
  else
    bSameSelection = bSameSelection and self.Cur_SelectMusicId == SelectItem.MusicId
  end
  if bSameSelection then
    return
  end
  self.Cur_ListSelectIndex = NewIndex
  self:UpdateMusicItemTextShow(NewIndex)
  EventManager:FireEvent(EventID.ChangeSelectMusicItem, -1)
  EventManager:FireEvent(EventID.ChangeSelectMusicItem, SelectItem.MusicId)
end

function WBP_Piano_Main:ChangeCurrentHoverAlbumItem(NewIndex)
  if self.IsClosing then
    return
  end
  local HoverItem = self.List_Album:GetItemAt(NewIndex)
  if not HoverItem or HoverItem.bIsEmptyMusicScore then
    return
  end
  if self.Cur_AlbumHoverIndex == NewIndex then
    return
  end
  self.Cur_AlbumHoverIndex = NewIndex
  EventManager:FireEvent(EventID.ChangeHoverAlbumItem, HoverItem.MusicScoreId)
end

function WBP_Piano_Main:ClearHoverAlbumItemIfMatch(Index)
  if self.Cur_AlbumHoverIndex ~= Index then
    return
  end
  self:ClearAlbumListHoverVisual()
end

function WBP_Piano_Main:ClearAlbumListHoverVisual()
  if self.Cur_AlbumHoverIndex == nil then
    return
  end
  self.Cur_AlbumHoverIndex = nil
  EventManager:FireEvent(EventID.ChangeHoverAlbumItem, -1)
end

function WBP_Piano_Main:ChangeCurrentHoverMusicItem(NewIndex, bUpdateDescribe)
  if self.IsClosing then
    return
  end
  local HoverItem = self.List_Music:GetItemAt(NewIndex)
  if not HoverItem then
    return
  end
  local bSameHover = self.Cur_ListHoverIndex == NewIndex and not self.TextShowNeedForceUpdate
  if self:IsDungeonDynamicMusicItem(HoverItem) then
    if bSameHover then
      bSameHover = 0 == self.Cur_SelectMusicId
    end
  else
    bSameHover = bSameHover and self.Cur_SelectMusicId == HoverItem.MusicId
  end
  if bSameHover then
    return
  end
  self.Cur_ListHoverIndex = NewIndex
  if true == bUpdateDescribe then
    self:UpdateMusicItemTextShow(NewIndex)
  end
  EventManager:FireEvent(EventID.ChangeHoverMusicItem, HoverItem.MusicId)
end

function WBP_Piano_Main:ClearHoverMusicItemIfMatch(Index)
  if self.Cur_ListHoverIndex ~= Index then
    return
  end
  self.Cur_ListHoverIndex = nil
  EventManager:FireEvent(EventID.ChangeHoverMusicItem, -1)
end

function WBP_Piano_Main:GetDefaultMusicListIndexForAlbumSwitch()
  if self:IsDungeonMusicScore(self.CurrentSelectMusicScore) then
    return self:GetDefaultMusicListIndex()
  end
  return self.Init_Select_MusicIndex or 0
end

function WBP_Piano_Main:SelectDefaultMusicItemAfterListUpdate()
  if self.IsClosing then
    return
  end
  local ItemCount = self.List_Music:GetNumItems()
  if ItemCount <= 0 then
    return
  end
  local TargetIndex = self:GetDefaultMusicListIndexForAlbumSwitch()
  self.PendingMusicListIndex = TargetIndex
  if self.InputDevice == ECommonInputType.Gamepad and self.GamepadFocusArea == "Album" then
    self:ClearMusicListSelectionVisual()
    if self.TextShowNeedForceUpdate then
      self:UpdateMusicItemTextShow(TargetIndex)
    end
    if self.PendingSelectMusicTimer then
      self:RemoveTimer(self.PendingSelectMusicTimer)
      self.PendingSelectMusicTimer = nil
    end
    self.PendingSelectMusicTimer = self:AddTimer(0, function()
      self.PendingSelectMusicTimer = nil
      if self.IsClosing then
        return
      end
      if self.InputDevice == ECommonInputType.Gamepad and self.GamepadFocusArea == "Album" then
        self:ClearMusicListSelectionVisual()
      end
    end, false)
    self.PendingDefaultSelectIndex = nil
    return
  end
  self.Cur_ListSelectIndex = nil
  EventManager:FireEvent(EventID.ChangeSelectMusicItem, -1)
  self:ChangeCurrentSelectMusicItem(TargetIndex)
  if self.PendingSelectMusicTimer then
    self:RemoveTimer(self.PendingSelectMusicTimer)
    self.PendingSelectMusicTimer = nil
  end
  self.PendingSelectMusicTimer = self:AddTimer(0, function()
    self.PendingSelectMusicTimer = nil
    if self.IsClosing then
      return
    end
    local Item = self.List_Music:GetItemAt(TargetIndex)
    if not Item then
      return
    end
    EventManager:FireEvent(EventID.ChangeSelectMusicItem, -1)
    self.Cur_ListSelectIndex = nil
    self:ChangeCurrentSelectMusicItem(TargetIndex)
  end, false)
  self.PendingDefaultSelectIndex = nil
end

function WBP_Piano_Main:RefreshDescribeForCurrentPlayState()
  if self.IsClosing then
    return
  end
  if self.List_Music:GetNumItems() <= 0 then
    return
  end
  local TargetIndex = self:GetDefaultMusicListIndex()
  self:UpdateMusicItemTextShow(TargetIndex)
end

function WBP_Piano_Main:GetDefaultMusicListIndex()
  if self.IsClosing then
    return 0
  end
  local ItemCount = self.List_Music:GetNumItems()
  if ItemCount <= 0 then
    return 0
  end
  for i = 0, ItemCount - 1 do
    local Item = self.List_Music:GetItemAt(i)
    if Item and self:IsDungeonDynamicMusicItem(Item) and self:IsSameDungeonBgmEvent(self.Cur_PlayDungeonBgmEvent, self:GetDungeonBgmEventForMusicItem(Item)) then
      return i
    elseif Item and not self:IsDungeonDynamicMusicItem(Item) and Item.MusicId == self.Cur_PlayMusicId then
      return i
    end
  end
  return self.Init_Select_MusicIndex or 0
end

function WBP_Piano_Main:ResolveMusicListNavTargetIndex()
  local ItemCount = self.List_Music:GetNumItems()
  if ItemCount <= 0 then
    return 0
  end
  if self:IsDungeonSceneMode() and self.Cur_PlayDungeonBgmEvent and self:IsDungeonMusicScore(self.CurrentSelectMusicScore) then
    for i = 0, ItemCount - 1 do
      local Item = self.List_Music:GetItemAt(i)
      if Item and self:IsDungeonDynamicMusicItem(Item) and self:IsSameDungeonBgmEvent(self:GetDungeonBgmEventForMusicItem(Item), self.Cur_PlayDungeonBgmEvent) then
        return i
      end
    end
  end
  if self.Cur_PlayMusicId then
    local MusicData = DataMgr.Music[self.Cur_PlayMusicId]
    if MusicData and MusicData.MusicScoreId == self.CurrentSelectMusicScore then
      for i = 0, ItemCount - 1 do
        local Item = self.List_Music:GetItemAt(i)
        if Item and Item.MusicId == self.Cur_PlayMusicId then
          return i
        end
      end
    end
  end
  if self.PendingMusicListIndex ~= nil then
    local PendingItem = self.List_Music:GetItemAt(self.PendingMusicListIndex)
    if PendingItem then
      return self.PendingMusicListIndex
    end
  end
  if nil ~= self.Cur_ListHoverIndex then
    local HoverItem = self.List_Music:GetItemAt(self.Cur_ListHoverIndex)
    if HoverItem then
      return self.Cur_ListHoverIndex
    end
  end
  if nil ~= self.Cur_ListSelectIndex then
    local HoverItem = self.List_Music:GetItemAt(self.Cur_ListSelectIndex)
    if HoverItem then
      return self.Cur_ListSelectIndex
    end
  end
  if self.Cur_SelectMusicId and self.Cur_SelectMusicId > 0 then
    for i = 0, ItemCount - 1 do
      local Item = self.List_Music:GetItemAt(i)
      if Item and Item.MusicId == self.Cur_SelectMusicId then
        return i
      end
    end
  end
  return self:GetDefaultMusicListIndex()
end

function WBP_Piano_Main:ClearMusicListSelectionVisual()
  EventManager:FireEvent(EventID.ChangeSelectMusicItem, -1)
  EventManager:FireEvent(EventID.ChangeHoverMusicItem, -1)
  self.Cur_ListSelectIndex = nil
  self.Cur_ListHoverIndex = nil
end

function WBP_Piano_Main:UpdateMusicItemTextShow(NewIndex)
  if self.IsClosing then
    return
  end
  local SelectItem = self.List_Music:GetItemAt(NewIndex)
  if not SelectItem then
    return
  end
  self.BtnMusicCanClick = false
  if self:IsDungeonDynamicMusicItem(SelectItem) then
    self.Cur_SelectMusicId = 0
    self:UpdateMusicItemDescribe(SelectItem.DungeonMusicDesKey or PIANO_DUNGEON_MUSIC_DES_KEY, false)
  elseif SelectItem.bIsLocked then
    self.Cur_SelectMusicId = SelectItem.MusicId
    self:UpdateMusicItemDescribe(DataMgr.Music[SelectItem.MusicId].PathDes, true)
  else
    self.Cur_SelectMusicId = SelectItem.MusicId
    self:UpdateMusicItemDescribe(DataMgr.Music[SelectItem.MusicId].MusicDes, false)
  end
  self:PlayAnimation(self.Switch_item)
end

function WBP_Piano_Main:SetPlayStateFromMusicItem(SelectItem)
  if self:IsDungeonDynamicMusicItem(SelectItem) then
    self.Cur_PlayDungeonBgmEvent = self:GetDungeonBgmEventForMusicItem(SelectItem)
    self.Cur_PlayMusicId = nil
  else
    self.Cur_PlayDungeonBgmEvent = nil
    self.Cur_PlayMusicId = SelectItem.MusicId
  end
end

function WBP_Piano_Main:GetChapterStoredMusicId()
  if not self:IsDungeonSceneMode() then
    return 0
  end
  local StoredMusicId = PianoSceneUtils.GetChapterCustomMusicId(self.CurrentScene, self.ChapterCustomBGM)
  if nil == StoredMusicId then
    return 0
  end
  return StoredMusicId
end

function WBP_Piano_Main:GetMusicIdForStoreFromSelection(SelectItem)
  if SelectItem and self:IsDungeonDynamicMusicItem(SelectItem) then
    return 0
  end
  return self.Cur_SelectMusicId or 0
end

function WBP_Piano_Main:IsCurrentSelectionStoredChapterBGM()
  if not self:IsDungeonSceneMode() then
    return false
  end
  local StoredMusicId = self:GetChapterStoredMusicId()
  local SelectItem
  local FocusIndex = self:GetMusicListFocusIndex()
  if nil ~= FocusIndex then
    SelectItem = self.List_Music:GetItemAt(FocusIndex)
  end
  if SelectItem and self:IsDungeonDynamicMusicItem(SelectItem) then
    return 0 == StoredMusicId
  end
  return nil ~= self.Cur_SelectMusicId and StoredMusicId == self.Cur_SelectMusicId
end

function WBP_Piano_Main:RefreshBtnMusicStateForCurrentSelection()
  local bSet
  if self:IsDungeonSceneMode() then
    bSet = self:IsCurrentSelectionStoredChapterBGM()
  else
    bSet = self.Cur_SelectMusicId ~= nil and self.Cur_SelectMusicId == self.CurrentHomeBaseBGM
  end
  if bSet == self.BtnMusic_IsSet then
    if self.TEXT_Btn then
      if bSet then
        if self:IsDungeonSceneMode() then
          self.TEXT_Btn:SetText(GText("HomePiano_AlreadySetDungeon"))
        else
          self.TEXT_Btn:SetText(GText("HomePiano_AlreadySet"))
        end
      elseif self:IsDungeonSceneMode() then
        self.TEXT_Btn:SetText(GText("HomePiano_SetAsDungeon"))
      else
        self.TEXT_Btn:SetText(GText("HomePiano_SetAsHome"))
      end
    end
    return
  end
  self:ChangeBtnMusicState(bSet, false)
end

function WBP_Piano_Main:ChangeCurrentPlayedMusicItem(NewIndex)
  if self.IsClosing then
    return
  end
  local SelectItem = self.List_Music:GetItemAt(NewIndex)
  if not SelectItem then
    return
  end
  if not SelectItem.bIsLocked then
    self:SetPlayStateFromMusicItem(SelectItem)
    self:PlayCurrentMusicSelection(true)
  end
  self:UpdateBtnVisbility()
  if self.InputDevice == ECommonInputType.Gamepad then
    self:RefreshGamepadBottomKeys()
  end
  if IsValid(self.Book) and self.Book.FlipBook then
    self.Book:FlipBook()
  end
  self:RefreshBtnMusicStateForCurrentSelection()
  self:StopAnimation(self.Click)
end

function WBP_Piano_Main:OnBtnClicked()
  if self.IsClosing or not self.BtnMusicCanClick then
    return
  end
  if self:IsDungeonSceneMode() then
    if self:IsCurrentSelectionStoredChapterBGM() then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("HomePiano_AlreadySetDungeon"), 5)
      return
    end
    if not self.BtnMusic_IsSet then
      self:PlayAnimation(self.Click)
    end
    AudioManager(self):PlayUISound(self, "event:/ui/common/music_savor_change_btn_click", nil, nil)
    local FocusIndex = self:GetMusicListFocusIndex()
    local SelectItem = nil ~= FocusIndex and self.List_Music:GetItemAt(FocusIndex) or nil
    local MusicId = self:GetMusicIdForStoreFromSelection(SelectItem)
    PianoSceneUtils.SetChapterCustomMusicId(self.CurrentScene, MusicId, self.ChapterCustomBGM)
    self:SavePianoSceneCache()
    EventManager:FireEvent(EventID.ChangeStoredChapterBGM, self.CurrentScene, MusicId)
    self:ChangeBtnMusicState(true, true)
    self:RefreshResetMusicBtnState()
    return
  end
  if self.CurrentHomeBaseBGM == self.Cur_SelectMusicId then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("HomePiano_SetAsHomeAlready"), 5)
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self.BtnMusic_IsSet then
    self:PlayAnimation(self.Click)
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/music_savor_change_btn_click", nil, nil)
  self.CurrentHomeBaseBGM = self.Cur_SelectMusicId
  Avatar:SetHomeBaseBGM(self.CurrentHomeBaseBGM)
  EventManager:FireEvent(EventID.ChangeStoredCustomBGM, self.CurrentHomeBaseBGM)
  self:ChangeBtnMusicState(true, true)
end

function WBP_Piano_Main:ChangeBtnMusicState(bSet, bFromBtnClick)
  if bSet == self.BtnMusic_IsSet then
    return
  end
  if bSet then
    if self:IsDungeonSceneMode() then
      self.TEXT_Btn:SetText(GText("HomePiano_AlreadySetDungeon"))
    else
      self.TEXT_Btn:SetText(GText("HomePiano_AlreadySet"))
    end
    self.Btn_Music:SetForbidden(true)
    if not bFromBtnClick then
      if self.Click then
        self:StopAnimation(self.Click)
      end
      if self.Forbidden then
        self:PlayAnimation(self.Forbidden)
      end
    end
  else
    if self:IsDungeonSceneMode() then
      self.TEXT_Btn:SetText(GText("HomePiano_SetAsDungeon"))
    else
      self.TEXT_Btn:SetText(GText("HomePiano_SetAsHome"))
    end
    self.Btn_Music:SetForbidden(false)
    if self.Normal then
      self:PlayAnimation(self.Normal)
    end
  end
  self.BtnMusic_IsSet = bSet
end

local function HasDescribeDisplayText(DescribeTextKey)
  if not DescribeTextKey or "" == DescribeTextKey then
    return false
  end
  local DisplayText = GText(DescribeTextKey)
  return nil ~= DisplayText and "" ~= DisplayText
end

function WBP_Piano_Main:UpdatePanelDescVisibility(bVisible)
  if not self.Panel_Desc or not self.Panel_Desc.SetVisibility then
    return
  end
  self.Panel_Desc:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function WBP_Piano_Main:UpdateMusicItemDescribe(UpdateText, IsLocked)
  if IsLocked then
    self.Text_Lock:SetText(GText(UpdateText))
  else
    self.Text_Describe:SetText(GText(UpdateText))
  end
  self:UpdateLockState(IsLocked)
  self:UpdatePanelDescVisibility(not IsLocked and HasDescribeDisplayText(UpdateText))
  self:UpdateBtnVisbility()
  self:RefreshTabShow(self.Cur_SelectMusicId, IsLocked)
end

function WBP_Piano_Main:UpdateLockState(bIsLock)
  if not self.TextShowNeedForceUpdate and bIsLock == self.IsShowingLockText then
    return
  end
  if bIsLock then
    self.Text_Describe:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Hb_Lock:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Text_Describe:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Hb_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:UpdateBtnVisbility()
  end
  self.IsShowingLockText = bIsLock
  self.TextShowNeedForceUpdate = false
end

function WBP_Piano_Main:CollapseMusicItemDescribe()
  if self.TextShowNeedForceUpdate then
    return
  end
  self.Text_Describe:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Hb_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:UpdatePanelDescVisibility(false)
  if self.InputDevice == ECommonInputType.Gamepad then
    self:RefreshGamepadBottomKeys()
  end
  self.TextShowNeedForceUpdate = true
end

function WBP_Piano_Main:UpdateBtnVisbility()
  if self.IsShowingLockText then
    self.BtnMusicCanClick = false
    return
  end
  self.Panel_Btn:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.BtnMusicCanClick = true
  self:RefreshBtnMusicStateForCurrentSelection()
end

function WBP_Piano_Main:CloseSwitchScenePanel()
  if not IsValid(self.SwitchScenePanel) then
    return false
  end
  self.SwitchScenePanel:RemoveFromParent()
  self.SwitchScenePanel = nil
  self:RefreshSwitchSceneGamepadKey()
  self:RefreshCloseMusicGamepadKey()
  self:RefreshResetMusicGamepadKey()
  if self.InputDevice == ECommonInputType.Gamepad then
    self:RefreshGamepadBottomKeys()
    self:AddTimer(0.05, function()
      if not self.IsClosing then
        self:HandleGamepadRefocus()
      end
    end)
  end
  return true
end

function WBP_Piano_Main:OnSwitchScenePanelOpened()
  self:RefreshSwitchSceneGamepadKey()
  self:RefreshCloseMusicGamepadKey()
  self:RefreshResetMusicGamepadKey()
  if self.InputDevice == ECommonInputType.Gamepad then
    self:RefreshGamepadBottomKeys()
    if IsValid(self.SwitchScenePanel) and self.SwitchScenePanel.FocusGamepadSceneList then
      self.SwitchScenePanel:FocusGamepadSceneList()
    end
  end
end

function WBP_Piano_Main:OnGamepadPlayMusicPressed()
  if self.InputDevice ~= ECommonInputType.Gamepad then
    return false
  end
  if self.GamepadFocusArea ~= "Music" then
    return false
  end
  local FocusIndex = self.Cur_ListHoverIndex
  if nil == FocusIndex then
    return false
  end
  local SelectItem = self.List_Music:GetItemAt(FocusIndex)
  if not SelectItem or SelectItem.bIsLocked then
    return false
  end
  self:ChangeCurrentSelectMusicItem(FocusIndex)
  self:ChangeCurrentPlayedMusicItem(FocusIndex)
  return true
end

function WBP_Piano_Main:OnGamepadSwitchScenePressed()
  if IsValid(self.SwitchScenePanel) then
    return false
  end
  self:OnBtnSwitchSceneClicked()
  return true
end

function WBP_Piano_Main:OnGamepadToggleDungeonBgmPressed()
  if not self:ShouldShowDungeonBgmSwitch() then
    return false
  end
  self:OnSwitchMusicClicked()
  return true
end

function WBP_Piano_Main:OnGamepadResetDefaultMusicPressed()
  if not self:ShouldShowDungeonBgmSwitch() then
    return false
  end
  if self:IsChapterUsingDefaultBgm() then
    return false
  end
  self:OnResetDefaultMusicClicked()
  return true
end

function WBP_Piano_Main:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if IsValid(self.SwitchScenePanel) then
    if "Escape" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight then
      if self.SwitchScenePanel.RequestClose then
        self.SwitchScenePanel:RequestClose()
      else
        self:CloseSwitchScenePanel()
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
      if self.SwitchScenePanel.HandleGamepadKeyDown and self.SwitchScenePanel:HandleGamepadKeyDown(InKeyName) then
        return UE4.UWidgetBlueprintLibrary.Handled()
      end
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  if "Escape" == InKeyName then
    self:Close()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:Close()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnBtnClicked()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
      self:OnGamepadPlayMusicPressed()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      self:OnGamepadSwitchScenePressed()
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
      self:OnGamepadToggleDungeonBgmPressed()
    elseif InKeyName == UIConst.GamePadKey.RightThumb then
      self:OnGamepadResetDefaultMusicPressed()
    end
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function WBP_Piano_Main:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function WBP_Piano_Main:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function WBP_Piano_Main:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self.InputDevice = NewGameInputType
  self:RefreshIconAndGamePadVisibility()
  if NewGameInputType == ECommonInputType.Gamepad then
    if IsValid(self.SwitchScenePanel) and self.SwitchScenePanel.InitGamepadAfterOpen then
      self.SwitchScenePanel:InitGamepadAfterOpen()
    else
      self:HandleGamepadRefocus()
    end
  end
end

function WBP_Piano_Main:RefreshSwitchSceneGamepadKey()
  if not self.Key_SwitchScene then
    return
  end
  if self.isPC and self.InputDevice == ECommonInputType.Gamepad and not IsValid(self.SwitchScenePanel) then
    self.Key_SwitchScene:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_SwitchScene:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Piano_Main:RefreshCloseMusicGamepadKey()
  if not self.Key_CloseMusic then
    return
  end
  if self.isPC and self.InputDevice == ECommonInputType.Gamepad and not IsValid(self.SwitchScenePanel) and self:ShouldShowDungeonBgmSwitch() then
    self.Key_CloseMusic:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_CloseMusic:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Piano_Main:RefreshResetMusicGamepadKey()
  if not self.Key_ResetMusic then
    return
  end
  if self.isPC and self.InputDevice == ECommonInputType.Gamepad and not IsValid(self.SwitchScenePanel) and self:ShouldShowDungeonBgmSwitch() then
    self.Key_ResetMusic:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_ResetMusic:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Piano_Main:RefreshIconAndGamePadVisibility()
  if not self.isPC then
    return
  end
  if self.InputDevice == ECommonInputType.Gamepad then
    self:ListMusicBindSelectChangeDelegate()
    if self.Key_GamePad then
      self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self:RefreshSwitchSceneGamepadKey()
    self:RefreshCloseMusicGamepadKey()
    self:RefreshResetMusicGamepadKey()
    self:RefreshGamepadBottomKeys()
  else
    self:ListMusicUnBindSelectChangeDelegate()
    if self.Key_GamePad then
      self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    self:RefreshSwitchSceneGamepadKey()
    self:RefreshCloseMusicGamepadKey()
    self:RefreshResetMusicGamepadKey()
    if self.Tab_Piano and self.Tab_Piano.UpdateBottomKeyInfo and self.KeyboardBottomKeyInfo then
      self.Tab_Piano:UpdateBottomKeyInfo(self.KeyboardBottomKeyInfo)
    end
  end
end

function WBP_Piano_Main:ShouldShowGamepadPlayBottomKey()
  if self.GamepadFocusArea ~= "Music" then
    return false
  end
  local SelectItem
  if self.Cur_ListHoverIndex ~= nil then
    SelectItem = self.List_Music:GetItemAt(self.Cur_ListHoverIndex)
  end
  if not SelectItem or SelectItem.bIsLocked then
    return false
  end
  return not self:IsMusicListItemCurrentlyPlaying(SelectItem)
end

function WBP_Piano_Main:BuildGamepadBottomKeyInfo()
  if IsValid(self.SwitchScenePanel) and self.SwitchScenePanel.BuildGamepadBottomKeyInfo then
    return self.SwitchScenePanel:BuildGamepadBottomKeyInfo()
  end
  local BottomKeyInfo = {}
  if self:ShouldShowGamepadPlayBottomKey() then
    BottomKeyInfo[#BottomKeyInfo + 1] = {
      GamePadInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("HomePiano_PlayMusic")
    }
  end
  BottomKeyInfo[#BottomKeyInfo + 1] = {
    KeyInfoList = {
      {Type = "Text", Text = "Esc"}
    },
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("HomePiano_GoBack")
  }
  return BottomKeyInfo
end

function WBP_Piano_Main:RefreshGamepadBottomKeys()
  if not self.isPC or self.InputDevice ~= ECommonInputType.Gamepad then
    return
  end
  if not self.Tab_Piano or not self.Tab_Piano.UpdateBottomKeyInfo then
    return
  end
  self.Tab_Piano:UpdateBottomKeyInfo(self:BuildGamepadBottomKeyInfo())
end

function WBP_Piano_Main:GetGamepadAlbumFocusIndex()
  if self.CurrentSelectMusicScore then
    local ItemCount = self.List_Album:GetNumItems()
    for i = 0, ItemCount - 1 do
      local Item = self.List_Album:GetItemAt(i)
      if Item and not Item.bIsEmptyMusicScore and Item.MusicScoreId == self.CurrentSelectMusicScore then
        return Item.Index or i
      end
    end
  end
  if self.Init_Select_ItemIndex ~= nil then
    return self.Init_Select_ItemIndex
  end
  return 0
end

function WBP_Piano_Main:SetListViewEntryFocus(ListView, ItemIndex)
  if not ListView then
    return
  end
  ListView:ScrollIndexIntoView(ItemIndex)
  local EntryWidget = URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(ListView, ItemIndex)
  if EntryWidget and EntryWidget.SetFocus then
    EntryWidget:SetFocus()
  elseif ListView.SetFocus then
    ListView:SetFocus()
  end
end

function WBP_Piano_Main:HandleGamepadRefocus()
  if self.IsClosing or not self.isPC then
    return
  end
  if self.InputDevice ~= ECommonInputType.Gamepad then
    return
  end
  if IsValid(self.SwitchScenePanel) then
    return
  end
  if self.GamepadFocusArea == "Music" then
    self:FocusGamepadMusicList()
  else
    self:FocusGamepadAlbumList()
  end
end

function WBP_Piano_Main:FocusGamepadAlbumList()
  if not self.List_Album then
    return
  end
  self.GamepadFocusArea = "Album"
  local TargetIndex = self:GetGamepadAlbumFocusIndex()
  self.List_Album:NavigateToIndex(TargetIndex)
  self:SetListViewEntryFocus(self.List_Album, TargetIndex)
  self:ClearMusicListSelectionVisual()
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:FocusGamepadMusicList()
  if not self.List_Music then
    return
  end
  self.GamepadFocusArea = "Music"
  local TargetIndex = self:ResolveMusicListNavTargetIndex()
  local Item = self.List_Music:GetItemAt(TargetIndex)
  if Item then
    self.List_Music:BP_NavigateToItem(Item)
  else
    self.List_Music:NavigateToIndex(TargetIndex)
  end
  self.PendingMusicListIndex = TargetIndex
  self.TextShowNeedForceUpdate = true
  self:ChangeCurrentHoverMusicItem(TargetIndex, false)
  self.TextShowNeedForceUpdate = false
  self:SetListViewEntryFocus(self.List_Music, TargetIndex)
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:ListMusicBindSelectChangeDelegate()
  if not self.List_Music or not self.List_Music.BP_OnItemSelectionChanged then
    return
  end
  self.List_Music.BP_OnItemSelectionChanged:Clear()
  self.List_Music.BP_OnItemSelectionChanged:Add(self, self.OnMusicListItemSelectionChanged)
end

function WBP_Piano_Main:ListMusicUnBindSelectChangeDelegate()
  if self.List_Music and self.List_Music.BP_OnItemSelectionChanged then
    self.List_Music.BP_OnItemSelectionChanged:Remove(self, self.OnMusicListItemSelectionChanged)
  end
end

function WBP_Piano_Main:OnMusicListItemSelectionChanged(Item, bIsSelected)
  if not bIsSelected or not Item then
    return
  end
  self.GamepadFocusArea = "Music"
  self:ChangeCurrentHoverMusicItem(Item.Index, false)
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:RefreshTabShow(SelectMusicId, IsLocked)
  self:RefreshGamepadBottomKeys()
end

function WBP_Piano_Main:GetPianoOpenContextSceneId()
  if not WorldTravelSubsystem then
    return nil
  end
  local Subsystem = WorldTravelSubsystem()
  if not Subsystem or not Subsystem.GetCurrentSceneId then
    return nil
  end
  local DungeonId = Subsystem:GetCurrentSceneId()
  if not DungeonId or 0 == DungeonId then
    return nil
  end
  local ChapterId = DataMgr.Dungeon2Select and DataMgr.Dungeon2Select[DungeonId]
  if ChapterId and PianoSceneUtils.IsChapterAvailableInPianoScene(ChapterId) then
    return PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(ChapterId)
  end
  return nil
end

function WBP_Piano_Main:OnBtnSwitchSceneClicked()
  if IsValid(self.SwitchScenePanel) then
    return
  end
  self.SwitchScenePanel = UIManager(self):CreateWidget("/Game/UI/WBP/Piano/Widget/WBP_Piano_SwitchScene.WBP_Piano_SwitchScene", false)
  if not IsValid(self.SwitchScenePanel) then
    return
  end
  self.SwitchScenePanel:AddToViewport(self:GetZOrder() + 1)
  self.SwitchScenePanel.PianoMain = self
  self.SwitchScenePanel:Init(self.CurrentScene, self:GetPianoOpenContextSceneId())
  self:OnSwitchScenePanelOpened()
end

function WBP_Piano_Main:OnMusicItemNewStateChange(MusicId)
  if not self.UnreadMusicItems[MusicId] then
    self.ReadMusicItems[MusicId] = 1
    return
  end
  self.UnreadMusicItems[MusicId] = nil
  self.ReadMusicItems[MusicId] = 1
  local MusicInfo = DataMgr.Music[MusicId]
  if not MusicInfo or not self.MusicScoreUnreadNum then
    return
  end
  local MusicScoreId = MusicInfo.MusicScoreId
  local NewUnreadNum = math.max(0, (self.MusicScoreUnreadNum[MusicScoreId] or 0) - 1)
  self.MusicScoreUnreadNum[MusicScoreId] = NewUnreadNum
  local ItemCount = self.List_Album:GetNumItems()
  for i = 0, ItemCount - 1 do
    local Item = self.List_Album:GetItemAt(i)
    if Item and not Item.bIsEmptyMusicScore and Item.MusicScoreId == MusicScoreId then
      Item.ReddotNum = NewUnreadNum
      break
    end
  end
end

function WBP_Piano_Main:List_Album_NavRight(NavigationDirection)
  self.GamepadFocusArea = "Music"
  local TargetIndex = self:ResolveMusicListNavTargetIndex()
  local Item = self.List_Music:GetItemAt(TargetIndex)
  if Item then
    return self:FinishNavigateToMusicItem(TargetIndex, Item)
  end
  return self:FinishNavigateToMusicItem(0, nil)
end

function WBP_Piano_Main:FinishNavigateToMusicItem(MusicIndex, Item)
  if Item then
    self.List_Music:BP_NavigateToItem(Item)
    MusicIndex = Item.Index
  else
    self.List_Music:NavigateToIndex(MusicIndex)
  end
  self.PendingMusicListIndex = MusicIndex
  self.TextShowNeedForceUpdate = true
  self:ChangeCurrentHoverMusicItem(MusicIndex, false)
  self.TextShowNeedForceUpdate = false
  self:RefreshGamepadBottomKeys()
  return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Music, MusicIndex)
end

function WBP_Piano_Main:List_Music_NavLeft(NavigationDirection)
  self.GamepadFocusArea = "Album"
  self:RefreshGamepadBottomKeys()
  local TargetMusicScoreId = self.CurrentSelectMusicScore
  if TargetMusicScoreId then
    local ItemCount = self.List_Album:GetNumItems()
    for i = 0, ItemCount - 1 do
      local Item = self.List_Album:GetItemAt(i)
      if Item and not Item.bIsEmptyMusicScore and Item.MusicScoreId == TargetMusicScoreId then
        self.List_Album:BP_NavigateToItem(Item)
        return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Album, Item.Index)
      end
    end
  end
  self.List_Album:NavigateToIndex(0)
  return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Album, 0)
end

return WBP_Piano_Main
