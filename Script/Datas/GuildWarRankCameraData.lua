local T = {}
T.RT_1 = {
  0,
  0,
  -90
}
T.RT_2 = {
  0,
  1,
  -90
}
T.RT_3 = {
  0,
  0,
  10
}
T.RT_4 = {
  [2101] = T.RT_3
}
T.RT_5 = {
  0,
  0,
  -60
}
T.RT_6 = {
  -58,
  215,
  135
}
T.RT_7 = {
  -60,
  230,
  120
}
T.RT_8 = {
  -65,
  215,
  91
}
T.RT_9 = {
  -60,
  265,
  150
}
T.RT_10 = {
  -60,
  225,
  135
}
T.RT_11 = {
  -75,
  247,
  119
}
T.RT_12 = {
  -73.5,
  263,
  111
}
T.RT_13 = {
  -75,
  260,
  105
}
T.RT_14 = {
  -75,
  260,
  100
}
T.RT_15 = {
  -65,
  260,
  80
}
T.RT_16 = {
  -70,
  260,
  128
}
T.RT_17 = {
  -75,
  260,
  120
}
T.RT_18 = {
  -81,
  278,
  115
}
T.RT_19 = {
  -68,
  213,
  91
}
T.RT_20 = {
  -77,
  230,
  144
}
T.RT_21 = {
  -67,
  225,
  131
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GuildWarRankCameraData", {
  Char_Boy = {
    CameraFocal = 38.6,
    CameraName = "Char_Boy",
    Ease = 14,
    Location = {
      -17,
      208,
      126
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Char_Girl = {
    CameraFocal = 38.6,
    CameraName = "Char_Girl",
    Ease = 14,
    Location = {
      -19,
      208,
      115
    },
    LocationOffset = {
      [1801] = {
        8,
        0,
        0
      }
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Char_Loli = {
    CameraFocal = 38.6,
    CameraName = "Char_Loli",
    Ease = 14,
    Location = {
      -14,
      208,
      92
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Char_Man = {
    CameraFocal = 38.6,
    CameraName = "Char_Man",
    Ease = 14,
    Location = {
      -17,
      208,
      155
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Char_Woman = {
    CameraFocal = 38.6,
    CameraName = "Char_Woman",
    Ease = 14,
    Location = {
      -21,
      228,
      135
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Default = {
    CameraFocal = 70,
    CameraName = "Default",
    Ease = 14,
    Location = {
      1000,
      -20,
      -1
    },
    Rotation = {
      0,
      0,
      180
    },
    Time = 1.2
  },
  Weapon_Bow_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Bow_Boy",
    Ease = 14,
    Location = {
      -55,
      310,
      100
    },
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Bow_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Bow_Girl",
    Ease = 14,
    Location = {
      -63,
      270,
      100
    },
    LocationOffset = T.RT_4,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Bow_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Bow_Loli",
    Ease = 14,
    Location = {
      -52,
      270,
      80
    },
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Bow_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Bow_Man",
    Ease = 14,
    Location = {
      -63,
      320,
      125
    },
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Bow_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Bow_Woman",
    Ease = 14,
    Location = {
      -63,
      290,
      113
    },
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Cannon_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Cannon_Boy",
    Ease = 14,
    Location = {
      -250,
      265,
      100
    },
    Rotation = T.RT_5,
    Time = 1.2
  },
  Weapon_Cannon_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Cannon_Girl",
    Ease = 14,
    Location = {
      -238,
      240,
      100
    },
    LocationOffset = T.RT_4,
    Rotation = T.RT_5,
    Time = 1.2
  },
  Weapon_Cannon_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Cannon_Loli",
    Ease = 14,
    Location = {
      -220,
      225,
      77
    },
    Rotation = T.RT_5,
    Time = 1.2
  },
  Weapon_Cannon_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Cannon_Man",
    Ease = 14,
    Location = {
      -240,
      260,
      115
    },
    Rotation = T.RT_5,
    Time = 1.2
  },
  Weapon_Cannon_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Cannon_Woman",
    Ease = 14,
    Location = {
      -240,
      255,
      110
    },
    Rotation = T.RT_5,
    Time = 1.2
  },
  Weapon_Claymore_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Claymore_Boy",
    Ease = 14,
    Location = {
      -78,
      260,
      115
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Claymore_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Claymore_Girl",
    Ease = 14,
    Location = {
      -78,
      260,
      110
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Claymore_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Claymore_Loli",
    Ease = 14,
    Location = {
      -80,
      240,
      85
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Claymore_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Claymore_Man",
    Ease = 14,
    Location = {
      -97,
      330,
      135
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Claymore_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Claymore_Woman",
    Ease = 14,
    Location = {
      -98,
      320,
      120
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Crossbow_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Crossbow_Boy",
    Ease = 14,
    Location = T.RT_6,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Crossbow_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Crossbow_Girl",
    Ease = 14,
    Location = T.RT_7,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Crossbow_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Crossbow_Loli",
    Ease = 14,
    Location = T.RT_8,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Crossbow_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Crossbow_Man",
    Ease = 14,
    Location = T.RT_9,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Crossbow_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Crossbow_Woman",
    Ease = 14,
    Location = T.RT_10,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Dualblade_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Dualblade_Boy",
    Ease = 14,
    Location = {
      -61,
      225,
      123
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Dualblade_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Dualblade_Girl",
    Ease = 14,
    Location = {
      -61,
      225,
      115
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Dualblade_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Dualblade_Loli",
    Ease = 14,
    Location = {
      -67,
      230,
      90
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Dualblade_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Dualblade_Man",
    Ease = 14,
    Location = {
      -70,
      260,
      140
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Dualblade_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Dualblade_Woman",
    Ease = 14,
    Location = {
      -70,
      250,
      130
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Katana_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Katana_Boy",
    Ease = 14,
    Location = T.RT_11,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Katana_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Katana_Girl",
    Ease = 14,
    Location = T.RT_12,
    LocationOffset = {
      [2101] = {
        0,
        0,
        15
      }
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Katana_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Katana_Loli",
    Ease = 14,
    Location = {
      -61,
      213,
      91
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Katana_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Katana_Man",
    Ease = 14,
    Location = {
      -62,
      230,
      144
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Katana_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Katana_Woman",
    Ease = 14,
    Location = {
      -62,
      225,
      131
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Machinegun_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Machinegun_Boy",
    Ease = 14,
    Location = T.RT_13,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Machinegun_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Machinegun_Girl",
    Ease = 14,
    Location = T.RT_14,
    LocationOffset = T.RT_4,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Machinegun_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Machinegun_Loli",
    Ease = 14,
    Location = T.RT_15,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Machinegun_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Machinegun_Man",
    Ease = 14,
    Location = T.RT_16,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Machinegun_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Machinegun_Woman",
    Ease = 14,
    Location = T.RT_17,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Pistol_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Pistol_Boy",
    Ease = 14,
    Location = T.RT_6,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Pistol_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Pistol_Girl",
    Ease = 14,
    Location = T.RT_7,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Pistol_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Pistol_Loli",
    Ease = 14,
    Location = T.RT_8,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Pistol_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Pistol_Man",
    Ease = 14,
    Location = T.RT_9,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Pistol_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Pistol_Woman",
    Ease = 14,
    Location = T.RT_10,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Polearm_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Polearm_Boy",
    Ease = 14,
    Location = T.RT_18,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Polearm_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Polearm_Girl",
    Ease = 14,
    Location = T.RT_18,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Polearm_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Polearm_Loli",
    Ease = 14,
    Location = {
      -75,
      230,
      89
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Polearm_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Polearm_Man",
    Ease = 14,
    Location = {
      -85,
      263,
      142
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Polearm_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Polearm_Woman",
    Ease = 14,
    Location = {
      -81,
      263,
      137
    },
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Shotgun_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Shotgun_Boy",
    Ease = 14,
    Location = T.RT_13,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Shotgun_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Shotgun_Girl",
    Ease = 14,
    Location = T.RT_14,
    LocationOffset = T.RT_4,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Shotgun_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Shotgun_Loli",
    Ease = 14,
    Location = T.RT_15,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Shotgun_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Shotgun_Man",
    Ease = 14,
    Location = T.RT_16,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Shotgun_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Shotgun_Woman",
    Ease = 14,
    Location = T.RT_17,
    Rotation = T.RT_2,
    Time = 1.2
  },
  Weapon_Sword_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Sword_Boy",
    Ease = 14,
    Location = T.RT_11,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Sword_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Sword_Girl",
    Ease = 14,
    Location = T.RT_12,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Sword_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Sword_Loli",
    Ease = 14,
    Location = T.RT_19,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Sword_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Sword_Man",
    Ease = 14,
    Location = T.RT_20,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Sword_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Sword_Woman",
    Ease = 14,
    Location = T.RT_21,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Swordwhip_Boy = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Swordwhip_Boy",
    Ease = 14,
    Location = T.RT_11,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Swordwhip_Girl = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Swordwhip_Girl",
    Ease = 14,
    Location = T.RT_12,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Swordwhip_Loli = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Swordwhip_Loli",
    Ease = 14,
    Location = T.RT_19,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Swordwhip_Man = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Swordwhip_Man",
    Ease = 14,
    Location = T.RT_20,
    Rotation = T.RT_1,
    Time = 1.2
  },
  Weapon_Swordwhip_Woman = {
    CameraFocal = 38.6,
    CameraName = "Weapon_Swordwhip_Woman",
    Ease = 14,
    Location = T.RT_21,
    Rotation = T.RT_1,
    Time = 1.2
  }
})
