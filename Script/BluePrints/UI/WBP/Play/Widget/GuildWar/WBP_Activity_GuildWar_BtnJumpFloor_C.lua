require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
M._components = {
  "BluePrints.UI.WBP.Play.Widget.GuildWar.GuildWarView"
}

function M:Construct()
  self.Text_Button:SetText(string.format(GText("Raid_Season_Floor_UI_Floor"), self:GetHighestUnlockedFloor()))
  self.Btn_Click.OnClicked:Add(self, self.OnClicked_JumpFloor)
  self:InitControllerJump()
  self:SetControllerJumpVisible(UIUtils.UtilsGetCurrentInputType() == ECommonInputType.Gamepad)
end

function M:Init(Owner, OnClicked)
  self.Owner = Owner
  self.OnClicked = OnClicked
end

function M:InitControllerJump()
  if not self.Controller_Jump then
    return
  end
  self.Controller_Jump:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.LeftThumb
      }
    },
    bLongPress = true,
    bButton = true
  })
end

function M:SetControllerJumpVisible(bVisible)
  if self.WS_Key then
    self.WS_Key:SetActiveWidgetIndex(bVisible and 1 or 0)
  end
  if self.Controller_Jump then
    self.Controller_Jump:SetVisibility(bVisible and ESlateVisibility.HitTestInvisible or ESlateVisibility.Collapsed)
  end
end

function M:StartGamepadLongPress()
  if self.Controller_Jump then
    self.Controller_Jump:OnButtonPressed()
  end
end

function M:StopGamepadLongPress()
  if self.Controller_Jump then
    self.Controller_Jump:OnButtonReleased()
  end
end

function M:OnClicked_JumpFloor()
  if self.OnClicked then
    self.OnClicked(self.Owner)
  end
end

AssembleComponents(M)
return M
