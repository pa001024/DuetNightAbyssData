require("UnLua")
local M = Class("BluePrints.UI.UI_PC.Battle.ExclusiveSkill.Base.Battle_Skill_UI_Base")

function M:Construct()
  DebugPrint("lgc@Battle_KamiSkill M:Construct", 123123)
  self.DeltaTime = 0
end

function M:OnLoaded(OwnerPlayer, Params)
  DebugPrint("lgc@Battle_KamiSkill M:OnLoaded", 123123)
  self.OwnerPlayer = OwnerPlayer
  self.CreatureId = Params.CreatureId
  self.bIsCreatureActive = false
  self.MaxLifeTime = 666
  self.Battle = Battle(self.OwnerPlayer)
  self.Root:SetVisibility(ESlateVisibility.Collapsed)
  self:AddTimer(0.3, self.UpdateBattleCharUI, true, 0)
end

function M:UpdateBattleCharUI()
  if IsValid(self.OwnerPlayer) and IsValid(self.Battle) then
    local CreatureList = self.OwnerPlayer:GetCreatureList(self.CreatureId)
    local bHasActiveCreature = false
    local bFirstActive = false
    local MaxRemainingLifeTime = -1
    if CreatureList:Num() > 0 then
      local CurCreatureList = CreatureList:ToTable()
      if #CurCreatureList > 0 then
        local Creature = self.Battle:GetEntity(CurCreatureList[1])
        if IsValid(Creature) then
          bHasActiveCreature = true
          if not self.bIsCreatureActive then
            self.bIsCreatureActive = true
            bFirstActive = true
          end
          local LeftLifeTime = Creature:GetLeftLifeTime()
          if LeftLifeTime and LeftLifeTime > 0 then
            MaxRemainingLifeTime = LeftLifeTime
          end
        end
      end
    end
    if bHasActiveCreature and MaxRemainingLifeTime > 0 then
      if bFirstActive then
        local CurCreatureList = CreatureList:ToTable()
        if #CurCreatureList > 0 then
          local FirstCreature = self.Battle:GetEntity(CurCreatureList[1])
          if IsValid(FirstCreature) then
            local TotalLifeTime = FirstCreature:GetTotalLifeTime()
            if TotalLifeTime and TotalLifeTime > 0 then
              self.MaxLifeTime = TotalLifeTime
            else
              self.MaxLifeTime = MaxRemainingLifeTime
            end
          end
        end
        self:PlayAnimation(self.In)
      end
      self:UpdateProgress(MaxRemainingLifeTime, self.MaxLifeTime)
      local bNowPausing = false
      if MaxRemainingLifeTime and MaxRemainingLifeTime > 0 and self.LastMaxRemainingLifeTime and self.LastMaxRemainingLifeTime == MaxRemainingLifeTime then
        bNowPausing = true
      end
      self.LastMaxRemainingLifeTime = MaxRemainingLifeTime
      DebugPrint("lgc@Battle_KamiSkill M:UpdateBattleCharUI", bNowPausing, MaxRemainingLifeTime)
      self.bOldPausing = self.bOldPausing or false
      if bNowPausing and not self.bOldPausing then
        self:PlayAnimationForward(self.Pause)
      else
        if not bNowPausing and self.bOldPausing then
          self:PlayAnimationReverse(self.Pause)
        else
        end
      end
      self.bOldPausing = bNowPausing
      self.Root:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      if self.bIsCreatureActive then
        self:BindToAnimationFinished(self.Out, function()
          self:UnbindAllFromAnimationFinished(self.Out)
          self.Root:SetVisibility(ESlateVisibility.Collapsed)
        end)
        self:PlayAnimation(self.Out)
      end
      self.bIsCreatureActive = false
    end
  end
end

function M:UpdateProgress(Remaining, Max)
  if Remaining > 0 then
    local Percent = math.max(Remaining / Max, 0)
    self.Progress_Kami:SetPercent(Percent)
    self.Num_Kami:SetText(string.format("%.0f", Remaining))
  end
end

return M
