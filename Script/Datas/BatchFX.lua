local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("BatchFX", {
  ["/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM.NS_Sword_SZRM"] = {
    BatchRootMesh = "MainPlayer",
    OnlyRegionOnline = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM.NS_Sword_SZRM",
    TargetEffect = "/Game/Asset/Effect/Niagara/Costume/09Weapon/Sword/NS_Sword_SZRM_Batch.NS_Sword_SZRM_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head.NS_Fuluo_SP01_SM_head"] = {
    BatchRootMesh = "MainPlayer",
    OnlyRegionOnline = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head.NS_Fuluo_SP01_SM_head",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_head_Batch.NS_Fuluo_SP01_SM_head_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c.NS_Fuluo_SP01_SM_shawl_right04_c"] = {
    BatchRootMesh = "MainPlayer",
    OnlyRegionOnline = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c.NS_Fuluo_SP01_SM_shawl_right04_c",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Fuluo01/NS_Fuluo_SP01_SM_shawl_right04_c_Batch.NS_Fuluo_SP01_SM_shawl_right04_c_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal.NS_Kezhou_WeaponDecal"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal.NS_Kezhou_WeaponDecal",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal_Batch.NS_Kezhou_WeaponDecal_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal_Dualblade.NS_Kezhou_WeaponDecal_Dualblade"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal_Dualblade.NS_Kezhou_WeaponDecal_Dualblade",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponDecal_Dualblade_Batch.NS_Kezhou_WeaponDecal_Dualblade_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponTrail.NS_Kezhou_WeaponTrail"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponTrail.NS_Kezhou_WeaponTrail",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Kezhou/NS_Kezhou_WeaponTrail_Batch.NS_Kezhou_WeaponTrail_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Suyi01/NS_Suyi01_Explode.NS_Suyi01_Explode"] = {
    NABMinAliveTime = 0.8,
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Suyi01/NS_Suyi01_Explode.NS_Suyi01_Explode",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Suyi01/NS_Suyi01_Explode_Batch.NS_Suyi01_Explode_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Xier/NS_Xier_Skill01_laser.NS_Xier_Skill01_laser"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Xier/NS_Xier_Skill01_laser.NS_Xier_Skill01_laser",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Xier/NS_Xier_Skill01_laser_Batch.NS_Xier_Skill01_laser_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Skill01_Buff.NS_Zhangyu_Skill01_Buff"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Skill01_Buff.NS_Zhangyu_Skill01_Buff",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Skill01_Buff_Batch.NS_Zhangyu_Skill01_Buff_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Tentacle_Water.NS_Zhangyu_Tentacle_Water"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Tentacle_Water.NS_Zhangyu_Tentacle_Water",
    TargetEffect = "/Game/Asset/Effect/Niagara/Player/Zhangyu/zhangyu_skill_new/NS_Zhangyu_Tentacle_Water_Batch.NS_Zhangyu_Tentacle_Water_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Roguelike/NS_Rou_Liuming_Seed_Idle.NS_Rou_Liuming_Seed_Idle"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Roguelike/NS_Rou_Liuming_Seed_Idle.NS_Rou_Liuming_Seed_Idle",
    TargetEffect = "/Game/Asset/Effect/Niagara/Roguelike/NS_Rou_Liuming_Seed_Idle_Batch.NS_Rou_Liuming_Seed_Idle_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_Maojiang_Shoot01.NS_Bow_Maojiang_Shoot01"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_Maojiang_Shoot01.NS_Bow_Maojiang_Shoot01",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_Maojiang_Shoot01_Batch.NS_Bow_Maojiang_Shoot01_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_OpenFire_Shooting_01.NS_Bow_OpenFire_Shooting_01"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_OpenFire_Shooting_01.NS_Bow_OpenFire_Shooting_01",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Bow/NS_Bow_OpenFire_Shooting_01_Batch.NS_Bow_OpenFire_Shooting_01_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Explode.NS_Chiqiang_Explode"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Explode.NS_Chiqiang_Explode",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Explode_Batch.NS_Chiqiang_Explode_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Smoke_02.NS_Chiqiang_Smoke_02"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Smoke_02.NS_Chiqiang_Smoke_02",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Cannon/NS_Chiqiang_Smoke_02_Batch.NS_Chiqiang_Smoke_02_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua.NS_Machinegun_Linghua"] = {
    BatchRootMesh = "MainPlayer",
    OnlyRegionOnline = true,
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua.NS_Machinegun_Linghua",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/LingHua/NS_Machinegun_Linghua_Batch.NS_Machinegun_Linghua_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_01.NS_weapon_poxiao_shouji_01"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_01.NS_weapon_poxiao_shouji_01",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_01_Batch.NS_weapon_poxiao_shouji_01_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_02.NS_weapon_poxiao_shouji_02"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_02.NS_weapon_poxiao_shouji_02",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_02_Batch.NS_weapon_poxiao_shouji_02_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_03.NS_weapon_poxiao_shouji_03"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_03.NS_weapon_poxiao_shouji_03",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Machinegun/NS_weapon_poxiao_shouji_03_Batch.NS_weapon_poxiao_shouji_03_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_Bullet.NS_Ruohua_Bullet"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_Bullet.NS_Ruohua_Bullet",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_Bullet_Batch.NS_Ruohua_Bullet_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_BulletBurst.NS_Ruohua_BulletBurst"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_BulletBurst.NS_Ruohua_BulletBurst",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Ruohua/NS_Ruohua_BulletBurst_Batch.NS_Ruohua_BulletBurst_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Shotgun/Shengcai/NS_Shengcai_Hit.NS_Shengcai_Hit"] = {
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Shengcai/NS_Shengcai_Hit.NS_Shengcai_Hit",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Shengcai/NS_Shengcai_Hit_Batch.NS_Shengcai_Hit_Batch"
  },
  ["/Game/Asset/Effect/Niagara/Weapon/Shotgun/Yinlang/NS_Yinlang_Bullet.NS_Yinlang_Bullet"] = {
    BatchRootMesh = "Character",
    SourceEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Yinlang/NS_Yinlang_Bullet.NS_Yinlang_Bullet",
    TargetEffect = "/Game/Asset/Effect/Niagara/Weapon/Shotgun/Yinlang/NS_Yinlang_Bullet_Batch.NS_Yinlang_Bullet_Batch"
  }
})
