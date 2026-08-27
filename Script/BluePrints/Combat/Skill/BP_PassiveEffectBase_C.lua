require("UnLua")
local BP_PassiveEffectBase_C = Class({
  "BluePrints.Combat.Components.SkillLevelInterface",
  "BluePrints.Common.TimerMgr"
})

function BP_PassiveEffectBase_C:ReceiveBeginPlay()
  rawset(self, "BattleEvent", self.BattleEvent)
  if self.PassiveLuaPath and self.PassiveLuaPath ~= "" then
    self.PassiveLogic = require(self.PassiveLuaPath)
    if getmetatable(self.PassiveLogic) == nil then
      setmetatable(self.PassiveLogic, {
        __index = function(_, Key)
          return self[Key]
        end
      })
    end
    self:BindPassiveEvents()
    if self.PassiveLogic.BeginPlay and type(self.PassiveLogic.BeginPlay) == "function" then
      self.PassiveLogic.BeginPlay(self)
    end
  end
end

function BP_PassiveEffectBase_C:BindPassiveEvents()
  if not self.PassiveLogic or not self.BattleEvent then
    return
  end
  for EventName, Handler in pairs(self.PassiveLogic) do
    if "BeginPlay" ~= EventName and type(Handler) == "function" then
      local Delegate = self.BattleEvent[EventName]
      if Delegate and Delegate.Add then
        Delegate:Add(self, Handler)
      end
    end
  end
end

local function ApplyLuaFallbackVar(self, VarName, Value)
  rawset(self, tostring(VarName), Value)
end

function BP_PassiveEffectBase_C:InitPassiveLuaVar_Number(VarName, Value)
  ApplyLuaFallbackVar(self, VarName, Value)
end

function BP_PassiveEffectBase_C:InitPassiveLuaVar_String(VarName, Value)
  ApplyLuaFallbackVar(self, VarName, Value)
end

function BP_PassiveEffectBase_C:InitPassiveLuaVar_Bool(VarName, Value)
  ApplyLuaFallbackVar(self, VarName, Value)
end

function BP_PassiveEffectBase_C:SetPassiveOwner(PassiveOwner)
  self.SavedPassiveOwner = PassiveOwner
  self:CheckInitSuccess()
end

function BP_PassiveEffectBase_C:SetPassiveEffectsReady()
  self:RemoveTimer(self.InitHandle)
  self:CheckInitSuccess()
end

function BP_PassiveEffectBase_C:CheckInitSuccess()
  if not IsValid(self.SavedPassiveOwner) then
    return
  end
  if not self.SavedPassiveOwner.InitSuccess then
    return
  end
  if not self.InitSuccess then
    self.PassiveOwner = self.SavedPassiveOwner
    self.Overridden.ReceiveBeginPlay(self)
    self.InitSuccess = true
    self:RemoveTimer(self.InitHandle)
  end
end

function BP_PassiveEffectBase_C:Destroy()
  self:RemoveTimer(self.InitHandle)
  self:K2_DestroyActor()
end

return BP_PassiveEffectBase_C
