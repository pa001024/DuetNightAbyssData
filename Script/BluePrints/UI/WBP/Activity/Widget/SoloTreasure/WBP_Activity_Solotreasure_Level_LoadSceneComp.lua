local Component = {}
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local ComboSequencePath = {
  [1] = "/Game/UI/Sequence/SQ_FengXiang_GUI1.SQ_FengXiang_GUI1",
  [2] = "/Game/UI/Sequence/SQ_FengXiang_GUI2.SQ_FengXiang_GUI2",
  [3] = "/Game/UI/Sequence/SQ_FengXiang_GUI3.SQ_FengXiang_GUI3"
}
local Stage2Combo = {
  [1] = 3,
  [2] = 1,
  [3] = 1,
  [4] = 1,
  [5] = 2
}

function Component:LoadSkyBoxScene(NewResult)
  self.NewResult = NewResult
  self.PlayerCurState = self:GetPlayerState(NewResult)
  self:CreateActorController()
  if not self.ActorController then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("Avatar nil")
    return
  end
  local Sex = Avatar.Sex
  local CharId = DataMgr.Player2RoleId.Player[Sex]
  if CharId then
    self.ActorController:ChangeCharModel({CharId = CharId}, true, true)
    self.ActorController:ChangeCharAppearance({})
  end
  if self.ActorController.TryCreateSequenceActorController then
    self.ActorController:TryCreateSequenceActorController()
  end
  self:LoadSceneSequence()
end

function Component:GetPlayerState(NewResult)
  if NewResult and NewResult.CurStageIndex then
    return NewResult.CurStageIndex
  end
  return nil
end

function Component:CreateActorController()
  if self.ActorController then
    return
  end
  self.ActorController = ActorController:New({
    ViewUI = self.Root,
    IsPreviewMode = true,
    bEnableReflection = false,
    EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewSoloTreasure
  })
  if self.ActorController then
    self.ActorController:OnOpened(0)
  end
end

function Component:LoadSceneSequence()
  if not self.ActorController then
    return
  end
  local Stage = self.PlayerCurState
  if not Stage then
    return
  end
  local Combo = Stage2Combo[Stage] or 1
  local SeqPath = ComboSequencePath[Combo]
  if not SeqPath or "" == SeqPath then
    return
  end
  if self.CurSequencePath == SeqPath then
  end
  self.CurSequencePath = SeqPath
  self.ActorController:PlaySequence({
    SequencePath = SeqPath,
    MontagePath = "Story_Fengxiang_Montage",
    ActorRotation = FRotator(0, -68.31257629999999, 0)
  })
end

return Component
