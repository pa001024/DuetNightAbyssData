local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local COLLECT_REWARD_POPUP_ID = 100431

local function HasValidCollectRewardData(PoolId)
  local PoolData = DataMgr.LimitedPrizePool[PoolId]
  if not PoolData or type(PoolData.ExtraItem) ~= "table" then
    return false
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return false
  end
  local LimitPrizeData = Avatar and Avatar.LimitPrize and Avatar.LimitPrize[PoolId]
  local Round = LimitPrizeData and LimitPrizeData.Round or 1
  local RoundCount = PoolData.LimitedPrizePoolId and #PoolData.LimitedPrizePoolId or 0
  if RoundCount <= 0 then
    return false
  end
  Round = math.min(math.max(Round, 1), RoundCount)
  local RoundId = PoolData.LimitedPrizePoolId and PoolData.LimitedPrizePoolId[Round]
  local RoundData = RoundId and DataMgr.LimitedPrizeItem[RoundId]
  if not RoundData then
    return false
  end
  for RawCategoryIndex, RewardInfo in pairs(PoolData.ExtraItem) do
    local CategoryIndex = tonumber(RawCategoryIndex)
    if CategoryIndex and type(RewardInfo) == "table" then
      local ItemId = tonumber(RewardInfo[1])
      local ItemCount = tonumber(RewardInfo[2])
      local CollectItemIds = RoundData.Id and RoundData.Id[CategoryIndex]
      local CollectItemTypeIndex = RoundData.Type and RoundData.Type[CategoryIndex]
      local CollectItemType = CollectItemTypeIndex and ItemUtils.GetItemType(CollectItemTypeIndex)
      local CollectItemCount = RoundData.Count and RoundData.Count[CategoryIndex]
      if ItemId and ItemId > 0 and ItemCount and ItemCount > 0 and CollectItemType and CollectItemIds and #CollectItemIds > 0 and CollectItemCount and CollectItemCount > 0 then
        return true
      end
    end
  end
  return false
end

function M:Construct()
  self.PoolId = nil
  self.Text:SetText(GText("UI_LimitedPrizePool_CollectReward"))
  if self.Controller then
    self.Controller:CreateGamepadKey(UIConst.GamePadImgKey.LeftThumb)
  end
  self:SetInputType(UIUtils.UtilsGetCurrentInputType(), UIUtils.UtilsGetCurrentGamepadName())
  self:ListenInputTypeChanged()
  self.Btn_Click.AudioEventPath = "event:/ui/activity/shop_small_btn_click"
  self.Btn_Click.OnClicked:Add(self, self.OpenCollectRewardPopup)
end

function M:Destruct()
  self:UnlistenInputTypeChanged()
  self.Btn_Click.OnClicked:Remove(self, self.OpenCollectRewardPopup)
end

function M:ListenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.SetInputType)
  end
end

function M:UnlistenInputTypeChanged()
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(self, 0)
  local GameInputModeSubsystem = UE4.UGameInputModeSubsystem.GetGameInputModeSubsystem(PlayerController)
  if IsValid(GameInputModeSubsystem) then
    GameInputModeSubsystem.OnInputMethodChanged:Remove(self, self.SetInputType)
  end
end

function M:SetInputType(NewInputType, NewGamepadName)
  if not self.Controller then
    return
  end
  if NewInputType == ECommonInputType.Gamepad then
    self.Controller:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self.Controller:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:Init(PoolId)
  self.PoolId = PoolId
  self:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
end

function M:OpenCollectRewardPopup()
  if not HasValidCollectRewardData(self.PoolId) then
    DebugPrint("WBP_LimitedPrizePool_CollectReward_Doll_C: no valid collect reward data, PoolId is", self.PoolId)
    return
  end
  UIManager(self):ShowCommonPopupUI(COLLECT_REWARD_POPUP_ID, {
    PoolId = self.PoolId
  }, self)
end

return M
