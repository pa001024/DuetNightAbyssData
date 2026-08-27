local M = Class("StoryCreator.StoryLogic.StorylineNodes.BaseAsynQuestNode")

function M:Init()
  self.CreatorId = 0
  self.ManualItemId = 0
end

function M:Execute(Callback)
  self.Callback = Callback
  EventManager:AddEvent(EventID.OnPhotoSpotShot, self, self.OnPhotoSpotShot)
end

function M:OnPhotoSpotShot(CreatorId, ManualItemId, PhotoAtPlaceId)
  if 0 ~= self.CreatorId and CreatorId == self.CreatorId or 0 ~= self.ManualItemId and ManualItemId == self.ManualItemId then
    self.Callback("Success")
  end
end

function M:Clear()
  EventManager:RemoveEvent(EventID.OnPhotoSpotShot, self)
end

return M
