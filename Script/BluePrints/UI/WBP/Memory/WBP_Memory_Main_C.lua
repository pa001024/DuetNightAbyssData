local M = Class({
  "BluePrints.UI.BP_UIState_C"
})
local RestoreBlackScreenHandle = "MemoryMainRestoreAnimeRoom"

function M:Construct()
  if M.Super.Construct then
    M.Super.Construct(self)
  end
  self.ItemAddInterval = 0.1
  self.Toolbar = self.Com_Tab
  self.ChapterList = self.List_Chapter
  self.FadeInAnimation = self.In
  self.FadeOutAnimation = self.Out
  self.OpenAnimeRoomAnimation = self.Enter
  
  local function BackCallback()
    self:MyClose(true)
  end
  
  self.Toolbar:Init({
    OwnerPanel = self,
    TitleName = GText("MAIN_UI_MEMORY"),
    DynamicNode = {"Back", "BottomKey"},
    BackCallback = BackCallback,
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            ClickCallback = BackCallback,
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = BackCallback,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = BackCallback,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    }
  })
  self.Toolbar:BindEventOnTabSelected(self, self.HandleTabSelected)
  self.ChapterList.BP_OnItemClicked:Add(self, self.HandleChapterSelected)
  self.ChapterList.BP_OnItemIsHoveredChanged:Add(self, self.HandleChapterHoveredChanged)
  self.ChapterList.BP_OnEntryGenerated:Add(self, self.HandleChapterEntryGenerated)
  self:BindToAnimationFinished(self.FadeOutAnimation, {
    self,
    self.Close
  })
  local Tabs = self:GenerateTabs()
  self.Toolbar:UpdateTabs(Tabs)
  self:InitTabReddot()
  self.ChapterList:SetFocus()
end

function M:Destruct()
  self.ChapterList.BP_OnItemClicked:Remove(self, self.HandleChapterSelected)
  self.ChapterList.BP_OnItemIsHoveredChanged:Remove(self, self.HandleChapterHoveredChanged)
  self.ChapterList.BP_OnEntryGenerated:Remove(self, self.HandleChapterEntryGenerated)
  self.ChapterList:ClearListItems()
  self:ClearChapterLoadTimer()
  self:ClearRestoreData()
  if M.Super.Destruct then
    M.Super.Destruct(self)
  end
end

function M:OnLoaded(...)
  if M.Super.OnLoaded then
    M.Super.OnLoaded(self, ...)
  end
  self:PlayAnimation(self.FadeInAnimation)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", self:GetName(), nil)
  local ChapterId, CinematicId = ...
  if ChapterId and CinematicId then
    for TabIdx, Tab in pairs(self.Toolbar.Tabs) do
      for _, Chapter in ipairs(Tab.Chapters) do
        if Chapter.Id == ChapterId then
          self.RestoreChapterId = ChapterId
          self.RestoreCinematicId = CinematicId
          UIManager(self):ShowCommonBlackScreen({BlackScreenHandle = RestoreBlackScreenHandle})
          self.Toolbar:SelectTab(TabIdx)
          return
        end
      end
    end
  end
  self:ClearRestoreData()
  self.Toolbar:SelectTab(1)
end

function M:OnEndClose()
  if M.Super.OnEndClose then
    M.Super.OnEndClose(self)
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local Key = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local KeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(Key)
  local bHandled = false
  if KeyName == UE4.EKeys.Q.KeyName or KeyName == UIConst.GamePadKey.LeftShoulder then
    bHandled = true
    self.Toolbar:TabToLeft()
  elseif KeyName == UE4.EKeys.E.KeyName or KeyName == UIConst.GamePadKey.RightShoulder then
    bHandled = true
    self.Toolbar:TabToRight()
  elseif KeyName == UE4.EKeys.Escape.KeyName or KeyName == UIConst.GamePadKey.FaceButtonRight then
    bHandled = true
    self:MyClose(true)
  end
  if bHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if M.Super.OnUpdateUIStyleByInputTypeChange then
    M.Super.OnUpdateUIStyleByInputTypeChange(self, CurInputType, CurGamepadName)
  end
  if CurInputType == ECommonInputType.Gamepad and self.ChapterList:GetNumItems() > 0 then
    local TargetIndex = self:GetCurrentChapterIndex()
    self.ChapterList:NavigateToIndex(TargetIndex)
    self.ChapterList:SetFocus()
  end
end

function M:MyClose(bFadeOut)
  if bFadeOut and self:IsAnimationPlaying(self.FadeOutAnimation) then
    return
  end
  AudioManager(self):SetEventSoundParam(self, self:GetName(), {ToEnd = 1})
  if bFadeOut then
    self:PlayAnimation(self.FadeOutAnimation)
  else
    self:Close()
  end
end

function M:GenerateTabs()
  local Tabs = {}
  for _, TabData in pairs(DataMgr.QuestTab) do
    local Tab = {
      TabId = TabData.TabId,
      Text = GText(TabData.TabName),
      IconPath = TabData.Icon,
      Chapters = {}
    }
    Tabs[TabData.QuestType] = Tab
  end
  for _, ChapterData in pairs(DataMgr.CinematicChapter) do
    local Chapter = {
      Id = ChapterData.ChapterId,
      Name = GText(ChapterData.ChapterName),
      Number = GText(ChapterData.ChapterNumber),
      ConditionId = ChapterData.ConditionId,
      IconPath = ChapterData.ChapterIconPath,
      PicPath = ChapterData.ChapterPicPath,
      CinematicIds = ChapterData.CinematicId,
      Priority = ChapterData.SortPriority
    }
    local Tab = Tabs[ChapterData.ChapterType]
    if Tab then
      table.insert(Tab.Chapters, Chapter)
    end
  end
  local FilteredTabs = {}
  for _, Tab in pairs(Tabs) do
    if #Tab.Chapters > 0 then
      table.insert(FilteredTabs, Tab)
    end
  end
  Tabs = FilteredTabs
  for _, Tab in pairs(Tabs) do
    table.sort(Tab.Chapters, function(a, b)
      return a.Priority < b.Priority
    end)
  end
  return Tabs
end

function M:HandleTabSelected(TabWidget)
  self:ClearChapterLoadTimer()
  self.ChapterList:ClearListItems()
  local Tab = TabWidget.Info
  if not Tab then
    self:ClearRestoreData()
    DebugPrint("Memory main handle tab selected failed, invalid tab")
    return
  end
  local Chapters = Tab.Chapters
  if not Chapters then
    self:ClearRestoreData()
    DebugPrint("Memory main handle tab selected failed, invalid chapters")
    return
  end
  local ValidChapters = {}
  for _, Chapter in ipairs(Chapters) do
    if not Chapter.ConditionId or ConditionUtils.CheckCondition(GWorld:GetAvatar(), Chapter.ConditionId) then
      table.insert(ValidChapters, Chapter)
    end
  end
  if 0 == #ValidChapters then
    self:ClearRestoreData()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    self.ChapterList:AddItem(Content)
    return
  end
  if self.RestoreChapterId and self.RestoreCinematicId then
    local bHasRestoreChapter = false
    for _, Chapter in ipairs(ValidChapters) do
      if Chapter.Id == self.RestoreChapterId then
        bHasRestoreChapter = true
        break
      end
    end
    if not bHasRestoreChapter then
      self:ClearRestoreData()
    end
  end
  if self.RestoreChapterId and self.RestoreCinematicId then
    for Index, Chapter in ipairs(ValidChapters) do
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = Chapter.Id
      Content.Index = Index - 1
      Content.Name = Chapter.Name
      Content.Number = Chapter.Number
      Content.IconPath = Chapter.IconPath
      Content.PicPath = Chapter.PicPath
      Content.bSkipBlendIn = false
      Content.bIsNew = self:CheckIsNew(Chapter.Id)
      self.ChapterList:AddItem(Content)
    end
    local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
    self.ChapterList:AddItem(Placeholder)
    return
  end
  local Index = 1
  
  local function IntervalAddItem()
    if Index > #ValidChapters then
      self:ClearChapterLoadTimer()
      local Placeholder = NewObject(UIUtils.GetCommonItemContentClass())
      self.ChapterList:AddItem(Placeholder)
    else
      local Chapter = ValidChapters[Index]
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Id = Chapter.Id
      Content.Index = Index - 1
      Content.Name = Chapter.Name
      Content.Number = Chapter.Number
      Content.IconPath = Chapter.IconPath
      Content.PicPath = Chapter.PicPath
      Content.bSkipBlendIn = false
      Content.bIsNew = self:CheckIsNew(Chapter.Id)
      self.ChapterList:AddItem(Content)
      AudioManager(self):PlayUISound(self, "event:/ui/common/cine_review_chapter_icon_in", self:GetName(), nil)
    end
    Index = Index + 1
  end
  
  self.ChapterLoadTimer = self:AddTimer(self.ItemAddInterval, IntervalAddItem, true)
  IntervalAddItem()
end

function M:HandleChapterEntryGenerated(Widget)
  if not self.RestoreChapterId or not self.RestoreCinematicId then
    return
  end
  local RestoreChapterId = self.RestoreChapterId
  local RestoreCinematicId = self.RestoreCinematicId
  for Index = 0, self.ChapterList:GetNumItems() - 1 do
    local Content = self.ChapterList:GetItemAt(Index)
    if Content and Content.Id == RestoreChapterId then
      self.ChapterList:SetScrollOffset(Index)
      self.ChapterList:NavigateToIndex(Index)
      self.ChapterList:SetSelectedIndex(Index)
      self:ClearRestoreData()
      self:OpenAnimeRoom(RestoreChapterId, RestoreCinematicId)
      break
    end
  end
end

function M:HandleChapterHoveredChanged(Content, bIsHovered)
  if not (bIsHovered and Content) or not Content.Id then
    return
  end
  self.ChapterList:BP_SetSelectedItem(Content)
end

function M:HandleChapterSelected(Content)
  if not Content or not Content.Id then
    DebugPrint("Memory main handle chapter selected failed, invalid content")
    return
  end
  self:OpenAnimeRoom(Content.Id, nil)
end

function M:OpenAnimeRoom(ChapterId, CinematicId)
  self:PlayAnimation(self.OpenAnimeRoomAnimation)
  UIManager(self):LoadUINew("MemoryAnimeRoom", ChapterId, CinematicId, function(ConfirmCinematicId)
    if ConfirmCinematicId then
      local MenuWorld = UIManager(self):GetUI("MenuWorld")
      if IsValid(MenuWorld) then
        MenuWorld.CloseByChild = true
        MenuWorld:RealClose()
      end
      self:MyClose(false)
    else
      local ChapterIndex = self:GetCurrentChapterIndex()
      self.ChapterList:NavigateToIndex(ChapterIndex)
      self.ChapterList:SetFocus()
    end
  end)
  self:TryRemoveCutSceneReviewReddot(ChapterId)
end

function M:GetCurrentChapterIndex()
  local MaxIndex = self.ChapterList:GetNumItems() - 1
  if MaxIndex < 0 then
    return 0
  end
  local Content = self.ChapterList:BP_GetSelectedItem()
  if Content and Content.Index ~= nil then
    return math.clamp(Content.Index, 0, MaxIndex)
  end
  return math.clamp(math.floor(self.ChapterList:GetScrollOffset()), 0, MaxIndex)
end

function M:ClearRestoreData()
  if self.RestoreChapterId and self.RestoreCinematicId then
    UIManager(self):HideCommonBlackScreen(RestoreBlackScreenHandle)
  end
  self.RestoreChapterId = nil
  self.RestoreCinematicId = nil
end

function M:ClearChapterLoadTimer()
  self:RemoveTimer(self.ChapterLoadTimer)
  self.ChapterLoadTimer = nil
end

function M:InitTabReddot()
  if self.Toolbar.Tabs and #self.Toolbar.Tabs >= 1 then
    self.Index2ReddotNum = {}
    if not ReddotManager.GetTreeNode("CutSceneReview") then
      ReddotManager.AddNodeEx("CutSceneReview")
    end
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("CutSceneReview")
    for Index, TabInfo in pairs(self.Toolbar.Tabs) do
      self.Index2ReddotNum[Index] = 0
      if TabInfo.Chapters then
        local Chapters = TabInfo.Chapters
        for _, Info in pairs(Chapters) do
          if 1 == CacheDetail[Info.Id] then
            self.Index2ReddotNum[Index] = self.Index2ReddotNum[Index] + 1
          end
        end
      end
    end
  end
  self:RefreshTabReddot()
end

function M:TryRemoveCutSceneReviewReddot(ChapterId)
  if not ReddotManager.GetTreeNode("CutSceneReview") then
    ReddotManager.AddNodeEx("CutSceneReview")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("CutSceneReview")
  if 1 == CacheDetail[ChapterId] then
    CacheDetail[ChapterId] = 0
    self:RefreshItemReddot(ChapterId, false)
    ReddotManager.DecreaseLeafNodeCount("CutSceneReview")
    if self.Toolbar.CurrentTab and self.Index2ReddotNum and self.Index2ReddotNum[self.Toolbar.CurrentTab] then
      local Num = self.Index2ReddotNum[self.Toolbar.CurrentTab] - 1
      if Num < 0 then
        Num = 0
      end
      self.Index2ReddotNum[self.Toolbar.CurrentTab] = Num
      self:RefreshTabReddot()
    end
  end
end

function M:RefreshTabReddot()
  if self.Toolbar.Tabs and #self.Toolbar.Tabs >= 1 then
    for Index, TabWidget in pairs(self.Toolbar.Tabs) do
      if self.Index2ReddotNum and self.Index2ReddotNum[Index] and self.Index2ReddotNum[Index] > 0 then
        self.Toolbar:ShowTabRedDot(Index, true)
      else
        self.Toolbar:ShowTabRedDot(Index, false)
      end
    end
  end
end

function M:RefreshItemReddot(ChapterId, bIsNew)
  for _, Content in pairs(self.List_Chapter:GetListItems()) do
    if Content.Id == ChapterId then
      Content.bIsNew = bIsNew
      if IsValid(Content.Entry) then
        Content.Entry:SetNew(Content.bIsNew)
      end
    end
  end
end

function M:CheckIsNew(ChapterId)
  if not ReddotManager.GetTreeNode("CutSceneReview") then
    ReddotManager.AddNodeEx("CutSceneReview")
  end
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("CutSceneReview")
  if 1 == CacheDetail[ChapterId] then
    return true
  else
    return false
  end
end

return M
