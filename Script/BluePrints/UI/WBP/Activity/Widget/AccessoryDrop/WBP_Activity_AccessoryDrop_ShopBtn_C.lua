require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:BindInputMethodChangedDelegate()
  self.Btn_Click.OnClicked:Add(self, self.GoToShopClick)
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Btn_Click.OnClicked:Remove(self, self.GoToShopClick)
end

function M:InitView(AccessDropConfig, AccessoryDrop, IsRefresh)
  self.AccessDropConfig = AccessDropConfig
  self.EventId = AccessDropConfig.EventId
  self.Text_Name:SetText(GText("Event_FreeAppearance_tittle01"))
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
  if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime and 0 == AccessoryDrop.CurDropBoxNum then
    if self.Panel_Bubble:GetVisibility() == ESlateVisibility.Collapsed then
      self:PlayAnimation(self.Bubble_In)
    end
    self.Text_Bubble:SetText(GText("Event_FreeAppearance_tips12"))
    self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    if self.Panel_Bubble:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self:PlayAnimation(self.Bubble_Out)
    end
    self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if not IsRefresh then
    self:InitGamePadBtn()
  end
  self:UpdateTime()
end

function M:UpdateTime()
  if self.AccessDropConfig then
    local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(ActivityConfigData.EventEndTime)
    self.Time:SetTimeText("", RemainTimeDict)
  end
end

function M:GoToShopClick()
  local PageConfigData = DataMgr.EventPortal[self.EventId]
  if not PageConfigData.EventShop then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_gift_btn_click", nil, nil)
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  if NewGameInputType == ECommonInputType.Gamepad then
    self:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitGamePadBtn()
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
      }
    }
  })
  self:SetGamePadVisibility()
end

function M:SetGamePadVisibility(Op)
  if nil == Op then
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      Op = UIConst.VisibilityOp.SelfHitTestInvisible
    else
      Op = UIConst.VisibilityOp.Collapsed
    end
  end
  self.Key_Controller:SetVisibility(Op)
end

return M
