local LocalTimeProxy = (DataMgr or {}).LocalTimeProxy or function(x)
  return x
end
local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("PortraitFacial", {
  Kamila_Afraid = {
    EyesIndex = 3,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_3.T_Story_Kamila_3'",
    MouthDefaultFrame = 0,
    MouthIndex = 3,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Afraid"
  },
  Kamila_Angry = {
    EyesIndex = 5,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 5,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Angry"
  },
  Kamila_Confident = {
    EyesIndex = 7,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 7,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Confident"
  },
  Kamila_Happy = {
    EyesIndex = 2,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 2,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Happy"
  },
  Kamila_Idle = {
    EyesIndex = 0,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 0,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Idle"
  },
  Kamila_Sad = {
    EyesIndex = 1,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_3.T_Story_Kamila_3'",
    MouthDefaultFrame = 2,
    MouthIndex = 1,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Sad"
  },
  Kamila_Shock = {
    EyesIndex = 4,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 4,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Shock"
  },
  Kamila_Smile = {
    EyesIndex = 6,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Eyes.T_Story_Kamila_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_1.T_Story_Kamila_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 6,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Kamila_Mouth.T_Story_Kamila_Mouth'",
    PortraitFacialId = "Kamila_Smile"
  },
  Leiyi_Afraid = {
    EyesIndex = 3,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_3.T_Story_NPCLeiyi_3'",
    MouthDefaultFrame = 0,
    MouthIndex = 3,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Afraid"
  },
  Leiyi_Angry = {
    EyesIndex = 5,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_2.T_Story_NPCLeiyi_2'",
    MouthDefaultFrame = 2,
    MouthIndex = 5,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Angry"
  },
  Leiyi_Confident = {
    EyesIndex = 7,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_1.T_Story_NPCLeiyi_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 7,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Confident"
  },
  Leiyi_Happy = {
    EyesIndex = 2,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_1.T_Story_NPCLeiyi_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 2,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Happy"
  },
  Leiyi_Idle = {
    EyesIndex = 0,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_1.T_Story_NPCLeiyi_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 0,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Idle"
  },
  Leiyi_Sad = {
    EyesIndex = 1,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_3.T_Story_NPCLeiyi_3'",
    MouthDefaultFrame = 2,
    MouthIndex = 1,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Sad"
  },
  Leiyi_Shock = {
    EyesIndex = 4,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_1.T_Story_NPCLeiyi_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 4,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Shock"
  },
  Leiyi_Smile = {
    EyesIndex = 6,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Eyes.T_Story_NPCLeiyi_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_1.T_Story_NPCLeiyi_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 6,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_NPCLeiyi_Mouth.T_Story_NPCLeiyi_Mouth'",
    PortraitFacialId = "Leiyi_Smile"
  },
  Nanzhu_Afraid = {
    EyesIndex = 3,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_3.T_Story_Nanzhu_3'",
    MouthDefaultFrame = 0,
    MouthIndex = 3,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Afraid"
  },
  Nanzhu_Angry = {
    EyesIndex = 5,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_2.T_Story_Nanzhu_2'",
    MouthDefaultFrame = 2,
    MouthIndex = 5,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Angry"
  },
  Nanzhu_Confident = {
    EyesIndex = 7,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_1.T_Story_Nanzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 7,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Confident"
  },
  Nanzhu_Happy = {
    EyesIndex = 2,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_1.T_Story_Nanzhu_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 2,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Happy"
  },
  Nanzhu_Idle = {
    EyesIndex = 0,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_1.T_Story_Nanzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 0,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Idle"
  },
  Nanzhu_Sad = {
    EyesIndex = 1,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_3.T_Story_Nanzhu_3'",
    MouthDefaultFrame = 2,
    MouthIndex = 1,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Sad"
  },
  Nanzhu_Shock = {
    EyesIndex = 4,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_1.T_Story_Nanzhu_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 4,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Shock"
  },
  Nanzhu_Smile = {
    EyesIndex = 6,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Eyes.T_Story_Nanzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_1.T_Story_Nanzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 6,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nanzhu_Mouth.T_Story_Nanzhu_Mouth'",
    PortraitFacialId = "Nanzhu_Smile"
  },
  Nvzhu_Afraid = {
    EyesIndex = 3,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_3.T_Story_Nvzhu_3'",
    MouthDefaultFrame = 0,
    MouthIndex = 3,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Afraid"
  },
  Nvzhu_Angry = {
    EyesIndex = 5,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_2.T_Story_Nvzhu_2'",
    MouthDefaultFrame = 2,
    MouthIndex = 5,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Angry"
  },
  Nvzhu_Confident = {
    EyesIndex = 7,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_1.T_Story_Nvzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 7,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Confident"
  },
  Nvzhu_Happy = {
    EyesIndex = 2,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_1.T_Story_Nvzhu_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 2,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Happy"
  },
  Nvzhu_Idle = {
    EyesIndex = 0,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_1.T_Story_Nvzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 0,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Idle"
  },
  Nvzhu_Sad = {
    EyesIndex = 1,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_3.T_Story_Nvzhu_3'",
    MouthDefaultFrame = 2,
    MouthIndex = 1,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Sad"
  },
  Nvzhu_Shock = {
    EyesIndex = 4,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_1.T_Story_Nvzhu_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 4,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Shock"
  },
  Nvzhu_Smile = {
    EyesIndex = 6,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Eyes.T_Story_Nvzhu_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_1.T_Story_Nvzhu_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 6,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_Nvzhu_Mouth.T_Story_Nvzhu_Mouth'",
    PortraitFacialId = "Nvzhu_Smile"
  },
  SPLise_Afraid = {
    EyesIndex = 3,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_3.T_Story_SPLise_3'",
    MouthDefaultFrame = 0,
    MouthIndex = 3,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Afraid"
  },
  SPLise_Angry = {
    EyesIndex = 5,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_2.T_Story_SPLise_2'",
    MouthDefaultFrame = 2,
    MouthIndex = 5,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Angry"
  },
  SPLise_Confident = {
    EyesIndex = 7,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_1.T_Story_SPLise_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 7,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Confident"
  },
  SPLise_Happy = {
    EyesIndex = 2,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_1.T_Story_SPLise_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 2,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Happy"
  },
  SPLise_Idle = {
    EyesIndex = 0,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_1.T_Story_SPLise_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 0,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Idle"
  },
  SPLise_Sad = {
    EyesIndex = 1,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_3.T_Story_SPLise_3'",
    MouthDefaultFrame = 2,
    MouthIndex = 1,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Sad"
  },
  SPLise_Shock = {
    EyesIndex = 4,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_1.T_Story_SPLise_1'",
    MouthDefaultFrame = 0,
    MouthIndex = 4,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Shock"
  },
  SPLise_Smile = {
    EyesIndex = 6,
    EyesTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Eyes.T_Story_SPLise_Eyes'",
    FaceTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_1.T_Story_SPLise_1'",
    MouthDefaultFrame = 2,
    MouthIndex = 6,
    MouthTexture = "Texture2D'/Game/UI/Texture/Static/Image/Story/T_Story_SPLise_Mouth.T_Story_SPLise_Mouth'",
    PortraitFacialId = "SPLise_Smile"
  }
})
