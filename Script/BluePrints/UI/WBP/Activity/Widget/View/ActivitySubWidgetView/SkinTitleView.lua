require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Init(SkinId)
  self.SkinId = SkinId
  local SkinInfo = DataMgr.Skin[SkinId]
  local Rarity = SkinInfo.Rarity
  if not Rarity or Rarity < 1 or Rarity > 6 then
    DebugPrint("No Rarity")
    return
  end
  self.Com_QualityTag:Init(Rarity)
  local Font, ImageLight
  if 6 == Rarity then
    Font = self.Font_Red
    ImageLight = self.Light_Red
  elseif 5 == Rarity then
    Font = self.Font_Gold
    ImageLight = self.Light_Gold
  elseif 4 == Rarity then
    Font = self.Font_Purple
    ImageLight = self.Light_Purple
  elseif 3 == Rarity then
    Font = self.Font_Blue
    ImageLight = self.Light_Blue
  end
  self.Text_CharName:SetFont(Font)
  self.Text_CharName:SetText(GText(SkinInfo.SkinName))
  self.Img_TryOutBG:SetColorAndOpacity(ImageLight)
  self.Btn_Detail.OnClicked:Clear()
  self.Btn_Detail.OnClicked:Add(self, self.BtnClicked)
end

function M:BtnClicked()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_small", nil, nil)
  UIManager(self):LoadUINew("SkinPreview", {
    ItemType = "Skin",
    TypeId = self.SkinId,
    SinglePreview = true,
    HidePurchase = true
  })
end

return M
