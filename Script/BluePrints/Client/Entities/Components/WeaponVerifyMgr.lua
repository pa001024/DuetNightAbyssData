local Component = {}
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")

local function RefreshStarRewardReddot()
  local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
  local EventId = Model.GetDefaultEventId()
  if not EventId then
    return
  end
  if not ActivityUtils.CheckEventIsOpen(EventId) then
    return
  end
  Model.RefreshStarRewardReddot(EventId)
end

function Component:EnterWorld()
  EventManager:AddEvent(EventID.OnLoginSuccess, self, self.OnLoginSuccess)
end

function Component:LeaveWorld()
  EventManager:RemoveEvent(EventID.OnLoginSuccess, self)
end

function Component:OnLoginSuccess()
  RefreshStarRewardReddot()
end

function Component:WeaponVerifySetSquad(EventId, DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId, CallBack)
  self.logger.info("WeaponVerifySetSquad", EventId, DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WeaponVerifySetSquad", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WeaponVerifySetSquad", Cb, EventId, DungeonId, CharUuid, MeleeWeaponUuid, RangedWeaponUuid, PetUniqueId, AffixId)
end

function Component:WeaponVerifyResetDungeon(EventId, DungeonId, CallBack)
  self.logger.info("WeaponVerifyResetDungeon", EventId, DungeonId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WeaponVerifyResetDungeon", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WeaponVerifyResetDungeon", Cb, EventId, DungeonId)
end

function Component:WeaponVerifyEnsureDungeonResult(EventId, DungeonId, bExchange, CallBack)
  self.logger.info("WeaponVerifyEnsureDungeonResult", EventId, DungeonId, bExchange)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    DebugPrint("WeaponVerifyEnsureDungeonResult", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WeaponVerifyEnsureDungeonResult", Cb, EventId, DungeonId, bExchange)
end

function Component:WeaponVerifyGetStarReward(EventId, RewardId, CallBack)
  self.logger.info("WeaponVerifyGetStarReward", EventId, RewardId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    if 0 == ErrCode then
      RefreshStarRewardReddot()
    end
    DebugPrint("WeaponVerifyGetStarReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WeaponVerifyGetStarReward", Cb, EventId, RewardId)
end

function Component:WeaponVerifyGetAllStarReward(EventId, CallBack)
  self.logger.info("WeaponVerifyGetAllStarReward", EventId)
  
  local function Cb(ErrCode, Ret)
    if CallBack then
      CallBack(ErrCode, Ret)
    end
    if 0 == ErrCode then
      RefreshStarRewardReddot()
    end
    DebugPrint("WeaponVerifyGetAllStarReward", ErrorCode:Name(ErrCode))
  end
  
  self:CallServer("WeaponVerifyGetAllStarReward", Cb, EventId)
end

return Component
