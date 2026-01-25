local CssCode = require("BluePrints.UI.WBP.Announcement.WebSource.CssCode")
local JsCode = require("BluePrints.UI.WBP.Announcement.WebSource.JsCode")
local HtmlCode = require("BluePrints.UI.WBP.Announcement.WebSource.HtmlCode")
local CodeVersion = require("BluePrints.UI.WBP.Announcement.WebSource.CodeVersion")
local AnnounceCommon = {
  ContentUIStyle = {ImageOnly = 0, Default = 1},
  TabTag = {
    System = 1,
    Activity = 2,
    News = 3
  },
  ShowTag = {InLogin = 1, InGame = 2},
  SpecialChannelName = {bilibili = 1, wegame = 1},
  PlatformName = string.lower(UE4.UUIFunctionLibrary.GetDevicePlatformName(GWorld.GameInstance)),
  AnnounceWeb = UEMPathFunctionLibrary.GetProjectSavedDirectory() .. "AnnounceWeb/",
  FontTypeMap = {
    [CommonConst.SystemLanguages.CN] = "otf",
    [CommonConst.SystemLanguages.EN] = "otf",
    [CommonConst.SystemLanguages.KR] = "otf",
    [CommonConst.SystemLanguages.TC] = "ttf",
    [CommonConst.SystemLanguages.JP] = "ttf"
  },
  bUseWeb = true,
  LongYMDHMFormat = "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)%s*~%s*(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)",
  LongTimeFormat = "(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*~%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*%])",
  ShortYMDHMFormat = "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)%s*~%s*(%d+)%s*:%s*(%d+)",
  ShortTimeFormat = "(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*~%s*%d+%s*:%s*%d+%s*%])",
  OneYMDHMFormat = "(%d+)-(%d+)-(%d+)%s*(%d+)%s*:%s*(%d+)",
  OneTimeFormat = "(%[%s*%d+-%d+-%d+%s*%d+%s*:%s*%d+%s*%])",
  FontSizeFormat = "(font%-size%s*:%s*%d*.?%d+pt)",
  FontScale = 1.13,
  TableTagFormat = "(</?table>)"
}
if not AnnounceCommon.bUseWeb then
  AnnounceCommon.StyleToContent = {
    [AnnounceCommon.ContentUIStyle.ImageOnly] = "ImageOnly",
    [AnnounceCommon.ContentUIStyle.Default] = "AnnouncementDefaultContent"
  }
end
AnnounceCommon.Version = CodeVersion
AnnounceCommon.HtmlBody1 = string.format(HtmlCode.HtmlBody1, "%s", "%s", CodeVersion, CodeVersion, "%s")
AnnounceCommon.ImageOnlyContent = HtmlCode.ImageOnlyContent
AnnounceCommon.DefaultContent = HtmlCode.DefaultContent
AnnounceCommon.CssContent = CssCode
AnnounceCommon.JsContent = JsCode
_G.AnnounceCommon = AnnounceCommon
return AnnounceCommon
