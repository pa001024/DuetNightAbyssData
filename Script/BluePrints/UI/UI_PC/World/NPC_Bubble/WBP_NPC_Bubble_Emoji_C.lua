require("UnLua")
require("DataMgr")
local WBP_NPC_Bubble_Emoji_C = Class("BluePrints.UI.BP_EMUserWidget_C")

function WBP_NPC_Bubble_Emoji_C:Initialize(Initializer)
  self.ParentHeadWidget = nil
  self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_Emoji_C:Init(ParentHeadWidget)
  self:SetVisibility(ESlateVisibility.Collapsed)
  self.ParentHeadWidget = ParentHeadWidget
  self.bIsEnabled_Bubble = false
end

function WBP_NPC_Bubble_Emoji_C:OnEnabled(IconPath)
  if not self.ParentHeadWidget then
    return
  end
  if self.bIsEnabled_Bubble then
    return
  end
  self.bIsEnabled_Bubble = true
  self.IconPath = IconPath
  UResourceLibrary.LoadObjectAsync(self, IconPath, {
    self,
    function(obj, Image)
      if not IsValid(obj) then
        return
      end
      if not self.bIsEnabled_Bubble then
        return
      end
      if self.IconPath ~= IconPath then
        return
      end
      self.WS_Emoji:SetActiveWidgetIndex(0)
      self.Image_EmojiBig:SetBrushFromTexture(Image)
      self:StopAllAnimations()
      self:PlayAnimation(self.In)
      self:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
    end
  })
end

function WBP_NPC_Bubble_Emoji_C:OnDisabled()
  if not self.bIsEnabled_Bubble then
    return
  end
  self.bIsEnabled_Bubble = false
  self.IconPath = nil
  self:StopAllAnimations()
  self:PlayAnimation(self.Out)
  self.Image_EmojiBig:SetBrushFromTexture(nil)
end

function WBP_NPC_Bubble_Emoji_C:ResetForPool()
  self:StopAllAnimations()
  self.bIsEnabled_Bubble = false
  self.IconPath = nil
  self.Image_EmojiBig:SetBrushFromTexture(nil)
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

function WBP_NPC_Bubble_Emoji_C:OnInAnimationFinished()
  self:PlayAnimation(self.Loop, 0, 0)
end

function WBP_NPC_Bubble_Emoji_C:OnAnimationFinished(InAnimation)
  if InAnimation == self.In then
    self:OnInAnimationFinished()
  elseif InAnimation == self.Out then
    self:OnOutAnimationFinished()
  end
end

function WBP_NPC_Bubble_Emoji_C:OnOutAnimationFinished()
  self:SetVisibility(UE4.ESlateVisibility.Collapsed)
end

return WBP_NPC_Bubble_Emoji_C
