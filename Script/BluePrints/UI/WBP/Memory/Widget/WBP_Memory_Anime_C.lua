require("UnLua")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.CinematicId = Content.CinematicId
  self.ChapterId = Content.ChapterId
  self.Index = Content.Index or 0
  self.OnClickCallback = Content.OnClicked
  self.SetUp = 1 == self.Index % 2
  self:SetAnimeUp()
  local AnimeScale = 1.0
  if Content.GetAnimeScale then
    AnimeScale = Content.GetAnimeScale()
  end
  local Padding = FMargin(0, 0, 0, 0)
  if 1 == self.Index then
    Padding.Left = 100
  elseif self.Index == Content.LastIndex then
    Padding.Right = 120
  end
  self:SetPadding(Padding)
  self:SetRenderScale(FVector2D(AnimeScale, AnimeScale))
  self:BindButtons()
  self:RefreshView()
end

function M:BindButtons()
  if self.BtnBinded then
    return
  end
  self.Btn_Area.OnClicked:Add(self, self.OnClickSelf)
  self.BtnBinded = true
end

function M:OnClickSelf()
  AudioManager(self):PlayUISound(self, "event:/ui/common/click_btn_large", nil, nil)
  if self.OnClickCallback then
    self.OnClickCallback(self.CinematicId)
  end
end

function M:RefreshView()
  local ReviewConfig = DataMgr.CinematicReview[self.CinematicId]
  if not ReviewConfig then
    DebugPrint(ErrorTag, "CinematicReview not found: ", self.CinematicId)
    return
  end
  self.Num_Chapter:SetText(tostring(self.Index))
  self.Text_Chapter:SetText(GText(ReviewConfig.CinematicName))
  self.Img_Anime:SetBrushFromTexture(LoadObject(ReviewConfig.IconPath or ""))
end

function M:BP_GetDesiredFocusTarget()
  return self.Btn_Area
end

return M
