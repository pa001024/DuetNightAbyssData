local GiftController = require("BluePrints.UI.WBP.Gift.GiftController")
local Component = {}

function Component:EnterWorld()
  GiftController:Init()
end

function Component:LeaveWorld()
  GiftController:Destory()
end

function Component:UpdateSendGiftRecordCache(SendGiftRecordCache)
  DebugPrint("UpdateSendGiftRecordCache")
  DebugPrintTable(SendGiftRecordCache)
  self.SendGiftRecordCache = SendGiftRecordCache
end

function Component:CheckCanRecvShopItemGift(InCallBack, Uid, ShopItemId)
  local function Callback(ErrCode, ...)
    DebugPrint("CheckCanRecvShopItemGift 收到回调" .. ErrCode, ...)
    
    if ErrCode ~= ErrorCode.RET_SUCCESS then
      DebugPrint("CheckCanRecvShopItemGift 错误码" .. ErrCode)
    end
    InCallBack(ErrCode, ...)
  end
  
  self:CallServer("CheckCanRecvShopItemGift", Callback, Uid, ShopItemId)
end

function Component:RequestSendShopOrderGift(CallbackInfo, GoodsId, Uid, Content)
  local function Callback(ErrCode, ...)
    CallbackInfo.Func(CallbackInfo.Obj, ErrCode, ...)
  end
  
  self:CallServer("RequestSendShopOrderGift", Callback, GoodsId, Uid, Content)
end

function Component:RequestSendShopResourceGift(CallbackInfo, Uid, ShopItemId, Count, Content, SecondaryPassWord)
  local function Callback(ErrCode, ...)
    CallbackInfo.Func(CallbackInfo.Obj, ErrCode, ...)
    
    local Index = (...)
    if ErrCode == ErrorCode.RET_SUCCESS then
      ChatController:SendGiftMessage(Uid, Index)
      EventManager:FireEvent(EventID.OnSendGiftFinished)
    end
  end
  
  self:CallServer("RequestSendShopResourceGift", Callback, Uid, ShopItemId, Count, Content, SecondaryPassWord)
end

function Component:NotifyGiftMailGot(Index, Time)
  ScreenPrint("NotifyGiftMailGot", Index, Time)
  self.SentGiftRecords[Index].bGiftMailGot = true
  local RecvGiftRecords = self.SentGiftRecords
  local GiftData
  if RecvGiftRecords and CommonUtils.Size(RecvGiftRecords) > 0 then
    GiftData = RecvGiftRecords[Index]
  end
end

function Component:NotifyGetGiftMailItemSuccess(Index)
  ScreenPrint("NotifyGetGiftMailItemSuccess", Index)
  local RecvGiftRecords = self.RecvGiftRecords
  local GiftData
  if RecvGiftRecords and CommonUtils.Size(RecvGiftRecords) > 0 then
    GiftData = RecvGiftRecords[Index]
  end
  local FriendData = FriendController:GetModel():GetFriendDict()[GiftData.Uid]
  if not FriendData then
    return
  end
  ChatController:SendGiftReceivedMessage(GiftData.Uid, Index)
end

return Component
