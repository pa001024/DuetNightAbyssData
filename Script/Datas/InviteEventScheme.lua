local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("InviteEventScheme", {
  [114001] = {
    America = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      ServerId = "America"
    },
    Asian = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling",
      PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling",
      ServerId = "Asian"
    },
    China = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://dna.yingxiong.com/gyatlxy?source=game",
      PhoneJumpLink = "https://dna.yingxiong.com/gyatlxy?source=game",
      ServerId = "China"
    },
    Europe = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      ServerId = "Europe"
    },
    HMT = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/zh-tw",
      PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/zh-tw",
      ServerId = "HMT"
    },
    SEA = {
      InviteEventSchemeId = 114001,
      PCJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      PhoneJumpLink = "https://duetnightabyss.dna-panstudio.com/atlasiacalling/en",
      ServerId = "SEA"
    }
  }
})
