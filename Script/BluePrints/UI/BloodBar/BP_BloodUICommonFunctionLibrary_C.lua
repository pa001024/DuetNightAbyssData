local BP_BloodUICommonFunctionLibrary_C = Class()

function BP_BloodUICommonFunctionLibrary_C:LoadRPGBloodBar_Lua(BossName, PlayerName)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:LoadUINew("FakeBloodBar", BossName, PlayerName)
end

function BP_BloodUICommonFunctionLibrary_C:SetRPGBossHpPercent_Lua(Percent)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if UIManager:GetUIObj("FakeBloodBar") then
    UIManager:GetUIObj("FakeBloodBar"):SetDisplayBossHpPercent(Percent, true)
  end
end

function BP_BloodUICommonFunctionLibrary_C:UnLoadRPGBloodBar_Lua()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if UIManager:GetUIObj("FakeBloodBar") then
    UIManager:GetUIObj("FakeBloodBar"):UnLoadSelf()
  end
end

return BP_BloodUICommonFunctionLibrary_C
