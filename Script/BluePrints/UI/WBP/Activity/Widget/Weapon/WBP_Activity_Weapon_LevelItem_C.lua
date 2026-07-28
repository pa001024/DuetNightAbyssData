require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:PlayStateAnim(Anim)
  if not Anim then
    return
  end
  self:StopAllAnimations()
  self:PlayAnimation(Anim)
end

local DIFFICULTY_KEYS = {
  "RL_Difficulty_1",
  "RL_Difficulty_2",
  "RL_Difficulty_3",
  "RL_Difficulty_4",
  "RL_Difficulty_5",
  "RL_Difficulty_6"
}

function M:Construct()
  self.BtnArea.OnClicked:Add(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Add(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Add(self, self.OnBtnPressed)
end

function M:Destruct()
  self.BtnArea.OnClicked:Remove(self, self.OnBtnClicked)
  self.BtnArea.OnHovered:Remove(self, self.OnBtnHovered)
  self.BtnArea.OnUnhovered:Remove(self, self.OnBtnUnhovered)
  self.BtnArea.OnPressed:Remove(self, self.OnBtnPressed)
end

function M:SetData(Data)
  self.Data = Data
  if IsValid(self.TextLevelNum) then
    self.TextLevelNum:SetText(Data.Index or 1)
  end
  self:SetLockState(not Data.Unlocked)
  self:SetSelected(false)
end

function M:SetLockState(bLocked)
  self.bLocked = bLocked
  if bLocked then
    self:PlayStateAnim(self.Lock)
  end
end

function M:SetSelected(bSelected)
  self.bSelected = bSelected
  if self.bLocked then
    return
  end
  self:PlayStateAnim(bSelected and self.Click or self.Normal)
end

function M:OnBtnHovered()
  if self.bLocked or self.bSelected then
    return
  end
  self:PlayStateAnim(self.Hover)
end

function M:OnBtnUnhovered()
  if self.bLocked or self.bSelected then
    return
  end
  self:PlayStateAnim(self.UnHover)
end

function M:OnBtnPressed()
  if self.bLocked then
    return
  end
  self:PlayStateAnim(self.Press)
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_sub_level_btn_click", nil, nil)
  local Data = self.Data
  if Data and Data.Owner and Data.OnClick then
    Data.OnClick(Data.Owner, Data.Index, Data.GroupId, Data.Unlocked)
  end
end

return M
