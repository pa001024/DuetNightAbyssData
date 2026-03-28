local FriendController = require("BluePrints.UI.WBP.Friend.FriendController")
require("UnLua")
local WBP_Settlement_DataDisplay_C = Class({
  "BluePrints.UI.BP_UIState_C"
})

function WBP_Settlement_DataDisplay_C:Construct()
  local LevelEnterData = DataMgr.LevelEnterData
  self.SwitchBattleDataTypeToText = {
    Damage = LevelEnterData.Damage.HighLightName,
    Kill = LevelEnterData.Kill.HighLightName,
    Damaged = LevelEnterData.Damaged.HighLightName,
    Heal = LevelEnterData.Heal.HighLightName,
    DamageSingle = LevelEnterData.DamageSingle.HighLightName,
    Destroy = LevelEnterData.Destroy.HighLightName,
    HitCount = LevelEnterData.HitCount.HighLightName
  }
  self.IconColorByType = {
    [1] = self.Color_Red,
    [2] = self.Color_Blue,
    [3] = self.Color_Green,
    [4] = self.Color_Yellow
  }
  self.Button_Area.OnClicked:Add(self, self.OnAddFriendButtonClicked)
  self.Button_Area.OnHovered:Add(self, self.OnAddFriendButtonHovered)
  self.Button_Area.OnUnhovered:Add(self, self.OnAddFriendButtonUnhovered)
  self.Button_Area.OnPressed:Add(self, self.OnAddFriendButtonPressed)
  self:UnbindAllFromAnimationFinished(self.AddBtn_Click)
  self:BindToAnimationFinished(self.AddBtn_Click, {
    self,
    function()
      self:PlayAnimation(self.AddBtn_Hover)
    end
  })
end

function WBP_Settlement_DataDisplay_C:Init(Parmas)
  self.Parmas = Parmas
  if not self.Parmas then
    return
  end
  self.TitleText = GText(self.SwitchBattleDataTypeToText[self.Parmas.DataName])
  self.Text_Type:SetText(self.TitleText)
  self:InitUIByType()
  self:SetColor()
  self:InitData()
  self:InitFriendData()
end

function WBP_Settlement_DataDisplay_C:InitFriendData()
  if self.Parmas.PlayerName then
    self:SwitchName(0)
    self.Text_Name:SetText(self.Parmas.PlayerName)
  else
    self:SwitchName(1)
    self.Text_Name:SetText(GText("UI_Shadow_Name"))
  end
  if self.Parmas.Uid and self:CheckAddFriend() then
    self.Text_Add:SetText(GText("UI_Friend_AddFriend"))
    self.SizeBox_Add:SetVisibility(ESlateVisibility.Visible)
    self:PlayAnimation(self.AddBtn_Normal)
    self.IsCanAddFriend = true
  else
    self.bIsFocusable = false
    self.SizeBox_Add:SetVisibility(ESlateVisibility.Collapsed)
  end
end

function WBP_Settlement_DataDisplay_C:CheckAddFriend()
  DebugPrint("CheckAddFriend", self.Parmas.IsMainPlayer, FriendController:GetModel():GetBlackListDict()[self.Parmas.Uid], FriendController:GetModel():GetFriendDict()[self.Parmas.Uid])
  return not self.Parmas.IsMainPlayer and FriendController:GetModel():GetBlackListDict()[self.Parmas.Uid] == nil and FriendController:GetModel():GetFriendDict()[self.Parmas.Uid] == nil
end

function WBP_Settlement_DataDisplay_C:SetColor()
  local DataType = DataMgr.LevelEnterData[self.Parmas.DataName].Type
  if not DataType then
    return
  end
  local Color = self.IconColorByType[DataType]
  self:SwitchColor(DataType - 1)
end

function WBP_Settlement_DataDisplay_C:InitUIByType()
  local IconPath = DataMgr.LevelEnterData[self.Parmas.DataName].Icon
  if not IconPath then
    return
  end
  IconPath = string.format("Texture2D'/%s'", IconPath)
  local Img = LoadObject(IconPath)
  if not Img then
    DebugPrint("缺少图片资源: ImgPath = " .. IconPath)
    return
  end
  self.Icon_Type:SetBrushResourceObject(Img)
end

function WBP_Settlement_DataDisplay_C:InitData()
  local NumText = self.Parmas.Value
  if NumText < 1000000000 then
    NumText = Utils.FormatNumber(NumText, false)
    if self.Parmas.DataName == "Damage" or self.Parmas.DataName == "Damaged" then
      NumText = string.format("%s", NumText) .. "%"
    end
  else
    NumText = Utils.FormatNumber(NumText, true)
  end
  self.Text_Data:SetVisibility(ESlateVisibility.Visible)
  self.Text_Data:SetText(NumText)
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonClicked()
  DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonClicked")
  self:PlayAnimation(self.AddBtn_Click)
  AudioManager(self):PlayUISound(self, "event:/ui/common/click")
  local DungoenSettlement = UIManager(self):GetUIObj("DungeonSettlement")
  if DungoenSettlement then
    DungoenSettlement.IsInAddFriendMode = true
    DungoenSettlement:SwitchFocusablePerHighLightWidget(true)
    DungoenSettlement.IsAddFriendWindowOpening = true
  end
  FriendController:OpenAddFriendDialog(self, {
    Uid = self.Parmas.Uid,
    OnCloseCallbackObj = self,
    OnCloseCallbackFunction = self.OnClosedCallback
  })
end

function WBP_Settlement_DataDisplay_C:SwitchFocusable(bEnableFocus)
  if self.IsCanAddFriend then
    self.bIsFocusable = bEnableFocus
  else
    self.bIsFocusable = false
  end
  if not bEnableFocus then
    self:PlayAnimation(self.AddBtn_Normal)
  end
end

function WBP_Settlement_DataDisplay_C:OnClosedCallback()
  DebugPrint("OnClosedCallback")
  local DungoenSettlement = UIManager(self):GetUIObj("DungeonSettlement")
  if DungoenSettlement then
    DungoenSettlement.IsAddFriendWindowOpening = false
    if DungoenSettlement.CurInputDeviceType ~= ECommonInputType.Gamepad then
      DungoenSettlement.IsInAddFriendMode = false
      DungoenSettlement:SwitchFocusablePerHighLightWidget(false)
      DungoenSettlement:UpdateMainUI()
    else
      self.Button_Area:SetFocus()
    end
  end
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonHovered()
  DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonHovered")
  self:PlayAnimation(self.AddBtn_Hover)
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonUnhovered()
  DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonUnhovered")
  self:PlayAnimation(self.AddBtn_UnHover)
end

function WBP_Settlement_DataDisplay_C:OnAddFriendButtonPressed()
  DebugPrint("WBP_Settlement_DataDisplay_C:OnAddFriendButtonPressed")
  self:PlayAnimation(self.AddBtn_Press)
end

function WBP_Settlement_DataDisplay_C:OnFocusReceived()
  local DungoenSettlement = UIManager(self):GetUIObj("DungeonSettlement")
  if DungoenSettlement and DungoenSettlement.IsInAddFriendMode then
    self.Button_Area:SetFocus()
  end
  return false
end

return WBP_Settlement_DataDisplay_C
