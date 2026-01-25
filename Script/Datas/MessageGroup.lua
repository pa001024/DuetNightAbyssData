local T = {}
T.RT_1 = {
  900103,
  900202,
  900201,
  900218,
  900219,
  900220,
  900224
}
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MessageGroup", {
  [10410201] = {
    MessageGroupId = 10410201,
    MessageList = {900107, 900224}
  },
  [10410301] = {
    MessageGroupId = 10410301,
    MessageList = {
      900105,
      900204,
      900209,
      900212
    }
  },
  [10410401] = {
    MessageGroupId = 10410401,
    MessageList = {
      900110,
      900221,
      900227
    }
  },
  [10410501] = {
    MessageGroupId = 10410501,
    MessageList = {
      900108,
      900218,
      900219
    }
  },
  [10410601] = {
    MessageGroupId = 10410601,
    MessageList = {
      900111,
      900215,
      900217
    }
  },
  [10410701] = {
    MessageGroupId = 10410701,
    MessageList = T.RT_1
  },
  [10410702] = {
    MessageGroupId = 10410702,
    MessageList = T.RT_1
  },
  [10410801] = {
    MessageGroupId = 10410801,
    MessageList = {
      900101,
      900202,
      900203,
      900206
    }
  },
  [10410802] = {
    MessageGroupId = 10410802,
    MessageList = {
      900102,
      900205,
      900204,
      900207,
      900208,
      900209
    }
  },
  [10410901] = {
    MessageGroupId = 10410901,
    MessageList = {
      900106,
      900201,
      900202
    }
  },
  [10411001] = {
    MessageGroupId = 10411001,
    MessageList = {
      900104,
      900203,
      900207,
      900210
    }
  },
  [10420101] = {
    MessageGroupId = 10420101,
    MessageList = {
      900116,
      900224,
      900218,
      900219,
      900220,
      900225,
      900212
    }
  },
  [10430101] = {
    MessageGroupId = 10430101,
    MessageList = {
      900113,
      900215,
      900217
    }
  },
  [10440101] = {
    MessageGroupId = 10440101,
    MessageList = {
      900114,
      900215,
      900217,
      900227
    }
  },
  [10460101] = {
    MessageGroupId = 10460101,
    MessageList = {
      900117,
      900224,
      900218,
      900219,
      900220,
      900225,
      900212
    }
  },
  [10470101] = {
    MessageGroupId = 10470101,
    MessageList = {
      900118,
      900224,
      900218,
      900219,
      900220,
      900225,
      900212
    }
  },
  [10490101] = {
    MessageGroupId = 10490101,
    MessageList = {900119, 900220}
  },
  [10500101] = {
    MessageGroupId = 10500101,
    MessageList = {
      900115,
      900215,
      900217,
      900227
    }
  },
  [10570101] = {
    MessageGroupId = 10570101,
    MessageList = {900112, 900211}
  }
})
