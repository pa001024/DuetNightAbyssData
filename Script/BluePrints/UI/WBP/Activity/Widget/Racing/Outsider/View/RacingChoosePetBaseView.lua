require("UnLua")
local RacingActivityConst = require("BluePrints.UI.WBP.Activity.Widget.Racing.RacingActivityConst")
local RacingOutsiderModel = require("BluePrints.UI.WBP.Activity.Widget.Racing.Outsider.RacingOutsiderModel")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:InitBaseView()
  self.IsInAnimation = false
  self:InitPageView()
  self:QuerryTodayPlayerList()
  self:PlayAnimationIn()
end

function M:InitPageView()
  self.WBP_Activity_Racing_Pet_P:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self:UpdateBgColor()
end

function M:UpdateBgColor()
  if RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.SelectPlayer then
    self.Racing_ChooseBG.WS_Stage:SetActiveWidgetIndex(0)
  elseif RacingOutsiderModel.CurActivityStage == RacingActivityConst.RacingActivityStage.GetReward then
    self.Racing_ChooseBG.WS_Stage:SetActiveWidgetIndex(2)
  else
    self.Racing_ChooseBG.WS_Stage:SetActiveWidgetIndex(1)
  end
end

function M:QuerryTodayPlayerList()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:RaceLotteryQueryPlayerList()
  end
end

function M:bShowPetPage(bShow)
  DebugPrint("Yihan@ bShowPetPage", bShow, self.IsPetPageOpen)
  local TodayPlayerList = RacingOutsiderModel:GetTodayPlayerList()
  if bShow and not next(TodayPlayerList) then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("RET_POOR_NETWORK_CONNECTION"))
    return
  end
  self.WBP_Activity_Racing_Pet_P:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  RacingOutsiderModel.CurrentFocusWidget = nil
  if self.Com_Tab and self.Com_Tab.WBP_Com_Tab_ResourceBar then
    self.Com_Tab.WBP_Com_Tab_ResourceBar:SetLastFocusWidget(self)
  end
  if bShow then
    if self.IsPetPageOpen then
      return
    end
    self.WBP_Activity_Racing_Pet_P:StopAnimation(self.WBP_Activity_Racing_Pet_P.Out)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.In)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.Out)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.Tips)
    self.WBP_Activity_Racing_Pet_P:PlayAnimationIn()
    self.WBP_Activity_Racing_Choose_P:PlayAnimationOut()
    AudioManager(self):PlayUISound(self, "event:/ui/common/pet_race_pet_list_in", nil, nil)
    self.IsPetPageOpen = true
  else
    if not self.IsPetPageOpen then
      self.WBP_Activity_Racing_Pet_P:SetVisibility(UIConst.VisibilityOp.Collapsed)
      return
    end
    self.WBP_Activity_Racing_Pet_P:StopAnimation(self.WBP_Activity_Racing_Pet_P.In)
    self.WBP_Activity_Racing_Pet_P:StopAnimation(self.WBP_Activity_Racing_Pet_P.Out)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.In)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.Out)
    self.WBP_Activity_Racing_Choose_P:StopAnimation(self.WBP_Activity_Racing_Choose_P.Tips)
    self.WBP_Activity_Racing_Pet_P:PlayAnimationOut()
    self.WBP_Activity_Racing_Choose_P:PlayAnimationIn()
    self.IsPetPageOpen = false
    self.WBP_Activity_Racing_Choose_P:SetFocus()
    AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_icon_btn_click", nil, nil)
  end
end

function M:RefreshMainPage()
  if self.WBP_Activity_Racing_Choose_P and self.WBP_Activity_Racing_Choose_P.RefreshHomeView then
    self.WBP_Activity_Racing_Choose_P:RefreshHomeView()
  end
end

function M:Destruct()
end

function M:OnViewClose()
  self:PlayAnimationOut()
end

function M:PlayTaskBackAnimation()
  self.WBP_Activity_Racing_Choose_P:PlayAnimation(self.WBP_Activity_Racing_Choose_P.Back)
end

function M:PlayAnimationIn()
  DebugPrint("Yihan@ PlayAnimationIn: ")
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "RacingMainPop", nil)
  self:PlayAnimation(self.In)
  self.IsInAnimation = true
end

function M:PlayAnimationOut()
  self.WBP_Activity_Racing_Choose_P:PlayAnimation(self.WBP_Activity_Racing_Choose_P.Out)
  AudioManager(self):SetEventSoundParam(self, "RacingMainPop", {ToEnd = 1})
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self.IsInAnimation = false
  end
end

AssembleComponents(M)
return M
