require("UnLua")
require("DataMgr")
local PianoSceneUtils = require("BluePrints.UI.WBP.Piano.PianoSceneUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

local function IsSameSceneId(SceneIdA, SceneIdB)
  return PianoSceneUtils.IsSameSceneId(SceneIdA, SceneIdB)
end

local function GetSceneDisplayName(SceneId)
  if PianoSceneUtils.IsHomeSceneId(SceneId) then
    return PianoSceneUtils.GetHomeSceneDisplayName()
  end
  local NameKey = PianoSceneUtils.GetChapterDisplayNameKey(SceneId)
  if NameKey then
    return GText(NameKey)
  end
  return ""
end

function M:RefreshInfoTexts()
  if self.Text_Scene then
    self.Text_Scene:SetText(GetSceneDisplayName(self.Cur_SelectSceneId))
  end
  local PianoMain = self.PianoMain
  if not PianoMain then
    return
  end
  local PreviewSceneId = self.Cur_SelectSceneId
  if self.Text_Album then
    local MusicScoreId = PianoMain:GetPreviewMusicScoreIdForScene(PreviewSceneId)
    local NameKey = MusicScoreId and PianoMain:GetMusicScoreDisplayName(MusicScoreId)
    self.Text_Album:SetText(NameKey and GText(NameKey) or "")
  end
  if self.Text_Music then
    local NameKey = PianoMain:GetPreviewMusicDisplayNameKeyForScene(PreviewSceneId)
    self.Text_Music:SetText(NameKey and GText(NameKey) or "")
  end
end

function M:Destruct()
  self:UnbindCloseEvents()
  self:UnbindSceneListEvents()
  self.List_Scene:ClearListItems()
  self.Btn_Set:UnBindEventOnClicked(self, self.OnBtnSetClicked)
  self.IsClosing = nil
end

function M:BindSceneListEvents()
  if not self.List_Scene then
    return
  end
  if self.List_Scene.BP_OnItemClicked then
    self.List_Scene.BP_OnItemClicked:Clear()
    self.List_Scene.BP_OnItemClicked:Add(self, self.OnSceneListItemClicked)
  end
  if self.List_Scene.BP_OnItemSelectionChanged then
    self.List_Scene.BP_OnItemSelectionChanged:Clear()
    self.List_Scene.BP_OnItemSelectionChanged:Add(self, self.OnSceneListSelectionChanged)
  end
  if self.List_Scene.BP_OnItemIsHoveredChanged then
    self.List_Scene.BP_OnItemIsHoveredChanged:Clear()
    self.List_Scene.BP_OnItemIsHoveredChanged:Add(self, self.OnSceneItemIsHoveredChanged)
  end
end

function M:UnbindSceneListEvents()
  if not self.List_Scene then
    return
  end
  if self.List_Scene.BP_OnItemClicked then
    self.List_Scene.BP_OnItemClicked:Remove(self, self.OnSceneListItemClicked)
  end
  if self.List_Scene.BP_OnItemSelectionChanged then
    self.List_Scene.BP_OnItemSelectionChanged:Remove(self, self.OnSceneListSelectionChanged)
  end
  if self.List_Scene.BP_OnItemIsHoveredChanged then
    self.List_Scene.BP_OnItemIsHoveredChanged:Remove(self, self.OnSceneItemIsHoveredChanged)
  end
end

function M:GetSceneEntryWidget(Item)
  if not Item or not self.List_Scene then
    return nil
  end
  local ItemIndex = Item.Index
  if nil == ItemIndex then
    ItemIndex = self.List_Scene:GetIndexForItem(Item)
  end
  if not ItemIndex or ItemIndex < 0 then
    return nil
  end
  return URuntimeCommonFunctionLibrary.GetEntryWidgetFromItem(self.List_Scene, ItemIndex)
end

function M:OnSceneItemIsHoveredChanged(Item, bIsHovered)
  if self:IsGamepadInput() or not Item then
    return
  end
  if bIsHovered then
    self.Cur_SceneHoverIndex = Item.Index
  elseif self.Cur_SceneHoverIndex == Item.Index then
    self.Cur_SceneHoverIndex = nil
  end
  local EntryWidget = self:GetSceneEntryWidget(Item)
  if not EntryWidget then
    return
  end
  if bIsHovered then
    if EntryWidget.OnItemHovered then
      EntryWidget:OnItemHovered()
    end
  elseif EntryWidget.OnItemUnHovered then
    EntryWidget:OnItemUnHovered()
  end
end

function M:PlaySceneItemForbiddenFeedback(Item)
  if not Item or not self.List_Scene then
    return
  end
  local EntryWidget = self:GetSceneEntryWidget(Item)
  if EntryWidget and EntryWidget.PlayForbiddenFeedback then
    EntryWidget:PlayForbiddenFeedback()
  end
end

function M:OnSceneListItemClicked(Item)
  if not Item then
    return
  end
  local EntryWidget = self:GetSceneEntryWidget(Item)
  if EntryWidget and EntryWidget.OnItemPressed then
    EntryWidget:OnItemPressed()
  end
  if Item.bIsLocked then
    self:PlaySceneItemForbiddenFeedback(Item)
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Locked_Des_CurrentComission"), 5)
    return
  end
  self:OnSceneItemSelected(Item.SceneId)
  if self:IsGamepadInput() then
    self:TryConfirmSceneSwitch()
  end
end

function M:OnSceneListSelectionChanged(Item, bIsSelected)
  if not bIsSelected or not Item then
    return
  end
  if not self:IsGamepadInput() then
    return
  end
  if Item.bIsLocked then
    self:RefreshSidebarBottomKeys()
    return
  end
  self:OnSceneItemSelected(Item.SceneId)
end

function M:BindSceneListGamepadNavigation()
  if not self.List_Scene then
    return
  end
  self.List_Scene:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
end

function M:BindCloseEvents()
  if not self.Btn_Close then
    return
  end
  if self.Btn_Close.Btn_Close and self.Btn_Close.Btn_Close.OnClicked then
    self.Btn_Close.Btn_Close.OnClicked:Add(self, self.OnBtnCloseClicked)
  elseif self.Btn_Close.OnClicked then
    self.Btn_Close.OnClicked:Add(self, self.OnBtnCloseClicked)
  end
end

function M:UnbindCloseEvents()
  if not self.Btn_Close then
    return
  end
  if self.Btn_Close.Btn_Close and self.Btn_Close.Btn_Close.OnClicked then
    self.Btn_Close.Btn_Close.OnClicked:Remove(self, self.OnBtnCloseClicked)
  elseif self.Btn_Close.OnClicked then
    self.Btn_Close.OnClicked:Remove(self, self.OnBtnCloseClicked)
  end
end

function M:OnBtnCloseClicked()
  self:RequestClose()
end

function M:RequestClose()
  if self.IsClosing then
    return
  end
  if self.Out then
    self.IsClosing = true
    self:BindToAnimationFinished(self.Out, {
      self,
      self.FinishClose
    })
    self:PlayAnimation(self.Out)
  else
    self:FinishClose()
  end
end

function M:FinishClose()
  if self.PianoMain and self.PianoMain.CloseSwitchScenePanel then
    self.PianoMain:CloseSwitchScenePanel()
  elseif IsValid(self) then
    self:RemoveFromParent()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Escape" == InKeyName or InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:RequestClose()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and self:HandleGamepadKeyDown(InKeyName) then
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:Init(SavedSceneId, OpenContextSceneId)
  self.CurrentSceneId = PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(SavedSceneId)
  self.OpenContextSceneId = PianoSceneUtils.ResolveCanonicalPianoSceneChapterId(OpenContextSceneId)
  self.Cur_SelectSceneId = self.OpenContextSceneId or self.CurrentSceneId
  self.Cur_SceneHoverIndex = nil
  self.IsClosing = false
  self:BindCloseEvents()
  self:BindSceneListGamepadNavigation()
  self:InitList()
  self:BindSceneListEvents()
  self.Btn_Set:BindEventOnClicked(self, self.OnBtnSetClicked)
  self:RefreshBtnState()
  self:RefreshInfoTexts()
  EventManager:FireEvent(EventID.ChangePianoSelectScene, self.Cur_SelectSceneId)
  if self.In then
    self:PlayAnimation(self.In)
  end
  self:InitGamepadAfterOpen()
end

function M:InitList()
  self.List_Scene:ClearListItems()
  local SceneIndex = 0
  local HomeData = NewObject(UE4.LoadClass(UIConst.PianoSceneData))
  HomeData.Owner = self
  HomeData.SceneId = 0
  HomeData.bIsDungeon = false
  HomeData.bIsLocked = false
  HomeData.ThumbPath = PianoSceneUtils.HOME_SCENE_ICON
  HomeData.Index = SceneIndex
  self.List_Scene:AddItem(HomeData)
  SceneIndex = SceneIndex + 1
  for _, ChapterInfo in ipairs(PianoSceneUtils.CollectPianoSceneChapters()) do
    local Data = NewObject(UE4.LoadClass(UIConst.PianoSceneData))
    Data.Owner = self
    Data.SceneId = ChapterInfo.ChapterId
    Data.bIsDungeon = true
    Data.ThumbPath = PianoSceneUtils.GetChapterThumbPath(ChapterInfo.ChapterId)
    Data.bIsLocked = not PianoSceneUtils.IsPianoSceneChapterGroupUnlocked(ChapterInfo)
    Data.Index = SceneIndex
    self.List_Scene:AddItem(Data)
    SceneIndex = SceneIndex + 1
  end
end

function M:OnSceneItemSelected(SceneId)
  self.Cur_SelectSceneId = PianoSceneUtils.NormalizeChapterId(SceneId)
  EventManager:FireEvent(EventID.ChangePianoSelectScene, self.Cur_SelectSceneId)
  self:RefreshBtnState()
  self:RefreshInfoTexts()
  self:RefreshSidebarBottomKeys()
end

function M:GetSceneSwitchBtnTextKey()
  if IsSameSceneId(self.Cur_SelectSceneId, self.CurrentSceneId) then
    return "UI_ChangeBGM_Using"
  end
  return "UI_ChangeBGM_Change"
end

function M:RefreshBtnState()
  local bIsCurrentScene = IsSameSceneId(self.Cur_SelectSceneId, self.CurrentSceneId)
  self.Btn_Set:ForbidBtn(bIsCurrentScene)
  if self.Btn_Set and self.Btn_Set.SetText then
    self.Btn_Set:SetText(GText(self:GetSceneSwitchBtnTextKey()))
  end
end

function M:ApplySceneSwitchAndClose()
  if IsSameSceneId(self.Cur_SelectSceneId, self.CurrentSceneId) then
    return false
  end
  self.CurrentSceneId = self.Cur_SelectSceneId
  if self.PianoMain then
    self.PianoMain:OnPianoSceneChanged(self.Cur_SelectSceneId)
  end
  self:RequestClose()
  return true
end

function M:OnBtnSetClicked()
  self:ApplySceneSwitchAndClose()
end

function M:IsGamepadInput()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:GetSceneListFocusIndex()
  local TargetId = self.Cur_SelectSceneId
  local ItemCount = self.List_Scene:GetNumItems()
  for i = 0, ItemCount - 1 do
    local Item = self.List_Scene:GetItemAt(i)
    if Item and IsSameSceneId(Item.SceneId, TargetId) then
      return Item.Index or i
    end
  end
  return 0
end

function M:FocusGamepadSceneList()
  if not self.List_Scene then
    return
  end
  local TargetIndex = self:GetSceneListFocusIndex()
  self.List_Scene:NavigateToIndex(TargetIndex)
  if self.PianoMain and self.PianoMain.SetListViewEntryFocus then
    self.PianoMain:SetListViewEntryFocus(self.List_Scene, TargetIndex)
  elseif self.List_Scene.SetFocus then
    self.List_Scene:SetFocus()
  end
end

function M:InitGamepadAfterOpen()
  if not self:IsGamepadInput() then
    return
  end
  self:RefreshSidebarBottomKeys()
  
  local function RefreshFocus()
    if not self.IsClosing and IsValid(self) then
      self:FocusGamepadSceneList()
    end
  end
  
  local TimerOwner = self.PianoMain
  if TimerOwner and TimerOwner.AddTimer then
    TimerOwner:AddTimer(0.05, RefreshFocus)
  else
    RefreshFocus()
  end
end

function M:GetFocusedSceneItem()
  if not self.List_Scene then
    return nil
  end
  if self.List_Scene.BP_GetSelectedItem then
    return self.List_Scene:BP_GetSelectedItem()
  end
  if self.List_Scene.GetSelectedItem then
    return self.List_Scene:GetSelectedItem()
  end
  return nil
end

function M:TryOpenSelectedDungeonDetail()
  local Item = self:GetFocusedSceneItem()
  if not (Item and Item.bIsDungeon) or Item.bIsLocked then
    return false
  end
  local ChapterId = PianoSceneUtils.NormalizeChapterId(Item.SceneId)
  if not ChapterId or not PianoSceneUtils.IsChapterAvailableInPianoScene(ChapterId) then
    return false
  end
  local NameKey, DescKey, RewardViewId = PianoSceneUtils.GetChapterDetailInfo(ChapterId)
  UIManager(self):LoadUINew("ItemInformation", {
    Name = NameKey,
    Desc = DescKey,
    RewardViewId = RewardViewId
  }, "LevelDatail", self)
  return true
end

function M:TryConfirmSceneSwitch()
  return self:ApplySceneSwitchAndClose()
end

function M:HandleGamepadKeyDown(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:TryConfirmSceneSwitch()
    return true
  end
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    self:TryOpenSelectedDungeonDetail()
    return true
  end
  return false
end

function M:BuildGamepadBottomKeyInfo()
  local BottomKeyInfo = {}
  BottomKeyInfo[#BottomKeyInfo + 1] = {
    GamePadInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("HomePiano_GoBack")
  }
  return BottomKeyInfo
end

function M:RefreshSidebarBottomKeys()
  if self.PianoMain and self.PianoMain.RefreshGamepadBottomKeys then
    self.PianoMain:RefreshGamepadBottomKeys()
  end
end

return M
