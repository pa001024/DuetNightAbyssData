require("UnLua")
local ChatController = require("BluePrints.UI.WBP.Chat.ChatController")
local ChatModel = ChatController:GetModel()
local M = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase")

function M:InitContent(Params, PopupData, Owner)
  self.Super.InitContent(self, Params, PopupData, Owner)
  self.Owner = Owner
  self.Owner.bShoulFocusToLastFocusedWidget = false
  self.SelectType = "Search"
  ChatController:SetIsEnterChannelContent(true)
  self:InitCommonUI()
  self:BindDialogEvent(DialogEvent.OnTitleTabSelected, self.OnChatTabSelected)
  ChatController:RegisterEvent(self, function(self, EventId, ...)
    if EventId == ChatCommon.EventID.RecvAllChatChannel then
      self.Com_Search:SetHintText(string.format(GText("InputChannelNumberRange"), ChatModel.FirstIndex, ChatModel.LastIndex))
    elseif EventId == ChatCommon.EventID.EnterChatChannel then
      local ErrCode, ChannelType, ChannelIndex, online_type = ...
      self:HandleSwitchChannelIndex(ErrCode, ChannelType, ChannelIndex, online_type)
    elseif EventId == ChatCommon.EventID.RecvChannelPlayerNum and self.SelectType == "History" then
      self:InitHistoryItems(ChatModel:GetNumbersContainingOfHistory())
    end
  end)
  EventManager:AddEvent(EventID.OnChannelIndexSelect, self, self.SelectChannelIndex)
  EventManager:AddEvent(EventID.OnSendChannelIndexSelect, self, self.OnSendChannelIndexSelect)
end

function M:HandleSwitchChannelIndex(ErrCode, ChannelType, ChannelIndex, online_type)
  if 0 ~= ErrCode then
    return
  end
  self:RemoveTimer("ChannelSwitchSuccess")
  self:AddTimer(0.1, function()
    UIManager(self):ShowUITip(UIConst.Tip_CommonTop, GText("ChannelSwitchSuccess"))
  end, false, 0, "ChannelSwitchSuccess")
  self.Owner:ForbidRightBtn(true)
  local Text
  if ChatModel:IsInRegionOnlineChannelType() then
    Text = string.format(GText("SwitchedToChannel"), GText(DataMgr.RegionOnline[ChatModel:GetRegionId()].RegionChannelName) .. "(" .. ChannelIndex .. ")")
  else
    Text = string.format(GText("SwitchedToChannel"), string.format(GText("WorldChannelWithParam"), ChannelIndex))
  end
  ChatController:RecvUpdateChannelIndexChatToWorld(Text, ChannelType)
  EventManager:FireEvent(EventID.OnSelectChannelSuccess, ChannelType, ChannelIndex, online_type)
end

function M:FilterInput(Input)
  local Digits = Input:gsub("%D", "")
  if "" == Digits then
    return ""
  end
  local Len = #Digits
  if Len <= 2 then
    return Digits
  end
  local FirstNonZero = Digits:find("[^0]")
  if not FirstNonZero then
    return "0"
  end
  local Trimmed = Digits:sub(FirstNonZero)
  if #Trimmed > 2 then
    return Trimmed:sub(1, 2)
  else
    return Trimmed
  end
end

function M:SelectChannelIndex(SelectIndex)
  if not SelectIndex or SelectIndex == ChatModel:GetChannelIndex(ChatModel:GetCurrentChannel()) then
    self.Owner:ForbidRightBtn(true)
  else
    self.Owner:ForbidRightBtn(false)
  end
end

function M:OnSendChannelIndexSelect()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  if ChatModel:IsInRegionOnlineChannelType() then
    Avatar:ActiveSwitchToRegionOnlineChannel(ChatModel:GetRegionId(), ChatModel:GetSelectChannelIndex())
  else
    Avatar:RequestEnterWorldOneChannel(ChatModel:GetCurrentChannel(), ChatModel:GetSelectChannelIndex())
  end
end

function M:InitCommonUI()
  self.Com_Search:SetHintText(string.format(GText("InputChannelNumberRange"), ChatModel.FirstIndex, ChatModel.LastIndex))
  self.Key_Search:CreateGamepadKey("X")
  self.Key_Cancel:CreateGamepadKey("LS")
  self.List_Channel:ClearListItems()
  self.WS_Content:SetActiveWidgetIndex(1)
  self.Text_Empty:SetText(GText("PleaseSearchFirst"))
  self.List_Channel:SetScrollbarVisibility(UIConst.VisibilityOp.Collapsed)
  self.List_Channel:SetControlScrollbarInside(true)
  self.Com_Search:BindEventOnContentChanged(self, function(_, Text)
    local NewText = self:FilterInput(Text)
    self.Com_Search:SetText(NewText)
    local SearchNum = tonumber(NewText)
    if SearchNum and 0 ~= SearchNum then
      if "" ~= SearchNum and UIUtils.IsGamepadInput() then
        self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
      end
      self:HandleSearchTextUpdate(SearchNum)
    else
      if UIUtils.IsGamepadInput() then
        self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.Collapsed)
      end
      self:InitSearchItems()
    end
  end)
end

function M:HandleSearchTextUpdate(SearchNum)
  if not SearchNum then
    return
  end
  local Results = ChatModel:GetNumbersContainingOfSearch(SearchNum)
  self:InitSearchItems(Results)
end

function M:RefreshSelectChannel(Results)
  if UIUtils.IsGamepadInput() and Results and #Results > 0 then
    ChatModel:SetSelectChannelIndex(Results and Results[1].Idx)
  else
    ChatModel:SetSelectChannelIndex()
  end
  self.List_Channel:ClearListItems()
  self.Results = Results
  self.Owner:ForbidRightBtn(true)
  for Index, Data in ipairs(Results or {}) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.ChannelIndex = Data.Idx
    Content.State = Data.State
    Content.ParentWidget = self
    Content.Index = Index
    self.List_Channel:AddItem(Content)
  end
  self.List_Channel.OnCreateEmptyContent:Bind(self, function(self)
    local Obj = NewObject(UIUtils.GetCommonItemContentClass())
    Obj.IsEmpty = true
    Obj.ParentWidget = self
    return Obj
  end)
  self.List_Channel:RequestFillEmptyContent()
  self.List_Channel:SetEmptyGridItemCount(0)
end

function M:SetUserWidgetFocus(Widget)
  if not UIUtils.IsGamepadInput() then
    return
  end
  Widget:SetFocus()
end

function M:InitSearchItems(Results)
  self:RefreshSelectChannel(Results)
  if not Results then
    self:SetUserWidgetFocus(self.Owner)
    self.WS_Content:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("PleaseSearchFirst"))
  elseif 0 == #Results then
    self:SetUserWidgetFocus(self.Owner)
    self.WS_Content:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("NoChannelFound"))
  else
    self.WS_Content:SetActiveWidgetIndex(0)
  end
end

function M:InitHistoryItems(Results)
  self:RefreshSelectChannel(Results)
  if not Results or 0 == #Results then
    self.WS_Content:SetActiveWidgetIndex(1)
    self.Text_Empty:SetText(GText("NoHistoryChannels"))
  else
    self.WS_Content:SetActiveWidgetIndex(0)
    self:NavigateToItem()
  end
  self.Com_Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:Destruct()
  self.Owner.bShoulFocusToLastFocusedWidget = true
  self:RemoveTimer("ChannelSwitchSuccess")
  EventManager:RemoveEvent(EventID.OnChannelIndexSelect, self)
  EventManager:RemoveEvent(EventID.OnSendChannelIndexSelect, self)
  ChatController:UnRegisterEvent(self)
  ChatController:SetIsEnterChannelContent(false)
  ChatModel:SetSelectChannelIndex()
  self:UnbindDialogEvent(DialogEvent.OnTitleTabSelected)
end

function M:ChangeToSearchList()
  self.SelectType = "Search"
  self:InitSearchItems()
  self.Com_Empty:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.Group_Search:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if self.SelectType == "Search" and UIUtils.IsGamepadInput() then
    local Text = self.Com_Search:GetText()
    if "" ~= Text then
      self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:ChangeToHistoryList()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  self:SetUserWidgetFocus(self.Owner)
  self.SelectType = "History"
  if ChatModel:IsInRegionOnlineChannelType() then
    Avatar:QueryRegionOnlineChannelState(ChatModel:GetRegionId(), ChatModel:GetRecvChannelIndex())
  else
    Avatar:QueryChatChannelBusyInfo(ChatModel:GetRecvChannelIndex())
  end
  self.Com_Search:SetText("")
  self.Com_Empty:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Group_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnChatTabSelected(TabWidget)
  if 1 == TabWidget.Idx then
    self:ChangeToSearchList()
  else
    self:ChangeToHistoryList()
  end
end

function M:OnContentKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if self.SelectType == "Search" then
    if InKeyName == UIConst.GamePadKey.FaceButtonLeft then
      UIManager(self):LoadUINew("CommonNumInput", UIConst.InputNumMode.NUMBER, {
        ConfirmCB = {
          Obj = self,
          Func = self.ExecOnTextAfterNumInput
        },
        TextLimit = 2
      })
    elseif InKeyName == UIConst.GamePadKey.LeftThumb then
      self:ExecOnTextAfterNumInput("")
      self:SetUserWidgetFocus(self.Owner)
    end
  end
end

function M:ExecOnTextAfterNumInput(TempNumber)
  self.Com_Search:SetText(TempNumber)
end

function M:InitGamepadView()
  if self.SelectType == "Search" then
    local Text = self.Com_Search:GetText()
    if "" ~= Text then
      self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Key_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if self.List_Channel:GetNumItems() > 0 and self.Results then
    if not ChatModel:GetSelectChannelIndex() and self.Results then
      ChatModel:SetSelectChannelIndex(self.Results[1].Idx)
    end
    self:NavigateToItem()
    EventManager:FireEvent(EventID.OnChatUpdateInput)
  else
    self:SetUserWidgetFocus(self.Owner)
  end
end

function M:InitKeyboardView()
  self.Key_Search:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.Key_Cancel:SetVisibility(UIConst.VisibilityOp.Collapsed)
  EventManager:FireEvent(EventID.OnChatUpdateInput)
end

function M:NavigateToItem()
  local ChannelIndex = ChatModel:GetSelectChannelIndex()
  if not ChannelIndex or not self.Results then
    return
  end
  local Index
  for i, Data in ipairs(self.Results) do
    if Data.Idx == ChannelIndex then
      Index = i
      break
    else
      Index = Index or i
    end
  end
  self.List_Channel:NavigateToIndex(Index - 1)
end

function M:HandleDialogFocused()
  local ChannelIndex = ChatModel:GetSelectChannelIndex()
  if not ChannelIndex or not self.Results then
    return
  end
  local Widget, Index
  for i, Data in ipairs(self.Results) do
    local Content = self.List_Channel:GetItemAt(i - 1)
    if Data.Idx == ChannelIndex then
      if Content.SelfWidget then
        Widget = Content.SelfWidget
        Index = i
        break
      end
    elseif Content.SelfWidget and not Widget then
      Widget = Content.SelfWidget
      Index = i
    end
  end
  if Widget then
    self.List_Channel:NavigateToIndex(Index - 1)
  end
  return Widget
end

return M
