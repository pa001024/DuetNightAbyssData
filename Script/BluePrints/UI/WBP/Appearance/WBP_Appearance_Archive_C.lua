require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Super.Construct(self)
  self.Type2Entry = {
    Skin = self.Btn_AvatarSkin,
    CharAccessory = self.Btn_AvatarAccessory,
    WeaponSkin = self.Btn_WeaponSkin,
    WeaponAccessory = self.Btn_WeaponAccessory,
    Mount = self.Btn_Mounts,
    Resource = self.Btn_Gesture
  }
  self.Type2EntranceId = {}
  for EntranceId, Info in pairs(DataMgr.AppearanceCollect) do
    self.Type2EntranceId[Info.Type] = EntranceId
  end
  if self.Out then
    self:BindToAnimationFinished(self.Out, {
      self,
      self.Close
    })
  end
  self:Init()
  self:PlayInAnim()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  self:InitListenEvent()
  self:InitWidgetInfoInGamePad()
end

function M:Destruct()
  if self.Out then
    self:UnbindAllFromAnimationFinished(self.Out)
  end
  self:ClearListenEvent()
  self.Btn_Check:UnBindEventOnClicked(self, self.OpenFenghuaReward)
  self.Super.Destruct(self)
end

function M:OnLoaded(...)
  self.Super.OnLoaded(self, ...)
end

function M:Init()
  self:InitTable()
  self:InitEntry()
  self:InitRewardBtn()
  self:InitCheckBtn()
  self:RefreshFenghuaNum()
  self.Text_Fernghua:SetText(GText("UI_AppearanceScore_ScoreName"))
end

function M:InitRewardBtn()
  self.Btn_Reward:BindEventOnClicked(self, self.OpenFenghuaReward)
end

function M:InitCheckBtn()
  self.Btn_Check:BindEventOnClicked(self, self.OpenFenghuaDialog)
end

function M:InitEntry()
  for Type, Entry in pairs(self.Type2Entry) do
    Entry:Init(self.Type2EntranceId[Type], Type, DataMgr.AppearanceCollect[self.Type2EntranceId[Type]])
  end
end

function M:InitTable()
  self.TabConfigData = {
    TitleName = GText("UI_AppearanceScore_AppIllustrated"),
    DynamicNode = {"Back", "BottomKey"},
    StyleName = "Text",
    OwnerPanel = self,
    BackCallback = self.OnClickBack,
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "A"}
        },
        Desc = GText("UI_Tips_Ensure"),
        bLongPress = false
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnClickBack,
            Owner = self
          }
        },
        GamePadInfoList = {
          {Type = "Img", ImgShortPath = "B"}
        },
        Desc = GText("UI_BACK"),
        bLongPress = false
      }
    }
  }
  self.Com_Tab:Init(self.TabConfigData)
end

function M:RefreshFenghuaNum()
  local Avatar = GWorld:GetAvatar()
  local FenghuaNum = 0
  if Avatar and Avatar.AppearanceScores then
    FenghuaNum = Avatar.AppearanceScores.Total or 0
  end
  self.Num_Fenghua:SetText(FenghuaNum)
end

function M:OpenFenghuaReward()
  UIManager(self):LoadUINew("AppearanceFenghuaReward")
end

function M:OpenFenghuaDialog()
  UIManager(self):ShowCommonPopupUI(100374, {}, self)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if InKeyName == UIConst.GamePadKey.FaceButtonTop then
      IsEventHandled = true
      self.Btn_Reward:OnCellClicked()
    elseif InKeyName == UIConst.GamePadKey.SpecialLeft then
      IsEventHandled = true
      self.Btn_Check:OnBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
      IsEventHandled = true
      self:OnReturnKeyDown()
    end
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    self:OnReturnKeyDown()
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnReturnKeyDown()
  UIUtils.PlayCommonBtnSe(self)
  self:OnClickBack()
end

function M:OnClickBack()
  if self:CheckIsCanCloseSelf() then
    self:PlayOutAnim()
  end
end

function M:PlayInAnim()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  self:PlayAnimationForward(self.In)
end

function M:PlayOutAnim()
  if self:IsAnimationPlaying(self.Out) then
    return
  end
  if self.Out then
    self:PlayAnimationForward(self.Out)
  else
    self:Close()
  end
end

function M:Close()
  self.Super.Close(self)
end

function M:CheckIsCanCloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return false
  end
  return true
end

function M:InitListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:ClearListenEvent()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if IsUseKeyAndMouse then
    self:InitKeyboardView()
  else
    self:InitGamepadView()
  end
end

function M:InitGamepadView()
  if UIUtils.HasAnyFocus(self) then
    self.Btn_AvatarSkin:SetFocus()
  end
  self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self.Btn_Check:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  if self.Key_Check_GamePad then
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.Btn_Reward.Key_GamePad then
    self.Btn_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  end
  if self.WS_MP then
    self.WS_MP:SetActiveWidgetIndex(1)
  end
end

function M:InitKeyboardView()
  self.Btn_Reward:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Check:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.Key_Check_GamePad then
    self.Key_Check_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.Btn_Reward.Key_GamePad then
    self.Btn_Reward.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.WS_MP then
    self.WS_MP:SetActiveWidgetIndex(0)
  end
end

function M:InitWidgetInfoInGamePad()
  if self.Key_Check_GamePad then
    self.Key_Check_GamePad:CreateGamepadKey("View")
  end
  if self.Btn_Reward.Key_GamePad then
    self.Btn_Reward.Key_GamePad:CreateGamepadKey("Y")
  end
end

function M:BP_GetDesiredFocusTarget()
  return self.Btn_AvatarSkin.Btn_Area
end

function M:OnShow(ShowTag)
  if self:IsAnimationPlaying(self.In_2) then
    return
  end
  self:PlayAnimationForward(self.In_2)
end

return M
