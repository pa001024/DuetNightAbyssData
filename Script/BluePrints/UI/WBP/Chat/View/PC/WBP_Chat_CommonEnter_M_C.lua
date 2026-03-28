require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Com_ChatBtn.Button_Area.OnClicked:Add(self, self.OnClick)
  ReddotManager.AddListener(ChatCommon.ReddotName, self, function(self, Count)
    self:OnReddotUpdateChatMainMenu()
  end)
end

function M:OnReddotUpdateChatMainMenu()
  ChatController:OnChatReddotUpdate(self.Reddot_Num)
end

function M:Destruct()
  ReddotManager.RemoveListener(ChatCommon.ReddotName, self)
end

function M:OnClick()
  self:PlayAnimation(self.Click)
  local Params = {
    bBattle = false,
    bInDungeonSettlement = self.bInDungeonSettlement and GWorld:GetAvatar().SettlementUidArray
  }
  local ChatMainUI = ChatController:OpenView(self, Params)
  if ChatMainUI and ChatMainUI:GetVisibility() == UIConst.VisibilityOp.Collapsed then
    ChatMainUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

return M
