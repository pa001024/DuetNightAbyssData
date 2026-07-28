local T = {}
T.RT_1 = {AttrName = "ATK", Rate = 0.4}
T.RT_2 = {
  [1] = T.RT_1
}
T.RT_3 = {11}
T.RT_4 = {
  25,
  17.7,
  12.5,
  1
}
T.RT_5 = {
  DMMIColor = T.RT_4,
  DMMILineWidth = 0.5
}
T.RT_6 = {1000101}
T.RT_7 = {1000201}
T.RT_8 = {1000202}
T.RT_9 = {
  AttrName = "DamageRate",
  IndividualRateZone = 1,
  Value = 0.5
}
T.RT_10 = {"Dot"}
T.RT_11 = {ParamType = "Dark"}
T.RT_12 = {
  AttrName = "DamagedRate",
  RateZone = "Rouge",
  Value = 0.025
}
T.RT_13 = {
  [1] = T.RT_12
}
T.RT_14 = {21}
T.RT_15 = {10101101}
T.RT_16 = {"Dot", "RouB101"}
T.RT_17 = {
  DamageTag = T.RT_16,
  EnableIcon = 1,
  Immediately = 1,
  Interval = 1,
  Rate = 0.35,
  Stackable = 1,
  Type = "Dot"
}
T.RT_18 = {
  [1] = T.RT_17
}
T.RT_19 = {AttrName = "ATK", Rate = "#1"}
T.RT_20 = {
  [1] = T.RT_19
}
T.RT_21 = {1025}
T.RT_22 = {10}
T.RT_23 = {
  AttrName = "DamageRate",
  RateZone = "Rouge",
  Value = "#1"
}
T.RT_24 = {
  [1] = T.RT_23
}
T.RT_25 = {10199002}
T.RT_26 = {Value = "#1"}
T.RT_27 = {10199003}
T.RT_28 = {11, 63}
T.RT_29 = {40, 42}
T.RT_30 = {"Hit"}
T.RT_31 = {11, 10101101}
T.RT_32 = {AttrName = "ATK", Rate = 0.15}
T.RT_33 = {
  [1] = T.RT_32
}
T.RT_34 = {AttrName = "ATK", Rate = 0.3}
T.RT_35 = {
  [1] = T.RT_34
}
T.RT_36 = {10103101}
T.RT_37 = {
  AttrName = "SkillIntensity",
  Rate = "#1",
  Stackable = 1
}
T.RT_38 = {
  [1] = T.RT_37
}
T.RT_39 = {
  AttrName = "ATK",
  Rate = "#1",
  Stackable = 1
}
T.RT_40 = {
  [1] = T.RT_39
}
T.RT_41 = {
  AttrName = "WeaponCRIModifierRate",
  Value = "#1"
}
T.RT_42 = {
  [1] = T.RT_41
}
T.RT_43 = {
  AttrName = "WeaponCRIModifierRate",
  Type = "Ranged",
  Value = "#1"
}
T.RT_44 = {
  [1] = T.RT_43
}
T.RT_45 = {
  AttrName = "WeaponCRDModifierRate",
  Type = "Ranged",
  Value = "#1"
}
T.RT_46 = {
  [1] = T.RT_45
}
T.RT_47 = {
  AttrName = "TriggerProbModifierRate",
  Type = "Ranged",
  Value = "#1"
}
T.RT_48 = {
  [1] = T.RT_47
}
T.RT_49 = {
  AttrName = "MultiShootModifierRate",
  Type = "Ranged",
  Value = "#1"
}
T.RT_50 = {
  [1] = T.RT_49
}
T.RT_51 = {
  AttrName = "DamageRate",
  RateZone = "Almighty",
  Value = "#1"
}
T.RT_52 = {
  [1] = T.RT_51
}
T.RT_53 = {
  AttrName = "StrongValue",
  Value = "#1"
}
T.RT_54 = {
  [1] = T.RT_53
}
T.RT_55 = {2012}
T.RT_56 = {1007}
T.RT_57 = {
  Interval = 3,
  Type = "SpChange",
  Value = "#1"
}
T.RT_58 = {
  [1] = T.RT_57
}
T.RT_59 = {
  AttrName = "TriggerProbModifierRate",
  Type = "Melee",
  Value = "#1"
}
T.RT_60 = {
  [1] = T.RT_59
}
T.RT_61 = {
  AttrName = "SkillIntensity",
  Rate = "#1"
}
T.RT_62 = {
  [1] = T.RT_61
}
T.RT_63 = {
  AttrName = "WeaponCRIModifierRate",
  Type = "Melee",
  Value = "#1"
}
T.RT_64 = {
  [1] = T.RT_63
}
T.RT_65 = {
  AttrName = "WeaponCRDModifierRate",
  Type = "Melee",
  Value = "#1"
}
T.RT_66 = {
  [1] = T.RT_65
}
T.RT_67 = {"Hot"}
T.RT_68 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_67,
  Interval = 1,
  Rate = "#1",
  Type = "Hot"
}
T.RT_69 = {
  [1] = T.RT_68
}
T.RT_70 = {600000502}
T.RT_71 = {
  AttrName = "AttackSpeedModifierRate",
  Type = "Melee",
  Value = "#1"
}
T.RT_72 = {
  [1] = T.RT_71
}
T.RT_73 = {
  AttrName = "EnmityValue",
  Value = "#1"
}
T.RT_74 = {
  [1] = T.RT_73
}
T.RT_75 = {10109102, 10109104}
T.RT_76 = {ParamType = "Water"}
T.RT_77 = {
  AttrName = "AttackSpeedModifierRate",
  Stackable = 1,
  Value = "#1"
}
T.RT_78 = {
  [1] = T.RT_77
}
T.RT_79 = {104}
T.RT_80 = {1021}
T.RT_81 = {
  "FallAttack",
  "HeavyAttack",
  "SlideAttack"
}
T.RT_82 = {
  AttrName = "DamageRate",
  DamageTag = "Skill",
  RateZone = "Normal",
  Value = "#1"
}
T.RT_83 = {
  [1] = T.RT_82
}
T.RT_84 = {1002}
T.RT_85 = {
  AttrName = "AttackSpeedModifierRate",
  Value = "#1"
}
T.RT_86 = {
  AttrName = "EnmityValue",
  Value = "#2"
}
T.RT_87 = {
  [1] = T.RT_85,
  [2] = T.RT_86
}
T.RT_88 = {1008}
T.RT_89 = {
  AttrName = "SkillSpeed",
  Rate = 0.02,
  Stackable = 1
}
T.RT_90 = {
  [1] = T.RT_89
}
T.RT_91 = {
  AttrName = "TriggerProbModifierRate",
  Value = 1
}
T.RT_92 = {
  [1] = T.RT_91
}
T.RT_93 = {ParamType = "Fire"}
T.RT_94 = {
  AttrName = "MoveSpeedAddRate",
  Value = -0.4
}
T.RT_95 = {
  [1] = T.RT_94
}
T.RT_96 = {
  21,
  41,
  49,
  44
}
T.RT_97 = {
  AttrName = "MoveSpeedAddRate",
  Value = 1
}
T.RT_98 = {
  [1] = T.RT_97
}
T.RT_99 = {1003}
T.RT_100 = {
  AttrName = "BonusDamage",
  Type = "Water",
  Value = 0.35
}
T.RT_101 = {
  [1] = T.RT_100
}
T.RT_102 = {202}
T.RT_103 = {
  AttrName = "BonusDamage",
  Type = "Fire",
  Value = 0.35
}
T.RT_104 = {
  [1] = T.RT_103
}
T.RT_105 = {203}
T.RT_106 = {
  AttrName = "BonusDamage",
  Type = "Thunder",
  Value = 0.35
}
T.RT_107 = {
  [1] = T.RT_106
}
T.RT_108 = {204}
T.RT_109 = {
  AttrName = "BonusDamage",
  Type = "Wind",
  Value = 0.35
}
T.RT_110 = {
  [1] = T.RT_109
}
T.RT_111 = {205}
T.RT_112 = {
  AttrName = "BonusDamage",
  Type = "Light",
  Value = 0.35
}
T.RT_113 = {
  [1] = T.RT_112
}
T.RT_114 = {206}
T.RT_115 = {
  AttrName = "BonusDamage",
  Type = "Dark",
  Value = 0.35
}
T.RT_116 = {
  [1] = T.RT_115
}
T.RT_117 = {201}
T.RT_118 = {
  AttrName = "DamageRate",
  RateZone = "Almighty",
  Value = 0.2
}
T.RT_119 = {
  [1] = T.RT_118
}
T.RT_120 = {ParamType = "Thunder"}
T.RT_121 = {ParamType = "Wind"}
T.RT_122 = {AttrName = "MaxHp", Rate = "#1"}
T.RT_123 = {
  [1] = T.RT_122
}
T.RT_124 = {
  AttrName = "AttackRangeModifierValue",
  Value = "#1"
}
T.RT_125 = {
  [1] = T.RT_124
}
T.RT_126 = {10503}
T.RT_127 = {10503001}
T.RT_128 = {
  AttrName = "TriggerProbModifierRate",
  Value = "#1"
}
T.RT_129 = {
  [1] = T.RT_128
}
T.RT_130 = {
  [1] = T.RT_85
}
T.RT_131 = {ParamType = "Light"}
T.RT_132 = {
  AttrName = "WeaponCRDModifierRate",
  Value = "#1"
}
T.RT_133 = {
  [1] = T.RT_132
}
T.RT_134 = {10, 12}
T.RT_135 = {AttrName = "ATK", Rate = 0.5}
T.RT_136 = {
  [1] = T.RT_135
}
T.RT_137 = {70}
T.RT_138 = {
  1,
  0,
  0,
  0
}
T.RT_139 = {Default = 0.5}
T.RT_140 = {110129}
T.RT_141 = {
  AttrName = "SkillEfficiency",
  Rate = 0.08
}
T.RT_142 = {
  [1] = T.RT_141
}
T.RT_143 = {
  AttrName = "ATK",
  Rate = 0.2,
  Stackable = 1
}
T.RT_144 = {
  [1] = T.RT_143
}
T.RT_145 = {30}
T.RT_146 = {110203}
T.RT_147 = {HitFly = "HeavyHit"}
T.RT_148 = {Value = -30}
T.RT_149 = {110202}
T.RT_150 = {70, 72}
T.RT_151 = {
  "TuosiSkill02",
  "0.8",
  "50"
}
T.RT_152 = {
  "EBulletJump"
}
T.RT_153 = {
  AttrName = "ATK",
  BaseUseValue = 1,
  Rate = "#1",
  SupLimitValue = 315
}
T.RT_154 = {
  AttrName = "WalkSpeedModifier",
  Value = 0.5
}
T.RT_155 = {
  AttrName = "JumpVelocityModifier",
  Value = 0.1
}
T.RT_156 = {Value = -0.25}
T.RT_157 = {AttrName = "SkillRange", Rate = 0.3}
T.RT_158 = {1005}
T.RT_159 = {AttrName = "SkillSpeed", Rate = 0.3}
T.RT_160 = {
  AttrName = "StrongValue",
  Value = 0.9
}
T.RT_161 = {11, 110401}
T.RT_162 = {160122}
T.RT_163 = {1001}
T.RT_164 = {AttrName = "ATK", Rate = 1}
T.RT_165 = {
  [1] = T.RT_164
}
T.RT_166 = {
  20,
  100,
  111
}
T.RT_167 = {AttrName = "Def", Rate = "#1"}
T.RT_168 = {
  [1] = T.RT_167
}
T.RT_169 = {
  AttrName = "BonusDamage",
  Type = "Dark",
  Value = "#1"
}
T.RT_170 = {
  [1] = T.RT_169
}
T.RT_171 = {
  AttrName = "MoveSpeedAddRate",
  Value = -0.5
}
T.RT_172 = {
  [1] = T.RT_171
}
T.RT_173 = {20, 42}
T.RT_174 = {
  AttrName = "DamageRate",
  RateZone = "Almighty",
  Value = 0.25
}
T.RT_175 = {
  [1] = T.RT_174
}
T.RT_176 = {11, 70}
T.RT_177 = {
  AttrName = "DamageRate",
  RateZone = "Normal",
  Value = "#1"
}
T.RT_178 = {
  [1] = T.RT_177
}
T.RT_179 = {6000206}
T.RT_180 = {
  AttrName = "SkillSustain",
  Rate = "#1"
}
T.RT_181 = {
  [1] = T.RT_180
}
T.RT_182 = {Value = -0.3}
T.RT_183 = {150103}
T.RT_184 = {Default = 50}
T.RT_185 = {AttrName = "ATK", Rate = 0.35}
T.RT_186 = {
  [1] = T.RT_185
}
T.RT_187 = {
  AttrName = "MoveSpeedAddRate",
  Value = -0.3
}
T.RT_188 = {
  [1] = T.RT_187
}
T.RT_189 = {20}
T.RT_190 = {
  AttrName = "SkillIntensity",
  RateUseValue = 1
}
T.RT_191 = {
  AttrName = "DamageRate",
  DamageTag = "Melee",
  RateZone = "Normal",
  Stackable = 1,
  Value = "#1"
}
T.RT_192 = {
  AttrName = "TriggerProbModifierRate",
  Stackable = 1,
  Type = "Melee",
  Value = "#2"
}
T.RT_193 = {
  [1] = T.RT_191,
  [2] = T.RT_192
}
T.RT_194 = {
  [150302] = T.RT_182
}
T.RT_195 = {
  [100] = 150305
}
T.RT_196 = {
  AttrName = "DamageRate",
  DamageTag = "Ranged",
  RateZone = "Normal",
  Stackable = 1,
  Value = "#1"
}
T.RT_197 = {
  AttrName = "TriggerProbModifierRate",
  Stackable = 1,
  Type = "Ranged",
  Value = "#2"
}
T.RT_198 = {
  [1] = T.RT_196,
  [2] = T.RT_197
}
T.RT_199 = {
  [150321] = T.RT_182
}
T.RT_200 = {
  [100] = 150306
}
T.RT_201 = {
  AttrName = "AttackSpeedModifierRate",
  Type = "Ranged",
  Value = "#1"
}
T.RT_202 = {
  [1] = T.RT_201
}
T.RT_203 = {150311}
T.RT_204 = {150312}
T.RT_205 = {Default = 0.45}
T.RT_206 = {
  AttrName = "DamageRate",
  RateZone = "Normal",
  Value = 0.9
}
T.RT_207 = {
  [1] = T.RT_206
}
T.RT_208 = {1000}
T.RT_209 = {
  "ESecondJump",
  "EWallJump",
  "EBulletJump",
  "Eclimb",
  "EFlipEaves"
}
T.RT_210 = {150413}
T.RT_211 = {
  AttrName = "StrongValue",
  Value = 0.06
}
T.RT_212 = {
  [1] = T.RT_211
}
T.RT_213 = {
  Interval = 0.2,
  Type = "SecondSpChange",
  Value = -1
}
T.RT_214 = {
  [1] = T.RT_213
}
T.RT_215 = {
  "IncrementDefault",
  "0.5",
  "50"
}
T.RT_216 = {"Move", "Hit"}
T.RT_217 = {Value = 1}
T.RT_218 = {
  AttrName = "DamageRate",
  DamageTag = "Weapon",
  RateZone = "Normal",
  Value = "#1"
}
T.RT_219 = {
  [1] = T.RT_218
}
T.RT_220 = {160121}
T.RT_221 = {160101}
T.RT_222 = {
  AllowSkillIntensity = 1,
  AttrName = "BonusDamage",
  Stackable = 1,
  Type = "Light",
  Value = "#1"
}
T.RT_223 = {
  [1] = T.RT_222
}
T.RT_224 = {180102}
T.RT_225 = {11, 180101}
T.RT_226 = {
  0.0068,
  0.0492,
  0.2,
  0
}
T.RT_227 = {Default = 0.4}
T.RT_228 = {Default = 130}
T.RT_229 = {
  FresnelColor = T.RT_226,
  FresnelColorRange = T.RT_227,
  FresnelColorStrength = T.RT_228
}
T.RT_230 = {180101}
T.RT_231 = {2031}
T.RT_232 = {180120}
T.RT_233 = {21, 180121}
T.RT_234 = {"Dot", "Skill"}
T.RT_235 = {
  AllowSkillIntensity = 1,
  DamageTag = T.RT_234,
  DamageType = "Fire",
  Immediately = 1,
  Interval = 2,
  Rate = "#1",
  Type = "Dot"
}
T.RT_236 = {
  [1] = T.RT_235
}
T.RT_237 = {
  AllowSkillIntensity = 1,
  DamageTag = T.RT_234,
  DamageType = "Thunder",
  Immediately = 1,
  Interval = 2,
  Rate = "#1",
  Type = "Dot"
}
T.RT_238 = {
  [1] = T.RT_237
}
T.RT_239 = {
  AllowSkillIntensity = 1,
  DamageTag = T.RT_234,
  DamageType = "Wind",
  Immediately = 1,
  Interval = 2,
  Rate = "#1",
  Type = "Dot"
}
T.RT_240 = {
  [1] = T.RT_239
}
T.RT_241 = {
  AttrName = "BonusDamage",
  Type = "Water",
  Value = "#1"
}
T.RT_242 = {1041}
T.RT_243 = {
  AttrName = "BonusDamage",
  Type = "Fire",
  Value = "#1"
}
T.RT_244 = {1042}
T.RT_245 = {
  AttrName = "BonusDamage",
  Type = "Thunder",
  Value = "#1"
}
T.RT_246 = {1044}
T.RT_247 = {
  AttrName = "BonusDamage",
  Type = "Wind",
  Value = "#1"
}
T.RT_248 = {
  [1] = T.RT_247
}
T.RT_249 = {1043}
T.RT_250 = {
  AttrName = "DamageRate",
  RateZone = "Almighty",
  Value = 0.06
}
T.RT_251 = {10, 180130}
T.RT_252 = {180131}
T.RT_253 = {180132}
T.RT_254 = {180133}
T.RT_255 = {180134}
T.RT_256 = {
  20,
  41,
  49
}
T.RT_257 = {Rate = 0.5}
T.RT_258 = {
  1,
  0.2,
  0,
  0
}
T.RT_259 = {Default = 0.65}
T.RT_260 = {Default = 20, FresnelColor = 20}
T.RT_261 = {
  FresnelColor = T.RT_258,
  FresnelColorRange = T.RT_259,
  FresnelColorStrength = T.RT_260
}
T.RT_262 = {"Invincible"}
T.RT_263 = {
  "InvincibleUI"
}
T.RT_264 = {
  AttrName = "WaterDamagedRate",
  Value = 4
}
T.RT_265 = {
  AttrName = "FireDamagedRate",
  Value = -0.5
}
T.RT_266 = {
  AttrName = "ThunderDamagedRate",
  Value = -0.5
}
T.RT_267 = {
  AttrName = "WindDamagedRate",
  Value = -0.5
}
T.RT_268 = {
  AttrName = "FireDamagedRate",
  Value = 4
}
T.RT_269 = {
  AttrName = "WaterDamagedRate",
  Value = -0.5
}
T.RT_270 = {
  AttrName = "ThunderDamagedRate",
  Value = 4
}
T.RT_271 = {
  AttrName = "WindDamagedRate",
  Value = 4
}
T.RT_272 = {
  AttrName = "LightDamagedRate",
  Value = 4
}
T.RT_273 = {
  AttrName = "DarkDamagedRate",
  Value = -0.5
}
T.RT_274 = {
  AttrName = "DarkDamagedRate",
  Value = 4
}
T.RT_275 = {
  AttrName = "LightDamagedRate",
  Value = -0.5
}
T.RT_276 = {
  AuraRange = 2000,
  BuffId = 2010102,
  Camp = "OtherFriend"
}
T.RT_277 = {
  [1] = T.RT_276
}
T.RT_278 = {Value = -0.01}
T.RT_279 = {Value = -0.02}
T.RT_280 = {Value = -0.04}
T.RT_281 = {
  BaseAttr = "MaxES",
  Condition = 2010211,
  DamageTag = T.RT_67,
  Interval = 3,
  Rate = 0.3,
  Type = "AddShield"
}
T.RT_282 = {
  [1] = T.RT_281
}
T.RT_283 = {
  AttrName = "DamageRate",
  DamageTag = "Melee",
  RateZone = "Normal",
  Value = "#1"
}
T.RT_284 = {
  [1] = T.RT_283
}
T.RT_285 = {
  [5] = 2010004
}
T.RT_286 = {
  AttrName = "WeaponCRIModifierRate",
  Stackable = 1,
  Value = "#1"
}
T.RT_287 = {
  [1] = T.RT_286
}
T.RT_288 = {
  AttrName = "WeaponCRDModifierRate",
  Value = 1
}
T.RT_289 = {
  AttrName = "SkillIntensity",
  Rate = 1
}
T.RT_290 = {
  [1] = T.RT_289
}
T.RT_291 = {
  AttrName = "DamageRate",
  IndividualRateZone = 1,
  Value = -0.12
}
T.RT_292 = {
  AttrName = "WeaponCRIModifierRate",
  Value = 1
}
T.RT_293 = {
  AttrName = "DamageRate",
  RateZone = "Abyss",
  Value = 0.1
}
T.RT_294 = {
  [1] = T.RT_293
}
T.RT_295 = {
  AttrName = "StrongValue",
  Value = 0.15
}
T.RT_296 = {
  [1] = T.RT_295
}
T.RT_297 = {
  AttrName = "DamageRate",
  RateZone = "Abyss",
  Value = 0.5
}
T.RT_298 = {
  [1] = T.RT_297
}
T.RT_299 = {AttrName = "ATK", Rate = -1.5}
T.RT_300 = {AttrName = "ATK", Rate = 0.05}
T.RT_301 = {
  [1] = T.RT_300
}
T.RT_302 = {
  AttrName = "DamageRate",
  RateZone = "Rouge",
  Value = 0.5
}
T.RT_303 = {
  AttrName = "DamageRate",
  RateZone = "Rouge",
  Value = 0.75
}
T.RT_304 = {
  [1] = T.RT_303
}
T.RT_305 = {
  AttrName = "DamageRate",
  RateZone = "Rouge",
  Value = 1
}
T.RT_306 = {
  AttrName = "MultiShootModifierRate",
  Stackable = 1,
  Value = "#1"
}
T.RT_307 = {
  [1] = T.RT_306
}
T.RT_308 = {1023}
T.RT_309 = {600012}
T.RT_310 = {1004}
T.RT_311 = {20, 41}
T.RT_312 = {20, 22}
T.RT_313 = {210102}
T.RT_314 = {20, 210101}
T.RT_315 = {
  AllowSkillIntensity = 1,
  DamageTag = T.RT_234,
  DamageType = "Water",
  Immediately = 1,
  Interval = 2,
  PlaySe = 152,
  Rate = "#1",
  Stackable = 1,
  Type = "Dot"
}
T.RT_316 = {
  [1] = T.RT_315
}
T.RT_317 = {
  ["210189"] = "ShuimuDot_210189",
  ParamType = "ShuimuDot"
}
T.RT_318 = {
  [1] = T.RT_159
}
T.RT_319 = {
  AttrName = "DamageRate",
  RateZone = "Almighty",
  Value = 0.4
}
T.RT_320 = {
  [1] = T.RT_319
}
T.RT_321 = {AttrName = "FakeHpRate", Value = 0.01}
T.RT_322 = {11, 21103010}
T.RT_323 = {1024}
T.RT_324 = {Default = 30, FresnelColor = 30}
T.RT_325 = {1022}
T.RT_326 = {
  AttrName = "WalkSpeedModifier",
  Value = "#1"
}
T.RT_327 = {
  AttrName = "SkillIntensity",
  RateUseValue = 1,
  SupLimitRate = 1.2
}
T.RT_328 = {
  [1] = T.RT_327
}
T.RT_329 = {240121}
T.RT_330 = {
  0.7,
  0.95,
  1,
  1
}
T.RT_331 = {Default = 3, FresnelColor = 3}
T.RT_332 = {
  FresnelColor = T.RT_330,
  FresnelColorRange = T.RT_139,
  FresnelColorStrength = T.RT_331
}
T.RT_333 = {
  3001,
  240122,
  240123
}
T.RT_334 = {
  AttrName = "SkillSpeed",
  Rate = "#1",
  Stackable = 1
}
T.RT_335 = {
  [1] = T.RT_334
}
T.RT_336 = {240133}
T.RT_337 = {11, 60}
T.RT_338 = {41}
T.RT_339 = {11, 61}
T.RT_340 = {6000213}
T.RT_341 = {11, 62}
T.RT_342 = {30, 30401}
T.RT_343 = {30402, 30407}
T.RT_344 = {304000001}
T.RT_345 = {30, 30402}
T.RT_346 = {30401, 30407}
T.RT_347 = {304000002}
T.RT_348 = {
  "BossMapSkill",
  "1",
  "999"
}
T.RT_349 = {30, 30407}
T.RT_350 = {30401, 30402}
T.RT_351 = {304000004}
T.RT_352 = {Rate = 0.2}
T.RT_353 = {
  [1010101] = 1019801
}
T.RT_354 = {310111}
T.RT_355 = {21, 310111}
T.RT_356 = {310101}
T.RT_357 = {
  [310101] = 310111,
  [310102] = 310121
}
T.RT_358 = {
  "Attack",
  "FallAttack",
  "HeavyAttack",
  "SlideAttack"
}
T.RT_359 = {
  DotDelay = 1.5,
  Interval = 1,
  Type = "SpChange",
  Value = -20
}
T.RT_360 = {
  [1] = T.RT_359
}
T.RT_361 = {Attack = "Fire"}
T.RT_362 = {
  [310201] = 310211
}
T.RT_363 = {
  DotDelay = 0.5,
  Interval = 1,
  Type = "SpChange",
  Value = -24
}
T.RT_364 = {
  [1] = T.RT_363
}
T.RT_365 = {Default = 1.5, FresnelColor = 1.5}
T.RT_366 = {
  AttrName = "MoveSpeedAddRate",
  Value = -0.6
}
T.RT_367 = {
  [1] = T.RT_366
}
T.RT_368 = {21, 42}
T.RT_369 = {310321}
T.RT_370 = {
  [1] = T.RT_154
}
T.RT_371 = {"HotUI"}
T.RT_372 = {320102}
T.RT_373 = {AttrName = "ATK", Rate = 0.45}
T.RT_374 = {
  [1] = T.RT_373
}
T.RT_375 = {
  AttrName = "MultiShootModifierRate",
  Value = "#1"
}
T.RT_376 = {
  [1] = T.RT_375
}
T.RT_377 = {AttrName = "SkillSpeed", Rate = 0.8}
T.RT_378 = {
  AttrName = "DamagedRate",
  RateZone = "Level",
  Value = 0.5
}
T.RT_379 = {
  [1] = T.RT_378
}
T.RT_380 = {600000901}
T.RT_381 = {
  AttrName = "MaxHp",
  Rate = 0.3,
  Stackable = 1
}
T.RT_382 = {
  [1] = T.RT_381
}
T.RT_383 = {
  AttrName = "DEF",
  Rate = 0.45,
  Stackable = 1
}
T.RT_384 = {
  AttrName = "ATK",
  Rate = 0.3,
  Stackable = 1
}
T.RT_385 = {
  [1] = T.RT_384
}
T.RT_386 = {
  AttrName = "MaxES",
  Rate = 0.4,
  Stackable = 1
}
T.RT_387 = {6000101}
T.RT_388 = {
  Char = "Mon_Strong_Single"
}
T.RT_389 = {6000102}
T.RT_390 = {6000103}
T.RT_391 = {6000104}
T.RT_392 = {6000105}
T.RT_393 = {6000106}
T.RT_394 = {6000107}
T.RT_395 = {6000108}
T.RT_396 = {6000109}
T.RT_397 = {6000110}
T.RT_398 = {6000111}
T.RT_399 = {6000112}
T.RT_400 = {6000113}
T.RT_401 = {
  AttrName = "DEF",
  Rate = 0.25,
  Stackable = 1
}
T.RT_402 = {
  AttrName = "ATK",
  Rate = 0.25,
  Stackable = 1
}
T.RT_403 = {
  AttrName = "DEF",
  Rate = 0.2,
  Stackable = 1
}
T.RT_404 = {
  [1] = T.RT_143,
  [2] = T.RT_403
}
T.RT_405 = {
  AttrName = "ATK",
  Rate = 0.45,
  Stackable = 1
}
T.RT_406 = {
  [1] = T.RT_405
}
T.RT_407 = {
  AttrName = "MaxHp",
  Rate = 0.9,
  Stackable = 1
}
T.RT_408 = {
  [1] = T.RT_407
}
T.RT_409 = {
  AttrName = "DEF",
  Rate = 0.3,
  Stackable = 1
}
T.RT_410 = {
  AttrName = "ATK",
  Rate = 0.5,
  Stackable = 1
}
T.RT_411 = {
  [1] = T.RT_410
}
T.RT_412 = {
  AttrName = "ATK",
  Rate = 1,
  Stackable = 1
}
T.RT_413 = {
  AttrName = "DEF",
  Rate = 1,
  Stackable = 1
}
T.RT_414 = {
  AttrName = "MaxHp",
  Rate = 1,
  Stackable = 1
}
T.RT_415 = {
  AttrName = "MaxES",
  Rate = 1,
  Stackable = 1
}
T.RT_416 = {
  [1] = T.RT_412,
  [2] = T.RT_413,
  [3] = T.RT_414,
  [4] = T.RT_415
}
T.RT_417 = {
  AttrName = "ATK",
  Rate = 1.5,
  Stackable = 1
}
T.RT_418 = {
  [1] = T.RT_417
}
T.RT_419 = {
  AttrName = "MaxHp",
  Rate = 0.25,
  Stackable = 1
}
T.RT_420 = {
  AttrName = "MaxES",
  Rate = 0.25,
  Stackable = 1
}
T.RT_421 = {
  BaseAttr = "MaxHp",
  DamageTag = T.RT_10,
  DamageType = "TrueDamage",
  Interval = 1,
  Rate = 0.1,
  Type = "Dot"
}
T.RT_422 = {
  [1] = T.RT_421
}
T.RT_423 = {
  AttrName = "DamageRate",
  RateZone = "Normal",
  Value = 0.15
}
T.RT_424 = {
  [1] = T.RT_423
}
T.RT_425 = {
  AttrName = "DamageRate",
  RateZone = "Normal",
  Value = -0.15
}
T.RT_426 = {
  [1] = T.RT_425
}
T.RT_427 = {AttrName = "ATK", Rate = 0.1}
T.RT_428 = {
  [1] = T.RT_427
}
T.RT_429 = {4020118}
T.RT_430 = {
  AttrName = "MoveSpeedAddRate",
  Value = 0.5
}
T.RT_431 = {40201001}
T.RT_432 = {40201002}
T.RT_433 = {40201009}
T.RT_434 = {40201006}
T.RT_435 = {
  AttrName = "WalkSpeedModifier",
  Value = 0.25
}
T.RT_436 = {
  AttrName = "SlideVelocityModifier",
  Value = 0.25
}
T.RT_437 = {
  AttrName = "BulletJumpVelocityModifier",
  Value = 0.25
}
T.RT_438 = {
  AttrName = "JumpVelocityModifier",
  Value = 0.25
}
T.RT_439 = {
  [1] = T.RT_435,
  [2] = T.RT_436,
  [3] = T.RT_437,
  [4] = T.RT_438
}
T.RT_440 = {
  Interval = 1,
  Type = "SpChange",
  Value = -6
}
T.RT_441 = {
  [1] = T.RT_440
}
T.RT_442 = {AttrName = "DEF", Rate = "#1"}
T.RT_443 = {
  [1] = T.RT_442
}
T.RT_444 = {420102}
T.RT_445 = {
  Interval = 3,
  Type = "SpChange",
  Value = 1
}
T.RT_446 = {
  [1] = T.RT_445
}
T.RT_447 = {2000}
T.RT_448 = {5000010}
T.RT_449 = {Rate = 1}
T.RT_450 = {2105}
T.RT_451 = {"Controlled"}
T.RT_452 = {
  "Dot",
  "PhantomAvoid"
}
T.RT_453 = {
  DamageTag = T.RT_452,
  Interval = 1,
  Rate = 0.8,
  Type = "Dot"
}
T.RT_454 = {
  [1] = T.RT_453
}
T.RT_455 = {600503}
T.RT_456 = {
  AttrName = "SlideVelocityModifier",
  Value = 0.5
}
T.RT_457 = {
  AttrName = "BulletJumpVelocityModifier",
  Value = 0.5
}
T.RT_458 = {
  AttrName = "JumpVelocityModifier",
  Value = 0.5
}
T.RT_459 = {
  [1] = T.RT_154,
  [2] = T.RT_456,
  [3] = T.RT_457,
  [4] = T.RT_458
}
T.RT_460 = {6000}
T.RT_461 = {
  AttrName = "BulletJumpVelocityModifier",
  Value = 1.5
}
T.RT_462 = {
  [1] = T.RT_154,
  [2] = T.RT_456,
  [3] = T.RT_461,
  [4] = T.RT_458
}
T.RT_463 = {
  40,
  41,
  42,
  43,
  44
}
T.RT_464 = {600000802}
T.RT_465 = {
  "Roller01",
  "0.5",
  "50"
}
T.RT_466 = {
  "FallAttack",
  "HeavyAttack",
  "SlideAttack",
  "Attack",
  "Skill2",
  "Skill1",
  "Shooting",
  "HeavyShooting",
  "Reload"
}
T.RT_467 = {
  AttrName = "ATK",
  Rate = 0.1,
  Stackable = 1
}
T.RT_468 = {
  AttrName = "MaxHp",
  Rate = 3.5,
  Stackable = 1
}
T.RT_469 = {
  AttrName = "MaxES",
  Rate = 3.5,
  Stackable = 1
}
T.RT_470 = {
  [1] = T.RT_467,
  [2] = T.RT_468,
  [3] = T.RT_469
}
T.RT_471 = {Value = "#2"}
T.RT_472 = {10, 510103}
T.RT_473 = {
  10.88886,
  2.91666,
  20,
  0
}
T.RT_474 = {
  FresnelColor = T.RT_473,
  FresnelColorRange = T.RT_227,
  FresnelColorStrength = T.RT_365
}
T.RT_475 = {
  510106,
  510108,
  510109,
  510110,
  510111,
  510112
}
T.RT_476 = {
  "Stealth",
  "Translucency"
}
T.RT_477 = {10, 510221}
T.RT_478 = {510201}
T.RT_479 = {
  "FallAttack",
  "HeavyAttack",
  "SlideAttack",
  "Attack"
}
T.RT_480 = {530121}
T.RT_481 = {530102}
T.RT_482 = {11, 540101}
T.RT_483 = {
  EffectId = 540112,
  Immediately = 1,
  Interval = 1,
  Type = "SkillEffect"
}
T.RT_484 = {
  [1] = T.RT_483
}
T.RT_485 = {
  AllowSkillRange = 1,
  AuraRange = 600,
  BuffId = 540112,
  Camp = "Enemy"
}
T.RT_486 = {540111}
T.RT_487 = {
  AllowSkillIntensity = 1,
  Condition = 2,
  DamageTag = T.RT_67,
  DefaultHealFX = 1,
  Immediately = 1,
  Interval = 1,
  Rate = "#1",
  Type = "Hot",
  Value = 3
}
T.RT_488 = {
  [1] = T.RT_487
}
T.RT_489 = {540121}
T.RT_490 = {540123}
T.RT_491 = {600000103}
T.RT_492 = {600010}
T.RT_493 = {AttrName = "SkillSpeed", Rate = 0.4}
T.RT_494 = {
  Char = "Mon_Strong_Double"
}
T.RT_495 = {
  Char = "Mon_Strong_Tripple"
}
T.RT_496 = {
  AttrName = "DamagedRate",
  IndividualRateZone = 1,
  Value = 0.5
}
T.RT_497 = {700501}
T.RT_498 = {
  41,
  42,
  43,
  44
}
T.RT_499 = {44}
T.RT_500 = {2102}
T.RT_501 = {11, 1000}
T.RT_502 = {41, 43}
T.RT_503 = {
  50,
  7.0434,
  2.06,
  1
}
T.RT_504 = {
  DMMIColor = T.RT_503,
  DMMILineWidth = 0.5
}
T.RT_505 = {
  ParamType = "Invisibility",
  Priority = 1
}
T.RT_506 = {800201}
T.RT_507 = {AttrName = "MaxES", Rate = "#1"}
T.RT_508 = {AttrName = "DEF", Rate = "#2"}
T.RT_509 = {AttrName = "MaxHp", Rate = "#3"}
T.RT_510 = {40, 41}
T.RT_511 = {Rate = 0.01}
T.RT_512 = {
  "BossMapSkill",
  "0.5",
  "999"
}
T.RT_513 = {
  41,
  42,
  43
}
T.RT_514 = {
  "BossLinenDefault",
  "0.5",
  "5"
}
T.RT_515 = {
  "BossLiecheCannonSkill06",
  "0.5",
  "999"
}
T.RT_516 = {
  "FallAttack",
  "HeavyAttack",
  "SlideAttack",
  "Skill1",
  "Skill2",
  "Reload"
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Buff", {
  [1] = {
    BuffId = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Phantom",
        Value = -0.5
      }
    },
    BuffId = 2,
    DeadNotRemove = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [3] = {
    BuffId = 3,
    FresnelParams = {
      FresnelColor = {
        1,
        0.84682,
        0.359142,
        0
      },
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = T.RT_184
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_262
  },
  [4] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_CommonBulletJump.BP_Buff_CommonBulletJump",
    BuffId = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [5] = {
    AddAttrs = T.RT_370,
    AddPassiveEffect = {1},
    BuffId = 5,
    DisableEmoIdle = true,
    DisableSkills = {"Skill1", "Skill2"},
    ForbidenJumpState = {
      "EWallJump",
      "EBulletJump",
      "Eclimb",
      "EFlipEaves"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "LandHeavy",
      "Hit",
      "Crouch",
      "Interactive",
      "Seating",
      "Shooting",
      "Skill",
      "Slide"
    }
  },
  [6] = {
    AddAttrs = {
      [1] = {
        AttrName = "RideMoveFlySpeedModifier",
        Value = 0.5
      }
    },
    BuffId = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [11] = {
    AddAttrs = T.RT_20,
    BuffId = 11,
    BuffType = T.RT_134,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [12] = {
    AddAttrs = T.RT_168,
    BuffId = 12,
    BuffType = T.RT_134,
    BuffTypeImgPath = "Def_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [13] = {
    AddAttrs = T.RT_62,
    BuffId = 13,
    BuffType = T.RT_134,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [14] = {
    AddAttrs = T.RT_181,
    BuffId = 14,
    BuffType = T.RT_134,
    BuffTypeImgPath = "Skill_Sustain_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21] = {
    AddAttrs = T.RT_20,
    BuffId = 21,
    BuffType = T.RT_312,
    BuffTypeImgPath = "Atk_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [22] = {
    AddAttrs = T.RT_168,
    BuffId = 22,
    BuffType = T.RT_312,
    BuffTypeImgPath = "Def_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [23] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        Value = "#1"
      }
    },
    BuffId = 23,
    BuffType = T.RT_312,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [41] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        ValueUseValue = 1
      }
    },
    BuffId = 41,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [50] = {
    BuffId = 50,
    DeadNotRemove = true,
    EffectCreatureID = 1,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [51] = {
    BuffId = 51,
    DeadNotRemove = true,
    EffectCreatureID = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [52] = {
    BuffId = 52,
    BuffType = T.RT_312,
    BuffTypeImgPath = "Def_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [94] = {
    BuffId = 94,
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "SpChange",
        Value = 10
      }
    },
    IsAvatarBuff = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [95] = {
    BuffId = 95,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_162
  },
  [96] = {
    AddAttrs = T.RT_35,
    BuffDamagedRate = T.RT_182,
    BuffId = 96,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {114}
  },
  [97] = {
    BuffId = 97,
    DeadNotRemove = true,
    ForbidGetExp = true,
    IsAvatarBuff = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [98] = {
    BuffId = 98,
    DisableSkills = {"Skill2"},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [99] = {
    BuffId = 99,
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        Interval = 0.5,
        Type = "SpChange",
        Value = 5
      }
    },
    IsAvatarBuff = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [101] = {
    AddAttrs = {
      [1] = {
        AttrName = "BossTNToZeroRecoverSpeed",
        Rate = -0.01,
        Stackable = 1
      }
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element.BP_Buff_Element",
    BuffId = 101,
    BuffType = {
      20,
      100,
      101
    },
    BuffTypeImgPath = "Dot_Dark",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Dark",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_11,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [102] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element.BP_Buff_Element",
    BuffId = 102,
    BuffType = {
      20,
      100,
      102
    },
    BuffTypeImgPath = "Dot_Water",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Water",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_76,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [103] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element.BP_Buff_Element",
    BuffId = 103,
    BuffType = {
      20,
      100,
      103
    },
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Fire",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_93,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [104] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element.BP_Buff_Element",
    BuffId = 104,
    BuffType = {
      20,
      100,
      104
    },
    BuffTypeImgPath = "Dot_Thunder",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Thunder",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_120,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [105] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element.BP_Buff_Element",
    BuffId = 105,
    BuffType = {
      20,
      100,
      105
    },
    BuffTypeImgPath = "Dot_Wind",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Wind",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_121,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [106] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Element_Light.BP_Buff_Element_Light",
    BuffId = 106,
    BuffType = {
      20,
      100,
      106
    },
    BuffTypeImgPath = "Dot_Light",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Light",
        EnableIcon = 1,
        Immediately = 1,
        Interval = 2,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    DotDeathSe = 152,
    FXMID = T.RT_131,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [111] = {
    BuffId = 111,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Dark_Up",
    FXMID = T.RT_11,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [112] = {
    BuffId = 112,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Water_Up",
    FXMID = T.RT_76,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [113] = {
    BuffId = 113,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Fire_Up",
    FXMID = T.RT_93,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [114] = {
    BuffId = 114,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Thunder_Up",
    FXMID = T.RT_120,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [115] = {
    BuffId = 115,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Wind_Up",
    FXMID = T.RT_121,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [116] = {
    BuffId = 116,
    BuffType = T.RT_166,
    BuffTypeImgPath = "Damaged_Light_Up",
    FXMID = T.RT_131,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    Priority = 10
  },
  [201] = {
    BuffId = 201,
    BuffType = T.RT_256,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetCharacterTag = "Stun",
    StunType = "StunBlind"
  },
  [202] = {
    BuffId = 202,
    BuffType = T.RT_256,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunBound"
  },
  [203] = {
    BuffId = 203,
    BuffType = {
      20,
      41,
      203,
      49
    },
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunParalysis",
    VisualEffects = T.RT_309
  },
  [204] = {
    BuffId = 204,
    BuffType = T.RT_256,
    BuffTypeImgPath = "Stun",
    EnterFloating = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [205] = {
    BuffId = 205,
    BuffType = {20, 43},
    BuffTypeImgPath = "Taunt",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SpecialEffect = {"Taunt"},
    VisualEffects = {600013}
  },
  [206] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        Value = -0.8
      }
    },
    BuffEffects = T.RT_231,
    BuffId = 206,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [207] = {
    BuffId = 207,
    BuffType = T.RT_311,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetCharacterTag = "Stun",
    StunType = "StunCommon"
  },
  [301] = {
    BuffId = 301,
    BuffType = T.RT_337,
    BuffTypeImgPath = "Invincible",
    ForbidBuffType = T.RT_338,
    FresnelParams = T.RT_261,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    Priority = 1000,
    SpecialEffect = T.RT_262,
    UISpecialEffect = T.RT_263
  },
  [302] = {
    BuffId = 302,
    BuffType = T.RT_339,
    BuffTypeImgPath = "Common_Buff",
    DMMIParams = {
      DMMIColor = {
        10,
        10,
        10,
        0
      },
      DMMILineWidth = 0.5
    },
    FXMID = {
      ParamType = "Invisibility"
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [303] = {
    AddAttrs = T.RT_98,
    BuffEffects = T.RT_208,
    BuffId = 303,
    BuffType = T.RT_341,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [304] = {
    BuffId = 304,
    DeadNotRemove = true,
    IsAvatarBuff = 1,
    LockHp = T.RT_217,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [305] = {
    BuffId = 305,
    BuffType = T.RT_28,
    BuffTypeImgPath = "Endure",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [306] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        IndividualRateZone = 1,
        Value = 0
      }
    },
    BuffId = 306,
    IsAvatarBuff = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [307] = {
    BuffId = 307,
    BuffType = T.RT_337,
    ForbidBuffType = T.RT_338,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    SpecialEffect = T.RT_262
  },
  [308] = {
    BuffId = 308,
    BuffType = {
      20,
      60,
      61
    },
    ForbidBuffType = T.RT_338,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    SpecialEffect = {"Invincible", "Stealth"}
  },
  [309] = {
    ActivateSkills = T.RT_353,
    BuffId = 309,
    DeadNotRemove = true,
    IsAvatarBuff = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310] = {
    ActivateSkills = T.RT_353,
    BuffId = 310,
    DeadNotRemove = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [311] = {
    BuffId = 311,
    DisableSkills = {
      "Skill1",
      "Skill2",
      "Support"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [312] = {
    BuffId = 312,
    BuffType = T.RT_145,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 205,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [402] = {
    AddAttrs = T.RT_20,
    BuffEffects = {4022},
    BuffId = 402,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [406] = {
    BuffDamageRate = T.RT_26,
    BuffId = 406,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Damage_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [408] = {
    BuffDamagedRate = T.RT_26,
    BuffEffects = {4081},
    BuffId = 408,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [409] = {
    BuffEffects = {4091},
    BuffId = 409,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = T.RT_69,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [411] = {
    AddAttrs = T.RT_443,
    BuffId = 411,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Def_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [412] = {
    AddAttrs = T.RT_20,
    BuffEffects = {4122},
    BuffId = 412,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [413] = {
    AddAttrs = T.RT_181,
    BuffId = 413,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Sustain_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [415] = {
    AddAttrs = T.RT_443,
    BuffEffects = {4152},
    BuffId = 415,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Def_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [416] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        DamageTag = "Skill",
        RateZone = "Normal",
        Value = "#1"
      }
    },
    BuffId = 416,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Def_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [421] = {
    AddAttrs = T.RT_54,
    BuffEffects = {4212},
    BuffId = 421,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [422] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = "#1"
      }
    },
    BuffEffects = {4222},
    BuffId = 422,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [423] = {
    AddAttrs = T.RT_376,
    BuffEffects = {4232},
    BuffId = 423,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Multishoot_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [424] = {
    AddAttrs = T.RT_83,
    BuffEffects = {4242},
    BuffId = 424,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [425] = {
    AddAttrs = T.RT_74,
    BuffEffects = {4252},
    BuffId = 425,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Berserk",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [426] = {
    AddAttrs = {
      [1] = {
        AttrName = "BonusDamage",
        Type = "Light",
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_114,
    BuffEffects = {4262},
    BuffId = 426,
    BuffType = T.RT_22,
    BuffTypeImgPath = "BonusDmg_Light",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [801] = {
    AddAttrs = {
      [1] = T.RT_507
    },
    BuffId = 801,
    CombatConditionId = 502,
    IsAvatarBuff = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [802] = {
    AddAttrs = {
      [1] = T.RT_508,
      [2] = T.RT_507
    },
    BuffId = 802,
    CombatConditionId = 502,
    IsAvatarBuff = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [803] = {
    AddAttrs = {
      [1] = T.RT_509,
      [2] = T.RT_508,
      [3] = T.RT_507
    },
    BuffId = 803,
    CombatConditionId = 502,
    IsAvatarBuff = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [804] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = "#4"},
      [2] = T.RT_509,
      [3] = T.RT_508,
      [4] = T.RT_507
    },
    BuffId = 804,
    CombatConditionId = 502,
    IsAvatarBuff = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [901] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_901.BP_Buff_901",
    BuffId = 901,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [902] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_901.BP_Buff_901",
    BuffId = 902,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [903] = {
    AllowSkillSustainModify = true,
    BuffId = 903,
    DeadNotRemove = true,
    LockHp = T.RT_217,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [904] = {
    BuffId = 904,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SetCharacterTag = "Interactive"
  },
  [1311] = {
    AddAttrs = T.RT_40,
    BuffId = 1311,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 15,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1312] = {
    AddAttrs = T.RT_62,
    BuffId = 1312,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1313] = {
    AddAttrs = T.RT_178,
    BuffId = 1313,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1314] = {
    AddAttrs = T.RT_178,
    BuffId = 1314,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1315] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "BossDown",
        Value = "#1"
      }
    },
    BuffId = 1315,
    BuffType = T.RT_179,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1316] = {
    AddAttrs = T.RT_40,
    BuffId = 1316,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1430] = {
    BuffId = 1430,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1430001,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1440] = {
    BuffId = 1440,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1440001,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1523] = {
    BuffId = 1523,
    LockHp = T.RT_217,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1526] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        IndividualRateZone = 1,
        Value = -0.15
      }
    },
    BuffId = 1526,
    ForbidCatch = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [1800] = {
    AddAttrs = T.RT_178,
    BuffId = 1800,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1911] = {
    AddAttrs = T.RT_42,
    BuffId = 1911,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 15,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1921] = {
    AddAttrs = {
      [1] = {AttrName = "SkillSpeed", ValueUseValue = 1}
    },
    BuffId = 1921,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1922] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        BaseUseValue = 1,
        Rate = "#1",
        SupLimitValue = 275
      }
    },
    BuffId = 1922,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1931] = {
    AddAttrs = T.RT_20,
    BuffId = 1931,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 120,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1941] = {
    AddAttrs = T.RT_83,
    BuffId = 1941,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 8,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [1951] = {
    AddAttrs = T.RT_62,
    BuffId = 1951,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1952] = {
    AddAttrs = T.RT_74,
    BuffId = 1952,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Berserk",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1961] = {
    BuffId = 1961,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1961001,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1962] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        RateUseValue = 1,
        SupLimitRate = "#1"
      }
    },
    BuffId = 1962,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2301] = {
    AddAttrs = T.RT_287,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_323,
    BuffId = 2301,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2302] = {
    AddAttrs = {
      [1] = {
        AttrName = "TriggerProbModifierRate",
        Stackable = 1,
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_325,
    BuffId = 2302,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2311] = {
    AddAttrs = T.RT_130,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 2311,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [2312] = {
    AddAttrs = {
      [1] = T.RT_326
    },
    BuffId = 2312,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2321] = {
    AddAttrs = T.RT_133,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 2321,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [2322] = {
    AddAttrs = T.RT_125,
    AddPassiveEffect = T.RT_79,
    BuffEffects = {1026},
    BuffId = 2322,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Range_Up",
    IsShowInBillboard = true,
    MaxLayer = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [3301] = {
    AddAttrs = T.RT_130,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 3301,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [3311] = {
    AddAttrs = T.RT_133,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 3311,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [3312] = {
    AddAttrs = {
      [1] = T.RT_326,
      [2] = {
        AttrName = "SlideVelocityModifier",
        Value = "#1"
      },
      [3] = {
        AttrName = "BulletJumpVelocityModifier",
        Value = "#1"
      }
    },
    BuffId = 3312,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [3321] = {
    AddAttrs = T.RT_129,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_325,
    BuffId = 3321,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [3331] = {
    AddAttrs = T.RT_376,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_308,
    BuffId = 3331,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Multishoot_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [3342] = {
    AddAttrs = T.RT_284,
    BuffEffects = T.RT_84,
    BuffId = 3342,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [3703] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_3703.BP_Buff_3703",
    BuffId = 3703,
    BuffType = {
      21,
      41,
      3703
    },
    ForbidBuffType = {3703},
    HitReplace = T.RT_147,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SetCharacterTag = "StunFloat",
    SpecialEffect = {"Breakable"}
  },
  [4205] = {
    BuffId = 4205,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6111] = {
    AddAttrs = T.RT_170,
    AddPassiveEffect = T.RT_117,
    BuffId = 6111,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6113] = {
    BuffId = 6113,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6114,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6114] = {
    AddAttrs = T.RT_133,
    BuffId = 6114,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6121] = {
    BuffId = 6121,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6122,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6122] = {
    AddAttrs = T.RT_178,
    BuffId = 6122,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6123] = {
    BuffId = 6123,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6124,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6124] = {
    AddAttrs = T.RT_54,
    BuffId = 6124,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6131] = {
    AddAttrs = T.RT_165,
    BuffId = 6131,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6133] = {
    BuffId = 6133,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6134,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6134] = {
    AddAttrs = T.RT_290,
    BuffId = 6134,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6141] = {
    AddAttrs = T.RT_62,
    BuffId = 6141,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6143] = {
    BuffId = 6143,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6144,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6144] = {
    AddAttrs = T.RT_54,
    BuffId = 6144,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6151] = {
    AddAttrs = T.RT_62,
    BuffId = 6151,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6153] = {
    BuffId = 6153,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6154,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6154] = {
    AddAttrs = T.RT_74,
    BuffId = 6154,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6161] = {
    AddAttrs = T.RT_54,
    BuffId = 6161,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6163] = {
    BuffId = 6163,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 6164,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6164] = {
    AddAttrs = T.RT_42,
    BuffId = 6164,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102] = {
    AddAttrs = T.RT_20,
    BuffEffects = T.RT_21,
    BuffId = 10102,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        ValueUseValue = 1
      }
    },
    BuffEffects = T.RT_56,
    BuffId = 10107,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10201] = {
    AddAttrs = T.RT_78,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 10201,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 12,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [10203] = {
    AddAttrs = T.RT_83,
    BuffEffects = T.RT_84,
    BuffId = 10203,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    CombatConditionId = 1004,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10204] = {
    AddAttrs = T.RT_87,
    BuffEffects = T.RT_88,
    BuffId = 10204,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Berserk",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10209] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Stackable = 1,
        Type = "Melee",
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 10209,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MaxLayer = 25,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10301] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillSustain",
        Rate = "#1",
        Stackable = 1
      }
    },
    BuffEffects = {1006},
    BuffId = 10301,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Sustain_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [10304] = {
    AddAttrs = T.RT_62,
    BuffId = 10304,
    BuffInitEffects = T.RT_99,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [10501] = {
    AddAttrs = T.RT_123,
    BuffId = 10501,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Hp_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [10502] = {
    AddAttrs = T.RT_83,
    BuffEffects = T.RT_84,
    BuffId = 10502,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10503] = {
    AddAttrs = T.RT_125,
    AddPassiveEffect = T.RT_79,
    BuffId = 10503,
    BuffType = T.RT_126,
    DisperseBuffType = T.RT_127,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10504] = {
    AddAttrs = T.RT_130,
    AddPassiveEffect = T.RT_79,
    BuffId = 10504,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10602] = {
    AddAttrs = T.RT_20,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 10602,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [10603] = {
    AddAttrs = T.RT_133,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 10603,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10604] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Attack",
        RateZone = "Normal",
        Stackable = 1,
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_84,
    BuffId = 10604,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20103] = {
    AddAttrs = T.RT_284,
    BuffEffects = T.RT_84,
    BuffId = 20103,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20104] = {
    AddAttrs = T.RT_287,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 20104,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 15,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20201] = {
    AddAttrs = T.RT_78,
    AddPassiveEffect = T.RT_79,
    BuffId = 20201,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20203] = {
    BuffId = 20203,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20205] = {
    AddAttrs = T.RT_307,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_308,
    BuffId = 20205,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Multishoot_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20207] = {
    BuffId = 20207,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 2020701,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    MaxLayer = 9,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20301] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Stackable = 1,
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_21,
    BuffId = 20301,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20302] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Normal",
        Stackable = 1,
        Value = "#1"
      },
      [2] = T.RT_306
    },
    BuffId = 20302,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20303] = {
    AddAttrs = T.RT_40,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_163,
    BuffId = 20303,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20304] = {
    AddAttrs = T.RT_307,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_308,
    BuffId = 20304,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Multishoot_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20305] = {
    AddAttrs = T.RT_78,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 20305,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20405] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillEfficiency",
        Rate = "#1"
      }
    },
    BuffEffects = T.RT_310,
    BuffId = 20405,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Effi_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20407] = {
    AddAttrs = {
      [1] = T.RT_190
    },
    BuffEffects = T.RT_99,
    BuffId = 20407,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20502] = {
    AddAttrs = T.RT_219,
    BuffEffects = T.RT_84,
    BuffId = 20502,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20506] = {
    AddAttrs = T.RT_78,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 20506,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20509] = {
    AddAttrs = T.RT_40,
    BuffEffects = T.RT_163,
    BuffId = 20509,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [20510] = {
    AddAttrs = T.RT_40,
    BuffEffects = T.RT_163,
    BuffId = 20510,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 9,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20511] = {
    AddAttrs = T.RT_130,
    AddPassiveEffect = T.RT_79,
    BuffEffects = T.RT_80,
    BuffId = 20511,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20512] = {
    AddAttrs = T.RT_62,
    BuffId = 20512,
    BuffInitEffects = T.RT_99,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [20603] = {
    AddAttrs = T.RT_83,
    BuffEffects = T.RT_84,
    BuffId = 20603,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100001] = {
    BuffId = 100001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 100002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100002] = {
    AddAttrs = T.RT_2,
    BuffId = 100002,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [100003] = {
    BuffId = 100003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 100004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100004] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Normal",
        Value = 0.08
      }
    },
    BuffId = 100004,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [100005] = {
    BuffId = 100005,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 100006,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100006] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Normal",
        Value = 0.08
      }
    },
    BuffId = 100006,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [100007] = {
    BuffId = 100007,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 100008,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100008] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = 0.4}
    },
    BuffId = 100008,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [100009] = {
    BuffId = 100009,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 100010,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [100010] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Value = 0.4
      }
    },
    BuffId = 100010,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [110001] = {
    BuffId = 110001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 110002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110002] = {
    AddAttrs = T.RT_2,
    BuffId = 110002,
    CombatConditionId = 1001,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [110003] = {
    BuffId = 110003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 110004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110004] = {
    AddAttrs = T.RT_136,
    BuffId = 110004,
    CombatConditionId = 1001,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [110101] = {
    ActivateSkills = {
      [110102] = 110121
    },
    AllowSkillSustainModify = true,
    BuffId = 110101,
    BuffType = T.RT_137,
    DisableSkills = {"FallAttack"},
    DotDatas = {
      [1] = {
        DotDelay = 1,
        Interval = 1,
        Type = "SpChange",
        Value = -30
      }
    },
    EmissiveIntensity = {Hair = 150},
    EyeStrength = 1500,
    FresnelParams = {
      FresnelColor = T.RT_138,
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = {Default = 10, FresnelColor = 10}
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    RemoveWhenSpZero = true,
    UseSummonWeapon = 1,
    VisualEffects = T.RT_140
  },
  [110102] = {
    ActivateSkills = {
      [110101] = 110111
    },
    BuffId = 110102,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110111] = {
    AddAttrs = T.RT_142,
    BuffId = 110111,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Effi_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [110112] = {
    AddAttrs = T.RT_144,
    BuffId = 110112,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110201] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_110201.BP_Buff_110201",
    BuffId = 110201,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Rou_BG06_01",
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [1] = 110211,
      [30] = 110212
    },
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110202] = {
    ActivateSkills = {
      [110202] = 110221
    },
    AddAttrs = {
      [1] = {
        AllowSkillIntensity = 1,
        AttrName = "WeaponCRDModifierRate",
        Type = "Melee",
        Value = 0.8
      }
    },
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_110202.BP_Buff_110202",
    BuffId = 110202,
    BuffType = {11, 110202},
    BuffTypeImgPath = "Crd_Up",
    CameraParam = {
      "FuluoSkill02",
      "0.5",
      "3"
    },
    DotDatas = {
      [1] = {
        DotDelay = 3,
        Interval = 1,
        Type = "SpChange",
        Value = -30
      }
    },
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    VisualEffects = {110205}
  },
  [110203] = {
    AddPassiveEffect = T.RT_146,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_110203.BP_Buff_110203",
    BuffEffects = {110201, 110202},
    BuffId = 110203,
    BuffType = {
      21,
      41,
      49,
      110203
    },
    BuffTypeImgPath = "Stun",
    ForbidBuffType = T.RT_146,
    HitReplace = T.RT_147,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SetCharacterTag = "StunFloat"
  },
  [110211] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Type = "Melee",
        Value = 0.75
      }
    },
    BuffId = 110211,
    CombatConditionId = 71,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110212] = {
    BuffId = 110212,
    BuffSpModify = {
      [110201] = T.RT_148,
      [110211] = T.RT_148
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110221] = {
    BuffId = 110221,
    BuffType = T.RT_149,
    LayerExtraBuff = {
      [6] = 110222
    },
    MaxLayer = 12,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110222] = {
    ActivateSkills = {HeavyAttack = 110205},
    BuffId = 110222,
    BuffType = T.RT_137,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110223] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Value = 0.3
      }
    },
    BuffId = 110223,
    BuffType = T.RT_149,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110231] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_110201.BP_Buff_110201",
    BuffId = 110231,
    MaxLayer = 42,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110301] = {
    AllowSkillSustainModify = true,
    BuffId = 110301,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Common_Debuff",
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [10] = 110312
    },
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110302] = {
    ActivateSkills = {
      [110301] = 110311,
      [110302] = 110321
    },
    AllowSkillSustainModify = true,
    AttackOnPressedDown = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_110302.BP_Buff_110302",
    BuffId = 110302,
    BuffType = T.RT_150,
    CameraParam = T.RT_151,
    ChangeModel = 110301,
    DisableEmoIdle = true,
    DisableSkills = {
      "HeavyAttack",
      "SlideAttack"
    },
    DotDatas = {
      [1] = {
        Condition = 110312,
        DotDelay = 3.5,
        Interval = 1,
        Type = "SpChange",
        Value = -30
      },
      [2] = {
        DotDelay = 3.5,
        EffectId = 110323,
        Interval = 1,
        Type = "SkillEffect"
      }
    },
    ForbidenJumpState = T.RT_152,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "Crouch",
      "Slide",
      "Interactive",
      "Seating"
    },
    UseSummonWeapon = 1,
    VisualEffects = {110324}
  },
  [110303] = {
    AddAttrs = {
      [1] = T.RT_153,
      [2] = T.RT_154,
      [3] = T.RT_155
    },
    BuffId = 110303,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110304] = {
    BuffDamagedRate = T.RT_156,
    BuffId = 110304,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110311] = {
    AddAttrs = {
      [1] = T.RT_157
    },
    AllowSkillSustainModify = true,
    BuffId = 110311,
    BuffInitEffects = T.RT_158,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Range_Up",
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [110312] = {
    BuffId = 110312,
    FXMID = T.RT_11,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {110303}
  },
  [110331] = {
    AddAttrs = {
      [1] = T.RT_153,
      [2] = T.RT_159
    },
    BuffEffects = {110302},
    BuffId = 110331,
    EnableRimLightModel = true,
    FresnelParams = {
      FresnelColor = {
        1,
        0.009047,
        0.058806,
        0
      },
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = {Default = 5}
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetSeParam = {isTuosi02 = 1},
    VisualEffects = {
      110321,
      110322,
      110323
    }
  },
  [110341] = {
    AddAttrs = {
      [1] = T.RT_157,
      [2] = T.RT_160
    },
    AllowSkillSustainModify = true,
    BuffId = 110341,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Range_Up",
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [110399] = {
    AddAttrs = {
      [1] = T.RT_154,
      [2] = T.RT_155
    },
    BuffId = 110399,
    BuffType = T.RT_150,
    CameraParam = T.RT_151,
    DisableEmoIdle = true,
    DisableSkills = {
      "HeavyAttack",
      "SlideAttack",
      "Skill2"
    },
    ForbidenJumpState = T.RT_152,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "Crouch",
      "Slide",
      "Seating"
    },
    UseSummonWeapon = 1
  },
  [110401] = {
    ActivateSkills = {
      [110401] = 110421
    },
    BuffId = 110401,
    BuffType = T.RT_161,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110402] = {
    ActivateSkills = {
      [110401] = 110441
    },
    BuffId = 110402,
    BuffType = T.RT_161,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110411] = {
    BuffId = 110411,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Common_Buff",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_162
  },
  [110412] = {
    BuffEffects = T.RT_163,
    BuffId = 110412,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110413] = {
    BuffEffects = {1040},
    BuffId = 110413,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110414] = {
    BuffEffects = {1031},
    BuffId = 110414,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [110431] = {
    AddAttrs = T.RT_165,
    BuffId = 110431,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120101] = {
    BuffId = 120101,
    EffectCreatureID = 120111,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120102] = {
    AddAttrs = T.RT_170,
    AddPassiveEffect = T.RT_117,
    AllowSkillSustainModify = true,
    BuffId = 120102,
    BuffType = T.RT_22,
    BuffTypeImgPath = "BonusDmg_Dark",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {120113}
  },
  [120103] = {
    AddAttrs = T.RT_172,
    AllowSkillSustainModify = true,
    BuffId = 120103,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [120111] = {
    BuffId = 120111,
    ChangeWeaponNotClearCombo = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120112] = {
    AddAttrs = T.RT_175,
    BuffId = 120112,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Ignore",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120121] = {
    BuffId = 120121,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 120122,
        Camp = "Enemy"
      },
      [2] = {
        AuraRange = -1,
        BuffId = 120123,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120122] = {
    AddPassiveEffect = {120104},
    BuffId = 120122,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Dark_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {120132}
  },
  [120123] = {
    AddPassiveEffect = {120103},
    BuffId = 120123,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120221] = {
    ActivateSkills = {
      [310401] = 310412
    },
    AllowSkillSustainModify = true,
    BuffId = 120221,
    BuffType = T.RT_176,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120231] = {
    BuffId = 120231,
    BuffType = T.RT_3,
    ChangeWeaponNotClearCombo = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [120232] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "HeavyAttack",
        RateZone = "Normal",
        Stackable = 1,
        Value = 0.1
      }
    },
    AddPassiveEffect = {310402},
    BuffEffects = T.RT_84,
    BuffId = 120232,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 240,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150001] = {
    BuffId = 150001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 150002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150002] = {
    AddAttrs = T.RT_2,
    BuffId = 150002,
    CombatConditionId = 1006,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [150003] = {
    BuffId = 150003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 150004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150004] = {
    AddAttrs = T.RT_136,
    BuffId = 150004,
    CombatConditionId = 1006,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [150101] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackRangeModifierValue",
        Stackable = 1,
        Type = "Ultra",
        Value = 120
      },
      [2] = {
        AttrName = "TriggerProbModifierRate",
        Stackable = 1,
        Type = "Ultra",
        Value = "#1"
      }
    },
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_150101.BP_Buff_150101",
    BuffId = 150101,
    LayerExtraBuff = {
      [3] = 150111
    },
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150102] = {
    ActivateSkills = {
      [150102] = 150121
    },
    AllowSkillSustainModify = true,
    BuffId = 150102,
    BuffType = T.RT_137,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UseSummonWeapon = 1
  },
  [150103] = {
    AllowSkillSustainModify = true,
    BuffDamagedRate = T.RT_182,
    BuffId = 150103,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Baonu",
    CannotBeHitted = true,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [150104] = {
    AddAttrs = {
      [1] = {
        AttrName = "BonusDamage",
        Type = "Light",
        Value = 0.3
      }
    },
    AddPassiveEffect = T.RT_114,
    BuffId = 150104,
    BuffType = T.RT_3,
    BuffTypeImgPath = "BonusDmg_Light",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150111] = {
    BuffId = 150111,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetSeParam = {BaonuState = 1},
    VisualEffects = T.RT_183
  },
  [150121] = {
    BuffId = 150121,
    FresnelParams = {
      FresnelColor = {
        1,
        0.2,
        0.11,
        1
      },
      FresnelColorRange = {Default = 0.6},
      FresnelColorStrength = T.RT_184
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150141] = {
    AddAttrs = T.RT_186,
    BuffId = 150141,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150201] = {
    ActivateSkills = {
      [150201] = 150211
    },
    BuffId = 150201,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150203] = {
    ActivateSkills = {
      [150201] = 150213
    },
    BuffId = 150203,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150211] = {
    BuffId = 150211,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [150212] = {
    BuffId = 150212,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [150214] = {
    AddAttrs = T.RT_188,
    BuffId = 150214,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [150215] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = -0.25}
    },
    BuffId = 150215,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Atk_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [150221] = {
    ActivateSkills = {
      [150201] = 150212
    },
    AddAttrs = {
      [1] = {
        AttrName = "TriggerProbModifierRate",
        Value = 0.6
      },
      [2] = T.RT_190
    },
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_150221.BP_Buff_150221",
    BuffId = 150221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    FresnelParams = {
      FresnelColor = {
        0.031026,
        1,
        0.980104,
        0
      },
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = {Default = 15}
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {3001}
  },
  [150222] = {
    AddAttrs = {
      [1] = {AttrName = "SkillRange", RateUseValue = 1}
    },
    AllowSkillSustainModify = true,
    BuffId = 150222,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150223] = {
    AllowSkillSustainModify = true,
    BuffId = 150223,
    BuffType = T.RT_3,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150231] = {
    AddAttrs = {
      [1] = {AttrName = "SpRate", Value = 0.25}
    },
    BuffId = 150231,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150301] = {
    AddAttrs = T.RT_193,
    BuffId = 150301,
    BuffSpModify = T.RT_194,
    LayerExtraBuff = T.RT_195,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150302] = {
    AddAttrs = T.RT_198,
    BuffId = 150302,
    BuffSpModify = T.RT_199,
    LayerExtraBuff = T.RT_200,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150305] = {
    BuffId = 150305,
    BuffSpModify = {
      [150302] = T.RT_148
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150306] = {
    BuffId = 150306,
    BuffSpModify = {
      [150321] = T.RT_148
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150307] = {
    AddAttrs = T.RT_193,
    BuffId = 150307,
    BuffSpModify = T.RT_194,
    LayerExtraBuff = T.RT_195,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150308] = {
    AddAttrs = T.RT_198,
    BuffId = 150308,
    BuffSpModify = T.RT_199,
    LayerExtraBuff = T.RT_200,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150311] = {
    AddAttrs = T.RT_202,
    BuffId = 150311,
    BuffType = T.RT_203,
    DisperseBuffType = T.RT_204,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150312] = {
    AddAttrs = T.RT_72,
    BuffId = 150312,
    BuffType = T.RT_204,
    DisperseBuffType = T.RT_203,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150313] = {
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_150313.BP_Buff_150313",
    BuffId = 150313,
    BuffType = {150313, 10},
    BuffTypeImgPath = "Weapon_Spd_Up",
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [150320] = {
    ActivateSkills = {Attack = 1503101},
    BuffId = 150320,
    BuffType = {150320},
    DisperseBuffType = {
      150321,
      150322,
      150323,
      150324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UseSummonWeapon = 1
  },
  [150321] = {
    ActivateSkills = {Attack = 1503121},
    BuffId = 150321,
    BuffType = {150321},
    DisperseBuffType = {
      150320,
      150322,
      150323,
      150324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UseSummonWeapon = 2
  },
  [150322] = {
    ActivateSkills = {Attack = 1503141},
    BuffId = 150322,
    BuffType = {150322},
    DisperseBuffType = {
      150320,
      150321,
      150323,
      150324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UseSummonWeapon = 3
  },
  [150323] = {
    ActivateSkills = {Attack = 1503161},
    BuffId = 150323,
    BuffType = {150323},
    DisperseBuffType = {
      150320,
      150321,
      150322,
      150324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UseSummonWeapon = 4
  },
  [150325] = {
    ActivateSkills = {
      [150302] = 150321
    },
    AddAttrs = {
      [1] = {
        AttrName = "AttackRangeModifierValue",
        Value = 100
      }
    },
    BuffId = 150325,
    BuffType = {150325},
    CameraParam = {
      "KezhouSkill02",
      "0.5",
      "6"
    },
    FresnelParams = {
      FresnelColor = {
        0,
        0.123,
        1,
        0
      },
      FresnelColorRange = T.RT_205,
      FresnelColorStrength = {Default = 45}
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {
      150327,
      150328,
      150329
    }
  },
  [150326] = {
    AddAttrs = T.RT_207,
    BuffEffects = T.RT_84,
    BuffId = 150326,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150327] = {
    BuffDamagedRate = T.RT_156,
    BuffId = 150327,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damaged_Down",
    ForbidCatch = true,
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [150328] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Stackable = 1,
        Value = 0.03
      }
    },
    BuffId = 150328,
    BuffInitEffects = T.RT_208,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Ignore",
    IconPriority = 99,
    IsShowInBillboard = true,
    MaxLayer = 18,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150329] = {
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_150301.BP_Buff_150301",
    BuffId = 150329,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {150330}
  },
  [150331] = {
    BuffId = 150331,
    BuffType = {150331},
    DisperseBuffType = {
      150332,
      150333,
      150334
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503104] = 1503202
    }
  },
  [150332] = {
    BuffId = 150332,
    BuffType = {150332},
    DisperseBuffType = {
      150331,
      150333,
      150334
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503104] = 1503203
    }
  },
  [150333] = {
    BuffId = 150333,
    BuffType = {150333},
    DisperseBuffType = {
      150331,
      150332,
      150334
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503104] = 1503204
    }
  },
  [150341] = {
    BuffId = 150341,
    BuffType = {150341},
    DisperseBuffType = {
      150342,
      150343,
      150344
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503124] = 1503201
    }
  },
  [150342] = {
    BuffId = 150342,
    BuffType = {150342},
    DisperseBuffType = {
      150341,
      150343,
      150344
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503124] = 1503203
    }
  },
  [150343] = {
    BuffId = 150343,
    BuffType = {150343},
    DisperseBuffType = {
      150341,
      150342,
      150344
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503124] = 1503204
    }
  },
  [150351] = {
    BuffId = 150351,
    BuffType = {150351},
    DisperseBuffType = {
      150352,
      150353,
      150354
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503144] = 1503201
    }
  },
  [150352] = {
    BuffId = 150352,
    BuffType = {150352},
    DisperseBuffType = {
      150351,
      150353,
      150354
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503144] = 1503202
    }
  },
  [150353] = {
    BuffId = 150353,
    BuffType = {150353},
    DisperseBuffType = {
      150351,
      150352,
      150354
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503144] = 1503204
    }
  },
  [150361] = {
    BuffId = 150361,
    BuffType = {150361},
    DisperseBuffType = {
      150362,
      150363,
      150364
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503164] = 1503201
    }
  },
  [150362] = {
    BuffId = 150362,
    BuffType = {150362},
    DisperseBuffType = {
      150361,
      150363,
      150364
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503164] = 1503202
    }
  },
  [150363] = {
    BuffId = 150363,
    BuffType = {150363},
    DisperseBuffType = {
      150361,
      150362,
      150364
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceSkillNodes = {
      [1503164] = 1503203
    }
  },
  [150371] = {
    AddAttrs = T.RT_193,
    BuffId = 150371,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150372] = {
    AddAttrs = T.RT_198,
    BuffId = 150372,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150373] = {
    AddAttrs = T.RT_193,
    BuffId = 150373,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150374] = {
    AddAttrs = T.RT_198,
    BuffId = 150374,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150401] = {
    ActivateSkills = {
      [30] = 150405,
      [150402] = 150421
    },
    AddAttrs = {
      [1] = {
        AttrName = "WalkSpeedModifier",
        Value = 0.3
      }
    },
    BuffId = 150401,
    BuffType = T.RT_137,
    DisableSkills = T.RT_81,
    DotDatas = {
      [1] = {
        Condition = 72,
        DotDelay = 2,
        EffectId = 150472,
        Interval = 5,
        Type = "SkillEffect"
      }
    },
    EnableAnimFly = true,
    ExecSkillEffectWhenRemoved = {150423},
    ForbidCatch = true,
    ForbidenJumpState = T.RT_209,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {"Hit", "Seating"},
    UseSummonWeapon = 1,
    VisualEffects = T.RT_210,
    bHeavyAttack2Attack = true
  },
  [150402] = {
    BuffId = 150402,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150403] = {
    AddAttrs = T.RT_212,
    AllowSkillSustainModify = true,
    BuffId = 150403,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150404] = {
    AddAttrs = {
      [1] = T.RT_211,
      [2] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Stackable = 1,
        Value = 0.045
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 150404,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150405] = {
    ActivateSkills = {
      [150422] = 150431
    },
    BuffId = 150405,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150407] = {
    ActivateSkills = {
      [150401] = 150411
    },
    BuffId = 150407,
    BuffType = {
      150407,
      70,
      73
    },
    CameraParam = {
      "SuyiSkill01JetRush",
      "0.2",
      "50"
    },
    DisperseBuffType = {150408, 150409},
    DotDatas = T.RT_214,
    ExecSkillEffectWhenRemoved = T.RT_210,
    ForbidCatch = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "Hit",
      "Interactive",
      "Seating",
      "LandHeavy",
      "Crouch",
      "Slide"
    },
    VisualEffects = {150481}
  },
  [150408] = {
    BuffId = 150408,
    BuffType = {150408, 70},
    DisperseBuffType = {150407, 150409},
    DotDatas = T.RT_214,
    ForbidenJumpState = T.RT_209,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "Interactive",
      "Seating",
      "LandHeavy",
      "Crouch"
    },
    VisualEffects = {150477}
  },
  [150409] = {
    BuffId = 150409,
    BuffType = {150409},
    DisperseBuffType = {150407, 150408},
    DotDatas = {
      [1] = {
        DotDelay = 1,
        Interval = 0.2,
        Type = "SecondSpChange",
        Value = 2
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150410] = {
    BuffId = 150410,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {150445}
  },
  [150421] = {
    BuffId = 150421,
    MaxLayer = 200,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [150424] = {
    ActivateSkills = {
      [150422] = 150421,
      [150431] = 150421,
      [150441] = 150421
    },
    BuffId = 150424,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150501] = {
    ActivateSkills = {
      [150501] = 150513
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_150501.BP_Buff_150501",
    BuffId = 150501,
    BuffType = T.RT_137,
    CameraParam = T.RT_215,
    DisableSkills = {
      "FallAttack",
      "SlideAttack"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_216,
    SetIdleTag = "SkillIdle",
    UseSummonWeapon = 1
  },
  [150502] = {
    BuffId = 150502,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [12] = 150521
    },
    MaxLayer = 12,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [150503] = {
    AllowSkillSustainModify = true,
    BuffId = 150503,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [2] = 150531
    },
    MaxLayer = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_183
  },
  [150521] = {
    ActivateSkills = {
      [150502] = 150521
    },
    BuffId = 150521,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_162
  },
  [150531] = {
    BuffId = 150531,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_140
  },
  [160101] = {
    AddAttrs = T.RT_219,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_220,
    BuffId = 160101,
    BuffType = {10, 160101},
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_162
  },
  [160102] = {
    AddAttrs = T.RT_172,
    AllowSkillSustainModify = true,
    BuffId = 160102,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [160103] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeedModifierRate",
        Stackable = 1,
        Value = 0.09
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 160103,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [160104] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Value = 0.54
      },
      [2] = T.RT_218
    },
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_220,
    BuffId = 160104,
    BuffType = {10, 160104},
    BuffTypeImgPath = "Damage_Up",
    DisperseBuffType = T.RT_221,
    ForbidBuffType = T.RT_221,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_162
  },
  [160105] = {
    AddAttrs = T.RT_92,
    AllowSkillSustainModify = true,
    BuffId = 160105,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180101] = {
    AddAttrs = {
      [1] = {
        AllowSkillIntensity = 1,
        AttrName = "BonusDamage",
        Type = "Light",
        Value = "#1"
      }
    },
    AddPassiveEffect = T.RT_114,
    BuffId = 180101,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180102] = {
    ActivateSkills = {
      [180101] = 180111,
      [180102] = 180121
    },
    AllowSkillSustainModify = true,
    BuffId = 180102,
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "SpChange",
        Value = -12
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [180111] = {
    AddAttrs = T.RT_223,
    AllowSkillSustainModify = true,
    BuffId = 180111,
    BuffInitEffects = T.RT_224,
    BuffType = T.RT_225,
    BuffTypeImgPath = "BonusDmg_Light",
    FresnelParams = T.RT_229,
    IconPriority = 8,
    IsShowInBillboard = true,
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_230
  },
  [180112] = {
    AddAttrs = T.RT_223,
    AllowSkillSustainModify = true,
    BuffId = 180112,
    BuffInitEffects = T.RT_224,
    BuffType = T.RT_225,
    BuffTypeImgPath = "BonusDmg_Light",
    FresnelParams = T.RT_229,
    IconPriority = 8,
    IsShowInBillboard = true,
    MaxLayer = 45,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_230
  },
  [180113] = {
    AddAttrs = T.RT_95,
    AllowSkillSustainModify = true,
    BuffId = 180113,
    BuffInitEffects = T.RT_231,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180114] = {
    AddAttrs = {
      [1] = T.RT_222,
      [2] = {
        AttrName = "SkillIntensity",
        Rate = 0.02,
        Stackable = 1
      },
      [3] = {
        AttrName = "SkillRange",
        Rate = 0.01,
        Stackable = 1
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 180114,
    BuffInitEffects = T.RT_224,
    BuffType = T.RT_225,
    BuffTypeImgPath = "BonusDmg_Light",
    FresnelParams = T.RT_229,
    IconPriority = 8,
    IsShowInBillboard = true,
    MaxLayer = 45,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_230
  },
  [180121] = {
    BuffId = 180121,
    BuffType = T.RT_232,
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 180122,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180122] = {
    BuffId = 180122,
    BuffType = T.RT_233,
    BuffTypeImgPath = "Dot_Water",
    DotDatas = {
      [1] = {
        AllowSkillIntensity = 1,
        DamageTag = T.RT_234,
        DamageType = "Water",
        Immediately = 1,
        Interval = 2,
        Rate = "#1",
        Type = "Dot"
      }
    },
    FXMID = T.RT_76,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180123] = {
    BuffId = 180123,
    BuffType = T.RT_232,
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 180124,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180124] = {
    BuffId = 180124,
    BuffType = T.RT_233,
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = T.RT_236,
    FXMID = T.RT_93,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180125] = {
    BuffId = 180125,
    BuffType = T.RT_232,
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 180126,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180126] = {
    BuffId = 180126,
    BuffType = T.RT_233,
    BuffTypeImgPath = "Dot_Thunder",
    DotDatas = T.RT_238,
    FXMID = T.RT_120,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180127] = {
    BuffId = 180127,
    BuffType = T.RT_232,
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 180128,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180128] = {
    BuffId = 180128,
    BuffType = T.RT_233,
    BuffTypeImgPath = "Dot_Wind",
    DotDatas = T.RT_240,
    FXMID = T.RT_121,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180131] = {
    AddAttrs = {
      [1] = T.RT_241
    },
    AddPassiveEffect = T.RT_102,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_242,
    BuffId = 180131,
    BuffType = {
      10,
      180130,
      180131
    },
    BuffTypeImgPath = "BonusDmg_Water",
    IconPriority = 23,
    IsShowInBillboard = true,
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180132] = {
    AddAttrs = {
      [1] = T.RT_243
    },
    AddPassiveEffect = T.RT_105,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_244,
    BuffId = 180132,
    BuffType = {
      10,
      180130,
      180132
    },
    BuffTypeImgPath = "BonusDmg_Fire",
    IconPriority = 22,
    IsShowInBillboard = true,
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180133] = {
    AddAttrs = {
      [1] = T.RT_245
    },
    AddPassiveEffect = T.RT_108,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_246,
    BuffId = 180133,
    BuffType = {
      10,
      180130,
      180133
    },
    BuffTypeImgPath = "BonusDmg_Thunder",
    IconPriority = 21,
    IsShowInBillboard = true,
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180134] = {
    AddAttrs = T.RT_248,
    AddPassiveEffect = T.RT_111,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_249,
    BuffId = 180134,
    BuffType = {
      10,
      180130,
      180134
    },
    BuffTypeImgPath = "BonusDmg_Wind",
    IconPriority = 20,
    IsShowInBillboard = true,
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180135] = {
    AddAttrs = {
      [1] = T.RT_241,
      [2] = T.RT_250
    },
    AddPassiveEffect = T.RT_102,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_242,
    BuffId = 180135,
    BuffType = T.RT_251,
    BuffTypeImgPath = "BonusDmg_Water",
    DisperseBuffType = T.RT_252,
    ForbidBuffType = T.RT_252,
    IconPriority = 23,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180136] = {
    AddAttrs = {
      [1] = T.RT_243,
      [2] = T.RT_250
    },
    AddPassiveEffect = T.RT_105,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_244,
    BuffId = 180136,
    BuffType = T.RT_251,
    BuffTypeImgPath = "BonusDmg_Fire",
    DisperseBuffType = T.RT_253,
    ForbidBuffType = T.RT_253,
    IconPriority = 22,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180137] = {
    AddAttrs = {
      [1] = T.RT_245,
      [2] = T.RT_250
    },
    AddPassiveEffect = T.RT_108,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_246,
    BuffId = 180137,
    BuffType = T.RT_251,
    BuffTypeImgPath = "BonusDmg_Thunder",
    DisperseBuffType = T.RT_254,
    ForbidBuffType = T.RT_254,
    IconPriority = 21,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180138] = {
    AddAttrs = {
      [1] = T.RT_247,
      [2] = T.RT_250
    },
    AddPassiveEffect = T.RT_111,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_249,
    BuffId = 180138,
    BuffType = T.RT_251,
    BuffTypeImgPath = "BonusDmg_Wind",
    DisperseBuffType = T.RT_255,
    ForbidBuffType = T.RT_255,
    IconPriority = 20,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180141] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = 0.01
      }
    },
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_84,
    BuffId = 180141,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 10,
    IsShowInBillboard = true,
    MaxLayer = 45,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [180191] = {
    BuffId = 180191,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 180192,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [180192] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Normal",
        Value = 0.1
      }
    },
    BuffId = 180192,
    CombatConditionId = 1031,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [201001] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = -0.5}
    },
    BuffEffects = {2002},
    BuffId = 201001,
    BuffType = T.RT_189,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [201002] = {
    BuffId = 201002,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Common_Buff_Aura",
    HaloDatas = {
      [1] = {
        AuraRange = 1000,
        BuffId = 201021,
        Camp = "Friend"
      },
      [2] = {
        AuraRange = 1000,
        BuffId = 201022,
        Camp = "Enemy"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {20103}
  },
  [201021] = {
    AddAttrs = T.RT_35,
    BuffId = 201021,
    BuffType = T.RT_22,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        DefaultHealFX = 1,
        Interval = 1,
        Rate = 0.5,
        Type = "Hot"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [201022] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Normal",
        Value = 0.3
      }
    },
    BuffId = 201022,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Fire",
        Immediately = 1,
        Interval = 1,
        Rate = 2,
        Type = "Dot"
      }
    },
    FXMID = T.RT_93,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210001] = {
    BuffId = 210001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210002] = {
    AddAttrs = T.RT_2,
    BuffId = 210002,
    CombatConditionId = 1002,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [210003] = {
    BuffId = 210003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210004] = {
    AddAttrs = T.RT_136,
    BuffId = 210004,
    CombatConditionId = 1002,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [210101] = {
    AddPassiveEffect = T.RT_313,
    AllowSkillSustainModify = true,
    BuffId = 210101,
    BuffType = T.RT_314,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_316,
    DotDeathSe = 210102,
    FXMID = T.RT_317,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    Priority = 999,
    VisualEffects = T.RT_313
  },
  [210103] = {
    AddPassiveEffect = T.RT_313,
    AllowSkillSustainModify = true,
    BuffId = 210103,
    BuffType = T.RT_314,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_316,
    DotDeathSe = 210102,
    FXMID = T.RT_317,
    IsShowInBillboard = true,
    MaxLayer = 8,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    Priority = 999,
    VisualEffects = T.RT_313
  },
  [210105] = {
    BuffId = 210105,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210151,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210106] = {
    BuffId = 210106,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210161,
        Camp = "Friend",
        Filter = "Summon"
      }
    },
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210121] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = 0.03,
        Stackable = 1
      }
    },
    BuffId = 210121,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 50,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210151] = {
    AddPassiveEffect = {210151},
    BuffId = 210151,
    CombatConditionId = 210102,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210161] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = 0.12
      }
    },
    BuffId = 210161,
    CombatConditionId = 210103,
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210201] = {
    BuffEffects = {210222},
    BuffId = 210201,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {210220, 210221}
  },
  [210202] = {
    ActivateSkills = {
      [210202] = 210221
    },
    AllowSkillSustainModify = true,
    BuffId = 210202,
    DotDatas = {
      [1] = {
        DotDelay = 1.5,
        Interval = 1,
        Type = "SpChange",
        Value = -30
      }
    },
    ExecSkillEffectWhenRemoved = {210217},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [210203] = {
    BuffId = 210203,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210204,
        Camp = "Friend"
      }
    },
    InitialEffect = {210211},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210204] = {
    AddPassiveEffect = {210212},
    BuffId = 210204,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210205] = {
    BuffId = 210205,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {210224}
  },
  [210206] = {
    BuffId = 210206,
    BuffType = {210206},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210211] = {
    AddAttrs = {
      [1] = {
        AttrName = "DropDistance",
        Value = 2500
      }
    },
    BuffId = 210211,
    CombatConditionId = 74,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210212] = {
    BuffId = 210212,
    CombatConditionId = 74,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210213,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210213] = {
    AddAttrs = T.RT_318,
    BuffId = 210213,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210214] = {
    BuffId = 210214,
    CombatConditionId = 76,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 210215,
        Camp = "Friend",
        Filter = "Summon"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210215] = {
    AddAttrs = T.RT_320,
    BuffId = 210215,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210216] = {
    BuffId = 210216,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [210291] = {
    ActivateSkills = {
      [210201] = 210217
    },
    BuffId = 210291,
    EnableCopyMode = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [220101] = {
    BuffId = 220101,
    BuffType = T.RT_3,
    HaloDatas = {
      [1] = {
        AuraRange = 600,
        BuffId = 220102,
        Camp = "OtherFriend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [220102] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = 1
      },
      [2] = {
        AttrName = "SkillSpeed",
        Rate = 0.1,
        Stackable = 1
      }
    },
    BuffId = 220102,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    CombatConditionId = 213,
    IsShowInBillboard = true,
    MaxLayer = 24,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_36
  },
  [220113] = {
    AddAttrs = T.RT_142,
    AllowSkillSustainModify = true,
    BuffId = 220113,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Effi_Up",
    IsShowInBillboard = true,
    MaxLayer = 24,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [220121] = {
    BuffId = 220121,
    BuffType = T.RT_3,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 220122,
        Camp = "OtherFriend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [220122] = {
    AddPassiveEffect = {220103},
    BuffId = 220122,
    BuffType = T.RT_22,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [230100] = {
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_230100.BP_Buff_230100",
    BuffId = 230100,
    BuffType = T.RT_96,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RagdollEnable = 1,
    SetCharacterTag = "HitFly",
    VisualEffects = {230104}
  },
  [230101] = {
    AddAttrs = T.RT_83,
    AllowSkillSustainModify = true,
    BuffId = 230101,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {230101}
  },
  [230102] = {
    AllowSkillSustainModify = true,
    BuffId = 230102,
    FresnelParams = {
      FresnelColor = {
        0.291667,
        0,
        0,
        1
      },
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = T.RT_324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [230103] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Stackable = 1,
        Value = 0.08
      }
    },
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_323,
    BuffId = 230103,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [230110] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_230110.BP_Buff_230110",
    BuffId = 230110,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [230121] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Stackable = 1,
        Value = 0.02
      }
    },
    BuffEffects = T.RT_323,
    BuffId = 230121,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 24,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [230122] = {
    BuffId = 230122,
    BuffType = {21, 41},
    DotDatas = {
      [1] = {
        DamageTag = T.RT_234,
        DamageType = "Water",
        Immediately = 1,
        Interval = 2,
        Rate = 2.8,
        Type = "Dot"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240121] = {
    AddAttrs = T.RT_328,
    AllowSkillSustainModify = true,
    BuffId = 240121,
    BuffType = {10, 240121},
    BuffTypeImgPath = "Skill_Inten_Up",
    EffectCreatureID = 240118,
    IconPriority = 15,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SpawnECOnlyPlayer = true,
    VisualEffects = T.RT_329
  },
  [240122] = {
    AddAttrs = T.RT_328,
    AddPassiveEffect = {240104},
    AllowSkillSustainModify = true,
    BuffId = 240122,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    DisperseBuffType = T.RT_329,
    EffectCreatureID = 240118,
    ForbidBuffType = T.RT_329,
    IconPriority = 15,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SpawnECOnlyPlayer = true,
    VisualEffects = T.RT_329
  },
  [240123] = {
    AddAttrs = T.RT_130,
    AllowSkillSustainModify = true,
    BuffId = 240123,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    FresnelParams = T.RT_332,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_333
  },
  [240124] = {
    AddAttrs = {
      [1] = T.RT_85,
      [2] = {
        AttrName = "BonusDamage",
        Type = "Attack",
        Value = 2.2
      }
    },
    AddPassiveEffect = {211},
    AllowSkillSustainModify = true,
    BuffId = 240124,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    FresnelParams = T.RT_332,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_333
  },
  [240131] = {
    BuffId = 240131,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 240132,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240132] = {
    AddPassiveEffect = {240103},
    BuffId = 240132,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [240133] = {
    AddAttrs = T.RT_335,
    AllowSkillSustainModify = true,
    BuffId = 240133,
    BuffType = {10, 240133},
    BuffTypeImgPath = "Skill_Spd_Up",
    IsShowInBillboard = true,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [240134] = {
    AddAttrs = {
      [1] = T.RT_334,
      [2] = {
        AttrName = "StrongValue",
        Stackable = 1,
        Value = 0.12
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 240134,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Spd_Up",
    DisperseBuffType = T.RT_336,
    ForbidBuffType = T.RT_336,
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [240141] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.33,
        Stackable = 1
      }
    },
    BuffId = 240141,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240151] = {
    AddPassiveEffect = {240111},
    BuffId = 240151,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Common",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {240151}
  },
  [240152] = {
    BuffId = 240152,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240153] = {
    BuffId = 240153,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240191] = {
    BuffId = 240191,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 240192,
        Camp = "Friend",
        Condition = 1007
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [240192] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Normal",
        Value = 0.1
      }
    },
    BuffId = 240192,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [310001] = {
    BuffId = 310001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 310002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310002] = {
    AddAttrs = T.RT_2,
    BuffId = 310002,
    CombatConditionId = 1003,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [310003] = {
    BuffId = 310003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 310004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310004] = {
    AddAttrs = T.RT_136,
    BuffId = 310004,
    CombatConditionId = 1003,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [310111] = {
    AddPassiveEffect = T.RT_354,
    BuffId = 310111,
    BuffType = T.RT_355,
    BuffTypeImgPath = "Char_Linen_02",
    ForbidBuffType = T.RT_354,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_356
  },
  [310112] = {
    AddPassiveEffect = {310112},
    BuffId = 310112,
    BuffType = T.RT_355,
    BuffTypeImgPath = "Char_Linen_02",
    ForbidBuffType = T.RT_354,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_356
  },
  [310120] = {
    ActivateSkills = T.RT_357,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_310120.BP_Buff_310120",
    BuffId = 310120,
    BuffType = T.RT_150,
    CameraParam = T.RT_215,
    DisableSkills = T.RT_358,
    DotDatas = T.RT_360,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_216,
    ReplaceActions = T.RT_361,
    ReplaceMobileAttackButtonIcon = true,
    SetIdleTag = "SkillIdle",
    UseSummonWeapon = 1
  },
  [310121] = {
    ActivateSkills = T.RT_357,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_310120.BP_Buff_310120",
    BuffDamagedRate = T.RT_182,
    BuffId = 310121,
    BuffType = T.RT_150,
    CameraParam = T.RT_215,
    DisableSkills = T.RT_358,
    DotDatas = T.RT_360,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_216,
    ReplaceActions = T.RT_361,
    ReplaceMobileAttackButtonIcon = true,
    SetIdleTag = "SkillIdle",
    UseSummonWeapon = 1
  },
  [310122] = {
    BuffId = 310122,
    FresnelParams = {
      FresnelColor = T.RT_138,
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = T.RT_324
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true,
    VisualEffects = {
      310121,
      310122,
      310123,
      310124,
      310125,
      310126,
      310127
    }
  },
  [310123] = {
    BuffId = 310123,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [310124] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeedModifierRate",
        Stackable = 1,
        Value = 0.03
      }
    },
    BuffId = 310124,
    MaxLayer = 35,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [310131] = {
    BuffId = 310131,
    BuffType = {11, 310131},
    BuffTypeImgPath = "Char_Linen_01",
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310132] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        ValueUseValue = 1
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 310132,
    BuffType = {10, 310131},
    BuffTypeImgPath = "Char_Linen_02",
    ForbidBuffType = {310131},
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310141] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        Value = 0.35
      }
    },
    BuffEffects = T.RT_56,
    BuffId = 310141,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310203] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = 0.18
      }
    },
    BuffId = 310203,
    BuffInitEffects = T.RT_84,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [310204] = {
    ActivateSkills = T.RT_362,
    AllowSkillSustainModify = true,
    BuffId = 310204,
    DotDatas = T.RT_364,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [310206] = {
    ActivateSkills = T.RT_362,
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Value = 0.6
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 310206,
    DotDatas = T.RT_364,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [310211] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxAvoidExecuteTimes",
        Value = 4
      }
    },
    BuffId = 310211,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310212] = {
    AddAttrs = T.RT_202,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_310201.BP_Buff_310201",
    BuffId = 310212,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Xier",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310213] = {
    AddAttrs = T.RT_202,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_310201.BP_Buff_310201",
    BuffId = 310213,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Xier",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310301] = {
    ActivateSkills = {
      [310302] = 310321
    },
    BuffId = 310301,
    EmissiveIntensity = {Body = 30},
    EyeColor = 2,
    FresnelParams = {
      FresnelColor = {
        15,
        0,
        0,
        0
      },
      FresnelColorRange = T.RT_227,
      FresnelColorStrength = T.RT_365
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetSeParam = {isYeer02 = 1}
  },
  [310302] = {
    BuffId = 310302,
    HaloDatas = {
      [1] = {
        AuraRange = 1500,
        BuffId = 310321,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310303] = {
    ActivateSkills = {
      [310301] = 310311
    },
    BuffId = 310303,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310304] = {
    AddAttrs = T.RT_142,
    AllowSkillSustainModify = true,
    BuffId = 310304,
    BuffInitEffects = T.RT_310,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Effi_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [310311] = {
    BuffId = 310311,
    ForbidBuffType = {
      10,
      11,
      12,
      20,
      21,
      22,
      30,
      40,
      41,
      42,
      43,
      44,
      49,
      60,
      61,
      62,
      63
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [310321] = {
    AddAttrs = T.RT_95,
    BuffId = 310321,
    BuffInitEffects = T.RT_231,
    BuffType = {
      21,
      42,
      310321
    },
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [310323] = {
    AddAttrs = T.RT_367,
    BuffId = 310323,
    BuffInitEffects = T.RT_231,
    BuffType = T.RT_368,
    BuffTypeImgPath = "Slowdown",
    DisperseBuffType = T.RT_369,
    ForbidBuffType = T.RT_369,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [310411] = {
    ActivateSkills = {
      [310401] = 310411
    },
    AddAttrs = T.RT_370,
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_310411.BP_Buff_310411",
    BuffId = 310411,
    BuffType = T.RT_176,
    BuffTypeImgPath = "Common_Buff",
    DisableSkills = {
      "Attack",
      "FallAttack",
      "HeavyAttack",
      "Shooting",
      "HeavyShooting",
      "Reload",
      "SlideAttack"
    },
    DotDatas = {
      [1] = {
        DotDelay = 1,
        Interval = 1,
        Type = "SpChange",
        Value = -10
      }
    },
    EnableFreeRun = true,
    ForbidenJumpState = T.RT_209,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "LandHeavy",
      "Hit",
      "Crouch",
      "Slide",
      "Interactive",
      "Seating"
    },
    RemoveWhenSpZero = true,
    SpecialEffect = T.RT_262
  },
  [320100] = {
    AddAttrs = T.RT_123,
    BuffId = 320100,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        Condition = 2,
        DamageTag = T.RT_67,
        DefaultHealFX = 0,
        Interval = 1,
        Rate = 0.004,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UISpecialEffect = T.RT_371
  },
  [320101] = {
    AddAttrs = T.RT_123,
    BuffId = 320101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        Condition = 2,
        DamageTag = T.RT_67,
        DefaultHealFX = 0,
        Interval = 1,
        Rate = 0.003,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    UISpecialEffect = T.RT_371
  },
  [320102] = {
    BuffId = 320102,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 320103,
        Camp = "OtherFriend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320103] = {
    AddPassiveEffect = {320103},
    BuffId = 320103,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320105] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        Stackable = 1,
        Value = 0.01
      }
    },
    BuffId = 320105,
    BuffType = T.RT_22,
    BuffTypeImgPath = "HaierUltra",
    IconPriority = 99,
    IsShowInBillboard = true,
    MaxLayer = 150,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320111] = {
    AddPassiveEffect = T.RT_372,
    AllowSkillSustainModify = true,
    BuffId = 320111,
    BuffTypeImgPath = "Common_Debuff_Aura",
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 320112,
        Camp = "Enemy"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {
      320103,
      320104,
      320105,
      320106,
      320107,
      320108
    }
  },
  [320112] = {
    BuffId = 320112,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_236,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_372
  },
  [320122] = {
    BuffId = 320122,
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320201] = {
    AddPassiveEffect = {320202},
    BuffId = 320201,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Kami_Enemy",
    IsShowInBillboard = true,
    MaxLayer = 40,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = {320201}
  },
  [320203] = {
    AddAttrs = T.RT_335,
    BuffId = 320203,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Spd_Up",
    ExecSkillEffectWhenRemoved = {320225},
    ForbidCatch = true,
    InitialEffect = {320224},
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [1] = 320231
    },
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    NotEnterCharacterTagType = T.RT_30
  },
  [320205] = {
    BuffId = 320205,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Kami_Friend",
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [20] = 320206
    },
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [320206] = {
    BuffId = 320206,
    InitialEffect = {320241},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320211] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.55
      }
    },
    BuffDamagedRate = {Value = -0.15},
    BuffId = 320211,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320212] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Value = 0.45
      }
    },
    BuffId = 320212,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320231] = {
    BuffId = 320231,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceActions = {Attack = "Skill1"}
  },
  [320232] = {
    BuffId = 320232,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320291] = {
    BuffId = 320291,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 320292,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [320292] = {
    AddAttrs = T.RT_296,
    BuffId = 320292,
    CombatConditionId = 1003,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [330101] = {
    AddAttrs = T.RT_38,
    BuffId = 330101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    EffectCreatureID = 330111,
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [330121] = {
    BuffId = 330121,
    BuffInitEffects = T.RT_55,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [330131] = {
    BuffId = 330131,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 330132,
        Camp = "OtherFriend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [330132] = {
    AddPassiveEffect = {330103},
    BuffId = 330132,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [330141] = {
    BuffId = 330141,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 330142,
        Camp = "OtherFriend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [330142] = {
    AddAttrs = T.RT_374,
    BuffId = 330142,
    BuffInitEffects = T.RT_163,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [410001] = {
    BuffId = 410001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 410002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410002] = {
    AddAttrs = T.RT_2,
    BuffId = 410002,
    CombatConditionId = 1004,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [410003] = {
    BuffId = 410003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 410004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410004] = {
    AddAttrs = T.RT_136,
    BuffId = 410004,
    CombatConditionId = 1004,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [410101] = {
    BuffId = 410101,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410102] = {
    AddAttrs = T.RT_207,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_84,
    BuffId = 410102,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410111] = {
    ActivateSkills = {
      [410102] = 410121
    },
    AddPassiveEffect = {410103},
    AllowSkillSustainModify = true,
    BuffId = 410111,
    DotDatas = {
      [1] = {
        DotDelay = 2,
        Interval = 1,
        Type = "SpChange",
        Value = -20
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [410112] = {
    BuffId = 410112,
    CameraParam = {
      "IncrementDefault",
      "1.1",
      "50"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410121] = {
    AddPassiveEffect = {410104},
    AllowSkillSustainModify = true,
    BuffId = 410121,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Common_Debuff",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {410101}
  },
  [410122] = {
    AddPassiveEffect = {410105},
    AllowSkillSustainModify = true,
    BuffId = 410122,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Common_Debuff",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {410102}
  },
  [410123] = {
    AddAttrs = T.RT_439,
    BuffId = 410123,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    FresnelParams = {
      FresnelColor = {
        0,
        0.01,
        0.1,
        0
      },
      FresnelColorRange = T.RT_205,
      FresnelColorStrength = {Default = 100, FresnelColor = 100}
    },
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 410124,
        Camp = "OtherFriend"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true,
    VisualEffects = {410124, 410129}
  },
  [410124] = {
    AddAttrs = T.RT_439,
    BuffId = 410124,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {410130}
  },
  [410125] = {
    BuffId = 410125,
    BuffType = T.RT_338,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunParalysis"
  },
  [410201] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_410200.BP_Buff_410200",
    BuffId = 410201,
    BuffType = {410201, 410200},
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [410202] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_410200.BP_Buff_410200",
    BuffId = 410202,
    BuffType = {410202, 410200},
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [410211] = {
    BuffId = 410211,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 410212,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410212] = {
    AddPassiveEffect = {410212},
    BuffId = 410212,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410214] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        Value = 0.015
      }
    },
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_56,
    BuffId = 410214,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Morale",
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [410221] = {
    ActivateSkills = {
      [410202] = 410221
    },
    BuffId = 410221,
    BuffType = {410221},
    DisperseBuffType = {410222, 410223},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410222] = {
    ActivateSkills = {
      [410202] = 410222
    },
    BuffId = 410222,
    BuffType = {410222},
    DisperseBuffType = {410221, 410223},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410223] = {
    ActivateSkills = {
      [410202] = 410223
    },
    BuffId = 410223,
    BuffType = {410223},
    DisperseBuffType = {410222, 410221},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410231] = {
    AddAttrs = T.RT_83,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_84,
    BuffId = 410231,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410241] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = 0.16,
        Stackable = 1
      }
    },
    BuffEffects = T.RT_163,
    BuffId = 410241,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [410242] = {
    AddAttrs = T.RT_320,
    BuffId = 410242,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [410243] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_410243.BP_Buff_410243",
    BuffId = 410243,
    DotDatas = T.RT_441,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RemoveWhenSpZero = true
  },
  [410251] = {
    BuffId = 410251,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {410203}
  },
  [410252] = {
    AddAttrs = T.RT_367,
    BuffId = 410252,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [420104] = {
    AddAttrs = {
      [1] = {
        AttrName = "BonusDamage",
        SupLimitValue = 0.36,
        Type = "FallAttack",
        ValueUseValue = 1
      }
    },
    AddPassiveEffect = {214},
    BuffId = 420104,
    BuffType = T.RT_3,
    BuffTypeImgPath = "BonusDmg_Common",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420111] = {
    ActivateSkills = {FallAttack = 420111},
    BuffId = 420111,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_444
  },
  [420112] = {
    AddAttrs = T.RT_178,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_99,
    BuffId = 420112,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [420113] = {
    AddAttrs = {
      [1] = T.RT_157,
      [2] = {
        AttrName = "AttackRangeModifierValue",
        Value = 60
      }
    },
    BuffEffects = T.RT_158,
    BuffId = 420113,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Range_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [420114] = {
    BuffId = 420114,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420121] = {
    BuffId = 420121,
    BuffType = {11, 420121},
    BuffTypeImgPath = "Char_Yuming_01",
    EmissiveIntensity = {Body = 12.782403},
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    HpLink = 1,
    IconPriority = 99,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [420122] = {
    BuffId = 420122,
    BuffType = {430101},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420123] = {
    BuffId = 420123,
    BuffType = T.RT_444,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 420124,
        Camp = "Friend"
      },
      [2] = {
        AllowSkillRange = 1,
        AuraRange = 2000,
        BuffId = 420131,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420124] = {
    AddAttrs = T.RT_178,
    AddPassiveEffect = {420103},
    BuffId = 420124,
    BuffTypeImgPath = "Damage_Thunder_Up",
    CombatConditionId = 1004,
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [420131] = {
    BuffId = 420131,
    BuffInitEffects = T.RT_55,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Char_Yuming_01",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [420141] = {
    AddAttrs = T.RT_175,
    BuffId = 420141,
    BuffType = T.RT_444,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420191] = {
    BuffId = 420191,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 420192,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420192] = {
    AddAttrs = T.RT_296,
    BuffId = 420192,
    CombatConditionId = 1004,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [420200] = {
    AddAttrs = {
      [1] = {
        AttrName = "OverShieldLevelGrow",
        Value = 50
      }
    },
    BuffId = 420200,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420201] = {
    AddAttrs = {
      [1] = {
        AttrName = "DEF",
        Stackable = 1,
        SupLimitValue = 20,
        ValueUseValue = 1
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 420201,
    BuffInitEffects = {1011},
    BuffType = T.RT_22,
    BuffTypeImgPath = "Def_Up",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [420211] = {
    ActivateSkills = {
      [420201] = 420211
    },
    AllowSkillSustainModify = true,
    BuffId = 420211,
    BuffType = T.RT_150,
    DisableSkills = T.RT_358,
    DotDatas = {
      [1] = {
        DotDelay = 2,
        Interval = 1,
        Type = "SpChange",
        Value = -5
      }
    },
    HaloDatas = {
      [1] = {
        AllowSkillRange = 1,
        AuraRange = 1000,
        BuffId = 420213,
        Camp = "Enemy"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [420213] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = -0.15,
        Stackable = 1
      }
    },
    BuffId = 420213,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Thunder",
    DotDatas = T.RT_238,
    IsShowInBillboard = true,
    MaxLayer = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [430112] = {
    BuffId = 430112,
    BuffType = T.RT_14,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        Condition = 2,
        DamageTag = T.RT_67,
        DefaultHealFX = 0,
        Interval = 1,
        Rate = 0.1,
        Type = "Hot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [430122] = {
    AddPassiveEffect = {430103},
    BuffId = 430122,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {430156}
  },
  [510001] = {
    BuffId = 510001,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 510002,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [510002] = {
    AddAttrs = T.RT_2,
    BuffId = 510002,
    CombatConditionId = 1005,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [510003] = {
    BuffId = 510003,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 510004,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [510004] = {
    AddAttrs = T.RT_136,
    BuffId = 510004,
    CombatConditionId = 1005,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [510101] = {
    AddAttrs = T.RT_178,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_84,
    BuffId = 510101,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [510102] = {
    BuffAnimInstance = "Ride",
    BuffId = 510102,
    BuffType = T.RT_150,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [510103] = {
    AddAttrs = T.RT_178,
    AllowSkillSustainModify = true,
    BuffDamagedRate = T.RT_471,
    BuffId = 510103,
    BuffType = T.RT_472,
    BuffTypeImgPath = "Songlu",
    FresnelParams = T.RT_474,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_475
  },
  [510104] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        SupLimitValue = 300,
        ValueUseValue = 1
      }
    },
    BuffId = 510104,
    BuffInitEffects = T.RT_163,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [510105] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.45
      }
    },
    BuffEffects = T.RT_84,
    BuffId = 510105,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [510121] = {
    ActivateSkills = {
      [30] = 510107,
      [510101] = 510111,
      [510102] = 510121
    },
    AddAttrs = {
      [1] = {
        AttrName = "WalkSpeedModifier",
        Value = 0.6
      },
      [2] = {
        AttrName = "JumpVelocityModifier",
        Value = 0.3
      }
    },
    AddPassiveEffect = {510102},
    BuffId = 510121,
    BuffType = T.RT_150,
    CameraParam = {
      "SongluSkill02",
      "0.2",
      "50"
    },
    DisableSkills = {
      "HeavyAttack",
      "SlideAttack",
      "Shooting",
      "HeavyShooting",
      "Reload"
    },
    ForbidenJumpState = T.RT_209,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {
      "LandHeavy",
      "Hit",
      "Crouch",
      "Slide",
      "Avoid",
      "Interactive",
      "Seating"
    },
    UseSummonWeapon = 1
  },
  [510122] = {
    BuffId = 510122,
    BuffType = T.RT_150,
    DisableSkills = {"Attack", "FallAttack"},
    DotDatas = T.RT_441,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {
      510102,
      510104,
      510103
    }
  },
  [510131] = {
    AddAttrs = T.RT_178,
    AllowSkillSustainModify = true,
    BuffDamagedRate = T.RT_471,
    BuffId = 510131,
    BuffType = T.RT_472,
    BuffTypeImgPath = "Songlu",
    FresnelParams = T.RT_474,
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_475
  },
  [510191] = {
    BuffId = 510191,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 510192,
        Camp = "Friend",
        Condition = 1007
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [510192] = {
    AddAttrs = {
      [1] = {
        AttrName = "EnmityValue",
        Value = 0.05
      }
    },
    BuffId = 510192,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [510211] = {
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_510201.BP_Buff_510201",
    BuffId = 510211,
    BuffType = {
      11,
      61,
      510211
    },
    BuffTypeImgPath = "Common_Buff",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_476
  },
  [510212] = {
    AddAttrs = {
      [1] = {
        AttrName = "WalkSpeedModifier",
        Value = 0.35
      },
      [2] = {
        AttrName = "SlideVelocityModifier",
        Value = 0.35
      },
      [3] = {
        AttrName = "BulletJumpVelocityModifier",
        Value = 0.35
      },
      [4] = {
        AttrName = "JumpVelocityModifier",
        Value = 0.35
      }
    },
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_510201.BP_Buff_510201",
    BuffId = 510212,
    BuffType = {11, 510211},
    BuffTypeImgPath = "Common_Buff",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_476
  },
  [510213] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Value = 0.6
      }
    },
    BuffId = 510213,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [510221] = {
    AddAttrs = T.RT_87,
    AllowSkillSustainModify = true,
    BuffId = 510221,
    BuffType = T.RT_477,
    BuffTypeImgPath = "Weapon_Spd_Up",
    CannotBeHitted = true,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    VisualEffects = T.RT_478
  },
  [510222] = {
    AddAttrs = {
      [1] = T.RT_85,
      [2] = T.RT_86,
      [3] = {
        AttrName = "BonusDamage",
        Type = "Wind",
        Value = 0.2
      }
    },
    AddPassiveEffect = T.RT_111,
    AllowSkillSustainModify = true,
    BuffId = 510222,
    BuffType = T.RT_477,
    BuffTypeImgPath = "Weapon_Spd_Up",
    CannotBeHitted = true,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    VisualEffects = T.RT_478
  },
  [510231] = {
    AllowSkillSustainModify = true,
    BuffId = 510231,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530100] = {
    ActivateSkills = {
      [30] = 530105,
      [530101] = 530111,
      [530102] = 530121
    },
    AllowSkillSustainModify = true,
    BuffId = 530100,
    BuffType = {70, 530102},
    CameraParam = T.RT_215,
    DisableSkills = T.RT_479,
    DotDatas = {
      [1] = {
        Condition = 530122,
        DotDelay = 2.7,
        Interval = 1,
        Type = "SpChange",
        Value = -30
      },
      [2] = {
        Condition = 530121,
        DotDelay = 2.7,
        EffectId = 530128,
        Interval = 1,
        Type = "SkillEffect"
      }
    },
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceActions = T.RT_361,
    ReplaceMobileAttackButtonIcon = true,
    UseSummonWeapon = 1
  },
  [530101] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_530101.BP_Buff_530101",
    BuffId = 530101,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_480
  },
  [530102] = {
    AllowSkillSustainModify = true,
    BuffId = 530102,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Common_Debuff",
    IsShowInBillboard = true,
    MaxLayer = 12,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree",
    VisualEffects = {530101}
  },
  [530110] = {
    AllowSkillSustainModify = true,
    BuffId = 530110,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hp_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    OverrideAttrs = T.RT_321
  },
  [530111] = {
    BuffId = 530111,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530112] = {
    AddAttrs = {
      [1] = {
        AttrName = "DropDistance",
        Value = 1500
      }
    },
    BuffDamagedRate = T.RT_156,
    BuffId = 530112,
    BuffType = {11, 530102},
    BuffTypeImgPath = "Damaged_Down",
    CannotBeHitted = true,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [530113] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Value = 0.5
      }
    },
    BuffId = 530113,
    BuffType = T.RT_481,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530121] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.35
      }
    },
    BuffId = 530121,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530122] = {
    BuffId = 530122,
    BuffType = T.RT_481,
    DotDatas = {
      [1] = {
        DotDelay = 2.7,
        EffectId = 530142,
        Interval = 5,
        Type = "SkillEffect"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530131] = {
    AddAttrs = T.RT_74,
    AllowSkillSustainModify = true,
    BuffId = 530131,
    BuffInitEffects = T.RT_88,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Berserk",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530132] = {
    AddAttrs = T.RT_20,
    AllowSkillSustainModify = true,
    BuffId = 530132,
    BuffInitEffects = T.RT_163,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530133] = {
    AddAttrs = T.RT_62,
    AllowSkillSustainModify = true,
    BuffId = 530133,
    BuffInitEffects = T.RT_99,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [530141] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        Value = -0.2
      }
    },
    BuffId = 530141,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [540101] = {
    AllowSkillSustainModify = true,
    BuffId = 540101,
    BuffType = T.RT_482,
    BuffTypeImgPath = "Common_Buff_Aura",
    DotDatas = T.RT_484,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 540111,
        Camp = "Friend"
      },
      [2] = T.RT_485
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_486
  },
  [540102] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = -0.15}
    },
    AllowSkillSustainModify = true,
    BuffId = 540102,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Atk_Down",
    DotDatas = T.RT_240,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {540124}
  },
  [540103] = {
    AddAttrs = T.RT_48,
    BuffId = 540103,
    BuffInitEffects = T.RT_325,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IconPriority = 99,
    IsShowInBillboard = true,
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    WeaponFresnelParams = {
      FresnelColor = {
        0.314,
        1,
        0.02,
        1
      },
      FresnelColorRange = T.RT_139,
      FresnelColorStrength = {Default = 0, Ranged = 8}
    }
  },
  [540111] = {
    BuffId = 540111,
    BuffType = {11, 540111},
    BuffTypeImgPath = "Hot_Up",
    DotDatas = T.RT_488,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [540112] = {
    AddAttrs = T.RT_188,
    BuffId = 540112,
    BuffInitEffects = T.RT_231,
    BuffType = T.RT_368,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {540112}
  },
  [540113] = {
    AllowSkillSustainModify = true,
    BuffId = 540113,
    BuffType = T.RT_482,
    BuffTypeImgPath = "Common_Buff_Aura",
    DotDatas = T.RT_484,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 540114,
        Camp = "Friend"
      },
      [2] = T.RT_485
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_486
  },
  [540114] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.1
      }
    },
    BuffId = 540114,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DisperseBuffType = T.RT_486,
    DotDatas = T.RT_488,
    ForbidBuffType = T.RT_486,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [540121] = {
    AddAttrs = T.RT_248,
    AddPassiveEffect = T.RT_111,
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_489,
    BuffId = 540121,
    BuffType = {10, 540121},
    BuffTypeImgPath = "BonusDmg_Wind",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_490
  },
  [540122] = {
    AddAttrs = T.RT_248,
    AddPassiveEffect = {205, 540102},
    AllowSkillSustainModify = true,
    BuffEffects = T.RT_489,
    BuffId = 540122,
    BuffType = T.RT_22,
    BuffTypeImgPath = "BonusDmg_Wind",
    DisperseBuffType = T.RT_489,
    ForbidBuffType = T.RT_489,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_490
  },
  [540123] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.07
      }
    },
    BuffId = 540123,
    BuffInitEffects = T.RT_84,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [540124] = {
    AllowSkillSustainModify = true,
    BuffId = 540124,
    BuffType = T.RT_256,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunBound",
    VisualEffects = {540122}
  },
  [540201] = {
    ActivateSkills = {
      [540201] = 540211
    },
    AllowSkillSustainModify = true,
    AttackOnPressedDown = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_540201.BP_Buff_540201",
    BuffId = 540201,
    BuffType = {70, 540201},
    CameraParam = T.RT_215,
    DisableSkills = T.RT_479,
    EnableFlight = 1,
    ForbidBuffType = {540201},
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 540211,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceActions = T.RT_361,
    ReplaceMobileAttackButtonIcon = true,
    UseSummonWeapon = 1
  },
  [540202] = {
    AddAttrs = {
      [1] = {
        AttrName = "FlySpeedModifier",
        Value = -0.5
      }
    },
    BuffId = 540202,
    CannotBeHitted = true,
    ForbidCatch = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [540203] = {
    AddAttrs = {
      [1] = {
        AttrName = "HyperTriggerRate",
        Stackable = 1,
        Value = 0.001
      }
    },
    BuffId = 540203,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Common_Buff",
    IsShowInBillboard = true,
    MaxLayer = 999,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [540204] = {
    AddAttrs = {
      [1] = {
        AttrName = "HyperTriggerRate",
        SupLimitValue = 1,
        ValueUseValue = 1
      }
    },
    AllowSkillSustainModify = true,
    BuffId = 540204,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [540211] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.3
      }
    },
    BuffId = 540211,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [540221] = {
    ActivateSkills = {
      [540202] = 540221
    },
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_540221.BP_Buff_540221",
    BuffId = 540221,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [540231] = {
    BuffId = 540231,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [540232] = {
    AddAttrs = {
      [1] = {
        AttrName = "HyperTriggerRate",
        Stackable = 1,
        Value = 0.004
      }
    },
    BuffId = 540232,
    MaxLayer = 100,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [600101] = {
    BuffId = 600101,
    BuffType = T.RT_368,
    BuffTypeImgPath = "Weapon_Spd_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {600100}
  },
  [600501] = {
    BuffId = 600501,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_454,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_455
  },
  [600502] = {
    BuffId = 600502,
    BuffType = {
      11,
      60,
      600502
    },
    ForbidBuffType = T.RT_338,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_262,
    VisualEffects = {600505}
  },
  [700221] = {
    BuffId = 700221,
    DisperseBuffType = T.RT_502,
    ForbidBuffType = T.RT_502,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [700401] = {
    BuffId = 700401,
    BuffType = T.RT_22,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SeHitedMat = "Shield"
  },
  [700501] = {
    AddAttrs = {
      [1] = T.RT_430,
      [2] = T.RT_135,
      [3] = {
        AttrName = "DamagedRate",
        IndividualRateZone = 1,
        Value = -0.5
      }
    },
    BuffId = 700501,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Team_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {700502}
  },
  [700502] = {
    BuffId = 700502,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Team_Caster",
    HaloDatas = {
      [1] = {
        AuraRange = 1500,
        BuffId = 700501,
        Camp = "OtherFriend"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_497
  },
  [700601] = {
    BuffId = 700601,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        EffectId = 700623,
        Interval = 0.4,
        Type = "SkillEffect"
      }
    },
    EmissiveParams = {
      EmissiveColor = {
        0.349,
        2,
        1.189,
        1
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [700602] = {
    AddAttrs = {
      [1] = T.RT_430,
      [2] = T.RT_135
    },
    BuffId = 700602,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 0.2,
        Rate = 0.02,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {700602}
  },
  [700701] = {
    AllowSkillSustainModify = true,
    BuffId = 700701,
    BuffType = {20, 203},
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunParalysis",
    VisualEffects = T.RT_309
  },
  [700801] = {
    BuffId = 700801,
    BuffType = T.RT_3,
    DMMIParams = T.RT_504,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = {700806}
  },
  [701101] = {
    AllowSkillSustainModify = true,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_701101.BP_Buff_701101",
    BuffId = 701101,
    BuffType = {11, 302},
    BuffTypeImgPath = "Common_Buff",
    FXMID = T.RT_505,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [701201] = {
    BuffId = 701201,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    TimeDilation = 1.5,
    VisualEffects = {701201}
  },
  [701501] = {
    BuffId = 701501,
    BuffType = T.RT_3,
    DMMIParams = T.RT_504,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_506
  },
  [701601] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff.BP_Buff",
    BuffId = 701601,
    BuffType = T.RT_3,
    EmissiveParams = {
      EmissiveColor = {
        0.29,
        1,
        0.97,
        1
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100
  },
  [701701] = {
    BuffId = 701701,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.2,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {600302}
  },
  [800201] = {
    BuffId = 800201,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        46.4,
        16.4,
        3.6,
        1
      },
      DMMILineWidth = 0.5
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_506
  },
  [800202] = {
    BuffId = 800202,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        51,
        6,
        0,
        1
      },
      DMMILineWidth = 0.5
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = {800202}
  },
  [800301] = {
    BuffId = 800301,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_67,
        DefaultHealFX = 0,
        Interval = 1,
        Rate = 0.025,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850001] = {
    BuffId = 850001,
    LockHp = T.RT_257,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850002] = {
    BuffId = 850002,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_262
  },
  [850201] = {
    BuffId = 850201,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850202] = {
    AddPassiveEffect = {850202},
    BuffId = 850202,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850203] = {
    BuffId = 850203,
    MaxLayer = 3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850204] = {
    AddAttrs = T.RT_172,
    BuffEffects = T.RT_231,
    BuffId = 850204,
    BuffType = {42},
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850205] = {
    BuffDamagedRate = {Value = -0.5},
    BuffId = 850205,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850206] = {
    BuffId = 850206,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850210}
  },
  [850207] = {
    BuffId = 850207,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850211}
  },
  [850208] = {
    BuffId = 850208,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850209}
  },
  [850209] = {
    BuffId = 850209,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850212}
  },
  [850210] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        IndividualRateZone = 1,
        Value = 0.2
      }
    },
    BuffId = 850210,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850301] = {
    BuffId = 850301,
    InitialEffect = {850324},
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850302] = {
    BuffId = 850302,
    ForbidBuffType = {40},
    LockHp = T.RT_449,
    LockHpUI = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850303] = {
    BuffId = 850303,
    CannotBeCutTN = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850304] = {
    BuffId = 850304,
    LockHp = {Rate = 0.1},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850305] = {
    BuffId = 850305,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850306}
  },
  [850306] = {
    BuffId = 850306,
    LockHp = T.RT_449,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850307] = {
    AddAttrs = T.RT_144,
    BuffId = 850307,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 100,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850308] = {
    BuffId = 850308,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850309] = {
    BuffId = 850309,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    LockHp = T.RT_449,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    SpecialEffect = T.RT_262
  },
  [850310] = {
    BuffId = 850310,
    BuffType = T.RT_3,
    CameraParam = {
      "BossShijingzheSkill15",
      "0.5",
      "999"
    },
    DeadNotRemove = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850311] = {
    BuffId = 850311,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    LockHp = T.RT_511,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850312] = {
    BuffId = 850312,
    BuffTypeImgPath = "Invincible",
    CannotBeCutTN = true,
    ForbidBuffType = T.RT_338,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    SpecialEffect = T.RT_262
  },
  [850313] = {
    BuffId = 850313,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850322}
  },
  [850401] = {
    BuffId = 850401,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [850402] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_850402.BP_Buff_850402",
    BuffId = 850402,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850403] = {
    BuffId = 850403,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850404] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        IndividualRateZone = 1,
        Value = 1
      }
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_850404.BP_Buff_850404",
    BuffId = 850404,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    TimeDilation = 0.1
  },
  [850405] = {
    ActivateSkills = {
      [530101] = 530111,
      [530102] = 530121
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_530101.BP_Buff_530101",
    BuffId = 850405,
    CameraParam = T.RT_215,
    DisableSkills = T.RT_479,
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "SpChange",
        Value = 5
      }
    },
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    ReplaceActions = T.RT_361,
    UseSummonWeapon = 1,
    VisualEffects = T.RT_480
  },
  [850406] = {
    BuffId = 850406,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_452,
        Interval = 0.5,
        Rate = 0.3,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_492
  },
  [850501] = {
    AddPassiveEffect = {850501},
    BuffId = 850501,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Common_Buff",
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {850502}
  },
  [850502] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_BossLianhuoCamera.BP_Buff_BossLianhuoCamera",
    BossSpCamera = {
      ArmRate = -0.5,
      BaseArmLength = 1500,
      BasePitch = 25,
      PitchRate = 0.01,
      UseSaveLoc = "BossMapSkill"
    },
    BuffId = 850502,
    BuffType = T.RT_3,
    CameraParam = T.RT_512,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850503] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        IndividualRateZone = 1,
        Value = 0.05
      }
    },
    BuffId = 850503,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MaxLayer = 99,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850504] = {
    BuffId = 850504,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {850512}
  },
  [850505] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_850505.BP_Buff_850505",
    BuffId = 850505,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850901] = {
    BuffId = 850901,
    LockHp = T.RT_257,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [850902] = {
    BuffId = 850902,
    LockHp = T.RT_511,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851001] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_851001.BP_Buff_851001",
    BuffId = 851001,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0.3,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_500
  },
  [851002] = {
    AllowSkillSustainModify = true,
    BuffId = 851002,
    DeadNotRemove = true,
    LockHp = T.RT_217,
    LockHpUI = 0,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851003] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_BossLianhuoCamera.BP_Buff_BossLianhuoCamera",
    BossSpCamera = {
      ArmRate = 0,
      BaseArmLength = 1200,
      BasePitch = 25,
      PitchRate = 0,
      UseSaveLoc = "BossMapSkill"
    },
    BuffId = 851003,
    BuffType = T.RT_3,
    CameraParam = T.RT_512,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851004] = {
    BossRecoverUI = {
      DelayTime = 3,
      ExecuteTime = 30,
      RecoverPercent = 0.5
    },
    BuffId = 851004,
    BuffType = T.RT_3,
    LockHpUI = 1
  },
  [851005] = {
    BuffId = 851005,
    BuffType = T.RT_3,
    CameraParam = {
      "BossHeilongDefault",
      "0.5",
      "5"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851101] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_851101.BP_Buff_851101",
    BuffId = 851101,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.9,
    VisualEffects = T.RT_491
  },
  [851201] = {
    BuffId = 851201,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851202] = {
    BuffId = 851202,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_513,
    ForbidCatch = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [851203] = {
    BuffId = 851203,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    LockHp = {Rate = 0.61},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851204] = {
    BuffId = 851204,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851205] = {
    BuffId = 851205,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {851202}
  },
  [851206] = {
    BuffId = 851206,
    BuffType = T.RT_3,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851207] = {
    BuffId = 851207,
    BuffType = T.RT_3,
    CameraParam = T.RT_514,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851208] = {
    BuffId = 851208,
    BuffType = T.RT_3,
    CameraParam = T.RT_514,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851209] = {
    BuffId = 851209,
    LockHp = {Rate = 0.49},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851210] = {
    BuffId = 851210,
    LockHp = T.RT_352,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851211] = {
    BuffDamagedRate = {Value = -0.99},
    BuffId = 851211,
    LockHp = {Rate = 0.48},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851212] = {
    BuffId = 851212,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851213] = {
    BuffId = 851213,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851214] = {
    BuffId = 851214,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    SpecialEffect = T.RT_262
  },
  [851501] = {
    BuffId = 851501,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 0.2,
        Rate = 0.01,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [851502] = {
    BuffId = 851502,
    LockHp = {Rate = 0.35},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851701] = {
    BuffId = 851701,
    LockHp = T.RT_257,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851801] = {
    BuffId = 851801,
    BuffType = T.RT_3,
    CameraParam = {
      "BossJuqueDefault",
      "0.5",
      "5"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851901] = {
    BuffId = 851901,
    LockHp = T.RT_511,
    LockHpUI = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851902] = {
    BossSpCamera = {
      ArmRate = 0,
      BaseArmLength = 500,
      BasePitch = 45,
      PitchRate = 0,
      UseSaveLoc = ""
    },
    BuffId = 851902,
    BuffType = T.RT_3,
    CameraParam = {
      "BossLiecheMCoreSkill01",
      "0.5",
      "999"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851903] = {
    BossSpCamera = {
      ArmRate = 0,
      BaseArmLength = 850,
      BasePitch = 0,
      PitchRate = 0,
      UseSaveLoc = ""
    },
    BuffId = 851903,
    BuffType = T.RT_3,
    CameraParam = T.RT_515,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851904] = {
    BossSpCamera = {
      ArmRate = 0,
      BaseArmLength = 700,
      BasePitch = 0,
      PitchRate = 0,
      UseSaveLoc = ""
    },
    BuffId = 851904,
    BuffType = T.RT_3,
    CameraParam = T.RT_515,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851905] = {
    BossSpCamera = {
      ArmRate = 0,
      BaseArmLength = 800,
      BasePitch = 0,
      PitchRate = 0,
      UseSaveLoc = ""
    },
    BuffId = 851905,
    BuffType = T.RT_3,
    CameraParam = T.RT_515,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [851906] = {
    BuffId = 851906,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = {
      Char = "Mon_BossLiecheBomb"
    },
    Priority = 1000
  },
  [851907] = {
    BuffId = 851907,
    BuffType = {11, 851907},
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [851908] = {
    BuffId = 851908,
    BuffType = T.RT_337,
    BuffTypeImgPath = "Invincible",
    DisperseBuffType = T.RT_338,
    ForbidBuffType = T.RT_338,
    FresnelParams = T.RT_261,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    NotEnterTarget = true,
    Priority = 9999,
    SpecialEffect = T.RT_262,
    UISpecialEffect = T.RT_263
  },
  [852001] = {
    BossSpCamera = {
      ArmRate = -0.5,
      BaseArmLength = 3000,
      BasePitch = 60,
      PitchRate = 0.01,
      UseSaveLoc = "CenterLoc"
    },
    BuffId = 852001,
    BuffType = T.RT_3,
    CameraParam = T.RT_348,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852003] = {
    BossSpCamera = {
      ArmRate = -0.1,
      BaseArmLength = 1200,
      BasePitch = -20,
      PitchRate = -0.002,
      UseSaveLoc = "Skill0501"
    },
    BuffId = 852003,
    BuffType = T.RT_3,
    CameraParam = T.RT_348,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852004] = {
    BossSpCamera = {
      ArmRate = -0.1,
      BaseArmLength = 1200,
      BasePitch = -20,
      PitchRate = -0.002,
      UseSaveLoc = "Skill0801"
    },
    BuffId = 852004,
    BuffType = T.RT_3,
    CameraParam = T.RT_348,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852005] = {
    BossSpCamera = {
      ArmRate = -0.5,
      BaseArmLength = 2000,
      BasePitch = 30,
      PitchRate = 0.01,
      UseSaveLoc = "CenterLoc"
    },
    BuffId = 852005,
    BuffType = T.RT_3,
    CameraParam = T.RT_348,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852201] = {
    BuffId = 852201,
    BuffType = T.RT_311,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetCharacterTag = "Stun",
    StunType = "StunCommon",
    VisualEffects = {852202}
  },
  [852401] = {
    BuffId = 852401,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 0.5,
        Rate = 1,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.5,
    VisualEffects = T.RT_380
  },
  [852501] = {
    BuffId = 852501,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852502] = {
    BuffId = 852502,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852503] = {
    BuffId = 852503,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [852504] = {
    BuffId = 852504,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_510,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    SpecialEffect = T.RT_262
  },
  [852505] = {
    BuffId = 852505,
    BuffType = T.RT_3,
    CameraParam = {
      "BossYidaiDefault",
      "0.5",
      "5"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [859900] = {
    BuffId = 859900,
    BuffType = T.RT_14,
    DisableSkills = {
      "FallAttack",
      "HeavyAttack",
      "SlideAttack",
      "Attack",
      "Skill2",
      "Skill1",
      "Shooting",
      "HeavyShooting",
      "Reload",
      "Support"
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [900003] = {
    BuffEffects = T.RT_447,
    BuffId = 900003,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [900301] = {
    BuffId = 900301,
    BuffType = T.RT_3,
    HaloDatas = {
      [1] = {
        AuraRange = 1500,
        BuffId = 900302,
        Camp = "Friend"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {900301}
  },
  [900302] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        Value = 0.3
      },
      [2] = T.RT_159
    },
    BuffId = 900302,
    BuffType = T.RT_341,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {900302}
  },
  [900303] = {
    BuffId = 900303,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {900303}
  },
  [900401] = {
    BuffId = 900401,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {900401}
  },
  [900601] = {
    BuffId = 900601,
    BuffType = T.RT_339,
    EffectCreatureID = 900601,
    FXMID = T.RT_505,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [900602] = {
    BuffId = 900602,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 1001,
    SpecialEffect = {"Invisible"}
  },
  [900603] = {
    BuffId = 900603,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        1,
        0.2,
        0,
        1
      },
      DMMILineWidth = 0.3
    },
    FXMID = T.RT_505,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [950001] = {
    AddAttrs = {
      [1] = T.RT_430
    },
    BuffId = 950001,
    BuffType = T.RT_341,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [950002] = {
    AddPassiveEffect = {950004},
    BuffId = 950002,
    BuffType = T.RT_145,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [950003] = {
    BuffId = 950003,
    BuffType = T.RT_145,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {950006}
  },
  [950101] = {
    AddAttrs = {
      [1] = T.RT_493
    },
    BuffId = 950101,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [950401] = {
    BuffId = 950401,
    ForbidBuffType = T.RT_513,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [950402] = {
    BuffId = 950402,
    BuffType = {21, 950401},
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SetCharacterTag = "Stun",
    StunType = "StunParalysis"
  },
  [950403] = {
    BuffId = 950403,
    LockHp = T.RT_511,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [980501] = {
    BuffId = 980501,
    DeadNotRemove = true,
    EnableFlight = 1,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1000101] = {
    BuffId = 1000101,
    BuffType = T.RT_3,
    DMMIParams = T.RT_5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_6
  },
  [1000102] = {
    BuffId = 1000102,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        20,
        25,
        25,
        1
      },
      DMMILineWidth = 0.5
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_6
  },
  [1000201] = {
    BuffId = 1000201,
    BuffType = T.RT_7,
    DisperseBuffType = T.RT_8,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_8
  },
  [1000202] = {
    BuffId = 1000202,
    BuffType = T.RT_8,
    DisperseBuffType = T.RT_7,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {1000203}
  },
  [1000301] = {
    AddAttrs = {
      [1] = T.RT_9
    },
    BuffId = 1000301,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {1000407}
  },
  [1000501] = {
    BuffId = 1000501,
    BuffType = T.RT_3,
    DMMIParams = T.RT_5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_6
  },
  [1000502] = {
    BuffId = 1000502,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        7.2,
        0,
        25,
        1
      },
      DMMILineWidth = 0.5
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    VisualEffects = T.RT_6
  },
  [1020121] = {
    ActivateSkills = {
      Attack = 1020105,
      SkillOwner = "MeleeWeapon"
    },
    BuffId = 1020121,
    BuffType = {70, 71},
    DisableSkills = T.RT_81,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029901] = {
    BuffId = 1029901,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Spd_Up",
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1029902,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029902] = {
    AddAttrs = T.RT_90,
    BuffId = 1029902,
    BuffType = T.RT_22,
    MaxLayer = 20,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029903] = {
    AddAttrs = {
      [1] = {
        AttrName = "SummonAttrRates",
        Stackable = 1,
        Value = 0.0025
      }
    },
    BuffId = 1029903,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Skill_Spd_Up",
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1029904,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [30] = 1029905
    },
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029904] = {
    AddAttrs = T.RT_90,
    BuffId = 1029904,
    BuffType = T.RT_22,
    MaxLayer = 30,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029905] = {
    AddAttrs = T.RT_92,
    BuffId = 1029905,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Trigger_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029906] = {
    BuffId = 1029906,
    BuffType = T.RT_3,
    HaloDatas = {
      [1] = {
        AuraRange = -1,
        BuffId = 1029907,
        Camp = "Friend",
        Filter = "OnlySummon"
      }
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1029907] = {
    AddPassiveEffect = {1029901},
    BuffId = 1029907,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1030111] = {
    AddAttrs = T.RT_95,
    BuffId = 1030111,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1030221] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_1030221.BP_Buff_1030221",
    BuffId = 1030221,
    BuffType = T.RT_96,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    RagdollEnable = 1,
    SetCharacterTag = "HitFly"
  },
  [1030222] = {
    AddAttrs = T.RT_98,
    BuffId = 1030222,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1039901] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Normal",
        Value = 0.5
      }
    },
    BuffId = 1039901,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1039902] = {
    AddAttrs = T.RT_101,
    AddPassiveEffect = T.RT_102,
    BuffId = 1039902,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039903] = {
    AddAttrs = T.RT_104,
    AddPassiveEffect = T.RT_105,
    BuffId = 1039903,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039904] = {
    AddAttrs = T.RT_107,
    AddPassiveEffect = T.RT_108,
    BuffId = 1039904,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039905] = {
    AddAttrs = T.RT_110,
    AddPassiveEffect = T.RT_111,
    BuffId = 1039905,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039906] = {
    AddAttrs = T.RT_113,
    AddPassiveEffect = T.RT_114,
    BuffId = 1039906,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039907] = {
    AddAttrs = T.RT_116,
    AddPassiveEffect = T.RT_117,
    BuffId = 1039907,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039908] = {
    AddAttrs = T.RT_119,
    BuffId = 1039908,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039910] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierValue",
        Type = "Ultra",
        ValueUseValue = 1
      }
    },
    BuffId = 1039910,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039911] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierValue",
        Type = "Ultra",
        ValueUseValue = 1
      }
    },
    BuffId = 1039911,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1039912] = {
    AddAttrs = {
      [1] = {
        AttrName = "TriggerProbModifierValue",
        Type = "Ultra",
        ValueUseValue = 1
      }
    },
    BuffId = 1039912,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1040141] = {
    AddAttrs = T.RT_98,
    BuffId = 1040141,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1050121] = {
    ActivateSkills = {
      Attack = 1019901,
      HeavyAttack = 1010102,
      SkillOwner = "MeleeWeapon"
    },
    BuffId = 1050121,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1060202] = {
    BuffId = 1060202,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1311001] = {
    BuffDamagedRate = T.RT_26,
    BuffId = 1311001,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1430001] = {
    AddAttrs = {
      [1] = {
        AttrName = "SpRecoverValue",
        Value = "#1"
      }
    },
    BuffId = 1430001,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1440001] = {
    AddAttrs = T.RT_178,
    BuffId = 1440001,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [1921001] = {
    AddAttrs = {
      [1] = {AttrName = "SkillRange", ValueUseValue = 1}
    },
    BuffId = 1921001,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [1961001] = {
    AddPassiveEffect = {1961001},
    BuffId = 1961001,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010001] = {
    BuffId = 2010001,
    BuffType = T.RT_3,
    LockHp = T.RT_257,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010002] = {
    BuffId = 2010002,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    CannotBeHitted = true,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    Priority = 1000,
    SpecialEffect = T.RT_262,
    UISpecialEffect = T.RT_263
  },
  [2010003] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Abyss",
        Stackable = 1,
        Value = 0.01
      }
    },
    BuffId = 2010003,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 100,
    IsShowInBillboard = true,
    MaxLayer = 50,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010004] = {
    BuffId = 2010004,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Endure",
    CannotBeHitted = true,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [2010005] = {
    BuffId = 2010005,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    OverrideAttrs = {
      AttrName = "MaxDamagedValue",
      BaseAttr = "MaxHp",
      Rate = 0.35
    }
  },
  [2010011] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = 0.12}
    },
    BuffId = 2010011,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2010012] = {
    AddAttrs = {
      [1] = T.RT_264,
      [2] = T.RT_265,
      [3] = T.RT_266,
      [4] = T.RT_267
    },
    BuffId = 2010012,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Water"
  },
  [2010013] = {
    AddAttrs = {
      [1] = T.RT_268,
      [2] = T.RT_269,
      [3] = T.RT_266,
      [4] = T.RT_267
    },
    BuffId = 2010013,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Fire"
  },
  [2010014] = {
    AddAttrs = {
      [1] = T.RT_270,
      [2] = T.RT_269,
      [3] = T.RT_265,
      [4] = T.RT_267
    },
    BuffId = 2010014,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Thunder"
  },
  [2010015] = {
    AddAttrs = {
      [1] = T.RT_271,
      [2] = T.RT_269,
      [3] = T.RT_265,
      [4] = T.RT_266
    },
    BuffId = 2010015,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Wind"
  },
  [2010016] = {
    AddAttrs = {
      [1] = T.RT_272,
      [2] = T.RT_273
    },
    BuffId = 2010016,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Light"
  },
  [2010017] = {
    AddAttrs = {
      [1] = T.RT_274,
      [2] = T.RT_275
    },
    BuffId = 2010017,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Dark"
  },
  [2010018] = {
    AddAttrs = {
      [1] = T.RT_275,
      [2] = T.RT_273
    },
    BuffId = 2010018,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010019] = {
    AddAttrs = {
      [1] = T.RT_269,
      [2] = T.RT_265,
      [3] = T.RT_266,
      [4] = T.RT_267
    },
    BuffId = 2010019,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010020] = {
    AddAttrs = {
      [1] = T.RT_264,
      [2] = T.RT_272
    },
    BuffId = 2010020,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010025] = {
    AddAttrs = {
      [1] = T.RT_264,
      [2] = T.RT_271
    },
    BuffId = 2010025,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010034] = {
    AddAttrs = {
      [1] = T.RT_268,
      [2] = T.RT_270
    },
    BuffId = 2010034,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010035] = {
    AddAttrs = {
      [1] = T.RT_268,
      [2] = T.RT_271
    },
    BuffId = 2010035,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010040] = {
    AddAttrs = {
      [1] = T.RT_270,
      [2] = T.RT_272
    },
    BuffId = 2010040,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010051] = {
    AddAttrs = {
      [1] = T.RT_271,
      [2] = T.RT_274
    },
    BuffId = 2010051,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010101] = {
    BuffId = 2010101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Common_Buff_Aura",
    HaloDatas = T.RT_277,
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010102] = {
    BuffDamagedRate = T.RT_156,
    BuffId = 2010102,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010201] = {
    BuffDamagedRate = T.RT_278,
    BuffId = 2010201,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 80,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010202] = {
    BuffDamagedRate = T.RT_279,
    BuffId = 2010202,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 40,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010203] = {
    BuffDamagedRate = T.RT_279,
    BuffId = 2010203,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 40,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010204] = {
    BuffDamagedRate = T.RT_279,
    BuffId = 2010204,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 40,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010205] = {
    BuffDamagedRate = T.RT_280,
    BuffId = 2010205,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010206] = {
    BuffDamagedRate = {Value = -0.06},
    BuffId = 2010206,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010207] = {
    BuffDamagedRate = T.RT_280,
    BuffId = 2010207,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010211] = {
    BuffId = 2010211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Es",
    DotDatas = T.RT_282,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010212] = {
    BuffDamagedRate = T.RT_278,
    BuffId = 2010212,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    DotDatas = T.RT_282,
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 80,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010301] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.1
      }
    },
    BuffId = 2010301,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2010302] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Ranged",
        RateZone = "Normal",
        Value = 0.5
      }
    },
    BuffId = 2010302,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010304] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.2
      }
    },
    BuffDamagedRate = T.RT_279,
    BuffId = 2010304,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    LayerExtraBuff = T.RT_285,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2010402] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        DamageTag = "Melee",
        IndividualRateZone = 1,
        Value = -0.5
      }
    },
    BuffId = 2010402,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2010512] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Value = -0.5
      }
    },
    BuffId = 2010512,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Crd_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2011111] = {
    BuffDamagedRate = {Value = -0.1},
    BuffId = 2011111,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    HaloDatas = T.RT_277,
    IconPriority = 200,
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2011113] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeedModifierRate",
        Value = 0.1
      },
      [2] = {AttrName = "SkillSpeed", Rate = 0.05}
    },
    BuffId = 2011113,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Spd_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [6] = 2010004
    },
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2011121] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Value = 0.1
      }
    },
    BuffId = 2011121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Cri_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2011122] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        IndividualRateZone = 1,
        Value = -0.5
      },
      [2] = T.RT_288
    },
    BuffId = 2011122,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2011211] = {
    AddAttrs = T.RT_290,
    BuffId = 2011211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    CannotBeHitted = true,
    ForbidCatch = true,
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [2011212] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Value = -1
      },
      [2] = {
        AttrName = "DamageRate",
        DamageTag = "Dot",
        RateZone = "Abyss",
        Value = 0.5
      }
    },
    BuffId = 2011212,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2011221] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Abyss",
        Value = 0.1
      }
    },
    BuffId = 2011221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    CannotBeHitted = true,
    ForbidCatch = true,
    IconPriority = 1,
    IsShowInBillboard = true,
    LayerExtraBuff = T.RT_285,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    NotEnterCharacterTagType = T.RT_30
  },
  [2011222] = {
    AddAttrs = {
      [1] = T.RT_291,
      [2] = T.RT_292
    },
    BuffId = 2011222,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2012111] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        Value = 0.6
      }
    },
    BuffId = 2012111,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Cri_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2012112] = {
    AddAttrs = {
      [1] = T.RT_291,
      [2] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Abyss",
        Value = 0.5
      }
    },
    BuffId = 2012112,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2012121] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Abyss",
        Value = 0.1
      }
    },
    BuffId = 2012121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [9] = 2010004
    },
    MaxLayer = 9,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2012211] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.5
      }
    },
    BuffId = 2012211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2012221] = {
    AddAttrs = T.RT_294,
    BuffId = 2012221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Cri_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 9,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2013111] = {
    AddAttrs = T.RT_296,
    BuffId = 2013111,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Morale",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2013112] = {
    AddAttrs = {
      [1] = {AttrName = "SkillRange", Rate = 0.75},
      [2] = {
        AttrName = "SkillSustain",
        Rate = -0.25
      }
    },
    BuffId = 2013112,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2013121] = {
    AddAttrs = T.RT_298,
    BuffId = 2013121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2013122] = {
    AddAttrs = {
      [1] = T.RT_289,
      [2] = T.RT_299
    },
    BuffId = 2013122,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2013211] = {
    AddAttrs = T.RT_298,
    BuffId = 2013211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 1,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2013212] = {
    AddAttrs = {
      [1] = {AttrName = "MaxSp", Rate = 1},
      [2] = {AttrName = "MaxHp", Rate = -1.5},
      [3] = {AttrName = "Sp", Rate = 1}
    },
    BuffId = 2013212,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2013221] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.03
      }
    },
    BuffId = 2013221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 50,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2013222] = {
    AddAttrs = {
      [1] = {
        AttrName = "MultiShootModifierRate",
        Value = 1.2
      },
      [2] = T.RT_299
    },
    BuffId = 2013222,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2014111] = {
    AddAttrs = T.RT_301,
    BuffId = 2014111,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 30,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2014121] = {
    AddAttrs = T.RT_294,
    BuffId = 2014121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2014122] = {
    AddAttrs = {
      [1] = T.RT_292,
      [2] = T.RT_299
    },
    BuffId = 2014122,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2014211] = {
    AddAttrs = T.RT_294,
    BuffId = 2014211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2014212] = {
    AddAttrs = {
      [1] = T.RT_160,
      [2] = T.RT_299
    },
    BuffId = 2014212,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2014221] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 0.3
      }
    },
    BuffId = 2014221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2015111] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Abyss",
        Value = 0.05
      }
    },
    BuffId = 2015111,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2015121] = {
    AddAttrs = T.RT_33,
    BuffId = 2015121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2015211] = {
    AddAttrs = T.RT_212,
    BuffId = 2015211,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Morale",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2015221] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Abyss",
        Value = 0.05
      }
    },
    BuffId = 2015221,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IconPriority = 1,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [2020701] = {
    AddAttrs = T.RT_178,
    BuffId = 2020701,
    BuffInitEffects = T.RT_84,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 9,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [2050501] = {
    BuffId = 2050501,
    MaxLayer = 10,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2059901] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Melee",
        RateZone = "Normal",
        Value = 0.3
      }
    },
    BuffId = 2059901,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2059902] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "HeavyAttack",
        RateZone = "Normal",
        Value = 3
      }
    },
    BuffId = 2059902,
    BuffType = T.RT_3,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [2059903] = {
    AddAttrs = T.RT_101,
    AddPassiveEffect = T.RT_102,
    BuffId = 2059903,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2059904] = {
    AddAttrs = T.RT_104,
    AddPassiveEffect = T.RT_105,
    BuffId = 2059904,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2059905] = {
    AddAttrs = T.RT_107,
    AddPassiveEffect = T.RT_108,
    BuffId = 2059905,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2059906] = {
    AddAttrs = T.RT_110,
    AddPassiveEffect = T.RT_111,
    BuffId = 2059906,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2059907] = {
    AddAttrs = T.RT_113,
    AddPassiveEffect = T.RT_114,
    BuffId = 2059907,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2059908] = {
    AddAttrs = T.RT_116,
    AddPassiveEffect = T.RT_117,
    BuffId = 2059908,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2060301] = {
    BuffId = 2060301,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = {2060301}
  },
  [2500101] = {
    BuffId = 2500101,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageTag = T.RT_10,
        DamageType = "HpConsume",
        Interval = 1,
        Rate = 0.01,
        Type = "Dot"
      }
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2500102] = {
    BuffId = 2500102,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageTag = T.RT_10,
        DamageType = "HpConsume",
        Interval = 1,
        Rate = 0.02,
        Type = "Dot"
      }
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2500103] = {
    BuffId = 2500103,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageTag = T.RT_10,
        DamageType = "HpConsume",
        Interval = 1,
        Rate = 0.04,
        Type = "Dot"
      }
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2500104] = {
    BuffId = 2500104,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageTag = T.RT_10,
        DamageType = "HpConsume",
        Interval = 1,
        Rate = 0.08,
        Type = "Dot"
      }
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [2500105] = {
    BuffId = 2500105,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHP",
        DamageTag = T.RT_10,
        DamageType = "HpConsume",
        Interval = 1,
        Rate = 0.16,
        Type = "Dot"
      }
    },
    IconPriority = 1,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [3010001] = {
    AddAttrs = {
      [1] = {AttrName = "MaxHp", Rate = 8},
      [2] = {AttrName = "MaxES", Rate = 8}
    },
    BuffId = 3010001,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [3021001] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Value = 3000}
    },
    BuffId = 3021001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Up",
    IconPriority = 99,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [3021002] = {
    BuffId = 3021002,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Endure",
    CannotBeCutTN = true,
    IconPriority = 99,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [3021003] = {
    BuffId = 3021003,
    DisperseBuffType = T.RT_340,
    ForbidBuffType = T.RT_340,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010001] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillIntensity",
        Rate = 1.5
      }
    },
    BuffId = 4010001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010002] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Normal",
        Value = 0.9
      }
    },
    BuffId = 4010002,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010003] = {
    AddAttrs = {
      [1] = {
        AttrName = "MultiShootModifierRate",
        Value = 0.75
      }
    },
    BuffId = 4010003,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Weapon_Multishoot_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010004] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeedModifierRate",
        Type = "Ranged",
        Value = 0.9
      }
    },
    BuffId = 4010004,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Weapon_Spd_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010005] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        RateZone = "Normal",
        Value = 1.35
      }
    },
    BuffId = 4010005,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010006] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeedModifierRate",
        Type = "Melee",
        Value = 0.9
      }
    },
    BuffId = 4010006,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Weapon_Spd_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010007] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillSustain",
        Rate = 1
      },
      [2] = {AttrName = "SkillRange", Rate = 1}
    },
    BuffId = 4010007,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Effi_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010008] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 5
      }
    },
    BuffId = 4010008,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010009] = {
    AddAttrs = {
      [1] = {
        AttrName = "SupportSkillCD",
        Rate = -0.5
      }
    },
    BuffId = 4010009,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010010] = {
    AddPassiveEffect = {605},
    BuffId = 4010010,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010012] = {
    AddAttrs = {
      [1] = {
        AttrName = "StrongValue",
        Stackable = 1,
        Value = 0.02
      }
    },
    BuffId = 4010012,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 50,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4010013] = {
    AddAttrs = T.RT_318,
    BuffId = 4010013,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Hot_Energy",
    DotDatas = {
      [1] = {
        EffectId = 60105,
        Interval = 1,
        Type = "SkillEffect"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {6012}
  },
  [4010014] = {
    AddAttrs = {
      [1] = {
        AttrName = "EnmityValue",
        Value = 0.3
      }
    },
    BuffId = 4010014,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Berserk",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    OverrideAttrs = T.RT_321
  },
  [4010015] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "HeavyAttack",
        RateZone = "Normal",
        Value = 0.9
      }
    },
    BuffId = 4010015,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "AddComboCount",
        Value = 40
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {6032}
  },
  [4010016] = {
    AddAttrs = {
      [1] = T.RT_377
    },
    BuffEffects = {6042},
    BuffId = 4010016,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Weapon_Spd_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020101] = {
    AddAttrs = T.RT_382,
    BuffId = 4020101,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020102] = {
    AddAttrs = {
      [1] = T.RT_383
    },
    BuffId = 4020102,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020103] = {
    AddAttrs = T.RT_385,
    BuffId = 4020103,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020104] = {
    AddAttrs = {
      [1] = T.RT_386
    },
    BuffId = 4020104,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020105] = {
    AddAttrs = {
      [1] = T.RT_381,
      [2] = T.RT_383
    },
    BuffId = 4020105,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020106] = {
    AddAttrs = {
      [1] = T.RT_384,
      [2] = T.RT_383
    },
    BuffId = 4020106,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020107] = {
    AddAttrs = {
      [1] = T.RT_384,
      [2] = T.RT_381
    },
    BuffId = 4020107,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020108] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxES",
        Rate = 0.6,
        Stackable = 1
      },
      [2] = {
        AttrName = "MaxHp",
        Rate = 0.65,
        Stackable = 1
      }
    },
    BuffId = 4020108,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020109] = {
    AddAttrs = {
      [1] = T.RT_384,
      [2] = T.RT_386
    },
    BuffId = 4020109,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020201] = {
    AddPassiveEffect = {4020101},
    BuffId = 4020201,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020202] = {
    AddPassiveEffect = {4020102},
    BuffId = 4020202,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020203] = {
    AddPassiveEffect = {4020103},
    BuffId = 4020203,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020204] = {
    AddPassiveEffect = {4020104},
    BuffId = 4020204,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020205] = {
    AddPassiveEffect = {4020105},
    BuffId = 4020205,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020206] = {
    AddPassiveEffect = {4020106},
    BuffId = 4020206,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020207] = {
    AddPassiveEffect = {4020107},
    BuffId = 4020207,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020208] = {
    AddPassiveEffect = {4020108},
    BuffId = 4020208,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020209] = {
    AddPassiveEffect = {4020109},
    BuffId = 4020209,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020210] = {
    AddPassiveEffect = {4020110},
    BuffId = 4020210,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020211] = {
    AddPassiveEffect = {4020111},
    BuffId = 4020211,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020212] = {
    AddPassiveEffect = {4020112},
    BuffId = 4020212,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020213] = {
    AddPassiveEffect = {4020113},
    BuffId = 4020213,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020214] = {
    AddPassiveEffect = {4020114},
    BuffId = 4020214,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020215] = {
    AddPassiveEffect = {4020115},
    BuffId = 4020215,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020216] = {
    AddPassiveEffect = {4020116},
    BuffId = 4020216,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020217] = {
    AddPassiveEffect = {4020117},
    BuffId = 4020217,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020301] = {
    AddPassiveEffect = T.RT_387,
    BuffId = 4020301,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020302] = {
    AddPassiveEffect = T.RT_389,
    BuffId = 4020302,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020303] = {
    AddPassiveEffect = T.RT_390,
    BuffId = 4020303,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020304] = {
    AddPassiveEffect = T.RT_391,
    BuffId = 4020304,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020305] = {
    AddPassiveEffect = T.RT_392,
    BuffId = 4020305,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020306] = {
    AddPassiveEffect = T.RT_393,
    BuffId = 4020306,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020307] = {
    AddPassiveEffect = T.RT_394,
    BuffId = 4020307,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020308] = {
    AddPassiveEffect = T.RT_395,
    BuffId = 4020308,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020309] = {
    AddPassiveEffect = T.RT_396,
    BuffId = 4020309,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020310] = {
    AddPassiveEffect = T.RT_397,
    BuffId = 4020310,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020311] = {
    AddPassiveEffect = T.RT_398,
    BuffId = 4020311,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020312] = {
    AddPassiveEffect = T.RT_399,
    BuffId = 4020312,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020313] = {
    AddPassiveEffect = T.RT_400,
    BuffId = 4020313,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388
  },
  [4020401] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = -0.45}
    },
    BuffId = 4020401,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Down",
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020402] = {
    AddAttrs = {
      [1] = {
        AttrName = "DEF",
        Rate = -0.2,
        Stackable = 1
      }
    },
    BuffId = 4020402,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Down",
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020403] = {
    AddAttrs = {
      [1] = T.RT_401
    },
    BuffId = 4020403,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Up",
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020404] = {
    AddAttrs = {
      [1] = T.RT_402
    },
    BuffId = 4020404,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020405] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = 0.45}
    },
    BuffId = 4020405,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Up",
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020406] = {
    AddAttrs = T.RT_186,
    BuffId = 4020406,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020407] = {
    AddAttrs = T.RT_374,
    BuffId = 4020407,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020408] = {
    AddAttrs = T.RT_404,
    BuffId = 4020408,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020409] = {
    AddAttrs = T.RT_404,
    BuffId = 4020409,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020410] = {
    BuffId = 4020410,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        DefaultHealFX = 1,
        Interval = 1,
        Rate = 0.075,
        Type = "Hot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020411] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = 0.15,
        Stackable = 1
      }
    },
    BuffId = 4020411,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020412] = {
    AddAttrs = {
      [1] = T.RT_403
    },
    BuffId = 4020412,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Up",
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020413] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillSpeed",
        Rate = 0.2,
        Stackable = 1
      }
    },
    BuffId = 4020413,
    BuffType = T.RT_3,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020414] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Stackable = 1,
        Value = 0.25
      }
    },
    BuffId = 4020414,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020415] = {
    BuffId = 4020415,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        DefaultHealFX = 1,
        Interval = 1,
        Rate = 0.035,
        Type = "Hot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020501] = {
    AddAttrs = T.RT_385,
    BuffId = 4020501,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020502] = {
    AddAttrs = T.RT_406,
    BuffId = 4020502,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020503] = {
    AddAttrs = T.RT_408,
    BuffId = 4020503,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020504] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxES",
        Rate = 0.9,
        Stackable = 1
      }
    },
    BuffId = 4020504,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020505] = {
    AddAttrs = T.RT_406,
    BuffId = 4020505,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020506] = {
    AddAttrs = T.RT_406,
    BuffId = 4020506,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020507] = {
    AddAttrs = T.RT_406,
    BuffId = 4020507,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020508] = {
    AddAttrs = {
      [1] = T.RT_409
    },
    BuffId = 4020508,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020509] = {
    AddAttrs = T.RT_144,
    BuffId = 4020509,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020510] = {
    AddAttrs = T.RT_408,
    BuffId = 4020510,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020511] = {
    AddAttrs = T.RT_408,
    BuffId = 4020511,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020512] = {
    AddAttrs = T.RT_408,
    BuffId = 4020512,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020513] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = 0.55,
        Stackable = 1
      }
    },
    BuffId = 4020513,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020514] = {
    AddAttrs = T.RT_411,
    BuffId = 4020514,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020515] = {
    AddAttrs = T.RT_411,
    BuffId = 4020515,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020516] = {
    AddAttrs = T.RT_411,
    BuffId = 4020516,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020517] = {
    AddAttrs = T.RT_411,
    BuffId = 4020517,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020601] = {
    AddAttrs = T.RT_416,
    BuffId = 4020601,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020602] = {
    AddAttrs = T.RT_416,
    BuffId = 4020602,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020603] = {
    AddAttrs = {
      [1] = T.RT_410,
      [2] = {
        AttrName = "DEF",
        Rate = 0.5,
        Stackable = 1
      },
      [3] = {
        AttrName = "MaxHp",
        Rate = 0.5,
        Stackable = 1
      },
      [4] = {
        AttrName = "MaxES",
        Rate = 0.5,
        Stackable = 1
      }
    },
    BuffId = 4020603,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020604] = {
    AddAttrs = T.RT_416,
    BuffId = 4020604,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020605] = {
    AddAttrs = T.RT_416,
    BuffId = 4020605,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020606] = {
    AddAttrs = T.RT_416,
    BuffId = 4020606,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020607] = {
    AddAttrs = {
      [1] = T.RT_384,
      [2] = T.RT_409,
      [3] = T.RT_381,
      [4] = {
        AttrName = "MaxES",
        Rate = 0.3,
        Stackable = 1
      }
    },
    BuffId = 4020607,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020608] = {
    AddAttrs = T.RT_418,
    BuffId = 4020608,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020609] = {
    AddAttrs = {
      [1] = T.RT_402,
      [2] = T.RT_401,
      [3] = T.RT_419,
      [4] = T.RT_420
    },
    BuffId = 4020609,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020610] = {
    AddAttrs = T.RT_416,
    BuffId = 4020610,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020611] = {
    AddAttrs = T.RT_418,
    BuffId = 4020611,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020612] = {
    AddAttrs = T.RT_416,
    BuffId = 4020612,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020613] = {
    AddAttrs = T.RT_416,
    BuffId = 4020613,
    BuffType = T.RT_3,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020701] = {
    BuffId = 4020701,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_422,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020702] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = 4}
    },
    BuffId = 4020702,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020703] = {
    BuffId = 4020703,
    BuffType = T.RT_3
  },
  [4020704] = {
    BuffId = 4020704,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxEs",
        DamageTag = T.RT_10,
        DamageType = "Water",
        Interval = 1,
        Rate = 0.1,
        Type = "Dot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020705] = {
    BuffId = 4020705,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        DamageType = "Fire",
        Interval = 1,
        Rate = 0.2,
        Type = "Dot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020706] = {
    AddAttrs = T.RT_424,
    BuffId = 4020706,
    BuffType = T.RT_3,
    CombatConditionId = 4020707,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020707] = {
    AddAttrs = T.RT_426,
    BuffId = 4020707,
    BuffType = T.RT_3,
    CombatConditionId = 4020706,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020708] = {
    AddAttrs = T.RT_424,
    BuffId = 4020708,
    BuffType = T.RT_3,
    CombatConditionId = 4020706,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020709] = {
    AddAttrs = T.RT_426,
    BuffId = 4020709,
    BuffType = T.RT_3,
    CombatConditionId = 4020707,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020710] = {
    AddAttrs = T.RT_424,
    BuffId = 4020710,
    BuffType = T.RT_3,
    CombatConditionId = 4020708,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020711] = {
    AddAttrs = T.RT_424,
    BuffId = 4020711,
    BuffType = T.RT_3,
    CombatConditionId = 4020709,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020712] = {
    AddAttrs = {
      [1] = {AttrName = "MaxES", Rate = 0.5}
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_4020712.BP_Buff_4020712",
    BuffId = 4020712,
    BuffType = T.RT_3,
    CombatConditionId = 4020711,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020713] = {
    AddAttrs = T.RT_301,
    BuffId = 4020713,
    BuffType = T.RT_3,
    CombatConditionId = 4020711,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020714] = {
    AddAttrs = T.RT_428,
    BuffId = 4020714,
    BuffType = T.RT_3,
    CombatConditionId = 4020712,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020715] = {
    AddAttrs = T.RT_428,
    BuffId = 4020715,
    BuffType = T.RT_3,
    CombatConditionId = 4020713,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020716] = {
    AddAttrs = T.RT_428,
    BuffId = 4020716,
    BuffType = T.RT_3,
    CombatConditionId = 4020714,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020717] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = 0.1}
    },
    BuffId = 4020717,
    BuffType = T.RT_3,
    CombatConditionId = 4020715,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020718] = {
    AddPassiveEffect = T.RT_429,
    BuffId = 4020718,
    BuffType = T.RT_3,
    CombatConditionId = 4020714,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020719] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = -0.05}
    },
    BuffId = 4020719,
    BuffType = T.RT_3,
    CombatConditionId = 4020711,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020720] = {
    AddAttrs = {
      [1] = {AttrName = "MaxHp", Rate = 0.1}
    },
    BuffId = 4020720,
    BuffType = T.RT_3,
    CombatConditionId = 4020710,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020721] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = 0.15}
    },
    BuffId = 4020721,
    BuffType = T.RT_3,
    CombatConditionId = 4020710,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020722] = {
    AddAttrs = T.RT_428,
    BuffId = 4020722,
    BuffType = T.RT_3,
    CombatConditionId = 4020710,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020723] = {
    AddPassiveEffect = T.RT_429,
    BuffId = 4020723,
    BuffType = T.RT_3,
    CombatConditionId = 4020716,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020724] = {
    AddPassiveEffect = {4020119},
    BuffId = 4020724,
    BuffType = T.RT_3,
    CombatConditionId = 4020710,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020725] = {
    AddAttrs = {
      [1] = {
        AttrName = "DEF",
        Rate = -0.01,
        Stackable = 1
      }
    },
    BuffId = 4020725,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Def_Down",
    MaxLayer = 12,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020726] = {
    BuffId = 4020726,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        DefaultHealFX = 1,
        Interval = 1,
        Rate = 0.03,
        Type = "Hot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020727] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.5
      }
    },
    BuffId = 4020727,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        DamageType = "Fire",
        Interval = 1,
        Rate = 0.04,
        Type = "Dot"
      },
      [2] = {
        BaseAttr = "MaxEs",
        DamageTag = T.RT_10,
        DamageType = "Fire",
        Interval = 1,
        Rate = 0.02,
        Type = "Dot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020728] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 0.25
      },
      [2] = T.RT_430
    },
    BuffId = 4020728,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020729] = {
    AddAttrs = T.RT_318,
    BuffId = 4020729,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020730] = {
    AddPassiveEffect = {4020120},
    BuffId = 4020730,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020731] = {
    AddAttrs = T.RT_426,
    BuffId = 4020731,
    BuffType = T.RT_3,
    CombatConditionId = 4020709,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4020732] = {
    AddAttrs = T.RT_426,
    BuffId = 4020732,
    BuffType = T.RT_3,
    CombatConditionId = 4020708,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030001] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        IndividualRateZone = 1,
        Value = 2.5
      }
    },
    BuffId = 4030001,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030002] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        IndividualRateZone = 1,
        Value = -0.9
      }
    },
    BuffId = 4030002,
    BuffType = T.RT_14,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030003] = {
    AddAttrs = {
      [1] = {
        AttrName = "ExcelWeaponModifierValue",
        Value = 6
      }
    },
    BuffId = 4030003,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030004] = {
    AddAttrs = {
      [1] = T.RT_412
    },
    BuffId = 4030004,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030005] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillSustain",
        Rate = -0.5,
        Stackable = 1
      },
      [2] = {
        AttrName = "SkillEfficiency",
        Rate = -0.5,
        Stackable = 1
      }
    },
    BuffId = 4030005,
    BuffType = T.RT_14,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030006] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxHp",
        Rate = 5,
        Stackable = 1
      }
    },
    BuffId = 4030006,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030007] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxEs",
        Rate = 5,
        Stackable = 1
      }
    },
    BuffId = 4030007,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030008] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "BossDown",
        Value = 2
      }
    },
    BuffId = 4030008,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030101] = {
    BuffEffects = T.RT_431,
    BuffId = 4030101,
    BuffType = {11, 4030101},
    BuffTypeImgPath = "ActivityWeapon_01",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_432
  },
  [4030201] = {
    BuffEffects = T.RT_431,
    BuffId = 4030201,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_02",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 9999,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4030301] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.005
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4030301,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_05",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 1000,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4030401] = {
    BuffEffects = T.RT_431,
    BuffId = 4030401,
    BuffType = {11, 4030401},
    BuffTypeImgPath = "ActivityWeapon_04",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4030601] = {
    BuffEffects = T.RT_431,
    BuffId = 4030601,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_06",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 30,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030602] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Weapon",
        IndividualRateZone = 1,
        Value = 1
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4030602,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_14",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4030701] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "FallAttack",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.025
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4030701,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 40,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4030801] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierValue",
        Stackable = 1,
        Value = 0.025
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4030801,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_03",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    LayerExtraBuff = {
      [100] = 4030802
    },
    MaxLayer = 100,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [4030802] = {
    BuffEffects = T.RT_434,
    BuffId = 4030802,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_13",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {40201007}
  },
  [4030901] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Melee",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.001
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4030901,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_07",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 9999,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4031001] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "SlideAttack",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.1
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4031001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_08",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 9999,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4031101] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Melee",
        IndividualRateZone = 1,
        Value = 1
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4031101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_12",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_432
  },
  [4031201] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "HeavyAttack",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.03
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4031201,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_15",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 9999,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4031401] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackRangeModifierValue",
        Stackable = 1,
        Value = 120
      },
      [2] = {
        AttrName = "DamageRate",
        DamageTag = "HeavyAttack",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 0.25
      }
    },
    BuffEffects = T.RT_431,
    BuffId = 4031401,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_10",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_433
  },
  [4031501] = {
    BuffEffects = T.RT_431,
    BuffId = 4031501,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_09",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_432
  },
  [4031502] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "WeaponVerify15",
        IndividualRateZone = 1,
        Stackable = 1,
        Value = 1
      }
    },
    BuffEffects = T.RT_434,
    BuffId = 4031502,
    BuffType = T.RT_3,
    BuffTypeImgPath = "ActivityWeapon_13",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 9999,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {40201008}
  },
  [5000001] = {
    BuffEffects = T.RT_231,
    BuffId = 5000001,
    BuffTypeImgPath = "Weapon_Spd_Down",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.5
  },
  [5000002] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierValue",
        Stackable = 1,
        Value = 0.2
      }
    },
    BuffEffects = T.RT_323,
    BuffId = 5000002,
    BuffTypeImgPath = "Cri_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000003] = {
    BuffEffects = T.RT_208,
    BuffId = 5000003,
    BuffTypeImgPath = "Hot_Energy",
    DeadNotRemove = true,
    DotDatas = T.RT_446,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000004] = {
    AddAttrs = {
      [1] = {
        AttrName = "AttackSpeed",
        Stackable = 1,
        Value = 0.5
      }
    },
    BuffEffects = T.RT_80,
    BuffId = 5000004,
    BuffTypeImgPath = "Weapon_Spd_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000005] = {
    AddAttrs = T.RT_382,
    BuffEffects = T.RT_208,
    BuffId = 5000005,
    BuffTypeImgPath = "Hot_Up",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.03,
        Stackable = 1,
        Type = "Hot"
      }
    },
    InitialEffect = {500000001},
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    UISpecialEffect = T.RT_371
  },
  [5000006] = {
    BuffId = 5000006,
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        AllowSkillIntensity = 1,
        DamageTag = T.RT_10,
        Interval = 0.2,
        Rate = 1,
        Type = "Dot"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000007] = {
    BuffEffects = T.RT_447,
    BuffId = 5000007,
    BuffTypeImgPath = "Dot_Common",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        AllowSkillIntensity = 1,
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 1,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000008] = {
    BuffEffects = T.RT_447,
    BuffId = 5000008,
    BuffTypeImgPath = "Dot_Common",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        AllowSkillIntensity = 1,
        DamageTag = T.RT_10,
        Interval = 0.2,
        Rate = 2,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000011] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierValue",
        Value = 0.2
      }
    },
    BuffEffects = T.RT_323,
    BuffId = 5000011,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Cri_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [5000012] = {
    BuffId = 5000012,
    BuffType = T.RT_448,
    HaloDatas = {
      [1] = {
        AuraRange = 4000,
        BuffId = 5000011,
        Camp = "OtherFriend"
      }
    },
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [5000013] = {
    BuffEffects = T.RT_208,
    BuffId = 5000013,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Energy",
    DotDatas = T.RT_446,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [5000014] = {
    BuffId = 5000014,
    BuffType = T.RT_448,
    HaloDatas = {
      [1] = {
        AuraRange = 4000,
        BuffId = 5000013,
        Camp = "OtherFriend"
      }
    },
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [5000015] = {
    BuffEffects = T.RT_208,
    BuffId = 5000015,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Common_Buff",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [5000016] = {
    BuffId = 5000016,
    BuffType = T.RT_448,
    HaloDatas = {
      [1] = {
        AuraRange = 4000,
        BuffId = 5000015,
        Camp = "OtherFriend"
      }
    },
    MaxLayer = 5,
    MergeRule1 = "Personal",
    MergeRule2 = "NewFree"
  },
  [5000017] = {
    BuffId = 5000017,
    LockHp = T.RT_449,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [5000018] = {
    BuffId = 5000018,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0.05,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_450
  },
  [5000019] = {
    BuffId = 5000019,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0.01,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_450
  },
  [5000020] = {
    BuffId = 5000020,
    BuffType = T.RT_3,
    CannotBeHitted = true,
    ForbidBuffType = {
      41,
      43,
      11
    },
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451,
    VisualEffects = {900064}
  },
  [5000021] = {
    AddAttrs = {
      [1] = {
        AttrName = "MoveSpeedAddRate",
        Value = -0.95
      }
    },
    BuffId = 5000021,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {900044}
  },
  [5000022] = {
    BuffId = 5000022,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_454,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_455
  },
  [5000100] = {
    AddAttrs = T.RT_459,
    BuffId = 5000100,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_460
  },
  [5000101] = {
    AddAttrs = T.RT_462,
    BuffId = 5000101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_460
  },
  [5000102] = {
    AddAttrs = T.RT_462,
    BuffEffects = {10301004},
    BuffId = 5000102,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [5000103] = {
    BuffId = 5000103,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Fire",
    DeadNotRemove = true,
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0,
        Type = "Dot",
        Value = 5
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_450
  },
  [5000104] = {
    AddAttrs = {
      [1] = {AttrName = "Def", Rate = 99999999999}
    },
    BuffId = 5000104,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Def_Up",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_463,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451,
    VisualEffects = T.RT_464
  },
  [5000105] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_5000105.BP_Buff_5000105",
    BuffId = 5000105,
    BuffType = T.RT_145,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SetCharacterTag = "LightHit"
  },
  [5000106] = {
    BuffId = 5000106,
    BuffType = T.RT_3,
    CameraParam = T.RT_465,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000201] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_5000201.BP_Buff_5000201",
    BuffId = 5000201,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000202] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000202,
    BuffType = T.RT_311,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunCommon"
  },
  [5000203] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_5000203.BP_Buff_5000203",
    BuffId = 5000203,
    BuffType = T.RT_150,
    DisableSkills = T.RT_466,
    DotDatas = {
      [1] = {
        EffectId = 104,
        Immediately = 1,
        Interval = -1,
        Type = "SkillEffect"
      }
    },
    EnableFlight = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000204] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000204,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        EffectId = 103,
        Interval = 3,
        Type = "SkillEffect"
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {241}
  },
  [5000205] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000205,
    BuffType = T.RT_311,
    BuffTypeImgPath = "Stun",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 100,
    SetCharacterTag = "Stun",
    StunType = "StunCommon"
  },
  [5000206] = {
    AddAttrs = T.RT_459,
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000206,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {244}
  },
  [5000207] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000207,
    BuffType = T.RT_337,
    BuffTypeImgPath = "Invincible",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {"Hit", "Controlled"},
    Priority = 1000,
    SpecialEffect = T.RT_262,
    UISpecialEffect = T.RT_263,
    VisualEffects = {245}
  },
  [5000208] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxAvoidExecuteTimes",
        Value = 2
      },
      [2] = {
        AttrName = "AvoidChargeCd",
        Rate = -0.5
      }
    },
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000208,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {246}
  },
  [5000209] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_Paoku_Common.BP_Buff_Paoku_Common",
    BuffId = 5000209,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000210] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_5000210.BP_Buff_5000210",
    BuffCapSize = 20,
    BuffId = 5000210,
    BuffType = T.RT_150,
    CameraParam = T.RT_465,
    DisableSkills = T.RT_466,
    EnableFlight = 1,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = {"Avoid"}
  },
  [5000301] = {
    AddAttrs = {
      [1] = {
        AttrName = "WalkSpeedModifier",
        Value = 0.2
      },
      [2] = T.RT_456,
      [3] = T.RT_457,
      [4] = T.RT_458
    },
    BuffId = 5000301,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000302] = {
    BuffId = 5000302,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Energy",
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "SpChange",
        Value = 50
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000303] = {
    AddPassiveEffect = {5000303},
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_5000303.BP_Buff_5000303",
    BuffId = 5000303,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000304] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Normal",
        Value = 2
      }
    },
    AddPassiveEffect = {5000304},
    BuffId = 5000304,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5000305] = {
    BuffId = 5000305,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_10,
        DamageType = "TrueDamage",
        Interval = 1,
        NotMortal = 1,
        Rate = 0.03,
        Type = "Dot",
        Value = 5
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5010001] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = 2.5},
      [2] = {AttrName = "MaxHp", Rate = 2.5},
      [3] = {AttrName = "MaxES", Rate = 2.5}
    },
    BuffId = 5010001,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5010002] = {
    AddAttrs = T.RT_470,
    BuffId = 5010002,
    BuffType = T.RT_3,
    MaxLayer = 100,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5010003] = {
    AddAttrs = {
      [1] = T.RT_402,
      [2] = T.RT_419,
      [3] = T.RT_420
    },
    BuffId = 5010003,
    BuffType = T.RT_3,
    MaxLayer = 8,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5010004] = {
    AddAttrs = {
      [1] = T.RT_467,
      [2] = {
        AttrName = "MaxHp",
        Rate = 2.5,
        Stackable = 1
      },
      [3] = {
        AttrName = "MaxES",
        Rate = 2.5,
        Stackable = 1
      }
    },
    BuffId = 5010004,
    BuffType = T.RT_3,
    MaxLayer = 8,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [5010005] = {
    AddAttrs = T.RT_470,
    BuffId = 5010005,
    BuffType = T.RT_3,
    MaxLayer = 100,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000002] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = -0.5
      }
    },
    BuffId = 6000002,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000003] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = -0.25
      }
    },
    BuffId = 6000003,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000004] = {
    AddAttrs = T.RT_379,
    BuffId = 6000004,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000005] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = 0.75
      }
    },
    BuffId = 6000005,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000006] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = 1
      }
    },
    BuffId = 6000006,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000007] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = 1.5
      }
    },
    BuffId = 6000007,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000008] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Level",
        Value = 2
      }
    },
    BuffId = 6000008,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000011] = {
    AddAttrs = {
      [1] = T.RT_269
    },
    BuffId = 6000011,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000012] = {
    AddAttrs = {
      [1] = {
        AttrName = "WaterDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000012,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Water_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000013] = {
    AddAttrs = {
      [1] = {
        AttrName = "WaterDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000013,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Water"
  },
  [6000014] = {
    AddAttrs = {
      [1] = T.RT_264
    },
    BuffId = 6000014,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Water"
  },
  [6000021] = {
    AddAttrs = {
      [1] = T.RT_265
    },
    BuffId = 6000021,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000022] = {
    AddAttrs = {
      [1] = {
        AttrName = "FireDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000022,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Fire_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000023] = {
    AddAttrs = {
      [1] = {
        AttrName = "FireDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000023,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Fire"
  },
  [6000024] = {
    AddAttrs = {
      [1] = T.RT_268
    },
    BuffId = 6000024,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Fire"
  },
  [6000031] = {
    AddAttrs = {
      [1] = T.RT_266
    },
    BuffId = 6000031,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000032] = {
    AddAttrs = {
      [1] = {
        AttrName = "ThunderDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000032,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Thunder_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000033] = {
    AddAttrs = {
      [1] = {
        AttrName = "ThunderDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000033,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Thunder"
  },
  [6000034] = {
    AddAttrs = {
      [1] = T.RT_270
    },
    BuffId = 6000034,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Thunder"
  },
  [6000041] = {
    AddAttrs = {
      [1] = T.RT_267
    },
    BuffId = 6000041,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000042] = {
    AddAttrs = {
      [1] = {
        AttrName = "WindDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000042,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Wind_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000043] = {
    AddAttrs = {
      [1] = {
        AttrName = "WindDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000043,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Wind"
  },
  [6000044] = {
    AddAttrs = {
      [1] = T.RT_271
    },
    BuffId = 6000044,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Wind"
  },
  [6000051] = {
    AddAttrs = {
      [1] = T.RT_273
    },
    BuffId = 6000051,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000052] = {
    AddAttrs = {
      [1] = {
        AttrName = "DarkDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000052,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000053] = {
    AddAttrs = {
      [1] = {
        AttrName = "DarkDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000053,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Dark"
  },
  [6000054] = {
    AddAttrs = {
      [1] = T.RT_274
    },
    BuffId = 6000054,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Dark"
  },
  [6000061] = {
    AddAttrs = {
      [1] = T.RT_275
    },
    BuffId = 6000061,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000062] = {
    AddAttrs = {
      [1] = {
        AttrName = "LightDamagedRate",
        Value = -0.25
      }
    },
    BuffId = 6000062,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000063] = {
    AddAttrs = {
      [1] = {
        AttrName = "LightDamagedRate",
        Value = 0.5
      }
    },
    BuffId = 6000063,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Light"
  },
  [6000064] = {
    AddAttrs = {
      [1] = T.RT_272
    },
    BuffId = 6000064,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    WeaknessType = "Light"
  },
  [6000071] = {
    BuffId = 6000071,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000072] = {
    BuffId = 6000072,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000073] = {
    BuffId = 6000073,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000074] = {
    BuffId = 6000074,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000075] = {
    BuffId = 6000075,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000076] = {
    BuffId = 6000076,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000077] = {
    BuffId = 6000077,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000078] = {
    BuffId = 6000078,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000079] = {
    BuffId = 6000079,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000080] = {
    BuffId = 6000080,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000081] = {
    BuffId = 6000081,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000082] = {
    BuffId = 6000082,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000102] = {
    BuffId = 6000102,
    BuffType = T.RT_368,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.96,
    VisualEffects = T.RT_491
  },
  [6000103] = {
    BuffId = 6000103,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 0.2,
        Rate = 0.1,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000107] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = -0.9}
    },
    BuffId = 6000107,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Def_Down",
    DotDatas = {
      [1] = {
        DamageTag = {
          "Dot",
          "PhantomAvoid",
          "Poison"
        },
        Interval = 2,
        Rate = 0.1,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {600000302}
  },
  [6000109] = {
    BuffId = 6000109,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = {
      [1] = {
        DamageTag = {
          "Dot",
          "PhantomAvoid",
          "Blood"
        },
        Interval = 2,
        Rate = 0.3,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_492
  },
  [6000111] = {
    BuffId = 6000111,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        Interval = 2,
        Rate = 0.02,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [6000112] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = 0.5},
      [2] = T.RT_135,
      [3] = T.RT_493,
      [4] = {
        AttrName = "MoveSpeedAddRate",
        Value = 0.4
      }
    },
    BuffId = 6000112,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_464
  },
  [6000113] = {
    BuffId = 6000113,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.7,
    VisualEffects = {700308}
  },
  [6000114] = {
    BuffId = 6000114,
    BuffType = T.RT_189,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.7,
    VisualEffects = T.RT_309
  },
  [6000115] = {
    BuffId = 6000115,
    BuffType = T.RT_173,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.5,
    VisualEffects = T.RT_380
  },
  [6000116] = {
    BuffId = 6000116,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Mon_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {600001001, 600001011}
  },
  [6000117] = {
    BuffId = 6000117,
    BuffType = T.RT_3,
    DMMIParams = {
      DMMIColor = {
        50,
        50,
        50,
        1
      },
      DMMILineWidth = 0.5
    },
    FXMID = {
      ParamType = "Invisibility",
      Priority = 1000
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [6000118] = {
    BuffId = 6000118,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000119] = {
    BuffId = 6000119,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000120] = {
    BuffId = 6000120,
    BuffType = T.RT_3,
    FresnelParams = T.RT_261,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000121] = {
    BuffId = 6000121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Team_Caster",
    HaloDatas = {
      [1] = {
        AuraRange = 1500,
        BuffId = 6000122,
        Camp = "OtherFriend"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {600001501}
  },
  [6000122] = {
    AddAttrs = {
      [1] = T.RT_430,
      [2] = T.RT_496,
      [3] = T.RT_9,
      [4] = T.RT_377
    },
    BuffId = 6000122,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Team_Roused",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_497
  },
  [6000123] = {
    AddAttrs = {
      [1] = T.RT_496
    },
    BuffId = 6000123,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_497
  },
  [6000200] = {
    BuffId = 6000200,
    DisperseBuffType = T.RT_498,
    ForbidBuffType = T.RT_498,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [6000201] = {
    BuffId = 6000201,
    BuffTypeImgPath = "Common_Buff",
    DisperseBuffType = T.RT_498,
    ForbidBuffType = T.RT_498,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [6000202] = {
    BuffId = 6000202,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [6000203] = {
    BuffId = 6000203,
    BuffTypeImgPath = "Common_Buff",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [6000204] = {
    BuffId = 6000204,
    CannotBeCutTN = true,
    ForbidBuffType = T.RT_338,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    SpecialEffect = T.RT_262
  },
  [6000205] = {
    BuffId = 6000205,
    BuffTypeImgPath = "Invincible",
    CannotBeCutTN = true,
    ForbidBuffType = T.RT_338,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterTarget = true,
    SpecialEffect = T.RT_262
  },
  [6000206] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "BossDown",
        Value = 0.5
      }
    },
    BuffId = 6000206,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000207] = {
    BuffId = 6000207,
    BuffType = T.RT_3,
    CannotBeCutTN = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000208] = {
    BuffId = 6000208,
    BuffType = T.RT_3,
    DisperseBuffType = T.RT_499,
    ForbidBuffType = T.RT_499,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [6000209] = {
    BuffId = 6000209,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterTarget = true
  },
  [6000210] = {
    BuffId = 6000210,
    CannotBeHitted = true,
    ForbidBuffType = T.RT_463,
    ForbidCatch = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_451
  },
  [6000211] = {
    BuffId = 6000211,
    LockHp = T.RT_217,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6000212] = {
    BuffId = 6000212,
    BuffType = T.RT_337,
    BuffTypeImgPath = "Invincible",
    DisperseBuffType = T.RT_338,
    ForbidBuffType = T.RT_338,
    FresnelParams = T.RT_261,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    NotEnterTarget = true,
    Priority = 1000,
    SpecialEffect = T.RT_262,
    UISpecialEffect = T.RT_263
  },
  [6000213] = {
    BuffId = 6000213,
    BuffType = T.RT_340,
    DisableSkills = {"MonSPSkill"},
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [6000301] = {
    BuffId = 6000301,
    BuffType = {20, 103},
    BuffTypeImgPath = "Dot_Fire",
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        DamageType = "Fire",
        EnableIcon = 1,
        Interval = 1,
        Rate = 0.1,
        Type = "Dot"
      }
    },
    IsShowInBillboard = true,
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_500
  },
  [6000401] = {
    AddPassiveEffect = T.RT_387,
    BuffId = 6000401,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990102,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000402] = {
    AddPassiveEffect = T.RT_389,
    BuffId = 6000402,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Burst",
    FresnelParams = T.RT_261,
    IconPriority = 990202,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000403] = {
    AddPassiveEffect = T.RT_390,
    BuffId = 6000403,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Poison",
    FresnelParams = T.RT_261,
    IconPriority = 990402,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000404] = {
    AddPassiveEffect = T.RT_391,
    BuffId = 6000404,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Thunder",
    FresnelParams = T.RT_261,
    IconPriority = 990501,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000405] = {
    AddPassiveEffect = T.RT_392,
    BuffId = 6000405,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Blood",
    FresnelParams = T.RT_261,
    IconPriority = 990303,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000406] = {
    AddPassiveEffect = T.RT_393,
    BuffId = 6000406,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Fade",
    FresnelParams = T.RT_261,
    IconPriority = 990302,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000407] = {
    AddPassiveEffect = T.RT_394,
    BuffId = 6000407,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Shield",
    FresnelParams = T.RT_261,
    IconPriority = 990101,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000408] = {
    AddPassiveEffect = T.RT_395,
    BuffId = 6000408,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Revenge",
    FresnelParams = T.RT_261,
    IconPriority = 990301,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000409] = {
    AddPassiveEffect = T.RT_396,
    BuffId = 6000409,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_IceOrb",
    FresnelParams = T.RT_261,
    IconPriority = 990103,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000410] = {
    AddPassiveEffect = T.RT_397,
    BuffId = 6000410,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Reflect",
    FresnelParams = T.RT_261,
    IconPriority = 990201,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000411] = {
    AddPassiveEffect = T.RT_398,
    BuffId = 6000411,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Kamikaze",
    FresnelParams = T.RT_261,
    IconPriority = 990401,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000412] = {
    AddPassiveEffect = T.RT_399,
    BuffId = 6000412,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_ThunderLaser",
    FresnelParams = T.RT_261,
    IconPriority = 990502,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000413] = {
    AddPassiveEffect = T.RT_400,
    BuffId = 6000413,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Vampire",
    FresnelParams = T.RT_261,
    IconPriority = 990602,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000414] = {
    AddPassiveEffect = {6000114},
    BuffId = 6000414,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Threefold",
    IconPriority = 990601,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [6000415] = {
    AddPassiveEffect = {6000115},
    BuffId = 6000415,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990603,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000416] = {
    AddPassiveEffect = {6000116},
    BuffId = 6000416,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990604,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_388,
    Priority = 1000
  },
  [6000501] = {
    AddPassiveEffect = {6000201},
    BuffId = 6000501,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990102,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000502] = {
    AddPassiveEffect = {6000202},
    BuffId = 6000502,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Burst",
    FresnelParams = T.RT_261,
    IconPriority = 990202,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000503] = {
    AddPassiveEffect = {6000203},
    BuffId = 6000503,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Poison",
    FresnelParams = T.RT_261,
    IconPriority = 990402,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000504] = {
    AddPassiveEffect = {6000204},
    BuffId = 6000504,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Thunder",
    FresnelParams = T.RT_261,
    IconPriority = 990501,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000505] = {
    AddPassiveEffect = {6000205},
    BuffId = 6000505,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Blood",
    FresnelParams = T.RT_261,
    IconPriority = 990303,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000506] = {
    AddPassiveEffect = T.RT_179,
    BuffId = 6000506,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Fade",
    FresnelParams = T.RT_261,
    IconPriority = 990302,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000507] = {
    AddPassiveEffect = {6000207},
    BuffId = 6000507,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Shield",
    FresnelParams = T.RT_261,
    IconPriority = 990101,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000508] = {
    AddPassiveEffect = {6000208},
    BuffId = 6000508,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Revenge",
    FresnelParams = T.RT_261,
    IconPriority = 990301,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000509] = {
    AddPassiveEffect = {6000209},
    BuffId = 6000509,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_IceOrb",
    FresnelParams = T.RT_261,
    IconPriority = 990103,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000510] = {
    AddPassiveEffect = {6000210},
    BuffId = 6000510,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Reflect",
    FresnelParams = T.RT_261,
    IconPriority = 990201,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000511] = {
    AddPassiveEffect = {6000211},
    BuffId = 6000511,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Kamikaze",
    FresnelParams = T.RT_261,
    IconPriority = 990401,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000512] = {
    AddPassiveEffect = {6000212},
    BuffId = 6000512,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_ThunderLaser",
    FresnelParams = T.RT_261,
    IconPriority = 990502,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000513] = {
    AddPassiveEffect = T.RT_340,
    BuffId = 6000513,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Vampire",
    FresnelParams = T.RT_261,
    IconPriority = 990602,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000514] = {
    AddPassiveEffect = {6000214},
    BuffId = 6000514,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Threefold",
    IconPriority = 990601,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [6000515] = {
    AddPassiveEffect = {6000215},
    BuffId = 6000515,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990603,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000516] = {
    AddPassiveEffect = {6000216},
    BuffId = 6000516,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990604,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_494,
    Priority = 1000
  },
  [6000601] = {
    AddPassiveEffect = {6000301},
    BuffId = 6000601,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990102,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000602] = {
    AddPassiveEffect = {6000302},
    BuffId = 6000602,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Burst",
    FresnelParams = T.RT_261,
    IconPriority = 990202,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000603] = {
    AddPassiveEffect = {6000303},
    BuffId = 6000603,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Poison",
    FresnelParams = T.RT_261,
    IconPriority = 990402,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000604] = {
    AddPassiveEffect = {6000304},
    BuffId = 6000604,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Thunder",
    FresnelParams = T.RT_261,
    IconPriority = 990501,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000605] = {
    AddPassiveEffect = {6000305},
    BuffId = 6000605,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Blood",
    FresnelParams = T.RT_261,
    IconPriority = 990303,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000606] = {
    AddPassiveEffect = {6000306},
    BuffId = 6000606,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Fade",
    FresnelParams = T.RT_261,
    IconPriority = 990302,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000607] = {
    AddPassiveEffect = {6000307},
    BuffId = 6000607,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Shield",
    FresnelParams = T.RT_261,
    IconPriority = 990101,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000608] = {
    AddPassiveEffect = {6000308},
    BuffId = 6000608,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Revenge",
    FresnelParams = T.RT_261,
    IconPriority = 990301,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000609] = {
    AddPassiveEffect = {6000309},
    BuffId = 6000609,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_IceOrb",
    FresnelParams = T.RT_261,
    IconPriority = 990103,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000610] = {
    AddPassiveEffect = {6000310},
    BuffId = 6000610,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Reflect",
    FresnelParams = T.RT_261,
    IconPriority = 990201,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000611] = {
    AddPassiveEffect = {6000311},
    BuffId = 6000611,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Kamikaze",
    FresnelParams = T.RT_261,
    IconPriority = 990401,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000612] = {
    AddPassiveEffect = {6000312},
    BuffId = 6000612,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_ThunderLaser",
    FresnelParams = T.RT_261,
    IconPriority = 990502,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000613] = {
    AddPassiveEffect = {6000313},
    BuffId = 6000613,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Vampire",
    FresnelParams = T.RT_261,
    IconPriority = 990602,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000614] = {
    AddPassiveEffect = {6000314},
    BuffId = 6000614,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Threefold",
    IconPriority = 990601,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [6000615] = {
    AddPassiveEffect = {6000315},
    BuffId = 6000615,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990603,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [6000616] = {
    AddPassiveEffect = {6000316},
    BuffId = 6000616,
    BuffType = T.RT_501,
    BuffTypeImgPath = "Elite_Frozen",
    FresnelParams = T.RT_261,
    IconPriority = 990604,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NextPassParams = T.RT_495,
    Priority = 1000
  },
  [9000101] = {
    ActivateSkills = {
      Attack = 90001,
      HeavyShooting = 90002,
      Shooting = 90002
    },
    BuffId = 9000101,
    BuffType = T.RT_150,
    DisableSkills = T.RT_516,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000102] = {
    ActivateSkills = {
      Attack = 90011,
      HeavyShooting = 90012,
      Shooting = 90012
    },
    BuffId = 9000102,
    BuffType = T.RT_150,
    DisableSkills = T.RT_516,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000103] = {
    ActivateSkills = {
      Attack = 4010100,
      HeavyShooting = 4010101,
      Shooting = 4010101
    },
    BuffId = 9000103,
    BuffType = T.RT_150,
    DisableSkills = T.RT_516,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000104] = {
    ActivateSkills = {
      Attack = 4010200,
      HeavyShooting = 4010201,
      Shooting = 4010201
    },
    BuffId = 9000104,
    BuffType = T.RT_150,
    DisableSkills = T.RT_516,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000105] = {
    ActivateSkills = {
      Attack = 90021,
      HeavyShooting = 90022,
      Shooting = 90022
    },
    BuffId = 9000105,
    BuffType = T.RT_150,
    DisableSkills = T.RT_516,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000106] = {
    ActivateSkills = {Attack = 90031, Shooting = 90032},
    BuffId = 9000106,
    BuffType = T.RT_150,
    DisableSkills = {
      "FallAttack",
      "HeavyAttack",
      "SlideAttack",
      "Skill1",
      "Skill2",
      "Reload",
      "HeavyShooting"
    },
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9000201] = {
    BuffId = 9000201,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Dot_Common",
    DotDatas = T.RT_422,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [9999999] = {
    AddAttrs = {
      [1] = {
        AttrName = "ATK",
        Rate = 0.1,
        Value = 100
      }
    },
    BuffId = 9999999,
    DotDatas = {
      [1] = {
        DamageTag = T.RT_10,
        Interval = 1,
        Rate = 0.01,
        Type = "Dot"
      }
    },
    MaxLayer = 2,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    SeHitedMat = "Glass"
  },
  [10101101] = {
    AddAttrs = T.RT_13,
    BuffId = 10101101,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Rou_BG01_01",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_15
  },
  [10101102] = {
    AddAttrs = T.RT_13,
    BuffId = 10101102,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Rou_BG01_01",
    DotDatas = T.RT_18,
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_15
  },
  [10101103] = {
    AddAttrs = T.RT_13,
    AddPassiveEffect = {10101902},
    BuffId = 10101103,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Rou_BG01_01",
    DotDatas = T.RT_18,
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_15
  },
  [10101202] = {
    BuffId = 10101202,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10101991] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Stackable = 1,
        Type = "Melee",
        Value = 0.15
      },
      [2] = {
        AttrName = "WeaponCRDModifierRate",
        Stackable = 1,
        Type = "Melee",
        Value = 0.1
      }
    },
    BuffId = 10101991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102101] = {
    AddAttrs = T.RT_24,
    BuffId = 10102101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_25
  },
  [10102102] = {
    BuffDamagedRate = T.RT_26,
    BuffId = 10102102,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_27
  },
  [10102103] = {
    BuffId = 10102103,
    BuffType = T.RT_28,
    BuffTypeImgPath = "Endure",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [10102104] = {
    AddAttrs = {
      [1] = {
        AttrName = "DropDistance",
        Value = 750
      }
    },
    BuffId = 10102104,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102105] = {
    BuffId = 10102105,
    BuffType = T.RT_3,
    EffectCreatureID = 10102101,
    MaxLayer = 6,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [10102106] = {
    BuffId = 10102106,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Rou_BG02_01",
    IsShowInBillboard = true,
    MaxLayer = 10,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = {10102991}
  },
  [10102107] = {
    BattlePetCdRate = -0.3,
    BuffId = 10102107,
    BuffType = T.RT_31,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102108] = {
    BattlePetCdRate = -0.5,
    BuffId = 10102108,
    BuffType = T.RT_31,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102109] = {
    AddAttrs = T.RT_33,
    BuffId = 10102109,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102110] = {
    AddAttrs = T.RT_35,
    BuffId = 10102110,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10102991] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRIModifierRate",
        Stackable = 1,
        Type = "Ranged",
        Value = 0.15
      },
      [2] = {
        AttrName = "WeaponCRDModifierRate",
        Stackable = 1,
        Type = "Ranged",
        Value = 0.1
      }
    },
    BuffId = 10102991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103106] = {
    AddAttrs = {
      [1] = {AttrName = "SkillSpeed", Rate = "#1"}
    },
    BuffId = 10103106,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103203] = {
    BuffId = 10103203,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Energy",
    DotDatas = {
      [1] = {
        Interval = 1,
        Type = "SpChange",
        Value = "#1"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103205] = {
    BuffId = 10103205,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Energy",
    DotDatas = {
      [1] = {
        Interval = 2,
        Type = "SpChange",
        Value = "#1"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103901] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Rouge",
        Value = 0.25
      }
    },
    BuffId = 10103901,
    BuffType = T.RT_31,
    BuffTypeImgPath = "Damage_Up",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103902] = {
    BuffId = 10103902,
    BuffType = T.RT_31,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MaxLayer = 60,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10103903] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Rouge",
        Value = 0.75
      }
    },
    BuffId = 10103903,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_36
  },
  [10103904] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        DamageTag = "Skill",
        RateZone = "Rouge",
        Value = "#1"
      }
    },
    BuffId = 10103904,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_36
  },
  [10103991] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxES",
        Rate = 0.15,
        Stackable = 1
      }
    },
    BuffId = 10103991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10104102] = {
    AddAttrs = T.RT_38,
    BuffId = 10104102,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Skill_Inten_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10104103] = {
    AddAttrs = T.RT_40,
    BuffId = 10104103,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MaxLayer = 3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10104204] = {
    AddAttrs = T.RT_24,
    BuffId = 10104204,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10104302] = {
    AddAttrs = T.RT_20,
    BuffId = 10104302,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10104901] = {
    BuffId = 10104901,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {10104102}
  },
  [10104991] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Stackable = 1,
        Value = 0.15
      }
    },
    BuffId = 10104991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10105101] = {
    AddAttrs = T.RT_20,
    BuffId = 10105101,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10105103] = {
    BuffDamagedRate = T.RT_26,
    BuffId = 10105103,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Endure",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10105301] = {
    AddAttrs = {
      [1] = {AttrName = "MaxSp", RateUseValue = 1}
    },
    BuffId = 10105301,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10105303] = {
    AddAttrs = T.RT_42,
    BuffId = 10105303,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10105304] = {
    AddAttrs = T.RT_20,
    BuffId = 10105304,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Atk_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10105900] = {
    AddAttrs = {
      [1] = {
        AttrName = "WalkSpeedModifier",
        Stackable = 1,
        Value = 0.01
      },
      [2] = {
        AttrName = "SlideVelocityModifier",
        Stackable = 1,
        Value = 0.01
      },
      [3] = {
        AttrName = "BulletJumpVelocityModifier",
        Stackable = 1,
        Value = 0.01
      },
      [4] = {
        AttrName = "JumpVelocityModifier",
        Stackable = 1,
        Value = 0.01
      }
    },
    BuffId = 10105900,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Boost",
    IsShowInBillboard = true,
    MaxLayer = 60,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10105901] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = 0.01}
    },
    BuffId = 10105901,
    BuffType = T.RT_3,
    MaxLayer = 60,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10105903] = {
    BuffId = 10105903,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        Immediately = 1,
        Interval = 1,
        Type = "SpChange",
        Value = 2
      }
    },
    MaxLayer = 6,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10105991] = {
    AddAttrs = {
      [1] = {
        AttrName = "MaxSp",
        Rate = 0.1,
        Stackable = 1
      }
    },
    BuffId = 10105991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106101] = {
    AddAttrs = T.RT_44,
    BuffId = 10106101,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106102] = {
    AddAttrs = T.RT_44,
    BuffId = 10106102,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106103] = {
    AddAttrs = T.RT_46,
    BuffId = 10106103,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106104] = {
    AddAttrs = T.RT_46,
    BuffId = 10106104,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106105] = {
    AddAttrs = T.RT_48,
    BuffId = 10106105,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106106] = {
    AddAttrs = T.RT_48,
    BuffId = 10106106,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106107] = {
    AddAttrs = T.RT_50,
    BuffId = 10106107,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106108] = {
    AddAttrs = T.RT_50,
    BuffId = 10106108,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106109] = {
    BuffDamagedRate = T.RT_26,
    BuffId = 10106109,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_27
  },
  [10106110] = {
    AddAttrs = T.RT_52,
    BuffId = 10106110,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106111] = {
    AddAttrs = T.RT_52,
    BuffId = 10106111,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106112] = {
    AddAttrs = T.RT_54,
    BuffId = 10106112,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106113] = {
    AddAttrs = T.RT_54,
    BuffId = 10106113,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10106114] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Rouge",
        Value = 0.12
      }
    },
    BuffId = 10106114,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Rou_BG06_01",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_55
  },
  [10106991] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillRange",
        Rate = 0.1,
        Stackable = 1
      }
    },
    BuffId = 10106991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107101] = {
    BuffId = 10107101,
    BuffType = T.RT_3,
    DotDatas = T.RT_58,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107102] = {
    BuffId = 10107102,
    BuffType = T.RT_3,
    DotDatas = T.RT_58,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107103] = {
    AddAttrs = T.RT_60,
    BuffId = 10107103,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107104] = {
    AddAttrs = T.RT_60,
    BuffId = 10107104,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107105] = {
    AddAttrs = T.RT_24,
    BuffId = 10107105,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_25
  },
  [10107106] = {
    AddAttrs = T.RT_62,
    BuffId = 10107106,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107107] = {
    AddAttrs = T.RT_62,
    BuffId = 10107107,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107108] = {
    AddAttrs = T.RT_64,
    BuffId = 10107108,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107109] = {
    AddAttrs = T.RT_64,
    BuffId = 10107109,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107110] = {
    AddAttrs = T.RT_66,
    BuffId = 10107110,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107111] = {
    AddAttrs = T.RT_66,
    BuffId = 10107111,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107112] = {
    BuffId = 10107112,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = T.RT_69,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [10107113] = {
    AddAttrs = T.RT_72,
    BuffId = 10107113,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107114] = {
    AddAttrs = T.RT_72,
    BuffId = 10107114,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107115] = {
    AddAttrs = T.RT_74,
    BuffId = 10107115,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107116] = {
    AddAttrs = T.RT_74,
    BuffId = 10107116,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107117] = {
    AddAttrs = {
      [1] = {AttrName = "MaxHp", Rate = 0.005}
    },
    BuffId = 10107117,
    BuffType = T.RT_31,
    BuffTypeImgPath = "Rou_BG07_01",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 100,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [10107118] = {
    BuffId = 10107118,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.01,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [10107119] = {
    BuffId = 10107119,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.0134,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [10107120] = {
    BuffId = 10107120,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.0167,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [10107121] = {
    BuffId = 10107121,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.02,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [10107122] = {
    AddAttrs = {
      [1] = {AttrName = "MaxHp", Rate = 1}
    },
    BuffId = 10107122,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Rou_BG07_02",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_75
  },
  [10107123] = {
    BuffId = 10107123,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {10109103}
  },
  [10107124] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", ValueUseValue = 1}
    },
    BuffId = 10107124,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Rou_BG07_02",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30,
    VisualEffects = T.RT_75
  },
  [10107125] = {
    BuffId = 10107125,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    OverrideAttrs = {AttrName = "FakeHpRate", Value = 0.4}
  },
  [10107126] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", ValueUseValue = 1}
    },
    BuffId = 10107126,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10107991] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillSustain",
        Rate = 0.1,
        Stackable = 1
      }
    },
    BuffId = 10107991,
    BuffType = T.RT_3,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [10503001] = {
    AddAttrs = T.RT_129,
    AddPassiveEffect = T.RT_79,
    BuffId = 10503001,
    BuffType = T.RT_127,
    DisperseBuffType = T.RT_126,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [20101001] = {
    BuffDamagedRate = {Value = -1},
    BuffId = 20101001,
    BuffType = T.RT_28,
    BuffTypeImgPath = "Endure",
    CannotBeHitted = true,
    ForbidBuffType = T.RT_29,
    ForbidCatch = true,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge",
    NotEnterCharacterTagType = T.RT_30
  },
  [20116001] = {
    BuffDamagedRate = T.RT_182,
    BuffId = 20116001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20119001] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Almighty",
        Value = 0.1
      }
    },
    BuffId = 20119001,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MaxLayer = 7,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [20120001] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 0.3
      }
    },
    BuffId = 20120001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_25
  },
  [20151001] = {
    AddAttrs = {
      [1] = {
        AttrName = "SkillEfficiency",
        Rate = -0.5
      },
      [2] = T.RT_302
    },
    BuffId = 20151001,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20152001] = {
    AddAttrs = T.RT_304,
    BuffId = 20152001,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20153001] = {
    AddAttrs = T.RT_304,
    BuffId = 20153001,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20154001] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "Normal",
        Value = 0.5
      },
      [2] = T.RT_305
    },
    BuffId = 20154001,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20156001] = {
    AddAttrs = {
      [1] = {
        AttrName = "CutTNModify",
        Value = 1
      }
    },
    BuffId = 20156001,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20156002] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamagedRate",
        RateZone = "BossDown",
        Value = 1
      }
    },
    BuffId = 20156002,
    BuffType = T.RT_14,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [20161001] = {
    BuffDamagedRate = T.RT_182,
    BuffId = 20161001,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21102061] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Value = -0.2
      }
    },
    BuffId = 21102061,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Crd_Down",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21102062] = {
    AddAttrs = {
      [1] = {
        AttrName = "WeaponCRDModifierRate",
        Value = 0.3
      }
    },
    BuffId = 21102062,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21102063] = {
    AddAttrs = {
      [1] = T.RT_288
    },
    BuffId = 21102063,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Crd_Up",
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21102181] = {
    AddAttrs = T.RT_119,
    BuffId = 21102181,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21102191] = {
    BuffId = 21102191,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    OverrideAttrs = T.RT_321
  },
  [21102201] = {
    AddAttrs = T.RT_13,
    BuffId = 21102201,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Rou_BG01_01",
    IsShowInBillboard = true,
    MaxLayer = 20,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree",
    VisualEffects = T.RT_15
  },
  [21103011] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 0.2
      }
    },
    BuffId = 21103011,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103012] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 0.4
      }
    },
    BuffId = 21103012,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103013] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 0.6
      }
    },
    BuffId = 21103013,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103014] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 0.8
      }
    },
    BuffId = 21103014,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103015] = {
    AddAttrs = {
      [1] = T.RT_305
    },
    BuffId = 21103015,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103016] = {
    AddAttrs = {
      [1] = {
        AttrName = "DamageRate",
        RateZone = "Rouge",
        Value = 1.2
      }
    },
    BuffId = 21103016,
    BuffType = T.RT_322,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21103061] = {
    AddAttrs = {
      [1] = T.RT_302
    },
    BuffDamagedRate = T.RT_182,
    BuffId = 21103061,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Down",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21181011] = {
    BuffId = 21181011,
    BuffType = T.RT_3,
    DotDatas = {
      [1] = {
        Interval = 2,
        Type = "SpChange",
        Value = 1
      }
    },
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [21182011] = {
    BuffId = 21182011,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Hot_Up",
    DotDatas = {
      [1] = {
        BaseAttr = "MaxHp",
        DamageTag = T.RT_67,
        Interval = 1,
        Rate = 0.05,
        Type = "Hot"
      }
    },
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = T.RT_70
  },
  [30100001] = {
    AddPassiveEffect = {20130001},
    BuffId = 30100001,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30100002] = {
    AddPassiveEffect = {20131001},
    BuffId = 30100002,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30100003] = {
    AddPassiveEffect = {20132001},
    BuffId = 30100003,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30100004] = {
    AddPassiveEffect = {20133001},
    BuffId = 30100004,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30100005] = {
    AddPassiveEffect = {20134001},
    BuffId = 30100005,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30100006] = {
    AddPassiveEffect = {20135001},
    BuffId = 30100006,
    BuffType = T.RT_22,
    BuffTypeImgPath = "Damage_Up",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [30101002] = {
    AddAttrs = T.RT_20,
    BuffId = 30101002,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30102001] = {
    AddAttrs = T.RT_123,
    BuffId = 30102001,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30102002] = {
    AddAttrs = T.RT_20,
    BuffId = 30102002,
    BuffType = T.RT_31,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30400001] = {
    AddPassiveEffect = {30424},
    BuffId = 30400001,
    BuffType = T.RT_342,
    BuffTypeImgPath = "Elite_Threefold",
    DisperseBuffType = T.RT_343,
    EmissiveParams = {
      EmissiveColor = {
        0,
        3,
        10,
        1
      },
      EmissiveIntensity = 10
    },
    IconPriority = 990102,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_344
  },
  [30400002] = {
    AddPassiveEffect = {30425},
    BuffId = 30400002,
    BuffType = T.RT_345,
    BuffTypeImgPath = "Elite_Vampire",
    DisperseBuffType = T.RT_346,
    EmissiveParams = {
      EmissiveColor = {
        9.8,
        10,
        0,
        1
      },
      EmissiveIntensity = 10
    },
    IconPriority = 990202,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_347
  },
  [30400003] = {
    AddAttrs = {
      [1] = {AttrName = "ATK", Rate = -0.5},
      [2] = {AttrName = "DEF", Rate = 2}
    },
    BuffId = 30400003,
    BuffType = {30, 30403},
    BuffTypeImgPath = "Def_Up",
    EffectCreatureID = 304000001,
    IsShowInBillboard = true,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [30400004] = {
    BossSpCamera = {
      ArmRate = -0.5,
      BaseArmLength = 2500,
      BasePitch = 50,
      PitchRate = 0.01,
      UseSaveLoc = "CenterLoc"
    },
    BuffId = 30400004,
    BuffType = T.RT_3,
    CameraParam = T.RT_348,
    MergeRule1 = "Personal",
    MergeRule2 = "Merge"
  },
  [30400005] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = -0.1}
    },
    BuffId = 30400005,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Def_Down",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30400006] = {
    BuffId = 30400006,
    LockHp = {Rate = 0.3},
    LockHpUI = 0,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30400007] = {
    AddPassiveEffect = {30426},
    BuffId = 30400007,
    BuffType = T.RT_349,
    BuffTypeImgPath = "Elite_Vampire",
    DisperseBuffType = T.RT_350,
    EmissiveParams = {
      EmissiveColor = {
        10,
        0,
        7.7,
        1
      },
      EmissiveIntensity = 10
    },
    IconPriority = 990101,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_351
  },
  [30400008] = {
    BuffId = 30400008,
    BuffType = T.RT_342,
    BuffTypeImgPath = "Elite_Threefold",
    DeadNotRemove = true,
    DisperseBuffType = T.RT_343,
    IconPriority = 990301,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_344
  },
  [30400009] = {
    BuffId = 30400009,
    BuffType = T.RT_345,
    BuffTypeImgPath = "Elite_Vampire",
    DeadNotRemove = true,
    DisperseBuffType = T.RT_346,
    IconPriority = 990103,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_347
  },
  [30400010] = {
    BuffId = 30400010,
    BuffType = T.RT_349,
    BuffTypeImgPath = "Elite_Vampire",
    DeadNotRemove = true,
    DisperseBuffType = T.RT_350,
    IconPriority = 990201,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000,
    VisualEffects = T.RT_351
  },
  [30400011] = {
    BuffId = 30400011,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Elite_Vampire",
    EmissiveParams = {
      EmissiveColor = {
        0.1,
        0.1,
        0.1,
        1
      },
      EmissiveIntensity = 10
    },
    IconPriority = 990401,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    Priority = 1000
  },
  [30400012] = {
    BuffId = 30400012,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Elite_Vampire",
    IconPriority = 990502,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {304000005}
  },
  [30400013] = {
    BuffId = 30400013,
    LockHp = T.RT_352,
    LockHpUI = 0,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [30400014] = {
    BuffId = 30400014,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Elite_Vampire",
    IconPriority = 990601,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {304000006}
  },
  [30400015] = {
    BuffId = 30400015,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Elite_Vampire",
    IconPriority = 990102,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {304000007}
  },
  [30400016] = {
    BuffId = 30400016,
    BuffType = T.RT_145,
    BuffTypeImgPath = "Elite_Vampire",
    IconPriority = 990202,
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {304000008}
  },
  [30400017] = {
    AddAttrs = {
      [1] = {AttrName = "DEF", Rate = -0.15}
    },
    BuffId = 30400017,
    BuffType = T.RT_14,
    BuffTypeImgPath = "Def_Down",
    DeadNotRemove = true,
    IsShowInBillboard = true,
    MaxLayer = 5,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101001] = {
    BuffId = 40101001,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101002] = {
    BuffId = 40101002,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101003] = {
    BuffId = 40101003,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101004] = {
    BuffId = 40101004,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101005] = {
    BuffId = 40101005,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101006] = {
    AddAttrs = T.RT_379,
    BuffId = 40101006,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101007] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/BP_Buff_40101007.BP_Buff_40101007",
    BuffId = 40101007,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101008] = {
    BuffId = 40101008,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101009] = {
    BuffId = 40101009,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101010] = {
    BuffId = 40101010,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101011] = {
    BuffId = 40101011,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101012] = {
    BuffId = 40101012,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101013] = {
    BuffId = 40101013,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101014] = {
    BuffId = 40101014,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101015] = {
    BuffId = 40101015,
    BuffType = T.RT_3,
    DeadNotRemove = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101016] = {
    BuffId = 40101016,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Slowdown",
    IsShowInBillboard = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.3,
    VisualEffects = T.RT_380
  },
  [40101017] = {
    BuffDamagedRate = {Value = 0.15},
    BuffId = 40101017,
    BuffType = T.RT_3,
    BuffTypeImgPath = "Damaged_Up",
    IsShowInBillboard = true,
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [40101018] = {
    BPPath = "/Game/BluePrints/Combat/Buff/BPBuffs/Bp_Buff_40101018.Bp_Buff_40101018",
    BuffId = 40101018,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    TimeDilation = 0.01
  },
  [40101019] = {
    BuffId = 40101019,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    VisualEffects = {40101006}
  },
  [99999999] = {
    AddAttrs = T.RT_172,
    BuffId = 99999999,
    MaxLayer = 2,
    MergeRule1 = "Global",
    MergeRule2 = "NewFree"
  },
  [100066601] = {
    BuffId = 100066601,
    BuffType = T.RT_3,
    EnableCopyMode = true,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  },
  [100066602] = {
    BuffId = 100066602,
    BuffType = T.RT_3,
    MergeRule1 = "Global",
    MergeRule2 = "Merge",
    bHeavyAttack2Attack = true
  },
  [999999999] = {
    BuffId = 999999999,
    HitReplace = {HitFly = "HeavyHIt"},
    LayerExtraBuff = {
      [2] = 104
    },
    MaxLayer = 4,
    MergeRule1 = "Global",
    MergeRule2 = "Merge"
  }
})
