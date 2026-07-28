require("UnLua")
local Model = require("BluePrints.UI.WBP.Activity.Widget.Weapon.WeaponVerifyUIModel")
local UIUtils = require("Utils.UIUtils")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local STAR_ICON_PATH = "Texture2D'/Game/UI/Texture/Static/Atlas/Activity/T_Activity_Weapon_Star.T_Activity_Weapon_Star'"
local REDDOT_NAME = Model.RewardReddotNode

function M:Construct()
  self.BtnArea.OnClicked:Add(self, self.OnBtnClicked)
  if IsValid(self.TextTitle) then
    self.TextTitle:SetText(GText("RaidDungeon_Rank_Task"))
  end
  local PC = UE4.UGameplayStatics.GetPlayerController(self, 0)
  self.KeySubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(PC)
  if IsValid(self.KeySubsystem) then
    self.KeySubsystem.OnInputMethodChanged:Add(self, self.OnInputMethodChangedForKey)
  end
  ReddotManager.AddListenerEx(REDDOT_NAME, self, self.OnRewardReddotChanged)
end

function M:Destruct()
  self.BtnArea.OnClicked:Remove(self, self.OnBtnClicked)
  if IsValid(self.KeySubsystem) then
    self.KeySubsystem.OnInputMethodChanged:Remove(self, self.OnInputMethodChangedForKey)
    self.KeySubsystem = nil
  end
  ReddotManager.RemoveListener(REDDOT_NAME, self)
end

function M:OnRewardReddotChanged(Count)
  if IsValid(self.Reddot) then
    local HasRed = (Count or 0) > 0
    self.Reddot:SetVisibility(HasRed and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnInputMethodChangedForKey(CurInputDevice)
  self:RefreshGamepadKey(CurInputDevice == ECommonInputType.Gamepad)
end

function M:HandleKeyDownOnGamePad(InKeyName)
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnBtnClicked()
    return true
  end
  return false
end

function M:Init(ActivityConfigData)
  self.EventId = ActivityConfigData and ActivityConfigData.EventId
  self:Refresh()
end

function M:Update()
  self:Refresh()
end

function M:SetData(EventId, Owner, OnClick)
  self.EventId = EventId
  self.Owner = Owner
  self.OnClick = OnClick
  self:Refresh()
end

function M:Refresh()
  if not self.EventId then
    return
  end
  local Now = Model.GetTotalStars(self.EventId)
  local Max = Model.GetActivityMaxStar(self.EventId)
  if IsValid(self.TextNumNow) then
    self.TextNumNow:SetText(tostring(Now))
  end
  if IsValid(self.TextNumTotal) then
    self.TextNumTotal:SetText("/" .. tostring(Max))
  end
  Model.RefreshStarRewardReddot(self.EventId)
  if IsValid(self.Reddot) then
    local HasRed = Model.HasStarRewardCanGet(self.EventId)
    self.Reddot:SetVisibility(HasRed and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
  self:RefreshGamepadKey(UIUtils.IsGamepadInput())
end

function M:RefreshGamepadKey(IsUseGamePad)
  if not IsValid(self.WBP_Com_KeyImg) then
    return
  end
  if IsUseGamePad then
    self.WBP_Com_KeyImg:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonTop)
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.HitTestInvisible)
  else
    self.WBP_Com_KeyImg:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnBtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_gift_btn_click", nil, nil)
  if self.Owner and self.OnClick then
    self.OnClick(self.Owner, self.EventId)
    return
  end
  self:OpenRewardPopup()
end

function M:OpenRewardPopup(CloseObj, CloseFunc)
  local EventId = self.EventId
  if not EventId then
    return
  end
  local Now = Model.GetTotalStars(EventId)
  local List = Model.GetRewardList(EventId)
  local MaxStar = 0
  for _, Cfg in ipairs(List) do
    MaxStar = math.max(MaxStar, Cfg.RequiredStar or 0)
  end
  local Items = {}
  for _, Cfg in ipairs(List) do
    local RS = Model.RewardState
    local State = Model.GetRewardState(EventId, Cfg)
    local Item = {
      ItemId = Cfg.RewardId,
      CanReceive = State == RS.CanGet,
      RewardsGot = State == RS.Got,
      ReddotName = REDDOT_NAME,
      ReceiveCallBack = M.OnGetReward,
      ReceiveParm = {
        EventId = EventId,
        RewardId = Cfg.RewardId
      },
      NotreachText = GText("UI_Archive_CollectionInProgress"),
      Hint = GText("UI_TempleEvent_RewardTarget"),
      SourceNum = Cfg.RequiredStar,
      ShowIcon = true,
      IconPath = STAR_ICON_PATH,
      Rewards = self:BuildRewards(Cfg.Reward)
    }
    table.insert(Items, Item)
  end
  local Params = {
    Title = GText("UI_Event_Reward"),
    ConfigData = {
      HasTab = false,
      ShowIcon = true,
      IconPath = STAR_ICON_PATH,
      ReddotName = REDDOT_NAME,
      Items = Items,
      NowNum = Now,
      NumMax = MaxStar,
      Text_Total = string.format(GText("UI_TempleEvent_StarHasGot"), Now, MaxStar),
      ReceiveAllCallBack = M.OnGetAllRewards,
      ReceiveAllParam = {EventId = EventId},
      ReceiveButtonText = GText("UI_Archive_CollectionClaimAll")
    }
  }
  if CloseObj and CloseFunc then
    Params.OnCloseCallbackObj = CloseObj
    Params.OnCloseCallbackFunction = CloseFunc
  end
  UIManager(self):ShowCommonPopupUI(100158, Params)
end

function M:BuildRewards(RewardId)
  local Rewards = {}
  local RewardInfo = DataMgr.Reward and DataMgr.Reward[RewardId]
  if not RewardInfo then
    return Rewards
  end
  local Ids = RewardInfo.Id or {}
  local Counts = RewardInfo.Count or {}
  local Types = RewardInfo.Type or {}
  for i = 1, #Ids do
    table.insert(Rewards, {
      ItemType = Types[i],
      ItemId = Ids[i],
      Count = RewardUtils:GetCount(Counts[i]),
      Rarity = ItemUtils.GetItemRarity(Ids[i], Types[i])
    })
  end
  return Rewards
end

function M:OnGetReward(Content)
  local EventId = Content.ConfigData.ReceiveParm.EventId
  local RewardId = Content.ConfigData.ReceiveParm.RewardId
  
  local function CallBack(ErrCode, Ret)
    if 0 == ErrCode then
      Content.ConfigData.CanReceive = false
      Content.ConfigData.RewardsGot = true
      if Content.SelfWidget then
        Content.SelfWidget:RefreshBtn(true)
      end
      if Content.Owner then
        Content.Owner:RefreshButton(Model.HasStarRewardCanGet(EventId))
      end
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
  end
  
  Model.GetStarReward(EventId, RewardId, CallBack)
end

function M:OnGetAllRewards(Parm)
  local EventId = Parm.EventId
  
  local function CallBack(ErrCode, Ret)
    if 0 == ErrCode then
      if Parm.SelfWidget and Parm.SelfWidget.List_Item then
        for i = 0, Parm.SelfWidget.List_Item:GetNumItems() - 1 do
          local Item = Parm.SelfWidget.List_Item:GetItemAt(i)
          if Item and Item.ConfigData and Item.ConfigData.CanReceive then
            Item.ConfigData.CanReceive = false
            Item.ConfigData.RewardsGot = true
            if Item.SelfWidget then
              Item.SelfWidget:RefreshBtn(true)
            end
          end
        end
      end
      if Parm.SelfWidget then
        Parm.SelfWidget:RefreshButton(false)
      end
    end
    UIUtils.ShowGetItemPageAndOpenBagIfNeeded(nil, nil, nil, Ret, false, nil, nil, false)
  end
  
  Model.GetAllStarReward(EventId, CallBack)
end

return M
