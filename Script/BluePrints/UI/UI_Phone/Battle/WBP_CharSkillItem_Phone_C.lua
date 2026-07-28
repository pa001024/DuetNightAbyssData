require("UnLua")
local SkillUtils = require("Utils.SkillUtils")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Initialize(Initializer)
  self.CurButtonState = {}
  self.AnimationList = {}
  self.IsEnoughSpCanUseSkill = {}
  self.SkillInfo = {}
  self.CurButtonState = "Normal"
end

function M:Destruct()
  self:TryClearFoldSkillInputPressed()
  if EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.UnLock) then
    self.CurButtonState = "Normal"
    EMUIAnimationSubsystem:EMStopAnimation(self, self.AnimationList.UnLock)
  end
  self.Super.Destruct(self)
end

function M:Construct()
  self.Super.Construct(self)
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
  self.EnergyNumMat = self.Energy_Num:GetDynamicFontMaterial()
end

function M:SetSkillIndex(Index, SkillType, SkillName, SkillAction, Parent, Panel)
  self.Index = Index
  self.SkillType = SkillType
  self.SkillName = SkillName
  self.SkillAction = SkillAction
  self.Parent = Parent
  self.OwnerPanel = Panel
  self:InitVariable()
end

function M:InitVariable()
  self.SkillId = self.OwnerPlayer:GetSkillByType(self.SkillType)
  self.Skill = self.OwnerPlayer:GetSkill(self.SkillId)
  self:RefreshButtonStyle()
  self.AnimationList = {
    Normal = self.Skill_Normal,
    CD = self.Skill_CD,
    MP_Deficiency = self.Skill_MP_Deficiency,
    Click = self.Skill_Click,
    Disable = self.Skill_Disable,
    Sustain_Loop = self.Skill_Sustain_Loop,
    CD_Complete = self.Skill_CD_Complete,
    Lock_In = self.Skill_Lock_In,
    UnLock = self.Skill_UnLock,
    Sustain_CD = self.Skill_Sustain_CD,
    Ban = self.Skill_Ban,
    Enable = self.Skill_Enable
  }
  self.Button_Area.OnPressed:Add(self, self.OnPressedSkill)
  self.Button_Area.OnReleased:Add(self, self.OnReleasedSkill)
  self.OwnerPlayer = UGameplayStatics.GetPlayerCharacter(self, 0)
end

function M:OnPressedSkill()
  self:TryMarkFoldSkillInputPressed()
  self.OwnerPanel:TryToPlayTargetCommand(self.SkillAction, true)
  self:OnPressed_Presentation(self.SkillName)
end

function M:OnReleasedSkill()
  self.OwnerPanel:TryToStopTargetCommand(self.SkillAction, true)
  self:TryClearFoldSkillInputPressed()
end

function M:CanCountAsFoldSkillInput()
  return self.CurButtonState ~= "Ban" and self.CurButtonState ~= "Empty" and self.CurButtonState ~= "InCDTime" and self.CurButtonState ~= "InCDTimeSustain" and self.CurButtonState ~= "MP_Deficiency"
end

function M:TryMarkFoldSkillInputPressed()
  if self.bFoldSkillInputPressed then
    return
  end
  if not self:CanCountAsFoldSkillInput() then
    return
  end
  self.bFoldSkillInputPressed = true
  if self.OwnerPanel and self.OwnerPanel.SetFoldSkillInputPressed then
    self.OwnerPanel:SetFoldSkillInputPressed(self.SkillAction, true)
  end
end

function M:TryClearFoldSkillInputPressed()
  if not self.bFoldSkillInputPressed then
    return
  end
  self.bFoldSkillInputPressed = false
  if self.OwnerPanel and self.OwnerPanel.SetFoldSkillInputPressed then
    self.OwnerPanel:SetFoldSkillInputPressed(self.SkillAction, false)
  end
end

function M:OnPressed_Presentation(SkillName)
  if self.CurButtonState == "Ban" then
    UIManager(self):ShowUITip_BattleCommonTop(UIConst.Tip_CommonTop, GText("UI_SKILL_FORBIDDEN"))
    return
  end
  if self.CurButtonState == "Empty" then
    return
  end
  self:PlayResponsiveAnimation()
end

function M:PlayResponsiveAnimation()
  if self.SkillInfo.CanNotUseInAir then
    return
  end
  if self.CurButtonState == "Lock_In" then
    return
  end
  if not (self.CurButtonState ~= "InCDTime" and self.SkillInfo.HasEnoughSp) or self.CurButtonState == "InCDTimeSustain" then
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Disable) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Disable)
    end
  elseif not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Click) then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Click)
  end
end

function M:PlayWithTimerAnimation()
  if self.SkillInfo == nil then
    return
  end
  if self.SkillInfo.NeedCDCompleteAnim then
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.CD_Complete) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.CD_Complete)
    end
    self.SkillInfo.NeedCDCompleteAnim = false
  end
end

function M:PlayButtonStateAnimation()
  if self.CurButtonState == "InCDTime" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入CD态")
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.CD) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.CD)
    end
  elseif self.CurButtonState == "InCDTimeSustain" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入CD持续态")
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Sustain_CD) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Sustain_CD)
    end
  elseif self.CurButtonState == "SustainLoop" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入持续态")
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Sustain_Loop) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Sustain_Loop)
    end
    if self.IsUltimateEnabled and self.AnimationList.Enable and not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Enable) then
      DebugPrint("[Skill2 Animation] 播放Skill_Enable动画")
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Enable)
    end
  elseif self.CurButtonState == "Normal" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入常规态")
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Normal)
  elseif self.CurButtonState == "MP_Deficiency" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入蓝量不足")
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.MP_Deficiency)
  elseif self.CurButtonState == "Lock_In" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入锁定态")
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Lock_In) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Lock_In)
    end
  elseif self.CurButtonState == "Ban" then
    DebugPrint(self.SkillAction, "[Skill2 Animation] 进入Ban态")
    if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.Ban) then
      EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.Ban)
    end
  end
end

function M:HandleCurButtonState(SkillId, Skill, CurButtonState)
  if nil == Skill then
    return
  end
  local SkillCDTime, SkillCDPercent = Skill:GetSkillCdTimeAndPercent()
  local IsSkillSustain = self.OwnerPanel:ExecuteCheckIsSkillInUsing(Skill)
  local TextCD = self.Text_CD
  local ProgressBar = self.ProgressBar_CD
  if "Normal" == CurButtonState then
    if not self.SkillInfo.HasEnoughSp then
      self.CurButtonState = "MP_Deficiency"
    end
    if SkillCDTime > 0 and IsSkillSustain then
      self.CurButtonState = "InCDTimeSustain"
      TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    elseif SkillCDTime > 0 then
      self.CurButtonState = "InCDTime"
      TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    elseif IsSkillSustain then
      self.CurButtonState = "SustainLoop"
    end
  elseif "InCDTime" == CurButtonState then
    TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    ProgressBar:SetPercent(1 - SkillCDPercent)
    if IsSkillSustain then
      self.CurButtonState = "InCDTimeSustain"
    end
    if SkillCDTime <= 0 then
      if self.SkillInfo.HasEnoughSp then
        self.CurButtonState = "Normal"
        self.SkillInfo.NeedCDCompleteAnim = true
      else
        self.CurButtonState = "Normal"
      end
    end
  elseif "InCDTimeSustain" == CurButtonState then
    TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    ProgressBar:SetPercent(1 - SkillCDPercent)
    if SkillCDTime <= 0 and IsSkillSustain then
      self.CurButtonState = "SustainLoop"
      if self.SkillInfo.HasEnoughSp then
        self.SkillInfo.NeedCDCompleteAnim = true
      end
    elseif SkillCDTime > 0 and not IsSkillSustain then
      self.CurButtonState = "InCDTime"
    elseif not IsSkillSustain then
      if self.SkillInfo.HasEnoughSp then
        self.CurButtonState = "Normal"
        self.SkillInfo.NeedCDCompleteAnim = true
      else
        self.CurButtonState = "Normal"
      end
    end
  elseif "SustainLoop" == CurButtonState then
    if not IsSkillSustain and SkillCDTime <= 0 then
      if self.SkillInfo.HasEnoughSp then
        self.CurButtonState = "Normal"
        self.SkillInfo.NeedCDCompleteAnim = true
      else
        self.CurButtonState = "Normal"
      end
    elseif not IsSkillSustain and SkillCDTime > 0 then
      self.CurButtonState = "InCDTime"
      TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    elseif SkillCDTime > 0 then
      self.CurButtonState = "InCDTimeSustain"
      TextCD:SetText(self:GetPreciseDecimal(SkillCDTime, 1))
    end
  elseif "MP_Deficiency" == CurButtonState then
    if self.SkillInfo.HasEnoughSp then
      self.CurButtonState = "Normal"
      self.SkillInfo.NeedCDCompleteAnim = true
    end
  elseif "Lock_In" == CurButtonState and true == self.SkillInfo.NeedUnlock then
    self:ToNormalStateAfterAnim()
    self.SkillInfo.NeedUnlock = false
  end
  if CurButtonState ~= self.CurButtonState then
    self:PlayButtonStateAnimation()
  end
end

function M:UpdateSkillInTimer()
  if self.CurButtonState == "MasterBan" then
    return
  end
  local SkillId = self.SkillId
  local Skill = self.OwnerPlayer:GetSkill(SkillId)
  self:HandleCurButtonState(SkillId, Skill, self.CurButtonState)
  self:PlayWithTimerAnimation()
end

function M:ChangeIsInAir(IsInAir)
  self:BanSkillInAir(IsInAir)
end

function M:BanSkillInAir(IsBanInAir)
  if IsBanInAir then
    self:SetRenderOpacity(0.5)
    self.SkillInfo.CanNotUseInAir = true
  else
    self:SetRenderOpacity(1.0)
    self.SkillInfo.CanNotUseInAir = false
  end
end

function M:RefreshButtonStyle()
  self.SkillId = self.OwnerPlayer:GetSkillByType(self.SkillType)
  self.Skill = self.OwnerPlayer:GetSkill(self.SkillId)
  if not IsValid(self.Skill) then
    return
  end
  local SkillBaseConfig = self.Skill.Data
  self.EnableHoldMoveCamera = SkillBaseConfig.EnableHoldMoveCamera == true
  if self.Button_Area then
    self.Button_Area:SetVisibility(self.EnableHoldMoveCamera and ESlateVisibility.HitTestInvisible or ESlateVisibility.Visible)
  end
  self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
  self.Energy_Num:SetText(self.SkillInfo.CostSp)
  if self.OwnerPanel and self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
    self.SkillInfo.HasEnoughSp = false
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
  else
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
    self.SkillInfo.HasEnoughSp = true
  end
  if SkillBaseConfig.SkillBtnIcon ~= nil then
    self.LoadSkillIconId = nil
    local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Skill/T_" .. SkillBaseConfig.SkillBtnIcon, {
      self,
      M.OnSkillImgIconLoadFinishWithId
    })
    if Handle then
      self.LoadSkillIconId = Handle.ResourceID
    end
  end
end

function M:OnRefreshSkillSpCost(Owner)
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if not Owner or Owner ~= self.OwnerPlayer then
    return
  end
  DebugPrint("@zyh 刷新技能的显示蓝耗")
  if not IsValid(self.Skill) then
    return
  end
  self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
  self.Energy_Num:SetText(self.SkillInfo.CostSp)
  if self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
    self.SkillInfo.HasEnoughSp = false
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
  else
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
    self.SkillInfo.HasEnoughSp = true
  end
end

function M:OnUpdateBuffSpModify()
  if not IsValid(self.OwnerPlayer) then
    return
  end
  if not IsValid(self.Skill) then
    return
  end
  self.SkillInfo.CostSp = self:CalculateSkillCostSp(self.Skill)
  self.Energy_Num:SetText(self.SkillInfo.CostSp)
  if self.OwnerPanel.Skill.NowSp < self.SkillInfo.CostSp then
    self.SkillInfo.HasEnoughSp = false
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 0)
  else
    self.SkillInfo.HasEnoughSp = true
    self.EnergyNumMat:SetScalarParameterValue("EnergyState", 1)
  end
end

function M:OnSkillImgIconLoadFinishWithId(Object, ResourceID)
  if not (IsValid(self) and Object) or ResourceID ~= self.LoadSkillIconId then
    return
  end
  self.Icon_Skill:GetDynamicMaterial():SetTextureParameterValue("Mask", Object)
end

function M:CalculateSkillCostSp(Skill)
  if not Skill then
    return
  end
  local SkillBaseConfig = Skill.Data
  local CostSpNum
  if SkillBaseConfig.NotExecuteSpCost ~= nil then
    CostSpNum = SkillBaseConfig.NotExecuteSpCost
    CostSpNum = SkillUtils.CalcSkillDescValue(CostSpNum, Skill.SkillLevel)
  else
    local SkillNodeId = Skill.BeginNodeId
    local SkillNodeConfig = DataMgr.SkillNode[SkillNodeId] or {}
    CostSpNum = SkillNodeConfig.CostSp or 0
  end
  local ModifyValue = self.OwnerPlayer.BuffManager:GetBuffSpModify(Skill.SkillId)
  CostSpNum = math.max(math.ceil(CostSpNum + ModifyValue), 0)
  return self.OwnerPlayer:ApplySkillEfficiency(CostSpNum) or 0
end

function M:ButtonSkillDown(Index, StartPos)
  self:TryMarkFoldSkillInputPressed()
  self.OwnerPanel:TryToPlayTargetCommand(self.SkillAction, true)
  self:OnPressed_Presentation(self.SkillName)
  if self.Joystick and self.EnableHoldMoveCamera then
    self.Joystick:SetRenderOpacity(1.0)
    self.Joystick:SetRenderTranslation(FVector2D(0, 0))
  end
end

function M:ButtonSkillMove(TouchFingerCount, Index, LastPos, TotalDeltaDis, LastDeltaDis, TouchLocalPos, ScreenSpacePos)
  if not self.EnableHoldMoveCamera then
    return
  end
  local WorldDeltaTime = UE4.UGameplayStatics.GetWorldDeltaSeconds(self)
  self.OwnerPlayer:AddCharacterPitchInput(-2 * LastDeltaDis.Y * WorldDeltaTime)
  self.OwnerPlayer:AddCharacterYawInput(4.5 * LastDeltaDis.X * WorldDeltaTime)
  if self.Joystick then
    local Radius = 40
    local Dx, Dy = TotalDeltaDis.X, TotalDeltaDis.Y
    local Dist = math.sqrt(Dx * Dx + Dy * Dy)
    if Radius < Dist then
      local S = Radius / Dist
      Dx, Dy = Dx * S, Dy * S
    end
    self.Joystick:SetRenderTranslation(FVector2D(Dx, Dy))
  end
end

function M:ButtonSkillUp(Index, WidgetLocalPos, LastWidgetTouchPos, EndTouchPos, TotalDeltaDis, ScreenSpacePos)
  self.OwnerPanel:TryToStopTargetCommand(self.SkillAction, true)
  self:TryClearFoldSkillInputPressed()
  if self.Joystick then
    self.Joystick:SetRenderOpacity(0)
    self.Joystick:SetRenderTranslation(FVector2D(0, 0))
  end
end

function M:OnUltimateStateChanged(IsActive)
  if not self.AnimationList.Enable then
    return
  end
  if IsActive then
    self.IsUltimateEnabled = true
  elseif self.IsUltimateEnabled then
    self.IsUltimateEnabled = false
    self:PlayAnimationReverse(self.AnimationList.Enable)
  end
end

function M:ToNormalStateAfterAnim()
  self:BindToAnimationFinished(self.AnimationList.UnLock, function()
    self.CurButtonState = "Normal"
  end)
  if not EMUIAnimationSubsystem:EMAnimationIsPlaying(self, self.AnimationList.UnLock) then
    EMUIAnimationSubsystem:EMPlayAnimation(self, self.AnimationList.UnLock)
  end
end

return M
