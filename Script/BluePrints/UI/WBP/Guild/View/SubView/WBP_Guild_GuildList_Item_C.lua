require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Btn_Click.OnClicked:Add(self, self.OnCellClick)
end

function M:OnCellClick(bIsChecked)
  self.Content.ClickCallbackInfo.Func(self.Content.ClickCallbackInfo.Obj, self)
  AudioManager(self):PlayUISound(self, "event:/ui/common/special_content_01_click", nil, nil)
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.CurrentEntry = self
  self:InitData(Content)
  if not self.Btn_Click.OnCheckStateChanged:IsBound() then
    self.Btn_Click.OnCheckStateChanged:Add(self, self.OnSelected)
    self.Btn_Click.OnHovered:Add(self, self.OnHovered)
  end
  if Content.bSelected then
    self:SetSelected(true)
  else
    self:SetSelected(false)
  end
end

function M:SetSelected(bIsChecked)
  if bIsChecked then
    self.Btn_Click:SetChecked(bIsChecked)
  else
    self.Btn_Click:SetChecked(bIsChecked)
    self:PlayAnimation(self.Normal)
  end
end

function M:OnHovered()
  if UIUtils.UtilsGetCurrentInputType() ~= UE4.ECommonInputType.Gamepad then
    return
  end
  self.Content.bSelected = true
  self:SetSelected(true)
  self.Content.ClickCallbackInfo.Func(self.Content.ClickCallbackInfo.Obj, self)
end

function M:OnSelected(bIsChecked)
  if not self.Content then
    DebugPrint("Content is nil, cannot clear list item object.")
    return
  end
  self.Content.bSelected = bIsChecked
  if bIsChecked then
    self.Content.Parent:OnSelected(self.Content)
    self.Btn_Click:SetIsEnabled(false)
  else
    local IsSelected = false
    if self.Content.Parent and self.Content.Parent.CurrentSelectedContent == self.Content then
      IsSelected = true
      self:SetSelected(true)
    end
    if not IsSelected then
      self.Btn_Click:SetIsEnabled(true)
    end
  end
end

function M:InitData(Content)
  if not Content.GuildId then
    self.WS_Type:SetActiveWidgetIndex(1)
    return
  end
  self.WS_Type:SetActiveWidgetIndex(0)
  self.Content.SelfWidget = self
  self.Logo:Init(Content.LogoInfo)
  self.Text_Name:SetText(GText(Content.Name))
  self.Text_Lv:SetText(GText("UI_LEVEL_NAME"))
  self.Text_Level:SetText(GText(tostring(Content.Level)))
  self.Text_NowNum:SetText(GText(tostring(Content.MemberCount)))
  local GuildLevelConfig = DataMgr.GuildLevel[Content.Level]
  self.Text_TotalNum:SetText(GText(tostring(GuildLevelConfig.GuildMembersNum)))
  self.Text_Join:SetText(GText(Content.AutoAgreeJoinRequest and GText("UI_AutoJoin") or GText("UI_NeedApproval")))
  self:UpdateApplayState()
end

function M:UpdateApplayState()
  local HasApplay = false
  local RequestJoinGuildTime = GWorld:GetAvatar().RequestJoinGuildTime or {}
  for CurGuildId, Time in pairs(RequestJoinGuildTime) do
    if self.Content.GuildId == CurGuildId then
      HasApplay = true
      break
    end
  end
  if HasApplay then
    self.Icon_HasApply:SetVisibility(UIConst.VisibilityOp.Visible)
  else
    self.Icon_HasApply:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

return M
