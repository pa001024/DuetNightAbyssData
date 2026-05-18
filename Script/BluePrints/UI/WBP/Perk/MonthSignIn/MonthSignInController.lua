local MonthSignInModel = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInModel")
local MonthSignInCommon = require("BluePrints.UI.WBP.Perk.MonthSignIn.MonthSignInCommon")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local RewardBox = require("BluePrints.Client.CustomTypes.SimpleRewardBox")
local TimeUtils = require("Utils.TimeUtils")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
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
  local CurTimestamp = TimeUtils.NowTime()
  local PreLoadingTime = EMCache:Get("PreLoadingTime")
  DebugPrint("Yihan@ ShowGetItemPage", CurTimestamp, PreLoadingTime)
  if not PreLoadingTime then
    self:GetUIMgr():LoadUINew("MonthSignInPopMain")
    EMCache:Set("PreLoadingTime", CurTimestamp, true)
  elseif 0 ~= TimeUtils.GetIntervalDay(CurTimestamp, PreLoadingTime, {
    0,
    0,
    0
  }) then
    self:GetUIMgr():LoadUINew("MonthSignInPopMain")
    EMCache:Set("PreLoadingTime", CurTimestamp, true)
  end
end

_G.MonthSignInController = M
return M
