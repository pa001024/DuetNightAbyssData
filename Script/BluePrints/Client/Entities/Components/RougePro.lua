local Component = {}

function Component:GmRougeProSetProfession(ProfessionId)
  ProfessionId = tonumber(ProfessionId)
  if not ProfessionId then
    print("GmRougeProSetProfession: 需要 ProfessionId，例 gm A:GmRougeProSetProfession(1)")
    return
  end
  if self.Eid == nil then
    print("GmRougeProSetProfession: 无 Eid")
    return
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode or not GameMode.NotifyServerDungeonEvent then
    print("GmRougeProSetProfession: GameMode 不可用或未混入 DungeonObjectComponent")
    return
  end
  GameMode:NotifyServerDungeonEvent("GMSetRougeProProfession", self.Eid, ProfessionId)
end

function Component:GmRougeProStartGame()
  local GameMode = UE4.UGameplayStatics.GetGameMode(GWorld.GameInstance)
  if not GameMode or not GameMode.NotifyServerDungeonEvent then
    print("GmRougeProStartGame: GameMode 不可用或未混入 DungeonObjectComponent")
    return
  end
  GameMode:NotifyServerDungeonEvent("GMRougeProStartGame")
end

return Component
