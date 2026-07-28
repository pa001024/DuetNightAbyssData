local M = {}
M.RougeProEventState = {
  Invalid = -1,
  Init = 1,
  Active = 2,
  Suspend = 3,
  Complete = 4,
  Destroy = 5
}
M.RougeProEventStateName = {
  [M.RougeProEventState.Invalid] = "Invalid",
  [M.RougeProEventState.Init] = "Create",
  [M.RougeProEventState.Active] = "Active",
  [M.RougeProEventState.Suspend] = "Suspend",
  [M.RougeProEventState.Complete] = "Complete",
  [M.RougeProEventState.Destroy] = "Destroy"
}

function M.GetRougeProEventStateName(state)
  return M.RougeProEventStateName[state]
end

function M.BuildRougeProEventFuncName(eventSubType, state)
  local stateName = M.RougeProEventStateName[state]
  if not eventSubType or not stateName then
    return nil
  end
  return string.format("%s_%s", eventSubType, stateName)
end

return M
