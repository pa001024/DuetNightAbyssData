require("UnLua")
require("DataMgr")
local PianoSceneUtils = require("BluePrints.UI.WBP.Piano.PianoSceneUtils")
local SCENE_THUMB_TEXTURE_PARAM = "MainTex"
local GAMEPAD_CHECK_KEY = UIConst.GamePadImgKey.LeftThumb

local function SetWidgetVisibility(Widget, bVisible)
  if not Widget or not Widget.SetVisibility then
    return
  end
  Widget:SetVisibility(bVisible and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

local function SetSceneThumbImage(Img, PicPath)
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
  DMI:SetTextureParameterValue(SCENE_THUMB_TEXTURE_PARAM, Texture)
end

local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
})

function M:Destruct()
  self:UnbindCheckEvents()
  self:RemoveInputMethodChangedListen()
  self:ClearScriptRegister()
end

function M:DisableBtnAreaHitTest()
  if not self.Btn_Area or not self.Btn_Area.SetVisibility then
    return
  end
  if self.Btn_Area.OnClicked then
    self.Btn_Area.OnClicked:Clear()
  end
  self.Btn_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
end

function M:BindCheckEvents()
  if not self.Btn_Check or not self.Btn_Check.BindEventOnClicked then
    return
  end
  self.Btn_Check:BindEventOnClicked(self, self.OnBtnCheckClicked)
end

function M:UnbindCheckEvents()
  if self.Btn_Check and self.Btn_Check.UnBindEventOnClickedByObj then
    self.Btn_Check:UnBindEventOnClickedByObj(self)
  end
end

function M:ApplyLockedVisual()
  self:StopAllAnimations()
  SetWidgetVisibility(self.Panel_Lock, true)
  if self.Btn_Check and self.Btn_Check.ForbidBtn then
    self.Btn_Check:ForbidBtn(true)
  end
  if self.Btn_Area and self.Btn_Area.SetIsEnabled then
    self.Btn_Area:SetIsEnabled(false)
  end
  if self.Forbidden then
    self:PlayAnimation(self.Forbidden)
  end
end

function M:ApplyUnlockedVisual()
  self:StopAllAnimations()
  SetWidgetVisibility(self.Panel_Lock, false)
  if self.Btn_Check and self.Btn_Check.ForbidBtn then
    self.Btn_Check:ForbidBtn(false)
  end
  if self.Btn_Area and self.Btn_Area.SetIsEnabled then
    self.Btn_Area:SetIsEnabled(true)
  end
  if self.Normal then
    self:PlayAnimation(self.Normal, 0)
  end
end

function M:ResetUnlockedSceneMaterialInstant()
  if self.Normal and self.Normal.GetEndTime then
    self:PlayAnimation(self.Normal, self.Normal:GetEndTime())
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
end

function M:PlayForbiddenFeedback()
  if not self.IsLocked then
    return
  end
  self:ApplyLockedVisual()
end

function M:BP_OnEntryReleased()
  self.DataObject = nil
  self.ParentUI = nil
  self.bIsHovered = false
  self.bIsGamepadSelected = false
  SetWidgetVisibility(self.Panel_Lock, false)
  self:StopAllAnimations()
  self:ResetUnlockedSceneMaterialInstant()
  self:RemoveInputMethodChangedListen()
  self:RefreshGamepadKeyCheckVisual()
end

function M:OnListItemObjectSet(ListItemObject)
  self:UnbindCheckEvents()
  self.DataObject = ListItemObject
  self.ParentUI = ListItemObject.Owner
  self.SceneId = PianoSceneUtils.NormalizeChapterId(ListItemObject.SceneId)
  self.IsLocked = ListItemObject.bIsLocked
  self.ThumbPath = ListItemObject.ThumbPath
  self.bIsDungeon = ListItemObject.bIsDungeon
  self.ListViewIndex = ListItemObject.Index
  self.bIsHovered = false
  self.bIsGamepadSelected = false
  if self.ParentUI and self.ParentUI.Cur_SceneHoverIndex == self.ListViewIndex then
    self.bIsHovered = true
  end
  self:InitUI()
  self:AddDispatcher(EventID.ChangePianoSelectScene, self, self.OnSelectSceneChanged)
  self:BindCheckEvents()
  self:RemoveInputMethodChangedListen()
  self:AddInputMethodChangedListen()
  self:RefreshItemVisualState()
end

function M:InitUI()
  if self.Text_Scene then
    if not self.bIsDungeon then
      self.Text_Scene:SetText(PianoSceneUtils.GetHomeSceneDisplayName())
    else
      local NameKey = PianoSceneUtils.GetChapterDisplayNameKey(self.SceneId)
      if NameKey then
        self.Text_Scene:SetText(GText(NameKey))
      end
    end
  end
  if self.ThumbPath and self.Img_Scene then
    SetSceneThumbImage(self.Img_Scene, self.ThumbPath)
  end
  if self.Btn_Check and self.Btn_Check.SetVisibility then
    local DescVisibility = self.bIsDungeon and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed
    self.Btn_Check:SetVisibility(DescVisibility)
  end
  if self.IsLocked then
    self:ApplyLockedVisual()
  end
  self:InitGamepadKeyCheck()
  self:BindGamepadEntryNavigation()
  self:DisableBtnAreaHitTest()
end

function M:BindGamepadEntryNavigation()
  if not self.SetNavigationRuleCustom then
    return
  end
  self:SetNavigationRuleBase(UE4.EUINavigation.Left, UE4.EUINavigationRule.Stop)
  self:SetNavigationRuleCustom(UE4.EUINavigation.Up, {
    self,
    self.HandleNavigationUp
  })
  self:SetNavigationRuleCustom(UE4.EUINavigation.Down, {
    self,
    self.HandleNavigationDown
  })
end

function M:HandleNavigationUp()
  if self.ListViewIndex == nil or self.ListViewIndex <= 0 then
    return
  end
  local ListScene = self.ParentUI and self.ParentUI.List_Scene
  if not ListScene then
    return
  end
  local TargetIndex = self.ListViewIndex - 1
  ListScene:NavigateToIndex(TargetIndex)
  if ListScene.SetSelectedIndex then
    ListScene:SetSelectedIndex(TargetIndex)
  else
    local TargetItem = ListScene:GetItemAt(TargetIndex)
    if TargetItem and ListScene.BP_SetSelectedItem then
      ListScene:BP_SetSelectedItem(TargetItem)
    end
  end
end

function M:HandleNavigationDown()
  if not (self.ListViewIndex ~= nil and self.ParentUI) or not self.ParentUI.List_Scene then
    return
  end
  local ListScene = self.ParentUI.List_Scene
  local ItemCount = ListScene:GetNumItems()
  if self.ListViewIndex >= ItemCount - 1 then
    return
  end
  local TargetIndex = self.ListViewIndex + 1
  ListScene:NavigateToIndex(TargetIndex)
  if ListScene.SetSelectedIndex then
    ListScene:SetSelectedIndex(TargetIndex)
  else
    local TargetItem = ListScene:GetItemAt(TargetIndex)
    if TargetItem and ListScene.BP_SetSelectedItem then
      ListScene:BP_SetSelectedItem(TargetItem)
    end
  end
end

function M:IsGamepadInput()
  return UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
end

function M:ShouldShowGamepadKeyCheck()
  return self:IsGamepadInput() and self.bIsGamepadSelected and self.bIsDungeon and not self.IsLocked
end

function M:InitGamepadKeyCheck()
  if self.Key_Check and self.Key_Check.CreateGamepadKey then
    self.Key_Check:CreateGamepadKey(GAMEPAD_CHECK_KEY)
  end
  self:RefreshGamepadKeyCheckVisual()
end

function M:RefreshGamepadKeyCheckVisual()
  local bShow = self:ShouldShowGamepadKeyCheck()
  if self.WS_State and self.WS_State.SetActiveWidgetIndex then
    self.WS_State:SetActiveWidgetIndex(bShow and 1 or 0)
  end
  if self.Key_Check and self.Key_Check.SetVisibility then
    SetWidgetVisibility(self.Key_Check, bShow)
  end
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  self:RefreshGamepadKeyCheckVisual()
end

function M:BP_OnItemSelectionChanged(bIsSelected)
  self.bIsGamepadSelected = true == bIsSelected
  self:RefreshGamepadKeyCheckVisual()
end

function M:IsItemSelected()
  if not self.ParentUI then
    return false
  end
  return PianoSceneUtils.IsSameSceneId(self.ParentUI.Cur_SelectSceneId, self.SceneId)
end

function M:RefreshItemVisualState()
  if self.IsLocked then
    self:ApplyLockedVisual()
    self:RefreshGamepadKeyCheckVisual()
    return
  end
  self:StopAllAnimations()
  SetWidgetVisibility(self.Panel_Lock, false)
  if self.Btn_Check and self.Btn_Check.ForbidBtn then
    self.Btn_Check:ForbidBtn(false)
  end
  if self.Btn_Area and self.Btn_Area.SetIsEnabled then
    self.Btn_Area:SetIsEnabled(true)
  end
  if self:IsItemSelected() then
    self:ResetUnlockedSceneMaterialInstant()
    if self.Click then
      self:PlayAnimation(self.Click)
    end
  elseif self.bIsHovered then
    self:ResetUnlockedSceneMaterialInstant()
    if self.Hover then
      self:PlayAnimation(self.Hover)
    end
  else
    self:ResetUnlockedSceneMaterialInstant()
  end
  self:RefreshGamepadKeyCheckVisual()
end

function M:OnItemHovered()
  if self.IsLocked or self:IsItemSelected() then
    return
  end
  AudioManager(self):PlayUISound(nil, "event:/ui/common/hover_btn_large_crystal", nil, nil)
  self.bIsHovered = true
  if self.UnHover then
    self:StopAnimation(self.UnHover)
  end
  if self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnItemUnHovered()
  if self.IsLocked or self:IsItemSelected() then
    return
  end
  self.bIsHovered = false
  if self.Click and self:IsAnimationPlaying(self.Click) then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.UnHover then
    self:PlayAnimation(self.UnHover)
  else
    self:ApplyUnlockedVisual()
  end
end

function M:OnItemPressed()
  if self.IsLocked then
    return
  end
  if self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:OnBtnCheckClicked()
  if self.IsLocked or not self.bIsDungeon then
    return
  end
  if not PianoSceneUtils.IsChapterAvailableInPianoScene(self.SceneId) then
    return
  end
  local NameKey, DescKey, RewardViewId = PianoSceneUtils.GetChapterDetailInfo(self.SceneId)
  UIManager(self):LoadUINew("ItemInformation", {
    Name = NameKey,
    Desc = DescKey,
    RewardViewId = RewardViewId
  }, "LevelDatail", self.ParentUI)
end

function M:OnSelectSceneChanged(NewSceneId)
  if PianoSceneUtils.IsSameSceneId(NewSceneId, self.SceneId) then
    self.bIsHovered = false
  end
  self:RefreshItemVisualState()
end

return M
