require("UnLua")
local M = Class()

function M:OnInputKey_Lua(ControllerId, Key, EventType)
  DebugPrint(LXYTag, "BP_EMGameViewportClient_C:: OnInputKey_Lua", Key.KeyName, EventType)
  local bNeedRecord = false
  if EventType == EInputEvent.IE_Pressed then
    bNeedRecord = true
    EventManager:FireEvent(EventID.GameViewportInputKeyPressed, Key, EventType)
  elseif EventType == EInputEvent.IE_Released then
    bNeedRecord = true
    EventManager:FireEvent(EventID.GameViewportInputKeyReleased, Key, EventType)
  elseif EventType == EInputEvent.IE_Repeat then
    EventManager:FireEvent(EventID.GameViewportInputKeyLongPressed, Key, EventType)
  end
  if not bNeedRecord then
    return
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if IsValid(GameInstance) then
    local SceneMgr = GameInstance:GetSceneManager()
    if IsValid(SceneMgr) then
      SceneMgr:ReceivedInputKey(Key, EventType)
    end
  end
end

function M:OnInputAxis_Lua(ControllerId, Key, Delta, DeltaTime, NumSamples, bGamepad)
end

function M:OnViewportSizeChanged_Lua()
  DebugPrint(LXYTag, "BP_EMGameViewportClient_C:: OnViewportSizeChanged_Lua")
  EventManager:FireEvent(EventID.GameViewportSizeChanged)
end

function M:OnWindowActionChanged_Lua(WindowAction)
  DebugPrint("BP_EMGameViewportClient_C:: OnWindowActionChanged_Lua", WindowAction)
  EventManager:FireEvent(EventID.GameWindowActionChanged, WindowAction)
end

return M
