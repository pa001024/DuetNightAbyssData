require("UnLua")
local EMCache = require("EMCache.EMCache")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Initialize()
  self.BossUnitID = nil
  self.TotalRound = nil
  self.PauseRoundItemBPClassPath = "WidgetBlueprint'/Game/UI/WBP/Activity/Widget/Coop/WBP_Activity_Coop_PauseRoundItem.WBP_Activity_Coop_PauseRoundItem'"
end

function M:SetCurRound(InRound)
  self.TextNow:SetText(tostring(InRound))
end

function M:Construct()
end

function M:InitAsyncCombat(AsyncCombatInfo)
  if not AsyncCombatInfo then
    DebugPrint("WBP_Activity_Coop_PauseRound_C InitAsyncCombat 失败 AsyncCombatInfo为空")
    return
  end
  self.BossUnitID = AsyncCombatInfo.BossUnitID
  self.TotalRound = #self.BossUnitID
  self.TextTotal:SetText("/" .. tostring(self.TotalRound))
  for I = 1, self.TotalRound do
    local WidgetName = "PauseRoundItem" .. tostring(I)
    self[WidgetName] = nil
  end
  self.ScrollListRound:ClearChildren()
  for I = 1, self.TotalRound do
    local WidgetName = "PauseRoundItem" .. tostring(I)
    local CreatedWidget = UIManager(self):CreateWidget(self.PauseRoundItemBPClassPath, true)
    if CreatedWidget then
      self[WidgetName] = CreatedWidget
    end
    self.ScrollListRound:AddChild(CreatedWidget)
    if I < 10 then
      CreatedWidget.TextNum:SetText("0" .. tostring(I))
    else
      CreatedWidget.TextNum:SetText(tostring(I))
    end
  end
end

function M:UpdateVX(CurRound, BossRound)
  if not CurRound or not BossRound then
    return
  end
  for I = 1, self.TotalRound do
    local WidgetName = "PauseRoundItem" .. tostring(I)
    local bBossRound = false
    for _, B in pairs(BossRound) do
      if B == I then
        bBossRound = true
        break
      end
    end
    if not bBossRound then
      self[WidgetName]:PlayAnimation(self[WidgetName].Boss_Folded)
    else
      self[WidgetName]:PlayAnimation(self[WidgetName].Boss_Normal)
    end
    if I < CurRound then
      self[WidgetName]:PlayAnimation(self[WidgetName].Done)
    elseif I == CurRound then
      self[WidgetName]:PlayAnimation(self[WidgetName].Active)
    else
      self[WidgetName]:PlayAnimation(self[WidgetName].Lock)
    end
    if I ~= self.TotalRound then
      self[WidgetName]:PlayAnimation(self[WidgetName].Line_Normal)
    else
      self[WidgetName]:PlayAnimation(self[WidgetName].Line_Folded)
    end
  end
end

function M:ScrollWidgetIntoView(CurRound)
  if not CurRound then
    return
  end
  local WidgetName = "PauseRoundItem" .. tostring(CurRound)
  if self[WidgetName] then
    self.ScrollListRound:ScrollWidgetIntoView(self[WidgetName])
  end
end

return M
