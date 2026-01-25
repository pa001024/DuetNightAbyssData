require("UnLua")
local EffectResults = require("BluePrints.Combat.BattleLogic.EffectResults")
local CharacterDataStruct = require("BluePrints.Combat.Components.CharacterDataStruct")
local EMCache = require("EMCache.EMCache")
local BP_Battle_C = Class("BluePrints.Common.TimerMgr")
BP_Battle_C._components = {
  "BluePrints.Combat.BattleLogic.AttrLogic",
  "BluePrints.Combat.BattleLogic.BattleEventLogic",
  "BluePrints.Combat.BattleLogic.BattleGMLogic",
  "BluePrints.Combat.BattleLogic.BuffLogic",
  "BluePrints.Combat.BattleLogic.CampLogic",
  "BluePrints.Combat.BattleLogic.CharacterLogic",
  "BluePrints.Combat.BattleLogic.CreatureLogic",
  "BluePrints.Combat.BattleLogic.DamageLogic",
  "BluePrints.Combat.BattleLogic.PositionLogic",
  "BluePrints.Combat.BattleLogic.SeekEnemyLogic",
  "BluePrints.Combat.BattleLogic.SkillRawEffects",
  "BluePrints.Combat.BattleLogic.TargetFilterLogic",
  "BluePrints.Combat.BattleLogic.DeadLogic",
  "BluePrints.Combat.BattleLogic.ConditionLogic",
  "BluePrints.Combat.BattleLogic.ToughnessLogic",
  "BluePrints.Combat.BattleLogic.BattlePlayMgr",
  "BluePrints.Combat.BattleLogic.LaserLogic",
  "BluePrints.Combat.Components.SkillCreaturePool"
}

function BP_Battle_C:CanExecute()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  if not GameState:CheckGameModeStateNotEnd() then
    return false
  end
  if IsStandAlone(self) then
    return true
  end
  if IsDedicatedServer(self) then
    return true
  end
  if self.ClientExec then
    return true
  end
  return false
end

function BP_Battle_C:ReceiveBeginPlay()
  print(_G.LogTag, "BP_Battle_C ReceiveBeginPlay")
  GWorld.Battle = self
  self.Overridden.ReceiveBeginPlay(self)
  rawset(self, "BattleEvent", self.BattleEvent)
  self.Results = EffectResults.Results()
  self.Result = EffectResults.Result()
  self.CreatureSrouceMap = {}
  self.CreatureDelayHandles = {}
  self.HpLinkBuffDic = {}
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  GameState.Battle = self
  self:OnCreated()
  EventManager:AddEvent(EventID.TalkPauseGame, self, self.ClearAllDanmaku)
end

function BP_Battle_C:GetSummonInheritAttrs()
  return {
    "MaxHP",
    "Hp",
    "MaxES",
    "ES",
    "DEF",
    "SkillRange",
    "SkillSustain",
    "SkillEfficiency",
    "SkillIntensity"
  }
end

function BP_Battle_C:GetSummonSpecialInheritAttrs()
  return {
    "StrongValue",
    "EnmityValue"
  }
end

function BP_Battle_C:OnCreated()
  assert(Battle(self))
  if IsAuthority(self) then
    self:TriggerGameModeBattleInit()
  end
  print(_G.LogTag, "FireEvent OnBattleReady")
  EventManager:FireEvent(EventID.OnBattleReady, self)
end

function BP_Battle_C:GetClientOnlyFunction_Lua()
  return {
    "ExecuteClientPassiveFunction",
    "PlayUIAnim",
    "AimDiffusion",
    "BeginAccumulate",
    "CameraShake",
    "AdditionalHitFX"
  }
end

function BP_Battle_C:GetClientPredictFunction_Lua()
  return {"PlayFX", "PlaySE"}
end

function BP_Battle_C:GetServerClientBothFunction_Lua()
  return {
    "AddCameraSpeed",
    "AddCharFallSpeed",
    "HitStop",
    "ExecuteClientSkillLogicFunction",
    "ChangeModel",
    "SetToCondemnLoc",
    "GrabHit"
  }
end

function BP_Battle_C:GetServerClientBothNetMulticastFunction_Lua()
  return {
    "CreateSkillCreature",
    "CreateRayCreature",
    "RemoveRayCreature",
    "RemoveSkillCreature",
    "StartLoopShoot",
    "EndLoopShoot",
    "UpdateLoopShoot",
    "StartHeavyCharge",
    "ExecuteHeavyEffect",
    "SaveLoc",
    "OverrideCharVelocity",
    "CallBackSkillCreature",
    "ClearHitTargets",
    "ReplaceBulletFXID",
    "RemoveDanmaku"
  }
end

function BP_Battle_C:GetLuaOverrideFunction_Lua()
  return {}
end

function BP_Battle_C:TriggerGameModeBattleInit()
  if not IsAuthority(self) then
    return
  end
  UE4.UGameplayStatics.GetGameMode(self):TryTriggerOnPrepare("BattleInit")
end

function BP_Battle_C:FlushEffectResult_Lua()
  if self.Result and not self.Result.IsEmpty then
    self.Results:Add(self.Result)
    self.Result = EffectResults.Result()
  end
  if self.Results and not self.Results.IsEmpty and self.Results.ToEffectStruct then
    local EffectStruct = self.Results:ToEffectStruct()
    self:AddEffectStruct(EffectStruct)
    self.Results = EffectResults.Results()
  end
end

function BP_Battle_C:DelayCreateSkillCreature()
  local Battle = Battle(self)
  for i, v in pairs(self.CreatureSrouceMap) do
    local function CreateSkillCreatureDelay(self)
      if not UE4.UKismetSystemLibrary.IsValid(v.Source) then
        return
      end
      local BornLocationData = v.BornLocationData
      if self.BornLocation and BornLocationData and 1 ~= BornLocationData.Index then
        v.BornLocation = FVector(self.BornLocation.X, self.BornLocation.Y + BornLocationData.YOffset, self.BornLocation.Z + BornLocationData.ZOffset)
      end
      local Creature = Battle:CreateSkillCreature(v, true)
      if BornLocationData and 1 == BornLocationData.Index then
        self.BornLocation = Creature.BornLocation
      elseif not BornLocationData then
        self.BornLocation = nil
      end
    end
    
    local Interval = 0.01 * (i - 1)
    if Interval > 0 then
      local Handle = UE4.UKismetSystemLibrary.K2_SetTimerDelegate({self, CreateSkillCreatureDelay}, Interval, false)
      table.insert(self.CreatureDelayHandles, Handle)
    else
      CreateSkillCreatureDelay(self)
    end
  end
  self.CreatureSrouceMap = {}
end

function BP_Battle_C:ReceiveEndPlay()
  if self.Components then
    for _, Module in pairs(self.Components) do
      Module:Destroy(self)
    end
  end
  for i, v in pairs(self.CreatureDelayHandles) do
    UE4.UKismetSystemLibrary.K2_ClearAndInvalidateTimerHandle(self, v)
  end
  EventManager:RemoveEvent(EventID.TalkPauseGame, self)
  GWorld.Battle = nil
end

function BP_Battle_C:ToTable(SourceCharacter)
  local CharStruct = New(CharacterDataStruct)
  CharStruct.Eid = SourceCharacter.Eid
  CharStruct.Location = {
    SourceCharacter:K2_GetActorLocation().X,
    SourceCharacter:K2_GetActorLocation().Y,
    SourceCharacter:K2_GetActorLocation().Z
  }
  CharStruct.CurrentSkillId = SourceCharacter.CurrentSkillId
  if SourceCharacter and SourceCharacter.GetFireSkill then
    CharStruct.FireSkillId = SourceCharacter:GetSkillByType(UE.ESkillType.Shooting)
  end
  if SourceCharacter and SourceCharacter.GetCurrentWeapon and SourceCharacter:GetCurrentWeapon() then
    CharStruct.CurrentWeapon = SourceCharacter:GetCurrentWeapon().WeaponId
  end
  return CharStruct
end

function BP_Battle_C:ToStruct(CharStruct)
  function CharStruct.K2_GetActorLocation()
    return FVector(CharStruct.Location[1], CharStruct.Location[2], CharStruct.Location[3])
  end
  
  function CharStruct.GetFireSkill()
    return CharStruct.FireSkillId
  end
  
  function CharStruct.GetCurrentWeapon()
    if not Battle(self):GetEntity(CharStruct.Eid) then
      return nil
    end
    local Character = Battle(self):GetEntity(CharStruct.Eid)
    if not Character.Weapons then
      return
    end
    return Character.Weapons[CharStruct.CurrentWeapon]
  end
  
  return CharStruct
end

function BP_Battle_C:ShowBattleErrorLua(Text)
  self:ShowBattleError(Text, true)
end

function BP_Battle_C:StandardShowBattleErrorLua(Type, Title, Content, bCallFromCpp)
  Content = Content or ""
  if nil == Type then
    DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Type为nil")
    return
  end
  local TypeString
  local Success, Result = pcall(function()
    return UE.EShowBattleErrorType:GetNameStringByValue(Type)
  end)
  if not (Success and Result) or "" == Result then
    DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Type不是有效的EShowBattleErrorType枚举值")
    return
  end
  TypeString = Result
  if nil == Title then
    DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Title为nil")
    Title = "nil"
  elseif type(Title) ~= "string" and type(Title) ~= "number" then
    Title = tostring(Title)
  end
  if nil == Content then
    DebugPrint(ErrorTag, "StandardShowBattleErrorLua:参数Content为nil")
    Content = "nil"
  elseif type(Content) ~= "string" and type(Content) ~= "number" then
    Content = tostring(Content)
  end
  local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
  if bDistribution then
    return
  end
  local Space = "=========================================================\n"
  local Ct = "" ~= Content and {
    Space,
    "【错误大类】: ",
    TypeString,
    "\n",
    "【Title】: ",
    Title,
    "\n",
    "【Content】: ",
    Content,
    "\n"
  } or {
    Space,
    "【错误大类】: ",
    TypeString,
    "\n",
    "【Title】: ",
    Title,
    "\n"
  }
  local Ret
  self:FillBattleLog(Ct)
  if not bCallFromCpp then
    table.insert(Ct, Space)
    table.insert(Ct, [[
Traceback:
	]])
    table.insert(Ct, debug.traceback())
    table.insert(Ct, "\n")
  end
  Ret = table.concat(Ct)
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    ScreenPrint("战斗报错(StandardShowBattleError):\n" .. Ret)
  end
  if not GWorld.ErrorDict then
    GWorld.ErrorDict = {}
  end
  local ErrorDictContent = TypeString .. Title
  if "" ~= ErrorDictContent and GWorld.ErrorDict[ErrorDictContent] then
    return
  end
  GWorld.ErrorDict[ErrorDictContent] = true
  local TraceType = {
    first = GText("战斗报错"),
    second = TypeString,
    third = Title
  }
  local DescribeInfo = {
    title = GText("详细信息"),
    trace_content = Ret
  }
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SendToFeishuForBattle(Ret, "战斗报错" .. TypeString)
    Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:SendToFeishuForBattle(Ret, "战斗报错" .. TypeString)
    DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
end

function BP_Battle_C:FillBattleCharacterLog(Ct, Player)
  if not Player then
    return
  end
  local CurrentRoleId = Player.CurrentRoleId
  table.insert(Ct, "使用角色ID:")
  table.insert(Ct, tostring(CurrentRoleId))
  if DataMgr.BattleChar[CurrentRoleId] then
    local RoleName = GText(DataMgr.BattleChar[CurrentRoleId].CharName)
    table.insert(Ct, "(")
    table.insert(Ct, tostring(RoleName))
    table.insert(Ct, ")")
  end
  if Player.MeleeWeapon then
    local WeaponId = Player.MeleeWeapon.WeaponId
    table.insert(Ct, ",近战武器ID:")
    table.insert(Ct, tostring(Player.MeleeWeapon.WeaponId))
    local WeaponInfo = DataMgr.Weapon[WeaponId]
    if WeaponInfo then
      local WeaponName = WeaponInfo.WeaponName
      if DataMgr.TextMap[WeaponName] then
        WeaponName = GText(WeaponName)
      end
      if WeaponName then
        table.insert(Ct, "(")
        table.insert(Ct, WeaponName)
        table.insert(Ct, ")")
      end
    end
  end
  if Player.RangedWeapon then
    local WeaponId = Player.RangedWeapon.WeaponId
    table.insert(Ct, ",远程武器ID:")
    table.insert(Ct, tostring(Player.RangedWeapon.WeaponId))
    local WeaponInfo = DataMgr.Weapon[WeaponId]
    if WeaponInfo then
      local WeaponName = WeaponInfo.WeaponName
      if DataMgr.TextMap[WeaponName] then
        WeaponName = GText(WeaponName)
      end
      if WeaponName then
        table.insert(Ct, "(")
        table.insert(Ct, WeaponName)
        table.insert(Ct, ")")
      end
    end
  end
  if not Player:IsPhantom() then
    table.insert(Ct, "\n基础信息:")
    table.insert(Ct, "  Eid: ")
    table.insert(Ct, tostring(Player.Eid or "Unknown"))
    table.insert(Ct, "  模型Id: ")
    table.insert(Ct, tostring(Player.ModelId or "Unknown"))
    table.insert(Ct, "\n初始化状态:")
    table.insert(Ct, "  InitSuccess: ")
    table.insert(Ct, Player.InitSuccess and "成功" or "失败")
    table.insert(Ct, "  ServerInitSuccess: ")
    table.insert(Ct, Player.ServerInitSuccess and "成功" or "失败")
    if Player.IsCharacterReady then
      table.insert(Ct, "  IsCharacterReady: ")
      table.insert(Ct, Player:IsCharacterReady() and "就绪" or "未就绪")
    end
    if Player.WaitInitTags then
      local waitCount = 0
      for _ in pairs(Player.WaitInitTags) do
        waitCount = waitCount + 1
      end
      if waitCount > 0 then
        table.insert(Ct, "  WaitInitTags: ")
        table.insert(Ct, tostring(waitCount))
      end
    end
    local hasSpecialState = false
    local specialStates = {}
    if Player.bInJetRush then
      table.insert(specialStates, "喷射冲刺")
      hasSpecialState = true
    end
    if Player.bInJetState then
      table.insert(specialStates, "喷射状态")
      hasSpecialState = true
    end
    if Player.EnableAnimFly then
      table.insert(specialStates, "飞行动画")
      hasSpecialState = true
    end
    if Player.JumpHolden then
      table.insert(specialStates, "跳跃保持")
      hasSpecialState = true
    end
    if Player.SprintHolden then
      table.insert(specialStates, "冲刺保持")
      hasSpecialState = true
    end
    if hasSpecialState then
      table.insert(Ct, "\n特殊状态:")
      for i, state in ipairs(specialStates) do
        if i > 1 then
          table.insert(Ct, ", ")
        end
        table.insert(Ct, "  " .. state)
      end
    end
  end
  if Player:IsPlayer() then
    local Flag = false
    local PhantomTeammate = Player:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
      if Target ~= Player then
        if not Flag then
          table.insert(Ct, "\n正在使用的魅影信息:")
          Flag = true
        end
        table.insert(Ct, [[

	]])
        self:FillBattleCharacterLog(Ct, Target)
      end
    end
  end
end

function BP_Battle_C:FillBattleLog(Ct)
  local Avatar = GWorld:GetAvatar()
  table.insert(Ct, "环境:")
  if IsClient(self) then
    table.insert(Ct, "联机客户端")
  elseif IsDedicatedServer(self) then
    table.insert(Ct, "联机服务端")
  elseif Avatar and Avatar:IsInHardBoss() then
    table.insert(Ct, "梦魇残声")
    if Avatar.HardBossInfo then
      table.insert(Ct, ":编号[")
      local HardBossId = Avatar.HardBossInfo.HardBossId
      table.insert(Ct, HardBossId)
      table.insert(Ct, "]")
      local Context
      if DataMgr.HardBossMain[HardBossId] then
        local HardBossName = DataMgr.HardBossMain[HardBossId].HardBossName
        if DataMgr.TextMap[HardBossName] then
          Context = GText(HardBossName)
        end
      end
      if Context then
        table.insert(Ct, "[")
        table.insert(Ct, Context)
        table.insert(Ct, "]")
      end
      local DifficultyId = Avatar.HardBossInfo.DifficultyId
      local DifficultyLevel
      if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
        DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
      end
      table.insert(Ct, ":难度等级[")
      table.insert(Ct, DifficultyLevel)
      table.insert(Ct, "]")
    end
  elseif Avatar and Avatar.CurrentOnlineType and -1 ~= Avatar.CurrentOnlineType then
    table.insert(Ct, "区域联机")
  else
    table.insert(Ct, "单机")
  end
  local PlatformName
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    PlatformName = "编辑器"
  else
    PlatformName = UGameplayStatics.GetPlatformName()
  end
  table.insert(Ct, "  平台:" .. tostring(PlatformName))
  table.insert(Ct, "\n")
  local Space = "================" .. "角色信息" .. "================\n"
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  table.insert(Ct, Space)
  if IsDedicatedServer(self) then
    local AllPlayer = GameMode:GetAllPlayer()
    for i, Player in pairs(AllPlayer) do
      table.insert(Ct, "[")
      table.insert(Ct, i)
      table.insert(Ct, "]")
      self:FillBattleCharacterLog(Ct, Player)
      table.insert(Ct, "\n")
    end
  else
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local CurrentRoleId
    if Player then
      CurrentRoleId = Player.CurrentRoleId
    end
    self:FillBattleCharacterLog(Ct, Player)
    table.insert(Ct, "\n")
  end
  Space = "================" .. "副本信息" .. "================\n"
  local GameState = UE.UGameplayStatics.GetGameState(self.Player)
  if IsValid(GameState) and GameState:IsInDungeon() then
    table.insert(Ct, Space)
    self:FillDungeonLog(Ct, GameState)
  end
  Space = "================" .. "区域信息" .. "================\n"
  if IsValid(GameState) and GameState:IsInRegion() and Avatar then
    table.insert(Ct, Space)
    self:FillRegionLog(Ct, GameMode, Avatar)
  end
  Space = "================" .. "时间信息" .. "================\n"
  table.insert(Ct, Space)
  self:FillTimeLog(Ct)
  Space = "================" .. "UI信息" .. "================\n"
  table.insert(Ct, Space)
  self:FillUIInfoLog(Ct)
end

function BP_Battle_C:FillDungeonLog(Ct, GameState)
  local DungeonId = GameState.DungeonId
  if not DungeonId or DungeonId <= 0 then
    return
  end
  table.insert(Ct, "副本ID:")
  table.insert(Ct, tostring(DungeonId))
  local DungeonInfo = DataMgr.Dungeon[DungeonId]
  local DungeonType
  if DungeonInfo then
    local DungeonName = DungeonInfo.DungeonName
    if DungeonName and DataMgr.TextMap[DungeonName] then
      DungeonName = GText(DungeonName)
    end
    table.insert(Ct, "(")
    table.insert(Ct, tostring(DungeonName))
    table.insert(Ct, ")")
    DungeonType = DungeonInfo.DungeonType
    if DungeonInfo.DungeonType then
      table.insert(Ct, "  [")
      table.insert(Ct, "副本类型: ")
      table.insert(Ct, tostring(DungeonInfo.DungeonType))
      table.insert(Ct, "]")
    end
  end
  table.insert(Ct, "\n")
  if DungeonInfo then
    if DungeonInfo.DungeonLevel then
      table.insert(Ct, "副本等级: ")
      table.insert(Ct, tostring(DungeonInfo.DungeonLevel))
      table.insert(Ct, "")
    end
    if DungeonId and DataMgr.Dungeon[DungeonId] and DataMgr.Dungeon[DungeonId].IsWeeklyDungeon then
      table.insert(Ct, "      是否为周本: 是")
    else
      table.insert(Ct, "      是否为周本: 否")
    end
  end
  local SceneManager = GWorld.GameInstance:GetSceneManager()
  if SceneManager then
    local SceneName = SceneManager:GetCurSceneName()
    if SceneName then
      table.insert(Ct, "      当前场景名称: ")
      table.insert(Ct, tostring(SceneName))
    end
  end
  table.insert(Ct, "\n")
  if self:IsInSettlement() then
    table.insert(Ct, "是否结算: 是")
  else
    table.insert(Ct, "是否结算: 否")
    if GameState.DungeonProgress then
      table.insert(Ct, "      副本当前进度(轮次): ")
      table.insert(Ct, tostring(GameState.DungeonProgress))
    end
    if GameState.MonsterNum then
      table.insert(Ct, "      当前敌人数量: ")
      table.insert(Ct, tostring(GameState.MonsterNum))
    end
  end
  table.insert(Ct, "\n")
end

function BP_Battle_C:FillTimeLog(Ct)
  local WorldTime = GWorld:GetCurrentTime()
  table.insert(Ct, "当前World运行时间（进入副本/父区域时间）:")
  local minutes = math.floor(WorldTime / 60)
  local seconds = WorldTime % 60
  if minutes > 0 then
    table.insert(Ct, string.format("  时间: %d分%.0f秒", minutes, seconds))
  else
    table.insert(Ct, string.format("  时间: %.0f秒", seconds))
  end
  table.insert(Ct, "\n")
  local SystemTime = os.time()
  if self.LastErrorLogTime then
    local LastTimeStr = os.date("%Y-%m-%d %H:%M:%S", self.LastErrorLogTime)
    local TimeSinceLast = math.floor(SystemTime - self.LastErrorLogTime)
    table.insert(Ct, "上次战斗报错距今(" .. LastTimeStr .. "):")
    local hours = math.floor(TimeSinceLast / 3600)
    local minutes = math.floor(TimeSinceLast % 3600 / 60)
    local seconds = TimeSinceLast % 60
    local timeStr = ""
    if hours > 0 then
      timeStr = timeStr .. hours .. "小时"
    end
    if minutes > 0 then
      timeStr = timeStr .. minutes .. "分钟"
    end
    if seconds > 0 or 0 == hours and 0 == minutes then
      timeStr = timeStr .. seconds .. "秒"
    end
    table.insert(Ct, timeStr)
    table.insert(Ct, "\n")
  end
  self.LastErrorLogTime = SystemTime
end

function BP_Battle_C:FillUIInfoLog(Ct)
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  if IsValid(UIManager) then
    local ExcludeUIPrefixes = {
      "TaskIndicator",
      "PoolClass_Monster",
      "BattleHitDirection",
      "TalkGuideUI"
    }
    
    local function IsUIExcluded(UiName)
      for _, prefix in ipairs(ExcludeUIPrefixes) do
        if string.sub(UiName, 1, string.len(prefix)) == prefix then
          return true
        end
      end
      return false
    end
    
    table.insert(Ct, "当前UI:")
    table.insert(Ct, "\n")
    local AllUI = UIManager.UIInstances:ToTable()
    local RootWidgets = {}
    for _, Widget in pairs(AllUI) do
      if IsValid(Widget) then
        local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
        if not IsUIExcluded(UIName) then
          local Parent = Widget:GetParent()
          table.insert(RootWidgets, Widget)
        end
      end
    end
    
    local function BuildUIHierarchy(Widget, Depth)
      local Indent = string.rep("  ", Depth)
      local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
      local VisibilityState = Widget:IsVisible() and "显示" or "隐藏"
      local HideTagsInfo = ""
      if not Widget:IsVisible() and Widget.HideTags then
        local HideTags = Widget.HideTags
        if HideTags and type(HideTags) == "table" and next(HideTags) then
          local TagsList = {}
          for tag, _ in pairs(HideTags) do
            table.insert(TagsList, tostring(tag))
          end
          if #TagsList > 0 then
            local TagsStr = table.concat(TagsList, ",")
            HideTagsInfo = string.format(" [HideTags:%s]", TagsStr)
          end
        elseif HideTags and "string" == type(HideTags) and "" ~= HideTags then
          HideTagsInfo = string.format(" [HideTags:%s]", HideTags)
        end
      end
      local UIInfo = string.format("%s├─ %s (%s)%s", Indent, UIName, VisibilityState, HideTagsInfo)
      table.insert(Ct, UIInfo)
      table.insert(Ct, "\n")
    end
    
    if #RootWidgets > 0 then
      for _, RootWidget in pairs(RootWidgets) do
        BuildUIHierarchy(RootWidget, 0)
      end
    else
      table.insert(Ct, "  无活跃UI")
      table.insert(Ct, "\n")
    end
    local TotalUICount = 0
    local VisibleUICount = 0
    local HiddenUICount = 0
    local ExcludeUICount = 0
    for _, Widget in pairs(AllUI) do
      if IsValid(Widget) then
        TotalUICount = TotalUICount + 1
        local UIName = Widget.ConfigName or Widget.WidgetName or "Unknown"
        if IsUIExcluded(UIName) then
          ExcludeUICount = ExcludeUICount + 1
        elseif Widget:IsVisible() then
          VisibleUICount = VisibleUICount + 1
        else
          HiddenUICount = HiddenUICount + 1
        end
      end
    end
    table.insert(Ct, string.format("UI统计: 总计%d个, 可见%d个, 隐藏%d个, 排除%d个(排除前缀:%s)", TotalUICount, VisibleUICount, HiddenUICount, ExcludeUICount, table.concat(ExcludeUIPrefixes, ",")))
    table.insert(Ct, "\n")
  end
end

function BP_Battle_C:FillRegionLog(Ct, GameMode, Avatar)
  local RegionId = Avatar:GetCurrentRegionId()
  table.insert(Ct, "子区域ID:")
  table.insert(Ct, tostring(RegionId))
  local RegionInfo = DataMgr.SubRegion[RegionId]
  if not RegionInfo then
    return
  end
  local RegionName = RegionInfo.SubRegionName
  if DataMgr.TextMap[RegionName] then
    RegionName = GText(RegionName)
  end
  table.insert(Ct, "(")
  table.insert(Ct, tostring(RegionName))
  table.insert(Ct, ")")
  table.insert(Ct, "\n")
  if GameMode and GameMode.RegionId then
    table.insert(Ct, "父区域ID:")
    table.insert(Ct, tostring(GameMode.RegionId))
    local MainRegionInfo = DataMgr.Region[GameMode.RegionId]
    if MainRegionInfo then
      local MainRegionName = MainRegionInfo.RegionName
      if DataMgr.TextMap[MainRegionName] then
        MainRegionName = GText(MainRegionName)
      end
      table.insert(Ct, "(")
      table.insert(Ct, tostring(MainRegionName))
      table.insert(Ct, ")")
    end
    table.insert(Ct, "\n")
  end
  local SceneManager = GWorld.GameInstance:GetSceneManager()
  if SceneManager then
    local SceneName = SceneManager:GetCurSceneName()
    if SceneName then
      table.insert(Ct, "当前场景名称: ")
      table.insert(Ct, tostring(SceneName))
      table.insert(Ct, "\n")
    end
  end
end

function BP_Battle_C:ShowBattleError(Text, HideTraceback)
  local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
  local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
  if bDistribution and not bEnableShippingLog then
    return
  end
  local Space = "=========================================================\n"
  local Ct = {
    Space,
    "报错文本:\n\t",
    tostring(Text),
    "\n"
  }
  local Ret
  if not HideTraceback then
    table.insert(Ct, Space)
    table.insert(Ct, [[
Traceback:
	]])
    table.insert(Ct, debug.traceback())
    table.insert(Ct, "\n")
  end
  table.insert(Ct, Space)
  self:FillBattleLog(Ct)
  Ret = table.concat(Ct)
  if UE4.URuntimeCommonFunctionLibrary.IsPlayInEditor(self) then
    ScreenPrint("战斗报错:\n" .. Ret)
  end
  if not GWorld.ErrorDict then
    GWorld.ErrorDict = {}
  end
  if GWorld.ErrorDict[Text] then
    return
  end
  GWorld.ErrorDict[Text] = true
  local TraceType = {
    first = "战斗报错",
    second = "旧版ShowBattleError",
    third = "其他分类"
  }
  local DescribeInfo = {
    title = "战斗报错",
    trace_content = Ret
  }
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SendToFeishuForBattle(Ret, "战斗报错")
    Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:SendToFeishuForBattle(Ret, "战斗报错")
    DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
end

function BP_Battle_C:GetLimitSeNumEachAttack()
  return Const.EveryAttackLimitSeNum
end

function BP_Battle_C:InitBannedRecordTags()
  local Arr = TArray(FName)
  local BannedRecordTags = EMCache:Get("BannedRecordTags")
  if BannedRecordTags and next(BannedRecordTags) then
    for Tag, _ in pairs(BannedRecordTags) do
      Arr:Add(Tag)
    end
  end
  self:SetBannedRecordTags(Arr)
end

function BP_Battle_C:ShowError_Monster_Inner_Lua(Text, Title)
  if nil == Title then
    Title = "怪物组报错"
  end
  local bDistribution = UE4.URuntimeCommonFunctionLibrary.IsDistribution()
  local bEnableShippingLog = UE4.URuntimeCommonFunctionLibrary.EnableLogInShipping()
  if bDistribution and not bEnableShippingLog then
    return
  end
  local Space = "=========================================================\n"
  local ct = {
    Space,
    "报错文本:\n\t",
    tostring(Text),
    "\n"
  }
  local ret
  table.insert(ct, Space)
  table.insert(ct, [[
Traceback:
	]])
  table.insert(ct, debug.traceback())
  table.insert(ct, "\n")
  table.insert(ct, Space)
  self:FillLog_Monster(ct)
  ret = table.concat(ct)
  if not GWorld.ErrorDict then
    GWorld.ErrorDict = {}
  end
  if GWorld.ErrorDict[Text] then
    return
  end
  GWorld.ErrorDict[Text] = true
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    local LocalUser = UE.UKismetSystemLibrary:GetPlatformUserName()
    local ret = "设备名：" .. LocalUser .. "\n" .. ret
    Avatar:CallServerMethod("SendToFeiShuForMonster", ret, Title)
    return
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:SendToFeishuForMonster(ret, Title)
    return
  end
  local TraceType = {
    first = GText("怪物报错"),
    second = Title,
    third = ""
  }
  local DescribeInfo = {
    title = GText("详细信息"),
    trace_content = ret
  }
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
  local DSEntity = GWorld:GetDSEntity()
  if DSEntity then
    DSEntity:SendTraceToQaWeb(TraceType, DescribeInfo)
    return
  end
end

function BP_Battle_C:FillLog_Monster(ct)
  local Avatar = GWorld:GetAvatar()
  table.insert(ct, "环境:")
  if IsClient(self) then
    table.insert(ct, "联机客户端\n")
  elseif IsDedicatedServer(self) then
    table.insert(ct, "联机服务端\n")
  elseif Avatar and Avatar:IsInHardBoss() then
    table.insert(ct, "梦魇残声")
    if Avatar.HardBossInfo then
      table.insert(ct, ":编号[")
      local HardBossId = Avatar.HardBossInfo.HardBossId
      table.insert(ct, HardBossId)
      table.insert(ct, "]")
      local Context
      if DataMgr.HardBossMain[HardBossId] then
        local HardBossName = DataMgr.HardBossMain[HardBossId].HardBossName
        if DataMgr.TextMap[HardBossName] then
          Context = GText(HardBossName)
        end
      end
      if Context then
        table.insert(ct, "[")
        table.insert(ct, Context)
        table.insert(ct, "]")
      end
      local DifficultyId = Avatar.HardBossInfo.DifficultyId
      local DifficultyLevel
      if DifficultyId and DataMgr.HardBossDifficulty[DifficultyId] then
        DifficultyLevel = DataMgr.HardBossDifficulty[DifficultyId].DifficultyLevel
      end
      table.insert(ct, ":难度等级[")
      table.insert(ct, DifficultyLevel)
      table.insert(ct, "]")
    end
    table.insert(ct, "\n")
  else
    table.insert(ct, "单机\n")
  end
  local GameMode = UE4.UGameplayStatics.GetGameMode(self)
  if IsDedicatedServer(self) then
    local AllPlayer = GameMode:GetAllPlayer()
    for i, Player in pairs(AllPlayer) do
      table.insert(ct, "[")
      table.insert(ct, i)
      table.insert(ct, "]")
      self:FillCharacterLog_Monster(ct, Player)
      table.insert(ct, "\n")
    end
  else
    local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
    local CurrentRoleId
    if Player then
      CurrentRoleId = Player.CurrentRoleId
    end
    self:FillCharacterLog_Monster(ct, Player)
    table.insert(ct, "\n")
  end
  local GameState = UE.UGameplayStatics.GetGameState(self.Player)
  if IsValid(GameState) then
    local DungeonId = GameState.DungeonId
    if DungeonId and DungeonId > 0 then
      table.insert(ct, "副本ID:")
      table.insert(ct, tostring(DungeonId))
      local DungeonInfo = DataMgr.Dungeon[DungeonId]
      if DungeonInfo then
        local DungeonName = DungeonInfo.DungeonName
        if DungeonName and DataMgr.TextMap[DungeonName] then
          DungeonName = GText(DungeonName)
        end
        table.insert(ct, "(")
        table.insert(ct, tostring(DungeonName))
        table.insert(ct, ")")
      end
      table.insert(ct, "\n")
    end
  end
  if IsValid(GameMode) and GameMode:IsInRegion() and Avatar then
    local RegionId = Avatar:GetCurrentRegionId()
    table.insert(ct, "子区域ID:")
    table.insert(ct, tostring(RegionId))
    local RegionInfo = DataMgr.SubRegion[RegionId]
    if RegionInfo then
      local RegionName = RegionInfo.SubRegionName
      if DataMgr.TextMap[RegionName] then
        RegionName = GText(RegionName)
      end
      table.insert(ct, "(")
      table.insert(ct, tostring(RegionName))
      table.insert(ct, ")")
    end
    table.insert(ct, "\n")
  end
end

function BP_Battle_C:FillCharacterLog_Monster(ct, Player)
  if not Player then
    return
  end
  local CurrentRoleId = Player.CurrentRoleId
  table.insert(ct, "使用角色ID:")
  table.insert(ct, tostring(CurrentRoleId))
  if DataMgr.BattleChar[CurrentRoleId] then
    local RoleName = GText(DataMgr.BattleChar[CurrentRoleId].CharName)
    table.insert(ct, "(")
    table.insert(ct, tostring(RoleName))
    table.insert(ct, ")")
  end
  if Player:IsPlayer() then
    local Flag = false
    local PhantomTeammate = Player:GetPhantomTeammates()
    for _, Target in pairs(PhantomTeammate) do
      if Target ~= Player then
        if not Flag then
          table.insert(ct, "\n正在使用的魅影信息:")
          Flag = true
        end
        table.insert(ct, [[

	]])
        self:FillCharacterLog_Monster(ct, Target)
      end
    end
  end
end

function BP_Battle_C:IsInSettlement()
  return UIManager(self):GetUI("DungeonSettlement") ~= nil
end

AssembleComponents(BP_Battle_C)
return BP_Battle_C
