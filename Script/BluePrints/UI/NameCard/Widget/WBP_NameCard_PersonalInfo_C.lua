require("UnLua")
require("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")
local M = Class("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")

function M:SetPlayerBasicInfo(Avatar)
  if self.Text_PlayerName and Avatar.Nickname then
    self.Text_PlayerName:SetText(GText(Avatar.Nickname))
  end
  if self.Text_Level and Avatar.Level then
    self.Text_Level:SetText(tostring(Avatar.Level))
  end
  if self.Com_ItemHead then
    local HeadIconId = Avatar.HeadIconId
    local HeadFrameId = Avatar.HeadFrameId
    self.Com_ItemHead:SetHeadIconById(HeadIconId, false)
    self.Com_ItemHead:SetHeadFrame(HeadFrameId)
    if self.Com_ItemHead.Button_Area then
      self.Com_ItemHead.Button_Area:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    end
  end
  if self.TitleSetting then
    local TitleBefore = Avatar.TitleBefore or -1
    local TitleAfter = Avatar.TitleAfter or -1
    local TitleFrame = Avatar.TitleFrame or -1
    self.TitleSetting:Init(false)
    self.TitleSetting:Freshtitle(TitleBefore, TitleAfter, TitleFrame)
  end
  if self.Switcher_Input and self.Text_Input and self.Text_Empty then
    local PlayerSignature = Avatar.PersonalSignature or ""
    if "" ~= PlayerSignature then
      self.Switcher_Input:SetActiveWidgetIndex(1)
      self.Text_Input:SetText(PlayerSignature)
    else
      self.Switcher_Input:SetActiveWidgetIndex(0)
      self.Text_Empty:SetText(GText("UI_Menu_Sign_None"))
    end
  end
end

return M
