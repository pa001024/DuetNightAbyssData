require("UnLua")
local CommonConst = require("CommonConst")
local ResourceUseConsumeFlow = require("BluePrints.UI.Common.ResourceUse.ResourceUseConsumeFlow")
local ResourceRoleRenameCardFlow = require("BluePrints.UI.Common.ResourceUse.ResourceRoleRenameCardFlow")
local ResourceUseEffectDispatcher = {}
local ResUseEffectType = CommonConst.ResUseEffectType
local ConsumeTypeHandler = ResourceUseConsumeFlow.TypeHandler

function ResourceUseEffectDispatcher.HandleChangeName(Host, StuffConfigData, Extra)
  ResourceRoleRenameCardFlow.Open(Host, StuffConfigData, Extra)
end

function ResourceUseEffectDispatcher.HandleChangeGuildName(Host, StuffConfigData)
  local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
  GuildController:TryOpenGuildRenameCardDialog(StuffConfigData.ResourceId, Host)
end

function ResourceUseEffectDispatcher.HandleCharSkinPreview(Host, StuffConfigData, Extra)
  Extra = Extra or {}
  if not IsValid(Host) or not StuffConfigData then
    return
  end
  Host.CurrentChooseInfo = nil
  local PreviewParams = {
    Type = StuffConfigData.UseEffectType,
    OptRewardId = StuffConfigData.UseParam,
    ResourceId = StuffConfigData.ResourceId
  }
  if Extra.OnClose then
    PreviewParams.CloseCallback = Extra.OnClose
  end
  UIManager(Host):LoadUINew("CharSkinPreview", PreviewParams)
end

function ResourceUseEffectDispatcher.HandleConsume(Host, StuffConfigData, Extra)
  ResourceUseConsumeFlow.Open(Host, StuffConfigData, Extra, ConsumeTypeHandler[StuffConfigData.UseEffectType])
end

local Handlers = {
  [ResUseEffectType.ChangeName] = ResourceUseEffectDispatcher.HandleChangeName,
  [ResUseEffectType.ChangeGuildName] = ResourceUseEffectDispatcher.HandleChangeGuildName,
  [ResUseEffectType.SelectGeneralSkin] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectCharAccessory] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectWeaponSkin] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectWeaponAccessory] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectSkin] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectGestureItem] = ResourceUseEffectDispatcher.HandleCharSkinPreview,
  [ResUseEffectType.SelectWeapon] = ResourceUseEffectDispatcher.HandleConsume,
  [ResUseEffectType.SelectCharacter] = ResourceUseEffectDispatcher.HandleConsume,
  [ResUseEffectType.SelectPet] = ResourceUseEffectDispatcher.HandleConsume,
  [ResUseEffectType.SelectResource] = ResourceUseEffectDispatcher.HandleConsume,
  [ResUseEffectType.ResourcePack] = ResourceUseEffectDispatcher.HandleConsume,
  [ResUseEffectType.RandomSelectPack] = ResourceUseEffectDispatcher.HandleConsume
}

function ResourceUseEffectDispatcher.TryHandle(Host, StuffConfigData, Extra)
  if not StuffConfigData then
    return false
  end
  local UseEffectType = StuffConfigData.UseEffectType
  local Handler = Handlers[UseEffectType]
  if Handler then
    Handler(Host, StuffConfigData, Extra)
    return true
  end
  local ConsumeHandler = ConsumeTypeHandler[UseEffectType]
  if ConsumeHandler then
    ResourceUseConsumeFlow.Open(Host, StuffConfigData, Extra, ConsumeHandler)
    return true
  end
  if UseEffectType then
    for _, TypeName in pairs(ResUseEffectType) do
      if TypeName == UseEffectType then
        DebugPrint("ResourceUseEffectDispatcher unhandled UseEffectType", UseEffectType)
        return false
      end
    end
  end
  ResourceUseConsumeFlow.Open(Host, StuffConfigData, Extra)
  return true
end

return ResourceUseEffectDispatcher
