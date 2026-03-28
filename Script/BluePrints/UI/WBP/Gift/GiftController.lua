local GiftModel = require("BluePrints.UI.WBP.Gift.GiftModel")
local GiftCommon = require("BluePrints.UI.WBP.Gift.GiftCommon")
local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
local GMVariable = require("BluePrints.UI.GMInterface.GMVariable")
local M = Class("BluePrints.Common.MVC.Controller")

function M:Init()
  M.Super.Init(self)
end

function M:Destory()
  M.Super.Destory(self)
end

function M:OpenSelectFriendPopup(ShopItemId, ParentWidget)
  DebugPrint("GiftSystem: OpenSelectFriendPopup", ShopItemId)
  UIManager():ShowCommonPopupUI(GiftCommon.SelectFriendPopupId, {ShopItemId = ShopItemId}, ParentWidget)
end

function M:OpenGiftShopMain(FriendUid)
  UIManager():LoadUINew(GiftCommon.GiftShopViewName, {FriendUid = FriendUid})
end

function M:OpenGiftShopMainGM()
  local FriendUid
  local FriendModel = FriendController:GetModel()
  if FriendModel and FriendModel.GetFriendList then
    local FriendList = FriendModel:GetFriendList()
    if type(FriendList) == "table" and #FriendList > 0 then
      FriendUid = FriendList[1]
    end
  end
  if not FriendUid then
    local FriendDict = self:GetAvatar().Friends
    if FriendDict then
      for uid, _ in pairs(FriendDict) do
        FriendUid = uid
        break
      end
    end
  end
  return self:OpenGiftShopMain(FriendUid)
end

function M:OpenChangeFriendPopup(FriendUid, FriendChangeCallBack, ParentWidget)
  UIManager():ShowCommonPopupUI(GiftCommon.ChangeFriendPopupId, {FriendUid = FriendUid, FriendChangeCallBack = FriendChangeCallBack}, ParentWidget)
end

function M:OpenCanNotSendPopup(FriendId)
  UIManager():ShowCommonPopupUI(GiftCommon.CanNotSendGiftPopupId, {FriendId = FriendId})
end

function M:OpenPersonInfoPage(Uid)
  local Dialog = UIManager(self):GetUIObj("CommonDialog")
  if Dialog then
    Dialog:Hide("OpenPersonInfoPage")
  end
  self:GetAvatar():CheckOtherPlayerPersonallInfo(Uid)
end

function M:CheckCanSendGift(FriendUid)
  if not GiftModel:LevelCanSendGift() then
    return false
  end
  if FriendUid and not GMVariable.IgnoreGiftShopFriendLimit then
    local FriendDay = GiftModel:GetFriendDay(FriendUid)
    if FriendDay < GiftModel:GetGiftNeedFriendTime() then
      return false
    end
  end
  local LeftCount, LimitCount = GiftModel:GetTotalGiftCount()
  if LeftCount <= 0 then
    return false
  end
  return true
end

function M:IsInGiftShop()
  return UIManager(self):GetUIObj(GiftCommon.GiftShopViewName) ~= nil
end

function M:GetGiftMainPage()
  return UIManager(self):GetUIObj(GiftCommon.GiftShopViewName)
end

function M:OnSendGiftFinished()
  local SkinPreview = UIManager(self):GetUIObj("SkinPreview")
  if SkinPreview then
    SkinPreview:Close()
  end
end

function M:GetModel()
  return GiftModel
end

function M:GetEventName()
  return EventID.GiftControllerEvent
end

function M:TryToSendGift(OtherUid, ShopItemId)
  local function CallBack(ErrCode, ...)
    DebugPrint("TryToSendGift", ErrCode, ...)
    
    if ErrCode == ErrorCode.RET_SUCCESS then
      self:OpenGiftCardView(OtherUid, ShopItemId, 1)
    elseif ErrCode == ErrorCode.GIFT_RECIPIENT_INVENTORY_FULL then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_AlreadyHave"))
    elseif ErrCode == ErrorCode.GIFT_RECIPIENT_REGION_CODE_RESTRICTED then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_CantSendRegion"))
    else
      self:CheckError(ErrCode)
    end
  end
  
  self:GetAvatar():CheckCanRecvShopItemGift(CallBack, OtherUid, ShopItemId)
end

function M:OpenGiftCardView(OtherUid, ShopItemId, GreetingsMode, Mail)
  if 1 == GreetingsMode then
    local FriendData = FriendController:GetModel():GetFriendDict()[OtherUid]
    if not FriendData then
      UIManager(self):ShowUITip(UIConst.Tip_CommonToast, GText("UI_SendGift_NoLongerFriend"))
      return
    end
  else
    local FriendData = FriendController:GetModel():GetFriendDict()[OtherUid]
    if not FriendData then
      local function OpenGiftCardView(OtherPlayerInfo)
        local Dialog = UIManager(self):GetUIObj("CommonDialog")
        
        if Dialog then
          Dialog:Close()
        end
        M.Super.OpenView(self, self:GetUIMgr(), GiftCommon.GiftGetViewName, OtherUid, ShopItemId, GreetingsMode, Mail, OtherPlayerInfo)
      end
      
      GWorld:GetAvatar():GetOtherPlayerPersonallInfo(OtherUid, {Func = OpenGiftCardView})
      return
    end
  end
  local Dialog = UIManager(self):GetUIObj("CommonDialog")
  if Dialog then
    Dialog:Close()
  end
  return M.Super.OpenView(self, self:GetUIMgr(), GiftCommon.GiftGetViewName, OtherUid, ShopItemId, GreetingsMode, Mail)
end

function M:SendToShopOrderGift(GoodsId, Uid, Content)
  local CallbackInfo = {
    Func = self.RecvToShopOrderGift,
    Obj = self
  }
  self:GetAvatar():RequestSendShopOrderGift(CallbackInfo, GoodsId, Uid, Content)
end

function M:RecvToShopOrderGift(ErrCode, ...)
  if ErrCode ~= ErrorCode.RET_SUCCESS then
    self:CheckError(ErrCode)
    return
  end
  self:NotifyEvent(GiftCommon.EventId.ToShopOrderGift)
end

function M:SendToShopResourceGift(Uid, ShopItemId, Count, Content, Handler, Password)
  local CallbackInfo = {
    Func = function(_Self, ErrCode, ...)
      _Self:RecvToShopResourceGift(ErrCode, ...)
      Handler.Func(Handler.Obj, ErrCode, ...)
    end,
    Obj = self
  }
  self:GetAvatar():RequestSendShopResourceGift(CallbackInfo, Uid, ShopItemId, Count, Content, Password)
end

function M:RecvToShopResourceGift(ErrCode, ...)
  if ErrCode ~= ErrorCode.RET_SUCCESS then
    self:CheckError(ErrCode)
    return
  end
  self:NotifyEvent(GiftCommon.EventId.ToShopResourceGift)
end

function M:GetSenderName(MailUniqueId, IsStar)
  local Avatar = GWorld:GetAvatar()
  local Mail
  if IsStar then
    Mail = Avatar.StarMails[MailUniqueId]
  else
    Mail = Avatar.MailInbox[MailUniqueId]
  end
  return Mail.Nickname
end

_G.GiftController = M
return M
