local MonthSignInModel = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInModel")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
  self:BindMonthSignInEvent()
end

function M:Destory()
  M.Super.Destory(self)
  self:UnBindMonthSignInEvent()
end

function M:GetModel()
  return MonthSignInModel
end

function M:GetEventName()
  return nil
end

function M:OpenView(WorldContex, Param)
  return M.Super.OpenView(self, WorldContex, MonthSignInCommon.UIName, Param)
end

function M:GetView(WorldContex)
  return M.Super.GetView(self, WorldContex, MonthSignInCommon.UIName)
end

function M:TryPopUpMonthSignIn()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local UIUnlocked = Avatar:CheckUIUnlocked("MonthSignIn")
  if not UIUnlocked then
    return
  end
  local PreCheckCount = EMCache:Get("PreCheckCount", true)
  if not PreCheckCount then
    self:GetUIMgr():LoadUINew("MonthSignInPopMain")
  else
    DebugPrint("Yihan@ TryPopUpMonthSignIn", PreCheckCount ~= Avatar.MonthlyCheck.MonthlyCheckCount)
    if PreCheckCount ~= Avatar.MonthlyCheck.MonthlyCheckCount then
      self:GetUIMgr():LoadUINew("MonthSignInPopMain")
    end
  end
end

function M:BindMonthSignInEvent()
  EventManager:AddEvent(EventID.OnRefreshWithNextDay, self, self.OnRefreshInNextDay)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or self.MonthSignInUnlockKey then
    return
  end
  if Avatar:CheckUIUnlocked("MonthSignIn") then
    return
  end
  self.MonthSignInUnlockKey = Avatar:BindOnUIFirstTimeUnlock("MonthSignIn", function()
    self:UnBindMonthSignInEvent()
    self:TryPopUpMonthSignIn()
  end)
end

function M:UnBindMonthSignInEvent()
  EventManager:RemoveEvent(EventID.OnRefreshWithNextDay, self)
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not self.MonthSignInUnlockKey then
    return
  end
  Avatar:UnBindOnUIFirstTimeUnlock("MonthSignIn", self.MonthSignInUnlockKey)
  self.MonthSignInUnlockKey = nil
end

function M:OnRefreshInNextDay()
  local PopMain = UIManager(self):GetUIObj("MonthSignInPopMain")
  DebugPrint("Yihan@ OnRefreshInNextDay", PopMain)
  if not PopMain then
    self:TryPopUpMonthSignIn()
  else
    EventManager:FireEvent(MonthSignInCommon.EventId.RefreshInNextDay)
  end
end

function M:PlayGetAnimation()
  DebugPrint("Yihan@ PlayGetAnimation")
  EventManager:FireEvent(MonthSignInCommon.EventId.PlayGetAnimation)
end

_G.MonthSignInController = M
return M
