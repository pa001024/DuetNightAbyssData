require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if self.Btn_TabClick then
    self.Btn_TabClick.OnClicked:Add(self, self.OnCellClicked)
    self.Btn_TabClick.OnHovered:Add(self, self.OnCellHovered)
    self.Btn_TabClick.OnUnhovered:Add(self, self.OnCellUnhovered)
    self.Btn_TabClick.OnPressed:Add(self, self.OnCellPressed)
    self.Btn_TabClick.OnReleased:Add(self, self.OnCellReleased)
    self.Btn_TabClick:SetVisibility(UE4.ESlateVisibility.Visible)
  end
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.Entry = self
  local DungeonInfo = DataMgr.Dungeon[self.Content.Id] or {}
  local Level = DungeonInfo.DungeonLevel or self.Content.Index
  if self.Text_TabLevelNormal then
    self.Text_TabLevelNormal:SetText(GText("BATTLE_UI_BLOOD_LV") .. tostring(Level))
  end
  if self.Text_TabLevelSelect then
    self.Text_TabLevelSelect:SetText(GText("BATTLE_UI_BLOOD_LV") .. tostring(Level))
  end
  self:BindEventOnClicked(self.Content.Parent, self.Content.Parent.RefreshListChallengeInfo, self.Content.Index)
  local Avatar = GWorld:GetAvatar()
  local unlocked = Avatar and ConditionUtils.CheckCondition(Avatar, DungeonInfo.Condition, false) or false
  self.Content.IsLocked = not unlocked
  if self.Content.IsLocked then
    if self.Content.IsSelect and self.Lock_Click then
      self:PlayAnimation(self.Lock_Click)
    elseif self.Lock_Normal then
      self:PlayAnimation(self.Lock_Normal)
    end
  elseif self.Content.IsSelect and self.Click then
    self:PlayAnimation(self.Click)
  elseif self.Normal then
    self:PlayAnimation(self.Normal)
  end
  if self.Group_TabSelect and self.Group_Normal then
    if self.Content.IsSelect then
      self.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
      self.Group_Normal:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
      self.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.Collapsed)
      self.Group_Normal:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
    end
  end
end

function M:BindEventOnClicked(Obj, Func, ...)
  if not Obj or not Func then
    return
  end
  self.Obj = Obj
  self.Func = Func
  self.Params = {
    ...
  }
end

function M:OnCellClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_level_02", nil, nil)
  return self:OnCellClickedWithoutSound()
end

function M:OnCellClickedWithoutSound()
  if self.Content.IsSelect then
    return false
  end
  if self.Content.IsLocked then
    local Avatar = GWorld:GetAvatar()
    local DungeonInfo = DataMgr.Dungeon[self.Content.Id] or {}
    if Avatar and DungeonInfo and DungeonInfo.Condition and ConditionUtils and ConditionUtils.CheckCondition then
      ConditionUtils.CheckCondition(Avatar, DungeonInfo.Condition, true)
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Tosat_Level_Locked"))
    end
  end
  if self.Obj and self.Func then
    self.Func(self.Obj, table.unpack(self.Params))
  end
  local parent = self.Content.Parent
  if parent and parent.SelectedIndex and parent.ChallengeId and parent.List_BossLevels then
    local prevIndex = parent.SelectedIndex[parent.ChallengeId]
    if prevIndex and prevIndex ~= self.Content.Index then
      local PrevContent = parent.List_BossLevels:GetItemAt(math.max(prevIndex - 1, 0))
      if PrevContent and PrevContent.Entry then
        PrevContent.Entry.Content.IsSelect = false
        PrevContent.Entry:StopAllAnimations()
        if PrevContent.Entry.Content.IsLocked then
          if PrevContent.Entry.Lock_Normal then
            PrevContent.Entry:PlayAnimation(PrevContent.Entry.Lock_Normal)
          end
        elseif PrevContent.Entry.Normal then
          PrevContent.Entry:PlayAnimation(PrevContent.Entry.Normal)
        end
        if PrevContent.Entry.Group_TabSelect then
          PrevContent.Entry.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.Collapsed)
        end
        if PrevContent.Entry.Group_Normal then
          PrevContent.Entry.Group_Normal:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
        end
      end
    end
    parent.SelectedIndex[parent.ChallengeId] = self.Content.Index
  end
  self.Content.IsSelect = true
  self:StopAllAnimations()
  if self.Content.IsLocked then
    if self.Lock_Click then
      self:PlayAnimation(self.Lock_Click)
    end
  elseif self.Click then
    self:PlayAnimation(self.Click)
  end
  if self.Group_TabSelect then
    self.Group_TabSelect:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  end
  if self.Group_Normal then
    self.Group_Normal:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  return true
end

function M:OnCellHovered()
  if self.Content.IsSelect then
    return
  end
  if self.Normal then
    self:StopAnimation(self.Normal)
  end
  if self.Lock_Normal then
    self:StopAnimation(self.Lock_Normal)
  end
  if self.Content.IsLocked then
    if self.Lock_Hover then
      self:PlayAnimation(self.Lock_Hover)
    end
  elseif self.Hover then
    self:PlayAnimation(self.Hover)
  end
end

function M:OnCellUnhovered()
  if self.Content.IsSelect then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Lock_Hover then
    self:StopAnimation(self.Lock_Hover)
  end
  if self.Content.IsLocked then
    if self.Lock_UnHover then
      self:PlayAnimation(self.Lock_UnHover)
    end
  elseif self.UnHover then
    self:PlayAnimation(self.UnHover)
  end
end

function M:OnCellPressed()
  if self.Content.IsSelect then
    return
  end
  if self.Hover then
    self:StopAnimation(self.Hover)
  end
  if self.Lock_Hover then
    self:StopAnimation(self.Lock_Hover)
  end
  if self.Content.IsLocked then
    if self.Lock_Press then
      self:PlayAnimation(self.Lock_Press)
    end
  elseif self.Press then
    self:PlayAnimation(self.Press)
  end
end

function M:OnCellReleased()
  if self.Content.IsSelect then
    return
  end
  if self.Press then
    self:StopAnimation(self.Press)
  end
  if self.Lock_Press then
    self:StopAnimation(self.Lock_Press)
  end
end

return M
