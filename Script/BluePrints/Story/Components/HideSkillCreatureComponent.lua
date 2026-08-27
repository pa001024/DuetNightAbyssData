local FHideSkillCreatureComponent = {}

function FHideSkillCreatureComponent:New(TalkContext)
  local Obj = setmetatable({}, {__index = FHideSkillCreatureComponent})
  Obj.TalkContext = TalkContext
  return Obj
end

function FHideSkillCreatureComponent:Execute()
  local BattleObject = Battle(self.TalkContext)
  if IsValid(BattleObject) then
    BattleObject:HideAllSkillCreature(Const.TalkHideTag, true)
  end
end

function FHideSkillCreatureComponent:Resume()
  local BattleObject = Battle(self.TalkContext)
  if IsValid(BattleObject) then
    BattleObject:HideAllSkillCreature(Const.TalkHideTag, false)
  end
end

return FHideSkillCreatureComponent
