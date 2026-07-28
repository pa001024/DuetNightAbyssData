require("UnLua")
local SoloTreasurePermanentDataModel = require("BluePrints.UI.UI_PC.SoloTreasure.SoloTreasurePermanentDataModel")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self:PlayAnimation(self.In, 0, 1, UE4.EUMGSequencePlayMode.Forward, 1, true)
  self:BindBtnState()
end

function M:Init(CallBackObj, CallBackFunc, TitleText)
  self.CallBackObj = CallBackObj
  self.CallBackFunc = CallBackFunc
  self.RewardControllerKeyInfo = {
    GamePadInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.FaceButtonTop,
        ClickCallback = self.OnBtnClicked,
        Owner = self
      }
    },
    bButton = true
  }
  self.Controller:CreateCommonKey({
    KeyInfoList = self.RewardControllerKeyInfo.GamePadInfoList,
    bButton = self.RewardControllerKeyInfo.bButton
  })
  if self.Text_RewardTitle and TitleText then
    self.Text_RewardTitle:SetText(GText(TitleText))
  end
  if self.New then
    self.New:SetVisibility(UE4.ESlateVisibility.Collapsed)
  end
  self:InitReddotListen()
end

function M:Destruct()
  self:RemoveReddotListen()
end

function M:InitReddotListen()
  self:RemoveReddotListen()
  local Node = ReddotManager.GetTreeNode(SoloTreasurePermanentDataModel.REDDOT_NODE_ILLUSTRATED_REWARD)
  if not Node then
    ReddotManager.AddNodeEx(SoloTreasurePermanentDataModel.REDDOT_NODE_ILLUSTRATED_REWARD)
  end
  ReddotManager.AddListenerEx(SoloTreasurePermanentDataModel.REDDOT_NODE_ILLUSTRATED_REWARD, self, function(RewardWidget, Count, RdType)
    RewardWidget:RefreshRewardReddot(Count, RdType)
  end)
  SoloTreasurePermanentDataModel:RefreshManualArchiveRewardReddot()
end

function M:Handle_KeyEventOnGamePad_KeyDown(InKeyName)
  local IsEventHandled = true
  if InKeyName == UIConst.GamePadKey.FaceButtonTop then
    self:OnBtnClicked()
  else
    IsEventHandled = false
  end
  return IsEventHandled
end

function M:RemoveReddotListen()
  ReddotManager.RemoveListener(SoloTreasurePermanentDataModel.REDDOT_NODE_ILLUSTRATED_REWARD, self)
end

function M:RefreshRewardReddot(Count, RdType)
  Count = Count or 0
  local bShow = Count > 0
  if self.EMShowReddot then
    self:EMShowReddot(bShow, RdType or EReddotType.Normal, Count)
    return
  end
  if self.Reddot then
    self.Reddot:SetVisibility(bShow and UIConst.VisibilityOp.HitTestInvisible or UIConst.VisibilityOp.Collapsed)
  end
end

function M:BindBtnState()
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

function M:OnBtnHovered()
  self:PlayAnimation(self.Hover)
end

function M:OnBtnUnhovered()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.UnHover)
end

function M:OnBtnPressed()
  self:StopAnimation(self.Hover)
  self:PlayAnimation(self.Press)
end

function M:OnBtnClicked()
  self:StopAllAnimations()
  self:PlayAnimation(self.Click)
  if self.CallBackObj and self.CallBackFunc then
    self.CallBackFunc(self.CallBackObj, self)
  end
end

function M:SetProgress(NowNum, TotalNum)
  if self.Text_Now then
    self.Text_Now:SetText(tostring(NowNum or 0))
  end
  if self.Text_Total then
    self.Text_Total:SetText(tostring(TotalNum or 0))
  end
end

function M:SetControllerVisible(bVisible)
  if not self.Controller then
    return
  end
  local Vis = bVisible and UE4.ESlateVisibility.SelfHitTestInvisible or UE4.ESlateVisibility.Collapsed
  self.Controller:SetVisibility(Vis)
end

return M
