require("UnLua")
local Component = Class()

function Component:GetCurrentModelInfo()
  return DataMgr.Model[self.Owner.ModelId]
end

function Component:GetCurrentKawaiiLinkLayer(Id)
  local ModelId = Id
  ModelId = ModelId or DataMgr.BattleChar[self.CurrentRoleId].ModelId
  if not DataMgr.Model[ModelId] then
    return
  end
  local LinkLayerPath = DataMgr.Model[ModelId].LinkLayerPath
  return LinkLayerPath
end

function Component:GetNPCServerSkinIdByUnitId(NpcId, ConmmonSkinId)
  if not NpcId or not DataMgr.Npc[NpcId] then
    return 0
  end
  local NpcInfo = DataMgr.Npc[NpcId]
  if NpcInfo.PlayerInfo and NpcInfo.CharId ~= nil or NpcInfo.NpcType == "Show" and NpcInfo.CharId ~= nil then
    local CharId = NpcInfo.CharId
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return 0
    end
    local SkinId
    for key, Char in pairs(Avatar.Chars) do
      if Char.CharId == CharId then
        local Appearance = Char.AppearanceSuits[Char.CurrentAppearanceIndex]
        SkinId = Appearance.SkinId
        break
      end
    end
    local CommonChar = Avatar.CommonChars[CharId]
    if nil == CommonChar then
      Utils.ScreenPrint("时装信息错误, CommonChars为空，CharId:" .. tostring(CharId))
      return 0
    end
    local Skin = CommonChar.OwnedSkins[SkinId]
    if nil == Skin then
      Utils.ScreenPrint("时装信息错误, OwnedSkins，SkinId::" .. tostring(SkinId))
      return 0
    end
    local SkinInfo = DataMgr.Skin[SkinId]
    if not SkinInfo or not SkinInfo.SkinModelId then
      return 0
    end
    if SkinInfo.CommonSkinSettingId then
      ConmmonSkinId = SkinInfo.CommonSkinSettingId
    else
      ConmmonSkinId = 0
    end
    return ConmmonSkinId, SkinInfo.SkinModelId
  end
  return 0
end

function Component:GetNPCServerSkinIdByNpcId(NpcId)
  local NpcInfo = DataMgr.Npc[NpcId]
  local CharId = NpcInfo.CharId
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 0
  end
  local SkinId = 0
  for key, Char in pairs(Avatar.Chars) do
    if Char.CharId == CharId then
      local Appearance = Char.AppearanceSuits[Char.CurrentAppearanceIndex]
      SkinId = Appearance.SkinId
      return SkinId
    end
  end
  return SkinId
end

function Component:GetRotationMontagePath()
  local ModelData = DataMgr.Model[self:GetCurrentModelId()]
  return ModelData.MontageFolder .. "Locomotion/" .. ModelData.MontagePrefix .. "Rotation_Montage"
end

function Component:HaveBodyId()
  return self.Owner and self.Owner.BodyId
end

return Component
