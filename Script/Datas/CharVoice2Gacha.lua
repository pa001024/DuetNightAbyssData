local T = {}
T.RT_1 = {
  [1] = "vo_gain"
}
T.RT_2 = {
  [1] = "vo_gain_1"
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("CharVoice2Gacha", {
  [1101] = {
    [1] = {
      [1] = {
        VoiceId = 10001,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Heitao_vo_gain"
        }
      }
    }
  },
  [1103] = {
    [1] = {
      [1] = {
        VoiceId = 10656,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Tuosi_vo_gain"
        }
      }
    }
  },
  [1501] = {
    [1] = {
      [1] = {
        VoiceId = 10877,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Baonu_vo_gain"
        }
      }
    }
  },
  [1502] = {
    [1] = {
      [1] = {
        VoiceId = 10562,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Nifu_vo_gain"
        }
      }
    }
  },
  [1503] = {
    [1] = {
      [1] = {
        VoiceId = 10760,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Kezhou_vo_gain"
        }
      }
    }
  },
  [1801] = {
    [1] = {
      [1] = {
        VoiceId = 10449,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Feina_vo_gain"
        }
      }
    }
  },
  [2101] = {
    [1] = {
      [1] = {
        VoiceId = 10037,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Shuimu01_vo_gain"
        }
      },
      [2] = {
        VoiceId = 10041,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Shuimu_vo_gain"
        }
      }
    }
  },
  [2301] = {
    [1] = {
      [1] = {
        VoiceId = 10078,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Zhangyu_vo_gain"
        }
      }
    }
  },
  [2401] = {
    [1] = {
      [1] = {
        VoiceId = 10259,
        VoiceRes = T.RT_2,
        VoiceText = {
          [1] = "voice_ch_char_Baiheng_vo_gain_1"
        }
      }
    }
  },
  [3101] = {
    [1] = {
      [1] = {
        VoiceId = 10113,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Linen_vo_gain"
        }
      }
    }
  },
  [3102] = {
    [1] = {
      [1] = {
        VoiceId = 10145,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Xier_vo_gain"
        }
      }
    }
  },
  [3103] = {
    [1] = {
      [1] = {
        VoiceId = 10487,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Yeer_vo_gain"
        }
      }
    }
  },
  [3201] = {
    [1] = {
      [1] = {
        VoiceId = 10524,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Haier_vo_gain"
        }
      }
    }
  },
  [3301] = {
    [1] = {
      [1] = {
        VoiceId = 10406,
        VoiceRes = T.RT_2,
        VoiceText = {
          [1] = "voice_ch_char_Maer_vo_gain_1"
        }
      }
    },
    [2] = {
      [1] = {
        GachaVoiceCondition = {
          [1] = 6007
        },
        VoiceId = 10407,
        VoiceRes = {
          [1] = "vo_gain_2"
        },
        VoiceText = {
          [1] = "voice_ch_char_Maer_vo_gain_2"
        }
      }
    }
  },
  [4101] = {
    [1] = {
      [1] = {
        VoiceId = 10611,
        VoiceRes = {
          [1] = "vo_gain_01"
        },
        VoiceText = {
          [1] = "voice_ch_char_Lise_vo_gain_01"
        }
      }
    },
    [2] = {
      [1] = {
        GachaVoiceCondition = {
          [1] = 100307
        },
        VoiceId = 10612,
        VoiceRes = {
          [1] = "vo_gain_02"
        },
        VoiceText = {
          [1] = "voice_ch_char_Lise_vo_gain_02"
        }
      }
    }
  },
  [4102] = {
    [1] = {
      [1] = {
        VoiceId = 10837,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Zhiliu_vo_gain"
        }
      }
    }
  },
  [4201] = {
    [1] = {
      [1] = {
        VoiceId = 10186,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Yuming_vo_gain"
        }
      }
    }
  },
  [4202] = {
    [1] = {
      [1] = {
        VoiceId = 10338,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Landi_vo_gain"
        }
      }
    }
  },
  [4301] = {
    [1] = {
      [1] = {
        VoiceId = 10370,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Xibi_vo_gain"
        }
      }
    }
  },
  [5101] = {
    [1] = {
      [1] = {
        VoiceId = 10295,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Songlu01_vo_gain"
        }
      },
      [2] = {
        VoiceId = 10299,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Songlu_vo_gain"
        }
      }
    }
  },
  [5102] = {
    [1] = {
      [1] = {
        VoiceId = 10800,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Aote_vo_gain"
        }
      }
    }
  },
  [5301] = {
    [1] = {
      [1] = {
        VoiceId = 10216,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Saiqi01_vo_gain"
        }
      },
      [2] = {
        VoiceId = 10220,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Saiqi_vo_gain"
        }
      }
    }
  },
  [5401] = {
    [1] = {
      [1] = {
        VoiceId = 10711,
        VoiceRes = T.RT_1,
        VoiceText = {
          [1] = "voice_ch_char_Dafu_vo_gain"
        }
      }
    }
  }
})
