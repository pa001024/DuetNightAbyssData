local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("Cutoff", {
  [1] = {
    CutoffId = 1,
    CutoffPrice = 60,
    CutoffShow = 6,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120101
  },
  [2] = {
    CutoffId = 2,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120214
  },
  [3] = {
    CutoffId = 3,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120215
  },
  [4] = {
    CutoffId = 4,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120216
  },
  [5] = {
    CutoffId = 5,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120204
  },
  [6] = {
    CutoffId = 6,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120205
  },
  [7] = {
    CutoffId = 7,
    CutoffPrice = 10,
    CutoffShow = 3,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120206
  },
  [8] = {
    CutoffId = 8,
    CutoffPrice = 10,
    CutoffShow = 3,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120207
  },
  [9] = {
    CutoffId = 9,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120208
  },
  [10] = {
    CutoffId = 10,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120209
  },
  [11] = {
    CutoffEndTime = LocalTimeProxy(1764018000),
    CutoffId = 11,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120105
  },
  [12] = {
    CutoffEndTime = LocalTimeProxy(1764018000),
    CutoffId = 12,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 120106
  },
  [13] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 13,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 120108
  },
  [14] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 14,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 120403
  },
  [15] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 15,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 120201
  },
  [16] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 16,
    CutoffPrice = 60,
    CutoffShow = 12,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 120220
  },
  [17] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 17,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120109
  },
  [18] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 18,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120110
  },
  [19] = {
    CutoffId = 19,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120507
  },
  [20] = {
    CutoffId = 20,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120508
  },
  [21] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 21,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120407
  },
  [22] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 22,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120307
  },
  [23] = {
    CutoffEndTime = LocalTimeProxy(1768770000),
    CutoffId = 23,
    CutoffPrice = 60,
    CutoffShow = 12,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120411
  },
  [24] = {
    CutoffEndTime = LocalTimeProxy(1768770000),
    CutoffId = 24,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120225
  },
  [25] = {
    CutoffEndTime = LocalTimeProxy(1768770000),
    CutoffId = 25,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120701
  },
  [26] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 26,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120702
  },
  [27] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 27,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120226
  },
  [28] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 28,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120312
  },
  [29] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 29,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120510
  },
  [30] = {
    CutoffId = 30,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120112
  },
  [31] = {
    CutoffId = 31,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120113
  },
  [32] = {
    CutoffId = 32,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120114
  },
  [33] = {
    CutoffId = 33,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120115
  },
  [34] = {
    CutoffId = 34,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120116
  },
  [35] = {
    CutoffId = 35,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 120117
  },
  [36] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 36,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120123
  },
  [37] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 37,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120124
  },
  [38] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 38,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120125
  },
  [39] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 39,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120126
  },
  [40] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 40,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120127
  },
  [41] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 41,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120128
  },
  [42] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 42,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 120129
  },
  [43] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 43,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120130
  },
  [44] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 44,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120131
  },
  [45] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 45,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120132
  },
  [46] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 46,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120133
  },
  [47] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 47,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120134
  },
  [48] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 48,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 120135
  },
  [49] = {
    CutoffId = 49,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 120118
  },
  [50] = {
    CutoffId = 50,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 120119
  },
  [51] = {
    CutoffId = 51,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 120120
  },
  [52] = {
    CutoffId = 52,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 120121
  },
  [53] = {
    CutoffId = 53,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 120122
  },
  [54] = {
    CutoffId = 54,
    CutoffPrice = 1080,
    CutoffShow = 64,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1208001
  },
  [55] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 55,
    CutoffPrice = 60,
    CutoffShow = 6,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1208002
  },
  [56] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 56,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120234
  },
  [57] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 57,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120236
  },
  [58] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 58,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120237
  },
  [59] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 59,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120235
  },
  [60] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 60,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120316
  },
  [61] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 61,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120317
  },
  [62] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 62,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1771898400),
    ItemId = 120318
  },
  [63] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 63,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120517
  },
  [64] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 64,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120519
  },
  [65] = {
    CutoffId = 65,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120520
  },
  [66] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 66,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120521
  },
  [67] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 67,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120522
  },
  [68] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 68,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120414
  },
  [69] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 69,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1771293600),
    ItemId = 120416
  },
  [70] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 70,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120322
  },
  [71] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 71,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120323
  },
  [72] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 72,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120324
  },
  [73] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 73,
    CutoffPrice = 60,
    CutoffShow = 12,
    CutoffStartTime = LocalTimeProxy(1771898400),
    ItemId = 1209001
  },
  [74] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 74,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1210001
  },
  [75] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 75,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1210002
  },
  [76] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 76,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1210003
  },
  [77] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 77,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1210004
  },
  [78] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 78,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120523
  },
  [79] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 79,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120524
  },
  [80] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 80,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1211001
  },
  [81] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 81,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1211002
  },
  [82] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 82,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 1211003
  },
  [83] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 83,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120136
  },
  [84] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 84,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120137
  },
  [85] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 85,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120138
  },
  [86] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 86,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120139
  },
  [87] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 87,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120140
  },
  [88] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 88,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120141
  },
  [89] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 89,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 120243
  },
  [90] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 90,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120333
  },
  [91] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 91,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120334
  },
  [92] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 92,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120525
  },
  [93] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 93,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120538
  },
  [94] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 94,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211004
  },
  [95] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 95,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211005
  },
  [96] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 96,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211006
  },
  [97] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 97,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211007
  },
  [98] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 98,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211008
  },
  [99] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 99,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1774317600),
    ItemId = 1211009
  },
  [100] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 100,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211010
  },
  [101] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 101,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1211012
  },
  [102] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 102,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120336
  },
  [103] = {
    CutoffId = 103,
    CutoffPrice = 1000,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000106
  },
  [104] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 104,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120347
  },
  [105] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 105,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1211015
  },
  [106] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 106,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120343
  },
  [107] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 107,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120344
  },
  [108] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 108,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120345
  },
  [109] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 109,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120346
  },
  [110] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 110,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 13110001
  },
  [111] = {
    CutoffId = 111,
    CutoffPrice = 300,
    CutoffShow = 10,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 801200
  },
  [112] = {
    CutoffId = 112,
    CutoffPrice = 4000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 801201
  },
  [113] = {
    CutoffId = 113,
    CutoffPrice = 4000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 801202
  },
  [114] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 114,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 13110002
  },
  [115] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 115,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1776909600),
    ItemId = 120351
  },
  [116] = {
    CutoffId = 116,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000500
  },
  [117] = {
    CutoffId = 117,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000501
  },
  [118] = {
    CutoffId = 118,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000502
  },
  [119] = {
    CutoffId = 119,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000503
  },
  [120] = {
    CutoffEndTime = LocalTimeProxy(1770688800),
    CutoffId = 120,
    CutoffPrice = 1000,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1768770000),
    ItemId = 10000606
  },
  [121] = {
    CutoffId = 121,
    CutoffPrice = 0,
    CutoffShow = 0,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 140155
  },
  [122] = {
    CutoffId = 122,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1770688800),
    ItemId = 10000616
  },
  [123] = {
    CutoffId = 123,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 140267
  },
  [124] = {
    CutoffId = 124,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 140268
  },
  [125] = {
    CutoffId = 125,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150305
  },
  [126] = {
    CutoffId = 126,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150306
  },
  [127] = {
    CutoffId = 127,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150307
  },
  [128] = {
    CutoffId = 128,
    CutoffPrice = 30,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150308
  },
  [129] = {
    CutoffId = 129,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150309
  },
  [130] = {
    CutoffId = 130,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150310
  },
  [131] = {
    CutoffId = 131,
    CutoffPrice = 10,
    CutoffShow = 33,
    CutoffStartTime = LocalTimeProxy(1770948000),
    ItemId = 150311
  },
  [132] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 132,
    CutoffPrice = 0,
    CutoffShow = 0,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 150317
  },
  [133] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 133,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 13110003
  },
  [134] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 134,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 120354
  },
  [135] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 135,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 120358
  },
  [136] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 136,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 1211018
  },
  [137] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 137,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 1211022
  },
  [138] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 138,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 1211023
  },
  [139] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 139,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 1211024
  },
  [140] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 140,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 1211025
  },
  [141] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 141,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1779328800),
    ItemId = 1211026
  },
  [142] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 142,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1779328800),
    ItemId = 1211027
  },
  [143] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 143,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1779328800),
    ItemId = 1211028
  },
  [144] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 144,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1779328800),
    ItemId = 1211029
  },
  [145] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 145,
    CutoffPrice = 980,
    CutoffShow = 58,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1208003
  },
  [146] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 146,
    CutoffPrice = 980,
    CutoffShow = 58,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1208004
  },
  [147] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 147,
    CutoffPrice = 980,
    CutoffShow = 58,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1208005
  },
  [148] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 148,
    CutoffPrice = 680,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 1208006
  },
  [149] = {
    CutoffId = 149,
    CutoffPrice = 700,
    CutoffShow = 14,
    CutoffStartTime = LocalTimeProxy(1770688800),
    ItemId = 10000620
  },
  [150] = {
    CutoffEndTime = LocalTimeProxy(1780866000),
    CutoffId = 150,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 140302
  },
  [151] = {
    CutoffId = 151,
    CutoffPrice = 500,
    CutoffShow = 2,
    CutoffStartTime = LocalTimeProxy(1761512400),
    ItemId = 10000504
  },
  [152] = {
    CutoffId = 152,
    CutoffPrice = 500,
    CutoffShow = 2,
    CutoffStartTime = LocalTimeProxy(1761512400),
    ItemId = 10000505
  },
  [153] = {
    CutoffEndTime = LocalTimeProxy(1785704400),
    CutoffId = 153,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 140352
  },
  [154] = {
    CutoffEndTime = LocalTimeProxy(1785704400),
    CutoffId = 154,
    CutoffPrice = 35,
    CutoffShow = 87,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 140364
  },
  [155] = {
    CutoffEndTime = LocalTimeProxy(1785704400),
    CutoffId = 155,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 140367
  },
  [156] = {
    CutoffId = 156,
    CutoffPrice = 60,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 10010101
  },
  [157] = {
    CutoffId = 157,
    CutoffPrice = 48,
    CutoffShow = 35,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 10010103
  },
  [158] = {
    CutoffEndTime = LocalTimeProxy(1789333200),
    CutoffId = 158,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140397
  },
  [159] = {
    CutoffId = 159,
    CutoffPrice = 1000,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 10000511
  },
  [160] = {
    CutoffEndTime = LocalTimeProxy(1789333200),
    CutoffId = 160,
    CutoffPrice = 1,
    CutoffShow = 16,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140451
  },
  [173] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 173,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120427
  },
  [174] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 174,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120428
  },
  [175] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 175,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120429
  },
  [176] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 176,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120432
  },
  [177] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 177,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120433
  },
  [178] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 178,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120435
  },
  [179] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 179,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120436
  },
  [180] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 180,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120437
  },
  [181] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 181,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120439
  },
  [182] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 182,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120440
  },
  [183] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 183,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120441
  },
  [184] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 184,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120442
  },
  [185] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 185,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120443
  },
  [186] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 186,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120444
  },
  [187] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 187,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120445
  },
  [188] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 188,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120447
  },
  [189] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 189,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120448
  },
  [190] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 190,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120449
  },
  [191] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 191,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120451
  },
  [192] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 192,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120452
  },
  [193] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 193,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1784167200),
    ItemId = 120453
  },
  [194] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 194,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 13110004
  },
  [195] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 195,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 13110005
  },
  [196] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 196,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 13110006
  },
  [197] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 197,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 13110007
  },
  [199] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 199,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120362
  },
  [200] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 200,
    CutoffPrice = 120,
    CutoffShow = 17,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120366
  },
  [201] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 201,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120368
  },
  [202] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 202,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120369
  },
  [203] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 203,
    CutoffPrice = 120,
    CutoffShow = 17,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120370
  },
  [204] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 204,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120372
  },
  [205] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 205,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120373
  },
  [206] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 206,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120375
  },
  [207] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 207,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120376
  },
  [208] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 208,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120377
  },
  [209] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 209,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120379
  },
  [210] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 210,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120380
  },
  [211] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 211,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120381
  },
  [212] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 212,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120382
  },
  [213] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 213,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120383
  },
  [214] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 214,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120384
  },
  [215] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 215,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120388
  },
  [216] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 216,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120391
  },
  [217] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 217,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120392
  },
  [218] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 218,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120394
  },
  [219] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 219,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120395
  },
  [220] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 220,
    CutoffPrice = 100,
    CutoffShow = 14,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 1208008
  },
  [221] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 221,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120367
  },
  [222] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 222,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120371
  },
  [223] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 223,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120364
  },
  [224] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 224,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120365
  },
  [225] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 225,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120387
  },
  [226] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 226,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120389
  },
  [227] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 227,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120393
  },
  [228] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 228,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120385
  },
  [229] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 229,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1781748000),
    ItemId = 120386
  },
  [230] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 230,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120431
  },
  [231] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 231,
    CutoffPrice = 180,
    CutoffShow = 18,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 1208009
  },
  [232] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 232,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130001
  },
  [233] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 233,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130002
  },
  [234] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 234,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130003
  },
  [235] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 235,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130004
  },
  [236] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 236,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130005
  },
  [237] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 237,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130006
  },
  [238] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 238,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130007
  },
  [239] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 239,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130008
  },
  [240] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 240,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 1600001
  },
  [241] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 241,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 1600002
  },
  [242] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 242,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 1600003
  },
  [243] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 243,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140002
  },
  [244] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 244,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140003
  },
  [245] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 245,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150001
  },
  [246] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 246,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150002
  },
  [247] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 247,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130009
  },
  [248] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 248,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 130010
  },
  [249] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 249,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140004
  },
  [250] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 250,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140005
  },
  [251] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 251,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 140006
  },
  [252] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 252,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150004
  },
  [253] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 253,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150005
  },
  [254] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 254,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150006
  },
  [255] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 255,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 150007
  },
  [256] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 256,
    CutoffPrice = 1080,
    CutoffShow = 64,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 1208013
  },
  [10001] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10001,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1773712800),
    ItemId = 1211011
  },
  [10002] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10002,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120143
  },
  [10003] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10003,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1773108000),
    ItemId = 120144
  },
  [10004] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10004,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120145
  },
  [10005] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10005,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 120146
  },
  [10006] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10006,
    CutoffPrice = 520,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120148
  },
  [10007] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10007,
    CutoffPrice = 620,
    CutoffShow = 63,
    CutoffStartTime = LocalTimeProxy(1772503200),
    ItemId = 120149
  },
  [10008] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 10008,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120152
  },
  [10009] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 10009,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1775440800),
    ItemId = 120153
  },
  [10010] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 10010,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1776909600),
    ItemId = 120155
  },
  [10011] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 10011,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1776909600),
    ItemId = 120157
  },
  [10012] = {
    CutoffEndTime = LocalTimeProxy(1780304400),
    CutoffId = 10012,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1777946400),
    ItemId = 120158
  },
  [10013] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10013,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120159
  },
  [10014] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10014,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 120160
  },
  [10015] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10015,
    CutoffPrice = 100,
    CutoffShow = 14,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120162
  },
  [10016] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10016,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120163
  },
  [10017] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10017,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120164
  },
  [10018] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10018,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120165
  },
  [10019] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10019,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120166
  },
  [10020] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10020,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120167
  },
  [10021] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10021,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 120168
  },
  [10022] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10022,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 160166
  },
  [10023] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10023,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1782784800),
    ItemId = 160167
  },
  [10024] = {
    CutoffEndTime = LocalTimeProxy(1785142800),
    CutoffId = 10024,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1780279200),
    ItemId = 160168
  },
  [10025] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10025,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120170
  },
  [10026] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10026,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120171
  },
  [10027] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10027,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120172
  },
  [10028] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10028,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120173
  },
  [10029] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10029,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120174
  },
  [10030] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10030,
    CutoffPrice = 780,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120175
  },
  [10031] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10031,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 120176
  },
  [10032] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 10032,
    CutoffPrice = 680,
    CutoffShow = 53,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 100095
  },
  [10033] = {
    CutoffId = 10033,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100096
  },
  [10034] = {
    CutoffId = 10034,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100097
  },
  [10035] = {
    CutoffId = 10035,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100098
  },
  [10036] = {
    CutoffId = 10036,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100099
  },
  [10037] = {
    CutoffId = 10037,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100100
  },
  [10038] = {
    CutoffId = 10038,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100101
  },
  [10039] = {
    CutoffId = 10039,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 100102
  },
  [10040] = {
    CutoffId = 10040,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 100103
  },
  [10041] = {
    CutoffId = 10041,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 100104
  },
  [10042] = {
    CutoffId = 10042,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 100105
  },
  [10043] = {
    CutoffId = 10043,
    CutoffPrice = 680,
    CutoffShow = 69,
    CutoffStartTime = LocalTimeProxy(1767664800),
    ItemId = 100106
  },
  [10044] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10044,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100107
  },
  [10045] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10045,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100108
  },
  [10046] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10046,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100109
  },
  [10047] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10047,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100110
  },
  [10048] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10048,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100111
  },
  [10049] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10049,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100112
  },
  [10050] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10050,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100113
  },
  [10051] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10051,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100114
  },
  [10052] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10052,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100115
  },
  [10053] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10053,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100116
  },
  [10054] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10054,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100117
  },
  [10055] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10055,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100118
  },
  [10056] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10056,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1769479200),
    ItemId = 100119
  },
  [10057] = {
    CutoffId = 10057,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100120
  },
  [10058] = {
    CutoffId = 10058,
    CutoffPrice = 60,
    CutoffShow = 20,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100121
  },
  [10059] = {
    CutoffId = 10059,
    CutoffPrice = 10,
    CutoffShow = 3,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100122
  },
  [10060] = {
    CutoffId = 10060,
    CutoffPrice = 10,
    CutoffShow = 3,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100123
  },
  [10061] = {
    CutoffId = 10061,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100124
  },
  [10062] = {
    CutoffId = 10062,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100125
  },
  [10063] = {
    CutoffId = 10063,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 100126
  },
  [10064] = {
    CutoffId = 10064,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 100127
  },
  [10065] = {
    CutoffId = 10065,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 100128
  },
  [10066] = {
    CutoffEndTime = LocalTimeProxy(1766394000),
    CutoffId = 10066,
    CutoffPrice = 60,
    CutoffShow = 12,
    CutoffStartTime = LocalTimeProxy(1764036000),
    ItemId = 100129
  },
  [10067] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10067,
    CutoffPrice = 60,
    CutoffShow = 12,
    CutoffStartTime = LocalTimeProxy(1771898400),
    ItemId = 100130
  },
  [10068] = {
    CutoffId = 10068,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100131
  },
  [10069] = {
    CutoffId = 10069,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100132
  },
  [10070] = {
    CutoffId = 10070,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1770602400),
    ItemId = 100133
  },
  [10071] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10071,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1774317600),
    ItemId = 100134
  },
  [10072] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10072,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1774317600),
    ItemId = 100135
  },
  [10073] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10073,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1774317600),
    ItemId = 100136
  },
  [10074] = {
    CutoffEndTime = LocalTimeProxy(1775466000),
    CutoffId = 10074,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1774317600),
    ItemId = 100137
  },
  [10075] = {
    CutoffEndTime = LocalTimeProxy(1768770000),
    CutoffId = 10075,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1766408400),
    ItemId = 100138
  },
  [10076] = {
    CutoffEndTime = LocalTimeProxy(1770667200),
    CutoffId = 10076,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1768874400),
    ItemId = 100139
  },
  [10077] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10077,
    CutoffPrice = 980,
    CutoffShow = 76,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100140
  },
  [10078] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10078,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100141
  },
  [10079] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10079,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100142
  },
  [10080] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10080,
    CutoffPrice = 180,
    CutoffShow = 26,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100143
  },
  [10081] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10081,
    CutoffPrice = 60,
    CutoffShow = 8,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100144
  },
  [10084] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10084,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100147
  },
  [10085] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10085,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100148
  },
  [10086] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10086,
    CutoffPrice = 120,
    CutoffShow = 40,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100149
  },
  [10087] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10087,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100150
  },
  [10088] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10088,
    CutoffPrice = 180,
    CutoffShow = 60,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100151
  },
  [10090] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10090,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100153
  },
  [10091] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10091,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100154
  },
  [10092] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10092,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100155
  },
  [10093] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10093,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100156
  },
  [10094] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10094,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100157
  },
  [10095] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10095,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100158
  },
  [10096] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10096,
    CutoffPrice = 180,
    CutoffShow = 37,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100159
  },
  [10097] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10097,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100160
  },
  [10098] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10098,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100161
  },
  [10099] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10099,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100162
  },
  [10100] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10100,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100163
  },
  [10101] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10101,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100164
  },
  [10103] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10103,
    CutoffPrice = 300,
    CutoffShow = 44,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100166
  },
  [10104] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10104,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100167
  },
  [10105] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10105,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100168
  },
  [10106] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10106,
    CutoffPrice = 480,
    CutoffShow = 70,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100169
  },
  [10107] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10107,
    CutoffPrice = 120,
    CutoffShow = 25,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100170
  },
  [10108] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10108,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100171
  },
  [10109] = {
    CutoffEndTime = LocalTimeProxy(1788771600),
    CutoffId = 10109,
    CutoffPrice = 300,
    CutoffShow = 62,
    CutoffStartTime = LocalTimeProxy(1785117600),
    ItemId = 100172
  },
  [10110] = {
    CutoffId = 10110,
    CutoffPrice = 60,
    CutoffShow = 6,
    CutoffStartTime = LocalTimeProxy(1672545600),
    ItemId = 100198
  }
})
