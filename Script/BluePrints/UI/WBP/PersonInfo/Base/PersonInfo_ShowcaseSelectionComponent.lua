require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local PersonInfoModel = PersonInfoController:GetModel()
local M = {}

function M:TrySelectShowcaseEntityByPointer()
  return false
end

return M
