require("UnLua")
local TimeUtils = require("Utils.TimeUtils")
local UIUtils = require("Utils.UIUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
  GuildController:RegisterEvent(self, function(self, EventId)
    if EventId == GuildCommon.EventID.OnGetGuildInfo then
      local CurrGuildInfo = GuildController:GetModel():GetCurrGuild()
      if CurrGuildInfo then
        self.CurrGuildInfo = CurrGuildInfo
        self:RefreshActivityInfo()
      end
    end
  end)
  local GameInputModeSubsystem = UIManager(self):GetGameInputModeSubsystem()
  if GameInputModeSubsystem then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice()
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "Y"}
    }
  })
  self.Btn_Click.OnClicked:Clear()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  ReddotManager.AddListenerEx("GuildTaskHub", self, self.RefreshReddot)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Clear()
  if self.RefreshTimeTimer then
    self:RemoveTimer(self.RefreshTimeTimer)
    self.RefreshTimeTimer = nil
  end
  ReddotManager.RemoveListener("GuildTaskHub", self)
  GuildController:UnRegisterEvent(self)
end

function M:InitView(ParentWidget, GuildInfo)
  self.ParentWidget = ParentWidget
  self.CurrGuildInfo = GuildInfo
  self.CurrActivityValue = 0
  self.Text_Desc:SetText(GText("UI_WeeklyPersonalActivity"))
  self.NextUnlockTime = TimeUtils.NextWeeklyRefreshTime(TimeUtils.NowTime(), CommonConst.GAME_REFRESH_HMS)
  self:RefreshActivityInfo()
  self:StartRefreshTimeTicker()
end

function M:GetWeekActivityLimit()
  local Data = DataMgr.GuildWeekReward
  local WeekActivityLimit = 0
  for ActivityScore, Info in pairs(Data) do
    WeekActivityLimit = math.max(WeekActivityLimit, ActivityScore)
  end
  return WeekActivityLimit
end

function M:GetMyWeekActivityValue()
  local Avatar = GWorld:GetAvatar()
  self.GuildMemberInfo = GuildController:GetModel():GetCurrMember(Avatar.Uid)
  local Ttt = GuildController:GetModel()
  local CurrActivityValue = GuildController:GetModel():GetGuildActivityLevel()
  if self.CurrActivityValue and self.CurrActivityValue ~= CurrActivityValue then
    self.CurrActivityValue = CurrActivityValue
    GuildController:SendGetGuildInfo(self.CurrGuildInfo.GuildId)
  end
  return CurrActivityValue
end

function M:RefreshActivityInfo()
  local NowActivity = self:GetMyWeekActivityValue()
  local MaxActivity = self:GetWeekActivityLimit()
  self.Text_Now:SetText(tostring(NowActivity))
  self.Text_Total:SetText(tostring(MaxActivity))
end

function M:StartRefreshTimeTicker()
  self.Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  if self.RefreshTimeTimer then
    self:RemoveTimer(self.RefreshTimeTimer)
    self.RefreshTimeTimer = nil
  end
  self:RefreshRemainTimeText()
  self.RefreshTimeTimer = self:AddTimer(1, self.RefreshRemainTimeText, true, 0, "GuildUserActivityRefreshTime", true)
end

function M:RefreshRemainTimeText()
  local NowTime = math.floor(TimeUtils.NowTime())
  if not self.NextUnlockTime or NowTime >= self.NextUnlockTime then
    self.NextUnlockTime = TimeUtils.NextWeeklyRefreshTime(NowTime, CommonConst.GAME_REFRESH_HMS)
  end
  local RemainRefreshTime = self.NextUnlockTime - NowTime
  if RemainRefreshTime <= 0 then
    self.NextUnlockTime = TimeUtils.NextWeeklyRefreshTime(NowTime + 1, CommonConst.GAME_REFRESH_HMS)
    RemainRefreshTime = self.NextUnlockTime - NowTime
  end
  RemainRefreshTime = math.max(0, RemainRefreshTime)
  local RemainTimeDict = self:BuildRemainTimeDict(RemainRefreshTime)
  self.Time:SetTimeText("", RemainTimeDict)
  self:RefreshActivityInfo()
end

function M:BuildRemainTimeDict(RemainRefreshTime)
  RemainRefreshTime = math.max(0, math.floor(RemainRefreshTime or 0))
  local Day = math.floor(RemainRefreshTime / 86400)
  RemainRefreshTime = RemainRefreshTime % 86400
  local Hour = math.floor(RemainRefreshTime / 3600)
  RemainRefreshTime = RemainRefreshTime % 3600
  local Min = math.floor(RemainRefreshTime / 60)
  local Sec = RemainRefreshTime % 60
  if Day > 0 then
    return {
      {TimeType = "Day", TimeValue = Day},
      {TimeType = "Hour", TimeValue = Hour}
    }
  end
  if Hour > 0 then
    return {
      {TimeType = "Hour", TimeValue = Hour},
      {TimeType = "Min", TimeValue = Min}
    }
  end
  return {
    {TimeType = "Min", TimeValue = Min},
    {TimeType = "Sec", TimeValue = Sec}
  }
end

function M:OnBtnClick()
  UIManager(self):LoadUINew("GuildReward")
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if UIUtils.IsGamepadInput() then
    self:InitGamepadView()
  else
    self:InitKeyboardView()
  end
end

function M:InitGamepadView()
  self.Key_Controller:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function M:InitKeyboardView()
  self.Key_Controller:SetVisibility(ESlateVisibility.Collapsed)
end

function M:SetGamepadIconVisibility(Visable)
  self.Key_Controller:SetVisibility(Visable and ESlateVisibility.SelfHitTestInvisible or ESlateVisibility.Collapsed)
end

function M:RefreshReddot(Count)
  if Count > 0 then
    self.Reddot:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Reddot:SetVisibility(ESlateVisibility.Collapsed)
  end
end

return M
