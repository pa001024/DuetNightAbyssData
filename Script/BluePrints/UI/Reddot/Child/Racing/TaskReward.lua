local M = Class("BluePrints.UI.Reddot.ReddotTreeNode")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")

function M:OnInitNodeCache(NodeCache)
  EventManager:AddEvent(EventID.OnActivityTimeOpenClose, self, self.OnRefreshWithActivityClose)
end

function M:OnDisposeNode()
  EventManager:RemoveEvent(EventID.OnActivityTimeOpenClose, self)
end

function M:OnRefreshWithActivityClose(ActivityID)
  if ActivityID == RacingActivityConst.ActivityEventId then
    ReddotManager.ClearLeafNodeCount(self.Name, true)
  end
end

return M
