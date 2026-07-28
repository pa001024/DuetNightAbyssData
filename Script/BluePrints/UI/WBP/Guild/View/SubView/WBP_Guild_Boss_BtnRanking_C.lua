require("UnLua")
local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")

local function LookupMemberInfo(MemberInfos, Uid)
  if type(MemberInfos) ~= "table" or nil == Uid then
    return nil
  end
  return MemberInfos[Uid] or MemberInfos[tostring(Uid)] or MemberInfos[tonumber(Uid)]
end

local function GetRankArray(GuildBossData, Getter, FieldName)
  if not GuildBossData then
    return {}
  end
  local List
  local GetterFn = GuildBossData[Getter]
  if type(GetterFn) == "function" then
    List = GetterFn(GuildBossData)
  end
  List = List or GuildBossData[FieldName]
  if List and "function" == type(List.Values) then
    return List:Values()
  end
  if type(List) == "table" then
    return List
  end
  return {}
end

local function GetCurrentBossId(GuildBossData)
  if not GuildBossData then
    return 0
  end
  if GuildBossData.GetCurrentBossId then
    return tonumber(GuildBossData:GetCurrentBossId()) or 0
  end
  return tonumber(GuildBossData.CurrentBossId) or 0
end

local function GetBossMaxHp(BossId)
  BossId = tonumber(BossId) or 0
  local BossInfo = BossId > 0 and DataMgr.GuildBossInfo[BossId] or nil
  local BossHP = BossInfo and tonumber(BossInfo.BossTotalHP) or 0
  if not BossHP or BossHP <= 0 then
    BossHP = 1
  end
  return BossHP
end

local function IsCurrentBossRankItem(Item, BossId)
  BossId = tonumber(BossId) or 0
  if BossId <= 0 then
    return true
  end
  return tonumber(Item and Item.BossId) == BossId
end

local function CollectMemberUids(...)
  local UidSet = {}
  local Uids = {}
  for Index = 1, select("#", ...) do
    local RankData = select(Index, ...)
    local RankInfoList = RankData and RankData.RankInfoList
    for _, Data in ipairs(RankInfoList or {}) do
      local Uid = tonumber(Data.Uid)
      if Uid and Uid > 0 and not UidSet[Uid] then
        UidSet[Uid] = true
        table.insert(Uids, Uid)
      end
    end
  end
  return Uids
end

local function EmptyRankData()
  return {
    RankInfoList = {},
    SelfRankInfo = {},
    MemberUids = {}
  }
end

local function TryBlockParentInput(Parent, bBlock)
  if Parent and Parent.BlockAllUIInput then
    Parent:BlockAllUIInput(bBlock)
  end
end

local function EnsureCommonRankingPreloaded(UIManager, OnReady)
  if not UIManager then
    OnReady()
    return
  end
  if UIManager:GetPreloadUIClass("CommonRanking") then
    OnReady()
    return
  end
  local Config = DataMgr.SystemUI.CommonRanking
  if not Config then
    OnReady()
    return
  end
  local BPPath = CommonUtils.GetDeviceTypeByPlatformName(UIManager) == "PC" and Config.PCBPPath or Config.MobileBPPath or Config.PCBPPath
  if not BPPath then
    OnReady()
    return
  end
  local Class = UE4.UClass.Load(BPPath)
  if Class then
    UIManager.PreLoadUIStates:Add("CommonRanking", Class)
  end
  OnReady()
end

local function ResolveTargetGuildId(Self)
  local TargetGuildId = tonumber(Self.TargetGuildId) or 0
  if TargetGuildId > 0 then
    return TargetGuildId
  end
  if Self.Parent and tonumber(Self.Parent.TargetGuildId) and tonumber(Self.Parent.TargetGuildId) > 0 then
    return tonumber(Self.Parent.TargetGuildId)
  end
  return GuildModel:ResolveGuildBossDisplayGuildId(nil)
end

local function OpenRankUIWithGuildBossData(Self, MemberInfos)
  TryBlockParentInput(Self.Parent, false)
  if not IsValid(Self) then
    return
  end
  Self:PreprocessRankData(MemberInfos)
  EnsureCommonRankingPreloaded(UIManager(), function()
    if not IsValid(Self) then
      return
    end
    Self:LoadRankUI()
  end)
end

local function BuildUidSquadMap(GuildBossData, BossId)
  local UidSquadMap = {}
  local SingleDamageRank = GetRankArray(GuildBossData, "GetSingleDamageRank", "SingleDamageRank")
  for _, DamageData in ipairs(SingleDamageRank) do
    if IsCurrentBossRankItem(DamageData, BossId) then
      local Squad = DamageData.Squad
      if Squad and "" ~= Squad then
        UidSquadMap[tostring(DamageData.Uid)] = Squad
      end
    end
  end
  return UidSquadMap
end

local function ResolveRankSquad(Data, UidSquadMap)
  local Squad = Data and Data.Squad
  if Squad and "" ~= Squad then
    return Squad
  end
  if not Data or Data.Uid == nil then
    return ""
  end
  return UidSquadMap[tostring(Data.Uid)] or ""
end

local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C"
}

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClick)
  self:AddInputMethodChangedListen()
  self:RefreshOpInfoByInputDevice(UIUtils.UtilsGetCurrentInputType())
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClick)
end

function M:Init(Params)
  Params = Params or {}
  self.GuildBossData = Params.GuildBossData
  self.TargetGuildId = Params.TargetGuildId
  self.Parent = Params.Parent
  self.Key_Controller:CreateGamepadKey(Params.GamePadKey)
  self.Avatar = GWorld:GetAvatar()
  self.Text_Name:SetText(GText("UI_GuildBoss_DrillData"))
end

function M:OnBtnClick()
  AudioManager(self):PlayUISound(self.Btn_Click, "event:/ui/common/click_mid", nil, nil)
  self:OpenRankUI()
end

function M:OpenRankUI()
  self.Avatar = self.Avatar or GWorld:GetAvatar()
  local TargetGuildId = ResolveTargetGuildId(self)
  
  local function BeginOpenRankUI()
    if not IsValid(self) then
      return
    end
    self.DamageRankData = self:GetGuildSingleDamageRankData() or EmptyRankData()
    self.ContributionRankData = self:GetGuildTotalContributionRankData() or EmptyRankData()
    local MemberUids = CollectMemberUids(self.DamageRankData, self.ContributionRankData)
    if #MemberUids < 1 then
      OpenRankUIWithGuildBossData(self, nil)
      return
    end
    if not self.Avatar or not self.Avatar.QueryGuildMemberInfo then
      OpenRankUIWithGuildBossData(self, nil)
      return
    end
    TryBlockParentInput(self.Parent, true)
    self.Avatar:QueryGuildMemberInfo(function(Ret, MemberInfos)
      local Infos = ErrorCode:Check(Ret) and MemberInfos or nil
      OpenRankUIWithGuildBossData(self, Infos)
    end, MemberUids, true)
  end
  
  TryBlockParentInput(self.Parent, true)
  GuildModel:GetGuildBossDataByGuildId(TargetGuildId, function(GuildBossData)
    if not IsValid(self) then
      TryBlockParentInput(self.Parent, false)
      return
    end
    self.GuildBossData = GuildBossData
    BeginOpenRankUI()
  end)
end

function M:PreprocessRankData(MemberInfos)
  local Avatar = self.Avatar or GWorld:GetAvatar()
  
  local function ResolveMemberInfo(Uid)
    if MemberInfos then
      local Info = LookupMemberInfo(MemberInfos, Uid)
      if Info then
        return Info
      end
    end
    if Avatar and nil ~= Uid and tostring(Uid) == tostring(Avatar.Uid) then
      return Avatar
    end
    return GuildModel:GetCurrMember(Uid)
  end
  
  local function FillRankInfo(RankInfoList)
    for _, Data in ipairs(RankInfoList) do
      local MemberInfo = ResolveMemberInfo(Data.Uid)
      if MemberInfo then
        if MemberInfo.HeadIconId ~= nil then
          Data.HeadIconId = MemberInfo.HeadIconId
        end
        if nil ~= MemberInfo.HeadFrameId then
          Data.HeadFrameId = MemberInfo.HeadFrameId
        end
        if nil ~= MemberInfo.Level then
          Data.Level = MemberInfo.Level
        end
        if MemberInfo.Nickname and MemberInfo.Nickname ~= "" then
          Data.Nickname = MemberInfo.Nickname
        end
        if nil ~= MemberInfo.TitleBefore then
          Data.TitleBefore = MemberInfo.TitleBefore
        end
        if nil ~= MemberInfo.TitleAfter then
          Data.TitleAfter = MemberInfo.TitleAfter
        end
        if nil ~= MemberInfo.TitleFrame then
          Data.TitleFrame = MemberInfo.TitleFrame
        end
      end
      Data.HeadIconId = Data.HeadIconId or 10001
    end
  end
  
  FillRankInfo(self.DamageRankData.RankInfoList)
  FillRankInfo(self.ContributionRankData.RankInfoList)
end

function M:LoadRankUI()
  local Params = {
    GuildBossData = self.GuildBossData,
    TargetGuildId = ResolveTargetGuildId(self),
    MainTab = {
      TitleName = "UI_GuildBoss_DrillData",
      SubWidgetInfo = {
        WidgetPath = "WidgetBlueprint'/Game/UI/WBP/Guild/Widget/Boss/WBP_Guild_Boss_BtnAssistPlayer.WBP_Guild_Boss_BtnAssistPlayer'",
        GamepadKey = "Gamepad_Special_Right"
      }
    },
    Tabs = {
      [1] = {
        Text = GText("UI_GuildBoss_SingleDamageRank"),
        TabId = 1
      },
      [2] = {
        Text = GText("UI_GuildBoss_TotalContributionRank"),
        TabId = 2
      }
    },
    HeaderNames = {
      [1] = {
        {
          Text = "RaidDungeon_Raid_Rank"
        },
        {
          Text = "RaidDungeon_Rank_Name"
        },
        {
          Text = "UI_GuildBoss_Damage"
        },
        {
          Text = "RaidDungeon_Rank_CharList"
        }
      },
      [2] = {
        {
          Text = "RaidDungeon_Raid_Rank"
        },
        {
          Text = "RaidDungeon_Rank_Name"
        },
        {
          Text = "UI_GuildBoss_BreakContribution",
          QaText = "UI_GuildBoss_ThreeTrialsStats"
        },
        {
          Text = "UI_GuildBoss_HPContribution"
        }
      }
    },
    TopNRankInfo = {
      [1] = self.DamageRankData.RankInfoList,
      [2] = self.ContributionRankData.RankInfoList
    },
    TopNRankKeys = {
      [1] = {Column03Key = "Damage", Column04Key = "Squad"},
      [2] = {
        Column03Key = "TrialContribution",
        Column04Key = "HPContribution"
      }
    },
    TopNRankTextMap = {
      [1] = {Column03TextMap = "%.0f"},
      [2] = {Column03TextMap = "%.0f%%", Column04TextMap = "%.0f%%"}
    },
    SelfRankInfo = {
      [1] = self.DamageRankData.SelfRankInfo,
      [2] = self.ContributionRankData.SelfRankInfo
    },
    ItemTypeIndex = {
      [1] = 0,
      [2] = 1
    },
    RankEmptyText = "UI_GuildBoss_NoPlayerData",
    PreviewActorTabId = 1
  }
  UIManager():LoadUINew("CommonRanking", Params)
end

function M:GetGuildSingleDamageRankData()
  local Avatar = self.Avatar or GWorld:GetAvatar()
  if not Avatar then
    return EmptyRankData()
  end
  local GuildBossData = self.GuildBossData
  if not GuildBossData then
    return EmptyRankData()
  end
  local BossId = GetCurrentBossId(GuildBossData)
  local SingleDamageRank = GetRankArray(GuildBossData, "GetSingleDamageRank", "SingleDamageRank")
  local Result = EmptyRankData()
  table.sort(SingleDamageRank, function(A, B)
    local ADamage = tonumber(A.Damage) or 0
    local BDamage = tonumber(B.Damage) or 0
    if ADamage == BDamage then
      return (tonumber(A.Uid) or 0) < (tonumber(B.Uid) or 0)
    end
    return ADamage > BDamage
  end)
  for _, Data in ipairs(SingleDamageRank) do
    if not IsCurrentBossRankItem(Data, BossId) then
    else
      local RankInfo = {}
      RankInfo.Uid = Data.Uid
      RankInfo.BossId = Data.BossId
      RankInfo.Damage = tonumber(Data.Damage) or 0
      RankInfo.Squad = Data.Squad
      RankInfo.Nickname = Data.Nickname or ""
      if tostring(RankInfo.Uid) == tostring(Avatar.Uid) then
        Result.SelfRankInfo = RankInfo
      end
      table.insert(Result.MemberUids, RankInfo.Uid)
      table.insert(Result.RankInfoList, RankInfo)
    end
  end
  return Result
end

function M:GetGuildTotalContributionRankData()
  local Avatar = self.Avatar or GWorld:GetAvatar()
  if not Avatar then
    return EmptyRankData()
  end
  local GuildBossData = self.GuildBossData
  if not GuildBossData then
    return EmptyRankData()
  end
  local BossId = GetCurrentBossId(GuildBossData)
  local BossHP = GetBossMaxHp(BossId)
  local TotalContributionRank = GetRankArray(GuildBossData, "GetTotalContributionRank", "TotalContributionRank")
  local UidSquadMap = BuildUidSquadMap(GuildBossData, BossId)
  local Result = EmptyRankData()
  table.sort(TotalContributionRank, function(A, B)
    local AContribution = tonumber(A.TrialContribution) or 0
    local BContribution = tonumber(B.TrialContribution) or 0
    if AContribution == BContribution then
      return (tonumber(A.Uid) or 0) < (tonumber(B.Uid) or 0)
    end
    return AContribution > BContribution
  end)
  for _, Data in ipairs(TotalContributionRank) do
    if not IsCurrentBossRankItem(Data, BossId) then
    else
      local RankInfo = {}
      RankInfo.Uid = Data.Uid
      RankInfo.BossId = Data.BossId
      RankInfo.Damage = Data.Damage
      RankInfo.TrialContribution = tonumber(Data.TrialContribution) or 0
      RankInfo.HPContribution = (tonumber(Data.Damage) or 0) / BossHP * 100
      RankInfo.Squad = ResolveRankSquad(Data, UidSquadMap)
      RankInfo.Nickname = Data.Nickname or ""
      if tostring(RankInfo.Uid) == tostring(Avatar.Uid) then
        Result.SelfRankInfo = RankInfo
      end
      table.insert(Result.MemberUids, RankInfo.Uid)
      table.insert(Result.RankInfoList, RankInfo)
    end
  end
  return Result
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamepadInput = CurInputDevice == ECommonInputType.Gamepad
  local Visible = UIConst.VisibilityOp.SelfHitTestInvisible
  local Collapsed = UIConst.VisibilityOp.Collapsed
  local Visibility = self.IsGamepadInput and Visible or Collapsed
  self.Key_Controller:SetVisibility(Visibility)
end

AssembleComponents(M)
return M
