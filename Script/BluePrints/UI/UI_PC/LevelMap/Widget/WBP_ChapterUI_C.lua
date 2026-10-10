require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Destruct()
  if self.Type == "BackUp" then
    self.Btn_1:UnBindEventOnClickedByObj(self)
    self.Btn_2:UnBindEventOnClickedByObj(self)
  end
  self:SetInputUIOnly(false)
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.QuestUIId, self.Type, self.EndingData = ...
  self.Info = DataMgr.QuestUI[self.QuestUIId]
  self.Text_SubTitle:SetTexT(GText(self.Info.ChapterName))
  self.Text_Title:SetTexT(GText(self.Info.CantoName))
  local IconDynaMaterial = self.Image_TitleIcon:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetTextureParameterValue("Mask2", LoadObject(self.Info.IconPath))
  end
  local VXIconDynaMaterial = self.TitleIcon_VX:GetDynamicMaterial()
  if VXIconDynaMaterial then
    VXIconDynaMaterial:SetTextureParameterValue("Mask2", LoadObject(self.Info.IconPath))
  end
  self.Text_Tips:SetTexT(GText("UI_GACHA_NEXT"))
  self:SetInputUIOnly(true)
  if self.Type == "Start" then
    self.Text_Desc:SetTexT(GText("UI_Quest_ChapterStart"))
    self:PlayAnimation(self.In)
    AudioManager(self):PlayUISound(self, self.Info.AudioPath, "Open", nil)
    local EndTime = self.In:GetEndTime()
    self:AddTimer(EndTime, function()
      self.Out:BindToAnimationFinished(self, {
        self,
        function()
          AudioManager(self):SetEventSoundParam(self, "Open", {ToEnd = 1})
          self:OnClose()
        end
      })
      self:PlayAnimation(self.Out)
    end, false, 0, nil, true)
  else
    AudioManager(self):PlayUISound(self, self.Info.AudioPathFinal, "Close", nil)
    self.Text_Desc:SetTexT(GText("UI_Quest_ChapterFinish"))
    self.bClick = false
    local EndTime = self.End_In:GetEndTime()
    self.End_In:BindToAnimationFinished(self, {
      self,
      function()
        self.bClick = true
      end
    })
    self:PlayAnimation(self.End_In)
    if self.Type == "BackUp" then
      self:InitBackUpUI(self.EndingData)
    else
      self.Btn_FullClose.OnClicked:Add(self, self.OnClick)
    end
  end
  self.Key_Tips:CreateCommonKey({
    KeyInfoList = {
      {Type = "Img", ImgShortPath = "A"}
    }
  })
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnUpdateUIStyleByInputTypeChange)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  if self.QuestUIId == 100400 then
    AudioManager(self):PlayUISound(self, "event:/ui/common/main_quest_start_chapter3", "Chapter3ToEnd", nil)
  end
end

function M:InitBackUpUI(EndingData)
  self.Text_SubTitle:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.EndImage:SetVisibility(UE4.ESlateVisibility.HitTestInvisible)
  self.Group_Button:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  self.Text_Tips:SetTexT(GText("UI_QuestEnd_1301_01"))
  self.Btn_1:SetText(GText("UI_QuestEnd_1301_02"))
  self.Btn_2:SetText(GText("UI_QuestEnd_1301_03"))
  self.Btn_1:BindEventOnClicked(self, self.OnClick)
  self.Btn_2:BindEventOnClicked(self, self.OnBackUpClick)
end

function M:OnBackUpClick()
  if self:IsPlayingAnimation(self.Out) or not self.bClick then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
  self.Out:BindToAnimationFinished(self, {
    self,
    function()
      local UIManger = UIManager(self)
      AudioManager(self):SetEventSoundParam(self, "Close", {ToEnd = 1})
      self:OnClose()
      UIManger:LoadUINew("QuestReviewRoot")
    end
  })
  self:PlayAnimation(self.Out)
end

function M:OnClick()
  if self:IsPlayingAnimation(self.Out) then
    return
  end
  if self.bClick then
    AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
    self.Out:BindToAnimationFinished(self, {
      self,
      function()
        AudioManager(self):SetEventSoundParam(self, "Close", {ToEnd = 1})
        self:OnClose()
      end
    })
    self:PlayAnimation(self.Out)
  end
end

function M:OnClose()
  if self.QuestUIId == 100400 then
    AudioManager(self):SetEventSoundParam(self, "Chapter3ToEnd", {ToEnd = 1})
    AudioManager(self):StopSound(self, "Chapter3ToEnd")
  end
  self:Close()
end

function M:OnUpdateUIStyleByInputTypeChange(CurInputType, CurGamepadName)
  if CurInputType == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputType == ECommonInputType.MouseAndKeyboard
  local IsBackUp = self.Type == "BackUp"
  if IsUseKeyAndMouse then
    self.Text_Tips:SetTexT(GText(IsBackUp and "UI_QuestEnd_1301_01" or "UI_GACHA_NEXT"))
    self.Key_Tips:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self.Text_Tips:SetTexT(GText(IsBackUp and "UI_QuestEnd_1301_01" or "UI_CTL_Continue"))
    self.Key_Tips:SetVisibility(UE4.ESlateVisibility.visible)
    if IsBackUp then
      self.Btn_2:SetFocus()
    else
      self:SetFocus()
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_FaceButton_Bottom" == InKeyName and self.bClick and self.Type ~= "BackUp" then
    self:OnClose()
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

return M
