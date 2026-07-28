require("UnLua")
local M = Class()

function M:OnInputKey_Lua(ControllerId, Key, EventType)
  local AnyHandled = {bHandled = false}
  local bNeedRecord = false
  if EventType == EInputEvent.IE_Pressed then
    bNeedRecord = true
    EventManager:FireEvent(EventID.GameViewportInputKeyPressed, Key, AnyHandled)
  elseif EventType == EInputEvent.IE_Released then
    bNeedRecord = true
    EventManager:FireEvent(EventID.GameViewportInputKeyReleased, Key, AnyHandled)
  elseif EventType == EInputEvent.IE_Repeat then
    EventManager:FireEvent(EventID.GameViewportInputKeyLongPressed, Key, AnyHandled)
  end
  if not bNeedRecord and not AnyHandled.bHandled then
    return false
  end
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if IsValid(GameInstance) then
    local SceneMgr = GameInstance:GetSceneManager()
    if IsValid(SceneMgr) then
      SceneMgr:ReceivedInputKey(Key, EventType)
    end
  end
  return AnyHandled.bHandled
end

function M:OnInputAxis_Lua(ControllerId, Key, Delta, DeltaTime, NumSamples, bGamepad)
  return false
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
