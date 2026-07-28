require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
local GuildBossUtils = require("BluePrints.UI.WBP.Guild.Common.GuildBossUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
  self.ListState = true
end

function M:Construct()
  self:InitUIInfo()
  self:InitDeviceInfo()
  EventManager:AddEvent(EventID.OnGuildBossStatsUpdate, self, self.OnGuildBossStatsUpdate)
end

function M:InitUIInfo()
  self.Text_Title:SetText(GText("UI_GuildBoss_ExtremeThreat"))
  self.Text_Btn:SetText(GText("UI_GuildBoss_DrillProgress"))
  self.Text_Tip:SetText(GText("UI_GuildBoss_StatsAfterSettlement"))
  self:InitTrialProgressItemList()
  self:InitKeyInfo()
  self:PlayAnimation(self.In)
  self:OpenList(true)
end

function M:InitDeviceInfo()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(self.GameInputModeSubsystem) then
    self.NavigateWidget = self.GameInputModeSubsystem and self.GameInputModeSubsystem:GetNavigateWidget()
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
    local CurInputType = self.GameInputModeSubsystem:GetCurrentInputType()
    self:RefreshOpInfoByInputDevice(CurInputType, self.GameInputModeSubsystem:GetCurrentGamepadName())
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputType, CurGamepadName)
  self.CurInputDeviceType = CurInputType
  self.CurGamepadName = CurGamepadName
  if self.CurInputDeviceType == ECommonInputType.MouseAndKeyboard then
    self.WS_Controller:SetActiveWidgetIndex(0)
    self.Btn_Fold:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif self.CurInputDeviceType == ECommonInputType.Gamepad then
    self.WS_Controller:SetActiveWidgetIndex(1)
    self.Btn_Fold:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif self.CurInputDeviceType == ECommonInputType.Touch then
    self.WS_Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Fold_Extra.OnClicked:Clear()
    self.Btn_Fold_Extra.OnClicked:Add(self, self.OpenList)
    self.Btn_Fold:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:InitKeyInfo()
  self.Key_Fold:CreateCommonKey({
    KeyInfoList = {
      {Type = "Text", Text = "K"}
    }
  })
  self.Controller_Fold:CreateGamepadKey(UIConst.GamePadImgKey.DPadRight)
end

function M:ResolveGuildBossData(Callback)
  local CandidateTargetGuildId = GuildModel:GetCurrentGuildRegionTargetGuildId()
  local DisplayGuildId = GuildModel:ResolveGuildBossDisplayGuildId(CandidateTargetGuildId)
  GuildModel:GetGuildBossDataByGuildId(DisplayGuildId, function(GuildBossData)
    if not IsValid(self) then
      return
    end
    self.GuildBossData = GuildBossData
    if Callback then
      Callback(GuildBossData)
    end
  end)
end

function M:InitTrialProgressItemList()
  self:ResolveGuildBossData(function(GuildBossData)
    if not IsValid(self) or not GuildBossData then
      return
    end
    local TrialList = GuildBossData:GetTrialList()
    self.SlotTrialIds = {}
    for i = 1, 3 do
      self.SlotTrialIds[i] = TrialList[i]
      local Content = self:BuildTrialProgressContent(TrialList[i], i)
      self["TrialProgress_" .. i]:InitContent(Content)
    end
  end)
end

function M:CacheTrialSlotMap()
  self.SlotTrialIds = {}
  local GuildBossData = self.GuildBossData or GuildModel:GetGuildBossData()
  if not GuildBossData then
    return
  end
  local TrialList = GuildBossData:GetTrialList()
  for i = 1, 3 do
    self.SlotTrialIds[i] = TrialList[i]
  end
end

function M:BuildTrialProgressContent(TrialId, Index)
  local GuildBossData = self.GuildBossData or GuildModel:GetGuildBossData()
  local Percent = 0
  local TestDes = ""
  local EffectText = ""
  if TrialId and GuildBossData then
    Percent = GuildBossUtils.CalcTrialProgressPercent(TrialId, GuildBossData:GetTrialProgressOfTrial(TrialId))
    if Percent >= 100 then
      Percent = 100
    else
      Percent = 0
    end
    local TrialCfg = DataMgr.GuildWarTest and DataMgr.GuildWarTest[TrialId]
    if TrialCfg then
      TestDes = GText("UI_GuildBoss_BrokenCondition") .. (GuildBossUtils.FormatGuildWarTestDesc(TrialCfg) or "")
      local BossId = GuildBossData:GetCurrentBossId()
      local BossCfg = DataMgr.GuildBossInfo and DataMgr.GuildBossInfo[BossId]
      local BuffId
      if BossCfg and BossCfg.GuildWarBuff then
        BuffId = BossCfg.GuildWarBuff[Index]
      end
      local BuffCfg = BuffId and DataMgr.GuildWarBuff and DataMgr.GuildWarBuff[BuffId]
      if BuffCfg then
        local BuffName = GText(BuffCfg.BuffName) or ""
        local BuffDes = GuildBossUtils.FormatGuildWarBuffDesc(BuffCfg)
        EffectText = BuffName .. BuffDes
      end
    end
  end
  return {
    Text_Effect = EffectText,
    Text_Condition = TestDes,
    IconPath = GuildBossUtils.GetTrialIconPath(Index),
    Percent = tostring(Percent)
  }
end

function M:OpenList(NotPlaySound)
  self.ListState = not self.ListState
  for i = 1, 3 do
    self["TrialProgress_" .. i]:ChangeItemState(self.ListState)
  end
  self:PlayAnimation(self.ListState and self.List_In or self.List_Out)
  if NotPlaySound then
    return
  end
  if self.ListState then
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_challenge_info_expand", nil, nil)
  else
    AudioManager(self):PlayUISound(self, "event:/ui/common/association_boss_challenge_info_shrink", nil, nil)
  end
end

function M:OnGuildBossStatsUpdate(Snapshot)
  if not Snapshot or not Snapshot.Trials then
    return
  end
  if not self.SlotTrialIds then
    self:CacheTrialSlotMap()
  end
  for i = 1, 3 do
    local TrialId = self.SlotTrialIds[i]
    local Item = self["TrialProgress_" .. i]
    if Item and TrialId then
      Item:UpdatePercent(self:CalcLiveTrialPercent(Snapshot.Trials[TrialId]))
    end
  end
end

function M:CalcLiveTrialPercent(LiveData)
  if not LiveData then
    return 0
  end
  if LiveData.Broken then
    return 100
  end
  local Val = (LiveData.BreakProgress or 0) * 100
  return math.floor(Val * 10 + 1.0E-9) / 10
end

function M:Destruct()
  EventManager:RemoveEvent(EventID.OnGuildBossStatsUpdate, self)
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
    self.GameInputModeSubsystem:SetNavigateWidgetOpacity(1)
  end
end

return M
