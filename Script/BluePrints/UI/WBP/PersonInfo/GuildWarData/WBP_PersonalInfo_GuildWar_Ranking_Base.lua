require("UnLua")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local SerializeUtils = require("Utils.SerializeUtils")
local UIUtils = require("Utils.UIUtils")
local PersonInfoController = require("BluePrints.UI.WBP.PersonInfo.PersonInfoController")

local function GetMainPageActorController()
  local MainPage = PersonInfoController.MainPage
  local PersonInfoMainPage = MainPage and MainPage.PersonInfoMainPage
  return PersonInfoMainPage and PersonInfoMainPage.ActorController or nil
end

local function RebuildMainPagePreviewAfterRankingClosed()
  local MainPage = PersonInfoController.MainPage
  local PersonInfoMainPage = MainPage and MainPage.PersonInfoMainPage
  if PersonInfoMainPage then
    PersonInfoMainPage:RebuildDisplayPreviewAfterExternalPreviewClosed()
    local ActorController = PersonInfoMainPage.ActorController
    local SceneService = ActorController and ActorController.SceneService
    if SceneService and SceneService.RefreshUIArtNiagara and ActorController and ActorController.ArmoryHelper then
      ActorController.ArmoryHelper:AddTimer(0.03, function()
        SceneService:NotifyHelperUpdateLighting()
        SceneService:RefreshUIArtNiagara()
      end, false, 0, "RefreshUIArtNiagaraAfterGuildWarRankingClosed", true)
    end
  end
end

local function NormalizeSlotData(Info)
  if type(Info) ~= "table" then
    return Info
  end
  local SlotData = Info.SlotData
  if type(SlotData) ~= "table" then
    return Info
  end
  local needConvert = false
  for _, value in pairs(SlotData) do
    if type(value) ~= "table" then
      needConvert = true
      break
    end
  end
  if not needConvert then
    return Info
  end
  local NewInfo = {}
  for key, value in pairs(Info) do
    NewInfo[key] = value
  end
  local NewSlotData = {}
  for key, value in pairs(SlotData) do
    if type(value) == "table" then
      NewSlotData[key] = value
    elseif type(value) == "number" then
      NewSlotData[key] = {
        SlotId = key,
        Polarity = value,
        ModEid = -1
      }
    end
  end
  NewInfo.SlotData = NewSlotData
  return NewInfo
end

local M = Class({
  "BluePrints.UI.WBP.Activity.PC.GuildWar.WBP_Activity_GuildWar_RankingBase"
})

function M:Construct()
  M.Super.Construct(self)
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "GuildWarHistoryRankOpen", nil)
  if self.List_Ranking.OnCreateEmptyContent then
    self.List_Ranking.OnCreateEmptyContent:Bind(self, function(self)
      local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
      ItemObj.Empty = true
      return ItemObj
    end)
  end
end

function M:InitView()
  self.Text_Time:SetText(GText("RaidDungeon_Rank_Time"))
  self.Text_Name:SetText(GText("RaidDungeon_Rank_Tier"))
  self.Text_Title:SetText(GText("RaidDungeon_Raid_Rank"))
  self.Text_Ranking:SetText(GText("RaidDungeon_Rank"))
  self.Text_Score:SetText(GText("RaidDungeon_Max_Point_Rank"))
  self.Text_Team:SetText(GText("RaidDungeon_Rank_CharList"))
  self:InitCommonTab()
end

function M:Destruct()
  if self.List_Ranking.OnCreateEmptyContent then
    self.List_Ranking.OnCreateEmptyContent:Unbind()
  end
  self:ReleasePreviewScene()
  M.Super.Destruct(self)
end

function M:ReleasePreviewScene()
  local ActorController = self.ActorController
  self.ActorController = nil
  if ActorController then
    ActorController.bClosed = true
    if ActorController.OnClosed_Implementation then
      ActorController:OnClosed_Implementation()
    end
    if ActorController.OnDestruct then
      ActorController:OnDestruct()
    end
    if ActorController.TryDestroyActors then
      ActorController:TryDestroyActors()
    end
  end
  RebuildMainPagePreviewAfterRankingClosed()
end

function M:InitPreviewScene(TopNInfo)
  local WeaponModel
  if GuildWarUtils.IsEmptyTable(TopNInfo) or TopNInfo[1].MaxSquad == nil or TopNInfo[1].MaxSquad == "" then
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = nil,
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
  else
    local DummyAvatar = self:CreateDummyAvatarByRankInfo(TopNInfo[1])
    local _, CharModel = next(DummyAvatar.Chars)
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = CharModel,
      Avatar = DummyAvatar,
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    local _, Weapon = next(DummyAvatar.Weapons)
    WeaponModel = Weapon
  end
  local MainActorController = GetMainPageActorController()
  if MainActorController and MainActorController.SuspendPreviewControl then
    MainActorController:SuspendPreviewControl()
  end
  self.ActorController:OnOpened()
  if WeaponModel then
    self.ActorController:ChangeWeaponModel(WeaponModel)
    local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
end

function M:CreateDummyAvatarByRankInfo(RankInfo)
  if not RankInfo then
    return
  end
  local Squad = SerializeUtils:UnSerialize(RankInfo.MaxSquad)
  if not Squad or GuildWarUtils.IsEmptyTable(Squad) then
    return
  end
  local CharacterInfo = Squad.AvatarInfo and Squad.AvatarInfo.CharacterInfo
  if not CharacterInfo then
    return
  end
  if GuildWarUtils.IsEmptyTable(CharacterInfo.RoleInfo) or GuildWarUtils.IsEmptyTable(CharacterInfo.MeleeWeapon) then
    return
  end
  local RoleInfo = NormalizeSlotData(CharacterInfo.RoleInfo)
  local WeaponInfo = NormalizeSlotData(CharacterInfo.MeleeWeapon)
  local DummyAvatar = {}
  local Params = {
    CharInfos = {RoleInfo},
    WeaponInfos = {WeaponInfo}
  }
  ArmoryUtils._CreateDummyAvatarCustom(DummyAvatar, Params)
  return DummyAvatar
end

function M:SetRankingPlayerPreview(RankInfo)
  if not self.ActorController or not RankInfo then
    return
  end
  local DummyAvatar = self:CreateDummyAvatarByRankInfo(RankInfo)
  if DummyAvatar then
    local _, CharModel = next(DummyAvatar.Chars)
    local _, WeaponModel = next(DummyAvatar.Weapons)
    local Tag = WeaponModel:IsMelee() and "Melee" or "Ranged"
    self.ActorController:SetAvatar(DummyAvatar)
    self.ActorController:ChangeCharModel(CharModel, true)
    self.ActorController:ChangeWeaponModel(WeaponModel)
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
end

function M:InitOnGetTopN(TopNInfo)
  self:InitPreviewScene(TopNInfo)
  self:InitRankInfoTopN(TopNInfo)
end

function M:InitRankInfoTopN(TopNInfo)
  if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
    if self.WS_Type then
      self.WS_Type:SetActiveWidgetIndex(1)
    end
    if self.Text_Empty then
      self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
    end
    return
  end
  if self.WS_Type then
    self.WS_Type:SetActiveWidgetIndex(0)
  end
  self.List_Ranking:ClearListItems()
  local RankCount = 0
  for _, RankInfo in pairs(TopNInfo or {}) do
    RankCount = RankCount + 1
    local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObj.RankInfo = RankInfo
    ItemObj.RoleInfo, ItemObj.PetInfo = self:GetMaxScoreSquad(RankInfo.MaxSquad)
    ItemObj.RankInfo.RankNum = RankCount
    ItemObj.ParentWidget = self
    ItemObj.SelfAvatar = self.Avatar
    self.List_Ranking:AddItem(ItemObj)
  end
  self.List_Ranking:RequestFillEmptyContent()
  self.List_Ranking:NavigateToIndex(0)
  self.ValidItemNum = RankCount
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
  self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end

function M:OnListRankScrolled()
  if not self.LastClickedItem then
    return
  end
end

function M:OnListRankItemClicked(Item)
  if Item.Empty then
    return
  end
  if self.LastClickedItem == Item then
    return
  end
  local ItemWidget = Item.SelfWidget
  if not ItemWidget then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/common/click", nil, nil)
  self:SetRankingPlayerPreview(Item.RankInfo)
  ItemWidget:StopAnimation(ItemWidget.Normal)
  ItemWidget:PlayAnimation(ItemWidget.Click)
  if self.LastClickedItem then
    local LastItemWidget = self.LastClickedItem.SelfWidget
    if LastItemWidget then
      LastItemWidget:StopAnimation(LastItemWidget.Click)
      LastItemWidget:PlayAnimation(LastItemWidget.Normal)
    end
  end
  self.LastClickedItem = Item
end

function M:InitRankInfoSelf(SelfRankInfo)
  if self.Ranking_Myself then
    self.Ranking_Myself:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:OnReturnKeyDown()
  if self:IsAnimationPlaying(self.In) or self.IsClosing then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "GuildWarHistoryRankOpen", {ToEnd = 1})
  self:CloseSelf()
end

return M
