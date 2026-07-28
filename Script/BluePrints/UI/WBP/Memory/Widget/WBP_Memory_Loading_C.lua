require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C",
  "BluePrints.Common.TimerMgr"
})

function M:Construct()
end

function M:Destruct()
end

function M:InitLoadingData(ChapterId, ParentUI)
  self.ParentUI = ParentUI
  local ChapterInfo = DataMgr.CinematicChapter[ChapterId]
  if not ChapterInfo then
    return
  end
  if ChapterInfo.ChapterNumber then
    self.Text_Chapter:SetText(GText(ChapterInfo.ChapterNumber))
  end
  if self.Name_Chapter and ChapterInfo.ChapterName then
    self.Name_Chapter:SetText(GText(ChapterInfo.ChapterName))
  end
  if ChapterInfo.ChapterIconPath then
    local IconTexture = LoadObject(ChapterInfo.ChapterIconPath)
    if IconTexture then
      local ImageIconMat = self.Icon_Chapter:GetDynamicMaterial()
      ImageIconMat:SetTextureParameterValue("IconTex", IconTexture)
    end
  end
  if ChapterInfo.ChapterShadowPath then
    local IconShadowTexture = LoadObject(ChapterInfo.ChapterShadowPath)
    if IconShadowTexture then
      self.Shadow_Chapter:SetBrushFromTexture(IconShadowTexture)
    end
  end
  if ChapterInfo.IconPath then
    local IconTexture = LoadObject(ChapterInfo.IconPath)
    if IconTexture then
      self.Icon_Chapter:SetBrushFromTexture(IconTexture)
    end
  end
  self:PlayAnimation(self.In)
  self.Loading:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
  self.Loading:PlayAnimation(self.Loading.In)
  self.Loading:BindToAnimationFinished(self.Loading.In, {
    self.Loading,
    function()
      self.Loading:UnbindAllFromAnimationFinished(self.Loading.In)
      self.Loading:PlayAnimation(self.Loading.Loop, 1, 0)
    end
  })
  if not ParentUI then
    self:ConstructSoundFunc()
  end
end

function M:CloseUI(UnLoadingCallback)
  self:RemoveFromParent()
  self:DestructSoundFunc()
end

function M:ConstructSoundFunc()
  AudioManager(self):PlayUISound(self, "event:/ui/common/cine_review_loading", "Loading", nil)
  AudioManager(self):PausePlayBGMCauseIsLoadingOrBlackScreen()
  AudioManager(self):AddAuANotifyForbidTag("self")
end

function M:DestructSoundFunc()
  AudioManager(self):SetEventSoundParam(self, "Loading", {ToEnd = 1})
  AudioManager(self):ResumePlayBGMCauseIsLoadingOrBlackScreen()
  AudioManager(self):RemoveAuANotifyForbidTag("self")
end

AssembleComponents(M)
return M
