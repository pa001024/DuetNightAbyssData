local M = Class()

function M:OnInitializeEvent()
end

function M:UpdateImageWidget(ImagePath)
  DebugPrint("ImageSequenceInstance:UpdateImageWidget", ImagePath)
  if not IsValid(self.ImageWidget) then
    self.ImageWidget = UIManager(self):_CreateWidgetNew("StoryImgSequence")
    self.ImageWidget:AddToViewport(-1)
  end
  local DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(self, ImagePath, self)
  if not DialogueImage then
    local Message = "Sequence图片资源缺失" .. "\n路径:" .. ImagePath
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Sequence, "图片资源缺失", Message)
    return
  end
  self.ImageWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.ImageWidget:SetImage(DialogueImage)
end

function M:HideImageWidget()
  DebugPrint("ImageSequenceInstance:HideImageWidget")
  if not IsValid(self.ImageWidget) then
    return
  end
  self.ImageWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:UpdateIconWidget(ImagePath)
  DebugPrint("ImageSequenceInstance:UpdateIconWidget", ImagePath)
  if not IsValid(self.IconWidget) then
    self.IconWidget = UIManager(self):_CreateWidgetNew("StoryImgItem")
    self.IconWidget:AddToViewport(0)
  end
  local DialogueImage = UStoryFunctionLibrary.LoadResourceWithGender(self, ImagePath, self)
  if not DialogueImage then
    local Message = "Sequence Icon资源缺失" .. "\n路径:" .. ImagePath
    UStoryLogUtils.PrintToFeiShu(GWorld.GameInstance, UE.EStoryLogType.Sequence, "图片资源缺失", Message)
    return
  end
  self.IconWidget:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  self.IconWidget:DireceShowPicture(DialogueImage)
end

function M:HideIconWidget()
  DebugPrint("ImageSequenceInstance:HideIconWidget")
  if not IsValid(self.IconWidget) then
    return
  end
  self.IconWidget:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

function M:OnDestroyedEvent()
  if IsValid(self.IconWidget) then
    self.IconWidget:RemoveFromParent()
    self.IconWidget = nil
  end
  if IsValid(self.ImageWidget) then
    self.ImageWidget:RemoveFromParent()
    self.ImageWidget = nil
  end
end

return M
