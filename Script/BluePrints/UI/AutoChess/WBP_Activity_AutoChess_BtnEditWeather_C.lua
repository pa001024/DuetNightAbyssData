require("UnLua")
local UIUtils = require("Utils.UIUtils")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.DelayFrameComponent"
})
local WS_BUTTON_CHECK = 0
local WS_BUTTON_EDIT = 1
local WS_BUTTON_GAMEPAD = 2
local WS_ICON_CONTENT = 0
local WS_ICON_EMPTY = 1

function M:Construct()
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
  end
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
  if self.Tips_MenuAnchor and self.Tips_MenuAnchor.OnMenuOpenChanged then
    self.Tips_MenuAnchor.OnMenuOpenChanged:Add(self, self.OnWeatherTipsOpenChanged)
  end
  EventManager:AddEvent(EventID.OnAutoChessWeatherChanged, self, self.OnWeatherChanged)
  EventManager:AddEvent(EventID.OnAutoChessSquadChanged, self, self.OnWeatherChanged)
end

function M:Destruct()
  if self.Btn_Click then
    self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
  end
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
    self.GameInputModeSubsystem = nil
  end
  if self.Tips_MenuAnchor and self.Tips_MenuAnchor.OnMenuOpenChanged then
    self.Tips_MenuAnchor.OnMenuOpenChanged:Remove(self, self.OnWeatherTipsOpenChanged)
  end
  EventManager:RemoveEvent(EventID.OnAutoChessWeatherChanged, self)
  EventManager:RemoveEvent(EventID.OnAutoChessSquadChanged, self)
end

function M:Init(bEditMode, Parent, MissionId)
  self.bEditMode = bEditMode and true or false
  self.Parent = Parent
  self.MissionId = MissionId
  self:RefreshWeatherIcon()
  self:RefreshOpInfoByInputDevice()
end

function M:RefreshOpInfoByInputDevice(CurInputType)
  if nil == CurInputType then
    CurInputType = UIUtils.UtilsGetCurrentInputType()
  end
  local bIsGamepad = CurInputType == ECommonInputType.Gamepad
  if self.Tips_MenuAnchor then
    local bShowAnchor = not self.bEditMode and self.bHasWeather
    self.Tips_MenuAnchor:SetVisibility(bShowAnchor and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if not self.WS_Button then
    return
  end
  if bIsGamepad then
    if self.Key_Controller and self.Key_Controller.CreateCommonKey then
      self.Key_Controller:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgShortPath = UIConst.GamePadImgKey.SpecialRight
          }
        }
      })
    end
    self.WS_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Button:SetActiveWidgetIndex(WS_BUTTON_GAMEPAD)
  elseif self.bEditMode then
    self.WS_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Button:SetActiveWidgetIndex(WS_BUTTON_EDIT)
  else
    self.WS_Button:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.WS_Button:SetActiveWidgetIndex(WS_BUTTON_CHECK)
  end
end

function M:GetShareChallengeBuffIds()
  local Parent = self.Parent
  if not Parent or not Parent.GameMode then
    return nil
  end
  local bShareChallenge = Parent.GameMode:TriggerDungeonComponentFun("GetIsShareChallenge")
  if not bShareChallenge then
    return nil
  end
  return Parent.GameMode:TriggerDungeonComponentFun("GetActiveChallengeBuffIdList")
end

function M:RefreshWeatherIcon()
  local WeatherBuffId = Model:GetDisplayWeatherBuff(self.MissionId, self:GetShareChallengeBuffIds())
  local BuffRow = WeatherBuffId and DataMgr.ChallengeBuff[WeatherBuffId]
  self.bHasWeather = nil ~= BuffRow
  if not BuffRow then
    if self.WS_Icon then
      self.WS_Icon:SetActiveWidgetIndex(WS_ICON_EMPTY)
    end
    return
  end
  if self.WS_Icon then
    self.WS_Icon:SetActiveWidgetIndex(WS_ICON_CONTENT)
  end
  if self.Image_Weather then
    local IconObj = LoadObject(BuffRow.BuffIcon)
    if IconObj then
      self.Image_Weather:SetBrushResourceObject(IconObj)
    end
    self.Image_Weather:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self.WeatherDescText = Model:CalcDescCommom(BuffRow, GText(BuffRow.BuffDesc))
end

function M:OnInputMethodChanged()
  if self:IsTipsOpen() then
    self:CloseTips()
  end
  self:RefreshOpInfoByInputDevice()
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  self:TriggerAction()
end

function M:TriggerAction()
  if self.bEditMode then
    local CurrentWeatherId = Model:GetDisplayWeatherBuff(self.MissionId)
    UIManager(self):ShowCommonPopupUI(100403, {
      IgnoreWeekend = true,
      RightCallbackObj = self,
      SelectedWeatherId = CurrentWeatherId,
      CurrentWeatherId = CurrentWeatherId,
      ShareEditCallback = self.OnWeatherPopupClosed
    }, self)
    return
  end
  self:ToggleWeatherTips()
end

function M:OnWeatherPopupClosed(WeatherId)
  if not IsValid(self) or not WeatherId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar or not Avatar.AutoChess then
    return
  end
  local SquadIdx = Model:GetEditingSuqadIndex() or 1
  local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[SquadIdx]
  if not Squad then
    return
  end
  local NewBuffs = {}
  if Squad.Buffs then
    for _, BuffId in ipairs(Squad.Buffs) do
      if Model:IsFieldBuff(BuffId) then
        table.insert(NewBuffs, BuffId)
      end
    end
  end
  table.insert(NewBuffs, WeatherId)
  Avatar:AutoChessSetSharedSquad(function(Ret)
    if ErrorCode:Check(Ret) then
      self:RefreshWeatherIcon()
      self:RefreshOpInfoByInputDevice()
      EventManager:FireEvent(EventID.OnAutoChessChallengeBuffChanged)
    end
  end, SquadIdx, Squad.Squad, NewBuffs, Squad.Equips)
end

function M:OnWeatherChanged()
  if not IsValid(self) then
    return
  end
  self:RefreshWeatherIcon()
  self:RefreshOpInfoByInputDevice()
end

function M:OnWeatherTipsOpenChanged(bIsOpen)
  UIManager(self):SetIsMenuAnchorOpen(bIsOpen)
  if not bIsOpen then
    self:NotifyBattlePageRefreshOpInfo(false)
  end
end

function M:ToggleWeatherTips()
  if not self.Tips_MenuAnchor or not self.bHasWeather then
    return
  end
  if self.Tips_MenuAnchor:IsOpen() then
    self:CloseTips()
  else
    self.bPendingGamepadOpen = UIUtils.IsGamepadInput()
    if self.AddDelayFrameFunc then
      self:AddDelayFrameFunc(function()
        if IsValid(self) then
          self:DoOpenWeatherTips()
        end
      end, 1, "AutoChessWeatherTipsOpen")
    else
      self:DoOpenWeatherTips()
    end
  end
end

function M:DoOpenWeatherTips()
  if not IsValid(self.Tips_MenuAnchor) then
    return
  end
  local bGamepad = self.bPendingGamepadOpen
  self.bPendingGamepadOpen = nil
  self.Tips_MenuAnchor:Open(true)
  if bGamepad then
    self:NotifyBattlePageRefreshOpInfo(true)
  end
  if self.TipsDetail and self.WeatherDescText then
    self.TipsDetail:InitMessage(self.WeatherDescText)
  end
end

function M:NotifyBattlePageRefreshOpInfo(bForceKeyboard)
  local Parent = self.Parent
  if not IsValid(Parent) or not Parent.RefreshOpInfoByInputDevice then
    return
  end
  local InputType, GamepadName
  if bForceKeyboard then
    InputType = ECommonInputType.MouseAndKeyboard
  elseif self.GameInputModeSubsystem then
    InputType = self.GameInputModeSubsystem:GetCurrentInputType()
    GamepadName = self.GameInputModeSubsystem:GetCurrentGamepadName()
  end
  Parent:RefreshOpInfoByInputDevice(InputType, GamepadName)
end

function M:IsTipsOpen()
  return self.Tips_MenuAnchor ~= nil and self.Tips_MenuAnchor:IsOpen()
end

function M:CloseTips()
  if self.Tips_MenuAnchor and self.Tips_MenuAnchor:IsOpen() then
    self.Tips_MenuAnchor:Close()
  end
end

return M
