local DeferCallUtils = {}
DeferCallUtils.PendingByCtx = {}
DeferCallUtils.RegisteredWorlds = setmetatable({}, {__mode = "k"})

function DeferCallUtils.OnFlushError(Err)
  if not GWorld or not GWorld.logger then
    return
  end
  GWorld.logger.error(Traceback("DeferCallUtils.Flush", Err, true))
end

function DeferCallUtils.Flush()
  local Snapshot = DeferCallUtils.PendingByCtx
  DeferCallUtils.PendingByCtx = {}
  DeferCallUtils.RegisteredWorlds = setmetatable({}, {__mode = "k"})
  for Ctx, Entries in pairs(Snapshot) do
    if Ctx:IsValid() then
      for _, Func in pairs(Entries) do
        xpcall(Func, DeferCallUtils.OnFlushError)
      end
    end
  end
end

function DeferCallUtils.DeferredCall(WorldContextObject, NameKey, Func)
  if not WorldContextObject then
    return
  end
  local World = WorldContextObject.GetWorld and WorldContextObject:GetWorld()
  if not World then
    UE4.UBattleFunctionLibrary.DeferredCall(WorldContextObject, NameKey, Func)
    return
  end
  DeferCallUtils.PendingByCtx[WorldContextObject] = DeferCallUtils.PendingByCtx[WorldContextObject] or {}
  DeferCallUtils.PendingByCtx[WorldContextObject][NameKey] = Func
  local Now = os.clock()
  local LastRegister = DeferCallUtils.RegisteredWorlds[World]
  if LastRegister and Now - LastRegister <= 1.0 then
    return
  end
  DeferCallUtils.RegisteredWorlds[World] = Now
  UE4.UBattleFunctionLibrary.DeferredCall(World, "DeferCallUtils_Flush", DeferCallUtils.Flush)
end

return DeferCallUtils
