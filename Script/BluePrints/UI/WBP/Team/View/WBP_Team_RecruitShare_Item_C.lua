require("UnLua")
local UIUtils = require("Utils.UIUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}
local DefaultCooldownSeconds = 30
local CooldownTimerKeyPrefix = "TeamRecruitShareCooldownTimer:"

function M:Initialize(Initializer)
  rawset(self, "ChannelType", nil)
  rawset(self, "RecruitmentData", nil)
  rawset(self, "OnShareRequested", nil)
  rawset(self, "CooldownTimerKey", nil)
  rawset(self, "bRequesting", false)
  rawset(self, "bDestroyed", false)
end

function M:Construct()
  self.bIsFocusable = true
  if self.SetIsFocusable then
    self:SetIsFocusable(true)
  end
  self.bIsDealWithVirtualAccept = true
  self.Btn_Send:BindEventOnClicked(self, self.OnSendClicked)
  self.Btn_Send:SetText(GText("UI_TeamShare"))
  self.Btn_Send:SetDefaultGamePadImg(UIConst.GamePadImgKey.FaceButtonBottom)
  self:SetGamepadKeyVisible(false)
end

function M:SetGamepadKeyVisible(bVisible)
  if self.Btn_Send and self.Btn_Send.SetGamepadIconVisibility then
    self.Btn_Send:SetGamepadIconVisibility(true == bVisible)
  end
end

function M:Init(ChannelType, TitleTextKey, RecruitmentData, OnShareRequested)
  self:StopCooldownTimer()
  self.ChannelType = ChannelType
  self.RecruitmentData = RecruitmentData
  self.OnShareRequested = OnShareRequested
  self.CooldownTimerKey = CooldownTimerKeyPrefix .. tostring(ChannelType)
  self.bRequesting = false
  self.bDestroyed = false
  self.Text_ShareTitle:SetText(GText(TitleTextKey))
  self:RefreshCooldownState()
end

function M:GetCooldownSeconds()
  local CooldownConfig = DataMgr and DataMgr.GlobalConstant and DataMgr.GlobalConstant.TeamRecruitmentShareCD
  local CooldownSeconds = CooldownConfig and tonumber(CooldownConfig.ConstantValue)
  if nil == CooldownSeconds or CooldownSeconds < 0 then
    return DefaultCooldownSeconds
  end
  return CooldownSeconds
end

function M:GetCooldownStore()
  local GameInstance = GWorld and GWorld.GameInstance
  if not GameInstance then
    return nil
  end
  GameInstance.TeamHallRecruitShareCooldowns = GameInstance.TeamHallRecruitShareCooldowns or {}
  return GameInstance.TeamHallRecruitShareCooldowns
end

function M:GetRequestStore()
  local GameInstance = GWorld and GWorld.GameInstance
  if not GameInstance then
    return nil
  end
  GameInstance.TeamHallRecruitShareInFlights = GameInstance.TeamHallRecruitShareInFlights or {}
  return GameInstance.TeamHallRecruitShareInFlights
end

function M:IsRequestInFlight()
  local RequestStore = self:GetRequestStore()
  return RequestStore and RequestStore[self.ChannelType] == true or false
end

function M:SetRequestInFlight(bInFlight)
  local RequestStore = self:GetRequestStore()
  if RequestStore then
    RequestStore[self.ChannelType] = bInFlight and true or nil
  end
end

function M:IsCooldownActive()
  local CooldownStore = self:GetCooldownStore()
  local CooldownInfo = CooldownStore and CooldownStore[self.ChannelType]
  local EndTimeMs = CooldownInfo and CooldownInfo.EndTimeMs
  if EndTimeMs and EndTimeMs > TimeUtils.NowTimeMs() then
    return true
  end
  if CooldownStore then
    CooldownStore[self.ChannelType] = nil
  end
  return false
end

function M:OnSendClicked()
  if self.bRequesting or self:IsRequestInFlight() or self:IsCooldownActive() then
    self:RefreshCooldownState()
    return
  end
  if type(self.OnShareRequested) ~= "function" then
    DebugPrint("WBP_Team_RecruitShare_Item_C:OnSendClicked missing OnShareRequested")
    self:ApplyNormalState()
    return
  end
  self.bRequesting = true
  self:SetRequestInFlight(true)
  self.Btn_Send:ForbidBtn(true)
  local bCompleted = false
  
  local function Complete(bSuccess)
    if bCompleted then
      return
    end
    bCompleted = true
    self:HandleShareCompleted(true == bSuccess)
  end
  
  local bSuccess, ErrorMessage = pcall(self.OnShareRequested, self.ChannelType, self.RecruitmentData, Complete)
  if not bSuccess then
    DebugPrint("WBP_Team_RecruitShare_Item_C:OnSendClicked callback failed: " .. tostring(ErrorMessage))
    Complete(false)
  end
end

function M:HandleShareCompleted(bSuccess)
  self:SetRequestInFlight(false)
  self.bRequesting = false
  if bSuccess then
    self:StartCooldown()
    return
  end
  if not self.bDestroyed then
    self:RefreshCooldownState()
  end
end

function M:StartCooldown()
  local CooldownStore = self:GetCooldownStore()
  local CooldownSeconds = self:GetCooldownSeconds()
  if CooldownStore and CooldownSeconds > 0 then
    CooldownStore[self.ChannelType] = {
      EndTimeMs = TimeUtils.NowTimeMs() + CooldownSeconds * 1000
    }
  elseif CooldownStore then
    CooldownStore[self.ChannelType] = nil
  end
  if not self.bDestroyed then
    self:RefreshCooldownState()
  end
end

function M:RefreshCooldownState()
  self:StopCooldownTimer()
  local CooldownStore = self:GetCooldownStore()
  local CooldownInfo = CooldownStore and CooldownStore[self.ChannelType]
  local EndTimeMs = CooldownInfo and CooldownInfo.EndTimeMs
  local RemainingSeconds = EndTimeMs and math.ceil((EndTimeMs - TimeUtils.NowTimeMs()) / 1000) or 0
  if RemainingSeconds > 0 then
    self.bRequesting = false
    self:ApplyCooldownState(RemainingSeconds)
    self:AddTimer(1, self.OnCooldownTick, true, 1, self.CooldownTimerKey)
    return
  end
  if self:IsRequestInFlight() then
    self.bRequesting = true
    self:ApplyNormalState()
    self:AddTimer(1, self.OnCooldownTick, true, 1, self.CooldownTimerKey)
    return
  end
  if CooldownStore then
    CooldownStore[self.ChannelType] = nil
  end
  self.bRequesting = false
  self:ApplyNormalState()
end

function M:OnCooldownTick()
  local CooldownStore = self:GetCooldownStore()
  local CooldownInfo = CooldownStore and CooldownStore[self.ChannelType]
  local EndTimeMs = CooldownInfo and CooldownInfo.EndTimeMs
  local RemainingSeconds = EndTimeMs and math.ceil((EndTimeMs - TimeUtils.NowTimeMs()) / 1000) or 0
  if RemainingSeconds > 0 then
    self.bRequesting = false
    self:ApplyCooldownState(RemainingSeconds)
    return
  end
  if self:IsRequestInFlight() then
    self.bRequesting = true
    self:ApplyNormalState()
    return
  end
  self:FinishCooldown()
end

function M:FinishCooldown()
  self:StopCooldownTimer()
  local CooldownStore = self:GetCooldownStore()
  if CooldownStore then
    CooldownStore[self.ChannelType] = nil
  end
  self.bRequesting = false
  self:ApplyNormalState()
end

function M:ApplyNormalState()
  self.Btn_Send:SetText(GText("UI_TeamShare"))
  self.Btn_Send:ForbidBtn(self.bRequesting == true)
end

function M:ApplyCooldownState(RemainingSeconds)
  local CooldownText = string.format("%s(%ds)", GText("UI_TeamOperationOnCooldown"), RemainingSeconds)
  self.Btn_Send:SetText(CooldownText)
  self.Btn_Send:ForbidBtn(true)
end

function M:StopCooldownTimer()
  if self.CooldownTimerKey then
    self:RemoveTimer(self.CooldownTimerKey)
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  if not UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    return UE4.UWidgetBlueprintLibrary.Unhandled()
  end
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    local InputEvent = UE4.UWidgetBlueprintLibrary.GetInputEventFromKeyEvent(InKeyEvent)
    if UE4.UKismetInputLibrary.InputEvent_IsRepeat(InputEvent) then
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
    if self.Btn_Send and type(self.Btn_Send.OnBtnClicked) == "function" then
      self.Btn_Send:OnBtnClicked()
      return UE4.UWidgetBlueprintLibrary.Handled()
    end
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnAddedToFocusPath(InFocusEvent)
  self:SetGamepadKeyVisible(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
end

function M:OnRemovedFromFocusPath(InFocusEvent)
  self:SetGamepadKeyVisible(false)
end

function M:EMDestruct()
  self.bDestroyed = true
  self:StopCooldownTimer()
  self:SetGamepadKeyVisible(false)
  if self.Btn_Send then
    self.Btn_Send:UnBindEventOnClickedByObj(self)
  end
  M.Super.EMDestruct(self)
end

AssembleComponents(M)
return M
