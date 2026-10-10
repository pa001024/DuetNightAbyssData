require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClicked_BtnMore)
  self.Text_More:SetText(GText("Raid_Season_Floor_More"))
end

function M:OnClicked_BtnMore()
  UIManager(self):ShowCommonPopupUI(100440)
end

return M
