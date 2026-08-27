require("UnLua")

local function DeriveTypeModule(BaseModule)
  local TypeModule = {}
  for Name, Value in pairs(BaseModule) do
    TypeModule[Name] = Value
  end
  return TypeModule
end

local WorldPromptBase = {}

function WorldPromptBase:Init()
  self.Key:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        Text = CommonUtils:GetActionMappingKeyName("Interactive")
      }
    }
  })
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIUtils.GetIconListByActionName("Interactive")[1]
      }
    }
  })
  self.bInScreen = false
  self.ScreenLocation = FVector2D(0, 0)
  self.CacheScreenPos = FVector2D(0, 0)
  self.TargetWorldLoc = FVector(0, 0, 0)
  self.CurrentWorldLoc = FVector(0, 0, 0)
  self.CenterPos = FVector2D(0, 0)
  self.OvalSize = FVector2D(0, 0)
  self.BoardSize = FVector2D(30, 30)
  self.CurrentOffsetOnDoor = 0
  self.OffsetLerpInterval = 0
  self.DeviceInPc = CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile"
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  self:OnUpdateUIStyleByInputTypeChange(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  self:OnTypeInit()
end

function WorldPromptBase:OnTypeInit()
end

function WorldPromptBase:EnsureInteractiveInput()
  if not self:IsListeningForInputAction("Interactive") then
    self:ListenForInputAction("Interactive", EInputEvent.IE_Pressed, true, {
      self,
      self.PressedSelectAction
    })
    self:ListenForInputAction("Interactive", EInputEvent.IE_Released, true, {
      self,
      self.ReleasedSelectAction
    })
  end
end

function WorldPromptBase:UpdateOwner(Owner, InteractionComp, PlayerActor, PromptWorldLoc)
  self:EnsureInteractiveInput()
  self.Player = PlayerActor
  self:OnOwnerUpdated(Owner, InteractionComp, PromptWorldLoc)
end

function WorldPromptBase:OnOwnerUpdated(Owner, InteractionComp, PromptWorldLoc)
end

function WorldPromptBase:ReleasedSelectAction()
end

function WorldPromptBase:RefreshWorldLoc(Loc)
  local ViewportSize = UIManager(self):GetViewportSize()
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    self.CenterPos.X, self.CenterPos.Y = ViewportSize.X * 0.5, ViewportSize.Y * 0.463
    self.OvalSize.X, self.OvalSize.Y = 0.6 * ViewportSize.X * 0.5, 0.55 * ViewportSize.Y * 0.5
  elseif CommonUtils.GetDeviceTypeByPlatformName(self) == "PC" then
    self.CenterPos.X, self.CenterPos.Y = ViewportSize.X * 0.5, ViewportSize.Y * 0.4723
    self.OvalSize.X, self.OvalSize.Y = 0.62 * ViewportSize.X * 0.5, 0.532 * ViewportSize.Y * 0.5
  end
  local Controller = UGameplayStatics.GetPlayerController(self, 0)
  local CurrentOffsetOnDoor, LocLerpFinished, IndicatorAngle, TargetDistance, CurrentDistance, IsOutElliptic, IsOutScreen = UUIFunctionLibrary.LerpAndProjectWorldToScreenInEllipse(Controller, Loc, Loc, 3, self.ScreenLocation, self.CenterPos, self.OvalSize, self.BoardSize, false, 0, self.CurrentOffsetOnDoor, self.OffsetLerpInterval, false, 0, 0, 0, false)
  if not IsOutElliptic then
    local CanvasSlot = UWidgetLayoutLibrary.SlotAsCanvasSlot(self.WS_Type)
    local ViewPortScale = UWidgetLayoutLibrary.GetViewportScale(self)
    self.CacheScreenPos:Set(self.ScreenLocation.X / ViewPortScale, self.ScreenLocation.Y / ViewPortScale)
    CanvasSlot:SetPosition(self.CacheScreenPos)
    self.WS_Type:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.bInScreen = true
  else
    self.WS_Type:SetVisibility(ESlateVisibility.Collapsed)
    self.bInScreen = false
  end
end

function WorldPromptBase:OnUpdateUIStyleByInputTypeChange(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.MouseAndKeyboard and self.DeviceInPc then
    self.WS_Type:SetActiveWidgetIndex(0)
  elseif CurInputDevice == ECommonInputType.Gamepad and self.DeviceInPc then
    self.WS_Type:SetActiveWidgetIndex(1)
  elseif CurInputDevice == ECommonInputType.Touch then
  end
end

local WBP_Battle_HookLock_P_C_Hook = DeriveTypeModule(WorldPromptBase)

function WBP_Battle_HookLock_P_C_Hook:OnOwnerUpdated(Hook, HookComp, PromptWorldLoc)
  self.Hook = Hook
  self.HookComp = HookComp
end

function WBP_Battle_HookLock_P_C_Hook:PressedSelectAction()
  print(_G.LogTag, "LXZ PressedSelectAction")
  if not self.bInScreen then
    return
  end
  self.HookComp:StartInteractive(self.Player)
end

function WBP_Battle_HookLock_P_C_Hook:ReleasedSelectAction()
  print(_G.LogTag, "LXZ ReleasedSelectAction")
end

function WBP_Battle_HookLock_P_C_Hook:ReleasedSpace()
  print(_G.LogTag, "LXZ ReleasedSpace")
  self.HookComp:EndInteractive(self.Player)
end

function WBP_Battle_HookLock_P_C_Hook:RefreshKeyLoc(FXLocComp)
  if not IsValid(FXLocComp) then
    return
  end
  self:RefreshWorldLoc(FXLocComp:K2_GetComponentLocation())
end

function WBP_Battle_HookLock_P_C_Hook:RealTick(MyGeometry, InDeltaTime)
  if IsValid(self.HookComp) then
    local Owner = self.HookComp:GetOwner()
    self:RefreshKeyLoc(Owner.FXLoc)
  end
end

local WBP_Battle_HookLock_P_C_SlideSpline = DeriveTypeModule(WorldPromptBase)
local HOOK_HINT_SOUND_PATH = "event:/sfx/common/player/action/commnon_gousuo_hint"
local HOOK_HINT_SOUND_KEY = "GousuoHint"

function WBP_Battle_HookLock_P_C_SlideSpline:OnTypeInit()
  self:SetSlideSplineIcon()
end

function WBP_Battle_HookLock_P_C_SlideSpline:SetSlideSplineIcon()
  local IconObj = LoadObject("/Game/UI/Texture/Static/Atlas/Common/T_Com_IconTrack.T_Com_IconTrack")
  if not IconObj then
    return
  end
  local IconWidget = self.Icon_HookLock or self.Img_HookLock or self.Icon_Track or self.Img_Track or self.Image_Icon
  if not IsValid(IconWidget) then
    return
  end
  if type(IconWidget.SetBrushFromTexture) == "function" then
    IconWidget:SetBrushFromTexture(IconObj)
  elseif "function" == type(IconWidget.SetBrushResourceObject) then
    IconWidget:SetBrushResourceObject(IconObj)
  end
end

function WBP_Battle_HookLock_P_C_SlideSpline:OnOwnerUpdated(SlideSpline, HookComp, PromptWorldLoc)
  local ShouldPlayHintSound = self.SlideSpline ~= SlideSpline
  self.SlideSpline = SlideSpline
  self.Hook = SlideSpline
  self.HookComp = HookComp
  self.PromptWorldLoc = PromptWorldLoc
  if ShouldPlayHintSound and IsValid(self.Player) and self.Player:IsMainPlayer() then
    AudioManager(self):PlayNormalSound(self.Player, nil, HOOK_HINT_SOUND_PATH, HOOK_HINT_SOUND_KEY, false)
  end
end

function WBP_Battle_HookLock_P_C_SlideSpline:PressedSelectAction()
  if not self.bInScreen then
    return
  end
  if IsValid(self.Player) and type(self.Player.TryEnterSlideMech) == "function" then
    self.Player:TryEnterSlideMech()
  end
end

function WBP_Battle_HookLock_P_C_SlideSpline:RealTick(MyGeometry, InDeltaTime)
  if IsValid(self.SlideSpline) and self.PromptWorldLoc then
    self:RefreshWorldLoc(self.PromptWorldLoc)
  end
end

local WBP_Battle_HookLock_P_C = Class("BluePrints.UI.BP_UIStateBridge_C")

function WBP_Battle_HookLock_P_C:SetupTypeModule()
  self.DefaultType = nil
  self.TypeModulePaths = {Hook = WBP_Battle_HookLock_P_C_Hook, SlideSpline = WBP_Battle_HookLock_P_C_SlideSpline}
end

return WBP_Battle_HookLock_P_C
