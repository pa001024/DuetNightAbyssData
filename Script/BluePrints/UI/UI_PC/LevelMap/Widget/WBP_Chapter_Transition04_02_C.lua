require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
  self.ChapterName, self.CantoName, self.Title, self.AudioPath, self.Func = ...
end

function M:Transition04_02(QuestUIId)
  self.Text_SubTitle01:SetText(GText("UI_Chapter03_Transition01"))
  self.Text_SubTitle02:SetText(GText("UI_Chapter03_Transition02"))
  local QuestConfig = DataMgr.QuestUI[QuestUIId or 100401]
  self.Text_Title:SetText(GText(QuestConfig.ChapterName))
  local Params = QuestConfig.Params
  local Hours = tonumber(Params[1])
  self.Text_SubTitle_Num:SetText(GText(Params[1]))
  local PointCircle = math.floor(Hours / 12)
  local PointCount = 12 - Hours % 12
  self.Panel_HourHand:SetRenderTransformAngle(PointCount * 30 + PointCircle * 360)
  self:PlayInAnim()
  AudioManager(self):PlayUISound(self, "event:/ui/common/chapter_3_trans_clock", "TransClockToEnd", nil)
end

function M:PlayInAnim()
  self:BindToAnimationFinished(self.In, {
    self,
    self.PlayOutAnim
  })
  self:PlayAnimation(self.In)
end

function M:PlayOutAnim()
  self:BindToAnimationFinished(self.Out, {
    self,
    self.Close
  })
  self:PlayAnimation(self.Out)
  if self.Func then
    self.Func()
  end
  self:UISetGamePaused(self.WidgetName or self.ConfigName, false)
  self.IsStopGame = nil
end

function M:Close()
  AudioManager(self):SetEventSoundParam(self, "TransClockToEnd", {ToEnd = 1})
  AudioManager(self):StopSound(self, "TransClockToEnd")
  M.Super.Close(self)
end

return M
