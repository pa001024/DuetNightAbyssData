local SecondaryPasswordController = require("BluePrints.UI.WBP.Common.Dialog_InputNum.SecondaryPasswordController")
local Component = {}

function Component:EnterWorld()
  SecondaryPasswordController:Init()
end

function Component:LeaveWorld()
  SecondaryPasswordController:Destroy()
end

function Component:SecondaryPasswordSwitch(callback, switch, onlyvalidateonce, password)
  self:CallServer("OnSecondaryPasswordSwitch", callback, switch, onlyvalidateonce, password)
end

function Component:SecondaryPasswordFreeze(timestamp)
  print("SecondaryPasswordFreeze: " .. timestamp)
end

function Component:ClientSecondaryPasswordValidateOnce(callback, password)
  self:CallServer("ClientSecondaryPasswordValidateOnce", callback, password)
end

return Component
