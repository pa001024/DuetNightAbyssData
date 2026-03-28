require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})
local TaskUtils = require("BluePrints.UI.TaskPanel.TaskUtils")

function M:Initialize(Initializer)
  DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Initialize")
end

function M:Construct()
  DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Construct")
  EventManager:AddEvent(EventID.OnContainerBeAttacked, self, self.OnContainerAttacked)
  EventManager:AddEvent(EventID.OnContainerBeRepaired, self, self.OnContainerRepaired)
  EventManager:AddEvent(EventID.OnContainerDestroyed, self, self.OnContainerDestroyed)
end

function M:Destruct()
  DebugPrint("yly    WBP_SoloTreasure_HudItem01_C Destruct")
  EventManager:RemoveEvent(EventID.OnContainerBeAttacked, self)
  EventManager:RemoveEvent(EventID.OnContainerBeRepaired, self)
  EventManager:RemoveEvent(EventID.OnContainerDestroyed, self)
end

function M:SetData(data)
  if nil == data then
    GWorld.logger.error("WBP_SoloTreasure_HudItem01_C get data = nil")
    return
  end
  self.Order = data.Order
  self.ContainerId = data.ContainerId
  self.CurHpPercent = 1.0
  self:ShowHP(self.CurHpPercent)
  local GameInstance = UE4.UGameplayStatics.GetGameInstance(self)
  if nil == GameInstance then
    DebugPrint("WBP_SoloTreasure_HudItem01_C: GameInstance 不存在")
    return
  end
  local SceneManager = GameInstance:GetSceneManager()
  if nil == SceneManager then
    DebugPrint("WBP_SoloTreasure_HudItem01_C: SceneManager 不存在")
    return
  end
  local Content = string.char(string.byte("A") + self.Order - 1)
  local RetPath = SceneManager:GetExcavationABCIconPath(Content)
  UE4.UResourceLibrary.LoadObjectAsync(self, RetPath, {
    self,
    self.RealSetABCImg
  })
end

function M:SetSpecialEffectForDiffHp(CurHpPercent)
  if CurHpPercent >= 0.5 then
    self:PlayAnimation(self.HP_Healthy)
  elseif CurHpPercent > 0 then
    self:PlayAnimation(self.HP_Low)
  else
    self:PlayAnimation(self.Destroyed)
    AudioManager(self):PlayUISound(self, "event:/ui/common/excavation_warning", nil, nil)
  end
end

function M:RealSetABCImg(Object)
  self.Icon_Organ:SetBrushResourceObject(Object)
end

function M:ShowHP(CurHpPercent)
  self.Progress:GetDynamicMaterial():SetScalarParameterValue("Percent", 1.0 - CurHpPercent)
  self:PlayAnimation(self.Normal)
  self:AddTimer(0.1, function()
    self:SetSpecialEffectForDiffHp(CurHpPercent)
  end)
end

function M:OnContainerAttacked(CStaticId, CurHpPercent)
  if CStaticId == self.ContainerId then
    DebugPrint("yly HudItem01 CStaticId = ", CStaticId, "Attacked, ShowHP = ", CurHpPercent)
    self:ShowHP(CurHpPercent)
    if not self:IsExistTimer("TimerRedFlash" .. self.ContainerId) then
      self:AddTimer(0.2, function()
        self:PlayAnimation(self.UnderAttack)
      end, false, 0, "TimerGap" .. self.ContainerId)
      self:AddTimer(1.5, function()
        self:PlayAnimation(self.Normal)
      end, false, 0, "TimerRedFlash" .. self.ContainerId)
    end
  end
end

function M:OnContainerRepaired(CStaticId, CurHpPercent)
  if CStaticId == self.ContainerId then
    self:ShowHP(CurHpPercent)
    self:PlayAnimation(self.Return)
  end
end

function M:OnContainerDestroyed(CStaticId)
  if CStaticId == self.ContainerId then
    self:RemoveTimer("TimerRedFlash" .. self.ContainerId)
    self:RemoveTimer("TimerGap" .. self.ContainerId)
    DebugPrint("yly HudItem01 CStaticId = ", CStaticId, "Destroyed, ShowHP = ", 0)
    self:ShowHP(0)
  end
end

return M
