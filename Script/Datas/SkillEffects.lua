local T = {}
T.RT_1 = {EnmityValue = 0, StrongValue = 0}
T.RT_2 = {"hit1"}
T.RT_3 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1
}
T.RT_4 = {FXId = 600008, Function = "PlayFX"}
T.RT_5 = {Function = "PlaySE", SEId = 1003}
T.RT_6 = {
  [1] = T.RT_3,
  [2] = T.RT_4,
  [3] = T.RT_5
}
T.RT_7 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.2
}
T.RT_8 = {
  [1] = T.RT_7,
  [2] = T.RT_4,
  [3] = T.RT_5
}
T.RT_9 = {"hit2"}
T.RT_10 = {
  CauseHit = "LightHit",
  Function = "CutToughness"
}
T.RT_11 = {
  [1] = T.RT_7,
  [2] = T.RT_4,
  [3] = T.RT_10,
  [4] = T.RT_5
}
T.RT_12 = {"hit3"}
T.RT_13 = {"hit4"}
T.RT_14 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.8
}
T.RT_15 = {
  [1] = T.RT_14,
  [2] = T.RT_4,
  [3] = T.RT_10,
  [4] = T.RT_5
}
T.RT_16 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 2
}
T.RT_17 = {
  CauseHit = "HitFly_XY0Z1000",
  Function = "CutToughness"
}
T.RT_18 = {
  CauseHit = "HitFly_XY500Z1000",
  Function = "CutToughness"
}
T.RT_19 = {
  Function = "SaveLoc",
  IsOnGround = true,
  TargetType = "Target"
}
T.RT_20 = {
  [1] = T.RT_19
}
T.RT_21 = {
  0,
  0,
  -5
}
T.RT_22 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.5
}
T.RT_23 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.87
}
T.RT_24 = {Function = "PlaySE", SEId = 10003001}
T.RT_25 = {
  [1] = T.RT_23,
  [2] = T.RT_10,
  [3] = T.RT_24
}
T.RT_26 = {
  FXId = 1000302,
  Function = "PlayFX",
  Overlap = true
}
T.RT_27 = {Function = "PlaySE", SEId = 10003008}
T.RT_28 = {
  [1] = T.RT_7,
  [2] = T.RT_18,
  [3] = T.RT_26,
  [4] = T.RT_27
}
T.RT_29 = {
  BuffId = 1000301,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_30 = {
  [1] = T.RT_29
}
T.RT_31 = {
  0,
  150,
  0
}
T.RT_32 = {
  FXId = 1000402,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_33 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.5
}
T.RT_34 = {FXId = 1000404, Function = "PlayFX"}
T.RT_35 = {
  CauseHit = "HitFly_XY500Z1000",
  Function = "CutToughness",
  Value = 100
}
T.RT_36 = {
  0,
  0,
  100
}
T.RT_37 = {"MeleeWord"}
T.RT_38 = {Function = "PlayFX", WeaponFXGroupName = "Hit1"}
T.RT_39 = {
  CauseHit = "LightHit_50",
  Function = "CutToughness",
  Value = 100
}
T.RT_40 = {"Skill", "Skill2"}
T.RT_41 = {
  CauseHit = "HitFly_XY500Z300",
  Function = "CutToughness",
  Value = 100
}
T.RT_42 = {FXId = 25, Function = "PlayFX"}
T.RT_43 = {
  BaseAttr = "MaxHp",
  DamageType = "Default",
  Function = "Heal",
  Rate = "#1"
}
T.RT_44 = {
  [1] = T.RT_43
}
T.RT_45 = {
  "Melee",
  "Weapon",
  "Attack"
}
T.RT_46 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.45
}
T.RT_47 = {
  CauseHit = "LightHit_100_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_48 = {
  Condition = 100,
  Delay = 0.05,
  Dilation = 0,
  Duration = 0.03,
  Function = "HitStop"
}
T.RT_49 = {
  Function = "PlaySE",
  MeleeHitLevel = "Normal",
  SEId = 104
}
T.RT_50 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.5
}
T.RT_51 = {
  60,
  90,
  0
}
T.RT_52 = {
  Condition = 100,
  Delay = 0.1,
  Dilation = 0,
  Duration = 0.03,
  Function = "HitStop"
}
T.RT_53 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.4
}
T.RT_54 = {
  185,
  90,
  0
}
T.RT_55 = {
  CauseHit = "LightHit_100_F",
  Delay = 0.05,
  Function = "CutToughness",
  Value = 30
}
T.RT_56 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.82
}
T.RT_57 = {
  90,
  90,
  0
}
T.RT_58 = {
  Condition = 100,
  Delay = 0.05,
  Dilation = 0,
  Duration = 0.07,
  Function = "HitStop"
}
T.RT_59 = {
  Function = "PlaySE",
  MeleeHitLevel = "Heavy",
  SEId = 104
}
T.RT_60 = {
  200,
  90,
  0
}
T.RT_61 = {
  "Melee",
  "Weapon",
  "HeavyAttack"
}
T.RT_62 = {
  Function = "ExecutePassiveFunction",
  FunctionName = "ClearComboCount",
  PassiveEffectId = 102
}
T.RT_63 = {
  Function = "PlayFX",
  MaxHitFXNum = 5,
  WeaponFXGroupName = "Hit1"
}
T.RT_64 = {
  CauseHit = "HitFly_XY800Z400_F",
  Function = "CutToughness",
  Value = 73
}
T.RT_65 = {
  Condition = 100,
  Dilation = 0,
  Duration = 0.03,
  Function = "HitStop"
}
T.RT_66 = {"Melee", "RouB101"}
T.RT_67 = {
  Acceleration = 35000,
  AccelerationTime = 0.25,
  Angle = 30,
  Function = "AddCameraSpeed"
}
T.RT_68 = {
  [1] = T.RT_67
}
T.RT_69 = {
  "Melee",
  "Weapon",
  "FallAttack"
}
T.RT_70 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_69,
  Function = "Damage",
  Rate = 0.51
}
T.RT_71 = {
  CauseHit = "HitFly_XY400Z600",
  Function = "CutToughness",
  Value = 33
}
T.RT_72 = {Function = "MakeSound", SoundSourceId = 7}
T.RT_73 = {
  [1] = T.RT_70,
  [2] = T.RT_63,
  [3] = T.RT_71,
  [4] = T.RT_59,
  [5] = T.RT_72
}
T.RT_74 = {
  "Melee",
  "Weapon",
  "SlideAttack"
}
T.RT_75 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_74,
  Function = "Damage",
  Rate = 0.51
}
T.RT_76 = {
  0,
  90,
  0
}
T.RT_77 = {
  Function = "PlayFX",
  FxRotator = T.RT_76,
  IsFaceToChar = true,
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit"
}
T.RT_78 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 33
}
T.RT_79 = {
  Condition = 100,
  Dilation = 0,
  Duration = 0.1,
  Function = "HitStop"
}
T.RT_80 = {
  ChargeAmount = 1,
  Function = "ChargeBullet"
}
T.RT_81 = {Function = "AddBullet", Value = 1}
T.RT_82 = {
  Function = "AddEnergyShield",
  IsOverShield = 1,
  Rate = 0,
  Value = "#1"
}
T.RT_83 = {
  [1] = T.RT_82
}
T.RT_84 = {ATK = 1}
T.RT_85 = {
  CauseHit = "LightHit_100_F",
  Function = "CutToughness",
  Value = 20
}
T.RT_86 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.85
}
T.RT_87 = {
  180,
  90,
  0
}
T.RT_88 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_89 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.55
}
T.RT_90 = {
  Function = "PlayFX",
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit1"
}
T.RT_91 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 1.2
}
T.RT_92 = {
  CauseHit = "HitFly_XY400Z300_F",
  Function = "CutToughness",
  Value = 40
}
T.RT_93 = {Function = "AddSp", SpChange = "#1"}
T.RT_94 = {
  [1] = T.RT_93
}
T.RT_95 = {
  BaseChar = "Target",
  FXId = 6,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_96 = {
  BaseChar = "Target",
  FXId = 7,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_97 = {
  0,
  35,
  -5
}
T.RT_98 = {
  0,
  0,
  50
}
T.RT_99 = {
  AimSkeletal = "hit1",
  CreatureId = 1010201,
  Direction = "Camera",
  Function = "CreateSkillCreature",
  Location = T.RT_97,
  Rotation = T.RT_98
}
T.RT_100 = {
  Function = "AimDiffusion"
}
T.RT_101 = {"Ranged", "RouB102"}
T.RT_102 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_101,
  Function = "Damage",
  Rate = 2.7
}
T.RT_103 = {
  FXId = 10102102,
  Function = "PlayFX",
  Overlap = true
}
T.RT_104 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 50
}
T.RT_105 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 2000,
  ShakeClass = "BP_CS_Cannon_Hit"
}
T.RT_106 = {
  [1] = T.RT_102,
  [2] = T.RT_103,
  [3] = T.RT_104,
  [4] = T.RT_105
}
T.RT_107 = {"RouB104"}
T.RT_108 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 50
}
T.RT_109 = {FXId = 10104104, Function = "PlayFX"}
T.RT_110 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 100
}
T.RT_111 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 150
}
T.RT_112 = {FXId = 10104101, Function = "PlayFX"}
T.RT_113 = {
  CreatureId = 10105102,
  Function = "CreateSkillCreature"
}
T.RT_114 = {"RouB105"}
T.RT_115 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_114,
  Function = "Damage",
  Rate = "#1"
}
T.RT_116 = {FXId = 10105103, Function = "PlayFX"}
T.RT_117 = {"RouB106"}
T.RT_118 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_117,
  Function = "Damage",
  Rate = 3
}
T.RT_119 = {
  BodyAccessoryEffect = true,
  DieEffect = true,
  Function = "AdditionalHitFX"
}
T.RT_120 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 20
}
T.RT_121 = {FXId = 600005, Function = "PlayFX"}
T.RT_122 = {
  Function = "RemoveSkillCreature",
  Self = true
}
T.RT_123 = {FXId = 26, Function = "PlayFX"}
T.RT_124 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_117,
  Function = "Damage",
  Rate = 7
}
T.RT_125 = {
  BuffId = 10107123,
  Function = "AddBuff",
  LastTime = 1
}
T.RT_126 = {
  0,
  0,
  90
}
T.RT_127 = {
  Function = "ChargeBullet"
}
T.RT_128 = {
  [1] = T.RT_127
}
T.RT_129 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 20
}
T.RT_130 = {
  Condition = 100,
  Dilation = 0.1,
  Duration = 0.1,
  Function = "HitStop"
}
T.RT_131 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.25
}
T.RT_132 = {
  CauseHit = "LightHit_100_F",
  Function = "CutToughness",
  Value = 15
}
T.RT_133 = {
  CauseHit = "LightHit_100_F",
  Function = "CutToughness",
  Value = 35
}
T.RT_134 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_61,
  Function = "Damage",
  Rate = 0.1
}
T.RT_135 = {
  FXId = 47,
  Function = "PlayFX",
  MaxHitFXNum = 3
}
T.RT_136 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 5
}
T.RT_137 = {
  [1] = T.RT_134,
  [2] = T.RT_135,
  [3] = T.RT_136,
  [4] = T.RT_49,
  [5] = T.RT_119
}
T.RT_138 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = "#1"
}
T.RT_139 = {
  [1] = T.RT_138,
  [2] = T.RT_90,
  [3] = T.RT_88,
  [4] = T.RT_65,
  [5] = T.RT_49
}
T.RT_140 = {
  CauseHit = "LightHit_50_F",
  Function = "CutToughness",
  Value = 20
}
T.RT_141 = {
  0,
  -15,
  0
}
T.RT_142 = {
  0,
  15,
  0
}
T.RT_143 = {
  0,
  -30,
  0
}
T.RT_144 = {
  0,
  30,
  0
}
T.RT_145 = {
  FXId = 1020202,
  Function = "PlayFX",
  MaxHitFXNum = 3
}
T.RT_146 = {
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 15
}
T.RT_147 = {
  0,
  0,
  -90
}
T.RT_148 = {FXId = 1020203, Function = "PlayFX"}
T.RT_149 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 2000,
  ShakeClass = "BP_CameraShake_FallAttack"
}
T.RT_150 = {
  [1] = T.RT_148,
  [2] = T.RT_149
}
T.RT_151 = {
  Function = "PlayFX",
  FxRotator = T.RT_60,
  IsFaceToChar = true,
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit"
}
T.RT_152 = {
  Condition = 100,
  Dilation = 0,
  Duration = 0.07,
  Function = "HitStop"
}
T.RT_153 = {
  Function = "PlayFX",
  FxRotator = T.RT_51,
  IsFaceToChar = true,
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit"
}
T.RT_154 = {
  CauseHit = "HitFly_XY400Z500_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_155 = {
  -20,
  90,
  0
}
T.RT_156 = {
  Function = "PlayFX",
  FxRotator = T.RT_155,
  IsFaceToChar = true,
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit"
}
T.RT_157 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_61,
  Function = "Damage",
  Rate = 0.55
}
T.RT_158 = {
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 35
}
T.RT_159 = {
  10,
  90,
  0
}
T.RT_160 = {
  Function = "PlayFX",
  FxRotator = T.RT_159,
  IsFaceToChar = true,
  MaxHitFXNum = 3,
  WeaponFXGroupName = "Hit"
}
T.RT_161 = {
  CauseHit = "HitFly_XY600Z400",
  Function = "CutToughness",
  Value = 150
}
T.RT_162 = {
  -10,
  90,
  0
}
T.RT_163 = {
  CreatureId = 1030221,
  Function = "RemoveSkillCreature"
}
T.RT_164 = {
  CauseHit = "LightHit_50_F",
  Function = "CutToughness",
  Value = 15
}
T.RT_165 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 15
}
T.RT_166 = {
  CauseHit = "HitFly_XY500Z300_F",
  Function = "CutToughness",
  Value = 20
}
T.RT_167 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 0.2
}
T.RT_168 = {
  Function = "PlaySE",
  MeleeHitLevel = "Light",
  SEId = 105
}
T.RT_169 = {
  Function = "PlaySE",
  MeleeHitLevel = "Sp",
  SEId = 105
}
T.RT_170 = {
  Function = "PlayFX",
  FxRotator = T.RT_76,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_171 = {
  Function = "PlaySE",
  MeleeHitLevel = "Combo",
  SEId = 105
}
T.RT_172 = {
  Function = "PlayFX",
  FxRotator = T.RT_159,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_173 = {
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 12
}
T.RT_174 = {
  0,
  45,
  0
}
T.RT_175 = {Function = "MakeSound", SoundSourceId = 6}
T.RT_176 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_74,
  Function = "Damage",
  Rate = "#1"
}
T.RT_177 = {
  FXId = 44,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_178 = {
  CauseHit = "LightHit_50_F",
  Function = "CutToughness",
  Value = 30
}
T.RT_179 = {
  5,
  90,
  0
}
T.RT_180 = {"Skill", "Skill1"}
T.RT_181 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_180,
  Function = "Damage",
  Rate = "#1"
}
T.RT_182 = {FXId = 110151, Function = "PlayFX"}
T.RT_183 = {
  BossValue = 29,
  CauseHit = "HitFly_XY800Z400_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_184 = {Function = "PlaySE", SEId = 110101}
T.RT_185 = {
  [1] = T.RT_181,
  [2] = T.RT_182,
  [3] = T.RT_183,
  [4] = T.RT_184
}
T.RT_186 = {
  BossValue = 29,
  CauseHit = "HitFly_XY600Z400_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_187 = {
  0,
  0,
  30
}
T.RT_188 = {
  BaseAttr = "ATK_Ultra",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = "#1"
}
T.RT_189 = {
  BossValue = 25,
  CauseHit = "HitFly_XY200Z300_F",
  Function = "CutToughness",
  Value = 25
}
T.RT_190 = {
  0,
  0,
  12
}
T.RT_191 = {
  0,
  0,
  20
}
T.RT_192 = {
  ATKBase = "ATK_Ultra",
  CreatureId = 110141,
  Function = "CreateSkillCreature",
  Location = T.RT_190,
  Rotation = T.RT_191
}
T.RT_193 = {
  0,
  0,
  0
}
T.RT_194 = {
  0,
  0,
  59
}
T.RT_195 = {
  ATKBase = "ATK_Ultra",
  CreatureId = 110142,
  Function = "CreateSkillCreature",
  Location = T.RT_193,
  Rotation = T.RT_194
}
T.RT_196 = {
  0,
  0,
  40
}
T.RT_197 = {
  0,
  0,
  -8
}
T.RT_198 = {
  ATKBase = "ATK_Ultra",
  CreatureId = 110143,
  Function = "CreateSkillCreature",
  Location = T.RT_196,
  Rotation = T.RT_197
}
T.RT_199 = {
  0,
  0,
  142
}
T.RT_200 = {
  ATKBase = "ATK_Ultra",
  CreatureId = 110144,
  Function = "CreateSkillCreature",
  Location = T.RT_187,
  Rotation = T.RT_199
}
T.RT_201 = {
  ATKBase = "ATK_Ultra",
  CreatureId = 110145,
  Function = "CreateSkillCreature",
  Location = T.RT_193,
  Rotation = T.RT_126
}
T.RT_202 = {FXId = 110152, Function = "PlayFX"}
T.RT_203 = {Function = "PlaySE", SEId = 104}
T.RT_204 = {
  "Weapon",
  "Melee",
  "Attack"
}
T.RT_205 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_204,
  Function = "Damage",
  Rate = 1
}
T.RT_206 = {BuffId = 110221, Function = "RemoveBuff"}
T.RT_207 = {FXId = 21, Function = "PlayFX"}
T.RT_208 = {
  CreatureId = 110301,
  Function = "CreateSkillCreature"
}
T.RT_209 = {
  Function = "ExecutePassiveFunction",
  FunctionName = "Skill1AddMsp2",
  PassiveEffectId = 110301
}
T.RT_210 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_40,
  Function = "Damage",
  Rate = "#1"
}
T.RT_211 = {
  BossValue = 21,
  CauseHit = "LightHit_Tuosi",
  Function = "CutToughness",
  Value = 25
}
T.RT_212 = {Function = "PlaySE", SEId = 110306}
T.RT_213 = {
  "TuosiCombo",
  "Skill",
  "Skill2"
}
T.RT_214 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_213,
  Function = "Damage",
  Rate = "#1"
}
T.RT_215 = {
  FXId = 110341,
  Function = "PlayFX",
  MaxHitFXNum = 5
}
T.RT_216 = {
  "TuosiFinish",
  "Skill",
  "Skill2"
}
T.RT_217 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_216,
  Function = "Damage",
  Rate = "#1"
}
T.RT_218 = {"hit0"}
T.RT_219 = {FXId = 110311, Function = "PlayFX"}
T.RT_220 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_180,
  Function = "Damage",
  Rate = 1
}
T.RT_221 = {
  [1] = T.RT_220
}
T.RT_222 = {BuffId = 110411, Function = "RemoveBuff"}
T.RT_223 = {
  0,
  400,
  0
}
T.RT_224 = {
  CreatureId = 110411,
  Function = "CreateSkillCreature",
  Location = T.RT_223
}
T.RT_225 = {Function = "AddSp", SpChange = 25}
T.RT_226 = {
  [1] = T.RT_225,
  [2] = T.RT_96
}
T.RT_227 = {
  "Skill",
  "Skill1",
  "ZhujueDark"
}
T.RT_228 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_227,
  Function = "Damage",
  Rate = 1
}
T.RT_229 = {
  BuffId = 120102,
  Function = "AddBuff",
  LastTime = 6
}
T.RT_230 = {
  BaseAttr = "MaxHp",
  DamageType = "Default",
  Function = "Heal",
  Rate = 0.25
}
T.RT_231 = {
  "Skill",
  "Skill2",
  "ZhujueDark"
}
T.RT_232 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_231,
  Function = "Damage",
  Rate = 4.2
}
T.RT_233 = {FXId = 10103102, Function = "PlayFX"}
T.RT_234 = {
  [1] = T.RT_232,
  [2] = T.RT_41,
  [3] = T.RT_233
}
T.RT_235 = {
  BaseAttr = "MaxHp",
  DamageType = "Default",
  Function = "Heal",
  Rate = 0.1
}
T.RT_236 = {ComboCount = 10, Function = "HitCount"}
T.RT_237 = {
  [1] = T.RT_235,
  [2] = T.RT_236
}
T.RT_238 = {
  100,
  0,
  200
}
T.RT_239 = {
  0,
  200,
  0
}
T.RT_240 = {Function = "PlaySE", SEId = 150106}
T.RT_241 = {Function = "PlaySE", SEId = 150107}
T.RT_242 = {
  BaseAttr = "ATK_Ultra",
  DamageTag = T.RT_61,
  Function = "Damage",
  Rate = "#1"
}
T.RT_243 = {"Skill"}
T.RT_244 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_243,
  Function = "Damage",
  Rate = "#1"
}
T.RT_245 = {
  Delay = 0.15,
  FXId = 25,
  Function = "PlayFX"
}
T.RT_246 = {
  Condition = 100,
  Delay = 0.15,
  Dilation = 0,
  Duration = 0.05,
  Function = "HitStop"
}
T.RT_247 = {"Mod"}
T.RT_248 = {
  CauseHit = "HitFly_XY400Z600",
  Function = "CutToughness",
  Value = 15
}
T.RT_249 = {
  Delay = 0.05,
  FXId = 25,
  Function = "PlayFX"
}
T.RT_250 = {Function = "PlaySE", SEId = 850294}
T.RT_251 = {
  0,
  600,
  -90
}
T.RT_252 = {
  0,
  1000,
  -90
}
T.RT_253 = {
  BossValue = 150,
  CauseHit = "HitDown",
  Function = "CutToughness",
  Value = 100
}
T.RT_254 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 2000,
  ShakeClass = "BP_CS_Xibi_Skill01"
}
T.RT_255 = {
  BuffId = 150211,
  Condition = 72,
  Function = "AddBuff",
  LastTime = 3
}
T.RT_256 = {
  BuffId = 150215,
  Function = "AddBuff",
  LastTime = 3
}
T.RT_257 = {Function = "PlaySE", SEId = 150205}
T.RT_258 = {
  "Skill",
  "Skill1",
  "NifuDark"
}
T.RT_259 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_258,
  DamageType = "Dark",
  Function = "Damage",
  Rate = "#1",
  TriggerProbability = "$Source:GetRootSource():GetFloat('Skill04TriggerRate')$"
}
T.RT_260 = {
  BuffId = 150212,
  Condition = 72,
  Function = "AddBuff",
  LastTime = 3
}
T.RT_261 = {
  BuffId = 150214,
  Function = "AddBuff",
  LastTime = 3
}
T.RT_262 = {Function = "PlaySE", SEId = 401}
T.RT_263 = {FXId = 150314, Function = "PlayFX"}
T.RT_264 = {Function = "PlaySE", SEId = 150308}
T.RT_265 = {
  BuffId = 150327,
  Condition = 74,
  Function = "AddBuff",
  LastTime = 25
}
T.RT_266 = {
  BuffId = 150320,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_267 = {
  BossValue = 100,
  CauseHit = "HitFly_XY0Z500",
  Function = "CutToughness",
  Value = 30
}
T.RT_268 = {
  Function = "PlaySE",
  MeleeHitLevel = "Light",
  SEId = 104
}
T.RT_269 = {
  Condition = 100,
  Dilation = 0.1,
  Duration = 0.03,
  Function = "HitStop"
}
T.RT_270 = {
  CauseHit = "LightHit_50_F",
  Function = "CutToughness",
  Value = 60
}
T.RT_271 = {
  [1] = T.RT_138,
  [2] = T.RT_269,
  [3] = T.RT_270,
  [4] = T.RT_49
}
T.RT_272 = {FXId = 1020202, Function = "PlayFX"}
T.RT_273 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_61,
  Function = "Damage",
  Rate = "#1"
}
T.RT_274 = {
  BaseAttr = "ATK_Melee",
  DamageTag = T.RT_69,
  Function = "Damage",
  Rate = "#1"
}
T.RT_275 = {
  CauseHit = "HitFly_XY400Z600",
  Function = "CutToughness",
  Value = 50
}
T.RT_276 = {
  [1] = T.RT_274,
  [2] = T.RT_38,
  [3] = T.RT_275,
  [4] = T.RT_59,
  [5] = T.RT_72
}
T.RT_277 = {
  [1] = T.RT_176,
  [2] = T.RT_170,
  [3] = T.RT_129,
  [4] = T.RT_79,
  [5] = T.RT_49
}
T.RT_278 = {
  [1] = T.RT_138,
  [2] = T.RT_38,
  [3] = T.RT_47,
  [4] = T.RT_268
}
T.RT_279 = {
  -110,
  90,
  0
}
T.RT_280 = {
  Function = "PlayFX",
  FxRotator = T.RT_279,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_281 = {
  170,
  90,
  0
}
T.RT_282 = {
  Function = "PlayFX",
  FxRotator = T.RT_281,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_283 = {
  CauseHit = "HitFly_XY400Z300",
  Function = "CutToughness",
  Value = 80
}
T.RT_284 = {
  Function = "PlayFX",
  FxRotator = T.RT_162,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_285 = {
  Function = "ExecuteClientPassiveFunction",
  FunctionName = "EndJetRush"
}
T.RT_286 = {
  Condition = 100,
  Dilation = 0,
  Duration = 0.02,
  Function = "HitStop"
}
T.RT_287 = {Function = "PlaySE", SEId = 410104}
T.RT_288 = {1}
T.RT_289 = {
  "Skill",
  "Skill2",
  "SuyiSkill02Creature"
}
T.RT_290 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_289,
  Function = "Damage",
  Rate = 1
}
T.RT_291 = {
  Function = "ExecuteClientPassiveFunction",
  FunctionName = "SwitchMontage"
}
T.RT_292 = {
  ClientSkillLogicId = 150402,
  Function = "ExecuteClientSkillLogicFunction",
  FunctionName = "SetShootLoc"
}
T.RT_293 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 530105
}
T.RT_294 = {
  "Skill",
  "Skill2",
  "SuyiWeapon"
}
T.RT_295 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_294,
  Function = "Damage",
  Rate = 1
}
T.RT_296 = {
  BossValue = 100,
  CauseHit = "HitFly_XY0Z500",
  Function = "CutToughness",
  Value = 20
}
T.RT_297 = {
  BuffId = 150402,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_298 = {
  FXId = 2051005,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_299 = {
  Function = "BeginAccumulate"
}
T.RT_300 = {Function = "PlaySE", SEId = 2060305}
T.RT_301 = {Function = "PlaySE", SEId = 2050702}
T.RT_302 = {
  Dilation = 0.18,
  Duration = 0.1,
  Function = "HitStop"
}
T.RT_303 = {
  Mud = 64,
  Sand = 63,
  Snow = 62,
  Water = 61
}
T.RT_304 = {
  FXId = 54,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true,
  ReplaceFXId = T.RT_303
}
T.RT_305 = {
  Mud = 0,
  Sand = 0,
  Snow = 0,
  Water = 0
}
T.RT_306 = {
  Function = "PlaySE",
  SEId = 2050703,
  SceneSe = true
}
T.RT_307 = {
  BaseAttr = "ATK_Ultra",
  DamageTag = T.RT_45,
  Function = "Damage",
  Rate = 1
}
T.RT_308 = {
  [1] = T.RT_307
}
T.RT_309 = {
  CauseHit = "HitFly_XY500Z300",
  Function = "CutToughness",
  Value = 30
}
T.RT_310 = {
  "Melee",
  "Weapon",
  "Attack",
  "NoCombo"
}
T.RT_311 = {
  BaseAttr = "ATK_Ultra",
  DamageTag = T.RT_310,
  Function = "Damage",
  Rate = 1
}
T.RT_312 = {
  0,
  300,
  -90
}
T.RT_313 = {
  [1] = T.RT_307,
  [2] = T.RT_63
}
T.RT_314 = {
  -5,
  90,
  0
}
T.RT_315 = {
  Function = "PlayFX",
  FxRotator = T.RT_314,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_316 = {Function = "PlaySE", SEId = 850272}
T.RT_317 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_247,
  DamageType = "Fire",
  Function = "Damage",
  Rate = 2.56
}
T.RT_318 = {
  Delay = 0.05,
  FXId = 22,
  Function = "PlayFX"
}
T.RT_319 = {Function = "PlaySE", SEId = 850282}
T.RT_320 = {
  0,
  0,
  -45
}
T.RT_321 = {
  0,
  0,
  45
}
T.RT_322 = {
  BuffId = 180113,
  Function = "AddBuff",
  LastTime = 12
}
T.RT_323 = {
  Function = "ExecutePassiveFunction",
  FunctionName = "Skill1AddBuff",
  PassiveEffectId = 180101
}
T.RT_324 = {
  BossValue = 56,
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 65
}
T.RT_325 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 18010
}
T.RT_326 = {
  BuffType = 180130,
  Function = "ChangeBuffTypeLastTime",
  IsExpand = false,
  LastTimeValue = 12
}
T.RT_327 = {
  "FeinaColorRed"
}
T.RT_328 = {
  DamageTag = T.RT_327,
  Function = "Damage",
  Value = 1
}
T.RT_329 = {
  FXId = 10301031,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_330 = {
  [1] = T.RT_328,
  [2] = T.RT_329
}
T.RT_331 = {
  "FeinaColorBlue"
}
T.RT_332 = {
  DamageTag = T.RT_331,
  Function = "Damage",
  Value = 1
}
T.RT_333 = {
  FXId = 10301011,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_334 = {
  [1] = T.RT_332,
  [2] = T.RT_333
}
T.RT_335 = {
  "FeinaColorGreen"
}
T.RT_336 = {
  DamageTag = T.RT_335,
  Function = "Damage",
  Value = 1
}
T.RT_337 = {
  FXId = 10301021,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_338 = {
  [1] = T.RT_336,
  [2] = T.RT_337
}
T.RT_339 = {"Ranged", "Weapon"}
T.RT_340 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.71
}
T.RT_341 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 12
}
T.RT_342 = {Function = "PlaySE", SEId = 103}
T.RT_343 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = "#1"
}
T.RT_344 = {Function = "PlaySE", SEId = 2010104}
T.RT_345 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 1500,
  ShakeClass = "BP_CS_Wuxu_Hit"
}
T.RT_346 = {
  Function = "PlaySE",
  SEId = 2010101,
  SceneSe = true
}
T.RT_347 = {
  0,
  0,
  -10
}
T.RT_348 = {Function = "AddSp", SpChange = 15}
T.RT_349 = {
  [1] = T.RT_348
}
T.RT_350 = {
  FXId = 2019901,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_351 = {
  FXId = 42,
  Function = "PlayFX",
  Overlap = true
}
T.RT_352 = {
  FXId = 52,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true,
  ReplaceFXId = T.RT_303
}
T.RT_353 = {
  FXId = 2020106,
  Function = "PlayFX",
  IsAttached = true,
  IsDecalEffectCreature = true,
  NormalToHit = true,
  Overlap = true,
  RefinedOverlap = true,
  ReplaceFXId = T.RT_305
}
T.RT_354 = {
  Function = "PlaySE",
  SEId = 103,
  SceneSe = true
}
T.RT_355 = {
  [1] = T.RT_352,
  [2] = T.RT_353,
  [3] = T.RT_354
}
T.RT_356 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 1
}
T.RT_357 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 10
}
T.RT_358 = {
  0,
  -45,
  0
}
T.RT_359 = {
  0,
  135,
  0
}
T.RT_360 = {
  0,
  -135,
  0
}
T.RT_361 = {
  CreatureId = 20132001,
  Delay = 0.05,
  Function = "CreateSkillCreature"
}
T.RT_362 = {
  CreatureId = 20132001,
  Delay = 0.1,
  Function = "CreateSkillCreature"
}
T.RT_363 = {
  [1] = T.RT_361,
  [2] = T.RT_361,
  [3] = T.RT_361,
  [4] = T.RT_362,
  [5] = T.RT_362,
  [6] = T.RT_362
}
T.RT_364 = {FXId = 530103, Function = "PlayFX"}
T.RT_365 = {"RouT103"}
T.RT_366 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_365,
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 1
}
T.RT_367 = {
  [1] = T.RT_366
}
T.RT_368 = {
  BaseChar = "Self",
  ConsumeAmount = 1,
  Function = "ConsumeBullet"
}
T.RT_369 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.47
}
T.RT_370 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 8
}
T.RT_371 = {
  [1] = T.RT_369,
  [2] = T.RT_177,
  [3] = T.RT_370
}
T.RT_372 = {
  FXId = 51,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true,
  ReplaceFXId = T.RT_303
}
T.RT_373 = {
  [1] = T.RT_372
}
T.RT_374 = {
  "Ranged",
  "Weapon",
  "Explode"
}
T.RT_375 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Function = "Damage",
  Rate = 0.95
}
T.RT_376 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 40
}
T.RT_377 = {
  Falloff = 0.2,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 1500,
  ShakeClass = "BP_CS_Cannon_Hit"
}
T.RT_378 = {
  [1] = T.RT_110
}
T.RT_379 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Function = "Damage",
  Rate = 0.8
}
T.RT_380 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 30
}
T.RT_381 = {Function = "PlaySE", SEId = 2030204}
T.RT_382 = {
  Function = "PlaySE",
  SEId = 2030201,
  SceneSe = true
}
T.RT_383 = {
  1,
  1,
  0
}
T.RT_384 = {-20, 20}
T.RT_385 = {0, 20}
T.RT_386 = {-400, 400}
T.RT_387 = {750, 750}
T.RT_388 = {
  AttackRangeBulletModify = T.RT_383,
  CreatureId = 2030212,
  Function = "CreateSkillCreature",
  Horizontally = true,
  RandomOffsetX = T.RT_384,
  RandomOffsetY = T.RT_384,
  RandomOffsetZ = T.RT_385,
  RandomVelocityX = T.RT_386,
  RandomVelocityY = T.RT_386,
  RandomVelocityZ = T.RT_387
}
T.RT_389 = {
  AttackRangeBulletModify = T.RT_383,
  CreatureId = 2030212,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  Horizontally = true,
  RandomOffsetX = T.RT_384,
  RandomOffsetY = T.RT_384,
  RandomOffsetZ = T.RT_385,
  RandomVelocityX = T.RT_386,
  RandomVelocityY = T.RT_386,
  RandomVelocityZ = T.RT_387
}
T.RT_390 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Function = "Damage",
  Rate = 0.15
}
T.RT_391 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Function = "Damage",
  Rate = 0.32
}
T.RT_392 = {
  CauseHit = "LightHit_50",
  Function = "CutToughness",
  Value = 12
}
T.RT_393 = {Function = "PlaySE", SEId = 2030304}
T.RT_394 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 1500,
  ShakeClass = "BP_CS_Chiqiang_Hit"
}
T.RT_395 = {
  Function = "PlaySE",
  SEId = 2030301,
  SceneSe = true
}
T.RT_396 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Delay = 0.6,
  Function = "Damage",
  Rate = 0.32
}
T.RT_397 = {
  Delay = 0.6,
  FXId = 2030302,
  Function = "PlayFX"
}
T.RT_398 = {
  Delay = 0.6,
  Function = "PlaySE",
  SEId = 2030304
}
T.RT_399 = {
  Delay = 0.6,
  Function = "PlaySE",
  SEId = 2030302,
  SceneSe = true
}
T.RT_400 = {
  [1] = T.RT_396,
  [2] = T.RT_397,
  [3] = T.RT_398,
  [4] = T.RT_399
}
T.RT_401 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 1
}
T.RT_402 = {Function = "PlaySE", SEId = 2030406}
T.RT_403 = {2030511}
T.RT_404 = {"hit5"}
T.RT_405 = {
  AimSkeletal = "hit1",
  CreatureId = 2040111,
  Direction = "Camera",
  ExtraRotation = 2,
  Function = "CreateSkillCreature"
}
T.RT_406 = {FXId = 2040203, Function = "PlayFX"}
T.RT_407 = {Function = "PlaySE", SEId = 2040202}
T.RT_408 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_374,
  Function = "Damage",
  Rate = 1.39
}
T.RT_409 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 25
}
T.RT_410 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.33
}
T.RT_411 = {FXId = 2040504, Function = "PlayFX"}
T.RT_412 = {FXId = 23, Function = "PlayFX"}
T.RT_413 = {FXId = 22, Function = "PlayFX"}
T.RT_414 = {
  0,
  60,
  0
}
T.RT_415 = {
  CreatureId = 2040602,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  Location = T.RT_193,
  Rotation = T.RT_414
}
T.RT_416 = {
  0,
  -60,
  0
}
T.RT_417 = {
  CreatureId = 2040602,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  Location = T.RT_193,
  Rotation = T.RT_416
}
T.RT_418 = {
  CreatureId = 2040602,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  Location = T.RT_193,
  Rotation = T.RT_193
}
T.RT_419 = {
  0,
  20,
  0
}
T.RT_420 = {
  0,
  -20,
  0
}
T.RT_421 = {
  0,
  40,
  0
}
T.RT_422 = {
  0,
  -40,
  0
}
T.RT_423 = {
  0,
  25,
  0
}
T.RT_424 = {
  0,
  -25,
  0
}
T.RT_425 = {
  0,
  50,
  0
}
T.RT_426 = {
  0,
  -50,
  0
}
T.RT_427 = {
  0,
  75,
  0
}
T.RT_428 = {
  0,
  -75,
  0
}
T.RT_429 = {
  CauseHit = "HitFly_XY400Z300",
  Function = "CutToughness",
  Value = 25
}
T.RT_430 = {
  [1] = T.RT_81
}
T.RT_431 = {
  FXId = 2050102,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_432 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 109
}
T.RT_433 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 4
}
T.RT_434 = {
  "Ranged",
  "Weapon",
  "Ray",
  "Ranged20502"
}
T.RT_435 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_434,
  Function = "Damage",
  Rate = 0.176
}
T.RT_436 = {FXId = 2050205, Function = "PlayFX"}
T.RT_437 = {FXId = 2050206, Function = "PlayFX"}
T.RT_438 = {
  [1] = T.RT_437
}
T.RT_439 = {
  "Ranged",
  "Weapon",
  "Ray"
}
T.RT_440 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_439,
  Function = "Damage",
  Rate = 0.2
}
T.RT_441 = {
  CreatureId = 2050411,
  Function = "RemoveRayCreature"
}
T.RT_442 = {
  CreatureId = 2050412,
  Function = "RemoveRayCreature"
}
T.RT_443 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 3
}
T.RT_444 = {
  Function = "PlaySE",
  SEId = 2050404,
  SceneSe = true
}
T.RT_445 = {FXId = 2050503, Function = "PlayFX"}
T.RT_446 = {
  Function = "EndLoopShoot",
  LoopShootId = 20505
}
T.RT_447 = {
  BuffId = 203,
  Function = "AddBuff",
  LastTime = 2
}
T.RT_448 = {
  -90,
  0,
  -90
}
T.RT_449 = {
  AllowAttackSpeed = 1,
  Rotate = T.RT_448,
  Time = 1.5
}
T.RT_450 = {
  90,
  0,
  90
}
T.RT_451 = {
  CreatureId = 2050611,
  Direction = "Camera",
  Function = "CreateRayCreature",
  InterpRotation = T.RT_449,
  RayEndLoc = true,
  Rotation = T.RT_450
}
T.RT_452 = {
  AllowAttackSpeed = 1,
  Rotate = T.RT_450,
  Time = 1.5
}
T.RT_453 = {
  CreatureId = 2050612,
  Direction = "Camera",
  Function = "CreateRayCreature",
  InterpRotation = T.RT_452,
  RayEndLoc = true,
  Rotation = T.RT_448
}
T.RT_454 = {
  FXId = 2050601,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_455 = {FXId = 2050604, Function = "PlayFX"}
T.RT_456 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.06
}
T.RT_457 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 1
}
T.RT_458 = {
  FXId = 2060102,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_459 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.35
}
T.RT_460 = {
  FXId = 45,
  Function = "PlayFX",
  Overlap = true
}
T.RT_461 = {
  10,
  16,
  10
}
T.RT_462 = {
  AttachToMesh = true,
  BaseChar = "Target",
  DirectionByCreature = true,
  FXId = 46,
  Function = "PlayFX",
  Overlap = true,
  RandomRotation = T.RT_461
}
T.RT_463 = {Function = "PlaySE", SEId = 112}
T.RT_464 = {
  [1] = T.RT_459,
  [2] = T.RT_460,
  [3] = T.RT_462,
  [4] = T.RT_370,
  [5] = T.RT_463
}
T.RT_465 = {
  Function = "PlaySE",
  SEId = 112,
  SceneSe = true
}
T.RT_466 = {
  5,
  5,
  5
}
T.RT_467 = {
  DirectionByCreature = true,
  FXId = 46,
  Function = "PlayFX",
  Overlap = true,
  RandomRotation = T.RT_466
}
T.RT_468 = {
  [1] = T.RT_352,
  [2] = T.RT_465,
  [3] = T.RT_467
}
T.RT_469 = {
  FXId = 2060103,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_470 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.6
}
T.RT_471 = {
  CauseHit = "RangedWeapon_Common",
  Function = "CutToughness",
  Value = 10
}
T.RT_472 = {
  AttachToSkillCreature = true,
  Function = "GrabTarget",
  OnlyInPlayer = true
}
T.RT_473 = {
  0.5,
  0.5,
  0.5
}
T.RT_474 = {
  BaseChar = "Self",
  Condition = 44,
  ConsumeAmount = 1,
  Function = "ConsumeBullet",
  TotalBullet = 1
}
T.RT_475 = {
  0,
  12,
  0
}
T.RT_476 = {
  0,
  -12,
  0
}
T.RT_477 = {
  AimSkeletal = "hit1",
  CreatureId = 2060311,
  Direction = "Camera",
  Function = "CreateSkillCreature"
}
T.RT_478 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 2060308
}
T.RT_479 = {
  ClientSkillLogicId = 2060301,
  Function = "ExecuteClientSkillLogicFunction",
  FunctionName = "EndShoot"
}
T.RT_480 = {
  BaseAttr = "ATK_Ranged",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.18
}
T.RT_481 = {
  [1] = T.RT_352,
  [2] = T.RT_465,
  [3] = T.RT_467,
  [4] = T.RT_122
}
T.RT_482 = {
  AimSkeletal = "hit1",
  CreatureId = 2060521,
  Direction = "Camera",
  Function = "CreateSkillCreature"
}
T.RT_483 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_243,
  Function = "Damage",
  Rate = "#1"
}
T.RT_484 = {
  BossValue = 18,
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 15
}
T.RT_485 = {
  [1] = T.RT_483,
  [2] = T.RT_412,
  [3] = T.RT_484
}
T.RT_486 = {Function = "PlaySE", SEId = 210105}
T.RT_487 = {IsEveAdditionalSummon = 1}
T.RT_488 = {Function = "RemoveUnit", UnitId = 210204}
T.RT_489 = {
  FXId = 700804,
  Function = "PlayFX",
  NormalToHit = true
}
T.RT_490 = {Function = "PlaySE", SEId = 700803}
T.RT_491 = {Function = "AddSp", SpChange = 4}
T.RT_492 = {
  BaseChar = "Target",
  Delay = 0.15,
  FXId = 7,
  Function = "PlayFX"
}
T.RT_493 = {"Skill", "Zhangyu"}
T.RT_494 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_493,
  Function = "Damage",
  Rate = "#1"
}
T.RT_495 = {
  AllowSkillIntensity = 1,
  BaseAttr = "ATK_Char",
  DamageType = "Default",
  Function = "AddEnergyShield",
  IsOverShield = 1,
  Rate = "#1",
  Value = 80
}
T.RT_496 = {
  0,
  0,
  60
}
T.RT_497 = {FXId = 900502, Function = "PlayFX"}
T.RT_498 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.2
}
T.RT_499 = {
  [1] = T.RT_3,
  [2] = T.RT_10,
  [3] = T.RT_497
}
T.RT_500 = {
  [1] = T.RT_3,
  [2] = T.RT_10
}
T.RT_501 = {
  CreatureId = 30423,
  Function = "CreateSkillCreature"
}
T.RT_502 = {
  BuffId = 30400015,
  Function = "AddBuff",
  LastTime = 6
}
T.RT_503 = {
  [1] = T.RT_501,
  [2] = T.RT_502
}
T.RT_504 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.1
}
T.RT_505 = {
  [1] = T.RT_504
}
T.RT_506 = {
  [1] = T.RT_33
}
T.RT_507 = {"hit6"}
T.RT_508 = {
  FXId = 600009,
  Function = "PlayFX",
  Overlap = true
}
T.RT_509 = {
  FXId = 600009,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_510 = {
  [1] = T.RT_509
}
T.RT_511 = {"hit10"}
T.RT_512 = {
  BuffId = 6000204,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_513 = {
  [1] = T.RT_512
}
T.RT_514 = {
  BuffId = 30400008,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_515 = {
  [1] = T.RT_514
}
T.RT_516 = {
  BuffId = 30400009,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_517 = {
  [1] = T.RT_516
}
T.RT_518 = {
  [1] = T.RT_3,
  [2] = T.RT_497
}
T.RT_519 = {
  [1] = T.RT_498,
  [2] = T.RT_497
}
T.RT_520 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 10000
}
T.RT_521 = {FXId = 851511, Function = "PlayFX"}
T.RT_522 = {FXId = 600302, Function = "PlayFX"}
T.RT_523 = {
  [1] = T.RT_33,
  [2] = T.RT_497
}
T.RT_524 = {Function = "PlaySE", SEId = 310105}
T.RT_525 = {"hit1", "hit2"}
T.RT_526 = {
  FXId = 310203,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_527 = {Function = "Disarm"}
T.RT_528 = {Function = "PlaySE", SEId = 310205}
T.RT_529 = {
  BossValue = 8,
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 33
}
T.RT_530 = {
  [1] = T.RT_244,
  [2] = T.RT_529,
  [3] = T.RT_528,
  [4] = T.RT_119,
  [5] = T.RT_413
}
T.RT_531 = {
  FXId = 310204,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_532 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 500,
  ShakeClass = "BP_Camera_Yeer_Explode_Light"
}
T.RT_533 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_40,
  DamageType = "Fire",
  Function = "Damage",
  Rate = "#1",
  Value = "#2"
}
T.RT_534 = {
  BossValue = 160,
  CauseHit = "HitFly_XY300Z800",
  Function = "CutToughness",
  Value = 100
}
T.RT_535 = {
  BuffId = 205,
  Function = "AddBuff",
  LastTime = 5
}
T.RT_536 = {Function = "PlaySE", SEId = 320105}
T.RT_537 = {
  CreatureId = 320202,
  Function = "RemoveSkillCreature"
}
T.RT_538 = {
  -40,
  0,
  70
}
T.RT_539 = {
  AutoAttach = 1,
  CreatureId = 320202,
  Function = "CreateSkillCreature",
  Location = T.RT_538
}
T.RT_540 = {
  "Skill",
  "KamiPassive"
}
T.RT_541 = {FXId = 320203, Function = "PlayFX"}
T.RT_542 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_180,
  Delay = 0.2,
  Function = "Damage",
  Rate = "#1"
}
T.RT_543 = {
  BuffId = 201,
  Delay = 0.2,
  Function = "AddBuff",
  LastTime = 2
}
T.RT_544 = {
  BossValue = 23,
  CauseHit = "LightHit",
  Delay = 0.2,
  Function = "CutToughness",
  Value = 5
}
T.RT_545 = {
  BaseChar = "Target",
  FXId = 330110,
  Function = "PlayFX",
  IsEffectCreature = true
}
T.RT_546 = {Function = "PlaySE", SEId = 330101}
T.RT_547 = {
  BaseChar = "Target",
  CreateWithoutTarget = false,
  CreatureId = 330103,
  DefaultLocationOffset = T.RT_312,
  Function = "CreateSkillCreature"
}
T.RT_548 = {
  [1] = T.RT_542,
  [2] = T.RT_543,
  [3] = T.RT_544,
  [4] = T.RT_545,
  [5] = T.RT_546,
  [6] = T.RT_547
}
T.RT_549 = {
  Function = "ExecutePassiveFunction",
  FunctionName = "ClearSkill01TargetNum",
  PassiveEffectId = 330101
}
T.RT_550 = {
  [1] = T.RT_542,
  [2] = T.RT_543,
  [3] = T.RT_544,
  [4] = T.RT_545,
  [5] = T.RT_546,
  [6] = T.RT_549
}
T.RT_551 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 2000,
  ShakeClass = "BP_CS_Maer_Hit01"
}
T.RT_552 = {
  BossValue = 93,
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 30
}
T.RT_553 = {
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 100
}
T.RT_554 = {"Support"}
T.RT_555 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_554,
  DamageType = "Dark",
  Delay = 0.4,
  Function = "Damage",
  Rate = "#1"
}
T.RT_556 = {
  CauseHit = "LightHit_100_F",
  Delay = 0.4,
  Function = "CutToughness",
  Value = 80
}
T.RT_557 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 2018
}
T.RT_558 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 2016
}
T.RT_559 = {
  FXId = 90003,
  Function = "PlayFX",
  Overlap = true
}
T.RT_560 = {
  CauseHit = "HitFly_Force_Common",
  Function = "CutToughness",
  Value = 1000
}
T.RT_561 = {
  FXId = 90003,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_562 = {
  BaseAttr = "ATK_Char",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 5
}
T.RT_563 = {
  FXId = 90004,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_564 = {
  CauseHit = "RangedWeapon_Shotgun",
  Function = "CutToughness",
  Value = 0.2
}
T.RT_565 = {
  [1] = T.RT_563
}
T.RT_566 = {
  BaseAttr = "ATK_Char",
  DamageType = "Default",
  Function = "Damage",
  Rate = 24
}
T.RT_567 = {
  CauseHit = "HitFly_XY400Z300_F",
  Function = "CutToughness",
  Value = 1000
}
T.RT_568 = {Function = "PlaySE", SEId = 2017}
T.RT_569 = {
  [1] = T.RT_566,
  [2] = T.RT_561,
  [3] = T.RT_567,
  [4] = T.RT_568
}
T.RT_570 = {
  BaseAttr = "ATK_Char",
  DamageType = "Default",
  Function = "Damage",
  Rate = 2.8
}
T.RT_571 = {
  [1] = T.RT_570,
  [2] = T.RT_563
}
T.RT_572 = {
  BaseAttr = "ATK_Char",
  DamageType = "Default",
  Function = "Damage",
  Rate = 5
}
T.RT_573 = {
  [1] = T.RT_572,
  [2] = T.RT_563
}
T.RT_574 = {Function = "PlaySE", SEId = 900402}
T.RT_575 = {
  BuffId = 850204,
  Function = "AddBuff",
  LastTime = 1.3
}
T.RT_576 = {
  BuffId = 850204,
  BySource = true,
  Function = "RemoveBuff"
}
T.RT_577 = {
  FXId = 40101007,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_578 = {
  [1] = T.RT_566,
  [2] = T.RT_577,
  [3] = T.RT_567,
  [4] = T.RT_568
}
T.RT_579 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 5
}
T.RT_580 = {
  [1] = T.RT_579
}
T.RT_581 = {
  Delay = 0.4,
  Function = "AddEnergyShield",
  IsOverShield = 1,
  Rate = 0,
  Value = "#1"
}
T.RT_582 = {
  BaseAttr = "MaxHp",
  DamageType = "Default",
  Delay = 0.4,
  Function = "Heal",
  Rate = "#1"
}
T.RT_583 = {
  BossValue = 1,
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 33
}
T.RT_584 = {Function = "PlaySE", SEId = 410105}
T.RT_585 = {
  AimTarget = true,
  FXId = 410121,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_586 = {
  [1] = T.RT_210,
  [2] = T.RT_583,
  [3] = T.RT_123
}
T.RT_587 = {
  0,
  0,
  -87
}
T.RT_588 = {Function = "PlaySE", SEId = 410207}
T.RT_589 = {
  ATKBase = "ATK_Char",
  CreatureId = 410222,
  Function = "CreateSkillCreature",
  UseSaveLoc = "ZhiliuTD"
}
T.RT_590 = {
  ATKBase = "ATK_Char",
  CreatureId = 410223,
  Function = "CreateSkillCreature",
  UseSaveLoc = "ZhiliuTD"
}
T.RT_591 = {Function = "PlaySE", SEId = 410211}
T.RT_592 = {
  Function = "ExecuteClientPassiveFunction",
  FunctionName = "EndPP"
}
T.RT_593 = {
  CreatureId = 410225,
  Function = "RemoveSkillCreature"
}
T.RT_594 = {
  CreatureId = 410245,
  Function = "RemoveSkillCreature"
}
T.RT_595 = {
  BossValue = 12,
  CauseHit = "HitFly_XY400Z300",
  Function = "CutToughness",
  Value = 100
}
T.RT_596 = {
  CanBeScaled = true,
  FXId = 410215,
  Function = "PlayFX",
  IsAttached = 1
}
T.RT_597 = {Function = "PlaySE", SEId = 410210}
T.RT_598 = {
  [1] = T.RT_210,
  [2] = T.RT_595,
  [3] = T.RT_596,
  [4] = T.RT_597
}
T.RT_599 = {ComboCount = 1, Function = "HitCount"}
T.RT_600 = {
  [1] = T.RT_599
}
T.RT_601 = {
  DamageType = "TrueDamage",
  Function = "Damage",
  Value = 200
}
T.RT_602 = {
  BuffId = 420111,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_603 = {
  Delay = 0.1,
  FXId = 26,
  Function = "PlayFX"
}
T.RT_604 = {
  "Skill",
  "Skill2",
  "YumingExtra"
}
T.RT_605 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_604,
  Function = "Damage",
  Rate = "#1"
}
T.RT_606 = {
  BaseChar = "Target",
  FXId = 420103,
  Function = "PlayFX"
}
T.RT_607 = {
  [1] = T.RT_605,
  [2] = T.RT_606
}
T.RT_608 = {
  BaseAttr = "DEF",
  DamageTag = T.RT_40,
  DamageType = "EsDamage",
  Function = "Damage",
  Rate = "#1",
  Value = "#2"
}
T.RT_609 = {
  "Skill",
  "Skill1",
  "XibiSkill01",
  "XibiSkill01SP"
}
T.RT_610 = {
  CreatureId = 430111,
  Function = "RemoveSkillCreature"
}
T.RT_611 = {
  CreatureId = 430113,
  Function = "RemoveSkillCreature"
}
T.RT_612 = {
  CreatureId = 430114,
  Function = "RemoveSkillCreature"
}
T.RT_613 = {
  [1] = T.RT_610,
  [2] = T.RT_611,
  [3] = T.RT_612
}
T.RT_614 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_243,
  DamageType = "Thunder",
  Function = "Damage",
  Rate = "#1",
  Value = "#2"
}
T.RT_615 = {
  [1] = T.RT_614
}
T.RT_616 = {
  BossValue = 46,
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 33
}
T.RT_617 = {FXId = 500000306, Function = "PlayFX"}
T.RT_618 = {
  BaseAttr = "MaxHp",
  BaseChar = "Target",
  DamageType = "Default",
  Function = "Damage",
  Rate = 0.67
}
T.RT_619 = {-200, 200}
T.RT_620 = {
  CauseHit = "HitFly_XY400Z600",
  Function = "CutToughness",
  Value = 150
}
T.RT_621 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_180,
  DamageType = "Wind",
  Function = "Damage",
  Rate = "#1",
  Value = "#2"
}
T.RT_622 = {
  BuffType = 10,
  Function = "RemoveBuff",
  Num = 1
}
T.RT_623 = {
  BossValue = 56,
  CauseHit = "HitFly_XY1000Z500",
  Function = "CutToughness",
  Value = 100
}
T.RT_624 = {FXId = 510105, Function = "PlayFX"}
T.RT_625 = {Function = "PlaySE", SEId = 510102}
T.RT_626 = {"MeleeWord", "Skill"}
T.RT_627 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_626,
  DamageType = "Wind",
  Function = "Damage",
  Rate = "#1",
  Value = "#2"
}
T.RT_628 = {
  BodyAccessoryEffect = true,
  DieEffect = false,
  Function = "AdditionalHitFX"
}
T.RT_629 = {
  Function = "ExecutePassiveFunction",
  FunctionName = "QuitSkill02",
  PassiveEffectId = 510201
}
T.RT_630 = {
  ATK = 1,
  DEF = 1,
  ES = 0,
  EnmityValue = 0,
  MaxES = 0,
  MaxHp = 1,
  SkillIntensity = 1,
  StrongValue = 0
}
T.RT_631 = {
  AttrRates = T.RT_630,
  Function = "CreateUnit",
  IsShadow = 1,
  LifeTime = 5,
  MaxSummonCount = 1,
  SingleSummonCount = 1,
  UnitId = 530101,
  UnitType = "Monster"
}
T.RT_632 = {Function = "PlaySE", SEId = 25}
T.RT_633 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.05,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_634 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_635 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.15,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_636 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.2,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_637 = {"RootSource"}
T.RT_638 = {Function = "PlaySE", SEId = 530102}
T.RT_639 = {
  "Skill",
  "Skill1",
  "SaiqiSkill01"
}
T.RT_640 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_639,
  Function = "Damage",
  Rate = "#1"
}
T.RT_641 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.25,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_642 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.3,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_643 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.35,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_644 = {
  ATKBase = "ATK",
  CreatureId = 530111,
  Delay = 0.4,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SaiqiMissle"
}
T.RT_645 = {
  ClientSkillLogicId = 530101,
  Function = "ExecuteClientSkillLogicFunction",
  FunctionName = "SetShootLoc"
}
T.RT_646 = {
  BaseAttr = "ATK_Ultra",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = "#1"
}
T.RT_647 = {
  BossValue = 14,
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 15
}
T.RT_648 = {Function = "PlaySE", SEId = 530106}
T.RT_649 = {
  BaseAttr = "ATK_Char",
  Function = "Heal",
  Rate = "#1",
  Value = 35
}
T.RT_650 = {
  BaseAttr = "MaxSp",
  DamageTag = T.RT_180,
  DamageType = "Wind",
  Function = "Damage",
  Rate = 1
}
T.RT_651 = {
  BuffId = 540222,
  Function = "AddBuff",
  LastTime = 12
}
T.RT_652 = {
  [1] = T.RT_651
}
T.RT_653 = {
  "PhantomAvoid"
}
T.RT_654 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_653,
  Function = "Damage",
  Rate = 0.1
}
T.RT_655 = {FXId = 600001, Function = "PlayFX"}
T.RT_656 = {
  AimTarget = true,
  FXId = 600000402,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_657 = {
  "PhantomAvoid",
  "Fade"
}
T.RT_658 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_657,
  Function = "Damage",
  Rate = 0.4
}
T.RT_659 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.67
}
T.RT_660 = {FXId = 600009, Function = "PlayFX"}
T.RT_661 = {
  [1] = T.RT_659,
  [2] = T.RT_660,
  [3] = T.RT_5
}
T.RT_662 = {
  BuffId = 600101,
  Function = "AddBuff",
  LastTime = 5
}
T.RT_663 = {
  [1] = T.RT_662
}
T.RT_664 = {
  BuffId = 600101,
  BySource = true,
  Function = "RemoveBuff"
}
T.RT_665 = {
  [1] = T.RT_664
}
T.RT_666 = {
  "hit1",
  "hit2",
  "hit3"
}
T.RT_667 = {
  FXId = 600203,
  Function = "PlayFX",
  Overlap = true
}
T.RT_668 = {Function = "PlaySE", SEId = 600201}
T.RT_669 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.57
}
T.RT_670 = {
  FXId = 600203,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_671 = {
  Function = "PlaySE",
  SEId = 600201,
  SceneSe = true
}
T.RT_672 = {
  [1] = T.RT_670,
  [2] = T.RT_671
}
T.RT_673 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 2.67
}
T.RT_674 = {
  BaseAttr = "MaxHp",
  Function = "Heal",
  Rate = 0.3
}
T.RT_675 = {
  BaseAttr = "MaxHp",
  Function = "Heal",
  Rate = 0.5
}
T.RT_676 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 2.1
}
T.RT_677 = {
  [1] = T.RT_676,
  [2] = T.RT_660,
  [3] = T.RT_5
}
T.RT_678 = {Function = "PlaySE", SEId = 600401}
T.RT_679 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 2.5
}
T.RT_680 = {
  CauseHit = "HitFly_XY1200Z1000",
  Function = "CutToughness",
  Value = 100
}
T.RT_681 = {
  CauseHit = "LightHit_300",
  Function = "CutToughness",
  Value = 100
}
T.RT_682 = {
  BuffId = 600501,
  Function = "AddBuff",
  LastTime = 3
}
T.RT_683 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 4
}
T.RT_684 = {
  CauseHit = "LightHit_300",
  Function = "CutToughness"
}
T.RT_685 = {Function = "PlaySE", SEId = 600701}
T.RT_686 = {
  Function = "PlaySE",
  SEId = 600701,
  SceneSe = true
}
T.RT_687 = {
  BaseAttr = "MaxHP",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 0.5
}
T.RT_688 = {
  [1] = T.RT_687,
  [2] = T.RT_10,
  [3] = T.RT_685
}
T.RT_689 = {
  CauseHit = "HitFly_XY800Z1000",
  Function = "CutToughness"
}
T.RT_690 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.85
}
T.RT_691 = {FXId = 600704, Function = "PlayFX"}
T.RT_692 = {
  0,
  800,
  0
}
T.RT_693 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_554,
  Function = "Damage",
  Rate = 60
}
T.RT_694 = {FXId = 6011, Function = "PlayFX"}
T.RT_695 = {Function = "PlaySE", SEId = 624}
T.RT_696 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_554,
  Function = "Damage",
  Rate = 120
}
T.RT_697 = {
  FXId = 601202,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_698 = {
  BuffId = 6000301,
  Function = "AddBuff",
  LastTime = 5
}
T.RT_699 = {Function = "PlaySE", SEId = 600203}
T.RT_700 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.43
}
T.RT_701 = {
  CauseHit = "LightHit_100",
  Function = "CutToughness",
  Value = 100
}
T.RT_702 = {Function = "PlaySE", SEId = 600303}
T.RT_703 = {
  BaseAttr = "MaxHp",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 2
}
T.RT_704 = {Function = "PlaySE", SEId = 601502}
T.RT_705 = {Function = "PlaySE", SEId = 601503}
T.RT_706 = {FXId = 601504, Function = "PlayFX"}
T.RT_707 = {
  FXId = 601603,
  Function = "PlayFX",
  Overlap = true
}
T.RT_708 = {Function = "PlaySE", SEId = 601601}
T.RT_709 = {
  FXId = 601606,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_710 = {
  [1] = T.RT_709
}
T.RT_711 = {Function = "PlaySE", SEId = 601701}
T.RT_712 = {
  [1] = T.RT_659,
  [2] = T.RT_660,
  [3] = T.RT_711
}
T.RT_713 = {
  CreatureId = 60200,
  Function = "CreateSkillCreature"
}
T.RT_714 = {
  [1] = T.RT_713,
  [2] = T.RT_713,
  [3] = T.RT_713,
  [4] = T.RT_713,
  [5] = T.RT_713,
  [6] = T.RT_713,
  [7] = T.RT_713,
  [8] = T.RT_713
}
T.RT_715 = {
  BaseAttr = "ATK_Char",
  DamageTag = T.RT_554,
  Function = "Damage",
  Rate = 5
}
T.RT_716 = {FXId = 6022, Function = "PlayFX"}
T.RT_717 = {
  CauseHit = "LightHit_100",
  Function = "CutToughness",
  Value = 15
}
T.RT_718 = {Function = "PlaySE", SEId = 626}
T.RT_719 = {
  CreatureId = 60202,
  Function = "CreateSkillCreature"
}
T.RT_720 = {
  [1] = T.RT_719,
  [2] = T.RT_719,
  [3] = T.RT_719,
  [4] = T.RT_719,
  [5] = T.RT_719,
  [6] = T.RT_719,
  [7] = T.RT_719,
  [8] = T.RT_719
}
T.RT_721 = {
  CreatureId = 60301,
  Function = "CreateSkillCreature"
}
T.RT_722 = {
  CreatureId = 60303,
  Function = "CreateSkillCreature"
}
T.RT_723 = {
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 20
}
T.RT_724 = {Function = "PlaySE", SEId = 629}
T.RT_725 = {
  CreatureId = 700101,
  ExtraRotation = 105,
  Function = "CreateSkillCreature"
}
T.RT_726 = {
  FXId = 700104,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_727 = {
  [1] = T.RT_725,
  [2] = T.RT_726
}
T.RT_728 = {
  FXId = 600006,
  Function = "PlayFX",
  Overlap = true
}
T.RT_729 = {Function = "PlaySE", SEId = 1001}
T.RT_730 = {
  FXId = 600006,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_731 = {
  Function = "PlaySE",
  SEId = 1001,
  SceneSe = true
}
T.RT_732 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.53
}
T.RT_733 = {
  [1] = T.RT_732,
  [2] = T.RT_4
}
T.RT_734 = {
  -25,
  -90,
  0
}
T.RT_735 = {
  FXId = 600008,
  Function = "PlayFX",
  FxRotator = T.RT_734,
  IsFaceToChar = true
}
T.RT_736 = {
  30,
  -90,
  0
}
T.RT_737 = {
  FXId = 600008,
  Function = "PlayFX",
  FxRotator = T.RT_736,
  IsFaceToChar = true
}
T.RT_738 = {
  FXId = 600008,
  Function = "PlayFX",
  IsFaceToChar = true
}
T.RT_739 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.18
}
T.RT_740 = {
  FXId = 700302,
  Function = "PlayFX",
  NormalToHit = true
}
T.RT_741 = {
  "hit1",
  "hit2",
  "hit3",
  "hit4"
}
T.RT_742 = {FXId = 600007, Function = "PlayFX"}
T.RT_743 = {
  10,
  -90,
  0
}
T.RT_744 = {
  FXId = 600008,
  Function = "PlayFX",
  FxRotator = T.RT_743,
  IsFaceToChar = true
}
T.RT_745 = {
  CauseHit = "HitFly_XY1000Z1000",
  Function = "CutToughness",
  Value = 100
}
T.RT_746 = {
  BuffId = 700501,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_747 = {
  [1] = T.RT_746
}
T.RT_748 = {BuffId = 700501, Function = "RemoveBuff"}
T.RT_749 = {
  [1] = T.RT_748
}
T.RT_750 = {
  BuffId = 700502,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_751 = {
  [1] = T.RT_750
}
T.RT_752 = {
  BaseAttr = "MaxHp",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 1
}
T.RT_753 = {
  [1] = T.RT_752
}
T.RT_754 = {
  [1] = T.RT_357,
  [2] = T.RT_10,
  [3] = T.RT_742
}
T.RT_755 = {Function = "PlaySE", SEId = 700804}
T.RT_756 = {
  FXId = 700802,
  Function = "PlayFX",
  NormalToHit = true
}
T.RT_757 = {
  CauseHit = "HitFly_XY600Z1000",
  Function = "CutToughness",
  Value = 100
}
T.RT_758 = {
  CauseHit = "LightHit_200",
  Function = "CutToughness",
  Value = 100
}
T.RT_759 = {Tag = 6}
T.RT_760 = {
  Function = "EffectFunction",
  FunctionName = "SelfLocation",
  Vars = T.RT_759
}
T.RT_761 = {
  Distance = 700,
  MaxNum = 4,
  Radius = 1000
}
T.RT_762 = {
  Function = "EffectFunction",
  FunctionName = "RandomAreaLocation",
  Vars = T.RT_761
}
T.RT_763 = {
  CauseHit = "HitFly_XY800Z1000",
  Function = "CutToughness",
  Value = 100
}
T.RT_764 = {Function = "PlaySE", SEId = 700901}
T.RT_765 = {
  [1] = T.RT_659,
  [2] = T.RT_660,
  [3] = T.RT_764
}
T.RT_766 = {
  0,
  0,
  -50
}
T.RT_767 = {Function = "PlaySE", SEId = 701001}
T.RT_768 = {FXId = 701006, Function = "PlayFX"}
T.RT_769 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.39
}
T.RT_770 = {
  FXId = 701304,
  Function = "PlayFX",
  NormalToHit = true
}
T.RT_771 = {Function = "SaveLoc", TargetType = "Target"}
T.RT_772 = {
  [1] = T.RT_771
}
T.RT_773 = {
  0,
  20,
  40
}
T.RT_774 = {FXId = 701504, Function = "PlayFX"}
T.RT_775 = {
  BaseAttr = "MaxHP",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 1
}
T.RT_776 = {
  [1] = T.RT_775
}
T.RT_777 = {Function = "PlaySE", SEId = 701602}
T.RT_778 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.8
}
T.RT_779 = {Function = "PlaySE", SEId = 800101}
T.RT_780 = {Function = "PlaySE", SEId = 800102}
T.RT_781 = {
  [1] = T.RT_3,
  [2] = T.RT_4,
  [3] = T.RT_780
}
T.RT_782 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.6
}
T.RT_783 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 3
}
T.RT_784 = {
  CauseHit = "LightHit_400",
  Function = "CutToughness",
  Value = 100
}
T.RT_785 = {FXId = 850001, Function = "PlayFX"}
T.RT_786 = {
  CauseHit = "LightHit_150",
  Function = "CutToughness",
  Value = 100
}
T.RT_787 = {
  [1] = T.RT_783,
  [2] = T.RT_785,
  [3] = T.RT_786,
  [4] = T.RT_5
}
T.RT_788 = {
  [1] = T.RT_16,
  [2] = T.RT_785,
  [3] = T.RT_786,
  [4] = T.RT_5
}
T.RT_789 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 2.3
}
T.RT_790 = {
  [1] = T.RT_789,
  [2] = T.RT_785,
  [3] = T.RT_681,
  [4] = T.RT_5
}
T.RT_791 = {
  [1] = T.RT_22,
  [2] = T.RT_785,
  [3] = T.RT_681,
  [4] = T.RT_5
}
T.RT_792 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 4.5
}
T.RT_793 = {
  [1] = T.RT_792,
  [2] = T.RT_785,
  [3] = T.RT_786,
  [4] = T.RT_5
}
T.RT_794 = {
  CreatureId = 850011,
  Function = "CreateSkillCreature"
}
T.RT_795 = {
  [1] = T.RT_794
}
T.RT_796 = {
  CreatureId = 850011,
  Function = "RemoveSkillCreature"
}
T.RT_797 = {
  [1] = T.RT_796
}
T.RT_798 = {
  [1] = T.RT_3,
  [2] = T.RT_785,
  [3] = T.RT_786,
  [4] = T.RT_5
}
T.RT_799 = {
  CreatureId = 850012,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SwordDashLocStart"
}
T.RT_800 = {
  CreatureId = 850012,
  Delay = 0.3,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SwordDashLocMid"
}
T.RT_801 = {
  CreatureId = 850012,
  Delay = 0.6,
  Function = "CreateSkillCreature",
  UseSaveLoc = "SwordDashLocEnd"
}
T.RT_802 = {
  [1] = T.RT_799,
  [2] = T.RT_800,
  [3] = T.RT_801
}
T.RT_803 = {
  [1] = T.RT_3,
  [2] = T.RT_785,
  [3] = T.RT_681,
  [4] = T.RT_5
}
T.RT_804 = {
  0,
  0,
  -100
}
T.RT_805 = {
  Delay = 0.1,
  FXId = 850002,
  Function = "PlayFX"
}
T.RT_806 = {
  CauseHit = "LightHit_100",
  Delay = 0.1,
  Function = "CutToughness",
  Value = 100
}
T.RT_807 = {
  50,
  -50,
  0
}
T.RT_808 = {
  50,
  50,
  0
}
T.RT_809 = {FXId = 850002, Function = "PlayFX"}
T.RT_810 = {
  [1] = T.RT_673,
  [2] = T.RT_809,
  [3] = T.RT_701
}
T.RT_811 = {
  BoneName = "head",
  DanmakuTemplateId = 850051,
  Duration = 3,
  Function = "CreateDanmaku"
}
T.RT_812 = {
  [1] = T.RT_811
}
T.RT_813 = {
  FXId = 850011,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_814 = {
  [1] = T.RT_498,
  [2] = T.RT_813,
  [3] = T.RT_809
}
T.RT_815 = {
  CantLockTime = 0.8,
  Function = "CameraUnlock"
}
T.RT_816 = {
  [1] = T.RT_815
}
T.RT_817 = {
  Function = "SetSelfLoc",
  SaveLocTag = "BornLoc",
  TargetCenterLoc = "SavedLoc"
}
T.RT_818 = {
  [1] = T.RT_817
}
T.RT_819 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 5.5
}
T.RT_820 = {
  [1] = T.RT_819,
  [2] = T.RT_785,
  [3] = T.RT_39
}
T.RT_821 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.4
}
T.RT_822 = {
  [1] = T.RT_821,
  [2] = T.RT_809
}
T.RT_823 = {
  CauseHit = "BossXibi_Skill07",
  Function = "CutToughness",
  Value = 100
}
T.RT_824 = {
  [1] = T.RT_819,
  [2] = T.RT_823
}
T.RT_825 = {"hit7"}
T.RT_826 = {
  0,
  0,
  350
}
T.RT_827 = {
  FixLocation = true,
  FixLocationEndZ = -2000,
  FixLocationStartZ = 100,
  Function = "SetSelfLoc",
  LocOffset = T.RT_826,
  TargetCenterLoc = "SavedLoc"
}
T.RT_828 = {
  [1] = T.RT_827
}
T.RT_829 = {"hit8"}
T.RT_830 = {
  CauseHit = "BossXibi_Skill08",
  Function = "CutToughness",
  Value = 100
}
T.RT_831 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.25
}
T.RT_832 = {
  [1] = T.RT_831,
  [2] = T.RT_809
}
T.RT_833 = {"MajoDodge"}
T.RT_834 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 0.7
}
T.RT_835 = {
  CauseHit = "LightHit_120",
  Function = "CutToughness",
  Value = 100
}
T.RT_836 = {Function = "PlaySE", SEId = 850107}
T.RT_837 = {
  [1] = T.RT_834,
  [2] = T.RT_835,
  [3] = T.RT_836
}
T.RT_838 = {
  CauseHit = "BossLizhan_Skill02",
  Function = "CutToughness",
  Value = 100
}
T.RT_839 = {Function = "PlaySE", SEId = 850108}
T.RT_840 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 1.2
}
T.RT_841 = {
  [1] = T.RT_840,
  [2] = T.RT_838,
  [3] = T.RT_839
}
T.RT_842 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 0.9
}
T.RT_843 = {FXId = 850313, Function = "PlayFX"}
T.RT_844 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 0.3
}
T.RT_845 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 0.6
}
T.RT_846 = {
  CauseHit = "LightHit_60",
  Function = "CutToughness",
  Value = 100
}
T.RT_847 = {
  Function = "PlayFX",
  FxRotator = T.RT_179,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_848 = {Function = "PlaySE", SEId = 850211}
T.RT_849 = {
  [1] = T.RT_22,
  [2] = T.RT_110,
  [3] = T.RT_847,
  [4] = T.RT_848
}
T.RT_850 = {
  3,
  -90,
  0
}
T.RT_851 = {
  Function = "PlayFX",
  FxRotator = T.RT_850,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_852 = {
  [1] = T.RT_783,
  [2] = T.RT_110,
  [3] = T.RT_851,
  [4] = T.RT_848
}
T.RT_853 = {
  [1] = T.RT_783,
  [2] = T.RT_701,
  [3] = T.RT_848
}
T.RT_854 = {
  0,
  0,
  140
}
T.RT_855 = {
  CreatureId = 850207,
  Function = "CreateSkillCreature",
  Location = T.RT_854
}
T.RT_856 = {
  [1] = T.RT_855
}
T.RT_857 = {
  CreatureId = 850210,
  Function = "CreateSkillCreature",
  Location = T.RT_854
}
T.RT_858 = {
  [1] = T.RT_857
}
T.RT_859 = {Function = "PlaySE", SEId = 850232}
T.RT_860 = {
  [1] = T.RT_16,
  [2] = T.RT_110,
  [3] = T.RT_859
}
T.RT_861 = {
  [1] = T.RT_683,
  [2] = T.RT_758,
  [3] = T.RT_315,
  [4] = T.RT_848
}
T.RT_862 = {
  Function = "PlayFX",
  FxRotator = T.RT_57,
  IsFaceToChar = true,
  WeaponFXGroupName = "Hit"
}
T.RT_863 = {
  [1] = T.RT_783,
  [2] = T.RT_701,
  [3] = T.RT_862,
  [4] = T.RT_848
}
T.RT_864 = {
  BuffId = 850202,
  Function = "AddBuff",
  LastTime = 99
}
T.RT_865 = {
  BuffId = 850206,
  Function = "AddBuff",
  LastTime = 99
}
T.RT_866 = {
  BuffId = 850207,
  Function = "AddBuff",
  LastTime = 99
}
T.RT_867 = {
  BuffId = 850208,
  Function = "AddBuff",
  LastTime = 99
}
T.RT_868 = {
  BuffId = 850209,
  Function = "AddBuff",
  LastTime = 99
}
T.RT_869 = {
  [1] = T.RT_865,
  [2] = T.RT_866,
  [3] = T.RT_867,
  [4] = T.RT_868
}
T.RT_870 = {"hit13"}
T.RT_871 = {BuffId = 850202, Function = "RemoveBuff"}
T.RT_872 = {BuffId = 850206, Function = "RemoveBuff"}
T.RT_873 = {BuffId = 850207, Function = "RemoveBuff"}
T.RT_874 = {BuffId = 850208, Function = "RemoveBuff"}
T.RT_875 = {BuffId = 850209, Function = "RemoveBuff"}
T.RT_876 = {
  [1] = T.RT_871,
  [2] = T.RT_872,
  [3] = T.RT_873,
  [4] = T.RT_874,
  [5] = T.RT_875
}
T.RT_877 = {
  0,
  600,
  400
}
T.RT_878 = {
  CreatureId = 850201,
  Direction = T.RT_877,
  Function = "CreateSkillCreature"
}
T.RT_879 = {
  [1] = T.RT_878
}
T.RT_880 = {
  0,
  600,
  -400
}
T.RT_881 = {
  CreatureId = 850202,
  Direction = T.RT_880,
  Function = "CreateSkillCreature"
}
T.RT_882 = {
  [1] = T.RT_881
}
T.RT_883 = {
  0,
  -600,
  400
}
T.RT_884 = {
  CreatureId = 850204,
  Direction = T.RT_883,
  Function = "CreateSkillCreature"
}
T.RT_885 = {
  [1] = T.RT_884
}
T.RT_886 = {
  0,
  -600,
  -400
}
T.RT_887 = {
  CreatureId = 850205,
  Direction = T.RT_886,
  Function = "CreateSkillCreature"
}
T.RT_888 = {
  [1] = T.RT_887
}
T.RT_889 = {Function = "PlaySE", SEId = 850262}
T.RT_890 = {
  FixLocationEndZ = -3500,
  Function = "SaveLoc",
  IsOnGround = true,
  TargetType = "Target"
}
T.RT_891 = {Distance = 600}
T.RT_892 = {
  Function = "EffectFunction",
  FunctionName = "RelativeLocationToTarget",
  Vars = T.RT_891
}
T.RT_893 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.3
}
T.RT_894 = {
  [1] = T.RT_893,
  [2] = T.RT_758,
  [3] = T.RT_316
}
T.RT_895 = {
  [1] = T.RT_890
}
T.RT_896 = {
  CreatureId = 850213,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = ""
}
T.RT_897 = {
  CreatureId = 850211,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = ""
}
T.RT_898 = {
  [1] = T.RT_783,
  [2] = T.RT_319
}
T.RT_899 = {
  [1] = T.RT_575
}
T.RT_900 = {
  [1] = T.RT_576
}
T.RT_901 = {
  Function = "CreateUnit",
  LifeTime = 15,
  UnitId = 850291,
  UnitType = "MechanismSummon"
}
T.RT_902 = {
  [1] = T.RT_901
}
T.RT_903 = {
  "hit3",
  "hit5",
  "hit7",
  "hit9"
}
T.RT_904 = {
  "hit4",
  "hit6",
  "hit8",
  "hit10"
}
T.RT_905 = {
  CreatureId = 850212,
  Function = "CreateSkillCreature",
  UseSaveLoc = ""
}
T.RT_906 = {
  [1] = T.RT_905
}
T.RT_907 = {Function = "PlaySE", SEId = 850292}
T.RT_908 = {"hit11"}
T.RT_909 = {
  CreatureId = 850208,
  Function = "CreateSkillCreature",
  UseSaveLoc = ""
}
T.RT_910 = {
  [1] = T.RT_909
}
T.RT_911 = {
  [1] = T.RT_783,
  [2] = T.RT_680,
  [3] = T.RT_250
}
T.RT_912 = {
  [1] = T.RT_683,
  [2] = T.RT_757,
  [3] = T.RT_250
}
T.RT_913 = {"hit12"}
T.RT_914 = {
  CantLockTime = 6,
  Function = "CameraUnlock"
}
T.RT_915 = {
  [1] = T.RT_914
}
T.RT_916 = {
  CantLockTime = 1.5,
  Function = "CameraUnlock"
}
T.RT_917 = {
  [1] = T.RT_916
}
T.RT_918 = {
  [1] = T.RT_783,
  [2] = T.RT_848,
  [3] = T.RT_758
}
T.RT_919 = {
  [1] = T.RT_16,
  [2] = T.RT_680,
  [3] = T.RT_848
}
T.RT_920 = {
  [1] = T.RT_783,
  [2] = T.RT_680,
  [3] = T.RT_848
}
T.RT_921 = {
  CreatureId = 850211,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "1"
}
T.RT_922 = {
  CreatureId = 850211,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "2"
}
T.RT_923 = {
  CreatureId = 850211,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "3"
}
T.RT_924 = {
  CreatureId = 850211,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "4"
}
T.RT_925 = {
  CreatureId = 850213,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "1"
}
T.RT_926 = {
  CreatureId = 850213,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "2"
}
T.RT_927 = {
  CreatureId = 850213,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "3"
}
T.RT_928 = {
  CreatureId = 850213,
  Function = "CreateSkillCreature",
  Location = T.RT_766,
  UseSaveLoc = "4"
}
T.RT_929 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.7
}
T.RT_930 = {
  CauseHit = "BossShijingzhe_Effect850301",
  Function = "CutToughness",
  Value = 100
}
T.RT_931 = {FXId = 850312, Function = "PlayFX"}
T.RT_932 = {Function = "PlaySE", SEId = 850322}
T.RT_933 = {
  [1] = T.RT_782,
  [2] = T.RT_930,
  [3] = T.RT_931,
  [4] = T.RT_932
}
T.RT_934 = {
  CauseHit = "BossShijingzhe_Effect850302",
  Function = "CutToughness",
  Value = 100
}
T.RT_935 = {
  [1] = T.RT_782,
  [2] = T.RT_934,
  [3] = T.RT_931,
  [4] = T.RT_932
}
T.RT_936 = {
  CreatureId = 850305,
  Function = "CreateSkillCreature"
}
T.RT_937 = {
  [1] = T.RT_936
}
T.RT_938 = {
  CauseHit = "BossShijingzhe_Effect850304",
  Function = "CutToughness",
  Value = 100
}
T.RT_939 = {Function = "PlaySE", SEId = 850320}
T.RT_940 = {
  [1] = T.RT_16,
  [2] = T.RT_938,
  [3] = T.RT_931,
  [4] = T.RT_939
}
T.RT_941 = {
  CreatureId = 850301,
  Function = "CreateSkillCreature"
}
T.RT_942 = {
  [1] = T.RT_941
}
T.RT_943 = {
  CreatureId = 850301,
  Function = "RemoveSkillCreature"
}
T.RT_944 = {
  [1] = T.RT_943
}
T.RT_945 = {
  BoneName = "head",
  DanmakuTemplateId = 850303,
  Duration = 7,
  Function = "CreateDanmaku"
}
T.RT_946 = {
  [1] = T.RT_945
}
T.RT_947 = {
  CauseHit = "BossShijingzhe_Effect850316",
  Function = "CutToughness",
  Value = 100
}
T.RT_948 = {
  CauseHit = "BossShijingzhe_Effect850320",
  Function = "CutToughness",
  Value = 100
}
T.RT_949 = {
  [1] = T.RT_14,
  [2] = T.RT_948,
  [3] = T.RT_931,
  [4] = T.RT_932
}
T.RT_950 = {
  CreatureId = 850305,
  Function = "RemoveSkillCreature"
}
T.RT_951 = {
  [1] = T.RT_950
}
T.RT_952 = {
  -350,
  300,
  0
}
T.RT_953 = {
  50,
  0,
  0
}
T.RT_954 = {"hit98", "hit99"}
T.RT_955 = {
  BaseAttr = "ATK",
  Function = "Damage",
  JumpWordHide = true,
  Rate = 999
}
T.RT_956 = {
  [1] = T.RT_955
}
T.RT_957 = {Function = "PlaySE", SEId = 850321}
T.RT_958 = {Radius = 1500}
T.RT_959 = {
  Function = "EffectFunction",
  FunctionName = "RandomAreaLocation_Shijingzhe",
  Vars = T.RT_958
}
T.RT_960 = {
  CreatureId = 850312,
  Function = "CreateSkillCreature",
  UseSaveLoc = "1"
}
T.RT_961 = {
  CreatureId = 850319,
  Function = "CreateSkillCreature",
  UseSaveLoc = "4"
}
T.RT_962 = {
  CreatureId = 850320,
  Function = "CreateSkillCreature",
  UseSaveLoc = "5"
}
T.RT_963 = {
  CreatureId = 850318,
  Function = "CreateSkillCreature",
  UseSaveLoc = "3"
}
T.RT_964 = {
  CreatureId = 850321,
  Function = "CreateSkillCreature",
  UseSaveLoc = "6"
}
T.RT_965 = {
  CreatureId = 850322,
  Function = "CreateSkillCreature",
  UseSaveLoc = "7"
}
T.RT_966 = {
  [1] = T.RT_959,
  [2] = T.RT_963,
  [3] = T.RT_964,
  [4] = T.RT_965
}
T.RT_967 = {
  CreatureId = 850323,
  Function = "CreateSkillCreature",
  UseSaveLoc = "8"
}
T.RT_968 = {
  CreatureId = 850303,
  Function = "CreateSkillCreature",
  UseSaveLoc = "1"
}
T.RT_969 = {
  CreatureId = 850313,
  Function = "CreateSkillCreature",
  UseSaveLoc = "2"
}
T.RT_970 = {
  CreatureId = 850314,
  Function = "CreateSkillCreature",
  UseSaveLoc = "3"
}
T.RT_971 = {
  CreatureId = 850315,
  Function = "CreateSkillCreature",
  UseSaveLoc = "4"
}
T.RT_972 = {
  CreatureId = 850317,
  Function = "CreateSkillCreature",
  UseSaveLoc = "2"
}
T.RT_973 = {
  CreatureId = 850303,
  Function = "TriggerSkillCreatureTriggerEvent"
}
T.RT_974 = {
  CreatureId = 850313,
  Function = "TriggerSkillCreatureTriggerEvent"
}
T.RT_975 = {
  CreatureId = 850314,
  Function = "TriggerSkillCreatureTriggerEvent"
}
T.RT_976 = {
  CreatureId = 850315,
  Function = "TriggerSkillCreatureTriggerEvent"
}
T.RT_977 = {
  [1] = T.RT_973,
  [2] = T.RT_974,
  [3] = T.RT_975,
  [4] = T.RT_976
}
T.RT_978 = {
  BoneName = "head",
  DanmakuTemplateId = 850301,
  Duration = 3.5,
  Function = "CreateDanmaku"
}
T.RT_979 = {
  [1] = T.RT_978
}
T.RT_980 = {FXId = 850320, Function = "PlayFX"}
T.RT_981 = {
  [1] = T.RT_22,
  [2] = T.RT_948,
  [3] = T.RT_931,
  [4] = T.RT_932
}
T.RT_982 = {
  -50,
  0,
  0
}
T.RT_983 = {
  -350,
  -200,
  0
}
T.RT_984 = {
  -50,
  -50,
  0
}
T.RT_985 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.6
}
T.RT_986 = {
  350,
  -200,
  0
}
T.RT_987 = {
  0,
  0,
  -150
}
T.RT_988 = {
  CauseHit = "BossShijingzhe_Effect850322",
  Function = "CutToughness",
  Value = 100
}
T.RT_989 = {
  FXId = 600000,
  Function = "PlayFX",
  Overlap = true
}
T.RT_990 = {
  BuffId = 207,
  Function = "AddBuff",
  LastTime = 5
}
T.RT_991 = {
  EventName = "OnBeforeGrabHit",
  Function = "TriggerBattleEvent"
}
T.RT_992 = {
  [1] = T.RT_990,
  [2] = T.RT_991
}
T.RT_993 = {
  [1] = T.RT_16
}
T.RT_994 = {
  [1] = T.RT_778,
  [2] = T.RT_934,
  [3] = T.RT_931,
  [4] = T.RT_939
}
T.RT_995 = {
  CantLockTime = -1,
  Function = "CameraUnlock"
}
T.RT_996 = {
  0,
  0,
  600
}
T.RT_997 = {
  90,
  0,
  0
}
T.RT_998 = {
  CreatureId = 850324,
  Function = "CreateSkillCreature",
  Location = T.RT_996,
  Rotation = T.RT_997
}
T.RT_999 = {
  CreatureId = 850306,
  Function = "RemoveSkillCreature"
}
T.RT_1000 = {
  [1] = T.RT_778,
  [2] = T.RT_934,
  [3] = T.RT_931,
  [4] = T.RT_932
}
T.RT_1001 = {DEF = 2, MaxHp = 0.1}
T.RT_1002 = {DEF = 2, MaxHp = 0.18}
T.RT_1003 = {
  -100,
  -100,
  0
}
T.RT_1004 = {
  100,
  100,
  0
}
T.RT_1005 = {
  ATK = 1,
  DEF = 1,
  ES = 1,
  Hp = 1,
  MaxES = 1,
  MaxHp = 0.1
}
T.RT_1006 = {
  AttrRates = T.RT_1005,
  FormationId = 850401,
  Function = "CreateUnit",
  LifeTime = 9999,
  MaxSummonCount = 10,
  SingleSummonCount = 1,
  UnitId = 8504003,
  UnitType = "Monster"
}
T.RT_1007 = {
  AttrRates = T.RT_1005,
  AutoAttach = 1,
  Function = "CreateUnit",
  LifeTime = 9999,
  UnitId = 850402,
  UnitType = "MechanismSummon"
}
T.RT_1008 = {
  BuffId = 6000205,
  Function = "AddBuff",
  LastTime = 9999
}
T.RT_1009 = {
  BuffId = 850406,
  Function = "AddBuff",
  LastTime = 10
}
T.RT_1010 = {Function = "PlaySE", SEId = 850409}
T.RT_1011 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.3
}
T.RT_1012 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 6
}
T.RT_1013 = {
  CauseHit = "LightHit_40",
  Function = "CutToughness",
  Value = 100
}
T.RT_1014 = {Function = "PlaySE", SEId = 850402}
T.RT_1015 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 8
}
T.RT_1016 = {
  BuffId = 850403,
  Function = "AddBuff",
  LastTime = 100000
}
T.RT_1017 = {
  [1] = T.RT_1016
}
T.RT_1018 = {
  [1] = T.RT_504,
  [2] = T.RT_1014
}
T.RT_1019 = {
  CantLockTime = 20,
  Function = "CameraUnlock"
}
T.RT_1020 = {
  -400,
  300,
  200
}
T.RT_1021 = {
  0,
  300,
  200
}
T.RT_1022 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.15
}
T.RT_1023 = {
  Function = "PlaySE",
  MeleeHitLevel = "Normal",
  SEId = 503
}
T.RT_1024 = {
  [1] = T.RT_3,
  [2] = T.RT_681,
  [3] = T.RT_1023
}
T.RT_1025 = {
  [1] = T.RT_3,
  [2] = T.RT_758,
  [3] = T.RT_1023
}
T.RT_1026 = {
  [1] = T.RT_22,
  [2] = T.RT_758,
  [3] = T.RT_1023
}
T.RT_1027 = {"hit2", "hit3"}
T.RT_1028 = {
  [1] = T.RT_33,
  [2] = T.RT_701,
  [3] = T.RT_1023
}
T.RT_1029 = {
  [1] = T.RT_33,
  [2] = T.RT_681,
  [3] = T.RT_1023
}
T.RT_1030 = {
  [1] = T.RT_22,
  [2] = T.RT_35,
  [3] = T.RT_1023
}
T.RT_1031 = {Function = "PlaySE", SEId = 850510}
T.RT_1032 = {
  [1] = T.RT_7,
  [2] = T.RT_553,
  [3] = T.RT_1031
}
T.RT_1033 = {
  BuffId = 850503,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_1034 = {
  [1] = T.RT_16,
  [2] = T.RT_1033,
  [3] = T.RT_1031,
  [4] = T.RT_701
}
T.RT_1035 = {
  CantLockTime = 1,
  Function = "CameraUnlock"
}
T.RT_1036 = {
  [1] = T.RT_1035
}
T.RT_1037 = {
  0,
  0,
  -270
}
T.RT_1038 = {
  FormationId = 850501,
  Function = "BossSPSaveLocs",
  Location = T.RT_1037,
  SetSaveLocs = "First"
}
T.RT_1039 = {
  [1] = T.RT_778,
  [2] = T.RT_758,
  [3] = T.RT_1031
}
T.RT_1040 = {
  500,
  0,
  500
}
T.RT_1041 = {
  CreatureId = 850503,
  Function = "CreateSkillCreature",
  Location = T.RT_1040
}
T.RT_1042 = {
  [1] = T.RT_1041
}
T.RT_1043 = {
  CreatureId = 850503,
  Function = "RemoveSkillCreature"
}
T.RT_1044 = {
  [1] = T.RT_1043
}
T.RT_1045 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.1
}
T.RT_1046 = {
  CauseHit = "HitFly_XY0Z300",
  Function = "CutToughness",
  Value = 100
}
T.RT_1047 = {
  [1] = T.RT_1045,
  [2] = T.RT_1046,
  [3] = T.RT_1023
}
T.RT_1048 = {
  [1] = T.RT_16,
  [2] = T.RT_745,
  [3] = T.RT_1031
}
T.RT_1049 = {
  FormationId = 850502,
  Function = "BossSPSaveLocs",
  Location = T.RT_1037,
  SetSaveLocs = "Fire"
}
T.RT_1050 = {
  CreatureId = 850515,
  Function = "CreateSkillCreature",
  Location = T.RT_1037,
  UseRelativeOffset = true,
  UseSaveLoc = "Fire1"
}
T.RT_1051 = {
  CreatureId = 850515,
  Function = "CreateSkillCreature",
  Location = T.RT_1037,
  UseRelativeOffset = true,
  UseSaveLoc = "Fire2"
}
T.RT_1052 = {
  CreatureId = 850515,
  Function = "CreateSkillCreature",
  Location = T.RT_1037,
  UseRelativeOffset = true,
  UseSaveLoc = "Fire3"
}
T.RT_1053 = {
  CreatureId = 850515,
  Function = "CreateSkillCreature",
  Location = T.RT_1037,
  UseRelativeOffset = true,
  UseSaveLoc = "Fire4"
}
T.RT_1054 = {
  [1] = T.RT_1049,
  [2] = T.RT_1050,
  [3] = T.RT_1051,
  [4] = T.RT_1052,
  [5] = T.RT_1053
}
T.RT_1055 = {
  [1] = T.RT_16,
  [2] = T.RT_758,
  [3] = T.RT_1031
}
T.RT_1056 = {
  CauseHit = "BossLianhuo_Effect850507",
  Function = "GrabHit"
}
T.RT_1057 = {
  [1] = T.RT_1056,
  [2] = T.RT_498
}
T.RT_1058 = {
  "hit2",
  "hit4",
  "hit6",
  "hit8",
  "hit10",
  "hit12"
}
T.RT_1059 = {
  CreatureId = 850504,
  Function = "CreateSkillCreature"
}
T.RT_1060 = {
  [1] = T.RT_1059
}
T.RT_1061 = {
  Function = "PlaySE",
  MeleeHitLevel = "Heavy",
  SEId = 503
}
T.RT_1062 = {
  [1] = T.RT_1045,
  [2] = T.RT_758,
  [3] = T.RT_1061
}
T.RT_1063 = {
  "hit3",
  "hit5",
  "hit7",
  "hit9",
  "hit11",
  "hit13"
}
T.RT_1064 = {
  CreatureId = 850504,
  Function = "RemoveSkillCreature"
}
T.RT_1065 = {
  [1] = T.RT_1064
}
T.RT_1066 = {"hit14"}
T.RT_1067 = {
  CreatureId = 850505,
  Function = "CreateSkillCreature"
}
T.RT_1068 = {
  [1] = T.RT_1067
}
T.RT_1069 = {"hit16"}
T.RT_1070 = {"hit17"}
T.RT_1071 = {
  [1] = T.RT_995
}
T.RT_1072 = {
  Function = "CameraRelock"
}
T.RT_1073 = {"hit20", "hit24"}
T.RT_1074 = {
  Distance = 600,
  MaxNum = 3,
  Radius = 700
}
T.RT_1075 = {
  Function = "EffectFunction",
  FunctionName = "RandomAreaLocation",
  Vars = T.RT_1074
}
T.RT_1076 = {
  [1] = T.RT_1075
}
T.RT_1077 = {"hit21", "hit25"}
T.RT_1078 = {
  CreatureId = 850509,
  Function = "CreateSkillCreature",
  UseSaveLoc = "1"
}
T.RT_1079 = {
  CreatureId = 850509,
  Function = "CreateSkillCreature",
  UseSaveLoc = "2"
}
T.RT_1080 = {
  CreatureId = 850509,
  Function = "CreateSkillCreature",
  UseSaveLoc = "3"
}
T.RT_1081 = {
  [1] = T.RT_1078,
  [2] = T.RT_1079,
  [3] = T.RT_1080
}
T.RT_1082 = {"hit19", "hit23"}
T.RT_1083 = {
  CreatureId = 850509,
  Function = "CreateSkillCreature",
  UseSaveLoc = ""
}
T.RT_1084 = {
  [1] = T.RT_1083
}
T.RT_1085 = {
  BuffId = 6000205,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_1086 = {"hit26"}
T.RT_1087 = {BuffId = 6000205, Function = "RemoveBuff"}
T.RT_1088 = {
  [1] = T.RT_985,
  [2] = T.RT_1023
}
T.RT_1089 = {
  [1] = T.RT_7,
  [2] = T.RT_758,
  [3] = T.RT_1023
}
T.RT_1090 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.4
}
T.RT_1091 = {
  [1] = T.RT_1090,
  [2] = T.RT_681,
  [3] = T.RT_1023
}
T.RT_1092 = {"hit24"}
T.RT_1093 = {
  CreatureId = 850510,
  Function = "CreateSkillCreature"
}
T.RT_1094 = {
  [1] = T.RT_1093
}
T.RT_1095 = {
  CauseHit = "LightHit_200",
  Function = "CutToughness",
  Value = 10
}
T.RT_1096 = {
  BuffId = 6000209,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_1097 = {BuffId = 6000209, Function = "RemoveBuff"}
T.RT_1098 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 0.4
}
T.RT_1099 = {Function = "PlaySE", SEId = 850601}
T.RT_1100 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_833,
  Function = "Damage",
  Rate = 1.5
}
T.RT_1101 = {
  CauseHit = "HitFly_XY600Z300",
  Function = "CutToughness",
  Value = 100
}
T.RT_1102 = {
  [1] = T.RT_1100,
  [2] = T.RT_1099,
  [3] = T.RT_72,
  [4] = T.RT_38,
  [5] = T.RT_1101
}
T.RT_1103 = {"hit3", "hit4"}
T.RT_1104 = {
  CauseHit = "LightHit_200",
  Function = "CutToughness"
}
T.RT_1105 = {Function = "PlaySE", SEId = 850916}
T.RT_1106 = {
  [1] = T.RT_16,
  [2] = T.RT_17,
  [3] = T.RT_1105
}
T.RT_1107 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.9
}
T.RT_1108 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.9
}
T.RT_1109 = {
  [1] = T.RT_1108,
  [2] = T.RT_17,
  [3] = T.RT_1105
}
T.RT_1110 = {
  FXId = 850923,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_1111 = {
  [1] = T.RT_1110
}
T.RT_1112 = {
  Falloff = 0.1,
  Function = "CameraShake",
  IsSceneCameraShake = true,
  OuterRadius = 2000,
  ShakeClass = "BP_Camera_BossTuosi_Burst"
}
T.RT_1113 = {Function = "PlaySE", SEId = 850919}
T.RT_1114 = {
  CauseHit = "HitFly_XY2000Z1000",
  Function = "CutToughness"
}
T.RT_1115 = {Function = "PlaySE", SEId = 850920}
T.RT_1116 = {
  CantLockTime = 13,
  Function = "CameraUnlock"
}
T.RT_1117 = {FXId = 850903, Function = "PlayFX"}
T.RT_1118 = {Function = "PlaySE", SEId = 851003}
T.RT_1119 = {
  BuffId = 851001,
  Function = "AddBuff",
  LastTime = 5
}
T.RT_1120 = {Function = "PlaySE", SEId = 851004}
T.RT_1121 = {
  [1] = T.RT_16,
  [2] = T.RT_1119,
  [3] = T.RT_620,
  [4] = T.RT_1120
}
T.RT_1122 = {
  [1] = T.RT_16,
  [2] = T.RT_1119,
  [3] = T.RT_684,
  [4] = T.RT_1120
}
T.RT_1123 = {
  [1] = T.RT_1119
}
T.RT_1124 = {
  ATK = 1,
  DEF = 0,
  MaxHp = 0.06
}
T.RT_1125 = {Function = "PlaySE", SEId = 851009}
T.RT_1126 = {Function = "PlaySE", SEId = 851010}
T.RT_1127 = {
  [1] = T.RT_16,
  [2] = T.RT_10,
  [3] = T.RT_1125,
  [4] = T.RT_1126
}
T.RT_1128 = {
  DanmakuTemplateId = 851002,
  Duration = 15,
  Function = "CreateDanmaku"
}
T.RT_1129 = {
  [1] = T.RT_1128
}
T.RT_1130 = {Function = "PlaySE", SEId = 851012}
T.RT_1131 = {
  CantLockTime = 18,
  Function = "CameraUnlock"
}
T.RT_1132 = {Function = "PlaySE", SEId = 851016}
T.RT_1133 = {
  DanmakuTemplateId = 851004,
  Duration = 20,
  Function = "CreateDanmaku"
}
T.RT_1134 = {
  [1] = T.RT_1133
}
T.RT_1135 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0901"
}
T.RT_1136 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0902"
}
T.RT_1137 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0903"
}
T.RT_1138 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0904"
}
T.RT_1139 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0905"
}
T.RT_1140 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0906"
}
T.RT_1141 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0907"
}
T.RT_1142 = {
  CreatureId = 851007,
  Function = "CreateSkillCreature",
  UseSaveLoc = "Skill0908"
}
T.RT_1143 = {
  CauseHit = "LightHit_100",
  Function = "CutToughness"
}
T.RT_1144 = {
  [1] = T.RT_16,
  [2] = T.RT_10,
  [3] = T.RT_1126
}
T.RT_1145 = {"hit9"}
T.RT_1146 = {
  BuffId = 851101,
  Function = "AddBuff",
  LastTime = 10
}
T.RT_1147 = {
  [1] = T.RT_16,
  [2] = T.RT_1104,
  [3] = T.RT_1146
}
T.RT_1148 = {
  [1] = T.RT_16,
  [2] = T.RT_1104
}
T.RT_1149 = {
  CreatureId = 851108,
  Function = "CreateSkillCreature",
  UseSaveLoc = "IceRingRight"
}
T.RT_1150 = {
  ATK = 1,
  DEF = 0,
  MaxHp = 0.02
}
T.RT_1151 = {Function = "PlaySE", SEId = 851202}
T.RT_1152 = {
  CauseHit = "BossLinen_Skill06",
  Function = "CutToughness",
  Value = 100
}
T.RT_1153 = {
  CreatureId = 851208,
  Function = "CreateSkillCreature"
}
T.RT_1154 = {
  [1] = T.RT_1153,
  [2] = T.RT_1153,
  [3] = T.RT_1153,
  [4] = T.RT_1153,
  [5] = T.RT_1153,
  [6] = T.RT_1153
}
T.RT_1155 = {FXId = 851212, Function = "PlayFX"}
T.RT_1156 = {Function = "PlaySE", SEId = 851201}
T.RT_1157 = {
  CreatureId = 851203,
  Delay = 0.167,
  Function = "CreateSkillCreature"
}
T.RT_1158 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 30
}
T.RT_1159 = {FXId = 851205, Function = "PlayFX"}
T.RT_1160 = {
  FXId = 851204,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_1161 = {
  ATK = 1,
  DEF = 1,
  MaxHp = 0.007
}
T.RT_1162 = {
  [1] = T.RT_16,
  [2] = T.RT_1152,
  [3] = T.RT_1156
}
T.RT_1163 = {
  CauseHit = "BossLinen_Skill07",
  Function = "CutToughness",
  Value = 50
}
T.RT_1164 = {
  BuffId = 851201,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_1165 = {Function = "AddTnToMax"}
T.RT_1166 = {
  [1] = T.RT_1164,
  [2] = T.RT_1165
}
T.RT_1167 = {
  ATK = 1,
  DEF = 1,
  MaxHp = 0.01
}
T.RT_1168 = {
  ATK = 1,
  DEF = 1,
  MaxHp = 0.02
}
T.RT_1169 = {
  [1] = T.RT_7,
  [2] = T.RT_1152,
  [3] = T.RT_1156
}
T.RT_1170 = {
  BaseAttr = "ATK",
  DamageTag = T.RT_339,
  Function = "Damage",
  Rate = 0.6
}
T.RT_1171 = {
  CreatureId = 8512908,
  Function = "CreateSkillCreature"
}
T.RT_1172 = {
  [1] = T.RT_1171,
  [2] = T.RT_1171,
  [3] = T.RT_1171,
  [4] = T.RT_1171,
  [5] = T.RT_1171,
  [6] = T.RT_1171
}
T.RT_1173 = {
  CreatureId = 8512903,
  Delay = 0.167,
  Function = "CreateSkillCreature"
}
T.RT_1174 = {
  BaseAttr = "MaxHp",
  BaseChar = "Target",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 0.1
}
T.RT_1175 = {
  [1] = T.RT_1174
}
T.RT_1176 = {Function = "PlaySE", SEId = 851301}
T.RT_1177 = {
  -8.89,
  153.32,
  50
}
T.RT_1178 = {
  CreatureId = 851302,
  Function = "CreateSkillCreature",
  Location = T.RT_1177
}
T.RT_1179 = {
  [1] = T.RT_1178
}
T.RT_1180 = {
  FXId = 851303,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1181 = {
  FXId = 851303,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_1182 = {
  [1] = T.RT_1181
}
T.RT_1183 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End1",
  UseSaveLoc = "StartCenter"
}
T.RT_1184 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End2",
  UseSaveLoc = "StartCenter"
}
T.RT_1185 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End3",
  UseSaveLoc = "StartCenter"
}
T.RT_1186 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End4",
  UseSaveLoc = "StartCenter"
}
T.RT_1187 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End5",
  UseSaveLoc = "StartCenter"
}
T.RT_1188 = {
  CreatureId = 851304,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "End6",
  UseSaveLoc = "StartCenter"
}
T.RT_1189 = {
  BaseChar = "Self",
  Function = "PlaySE",
  SEId = 851307
}
T.RT_1190 = {Function = "PlaySE", SEId = 851309}
T.RT_1191 = {FXId = 851311, Function = "PlayFX"}
T.RT_1192 = {
  [1] = T.RT_1191
}
T.RT_1193 = {
  Function = "EffectFunction",
  FunctionName = "Mon_BossShenpan_Skill03BulletLoc"
}
T.RT_1194 = {
  CreatureId = 851402,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "Skill03Right01"
}
T.RT_1195 = {
  CreatureId = 851411,
  Delay = 0.3,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "Skill03Right02"
}
T.RT_1196 = {
  CreatureId = 851403,
  Delay = 0.1,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "Skill03Left01"
}
T.RT_1197 = {
  CreatureId = 851412,
  Delay = 0.2,
  Function = "CreateSkillCreature",
  SetSavelocAsTarget = "Skill03Left02"
}
T.RT_1198 = {
  [1] = T.RT_1193,
  [2] = T.RT_1194,
  [3] = T.RT_1195,
  [4] = T.RT_1196,
  [5] = T.RT_1197
}
T.RT_1199 = {
  CauseHit = "LightHit_400",
  Function = "CutToughness"
}
T.RT_1200 = {Function = "PlaySE", SEId = 851408}
T.RT_1201 = {Function = "PlaySE", SEId = 851519}
T.RT_1202 = {
  [1] = T.RT_3,
  [2] = T.RT_10,
  [3] = T.RT_660,
  [4] = T.RT_1201
}
T.RT_1203 = {Function = "PlaySE", SEId = 851507}
T.RT_1204 = {
  0,
  175,
  455
}
T.RT_1205 = {FXId = 851504, Function = "PlayFX"}
T.RT_1206 = {
  Function = "EffectFunction",
  FunctionName = "Mon_BossJushi_Skill08Bullet"
}
T.RT_1207 = {
  BoneName = "ShoulderLaserR2",
  DanmakuTemplateId = 851506,
  Duration = 2,
  Function = "CreateDanmaku"
}
T.RT_1208 = {
  BoneName = "ShoulderLaserL2",
  DanmakuTemplateId = 851506,
  Duration = 2,
  Function = "CreateDanmaku"
}
T.RT_1209 = {
  FXId = 851510,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1210 = {
  [1] = T.RT_3,
  [2] = T.RT_10,
  [3] = T.RT_660
}
T.RT_1211 = {
  [1] = T.RT_757,
  [2] = T.RT_3,
  [3] = T.RT_660
}
T.RT_1212 = {
  [1] = T.RT_831,
  [2] = T.RT_10,
  [3] = T.RT_660
}
T.RT_1213 = {Function = "PlaySE", SEId = 851701}
T.RT_1214 = {
  [1] = T.RT_3,
  [2] = T.RT_1143,
  [3] = T.RT_1213
}
T.RT_1215 = {Function = "PlaySE", SEId = 851702}
T.RT_1216 = {
  [1] = T.RT_783,
  [2] = T.RT_1104,
  [3] = T.RT_1213
}
T.RT_1217 = {
  [1] = T.RT_783,
  [2] = T.RT_757,
  [3] = T.RT_1215
}
T.RT_1218 = {
  [1] = T.RT_3,
  [2] = T.RT_757
}
T.RT_1219 = {
  [1] = T.RT_16,
  [2] = T.RT_10
}
T.RT_1220 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "1"
}
T.RT_1221 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "2"
}
T.RT_1222 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "5"
}
T.RT_1223 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "3"
}
T.RT_1224 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "6"
}
T.RT_1225 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "9"
}
T.RT_1226 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "4"
}
T.RT_1227 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "7"
}
T.RT_1228 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "10"
}
T.RT_1229 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "13"
}
T.RT_1230 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "8"
}
T.RT_1231 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "11"
}
T.RT_1232 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "14"
}
T.RT_1233 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "12"
}
T.RT_1234 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "15"
}
T.RT_1235 = {
  CreatureId = 851805,
  Function = "CreateSkillCreature",
  UseSaveLoc = "16"
}
T.RT_1236 = {
  FXId = 851901,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1237 = {
  [1] = T.RT_3,
  [2] = T.RT_10,
  [3] = T.RT_1236
}
T.RT_1238 = {
  CauseHit = "HitFly_XY0Z300",
  Function = "CutToughness"
}
T.RT_1239 = {FXId = 900406, Function = "PlayFX"}
T.RT_1240 = {
  CreatureId = 851903,
  Function = "CreateSkillCreature",
  UseSaveLoc = "LFront"
}
T.RT_1241 = {FXId = 851902, Function = "PlayFX"}
T.RT_1242 = {
  [1] = T.RT_22,
  [2] = T.RT_10,
  [3] = T.RT_1241
}
T.RT_1243 = {
  [1] = T.RT_703
}
T.RT_1244 = {
  Function = "CreateUnit",
  MaxSummonCount = 2,
  SingleSummonCount = 1,
  UnitId = 8519005,
  UnitType = "Monster",
  UseSaveLoc = "Skill05L"
}
T.RT_1245 = {
  Function = "CreateUnit",
  MaxSummonCount = 2,
  SingleSummonCount = 1,
  UnitId = 8519005,
  UnitType = "Monster",
  UseSaveLoc = "Skill05M"
}
T.RT_1246 = {
  CreatureId = 851915,
  Function = "CreateSkillCreature",
  UseSaveLoc = "LFront"
}
T.RT_1247 = {
  Function = "CreateUnit",
  MaxSummonCount = 2,
  SingleSummonCount = 1,
  UnitId = 8519005,
  UnitType = "Monster",
  UseSaveLoc = "Skill05R"
}
T.RT_1248 = {
  CreatureId = 851919,
  Function = "CreateSkillCreature",
  UseSaveLoc = "RFront"
}
T.RT_1249 = {
  CreatureId = 851920,
  Function = "CreateSkillCreature",
  UseSaveLoc = "RFront"
}
T.RT_1250 = {Hp = 1, MaxHp = 0.03}
T.RT_1251 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 3,
  SingleSummonCount = 1,
  UnitId = 8519009,
  UnitType = "Monster",
  UseSaveLoc = "8519302"
}
T.RT_1252 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519310"
}
T.RT_1253 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 3,
  SingleSummonCount = 1,
  UnitId = 8519009,
  UnitType = "Monster",
  UseSaveLoc = "8519304"
}
T.RT_1254 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519301"
}
T.RT_1255 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519303"
}
T.RT_1256 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519305"
}
T.RT_1257 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519307"
}
T.RT_1258 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519308"
}
T.RT_1259 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519309"
}
T.RT_1260 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519302"
}
T.RT_1261 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519304"
}
T.RT_1262 = {
  AttrRates = T.RT_1250,
  Function = "CreateUnit",
  MaxSummonCount = 9,
  SingleSummonCount = 1,
  UnitId = 8519010,
  UnitType = "Monster",
  UseSaveLoc = "8519306"
}
T.RT_1263 = {
  [1] = T.RT_16,
  [2] = T.RT_10,
  [3] = T.RT_809
}
T.RT_1264 = {
  CauseHit = "HitFly_XY0Z800",
  Function = "CutToughness"
}
T.RT_1265 = {
  [1] = T.RT_3,
  [2] = T.RT_1264
}
T.RT_1266 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200502,
  UseBattlePointRotation = 1
}
T.RT_1267 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200520,
  UseBattlePointRotation = 1
}
T.RT_1268 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200503,
  UseBattlePointRotation = 1
}
T.RT_1269 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200504,
  UseBattlePointRotation = 1
}
T.RT_1270 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200505,
  UseBattlePointRotation = 1
}
T.RT_1271 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200506,
  UseBattlePointRotation = 1
}
T.RT_1272 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200508,
  UseBattlePointRotation = 1
}
T.RT_1273 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200509,
  UseBattlePointRotation = 1
}
T.RT_1274 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200510,
  UseBattlePointRotation = 1
}
T.RT_1275 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200507,
  UseBattlePointRotation = 1
}
T.RT_1276 = {
  [1] = T.RT_3
}
T.RT_1277 = {
  BattlePointID = 85200801,
  Function = "SetSelfLoc",
  TargetCenterLoc = "BattlePoint",
  UseBattlePointRotation = 1
}
T.RT_1278 = {
  [1] = T.RT_1277
}
T.RT_1279 = {
  Function = "CreateUnit",
  MaxSummonCount = 3,
  SingleSummonCount = 1,
  UnitId = 8520003,
  UnitType = "Monster",
  UseSaveLoc = "85200902"
}
T.RT_1280 = {
  Function = "CreateUnit",
  MaxSummonCount = 3,
  SingleSummonCount = 1,
  UnitId = 8520003,
  UnitType = "Monster",
  UseSaveLoc = "85200903"
}
T.RT_1281 = {
  Function = "CreateUnit",
  MaxSummonCount = 3,
  SingleSummonCount = 1,
  UnitId = 8520003,
  UnitType = "Monster",
  UseSaveLoc = "85200901"
}
T.RT_1282 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200802,
  UseBattlePointRotation = 1
}
T.RT_1283 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200820,
  UseBattlePointRotation = 1
}
T.RT_1284 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200803,
  UseBattlePointRotation = 1
}
T.RT_1285 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200804,
  UseBattlePointRotation = 1
}
T.RT_1286 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200805,
  UseBattlePointRotation = 1
}
T.RT_1287 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200806,
  UseBattlePointRotation = 1
}
T.RT_1288 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200808,
  UseBattlePointRotation = 1
}
T.RT_1289 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200809,
  UseBattlePointRotation = 1
}
T.RT_1290 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200810,
  UseBattlePointRotation = 1
}
T.RT_1291 = {
  CreatureId = 852008,
  Function = "CreateSkillCreature",
  UseBattlePointID = 85200807,
  UseBattlePointRotation = 1
}
T.RT_1292 = {
  0,
  0,
  -130
}
T.RT_1293 = {FXId = 900038, Function = "PlayFX"}
T.RT_1294 = {
  [1] = T.RT_3,
  [2] = T.RT_681,
  [3] = T.RT_1293
}
T.RT_1295 = {
  [1] = T.RT_3,
  [2] = T.RT_681
}
T.RT_1296 = {
  0,
  0,
  -120
}
T.RT_1297 = {
  Function = "EffectFunction",
  FunctionName = "Mon_BossTuisheng_Skill02Hit1"
}
T.RT_1298 = {
  [1] = T.RT_3,
  [2] = T.RT_684,
  [3] = T.RT_1297
}
T.RT_1299 = {
  CauseHit = "HitFly_XY300Z800",
  Function = "CutToughness"
}
T.RT_1300 = {
  [1] = T.RT_3,
  [2] = T.RT_1299
}
T.RT_1301 = {
  [1] = T.RT_7,
  [2] = T.RT_4,
  [3] = T.RT_1299
}
T.RT_1302 = {
  FXId = 852402,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1303 = {
  [1] = T.RT_33,
  [2] = T.RT_1302
}
T.RT_1304 = {
  Function = "EffectFunction",
  FunctionName = "Mon_BossHengmeng_Skill03GetLoc"
}
T.RT_1305 = {
  0,
  0,
  400
}
T.RT_1306 = {
  CreatureId = 852404,
  Function = "CreateSkillCreature",
  Location = T.RT_1305,
  UseSaveLoc = "Skill03Loc1"
}
T.RT_1307 = {
  [1] = T.RT_3,
  [2] = T.RT_1302,
  [3] = T.RT_1299
}
T.RT_1308 = {
  CauseHit = "HitFly_XY600Z1000",
  Function = "CutToughness",
  Value = 150
}
T.RT_1309 = {
  0,
  0,
  1900
}
T.RT_1310 = {
  CreatureId = 900001,
  Function = "CreateSkillCreature",
  Location = T.RT_1309,
  UseSaveLoc = ""
}
T.RT_1311 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0.01
}
T.RT_1312 = {
  BaseAttr = "MaxHp",
  BaseChar = "Target",
  DamageType = "Default",
  Function = "Damage",
  Rate = 0.05
}
T.RT_1313 = {
  BuffId = 5000020,
  Function = "AddBuff",
  LastTime = 1.3
}
T.RT_1314 = {
  BaseAttr = "MaxHp",
  BaseChar = "Target",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 0.35
}
T.RT_1315 = {
  BaseChar = "Target",
  FXId = 900074,
  Function = "PlayFX",
  IsAttached = true
}
T.RT_1316 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 300
}
T.RT_1317 = {
  BaseAttr = "ATK",
  DamageType = "TrueDamage",
  Function = "Damage",
  Rate = 10
}
T.RT_1318 = {
  CauseHit = "HitFly_XY800Z1000",
  Function = "CutToughness",
  Value = 300
}
T.RT_1319 = {
  [1] = T.RT_1311
}
T.RT_1320 = {Function = "PlaySE", SEId = 111}
T.RT_1321 = {
  FXId = 900062,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1322 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 0,
  Value = 1
}
T.RT_1323 = {
  CauseHit = "HitFly_XY600Z1000",
  Function = "CutToughness"
}
T.RT_1324 = {
  [1] = T.RT_1322,
  [2] = T.RT_1323
}
T.RT_1325 = {
  CauseHit = "HitFly_XY600Z1000",
  Function = "CutToughness",
  Value = 500
}
T.RT_1326 = {
  BaseAttr = "ATK",
  Function = "Damage",
  Rate = 1.65
}
T.RT_1327 = {Function = "PlaySE", SEId = 900101}
T.RT_1328 = {Function = "PlaySE", SEId = 900201}
T.RT_1329 = {
  Function = "PlaySE",
  MeleeHitLevel = "light",
  SEId = 502
}
T.RT_1330 = {
  [1] = T.RT_23,
  [2] = T.RT_660,
  [3] = T.RT_39,
  [4] = T.RT_1329
}
T.RT_1331 = {
  Function = "PlaySE",
  MeleeHitLevel = "light",
  SEId = 504
}
T.RT_1332 = {
  CreatureId = 900701,
  Function = "CreateSkillCreature"
}
T.RT_1333 = {
  [1] = T.RT_1332
}
T.RT_1334 = {
  FXId = 900702,
  Function = "PlayFX",
  Overlap = true
}
T.RT_1335 = {Function = "PlaySE", SEId = 900701}
T.RT_1336 = {
  [1] = T.RT_3,
  [2] = T.RT_1334,
  [3] = T.RT_1335
}
T.RT_1337 = {
  FXId = 900702,
  Function = "PlayFX",
  NormalToHit = true,
  Overlap = true
}
T.RT_1338 = {
  [1] = T.RT_1337
}
T.RT_1339 = {
  CreatureId = 950004,
  Function = "CreateSkillCreature",
  Location = T.RT_419
}
T.RT_1340 = {
  CreatureId = 950011,
  Function = "CreateSkillCreature",
  Location = T.RT_419
}
T.RT_1341 = {Function = "PlaySE", SEId = 950102}
T.RT_1342 = {
  [1] = T.RT_16,
  [2] = T.RT_4,
  [3] = T.RT_1341
}
T.RT_1343 = {
  CauseHit = "HitFly_XY200Z300",
  Function = "CutToughness",
  Value = 1
}
T.RT_1344 = {
  [1] = T.RT_3,
  [2] = T.RT_1343
}
T.RT_1345 = {
  CauseHit = "LightHit",
  Function = "CutToughness",
  Value = 1
}
T.RT_1346 = {Function = "PlaySE", SEId = 950701}
T.RT_1347 = {
  [1] = T.RT_3,
  [2] = T.RT_4,
  [3] = T.RT_1346
}
T.RT_1348 = {Function = "PlaySE", SEId = 951001}
T.RT_1349 = {
  [1] = T.RT_3,
  [2] = T.RT_4,
  [3] = T.RT_1348
}
T.RT_1350 = {Function = "PlaySE", SEId = 980101}
T.RT_1351 = {
  [1] = T.RT_16,
  [2] = T.RT_10,
  [3] = T.RT_1350
}
T.RT_1352 = {Function = "PlaySE", SEId = 980201}
T.RT_1353 = {
  [1] = T.RT_659,
  [2] = T.RT_1104,
  [3] = T.RT_1352
}
T.RT_1354 = {
  [1] = T.RT_659,
  [2] = T.RT_1143,
  [3] = T.RT_1352
}
T.RT_1355 = {Function = "PlaySE", SEId = 980301}
T.RT_1356 = {
  BuffId = 980501,
  Function = "AddBuff",
  LastTime = -1
}
T.RT_1357 = {
  [1] = T.RT_1356
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SkillEffects", {
  [4] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "HitWall",
        PassiveEffectId = 1
      }
    },
    TaskId = 4
  },
  [5] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 5,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 5
  },
  [6] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 5,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 6
  },
  [10] = {TaskId = 10},
  [11] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.05,
        Value = 15
      },
      [2] = T.RT_95
    },
    TaskId = 11
  },
  [12] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_226,
    TaskId = 12
  },
  [13] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {FXId = 20, Function = "PlayFX"}
    },
    TaskId = 13
  },
  [20] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 301,
        Function = "AddBuff",
        LastTime = 6
      },
      [2] = {
        BuffId = 305,
        Function = "AddBuff",
        LastTime = 4
      }
    },
    TaskId = 20
  },
  [21] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        CauseHit = "HitFly_XY800Z400",
        ForceHit = true,
        Function = "CutToughness",
        Value = 70
      }
    },
    TaskId = 21
  },
  [23] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_368
    },
    TaskId = 23
  },
  [24] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 24
  },
  [25] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_127,
      [2] = T.RT_81
    },
    TaskId = 25
  },
  [26] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ClearHitTargets"
      }
    },
    TaskId = 26
  },
  [27] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_122
    },
    TaskId = 27
  },
  [30] = {
    NotifyName = T.RT_2,
    TargetFilter = "CondemnTarget",
    TaskEffects = {
      [1] = {
        CantLockTime = 4,
        Function = "PlayerCameraUnlock"
      },
      [2] = {
        Function = "SetToCondemnLoc"
      }
    },
    TaskId = 30
  },
  [31] = {
    NotifyName = T.RT_9,
    TargetFilter = "CondemnTarget",
    TaskEffects = {
      [1] = {
        Function = "StartTargetCondemn"
      }
    },
    TaskId = 31
  },
  [32] = {
    HatredIncrement = 40,
    NotifyName = T.RT_12,
    TargetFilter = "CondemnTarget",
    TaskEffects = {
      [1] = {
        BaseAttr = "SkillIntensity",
        Condition = 301,
        DamageTag = T.RT_37,
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = "$0.25*math.exp(0.0002*Source:GetAttr('Level')^2+0.0868*Source:GetAttr('Level')+7.0885)$"
      },
      [2] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        Condition = 300,
        DamageTag = T.RT_37,
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.05
      },
      [3] = {
        BaseChar = "Target",
        FXId = 31,
        Function = "PlayFX"
      },
      [4] = {
        BaseChar = "Target",
        FXId = 33,
        Function = "PlayFX"
      }
    },
    TaskId = 32
  },
  [33] = {
    HatredIncrement = 40,
    NotifyName = T.RT_13,
    TargetFilter = "CondemnTarget",
    TaskEffects = {
      [1] = {
        BaseAttr = "SkillIntensity",
        Condition = 301,
        DamageTag = T.RT_37,
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = "$0.75*math.exp(0.0002*Source:GetAttr('Level')^2+0.0868*Source:GetAttr('Level')+7.0885)$"
      },
      [2] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        Condition = 300,
        DamageTag = T.RT_37,
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.15
      },
      [3] = {
        BaseChar = "Target",
        FXId = 32,
        Function = "PlayFX"
      }
    },
    TaskId = 33
  },
  [41] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {ClearCount = 1, Function = "HitCount"}
    },
    TaskId = 41
  },
  [42] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_600,
    TaskId = 42
  },
  [43] = {
    TargetFilter = "RootSource",
    TaskEffects = T.RT_600,
    TaskId = 43
  },
  [101] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 101,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          1000
        }
      }
    },
    TaskId = 101
  },
  [102] = {
    TargetFilter = "Char_Sphere_Small_Frd",
    TaskEffects = {
      [1] = {
        FXId = 247,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RandomRotation = T.RT_126
      },
      [2] = {
        BuffId = 5000202,
        Function = "AddBuff",
        LastTime = 1
      }
    },
    TaskId = 102
  },
  [103] = {
    TargetFilter = "Char_Sphere_Small_Frd",
    TaskEffects = {
      [1] = {
        BaseChar = "Self",
        FXId = 242,
        Function = "PlayFX"
      },
      [2] = {
        BuffId = 5000205,
        Function = "AddBuff",
        LastTime = 2
      },
      [3] = {BuffId = 5000204, Function = "RemoveBuff"}
    },
    TaskId = 103
  },
  [104] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 102,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 104
  },
  [105] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CauseHit = "HitFly_XY600Z600",
        Function = "CutToughness",
        Value = 100
      },
      [2] = T.RT_177,
      [3] = {Function = "PlaySE", SEId = 2018}
    },
    TaskId = 105
  },
  [106] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 102,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 106
  },
  [1502] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_247,
        DamageType = "Wind",
        Function = "Damage",
        Rate = 2.56
      },
      [2] = T.RT_248,
      [3] = T.RT_249,
      [4] = {
        Delay = 0.05,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = T.RT_250
    },
    TaskId = 1502
  },
  [1513] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_247,
        DamageType = "Smash",
        Function = "Damage",
        Rate = 1.28
      },
      [2] = {
        Delay = 0.1,
        FXId = 15131,
        Function = "PlayFX"
      },
      [3] = {
        CauseHit = "LightHit_100",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 45
      },
      [4] = T.RT_245,
      [5] = T.RT_246,
      [6] = T.RT_316
    },
    TaskId = 1513
  },
  [1525] = {
    TargetFilter = "Char_Cylinder_Large_OtFr",
    TaskEffects = {
      [1] = {
        BaseAttr = "Maxhp",
        BaseChar = "Target",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.03
      }
    },
    TaskId = 1525
  },
  [1922] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        BuffId = 1922,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 1922
  },
  [1952] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 1952,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 1952
  },
  [3311] = {
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = {"Weapon", "Ranged"},
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_553,
      [3] = T.RT_42,
      [4] = {Function = "PlaySE", SEId = 3331102}
    },
    TaskId = 3311
  },
  [3322] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_527
    },
    TaskId = 3322
  },
  [3332] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_430,
    TaskId = 3332
  },
  [3343] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "HpConsume",
        Function = "Damage",
        Rate = 0.1
      }
    },
    TaskId = 3343
  },
  [3701] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_94,
    TaskId = 3701
  },
  [3702] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        FXId = 43703,
        Function = "PlayFX"
      }
    },
    TaskId = 3702
  },
  [3703] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_247,
        DamageType = "Smash",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_553,
      [3] = T.RT_413
    },
    TaskId = 3703
  },
  [4204] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_94,
    TaskId = 4204
  },
  [10001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = 0.6,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 10001,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 10001
  },
  [10011] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_37,
        Function = "Damage",
        Rate = 7.5
      },
      [2] = T.RT_38,
      [3] = T.RT_39,
      [4] = {
        CauseHit = "LightHit_50",
        Condition = 15,
        Function = "CutToughness",
        Value = 178
      },
      [5] = {Function = "PlaySE", SEId = 10002}
    },
    TaskId = 10011
  },
  [10021] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large_Frd",
    TaskEffects = {
      [1] = {
        BuffId = 96,
        Function = "AddBuff",
        LastTime = 6
      },
      [2] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.2
      },
      [3] = {
        FXId = 113,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 10021
  },
  [10022] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_40,
        Function = "Damage",
        Rate = 7.5
      },
      [2] = T.RT_41,
      [3] = T.RT_42
    },
    TaskId = 10022
  },
  [10101] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        NotRotateWhenHit = true,
        Value = 100
      }
    },
    TaskId = 10101
  },
  [12211] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 2012211,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 12211
  },
  [18010] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ChangeColor",
        PassiveEffectId = 18011
      }
    },
    TaskId = 18010
  },
  [18011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "StartShoot",
        PassiveEffectId = 18011
      }
    },
    TaskId = 18011
  },
  [18012] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 18011,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_325
    },
    TaskId = 18012
  },
  [18013] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 18012,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_325
    },
    TaskId = 18013
  },
  [18014] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 18013,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_325
    },
    TaskId = 18014
  },
  [18015] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_330,
    TaskId = 18015
  },
  [18016] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_334,
    TaskId = 18016
  },
  [18017] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_338,
    TaskId = 18017
  },
  [18018] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_330,
    TaskId = 18018
  },
  [18019] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_334,
    TaskId = 18019
  },
  [18020] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_338,
    TaskId = 18020
  },
  [20111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 20101,
        Function = "CreateSkillCreature",
        Rotation = T.RT_193
      },
      [2] = T.RT_72
    },
    TaskId = 20111
  },
  [20112] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 20102,
        Function = "CreateSkillCreature",
        Rotation = T.RT_142
      },
      [2] = T.RT_72
    },
    TaskId = 20112
  },
  [20113] = {
    NotifyName = T.RT_12,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 20103,
        Function = "CreateSkillCreature",
        Rotation = T.RT_141
      },
      [2] = T.RT_72
    },
    TaskId = 20113
  },
  [20114] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_357,
      [2] = {
        BuffId = 201001,
        Function = "AddBuff",
        LastTime = 8
      },
      [3] = {FXId = 20102, Function = "PlayFX"},
      [4] = T.RT_309
    },
    TaskId = 20114
  },
  [20121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 201002,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 20121
  },
  [30401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_RDChoose1",
    TaskEffects = {
      [1] = {
        CreatureId = 30401,
        Function = "CreateSkillCreature",
        UseBattlePointId = 30400
      },
      [2] = {
        BuffId = 30400012,
        Function = "AddBuff",
        LastTime = 6
      }
    },
    TaskId = 30401
  },
  [30402] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_489,
      [3] = T.RT_497
    },
    TaskId = 30402
  },
  [30403] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_489,
      [3] = T.RT_497
    },
    TaskId = 30403
  },
  [30404] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_489,
      [3] = T.RT_497
    },
    TaskId = 30404
  },
  [30405] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_489,
      [3] = T.RT_497
    },
    TaskId = 30405
  },
  [30406] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 311,
        UnitType = "Monster",
        UseBattlePointId = 3040301
      }
    },
    TaskId = 30406
  },
  [30407] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30402,
        Function = "CreateSkillCreature",
        UseBattlePointId = 30400
      }
    },
    TaskId = 30407
  },
  [30408] = {
    TargetFilter = "BossOnline_Skill04Cylinder1",
    TaskEffects = T.RT_499,
    TaskId = 30408
  },
  [30409] = {
    TargetFilter = "BossOnline_Skill05Damage",
    TaskEffects = T.RT_500,
    TaskId = 30409
  },
  [30410] = {
    TargetFilter = "BossOnline_Skill06Damage",
    TaskEffects = T.RT_500,
    TaskId = 30410
  },
  [30411] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30403,
        Function = "CreateSkillCreature",
        UseBattlePointId = 30400
      }
    },
    TaskId = 30411
  },
  [30412] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30403,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 30412
  },
  [30413] = {
    TargetFilter = "BossOnline_Skill07Damage",
    TaskEffects = T.RT_505,
    TaskId = 30413
  },
  [30414] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040701,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30414
  },
  [30415] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = T.RT_506,
    TaskId = 30415
  },
  [30416] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040702,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30416
  },
  [30417] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040703,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30417
  },
  [30418] = {
    NotifyName = T.RT_13,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040704,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30418
  },
  [30419] = {
    NotifyName = T.RT_404,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040705,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30419
  },
  [30420] = {
    NotifyName = T.RT_507,
    TaskEffects = {
      [1] = {
        CreatureId = 30404,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040706,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30420
  },
  [30421] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30405,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040801,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30421
  },
  [30422] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 30406,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040802,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30422
  },
  [30423] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30407,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3040901,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30423
  },
  [30424] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 30401,
        Duration = 17,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 30424
  },
  [30425] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_504,
      [2] = T.RT_508
    },
    TaskId = 30425
  },
  [30426] = {
    TaskEffects = T.RT_510,
    TaskId = 30426
  },
  [30427] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041001,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 30408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041002,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 30408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041003,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30427
  },
  [30428] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 30409,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041004,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30428
  },
  [30429] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 30409,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041005,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 30409,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041006,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30429
  },
  [30430] = {
    TargetFilter = "BossOnline_Skill10Damage",
    TaskEffects = T.RT_500,
    TaskId = 30430
  },
  [30431] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 312,
        UnitType = "Monster",
        UseBattlePointId = 3040302
      }
    },
    TaskId = 30431
  },
  [30432] = {
    NotifyName = T.RT_511,
    TargetFilter = "Self",
    TaskEffects = T.RT_513,
    TaskId = 30432
  },
  [30433] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041101,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041102,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041103,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041104,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041105,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 30411,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041106,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30433
  },
  [30434] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30410,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041107,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30434
  },
  [30435] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30411,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 30435
  },
  [30436] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30412,
        Function = "CreateSkillCreature",
        UseBattlePointId = 30400
      }
    },
    TaskId = 30436
  },
  [30437] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30412,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 30437
  },
  [30438] = {
    TargetFilter = "BossOnline_Skill02Cylinder1",
    TaskEffects = T.RT_499,
    TaskId = 30438
  },
  [30439] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30413,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30439
  },
  [30440] = {
    TargetFilter = "HatredPlayers",
    TaskEffects = {
      [1] = {
        BuffId = 30400004,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 30440
  },
  [30441] = {
    TargetFilter = "HatredPlayers",
    TaskEffects = {
      [1] = {BuffId = 30400004, Function = "RemoveBuff"}
    },
    TaskId = 30441
  },
  [30442] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 30400,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint"
      }
    },
    TaskId = 30442
  },
  [30443] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 307,
        UnitType = "Monster",
        UseBattlePointId = 3040101
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040102
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040103
      },
      [4] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040104
      },
      [5] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040105
      },
      [6] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040106
      },
      [7] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040107
      },
      [8] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 308,
        UnitType = "Monster",
        UseBattlePointId = 3040108
      }
    },
    TaskId = 30443
  },
  [30446] = {
    TargetFilter = "HatredPlayers",
    TaskEffects = {
      [1] = {
        Function = "SpecificTarget",
        Tag = "HatredShuffle",
        TargetType = "Target"
      },
      [2] = {
        Function = "ShuffleSpecificTarget",
        Tag = "HatredShuffle"
      }
    },
    TaskId = 30446
  },
  [30447] = {
    TargetFilter = "Mon_SPTarget01",
    TaskEffects = T.RT_515,
    TaskId = 30447
  },
  [30448] = {
    TargetFilter = "Mon_SPTarget02",
    TaskEffects = T.RT_517,
    TaskId = 30448
  },
  [30449] = {
    TargetFilter = "Mon_SPTarget03",
    TaskEffects = T.RT_515,
    TaskId = 30449
  },
  [30450] = {
    TargetFilter = "Mon_SPTarget04",
    TaskEffects = T.RT_517,
    TaskId = 30450
  },
  [30451] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill12Cylinder1",
    TaskEffects = T.RT_518,
    TaskId = 30451
  },
  [30452] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_RDChoose1",
    TaskEffects = {
      [1] = {
        CreatureId = 30414,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041301,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 30414,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041302,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 30414,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041303,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 30414,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041304,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 30414,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041305,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 30415,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041301,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 30452
  },
  [30453] = {
    TargetFilter = "BossOnline_Skill13Cylinder1",
    TaskEffects = T.RT_518,
    TaskId = 30453
  },
  [30454] = {
    TargetFilter = "BossOnline_Skill13Cylinder2",
    TaskEffects = T.RT_518,
    TaskId = 30454
  },
  [30455] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_RandomChoosePlayersRepeatableToSPT",
        Vars = {ChooseNum = 3, SPTargetTag = "Repeatable"}
      }
    },
    TaskId = 30455
  },
  [30456] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill15Cylinder1",
    TaskEffects = T.RT_519,
    TaskId = 30456
  },
  [30457] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill16Cylinder1",
    TaskEffects = T.RT_519,
    TaskId = 30457
  },
  [30458] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill16Cylinder1",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_497,
      [3] = T.RT_10
    },
    TaskId = 30458
  },
  [30459] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_520,
      [2] = T.RT_521
    },
    TaskId = 30459
  },
  [30460] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30416,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041701
      }
    },
    TaskId = 30460
  },
  [30461] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30417,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041702
      }
    },
    TaskId = 30461
  },
  [30462] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 30418,
        Function = "CreateSkillCreature",
        UseBattlePointId = 3041703
      }
    },
    TaskId = 30462
  },
  [30463] = {
    TargetFilter = "Mon_Cylinder_300_40_360",
    TaskEffects = T.RT_515,
    TaskId = 30463
  },
  [30464] = {
    TargetFilter = "Mon_Cylinder_300_40_360",
    TaskEffects = T.RT_517,
    TaskId = 30464
  },
  [30465] = {
    TargetFilter = "Mon_Cylinder_300_40_360",
    TaskEffects = {
      [1] = {
        BuffId = 30400010,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 30465
  },
  [30466] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 30400007,
        Function = "AddBuff",
        LastTime = 180
      }
    },
    TaskId = 30466
  },
  [30467] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040101
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040102
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040103
      },
      [4] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040104
      },
      [5] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040105
      },
      [6] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 305,
        UnitType = "Monster",
        UseBattlePointId = 3040106
      }
    },
    TaskId = 30467
  },
  [30468] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040101
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040102
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040103
      },
      [4] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040104
      },
      [5] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040105
      },
      [6] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 306,
        UnitType = "Monster",
        UseBattlePointId = 3040106
      }
    },
    TaskId = 30468
  },
  [30469] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040101
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040102
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040103
      },
      [4] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040104
      },
      [5] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040105
      },
      [6] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310,
        UnitType = "Monster",
        UseBattlePointId = 3040106
      }
    },
    TaskId = 30469
  },
  [30470] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Function = "Heal",
        Rate = 0.001
      },
      [2] = T.RT_522
    },
    TaskId = 30470
  },
  [30471] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30416,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30471
  },
  [30472] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30417,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30472
  },
  [30473] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30418,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30473
  },
  [30474] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30419,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30474
  },
  [30475] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30420,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30475
  },
  [30476] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30421,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30476
  },
  [30477] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 30400016,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 30477
  },
  [30478] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 30400016,
        Function = "RemoveBuff",
        LastTime = -1
      }
    },
    TaskId = 30478
  },
  [30479] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill12Cylinder2",
    TaskEffects = T.RT_518,
    TaskId = 30479
  },
  [30480] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill12Cylinder3",
    TaskEffects = T.RT_518,
    TaskId = 30480
  },
  [30481] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill12Cylinder4",
    TaskEffects = T.RT_518,
    TaskId = 30481
  },
  [30482] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill12Cylinder5",
    TaskEffects = T.RT_518,
    TaskId = 30482
  },
  [30483] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill12Cylinder6",
    TaskEffects = T.RT_518,
    TaskId = 30483
  },
  [30484] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 313,
        UnitType = "Monster",
        UseBattlePointId = 3041701
      }
    },
    TaskId = 30484
  },
  [30485] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 314,
        UnitType = "Monster",
        UseBattlePointId = 3041702
      }
    },
    TaskId = 30485
  },
  [30486] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 315,
        UnitType = "Monster",
        UseBattlePointId = 3041703
      }
    },
    TaskId = 30486
  },
  [30487] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30422,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30487
  },
  [30488] = {
    TargetFilter = "Mon_Sphere_150_360",
    TaskEffects = T.RT_518,
    TaskId = 30488
  },
  [30489] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill14SPTarget01",
    TaskEffects = T.RT_503,
    TaskId = 30489
  },
  [30490] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill14SPTarget02",
    TaskEffects = T.RT_503,
    TaskId = 30490
  },
  [30491] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossOnline_Skill14SPTarget03",
    TaskEffects = T.RT_503,
    TaskId = 30491
  },
  [30492] = {
    TargetFilter = "BossOnline_Skill14Cylinder1",
    TaskEffects = T.RT_518,
    TaskId = 30492
  },
  [30493] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851315,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30493
  },
  [30494] = {
    TaskEffects = {
      [1] = {
        CreatureId = 30424,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 30494
  },
  [30495] = {
    TargetFilter = "Mon_Cylinder_600_40_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.05
      }
    },
    TaskId = 30495
  },
  [30496] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill18Cylinder1",
    TaskEffects = T.RT_523,
    TaskId = 30496
  },
  [30497] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossOnline_Skill19Cylinder1",
    TaskEffects = T.RT_523,
    TaskId = 30497
  },
  [30498] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 16,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 316,
        UnitType = "Monster",
        UseBattlePointId = 30400
      }
    },
    TaskId = 30498
  },
  [30499] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 30425,
        Function = "CreateSkillCreature",
        UseBattlePointId = 30400
      }
    },
    TaskId = 30499
  },
  [40100] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4011,
        Function = "PlayFX"
      }
    },
    TaskId = 40100
  },
  [40101] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_555,
      [2] = {
        Delay = 0.4,
        FXId = 4012,
        Function = "PlayFX"
      },
      [3] = T.RT_556,
      [4] = {
        BuffType = 100,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 40101
  },
  [40200] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4021,
        Function = "PlayFX"
      }
    },
    TaskId = 40200
  },
  [40201] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 402,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 40201
  },
  [40300] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4031,
        Function = "PlayFX"
      }
    },
    TaskId = 40300
  },
  [40301] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        Function = "AddSp",
        SpChange = "#1"
      },
      [2] = {
        BaseChar = "Target",
        Delay = 0.4,
        FXId = 4032,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 40301
  },
  [40400] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4041,
        Function = "PlayFX"
      }
    },
    TaskId = 40400
  },
  [40401] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffType = 12,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      },
      [2] = T.RT_581,
      [3] = {
        BaseChar = "Target",
        Delay = 0.4,
        FXId = 4042,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 40401
  },
  [40500] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4051,
        Function = "PlayFX"
      }
    },
    TaskId = 40500
  },
  [40501] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = T.RT_582,
      [2] = {
        BaseChar = "Target",
        Delay = 0.4,
        FXId = 4052,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 40501
  },
  [40600] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4061,
        Function = "PlayFX"
      }
    },
    TaskId = 40600
  },
  [40601] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        DamageType = "Light",
        Delay = 0.4,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        CauseHit = "HitFly_XY400Z300",
        Delay = 0.4,
        Function = "CutToughness",
        Value = 80
      },
      [3] = {
        Delay = 0.4,
        FXId = 4062,
        Function = "PlayFX"
      },
      [4] = {
        BuffId = 406,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 40601
  },
  [40700] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4071,
        Function = "PlayFX"
      }
    },
    TaskId = 40700
  },
  [40701] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        Delay = 0.4,
        Function = "Damage",
        Rate = "#1"
      }
    },
    TaskId = 40701
  },
  [40702] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CheckRange = 100,
        CheckType = 1,
        Function = "FindTreasure",
        GuideCloseRange = 500,
        GuideDuration = 30
      },
      [2] = {
        CheckRange = 100,
        CheckType = 2,
        Function = "FindTreasure",
        GuideCloseRange = 500,
        GuideDuration = 30
      }
    },
    TaskId = 40702
  },
  [40800] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4081, Function = "PlayFX"}
    },
    TaskId = 40800
  },
  [40801] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 408,
        Function = "AddBuff",
        LastTime = "#1"
      }
    },
    TaskId = 40801
  },
  [40900] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4091,
        Function = "PlayFX"
      }
    },
    TaskId = 40900
  },
  [40901] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 409,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 40901
  },
  [41100] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4111,
        Function = "PlayFX"
      }
    },
    TaskId = 41100
  },
  [41101] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_555,
      [2] = {
        Delay = 0.4,
        FXId = 4112,
        Function = "PlayFX"
      },
      [3] = T.RT_556,
      [4] = {
        BuffId = 411,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 41101
  },
  [41200] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4121,
        Function = "PlayFX"
      }
    },
    TaskId = 41200
  },
  [41201] = {
    ExtraBPFilter = "Common_IsRealSummon",
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 412,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 41201
  },
  [41300] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4131,
        Function = "PlayFX"
      }
    },
    TaskId = 41300
  },
  [41301] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 413,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 41301
  },
  [41302] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        Function = "SpawnDrop",
        UnitId = 1001,
        UnitType = "Drop"
      },
      [2] = {
        Delay = 0.4,
        Function = "SpawnDrop",
        UnitId = 1002,
        UnitType = "Drop"
      },
      [3] = {
        Delay = 0.4,
        Function = "SpawnDrop",
        UnitId = 1003,
        UnitType = "Drop"
      }
    },
    TaskId = 41302
  },
  [41400] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4142,
        Function = "PlayFX"
      }
    },
    TaskId = 41400
  },
  [41401] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = T.RT_581,
      [2] = {
        Delay = 0.4,
        Function = "AddSp",
        SpChange = "#2"
      },
      [3] = {
        BaseChar = "Target",
        Delay = 0.4,
        FXId = 4142,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 41401
  },
  [41500] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4151,
        Function = "PlayFX"
      }
    },
    TaskId = 41500
  },
  [41501] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 415,
        Delay = 0.4,
        Function = "AddBuff",
        LastTime = 15
      },
      [2] = T.RT_582
    },
    TaskId = 41501
  },
  [41600] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.4,
        FXId = 4161,
        Function = "PlayFX"
      }
    },
    TaskId = 41600
  },
  [41601] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        DamageType = "Light",
        Delay = 0.5,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        CauseHit = "HitFly_XY400Z300",
        Delay = 0.5,
        Function = "CutToughness",
        Value = 80
      },
      [3] = {
        Delay = 0.5,
        FXId = 4162,
        Function = "PlayFX"
      },
      [4] = {
        BuffId = 416,
        Delay = 0.5,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 41601
  },
  [41700] = {
    TaskEffects = {
      [1] = {
        CreatureId = 41700,
        Function = "CreateSkillCreature",
        Rotation = {
          30,
          0,
          0
        }
      },
      [2] = {
        CreatureId = 41700,
        Function = "CreateSkillCreature",
        Rotation = {
          30,
          120,
          0
        }
      },
      [3] = {
        CreatureId = 41700,
        Function = "CreateSkillCreature",
        Rotation = {
          30,
          -120,
          0
        }
      }
    },
    TaskId = 41700
  },
  [41701] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_283,
      [3] = {FXId = 4172, Function = "PlayFX"}
    },
    TaskId = 41701
  },
  [42100] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4211, Function = "PlayFX"}
    },
    TaskId = 42100
  },
  [42101] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        DamageType = "Dark",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {FXId = 4112, Function = "PlayFX"},
      [3] = {
        CauseHit = "HitFly_XY400Z300",
        Function = "CutToughness",
        Value = 125
      }
    },
    TaskId = 42101
  },
  [42102] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 421,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42102
  },
  [42200] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4121, Function = "PlayFX"}
    },
    TaskId = 42200
  },
  [42201] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 422,
        Function = "AddBuff",
        LastTime = 12
      },
      [2] = {
        BuffId = 422,
        Condition = 210,
        Function = "AddBuff",
        LastTime = 12
      },
      [3] = {
        BuffId = 422,
        Condition = 211,
        Function = "AddBuff",
        LastTime = 12
      },
      [4] = {
        BuffId = 422,
        Condition = 212,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42201
  },
  [42300] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4231, Function = "PlayFX"}
    },
    TaskId = 42300
  },
  [42301] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        DamageType = "Fire",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {FXId = 4132, Function = "PlayFX"},
      [3] = T.RT_85
    },
    TaskId = 42301
  },
  [42302] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 423,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42302
  },
  [42400] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4241, Function = "PlayFX"}
    },
    TaskId = 42400
  },
  [42401] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = T.RT_93,
      [2] = {
        BuffId = 424,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42401
  },
  [42500] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4251, Function = "PlayFX"}
    },
    TaskId = 42500
  },
  [42501] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 425,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42501
  },
  [42502] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Condition = 415,
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.1
      }
    },
    TaskId = 42502
  },
  [42600] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 4261, Function = "PlayFX"}
    },
    TaskId = 42600
  },
  [42601] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        DamageType = "Light",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {FXId = 4162, Function = "PlayFX"},
      [3] = T.RT_85
    },
    TaskId = 42601
  },
  [42602] = {
    NotifyName = T.RT_9,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 426,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 42602
  },
  [49100] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 49100,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 49100
  },
  [49101] = {
    TargetFilter = "Char_Sphere_Xlarge",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Support",
          "DongGuoWysSkill01"
        },
        DamageType = "Default",
        Function = "Damage",
        Rate = 0
      }
    },
    TaskId = 49101
  },
  [60100] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 60100,
        Function = "CreateSkillCreature",
        Location = T.RT_692
      }
    },
    TaskId = 60100
  },
  [60101] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_693,
      [2] = T.RT_694,
      [3] = T.RT_695
    },
    TaskId = 60101
  },
  [60102] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 60102,
        Function = "CreateSkillCreature",
        Location = T.RT_692
      }
    },
    TaskId = 60102
  },
  [60103] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_696,
      [2] = T.RT_694,
      [3] = T.RT_695
    },
    TaskId = 60103
  },
  [60104] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 4010013,
        Function = "AddBuff",
        LastTime = 4
      }
    },
    TaskId = 60104
  },
  [60105] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_349,
    TaskId = 60105
  },
  [60200] = {
    TaskEffects = T.RT_714,
    TaskId = 60200
  },
  [60201] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_715,
      [2] = T.RT_716,
      [3] = T.RT_717,
      [4] = T.RT_718
    },
    TaskId = 60201
  },
  [60202] = {
    TaskEffects = T.RT_720,
    TaskId = 60202
  },
  [60203] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_554,
        Function = "Damage",
        Rate = 10
      },
      [2] = T.RT_716,
      [3] = T.RT_717,
      [4] = T.RT_718
    },
    TaskId = 60203
  },
  [60204] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 4010014,
        Function = "AddBuff",
        LastTime = 4
      },
      [2] = {
        FXId = 6023,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 60204
  },
  [60205] = {
    TaskEffects = T.RT_714,
    TaskId = 60205
  },
  [60206] = {
    TaskEffects = T.RT_720,
    TaskId = 60206
  },
  [60300] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 60300,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 60300
  },
  [60301] = {
    TaskEffects = {
      [1] = T.RT_721,
      [2] = T.RT_721,
      [3] = T.RT_721
    },
    TaskId = 60301
  },
  [60302] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_715,
      [2] = T.RT_248,
      [3] = {Function = "PlaySE", SEId = 628}
    },
    TaskId = 60302
  },
  [60303] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 60302,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 60303
  },
  [60304] = {
    TaskEffects = {
      [1] = T.RT_722,
      [2] = T.RT_722,
      [3] = T.RT_722
    },
    TaskId = 60304
  },
  [60305] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 4010015,
        Function = "AddBuff",
        LastTime = 4
      }
    },
    TaskId = 60305
  },
  [60400] = {
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_693,
      [2] = {FXId = 6041, Function = "PlayFX"},
      [3] = T.RT_723,
      [4] = T.RT_724
    },
    TaskId = 60400
  },
  [60401] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_696,
      [2] = {FXId = 6043, Function = "PlayFX"},
      [3] = T.RT_723,
      [4] = T.RT_724
    },
    TaskId = 60401
  },
  [60402] = {
    ExtraBPFilter = "Common_IsRealSummon",
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = {
        BuffId = 4010016,
        Function = "AddBuff",
        LastTime = 4
      }
    },
    TaskId = 60402
  },
  [90001] = {
    TaskEffects = {
      [1] = {
        CreatureId = 90001,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_558
    },
    TaskId = 90001
  },
  [90002] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 17
      },
      [2] = T.RT_559,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 90002
  },
  [90003] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        Function = "Damage",
        Rate = 17
      },
      [2] = T.RT_561,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 90003
  },
  [90004] = {
    TaskEffects = {
      [1] = {
        CreatureId = 90002,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 90004
  },
  [90005] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 1.7
      },
      [2] = T.RT_563,
      [3] = T.RT_564
    },
    TaskId = 90005
  },
  [90006] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_565,
    TaskId = 90006
  },
  [90007] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ShootLoopStart",
        PassiveEffectId = 90002
      }
    },
    TaskId = 90007
  },
  [90011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 90011,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_558
    },
    TaskId = 90011
  },
  [90012] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_601,
      [2] = T.RT_559,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 90012
  },
  [90013] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_601,
      [2] = T.RT_561,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 90013
  },
  [90014] = {
    TaskEffects = {
      [1] = {
        CreatureId = 90012,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 90014
  },
  [90015] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        DamageType = "TrueDamage",
        Function = "Damage",
        Value = 20
      },
      [2] = T.RT_563,
      [3] = T.RT_564
    },
    TaskId = 90015
  },
  [90016] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_565,
    TaskId = 90016
  },
  [90017] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ShootLoopStart",
        PassiveEffectId = 90012
      }
    },
    TaskId = 90017
  },
  [110111] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_185,
    TaskId = 110111
  },
  [110112] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_185,
    TaskId = 110112
  },
  [110113] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_12,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_185,
    TaskId = 110113
  },
  [110114] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_13,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_182,
      [3] = T.RT_186,
      [4] = T.RT_184
    },
    TaskId = 110114
  },
  [110121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110101,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 110121
  },
  [110122] = {
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK_Ultra",
        CreatureId = 110141,
        Function = "CreateSkillCreature",
        Location = T.RT_187,
        Rotation = T.RT_187
      }
    },
    TaskId = 110122
  },
  [110131] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 110101, Function = "RemoveBuff"}
    },
    TaskId = 110131
  },
  [110141] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_182,
      [3] = {
        BossValue = 15,
        CauseHit = "HitFly_XY400Z400_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_79,
      [5] = T.RT_184
    },
    TaskId = 110141
  },
  [110142] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_182,
      [3] = {
        BossValue = 20,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_79,
      [5] = T.RT_184
    },
    TaskId = 110142
  },
  [110143] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_182,
      [3] = T.RT_189,
      [4] = T.RT_79,
      [5] = T.RT_184
    },
    TaskId = 110143
  },
  [110144] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_182,
      [3] = {
        BossValue = 30,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_79,
      [5] = T.RT_184
    },
    TaskId = 110144
  },
  [110145] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_182,
      [3] = {
        BossValue = 35,
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 40
      },
      [4] = T.RT_79,
      [5] = T.RT_184
    },
    TaskId = 110145
  },
  [110146] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_192
    },
    TaskId = 110146
  },
  [110147] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_195
    },
    TaskId = 110147
  },
  [110148] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_198
    },
    TaskId = 110148
  },
  [110149] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_200
    },
    TaskId = 110149
  },
  [110150] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_201
    },
    TaskId = 110150
  },
  [110151] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_202,
      [3] = {
        BossValue = 27,
        CauseHit = "HitFly_XY400Z400_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_203
    },
    TaskId = 110151
  },
  [110152] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_202,
      [3] = {
        BossValue = 32,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_203
    },
    TaskId = 110152
  },
  [110153] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_202,
      [3] = {
        BossValue = 37,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_203
    },
    TaskId = 110153
  },
  [110154] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_202,
      [3] = {
        BossValue = 42,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_203
    },
    TaskId = 110154
  },
  [110155] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = T.RT_202,
      [3] = {
        BossValue = 47,
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_203
    },
    TaskId = 110155
  },
  [110161] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_192,
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 110102,
        CreatureId = 110141,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = T.RT_190,
        Rotation = T.RT_191
      }
    },
    TaskId = 110161
  },
  [110162] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_195,
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 110102,
        CreatureId = 110142,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_194
      }
    },
    TaskId = 110162
  },
  [110163] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_198,
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 110102,
        CreatureId = 110143,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = T.RT_196,
        Rotation = T.RT_197
      }
    },
    TaskId = 110163
  },
  [110164] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_200,
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 110102,
        CreatureId = 110144,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = T.RT_187,
        Rotation = T.RT_199
      }
    },
    TaskId = 110164
  },
  [110165] = {
    NotifyName = T.RT_2,
    TargetFilter = "Heitao_Skill02_Search",
    TaskEffects = {
      [1] = T.RT_201,
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 110102,
        CreatureId = 110145,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_126
      }
    },
    TaskId = 110165
  },
  [110211] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "Skill1Aim"
      }
    },
    TaskId = 110211
  },
  [110212] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_205,
      [2] = T.RT_182,
      [3] = T.RT_186
    },
    TaskId = 110212
  },
  [110213] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110201,
        Condition = 71,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 110213
  },
  [110221] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110202,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        AttrRates = T.RT_1,
        AutoAttach = 1,
        Delay = 3,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        UnitId = 110201,
        UnitType = "Monster"
      },
      [3] = {
        FXId = 110221,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      },
      [4] = {
        FXId = 110222,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      },
      [5] = {
        FXId = 110223,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      },
      [6] = {
        FXId = 110224,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      },
      [7] = {
        FXId = 110225,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      }
    },
    TaskId = 110221
  },
  [110222] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_206,
      [2] = {BuffId = 110202, Function = "RemoveBuff"},
      [3] = {Function = "RemoveUnit", UnitId = 110201}
    },
    TaskId = 110222
  },
  [110223] = {
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "FuluoDollAttack",
        PassiveEffectId = 110201
      }
    },
    TaskId = 110223
  },
  [110231] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110231,
        Function = "AddBuff",
        LastTime = 8
      }
    },
    TaskId = 110231
  },
  [110241] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 110202,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FuluoStart"
      }
    },
    TaskId = 110241
  },
  [110242] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_205,
      [2] = T.RT_202,
      [3] = {
        BossValue = 32,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 15
      }
    },
    TaskId = 110242
  },
  [110251] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = {
          "Weapon",
          "Melee",
          "HeavyAttack"
        },
        Function = "Damage",
        Rate = 3
      },
      [2] = {
        BossValue = 29,
        CauseHit = "HitFly_XY600Z400",
        Function = "CutToughness",
        Value = 25
      }
    },
    TaskId = 110251
  },
  [110252] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_62,
      [2] = {
        Delay = 0.3,
        Function = "ExecutePassiveFunction",
        FunctionName = "HeavyAttackEnd",
        PassiveEffectId = 110201
      },
      [3] = T.RT_206,
      [4] = {
        BuffId = 110205,
        Condition = 74,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 110252
  },
  [110311] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle120",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 25,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 25
      },
      [3] = T.RT_207,
      [4] = {
        BuffCount = 5,
        BuffId = 110301,
        Function = "AddBuff",
        LastTime = 8
      },
      [5] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill1AddMsp1",
        PassiveEffectId = 110301
      },
      [6] = {Function = "PlaySE", SEId = 110311}
    },
    TaskId = 110311
  },
  [110312] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110311,
        Function = "AddBuff",
        LastTime = 5
      },
      [2] = T.RT_208,
      [3] = T.RT_209
    },
    TaskId = 110312
  },
  [110313] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        FXId = 110331,
        Function = "PlayFX",
        IsAttached = true
      },
      [2] = {
        Dilation = 0,
        Duration = 0.05,
        Function = "HitStop"
      }
    },
    TaskId = 110313
  },
  [110314] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 25,
        CauseHit = "HitFly_XY1000Z300_F",
        Function = "CutToughness",
        Value = 25
      },
      [3] = T.RT_207,
      [4] = {Function = "PlaySE", SEId = 110305}
    },
    TaskId = 110314
  },
  [110315] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110341,
        Function = "AddBuff",
        LastTime = 5
      },
      [2] = T.RT_208,
      [3] = T.RT_209
    },
    TaskId = 110315
  },
  [110321] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ChangeModel",
        ModelId = 110301
      },
      [2] = {
        BuffId = 110302,
        Function = "AddBuff",
        LastTime = -1
      },
      [3] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "HenshinBuff",
        PassiveEffectId = 110301
      }
    },
    TaskId = 110321
  },
  [110322] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ChangeModel",
        ModelId = 0
      },
      [2] = {BuffId = 110302, Function = "RemoveBuff"},
      [3] = {BuffId = 110303, Function = "RemoveBuff"},
      [4] = {BuffId = 110331, Function = "RemoveBuff"},
      [5] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "HenshinOff",
        PassiveEffectId = 110301
      }
    },
    TaskId = 110322
  },
  [110323] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill2AddMsp",
        PassiveEffectId = 110301
      }
    },
    TaskId = 110323
  },
  [110324] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BossValue = 1,
        CauseHit = "HitFly_XY200Z500",
        Function = "CutToughness",
        Value = 30
      }
    },
    TaskId = 110324
  },
  [110331] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        FXId = 110304,
        Function = "PlayFX",
        FxRotator = {
          200,
          -90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3
      },
      [3] = T.RT_211,
      [4] = T.RT_72,
      [5] = T.RT_212
    },
    TaskId = 110331
  },
  [110332] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        FXId = 110304,
        Function = "PlayFX",
        FxRotator = T.RT_60,
        IsFaceToChar = true,
        MaxHitFXNum = 3
      },
      [3] = T.RT_211,
      [4] = T.RT_72,
      [5] = T.RT_212
    },
    TaskId = 110332
  },
  [110333] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_214,
      [2] = T.RT_215,
      [3] = {
        BossValue = 14,
        CauseHit = "LightHit_Tuosi",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_72,
      [5] = {
        BaseChar = "Self",
        Condition = 100,
        Function = "ExecutePassiveFunction",
        FunctionName = "AddMspOnHit",
        PassiveEffectId = 110301
      },
      [6] = T.RT_212
    },
    TaskId = 110333
  },
  [110334] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_217,
      [2] = T.RT_215,
      [3] = {
        BossValue = 49,
        CauseHit = "HitFly_XY800Z400_F",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_72,
      [5] = {Function = "PlaySE", SEId = 110307}
    },
    TaskId = 110334
  },
  [110341] = {
    NotifyName = T.RT_218,
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 110341
  },
  [110342] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_217,
      [2] = T.RT_215,
      [3] = {
        BossValue = 49,
        CauseHit = "HitFly_XY300Z800",
        Function = "CutToughness",
        Value = 50
      },
      [4] = T.RT_72,
      [5] = {Function = "PlaySE", SEId = 110308}
    },
    TaskId = 110342
  },
  [110351] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        Condition = 110312,
        CreatureId = 110301,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [2] = {
        Condition = 110313,
        CreatureId = 110311,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [3] = {
        CreatureId = 110312,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [4] = T.RT_72,
      [5] = T.RT_100
    },
    TaskId = 110351
  },
  [110352] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 110301,
        Function = "RemoveRayCreature"
      },
      [2] = {
        CreatureId = 110311,
        Function = "RemoveRayCreature"
      },
      [3] = {
        CreatureId = 110312,
        Function = "RemoveRayCreature"
      }
    },
    TaskId = 110352
  },
  [110353] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.25,
        LoopShootId = 110325,
        SkillEffect = {110351}
      }
    },
    TaskId = 110353
  },
  [110354] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 110325
      }
    },
    TaskId = 110354
  },
  [110355] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_214,
      [2] = {
        BossValue = 17,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 15
      },
      [3] = {
        BaseChar = "Self",
        Function = "ExecutePassiveFunction",
        FunctionName = "AddMspOnHit",
        PassiveEffectId = 110301
      },
      [4] = {
        Condition = 110312,
        Function = "PlaySE",
        SEId = 110309
      },
      [5] = {
        Condition = 110313,
        Function = "PlaySE",
        SEId = 110312
      }
    },
    TaskId = 110355
  },
  [110356] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_219,
      [2] = {
        Function = "PlaySE",
        SEId = 110310,
        SceneSe = true
      }
    },
    TaskId = 110356
  },
  [110357] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_219
    },
    TaskId = 110357
  },
  [110411] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 110401,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 110411
  },
  [110412] = {
    TaskEffects = {
      [1] = {
        CreatureId = 110402,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 110412
  },
  [110413] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_221,
    TaskId = 110413
  },
  [110414] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 110402, Function = "RemoveBuff"},
      [2] = {
        BuffId = 110401,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 110414
  },
  [110415] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 110403,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_222
    },
    TaskId = 110415
  },
  [110416] = {
    TaskEffects = {
      [1] = {
        CreatureId = 110404,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 110416
  },
  [110421] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_40,
        Function = "Damage",
        Rate = 1
      },
      [2] = {FXId = 160124, Function = "PlayFX"}
    },
    TaskId = 110421
  },
  [110422] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110411,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 110422
  },
  [110423] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 110412,
        Condition = 110421,
        Function = "AddBuff",
        LastTime = 5
      },
      [2] = {
        BuffId = 110413,
        Condition = 110423,
        Function = "AddBuff",
        LastTime = 5
      },
      [3] = {
        BuffId = 110414,
        Condition = 110424,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 110423
  },
  [110431] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_224
    },
    TaskId = 110431
  },
  [110432] = {
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_221,
    TaskId = 110432
  },
  [110433] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 110401, Function = "RemoveBuff"},
      [2] = {
        BuffId = 110402,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 110433
  },
  [110434] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_224,
      [2] = {
        CreatureId = 110411,
        Function = "CreateSkillCreature",
        Location = {
          400,
          0,
          0
        }
      },
      [3] = {
        CreatureId = 110411,
        Function = "CreateSkillCreature",
        Location = {
          -400,
          0,
          0
        }
      },
      [4] = T.RT_222
    },
    TaskId = 110434
  },
  [110435] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.1
      }
    },
    TaskId = 110435
  },
  [110441] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 110421,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          300
        },
        Rotation = {
          0,
          90,
          -90
        }
      }
    },
    TaskId = 110441
  },
  [110442] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 110422,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 110442
  },
  [110443] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffType = 110401, Function = "RemoveBuff"}
    },
    TaskId = 110443
  },
  [110444] = {
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_220,
      [2] = {
        Function = "GatherTargets",
        GatherSpeed = 1000,
        LocationOffset = T.RT_98,
        StopDistance = 50
      },
      [3] = T.RT_39
    },
    TaskId = 110444
  },
  [110451] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillIntensity = 1,
        BaseAttr = "MaxES",
        BaseChar = "Self",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = 1
      }
    },
    TaskId = 110451
  },
  [120111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_228,
      [2] = T.RT_39
    },
    TaskId = 120111
  },
  [120112] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 120101,
        Condition = 120102,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 120112
  },
  [120113] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 120112,
        Function = "CreateSkillCreature",
        Location = T.RT_223
      }
    },
    TaskId = 120113
  },
  [120114] = {
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_228,
      [2] = T.RT_39,
      [3] = {FXId = 120101, Function = "PlayFX"}
    },
    TaskId = 120114
  },
  [120121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "HpConsume",
        Function = "Damage",
        Rate = 0.25
      },
      [2] = T.RT_229
    },
    TaskId = 120121
  },
  [120122] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = T.RT_230,
      [2] = T.RT_229
    },
    TaskId = 120122
  },
  [120123] = {
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = T.RT_234,
    TaskId = 120123
  },
  [120124] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Condition = 120101,
        Function = "ExecutePassiveFunction",
        FunctionName = "ExecuteSkill02ExtraEffect",
        PassiveEffectId = 120101
      }
    },
    TaskId = 120124
  },
  [120125] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 120121,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 120125
  },
  [120126] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = T.RT_234,
    TaskId = 120126
  },
  [120127] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 120101, Function = "RemoveBuff"}
    },
    TaskId = 120127
  },
  [120128] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_231,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 10
      },
      [3] = T.RT_112
    },
    TaskId = 120128
  },
  [120131] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 120131,
        Function = "CreateSkillCreature",
        Location = {
          0,
          400,
          -100
        }
      }
    },
    TaskId = 120131
  },
  [120132] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_237,
    TaskId = 120132
  },
  [120133] = {
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = T.RT_237,
    TaskId = 120133
  },
  [120134] = {
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill1",
          "ZhujueDark",
          "ZhujueDarkPassive"
        },
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_39
    },
    TaskId = 120134
  },
  [120135] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.01
      }
    },
    TaskId = 120135
  },
  [120211] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 120211,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Falu_Skill01_On",
        PassiveEffectId = 120201
      },
      [3] = {
        CreatureId = 120211,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 120211
  },
  [120212] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 120211, Function = "RemoveBuff"}
    },
    TaskId = 120212
  },
  [120213] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill1",
          "Falu_Skill1"
        },
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_123
    },
    TaskId = 120213
  },
  [120214] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_220,
      [2] = {
        Function = "GatherTargets",
        GatherSpeed = 2000,
        LocationOffset = T.RT_238,
        StopDistance = 100
      }
    },
    TaskId = 120214
  },
  [120215] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 120211,
        Function = "RemoveSkillCreature"
      },
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill01_GatherTarget",
        PassiveEffectId = 120201
      }
    },
    TaskId = 120215
  },
  [120221] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 0.5
      },
      [2] = T.RT_182,
      [3] = {
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_79
    },
    TaskId = 120221
  },
  [120222] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_182,
      [3] = {
        BossValue = 15,
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_79
    },
    TaskId = 120222
  },
  [120223] = {
    NotifyName = T.RT_12,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 120221,
        Function = "CreateSkillCreature",
        Location = T.RT_239
      }
    },
    TaskId = 120223
  },
  [120224] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 1.5
      },
      [2] = T.RT_182,
      [3] = {
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 300
      },
      [4] = T.RT_79
    },
    TaskId = 120224
  },
  [150111] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 11,
        CauseHit = "HitFly_XY1000Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_63,
      [4] = T.RT_240
    },
    TaskId = 150111
  },
  [150112] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 28,
        CauseHit = "HitFly_XY800Z400_F",
        Function = "CutToughness",
        Value = 80
      },
      [3] = {
        Function = "PlayFX",
        MaxHitFXNum = 8,
        WeaponFXGroupName = "Hit1"
      },
      [4] = T.RT_65,
      [5] = T.RT_241
    },
    TaskId = 150112
  },
  [150121] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150102,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        BuffId = 150121,
        Delay = 1.7,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150121
  },
  [150122] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 150102, Function = "RemoveBuff"},
      [2] = {BuffId = 150121, Function = "RemoveBuff"}
    },
    TaskId = 150122
  },
  [150123] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large240_InAir",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 50,
        CauseHit = "HitFly_XY800Z600_F",
        Function = "CutToughness",
        Value = 30
      },
      [3] = T.RT_241
    },
    TaskId = 150123
  },
  [150131] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = {
        BossValue = 42,
        CauseHit = "LightHit_100_F",
        Function = "CutToughness",
        Value = 25
      },
      [3] = T.RT_151,
      [4] = T.RT_152,
      [5] = T.RT_240
    },
    TaskId = 150131
  },
  [150132] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Small",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = {
        BossValue = 49,
        CauseHit = "LightHit_150_F",
        Function = "CutToughness",
        Value = 25
      },
      [3] = T.RT_90,
      [4] = T.RT_152,
      [5] = T.RT_241
    },
    TaskId = 150132
  },
  [150133] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = {
        BossValue = 24,
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_77,
      [4] = {
        Condition = 100,
        Dilation = 0.03,
        Duration = 0.05,
        Function = "HitStop"
      },
      [5] = T.RT_240
    },
    TaskId = 150133
  },
  [150134] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = {
        BossValue = 30,
        CauseHit = "HitFly_XY400Z500_F",
        Function = "CutToughness",
        Value = 30
      },
      [3] = {
        Function = "PlayFX",
        FxRotator = T.RT_57,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [4] = T.RT_152,
      [5] = T.RT_241
    },
    TaskId = 150134
  },
  [150135] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_9,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = T.RT_188,
      [2] = {
        BossValue = 60,
        CauseHit = "HitFly_XY800Z600_F",
        Function = "CutToughness",
        Value = 80
      },
      [3] = {
        Delay = 0.1,
        Function = "PlayFX",
        MaxHitFXNum = 5,
        WeaponFXGroupName = "Hit1"
      },
      [4] = {
        Delay = 0.05,
        Dilation = 0,
        Duration = 0.07,
        Function = "HitStop"
      },
      [5] = T.RT_241
    },
    TaskId = 150135
  },
  [150141] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_12,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = T.RT_242,
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ClearComboCount",
        PassiveEffectId = 150103
      },
      [3] = {
        Delay = 0.1,
        Function = "PlayFX",
        MaxHitFXNum = 8,
        WeaponFXGroupName = "Hit1"
      },
      [4] = {
        BossValue = 120,
        CauseHit = "HitFly_XY800Z600_F",
        Function = "CutToughness",
        Value = 80
      },
      [5] = T.RT_58,
      [6] = T.RT_241
    },
    TaskId = 150141
  },
  [150142] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "HeavyAttackStart",
        PassiveEffectId = 150101
      },
      [2] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "CreateWarning"
      }
    },
    TaskId = 150142
  },
  [150143] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "RemoveWarning"
      }
    },
    TaskId = 150143
  },
  [150144] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "HeavyAttackEnd",
        PassiveEffectId = 150101
      }
    },
    TaskId = 150144
  },
  [150145] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_13,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_242,
      [2] = {
        BossValue = 50,
        CauseHit = "HitFly_XY200Z500_F",
        Function = "CutToughness",
        Value = 30
      },
      [3] = {
        Function = "PlayFX",
        FxRotator = T.RT_57,
        IsFaceToChar = true,
        MaxHitFXNum = 5,
        WeaponFXGroupName = "Hit"
      },
      [4] = T.RT_152,
      [5] = T.RT_241
    },
    TaskId = 150145
  },
  [150151] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_244,
      [2] = {FXId = 150101, Function = "PlayFX"},
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 45
      },
      [4] = T.RT_245,
      [5] = T.RT_246,
      [6] = T.RT_240,
      [7] = {
        FeedbackPath = "FE_Light_R_Big",
        Function = "PlayForceFeedback",
        Tag = "Hit"
      },
      [8] = {
        Condition = 150141,
        Function = "CameraShake",
        ShakeClass = "BP_CS_BaoNu_Cast_001"
      },
      [9] = {
        Condition = 150104,
        Function = "CameraShake",
        ShakeClass = "BP_CS_BaoNu_Cast_002"
      }
    },
    TaskId = 150151
  },
  [150211] = {
    ExtraBPFilter = "Nifu_Skill01_Search",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        Condition = 150201,
        CreatureId = 150201,
        DefaultLocationOffset = T.RT_251,
        Function = "CreateSkillCreature"
      },
      [2] = {
        BaseChar = "Target",
        Condition = 150203,
        CreatureId = 150203,
        DefaultLocationOffset = T.RT_251,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150211
  },
  [150212] = {
    ExtraBPFilter = "Nifu_Skill01_Search",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        Condition = 150202,
        CreatureId = 150202,
        DefaultLocationOffset = T.RT_252,
        Function = "CreateSkillCreature"
      },
      [2] = {
        BaseChar = "Target",
        Condition = 150204,
        CreatureId = 150204,
        DefaultLocationOffset = T.RT_252,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150212
  },
  [150213] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill1",
          "NifuLight"
        },
        DamageType = "Light",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = "$Source:GetRootSource():GetFloat('Skill04TriggerRate')$"
      },
      [2] = T.RT_253,
      [3] = T.RT_254,
      [4] = {
        CanBeScaled = true,
        FXId = 150201,
        Function = "PlayFX"
      },
      [5] = T.RT_255,
      [6] = T.RT_256,
      [7] = T.RT_257
    },
    TaskId = 150213
  },
  [150214] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_259,
      [2] = {
        BossValue = 150,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_254,
      [4] = {
        CanBeScaled = true,
        FXId = 150202,
        Function = "PlayFX"
      },
      [5] = T.RT_260,
      [6] = T.RT_261,
      [7] = T.RT_257
    },
    TaskId = 150214
  },
  [150215] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150201,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150215
  },
  [150216] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 150201, Function = "RemoveBuff"}
    },
    TaskId = 150216
  },
  [150217] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150201,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150217
  },
  [150218] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150202,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150218
  },
  [150221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "AddbuffSkill02",
        PassiveEffectId = 150201
      }
    },
    TaskId = 150221
  },
  [150222] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150203,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150222
  },
  [150223] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 150203, Function = "RemoveBuff"}
    },
    TaskId = 150223
  },
  [150224] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill1",
          "NifuLight",
          "NifuSpLight"
        },
        DamageType = "Light",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = "$Source:GetRootSource():GetFloat('Skill04TriggerRate')$"
      },
      [2] = T.RT_253,
      [3] = T.RT_254,
      [4] = {FXId = 150203, Function = "PlayFX"},
      [5] = T.RT_260,
      [6] = T.RT_256,
      [7] = T.RT_257
    },
    TaskId = 150224
  },
  [150225] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_259,
      [2] = {
        Function = "GatherTargets",
        GatherSpeed = 2000,
        LocationOffset = {
          0,
          0,
          200
        },
        StopDistance = 50
      },
      [3] = T.RT_254,
      [4] = {FXId = 150204, Function = "PlayFX"},
      [5] = T.RT_255,
      [6] = T.RT_261,
      [7] = T.RT_257
    },
    TaskId = 150225
  },
  [150231] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 150201,
        DefaultLocationOffset = T.RT_251,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150231
  },
  [150232] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 150202,
        DefaultLocationOffset = T.RT_252,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150232
  },
  [150311] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150301,
        Function = "CreateSkillCreature",
        Location = T.RT_147
      },
      [2] = {
        CanBeScaled = true,
        FXId = 150312,
        Function = "PlayFX"
      },
      [3] = {
        Condition = 43,
        FXId = 150313,
        Function = "PlayFX"
      },
      [4] = T.RT_262,
      [5] = {
        BaseChar = "Target",
        Function = "PlaySE",
        SEId = 150307
      },
      [6] = {
        FeedbackPath = "FE_Loop_Light",
        Function = "PlayForceFeedback",
        Tag = "Hit"
      }
    },
    TaskId = 150311
  },
  [150312] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_180,
        Delay = 0.2,
        Function = "Damage",
        Rate = "#2"
      },
      [3] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_180,
        Delay = 0.4,
        Function = "Damage",
        Rate = "#3"
      },
      [4] = T.RT_263,
      [5] = {
        Delay = 0.2,
        FXId = 150314,
        Function = "PlayFX"
      },
      [6] = {
        Delay = 0.4,
        FXId = 150314,
        Function = "PlayFX"
      },
      [7] = {FXId = 150315, Function = "PlayFX"},
      [8] = T.RT_264,
      [9] = {
        Delay = 0.2,
        Function = "PlaySE",
        SEId = 150308
      },
      [10] = {
        Delay = 0.4,
        Function = "PlaySE",
        SEId = 150308
      }
    },
    TaskId = 150312
  },
  [150321] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150322,
        Function = "CreateSkillCreature",
        Location = {
          223,
          -429,
          500
        },
        Rotation = {
          -78,
          -116,
          116
        }
      },
      [2] = {
        CreatureId = 150324,
        Function = "CreateSkillCreature",
        Location = {
          -537,
          -677,
          500
        },
        Rotation = {
          -98,
          -65,
          10
        }
      },
      [3] = {
        CreatureId = 150324,
        Function = "CreateSkillCreature",
        Location = {
          -312,
          523,
          500
        },
        Rotation = {
          -77,
          20,
          -5
        }
      },
      [4] = {
        CreatureId = 150323,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        Location = {
          571,
          483,
          500
        },
        Rotation = {
          -78,
          -62,
          168
        }
      },
      [5] = {
        CreatureId = 150324,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        Location = {
          741,
          142,
          500
        },
        Rotation = {
          -72,
          257,
          -241
        }
      },
      [6] = {
        CreatureId = 150322,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        Location = {
          998,
          -328,
          500
        },
        Rotation = {
          -98,
          -104,
          135
        }
      },
      [7] = {
        CreatureId = 150324,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = {
          146,
          -1003,
          500
        },
        Rotation = {
          -101,
          -68,
          73
        }
      },
      [8] = {
        CreatureId = 150321,
        Delay = 0.9,
        Function = "CreateSkillCreature",
        Location = {
          -628,
          -704,
          500
        },
        Rotation = {
          -73,
          -47,
          7
        }
      },
      [9] = {
        CreatureId = 150324,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        Location = {
          546,
          -813,
          500
        },
        Rotation = {
          -71,
          -78,
          77
        }
      },
      [10] = {
        CreatureId = 150322,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        Location = {
          -546,
          -853,
          500
        },
        Rotation = {
          -102,
          -78,
          77
        }
      }
    },
    TaskId = 150321
  },
  [150322] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150323,
        Delay = 0.7,
        Function = "CreateSkillCreature",
        Location = {
          -896,
          373,
          500
        },
        Rotation = {
          -75,
          63,
          64
        }
      },
      [2] = {
        CreatureId = 150322,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = {
          -568,
          1102,
          500
        },
        Rotation = {
          -64,
          47,
          -43
        }
      },
      [3] = {
        CreatureId = 150321,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = {
          126,
          1138,
          500
        },
        Rotation = {
          -98,
          101,
          -71
        }
      },
      [4] = {
        CreatureId = 150321,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        Location = {
          1047,
          618,
          500
        },
        Rotation = {
          -102,
          64,
          173
        }
      },
      [5] = {
        CreatureId = 150321,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        Location = {
          -845,
          762,
          500
        },
        Rotation = {
          -71,
          62,
          -3
        }
      },
      [6] = {
        CreatureId = 150323,
        Delay = 0.9,
        Function = "CreateSkillCreature",
        Location = {
          965,
          -995,
          500
        },
        Rotation = {
          -105,
          101,
          109
        }
      },
      [7] = {
        CreatureId = 150322,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        Location = {
          624,
          1111,
          500
        },
        Rotation = {
          -108,
          -199,
          197
        }
      },
      [8] = {
        CreatureId = 150322,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        Location = {
          904,
          721,
          500
        },
        Rotation = {
          -98,
          199,
          197
        }
      },
      [9] = {
        CreatureId = 150324,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = {
          -183,
          1275,
          500
        },
        Rotation = {
          -66,
          51,
          -45
        }
      },
      [10] = {
        CreatureId = 150321,
        Delay = 0.9,
        Function = "CreateSkillCreature",
        Location = {
          -578,
          -100,
          500
        },
        Rotation = {
          -83,
          -50,
          7
        }
      }
    },
    TaskId = 150322
  },
  [150325] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150325,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 150302,
        UnitType = "MechanismSummon"
      },
      [3] = T.RT_265,
      [4] = T.RT_266
    },
    TaskId = 150325
  },
  [150326] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_267,
      [3] = {
        CorrectDirection = true,
        FXId = 150307,
        Function = "PlayFX",
        IsAttached = true,
        NormalToHit = true
      },
      [4] = T.RT_263,
      [5] = T.RT_268
    },
    TaskId = 150326
  },
  [150327] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_267,
      [3] = {
        CorrectDirection = true,
        FXId = 150309,
        Function = "PlayFX",
        IsAttached = true,
        NormalToHit = true
      },
      [4] = T.RT_263,
      [5] = T.RT_268
    },
    TaskId = 150327
  },
  [150328] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150325,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Kezhou_Skill02_Loop"
      }
    },
    TaskId = 150328
  },
  [150329] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "PlaySE",
        SEId = 150305,
        SceneSe = true
      }
    },
    TaskId = 150329
  },
  [150331] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_266
    },
    TaskId = 150331
  },
  [150332] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150321,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150332
  },
  [150333] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150322,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150333
  },
  [150334] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150323,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150334
  },
  [150335] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_271,
    TaskId = 150335
  },
  [150336] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_269,
      [3] = T.RT_270,
      [4] = T.RT_268
    },
    TaskId = 150336
  },
  [150337] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_271,
    TaskId = 150337
  },
  [150338] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_269,
      [3] = T.RT_270,
      [4] = T.RT_168
    },
    TaskId = 150338
  },
  [150340] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 150320, Function = "RemoveBuff"},
      [2] = {BuffId = 150321, Function = "RemoveBuff"},
      [3] = {BuffId = 150322, Function = "RemoveBuff"},
      [4] = {BuffId = 150323, Function = "RemoveBuff"},
      [5] = {BuffId = 150324, Function = "RemoveBuff"},
      [6] = {BuffId = 150325, Function = "RemoveBuff"},
      [7] = T.RT_265
    },
    TaskId = 150340
  },
  [150341] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150321,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 10,
        SetSpeed = 0,
        TargetSocket = "hook_arm_r",
        TargetSocketLocation = T.RT_193
      },
      [2] = {
        CreatureId = 150322,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 10,
        SetSpeed = 0,
        TargetSocket = "hook_arm_r",
        TargetSocketLocation = T.RT_193
      },
      [3] = {
        CreatureId = 150323,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 10,
        SetSpeed = 0,
        TargetSocket = "hook_arm_r",
        TargetSocketLocation = T.RT_193
      },
      [4] = {
        CreatureId = 150324,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 10,
        SetSpeed = 0,
        TargetSocket = "hook_arm_r",
        TargetSocketLocation = T.RT_193
      },
      [5] = {
        CreatureId = 150325,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 150341
  },
  [150342] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 150332,
        Function = "CreateSkillCreature",
        Location = {
          0,
          100,
          160
        },
        Rotation = {
          -10,
          0,
          0
        }
      }
    },
    TaskId = 150342
  },
  [150343] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 100,
        CauseHit = "RangedWeapon_Common",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_263,
      [4] = {
        CanBeScaled = true,
        FXId = 150324,
        Function = "PlayFX"
      },
      [5] = {
        Falloff = 0.1,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 1000,
        ShakeClass = "BP_CS_Kezhou_Skill02_Off"
      },
      [6] = T.RT_59,
      [7] = {
        FeedbackPath = "FE_Medium_R",
        Function = "PlayForceFeedback",
        Tag = "Hit"
      }
    },
    TaskId = 150343
  },
  [150344] = {
    TaskEffects = {
      [1] = {
        BaseChar = "Self",
        CreatureId = 150333,
        Function = "CreateSkillCreature",
        IsAttached = true,
        Location = {
          30,
          30,
          50
        },
        Rotation = {
          60,
          60,
          60
        }
      }
    },
    TaskId = 150344
  },
  [150345] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill2",
          "KezhouShadowSword"
        },
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        BossValue = 3,
        CauseHit = "RangedWeapon_Common",
        Function = "CutToughness",
        Value = 10
      },
      [3] = T.RT_264,
      [4] = {FXId = 150326, Function = "PlayFX"}
    },
    TaskId = 150345
  },
  [150346] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "LaunchShadowSword",
        PassiveEffectId = 150301
      }
    },
    TaskId = 150346
  },
  [150351] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_170,
      [3] = T.RT_164,
      [4] = T.RT_269,
      [5] = T.RT_49
    },
    TaskId = 150351
  },
  [150352] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          -40,
          90,
          0
        },
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY400Z400_F",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_269,
      [5] = T.RT_49
    },
    TaskId = 150352
  },
  [150353] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          70,
          90,
          0
        },
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_85,
      [4] = T.RT_269,
      [5] = T.RT_49
    },
    TaskId = 150353
  },
  [150354] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150341,
        Function = "CreateSkillCreature",
        Location = {
          0,
          50,
          45
        }
      }
    },
    TaskId = 150354
  },
  [150355] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_272,
      [3] = T.RT_165,
      [4] = T.RT_49,
      [5] = T.RT_119
    },
    TaskId = 150355
  },
  [150356] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_62,
      [3] = T.RT_38,
      [4] = {
        CauseHit = "HitFly_XY800Z400_F",
        Function = "CutToughness",
        Value = 80
      },
      [5] = T.RT_65,
      [6] = T.RT_59
    },
    TaskId = 150356
  },
  [150357] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 150357
  },
  [150358] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_276,
    TaskId = 150358
  },
  [150359] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_277,
    TaskId = 150359
  },
  [150361] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_38,
      [3] = T.RT_129,
      [4] = T.RT_130,
      [5] = T.RT_268
    },
    TaskId = 150361
  },
  [150362] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_278,
    TaskId = 150362
  },
  [150363] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150342,
        Function = "CreateSkillCreature",
        Location = {
          0,
          45,
          45
        }
      }
    },
    TaskId = 150363
  },
  [150364] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_278,
    TaskId = 150364
  },
  [150365] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_38,
      [3] = T.RT_92,
      [4] = T.RT_65,
      [5] = T.RT_268
    },
    TaskId = 150365
  },
  [150366] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_272,
      [3] = T.RT_165,
      [4] = T.RT_268,
      [5] = T.RT_119
    },
    TaskId = 150366
  },
  [150367] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150343,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 150343,
        Function = "CreateSkillCreature",
        Rotation = T.RT_141
      },
      [3] = {
        CreatureId = 150343,
        Function = "CreateSkillCreature",
        Rotation = T.RT_142
      },
      [4] = {
        CreatureId = 150343,
        Function = "CreateSkillCreature",
        Rotation = T.RT_143
      },
      [5] = {
        CreatureId = 150343,
        Function = "CreateSkillCreature",
        Rotation = T.RT_144
      },
      [6] = T.RT_62
    },
    TaskId = 150367
  },
  [150368] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_272,
      [3] = T.RT_111,
      [4] = T.RT_49,
      [5] = T.RT_119
    },
    TaskId = 150368
  },
  [150369] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 150369
  },
  [150370] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_274,
      [2] = T.RT_38,
      [3] = T.RT_158,
      [4] = T.RT_49,
      [5] = T.RT_72,
      [6] = {
        CreatureId = 150344,
        Function = "CreateSkillCreature",
        Location = T.RT_147
      }
    },
    TaskId = 150370
  },
  [150371] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_274,
      [2] = T.RT_38,
      [3] = {
        CauseHit = "HitFly_XY600Z600",
        Function = "CutToughness",
        Value = 35
      },
      [4] = T.RT_49,
      [5] = T.RT_72
    },
    TaskId = 150371
  },
  [150372] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_150,
    TaskId = 150372
  },
  [150373] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_277,
    TaskId = 150373
  },
  [150381] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_172,
      [3] = T.RT_178,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 150381
  },
  [150382] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_280,
      [3] = T.RT_178,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 150382
  },
  [150383] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_282,
      [3] = {
        CauseHit = "LightHit_100_F",
        Function = "CutToughness",
        Value = 60
      },
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 150383
  },
  [150384] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_38,
      [3] = T.RT_283,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 150384
  },
  [150385] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_170,
      [3] = {
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 150385
  },
  [150386] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_62,
      [3] = T.RT_172,
      [4] = T.RT_161,
      [5] = T.RT_79,
      [6] = T.RT_59
    },
    TaskId = 150386
  },
  [150387] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 150387
  },
  [150388] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_276,
    TaskId = 150388
  },
  [150389] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_176,
      [2] = T.RT_284,
      [3] = {
        CauseHit = "HitFly_XY600Z400_F",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 150389
  },
  [150391] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_172,
      [3] = T.RT_85,
      [4] = T.RT_168
    },
    TaskId = 150391
  },
  [150392] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_280,
      [3] = T.RT_140,
      [4] = T.RT_168
    },
    TaskId = 150392
  },
  [150393] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_282,
      [3] = {
        CauseHit = "HitFly_XY200Z300_B",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 60
      },
      [4] = T.RT_152,
      [5] = T.RT_168
    },
    TaskId = 150393
  },
  [150394] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_38,
      [3] = {
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 80
      },
      [4] = T.RT_168
    },
    TaskId = 150394
  },
  [150395] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_170,
      [3] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 15
      },
      [4] = T.RT_171
    },
    TaskId = 150395
  },
  [150396] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_273,
      [2] = T.RT_62,
      [3] = T.RT_172,
      [4] = {
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 200
      },
      [5] = T.RT_79,
      [6] = T.RT_59
    },
    TaskId = 150396
  },
  [150397] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 150397
  },
  [150398] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_274,
      [2] = T.RT_38,
      [3] = T.RT_275,
      [4] = T.RT_72,
      [5] = T.RT_59
    },
    TaskId = 150398
  },
  [150399] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_176,
      [2] = T.RT_284,
      [3] = T.RT_129,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 150399
  },
  [150412] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "StartJetRush"
      },
      [2] = {
        CreatureId = 150401,
        Function = "CreateSkillCreature"
      },
      [3] = {
        BuffId = 150407,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150412
  },
  [150413] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_285
    },
    TaskId = 150413
  },
  [150414] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_220,
      [2] = T.RT_104,
      [3] = T.RT_123,
      [4] = T.RT_286,
      [5] = T.RT_287
    },
    TaskId = 150414
  },
  [150415] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_220,
      [2] = {
        CauseHit = "HitFly_XY800Z600_F",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_123,
      [4] = T.RT_287
    },
    TaskId = 150415
  },
  [150416] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150401,
        Function = "RemoveSkillCreature"
      },
      [2] = {BuffId = 150411, Function = "RemoveBuff"}
    },
    TaskId = 150416
  },
  [150421] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150401,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        BuffId = 150404,
        Function = "AddBuff",
        LastTime = -1
      },
      [3] = {
        Function = "AddBullet",
        TotalBullet = 1,
        UltraWeapon = T.RT_288,
        Value = -99999
      },
      [4] = {
        Function = "AddBullet",
        TotalBullet = 1,
        UltraWeapon = T.RT_288,
        Value = "$Source:GetInt('Skill02BulletNum')$"
      },
      [5] = T.RT_127
    },
    TaskId = 150421
  },
  [150422] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 150401, Function = "RemoveBuff"},
      [2] = {BuffId = 150403, Function = "RemoveBuff"},
      [3] = {BuffId = 150404, Function = "RemoveBuff"},
      [4] = {BuffId = 150406, Function = "RemoveBuff"},
      [5] = T.RT_285
    },
    TaskId = 150422
  },
  [150425] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        ATKBase = "ATK_Ultra",
        Condition = 150402,
        CreatureId = 150421,
        Direction = "Camera",
        Distance = 9000,
        Function = "CreateSkillCreature",
        Location = {
          0,
          100,
          150
        }
      },
      [2] = {
        ATKBase = "ATK_Ultra",
        Condition = 150421,
        CreatureId = 150422,
        Direction = "Camera",
        Distance = 9000,
        Function = "CreateSkillCreature",
        Location = {
          250,
          -100,
          30
        }
      },
      [3] = {
        ATKBase = "ATK_Ultra",
        Condition = 150421,
        CreatureId = 150422,
        Direction = "Camera",
        Distance = 9000,
        Function = "CreateSkillCreature",
        Location = {
          -250,
          -100,
          30
        }
      }
    },
    TaskId = 150425
  },
  [150426] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_290,
      [2] = {
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 50
      },
      [3] = T.RT_175
    },
    TaskId = 150426
  },
  [150427] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Xlarge",
    TaskEffects = {
      [1] = T.RT_290,
      [2] = T.RT_104,
      [3] = {
        CanBeScaled = true,
        FXId = 150461,
        Function = "PlayFX"
      },
      [4] = T.RT_175
    },
    TaskId = 150427
  },
  [150431] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.25,
        LoopShootId = 150431,
        SkillEffect = {150433, 150436}
      }
    },
    TaskId = 150431
  },
  [150432] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 150431
      },
      [2] = T.RT_291
    },
    TaskId = 150432
  },
  [150433] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_292,
      [2] = {
        CreatureId = 150402,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        UseSaveLoc = "SuyiShoot"
      },
      [3] = T.RT_293,
      [4] = T.RT_100
    },
    TaskId = 150433
  },
  [150434] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_295,
      [2] = {
        CanBeScaled = true,
        FXId = 150422,
        Function = "PlayFX"
      },
      [3] = T.RT_296,
      [4] = T.RT_175
    },
    TaskId = 150434
  },
  [150435] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_295,
      [2] = {
        CanBeScaled = true,
        FXId = 150422,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RandomRotation = T.RT_126
      },
      [3] = T.RT_296,
      [4] = T.RT_175
    },
    TaskId = 150435
  },
  [150436] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_297
    },
    TaskId = 150436
  },
  [150441] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_292,
      [2] = {
        AimSkeletal = "hit1",
        CreatureId = 150403,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        UseSaveLoc = "SuyiShoot"
      },
      [3] = T.RT_298,
      [4] = T.RT_72,
      [5] = T.RT_127
    },
    TaskId = 150441
  },
  [150442] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CostBullet = 0,
        Function = "StartLoopShoot",
        LoopInterval = 0.15,
        LoopShootId = 150401,
        SkillEffect = {150444, 150436}
      },
      [2] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.5,
        LoopShootId = 150402,
        SkillEffect = {150441}
      },
      [3] = T.RT_299,
      [4] = T.RT_300
    },
    TaskId = 150442
  },
  [150443] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 150401
      },
      [2] = {
        Function = "EndLoopShoot",
        LoopShootId = 150402
      },
      [3] = {
        ClientSkillLogicId = 150401,
        Function = "ExecuteClientSkillLogicFunction",
        FunctionName = "EndShoot"
      },
      [4] = T.RT_291
    },
    TaskId = 150443
  },
  [150444] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ClientSkillLogicId = 150401,
        Function = "ExecuteClientSkillLogicFunction",
        FunctionName = "HeavyShootingLoop"
      }
    },
    TaskId = 150444
  },
  [150445] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_295,
      [2] = T.RT_296,
      [3] = {
        CanBeScaled = true,
        FXId = 150432,
        Function = "PlayFX"
      }
    },
    TaskId = 150445
  },
  [150446] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 150404,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150446
  },
  [150447] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 150441,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150447
  },
  [150451] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150405,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_297,
      [3] = T.RT_297,
      [4] = T.RT_297,
      [5] = T.RT_297,
      [6] = T.RT_297,
      [7] = T.RT_49,
      [8] = {
        BuffId = 150422,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150451
  },
  [150452] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150405,
        Function = "RemoveSkillCreature"
      },
      [2] = T.RT_297,
      [3] = T.RT_297,
      [4] = T.RT_297
    },
    TaskId = 150452
  },
  [150453] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150406,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_297,
      [3] = T.RT_297,
      [4] = T.RT_297,
      [5] = T.RT_297,
      [6] = T.RT_297,
      [7] = T.RT_49
    },
    TaskId = 150453
  },
  [150454] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150406,
        Function = "RemoveSkillCreature"
      },
      [2] = T.RT_297,
      [3] = T.RT_297,
      [4] = T.RT_297
    },
    TaskId = 150454
  },
  [150455] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_295,
      [2] = T.RT_177,
      [3] = {
        BossValue = 100,
        CauseHit = "HitFly_XY800Z300A90",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_119,
      [5] = T.RT_301,
      [6] = T.RT_302
    },
    TaskId = 150455
  },
  [150456] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_295,
      [2] = T.RT_177,
      [3] = {
        BossValue = 100,
        CauseHit = "HitFly_XY800Z300A270",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_119,
      [5] = T.RT_301,
      [6] = T.RT_302
    },
    TaskId = 150456
  },
  [150457] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_304,
      [2] = {
        CorrectDirection = true,
        FXId = 150411,
        Function = "PlayFX",
        IsAttached = true,
        IsDecalEffectCreature = true,
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true,
        ReplaceFXId = T.RT_305
      },
      [3] = T.RT_306
    },
    TaskId = 150457
  },
  [150458] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "ClaymoreDis"
      }
    },
    TaskId = 150458
  },
  [150472] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "GradeAutoShoot",
        PassiveEffectId = 150401
      },
      [2] = {
        Delay = 0.2,
        Function = "ExecutePassiveFunction",
        FunctionName = "GradeAutoShoot",
        PassiveEffectId = 150401
      },
      [3] = {
        Delay = 0.4,
        Function = "ExecutePassiveFunction",
        FunctionName = "GradeAutoShoot",
        PassiveEffectId = 150401
      },
      [4] = {
        Delay = 0.6,
        Function = "ExecutePassiveFunction",
        FunctionName = "GradeAutoShoot",
        PassiveEffectId = 150401
      }
    },
    TaskId = 150472
  },
  [150473] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 150402,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_293
    },
    TaskId = 150473
  },
  [150511] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 150501,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 150511
  },
  [150521] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = T.RT_308,
    TaskId = 150521
  },
  [150522] = {
    AllowSkillRangeModify = true,
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "BladeUp",
        PassiveEffectId = 150501
      },
      [2] = {BuffId = 150502, Function = "RemoveBuff"}
    },
    TaskId = 150522
  },
  [150531] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 150501,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature",
        Rotation = T.RT_21
      },
      [2] = {
        Condition = 150501,
        CreatureId = 150511,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature",
        Rotation = {
          0,
          0,
          5
        }
      }
    },
    TaskId = 150531
  },
  [150532] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 150502,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature",
        Rotation = T.RT_126
      },
      [2] = {
        Condition = 150501,
        CreatureId = 150521,
        Direction = "Camera",
        Distance = 2000,
        Function = "CreateSkillCreature",
        Rotation = T.RT_126
      }
    },
    TaskId = 150532
  },
  [150533] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_307,
      [2] = {
        CauseHit = "LightHit_120",
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_42,
      [4] = T.RT_90
    },
    TaskId = 150533
  },
  [150534] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ultra",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 2
      },
      [2] = T.RT_309,
      [3] = T.RT_42,
      [4] = T.RT_38
    },
    TaskId = 150534
  },
  [150541] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150503,
        Function = "CreateSkillCreature"
      },
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill1End",
        PassiveEffectId = 150501
      }
    },
    TaskId = 150541
  },
  [150542] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = T.RT_63
    },
    TaskId = 150542
  },
  [150543] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060212,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150543
  },
  [150544] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060213,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150544
  },
  [150545] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060214,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150545
  },
  [150546] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060215,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150546
  },
  [150547] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060216,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150547
  },
  [150548] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_311,
      [2] = T.RT_146,
      [3] = {
        FXId = 1060217,
        Function = "PlayFX",
        IsAttached = false
      },
      [4] = T.RT_90
    },
    TaskId = 150548
  },
  [150551] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1060221,
        Function = "CreateSkillCreature",
        Location = T.RT_312
      }
    },
    TaskId = 150551
  },
  [150552] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_313,
    TaskId = 150552
  },
  [150553] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_313,
    TaskId = 150553
  },
  [150561] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150504,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 150561
  },
  [150562] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 150504,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 150562
  },
  [150563] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small_Trgt",
    TaskEffects = T.RT_308,
    TaskId = 150563
  },
  [150564] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_315
    },
    TaskId = 150564
  },
  [160111] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 160101,
        Function = "CreateSkillCreature",
        Rotation = T.RT_320
      }
    },
    TaskId = 160111
  },
  [160112] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 160102,
        Function = "CreateSkillCreature",
        Rotation = T.RT_321
      }
    },
    TaskId = 160112
  },
  [160113] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_180,
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = 1
      },
      [2] = {
        BossValue = 23,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 40
      },
      [3] = {FXId = 160103, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 160101}
    },
    TaskId = 160113
  },
  [160121] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 160101,
        Condition = 96,
        Function = "AddBuff",
        LastTime = 12
      },
      [2] = {
        AllowSkillIntensity = 1,
        BaseAttr = "MaxES",
        BaseChar = "Self",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = 0.05
      },
      [3] = {
        BuffId = 160104,
        Condition = 76,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 160121
  },
  [160122] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        CauseHit = "HitFly_XY500Z300",
        Function = "CutToughness",
        Value = 150
      },
      [3] = T.RT_42,
      [4] = {Function = "PlaySE", SEId = 160104}
    },
    TaskId = 160122
  },
  [160123] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Condition = 72,
        CreatureId = 160103,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 160123
  },
  [160124] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BuffId = 160102,
        Function = "AddBuff",
        LastTime = 1.1
      }
    },
    TaskId = 160124
  },
  [160125] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Condition = 92,
        FXId = 160124,
        Function = "PlayFX"
      }
    },
    TaskId = 160125
  },
  [160131] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 160105,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 160131
  },
  [160132] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Small_Trgt",
    TaskEffects = {
      [1] = T.RT_244,
      [2] = {
        CauseHit = "LightHit_50_F",
        Function = "CutToughness",
        Value = 40
      }
    },
    TaskId = 160132
  },
  [160133] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        FXId = 160131,
        Function = "PlayFX"
      }
    },
    TaskId = 160133
  },
  [180111] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_322,
      [3] = {
        BossValue = 56,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 40
      },
      [4] = T.RT_323,
      [5] = {
        Delay = 0.1,
        FXId = 25,
        Function = "PlayFX"
      }
    },
    TaskId = 180111
  },
  [180112] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "SummonSkill1",
        PassiveEffectId = 180101
      }
    },
    TaskId = 180112
  },
  [180113] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large_Trgt",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_322,
      [3] = T.RT_324,
      [4] = T.RT_323,
      [5] = T.RT_249,
      [6] = {Function = "PlaySE", SEId = 180107}
    },
    TaskId = 180113
  },
  [180114] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large_Trgt",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_322,
      [3] = T.RT_324,
      [4] = T.RT_323,
      [5] = T.RT_249,
      [6] = {Function = "PlaySE", SEId = 180108}
    },
    TaskId = 180114
  },
  [180115] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large_Trgt",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_322,
      [3] = T.RT_324,
      [4] = T.RT_323,
      [5] = T.RT_249,
      [6] = {Function = "PlaySE", SEId = 180109}
    },
    TaskId = 180115
  },
  [180116] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large_Trgt",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_322,
      [3] = T.RT_324,
      [4] = T.RT_323,
      [5] = T.RT_249,
      [6] = {Function = "PlaySE", SEId = 180110}
    },
    TaskId = 180116
  },
  [180121] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        UnitId = 180101,
        UnitType = "Monster",
        UseSaveLoc = "FeinaSummon"
      }
    },
    TaskId = 180121
  },
  [180122] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "RemoveUnit", UnitId = 180101}
    },
    TaskId = 180122
  },
  [180123] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 180121,
        Function = "PlayFX",
        IsAttached = true,
        IsEffectCreature = true
      }
    },
    TaskId = 180123
  },
  [180131] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180131,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180131
  },
  [180132] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180132,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180132
  },
  [180133] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180133,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180133
  },
  [180134] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180134,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180134
  },
  [180135] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180135,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180135
  },
  [180136] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180136,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180136
  },
  [180137] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180137,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180137
  },
  [180138] = {
    AllowSkillRangeModify = true,
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = T.RT_326,
      [2] = {
        BuffId = 180138,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 180138
  },
  [210111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 14,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 210101,
        UnitType = "Monster"
      }
    },
    TaskId = 210111
  },
  [210112] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = T.RT_485,
    TaskId = 210112
  },
  [210113] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 14,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 210101,
        UnitType = "Monster"
      }
    },
    TaskId = 210113
  },
  [210114] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = T.RT_485,
    TaskId = 210114
  },
  [210115] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 14,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 210101,
        UnitType = "Monster",
        UseSaveLoc = "ShuimuSkill01"
      }
    },
    TaskId = 210115
  },
  [210116] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 14,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 210101,
        UnitType = "Monster",
        UseSaveLoc = "ShuimuSkill01"
      }
    },
    TaskId = 210116
  },
  [210121] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_412,
      [3] = {
        BossValue = 233,
        CauseHit = "HitFly_XY300Z1000",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_486
    },
    TaskId = 210121
  },
  [210122] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Shuimu_Skill02_MiddleRing",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_40,
        Delay = 0.3,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        Delay = 0.3,
        FXId = 23,
        Function = "PlayFX"
      },
      [3] = {
        BossValue = 233,
        CauseHit = "HitFly_XY300Z1000",
        Delay = 0.3,
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_486
    },
    TaskId = 210122
  },
  [210123] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Shuimu_Skill02_OuterRing",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_40,
        Delay = 0.6,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        Delay = 0.6,
        FXId = 23,
        Function = "PlayFX"
      },
      [3] = {
        BossValue = 233,
        CauseHit = "HitFly_XY300Z1000",
        Delay = 0.6,
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_486
    },
    TaskId = 210123
  },
  [210131] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_412
    },
    TaskId = 210131
  },
  [210211] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SetInt = T.RT_487,
        SingleSummonCount = 1,
        UnitId = 210201,
        UnitType = "Monster"
      }
    },
    TaskId = 210211
  },
  [210212] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 99,
        MaxSummonCount = 9,
        SingleSummonCount = 1,
        UnitId = 210202,
        UnitType = "Monster"
      }
    },
    TaskId = 210212
  },
  [210213] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 99,
        MaxSummonCount = 2,
        SetInt = T.RT_487,
        SingleSummonCount = 1,
        UnitId = 210203,
        UnitType = "Monster",
        UseSaveLoc = "EveRook01"
      }
    },
    TaskId = 210213
  },
  [210214] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Promotion_Rook",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210214
  },
  [210215] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Promotion_Queen",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210215
  },
  [210216] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SetInt = T.RT_487,
        SingleSummonCount = 1,
        UnitId = 210204,
        UnitType = "Monster",
        UseSaveLoc = "EveQueen"
      }
    },
    TaskId = 210216
  },
  [210217] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_488,
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "EndSkill02",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210217
  },
  [210221] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_11,
    TaskId = 210221
  },
  [210222] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_11,
    TaskId = 210222
  },
  [210223] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 12
      },
      [2] = T.RT_4,
      [3] = T.RT_10,
      [4] = {FXId = 33311, Function = "PlayFX"},
      [5] = T.RT_5
    },
    TaskId = 210223
  },
  [210231] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 210201,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_4,
      [3] = T.RT_10,
      [4] = T.RT_5
    },
    TaskId = 210231
  },
  [210232] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_489,
      [3] = {
        CauseHit = "HitFly_XY200Z100",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_490
    },
    TaskId = 210232
  },
  [210241] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 210202,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ExecuteSkill02",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210241
  },
  [210242] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_491,
      [2] = T.RT_492
    },
    TaskId = 210242
  },
  [210243] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 99,
        MaxSummonCount = 9,
        SetInt = {IsEveCopySummon = 1},
        SingleSummonCount = 1,
        UnitId = 210202,
        UnitType = "Monster",
        UseSaveLoc = "EveSkill02Copy"
      }
    },
    TaskId = 210243
  },
  [210251] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 210202,
        Function = "RemoveBuff",
        LastTime = -1
      },
      [2] = T.RT_488,
      [3] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill02Off",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210251
  },
  [210252] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ReSetQueenLocation",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210252
  },
  [210253] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Sphere_Xlarge",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_4,
      [3] = {
        BossValue = 120,
        CauseHit = "HitFly_XY0Z800",
        Function = "CutToughness",
        Value = 120
      },
      [4] = T.RT_5
    },
    TaskId = 210253
  },
  [210254] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 99,
        MaxSummonCount = 9,
        SetInt = T.RT_487,
        SingleSummonCount = 1,
        UnitId = 210202,
        UnitType = "Monster"
      }
    },
    TaskId = 210254
  },
  [210262] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "RemoveUnit",
        Num = 1,
        UnitId = 210202
      }
    },
    TaskId = 210262
  },
  [210263] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 210101,
        Function = "CreateUnit",
        LifeTime = 99,
        MaxSummonCount = 9,
        SetInt = T.RT_487,
        SingleSummonCount = "$Source:GetRootSource():GetInt('PassiveWaitingNum')$",
        UnitId = 210202,
        UnitType = "Monster"
      },
      [2] = {Function = "AddBullet", Value = 50}
    },
    TaskId = 210263
  },
  [210264] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "PassiveAdditionalSummon",
        PassiveEffectId = 210201
      }
    },
    TaskId = 210264
  },
  [230111] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "MySummoned",
    TargetFilterVars = {Id = 230101},
    TaskEffects = {
      [1] = {
        BuffId = 230110,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 230111
  },
  [230112] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 230101,
        Function = "AddBuff",
        LastTime = 8
      }
    },
    TaskId = 230112
  },
  [230113] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 230102,
        Function = "AddBuff",
        LastTime = 8
      }
    },
    TaskId = 230113
  },
  [230121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230102,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 18,
        SingleSummonCount = 3,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230121
  },
  [230122] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230103,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 18,
        SingleSummonCount = 3,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230122
  },
  [230123] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230104,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 18,
        SingleSummonCount = 3,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230123
  },
  [230124] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230102,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 24,
        SingleSummonCount = 4,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230124
  },
  [230125] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230103,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 24,
        SingleSummonCount = 4,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230125
  },
  [230126] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230104,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 24,
        SingleSummonCount = 4,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230126
  },
  [230130] = {
    TargetFilter = "Zhangyu_TentacleBirth",
    TaskEffects = {
      [1] = {
        BossValue = 65,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 65
      },
      [2] = {FXId = 230102, Function = "PlayFX"},
      [3] = {Function = "PlaySE", SEId = 230101}
    },
    TaskId = 230130
  },
  [230131] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230101,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 18,
        RefreshRule = "Block",
        SingleSummonCount = 1,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230131
  },
  [230132] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 230101,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 24,
        RefreshRule = "Block",
        SingleSummonCount = 1,
        UnitId = 230101,
        UnitType = "Monster"
      }
    },
    TaskId = 230132
  },
  [230133] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_494,
      [2] = {
        BossValue = 3,
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 15
      }
    },
    TaskId = 230133
  },
  [230134] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_430,
    TaskId = 230134
  },
  [230135] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Zhangyu_TentacleAttackSp",
    TaskEffects = {
      [1] = T.RT_494,
      [2] = {
        BossValue = 3,
        CauseHit = "LightHit_100_F",
        Function = "CutToughness",
        Value = 15
      }
    },
    TaskId = 230135
  },
  [240103] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Default",
        Function = "Heal",
        Rate = "#1",
        Value = 5
      },
      [2] = {Function = "AddSp", SpChange = 12},
      [3] = {
        BaseChar = "Target",
        Delay = 0.15,
        FXId = 6,
        Function = "PlayFX"
      },
      [4] = T.RT_492
    },
    TaskId = 240103
  },
  [240111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 240101,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 2,
        SingleSummonCount = 1,
        UnitId = 240101,
        UnitType = "Monster"
      }
    },
    TaskId = 240111
  },
  [240112] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FixLocation = true,
        FormationId = 240101,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 240101,
        UnitType = "Monster"
      }
    },
    TaskId = 240112
  },
  [240113] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FormationId = 240101,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 2,
        SingleSummonCount = 1,
        UnitId = 240101,
        UnitType = "Monster",
        UseSaveLoc = "BaihengSkill01"
      }
    },
    TaskId = 240113
  },
  [240114] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        FormationId = 240101,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 240101,
        UnitType = "Monster",
        UseSaveLoc = "BaihengSkill01"
      }
    },
    TaskId = 240114
  },
  [240121] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = T.RT_495,
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "AddbuffSkillintensity",
        PassiveEffectId = 240101
      }
    },
    TaskId = 240121
  },
  [240122] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_495,
      [2] = {
        BuffId = 240123,
        Condition = 96,
        Function = "AddBuff",
        LastTime = 12
      },
      [3] = {
        BuffId = 240124,
        Condition = 76,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 240122
  },
  [240123] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 100,
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_412
    },
    TaskId = 240123
  },
  [240141] = {
    AllowSkillRangeModify = true,
    EffectExecuteTiming = "Enter",
    ExtraBPFilter = "Char_Baiheng_Skill01",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_483,
      [2] = {
        BossValue = 1,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 15
      },
      [3] = {
        AimTarget = true,
        FXId = 240101,
        Function = "PlayFX",
        IsAttached = true
      },
      [4] = {
        FXId = 240105,
        Function = "PlayFX",
        FxRotator = T.RT_193,
        IsFaceToChar = true
      }
    },
    TaskId = 240141
  },
  [240142] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 240102, Function = "PlayFX"}
    },
    TaskId = 240142
  },
  [304100] = {
    TargetFilter = "BossOnline_Skill20Cylinder1",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 10
      },
      [2] = T.RT_497
    },
    TaskId = 304100
  },
  [304101] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 30401,
        Function = "RemoveDanmaku"
      }
    },
    TaskId = 304101
  },
  [304102] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_SPTarget01",
    TaskEffects = T.RT_503,
    TaskId = 304102
  },
  [304103] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_SPTarget02",
    TaskEffects = T.RT_503,
    TaskId = 304103
  },
  [304104] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_SPTarget03",
    TaskEffects = T.RT_503,
    TaskId = 304104
  },
  [310111] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_XLarge120",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BaseAttr = "ATK_Ultra",
        BuffId = "$Source:GetRootSource():GetInt('Skill1Buff')$",
        Function = "AddBuff",
        LastTime = 8
      },
      [3] = {
        BossValue = 95,
        CauseHit = "HitFly_XY200Z500_F",
        Function = "CutToughness",
        Value = 15
      },
      [4] = {FXId = 310111, Function = "PlayFX"},
      [5] = T.RT_152,
      [6] = T.RT_524
    },
    TaskId = 310111
  },
  [310114] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        FXId = 310104,
        Function = "PlayFX"
      },
      [2] = {
        BossValue = 45,
        CauseHit = "HitFly_XY200Z500_F",
        Delay = 0.05,
        Function = "CutToughness",
        Value = 30
      }
    },
    TaskId = 310114
  },
  [310120] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 310120,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 310120
  },
  [310121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 310122,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 310121
  },
  [310122] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 310121,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 310122
  },
  [310123] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 310122, Function = "RemoveBuff"},
      [2] = {BuffId = 310120, Function = "RemoveBuff"},
      [3] = {BuffId = 310121, Function = "RemoveBuff"},
      [4] = {BuffId = 310124, Function = "RemoveBuff"}
    },
    TaskId = 310123
  },
  [310131] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_525,
    TargetFilter = "Linen_Skill02",
    TaskEffects = {
      [1] = {
        Function = "SetFloat",
        Key = "LinenSkill02ShootRate",
        Value = "#1"
      },
      [2] = {
        BaseAttr = "ATK_Ultra",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = "$Source:GetFloat('LinenSkill02ShootRate')*Source:GetCurrentWeaponAttr('MultiShoot', 1)$"
      },
      [3] = {
        BaseChar = "Target",
        FXId = 310111,
        Function = "PlayFX"
      },
      [4] = {
        BossValue = 17,
        CauseHit = "RangedWeapon_Common",
        Function = "CutToughness",
        Value = 1
      },
      [5] = {
        AnimName = "OpenFire",
        Function = "PlayUIAnim",
        UIName = "UISkill2Linen"
      },
      [6] = T.RT_524
    },
    TaskId = 310131
  },
  [310201] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_526,
      [2] = {
        FXId = 310213,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310201
  },
  [310202] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AllowSkillSustain = 1,
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 6,
        SingleSummonCount = 1,
        UnitId = 310202,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 310202
  },
  [310203] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_XLarge",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill2",
          "XierSkill2"
        },
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_527,
      [3] = {
        BossValue = 47,
        CauseHit = "HitFly_XY200Z300",
        Delay = 0.2,
        Function = "CutToughness",
        Value = 33
      },
      [4] = T.RT_413,
      [5] = T.RT_528,
      [6] = T.RT_119
    },
    TaskId = 310203
  },
  [310204] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 310201,
        UnitType = "Monster"
      }
    },
    TaskId = 310204
  },
  [310205] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "FunnelCreate",
        PassiveEffectId = 310201
      }
    },
    TaskId = 310205
  },
  [310211] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 310201,
        Function = "CreateSkillCreature"
      },
      [2] = {
        FXId = 310202,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310211
  },
  [310212] = {
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Target",
    TaskEffects = T.RT_530,
    TaskId = 310212
  },
  [310213] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 310213
  },
  [310214] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_531,
      [2] = {
        FXId = 310215,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310214
  },
  [310215] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_531,
      [2] = {
        FXId = 310216,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310215
  },
  [310216] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill1",
          "XierSkill1Laser"
        },
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        BossValue = 5,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 33
      },
      [3] = {Function = "PlaySE", SEId = 310201},
      [4] = T.RT_119,
      [5] = T.RT_413
    },
    TaskId = 310216
  },
  [310217] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 310202,
        Function = "CreateSkillCreature"
      },
      [2] = {
        FXId = 310206,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310217
  },
  [310218] = {
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Target",
    TaskEffects = T.RT_530,
    TaskId = 310218
  },
  [310219] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_526,
      [2] = {
        FXId = 310214,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310219
  },
  [310221] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        MaxSummonCount = 2,
        SingleSummonCount = 2,
        UnitId = 310201,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 310221
  },
  [310222] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 310207,
        Function = "PlayFX",
        IsAttached = true
      },
      [2] = {
        AimTarget = true,
        FXId = 310208,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 310222
  },
  [310311] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "BombCreate",
        PassiveEffectId = 310301
      }
    },
    TaskId = 310311
  },
  [310312] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = 2,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310301,
        UnitType = "Monster"
      }
    },
    TaskId = 310312
  },
  [310313] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Yeer_Skill01_Enemy",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 120,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 120
      },
      [3] = T.RT_175,
      [4] = T.RT_532,
      [5] = T.RT_413
    },
    TaskId = 310313
  },
  [310314] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = 2,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 310302,
        UnitType = "Monster"
      }
    },
    TaskId = 310314
  },
  [310315] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Yeer_Skill01_Enemy",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 20,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 20
      },
      [3] = T.RT_175,
      [4] = T.RT_532,
      [5] = T.RT_413
    },
    TaskId = 310315
  },
  [310316] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 310303,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 310316
  },
  [310317] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 310303, Function = "RemoveBuff"}
    },
    TaskId = 310317
  },
  [310321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 310301,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        AllowSkillSustain = 1,
        AttrRates = T.RT_1,
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 15,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 310303,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 310321
  },
  [310322] = {
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Sphere_Xlarge",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill2",
          "YeerSkill2Bomb"
        },
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        BossValue = 70,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 25
      },
      [3] = T.RT_175,
      [4] = {
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 1000,
        ShakeClass = "BP_Camera_Yeer_Explode_Heavy"
      },
      [5] = T.RT_413
    },
    TaskId = 310322
  },
  [310323] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "RemoveUnit", UnitId = 310303},
      [2] = {FXId = 310321, Function = "PlayFX"}
    },
    TaskId = 310323
  },
  [310331] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_413
    },
    TaskId = 310331
  },
  [310341] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Yeer_Skill01_Enemy",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 120,
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 120
      },
      [3] = T.RT_175,
      [4] = {
        FXId = 2030102,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 310341
  },
  [320111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BuffId = 320111,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 320111
  },
  [320112] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_180,
        DamageType = "Fire",
        Function = "Damage",
        Rate = "#1",
        Value = "#2"
      },
      [2] = {
        BossValue = 23,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 10
      },
      [3] = {
        FXId = 320101,
        Function = "PlayFX",
        NormalToHit = true
      },
      [4] = T.RT_413,
      [5] = {Function = "PlaySE", SEId = 320104}
    },
    TaskId = 320112
  },
  [320123] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_XLarge",
    TaskEffects = {
      [1] = T.RT_533,
      [2] = T.RT_534,
      [3] = T.RT_535,
      [4] = T.RT_413,
      [5] = T.RT_536
    },
    TaskId = 320123
  },
  [320124] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_XLarge",
    TaskEffects = {
      [1] = T.RT_533,
      [2] = T.RT_534,
      [3] = T.RT_535,
      [4] = T.RT_413,
      [5] = {FXId = 320111, Function = "PlayFX"},
      [6] = T.RT_536
    },
    TaskId = 320124
  },
  [320212] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ExecuteSkill01",
        PassiveEffectId = 320201
      }
    },
    TaskId = 320212
  },
  [320215] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_220,
      [2] = T.RT_189,
      [3] = {FXId = 320204, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 320209}
    },
    TaskId = 320215
  },
  [320222] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 320203,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 320222
  },
  [320223] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 320203, Function = "RemoveBuff"}
    },
    TaskId = 320223
  },
  [320231] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = T.RT_537,
      [2] = {
        AutoAttach = 1,
        CreatureId = 320203,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          70
        }
      },
      [3] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "DissEffectCreature02"
      }
    },
    TaskId = 320231
  },
  [320232] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = T.RT_537,
      [2] = {
        AutoAttach = 1,
        CreatureId = 320202,
        Function = "CreateSkillCreature",
        Location = {
          -20,
          0,
          50
        }
      },
      [3] = {
        AutoAttach = 1,
        CreatureId = 320202,
        Function = "CreateSkillCreature",
        Location = {
          -30,
          0,
          60
        }
      },
      [4] = T.RT_539,
      [5] = T.RT_539,
      [6] = T.RT_539,
      [7] = T.RT_539,
      [8] = T.RT_539,
      [9] = {
        AutoAttach = 1,
        CreatureId = 320202,
        Function = "CreateSkillCreature",
        Location = {
          -10,
          0,
          40
        }
      }
    },
    TaskId = 320232
  },
  [320233] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "CreateEffectCreature01"
      }
    },
    TaskId = 320233
  },
  [320234] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "CreateEffectCreature02"
      }
    },
    TaskId = 320234
  },
  [320235] = {
    EffectExecuteTiming = "Leave",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "DissEffectCreature"
      }
    },
    TaskId = 320235
  },
  [320236] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Skill",
          "Skill2",
          "KamiPassive"
        },
        Function = "Damage",
        Rate = 0.15
      },
      [2] = T.RT_457,
      [3] = T.RT_119,
      [4] = {
        BuffId = 320201,
        Function = "AddBuff",
        LastTime = -1
      },
      [5] = {FXId = 320205, Function = "PlayFX"},
      [6] = {Function = "PlaySE", SEId = 320208}
    },
    TaskId = 320236
  },
  [320241] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_491,
      [2] = T.RT_492,
      [3] = {BuffId = 320205, Function = "RemoveBuff"},
      [4] = {BuffId = 320206, Function = "RemoveBuff"}
    },
    TaskId = 320241
  },
  [320242] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_540,
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_189,
      [3] = T.RT_541
    },
    TaskId = 320242
  },
  [320243] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_540,
        Function = "Damage",
        Rate = 1.3
      },
      [2] = T.RT_189,
      [3] = T.RT_541
    },
    TaskId = 320243
  },
  [330111] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Common_Random",
    HatredIncrement = 40,
    NotifyName = T.RT_12,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_548,
    TaskId = 330111
  },
  [330112] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Maer_Skill01",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_550,
    TaskId = 330112
  },
  [330114] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Common_Random",
    HatredIncrement = 40,
    NotifyName = T.RT_12,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_548,
    TaskId = 330114
  },
  [330115] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Maer_Skill01",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_550,
    TaskId = 330115
  },
  [330116] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "AddSp",
        Reason = "Skill1",
        SkillEfficiency = 1,
        SpChange = -10
      }
    },
    TaskId = 330116
  },
  [330121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 330111,
        Function = "CreateSkillCreature",
        Rotation = T.RT_193,
        Scale = T.RT_473
      },
      [2] = {
        CreatureId = 330111,
        Function = "CreateSkillCreature",
        Rotation = T.RT_144,
        Scale = T.RT_473
      },
      [3] = {
        CreatureId = 330111,
        Function = "CreateSkillCreature",
        Rotation = T.RT_143,
        Scale = T.RT_473
      }
    },
    TaskId = 330121
  },
  [330123] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    ReplaceEffectParam = {
      Condition = 330111,
      SkillEffect = {330124}
    },
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 60,
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 30
      },
      [3] = {FXId = 330101, Function = "PlayFX"},
      [4] = T.RT_551,
      [5] = {
        FeedbackPath = "FE_ExtraLight_L",
        Function = "PlayForceFeedback",
        Tag = "Hit"
      }
    },
    TaskId = 330123
  },
  [330124] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_552,
      [3] = {FXId = 330102, Function = "PlayFX"},
      [4] = T.RT_551
    },
    TaskId = 330124
  },
  [330125] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_210
    },
    TaskId = 330125
  },
  [330126] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_552,
      [3] = {FXId = 330103, Function = "PlayFX"},
      [4] = {
        Falloff = 0.1,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 2000,
        ShakeClass = "BP_CS_Maer_Hit02"
      }
    },
    TaskId = 330126
  },
  [330127] = {
    ReplaceEffectParam = {
      Condition = 74,
      SkillEffect = {330131}
    },
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Condition = 330112,
        CreatureId = 330112,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 330127
  },
  [330128] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Condition = 330113,
        CreatureId = 330113,
        Function = "CreateSkillCreature",
        Location = {
          150,
          0,
          0
        }
      }
    },
    TaskId = 330128
  },
  [330129] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Condition = 330113,
        CreatureId = 330114,
        Function = "CreateSkillCreature",
        Location = {
          -150,
          0,
          0
        }
      }
    },
    TaskId = 330129
  },
  [330130] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "SetSkill02Level",
        PassiveEffectId = 330101
      }
    },
    TaskId = 330130
  },
  [330131] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Condition = 330112,
        CreatureId = 330115,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 330131
  },
  [410112] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "LaunchHook"
      }
    },
    TaskId = 410112
  },
  [410113] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "WithdrawHook"
      }
    },
    TaskId = 410113
  },
  [410114] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_583,
      [3] = T.RT_123,
      [4] = T.RT_286,
      [5] = T.RT_287
    },
    TaskId = 410114
  },
  [410115] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = T.RT_583,
      [3] = T.RT_123,
      [4] = T.RT_286,
      [5] = T.RT_584
    },
    TaskId = 410115
  },
  [410116] = {
    NotifyName = T.RT_9,
    ReplaceEffectParam = {
      Condition = 410103,
      SkillEffect = {410117}
    },
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 410101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410116
  },
  [410117] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 410102,
        Function = "CreateSkillCreature"
      },
      [2] = {
        BuffId = 410102,
        Function = "AddBuff",
        LastTime = 9
      }
    },
    TaskId = 410117
  },
  [410118] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 410101,
        Function = "RemoveSkillCreature"
      },
      [2] = {
        CreatureId = 410102,
        Function = "RemoveSkillCreature"
      },
      [3] = {BuffId = 410101, Function = "RemoveBuff"}
    },
    TaskId = 410118
  },
  [410119] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 410112,
        Function = "AddBuff",
        LastTime = 1.1
      }
    },
    TaskId = 410119
  },
  [410121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 410111,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        BuffId = 410123,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 410121
  },
  [410122] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BuffId = 410121,
        Function = "AddBuff",
        LastTime = 6
      },
      [3] = T.RT_583,
      [4] = T.RT_585,
      [5] = T.RT_123
    },
    TaskId = 410122
  },
  [410123] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BuffId = 410122,
        Function = "AddBuff",
        LastTime = 6
      },
      [3] = T.RT_583,
      [4] = T.RT_585,
      [5] = T.RT_123
    },
    TaskId = 410123
  },
  [410124] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_583,
      [3] = T.RT_585,
      [4] = T.RT_123
    },
    TaskId = 410124
  },
  [410125] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_586,
    TaskId = 410125
  },
  [410126] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = T.RT_123,
      [3] = {FXId = 410127, Function = "PlayFX"},
      [4] = {
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 90
      },
      [5] = T.RT_584
    },
    TaskId = 410126
  },
  [410131] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 410111, Function = "RemoveBuff"},
      [2] = {BuffId = 410123, Function = "RemoveBuff"},
      [3] = {
        FXId = 410131,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 410131
  },
  [410141] = {
    TargetFilter = "Char_Sphere_Small_Trgt",
    TaskEffects = T.RT_586,
    TaskId = 410141
  },
  [410211] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 410201,
        Function = "CreateSkillCreature",
        Location = T.RT_587
      }
    },
    TaskId = 410211
  },
  [410212] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 410201,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 410212
  },
  [410213] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 40,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {
        Delay = 0.07,
        Falloff = 0.1,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 500,
        ShakeClass = "BP_Camera_Zhiliu_Skill02"
      },
      [4] = T.RT_588
    },
    TaskId = 410213
  },
  [410214] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 82,
        CauseHit = "HitFly_XY400Z300",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_588
    },
    TaskId = 410214
  },
  [410215] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 410202,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        AllowSkillIntensity = 1,
        BaseAttr = "MaxES",
        BaseChar = "Target",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = 0.04
      },
      [3] = {
        BuffId = 410251,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 410215
  },
  [410216] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CanBeScaled = true,
        FXId = 410202,
        Function = "PlayFX",
        IsAttached = 1
      }
    },
    TaskId = 410216
  },
  [410221] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 410211,
        Function = "CreateSkillCreature",
        Location = T.RT_587
      }
    },
    TaskId = 410221
  },
  [410222] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 89,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {
        Falloff = 0.1,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 1500,
        ShakeClass = "BP_Camera_Zhiliu_Skill02"
      },
      [4] = {Function = "PlaySE", SEId = 410209}
    },
    TaskId = 410222
  },
  [410223] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 410201,
        Function = "PlayFX",
        IsAttached = 1
      },
      [2] = {
        CanBeScaled = true,
        FXId = 410204,
        Function = "PlayFX",
        IsAttached = 1
      }
    },
    TaskId = 410223
  },
  [410225] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 105,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 25
      },
      [3] = {Function = "PlaySE", SEId = 410212}
    },
    TaskId = 410225
  },
  [410226] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 410231,
        Function = "AddBuff",
        LastTime = 24
      }
    },
    TaskId = 410226
  },
  [410227] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "OnZhiliuMarkRemove",
        PassiveEffectId = 410201
      }
    },
    TaskId = 410227
  },
  [410231] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK_Char",
        CreatureId = 410231,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTT"
      },
      [2] = {
        CreatureId = 410232,
        Delay = 0.16,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTT"
      },
      [3] = {
        CreatureId = 410233,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTT"
      }
    },
    TaskId = 410231
  },
  [410232] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Zhiliu_TT",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 90,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {Function = "PlaySE", SEId = 410208}
    },
    TaskId = 410232
  },
  [410233] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CanBeScaled = true,
        FXId = 410224,
        Function = "PlayFX",
        IsAttached = 1
      },
      [2] = {
        FXId = 410220,
        Function = "PlayFX",
        IsAttached = 1
      },
      [3] = {
        CreatureId = 410230,
        Function = "CreateSkillCreature"
      },
      [4] = {
        FXId = 410225,
        Function = "PlayFX",
        IsAttached = 1
      }
    },
    TaskId = 410233
  },
  [410234] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Zhiliu_TT",
    TaskEffects = {
      [1] = {
        CreatureId = 410233,
        Function = "RemoveSkillCreature"
      },
      [2] = {BuffId = 410252, Function = "RemoveBuff"}
    },
    TaskId = 410234
  },
  [410235] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 410226,
        Function = "PlayFX",
        IsAttached = 1
      },
      [2] = {
        FXId = 410227,
        Function = "PlayFX",
        IsAttached = 1
      }
    },
    TaskId = 410235
  },
  [410236] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Zhiliu_TT",
    TaskEffects = {
      [1] = {
        BuffId = 410252,
        Function = "AddBuff",
        LastTime = 0.2
      }
    },
    TaskId = 410236
  },
  [410240] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        FormationId = 410201,
        Function = "CreateUnit",
        LifeTime = 7.8,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 410201,
        UnitType = "Monster"
      }
    },
    TaskId = 410240
  },
  [410241] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK_Char",
        CreatureId = 410221,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTD"
      },
      [2] = T.RT_589,
      [3] = T.RT_590,
      [4] = {
        ATKBase = "ATK_Char",
        CreatureId = 410224,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTD"
      }
    },
    TaskId = 410241
  },
  [410242] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 410220,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410242
  },
  [410243] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 25,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_591
    },
    TaskId = 410243
  },
  [410244] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 410213, Function = "PlayFX"},
      [2] = {
        CanBeScaled = true,
        FXId = 410216,
        Function = "PlayFX"
      },
      [3] = T.RT_592
    },
    TaskId = 410244
  },
  [410245] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 100,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_591
    },
    TaskId = 410245
  },
  [410246] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreateWithoutTarget = false,
        CreatureId = 410226,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410246
  },
  [410247] = {
    SkillEffectSourceFlag = "RootSource",
    TaskEffects = {
      [1] = T.RT_593,
      [2] = T.RT_594,
      [3] = {
        ATKBase = "ATK_Char",
        CreatureId = 410225,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410247
  },
  [410248] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_598,
    TaskId = 410248
  },
  [410249] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreateWithoutTarget = false,
        CreatureId = 410227,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410249
  },
  [410250] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_598,
    TaskId = 410250
  },
  [410251] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 410241,
        Function = "AddBuff",
        LastTime = 16
      }
    },
    TaskId = 410251
  },
  [410252] = {
    TaskEffects = {
      [1] = T.RT_594
    },
    TaskId = 410252
  },
  [410260] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        FormationId = 410201,
        Function = "CreateUnit",
        LifeTime = 7.8,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 410202,
        UnitType = "Monster"
      }
    },
    TaskId = 410260
  },
  [410261] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK_Char",
        CreatureId = 410241,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTD"
      },
      [2] = T.RT_589,
      [3] = T.RT_590,
      [4] = {
        ATKBase = "ATK_Char",
        CreatureId = 410244,
        Function = "CreateSkillCreature",
        UseSaveLoc = "ZhiliuTD"
      }
    },
    TaskId = 410261
  },
  [410262] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 410240,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410262
  },
  [410264] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 410233, Function = "PlayFX"},
      [2] = {
        CanBeScaled = true,
        FXId = 410236,
        Function = "PlayFX"
      },
      [3] = T.RT_592
    },
    TaskId = 410264
  },
  [410267] = {
    SkillEffectSourceFlag = "RootSource",
    TaskEffects = {
      [1] = T.RT_593,
      [2] = T.RT_594,
      [3] = {
        ATKBase = "ATK_Char",
        CreatureId = 410245,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 410267
  },
  [420111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_602,
      [2] = {
        BuffId = 420114,
        Condition = 420102,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 420111
  },
  [420112] = {
    AllowSkillRangeModify = true,
    EffectExecuteTiming = "Enter",
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BossValue = 30,
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 33
      }
    },
    TaskId = 420112
  },
  [420113] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 420101,
        DefaultLocationOffset = T.RT_193,
        Delay = 0.1,
        Function = "CreateSkillCreature"
      },
      [2] = {
        Delay = 0.1,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 600,
        ShakeClass = "BP_CS_YM_Skill01"
      }
    },
    TaskId = 420113
  },
  [420114] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 420101,
        DefaultLocationOffset = T.RT_193,
        Delay = 0.3,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 420114
  },
  [420115] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 420101,
        DefaultLocationOffset = T.RT_193,
        Delay = 0.5,
        Function = "CreateSkillCreature"
      },
      [2] = {
        Delay = 0.5,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 600,
        ShakeClass = "BP_CS_YM_Skill01"
      }
    },
    TaskId = 420115
  },
  [420116] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 420101,
        DefaultLocationOffset = T.RT_193,
        Delay = 0.7,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 420116
  },
  [420117] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 420101,
        DefaultLocationOffset = T.RT_193,
        Delay = 0.9,
        Function = "CreateSkillCreature"
      },
      [2] = {
        Delay = 0.9,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 600,
        ShakeClass = "BP_CS_YM_Skill01"
      }
    },
    TaskId = 420117
  },
  [420118] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_602,
      [2] = {
        BuffCount = 2,
        BuffId = 420114,
        Condition = 420102,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 420118
  },
  [420121] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ATK = 0,
          DEF = 0,
          EnmityValue = 0,
          MaxHp = "#1",
          SkillEfficiency = 0,
          SkillIntensity = 0,
          SkillRange = 0,
          SkillSustain = 0,
          StrongValue = 0
        },
        AutoAttach = 1,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 420101,
        UnitType = "Monster"
      }
    },
    TaskId = 420121
  },
  [420122] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large_Front",
    TaskEffects = {
      [1] = T.RT_210,
      [2] = {
        BossValue = 50,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 33
      },
      [3] = T.RT_603,
      [4] = {
        Condition = 100,
        Dilation = 0,
        Duration = 0.15,
        Function = "HitStop"
      }
    },
    TaskId = 420122
  },
  [420123] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_607,
    TaskId = 420123
  },
  [420124] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_607,
    TaskId = 420124
  },
  [420131] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 30,
        CauseHit = "HitDown",
        Function = "CutToughness",
        Value = 33
      }
    },
    TaskId = 420131
  },
  [420141] = {
    NotifyName = T.RT_218,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 420114, Function = "RemoveBuff"},
      [2] = {
        Dilation = 0.5,
        Duration = 0.15,
        Function = "HitStop"
      },
      [3] = {
        BuffId = 420112,
        Function = "AddBuff",
        LastTime = 8
      }
    },
    TaskId = 420141
  },
  [420142] = {
    NotifyName = T.RT_218,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 420113,
        Function = "AddBuff",
        LastTime = 8
      }
    },
    TaskId = 420142
  },
  [420143] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Acceleration = 50000,
        AccelerationTime = 0.2,
        Angle = 65,
        Function = "AddCharFallSpeed"
      }
    },
    TaskId = 420143
  },
  [420144] = {
    AllowSkillRangeModify = true,
    AttackRangeType = "Normal",
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Condition = 420104,
        DamageTag = T.RT_69,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        BaseAttr = "ATK",
        Condition = 420103,
        DamageTag = T.RT_69,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#2"
      },
      [3] = {
        BossValue = 50,
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 50
      }
    },
    TaskId = 420144
  },
  [420145] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Sphere_Xlarge",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_604,
        Delay = 0.1,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_603,
      [3] = {
        BaseChar = "Self",
        FXId = 420101,
        Function = "PlayFX"
      }
    },
    TaskId = 420145
  },
  [420211] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          DEF = 0.5,
          ES = 0,
          EnmityValue = 0,
          MaxES = 0,
          MaxHp = 1,
          StrongValue = 0
        },
        Function = "CreateUnit",
        MaxSummonCount = 1,
        UnitId = 420201,
        UnitType = "MechanismSummon"
      },
      [2] = {
        BaseAttr = "DEF",
        BuffId = 420211,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 420211
  },
  [420212] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {FXId = 420211, Function = "PlayFX"}
    },
    TaskId = 420212
  },
  [420213] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "RemoveUnit", UnitId = 420201},
      [2] = {BuffId = 420211, Function = "RemoveBuff"}
    },
    TaskId = 420213
  },
  [420214] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "DEF",
        DamageTag = T.RT_180,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1",
        Value = "#2"
      },
      [2] = {
        BossValue = 46,
        CauseHit = "HitFly_XY400Z300",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_603
    },
    TaskId = 420214
  },
  [420221] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 420202,
        Function = "CreateSkillCreature",
        Location = T.RT_98,
        MaxCount = 3
      }
    },
    TaskId = 420221
  },
  [420222] = {
    AllowSkillRangeModify = true,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "AlmostAllFrd_Trgt",
    TaskEffects = {
      [1] = {
        AllowSkillIntensity = 1,
        BaseAttr = "DEF",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = "#1",
        Value = 10
      }
    },
    TaskId = 420222
  },
  [420223] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Char_Sphere_Middle_Trgt",
    TaskEffects = {
      [1] = T.RT_608,
      [2] = {
        BossValue = 16,
        CauseHit = "HitFly_XY200Z300",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 100
      },
      [3] = {
        CanBeScaled = true,
        FXId = 420221,
        Function = "PlayFX"
      },
      [4] = T.RT_603
    },
    TaskId = 420223
  },
  [420224] = {
    AllowSkillRangeModify = true,
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Sphere_Middle_Trgt",
    TaskEffects = {
      [1] = T.RT_608,
      [2] = {
        BossValue = 16,
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 33
      },
      [3] = T.RT_603
    },
    TaskId = 420224
  },
  [420225] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Common_AttrFilter",
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Sphere_Middle_Trgt",
    TargetFilterVars = {ConditionId = 420202},
    TaskEffects = {
      [1] = T.RT_447
    },
    TaskId = 420225
  },
  [420226] = {
    AllowSkillRangeModify = true,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CanBeScaled = true,
        FXId = 420223,
        Function = "PlayFX"
      },
      [2] = {
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 1000,
        ShakeClass = "BP_CS_LD_Skill02"
      }
    },
    TaskId = 420226
  },
  [430111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 430111,
        Function = "CreateSkillCreature",
        Location = {
          0,
          450,
          -90
        },
        MaxCount = 3
      }
    },
    TaskId = 430111
  },
  [430112] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 430112,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        MaxCount = 3
      }
    },
    TaskId = 430112
  },
  [430113] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = {
          "Skill",
          "Skill1",
          "XibiSkill01"
        },
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = "$Source:GetRootSource():GetFloat('Xibi_Skill04_Rate')$",
        Value = "#2"
      },
      [2] = {
        BossValue = 100,
        CauseHit = "HitDown",
        Function = "CutToughness",
        Value = 100
      }
    },
    TaskId = 430113
  },
  [430114] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 430113,
        Function = "CreateSkillCreature",
        MaxCount = 3
      },
      [2] = {
        Condition = 74,
        CreatureId = 430114,
        Function = "CreateSkillCreature",
        MaxCount = 3
      }
    },
    TaskId = 430114
  },
  [430115] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Common_Random",
    ReplaceEffectParam = {
      Condition = 430102,
      SkillEffect = {430116}
    },
    TargetFilter = "CreatureShape",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_609,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = "$Source:GetRootSource():GetFloat('Xibi_Skill04_Rate')$",
        Value = "#2"
      },
      [2] = {
        BossValue = 35,
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 15
      },
      [3] = {
        BaseChar = "Target",
        CreateWithoutTarget = false,
        CreatureId = 430115,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 430115
  },
  [430116] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_613,
    TaskId = 430116
  },
  [430117] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_254,
      [2] = {Function = "PlaySE", SEId = 430102}
    },
    TaskId = 430117
  },
  [430118] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.1,
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill01ConsumeEnergy",
        PassiveEffectId = 430101
      },
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "SetRate",
        PassiveEffectId = 430101
      }
    },
    TaskId = 430118
  },
  [430119] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Common_Random",
    ReplaceEffectParam = {
      Condition = 430102,
      SkillEffect = {430120}
    },
    TargetFilter = "CreatureShape",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Condition = 430105,
        DamageTag = T.RT_609,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = "$Source:GetRootSource():GetFloat('Xibi_Skill04_Rate')$",
        Value = "#2"
      },
      [2] = {
        BossValue = 35,
        CauseHit = "LightHit_50",
        Condition = 430105,
        Function = "CutToughness",
        Value = 15
      },
      [3] = {
        BaseChar = "Target",
        Condition = 430105,
        CreateWithoutTarget = false,
        CreatureId = 430116,
        Delay = 0.05,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 430119
  },
  [430120] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_613,
    TaskId = 430120
  },
  [430121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          DEF = 0,
          ES = 0,
          EnmityValue = 0,
          MaxES = 0,
          MaxHp = 100000,
          SkillIntensity = 0,
          StrongValue = 0
        },
        Camp = "Enemy",
        FixLocation = true,
        FormationId = 430101,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 430101,
        UnitType = "Monster"
      }
    },
    TaskId = 430121
  },
  [430122] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_615,
    TaskId = 430122
  },
  [430123] = {
    AllowSkillRangeModify = true,
    ExtraBPFilter = "Xibi_Skill02",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TargetFilterVars = {Id = 430101},
    TaskEffects = {
      [1] = T.RT_614,
      [2] = T.RT_616,
      [3] = {FXId = 430153, Function = "PlayFX"},
      [4] = {FXId = 430152, Function = "PlayFX"}
    },
    TaskId = 430123
  },
  [430125] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_615,
    TaskId = 430125
  },
  [430151] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 430122,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        AimTarget = true,
        FXId = 430151,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 430151
  },
  [430155] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_243,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = "#1",
        TriggerProbability = 1,
        Value = "#2"
      },
      [2] = {
        BossValue = 23,
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 33
      },
      [3] = T.RT_254,
      [4] = {
        BaseChar = "Target",
        CreatureId = 430102,
        DefaultLocationOffset = T.RT_193,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 430155
  },
  [510101] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_621,
      [2] = T.RT_622,
      [3] = T.RT_623,
      [4] = T.RT_624,
      [5] = T.RT_625
    },
    TaskId = 510101
  },
  [510102] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_621,
      [2] = T.RT_622,
      [3] = T.RT_623,
      [4] = {FXId = 510101, Function = "PlayFX"},
      [5] = T.RT_624,
      [6] = T.RT_625
    },
    TaskId = 510102
  },
  [510103] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Delay = 0.05,
        Function = "SpawnDrop",
        UnitId = 1003,
        UnitType = "Drop"
      }
    },
    TaskId = 510103
  },
  [510111] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 510131,
        Function = "CreateSkillCreature",
        Location = {
          30,
          25,
          36
        }
      }
    },
    TaskId = 510111
  },
  [510113] = {
    AllowSkillRangeModify = true,
    EffectExecuteTiming = "Enter",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_621,
      [2] = {
        BossValue = 56,
        CauseHit = "HitFly_Force_Songlu",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {
        BaseChar = "Self",
        FXId = 510121,
        Function = "PlayFX"
      },
      [4] = T.RT_624,
      [5] = T.RT_625
    },
    TaskId = 510113
  },
  [510114] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 510101,
        Function = "AddBuff",
        LastTime = 6
      },
      [2] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.016,
        Value = 30
      }
    },
    TaskId = 510114
  },
  [510115] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "StartDash",
        PassiveEffectId = 510102
      },
      [2] = {
        CreatureId = 510102,
        Function = "CreateSkillCreature",
        Location = {
          0,
          50,
          30
        }
      }
    },
    TaskId = 510115
  },
  [510116] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "StopDash",
        PassiveEffectId = 510102
      },
      [2] = {
        CreatureId = 510102,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 510116
  },
  [510117] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "OnSummonHitWall",
        PassiveEffectId = 510102
      }
    },
    TaskId = 510117
  },
  [510121] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ES = 0,
          EnmityValue = 0,
          MaxES = 0,
          MaxHp = 100,
          StrongValue = 0
        },
        AutoAttach = 1,
        FormationId = 510102,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 510101,
        UnitType = "Monster"
      }
    },
    TaskId = 510121
  },
  [510122] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "RemoveUnit", UnitId = 510101},
      [2] = {BuffId = 510121, Function = "RemoveBuff"}
    },
    TaskId = 510122
  },
  [510123] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        CreatureId = 510131,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          36
        }
      }
    },
    TaskId = 510123
  },
  [510124] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 510101,
        Function = "CreateSkillCreature",
        MaxCount = 1
      }
    },
    TaskId = 510124
  },
  [510125] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 510101,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 510125
  },
  [510126] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_40,
        DamageType = "Wind",
        Function = "Damage",
        Rate = "#1",
        Value = "#2"
      },
      [2] = {
        BossValue = 14,
        CauseHit = "HitFly_XY1000Z500",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_624,
      [4] = T.RT_625
    },
    TaskId = 510126
  },
  [510127] = {
    TargetFilter = "RootSource",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "OnSkill02Hit",
        PassiveEffectId = 510102,
        Source = "Target"
      },
      [2] = {
        Function = "ExecuteClientPassiveFunction",
        FunctionName = "CameraShake",
        Source = "Target"
      }
    },
    TaskId = 510127
  },
  [510141] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_627,
      [2] = {
        BossValue = 14,
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 40
      },
      [3] = T.RT_42,
      [4] = T.RT_628,
      [5] = T.RT_625
    },
    TaskId = 510141
  },
  [510142] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_627,
      [2] = {
        BossValue = 14,
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 60
      },
      [3] = T.RT_42,
      [4] = T.RT_628,
      [5] = T.RT_625
    },
    TaskId = 510142
  },
  [510151] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 510151
  },
  [510152] = {
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_627,
      [2] = {
        BossValue = 14,
        CauseHit = "HitFly_XY1000Z500",
        Function = "CutToughness",
        Value = 60
      },
      [3] = T.RT_624,
      [4] = T.RT_628,
      [5] = T.RT_625
    },
    TaskId = 510152
  },
  [510211] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 510211,
        Function = "AddBuff",
        LastTime = "#1"
      },
      [2] = T.RT_629
    },
    TaskId = 510211
  },
  [510212] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 510203,
        Function = "PlayFX",
        IsAttached = true
      },
      [2] = {
        Delay = 0.05,
        FXId = 510204,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 510212
  },
  [510213] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 510212,
        Function = "AddBuff",
        LastTime = "#1"
      },
      [2] = T.RT_629
    },
    TaskId = 510213
  },
  [510221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 510201,
        Function = "CallBackSkillCreature"
      }
    },
    TaskId = 510221
  },
  [510222] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "AddShield",
        PassiveEffectId = 510201
      }
    },
    TaskId = 510222
  },
  [510223] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 510222,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      }
    },
    TaskId = 510223
  },
  [510231] = {
    TaskEffects = {
      [1] = {
        CreatureId = 510201,
        Function = "CreateSkillCreature",
        Location = {
          80,
          0,
          0
        },
        MaxCount = 10
      }
    },
    TaskId = 510231
  },
  [510232] = {
    TaskEffects = {
      [1] = {
        CreatureId = 510201,
        Function = "CreateSkillCreature",
        Location = {
          -80,
          0,
          0
        },
        MaxCount = 10
      }
    },
    TaskId = 510232
  },
  [510233] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_243,
        DamageType = "Wind",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = {
        BuffId = 510231,
        Function = "AddBuff",
        LastTime = 15
      },
      [3] = {
        BossValue = 20,
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 20
      },
      [4] = {
        FXId = 510202,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [5] = {Function = "PlaySE", SEId = 510207}
    },
    TaskId = 510233
  },
  [530111] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_631,
      [2] = {
        BuffId = 305,
        Function = "AddBuff",
        LastTime = 0.3
      },
      [3] = T.RT_632,
      [4] = T.RT_262
    },
    TaskId = 530111
  },
  [530112] = {
    TaskEffects = {
      [1] = T.RT_633,
      [2] = T.RT_633,
      [3] = T.RT_634,
      [4] = T.RT_634,
      [5] = T.RT_635,
      [6] = T.RT_635,
      [7] = T.RT_636,
      [8] = T.RT_636
    },
    TaskId = 530112
  },
  [530113] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_637,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = {
        BuffId = 530141,
        Function = "AddBuff",
        LastTime = 1
      }
    },
    TaskId = 530113
  },
  [530114] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_637,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_181,
      [2] = {
        BossValue = 30,
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_42,
      [4] = T.RT_638
    },
    TaskId = 530114
  },
  [530115] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_640,
      [2] = {
        BossValue = 7,
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_364,
      [4] = {
        BuffId = 530102,
        Function = "AddBuff",
        LastTime = 10
      },
      [5] = T.RT_638
    },
    TaskId = 530115
  },
  [530116] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_640,
      [2] = {FXId = 530141, Function = "PlayFX"}
    },
    TaskId = 530116
  },
  [530117] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_631,
      [2] = T.RT_632
    },
    TaskId = 530117
  },
  [530118] = {
    TaskEffects = {
      [1] = T.RT_641,
      [2] = T.RT_641,
      [3] = T.RT_642,
      [4] = T.RT_642,
      [5] = T.RT_643,
      [6] = T.RT_643,
      [7] = T.RT_644,
      [8] = T.RT_644
    },
    TaskId = 530118
  },
  [530119] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Condition = 31,
        Function = "OverrideCharVelocity",
        ServerCatchupTime = 0.5,
        VelocityScale = 2500
      },
      [2] = {
        Condition = 33,
        Function = "OverrideCharVelocity",
        ServerCatchupTime = 0.5,
        VelocityScale = -2000
      },
      [3] = {
        BuffId = 305,
        Function = "AddBuff",
        LastTime = 0.2
      }
    },
    TaskId = 530119
  },
  [530121] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 530100,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        BuffId = 530101,
        Delay = 1.5,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 530121
  },
  [530122] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffType = 530102, Function = "RemoveBuff"},
      [2] = {
        BuffId = 530101,
        Delay = 0.05,
        Function = "RemoveBuff"
      }
    },
    TaskId = 530122
  },
  [530123] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.3,
        LoopShootId = 5301,
        SkillEffect = {530131}
      },
      [2] = T.RT_645
    },
    TaskId = 530123
  },
  [530124] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Saiqi_Skill02_Shoot",
    TaskEffects = {
      [1] = T.RT_646,
      [2] = T.RT_647,
      [3] = {
        FXId = 530107,
        Function = "PlayFX",
        Overlap = true
      },
      [4] = T.RT_42,
      [5] = T.RT_648
    },
    TaskId = 530124
  },
  [530125] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    TargetFilter = "Saiqi_Skill02_Shoot",
    TaskEffects = {
      [1] = T.RT_646,
      [2] = T.RT_647,
      [3] = {
        FXId = 530107,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true
      },
      [4] = T.RT_42,
      [5] = T.RT_648
    },
    TaskId = 530125
  },
  [530126] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 5301
      }
    },
    TaskId = 530126
  },
  [530127] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        FXId = 530171,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true
      },
      [2] = T.RT_648
    },
    TaskId = 530127
  },
  [530128] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "HpConsume",
        Function = "Damage",
        Rate = 0.05
      },
      [2] = {
        BaseAttr = "MaxHp",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = 0.075
      }
    },
    TaskId = 530128
  },
  [530131] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_645,
      [2] = {
        ATKBase = "ATK_Ultra",
        AimSkeletal = "hit1",
        CreatureId = 530121,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        UseSaveLoc = "SaiqiShoot0"
      },
      [3] = T.RT_293,
      [4] = {
        ATKBase = "ATK_Ultra",
        AimSkeletal = "hit1",
        CreatureId = 530122,
        Delay = 0.07,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        UseSaveLoc = "SaiqiShoot1"
      },
      [5] = {
        BaseChar = "Self",
        Delay = 0.07,
        Function = "PlaySE",
        SEId = 530105
      },
      [6] = {
        ATKBase = "ATK_Ultra",
        AimSkeletal = "hit1",
        CreatureId = 530122,
        Delay = 0.15,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        UseSaveLoc = "SaiqiShoot2"
      },
      [7] = {
        BaseChar = "Self",
        Delay = 0.15,
        Function = "PlaySE",
        SEId = 530105
      }
    },
    TaskId = 530131
  },
  [530141] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        Function = "Heal",
        Rate = 0.1
      },
      [2] = {
        BuffId = 530121,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 530141
  },
  [530142] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "FlyingSkill1",
        PassiveEffectId = 530102
      }
    },
    TaskId = 530142
  },
  [540111] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540101,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 540111
  },
  [540112] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill1AddPassive",
        PassiveEffectId = 540101
      }
    },
    TaskId = 540112
  },
  [540113] = {
    AllowSkillRangeModify = true,
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540113,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 540113
  },
  [540121] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = T.RT_649,
      [2] = {
        BuffId = 540121,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 540121
  },
  [540122] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BuffId = 540102,
        Function = "AddBuff",
        LastTime = 12
      },
      [2] = {
        BuffId = 540124,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 540122
  },
  [540123] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill2AddPassive",
        PassiveEffectId = 540101
      }
    },
    TaskId = 540123
  },
  [540124] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = T.RT_649,
      [2] = {
        BuffId = 540122,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 540124
  },
  [540201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540201,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 540201
  },
  [540202] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540202,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 540202
  },
  [540203] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540203,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 540203
  },
  [540211] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_650,
      [2] = T.RT_616,
      [3] = {
        BuffId = 540211,
        Function = "AddBuff",
        LastTime = 12
      },
      [4] = {
        AttrRates = T.RT_1,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 540201,
        UnitType = "Monster"
      }
    },
    TaskId = 540211
  },
  [540212] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        FormationId = 540201,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 540201,
        UnitType = "Monster"
      }
    },
    TaskId = 540212
  },
  [540213] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1,
        FormationId = 540201,
        Function = "CreateUnit",
        LifeTime = 20,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 540201,
        UnitType = "Monster"
      }
    },
    TaskId = 540213
  },
  [540214] = {
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_650,
      [2] = {
        Function = "GatherTargets",
        GatherSpeed = 2000,
        LocationOffset = T.RT_98,
        StopDistance = 50
      }
    },
    TaskId = 540214
  },
  [540221] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540221,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 540221
  },
  [540222] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 540221, Function = "RemoveBuff"}
    },
    TaskId = 540222
  },
  [540231] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxSp",
        Function = "Heal",
        Rate = 1,
        Value = 35
      },
      [2] = T.RT_651
    },
    TaskId = 540231
  },
  [540232] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxSp",
        DamageTag = T.RT_40,
        DamageType = "Wind",
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_616
    },
    TaskId = 540232
  },
  [540241] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = T.RT_652,
    TaskId = 540241
  },
  [540242] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllFrd",
    TaskEffects = T.RT_652,
    TaskId = 540242
  },
  [540251] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 540205,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 540251
  },
  [540252] = {
    AllowSkillRangeModify = true,
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = T.RT_650,
      [2] = T.RT_616,
      [3] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "Skill2ComboRemove",
        PassiveEffectId = 540201
      }
    },
    TaskId = 540252
  },
  [600001] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {Function = "StartAlarm"}
    },
    TaskId = 600001
  },
  [600002] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {Function = "TryAlarm"}
    },
    TaskId = 600002
  },
  [600003] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        Function = "RescueAlert"
      }
    },
    TaskId = 600003
  },
  [600101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_661,
    TaskId = 600101
  },
  [600102] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_661,
    TaskId = 600102
  },
  [600103] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600103
  },
  [600104] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = {FXId = 600103, Function = "PlayFX"}
    },
    TaskId = 600104
  },
  [600105] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 600101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600105
  },
  [600106] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_663,
    TaskId = 600106
  },
  [600107] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_665,
    TaskId = 600107
  },
  [600201] = {
    NotifyName = T.RT_666,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600201,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 600202,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 600203,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600201
  },
  [600202] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 600205,
        Function = "PlayFX"
      }
    },
    TaskId = 600202
  },
  [600203] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600206,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600203
  },
  [600204] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.14
      },
      [2] = T.RT_667,
      [3] = T.RT_668
    },
    TaskId = 600204
  },
  [600205] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_669,
      [2] = T.RT_667,
      [3] = T.RT_668
    },
    TaskId = 600205
  },
  [600206] = {
    TaskEffects = T.RT_672,
    TaskId = 600206
  },
  [600207] = {
    TaskEffects = T.RT_672,
    TaskId = 600207
  },
  [600209] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_661,
    TaskId = 600209
  },
  [600301] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_400_360",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {FXId = 600303, Function = "PlayFX"},
      [3] = T.RT_5
    },
    TaskId = 600301
  },
  [600302] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_800_360_OtFr_01",
    TaskEffects = {
      [1] = T.RT_674,
      [2] = T.RT_522
    },
    TaskId = 600302
  },
  [600303] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_675,
      [2] = T.RT_522
    },
    TaskId = 600303
  },
  [600304] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600301,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600304
  },
  [600305] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {
        FXId = 600305,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 600202}
    },
    TaskId = 600305
  },
  [600306] = {
    TaskEffects = {
      [1] = {
        FXId = 600305,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 600306
  },
  [600401] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_677,
    TaskId = 600401
  },
  [600402] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_677,
    TaskId = 600402
  },
  [600403] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600401,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600403
  },
  [600404] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 3.54
      },
      [2] = T.RT_660,
      [3] = T.RT_678
    },
    TaskId = 600404
  },
  [600405] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_680,
      [3] = T.RT_660,
      [4] = T.RT_678
    },
    TaskId = 600405
  },
  [600406] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600401,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 600406
  },
  [600407] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_681,
      [2] = T.RT_660
    },
    TaskId = 600407
  },
  [600408] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 7
      },
      [2] = T.RT_680,
      [3] = T.RT_660,
      [4] = T.RT_678
    },
    TaskId = 600408
  },
  [600409] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 600409
  },
  [600501] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600501,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600501
  },
  [600502] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_682,
      [3] = {
        FXId = 600502,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 600502
  },
  [600503] = {
    TaskEffects = {
      [1] = {
        FXId = 600506,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 600503
  },
  [600504] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreateDelay = 2,
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 600501,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 5,
        SaveLocTag = "Skill01",
        SaveToSaveLoc = 1,
        SingleSummonCount = 2,
        UnitId = 600501,
        UnitType = "MechanismSummon"
      },
      [2] = {
        CreatureId = 600502,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Skill011"
      },
      [3] = {
        CreatureId = 600502,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Skill012"
      }
    },
    TaskId = 600504
  },
  [600505] = {
    TargetFilter = "Mon_Cylinder_200_40_360_NoMch",
    TaskEffects = {
      [1] = T.RT_682
    },
    TaskId = 600505
  },
  [600506] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 600502,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 600506
  },
  [600507] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 600502, Function = "RemoveBuff"}
    },
    TaskId = 600507
  },
  [600601] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600601,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 600602,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600601
  },
  [600602] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 2.05
      },
      [2] = {
        FXId = 600602,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 600601}
    },
    TaskId = 600602
  },
  [600603] = {
    TaskEffects = {
      [1] = {
        FXId = 600602,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 600603
  },
  [600604] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600603,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 600604
  },
  [600605] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600603,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 600605
  },
  [600606] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_683,
      [2] = T.RT_684,
      [3] = {FXId = 600603, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 600602}
    },
    TaskId = 600606
  },
  [600701] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600701,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600701
  },
  [600702] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {
        FXId = 600702,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_685
    },
    TaskId = 600702
  },
  [600703] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600702,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_686
    },
    TaskId = 600703
  },
  [600704] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 600702,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600704
  },
  [600705] = {
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = T.RT_688,
    TaskId = 600705
  },
  [600706] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_689,
      [3] = T.RT_685
    },
    TaskId = 600706
  },
  [600707] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_690,
      [2] = T.RT_691,
      [3] = T.RT_685
    },
    TaskId = 600707
  },
  [600708] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_691,
      [2] = T.RT_686
    },
    TaskId = 600708
  },
  [600709] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600703,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 600709
  },
  [601101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = {
        AimTarget = true,
        FXId = 601101,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 601101
  },
  [601201] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 601201
  },
  [601202] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601201,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601202
  },
  [601203] = {
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_669,
      [2] = T.RT_697,
      [3] = T.RT_698,
      [4] = T.RT_699
    },
    TaskId = 601203
  },
  [601204] = {
    TaskEffects = {
      [1] = T.RT_697,
      [2] = {
        Function = "PlaySE",
        SEId = 600203,
        SceneSe = true
      }
    },
    TaskId = 601204
  },
  [601205] = {
    NotifyName = T.RT_666,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601202,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601205
  },
  [601206] = {
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_700,
      [2] = T.RT_697,
      [3] = T.RT_698,
      [4] = T.RT_699
    },
    TaskId = 601206
  },
  [601301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        FormationId = 601301,
        Function = "BossSPSaveLocs",
        SetSaveLocs = "bubble"
      }
    },
    TaskId = 601301
  },
  [601302] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        CreatureId = 601301,
        Function = "CreateSkillCreature",
        UseRelativeOffset = true,
        UseSaveLoc = "bubble2"
      },
      [2] = {
        BaseChar = "Target",
        CreatureId = 601301,
        Function = "CreateSkillCreature",
        UseRelativeOffset = true,
        UseSaveLoc = "bubble3"
      }
    },
    TaskId = 601302
  },
  [601303] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {FXId = 601302, Function = "PlayFX"},
      [3] = T.RT_701,
      [4] = T.RT_702
    },
    TaskId = 601303
  },
  [601304] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_500_400_90",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = T.RT_701,
      [3] = T.RT_702
    },
    TaskId = 601304
  },
  [601401] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_676,
      [2] = T.RT_655,
      [3] = T.RT_698,
      [4] = T.RT_5
    },
    TaskId = 601401
  },
  [601402] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_676,
      [2] = T.RT_655,
      [3] = T.RT_698,
      [4] = T.RT_5,
      [5] = T.RT_678
    },
    TaskId = 601402
  },
  [601403] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_680,
      [3] = T.RT_655,
      [4] = T.RT_698
    },
    TaskId = 601403
  },
  [601404] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_680,
      [3] = T.RT_655
    },
    TaskId = 601404
  },
  [601405] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_2500_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_655,
      [3] = {
        BuffId = 30400017,
        Function = "AddBuff",
        LastTime = -1
      },
      [4] = T.RT_678
    },
    TaskId = 601405
  },
  [601406] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_703,
      [2] = T.RT_655
    },
    TaskId = 601406
  },
  [601501] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601501,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601501
  },
  [601502] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {
        FXId = 601502,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_704
    },
    TaskId = 601502
  },
  [601503] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 601502,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 601503
  },
  [601504] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601502,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601504
  },
  [601505] = {
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = {
      [1] = T.RT_687,
      [2] = T.RT_10,
      [3] = T.RT_705
    },
    TaskId = 601505
  },
  [601506] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_689,
      [3] = T.RT_705
    },
    TaskId = 601506
  },
  [601507] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_690,
      [2] = T.RT_706,
      [3] = T.RT_704
    },
    TaskId = 601507
  },
  [601508] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_706
    },
    TaskId = 601508
  },
  [601509] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 601503,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 601509
  },
  [601601] = {
    NotifyName = T.RT_666,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601601,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 601602,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 601603,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601601
  },
  [601602] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 601605,
        Function = "PlayFX"
      }
    },
    TaskId = 601602
  },
  [601603] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601606,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601603
  },
  [601604] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_700,
      [2] = T.RT_707,
      [3] = T.RT_708
    },
    TaskId = 601604
  },
  [601605] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_669,
      [2] = T.RT_707,
      [3] = T.RT_708
    },
    TaskId = 601605
  },
  [601606] = {
    TaskEffects = T.RT_710,
    TaskId = 601606
  },
  [601607] = {
    TaskEffects = T.RT_710,
    TaskId = 601607
  },
  [601609] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_660,
      [3] = {Function = "PlaySE", SEId = 601602}
    },
    TaskId = 601609
  },
  [601701] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_712,
    TaskId = 601701
  },
  [601702] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_712,
    TaskId = 601702
  },
  [601703] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 601701,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601703
  },
  [601704] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = {FXId = 601703, Function = "PlayFX"},
      [3] = {Function = "PlaySE", SEId = 601703}
    },
    TaskId = 601704
  },
  [601705] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 601701,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 601705
  },
  [601706] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_663,
    TaskId = 601706
  },
  [601707] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_665,
    TaskId = 601707
  },
  [700101] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_727,
    TaskId = 700101
  },
  [700102] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_727,
    TaskId = 700102
  },
  [700103] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.75
      },
      [2] = T.RT_728,
      [3] = T.RT_729
    },
    TaskId = 700103
  },
  [700104] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_730,
      [2] = T.RT_731
    },
    TaskId = 700104
  },
  [700106] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 700101,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 700106
  },
  [700107] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 700101,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_726
    },
    TaskId = 700107
  },
  [700108] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 700105,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 700108
  },
  [700109] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_733,
    TaskId = 700109
  },
  [700110] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_733,
    TaskId = 700110
  },
  [700121] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ATK = 1,
          DEF = 1,
          ES = 1,
          Hp = 1,
          MaxES = 1,
          MaxHp = 1
        },
        FixLocation = true,
        FixLocationNav = 1,
        FormationId = 6000005,
        Function = "CreateUnit",
        LifeTime = 12,
        MaxSummonCount = 10,
        SingleSummonCount = 3,
        UnitId = 70010051,
        UnitType = "Monster"
      }
    },
    TaskId = 700121
  },
  [700122] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 700102, Function = "PlayFX"}
    },
    TaskId = 700122
  },
  [700201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_735,
      [3] = T.RT_5
    },
    TaskId = 700201
  },
  [700202] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_737,
      [3] = T.RT_5
    },
    TaskId = 700202
  },
  [700203] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_110,
      [3] = T.RT_738,
      [4] = T.RT_5
    },
    TaskId = 700203
  },
  [700223] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {MaxES = 0.5, MaxHp = 0.5},
        FixLocation = true,
        FixLocationNav = 1,
        FormationId = 700201,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 7006001,
        UnitType = "Monster"
      }
    },
    TaskId = 700223
  },
  [700224] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {MaxES = 0, MaxHp = 0.3},
        FixLocation = true,
        FixLocationNav = 1,
        FormationId = 700202,
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 7007001,
        UnitType = "Monster"
      }
    },
    TaskId = 700224
  },
  [700301] = {
    NotifyName = T.RT_666,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 700301,
        ExtraRotation = 104,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 700301
  },
  [700302] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_739,
      [2] = T.RT_740,
      [3] = T.RT_729
    },
    TaskId = 700302
  },
  [700303] = {
    NotifyName = T.RT_741,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 700302,
        Function = "CreateSkillCreature",
        Location = T.RT_421
      }
    },
    TaskId = 700303
  },
  [700304] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = {FXId = 700304, Function = "PlayFX"},
      [3] = T.RT_742
    },
    TaskId = 700304
  },
  [700305] = {
    NotifyName = T.RT_741,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 700303,
        Function = "CreateSkillCreature",
        Location = T.RT_421
      }
    },
    TaskId = 700305
  },
  [700306] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_732,
      [2] = T.RT_4,
      [3] = T.RT_5
    },
    TaskId = 700306
  },
  [700307] = {
    TargetFilter = "Mon_Sphere_400_360_Fr",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = {
        CauseHit = "HeavyHit_80",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_742
    },
    TaskId = 700307
  },
  [700308] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_733,
    TaskId = 700308
  },
  [700309] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_733,
    TaskId = 700309
  },
  [700312] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_740,
      [2] = T.RT_731
    },
    TaskId = 700312
  },
  [700321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_732,
      [2] = T.RT_4,
      [3] = T.RT_701,
      [4] = T.RT_5
    },
    TaskId = 700321
  },
  [700322] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 700321,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 700322
  },
  [700323] = {
    TargetFilter = "Jt_Ranger_LandMine",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = {"LandMine"},
        Function = "Damage",
        Rate = 7.7
      },
      [2] = T.RT_110,
      [3] = {FXId = 700305, Function = "PlayFX"},
      [4] = T.RT_742,
      [5] = {
        BuffId = 6000113,
        Function = "AddBuff",
        LastTime = 4
      },
      [6] = {Function = "PlaySE", SEId = 700314}
    },
    TaskId = 700323
  },
  [700324] = {
    TargetFilter = "Jt_Ranger_LandMine_Fr",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_110,
      [3] = T.RT_742,
      [4] = {Function = "PlaySE", SEId = 700315}
    },
    TaskId = 700324
  },
  [700401] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_744,
      [3] = T.RT_5
    },
    TaskId = 700401
  },
  [700402] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 700401,
        Function = "CreateSkillCreature",
        Location = T.RT_421
      }
    },
    TaskId = 700402
  },
  [700403] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_39,
      [3] = T.RT_4,
      [4] = T.RT_5
    },
    TaskId = 700403
  },
  [700404] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 700401,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 700404
  },
  [700405] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_745,
      [3] = T.RT_4,
      [4] = T.RT_5
    },
    TaskId = 700405
  },
  [700406] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 700401,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 700406
  },
  [700501] = {
    NotifyName = T.RT_2,
    TargetFilter = "Jt_Commander_Cylinder_1500_500_360",
    TaskEffects = T.RT_747,
    TaskId = 700501
  },
  [700502] = {
    TargetFilter = "Jt_Commander_Cylinder_1500_500_360",
    TaskEffects = T.RT_749,
    TaskId = 700502
  },
  [700503] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_751,
    TaskId = 700503
  },
  [700621] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 700601,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 700621
  },
  [700622] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 700601,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 700622
  },
  [700623] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 700602,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 700623
  },
  [700624] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 700601, Function = "RemoveBuff"}
    },
    TaskId = 700624
  },
  [700721] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = {
      [1] = {
        BuffId = 700701,
        Function = "AddBuff",
        LastTime = 6
      },
      [2] = T.RT_3
    },
    TaskId = 700721
  },
  [700722] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.81
      },
      [2] = T.RT_10,
      [3] = {
        BuffId = 6000114,
        Function = "AddBuff",
        LastTime = 1.5
      },
      [4] = T.RT_742
    },
    TaskId = 700722
  },
  [700723] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 4.5
      }
    },
    TaskId = 700723
  },
  [700731] = {
    NotifyName = T.RT_2,
    TargetFilter = "Jt_BlastRobot_NoTrolly",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_742
    },
    TaskId = 700731
  },
  [700732] = {
    NotifyName = T.RT_2,
    TargetFilter = "Jt_BlastRobot_OnlyTrolly",
    TaskEffects = T.RT_580,
    TaskId = 700732
  },
  [700733] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 700733
  },
  [700741] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360_OtFr",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 510
      },
      [2] = T.RT_110,
      [3] = T.RT_742
    },
    TaskId = 700741
  },
  [700742] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = T.RT_754,
    TaskId = 700742
  },
  [700743] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 700743
  },
  [700751] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360_OtFr",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_110,
      [3] = T.RT_742
    },
    TaskId = 700751
  },
  [700752] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = T.RT_754,
    TaskId = 700752
  },
  [700753] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 700753
  },
  [700801] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_755,
      [3] = T.RT_110
    },
    TaskId = 700801
  },
  [700802] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "upperarm_r",
        CreatureId = 700801,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 700802
  },
  [700803] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_756,
      [3] = T.RT_757,
      [4] = T.RT_490
    },
    TaskId = 700803
  },
  [700804] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_755,
      [3] = T.RT_758
    },
    TaskId = 700804
  },
  [700805] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 700805
  },
  [700806] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_760,
      [2] = T.RT_762,
      [3] = {
        CreatureId = 700802,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "1",
        UseSaveLoc = "6"
      },
      [4] = {
        CreatureId = 700802,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "2",
        UseSaveLoc = "6"
      },
      [5] = {
        CreatureId = 700802,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "3",
        UseSaveLoc = "6"
      },
      [6] = {
        CreatureId = 700802,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "4",
        UseSaveLoc = "6"
      },
      [7] = {
        CreatureId = 700802,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "",
        UseSaveLoc = "6"
      }
    },
    TaskId = 700806
  },
  [700807] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_489,
      [3] = T.RT_763,
      [4] = T.RT_490
    },
    TaskId = 700807
  },
  [700808] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = {
        FXId = 700805,
        Function = "PlayFX",
        NormalToHit = true
      },
      [3] = T.RT_763,
      [4] = T.RT_490
    },
    TaskId = 700808
  },
  [700809] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_650_200_100",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_110,
      [3] = T.RT_490
    },
    TaskId = 700809
  },
  [700810] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "upperarm_r",
        CreatureId = 700803,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 700810
  },
  [700811] = {
    NotifyName = T.RT_2,
    TargetFilter = "Jt_Commander_Cylinder_1500_500_360",
    TaskEffects = T.RT_747,
    TaskId = 700811
  },
  [700812] = {
    TargetFilter = "Jt_Commander_Cylinder_1500_500_360",
    TaskEffects = T.RT_749,
    TaskId = 700812
  },
  [700813] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_751,
    TaskId = 700813
  },
  [700814] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_755,
      [3] = T.RT_701
    },
    TaskId = 700814
  },
  [700815] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_756,
      [3] = T.RT_490
    },
    TaskId = 700815
  },
  [700816] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 700801,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 700816
  },
  [700817] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 700801, Function = "RemoveBuff"}
    },
    TaskId = 700817
  },
  [700901] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_40",
    TaskEffects = T.RT_765,
    TaskId = 700901
  },
  [700902] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_40",
    TaskEffects = T.RT_765,
    TaskId = 700902
  },
  [700903] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_230_200_40",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_660,
      [3] = T.RT_10,
      [4] = {Function = "PlaySE", SEId = 700902}
    },
    TaskId = 700903
  },
  [700904] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 700901,
        Function = "CreateSkillCreature",
        Location = T.RT_766
      }
    },
    TaskId = 700904
  },
  [700905] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 700901,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 700905
  },
  [700906] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_10,
      [3] = T.RT_660,
      [4] = {Function = "PlaySE", SEId = 700903}
    },
    TaskId = 700906
  },
  [701001] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 701001,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 701001
  },
  [701002] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        FXId = 701002,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_767
    },
    TaskId = 701002
  },
  [701003] = {
    TaskEffects = {
      [1] = {
        FXId = 701002,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 701003
  },
  [701004] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 701002,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 701003,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 701004
  },
  [701005] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        FXId = 701004,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_767
    },
    TaskId = 701005
  },
  [701006] = {
    TaskEffects = {
      [1] = {
        FXId = 701004,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 701006
  },
  [701007] = {
    TaskEffects = {
      [1] = {FXId = 701005, Function = "PlayFX"}
    },
    TaskId = 701007
  },
  [701008] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_800_360_OtFr",
    TaskEffects = {
      [1] = T.RT_674,
      [2] = T.RT_768
    },
    TaskId = 701008
  },
  [701009] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_675,
      [2] = T.RT_768
    },
    TaskId = 701009
  },
  [701101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 701101,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 701101
  },
  [701102] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 701101,
        Function = "AddBuff",
        LastTime = 60
      }
    },
    TaskId = 701102
  },
  [701201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_769,
      [2] = T.RT_735,
      [3] = T.RT_5
    },
    TaskId = 701201
  },
  [701202] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_769,
      [2] = T.RT_737,
      [3] = T.RT_5
    },
    TaskId = 701202
  },
  [701203] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_769,
      [2] = T.RT_110,
      [3] = T.RT_738,
      [4] = T.RT_5
    },
    TaskId = 701203
  },
  [701301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 701301,
        ExtraRotation = 104,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 701301
  },
  [701302] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.54
      },
      [2] = T.RT_770,
      [3] = {Function = "PlaySE", SEId = 700322}
    },
    TaskId = 701302
  },
  [701303] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_770
    },
    TaskId = 701303
  },
  [701304] = {
    NotifyName = T.RT_741,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 701302,
        Function = "CreateSkillCreature",
        Location = T.RT_421
      }
    },
    TaskId = 701304
  },
  [701305] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = {FXId = 701303, Function = "PlayFX"},
      [3] = T.RT_742,
      [4] = T.RT_758,
      [5] = {Function = "PlaySE", SEId = 700324}
    },
    TaskId = 701305
  },
  [701401] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_744,
      [3] = T.RT_758,
      [4] = {Function = "PlaySE", SEId = 700401}
    },
    TaskId = 701401
  },
  [701402] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701401,
        Function = "CreateSkillCreature",
        Location = T.RT_421
      }
    },
    TaskId = 701402
  },
  [701403] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701401,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 701403
  },
  [701404] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_681,
      [3] = {
        FXId = 701401,
        Function = "PlayFX",
        IsFaceToChar = true
      },
      [4] = {Function = "PlaySE", SEId = 700402}
    },
    TaskId = 701404
  },
  [701501] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 701501
  },
  [701502] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 701501,
        Function = "CreateSkillCreature",
        Location = T.RT_773,
        SetSavelocAsTarget = ""
      },
      [2] = {
        CreatureId = 701501,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_773,
        SetSavelocAsTarget = ""
      }
    },
    TaskId = 701502
  },
  [701503] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_673,
      [2] = {
        FXId = 701502,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_685
    },
    TaskId = 701503
  },
  [701504] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        FXId = 701502,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_686
    },
    TaskId = 701504
  },
  [701505] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 701502,
        Function = "CreateSkillCreature",
        Location = T.RT_773
      }
    },
    TaskId = 701505
  },
  [701506] = {
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = T.RT_688,
    TaskId = 701506
  },
  [701507] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 15
      },
      [2] = T.RT_689,
      [3] = T.RT_685
    },
    TaskId = 701507
  },
  [701508] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_690,
      [2] = T.RT_774,
      [3] = T.RT_685
    },
    TaskId = 701508
  },
  [701509] = {
    TaskEffects = {
      [1] = T.RT_774
    },
    TaskId = 701509
  },
  [701510] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701503,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 701510
  },
  [701511] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "CorpTarget",
        TargetType = "Target"
      }
    },
    TaskId = 701511
  },
  [701512] = {
    NotifyName = T.RT_9,
    TargetFilter = "RootSource",
    TaskEffects = T.RT_776,
    TaskId = 701512
  },
  [701513] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701504,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 701513
  },
  [701514] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 701501,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 701514
  },
  [701515] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 701501, Function = "RemoveBuff"}
    },
    TaskId = 701515
  },
  [701601] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701601,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 701601
  },
  [701602] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 701601,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 701602
  },
  [701603] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_504,
      [2] = {
        FXId = 701602,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 701601}
    },
    TaskId = 701603
  },
  [701604] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = T.RT_505,
    TaskId = 701604
  },
  [701605] = {
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.1
      },
      [2] = T.RT_620,
      [3] = T.RT_777,
      [4] = {FXId = 701603, Function = "PlayFX"}
    },
    TaskId = 701605
  },
  [701606] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_10,
      [3] = T.RT_777
    },
    TaskId = 701606
  },
  [800101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 800101,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 800101
  },
  [800102] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 800102,
        ExtraRotation = 105,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 800102
  },
  [800103] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_778,
      [2] = T.RT_728,
      [3] = T.RT_779
    },
    TaskId = 800103
  },
  [800104] = {
    TaskEffects = {
      [1] = T.RT_730
    },
    TaskId = 800104
  },
  [800105] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_781,
    TaskId = 800105
  },
  [800106] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_781,
    TaskId = 800106
  },
  [800107] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimTarget = true,
        FXId = 800103,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 800107
  },
  [800108] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_782,
      [2] = T.RT_728,
      [3] = T.RT_779
    },
    TaskId = 800108
  },
  [800201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_200_200_180",
    TaskEffects = T.RT_6,
    TaskId = 800201
  },
  [800202] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_200_200_180",
    TaskEffects = T.RT_6,
    TaskId = 800202
  },
  [800203] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_8,
    TaskId = 800203
  },
  [800204] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_300_200_180_180",
    TaskEffects = T.RT_11,
    TaskId = 800204
  },
  [800205] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_11,
    TaskId = 800205
  },
  [800206] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 800201,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 800206
  },
  [800207] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 800201, Function = "RemoveBuff"}
    },
    TaskId = 800207
  },
  [800208] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 800202,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 800208
  },
  [800209] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 800202, Function = "RemoveBuff"}
    },
    TaskId = 800209
  },
  [800210] = {
    NotifyName = T.RT_13,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_4,
      [3] = T.RT_10,
      [4] = T.RT_5
    },
    TaskId = 800210
  },
  [800211] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000200,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        BuffId = 6000202,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 800211
  },
  [800212] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 6000200, Function = "RemoveBuff"},
      [2] = {BuffId = 6000202, Function = "RemoveBuff"}
    },
    TaskId = 800212
  },
  [800301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 800301,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 800301
  },
  [800302] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        FXId = 800304,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 800301}
    },
    TaskId = 800302
  },
  [800303] = {
    TaskEffects = {
      [1] = {
        FXId = 800304,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 800303
  },
  [800304] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 800302,
        Function = "CreateSkillCreature",
        Location = T.RT_98
      }
    },
    TaskId = 800304
  },
  [800305] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_784,
      [2] = T.RT_3,
      [3] = {Function = "PlaySE", SEId = 800302}
    },
    TaskId = 800305
  },
  [800306] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_674,
      [2] = {FXId = 800305, Function = "PlayFX"}
    },
    TaskId = 800306
  },
  [850011] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill01_Whip01",
    TaskEffects = T.RT_787,
    TaskId = 850011
  },
  [850012] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Skill01_Whip02",
    TaskEffects = T.RT_788,
    TaskId = 850012
  },
  [850013] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_791,
    TaskId = 850013
  },
  [850014] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_791,
    TaskId = 850014
  },
  [850015] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_788,
    TaskId = 850015
  },
  [850016] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_795,
    TaskId = 850016
  },
  [850017] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_797,
    TaskId = 850017
  },
  [850018] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_798,
    TaskId = 850018
  },
  [850021] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill02_Sword01",
    TaskEffects = T.RT_788,
    TaskId = 850021
  },
  [850022] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Skill02_Sword02",
    TaskEffects = T.RT_787,
    TaskId = 850022
  },
  [850023] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_803,
    TaskId = 850023
  },
  [850024] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_803,
    TaskId = 850024
  },
  [850025] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_788,
    TaskId = 850025
  },
  [850041] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 850041,
        Function = "CreateSkillCreature",
        Location = T.RT_425
      }
    },
    TaskId = 850041
  },
  [850042] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_810,
    TaskId = 850042
  },
  [850051] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_812,
    TaskId = 850051
  },
  [850052] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = T.RT_814,
    TaskId = 850052
  },
  [850061] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_816,
    TaskId = 850061
  },
  [850062] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_818,
    TaskId = 850062
  },
  [850063] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Skill06_Donut01",
    TaskEffects = T.RT_820,
    TaskId = 850063
  },
  [850064] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Skill06_Donut02",
    TaskEffects = T.RT_820,
    TaskId = 850064
  },
  [850065] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Skill06_Donut03",
    TaskEffects = T.RT_820,
    TaskId = 850065
  },
  [850071] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill07",
    TaskEffects = T.RT_824,
    TaskId = 850071
  },
  [850081] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_791,
    TaskId = 850081
  },
  [850082] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_791,
    TaskId = 850082
  },
  [850083] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_788,
    TaskId = 850083
  },
  [850084] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 850084
  },
  [850085] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = T.RT_816,
    TaskId = 850085
  },
  [850086] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = T.RT_828,
    TaskId = 850086
  },
  [850087] = {
    NotifyName = T.RT_825,
    TargetFilter = "BossXibi_Skill08_Jump",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_809,
      [3] = T.RT_830,
      [4] = T.RT_5
    },
    TaskId = 850087
  },
  [850201] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_849,
    TaskId = 850201
  },
  [850202] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_852,
    TaskId = 850202
  },
  [850203] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_853,
    TaskId = 850203
  },
  [850204] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_856,
    TaskId = 850204
  },
  [850205] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_110,
      [3] = T.RT_848
    },
    TaskId = 850205
  },
  [850206] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_858,
    TaskId = 850206
  },
  [850207] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_860,
    TaskId = 850207
  },
  [850208] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill04_Cylinder_300_200_360",
    TaskEffects = T.RT_861,
    TaskId = 850208
  },
  [850209] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossSaiqi_Skill13_Cylinder_300_200_360",
    TaskEffects = T.RT_863,
    TaskId = 850209
  },
  [850210] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_864
    },
    TaskId = 850210
  },
  [850211] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_869,
    TaskId = 850211
  },
  [850212] = {
    NotifyName = T.RT_870,
    TargetFilter = "Self",
    TaskEffects = T.RT_876,
    TaskId = 850212
  },
  [850213] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_879,
    TaskId = 850213
  },
  [850214] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_882,
    TaskId = 850214
  },
  [850215] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_885,
    TaskId = 850215
  },
  [850216] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_888,
    TaskId = 850216
  },
  [850217] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_929,
      [2] = T.RT_889
    },
    TaskId = 850217
  },
  [850218] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_890,
      [2] = T.RT_892
    },
    TaskId = 850218
  },
  [850219] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850209,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 850219
  },
  [850220] = {
    TargetFilter = "BossSaiqi_Skill07_Cylinder_300_800_360",
    TaskEffects = T.RT_894,
    TaskId = 850220
  },
  [850221] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850221
  },
  [850222] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_897
    },
    TaskId = 850222
  },
  [850223] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_898,
    TaskId = 850223
  },
  [850224] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 1.3,
        UnitId = 850281,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 850224
  },
  [850225] = {
    TargetFilter = "LaserTarget",
    TaskEffects = T.RT_899,
    TaskId = 850225
  },
  [850226] = {
    TargetFilter = "LaserTarget",
    TaskEffects = T.RT_900,
    TaskId = 850226
  },
  [850227] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_902,
    TaskId = 850227
  },
  [850228] = {
    NotifyName = T.RT_903,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850228
  },
  [850229] = {
    NotifyName = T.RT_904,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_906,
    TaskId = 850229
  },
  [850230] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_907
    },
    TaskId = 850230
  },
  [850231] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850231
  },
  [850232] = {
    NotifyName = T.RT_908,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_910,
    TaskId = 850232
  },
  [850233] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_911,
    TaskId = 850233
  },
  [850234] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_912,
    TaskId = 850234
  },
  [850235] = {
    NotifyName = T.RT_913,
    TargetFilter = "Self",
    TaskEffects = T.RT_915,
    TaskId = 850235
  },
  [850236] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = T.RT_917,
    TaskId = 850236
  },
  [850237] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_918,
    TaskId = 850237
  },
  [850238] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850238
  },
  [850239] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_919,
    TaskId = 850239
  },
  [850240] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_920,
    TaskId = 850240
  },
  [850301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill01_L",
    TaskEffects = T.RT_933,
    TaskId = 850301
  },
  [850302] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill02_Cylinder01",
    TaskEffects = T.RT_935,
    TaskId = 850302
  },
  [850303] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_937,
    TaskId = 850303
  },
  [850304] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = T.RT_940,
    TaskId = 850304
  },
  [850305] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_942,
    TaskId = 850305
  },
  [850306] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = {
        CauseHit = "BossShijingzhe_Effect850306",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850306
  },
  [850307] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_944,
    TaskId = 850307
  },
  [850308] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_110,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850308
  },
  [850309] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_946,
    TaskId = 850309
  },
  [850310] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_947,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850310
  },
  [850311] = {
    NotifyName = {
      "hit2",
      "hit3",
      "hit4",
      "hit5",
      "hit6"
    },
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850302,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 850311
  },
  [850312] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_757,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850312
  },
  [850313] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_895,
    TaskId = 850313
  },
  [850314] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "RandomAreaLocation",
        Vars = {
          Distance = 600,
          MaxNum = 4,
          Radius = 1500
        }
      },
      [2] = T.RT_968,
      [3] = T.RT_969,
      [4] = T.RT_970,
      [5] = T.RT_971
    },
    TaskId = 850314
  },
  [850315] = {
    NotifyName = T.RT_12,
    TaskEffects = T.RT_977,
    TaskId = 850315
  },
  [850316] = {
    TargetFilter = "BossShijingzhe_Cylinder_100_100_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_947,
      [3] = T.RT_931,
      [4] = T.RT_939
    },
    TaskId = 850316
  },
  [850317] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_979,
    TaskId = 850317
  },
  [850318] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_930,
      [3] = T.RT_989,
      [4] = T.RT_931,
      [5] = T.RT_957
    },
    TaskId = 850318
  },
  [850319] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill01_R",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_930,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850319
  },
  [850320] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill02_Cylinder02",
    TaskEffects = T.RT_949,
    TaskId = 850320
  },
  [850321] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_320_250_360",
    TaskEffects = T.RT_935,
    TaskId = 850321
  },
  [850322] = {
    TargetFilter = "BossShijingzhe_Cylinder_1000_200_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_988,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850322
  },
  [850323] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850303,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_999
    },
    TaskId = 850323
  },
  [850324] = {
    TargetFilter = "BossShijingzhe_Cylinder_600_350_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "BossShijingzhe_Effect850324",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_931
    },
    TaskId = 850324
  },
  [850325] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        BoneName = "head",
        DanmakuTemplateId = 850302,
        Duration = 3.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850325
  },
  [850326] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill05_RushPillar",
    TaskEffects = T.RT_956,
    TaskId = 850326
  },
  [850327] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.172
      }
    },
    TaskId = 850327
  },
  [850328] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.229
      }
    },
    TaskId = 850328
  },
  [850329] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.34
      }
    },
    TaskId = 850329
  },
  [850330] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.667
      }
    },
    TaskId = 850330
  },
  [850331] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_skill12_L",
    TaskEffects = T.RT_981,
    TaskId = 850331
  },
  [850332] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_skill12_R",
    TaskEffects = T.RT_981,
    TaskId = 850332
  },
  [850333] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = T.RT_940,
    TaskId = 850333
  },
  [850334] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Cylinder_600_350_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_938,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850334
  },
  [850335] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder01",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_930,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850335
  },
  [850336] = {
    NotifyName = {
      "hit2",
      "hit3",
      "hit4",
      "hit5",
      "hit6",
      "hit7",
      "hit8",
      "hit9",
      "hit10",
      "hit11",
      "hit12"
    },
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850306,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          700
        }
      }
    },
    TaskId = 850336
  },
  [850337] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_951,
    TaskId = 850337
  },
  [850338] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder02",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_930,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850338
  },
  [850339] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_934,
      [3] = T.RT_989,
      [4] = T.RT_931,
      [5] = T.RT_939
    },
    TaskId = 850339
  },
  [850340] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder03",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_938,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 850340
  },
  [850341] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.334
      },
      [2] = T.RT_931
    },
    TaskId = 850341
  },
  [850342] = {
    TargetFilter = "Mon_Cylinder_150_400_360",
    TaskEffects = {
      [1] = T.RT_999,
      [2] = {
        FXId = 850311,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_893,
      [4] = {
        CauseHit = "LightHit_60",
        Function = "CutToughness",
        Value = 20
      }
    },
    TaskId = 850342
  },
  [850343] = {
    NotifyName = T.RT_954,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = {
      [1] = T.RT_498
    },
    TaskId = 850343
  },
  [850344] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill11_Donut01",
    TaskEffects = T.RT_1000,
    TaskId = 850344
  },
  [850345] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill11_Donut02",
    TaskEffects = T.RT_1000,
    TaskId = 850345
  },
  [850346] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossShijingzhe_Skill11_Donut03",
    TaskEffects = T.RT_1000,
    TaskId = 850346
  },
  [850347] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850317, Function = "PlayFX"}
    },
    TaskId = 850347
  },
  [850348] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850318, Function = "PlayFX"}
    },
    TaskId = 850348
  },
  [850349] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850319, Function = "PlayFX"}
    },
    TaskId = 850349
  },
  [850350] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1001,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850311,
        UnitType = "MechanismSummon"
      },
      [2] = {
        AttrRates = T.RT_1002,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850312,
        UnitType = "MechanismSummon"
      },
      [3] = {
        AttrRates = T.RT_1001,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850313,
        UnitType = "MechanismSummon"
      },
      [4] = {
        AttrRates = T.RT_1002,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850314,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 850350
  },
  [850351] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill11_Donut01_Pillar",
    TaskEffects = T.RT_956,
    TaskId = 850351
  },
  [850352] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill11_Donut02_Pillar",
    TaskEffects = T.RT_956,
    TaskId = 850352
  },
  [850353] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossShijingzhe_Skill11_Donut03_Pillar",
    TaskEffects = T.RT_956,
    TaskId = 850353
  },
  [850401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850419,
        Duration = 10,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850401
  },
  [850402] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850402,
        Duration = 5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850402
  },
  [850403] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850404,
        Duration = 5,
        Function = "CreateDanmaku"
      },
      [2] = {
        DanmakuTemplateId = 850416,
        Duration = 5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850403
  },
  [850404] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850406,
        Duration = 7,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850404
  },
  [850405] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850402,
        Function = "CreateSkillCreature",
        Location = T.RT_1003
      },
      [2] = {
        CreatureId = 850402,
        Function = "CreateSkillCreature",
        Location = T.RT_984
      },
      [3] = {
        CreatureId = 850402,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 850402,
        Function = "CreateSkillCreature",
        Location = T.RT_808
      },
      [5] = {
        CreatureId = 850402,
        Function = "CreateSkillCreature",
        Location = T.RT_1004
      }
    },
    TaskId = 850405
  },
  [850406] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_504,
      [2] = {Function = "PlaySE", SEId = 850404}
    },
    TaskId = 850406
  },
  [850407] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1006,
      [2] = {
        AttrRates = T.RT_1005,
        FormationId = 850402,
        Function = "CreateUnit",
        LifeTime = 9999,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8504004,
        UnitType = "Monster"
      },
      [3] = T.RT_1007,
      [4] = T.RT_1008
    },
    TaskId = 850407
  },
  [850408] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 999,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850403,
        UnitType = "MechanismSummon"
      },
      [2] = {
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 999,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850404,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 850408
  },
  [850409] = {
    NotifyName = T.RT_666,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 2.8
      },
      [2] = T.RT_846,
      [3] = T.RT_1009,
      [4] = T.RT_1010
    },
    TaskId = 850409
  },
  [850410] = {
    NotifyName = T.RT_13,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 3.2
      },
      [2] = T.RT_758,
      [3] = T.RT_1009,
      [4] = T.RT_1010
    },
    TaskId = 850410
  },
  [850411] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = {
        Function = "EffectFunction",
        FunctionName = "SelfLocation",
        Vars = {Tag = 1}
      },
      [3] = {
        CreatureId = 850401,
        Function = "CreateSkillCreature",
        Location = T.RT_496,
        Saveloc = "1",
        SetSavelocAsTarget = ""
      }
    },
    TaskId = 850411
  },
  [850412] = {
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_1011,
      [2] = T.RT_1009,
      [3] = T.RT_1010
    },
    TaskId = 850412
  },
  [850413] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 4.8
      },
      [2] = T.RT_1009,
      [3] = T.RT_846,
      [4] = T.RT_1010
    },
    TaskId = 850413
  },
  [850414] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850403,
        Function = "CreateSkillCreature",
        Location = T.RT_36
      }
    },
    TaskId = 850414
  },
  [850415] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1012,
      [2] = T.RT_1009,
      [3] = T.RT_1013,
      [4] = T.RT_1014
    },
    TaskId = 850415
  },
  [850416] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_1015,
      [2] = T.RT_758,
      [3] = T.RT_1009,
      [4] = T.RT_1014
    },
    TaskId = 850416
  },
  [850417] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 850417
  },
  [850418] = {TaskId = 850418},
  [850419] = {TaskId = 850419},
  [850420] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850403,
        Duration = 4,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850420
  },
  [850421] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850405,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850421
  },
  [850422] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 850422
  },
  [850423] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850405,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 850423
  },
  [850424] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1017,
    TaskId = 850424
  },
  [850425] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1017,
    TaskId = 850425
  },
  [850426] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageType = "TrueDamage",
        DefaultHealFX = 0,
        Function = "Damage",
        Rate = 3
      }
    },
    TaskId = 850426
  },
  [850427] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_1012,
      [2] = {FXId = 530106, Function = "PlayFX"}
    },
    TaskId = 850427
  },
  [850428] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850404,
        Function = "CreateSkillCreature",
        UseSaveLoc = "storm"
      }
    },
    TaskId = 850428
  },
  [850429] = {
    TargetFilter = "BossSaiqi02_Cylinder_750_2500_360",
    TaskEffects = {
      [1] = T.RT_893,
      [2] = T.RT_758,
      [3] = {Function = "PlaySE", SEId = 850420}
    },
    TaskId = 850429
  },
  [850430] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_1015,
      [2] = T.RT_763
    },
    TaskId = 850430
  },
  [850431] = {
    NotifyName = T.RT_13,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_683,
      [2] = T.RT_39
    },
    TaskId = 850431
  },
  [850432] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 3,
        UnitId = 850401,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 850432
  },
  [850433] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 850404,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 850433
  },
  [850434] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 850404,
        BySource = true,
        Function = "RemoveBuff"
      }
    },
    TaskId = 850434
  },
  [850435] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850407,
        Duration = 5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850435
  },
  [850436] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850408,
        Duration = 5,
        Function = "CreateDanmaku"
      },
      [2] = {
        DanmakuTemplateId = 850415,
        Duration = 5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850436
  },
  [850437] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850409,
        Duration = 5,
        Function = "CreateDanmaku"
      },
      [2] = {
        DanmakuTemplateId = 850410,
        Duration = 5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850437
  },
  [850438] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = {
          400,
          0,
          200
        },
        Rotation = T.RT_321
      }
    },
    TaskId = 850438
  },
  [850439] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1018,
    TaskId = 850439
  },
  [850440] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CantLockTime = 3,
        Function = "CameraUnlock"
      }
    },
    TaskId = 850440
  },
  [850441] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1018,
    TaskId = 850441
  },
  [850442] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskId = 850442
  },
  [850443] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850413,
        Duration = 7,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850443
  },
  [850444] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850414,
        Duration = 7,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850444
  },
  [850445] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1005,
        FormationId = 850402,
        Function = "CreateUnit",
        LifeTime = 9999,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8504003,
        UnitType = "Monster"
      },
      [2] = {
        AttrRates = T.RT_1005,
        FormationId = 850404,
        Function = "CreateUnit",
        LifeTime = 9999,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8504004,
        UnitType = "Monster"
      },
      [3] = T.RT_1007,
      [4] = T.RT_1008
    },
    TaskId = 850445
  },
  [850446] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1006,
      [2] = {
        AttrRates = T.RT_1005,
        FormationId = 850403,
        Function = "CreateUnit",
        LifeTime = 9999,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8504004,
        UnitType = "Monster"
      },
      [3] = T.RT_1007,
      [4] = T.RT_1008
    },
    TaskId = 850446
  },
  [850447] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1019
    },
    TaskId = 850447
  },
  [850448] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1020,
        Rotation = T.RT_320
      }
    },
    TaskId = 850448
  },
  [850449] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1021
      }
    },
    TaskId = 850449
  },
  [850450] = {
    NotifyName = T.RT_13,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1021,
        Rotation = T.RT_126
      }
    },
    TaskId = 850450
  },
  [850451] = {
    NotifyName = T.RT_404,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = {
          400,
          300,
          200
        },
        Rotation = T.RT_126
      },
      [2] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1020,
        Rotation = T.RT_126
      }
    },
    TaskId = 850451
  },
  [850452] = {
    NotifyName = T.RT_507,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1021,
        Rotation = T.RT_321
      }
    },
    TaskId = 850452
  },
  [850453] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = {
          0,
          300,
          500
        },
        Rotation = T.RT_126
      },
      [2] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = {
          0,
          30,
          -100
        },
        Rotation = T.RT_126
      }
    },
    TaskId = 850453
  },
  [850454] = {
    NotifyName = T.RT_829,
    TaskEffects = {
      [1] = {
        CreatureId = 850406,
        Function = "CreateSkillCreature",
        Location = T.RT_1021,
        Rotation = T.RT_320
      }
    },
    TaskId = 850454
  },
  [850455] = {
    NotifyName = {
      "hit9",
      "hit10",
      "hit11",
      "hit12",
      "hit13",
      "hit14",
      "hit15"
    },
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850407,
        Function = "CreateSkillCreature",
        Location = {
          0,
          300,
          100
        }
      }
    },
    TaskId = 850455
  },
  [850456] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850418,
        Duration = 4,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850456
  },
  [850457] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850408,
        Function = "CreateSkillCreature",
        Location = T.RT_1003
      },
      [2] = {
        CreatureId = 850408,
        Function = "CreateSkillCreature",
        Location = T.RT_984
      },
      [3] = {
        CreatureId = 850408,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 850408,
        Function = "CreateSkillCreature",
        Location = T.RT_808
      },
      [5] = {
        CreatureId = 850408,
        Function = "CreateSkillCreature",
        Location = T.RT_1004
      }
    },
    TaskId = 850457
  },
  [850458] = {
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1013
    },
    TaskId = 850458
  },
  [850459] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850410,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850459
  },
  [850460] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850411,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850460
  },
  [850461] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850412,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850461
  },
  [850462] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850413,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850462
  },
  [850463] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850414,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850463
  },
  [850464] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850415,
        Function = "CreateSkillCreature",
        Location = {
          250,
          0,
          0
        }
      }
    },
    TaskId = 850464
  },
  [850465] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850415,
        Function = "CreateSkillCreature",
        Location = {
          -250,
          0,
          0
        }
      }
    },
    TaskId = 850465
  },
  [850466] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1022,
      [2] = T.RT_889
    },
    TaskId = 850466
  },
  [850501] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_01",
    TaskEffects = T.RT_1024,
    TaskId = 850501
  },
  [850502] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_02",
    TaskEffects = T.RT_1025,
    TaskId = 850502
  },
  [850503] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_02",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_553,
      [3] = T.RT_1023
    },
    TaskId = 850503
  },
  [850504] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_01",
    TaskEffects = T.RT_1026,
    TaskId = 850504
  },
  [850505] = {
    NotifyName = T.RT_1027,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_02",
    TaskEffects = T.RT_1028,
    TaskId = 850505
  },
  [850506] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_03",
    TaskEffects = T.RT_1029,
    TaskId = 850506
  },
  [850507] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_03",
    TaskEffects = T.RT_1030,
    TaskId = 850507
  },
  [850508] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill03_Cylinder",
    TaskEffects = T.RT_1032,
    TaskId = 850508
  },
  [850509] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850501,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 850509
  },
  [850510] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850501,
        Function = "CreateSkillCreature",
        Location = T.RT_36
      }
    },
    TaskId = 850510
  },
  [850511] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        FXId = 601202,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_1031
    },
    TaskId = 850511
  },
  [850512] = {
    NotifyName = T.RT_1027,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1038,
      [2] = {
        CreatureId = 850502,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "First1"
      },
      [3] = {
        CreatureId = 850502,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "First2"
      }
    },
    TaskId = 850512
  },
  [850513] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = T.RT_1042,
    TaskId = 850513
  },
  [850514] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1047,
    TaskId = 850514
  },
  [850515] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850515
  },
  [850516] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850502,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 850516
  },
  [850517] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1039,
    TaskId = 850517
  },
  [850518] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill06_Cylinder",
    TaskEffects = T.RT_1048,
    TaskId = 850518
  },
  [850519] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill07_Select",
    TaskEffects = {
      [1] = T.RT_1095,
      [2] = T.RT_1031
    },
    TaskId = 850519
  },
  [850520] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = {
      [1] = {
        BuffId = 207,
        Function = "AddBuff",
        LastTime = 2.4
      },
      [2] = T.RT_991
    },
    TaskId = 850520
  },
  [850521] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = {
      [1] = T.RT_1095,
      [2] = T.RT_498
    },
    TaskId = 850521
  },
  [850522] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 2.2
      },
      [2] = T.RT_680
    },
    TaskId = 850522
  },
  [850523] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850507,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 850523
  },
  [850524] = {
    NotifyName = T.RT_2,
    TargetFilter = "AlmostAllEnemy",
    TaskEffects = {
      [1] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 1660021
      },
      [2] = T.RT_1019
    },
    TaskId = 850524
  },
  [850525] = {
    NotifyName = T.RT_1058,
    TargetFilter = "Self",
    TaskEffects = T.RT_1060,
    TaskId = 850525
  },
  [850526] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1062,
    TaskId = 850526
  },
  [850527] = {
    NotifyName = T.RT_1063,
    TargetFilter = "Self",
    TaskEffects = T.RT_1065,
    TaskId = 850527
  },
  [850528] = {
    NotifyName = T.RT_1070,
    TargetFilter = "AlmostAllEnemy",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 1660021
      },
      [2] = T.RT_1072
    },
    TaskId = 850528
  },
  [850529] = {
    NotifyName = {
      "hit15",
      "hit18",
      "hit22"
    },
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 850529
  },
  [850530] = {
    NotifyName = T.RT_1069,
    TargetFilter = "BossLianhuo_Skill08_Cylinder",
    TaskEffects = T.RT_1048,
    TaskId = 850530
  },
  [850531] = {
    NotifyName = T.RT_1066,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1068,
    TaskId = 850531
  },
  [850532] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 850532
  },
  [850533] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850506,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = ""
      }
    },
    TaskId = 850533
  },
  [850534] = {
    TargetFilter = "BossLianhuo_Skill07_Select",
    TaskEffects = {
      [1] = T.RT_990,
      [2] = T.RT_991,
      [3] = {
        BuffId = 850504,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 850534
  },
  [850535] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = T.RT_1057,
    TaskId = 850535
  },
  [850536] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = T.RT_993,
    TaskId = 850536
  },
  [850537] = {
    TargetFilter = "BossLianhuo_Skill08_Field",
    TaskEffects = {
      [1] = T.RT_821,
      [2] = T.RT_1031
    },
    TaskId = 850537
  },
  [850538] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill12_Rectangle",
    TaskEffects = T.RT_1089,
    TaskId = 850538
  },
  [850539] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_01",
    TaskEffects = T.RT_1091,
    TaskId = 850539
  },
  [850540] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1088,
    TaskId = 850540
  },
  [850541] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = T.RT_1088,
    TaskId = 850541
  },
  [850542] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1049,
      [2] = {
        CreatureId = 850508,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "Fire1"
      },
      [3] = {
        CreatureId = 850508,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "Fire2"
      },
      [4] = {
        CreatureId = 850508,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "Fire3"
      },
      [5] = {
        CreatureId = 850508,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        UseRelativeOffset = true,
        UseSaveLoc = "Fire4"
      }
    },
    TaskId = 850542
  },
  [850543] = {
    TargetFilter = "BossLianhuo_Skill06_Cylinder_02",
    TaskEffects = {
      [1] = T.RT_1022,
      [2] = T.RT_1031
    },
    TaskId = 850543
  },
  [850544] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1036,
    TaskId = 850544
  },
  [850545] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = T.RT_1044,
    TaskId = 850545
  },
  [850546] = {
    NotifyName = T.RT_1070,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1071,
    TaskId = 850546
  },
  [850547] = {
    NotifyName = T.RT_1077,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1081,
    TaskId = 850547
  },
  [850548] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_821,
      [2] = T.RT_1023,
      [3] = {
        FXId = 850510,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 850548
  },
  [850549] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill06_Cylinder",
    TaskEffects = T.RT_1055,
    TaskId = 850549
  },
  [850550] = {
    NotifyName = T.RT_1082,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1084,
    TaskId = 850550
  },
  [850551] = {
    NotifyName = T.RT_1092,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1094,
    TaskId = 850551
  },
  [850552] = {
    NotifyName = {"hit25"},
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1085,
      [2] = T.RT_1096
    },
    TaskId = 850552
  },
  [850553] = {
    NotifyName = T.RT_1086,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1087,
      [2] = T.RT_1097
    },
    TaskId = 850553
  },
  [850554] = {
    NotifyName = T.RT_1073,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1076,
    TaskId = 850554
  },
  [850555] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = {
      [1] = {
        BuffId = 850505,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 850555
  },
  [850601] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_1098,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          30,
          90,
          0
        },
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit2"
      },
      [3] = T.RT_701,
      [4] = T.RT_1099
    },
    TaskId = 850601
  },
  [850602] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_1098,
      [2] = {
        Delay = 0.1,
        Function = "PlayFX",
        FxRotator = T.RT_51,
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit2"
      },
      [3] = T.RT_701,
      [4] = T.RT_1099
    },
    TaskId = 850602
  },
  [850603] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_1098,
      [2] = {FXId = 850601, Function = "PlayFX"},
      [3] = T.RT_701,
      [4] = T.RT_1099
    },
    TaskId = 850603
  },
  [850604] = {
    NotifyName = T.RT_13,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = T.RT_57,
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit2"
      },
      [3] = {
        CauseHit = "HitFly_XY400Z300",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_1099
    },
    TaskId = 850604
  },
  [850605] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1102,
    TaskId = 850605
  },
  [850606] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = T.RT_1102,
    TaskId = 850606
  },
  [850607] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 2
      },
      [2] = T.RT_1101,
      [3] = T.RT_1099
    },
    TaskId = 850607
  },
  [850608] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 2.5
      },
      [2] = T.RT_1101,
      [3] = T.RT_1099
    },
    TaskId = 850608
  },
  [850609] = {
    NotifyName = T.RT_1103,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_1098,
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = T.RT_76,
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit2"
      },
      [3] = T.RT_1099
    },
    TaskId = 850609
  },
  [850901] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossTuosi_Skill01_Cylinder01",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1104,
      [3] = {Function = "PlaySE", SEId = 850912}
    },
    TaskId = 850901
  },
  [850902] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossTuosi_Skill01_Cylinder02",
    TaskEffects = {
      [1] = T.RT_1045,
      [2] = T.RT_1104,
      [3] = {Function = "PlaySE", SEId = 850913}
    },
    TaskId = 850902
  },
  [850903] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossTuosi_Skill02_Cylinder01",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 850914}
    },
    TaskId = 850903
  },
  [850904] = {
    NotifyName = {"hit1", "hit10"},
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 850904
  },
  [850905] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850901,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 850905
  },
  [850906] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850901,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 850906
  },
  [850907] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1106,
    TaskId = 850907
  },
  [850908] = {
    TargetFilter = "BossTuosi_Skill04_Box",
    TaskEffects = T.RT_1106,
    TaskId = 850908
  },
  [850909] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850902,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        SetSavelocAsTarget = "Skill04"
      }
    },
    TaskId = 850909
  },
  [850910] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1106,
    TaskId = 850910
  },
  [850911] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossTuosi_Skill06_Cylinder01",
    TaskEffects = {
      [1] = T.RT_778,
      [2] = T.RT_10,
      [3] = T.RT_1105
    },
    TaskId = 850911
  },
  [850912] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossTuosi_Skill06_Cylinder02",
    TaskEffects = {
      [1] = T.RT_778,
      [2] = {
        CauseHit = "HitFly_XY300Z1000",
        Function = "CutToughness"
      },
      [3] = T.RT_1105
    },
    TaskId = 850912
  },
  [850913] = {
    TargetFilter = "BossTuosi_Skill06_BoxRotate0",
    TaskEffects = {
      [1] = T.RT_1107,
      [2] = T.RT_17,
      [3] = T.RT_1105
    },
    TaskId = 850913
  },
  [850914] = {
    TargetFilter = "BossTuosi_Skill06_BoxRotate+45",
    TaskEffects = T.RT_1109,
    TaskId = 850914
  },
  [850915] = {
    TargetFilter = "BossTuosi_Skill06_BoxRotate-45",
    TaskEffects = T.RT_1109,
    TaskId = 850915
  },
  [850916] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "pelvis",
        DanmakuTemplateId = 850901,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850916
  },
  [850917] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_10,
      [3] = T.RT_508,
      [4] = T.RT_1105
    },
    TaskId = 850917
  },
  [850918] = {
    TaskEffects = T.RT_1111,
    TaskId = 850918
  },
  [850919] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "pelvis",
        DanmakuTemplateId = 850902,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850919
  },
  [850920] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SetSelfLoc",
        TargetCenterLoc = "StaticCreator"
      }
    },
    TaskId = 850920
  },
  [850921] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 850901,
        Function = "CreateUnit",
        LifeTime = 14,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850901,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 850921
  },
  [850922] = {
    TargetFilter = "BossTuosi_Skill08_CenterBurstCylinder",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_17,
      [3] = T.RT_1112,
      [4] = T.RT_1113
    },
    TaskId = 850922
  },
  [850923] = {
    TargetFilter = "BossTuosi_Skill08_AroundBurstCylinder",
    TaskEffects = {
      [1] = T.RT_1108,
      [2] = T.RT_17,
      [3] = T.RT_1112,
      [4] = {Function = "PlaySE", SEId = 850917}
    },
    TaskId = 850923
  },
  [850926] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850903,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850926
  },
  [850927] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_1114,
      [3] = T.RT_508,
      [4] = T.RT_1113
    },
    TaskId = 850927
  },
  [850928] = {
    TaskEffects = T.RT_510,
    TaskId = 850928
  },
  [850929] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850904,
        Delay = 10,
        Duration = 999,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 850929
  },
  [850930] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_508,
      [3] = T.RT_1115
    },
    TaskId = 850930
  },
  [850931] = {
    TaskEffects = T.RT_510,
    TaskId = 850931
  },
  [850932] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850903,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        SetSavelocAsTarget = "Skill04"
      }
    },
    TaskId = 850932
  },
  [850933] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 850904,
        Direction = T.RT_953,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 850933
  },
  [850934] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 850905,
        Direction = T.RT_953,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 850934
  },
  [850935] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 850906,
        Direction = T.RT_953,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 850935
  },
  [850937] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossTuosi_Skill02_Cylinder02",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1104,
      [3] = {Function = "PlaySE", SEId = 850915}
    },
    TaskId = 850937
  },
  [850939] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850907,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 850939
  },
  [850940] = {
    TargetFilter = "BossTuosi_Skill08_BigBurst",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1114,
      [3] = {FXId = 850904, Function = "PlayFX"},
      [4] = T.RT_1113
    },
    TaskId = 850940
  },
  [850941] = {
    NotifyName = T.RT_525,
    TargetFilter = "BossTuosi_Skill07_Hit",
    TaskEffects = {
      [1] = T.RT_1045,
      [2] = T.RT_1104,
      [3] = T.RT_1105
    },
    TaskId = 850941
  },
  [850942] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1096
    },
    TaskId = 850942
  },
  [850943] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1097
    },
    TaskId = 850943
  },
  [850944] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1116
    },
    TaskId = 850944
  },
  [850945] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1117
    },
    TaskId = 850945
  },
  [850946] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850922, Function = "PlayFX"}
    },
    TaskId = 850946
  },
  [850947] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850908, Function = "PlayFX"}
    },
    TaskId = 850947
  },
  [850948] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850910, Function = "PlayFX"}
    },
    TaskId = 850948
  },
  [850949] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850912, Function = "PlayFX"}
    },
    TaskId = 850949
  },
  [850950] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850907, Function = "PlayFX"}
    },
    TaskId = 850950
  },
  [850951] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850909, Function = "PlayFX"}
    },
    TaskId = 850951
  },
  [850952] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850911, Function = "PlayFX"}
    },
    TaskId = 850952
  },
  [850953] = {
    TargetFilter = "BossTuosi_Skill05_Box01",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_17,
      [3] = T.RT_1105
    },
    TaskId = 850953
  },
  [850954] = {
    TargetFilter = "BossTuosi_Skill05_Box02",
    TaskEffects = {
      [1] = T.RT_1011,
      [2] = T.RT_17,
      [3] = T.RT_1105
    },
    TaskId = 850954
  },
  [850955] = {
    TargetFilter = "BossTuosi_Skill05_Box03",
    TaskEffects = {
      [1] = T.RT_778,
      [2] = T.RT_17,
      [3] = T.RT_1105
    },
    TaskId = 850955
  },
  [850956] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850917, Function = "PlayFX"}
    },
    TaskId = 850956
  },
  [850957] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850918, Function = "PlayFX"}
    },
    TaskId = 850957
  },
  [850958] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850919, Function = "PlayFX"}
    },
    TaskId = 850958
  },
  [850959] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_893,
      [2] = T.RT_10,
      [3] = T.RT_660,
      [4] = T.RT_1115
    },
    TaskId = 850959
  },
  [850960] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850920, Function = "PlayFX"}
    },
    TaskId = 850960
  },
  [850961] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 850921, Function = "PlayFX"}
    },
    TaskId = 850961
  },
  [851001] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851001,
        Duration = 10,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851001
  },
  [851002] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill02_Cylinder_Left",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1104,
      [3] = {Function = "PlaySE", SEId = 851002}
    },
    TaskId = 851002
  },
  [851003] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill02_Cylinder_Right",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1104,
      [3] = T.RT_1118
    },
    TaskId = 851003
  },
  [851004] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1118
    },
    TaskId = 851004
  },
  [851005] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851002,
        Function = "CreateSkillCreature",
        UseSaveLoc = "center"
      }
    },
    TaskId = 851005
  },
  [851006] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851003,
        Function = "CreateSkillCreature",
        UseSaveLoc = "center"
      }
    },
    TaskId = 851006
  },
  [851007] = {
    TargetFilter = "BossHeilong_Skill04_Cylinder_In",
    TaskEffects = T.RT_1121,
    TaskId = 851007
  },
  [851008] = {
    TargetFilter = "BossHeilong_Skill04_Cylinder_Out",
    TaskEffects = T.RT_1122,
    TaskId = 851008
  },
  [851009] = {
    TargetFilter = "BossHeilong_Skill04_Cylinder_In",
    TaskEffects = T.RT_1123,
    TaskId = 851009
  },
  [851010] = {
    TargetFilter = "BossHeilong_Skill04_Cylinder_Out",
    TaskEffects = T.RT_1123,
    TaskId = 851010
  },
  [851011] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1124,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8510003,
        UnitType = "Monster",
        UseSaveLoc = "FireBall1"
      },
      [2] = {
        AttrRates = T.RT_1124,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8510003,
        UnitType = "Monster",
        UseSaveLoc = "FireBall2"
      }
    },
    TaskId = 851011
  },
  [851012] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill06_Cylinder",
    TaskEffects = T.RT_1127,
    TaskId = 851012
  },
  [851013] = {
    TargetFilter = "BossHeilong_Skill05_Cylinder",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1104,
      [3] = {FXId = 851006, Function = "PlayFX"},
      [4] = T.RT_1125
    },
    TaskId = 851013
  },
  [851014] = {
    NotifyName = T.RT_12,
    TaskEffects = T.RT_1129,
    TaskId = 851014
  },
  [851015] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = T.RT_892
    },
    TaskId = 851015
  },
  [851016] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851004,
        Function = "CreateSkillCreature",
        Location = T.RT_766,
        UseSaveLoc = "HeilongStrom01"
      }
    },
    TaskId = 851016
  },
  [851017] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851003, Function = "PlayFX"}
    },
    TaskId = 851017
  },
  [851018] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851004, Function = "PlayFX"}
    },
    TaskId = 851018
  },
  [851019] = {
    TargetFilter = "AlmostAllEnemy",
    TaskEffects = {
      [1] = T.RT_357,
      [2] = T.RT_17
    },
    TaskId = 851019
  },
  [851020] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1104,
      [3] = T.RT_1130
    },
    TaskId = 851020
  },
  [851021] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851003,
        Duration = 15,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851021
  },
  [851022] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851006,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 851022
  },
  [851023] = {
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_1104,
      [3] = T.RT_1130
    },
    TaskId = 851023
  },
  [851024] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_675
    },
    TaskId = 851024
  },
  [851025] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851003,
        Function = "AddBuff",
        LastTime = 18
      },
      [2] = T.RT_1131
    },
    TaskId = 851025
  },
  [851026] = {
    TargetFilter = "BossHeilong_Skill08_Cylinder",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1132
    },
    TaskId = 851026
  },
  [851027] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1134,
    TaskId = 851027
  },
  [851028] = {
    TargetFilter = "BossHeilong_Skill07_Cylinder",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = {Function = "PlaySE", SEId = 851014}
    },
    TaskId = 851028
  },
  [851029] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000205,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 851029
  },
  [851030] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1124,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8510003,
        UnitType = "Monster",
        UseSaveLoc = "IceBall1"
      },
      [2] = {
        AttrRates = T.RT_1124,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8510003,
        UnitType = "Monster",
        UseSaveLoc = "IceBall2"
      },
      [3] = {
        AttrRates = T.RT_1124,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8510003,
        UnitType = "Monster",
        UseSaveLoc = "IceBall3"
      }
    },
    TaskId = 851030
  },
  [851031] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1135,
      [2] = T.RT_1136,
      [3] = T.RT_1137,
      [4] = T.RT_1138,
      [5] = T.RT_1139,
      [6] = T.RT_1140,
      [7] = T.RT_1141,
      [8] = T.RT_1142
    },
    TaskId = 851031
  },
  [851032] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1143
    },
    TaskId = 851032
  },
  [851033] = {
    NotifyName = T.RT_12,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851012,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851033
  },
  [851034] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851008,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851034
  },
  [851035] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851009,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851035
  },
  [851036] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851010,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851036
  },
  [851037] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851011,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851037
  },
  [851038] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851003,
        Function = "AddBuff",
        LastTime = 13
      },
      [2] = T.RT_1116
    },
    TaskId = 851038
  },
  [851039] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1139,
      [2] = T.RT_1140,
      [3] = T.RT_1141,
      [4] = T.RT_1142,
      [5] = T.RT_1135,
      [6] = T.RT_1136,
      [7] = T.RT_1137,
      [8] = T.RT_1138
    },
    TaskId = 851039
  },
  [851040] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1143
    },
    TaskId = 851040
  },
  [851041] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossHeilong_Skill06_Cylinder",
    TaskEffects = T.RT_1144,
    TaskId = 851041
  },
  [851042] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_658,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 851001}
    },
    TaskId = 851042
  },
  [851043] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_658,
      [2] = T.RT_10,
      [3] = T.RT_1132
    },
    TaskId = 851043
  },
  [851044] = {
    NotifyName = T.RT_507,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851013,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "19",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851044
  },
  [851045] = {
    NotifyName = T.RT_825,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851013,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "20",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851045
  },
  [851046] = {
    NotifyName = T.RT_829,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851013,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "21",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851046
  },
  [851047] = {
    NotifyName = T.RT_1145,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851013,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "22",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851047
  },
  [851048] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill06H_Cylinder",
    TaskEffects = T.RT_1127,
    TaskId = 851048
  },
  [851049] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossHeilong_Skill06H_Cylinder",
    TaskEffects = T.RT_1144,
    TaskId = 851049
  },
  [851050] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851014,
        Function = "CreateSkillCreature",
        UseSaveLoc = "center"
      }
    },
    TaskId = 851050
  },
  [851051] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851015,
        Function = "CreateSkillCreature",
        UseSaveLoc = "center"
      },
      [2] = {FXId = 851002, Function = "PlayFX"}
    },
    TaskId = 851051
  },
  [851052] = {
    TargetFilter = "BossHeilong_Skill04H_Cylinder_In",
    TaskEffects = T.RT_1121,
    TaskId = 851052
  },
  [851053] = {
    TargetFilter = "BossHeilong_Skill04H_Cylinder_Out",
    TaskEffects = T.RT_1122,
    TaskId = 851053
  },
  [851054] = {
    NotifyName = T.RT_12,
    TaskEffects = T.RT_1129,
    TaskId = 851054
  },
  [851101] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851101,
        Duration = 10,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851101
  },
  [851102] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill02_Cylinder_Left",
    TaskEffects = T.RT_1147,
    TaskId = 851102
  },
  [851103] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossHeilong_Skill02_Cylinder_Right",
    TaskEffects = T.RT_1147,
    TaskId = 851103
  },
  [851104] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1146
    },
    TaskId = 851104
  },
  [851105] = {
    TargetFilter = "BossBailong_Skill04_Rectangle",
    TaskEffects = T.RT_1148,
    TaskId = 851105
  },
  [851106] = {
    TargetFilter = "BossBailong_Skill04_Rectangle_Middle",
    TaskEffects = T.RT_1148,
    TaskId = 851106
  },
  [851107] = {
    TargetFilter = "BossBailong_Skill04_Rectangle",
    TaskEffects = T.RT_1148,
    TaskId = 851107
  },
  [851108] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851107,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851108
  },
  [851109] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851108,
        Function = "CreateSkillCreature",
        UseSaveLoc = "IceRingLeft"
      },
      [2] = T.RT_1149
    },
    TaskId = 851109
  },
  [851110] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1149
    },
    TaskId = 851110
  },
  [851111] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1150,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 851101,
        UnitType = "MechanismSummon",
        UseSaveLoc = "IceBall1"
      },
      [2] = {
        AttrRates = T.RT_1150,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 851101,
        UnitType = "MechanismSummon",
        UseSaveLoc = "IceBall2"
      },
      [3] = {
        AttrRates = T.RT_1150,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 851101,
        UnitType = "MechanismSummon",
        UseSaveLoc = "IceBall3"
      }
    },
    TaskId = 851111
  },
  [851112] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = {
        CauseHit = "LightHit_150_Laser",
        Function = "CutToughness"
      }
    },
    TaskId = 851112
  },
  [851113] = {
    NotifyName = T.RT_741,
    TargetFilter = "BossBailong_Skill08_Cylinder",
    TaskEffects = T.RT_993,
    TaskId = 851113
  },
  [851114] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1134,
    TaskId = 851114
  },
  [851115] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851101,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851115
  },
  [851116] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851102,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingOut"
      }
    },
    TaskId = 851116
  },
  [851117] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_990
    },
    TaskId = 851117
  },
  [851118] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851103,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851118
  },
  [851119] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851104,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851119
  },
  [851120] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851105,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851120
  },
  [851121] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851106,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FireRingIn"
      }
    },
    TaskId = 851121
  },
  [851122] = {
    NotifyName = T.RT_507,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851109,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "21",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851122
  },
  [851123] = {
    NotifyName = T.RT_825,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851109,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "22",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851123
  },
  [851124] = {
    NotifyName = T.RT_829,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851109,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "19",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851124
  },
  [851125] = {
    NotifyName = T.RT_1145,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851109,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "20",
        UseSaveLoc = "25"
      }
    },
    TaskId = 851125
  },
  [851201] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLinen_Skill01",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_39,
      [3] = T.RT_1151
    },
    TaskId = 851201
  },
  [851202] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851230,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851202
  },
  [851203] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 2.4
      },
      [2] = T.RT_1152,
      [3] = T.RT_1151
    },
    TaskId = 851203
  },
  [851204] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851230,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851204
  },
  [851206] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = T.RT_1154,
    TaskId = 851206
  },
  [851207] = {
    TargetFilter = "BossLinen_Skill02_Scene",
    TaskEffects = {
      [1] = T.RT_929,
      [2] = {
        CauseHit = "BossLinen_Skill02",
        Function = "CutToughness",
        Value = 30
      },
      [3] = T.RT_1155,
      [4] = T.RT_1156
    },
    TaskId = 851207
  },
  [851208] = {
    TargetFilter = "BossLinen_Skill02_Scene",
    TaskEffects = {
      [1] = {
        FXId = 851212,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_498,
      [3] = {
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_1156
    },
    TaskId = 851208
  },
  [851211] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851202,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_1157,
      [3] = {
        CreatureId = 851204,
        Delay = 0.333,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851211
  },
  [851212] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851205,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851206,
        Delay = 0.167,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851207,
        Delay = 0.333,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851212
  },
  [851213] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851228,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851229,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851202,
        Delay = 0.033,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851206,
        Delay = 0.067,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851205,
        Delay = 0.1,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851204,
        Delay = 0.133,
        Function = "CreateSkillCreature"
      },
      [7] = T.RT_1157,
      [8] = {
        CreatureId = 851207,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851213
  },
  [851214] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_893,
      [2] = T.RT_1158,
      [3] = T.RT_1159,
      [4] = T.RT_1156
    },
    TaskId = 851214
  },
  [851215] = {
    TargetFilter = "BossLinen_Skill03_Scene1",
    TaskEffects = {
      [1] = T.RT_1160,
      [2] = T.RT_498,
      [3] = {
        CauseHit = "LightHit_100",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_1156
    },
    TaskId = 851215
  },
  [851216] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SetSelfLoc",
        SaveLocTag = "Skill04TargetLoc",
        TargetCenterLoc = "SavedLoc"
      },
      [2] = {
        CantLockTime = 1.3,
        Function = "CameraUnlock"
      }
    },
    TaskId = 851216
  },
  [851217] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 851213,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 851217
  },
  [851218] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 851213, Function = "RemoveBuff"}
    },
    TaskId = 851218
  },
  [851221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851209,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851209,
        Delay = 0.01,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851209,
        Delay = 0.02,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851209,
        Delay = 0.03,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851221
  },
  [851222] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        CauseHit = "BossLinen_Skill05",
        Function = "CutToughness",
        Value = 50
      },
      [3] = T.RT_1156
    },
    TaskId = 851222
  },
  [851223] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 851223
  },
  [851224] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851210,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 851224
  },
  [851225] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1161,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster"
      },
      [2] = {
        AttrRates = T.RT_1161,
        Delay = 0.02,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster"
      }
    },
    TaskId = 851225
  },
  [851226] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851203,
        Duration = 2.3,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851226
  },
  [851227] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1162,
    TaskId = 851227
  },
  [851228] = {
    TargetFilter = "BossLinen_Skill06_Scene2",
    TaskEffects = T.RT_1162,
    TaskId = 851228
  },
  [851229] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851213,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851229
  },
  [851231] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851211,
        Function = "CreateSkillCreature",
        Location = {
          -500,
          200,
          0
        }
      },
      [2] = {
        CreatureId = 851211,
        Delay = 0.05,
        Function = "CreateSkillCreature",
        Location = {
          -250,
          200,
          250
        }
      },
      [3] = {
        CreatureId = 851211,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = {
          250,
          200,
          250
        }
      },
      [4] = {
        CreatureId = 851211,
        Delay = 0.15,
        Function = "CreateSkillCreature",
        Location = {
          500,
          200,
          0
        }
      }
    },
    TaskId = 851231
  },
  [851232] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_1163,
      [3] = T.RT_1156
    },
    TaskId = 851232
  },
  [851233] = {
    TargetFilter = "BossLinen_Skill07_Scene",
    TaskEffects = {
      [1] = T.RT_1012,
      [2] = T.RT_1163,
      [3] = T.RT_1156
    },
    TaskId = 851233
  },
  [851236] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1166,
    TaskId = 851236
  },
  [851237] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {MaxHp = 0.15},
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851201,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851237
  },
  [851238] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1167,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_1"
      },
      [2] = {
        AttrRates = T.RT_1161,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_2"
      },
      [3] = {
        AttrRates = T.RT_1168,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 2,
        SingleSummonCount = 1,
        UnitId = 8512013,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_3"
      },
      [4] = {
        AttrRates = T.RT_1167,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_4"
      }
    },
    TaskId = 851238
  },
  [851239] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1161,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_5"
      },
      [2] = {
        AttrRates = T.RT_1168,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 2,
        SingleSummonCount = 1,
        UnitId = 8512013,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_6"
      },
      [3] = {
        AttrRates = T.RT_1167,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_7"
      },
      [4] = {
        AttrRates = T.RT_1161,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster",
        UseSaveLoc = "Skill08_8"
      }
    },
    TaskId = 851239
  },
  [851241] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 22,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851202,
        UnitType = "MechanismSummon"
      },
      [2] = {
        AttrRates = T.RT_84,
        Delay = 0.2,
        Function = "CreateUnit",
        LifeTime = 22.8,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851203,
        UnitType = "MechanismSummon"
      },
      [3] = {
        AttrRates = T.RT_84,
        Delay = 5.2,
        Function = "CreateUnit",
        LifeTime = 19.8,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851204,
        UnitType = "MechanismSummon"
      },
      [4] = {
        AttrRates = T.RT_84,
        Delay = 5.4,
        Function = "CreateUnit",
        LifeTime = 18.6,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851213,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851241
  },
  [851242] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851205,
        Duration = 2.3,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851242
  },
  [851243] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851206,
        Duration = 21.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851243
  },
  [851244] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851214,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill09LaserSceneLoc1"
      }
    },
    TaskId = 851244
  },
  [851245] = {
    TargetFilter = "BossLinen_Skill03_Scene1",
    TaskEffects = {
      [1] = T.RT_831,
      [2] = {
        CauseHit = "BossLinen_Skill11",
        Function = "CutToughness",
        Value = 30
      },
      [3] = T.RT_1156
    },
    TaskId = 851245
  },
  [851246] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1167,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster"
      },
      [2] = {
        AttrRates = T.RT_1167,
        Delay = 0.3,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster"
      },
      [3] = {
        AttrRates = T.RT_1167,
        Delay = 0.6,
        Function = "CreateUnit",
        LifeTime = -1,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster"
      }
    },
    TaskId = 851246
  },
  [851251] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851216,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851217,
        Delay = 0.1,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851218,
        Delay = 0.15,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851219,
        Delay = 0.25,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851220,
        Delay = 0.05,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851221,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851251
  },
  [851252] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_831,
      [2] = T.RT_843,
      [3] = T.RT_980,
      [4] = T.RT_1156,
      [5] = T.RT_1158
    },
    TaskId = 851252
  },
  [851253] = {
    TargetFilter = "BossLinen_Skill03_Scene1",
    TaskEffects = {
      [1] = {
        FXId = 851229,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_893,
      [3] = T.RT_1156,
      [4] = T.RT_1158
    },
    TaskId = 851253
  },
  [851254] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1166,
    TaskId = 851254
  },
  [851255] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851222,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851223,
        Delay = 0.1,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851224,
        Delay = 0.15,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851225,
        Delay = 0.25,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851226,
        Delay = 0.05,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851227,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851255
  },
  [851256] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = T.RT_1154,
    TaskId = 851256
  },
  [851257] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851216, Function = "PlayFX"},
      [2] = {
        Delay = 0.1,
        FXId = 851217,
        Function = "PlayFX"
      },
      [3] = {
        Delay = 0.15,
        FXId = 851218,
        Function = "PlayFX"
      },
      [4] = {
        Delay = 0.25,
        FXId = 851219,
        Function = "PlayFX"
      },
      [5] = {
        Delay = 0.05,
        FXId = 851220,
        Function = "PlayFX"
      },
      [6] = {
        Delay = 0.2,
        FXId = 851221,
        Function = "PlayFX"
      }
    },
    TaskId = 851257
  },
  [851258] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851222, Function = "PlayFX"},
      [2] = {
        Delay = 0.1,
        FXId = 851223,
        Function = "PlayFX"
      },
      [3] = {
        Delay = 0.15,
        FXId = 851224,
        Function = "PlayFX"
      },
      [4] = {
        Delay = 0.25,
        FXId = 851225,
        Function = "PlayFX"
      },
      [5] = {
        Delay = 0.05,
        FXId = 851226,
        Function = "PlayFX"
      },
      [6] = {
        Delay = 0.2,
        FXId = 851227,
        Function = "PlayFX"
      }
    },
    TaskId = 851258
  },
  [851261] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851204,
        Duration = 2.3,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851261
  },
  [851262] = {
    TargetFilter = "BossLinen_Skill06_Scene1",
    TaskEffects = T.RT_1169,
    TaskId = 851262
  },
  [851263] = {
    TargetFilter = "BossLinen_Skill06_Scene2",
    TaskEffects = T.RT_1169,
    TaskId = 851263
  },
  [851264] = {
    TargetFilter = "BossLinen_Skill06_Scene3",
    TaskEffects = T.RT_1169,
    TaskId = 851264
  },
  [851266] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851205,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon1"
      },
      [2] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851206,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon2"
      },
      [3] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851207,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon3"
      },
      [4] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851208,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon4"
      }
    },
    TaskId = 851266
  },
  [851267] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851207,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851267
  },
  [851268] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1170,
      [2] = T.RT_110,
      [3] = T.RT_1156
    },
    TaskId = 851268
  },
  [851269] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851209,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon5"
      },
      [2] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851210,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon6"
      },
      [3] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851211,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon7"
      },
      [4] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 23,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851212,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill09Summon8"
      }
    },
    TaskId = 851269
  },
  [851270] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851215,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851270
  },
  [851271] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851207, Function = "PlayFX"}
    },
    TaskId = 851271
  },
  [851272] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 851208,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 851272
  },
  [851273] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851214,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill09LaserSceneLoc2"
      }
    },
    TaskId = 851273
  },
  [851274] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851214,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill09LaserSceneLoc3"
      }
    },
    TaskId = 851274
  },
  [851275] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851214,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill09LaserSceneLoc4"
      }
    },
    TaskId = 851275
  },
  [851276] = {
    TargetFilter = "BossLinen_Skill03_Scene2",
    TaskEffects = {
      [1] = {
        FXId = 851215,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_498,
      [3] = T.RT_120
    },
    TaskId = 851276
  },
  [851281] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512011,
        UnitType = "Monster"
      }
    },
    TaskId = 851281
  },
  [851282] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512012,
        UnitType = "Monster"
      }
    },
    TaskId = 851282
  },
  [851283] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 40,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8512013,
        UnitType = "Monster"
      }
    },
    TaskId = 851283
  },
  [851284] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851201,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851284
  },
  [851285] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1170,
      [2] = T.RT_1156
    },
    TaskId = 851285
  },
  [851286] = {
    TaskEffects = {
      [1] = {FXId = 851209, Function = "PlayFX"},
      [2] = {
        CreatureId = 851201,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851286
  },
  [851287] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.2
      },
      [2] = T.RT_177,
      [3] = {Function = "PlaySE", SEId = 851210}
    },
    TaskId = 851287
  },
  [851288] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_352,
      [2] = {
        AttachToTarget = true,
        FXId = 2020106,
        Function = "PlayFX",
        IsDecalEffectCreature = true,
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true,
        ReplaceFXId = T.RT_305
      }
    },
    TaskId = 851288
  },
  [851289] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851202,
        Duration = 4.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851289
  },
  [851290] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 1.2
      },
      [2] = {
        CauseHit = "BossLinen_Summon3",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_1156
    },
    TaskId = 851290
  },
  [851291] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851231,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851232,
        Delay = 0.04,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851233,
        Delay = 0.08,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851234,
        Delay = 0.12,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851235,
        Delay = 0.16,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851236,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851291
  },
  [851292] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851237,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851238,
        Delay = 0.04,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851239,
        Delay = 0.08,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851240,
        Delay = 0.12,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851241,
        Delay = 0.16,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851242,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851292
  },
  [851296] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1175,
    TaskId = 851296
  },
  [851297] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1175,
    TaskId = 851297
  },
  [851298] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.15
      }
    },
    TaskId = 851298
  },
  [851301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossKuxiu_Attack",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1104,
      [3] = T.RT_660,
      [4] = T.RT_1176
    },
    TaskId = 851301
  },
  [851302] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossKuxiu_Skill01",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "BossKuxiu_Skill01",
        Function = "CutToughness"
      },
      [3] = T.RT_660,
      [4] = T.RT_1176
    },
    TaskId = 851302
  },
  [851303] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 851302,
        Function = "CreateSkillCreature",
        Location = {
          2,
          153.32,
          50
        }
      }
    },
    TaskId = 851303
  },
  [851304] = {
    NotifyName = T.RT_9,
    TaskEffects = T.RT_1179,
    TaskId = 851304
  },
  [851305] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossKuxiu_Attack",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1104,
      [3] = T.RT_660
    },
    TaskId = 851305
  },
  [851306] = {
    NotifyName = T.RT_9,
    TaskEffects = T.RT_1179,
    TaskId = 851306
  },
  [851307] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1107,
      [2] = {
        CauseHit = "BossKuxiu_ShockWave",
        Function = "CutToughness"
      },
      [3] = T.RT_660,
      [4] = {Function = "PlaySE", SEId = 851303}
    },
    TaskId = 851307
  },
  [851308] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_BossKuxiu_Skill03BulletLoc"
      },
      [2] = {
        CreatureId = 851303,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "EndLeft",
        UseSaveLoc = "StartLeft"
      },
      [3] = {
        CreatureId = 851303,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "EndRight",
        UseSaveLoc = "StartRight"
      },
      [4] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 851304
      }
    },
    TaskId = 851308
  },
  [851309] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104,
      [3] = T.RT_1180,
      [4] = {Function = "PlaySE", SEId = 851306}
    },
    TaskId = 851309
  },
  [851310] = {
    TaskEffects = T.RT_1182,
    TaskId = 851310
  },
  [851311] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_BossKuxiu_Skill05BulletLoc"
      },
      [2] = T.RT_1183,
      [3] = T.RT_1184,
      [4] = T.RT_1185,
      [5] = T.RT_1186,
      [6] = T.RT_1187,
      [7] = T.RT_1188,
      [8] = T.RT_1189
    },
    TaskId = 851311
  },
  [851312] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104,
      [3] = {
        FXId = 851313,
        Function = "PlayFX",
        Overlap = true
      },
      [4] = T.RT_1190
    },
    TaskId = 851312
  },
  [851313] = {
    TaskEffects = {
      [1] = {
        FXId = 851313,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851313
  },
  [851314] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851305,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851306,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851307,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851308,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851314
  },
  [851315] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104,
      [3] = T.RT_1180,
      [4] = T.RT_1190
    },
    TaskId = 851315
  },
  [851316] = {
    TaskEffects = T.RT_1182,
    TaskId = 851316
  },
  [851317] = {
    TaskEffects = T.RT_1192,
    TaskId = 851317
  },
  [851318] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_10,
      [3] = {
        CreatureId = 851315,
        Function = "CreateSkillCreature",
        Location = T.RT_98
      },
      [4] = {Function = "PlaySE", SEId = 851316}
    },
    TaskId = 851318
  },
  [851319] = {
    TaskEffects = T.RT_1192,
    TaskId = 851319
  },
  [851320] = {
    NotifyName = T.RT_12,
    TargetFilter = "Target",
    TaskEffects = T.RT_772,
    TaskId = 851320
  },
  [851321] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSaveLoc = true,
        FXId = 851306,
        Function = "PlayFX"
      }
    },
    TaskId = 851321
  },
  [851322] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSaveLoc = true,
        FXId = 851307,
        Function = "PlayFX"
      }
    },
    TaskId = 851322
  },
  [851323] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104,
      [3] = {
        FXId = 851308,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851323
  },
  [851324] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851309, Function = "PlayFX"}
    },
    TaskId = 851324
  },
  [851325] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851305,
        Function = "RemoveSkillCreature"
      },
      [2] = {
        CreatureId = 851306,
        Function = "RemoveSkillCreature"
      },
      [3] = {
        CreatureId = 851307,
        Function = "RemoveSkillCreature"
      },
      [4] = {
        CreatureId = 851308,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851325
  },
  [851326] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851309,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851310,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851311,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851326
  },
  [851327] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = {
        CreatureId = 851312,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 851327
  },
  [851328] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 851313,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851313Loc"
      },
      [2] = {
        CreatureId = 851310,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851328
  },
  [851329] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "root",
        CreatureId = 851314,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851314Loc"
      },
      [2] = {
        CreatureId = 851311,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851329
  },
  [851330] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851315, Function = "PlayFX"}
    },
    TaskId = 851330
  },
  [851331] = {
    TaskEffects = {
      [1] = {
        FXId = 851310,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851331
  },
  [851332] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104,
      [3] = {
        FXId = 851314,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851332
  },
  [851333] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_BossKuxiu_Skill05BulletLoc2"
      },
      [2] = T.RT_1183,
      [3] = T.RT_1184,
      [4] = T.RT_1185,
      [5] = T.RT_1186,
      [6] = T.RT_1187,
      [7] = T.RT_1188,
      [8] = T.RT_1189
    },
    TaskId = 851333
  },
  [851401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851401,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851401
  },
  [851402] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.135
      },
      [2] = {
        FXId = 851402,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 851407}
    },
    TaskId = 851402
  },
  [851403] = {
    TaskEffects = {
      [1] = {
        FXId = 851402,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851403
  },
  [851404] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851403, Function = "PlayFX"}
    },
    TaskId = 851404
  },
  [851405] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_772,
    TaskId = 851405
  },
  [851406] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSaveLoc = true,
        FXId = 851404,
        Function = "PlayFX"
      }
    },
    TaskId = 851406
  },
  [851407] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSaveLoc = true,
        FXId = 851405,
        Function = "PlayFX"
      }
    },
    TaskId = 851407
  },
  [851408] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_985,
      [2] = T.RT_1104,
      [3] = {
        FXId = 851406,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851408
  },
  [851409] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851404,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851409
  },
  [851410] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1198,
    TaskId = 851410
  },
  [851411] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_1108,
      [2] = T.RT_1104,
      [3] = {
        FXId = 851408,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851411
  },
  [851412] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851405,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851412
  },
  [851413] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851406,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851413
  },
  [851414] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851407,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851414
  },
  [851415] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851408,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851415
  },
  [851416] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851409,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851416
  },
  [851417] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = {
        CreatureId = 851410,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 851417
  },
  [851418] = {
    NotifyName = T.RT_829,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1198,
    TaskId = 851418
  },
  [851419] = {
    TargetFilter = "BossShenpan_GroundHit",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1104
    },
    TaskId = 851419
  },
  [851420] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShenpan_Skill07",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_1199,
      [3] = T.RT_660,
      [4] = T.RT_1200
    },
    TaskId = 851420
  },
  [851421] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShenpan_Skill08",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 3.5
      },
      [2] = T.RT_1199,
      [3] = T.RT_660,
      [4] = T.RT_1200
    },
    TaskId = 851421
  },
  [851422] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851411, Function = "PlayFX"}
    },
    TaskId = 851422
  },
  [851501] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJushi_Skill01_Cylinder",
    TaskEffects = T.RT_1202,
    TaskId = 851501
  },
  [851502] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJushi_Skill02_Cylinder",
    TaskEffects = T.RT_1202,
    TaskId = 851502
  },
  [851503] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1035,
      [2] = {
        FixLocation = true,
        FixLocationZ = 160,
        Function = "SetSelfLoc",
        SaveLocTag = "Skill03Loc",
        TargetCenterLoc = "SavedLoc"
      }
    },
    TaskId = 851503
  },
  [851504] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_BossJushi_Skill04HeadBullet"
      },
      [2] = {
        CreatureId = 851501,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start1"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start2"
      },
      [4] = {
        CreatureId = 851501,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start3"
      },
      [5] = {
        CreatureId = 851501,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start4"
      },
      [6] = {
        CreatureId = 851501,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start5"
      },
      [7] = {
        CreatureId = 851501,
        Delay = 1.0,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Start6"
      }
    },
    TaskId = 851504
  },
  [851505] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = {
        FXId = 851502,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_1203
    },
    TaskId = 851505
  },
  [851506] = {
    TaskEffects = {
      [1] = {
        FXId = 851502,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851506
  },
  [851507] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "spine_02",
        DanmakuTemplateId = 851501,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851507
  },
  [851508] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_508,
      [3] = T.RT_1203
    },
    TaskId = 851508
  },
  [851509] = {
    TaskEffects = T.RT_510,
    TaskId = 851509
  },
  [851510] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "spine_02",
        DanmakuTemplateId = 851502,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851510
  },
  [851511] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "spine_02",
        DanmakuTemplateId = 851503,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851511
  },
  [851512] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851502,
        Function = "CreateSkillCreature",
        Location = T.RT_1204
      }
    },
    TaskId = 851512
  },
  [851513] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_10,
      [3] = T.RT_1205,
      [4] = {Function = "PlaySE", SEId = 851511}
    },
    TaskId = 851513
  },
  [851514] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1206,
      [2] = {
        CreatureId = 851503,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851514Loc"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851514Loc"
      }
    },
    TaskId = 851514
  },
  [851515] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851504,
        Function = "CreateSkillCreature",
        Location = T.RT_1204
      }
    },
    TaskId = 851515
  },
  [851516] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_10,
      [3] = {FXId = 851506, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 851512}
    },
    TaskId = 851516
  },
  [851517] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851505,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851506,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851507,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851508,
        Function = "CreateSkillCreature"
      },
      [5] = T.RT_1207,
      [6] = T.RT_1208
    },
    TaskId = 851517
  },
  [851518] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851509,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851510,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851511,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851512,
        Function = "CreateSkillCreature"
      },
      [5] = T.RT_1207,
      [6] = T.RT_1208
    },
    TaskId = 851518
  },
  [851519] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_985,
      [2] = T.RT_10,
      [3] = {
        FXId = 851508,
        Function = "PlayFX",
        Overlap = true
      },
      [4] = {Function = "PlaySE", SEId = 851514}
    },
    TaskId = 851519
  },
  [851520] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 2,
        Function = "CreateUnit",
        LifeTime = 6,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851501,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851520
  },
  [851521] = {
    TargetFilter = "BossJushi_Skill07_Burst",
    TaskEffects = {
      [1] = T.RT_1107,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 851516}
    },
    TaskId = 851521
  },
  [851522] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851504,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851522
  },
  [851523] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_508,
      [3] = {Function = "PlaySE", SEId = 851502}
    },
    TaskId = 851523
  },
  [851524] = {
    TaskEffects = T.RT_510,
    TaskId = 851524
  },
  [851525] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851513,
        Function = "CreateSkillCreature",
        Location = T.RT_31
      }
    },
    TaskId = 851525
  },
  [851526] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = T.RT_1209,
      [4] = {Function = "PlaySE", SEId = 851518}
    },
    TaskId = 851526
  },
  [851527] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 3000
      },
      [2] = T.RT_521
    },
    TaskId = 851527
  },
  [851528] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851513,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851528
  },
  [851529] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851505,
        Duration = 2,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851529
  },
  [851530] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851514,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          -182
        }
      }
    },
    TaskId = 851530
  },
  [851531] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 851512, Function = "PlayFX"}
    },
    TaskId = 851531
  },
  [851532] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1206,
      [2] = {
        CreatureId = 851503,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851532Loc"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851532Loc"
      }
    },
    TaskId = 851532
  },
  [851533] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1206,
      [2] = {
        CreatureId = 851503,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851533Loc"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851533Loc"
      }
    },
    TaskId = 851533
  },
  [851534] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1206,
      [2] = {
        CreatureId = 851503,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851534Loc"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851534Loc"
      }
    },
    TaskId = 851534
  },
  [851535] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1206,
      [2] = {
        CreatureId = 851503,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851535Loc"
      },
      [3] = {
        CreatureId = 851501,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "851535Loc"
      }
    },
    TaskId = 851535
  },
  [851536] = {
    TargetFilter = "BossJushi_Passive_Dot",
    TaskEffects = {
      [1] = {
        BuffId = 851501,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 851536
  },
  [851603] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossFuer_Skill02",
    TaskEffects = T.RT_1210,
    TaskId = 851603
  },
  [851607] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851603,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 851603,
        Delay = 0.1,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 851603,
        Delay = 0.2,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 851603,
        Delay = 0.3,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 851603,
        Delay = 0.4,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 851603,
        Delay = 0.5,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [7] = {
        CreatureId = 851603,
        Delay = 0.6,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      },
      [8] = {
        CreatureId = 851603,
        Delay = 0.7,
        ExtraRotation = 101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851607
  },
  [851608] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_504,
      [2] = {
        FXId = 851604,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851608
  },
  [851609] = {
    TaskEffects = {
      [1] = {
        FXId = 851604,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851609
  },
  [851610] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 851610
  },
  [851611] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851604,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = ""
      }
    },
    TaskId = 851611
  },
  [851612] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = {
        FXId = 851607,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851612
  },
  [851613] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        FXId = 851607,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End1",
        UseSaveLoc = ""
      },
      [3] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End2",
        UseSaveLoc = ""
      },
      [4] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End3",
        UseSaveLoc = ""
      },
      [5] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End4",
        UseSaveLoc = ""
      },
      [6] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End5",
        UseSaveLoc = ""
      },
      [7] = {
        CreatureId = 851605,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End6",
        UseSaveLoc = ""
      }
    },
    TaskId = 851613
  },
  [851614] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_10,
      [3] = {
        FXId = 851609,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851614
  },
  [851615] = {
    TaskEffects = {
      [1] = {
        FXId = 851609,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851615
  },
  [851617] = {
    TaskEffects = {
      [1] = {
        FXId = 851610,
        Function = "PlayFX",
        IsAttached = true
      },
      [2] = {
        Delay = 0.2,
        FXId = 851611,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 851617
  },
  [851618] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851606,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "RocketDrop",
        UseSaveLoc = "RocketFire"
      }
    },
    TaskId = 851618
  },
  [851619] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = {
        FXId = 851612,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851619
  },
  [851620] = {
    TaskEffects = {
      [1] = {
        FXId = 851612,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 851620
  },
  [851621] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851607,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851621
  },
  [851622] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851607,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851622
  },
  [851623] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_504,
      [2] = {
        FXId = 851614,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 851623
  },
  [851624] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851608,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 851624
  },
  [851625] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {FXId = 851617, Function = "PlayFX"}
    },
    TaskId = 851625
  },
  [851626] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851609,
        Function = "CreateSkillCreature",
        Location = T.RT_98
      }
    },
    TaskId = 851626
  },
  [851627] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_757
    },
    TaskId = 851627
  },
  [851630] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossFuer_Skill06_Rectangle",
    TaskEffects = T.RT_1211,
    TaskId = 851630
  },
  [851631] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 851631
  },
  [851632] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851611,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851632
  },
  [851635] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossFuer_Skill06_Cylinder",
    TaskEffects = T.RT_1210,
    TaskId = 851635
  },
  [851636] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000206,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 851636
  },
  [851637] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000206,
        BySource = true,
        Function = "RemoveBuff"
      }
    },
    TaskId = 851637
  },
  [851638] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851611,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851638
  },
  [851639] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 1000000
      }
    },
    TaskId = 851639
  },
  [851640] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851614,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851640
  },
  [851641] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851614,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851641
  },
  [851642] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851606,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "RocketDrop1",
        UseSaveLoc = "RocketFire1"
      }
    },
    TaskId = 851642
  },
  [851643] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossFuer_Skill01_1",
    TaskEffects = T.RT_1212,
    TaskId = 851643
  },
  [851644] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851615,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851644
  },
  [851645] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851615,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851645
  },
  [851646] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossFuer_Skill01_2",
    TaskEffects = T.RT_1212,
    TaskId = 851646
  },
  [851647] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossFuer_Skill01_3",
    TaskEffects = T.RT_1212,
    TaskId = 851647
  },
  [851648] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossFuer_Skill01_4",
    TaskEffects = T.RT_1212,
    TaskId = 851648
  },
  [851649] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossFuer_Skill01_5",
    TaskEffects = T.RT_1212,
    TaskId = 851649
  },
  [851650] = {
    NotifyName = T.RT_507,
    TargetFilter = "BossFuer_Skill01_6",
    TaskEffects = T.RT_1212,
    TaskId = 851650
  },
  [851651] = {
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1211,
    TaskId = 851651
  },
  [851652] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851616,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851652
  },
  [851653] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851616,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851653
  },
  [851654] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_10,
      [2] = T.RT_3,
      [3] = T.RT_660
    },
    TaskId = 851654
  },
  [851701] = {
    NotifyName = T.RT_666,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1214,
    TaskId = 851701
  },
  [851702] = {
    NotifyName = T.RT_13,
    TaskEffects = {
      [1] = {
        CreatureId = 851702,
        Function = "CreateSkillCreature",
        Location = T.RT_36
      }
    },
    TaskId = 851702
  },
  [851703] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = T.RT_1215
    },
    TaskId = 851703
  },
  [851704] = {
    NotifyName = T.RT_404,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1104,
      [3] = T.RT_1213
    },
    TaskId = 851704
  },
  [851705] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = T.RT_1216,
    TaskId = 851705
  },
  [851706] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_500_360",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_757,
      [3] = T.RT_1213
    },
    TaskId = 851706
  },
  [851707] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1216,
    TaskId = 851707
  },
  [851708] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = T.RT_1217,
    TaskId = 851708
  },
  [851709] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = T.RT_1217,
    TaskId = 851709
  },
  [851710] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ATK = 1,
          DEF = 0,
          ES = 1,
          HP = 1,
          MaxES = 1,
          MaxHp = "1"
        },
        Function = "CreateUnit",
        UnitId = 8517002,
        UnitType = "Monster"
      }
    },
    TaskId = 851710
  },
  [851711] = {
    NotifyName = {
      "hit4",
      "hit1",
      "hit3"
    },
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1214,
    TaskId = 851711
  },
  [851712] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1143,
      [3] = T.RT_1215
    },
    TaskId = 851712
  },
  [851713] = {
    NotifyName = T.RT_507,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 851713
  },
  [851714] = {
    NotifyName = T.RT_825,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 851701,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 851714
  },
  [851801] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 4.5,
        MaxSummonCount = 5,
        Rotation = T.RT_187,
        SingleSummonCount = 1,
        UnitId = 851801,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851801
  },
  [851802] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 3.05,
        MaxSummonCount = 5,
        Rotation = {
          0,
          0,
          -30
        },
        SingleSummonCount = 1,
        UnitId = 851802,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851802
  },
  [851803] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossRobot_Skill07_Cylinder",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_757,
      [3] = {Function = "PlaySE", SEId = 851812}
    },
    TaskId = 851803
  },
  [851804] = {TaskId = 851804},
  [851805] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 851805
  },
  [851806] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_760,
      [2] = {
        CreatureId = 851803,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "",
        UseSaveLoc = "6"
      }
    },
    TaskId = 851806
  },
  [851807] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 851804}
    },
    TaskId = 851807
  },
  [851808] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossJuque_Skill01_Cylinder",
    TaskEffects = T.RT_1218,
    TaskId = 851808
  },
  [851810] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossRobot_Skill02_Cylinder",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_757,
      [3] = {Function = "PlaySE", SEId = 851803}
    },
    TaskId = 851810
  },
  [851811] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FormationId = 851801,
        Function = "BossSPSaveLocs",
        Location = T.RT_347,
        SetSaveLocs = "First"
      },
      [2] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First1"
      },
      [3] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First2"
      },
      [4] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First3"
      },
      [5] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First4"
      },
      [6] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First5"
      },
      [7] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First6"
      },
      [8] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First7"
      },
      [9] = {
        CreatureId = 851802,
        Function = "CreateSkillCreature",
        Location = T.RT_347,
        UseRelativeOffset = true,
        UseSaveLoc = "First8"
      }
    },
    TaskId = 851811
  },
  [851812] = {
    NotifyName = T.RT_525,
    TargetFilter = "BossJuque_Skill01_Cylinder",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 851801}
    },
    TaskId = 851812
  },
  [851813] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_760,
      [2] = {
        CreatureId = 851801,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "",
        UseSaveLoc = "6"
      }
    },
    TaskId = 851813
  },
  [851814] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_760,
      [2] = T.RT_762,
      [3] = {
        CreatureId = 851804,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "1",
        UseSaveLoc = "6"
      },
      [4] = {
        CreatureId = 851804,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "2",
        UseSaveLoc = "7"
      },
      [5] = {
        CreatureId = 851804,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "3",
        UseSaveLoc = "8"
      },
      [6] = {
        CreatureId = 851804,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "4",
        UseSaveLoc = "9"
      },
      [7] = {
        CreatureId = 851804,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "",
        UseSaveLoc = "10"
      }
    },
    TaskId = 851814
  },
  [851815] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossRobot_Skill06_Cylinder",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_757,
      [3] = {Function = "PlaySE", SEId = 851807}
    },
    TaskId = 851815
  },
  [851816] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = {
        FXId = 851805,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_757,
      [4] = {Function = "PlaySE", SEId = 851809}
    },
    TaskId = 851816
  },
  [851817] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "1"
      },
      [2] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "2"
      },
      [3] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "5"
      },
      [4] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "6"
      }
    },
    TaskId = 851817
  },
  [851818] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "3"
      },
      [2] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "4"
      },
      [3] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "7"
      },
      [4] = {
        CreatureId = 851810,
        Function = "CreateSkillCreature",
        UseSaveLoc = "8"
      }
    },
    TaskId = 851818
  },
  [851819] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851805,
        Function = "CreateSkillCreature",
        UseSaveLoc = "loop"
      }
    },
    TaskId = 851819
  },
  [851820] = {
    TargetFilter = "BossJuque_Creature_Rectangle",
    TaskEffects = T.RT_1219,
    TaskId = 851820
  },
  [851821] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 851821
  },
  [851822] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851806,
        Function = "CreateSkillCreature",
        Location = T.RT_996,
        UseSaveLoc = ""
      }
    },
    TaskId = 851822
  },
  [851823] = {
    TargetFilter = "Mon_Cylinder_500_40_360",
    TaskEffects = T.RT_1219,
    TaskId = 851823
  },
  [851824] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1220
    },
    TaskId = 851824
  },
  [851825] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1221,
      [2] = T.RT_1222
    },
    TaskId = 851825
  },
  [851826] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1223,
      [2] = T.RT_1224,
      [3] = T.RT_1225
    },
    TaskId = 851826
  },
  [851827] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1226,
      [2] = T.RT_1227,
      [3] = T.RT_1228,
      [4] = T.RT_1229
    },
    TaskId = 851827
  },
  [851828] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1230,
      [2] = T.RT_1231,
      [3] = T.RT_1232
    },
    TaskId = 851828
  },
  [851829] = {
    NotifyName = T.RT_507,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1233,
      [2] = T.RT_1234
    },
    TaskId = 851829
  },
  [851830] = {
    NotifyName = T.RT_825,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1235
    },
    TaskId = 851830
  },
  [851831] = {
    NotifyName = T.RT_829,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851807,
        Function = "CreateSkillCreature",
        UseSaveLoc = "1"
      }
    },
    TaskId = 851831
  },
  [851832] = {
    NotifyName = T.RT_1145,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851807,
        Function = "CreateSkillCreature",
        UseSaveLoc = "2"
      }
    },
    TaskId = 851832
  },
  [851833] = {
    NotifyName = T.RT_511,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851807,
        Function = "CreateSkillCreature",
        UseSaveLoc = "3"
      }
    },
    TaskId = 851833
  },
  [851834] = {
    NotifyName = T.RT_908,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851807,
        Function = "CreateSkillCreature",
        UseSaveLoc = "4"
      }
    },
    TaskId = 851834
  },
  [851835] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1218,
    TaskId = 851835
  },
  [851836] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 851003,
        Function = "AddBuff",
        LastTime = 99
      },
      [2] = T.RT_1131
    },
    TaskId = 851836
  },
  [851837] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {BuffId = 851003, Function = "RemoveBuff"}
    },
    TaskId = 851837
  },
  [851838] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1220,
      [2] = T.RT_1222,
      [3] = T.RT_1225,
      [4] = T.RT_1229
    },
    TaskId = 851838
  },
  [851839] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1221,
      [2] = T.RT_1224,
      [3] = T.RT_1228,
      [4] = T.RT_1232
    },
    TaskId = 851839
  },
  [851840] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1223,
      [2] = T.RT_1227,
      [3] = T.RT_1231,
      [4] = T.RT_1234
    },
    TaskId = 851840
  },
  [851841] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1226,
      [2] = T.RT_1230,
      [3] = T.RT_1233,
      [4] = T.RT_1235
    },
    TaskId = 851841
  },
  [851842] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1220,
      [2] = T.RT_1221,
      [3] = T.RT_1223,
      [4] = T.RT_1226
    },
    TaskId = 851842
  },
  [851843] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1222,
      [2] = T.RT_1224,
      [3] = T.RT_1227,
      [4] = T.RT_1230
    },
    TaskId = 851843
  },
  [851844] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1225,
      [2] = T.RT_1228,
      [3] = T.RT_1231,
      [4] = T.RT_1233
    },
    TaskId = 851844
  },
  [851845] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_1229,
      [2] = T.RT_1232,
      [3] = T.RT_1234,
      [4] = T.RT_1235
    },
    TaskId = 851845
  },
  [851846] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 3
      },
      [2] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 4
      },
      [3] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 7
      },
      [4] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 8
      },
      [5] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 9
      },
      [6] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 10
      },
      [7] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 11
      },
      [8] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 12
      }
    },
    TaskId = 851846
  },
  [851847] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 1
      },
      [2] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 2
      },
      [3] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 5
      },
      [4] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 6
      }
    },
    TaskId = 851847
  },
  [851848] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJuque_Skill12_Rectangle",
    TaskEffects = T.RT_1218,
    TaskId = 851848
  },
  [851849] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851808,
        Function = "CreateSkillCreature",
        Location = {
          0,
          -150,
          0
        }
      }
    },
    TaskId = 851849
  },
  [851850] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 13
      },
      [2] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 14
      },
      [3] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 15
      },
      [4] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 16
      }
    },
    TaskId = 851850
  },
  [851851] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 13
      },
      [2] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 14
      },
      [3] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 15
      },
      [4] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 16
      }
    },
    TaskId = 851851
  },
  [851852] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJuque_Skill11_Rectangle",
    TaskEffects = T.RT_1218,
    TaskId = 851852
  },
  [851853] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851809,
        Function = "CreateSkillCreature",
        Location = T.RT_193
      }
    },
    TaskId = 851853
  },
  [851854] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1218,
    TaskId = 851854
  },
  [851855] = {
    NotifyName = T.RT_829,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851811,
        Function = "CreateSkillCreature",
        UseSaveLoc = "1"
      }
    },
    TaskId = 851855
  },
  [851856] = {
    NotifyName = T.RT_908,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 851811,
        Function = "CreateSkillCreature",
        UseSaveLoc = "4"
      }
    },
    TaskId = 851856
  },
  [851901] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851901,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851901
  },
  [851902] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = T.RT_1237,
    TaskId = 851902
  },
  [851903] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851901,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851903
  },
  [851904] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851901,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851904
  },
  [851905] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_508
    },
    TaskId = 851905
  },
  [851906] = {
    TaskEffects = T.RT_510,
    TaskId = 851906
  },
  [851907] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 851902,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 851907
  },
  [851908] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLiecheHand_Skill01",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1238
    },
    TaskId = 851908
  },
  [851909] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_BossLiecheHand_Skill02Bullet"
      },
      [2] = {
        CreatureId = 851902,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End1",
        UseSaveLoc = "Start1"
      },
      [3] = {
        CreatureId = 851902,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End2",
        UseSaveLoc = "Start2"
      },
      [4] = {
        CreatureId = 851902,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End3",
        UseSaveLoc = "Start3"
      },
      [5] = {
        CreatureId = 851902,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End4",
        UseSaveLoc = "Start4"
      },
      [6] = {
        CreatureId = 851902,
        Delay = 0.8,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End5",
        UseSaveLoc = "Start5"
      }
    },
    TaskId = 851909
  },
  [851910] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1180
    },
    TaskId = 851910
  },
  [851911] = {TaskId = 851911},
  [851912] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_675,
      [2] = T.RT_1239
    },
    TaskId = 851912
  },
  [851913] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1240,
      [2] = {
        CreatureId = 851903,
        Delay = 2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LMid"
      },
      [3] = {
        CreatureId = 851903,
        Delay = 4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LDown"
      }
    },
    TaskId = 851913
  },
  [851914] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = T.RT_1209
    },
    TaskId = 851914
  },
  [851915] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851906,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down1"
      },
      [2] = {
        CreatureId = 851907,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up2"
      },
      [3] = {
        CreatureId = 851906,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down3"
      },
      [4] = {
        CreatureId = 851907,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up4"
      },
      [5] = {
        CreatureId = 851906,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down5"
      },
      [6] = {
        CreatureId = 851907,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up6"
      }
    },
    TaskId = 851915
  },
  [851916] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851907,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up1"
      },
      [2] = {
        CreatureId = 851906,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down2"
      },
      [3] = {
        CreatureId = 851907,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up3"
      },
      [4] = {
        CreatureId = 851906,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down4"
      },
      [5] = {
        CreatureId = 851907,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up5"
      },
      [6] = {
        CreatureId = 851906,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down6"
      }
    },
    TaskId = 851916
  },
  [851917] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851908,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down1"
      },
      [2] = {
        CreatureId = 851909,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up2"
      },
      [3] = {
        CreatureId = 851908,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down3"
      },
      [4] = {
        CreatureId = 851909,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up4"
      },
      [5] = {
        CreatureId = 851908,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down5"
      },
      [6] = {
        CreatureId = 851909,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up6"
      }
    },
    TaskId = 851917
  },
  [851918] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851909,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up1"
      },
      [2] = {
        CreatureId = 851908,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down2"
      },
      [3] = {
        CreatureId = 851909,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up3"
      },
      [4] = {
        CreatureId = 851908,
        Delay = 0.5,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down4"
      },
      [5] = {
        CreatureId = 851909,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Up5"
      },
      [6] = {
        CreatureId = 851908,
        Delay = 1,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Down6"
      }
    },
    TaskId = 851918
  },
  [851919] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Skill03",
        TargetType = "Target"
      },
      [2] = {
        CreatureId = 851910,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill03"
      }
    },
    TaskId = 851919
  },
  [851920] = {
    TargetFilter = "BossLieche_Skill07Step01",
    TaskEffects = T.RT_1242,
    TaskId = 851920
  },
  [851921] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1243,
    TaskId = 851921
  },
  [851922] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851902,
        UnitType = "MechanismSummon",
        UseSaveLoc = "Skill04"
      }
    },
    TaskId = 851922
  },
  [851923] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1244,
      [2] = T.RT_1245,
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 8519006,
        UnitType = "Monster",
        UseSaveLoc = "Skill05R"
      }
    },
    TaskId = 851923
  },
  [851924] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLiecheBomb_Burst",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1238,
      [3] = {FXId = 851908, Function = "PlayFX"}
    },
    TaskId = 851924
  },
  [851925] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 8519004,
        UnitType = "Monster",
        UseSaveLoc = "Skill05L"
      }
    },
    TaskId = 851925
  },
  [851926] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_1243,
    TaskId = 851926
  },
  [851927] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1246,
      [2] = {
        CreatureId = 851915,
        Delay = 2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LMid"
      },
      [3] = {
        CreatureId = 851915,
        Delay = 4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LDown"
      }
    },
    TaskId = 851927
  },
  [851929] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851901,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851929
  },
  [851930] = {
    TargetFilter = "BossLieche_Skill07Step01",
    TaskEffects = T.RT_1242,
    TaskId = 851930
  },
  [851931] = {
    TargetFilter = "BossLieche_Skill07Step02",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1238,
      [3] = {FXId = 851903, Function = "PlayFX"}
    },
    TaskId = 851931
  },
  [851932] = {
    TargetFilter = "BossLieche_Skill07AllLieche",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1238,
      [3] = {FXId = 851906, Function = "PlayFX"}
    },
    TaskId = 851932
  },
  [851933] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851912,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851933
  },
  [851934] = {
    TargetFilter = "BossLieche_Skill07Attach",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1238,
      [3] = {FXId = 851905, Function = "PlayFX"}
    },
    TaskId = 851934
  },
  [851935] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851913,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851935
  },
  [851936] = {
    TargetFilter = "BossLieche_Skill07Step03",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1238,
      [3] = {FXId = 851904, Function = "PlayFX"}
    },
    TaskId = 851936
  },
  [851937] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Step04",
        TargetType = "Target"
      },
      [2] = {
        CreatureId = 851914,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Step04"
      }
    },
    TaskId = 851937
  },
  [851938] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1244,
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 8519006,
        UnitType = "Monster",
        UseSaveLoc = "Skill05M"
      },
      [3] = T.RT_1247
    },
    TaskId = 851938
  },
  [851939] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 8519006,
        UnitType = "Monster",
        UseSaveLoc = "Skill05L"
      },
      [2] = T.RT_1245,
      [3] = T.RT_1247
    },
    TaskId = 851939
  },
  [851940] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851916,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851940
  },
  [851941] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = T.RT_1237,
    TaskId = 851941
  },
  [851942] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851916,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851942
  },
  [851943] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851903,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851943
  },
  [851944] = {
    TargetFilter = "BossLiecheCore_Skill02Burst",
    TaskEffects = T.RT_1242,
    TaskId = 851944
  },
  [851945] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851902,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 851945
  },
  [851946] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 851902, Function = "RemoveBuff"}
    },
    TaskId = 851946
  },
  [851947] = {
    TaskEffects = {
      [1] = {
        CreatureId = 851917,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851947
  },
  [851948] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851918,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 851948
  },
  [851949] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851918,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 851949
  },
  [851950] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1248,
      [2] = {
        CreatureId = 851919,
        Delay = 2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RMid"
      },
      [3] = {
        CreatureId = 851919,
        Delay = 4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RDown"
      }
    },
    TaskId = 851950
  },
  [851951] = {
    NotifyName = T.RT_829,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1249,
      [2] = {
        CreatureId = 851920,
        Delay = 2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RMid"
      },
      [3] = {
        CreatureId = 851920,
        Delay = 4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RDown"
      }
    },
    TaskId = 851951
  },
  [851952] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {Hp = 0.4, MaxHp = 0.4},
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 8519008,
        UnitType = "Monster",
        UseSaveLoc = "Skill07Center"
      }
    },
    TaskId = 851952
  },
  [851953] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1248,
      [2] = {
        CreatureId = 851919,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RMid"
      },
      [3] = {
        CreatureId = 851919,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RDown"
      }
    },
    TaskId = 851953
  },
  [851954] = {
    NotifyName = T.RT_829,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1249,
      [2] = {
        CreatureId = 851920,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RMid"
      },
      [3] = {
        CreatureId = 851920,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "RDown"
      }
    },
    TaskId = 851954
  },
  [851955] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1240,
      [2] = {
        CreatureId = 851903,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LMid"
      },
      [3] = {
        CreatureId = 851903,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LDown"
      }
    },
    TaskId = 851955
  },
  [851956] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1246,
      [2] = {
        CreatureId = 851915,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LMid"
      },
      [3] = {
        CreatureId = 851915,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        UseSaveLoc = "LDown"
      }
    },
    TaskId = 851956
  },
  [851957] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851921,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill091"
      },
      [2] = {
        CreatureId = 851923,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill092"
      }
    },
    TaskId = 851957
  },
  [851958] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851922,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill091"
      },
      [2] = {
        CreatureId = 851924,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill092"
      }
    },
    TaskId = 851958
  },
  [851959] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851925,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill093"
      },
      [2] = {
        CreatureId = 851927,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill094"
      }
    },
    TaskId = 851959
  },
  [851960] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851926,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill093"
      },
      [2] = {
        CreatureId = 851928,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill094"
      }
    },
    TaskId = 851960
  },
  [851961] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851929,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill095"
      }
    },
    TaskId = 851961
  },
  [851962] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 851930,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill095"
      }
    },
    TaskId = 851962
  },
  [851963] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1251,
      [2] = T.RT_1253,
      [3] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519306"
      },
      [4] = T.RT_1254,
      [5] = T.RT_1255,
      [6] = T.RT_1256,
      [7] = T.RT_1257,
      [8] = T.RT_1258,
      [9] = T.RT_1259,
      [10] = T.RT_1252
    },
    TaskId = 851963
  },
  [851964] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519303"
      },
      [2] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519305"
      },
      [3] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519307"
      },
      [4] = T.RT_1254,
      [5] = T.RT_1260,
      [6] = T.RT_1261,
      [7] = T.RT_1262,
      [8] = T.RT_1258,
      [9] = T.RT_1259,
      [10] = T.RT_1252
    },
    TaskId = 851964
  },
  [851965] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1251,
      [2] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519308"
      },
      [3] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519310"
      },
      [4] = T.RT_1254,
      [5] = T.RT_1255,
      [6] = T.RT_1256,
      [7] = T.RT_1257,
      [8] = T.RT_1261,
      [9] = T.RT_1259,
      [10] = T.RT_1262
    },
    TaskId = 851965
  },
  [851966] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519301"
      },
      [2] = T.RT_1253,
      [3] = {
        AttrRates = T.RT_1250,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8519009,
        UnitType = "Monster",
        UseSaveLoc = "8519309"
      },
      [4] = T.RT_1260,
      [5] = T.RT_1255,
      [6] = T.RT_1256,
      [7] = T.RT_1257,
      [8] = T.RT_1258,
      [9] = T.RT_1262,
      [10] = T.RT_1252
    },
    TaskId = 851966
  },
  [851967] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851903,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 851967
  },
  [851968] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 851903, Function = "RemoveBuff"}
    },
    TaskId = 851968
  },
  [851969] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851904,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 851969
  },
  [851970] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 851904, Function = "RemoveBuff"}
    },
    TaskId = 851970
  },
  [851971] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851905,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 851971
  },
  [851972] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 851905, Function = "RemoveBuff"}
    },
    TaskId = 851972
  },
  [851973] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 851906,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 851973
  },
  [851974] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 851906, Function = "RemoveBuff"}
    },
    TaskId = 851974
  },
  [851975] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 851904,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 851975
  },
  [851976] = {
    TargetFilter = "BossLiecheCore_Skill05Burst1",
    TaskEffects = T.RT_1263,
    TaskId = 851976
  },
  [851977] = {
    TargetFilter = "BossLiecheCore_Skill05Burst2",
    TaskEffects = T.RT_1263,
    TaskId = 851977
  },
  [851978] = {
    TargetFilter = "BossLiecheCore_Skill05Burst3",
    TaskEffects = T.RT_1263,
    TaskId = 851978
  },
  [852001] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200101,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200102,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200103,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200104,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852005,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200105,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200106,
        UseBattlePointRotation = 1
      },
      [7] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200107,
        UseBattlePointRotation = 1
      },
      [8] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200108,
        UseBattlePointRotation = 1
      },
      [9] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200109,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852001
  },
  [852002] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200110,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200111,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200112,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200113,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200114,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200115,
        UseBattlePointRotation = 1
      },
      [7] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200116,
        UseBattlePointRotation = 1
      },
      [8] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200117,
        UseBattlePointRotation = 1
      },
      [9] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200118,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852002
  },
  [852003] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200119,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200120,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200121,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200122,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200123,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852003
  },
  [852004] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "HitFly_XY0Z3000",
        Function = "CutToughness"
      },
      [3] = T.RT_1209
    },
    TaskId = 852004
  },
  [852005] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossAida_Skill02_BoxL",
    TaskEffects = T.RT_1265,
    TaskId = 852005
  },
  [852006] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852007,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 852006
  },
  [852007] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = T.RT_1205
    },
    TaskId = 852007
  },
  [852008] = {
    TargetFilter = "BossAida_Skill04_Box1",
    TaskEffects = T.RT_1265,
    TaskId = 852008
  },
  [852009] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1266,
      [2] = T.RT_1268,
      [3] = T.RT_1269,
      [4] = T.RT_1270,
      [5] = T.RT_1271,
      [6] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200507,
        UseBattlePointRotation = 1
      },
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852009
  },
  [852010] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200502,
        UseBattlePointRotation = 1
      },
      [2] = T.RT_1268,
      [3] = T.RT_1269,
      [4] = T.RT_1270,
      [5] = T.RT_1271,
      [6] = T.RT_1275,
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852010
  },
  [852011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1264,
      [3] = T.RT_1209
    },
    TaskId = 852011
  },
  [852013] = {
    NotifyName = T.RT_511,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85200000,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852013
  },
  [852014] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossAida_Skill02_BoxR",
    TaskEffects = T.RT_1265,
    TaskId = 852014
  },
  [852015] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85200501,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852015
  },
  [852016] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85200701,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852016
  },
  [852017] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 852010,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200000,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852017
  },
  [852018] = {
    TargetFilter = "BossAida_Skill07_Box1",
    TaskEffects = T.RT_1276,
    TaskId = 852018
  },
  [852019] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852011,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200702,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852019
  },
  [852020] = {
    TargetFilter = "BossAida_Skill07_Box2",
    TaskEffects = T.RT_1276,
    TaskId = 852020
  },
  [852021] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852012,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200703,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852021
  },
  [852022] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852026,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200704,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852022
  },
  [852023] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852027,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200705,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852023
  },
  [852024] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852010,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 852024
  },
  [852025] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852028,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200706,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852025
  },
  [852026] = {
    TargetFilter = "BossTuosi_Skill08_AroundBurstCylinder",
    TaskEffects = {
      [1] = T.RT_1108,
      [2] = T.RT_1117
    },
    TaskId = 852026
  },
  [852027] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_1114
    },
    TaskId = 852027
  },
  [852029] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1278,
    TaskId = 852029
  },
  [852030] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852014,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200803,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852014,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200805,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852014,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200808,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852014,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200810,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852030
  },
  [852031] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "BossAida_Skill08TrainHit",
        Function = "CutToughness"
      }
    },
    TaskId = 852031
  },
  [852032] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852015,
        Function = "CreateSkillCreature",
        UseBattlePointID = 852008031,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852015,
        Function = "CreateSkillCreature",
        UseBattlePointID = 852008051,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852015,
        Function = "CreateSkillCreature",
        UseBattlePointID = 852008081,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852015,
        Function = "CreateSkillCreature",
        UseBattlePointID = 852008101,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852032
  },
  [852033] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Skill08",
        TargetType = "Target"
      },
      [2] = {
        CreatureId = 852016,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          -1000
        },
        Rotation = T.RT_997,
        UseSaveLoc = "Skill08"
      },
      [3] = {
        CreatureId = 852016,
        Delay = 0.3,
        Function = "CreateSkillCreature",
        Location = {
          500,
          500,
          -1000
        },
        Rotation = T.RT_997,
        UseSaveLoc = "Skill08"
      },
      [4] = {
        CreatureId = 852016,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = {
          0,
          500,
          -1000
        },
        Rotation = T.RT_997,
        UseSaveLoc = "Skill08"
      },
      [5] = {
        CreatureId = 852016,
        Delay = 0.9,
        Function = "CreateSkillCreature",
        Location = {
          -500,
          0,
          -1000
        },
        Rotation = T.RT_997,
        UseSaveLoc = "Skill08"
      },
      [6] = {
        CreatureId = 852016,
        Delay = 1.2,
        Function = "CreateSkillCreature",
        Location = {
          0,
          -500,
          -1000
        },
        Rotation = T.RT_997,
        UseSaveLoc = "Skill08"
      }
    },
    TaskId = 852033
  },
  [852034] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1265,
    TaskId = 852034
  },
  [852035] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8520002,
        UnitType = "Monster",
        UseSaveLoc = "85200901"
      },
      [2] = T.RT_1279,
      [3] = T.RT_1280
    },
    TaskId = 852035
  },
  [852036] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8520002,
        UnitType = "Monster",
        UseSaveLoc = "85200902"
      },
      [2] = T.RT_1281,
      [3] = T.RT_1280
    },
    TaskId = 852036
  },
  [852037] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 8520002,
        UnitType = "Monster",
        UseSaveLoc = "85200903"
      },
      [2] = T.RT_1279,
      [3] = T.RT_1281
    },
    TaskId = 852037
  },
  [852038] = {
    NotifyName = T.RT_908,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Function = "Heal",
        Rate = 0.1
      }
    },
    TaskId = 852038
  },
  [852039] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520004,
        UnitType = "Monster",
        UseSaveLoc = "85201101"
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520005,
        UnitType = "Monster",
        UseSaveLoc = "85201101"
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520006,
        UnitType = "Monster",
        UseSaveLoc = "85201101"
      }
    },
    TaskId = 852039
  },
  [852040] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BoneName = "pelvis",
        DanmakuTemplateId = 852001,
        Duration = 0.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 852040
  },
  [852041] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201101,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852041
  },
  [852042] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201102,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852042
  },
  [852043] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201103,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852043
  },
  [852044] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201104,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852044
  },
  [852045] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201105,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852045
  },
  [852046] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201106,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852046
  },
  [852047] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852017,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201001,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852047
  },
  [852048] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "BossAida_Skill10SPHit",
        Function = "CutToughness"
      }
    },
    TaskId = 852048
  },
  [852049] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852018,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201001,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852049
  },
  [852050] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852017,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201002,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852050
  },
  [852051] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852019,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201002,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852051
  },
  [852052] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852017,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201003,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852052
  },
  [852053] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852020,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201003,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852053
  },
  [852054] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852017,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201004,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852054
  },
  [852055] = {
    NotifyName = T.RT_829,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852021,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201004,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852055
  },
  [852056] = {
    NotifyName = T.RT_1145,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852017,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201005,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852056
  },
  [852057] = {
    NotifyName = T.RT_511,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852022,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201005,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852057
  },
  [852058] = {
    TaskEffects = {
      [1] = {
        CreatureId = 852023,
        Function = "CreateSkillCreature",
        Rotation = T.RT_997
      }
    },
    TaskId = 852058
  },
  [852059] = {
    TaskEffects = {
      [1] = {
        CreatureId = 852024,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200751
      }
    },
    TaskId = 852059
  },
  [852060] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852024,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 852060
  },
  [852061] = {
    NotifyName = T.RT_908,
    TaskEffects = {
      [1] = {
        CreatureId = 852025,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200751
      }
    },
    TaskId = 852061
  },
  [852062] = {
    TargetFilter = "BossAida_Skill10_Box1",
    TaskEffects = T.RT_500,
    TaskId = 852062
  },
  [852063] = {
    NotifyName = T.RT_913,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852018,
        Function = "RemoveSkillCreature"
      },
      [2] = {
        CreatureId = 852019,
        Function = "RemoveSkillCreature"
      },
      [3] = {
        CreatureId = 852020,
        Function = "RemoveSkillCreature"
      },
      [4] = {
        CreatureId = 852021,
        Function = "RemoveSkillCreature"
      },
      [5] = {
        CreatureId = 852022,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 852063
  },
  [852064] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1266,
      [2] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200503,
        UseBattlePointRotation = 1
      },
      [3] = T.RT_1269,
      [4] = T.RT_1270,
      [5] = T.RT_1271,
      [6] = T.RT_1275,
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852064
  },
  [852065] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1266,
      [2] = T.RT_1268,
      [3] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200504,
        UseBattlePointRotation = 1
      },
      [4] = T.RT_1270,
      [5] = T.RT_1271,
      [6] = T.RT_1275,
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852065
  },
  [852066] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1266,
      [2] = T.RT_1268,
      [3] = T.RT_1269,
      [4] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200505,
        UseBattlePointRotation = 1
      },
      [5] = T.RT_1271,
      [6] = T.RT_1275,
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852066
  },
  [852067] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1266,
      [2] = T.RT_1268,
      [3] = T.RT_1269,
      [4] = T.RT_1270,
      [5] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200506,
        UseBattlePointRotation = 1
      },
      [6] = T.RT_1275,
      [7] = T.RT_1272,
      [8] = T.RT_1273,
      [9] = T.RT_1274,
      [10] = T.RT_1267
    },
    TaskId = 852067
  },
  [852068] = {
    TargetFilter = "BossAida_Skill07_Box3",
    TaskEffects = {
      [1] = {
        BuffId = 301,
        Function = "AddBuff",
        LastTime = 2
      }
    },
    TaskId = 852068
  },
  [852069] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85200100,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852069
  },
  [852070] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 852029,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200000,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852070
  },
  [852071] = {
    NotifyName = T.RT_511,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85200751,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852071
  },
  [852072] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520007,
        UnitType = "Monster",
        UseSaveLoc = "85201101"
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520008,
        UnitType = "Monster",
        UseSaveLoc = "85201101"
      }
    },
    TaskId = 852072
  },
  [852073] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1278,
    TaskId = 852073
  },
  [852074] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852030,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 852074
  },
  [852075] = {
    TargetFilter = "BossAida_Skill17_Cylinder1",
    TaskEffects = T.RT_1265,
    TaskId = 852075
  },
  [852076] = {
    TargetFilter = "BossAida_Skill17_Cylinder1_OtFr",
    TaskEffects = T.RT_776,
    TaskId = 852076
  },
  [852077] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SetSelfLoc",
        SaveLocTag = "Skill17",
        TargetCenterLoc = "SavedLoc"
      }
    },
    TaskId = 852077
  },
  [852078] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 852001,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 852078
  },
  [852079] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 852001, Function = "RemoveBuff"}
    },
    TaskId = 852079
  },
  [852080] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 852003,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 852080
  },
  [852081] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 852003, Function = "RemoveBuff"}
    },
    TaskId = 852081
  },
  [852082] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 852004,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 852082
  },
  [852083] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 852004, Function = "RemoveBuff"}
    },
    TaskId = 852083
  },
  [852084] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 852005,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 852084
  },
  [852085] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {BuffId = 852005, Function = "RemoveBuff"}
    },
    TaskId = 852085
  },
  [852086] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201801,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201802,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201803,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201804,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852005,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201805,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201806,
        UseBattlePointRotation = 1
      },
      [7] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201807,
        UseBattlePointRotation = 1
      },
      [8] = {
        CreatureId = 852001,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201808,
        UseBattlePointRotation = 1
      },
      [9] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201809,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852086
  },
  [852087] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201810,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201811,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201812,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201813,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201814,
        UseBattlePointRotation = 1
      },
      [6] = {
        CreatureId = 852003,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201815,
        UseBattlePointRotation = 1
      },
      [7] = {
        CreatureId = 852004,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201816,
        UseBattlePointRotation = 1
      },
      [8] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201817,
        UseBattlePointRotation = 1
      },
      [9] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201818,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852087
  },
  [852088] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201819,
        UseBattlePointRotation = 1
      },
      [2] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201820,
        UseBattlePointRotation = 1
      },
      [3] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201821,
        UseBattlePointRotation = 1
      },
      [4] = {
        CreatureId = 852006,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201822,
        UseBattlePointRotation = 1
      },
      [5] = {
        CreatureId = 852002,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85201823,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852088
  },
  [852089] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201800,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852089
  },
  [852090] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_1278,
    TaskId = 852090
  },
  [852091] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1282,
      [2] = T.RT_1284,
      [3] = T.RT_1285,
      [4] = T.RT_1286,
      [5] = T.RT_1287,
      [6] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200807,
        UseBattlePointRotation = 1
      },
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852091
  },
  [852092] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200802,
        UseBattlePointRotation = 1
      },
      [2] = T.RT_1284,
      [3] = T.RT_1285,
      [4] = T.RT_1286,
      [5] = T.RT_1287,
      [6] = T.RT_1291,
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852092
  },
  [852093] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1282,
      [2] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200803,
        UseBattlePointRotation = 1
      },
      [3] = T.RT_1285,
      [4] = T.RT_1286,
      [5] = T.RT_1287,
      [6] = T.RT_1291,
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852093
  },
  [852094] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1282,
      [2] = T.RT_1284,
      [3] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200804,
        UseBattlePointRotation = 1
      },
      [4] = T.RT_1286,
      [5] = T.RT_1287,
      [6] = T.RT_1291,
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852094
  },
  [852095] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1282,
      [2] = T.RT_1284,
      [3] = T.RT_1285,
      [4] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200805,
        UseBattlePointRotation = 1
      },
      [5] = T.RT_1287,
      [6] = T.RT_1291,
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852095
  },
  [852096] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1282,
      [2] = T.RT_1284,
      [3] = T.RT_1285,
      [4] = T.RT_1286,
      [5] = {
        CreatureId = 852009,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200806,
        UseBattlePointRotation = 1
      },
      [6] = T.RT_1291,
      [7] = T.RT_1288,
      [8] = T.RT_1289,
      [9] = T.RT_1290,
      [10] = T.RT_1283
    },
    TaskId = 852096
  },
  [852097] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 852029,
        Function = "CreateSkillCreature",
        UseBattlePointID = 85200751,
        UseBattlePointRotation = 1
      }
    },
    TaskId = 852097
  },
  [852098] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852031,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 852032,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 852033,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 852034,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 852098
  },
  [852099] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_508,
      [3] = T.RT_1105
    },
    TaskId = 852099
  },
  [900001] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {FXId = 600203, Function = "PlayFX"},
      [3] = {
        BuffId = 6000200,
        Function = "AddBuff",
        LastTime = 3
      }
    },
    TaskId = 900001
  },
  [900002] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1218,
    TaskId = 900002
  },
  [900003] = {
    TargetFilter = "Mech_Bomb_MonAndSelf",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_757
    },
    TaskId = 900003
  },
  [900004] = {
    TargetFilter = "Mech_Bomb_MonAndSelf",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = {
        CauseHit = "HitFly_XY600Z1000",
        Function = "CutToughness",
        Value = 350
      }
    },
    TaskId = 900004
  },
  [900005] = {
    TargetFilter = "Mech_Bomb_MonAndSelf",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_1308
    },
    TaskId = 900005
  },
  [900006] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000001,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900006
  },
  [900007] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000001,
        Function = "ChangeBuffLastTime",
        IsExpand = false,
        LastTimeValue = 5
      }
    },
    TaskId = 900007
  },
  [900008] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1310,
      [2] = T.RT_681
    },
    TaskId = 900008
  },
  [900009] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_772,
    TaskId = 900009
  },
  [900010] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1308
    },
    TaskId = 900010
  },
  [900011] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 5000006,
        Function = "AddBuff",
        LastTime = 100000
      }
    },
    TaskId = 900011
  },
  [900012] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 5000006,
        BySource = true,
        Function = "RemoveBuff"
      }
    },
    TaskId = 900012
  },
  [900013] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1311,
      [2] = {
        CauseHit = "HitFly_XY0Z1000",
        Function = "CutToughness",
        Value = 100
      }
    },
    TaskId = 900013
  },
  [900014] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1311,
      [2] = T.RT_110
    },
    TaskId = 900014
  },
  [900015] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CauseHit = "LightHit_1000_Z",
        Function = "CutToughness",
        Value = 100
      }
    },
    TaskId = 900015
  },
  [900016] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = {
        FXId = 900073,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_679,
      [3] = T.RT_681
    },
    TaskId = 900016
  },
  [900017] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 5000007,
        Function = "AddBuff",
        LastTime = 100000
      }
    },
    TaskId = 900017
  },
  [900018] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 5000008,
        Function = "AddBuff",
        LastTime = 100000
      }
    },
    TaskId = 900018
  },
  [900019] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BuffId = 5000007,
        BySource = true,
        Function = "RemoveBuff"
      },
      [2] = {
        BuffId = 5000008,
        BySource = true,
        Function = "RemoveBuff"
      }
    },
    TaskId = 900019
  },
  [900020] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "RandomLocation",
        Vars = T.RT_958
      },
      [2] = T.RT_1310,
      [3] = T.RT_681
    },
    TaskId = 900020
  },
  [900021] = {
    TargetFilter = "Mech_Target_OtFr",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.4
      },
      [2] = {
        BuffId = 5000018,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900021
  },
  [900022] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0,
        Value = 3
      },
      [2] = {
        BuffId = 5000019,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900022
  },
  [900023] = {
    TargetFilter = "Mech_PlayerSingle",
    TaskEffects = {
      [1] = T.RT_1312
    },
    TaskId = 900023
  },
  [900024] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_553,
      [3] = T.RT_1313
    },
    TaskId = 900024
  },
  [900025] = {
    TargetFilter = "Mech_Target_OtFr",
    TaskEffects = {
      [1] = T.RT_1314,
      [2] = T.RT_553,
      [3] = T.RT_1313
    },
    TaskId = 900025
  },
  [900026] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {Function = "Heal", Value = 800},
      [2] = T.RT_1315
    },
    TaskId = 900026
  },
  [900027] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_226,
    TaskId = 900027
  },
  [900028] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {Function = "Heal", Value = 30},
      [2] = T.RT_225,
      [3] = {Function = "AddBullet", Value = 10}
    },
    TaskId = 900028
  },
  [900029] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {Function = "Heal", Value = 300},
      [2] = T.RT_1315
    },
    TaskId = 900029
  },
  [900030] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {Function = "AddSp", SpChange = 100},
      [2] = T.RT_96
    },
    TaskId = 900030
  },
  [900031] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1175,
    TaskId = 900031
  },
  [900032] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 851002,
        Function = "AddBuff",
        LastTime = 100000
      },
      [2] = T.RT_1312
    },
    TaskId = 900032
  },
  [900040] = {
    TargetFilter = "Mech_TouchBomb_Player",
    TaskEffects = {
      [1] = T.RT_1293,
      [2] = T.RT_504
    },
    TaskId = 900040
  },
  [900041] = {
    TargetFilter = "Mech_TouchBomb_Monster",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 999
      },
      [2] = T.RT_1316
    },
    TaskId = 900041
  },
  [900042] = {
    TargetFilter = "Mech_TouchBomb_Player",
    TaskEffects = {
      [1] = {FXId = 900039, Function = "PlayFX"},
      [2] = T.RT_1311
    },
    TaskId = 900042
  },
  [900043] = {
    TargetFilter = "Mech_TouchBomb_Monster",
    TaskEffects = {
      [1] = T.RT_1317,
      [2] = T.RT_1318
    },
    TaskId = 900043
  },
  [900044] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1317,
      [2] = T.RT_1318,
      [3] = {Function = "PlaySE", SEId = 9000405}
    },
    TaskId = 900044
  },
  [900045] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1317,
      [2] = {
        FXId = 900042,
        Function = "PlayFX",
        IsAttached = true
      },
      [3] = T.RT_1318
    },
    TaskId = 900045
  },
  [900046] = {
    TargetFilter = "Mech_RockBomb_Player",
    TaskEffects = {
      [1] = T.RT_1311,
      [2] = T.RT_1318
    },
    TaskId = 900046
  },
  [900047] = {
    TargetFilter = "Mech_RockBomb_Monster",
    TaskEffects = {
      [1] = T.RT_1317,
      [2] = {FXId = 900040, Function = "PlayFX"},
      [3] = T.RT_1318
    },
    TaskId = 900047
  },
  [900048] = {
    TargetFilter = "Mech_BallBomb_Player",
    TaskEffects = T.RT_1319,
    TaskId = 900048
  },
  [900049] = {
    TargetFilter = "Mech_BallBomb_Monster",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 9999
      },
      [2] = {FXId = 900041, Function = "PlayFX"}
    },
    TaskId = 900049
  },
  [900050] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1320
    },
    TaskId = 900050
  },
  [900051] = {
    TargetFilter = "Mech_Target_OtFr",
    TaskEffects = {
      [1] = T.RT_1314,
      [2] = T.RT_1320
    },
    TaskId = 900051
  },
  [900061] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 900061,
        Function = "CreateSkillCreature"
      },
      [2] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 9000601
      }
    },
    TaskId = 900061
  },
  [900062] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_739,
      [2] = T.RT_1321,
      [3] = {Function = "PlaySE", SEId = 9000602}
    },
    TaskId = 900062
  },
  [900063] = {
    TaskEffects = {
      [1] = T.RT_1321
    },
    TaskId = 900063
  },
  [900064] = {
    TaskEffects = {
      [1] = {FXId = 900061, Function = "PlayFX"}
    },
    TaskId = 900064
  },
  [900070] = {
    TargetFilter = "Mech_IceBomb_Player",
    TaskEffects = T.RT_1319,
    TaskId = 900070
  },
  [900071] = {
    TargetFilter = "Mech_IceBomb_Monster",
    TaskEffects = {
      [1] = T.RT_1311,
      [2] = {FXId = 900043, Function = "PlayFX"},
      [3] = {
        CauseHit = "LightHit_IceBomb",
        Function = "CutToughness",
        Value = 300
      }
    },
    TaskId = 900071
  },
  [900072] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = {
        CreatureId = 900071,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 900072
  },
  [900073] = {
    TargetFilter = "Mech_IceBombField_Monster",
    TaskEffects = {
      [1] = {
        BuffId = 5000021,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 900073
  },
  [900074] = {
    TargetFilter = "Mech_MonAndSelf",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "Default",
        Function = "Damage",
        Rate = 0.4
      }
    },
    TaskId = 900074
  },
  [900075] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.02
      },
      [2] = {
        BuffId = 5000022,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900075
  },
  [900076] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 303,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 900076
  },
  [900077] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 303,
        Function = "ChangeBuffLastTime",
        IsExpand = false,
        LastTimeValue = 3
      }
    },
    TaskId = 900077
  },
  [900078] = {
    TargetFilter = "Mech_Bomb_Player",
    TaskEffects = T.RT_1324,
    TaskId = 900078
  },
  [900079] = {
    TargetFilter = "Mech_Bomb_Monster",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 50
      },
      [2] = T.RT_1325
    },
    TaskId = 900079
  },
  [900080] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 900002,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      },
      [2] = T.RT_681
    },
    TaskId = 900080
  },
  [900081] = {
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_1325
    },
    TaskId = 900081
  },
  [900082] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_20,
    TaskId = 900082
  },
  [900083] = {
    TargetFilter = "Mech_Bomb_PlayerSingle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0,
        Value = 10
      },
      [2] = T.RT_757
    },
    TaskId = 900083
  },
  [900084] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 5,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 900001,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 900084
  },
  [900085] = {
    TargetFilter = "Mech_Cylinder_500_40_360",
    TaskEffects = {
      [1] = {
        BuffId = 5000103,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900085
  },
  [900086] = {
    TargetFilter = "Mech_Bomb",
    TaskEffects = T.RT_1324,
    TaskId = 900086
  },
  [900087] = {
    TargetFilter = "Mech_Bomb_Monster",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 50
      },
      [2] = T.RT_1325
    },
    TaskId = 900087
  },
  [900101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_1326,
      [2] = T.RT_660,
      [3] = T.RT_1327
    },
    TaskId = 900101
  },
  [900102] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_1045,
      [2] = T.RT_660,
      [3] = T.RT_1327
    },
    TaskId = 900102
  },
  [900103] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 2.75
      },
      [2] = T.RT_660,
      [3] = T.RT_110,
      [4] = T.RT_1327
    },
    TaskId = 900103
  },
  [900201] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 900201,
        ExtraRotation = 104,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 900201
  },
  [900202] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1011,
      [2] = {
        FXId = 900202,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_1328
    },
    TaskId = 900202
  },
  [900203] = {
    TaskEffects = {
      [1] = {
        FXId = 900202,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 900203
  },
  [900204] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_1326,
      [2] = T.RT_660,
      [3] = T.RT_1328
    },
    TaskId = 900204
  },
  [900301] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_1330,
    TaskId = 900301
  },
  [900302] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ATK = 0.5,
          DEF = 0,
          MaxES = 0.5,
          MaxHp = 0.5
        },
        FixLocation = true,
        FixLocationNav = 1,
        FixLocationZ = 0,
        FormationId = 900301,
        Function = "CreateUnit",
        LifeTime = 30,
        MaxSummonCount = 2,
        SingleSummonCount = 1,
        UnitId = 9004001,
        UnitType = "Monster"
      }
    },
    TaskId = 900302
  },
  [900303] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 900303,
        Function = "AddBuff",
        LastTime = 12
      }
    },
    TaskId = 900303
  },
  [900304] = {
    NotifyName = T.RT_2,
    TargetFilter = "SQ_Wanju_Skill02_Sphere",
    TaskEffects = {
      [1] = {
        BuffId = 900401,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 900304
  },
  [900305] = {
    NotifyName = T.RT_666,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 1.935
      },
      [2] = T.RT_39,
      [3] = T.RT_660,
      [4] = T.RT_1329
    },
    TaskId = 900305
  },
  [900401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 900401
  },
  [900402] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 900401,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 900402,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 900403,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 900404,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 900402
  },
  [900403] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.56
      },
      [2] = {
        FXId = 900403,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 900403
  },
  [900404] = {
    TaskEffects = {
      [1] = {
        FXId = 900403,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 900404
  },
  [900405] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 900405
  },
  [900406] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_762,
      [2] = {
        CreatureId = 900405,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        SetSavelocAsTarget = "1"
      },
      [3] = {
        CreatureId = 900405,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        SetSavelocAsTarget = "2"
      },
      [4] = {
        CreatureId = 900405,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        SetSavelocAsTarget = "3"
      },
      [5] = {
        CreatureId = 900405,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        SetSavelocAsTarget = "4"
      },
      [6] = {
        CreatureId = 900405,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        SetSavelocAsTarget = ""
      }
    },
    TaskId = 900406
  },
  [900407] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_110,
      [3] = {
        FXId = 900405,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 900407
  },
  [900408] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Function = "Heal",
        Rate = 0.2
      },
      [2] = T.RT_1239
    },
    TaskId = 900408
  },
  [900501] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_1330,
    TaskId = 900501
  },
  [900502] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "Root",
        CreatureId = 900501,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 900502
  },
  [900503] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_18,
      [3] = T.RT_497,
      [4] = T.RT_655
    },
    TaskId = 900503
  },
  [900504] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_357,
      [2] = T.RT_18,
      [3] = T.RT_655
    },
    TaskId = 900504
  },
  [900505] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 900505
  },
  [900506] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_660,
      [3] = T.RT_39,
      [4] = T.RT_1329
    },
    TaskId = 900506
  },
  [900507] = {
    NotifyName = T.RT_9,
    TargetFilter = "SQ_Baozha_Skill03_Sphere",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_18,
      [3] = T.RT_655
    },
    TaskId = 900507
  },
  [900508] = {
    TargetFilter = "SQ_Baozha_Die_Sphere",
    TaskEffects = {
      [1] = T.RT_357,
      [2] = T.RT_10,
      [3] = T.RT_655
    },
    TaskId = 900508
  },
  [900601] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_23,
      [2] = T.RT_660,
      [3] = T.RT_39,
      [4] = T.RT_1331
    },
    TaskId = 900601
  },
  [900602] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_660,
      [3] = T.RT_39,
      [4] = T.RT_1331
    },
    TaskId = 900602
  },
  [900603] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_660,
      [3] = T.RT_39,
      [4] = T.RT_1331
    },
    TaskId = 900603
  },
  [900604] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 900601,
        Function = "CreateSkillCreature",
        Location = T.RT_191
      }
    },
    TaskId = 900604
  },
  [900605] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 900601,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 900605
  },
  [900606] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_1107,
      [2] = T.RT_10,
      [3] = T.RT_4,
      [4] = T.RT_1331
    },
    TaskId = 900606
  },
  [900607] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 900601,
        Function = "AddBuff",
        LastTime = 2.5
      }
    },
    TaskId = 900607
  },
  [900608] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationNav = 1,
        FormationId = 900601,
        Function = "CreateUnit",
        LifeTime = 20,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 9006002,
        UnitType = "Monster"
      }
    },
    TaskId = 900608
  },
  [900609] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 900609
  },
  [900610] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SetSelfLoc",
        SaveLocTag = "NearlistSumLoc",
        TargetCenterLoc = "SavedLoc"
      }
    },
    TaskId = 900610
  },
  [900611] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 900602,
        Function = "CreateSkillCreature",
        Location = T.RT_191
      }
    },
    TaskId = 900611
  },
  [900612] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 900602,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 900612
  },
  [900613] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_10,
      [3] = T.RT_4,
      [4] = T.RT_1331
    },
    TaskId = 900613
  },
  [900614] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 301,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 900614
  },
  [900615] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationNav = 1,
        FixLocationZ = 0,
        FormationId = 900602,
        Function = "CreateUnit",
        LifeTime = 20,
        MaxSummonCount = 5,
        SingleSummonCount = 5,
        UnitId = 9006003,
        UnitType = "Monster"
      }
    },
    TaskId = 900615
  },
  [900616] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SetSelfLoc",
        LocOffset = T.RT_953,
        TargetCenterLoc = "SavedLoc"
      }
    },
    TaskId = 900616
  },
  [900617] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 900602,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 900617
  },
  [900618] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 900602, Function = "RemoveBuff"}
    },
    TaskId = 900618
  },
  [900619] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 900603,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 900619
  },
  [900620] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_660,
      [3] = T.RT_39,
      [4] = T.RT_1331
    },
    TaskId = 900620
  },
  [900701] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1333,
    TaskId = 900701
  },
  [900702] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1336,
    TaskId = 900702
  },
  [900703] = {
    TaskEffects = T.RT_1338,
    TaskId = 900703
  },
  [900704] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1333,
    TaskId = 900704
  },
  [900705] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1336,
    TaskId = 900705
  },
  [900706] = {
    TaskEffects = T.RT_1338,
    TaskId = 900706
  },
  [900707] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 900702,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 900707
  },
  [900708] = {
    TargetFilter = "Mon_Sphere_100_360",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = {FXId = 900704, Function = "PlayFX"}
    },
    TaskId = 900708
  },
  [900709] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_660,
      [3] = T.RT_10,
      [4] = {Function = "PlaySE", SEId = 900704}
    },
    TaskId = 900709
  },
  [950001] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = T.RT_1339,
      [2] = T.RT_1339,
      [3] = T.RT_1339,
      [4] = T.RT_1339,
      [5] = T.RT_1339
    },
    TaskId = 950001
  },
  [950002] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 1051,
        UnitType = "Drop"
      }
    },
    TaskId = 950002
  },
  [950003] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 950001,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 950003
  },
  [950004] = {
    NotifyName = T.RT_741,
    TaskEffects = {
      [1] = {
        CreatureId = 950001,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      },
      [2] = {
        CreatureId = 950002,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      },
      [3] = T.RT_1339
    },
    TaskId = 950004
  },
  [950005] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "head",
        CreatureId = 950006,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 950005
  },
  [950006] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 1052,
        UnitType = "Drop"
      }
    },
    TaskId = 950006
  },
  [950007] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 1053,
        UnitType = "Drop"
      }
    },
    TaskId = 950007
  },
  [950008] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 1005,
        UnitType = "Drop"
      }
    },
    TaskId = 950008
  },
  [950009] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 1016,
        UnitType = "Drop"
      }
    },
    TaskId = 950009
  },
  [950010] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950005,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      }
    },
    TaskId = 950010
  },
  [950011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950007,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      }
    },
    TaskId = 950011
  },
  [950012] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950008,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      }
    },
    TaskId = 950012
  },
  [950013] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950009,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      }
    },
    TaskId = 950013
  },
  [950014] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 51030,
        UnitType = "Drop"
      },
      [2] = {
        Function = "SpawnDrop",
        UnitId = 51031,
        UnitType = "Drop"
      },
      [3] = {
        Function = "SpawnDrop",
        UnitId = 51032,
        UnitType = "Drop"
      },
      [4] = {
        Function = "SpawnDrop",
        UnitId = 51033,
        UnitType = "Drop"
      },
      [5] = {
        Function = "SpawnDrop",
        UnitId = 51034,
        UnitType = "Drop"
      }
    },
    TaskId = 950014
  },
  [950015] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 51035,
        UnitType = "Drop"
      },
      [2] = {
        Function = "SpawnDrop",
        UnitId = 51036,
        UnitType = "Drop"
      },
      [3] = {
        Function = "SpawnDrop",
        UnitId = 51037,
        UnitType = "Drop"
      },
      [4] = {
        Function = "SpawnDrop",
        UnitId = 51038,
        UnitType = "Drop"
      },
      [5] = {
        Function = "SpawnDrop",
        UnitId = 51039,
        UnitType = "Drop"
      }
    },
    TaskId = 950015
  },
  [950016] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 51040,
        UnitType = "Drop"
      },
      [2] = {
        Function = "SpawnDrop",
        UnitId = 51041,
        UnitType = "Drop"
      },
      [3] = {
        Function = "SpawnDrop",
        UnitId = 51042,
        UnitType = "Drop"
      },
      [4] = {
        Function = "SpawnDrop",
        UnitId = 51043,
        UnitType = "Drop"
      },
      [5] = {
        Function = "SpawnDrop",
        UnitId = 51044,
        UnitType = "Drop"
      }
    },
    TaskId = 950016
  },
  [950017] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 4901,
        UnitType = "Drop"
      }
    },
    TaskId = 950017
  },
  [950018] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950010,
        Function = "CreateSkillCreature",
        Location = T.RT_419
      }
    },
    TaskId = 950018
  },
  [950019] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = T.RT_1340,
      [2] = T.RT_1340,
      [3] = T.RT_1340
    },
    TaskId = 950019
  },
  [950020] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_1316,
      [2] = {
        FXId = 950005,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 950020
  },
  [950021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_520
    },
    TaskId = 950021
  },
  [950022] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "SpawnDrop",
        UnitId = 3014,
        UnitType = "Drop"
      }
    },
    TaskId = 950022
  },
  [950023] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 950002,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 950023
  },
  [950024] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 950002, Function = "RemoveBuff"}
    },
    TaskId = 950024
  },
  [950025] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 950025
  },
  [950026] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 950003,
        Function = "AddBuff",
        LastTime = 7
      }
    },
    TaskId = 950026
  },
  [950101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1342,
    TaskId = 950101
  },
  [950102] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1342,
    TaskId = 950102
  },
  [950103] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1342,
    TaskId = 950103
  },
  [950104] = {
    NotifyName = T.RT_1103,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "LightHit_80",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_4,
      [4] = T.RT_1341
    },
    TaskId = 950104
  },
  [950105] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AimSkeletal = "upperarm_r",
        CreatureId = 950101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 950105
  },
  [950106] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_10,
      [3] = {
        FXId = 950102,
        Function = "PlayFX",
        Overlap = true
      },
      [4] = {Function = "PlaySE", SEId = 950101}
    },
    TaskId = 950106
  },
  [950107] = {
    TaskEffects = {
      [1] = {
        FXId = 950102,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 950107
  },
  [950108] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950102,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 950108
  },
  [950109] = {
    TaskEffects = {
      [1] = {
        CreatureId = 950102,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 950109
  },
  [950110] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_753,
    TaskId = 950110
  },
  [950401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 950401,
        Function = "CreateSkillCreature",
        Rotation = {
          20,
          0,
          0
        }
      }
    },
    TaskId = 950401
  },
  [950402] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        FXId = 950401,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 950402}
    },
    TaskId = 950402
  },
  [950403] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 950401,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = {
        Function = "PlaySE",
        SEId = 950402,
        SceneSe = true
      }
    },
    TaskId = 950403
  },
  [950404] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 950401,
        Function = "CreateSkillCreature",
        Rotation = {
          -15,
          -15,
          0
        }
      }
    },
    TaskId = 950404
  },
  [950405] = {
    NotifyName = T.RT_2,
    TargetFilter = "NEWuyou_Skill02Burst1",
    TaskEffects = T.RT_1344,
    TaskId = 950405
  },
  [950406] = {
    NotifyName = T.RT_9,
    TargetFilter = "NEWuyou_Skill02Burst2",
    TaskEffects = T.RT_1344,
    TaskId = 950406
  },
  [950407] = {
    NotifyName = T.RT_12,
    TargetFilter = "NEWuyou_Skill02Burst3",
    TaskEffects = T.RT_1344,
    TaskId = 950407
  },
  [950408] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 950401,
        Function = "CreateSkillCreature",
        Rotation = T.RT_419
      }
    },
    TaskId = 950408
  },
  [950501] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_1345,
      [3] = {FXId = 950501, Function = "PlayFX"}
    },
    TaskId = 950501
  },
  [950502] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_778,
      [2] = T.RT_1343
    },
    TaskId = 950502
  },
  [950601] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_400_200_180",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_1345
    },
    TaskId = 950601
  },
  [950602] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360_180",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 1
      }
    },
    TaskId = 950602
  },
  [950701] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1347,
    TaskId = 950701
  },
  [950702] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1347,
    TaskId = 950702
  },
  [951001] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1349,
    TaskId = 951001
  },
  [951002] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1349,
    TaskId = 951002
  },
  [951003] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_200_180",
    TaskEffects = T.RT_1349,
    TaskId = 951003
  },
  [980101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_1350
    },
    TaskId = 980101
  },
  [980102] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1350
    },
    TaskId = 980102
  },
  [980103] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_1351,
    TaskId = 980103
  },
  [980104] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_10,
      [3] = T.RT_1350
    },
    TaskId = 980104
  },
  [980105] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1143,
      [3] = T.RT_1350
    },
    TaskId = 980105
  },
  [980106] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1351,
    TaskId = 980106
  },
  [980107] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_776,
    TaskId = 980107
  },
  [980108] = {
    TargetFilter = "Mon_Sphere_400_360_Fr",
    TaskEffects = {
      [1] = T.RT_687,
      [2] = T.RT_620,
      [3] = T.RT_685
    },
    TaskId = 980108
  },
  [980109] = {
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_10,
      [3] = T.RT_685
    },
    TaskId = 980109
  },
  [980201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_300_90",
    TaskEffects = T.RT_1353,
    TaskId = 980201
  },
  [980202] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_230_200_180",
    TaskEffects = T.RT_1354,
    TaskId = 980202
  },
  [980203] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1354,
    TaskId = 980203
  },
  [980204] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Rectangle_80_200_100",
    TaskEffects = T.RT_1353,
    TaskId = 980204
  },
  [980301] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_1355
    },
    TaskId = 980301
  },
  [980302] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1355
    },
    TaskId = 980302
  },
  [980303] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_659,
      [2] = T.RT_10,
      [3] = T.RT_1355
    },
    TaskId = 980303
  },
  [980304] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 980301,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 980304
  },
  [980305] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_10,
      [3] = T.RT_1355
    },
    TaskId = 980305
  },
  [980306] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_150_50_90",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_1143,
      [3] = T.RT_1355
    },
    TaskId = 980306
  },
  [980401] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1357,
    TaskId = 980401
  },
  [980501] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1357,
    TaskId = 980501
  },
  [980701] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 980701,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 980701
  },
  [980702] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_684
    },
    TaskId = 980702
  },
  [1000101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_200_200_180",
    TaskEffects = T.RT_6,
    TaskId = 1000101
  },
  [1000102] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_200_200_180",
    TaskEffects = T.RT_6,
    TaskId = 1000102
  },
  [1000103] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_8,
    TaskId = 1000103
  },
  [1000104] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_300_200_180_180",
    TaskEffects = T.RT_11,
    TaskId = 1000104
  },
  [1000105] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_11,
    TaskId = 1000105
  },
  [1000106] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1000101,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1000106
  },
  [1000107] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 1000101, Function = "RemoveBuff"}
    },
    TaskId = 1000107
  },
  [1000108] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1000102,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1000108
  },
  [1000109] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 1000102, Function = "RemoveBuff"}
    },
    TaskId = 1000109
  },
  [1000110] = {
    NotifyName = T.RT_13,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = T.RT_15,
    TaskId = 1000110
  },
  [1000111] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1000501,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1000111
  },
  [1000112] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 1000501, Function = "RemoveBuff"}
    },
    TaskId = 1000112
  },
  [1000113] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1000502,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1000113
  },
  [1000114] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 1000502, Function = "RemoveBuff"}
    },
    TaskId = 1000114
  },
  [1000201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_250_200_120",
    TaskEffects = T.RT_15,
    TaskId = 1000201
  },
  [1000202] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Loc1",
        TargetType = "Target"
      }
    },
    TaskId = 1000202
  },
  [1000203] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000202,
        Function = "CreateSkillCreature",
        Location = {
          0,
          100,
          0
        }
      }
    },
    TaskId = 1000203
  },
  [1000204] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000202,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1000204
  },
  [1000205] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_250_400_180",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_4,
      [3] = T.RT_17,
      [4] = T.RT_5
    },
    TaskId = 1000205
  },
  [1000206] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_360_Tianwei",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_4,
      [3] = T.RT_10,
      [4] = T.RT_5
    },
    TaskId = 1000206
  },
  [1000207] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_500_360_Tianwei",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_4,
      [3] = T.RT_18,
      [4] = T.RT_5
    },
    TaskId = 1000207
  },
  [1000208] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 1000208
  },
  [1000209] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1000201,
        Function = "CreateSkillCreature",
        Location = T.RT_21,
        SetSavelocAsTarget = ""
      }
    },
    TaskId = 1000209
  },
  [1000210] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_10,
      [3] = {
        FXId = 600008,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 1000210
  },
  [1000211] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        FXId = 600008,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 1000211
  },
  [1000212] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_500_360",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_18
    },
    TaskId = 1000212
  },
  [1000213] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_4,
      [3] = T.RT_10
    },
    TaskId = 1000213
  },
  [1000214] = {
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_SetBool",
        Vars = {
          BoolKey = "InZhilvChargeState",
          BoolValue = true
        }
      }
    },
    TaskId = 1000214
  },
  [1000215] = {
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_SetBool",
        Vars = {
          BoolKey = "InZhilvChargeState",
          BoolValue = false
        }
      }
    },
    TaskId = 1000215
  },
  [1000301] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossBianA_Attack01_1",
    TaskEffects = T.RT_25,
    TaskId = 1000301
  },
  [1000302] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 1000302
  },
  [1000303] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossBianA_Skill01_1",
    TaskEffects = {
      [1] = T.RT_23,
      [2] = T.RT_10,
      [3] = {Function = "PlaySE", SEId = 10003002}
    },
    TaskId = 1000303
  },
  [1000304] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000301,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 1000302,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 1000303,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 1000304
  },
  [1000305] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = {FXId = 1000302, Function = "PlayFX"},
      [3] = {Function = "PlaySE", SEId = 10003003}
    },
    TaskId = 1000305
  },
  [1000306] = {
    TaskEffects = {
      [1] = {
        FXId = 1000302,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 1000306
  },
  [1000307] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossBianA_Skill03_1",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_10,
      [3] = T.RT_26,
      [4] = {Function = "PlaySE", SEId = 10003005}
    },
    TaskId = 1000307
  },
  [1000308] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "Mon_AnimHeiBiAn_Skill03Blade"
      },
      [2] = {
        CreatureId = 1000304,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Target1",
        UseSaveLoc = "BornBlade"
      },
      [3] = {
        CreatureId = 1000304,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Target2",
        UseSaveLoc = "BornBlade"
      },
      [4] = {
        CreatureId = 1000304,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Target3",
        UseSaveLoc = "BornBlade"
      }
    },
    TaskId = 1000308
  },
  [1000309] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_600_200_360",
    TaskEffects = T.RT_28,
    TaskId = 1000309
  },
  [1000310] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossBiAn_Corp_Rectangle",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_18,
      [3] = T.RT_26,
      [4] = {Function = "PlaySE", SEId = 10003007}
    },
    TaskId = 1000310
  },
  [1000311] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossBiAn_Corp_Cylinder",
    TaskEffects = T.RT_28,
    TaskId = 1000311
  },
  [1000312] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_30,
    TaskId = 1000312
  },
  [1000313] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 1000304, Function = "PlayFX"}
    },
    TaskId = 1000313
  },
  [1000314] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossBianA_Attack01_2",
    TaskEffects = T.RT_25,
    TaskId = 1000314
  },
  [1000315] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Sphere_400_360",
    TaskEffects = {
      [1] = T.RT_23,
      [2] = T.RT_18,
      [3] = T.RT_24
    },
    TaskId = 1000315
  },
  [1000401] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 1000401,
        Function = "CreateSkillCreature",
        Location = T.RT_31
      }
    },
    TaskId = 1000401
  },
  [1000402] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_23,
      [2] = T.RT_32,
      [3] = {Function = "PlaySE", SEId = 10004001}
    },
    TaskId = 1000402
  },
  [1000403] = {
    TaskEffects = {
      [1] = T.RT_32
    },
    TaskId = 1000403
  },
  [1000404] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000402,
        Function = "CreateSkillCreature",
        Location = {
          0,
          130,
          150
        }
      }
    },
    TaskId = 1000404
  },
  [1000405] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000402,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1000405
  },
  [1000406] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        FXId = 1000403,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = {Function = "PlaySE", SEId = 10004002}
    },
    TaskId = 1000406
  },
  [1000408] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 1000403,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill02_Blade1"
      },
      [2] = {
        CreatureId = 1000403,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill02_Blade2"
      }
    },
    TaskId = 1000408
  },
  [1000409] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_23,
      [2] = T.RT_10,
      [3] = T.RT_34,
      [4] = {Function = "PlaySE", SEId = 10004004}
    },
    TaskId = 1000409
  },
  [1000410] = {
    TaskEffects = {
      [1] = T.RT_34
    },
    TaskId = 1000410
  },
  [1000411] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 1000404,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill02_Blade1"
      },
      [2] = {
        CreatureId = 1000404,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill02_Blade2"
      }
    },
    TaskId = 1000411
  },
  [1000412] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_19,
      [2] = {
        CreatureId = 1000405,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 1000412
  },
  [1000413] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_35,
      [3] = {FXId = 1000402, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 10004007}
    },
    TaskId = 1000413
  },
  [1000414] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossBiAn_Corp_Rectangle",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_18,
      [3] = T.RT_26,
      [4] = {Function = "PlaySE", SEId = 10004008}
    },
    TaskId = 1000414
  },
  [1000415] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossBiAn_Corp_Cylinder",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_18,
      [3] = T.RT_26,
      [4] = {Function = "PlaySE", SEId = 10004009}
    },
    TaskId = 1000415
  },
  [1000416] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_30,
    TaskId = 1000416
  },
  [1000417] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000406,
        Function = "CreateSkillCreature",
        Location = T.RT_36
      }
    },
    TaskId = 1000417
  },
  [1000418] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1000406,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1000418
  },
  [1010111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_46,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          210,
          90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_47,
      [4] = T.RT_48,
      [5] = T.RT_49
    },
    TaskId = 1010111
  },
  [1010112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = {
        Delay = 0.1,
        Function = "PlayFX",
        FxRotator = T.RT_51,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY400Z400_F",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_52,
      [5] = T.RT_49
    },
    TaskId = 1010112
  },
  [1010113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = T.RT_54,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_55,
      [4] = T.RT_49
    },
    TaskId = 1010113
  },
  [1010114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_56,
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = T.RT_57,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY400Z500_F",
        Function = "CutToughness",
        Value = 50
      },
      [4] = T.RT_58,
      [5] = T.RT_59
    },
    TaskId = 1010114
  },
  [1010115] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = T.RT_60,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_55,
      [4] = T.RT_49
    },
    TaskId = 1010115
  },
  [1010121] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 1.13
      },
      [2] = T.RT_62,
      [3] = T.RT_63,
      [4] = T.RT_64,
      [5] = T.RT_65,
      [6] = T.RT_59
    },
    TaskId = 1010121
  },
  [1010131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1010131
  },
  [1010132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_73,
    TaskId = 1010132
  },
  [1010141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_75,
      [2] = T.RT_77,
      [3] = T.RT_78,
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 1010141
  },
  [1010155] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "UpdateSupportSkillCd",
        ModifyValue = "#1"
      }
    },
    TaskId = 1010155
  },
  [1010211] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.65
      },
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          -30,
          90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_85,
      [4] = T.RT_65,
      [5] = T.RT_49
    },
    TaskId = 1010211
  },
  [1010212] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_86,
      [2] = {
        Delay = 0.1,
        Function = "PlayFX",
        FxRotator = T.RT_87,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_88,
      [4] = T.RT_65,
      [5] = T.RT_49
    },
    TaskId = 1010212
  },
  [1010213] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Small",
    TaskEffects = {
      [1] = T.RT_89,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "LightHit_100_F",
        Delay = 0.05,
        Function = "CutToughness",
        Value = 25
      },
      [4] = T.RT_49
    },
    TaskId = 1010213
  },
  [1010214] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_91,
      [2] = {
        Delay = 0.05,
        Function = "PlayFX",
        FxRotator = {
          190,
          90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_92,
      [4] = T.RT_79,
      [5] = T.RT_59
    },
    TaskId = 1010214
  },
  [1010221] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 2.28
      },
      [2] = {
        Function = "PlayFX",
        FxRotator = T.RT_87,
        IsFaceToChar = true,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_64,
      [4] = T.RT_79,
      [5] = T.RT_59
    },
    TaskId = 1010221
  },
  [1010299] = {
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = {
        BuffId = 10102,
        Function = "AddBuff",
        LastTime = "#1"
      }
    },
    TaskId = 1010299
  },
  [1010321] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1010301,
        Function = "CreateSkillCreature",
        Rotation = {
          -40,
          0,
          0
        }
      },
      [2] = T.RT_62
    },
    TaskId = 1010321
  },
  [1010322] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 1.14
      },
      [2] = T.RT_63,
      [3] = {
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 36
      },
      [4] = T.RT_59
    },
    TaskId = 1010322
  },
  [1010323] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 1010301,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 1010323
  },
  [1020001] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 1020001
  },
  [1020002] = {
    TargetFilter = "AlmostAllFrd",
    TaskEffects = {
      [1] = {
        BuffId = 10203,
        Function = "AddBuff",
        LastTime = "#1"
      }
    },
    TaskId = 1020002
  },
  [1020111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.35
      },
      [2] = T.RT_90,
      [3] = T.RT_129,
      [4] = T.RT_130,
      [5] = T.RT_59
    },
    TaskId = 1020111
  },
  [1020112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_131,
      [2] = T.RT_90,
      [3] = T.RT_132,
      [4] = T.RT_49
    },
    TaskId = 1020112
  },
  [1020113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = T.RT_90,
      [3] = T.RT_133,
      [4] = T.RT_59
    },
    TaskId = 1020113
  },
  [1020114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 25
      },
      [4] = T.RT_65,
      [5] = T.RT_49
    },
    TaskId = 1020114
  },
  [1020115] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.75
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY600Z400_F",
        Function = "CutToughness",
        Value = 50
      },
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1020115
  },
  [1020121] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1020101,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_62
    },
    TaskId = 1020121
  },
  [1020122] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_137,
    TaskId = 1020122
  },
  [1020123] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1020121,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1020123
  },
  [1020124] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_137,
    TaskId = 1020124
  },
  [1020131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1020131
  },
  [1020132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_69,
        Function = "Damage",
        Rate = 0.47
      },
      [2] = T.RT_63,
      [3] = {
        CauseHit = "HitFly_XY400Z600",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_59,
      [5] = T.RT_72
    },
    TaskId = 1020132
  },
  [1020141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 0.4
      },
      [2] = T.RT_77,
      [3] = {
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 26
      },
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 1020141
  },
  [1020151] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1020101,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 300,
        TargetSocket = "Root",
        TargetSocketLocation = {
          0,
          450,
          100
        }
      }
    },
    TaskId = 1020151
  },
  [1020161] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1020121,
        Delay = 0.134,
        Function = "RemoveBuff"
      }
    },
    TaskId = 1020161
  },
  [1020162] = {
    TargetFilter = "RootSource",
    TaskEffects = {
      [1] = {BuffId = 1020121, Function = "RemoveBuff"}
    },
    TaskId = 1020162
  },
  [1020211] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_139,
    TaskId = 1020211
  },
  [1020212] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = T.RT_139,
    TaskId = 1020212
  },
  [1020213] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_90,
      [3] = T.RT_140,
      [4] = T.RT_49
    },
    TaskId = 1020213
  },
  [1020214] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY0Z300",
        Function = "CutToughness",
        Value = 40
      },
      [4] = T.RT_130,
      [5] = T.RT_49
    },
    TaskId = 1020214
  },
  [1020215] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_90,
      [3] = T.RT_132,
      [4] = T.RT_65,
      [5] = T.RT_49
    },
    TaskId = 1020215
  },
  [1020216] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 150
      },
      [4] = T.RT_130,
      [5] = T.RT_49
    },
    TaskId = 1020216
  },
  [1020221] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1020201,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 1020201,
        Function = "CreateSkillCreature",
        Rotation = T.RT_141
      },
      [3] = {
        CreatureId = 1020201,
        Function = "CreateSkillCreature",
        Rotation = T.RT_142
      },
      [4] = {
        CreatureId = 1020201,
        Function = "CreateSkillCreature",
        Rotation = T.RT_143
      },
      [5] = {
        CreatureId = 1020201,
        Function = "CreateSkillCreature",
        Rotation = T.RT_144
      },
      [6] = T.RT_62
    },
    TaskId = 1020221
  },
  [1020222] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.3
      },
      [2] = T.RT_145,
      [3] = {
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 10
      },
      [4] = T.RT_49,
      [5] = T.RT_119
    },
    TaskId = 1020222
  },
  [1020231] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1020231
  },
  [1020232] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_69,
        Function = "Damage",
        Rate = 0.47
      },
      [2] = T.RT_90,
      [3] = T.RT_146,
      [4] = T.RT_49,
      [5] = T.RT_72,
      [6] = {
        CreatureId = 1020202,
        Function = "CreateSkillCreature",
        Location = T.RT_147
      }
    },
    TaskId = 1020232
  },
  [1020233] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_69,
        Function = "Damage",
        Rate = 0.63
      },
      [2] = T.RT_63,
      [3] = {
        CauseHit = "HitFly_XY600Z600",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_49,
      [5] = T.RT_72
    },
    TaskId = 1020233
  },
  [1020234] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_150,
    TaskId = 1020234
  },
  [1020321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1020321,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 1020321
  },
  [1020322] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1020321,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1020322
  },
  [1020323] = {
    AttackRangeType = "Normal",
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 1.24
      },
      [2] = T.RT_145,
      [3] = {
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 40
      },
      [4] = T.RT_49
    },
    TaskId = 1020323
  },
  [1030111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = T.RT_151,
      [3] = T.RT_140,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030111
  },
  [1030112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_46,
      [2] = T.RT_153,
      [3] = T.RT_154,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030112
  },
  [1030113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = T.RT_156,
      [3] = {
        CauseHit = "LightHit_100_F",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030113
  },
  [1030114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_91,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY600Z600",
        Function = "CutToughness",
        Value = 85
      },
      [4] = T.RT_152,
      [5] = T.RT_59
    },
    TaskId = 1030114
  },
  [1030121] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_157,
      [2] = T.RT_77,
      [3] = T.RT_158,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1030121
  },
  [1030122] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.5
      },
      [2] = T.RT_62,
      [3] = T.RT_160,
      [4] = T.RT_161,
      [5] = T.RT_79,
      [6] = T.RT_59
    },
    TaskId = 1030122
  },
  [1030131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1030131
  },
  [1030132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = T.RT_73,
    TaskId = 1030132
  },
  [1030141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 0.73
      },
      [2] = {
        Function = "PlayFX",
        FxRotator = T.RT_162,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z500_F",
        Function = "CutToughness",
        Value = 47
      },
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 1030141
  },
  [1030152] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {ComboCount = 120, Function = "HitCount"}
    },
    TaskId = 1030152
  },
  [1030211] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_160,
      [3] = {
        CauseHit = "HitFly_XY400Z400_F",
        Function = "CutToughness",
        Value = 30
      },
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030211
  },
  [1030212] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_160,
      [3] = {
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 35
      },
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030212
  },
  [1030213] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1030201,
        Function = "CreateSkillCreature",
        Location = T.RT_31
      },
      [2] = {
        CreatureId = 1030202,
        Function = "CreateSkillCreature",
        Location = T.RT_31,
        Rotation = T.RT_144
      },
      [3] = {
        CreatureId = 1030202,
        Function = "CreateSkillCreature",
        Location = T.RT_31,
        Rotation = T.RT_143
      }
    },
    TaskId = 1030213
  },
  [1030214] = {
    AttackRangeType = "Normal",
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_160,
      [3] = {
        CauseHit = "HitFly_XY400Z300_F",
        Function = "CutToughness",
        Value = 70
      },
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030214
  },
  [1030218] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_138,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY200Z100",
        Function = "CutToughness",
        Value = 35
      }
    },
    TaskId = 1030218
  },
  [1030221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "StartGrab",
        PassiveEffectId = 1030202
      },
      [2] = {
        CreatureId = 1030221,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 1030222,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 1030223,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 1030224,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 1030225,
        Function = "CreateSkillCreature"
      },
      [7] = {
        ClientSkillLogicId = 1030202,
        Function = "ExecuteClientSkillLogicFunction",
        FunctionName = "SetCatchTrue"
      }
    },
    TaskId = 1030221
  },
  [1030222] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "EndGrab",
        PassiveEffectId = 1030202
      },
      [2] = T.RT_163,
      [3] = {
        CreatureId = 1030222,
        Function = "RemoveSkillCreature"
      },
      [4] = {
        CreatureId = 1030223,
        Function = "RemoveSkillCreature"
      },
      [5] = {
        CreatureId = 1030224,
        Function = "RemoveSkillCreature"
      },
      [6] = {
        CreatureId = 1030225,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1030222
  },
  [1030224] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_12,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 2
      },
      [2] = T.RT_62,
      [3] = T.RT_160,
      [4] = {
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 62
      },
      [5] = T.RT_163,
      [6] = {
        Function = "PlaySE",
        MeleeHitLevel = "heavy",
        SEId = 119
      }
    },
    TaskId = 1030224
  },
  [1030225] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = {
          "Melee",
          "Weapon",
          "HeavyAttack",
          "Catch"
        },
        Function = "Damage",
        Rate = 0.55
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "LightHit_80",
        Function = "CutToughness",
        Value = 20
      },
      [4] = {
        Function = "PlaySE",
        MeleeHitLevel = "light",
        SEId = 119
      }
    },
    TaskId = 1030225
  },
  [1030226] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.55
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY800Z400",
        Function = "CutToughness",
        Value = 20
      }
    },
    TaskId = 1030226
  },
  [1030311] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = T.RT_151,
      [3] = T.RT_164,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030311
  },
  [1030312] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small180",
    TaskEffects = {
      [1] = T.RT_46,
      [2] = T.RT_153,
      [3] = T.RT_165,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030312
  },
  [1030313] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = T.RT_156,
      [3] = T.RT_166,
      [4] = T.RT_152,
      [5] = T.RT_49
    },
    TaskId = 1030313
  },
  [1030314] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_91,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY500Z300",
        Function = "CutToughness",
        Value = 85
      },
      [4] = T.RT_152,
      [5] = T.RT_59
    },
    TaskId = 1030314
  },
  [1040001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Maxhp",
        DamageType = "TrueDamage",
        Function = "Heal",
        Rate = "#1"
      }
    },
    TaskId = 1040001
  },
  [1040111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_167,
      [2] = T.RT_90,
      [3] = T.RT_132,
      [4] = T.RT_168
    },
    TaskId = 1040111
  },
  [1040112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_131,
      [2] = T.RT_90,
      [3] = T.RT_140,
      [4] = T.RT_168
    },
    TaskId = 1040112
  },
  [1040113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.38
      },
      [2] = T.RT_90,
      [3] = T.RT_133,
      [4] = T.RT_152,
      [5] = {
        FXId = 1040101,
        Function = "PlayFX",
        IsAttached = false,
        IsEffectCreature = true
      },
      [6] = T.RT_169
    },
    TaskId = 1040113
  },
  [1040114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.43
      },
      [2] = T.RT_90,
      [3] = T.RT_166,
      [4] = T.RT_169
    },
    TaskId = 1040114
  },
  [1040121] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.2
      },
      [2] = T.RT_170,
      [3] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 12
      },
      [4] = T.RT_171
    },
    TaskId = 1040121
  },
  [1040122] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_157,
      [2] = T.RT_62,
      [3] = T.RT_172,
      [4] = {
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 40
      },
      [5] = T.RT_79,
      [6] = T.RT_59
    },
    TaskId = 1040122
  },
  [1040131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1040131
  },
  [1040132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_70,
      [2] = T.RT_63,
      [3] = T.RT_71,
      [4] = T.RT_72,
      [5] = T.RT_59
    },
    TaskId = 1040132
  },
  [1040141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 0.36
      },
      [2] = T.RT_90,
      [3] = T.RT_173,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1040141
  },
  [1040211] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_89,
      [2] = T.RT_90,
      [3] = T.RT_85,
      [4] = T.RT_65,
      [5] = T.RT_168
    },
    TaskId = 1040211
  },
  [1040212] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_91,
      [2] = T.RT_90,
      [3] = T.RT_133,
      [4] = T.RT_65,
      [5] = T.RT_168
    },
    TaskId = 1040212
  },
  [1040213] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_89,
      [2] = T.RT_90,
      [3] = T.RT_85,
      [4] = T.RT_168
    },
    TaskId = 1040213
  },
  [1040214] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_56,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 25
      },
      [4] = T.RT_169
    },
    TaskId = 1040214
  },
  [1040221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1040222,
        Function = "CreateSkillCreature",
        Location = {
          0,
          100,
          20
        },
        Rotation = T.RT_174
      },
      [2] = T.RT_62
    },
    TaskId = 1040221
  },
  [1040222] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.88
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY200Z300",
        Function = "CutToughness",
        Value = 28
      },
      [4] = T.RT_168,
      [5] = T.RT_175
    },
    TaskId = 1040222
  },
  [1040223] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_175
    },
    TaskId = 1040223
  },
  [1040241] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1040241,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 1040241
  },
  [1040242] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_176,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 66
      },
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1040242
  },
  [1040243] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1040241,
        Function = "RemoveCreature"
      }
    },
    TaskId = 1040243
  },
  [1050001] = {
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = {
        BuffId = 10502,
        Function = "AddBuff",
        LastTime = "#1"
      }
    },
    TaskId = 1050001
  },
  [1050111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = {
        Function = "PlayFX",
        FxRotator = T.RT_54,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_88,
      [4] = T.RT_48,
      [5] = T.RT_49
    },
    TaskId = 1050111
  },
  [1050112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle240",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          -35,
          90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = T.RT_178,
      [4] = T.RT_52,
      [5] = T.RT_49
    },
    TaskId = 1050112
  },
  [1050113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.6
      },
      [2] = T.RT_77,
      [3] = {
        CauseHit = "HitFly_XY400Z500_F",
        Function = "CutToughness",
        Value = 35
      },
      [4] = T.RT_49
    },
    TaskId = 1050113
  },
  [1050114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_50,
      [2] = {
        Function = "PlayFX",
        FxRotator = T.RT_179,
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY500Z300_F",
        Function = "CutToughness",
        Value = 35
      },
      [4] = T.RT_58,
      [5] = T.RT_59
    },
    TaskId = 1050114
  },
  [1050121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1050121,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_62
    },
    TaskId = 1050121
  },
  [1050122] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.161
      },
      [2] = T.RT_90,
      [3] = T.RT_173,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1050122
  },
  [1050123] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_38,
      [3] = T.RT_165,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1050123
  },
  [1050124] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.2,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 0.2,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "HitFly_XY0Z300",
        Delay = 0.2,
        Function = "CutToughness",
        Value = 15
      },
      [4] = {
        Condition = 100,
        Delay = 0.2,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.2,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050124
  },
  [1050125] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.4,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 0.4,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z100_B",
        Delay = 0.4,
        Function = "CutToughness",
        Value = 15
      },
      [4] = {
        Condition = 100,
        Delay = 0.4,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.4,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050125
  },
  [1050126] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.6,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 0.6,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z100_B",
        Delay = 0.6,
        Function = "CutToughness",
        Value = 15
      },
      [4] = {
        Condition = 100,
        Delay = 0.6,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.6,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050126
  },
  [1050127] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.8,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 0.8,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z100_B",
        Delay = 0.8,
        Function = "CutToughness",
        Value = 15
      },
      [4] = {
        Condition = 100,
        Delay = 0.8,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.8,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050127
  },
  [1050128] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.0,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 1.0,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z100_B",
        Delay = 1.0,
        Function = "CutToughness",
        Value = 15
      },
      [4] = {
        Condition = 100,
        Delay = 1.0,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 1.0,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050128
  },
  [1050129] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Rectangle_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.2,
        Function = "Damage",
        Rate = 1
      },
      [2] = {
        Delay = 1.2,
        Function = "ExecutePassiveFunction",
        FunctionName = "ClearComboCount",
        PassiveEffectId = 102
      },
      [3] = {
        Delay = 1.2,
        Function = "PlayFX",
        WeaponFXGroupName = "Hit1"
      },
      [4] = {
        CauseHit = "HitFly_XY0Z300",
        Delay = 1.2,
        Function = "CutToughness",
        Value = 15
      },
      [5] = {
        Condition = 100,
        Delay = 1.2,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [6] = {
        Delay = 1.2,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      }
    },
    TaskId = 1050129
  },
  [1050131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1050131
  },
  [1050132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_69,
        Function = "Damage",
        Rate = 0.51
      },
      [2] = T.RT_90,
      [3] = T.RT_71,
      [4] = T.RT_59,
      [5] = T.RT_72
    },
    TaskId = 1050132
  },
  [1050141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_74,
        Function = "Damage",
        Rate = 0.51
      },
      [2] = T.RT_90,
      [3] = T.RT_78,
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 1050141
  },
  [1060111] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_167,
      [2] = T.RT_90,
      [3] = T.RT_164,
      [4] = T.RT_49
    },
    TaskId = 1060111
  },
  [1060112] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_45,
        Function = "Damage",
        Rate = 0.3
      },
      [2] = T.RT_90,
      [3] = T.RT_85,
      [4] = T.RT_49
    },
    TaskId = 1060112
  },
  [1060113] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_53,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "LightHit_50_F",
        Function = "CutToughness",
        Value = 25
      },
      [4] = T.RT_49
    },
    TaskId = 1060113
  },
  [1060114] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_86,
      [2] = {
        Function = "PlayFX",
        FxRotator = {
          165,
          90,
          0
        },
        IsFaceToChar = true,
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit"
      },
      [3] = {
        CauseHit = "HitFly_XY200Z500_F",
        Function = "CutToughness",
        Value = 50
      },
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1060114
  },
  [1060115] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_9,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = T.RT_46,
      [2] = T.RT_90,
      [3] = T.RT_154,
      [4] = T.RT_65,
      [5] = T.RT_59
    },
    TaskId = 1060115
  },
  [1060120] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1060121,
        Function = "CreateSkillCreature",
        Location = T.RT_147
      },
      [2] = T.RT_62
    },
    TaskId = 1060120
  },
  [1060121] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = T.RT_134,
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY200Z300_F",
        Delay = 0.05,
        Function = "CutToughness",
        Value = 8
      },
      [4] = T.RT_65,
      [5] = T.RT_49,
      [6] = {
        FXId = 1010121,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060121
  },
  [1060122] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.045,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.045,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.045,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.045,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.045,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.045,
        FXId = 1010122,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060122
  },
  [1060123] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.112,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.112,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.112,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.112,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.112,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.112,
        FXId = 1010123,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060123
  },
  [1060124] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.165,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.165,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.165,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.165,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.165,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.165,
        FXId = 1010124,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060124
  },
  [1060125] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.229,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.267,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.267,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.267,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.267,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.267,
        FXId = 1010125,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060125
  },
  [1060126] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.284,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.284,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.284,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.284,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.284,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.284,
        FXId = 1010126,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060126
  },
  [1060127] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.342,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.342,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.342,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.342,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.342,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.342,
        FXId = 1010127,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060127
  },
  [1060128] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.365,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {
        Delay = 0.365,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.365,
        Function = "CutToughness",
        Value = 8
      },
      [4] = {
        Condition = 100,
        Delay = 0.365,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.365,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      },
      [6] = {
        Delay = 0.365,
        FXId = 1010128,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060128
  },
  [1060129] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle180",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.441,
        Function = "Damage",
        Rate = 0.25
      },
      [2] = T.RT_62,
      [3] = {
        Delay = 0.441,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [4] = {
        CauseHit = "HitFly_XY200Z300_F",
        Delay = 0.441,
        Function = "CutToughness",
        Value = 12
      },
      [5] = {
        Condition = 100,
        Delay = 0.441,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [6] = {
        Delay = 0.441,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      },
      [7] = {
        Delay = 0.441,
        FXId = 1010129,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060129
  },
  [1060131] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = T.RT_68,
    TaskId = 1060131
  },
  [1060132] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = T.RT_70,
      [2] = T.RT_90,
      [3] = T.RT_71,
      [4] = T.RT_59,
      [5] = T.RT_72
    },
    TaskId = 1060132
  },
  [1060141] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_75,
      [2] = T.RT_90,
      [3] = T.RT_78,
      [4] = T.RT_79,
      [5] = T.RT_49
    },
    TaskId = 1060141
  },
  [1060220] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 1060221,
        Function = "CreateSkillCreature",
        Location = T.RT_147
      },
      [2] = T.RT_62
    },
    TaskId = 1060220
  },
  [1060221] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "HitFly_XY200Z500_F",
        Function = "CutToughness",
        Value = 6
      },
      [4] = T.RT_65,
      [5] = T.RT_49
    },
    TaskId = 1060221
  },
  [1060222] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.845,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 0.836,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.836,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 0.836,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.836,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.836,
        FXId = 1060212,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060222
  },
  [1060223] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.895,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 0.895,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.895,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 0.895,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.895,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.895,
        FXId = 1060213,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060223
  },
  [1060224] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 0.957,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 0.957,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 0.957,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 0.957,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 0.957,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 0.957,
        FXId = 1060214,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060224
  },
  [1060225] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.042,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 1.042,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 1.042,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 1.042,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 1.042,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 1.042,
        FXId = 1060215,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060225
  },
  [1060226] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.107,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 1.107,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 1.107,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 1.107,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 1.107,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 1.107,
        FXId = 1060216,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060226
  },
  [1060227] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.192,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 1.192,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 1.192,
        Function = "CutToughness",
        Value = 6
      },
      [4] = {
        Condition = 100,
        Delay = 1.192,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 1.192,
        Function = "PlaySE",
        MeleeHitLevel = "Normal",
        SEId = 104
      },
      [6] = {
        Delay = 1.192,
        FXId = 1060217,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060227
  },
  [1060228] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.267,
        Function = "Damage",
        Rate = 0.64
      },
      [2] = {
        Delay = 1.267,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [3] = {
        CauseHit = "LightHit",
        Delay = 1.267,
        Function = "CutToughness",
        Value = 13
      },
      [4] = {
        Condition = 100,
        Delay = 1.267,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [5] = {
        Delay = 1.267,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      },
      [6] = {
        Delay = 1.267,
        FXId = 1060218,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060228
  },
  [1060229] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Delay = 1.392,
        Function = "Damage",
        Rate = 1.9
      },
      [2] = T.RT_62,
      [3] = {
        Delay = 1.392,
        Function = "PlayFX",
        MaxHitFXNum = 3,
        WeaponFXGroupName = "Hit1"
      },
      [4] = {
        CauseHit = "HitFly_XY200Z300",
        Delay = 1.392,
        Function = "CutToughness",
        Value = 15
      },
      [5] = {
        Condition = 100,
        Delay = 1.392,
        Dilation = 0,
        Duration = 0.03,
        Function = "HitStop"
      },
      [6] = {
        Delay = 1.392,
        Function = "PlaySE",
        MeleeHitLevel = "Heavy",
        SEId = 104
      },
      [7] = {
        Delay = 1.392,
        FXId = 1060219,
        Function = "PlayFX",
        IsAttached = false
      }
    },
    TaskId = 1060229
  },
  [1060251] = {
    AttackRangeType = "Normal",
    HatredIncrement = 40,
    NotifyName = T.RT_2,
    TargetFilter = "Char_Cylinder_Small240",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Melee",
        DamageTag = T.RT_61,
        Function = "Damage",
        Rate = 0.75
      },
      [2] = T.RT_90,
      [3] = {
        CauseHit = "LightHit_150_F",
        Function = "CutToughness",
        Value = 5
      },
      [4] = T.RT_65,
      [5] = T.RT_38,
      [6] = T.RT_49
    },
    TaskId = 1060251
  },
  [1060252] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 1060202,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 1060252
  },
  [1060253] = {
    EffectExecuteTiming = "Leave",
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 1060202, Function = "RemoveBuff"}
    },
    TaskId = 1060253
  },
  [1502001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1502,
        Function = "CreateSkillCreature"
      },
      [2] = {
        FXId = 15021,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 1502001
  },
  [1502002] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 1502,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 1502002
  },
  [1532001] = {
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_317,
      [2] = {
        CauseHit = "LightHit_150_F",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_318,
      [4] = {
        FXId = 15321,
        Function = "PlayFX",
        IsAttached = true
      },
      [5] = T.RT_48,
      [6] = T.RT_319
    },
    TaskId = 1532001
  },
  [1532002] = {
    TargetFilter = "Char_Cylinder_Small",
    TaskEffects = {
      [1] = T.RT_317,
      [2] = {
        CauseHit = "LightHit_100",
        Delay = 0.1,
        Function = "CutToughness",
        Value = 15
      },
      [3] = T.RT_318,
      [4] = {FXId = 15322, Function = "PlayFX"},
      [5] = T.RT_48,
      [6] = T.RT_319
    },
    TaskId = 1532002
  },
  [2010111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2010111,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          10
        }
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = {
        FXId = 2010101,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 2010111
  },
  [2010112] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_340,
      [2] = {FXId = 2010121, Function = "PlayFX"},
      [3] = T.RT_341,
      [4] = {Function = "PlaySE", SEId = 2010106},
      [5] = T.RT_342
    },
    TaskId = 2010112
  },
  [2010113] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 2010121,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_72,
      [3] = {
        Function = "PlaySE",
        SEId = 2010105,
        SceneSe = true
      }
    },
    TaskId = 2010113
  },
  [2010114] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_343,
      [2] = {FXId = 2010122, Function = "PlayFX"},
      [3] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 20
      },
      [4] = T.RT_72,
      [5] = T.RT_344,
      [6] = T.RT_345,
      [7] = T.RT_346
    },
    TaskId = 2010114,
    UseWeaponGradeLevel = true
  },
  [2010115] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_343,
      [2] = {
        FXId = 2010122,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = {
        CauseHit = "RangedWeapon_Shotgun",
        Function = "CutToughness",
        Value = 10
      },
      [4] = T.RT_72,
      [5] = T.RT_344,
      [6] = T.RT_345,
      [7] = T.RT_346
    },
    TaskId = 2010115,
    UseWeaponGradeLevel = true
  },
  [2010116] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ShootJudge",
        PassiveEffectId = 20101
      }
    },
    TaskId = 2010116
  },
  [2010117] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2010121,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_347
      },
      [2] = T.RT_72,
      [3] = {
        FXId = 2010102,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 2010117
  },
  [2010121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2010121
  },
  [2010411] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2010411,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = T.RT_350
    },
    TaskId = 2010411
  },
  [2010412] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_340,
      [2] = T.RT_351,
      [3] = {
        CauseHit = "HeavyHit_120",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_342
    },
    TaskId = 2010412
  },
  [2010413] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_355,
    TaskId = 2010413
  },
  [2010414] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Condition = 104,
        CreatureId = 2010412,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 2010414
  },
  [2010415] = {
    TargetFilter = "Char_Pistol_20104",
    TaskEffects = {
      [1] = T.RT_356,
      [2] = {
        BossValue = 100,
        CauseHit = "HitFly_XY0Z800",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {FXId = 150201, Function = "PlayFX"}
    },
    TaskId = 2010415
  },
  [2010416] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 2010413,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 2010416
  },
  [2010417] = {
    TargetFilter = "Char_Pistol_20104",
    TaskEffects = {
      [1] = T.RT_356,
      [2] = {
        BossValue = 100,
        CauseHit = "HitDown02",
        Function = "CutToughness",
        Value = 100
      },
      [3] = {FXId = 2010401, Function = "PlayFX"}
    },
    TaskId = 2010417
  },
  [2010421] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2010421
  },
  [2019911] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2019911,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = T.RT_350
    },
    TaskId = 2019911
  },
  [2019912] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_340,
      [2] = T.RT_351,
      [3] = T.RT_341,
      [4] = T.RT_342
    },
    TaskId = 2019912
  },
  [2019913] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_355,
    TaskId = 2019913
  },
  [2019921] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2019921
  },
  [2020111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020111,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2020111
  },
  [2020112] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020112,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = T.RT_368
    },
    TaskId = 2020112
  },
  [2020113] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_369,
      [2] = T.RT_351,
      [3] = T.RT_370,
      [4] = T.RT_342
    },
    TaskId = 2020113
  },
  [2020114] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_355,
    TaskId = 2020114
  },
  [2020121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2020121
  },
  [2020311] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020311,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2020311
  },
  [2020312] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020312,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = T.RT_368
    },
    TaskId = 2020312
  },
  [2020313] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_371,
    TaskId = 2020313
  },
  [2020314] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_373,
    TaskId = 2020314
  },
  [2020321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2020321
  },
  [2020711] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020711,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2020711
  },
  [2020712] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2020712,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = T.RT_368
    },
    TaskId = 2020712
  },
  [2020713] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_371,
    TaskId = 2020713
  },
  [2020714] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_373,
    TaskId = 2020714
  },
  [2020721] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2020721
  },
  [2030111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030111,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2030111
  },
  [2030112] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_375,
      [2] = {
        FXId = 2030102,
        Function = "PlayFX",
        Overlap = true,
        RandomRotation = T.RT_193
      },
      [3] = T.RT_376,
      [4] = T.RT_175,
      [5] = T.RT_377
    },
    TaskId = 2030112
  },
  [2030113] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_375,
      [2] = {
        FXId = 2030102,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RandomRotation = T.RT_126
      },
      [3] = T.RT_376,
      [4] = T.RT_175,
      [5] = T.RT_377
    },
    TaskId = 2030113
  },
  [2030114] = {
    ExtraBPFilter = "Common_CreatorFilter",
    TargetFilter = "Char_Sphere_Small_Frd",
    TaskEffects = T.RT_378,
    TaskId = 2030114
  },
  [2030121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ChargeAmount = 2,
        Function = "ChargeBullet"
      }
    },
    TaskId = 2030121
  },
  [2030211] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2030211
  },
  [2030212] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_379,
      [2] = {
        FXId = 2030201,
        Function = "PlayFX",
        Rotation = T.RT_76
      },
      [3] = T.RT_380,
      [4] = T.RT_175,
      [5] = T.RT_381,
      [6] = T.RT_377,
      [7] = T.RT_382
    },
    TaskId = 2030212
  },
  [2030213] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_379,
      [2] = {
        FXId = 2030201,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_380,
      [4] = T.RT_175,
      [5] = T.RT_377,
      [6] = T.RT_382
    },
    TaskId = 2030213
  },
  [2030214] = {
    ExtraBPFilter = "Common_CreatorFilter",
    TargetFilter = "Char_Sphere_Small_Frd",
    TaskEffects = T.RT_378,
    TaskId = 2030214
  },
  [2030215] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_388,
      [2] = T.RT_388,
      [3] = T.RT_388,
      [4] = T.RT_389,
      [5] = T.RT_389,
      [6] = T.RT_389
    },
    TaskId = 2030215
  },
  [2030216] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_390,
      [2] = {FXId = 2030202, Function = "PlayFX"},
      [3] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 8
      },
      [4] = T.RT_175,
      [5] = T.RT_381,
      [6] = {
        Function = "PlaySE",
        SEId = 2030203,
        SceneSe = true
      }
    },
    TaskId = 2030216
  },
  [2030221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2030221
  },
  [2030311] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030311,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2030311
  },
  [2030312] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_391,
      [2] = {
        FXId = 2030301,
        Function = "PlayFX",
        Overlap = true,
        RandomRotation = T.RT_193
      },
      [3] = T.RT_392,
      [4] = T.RT_393,
      [5] = T.RT_394,
      [6] = T.RT_395
    },
    TaskId = 2030312
  },
  [2030313] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_391,
      [2] = {
        FXId = 2030301,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        RandomRotation = T.RT_126
      },
      [3] = T.RT_392,
      [4] = T.RT_393,
      [5] = T.RT_394,
      [6] = T.RT_395
    },
    TaskId = 2030313
  },
  [2030314] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_400,
    TaskId = 2030314
  },
  [2030315] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_400,
    TaskId = 2030315
  },
  [2030316] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_400,
    TaskId = 2030316
  },
  [2030317] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_400,
    TaskId = 2030317
  },
  [2030321] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030312,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97
      },
      [2] = T.RT_100,
      [3] = T.RT_368,
      [4] = T.RT_100
    },
    TaskId = 2030321
  },
  [2030322] = {
    NotifyName = T.RT_12,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030313,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97
      },
      [2] = T.RT_100,
      [3] = T.RT_368,
      [4] = T.RT_100
    },
    TaskId = 2030322
  },
  [2030331] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2030331
  },
  [2030411] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2030401,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2030411
  },
  [2030412] = {
    TaskEffects = {
      [1] = {
        CreatureId = 2030403,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        Rotation = T.RT_142
      },
      [2] = {
        CreatureId = 2030403,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_191,
        Rotation = T.RT_141
      },
      [3] = T.RT_72,
      [4] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 2030401
      }
    },
    TaskId = 2030412
  },
  [2030413] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_390,
      [2] = {FXId = 2030403, Function = "PlayFX"},
      [3] = T.RT_401,
      [4] = T.RT_175,
      [5] = T.RT_402
    },
    TaskId = 2030413
  },
  [2030414] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.04
      },
      [2] = T.RT_401,
      [3] = T.RT_175,
      [4] = {FXId = 2030401, Function = "PlayFX"},
      [5] = T.RT_402
    },
    TaskId = 2030414
  },
  [2030416] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = 0.08
      },
      [2] = {FXId = 2030402, Function = "PlayFX"},
      [3] = T.RT_401,
      [4] = T.RT_175,
      [5] = T.RT_402
    },
    TaskId = 2030416
  },
  [2030421] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2030421
  },
  [2030511] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2030511,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2030511
  },
  [2030512] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.072
      },
      [2] = {FXId = 44, Function = "PlayFX"},
      [3] = {
        CauseHit = "LightHit_50",
        Function = "CutToughness",
        Value = 2
      },
      [4] = {Function = "PlaySE", SEId = 2030503}
    },
    TaskId = 2030512
  },
  [2030513] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_355,
    TaskId = 2030513
  },
  [2030514] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.35,
        LoopShootId = 20305,
        SkillEffect = T.RT_403
      }
    },
    TaskId = 2030514
  },
  [2030515] = {
    NotifyName = T.RT_404,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20305
      }
    },
    TaskId = 2030515
  },
  [2030516] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = {
          1.1,
          1.1,
          1.1
        },
        HeavyChargeId = 20305,
        MaxGrade = 3
      }
    },
    TaskId = 2030516
  },
  [2030517] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.25,
        LoopShootId = 20305,
        SkillEffect = T.RT_403
      }
    },
    TaskId = 2030517
  },
  [2030518] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.15,
        LoopShootId = 20305,
        SkillEffect = T.RT_403
      }
    },
    TaskId = 2030518
  },
  [2030519] = {
    NotifyName = T.RT_13,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.05,
        LoopShootId = 20305,
        SkillEffect = T.RT_403
      }
    },
    TaskId = 2030519
  },
  [2030521] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2030521
  },
  [2040111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_405,
      [2] = T.RT_405,
      [3] = T.RT_405,
      [4] = T.RT_405,
      [5] = T.RT_405,
      [6] = T.RT_72,
      [7] = T.RT_100
    },
    TaskId = 2040111
  },
  [2040112] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.3
      },
      [2] = {
        FXId = 43,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = {
        CauseHit = "RangedWeapon_Shotgun",
        Function = "CutToughness",
        Value = 2
      },
      [4] = T.RT_342
    },
    TaskId = 2040112
  },
  [2040113] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 53,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        ReplaceFXId = T.RT_303
      },
      [2] = T.RT_353,
      [3] = T.RT_354
    },
    TaskId = 2040113
  },
  [2040121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2040121
  },
  [2040211] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2040211,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2040211
  },
  [2040213] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    ReplaceEffectParam = {
      Condition = 2040202,
      SkillEffect = {2040214}
    },
    TargetFilter = "Char_Shotgun_20402_1",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        Condition = 2040201,
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_406,
      [3] = T.RT_104,
      [4] = T.RT_175,
      [5] = T.RT_407
    },
    TaskId = 2040213
  },
  [2040214] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    ReplaceEffectParam = {
      Condition = 2040203,
      SkillEffect = {2040215}
    },
    TargetFilter = "Char_Shotgun_20402_2",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_406,
      [3] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 100
      },
      [4] = T.RT_175,
      [5] = T.RT_407
    },
    TaskId = 2040214,
    UseWeaponGradeLevel = true
  },
  [2040215] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    ReplaceEffectParam = {
      Condition = 2040204,
      SkillEffect = {2040216}
    },
    TargetFilter = "Char_Shotgun_20402_3",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = "#2"
      },
      [2] = T.RT_406,
      [3] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 150
      },
      [4] = T.RT_175,
      [5] = T.RT_407
    },
    TaskId = 2040215,
    UseWeaponGradeLevel = true
  },
  [2040216] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Shotgun_20402_4",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = "#3"
      },
      [2] = T.RT_406,
      [3] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 200
      },
      [4] = T.RT_175,
      [5] = T.RT_407,
      [6] = T.RT_105
    },
    TaskId = 2040216,
    UseWeaponGradeLevel = true
  },
  [2040221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2040221
  },
  [2040311] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2040301,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2040311
  },
  [2040313] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2040302,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_409,
      [4] = T.RT_175,
      [5] = T.RT_105
    },
    TaskId = 2040313
  },
  [2040314] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2040302,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_409,
      [4] = T.RT_175,
      [5] = T.RT_105
    },
    TaskId = 2040314
  },
  [2040315] = {
    ExtraBPFilter = "Common_CreatorFilter",
    TargetFilter = "Char_Sphere_Small_Frd",
    TaskEffects = {
      [1] = T.RT_110,
      [2] = T.RT_175
    },
    TaskId = 2040315
  },
  [2040321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2040321
  },
  [2040511] = {
    AttackRangeType = "Bullet",
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2040511,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 2040501
      }
    },
    TaskId = 2040511
  },
  [2040512] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_410,
      [2] = T.RT_411,
      [3] = T.RT_341,
      [4] = T.RT_175,
      [5] = {Function = "PlaySE", SEId = 2040505}
    },
    TaskId = 2040512
  },
  [2040513] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 53,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = {
        Function = "PlaySE",
        SEId = 2040505,
        SceneSe = true
      }
    },
    TaskId = 2040513
  },
  [2040514] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2040512,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 2040502
      }
    },
    TaskId = 2040514
  },
  [2040515] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.1
      },
      [2] = T.RT_412,
      [3] = {Function = "PlaySE", SEId = 2040506}
    },
    TaskId = 2040515
  },
  [2040518] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = 2
      },
      [2] = {
        CauseHit = "HitFly_Force_Common",
        Function = "CutToughness",
        Value = 80
      },
      [3] = T.RT_175,
      [4] = T.RT_413,
      [5] = {Function = "PlaySE", SEId = 2040508},
      [6] = {
        Falloff = 0.5,
        Function = "CameraShake",
        IsSceneCameraShake = true,
        OuterRadius = 3000,
        ShakeClass = "BP_CS_BPYS_01"
      }
    },
    TaskId = 2040518
  },
  [2040519] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 2040503, Function = "PlayFX"},
      [2] = T.RT_175
    },
    TaskId = 2040519
  },
  [2040521] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2040521
  },
  [2040531] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = T.RT_288,
        HeavyChargeId = 20405,
        MaxGrade = 1
      },
      [2] = T.RT_299
    },
    TaskId = 2040531
  },
  [2040532] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteHeavyEffect",
        HeavyChargeId = 20405,
        SkillEffect = {2040511, 2040514}
      }
    },
    TaskId = 2040532
  },
  [2040611] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2040601,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        MaxCount = 5
      },
      [2] = T.RT_72,
      [3] = T.RT_100,
      [4] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "CheckBullet",
        PassiveEffectId = 20406
      },
      [5] = {
        BaseChar = "Self",
        ConsumeAmount = "$Source:GetInt('MagazineBulletNum_20406')$",
        Function = "ConsumeBullet"
      }
    },
    TaskId = 2040611
  },
  [2040612] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_410,
      [2] = T.RT_411,
      [3] = T.RT_341,
      [4] = T.RT_175
    },
    TaskId = 2040612
  },
  [2040614] = {
    AttackRangeType = "Bullet",
    ExtraBPFilter = "Common_Random",
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        CreatureId = 2040602,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 2040614
  },
  [2040615] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = 0.5
      },
      [2] = {FXId = 2040403, Function = "PlayFX"},
      [3] = T.RT_401,
      [4] = T.RT_175
    },
    TaskId = 2040615
  },
  [2040616] = {
    TaskEffects = {
      [1] = T.RT_415,
      [2] = T.RT_417,
      [3] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_144
      },
      [4] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_143
      },
      [5] = T.RT_418,
      [6] = T.RT_72
    },
    TaskId = 2040616
  },
  [2040617] = {
    TaskEffects = {
      [1] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_419
      },
      [2] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_420
      },
      [3] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_421
      },
      [4] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_422
      },
      [5] = T.RT_415,
      [6] = T.RT_417,
      [7] = T.RT_72
    },
    TaskId = 2040617
  },
  [2040618] = {
    TaskEffects = {
      [1] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_423
      },
      [2] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_424
      },
      [3] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_425
      },
      [4] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_426
      },
      [5] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_427
      },
      [6] = {
        CreatureId = 2040602,
        Delay = 0.1,
        Function = "CreateSkillCreature",
        Location = T.RT_193,
        Rotation = T.RT_428
      },
      [7] = T.RT_418,
      [8] = T.RT_72
    },
    TaskId = 2040618
  },
  [2040711] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2040711,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_420
      },
      [2] = {
        AimSkeletal = "hit1",
        CreatureId = 2040711,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_419
      },
      [3] = {
        AimSkeletal = "hit1",
        CreatureId = 2040711,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = {
          15,
          0,
          0
        }
      },
      [4] = T.RT_72,
      [5] = T.RT_100
    },
    TaskId = 2040711
  },
  [2040712] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2040702,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_429,
      [4] = T.RT_175
    },
    TaskId = 2040712
  },
  [2040713] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2040702,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_429,
      [4] = T.RT_175
    },
    TaskId = 2040713
  },
  [2040721] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2040721
  },
  [2050001] = {
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = {
        BuffId = 20509,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 2050001
  },
  [2050002] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_430,
    TaskId = 2050002
  },
  [2050111] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2050111,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_431,
      [3] = T.RT_72,
      [4] = T.RT_100,
      [5] = T.RT_432
    },
    TaskId = 2050111
  },
  [2050113] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.16
      },
      [2] = T.RT_177,
      [3] = T.RT_433,
      [4] = T.RT_342
    },
    TaskId = 2050113
  },
  [2050114] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_355,
    TaskId = 2050114
  },
  [2050115] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20501,
        SkillEffect = {2050111}
      }
    },
    TaskId = 2050115
  },
  [2050116] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20501
      }
    },
    TaskId = 2050116
  },
  [2050121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050121
  },
  [2050211] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2050211,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [2] = {
        AimSaveLoc = true,
        FXId = 2050201,
        Function = "PlayFX",
        IsAttached = true,
        LerpTime = 0.1
      },
      [3] = {
        FXId = 2050204,
        Function = "PlayFX",
        IsAttached = true
      },
      [4] = T.RT_72,
      [5] = T.RT_100
    },
    TaskId = 2050211
  },
  [2050213] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_435,
      [2] = T.RT_433,
      [3] = T.RT_436
    },
    TaskId = 2050213
  },
  [2050214] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_435,
      [2] = T.RT_433,
      [3] = {
        AimFrom = "SaveLoc",
        AimTarget = true,
        FXId = 2050202,
        Function = "PlayFX"
      },
      [4] = {FXId = 2050203, Function = "PlayFX"}
    },
    TaskId = 2050214
  },
  [2050215] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20502,
        SkillEffect = {2050211}
      }
    },
    TaskId = 2050215
  },
  [2050216] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20502
      }
    },
    TaskId = 2050216
  },
  [2050217] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_438,
    TaskId = 2050217
  },
  [2050218] = {
    TargetFilter = "Char_Machinegun_20502",
    TaskEffects = {
      [1] = {
        CatapultNum = 4,
        Function = "Catapult",
        Rule = "Nearpriority",
        SkillEffectId = 2050214
      }
    },
    TaskId = 2050218
  },
  [2050221] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050221
  },
  [2050311] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2050311,
        Direction = "Camera",
        Function = "CreateRayCreature"
      },
      [2] = {
        FXId = 2050301,
        Function = "PlayFX",
        IsAttached = true
      },
      [3] = T.RT_72,
      [4] = T.RT_100
    },
    TaskId = 2050311
  },
  [2050314] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_440,
      [2] = T.RT_433,
      [3] = {Function = "PlaySE", SEId = 151}
    },
    TaskId = 2050314
  },
  [2050315] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.125,
        LoopShootId = 20503,
        SkillEffect = {2050311}
      }
    },
    TaskId = 2050315
  },
  [2050316] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20503
      }
    },
    TaskId = 2050316
  },
  [2050321] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050321
  },
  [2050331] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_80
    },
    TaskId = 2050331
  },
  [2050411] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2050411,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [2] = T.RT_72,
      [3] = T.RT_100
    },
    TaskId = 2050411
  },
  [2050412] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_441,
      [2] = {
        CreatureId = 2050412,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [3] = T.RT_72,
      [4] = T.RT_100
    },
    TaskId = 2050412
  },
  [2050413] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_442,
      [2] = {
        CreatureId = 2050413,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [3] = T.RT_72,
      [4] = T.RT_100
    },
    TaskId = 2050413
  },
  [2050414] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.5,
        LoopShootId = 20504,
        SkillEffect = {2050411}
      }
    },
    TaskId = 2050414
  },
  [2050415] = {
    EffectExecuteTiming = "Leave",
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20504
      },
      [2] = T.RT_441,
      [3] = T.RT_442,
      [4] = {
        CreatureId = 2050413,
        Function = "RemoveRayCreature"
      }
    },
    TaskId = 2050415
  },
  [2050416] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = {2, 2},
        HeavyChargeId = 20504,
        MaxGrade = 2
      }
    },
    TaskId = 2050416
  },
  [2050417] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.35,
        LoopShootId = 20504,
        SkillEffect = {2050412}
      }
    },
    TaskId = 2050417
  },
  [2050418] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20504,
        SkillEffect = {2050413}
      }
    },
    TaskId = 2050418
  },
  [2050421] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050421
  },
  [2050431] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_439,
        Function = "Damage",
        Rate = 0.12
      },
      [2] = {FXId = 2050411, Function = "PlayFX"},
      [3] = T.RT_443,
      [4] = {Function = "PlaySE", SEId = 2050401}
    },
    TaskId = 2050431
  },
  [2050432] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_440,
      [2] = {FXId = 2050412, Function = "PlayFX"},
      [3] = T.RT_433,
      [4] = {Function = "PlaySE", SEId = 2050402}
    },
    TaskId = 2050432
  },
  [2050433] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_439,
        Function = "Damage",
        Rate = 0.37
      },
      [2] = {FXId = 2050413, Function = "PlayFX"},
      [3] = {
        CauseHit = "RangedWeapon_Common",
        Function = "CutToughness",
        Value = 5
      },
      [4] = {Function = "PlaySE", SEId = 2050403}
    },
    TaskId = 2050433
  },
  [2050434] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 2050414, Function = "PlayFX"},
      [2] = T.RT_444
    },
    TaskId = 2050434
  },
  [2050435] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 2050415, Function = "PlayFX"},
      [2] = T.RT_444
    },
    TaskId = 2050435
  },
  [2050436] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 2050416, Function = "PlayFX"},
      [2] = T.RT_444
    },
    TaskId = 2050436
  },
  [2050511] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 2050511,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      },
      [2] = {
        AimSaveLoc = true,
        FXId = 2050501,
        Function = "PlayFX",
        IsAttached = true,
        LerpTime = 0.1
      },
      [3] = T.RT_72
    },
    TaskId = 2050511
  },
  [2050512] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 2050501,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 2050512
  },
  [2050513] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20505,
        SkillEffect = {2050511, 2050512}
      }
    },
    TaskId = 2050513
  },
  [2050514] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_439,
        Function = "Damage",
        Rate = 0.05
      },
      [2] = T.RT_445,
      [3] = {Function = "PlaySE", SEId = 2050501}
    },
    TaskId = 2050514
  },
  [2050515] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_446,
      [2] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "CheckBullet",
        PassiveEffectId = 20505
      },
      [3] = {
        BuffId = 2050501,
        Function = "RemoveBuff",
        Num = 10
      },
      [4] = {
        BaseChar = "Self",
        ConsumeAmount = "$Source:GetInt('MagazineBulletNum_20505')$",
        Function = "ConsumeBullet"
      }
    },
    TaskId = 2050515
  },
  [2050516] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2050511,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = {
        FXId = 2050505,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 2050516
  },
  [2050517] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_374,
        Function = "Damage",
        Rate = 2.915
      },
      [2] = {
        FXId = 2050504,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_447,
      [4] = T.RT_175,
      [5] = {Function = "PlaySE", SEId = 2050505}
    },
    TaskId = 2050517
  },
  [2050518] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_445,
      [2] = {
        Function = "PlaySE",
        SEId = 2050502,
        SceneSe = true
      }
    },
    TaskId = 2050518
  },
  [2050519] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = T.RT_446
    },
    TaskId = 2050519
  },
  [2050521] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050521
  },
  [2050611] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_451,
      [2] = T.RT_453,
      [3] = T.RT_72,
      [4] = T.RT_454
    },
    TaskId = 2050611
  },
  [2050612] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20506,
        SkillEffect = {2050611}
      },
      [2] = {
        Function = "StartHeavyCharge",
        GradeInterval = {1.5},
        HeavyChargeId = 20506,
        MaxGrade = 1
      }
    },
    TaskId = 2050612
  },
  [2050613] = {
    EffectExecuteTiming = "Leave",
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20506
      },
      [2] = {
        CreatureId = 2050611,
        Function = "RemoveRayCreature"
      },
      [3] = {
        CreatureId = 2050612,
        Function = "RemoveRayCreature"
      },
      [4] = {
        CreatureId = 2050613,
        Function = "RemoveRayCreature"
      },
      [5] = {
        CreatureId = 2050614,
        Function = "RemoveRayCreature"
      }
    },
    TaskId = 2050613
  },
  [2050614] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_451,
      [2] = T.RT_453,
      [3] = {
        CreatureId = 2050613,
        Direction = "Camera",
        Function = "CreateRayCreature",
        InterpRotation = T.RT_449,
        RayEndLoc = true,
        Rotation = T.RT_450
      },
      [4] = {
        CreatureId = 2050614,
        Direction = "Camera",
        Function = "CreateRayCreature",
        InterpRotation = T.RT_452,
        RayEndLoc = true,
        Rotation = T.RT_448
      },
      [5] = T.RT_454,
      [6] = T.RT_72
    },
    TaskId = 2050614
  },
  [2050615] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        Function = "UpdateLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20506,
        SkillEffect = {2050614}
      }
    },
    TaskId = 2050615
  },
  [2050621] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2050621
  },
  [2050631] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_439,
        Function = "Damage",
        Rate = 0.041
      },
      [2] = T.RT_455,
      [3] = T.RT_443,
      [4] = {Function = "PlaySE", SEId = 2050603}
    },
    TaskId = 2050631
  },
  [2050632] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_455
    },
    TaskId = 2050632
  },
  [2050711] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2050701,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_431,
      [3] = T.RT_72,
      [4] = T.RT_100,
      [5] = T.RT_127,
      [6] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 2050704
      }
    },
    TaskId = 2050711
  },
  [2050713] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_456,
      [2] = T.RT_177,
      [3] = T.RT_457,
      [4] = T.RT_119,
      [5] = T.RT_301
    },
    TaskId = 2050713
  },
  [2050714] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_304,
      [2] = {
        CorrectDirection = true,
        FXId = 2050701,
        Function = "PlayFX",
        IsAttached = true,
        IsDecalEffectCreature = true,
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true,
        ReplaceFXId = T.RT_305
      },
      [3] = T.RT_306
    },
    TaskId = 2050714
  },
  [2050715] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20507,
        SkillEffect = {2050711}
      }
    },
    TaskId = 2050715
  },
  [2050716] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20507
      }
    },
    TaskId = 2050716
  },
  [2050721] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BeCallBacked = true,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 50,
        SetSpeed = 5000,
        Target = "RangedWeapon",
        TargetSocket = "root"
      }
    },
    TaskId = 2050721
  },
  [2050722] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "RootSource",
    TaskEffects = {
      [1] = T.RT_81,
      [2] = {Function = "PlaySE", SEId = 2050705}
    },
    TaskId = 2050722
  },
  [2051011] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2051001,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_298,
      [3] = T.RT_72,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2051011
  },
  [2051013] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_456,
      [2] = T.RT_457,
      [3] = {FXId = 2051004, Function = "PlayFX"},
      [4] = T.RT_119,
      [5] = T.RT_301
    },
    TaskId = 2051013
  },
  [2051014] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 2051006,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true,
        ReplaceFXId = T.RT_303
      },
      [2] = {
        CorrectDirection = true,
        FXId = 2010100,
        Function = "PlayFX",
        IsAttached = true,
        IsDecalEffectCreature = true,
        NormalToHit = true,
        Overlap = true,
        RefinedOverlap = true,
        ReplaceFXId = T.RT_305
      },
      [3] = T.RT_306
    },
    TaskId = 2051014
  },
  [2051015] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.1,
        LoopShootId = 20510,
        SkillEffect = {2051011}
      }
    },
    TaskId = 2051015
  },
  [2051016] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20510
      }
    },
    TaskId = 2051016
  },
  [2051021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BeCallBacked = true,
        Function = "CallBackSkillCreature",
        IsFollowing = true,
        MinDistance = 50,
        SetSpeed = 2000,
        Target = "RangedWeapon",
        TargetSocket = "root"
      },
      [2] = {
        FXId = 2051002,
        Function = "ReplaceBulletFXID"
      }
    },
    TaskId = 2051021
  },
  [2051022] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "RootSource",
    TaskEffects = {
      [1] = T.RT_81,
      [2] = {Function = "PlaySE", SEId = 2051002}
    },
    TaskId = 2051022
  },
  [2051111] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2051111,
        Direction = "Camera",
        ExtraRotation = 3,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_431,
      [3] = T.RT_72,
      [4] = T.RT_100,
      [5] = T.RT_432
    },
    TaskId = 2051111
  },
  [2051113] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2051102,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_409,
      [4] = T.RT_175
    },
    TaskId = 2051113
  },
  [2051115] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartLoopShoot",
        LoopInterval = 0.15,
        LoopShootId = 20511,
        SkillEffect = {2051111}
      }
    },
    TaskId = 2051115
  },
  [2051116] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20511
      }
    },
    TaskId = 2051116
  },
  [2051121] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_128,
    TaskId = 2051121
  },
  [2051122] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 2051111,
        Function = "CallBackSkillCreature",
        SetSpeed = 0.001
      }
    },
    TaskId = 2051122
  },
  [2060111] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060111,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2060111
  },
  [2060112] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_464,
    TaskId = 2060112
  },
  [2060113] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_468,
    TaskId = 2060113
  },
  [2060121] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060121,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_469,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2060121
  },
  [2060122] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_470,
      [2] = T.RT_460,
      [3] = T.RT_462,
      [4] = T.RT_471,
      [5] = T.RT_463,
      [6] = T.RT_472
    },
    TaskId = 2060122
  },
  [2060131] = {
    NotifyName = T.RT_12,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060131,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = {
        FXId = 2060131,
        Function = "PlayFX",
        IsAttached = true
      },
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2060131
  },
  [2060132] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 1.43
      },
      [2] = T.RT_460,
      [3] = T.RT_462,
      [4] = {
        CauseHit = "RangedWeapon_Common",
        Function = "CutToughness",
        Value = 20
      },
      [5] = T.RT_463,
      [6] = T.RT_472
    },
    TaskId = 2060132
  },
  [2060141] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = T.RT_473,
        HeavyChargeId = 20601,
        MaxGrade = 3
      },
      [2] = T.RT_299
    },
    TaskId = 2060141
  },
  [2060142] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteHeavyEffect",
        HeavyChargeId = 20601,
        SkillEffect = {
          2060111,
          2060121,
          2060131,
          2060121
        }
      }
    },
    TaskId = 2060142
  },
  [2060143] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttachToSkillCreature = true,
        Function = "ReleaseTarget"
      }
    },
    TaskId = 2060143
  },
  [2060211] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_474,
      [3] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = {
          0,
          6,
          0
        }
      },
      [4] = T.RT_474,
      [5] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = {
          0,
          -6,
          0
        }
      },
      [6] = T.RT_474,
      [7] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_475
      },
      [8] = T.RT_474
    },
    TaskId = 2060211
  },
  [2060212] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_476
      },
      [2] = T.RT_474,
      [3] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = {
          0,
          18,
          0
        }
      },
      [4] = T.RT_474,
      [5] = {
        AimSkeletal = "hit1",
        Condition = 44,
        CreatureId = 2060211,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = {
          0,
          -18,
          0
        }
      },
      [6] = T.RT_474,
      [7] = T.RT_127,
      [8] = T.RT_72,
      [9] = T.RT_458,
      [10] = T.RT_100
    },
    TaskId = 2060212
  },
  [2060213] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = T.RT_339,
        Function = "Damage",
        Rate = 0.063
      },
      [2] = T.RT_460,
      [3] = T.RT_462,
      [4] = T.RT_443,
      [5] = T.RT_463
    },
    TaskId = 2060213
  },
  [2060214] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_468,
    TaskId = 2060214
  },
  [2060311] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_477,
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = T.RT_478,
      [6] = T.RT_127
    },
    TaskId = 2060311
  },
  [2060312] = {
    NotifyName = T.RT_2,
    ReplaceEffectParam = {
      Condition = 2060301,
      SkillEffect = {2060317}
    },
    TargetFilter = "CustomizedTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060312,
        Direction = "Camera",
        ExtraRotation = 2,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = {
        BaseChar = "Target",
        ConsumeAmount = 1,
        Function = "ConsumeBullet",
        TotalBullet = 1
      },
      [6] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 2060307
      }
    },
    TaskId = 2060312
  },
  [2060313] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CostBullet = 0,
        Function = "StartLoopShoot",
        LoopInterval = 0.2,
        LoopShootId = 20603,
        SkillEffect = {2060315}
      },
      [2] = T.RT_299,
      [3] = T.RT_300
    },
    TaskId = 2060313
  },
  [2060314] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        Function = "EndLoopShoot",
        LoopShootId = 20603
      },
      [2] = T.RT_479,
      [3] = T.RT_127
    },
    TaskId = 2060314
  },
  [2060315] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ClientSkillLogicId = 2060301,
        Function = "ExecuteClientSkillLogicFunction",
        FunctionName = "HeavyShootingLoop"
      }
    },
    TaskId = 2060315
  },
  [2060316] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_480,
      [2] = T.RT_460,
      [3] = T.RT_443,
      [4] = {Function = "PlaySE", SEId = 2060302},
      [5] = T.RT_119
    },
    TaskId = 2060316
  },
  [2060317] = {
    NotifyName = T.RT_2,
    TargetFilter = "CustomizedTargets",
    TaskEffects = {
      [1] = T.RT_477,
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = {
        BaseChar = "Self",
        ConsumeAmount = 1,
        Function = "ConsumeBullet",
        TotalBullet = 1
      },
      [6] = T.RT_478,
      [7] = T.RT_127
    },
    TaskId = 2060317
  },
  [2060318] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_480,
      [2] = T.RT_460,
      [3] = T.RT_443,
      [4] = {Function = "PlaySE", SEId = 2060303},
      [5] = T.RT_119
    },
    TaskId = 2060318
  },
  [2060321] = {
    EffectExecuteTiming = "Leave",
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_479
    },
    TaskId = 2060321
  },
  [2060511] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2060511,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2060511
  },
  [2060512] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_464,
    TaskId = 2060512
  },
  [2060513] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_481,
    TaskId = 2060513
  },
  [2060521] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_482,
      [2] = T.RT_72,
      [3] = T.RT_469,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2060521
  },
  [2060522] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2060511,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_409,
      [4] = T.RT_175
    },
    TaskId = 2060522
  },
  [2060523] = {
    AttackRangeType = "Bullet",
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_408,
      [2] = {
        FXId = 2060511,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_409,
      [4] = T.RT_175
    },
    TaskId = 2060523
  },
  [2060524] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_482,
      [2] = {
        AimSkeletal = "hit1",
        CreatureId = 2060521,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_476
      },
      [3] = {
        AimSkeletal = "hit1",
        CreatureId = 2060521,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Rotation = T.RT_475
      },
      [4] = T.RT_72,
      [5] = T.RT_469,
      [6] = T.RT_100,
      [7] = T.RT_127
    },
    TaskId = 2060524
  },
  [2060531] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = {
          0.4,
          0.4,
          0.4
        },
        HeavyChargeId = 20605,
        MaxGrade = 3
      },
      [2] = T.RT_299
    },
    TaskId = 2060531
  },
  [2060532] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteHeavyEffect",
        HeavyChargeId = 20605,
        SkillEffect = {
          2060511,
          2060521,
          2060524,
          2060521
        }
      }
    },
    TaskId = 2060532
  },
  [2069911] = {
    NotifyName = T.RT_2,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2069911,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_458,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2069911
  },
  [2069912] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = T.RT_464,
    TaskId = 2069912
  },
  [2069913] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_481,
    TaskId = 2069913
  },
  [2069921] = {
    NotifyName = T.RT_9,
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        AimSkeletal = "hit1",
        CreatureId = 2069921,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_72,
      [3] = T.RT_469,
      [4] = T.RT_100,
      [5] = T.RT_127
    },
    TaskId = 2069921
  },
  [2069922] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_470,
      [2] = T.RT_460,
      [3] = T.RT_462,
      [4] = T.RT_471,
      [5] = T.RT_463
    },
    TaskId = 2069922
  },
  [2069931] = {
    EffectExecuteTiming = "Enter",
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "StartHeavyCharge",
        GradeInterval = {0.5},
        HeavyChargeId = 20601,
        MaxGrade = 1
      },
      [2] = T.RT_299
    },
    TaskId = 2069931
  },
  [2069932] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "ExecuteHeavyEffect",
        HeavyChargeId = 20601,
        SkillEffect = {2069911, 2069921}
      }
    },
    TaskId = 2069932
  },
  [3311001] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseChar = "Target",
        FXId = 33311,
        Function = "PlayFX"
      }
    },
    TaskId = 3311001
  },
  [4200101] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 4200101,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      }
    },
    TaskId = 4200101
  },
  [4200102] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_436
    },
    TaskId = 4200102
  },
  [4200103] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_438,
    TaskId = 4200103
  },
  [4200104] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 4200102,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      }
    },
    TaskId = 4200104
  },
  [4200105] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Ranged",
        DamageTag = {
          "Ray",
          "Prop42001Ray"
        },
        Function = "Damage",
        Rate = 0.25
      }
    },
    TaskId = 4200105
  },
  [4200106] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4200101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 4200106
  },
  [4200107] = {
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_601,
      [2] = {
        FXId = 4200104,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 4200107
  },
  [4200108] = {
    TargetFilter = "Char_Sphere_Middle",
    TaskEffects = {
      [1] = T.RT_601,
      [2] = {
        FXId = 4200104,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 4200108
  },
  [4200201] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = {
        CreatureId = 4200201,
        Direction = "Camera",
        Function = "CreateRayCreature"
      }
    },
    TaskId = 4200201
  },
  [4200202] = {
    HatredIncrement = 40,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "Ray",
          "Prop42002Ray"
        },
        Function = "Damage",
        Rate = 0.1
      },
      [2] = {Function = "PlaySE", SEId = 2036}
    },
    TaskId = 4200202
  },
  [4200203] = {
    TaskEffects = {
      [1] = {
        CheckRange = 50,
        CheckType = 3,
        Function = "FindTreasure",
        GuideCloseRange = 100,
        GuideDuration = 5,
        ScanAll = true
      }
    },
    TaskId = 4200203
  },
  [8500111] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill01_Whip01",
    TaskEffects = T.RT_787,
    TaskId = 8500111
  },
  [8500112] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Skill01_Whip02",
    TaskEffects = T.RT_788,
    TaskId = 8500112
  },
  [8500113] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_790,
    TaskId = 8500113
  },
  [8500114] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_791,
    TaskId = 8500114
  },
  [8500115] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_793,
    TaskId = 8500115
  },
  [8500116] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_795,
    TaskId = 8500116
  },
  [8500117] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_797,
    TaskId = 8500117
  },
  [8500118] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_798,
    TaskId = 8500118
  },
  [8500119] = {
    NotifyName = T.RT_507,
    TaskEffects = T.RT_802,
    TaskId = 8500119
  },
  [8500121] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill02_Sword01",
    TaskEffects = T.RT_788,
    TaskId = 8500121
  },
  [8500122] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Skill02_Sword02",
    TaskEffects = T.RT_787,
    TaskId = 8500122
  },
  [8500123] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_803,
    TaskId = 8500123
  },
  [8500124] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_803,
    TaskId = 8500124
  },
  [8500125] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_788,
    TaskId = 8500125
  },
  [8500126] = {
    NotifyName = T.RT_507,
    TaskEffects = T.RT_802,
    TaskId = 8500126
  },
  [8500131] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_772,
    TaskId = 8500131
  },
  [8500132] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = ""
      }
    },
    TaskId = 8500132
  },
  [8500133] = {
    TargetFilter = "BossXibi_Skill03_Thunder",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Delay = 0.1,
        Function = "Damage",
        Rate = 5
      },
      [2] = T.RT_805,
      [3] = T.RT_806
    },
    TaskId = 8500133
  },
  [8500134] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder101"
      },
      [2] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder102"
      },
      [3] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder103"
      },
      [4] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder104"
      },
      [5] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder105"
      },
      [6] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder106"
      }
    },
    TaskId = 8500134
  },
  [8500135] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder201"
      },
      [2] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder202"
      },
      [3] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder203"
      },
      [4] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder204"
      },
      [5] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder205"
      },
      [6] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder206"
      }
    },
    TaskId = 8500135
  },
  [8500136] = {
    TaskEffects = {
      [1] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder301"
      },
      [2] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder302"
      },
      [3] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder303"
      },
      [4] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder304"
      },
      [5] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder305"
      },
      [6] = {
        CreatureId = 850031,
        Delay = 0.6,
        Function = "CreateSkillCreature",
        Location = T.RT_804,
        UseSaveLoc = "FieldThunder306"
      }
    },
    TaskId = 8500136
  },
  [8500141] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 850042,
        Direction = T.RT_807,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 850042,
        Function = "CreateSkillCreature",
        Location = T.RT_425
      },
      [3] = {
        CreatureId = 850042,
        Direction = T.RT_808,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8500141
  },
  [8500142] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_810,
    TaskId = 8500142
  },
  [8500143] = {
    TargetFilter = "BossXibi_Skill03_Thunder",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Delay = 0.1,
        Function = "Damage",
        Rate = 3
      },
      [2] = T.RT_805,
      [3] = T.RT_806
    },
    TaskId = 8500143
  },
  [8500151] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_812,
    TaskId = 8500151
  },
  [8500152] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = T.RT_814,
    TaskId = 8500152
  },
  [8500161] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_816,
    TaskId = 8500161
  },
  [8500162] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_818,
    TaskId = 8500162
  },
  [8500163] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Skill06_Donut01",
    TaskEffects = T.RT_820,
    TaskId = 8500163
  },
  [8500164] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_Skill06_Donut02",
    TaskEffects = T.RT_820,
    TaskId = 8500164
  },
  [8500165] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_Skill06_Donut03",
    TaskEffects = T.RT_820,
    TaskId = 8500165
  },
  [8500166] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 850061,
        Function = "CreateUnit",
        LifeTime = 6.15,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850061,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8500166
  },
  [8500167] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 850061,
        Function = "CreateUnit",
        LifeTime = 5,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850062,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8500167
  },
  [8500168] = {
    TargetFilter = "BossXibi_Skill06_Field01",
    TaskEffects = T.RT_822,
    TaskId = 8500168
  },
  [8500169] = {
    TargetFilter = "BossXibi_Skill06_Field02",
    TaskEffects = T.RT_822,
    TaskId = 8500169
  },
  [8500171] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Skill07",
    TaskEffects = T.RT_824,
    TaskId = 8500171
  },
  [8500181] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossXibi_Dash_Whip01",
    TaskEffects = T.RT_790,
    TaskId = 8500181
  },
  [8500182] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossXibi_Dash_Whip02",
    TaskEffects = T.RT_790,
    TaskId = 8500182
  },
  [8500183] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_Dash_Sword",
    TaskEffects = T.RT_793,
    TaskId = 8500183
  },
  [8500184] = {
    NotifyName = T.RT_13,
    TaskEffects = T.RT_802,
    TaskId = 8500184
  },
  [8500185] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 8500185
  },
  [8500186] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = T.RT_816,
    TaskId = 8500186
  },
  [8500187] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = T.RT_828,
    TaskId = 8500187
  },
  [8500188] = {
    NotifyName = T.RT_829,
    TargetFilter = "BossXibi_Skill08_Jump",
    TaskEffects = {
      [1] = T.RT_792,
      [2] = T.RT_809,
      [3] = T.RT_830,
      [4] = T.RT_5
    },
    TaskId = 8500188
  },
  [8500191] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossXibi_StageSkill_Donut01",
    TaskEffects = T.RT_820,
    TaskId = 8500191
  },
  [8500192] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossXibi_StageSkill_Donut02",
    TaskEffects = T.RT_820,
    TaskId = 8500192
  },
  [8500193] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossXibi_StageSkill_Donut03",
    TaskEffects = T.RT_820,
    TaskId = 8500193
  },
  [8500194] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 850061,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850063,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8500194
  },
  [8500195] = {
    TargetFilter = "BossXibi_StageSkill_Field01",
    TaskEffects = T.RT_832,
    TaskId = 8500195
  },
  [8500196] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 850061,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850064,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8500196
  },
  [8500197] = {
    TargetFilter = "BossXibi_StageSkill_Field02",
    TaskEffects = T.RT_832,
    TaskId = 8500197
  },
  [8500198] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FormationId = 850061,
        Function = "CreateUnit",
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850065,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8500198
  },
  [8500199] = {
    TargetFilter = "BossXibi_StageSkill_Field03",
    TaskEffects = T.RT_832,
    TaskId = 8500199
  },
  [8501101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill01_HalfCylinder",
    TaskEffects = T.RT_837,
    TaskId = 8501101
  },
  [8501102] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLizhan_Skill02_Cylinder",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 1.1
      },
      [2] = T.RT_838,
      [3] = T.RT_839
    },
    TaskId = 8501102
  },
  [8501106] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill02_Cylinder",
    TaskEffects = T.RT_841,
    TaskId = 8501106
  },
  [8501111] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850101,
        Function = "CreateSkillCreature"
      },
      [2] = {
        BaseChar = "Self",
        Function = "PlaySE",
        SEId = 850101
      }
    },
    TaskId = 8501111
  },
  [8501112] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 1.25
      },
      [2] = T.RT_835,
      [3] = {FXId = 850103, Function = "PlayFX"},
      [4] = T.RT_839
    },
    TaskId = 8501112
  },
  [8501113] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 850102,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 8501113
  },
  [8501116] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill04_Cylinder",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 0.8
      },
      [2] = T.RT_681,
      [3] = T.RT_839
    },
    TaskId = 8501116
  },
  [8501117] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill04_HalfCylinder",
    TaskEffects = {
      [1] = T.RT_842,
      [2] = {
        CauseHit = "BossLizhan_Skill04",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_839
    },
    TaskId = 8501117
  },
  [8501121] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "LizhanTargetLocation_Skill05"
      },
      [2] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "1"
      },
      [3] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "2"
      },
      [4] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "3"
      },
      [5] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "4"
      },
      [6] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "5"
      },
      [7] = {
        CreatureId = 850102,
        Function = "CreateSkillCreature",
        Location = T.RT_238,
        SetSavelocAsTarget = "6"
      }
    },
    TaskId = 8501121
  },
  [8501122] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 0.85
      },
      [2] = T.RT_786,
      [3] = T.RT_843,
      [4] = T.RT_839
    },
    TaskId = 8501122
  },
  [8501123] = {
    TargetFilter = "BossLizhan_Skill05_Cylinder",
    TaskEffects = {
      [1] = {
        FXId = 850105,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_844,
      [3] = T.RT_839
    },
    TaskId = 8501123
  },
  [8501124] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 8501124
  },
  [8501131] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill04_Cylinder",
    TaskEffects = {
      [1] = T.RT_845,
      [2] = T.RT_835,
      [3] = T.RT_839
    },
    TaskId = 8501131
  },
  [8501132] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLizhan_Skill07_Cylinder_120",
    TaskEffects = {
      [1] = T.RT_842,
      [2] = T.RT_838,
      [3] = T.RT_839
    },
    TaskId = 8501132
  },
  [8501133] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850103,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8501133
  },
  [8501134] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850103,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8501134
  },
  [8501135] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_833,
        Function = "Damage",
        Rate = 1.8
      },
      [2] = {
        CauseHit = "BossLizhan_Skill07",
        Function = "CutToughness",
        Value = 100
      },
      [3] = T.RT_836
    },
    TaskId = 8501135
  },
  [8501146] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill04_Cylinder",
    TaskEffects = {
      [1] = T.RT_845,
      [2] = T.RT_846,
      [3] = T.RT_839
    },
    TaskId = 8501146
  },
  [8501147] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850101,
        Duration = 15,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 8501147
  },
  [8501148] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_840,
      [2] = T.RT_843,
      [3] = T.RT_839
    },
    TaskId = 8501148
  },
  [8501149] = {
    TargetFilter = "BossLizhan_Skill10_Cylinder",
    TaskEffects = {
      [1] = {
        FXId = 850107,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [2] = T.RT_844,
      [3] = T.RT_839
    },
    TaskId = 8501149
  },
  [8501151] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 8501151
  },
  [8501152] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationEndZ = -2000,
        FixLocationStartZ = 0,
        Function = "SetSelfLoc",
        LocOffset = {
          0,
          0,
          230
        },
        TargetCenterLoc = "SavedLoc"
      }
    },
    TaskId = 8501152
  },
  [8501153] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLizhan_Skill11_Cylinder",
    TaskEffects = T.RT_841,
    TaskId = 8501153
  },
  [8501156] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850308,
        Function = "AddBuff",
        LastTime = 99
      }
    },
    TaskId = 8501156
  },
  [8501157] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 850308, Function = "RemoveBuff"}
    },
    TaskId = 8501157
  },
  [8501161] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLizhan_Skill01_HalfCylinder",
    TaskEffects = T.RT_837,
    TaskId = 8501161
  },
  [8502101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_849,
    TaskId = 8502101
  },
  [8502102] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_852,
    TaskId = 8502102
  },
  [8502103] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_853,
    TaskId = 8502103
  },
  [8502104] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_856,
    TaskId = 8502104
  },
  [8502105] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_110,
      [3] = {Function = "PlaySE", SEId = 850222}
    },
    TaskId = 8502105
  },
  [8502106] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_858,
    TaskId = 8502106
  },
  [8502107] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_860,
    TaskId = 8502107
  },
  [8502108] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill04_Cylinder_300_200_360",
    TaskEffects = T.RT_861,
    TaskId = 8502108
  },
  [8502109] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossSaiqi_Skill13_Cylinder_300_200_360",
    TaskEffects = T.RT_863,
    TaskId = 8502109
  },
  [8502110] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_864,
      [2] = {
        BuffId = 850210,
        Function = "AddBuff",
        LastTime = 9999
      }
    },
    TaskId = 8502110
  },
  [8502111] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_869,
    TaskId = 8502111
  },
  [8502112] = {
    NotifyName = T.RT_870,
    TargetFilter = "Self",
    TaskEffects = T.RT_876,
    TaskId = 8502112
  },
  [8502113] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_879,
    TaskId = 8502113
  },
  [8502114] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_882,
    TaskId = 8502114
  },
  [8502115] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_885,
    TaskId = 8502115
  },
  [8502116] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_888,
    TaskId = 8502116
  },
  [8502117] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_889
    },
    TaskId = 8502117
  },
  [8502118] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_890,
      [2] = T.RT_892,
      [3] = {
        Function = "EffectFunction",
        FunctionName = "RelativeLocationToTarget",
        Vars = {
          Distance = 600,
          Tag = 1,
          X = 200
        }
      },
      [4] = {
        Function = "EffectFunction",
        FunctionName = "RelativeLocationToTarget",
        Vars = {
          Distance = 600,
          Tag = 2,
          X = -200
        }
      }
    },
    TaskId = 8502118
  },
  [8502119] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850218,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8502119
  },
  [8502120] = {
    TargetFilter = "BossSaiqi_Skill07_Cylinder_300_800_360",
    TaskEffects = T.RT_894,
    TaskId = 8502120
  },
  [8502121] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8502121
  },
  [8502122] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_896,
      [2] = T.RT_897
    },
    TaskId = 8502122
  },
  [8502123] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_898,
    TaskId = 8502123
  },
  [8502124] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 1.3,
        UnitId = 850281,
        UnitType = "MechanismSummon",
        UseSaveLoc = "08"
      }
    },
    TaskId = 8502124
  },
  [8502125] = {
    TargetFilter = "LaserTarget",
    TaskEffects = T.RT_899,
    TaskId = 8502125
  },
  [8502126] = {
    TargetFilter = "LaserTarget",
    TaskEffects = T.RT_900,
    TaskId = 8502126
  },
  [8502127] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_902,
    TaskId = 8502127
  },
  [8502128] = {
    NotifyName = T.RT_903,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8502128
  },
  [8502129] = {
    NotifyName = T.RT_904,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_906,
    TaskId = 8502129
  },
  [8502130] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_907
    },
    TaskId = 8502130
  },
  [8502131] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8502131
  },
  [8502132] = {
    NotifyName = T.RT_908,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_910,
    TaskId = 8502132
  },
  [8502133] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_911,
    TaskId = 8502133
  },
  [8502134] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_912,
    TaskId = 8502134
  },
  [8502135] = {
    NotifyName = T.RT_913,
    TargetFilter = "Self",
    TaskEffects = T.RT_915,
    TaskId = 8502135
  },
  [8502136] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = T.RT_917,
    TaskId = 8502136
  },
  [8502137] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossSaiqi_Skill01_Cylinder_450_200_270",
    TaskEffects = T.RT_918,
    TaskId = 8502137
  },
  [8502138] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8502138
  },
  [8502139] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_919,
    TaskId = 8502139
  },
  [8502140] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = T.RT_920,
    TaskId = 8502140
  },
  [8502141] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_319
    },
    TaskId = 8502141
  },
  [8502142] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850219,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8502142
  },
  [8502143] = {
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_319
    },
    TaskId = 8502143
  },
  [8502144] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = {
      [1] = T.RT_683,
      [2] = T.RT_681,
      [3] = T.RT_848
    },
    TaskId = 8502144
  },
  [8502145] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850201,
        Duration = 3,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 8502145
  },
  [8502146] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = {Function = "PlaySE", SEId = 850219}
    },
    TaskId = 8502146
  },
  [8502147] = {
    NotifyName = {
      "hit1",
      "hit2",
      "hit3",
      "hit4",
      "hit5",
      "hit6"
    },
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850214,
        Function = "CreateSkillCreature",
        Location = {
          50,
          40,
          300
        }
      }
    },
    TaskId = 8502147
  },
  [8502148] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_889
    },
    TaskId = 8502148
  },
  [8502149] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8502149
  },
  [8502150] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {
          Tag = 1,
          X = 700,
          Y = 0
        }
      },
      [2] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {
          Tag = 2,
          X = -700,
          Y = 0
        }
      },
      [3] = T.RT_921,
      [4] = T.RT_922,
      [5] = T.RT_897
    },
    TaskId = 8502150
  },
  [8502151] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {
          Tag = 3,
          X = 0,
          Y = 700
        }
      },
      [2] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {
          Tag = 4,
          X = 0,
          Y = -700
        }
      },
      [3] = T.RT_923,
      [4] = T.RT_924
    },
    TaskId = 8502151
  },
  [8502152] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_762,
      [2] = T.RT_897,
      [3] = T.RT_921,
      [4] = T.RT_922,
      [5] = T.RT_923,
      [6] = T.RT_924
    },
    TaskId = 8502152
  },
  [8502154] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_890,
      [2] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {Tag = 1, X = 2500}
      },
      [3] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {Tag = 2, X = -2500}
      },
      [4] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {Tag = 3, X = 1000}
      },
      [5] = {
        Function = "EffectFunction",
        FunctionName = "SaveLoc",
        Vars = {Tag = 4, X = -1000}
      }
    },
    TaskId = 8502154
  },
  [8502155] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850220,
        Function = "CreateSkillCreature",
        UseSaveLoc = "1"
      },
      [2] = {
        CreatureId = 850220,
        Function = "CreateSkillCreature",
        UseSaveLoc = "2"
      }
    },
    TaskId = 8502155
  },
  [8502156] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850221,
        Function = "CreateSkillCreature",
        UseSaveLoc = "3"
      },
      [2] = {
        CreatureId = 850221,
        Function = "CreateSkillCreature",
        UseSaveLoc = "4"
      }
    },
    TaskId = 8502156
  },
  [8502157] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_925,
      [2] = T.RT_926,
      [3] = T.RT_896
    },
    TaskId = 8502157
  },
  [8502158] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_927,
      [2] = T.RT_928
    },
    TaskId = 8502158
  },
  [8502159] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = T.RT_896,
      [2] = T.RT_925,
      [3] = T.RT_926,
      [4] = T.RT_927,
      [5] = T.RT_928
    },
    TaskId = 8502159
  },
  [8502160] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850222,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8502160
  },
  [8502161] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        Function = "CreateUnit",
        LifeTime = 19,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850201,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8502161
  },
  [8502162] = {
    NotifyName = {"hit2", "hit4"},
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          300,
          0,
          0
        }
      },
      [2] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          -300,
          0,
          0
        }
      },
      [3] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          0,
          300,
          0
        }
      },
      [4] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          0,
          -300,
          0
        }
      }
    },
    TaskId = 8502162
  },
  [8502163] = {
    NotifyName = {"hit3", "hit5"},
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          212,
          212,
          0
        }
      },
      [2] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          -212,
          212,
          0
        }
      },
      [3] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          212,
          -212,
          0
        }
      },
      [4] = {
        CreatureId = 850223,
        Function = "CreateSkillCreature",
        Location = {
          -212,
          -212,
          0
        }
      }
    },
    TaskId = 8502163
  },
  [8502164] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 850224,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8502164
  },
  [8502165] = {
    TargetFilter = "BossSaiqi_Skill23_Cylinder_1000_1000_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_784,
      [3] = T.RT_319
    },
    TaskId = 8502165
  },
  [8503101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill01_L",
    TaskEffects = T.RT_933,
    TaskId = 8503101
  },
  [8503106] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill01_R",
    TaskEffects = T.RT_933,
    TaskId = 8503106
  },
  [8503111] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill02_Cylinder01",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_934,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 8503111
  },
  [8503112] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill02_Cylinder02",
    TaskEffects = T.RT_949,
    TaskId = 8503112
  },
  [8503116] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_937,
    TaskId = 8503116
  },
  [8503117] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_951,
    TaskId = 8503117
  },
  [8503118] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_320_250_360",
    TaskEffects = T.RT_935,
    TaskId = 8503118
  },
  [8503119] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850307,
        Direction = {
          50,
          45,
          0
        },
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_952
      },
      [2] = {
        CreatureId = 850307,
        Direction = {
          50,
          -45,
          0
        },
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_952
      },
      [3] = {
        CreatureId = 850307,
        Direction = T.RT_953,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_952
      },
      [4] = T.RT_939
    },
    TaskId = 8503119
  },
  [8503121] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = T.RT_940,
    TaskId = 8503121
  },
  [8503122] = {
    NotifyName = T.RT_954,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = T.RT_506,
    TaskId = 8503122
  },
  [8503126] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_942,
    TaskId = 8503126
  },
  [8503127] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_944,
    TaskId = 8503127
  },
  [8503128] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill05_RushPillar",
    TaskEffects = T.RT_956,
    TaskId = 8503128
  },
  [8503129] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Cylinder_600_350_360",
    TaskEffects = {
      [1] = T.RT_14,
      [2] = T.RT_938,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 8503129
  },
  [8503131] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_946,
    TaskId = 8503131
  },
  [8503132] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder01",
    TaskEffects = {
      [1] = T.RT_22,
      [2] = T.RT_930,
      [3] = T.RT_931,
      [4] = T.RT_957
    },
    TaskId = 8503132
  },
  [8503133] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder02",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_930,
      [3] = T.RT_931,
      [4] = T.RT_957
    },
    TaskId = 8503133
  },
  [8503134] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossShijingzhe_Skill07_Cylinder03",
    TaskEffects = {
      [1] = T.RT_679,
      [2] = T.RT_938,
      [3] = T.RT_931,
      [4] = T.RT_957
    },
    TaskId = 8503134
  },
  [8503136] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_960,
      [3] = T.RT_961,
      [4] = T.RT_962
    },
    TaskId = 8503136
  },
  [8503137] = {
    NotifyName = T.RT_12,
    TargetFilter = "Self",
    TaskEffects = T.RT_966,
    TaskId = 8503137
  },
  [8503138] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_960,
      [3] = T.RT_961,
      [4] = T.RT_962,
      [5] = T.RT_967
    },
    TaskId = 8503138
  },
  [8503139] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_966,
    TaskId = 8503139
  },
  [8503140] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_960,
      [3] = T.RT_972,
      [4] = T.RT_967
    },
    TaskId = 8503140
  },
  [8503141] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_895,
    TaskId = 8503141
  },
  [8503142] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "RandomAreaLocation",
        Vars = {
          Distance = 600,
          MaxNum = 4,
          Radius = 1000
        }
      },
      [2] = T.RT_968,
      [3] = T.RT_969,
      [4] = T.RT_970,
      [5] = T.RT_971
    },
    TaskId = 8503142
  },
  [8503143] = {
    NotifyName = T.RT_12,
    TaskEffects = T.RT_977,
    TaskId = 8503143
  },
  [8503144] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossShijingzhe_Skill03_Cylinder_1000_200_360",
    TaskEffects = T.RT_940,
    TaskId = 8503144
  },
  [8503145] = {
    TargetFilter = "BossShijingzhe_Cylinder_1000_200_360",
    TaskEffects = {
      [1] = T.RT_783,
      [2] = T.RT_938,
      [3] = T.RT_931,
      [4] = T.RT_939
    },
    TaskId = 8503145
  },
  [8503146] = {
    NotifyName = T.RT_2,
    TaskEffects = T.RT_979,
    TaskId = 8503146
  },
  [8503147] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850306,
        Function = "CreateSkillCreature",
        Location = {
          0,
          0,
          850
        }
      }
    },
    TaskId = 8503147
  },
  [8503148] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_831,
      [2] = {
        CauseHit = "LightHit_60",
        Function = "CutToughness",
        Value = 30
      },
      [3] = T.RT_843,
      [4] = T.RT_980,
      [5] = T.RT_939
    },
    TaskId = 8503148
  },
  [8503151] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          10,
          50,
          0
        }
      },
      [2] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          10,
          -50,
          0
        }
      },
      [3] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = T.RT_808
      },
      [4] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = T.RT_807
      }
    },
    TaskId = 8503151
  },
  [8503152] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          23,
          -30,
          0
        }
      },
      [2] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          23,
          30,
          0
        }
      },
      [3] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          36,
          -30,
          0
        }
      },
      [4] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          36,
          30,
          0
        }
      }
    },
    TaskId = 8503152
  },
  [8503153] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          40,
          -40,
          0
        }
      }
    },
    TaskId = 8503153
  },
  [8503154] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850316,
        Function = "CreateSkillCreature",
        Location = T.RT_239,
        Rotation = {
          50,
          60,
          0
        }
      }
    },
    TaskId = 8503154
  },
  [8503156] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_skill12_L",
    TaskEffects = T.RT_981,
    TaskId = 8503156
  },
  [8503157] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850307,
        Direction = T.RT_982,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_983
      },
      [2] = {
        CreatureId = 850307,
        Direction = T.RT_984,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_983
      },
      [3] = {
        CreatureId = 850307,
        Direction = T.RT_426,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_983
      }
    },
    TaskId = 8503157
  },
  [8503158] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = T.RT_985,
      [2] = T.RT_934,
      [3] = T.RT_931,
      [4] = T.RT_932
    },
    TaskId = 8503158
  },
  [8503161] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Cylinder_skill12_R",
    TaskEffects = T.RT_981,
    TaskId = 8503161
  },
  [8503162] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 850307,
        Direction = T.RT_982,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_986
      },
      [2] = {
        CreatureId = 850307,
        Direction = {
          -50,
          50,
          0
        },
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_986
      },
      [3] = {
        CreatureId = 850307,
        Direction = T.RT_425,
        DirectionBase = "Creature",
        Function = "CreateSkillCreature",
        Location = T.RT_986
      }
    },
    TaskId = 8503162
  },
  [8503166] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850308,
        Function = "CreateSkillCreature",
        Location = T.RT_987
      },
      [2] = {
        CreatureId = 850309,
        Function = "CreateSkillCreature",
        Location = T.RT_987
      },
      [3] = {
        CreatureId = 850310,
        Function = "CreateSkillCreature",
        Location = T.RT_987
      },
      [4] = {
        CreatureId = 850311,
        Function = "CreateSkillCreature",
        Location = T.RT_987
      }
    },
    TaskId = 8503166
  },
  [8503167] = {
    TargetFilter = "BossShijingzhe_Sphere_3000_360_NoMch",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = T.RT_656,
      [3] = T.RT_931,
      [4] = T.RT_939
    },
    TaskId = 8503167
  },
  [8503171] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.075
      }
    },
    TaskId = 8503171
  },
  [8503172] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.11
      }
    },
    TaskId = 8503172
  },
  [8503173] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.16
      }
    },
    TaskId = 8503173
  },
  [8503174] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "Hp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.3
      }
    },
    TaskId = 8503174
  },
  [8503176] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_895,
    TaskId = 8503176
  },
  [8503177] = {
    TargetFilter = "BossShijingzhe_Cylinder_600_200_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_988,
      [3] = T.RT_931,
      [4] = T.RT_939
    },
    TaskId = 8503177
  },
  [8503181] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill13_Howl",
    TaskEffects = {
      [1] = {
        CauseHit = "BossShijingzhe_Effect8503181",
        Function = "CutToughness",
        NotRotateWhenHit = true,
        Value = 10
      }
    },
    TaskId = 8503181
  },
  [8503182] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill13_Select",
    TaskEffects = T.RT_992,
    TaskId = 8503182
  },
  [8503183] = {
    NotifyName = T.RT_12,
    TargetFilter = "Boss_Grab_GetActorByEid",
    TaskEffects = {
      [1] = {
        CauseHit = "BossShijingzhe_Effect8503182",
        Function = "GrabHit"
      },
      [2] = T.RT_498
    },
    TaskId = 8503183
  },
  [8503184] = {
    NotifyName = T.RT_13,
    TargetFilter = "Boss_Grab_GetActorByEid",
    TaskEffects = T.RT_993,
    TaskId = 8503184
  },
  [8503185] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill13_Howl_Pillar",
    TaskEffects = T.RT_956,
    TaskId = 8503185
  },
  [8503186] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossShijingzhe_Skill11_Donut01",
    TaskEffects = T.RT_994,
    TaskId = 8503186
  },
  [8503187] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossShijingzhe_Skill11_Donut02",
    TaskEffects = T.RT_994,
    TaskId = 8503187
  },
  [8503188] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossShijingzhe_Skill11_Donut03",
    TaskEffects = T.RT_994,
    TaskId = 8503188
  },
  [8503191] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_895,
    TaskId = 8503191
  },
  [8503192] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_960,
      [3] = T.RT_962
    },
    TaskId = 8503192
  },
  [8503193] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_966,
    TaskId = 8503193
  },
  [8503194] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_960,
      [3] = T.RT_963,
      [4] = T.RT_962,
      [5] = T.RT_965
    },
    TaskId = 8503194
  },
  [8503195] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_959,
      [2] = T.RT_972,
      [3] = T.RT_961,
      [4] = T.RT_964,
      [5] = T.RT_967
    },
    TaskId = 8503195
  },
  [8503196] = {
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8503196
  },
  [8503197] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850312,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8503197
  },
  [8503198] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850309,
        Function = "AddBuff",
        LastTime = 5.7
      }
    },
    TaskId = 8503198
  },
  [8503201] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850313,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 8503201
  },
  [8503202] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 1440065
      }
    },
    TaskId = 8503202
  },
  [8503203] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850312,
        Function = "AddBuff",
        LastTime = -1
      },
      [2] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 1440065
      }
    },
    TaskId = 8503203
  },
  [8503204] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 850312, Function = "RemoveBuff"}
    },
    TaskId = 8503204
  },
  [8503205] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        BuffId = 850310,
        Function = "AddBuff",
        LastTime = 31
      },
      [2] = T.RT_995
    },
    TaskId = 8503205
  },
  [8503206] = {
    NotifyName = T.RT_13,
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 850305,
        Duration = 11,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 8503206
  },
  [8503207] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_782,
      [2] = T.RT_110,
      [3] = T.RT_957
    },
    TaskId = 8503207
  },
  [8503208] = {
    NotifyName = T.RT_404,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_998,
      [2] = T.RT_998,
      [3] = T.RT_998,
      [4] = T.RT_998
    },
    TaskId = 8503208
  },
  [8503209] = {
    NotifyName = T.RT_507,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Camp = "Enemy",
        Function = "CreateUnit",
        LifeTime = 34,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850316,
        UnitType = "MechanismSummon",
        UseSaveLoc = "SJZ_Skill15_Pillar"
      },
      [2] = {
        CreatureId = 850327,
        Function = "CreateSkillCreature",
        UseSaveLoc = "SJZ_Skill15_Pillar"
      }
    },
    TaskId = 8503209
  },
  [8503210] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850325,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 850328,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 850329,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8503210
  },
  [8503211] = {
    TargetFilter = "BossShijingzhe_Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 7.3
      },
      [2] = T.RT_939
    },
    TaskId = 8503211
  },
  [8503212] = {
    TargetFilter = "BossShijingzhe_Skill15Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 1
      },
      [2] = T.RT_939
    },
    TaskId = 8503212
  },
  [8503213] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          52.2936,
          597.717,
          0
        },
        Rotation = {
          0,
          5,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          155.2914,
          579.5556,
          0
        },
        Rotation = T.RT_142
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          253.5708,
          543.7842,
          0
        },
        Rotation = T.RT_423
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          344.1456,
          491.4912,
          0
        },
        Rotation = {
          0,
          35,
          0
        }
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          424.2642,
          424.2642,
          0
        },
        Rotation = T.RT_174
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          491.4912,
          344.1456,
          0
        },
        Rotation = {
          0,
          55,
          0
        }
      }
    },
    TaskId = 8503213
  },
  [8503214] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          543.7842,
          253.5708,
          0
        },
        Rotation = {
          0,
          65,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          579.5556,
          155.2914,
          0
        },
        Rotation = T.RT_427
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          597.717,
          52.2936,
          0
        },
        Rotation = {
          0,
          85,
          0
        }
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          597.717,
          -52.2936,
          0
        },
        Rotation = {
          0,
          95,
          0
        }
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          579.5556,
          -155.2914,
          0
        },
        Rotation = {
          0,
          105,
          0
        }
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          543.7842,
          -253.5708,
          0
        },
        Rotation = {
          0,
          115,
          0
        }
      }
    },
    TaskId = 8503214
  },
  [8503215] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          491.4912,
          -344.1456,
          0
        },
        Rotation = {
          0,
          125,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          424.2642,
          -424.2642,
          0
        },
        Rotation = T.RT_359
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          344.1456,
          -491.4912,
          0
        },
        Rotation = {
          0,
          145,
          0
        }
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          253.5708,
          -543.7842,
          0
        },
        Rotation = {
          0,
          155,
          0
        }
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          155.2914,
          -579.5556,
          0
        },
        Rotation = {
          0,
          165,
          0
        }
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          52.2936,
          -597.717,
          0
        },
        Rotation = {
          0,
          175,
          0
        }
      }
    },
    TaskId = 8503215
  },
  [8503216] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -52.2936,
          -597.717,
          0
        },
        Rotation = {
          0,
          -175,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -155.2914,
          -579.5556,
          0
        },
        Rotation = {
          0,
          -165,
          0
        }
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -253.5708,
          -543.7842,
          0
        },
        Rotation = {
          0,
          -155,
          0
        }
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -344.1456,
          -491.4912,
          0
        },
        Rotation = {
          0,
          -145,
          0
        }
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -424.2642,
          -424.2642,
          0
        },
        Rotation = T.RT_360
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -491.4912,
          -344.1456,
          0
        },
        Rotation = {
          0,
          -125,
          0
        }
      }
    },
    TaskId = 8503216
  },
  [8503217] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -543.7842,
          -253.5708,
          0
        },
        Rotation = {
          0,
          -115,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -579.5556,
          -155.2914,
          0
        },
        Rotation = {
          0,
          -105,
          0
        }
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -597.717,
          -52.2936,
          0
        },
        Rotation = {
          0,
          -95,
          0
        }
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -597.717,
          52.2936,
          0
        },
        Rotation = {
          0,
          -85,
          0
        }
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -579.5556,
          155.2914,
          0
        },
        Rotation = T.RT_428
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -543.7842,
          253.5708,
          0
        },
        Rotation = {
          0,
          -65,
          0
        }
      }
    },
    TaskId = 8503217
  },
  [8503218] = {
    NotifyName = T.RT_825,
    TaskEffects = {
      [1] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -491.4912,
          344.1456,
          0
        },
        Rotation = {
          0,
          -55,
          0
        }
      },
      [2] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -424.2642,
          424.2642,
          0
        },
        Rotation = T.RT_358
      },
      [3] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -344.1456,
          491.4912,
          0
        },
        Rotation = {
          0,
          -35,
          0
        }
      },
      [4] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -253.5708,
          543.7842,
          0
        },
        Rotation = T.RT_424
      },
      [5] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -155.2914,
          579.5556,
          0
        },
        Rotation = T.RT_141
      },
      [6] = {
        CreatureId = 850326,
        Function = "CreateSkillCreature",
        Location = {
          -52.2936,
          597.717,
          0
        },
        Rotation = {
          0,
          -5,
          0
        }
      }
    },
    TaskId = 8503218
  },
  [8503219] = {
    TargetFilter = "BossShijingzhe_Skill15Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.07
      },
      [2] = T.RT_939
    },
    TaskId = 8503219
  },
  [8503220] = {
    NotifyName = {"hit93"},
    TargetFilter = "BossShijingzhe_Skill15_ClearPillar",
    TaskEffects = T.RT_956,
    TaskId = 8503220
  },
  [8503221] = {
    NotifyName = {"hit94"},
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 850313, Function = "RemoveBuff"}
    },
    TaskId = 8503221
  },
  [8503222] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = {MaxHp = 1},
        Function = "CreateUnit",
        LifeTime = 35,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 850315,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 8503222
  },
  [8505101] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_01",
    TaskEffects = T.RT_1024,
    TaskId = 8505101
  },
  [8505102] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_02",
    TaskEffects = T.RT_1025,
    TaskId = 8505102
  },
  [8505103] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill01_Cylinder_02",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_553,
      [3] = T.RT_1033
    },
    TaskId = 8505103
  },
  [8505104] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill01_Cross",
    TaskEffects = T.RT_1034,
    TaskId = 8505104
  },
  [8505105] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_01",
    TaskEffects = T.RT_1026,
    TaskId = 8505105
  },
  [8505106] = {
    NotifyName = T.RT_1027,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_02",
    TaskEffects = T.RT_1028,
    TaskId = 8505106
  },
  [8505107] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_03",
    TaskEffects = T.RT_1029,
    TaskId = 8505107
  },
  [8505108] = {
    NotifyName = T.RT_404,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_03",
    TaskEffects = T.RT_1030,
    TaskId = 8505108
  },
  [8505109] = {
    NotifyName = T.RT_507,
    TargetFilter = "BossLianhuo_Skill01_Cross",
    TaskEffects = T.RT_1034,
    TaskId = 8505109
  },
  [8505110] = {
    NotifyName = T.RT_825,
    TargetFilter = "Self",
    TaskEffects = T.RT_816,
    TaskId = 8505110
  },
  [8505111] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill03_Cylinder",
    TaskEffects = T.RT_1032,
    TaskId = 8505111
  },
  [8505112] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 850501,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 8505112
  },
  [8505113] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_895,
    TaskId = 8505113
  },
  [8505114] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850511,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Skill03Target",
        UseSaveLoc = "SelfLoc"
      }
    },
    TaskId = 8505114
  },
  [8505115] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 5,
        MaxSummonCount = 3,
        SingleSummonCount = 1,
        UnitId = 850502,
        UnitType = "MechanismSummon"
      },
      [3] = T.RT_1031
    },
    TaskId = 8505115
  },
  [8505116] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = T.RT_1036,
    TaskId = 8505116
  },
  [8505117] = {
    NotifyName = T.RT_1027,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1038,
      [2] = {
        CreatureId = 850502,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        Rotation = T.RT_174,
        UseRelativeOffset = true,
        UseSaveLoc = "First1"
      },
      [3] = {
        CreatureId = 850502,
        Function = "CreateSkillCreature",
        Location = T.RT_1037,
        Rotation = T.RT_174,
        UseRelativeOffset = true,
        UseSaveLoc = "First2"
      }
    },
    TaskId = 8505117
  },
  [8505118] = {
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = T.RT_1039,
    TaskId = 8505118
  },
  [8505119] = {
    NotifyName = T.RT_13,
    TargetFilter = "Self",
    TaskEffects = T.RT_1042,
    TaskId = 8505119
  },
  [8505120] = {
    NotifyName = T.RT_404,
    TargetFilter = "Self",
    TaskEffects = T.RT_1044,
    TaskId = 8505120
  },
  [8505121] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1047,
    TaskId = 8505121
  },
  [8505122] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_03",
    TaskEffects = T.RT_1029,
    TaskId = 8505122
  },
  [8505123] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8505123
  },
  [8505124] = {
    NotifyName = T.RT_9,
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850513,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8505124
  },
  [8505125] = {
    TargetFilter = "BossLianhuo_Skill05_Cross",
    TaskEffects = T.RT_1039,
    TaskId = 8505125
  },
  [8505126] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill06_Cylinder",
    TaskEffects = T.RT_1048,
    TaskId = 8505126
  },
  [8505127] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = T.RT_1054,
    TaskId = 8505127
  },
  [8505128] = {
    TargetFilter = "BossLianhuo_Skill06_Cylinder_02",
    TaskEffects = {
      [1] = T.RT_1022,
      [2] = T.RT_1031,
      [3] = T.RT_1033,
      [4] = T.RT_701
    },
    TaskId = 8505128
  },
  [8505129] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill06_Cylinder",
    TaskEffects = T.RT_1055,
    TaskId = 8505129
  },
  [8505130] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_772,
    TaskId = 8505130
  },
  [8505131] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850506,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8505131
  },
  [8505132] = {
    TargetFilter = "BossLianhuo_Skill07_Select",
    TaskEffects = T.RT_992,
    TaskId = 8505132
  },
  [8505133] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = T.RT_1057,
    TaskId = 8505133
  },
  [8505134] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossLianhuo_Skill07_GetActor",
    TaskEffects = T.RT_993,
    TaskId = 8505134
  },
  [8505135] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "ActiveStaticCreator",
        StaticCreatorId = 1660122
      },
      [2] = T.RT_1019
    },
    TaskId = 8505135
  },
  [8505136] = {
    NotifyName = T.RT_1058,
    TargetFilter = "Self",
    TaskEffects = T.RT_1060,
    TaskId = 8505136
  },
  [8505137] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1062,
    TaskId = 8505137
  },
  [8505138] = {
    NotifyName = T.RT_1063,
    TargetFilter = "Self",
    TaskEffects = T.RT_1065,
    TaskId = 8505138
  },
  [8505139] = {
    NotifyName = {
      "hit15",
      "hit1",
      "hit22"
    },
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_895,
    TaskId = 8505139
  },
  [8505140] = {
    NotifyName = T.RT_1066,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1068,
    TaskId = 8505140
  },
  [8505141] = {
    NotifyName = T.RT_1069,
    TargetFilter = "BossLianhuo_Skill08_Cylinder",
    TaskEffects = T.RT_1048,
    TaskId = 8505141
  },
  [8505142] = {
    NotifyName = T.RT_1070,
    TargetFilter = "AlmostAllEnemy",
    TaskEffects = T.RT_1071,
    TaskId = 8505142
  },
  [8505143] = {
    NotifyName = T.RT_1070,
    TargetFilter = "AlmostAllEnemy",
    TaskEffects = {
      [1] = {
        Function = "InactiveStaticCreator",
        StaticCreatorId = 1660122
      },
      [2] = T.RT_1072
    },
    TaskId = 8505143
  },
  [8505144] = {
    NotifyName = T.RT_1073,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1076,
    TaskId = 8505144
  },
  [8505145] = {
    NotifyName = T.RT_1077,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1081,
    TaskId = 8505145
  },
  [8505146] = {
    NotifyName = T.RT_1082,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1084,
    TaskId = 8505146
  },
  [8505147] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_821,
      [2] = T.RT_1023
    },
    TaskId = 8505147
  },
  [8505148] = {
    NotifyName = {"hit27"},
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1085
    },
    TaskId = 8505148
  },
  [8505149] = {
    NotifyName = T.RT_1086,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1087
    },
    TaskId = 8505149
  },
  [8505150] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1088,
    TaskId = 8505150
  },
  [8505151] = {
    TargetFilter = "Mon_Sphere_200_360",
    TaskEffects = T.RT_1088,
    TaskId = 8505151
  },
  [8505152] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 850517,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8505152
  },
  [8505153] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLianhuo_Skill12_Rectangle",
    TaskEffects = T.RT_1089,
    TaskId = 8505153
  },
  [8505154] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossLianhuo_Skill02_Cylinder_01",
    TaskEffects = T.RT_1091,
    TaskId = 8505154
  },
  [8505155] = {
    NotifyName = T.RT_1092,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_1094,
    TaskId = 8505155
  },
  [8505156] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        FixLocationEndZ = -3500,
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "FirePool",
        TargetType = "Target"
      }
    },
    TaskId = 8505156
  },
  [8505157] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "RandomAreaLocation",
        Vars = {
          Distance = 850,
          MaxNum = 3,
          Radius = 1300
        }
      }
    },
    TaskId = 8505157
  },
  [8505158] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850512,
        Function = "CreateSkillCreature",
        UseSaveLoc = "3"
      },
      [2] = {
        CreatureId = 850512,
        Function = "CreateSkillCreature",
        UseSaveLoc = "FirePool"
      },
      [3] = {
        CreatureId = 850512,
        Function = "CreateSkillCreature",
        UseSaveLoc = "1"
      },
      [4] = {
        CreatureId = 850512,
        Function = "CreateSkillCreature",
        UseSaveLoc = "2"
      },
      [5] = {
        Function = "PlaySE",
        SEId = 850514,
        SceneSe = true
      }
    },
    TaskId = 8505158
  },
  [8505159] = {
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        Function = "Damage",
        Rate = 0.025
      }
    },
    TaskId = 8505159
  },
  [8505160] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850512,
        Function = "CreateSkillCreature",
        UseSaveLoc = ""
      }
    },
    TaskId = 8505160
  },
  [8505161] = {
    NotifyName = {"hit28"},
    TargetFilter = "Self",
    TaskEffects = T.RT_1054,
    TaskId = 8505161
  },
  [8505162] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 850516,
        Function = "CreateSkillCreature",
        Location = {
          190,
          0,
          -270
        }
      }
    },
    TaskId = 8505162
  },
  [8505163] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 850518,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Skill03Target"
      }
    },
    TaskId = 8505163
  },
  [8512901] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossLinen_Skill01",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1151
    },
    TaskId = 8512901
  },
  [8512906] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = T.RT_1172,
    TaskId = 8512906
  },
  [8512907] = {
    TargetFilter = "BossLinen_Skill02_Scene",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_1155,
      [3] = T.RT_1156
    },
    TaskId = 8512907
  },
  [8512911] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 8512902,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_1173,
      [3] = {
        CreatureId = 8512904,
        Delay = 0.333,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8512911
  },
  [8512912] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 8512905,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 8512906,
        Delay = 0.167,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 8512907,
        Delay = 0.333,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8512912
  },
  [8512913] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 8512928,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 8512929,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 8512902,
        Delay = 0.033,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 8512906,
        Delay = 0.067,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 8512905,
        Delay = 0.1,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 8512904,
        Delay = 0.133,
        Function = "CreateSkillCreature"
      },
      [7] = T.RT_1173,
      [8] = {
        CreatureId = 8512907,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8512913
  },
  [8512914] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_498,
      [2] = T.RT_1159,
      [3] = T.RT_1156
    },
    TaskId = 8512914
  },
  [8512915] = {
    TargetFilter = "BossLinen_Skill03_Scene1",
    TaskEffects = {
      [1] = T.RT_1160,
      [2] = T.RT_498,
      [3] = T.RT_1156
    },
    TaskId = 8512915
  },
  [8512956] = {
    NotifyName = T.RT_2,
    TargetFilter = "Target",
    TaskEffects = T.RT_1172,
    TaskId = 8512956
  },
  [8512991] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 8512931,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 8512932,
        Delay = 0.04,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 8512933,
        Delay = 0.08,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 8512934,
        Delay = 0.12,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 8512935,
        Delay = 0.16,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 8512936,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8512991
  },
  [8512992] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 8512937,
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 8512938,
        Delay = 0.04,
        Function = "CreateSkillCreature"
      },
      [3] = {
        CreatureId = 8512939,
        Delay = 0.08,
        Function = "CreateSkillCreature"
      },
      [4] = {
        CreatureId = 8512940,
        Delay = 0.12,
        Function = "CreateSkillCreature"
      },
      [5] = {
        CreatureId = 8512941,
        Delay = 0.16,
        Function = "CreateSkillCreature"
      },
      [6] = {
        CreatureId = 8512942,
        Delay = 0.2,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8512992
  },
  [8520100] = {
    TaskEffects = T.RT_1111,
    TaskId = 8520100
  },
  [8520101] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520009,
        UnitType = "Monster"
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520010,
        UnitType = "Monster"
      }
    },
    TaskId = 8520101
  },
  [8520102] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201107,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 8520102
  },
  [8520103] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201108,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 8520103
  },
  [8520104] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201109,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 8520104
  },
  [8520105] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BattlePointID = 85201110,
        Function = "SetSelfLoc",
        TargetCenterLoc = "BattlePoint",
        UseBattlePointRotation = 1
      }
    },
    TaskId = 8520105
  },
  [8520106] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520011,
        UnitType = "Monster"
      },
      [2] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520012,
        UnitType = "Monster"
      },
      [3] = {
        Function = "CreateUnit",
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 8520013,
        UnitType = "Monster"
      }
    },
    TaskId = 8520106
  },
  [8520107] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852035,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8520107
  },
  [8520108] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852025,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8520108
  },
  [8520109] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852036,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8520109
  },
  [8520110] = {
    TargetFilter = "BossAida_Skill23_Sphere1",
    TaskEffects = T.RT_1265,
    TaskId = 8520110
  },
  [8520111] = {
    TargetFilter = "BossAida_Skill23_Sphere2",
    TaskEffects = T.RT_1265,
    TaskId = 8520111
  },
  [8520112] = {
    TargetFilter = "BossAida_Skill23_Sphere3",
    TaskEffects = T.RT_1265,
    TaskId = 8520112
  },
  [8520113] = {
    TargetFilter = "BossAida_Skill23_Sphere4",
    TaskEffects = T.RT_1265,
    TaskId = 8520113
  },
  [8520114] = {
    TargetFilter = "BossAida_Skill23_Sphere5",
    TaskEffects = T.RT_1265,
    TaskId = 8520114
  },
  [8520115] = {
    TargetFilter = "BossAida_Skill23_Cylinder1",
    TaskEffects = T.RT_500,
    TaskId = 8520115
  },
  [8520116] = {
    TargetFilter = "BossAida_Skill23_Cylinder2",
    TaskEffects = T.RT_500,
    TaskId = 8520116
  },
  [8520117] = {
    TargetFilter = "BossAida_Skill23_Cylinder3",
    TaskEffects = T.RT_500,
    TaskId = 8520117
  },
  [8520118] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 0.04
      }
    },
    TaskId = 8520118
  },
  [8520119] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 852037,
        Function = "CreateSkillCreature",
        Rotation = {
          40,
          0,
          0
        }
      },
      [2] = {
        CreatureId = 852037,
        Function = "CreateSkillCreature",
        Rotation = T.RT_421
      },
      [3] = {
        CreatureId = 852037,
        Function = "CreateSkillCreature",
        Rotation = T.RT_422
      }
    },
    TaskId = 8520119
  },
  [8520120] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_513,
    TaskId = 8520120
  },
  [8520121] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 6000204, Function = "RemoveBuff"}
    },
    TaskId = 8520121
  },
  [8521001] = {
    NotifyName = T.RT_525,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1276,
    TaskId = 8521001
  },
  [8521002] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_360",
    TaskEffects = T.RT_1265,
    TaskId = 8521002
  },
  [8521003] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        FormationId = 852101,
        Function = "BossSPSaveLocs",
        SetSaveLocs = "Target"
      },
      [2] = {
        CreatureId = 852101,
        Function = "CreateSkillCreature",
        Location = T.RT_1292,
        UseRelativeOffset = true,
        UseSaveLoc = "Target1"
      },
      [3] = {
        CreatureId = 852101,
        Function = "CreateSkillCreature",
        Location = T.RT_1292,
        UseRelativeOffset = true,
        UseSaveLoc = "Target2"
      },
      [4] = {
        CreatureId = 852101,
        Function = "CreateSkillCreature",
        Location = T.RT_1292,
        UseRelativeOffset = true,
        UseSaveLoc = "Target3"
      },
      [5] = {
        CreatureId = 852101,
        Function = "CreateSkillCreature",
        Location = T.RT_1292,
        UseRelativeOffset = true,
        UseSaveLoc = "Target4"
      },
      [6] = {
        CreatureId = 852101,
        Function = "CreateSkillCreature",
        Location = T.RT_1292,
        UseRelativeOffset = true,
        UseSaveLoc = "Target5"
      }
    },
    TaskId = 8521003
  },
  [8521004] = {
    TargetFilter = "Mon_Cylinder_150_400_360",
    TaskEffects = T.RT_1294,
    TaskId = 8521004
  },
  [8521005] = {
    NotifyName = T.RT_1027,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1295,
    TaskId = 8521005
  },
  [8521006] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852102,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8521006
  },
  [8521007] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_110
    },
    TaskId = 8521007
  },
  [8521008] = {
    NotifyName = T.RT_1027,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1295,
    TaskId = 8521008
  },
  [8521009] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_300_200_180",
    TaskEffects = T.RT_1265,
    TaskId = 8521009
  },
  [8521010] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "EffectFunction",
        FunctionName = "RandomAreaLocation",
        Vars = {
          Distance = 200,
          MaxNum = 4,
          Radius = 500
        }
      },
      [2] = {
        CreatureId = 852103,
        Function = "CreateSkillCreature",
        Location = T.RT_1296,
        UseRelativeOffset = true,
        UseSaveLoc = "1"
      },
      [3] = {
        CreatureId = 852103,
        Function = "CreateSkillCreature",
        Location = T.RT_1296,
        UseRelativeOffset = true,
        UseSaveLoc = "2"
      },
      [4] = {
        CreatureId = 852103,
        Function = "CreateSkillCreature",
        Location = T.RT_1296,
        UseRelativeOffset = true,
        UseSaveLoc = "3"
      },
      [5] = {
        CreatureId = 852103,
        Function = "CreateSkillCreature",
        Location = T.RT_1296,
        UseRelativeOffset = true,
        UseSaveLoc = "4"
      }
    },
    TaskId = 8521010
  },
  [8521011] = {
    TargetFilter = "Mon_Cylinder_150_400_360",
    TaskEffects = T.RT_1294,
    TaskId = 8521011
  },
  [8522001] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossTuisheng_Skill01_Cylinder1",
    TaskEffects = T.RT_500,
    TaskId = 8522001
  },
  [8522002] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossTuisheng_Skill02_Cylinder1",
    TaskEffects = T.RT_1298,
    TaskId = 8522002
  },
  [8522003] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 852201,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522003
  },
  [8522004] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_500,
    TaskId = 8522004
  },
  [8522005] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_400_200_240",
    TaskEffects = T.RT_500,
    TaskId = 8522005
  },
  [8522006] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = T.RT_20,
    TaskId = 8522006
  },
  [8522007] = {
    NotifyName = T.RT_12,
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = T.RT_1265,
    TaskId = 8522007
  },
  [8522008] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852202,
        Function = "CreateSkillCreature"
      },
      [2] = {
        Function = "EffectFunction",
        FunctionName = "Mon_SetBool",
        Vars = {
          BoolKey = "BossTuisheng_Skill04CreatureHitResult",
          BoolValue = false
        }
      }
    },
    TaskId = 8522008
  },
  [8522009] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 852201,
        Function = "AddBuff",
        LastTime = 3
      },
      [2] = T.RT_3,
      [3] = {
        Function = "EffectFunction",
        FunctionName = "Mon_SetBool",
        Vars = {
          BoolKey = "BossTuisheng_Skill04CreatureHitResult",
          BoolValue = true
        }
      },
      [4] = T.RT_1205
    },
    TaskId = 8522009
  },
  [8522010] = {
    TaskEffects = {
      [1] = T.RT_1205
    },
    TaskId = 8522010
  },
  [8522011] = {
    NotifyName = T.RT_12,
    TaskEffects = {
      [1] = {
        CreatureId = 852203,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522011
  },
  [8522012] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        Tag = "BossTuishengSkill04",
        TargetType = "Target"
      }
    },
    TaskId = 8522012
  },
  [8522013] = {
    NotifyName = T.RT_9,
    TaskEffects = {
      [1] = {
        CreatureId = 852204,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522013
  },
  [8522014] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        Tag = "BossTuishengSkill05",
        TargetType = "Target"
      }
    },
    TaskId = 8522014
  },
  [8522015] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852205,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522015
  },
  [8522016] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1276,
    TaskId = 8522016
  },
  [8522017] = {
    TaskEffects = {
      [1] = {
        CreatureId = 852206,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_1205
    },
    TaskId = 8522017
  },
  [8522018] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1276,
    TaskId = 8522018
  },
  [8522019] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Cylinder_400_200_180",
    TaskEffects = T.RT_500,
    TaskId = 8522019
  },
  [8522020] = {
    NotifyName = T.RT_9,
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = T.RT_500,
    TaskId = 8522020
  },
  [8522021] = {
    NotifyName = T.RT_2,
    TaskEffects = {
      [1] = {
        CreatureId = 852207,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522021
  },
  [8522022] = {
    TargetFilter = "Mon_Cylinder_500_400_360",
    TaskEffects = T.RT_1300,
    TaskId = 8522022
  },
  [8522023] = {
    TargetFilter = "Mon_Cylinder_800_400_360",
    TaskEffects = T.RT_1276,
    TaskId = 8522023
  },
  [8522024] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossTuisheng_Skill02_Cylinder1",
    TaskEffects = T.RT_1298,
    TaskId = 8522024
  },
  [8522025] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852208,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8522025
  },
  [8522026] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852208,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8522026
  },
  [8522027] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_500,
    TaskId = 8522027
  },
  [8523001] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJishi_Attack01",
    TaskEffects = T.RT_500,
    TaskId = 8523001
  },
  [8523002] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossJishi_Attack01",
    TaskEffects = T.RT_500,
    TaskId = 8523002
  },
  [8523003] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossJishi_Attack01",
    TaskEffects = T.RT_1300,
    TaskId = 8523003
  },
  [8523004] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJishi_Skill02",
    TaskEffects = T.RT_500,
    TaskId = 8523004
  },
  [8523005] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Skill03Loc",
        TargetType = "Target"
      }
    },
    TaskId = 8523005
  },
  [8523006] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852301,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8523006
  },
  [8523007] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852301,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8523007
  },
  [8523008] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1301,
    TaskId = 8523008
  },
  [8523009] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "Skill04Loc",
        TargetType = "Target"
      }
    },
    TaskId = 8523009
  },
  [8523010] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossJishi_Attack02",
    TaskEffects = T.RT_1265,
    TaskId = 8523010
  },
  [8523013] = {
    NotifyName = T.RT_2,
    TargetFilter = "BossJishi_Attack02",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_4,
      [3] = T.RT_5,
      [4] = T.RT_10
    },
    TaskId = 8523013
  },
  [8523014] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossJishi_Attack02",
    TaskEffects = T.RT_1301,
    TaskId = 8523014
  },
  [8523015] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852303,
        Function = "CreateSkillCreature",
        Location = T.RT_414
      }
    },
    TaskId = 8523015
  },
  [8523016] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852303,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8523016
  },
  [8523017] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        AttrRates = {
          ATK = 0.3,
          DEF = 0,
          MaxES = 0.5,
          MaxHp = 0.5
        },
        FixLocation = true,
        FixLocationNav = 1,
        FixLocationZ = 0,
        FormationId = 852301,
        Function = "CreateUnit",
        MaxSummonCount = 3,
        SingleSummonCount = 3,
        UnitId = 8523002,
        UnitType = "Monster"
      }
    },
    TaskId = 8523017
  },
  [8523018] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        Function = "SaveLoc",
        IsOnGround = true,
        Tag = "SumSkill01Loc",
        TargetType = "Target"
      }
    },
    TaskId = 8523018
  },
  [8523019] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852304,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8523019
  },
  [8523020] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852304,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8523020
  },
  [8523021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 852302, Function = "PlayFX"}
    },
    TaskId = 8523021
  },
  [8523025] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852309,
        Function = "CreateSkillCreature",
        Location = {
          60,
          60,
          100
        }
      }
    },
    TaskId = 8523025
  },
  [8523026] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852309,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8523026
  },
  [8523027] = {
    TargetFilter = "Mon_Sphere_50_360",
    TaskEffects = {
      [1] = T.RT_33,
      [2] = {
        FXId = 852306,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 8523027
  },
  [8523028] = {
    NotifyName = T.RT_12,
    TargetFilter = "BossJishi_Attack01",
    TaskEffects = T.RT_500,
    TaskId = 8523028
  },
  [8523029] = {
    NotifyName = T.RT_13,
    TargetFilter = "BossJishi_Attack01",
    TaskEffects = T.RT_1300,
    TaskId = 8523029
  },
  [8523030] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852310,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8523030
  },
  [8523031] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852310,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8523031
  },
  [8523032] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_7,
      [2] = T.RT_4,
      [3] = T.RT_10
    },
    TaskId = 8523032
  },
  [8524001] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852401,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          0,
          100
        }
      },
      [2] = {
        CreatureId = 852401,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          0,
          300
        }
      },
      [3] = {
        CreatureId = 852401,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          0,
          500
        }
      },
      [4] = {
        CreatureId = 852402,
        Function = "CreateSkillCreature",
        Location = {
          200,
          0,
          100
        }
      },
      [5] = {
        CreatureId = 852402,
        Function = "CreateSkillCreature",
        Location = {
          200,
          0,
          300
        }
      },
      [6] = {
        CreatureId = 852402,
        Function = "CreateSkillCreature",
        Location = {
          200,
          0,
          500
        }
      }
    },
    TaskId = 8524001
  },
  [8524002] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1303,
    TaskId = 8524002
  },
  [8524003] = {
    TaskEffects = {
      [1] = {
        FXId = 852402,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 8524003
  },
  [8524004] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852403,
        Function = "CreateSkillCreature",
        Location = T.RT_36
      }
    },
    TaskId = 8524004
  },
  [8524005] = {
    NotifyName = T.RT_2,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1304,
      [2] = T.RT_1306,
      [3] = {
        CreatureId = 852404,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc2"
      },
      [4] = {
        CreatureId = 852404,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc3"
      },
      [5] = {
        CreatureId = 852404,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc4"
      }
    },
    TaskId = 8524005
  },
  [8524006] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852405,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8524006
  },
  [8524007] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1302
    },
    TaskId = 8524007
  },
  [8524008] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1307,
    TaskId = 8524008
  },
  [8524009] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_1302,
      [3] = T.RT_684
    },
    TaskId = 8524009
  },
  [8524010] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          -400,
          100
        }
      }
    },
    TaskId = 8524010
  },
  [8524011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_3,
      [2] = T.RT_10,
      [3] = {FXId = 852406, Function = "PlayFX"}
    },
    TaskId = 8524011
  },
  [8524012] = {
    TaskEffects = {
      [1] = {
        FXId = 852406,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 8524012
  },
  [8524013] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          -400,
          300
        }
      }
    },
    TaskId = 8524013
  },
  [8524014] = {
    NotifyName = T.RT_12,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          -200,
          -400,
          500
        }
      }
    },
    TaskId = 8524014
  },
  [8524015] = {
    NotifyName = T.RT_13,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          200,
          -400,
          500
        }
      }
    },
    TaskId = 8524015
  },
  [8524016] = {
    NotifyName = T.RT_404,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          200,
          -400,
          300
        }
      }
    },
    TaskId = 8524016
  },
  [8524017] = {
    NotifyName = T.RT_507,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852406,
        Function = "CreateSkillCreature",
        Location = {
          200,
          -400,
          100
        }
      }
    },
    TaskId = 8524017
  },
  [8524018] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852407,
        Function = "CreateSkillCreature",
        Location = T.RT_239
      }
    },
    TaskId = 8524018
  },
  [8524019] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_1303,
    TaskId = 8524019
  },
  [8524020] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_1302
    },
    TaskId = 8524020
  },
  [8524021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 852401
      }
    },
    TaskId = 8524021
  },
  [8524022] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 852402
      }
    },
    TaskId = 8524022
  },
  [8524023] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852408,
        Function = "CreateSkillCreature",
        UseBattlePointId = 852403
      }
    },
    TaskId = 8524023
  },
  [8524024] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 852408,
        Function = "RemoveSkillCreature"
      }
    },
    TaskId = 8524024
  },
  [8524025] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 852401,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 8524025
  },
  [8524026] = {
    NotifyName = T.RT_2,
    TargetFilter = "Mon_Sphere_2500_360",
    TaskEffects = {
      [1] = T.RT_579,
      [2] = T.RT_1302,
      [3] = T.RT_1299
    },
    TaskId = 8524026
  },
  [8524027] = {
    NotifyName = T.RT_9,
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_1304,
      [2] = T.RT_1306,
      [3] = {
        CreatureId = 852409,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc2"
      },
      [4] = {
        CreatureId = 852410,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc3"
      },
      [5] = {
        CreatureId = 852411,
        Function = "CreateSkillCreature",
        Location = T.RT_1305,
        UseSaveLoc = "Skill03Loc4"
      }
    },
    TaskId = 8524027
  },
  [8524028] = {
    NotifyName = T.RT_9,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852412,
        Function = "CreateSkillCreature",
        Location = T.RT_239
      }
    },
    TaskId = 8524028
  },
  [8524029] = {
    NotifyName = T.RT_2,
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        CreatureId = 852413,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 8524029
  },
  [8524030] = {
    NotifyName = T.RT_9,
    TargetFilter = "BossHengmeng_Skill08Cylinder",
    TaskEffects = T.RT_1307,
    TaskId = 8524030
  },
  [101011041] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_44,
    TaskId = 101011041
  },
  [101011061] = {
    TargetFilter = "Rou_10101201_Debuff",
    TaskEffects = {
      [1] = {
        BuffId = 10101101,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 101011061
  },
  [101011062] = {
    TargetFilter = "Rou_10101201_Debuff",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        BuffId = 10101102,
        Function = "AddBuff",
        LastTime = 5
      }
    },
    TaskId = 101011062
  },
  [101011063] = {
    TargetFilter = "Rou_10101201_Debuff",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        BuffId = 10101103,
        Function = "AddBuff",
        LastTime = 10
      }
    },
    TaskId = 101011063
  },
  [101012051] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_44,
    TaskId = 101012051
  },
  [101013021] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {FXId = 10101302, Function = "PlayFX"},
      [2] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_66,
        Delay = 0.45,
        Function = "Damage",
        Rate = "#1"
      }
    },
    TaskId = 101013021
  },
  [101019011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {FXId = 10101901, Function = "PlayFX"},
      [2] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_66,
        Delay = 0.45,
        Function = "Damage",
        Rate = 5.63
      }
    },
    TaskId = 101019011
  },
  [101021031] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_80,
      [2] = T.RT_81
    },
    TaskId = 101021031
  },
  [101021041] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_83,
    TaskId = 101021041
  },
  [101021061] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 3,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 9901102,
        UnitType = "Monster",
        UseSaveLoc = "10102106"
      }
    },
    TaskId = 101021061
  },
  [101022041] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_94,
    TaskId = 101022041
  },
  [101029021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        LifeTime = 2.5,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 9901101,
        UnitType = "Monster",
        UseSaveLoc = "10102902"
      }
    },
    TaskId = 101029021
  },
  [101029022] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {"RouB102"},
        Delay = 0.2,
        Function = "Damage",
        Rate = 13.5
      }
    },
    TaskId = 101029022
  },
  [101029023] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        Function = "Heal",
        Rate = 0.03
      },
      [2] = T.RT_95,
      [3] = {Function = "AddSp", SpChange = 10},
      [4] = T.RT_96,
      [5] = {Function = "AddBullet", Value = 3}
    },
    TaskId = 101029023
  },
  [101029031] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_99,
      [2] = T.RT_100
    },
    TaskId = 101029031
  },
  [101029032] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_106,
    TaskId = 101029032
  },
  [101029033] = {
    TargetFilter = "Char_Sphere_Small",
    TaskEffects = T.RT_106,
    TaskId = 101029033
  },
  [101029034] = {
    TargetFilter = "ShootingTargets",
    TaskEffects = {
      [1] = T.RT_99,
      [2] = {
        AimSkeletal = "hit1",
        CreatureId = 1010201,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97,
        Rotation = {
          0,
          10,
          50
        }
      },
      [3] = {
        AimSkeletal = "hit1",
        CreatureId = 1010201,
        Direction = "Camera",
        Function = "CreateSkillCreature",
        Location = T.RT_97,
        Rotation = {
          0,
          -10,
          50
        }
      },
      [4] = T.RT_100
    },
    TaskId = 101029034
  },
  [101031041] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_94,
    TaskId = 101031041
  },
  [101031051] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxES",
        BaseChar = "Target",
        Function = "AddEnergyShield",
        Rate = "#1"
      }
    },
    TaskId = 101031051
  },
  [101039001] = {
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {"Skill", "RouB103"},
        Delay = 0.2,
        Function = "Damage",
        Rate = 8.1
      },
      [2] = {
        BaseChar = "Self",
        FXId = 10103102,
        Function = "PlayFX",
        IsAttached = true
      },
      [3] = {
        Delay = 0.2,
        FXId = 10103103,
        Function = "PlayFX"
      },
      [4] = {
        CauseHit = "LightHit",
        Delay = 0.2,
        Function = "CutToughness",
        Value = 20
      }
    },
    TaskId = 101039001
  },
  [101041011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationEndZ = -6000,
        FixLocationStartZ = 0,
        FixLocationZ = 0,
        FormationId = 10104900,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 9901111,
        UnitType = "Monster"
      }
    },
    TaskId = 101041011
  },
  [101041012] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationEndZ = -6000,
        FixLocationStartZ = 0,
        FixLocationZ = 0,
        FormationId = 10104900,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 10,
        SingleSummonCount = 1,
        UnitId = 9901112,
        UnitType = "Monster"
      }
    },
    TaskId = 101041012
  },
  [101041013] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Condition = 10104101,
        FixLocation = true,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 9901113,
        UnitType = "Monster",
        UseSaveLoc = "Rou104Leaf"
      }
    },
    TaskId = 101041013
  },
  [101041022] = {
    TargetFilter = "Rou_10104_Sphere_Level02",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_107,
        Function = "Damage",
        Rate = 6
      },
      [2] = T.RT_108,
      [3] = T.RT_109
    },
    TaskId = 101041022
  },
  [101041024] = {
    TargetFilter = "Rou_10104_Sphere_Level02",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_107,
        Function = "Damage",
        Rate = 10
      },
      [2] = T.RT_110,
      [3] = T.RT_109
    },
    TaskId = 101041024
  },
  [101041051] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_44,
    TaskId = 101041051
  },
  [101041061] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_94,
    TaskId = 101041061
  },
  [101042051] = {
    TargetFilter = "Rou_10104_Sphere_Level02",
    TaskEffects = {
      [1] = T.RT_111
    },
    TaskId = 101042051
  },
  [101043031] = {
    TargetFilter = "Rou_10104_Sphere_Level02",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_107,
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_108,
      [3] = T.RT_109
    },
    TaskId = 101043031
  },
  [101049001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "HpConsume",
        Function = "Damage",
        Rate = 1
      }
    },
    TaskId = 101049001
  },
  [101049011] = {
    TargetFilter = "Rou_10104_Cylinder_1000_Fr",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        BaseChar = "Target",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.05
      }
    },
    TaskId = 101049011
  },
  [101049012] = {
    TargetFilter = "Rou_10104_Cylinder_1000",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        Function = "Damage",
        Rate = 6.5
      },
      [2] = T.RT_112
    },
    TaskId = 101049012
  },
  [101051021] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_113,
      [2] = T.RT_113,
      [3] = T.RT_113
    },
    TaskId = 101051021
  },
  [101051022] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_115,
      [2] = T.RT_116
    },
    TaskId = 101051022
  },
  [101051061] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 10105106,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101051061
  },
  [101051062] = {
    TargetFilter = "Rou_10105_Cylinder_400",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_114,
        Function = "Damage",
        Rate = 4
      },
      [2] = T.RT_108,
      [3] = {FXId = 10105902, Function = "PlayFX"}
    },
    TaskId = 101051062
  },
  [101052051] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 10105205,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101052051
  },
  [101052052] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_115,
      [2] = {
        CauseHit = "HitFly_XY400Z400_F",
        Function = "CutToughness",
        Value = 200
      },
      [3] = T.RT_116
    },
    TaskId = 101052052
  },
  [101053023] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        Function = "CreateUnit",
        LifeTime = 5,
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 10106002,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 101053023
  },
  [101059041] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = {
          "RouB105Group4"
        },
        Function = "Damage",
        Rate = 1
      }
    },
    TaskId = 101059041
  },
  [101061011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        AttrRates = T.RT_84,
        Function = "CreateUnit",
        MaxSummonCount = 5,
        SingleSummonCount = 1,
        UnitId = 10106001,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 101061011
  },
  [101061012] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_118,
      [2] = T.RT_119,
      [3] = T.RT_120,
      [4] = T.RT_121
    },
    TaskId = 101061012
  },
  [101061013] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_121,
      [2] = T.RT_122
    },
    TaskId = 101061013
  },
  [101061014] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010602,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101061014
  },
  [101061015] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010603,
        Function = "CreateSkillCreature",
        UseSaveLoc = "SubInsectLoc"
      },
      [2] = {
        ATKBase = "ATK",
        CreatureId = 1010604,
        Function = "CreateSkillCreature",
        UseSaveLoc = "SubInsectLoc"
      },
      [3] = {
        ATKBase = "ATK",
        CreatureId = 1010605,
        Function = "CreateSkillCreature",
        UseSaveLoc = "SubInsectLoc"
      }
    },
    TaskId = 101061015
  },
  [101061016] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010604,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101061016
  },
  [101061017] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010605,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101061017
  },
  [101061018] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010606,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101061018
  },
  [101061019] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Rou_10106_Group1Damage",
    TaskEffects = {
      [1] = T.RT_118,
      [2] = T.RT_119,
      [3] = T.RT_120,
      [4] = T.RT_123
    },
    TaskId = 101061019
  },
  [101061020] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Rou_10106_Group1Damage",
    TaskEffects = {
      [1] = T.RT_118,
      [2] = T.RT_120
    },
    TaskId = 101061020
  },
  [101061021] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010601,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101061021
  },
  [101061022] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Rou_10106_Group2Damage",
    TaskEffects = {
      [1] = T.RT_124,
      [2] = T.RT_119,
      [3] = T.RT_120,
      [4] = T.RT_123
    },
    TaskId = 101061022
  },
  [101061023] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Rou_10106_Group2Damage",
    TaskEffects = {
      [1] = T.RT_124,
      [2] = T.RT_120
    },
    TaskId = 101061023
  },
  [101061024] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 10106105,
        Function = "PlayFX",
        NormalToHit = true
      }
    },
    TaskId = 101061024
  },
  [101071061] = {
    SkillEffectSourceFlag = "RootSource",
    TargetFilter = "Rou_101071061",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = {"RouB107106"},
        DamageType = "Default",
        Function = "Damage",
        Rate = "#1"
      },
      [2] = T.RT_120
    },
    TaskId = 101071061
  },
  [101071062] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 1010701,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 101071062
  },
  [101072051] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_83,
    TaskId = 101072051
  },
  [101079301] = {
    TargetFilter = "Rou_10107_Group3Damage",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Damage",
        Rate = 0.4
      },
      [2] = T.RT_125
    },
    TaskId = 101079301
  },
  [101079302] = {
    TargetFilter = "Rou_10107_Group3Damage",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Damage",
        Rate = 0.533
      },
      [2] = T.RT_125
    },
    TaskId = 101079302
  },
  [101079303] = {
    TargetFilter = "Rou_10107_Group3Damage",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Damage",
        Rate = 0.667
      },
      [2] = T.RT_125
    },
    TaskId = 101079303
  },
  [101079304] = {
    TargetFilter = "Rou_10107_Group3Damage",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Damage",
        Rate = 0.8
      },
      [2] = T.RT_125
    },
    TaskId = 101079304
  },
  [101999991] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        DamageType = "TrueDamage",
        Function = "Heal",
        Value = 100
      },
      [2] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        Function = "Heal",
        Rate = 0.25
      },
      [3] = T.RT_95
    },
    TaskId = 101999991
  },
  [201020011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "Default",
        Function = "Heal",
        Rate = 0.02
      }
    },
    TaskId = 201020011
  },
  [201020012] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_349,
    TaskId = 201020012
  },
  [201040011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = T.RT_230
    },
    TaskId = 201040011
  },
  [201050011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "AddSp", SpChange = 50}
    },
    TaskId = 201050011
  },
  [201210011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        DamageType = "TrueDamage",
        Function = "Damage",
        Value = 500
      }
    },
    TaskId = 201210011
  },
  [201300011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321
      },
      [2] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = T.RT_174
      },
      [3] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = T.RT_358
      },
      [4] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = T.RT_76
      },
      [5] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = {
          0,
          -90,
          0
        }
      },
      [6] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = T.RT_359
      },
      [7] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = T.RT_360
      },
      [8] = {
        CreatureId = 20130001,
        Function = "CreateSkillCreature",
        Location = T.RT_321,
        Rotation = {
          0,
          -180,
          0
        }
      }
    },
    TaskId = 201300011
  },
  [201300012] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Light",
        Function = "Damage",
        Rate = 5
      },
      [2] = T.RT_165
    },
    TaskId = 201300012
  },
  [201310011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 20131001,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = {
          400,
          400,
          0
        }
      },
      [2] = {
        CreatureId = 20131001,
        Delay = 0.2,
        Function = "CreateSkillCreature",
        Location = {
          -400,
          400,
          0
        }
      },
      [3] = {
        CreatureId = 20131001,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        Location = {
          -400,
          -400,
          0
        }
      },
      [4] = {
        CreatureId = 20131001,
        Delay = 0.4,
        Function = "CreateSkillCreature",
        Location = {
          400,
          -400,
          0
        }
      }
    },
    TaskId = 201310011
  },
  [201310012] = {
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Dark",
        Function = "Damage",
        Rate = 9
      },
      [2] = {
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 80
      }
    },
    TaskId = 201310012
  },
  [201320011] = {
    TaskEffects = T.RT_363,
    TaskId = 201320011
  },
  [201320012] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Wind",
        Function = "Damage",
        Rate = 5
      },
      [2] = T.RT_364,
      [3] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 10
      }
    },
    TaskId = 201320012
  },
  [201320013] = {
    TaskEffects = T.RT_363,
    TaskId = 201320013
  },
  [201330011] = {
    TargetFilter = "Char_Cylinder_Large_Trgt",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Water",
        Function = "Damage",
        Rate = 13.5
      },
      [2] = {FXId = 210121, Function = "PlayFX"},
      [3] = {
        BossValue = 100,
        CauseHit = "HitFly_XY0Z500",
        Function = "CutToughness",
        Value = 50
      }
    },
    TaskId = 201330011
  },
  [201340011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 20134001,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      },
      [2] = {
        CreatureId = 20134002,
        Direction = "Camera",
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 201340011
  },
  [201340012] = {
    TargetFilter = "Rou_20134_Cylinder_XLarge120",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Fire",
        Function = "Damage",
        Rate = 7
      },
      [2] = T.RT_129
    },
    TaskId = 201340012
  },
  [201350011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 20135001,
        Function = "CreateSkillCreature",
        Location = {
          0,
          500,
          0
        }
      },
      [2] = {
        CreatureId = 20135001,
        Function = "CreateSkillCreature",
        Location = {
          300,
          300,
          0
        }
      },
      [3] = {
        CreatureId = 20135001,
        Function = "CreateSkillCreature",
        Location = {
          -300,
          300,
          0
        }
      }
    },
    TaskId = 201350011
  },
  [201350012] = {
    TargetFilter = "Char_Cylinder_Middle",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Thunder",
        Function = "Damage",
        Rate = 3.5
      },
      [2] = {FXId = 20135001, Function = "PlayFX"},
      [3] = {
        BossValue = 10,
        CauseHit = "HitFly_XY200Z300_F",
        Function = "CutToughness",
        Value = 15
      }
    },
    TaskId = 201350012
  },
  [201560011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {Function = "AddSp", SpChange = 3}
    },
    TaskId = 201560011
  },
  [201720011] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        Function = "AddEnergyShield",
        IsOverShield = 1,
        Rate = 0.1
      }
    },
    TaskId = 201720011
  },
  [201810011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_365,
        DamageType = "Fire",
        Function = "Damage",
        Rate = 0.2
      }
    },
    TaskId = 201810011
  },
  [201810012] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_367,
    TaskId = 201810012
  },
  [201820011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_365,
        DamageType = "Water",
        Function = "Damage",
        Rate = 0.2
      }
    },
    TaskId = 201820011
  },
  [201820012] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_367,
    TaskId = 201820012
  },
  [201830011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_365,
        DamageType = "Wind",
        Function = "Damage",
        Rate = 0.2
      }
    },
    TaskId = 201830011
  },
  [201830012] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_367,
    TaskId = 201830012
  },
  [201840011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageTag = T.RT_365,
        DamageType = "Thunder",
        Function = "Damage",
        Rate = 0.2
      }
    },
    TaskId = 201840011
  },
  [201840012] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_367,
    TaskId = 201840012
  },
  [301020041] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        ATKBase = "ATK",
        CreatureId = 30102004,
        Function = "CreateSkillCreature",
        Location = T.RT_496
      }
    },
    TaskId = 301020041
  },
  [301020042] = {
    TargetFilter = "Mon_Sphere_300_360",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_10,
      [3] = {FXId = 30102042, Function = "PlayFX"}
    },
    TaskId = 301020042
  },
  [401010001] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ShootLoopStart",
        PassiveEffectId = 40101001
      }
    },
    TaskId = 401010001
  },
  [401010002] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010102,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 401010002
  },
  [401010003] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010101,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_558
    },
    TaskId = 401010003
  },
  [401010004] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "TrueDamage",
        Function = "Damage",
        Rate = 50
      },
      [2] = T.RT_559,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 401010004
  },
  [401010005] = {
    HatredIncrement = 40,
    TargetFilter = "Char_Sphere_large",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        Function = "Damage",
        Rate = 50
      },
      [2] = T.RT_561,
      [3] = T.RT_560,
      [4] = T.RT_175
    },
    TaskId = 401010005
  },
  [401010006] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_562,
      [2] = T.RT_563,
      [3] = T.RT_564
    },
    TaskId = 401010006
  },
  [401010007] = {
    TargetFilter = "Self",
    TaskEffects = T.RT_565,
    TaskId = 401010007
  },
  [401010008] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010103,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401010008
  },
  [401010009] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010104,
        Direction = "Camera",
        Function = "CreateRayCreature",
        RayEndLoc = true
      }
    },
    TaskId = 401010009
  },
  [401010010] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_562,
      [2] = T.RT_563,
      [3] = T.RT_564,
      [4] = {Function = "PlaySE", SEId = 40101001}
    },
    TaskId = 401010010
  },
  [401010011] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 4010104,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "End",
        UseSaveLoc = "Start"
      }
    },
    TaskId = 401010011
  },
  [401010012] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 40101002,
        Function = "AddBuff",
        LastTime = 1
      }
    },
    TaskId = 401010012
  },
  [401020001] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010201,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020001
  },
  [401020002] = {
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = T.RT_569,
    TaskId = 401020002
  },
  [401020003] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010202,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 401020003
  },
  [401020004] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_571,
    TaskId = 401020004
  },
  [401020005] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_571,
    TaskId = 401020005
  },
  [401020006] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010203,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 401020006
  },
  [401020007] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_573,
    TaskId = 401020007
  },
  [401020008] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_573,
    TaskId = 401020008
  },
  [401020009] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010105,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 401020009
  },
  [401020010] = {
    EffectExecuteTiming = "Enter",
    TaskEffects = {
      [1] = {
        Function = "ExecutePassiveFunction",
        FunctionName = "ShootLoopStart",
        PassiveEffectId = 40102001
      }
    },
    TaskId = 401020010
  },
  [401020011] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010204,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020011
  },
  [401020012] = {
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = T.RT_569,
    TaskId = 401020012
  },
  [401020013] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010205,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020013
  },
  [401020014] = {
    TargetFilter = "Mon_Sphere_600_360",
    TaskEffects = {
      [1] = T.RT_566,
      [2] = {
        FXId = 40101003,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      },
      [3] = T.RT_567,
      [4] = T.RT_574
    },
    TaskId = 401020014
  },
  [401020015] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = T.RT_575,
      [2] = T.RT_575
    },
    TaskId = 401020015
  },
  [401020016] = {
    TargetFilter = "LaserTarget",
    TaskEffects = {
      [1] = T.RT_576,
      [2] = T.RT_576
    },
    TaskId = 401020016
  },
  [401020017] = {
    TargetFilter = "Target",
    TaskEffects = T.RT_571,
    TaskId = 401020017
  },
  [401020018] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Default",
        Function = "Damage",
        Rate = 4.3
      },
      [2] = T.RT_563
    },
    TaskId = 401020018
  },
  [401020024] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreatureId = 4010209,
        Function = "CreateSkillCreature",
        UseSaveLoc = "Onground"
      }
    },
    TaskId = 401020024
  },
  [401020025] = {
    TargetFilter = "AlmostAllOtFr",
    TaskEffects = {
      [1] = {
        BuffId = 40101018,
        Function = "AddBuff",
        LastTime = 4
      }
    },
    TaskId = 401020025
  },
  [401020026] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010106,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100,
      [3] = T.RT_557
    },
    TaskId = 401020026
  },
  [401020027] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010206,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020027
  },
  [401020028] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = T.RT_578,
    TaskId = 401020028
  },
  [401020029] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010207,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020029
  },
  [401020030] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = T.RT_578,
    TaskId = 401020030
  },
  [401020031] = {
    TaskEffects = {
      [1] = {
        CreatureId = 4010208,
        Function = "CreateSkillCreature"
      },
      [2] = T.RT_100
    },
    TaskId = 401020031
  },
  [401020032] = {
    TargetFilter = "Mon_Sphere_800_360",
    TaskEffects = {
      [1] = T.RT_566,
      [2] = {
        FXId = 40101008,
        Function = "PlayFX",
        Overlap = true
      },
      [3] = T.RT_567,
      [4] = T.RT_574
    },
    TaskId = 401020032
  },
  [401020033] = {
    TargetFilter = "Mon_Cylinder_400_200_360",
    TaskEffects = T.RT_580,
    TaskId = 401020033
  },
  [401020034] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 5,
        UnitId = 40101001,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 401020034
  },
  [500000001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageType = "TrueDamage",
        DefaultHealFX = 0,
        Function = "Heal",
        Rate = 0.3
      }
    },
    TaskId = 500000001
  },
  [500000301] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000301,
        Function = "AddBuff",
        LastTime = 60
      }
    },
    TaskId = 500000301
  },
  [500000302] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000302,
        Function = "AddBuff",
        LastTime = 15
      }
    },
    TaskId = 500000302
  },
  [500000303] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000303,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 500000303
  },
  [500000304] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BuffId = 5000304,
        Function = "AddBuff",
        LastTime = 25
      }
    },
    TaskId = 500000304
  },
  [500000305] = {
    TargetFilter = "Silverbox",
    TaskEffects = {
      [1] = {
        CreateWithoutTarget = false,
        CreatureId = 500000305,
        Function = "CreateSkillCreature",
        RandomVelocityX = T.RT_386,
        RandomVelocityY = T.RT_386,
        RandomVelocityZ = T.RT_387
      }
    },
    TaskId = 500000305
  },
  [500000306] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK_Char",
        DamageType = "Default",
        Function = "Damage",
        Rate = 25
      },
      [2] = T.RT_617
    },
    TaskId = 500000306
  },
  [500000307] = {
    TaskEffects = {
      [1] = {
        FXId = 5000303,
        Function = "PlayFX",
        IsAttached = true,
        IsEffectCreature = true
      },
      [2] = {
        FXId = 5000304,
        Function = "PlayFX",
        IsAttached = true,
        IsEffectCreature = true
      },
      [3] = {
        FXId = 5000305,
        Function = "PlayFX",
        IsAttached = true,
        IsEffectCreature = true
      }
    },
    TaskId = 500000307
  },
  [500000309] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_618
    },
    TaskId = 500000309
  },
  [500000310] = {
    TargetFilter = "Silverbox_03",
    TaskEffects = {
      [1] = {
        CreateWithoutTarget = false,
        CreatureId = 500000301,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 500000310
  },
  [500000311] = {
    TargetFilter = "Silverbox_03",
    TaskEffects = {
      [1] = {
        CreateWithoutTarget = false,
        CreatureId = 500000302,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 500000311
  },
  [500000312] = {
    TargetFilter = "Silverbox_03",
    TaskEffects = {
      [1] = {
        CreateWithoutTarget = false,
        CreatureId = 500000303,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 500000312
  },
  [500000401] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        CreateWithoutTarget = false,
        CreatureId = 500000401,
        Function = "CreateSkillCreature",
        RandomVelocityX = T.RT_619,
        RandomVelocityY = T.RT_619,
        RandomVelocityZ = {400, 400}
      }
    },
    TaskId = 500000401
  },
  [500000402] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_618,
      [2] = T.RT_617
    },
    TaskId = 500000402
  },
  [500000403] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_16,
      [2] = T.RT_620
    },
    TaskId = 500000403
  },
  [500000404] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageType = "EsDamage",
        Function = "Damage",
        Rate = 5,
        Value = 10
      }
    },
    TaskId = 500000404
  },
  [600000101] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = {
        AimSkeletal = "spine_03",
        CreatureId = 600000101,
        Function = "CreateSkillCreature"
      },
      [2] = {Function = "PlaySE", SEId = 700112}
    },
    TaskId = 600000101
  },
  [600000102] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_654,
      [2] = {
        BuffId = 6000102,
        Function = "AddBuff",
        LastTime = 3
      },
      [3] = {
        FXId = 600003,
        Function = "PlayFX",
        Overlap = true
      }
    },
    TaskId = 600000102
  },
  [600000103] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000102,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000103
  },
  [600000104] = {
    TaskEffects = {
      [1] = {
        FXId = 600003,
        Function = "PlayFX",
        NormalToHit = true,
        Overlap = true
      }
    },
    TaskId = 600000104
  },
  [600000105] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000104,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000105
  },
  [600000201] = {
    TargetFilter = "Mon_Sphere_400_360_NoMch",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = {
          "PhantomAvoid",
          "Burst"
        },
        Function = "Damage",
        Rate = 0.65
      },
      [2] = T.RT_35,
      [3] = T.RT_655
    },
    TaskId = 600000201
  },
  [600000301] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreateDelay = 3,
        FixLocation = true,
        FixLocationZ = 0,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 15,
        SaveLocTag = "Strong",
        SaveToSaveLoc = 1,
        SingleSummonCount = 1,
        UnitId = 900301,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 600000301
  },
  [600000302] = {
    TargetFilter = "Mon_Cylinder_500_40_360_NoMch",
    TaskEffects = {
      [1] = {
        BuffId = 6000107,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 600000302
  },
  [600000401] = {
    TaskEffects = {
      [1] = {
        BoneName = "spine_03",
        DanmakuTemplateId = 600000401,
        Duration = 1,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 600000401
  },
  [600000402] = {
    TargetFilter = "Mon_Sphere_200_360_NoMch",
    TaskEffects = {
      [1] = T.RT_654,
      [2] = T.RT_656,
      [3] = T.RT_121
    },
    TaskId = 600000402
  },
  [600000403] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000404,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000403
  },
  [600000404] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000405,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000404
  },
  [600000501] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreateDelay = 2,
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 6000005,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 3,
        SaveLocTag = "Strong",
        SaveToSaveLoc = 1,
        SingleSummonCount = 3,
        UnitId = 900501,
        UnitType = "MechanismSummon"
      },
      [2] = {
        CreatureId = 600000501,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Strong1"
      },
      [3] = {
        CreatureId = 600000501,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Strong2"
      },
      [4] = {
        CreatureId = 600000501,
        Function = "CreateSkillCreature",
        SetSavelocAsTarget = "Strong3"
      },
      [5] = {Function = "PlaySE", SEId = 700123}
    },
    TaskId = 600000501
  },
  [600000502] = {
    TargetFilter = "Mon_Cylinder_300_40_360_NoMch",
    TaskEffects = {
      [1] = {
        BuffId = 6000109,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 600000502
  },
  [600000503] = {
    TargetFilter = "Mon_Cylinder_300_40_360_FrNoMch",
    TaskEffects = {
      [1] = {
        BuffId = 6000111,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 600000503
  },
  [600000504] = {
    TaskEffects = {
      [1] = {
        FXId = 600000503,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000504
  },
  [600000601] = {
    TaskEffects = {
      [1] = {
        DanmakuTemplateId = 600000406,
        Duration = 12.5,
        Function = "CreateDanmaku"
      }
    },
    TaskId = 600000601
  },
  [600000602] = {
    TargetFilter = "Target",
    TaskEffects = {
      [1] = T.RT_658,
      [2] = {Function = "AddSp", SpChange = -3}
    },
    TaskId = 600000602
  },
  [600000701] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        Function = "CreateUnit",
        LifeTime = 9,
        MaxSummonCount = 1,
        SingleSummonCount = 1,
        UnitId = 900701,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 600000701
  },
  [600000702] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600000701, Function = "PlayFX"}
    },
    TaskId = 600000702
  },
  [600000703] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000702,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000703
  },
  [600000801] = {
    TargetFilter = "Mon_Sphere_500_360_Fr",
    TaskEffects = {
      [1] = {
        BuffId = 6000112,
        Function = "AddBuff",
        LastTime = 20
      }
    },
    TaskId = 600000801
  },
  [600000802] = {
    TaskEffects = {
      [1] = {FXId = 600000801, Function = "PlayFX"}
    },
    TaskId = 600000802
  },
  [600000901] = {
    TargetFilter = "BTTarget",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 6000009,
        Function = "CreateUnit",
        LifeTime = 4,
        MaxSummonCount = 8,
        SaveLocTag = "IceOrb",
        SaveToSaveLoc = 1,
        SingleSummonCount = 1,
        UnitId = 900901,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 600000901
  },
  [600000902] = {
    TargetFilter = "Mon_Cylinder_700_300_360_NoMch",
    TaskEffects = {
      [1] = {
        BuffId = 6000115,
        Function = "AddBuff",
        LastTime = 0.5
      }
    },
    TaskId = 600000902
  },
  [600000903] = {
    TargetFilter = "Mon_Cylinder_700_300_360_NoMch",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = {
          "PhantomAvoid",
          "IceOrb"
        },
        Function = "Damage",
        Rate = 0.65
      },
      [2] = {FXId = 600000903, Function = "PlayFX"},
      [3] = {Function = "PlaySE", SEId = 600000903}
    },
    TaskId = 600000903
  },
  [600000904] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FXId = 600000902,
        Function = "PlayFX",
        IsAttached = true
      }
    },
    TaskId = 600000904
  },
  [600001001] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000116,
        Function = "AddBuff",
        LastTime = 2.5
      }
    },
    TaskId = 600001001
  },
  [600001002] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600001002, Function = "PlayFX"}
    },
    TaskId = 600001002
  },
  [600001003] = {
    TargetFilter = "Mon_Sphere_400_360_NoMch",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = {
          "PhantomAvoid",
          "Reflect"
        },
        Function = "Damage",
        Rate = 0.65
      },
      [2] = T.RT_10,
      [3] = {FXId = 600001003, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 600001004}
    },
    TaskId = 600001003
  },
  [600001004] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600001004, Function = "PlayFX"}
    },
    TaskId = 600001004
  },
  [600001005] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {BuffId = 6000116, Function = "RemoveBuff"}
    },
    TaskId = 600001005
  },
  [600001101] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreatureId = 600001101,
        Function = "CreateSkillCreature"
      }
    },
    TaskId = 600001101
  },
  [600001102] = {
    TargetFilter = "Mon_Sphere_400_360_NoMch",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = T.RT_653,
        Function = "Damage",
        Rate = 0.65
      },
      [2] = T.RT_10,
      [3] = {FXId = 600001102, Function = "PlayFX"},
      [4] = {Function = "PlaySE", SEId = 600001103}
    },
    TaskId = 600001102
  },
  [600001103] = {
    TargetFilter = "Mon_Sphere_400_360_OtFr",
    TaskEffects = {
      [1] = {
        CauseHit = "LightHit",
        Function = "CutToughness",
        Value = 200
      }
    },
    TaskId = 600001103
  },
  [600001201] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        FixLocation = true,
        FixLocationZ = 0,
        FormationId = 6000012,
        Function = "CreateUnit",
        LifeTime = 10,
        MaxSummonCount = 8,
        SingleSummonCount = 6,
        UnitId = 901201,
        UnitType = "MechanismSummon"
      }
    },
    TaskId = 600001201
  },
  [600001202] = {
    TargetFilter = "Mon_Sphere_50_360_NoMch",
    TaskEffects = {
      [1] = {
        BaseAttr = "ATK",
        DamageTag = {
          "PhantomAvoid",
          "ThunderLaser"
        },
        Function = "Damage",
        Rate = 0.4
      },
      [2] = {Function = "PlaySE", SEId = 600001203}
    },
    TaskId = 600001202
  },
  [600001203] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600001201, Function = "PlayFX"}
    },
    TaskId = 600001203
  },
  [600001301] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600001301, Function = "PlayFX"}
    },
    TaskId = 600001301
  },
  [600001401] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        CreateNotSummoned = 1,
        DestroyWithCreator = 0,
        FixLocation = true,
        FixLocationNav = 1,
        FixLocationZ = 0,
        FormationId = 6000014,
        Function = "CreateUnit",
        MaxSummonCount = 2,
        SingleSummonCount = 2,
        UnitType = "Monster",
        UseSelfUnitId = 1
      }
    },
    TaskId = 600001401
  },
  [600001402] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {
        BuffId = 6000117,
        Function = "AddBuff",
        LastTime = -1
      }
    },
    TaskId = 600001402
  },
  [600001403] = {
    TargetFilter = "Self",
    TaskEffects = {
      [1] = {FXId = 600001401, Function = "PlayFX"}
    },
    TaskId = 600001403
  }
})
