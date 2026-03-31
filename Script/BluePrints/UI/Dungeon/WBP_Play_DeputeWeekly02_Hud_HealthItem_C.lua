require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  EventManager:AddEvent(EventID.OnSynthesisEnergyValueChange, self, self.OnSynthesisEnergyValueChange)
  self.Full = false
end

function M:OnListItemObjectSet(Content)
  self.Content = Content
  self.Content.UI = self
  self:Init(Content)
end

function M:Init(Content)
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Progress = GameState.SynthesisEnergyValues:FindRef(self.Content.StaticCreatorId)
  if nil == Progress then
    self:SetProgress(0)
  else
    self:SetProgress(Progress)
  end
  local TexturePath = ""
  if 1 == Content.Index then
    TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_A.T_Gp_Digging_A'"
  elseif 2 == Content.Index then
    TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_B.T_Gp_Digging_B'"
  elseif 3 == Content.Index then
    TexturePath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/GuidePoint/T_Gp_Digging_C.T_Gp_Digging_C'"
  end
  local Texture = LoadObject(TexturePath)
  self.Image_Icon:SetBrushFromTexture(Texture)
end

function M:SetProgress(Progress)
  self.Progress = Progress
  self.Text_Percent:SetText(math.floor(Progress * 100))
  local Material = self.progress_Bar:GetDynamicMaterial()
  if Material then
    Material:SetScalarParameterValue("Percent", 1 - Progress)
  end
  if 1 == Progress and not self.Full then
    self:PlayAnimation(self.Up)
    self.Full = true
    AudioManager(self):PlayUISound(self, "event:/ui/common/week_level_progress_full", nil, nil)
  end
end

function M:Max()
  local MatPath = "/Game/UI/WBP/Common/VX/UIVX/Material/MI_Word_Wave.MI_Word_Wave"
  UResourceLibrary.LoadObjectAsync(self, MatPath, {
    self,
    function(self, Mat)
      local Font = self.Text_Percent.Font
      Font.FontMaterial = Mat
      self.Text_Percent:SetFont(Font)
      local FontP = self.Text_p.Font
      FontP.FontMaterial = Mat
      self.Text_p:SetFont(FontP)
    end
  })
end

function M:OnSynthesisEnergyValueChange()
  local GameState = UE4.UGameplayStatics.GetGameState(self)
  local Progress = GameState.SynthesisEnergyValues:FindRef(self.Content.StaticCreatorId)
  if nil == Progress then
    Progress = self.Progress
  end
  self:SetProgress(Progress)
end

return M
