require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local AppearanceShareModel = require("BluePrints.UI.WBP.Appearance.AppearanceShareModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitAppearancePlan(AppearancePlanInfo, bSelfMsg, SenderName)
  self.AppearancePlanInfo = AppearancePlanInfo
  self.bSelfMsg = bSelfMsg
  self.SenderName = SenderName
  local PlanName = AppearancePlanInfo.PlanName or ""
  local TargetName = AppearancePlanInfo.TargetName or SenderName or ""
  self.Text_Plan:SetText(PlanName)
  self.Text_Avatar:SetText(TargetName)
  self:RefreshAvatarIcon(AppearancePlanInfo)
  self.Button_Area.OnClicked:Clear()
  self.Button_Area.OnClicked:Add(self, self.OnBtnClick)
end

function M:RefreshAvatarIcon(AppearancePlanInfo)
  local TargetId = AppearancePlanInfo and AppearancePlanInfo.TargetId
  local CharData = TargetId and DataMgr.Char[TargetId] or nil
  if not CharData or not CharData.Icon then
    return
  end
  UResourceLibrary.LoadObjectAsync(self, CharData.Icon, {
    self,
    function(_, Icon)
      if not IsValid(self) or not IsValid(Icon) then
        return
      end
      local Mat = self.Img_Avatar:GetDynamicMaterial()
      Mat:SetTextureParameterValue("IconMap", Icon)
    end
  })
end

function M:OnBtnClick()
  local ChatView = ChatController:GetView()
  if not ChatView or ChatView.IsBeginToClose then
    return
  end
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState:IsInDungeon() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  local AppearancePlanInfo = self.AppearancePlanInfo
  if not AppearancePlanInfo or not AppearancePlanInfo.AppearanceInfo then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  local bBattle = ChatView.bBattle
  ChatView:Close()
  AppearanceShareModel.OpenAppearanceImport(self, AppearancePlanInfo, {
    AppearanceIndex = AppearancePlanInfo.PlanIndex or 1,
    OnCloseCallback = function()
      ChatController:OpenView(nil, bBattle)
    end
  })
end

function M:Destruct()
  if self.Button_Area and self.Button_Area.OnClicked then
    self.Button_Area.OnClicked:Clear()
  end
end

return M
