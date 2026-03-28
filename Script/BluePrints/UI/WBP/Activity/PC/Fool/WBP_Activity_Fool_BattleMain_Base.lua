require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:OnLoaded(...)
  self.TransformID = (...)
  self:InitEscButton()
  self:InitCameraButton()
  self:InitTransformButtons()
end

function M:ReceiveEnterState(StackAction)
  M.Super.ReceiveEnterState(self, StackAction)
  if self.CloseByChild then
    self.CloseByChild = false
    self:BlockAllUIInput(true)
    self:AddTimer(0.1, function()
      self:BlockAllUIInput(false)
      self:Close()
    end)
  end
end

function M:Construct()
  self:PlayAnimation(self.In)
  self:BindToAnimationFinished(self.Out, {
    self,
    self.OnOutAnimationFinished
  })
  self:AddDispatcher(EventID.OnInitScreenshotParams, self, self.OnInitScreenshotParams)
  self:AddDispatcher(EventID.OnTeamRecoveryStateChange, self, self.CloseOnPlayerDead)
end

function M:Destruct()
  self:UnbindAllFromAnimationFinished(self.Out)
  self.Btn_Close.OnClicked:Clear()
end

function M:CloseOnPlayerDead(Eid, Type, PrevType)
  local Controller = self:GetOwningPlayer()
  local Player = Controller:K2_GetPawn()
  if Player and Eid == Player:GetEid() and Type == UE4.ETeamRecoveryState.Dying then
    self:Close()
  end
end

function M:InitEscButton()
  self.Btn_Close.OnClicked:Add(self, self.CloseSelf)
end

function M:InitCameraButton()
  self.Pos_Entry:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Btn_Camera:PlayAnimation(self.Btn_Camera.Normal)
  local CameraData = DataMgr.MainUI[15]
  if not CameraData then
    return
  end
  local Texture = LoadObject(CameraData.Icon)
  self.Btn_Camera.Image_Top:SetBrushFromTexture(Texture)
  self.Btn_Camera.Btn_top.OnClicked:Clear()
  self.Btn_Camera.Btn_top.OnClicked:Add(self, self.OpenCamera)
  self.Btn_Camera.Common_Key_Hud_PC:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_Camera.Name:SetText(GText(CameraData.Name))
end

function M:OpenCamera()
  UIManager(self):LoadUINew("PhotoCameraMain")
end

function M:OnInitScreenshotParams(Params)
  Params.IsAprilFoolsDayActivity = true
  Params.TargetActors = {
    UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  }
  Params.IsLargeRange = true
  Params.DetectTargetMethod = 3
  Params.AFDTransformID = self.TransformID
end

function M:Randomransform()
  self:CloseSelf()
  self.LoadUIName = "AprilFoolDayRandomTrans"
end

function M:SwitchTransform()
  self:CloseSelf()
  self.LoadUIName = "AprilFoolDayTransList"
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.In) then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  self:PlayAnimation(self.Out)
end

function M:OnOutAnimationFinished()
  self:Close()
end

function M:Close()
  if rawget(self, "bClosed") then
    return
  end
  if UIManager(self):GetUIObj("PhotoCameraMain") then
    return
  end
  rawset(self, "bClosed", true)
  M.Super.Close(self)
  if self.LoadUIName then
    UIManager():LoadUINew(self.LoadUIName, self.TransformID)
    self.LoadUIName = nil
  else
    local PlayerCharacter = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local Avatar = GWorld:GetAvatar()
    if PlayerCharacter and IsValid(PlayerCharacter) and Avatar then
      Avatar:RegionOnlineTransformAFDay(-1)
      PlayerCharacter:CancelAFDTransform()
    end
  end
end

function M:InitTransformButtons()
end

return M
