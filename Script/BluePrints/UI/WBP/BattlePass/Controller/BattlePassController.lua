local BattlePassModel = require("BluePrints.UI.WBP.BattlePass.Model.BattlePassModel")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:GetModel()
  return BattlePassModel
end

function M:GetEventName()
  return "BattlePass"
end

function M:SetModelData(Name, Value)
  return BattlePassModel:SetModelData(Name, Value)
end

function M:GetModelData(Name, DefaultValue)
  return BattlePassModel:GetModelData(Name, DefaultValue)
end

return M
