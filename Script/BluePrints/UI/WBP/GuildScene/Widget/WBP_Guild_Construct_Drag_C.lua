require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitOperation()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.ActorId = self.GuildManager:GetSelectedActorGuild()
end

function M:CopyActor()
  local ModifiedState = FGuildActorState()
  local Ret = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  local Operator = UE4.UGuildFunctionLibrary.CopyActor(ModifiedState)
  UE4.UGuildFunctionLibrary.CreateActorExec(self.GuildManager, Operator)
end

function M:InitButton()
  self.Btn_Copy:SetText(GText("复制"))
  self.Btn_Copy:BindEventOnClicked(self, self.CopyActor)
end

function M:GetActorLocation()
  local State = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  return State.Location
end

function M:UpdateCurrentRotation()
  local RotationYaw = self.Slider_Rotation.CurrentCount
  local ModifiedState = FGuildActorState()
  local Ret = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  ModifiedState.Rotation.Yaw = RotationYaw
  local ActorCreateState = TArray(FGuildActorState)
  ActorCreateState:Add(ModifiedState)
  local Operator = UE4.UGuildFunctionLibrary.ModifyOperator(ActorCreateState)
  UE4.UGuildFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:UpdateCurrentScale()
  local Scale = self.Slider_Scale.CurrentCount
  local ModifiedState = FGuildActorState()
  local Ret = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  ModifiedState.Scale = FVector(Scale, Scale, Scale)
  local ActorCreateState = TArray(FGuildActorState)
  ActorCreateState:Add(ModifiedState)
  local Operator = UE4.UGuildFunctionLibrary.ModifyOperator(ActorCreateState)
  UE4.UGuildFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:InitSlider()
  local ActorState = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  local Yaw = ActorState.Rotation.Yaw
  local ConfigData = {
    InitValue = Yaw,
    MinValue = 0,
    MaxValue = 345,
    EnableMiniBtn = true,
    EnableMaxBtn = true,
    ClickInterval = 15,
    MaxBtnCallback = self.UpdateCurrentRotation,
    MinusBtnCallback = self.UpdateCurrentRotation,
    AddBtnCallback = self.UpdateCurrentRotation,
    SliderChangeCallback = self.UpdateCurrentRotation,
    OwnerPanel = self,
    bForbidPressAccelerate = true
  }
  local Scale = ActorState.Scale.X
  local ScaleConfigData = {
    InitValue = Scale,
    MinValue = 1,
    MaxValue = 5,
    EnableMiniBtn = true,
    EnableMaxBtn = true,
    ClickInterval = 1,
    MaxBtnCallback = self.UpdateCurrentScale,
    MinusBtnCallback = self.UpdateCurrentScale,
    AddBtnCallback = self.UpdateCurrentScale,
    SliderChangeCallback = self.UpdateCurrentScale,
    OwnerPanel = self,
    bForbidPressAccelerate = true
  }
  self.Slider_Rotation:Init(ConfigData)
  self.Slider_Scale:Init(ScaleConfigData)
end

function M:Construct()
end

function M:InitParent(ParentTest)
  self.WBP_Guild_Move_Image:InitParent(ParentTest)
end

function M:RefreshData()
  self:InitOperation()
  self:InitButton()
  self:InitSlider()
end

return M
