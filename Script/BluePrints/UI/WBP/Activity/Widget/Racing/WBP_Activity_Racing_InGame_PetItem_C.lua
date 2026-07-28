require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local PetItemState = {
  Empty = 0,
  Normal = 1,
  Highlight = 2,
  Selected = 3
}

local function SetTextSafely(Widget, Text)
  if Widget and Widget.SetText and nil ~= Text then
    Widget:SetText(Text)
  end
end

local function SetVisibilitySafely(Widget, Visibility)
  if Widget and Widget.SetVisibility then
    Widget:SetVisibility(Visibility)
  end
end

local function FormatRankWidgets(Rank)
  local Num = tonumber(Rank) or 0
  if Num <= 0 then
    return nil, nil
  end
  if Num <= 6 then
    return tostring(Num), nil
  end
  return nil, tostring(Num)
end

function M:Construct()
  self.DisplayState = PetItemState.Empty
  self.PetImage = self.Image_Pet
  self.IndexGroup = self.HB_Index
  self.Btn_Click.OnClicked:Add(self, self.OnBtnClicked)
end

function M:Destruct()
  self.Btn_Click.OnClicked:Remove(self, self.OnBtnClicked)
end

function M:SetPetData(Data, Index, TotalCount)
  self.PetData = Data
  self.SlotIndex = Index
  self.TotalCount = tonumber(TotalCount) or self.TotalCount or 0
  if not Data then
    self.PetId = nil
    self.Ranking = nil
    self.LastRanking = nil
    self.DisplayState = PetItemState.Empty
    self:RefreshDynamicVisual()
    return
  end
  local LastPetId = self.PetId
  self.PetId = Data.PetId
  self.Ranking = Data.Ranking
  self.LastRanking = Data.Ranking
  self:UpdateDisplayState()
  if LastPetId ~= self.PetId then
    self:RefreshStaticVisual()
  end
  self:RefreshDynamicVisual()
end

function M:UpdateRuntimeData(Data)
  if not Data then
    return
  end
  self.PetData = Data
  self.Ranking = Data.Ranking
  self:UpdateDisplayState()
  if self.LastRanking ~= self.Ranking then
    self:RefreshDynamicVisual()
    self.LastRanking = Data.Ranking
  end
end

function M:OnListItemObjectSet(Content)
  self:SetPetData(Content, Content and Content.Index, Content and Content.TotalCount)
end

function M:SetDisplayState(State)
  self.DisplayState = State or PetItemState.Normal
  self:ApplyState()
end

function M:SetSelectedState(bSelected)
  self.IsSelected = true == bSelected
  self:PlayAnimation(self.IsSelected and self.Click or self.Unselect)
end

function M:SetSelectState(bSelected)
  self:SetSelectedState(bSelected)
end

function M:OnBtnClicked()
  if not self.PetData then
    return
  end
  if self.OnItemClicked then
    self:SetSelectedState(true)
    self:PlayAnimation(self.Click)
    self.OnItemClicked(self.OnItemClickedObj, self)
  end
end

function M:BindOnClicked(Obj, Func)
  self.OnItemClickedObj = Obj
  self.OnItemClicked = Func
end

function M:UpdateDisplayState()
  if not self.PetData then
    self.DisplayState = PetItemState.Empty
    return
  end
  local CurrentRanking = tonumber(self.Ranking or 0)
  if CurrentRanking > 0 and CurrentRanking <= 6 then
    self.DisplayState = PetItemState.Highlight
  else
    self.DisplayState = PetItemState.Normal
  end
end

function M:RefreshStaticVisual()
  if not self.PetId then
    return
  end
  local PlayerInfo = DataMgr.RaceLotteryPlayer[self.PetId]
  local IconPath = PlayerInfo.PlayerIcon
  local IconDice = LoadObject(IconPath)
  self.Image_Pet:SetBrushFromTexture(IconDice)
end

function M:RefreshDynamicVisual()
  if not self.PetData then
    self:ApplyState()
    return
  end
  local RankingText = string.format(GText("UI_RaceLottery_PlayerRaceRank"), self.Ranking or 0)
  DebugPrint(string.format("Racing_InGame PetId = %s , RankingText = %s", self.PetId, RankingText))
  self.Text_IndexNum_Front:SetText(RankingText)
  self.Text_IndexNum_Behind:SetText(RankingText)
  self:ApplyState()
end

function M:ApplyState()
  local bEmpty = self.DisplayState == PetItemState.Empty or self.PetData == nil
  if bEmpty then
    self:PlayAnimation(self.Empty)
    DebugPrint("Racing_InGame SetEmpty")
    return
  end
  local CurrentRanking = tonumber(self.Ranking or 0)
  if CurrentRanking > 0 and CurrentRanking <= 6 then
    self.Text_IndexNum_Front:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self.Text_IndexNum_Behind:SetVisibility(ESlateVisibility.Collapsed)
    self:PlayAnimation(self.MVP)
  else
    self.Text_IndexNum_Front:SetVisibility(ESlateVisibility.Collapsed)
    self.Text_IndexNum_Behind:SetVisibility(ESlateVisibility.SelfHitTestInvisible)
    self:PlayAnimation(self.Normal)
  end
  if self.LastRanking ~= self.Ranking and (tonumber(self.Ranking) or 0) <= 6 then
    self:PlayAnimation(self.MVP_In)
  end
end

return M
