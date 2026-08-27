require("UnLua")
local M = Class()

local function NewWeakKeyTable()
  return setmetatable({}, {__mode = "k"})
end

local function NewWeakValueTable()
  return setmetatable({}, {__mode = "v"})
end

local function InvokeTick(Entry, Widget, DeltaTime)
  Entry.TickFunction(Widget, Widget:GetCachedGeometry(), DeltaTime)
end

local function Traceback(ErrorMessage)
  return debug.traceback(tostring(ErrorMessage), 2)
end

function M:ReceiveInitialize()
  rawset(self, "Objects", NewWeakValueTable())
  rawset(self, "Index", NewWeakKeyTable())
  rawset(self, "Nodes", {})
  rawset(self, "Entries", {})
  rawset(self, "Order", {})
  rawset(self, "PendingAdd", {})
  rawset(self, "PendingRemove", {})
  rawset(self, "WaitingChildren", NewWeakKeyTable())
  rawset(self, "NextToken", 1)
  rawset(self, "InTick", false)
end

function M:_SetSubtreeInactive(Token)
  local Node = self.Nodes[Token]
  if not Node then
    return
  end
  Node.Active = false
  for ChildToken in pairs(Node.Children) do
    self:_SetSubtreeInactive(ChildToken)
  end
end

function M:_UpdateActive(Token)
  local Node = self.Nodes[Token]
  if not Node then
    return
  end
  local ParentActive = not Node.ParentMissing
  if Node.ParentToken then
    local ParentNode = self.Nodes[Node.ParentToken]
    ParentActive = nil ~= ParentNode and ParentNode.Active
  end
  Node.Active = Node.Alive and Node.SelfActive and ParentActive
  for ChildToken in pairs(Node.Children) do
    self:_UpdateActive(ChildToken)
  end
end

function M:_AttachChild(ParentToken, ChildToken)
  local ParentNode = self.Nodes[ParentToken]
  local ChildNode = self.Nodes[ChildToken]
  if not ParentNode or not ChildNode then
    return
  end
  if ChildNode.ParentToken then
    local OldParent = self.Nodes[ChildNode.ParentToken]
    if OldParent then
      OldParent.Children[ChildToken] = nil
    end
  end
  ChildNode.ParentToken = ParentToken
  ChildNode.ParentMissing = false
  ParentNode.Children[ChildToken] = true
  self:_UpdateActive(ChildToken)
end

function M:_AddEntry(Token)
  local Entry = self.Entries[Token]
  if not Entry or Entry.PendingRemove or Entry.InOrder then
    return
  end
  Entry.InOrder = true
  self.Order[#self.Order + 1] = Token
end

function M:_FlushRemoves()
  if next(self.PendingRemove) == nil then
    return
  end
  local NewOrder = {}
  for _, Token in ipairs(self.Order) do
    local Entry = self.Entries[Token]
    if Entry and not Entry.PendingRemove then
      NewOrder[#NewOrder + 1] = Token
    elseif Entry then
      Entry.InOrder = false
      self.Entries[Token] = nil
    end
  end
  for Token in pairs(self.PendingRemove) do
    local Entry = self.Entries[Token]
    if Entry and not Entry.InOrder then
      self.Entries[Token] = nil
    end
  end
  rawset(self, "Order", NewOrder)
  rawset(self, "PendingRemove", {})
end

function M:_FlushAdds()
  local PendingAdd = self.PendingAdd
  rawset(self, "PendingAdd", {})
  for _, Token in ipairs(PendingAdd) do
    local Node = self.Nodes[Token]
    if Node and Node.Alive then
      self:_AddEntry(Token)
    end
  end
end

function M:_RemoveToken(Token)
  local Node = self.Nodes[Token]
  if not Node then
    return
  end
  self:_SetSubtreeInactive(Token)
  Node.Alive = false
  if Node.ParentToken then
    local ParentNode = self.Nodes[Node.ParentToken]
    if ParentNode then
      ParentNode.Children[Token] = nil
    end
  end
  for ChildToken in pairs(Node.Children) do
    local ChildNode = self.Nodes[ChildToken]
    if ChildNode then
      ChildNode.ParentToken = nil
      ChildNode.ParentMissing = true
    end
  end
  local Entry = self.Entries[Token]
  if Entry then
    Entry.PendingRemove = true
    self.PendingRemove[Token] = true
  end
  local Widget = self.Objects[Token]
  if Widget then
    self.Index[Widget] = nil
  end
  self.Objects[Token] = nil
  self.Nodes[Token] = nil
  if not self.InTick then
    self:_FlushRemoves()
  end
end

function M:ReceiveWidgetConstructed(Widget, ManagedParent, bSelfActive)
  if not IsValid(Widget) then
    return
  end
  local ExistingToken = self.Index[Widget]
  if ExistingToken then
    local ExistingNode = self.Nodes[ExistingToken]
    if ExistingNode then
      ExistingNode.SelfActive = bSelfActive
      local ParentToken = IsValid(ManagedParent) and self.Index[ManagedParent] or nil
      if ParentToken then
        self:_AttachChild(ParentToken, ExistingToken)
      else
        ExistingNode.ParentMissing = IsValid(ManagedParent)
        self:_UpdateActive(ExistingToken)
      end
    end
    return
  end
  local Token = self.NextToken
  rawset(self, "NextToken", Token + 1)
  self.Objects[Token] = Widget
  self.Index[Widget] = Token
  local ParentToken = IsValid(ManagedParent) and self.Index[ManagedParent] or nil
  local Node = {
    Token = Token,
    ParentToken = nil,
    ParentMissing = IsValid(ManagedParent) and nil == ParentToken,
    Children = {},
    SelfActive = bSelfActive,
    Active = false,
    Alive = true
  }
  self.Nodes[Token] = Node
  if ParentToken then
    self:_AttachChild(ParentToken, Token)
  elseif Node.ParentMissing then
    local Waiting = self.WaitingChildren[ManagedParent]
    if not Waiting then
      Waiting = {}
      self.WaitingChildren[ManagedParent] = Waiting
    end
    Waiting[#Waiting + 1] = Token
  else
    self:_UpdateActive(Token)
  end
  local Waiting = self.WaitingChildren[Widget]
  if Waiting then
    self.WaitingChildren[Widget] = nil
    for _, ChildToken in ipairs(Waiting) do
      self:_AttachChild(Token, ChildToken)
    end
  end
  local LuaClass = getmetatable(Widget)
  local TickFunction = LuaClass and rawget(LuaClass, "Tick")
  if type(TickFunction) ~= "function" or not Widget:SetManagedLuaWidgetTickEnabled(true) then
    return
  end
  self.Entries[Token] = {
    Token = Token,
    TickFunction = TickFunction,
    ConsecutiveErrorCount = 0,
    PendingRemove = false,
    InOrder = false
  }
  if self.InTick then
    self.PendingAdd[#self.PendingAdd + 1] = Token
  else
    self:_AddEntry(Token)
  end
end

function M:ReceiveWidgetDestructed(Widget)
  local Token = Widget and self.Index[Widget] or nil
  if Token then
    self:_RemoveToken(Token)
  end
end

function M:ReceiveWidgetActiveChanged(Widget, bActive)
  local Token = IsValid(Widget) and self.Index[Widget] or nil
  local Node = Token and self.Nodes[Token] or nil
  if not Node then
    return
  end
  Node.SelfActive = bActive
  self:_UpdateActive(Token)
end

function M:ReceiveTick(DeltaTime)
  rawset(self, "InTick", true)
  for _, Token in ipairs(self.Order) do
    local Entry = self.Entries[Token]
    local Node = self.Nodes[Token]
    if Entry and not Entry.PendingRemove and Node and Node.Active then
      local Widget = self.Objects[Token]
      if IsValid(Widget) then
        local bSucceeded, ErrorMessage = xpcall(InvokeTick, Traceback, Entry, Widget, DeltaTime)
        if bSucceeded then
          Entry.ConsecutiveErrorCount = 0
        else
          Entry.ConsecutiveErrorCount = Entry.ConsecutiveErrorCount + 1
          if 1 == Entry.ConsecutiveErrorCount or 0 == Entry.ConsecutiveErrorCount % 60 then
            DebugPrint(ErrorTag, string.format([[
LuaWidgetTick failed (token=%d, repeated=%d, widget=%s):
%s]], Token, Entry.ConsecutiveErrorCount, tostring(Widget), tostring(ErrorMessage)))
          end
        end
      else
        self:_RemoveToken(Token)
      end
    end
  end
  rawset(self, "InTick", false)
  self:_FlushRemoves()
  self:_FlushAdds()
end

function M:ReceiveDeinitialize()
  for _, Widget in pairs(self.Objects or {}) do
    if IsValid(Widget) then
      Widget:SetManagedLuaWidgetTickEnabled(false)
    end
  end
  rawset(self, "Objects", NewWeakValueTable())
  rawset(self, "Index", NewWeakKeyTable())
  rawset(self, "Nodes", {})
  rawset(self, "Entries", {})
  rawset(self, "Order", {})
  rawset(self, "PendingAdd", {})
  rawset(self, "PendingRemove", {})
  rawset(self, "WaitingChildren", NewWeakKeyTable())
  rawset(self, "InTick", false)
end

return M
