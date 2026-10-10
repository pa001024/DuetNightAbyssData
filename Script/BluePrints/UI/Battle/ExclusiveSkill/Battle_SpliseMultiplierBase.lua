require("UnLua")
local Const = require("BluePrints.UI.Battle.ExclusiveSkill.Battle_SpliseConst")
local M = {}

function M.GetSliderTierStep()
  return 1 / (#Const.Multiplier.Tiers - 1)
end

function M.GetMultiplierIndex(Multi, ReverseSlots)
  local Tiers = Const.Multiplier.Tiers
  local Index = 1
  for i = 2, #Tiers do
    if Multi < (Tiers[i - 1] + Tiers[i]) / 2 then
      break
    end
    Index = i
  end
  return ReverseSlots and #Tiers - Index + 1 or Index
end

function M.CreateMultiplierEntries(Widget)
  local Box = Widget.DynamicEntryBox_Multiplier
  if not Box then
    return
  end
  Box:Reset(true)
  Box:SetRenderTransformPivot(FVector2D(0.5, 0.5))
  local Config = Widget.DialConfig
  if Config.SectorCentralAngle then
    local Settings = UE4.FRadialBoxSettings()
    Settings.StartingAngle = Config.StartAngle
    Settings.bDistributeItemsEvenly = true
    Settings.AngleBetweenItems = 0
    Settings.SectorCentralAngle = Config.SectorCentralAngle
    Box:SetRadialSettings(Settings)
  end
  Widget.MultiplierEntries = {}
  for i = 1, #Const.Multiplier.Tiers do
    local Tier = Config.ReverseSlots and Const.Multiplier.Tiers[#Const.Multiplier.Tiers - i + 1] or Const.Multiplier.Tiers[i]
    local Entry = Box:BP_CreateEntry()
    if IsValid(Entry) then
      local TierText = "×" .. string.format("%g", Tier)
      if Entry.Text_Before then
        Entry.Text_Before:SetText(TierText)
      end
      if Entry.Text_Now then
        Entry.Text_Now:SetText(TierText)
      end
      if Entry.Text_After then
        Entry.Text_After:SetText(TierText)
      end
      if Entry.Switch_Text and Entry.Text_Now then
        Entry.Switch_Text:SetActiveWidget(Entry.Text_Now)
      end
      Entry:SetRenderTransformPivot(FVector2D(0.5, 0.5))
      table.insert(Widget.MultiplierEntries, Entry)
    end
  end
  Widget.DialStepAngle = Config.SpacingAngle
  Widget.CurMultiplierIndex = nil
  Widget.CurDialAngle = nil
  Widget.TargetDialAngle = nil
end

function M.UpdateDial(Widget, Index)
  if not (Widget.MultiplierEntries and Widget.DynamicEntryBox_Multiplier) or not Index then
    return false
  end
  local Config = Widget.DialConfig
  local bIndexChanged = Widget.CurMultiplierIndex ~= Index
  if bIndexChanged then
    Widget.CurMultiplierIndex = Index
    Widget.TargetDialAngle = Config.StartAngle + Widget.DialStepAngle / 2 + (Index - 1) * Widget.DialStepAngle - Config.SelectAngle
  end
  if Widget.TargetDialAngle then
    if Widget.CurDialAngle == Widget.TargetDialAngle then
      return bIndexChanged
    end
    Widget.CurDialAngle = Widget.CurDialAngle or Widget.TargetDialAngle
    Widget.CurDialAngle = Widget.CurDialAngle + (Widget.TargetDialAngle - Widget.CurDialAngle) * Const.Multiplier.Smooth
    if math.abs(Widget.TargetDialAngle - Widget.CurDialAngle) <= Const.Multiplier.AngleTolerance then
      Widget.CurDialAngle = Widget.TargetDialAngle
    end
    Widget.DynamicEntryBox_Multiplier:SetRenderTransformAngle(Widget.CurDialAngle)
    for _, Entry in ipairs(Widget.MultiplierEntries) do
      Entry:SetRenderTransformAngle(-Widget.CurDialAngle)
    end
  end
  return bIndexChanged
end

return M
