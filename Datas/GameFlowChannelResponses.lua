local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("GameFlowChannelResponses", {
  GetItemPage = {
    Channel = "GetItemPage",
    GetItemPage = "Block",
    GuideMain = "Block",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Block",
    Sojourn = "Ignore",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  },
  GuideMain = {
    Channel = "GuideMain",
    GetItemPage = "Block",
    GuideMain = "Ignore",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Block",
    Sojourn = "Block",
    SystemGuideWithUI = "Ignore",
    SystemGuideWithoutUI = "Ignore"
  },
  ImmersiveStory = {
    Channel = "ImmersiveStory",
    GetItemPage = "Block",
    GuideMain = "Block",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Block",
    SkillFeature = "Block",
    Sojourn = "Ignore",
    SystemGuideWithUI = "Ignore",
    SystemGuideWithoutUI = "Block"
  },
  LevelDelivery = {
    Channel = "LevelDelivery",
    GetItemPage = "Block",
    GuideMain = "Block",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Block",
    SkillFeature = "Block",
    Sojourn = "Block",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  },
  OpenSystemUI = {
    Channel = "OpenSystemUI",
    GetItemPage = "Ignore",
    GuideMain = "Ignore",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Ignore",
    Sojourn = "Ignore",
    SystemGuideWithUI = "Ignore",
    SystemGuideWithoutUI = "Ignore"
  },
  SkillFeature = {
    Channel = "SkillFeature",
    GetItemPage = "Block",
    GuideMain = "Block",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Block",
    Sojourn = "Ignore",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  },
  Sojourn = {
    Channel = "Sojourn",
    GetItemPage = "Ignore",
    GuideMain = "Block",
    ImmersiveStory = "Ignore",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Ignore",
    Sojourn = "Ignore",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  },
  SystemGuideWithUI = {
    Channel = "SystemGuideWithUI",
    GetItemPage = "Block",
    GuideMain = "Ignore",
    ImmersiveStory = "Ignore",
    LevelDelivery = "Block",
    OpenSystemUI = "Ignore",
    SkillFeature = "Block",
    Sojourn = "Block",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  },
  SystemGuideWithoutUI = {
    Channel = "SystemGuideWithoutUI",
    GetItemPage = "Block",
    GuideMain = "Ignore",
    ImmersiveStory = "Block",
    LevelDelivery = "Block",
    OpenSystemUI = "Block",
    SkillFeature = "Block",
    Sojourn = "Block",
    SystemGuideWithUI = "Block",
    SystemGuideWithoutUI = "Block"
  }
})
