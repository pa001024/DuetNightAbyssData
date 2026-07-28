require("UnLua")
local Model = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.WeatherImages = {}
  self:BindEvents()
  self.TextEmpty:SetText(GText("UI_AutoChess_NeedChooseBuff"))
end

function M:BindEvents()
  if self.Btn_Cancel then
    self.Btn_Cancel.OnClicked:Clear()
    self.Btn_Cancel.OnClicked:Add(self, self.OnBtnCancelClicked)
  end
end

function M:Refresh(WeatherList)
  self.WeatherList = WeatherList
  if not self.WeatherList then
    self.WeatherList = {}
    local Avatar = GWorld:GetAvatar()
    if Avatar and Avatar.AutoChess and Avatar.AutoChess.DailyChallengeBuffs then
      for BuffId, _ in pairs(Avatar.AutoChess.DailyChallengeBuffs) do
        table.insert(self.WeatherList, BuffId)
      end
    end
  end
  self:ClearWeatherImages()
  local bHasWeather = #self.WeatherList > 0
  if self.TextEmpty then
    self.TextEmpty:SetVisibility(bHasWeather and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.SelfHitTestInvisible)
  end
  if self.Image_BUff then
    self.Image_BUff:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  for _, BuffId in ipairs(self.WeatherList) do
    self:AddWeatherImage(BuffId)
  end
end

function M:AddWeatherImage(BuffId)
  local BuffData = DataMgr.ChallengeBuff[BuffId]
  local IconPath = BuffData and BuffData.BuffIcon
  if not IconPath or not self.Image_BUff then
    return
  end
  local NewImage = self:CopyImage(self.Image_BUff)
  if not NewImage then
    return
  end
  local Icon = LoadObject(IconPath)
  if Icon then
    local DynMaterial = NewImage:GetDynamicMaterial()
    if DynMaterial then
      DynMaterial:SetTextureParameterValue("Mask", Icon)
    end
  end
  NewImage:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  if self.HB_Text then
    self.HB_Text:AddChild(NewImage)
  end
  table.insert(self.WeatherImages, NewImage)
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

function M:ClearWeatherImages()
  for _, Img in ipairs(self.WeatherImages or {}) do
    if IsValid(Img) then
      Img:RemoveFromParent()
    end
  end
  self.WeatherImages = {}
end

function M:OnBtnCancelClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/auto_chess_normal_btn_click", nil, nil)
  local WeatherId = #self.WeatherList > 0 and self.WeatherList[1] or nil
  UIManager(self):ShowCommonPopupUI(100403, {
    IgnoreWeekend = true,
    RightCallbackObj = self,
    SelectedWeatherId = WeatherId,
    CurrentWeatherId = WeatherId,
    ShareEditCallback = self.OnWeatherPopupClosed
  }, self)
end

function M:OnWeatherPopupClosed(WeatherId)
  local Avatar = GWorld:GetAvatar()
  if not (Avatar and Avatar.AutoChess) or not self.SquadIdx then
    return
  end
  local Squad = Avatar.AutoChess.SharedSquads and Avatar.AutoChess.SharedSquads[self.SquadIdx]
  if not Squad then
    return
  end
  local NewWeatherBuffIds = {}
  table.insert(NewWeatherBuffIds, WeatherId)
  local NewBuffs = {}
  if Squad.Buffs then
    for _, BuffId in ipairs(Squad.Buffs) do
      if Model:IsFieldBuff(BuffId) then
        table.insert(NewBuffs, BuffId)
      end
    end
  end
  for _, BuffId in ipairs(NewWeatherBuffIds) do
    table.insert(NewBuffs, BuffId)
  end
  Avatar:AutoChessSetSharedSquad(function(Ret)
    if ErrorCode:Check(Ret) then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SaveSuccessful"))
      local OwnerPanel = self.Owner
      if OwnerPanel and OwnerPanel.RefreshBuffs then
        OwnerPanel:RefreshBuffs()
      end
    end
  end, self.SquadIdx, Squad.Squad, NewBuffs, Squad.Equips)
end

function M:SetSquadIdx(SquadIdx)
  self.SquadIdx = SquadIdx
end

function M:Destruct()
  self:ClearWeatherImages()
end

return M
