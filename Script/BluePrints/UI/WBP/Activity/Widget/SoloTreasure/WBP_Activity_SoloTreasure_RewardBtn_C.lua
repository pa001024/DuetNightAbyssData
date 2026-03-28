require("Unlua")
local SoloTreasureDataModel = require("BluePrints.UI.WBP.Activity.Widget.SoloTreasure.SoloTreasureDataModel")
local SoloTreasureRewardBtn = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function SoloTreasureRewardBtn:Construct()
  self:PlayAnimation(self.In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
  self:BindBtnState()
end

function SoloTreasureRewardBtn:Init(CallBackObj, CallBackFunc, TitleText, Params)
  self.CallBackObj = CallBackObj
  self.CallBackFunc = CallBackFunc
  self.Params = Params
  if self.Text_RewardTitle and TitleText then
    self.Text_RewardTitle:SetText(GText(TitleText))
  end
end

function SoloTreasureRewardBtn:BindBtnState()
  if self.Btn_Area.OnHovered then
    self.Btn_Area.OnHovered:Clear()
    self.Btn_Area.OnHovered:Add(self, self.OnBtnHovered)
  end
  if self.Btn_Area.OnUnhovered then
    self.Btn_Area.OnUnhovered:Clear()
    self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
  end
  if self.Btn_Area.OnPressed then
    self.Btn_Area.OnPressed:Clear()
    self.Btn_Area.OnPressed:Add(self, self.OnBtnPressed)
  end
  if self.Btn_Area.OnClicked then
    self.Btn_Area.OnClicked:Clear()
    self.Btn_Area.OnClicked:Add(self, self.OnBtnClicked)
  end
end

function SoloTreasureRewardBtn:OnBtnHovered()
  self:PlayAnimation(self.Hover)
end

function SoloTreasureRewardBtn:OnBtnUnhovered()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function SoloTreasureRewardBtn:OnBtnPressed()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function SoloTreasureRewardBtn:OnBtnClicked()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  if self.CallBackObj and self.CallBackFunc then
    self.CallBackFunc(self.CallBackObj, self.Params, self)
  end
end

function SoloTreasureRewardBtn:SetScore(UserCurrentScore)
  local NumText = Utils.FormatNumber(UserCurrentScore, false)
  if NumText and self.Num_Icon then
    self.Num_Icon:SetText(NumText)
  end
end

function SoloTreasureRewardBtn:SetCoinIcon()
  local ResourceId = DataMgr.GlobalConstant.SoloTreasureCurrent.ConstantValue
  local CoinIconPath = DataMgr.Resource[ResourceId].Icon
  local CoinObj = LoadObject(CoinIconPath)
  if CoinObj then
    self.Icon_Coin:SetBrushFromTexture(CoinObj)
  end
end

function SoloTreasureRewardBtn:SetRemainTime(RemainTimeDict)
  if self.Com_Time and RemainTimeDict then
    self.Com_Time:SetTimeText(GText("UI_GameEvent_TimeRemain"), RemainTimeDict)
  end
end

function SoloTreasureRewardBtn:SetProgress(NowNum, TotalNum)
  if self.Num_Now then
    self.Num_Now:SetText(tostring(NowNum or 0))
  end
  if self.Num_Total then
    self.Num_Total:SetText(tostring(TotalNum or 0))
  end
end

function SoloTreasureRewardBtn:SetControllerVisible(bVisible)
  if not self.Controller then
    return
  end
  local Vis = bVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self.Controller:SetVisibility(Vis)
end

return SoloTreasureRewardBtn
