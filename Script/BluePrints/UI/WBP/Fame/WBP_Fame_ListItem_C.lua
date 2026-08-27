require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.BtnReward_1.Button_Area.OnClicked:Add(self, self.OnReceiveBtnClicked)
  self.BtnReward_1:SetGamePadImg("A")
end

function M:Destruct()
  self.BtnReward_1.Button_Area.OnClicked:Remove(self, self.OnReceiveBtnClicked)
end

function M:OnListItemObjectSet(Content)
  rawset(self, "Content", Content)
  rawset(self, "State", Content.State)
  rawset(self, "State", Content.State)
  rawset(self, "Level", Content.Level)
  rawset(self, "RewardID", Content.RewardID)
  rawset(self, "FameModel", Content.FameModel)
  rawset(self, "RegionId", Content.RegionId)
  rawset(self, "Parent", Content.Parent)
  rawset(self, "Index", Content.Index)
  rawset(self, "OnMenuOpenChanged", Content.OnMenuOpenChanged)
  rawset(self, "OnReceiveRewardCallBack", Content.OnReceiveRewardCallBack)
  rawset(self, "IsFameTaskItem", Content.IsFameTaskItem)
  rawset(self, "QuestId", Content.QuestId)
  rawset(self, "Description", Content.Description)
  rawset(self, "ResourceId", Content.ResourceId)
  rawset(self, "ExpCount", Content.ExpCount)
  self.RichTextContent:SetText(string.format(GText("ReputationLevel_ListContent"), self.Level))
  if self.IsFameTaskItem then
    self:InitRewardList_FameTaskItem()
    self.RichTextContent:SetText(GText(self.Description))
  else
    self:InitRewardList()
  end
  self:InitBtn()
  Content.SelfWidget = self
end

function M:InitRewardList_FameTaskItem()
  local resourceData = DataMgr.Resource[self.ResourceId]
  if not resourceData then
    UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find ResourceId Data %d", self.ResourceId))
    return
  end
  self.ListItem:ClearListItems()
  local Content = NewObject(UIUtils.GetCommonItemContentClass())
  local Id = self.ResourceId
  local Type = "Resource"
  local ResourceInfo = resourceData
  Content.ItemType = Type
  Content.Id = Id
  Content.Rarity = ResourceInfo.Rarity
  Content.Icon = ResourceInfo.Icon
  Content.IsShowDetails = true
  Content.Count = self.ExpCount
  Content.bHasGot = self.State == CommonConst.FameRewardState.AlreadyClaimed
  Content.OnMenuOpenChangedEvents = {
    Obj = self.Parent,
    Callback = self.OnMenuOpenChanged
  }
  self.ListItem:AddItem(Content)
end

function M:InitRewardList()
  local RewardData = DataMgr.Reward[self.RewardID]
  if not RewardData then
    UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find RewardID Data %d", self.RewardID))
    return
  end
  self.ListItem:ClearListItems()
  for i = 1, #RewardData.Id do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    local Id = RewardData.Id[i]
    local Type = RewardData.Type[i]
    local ResourceInfo
    if DataMgr[Type] and DataMgr[Type][Id] then
      ResourceInfo = DataMgr[Type][Id]
    else
      UEPrint(string.format("WBP_Fame_ListItem_C InitRewardList not find ResourceInfo Data Type:%s Id:%d", tostring(Type), tostring(Id)))
      ResourceInfo = {
        Rarity = 1,
        Icon = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Monster/T_Head_Empty.T_Head_Empty'"
      }
    end
    Content.ItemType = Type
    Content.Id = Id
    Content.Rarity = ResourceInfo.Rarity
    Content.Icon = ResourceInfo.Icon
    Content.IsShowDetails = true
    Content.Count = RewardData.Count[i][1]
    Content.bHasGot = self.State == CommonConst.FameRewardState.AlreadyClaimed
    Content.OnMenuOpenChangedEvents = {
      Obj = self.Parent,
      Callback = self.OnMenuOpenChanged
    }
    self.ListItem:AddItem(Content)
  end
end

function M:InitBtn()
  local SwitcherIdx = 0
  if self.State == CommonConst.FameRewardState.ReadyClaim then
    SwitcherIdx = 0
    self.BtnReward_1:SetText(GText("UI_GameEvent_ClaimReward"))
  elseif self.State == CommonConst.FameRewardState.AlreadyClaimed then
    SwitcherIdx = 1
  elseif self.State == CommonConst.FameRewardState.NotClaimable then
    SwitcherIdx = 2
    self.TextBlock_92:SetText(GText("UI_EventReward_NotAchieved"))
  end
  self.Switcher_Btn:SetActiveWidgetIndex(SwitcherIdx)
end

function M:OnReceiveBtnClicked()
  if self.State ~= CommonConst.FameRewardState.ReadyClaim then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    if self.IsFameTaskItem and self.IsFameTaskItem == true then
      Avatar:GetExperienceQuestReward(self.QuestId, self.OnReceiveRewardCallBack)
    else
      Avatar:GetRegionReputationLevelReward(self.RegionId, {
        self.Level
      }, self.OnReceiveRewardCallBack)
    end
  end
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.FaceButtonBottom then
    if self.State == CommonConst.FameRewardState.ReadyClaim then
      self:OnReceiveBtnClicked()
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonLeft then
    if self.ListItem:GetNumItems() > 0 then
      rawset(self, "bFocusedList", true)
      self.ListItem:NavigateToIndex(0)
      self.ListItem:SetFocus()
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight and self.bFocusedList then
    rawset(self, "bFocusedList", false)
    self:SetFocus()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:OnFocusReceived(MyGeometry, InFocusEvent)
  self.Parent.UpdateSelectedRewardIdx(self.Parent, self.Index)
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
    rawset(self, "bFocused", true)
    self:UpdateGamePadStyle()
    self:PlayAnimation(self.Hover)
    return UE4.UWidgetBlueprintLibrary.Handled()
  end
  return UE4.UWidgetBlueprintLibrary.Unhandled()
end

function M:OnFocusLost(InFocusEvent)
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad then
    if self.bFocused then
      self:PlayAnimation(self.UnHover)
    end
    rawset(self, "bFocused", false)
    self:UpdateGamePadStyle()
  end
end

function M:UpdateGamePadStyle()
  if self.Parent.CurInputDeviceType == ECommonInputType.Gamepad and self.bFocused then
    if not rawget(self, "GamePadKeyInited") then
      rawset(self, "GamePadKeyInited", true)
      self.WBP_Com_KeyImg:CreateCommonKey({
        KeyInfoList = {
          {
            Type = "Img",
            ImgLongPath = UIUtils.UtilsGetKeyIconPathInGamepad("X", self.Parent.CurGamepadName)
          }
        }
      })
    end
    self.WBP_Com_KeyImg:SetVisibility(self.ListItem:GetNumItems() > 0 and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
    self:AddDelayFrameFunc(function()
      self.BtnReward_1:SetGamePadVisibility(self.State == CommonConst.FameRewardState.ReadyClaim and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
      self:SetFocus()
    end, 1)
  else
    if self.bFocused then
      self:PlayAnimation(self.UnHover)
    end
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
    self:AddDelayFrameFunc(function()
      self.BtnReward_1:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
    end, 1)
  end
end

return M
