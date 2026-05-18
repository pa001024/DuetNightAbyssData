require("UnLua")
local SkillUtils = require("Utils.SkillUtils")
local ArmoryUtils = require("BluePrints.UI.WBP.Armory.ArmoryUtils")

local function GetTrialCharSkillLevelForDesc(SkillId)
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return nil
  end
  local GameInstance = GWorld.GameInstance
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(GameInstance, 0)
  local CharId = Player and Player.PlayerState and Player.PlayerState.CharId
  if not CharId then
    return nil
  end
  for _, Char in pairs(Avatar.Chars) do
    if Char.CharId == CharId then
      for _, CharSkill in pairs(Char.Skills) do
        if CharSkill.SkillId == SkillId then
          return CharSkill.Level + (CharSkill.ExtraLevel or 0)
        end
      end
      return nil
    end
  end
  return nil
end

local function SkillDescPlainForTryOut(SkillId, Data)
  local Level = GetTrialCharSkillLevelForDesc(SkillId) or 1
  local Desc = SkillUtils.GetSkillDesc(SkillId, Level)
  if Desc and "" ~= Desc then
    Desc = string.gsub(Desc, "<H>(.-)</>", "%1")
    return Desc
  end
  return GText(Data.SkillDesc) or ""
end

local M = Class("Blueprints.UI.BP_UIState_C")
M._components = {
  "BluePrints.UI.UIComponent.StarsUIComponent"
}

function M:Construct()
end

function M:Init(Content)
  Content.SelfWidget = self
  self.Content = Content
  self.Owner = Content.Owner
  self.Id = Content.Id
  local SkillId = Content.SkillId
  local SkillData = DataMgr.Skill[SkillId]
  if SkillData and SkillData[1] and SkillData[1][0] then
    local Data = SkillData[1][0]
    self.SkillData = Data
    local IconName = Data.SkillBtnIcon
    local Icon
    if IconName then
      Icon = LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_" .. IconName .. ".T_" .. IconName)
    end
    Icon = Icon or LoadObject("/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Heitao_Skill01.T_Skill_Heitao_Skill01")
    self.Icon_Skill:SetBrushResourceObject(Icon)
    self.Text_ItemName:SetText(GText(Data.SkillName))
    if Data.SkillType == "Passive" then
      self.Text_Type:SetText(GText("UI_Armory_Passive"))
    else
      self.Text_Type:SetText(GText(Data.SkillBtnDesc))
    end
    self.Text_Describe:SetText(SkillDescPlainForTryOut(SkillId, Data))
  end
  self:SetNavigationRuleCustom(UE4.EUINavigation.Up, {
    self,
    self.OnNavigateUp
  })
  self:SetNavigationRuleCustom(UE4.EUINavigation.Down, {
    self,
    self.OnNavigateDown
  })
end

function M:OnListItemObjectSet(Content)
  self:Init(Content)
end

function M:RefreshBaseInfo()
  local GameInputModeSubsystem = UGameInputModeSubsystem.GetGameInputModeSubsystem(self)
  if IsValid(GameInputModeSubsystem) then
    self:RefreshOpInfoByInputDevice(GameInputModeSubsystem:GetCurrentInputType())
    GameInputModeSubsystem.OnInputMethodChanged:Add(self, self.RefreshOpInfoByInputDevice)
  end
end

function M:RefreshOpInfoByInputDevice(CurInputDevice, CurGamepadName)
  if self.CurInputDeviceType == CurInputDevice then
    return
  end
  self.CurInputDeviceType = CurInputDevice
  self:UpdateHotKeyInfo(CurGamepadName)
end

function M:OnKeyDown(MyGeometry, InKeyEvent)
  local InKey = UE4.UKismetInputLibrary.GetKey(InKeyEvent)
  local InKeyName = UE4.UFormulaFunctionLibrary.Key_GetFName(InKey)
  if UE4.UKismetInputLibrary.Key_IsGamepadKey(InKey) and InKeyName == Const.GamepadFaceButtonRight then
    self.Owner:CloseSelf()
  end
end

function M:OnNavigateUp()
  self.Owner:OnNavigateUp(self.Content)
end

function M:OnNavigateDown()
  self.Owner:OnNavigateDown(self.Content)
end

return M
