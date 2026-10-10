require("UnLua")
local GuildLogoInfo = require("BluePrints.UI.WBP.Guild.Common.GuildLogoInfo")
local M = Class("BluePrints.UI.BP_EMUserWidget_C")
local GuildSignMaterialPath = "/Game/UI/WBP/Common/VX/Guide/"
local GuildSignMaterialPrefixes = {
  Frame = "MI_Guild_Icon_Frame_",
  BG = "MI_Guild_Icon_Bg_",
  TextLetter = "MI_Guild_Icon_Text_"
}

local function LoadGuildSignMaterial(Prefix, Index)
  if type(Index) ~= "number" or Index < 1 or Index > 8 or 0 ~= Index % 1 then
    return nil
  end
  local MaterialName = Prefix .. Index
  return LoadObject(GuildSignMaterialPath .. MaterialName .. "." .. MaterialName)
end

local function CreateGuildSignMaterialInstance(Owner, Prefix, Index)
  local Material = LoadGuildSignMaterial(Prefix, Index)
  if not Material then
    return nil
  end
  return UE4.UKismetMaterialLibrary.CreateDynamicMaterialInstance(Owner, Material, "None")
end

local function BuildGuildSignInfo(AvatarInfo)
  if type(AvatarInfo) ~= "table" then
    return nil
  end
  local GuildSimpleInfo = AvatarInfo.GuildSimpleInfo
  local GuildId = type(GuildSimpleInfo) == "table" and tonumber(GuildSimpleInfo.GuildId) or -1
  local BadgeText = type(GuildSimpleInfo) == "table" and GuildSimpleInfo.BadgeText or nil
  if AvatarInfo.ShowGuildBadge == false or GuildId <= 0 then
    return nil
  end
  local LogoInfo = GuildLogoInfo.Parse(GuildSimpleInfo.Logo)
  if not LogoInfo then
    return nil
  end
  DebugPrint(string.format("WBP_Guild_Sign: GuildId=%s FrameMaterial=%s BGMaterial=%s TextLetter=%s TextLetterMaterial=%s", tostring(GuildId), tostring(LogoInfo.LogoColor), tostring(LogoInfo.BgColor), tostring(BadgeText), tostring(LogoInfo.LogoColor)))
  return {
    GuildId = GuildId,
    FrameMaterial = LogoInfo.LogoColor,
    BGMaterial = LogoInfo.BgColor,
    TextLetter = BadgeText,
    TextLetterMaterial = LogoInfo.LogoColor
  }
end

local function ApplyGuildSignInfo(Owner, GuildSignInfo)
  if not GuildSignInfo then
    Owner:ResetForPool()
    return false
  end
  local PreviousGuildSignInfo = Owner.GuildSignInfo
  Owner.GuildSignInfo = GuildSignInfo
  if not PreviousGuildSignInfo or PreviousGuildSignInfo.FrameMaterial ~= GuildSignInfo.FrameMaterial then
    Owner:SetFrameMaterial(GuildSignInfo.FrameMaterial)
  end
  if not PreviousGuildSignInfo or PreviousGuildSignInfo.BGMaterial ~= GuildSignInfo.BGMaterial then
    Owner:SetBGMaterial(GuildSignInfo.BGMaterial)
  end
  Owner:SetTextLetter(GuildSignInfo.TextLetter)
  if not PreviousGuildSignInfo or PreviousGuildSignInfo.TextLetterMaterial ~= GuildSignInfo.TextLetterMaterial then
    Owner:SetTextLetterMaterial(GuildSignInfo.TextLetterMaterial)
  end
  Owner:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  return true
end

function M:Initialize(Initializer)
  self.GuildSignInfo = nil
end

function M:SetFrameMaterial(Index)
  local Material = CreateGuildSignMaterialInstance(self, GuildSignMaterialPrefixes.Frame, Index)
  if self.Frame and Material then
    self.Frame:SetBrushFromMaterial(Material)
  end
end

function M:SetBGMaterial(Index)
  local Material = CreateGuildSignMaterialInstance(self, GuildSignMaterialPrefixes.BG, Index)
  if self.BG and Material then
    self.BG:SetBrushFromMaterial(Material)
  end
end

function M:SetTextLetter(Letter)
  if self.Text_Letter then
    self.Text_Letter:SetText(Letter or "")
  end
end

function M:SetTextLetterMaterial(Index)
  local Material = CreateGuildSignMaterialInstance(self, GuildSignMaterialPrefixes.TextLetter, Index)
  if not self.Text_Letter or not Material then
    return
  end
  local Font = self.Text_Letter.Font
  Font.FontMaterial = Material
  self.Text_Letter:SetFont(Font)
end

function M:RefreshGuildSign(AvatarInfo)
  return ApplyGuildSignInfo(self, BuildGuildSignInfo(AvatarInfo))
end

function M:InitByGuildData(LogoInfo, BadgeText)
  local Parsed = GuildLogoInfo.Parse(LogoInfo) or GuildLogoInfo.Default()
  return ApplyGuildSignInfo(self, {
    GuildId = 0,
    FrameMaterial = Parsed.LogoColor,
    BGMaterial = Parsed.BgColor,
    TextLetter = BadgeText or "",
    TextLetterMaterial = Parsed.LogoColor
  })
end

function M:Init(AvatarInfo)
  return self:RefreshGuildSign(AvatarInfo)
end

function M:ResetForPool()
  self.GuildSignInfo = nil
  self:SetTextLetter("")
  self:SetVisibility(UIConst.VisibilityOp.Collapsed)
end

return M
