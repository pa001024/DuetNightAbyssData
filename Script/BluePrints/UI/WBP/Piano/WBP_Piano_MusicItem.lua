require("UnLua")
require("DataMgr")
local WBP_Piano_MusicItem = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C",
  "BluePrints.Common.TimerMgr"
})
local LOCKED_TIME_TEXT = "--:--"

function WBP_Piano_MusicItem:BP_OnEntryReleased()
  self.bIsHovered = false
  self.bIsListSelected = false
  self:StopScrollAnim()
  self.bPendingVisualRefresh = false
  self.bIsPlayingEntryAnim = false
  self:ClearScriptRegister()
  self:StopAllAnimations()
  if self.IsPlaying then
    return
  end
  if self.IsLocked and self.Forbidden and self.Forbidden.GetEndTime then
    self:PlayAnimation(self.Forbidden, self.Forbidden:GetEndTime())
  elseif self.Normal and self.Normal.GetEndTime then
    self:PlayAnimation(self.Normal, self.Normal:GetEndTime())
  end
end

function WBP_Piano_MusicItem:Destruct()
  self.Button_Music.OnClicked:Remove(self, self.OnBtnClicked)
  self.Button_Music.OnHovered:Remove(self, self.OnBtnHovered)
  self.Button_Music.OnUnHovered:Remove(self, self.OnBtnUnHovered)
  if self.UpdateProgressTimer then
    self:RemoveTimer(self.UpdateProgressTimer)
    self.UpdateProgressTimer = nil
  end
  self:StopScrollAnim()
  self.bIsPlayingEntryAnim = false
  self.bPendingVisualRefresh = false
  self:ClearScriptRegister()
end

function WBP_Piano_MusicItem:OnListItemObjectSet(ListItemObject)
  self.DataObject = ListItemObject
  self.ParentUI = ListItemObject.Owner
  self.MusicId = ListItemObject.MusicId
  self.IsLocked = ListItemObject.bIsLocked
  self.ListViewIndex = ListItemObject.Index
  self.NeedReddot = ListItemObject.NeedReddot
  self.bIsListSelected = false
  self.bIsHovered = false
  self.IsPlaying = false
  self.IsStoredCustomBGMMusicScore = false
  self.EventInstance = nil
  self.UpdateProgressTimer = nil
  self.bIsPlayingEntryAnim = false
  self.bPendingVisualRefresh = false
  self:StopScrollAnim()
  self.bIsDungeonDynamicTrack = self.ParentUI:IsDungeonDynamicMusicItem(ListItemObject)
  self:InitUI()
  self:AddDispatcher(EventID.ChangePlayedMusicItem, self, self.OnPlayedMusicItemChanged)
  self:AddDispatcher(EventID.ChangeSelectMusicItem, self, self.OnSelectMusicItemChanged)
  self:AddDispatcher(EventID.ChangeHoverMusicItem, self, self.OnHoverMusicItemChanged)
  self:AddDispatcher(EventID.ChangeStoredCustomBGM, self, self.OnStoredCustomBGMChanged)
  self:AddDispatcher(EventID.ChangeStoredChapterBGM, self, self.OnStoredChapterBGMChanged)
  self.bIsOnListItemSet = true
  if self:IsCurrentlyPlayingTrack() then
    self.IsPlaying = true
    self.EventInstance = AudioManager(self):GetPlayingFMODEventInstance(nil, "BGMKey_0")
  end
  if self.ParentUI.Cur_ListSelectIndex == self.ListViewIndex or self.ParentUI.PendingDefaultSelectIndex == self.ListViewIndex then
    self.bIsListSelected = true
    self:ClearReddotIfNeeded()
  end
  if self.ParentUI.Cur_ListHoverIndex == self.ListViewIndex then
    self.bIsHovered = true
  end
  self:RefreshItemVisualState()
  if self.In then
    self.bIsPlayingEntryAnim = true
    self:BindToAnimationFinished(self.In, {
      self,
      self.OnEntryAnimFinished
    })
    self:PlayAnimation(self.In)
  else
    self:OnEntryAnimFinished()
  end
  if self.IsPlaying and not self.IsLocked and not self:IsLoopingDungeonDefaultBgm() and not self.UpdateProgressTimer and self.EventLength and self.EventLength > 0 then
    self.UpdateProgressTimer = self:AddTimer(0.1, self.UpdateProgressBar, true, 0, "BGM", true)
  end
  if self.ParentUI:IsDungeonSceneMode() then
    if self:IsStoredChapterBGMForCurrentScene() then
      self:IsStoredBGMMusic()
    end
  elseif not self.bIsDungeonDynamicTrack and self.MusicId == self.ParentUI.CurrentHomeBaseBGM then
    self:IsStoredBGMMusic()
  end
  self.bIsOnListItemSet = false
end

function WBP_Piano_MusicItem:IsDungeonEventPlayTarget(PlayTarget)
  if not PlayTarget or not self.SoundEventPath then
    return false
  end
  if type(PlayTarget) == "number" then
    return false
  end
  return tostring(PlayTarget) == tostring(self.SoundEventPath)
end

function WBP_Piano_MusicItem:IsCurrentlyPlayingTrack()
  if self.bIsDungeonDynamicTrack then
    if not self.SoundEventPath or not self.ParentUI.Cur_PlayDungeonBgmEvent then
      return false
    end
    return tostring(self.ParentUI.Cur_PlayDungeonBgmEvent) == tostring(self.SoundEventPath)
  end
  return self.MusicId == self.ParentUI.Cur_PlayMusicId
end

function WBP_Piano_MusicItem:IsLoopingDungeonDefaultBgm()
  return self.bIsDungeonDynamicTrack == true
end

function WBP_Piano_MusicItem:ApplyLoopingDungeonBgmTimeDisplay()
  if self.Hb_Time then
    self.Hb_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Panel_Bar then
    self.Panel_Bar:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Text_Time then
    self.Text_Time:SetText(LOCKED_TIME_TEXT)
  end
  if self.Text_Total_Time then
    self.Text_Total_Time:SetText(LOCKED_TIME_TEXT)
  end
  if self.Bar_Time then
    self.Bar_Time:SetPercent(0)
  end
end

function WBP_Piano_MusicItem:ApplyNormalUnlockedTimeDisplay()
  if self.Hb_Time then
    self.Hb_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Panel_Bar then
    self.Panel_Bar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.EventLength = AudioManager(self):GetEventLengthByPath(self.SoundEventPath) or 0
  if self.EventLength > 0 then
    local EventLength_Second = math.floor(self.EventLength / 1000)
    local Event_Minute = math.floor(EventLength_Second / 60)
    local Event_Second = EventLength_Second % 60
    local TotalTimeStr = string.format("%02d:%02d", Event_Minute, Event_Second)
    self.Text_Total_Time:SetText(TotalTimeStr)
  else
    self.Text_Total_Time:SetText(LOCKED_TIME_TEXT)
  end
  self.Text_Time:SetText("00:00")
  self.Bar_Time:SetPercent(0)
end

function WBP_Piano_MusicItem:ResetUnlockedTimeDisplay()
  if self:IsLoopingDungeonDefaultBgm() then
    self:ApplyLoopingDungeonBgmTimeDisplay()
    return
  end
  self.Text_Time:SetText("00:00")
  self.Bar_Time:SetPercent(0)
end

function WBP_Piano_MusicItem:InitUI()
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.bIsDungeonDynamicTrack then
    local NameKey = self.DataObject.DungeonMusicNameKey
    self.Text_Name:SetText(GText(NameKey))
    self.SoundEventPath = self.ParentUI:GetDungeonBgmEventForMusicItem(self.DataObject)
  else
    local MusicInfo = DataMgr.Music[self.MusicId]
    self.Text_Name:SetText(GText(MusicInfo.MusicName))
    self.SoundEventPath = MusicInfo.Event
  end
  if self.IsLocked then
    self.Hb_Time:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Panel_Bar:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Time:SetText(LOCKED_TIME_TEXT)
    self.Text_Total_Time:SetText(LOCKED_TIME_TEXT)
    self.Bar_Time:SetPercent(0)
    self.Button_Music:SetForbidden(false)
  elseif self:IsLoopingDungeonDefaultBgm() then
    self:ApplyLoopingDungeonBgmTimeDisplay()
    self.Button_Music:SetForbidden(false)
  else
    self:ApplyNormalUnlockedTimeDisplay()
    self.Button_Music:SetForbidden(false)
  end
  if self.NeedReddot then
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Button_Music.OnClicked:Add(self, self.OnBtnClicked)
  self.Button_Music.OnHovered:Add(self, self.OnBtnHovered)
  self.Button_Music.OnUnHovered:Add(self, self.OnBtnUnHovered)
end

function WBP_Piano_MusicItem:OnBtnClicked()
  self.ParentUI:ChangeCurrentSelectMusicItem(self.ListViewIndex)
  if self.IsLocked then
    if not self.bIsOnListItemSet then
      AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
    end
    return
  end
  self.ParentUI:ChangeCurrentPlayedMusicItem(self.ListViewIndex)
  if not self.bIsOnListItemSet then
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_content", nil, nil)
  end
end

function WBP_Piano_MusicItem:OnBtnHovered()
  self:PlayScrollAnim()
  if self.bIsListSelected then
    return
  end
  self.ParentUI:ChangeCurrentHoverMusicItem(self.ListViewIndex, false)
end

function WBP_Piano_MusicItem:OnBtnUnHovered()
  self:StopScrollAnim()
  if self.bIsListSelected then
    return
  end
  self.ParentUI:ClearHoverMusicItemIfMatch(self.ListViewIndex)
end

function WBP_Piano_MusicItem:PlayScrollAnim()
  if not self.Text_Name then
    return
  end
  if not self.TextLength then
    local DesiredSize = self.Text_Name:GetDesiredSize()
    if not DesiredSize or not DesiredSize.X then
      return
    end
    self.TextLength = DesiredSize.X * -1
  end
  self.ScrollTimer = self:AddTimer(0.02, self.ScrollMusicName, true, 0, "Scroll", true)
end

function WBP_Piano_MusicItem:StopScrollAnim()
  if self.ScrollTimer then
    self:RemoveTimer(self.ScrollTimer)
    self.ScrollTimer = nil
  end
  self.TextLength = nil
  if self.Text_Name then
    self.Text_Name:SetRenderTranslation(FVector2D(0, 0))
  end
end

function WBP_Piano_MusicItem:ScrollMusicName()
  if not self.TextLength or not self.Text_Name then
    self:StopScrollAnim()
    return
  end
  local NewTrans = self.Text_Name.RenderTransform.Translation
  if not NewTrans or not NewTrans.X then
    return
  end
  if NewTrans.X < self.TextLength then
    NewTrans.X = 355
  else
    NewTrans.X = NewTrans.X - 1
  end
  self.Text_Name:SetRenderTranslation(NewTrans)
end

function WBP_Piano_MusicItem:ClearReddotIfNeeded()
  if not self.NeedReddot then
    return
  end
  EventManager:FireEvent(EventID.ChangeMusicItemNewState, self.MusicId)
  self.NeedReddot = false
  if self.DataObject then
    self.DataObject.NeedReddot = false
  end
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Piano_MusicItem:OnEntryAnimFinished()
  self.bIsPlayingEntryAnim = false
  if self.bPendingVisualRefresh then
    self.bPendingVisualRefresh = false
    self:RefreshItemVisualState()
  end
end

function WBP_Piano_MusicItem:RequestRefreshItemVisualState()
  if self.bIsPlayingEntryAnim then
    self.bPendingVisualRefresh = true
    return
  end
  self:RefreshItemVisualState()
end

function WBP_Piano_MusicItem:OnSelectMusicItemChanged(NewMusicId)
  local bSelected
  if self.bIsDungeonDynamicTrack then
    bSelected = 0 == NewMusicId
  else
    bSelected = NewMusicId == self.MusicId
  end
  if self.bIsListSelected == bSelected then
    return
  end
  self.bIsListSelected = bSelected
  if bSelected then
    self.bIsHovered = false
    self:ClearReddotIfNeeded()
  end
  self:RequestRefreshItemVisualState()
end

function WBP_Piano_MusicItem:OnHoverMusicItemChanged(HoverMusicId)
  local bHovered = false
  if HoverMusicId >= 0 then
    if self.bIsDungeonDynamicTrack then
      bHovered = 0 == HoverMusicId
    else
      bHovered = HoverMusicId == self.MusicId
    end
  end
  if self.bIsHovered == bHovered then
    return
  end
  self.bIsHovered = bHovered
  self:RequestRefreshItemVisualState()
end

function WBP_Piano_MusicItem:PlayNormalPlayingVisual()
  if self.Normal_Playing then
    self:PlayAnimation(self.Normal_Playing)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function WBP_Piano_MusicItem:UpdateSelectRhythmVisibility()
  if not self.VX_Ryhthm then
    return
  end
  local bShowRhythm = not self.IsLocked and self.bIsListSelected and self.IsPlaying
  if bShowRhythm then
    self.VX_Ryhthm:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.VX_Ryhthm:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function WBP_Piano_MusicItem:RefreshItemVisualState()
  if self.IsLocked then
    self:StopAllAnimations()
    if self.bIsListSelected then
      if self.Lock_Select then
        self:PlayAnimation(self.Lock_Select)
      end
    elseif self.bIsHovered then
      self:PlayAnimation(self.Hover)
    elseif self.Forbidden then
      self:PlayAnimation(self.Forbidden)
    end
    self:UpdateSelectRhythmVisibility()
    return
  end
  self:StopAllAnimations()
  if self.IsPlaying then
    self.WS_Icon:SetActiveWidgetIndex(1)
  else
    self.WS_Icon:SetActiveWidgetIndex(0)
  end
  if self.bIsListSelected then
    if self.Select then
      self:PlayAnimation(self.Select)
    end
  elseif self.bIsHovered then
    self:PlayAnimation(self.Hover)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
  self:UpdateSelectRhythmVisibility()
end

function WBP_Piano_MusicItem:OnPlayedMusicItemChanged(PlayTarget)
  if self.bIsDungeonDynamicTrack then
    if self:IsDungeonEventPlayTarget(PlayTarget) then
      self:TryPlayPianoBGM()
    else
      self:TryStopPianoBGM()
    end
    return
  end
  if type(PlayTarget) == "number" and PlayTarget > 0 and PlayTarget == self.MusicId then
    self:TryPlayPianoBGM()
  else
    self:TryStopPianoBGM()
  end
end

function WBP_Piano_MusicItem:TryPlayPianoBGM()
  if self.IsLocked then
    return
  end
  if self.ParentUI.ShouldAllowDungeonBgmPlayback and not self.ParentUI:ShouldAllowDungeonBgmPlayback() then
    self.IsPlaying = true
    self:StopPianoAudioOnly()
    self:RefreshItemVisualState()
    return
  end
  if self.IsPlaying and self.UpdateProgressTimer then
    return
  end
  self.IsPlaying = true
  self.EventInstance = AudioManager(self):GetPlayingFMODEventInstance(nil, "BGMKey_0")
  self:RefreshItemVisualState()
  if self.UpdateProgressTimer then
    self:RemoveTimer(self.UpdateProgressTimer)
    self.UpdateProgressTimer = nil
  end
  if self.bIsDungeonDynamicTrack then
    self:ApplyLoopingDungeonBgmTimeDisplay()
    return
  end
  self.UpdateProgressTimer = self:AddTimer(0.1, self.UpdateProgressBar, true, 0, "BGM", true)
end

function WBP_Piano_MusicItem:StopPianoAudioOnly()
  if self.UpdateProgressTimer then
    self:RemoveTimer(self.UpdateProgressTimer)
    self.UpdateProgressTimer = nil
  end
  self.EventInstance = nil
  self:ResetUnlockedTimeDisplay()
end

function WBP_Piano_MusicItem:TryStopPianoBGM()
  if self.IsLocked or not self.IsPlaying then
    return
  end
  self.IsPlaying = false
  self:RealStopPianoBGM()
end

function WBP_Piano_MusicItem:RealStopPianoBGM()
  if self.UpdateProgressTimer then
    self:RemoveTimer(self.UpdateProgressTimer)
    self.UpdateProgressTimer = nil
  end
  self.EventInstance = nil
  self:ResetUnlockedTimeDisplay()
  self:RefreshItemVisualState()
end

function WBP_Piano_MusicItem:UpdateProgressBar()
  if self:IsLoopingDungeonDefaultBgm() then
    return
  end
  if not (self.EventInstance and self.EventLength) or self.EventLength <= 0 then
    self:TryStopPianoBGM()
    return
  end
  local EventInstancePos = AudioManager(self):GetEventInstanceTimelinePosition(self.EventInstance)
  self.Bar_Time:SetPercent(EventInstancePos / self.EventLength)
  local EventPos_Second = math.floor(EventInstancePos / 1000)
  local Event_Minute = math.floor(EventPos_Second / 60)
  local Event_Second = EventPos_Second % 60
  local TotalTimeStr = string.format("%02d:%02d", Event_Minute, Event_Second)
  self.Text_Time:SetText(TotalTimeStr)
end

function WBP_Piano_MusicItem:IsStoredChapterBGMForCurrentScene()
  if not self.ParentUI:IsDungeonSceneMode() then
    return false
  end
  local StoredMusicId = self.ParentUI:GetChapterStoredMusicId()
  if self.bIsDungeonDynamicTrack then
    return 0 == StoredMusicId
  end
  return StoredMusicId > 0 and self.MusicId == StoredMusicId
end

function WBP_Piano_MusicItem:OnStoredChapterBGMChanged(ChapterId, MusicId)
  if not self.ParentUI:IsDungeonSceneMode() then
    return
  end
  local PianoSceneUtils = require("BluePrints.UI.WBP.Piano.PianoSceneUtils")
  if PianoSceneUtils.NormalizeChapterId(ChapterId) ~= PianoSceneUtils.NormalizeChapterId(self.ParentUI.CurrentScene) then
    return
  end
  if self:IsStoredChapterBGMForCurrentScene() then
    self:IsStoredBGMMusic()
  else
    self:IsNotStoredBGMMusic()
  end
end

function WBP_Piano_MusicItem:OnStoredCustomBGMChanged(NewMusicId)
  if self.ParentUI:IsDungeonSceneMode() then
    return
  end
  if NewMusicId == self.MusicId then
    self:IsStoredBGMMusic()
  else
    self:IsNotStoredBGMMusic()
  end
end

function WBP_Piano_MusicItem:IsStoredBGMMusic()
  if self.IsStoredCustomBGMMusicScore then
    return
  end
  self.IsStoredCustomBGMMusicScore = true
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function WBP_Piano_MusicItem:IsNotStoredBGMMusic()
  if not self.IsStoredCustomBGMMusicScore then
    return
  end
  self.IsStoredCustomBGMMusicScore = false
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return WBP_Piano_MusicItem
