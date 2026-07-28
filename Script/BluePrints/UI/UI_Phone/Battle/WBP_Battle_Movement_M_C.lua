require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  if self.Button_Area then
    self.Button_Area.OnClicked:Add(self, self.OnBtnClicked)
  end
end

function M:OnBtnClicked()
  if self.OwnerLeftBtn and self.OwnerLeftBtn.bPanelOpen then
    return
  end
  local BattleMain = UIManager(self):GetUIObj("BattleMain")
  if BattleMain then
    BattleMain:OpenAppearanceGestureGruop()
  end
end

function M:Destruct()
end

AssembleComponents(M)
return M
