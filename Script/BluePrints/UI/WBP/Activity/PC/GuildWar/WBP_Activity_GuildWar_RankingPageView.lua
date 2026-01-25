require("UnLua")
local ActorController = require("BluePrints.UI.WBP.Armory.ActorController.Armory_ActorController")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")
local GuildWarUtils = require("BluePrints.UI.WBP.Activity.Widget.GuildWar.GuildWarUtils")
local M = Class({})

function M:OnLoaded(...)
  local SelfRankInfo, TopNInfo = ...
  self.IsFirstOpen = true
  self:InitOnGetTopN(TopNInfo)
  self:InitRankInfoSelf(SelfRankInfo)
  self:InitView()
end

function M:Construct()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self.Avatar = GWorld:GetAvatar()
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad and self.LastClickedItem and UIUtils.HasAnyFocus(self) then
    local LastItem = self.LastClickedItem
    self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
  end
end

function M:InitView()
  self.Text_Title:SetText(GText("RaidDungeon_Raid_Rank"))
  self.Text_Ranking:SetText(GText("RaidDungeon_Rank"))
  self.Text_Name:SetText(GText("RaidDungeon_Rank_Name"))
  self.Text_Score:SetText(GText("RaidDungeon_Max_Point_Rank"))
  self.Text_Team:SetText(GText("RaidDungeon_Rank_CharList"))
  self:InitCommonTab()
end

function M:InitOnGetTopN(TopNInfo)
  self:InitPreviewScene(TopNInfo)
  if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
    self.List_Ranking:ClearListItems()
  else
    self:InitRankInfoTopN(TopNInfo)
  end
end

function M:InitPreviewScene(TopNInfo)
  local WeaponModel
  if GuildWarUtils.IsEmptyTable(TopNInfo) or TopNInfo[1].MaxSquad == nil or TopNInfo[1].MaxSquad == "" then
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = self.Avatar.Chars[self.Avatar.CurrentChar],
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    WeaponModel = self.Avatar.Weapons[self.Avatar.MeleeWeapon]
  else
    local DummyAvatar = self:CreateDummyAvatarByRankInfo(TopNInfo[1])
    local _, CharModel = next(DummyAvatar.Chars)
    self.ActorController = ActorController:New({
      ViewUI = self,
      IsPreviewMode = true,
      Char = CharModel,
      EPreviewSceneType = CommonConst.EPreviewSceneType.PreviewCommon
    })
    local _, Weapon = next(DummyAvatar.Weapons)
    WeaponModel = Weapon
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
  local DummyAvatar = {}
  local Params = {
    CharInfos = {
      CharacterInfo.RoleInfo
    },
    WeaponInfos = {
      CharacterInfo.MeleeWeapon
    }
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
    self.ActorController:ChangeCharModel(CharModel)
    self.ActorController:ChangeWeaponModel(WeaponModel)
    self.ActorController:SetMontageAndCamera("Weapon", Tag)
  end
end

function M:InitRankInfoTopN(TopNInfo)
  if not TopNInfo or GuildWarUtils.IsEmptyTable(TopNInfo) then
    self.WS_Type:SetActiveWidget(self.Com_Empty)
    self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
    return
  end
  self.WS_Type:SetActiveWidget(self.List_Ranking)
  self.List_Ranking:ClearListItems()
  local RankCount = 0
  for _, RankInfo in pairs(TopNInfo or {}) do
    if 1 ~= RankInfo.BanState then
      RankCount = RankCount + 1
      local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
      ItemObj.RankInfo = RankInfo
      ItemObj.RoleInfo, ItemObj.PetInfo = self:GetMaxScoreSquad(RankInfo.MaxSquad)
      ItemObj.RankInfo.RankNum = RankCount
      ItemObj.ParentWidget = self
      ItemObj.SelfAvatar = self.Avatar
      self.List_Ranking:AddItem(ItemObj)
      PrintTable(ItemObj.RoleInfo or RankInfo.MaxSquad or "该玩家阵容为空", 2, string.format("看看排行榜第 %d 名的阵容数据：", _))
    end
  end
  self.List_Ranking:NavigateToIndex(0)
  self.ValidItemNum = RankCount
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
  self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
end

function M:InitRankInfoSelf(SelfRankInfo)
  local SeasonId = self.Avatar.CurrentRaidSeasonId
  local RaidSeasons = self.Avatar.RaidSeasons[SeasonId]
  local RankInfo = {}
  SelfRankInfo = SelfRankInfo or {}
  RankInfo.RankNum = SelfRankInfo.Rank and SelfRankInfo.Rank > 0 and SelfRankInfo.Rank or -1
  RankInfo.BanState = RaidSeasons.BanState
  RankInfo.HeadIconId = self.Avatar.HeadIconId
  RankInfo.HeadFrameId = self.Avatar.HeadFrameId
  RankInfo.Level = self.Avatar.Level
  RankInfo.Nickname = self.Avatar.Nickname
  RankInfo.TitleBefore = self.Avatar.TitleBefore
  RankInfo.TitleAfter = self.Avatar.TitleAfter
  RankInfo.TitleFrame = self.Avatar.TitleFrame
  RankInfo.Score = RaidSeasons.MaxRaidScore
  local RoleInfo, PetInfo = self:GetMaxScoreSquad(SelfRankInfo.MaxSquad)
  local ItemData = {
    RankInfo = RankInfo,
    ParentWidget = self,
    RoleInfo = RoleInfo,
    PetInfo = PetInfo
  }
  self.SelfItemData = ItemData
  self.Ranking_Myself:OnListItemObjectSet(ItemData)
  self.Ranking_Myself.Button_Myself.OnPressed:Add(self, self.OnMyselfButtonPressed)
  self.Ranking_Myself.Button_Myself.OnClicked:Add(self, self.OnMyselfButtonClicked)
end

function M:GetMaxScoreSquad(SquadSnapShot)
  if not SquadSnapShot then
    return
  end
  local Squad = SerializeUtils:UnSerialize(SquadSnapShot)
  if not Squad or GuildWarUtils.IsEmptyTable(Squad) then
    return
  end
  local RoleInfo, PetInfo = {}, {}
  if Squad.AvatarInfo then
    local CharacterInfo = Squad.AvatarInfo.CharacterInfo
    if CharacterInfo and CharacterInfo.RoleInfo then
      RoleInfo[1] = {
        id = CharacterInfo.RoleInfo.RoleId,
        level = CharacterInfo.RoleInfo.Level
      }
    end
    local PhantomIndex = 2
    local PhantomInfo1 = Squad.AvatarInfo.PhantomInfo1
    if PhantomInfo1 and PhantomInfo1.RoleInfo then
      RoleInfo[PhantomIndex] = {
        id = PhantomInfo1.RoleInfo.RoleId,
        level = PhantomInfo1.RoleInfo.Level
      }
      PhantomIndex = PhantomIndex + 1
    end
    local PhantomInfo2 = Squad.AvatarInfo.PhantomInfo2
    if PhantomInfo2 and PhantomInfo2.RoleInfo then
      RoleInfo[PhantomIndex] = {
        id = PhantomInfo2.RoleInfo.RoleId,
        level = PhantomInfo2.RoleInfo.Level
      }
    end
  end
  if Squad.CommonCombatInfo then
    PetInfo = {
      id = Squad.CommonCombatInfo.pet_id,
      level = Squad.CommonCombatInfo.pet_level
    }
  end
  return RoleInfo, PetInfo
end

function M:OnMyselfButtonClicked()
  if not self.IsGamePad then
    self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Click)
  end
  local SelfRankNum = self.SelfItemData.RankInfo.RankNum
  if SelfRankNum and SelfRankNum >= 1 then
    if self.LastClickedItem and self.LastClickedItem.RankInfo.RankNum ~= SelfRankNum then
      local LastItemWidget = self.LastClickedItem and self.LastClickedItem.SelfWidget or nil
      if LastItemWidget then
        LastItemWidget:PlayAnimation(LastItemWidget.Normal)
      end
      self.LastClickedItem = nil
    end
    self.List_Ranking:NavigateToIndex(SelfRankNum - 1)
  end
end

function M:OnMyselfButtonPressed()
  self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Press)
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
  if self.IsGamePad then
    return
  end
  if Item.IsSelected or Item.Empty then
    return
  end
  local ItemWidget = Item.SelfWidget
  if not ItemWidget then
    return
  end
  if self.LastClickedItem == Item then
    return
  end
  if IsHovered then
    ItemWidget:StopAnimation(ItemWidget.UnHover)
    ItemWidget:PlayAnimation(ItemWidget.Hover)
  else
    ItemWidget:StopAnimation(ItemWidget.Hover)
    ItemWidget:PlayAnimation(ItemWidget.UnHover)
  end
end

function M:OnListRankScrolled()
  if not self.LastClickedItem then
    return
  end
  local ItemWidget = self.LastClickedItem.SelfWidget
  if not ItemWidget then
    return
  end
  ItemWidget.Head_Anchor:Close()
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
  if not self.IsFirstOpen then
    self:SetRankingPlayerPreview(Item.RankInfo)
  end
  self.IsFirstOpen = nil
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

function M:OnFocusReceived()
  local LastItem = self.LastClickedItem
  if LastItem and LastItem.SelfWidget then
    self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
  end
end

return M
