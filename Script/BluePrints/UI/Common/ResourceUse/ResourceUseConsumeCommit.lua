require("UnLua")
local BagCommon = require("BluePrints.UI.WBP.Bag.BagCommon")
local ResourceUseConsumeCommit = {}

local function ShowOptionalGetItem(UseEffectType, OptionalId, OptIndex, bIsNew, GetItemCloseCallback)
  local OptionalItemsDataConfig = DataMgr.OptReward[OptionalId]
  if "SelectWeapon" == UseEffectType then
    local WeaponChooseId = OptionalItemsDataConfig.Id[OptIndex]
    if WeaponChooseId then
      if GetItemCloseCallback then
        UIUtils.ShowGetItemPage(BagCommon.StuffType.Weapon, WeaponChooseId, 1, nil, nil, GetItemCloseCallback)
      else
        UIUtils.ShowGetItemPage(BagCommon.StuffType.Weapon, WeaponChooseId, 1)
      end
    end
  elseif "SelectCharacter" == UseEffectType then
    local CharChooseId = OptionalItemsDataConfig.Id[OptIndex]
    if CharChooseId then
      if GetItemCloseCallback then
        UIUtils.ShowGetItemPage("Char", CharChooseId, 1, nil, nil, GetItemCloseCallback, nil, nil, nil, bIsNew)
      else
        UIUtils.ShowGetItemPage("Char", CharChooseId, 1, nil, nil, nil, nil, nil, nil, bIsNew)
      end
    end
  elseif "SelectPet" == UseEffectType then
    local PetChooseId = OptionalItemsDataConfig.Id[OptIndex]
    if PetChooseId then
      local GameInstance = GWorld.GameInstance
      local UIManagerObj = GameInstance:GetGameUIManager()
      if GetItemCloseCallback then
        UIManagerObj:LoadUINew("GetItemPage", BagCommon.OptionalItemType.Pet, PetChooseId, 1, nil, GetItemCloseCallback, -1)
      else
        UIManagerObj:LoadUINew("GetItemPage", BagCommon.OptionalItemType.Pet, PetChooseId, 1, nil, -1, -1)
      end
    end
  end
end

function ResourceUseConsumeCommit.Items(Host, UseEffectType, UseParam, Extra)
  Extra = Extra or {}
  if not IsValid(Host) then
    return
  end
  local PlayerAvatar = GWorld:GetAvatar()
  if nil == PlayerAvatar then
    DebugPrint("ConfirmDealWithConsumableItems PlayerAvatar is nil, Not Connect to Server")
    return
  end
  if nil == Host.CurrentChooseInfo then
    DebugPrint("ConfirmDealWithConsumableItems error, CurrentChooseInfo is nil")
    return
  end
  DebugPrint("Now ConfirmDealWithConsumableItems The ChooseId is ", Host.CurrentChooseInfo.ChooseId)
  local ResourceId = Host.CurrentChooseInfo.ResourceId
  local OptionalId = Host.CurrentChooseInfo.OptionalId
  local OptIndex = 1
  for Index, Id in pairs(DataMgr.OptReward[UseParam].Id) do
    if Id == Host.CurrentChooseInfo.ChooseId then
      OptIndex = Index
      break
    end
  end
  local OptIdxList = {
    [OptIndex] = 1
  }
  local bIsNew = true
  if "SelectCharacter" == UseEffectType then
    bIsNew = not PlayerAvatar:CheckCharEnough({
      [Host.CurrentChooseInfo.ChooseId] = 1
    })
  end
  PlayerAvatar:UseOptResourceInBag(ResourceId, OptIdxList, function()
    if not IsValid(Host) then
      return
    end
    ShowOptionalGetItem(UseEffectType, OptionalId, OptIndex, bIsNew, Extra.GetItemCloseCallback)
    if Extra.OnAfterSuccess then
      Extra.OnAfterSuccess(ResourceId)
    end
  end)
  Host.CurrentChooseInfo = nil
end

return ResourceUseConsumeCommit
