local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ImgChannelInfo", {
  [0] = {
    ImgChannelId = 0,
    Name = "官方",
    Provider = "Hero"
  },
  [161] = {
    ImgChannelId = 161,
    Name = "好游-安卓",
    Provider = "HaoYouKuaiBao"
  },
  [167] = {
    ImgChannelId = 167,
    Name = "TapTap-安卓",
    Provider = "TapTap"
  },
  [181] = {
    ImgChannelId = 181,
    Name = "全球SDK-华为",
    Provider = "hero"
  },
  [197] = {
    ImgChannelId = 197,
    Name = "Onestore",
    Provider = "hero"
  },
  [259] = {
    ImgChannelId = 259,
    Name = "官方官网PC",
    Provider = "Hero"
  },
  [272] = {
    ImgChannelId = 272,
    Name = "全球SDK-rustore",
    Provider = "hero"
  },
  [287] = {
    ImgChannelId = 287,
    Name = "taptap-PC",
    Provider = "TapTap"
  },
  [288] = {
    ImgChannelId = 288,
    Name = "好游快爆-PC",
    Provider = "HaoYouKuaiBao"
  },
  [296] = {
    ImgChannelId = 296,
    Name = "抖音-安卓",
    Provider = "DouYin"
  }
})
