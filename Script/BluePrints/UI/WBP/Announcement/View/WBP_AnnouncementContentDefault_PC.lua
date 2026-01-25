require("UnLua")
local Utils = require("Utils")
local M = Class({
  "BluePrints.UI.WBP.Announcement.View.WBP_AnnouncementContentBase_PC"
})

function M:Open(Content)
  M.Super.Open(self, Content)
  self.Text_Date:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Title:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Text_Details:SetText(Content.Conf.NoticeContent)
  if Content.Conf.NoticeBanner then
    local BannerTex = LoadObject(Content.Conf.NoticeBanner)
    assert(BannerTex, "公告Banner配置图路径错误，公告Id:" .. Content.Conf.NoticeID .. "错误的路径：" .. Content.Conf.NoticeBanner)
    self.Image_Announcement:SetBrushResourceObject(BannerTex)
  end
end

return M
