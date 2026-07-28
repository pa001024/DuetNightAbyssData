local T = {}
T.RT_1 = {
  1101,
  1102,
  1103,
  1104,
  1105,
  1106,
  1107,
  1108,
  1109,
  1110,
  1111
}
T.RT_2 = {
  1,
  2,
  3,
  4,
  5,
  6,
  7
}
T.RT_3 = {
  107001,
  107002,
  107003
}
local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("RougePro_Room", {
  [1] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 1,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [2] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 2,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [3] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 3,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [4] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 4,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [5] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 5,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [6] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 6,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  },
  [7] = {
    ArtDataPath = "/Game/Maps/Datas/Data_Art/Ailixian/Ailixian_RougeII_Bat01_Art.Ailixian_RougeII_Bat01_Art",
    BossDeliveryDis = 12000,
    BossDeliveryPointId = 8001,
    CollectionList = T.RT_1,
    DesignDataPath = "/Game/Maps/Datas/Data_Design/Ailixian/Ailixian_RougeII_bat01_Design.Ailixian_RougeII_Bat01_Design",
    EventAreaList = T.RT_2,
    RoomId = 7,
    RoomWeight = 100,
    ShopNpcList = T.RT_3
  }
})
