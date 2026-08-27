require("UnLua")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M.PayType = 1
local TXT = {
  SingleDouble = "MoneyTree_SingleDouble",
  Doubled = "MoneyTree_Doubled",
  AutoDouble = "MoneyTree_AutoDouble",
  AllDouble = "MoneyTree_AllDouble",
  Unlocked = "MoneyTree_Unlocked",
  SingleDesc = "MoneyTree_SingleDouble_Desc",
  AllDesc = "MoneyTree_AllDouble_Desc"
}

function M:Construct()
  if self.Btn_Area then
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnAreaClicked)
  end
  self.bForbidden = false
end

function M:SetClickCallback(Obj, Func)
  self._CallbackObj = Obj
  self._CallbackFunc = Func
end

function M:OnAreaClicked()
  if self._CallbackFunc then
    self._CallbackFunc(self._CallbackObj, self)
  end
end

function M:SetForbidden(bForbidden)
  if self.bForbidden == bForbidden then
    return
  end
  self.bForbidden = bForbidden
  if self.Btn_Area and self.Btn_Area.SetForbidden then
    self.Btn_Area:SetForbidden(bForbidden)
  end
end

function M:Refresh()
  local State = MoneyTreeMgr.GetState()
  if self.Text_Price then
    self.Text_Price:SetText(string.format("¥%d", MoneyTreeMgr.GetPriceYuan(self.PayType)))
  end
  if 2 == self.PayType then
    self:RefreshAllUnlock(State)
  else
    self:RefreshSingle(State)
  end
  self:RefreshGamePadKey()
end

function M:RefreshGamePadKey()
  if not self.Key_GamePad then
    return
  end
  if UIUtils.IsGamepadInput() then
    local GamePadKey = 2 == self.PayType and UIConst.GamePadImgKey.FaceButtonTop or UIConst.GamePadImgKey.FaceButtonLeft
    self.Key_GamePad:CreateGamepadKey(GamePadKey)
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
  else
    self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
end

function M:RefreshSingle(State)
  if self.Text_Double then
    local TextKey = TXT.SingleDouble
    if State.AllUnlocked then
      TextKey = TXT.AutoDouble
    elseif State.Doubled then
      TextKey = TXT.Doubled
    end
    self.Text_Double:SetText(GText(TextKey))
  end
  if self.Text_Hint then
    self.Text_Hint:SetText(GText(TXT.SingleDesc))
  end
  self:SetForbidden(not MoneyTreeMgr.CanSingleDouble())
end

function M:RefreshAllUnlock(State)
  if self.Text_Double then
    self.Text_Double:SetText(GText(State.AllUnlocked and TXT.Unlocked or TXT.AllDouble))
  end
  if self.Text_Hint then
    self.Text_Hint:SetText(GText(TXT.AllDesc))
  end
  self:SetForbidden(not MoneyTreeMgr.CanAllUnlock())
end

return M
