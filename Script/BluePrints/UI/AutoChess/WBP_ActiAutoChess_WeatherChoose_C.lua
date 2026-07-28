require("UnLua")
local UIUtils = require("Utils.UIUtils")
local AutoChessDataModel = require("BluePrints.UI.AutoChess.AutoChessDataModel")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:PreInitContent(Params, PopupData, Owner)
  AudioManager(self):PlayUISound(self, "event:/ui/common/sub_panel_expand", "AutoWeatherChoose", nil)
  self.Super.PreInitContent(self, Params, PopupData, Owner)
  if self.TextTitle then
    self.TextTitle:SetText(GText("UI_AutoChess_WeatherChooseTitle"))
  end
  self.IgonreWeekend = Params.IgnoreWeekend
  self.IsWeekend = self.IgonreWeekend or TimeUtils.IsWeekend()
  self.Owner.RightBtnCallbackObj = self
  self.Owner.RightBtnClickedCallback = self.OnClickSave
  self.Owner:BindToAnimationStarted(self.Owner.Out, {
    self,
    function()
      AudioManager(self):SetEventSoundParam(self, "AutoWeatherChoose", {ToEnd = 1})
    end
  })
  self.ShareEditCallback = Params.ShareEditCallback
  self.CurrentWeatherId = Params.CurrentWeatherId
  self.SelectedWeatherId = Params.SelectedWeatherId
  self.WeatherContents = {}
  self.LastWeatherId = Params.SelectedWeatherId
  if not self.IgonreWeekend then
    local Avatar = GWorld:GetAvatar()
    for BuffId, _ in pairs(Avatar.AutoChess.DailyChallengeBuffs) do
      if not self.LastWeatherId then
        self.LastWeatherId = BuffId
      end
    end
  end
end

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self:InitWeatherList()
  self:BindEvents()
  self:RefreshDescription()
  self:RefreshButtons()
  self:ScheduleRefreshScrollGamepadTip()
  if self.IgonreWeekend then
    self.Owner:ShowDialogTip(1)
  elseif not self.IsWeekend then
    self.Owner:ShowDialogTip(1)
  else
    self.Owner:HideDialogTip(1)
  end
end

function M:BindEvents()
  if self.ListWeather then
    self.ListWeather.BP_OnItemClicked:Add(self, self.OnWeatherItemClicked)
  end
end

function M:InitWeatherList()
  if not self.ListWeather then
    return
  end
  self.ListWeather:ClearListItems()
  self.WeatherContents = {}
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if not self.IgonreWeekend then
    local DailyChallengeBuffs = Avatar.AutoChess.DailyChallengeBuffs
    if DailyChallengeBuffs then
      for ChallengeBuffId, _ in pairs(DailyChallengeBuffs) do
        self.CurrentWeatherId = ChallengeBuffId
        break
      end
    end
    self.SelectedWeatherId = self.CurrentWeatherId
  end
  for ChallengeBuffId, BuffData in pairs(DataMgr.ChallengeBuff) do
    if AutoChessDataModel:IsWeatherBuff(ChallengeBuffId) then
      if not self.SelectedWeatherId or not self.CurrentWeatherId then
        self.SelectedWeatherId = ChallengeBuffId
        self.CurrentWeatherId = ChallengeBuffId
      end
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Path = BuffData.BuffIcon
      Content.BuffName = GText(BuffData.BuffName)
      Content.BuffDes = AutoChessDataModel:CalcDescCommom(BuffData, GText(BuffData.BuffDesc))
      Content.ChallengeBuffId = ChallengeBuffId
      Content.bSelected = ChallengeBuffId == self.SelectedWeatherId
      Content.bLocked = not self.IsWeekend and ChallengeBuffId ~= self.CurrentWeatherId
      Content.Parent = self
      table.insert(self.WeatherContents, Content)
      self.ListWeather:AddItem(Content)
    end
  end
end

function M:OnWeatherItemClicked(Content)
  if not Content then
    return
  end
  local ChallengeBuffId = Content.ChallengeBuffId
  if not ChallengeBuffId then
    return
  end
  self.SelectedWeatherId = ChallengeBuffId
  self:RefreshListSelection()
  self:RefreshDescription()
  self:RefreshButtons()
  self:ScheduleRefreshScrollGamepadTip()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small_crystal", nil, nil)
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_LeftShoulder" == InKeyName then
    self:SwitchWeatherSelection(-1)
    return true
  elseif "Gamepad_RightShoulder" == InKeyName then
    self:SwitchWeatherSelection(1)
    return true
  end
  return false
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if not IsValid(self.EMScrollBox_Text) then
    return
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    UIUtils.ScrollBoxByGamepad(self.EMScrollBox_Text, InAnalogInputEvent)
  end
end

function M:SwitchWeatherSelection(Step)
  local Count = #self.WeatherContents
  if Count <= 1 then
    return
  end
  local CurIndex = 1
  for Index, Content in ipairs(self.WeatherContents) do
    if Content.ChallengeBuffId == self.SelectedWeatherId then
      CurIndex = Index
      break
    end
  end
  local NextIndex = CurIndex
  for _ = 1, Count do
    NextIndex = NextIndex + Step
    if NextIndex < 1 then
      NextIndex = Count
    elseif Count < NextIndex then
      NextIndex = 1
    end
    local Content = self.WeatherContents[NextIndex]
    if Content then
      self:OnWeatherItemClicked(Content)
      return
    end
  end
end

function M:InitGamepadView()
  if self.Panel_List_Controller then
    self.Panel_List_Controller:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.Controller_List_L then
    self.Controller_List_L:CreateGamepadKey(UIConst.GamePadImgKey.LeftShoulder)
    self.Controller_List_L:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  if self.Controller_List_R then
    self.Controller_List_R:CreateGamepadKey(UIConst.GamePadImgKey.RightShoulder)
    self.Controller_List_R:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  self:RefreshScrollGamepadTip()
end

function M:InitKeyboardView()
  if self.Panel_List_Controller then
    self.Panel_List_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Controller_List_L then
    self.Controller_List_L:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Controller_List_R then
    self.Controller_List_R:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshScrollGamepadTip()
end

function M:IsDescScrollable()
  local ScrollBox = self.EMScrollBox_Text
  if not IsValid(ScrollBox) then
    return false
  end
  ScrollBox:ForceLayoutPrepass()
  local ContentH = IsValid(self.RichTextContent) and self.RichTextContent:GetDesiredSize().Y or 0
  local ViewH = UE4.USlateBlueprintLibrary.GetLocalSize(ScrollBox:GetTickSpaceGeometry()).Y
  if ViewH <= 0 then
    return nil
  end
  return ContentH - ViewH > 5
end

function M:RefreshScrollGamepadTip()
  self:ShowGamepadScrollBtn(UIUtils.IsGamepadInput() and self:IsDescScrollable() == true)
end

function M:ScheduleRefreshScrollGamepadTip()
  if not UIUtils.IsGamepadInput() then
    self:ShowGamepadScrollBtn(false)
    return
  end
  local Scrollable = self:IsDescScrollable()
  if nil == Scrollable and self.AddDelayFrameFunc then
    self:AddDelayFrameFunc(function()
      if IsValid(self) then
        self:RefreshScrollGamepadTip()
      end
    end, 5, "AutoChessWeatherScrollTip")
    return
  end
  self:ShowGamepadScrollBtn(true == Scrollable)
end

function M:RefreshListSelection()
  for _, ItemContent in ipairs(self.WeatherContents) do
    local bSelected = ItemContent.ChallengeBuffId == self.SelectedWeatherId
    ItemContent.bSelected = bSelected
    if ItemContent.CurrentEntry then
      local Entry = ItemContent.CurrentEntry
      if type(Entry.SetSelected) == "function" then
        Entry:SetSelected(bSelected)
      end
    end
  end
end

function M:RefreshDescription(PreviewBuffId)
  local BuffId = PreviewBuffId or self.SelectedWeatherId
  if not BuffId then
    if self.TextTitle then
      self.TextTitle:SetText(GText("UI_AutoChess_WeatherChooseTitle"))
    end
    if self.RichTextContent then
      self.RichTextContent:SetText("")
    end
    return
  end
  local BuffData = DataMgr.ChallengeBuff[BuffId]
  if not BuffData then
    if self.TextTitle then
      self.TextTitle:SetText(GText("UI_AutoChess_WeatherChooseTitle"))
    end
    if self.RichTextContent then
      self.RichTextContent:SetText("")
    end
    return
  end
  if self.TextTitle then
    self.TextTitle:SetText(GText(BuffData.BuffName))
  end
  if self.RichTextContent then
    self.RichTextContent:SetText(GText(BuffData.BuffDesc))
  end
end

function M:RefreshButtons()
  local ButtonBar = self.Owner and self.Owner:GetButtonBar()
  if not ButtonBar then
    return
  end
  if self.IgonreWeekend then
    if self.LastWeatherId == self.SelectedWeatherId then
      ButtonBar.Btn_Yes:ForbidBtn(true)
    else
      ButtonBar.Btn_Yes:ForbidBtn(false)
    end
    return
  end
  if not self.IsWeekend then
    ButtonBar.Panel_Quit:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ButtonBar.Btn_Yes:SetText(GText("UI_BTN_Got_It"))
  elseif self.LastWeatherId == self.SelectedWeatherId then
    ButtonBar.Btn_Yes:ForbidBtn(true)
  else
    ButtonBar.Btn_Yes:ForbidBtn(false)
  end
end

function M:OnClickSave()
  if self.IgonreWeekend then
    if self.ShareEditCallback then
      self.ShareEditCallback(self.Owner.ParentWidget, self.SelectedWeatherId)
    end
  else
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    local AllBuffs = {}
    table.insert(AllBuffs, self.SelectedWeatherId)
    
    local function OnSetBuffSuccess(Ret)
      if ErrorCode:Check(Ret) then
        EventManager:FireEvent(EventID.OnAutoChessWeatherChanged)
        if IsValid(self.Owner) then
          self.Owner:Close()
        end
      end
    end
    
    if self.IsWeekend then
      Avatar:AutoChessSetChallengeBuff(OnSetBuffSuccess, AllBuffs)
    end
  end
end

return M
