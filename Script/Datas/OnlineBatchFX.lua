local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("OnlineBatchFX", {
  ["/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM.NS_Sword_SZRM"] = {
    BatchRootMesh = "MainPlayer",
    IsArrayBatching = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM.NS_Sword_SZRM",
    TargetEffect = "/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM_Batch.NS_Sword_SZRM_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head.NS_Fuluo_SP01_SM_head"] = {
    BatchRootMesh = "MainPlayer",
    IsArrayBatching = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head.NS_Fuluo_SP01_SM_head",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head_Batch.NS_Fuluo_SP01_SM_head_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c.NS_Fuluo_SP01_SM_shawl_right04_c"] = {
    BatchRootMesh = "MainPlayer",
    IsArrayBatching = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c.NS_Fuluo_SP01_SM_shawl_right04_c",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c_Batch.NS_Fuluo_SP01_SM_shawl_right04_c_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua.NS_Machinegun_Linghua"] = {
    BatchRootMesh = "MainPlayer",
    IsArrayBatching = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua.NS_Machinegun_Linghua",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua_Batch.NS_Machinegun_Linghua_Batch"
  }
})
