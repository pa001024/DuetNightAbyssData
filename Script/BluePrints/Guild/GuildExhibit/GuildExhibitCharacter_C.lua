require("UnLua")
local GuildExhibitCharacter_C = Class({
  "BluePrints.Combat.Components.CharacterComponent"
})

function GuildExhibitCharacter_C:Initialize(Initializer)
  self.LuaTimerHandles = {}
end

local function BuildCharacterInitInfo(ItemInfo)
  local CharInfo = ItemInfo
  if not CharInfo then
    return nil
  end
  local Info = {
    FromOtherWorld = true,
    FromArmory = true,
    RoleId = CharInfo.CharId,
    SkinId = CharInfo.SkinId,
    HairId = CharInfo.HairId,
    AppearanceSuit = {
      IsCornerVisible = CharInfo.IsCornerVisible,
      IsShowPartMesh = CharInfo.IsShowPartMesh,
      AccessorySuit = CharInfo.AccessorySuit,
      Colors = CharInfo.Colors,
      SkinId = CharInfo.SkinId,
      HairId = CharInfo.HairId,
      SkinLevel = CharInfo.SkinLevel,
      HairColors = CharInfo.HairColors,
      AccessoryCustomParams = CharInfo.AccessoryCustomParams
    }
  }
  return Info
end

function GuildExhibitCharacter_C:InitForExhibit()
  local Avatar = GWorld and GWorld.GetAvatar and GWorld:GetAvatar()
  local ItemInfo = Avatar and Avatar.GetGuildExhibitItemInfo and Avatar:GetGuildExhibitItemInfo(self.ExhibitUuid)
  local Info = BuildCharacterInitInfo(ItemInfo)
  if not Info then
    print(_G.LogTag, "GuildExhibitCharacter_C:InitForExhibit Info is nil")
    return
  end
  self.CacheInfo = Info
  if Info.AppearanceSuit then
    self.CurrentSkinId = Info.AppearanceSuit.SkinId
  else
    self.CurrentSkinId = Info.SkinId
  end
  self.ShadowModelId = Info.ShadowModelId or 0
  self:PreInitInfo(Info)
  self:GuildExhibitPendingInit()
end

function GuildExhibitCharacter_C:GuildExhibitPendingInit()
  print(_G.LogTag, "GuildExhibitCharacter_C:GuildExhibitPendingInit")
  if not self.CacheInfo then
    return
  end
  local Info = self.CacheInfo
  if self.InitSuccess then
    return
  end
  Battle(self):AddEntity(self.Eid, self)
  self.ServerInitSuccess = true
  self.InitSuccess = true
  self.CurrentSkinId = Info.AppearanceSuit and Info.AppearanceSuit.SkinId or Info.SkinId
  self.ShadowModelId = Info.ShadowModelId or 0
  if self.CurrentCompositeMesh then
    self.CurrentCompositeMesh = nil
  end
  self:LoadCurrentModel()
  self:InitAppearanceSuit(Info.AppearanceSuit or self.AppearanceSuit)
  if self.InitCapsuleSize then
    self:InitCapsuleSize()
  end
  self.DontInitColor = true
  self:HandleModelFashion()
  if self.FromArmory and self.Mesh then
    self.Mesh.bComponentUseFixedSkelBounds = false
    self.Mesh.bHasValidBodies = true
  end
end

function GuildExhibitCharacter_C:ReceiveEndPlay(EndPlayReason)
  if self.LuaTimerHandles then
    for _, TimerHandle in pairs(self.LuaTimerHandles) do
      UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, TimerHandle)
    end
    self.LuaTimerHandles = {}
  end
end

return GuildExhibitCharacter_C
