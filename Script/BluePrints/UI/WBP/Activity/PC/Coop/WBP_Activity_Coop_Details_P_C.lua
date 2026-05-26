require("UnLua")
local CommonUtils = require("Utils.CommonUtils")
local TimeUtils = require("Utils.TimeUtils")
local EMCache = require("EMCache.EMCache")
local CoopModel = require("BluePrints.UI.WBP.Activity.PC.Coop.Model.CoopModel")
local RoomState = {
  Public = 1,
  Friend = 2,
  Guild = 3,
  Private = 4
}
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  M.bOpened = true
  self.bAsyncCombat = true
  local SystemUIConfig = DataMgr.SystemUI[self.ConfigName or self.WidgetName] or {}
  self.IsChat = SystemUIConfig.IsChat
  self.WeekLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_WeeklyLimit.ConstantValue
  self.EventId = DataMgr.AsyncCombatEventConstant.AsyncCombat_EventId.ConstantValue
  self:AddDispatcher(EventID.OnDisableEscOnDungeonLoading, self, self.DisableEscOnDungeonLoading)
  self:AddDispatcher(EventID.CurrentSquadChange, self, self.OnCurrentSquadChange)
  self:AddInputMethodChangedListen()
  self.BtnCreateBig.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.BtnStartDouble.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.BtnStartDouble.WBP_Com_KeyImg_100:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.BtnRanking.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.BtnShare.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Progress_Box:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
  self.Bg:ClearChildren()
  self.SquadId = 1
  self.MaxMonNum = 2
  self.WalnutId = nil
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  self.Gamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  self.bOpenSquad = true
  self.FocusTypeName = nil
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self.RoomData, self.bInvite = ...
end

function M:Init(RoomData)
  self:SetFocus()
  self:GetRoomData(RoomData)
  self:BackgroundInit()
  self.Title.TextTitle:SetText(GText("UI_AsyncCombat_CombatRoom"))
  self.Title.TextLevel:SetText(GText("UI_LEVEL_NAME") .. DataMgr.AsyncCombat[self.RoomData.RoomConfId].Level)
  self.Title.Tag_Room.TextTag:SetText(GText("UI_AsyncCombat_Host"))
  if self.RoomData.IsMaster then
    self.Title.Tag_Room:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Title.Tag_Room:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.TextReward:SetText(GText("UI_AsyncCombat_MultiTicketBonus"))
  self.TextTimeEnd:SetText(GText("UI_AsyncCombat_ForceEndInTime"))
  self:IconInit()
  self.RoomRate = self.GetNeedNumber(DataMgr.Resource[self.RoomData.RateResId].UseParam / 100)
  self.Tag_Reward.TextNum:SetText("+" .. self.RoomRate .. "%")
  local AnimationName = CoopModel:GetRewardAnimationByDifficultyId(self.RoomData.RateResId)
  self.Tag_Reward:PlayAnimation(self.Tag_Reward[AnimationName])
  local RoomCapacityLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomCapacityLimit.ConstantValue
  self.TextPeopleNum:SetText(self.RoomData.MemberCount .. "/" .. RoomCapacityLimit)
  self.bRoomFull = self.RoomData.MemberCount == RoomCapacityLimit
  self.TextPeopleDetails:SetText(string.format(GText("UI_AsyncCombat_CurrentHostCount"), self.RoomData.MasterCount))
  self.TextProgress:SetText(GText("UI_AsyncCombat_ChallengeProgress"))
  self.TextRemaining:SetText(GText("UI_AsyncCombat_RemainContribution"))
  self.TextMy:SetText(GText("UI_AsyncCombat_MyContribution"))
  self.Tag_Mvp.TextTag:SetText(GText("UI_AsyncCombat_MVP"))
  self:SetProgress()
  if self.RoomData.IsMvp then
    self.Tag_Mvp:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  else
    self.Tag_Mvp:SetVisibility(ESlateVisibility.Collapsed)
  end
  self.TextDebuffName:SetText(GText("AsyncCombatDebuffTitle"))
  self.TextDebuffDetails:SetText(GText("AsyncCombatDebuffDesc"))
  self.BtnShare.TextName:SetText(GText("UI_AsyncCombat_Share"))
  self.BtnShare.Btn.OnClicked:Add(self, self.OnShareBtnClick)
  self.BtnRanking.TextName:SetText(GText("UI_AsyncCombat_Rank"))
  self.BtnRanking.Btn.OnClicked:Add(self, self.OnRankingBtnClick)
  self:RefreshBtnState()
  self:StartBtnInit()
  self:AttributesInit()
  self.TextRewardTitle:SetText(GText("UI_AsyncCombat_RewardPreview"))
  self:RewardListInit()
  self.List:DisableScroll(true)
  local bSquad = true
  if bSquad then
    self.DefaultList:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local DungeonType = DataMgr.Dungeon[self.DungeonId].DungeonType
    local bDisablePhantom = "Rouge" == DungeonType or false
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      local SquadId = Avatar.DungeonSquad[DungeonType] and Avatar.DungeonSquad[DungeonType] or 0
      self.DefaultList:Init(self, bDisablePhantom, SquadId, self.DungeonId)
    end
  else
    self.DefaultList:SetVisibility(ESlateVisibility.Collapsed)
  end
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.RoomExpireTime)
  self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
  self.RoomExpireTimer = self:AddTimer(1.0, self.UpdateRoomExpireCountDown, true, 0, "UpdateCoop_RoomExpire", true)
  self.RoomInfoUpdateTimer = self:AddTimer(5.0, self.UpdateRoomInfo, true, 0, "UpdateCoop_RoomInfo", true)
  self:UpdatKeyDisplay("SelfWidget")
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_level_select_page_in", nil, nil)
end

function M:IconInit()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  local ResourceID = DataMgr.AsyncCombat[self.RoomData.RoomConfId].ID
  local ResourceData = DataMgr.Resource[ResourceID]
  Content.Id = ResourceID
  Content.Icon = ResourceData.Icon
  Content.ItemType = "Resource"
  Content.UIName = ResourceData.ResourceName
  Content.Rarity = ResourceData.Rarity
  Content.IsShowDetails = true
  Content.ParentWidget = self
  self.Icon.WBP_Com_ItemIcon:Init(Content)
  local QualityName = "Color_0"
  self.Icon.Img_Quality:SetBrush(self.Icon[QualityName .. ResourceData.Rarity - 1])
  self.Icon.Panel_ItemNum:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.Icon.Btn.OnClicked:Add(self, function()
    self.Icon.WBP_Com_ItemIcon:OnMouseButtonUp()
  end)
end

function M:AttributesInit()
  self.RoomPermission = {}
  for key, value in pairs(self.RoomData.Permission) do
    if type(value) == "number" and value > 0 then
      self.RoomPermission[value] = true
    end
  end
  local StateNum = 0
  local Permission = CommonConst.AsyncCombatRoomPermission
  self.DetailsTag01:SetVisibility(ESlateVisibility.Collapsed)
  self.DetailsTag02:SetVisibility(ESlateVisibility.Collapsed)
  self.TextTime:SetVisibility(ESlateVisibility.Collapsed)
  self.WBP_Time:SetVisibility(ESlateVisibility.Collapsed)
  if self.RoomPermission[Permission.Public] then
    self.DetailsTag01.TextBlock_191:SetText(GText("UI_AsyncCombat_Public"))
    self.DetailsTag01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    return
  end
  if self.RoomPermission[Permission.FriendVisible] then
    self.DetailsTag01.TextBlock_191:SetText(GText("UI_AsyncCombat_FriendsOnly"))
    self.DetailsTag01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    StateNum = StateNum + 1
  end
  if self.RoomPermission[Permission.GuildVisible] then
    if 0 == StateNum then
      self.DetailsTag01.TextBlock_191:SetText(GText("UI_AsyncCombat_GuildMembersOnly"))
      self.DetailsTag01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    else
      self.DetailsTag02.TextBlock_191:SetText(GText("UI_AsyncCombat_GuildMembersOnly"))
      self.DetailsTag02:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  end
  if self.RoomPermission[Permission.InviteOnly] then
    self.DetailsTag01.TextBlock_191:SetText(GText("UI_AsyncCombat_InviteOnly"))
    self.DetailsTag01:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.TextTime:SetText(GText("UI_AsyncCombat_ToPublicInTime"))
    self.TextTime:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.WBP_Time:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.RoomToOpenTime)
    self.WBP_Time:SetTimeText("", RemainTimeDict)
    self.RoomToOpenTimer = self:AddTimer(1.0, self.UpdateRoomToOpenCountDown, true, 0, "UpdateCoop_RoomToOpen", true)
  end
end

function M:RewardListInit()
  self.List:ClearListItems()
  local RoomMult = self.GetNeedNumber(self.RoomRate / 100)
  local RoomConfig = DataMgr.AsyncCombat[self.RoomData.RoomConfId]
  local ResourceID = RoomConfig.ID
  local ResourceCount = RoomConfig.Count
  local ResourceData = DataMgr.Resource[ResourceID]
  local ResourceIcon = ResourceData.Icon
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  local AsyncCombatConst = DataMgr.AsyncCombatEventConstant
  local BaseContributionRequire = self.GetNeedNumber(AsyncCombatConst.AsyncCombat_BaseContributionRequire.ConstantValue / 100)
  local BaseContributionReward = self.GetNeedNumber(AsyncCombatConst.AsyncCombat_BaseContributionReward.ConstantValue / 100)
  local MVPRewardPerHomeOwner = self.GetNeedNumber(AsyncCombatConst.AsyncCombat_MVPRewardPerHomeOwner.ConstantValue / 100)
  local MVPContributionReward = self.GetNeedNumber(AsyncCombatConst.AsyncCombat_MVPContributionReward.ConstantValue / 100)
  Content.RewardText = "UI_AsyncCombat_ContributionBonus"
  Content.RewardTip = string.format(GText("UI_AsyncCombat_ContributionRequirement"), math.floor(BaseContributionRequire))
  Content.bChoose = self.MyContribution and BaseContributionRequire < self.MyContribution and not self.RoomData.IsMaster
  Content.Rate = BaseContributionReward
  Content.Count = math.floor(ResourceCount * RoomMult * (BaseContributionReward / 100))
  Content.ResourceIcon = ResourceIcon
  self.list:AddItem(Content)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  Content.RewardText = "UI_AsyncCombat_HostBonus"
  Content.RewardTip = "UI_AsyncCombat_HostRewardTip"
  Content.bChoose = self.RoomData.IsMaster
  Content.Rate = 100
  Content.Count = math.floor(ResourceCount * RoomMult)
  Content.ResourceIcon = ResourceIcon
  self.list:AddItem(Content)
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  local ExrtraRate = MVPRewardPerHomeOwner * self.RoomData.MasterCount
  Content.RewardText = "UI_AsyncCombat_MVPBonus"
  Content.RewardTip = string.format(GText("UI_AsyncCombat_HostBonusIncrease"), math.floor(MVPRewardPerHomeOwner))
  Content.bChoose = self.RoomData.IsMvp
  Content.Rate = MVPContributionReward
  Content.Count = math.floor(ResourceCount * RoomMult * (ExrtraRate + MVPContributionReward) / 100)
  Content.ResourceIcon = ResourceIcon
  Content.ExtraRate = ExrtraRate
  self.list:AddItem(Content)
end

function M:StartBtnInit()
  self.BtnCreateBig:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnCreateBig.TextContent:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnCreateBig.Btn.OnClicked:Add(self, self.OnStartBtnClick)
  self.BtnCreateBig.Cd_Node:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnStartDouble:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnStartDouble.BtnRight.OnClicked:Add(self, self.OnStartBtnClick)
  self.BtnStartDouble.BtnLeft.OnClicked:Add(self, self.OnBeHostBtnClick)
  local Avatar = GWorld:GetAvatar()
  local Uid
  if Avatar then
    Uid = Avatar.Uid
  end
  local CreateRoomTimes = 0
  if Avatar.AsyncCombats[self.EventId] then
    CreateRoomTimes = Avatar.AsyncCombats[self.EventId].CreateRoomTimes
  end
  local RemainTimes = self.WeekLimit - CreateRoomTimes
  self.bNoCreateTimes = 0 == RemainTimes
  self.BtnStartDouble.BtnLeft:SetForbidden(self.bNoCreateTimes)
  if self.IsMember or self.RoomData.IsMaster then
    self.BtnCreateBig:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    if self.CanEnterRoomTime > TimeUtils.NowTime() then
      self.BtnCreateBig.Btn:SetForbidden(true)
      self.BtnCreateBig.Cd_Node:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
      self.BtnCreateBig.TextStart:SetVisibility(ESlateVisibility.Collapsed)
      local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.CanEnterRoomTime)
      self.BtnCreateBig.WBP_Time:SetTimeText("", RemainTimeDict)
      self.EnterRoomTimer = self:AddTimer(1.0, self.UpdateEnterRoomCountDown, true, 0, "UpdateCoop_EnterRoom", true)
    else
      self.BtnCreateBig.Btn:SetForbidden(false)
      self.BtnCreateBig.TextStart:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    end
  else
    self.BtnStartDouble:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  end
  local CreateRoomTimes = 0
  if Avatar then
    local AsyncCombats = Avatar.AsyncCombats
    CreateRoomTimes = AsyncCombats[self.EventId].CreateRoomTimes
  end
  self.BtnCreateBig.TextCd:SetText(GText("UI_AsyncCombat_CoolDown"))
  self.BtnCreateBig.TextStart:SetText(GText("UI_AsyncCombat_GoToChallenge"))
  self.BtnStartDouble.TextLeft:SetText(GText("UI_AsyncCombat_BecomeHost"))
  self.BtnStartDouble.TextRight:SetText(GText("UI_AsyncCombat_JoinChallenge"))
  self.BtnStartDouble.TextWeek:SetText(GText("UI_AsyncCombat_WeeklyRemain"))
  local RemainTimes = self.WeekLimit - CreateRoomTimes
  local WeekTimeText = ""
  if 0 == RemainTimes then
    WeekTimeText = string.format("<Highlight>%d</>/%d", RemainTimes, self.WeekLimit)
  else
    WeekTimeText = string.format("%d/%d", RemainTimes, self.WeekLimit)
  end
  self.BtnStartDouble.TextNum:SetText(WeekTimeText)
end

function M:BackgroundInit()
  local DungeonData = DataMgr.Dungeon[self.DungeonId]
  local BossIdList = DataMgr.AsyncCombat[self.RoomData.RoomConfId].BossUnitID
  local FinalBossId = BossIdList[#BossIdList]
  local BossBg
  if DataMgr.AsyncBossBg then
    if DataMgr.AsyncBossBg[FinalBossId] then
      BossBg = DataMgr.AsyncBossBg[FinalBossId].MainIcon
    else
      DebugPrint("crk@AsyncBossBg未配表，BossId", FinalBossId)
      local ChildrenCount = self.Bg:GetChildrenCount()
      local OldItem = ChildrenCount > 0 and self.Bg:GetChildAt(0) or nil
      if OldItem and OldItem:IsValid() then
        OldItem:StopAllAnimations()
        OldItem:PlayAnimation(OldItem.In)
      end
      return
    end
  end
  if not BossBg then
    return
  end
  if self.BossBg and self.BossBg == BossBg then
    return
  end
  self.BossBg = BossBg
  self.BgItem = UIManager(self):CreateWidget(BossBg)
  local ChildrenCount = self.Bg:GetChildrenCount()
  local Item = self.BgItem
  self.Bg:ClearChildren()
  if Item then
    self.Bg:AddChild(Item)
    Item:UnbindAllFromAnimationFinished(Item.In)
    Item:BindToAnimationFinished(Item.In, {
      self,
      function()
        Item:PlayAnimation(Item.Loop)
      end
    })
    Item:StopAllAnimations()
    Item:PlayAnimation(Item.In)
    Item.Slot:SetHorizontalAlignment(EHorizontalAlignment.HAlign_Fill)
    Item.Slot:SetVerticalAlignment(EVerticalAlignment.VAlign_Fill)
  else
    DebugPrint("crk AsyncCoopBg Create Failed")
  end
end

function M:InitPageTab()
  local PopupInfoHotKey = "SpecialRight"
  local TabConfigData = {
    DynamicNode = {"Back", "BottomKey"},
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_CheckDetails")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.OnReturnKeyDown,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    OwnerPanel = self,
    BackCallback = self.OnReturnKeyDown,
    StyleName = "Text",
    TitleName = GText("UI_AsyncCombat_CombatRoom"),
    PopupInfoHotKey = "SpecialLeft",
    InfoCallback = self.OnClickInfoCallBack,
    GetReplyOnBack = function()
      return UWidgetBlueprintLibrary.SetUserFocus(UWidgetBlueprintLibrary.Handled(), self)
    end
  }
  self.WBP_Com_Tab:Init(TabConfigData, true)
  local PopupInfoHotKeyImg = UIConst.GamePadImgKey[PopupInfoHotKey] or "Menu"
  if not self.Mobile then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:InitGamePadTip({
      KeyInfo = {
        KeyInfoList = {
          {Type = "Img", ImgShortPath = PopupInfoHotKeyImg}
        },
        Desc = GText("UI_GACHA_DESDETAIL"),
        bAllowForbid = true
      },
      ClickFuncObj = self,
      ClickFunc = self.OnClickInfoCallBack,
      bNeedLongPressInfo = true
    })
  end
  local WeekLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_WeeklyLimit.ConstantValue
  local CurrentNum = WeekLimit - CoopModel:AsyncCombatGetPlayerInfo()
  local CurrentJoinRoomNum, LimitNum = CoopModel:AsyncCombatGetGoingRoomNum()
  local NumText = string.format(": %d/%d", CurrentJoinRoomNum, LimitNum)
  self:RefreshGoingRoomNum()
end

function M:RefreshGoingRoomNum()
  local CurrentNum = self.WeekLimit - CoopModel:AsyncCombatGetPlayerInfo()
  local CurrentJoinRoomNum, LimitNum = CoopModel:AsyncCombatGetGoingRoomNum()
  local NumText = string.format(": %d/%d", CurrentJoinRoomNum, LimitNum)
  self.JoinRoomLimit = false
  if CurrentJoinRoomNum == LimitNum then
    self.JoinRoomLimit = true
    NumText = string.format(GText(": <Highlight>%d</>/%d"), CurrentJoinRoomNum, LimitNum)
  end
  if self.Mobile then
    local SubTitle = UIManager(self):_CreateWidgetNew("AsyncCoopSubTitle")
    SubTitle.TextSubtitle:SetText(GText("UI_AsyncCombat_JoinLimit") .. NumText)
    if self.WBP_Com_Tab.Pos_Subtitle then
      self.WBP_Com_Tab.Pos_Subtitle:ClearChildren()
      self.WBP_Com_Tab.Pos_Subtitle:AddChildToOverlay(SubTitle)
    end
  else
    self.WBP_Com_Tab.Text_Gift_Shop_TabTips:SetText(GText("UI_AsyncCombat_JoinLimit") .. NumText)
    self.WBP_Com_Tab.Text_Gift_Shop_TabTips:SetVisibility(ESlateVisibility.HitTestInvisible)
  end
end

function M:GetRoomData(RoomData)
  if RoomData then
    self.RoomData = RoomData
  end
  self.DungeonId = DataMgr.AsyncCombat[self.RoomData.RoomConfId].DungeonID
  local AsyncCombatConst = DataMgr.AsyncCombatEventConstant
  self.TotleDamage = 0
  self.IsMember = false
  self.IsCreator = false
  self.LastMvp = self.RoomData.IsMvp
  self.RoomExpireTime = self.RoomData.CreateTime + AsyncCombatConst.AsyncCombat_RoomDuration.ConstantValue * 60
  self.RoomPermission = {}
  for key, value in pairs(self.RoomData.Permission) do
    if type(value) == "number" and value > 0 then
      self.RoomPermission[value] = true
    end
  end
  if self.RoomPermission[CommonConst.AsyncCombatRoomPermission.InviteOnly] then
    self.RoomToOpenTime = self.RoomData.CreateTime + AsyncCombatConst.AsyncCombat_MakePublicTime.ConstantValue * 60
  end
  if self.RoomData.EnterRoomCD and self.RoomData.EnterRoomCD > TimeUtils.NowTime() then
    self.bCanEnterDungeon = false
    self.CanEnterRoomTime = self.RoomData.EnterRoomCD
  else
    self.bCanEnterDungeon = true
    self.CanEnterRoomTime = 0
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self.IsCreator = Avatar.Uid == self.RoomData.CreatorUid
  end
  if not self.RoomData.MemberDamageList then
    return
  end
  for key, value in pairs(self.RoomData.MemberDamageList) do
    self.TotleDamage = self.TotleDamage + value.Damage
    if Avatar and Avatar.Uid == value.Uid then
      self.IsMember = true
    end
  end
end

function M:RefreshBtnState()
  self.bJumpRank = self.IsCreator or self.IsMember or self.RoomData.IsMaster
  self.bJumpShare = false
  local Permission = CommonConst.AsyncCombatRoomPermission
  if self.RoomPermission[Permission.Public] and self.IsMember then
    self.bJumpShare = true
  else
    self.bJumpShare = self.IsCreator
  end
  self.BtnRanking.Btn:SetForbidden(not self.bJumpRank)
  self.BtnShare.Btn:SetForbidden(not self.bJumpShare)
end

function M:RefreshStartBtnState()
  if self.IsComMissing then
    self.BtnCreateBig.Btn:SetForbidden(true)
    return
  end
  if not self.bCanEnterDungeon then
    self.BtnCreateBig.Btn:SetForbidden(true)
    return
  end
  self.BtnCreateBig.Btn:SetForbidden(false)
end

function M:Destruct()
  M.Super.Destruct(self)
  M.bOpened = false
  self.BtnRanking.Btn.OnClicked:Clear()
  self.BtnShare.Btn.OnClicked:Clear()
  if self:IsExistTimer(self.RoomExpireTimer) then
    self:RemoveTimer(self.RoomExpireTimer)
  end
  if self:IsExistTimer(self.RoomToOpenTimer) then
    self:RemoveTimer(self.RoomToOpenTimer)
  end
  if self:IsExistTimer(self.RoomInfoUpdateTimer) then
    self:RemoveTimer(self.RoomInfoUpdateTimer)
  end
end

function M:UpdateRoomToOpenCountDown()
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.RoomToOpenTime)
  self.WBP_Time:SetTimeText("", RemainTimeDict)
  if 0 == TimeCount then
    self:OnRoomToOpenCountDownEnd()
  end
end

function M:UpdateRoomExpireCountDown()
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.RoomExpireTime)
  self.WBP_Com_Time:SetTimeText("", RemainTimeDict)
  if 0 == TimeCount then
    self:OnRoomExpireCountDownEnd()
  end
end

function M:UpdateEnterRoomCountDown()
  local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(self.CanEnterRoomTime)
  self.BtnCreateBig.WBP_Time:SetTimeText("", RemainTimeDict)
  if 0 == TimeCount then
    self:OnEnterRoomCountDownEnd()
  end
end

function M:UpdateRoomInfo()
  if self.IsRoomExpire then
    return
  end
  CoopModel:AsyncGetMemberRoomInfo(function(Err, RoomData)
    if RoomData then
      self.RoomData = RoomData
      self:OnRoomInfoChange()
    end
  end, self.RoomData.RoomUniqueId)
end

function M:OnRoomToOpenCountDownEnd()
  if self:IsExistTimer(self.RoomToOpenTimer) then
    self:RemoveTimer(self.RoomToOpenTimer)
  end
  self.RoomPermission[CommonConst.AsyncCombatRoomPermission.Public] = true
  self:AttributesInit()
end

function M:OnRoomExpireCountDownEnd()
  if self:IsExistTimer(self.RoomExpireTimer) then
    self:RemoveTimer(self.RoomExpireTimer)
  end
  self.IsRoomExpire = true
  if self:IsExistTimer(self.RoomInfoUpdateTimer) then
    self:RemoveTimer(self.RoomInfoUpdateTimer)
  end
end

function M:OnEnterRoomCountDownEnd()
  if self:IsExistTimer(self.EnterRoomTimer) then
    self:RemoveTimer(self.EnterRoomTimer)
  end
  self.BtnCreateBig.Btn:SetForbidden(false)
  self.BtnCreateBig.Cd_Node:SetVisibility(ESlateVisibility.Collapsed)
  self.BtnCreateBig.TextStart:SetVisibility(ESlateVisibility.HitTestInvisible)
  self.bCanEnterDungeon = true
end

function M:OnRankingBtnClick()
  DebugPrint("@crk OnRankingBtnClick")
  if not self.bJumpRank then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_CannotShareToast"))
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_common_click", nil, nil)
  CoopModel:AsyncCombatGetRoomRankData(self.RoomData, function(SelfRankInfo, TopNInfo, RankingRoomData)
    if not self then
      return
    end
    UIManager(self):LoadUINew("CoopRank", SelfRankInfo, TopNInfo, RankingRoomData)
  end)
end

function M:OnShareBtnClick()
  DebugPrint("@crk OnShareBtnClick")
  if not self.bJumpShare then
    if self.IsMember then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomPrivateShare"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_CannotShareToast"))
    end
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_common_click", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Params = {
    TabConfigData = {
      LeftKey = "Q",
      RightKey = "E",
      Tabs = {
        {
          Text = GText("UI_AsyncCombat_FriendsChannel"),
          TabId = 1,
          ShowRedDot = false
        },
        {
          Text = GText("UI_AsyncCombat_Channel"),
          TabId = 2,
          ShowRedDot = false
        }
      },
      LeftGamePadKey = "LeftShoulder",
      RightGamePadKey = "RightShoulder"
    },
    RoomData = self.RoomData,
    ShareCallbackObj = self,
    ShareCallback = self.ShareCallback
  }
  UIManager(self):ShowCommonPopupUI(100349, Params, self)
end

function M:OnBeHostBtnClick()
  if self.bNoCreateTimes then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_HostLimitExceeded"))
    return
  end
  AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_large_confirm_click", nil, nil)
  
  local function Callback(Err)
    if Err == ErrorCode.RET_SUCCESS then
      self:RefreshHostInfo()
    elseif Err == ErrorCode.RET_ASYNCCOMBAT_RATERES_NOT_ENOUGH then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ManualInsufficient"))
    elseif Err == ErrorCode.RET_ASYNCCOMBAT_OWNED_COUNT_LIMIT then
      local CurrentJoinRoomNum, LimitNum = CoopModel:AsyncCombatGetGoingRoomNum()
      self.JoinRoomLimit = CurrentJoinRoomNum == LimitNum
      if not self.JoinRoomLimit then
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomFull"))
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_MaxRoomsReached"))
      end
    elseif Err == ErrorCode.RET_ASYNCCOMBAT_CANT_FIND_ROOM then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomEndedRefresh"))
    elseif Err == ErrorCode.RET_ASYNCCOMBAT_NO_ROOM_ACCESS then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomPrivateShare"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ConditionNotMet"))
    end
  end
  
  local Params = {}
  local CreateRoomTimes = 0
  local Avatar = GWorld:GetAvatar()
  Params.ItemList = {}
  local ItemCount = 0
  if Avatar and Avatar.Resources[self.RoomData.RateResId] and Avatar.AsyncCombats[self.EventId] then
    ItemCount = Avatar.Resources[self.RoomData.RateResId].Count
    CreateRoomTimes = Avatar.AsyncCombats[self.EventId].CreateRoomTimes
  end
  table.insert(Params.ItemList, {
    ItemId = self.RoomData.RateResId,
    ItemType = CommonConst.ItemType.Resource,
    ItemNum = ItemCount or 0,
    ItemNeed = 1
  })
  Params.ShortTextParams = {
    GText(DataMgr.Resource[self.RoomData.RateResId].ResourceName)
  }
  local RemainTimes = self.WeekLimit - CreateRoomTimes
  local WeekTimeText = string.format(": %d", RemainTimes)
  Params.Tips = {
    GText("UI_AsyncCombat_WeeklyRemain") .. WeekTimeText
  }
  Params.ForbidRightBtn = 0 == ItemCount
  
  function Params.ForbiddenRightCallbackFunction()
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ManualInsufficient"))
  end
  
  function Params.RightCallbackFunction()
    local Avatar = GWorld:GetAvatar()
    if not Avatar then
      return
    end
    CoopModel:AsyncCombatJoinRoom(self.RoomData.RoomUniqueId, true, self.bInvite, Callback)
  end
  
  UIManager(self):ShowCommonPopupUI(100351, Params, self)
end

function M:RefreshHostInfo()
  self.Title.Tag_Room:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.RoomData.IsMaster = true
  self.IsMember = true
  self.bJumpRank = true
  self.BtnRanking.Btn:SetForbidden(not self.bJumpRank)
  self.RoomData.MasterCount = self.RoomData.MasterCount + 1
  self.RoomData.MemberCount = self.RoomData.MemberCount + 1
  self:RewardListInit()
  self:StartBtnInit()
  local Hall = UIManager(self):GetUIObj("AsyncCombat")
  if Hall then
    Hall:RefreshPlayerInfo()
  end
  self:RefreshGoingRoomNum()
  local RoomCapacityLimit = DataMgr.AsyncCombatEventConstant.AsyncCombat_RoomCapacityLimit.ConstantValue
  self.TextPeopleNum:SetText(self.RoomData.MemberCount .. "/" .. RoomCapacityLimit)
  self.bRoomFull = self.RoomData.MemberCount == RoomCapacityLimit
  self.TextPeopleDetails:SetText(string.format(GText("UI_AsyncCombat_CurrentHostCount"), self.RoomData.MasterCount))
end

function M:OnStartBtnClick()
  if self.IsComMissing then
    self:OnForbiddenStartBtnClicked()
  end
  if self.bCanEnterDungeon then
    AudioManager(self):PlayUISound(self, "event:/ui/activity/lianmeiyanyi_btn_large_confirm_click", nil, nil)
    if self.IsMember or self.IsCreator or self.RoomData.IsMaster then
      self:EnterStandalone()
    else
      self:BlockAllUIInput(true, "AsyncCombatJoinRoom")
      self:TryJoinRoom()
    end
  end
end

function M:OnClickInfoCallBack()
  local SystemUIConfig = DataMgr.SystemUI[self:GetUIConfigName()]
  UIManager(self):ShowCommonPopupUI(SystemUIConfig.PopupInfoId)
end

function M:TryJoinRoom()
  CoopModel:AsyncCombatJoinRoom(self.RoomData.RoomUniqueId, false, self.bInvite, function(Err, ...)
    self:BlockAllUIInput(false, "AsyncCombatJoinRoom")
    local bRetCode = self:HandleJoinRoomRetCode(Err, ...)
    if bRetCode then
      local Hall = UIManager(self):GetUIObj("AsyncCombat")
      if Hall then
        Hall:RefreshPlayerInfo()
      end
      self:EnterStandalone()
    end
  end)
end

function M:EnterStandalone()
  local ActivityMain = UIManager(self):GetUIObj("ActivityMain")
  local CurTabIndex = 1
  if ActivityMain then
    CurTabIndex = ActivityMain.CurTabId
  end
  local ExitDungeonInfo = {
    Type = "AsyncCombat",
    CurTabIndex = CurTabIndex
  }
  GWorld.GameInstance:SetExitDungeonData(ExitDungeonInfo)
  AudioManager(self):PlayUISound(self, "event:/ui/common/map_click_enter_level", nil, nil)
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    self:TryEnterDungeon(Avatar, self.DungeonId, function(RetCode, ...)
      local bRetCode = self:HandleEnterDungeonRetCode(RetCode, ...)
      if not bRetCode then
        self:PlayAnimation(self.In)
      end
    end, nil)
  else
    WorldTravelSubsystem(self):ChangeDungeonByDungeonId(self.DungeonId, CommonConst.DungeonNetMode.Standalone)
  end
end

function M:TryEnterDungeon(Avatar, DungeonId, OtherCallback)
  local Params = {
    RoomUniId = self.RoomData.RoomUniqueId,
    EventId = self.EventId
  }
  if self.DefaultList:GetVisibility() == ESlateVisibility.Collapsed then
    Avatar:EnterEventDungeon(OtherCallback, DungeonId, nil, self.EventId, Params)
  else
    Avatar:EnterEventDungeon(OtherCallback, DungeonId, self.SquadId, self.EventId, Params)
  end
end

function M:HandleJoinRoomRetCode(RetCode, ...)
  if RetCode == ErrorCode.RET_SUCCESS then
    return true
  elseif RetCode == ErrorCode.RET_ASYNCCOMBAT_CANT_FIND_ROOM then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomEndedRefresh"))
    return false
  elseif RetCode == ErrorCode.RET_ASYNCCOMBAT_OWNED_COUNT_LIMIT then
    local CurrentJoinRoomNum, LimitNum = CoopModel:AsyncCombatGetGoingRoomNum()
    self.JoinRoomLimit = CurrentJoinRoomNum == LimitNum
    if not self.JoinRoomLimit then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomFull"))
    else
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_MaxRoomsReached"))
    end
    return false
  elseif RetCode == ErrorCode.RET_ASYNCCOMBAT_NO_ROOM_ACCESS then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ConditionNotMet"))
    return false
  else
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_ConditionNotMet"))
    return false
  end
  return false
end

function M:HandleEnterDungeonRetCode(RetCode, ...)
  if RetCode == ErrorCode.RET_SUCCESS then
    return true
  elseif RetCode == ErrorCode.RET_ASYNCCOMBAT_DUNGEON_ROOM_CLOSED then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomEndedRefresh"))
    return false
  elseif RetCode == ErrorCode.RET_ASYNCCOMBAT_PLAYER_ENTER_DUNGEON_CD then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_AsyncCombat_RoomCoolDownRetry"))
    return false
  end
end

function M:OnReturnKeyDown()
  AudioManager(self):SetEventSoundParam(self, "Play_DeputeDetail", {ToEnd = 1})
  if self.IsChat then
    EventManager:FireEvent(EventID.InterruptChatView)
  end
  if not self.Mobile then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipReleased()
  end
  if not self:IsAnimationPlaying(self.Auto_Out) and not self:IsAnimationPlaying(self.Auto_In) then
    if self.bNeedRefreshHallList then
      local Hall = UIManager(self):GetUIObj("AsyncCombat")
      if Hall then
        Hall:ResetRoomListData()
        Hall:RefreshList()
        Hall:RefreshPlayerInfo()
      end
    end
    self:PlayAnimation(self.Auto_Out)
    self:Close()
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  if self.Mobile then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadDown(InKeyName)
  elseif "Escape" == InKeyName then
    IsEventHandled = true
    if self.DisableEsc and self.DisableEsc == true then
      return UWidgetBlueprintLibrary.Handled()
    end
    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
      self.DefaultList:OnCloseSquadGamepad()
    else
      self:OnReturnKeyDown()
    end
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnKeyUp(MyGeometry, InKeyEvent)
  if self.Mobile then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:OnGamePadUp(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnRoomInfoChange()
  if self.LastMvp ~= self.RoomData.IsMvp then
    self.LastMvp = self.RoomData.IsMvp
    if self.LastMvp then
      self.Tag_Mvp:SetVisibility(ESlateVisibility.HitTestInvisible)
    else
      self.Tag_Mvp:SetVisibility(ESlateVisibility.Collapsed)
    end
    self:RewardListInit()
  end
  self:SetProgress()
  self:AttributesInit()
end

function M:ItemMenuAnchorChanged(bIsOpen)
  if UIUtils.UtilsGetCurrentInputType() ~= ECommonInputType.Gamepad then
    return
  end
  self:UpdatKeyDisplay("SelfWidget")
end

function M:UpdatKeyDisplay(FocusTypeName)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return
  end
  if "MenuAnchor" == FocusTypeName then
    local BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            Owner = self
          }
        },
        Desc = GText("UI_CTL_CloseTips"),
        bLongPress = false
      }
    }
    self.WBP_Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  elseif "SelfWidget" == FocusTypeName then
    self.bTipOpen = false
    local BottomKeyInfo = {}
    if UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_82) then
      table.insert(BottomKeyInfo, {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "RV",
            Owner = self
          }
        },
        Desc = GText("UI_Controller_Slide")
      })
    end
    table.insert(BottomKeyInfo, {
      KeyInfoList = {
        {
          Type = "Text",
          Text = "Esc",
          ClickCallback = self.OnReturnKeyDown,
          Owner = self
        }
      },
      GamePadInfoList = {
        {
          Type = "Img",
          ImgShortPath = "B",
          Owner = self
        }
      },
      Desc = GText("UI_BACK")
    })
    self.WBP_Com_Tab:UpdateBottomKeyInfo(BottomKeyInfo)
    self:UpdateUIStyleInPlatform(true)
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      self:UpdateUIStyleInPlatform(false)
      self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.DefaultList:InitWidgetInfoInGamePad()
    end
  else
    local BottomKeyInfo = {}
    self.WBP_Com_Tab:UpdateOtherPageTab(BottomKeyInfo)
    self:UpdateUIStyleInPlatform(true)
    self.WBP_Com_Tab.ComTab.WBP_Com_Tab_ResourceBar.Tip_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.Tab_Info:UpdateUIStyleInPlatform(false)
  end
end

function M.GetNeedNumber(x)
  local first_decimal = math.floor(x * 10) % 10
  if 0 == first_decimal then
    return math.floor(x)
  else
    return math.floor(x * 10) / 10
  end
end

function M:SetProgress()
  local CurProgress = self.RoomData.Progress
  local CurProgressStr = CommonUtils.FormatNumInFrench(tostring(CurProgress))
  self.TextProgressNum:SetText(CurProgressStr .. "%")
  self.Bar_Progress:SetPercent(CurProgress / 100)
  local RemainContribution = 100 - CurProgress
  local RemainContributionStr = CommonUtils.FormatNumInFrench(tostring(RemainContribution))
  self.TextRemainingNum:SetText(RemainContributionStr .. "%")
  self.MyContribution = math.floor(self.RoomData.Damage * 1000 / self.RoomData.TotalHp) / 10
  local MyContributionStr = CommonUtils.FormatNumInFrench(tostring(self.MyContribution))
  self.TextMyNum:SetText(MyContributionStr .. "%")
end

function M:ShareCallback(bShareClick)
  if bShareClick then
    self:UpdateRoomInfo()
  end
end

function M:DisableEscOnDungeonLoading()
  self.DisableEsc = true
end

function M:SelectCellFocus()
  self:UpdatKeyDisplay("SelfWidget")
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  if self.IsChat then
    EventManager:FireEvent(EventID.InterruptChatView)
  end
  if not self.Mobile then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipReleased()
  end
  return UIUtils.Handled
end

function M:ReceiveEnterState(StackAction)
  self.Super.ReceiveEnterState(self, StackAction)
  EventManager:FireEvent(EventID.GuilfWarLevelSelectReceiveEnterState, StackAction)
end

function M:OnGamePadDown(InKeyName)
  local IsEventHandled = false
  if "Gamepad_FaceButton_Right" == InKeyName then
    if self.DefaultList and self.DefaultList.IsShow and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self.DefaultList:OnCloseSquadGamepad()
      self.CurrentFocusType = "List"
      IsEventHandled = true
    elseif self.bTipOpen then
      self:UpdatKeyDisplay("SelfWidget")
      IsEventHandled = true
    else
      self:OnReturnKeyDown()
      IsEventHandled = true
    end
  end
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return IsEventHandled
  end
  if "Gamepad_Special_Right" == InKeyName then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipPressed()
    IsEventHandled = true
  elseif "Gamepad_FaceButton_Left" == InKeyName then
    if not self.IsCreator and not self.IsMember then
      self:OnBeHostBtnClick()
      IsEventHandled = true
    end
  elseif "Gamepad_FaceButton_Top" == InKeyName then
    self:OnStartBtnClick()
    IsEventHandled = true
  elseif "Gamepad_LeftThumbstick" == InKeyName then
    self:OnRankingBtnClick()
    IsEventHandled = true
  elseif "Gamepad_RightThumbstick" == InKeyName then
    self:OnShareBtnClick()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnGamePadUp(InKeyName)
  local IsEventHandled = false
  if InKeyName == Const.GamepadSpecialLeft then
    if self.IsChat then
      EventManager:FireEvent(EventID.InterruptChatView)
    end
    IsEventHandled = true
  elseif InKeyName == Const.GamepadSpecialRight then
    self.WBP_Com_Tab.WBP_Com_Tab_ResourceBar:OnGamePadTipReleased()
    if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self.DefaultList:OnSpecialRightUp()
      IsEventHandled = true
    end
  end
  return IsEventHandled
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  if self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsEventHandled = false
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    if "Gamepad_DPad_Up" == InKeyName then
      IsEventHandled = true
    elseif "Gamepad_DPad_Down" == InKeyName then
      IsEventHandled = true
    elseif "Gamepad_DPad_Right" == InKeyName then
      if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then
        return IsEventHandled
      end
      if not self.DefaultList.IsShow then
        local IsChecked = not self.DefaultList.Preview.Switch_Summon:GetChecked()
        self.DefaultList.Preview.Switch_Summon:SetChecked(IsChecked)
        local Avatar = GWorld:GetAvatar()
        if not Avatar then
          IsEventHandled = true
          return
        end
        Avatar:SwitchSquadAutoPhantom(IsChecked)
        IsEventHandled = true
      end
    elseif "Gamepad_DPad_Left" == InKeyName then
      if self.DefaultList:GetVisibility() ~= ESlateVisibility.SelfHitTestInvisible then
        return IsEventHandled
      end
      if not self.DefaultList.IsShow then
        self.DefaultList.Preview:OpenDefaultMenuAnchor()
        self.bTipOpen = true
        self:UpdatKeyDisplay("MenuAnchor")
        IsEventHandled = true
      end
    end
  end
  if "Enter" == InKeyName or "Gamepad_Special_Left" == InKeyName then
    if self.IsChat then
      EventManager:FireEvent(EventID.OpenChatView, InKeyName)
    end
    IsEventHandled = true
  end
  if IsEventHandled then
    return UWidgetBlueprintLibrary.Handled()
  else
    return UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:OnAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  if self.Mobile or self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible and self.DefaultList.IsShow then
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local AddOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent) * 5
  if InKeyName == UIConst.GamePadKey.RightAnalogY and UIUtils.CheckScrollBoxCanScroll(self.EMScrollBox_82) then
    local CurScrollOffset = self.EMScrollBox_82:GetScrollOffset()
    local ScrollOffset = math.clamp(CurScrollOffset - AddOffset, 0, self.EMScrollBox_82:GetScrollOffsetOfEnd())
    self.EMScrollBox_82:SetScrollOffset(ScrollOffset)
  end
  return UE4.UWidgetBlueprintLibrary.UnHandled()
end

function M:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
  if CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
    return
  end
  if IsUseKeyAndMouse then
    self.BtnCreateBig.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnStartDouble.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnStartDouble.WBP_Com_KeyImg_100:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnRanking.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
    self.BtnShare.WBP_Com_KeyImg:SetVisibility(UE4.ESlateVisibility.Collapsed)
  else
    self:SetFocus()
    self.BtnCreateBig.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BtnCreateBig.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
    self.BtnStartDouble.WBP_Com_KeyImg_100:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BtnStartDouble.WBP_Com_KeyImg_100:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "Y"}
      }
    })
    self.BtnStartDouble.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BtnStartDouble.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "X"}
      }
    })
    self.BtnRanking.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BtnRanking.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "LS"}
      }
    })
    self.BtnShare.WBP_Com_KeyImg:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.BtnShare.WBP_Com_KeyImg:CreateCommonKey({
      KeyInfoList = {
        {Type = "Img", ImgShortPath = "RS"}
      }
    })
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  local IsUseKeyAndMouse = CurInputDevice == ECommonInputType.MouseAndKeyboard
  local ActiveWidgetIndex = IsUseKeyAndMouse and 0 or 1
  if not IsUseKeyAndMouse and (self:HasFocusedDescendants() or self:HasAnyUserFocus()) then
    local isInvisible = self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible
    local isNotShown = not self.DefaultList.IsShow
    if isInvisible and isNotShown or not isInvisible then
      self:SelectCellFocus()
    end
  else
  end
  self:UpdateUIStyleInPlatform(IsUseKeyAndMouse)
end

function M:OnCurrentSquadChange(SquadId, IsComMissing)
  self.SquadId = SquadId
  self.IsComMissing = IsComMissing
  self:RefreshStartBtnState()
end

function M:OnForbiddenStartBtnClicked()
  if self.IsComMissing and self.DefaultList:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, "UI_Squad_Miss_Challenge")
  end
end

return M
