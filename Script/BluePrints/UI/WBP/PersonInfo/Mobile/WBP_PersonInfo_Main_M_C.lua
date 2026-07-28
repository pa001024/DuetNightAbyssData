require("UnLua")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.PersonInfo.Base.PersonInfoMainPageView"
}

function M:Construct()
  self:InitBaseView()
  if UIManager():GetUIObj("CheckGuildPage") then
    UIManager():GetUIObj("CheckGuildPage"):Close()
  end
end

function M:InitPage(Data)
  self:RefreshPageView(Data)
end

function M:ModelViewIni()
  self:FreshHideButton()
end

function M:FreshHideButton()
  if not PersonInfoController.MainPage or not PersonInfoController.MainPage.Com_BtnVisible then
    return
  end
  PersonInfoController.MainPage.Com_BtnVisible:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

AssembleComponents(M)
return M
