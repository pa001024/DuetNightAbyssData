require("UnLua")
local Const = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseConst")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:SetLeafSoundEvent(EventPath)
  self.LeafSoundEvent = EventPath
end

function M:SetKillInfo(Count, LitCount, bImmediate)
  local PreviousCount = self.KillCount
  local PreviousRank = self.LitCount or 0
  local bReset = bImmediate or nil == PreviousCount or Count < PreviousCount
  LitCount = math.max(0, math.min(LitCount, #Const.Kill.Points))
  local bWasMax = PreviousRank == #Const.Kill.Points
  local bIsMax = LitCount == #Const.Kill.Points
  local bLeafLit = false
  if (bImmediate or nil == PreviousCount) and self.Text_Kill then
    local Label = GText(Const.Kill.LabelKey)
    self.Text_Kill:SetText(Label)
    self.Text_Kill:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Text_Num and (bReset or Count ~= PreviousCount) then
    self.Text_Num:SetText(tostring(Count))
  end
  if bReset then
    self:StopKillAnimations()
    if self.Refesh then
      self:PlayAnimation(self.Refesh, self.Refesh:GetEndTime())
    end
  end
  if bReset or LitCount ~= PreviousRank then
    for i, Name in ipairs(Const.Kill.Points) do
      local Point = self[Name]
      if IsValid(Point) then
        local bLit = LitCount >= i
        local bWasLit = PreviousRank >= i
        if bReset or bLit ~= bWasLit then
          Point:StopAllAnimations()
          if bLit and Point.Add then
            Point:PlayAnimation(Point.Add, bReset and Point.Add:GetEndTime() or 0)
            if not bLeafLit then
              bLeafLit = not bReset and not bWasLit
            end
          elseif Point.Normal then
            Point:PlayAnimation(Point.Normal)
          end
        end
      end
    end
  end
  if bLeafLit and self.LeafSoundEvent and self.LeafSoundEvent ~= "" then
    AudioManager(self):PlayUISound(self, self.LeafSoundEvent, nil, nil)
  end
  if bReset or bIsMax ~= bWasMax then
    if self.Max_Normal then
      self:StopAnimation(self.Max_Normal)
    end
    if self.Max_Loop then
      self:StopAnimation(self.Max_Loop)
    end
    if bIsMax then
      if self.Max_Loop then
        self:PlayAnimation(self.Max_Loop, 0, 0)
      end
    elseif self.Max_Normal then
      self:PlayAnimation(self.Max_Normal)
    end
  end
  if not bReset and Count > PreviousCount then
    if self.Refesh then
      self:StopAnimation(self.Refesh)
    end
    if self.Max_Refesh then
      self:StopAnimation(self.Max_Refesh)
    end
    local RefreshAnimation = bIsMax and self.Max_Refesh or self.Refesh
    if RefreshAnimation then
      self:PlayAnimation(RefreshAnimation)
    end
  end
  self.KillCount = Count
  self.LitCount = LitCount
end

function M:StopKillAnimations()
  self:StopAllAnimations()
  for _, Name in ipairs(Const.Kill.Points) do
    local Point = self[Name]
    if IsValid(Point) then
      Point:StopAllAnimations()
    end
  end
end

function M:Destruct()
  self:StopKillAnimations()
  self.KillCount = nil
  self.LitCount = nil
  self.LeafSoundEvent = nil
end

return M
