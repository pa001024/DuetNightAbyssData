local FFlowDialogue = {}

function FFlowDialogue.New(DialogueData, DialogueSetting, DialogueSection)
  local function GetRawData(Key)
    if DialogueSection and nil ~= DialogueSection[Key] then
      return DialogueSection[Key]
    end
    if DialogueData and nil ~= DialogueData[Key] then
      return DialogueData[Key]
    end
    if DialogueSetting and nil ~= DialogueSetting[Key] then
      return DialogueSetting[Key]
    end
    return FFlowDialogue[Key]
  end
  
  local Obj = setmetatable({}, {
    __index = function(t, Key)
      local Value = GetRawData(Key)
      if Value then
        rawset(t, Key, Value)
      end
      return Value
    end
  })
  Obj.bForbiddenDSL = false
  Obj.bWaitAsyncTag = false
  if DialogueSection then
    Obj.EnableSkip = DialogueSection.EnableSkip
  else
    Obj.EnableSkip = true
  end
  return Obj
end

function FFlowDialogue:BindOnDialogueFinish(Func)
  self.OnDialogueFinish = Func
end

function FFlowDialogue:ExecuteOnDialogueFinish(...)
  if self.OnDialogueFinish then
    self.OnDialogueFinish(...)
  end
end

function FFlowDialogue:BindOnForceCompleteDialogue(Func)
  self.OnForceCompleteDialogue = Func
end

function FFlowDialogue:ExecuteOnForceCompleteDialogue(...)
  if self.OnForceCompleteDialogue then
    self.OnForceCompleteDialogue(...)
  end
end

function FFlowDialogue:IsForbiddenDSL()
  return self.bForbiddenDSL
end

function FFlowDialogue:SetForbiddenDSL(bValue)
  self.bForbiddenDSL = bValue
end

function FFlowDialogue:IsWaitAsyncTag()
  return self.bWaitAsyncTag
end

function FFlowDialogue:SetWaitAsyncTag(bValue)
  self.bWaitAsyncTag = bValue
end

function FFlowDialogue:SetAutoToNext()
  self.bAutoToNext = true
end

function FFlowDialogue:NeedAutoToNext()
  return self.bAutoToNext
end

function FFlowDialogue:SetEnableSkip(bValue)
  self.EnableSkip = bValue
end

function FFlowDialogue:SetOverrideDuration()
  self.DisableDuration = true
end

return {FFlowDialogue = FFlowDialogue}
