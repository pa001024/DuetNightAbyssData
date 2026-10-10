require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:Init(Data)
  Data = Data or {}
  local RoleId = Data.RoleId
  local WeaponId = Data.WeaponId
  if self.WS_Head then
    local BattleChar = RoleId and DataMgr.BattleChar[RoleId]
    local GuideIconImg = BattleChar and BattleChar.GuideIconImg
    local HeadIconPath = GuideIconImg and "" ~= GuideIconImg and UIUtils.GetCharMiniIconPath(RoleId) or nil
    if HeadIconPath then
      self.WS_Head:SetActiveWidgetIndex(0)
      if self.Image_Head then
        self.Image_Head:SetBrushFromTexture(LoadObject(HeadIconPath))
      end
    else
      if RoleId then
        DebugPrint("WBP_Com_Ranking_PhantomSlot: invalid RoleId " .. tostring(RoleId))
      end
      self.WS_Head:SetActiveWidgetIndex(1)
    end
  end
  if self.WS_Weapon then
    local WeaponConfig = WeaponId and DataMgr.Weapon[WeaponId]
    local WeaponIconPath = WeaponConfig and WeaponConfig.Icon
    if WeaponIconPath then
      self.WS_Weapon:SetActiveWidgetIndex(0)
      if self.Image_Weapon then
        self.Image_Weapon:SetBrushFromTexture(LoadObject(WeaponIconPath))
      end
    else
      if WeaponId then
        DebugPrint("WBP_Com_Ranking_PhantomSlot: invalid WeaponId " .. tostring(WeaponId))
      end
      self.WS_Weapon:SetActiveWidgetIndex(1)
    end
  end
end

return M
