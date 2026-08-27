require("UnLua")
local CoopUtils = {}
local AsyncCombatDebuffTitle = "AsyncCombatDebuffTitle"
local Hyphen = "Hyphen"
local AsyncCombatDebuffLevel = "AsyncCombatDebuffLevel"

function CoopUtils.GetGTextDebuffTitle(AsyncCombatComponent)
  if not AsyncCombatComponent then
    return nil
  end
  local BuffLevel = 1
  if AsyncCombatComponent.CurTimeBuffId and AsyncCombatComponent.TimeBuffConfig then
    local BuffIndex = 1
    for _, BuffConfig in pairs(AsyncCombatComponent.TimeBuffConfig) do
      if BuffConfig.buffId and tonumber(BuffConfig.buffId) == tonumber(AsyncCombatComponent.CurTimeBuffId) then
        break
      end
      BuffIndex = BuffIndex + 1
    end
    BuffLevel = BuffIndex
  end
  local GTextAsyncCombatDebuffTitle = GText(AsyncCombatDebuffTitle)
  local GTextHyphen = GText(Hyphen)
  local Suffix = AsyncCombatDebuffLevel .. tostring(BuffLevel)
  return GTextAsyncCombatDebuffTitle .. " " .. GTextHyphen .. " " .. GText(Suffix)
end

function CoopUtils.GetMyProgress()
  local bPersonal = UIUtils.IsInAsyncPersonalRoom()
  if nil == bPersonal then
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode then
    return
  end
  local AsyncCombatComponent = GameMode:GetDungeonComponent()
  if not AsyncCombatComponent then
    return
  end
  if bPersonal then
    local SnapShot = AsyncCombatComponent:GetSingleModeProgressSnapshot()
    return SnapShot.Progress
  else
    return GWorld.GameInstance[CommonConst.DungeonSyncMsg.AsyncCombatRoomStateUpdate] and GWorld.GameInstance[CommonConst.DungeonSyncMsg.AsyncCombatRoomStateUpdate].Progress
  end
end

return CoopUtils
