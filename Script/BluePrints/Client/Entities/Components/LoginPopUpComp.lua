local Component = {}
local LoginPopUpModel = require("BluePrints.UI.WBP.Activity.Widget.AdvertisingPopUp.LoginPopUpModel")

function Component:LeaveWorld()
  LoginPopUpModel:Destory()
end

function Component:OnLoginSuccess()
  LoginPopUpModel:Init()
  LoginPopUpModel:SetLoginSuccess(true)
end

function Component:UpdateLoginPopUpRecord(PopId, Callback)
  self.logger.info("UpdateLoginPopUpRecord", PopId)
  Callback = Callback or function()
  end
  self:CallServer("UpdateLoginPopUpRecord", Callback, PopId)
end

function Component:SetLoginPopUpNoPopSevenDays(NoPopSevenDays, ActivityIds, Callback)
  if type(ActivityIds) == "function" and nil == Callback then
    Callback = ActivityIds
    ActivityIds = {}
  end
  self.logger.info("SetLoginPopUpNoPopSevenDays", NoPopSevenDays, ActivityIds)
  Callback = Callback or function()
  end
  self:CallServer("SetLoginPopUpNoPopSevenDays", Callback, NoPopSevenDays and true or false, ActivityIds or {})
end

return Component
