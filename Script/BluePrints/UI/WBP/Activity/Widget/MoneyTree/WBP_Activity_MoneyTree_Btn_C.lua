require("UnLua")
local MoneyTreeMgr = require("BluePrints.UI.WBP.Activity.Widget.MoneyTree.MoneyTreeMgr")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local TXT = {
  Knock = "MoneyTree_Knock",
  KnockDone = "MoneyTree_KnockDone",
  CanClaim = "MoneyTree_CanClaim",
  TowCan = "MoneyTree_TowCan"
}
local ENTRY_ANIMS = {
  "Normal_In",
  "Forbidden_In"
}

function M:Construct()
  if self.Btn_Area then
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnAreaClicked)
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnHovered:Add(self, self.OnAreaHovered)
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnUnhovered:Add(self, self.OnAreaUnhovered)
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnPressed:Add(self, self.OnAreaPressed)
  end
  self.bForbidden = false
  self.bEntryAnimating = false
  self:PlayAnimation(self.Normal)
end

function M:SetClickCallback(Obj, Func)
  self._CallbackObj = Obj
  self._CallbackFunc = Func
end

function M:OnAreaHovered()
  if self.bForbidden then
    return
  end
  if self.bEntryAnimating then
    return
  end
  self:PlayAnimation(self.Hover)
end

function M:OnAreaUnhovered()
  if self.bForbidden then
    return
  end
  if self.bEntryAnimating then
    return
  end
  if self.UnHover then
    self:BindToAnimationFinished(self.UnHover, {
      self,
      function()
        self:UnbindAllFromAnimationFinished(self.UnHover)
        self:FinishEntryAnims()
        self:StopAllAnimations()
        self:PlayAnimation(self.Normal)
      end
    })
    self:PlayAnimation(self.UnHover)
  else
    self:FinishEntryAnims()
    self:StopAllAnimations()
    self:PlayAnimation(self.Normal)
  end
end

function M:OnAreaPressed()
  if self.bForbidden then
    return
  end
  self:PlayAnimation(self.Press)
end

function M:OnAreaClicked()
  if self.bForbidden then
    return
  end
  self:PlayAnimation(self.Click)
  if self._CallbackFunc then
    self._CallbackFunc(self._CallbackObj, self)
  end
end

function M:FinishEntryAnims()
  self.bEntryAnimating = false
  for _, AnimName in ipairs(ENTRY_ANIMS) do
    local Anim = self[AnimName]
    if Anim and self:IsAnimationPlaying(Anim) then
      self:PlayAnimation(Anim, Anim:GetEndTime(), 1, EUMGSequencePlayMode.Forward, 1)
    end
  end
end

function M:SetForbidden(bForbidden)
  if self.bForbidden == bForbidden then
    return
  end
  self.bForbidden = bForbidden
  self:FinishEntryAnims()
  self:StopAllAnimations()
  self:PlayAnimation(bForbidden and self.Forbidden or self.Normal)
end

function M:PlayEntryAnim()
  local Anim = self.bForbidden and self.Forbidden_In or self.Normal_In
  self.bEntryAnimating = false
  if Anim then
    self:StopAllAnimations()
    self.bEntryAnimating = true
    self:UnbindAllFromAnimationFinished(Anim)
    self:BindToAnimationFinished(Anim, {
      self,
      function()
        self:UnbindAllFromAnimationFinished(Anim)
        self.bEntryAnimating = false
        if not self.bForbidden and self.Btn_Area and self.Btn_Area:IsHovered() then
          self:PlayAnimation(self.Hover)
        end
      end
    })
    self:PlayAnimation(Anim)
  end
end

function M:Refresh()
  local bCanClaim = MoneyTreeMgr.CanClaim()
  local State = MoneyTreeMgr.GetState()
  local Config = MoneyTreeMgr.GetConfig()
  if self.Text_Knock then
    self.Text_Knock:SetText(GText(bCanClaim and TXT.Knock or TXT.KnockDone))
  end
  local TotalDays = Config and Config.TotalDays or 0
  local bHasNextReward = TotalDays >= State.ClaimIndex
  local bShowRewardInfo = bCanClaim or bHasNextReward and not MoneyTreeMgr.IsAllUnlockTimeBlocked()
  if self.HB_Get then
    self.HB_Get:SetVisibility(bShowRewardInfo and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Text_Get then
    self.Text_Get:SetText(GText(bCanClaim and TXT.CanClaim or TXT.TowCan))
  end
  if self.Text_NumRange then
    local MinReward, MaxReward = MoneyTreeMgr.GetRewardRange(State.ClaimIndex)
    if State.AllUnlocked then
      local ExtraCopies = MoneyTreeMgr.GetExtraRewardCopies(State.ClaimIndex)
      local TotalCopies = 1 + ExtraCopies
      MinReward, MaxReward = MinReward * TotalCopies, MaxReward * TotalCopies
    end
    local NumText = MinReward == MaxReward and tostring(MinReward) or string.format("%d - %d", MinReward, MaxReward)
    self.Text_NumRange:SetText(NumText)
  end
  if self.VB_Times then
    self.VB_Times:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  if self.Reddot then
    self.Reddot:SetVisibility(bCanClaim and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed)
  end
  if self.Key_GamePad then
    if UIUtils.IsGamepadInput() and bCanClaim then
      self.Key_GamePad:CreateGamepadKey(UIConst.GamePadImgKey.FaceButtonBottom)
      self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    else
      self.Key_GamePad:SetVisibility(UE4.ESlateVisibility.Collapsed)
    end
  end
  self:SetForbidden(not bCanClaim)
end

return M
