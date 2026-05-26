require("UnLua")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnClickBtnGuild)
  self.Btn_Guild.OnClicked:Add(self, self.OnClickBtnOpenGuildDetail)
  self.Btn_Click.OnPressed:Add(self, self.OnPressBtnGuild)
  self.Btn_Guild.OnPressed:Add(self, self.OnPressBtnOpenGuildDetail)
  self.Text_Apply:SetText(GText("UI_ApplyToJoinGuild"))
  self:PlayAnimation(self.Normal)
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Key_Name:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "X"}
    }
  })
  self.Key_Name:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGuildInviteItem(GuildInviteInfo, isFromOther)
  self.GuildInviteInfo = GuildInviteInfo
  if not GuildInviteInfo then
    return
  end
  self.Text_GuildName:SetText(GuildInviteInfo.GuildName or "")
  self.Text_Level:SetText(tostring(tonumber(GuildInviteInfo.Level) or 0))
  local MemberCount = tonumber(GuildInviteInfo.MemberCount) or 0
  local MemberLimit = tonumber(GuildInviteInfo.MemberLimit) or 0
  self.Text_NowNum:SetText(tostring(MemberCount))
  self.Text_TotalNum:SetText(tostring(MemberLimit))
  local Logo = GuildInviteInfo.Logo
  local LogoSlot = self.Logo
  if LogoSlot and LogoSlot.Init then
    if type(Logo) == "string" and "" ~= Logo then
      LogoSlot:Init(Logo)
    else
      LogoSlot:Init("1,1,1|1,1,1")
    end
  end
  self.Text_Intro:SetText(GuildInviteInfo.RecruitMessage or "")
  if isFromOther then
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Panel_Button:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnClickBtnGuild()
  local Info = self.GuildInviteInfo
  if not Info then
    return
  end
  local GuildId = tonumber(Info.GuildId) or 0
  if GuildId <= 0 then
    return
  end
  GuildController:SendRequestJoinGuild(GuildId, 0)
end

function M:OnClickBtnOpenGuildDetail()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if GameState and GameState:IsInDungeon() then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_COMMONPOP_TITLE_100059"))
    return
  end
  GuildController:OpenGuildDetailPopup(self, self.GuildInviteInfo.GuildId)
end

function M:OnPressBtnGuild()
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
end

function M:OnPressBtnOpenGuildDetail()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
end

return M
