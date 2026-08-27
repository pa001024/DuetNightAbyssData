local Class = _G.TypeClass
local CustomTypes = require("BluePrints.Client.CustomTypes.CustomTypes")
local prop = require("NetworkEngine.Common.Prop")
local FormatProperties = require("NetworkEngine.Common.Assemble").FormatProperties
local FRESHMEN_GIFT_CHAR_ID_NONE = 0
local FreshmenGift = Class("FreshmenGift", CustomTypes.CustomAttr)
FreshmenGift.__Props__ = {
  FreshmenGiftCharId = prop.prop("Int", "client save", FRESHMEN_GIFT_CHAR_ID_NONE)
}

function FreshmenGift:GetFreshmenGiftCharId()
  return self.FreshmenGiftCharId or FRESHMEN_GIFT_CHAR_ID_NONE
end

function FreshmenGift:SetFreshmenGiftCharId(CharId)
  self.FreshmenGiftCharId = CharId or FRESHMEN_GIFT_CHAR_ID_NONE
end

function FreshmenGift:IsFreshmenGiftRewardGot()
  return self:GetFreshmenGiftCharId() > FRESHMEN_GIFT_CHAR_ID_NONE
end

FormatProperties(FreshmenGift)
return {FreshmenGift = FreshmenGift}
