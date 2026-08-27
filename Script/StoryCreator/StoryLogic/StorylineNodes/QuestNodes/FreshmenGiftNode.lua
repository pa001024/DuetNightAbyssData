local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function M:Init()
end

function M:Execute(Callback)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint(_G.ErrorTag, "Freshmen gift node execute failed, avatar is nil")
    return
  end
  if Avatar.FreshmenGift and Avatar.FreshmenGift:IsFreshmenGiftRewardGot() then
    Callback()
    return
  end
  local Params = {}
  
  function Params.CloseChoosePageFun()
    Callback()
  end
  
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:LoadUINew("StoryOptionalAvatar", Params)
end

return M
