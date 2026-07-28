require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:InitGamepadView()
end

function M:InitGamepadView()
  self.Key_Back:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "B"}
    },
    Desc = GText("UI_BACK")
  })
end

function M:Init(Data)
  self._MenuData = Data
  self.Text_Title:SetText(Data.Title)
  self.Text_Desc:SetText(Data.Desc)
end

return M
