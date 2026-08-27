require("UnLua")
local GMVariable = require("BluePrints.UI.GMInterface.GMVariable")
local MonsterUtils = require("Utils.MonsterUtils")
local CommonUtils = require("Utils.CommonUtils")
local EMCache = require("EMCache.EMCache")
local BloodBarUtils = require("BluePrints.UI.BloodBar.BloodBarUtils")
local Const = require("Const")
local WBP_MainBar_C = Class("BluePrints.UI.BP_UIState_C")
UE4.UMainBar.SetIsShowMonsterName(EMCache:Get("ShowMonsterName") or false)
UE4.UMainBar.SetIsForbidenShowBloodUI(false)

function WBP_MainBar_C:Initialize(Initializer)
  self.Super.Initialize(self)
end

function WBP_MainBar_C:InitConfig_Lua(IsMainPlayer, ActorOwner)
  rawset(self, "Owner", ActorOwner)
  self.LastChaosLayerByBuffId = {}
  self.LastDisplayChaosBuffId = nil
  self.LastChaosPlayerAttribute = nil
  self.IsDestroied = nil
  if IsMainPlayer then
    self:RemoveAllDispatcher()
    self:AddDispatcher(EventID.OnCharGradeLevelUp, self, self.OnCharGradeLevelUp)
    self:AddDispatcher(EventID.CharRecover, self, self.CharRecovery)
    self:AddDispatcher(EventID.RefreshMainPlayerBlood, self, self.Reinitialize)
    self:AddDispatcher(EventID.OnCharLevelUpInBattle, self, self.OnUpdateCharLevelAndExp)
    self:AddDispatcher(EventID.OnUpdateCharExp, self, self.OnUpdateCharLevelAndExp)
    self:AddDispatcher(EventID.OnShowMainPlayerHealEvent, self, self.OnShowMainPlayerHealEvent)
    self:AddDispatcher(EventID.ChangeRole, self, self.CheckChangeRole)
    self:AddTimer(1.0, self.CheckMaxHpAndShieldChange, true, 0, "CheckMaxHpAndShieldChange")
    self:AddTimer(1.0, function()
      self:AddDispatcher(EventID.OnMainCharacterInitReady, self, self.CharRecovery)
    end, false, 0, "DelayDispatcherMainCharacterInitReady")
    self.IsPlayingReturning = false
  else
    self:RegisterEventsNormal()
  end
  self:UpdateCharBuffUI()
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  self.SceneMgrComponent = GameInstance:GetSceneManager()
  self:SetName()
end

function WBP_MainBar_C:ReInit_Lua(ActorOwner)
  rawset(self, "Owner", ActorOwner)
  self.LastChaosLayerByBuffId = {}
  self.LastDisplayChaosBuffId = nil
  self.LastChaosPlayerAttribute = nil
  if self.ChaosBuffWidget then
    self.ChaosBuffWidget:ReInit()
  end
  self:UpdateCharBuffUI()
  self:RegisterEventsNormal()
end

function WBP_MainBar_C:Construct()
  WBP_MainBar_C.Super.Construct(self)
  if self.Icon_Agree then
    self.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:AddDispatcher(EventID.OnRepOwnerEidPhantomState, self, self._SyncPhantomName)
  self:AddDispatcher(EventID.OnRepPlayerName, self, self._SyncPhantomName)
  self:AddDispatcher(EventID.CloseLoading, self, self._SyncPhantomName)
end

function WBP_MainBar_C:SetInTeam()
  self.Group_FrontSpace:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Icon_Agree:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Lv:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_BG:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function WBP_MainBar_C:WhileInvisibleMonsterBeAttack(Eid, NowTimeSeconds)
  if IsValid(self.SceneMgrComponent) then
    self.SceneMgrComponent.SpecialMonsterInfo[Eid] = {NowTimeSeconds}
  end
end

function WBP_MainBar_C:RegisterEventsNormal()
  if (self.Owner:IsMonster() or self.Owner:IsCombatItemBase() or self.Owner:IsNPC() or self.Owner:IsMechanismSummon()) and self.bIsDangerEnemy then
    self:AddDispatcher(EventID.MainPlayerLevelUp, self, self.OnMainPlayerLevelUp)
  end
  if self.Owner:IsMonster() then
    self:AddDispatcher(EventID.ChangeRole, self, self.OnLocalPlayerRoleChanged)
  end
end

function WBP_MainBar_C:OnLocalPlayerRoleChanged()
  self:UpdateCharBuffUI()
end

function WBP_MainBar_C:OnMainPlayerLevelUp(MainPlayerNowLevel)
  if not IsValid(self.Owner) then
    return
  end
  if self.bIsDangerEnemy then
    local NowLevel = self.Owner:GetAttr("Level")
    if NowLevel - MainPlayerNowLevel < 10 then
      self:SetLevelText(NowLevel)
      self:RemoveDispatcher(EventID.MainPlayerLevelUp)
    end
  end
end

function WBP_MainBar_C:CheckIsReduceDelay(DamageEvent)
  local NowTime = UE4.UGameplayStatics.GetRealTimeSeconds(self)
  if DamageEvent.SkillId then
    local SkillInfo = DataMgr.Skill[DamageEvent.SkillId]
    if SkillInfo and SkillInfo[1] then
      local SkillGradeInfo = SkillInfo[1][0]
      if SkillGradeInfo then
        local SkillType = SkillGradeInfo.SkillType
        if "Attack" == SkillType then
          self.LastAttackTime = NowTime
        end
      end
    end
  end
end

function WBP_MainBar_C:Reinitialize()
  self:InitValue(self.Owner)
  self:OnUpdateCharLevelAndExp()
  self.HpBar:ReInit()
  if self.ShieldBar then
    self.ShieldBar:ReInit()
  elseif self.MaxShield > 0 then
    self:CheckAndLoadShieldBar()
  end
  if self.MaxShield > 0 and self.ShieldBar then
    local CurOverShiledPercent = self.CurOverShield / self.MaxShield
    self.ShieldBar:SetOverShieldPercent(CurOverShiledPercent)
    self:CheckAndPlayOvershield()
    self:SetOverShieldNum_Player()
  end
  local CurBloodPercent = math.clamp(self.CurHp / self.MaxHp, 0, 1)
  local CurShieldPercent = 0 == self.MaxShield and 0 or math.clamp(self.CurShield / self.MaxShield, 0, 1)
  self.HpBar:SetBarPercent(CurBloodPercent)
  if self.ShieldBar then
    self.ShieldBar:SetBarPercent(CurShieldPercent)
    if self.MaxShield <= 0 then
      self.ShieldBar:SetVisibility(UE4.ESlateVisibility.Collapsed)
    else
      self.ShieldBar:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  end
  self:SetBloodNum_Player()
  self:SetShieldNum_Player()
  
  local function SetColor()
    self:CheckAndPlayLowHealth()
    self.HpBar:SetBarColor(false)
  end
  
  SetColor()
  self:InitLastingEffect()
end

function WBP_MainBar_C:CharRecovery(Eid)
  local GameInstance = self:GetGameInstance()
  local UIManager = GameInstance:GetGameUIManager()
  if UIManager and UIManager:GetArmoryUIObj() then
    return
  end
  self:Reinitialize()
  self:PlayAnimation(self.InAnimation)
end

function WBP_MainBar_C:OnUpdateCharLevelAndExp()
  if not IsValid(self.Owner) then
    return
  end
  local NowLevel = self.Owner:GetAttr("Level")
  if not NowLevel or NowLevel <= 0 then
    return
  end
  self.Lv:SetText(GText("UI_LEVEL_NAME"))
  self.Num_Lv_elite:SetText(NowLevel)
  if self.OldLevel and NowLevel > self.OldLevel and self.Owner:IsMainPlayer() then
    EventManager:FireEvent(EventID.MainPlayerLevelUp, NowLevel)
  end
  self.OldLevel = NowLevel
end

function WBP_MainBar_C:OnMainCharacterInitReady()
  if not IsValid(self.Owner) then
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    self.Owner = Player
  end
  self:RealInit(self.Owner, self.OwnerType or "", self.StyleNodeName or "")
  self:AddTimer(1.0, self.CheckMaxHpAndShieldChange, true, 0, "CheckMaxHpAndShieldChange")
end

function WBP_MainBar_C:CheckMaxHpAndShieldChange()
  if self:IsVisible() == false or not IsValid(self.Owner) then
    return
  end
  local NowMaxHp = self.Owner:GetAttr("MaxHp")
  local NowMaxShield = self.Owner:GetAttr("MaxES")
  if self.MaxHp ~= NowMaxHp or self.MaxShield ~= NowMaxShield then
    self:Reinitialize()
  end
end

function WBP_MainBar_C:OnShowMainPlayerHealEvent(HealEvent)
  if self.IsCharInHotUI then
    self:UpdateCharHotUIState(true)
    return
  end
  local IsHaveHot = false
  if HealEvent.DamageTag then
    for key, value in pairs(HealEvent.DamageTag) do
      if "Hot" == value then
        IsHaveHot = true
      end
    end
  end
  if not IsHaveHot then
    EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn, self.PlayerBloodReturn.Player_BloodReturn)
  end
end

function WBP_MainBar_C:UpdateCharHotUIState(HotUI)
  self.IsCharInHotUI = HotUI
  if HotUI then
    self:StartReturing()
  elseif self.IsPlayingReturning then
    self:StopReturning()
  end
end

function WBP_MainBar_C:StartReturing()
  if not self.PlayerBloodReturn or self.IsPlayingReturning then
    return
  end
  EMUIAnimationSubsystem:EMStopAnimation(self.PlayerBloodReturn, self.PlayerBloodReturn.Player_BloodReturnEnd)
  EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn, self.PlayerBloodReturn.Player_BloodReturning)
  self.IsPlayingReturning = true
end

function WBP_MainBar_C:StopReturning()
  if not self.PlayerBloodReturn or not self.IsPlayingReturning then
    return
  end
  EMUIAnimationSubsystem:EMStopAnimation(self.PlayerBloodReturn, self.PlayerBloodReturn.Player_BloodReturning)
  EMUIAnimationSubsystem:EMPlayAnimation(self.PlayerBloodReturn, self.PlayerBloodReturn.Player_BloodReturnEnd)
  self.IsPlayingReturning = false
end

function WBP_MainBar_C:CheckChangeRole()
  if not self.Owner:IsPlayer() then
    return
  end
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return
  end
  local NewRoleId = Player.CurrentRoleId
  if self.RoleId ~= NewRoleId and 0 ~= NewRoleId then
    self.Owner = Player
    self.OwnerEid = Player.Eid
    self.RoleId = Player.CurrentRoleId
    self:Reinitialize()
    self:PlayAnimation(self.InAnimation)
  end
end

function WBP_MainBar_C:CheckIsEnemyToPlayer(Owner)
  if Owner then
    rawset(self, "Owner", Owner)
  end
  local OwnerCamp = self.Owner:GetCamp()
  if OwnerCamp == ECampName.None or not OwnerCamp then
    if self.Owner:IsPlayer() then
      return false
    end
    if DataMgr[self.Owner.UnitType] then
      OwnerCamp = DataMgr[self.Owner.UnitType][self.Owner.UnitId].Camp
    else
      return true
    end
  end
  return DataMgr.CampRule[OwnerCamp].Player == Const.Enemy
end

function WBP_MainBar_C:_SyncPhantomName()
  if self.bPendingPhantomSetName then
    DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName _SyncPhantomName")
    self:SetName()
    self.bPendingPhantomSetName = false
  end
end

function WBP_MainBar_C:SetPhantomName()
  local NameKey = DataMgr.BattleChar[self.RoleId].CharName
  DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName NameKey ", NameKey)
  DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName ContentEN ", DataMgr.TextMap_ContentEN[NameKey].ContentEN)
  DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName IsStandAlone(self) ", IsStandAlone(self))
  local ShowName = ""
  local bHasCorrectShowName = false
  if string.find(DataMgr.TextMap_ContentEN[NameKey].ContentEN, "{nickname") and not IsStandAlone(self) then
    local PhantomState = GameState(self):GetPhantomState(self.Owner.Eid)
    if not PhantomState then
      local PhantomOwner = self.Owner.PhantomOwner
      if PhantomOwner then
        local OwnerState = GameState(self):GetPlayerState(PhantomOwner.Eid)
        if OwnerState and OwnerState.PlayerName then
          ShowName = OwnerState.PlayerName
        end
      end
      DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName not PhantomState")
      self.bPendingPhantomSetName = true
    else
      local PhantomOwnerEid = PhantomState.OwnerEid
      if PhantomOwnerEid then
        local OwnerState = GameState(self):GetPlayerState(PhantomOwnerEid)
        if OwnerState and OwnerState.PlayerName then
          ShowName = OwnerState.PlayerName
          bHasCorrectShowName = true
        else
          ShowName = GText(NameKey)
          self.bPendingPhantomSetName = true
          DebugPrint(ErrorTag, "WBP_MainBar_C:SetPhantomName  主角魅影找不到它的OwnerPlayerName")
        end
      else
        DebugPrint(ErrorTag, "WBP_MainBar_C:SetPhantomName  主角魅影找不到它的Owner， 无法赋予名称")
        ShowName = "<ERROR>"
      end
    end
  else
    ShowName = GText(NameKey)
    bHasCorrectShowName = true
  end
  self.MonsterName:SetText(ShowName)
  self.MonsterName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName GetText ", self.MonsterName:GetText())
  DebugPrint(DebugTag, "WBP_MainBar_C:SetPhantomName bHasCorrectShowName ", bHasCorrectShowName)
  if not bHasCorrectShowName then
    self:AddTimer(0.2, self.SetName, false, 0, "WBP_MainBar_C:SetPhantomName", true)
  end
end

function WBP_MainBar_C:SetName()
  DebugPrint("WBP_MainBar_C:SetName 1", self.MonsterName, self.bIsShowName, self.Owner:GetName())
  if not self.MonsterName then
    return
  end
  self.MonsterName:SetVisibility(ESlateVisibility.Collapsed)
  if not self.bIsShowName then
    return
  end
  local Data = self.Owner.Data
  if not Data or not Data.UnitName then
    self.bIsShowName = false
    DebugPrint("WBP_MainBar_C:SetName return because not Data or Data.UnitName", Data)
    return
  end
  local Name
  if self.Owner:IsPhantom() then
    self:SetPhantomName()
    return
  else
    Name = Data.UnitName
  end
  if not Name then
    DebugPrint("WBP_MainBar_C:SetName return because not Name", self.Owner:GetName())
    self.bIsShowName = false
    return
  end
  DebugPrint("WBP_MainBar_C:SetName", Name, GText(Name))
  self.MonsterName:SetText(GText(Name))
  self.MonsterName:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
end

function WBP_MainBar_C:GetLastingEffectColorMap()
  return self.LastingEffectColorMap
end

function WBP_MainBar_C:GetLocalPlayerAttribute()
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return nil
  end
  local RoleId = Player.CurrentRoleId
  if not RoleId or RoleId <= 0 then
    return nil
  end
  local BattleCharConfig = DataMgr.BattleChar[RoleId]
  if not BattleCharConfig then
    return nil
  end
  return BattleCharConfig.Attribute
end

function WBP_MainBar_C:FindLocalPlayerChaosBuff(PlayerAttribute, ChaosBuffs)
  if not PlayerAttribute or "Default" == PlayerAttribute then
    return nil
  end
  for Index = 1, ChaosBuffs:Num() do
    local BuffData = ChaosBuffs:GetRef(Index)
    local BuffConfig = DataMgr.Buff[BuffData.BuffId]
    local BuffElement = BuffConfig and BuffConfig.BPVars and BuffConfig.BPVars.Element
    if BuffElement == PlayerAttribute then
      return BuffData
    end
  end
  return nil
end

function WBP_MainBar_C:EnsureChaosBuffWidget()
  if self.ChaosBuffWidget then
    return
  end
  local BuffWidget = self:CreateWidgetNew("ChaosBuff")
  if BuffWidget then
    BuffWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.ChaosAnchor:AddChildToOverlay(BuffWidget)
    self.ChaosBuffWidget = BuffWidget
  end
end

function WBP_MainBar_C:RefreshChaosBuffUI_Lua(ChaosBuffs)
  if not self.ChaosAnchor then
    self:SetForceShowNameByChaosBuff(false)
    return
  end
  self:EnsureChaosBuffWidget()
  local LastLayers = self.LastChaosLayerByBuffId or {}
  local CurrentLayers = {}
  local CurrentBuffsById = {}
  local HasVisibleBuff = false
  for Index = 1, ChaosBuffs:Num() do
    local BuffData = ChaosBuffs:GetRef(Index)
    CurrentBuffsById[BuffData.BuffId] = BuffData
    CurrentLayers[BuffData.BuffId] = BuffData.Layer or 0
  end
  local PlayerAttribute = self:GetLocalPlayerAttribute()
  local LastPlayerAttribute = self.LastChaosPlayerAttribute
  local IsPlayerAttributeChanged = nil ~= LastPlayerAttribute and LastPlayerAttribute ~= PlayerAttribute
  self.LastChaosPlayerAttribute = PlayerAttribute
  local BuffWidget = self.ChaosBuffWidget
  local DisplayBuff = self:FindLocalPlayerChaosBuff(PlayerAttribute, ChaosBuffs)
  local DisplayBuffId = DisplayBuff and DisplayBuff.BuffId
  local LastDisplayBuffId = self.LastDisplayChaosBuffId
  local LastLayer = DisplayBuffId == LastDisplayBuffId and LastLayers[DisplayBuffId] or nil
  self.LastDisplayChaosBuffId = DisplayBuffId
  if BuffWidget then
    if DisplayBuff then
      local CurrentLayer = DisplayBuff.Layer or 0
      local IsLayerReduced = nil ~= LastLayer and LastLayer > CurrentLayer
      local IsLayerIncreased = nil ~= LastLayer and LastLayer < CurrentLayer
      local IsNewBuff = nil ~= DisplayBuffId and nil == LastLayers[DisplayBuffId]
      HasVisibleBuff = true
      BuffWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      BuffWidget:RefreshChaosBuff(DisplayBuff, IsNewBuff, IsLayerReduced, IsLayerIncreased)
      self:SetForceShowNameByChaosBuff(true)
    elseif not IsPlayerAttributeChanged and LastDisplayBuffId and not CurrentBuffsById[LastDisplayBuffId] then
      HasVisibleBuff = true
      BuffWidget:OnChaosBuffRemoved(function()
        if BuffWidget:GetVisibility() == UIConst.VisibilityOp.Collapsed then
          self.ChaosAnchor:SetVisibility(UIConst.VisibilityOp.Collapsed)
        end
        self:SetForceShowNameByChaosBuff(false)
      end)
    else
      BuffWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self:SetForceShowNameByChaosBuff(false)
    end
  end
  self.LastChaosLayerByBuffId = CurrentLayers
  self.ChaosAnchor:SetVisibility(HasVisibleBuff and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function WBP_MainBar_C:Destruct()
  WBP_MainBar_C.Super.Destruct(self)
  self.IsDestroied = true
  self:RemoveDispatcher(EventID.OnRepOwnerEidPhantomState)
  self:RemoveDispatcher(EventID.OnRepPlayerName)
  self:RemoveDispatcher(EventID.CloseLoading)
end

return WBP_MainBar_C
