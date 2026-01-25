require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")
local RarityBG = {
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Grey.T_Angling_Quality_Grey",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Green.T_Angling_Quality_Green",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Blue.T_Angling_Quality_Blue",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Purple.T_Angling_Quality_Purple",
  "/Game/UI/Texture/Dynamic/Image/Angling/T_Angling_Quality_Yellow.T_Angling_Quality_Yellow"
}
local RarityAnim = {
  "Grey",
  "Green",
  "Blue",
  "Purple",
  "Yellow"
}

function M:OnLoaded(...)
  local Info = (...)
  print(_G.LogTag, "LXZ OnLoaded", Info.FishingSpotId, Info.FishId)
  self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
  self.FishId = Info.FishId
  self.FishingPage = Info.FishingPage
  self.FishSize = Info.FishSize
  self.FishingSpotId = Info.FishingSpotId
  self.bIsNew = Info.IsNew
  self:BindToAnimationFinished(self.IN, {
    self,
    self.OnINEnd
  })
  self:PlayAnimation(self.IN)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutEnd
  })
  self.Btn_Empty.OnClicked:Add(self, self.OnClickEmpty)
  self.Btn_Empty:SetFocus()
  self.Text_Tips:SetText(GText("UI_TRAIN_CLOSE"))
  if self.DeviceInPc then
    self.Key_Continue_Gamepad:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "A"}
      },
      Desc = GText("UI_CTL_Continue")
    })
    self.Key_Check_Gamepad:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightTriggerAnalog
        }
      },
      Desc = GText("UI_Controller_Introduction")
    })
    print(_G.LogTag, "LXZ OnLoaded", UIUtils.CheckScrollBoxCanScroll(self.Scroll_Box))
  end
  self:InitUnLockWidget()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshInfoByInputTypeChange)
  self.CurMode = self.GameInputModeSubsystem:GetCurrentInputType()
  self:RefreshInfoByInputTypeChange(self.CurMode)
  AudioManager(self):PlayUISound(self, "event:/ui/minigame/fish_info_unlock", nil, nil)
end

function M:OnClickEmpty()
  if self:IsPlayingAnimation(self.IN) then
    return
  end
  self:PlayAnimation(self.Out)
end

function M:OnINEnd()
  if not UIUtils.CheckScrollBoxCanScroll(self.Scroll_Box) then
    self.Key_Check_Gamepad:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function M:OnOutEnd()
  local ResourceId = DataMgr.Fish[self.FishId].ResourceId
  UIUtils.ShowHudReward(GText("UI_Fishing_Reward"), {
    {
      ItemType = "Resource",
      ItemId = ResourceId,
      Count = 1,
      Rarity = ItemUtils.GetItemRarity(ResourceId, "Resource")
    }
  })
  self:Close()
end

function M:InitUnLockWidget()
  local Data = DataMgr.Fish[self.FishId]
  if not Data or not Data.ResourceId then
    GWorld.logger.error("鱼" .. self.FishId .. "没有数据或资源id")
    return
  end
  local ResourceData = DataMgr.Resource[Data.ResourceId]
  if not ResourceData then
    GWorld.logger.error("鱼资源" .. Data.ResourceId .. "没有资源数据")
    return
  end
  local IconPath = DataMgr.Fish[self.FishId].IconPath
  if IconPath then
    local Icon = LoadObject(IconPath)
    self.Icon_Fish:SetBrushResourceObject(Icon)
  end
  print(_G.LogTag, "LXZ InitUnLockWidget", self.FishId, Data.FishType)
  if 3 == Data.FishType then
    self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_Fishing_FishType_3"))
    self.Text_Title:SetColorAndOpacity(self.Text_King)
    self.WS_Type:SetActiveWidgetIndex(0)
  elseif 2 == Data.FishType then
    self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_Fishing_FishType_2"))
    self.Text_Title:SetColorAndOpacity(self.Text_Variation)
    self.WS_Type:SetActiveWidgetIndex(1)
  elseif 4 == Data.FishType then
    self.Panel_Title:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Title:SetText(GText("UI_Fishing_FishType_4"))
    self.Text_Title:SetColorAndOpacity(self.Text_Variation)
    self.WS_Type:SetActiveWidgetIndex(1)
  else
    self.Panel_Title:SetVisibility(ESlateVisibility.Collapsed)
  end
  local Rarity = ResourceData.Rarity
  local Icon = LoadObject(RarityBG[Rarity])
  self.Img_Quality:GetDynamicMaterial():SetTextureParameterValue("MainTex", Icon)
  self:PlayAnimation(self[RarityAnim[Rarity]])
  self.Text_FishName:SetText(GText(ResourceData.ResourceName))
  self.Text_Describe:SetText(GText(ResourceData.DetailDes))
  self.Text_Lv:SetText(Data.FishLevel)
  self.List_Text:ClearListItems()
  local Weight = self:GetWeight()
  local WeightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Size.T_Angling_Size", Weight)
  self.List_Text:AddItem(WeightContent)
  local Place = self:GetPlace()
  local PlaceContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Location.T_Angling_Location", Place)
  self.List_Text:AddItem(PlaceContent)
  if self.bIsNew then
    self.New:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_Top:SetText(GText("UI_Fishing_UnlockFishBook"))
  else
    self.New:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_Top:SetText(GText("UI_Fishing_Success"))
  end
  local Text, FishAppearPeriod = self:GetDayNight()
  print(_G.LogTag, "LXZ GetDayNight222", FishAppearPeriod)
  local DayNightContent = self:NewTextContent("/Game/UI/Texture/Dynamic/Atlas/Angling/T_Angling_Time.T_Angling_Time", Text, FishAppearPeriod)
  self.List_Text:AddItem(DayNightContent)
end

function M:GetWeight()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return 10
  end
  return self.FishSize
end

function M:GetPlace()
  local SpotData = DataMgr.FishingSpot[self.FishingSpotId]
  if not SpotData or not SpotData.FishingSpotName then
    return "找不到钓鱼点"
  end
  local Name = SpotData.FishingSpotName
  return Name
end

function M:GetDayNight()
  print(_G.LogTag, "LXZ GetDayNight")
  local Data = DataMgr.Fish[self.FishId]
  if not Data then
    return "找不到鱼数据", nil
  end
  local FishAppearPeriod = Data.FishAppearPeriod
  if not FishAppearPeriod then
    return "找不到鱼活跃时段", nil
  end
  print(_G.LogTag, "LXZ GetDayNight111", FishAppearPeriod)
  return nil, FishAppearPeriod
end

function M:NewTextContent(IconPath, Text, FishAppearPeriod)
  local Class = LoadClass("/Game/UI/WBP/Angling/Widget/Angling_TextItem_Content.Angling_TextItem_Content")
  local Obj = NewObject(Class)
  Obj.IconPath = IconPath
  Obj.Text = Text
  if FishAppearPeriod then
    Obj.IsTime = true
    for i, v in pairs(FishAppearPeriod) do
      if 1 == v then
        Obj.IsMorn = true
      elseif 2 == v then
        Obj.IsNoon = true
      elseif 3 == v then
        Obj.IsNight = true
      end
    end
  end
  return Obj
end

function M:RefreshInfoByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.DeviceInPc then
    self.Switcher_Text:SetActiveWidgetIndex(0)
  elseif CurInputDevice == ECommonInputType.Gamepad and self.DeviceInPc then
    self.Switcher_Text:SetActiveWidgetIndex(1)
  elseif CurInputDevice == ECommonInputType.Touch then
    self.Switcher_Text:SetActiveWidgetIndex(0)
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  print(_G.LogTag, "LXZ OnAnalogValueChanged")
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if "Gamepad_RightX" == InKeyName then
    self.MoveDeltaX = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  elseif "Gamepad_RightY" == InKeyName then
    self.MoveDeltaY = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
  end
  local InKeyName
  if self.MoveDeltaY and 0 ~= self.MoveDeltaY then
    if self.MoveDeltaY > 0.5 then
      InKeyName = "Gamepad_RightStick_Up"
    elseif self.MoveDeltaY < -0.5 then
      InKeyName = "Gamepad_RightStick_Down"
    end
    local DeltaOffset = -1 * UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
    local CurrentOffset = self.Scroll_Box:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset + DeltaOffset, 0, self.Scroll_Box:GetScrollOffsetOfEnd())
    self.Scroll_Box:SetScrollOffset(NextOffset)
  end
  return UIUtils.Handled
end

return M
