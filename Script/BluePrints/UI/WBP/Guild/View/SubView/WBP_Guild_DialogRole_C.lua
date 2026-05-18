require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  self:BindInputMethodChangedDelegate()
  self.List_Item:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Item:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
end

function M:InitContent(Params, PopupData, Owner)
  self.Params = Params
  self.Owner = Owner
  self.CurJobLevel = self:GetCurJobLevel()
  self.SelfJobLevel = self:GetSelfJoBLv()
  self:ShowList()
  self:RefreshIconAndGamePadVisibility(UIUtils.UtilsGetCurrentInputType())
end

function M:ShowList()
  local GuildTitle = DataMgr.GuildTitle
  local Configs = {}
  for Index, Config in pairs(GuildTitle) do
    table.insert(Configs, Config)
  end
  table.sort(Configs, function(a, b)
    return a.JoBLv > b.JoBLv
  end)
  self.List_Item:ClearListItems()
  for Index, Config in pairs(Configs) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.JoBLv = Config.JoBLv
    Content.KickMembers = Config.KickMembers
    Content.LimitCount = Config.LimitCount
    Content.ModifyDeclaration = Config.ModifyDeclaration
    Content.ModifyNameEmblem = Config.ModifyNameEmblem
    Content.TitleName = Config.TitleName
    Content.ApproveApplication = Config.ApproveApplication
    Content.CellCallbackInfo = {
      Obj = self,
      Func = self.OnCellClick
    }
    Content.CurJobLevel = self.CurJobLevel
    Content.SelfJobLevel = self.SelfJobLevel
    Content.LastChangeJobLevel = self.Params.LastChangeJobLevel
    self.List_Item:AddItem(Content)
  end
end

function M:OnCellClick(Content)
  local AllItemCount = self.List_Item:GetNumItems()
  for i = 0, AllItemCount - 1 do
    local Item = self.List_Item:GetItemAt(i)
    if Item.Index ~= Content.Index and Item.SelfWidget then
      Item.SelfWidget:SetIsSelect(false)
      Item.SelfWidget.IsSelect = false
    end
  end
  local JobLv = Content.JoBLv
  self.SelectJobLevel = JobLv
  if JobLv == self:GetCurJobLevel() then
    self.Owner:ForbidRightBtn(true)
  else
    self.Owner:ForbidRightBtn(false)
  end
end

function M:GetCurJobLevel()
  local CurMember = GuildController.GetGuildMember(self.Params.MemberGuildFullInfo.Members, self.Params.MemberUid)
  return CurMember.Title
end

function M:GetChangeJobLevel()
  return self.SelectJobLevel
end

function M:GetGuildFullInfo()
  return self.Params.MemberGuildFullInfo
end

function M:GetSelfJoBLv()
  local SelfGuildInfo = GuildController:GetModel():GetCurrGuild()
  local SelfMember = GuildController.GetGuildMember(SelfGuildInfo.Members, ChatController:GetAvatar().Uid)
  return SelfMember.Title
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    if InKeyName == UIConst.GamePadKey.FaceButtonRight then
      self.Owner:OnLeftBtnClicked()
    elseif InKeyName == UIConst.GamePadKey.FaceButtonDown and self.SelectJobLevel ~= self:GetCurJobLevel() then
      self.Owner:OnRightBtnClicked()
    end
  end
  return UIUtils.UnHandled
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
end

function M:BindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChanged)
  end
end

function M:UnBindInputMethodChangedDelegate()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChanged)
  end
end

function M:OnInputMethodChanged(NewGameInputType, NewGamepadName)
  self:RefreshIconAndGamePadVisibility(NewGameInputType)
end

function M:RefreshIconAndGamePadVisibility(CurInputDeviceType)
  if CurInputDeviceType == ECommonInputType.Gamepad then
    self:AddTimer(0.02, function()
      self.List_Item:SetFocus()
    end)
  else
  end
end

return M
