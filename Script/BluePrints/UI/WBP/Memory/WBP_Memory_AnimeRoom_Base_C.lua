require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local ConfirmPopupId = 100381

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  local ChapterId, ResumeCinematicId, OnClosedCallback, OnInFinishCallback = ...
  self.ChapterId = ChapterId
  self.DefaultCinematicId = ResumeCinematicId
  self.OnClosedCallback = OnClosedCallback
  self.OnInFinishCallback = OnInFinishCallback
  self.CinematicIdList = {}
  self.FocusedIndex = nil
  self.AnimeScale = 1
  self.IsClosing = false
  self.IsClosedNotified = false
  self.ReviewDialog = nil
  self:InitTable()
  self:InitAnimList()
  self:InitMemorySlider()
  self:UnbindAllFromAnimationFinished(self.Out)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnClose
  })
  self:UnbindAllFromAnimationFinished(self.In)
  self:BindToAnimationFinished(self.In, {
    self,
    self.OnInAnimationFinished
  })
  if not ResumeCinematicId then
    AudioManager(self):PlayUISound(self, "event:/ui/common/cine_review_sub_page_in", nil, nil)
    self:PlayAnimation(self.In)
  else
    self:PlayAnimation(self.In, self.In:GetEndTime())
  end
end

function M:OnInAnimationFinished()
  if type(self.OnInFinishCallback) == "function" then
    self.OnInFinishCallback()
  end
  self:UnbindAllFromAnimationFinished(self.In)
end

function M:InitTable()
  local CurrChapterConfig = DataMgr.CinematicChapter[self.ChapterId]
  local ChapterType, QuestTypeData
  if CurrChapterConfig then
    ChapterType = CurrChapterConfig.ChapterType
    QuestTypeData = DataMgr.QuestTab[ChapterType]
  else
    DebugPrint(ErrorTag, "WBP_Memory_AnimeRoom_Base_C @InitTable: CinematicChapter不存在, ChapterId: ", self.ChapterId)
  end
  self.Com_Tab:Init({
    TitleName = GText(QuestTypeData and QuestTypeData.TabName),
    OwnerPanel = self,
    DynamicNode = {"Back", "BottomKey"},
    BackCallback = self.OnClickClose,
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Escape",
            ClickCallback = self.OnClickClose,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.OnClickClose,
            Owner = self
          }
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  })
end

function M:InitAnimList()
  self:RefreshChapterInfo()
  self:RefreshAnimeList()
  self:SelectDefaultAnime()
end

function M:InitMemorySlider()
  self.Memory_Slider:Init({
    InitValue = 50,
    MinValue = 5,
    MaxValue = 85,
    OwnerPanel = self,
    AddBtnCallback = self.OnMemorySliderChanged,
    MinusBtnCallback = self.OnMemorySliderChanged,
    SliderChangeCallback = self.OnMemorySliderChanged,
    ForbidGamePadRSKey = true,
    SoundResPath = {
      Slider = "event:/ui/common/slider_value_change",
      Add = "event:/ui/common/slider_value_change",
      Minus = "event:/ui/common/slider_value_change"
    }
  })
  rawset(self.Memory_Slider, "GamePadMinKeyPath", "LT")
  rawset(self.Memory_Slider, "GamePadAddKeyPath", "RT")
  self:OnMemorySliderChanged(50)
end

function M:OnMemorySliderChanged(Value)
  self.AnimeScale = 0.6 + Value / 100 * 0.8
  self:ApplyAnimeScale()
end

function M:ApplyAnimeScale()
  local Scale = FVector2D(self.AnimeScale, self.AnimeScale)
  local DisplayedEntryWidgets = self.List_Anime:GetDisplayedEntryWidgets()
  for _, ItemWidget in pairs(DisplayedEntryWidgets) do
    if ItemWidget then
      ItemWidget:SetRenderScale(Scale)
    end
  end
end

function M:RefreshChapterInfo()
  if not self.ChapterId then
    return
  end
  local ChapterConfig = DataMgr.CinematicChapter[self.ChapterId]
  if not ChapterConfig then
    return
  end
  local DynamicMaterial = self.Icon_Chapter:GetDynamicMaterial()
  if IsValid(DynamicMaterial) then
    DynamicMaterial:SetTextureParameterValue("MainTex", LoadObject(ChapterConfig.ChapterIconPath or ""))
  end
  self.Text_Chapter:SetText(GText(ChapterConfig.ChapterNumber or ""))
  self.Name_Chapter:SetText(GText(ChapterConfig.ChapterName or ""))
end

function M:RefreshAnimeList()
  self.List_Anime:ClearListItems()
  self.CinematicIdList = {}
  if not self.ChapterId then
    DebugPrint(ErrorTag, "WBP_Memory_AnimeRoom_Base_C @RefreshAnimeList: ChapterId不存在")
    return
  end
  local ChapterConfig = DataMgr.CinematicChapter[self.ChapterId]
  if not ChapterConfig then
    DebugPrint(ErrorTag, "WBP_Memory_AnimeRoom_Base_C @RefreshAnimeList: CinematicChapter不存在, ChapterId: ", self.ChapterId)
    return
  end
  local IdList = ChapterConfig.CinematicId or {}
  for Index, CinematicId in ipairs(IdList) do
    table.insert(self.CinematicIdList, CinematicId)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.CinematicId = CinematicId
    Content.ChapterId = self.ChapterId
    Content.Index = Index
    Content.LastIndex = #IdList
    
    function Content.GetAnimeScale()
      return self.AnimeScale
    end
    
    function Content.OnClicked(ConfirmCinematicId)
      self:OpenConfirmDialog(ConfirmCinematicId)
    end
    
    self.List_Anime:AddItem(Content)
  end
end

function M:SelectDefaultAnime()
  if 0 == #self.CinematicIdList then
    self.FocusedIndex = nil
    return
  end
  if self.DefaultCinematicId then
    for Index, CinematicId in ipairs(self.CinematicIdList) do
      if CinematicId == self.DefaultCinematicId then
        self.FocusedIndex = Index
        self.DefaultCinematicId = nil
        return
      end
    end
  end
  self.DefaultCinematicId = nil
  self.FocusedIndex = 1
end

function M:OpenConfirmDialog(CinematicId)
  if IsValid(self.ReviewDialog) then
    self.ReviewDialog:Close()
    self.ReviewDialog = nil
  end
  local CommonDialogParams = {}
  
  function CommonDialogParams.RightCallbackFunction()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local ConfirmCinematicId = CinematicId
    Avatar:StartCutSceneReview(self.ChapterId, ConfirmCinematicId, function()
      self.ConfirmCinematicId = ConfirmCinematicId
      self:OnClose()
      self.ConfirmCinematicId = nil
    end)
  end
  
  function CommonDialogParams.LeftCallbackFunction()
    self.ReviewDialog = nil
    self:SetFocus()
  end
  
  function CommonDialogParams.OnCloseCallbackFunction()
    self.ReviewDialog = nil
  end
  
  self.ReviewDialog = UIManager(self):ShowCommonPopupUI(ConfirmPopupId, CommonDialogParams, self)
end

function M:OnClickClose()
  if self.IsClosing then
    return
  end
  self.IsClosing = true
  self:PlayAnimation(self.Out)
end

function M:NotifyClosed()
  if self.IsClosedNotified then
    return
  end
  self.IsClosedNotified = true
  if type(self.OnClosedCallback) == "function" then
    self.OnClosedCallback(self.ConfirmCinematicId)
  end
end

function M:OnClose()
  self.List_Anime:ClearListItems()
  self:UnbindAllFromAnimationFinished(self.Out)
  self:Close()
  self:NotifyClosed()
  self.IsClosing = false
end

return M
