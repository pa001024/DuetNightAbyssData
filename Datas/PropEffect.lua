local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PropEffect", {
  [1] = {
    BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject.PropEffectObject_C'",
    Id = 1,
    UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_CallPhantom_Empty"
  },
  [5] = {
    Id = 5,
    UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Resource_CallPhantom_Empty"
  },
  [42001] = {
    BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject_42001.PropEffectObject_42001'",
    Id = 42001,
    ReplaceShootIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Ray.T_Skill_Ray",
    UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Action/T_Resource_Gesture_Kaorou.T_Resource_Gesture_Kaorou"
  },
  [42002] = {
    BPPath = "Blueprint'/Game/BluePrints/Combat/PropEffect/PropEffectObject_42002.PropEffectObject_42002'",
    Id = 42002,
    ReplaceShootIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Blow.T_Skill_Blow",
    ReplaceSupportIconPath = "/Game/UI/Texture/Dynamic/Atlas/Skill/T_Skill_Pet_EastScan.T_Skill_Pet_EastScan",
    UsingIcon = "/Game/UI/Texture/Dynamic/Atlas/Prop/Item/T_Icon_CentralSquare_Unequip.T_Icon_CentralSquare_Unequip"
  }
})
