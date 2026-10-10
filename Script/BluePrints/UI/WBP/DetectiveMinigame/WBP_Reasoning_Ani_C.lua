require("UnLua")
local M = Class("BluePrints.UI.BP_UIState_C")

function M:Construct()
  self.GameInputModeSubsystem:SetNavigateWidgetOpacity(0)
end

function M:SetCharacterImg()
  local CharaImg = self:TryGetConfigCharaImg() or self:TryGetDefaultCharaImg()
  if not CharaImg then
    return
  end
  self.Image_Avatar:SetBrushResourceObject(CharaImg)
end

function M:TryGetConfigCharaImg()
  if not self.QuestionId then
    return nil
  end
  local Question = DataMgr.DetectiveQuestion[self.QuestionId]
  if not Question then
    return nil
  end
  local ImagePath = Question.ReasoningImagePath
  if not ImagePath or "" == ImagePath then
    return nil
  end
  local CharaImg = LoadObject(ImagePath)
  if not CharaImg then
    DebugPrint("Error: WBP_Reasoning_Ani_C TryGetConfigCharaImg 推理图片加载失败 QuestionId: ", self.QuestionId, " ImagePath: ", ImagePath)
  end
  return CharaImg
end

function M:TryGetDefaultCharaImg()
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    DebugPrint("Error: WBP_Reasoning_Ani_C TryGetDefaultCharaImg 找不到Avatar")
    return nil
  end
  local RegionId = Avatar:GetCurrentRegionId()
  if not RegionId or DataMgr.SubRegion[RegionId] == nil then
    DebugPrint("Error: WBP_Reasoning_Ani_C TryGetDefaultCharaImg 找不到区域或区域对应Player数据 RegionId: ", RegionId)
    return nil
  end
  local PlayerIdentity = DataMgr.SubRegion[RegionId].SwitchPlayer
  if not PlayerIdentity then
    DebugPrint("Error: WBP_Reasoning_Ani_C TryGetDefaultCharaImg 当前区域没有可切换角色")
    return nil
  end
  local ImagePath
  if "Player" == PlayerIdentity then
    if 1 == Avatar.Sex then
      ImagePath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_Female.T_Reasoning_Female'"
    else
      ImagePath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_Male.T_Reasoning_Male'"
    end
  elseif 1 == Avatar.WeitaSex then
    ImagePath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_EXFemale.T_Reasoning_EXFemale'"
  else
    ImagePath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Reasoning/T_Reasoning_EXMale.T_Reasoning_EXMale'"
  end
  return LoadObject(ImagePath)
end

function M:OnLoaded(...)
  M.Super:OnLoaded(...)
  self.Answers, self.AnswerId, self.QuestionId = ...
  self:SetCharacterImg()
  self:BindToAnimationFinished(self.In, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.In)
      self.AssociateWidget = UIManager(self):LoadUINew("DetectiveAssociate", 2, self.Answers, self.AnswerId)
      self:PlayAnimation(self.Out)
    end
  })
  self:BindToAnimationFinished(self.Out, {
    self,
    function()
      self:UnbindAllFromAnimationFinished(self.Out)
      self.AssociateWidget:SetVisibility(UE4.ESlateVisibility.SelfHitTestInvisible)
      self.AssociateWidget:StopAllAnimations()
      self.AssociateWidget:StartPlayInAnimation()
      self:Close()
    end
  })
  self:PlayAnimation(self.In)
  AudioManager(self):PlayUISound(self, "event:/ui/common/tuili_clue_think_inspiration", nil, nil)
  self:SetFocus()
end

return M
