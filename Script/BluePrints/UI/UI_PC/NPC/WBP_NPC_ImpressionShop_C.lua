require("UnLua")
local WBP_NPC_ImpressionShop_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_NPC_ImpressionShop_C:Initialize(Initializer)
  self.bIsEnabled_Impression = false
end

function WBP_NPC_ImpressionShop_C:Init(ParentHeadWidget)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
  self.IconPath = nil
  self.bIsEnabled_Impression = false
end

function WBP_NPC_ImpressionShop_C:OnEnabled(Npc)
  if self.bIsEnabled_Impression then
    return
  end
  self.bIsEnabled_Impression = true
  if not self.IconPath then
    local NpcData = DataMgr.Npc[Npc.NpcId]
    if NpcData and NpcData.HeadIconPath then
      self.IconPath = NpcData.HeadIconPath
    end
  end
  self:TryChangeIconPath()
  if not self:IsAnimationPlaying(self.In) then
    self:StopAllAnimations()
    self:PlayAnimation(self.In)
  end
  self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
end

function WBP_NPC_ImpressionShop_C:TryChangeIconPath()
  if not self.IconPath then
    return
  end
  if self.CurrentIconPath ~= self.IconPath then
    local RequestedIconPath = self.IconPath
    self.CurrentIconPath = RequestedIconPath
    UE.UResourceLibrary.LoadObjectAsync(self, RequestedIconPath, {
      self,
      function(Obj, HeadIcon)
        if not (IsValid(Obj) and Obj.bIsEnabled_Impression) or Obj.CurrentIconPath ~= RequestedIconPath then
          return
        end
        Obj:OnHeadIconLoaded(HeadIcon)
      end
    })
  end
end

function WBP_NPC_ImpressionShop_C:OnHeadIconLoaded(HeadIcon)
  DebugPrint("WBP_NPC_ImpressionShop_C:OnHeadIconLoaded", HeadIcon)
  if HeadIcon then
    self.Image_Icon:SetBrushFromTexture(HeadIcon)
  end
end

function WBP_NPC_ImpressionShop_C:OnDisabled()
  if not self.bIsEnabled_Impression then
    return
  end
  self.bIsEnabled_Impression = false
  if not self:IsAnimationPlaying(self.Out) then
    self:StopAllAnimations()
    self:PlayAnimation(self.Out)
  end
end

function WBP_NPC_ImpressionShop_C:ResetForPool()
  self:StopAllAnimations()
  self.bIsEnabled_Impression = false
  self.IconPath = nil
  self.CurrentIconPath = nil
  self.Image_Icon:SetBrushFromTexture(nil)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_NPC_ImpressionShop_C:OnAnimationFinished(InAnimation)
  if InAnimation == self.Out then
    self:OnOutAnimationFinished()
  end
end

function WBP_NPC_ImpressionShop_C:OnOutAnimationFinished()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return WBP_NPC_ImpressionShop_C
