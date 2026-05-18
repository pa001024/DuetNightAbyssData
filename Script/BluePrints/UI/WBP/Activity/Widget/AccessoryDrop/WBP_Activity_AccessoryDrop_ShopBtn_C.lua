require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:BindInputMethodChangedDelegate()
  self.Btn_Click.OnClicked:Add(self, self.GoToShopClick)
end

function M:Destruct()
  self:UnBindInputMethodChangedDelegate()
  self.Btn_Click.OnClicked:Remove(self, self.GoToShopClick)
end

function M:InitView(AccessDropConfig, AccessoryDrop, IsRefresh)
  self.AccessDropConfig = AccessDropConfig
  self.EventId = AccessDropConfig.EventId
  self.Text_Name:SetText(GText("Event_FreeAppearance_tittle01"))
  local nextAddDropBoxNumTime = math.floor(TimeUtils.NextDailyRefreshTime())
  local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
  if nextAddDropBoxNumTime > ActivityConfigData.EventEndTime and 0 == AccessoryDrop.CurDropBoxNum then
    if self.Panel_Bubble:GetVisibility() == ESlateVisibility.Collapsed then
      self:PlayAnimation(self.Bubble_In)
    end
    self.Text_Bubble:SetText(GText("Event_FreeAppearance_tips12"))
    if self:IsShopSoldOut() then
      self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
    else
      self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  else
    if self.Panel_Bubble:GetVisibility() == ESlateVisibility.SelfHitTestInvisible then
      self:PlayAnimation(self.Bubble_Out)
    end
    self.Panel_Bubble:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
  if not IsRefresh then
    self:InitGamePadBtn()
  end
  self:UpdateTime()
end

function M:UpdateTime()
  if self.AccessDropConfig then
    local ActivityConfigData = DataMgr.EventMain[self.AccessDropConfig.EventId]
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(ActivityConfigData.EventEndTime)
    self.Time:SetTimeText("", RemainTimeDict)
  end
end

function M:GoToShopClick()
  local PageConfigData = DataMgr.EventPortal[self.EventId]
  if not PageConfigData.EventShop then
    return
  end
  PageJumpUtils:JumpToTargetPageByJumpId(PageConfigData.EventShop)
  AudioManager(self):PlayUISound(self, "event:/ui/activity/drama_gift_btn_click", nil, nil)
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
  if NewGameInputType == ECommonInputType.Gamepad then
    self:SetGamePadVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  else
    self:SetGamePadVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:InitGamePadBtn()
  self.Key_Controller:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonLeft
      }
    }
  })
  self:SetGamePadVisibility()
end

function M:SetGamePadVisibility(Op)
  if nil == Op then
    if UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad then
      Op = UIConst.VisibilityOp.SelfHitTestInvisible
    else
      Op = UIConst.VisibilityOp.Collapsed
    end
  end
  self.Key_Controller:SetVisibility(Op)
end

function M:IsShopSoldOut()
  local Avatar = GWorld:GetAvatar()
  local PageConfigData = DataMgr.EventPortal[self.EventId]
  local SubTabId = DataMgr.InterfaceJump[PageConfigData.EventShop].JumpParameter3
  SubTabId = tonumber(SubTabId)
  local ShopDataList = {}
  for ShopItemId, ShopData in pairs(DataMgr.ShopItem) do
    if ShopData.SubTabId == SubTabId and ShopUtils:GetShopItemCanShow(ShopItemId) then
      table.insert(ShopDataList, ShopData)
    end
  end
  local NotSoldOutList, LimitLevelList = {}, {}
  for _, ShopData in pairs(ShopDataList) do
    local PurchaseLimit = ShopUtils:GetShopItemPurchaseLimit(ShopData.ItemId)
    if 0 == PurchaseLimit or Avatar:CheckShopItemUnique(ShopData.ItemId) then
    else
      local NeedLevel = ShopData.UnlockLevel or 0
      if NeedLevel > Avatar.Level then
        table.insert(LimitLevelList, ShopData)
      else
        table.insert(NotSoldOutList, ShopData)
      end
    end
  end
  if next(NotSoldOutList) or next(LimitLevelList) then
    return false
  end
  return true
end

return M
