require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local ModeConfig = {
  [UIConst.InputNumMode.ENABLE_PWD] = {
    "输入密码",
    "确认密码"
  },
  [UIConst.InputNumMode.VERIFY_PWD] = {
    "输入密码"
  }
}

function M:Construct()
  self.DataObjects = {}
  self.ActiveWidgets = {}
end

function M:InitRows(Mode)
  self.DataObjects = {}
  self.ActiveWidgets = {}
  local Texts = ModeConfig[Mode] or {
    "输入密码"
  }
  local RowCount = #Texts
  for i = 1, RowCount do
    local Item = NewObject(UIUtils.GetCommonItemContentClass())
    Item.ItemData = {
      RowIndex = i,
      Text = "",
      DescText = Texts[i],
      ParentPanel = self
    }
    table.insert(self.DataObjects, Item)
    self.List_Password:AddItem(Item)
  end
end

function M:RegisterRowWidget(RowIndex, Widget)
  self.ActiveWidgets[RowIndex] = Widget
end

function M:UpdateRowText(RowIndex, NewText)
  local Item = self.DataObjects[RowIndex]
  if Item and Item.LuaData then
    Item.LuaData.Text = NewText
  end
  local Widget = self.ActiveWidgets[RowIndex]
  if Widget then
    Widget:RefreshView(NewText)
  end
end

return M
