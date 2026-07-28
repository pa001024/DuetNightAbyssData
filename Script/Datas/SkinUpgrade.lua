local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("SkinUpgrade", {
  [110201] = {
    [2] = {
      ScoreAddValue = 200,
      SkinID = 110201,
      Step = 2,
      UnlockAmount = 54,
      UnlockCurrency = 1010
    },
    [3] = {
      ScoreAddValue = 300,
      SkinID = 110201,
      Step = 3,
      UnlockAmount = 72,
      UnlockCurrency = 1010
    }
  },
  [150401] = {
    [2] = {
      ScoreAddValue = 200,
      SkinID = 150401,
      Step = 2,
      UnlockAmount = 54,
      UnlockCurrency = 1010
    },
    [3] = {
      ScoreAddValue = 300,
      SkinID = 150401,
      Step = 3,
      UnlockAmount = 72,
      UnlockCurrency = 1010
    }
  },
  [210101] = {
    [2] = {
      ScoreAddValue = 200,
      SkinID = 210101,
      Step = 2,
      UnlockAmount = 54,
      UnlockCurrency = 1010
    },
    [3] = {
      ScoreAddValue = 300,
      SkinID = 210101,
      Step = 3,
      UnlockAmount = 72,
      UnlockCurrency = 1010
    }
  },
  [210201] = {
    [2] = {
      ScoreAddValue = 200,
      SkinID = 210201,
      Step = 2,
      UnlockAmount = 54,
      UnlockCurrency = 1010
    },
    [3] = {
      ScoreAddValue = 300,
      SkinID = 210201,
      Step = 3,
      UnlockAmount = 72,
      UnlockCurrency = 1010
    }
  }
})
