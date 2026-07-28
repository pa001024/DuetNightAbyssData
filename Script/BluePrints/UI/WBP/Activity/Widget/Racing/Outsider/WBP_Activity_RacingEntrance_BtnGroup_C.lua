require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local RacingOutsiderController = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderController")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")

function M:Init(ActivityConfigData, PageConfigData, PlayerAvatar)
  self.EventId = ActivityConfigData.EventId
  self:RefreshBaseInfo(ActivityConfigData)
end

function M:RefreshBaseInfo(ActivityConfigData)
  self.Btn_Shop:BtnSetUpWithData(self, "Shop", "UI_Event_RaceLottery_EventShopEntrance", self.OnBtnShopClick, {
    Key = UIConst.GamePadImgKey.FaceButtonLeft
  })
  self.Btn_Task:BtnSetUpWithData(self, "Task", "UI_Event_RaceLottery_EventQuestEntrance", self.OnBtnTaskClick, {
    Key = UIConst.GamePadImgKey.FaceButtonTop
  })
  self:InitReddot()
end

function M:InitReddot()
  ReddotManager.RemoveListener(RacingActivityConst.ReddotRewardKey, self)
  if not ReddotManager.GetTreeNode(RacingActivityConst.ReddotRewardKey) then
    ReddotManager.AddNodeEx(RacingActivityConst.ReddotRewardKey)
  end
  ReddotManager.AddListenerEx(RacingActivityConst.ReddotRewardKey, self, self.OnRefreshTaskRewardReddot)
end

function M:OnRefreshTaskRewardReddot(Count, RedType, Name)
  DebugPrint("RacingEntrance=== OnRefreshTaskRewardReddot", Count, RedType, Name)
  self.Btn_Task:RefreshReddot(Count)
end

function M:OnBtnShopClick()
  DebugPrint("RacingEntrance=== BtnGroup_OnBtnShopClick")
  local EventShopId = tonumber(DataMgr.RaceLotteryConstant.EventShopJumpId.ConstantValue)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_tab_btn_click", nil, nil)
  PageJumpUtils:JumpToTargetPageByJumpId(EventShopId)
end

function M:OnBtnTaskClick()
  DebugPrint("RacingEntrance=== BtnGroup_OnBtnTaskClick")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/feina_tab_btn_click", nil, nil)
  RacingOutsiderController:GetModel():OpenTaskReward()
end

function M:OnUpdateSubUIViewStyle(bIsUseGamePad)
  self.Btn_Shop:OnUpdateSubUIViewStyle(bIsUseGamePad)
  self.Btn_Task:OnUpdateSubUIViewStyle(bIsUseGamePad)
end

function M:HandleKeyDownOnGamePad(KeyName)
  local bHandled = false
  if KeyName == UIConst.GamePadKey.FaceButtonLeft then
    bHandled = true
    self:OnBtnShopClick()
  elseif KeyName == UIConst.GamePadKey.FaceButtonTop then
    bHandled = true
    self:OnBtnTaskClick()
  end
  return bHandled
end

return M
