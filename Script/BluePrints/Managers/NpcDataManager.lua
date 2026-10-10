require("DataMgr")

local function GetPortraitFacialId(NpcId, PortraitFacialType)
  if not NpcId then
    return nil
  end
  if not PortraitFacialType or "" == PortraitFacialType then
    return nil
  end
  local FinalNpcId = URuntimeCommonFunctionLibrary.GetFinalNPCIdByMapping(GWorld.GameInstance, NpcId)
  if not FinalNpcId then
    return nil
  end
  local NpcData = DataMgr.Npc[FinalNpcId]
  if not NpcData then
    return nil
  end
  local ModelId = NpcData.ModelId
  if not ModelId then
    return nil
  end
  local ModelData = DataMgr.Model[ModelId]
  if not ModelData then
    return nil
  end
  local Prefix = ModelData.AvatarExpressionPrefix
  if not Prefix then
    return nil
  end
  return Prefix .. PortraitFacialType
end

local M = {}

function M:GetPortraitFacialRow(NpcId, PortraitFacialType)
  if not PortraitFacialType or "" == PortraitFacialType or "None" == PortraitFacialType then
    return nil
  end
  local PortraitFacialId = GetPortraitFacialId(NpcId, PortraitFacialType)
  if not PortraitFacialId then
    return nil
  end
  return DataMgr.PortraitFacial[PortraitFacialId]
end

return M
