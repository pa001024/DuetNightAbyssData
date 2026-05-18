require("UnLua")
local M = Class({
  "BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_ContentBase"
})

function M:Construct()
  self.MaxLength = 730
  self.List_Info:SetScrollBarVisibility(ESlateVisibility.Hidden)
  self.List_Info:SetControlScrollbarInside(true)
  self.FenghuaProgress.Text_Fernghua:SetText(GText("UI_AppearanceScore_ScoreName"))
end

function M:InitContent(Params, PopupData, Owner)
  self.Owner = Owner
  self.Parent = Params.Parent
  self:InitScoreRule()
  self:Init()
end

function M:InitScoreRule()
  self.RuleTable = {}
  self.DyeType = {
    Skin = 1,
    Hair = 2,
    WeaponSkin = 3
  }
  for _, Info in pairs(DataMgr.AppearanceScore) do
    if not self.RuleTable[Info.Type] then
      self.RuleTable[Info.Type] = {}
    end
    self.RuleTable[Info.Type][Info.Rarity] = Info.Score
  end
  self.SpecialAppearanceTable = {}
  for _, Info in pairs(DataMgr.AppearanceSingleScore) do
    if not self.SpecialAppearanceTable[Info.Type] then
      self.SpecialAppearanceTable[Info.Type] = {}
    end
    self.SpecialAppearanceTable[Info.Type][Info.Id] = Info.Score
  end
end

function M:Init()
  local AppearacneScoreTable = {}
  local DyeScoreTable = {}
  local DyeNumTable = {}
  for Type, _ in pairs(self.DyeType) do
    DyeNumTable[Type] = 0
  end
  for _, AppearanceCollectInfo in ipairs(DataMgr.AppearanceCollect) do
    local SubScore = 0
    if AppearanceCollectInfo.SubTabId then
      for _, SubTabId in pairs(AppearanceCollectInfo.SubTabId) do
        local AppearanceSubTabInfo = DataMgr.AppearanceSubTab[SubTabId]
        if AppearanceSubTabInfo.FieldName then
          local Type = {}
          if AppearanceSubTabInfo.SubType then
            for _, Name in pairs(AppearanceSubTabInfo.SubType) do
              Type[Name] = 1
            end
          end
          local Data = DataMgr[AppearanceSubTabInfo.ParentIndex]
          if Data then
            for Id, Info in pairs(Data) do
              if not Info.ExcludeCollectServer and Info[AppearanceSubTabInfo.FieldName] and Type[Info[AppearanceSubTabInfo.FieldName]] then
                if self.SpecialAppearanceTable[AppearanceCollectInfo.Type] and self.SpecialAppearanceTable[AppearanceCollectInfo.Type][Id] then
                  SubScore = SubScore + self.SpecialAppearanceTable[AppearanceCollectInfo.Type][Id]
                elseif Info.Rarity or Info.MountRarity then
                  SubScore = SubScore + (self.RuleTable[AppearanceCollectInfo.Type][Info.Rarity or Info.MountRarity] or 0)
                end
                if self.DyeType[AppearanceSubTabInfo.ParentIndex] and self:CheckCanDye(AppearanceSubTabInfo.ParentIndex, Id) then
                  DyeNumTable[AppearanceSubTabInfo.ParentIndex] = DyeNumTable[AppearanceSubTabInfo.ParentIndex] + 1
                end
              end
            end
          end
        else
          local Data = DataMgr[AppearanceSubTabInfo.ParentIndex]
          if Data then
            for Id, Info in pairs(Data) do
              if not Info.ExcludeCollectServer then
                if self.SpecialAppearanceTable[AppearanceCollectInfo.Type] and self.SpecialAppearanceTable[AppearanceCollectInfo.Type][Id] then
                  SubScore = SubScore + self.SpecialAppearanceTable[AppearanceCollectInfo.Type][Id]
                elseif Info.Rarity or Info.MountRarity then
                  SubScore = SubScore + (self.RuleTable[AppearanceCollectInfo.Type][Info.Rarity or Info.MountRarity] or 0)
                end
                if self.DyeType[AppearanceSubTabInfo.ParentIndex] and self:CheckCanDye(AppearanceSubTabInfo.ParentIndex, Id) then
                  DyeNumTable[AppearanceSubTabInfo.ParentIndex] = DyeNumTable[AppearanceSubTabInfo.ParentIndex] + 1
                end
              end
            end
          end
        end
      end
    end
    AppearacneScoreTable[AppearanceCollectInfo.Entrance] = SubScore
    AppearacneScoreTable[AppearanceCollectInfo.Entrance] = {ScoreMax = SubScore}
  end
  local SingleMaxDyeScore = 0
  for _, DyeScoreInfo in pairs(DataMgr.DyeScore) do
    if DyeScoreInfo.MaxScore then
      SingleMaxDyeScore = SingleMaxDyeScore + DyeScoreInfo.MaxScore
    end
  end
  local SumDyeScore = 0
  for Type, Num in pairs(DyeNumTable) do
    local Score = Num * SingleMaxDyeScore
    table.insert(DyeScoreTable, {ScoreMax = Score, Type = Type})
    SumDyeScore = SumDyeScore + Score
  end
  table.sort(DyeScoreTable, function(a, b)
    return self.DyeType[a.Type] < self.DyeType[b.Type]
  end)
  local Avatar = GWorld:GetAvatar()
  local CurAppearacneScore = 0
  local SumAppearacneScore = 0
  for Entrance, ScoreInfo in ipairs(AppearacneScoreTable) do
    local ScoreCur = 0
    if Avatar then
      local Type = DataMgr.AppearanceCollect[Entrance].Type
      ScoreCur = Avatar.AppearanceScores[Type] or 0
    end
    ScoreInfo.ScoreCur = ScoreCur
    CurAppearacneScore = CurAppearacneScore + ScoreInfo.ScoreCur
    SumAppearacneScore = SumAppearacneScore + ScoreInfo.ScoreMax
  end
  local AppearacneScoreInfo = {}
  table.insert(AppearacneScoreInfo, {
    IsSum = true,
    ScoreCur = CurAppearacneScore,
    ScoreMax = SumAppearacneScore,
    Text = "UI_AppearanceScore_BaseScore"
  })
  for Entrance, ScoreInfo in ipairs(AppearacneScoreTable) do
    table.insert(AppearacneScoreInfo, {
      IsSum = false,
      ScoreCur = ScoreInfo.ScoreCur,
      ScoreMax = ScoreInfo.ScoreMax,
      Text = DataMgr.AppearanceCollect[Entrance].EntranceName
    })
  end
  local CurDyeScore = 0
  for Index, Info in ipairs(DyeScoreTable) do
    local ScoreCur = 0
    if Avatar then
      ScoreCur = Avatar.AppearanceScores[Info.Type .. "Dye"] or 0
    end
    Info.ScoreCur = ScoreCur
    CurDyeScore = CurDyeScore + Info.ScoreCur
  end
  table.insert(AppearacneScoreInfo, {
    IsSum = true,
    ScoreCur = CurDyeScore,
    ScoreMax = SumDyeScore,
    Text = "UI_AppearanceScore_DyeScore"
  })
  for Index, Info in ipairs(DyeScoreTable) do
    local TempTable = {
      IsSum = false,
      ScoreCur = Info.ScoreCur,
      ScoreMax = Info.ScoreMax
    }
    for _, AppearanceSubTabInfo in pairs(DataMgr.AppearanceSubTab) do
      if AppearanceSubTabInfo.ParentIndex == Info.Type then
        local SubEntranceId = AppearanceSubTabInfo.Entrance
        for _, AppearanceCollectInfo in pairs(DataMgr.AppearanceCollect) do
          for _, Id in pairs(AppearanceCollectInfo.SubTabId) do
            if SubEntranceId == Id then
              TempTable.Text = AppearanceCollectInfo.EntranceName
              break
            end
          end
        end
      end
    end
    table.insert(AppearacneScoreInfo, TempTable)
  end
  self.List_Info:ClearListItems()
  for Index, Info in ipairs(AppearacneScoreInfo) do
    local Content = NewObject(UIUtils.GetCommonItemContentClass())
    Content.IsSum = Info.IsSum
    Content.ScoreCur = Info.ScoreCur
    Content.ScoreMax = Info.ScoreMax
    Content.Text = Info.Text
    self.List_Info:AddItem(Content)
  end
  local TotalScoreCur = 0
  if Avatar then
    TotalScoreCur = Avatar.AppearanceScores.Total or 0
  end
  self.FenghuaProgress.Exp_Now:SetText(TotalScoreCur)
  self.FenghuaProgress.Exp_Max:SetText(SumAppearacneScore + SumDyeScore)
  local CanvasSlot = UE4.UWidgetLayoutLibrary.SlotAsCanvasSlot(self.FenghuaProgress.Exp_Bar)
  local Size = CanvasSlot:GetSize()
  Size.X = TotalScoreCur / (SumAppearacneScore + SumDyeScore) * self.MaxLength
  CanvasSlot:SetSize(Size)
end

function M:CheckCanDye(Type, Id)
  if "Skin" == Type then
    local Info = DataMgr.Skin[Id]
    if not Info.SkinSeries and not Info.SkinTag then
      return false
    else
      return true
    end
  elseif "Hair" == Type then
    local Info = DataMgr.Hair[Id]
    if not Info.CharId then
      return false
    else
      return true
    end
  elseif "WeaponSkin" == Type then
    return true
  end
  return false
end

function M:OnContentAnalogValueChanged(MyGeometry, InAnalogInputEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InAnalogInputEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if InKeyName == UIConst.GamePadKey.RightAnalogY then
    local DeltaOffset = UKismetInputLibrary.GetAnalogValue(InAnalogInputEvent)
    local CurrentOffset = self.List_Info:GetScrollOffset()
    local NextOffset = math.clamp(CurrentOffset - DeltaOffset, 0, UIUtils.GetMaxScrollOffsetOfListView(self.List_Info))
    self.List_Info:SetScrollOffset(NextOffset)
    return UIUtils.Handled
  end
  return UIUtils.Unhandled
end

return M
