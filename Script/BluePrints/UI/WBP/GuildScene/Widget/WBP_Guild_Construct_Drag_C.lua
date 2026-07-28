require("UnLua")
require("DataMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:InitOperation()
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  self.GuildManager = GameMode:GetGuildConstructManager()
  self.ActorId = self.GuildManager:GetSelectedActorGuild()
end

function M:CopyActor()
  local ModifiedState = FGuildConstructActorState()
  local Ret = self.GuildManager:GetActorState(self.ActorId, ModifiedState)
  if not Ret then
    ScreenPrint("请先选中后复制")
    return
  end
  local Operator = UE4.UGuildConstructFunctionLibrary.CopyActor(self.GuildManager, ModifiedState)
  UE4.UGuildConstructFunctionLibrary.CreateActorExec(self.GuildManager, Operator)
end

function M:InitButton()
  self.Btn_Copy:SetText(GText("复制"))
  self.Btn_Copy:BindEventOnClicked(self, self.CopyActor)
end

function M:GetActorLocation()
  local State = self.GuildManager:GetActorState(self.ActorId)
  return State.LocalLocation
end

function M:UpdateCurrentRotation()
  local RotationYaw = self.Slider_Rotation.CurrentCount
  local ModifiedState, Ret = self.GuildManager:GetActorState(self.ActorId)
  ModifiedState.LocalRotation.Yaw = RotationYaw
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperator(self.GuildManager, ModifiedState)
  UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:UpdateCurrentScale()
  local Scale = self.Slider_Scale.CurrentCount / 100.0
  local ModifiedState, Ret = self.GuildManager:GetActorState(self.ActorId)
  ModifiedState.LocalScale = FVector(Scale, Scale, Scale)
  local Operator = UE4.UGuildConstructFunctionLibrary.ModifyOperator(self.GuildManager, ModifiedState)
  UE4.UGuildConstructFunctionLibrary.ModifyOperatorExec(self.GuildManager, Operator)
end

function M:LeftRotate()
  self.Slider_Rotation:OnClickToMinus()
end

function M:RightRotate()
  self.Slider_Rotation:OnClickToAdd()
end

function M:SetSliderRotation()
  self.Slider_Rotation:SetValue()
end

function M:InitSlider()
  local ActorState, Ret = self.GuildManager:GetActorState(self.ActorId)
  local Yaw = ActorState.LocalRotation.Yaw
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
  self.Slider_Rotation:Init(ConfigData)
  local ScaleData = DataMgr.GuildItem[ActorState.UnitId].ScaleConfig
  local Length = #ScaleData
  if Length < 3 then
    self.Slider_Scale:SetVisibility(UE4.ESlateVisibility.Hidden)
    return
  end
  self.Slider_Scale:SetVisibility(UE4.ESlateVisibility.Visible)
  local Scale = ActorState.Scale.X
  local ScaleConfigData = {
    InitValue = Scale * 100,
    MinValue = ScaleData[1] * 100,
    MaxValue = ScaleData[2] * 100,
    EnableMiniBtn = true,
    EnableMaxBtn = true,
    ClickInterval = ScaleData[3] * 100,
    MaxBtnCallback = self.UpdateCurrentScale,
    MinusBtnCallback = self.UpdateCurrentScale,
    AddBtnCallback = self.UpdateCurrentScale,
    SliderChangeCallback = self.UpdateCurrentScale,
    OwnerPanel = self,
    bForbidPressAccelerate = true
  }
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
