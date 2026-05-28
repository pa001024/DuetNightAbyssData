require("UnLua")
local M = Class({
  "BluePrints.Common.TimerMgr",
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize(Initializer)
end

function M:Destruct()
  GuildController:UnRegisterEvent(self)
end

function M:Construct()
  self.SearchCoolDownPercent = 0
  GuildController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == GuildCommon.EventID.OnGuildSearch then
      self:GuildListSearchSuccessful(...)
    elseif EventId == GuildCommon.EventID.OnGuildSearchFail then
      self:GuildListSearchFail()
    elseif EventId == GuildCommon.EventID.OnGuildGetListCDTick then
      self:RefreshSearchBtnState(...)
    end
  end)
  self.Btn_Search:ForbidBtn(true)
  self.Input_Name:Init({
    Owner = self,
    Events = {
      OnTextChanged = function(Owner, Text)
        if "" == Text then
          self.Btn_Search:ForbidBtn(true)
          self.CurShowGuildList = self.AllGuildList
          self:ShowGuildList()
        else
          self.Btn_Search:ForbidBtn(false)
        end
      end
    },
    HintText = GText("UI_SearchGuildByNameOrID"),
    TextLimit = 40,
    HideGamePadDeleteBtn = true,
    bNeedPasteBtn = true,
    OnGetBackFocusWidget = function()
      self.List_Guild:SetFocus()
    end
  })
  self.Controller_Search:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "Menu",
        Owner = self
      }
    }
  })
  self.Btn_Search:BindEventOnClicked(self, self.SearchGuild)
  self.Btn_Search:BindForbidStateExecuteEvent(self, self.ForbiddenSearchGuild)
  self.Btn_JoinAll:SetGamePadImg("Right")
  self.Btn_JoinAll:SetText(GText("UI_ApplyToAllGuilds"))
  self.Btn_JoinAll:BindEventOnClicked(self, self.JoinAllGuild)
  self.Btn_Refresh:SetGamePadImg("Left")
  self.Btn_Refresh:SetText(GText("UI_RefreshGuildList"))
  self.Btn_Refresh:BindEventOnClicked(self, self.SearcRefreshGuildList)
  self.Btn_Refresh:BindForbidStateExecuteEvent(self, self.ForbiddenSearcRefreshGuildList)
  self.Text_Name:SetText(GText("UI_GuildName"))
  self.Text_Level:SetText(GText("UI_GuildLevel"))
  self.Text_Num:SetText(GText("UI_GuildMemberCount"))
  self.Text_Join:SetText(GText("UI_JoinMethod"))
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
end

function M:SetData(AllGuildList, SetGuildInfoFuncInfo, Parent)
  self.Parent = Parent
  self.SetGuildInfoFuncInfo = SetGuildInfoFuncInfo
  self.AllGuildList = AllGuildList
  self.CurShowGuildList = self.AllGuildList
  if self.DelayToShowContentItemTimer then
    self:RemoveTimer(self.DelayToShowContentItemTimer)
  end
  if self.IsRefresh then
    self.IsRefresh = false
    self:PlayAnimation(self.Refresh)
    self:DelayShowGuildList()
  else
    self:ShowGuildList()
  end
  self:UpdateGamePadIcon()
  self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:ShowGuildList()
  self.List_Guild:ClearListItems()
  for Index, Data in pairs(self.CurShowGuildList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Index = Index
    Content.ClickCallbackInfo = {
      Func = self.OnGuildListItemClick,
      Obj = self
    }
    Content.Parent = self
    Content.Name = Data.Name
    Content.AuditStatus = Data.AuditStatus
    Content.MemberLimit = Data.MemberLimit
    Content.GuildId = Data.GuildId
    Content.Declaration = Data.Declaration
    Content.Level = Data.Level
    Content.MemberCount = Data.MemberCount
    Content.LogoInfo = Data.LogoInfo
    Content.Score = Data.Score
    Content.ActivityLevel = Data.ActivityLevel
    Content.AutoAgreeJoinRequest = Data.AutoAgreeJoinRequest
    self.List_Guild:AddItem(Content)
    if 1 == Index then
      Content.bSelected = true
      Content.IsFocus = true
      self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, Content)
    else
      Content.bSelected = false
    end
  end
  self.List_Guild.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    Obj.Parent = self
    return Obj
  end)
  self.List_Guild:RequestFillEmptyContent()
  if 0 == #self.CurShowGuildList then
    self.WS_Type:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("UI_NoGuild"))
    self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, nil)
    self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.WS_Type:SetActiveWidgetIndex(0)
    self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if #self.CurShowGuildList ~= #self.AllGuildList and 1 == #self.CurShowGuildList then
      self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Bar_CD:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  if (self.List_Guild:HasAnyUserFocus() or self.List_Guild:HasFocusedDescendants() or self.ParentWidget:HasAnyUserFocus()) and 0 == #self.CurShowGuildList then
    self.ParentWidget:SetFocus()
  end
end

function M:OnSelected(Content)
  local PreSelectedContent = self.CurrentSelectedContent
  self.CurrentSelectedContent = Content
  if PreSelectedContent and PreSelectedContent ~= Content then
    if PreSelectedContent.CurrentEntry then
      PreSelectedContent.CurrentEntry:SetSelected(false)
    end
    PreSelectedContent.bSelected = false
  end
end

function M:OnGuildListItemClick(ItemWidget)
  self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, ItemWidget.Content)
end

function M:SearchGuild()
  local Text = self.Input_Name:GetText()
  self.CurShowGuildList = {}
  if "" == Text then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("GuildListSearchHint"))
  else
    GuildController:SendGuildSearch(Text)
  end
end

function M:ForbiddenSearchGuild()
  local Text = self.Input_Name:GetText()
  if "" == Text then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("GuildListSearchHint"))
  end
end

function M:GuildListSearchSuccessful(GuildList)
  self.SearchGuildList = GuildList
  self.CurShowGuildList = self.SearchGuildList
  self:ShowGuildList()
end

function M:GuildListSearchFail()
  self.SearchGuildList = {}
  self.CurShowGuildList = self.SearchGuildList
  self.WS_Type:SetActiveWidgetIndex(1)
  self.Text_Empty:SetText(GText("UI_GuildNotFound"))
  self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, nil)
  self.List_Guild:RequestFillEmptyContent()
  self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.ParentWidget:SetFocus()
end

function M:JoinAllGuild()
  local GuildIdList = {}
  local AllDisplayedEntries = self.List_Guild:GetDisplayedEntryWidgets()
  for _, Entry in pairs(AllDisplayedEntries) do
    table.insert(GuildIdList, Entry.Content.GuildId)
    DebugPrint("HZQ GuildName: ", Entry.Content.Name)
  end
  if 0 == #GuildIdList then
    return
  end
  GuildController:SendRequestJoinGuildBatch(GuildIdList)
end

function M:SearcRefreshGuildList()
  if self.SearchCoolDownPercent > 0 then
    local UIManager = GWorld.GameInstance:GetGameUIManager()
    UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_RefreshOnCooldown"))
    return
  end
  self.IsRefresh = true
  GuildController:SendGuildGetList()
end

function M:ForbiddenSearcRefreshGuildList()
  local UIManager = GWorld.GameInstance:GetGameUIManager()
  UIManager:ShowUITip(UIConst.Tip_CommonToast, GText("UI_RefreshOnCooldown"))
end

function M:RefreshSearchBtnState(Percent)
  if Percent <= 0 then
    self.SearchCoolDownPercent = Percent
    self.Btn_Refresh:ForbidBtn(false)
  else
    self.Btn_Refresh:ForbidBtn(true)
  end
  self.Bar_CD:SetPercent(Percent)
  self.Bar_CD:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:UpdateJoinGuildItem(GuildData)
  local len = self.List_Guild:GetNumItems()
  for index = 0, len - 1 do
    local Item = self.List_Guild:GetItemAt(index)
    if Item.GuildId == GuildData.GuildId and Item.SelfWidget then
      Item.SelfWidget:UpdateApplayState()
    end
  end
end

function M:OnPreviewKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    if InKeyName == UIConst.GamePadKey.DPadLeft then
      if self.Btn_Refresh:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
        if self.Btn_Refresh:IsBtnForbidden() then
          self:ForbiddenSearcRefreshGuildList()
        else
          self:SearcRefreshGuildList()
        end
        IsHandled = true
      end
    elseif InKeyName == UIConst.GamePadKey.DPadRight and self.Btn_JoinAll:GetVisibility() == UIConst.VisibilityOp.SelfHitTestInvisible then
      self:JoinAllGuild()
      IsHandled = true
    end
  end
  if IsHandled then
    return UIUtils.Handled
  else
    return UIUtils.UnHandled
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if UIUtils.IsGamepadInput() then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      self.Input_Name:SetFocus()
      IsHandled = true
    else
      if InKeyName == UIConst.GamePadKey.LeftThumb then
        if self.Input_Name:GetText() == "" then
          self.Input_Name:PasteText()
        else
          self.Input_Name:DeleteText()
        end
        if self.Input_Name:GetText() == "" then
          self.Btn_Search:ForbidBtn(true)
          self.CurShowGuildList = self.AllGuildList
          self:ShowGuildList()
        else
          self.Btn_Search:ForbidBtn(false)
        end
        IsHandled = true
      else
      end
    end
  end
  return IsHandled
end

function M:OnContentKeyUp(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = false
  if InKeyName == UIConst.GamePadKey.SpecialRight then
    if self.Input_Name:GetText() == "" then
      self:ForbiddenSearchGuild()
    else
      self:SearchGuild()
    end
    IsHandled = true
  end
  return IsHandled
end

function M:HideAllGamePadIcon()
  self.IsHideAllGamePadIcon = true
  self.Btn_Refresh:SetGamepadIconVisibility(false)
  self.Btn_JoinAll:SetGamepadIconVisibility(false)
  self.Panel_Controller_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Input_Name:SetIsShowGamPadKey(false)
end

function M:ShowAllGamePadIcon()
  self.IsHideAllGamePadIcon = false
  self.Btn_Refresh:SetGamepadIconVisibility(true)
  self.Btn_JoinAll:SetGamepadIconVisibility(true)
  if UIUtils:IsGamepadInput() then
    self.Panel_Controller_Search:SetVisibility(UIConst.VisibilityOp.Visable)
  else
    self.Panel_Controller_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Input_Name:SetIsShowGamPadKey(true)
end

function M:UpdateGamePadIcon(CurInputDevice, CurGamepadName)
  if UIUtils:IsGamepadInput() and not self.IsHideAllGamePadIcon then
    self.Panel_Controller_Search:SetVisibility(UIConst.VisibilityOp.Visable)
  else
    self.Panel_Controller_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:DelayShowGuildList()
  self.List_Guild:ClearListItems()
  self.DelayItemIndex = 1
  self.DelayToShowContentItemTimer = self:AddTimer(0.06, function()
    if self.DelayItemIndex > #self.CurShowGuildList then
      if self.DelayItemIndex <= self:GetMaxItemNumPerPanel() then
        local Content = NewObject(UIUtils.GetCommonItemContentClass())
        Content.IsEmpty = true
        Content.Parent = self
        self.List_Guild:AddItem(Content)
      else
        if self:GetMaxItemNumPerPanel() > #self.CurShowGuildList then
          self.List_Guild:SetEmptyGridItemCount(self:GetMaxItemNumPerPanel() - #self.CurShowGuildList)
        else
          self.List_Guild:SetEmptyGridItemCount(0)
        end
        if self.DelayToShowContentItemTimer then
          self:RemoveTimer(self.DelayToShowContentItemTimer)
          self.DelayToShowContentItemTimer = nil
        end
      end
    else
      local Data = self.CurShowGuildList[self.DelayItemIndex]
      local Content = NewObject(UIUtils.GetCommonItemContentClass())
      Content.Index = self.DelayItemIndex
      Content.ClickCallbackInfo = {
        Func = self.OnGuildListItemClick,
        Obj = self
      }
      Content.Parent = self
      Content.Name = Data.Name
      Content.AuditStatus = Data.AuditStatus
      Content.MemberLimit = Data.MemberLimit
      Content.GuildId = Data.GuildId
      Content.Declaration = Data.Declaration
      Content.Level = Data.Level
      Content.MemberCount = Data.MemberCount
      Content.LogoInfo = Data.LogoInfo
      Content.Score = Data.Score
      Content.ActivityLevel = Data.ActivityLevel
      Content.AutoAgreeJoinRequest = Data.AutoAgreeJoinRequest
      self.List_Guild:AddItem(Content)
      if 1 == self.DelayItemIndex then
        Content.bSelected = true
        Content.IsFocus = true
        self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, Content)
      else
        Content.bSelected = false
      end
    end
    self.DelayItemIndex = self.DelayItemIndex + 1
  end, true, nil, nil, true)
  if 0 == #self.CurShowGuildList then
    self.WS_Type:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("UI_NoGuild"))
    self.SetGuildInfoFuncInfo.Func(self.SetGuildInfoFuncInfo.Obj, nil)
    self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.WS_Type:SetActiveWidgetIndex(0)
    self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    if #self.CurShowGuildList ~= #self.AllGuildList and 1 == #self.CurShowGuildList then
      self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
      self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Bar_CD:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      self.Btn_JoinAll:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
  if (self.List_Guild:HasAnyUserFocus() or self.List_Guild:HasFocusedDescendants() or self.ParentWidget:HasAnyUserFocus()) and 0 == #self.CurShowGuildList then
    self.ParentWidget:SetFocus()
  end
end

function M:GetMaxItemNumPerPanel()
  if self.MaxItemNumPerPanel then
    return self.MaxItemNumPerPanel
  end
  if self.List_Guild:GetNumItems() > 0 then
    local ForgeItemWidgets = self.List_Guild:GetDisplayedEntryWidgets()
    if 0 ~= ForgeItemWidgets:Length() then
      self.MaxItemNumPerPanel = UIUtils.GetListViewContentMaxCount(self.List_Guild, ForgeItemWidgets)
      return self.MaxItemNumPerPanel
    else
      return 10
    end
  else
    return 10
  end
end

return M
