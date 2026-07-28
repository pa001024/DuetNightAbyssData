require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:OnListItemObjectSet(Content)
  self.MissionId = Content.MissionId
  local Info = DataMgr.CombatChessInfo[Content.AutoChessId]
  if not Info then
    DebugPrint(ErrorTag, string.format("CombatChessInfo查表失败，ID：%s不存在数据", Content.AutoChessId))
    return
  end
  self.Monster_Head:SetBrushResourceObject(LoadObject(Info.MonsterIcon))
  self.Icon_Type.Icon:SetBrushResourceObject(LoadObject(Info.PositionIcon))
  if 2 == Content.EquipCount then
    self.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
    self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
  elseif 1 == Content.EquipCount then
    self.Equipment_01.WS_Type:SetActiveWidgetIndex(1)
    self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
  else
    self.Equipment_01.WS_Type:SetActiveWidgetIndex(0)
    self.Equipment_02.WS_Type:SetActiveWidgetIndex(0)
  end
  self.Button_Area.OnClicked:Add(self, self.OnClick)
end

function M:OnClick()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_mid", nil, nil)
  UIManager(self):LoadUINew("AutoChessDeputeMonsterInfoUI", self.MissionId)
end

return M
