local TalkActionData_C = {}

function TalkActionData_C.New(TalkActionId)
  local Obj = setmetatable({}, {})
  local Data = DataMgr.TalkAction[TalkActionId]
  if nil == Data then
    local Message = string.format("TalkActionData_C.New 执行失败, 对话动作编号 %s 在 DataMgr.TalkAction 中不存在。", TalkActionId)
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.TalkAction, "TalkActionData创建失败: TalkActionId不在表中", Message)
    return nil
  end
  Obj.TalkActionId = TalkActionId
  Obj.IsSpecialAction = Data.IsSpecialAnim
  Obj.ActionMontage = Data.ActionMontage
  Obj.MontageSection = Data.MontageSection
  Obj.BlendInTime = Data.BlendInTime
  Obj.BlendOutTime = Data.BlendOutTime
  Obj.EndLoopMontage = Data.EndLoopMontage
  Obj.EndLoopMontageSection = Data.EndLoopMontageSection
  Obj.IsOnceAction = Data.IsOnceAction
  return Obj
end

local function CreateTalkActionData(TalkActorId, TalkActionId)
  DebugPrint("Play action", TalkActorId, TalkActionId)
  return TalkActionData_C.New(TalkActionId)
end

return {CreateTalkActionData = CreateTalkActionData, TalkActionData_C = TalkActionData_C}
