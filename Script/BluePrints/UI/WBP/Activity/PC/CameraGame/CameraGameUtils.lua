require("UnLua")
local ActivityUtils = require("Blueprints.UI.WBP.Activity.ActivityUtils")
local CameraGameUtils = {}

function CameraGameUtils.GetEventId()
  for EventId, _ in pairs(DataMgr.PhotoEvent) do
    if ActivityUtils.CheckEventIsInActiveTime(EventId) then
      return EventId
    end
  end
end

return CameraGameUtils
