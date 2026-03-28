local M = Class("BluePrints.UI.BP_UIState_C")
local MOBILE_SCALE = 0.8
local PC_SCALE = 1

function M:OnLoaded()
  self.IsInit = true
  self:AddDispatcher(EventID.OnMobileHudPlanChanged, self, self.OnMobileHudPlanChanged)
end

function M:OnMobileHudPlanChanged(OpType, LayoutPlan, _, _)
  if "Update" == OpType then
    self:ApplyServerLayoutPosition(LayoutPlan)
  end
end

function M:RemoveSelf()
  self:Close()
end

function M:IsMainPlayerSummon(Summoner, UIOwner, UISummonId)
  if Summoner and UIOwner and Summoner.UnitId == UISummonId and Summoner:GetRootSourceEid() == UIOwner.Eid then
    return true
  end
  return false
end

function M:InitBattleCharUI(CharUIId, GradeLevel)
  local CharUIInfo = DataMgr.BattleCharUI[CharUIId][GradeLevel]
  if CharUIInfo then
    if CharUIInfo.ScaleNode then
      self:InitQuantityScale(CharUIInfo.ScaleNode)
    end
    local MainNode = self.Main
    local Offset = self.Offset_M
    if MainNode and Offset and CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile" then
      local bHasServerLayout = self:HasServerLayoutPosition()
      if bHasServerLayout then
      else
        local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(MainNode)
        local Padding = Slot.Padding
        Padding.Bottom = Offset
        Slot:SetPadding(Padding)
      end
    end
  end
  self.FrameCount = 0
  self:ApplyServerLayoutPosition()
end

function M:HasServerLayoutPosition()
  local BattleMain = UIManager(self.Owner):GetUI("BattleMain")
  if not BattleMain then
    return false
  end
  local LayoutInfo = BattleMain:GetLayoutInfoFromServer("SpSkillPos")
  return nil ~= LayoutInfo
end

function M:ApplyServerLayoutPosition(LayoutPlan)
  if CommonUtils.GetDeviceTypeByPlatformName(self) ~= "Mobile" then
    return
  end
  local BattleMain = UIManager(self.Owner):GetUI("BattleMain")
  if not BattleMain then
    DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "BattleMain UI 未找到，跳过服务端布局设置")
    return
  end
  local LayoutInfo = BattleMain:GetLayoutInfoFromServer("SpSkillPos", LayoutPlan)
  if not LayoutInfo then
    DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "服务端无 SpSkillPos 布局数据，使用默认位置")
    return
  end
  local MainNode = self.Main
  if not MainNode then
    DebugPrint("gmy@Battle_Skill_UI_Base M:ApplyServerLayoutPosition", "self.Main 节点不存在，无法应用布局数据")
    return
  end
  local Slot = UE4.UWidgetLayoutLibrary.SlotAsOverlaySlot(MainNode)
  local Padding = Slot.Padding
  Padding.Left = LayoutInfo.PosX
  Padding.Bottom = -LayoutInfo.PosY
  Slot:SetPadding(Padding)
  if LayoutInfo.ScaleX ~= nil and nil ~= LayoutInfo.ScaleY then
    local NewScale = FVector2D(LayoutInfo.ScaleX, LayoutInfo.ScaleY)
    MainNode:SetRenderScale(NewScale)
  end
end

function M:Tick(MyGeometry, InDeltaTime)
  self.FrameCount = self.FrameCount or 0
  self.FrameCount = self.FrameCount + 1
end

function M:InitQuantityScale(ScaleNode)
  local bIsMobile = CommonUtils.GetDeviceTypeByPlatformName(self) == "Mobile"
  local Scale = bIsMobile and MOBILE_SCALE or PC_SCALE
  if self[ScaleNode] then
    self[ScaleNode]:SetRenderScale(FVector2D(Scale, Scale))
  end
end

function M:TrySetSummon(SummonId, bIsSummonMonster)
  if nil == self.Summoner then
    local Player = GWorld:GetMainPlayer()
    if Player then
      local Summons = Player:GetSummonsList(SummonId, bIsSummonMonster, not bIsSummonMonster)
      for _, Eid in pairs(Summons) do
        local Summoner = Battle(self):GetEntity(Eid)
        if IsValid(Summoner) and Summoner.UnitId == SummonId then
          DebugPrint("gmy@Battle_Skill_UI_Base M:TrySetSummon", Summoner)
          self.Summoner = Summoner
          if self.OnSummonerAdd then
            self:OnSummonerAdd(Summoner)
          end
          return
        end
      end
    end
  end
end

return M
