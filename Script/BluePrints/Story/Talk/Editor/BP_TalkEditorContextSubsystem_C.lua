local M = Class()

function M:InitNpcCharacter(NpcCharacter)
  if not IsValid(NpcCharacter) then
    return
  end
  NpcCharacter:PreEnterStory({}, false, true, true)
  NpcCharacter:AddTimer(0.01, function()
    NpcCharacter:StopBT("Talk")
    if IsValid(NpcCharacter.Controller) and IsValid(NpcCharacter.Controller.Blackboard) then
      NpcCharacter.Controller.Blackboard:ClearValue("Target")
    end
  end)
end

function M:OnTalkSequenceContextInitialized()
  local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
  GMFunctionLibrary.SetPlayerGhost(GWorld.GameInstance, true)
  local TS = TalkSubsystem()
  TS:TryFireEnterStoryEvent()
end

function M:OnTalkSequenceContextCleanup()
  local GMFunctionLibrary = require("BluePrints.UI.GMInterface.GMFunctionLibrary")
  GMFunctionLibrary.SetPlayerGhost(GWorld.GameInstance, false)
  local TS = TalkSubsystem()
  TS:TryFireLeaveStoryEvent()
end

function M:GetNpcWithGender(NpcId)
  if not NpcId then
    return
  end
  if IsValid(self.EditorBindingNpc:Find(NpcId)) then
    return self.EditorBindingNpc:Find(NpcId)
  end
  local NpcData = DataMgr.Npc[NpcId]
  if NpcData and NpcData.Gender and NpcData.RelateNpcId then
    return self.EditorBindingNpc:Find(NpcData.RelateNpcId)
  end
end

function M:InitGenderVoice(Gender, ExGender)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    return
  end
  local GameInstance = GWorld.GameInstance
  if not GameInstance then
    return
  end
  local AudioManager = AudioManager(GameInstance)
  if not AudioManager then
    return
  end
  if not self.OldGetGender then
    self.OldGetGender = AudioManager.GetGender
  end
  self.Gender = Gender
  self.ExGender = ExGender
  
  local function NewGetGender(_, bExGender)
    local UTalkEditorContextSubSystem = UE4.UTalkEditorContextSubSystem
    local EditorSystem = UTalkEditorContextSubSystem.GetSubsystem()
    local InnerGender = EditorSystem.Gender
    local InnerExGender = EditorSystem.ExGender
    if bExGender then
      if 1 == InnerExGender then
        return "_f"
      else
        return "_m"
      end
    elseif 1 == InnerGender then
      return "_f"
    else
      return "_m"
    end
  end
  
  local AudioManagerReplace = require("BluePrints.Managers.BP_AudioManager_C")
  local HotFix = require("HotFix")
  HotFix.HotFix(AudioManagerReplace, "GetGender", NewGetGender)
end

function M:ClearGenderVoice()
  local GameInstance = GWorld.GameInstance
  if not GameInstance then
    return
  end
  local AudioManager = AudioManager(GameInstance)
  if not AudioManager then
    return
  end
  if self.OldGetGender then
    local AudioManagerReplace = require("BluePrints.Managers.BP_AudioManager_C")
    local HotFix = require("HotFix")
    HotFix.HotFix(AudioManagerReplace, "GetGender", self.OldGetGender)
    AudioManager.GetGender = self.OldGetGender
    self.OldGetGender = nil
  end
end

return M
