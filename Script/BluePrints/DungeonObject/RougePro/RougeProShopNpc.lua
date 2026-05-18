local RougeProShopNpc = DungeonClass.Class()

function RougeProShopNpc:PostOnInit()
  self:InitReplicatedProperties(self, "ShopItems", {})
end

function RougeProShopNpc:InitShopItem(ShopRandomId)
  local ShopInfo = DataMgr.RougeProShopRandom[ShopRandomId]
  if not ShopInfo then
    print("InitShopItem cannot find ShopRandomId", ShopRandomId)
    return
  end
  local TreasureRange = ShopInfo.Treasure
  if not TreasureRange then
    return
  end
  local TreasureNum = math.random(TreasureRange[1], TreasureRange[2])
  self.ShopItems = self:GetTreasuresForRougeShop(TreasureNum, ShopInfo.Rarity)
end

function RougeProShopNpc:GetTreasuresForRougeShop(TreasureNum, Rarity)
  local Result = {}
  for Eid, Player in self.DungeonObject:PlayerIterator() do
    Result[Eid] = self:GetTreasuresForRougeShopByPlayer(TreasureNum, Rarity, Player)
  end
  return Result
end

function RougeProShopNpc:GetTreasuresForRougeShopByPlayer(TreasureNum, Rarity, Player)
  local OptionalList = {}
  local OptionalWeightSum = 0
  
  local function CheckRarity(TreasureInfo)
    if not Rarity then
      return true
    end
    return CommonUtils.HasValue(Rarity, TreasureInfo.TreasureRarity)
  end
  
  for Id, TreasureInfo in pairs(DataMgr.RougeProTreasure) do
    if TreasureInfo.CanSell and CheckRarity(TreasureInfo) and ConditionUtils.CheckCondition(Player, TreasureInfo.InCondition) and not Player:HasRougeProTreasure(Id) then
      OptionalList[#OptionalList + 1] = Id
      OptionalWeightSum = OptionalWeightSum + TreasureInfo.ShopWeight
    end
  end
  local ResultList = {}
  for i = 1, TreasureNum do
    if OptionalWeightSum < 1 then
      break
    end
    local RandomResult = math.random(1, OptionalWeightSum)
    for j = 1, #OptionalList do
      local Id = OptionalList[j]
      if Id >= 0 then
        local Weight = DataMgr.RougeProTreasure[Id].ShopWeight
        if RandomResult > Weight then
          RandomResult = RandomResult - Weight
        else
          ResultList[i] = Id
          OptionalList[j] = -1
          OptionalWeightSum = OptionalWeightSum - Weight
          break
        end
      end
    end
  end
  return ResultList
end

return RougeProShopNpc
