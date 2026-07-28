require("UnLua")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local STAR_ABBR_THRESHOLD = 15

function M:Construct()
  self:BindEvents()
  self.TextLevel:SetText(GText("UI_AutoChess_DifficultyScore"))
  EventManager:AddEvent(EventID.OnAutoChessWeatherChanged, self, self.OnWeatherChanged)
  self:InitGamePadKey()
  self.GameInputModeSubsystem = self.GameInputModeSubsystem or UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnAutoChessWeatherChanged, self)
  if self.GameInputModeSubsystem then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    self.GameInputModeSubsystem = nil
  end
end

function M:InitGamePadKey()
  if self.BtnRe01 and self.BtnRe01.Controller then
    self.BtnRe01.Controller:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonLeft)
  end
  if self.BtnRe02 and self.BtnRe02.Controller then
    self.BtnRe02.Controller:CreateGamepadKey(UIConst.GamePadImgKey.RightThumb)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  local bGamepad = UIUtils.IsGamepadInput()
  self:ShowOrHideGamePad(bGamepad)
end

function M:ShowOrHideGamePad(bShow)
  self:SetRefreshBtnGamepadShow(self.BtnRe01, bShow)
  self:SetRefreshBtnGamepadShow(self.BtnRe02, bShow)
end

function M:SetRefreshBtnGamepadShow(Btn, bGamepad)
  if Btn and Btn.WS_Type then
    Btn.WS_Type:SetActiveWidgetIndex(bGamepad and 1 or 0)
  end
end

function M:OnWeatherChanged()
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self:RefreshWeatherDisplay(Avatar)
  end
end

function M:BindEvents()
  if self.BtnRe01 then
    self.BtnRe01.BtnArea.OnClicked:Add(self, self.OnClickBuffEdit)
  end
  if self.BtnRe02 then
    self.BtnRe02.BtnArea.OnClicked:Add(self, self.OnClickWeatherEdit)
  end
end

function M:SetCallbacks(Callbacks)
  self.Callbacks = Callbacks
end

function M:OnClickBuffEdit()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  if self.Callbacks and self.Callbacks.OnBuffEdit then
    self.Callbacks.OnBuffEdit()
  end
end

function M:OnClickWeatherEdit()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
  if self.Callbacks and self.Callbacks.OnWeatherEdit then
    self.Callbacks.OnWeatherEdit()
  end
end

function M:Refresh(MissionId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local MissionData = DataMgr.AutoChessMission[MissionId]
  local BaseStar = MissionData and MissionData.DifficultyStar or 0
  local ExtraStar = 0
  local ChallengeBuffs = Avatar.AutoChess.ChallengeBuffs
  if ChallengeBuffs then
    for ChallengeBuffId, _ in pairs(ChallengeBuffs) do
      local BuffData = DataMgr.ChallengeBuff[ChallengeBuffId]
      if BuffData and BuffData.DifficultyStar then
        ExtraStar = ExtraStar + BuffData.DifficultyStar
      end
    end
  end
  local TotalStar = BaseStar + ExtraStar
  self:RefreshStarDisplay(TotalStar)
  self:RefreshWeatherDisplay(Avatar)
  self:RefreshEfficiencyDisplay(TotalStar)
end

function M:RefreshStarDisplay(TotalStar)
  self.Image_Star:SetVisibility(UIConst.VisibilityOp.Collapsed)
  for _, Image in ipairs(self.AddedImage or {}) do
    Image:RemoveFromParent()
  end
  self.AddedImage = {}
  if TotalStar <= 0 then
    return
  end
  if TotalStar < STAR_ABBR_THRESHOLD then
    self.TextStarNum:SetVisibility(UIConst.VisibilityOp.Collapsed)
    for i = 1, TotalStar do
      local NewImage = self:CopyImage(self.Image_Star)
      NewImage:SetVisibility(UIConst.VisibilityOp.Visible)
      self.Image_Star:GetParent():AddChild(NewImage)
      table.insert(self.AddedImage, NewImage)
    end
  else
    self.Image_Star:SetVisibility(UIConst.VisibilityOp.Visible)
    self.TextStarNum:SetVisibility(UIConst.VisibilityOp.Visible)
    self.TextStarNum:SetText("×" .. tostring(TotalStar))
  end
end

function M:CopyImage(InImage)
  if not InImage then
    return nil
  end
  local Image = NewObject(UE4.UImage)
  Image.bUsing4KImageDesign = InImage.bUsing4KImageDesign
  Image:SetBrush(InImage.Brush)
  Image:SetColorAndOpacity(InImage.ColorAndOpacity)
  return Image
end

function M:RefreshWeatherDisplay(Avatar)
  local DailyChallengeBuffs = Avatar.AutoChess.DailyChallengeBuffs
  local WeatherBuffId
  if DailyChallengeBuffs then
    for ChallengeBuffId, _ in pairs(DailyChallengeBuffs) do
      WeatherBuffId = ChallengeBuffId
      break
    end
  end
  if WeatherBuffId then
    local BuffData = DataMgr.ChallengeBuff[WeatherBuffId]
    if BuffData then
      if self.Image_Icon then
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Visible)
        local IconObj = LoadObject(BuffData.BuffIcon)
        if IconObj then
          self.Image_Icon:SetBrushResourceObject(IconObj)
        end
      end
      if self.TextWeather then
        self.TextWeather:SetText(GText(BuffData.BuffName))
      end
      if self.EMRichTextBlock_74 then
        local Desc = AutoChessDataModel:CalcDescCommom(BuffData, GText(BuffData.BuffDesc))
        self.EMRichTextBlock_74:SetText(Desc)
      end
    end
  else
    if self.Image_Icon then
      self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if self.TextWeather then
      self.TextWeather:SetText(GText("UI_AutoChess_NeedChooseWeather"))
    end
  end
end

function M:RefreshEfficiencyDisplay(TotalStar)
  local bShow = TotalStar > 0
  if self.Tips01 then
    self.Tips01:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  if self.Tips02 then
    self.Tips02:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
