require("UnLua")
local M = Class({
  "BluePrints.UI.WBP.Team.View.PC.WBP_Team_Main_P_C"
})

local function GetBoardHeadCount()
  return TeamCommon and TeamCommon.MaxTeamMembers or 4
end

function M:Construct()
  self.IsAddingToParent = true
  self.Teammate2UI = {}
  self.TeammateCount = 0
  self:_InitBoardDisplay()
end

function M:InitTeamUI(TeamData)
  self.TeamData = TeamData or {}
  self.OwnerBoardItem:SetBoardHeadFocusPromptVisible(false)
  self:_RefreshBoardTeam()
end

function M:EnterGamepadHeadFocus()
  if self.bOpenBtnList then
    return false
  end
  local HeadUIs = self:_GetBoardMemberHeadUIs()
  if #HeadUIs <= 0 then
    return false
  end
  self.OwnerBoardItem:SetBoardHeadFocusPromptVisible(true)
  self:_FocusBoardHeadAt(HeadUIs, 1)
  return true
end

function M:HasGamepadHeadFocus()
  local OwnerBoardItem = self.OwnerBoardItem
  if not OwnerBoardItem then
    return false
  end
  local HeadUIs = self:_GetBoardMemberHeadUIs()
  for Index, HeadUI in ipairs(HeadUIs) do
    local HeadTeam = HeadUI and HeadUI.Head_Team
    local HeadButton = HeadTeam and HeadTeam.Button_Area
    if HeadTeam and (HeadTeam:HasFocusedDescendants() or HeadTeam:HasAnyUserFocus() or HeadButton and (HeadButton:HasFocusedDescendants() or HeadButton:HasAnyUserFocus())) then
      self.bBoardFocusedHeadUI = HeadUI
      self.bBoardFocusedHeadIndex = Index
      return true
    end
  end
  return false
end

function M:HandleGamepadHeadFocusInput(InKeyName)
  if not self:HasGamepadHeadFocus() then
    return false
  end
  if self.bOpenBtnList then
    return false
  end
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    self:_OpenFocusedBoardHead()
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    self:ExitGamepadHeadFocus()
  elseif InKeyName == UIConst.GamePadKey.DPadLeft or InKeyName == UIConst.GamePadKey.LeftStickLeft then
    self:_MoveBoardHeadFocus(-1)
  elseif InKeyName == UIConst.GamePadKey.DPadRight or InKeyName == UIConst.GamePadKey.LeftStickRight then
    self:_MoveBoardHeadFocus(1)
  end
  return true
end

function M:ExitGamepadHeadFocus()
  self.OwnerBoardItem:SetBoardHeadFocusPromptVisible(false)
  if self.bBoardFocusedHeadUI and self.bBoardFocusedHeadUI.Head_Team then
    self.bBoardFocusedHeadUI.Head_Team:PlayNormal()
  end
  self.bBoardFocusedHeadUI = nil
  self.bBoardFocusedHeadIndex = nil
  self.OwnerBoardItem:SetFocus()
end

function M:OnBoardHeadMenuOpenChanged(bOpen)
  self.OwnerBoardItem:OnBoardHeadMenuOpenChanged(bOpen)
end

function M:FocusUIByUid(Uid)
  local HeadUIs = self:_GetBoardMemberHeadUIs()
  for Index, HeadUI in ipairs(HeadUIs) do
    if HeadUI.MemberInfo.Uid == Uid then
      self.OwnerBoardItem:SetBoardHeadFocusPromptVisible(true)
      self:_FocusBoardHeadAt(HeadUIs, Index)
      return
    end
  end
end

function M:_InitBoardDisplay()
  self.HB_My:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Panel_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.WB_Player:SetVisibility(UIConst.VisibilityOp.Collapsed)
  if self.Key_GamePad then
    self.Key_GamePad:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:_RefreshBoardTeam()
  local MemberList = self.TeamData.Members or {}
  local HeadCount = GetBoardHeadCount()
  self:_ResetBoardTeam()
  self.HB_My:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if MemberList[1] then
    self:_AddBoardHead(self.Head_My, MemberList[1], 1, true)
  else
    self:_SetupEmptyBoardHead(self.Head_My)
  end
  if HeadCount > 1 then
    self.WB_Player:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
  for Index = 2, math.min(#MemberList, HeadCount) do
    local MemberData = self:_BuildBoardMember(MemberList[Index], Index)
    self:AddTeammateUI(MemberData, false, nil, Index)
    self:_RefreshBoardHeadTag(self.Teammate2UI[MemberData.Uid], false)
  end
  for Index = math.max(#MemberList + 1, 2), HeadCount do
    self:_AddEmptyBoardHead(Index)
  end
end

function M:_ResetBoardTeam()
  self.WB_Player:ClearChildren()
  self.WB_Player:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.HB_My:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Teammate2UI = {}
  self.TeammateCount = 0
  if self.Head_My then
    self.Head_My:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:_AddBoardHead(HeadUI, Member, Index, bIsLeader)
  self:_SetBoardHeadInteractable(HeadUI, true)
  local MemberData = self:_BuildBoardMember(Member, Index)
  self:AddTeammateUI(MemberData, false, HeadUI, Index)
  self:_RefreshBoardHeadTag(HeadUI, bIsLeader, Index, MemberData.Uid)
end

function M:AddTeammateUI(Member, bAnim, HeadUI, Index)
  if not HeadUI then
    HeadUI = self:CreateWidgetNew(DataMgr.WidgetUI.TeamHead.UIName)
    self.WB_Player:AddChild(HeadUI)
    self.Teammate2UI[Member.Uid] = HeadUI
    self.TeammateCount = self.TeammateCount + 1
  end
  HeadUI.bBoardEmptyHead = false
  HeadUI:Init(TeamCommon.HeadUser.Team, self, Member, Index, bAnim)
  HeadUI:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self:_SetBoardHeadInteractable(HeadUI, true)
  return HeadUI
end

function M:_SetBoardHeadInteractable(HeadUI, bEnable)
  if not HeadUI or not HeadUI.Head_Team then
    return
  end
  if HeadUI.Head_Team.SetDisableAction then
    HeadUI.Head_Team:SetDisableAction(not bEnable)
  end
  if HeadUI.Head_Team.Button_Area and HeadUI.Head_Team.Button_Area.SetIsEnabled then
    HeadUI.Head_Team.Button_Area:SetIsEnabled(bEnable)
  end
end

function M:_SetupEmptyBoardHead(HeadUI)
  if not HeadUI or not HeadUI.Head_Team then
    return
  end
  HeadUI.bBoardEmptyHead = true
  HeadUI:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  self:_SetBoardHeadInteractable(HeadUI, false)
  if HeadUI.Tag_Team then
    HeadUI.Tag_Team:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self:_RefreshBoardHeadTag(HeadUI, false)
  if HeadUI.WidgetSwitcher_State then
    HeadUI.WidgetSwitcher_State:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  HeadUI.Head_Team:SetHeadIconEmpty(true, true)
  HeadUI.Head_Team:StopAllAnimations()
  if HeadUI.Head_Team.WidgetSwitcher_State then
    HeadUI.Head_Team.WidgetSwitcher_State:SetActiveWidgetIndex(0)
  end
end

function M:_AddEmptyBoardHead(Index)
  local HeadUI = self:CreateWidgetNew(DataMgr.WidgetUI.TeamHead.UIName)
  self.WB_Player:AddChild(HeadUI)
  self:_SetupEmptyBoardHead(HeadUI)
  HeadUI.Index = Index
end

function M:_BuildBoardMember(Member, Index)
  return {
    Uid = Member.Uid,
    HeadIconId = Member.HeadIconId,
    HeadFrameId = Member.HeadFrameId,
    HeadState = Member.HeadState,
    Index = Index,
    bUseTeamHallPlayerMenu = true
  }
end

function M:_RefreshBoardHeadTag(HeadUI, bIsLeader)
  if not HeadUI then
    return
  end
  if HeadUI.Tag_Team then
    HeadUI.Tag_Team:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if HeadUI.Icon_TeamLeader then
    HeadUI.Icon_TeamLeader:SetVisibility(bIsLeader and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:_GetBoardMemberHeadUIs()
  local HeadUIs = {}
  if self.Head_My and not self.Head_My.bBoardEmptyHead then
    table.insert(HeadUIs, self.Head_My)
  end
  for _, HeadUI in ipairs(self.WB_Player:GetAllChildren():ToTable()) do
    if not HeadUI.bBoardEmptyHead then
      table.insert(HeadUIs, HeadUI)
    end
  end
  return HeadUIs
end

function M:_FocusBoardHeadAt(HeadUIs, Index)
  local HeadUI = HeadUIs[Index]
  if not HeadUI then
    return
  end
  self.bBoardFocusedHeadUI = HeadUI
  self.bBoardFocusedHeadIndex = Index
  HeadUI.Head_Team:SetGamepadCursor()
  HeadUI.Head_Team.Button_Area:SetFocus()
end

function M:_MoveBoardHeadFocus(Offset)
  local HeadUIs = self:_GetBoardMemberHeadUIs()
  local Count = #HeadUIs
  if Count <= 0 then
    return
  end
  local NextIndex = (self.bBoardFocusedHeadIndex or 1) + Offset
  if NextIndex < 1 then
    NextIndex = Count
  elseif Count < NextIndex then
    NextIndex = 1
  end
  self:_FocusBoardHeadAt(HeadUIs, NextIndex)
end

function M:_OpenFocusedBoardHead()
  if not self:HasGamepadHeadFocus() then
    return
  end
  if self.bBoardFocusedHeadUI and self.bBoardFocusedHeadUI.Head_Team then
    self.bBoardFocusedHeadUI.Head_Team:BtnAreaOnClicked()
  end
end

function M:Destruct()
  self.OwnerBoardItem = nil
  self.TeamData = nil
  self.Teammate2UI = nil
  self.bBoardFocusedHeadUI = nil
  self.bBoardFocusedHeadIndex = nil
end

return M
