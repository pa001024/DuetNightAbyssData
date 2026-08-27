require("UnLua")
local TeamHallController = require("BluePrints.UI.WBP.TeamHall.TeamHallController")
local TeamHallRecruitShareModel = require("BluePrints.UI.WBP.TeamHall.TeamHallRecruitShareModel")
local TypeIconMaterialParamName = "MainTex"
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

local function HasIdentifier(Value)
  local Text = nil ~= Value and tostring(Value) or ""
  return "" ~= Text and "0" ~= Text
end

local function SetWidgetShown(Widget, bShown)
  if not Widget then
    return
  end
  Widget:SetVisibility(bShown and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

function M:Construct()
  self.Btn_Click.AudioEventPath = "event:/ui/common/special_content_01_click"
  self.Btn_Click.OnClicked:Remove(self, self.OnClicked)
  self.Btn_Click.OnClicked:Add(self, self.OnClicked)
  self:Reset()
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnClicked)
  self:Reset()
end

function M:InitTeamInfo(TeamInfo, bSelfMsg)
  self:Reset()
  if type(TeamInfo) ~= "table" then
    return false
  end
  local DisplayData = TeamHallRecruitShareModel.BuildDisplayData(TeamInfo)
  if not DisplayData then
    return false
  end
  self.TeamInfo = TeamInfo
  self.RecruitmentId = TeamInfo.RecruitmentId
  self.RecruitmentOwnerUid = TeamInfo.RecruitmentOwnerUid
  self.MessageSenderUid = TeamInfo.MessageSenderUid
  self.bSelfMsg = true == bSelfMsg
  local FirstTypeText = DisplayData.FirstTypeText or ""
  local SecondTypeText = DisplayData.SecondTypeText or ""
  local DungeonLevelText = DisplayData.DungeonLevelText or ""
  local MemberCountText = DisplayData.MemberCountText or ""
  if "" == FirstTypeText and "" == SecondTypeText and "" == MemberCountText then
    self:Reset()
    return false
  end
  self.Text_Title:SetText(FirstTypeText)
  self.Text_SubTitle:SetText(SecondTypeText)
  self.Text_Level:SetText(DungeonLevelText)
  self.Text_TeamNum:SetText(MemberCountText)
  SetWidgetShown(self.Text_Title, "" ~= FirstTypeText)
  SetWidgetShown(self.Text_SubTitle, "" ~= SecondTypeText)
  SetWidgetShown(self.Group_Level, "" ~= DungeonLevelText)
  SetWidgetShown(self.Group_TeamNum, "" ~= MemberCountText)
  SetWidgetShown(self.HB_Detail, "" ~= DungeonLevelText or "" ~= MemberCountText)
  self:RefreshTypeIcon(DisplayData.IconPath)
  local TagTexts = DisplayData.TagTexts or {}
  local bHasTag = false
  for Index = 1, 2 do
    local TagWidget = self["ChatSign_" .. Index]
    local TagText = TagTexts[Index] or ""
    if TagWidget and TagWidget.Text_ApplySign then
      TagWidget.Text_ApplySign:SetText(TagText)
    end
    SetWidgetShown(TagWidget, "" ~= TagText)
    bHasTag = bHasTag or "" ~= TagText
  end
  SetWidgetShown(self.HB_Sign, bHasTag)
  self:_RefreshClickState()
  return true
end

function M:Reset()
  self.DataVersion = (self.DataVersion or 0) + 1
  self.TeamInfo = nil
  self.RecruitmentId = nil
  self.RecruitmentOwnerUid = nil
  self.MessageSenderUid = nil
  self.bSelfMsg = nil
  self.bRequesting = false
  self.TypeIconLoadResourceID = nil
  self.Text_Title:SetText("")
  self.Text_SubTitle:SetText("")
  self.Text_Level:SetText("")
  self.Text_TeamNum:SetText("")
  SetWidgetShown(self.Text_Title, false)
  SetWidgetShown(self.Text_SubTitle, false)
  SetWidgetShown(self.Image_Icon, false)
  SetWidgetShown(self.Group_Level, false)
  SetWidgetShown(self.Group_TeamNum, false)
  SetWidgetShown(self.HB_Detail, false)
  SetWidgetShown(self.HB_Sign, false)
  for Index = 1, 2 do
    local TagWidget = self["ChatSign_" .. Index]
    if TagWidget and TagWidget.Text_ApplySign then
      TagWidget.Text_ApplySign:SetText("")
    end
    SetWidgetShown(TagWidget, false)
  end
  self:_RefreshClickState()
end

function M:RefreshTypeIcon(IconPath)
  self.TypeIconLoadResourceID = nil
  SetWidgetShown(self.Image_Icon, false)
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
  if IsValid(IconObject) then
    self:ApplyTypeIcon(IconObject)
  end
end

function M:ApplyTypeIcon(IconObject)
  if not IsValid(IconObject) then
    return
  end
  local DynamicMaterial = self.Image_Icon:GetDynamicMaterial()
  if not DynamicMaterial then
    return
  end
  DynamicMaterial:SetTextureParameterValue(TypeIconMaterialParamName, IconObject)
  SetWidgetShown(self.Image_Icon, true)
end

function M:OnTypeIconLoadFinish(Object, ResourceID)
  if not (IsValid(Object) and IsValid(self)) or self.TypeIconLoadResourceID ~= ResourceID then
    return
  end
  self:ApplyTypeIcon(Object)
end

function M:_RefreshClickState()
  local bClickable = not self.bSelfMsg and HasIdentifier(self.RecruitmentId) and HasIdentifier(self.RecruitmentOwnerUid) and HasIdentifier(self.MessageSenderUid)
  self.Btn_Click:SetVisibility(bClickable and UIConst.VisibilityOp.Visible or UIConst.VisibilityOp.HitTestInvisible)
  self.Btn_Click:SetIsEnabled(bClickable and not self.bRequesting)
end

function M:OnClicked()
  if not (not self.bSelfMsg and not self.bRequesting and HasIdentifier(self.RecruitmentId) and HasIdentifier(self.RecruitmentOwnerUid)) or not HasIdentifier(self.MessageSenderUid) then
    return false
  end
  self.bRequesting = true
  self:_RefreshClickState()
  local DataVersion = self.DataVersion
  local bCompleted = false
  
  local function Complete(bSuccess)
    if bCompleted then
      return
    end
    bCompleted = true
    if not IsValid(self) or self.DataVersion ~= DataVersion then
      return
    end
    self.bRequesting = false
    self:_RefreshClickState()
    if bSuccess then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_Team_JoinSent"))
    end
  end
  
  local bCallSuccess, bRequestStarted = pcall(TeamHallController.RequestEnterTeamFromChat, TeamHallController, self.RecruitmentId, self.RecruitmentOwnerUid, self.MessageSenderUid, Complete)
  if not bCallSuccess or not bRequestStarted then
    Complete(false)
  end
  return true
end

return M
