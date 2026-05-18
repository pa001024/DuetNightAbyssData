local BattleDumpUtils = require("BluePrints.Client.BattleDumpUtils")
local Component = {}

function Component:GetSquadCreateInfoByNow(ExtraInfo)
  self.logger.debug("GetSquadCreateInfoByNow")
  local ResInfo = {}
  if self.CurrentChar then
    ResInfo.Char = self.Chars[self.CurrentChar]
    if ResInfo.Char then
      ResInfo.CharModSuit = ResInfo.Char.ModSuitIndex
      ResInfo.UltraWeapons = BattleDumpUtils:GetDefaultUltraWeaponInfo(self, ResInfo.Char)
    end
  end
  if self.MeleeWeapon then
    ResInfo.MeleeWeapon = self.Weapons[self.MeleeWeapon]
    if ResInfo.MeleeWeapon then
      ResInfo.MeleeWeaponModSuit = ResInfo.MeleeWeapon.ModSuitIndex
    end
  end
  if self.RangedWeapon then
    ResInfo.RangedWeapon = self.Weapons[self.RangedWeapon]
    if ResInfo.RangedWeapon then
      ResInfo.RangedWeaponModSuit = ResInfo.RangedWeapon.ModSuitIndex
    end
  end
  ResInfo.WheelIndex = self.WheelIndex
  return ResInfo
end

function Component:ReShapeSquadInfo(Avatar, Squad)
  local Info = {
    Char = Avatar.Chars[Squad.Char],
    CharModSuit = Squad.ModSuit,
    MeleeWeapon = Avatar.Weapons[Squad.MeleeWeapon],
    MeleeWeaponModSuit = Squad.MeleeWeaponModSuit,
    RangedWeapon = Avatar.Weapons[Squad.RangedWeapon],
    RangedWeaponModSuit = Squad.RangedWeaponModSuit,
    Pet = Avatar.Pets[Squad.Pet],
    WheelIndex = Squad.WheelIndex,
    Phantom1 = Squad.Phantom1,
    PhantomWeapon1 = Squad.PhantomWeapon1,
    Phantom2 = Squad.Phantom2,
    PhantomWeapon2 = Squad.PhantomWeapon2
  }
  if Info.Char then
    Info.UltraWeapons = BattleDumpUtils:GetDefaultUltraWeaponInfo(Avatar, Info.Char)
  end
  return Info
end

function Component:GetSquadCreateInfoByExtra(ExtraInfo)
  local ResInfo = {
    Char = self.CurrentChar,
    ModSuit = ExtraInfo.CharModSuit or self.Chars[self.CurrentChar].ModSuitIndex,
    MeleeWeapon = self.MeleeWeapon,
    MeleeWeaponModSuit = ExtraInfo.MeleeWeaponModSuit or self.Weapons[self.MeleeWeapon].ModSuitIndex,
    RangedWeapon = self.RangedWeapon,
    RangedWeaponModSuit = ExtraInfo.RangedWeaponModSuit or self.Weapons[self.RangedWeapon].ModSuitIndex,
    WheelIndex = self.WheelIndex,
    Phantom1 = ExtraInfo.Phantom1,
    Phantom2 = ExtraInfo.Phantom2,
    PhantomWeapon1 = ExtraInfo.PhantomWeapon1,
    PhantomWeapon2 = ExtraInfo.PhantomWeapon2,
    Pet = ExtraInfo.Pet
  }
  return ResInfo
end

return Component
