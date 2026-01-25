require("UnLua")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self.Text_LevelName:SetText(GText("BATTLE_UI_BLOOD_LV"))
end

function M:Destruct()
end

function M:Init(PhantomState)
  local level = 0
  DebugPrint("PhantomState.CharLevel Data Error  " .. PhantomState.CharLevel .. " level = " .. (Battle(self):GetEntity(PhantomState.Eid):GetAttr("Level") or "nil"))
  if PhantomState.CharLevel and 0 ~= PhantomState.CharLevel then
    level = PhantomState.CharLevel
  else
    local PhantomCharacter = Battle(self):GetEntity(PhantomState.Eid)
    if Battle(self):GetEntity(PhantomState.Eid) then
      level = PhantomCharacter:GetAttr("Level") or 1
      DebugPrint("PhantomState没有同步对应等级信息 PhantomState.CharLevel Data Error  " .. PhantomState.CharLevel .. " level = " .. (level or "nil"))
    else
      DebugPrint("确实找不到正确的魅影等级")
    end
  end
  self.Text_Level:SetText(level)
  local HeadPath = "Texture2D'/Game/UI/Texture/Dynamic/Image/Head/Mini/"
  local HeadImg = DataMgr.BattleChar[PhantomState.CharId].GuideIconImg
  HeadImg = TeamCommon.Normal .. HeadImg
  UE.UResourceLibrary.LoadObjectAsync(self, HeadPath .. HeadImg .. "." .. HeadImg .. "'", {
    self,
    M.OnIconLoadFinish
  })
  local WeaponId, WeaponLevel, Tag
  if 0 ~= PhantomState.MeleeWeaponId then
    WeaponId = PhantomState.MeleeWeaponId
    WeaponLevel = PhantomState.MeleeWeaponLevel
    Tag = CommonConst.WeaponType.MeleeWeapon
  elseif 0 ~= PhantomState.RangedWeaponId then
    WeaponId = PhantomState.RangedWeaponId
    WeaponLevel = PhantomState.RangedWeaponLevel
    Tag = CommonConst.WeaponType.RangedWeapon
  else
    DebugPrint(ErrorTag, LXYTag, "WBP_Team_PhantomItem_C::Init ,魅影的PhantonState上找不到武器")
    return
  end
  self.WBP_Team_PlayerInfo:Init(WeaponId, WeaponLevel, Tag)
end

function M:OnIconLoadFinish(Object)
  if IsValid(self) and self.Img_Phaontom then
    self.Img_Phaontom:SetBrushResourceObject(Object)
  end
end

return M
