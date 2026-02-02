require("UnLua")
local WBP_AttrDebugPanel = Class({
  "BluePrints.UI.BP_UIState_C",
  "BluePrints.Common.TimerMgr"
})

function WBP_AttrDebugPanel:OnLoaded(...)
  local AttrName, Eid = ...
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local UIManager = GameInstance:GetGameUIManager()
  self.AttrWatcher = {}
  self.RepeatTimer = self:AddTimer(0.1, self.RefreshPanel, true, 0, "RefreshPanel")
end

function WBP_AttrDebugPanel:SetEntity(Entity)
  if not Entity.BuffManager then
    return
  end
  self.Entity = Entity
end

function WBP_AttrDebugPanel:RefreshPanel()
  self.DebugStr = ""
  self.Prefix = ""
  for Index, AttrWatcher in ipairs(self.AttrWatcher) do
    local Entity = Battle(self):GetEntity(AttrWatcher.Eid)
    if Entity then
      local Value = Entity:GetAttr(AttrWatcher.AttrName)
      self:AppendStr(Entity:GetName() .. " Eid: " .. AttrWatcher.Eid .. " " .. AttrWatcher.AttrName .. " : " .. string.format("%.2f", Value))
    else
      self:RemoveAttrWatcher(AttrWatcher.AttrName, AttrWatcher.Eid)
    end
  end
  self.TextInfo:SetText(self.DebugStr)
end

function WBP_AttrDebugPanel:AddAttrWatcher(AttrName, Eid)
  if not AttrName and not Eid then
    self:Clear()
    return
  end
  Eid = Eid or 1
  Eid = Eid and tonumber(Eid)
  local Entity = Battle(self):GetEntity(Eid)
  if not Entity then
    return
  end
  local AttributeSet = Entity:K2_GetAttributesSet()
  if not AttributeSet then
    return
  end
  for i, v in ipairs(self.AttrWatcher) do
    if v.AttrName == AttrName and v.Eid == Eid then
      return
    end
  end
  table.insert(self.AttrWatcher, {AttrName = AttrName, Eid = Eid})
  self:RefreshPanel()
end

function WBP_AttrDebugPanel:RemoveAttrWatcher(AttrName, Eid)
  for i, v in ipairs(self.AttrWatcher) do
    if v.AttrName == AttrName and v.Eid == Eid then
      table.remove(self.AttrWatcher, i)
      break
    end
  end
end

function WBP_AttrDebugPanel:Clear()
  self.AttrWatcher = {}
  self:RefreshPanel()
end

function WBP_AttrDebugPanel:AppendStr(InStr)
  self.DebugStr = self.DebugStr .. self.Prefix .. InStr .. "\n"
end

function WBP_AttrDebugPanel:AppendTab()
  self.Prefix = self.Prefix .. "    "
end

function WBP_AttrDebugPanel:RemoveTab()
  self.Prefix = self.Prefix:sub(1, -5)
end

function WBP_AttrDebugPanel:EMDestruct()
  self:Clear()
  self:RemoveTimer("RefreshPanel")
  DebugPrint("WBP_AttrDebugPanel Destruct")
end

return WBP_AttrDebugPanel
