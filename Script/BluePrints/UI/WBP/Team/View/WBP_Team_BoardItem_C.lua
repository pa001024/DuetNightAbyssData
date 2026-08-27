require("UnLua")
local TypeIconMaterialParamName = "MainTex"
local FriendIconPath = "/Game/UI/Texture/Dynamic/Atlas/Chat/T_ChatChannel_Friend.T_ChatChannel_Friend"
local GuildIconPath = "/Game/UI/Texture/Dynamic/Atlas/Chat/T_ChatChannel_Guild.T_ChatChannel_Guild"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.BP_EMUserWidgetUtils_C",
  "BluePrints.UI.WBP.Team.View.WBP_Team_BoardItem_GamePadCompoment"
}

local function GetMaxMemberCount()
  return TeamCommon and TeamCommon.MaxTeamMembers or 4
end

function M:Construct()
  self:BindButtonEvent()
  self:InitGamePadCompoment()
end

function M:InitRecruitmentDetail(RecruitmentData)
  local bWasShowing = self.bMineDetailMode and self.RecruitmentData ~= nil
  local bWillShow = nil ~= RecruitmentData
  self.Content = nil
  self.bMineDetailMode = true
  if not bWillShow then
    if bWasShowing and self.Out then
      self.bPendingHideAfterOut = true
      if self.In then
      end
      self:PlayAnimation(self.Out)
      return
    end
    self.bPendingHideAfterOut = nil
    self.RecruitmentData = nil
    self:RefreshView()
    return
  end
  self.bPendingHideAfterOut = nil
  if self.Out then
    self:StopAnimation(self.Out)
  end
  self.RecruitmentData = RecruitmentData
  self:RefreshView()
  if not bWasShowing and self.In then
    self:PlayAnimation(self.In)
  end
end

function M:HideRecruitmentDetail()
  self.bPendingHideAfterOut = nil
  if self.In then
    self:StopAnimation(self.In)
  end
  if self.Out then
    self:StopAnimation(self.Out)
  end
  self.Content = nil
  self.RecruitmentData = nil
  self.bMineDetailMode = true
  self:RefreshView()
end

function M:OnListItemObjectSet(Content)
  if not Content then
    return
  end
  self.bMineDetailMode = false
  self.Content = Content
  self.TeamBoardOwner = Content.ParentWidget
  Content.SelfWidget = self
  if Content.IsEmpty then
    self.RecruitmentData = nil
    self.bApplied = false
    self.WS_Item:SetActiveWidgetIndex(1)
    self:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
    if self.SetIsFocusable then
      self:SetIsFocusable(false)
    end
    return
  end
  self.WS_Item:SetActiveWidgetIndex(0)
  if self.SetIsFocusable then
    self:SetIsFocusable(true)
  end
  self:SetVisibility(UIConst.VisibilityOp.Visible)
  self.RecruitmentData = Content.RecruitmentData
  self.bApplied = Content.bApplied and true or false
  self.bBoardHeadMenuOpen = false
  self:RefreshGamepadPromptState()
  self:RefreshView()
  self:SetVisibility(UIConst.VisibilityOp.Visible)
end

function M:BindButtonEvent()
  if self.Btn_Apply then
    self.Btn_Apply:BindEventOnClicked(self, self.OnApplyClick)
  end
  if self.Btn_Share then
    self.Btn_Share:BindEventOnClicked(self, self.OnShareClick)
  end
end

function M:RefreshView()
  if self.WS_Item then
    self.WS_Item:SetActiveWidgetIndex(0)
  end
  if self.bMineDetailMode then
    self:SetVisibility(self.RecruitmentData and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.Collapsed)
    if self.Text_Title then
      self.Text_Title:SetText(self.RecruitmentData and GText("UI_TeamMyTeam") or "")
    end
    if self.Btn_Share and self.Btn_Share.SetText then
      self.Btn_Share:SetText(GText("UI_TeamShare"))
    end
    if not self.RecruitmentData then
      if self.Group_Level then
        self.Group_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      if self.Image_Icon then
        self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      self:RefreshTeamTypeIcon()
      self:SetSignText(self.RecruitSign_1, nil)
      self:SetSignText(self.RecruitSign_2, nil)
      return
    end
    self.WS_Btn:SetActiveWidgetIndex(1)
  end
  if not self.RecruitmentData then
    return
  end
  self:RefreshTypeInfo()
  self:RefreshTypeIcon()
  self:RefreshTeamTypeIcon()
  self:RefreshLevelInfo()
  self:RefreshMemberInfo()
  self:RefreshSignInfo()
  if self.bMineDetailMode then
    if self.Btn_Share and self.Btn_Share.ForbidBtn then
      self.Btn_Share:ForbidBtn(false)
    end
    return
  end
  self:RefreshButtonState()
end

function M:PlayBoardItemInAnimation()
  if self.In then
    self:PlayAnimation(self.In)
    return
  end
end

function M:OnAnimationFinished(InAnim)
  if self.bMineDetailMode and self.bPendingHideAfterOut and InAnim == self.Out then
    self.bPendingHideAfterOut = nil
    self.RecruitmentData = nil
    self:RefreshView()
    if self.TeamBoardOwner and 1 == self.TeamBoardOwner.CurMainTabIndex then
      self.TeamBoardOwner:RefreshRecruitList()
    end
  end
end

function M:RefreshTypeInfo()
  local RecruitmentData = self.RecruitmentData
  local FirstTypeCfg = DataMgr.TeamFirstType[RecruitmentData.FirstType]
  local SecondTypeCfg = DataMgr.TeamSecondType[RecruitmentData.SecondType]
  if self.Text_TeamTypeTitle then
    self.Text_TeamTypeTitle:SetText(FirstTypeCfg and GText(FirstTypeCfg.Name) or "")
  end
  if self.Text_TeamTypeSubTitle then
    self.Text_TeamTypeSubTitle:SetText(SecondTypeCfg and GText(SecondTypeCfg.Name) or "")
  end
end

function M:RefreshLevelInfo()
  local RecruitmentData = self.RecruitmentData
  if RecruitmentData.DungeonLevel and RecruitmentData.DungeonLevel > 0 then
    self.Group_Level:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    self.Text_Level:SetText(string.format("Lv.%s", tostring(RecruitmentData.DungeonLevel)))
    return
  end
  self.Group_Level:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:RefreshMemberInfo()
  if not self.Team_Head or not self.Team_Head.InitTeamUI then
    return
  end
  local TeamData = {
    Members = {}
  }
  local MemberList = self.RecruitmentData.Members or {}
  for Index, Member in ipairs(MemberList) do
    TeamData.Members[Index] = {
      Uid = Member.Uid,
      HeadIconId = Member.HeadIconId,
      HeadFrameId = Member.HeadFrameId,
      Index = Index
    }
  end
  self.Team_Head.OwnerBoardItem = self
  self.Team_Head:InitTeamUI(TeamData)
end

function M:RefreshSignInfo()
  local DisplayTags = self:BuildDisplayTags()
  self:SetSignText(self.RecruitSign_1, DisplayTags[1])
  self:SetSignText(self.RecruitSign_2, DisplayTags[2])
end

function M:BuildDisplayTags()
  local Result = {}
  local Tags = self.RecruitmentData.Tags or {}
  for _, TagId in ipairs(Tags) do
    local TagCfg = DataMgr.TagText and DataMgr.TagText[TagId]
    if TagCfg and TagCfg.TagText then
      table.insert(Result, {
        Text = GText(TagCfg.TagText)
      })
      if #Result >= 2 then
        return Result
      end
    end
  end
  local CustomTags = self.RecruitmentData.CustomTags or {}
  for _, CustomTag in ipairs(CustomTags) do
    if CustomTag and "" ~= CustomTag then
      table.insert(Result, {
        Text = tostring(CustomTag)
      })
      if #Result >= 2 then
        return Result
      end
    end
  end
  return Result
end

function M:SetSignText(SignWidget, TagData)
  if not SignWidget then
    return
  end
  if not (TagData and TagData.Text) or TagData.Text == "" then
    SignWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
    return
  end
  if SignWidget.Text_ApplySign and SignWidget.Text_ApplySign.SetText then
    SignWidget.Text_ApplySign:SetText(TagData.Text)
  end
  SignWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:RefreshButtonState()
  local MemberCount = self.RecruitmentData.Members and #self.RecruitmentData.Members or 0
  local IsFull = MemberCount >= GetMaxMemberCount()
  local IsApplied = self.bApplied
  self.bTeamFull = IsFull
  self.WS_Btn:SetActiveWidgetIndex(0)
  local BtnTextKey = IsApplied and "UI_TeamAlreadyApplied" or "UI_TeamApplyToJoin"
  if self.Btn_Apply and self.Btn_Apply.SetText then
    self.Btn_Apply:SetText(GText(BtnTextKey))
  end
  self:SetApplyBtnForbid(IsFull or IsApplied)
  if self.Btn_Share and self.Btn_Share.SetText then
    self.Btn_Share:SetText(GText("UI_TeamShare"))
  end
end

function M:OnApplyClick()
  if not self.RecruitmentData then
    return
  end
  if self.bApplied then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar and Avatar:IsInTeam() then
    UIManager(self):ShowUITip("CommonToastMain", GText("TeamHall_CanNotApplyTeam"), 1.5)
    return
  end
  local LeaderUid = self:GetLeaderUid()
  if not LeaderUid then
    UIManager(self):ShowUITip("CommonToastMain", GText("StatusNotAllowJoiningTeam"), 1.5)
    return
  end
  local RecruitmentData = self.RecruitmentData
  local RecruitmentId = RecruitmentData.RecruitmentId
  local Content = self.Content
  self:SetApplyBtnForbid(true)
  Avatar:RequestEnterTeam(function()
    if self.RecruitmentData ~= RecruitmentData or self.Content ~= Content then
      return
    end
    self.bApplied = true
    if Content then
      Content.bApplied = true
    end
    self:RefreshButtonState()
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_TeamJoinRequestSent"), 1.5)
  end, LeaderUid, function(bSuccess, RetCode)
    if bSuccess then
      return
    end
    if RetCode == ErrorCode.RET_TEAM_HALL_NOT_EXIST or RetCode == ErrorCode.RET_TEAM_HALL_NOT_IN then
      TeamHallController:RemoveExpiredRecruitment(RecruitmentId)
      return
    end
    if self.RecruitmentData == RecruitmentData and self.Content == Content then
      self:RefreshButtonState()
    end
  end, RecruitmentId)
end

function M:OnShareClick()
  if not self.RecruitmentData then
    return
  end
  local PublicVisibleType = CommonConst and CommonConst.TeamHallVisibleType and CommonConst.TeamHallVisibleType.Public
  local bCanShare = false
  for _, VisibleType in ipairs(self.RecruitmentData.VisibleType or {}) do
    if VisibleType == PublicVisibleType then
      bCanShare = true
      break
    end
  end
  if not bCanShare then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_TeamHall_CanNotShare"), 1.5)
    return
  end
  local TeamBoardOwner = self.TeamBoardOwner
  local Params = {
    RecruitmentData = self.RecruitmentData
  }
  if TeamBoardOwner and type(TeamBoardOwner.OnRecruitPopupClosed) == "function" then
    Params.OnCloseCallbackObj = TeamBoardOwner
    Params.OnCloseCallbackFunction = TeamBoardOwner.OnRecruitPopupClosed
  end
  TeamHallController:OpenRecruitShare(TeamBoardOwner or self, Params)
end

function M:GetLeaderUid()
  local MemberList = self.RecruitmentData.Members or {}
  local LeaderMember = MemberList[1]
  return LeaderMember and LeaderMember.Uid
end

function M:SetApplyBtnForbid(bForbid)
  if not self.Btn_Apply then
    return
  end
  if bForbid and not self.bForbidBinded then
    self.Btn_Apply:BindForbidStateExecuteEvent(self, self.OnApplyForbidClick)
    self.bForbidBinded = true
  end
  self.Btn_Apply:ForbidBtn(bForbid)
end

function M:OnApplyForbidClick()
  if self.bTeamFull then
    UIManager(self):ShowUITip("CommonToastMain", GText("UI_TeamTeamIsFull"), 1.5)
  end
end

function M:RefreshTypeIcon()
  local RecruitmentData = self.RecruitmentData
  local SecondTypeCfg = DataMgr.TeamSecondType[RecruitmentData.SecondType]
  local IconPath = SecondTypeCfg and SecondTypeCfg.Icon or nil
  self.TypeIconLoadResourceID = nil
  self.TypeIconPath = IconPath
  self.Image_Icon:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if not IconPath or "" == IconPath then
    return
  end
  local Handle = UE.UResourceLibrary.LoadObjectAsyncWithId(self, IconPath, {
    self,
    M.OnTypeIconLoadFinish
  })
  if Handle then
    self.TypeIconLoadResourceID = Handle.ResourceID
    return
  end
  local IconObject = LoadObject(IconPath)
  if IconObject then
    self:ApplyTypeIcon(IconObject)
  end
end

function M:RefreshTeamTypeIcon()
  local TeamTypeIconGroup = self.Group_TeamTypeIcon
  local TeamTypeIconImage = self.Image_TeamTypeIcon
  if not TeamTypeIconGroup or not TeamTypeIconImage then
    return
  end
  TeamTypeIconGroup:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.bMineDetailMode then
    return
  end
  if not self.RecruitmentData then
    return
  end
  local LeaderUid = self:GetLeaderUid()
  if not LeaderUid then
    return
  end
  local FriendModel = require("BluePrints.UI.WBP.Friend.FriendModel")
  local GuildModel = require("BluePrints.UI.WBP.Guild.Model.GuildModel")
  local IconPath
  if FriendModel:IsFriend(LeaderUid) then
    IconPath = FriendIconPath
  elseif GuildModel:IsInCurrGuild(LeaderUid) then
    IconPath = GuildIconPath
  end
  if not IconPath then
    return
  end
  local IconObject = LoadObject(IconPath)
  if not IconObject then
    return
  end
  TeamTypeIconImage:SetBrushFromTexture(IconObject)
  TeamTypeIconGroup:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:ApplyTypeIcon(IconObject)
  local DynamicMaterial = self.Image_Icon:GetDynamicMaterial()
  if not DynamicMaterial then
    return
  end
  DynamicMaterial:SetTextureParameterValue(TypeIconMaterialParamName, IconObject)
  self.Image_Icon:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OnTypeIconLoadFinish(Object, ResourceID)
  if not (Object and IsValid(self)) or self.TypeIconLoadResourceID ~= ResourceID then
    return
  end
  self:ApplyTypeIcon(Object)
end

AssembleComponents(M)
return M
