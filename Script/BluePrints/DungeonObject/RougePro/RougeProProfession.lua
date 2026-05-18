local RougeProProfession = DungeonClass.Class()

function RougeProProfession:SelectProfession(AvatarEid, Profession)
  local Avatar = self:GetPlayer(AvatarEid)
  if not Avatar then
    self:Log("SelectProfession but Player is not exist")
    return false
  end
  Avatar:SetRougeProProfession(Profession)
end

function RougeProProfession:ActivateProfessionEffect()
  self:Log("ActivateProfessionEffect")
  local BondCount = DataMgr.GlobalConstant.RougeProBondPlayers.ConstantValue
  local ProfessionCount = {}
  for _, Player in self:PlayerIterator() do
    local Profession = Player:GetRougeProProfession()
    ProfessionCount[Profession] = (ProfessionCount[Profession] or 0) + 1
  end
  for _, Player in self:PlayerIterator() do
    local Profession = Player:GetRougeProProfession()
    local DataInfo = DataMgr.RougeProClass[Profession]
    if DataInfo then
      self:ActivateRougeProEffects(Player, DataInfo.Effect)
      if BondCount <= ProfessionCount[Profession] then
        self:ActivateRougeProEffects(Player, DataInfo.BondEffect)
      end
    else
      self:Log("Error::Cannot find RougeProClass DataInfo", Profession)
    end
  end
end

return RougeProProfession
