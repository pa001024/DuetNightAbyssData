require("UnLua")
local M = Class({})

local function IsEmptyTable(T)
  return not T or next(T) == nil
end

function M:OnLoaded(...)
  self.SelfRankInfo, self.TopNInfo, self.RoomData = ...
  self.SelfRankInfo = self.SelfRankInfo or {}
  self.IsFirstOpen = true
  self:InitOnGetTopN(self.TopNInfo)
  self:InitRankInfoSelf(self.SelfRankInfo)
  self:InitView()
  self:RefreshUIBGByRoomBoss()
end

function M:Construct()
  self.GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(self.GameInputModeSubsystem) then
    local CurInputDevice = self.GameInputModeSubsystem:GetCurrentInputType()
    self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
    self.GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
  self.Avatar = GWorld:GetAvatar()
  self.List_Ranking.OnCreateEmptyContent:Bind(self, function()
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Empty = true
    return Content
  end)
end

function M:Destruct()
  if IsValid(self.GameInputModeSubsystem) then
    self.GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  self.IsGamePad = CurInputDevice == ECommonInputType.Gamepad
  if self.IsGamePad and UIUtils.HasAnyFocus(self) then
    if self.LastClickedItem then
      local LastItem = self.LastClickedItem
      self.List_Ranking:NavigateToIndex(LastItem.RankInfo.RankNum - 1)
      local LastItemWidget = LastItem.SelfWidget
      if LastItemWidget then
        LastItemWidget:StopAnimation(LastItemWidget.Normal)
        LastItemWidget:PlayAnimation(LastItemWidget.Click)
      end
    else
      self.List_Ranking:NavigateToIndex(0)
    end
  elseif not self.IsGamePad and self.LastClickedItem then
    local LastItemWidget = self.LastClickedItem.SelfWidget
    if LastItemWidget then
      LastItemWidget:StopAnimation(LastItemWidget.Click)
      LastItemWidget:PlayAnimation(LastItemWidget.Normal)
    end
  end
end

function M:InitView()
  self.Text_Title:SetText(GText("UI_AsyncCombat_ContributionRank"))
  self.Text_Ranking:SetText(GText("UI_AsyncCombat_Rank"))
  self.Text_Name:SetText(GText("RaidDungeon_Rank_Name"))
  self.Text_Score:SetText(GText("UI_AsyncCombat_Contribution"))
  self.Text_Team:SetText(GText("RaidDungeon_Rank_CharList"))
  self:InitCommonTab()
end

function M:GetRoomConfIdForBackground()
  local RoomConfId = not self.RoomData or self.RoomData.RoomConfId or self.RoomData.RoomConfigId or self.RoomData.ConfId
  return RoomConfId and (tonumber(RoomConfId) or RoomConfId) or nil
end

function M:RefreshUIBGByRoomBoss()
  local RoomConfId = self:GetRoomConfIdForBackground()
  if not RoomConfId then
    Utils.ScreenPrint("CoopRank BossBg Refresh Failed, missing RoomConfId", self:GetUIConfigName())
    return
  end
  local AsyncCombatData = DataMgr.AsyncCombat and DataMgr.AsyncCombat[RoomConfId]
  if not AsyncCombatData then
    Utils.ScreenPrint("CoopRank BossBg Refresh Failed, missing AsyncCombatData", self:GetUIConfigName())
    return
  end
  local BossIdList = AsyncCombatData.BossUnitID
  local FinalBossId = BossIdList and BossIdList[#BossIdList]
  if not FinalBossId then
    Utils.ScreenPrint("CoopRank BossBg Refresh Failed, missing FinalBossId", self:GetUIConfigName())
    return
  end
  local BossBgData = DataMgr.AsyncBossBg and DataMgr.AsyncBossBg[FinalBossId]
  local BossBg = BossBgData and BossBgData.MainIcon
  if not BossBg then
    Utils.ScreenPrint("CoopRank BossBg Refresh Failed, missing BossBg", self:GetUIConfigName())
    return
  end
  if self.BossBg and self.BossBg == BossBg then
    return
  end
  local BgRoot = self.Bg
  if not BgRoot then
    Utils.ScreenPrint("CoopRank BossBg Refresh Failed, missing BgRoot", self:GetUIConfigName())
    return
  end
  self.BossBg = BossBg
  local Item = UIManager(self):CreateWidget(BossBg)
  BgRoot:ClearChildren()
  if Item then
    BgRoot:AddChild(Item)
    if Item.Loop then
      Item:PlayAnimation(Item.Loop, 0, 0)
    end
    if Item.Slot then
      if Item.Slot.SetHorizontalAlignment then
        Item.Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
      end
      if Item.Slot.SetVerticalAlignment then
        Item.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
      end
    end
    if Item.In then
      Item:PlayAnimation(Item.In)
    end
  else
    Utils.ScreenPrint("CoopRank BossBg Create Failed", BossBg)
  end
end

function M:InitOnGetTopN(TopNInfo)
  if not TopNInfo or IsEmptyTable(TopNInfo) then
    self.List_Ranking:ClearListItems()
    DebugPrint("联机共斗排行榜，无数据时清空列表", self:GetUIConfigName())
  else
    self:InitRankInfoTopN(TopNInfo)
  end
end

function M:InitRankInfoTopN(TopNInfo)
  if not TopNInfo or IsEmptyTable(TopNInfo) then
    self.WS_Type:SetActiveWidget(self.Com_Empty)
    self.Text_Empty:SetText(GText("RaidDungeon_Rank_Empty"))
    return
  end
  self.WS_Type:SetActiveWidget(self.List_Ranking)
  self.List_Ranking:ClearListItems()
  local RankCount = 0
  for _, RankInfo in pairs(TopNInfo or {}) do
    RankCount = RankCount + 1
    local ItemObj = NewObject(UIUtils.GetCommonItemContentClass())
    ItemObj.RankInfo = RankInfo
    local SquadSnapShot = RankInfo.Squad
    ItemObj.RoleInfo, ItemObj.PetInfo = self:GetMaxScoreSquad(SquadSnapShot)
    ItemObj.RankInfo.RankNum = RankCount
    ItemObj.ParentWidget = self
    ItemObj.SelfAvatar = self.Avatar
    self.List_Ranking:AddItem(ItemObj)
    if RankInfo.Uid == self.Avatar.Uid then
      self.SelfRankInfo.Rank = RankCount
      self.SelfRankInfo.IsMaster = RankInfo.IsMaster
      self.SelfRankInfo.IsMvp = RankInfo.IsMvp
    end
  end
  self.List_Ranking:NavigateToIndex(0)
  self.ValidItemNum = RankCount
  self.List_Ranking.BP_OnItemClicked:Clear()
  self.List_Ranking.BP_OnItemClicked:Add(self, self.OnListRankItemClicked)
  self.List_Ranking.BP_OnItemIsHoveredChanged:Clear()
  self.List_Ranking.BP_OnItemIsHoveredChanged:Add(self, self.OnListRankItemIsHoveredChanged)
  self.List_Ranking.OnListViewScrolled:Add(self, self.OnListRankScrolled)
  self.List_Ranking:RequestFillEmptyContent()
end

function M:InitRankInfoSelf(SelfRankInfo)
  local RankInfo = {}
  SelfRankInfo = SelfRankInfo or {}
  RankInfo.RankNum = SelfRankInfo.Rank and SelfRankInfo.Rank > 0 and SelfRankInfo.Rank or -1
  RankInfo.BanState = SelfRankInfo.BanState
  RankInfo.HeadIconId = SelfRankInfo.HeadIconId or self.Avatar.HeadIconId
  RankInfo.HeadFrameId = SelfRankInfo.HeadFrameId or self.Avatar.HeadFrameId
  RankInfo.Level = SelfRankInfo.Level or self.Avatar.Level
  RankInfo.Nickname = SelfRankInfo.Nickname or self.Avatar.Nickname
  RankInfo.TitleBefore = SelfRankInfo.TitleBefore or self.Avatar.TitleBefore
  RankInfo.TitleAfter = SelfRankInfo.TitleAfter or self.Avatar.TitleAfter
  RankInfo.TitleFrame = SelfRankInfo.TitleFrame or self.Avatar.TitleFrame
  RankInfo.Score = SelfRankInfo.Score or 0
  RankInfo.IsMaster = SelfRankInfo.IsMaster or false
  RankInfo.IsMvp = SelfRankInfo.IsMvp or false
  local SquadSnapShot = SelfRankInfo.Squad
  local RoleInfo, PetInfo = self:GetMaxScoreSquad(SquadSnapShot)
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
  self.Ranking_Myself.Button_Myself.OnHovered:Add(self, self.OnMyselfButtonHovered)
end

function M:GetMaxScoreSquad(SquadSnapShot)
  if not SquadSnapShot then
    return
  end
  local Squad = SquadSnapShot
  if type(SquadSnapShot) == "string" then
    Squad = SerializeUtils:UnSerialize(SquadSnapShot)
  end
  if not Squad or IsEmptyTable(Squad) then
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
  if self.IsGamePad then
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
  if not self.IsGamePad then
    return
  end
end

function M:OnMyselfButtonHovered()
  if not self.IsGamePad then
    return
  end
  self.Ranking_Myself:StopAnimation(self.Ranking_Myself.UnHover)
  self.Ranking_Myself:PlayAnimation(self.Ranking_Myself.Hover)
end

function M:OnListRankItemIsHoveredChanged(Item, IsHovered)
  if self.IsGamePad or Item.IsSelected or Item.Empty then
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
    self.LastClickedItem = Item
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
  if not self.IsGamePad then
    return
  end
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

return M
