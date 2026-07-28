require("UnLua")
require("Utils.UIUtils")
local GuildController = require("BluePrints.UI.WBP.Guild.Controller.GuildController")
local GuildCommon = require("BluePrints.UI.WBP.Guild.Common.GuildCommon")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.bIsFocusable = true
  M.Super.Construct(self)
end

function M:OnLoaded(...)
  M.Super.OnLoaded(self, ...)
  self.VisitList = {}
  self.bIsSearchState = false
  self.RefreshCoolDownPercent = 0
  self:InitUIWidget()
  self:InitGamepad()
  self:RefreshUIInfo()
  GuildController:RegisterEvent(self, self.OnGuildEvent)
  AudioManager(self):PlayUISound(self, "event:/ui/common/common_panel_normal_expand", "GuildVisitPanel", nil)
end

function M:Destruct()
  self.Input_Name:BindEvent({})
  M.Super.Destruct(self)
  self:StopRefreshCD()
  GuildController:UnRegisterEvent(self)
end

function M:RefreshUIInfo()
  self.FocusItemWidget = nil
  self:PlayAnimation(self.In)
  self:InitGuildList()
  self:SetFocus()
end

function M:InitUIWidget()
  self.Text_Title:SetText(GText("UI_VisitGuildTerritory_2"))
  self.Text_Name:SetText(GText("UI_GuildName_2"))
  self.Text_Heat:SetText(GText("UI_GuildActivity_2"))
  self.Text_EmptyText:SetText(GText("UI_GuildNotFound_2"))
  self.Input_Name:Init({
    Owner = self,
    HintText = GText("UI_SearchGuildByNameOrID_2"),
    TextLimit = 40,
    bNeedPasteBtn = true,
    Events = {
      OnTextChanged = function(Owner, Text)
        if IsValid(Owner) and not Owner:IsBeingRemoveState() then
          Owner:OnSearchTextChanged(Text)
        end
      end
    }
  })
  self.Btn_Close.OnClicked:Add(self, self.OnCloseBtnClicked)
  self.Btn_Search:ForbidBtn(true)
  self.Btn_Search:BindEventOnClicked(self, self.OnSearchBtnClicked)
  self.Btn_Search:BindForbidStateExecuteEvent(self, self.OnSearchBtnClicked)
  self.Btn_Refresh:SetText(GText("UI_RefreshGuildList_2"))
  self.Btn_Refresh:BindEventOnClicked(self, self.OnRefreshBtnClicked)
  self.Btn_Refresh:BindForbidStateExecuteEvent(self, self.OnRefreshBtnClicked)
  self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Bar_CD:SetPercent(1)
  self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Guild:SetScrollBarVisibility(ESlateVisibility.Collapsed)
  self.List_Guild:SetControlScrollbarInside(true)
  self.List_Guild.OnCreateEmptyContent:Bind(self, function(self)
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Parent = self
    return Content
  end)
end

function M:InitGamepad()
  self.Mobile = "Mobile" == CommonUtils.GetDeviceTypeByPlatformName(self)
  if self.Mobile then
    return
  end
  self.Input_Name:SetGamePadKey("X", "LS")
  self.Btn_Refresh:SetGamePadImg("Y")
  self.Controller_Search:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = "Menu",
        Owner = self
      }
    }
  })
  self:UpdateUIStyleInPlatform()
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Left, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Right, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Up, EUINavigationRule.Stop)
  self.List_Guild:SetNavigationRuleBase(EUINavigation.Down, EUINavigationRule.Stop)
  self:SetFocus()
  self:SetIsShowNavigateGuide(false)
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if CurInputDevice == ECommonInputType.Touch then
    return
  end
  if not self:IsVisible() then
    return
  end
  self:UpdateUIStyleInPlatform()
end

function M:UpdateUIStyleInPlatform()
  if self.Mobile then
    return
  end
  local IsGamepad = UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad
  if IsGamepad then
    local FocusWidget = self:BP_GetDesiredFocusTarget()
    FocusWidget:SetFocus()
  end
  self.Panel_Controller_Search:SetVisibility(IsGamepad and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
end

function M:OnComponentFocusChanged(ItemWidget)
  if self.FocusItemWidget and self.FocusItemWidget ~= ItemWidget then
    self.FocusItemWidget:PlayItem_UnHover()
  end
  self.FocusItemWidget = ItemWidget
  self.FocusItemWidget:PlayItem_Hover()
end

function M:BP_GetDesiredFocusTarget()
  if self.FocusItemWidget then
    return self.FocusItemWidget
  end
  if 0 == self.WS_Type:GetActiveWidgetIndex() then
    return self.List_Guild
  end
  return self.Com_EmptyBg
end

function M:Handle_KeyDownOnGamePad(InKeyName)
  local IsHandled = false
  if InKeyName == Const.GamepadFaceButtonUp then
    if self.Btn_Refresh:IsVisible() then
      self:OnRefreshBtnClicked()
    end
    IsHandled = true
  elseif InKeyName == Const.GamepadFaceButtonRight then
    self:OnCloseBtnClicked()
    IsHandled = true
  elseif InKeyName == Const.GamepadFaceButtonLeft then
    self.Input_Name:SetFocus()
    IsHandled = true
  elseif InKeyName == Const.GamepadSpecialRight then
    self:OnSearchBtnClicked()
    IsHandled = true
  elseif InKeyName == Const.GamepadLeftThumbstick then
    local Text = self.Input_Name:GetText()
    if "" == Text then
      self.Input_Name:OnPasteBtnClicked()
      self:OnSearchTextChanged(self.Input_Name:GetText())
    else
      self.Input_Name:OnDeleteBtnClicked()
    end
  end
  return IsHandled
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = not UIUtils.IsGamepadInput()
  if IsHandled then
    if "Escape" == InKeyName then
      self:OnCloseBtnClicked()
    end
  else
    IsHandled = self:Handle_KeyDownOnGamePad(InKeyName)
  end
  return IsHandled
end

function M:RequestRandomVisitList()
  local Avatar = GWorld:GetAvatar()
  Avatar:GuildHomeGetRandomVisitGuild(function(ErrCode, GuildInfos, HeatMeta)
    if 0 ~= ErrCode then
      UIManager(self):ShowError(ErrCode, 1.0, "CommonToastMain")
      return
    end
    self:OnRecvRandomVisitList(GuildInfos)
  end)
end

function M:OnRecvRandomVisitList(DataList)
  local VisitList = self:_NormalizeList(DataList)
  self.RecvVisitList = self:FixVisitingList(VisitList)
  self:RefreshList(self.RecvVisitList)
  if not self.bIsSearchState then
    self:PlayAnimation(self.Refresh)
  end
end

function M:OnGuildEvent(EventId, ...)
  if EventId == GuildCommon.EventID.OnGuildSearch then
    self:OnSearchGuildResult(...)
  elseif EventId == GuildCommon.EventID.OnGuildSearchFail then
    self:OnSearchGuildFail()
  elseif EventId == GuildCommon.EventID.OnGuildGetList then
    self:OnRecvRandomVisitList(...)
  end
end

function M:_NormalizeList(RawList)
  local Result = {}
  if RawList then
    local Model = GuildController:GetModel()
    for _, Info in ipairs(RawList) do
      table.insert(Result, {
        GuildId = Info.GuildId,
        Name = Info.Name,
        Level = Info.Level,
        Heat = Info.Heat or 0,
        LogoInfo = Info.LogoInfo or Model:ParseGuildLogo(Info.Logo)
      })
    end
  end
  return Result
end

function M:FixVisitingList(VisitList)
  local Avatar = GWorld:GetAvatar()
  local CurrentGuildId = Avatar and Avatar.CurrentGuildId
  if not CurrentGuildId then
    return VisitList
  end
  local VisitingIndex
  for Index, Data in ipairs(VisitList) do
    Data.Sort = Index
    Data.IsVisiting = Data.GuildId == CurrentGuildId
    if Data.IsVisiting then
      VisitingIndex = Index
    end
  end
  if not VisitingIndex then
    local GuildSceneGuildInfo = GWorld.GameInstance.GuildSceneGuildInfo or {}
    local Heat = Avatar and Avatar.CurrentGuildOnlineHeat
    Heat = Heat or GuildSceneGuildInfo.GuildHomeData and GuildSceneGuildInfo.GuildHomeData.Heat.CurrentValue or 0
    local VisitingData = {
      GuildId = CurrentGuildId,
      Name = GuildSceneGuildInfo.Name,
      Level = GuildSceneGuildInfo.Level,
      Heat = Heat,
      LogoInfo = GuildSceneGuildInfo.LogoInfo,
      Sort = #VisitList + 1,
      IsVisiting = true
    }
    table.insert(VisitList, VisitingData)
  end
  table.sort(VisitList, function(A, B)
    local IsVisitingA = A and A.IsVisiting == true
    local IsVisitingB = B and B.IsVisiting == true
    if IsVisitingA ~= IsVisitingB then
      return IsVisitingA
    end
    local SortA = tonumber(A and A.Sort) or 0
    local SortB = tonumber(B and B.Sort) or 0
    if SortA ~= SortB then
      return SortA < SortB
    end
    local GuildIdA = tonumber(A and A.GuildId) or 0
    local GuildIdB = tonumber(B and B.GuildId) or 0
    return GuildIdA < GuildIdB
  end)
  return VisitList
end

function M:RefreshList(VisitList)
  VisitList = VisitList or {}
  self.FocusItemWidget = nil
  local Count = #VisitList
  self.WS_Type:SetActiveWidgetIndex(0 == Count and 1 or 0)
  local Avatar = GWorld:GetAvatar()
  local CurrentGuildId = Avatar and Avatar.CurrentGuildId
  self.List_Guild:ClearListItems()
  for Index, Data in ipairs(VisitList) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Data.IsVisiting = Data.GuildId == CurrentGuildId
    Content.Index = Index
    Content.Data = Data
    Content.Parent = self
    self.List_Guild:AddItem(Content)
  end
  self:SetFocus()
  if Count > 0 then
    self.List_Guild:RequestFillEmptyContent()
    self.List_Guild:RequestPlayEntriesAnim()
    self.List_Guild:NavigateToIndex(0)
  end
end

function M:OnSearchTextChanged(Text)
  Text = Text or ""
  self.Btn_Search:ForbidBtn("" == Text)
  if "" == Text then
    self.bIsSearchState = false
    if not self.IsInitGuildList then
      self:RefreshList(self.RecvVisitList)
    end
    self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:OnSearchBtnClicked()
  local Keyword = self.Input_Name:GetText()
  if "" == Keyword then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_PleaseInput_2"))
    return
  end
  self.bIsSearchState = true
  GuildController:SendGuildSearch(Keyword)
end

function M:OnSearchGuildResult(GuildList)
  self:RefreshList(self:_NormalizeList(GuildList))
  self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnSearchGuildFail()
  self:RefreshList({})
  self.Btn_Refresh:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:InitGuildList()
  self.IsInitGuildList = true
  if self.RefreshCoolDownPercent > 0 then
    self:RefreshList(self.RecvVisitList)
  else
    self.WS_Type:SetActiveWidgetIndex(1)
    self:OnRefreshBtnClicked()
  end
  self.IsInitGuildList = nil
end

function M:OnRefreshBtnClicked()
  if self.RefreshCoolDownPercent > 0 then
    UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_RefreshOnCooldown_2"))
    return
  end
  self.bIsSearchState = false
  self:StartRefreshCD()
  self:RequestRandomVisitList()
end

function M:RefreshSearchBtnState(Percent)
  Percent = Percent or 0
  self.RefreshCoolDownPercent = Percent
  self.Bar_CD:SetPercent(Percent)
  if Percent <= 0 then
    self.Btn_Refresh:ForbidBtn(false)
    self.Bar_CD:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Btn_Refresh:ForbidBtn(true)
    if not self.bIsSearchState then
      self.Bar_CD:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:StartRefreshCD()
  self:StopRefreshCD()
  self._RefreshCDTime = GuildCommon.GuildListMinRefreshSec > 0 and GuildCommon.GuildListMinRefreshSec or 1
  self._RefreshCDLeft = self._RefreshCDTime
  self:RefreshSearchBtnState(1)
  local Interval = GuildCommon.GuildGetListCDInterval
  self.RefreshCDTimer = self:AddTimer(Interval, function()
    self._RefreshCDLeft = (self._RefreshCDLeft or 0) - Interval
    if self._RefreshCDLeft <= 0 then
      self:RefreshSearchBtnState(0)
      self:StopRefreshCD()
      return
    end
    self:RefreshSearchBtnState(self._RefreshCDLeft / self._RefreshCDTime)
  end, true, 0, "VisitRefreshCD", true)
end

function M:StopRefreshCD()
  if self.RefreshCDTimer then
    self:RemoveTimer(self.RefreshCDTimer)
    self.RefreshCDTimer = nil
  end
end

function M:OnCloseBtnClicked()
  if self:IsBeingRemoveState() then
    return
  end
  AudioManager(self):SetEventSoundParam(self, "GuildVisitPanel", {ToEnd = 1})
  self:MarkToRemove()
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
end

function M:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    M.Super.Close(self)
  elseif InAnimation == self.Refresh then
    if self:IsBeingRemoveState() then
      return
    end
    local FocusTarget = self:BP_GetDesiredFocusTarget()
    if IsValid(FocusTarget) then
      FocusTarget:SetFocus()
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  local IsHandled = self:OnContentKeyDown(MyGeometry, InKeyEvent)
  if IsHandled then
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
