require("UnLua")
local TempKeyMap = {
  [1] = "One",
  [2] = "Two",
  [3] = "Three",
  [4] = "Four",
  [5] = "Five",
  [6] = "Six",
  [7] = "Seven",
  [8] = "Eight"
}
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})
local BattleUtils = require("Utils.BattleUtils")

function M:Initialize(Initializer)
end

function M:Construct()
  self.Btn_Area.OnHovered:Add(self, self.OnBtnHovered)
  self.Btn_Area.OnUnhovered:Add(self, self.OnBtnUnhovered)
  self.Btn_Area.OnClicked:Add(self, self.OnBtnClick)
  self.Icon_Add:SetVisibility(UIConst.VisibilityOp.Collapsed)
  self.SelectIndex = -1
end

function M:SetIndex(Index)
  self.Index = Index
  self.Key_Num:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Text",
        ImgShortPath = TempKeyMap[Index]
      }
    },
    bAllowForbid = false
  })
  self:SetKeyNumVisible()
end

function M:SetKeyNumVisible()
  if UIUtils.IsGamepadInput() then
    self.Key_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif UIUtils.IsMobileInput() then
    self.Key_Num:SetVisibility(UIConst.VisibilityOp.Collapsed)
  elseif UIUtils.IsPCInput then
    self.Key_Num:SetVisibility(UIConst.VisibilityOp.Visible)
  end
end

function M:SetData(ResourceId)
  self.ResourceId = ResourceId
  if -1 == ResourceId then
    self.WS_State:SetActiveWidgetIndex(1)
  else
    self.WS_State:SetActiveWidgetIndex(0)
    local Config = DataMgr.Resource[ResourceId]
    self.Text_Name:SetText(GText(Config.ResourceName))
    self:SetIconByPath(Config.Icon)
  end
end

function M:SetIconByPath(Path)
  local Obj = LoadObject(Path)
  local IconDynaMaterial = self.Icon_Gesture:GetDynamicMaterial()
  if IconDynaMaterial then
    IconDynaMaterial:SetTextureParameterValue("MainTex", Obj)
  else
    self.Icon_Gesture:SetBrushFromTexture(Obj)
  end
end

function M:SetSelectCallback(SelectCallbackInfo)
  self.SelectCallback = SelectCallbackInfo
  self.SlotIndex = SelectCallbackInfo.SlotIndex
end

function M:SelectResource(SlotIndex, ResourceId)
  self.SelectIndex = ResourceId
  if self.SelectIndex ~= self.ResourceId then
    self:PlayAnimation(self.Normal)
  end
end

function M:UpdateSelectResource(ResourceId)
  if -1 == self.ResourceId or self.ResourceId ~= ResourceId then
    self:PlayAnimation(self.Normal)
  else
    self:PlayAnimation(self.Click)
  end
end

function M:CheckResourceCanUse(ResourceId)
  local Player = UE4.UGameplayStatics.GetPlayerCharacter(self, 0)
  if not IsValid(Player) then
    return false
  end
  local Resolved = BattleUtils.ResolveCharacterAttributeSwitchPhantomData(DataMgr.Resource[ResourceId])
  local CombatConditionIDs = Resolved.CombatConditionID or {}
  local CombatConditionParams = Resolved.CombatConditionParams or {}
  local ToastIds = Resolved.CombatConditionToast or {}
  for Index, CombatConditionID in ipairs(CombatConditionIDs) do
    if CombatConditionID then
      local ConditionConfig = DataMgr.CombatCondition[CombatConditionID]
      if ConditionConfig then
        local ExtraVars = CombatConditionParams and CombatConditionParams[Index]
        local ConditionRes = Battle(self):CheckCondition_Lua(CombatConditionID, Player, nil, ExtraVars)
        if not ConditionRes then
          return false, ToastIds and ToastIds[Index]
        end
      end
    end
  end
  return true
end

function M:OnBtnClick()
  if -1 == self.ResourceId or self.SelectIndex == self.ResourceId then
    AudioManager(self):PlayUISound(nil, "event:/ui/common/click_mid", nil, nil)
    return
  end
  AudioManager(self):PlayItemSound(self, self.ResourceId, "Click", CommonConst.DataType.Resource)
  local GameInstance = GWorld.GameInstance
  local PlayerController = UE4.UGameplayStatics.GetPlayerController(GameInstance, 0)
  local PlayerCharacter = PlayerController:GetMyPawn():Cast(UE4.APlayerCharacter)
  local ConditionRes, ToastTextId = self:CheckResourceCanUse(self.ResourceId)
  if ConditionRes then
    local Avatar = GWorld:GetAvatar()
    if Avatar then
      self.SelectCallback.Func(self.SelectCallback.Obj, self.ResourceId, self.SlotIndex)
      self:PlayAnimation(self.Click)
      Avatar:UseItemInBattle(Avatar.Eid, self.ResourceId, nil, DataMgr.ReasonTypeConsume.RESOURCE_WHEEL_USE_CONSUME)
    end
  elseif ToastTextId then
    local ToastText = GText(ToastTextId)
    UIManager(self):ShowUITip("CommonToastMain", ToastText)
  end
end

function M:OnBtnHovered()
  if -1 ~= self.ResourceId then
    self.Panel_Name:SetVisibility(UIConst.VisibilityOp.SelfHitTestInvisible)
  end
end

function M:OnBtnUnhovered()
  if -1 ~= self.ResourceId then
    self.Panel_Name:SetVisibility(UIConst.VisibilityOp.Collapsed)
  end
end

function M:OnMouseLeave(MyGeometry, MouseEvent)
  self:PlayAnimation(self.Normal)
end

return M
