require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local LimitTimeColorRed = UE4.FLinearColor(0.47932, 0.0185, 0.057805, 0.901961)
local LimitTimeColorOrange = UE4.FLinearColor(0.930111, 0.318547, 0.03434, 0.901961)

function M:OnListItemObjectSet(ItemObject)
  self.Text_Title:SetText(GText(ItemObject.Name))
  if not ItemObject.IsSelected then
    self.Text_Title:SetRenderOpacity(0.4)
  else
    self.Text_Title:SetRenderOpacity(1)
  end
  ItemObject.UI = self
  self.Item = ItemObject
  if -1 ~= ItemObject.TitleID then
    local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
    if CacheDetail and CacheDetail[ItemObject.TitleID] then
      self.New:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    else
      self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    ItemObject.IsNew = true
  else
    self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
    ItemObject.IsNew = false
  end
  self:RefreshLimitTime()
end

function M:OnEntryReleased()
  self:HideLimitTime()
end

function M:HideLimitTime()
  if IsValid(self.Panel_LimitTime) then
    self.Panel_LimitTime:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:RefreshLimitTime()
  if not IsValid(self.Panel_LimitTime) or not IsValid(self.Time) then
    return
  end
  local Item = self.Item
  local TitleId = Item and Item.TitleID
  if not TitleId or -1 == TitleId then
    self:HideLimitTime()
    return
  end
  local Avatar = GWorld:GetAvatar()
  local EndTime = Avatar and Avatar:GetLimitedTitleEndTime(TitleId)
  if not EndTime then
    self:HideLimitTime()
    return
  end
  local NowTime = TimeUtils.NowTime()
  if EndTime <= NowTime then
    self:HideLimitTime()
    return
  end
  self.Panel_LimitTime:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  if IsValid(self.BG_LimitTime) then
    local LimitColor = LimitTimeColorOrange
    if os.difftime(EndTime, NowTime) < 86400 then
      LimitColor = LimitTimeColorRed
    end
    self.BG_LimitTime:SetColorAndOpacity(LimitColor)
  end
  local TimeTitle = self.Time.Text_TimeTitle
  local TimeDesc = self.Time.Text_TimeDesc
  if Item.IsSelected then
    local RemainTimeDict, TimeCount = UIUtils.GetLeftTimeStrStyle2(EndTime, NowTime)
    if not TimeCount or TimeCount <= 0 then
      self:HideLimitTime()
      return
    end
    if IsValid(TimeTitle) then
      TimeTitle:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if IsValid(TimeDesc) then
      TimeDesc:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
    self.Time:SetTimeText(nil, RemainTimeDict)
  else
    if IsValid(TimeDesc) then
      TimeDesc:SetVisibility(UIConst.VisibilityOp.Collapsed)
    end
    if IsValid(TimeTitle) then
      TimeTitle:SetText(GText("UI_SHOP_SHOPITEMLIMIT_TIME"))
      TimeTitle:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
    end
  end
end

function M:SetNotNew()
  local CacheDetail = ReddotManager.GetLeafNodeCacheDetail("Title")
  UIUtils.TrySubReddotCacheDetailNumber(self.Item.TitleID, "Title")
  self.New:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
