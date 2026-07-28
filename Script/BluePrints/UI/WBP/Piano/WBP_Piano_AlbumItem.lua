require("UnLua")
require("DataMgr")
local WBP_Piano_AlbumItem = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})
local ALBUM_COVER_TEXTURE_PARAM = "IconMap"

local function SetAlbumCoverImage(Img, PicPath)
  if not PicPath or not Img then
    return
  end
  local Texture = LoadObject(PicPath)
  if not IsValid(Texture) then
    return
  end
  local DMI = Img.GetDynamicMaterial and Img:GetDynamicMaterial() or nil
  if not IsValid(DMI) then
    return
  end
  DMI:SetTextureParameterValue(ALBUM_COVER_TEXTURE_PARAM, Texture)
end

function WBP_Piano_AlbumItem:ApplyLockedVisualInstant()
  self:StopAllAnimations()
  if self.Btn_Album then
    self.Btn_Album:SetForbidden(true)
  end
  if self.Forbidden and self.Forbidden.GetEndTime then
    self:PlayAnimation(self.Forbidden, self.Forbidden:GetEndTime())
  elseif self.Forbidden then
    self:PlayAnimation(self.Forbidden)
  end
end

function WBP_Piano_AlbumItem:ApplyUnlockedVisualInstant()
  self:StopAllAnimations()
  if self.Btn_Album then
    self.Btn_Album:SetForbidden(false)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal, 0)
  end
end

function WBP_Piano_AlbumItem:BP_OnEntryReleased()
  self.DataObject = nil
  self.IsSelected = false
  self.bIsHovered = false
  self.bCanPlayAnimation = true
  if self.Panel_Lock then
    self.Panel_Lock:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshItemVisualState()
end

function WBP_Piano_AlbumItem:Destruct()
  self.Btn_Album.OnClicked:Remove(self, self.OnBtnClicked)
  self.Btn_Album.OnHovered:Remove(self, self.OnBtnHovered)
  self.Btn_Album.OnUnHovered:Remove(self, self.OnBtnUnHovered)
  self:UnBindInputMethodChangedDelegate()
  self:ClearScriptRegister()
end

function WBP_Piano_AlbumItem:OnListItemObjectSet(ListItemObject)
  self.DataObject = ListItemObject
  self.ParentUI = ListItemObject.Owner
  self.MusicScoreId = ListItemObject.MusicScoreId
  self.IsLocked = ListItemObject.bIsLocked
  self.ListViewIndex = ListItemObject.Index
  self.ReddotNum = ListItemObject.ReddotNum
  self.IsSelected = false
  self.bIsHovered = false
  self.IsStoredCustomBGMMusicScore = false
  self.bCanPlayAnimation = true
  self.IsEmptyMusicScore = ListItemObject.bIsEmptyMusicScore
  self.CurIsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if self.IsEmptyMusicScore then
    if self.Main then
      self.Main:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    return
  end
  if self.Main then
    self.Main:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.ParentUI.Cur_AlbumHoverIndex == self.ListViewIndex then
    self.bIsHovered = true
  end
  self:InitUI()
  self:AddDispatcher(EventID.ChangeSelectMusicScore, self, self.OnSelectMusicScoreChanged)
  self:AddDispatcher(EventID.ChangeHoverAlbumItem, self, self.OnHoverAlbumItemChanged)
  self:AddDispatcher(EventID.ChangeStoredCustomBGM, self, self.OnStoredCustomBGMChanged)
  self:AddDispatcher(EventID.ChangeStoredChapterBGM, self, self.OnStoredChapterBGMChanged)
  self:AddDispatcher(EventID.ChangeMusicItemNewState, self, self.OnMusicItemNewStateChange)
  self:BindInputMethodChangedDelegate()
  self.bIsOnListItemSet = true
  if self.ParentUI:IsDungeonSceneMode() then
    if self:IsStoredChapterBGMScore() then
      self:IsStoredBGMMusicScore()
    end
  elseif not ListItemObject.bIsDungeonAlbum and self.MusicScoreId == DataMgr.Music[self.ParentUI.CurrentHomeBaseBGM].MusicScoreId then
    if self.ParentUI.IsFirstOpen then
      self:OnBtnHovered()
      self:OnBtnClicked()
      self.ParentUI.IsFirstOpen = false
    end
    self:IsStoredBGMMusicScore()
  end
  if self.ParentUI.CurrentSelectMusicScore == self.MusicScoreId then
    self:Selected()
  else
    self:RefreshItemVisualState()
  end
  self.bIsOnListItemSet = false
end

function WBP_Piano_AlbumItem:OnMusicItemNewStateChange(MusicId)
  if self.DataObject and self.DataObject.bIsDungeonAlbum then
    return
  end
  if DataMgr.Music[MusicId].MusicScoreId == self.MusicScoreId then
    self.ReddotNum = self.ReddotNum - 1
    if self.ReddotNum <= 0 then
      self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
  end
end

function WBP_Piano_AlbumItem:GetMusicScoreDisplayName()
  local NameKey = self.DataObject and self.DataObject.MusicScoreName
  if NameKey then
    return NameKey
  end
  if self.MusicScoreId and DataMgr.MusicScore[self.MusicScoreId] then
    return DataMgr.MusicScore[self.MusicScoreId].MusicScoreName
  end
  return nil
end

function WBP_Piano_AlbumItem:InitUI()
  local MusicScorePic = self.DataObject and self.DataObject.MusicScorePic
  if not MusicScorePic and self.MusicScoreId then
    local MusicScoreInfo = DataMgr.MusicScore[self.MusicScoreId]
    MusicScorePic = MusicScoreInfo and MusicScoreInfo.MusicScorePic
  end
  if MusicScorePic and self.Img_Album then
    SetAlbumCoverImage(self.Img_Album, MusicScorePic)
  end
  local NameKey = self:GetMusicScoreDisplayName()
  if self.Text_Title and NameKey then
    self.Text_Title:SetText(GText(NameKey))
  end
  if self.Text_World then
    self.Text_World:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Panel_Lock then
    self.Panel_Lock:SetVisibility(self.IsLocked and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.IsLocked then
    self:ApplyLockedVisualInstant()
  else
    self.Btn_Album:SetForbidden(false)
  end
  if self.ReddotNum and self.ReddotNum > 0 then
    self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Btn_Album.OnClicked:Add(self, self.OnBtnClicked)
  self.Btn_Album.OnHovered:Add(self, self.OnBtnHovered)
  self.Btn_Album.OnUnHovered:Add(self, self.OnBtnUnHovered)
end

function WBP_Piano_AlbumItem:OnBtnClicked()
  if self.IsLocked then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("HomePiano_NoMusicBeenIncluded"), 5)
    return
  end
  if self.IsSelected then
    return
  end
  self:SetFocus()
  self.ParentUI:OnSelectMusicScoreChanged(self.ListViewIndex)
  if not self.bIsOnListItemSet then
    AudioManager(self):PlayUISound(self, "event:/ui/armory/click_crystal_btn_tab", nil, nil)
  end
end

function WBP_Piano_AlbumItem:OnBtnHovered()
  if self.IsLocked or self.IsSelected then
    return
  end
  self.ParentUI:ChangeCurrentHoverAlbumItem(self.ListViewIndex)
  if self.CurIsGamepad then
    self:OnBtnClicked()
  end
end

function WBP_Piano_AlbumItem:OnBtnUnHovered()
  if self.IsLocked or self.IsSelected then
    return
  end
  self.ParentUI:ClearHoverAlbumItemIfMatch(self.ListViewIndex)
end

function WBP_Piano_AlbumItem:OnHoverAlbumItemChanged(HoverMusicScoreId)
  local bHovered = HoverMusicScoreId >= 0 and HoverMusicScoreId == self.MusicScoreId
  if self.bIsHovered == bHovered then
    return
  end
  self.bIsHovered = bHovered
  self:RefreshItemVisualState()
end

function WBP_Piano_AlbumItem:RefreshItemVisualState()
  if self.IsLocked then
    self:ApplyLockedVisualInstant()
    return
  end
  self:StopAllAnimations()
  if self.Btn_Album then
    self.Btn_Album:SetForbidden(false)
  end
  if self.IsSelected then
    self:PlayAnimation(self.Click)
    self.bCanPlayAnimation = false
  elseif self.bIsHovered then
    self.bCanPlayAnimation = true
    self:PlayAnimation(self.Hover)
  else
    self.bCanPlayAnimation = true
    self:ApplyUnlockedVisualInstant()
  end
end

function WBP_Piano_AlbumItem:OnSelectMusicScoreChanged(NewMusicScoreId)
  if NewMusicScoreId == self.MusicScoreId then
    self:Selected()
  else
    self:Deselected()
  end
end

function WBP_Piano_AlbumItem:Selected()
  if self.IsSelected then
    return
  end
  self.IsSelected = true
  self.bIsHovered = false
  self:RefreshItemVisualState()
end

function WBP_Piano_AlbumItem:Deselected()
  if not self.IsSelected then
    return
  end
  self.IsSelected = false
  self:RefreshItemVisualState()
end

function WBP_Piano_AlbumItem:IsStoredChapterBGMScore()
  if not self.ParentUI:IsDungeonSceneMode() then
    return false
  end
  local StoredMusicId = self.ParentUI:GetChapterStoredMusicId()
  if self.DataObject and self.DataObject.bIsDungeonAlbum then
    return 0 == StoredMusicId
  end
  if StoredMusicId > 0 and DataMgr.Music[StoredMusicId] then
    return DataMgr.Music[StoredMusicId].MusicScoreId == self.MusicScoreId
  end
  return false
end

function WBP_Piano_AlbumItem:OnStoredChapterBGMChanged(ChapterId, MusicId)
  if not self.ParentUI:IsDungeonSceneMode() then
    return
  end
  local PianoSceneUtils = require("BluePrints.UI.WBP.Piano.PianoSceneUtils")
  if PianoSceneUtils.NormalizeChapterId(ChapterId) ~= PianoSceneUtils.NormalizeChapterId(self.ParentUI.CurrentScene) then
    return
  end
  if self:IsStoredChapterBGMScore() then
    self:IsStoredBGMMusicScore()
  else
    self:IsNotStoredBGMMusicScore()
  end
end

function WBP_Piano_AlbumItem:OnStoredCustomBGMChanged(NewMusicId)
  if self.ParentUI:IsDungeonSceneMode() then
    return
  end
  if self.DataObject and self.DataObject.bIsDungeonAlbum then
    return
  end
  local NewMusicScoreId = DataMgr.Music[NewMusicId].MusicScoreId
  if NewMusicScoreId == self.MusicScoreId then
    self:IsStoredBGMMusicScore()
  else
    self:IsNotStoredBGMMusicScore()
  end
end

function WBP_Piano_AlbumItem:IsStoredBGMMusicScore()
  if self.IsStoredCustomBGMMusicScore then
    return
  end
  self.IsStoredCustomBGMMusicScore = true
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function WBP_Piano_AlbumItem:IsNotStoredBGMMusicScore()
  if not self.IsStoredCustomBGMMusicScore then
    return
  end
  self.IsStoredCustomBGMMusicScore = false
  self.Icon_Music:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_Piano_AlbumItem:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function WBP_Piano_AlbumItem:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function WBP_Piano_AlbumItem:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad then
    if self.IsSelected then
      self:SetFocus()
    end
    self.CurIsGamepad = true
    self.Btn_Album.OnClicked:Remove(self, self.OnBtnClicked)
  else
    self.CurIsGamepad = false
    self.Btn_Album.OnClicked:Add(self, self.OnBtnClicked)
  end
end

return WBP_Piano_AlbumItem
