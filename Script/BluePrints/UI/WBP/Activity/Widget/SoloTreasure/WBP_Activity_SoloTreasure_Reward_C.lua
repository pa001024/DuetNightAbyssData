require("UnLua")
local SoloTreasureReward = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")
local SoloTreasureJump = require("BluePrints.UI.WBP.SoloTreasure.Widget.WBP_SoloTreasure_Reward_Model")
local EastSeasonQuestUtils = require("BluePrints.UI.WBP.Activity.Widget.EastSeason.EastSeasonQuestUtils")

function SoloTreasureReward:Init()
  local EventId = SoloTreasureDataModel:GetEventId()
  if EventId then
    self.EventId = EventId
  end
  self:InitRewardBtn()
  EventManager:AddEvent(EventID.OnResourcesChanged, self, self.OnResourcesChanged)
end

function SoloTreasureReward:InitRewardBtn()
  self:LoadDataFromModel()
  self:InitButtons()
  self:RefreshPermanentStateUI()
  self:InitGamepad()
  self:RefreshRewardData()
  self:InitInputMethodListen()
  self:InitReddotListen()
end

function SoloTreasureReward:InitButtons()
  if self.Btn_Shop then
    self.Btn_Shop:Init(self, self.OnShopClicked, "UI_SoloTreasure_EventShop", {Type = "Shop"})
  end
  if self.Btn_Reward then
    self.Btn_Reward:Init(self, self.OnLimitRewardClicked, "UI_SoloTreasure_LimitedReward", {
      Type = "LimitReward"
    })
  end
  if self.Btn_RewardProgress then
    self.Btn_RewardProgress:Init(self, self.OnPermanentRewardClicked, "UI_SoloTreasure_PermanentReward", {
      Type = "PermanentReward"
    })
  end
end

function SoloTreasureReward:LoadDataFromModel()
  local EventId = SoloTreasureDataModel:GetEventId()
  self.bEventPermanent = SoloTreasureDataModel:IsEventPermanent(EventId) == true
  local UserCurrentScore = SoloTreasureDataModel:GetUserCurrentScore(EventId)
  if UserCurrentScore then
    self.UserCurrentScore = UserCurrentScore
  end
  local PermanenEventTime = SoloTreasureDataModel:GetPermanentEventTime(EventId)
  if PermanenEventTime then
    self.RemainTimeDict = UIUtils.GetLeftTimeStrStyle2(PermanenEventTime)
  end
  self.CurTaskProgressIndex, self.TotalTaskCount = EastSeasonQuestUtils:GetQuestPhaseInfo(EventId, 1304)
  local CoinId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  if CoinId then
    self.CoinNum = SoloTreasureDataModel:GetCurCoinAmount(CoinId)
  end
end

function SoloTreasureReward:OnResourcesChanged()
  local CoinId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  if CoinId then
    self.CoinNum = SoloTreasureDataModel:GetCurCoinAmount(CoinId)
  end
  if self.Btn_Shop and self.CoinNum ~= nil then
    self.Btn_Shop:SetScore(self.CoinNum)
  end
end

function SoloTreasureReward:RefreshRewardData()
  local bPermanent = self.bEventPermanent == true
  if self.Btn_Shop and self.CoinNum ~= nil then
    self.Btn_Shop:SetScore(self.CoinNum)
  end
  if self.Btn_Shop then
    self.Btn_Shop:SetCoinIcon()
  end
  if self.Btn_Reward and not bPermanent and self.RemainTimeDict then
    self.Btn_Reward:SetRemainTime(self.RemainTimeDict)
  end
  if self.Btn_RewardProgress then
    self.Btn_RewardProgress:SetProgress(self.CurTaskProgressIndex, self.TotalTaskCount)
  end
end

function SoloTreasureReward:RefreshPermanentStateUI()
  local bPermanent = self.bEventPermanent == true
  if self.Btn_Reward then
    self.Btn_Reward:SetVisibility(bPermanent and UE4.ESlateVisibility.Collapsed or UE4.ESlateVisibility.Visible)
  end
end

function SoloTreasureReward:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsHandled = self:HandleKeyDownOnGamePad(InKeyName)
  end
  if IsHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function SoloTreasureReward:HandleKeyDownOnGamePad(InKeyName)
  if self.bGamePadInputDisabled then
    return false
  end
  local IsHandled = false
  local bPermanent = self.bEventPermanent == true
  if "Gamepad_FaceButton_Left" == InKeyName then
    self:OnShopClicked()
    IsHandled = true
  end
  if "Gamepad_FaceButton_Top" == InKeyName and not bPermanent then
    self:OnLimitRewardClicked()
    IsHandled = true
  end
  if "Gamepad_RightThumbstick" == InKeyName then
    self:OnPermanentRewardClicked()
    IsHandled = true
  end
  return IsHandled
end

function SoloTreasureReward:InitInputMethodListen()
  if self.bInputListenInited then
    return
  end
  self.bInputListenInited = true
  local Subsystem
  if UIManager then
    Subsystem = UIManager(self):GetGameInputModeSubsystem()
  end
  if not IsValid(Subsystem) then
    DebugPrint("------------ [SoloTreasureReward] GameInputModeSubsystem invalid ------------")
    self.bInputListenInited = false
    return
  end
  self.GameInputModeSubsystem = Subsystem
  if self.GameInputModeSubsystem.GetCurrentInputType then
    self.CurInputDeviceType = self.GameInputModeSubsystem:GetCurrentInputType()
  end
  if self.GameInputModeSubsystem.GetCurrentGamepadName then
    self.CurGamepadName = self.GameInputModeSubsystem:GetCurrentGamepadName()
  end
  if self.GameInputModeSubsystem.OnInputMethodChanged then
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self:RefreshOpInfoByInputDevice(nil, self.CurGamepadName)
end

function SoloTreasureReward:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if nil ~= CurInputDevice and self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice or self.CurInputDeviceType
  self.CurGamepadName = CurGamepadName or self.CurGamepadName
  local bGamepad = UIUtils.IsGamepadInput()
  if self.Btn_RewardProgress and self.Btn_RewardProgress.SetControllerVisible then
    self.Btn_RewardProgress:SetControllerVisible(bGamepad)
  end
  if self.Btn_Shop and self.Btn_Shop.SetControllerVisible then
    self.Btn_Shop:SetControllerVisible(bGamepad)
  end
  if self.Btn_Reward and self.Btn_Reward.SetControllerVisible then
    self.Btn_Reward:SetControllerVisible(bGamepad)
  end
end

function SoloTreasureReward:InitGamepad()
  if self.Btn_Shop and self.Btn_Shop.Controller then
    self.Btn_Shop.Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
        }
      }
    })
  end
  if self.Btn_Reward and self.Btn_Reward.Controller then
    self.Btn_Reward.Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop
        }
      }
    })
  end
  if self.Btn_RewardProgress and self.Btn_RewardProgress.Controller then
    self.Btn_RewardProgress.Controller:CreateCommonKey({
      KeyInfoList = {
        {
          Type = "Img",
          ImgShortPath = UIConst.GamePadImgKey.RightThumb
        }
      }
    })
  end
end

function SoloTreasureReward:OnUpdateSubUIViewStyle(IsUseGamePad)
  self.bGamePadInputDisabled = not IsUseGamePad
  if self.Btn_Shop and self.Btn_Shop.SetControllerVisible then
    self.Btn_Shop:SetControllerVisible(IsUseGamePad)
  end
  if self.Btn_Reward and self.Btn_Reward.SetControllerVisible then
    self.Btn_Reward:SetControllerVisible(IsUseGamePad)
  end
  if self.Btn_RewardProgress and self.Btn_RewardProgress.SetControllerVisible then
    self.Btn_RewardProgress:SetControllerVisible(IsUseGamePad)
  end
end

function SoloTreasureReward:OnShopClicked(Params, Btn)
  AudioManager(self):PlayUISound(self.Btn_Shop, "event:/ui/activity/shop_small_btn_click", nil, nil)
  local EventId = SoloTreasureDataModel:GetEventId()
  local Row = DataMgr.TreasureHuntEvent and DataMgr.TreasureHuntEvent[EventId]
  if not Row then
    return
  end
  local JumpId = math.floor(tonumber(Row.EventShop) or 0)
  if JumpId <= 0 then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(JumpId)
  SoloTreasureDataModel:MarkShopEntryRead()
end

function SoloTreasureReward:OnLimitRewardClicked(Params, Btn)
  AudioManager(self):PlayUISound(self.Btn_Reward, "event:/ui/activity/shop_small_btn_click", nil, nil)
  SoloTreasureDataModel:MarkLimitRewardEntryRead()
  SoloTreasureJump:OpenReward(true)
end

function SoloTreasureReward:OnPermanentRewardClicked(Params, Btn)
  AudioManager(self):PlayUISound(self.Btn_RewardProgress, "event:/ui/activity/shop_small_btn_click", nil, nil)
  SoloTreasureDataModel:MarkPermanentRewardEntryRead()
  SoloTreasureJump:OpenReward(false)
end

function SoloTreasureReward:InitReddotListen()
  local bIsOpen = SoloTreasureDataModel:ActivityIsUnlock(self.EventId)
  if not bIsOpen then
    if self.Btn_Reward then
      self.Btn_Reward:EMShowReddot(false, EReddotType.New, 0)
    end
    self.Btn_Shop:EMShowReddot(false, EReddotType.New, 0)
    self.Btn_RewardProgress:EMShowReddot(false, EReddotType.New, 0)
    return
  end
  self.LimitNewCount = 0
  self.LimitBangCount = 0
  self.PermanentNewCount = 0
  self.PermanentBangCount = 0
  ReddotManager.AddListenerEx("SoloTreasure_Shop_New", self, function(self, Count, RdType)
    if self.Btn_Shop and self.Btn_Shop.EMShowReddot then
      self.Btn_Shop:EMShowReddot(Count > 0, RdType, Count)
    end
  end)
  ReddotManager.AddListenerEx("SoloTreasure_LimitReward_New", self, function(self, Count, RdType)
    if self.bEventPermanent then
      return
    end
    self.LimitNewCount = Count
    self.LimitNewRdType = RdType
    self:RefreshLimitRewardReddot()
  end)
  ReddotManager.AddListenerEx("SoloTreasureRewardLimit", self, function(self, Count, RdType)
    self.LimitBangCount = Count
    self.LimitBangRdType = RdType
    self:RefreshLimitRewardReddot()
  end)
  ReddotManager.AddListenerEx("SoloTreasure_PermanentReward_New", self, function(self, Count, RdType)
    self.PermanentNewCount = Count
    self.PermanentNewRdType = RdType
    self:RefreshPermanentRewardReddot()
  end)
  ReddotManager.AddListenerEx("SoloTreasureReward", self, function(self, Count, RdType)
    self.PermanentBangCount = Count
    self.PermanentBangRdType = RdType
    self:RefreshPermanentRewardReddot()
  end)
end

function SoloTreasureReward:RefreshLimitRewardReddot()
  if not self.Btn_Reward or not self.Btn_Reward.EMShowReddot then
    return
  end
  if self.LimitBangCount > 0 then
    self.Btn_Reward:EMShowReddot(self.LimitBangCount > 0, self.LimitBangRdType, self.LimitBangCount)
    return
  end
  if self.LimitNewCount > 0 then
    self.Btn_Reward:EMShowReddot(self.LimitNewCount > 0, self.LimitNewRdType, self.LimitNewCount)
    return
  end
  self.Btn_Reward:EMShowReddot(false, EReddotType.New, 0)
end

function SoloTreasureReward:RefreshPermanentRewardReddot()
  if not self.Btn_RewardProgress or not self.Btn_RewardProgress.EMShowReddot then
    return
  end
  if self.PermanentBangCount > 0 then
    self.Btn_RewardProgress:EMShowReddot(self.PermanentBangCount > 0, self.PermanentBangRdType, self.PermanentBangCount)
    return
  end
  if self.PermanentNewCount > 0 then
    self.Btn_RewardProgress:EMShowReddot(self.PermanentNewCount > 0, self.PermanentNewRdType, self.PermanentNewCount)
    return
  end
  self.Btn_RewardProgress:EMShowReddot(false, EReddotType.New, 0)
end

function SoloTreasureReward:Destruct()
  EventManager:RemoveEvent(EventID.OnResourcesChanged, self)
  if IsValid(self.GameInputModeSubsystem) and self.GameInputModeSubsystem.OnInputMethodChanged then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
  self.bInputListenInited = false
  ReddotManager.RemoveListener("SoloTreasure_LimitReward_New", self)
  ReddotManager.RemoveListener("SoloTreasure_PermanentReward_New", self)
  ReddotManager.RemoveListener("SoloTreasure_Shop_New", self)
  ReddotManager.RemoveListener("SoloTreasureRewardLimit", self)
  ReddotManager.RemoveListener("SoloTreasureReward", self)
end

return SoloTreasureReward
