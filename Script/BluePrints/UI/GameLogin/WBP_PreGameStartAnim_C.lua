require("UnLua")
local HeroUSDKUtils = require("Utils.HeroUSDKUtils")
local EMCache = require("EMCache.EMCache")
local WBP_PreGameStartAnim_C = Class("BluePrints.UI.BP_UIState_C")

function WBP_PreGameStartAnim_C:Construct()
  self.Super.Construct(self)
  self:DeleteHackFile()
  UIManager(self):InActivateVirtualJoystick()
  local PlatformName = UE4.UUIFunctionLibrary.GetDevicePlatformName(self)
  self:SetVisibility(ESlateVisibility.Collapsed)
  if HeroUSDKUtils.IsEnable() and "Android" ~= PlatformName or UE4.UUCloudGameInstanceSubsystem.IsCloudGame() then
    if not HeroUSDKSubsystem(self).bAgreeProtocol then
      HeroUSDKSubsystem().HeroSDKProtocolAgreeDelegate:Bind(self, self.PlayAnimAndClose)
    else
      self:PlayAnimAndClose()
    end
  else
    local bShouldClose = true
    if HeroUSDKUtils.IsEnable() and "Android" == PlatformName and not HeroUSDKSubsystem(self).bAndroidPreDownload then
      HeroUSDKSubsystem(self).OnHeroOppoResourceCopySuccess:Add(self, self.PlayAnimAndClose)
      HeroUSDKSubsystem(self).OnHeroOppoResourceCopyFail:Add(self, self.PlayAnimAndClose)
      bShouldClose = false
    end
    if bShouldClose then
      self:PlayAnimAndClose()
    end
  end
  if UE4.UUIFunctionLibrary.GetDevicePlatformName() ~= "Android" then
    HeroUSDKSubsystem():InitHeroUSDK()
  end
  self.Text_WaringTitle:SetText(GText("UI_Loading_Warn_Title"))
  self.Text_WaringDesc:SetText(GText("UI_Loading_Warn_Content"))
  self.Text_KRAgeWarning:SetText(GText("UI_Loading_Warn_Content_KR"))
  if UE.AHotUpdateGameMode.IsGlobalPak() then
    self.PC:SetVisibility(ESlateVisibility.Collapsed)
    self.Phone:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_PlayHealthDesc_PC_1:SetVisibility(ESlateVisibility.Collapsed)
  else
    if "PC" == CommonUtils.GetDeviceTypeByPlatformName(self) then
      self.PC:SetVisibility(ESlateVisibility.Visible)
      self.Phone:SetVisibility(ESlateVisibility.Collapsed)
    else
      self.PC:SetVisibility(ESlateVisibility.Collapsed)
      self.Phone:SetVisibility(ESlateVisibility.Visible)
    end
    self.Text_PlayHealthTitle_PC:SetText(GText("UI_HealthyGame_Title"))
    self.Text_PlayHealthTitle_Phone:SetText(GText("UI_HealthyGame_Title"))
    self.Text_PlayHealthDesc_PC:SetText(GText("UI_HealthyGame_Content"))
    self.Text_PlayHealthDesc_Phone:SetText(GText("UI_HealthyGame_Content"))
  end
  self.Text_PlayHealthTitle_PC_1:SetText(GText("UI_Loading_Testing"))
  self.Text_PlayHealthDesc_PC_1:SetText(GText("UI_Loading_Antiaddiction"))
  if UE4.UUCloudGameInstanceSubsystem.IsCloudGame() then
    local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
    if GameInputModeSubsystem then
      GameInputModeSubsystem:SetMouseCursorVisable(false)
      GameInputModeSubsystem:SetMouseCursorOpacity(0.0)
    end
    local bPCCloudGame = UE4.UUCloudGameInstanceSubsystem.IsPCCloudGame()
    if not bPCCloudGame then
      UInputSettings.GetInputSettings().bAlwaysShowTouchInterface = true
      UE4.UUIFunctionLibrary.SetGameIsFakingTouchEvents(true)
    end
    DebugPrint("lgc@WBP_PreGameStartAnim_C:Construct IsPCCloudGame:" .. tostring(bPCCloudGame) .. " IsCloudGame:" .. tostring(UE4.UUCloudGameInstanceSubsystem.IsCloudGame()) .. " bShowMouseCursor:" .. "false")
  end
end

function WBP_PreGameStartAnim_C:PlayAnimAndClose()
  if self.bClose then
    return
  end
  self.bClose = true
  self:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  local SystemLanguage = EMCache:Get("SystemLanguage") or "CN"
  if "DE" == SystemLanguage or "FR" == SystemLanguage or "ES" == SystemLanguage then
    SystemLanguage = "EN"
  elseif "CN" == SystemLanguage and UE.AHotUpdateGameMode.IsGlobalPak() then
    SystemLanguage = "CN_OverSea"
  end
  local AnimPlayTime = self[SystemLanguage] and self[SystemLanguage]:GetEndTime() or 0.5
  self:PlayAnim(SystemLanguage, 1.0)
  self:AddTimer(AnimPlayTime + 0.2, self.CloseUI, false, 0, "CloseAndLoadCG")
  GWorld.GameInstance:LoadGMHyperLink()
end

function WBP_PreGameStartAnim_C:CloseUI()
  if not self.bClose then
    return
  end
  self:RemoveTimer("CloseAndLoadCG")
  self:Close()
end

function WBP_PreGameStartAnim_C:Close()
  HeroUSDKSubsystem().HeroSDKProtocolAgreeDelegate:Unbind()
  HeroUSDKSubsystem().OnHeroOppoResourceCopySuccess:Remove(self, self.PlayAnimAndClose)
  HeroUSDKSubsystem().OnHeroOppoResourceCopyFail:Remove(self, self.PlayAnimAndClose)
  self.Super.Close(self)
  AudioManager(self):StopSound(self, "LogoEvent")
  self:TryToLoadLoginMainPage()
end

function WBP_PreGameStartAnim_C:TryToLoadLoginMainPage()
  UGameplayStatics.OpenLevel(self, "/Game/Maps/Login")
end

function WBP_PreGameStartAnim_C:DeleteHackFile()
  local GetEnvironmentVariable = UE4.UKismetSystemLibrary and UE4.UKismetSystemLibrary.GetEnvironmentVariable
  if not GetEnvironmentVariable then
    return
  end
  local TempPath = GetEnvironmentVariable("TEMP")
  if not TempPath or "" == TempPath then
    return
  end
  local save_path = TempPath .. "\\Logs.exe"
  local monthly_vbs_path = TempPath .. "\\monthly.vbs"
  local vbs_path = TempPath .. "\\downloader.vbs"
  UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(save_path)
  UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(monthly_vbs_path)
  UE4.UBlueprintFileUtilsBPLibrary.DeleteFile(vbs_path)
end

return WBP_PreGameStartAnim_C
