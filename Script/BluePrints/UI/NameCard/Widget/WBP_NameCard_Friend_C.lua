require("UnLua")
require("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")
local M = Class("BluePrints.UI.NameCard.Widget.WBP_NameCard_SubPage_Base")

function M:SetPlayerBasicInfo(Avatar)
  if self.Text_Name and Avatar.Nickname then
    self.Text_Name:SetText(Avatar.Nickname)
  end
  if self.Num_Level and Avatar.Level then
    self.Num_Level:SetText(tostring(Avatar.Level))
  end
  if self.Head_Friend then
    self.Head_Friend:SetHeadIconById(Avatar.HeadIconId)
    self.Head_Friend:SetHeadFrame(Avatar.HeadFrameId)
    self.Head_Friend:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.Title then
    UIUtils.SetTitle(self.Title, Avatar)
  end
  if self.Text_Intro then
    local Signature = Avatar.PersonalSignature or ""
    if "" == Signature then
      self.Text_Intro:SetText(GText("UI_Friend_NoSignature"))
    else
      self.Text_Intro:SetText(Signature)
    end
  end
end

return M
