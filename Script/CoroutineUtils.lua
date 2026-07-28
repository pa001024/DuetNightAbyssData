local function CreateCoroutine(Func, ...)
  return coroutine.create(function(...)
    try({exec = Func}, ...)
  end)
end

local function RunAsyncTask(Obj, TaskName, TaskFunc)
  if rawget(Obj, TaskName) then
    return
  end
  rawset(Obj, TaskName, coroutine.create(function()
    local Co = rawget(Obj, TaskName)
    try({exec = TaskFunc}, Co, Obj)
    rawset(Obj, TaskName, nil)
    coroutine.close(Co)
  end))
  coroutine.resume(rawget(Obj, TaskName))
end

local function ForceStopAsyncTask(Obj, TaskName)
  if not rawget(Obj, TaskName) then
    return
  end
  local Co = rawget(Obj, TaskName)
  rawset(Obj, TaskName, nil)
  local Status = coroutine.status(Co)
  if "running" == Status or "suspended" == Status then
    coroutine.close(Co)
  end
end

return {
  CreateCoroutine = CreateCoroutine,
  RunAsyncTask = RunAsyncTask,
  ForceStopAsyncTask = ForceStopAsyncTask
}
