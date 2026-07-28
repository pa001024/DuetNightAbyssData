local ConditionUtils = require("BluePrints.Common.ConditionUtils")
local RougeProShopNpc = DungeonClass.Class()

function RougeProShopNpc:PostOnInit()
  self:InitReplicatedProperties(self, "ShopItems", {})
  self.NpcStaticPoint = nil
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
  print(string.format("RougeProShopNpc:InitShopItem Success. ShopItems = %s", CommonUtils.TableToString3(self.ShopItems)))
end

function RougeProShopNpc:GetTreasuresForRougeShop(TreasureNum, Rarity)
  local Result = {}
  for Eid, Player in self:PlayerIterator() do
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

function RougeProShopNpc:OnChangeRound()
  print("RougeProShopNpc:OnChangeRound")
  local RoomId = self:GetRougeProRoomId()
  local tabRoom = DataMgr.RougePro_Room[RoomId]
  assert(tabRoom)
  if tabRoom.ShopNpcList and 0 ~= #tabRoom.ShopNpcList then
    local RandomIndex = math.random(1, #tabRoom.ShopNpcList)
    self.NpcStaticPoint = tabRoom.ShopNpcList[RandomIndex]
    self:ActiveStaticCreator({
      self.NpcStaticPoint
    })
  end
  local CurRound = self.Round
  local tabSeason = DataMgr.RougeProSeason[self.SeasonId]
  assert(tabSeason)
  if tabSeason.ShopRandom and tabSeason.ShopRandom[CurRound] and next(tabSeason.ShopRandom[CurRound]) then
    local ShopRandomId = -1
    local TotalWeight = 0
    for id, weight in pairs(tabSeason.ShopRandom[CurRound]) do
      TotalWeight = TotalWeight + weight
    end
    local RandomWeight = math.random(0, TotalWeight)
    for id, weight in pairs(tabSeason.ShopRandom[CurRound]) do
      TotalWeight = TotalWeight - weight
      if TotalWeight <= 0 then
        ShopRandomId = id
        break
      end
    end
    if -1 ~= ShopRandomId then
      self:InitShopItem(ShopRandomId)
    end
  end
end

function RougeProShopNpc:OnRoundFinish()
  print("RougeProShopNpc:OnRoundFinish")
  if self.NpcStaticPoint then
    self:NotifyGameModeInActivateStaticCreator({
      self.NpcStaticPoint
    })
  end
  self.ShopItems = {}
end

function RougeProShopNpc:OnNotifyServerDungeonEvent_RougeProShopBuyItem(AvatarEid, ShopItemId)
  print(string.format("OnNotifyServerDungeonEvent_RougeProShopBuyItem AvatarEid=%s ShopItemId=%s", tostring(AvatarEid), tostring(ShopItemId)))
  local Player = self:GetPlayer(AvatarEid)
  assert(Player)
  local PlayerShopItemList = self.ShopItems[AvatarEid]
  assert(PlayerShopItemList)
  local tabTreasureData = DataMgr.RougeProTreasure[ShopItemId]
  assert(tabTreasureData)
  local IsExistShopItem = CommonUtils.HasValue(PlayerShopItemList, ShopItemId)
  assert(IsExistShopItem)
  local NotBoughtShopItem = CommonUtils.HasValue(Player.ShopItemBoughtList, ShopItemId) == false
  assert(NotBoughtShopItem)
  if Player.Token < tabTreasureData.ShopPrices then
    print(string.format("OnNotifyServerDungeonEvent_RougeProShopBuyItem Player.Token(%s) tabTreasureData.ShopPrices(%s)", tostring(Player.Token), tostring(tabTreasureData.ShopPrices)))
    return
  end
  if false == self:CanAddTreasureForPlayer(Player, ShopItemId) then
    print(string.format("OnNotifyServerDungeonEvent_RougeProShopBuyItem CanAddTreasureForPlayer == false AvatarEid=%s ShopItemId=%s", tostring(AvatarEid), tostring(ShopItemId)))
    return
  end
  Player:AddToken(-tabTreasureData.ShopPrices)
  self:AddTreasureForPlayer(Player, ShopItemId)
  table.insert(Player.ShopItemBoughtList, ShopItemId)
  self:NotifyGameModeDungeonEvent("RougeProShopBuyItem", AvatarEid, ShopItemId)
end

return RougeProShopNpc
