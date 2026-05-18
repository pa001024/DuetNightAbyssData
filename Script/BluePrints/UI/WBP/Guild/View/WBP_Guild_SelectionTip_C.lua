require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(ConfigData)
  self.ConfigData = ConfigData
  self:InitEditList(ConfigData)
end

function M:InitEditList(ConfigData)
  self.List_Edit:ClearListItems()
  local ClassPath = UIUtils.GetCommonItemContentClass()
  local SecondBtnName = "UI_QuitGuild"
  local SecondBtnForbid = false
  local SecondFunc = ConfigData.OnClickQuitGuild
  if ConfigData.SelfGuildInfo.IsMaster then
    if 1 == ConfigData.MemberCount then
      SecondBtnName = "UI_DissolveGuild"
      SecondFunc = ConfigData.OnClickDissolveGuild
    else
      SecondBtnForbid = true
    end
  end
  local MemberMoreListConfig = {
    {
      BtnName = "UI_MemberPermissions",
      OnClickFunction = ConfigData.OnClickMemberPermissions
    },
    {
      BtnName = SecondBtnName,
      OnClickFunction = SecondFunc,
      OnForbiddenClickFunction = ConfigData.OnClickForbidQuitGuild,
      IsForbid = SecondBtnForbid,
      UseRedText = true
    }
  }
  for i = 1, #MemberMoreListConfig do
    local ItemConfig = MemberMoreListConfig[i]
    local MenuContent = NewObject(ClassPath)
    MenuContent.Id = i
    MenuContent.ParentWidget = self
    MenuContent.Text = ItemConfig.BtnName
    MenuContent.OnClickFunction = ItemConfig.OnClickFunction
    MenuContent.OnForbiddenClickFunction = ItemConfig.OnForbiddenClickFunction
    MenuContent.IsForbid = ItemConfig.IsForbid
    MenuContent.UseRedText = ItemConfig.UseRedText
    MenuContent.bGamepadIconVisible = false
    self.List_Edit:AddItem(MenuContent)
  end
end

return M
