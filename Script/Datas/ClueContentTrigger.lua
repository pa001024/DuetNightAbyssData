local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ClueContentTrigger", {
  Dialogue = {
    [11100001] = {
      [1] = {ClueContentId = 11030104, State = 1},
      [2] = {ClueContentId = 10020101, State = 1},
      [3] = {ClueContentId = 10010101, State = 1},
      [4] = {ClueContentId = 12020401, State = 1},
      [5] = {ClueContentId = 11030101, State = 1},
      [6] = {ClueContentId = 11030102, State = 1},
      [7] = {ClueContentId = 11030103, State = 1}
    },
    [11100225] = {
      [1] = {ClueContentId = 12020301, State = 1}
    },
    [11100241] = {
      [1] = {ClueContentId = 12020101, State = 1},
      [2] = {ClueContentId = 10010102, State = 1}
    },
    [11100406] = {
      [1] = {ClueContentId = 10030301, State = 1}
    },
    [11100414] = {
      [1] = {ClueContentId = 12020201, State = 1}
    },
    [11100902] = {
      [1] = {ClueContentId = 10030201, State = 1}
    },
    [11101102] = {
      [1] = {ClueContentId = 11010101, State = 1}
    },
    [11101610] = {
      [1] = {ClueContentId = 12020402, State = 1},
      [2] = {ClueContentId = 11030201, State = 1}
    },
    [11101617] = {
      [1] = {ClueContentId = 10010103, State = 1}
    },
    [11101619] = {
      [1] = {ClueContentId = 10030101, State = 1}
    },
    [11102821] = {
      [1] = {ClueContentId = 12010101, State = 1}
    },
    [11103808] = {
      [1] = {ClueContentId = 12020203, State = 1}
    },
    [11105405] = {
      [1] = {ClueContentId = 12020501, State = 1}
    },
    [11105822] = {
      [1] = {ClueContentId = 10010201, State = 1},
      [2] = {ClueContentId = 12010102, State = 1}
    },
    [11105834] = {
      [1] = {ClueContentId = 12020202, State = 1}
    },
    [11106506] = {
      [1] = {ClueContentId = 12021201, State = 1},
      [2] = {ClueContentId = 12020601, State = 1},
      [3] = {ClueContentId = 12022001, State = 1},
      [4] = {ClueContentId = 12021801, State = 1},
      [5] = {ClueContentId = 12021701, State = 1},
      [6] = {ClueContentId = 12021601, State = 1},
      [7] = {ClueContentId = 12021501, State = 1},
      [8] = {ClueContentId = 12021401, State = 1},
      [9] = {ClueContentId = 12021101, State = 1},
      [10] = {ClueContentId = 12021001, State = 1},
      [11] = {ClueContentId = 12020901, State = 1},
      [12] = {ClueContentId = 12020801, State = 1},
      [13] = {ClueContentId = 12020701, State = 1},
      [14] = {ClueContentId = 12021301, State = 1}
    },
    [11106524] = {
      [1] = {ClueContentId = 10030102, State = 1}
    },
    [11106537] = {
      [1] = {ClueContentId = 12020303, State = 1}
    },
    [11106802] = {
      [1] = {ClueContentId = 12020302, State = 1}
    },
    [11106804] = {
      [1] = {ClueContentId = 10030105, State = 1}
    },
    [11108302] = {
      [1] = {ClueContentId = 12020304, State = 1}
    },
    [11108404] = {
      [1] = {ClueContentId = 10030103, State = 1}
    },
    [11108813] = {
      [1] = {ClueContentId = 11030301, State = 1}
    },
    [11108949] = {
      [1] = {ClueContentId = 12020602, State = 1}
    },
    [11110403] = {
      [1] = {ClueContentId = 11030202, State = 1}
    },
    [11111019] = {
      [1] = {ClueContentId = 10010202, State = 1}
    },
    [11111047] = {
      [1] = {ClueContentId = 11030401, State = 1}
    },
    [11111057] = {
      [1] = {ClueContentId = 10030104, State = 1}
    },
    [11112301] = {
      [1] = {ClueContentId = 11030501, State = 1}
    },
    [11112701] = {
      [1] = {ClueContentId = 11030502, State = 1}
    },
    [11114002] = {
      [1] = {ClueContentId = 11020102, State = 1}
    },
    [11114213] = {
      [1] = {ClueContentId = 10030401, State = 1},
      [2] = {ClueContentId = 10030402, State = 1},
      [3] = {ClueContentId = 10030403, State = 1},
      [4] = {ClueContentId = 10030404, State = 1},
      [5] = {ClueContentId = 10030405, State = 1},
      [6] = {ClueContentId = 10030406, State = 1},
      [7] = {ClueContentId = 10030407, State = 1},
      [8] = {ClueContentId = 10030408, State = 1},
      [9] = {ClueContentId = 10030409, State = 1},
      [10] = {ClueContentId = 10030410, State = 1}
    },
    [11115003] = {
      [1] = {ClueContentId = 12021202, State = 1}
    },
    [11115049] = {
      [1] = {ClueContentId = 10030202, State = 1}
    },
    [11115209] = {
      [1] = {ClueContentId = 12022101, State = 1}
    },
    [11115516] = {
      [1] = {ClueContentId = 12020204, State = 1}
    },
    [11115524] = {
      [1] = {ClueContentId = 12020502, State = 1}
    },
    [11116601] = {
      [1] = {ClueContentId = 12020902, State = 1}
    },
    [11116801] = {
      [1] = {ClueContentId = 11030403, State = 1}
    },
    [11117201] = {
      [1] = {ClueContentId = 11030402, State = 1}
    },
    [11117210] = {
      [1] = {ClueContentId = 12020305, State = 1},
      [2] = {ClueContentId = 10030302, State = 1}
    },
    [11117225] = {
      [1] = {ClueContentId = 10030303, State = 1}
    },
    [11118623] = {
      [1] = {ClueContentId = 12020205, State = 1}
    },
    [11118913] = {
      [1] = {ClueContentId = 12021302, State = 1}
    },
    [11118917] = {
      [1] = {ClueContentId = 12021502, State = 1}
    },
    [11120305] = {
      [1] = {ClueContentId = 12020206, State = 1},
      [2] = {ClueContentId = 10020102, State = 1},
      [3] = {ClueContentId = 12020403, State = 1}
    },
    [11120334] = {
      [1] = {ClueContentId = 10020103, State = 1}
    },
    [11120338] = {
      [1] = {ClueContentId = 10010203, State = 1}
    },
    [11120622] = {
      [1] = {ClueContentId = 10010204, State = 1}
    },
    [11120823] = {
      [1] = {ClueContentId = 12020404, State = 1}
    },
    [11121012] = {
      [1] = {ClueContentId = 12010103, State = 1}
    },
    [11121420] = {
      [1] = {ClueContentId = 12020207, State = 1},
      [2] = {ClueContentId = 12021901, State = 1}
    },
    [11123840] = {
      [1] = {ClueContentId = 12020503, State = 1}
    }
  },
  MechState = {},
  Resource = {
    [2000128] = {
      [1] = {ClueContentId = 11010102, State = 1}
    },
    [2000129] = {
      [1] = {ClueContentId = 11020101, State = 1}
    },
    [2000134] = {
      [1] = {ClueContentId = 12020903, State = 1}
    },
    [2000135] = {
      [1] = {ClueContentId = 12021203, State = 1},
      [2] = {ClueContentId = 12021602, State = 1}
    },
    [2000136] = {
      [1] = {ClueContentId = 12022002, State = 1}
    },
    [2000137] = {
      [1] = {ClueContentId = 12021702, State = 1}
    },
    [2000138] = {
      [1] = {ClueContentId = 12021402, State = 1}
    },
    [2000139] = {
      [1] = {ClueContentId = 12021802, State = 1}
    }
  }
})
