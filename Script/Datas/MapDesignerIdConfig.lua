local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("MapDesignerIdConfig", {
  TestDesigner = {
    DesignerID = 10,
    DesignerName = "TestDesigner"
  },
  chenxinyu = {DesignerID = 26, DesignerName = "chenxinyu"},
  chenzhenyu = {DesignerID = 29, DesignerName = "chenzhenyu"},
  chenzhikun = {DesignerID = 23, DesignerName = "chenzhikun"},
  fanyige = {DesignerID = 22, DesignerName = "fanyige"},
  gongjiahao = {DesignerID = 28, DesignerName = "gongjiahao"},
  hehao = {DesignerID = 12, DesignerName = "hehao"},
  jiangyiqun = {DesignerID = 32, DesignerName = "jiangyiqun"},
  jinhengyi = {DesignerID = 24, DesignerName = "jinhengyi"},
  luwenxin = {DesignerID = 30, DesignerName = "luwenxin"},
  orson = {DesignerID = 13, DesignerName = "orson"},
  oujiahao = {DesignerID = 15, DesignerName = "oujiahao"},
  pukun = {DesignerID = 14, DesignerName = "pukun"},
  shaoxinbo = {DesignerID = 27, DesignerName = "shaoxinbo"},
  shenglinyun = {
    DesignerID = 25,
    DesignerName = "shenglinyun"
  },
  sunyijie = {DesignerID = 34, DesignerName = "sunyijie"},
  tianyuxin = {DesignerID = 20, DesignerName = "tianyuxin"},
  xiachunyu = {DesignerID = 36, DesignerName = "xiachunyu"},
  xiongcai = {DesignerID = 31, DesignerName = "xiongcai"},
  yangnongquan = {
    DesignerID = 19,
    DesignerName = "yangnongquan"
  },
  yishuying = {DesignerID = 35, DesignerName = "yishuying"},
  zhangkaiqi = {DesignerID = 17, DesignerName = "zhangkaiqi"},
  zhangsiyu = {DesignerID = 33, DesignerName = "zhangsiyu"},
  zhangxiang = {DesignerID = 11, DesignerName = "zhangxiang"},
  zhongtian = {DesignerID = 16, DesignerName = "zhongtian"},
  zhujunyi = {DesignerID = 21, DesignerName = "zhujunyi"},
  zhuohanqi = {DesignerID = 18, DesignerName = "zhuohanqi"}
})
