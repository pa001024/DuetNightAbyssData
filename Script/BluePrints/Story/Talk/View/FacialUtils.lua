require("DataMgr")
local FacialUtils = {}
local LogType = UE.EStoryLogType.NPC

function FacialUtils:GetNpcFacialPrefix(DialogueId, NpcId)
  if not NpcId then
    return nil
  end
  NpcId = URuntimeCommonFunctionLibrary.GetNPCIdByGender(GWorld.GameInstance, NpcId)
  if not NpcId then
    local Message = string.format("获取Npc表情Id失败，NpcId无效，反馈策划检查配置，台本编号：%s，NpcId：%s", DialogueId, NpcId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "获取Npc表情Id失败: NpcId无效", Message)
    return
  end
  local NpcData = DataMgr.Npc[NpcId]
  if not NpcData then
    local Message = string.format("获取Npc表情Id失败，Npc数据无效，反馈策划检查配置，台本编号：%s，Npc编号：%s", DialogueId, NpcId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "获取Npc表情Id失败: NpcData无效", Message)
    return
  end
  local ModelId = NpcData.ModelId
  if not ModelId then
    local Message = string.format("获取Npc表情Id失败，模型Id无效，反馈策划检查配置，台本编号：%s，Npc编号：%s", DialogueId, NpcId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "获取Npc表情Id失败: ModelId无效", Message)
    return
  end
  local ModelData = DataMgr.Model[ModelId]
  if not ModelData then
    local Message = string.format("获取Npc表情Id失败，模型数据无效，反馈策划检查配置，台本编号：%s，Npc编号：%s，模型Id：%s", DialogueId, NpcId, ModelId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "获取Npc表情Id失败: ModelData无效", Message)
    return
  end
  if not ModelData.AvatarExpressionPrefix then
    local Message = string.format("获取Npc表情Id失败，模型数据中没有AvatarExpressionPrefix，反馈策划检查配置，台本编号：%s，Npc编号：%s，模型Id：%s", DialogueId, NpcId, ModelId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, LogType, "获取Npc表情Id失败: 未找到AvatarExpressionPrefix", Message)
    return
  end
  return ModelData.AvatarExpressionPrefix
end

return FacialUtils
