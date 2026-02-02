require("UnLua")
local RegionFameController = require("BluePrints.UI.WBP.Fame.RegionFameController")
local RegionFameModel = RegionFameController:GetModel()
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Add(self, self.OnGetAllRewardsBtnClicked)
end

function M:Destruct()
  self.Fame_CompletionProgress.Btn_Reward.Button_Area.OnClicked:Remove(self, self.OnGetAllRewardsBtnClicked)
end

function M:InitUIInfo(Name, IsInUIMode, EventList, ...)
  self.Super.InitUIInfo(self, Name, IsInUIMode, EventList, ...)
  local CurRegionId = (...)
  rawset(self, "CurRegionId", CurRegionId and tonumber(CurRegionId) or 1001)
  self:InitTitleDetail()
  self:RefreshRewardList()
  if IsValid(self.GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(self.GameInputModeSubsystem:GetCurrentInputType(), self.GameInputModeSubsystem:GetCurrentGamepadName())
  end
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRewardIn", nil)
end

function M:InitTitleDetail()
  local CurRegionName = self:GetRegionName(self.CurRegionId)
  self.Com_Tab:Init({
    DynamicNode = {
      "Back",
      "ResourceBar",
      "BottomKey"
    },
    BottomKeyInfo = {
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    },
    StyleName = "Text",
    TitleName = string.format("%s·%s", GText(CurRegionName), GText("ReputationLevelReward_Title")),
    OwnerPanel = self,
    BackCallback = self.CloseSelf
  })
end

function M:InitLeftReward()
  local Content = {}
  Content.CurRegionId = self.CurRegionId
  Content.Parent = self
  local FameLevel = RegionFameModel:GetRegionFameLevel(self.CurRegionId)
  Content.CurrentFameLevel = FameLevel
  Content.OnMenuOpenChanged = self.OnMenuOpenChanged
  self.Reward:Init(Content)
  self.WidgetSwitcher_0:SetActiveWidgetIndex(0)
end

function M:RefreshRewardList()
  local AllRewardsData = DataMgr.ReputationLevel[self.CurRegionId]
  if not AllRewardsData then
    return
  end
  local FirstReadyClaimIndex, FirstNotClaimableIndex
  local AllReadyClaimRewards = {}
  local FinishedRewardNum = 0
  local TotalRewardNum = #AllRewardsData
  self.List_Item:ClearListItems()
  for Index, RewardInfo in ipairs(AllRewardsData) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.Level = RewardInfo.ReputationLevel
    Content.State = RegionFameModel:GetTargetLevelRewardState(self.CurRegionId, Content.Level)
    Content.RewardID = RewardInfo.Reward
    Content.FameModel = RegionFameModel
    Content.RegionId = self.CurRegionId
    Content.Parent = self
    Content.Index = Index - 1
    
    function Content.OnReceiveRewardCallBack(Ret, RewardReturn, ReputationId, LevelInfo)
      if Ret and Ret == ErrorCode.RET_SUCCESS then
        self:RefreshRewardList()
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
          self:SetFocus()
        end, self)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end
    
    Content.OnMenuOpenChanged = self.OnMenuOpenChanged
    self.List_Item:AddItem(Content)
    if Content.State == CommonConst.FameRewardState.AlreadyClaimed then
      FinishedRewardNum = FinishedRewardNum + 1
    elseif Content.State == CommonConst.FameRewardState.ReadyClaim then
      FirstReadyClaimIndex = FirstReadyClaimIndex or Index
      table.insert(AllReadyClaimRewards, Content.Level)
    elseif Content.State == CommonConst.FameRewardState.NotClaimable and not FirstNotClaimableIndex then
      FirstNotClaimableIndex = Index
    end
  end
  rawset(self, "AllReadyClaimRewards", AllReadyClaimRewards)
  rawset(self, "FirstReadyClaimIndex", FirstReadyClaimIndex)
  rawset(self, "FirstNotClaimableIndex", FirstNotClaimableIndex)
  rawset(self, "FinishedRewardNum", FinishedRewardNum)
  rawset(self, "TotalRewardNum", TotalRewardNum)
  self:RewardListAutoScroll()
  self.Fame_CompletionProgress.Text01:SetText(string.format(GText("UI_Party_Parkour_FinishingRate") .. ": "))
  self.Fame_CompletionProgress.Text_Now:SetText(string.format("%d", FinishedRewardNum))
  self.Fame_CompletionProgress.Text_Total:SetText(string.format("%d", TotalRewardNum))
  if 0 == #self.AllReadyClaimRewards then
    self.Fame_CompletionProgress.Btn_Reward:SetVisibility(UIConst.VisibilityOp.Collapsed)
  else
    self.Fame_CompletionProgress.Btn_Reward:SetText(GText("UI_Mail_Recieveall"))
    self.Fame_CompletionProgress.Btn_Reward:SetVisibility(UIConst.VisibilityOp.Visible)
  end
  self:InitLeftReward()
end

function M:RewardListAutoScroll()
  if self.FirstReadyClaimIndex then
    self.List_Item:NavigateToIndex(self.FirstReadyClaimIndex - 1)
  elseif self.FirstNotClaimableIndex then
    self.List_Item:NavigateToIndex(self.FirstNotClaimableIndex - 1)
  else
    self.List_Item:NavigateToIndex(self.List_Item:GetNumItems() - 1)
  end
end

function M:OnGetAllRewardsBtnClicked()
  if self.Fame_CompletionProgress.Btn_Reward:GetVisibility() == ESlateVisibility.Collapsed then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if Avatar then
    Avatar:GetRegionReputationLevelReward(self.CurRegionId, self.AllReadyClaimRewards, function(Ret, RewardReturn, ReputationId, LevelInfo)
      if Ret and Ret == ErrorCode.RET_SUCCESS then
        self:RefreshRewardList()
        UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, RewardReturn, false, function()
          self:SetFocus()
        end, self)
      else
        UIManager(self):ShowUITip(UIConst.Tip_CommonToast, string.format("ErrorCode :%d", Ret))
      end
    end)
  end
end

function M:GetRegionName(CurRegionId)
  if self.CurRegionName then
    return self.CurRegionName
  end
  CurRegionId = tonumber(CurRegionId)
  local CurRegionData = DataMgr.RegionReputation[CurRegionId]
  if not CurRegionData then
    return
  end
  local CurRegionName = CurRegionData.RegionName
  rawset(self, "CurRegionName", CurRegionName)
  return CurRegionName
end

function M:CloseSelf()
  if self:IsAnimationPlaying(self.Auto_Out) then
    return
  end
  self:BlockAllUIInput(true, "SP_DisplayOnly")
  self:BeginAnimOutToExitWithInStack(true)
  self:Close()
  AudioManager(self):PlayUISound(self, "event:/ui/armory/open", "FameRewardIn", nil)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local IsEventHandled = false
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) then
    IsEventHandled = self:Handle_OnGamePadButtonDown(InKeyName)
    if not IsEventHandled then
      IsEventHandled = self.Com_Tab:Handle_KeyEventOnGamePad(InKeyName)
    end
  else
    IsEventHandled = self.Com_Tab:Handle_KeyEventOnPC(InKeyName)
    IsEventHandled = IsEventHandled or self:Handle_OnPCButtonDown(InKeyName)
  end
  if IsEventHandled then
    return UE4.UWidgetBlueprintLibrary.Handled()
  else
    return UE4.UWidgetBlueprintLibrary.UnHandled()
  end
end

function M:Handle_OnGamePadButtonDown(InKeyName)
  local IsEventHandled = false
  if InKeyName == UIConst.GamePadKey.LeftThumb then
    self.bPreviewingAllRewards = true
    self:SetFocus()
    IsEventHandled = true
  elseif InKeyName == UIConst.GamePadKey.FaceButtonRight then
    if self.bPreviewingAllRewards then
      self.bPreviewingAllRewards = nil
      self:SetFocus()
      IsEventHandled = true
    end
  elseif InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnGetAllRewardsBtnClicked()
  end
  return IsEventHandled
end

function M:Handle_OnPCButtonDown(InKeyName)
  local IsEventHandled = false
  if "A" == InKeyName then
    self.Fame_Tab:TabToLeft()
    IsEventHandled = true
  elseif "D" == InKeyName then
    self.Fame_Tab:TabToRight()
    IsEventHandled = true
  end
  return IsEventHandled
end

function M:SetFocus()
  if self.bPreviewingAllRewards then
    self.Reward.List_Item:SetFocus()
  else
    self:RewardListAutoScroll()
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  rawset(self, "CurInputDeviceType", CurInputDevice)
  rawset(self, "CurGamepadName", CurGamepadName)
  self:UpdateUIStyleInPlatform()
  self:SetFocus()
end

function M:UpdateUIStyleInPlatform()
  if self.SelectedRewardIdx then
    local Item = self.List_Item:GetItemAt(self.SelectedRewardIdx)
    if Item.SelfWidget then
      Item.SelfWidget:UpdateGamePadStyle()
    end
  end
  if self.CurInputDeviceType == ECommonInputType.Gamepad then
    if not rawget(self, "GamePadKeyInited") then
      rawset(self, "GamePadKeyInited", true)
      local ImgPath = UIUtils.UtilsGetKeyIconPathInGamepad("Y", self.CurGamepadName)
      local Img = LoadObject(ImgPath)
      self.Fame_CompletionProgress.Btn_Reward.Img_GamePad:SetBrushResourceObject(Img)
    end
    self.Fame_CompletionProgress.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Fame_CompletionProgress.Btn_Reward:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
  self.Reward:UpdateUIStyleInPlatform()
end

function M:UpdateSelectedRewardIdx(NewIdx)
  rawset(self, "SelectedRewardIdx", NewIdx)
end

function M:OnMenuOpenChanged(IsOpen)
  if IsOpen then
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        }
      }
    })
  else
    self.Com_Tab:UpdateBottomKeyInfo({
      {
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "A",
            Owner = self
          }
        },
        Desc = GText("UI_Tips_Ensure")
      },
      {
        KeyInfoList = {
          {
            Type = "Text",
            Text = "Esc",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        GamePadInfoList = {
          {
            Type = "Img",
            ImgShortPath = "B",
            ClickCallback = self.CloseSelf,
            Owner = self
          }
        },
        Desc = GText("UI_BACK")
      }
    })
  end
end

return M
