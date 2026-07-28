require("UnLua")
local BP_Chest_RougePro_C = Class("BluePrints.Item.Chest.BP_ChestBase_C")

function BP_Chest_RougePro_C:OnActorReady(Info)
  BP_Chest_RougePro_C.Super.OnActorReady(self, Info)
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if not GameMode then
    return
  end
  GameMode:TriggerDungeonObjectFunc("OnRougeProChestReady", self)
end

return BP_Chest_RougePro_C
