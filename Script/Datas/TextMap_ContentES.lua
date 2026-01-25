local Data = {
  {
    MinKey = "AnnouncementAutoTimeZone",
    MaxKey = "DailyTaskDes_10000111",
    Loader = function()
      return {
        AnnouncementAutoTimeZone = {
          ContentES = "(UTC%s)",
          TextMapId = "AnnouncementAutoTimeZone"
        },
        AnnouncementTimeFormatLong = {
          ContentES = "{DD} {MM} {YY}, {H}:{M} – {DD1} {MM1} {YY1}, {H1}:{M1}",
          TextMapId = "AnnouncementTimeFormatLong"
        },
        AnnouncementTimeFormatOne = {
          ContentES = "{DD} {MM} {YY}, {H}:{M}",
          TextMapId = "AnnouncementTimeFormatOne"
        },
        AnnouncementTimeFormatShort = {
          ContentES = "{DD} {MM} {YY}, {H}:{M} – {H1}:{M1}",
          TextMapId = "AnnouncementTimeFormatShort"
        },
        BattlePass_Task_Des_100001001 = {
          ContentES = "Iniciar sesión",
          TextMapId = "BattlePass_Task_Des_100001001"
        },
        BattlePass_Task_Des_100001003 = {
          ContentES = "El progreso de las Notas alcanza <H>200</>",
          TextMapId = "BattlePass_Task_Des_100001003"
        },
        BattlePass_Task_Des_100001004 = {
          ContentES = "Obtén <H>3</> Cuñas Demoníacas",
          TextMapId = "BattlePass_Task_Des_100001004"
        },
        BattlePass_Task_Des_100001005 = {
          ContentES = "Hazte amigo con <H>1</> Geniemon",
          TextMapId = "BattlePass_Task_Des_100001005"
        },
        BattlePass_Task_Des_100001006 = {
          ContentES = "Completa <H>1</> Encargo secreto",
          TextMapId = "BattlePass_Task_Des_100001006"
        },
        BattlePass_Task_Des_100001101 = {
          ContentES = "Obtén <H>30</> Cuñas Demoníacas",
          TextMapId = "BattlePass_Task_Des_100001101"
        },
        BattlePass_Task_Des_100001102 = {
          ContentES = "Gasta un total de <H>300.000</> Monedas",
          TextMapId = "BattlePass_Task_Des_100001102"
        },
        BattlePass_Task_Des_100001103 = {
          ContentES = "Completa <H>10</> Encargos",
          TextMapId = "BattlePass_Task_Des_100001103"
        },
        BattlePass_Task_Des_100001104 = {
          ContentES = "Completa <H>1</> nivel del Laberinto místico",
          TextMapId = "BattlePass_Task_Des_100001104"
        },
        BattlePass_Task_Des_100001105 = {
          ContentES = "Completa <H>1</> Misión dinámica",
          TextMapId = "BattlePass_Task_Des_100001105"
        },
        BattlePass_Task_Des_100001106 = {
          ContentES = "Hazte amigo con <H>10</> Geniemons",
          TextMapId = "BattlePass_Task_Des_100001106"
        },
        BattlePass_Task_Des_100001107 = {
          ContentES = "Asciende cualquier Geniemon <H>3</> veces",
          TextMapId = "BattlePass_Task_Des_100001107"
        },
        BattlePass_Task_Des_100001108 = {
          ContentES = "Gana <H>1</> combate en los Ecos nocturnos",
          TextMapId = "BattlePass_Task_Des_100001108"
        },
        BattlePass_Task_Des_100001109 = {
          ContentES = "Completa <H>6</> Encargos secretos",
          TextMapId = "BattlePass_Task_Des_100001109"
        },
        BattlePass_Task_Des_100001110 = {
          ContentES = "Completa <H>12</> Encargos secretos",
          TextMapId = "BattlePass_Task_Des_100001110"
        },
        BattlePass_Task_Des_100001111 = {
          ContentES = "Completa <H>18</> Encargos secretos",
          TextMapId = "BattlePass_Task_Des_100001111"
        },
        BattlePass_Task_Des_100001112 = {
          ContentES = "Completa <H>24</> Encargos secretos",
          TextMapId = "BattlePass_Task_Des_100001112"
        },
        BattlePass_Task_Des_100001201 = {
          ContentES = "Completa todas las \"Representaciones Destacadas\" en curso en el \"Teatro Inmersivo\"",
          TextMapId = "BattlePass_Task_Des_100001201"
        },
        BattlePass_Task_Des_100001202 = {
          ContentES = "Rastrea <H>40</> veces",
          TextMapId = "BattlePass_Task_Des_100001202"
        },
        BattlePass_Task_Des_100001203 = {
          ContentES = "Completa la Misión principal: En una suave brisa",
          TextMapId = "BattlePass_Task_Des_100001203"
        },
        BattlePass_Task_Des_100001204 = {
          ContentES = "Completa la Misión principal: El Día del juicio",
          TextMapId = "BattlePass_Task_Des_100001204"
        },
        BattlePass_Task_Des_100001205 = {
          ContentES = "Alcanza la etapa VI de la Guía para principiantes en los Encargos",
          TextMapId = "BattlePass_Task_Des_100001205"
        },
        BattlePass_Task_Des_100001206 = {
          ContentES = "Inicia sesión <H>8</> días en total",
          TextMapId = "BattlePass_Task_Des_100001206"
        },
        BattlePass_Task_Des_100001207 = {
          ContentES = "Completa <H>10</> encargos en el evento \"El Extraño venido de lejos\"",
          TextMapId = "BattlePass_Task_Des_100001207"
        },
        BattlePass_Task_Des_100001209 = {
          ContentES = "En el evento \"Un sueño de colores del arcoíris\", completa el nivel \"A través del valle espinado – Parte II\"",
          TextMapId = "BattlePass_Task_Des_100001209"
        },
        BattlePass_Task_Des_100002201 = {
          ContentES = "Completa <H>6</> encargos en el evento \"Huaxu — Inciensos y Maravillas\"",
          TextMapId = "BattlePass_Task_Des_100002201"
        },
        BattlePass_Task_Des_100002202 = {
          ContentES = "Obtén <H>1.000</> Puntos Luno en el evento \"Juegos de la amistad\"",
          TextMapId = "BattlePass_Task_Des_100002202"
        },
        BattlePass_Task_Des_100003113 = {
          ContentES = "Pasa un total de <H>10</> minutos en áreas cooperativas",
          TextMapId = "BattlePass_Task_Des_100003113"
        },
        BattlePass_Task_Des_100003114 = {
          ContentES = "Pasa un total de <H>30</> minutos en áreas cooperativas",
          TextMapId = "BattlePass_Task_Des_100003114"
        },
        BattlePass_Task_Des_100003115 = {
          ContentES = "Pasa un total de <H>60</> minutos en áreas cooperativas",
          TextMapId = "BattlePass_Task_Des_100003115"
        },
        BattlePass_Task_Des_100003201 = {
          ContentES = "Obtén <H>12</> estrellas en dificultad normal en \"Pacto de Ave espiritual\"",
          TextMapId = "BattlePass_Task_Des_100003201"
        },
        BossSkillToast_Jushi_Skill07 = {
          ContentES = "Explosión de Esporas",
          TextMapId = "BossSkillToast_Jushi_Skill07"
        },
        BossSkillToast_Jushi_Skill08 = {
          ContentES = "Aliento Abrasador",
          TextMapId = "BossSkillToast_Jushi_Skill08"
        },
        BossSkillToast_Kuxiu_Skill07 = {
          ContentES = "Grilletes del Mártir",
          TextMapId = "BossSkillToast_Kuxiu_Skill07"
        },
        BossSkillToast_Lianhuo_Skill03 = {
          ContentES = "Juramento de Justicia",
          TextMapId = "BossSkillToast_Lianhuo_Skill03"
        },
        BossSkillToast_Lianhuo_Skill07 = {
          ContentES = "Prueba de Fuego",
          TextMapId = "BossSkillToast_Lianhuo_Skill07"
        },
        BossSkillToast_Lianhuo_Skill08 = {
          ContentES = "Condena Declarada",
          TextMapId = "BossSkillToast_Lianhuo_Skill08"
        },
        BossSkillToast_Linen_Skill04 = {
          ContentES = "Primeros Pasos",
          TextMapId = "BossSkillToast_Linen_Skill04"
        },
        BossSkillToast_Linen_Skill06 = {
          ContentES = "Vals de Proyectiles",
          TextMapId = "BossSkillToast_Linen_Skill06"
        },
        BossSkillToast_Linen_Skill07 = {
          ContentES = "Ritmos Mortales",
          TextMapId = "BossSkillToast_Linen_Skill07"
        },
        BossSkillToast_Linen_Skill09 = {
          ContentES = "Concierto de Fuego",
          TextMapId = "BossSkillToast_Linen_Skill09"
        },
        BossSkillToast_Linen_Skill11 = {
          ContentES = "Sinfonía de Disparos",
          TextMapId = "BossSkillToast_Linen_Skill11"
        },
        BossSkillToast_Saiqi_Skill05 = {
          ContentES = "Crisálida de Sueños Rotos",
          TextMapId = "BossSkillToast_Saiqi_Skill05"
        },
        BossSkillToast_Saiqi_Skill10 = {
          ContentES = "Zambullida Marchita",
          TextMapId = "BossSkillToast_Saiqi_Skill10"
        },
        BossSkillToast_Saiqi_Skill23 = {
          ContentES = "Lamento de la Luz Moribunda",
          TextMapId = "BossSkillToast_Saiqi_Skill23"
        },
        BossSkillToast_Shenpan_Skill02 = {
          ContentES = "Bautismo en Luz",
          TextMapId = "BossSkillToast_Shenpan_Skill02"
        },
        BossSkillToast_Shenpan_Skill05 = {
          ContentES = "Corona del Juicio",
          TextMapId = "BossSkillToast_Shenpan_Skill05"
        },
        BossSkillToast_Shijingzhe_Skill05 = {
          ContentES = "Ataque Salvaje",
          TextMapId = "BossSkillToast_Shijingzhe_Skill05"
        },
        BossSkillToast_Shijingzhe_Skill13 = {
          ContentES = "Desgarro Feral",
          TextMapId = "BossSkillToast_Shijingzhe_Skill13"
        },
        BossSkillToast_Shijingzhe_Skill14 = {
          ContentES = "Aplastamiento Desesperado",
          TextMapId = "BossSkillToast_Shijingzhe_Skill14"
        },
        BossSkillToast_Shijingzhe_Skill15 = {
          ContentES = "Aullido Errante",
          TextMapId = "BossSkillToast_Shijingzhe_Skill15"
        },
        BossSkillToast_Tuosi_Skill07 = {
          ContentES = "Rugido Salvaje",
          TextMapId = "BossSkillToast_Tuosi_Skill07"
        },
        BossSkillToast_Tuosi_Skill08 = {
          ContentES = "Rugido Furioso",
          TextMapId = "BossSkillToast_Tuosi_Skill08"
        },
        BossSkillToast_Xibi_Skill05 = {
          ContentES = "Tormenta Nefasta",
          TextMapId = "BossSkillToast_Xibi_Skill05"
        },
        BossSkillToast_Xibi_Skill09 = {
          ContentES = "Jaula del Terror",
          TextMapId = "BossSkillToast_Xibi_Skill09"
        },
        BossSkillToast_Xibi_Skill10 = {
          ContentES = "Asedio Eléctrico",
          TextMapId = "BossSkillToast_Xibi_Skill10"
        },
        BossSkillToast_Xibi_Skill15 = {
          ContentES = "Perdición Devastadora",
          TextMapId = "BossSkillToast_Xibi_Skill15"
        },
        Boss_Saiqi_Penalize = {
          ContentES = "Ofrece un ramo de flores",
          TextMapId = "Boss_Saiqi_Penalize"
        },
        CVName1001 = {ContentES = "贺文潇", TextMapId = "CVName1001"},
        CVName1002 = {ContentES = "朔小兔", TextMapId = "CVName1002"},
        CVName1003 = {ContentES = "虚元", TextMapId = "CVName1003"},
        CVName1004 = {ContentES = "柳知萧", TextMapId = "CVName1004"},
        CVName1005 = {ContentES = "常蓉珊", TextMapId = "CVName1005"},
        CVName1006 = {ContentES = "蔡娜", TextMapId = "CVName1006"},
        CVName1007 = {ContentES = "云鹤追", TextMapId = "CVName1007"},
        CVName1008 = {
          ContentES = "卢力峰DK",
          TextMapId = "CVName1008"
        },
        CVName1009 = {ContentES = "杨昕燃", TextMapId = "CVName1009"},
        CVName1010 = {ContentES = "蔡海婷", TextMapId = "CVName1010"},
        CVName1011 = {ContentES = "张琦", TextMapId = "CVName1011"},
        CVName1012 = {ContentES = "叶知秋", TextMapId = "CVName1012"},
        CVName1013 = {ContentES = "弭洋", TextMapId = "CVName1013"},
        CVName1014 = {ContentES = "黑特", TextMapId = "CVName1014"},
        CVName1015 = {ContentES = "赵爽", TextMapId = "CVName1015"},
        CVName1016 = {ContentES = "李春胤", TextMapId = "CVName1016"},
        CVName1017 = {ContentES = "橙璃", TextMapId = "CVName1017"},
        CVName1018 = {ContentES = "吕思衡", TextMapId = "CVName1018"},
        CVName1019 = {ContentES = "姜贺", TextMapId = "CVName1019"},
        CVName1020 = {ContentES = "李嘉祥", TextMapId = "CVName1020"},
        CVName1021 = {ContentES = "钟可", TextMapId = "CVName1021"},
        CVName1022 = {ContentES = "龟娘", TextMapId = "CVName1022"},
        CVName1023 = {ContentES = "Cai Shujin", TextMapId = "CVName1023"},
        CVName2001 = {
          ContentES = "Alexandra Guelff",
          TextMapId = "CVName2001"
        },
        CVName2002 = {
          ContentES = "Montserrat Lombard",
          TextMapId = "CVName2002"
        },
        CVName2003 = {
          ContentES = "Harriet Carmichael",
          TextMapId = "CVName2003"
        },
        CVName2004 = {ContentES = "Crystal Yu", TextMapId = "CVName2004"},
        CVName2005 = {
          ContentES = "Jess Nesling",
          TextMapId = "CVName2005"
        },
        CVName2006 = {
          ContentES = "Lucy Aarden",
          TextMapId = "CVName2006"
        },
        CVName2007 = {
          ContentES = "Gabrielle Nellis-Pain",
          TextMapId = "CVName2007"
        },
        CVName2008 = {
          ContentES = "Dominic Thorburn",
          TextMapId = "CVName2008"
        },
        CVName2009 = {
          ContentES = "James MacNaughton",
          TextMapId = "CVName2009"
        },
        CVName2010 = {
          ContentES = "Lizzie Waterworth-Santo",
          TextMapId = "CVName2010"
        },
        CVName2011 = {
          ContentES = "Eleanor Bennett",
          TextMapId = "CVName2011"
        },
        CVName2012 = {
          ContentES = "Devora Wilde",
          TextMapId = "CVName2012"
        },
        CVName2013 = {
          ContentES = "Claire Morgan",
          TextMapId = "CVName2013"
        },
        CVName2014 = {
          ContentES = "Carina Reeves",
          TextMapId = "CVName2014"
        },
        CVName2015 = {
          ContentES = "Shannon Tarbet",
          TextMapId = "CVName2015"
        },
        CVName2016 = {
          ContentES = "Jamie Hoskin",
          TextMapId = "CVName2016"
        },
        CVName2017 = {
          ContentES = "Sophie Colquhoun",
          TextMapId = "CVName2017"
        },
        CVName2018 = {ContentES = "Jack Ayres", TextMapId = "CVName2018"},
        CVName2019 = {
          ContentES = "Allegra Marland",
          TextMapId = "CVName2019"
        },
        CVName2020 = {
          ContentES = "Robin Liew Harper",
          TextMapId = "CVName2020"
        },
        CVName2021 = {
          ContentES = "Quanna Luo Masterson",
          TextMapId = "CVName2021"
        },
        CVName2022 = {
          ContentES = "Fern Deacon",
          TextMapId = "CVName2022"
        },
        CVName2023 = {
          ContentES = "Penelope Rawlins",
          TextMapId = "CVName2023"
        },
        CVName3001 = {
          ContentES = "石川由依",
          TextMapId = "CVName3001"
        },
        CVName3002 = {ContentES = "悠木碧", TextMapId = "CVName3002"},
        CVName3003 = {
          ContentES = "新井里美",
          TextMapId = "CVName3003"
        },
        CVName3004 = {
          ContentES = "南条爱乃",
          TextMapId = "CVName3004"
        },
        CVName3005 = {
          ContentES = "佐藤利奈",
          TextMapId = "CVName3005"
        },
        CVName3006 = {ContentES = "户松遥", TextMapId = "CVName3006"},
        CVName3007 = {
          ContentES = "小清水亚美",
          TextMapId = "CVName3007"
        },
        CVName3008 = {
          ContentES = "细谷佳正",
          TextMapId = "CVName3008"
        },
        CVName3009 = {
          ContentES = "小野贤章",
          TextMapId = "CVName3009"
        },
        CVName3010 = {
          ContentES = "丰崎爱生",
          TextMapId = "CVName3010"
        },
        CVName3011 = {
          ContentES = "佐藤聪美",
          TextMapId = "CVName3011"
        },
        CVName3012 = {
          ContentES = "田中理惠",
          TextMapId = "CVName3012"
        },
        CVName3013 = {
          ContentES = "田村睦心",
          TextMapId = "CVName3013"
        },
        CVName3014 = {
          ContentES = "黑泽朋世",
          TextMapId = "CVName3014"
        },
        CVName3015 = {
          ContentES = "长绳麻理亚",
          TextMapId = "CVName3015"
        },
        CVName3016 = {ContentES = "古川慎", TextMapId = "CVName3016"},
        CVName3017 = {
          ContentES = "濑户麻沙美",
          TextMapId = "CVName3017"
        },
        CVName3018 = {ContentES = "KENN", TextMapId = "CVName3018"},
        CVName3019 = {
          ContentES = "井上喜久子",
          TextMapId = "CVName3019"
        },
        CVName3020 = {
          ContentES = "高桥广树",
          TextMapId = "CVName3020"
        },
        CVName3021 = {
          ContentES = "泽城美雪",
          TextMapId = "CVName3021"
        },
        CVName3022 = {
          ContentES = "石见舞菜香",
          TextMapId = "CVName3022"
        },
        CVName3023 = {ContentES = "Asumi Kana", TextMapId = "CVName3023"},
        CVName4001 = {ContentES = "김하영", TextMapId = "CVName4001"},
        CVName4002 = {ContentES = "조경이", TextMapId = "CVName4002"},
        CVName4003 = {ContentES = "성예원", TextMapId = "CVName4003"},
        CVName4004 = {ContentES = "이다은", TextMapId = "CVName4004"},
        CVName4005 = {ContentES = "소연", TextMapId = "CVName4005"},
        CVName4006 = {ContentES = "성예원", TextMapId = "CVName4006"},
        CVName4007 = {ContentES = "김보나", TextMapId = "CVName4007"},
        CVName4008 = {ContentES = "김민주", TextMapId = "CVName4008"},
        CVName4009 = {ContentES = "남도형", TextMapId = "CVName4009"},
        CVName4010 = {ContentES = "강새봄", TextMapId = "CVName4010"},
        CVName4011 = {ContentES = "유영", TextMapId = "CVName4011"},
        CVName4012 = {ContentES = "이새아", TextMapId = "CVName4012"},
        CVName4013 = {ContentES = "이은조", TextMapId = "CVName4013"},
        CVName4014 = {ContentES = "박이서", TextMapId = "CVName4014"},
        CVName4015 = {ContentES = "강은애", TextMapId = "CVName4015"},
        CVName4016 = {ContentES = "표영재", TextMapId = "CVName4016"},
        CVName4017 = {ContentES = "김예림", TextMapId = "CVName4017"},
        CVName4018 = {ContentES = "장서화", TextMapId = "CVName4018"},
        CVName4019 = {ContentES = "이달래", TextMapId = "CVName4019"},
        CVName4020 = {ContentES = "박요한", TextMapId = "CVName4020"},
        CVName4021 = {ContentES = "강시현", TextMapId = "CVName4021"},
        CVName4022 = {ContentES = "이현진", TextMapId = "CVName4022"},
        CVName4023 = {
          ContentES = "Kim Suyoung",
          TextMapId = "CVName4023"
        },
        CharTrialEvent_Des_Baiheng = {
          ContentES = "Ninguna hierba medicinal puede curar los males profundos del mundo,\npero la suya es una naturaleza templada en el bosque de sanadores.\nSu figura brilla, una neblina entre el calor de las hierbas,\ny cada elegante trazo de su receta es un suave ungüento frente a la impermanencia de la vida.",
          TextMapId = "CharTrialEvent_Des_Baiheng"
        },
        CharTrialEvent_Des_Feina = {
          ContentES = "La conociste bajo un diminuto cielo estrellado.\nCon cuentos de hadas, reescribió las heridas de ayer.\nSu pluma blanca como la nieve elevaba innumerables sueños ligeros,\nllevados por los vientos indómitos, estos cruzan muros, páramos y noches heladas.",
          TextMapId = "CharTrialEvent_Des_Feina"
        },
        CharTrialEvent_Des_Saiqi = {
          ContentES = "En tierras heladas, vuestros caminos se cruzan en una ciudad desconocida.\nSu sonrisa derrite la escarcha acumulada en tu corazón.\nEl encuentro inesperado despertó su sueño largamente dormido:\nun sueño bañado de sol... y flores en pleno florecimiento.",
          TextMapId = "CharTrialEvent_Des_Saiqi"
        },
        CharTrialEvent_Des_Songlu = {
          ContentES = "¡Pum, pum, pum... Una enorme bestia cargada de provisiones se acerca!\nNo te preocupes, no te devorará, y tampoco tienes derecho a tocarla. Porque Truffle comparte su comida con todos, sin excepción.\nHoy, como todos los días, la pequeña comisaria tiene la misión de eliminar el hambre en el mundo.",
          TextMapId = "CharTrialEvent_Des_Songlu"
        },
        CharTrialEvent_Title = {
          ContentES = "Marcas en la arena",
          TextMapId = "CharTrialEvent_Title"
        },
        CharTrialEvent_Title_Saiqi = {
          ContentES = "Marcas en la arena",
          TextMapId = "CharTrialEvent_Title_Saiqi"
        },
        CharTrialEvent_Title_Songlu = {
          ContentES = "Marcas en la arena",
          TextMapId = "CharTrialEvent_Title_Songlu"
        },
        ChatCharacter01 = {
          ContentES = "Berenica",
          TextMapId = "ChatCharacter01"
        },
        ChatCharacter02 = {
          ContentES = "Chaos",
          TextMapId = "ChatCharacter02"
        },
        ChatCharacter03 = {
          ContentES = "Hilda",
          TextMapId = "ChatCharacter03"
        },
        ChatCharacter04 = {
          ContentES = "Seth",
          TextMapId = "ChatCharacter04"
        },
        ChatCharacter05 = {
          ContentES = "Flora",
          TextMapId = "ChatCharacter05"
        },
        ChatCharacter06 = {
          ContentES = "Yuming",
          TextMapId = "ChatCharacter06"
        },
        ChatCharacter07 = {
          ContentES = "Hellfire",
          TextMapId = "ChatCharacter07"
        },
        ChatCharacter08 = {
          ContentES = "Psyche",
          TextMapId = "ChatCharacter08"
        },
        ChatCharacter09 = {
          ContentES = "Randy",
          TextMapId = "ChatCharacter09"
        },
        ChatCharacter10 = {
          ContentES = "Sibylle",
          TextMapId = "ChatCharacter10"
        },
        ChatCharacter11 = {
          ContentES = "Lynn",
          TextMapId = "ChatCharacter11"
        },
        ChatCharacter12 = {
          ContentES = "Camilla",
          TextMapId = "ChatCharacter12"
        },
        ChatCharacter13 = {
          ContentES = "Truffle y Filbert",
          TextMapId = "ChatCharacter13"
        },
        ChatCharacter14 = {
          ContentES = "Outsider",
          TextMapId = "ChatCharacter14"
        },
        ChatCharacter15 = {
          ContentES = "Rebecca",
          TextMapId = "ChatCharacter15"
        },
        ChatCharacter16 = {
          ContentES = "Tabethe",
          TextMapId = "ChatCharacter16"
        },
        ChatCharacter17 = {
          ContentES = "Lisebell",
          TextMapId = "ChatCharacter17"
        },
        ChatCharacter18 = {
          ContentES = "Fushu",
          TextMapId = "ChatCharacter18"
        },
        ChatCharacter19 = {
          ContentES = "Fina",
          TextMapId = "ChatCharacter19"
        },
        ChatCharacter20 = {
          ContentES = "Rhythm",
          TextMapId = "ChatCharacter20"
        },
        ChatCharacter21 = {
          ContentES = "Lirico",
          TextMapId = "ChatCharacter21"
        },
        ChatCharacter22 = {
          ContentES = "Eleutheria",
          TextMapId = "ChatCharacter22"
        },
        ChatCharacter23 = {
          ContentES = "Dama Nifle",
          TextMapId = "ChatCharacter23"
        },
        ChatCharacter24 = {
          ContentES = "Yale y Oliver",
          TextMapId = "ChatCharacter24"
        },
        ChatCharacter26 = {
          ContentES = "Margie",
          TextMapId = "ChatCharacter26"
        },
        ChatCharacter31 = {
          ContentES = "Sr. Qiu",
          TextMapId = "ChatCharacter31"
        },
        ChatCharacter34 = {
          ContentES = "Daphne",
          TextMapId = "ChatCharacter34"
        },
        Condition_Test = {
          ContentES = "Fallo en la verificación de los requisitos previos.",
          TextMapId = "Condition_Test"
        },
        DailyTaskDes_10000101 = {
          ContentES = "Iniciar sesión",
          TextMapId = "DailyTaskDes_10000101"
        },
        DailyTaskDes_10000102 = {
          ContentES = "Obtén <Highlight>3</> Cuñas Demoníacas",
          TextMapId = "DailyTaskDes_10000102"
        },
        DailyTaskDes_10000103 = {
          ContentES = "Mejora una Cuña Demoníaca <Highlight>1</> vez",
          TextMapId = "DailyTaskDes_10000103"
        },
        DailyTaskDes_10000104 = {
          ContentES = "Consume un total de <Highlight>120</> de Energía",
          TextMapId = "DailyTaskDes_10000104"
        },
        DailyTaskDes_10000105 = {
          ContentES = "Completa <Highlight>1</> Encargo",
          TextMapId = "DailyTaskDes_10000105"
        },
        DailyTaskDes_10000106 = {
          ContentES = "Derrota a <Highlight>50</> enemigos",
          TextMapId = "DailyTaskDes_10000106"
        },
        DailyTaskDes_10000107 = {
          ContentES = "Completa <Highlight>1</> nivel del Laberinto místico",
          TextMapId = "DailyTaskDes_10000107"
        },
        DailyTaskDes_10000108 = {
          ContentES = "Gana <Highlight>1</> combate en los Ecos nocturnos",
          TextMapId = "DailyTaskDes_10000108"
        },
        DailyTaskDes_10000109 = {
          ContentES = "Completa [Encargo: Persecución] <Highlight>1</> vez",
          TextMapId = "DailyTaskDes_10000109"
        },
        DailyTaskDes_10000110 = {
          ContentES = "Completa <Highlight>1</> Misión dinámica",
          TextMapId = "DailyTaskDes_10000110"
        },
        DailyTaskDes_10000111 = {
          ContentES = "Pesca <Highlight>1</> vez",
          TextMapId = "DailyTaskDes_10000111"
        }
      }
    end
  },
  {
    MinKey = "DailyTaskDes_10000112",
    MaxKey = "MidTermGoal_Des_7_3",
    Loader = function()
      return {
        DailyTaskDes_10000112 = {
          ContentES = "Forja <Highlight>1</> vez",
          TextMapId = "DailyTaskDes_10000112"
        },
        DailyTaskDes_10000113 = {
          ContentES = "Toma <Highlight>1</> foto",
          TextMapId = "DailyTaskDes_10000113"
        },
        DailyTaskDes_10000114 = {
          ContentES = "Colorea <Highlight>1</> objeto",
          TextMapId = "DailyTaskDes_10000114"
        },
        DailyTaskDes_10000115 = {
          ContentES = "Asciende cualquier arma <Highlight>1</> vez",
          TextMapId = "DailyTaskDes_10000115"
        },
        DailyTaskDes_10000116 = {
          ContentES = "Completa <Highlight>1</> Encargo secreto",
          TextMapId = "DailyTaskDes_10000116"
        },
        DailyTaskDes_10000117 = {
          ContentES = "Completa <Highlight>1</> encargo en <Highlight>modo coop</>",
          TextMapId = "DailyTaskDes_10000117"
        },
        DailyTaskDes_10000118 = {
          ContentES = "Completa cualquier <Highlight>Misión principal</>",
          TextMapId = "DailyTaskDes_10000118"
        },
        DailyTaskDes_10000119 = {
          ContentES = "Completa cualquier <Highlight>Misión secundaria</>",
          TextMapId = "DailyTaskDes_10000119"
        },
        DailyTaskDes_10000120 = {
          ContentES = "Usa cualquier postura de la Mochila táctica un total de <Highlight>3</> veces",
          TextMapId = "DailyTaskDes_10000120"
        },
        EventDungeonPass_Title1 = {
          ContentES = "Desafío completado",
          TextMapId = "EventDungeonPass_Title1"
        },
        EventDungeonPass_Title2 = {
          ContentES = "Desafío terminado",
          TextMapId = "EventDungeonPass_Title2"
        },
        EventPortal_UnlockTips_103001 = {
          ContentES = "Completa la Misión principal: En una suave brisa para desbloquear",
          TextMapId = "EventPortal_UnlockTips_103001"
        },
        EventPortal_UnlockTips_103003 = {
          ContentES = "Continúa con la Misión principal para desbloquear",
          TextMapId = "EventPortal_UnlockTips_103003"
        },
        EventPortal_UnlockTips_103004 = {
          ContentES = "Continúa con la Misión principal para desbloquear",
          TextMapId = "EventPortal_UnlockTips_103004"
        },
        EventPortal_UnlockTips_103012 = {
          ContentES = "Completa la Misión principal: En una suave brisa para desbloquear",
          TextMapId = "EventPortal_UnlockTips_103012"
        },
        EventPortal_UnlockTips_103013 = {
          ContentES = "Completa la Misión principal: El arte de sobrevivir para desbloquear",
          TextMapId = "EventPortal_UnlockTips_103013"
        },
        EventPortal_UnlockTips_Common = {
          ContentES = "Completa las misiones previas para desbloquear",
          TextMapId = "EventPortal_UnlockTips_Common"
        },
        Event_102001_Quest01_Tips = {
          ContentES = "Avanza en la historia principal para completar las misiones de este capítulo",
          TextMapId = "Event_102001_Quest01_Tips"
        },
        Event_102001_QuestName1 = {
          ContentES = "Primer día en Huaxu",
          TextMapId = "Event_102001_QuestName1"
        },
        Event_102001_QuestName2 = {
          ContentES = "Desenreda la cadena",
          TextMapId = "Event_102001_QuestName2"
        },
        Event_102001_QuestName3 = {
          ContentES = "Conflicto incesante",
          TextMapId = "Event_102001_QuestName3"
        },
        Event_102001_QuestName4 = {
          ContentES = "Encuentros en el camino",
          TextMapId = "Event_102001_QuestName4"
        },
        Event_Des_101001 = {
          ContentES = "Inicia sesión durante 7 días para reclamar las recompensas",
          TextMapId = "Event_Des_101001"
        },
        Event_Des_101002 = {
          ContentES = "Inicia sesión durante 7 días para reclamar las recompensas",
          TextMapId = "Event_Des_101002"
        },
        Event_Des_101003 = {
          ContentES = "Inicia sesión durante 7 días para reclamar las recompensas",
          TextMapId = "Event_Des_101003"
        },
        Event_Des_101005 = {
          ContentES = "Inicia sesión durante 7 días para reclamar las recompensas",
          TextMapId = "Event_Des_101005"
        },
        Event_Des_102001 = {
          ContentES = "Huaxu, una tierra tranquila envuelta en incienso.\nHas sido {性别:invitado|invitada}, esperando que Zhiliu te revele un paisaje etéreo, a la vez inmortal y nunca antes visto.",
          TextMapId = "Event_Des_102001"
        },
        Event_Des_103001 = {
          ContentES = "Permíteme guiarte por los interminables senderos del tiempo.",
          TextMapId = "Event_Des_103001"
        },
        Event_Des_103002 = {
          ContentES = "Espectador o protagonista, la elección es tuya. Entra en tu propia escena, donde el coraje enfrenta a los adversarios más poderosos, y donde la alegría de un desenlace perfecto te espera.",
          TextMapId = "Event_Des_103002"
        },
        Event_Des_103003 = {
          ContentES = "Completa la Misión principal \"Presa contra cazador\" para obtener tus recompensas, incluyendo el [Fragmento de pensamiento: Outsider].",
          TextMapId = "Event_Des_103003"
        },
        Event_Des_103004 = {
          ContentES = "Completa la Misión principal \"Los vigilantes\" para obtener tus recompensas, incluyendo el [Fragmento de pensamiento: Daphne].",
          TextMapId = "Event_Des_103004"
        },
        Event_Des_103005 = {
          ContentES = "Como {性别:un Phoxcazador experimentado|una Phoxcazadora experimentada} , se te ha recomendado ayudarla a prepararse. Recolecta lo que necesita y gana generosas recompensas.",
          TextMapId = "Event_Des_103005"
        },
        Event_Des_103006 = {
          ContentES = "E-eh, ¡espera! ¡ESPERA! ¡Esta vez resolvamos esto... de manera civilizada, ¿vale!? ¡Por ejemplo... con una apuesta! ¡Si superas este pequeño desafío, el botín será todo tuyo!\n\n— Lulu, la saqueadora de botín, acurrucada en el suelo, pidiendo misericordia",
          TextMapId = "Event_Des_103006"
        },
        Event_Des_103007 = {
          ContentES = "Entrenamiento de artillería de precisión, una prueba de fuego. Apunta, dispara y cumple con todos los objetivos del ejercicio.",
          TextMapId = "Event_Des_103007"
        },
        Event_Des_103008 = {
          ContentES = "¡Sígueme para mantenerte en el camino y reclamar recompensas exclusivas!",
          TextMapId = "Event_Des_103008"
        },
        Event_Des_103009001 = {
          ContentES = "Durante el evento, las tasas de caída de Cuña Demoníaca se incrementan en los encargos del Manual del Noctoviajero. También están disponibles encargos de Cuña Demoníaca de tiempo limitado.",
          TextMapId = "Event_Des_103009001"
        },
        Event_Des_103010 = {
          ContentES = "Cuando un joven ruiseñor deja su nido, descubre la inmensidad del cielo, roza los suaves campos... pero también enfrenta la lluvia helada y los vientos furiosos.\nSin embargo, la niña no dará marcha atrás: con su pincel mágico, pintará un sueño en cada tono. Y en este mundo duro y implacable, buscará un rincón de cielo eternamente claro, cálido como en los cuentos que la hacen soñar.",
          TextMapId = "Event_Des_103010"
        },
        Event_Des_103012 = {
          ContentES = "Completa el Laberinto místico I a VI para obtener recompensas, incluyendo el [Fragmento de pensamiento: Lisbell].",
          TextMapId = "Event_Des_103012"
        },
        Event_Des_103013 = {
          ContentES = "Completa las Misiones secundarias especiales \"¡Adelante, Geniemon!\" y \"Tutorial: Carta secreta\" para obtener recompensas, incluyendo el [Fragmento de Pensamiento: Truffle y Filbert].",
          TextMapId = "Event_Des_103013"
        },
        Event_Des_105102011 = {
          ContentES = "En una noche de verano, bajo un cielo estrellado, un bosque donde las violetas y las alas de mariposa danzaban en pasos delicados. Una visión que nunca había visto.",
          TextMapId = "Event_Des_105102011"
        },
        Event_Des_105102012 = {
          ContentES = "Un susurro de amor a través de las sedas, una eternidad sellada en un beso fatal.",
          TextMapId = "Event_Des_105102012"
        },
        Event_Des_105102013 = {
          ContentES = "¡Sol reunido, sol disperso!",
          TextMapId = "Event_Des_105102013"
        },
        Event_Des_105102014 = {
          ContentES = "Las mareas para lavar el polvo, las olas para calmar el corazón.",
          TextMapId = "Event_Des_105102014"
        },
        Event_Des_106001 = {
          ContentES = "Aumenta tu Nivel de Aventura para obtener recompensas abundantes.",
          TextMapId = "Event_Des_106001"
        },
        Event_Des_106101 = {
          ContentES = "Carta secreta seleccionada: Abundancia de esperanza",
          TextMapId = "Event_Des_106101"
        },
        Event_Des_107001 = {
          ContentES = "Inicia sesión para recibir Reloj de arena inmaculado ×10.",
          TextMapId = "Event_Des_107001"
        },
        Event_Des_107002 = {
          ContentES = "Inicia sesión en PC y móvil para recibir tus recompensas, incluyendo el marco de avatar de Incensario silencioso y Reloj de arena inmaculado.",
          TextMapId = "Event_Des_107002"
        },
        Event_Des_107003 = {
          ContentES = "Las áreas en coop estarán disponibles al completar \"Hierro negro y flor blanca\" del Capítulo Noctoviajero. Ve a la Plaza de Lago Helado para participar en el modo coop y recibir recompensas increíbles.",
          TextMapId = "Event_Des_107003"
        },
        Event_Des_108001 = {
          ContentES = "Una Ave espiritual onírica te trae una nueva ramita y nuevos desafíos.\nCompleta las Pruebas de Ave espiritual de tiempo limitado para ganar recompensas del evento.",
          TextMapId = "Event_Des_108001"
        },
        Event_Des_WorldLan_101001 = {
          ContentES = "In this age of splendor, we reunite",
          TextMapId = "Event_Des_WorldLan_101001"
        },
        Event_RewardTitle_103007 = {
          ContentES = "Recompensas de los ejercicios",
          TextMapId = "Event_RewardTitle_103007"
        },
        Event_STitle_102001 = {
          ContentES = "El estuario envuelto en niebla",
          TextMapId = "Event_STitle_102001"
        },
        Event_STitle_103002 = {
          ContentES = "Leyendas de los valientes",
          TextMapId = "Event_STitle_103002"
        },
        Event_Tab_101001 = {
          ContentES = "Oda a la floración",
          TextMapId = "Event_Tab_101001"
        },
        Event_Tab_101002 = {
          ContentES = "Bajo los pétalos del albaricoquero",
          TextMapId = "Event_Tab_101002"
        },
        Event_Tab_101003 = {
          ContentES = "Mensaje del Ruiseñor",
          TextMapId = "Event_Tab_101003"
        },
        Event_Tab_101004 = {
          ContentES = "La ficha echada no se retracta",
          TextMapId = "Event_Tab_101004"
        },
        Event_Tab_102001 = {
          ContentES = "Huaxu — Incienso y Maravillas",
          TextMapId = "Event_Tab_102001"
        },
        Event_Tab_103001 = {
          ContentES = "Laberinto místico",
          TextMapId = "Event_Tab_103001"
        },
        Event_Tab_103003 = {
          ContentES = "Viaje hacia la larga noche",
          TextMapId = "Event_Tab_103003"
        },
        Event_Tab_103004 = {
          ContentES = "Entra en la lluvia torrencial",
          TextMapId = "Event_Tab_103004"
        },
        Event_Tab_103005 = {
          ContentES = "Visitante de lejos",
          TextMapId = "Event_Tab_103005"
        },
        Event_Tab_103006 = {
          ContentES = "Juegos amistosos",
          TextMapId = "Event_Tab_103006"
        },
        Event_Tab_103007 = {
          ContentES = "Ejercicios retumbantes",
          TextMapId = "Event_Tab_103007"
        },
        Event_Tab_103008 = {
          ContentES = "Guiando a Luno",
          TextMapId = "Event_Tab_103008"
        },
        Event_Tab_103009001 = {
          ContentES = "Día de abundancia",
          TextMapId = "Event_Tab_103009001"
        },
        Event_Tab_103010 = {
          ContentES = "Un sueño de colores del arcoíris",
          TextMapId = "Event_Tab_103010"
        },
        Event_Tab_103012 = {
          ContentES = "Tumulto inquietante",
          TextMapId = "Event_Tab_103012"
        },
        Event_Tab_103013 = {
          ContentES = "Barriga llena, manos llenas",
          TextMapId = "Event_Tab_103013"
        },
        Event_Tab_105101011 = {
          ContentES = "Marcas en la arena",
          TextMapId = "Event_Tab_105101011"
        },
        Event_Tab_105102011 = {
          ContentES = "Cuando los sueños se visten de noche",
          TextMapId = "Event_Tab_105102011"
        },
        Event_Tab_105102014 = {
          ContentES = "Destello de aguas corrientes",
          TextMapId = "Event_Tab_105102014"
        },
        Event_Tab_106001 = {
          ContentES = "Peregrinaje del largo viaje",
          TextMapId = "Event_Tab_106001"
        },
        Event_Tab_107001 = {
          ContentES = "Himno de la abundancia",
          TextMapId = "Event_Tab_107001"
        },
        Event_Tab_107002 = {
          ContentES = "Espiral de los vínculos",
          TextMapId = "Event_Tab_107002"
        },
        Event_Tab_107003 = {
          ContentES = "Huellas que se cruzan",
          TextMapId = "Event_Tab_107003"
        },
        Event_Tab_107101 = {
          ContentES = "Carta secreta seleccionada",
          TextMapId = "Event_Tab_107101"
        },
        Event_Tab_108001 = {
          ContentES = "Pacto de Ave espiritual",
          TextMapId = "Event_Tab_108001"
        },
        Event_Tab_CharTrialEvent = {
          ContentES = "Marcas en la arena",
          TextMapId = "Event_Tab_CharTrialEvent"
        },
        Event_Title_101001 = {
          ContentES = "Oda a la floración",
          TextMapId = "Event_Title_101001"
        },
        Event_Title_101002 = {
          ContentES = "Bajo los pétalos del albaricoquero",
          TextMapId = "Event_Title_101002"
        },
        Event_Title_101003 = {
          ContentES = "Mensaje del Ruiseñor",
          TextMapId = "Event_Title_101003"
        },
        Event_Title_101004 = {
          ContentES = "La ficha echada no se retracta",
          TextMapId = "Event_Title_101004"
        },
        Event_Title_102001 = {
          ContentES = "Huaxu — Incienso y Maravillas",
          TextMapId = "Event_Title_102001"
        },
        Event_Title_103001 = {
          ContentES = "Laberinto místico",
          TextMapId = "Event_Title_103001"
        },
        Event_Title_103003 = {
          ContentES = "Viaje hacia la larga noche",
          TextMapId = "Event_Title_103003"
        },
        Event_Title_103004 = {
          ContentES = "Entra en la lluvia torrencial",
          TextMapId = "Event_Title_103004"
        },
        Event_Title_103005 = {
          ContentES = "Visitante de lejos",
          TextMapId = "Event_Title_103005"
        },
        Event_Title_103006 = {
          ContentES = "Juegos amistosos",
          TextMapId = "Event_Title_103006"
        },
        Event_Title_103007 = {
          ContentES = "Ejercicios retumbantes",
          TextMapId = "Event_Title_103007"
        },
        Event_Title_103008 = {
          ContentES = "Guiando a Luno",
          TextMapId = "Event_Title_103008"
        },
        Event_Title_103009001 = {
          ContentES = "Día de abundancia",
          TextMapId = "Event_Title_103009001"
        },
        Event_Title_103010 = {
          ContentES = "Un sueño de colores del arcoíris",
          TextMapId = "Event_Title_103010"
        },
        Event_Title_103012 = {
          ContentES = "Tumulto inquietante",
          TextMapId = "Event_Title_103012"
        },
        Event_Title_103013 = {
          ContentES = "Barriga llena, manos llenas",
          TextMapId = "Event_Title_103013"
        },
        Event_Title_106001 = {
          ContentES = "Peregrinaje del largo viaje",
          TextMapId = "Event_Title_106001"
        },
        Event_Title_107001 = {
          ContentES = "Himno de la abundancia",
          TextMapId = "Event_Title_107001"
        },
        Event_Title_107002 = {
          ContentES = "Espiral de los vínculos",
          TextMapId = "Event_Title_107002"
        },
        Event_Title_107003 = {
          ContentES = "Huellas que se cruzan",
          TextMapId = "Event_Title_107003"
        },
        Event_Title_107101 = {
          ContentES = "Carta secreta seleccionada: Abundancia de esperanza",
          TextMapId = "Event_Title_107101"
        },
        Event_Title_108001 = {
          ContentES = "Pacto de Ave espiritual",
          TextMapId = "Event_Title_108001"
        },
        FeinaEvent_DungeonColor_Switch = {
          ContentES = "Cambiar de color",
          TextMapId = "FeinaEvent_DungeonColor_Switch"
        },
        FeinaEvent_DungeonColor_Unlock = {
          ContentES = "Nuevo color disponible",
          TextMapId = "FeinaEvent_DungeonColor_Unlock"
        },
        FeinaEvent_DungeonDes_1 = {
          ContentES = "Fina entra en un mundo de cuentos y llega como invitada a la casa del Gran Mago, pero él parece haber partido... Sigue las huellas que dejó y encuentra la salida de la cueva.",
          TextMapId = "FeinaEvent_DungeonDes_1"
        },
        FeinaEvent_DungeonDes_2 = {
          ContentES = "Al salir de la cueva oscura, Fina emerge en un vasto laberinto. No temáis los trampas y desvíos: con la ayuda de {性别:Señor|Señora} Unicornio, ella sabrá resolver cada uno de los enigmas que se presenten en su camino.",
          TextMapId = "FeinaEvent_DungeonDes_2"
        },
        FeinaEvent_DungeonDes_3 = {
          ContentES = "El camino se interrumpe por un lago resplandeciente, pero tal pequeño obstáculo no detendrá a Fina. Con la ayuda de Señorita Mariposa para despejar el camino espinoso, sube a la barca y cruza al otro lado.",
          TextMapId = "FeinaEvent_DungeonDes_3"
        },
        FeinaEvent_DungeonDes_4 = {
          ContentES = "En el bosque, un velo de niebla borra el camino... pero un ruiseñor se posa en una rama para guiarla. Fina huele flores en la brisa y avanza hacia los campos verdes, escribiendo el final feliz de su historia.",
          TextMapId = "FeinaEvent_DungeonDes_4"
        },
        FeinaEvent_DungeonFinish_Reward = {
          ContentES = "Recompensas",
          TextMapId = "FeinaEvent_DungeonFinish_Reward"
        },
        FeinaEvent_DungeonFinish_Title = {
          ContentES = "Nivel completado",
          TextMapId = "FeinaEvent_DungeonFinish_Title"
        },
        FeinaEvent_DungeonLock_1 = {
          ContentES = "Se desbloquea tras completar la misión <highlight>Más allá de las páginas</>",
          TextMapId = "FeinaEvent_DungeonLock_1"
        },
        FeinaEvent_DungeonLock_2 = {
          ContentES = "Se desbloquea tras completar la misión <highlight>Viejos amigos, nuevas historias</>",
          TextMapId = "FeinaEvent_DungeonLock_2"
        },
        FeinaEvent_DungeonLock_3 = {
          ContentES = "Se desbloquea tras completar la misión <highlight>Un encargo especial inesperado</>",
          TextMapId = "FeinaEvent_DungeonLock_3"
        },
        FeinaEvent_DungeonLock_3_2 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>A través del valle espinoso – Parte Ⅰ</>",
          TextMapId = "FeinaEvent_DungeonLock_3_2"
        },
        FeinaEvent_DungeonLock_4 = {
          ContentES = "Se desbloquea tras completar la misión <highlight>Pequeño ruiseñor, vuela hacia el mañana.</>",
          TextMapId = "FeinaEvent_DungeonLock_4"
        },
        FeinaEvent_DungeonLock_4_2 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Hacia los campos fragantes – Parte Ⅰ</>",
          TextMapId = "FeinaEvent_DungeonLock_4_2"
        },
        FeinaEvent_DungeonName_1 = {
          ContentES = "Adiós a la cueva de ayer",
          TextMapId = "FeinaEvent_DungeonName_1"
        },
        FeinaEvent_DungeonName_2 = {
          ContentES = "A través del laberinto de los recuerdos",
          TextMapId = "FeinaEvent_DungeonName_2"
        },
        FeinaEvent_DungeonName_3 = {
          ContentES = "A través del valle espinoso",
          TextMapId = "FeinaEvent_DungeonName_3"
        },
        FeinaEvent_DungeonName_3_1 = {
          ContentES = "A través del valle espinoso – Parte Ⅰ",
          TextMapId = "FeinaEvent_DungeonName_3_1"
        },
        FeinaEvent_DungeonName_3_2 = {
          ContentES = "A través del valle espinoso – Parte Ⅱ",
          TextMapId = "FeinaEvent_DungeonName_3_2"
        },
        FeinaEvent_DungeonName_4 = {
          ContentES = "Hacia los campos fragantes",
          TextMapId = "FeinaEvent_DungeonName_4"
        },
        FeinaEvent_DungeonName_4_1 = {
          ContentES = "Hacia los campos fragantes – Parte Ⅰ",
          TextMapId = "FeinaEvent_DungeonName_4_1"
        },
        FeinaEvent_DungeonName_4_2 = {
          ContentES = "Hacia los campos fragantes – Parte Ⅱ",
          TextMapId = "FeinaEvent_DungeonName_4_2"
        },
        FeinaEvent_DungeonTask_1 = {
          ContentES = "Recolecta un total de %d Plumas del pájaro blanco",
          TextMapId = "FeinaEvent_DungeonTask_1"
        },
        FeinaEvent_Exit_Content = {
          ContentES = "Si sales ahora, perderás las recompensas. ¿Deseas salir?",
          TextMapId = "FeinaEvent_Exit_Content"
        },
        FeinaEvent_Exit_Title = {
          ContentES = "Salir",
          TextMapId = "FeinaEvent_Exit_Title"
        },
        FeinaEvent_SimpleDungeonDes_1 = {
          ContentES = "Buscar al Gran Mago",
          TextMapId = "FeinaEvent_SimpleDungeonDes_1"
        },
        FeinaEvent_SimpleDungeonDes_2 = {
          ContentES = "Resuelve el laberinto junto a {性别:Señor|Señora} Unicornio",
          TextMapId = "FeinaEvent_SimpleDungeonDes_2"
        },
        FeinaEvent_SimpleDungeonDes_3_1 = {
          ContentES = "Alcanza el otro lado del lago",
          TextMapId = "FeinaEvent_SimpleDungeonDes_3_1"
        },
        FeinaEvent_SimpleDungeonDes_3_2 = {
          ContentES = "Llega al destino con Señorita Mariposa",
          TextMapId = "FeinaEvent_SimpleDungeonDes_3_2"
        },
        FeinaEvent_SimpleDungeonDes_4_1 = {
          ContentES = "Encuentra al pequeño ruiseñor en el bosque",
          TextMapId = "FeinaEvent_SimpleDungeonDes_4_1"
        },
        FeinaEvent_SimpleDungeonDes_4_2 = {
          ContentES = "Escapa de la niebla con el pequeño ruiseñor",
          TextMapId = "FeinaEvent_SimpleDungeonDes_4_2"
        },
        FeinaEvent_Toast_1 = {
          ContentES = "Has salido de la zona protegida por magia.",
          TextMapId = "FeinaEvent_Toast_1"
        },
        FeinaEvent_Toast_2 = {
          ContentES = "Fina se perdió en la niebla, pero el pequeño ruiseñor la trajo de vuelta a la zona segura.",
          TextMapId = "FeinaEvent_Toast_2"
        },
        FollowCommunity_Discord = {
          ContentES = "Síguenos en <highlight>Discord</>",
          TextMapId = "FollowCommunity_Discord"
        },
        FollowCommunity_Douyin = {
          ContentES = "Síguenos en <highlight>Douyin</>",
          TextMapId = "FollowCommunity_Douyin"
        },
        FollowCommunity_Facebook = {
          ContentES = "Síguenos en <highlight>Facebook</>",
          TextMapId = "FollowCommunity_Facebook"
        },
        FollowCommunity_Instagram = {
          ContentES = "Síguenos en <highlight>Instagram</>",
          TextMapId = "FollowCommunity_Instagram"
        },
        FollowCommunity_JJJ = {
          ContentES = "Únete a nuestra comunidad oficial: <highlight>LunoLoft</>",
          TextMapId = "FollowCommunity_JJJ"
        },
        FollowCommunity_Lounge = {
          ContentES = "Síguenos en <highlight>Lounge</>",
          TextMapId = "FollowCommunity_Lounge"
        },
        FollowCommunity_LunoLoft = {
          ContentES = "Únete a nuestra comunidad oficial: <highlight>LunoLoft</>",
          TextMapId = "FollowCommunity_LunoLoft"
        },
        FollowCommunity_Reddit = {
          ContentES = "Síguenos en <highlight>Reddit</>",
          TextMapId = "FollowCommunity_Reddit"
        },
        FollowCommunity_TikTok = {
          ContentES = "Síguenos en <highlight>TikTok</>",
          TextMapId = "FollowCommunity_TikTok"
        },
        FollowCommunity_WeCom = {
          ContentES = "Síguenos en <highlight>WeCom</>",
          TextMapId = "FollowCommunity_WeCom"
        },
        FollowCommunity_X = {
          ContentES = "Síguenos en <highlight>X</>",
          TextMapId = "FollowCommunity_X"
        },
        FollowCommunity_Youtube = {
          ContentES = "Síguenos en <highlight>YouTube</>",
          TextMapId = "FollowCommunity_Youtube"
        },
        HuaXu_Event_Des_10200107 = {
          ContentES = "Abe cofres en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200107"
        },
        HuaXu_Event_Des_10200108 = {
          ContentES = "Completa desafíos de tiempo limitado en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200108"
        },
        HuaXu_Event_Des_10200109 = {
          ContentES = "Resuelve los mecanismos mohistas en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200109"
        },
        HuaXu_Event_Des_10200110 = {
          ContentES = "Recolecta Wishen en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200110"
        },
        HuaXu_Event_Des_10200111 = {
          ContentES = "Derrota a Bi’an sombrío",
          TextMapId = "HuaXu_Event_Des_10200111"
        },
        HuaXu_Event_Des_10200112 = {
          ContentES = "Derrota a la Guardia Frenético de Yingtian",
          TextMapId = "HuaXu_Event_Des_10200112"
        },
        HuaXu_Event_Des_10200113 = {
          ContentES = "Derrota a Zhuyin",
          TextMapId = "HuaXu_Event_Des_10200113"
        },
        HuaXu_Event_Des_10200114 = {
          ContentES = "Derrota a Umbral del Coloso",
          TextMapId = "HuaXu_Event_Des_10200114"
        },
        HuaXu_Event_Des_10200115 = {
          ContentES = "Derrota a Yuming",
          TextMapId = "HuaXu_Event_Des_10200115"
        },
        HuaXu_Event_Des_10200116 = {
          ContentES = "Desbloquea Ave espiritual onírica en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200116"
        },
        HuaXu_Event_Des_10200117 = {
          ContentES = "Recolecta peces en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200117"
        },
        HuaXu_Event_Des_10200118 = {
          ContentES = "Recolecta Esfera de exploración en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200118"
        },
        HuaXu_Event_Des_10200119 = {
          ContentES = "Recolecta Lecturas en Puerto de las Brumas",
          TextMapId = "HuaXu_Event_Des_10200119"
        },
        MAIN_UI_MODGUIDEBOOK = {
          ContentES = "Arqueta de Cuña Demoníaca",
          TextMapId = "MAIN_UI_MODGUIDEBOOK"
        },
        Mail_Content_100001 = {
          ContentES = "¡Gracias por completar la encuesta! Hemos preparado un regalo para ti~",
          TextMapId = "Mail_Content_100001"
        },
        Mail_Content_100002 = {
          ContentES = "Estimado Phoxcazador,\n\n¡Gracias por tomarte el tiempo de responder nuestra encuesta! Encontrarás tu recompensa adjunta.\nValoramos mucho cada comentario: tus opiniones nos ayudan a mejorar continuamente la calidad y la experiencia del juego.",
          TextMapId = "Mail_Content_100002"
        },
        Mail_Content_100003 = {
          ContentES = "Este es un correo electrónico de prueba que contiene el paquete adicional 130004 (Lote intermedio de Cuña Demoníaca – combate cuerpo a cuerpo).\nExpira en 1 día.",
          TextMapId = "Mail_Content_100003"
        },
        Mail_Content_101001 = {
          ContentES = "{性别:Querido Phoxcazador|Querida Phoxcazadora},\n\nTenías recompensas no reclamadas en el evento %s.\nHan sido enviadas a tu buzón. ¡No olvides reclamarlas cuanto antes!",
          TextMapId = "Mail_Content_101001"
        },
        Mail_Content_102001 = {
          ContentES = "{性别:Querido Phoxcazador|Querida Phoxcazadora},\n\nTenías recompensas no reclamadas en el evento Guía para Principiantes de los Phoxcazadores.\nHan sido enviadas a tu buzón. ¡No olvides reclamarlas cuanto antes!",
          TextMapId = "Mail_Content_102001"
        },
        Mail_Sender_101001 = {
          ContentES = "Nieve",
          TextMapId = "Mail_Sender_101001"
        },
        Mail_Sender_102001 = {
          ContentES = "Nieve",
          TextMapId = "Mail_Sender_102001"
        },
        Mail_Title_100001 = {
          ContentES = "Recompensa de encuesta",
          TextMapId = "Mail_Title_100001"
        },
        Mail_Title_100002 = {
          ContentES = "Recompensa de encuesta",
          TextMapId = "Mail_Title_100002"
        },
        Mail_Title_101001 = {
          ContentES = "Recompensas de [%s] no reclamadas enviadas",
          TextMapId = "Mail_Title_101001"
        },
        Mail_Title_102001 = {
          ContentES = "Reclama tus recompensas — [Guía para Principiantes de los Phoxcazadores]",
          TextMapId = "Mail_Title_102001"
        },
        MidTermGoal_Des_0_1 = {
          ContentES = "Completa <Highlight>3</> Cartas secretas",
          TextMapId = "MidTermGoal_Des_0_1"
        },
        MidTermGoal_Des_0_2 = {
          ContentES = "Obtén <highlight>5</>Cuñas Demoníacas",
          TextMapId = "MidTermGoal_Des_0_2"
        },
        MidTermGoal_Des_1_1 = {
          ContentES = "Completa <highlight>1</> encargo en modo coop",
          TextMapId = "MidTermGoal_Des_1_1"
        },
        MidTermGoal_Des_1_2 = {
          ContentES = "Completa <highlight>1</> encargo",
          TextMapId = "MidTermGoal_Des_1_2"
        },
        MidTermGoal_Des_1_3 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_1_3"
        },
        MidTermGoal_Des_1_4 = {
          ContentES = "Obtén <highlight>3</> Manuales de encargo: Tomo I",
          TextMapId = "MidTermGoal_Des_1_4"
        },
        MidTermGoal_Des_2_1 = {
          ContentES = "Completa <highlight>1</> Encargo [Escolta] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_2_1"
        },
        MidTermGoal_Des_2_2 = {
          ContentES = "Obtén <highlight>300</> Glóbulos carmín",
          TextMapId = "MidTermGoal_Des_2_2"
        },
        MidTermGoal_Des_2_3 = {
          ContentES = "Mejora <highlight>1</> Cuña Demoníaca de nivel Azul al Niv. 3",
          TextMapId = "MidTermGoal_Des_2_3"
        },
        MidTermGoal_Des_2_4 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_2_4"
        },
        MidTermGoal_Des_3_1 = {
          ContentES = "Completa <highlight>1</> encargo del Manual de Noctoviajero",
          TextMapId = "MidTermGoal_Des_3_1"
        },
        MidTermGoal_Des_3_2 = {
          ContentES = "Obtén <highlight>1</> Cuña Demoníaca de nivel Azul",
          TextMapId = "MidTermGoal_Des_3_2"
        },
        MidTermGoal_Des_3_3 = {
          ContentES = "Obtén <highlight>1</> Cuñas Demoníacas de nivel Púrpura",
          TextMapId = "MidTermGoal_Des_3_3"
        },
        MidTermGoal_Des_3_4 = {
          ContentES = "Derrota <highlight>1</> Ordenador",
          TextMapId = "MidTermGoal_Des_3_4"
        },
        MidTermGoal_Des_4_1 = {
          ContentES = "Completa <highlight>5</> Encargos [Precaución] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_4_1"
        },
        MidTermGoal_Des_4_2 = {
          ContentES = "Completa <highlight>1</> Encargo [Precaución] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_4_2"
        },
        MidTermGoal_Des_4_3 = {
          ContentES = "Obtén <highlight>4</> Melodías de combate II",
          TextMapId = "MidTermGoal_Des_4_3"
        },
        MidTermGoal_Des_4_4 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_4_4"
        },
        MidTermGoal_Des_5_1 = {
          ContentES = "Completa <highlight>5</> Encargos [Expedición ∞] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_5_1"
        },
        MidTermGoal_Des_5_2 = {
          ContentES = "Completa <highlight>1</> Encargo [Expedición ∞] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_5_2"
        },
        MidTermGoal_Des_5_3 = {
          ContentES = "Obtén <highlight>1</> Manual de encargo: Tomo I",
          TextMapId = "MidTermGoal_Des_5_3"
        },
        MidTermGoal_Des_5_4 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_5_4"
        },
        MidTermGoal_Des_6_1 = {
          ContentES = "Completa <highlight>5</> Encargos [Exterminio] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_6_1"
        },
        MidTermGoal_Des_6_2 = {
          ContentES = "Completa <highlight>1</> Encargo [Exterminio] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_6_2"
        },
        MidTermGoal_Des_6_3 = {
          ContentES = "Obtén <highlight>4</> Manuales de armas II",
          TextMapId = "MidTermGoal_Des_6_3"
        },
        MidTermGoal_Des_6_4 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_6_4"
        },
        MidTermGoal_Des_7_1 = {
          ContentES = "Completa <highlight>5</> Encargos [Mediación] (excluyendo Cartas secretass)",
          TextMapId = "MidTermGoal_Des_7_1"
        },
        MidTermGoal_Des_7_2 = {
          ContentES = "Completa <highlight>1</> Encargo [Mediación] (excluyendo Cartas secretas)",
          TextMapId = "MidTermGoal_Des_7_2"
        },
        MidTermGoal_Des_7_3 = {
          ContentES = "Obtén <highlight>1</> Material de ascensión de arma de nivel Azul",
          TextMapId = "MidTermGoal_Des_7_3"
        }
      }
    end
  },
  {
    MinKey = "MidTermGoal_Des_7_4",
    MaxKey = "Mon_DesDetail_7014001",
    Loader = function()
      return {
        MidTermGoal_Des_7_4 = {
          ContentES = "Usa <highlight>1</> Manual de encargo",
          TextMapId = "MidTermGoal_Des_7_4"
        },
        MidTermGoal_Des_A1_1 = {
          ContentES = "Completa <highlight>20</> encargos",
          TextMapId = "MidTermGoal_Des_A1_1"
        },
        MidTermGoal_Des_A1_10 = {
          ContentES = "Obtén <highlight>10</> armas",
          TextMapId = "MidTermGoal_Des_A1_10"
        },
        MidTermGoal_Des_A1_11 = {
          ContentES = "Obtén <highlight>5</> personajes",
          TextMapId = "MidTermGoal_Des_A1_11"
        },
        MidTermGoal_Des_A1_12 = {
          ContentES = "Obtén <highlight>10</> personajes",
          TextMapId = "MidTermGoal_Des_A1_12"
        },
        MidTermGoal_Des_A1_13 = {
          ContentES = "Hazte amigo con <highlight>5</> Geniemons",
          TextMapId = "MidTermGoal_Des_A1_13"
        },
        MidTermGoal_Des_A1_14 = {
          ContentES = "Mejora <highlight>5</> armas al Niv. 30",
          TextMapId = "MidTermGoal_Des_A1_14"
        },
        MidTermGoal_Des_A1_15 = {
          ContentES = "Asciende <highlight>5</> armas a la fase 3",
          TextMapId = "MidTermGoal_Des_A1_15"
        },
        MidTermGoal_Des_A1_16 = {
          ContentES = "Mejora <highlight>5</> personajes al Niv. 30",
          TextMapId = "MidTermGoal_Des_A1_16"
        },
        MidTermGoal_Des_A1_17 = {
          ContentES = "Asciende <highlight>5</> personajes a la fase 3",
          TextMapId = "MidTermGoal_Des_A1_17"
        },
        MidTermGoal_Des_A1_18 = {
          ContentES = "Asciende cualquier Geniemon <highlight>3</> veces",
          TextMapId = "MidTermGoal_Des_A1_18"
        },
        MidTermGoal_Des_A1_19 = {
          ContentES = "Usa <highlight>10</> Manuales de encargo",
          TextMapId = "MidTermGoal_Des_A1_19"
        },
        MidTermGoal_Des_A1_2 = {
          ContentES = "Completa <highlight>50</> encargos",
          TextMapId = "MidTermGoal_Des_A1_2"
        },
        MidTermGoal_Des_A1_20 = {
          ContentES = "Derrota <highlight>50</> Ordenadores",
          TextMapId = "MidTermGoal_Des_A1_20"
        },
        MidTermGoal_Des_A1_3 = {
          ContentES = "Completa <highlight>10</> encargos en modo coop",
          TextMapId = "MidTermGoal_Des_A1_3"
        },
        MidTermGoal_Des_A1_4 = {
          ContentES = "Completa <highlight>15</> encargos en modo coop",
          TextMapId = "MidTermGoal_Des_A1_4"
        },
        MidTermGoal_Des_A1_5 = {
          ContentES = "Gasta <highlight>100.000</> Monedas",
          TextMapId = "MidTermGoal_Des_A1_5"
        },
        MidTermGoal_Des_A1_6 = {
          ContentES = "Gasta <highlight>5000</> Glóbulos carmín",
          TextMapId = "MidTermGoal_Des_A1_6"
        },
        MidTermGoal_Des_A1_7 = {
          ContentES = "Obtén <highlight>30</> Cuñas Demoníacas",
          TextMapId = "MidTermGoal_Des_A1_7"
        },
        MidTermGoal_Des_A1_8 = {
          ContentES = "Obtén <highlight>50</> Cuñas Demoníacas",
          TextMapId = "MidTermGoal_Des_A1_8"
        },
        MidTermGoal_Des_A1_9 = {
          ContentES = "Obtén <highlight>5</> armas",
          TextMapId = "MidTermGoal_Des_A1_9"
        },
        MidTermGoal_Des_A2_1 = {
          ContentES = "Gana <Highlight>3</> combates en los Ecos nocturnos",
          TextMapId = "MidTermGoal_Des_A2_1"
        },
        MidTermGoal_Des_A2_10 = {
          ContentES = "Asciende <highlight>1</>personaje a la fase 6",
          TextMapId = "MidTermGoal_Des_A2_10"
        },
        MidTermGoal_Des_A2_11 = {
          ContentES = "Completa el encargo [Defensa ∞] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_11"
        },
        MidTermGoal_Des_A2_12 = {
          ContentES = "Completa el encargo [Defensa] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_12"
        },
        MidTermGoal_Des_A2_13 = {
          ContentES = "Completa el encargo [Excavación ∞] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_13"
        },
        MidTermGoal_Des_A2_14 = {
          ContentES = "Completa el encargo [Captura] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_14"
        },
        MidTermGoal_Des_A2_15 = {
          ContentES = "Completa el encargo [Expedición ∞] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_15"
        },
        MidTermGoal_Des_A2_16 = {
          ContentES = "Completa el encargo [Precaución ∞] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_16"
        },
        MidTermGoal_Des_A2_17 = {
          ContentES = "Completa el encargo [Mediación] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_17"
        },
        MidTermGoal_Des_A2_18 = {
          ContentES = "Completa el encargo [Reubicación] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_18"
        },
        MidTermGoal_Des_A2_19 = {
          ContentES = "Completa el encargo [Exterminio] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_19"
        },
        MidTermGoal_Des_A2_2 = {
          ContentES = "Gana <Highlight>5</> combates en los Ecos nocturnos",
          TextMapId = "MidTermGoal_Des_A2_2"
        },
        MidTermGoal_Des_A2_20 = {
          ContentES = "Completa el encargo [Escolta] un total de <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_20"
        },
        MidTermGoal_Des_A2_3 = {
          ContentES = "Completa <Highlight>10</> Cartas secretas",
          TextMapId = "MidTermGoal_Des_A2_3"
        },
        MidTermGoal_Des_A2_4 = {
          ContentES = "Completa <Highlight>30</> Cartas secretas",
          TextMapId = "MidTermGoal_Des_A2_4"
        },
        MidTermGoal_Des_A2_5 = {
          ContentES = "Hazte amigo con <highlight>10</> Geniemons",
          TextMapId = "MidTermGoal_Des_A2_5"
        },
        MidTermGoal_Des_A2_6 = {
          ContentES = "Asciende cualquier Geniemon <highlight>5</> veces",
          TextMapId = "MidTermGoal_Des_A2_6"
        },
        MidTermGoal_Des_A2_7 = {
          ContentES = "Mejora <highlight>1</> arma al Niv. 60",
          TextMapId = "MidTermGoal_Des_A2_7"
        },
        MidTermGoal_Des_A2_8 = {
          ContentES = "Asciende <highlight>1</> arma a la fase 6",
          TextMapId = "MidTermGoal_Des_A2_8"
        },
        MidTermGoal_Des_A2_9 = {
          ContentES = "Mejora <highlight>1</> personaje al Niv. 60",
          TextMapId = "MidTermGoal_Des_A2_9"
        },
        ModArchive_Name_Char_1010 = {
          ContentES = "Fénix I",
          TextMapId = "ModArchive_Name_Char_1010"
        },
        ModArchive_Name_Char_1020 = {
          ContentES = "Typhon I",
          TextMapId = "ModArchive_Name_Char_1020"
        },
        ModArchive_Name_Char_1021 = {
          ContentES = "Fauno I",
          TextMapId = "ModArchive_Name_Char_1021"
        },
        ModArchive_Name_Char_1030 = {
          ContentES = "Typhon II",
          TextMapId = "ModArchive_Name_Char_1030"
        },
        ModArchive_Name_Char_1040 = {
          ContentES = "Fénix II",
          TextMapId = "ModArchive_Name_Char_1040"
        },
        ModArchive_Name_Char_1050 = {
          ContentES = "Grifo I",
          TextMapId = "ModArchive_Name_Char_1050"
        },
        ModArchive_Name_Char_1060 = {
          ContentES = "Fénix III",
          TextMapId = "ModArchive_Name_Char_1060"
        },
        ModArchive_Name_Char_1070 = {
          ContentES = "Fauno II",
          TextMapId = "ModArchive_Name_Char_1070"
        },
        ModArchive_Name_Char_1080 = {
          ContentES = "Sirena I",
          TextMapId = "ModArchive_Name_Char_1080"
        },
        ModArchive_Name_Char_1090 = {
          ContentES = "Quetzalcoatl I",
          TextMapId = "ModArchive_Name_Char_1090"
        },
        ModArchive_Name_Char_1100 = {
          ContentES = "Quetzalcoatl II",
          TextMapId = "ModArchive_Name_Char_1100"
        },
        ModArchive_Name_Char_1110 = {
          ContentES = "Quetzalcoatl III",
          TextMapId = "ModArchive_Name_Char_1110"
        },
        ModArchive_Name_Char_1120 = {
          ContentES = "Fénix IV",
          TextMapId = "ModArchive_Name_Char_1120"
        },
        ModArchive_Name_Char_1130 = {
          ContentES = "Typhon: Lumino",
          TextMapId = "ModArchive_Name_Char_1130"
        },
        ModArchive_Name_Char_1140 = {
          ContentES = "Typhon: Anemo",
          TextMapId = "ModArchive_Name_Char_1140"
        },
        ModArchive_Name_Char_1150 = {
          ContentES = "Typhon: Electro",
          TextMapId = "ModArchive_Name_Char_1150"
        },
        ModArchive_Name_Char_1160 = {
          ContentES = "Typhon: Pyro",
          TextMapId = "ModArchive_Name_Char_1160"
        },
        ModArchive_Name_Char_1170 = {
          ContentES = "Typhon: Hydro",
          TextMapId = "ModArchive_Name_Char_1170"
        },
        ModArchive_Name_Char_1180 = {
          ContentES = "Typhon: Umbro",
          TextMapId = "ModArchive_Name_Char_1180"
        },
        ModArchive_Name_Char_1190 = {
          ContentES = "Fauno III",
          TextMapId = "ModArchive_Name_Char_1190"
        },
        ModArchive_Name_Char_1200 = {
          ContentES = "Esfinge I",
          TextMapId = "ModArchive_Name_Char_1200"
        },
        ModArchive_Name_Char_1210 = {
          ContentES = "Grifo II",
          TextMapId = "ModArchive_Name_Char_1210"
        },
        ModArchive_Name_Char_1220 = {
          ContentES = "Grifo III",
          TextMapId = "ModArchive_Name_Char_1220"
        },
        ModArchive_Name_Char_1230 = {
          ContentES = "Pactista: Lumino",
          TextMapId = "ModArchive_Name_Char_1230"
        },
        ModArchive_Name_Char_1240 = {
          ContentES = "Pactista: Anemo",
          TextMapId = "ModArchive_Name_Char_1240"
        },
        ModArchive_Name_Char_1250 = {
          ContentES = "Pactista: Electro",
          TextMapId = "ModArchive_Name_Char_1250"
        },
        ModArchive_Name_Char_1260 = {
          ContentES = "Pactista: Pyro",
          TextMapId = "ModArchive_Name_Char_1260"
        },
        ModArchive_Name_Char_1270 = {
          ContentES = "Pactista: Hydro",
          TextMapId = "ModArchive_Name_Char_1270"
        },
        ModArchive_Name_Char_1280 = {
          ContentES = "Pactista: Umbro",
          TextMapId = "ModArchive_Name_Char_1280"
        },
        ModArchive_Name_Char_1290 = {
          ContentES = "Jörmungandr",
          TextMapId = "ModArchive_Name_Char_1290"
        },
        ModArchive_Name_Char_1300 = {
          ContentES = "Helios",
          TextMapId = "ModArchive_Name_Char_1300"
        },
        ModArchive_Name_Char_1310 = {
          ContentES = "Hastur",
          TextMapId = "ModArchive_Name_Char_1310"
        },
        ModArchive_Name_Char_1320 = {
          ContentES = "Summanus",
          TextMapId = "ModArchive_Name_Char_1320"
        },
        ModArchive_Name_Char_1330 = {
          ContentES = "Ifrit",
          TextMapId = "ModArchive_Name_Char_1330"
        },
        ModArchive_Name_Char_1340 = {
          ContentES = "Bahamut",
          TextMapId = "ModArchive_Name_Char_1340"
        },
        ModArchive_Name_Char_1350 = {
          ContentES = "Árbitro",
          TextMapId = "ModArchive_Name_Char_1350"
        },
        ModArchive_Name_Char_1360 = {
          ContentES = "Fénix V",
          TextMapId = "ModArchive_Name_Char_1360"
        },
        ModArchive_Name_Char_1370 = {
          ContentES = "Sirena II",
          TextMapId = "ModArchive_Name_Char_1370"
        },
        ModArchive_Name_Char_1380 = {
          ContentES = "Esfinge II",
          TextMapId = "ModArchive_Name_Char_1380"
        },
        ModArchive_Name_Char_1390 = {
          ContentES = "Grifo: Lumino",
          TextMapId = "ModArchive_Name_Char_1390"
        },
        ModArchive_Name_Char_1400 = {
          ContentES = "Grifo: Anemo",
          TextMapId = "ModArchive_Name_Char_1400"
        },
        ModArchive_Name_Char_1410 = {
          ContentES = "Grifo: Electro",
          TextMapId = "ModArchive_Name_Char_1410"
        },
        ModArchive_Name_Char_1420 = {
          ContentES = "Grifo: Pyro",
          TextMapId = "ModArchive_Name_Char_1420"
        },
        ModArchive_Name_Char_1430 = {
          ContentES = "Grifo: Hydro",
          TextMapId = "ModArchive_Name_Char_1430"
        },
        ModArchive_Name_Char_1440 = {
          ContentES = "Grifo: Umbro",
          TextMapId = "ModArchive_Name_Char_1440"
        },
        ModArchive_Name_Char_1450 = {
          ContentES = "Typhon: Lumino",
          TextMapId = "ModArchive_Name_Char_1450"
        },
        ModArchive_Name_Char_1460 = {
          ContentES = "Typhon: Anemo",
          TextMapId = "ModArchive_Name_Char_1460"
        },
        ModArchive_Name_Char_1470 = {
          ContentES = "Typhon: Electro",
          TextMapId = "ModArchive_Name_Char_1470"
        },
        ModArchive_Name_Char_1480 = {
          ContentES = "Typhon: Pyro",
          TextMapId = "ModArchive_Name_Char_1480"
        },
        ModArchive_Name_Char_1490 = {
          ContentES = "Typhon: Hydro",
          TextMapId = "ModArchive_Name_Char_1490"
        },
        ModArchive_Name_Char_1500 = {
          ContentES = "Typhon: Umbro",
          TextMapId = "ModArchive_Name_Char_1500"
        },
        ModArchive_Name_Char_1510 = {
          ContentES = "Pactista: Lumino",
          TextMapId = "ModArchive_Name_Char_1510"
        },
        ModArchive_Name_Char_1520 = {
          ContentES = "Pactista: Anemo",
          TextMapId = "ModArchive_Name_Char_1520"
        },
        ModArchive_Name_Char_1530 = {
          ContentES = "Pactista: Electro",
          TextMapId = "ModArchive_Name_Char_1530"
        },
        ModArchive_Name_Char_1540 = {
          ContentES = "Pactista: Pyro",
          TextMapId = "ModArchive_Name_Char_1540"
        },
        ModArchive_Name_Char_1550 = {
          ContentES = "Pactista: Hydro",
          TextMapId = "ModArchive_Name_Char_1550"
        },
        ModArchive_Name_Char_1560 = {
          ContentES = "Pactista: Umbro",
          TextMapId = "ModArchive_Name_Char_1560"
        },
        ModArchive_Name_Char_1570 = {
          ContentES = "Jörmungandr",
          TextMapId = "ModArchive_Name_Char_1570"
        },
        ModArchive_Name_Char_1580 = {
          ContentES = "Helios",
          TextMapId = "ModArchive_Name_Char_1580"
        },
        ModArchive_Name_Char_1590 = {
          ContentES = "Hastur",
          TextMapId = "ModArchive_Name_Char_1590"
        },
        ModArchive_Name_Char_1600 = {
          ContentES = "Summanus",
          TextMapId = "ModArchive_Name_Char_1600"
        },
        ModArchive_Name_Char_1610 = {
          ContentES = "Ifrit",
          TextMapId = "ModArchive_Name_Char_1610"
        },
        ModArchive_Name_Char_1620 = {
          ContentES = "Bahamut",
          TextMapId = "ModArchive_Name_Char_1620"
        },
        ModArchive_Name_Char_1630 = {
          ContentES = "Árbitro",
          TextMapId = "ModArchive_Name_Char_1630"
        },
        ModArchive_Name_Melee_2010 = {
          ContentES = "Cerbero I",
          TextMapId = "ModArchive_Name_Melee_2010"
        },
        ModArchive_Name_Melee_2020 = {
          ContentES = "Cerbero II",
          TextMapId = "ModArchive_Name_Melee_2020"
        },
        ModArchive_Name_Melee_2021 = {
          ContentES = "Cerbero III",
          TextMapId = "ModArchive_Name_Melee_2021"
        },
        ModArchive_Name_Melee_2030 = {
          ContentES = "Fenrir I",
          TextMapId = "ModArchive_Name_Melee_2030"
        },
        ModArchive_Name_Melee_2031 = {
          ContentES = "Fenrir II",
          TextMapId = "ModArchive_Name_Melee_2031"
        },
        ModArchive_Name_Melee_2040 = {
          ContentES = "Cerbero IV",
          TextMapId = "ModArchive_Name_Melee_2040"
        },
        ModArchive_Name_Melee_2050 = {
          ContentES = "Fenrir III",
          TextMapId = "ModArchive_Name_Melee_2050"
        },
        ModArchive_Name_Melee_2060 = {
          ContentES = "Fenrir IV",
          TextMapId = "ModArchive_Name_Melee_2060"
        },
        ModArchive_Name_Melee_2070 = {
          ContentES = "Fenrir V",
          TextMapId = "ModArchive_Name_Melee_2070"
        },
        ModArchive_Name_Melee_2080 = {
          ContentES = "Fenrir VI",
          TextMapId = "ModArchive_Name_Melee_2080"
        },
        ModArchive_Name_Melee_2090 = {
          ContentES = "Fenrir VII",
          TextMapId = "ModArchive_Name_Melee_2090"
        },
        ModArchive_Name_Melee_2100 = {
          ContentES = "Fenrir VIII",
          TextMapId = "ModArchive_Name_Melee_2100"
        },
        ModArchive_Name_Melee_2110 = {
          ContentES = "Fenrir IX",
          TextMapId = "ModArchive_Name_Melee_2110"
        },
        ModArchive_Name_Melee_2120 = {
          ContentES = "Fenrir X",
          TextMapId = "ModArchive_Name_Melee_2120"
        },
        ModArchive_Name_Melee_2130 = {
          ContentES = "Fenrir: Arma de Asta",
          TextMapId = "ModArchive_Name_Melee_2130"
        },
        ModArchive_Name_Melee_2140 = {
          ContentES = "Fenrir: Espadón",
          TextMapId = "ModArchive_Name_Melee_2140"
        },
        ModArchive_Name_Melee_2150 = {
          ContentES = "Fenrir: Hojas Dobles",
          TextMapId = "ModArchive_Name_Melee_2150"
        },
        ModArchive_Name_Melee_2160 = {
          ContentES = "Fenrir: Katana",
          TextMapId = "ModArchive_Name_Melee_2160"
        },
        ModArchive_Name_Melee_2161 = {
          ContentES = "Fenrir: Espada",
          TextMapId = "ModArchive_Name_Melee_2161"
        },
        ModArchive_Name_Melee_2170 = {
          ContentES = "Cerbero V",
          TextMapId = "ModArchive_Name_Melee_2170"
        },
        ModArchive_Name_Melee_2180 = {
          ContentES = "Cerbero VI",
          TextMapId = "ModArchive_Name_Melee_2180"
        },
        ModArchive_Name_Melee_2190 = {
          ContentES = "Cerbero VII",
          TextMapId = "ModArchive_Name_Melee_2190"
        },
        ModArchive_Name_Range_3010 = {
          ContentES = "Lilith I",
          TextMapId = "ModArchive_Name_Range_3010"
        },
        ModArchive_Name_Range_3011 = {
          ContentES = "Lilith II",
          TextMapId = "ModArchive_Name_Range_3011"
        },
        ModArchive_Name_Range_3020 = {
          ContentES = "Lilith III",
          TextMapId = "ModArchive_Name_Range_3020"
        },
        ModArchive_Name_Range_3030 = {
          ContentES = "Fafnir I",
          TextMapId = "ModArchive_Name_Range_3030"
        },
        ModArchive_Name_Range_3040 = {
          ContentES = "Fafnir II",
          TextMapId = "ModArchive_Name_Range_3040"
        },
        ModArchive_Name_Range_3050 = {
          ContentES = "Lilith IV",
          TextMapId = "ModArchive_Name_Range_3050"
        },
        ModArchive_Name_Range_3060 = {
          ContentES = "Lilith V",
          TextMapId = "ModArchive_Name_Range_3060"
        },
        ModArchive_Name_Range_3070 = {
          ContentES = "Fafnir III",
          TextMapId = "ModArchive_Name_Range_3070"
        },
        ModArchive_Name_Range_3080 = {
          ContentES = "Lilith VI",
          TextMapId = "ModArchive_Name_Range_3080"
        },
        ModArchive_Name_Range_3090 = {
          ContentES = "Fafnir IV",
          TextMapId = "ModArchive_Name_Range_3090"
        },
        ModArchive_Name_Range_3100 = {
          ContentES = "Fafnir V",
          TextMapId = "ModArchive_Name_Range_3100"
        },
        ModArchive_Name_Range_3110 = {
          ContentES = "Fafnir VI",
          TextMapId = "ModArchive_Name_Range_3110"
        },
        ModArchive_Name_Range_3120 = {
          ContentES = "Fafnir VII",
          TextMapId = "ModArchive_Name_Range_3120"
        },
        ModArchive_Name_Range_3130 = {
          ContentES = "Lilith VII",
          TextMapId = "ModArchive_Name_Range_3130"
        },
        ModArchive_Name_Range_3140 = {
          ContentES = "Lilith VIII",
          TextMapId = "ModArchive_Name_Range_3140"
        },
        ModArchive_Name_Range_3150 = {
          ContentES = "Lilith IX",
          TextMapId = "ModArchive_Name_Range_3150"
        },
        ModArchive_Name_UMelee_4010 = {
          ContentES = "Cerbero corrupto I",
          TextMapId = "ModArchive_Name_UMelee_4010"
        },
        ModArchive_Name_UMelee_4020 = {
          ContentES = "Cerbero corrupto II",
          TextMapId = "ModArchive_Name_UMelee_4020"
        },
        ModArchive_Name_UMelee_4030 = {
          ContentES = "Cerbero corrupto III",
          TextMapId = "ModArchive_Name_UMelee_4030"
        },
        ModArchive_Name_UMelee_4040 = {
          ContentES = "Cerbero corrupto IV",
          TextMapId = "ModArchive_Name_UMelee_4040"
        },
        ModArchive_Name_UMelee_4050 = {
          ContentES = "Cerbero corrupto V",
          TextMapId = "ModArchive_Name_UMelee_4050"
        },
        ModArchive_Name_UMelee_4060 = {
          ContentES = "Cerbero corrupto VI",
          TextMapId = "ModArchive_Name_UMelee_4060"
        },
        ModArchive_Name_UMelee_4070 = {
          ContentES = "Cerbero corrupto VII",
          TextMapId = "ModArchive_Name_UMelee_4070"
        },
        ModArchive_Name_UMelee_4080 = {
          ContentES = "Cerbero corrupto VIII",
          TextMapId = "ModArchive_Name_UMelee_4080"
        },
        ModArchive_Name_UMelee_4090 = {
          ContentES = "Cerbero corrupto IX",
          TextMapId = "ModArchive_Name_UMelee_4090"
        },
        ModArchive_Name_UMelee_4100 = {
          ContentES = "Cerbero corrupto X",
          TextMapId = "ModArchive_Name_UMelee_4100"
        },
        ModArchive_Name_URange_5010 = {
          ContentES = "Lilith corrupta I",
          TextMapId = "ModArchive_Name_URange_5010"
        },
        ModArchive_Name_URange_5020 = {
          ContentES = "Lilith corrupta II",
          TextMapId = "ModArchive_Name_URange_5020"
        },
        ModArchive_Name_URange_5030 = {
          ContentES = "Lilith corrupta III",
          TextMapId = "ModArchive_Name_URange_5030"
        },
        ModArchive_Name_URange_5040 = {
          ContentES = "Lilith corrupta IV",
          TextMapId = "ModArchive_Name_URange_5040"
        },
        ModArchive_Name_URange_5050 = {
          ContentES = "Lilith corrupta V",
          TextMapId = "ModArchive_Name_URange_5050"
        },
        ModArchive_Name_URange_5060 = {
          ContentES = "Lilith corrupta VI",
          TextMapId = "ModArchive_Name_URange_5060"
        },
        ModArchive_Name_URange_5070 = {
          ContentES = "Lilith corrupta VII",
          TextMapId = "ModArchive_Name_URange_5070"
        },
        ModArchive_Name_URange_5080 = {
          ContentES = "Lilith corrupta VIII",
          TextMapId = "ModArchive_Name_URange_5080"
        },
        ModArchive_Name_URange_5090 = {
          ContentES = "Lilith corrupta IX",
          TextMapId = "ModArchive_Name_URange_5090"
        },
        ModArchive_Name_URange_5100 = {
          ContentES = "Lilith corrupta X",
          TextMapId = "ModArchive_Name_URange_5100"
        },
        Mon_DesDetail_10001001 = {
          ContentES = "En Huaxu, algunas personas del Clan Dragón han sellado un pacto con los Nueve Capítulos de Dafeng, convirtiéndose en Guardias de Yingtian, protectores del reino. Reforzados por el Mandato del Cielo, castigan a los malvados en su nombre. Para muchos son héroes imponentes; para otros, una pesadilla viva.\nComo ocurrió con los Bi’an Sable, varios Guardias sucumbieron a la locura bajo la influencia del Flagelo de Zhuyin, y sus ataques ahora ponen en peligro a la población.",
          TextMapId = "Mon_DesDetail_10001001"
        },
        Mon_DesDetail_10002001 = {
          ContentES = "Los verdugos superiores de Huaxu. En Huaxu, algunas personas del Clan Dragón han sellado un pacto con los Nueve Capítulos de Dafeng, convirtiéndose en Magistrados de Yingtian. Reforzados por el Mandato del Cielo, castigan a los malvados en su nombre. Para muchos son héroes imponentes; para otros, una pesadilla viva.",
          TextMapId = "Mon_DesDetail_10002001"
        },
        Mon_DesDetail_10003001 = {
          ContentES = "En otro tiempo fueron guardianes de Huaxu, pero ahora deambulan fuera de control, similares a los Bi’an, aunque cubiertos de negro de la cabeza a la cola. Aparecieron junto al Flagelo de Zhuyin, con la mente velada y violenta, convirtiéndose en una amenaza constante para la vida cotidiana de Huaxu.\nAlgunos eruditos sospechan que, en realidad, podrían ser Filthoids.",
          TextMapId = "Mon_DesDetail_10003001"
        },
        Mon_DesDetail_10004001 = {
          ContentES = "Guardianes de Huaxu y ejecutores de la voluntad de los Nueve Capítulos de Dafeng. Surgen de los vientos cortantes para castigar a quienes quebrantan los edictos sagrados de los Nueve Capítulos de Dafeng.\nAlgunos eruditos sospechan que, en realidad, podrían ser Filthoids.",
          TextMapId = "Mon_DesDetail_10004001"
        },
        Mon_DesDetail_10005001 = {
          ContentES = "En Huaxu, algunas personas del Clan Dragón han sellado un pacto con los Nueve Capítulos de Dafeng, convirtiéndose en Guardias de Yingtian, protectores del reino. Reforzados por el Mandato del Cielo, castigan a los malvados en su nombre. Para muchos son héroes imponentes; para otros, una pesadilla viva.\nComo ocurrió con los Bi’an Sable, varios Guardias sucumbieron a la locura bajo la influencia del Flagelo de Zhuyin, y sus ataques ahora ponen en peligro a la población.",
          TextMapId = "Mon_DesDetail_10005001"
        },
        Mon_DesDetail_115 = {
          ContentES = "En su carácter de soldados de élite, los Halcones Patrullas dirigen a las tropas regulares y transmiten las señales de alarma cuando detectan intrusos aproximándose.",
          TextMapId = "Mon_DesDetail_115"
        },
        Mon_DesDetail_6001001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por lanzarse a toda velocidad contra su objetivo y destrozarlo en cuestión de segundos. Sus extremidades especiales le permiten aferrarse sin esfuerzo a muros y techos. Sus fauces y garras implacables, fueron consideradas una amenaza significativa para los viajeros. Si el aullido de un lobo da tiempo para poder escapar, el rugido ronco de un Filthoid solo es el aviso de una muerte anunciada para quienes van desarmados.",
          TextMapId = "Mon_DesDetail_6001001"
        },
        Mon_DesDetail_6002001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por la supresión a distancia. En lugar de munición convencional, disparan fragmentos de materia inorgánica dura desde sus brazos con forma de arma. Nadie comprende del todo el origen de su mutación, pero su adaptación a la era contemporánea es evidente.",
          TextMapId = "Mon_DesDetail_6002001"
        },
        Mon_DesDetail_6003001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por el apoyo a distancia. Suelen flotar en el aire y, Con sus tentáculos delgados y flexibles, han hecho que más de uno los considere, equivocadamente, “adorables”. Algunos audaces aventureros culinarios incluso intentaron convertirlos en manjares… normalmente pagando un alto precio por tal imprudencia.",
          TextMapId = "Mon_DesDetail_6003001"
        },
        Mon_DesDetail_6004001 = {
          ContentES = "Uno de los Filthoids grandes más comunes. Sobresalen por destruir objetivos usando la fuerza bruta de su propio cuerpo. Aunque aparentan ser lentos y adorables, esconden un poder destructivo capaz de perforar las armaduras de última generación.",
          TextMapId = "Mon_DesDetail_6004001"
        },
        Mon_DesDetail_6005001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por perturbar a distancia. Estas criaturas se camuflan con capas rígidas, semejantes a pétalos endurecidos, y utilizan secreciones pegajosas y corrosivas. Acechan desde la distancia, tejiendo una pesadilla persistente de la que sus víctimas no pueden librarse ni escapar.",
          TextMapId = "Mon_DesDetail_6005001"
        },
        Mon_DesDetail_6006001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por recolectar objetos. A menudo se les confunde con los Filthoids Flotantes mutados. Estas criaturas deambulan libremente, engullendo todo lo que desean. Nadie sabe si son esclavos de su hambre fantasmal e insaciable, o si solo reproducen la gula inherente en toda criatura viva.",
          TextMapId = "Mon_DesDetail_6006001"
        },
        Mon_DesDetail_6007001 = {
          ContentES = "Uno de los Filthoids más comunes. Sobresalen por contener enemigos. Es posible que en el pasado fueran unos titanes del pensamiento, capaces de plasmar ideas brillantes sobre la página… no de convertir sus “inspiraciones” en llamas reales.",
          TextMapId = "Mon_DesDetail_6007001"
        },
        Mon_DesDetail_6011001 = {
          ContentES = "Uno de los Filthoids mutantes más comunes. Sobresalen por lanzarse a toda velocidad contra su objetivo y destrozarlo en cuestión de segundos. Sus extremidades especiales le permiten aferrarse sin esfuerzo a muros y techos. Sus fauces y garras implacables, fueron consideradas una amenaza significativa para los viajeros. Si el aullido de un lobo da tiempo para poder escapar, el rugido ronco de un Filthoid solo es el aviso de una muerte anunciada para quienes van desarmados.",
          TextMapId = "Mon_DesDetail_6011001"
        },
        Mon_DesDetail_6012001 = {
          ContentES = "Uno de los Filthoids mutantes más comunes. Sobresalen por la supresión a distancia. En lugar de munición convencional, disparan fragmentos de materia inorgánica dura desde sus brazos con forma de arma. Nadie comprende del todo el origen de su mutación, pero su adaptación a la era contemporánea es evidente.",
          TextMapId = "Mon_DesDetail_6012001"
        },
        Mon_DesDetail_6013001 = {
          ContentES = "Uno de los Filthoids mutantes más comunes. Sobresalen por la supresión a distancia. Suelen flotar en el aire y, Con sus tentáculos delgados y flexibles, han hecho que más de uno los considere, equivocadamente, “adorables”. Algunos audaces aventureros culinarios incluso intentaron convertirlos en manjares… normalmente pagando un alto precio por tal imprudencia.",
          TextMapId = "Mon_DesDetail_6013001"
        },
        Mon_DesDetail_6014001 = {
          ContentES = "Los Filthoids grandes mutados más comunes. Sobresalen por destruir objetivos usando la fuerza bruta de su propio cuerpo. Aunque aparentan ser lentos y adorables, esconden un poder destructivo capaz de perforar las armaduras de última generación.",
          TextMapId = "Mon_DesDetail_6014001"
        },
        Mon_DesDetail_6015001 = {
          ContentES = "Es un tipo de Filthoid Quemaalmas, mutado por el aire impregnado de Incienso en Huaxu. Son especialistas en estorbar y contener. A veces, los transeúntes los confunden con unas inocentes plantas aromáticas. Algunas criaturas tocadas por el Flagelo de Zhuyin, lograron escapar de los designios de los Nueve Capítulos de Dafeng y se transformaron en calamidades peligrosas.",
          TextMapId = "Mon_DesDetail_6015001"
        },
        Mon_DesDetail_6016001 = {
          ContentES = "Es un tipo de Filthoid Guerrillero, mutado por el aire impregnado de Incienso en Huaxu. Sobresalen por la supresión a distancia. De las grietas en sus antebrazos osificados brotan ramas delgadas rematadas por pequeños capullos. Esto les da a sus proyectiles un inquietante perfume. \nAlgunas criaturas tocadas por el Flagelo de Zhuyin, lograron escapar de los designios de los Nueve Capítulos de Dafeng y se transformaron en calamidades peligrosas.",
          TextMapId = "Mon_DesDetail_6016001"
        },
        Mon_DesDetail_6017001 = {
          ContentES = "Es un tipo de Filthoid Veloz, mutado por el aire impregnado de Incienso en Huaxu. Su cabeza se ha transformado en una enorme estructura semejante a un estigma, capaz de engullir y desgarrar presas enteras. Algunas criaturas tocadas por el Flagelo de Zhuyin, lograron escapar de los designios de los Nueve Capítulos de Dafeng y se transformaron en calamidades peligrosas. Sus extremidades especiales le permiten aferrarse sin esfuerzo a muros y techos. Sus fauces y garras implacables, fueron consideradas una amenaza significativa para los viajeros.",
          TextMapId = "Mon_DesDetail_6017001"
        },
        Mon_DesDetail_7001001 = {
          ContentES = "Los francotiradores estándar de las Legiones de Hyperborea. Sobresalen por la supresión a distancia. Brindan apoyo de fuego a distancia a sus alianzas. Las francotiradoras constituyen la mayoría de la Legión. Brindan apoyo de fuego a distancia con una resistencia, vigilancia y estabilidad notables. Sus camuflajes a medida no solo les permiten ocultarse con eficacia, también son distintivo de su destreza extraordinaria.",
          TextMapId = "Mon_DesDetail_7001001"
        },
        Mon_DesDetail_7001005 = {
          ContentES = "El objetivo de este encargo.\nPueden entrar en el estado de Sigilo, lo que dificulta que los enemigos los detecten. Cuando sus PV son bajos, pueden invocar señuelos para confundir a sus oponentes.",
          TextMapId = "Mon_DesDetail_7001005"
        },
        Mon_DesDetail_7002001 = {
          ContentES = "Las tropas de asalto estándar de las Legiones de Hyperborea. Sobresalen por el combate cuerpo a cuerpo. Reconocibles por los grabados distintivos en su coraza, empuñan sus imponentes espadas con destreza, destruyendo todo lo que se interpone en su camino.",
          TextMapId = "Mon_DesDetail_7002001"
        },
        Mon_DesDetail_7002005 = {
          ContentES = [[
El objetivo de este encargo.
Pueden utilizar robots como ayuda durante el combate.]],
          TextMapId = "Mon_DesDetail_7002005"
        },
        Mon_DesDetail_7003001 = {
          ContentES = "Las tropas exploradoras estándar de las Legiones de Hyperborea. Competentes en distintos rangos de combate, portan armaduras pesadas fabricadas a medida ofrecen una protección formidable y un soporte vital en entornos hostiles. Se rumorea que estas tropas aparecen incluso en las zonas más remotas del Imperio.",
          TextMapId = "Mon_DesDetail_7003001"
        },
        Mon_DesDetail_7003005 = {
          ContentES = "El objetivo de este encargo.\nEl objetivo de este encargo. Pueden dejar minas terrestres para entorpecer a los enemigos mientras huyen de la persecución.",
          TextMapId = "Mon_DesDetail_7003005"
        },
        Mon_DesDetail_7004001 = {
          ContentES = "Las tropas de asalto estándar de las Legiones de Hyperborea, guardianes en la vanguardia. Sobresalen por el reconocimiento cercano y en la defensa contra ataques enemigos. Sus pesados escudos, un emblema que ha perdurado por siglos, es símbolo de su rol en la vanguardia.",
          TextMapId = "Mon_DesDetail_7004001"
        },
        Mon_DesDetail_7006001 = {
          ContentES = "Los dispositivos de apoyo estándar de las Legiones de Hyperborea. Son capaces de flotar alrededor del campo de batalla y curar a los soldados heridos. Su diseño modular les permite operar de forma lógica y autónoma. Su uso generalizado confirma uno de los principios fundamentales de la Academia de Alquimia: incluso los procesos repetitivos y tediosos pueden dar lugar a unos milagros extraordinarios.",
          TextMapId = "Mon_DesDetail_7006001"
        },
        Mon_DesDetail_7007001 = {
          ContentES = "Los dispositivos de apoyo estándar de las Legiones de Hyperborea. Son capaces de detener y restringir brevemente a los enemigos. Su diseño modular les permite operar de forma lógica y autónoma. Su uso generalizado confirma uno de los principios fundamentales de la Academia de Alquimia: incluso los procesos repetitivos y tediosos pueden dar lugar a unos milagros extraordinarios.",
          TextMapId = "Mon_DesDetail_7007001"
        },
        Mon_DesDetail_7007002 = {
          ContentES = "Estos dispositivos pueden detener y suprimir a los enemigos por un momento. Su diseño modular les permite operar de forma lógica y autónoma. Su uso generalizado confirma uno de los principios fundamentales de la Academia de Alquimia: incluso los procesos repetitivos y tediosos pueden dar lugar a unos milagros extraordinarios.",
          TextMapId = "Mon_DesDetail_7007002"
        },
        Mon_DesDetail_7008001 = {
          ContentES = "Los comandantes estándar de las Legiones de Hyperborea. Diestros tanto en el combate individual como en el liderazgo estratégico. Han demostrado un talento excepcional en batalla, investigación o mando. Sus armas hechas a medida, versátiles en varios rangos, reflejan su habilidad y su posición. Aunque sus habilidades varían, su lealtad al Imperio se mantiene inquebrantable.",
          TextMapId = "Mon_DesDetail_7008001"
        },
        Mon_DesDetail_7009001 = {
          ContentES = "Los soldados mejorados estándar de las Legiones de Hyperborea. Sobresalen por romper las líneas enemigas con su eficiencia despiadada. Visten el armamento más avanzado del Imperio, otorgado por la gracia inagotable del Emperador, con el cual penetran las defensas más resistentes. No hay campo de batalla demasiado adverso ni sacrificio demasiado grande: siempre se abrirán paso hacia otra victoria por la gloria del Imperio.",
          TextMapId = "Mon_DesDetail_7009001"
        },
        Mon_DesDetail_7010001 = {
          ContentES = "Los Alquimistas Spathatoi se despliegan con las Legiones de Hyperborea. Aparte de su usar su magia en la batalla, ayudan a mantener el armamento, atender a los heridos y forjar las armas más mortíferas. Son el aceite del engranaje de la máquina que es la conquista imperial, asegurando que su motor jamás se detenga.",
          TextMapId = "Mon_DesDetail_7010001"
        },
        Mon_DesDetail_7011001 = {
          ContentES = "Los francotiradores especializados de las Legiones de Hyperborea. Sobresalen por la supresión a distancia. Brindan apoyo de fuego a distancia a sus alianzas. Las francotiradoras constituyen la mayoría de la Legión. Brindan apoyo de fuego a distancia con una resistencia, vigilancia y estabilidad notables. Sus camuflajes a medida no solo les permiten ocultarse con eficacia, también son distintivo de su destreza extraordinaria.",
          TextMapId = "Mon_DesDetail_7011001"
        },
        Mon_DesDetail_7012001 = {
          ContentES = "Las tropas de asalto especializadas de las Legiones de Hyperborea. Sobresalen por el combate cuerpo a cuerpo. Reconocibles por los grabados distintivos en su coraza, empuñan sus imponentes espadas con destreza, destruyendo todo lo que se interpone en su camino.",
          TextMapId = "Mon_DesDetail_7012001"
        },
        Mon_DesDetail_7013001 = {
          ContentES = "Las tropas exploradoras especializadas de las Legiones de Hyperborea. Competentes en distintos rangos de combate, portan armaduras pesadas fabricadas a medida ofrecen una protección formidable y un soporte vital en entornos hostiles. Se rumorea que estas tropas aparecen incluso en las zonas más remotas del Imperio.",
          TextMapId = "Mon_DesDetail_7013001"
        },
        Mon_DesDetail_7014001 = {
          ContentES = "Las tropas de asalto especializadas de las Legiones de Hyperborea, guardianes en la vanguardia. Sobresalen por el reconocimiento cercano y en la defensa contra ataques enemigos. Sobresalen por el reconocimiento cercano y en la defensa contra ataques enemigos. Sus pesados escudos, un emblema que ha perdurado por siglos, es símbolo de su rol en la vanguardia.",
          TextMapId = "Mon_DesDetail_7014001"
        }
      }
    end
  },
  {
    MinKey = "Mon_DesDetail_7015001",
    MaxKey = "Mon_Name_6004021",
    Loader = function()
      return {
        Mon_DesDetail_7015001 = {
          ContentES = "Son dispositivos de apoyo estándar diseñados para contener a los enemigos Son una variante mejorada de los Drones magnéticos, basados en el Filthoid Quemaalmas, que tiene un diseño modular que les permite operar de forma lógica y autónoma. Su uso generalizado confirma uno de los principios fundamentales de la Academia de Alquimia: incluso los procesos repetitivos y tediosos pueden dar lugar a unos milagros extraordinarios.",
          TextMapId = "Mon_DesDetail_7015001"
        },
        Mon_DesDetail_7016001 = {
          ContentES = "La aeronave estándar de las Legiones de Hyperborea. Los avances pioneros en ingeniería militar dieron paso a una nueva era de armamento no convencional. Diseñado por la Aeolipile, el Ojo de la Legión simboliza la determinación del Imperio por dominar los cielos.",
          TextMapId = "Mon_DesDetail_7016001"
        },
        Mon_DesDetail_8001001 = {
          ContentES = "Los artilleros estándar de la Iglesia Elisiana. Sobresalen por la supresión a distancia. Sobresalen por la supresión a distancia, y prefieren enfrentarse sus enemigos, de forma ordenada y precisa, antes que ocultarse en las sombras para disparar. Forman fila, abriendo fuego bajo las órdenes de su líder, entregando su propia carne y sangre a Dios mientras ejecutan Su justicia.",
          TextMapId = "Mon_DesDetail_8001001"
        },
        Mon_DesDetail_8002001 = {
          ContentES = "Las tropas de asalto estándar de la Iglesia Elisiana. Sobresalen por el combate cuerpo a cuerpo, empuñan unas espadas de plata para desatar la ira divina a corta distancia. Visten cotas de malla bendita, cuya protección parece reforzada por la fuerza misma de su fe. Algunos alquimistas intentaron descifrar el misterio de su resistencia extraordinaria… pero descubrieron que estaban hechos de hierro común.",
          TextMapId = "Mon_DesDetail_8002001"
        },
        Mon_DesDetail_8003001 = {
          ContentES = "Los sacerdotes estándar de la Iglesia Elisiana. Sobresalen por el apoyo a distancia. Los versos que recitan sin cesar envuelven el campo de batalla cuando resuenan a través de sus máscaras, inspirando a los fieles de Elysium. Se dice que hasta un mudo podría ser escuchado por Dios al usar estas máscaras, siempre que su fe sea lo suficientemente férrea.",
          TextMapId = "Mon_DesDetail_8003001"
        },
        Mon_DesDetail_8500001 = {
          ContentES = "La Comandante de la 13.ª Legión del Imperio. Una fuerza imponente, movida por motivos desconocidos y una determinación implacable por Berenica.",
          TextMapId = "Mon_DesDetail_8500001"
        },
        Mon_DesDetail_8501001 = {
          ContentES = "Cuenta con una resistencia extraordinaria, y ha sobrevivido a incontables batallas y heridas letales. Lejos de ser doblegado, cada cicatriz y cada corte recibido solo han fortalecido su poder, y lo han vuelto una máquina de matar.",
          TextMapId = "Mon_DesDetail_8501001"
        },
        Mon_DesDetail_8502001 = {
          ContentES = "La semilla que cayó en tierra helada y echó raíces en la fría oscuridad de la noche.",
          TextMapId = "Mon_DesDetail_8502001"
        },
        Mon_DesDetail_8503001 = {
          ContentES = "Un Filthoid colosal que acecha en las profundidades del Foso de Glevum, y cuyo cuerpo mecánico solo se mueve para excavar y devorar cualquier cosa que brille.",
          TextMapId = "Mon_DesDetail_8503001"
        },
        Mon_DesDetail_8505001 = {
          ContentES = "La Alcaidesa de la Prisión Militar Imperial, que agita sus cadenas para castigar el mal y que enciende sus llamas para defender lo que es justo.",
          TextMapId = "Mon_DesDetail_8505001"
        },
        Mon_DesDetail_8509001 = {
          ContentES = "El paño escarlata ondea mientras la brisa helada entona un lamento del Yermo Nevado.",
          TextMapId = "Mon_DesDetail_8509001"
        },
        Mon_DesDetail_8510001 = {
          ContentES = "Ley nacida del corazón. Las arenas tapan el cielo con su manto de oscuridad.",
          TextMapId = "Mon_DesDetail_8510001"
        },
        Mon_DesDetail_8511001 = {
          ContentES = "Ley guiada por la razón. Una luz fría que atraviesa los incontables reinos.",
          TextMapId = "Mon_DesDetail_8511001"
        },
        Mon_DesDetail_8512001 = {
          ContentES = "Es la Bestia del Campo de Nieve, que arrasa con los hogares de los niños y acaba con los sueños de las hadas.",
          TextMapId = "Mon_DesDetail_8512001"
        },
        Mon_DesDetail_8513001 = {
          ContentES = "Para implorar por la misericordia divina, los Heraldo Divinos graban palabras sagradas en su piel. A la luz de la fe, el sufrimiento se vuelve gracia.",
          TextMapId = "Mon_DesDetail_8513001"
        },
        Mon_DesDetail_8514001 = {
          ContentES = "Para algunos Heraldos Divinos, predicar la verdad y purificar la fe es un llamado sagrado. Incluso el fuego y el plomo, cuando se empuñan con devoción, se convierten en extensiones de la gracia divina.",
          TextMapId = "Mon_DesDetail_8514001"
        },
        Mon_DesDetail_8515001 = {
          ContentES = "El Devorador no es un solo Filthoid, sino una amalgama grotesca: una masa retorcida de carne fusionada que consume animales, plantas, Filthoids e incluso humanos. Con fuerza bruta, une todo esto en un cuerpo deformado y siempre creciente, y deambula hambriento por la próxima presa que se le unirá.",
          TextMapId = "Mon_DesDetail_8515001"
        },
        Mon_DesDetail_9001001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"Enjambre Salvaje\". Sobresalen por el combate cuerpo a cuerpo. Gente común de Charon convertida en guerreros; sus técnicas carecen de refinamiento, pero su furia, templada en la sangre de los suyos, es el filo que rompe cadenas y deshace hasta el golpe más contundente del enemigo.",
          TextMapId = "Mon_DesDetail_9001001"
        },
        Mon_DesDetail_9002001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"Enjambre Salvaje\". Sobresalen por la supresión a distancia. Son capaces de suprimir a larga distancia y hostigar. Quienes se atrevan a cruzar su territorio no solo se enfrentarán a unas miradas frías, sino a una lluvia de flechas, golpeando allí donde la vigilancia flaquea.",
          TextMapId = "Mon_DesDetail_9002001"
        },
        Mon_DesDetail_9003001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"El Cuervo\". Son expertos en alterar el entorno y en tender trampas. Para estos \"Jugueteros\", la vida es un juego, una carrera letal contra la destrucción, sin importar que sus vidas estén en juego. Transforman el campo de batalla en su “patio de juegos”, sembrando trampas por doquier y observando a los combatientes, de los cuales solo unos pocos pueden escapar. Suelen colaborar con los Engañadores y los Bombadictos en sus ofensivas.",
          TextMapId = "Mon_DesDetail_9003001"
        },
        Mon_DesDetail_9005001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"El Cuervo\". Altamente diestros en manipular explosivos. Estos Bombadictos, obsesionados con la perfección, ajustan cada bomba hasta el instante previo a su detonación. Esa compulsión explica por qué sus artefactos suelen ser más vulnerables justo antes de su violenta explosión. Suelen colaborar con los \"Engañadores\" y los \"Jugueteros\" en sus ofensivas.",
          TextMapId = "Mon_DesDetail_9005001"
        },
        Mon_DesDetail_9006001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"El Cuervo\". Son expertos en desordenar formaciones y sembrar caos en el campo de batalla. Los llamados \"Engañadores\" son maestros de la manipulación y el engaño. Explotan la desinformación para enfrentar a los enemigos entre sí, alimentando el caos con cada movimiento. Se deleitan con el caos que causan, con una sonrisa burlona que a menudo les cuesta la vida… y la de otros. Suelen colaborar con los \"Bombadictos\" y los \"Jugueteros\" en sus ofensivas.",
          TextMapId = "Mon_DesDetail_9006001"
        },
        Mon_DesDetail_9007001 = {
          ContentES = "Un miembro de Los Abandonados, con el grado de \"Enjambre Salvaje\". Sobresalen por el apoyo a distancia. Ninguna operación de Los Abandonados se lleva a cabo sin las órdenes de estos agentes, que susurran como fantasmas, y que regresan con información del campo de batalla, como si de halcones mensajeros se tratara. Se mueven por los callejones más oscuros del Imperio, tejiendo una red invisible de murmullos que conecta a todos los Abandonados.",
          TextMapId = "Mon_DesDetail_9007001"
        },
        Mon_DesDetail_9500001 = {
          ContentES = "¡Un bandido maestro, infame y escurridizo!",
          TextMapId = "Mon_DesDetail_9500001"
        },
        Mon_DesDetail_9501001 = {
          ContentES = "Ese joven sospechoso de adelante es el ladrón que robó la bolsa de Margie. ¡Ve y atrápalo ahora!",
          TextMapId = "Mon_DesDetail_9501001"
        },
        Mon_DesDetail_9801001 = {
          ContentES = "La subespecie norteña de los lobos salvajes ha adaptado su cuerpo a los páramos helados, con un pelaje invernal pálido y extremidades alargadas. Cuando veas “montículos de nieve moviéndose” en plena naturaleza, sabrás que ya estás rodeado por estos depredadores únicos.",
          TextMapId = "Mon_DesDetail_9801001"
        },
        Mon_DesDetail_9802001 = {
          ContentES = "Una especie ancestral y escasa; las leyendas cuentan que estas criaturas han visto pasar eras enteras con la serenidad de su mirada. Sus astas, teñidas con la sangre de guerras olvidadas, cargan el peso de continentes que nacieron y cayeron.",
          TextMapId = "Mon_DesDetail_9802001"
        },
        Mon_DesDetail_9803001 = {
          ContentES = "Estos roedores se adaptan y mutan más rápido de lo que las ciudades son capaces de olvidar. Prosperan en los rincones oscuros del mundo urbano, royendo los secretos que escondemos bajo el concreto.",
          TextMapId = "Mon_DesDetail_9803001"
        },
        Mon_DesDetail_9804001 = {
          ContentES = "Un ave cantora común de Huaxu, de canto suave y figura redonda. Suele verse saltando entre las ramas o correteando por el suelo. Los habitantes locales adoran estos aves profundamente.",
          TextMapId = "Mon_DesDetail_9804001"
        },
        Mon_DesDetail_9805001 = {
          ContentES = "Un ave acuática exclusiva de Huaxu, reconocible por las largas plumas que adornan su cabeza. Se alimenta de peces, cazando inmóvil sobre una sola pata en los bajíos, asestando un picotazo en el instante en que la presa se acerca demasiado. Su nombre proviene de su parecido con un pescador esperando el tirón de su caña.",
          TextMapId = "Mon_DesDetail_9805001"
        },
        Mon_DesDetail_9806001 = {
          ContentES = "Un ave terrestre que solo existe en Huaxu. Aunque sus alas son demasiado cortas para un vuelo prolongado, puede planear distancias sorprendentes. En la temporada adecuada, los machos despliegan la cola en un gesto de cortejo… aunque ambos sexos comparten el mismo y vívido plumaje esmeralda.",
          TextMapId = "Mon_DesDetail_9806001"
        },
        Mon_DesDetail_9807001 = {
          ContentES = "Un pequeño jabalí salvaje, llamado así por su cuerpo compacto. Su carne es tierna y suave, sin el sabor fuerte típico de los jabalíes grandes. Es un manjar con el que los habitantes de Huaxu honran a sus invitados.",
          TextMapId = "Mon_DesDetail_9807001"
        },
        Mon_DesDetail_9808001 = {
          ContentES = "Si oyes un largo “yip...yaaah” después del anochecer, en Huaxu, casi con certeza es un zorro. Los cuidadores de gallinas salen a revisar sus gallineros; los cazadores se internan en la oscuridad. Pero los zorros son maestros del engaño y la distracción… atraparlos nunca es seguro.",
          TextMapId = "Mon_DesDetail_9808001"
        },
        Mon_DesDetail_9809001 = {
          ContentES = "Un ciervo de gran tamaño que solo habita en Huaxu, a menudo visto recorriendo llanuras y laderas boscosas. La melena suave como una nube en su cuello le da su nombre. Es dócil por naturaleza… pero mejor no provocarlo, a menos que tus costillas soporten el embate de esos cuernos.",
          TextMapId = "Mon_DesDetail_9809001"
        },
        Mon_FirstSeen_Label = {
          ContentES = "Nuevo enemigo",
          TextMapId = "Mon_FirstSeen_Label"
        },
        Mon_Guide_115_01 = {
          ContentES = "Los <Highlight>Halcones Patrullas</> son soldados de élite seleccionados de entre las Patrullas. Los Halcones Patrullas vigilan cuando el enemigo se aproxima y bajan su alerta cuando la amenaza se aleja.",
          TextMapId = "Mon_Guide_115_01"
        },
        Mon_Guide_115_02 = {
          ContentES = "Si un <Highlight>Halcón Patrulla</> permanece en estado de vigilancia por demasiado tiempo, emitirá una <Highlight>alarma</> e iniciará una <Highlight>cuenta regresiva</> de ejecución de rehenes.",
          TextMapId = "Mon_Guide_115_02"
        },
        Mon_Guide_6006001_01 = {
          ContentES = "Al ser derrotado, el <Highlight>Filthoid Portador</> dejará caer un <Highlight>Módulo de excavación</>, necesario para mantener en funcionamiento la Excavadora.",
          TextMapId = "Mon_Guide_6006001_01"
        },
        Mon_Guide_6007001_01 = {
          ContentES = "El <Highlight>Filthoid Quemaalmas</> explota al morir, infligiendo daño en área tanto a aliados como a enemigos dentro del rango.",
          TextMapId = "Mon_Guide_6007001_01"
        },
        Mon_Guide_6015001_01 = {
          ContentES = "El <Highlight>Filthoid Flor de Ceniza</> explota al morir, infligiendo daño en área tanto a aliados como a enemigos dentro del rango.",
          TextMapId = "Mon_Guide_6015001_01"
        },
        Mon_Guide_7001005_01 = {
          ContentES = "<Highlight>Soldado Francotirador – Sigilo</> entra periódicamente en el modo [Sigilo], aumentando su Velocidad de Movimiento durante #1 s.",
          TextMapId = "Mon_Guide_7001005_01"
        },
        Mon_Guide_7001005_02 = {
          ContentES = "Cuando el <Highlight>Soldado Francotirador - Sigilo</> recibe daño estando por debajo del 80% de su PV Máx., activa el modo [Sigilo] y invoca varios [Señuelos] idénticos.\n[Señuelos]: Tienen la misma apariencia que <Highlight>Soldado Francotirador - Sigilo</>, pero reciben más daño.\nCuando uno de los [Señuelos] es derrotado, el <Highlight>Soldado Francotirador – Sigilo</> queda afectado por [Ralentización]. \n[Ralentización]: Reduce la Velocidad de Movimiento durante #2 s.",
          TextMapId = "Mon_Guide_7001005_02"
        },
        Mon_Guide_7002005_01 = {
          ContentES = "Al aparecer en combate, el <Highlight>Soldado Hendedor – Belicoso</> invoca un <Highlight>[Dron curativo]</> y de forma periódica, un <Highlight>[Dron magnético]</> para asistirlo en batalla.",
          TextMapId = "Mon_Guide_7002005_01"
        },
        Mon_Guide_7002005_02 = {
          ContentES = "<Highlight>Dron curativo</>: Permanece vinculado de manera continua a <Highlight>Soldado Hendedor – Belicoso</>.\nEl objetivo vinculado recibe aumentos de Velocidad de Movimiento y ATQ, además de recuperar sus PV de forma constante.",
          TextMapId = "Mon_Guide_7002005_02"
        },
        Mon_Guide_7002005_03 = {
          ContentES = "<Highlight>Dron magnético</>: Persigue al objetivo hostil, se autodestruye y luego crea una [Tormenta Magnética] centrada en sí mismo.\n[Tormenta Magnética]: Inflige daño e impone [Ralentización] a los objetivos hostiles dentro del rango. \n[Ralentización]: Reduce la Velocidad de Movimiento durante #1 s. Causa daño e inflige [Parálisis] a los objetivos dentro del rango. \n[Parálisis]: Incapaz de moverse o atacar durante #2 s.",
          TextMapId = "Mon_Guide_7002005_03"
        },
        Mon_Guide_7003005_01 = {
          ContentES = "<Highlight>Soldado Explorador - Asalto Armado</> coloca periódicamente una [Mina Terrestre] en su posición actual.",
          TextMapId = "Mon_Guide_7003005_01"
        },
        Mon_Guide_7003005_02 = {
          ContentES = "Las [Minas Terrestres] se activan cuando un enemigo entra en su radio y detonan tras un breve retraso, infligiendo daño y aplicando [Lentitud] a las unidades hostiles cercanas. [Lentitud]: Pierdes Velocidad de Movimiento durante #1 s.",
          TextMapId = "Mon_Guide_7003005_02"
        },
        Mon_Guide_7007002_01 = {
          ContentES = "Algunos <Highlight>Drones Magnéticos Ⅱ</> se aproximarán a vehículos y se autodestruirán, causando un daño considerable tanto a los vehículos como a otros objetivos hostiles dentro del rango.",
          TextMapId = "Mon_Guide_7007002_01"
        },
        Mon_Guide_7008001_01 = {
          ContentES = "El Sargento de Élite puede usar <Highlight>Mejora de Moral</> para inspirar a los aliados cercanos.",
          TextMapId = "Mon_Guide_7008001_01"
        },
        Mon_Guide_7008001_02 = {
          ContentES = "Los aliados inspirados obtienen [Moral Alta]. [Moral Alta]: Aumenta la Velocidad de Movimiento, el daño infligido y reduce el daño recibido.",
          TextMapId = "Mon_Guide_7008001_02"
        },
        Mon_Guide_7008001_03 = {
          ContentES = "Cuando el Sargento de Élite es <Highlight>derrotado</>, los aliados pierden el efecto de [Moral Alta].",
          TextMapId = "Mon_Guide_7008001_03"
        },
        Mon_Guide_7015001_01 = {
          ContentES = "El <Highlight>Dron Patrullero</> explota al ser derrotado, infligiendo daño en área a aliados y enemigos dentro del rango.",
          TextMapId = "Mon_Guide_7015001_01"
        },
        Mon_Guide_8501002_01 = {
          ContentES = "Ferozmente implacables, los <Highlight>Maestro de Batalla</> usan sus habilidades aberrantes para perseguir a sus objetivos una vez iniciado el combate.",
          TextMapId = "Mon_Guide_8501002_01"
        },
        Mon_Guide_8515001_01 = {
          ContentES = "Cuando el <Highlight>Devorador</> libera <Highlight>Explosión de Esporas</> o <Highlight>Aliento Abrasador</>, apunta a su <Highlight>cabeza brillante</> para \ninmovilizarlo brevemente.",
          TextMapId = "Mon_Guide_8515001_01"
        },
        Mon_Guide_9003001_01 = {
          ContentES = "Los <Highlight>Jugueteros</> pertenecen a los \"Soldados\" de Los Abandonados. Son expertos en alterar el entorno y en tender trampas.\nEn <Highlight>“Encargo: Mediación”</>, cuando un Juguetero es derrotado, aparecen <Highlight>Plataformas de Rebote</> en la ruta de retirada para facilitar tu escape.",
          TextMapId = "Mon_Guide_9003001_01"
        },
        Mon_Guide_9005001_01 = {
          ContentES = "Los <Highlight>Bombadictos</> pertenecen a los \"Soldados\" de Los Abandonados. Altamente diestros en manipular explosivos.\nEn <Highlight>“Encargo: Mediación”</>, cuando un Bombadicto es derrotado, los PV Máx. de <Highlight>Destello final</> se reduce en un 30%.",
          TextMapId = "Mon_Guide_9005001_01"
        },
        Mon_Guide_9006001_01 = {
          ContentES = "Los <Highlight>Engañadores</> pertenecen a los \"Soldados\" de Los Abandonados. Son expertos en desordenar formaciones y sembrar caos en el campo de batalla.\nEn <Highlight>“Encargo: Mediación”</>, cuando un Engañador es derrotado, los enemigos de élite dejan de aparecer.",
          TextMapId = "Mon_Guide_9006001_01"
        },
        Mon_Guide_9500001_01 = {
          ContentES = "<Highlight>Lulu, la saqueadora de botín</> aparece por un periodo corto antes de escapar. Derrótala antes de que huya garantiza un botín considerable.",
          TextMapId = "Mon_Guide_9500001_01"
        },
        Mon_Guide_Strong_Blood_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Putrefacción</> crea periódicamente un [Pantano Putrefacto] a su alrededor.",
          TextMapId = "Mon_Guide_Strong_Blood_01"
        },
        Mon_Guide_Strong_Blood_02 = {
          ContentES = "[Pantano Putrefacto]: Inflige daño periódico a los enemigos dentro de su radio, mientras cura a los aliados adentro.",
          TextMapId = "Mon_Guide_Strong_Blood_02"
        },
        Mon_Guide_Strong_Burst_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Explosión</> desencadena periódicamente una explosión centrada en su propio cuerpo, lanzando por los aires a las unidades hostiles cercanas.",
          TextMapId = "Mon_Guide_Strong_Burst_01"
        },
        Mon_Guide_Strong_Fade_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Marchitar</> libera periódicamente 3 [Rayos Marchitos] que rotan a su alrededor. \n[Rayo Marchito]: Dura 10 s. Orbita alrededor del Comandante, causa daño al contacto y reduce la Cordura del objetivo.",
          TextMapId = "Mon_Guide_Strong_Fade_01"
        },
        Mon_Guide_Strong_Frozen_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\nCuando <Highlight>Comandante – Congelación</> recibe el impacto de un arma a distancia, contraataca lanzando carámbanos hacia el agresor, infligiendo daño y aplicando 1 acumulación de [Ralentización]. \n[Ralentización]: Reduce la Velocidad de Ataque y la Velocidad de Movimiento durante #1 s, hasta #2 acumulaciones.",
          TextMapId = "Mon_Guide_Strong_Frozen_01"
        },
        Mon_Guide_Strong_IceOrb_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Infierno Gélido</> invoca periódicamente un [Infierno Gélido] bajo los objetivos enemigos. \n[Infierno Gélido]: Ralentiza a los blancos dentro de su radio y, luego detona después de #1, infligiendo daño en área a todos los objetivos hostiles cercanos.",
          TextMapId = "Mon_Guide_Strong_IceOrb_01"
        },
        Mon_Guide_Strong_Kamikaze_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Sacrificio</> explota al ser derrotado, infligiendo daño a todos los objetivos hostiles dentro del rango.",
          TextMapId = "Mon_Guide_Strong_Kamikaze_01"
        },
        Mon_Guide_Strong_Multiple_01 = {
          ContentES = "Algunos Comandantes poseen varias <Highlight>habilidades de Comandante</> al mismo tiempo.",
          TextMapId = "Mon_Guide_Strong_Multiple_01"
        },
        Mon_Guide_Strong_Poison_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Corrosión</> genera de forma periódica un charco de [Veneno] bajo sus pies. \n[Veneno]: Inflige una reducción de DEF del objetivo y causa daño periódico dentro de su zona.\nAdemás, mientras permanezca con vida, <Highlight>Comandante – Corrosión</> acelerará la descomposición del Suero.",
          TextMapId = "Mon_Guide_Strong_Poison_01"
        },
        Mon_Guide_Strong_Reflect_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Destello</> se aplica periódicamente [Destello] a sí mismo. \n[Destello]: Dura #1 s; mientras está activo, recibir daño desencadena una explosión que inflige daño en área a los enemigos dentro del rango.",
          TextMapId = "Mon_Guide_Strong_Reflect_01"
        },
        Mon_Guide_Strong_Revenge_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Venganza</> otorga poder a sus aliados cercanos al morir. \n[Reforzado]: Aumenta el ATQ, la DEF, la Velocidad de Movimiento y la Velocidad de Ataque durante #1 s.",
          TextMapId = "Mon_Guide_Strong_Revenge_01"
        },
        Mon_Guide_Strong_Shield_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Guardián</> invoca periódicamente un [Campo Guardián] a su alrededor. \n[Campo Guardián]: Dura #1 s y bloquea todas las balas y proyectiles hostiles.",
          TextMapId = "Mon_Guide_Strong_Shield_01"
        },
        Mon_Guide_Strong_Threefold_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Fantasma</> invoca #1 [Fantasma(s)] al inicio del combate. \n[Fantasma]: Recibe más daño de lo normal, pero replica las habilidades de combate de su invocador.",
          TextMapId = "Mon_Guide_Strong_Threefold_01"
        },
        Mon_Guide_Strong_ThunderLaser_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Tormenta Eléctrica</> invoca periódicamente [Infiernos de Trueno] a su alrededor. \n[Infierno de Trueno]: Gira sin descanso por el campo, causando daño a cualquier objetivo hostil que toque.",
          TextMapId = "Mon_Guide_Strong_ThunderLaser_01"
        },
        Mon_Guide_Strong_Thunder_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Trueno</> libera periódicamente [Orbes Eléctricos] que se expanden hacia afuera. \n[Orbe Eléctrico]: Descarga electricidad cada #1 s, infligiendo daño a los enemigos cercanos. Desaparece al recibir un ataque.",
          TextMapId = "Mon_Guide_Strong_Thunder_01"
        },
        Mon_Guide_Strong_Vampire_01 = {
          ContentES = "Los Comandantes son entidades poderosas dentro de las fuerzas hostiles, capaces de emplear habilidades únicas conocidas como las <Highlight>habilidades de Comandante</>.\n<Highlight>Comandante – Baño de Sangre</> restaura sus propios PV cada vez que inflige daño.",
          TextMapId = "Mon_Guide_Strong_Vampire_01"
        },
        Mon_Guide_Title_115 = {
          ContentES = "Halcón Patrulla",
          TextMapId = "Mon_Guide_Title_115"
        },
        Mon_Guide_Title_6006001 = {
          ContentES = "Filthoid Portador",
          TextMapId = "Mon_Guide_Title_6006001"
        },
        Mon_Guide_Title_6007001 = {
          ContentES = "Filthoid Quemaalmas",
          TextMapId = "Mon_Guide_Title_6007001"
        },
        Mon_Guide_Title_6015001 = {
          ContentES = "Filthoid Flor de Ceniza",
          TextMapId = "Mon_Guide_Title_6015001"
        },
        Mon_Guide_Title_7001005 = {
          ContentES = "Objetivo: Soldado Francotirador - Sigilo",
          TextMapId = "Mon_Guide_Title_7001005"
        },
        Mon_Guide_Title_7002005 = {
          ContentES = "Objetivo: Soldado Hendedor - Belicoso",
          TextMapId = "Mon_Guide_Title_7002005"
        },
        Mon_Guide_Title_7003005 = {
          ContentES = "Objetivo: Soldado Explorador - Asalto Armado",
          TextMapId = "Mon_Guide_Title_7003005"
        },
        Mon_Guide_Title_7007002 = {
          ContentES = "Dron magnético Ⅱ",
          TextMapId = "Mon_Guide_Title_7007002"
        },
        Mon_Guide_Title_7008001 = {
          ContentES = "Sargento de Élite",
          TextMapId = "Mon_Guide_Title_7008001"
        },
        Mon_Guide_Title_7015001 = {
          ContentES = "Dron Patrullero",
          TextMapId = "Mon_Guide_Title_7015001"
        },
        Mon_Guide_Title_8501002 = {
          ContentES = "Maestro de Batalla",
          TextMapId = "Mon_Guide_Title_8501002"
        },
        Mon_Guide_Title_8515001 = {
          ContentES = "El Devorador",
          TextMapId = "Mon_Guide_Title_8515001"
        },
        Mon_Guide_Title_9003004 = {
          ContentES = "Juguetero",
          TextMapId = "Mon_Guide_Title_9003004"
        },
        Mon_Guide_Title_9005004 = {
          ContentES = "Bombadicto",
          TextMapId = "Mon_Guide_Title_9005004"
        },
        Mon_Guide_Title_9006004 = {
          ContentES = "Engañador",
          TextMapId = "Mon_Guide_Title_9006004"
        },
        Mon_Guide_Title_9500001 = {
          ContentES = "Lulu, la saqueadora de botín",
          TextMapId = "Mon_Guide_Title_9500001"
        },
        Mon_Guide_Title_Strong_Blood = {
          ContentES = "Comandante - Putrefacción",
          TextMapId = "Mon_Guide_Title_Strong_Blood"
        },
        Mon_Guide_Title_Strong_Burst = {
          ContentES = "Comandante - Explosión",
          TextMapId = "Mon_Guide_Title_Strong_Burst"
        },
        Mon_Guide_Title_Strong_Fade = {
          ContentES = "Comandante - Marchitar",
          TextMapId = "Mon_Guide_Title_Strong_Fade"
        },
        Mon_Guide_Title_Strong_Frozen = {
          ContentES = "Comandante - Congelación",
          TextMapId = "Mon_Guide_Title_Strong_Frozen"
        },
        Mon_Guide_Title_Strong_IceOrb = {
          ContentES = "Comandante - Infierno Gélido",
          TextMapId = "Mon_Guide_Title_Strong_IceOrb"
        },
        Mon_Guide_Title_Strong_Kamikaze = {
          ContentES = "Comandante - Sacrificio",
          TextMapId = "Mon_Guide_Title_Strong_Kamikaze"
        },
        Mon_Guide_Title_Strong_Multiple = {
          ContentES = "Comandante - Versátil",
          TextMapId = "Mon_Guide_Title_Strong_Multiple"
        },
        Mon_Guide_Title_Strong_Poison = {
          ContentES = "Comandante - Corrosión",
          TextMapId = "Mon_Guide_Title_Strong_Poison"
        },
        Mon_Guide_Title_Strong_Reflect = {
          ContentES = "Comandante - Destello",
          TextMapId = "Mon_Guide_Title_Strong_Reflect"
        },
        Mon_Guide_Title_Strong_Revenge = {
          ContentES = "Comandante - Venganza",
          TextMapId = "Mon_Guide_Title_Strong_Revenge"
        },
        Mon_Guide_Title_Strong_Shield = {
          ContentES = "Comandante - Guardián",
          TextMapId = "Mon_Guide_Title_Strong_Shield"
        },
        Mon_Guide_Title_Strong_Threefold = {
          ContentES = "Comandante - Fantasma",
          TextMapId = "Mon_Guide_Title_Strong_Threefold"
        },
        Mon_Guide_Title_Strong_Thunder = {
          ContentES = "Comandante - Trueno",
          TextMapId = "Mon_Guide_Title_Strong_Thunder"
        },
        Mon_Guide_Title_Strong_ThunderLaser = {
          ContentES = "Comandante - Tormenta Eléctrica",
          TextMapId = "Mon_Guide_Title_Strong_ThunderLaser"
        },
        Mon_Guide_Title_Strong_Vampire = {
          ContentES = "Comandante - Baño de Sangre",
          TextMapId = "Mon_Guide_Title_Strong_Vampire"
        },
        Mon_Guide_Weakness_Label = {
          ContentES = "Tipo de elemento",
          TextMapId = "Mon_Guide_Weakness_Label"
        },
        Mon_Name_10001001 = {
          ContentES = "Guardia de Yingtian",
          TextMapId = "Mon_Name_10001001"
        },
        Mon_Name_10001011 = {
          ContentES = "Guardia de Yingtian - Congelación",
          TextMapId = "Mon_Name_10001011"
        },
        Mon_Name_10001012 = {
          ContentES = "Guardia de Yingtian - Explosión",
          TextMapId = "Mon_Name_10001012"
        },
        Mon_Name_10001014 = {
          ContentES = "Guardia de Yingtian - Trueno",
          TextMapId = "Mon_Name_10001014"
        },
        Mon_Name_10001016 = {
          ContentES = "Guardia de Yingtian - Marchitar",
          TextMapId = "Mon_Name_10001016"
        },
        Mon_Name_10001017 = {
          ContentES = "Guardia de Yingtian - Guardián",
          TextMapId = "Mon_Name_10001017"
        },
        Mon_Name_10001018 = {
          ContentES = "Guardia de Yingtian - Venganza",
          TextMapId = "Mon_Name_10001018"
        },
        Mon_Name_10001019 = {
          ContentES = "Guardia de Yingtian - Infierno Gélido",
          TextMapId = "Mon_Name_10001019"
        },
        Mon_Name_10001020 = {
          ContentES = "Guardia de Yingtian - Destello",
          TextMapId = "Mon_Name_10001020"
        },
        Mon_Name_10001021 = {
          ContentES = "Guardia de Yingtian - Sacrificio",
          TextMapId = "Mon_Name_10001021"
        },
        Mon_Name_10001023 = {
          ContentES = "Guardia de Yingtian - Baño de Sangre",
          TextMapId = "Mon_Name_10001023"
        },
        Mon_Name_10001024 = {
          ContentES = "Guardia de Yingtian - Fantasma",
          TextMapId = "Mon_Name_10001024"
        },
        Mon_Name_10002001 = {
          ContentES = "Magistrado de Yingtian",
          TextMapId = "Mon_Name_10002001"
        },
        Mon_Name_10003001 = {
          ContentES = "Bi'an Oscuro",
          TextMapId = "Mon_Name_10003001"
        },
        Mon_Name_10004001 = {
          ContentES = "Bi'an",
          TextMapId = "Mon_Name_10004001"
        },
        Mon_Name_10005001 = {
          ContentES = "Guardia Frenético de Yingtian",
          TextMapId = "Mon_Name_10005001"
        },
        Mon_Name_10005011 = {
          ContentES = "Guardia Frenético de Yingtian - Congelación",
          TextMapId = "Mon_Name_10005011"
        },
        Mon_Name_10005012 = {
          ContentES = "Guardia Frenético de Yingtian - Explosión",
          TextMapId = "Mon_Name_10005012"
        },
        Mon_Name_10005014 = {
          ContentES = "Guardia Frenético de Yingtian - Trueno",
          TextMapId = "Mon_Name_10005014"
        },
        Mon_Name_10005016 = {
          ContentES = "Guardia Frenético de Yingtian - Marchitar",
          TextMapId = "Mon_Name_10005016"
        },
        Mon_Name_10005017 = {
          ContentES = "Guardia Frenético de Yingtian - Guardián",
          TextMapId = "Mon_Name_10005017"
        },
        Mon_Name_10005018 = {
          ContentES = "Guardia Frenético de Yingtian - Venganza",
          TextMapId = "Mon_Name_10005018"
        },
        Mon_Name_10005019 = {
          ContentES = "Guardia Frenético de Yingtian - Infierno Gélido",
          TextMapId = "Mon_Name_10005019"
        },
        Mon_Name_10005020 = {
          ContentES = "Guardia Frenético de Yingtian - Destello",
          TextMapId = "Mon_Name_10005020"
        },
        Mon_Name_10005021 = {
          ContentES = "Guardia Frenético de Yingtian - Sacrificio",
          TextMapId = "Mon_Name_10005021"
        },
        Mon_Name_10005023 = {
          ContentES = "Guardia Frenético de Yingtian - Baño de Sangre",
          TextMapId = "Mon_Name_10005023"
        },
        Mon_Name_10005024 = {
          ContentES = "Guardia Frenético de Yingtian - Fantasma",
          TextMapId = "Mon_Name_10005024"
        },
        Mon_Name_108 = {
          ContentES = "Bombadicto",
          TextMapId = "Mon_Name_108"
        },
        Mon_Name_109 = {
          ContentES = "Juguetero",
          TextMapId = "Mon_Name_109"
        },
        Mon_Name_110 = {
          ContentES = "Engañador",
          TextMapId = "Mon_Name_110"
        },
        Mon_Name_115 = {
          ContentES = "Halcón Patrulla",
          TextMapId = "Mon_Name_115"
        },
        Mon_Name_6001001 = {
          ContentES = "Filthoid Veloz",
          TextMapId = "Mon_Name_6001001"
        },
        Mon_Name_6001011 = {
          ContentES = "Filthoid Veloz - Congelación",
          TextMapId = "Mon_Name_6001011"
        },
        Mon_Name_6001012 = {
          ContentES = "Filthoid Veloz - Explosión",
          TextMapId = "Mon_Name_6001012"
        },
        Mon_Name_6001013 = {
          ContentES = "Filthoid Veloz - Corrosión",
          TextMapId = "Mon_Name_6001013"
        },
        Mon_Name_6001014 = {
          ContentES = "Filthoid Veloz - Trueno",
          TextMapId = "Mon_Name_6001014"
        },
        Mon_Name_6001015 = {
          ContentES = "Filthoid Veloz - Putrefacción",
          TextMapId = "Mon_Name_6001015"
        },
        Mon_Name_6001016 = {
          ContentES = "Filthoid Veloz - Marchitar",
          TextMapId = "Mon_Name_6001016"
        },
        Mon_Name_6001017 = {
          ContentES = "Filthoid Veloz - Guardián",
          TextMapId = "Mon_Name_6001017"
        },
        Mon_Name_6001018 = {
          ContentES = "Filthoid Veloz - Venganza",
          TextMapId = "Mon_Name_6001018"
        },
        Mon_Name_6001019 = {
          ContentES = "Filthoid Veloz - Infierno Gélido",
          TextMapId = "Mon_Name_6001019"
        },
        Mon_Name_6001020 = {
          ContentES = "Filthoid Veloz - Destello",
          TextMapId = "Mon_Name_6001020"
        },
        Mon_Name_6001021 = {
          ContentES = "Filthoid Veloz - Sacrificio",
          TextMapId = "Mon_Name_6001021"
        },
        Mon_Name_6001022 = {
          ContentES = "Filthoid Veloz - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6001022"
        },
        Mon_Name_6001023 = {
          ContentES = "Filthoid Veloz - Baño de Sangre",
          TextMapId = "Mon_Name_6001023"
        },
        Mon_Name_6001024 = {
          ContentES = "Filthoid Veloz - Fantasma",
          TextMapId = "Mon_Name_6001024"
        },
        Mon_Name_6001201 = {
          ContentES = "Filthoid Veloz - Trueno y Sacrificio",
          TextMapId = "Mon_Name_6001201"
        },
        Mon_Name_6001301 = {
          ContentES = "Filthoid Veloz - Sacrificio, Marchitar y Explosión",
          TextMapId = "Mon_Name_6001301"
        },
        Mon_Name_6002001 = {
          ContentES = "Filthoid Guerrillero",
          TextMapId = "Mon_Name_6002001"
        },
        Mon_Name_6002011 = {
          ContentES = "Filthoid Guerrillero - Congelación",
          TextMapId = "Mon_Name_6002011"
        },
        Mon_Name_6002012 = {
          ContentES = "Filthoid Guerrillero - Explosión",
          TextMapId = "Mon_Name_6002012"
        },
        Mon_Name_6002013 = {
          ContentES = "Filthoid Guerrillero - Corrosión",
          TextMapId = "Mon_Name_6002013"
        },
        Mon_Name_6002014 = {
          ContentES = "Filthoid Guerrillero - Estruendo",
          TextMapId = "Mon_Name_6002014"
        },
        Mon_Name_6002015 = {
          ContentES = "Filthoid Guerrillero - Putrefacción",
          TextMapId = "Mon_Name_6002015"
        },
        Mon_Name_6002016 = {
          ContentES = "Filthoid Guerrillero - Marchitar",
          TextMapId = "Mon_Name_6002016"
        },
        Mon_Name_6002017 = {
          ContentES = "Filthoid Guerrillero - Guardián",
          TextMapId = "Mon_Name_6002017"
        },
        Mon_Name_6002018 = {
          ContentES = "Filthoid Guerrillero - Venganza",
          TextMapId = "Mon_Name_6002018"
        },
        Mon_Name_6002019 = {
          ContentES = "Filthoid Guerrillero - Infierno Gélido",
          TextMapId = "Mon_Name_6002019"
        },
        Mon_Name_6002020 = {
          ContentES = "Filthoid Guerrillero - Destello",
          TextMapId = "Mon_Name_6002020"
        },
        Mon_Name_6002021 = {
          ContentES = "Filthoid Guerrillero - Sacrificio",
          TextMapId = "Mon_Name_6002021"
        },
        Mon_Name_6002022 = {
          ContentES = "Filthoid Guerrillero - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6002022"
        },
        Mon_Name_6002023 = {
          ContentES = "Filthoid Guerrillero - Baño de Sangre",
          TextMapId = "Mon_Name_6002023"
        },
        Mon_Name_6002024 = {
          ContentES = "Filthoid Guerrillero - Fantasma",
          TextMapId = "Mon_Name_6002024"
        },
        Mon_Name_6002201 = {
          ContentES = "Filthoid Guerrillero - Sacrificio y Guardián",
          TextMapId = "Mon_Name_6002201"
        },
        Mon_Name_6002301 = {
          ContentES = "Filthoid Guerrillero - Putrefacción, Congelación y Guardián",
          TextMapId = "Mon_Name_6002301"
        },
        Mon_Name_6003001 = {
          ContentES = "Filthoid Flotante",
          TextMapId = "Mon_Name_6003001"
        },
        Mon_Name_6003011 = {
          ContentES = "Filthoid Flotante - Congelación",
          TextMapId = "Mon_Name_6003011"
        },
        Mon_Name_6003012 = {
          ContentES = "Filthoid Flotante - Explosión",
          TextMapId = "Mon_Name_6003012"
        },
        Mon_Name_6003013 = {
          ContentES = "Filthoid Flotante - Corrosión",
          TextMapId = "Mon_Name_6003013"
        },
        Mon_Name_6003014 = {
          ContentES = "Filthoid Flotante - Trueno",
          TextMapId = "Mon_Name_6003014"
        },
        Mon_Name_6003015 = {
          ContentES = "Filthoid Flotante - Putrefacción",
          TextMapId = "Mon_Name_6003015"
        },
        Mon_Name_6003016 = {
          ContentES = "Filthoid Flotante - Marchitar",
          TextMapId = "Mon_Name_6003016"
        },
        Mon_Name_6003017 = {
          ContentES = "Filthoid Flotante - Guardián",
          TextMapId = "Mon_Name_6003017"
        },
        Mon_Name_6003018 = {
          ContentES = "Filthoid Flotante - Venganza",
          TextMapId = "Mon_Name_6003018"
        },
        Mon_Name_6003019 = {
          ContentES = "Filthoid Flotante - Infierno Gélido",
          TextMapId = "Mon_Name_6003019"
        },
        Mon_Name_6003020 = {
          ContentES = "Filthoid Flotante - Destello",
          TextMapId = "Mon_Name_6003020"
        },
        Mon_Name_6003021 = {
          ContentES = "Filthoid Flotante - Sacrificio",
          TextMapId = "Mon_Name_6003021"
        },
        Mon_Name_6003022 = {
          ContentES = "Filthoid Flotante - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6003022"
        },
        Mon_Name_6003023 = {
          ContentES = "Filthoid Flotante - Baño de Sangre",
          TextMapId = "Mon_Name_6003023"
        },
        Mon_Name_6003024 = {
          ContentES = "Filthoid Flotante - Fantasma",
          TextMapId = "Mon_Name_6003024"
        },
        Mon_Name_6003201 = {
          ContentES = "Filthoid Flotante - Congelación y Guardián",
          TextMapId = "Mon_Name_6003201"
        },
        Mon_Name_6003301 = {
          ContentES = "Filthoid Flotante - Putrefacción, Venganza y Guardián",
          TextMapId = "Mon_Name_6003301"
        },
        Mon_Name_6004001 = {
          ContentES = "Filthoid Salvaje",
          TextMapId = "Mon_Name_6004001"
        },
        Mon_Name_6004011 = {
          ContentES = "Filthoid Salvaje - Congelación",
          TextMapId = "Mon_Name_6004011"
        },
        Mon_Name_6004012 = {
          ContentES = "Filthoid Salvaje - Explosión",
          TextMapId = "Mon_Name_6004012"
        },
        Mon_Name_6004013 = {
          ContentES = "Filthoid Salvaje - Corrosión",
          TextMapId = "Mon_Name_6004013"
        },
        Mon_Name_6004014 = {
          ContentES = "Filthoid Salvaje - Trueno",
          TextMapId = "Mon_Name_6004014"
        },
        Mon_Name_6004015 = {
          ContentES = "Filthoid Salvaje - Putrefacción",
          TextMapId = "Mon_Name_6004015"
        },
        Mon_Name_6004016 = {
          ContentES = "Filthoid Salvaje - Marchitar",
          TextMapId = "Mon_Name_6004016"
        },
        Mon_Name_6004017 = {
          ContentES = "Filthoid Salvaje - Guardián",
          TextMapId = "Mon_Name_6004017"
        },
        Mon_Name_6004018 = {
          ContentES = "Filthoid Salvaje - Venganza",
          TextMapId = "Mon_Name_6004018"
        },
        Mon_Name_6004019 = {
          ContentES = "Filthoid Salvaje - Infierno Gélido",
          TextMapId = "Mon_Name_6004019"
        },
        Mon_Name_6004020 = {
          ContentES = "Filthoid Salvaje - Destello",
          TextMapId = "Mon_Name_6004020"
        },
        Mon_Name_6004021 = {
          ContentES = "Filthoid Salvaje - Sacrificio",
          TextMapId = "Mon_Name_6004021"
        }
      }
    end
  },
  {
    MinKey = "Mon_Name_6004022",
    MaxKey = "Mon_Name_7006001",
    Loader = function()
      return {
        Mon_Name_6004022 = {
          ContentES = "Filthoid Salvaje - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6004022"
        },
        Mon_Name_6004023 = {
          ContentES = "Filthoid Salvaje - Baño de Sangre",
          TextMapId = "Mon_Name_6004023"
        },
        Mon_Name_6004024 = {
          ContentES = "Filthoid Salvaje - Fantasma",
          TextMapId = "Mon_Name_6004024"
        },
        Mon_Name_6004201 = {
          ContentES = "Filthoid Salvaje - Explosión e Infierno Gélido",
          TextMapId = "Mon_Name_6004201"
        },
        Mon_Name_6004301 = {
          ContentES = "Filthoid Salvaje - Trueno, Explosión e Infierno Gélido",
          TextMapId = "Mon_Name_6004301"
        },
        Mon_Name_6005001 = {
          ContentES = "Filthoid Nepente",
          TextMapId = "Mon_Name_6005001"
        },
        Mon_Name_6006001 = {
          ContentES = "Filthoid Portador",
          TextMapId = "Mon_Name_6006001"
        },
        Mon_Name_6007001 = {
          ContentES = "Filthoid Quemaalmas",
          TextMapId = "Mon_Name_6007001"
        },
        Mon_Name_6007011 = {
          ContentES = "Filthoid Quemaalmas - Congelación",
          TextMapId = "Mon_Name_6007011"
        },
        Mon_Name_6007012 = {
          ContentES = "Filthoid Quemaalmas - Explosión",
          TextMapId = "Mon_Name_6007012"
        },
        Mon_Name_6007013 = {
          ContentES = "Filthoid Quemaalmas - Corrosión",
          TextMapId = "Mon_Name_6007013"
        },
        Mon_Name_6007014 = {
          ContentES = "Filthoid Quemaalmas - Trueno",
          TextMapId = "Mon_Name_6007014"
        },
        Mon_Name_6007015 = {
          ContentES = "Filthoid Quemaalmas - Putrefacción",
          TextMapId = "Mon_Name_6007015"
        },
        Mon_Name_6007016 = {
          ContentES = "Filthoid Quemaalmas - Marchitar",
          TextMapId = "Mon_Name_6007016"
        },
        Mon_Name_6007017 = {
          ContentES = "Filthoid Quemaalmas - Guardián",
          TextMapId = "Mon_Name_6007017"
        },
        Mon_Name_6007018 = {
          ContentES = "Filthoid Quemaalmas - Venganza",
          TextMapId = "Mon_Name_6007018"
        },
        Mon_Name_6007019 = {
          ContentES = "Filthoid Quemaalmas - Infierno Gélido",
          TextMapId = "Mon_Name_6007019"
        },
        Mon_Name_6007020 = {
          ContentES = "Filthoid Quemaalmas - Destello",
          TextMapId = "Mon_Name_6007020"
        },
        Mon_Name_6007021 = {
          ContentES = "Filthoid Quemaalmas - Sacrificio",
          TextMapId = "Mon_Name_6007021"
        },
        Mon_Name_6007022 = {
          ContentES = "Filthoid Quemaalmas - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6007022"
        },
        Mon_Name_6007023 = {
          ContentES = "Filthoid Quemaalmas - Baño de Sangre",
          TextMapId = "Mon_Name_6007023"
        },
        Mon_Name_6007024 = {
          ContentES = "Filthoid Quemaalmas - Fantasma",
          TextMapId = "Mon_Name_6007024"
        },
        Mon_Name_6007201 = {
          ContentES = "Filthoid Quemaalmas - Trueno y Explosión",
          TextMapId = "Mon_Name_6007201"
        },
        Mon_Name_6007301 = {
          ContentES = "Filthoid Quemaalmas - Venganza, Explosión y Destello",
          TextMapId = "Mon_Name_6007301"
        },
        Mon_Name_6011001 = {
          ContentES = "Filthoid Veloz Ⅱ",
          TextMapId = "Mon_Name_6011001"
        },
        Mon_Name_6011011 = {
          ContentES = "Filthoid Veloz Ⅱ - Congelación",
          TextMapId = "Mon_Name_6011011"
        },
        Mon_Name_6011012 = {
          ContentES = "Filthoid Veloz Ⅱ - Explosión",
          TextMapId = "Mon_Name_6011012"
        },
        Mon_Name_6011013 = {
          ContentES = "Filthoid Veloz Ⅱ - Corrosión",
          TextMapId = "Mon_Name_6011013"
        },
        Mon_Name_6011014 = {
          ContentES = "Filthoid Veloz Ⅱ - Trueno",
          TextMapId = "Mon_Name_6011014"
        },
        Mon_Name_6011015 = {
          ContentES = "Filthoid Veloz Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_6011015"
        },
        Mon_Name_6011016 = {
          ContentES = "Filthoid Veloz Ⅱ - Marchitar",
          TextMapId = "Mon_Name_6011016"
        },
        Mon_Name_6011017 = {
          ContentES = "Filthoid Veloz Ⅱ - Guardián",
          TextMapId = "Mon_Name_6011017"
        },
        Mon_Name_6011018 = {
          ContentES = "Filthoid Veloz Ⅱ - Venganza",
          TextMapId = "Mon_Name_6011018"
        },
        Mon_Name_6011019 = {
          ContentES = "Filthoid Veloz Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_6011019"
        },
        Mon_Name_6011020 = {
          ContentES = "Filthoid Veloz Ⅱ - Destello",
          TextMapId = "Mon_Name_6011020"
        },
        Mon_Name_6011021 = {
          ContentES = "Filthoid Veloz Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_6011021"
        },
        Mon_Name_6011022 = {
          ContentES = "Filthoid Veloz Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6011022"
        },
        Mon_Name_6011023 = {
          ContentES = "Filthoid Veloz Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_6011023"
        },
        Mon_Name_6011024 = {
          ContentES = "Filthoid Veloz Ⅱ - Fantasma",
          TextMapId = "Mon_Name_6011024"
        },
        Mon_Name_6011201 = {
          ContentES = "Filthoid Veloz Ⅱ - Trueno y Sacrificio",
          TextMapId = "Mon_Name_6011201"
        },
        Mon_Name_6011301 = {
          ContentES = "Filthoid Veloz Ⅱ - Sacrificio y Marchitar y Explosión",
          TextMapId = "Mon_Name_6011301"
        },
        Mon_Name_6012001 = {
          ContentES = "Filthoid Guerrillero Ⅱ",
          TextMapId = "Mon_Name_6012001"
        },
        Mon_Name_6012011 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Congelación",
          TextMapId = "Mon_Name_6012011"
        },
        Mon_Name_6012012 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Explosión",
          TextMapId = "Mon_Name_6012012"
        },
        Mon_Name_6012013 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Corrosión",
          TextMapId = "Mon_Name_6012013"
        },
        Mon_Name_6012014 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Trueno",
          TextMapId = "Mon_Name_6012014"
        },
        Mon_Name_6012015 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_6012015"
        },
        Mon_Name_6012016 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Marchitar",
          TextMapId = "Mon_Name_6012016"
        },
        Mon_Name_6012017 = {
          ContentES = "Filthoid Guerrillero Ⅱ- Guardián",
          TextMapId = "Mon_Name_6012017"
        },
        Mon_Name_6012018 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Venganza",
          TextMapId = "Mon_Name_6012018"
        },
        Mon_Name_6012019 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_6012019"
        },
        Mon_Name_6012020 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Destello",
          TextMapId = "Mon_Name_6012020"
        },
        Mon_Name_6012021 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_6012021"
        },
        Mon_Name_6012022 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6012022"
        },
        Mon_Name_6012023 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_6012023"
        },
        Mon_Name_6012024 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Fantasma",
          TextMapId = "Mon_Name_6012024"
        },
        Mon_Name_6012201 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Sacrificio y Guardián",
          TextMapId = "Mon_Name_6012201"
        },
        Mon_Name_6012301 = {
          ContentES = "Filthoid Guerrillero Ⅱ - Putrefacción, Congelación y Guardián",
          TextMapId = "Mon_Name_6012301"
        },
        Mon_Name_6013001 = {
          ContentES = "Filthoid Flotante Ⅱ",
          TextMapId = "Mon_Name_6013001"
        },
        Mon_Name_6013011 = {
          ContentES = "Filthoid Flotante Ⅱ - Congelación",
          TextMapId = "Mon_Name_6013011"
        },
        Mon_Name_6013012 = {
          ContentES = "Filthoid Flotante Ⅱ - Explosión",
          TextMapId = "Mon_Name_6013012"
        },
        Mon_Name_6013013 = {
          ContentES = "Filthoid Flotante Ⅱ - Corrosión",
          TextMapId = "Mon_Name_6013013"
        },
        Mon_Name_6013014 = {
          ContentES = "Filthoid Flotante Ⅱ - Trueno",
          TextMapId = "Mon_Name_6013014"
        },
        Mon_Name_6013015 = {
          ContentES = "Filthoid Flotante Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_6013015"
        },
        Mon_Name_6013016 = {
          ContentES = "Filthoid Flotante Ⅱ - Marchitar",
          TextMapId = "Mon_Name_6013016"
        },
        Mon_Name_6013017 = {
          ContentES = "Filthoid Flotante Ⅱ - Guardián",
          TextMapId = "Mon_Name_6013017"
        },
        Mon_Name_6013018 = {
          ContentES = "Filthoid Flotante Ⅱ - Venganza",
          TextMapId = "Mon_Name_6013018"
        },
        Mon_Name_6013019 = {
          ContentES = "Filthoid Flotante Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_6013019"
        },
        Mon_Name_6013020 = {
          ContentES = "Filthoid Flotante Ⅱ - Destello",
          TextMapId = "Mon_Name_6013020"
        },
        Mon_Name_6013021 = {
          ContentES = "Filthoid Flotante Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_6013021"
        },
        Mon_Name_6013022 = {
          ContentES = "Filthoid Flotante Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6013022"
        },
        Mon_Name_6013023 = {
          ContentES = "Filthoid Flotante Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_6013023"
        },
        Mon_Name_6013024 = {
          ContentES = "Filthoid Flotante Ⅱ - Fantasma",
          TextMapId = "Mon_Name_6013024"
        },
        Mon_Name_6013201 = {
          ContentES = "Filthoid Flotante Ⅱ - Congelación y Guardián",
          TextMapId = "Mon_Name_6013201"
        },
        Mon_Name_6013301 = {
          ContentES = "Filthoid Flotante Ⅱ - Putrefacción, Venganza y Guardián",
          TextMapId = "Mon_Name_6013301"
        },
        Mon_Name_6014001 = {
          ContentES = "Filthoid Salvaje Ⅱ",
          TextMapId = "Mon_Name_6014001"
        },
        Mon_Name_6014011 = {
          ContentES = "Filthoid Salvaje Ⅱ - Congelación",
          TextMapId = "Mon_Name_6014011"
        },
        Mon_Name_6014012 = {
          ContentES = "Filthoid Salvaje Ⅱ - Explosión",
          TextMapId = "Mon_Name_6014012"
        },
        Mon_Name_6014013 = {
          ContentES = "Filthoid Salvaje Ⅱ - Corrosión",
          TextMapId = "Mon_Name_6014013"
        },
        Mon_Name_6014014 = {
          ContentES = "Filthoid Salvaje Ⅱ - Trueno",
          TextMapId = "Mon_Name_6014014"
        },
        Mon_Name_6014015 = {
          ContentES = "Filthoid Salvaje Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_6014015"
        },
        Mon_Name_6014016 = {
          ContentES = "Filthoid Salvaje Ⅱ - Marchitar",
          TextMapId = "Mon_Name_6014016"
        },
        Mon_Name_6014017 = {
          ContentES = "Filthoid Salvaje Ⅱ - Guardián",
          TextMapId = "Mon_Name_6014017"
        },
        Mon_Name_6014018 = {
          ContentES = "Filthoid Salvaje Ⅱ - Venganza",
          TextMapId = "Mon_Name_6014018"
        },
        Mon_Name_6014019 = {
          ContentES = "Filthoid Salvaje Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_6014019"
        },
        Mon_Name_6014020 = {
          ContentES = "Filthoid Salvaje Ⅱ - Destello",
          TextMapId = "Mon_Name_6014020"
        },
        Mon_Name_6014021 = {
          ContentES = "Filthoid Salvaje Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_6014021"
        },
        Mon_Name_6014022 = {
          ContentES = "Filthoid Salvaje Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6014022"
        },
        Mon_Name_6014023 = {
          ContentES = "Filthoid Salvaje Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_6014023"
        },
        Mon_Name_6014024 = {
          ContentES = "Filthoid Salvaje Ⅱ - Fantasma",
          TextMapId = "Mon_Name_6014024"
        },
        Mon_Name_6014201 = {
          ContentES = "Filthoid Salvaje Ⅱ - Explosión e Infierno Gélido",
          TextMapId = "Mon_Name_6014201"
        },
        Mon_Name_6014301 = {
          ContentES = "Filthoid Salvaje Ⅱ - Trueno, Explosión e Infierno Gélido",
          TextMapId = "Mon_Name_6014301"
        },
        Mon_Name_6015001 = {
          ContentES = "Filthoid Flor de Ceniza",
          TextMapId = "Mon_Name_6015001"
        },
        Mon_Name_6015011 = {
          ContentES = "Filthoid Flor de Ceniza - Congelación",
          TextMapId = "Mon_Name_6015011"
        },
        Mon_Name_6015013 = {
          ContentES = "Filthoid Flor de Ceniza - Corrosión",
          TextMapId = "Mon_Name_6015013"
        },
        Mon_Name_6015015 = {
          ContentES = "Filthoid Flor de Ceniza - Putrefacción",
          TextMapId = "Mon_Name_6015015"
        },
        Mon_Name_6015016 = {
          ContentES = "Filthoid Flor de Ceniza - Marchitar",
          TextMapId = "Mon_Name_6015016"
        },
        Mon_Name_6015017 = {
          ContentES = "Filthoid Flor de Ceniza - Guardián",
          TextMapId = "Mon_Name_6015017"
        },
        Mon_Name_6015018 = {
          ContentES = "Filthoid Flor de Ceniza - Venganza",
          TextMapId = "Mon_Name_6015018"
        },
        Mon_Name_6015019 = {
          ContentES = "Filthoid Flor de Ceniza - Infierno Gélido",
          TextMapId = "Mon_Name_6015019"
        },
        Mon_Name_6015021 = {
          ContentES = "Filthoid Flor de Ceniza - Sacrificio",
          TextMapId = "Mon_Name_6015021"
        },
        Mon_Name_6015022 = {
          ContentES = "Filthoid Flor de Ceniza - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6015022"
        },
        Mon_Name_6015023 = {
          ContentES = "Filthoid Flor de Ceniza - Baño de Sangre",
          TextMapId = "Mon_Name_6015023"
        },
        Mon_Name_6015024 = {
          ContentES = "Filthoid Flor de Ceniza - Fantasma",
          TextMapId = "Mon_Name_6015024"
        },
        Mon_Name_6016001 = {
          ContentES = "Filthoid de Cáliz Marchito",
          TextMapId = "Mon_Name_6016001"
        },
        Mon_Name_6016011 = {
          ContentES = "Filthoid de Cáliz Marchito - Congelación",
          TextMapId = "Mon_Name_6016011"
        },
        Mon_Name_6016013 = {
          ContentES = "Filthoid de Cáliz Marchito - Corrosión",
          TextMapId = "Mon_Name_6016013"
        },
        Mon_Name_6016015 = {
          ContentES = "Filthoid de Cáliz Marchito - Putrefacción",
          TextMapId = "Mon_Name_6016015"
        },
        Mon_Name_6016016 = {
          ContentES = "Filthoid de Cáliz Marchito - Marchitar",
          TextMapId = "Mon_Name_6016016"
        },
        Mon_Name_6016017 = {
          ContentES = "Filthoid de Cáliz Marchito - Guardián",
          TextMapId = "Mon_Name_6016017"
        },
        Mon_Name_6016018 = {
          ContentES = "Filthoid de Cáliz Marchito - Venganza",
          TextMapId = "Mon_Name_6016018"
        },
        Mon_Name_6016019 = {
          ContentES = "Filthoid de Cáliz Marchito - Infierno Gélido",
          TextMapId = "Mon_Name_6016019"
        },
        Mon_Name_6016021 = {
          ContentES = "Filthoid de Cáliz Marchito - Sacrificio",
          TextMapId = "Mon_Name_6016021"
        },
        Mon_Name_6016022 = {
          ContentES = "Filthoid de Cáliz Marchito - Tormenta Eléctrica",
          TextMapId = "Mon_Name_6016022"
        },
        Mon_Name_6016023 = {
          ContentES = "Filthoid de Cáliz Marchito - Baño de Sangre",
          TextMapId = "Mon_Name_6016023"
        },
        Mon_Name_6016024 = {
          ContentES = "Filthoid de Cáliz Marchito - Fantasma",
          TextMapId = "Mon_Name_6016024"
        },
        Mon_Name_6017001 = {
          ContentES = "Filthoid Estigma",
          TextMapId = "Mon_Name_6017001"
        },
        Mon_Name_6017011 = {
          ContentES = "Filthoid Estigma - Congelación",
          TextMapId = "Mon_Name_6017011"
        },
        Mon_Name_6017012 = {
          ContentES = "Filthoid Estigma - Explosión",
          TextMapId = "Mon_Name_6017012"
        },
        Mon_Name_6017014 = {
          ContentES = "Filthoid Estigma - Trueno",
          TextMapId = "Mon_Name_6017014"
        },
        Mon_Name_6017016 = {
          ContentES = "Filthoid Estigma - Marchitar",
          TextMapId = "Mon_Name_6017016"
        },
        Mon_Name_6017017 = {
          ContentES = "Filthoid Estigma - Guardián",
          TextMapId = "Mon_Name_6017017"
        },
        Mon_Name_6017018 = {
          ContentES = "Filthoid Estigma - Venganza",
          TextMapId = "Mon_Name_6017018"
        },
        Mon_Name_6017019 = {
          ContentES = "Filthoid Estigma - Infierno Gélido",
          TextMapId = "Mon_Name_6017019"
        },
        Mon_Name_6017020 = {
          ContentES = "Filthoid Estigma - Destello",
          TextMapId = "Mon_Name_6017020"
        },
        Mon_Name_6017021 = {
          ContentES = "Filthoid Estigma - Sacrificio",
          TextMapId = "Mon_Name_6017021"
        },
        Mon_Name_6017023 = {
          ContentES = "Filthoid Estigma - Baño de Sangre",
          TextMapId = "Mon_Name_6017023"
        },
        Mon_Name_6017024 = {
          ContentES = "Filthoid Estigma - Fantasma",
          TextMapId = "Mon_Name_6017024"
        },
        Mon_Name_7001001 = {
          ContentES = "Soldado Francotirador",
          TextMapId = "Mon_Name_7001001"
        },
        Mon_Name_7001005 = {
          ContentES = "Soldado Francotirador - Sigilo",
          TextMapId = "Mon_Name_7001005"
        },
        Mon_Name_7001011 = {
          ContentES = "Soldado Francotirador - Congelación",
          TextMapId = "Mon_Name_7001011"
        },
        Mon_Name_7001012 = {
          ContentES = "Soldado Francotirador - Explosión",
          TextMapId = "Mon_Name_7001012"
        },
        Mon_Name_7001013 = {
          ContentES = "Soldado Francotirador - Corrosión",
          TextMapId = "Mon_Name_7001013"
        },
        Mon_Name_7001014 = {
          ContentES = "Soldado Francotirador - Trueno",
          TextMapId = "Mon_Name_7001014"
        },
        Mon_Name_7001015 = {
          ContentES = "Soldado Francotirador - Putrefacción",
          TextMapId = "Mon_Name_7001015"
        },
        Mon_Name_7001016 = {
          ContentES = "Soldado Francotirador - Marchitar",
          TextMapId = "Mon_Name_7001016"
        },
        Mon_Name_7001017 = {
          ContentES = "Soldado Francotirador - Guardián",
          TextMapId = "Mon_Name_7001017"
        },
        Mon_Name_7001018 = {
          ContentES = "Soldado Francotirador - Venganza",
          TextMapId = "Mon_Name_7001018"
        },
        Mon_Name_7001019 = {
          ContentES = "Soldado Francotirador - Infierno Gélido",
          TextMapId = "Mon_Name_7001019"
        },
        Mon_Name_7001020 = {
          ContentES = "Soldado Francotirador - Destello",
          TextMapId = "Mon_Name_7001020"
        },
        Mon_Name_7001021 = {
          ContentES = "Soldado Francotirador - Sacrificio",
          TextMapId = "Mon_Name_7001021"
        },
        Mon_Name_7001022 = {
          ContentES = "Soldado Francotirador - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7001022"
        },
        Mon_Name_7001023 = {
          ContentES = "Soldado Francotirador - Baño de Sangre",
          TextMapId = "Mon_Name_7001023"
        },
        Mon_Name_7001024 = {
          ContentES = "Soldado Francotirador - Fantasma",
          TextMapId = "Mon_Name_7001024"
        },
        Mon_Name_7001201 = {
          ContentES = "Soldado Francotirador - Tormenta Eléctrica y Guardián",
          TextMapId = "Mon_Name_7001201"
        },
        Mon_Name_7001301 = {
          ContentES = "Soldado Francotirador - Putrefacción, Marchitar y Congelación",
          TextMapId = "Mon_Name_7001301"
        },
        Mon_Name_7002001 = {
          ContentES = "Soldado Hendedor",
          TextMapId = "Mon_Name_7002001"
        },
        Mon_Name_7002005 = {
          ContentES = "Soldado Hendedor - Belicoso",
          TextMapId = "Mon_Name_7002005"
        },
        Mon_Name_7002011 = {
          ContentES = "Soldado Hendedor - Congelación",
          TextMapId = "Mon_Name_7002011"
        },
        Mon_Name_7002012 = {
          ContentES = "Soldado Hendedor - Explosión",
          TextMapId = "Mon_Name_7002012"
        },
        Mon_Name_7002013 = {
          ContentES = "Soldado Hendedor - Corrosión",
          TextMapId = "Mon_Name_7002013"
        },
        Mon_Name_7002014 = {
          ContentES = "Soldado Hendedor - Trueno",
          TextMapId = "Mon_Name_7002014"
        },
        Mon_Name_7002015 = {
          ContentES = "Soldado Hendedor - Putrefacción",
          TextMapId = "Mon_Name_7002015"
        },
        Mon_Name_7002016 = {
          ContentES = "Soldado Hendedor - Marchitar",
          TextMapId = "Mon_Name_7002016"
        },
        Mon_Name_7002017 = {
          ContentES = "Soldado Hendedor - Guardián",
          TextMapId = "Mon_Name_7002017"
        },
        Mon_Name_7002018 = {
          ContentES = "Soldado Hendedor - Venganza",
          TextMapId = "Mon_Name_7002018"
        },
        Mon_Name_7002019 = {
          ContentES = "Soldado Hendedor - Infierno Gélido",
          TextMapId = "Mon_Name_7002019"
        },
        Mon_Name_7002020 = {
          ContentES = "Soldado Hendedor - Destello",
          TextMapId = "Mon_Name_7002020"
        },
        Mon_Name_7002021 = {
          ContentES = "Soldado Hendedor - Sacrificio",
          TextMapId = "Mon_Name_7002021"
        },
        Mon_Name_7002022 = {
          ContentES = "Soldado Hendedor - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7002022"
        },
        Mon_Name_7002023 = {
          ContentES = "Soldado Hendedor - Baño de Sangre",
          TextMapId = "Mon_Name_7002023"
        },
        Mon_Name_7002024 = {
          ContentES = "Soldado Hendedor - Fantasma",
          TextMapId = "Mon_Name_7002024"
        },
        Mon_Name_7002201 = {
          ContentES = "Soldado Hendedor - Trueno y Congelación",
          TextMapId = "Mon_Name_7002201"
        },
        Mon_Name_7002301 = {
          ContentES = "Soldado Hendedor - Marchitar, Guardián y Putrefacción",
          TextMapId = "Mon_Name_7002301"
        },
        Mon_Name_7003001 = {
          ContentES = "Soldado Explorador",
          TextMapId = "Mon_Name_7003001"
        },
        Mon_Name_7003005 = {
          ContentES = "Soldado Explorador - Asalto Armado",
          TextMapId = "Mon_Name_7003005"
        },
        Mon_Name_7003011 = {
          ContentES = "Soldado Explorador - Congelación",
          TextMapId = "Mon_Name_7003011"
        },
        Mon_Name_7003012 = {
          ContentES = "Soldado Explorador - Explosión",
          TextMapId = "Mon_Name_7003012"
        },
        Mon_Name_7003013 = {
          ContentES = "Soldado Explorador - Corrosión",
          TextMapId = "Mon_Name_7003013"
        },
        Mon_Name_7003014 = {
          ContentES = "Soldado Explorador - Trueno",
          TextMapId = "Mon_Name_7003014"
        },
        Mon_Name_7003015 = {
          ContentES = "Soldado Explorador - Putrefacción",
          TextMapId = "Mon_Name_7003015"
        },
        Mon_Name_7003016 = {
          ContentES = "Soldado Explorador - Marchitar",
          TextMapId = "Mon_Name_7003016"
        },
        Mon_Name_7003017 = {
          ContentES = "Soldado Explorador - Guardián",
          TextMapId = "Mon_Name_7003017"
        },
        Mon_Name_7003018 = {
          ContentES = "Soldado Explorador - Venganza",
          TextMapId = "Mon_Name_7003018"
        },
        Mon_Name_7003019 = {
          ContentES = "Soldado Explorador - Infierno Gélido",
          TextMapId = "Mon_Name_7003019"
        },
        Mon_Name_7003020 = {
          ContentES = "Soldado Explorador - Destello",
          TextMapId = "Mon_Name_7003020"
        },
        Mon_Name_7003021 = {
          ContentES = "Soldado Explorador - Sacrificio",
          TextMapId = "Mon_Name_7003021"
        },
        Mon_Name_7003022 = {
          ContentES = "Soldado Explorador - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7003022"
        },
        Mon_Name_7003023 = {
          ContentES = "Soldado Explorador - Baño de Sangre",
          TextMapId = "Mon_Name_7003023"
        },
        Mon_Name_7003024 = {
          ContentES = "Soldado Explorador - Fantasma",
          TextMapId = "Mon_Name_7003024"
        },
        Mon_Name_7003201 = {
          ContentES = "Soldado Explorador - Baño de Sangre y Explosión",
          TextMapId = "Mon_Name_7003201"
        },
        Mon_Name_7003301 = {
          ContentES = "Soldado Explorador - Fantasma, Tormenta Eléctrica e Infierno Gélido",
          TextMapId = "Mon_Name_7003301"
        },
        Mon_Name_7004001 = {
          ContentES = "Soldado de Asalto",
          TextMapId = "Mon_Name_7004001"
        },
        Mon_Name_7004011 = {
          ContentES = "Soldado de Asalto - Congelación",
          TextMapId = "Mon_Name_7004011"
        },
        Mon_Name_7004012 = {
          ContentES = "Soldado de Asalto - Explosión",
          TextMapId = "Mon_Name_7004012"
        },
        Mon_Name_7004013 = {
          ContentES = "Soldado de Asalto - Corrosión",
          TextMapId = "Mon_Name_7004013"
        },
        Mon_Name_7004014 = {
          ContentES = "Soldado de Asalto - Trueno",
          TextMapId = "Mon_Name_7004014"
        },
        Mon_Name_7004015 = {
          ContentES = "Soldado de Asalto - Putrefacción",
          TextMapId = "Mon_Name_7004015"
        },
        Mon_Name_7004016 = {
          ContentES = "Soldado de Asalto - Marchitar",
          TextMapId = "Mon_Name_7004016"
        },
        Mon_Name_7004017 = {
          ContentES = "Soldado de Asalto - Guardián",
          TextMapId = "Mon_Name_7004017"
        },
        Mon_Name_7004018 = {
          ContentES = "Soldado de Asalto - Venganza",
          TextMapId = "Mon_Name_7004018"
        },
        Mon_Name_7004019 = {
          ContentES = "Soldado de Asalto - Infierno Gélido",
          TextMapId = "Mon_Name_7004019"
        },
        Mon_Name_7004020 = {
          ContentES = "Soldado de Asalto - Destello",
          TextMapId = "Mon_Name_7004020"
        },
        Mon_Name_7004021 = {
          ContentES = "Soldado de Asalto - Sacrificio",
          TextMapId = "Mon_Name_7004021"
        },
        Mon_Name_7004022 = {
          ContentES = "Soldado de Asalto - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7004022"
        },
        Mon_Name_7004023 = {
          ContentES = "Soldado de Asalto - Baño de Sangre",
          TextMapId = "Mon_Name_7004023"
        },
        Mon_Name_7004024 = {
          ContentES = "Soldado de Asalto - Fantasma",
          TextMapId = "Mon_Name_7004024"
        },
        Mon_Name_7004201 = {
          ContentES = "Soldado de Asalto - Destello e Infierno Gélido",
          TextMapId = "Mon_Name_7004201"
        },
        Mon_Name_7004301 = {
          ContentES = "Soldado de Asalto - Fantasma, Destello e Infierno Gélido",
          TextMapId = "Mon_Name_7004301"
        },
        Mon_Name_7006001 = {
          ContentES = "Dron curativo",
          TextMapId = "Mon_Name_7006001"
        }
      }
    end
  },
  {
    MinKey = "Mon_Name_7007001",
    MaxKey = "Mon_Name_8501015",
    Loader = function()
      return {
        Mon_Name_7007001 = {
          ContentES = "Dron magnético",
          TextMapId = "Mon_Name_7007001"
        },
        Mon_Name_7007002 = {
          ContentES = "Dron magnético Ⅱ",
          TextMapId = "Mon_Name_7007002"
        },
        Mon_Name_7008001 = {
          ContentES = "Sargento de Élite",
          TextMapId = "Mon_Name_7008001"
        },
        Mon_Name_7008011 = {
          ContentES = "Sargento de Élite - Congelación",
          TextMapId = "Mon_Name_7008011"
        },
        Mon_Name_7008012 = {
          ContentES = "Sargento de Élite - Explosión",
          TextMapId = "Mon_Name_7008012"
        },
        Mon_Name_7008013 = {
          ContentES = "Sargento de Élite - Corrosión",
          TextMapId = "Mon_Name_7008013"
        },
        Mon_Name_7008014 = {
          ContentES = "Sargento de Élite - Trueno",
          TextMapId = "Mon_Name_7008014"
        },
        Mon_Name_7008015 = {
          ContentES = "Sargento de Élite - Putrefacción",
          TextMapId = "Mon_Name_7008015"
        },
        Mon_Name_7008016 = {
          ContentES = "Sargento de Élite - Marchitar",
          TextMapId = "Mon_Name_7008016"
        },
        Mon_Name_7008017 = {
          ContentES = "Sargento de Élite - Guardián",
          TextMapId = "Mon_Name_7008017"
        },
        Mon_Name_7008018 = {
          ContentES = "Sargento de Élite - Venganza",
          TextMapId = "Mon_Name_7008018"
        },
        Mon_Name_7008019 = {
          ContentES = "Sargento de Élite - Infierno Gélido",
          TextMapId = "Mon_Name_7008019"
        },
        Mon_Name_7008020 = {
          ContentES = "Sargento de Élite - Destello",
          TextMapId = "Mon_Name_7008020"
        },
        Mon_Name_7008021 = {
          ContentES = "Sargento de Élite - Sacrificio",
          TextMapId = "Mon_Name_7008021"
        },
        Mon_Name_7008022 = {
          ContentES = "Sargento de Élite - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7008022"
        },
        Mon_Name_7008023 = {
          ContentES = "Sargento de Élite - Baño de Sangre",
          TextMapId = "Mon_Name_7008023"
        },
        Mon_Name_7008024 = {
          ContentES = "Sargento de Élite - Fantasma",
          TextMapId = "Mon_Name_7008024"
        },
        Mon_Name_7008051 = {
          ContentES = "Clive",
          TextMapId = "Mon_Name_7008051"
        },
        Mon_Name_7008201 = {
          ContentES = "Sargento de Élite - Sacrificio y Guardián",
          TextMapId = "Mon_Name_7008201"
        },
        Mon_Name_7008301 = {
          ContentES = "Sargento de Élite - Baño de Sangre, Fantasma y Venganza",
          TextMapId = "Mon_Name_7008301"
        },
        Mon_Name_7009001 = {
          ContentES = "Tirano Benevolente",
          TextMapId = "Mon_Name_7009001"
        },
        Mon_Name_7009011 = {
          ContentES = "Tirano Benevolente - Congelación",
          TextMapId = "Mon_Name_7009011"
        },
        Mon_Name_7009012 = {
          ContentES = "Tirano Benevolente - Explosión",
          TextMapId = "Mon_Name_7009012"
        },
        Mon_Name_7009013 = {
          ContentES = "Tirano Benevolente - Corrosión",
          TextMapId = "Mon_Name_7009013"
        },
        Mon_Name_7009014 = {
          ContentES = "Tirano Benevolente - Trueno",
          TextMapId = "Mon_Name_7009014"
        },
        Mon_Name_7009015 = {
          ContentES = "Tirano Benevolente - Putrefacción",
          TextMapId = "Mon_Name_7009015"
        },
        Mon_Name_7009016 = {
          ContentES = "Tirano Benevolente - Marchitar",
          TextMapId = "Mon_Name_7009016"
        },
        Mon_Name_7009017 = {
          ContentES = "Tirano Benevolente - Guardián",
          TextMapId = "Mon_Name_7009017"
        },
        Mon_Name_7009018 = {
          ContentES = "Tirano Benevolente - Venganza",
          TextMapId = "Mon_Name_7009018"
        },
        Mon_Name_7009019 = {
          ContentES = "Tirano Benevolente - Infierno Gélido",
          TextMapId = "Mon_Name_7009019"
        },
        Mon_Name_7009020 = {
          ContentES = "Tirano Benevolente - Destello",
          TextMapId = "Mon_Name_7009020"
        },
        Mon_Name_7009021 = {
          ContentES = "Tirano Benevolente - Sacrificio",
          TextMapId = "Mon_Name_7009021"
        },
        Mon_Name_7009022 = {
          ContentES = "Tirano Benevolente - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7009022"
        },
        Mon_Name_7009023 = {
          ContentES = "Tirano Benevolente - Baño de Sangre",
          TextMapId = "Mon_Name_7009023"
        },
        Mon_Name_7009024 = {
          ContentES = "Tirano Benevolente - Fantasma",
          TextMapId = "Mon_Name_7009024"
        },
        Mon_Name_7009201 = {
          ContentES = "Tirano Benevolente - Trueno y Explosión",
          TextMapId = "Mon_Name_7009201"
        },
        Mon_Name_7009301 = {
          ContentES = "Tirano Benevolente - Baño de Sangre, Destello e Infierno Gélido",
          TextMapId = "Mon_Name_7009301"
        },
        Mon_Name_7010001 = {
          ContentES = "Alquimista Spathatoi",
          TextMapId = "Mon_Name_7010001"
        },
        Mon_Name_7010011 = {
          ContentES = "Alquimista Spathatoi - Congelación",
          TextMapId = "Mon_Name_7010011"
        },
        Mon_Name_7010012 = {
          ContentES = "Alquimista Spathatoi - Explosión",
          TextMapId = "Mon_Name_7010012"
        },
        Mon_Name_7010013 = {
          ContentES = "Alquimista Spathatoi - Corrosión",
          TextMapId = "Mon_Name_7010013"
        },
        Mon_Name_7010014 = {
          ContentES = "Alquimista Spathatoi - Trueno",
          TextMapId = "Mon_Name_7010014"
        },
        Mon_Name_7010015 = {
          ContentES = "Alquimista Spathatoi - Putrefacción",
          TextMapId = "Mon_Name_7010015"
        },
        Mon_Name_7010016 = {
          ContentES = "Alquimista Spathatoi - Marchitar",
          TextMapId = "Mon_Name_7010016"
        },
        Mon_Name_7010017 = {
          ContentES = "Alquimista Spathatoi - Guardián",
          TextMapId = "Mon_Name_7010017"
        },
        Mon_Name_7010018 = {
          ContentES = "Alquimista Spathatoi - Venganza",
          TextMapId = "Mon_Name_7010018"
        },
        Mon_Name_7010019 = {
          ContentES = "Alquimista Spathatoi - Infierno Gélido",
          TextMapId = "Mon_Name_7010019"
        },
        Mon_Name_7010020 = {
          ContentES = "Alquimista Spathatoi - Destello",
          TextMapId = "Mon_Name_7010020"
        },
        Mon_Name_7010021 = {
          ContentES = "Alquimista Spathatoi - Sacrificio",
          TextMapId = "Mon_Name_7010021"
        },
        Mon_Name_7010022 = {
          ContentES = "Alquimista Spathatoi - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7010022"
        },
        Mon_Name_7010023 = {
          ContentES = "Alquimista Spathatoi - Baño de Sangre",
          TextMapId = "Mon_Name_7010023"
        },
        Mon_Name_7010024 = {
          ContentES = "Alquimista Spathatoi - Fantasma",
          TextMapId = "Mon_Name_7010024"
        },
        Mon_Name_7010201 = {
          ContentES = "Alquimista Spathatoi - Putrefacción y Venganza",
          TextMapId = "Mon_Name_7010201"
        },
        Mon_Name_7010301 = {
          ContentES = "Alquimista Spathatoi - Tormenta Eléctrica, Venganza y Guardián",
          TextMapId = "Mon_Name_7010301"
        },
        Mon_Name_7011001 = {
          ContentES = "Soldado Francotirador Ⅱ",
          TextMapId = "Mon_Name_7011001"
        },
        Mon_Name_7011011 = {
          ContentES = "Soldado Francotirador Ⅱ - Congelación",
          TextMapId = "Mon_Name_7011011"
        },
        Mon_Name_7011012 = {
          ContentES = "Soldado Francotirador Ⅱ - Explosión",
          TextMapId = "Mon_Name_7011012"
        },
        Mon_Name_7011013 = {
          ContentES = "Soldado Francotirador Ⅱ - Corrosión",
          TextMapId = "Mon_Name_7011013"
        },
        Mon_Name_7011014 = {
          ContentES = "Soldado Francotirador Ⅱ - Trueno",
          TextMapId = "Mon_Name_7011014"
        },
        Mon_Name_7011015 = {
          ContentES = "Soldado Francotirador Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_7011015"
        },
        Mon_Name_7011016 = {
          ContentES = "Soldado Francotirador Ⅱ - Marchitar",
          TextMapId = "Mon_Name_7011016"
        },
        Mon_Name_7011017 = {
          ContentES = "Soldado Francotirador Ⅱ - Guardián",
          TextMapId = "Mon_Name_7011017"
        },
        Mon_Name_7011018 = {
          ContentES = "Soldado Francotirador Ⅱ - Venganza",
          TextMapId = "Mon_Name_7011018"
        },
        Mon_Name_7011019 = {
          ContentES = "Soldado Francotirador Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_7011019"
        },
        Mon_Name_7011020 = {
          ContentES = "Soldado Francotirador Ⅱ - Destello",
          TextMapId = "Mon_Name_7011020"
        },
        Mon_Name_7011021 = {
          ContentES = "Soldado Francotirador Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_7011021"
        },
        Mon_Name_7011022 = {
          ContentES = "Soldado Francotirador Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7011022"
        },
        Mon_Name_7011023 = {
          ContentES = "Soldado Francotirador Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_7011023"
        },
        Mon_Name_7011024 = {
          ContentES = "Soldado Francotirador Ⅱ - Fantasma",
          TextMapId = "Mon_Name_7011024"
        },
        Mon_Name_7011201 = {
          ContentES = "Soldado Francotirador Ⅱ - Tormenta Eléctrica y Guardián",
          TextMapId = "Mon_Name_7011201"
        },
        Mon_Name_7011301 = {
          ContentES = "Soldado Francotirador Ⅱ - Putrefacción, Marchitar y Congelación",
          TextMapId = "Mon_Name_7011301"
        },
        Mon_Name_7012001 = {
          ContentES = "Soldado Hendedor Ⅱ",
          TextMapId = "Mon_Name_7012001"
        },
        Mon_Name_7012011 = {
          ContentES = "Soldado Hendedor Ⅱ - Congelación",
          TextMapId = "Mon_Name_7012011"
        },
        Mon_Name_7012012 = {
          ContentES = "Soldado Hendedor Ⅱ - Explosión",
          TextMapId = "Mon_Name_7012012"
        },
        Mon_Name_7012013 = {
          ContentES = "Soldado Hendedor Ⅱ - Corrosión",
          TextMapId = "Mon_Name_7012013"
        },
        Mon_Name_7012014 = {
          ContentES = "Soldado Hendedor Ⅱ - Trueno",
          TextMapId = "Mon_Name_7012014"
        },
        Mon_Name_7012015 = {
          ContentES = "Soldado Hendedor Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_7012015"
        },
        Mon_Name_7012016 = {
          ContentES = "Soldado Hendedor Ⅱ - Marchitar",
          TextMapId = "Mon_Name_7012016"
        },
        Mon_Name_7012017 = {
          ContentES = "Soldado Hendedor Ⅱ - Guardián",
          TextMapId = "Mon_Name_7012017"
        },
        Mon_Name_7012018 = {
          ContentES = "Soldado Hendedor Ⅱ - Venganza",
          TextMapId = "Mon_Name_7012018"
        },
        Mon_Name_7012019 = {
          ContentES = "Soldado Hendedor Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_7012019"
        },
        Mon_Name_7012020 = {
          ContentES = "Soldado Hendedor Ⅱ - Destello",
          TextMapId = "Mon_Name_7012020"
        },
        Mon_Name_7012021 = {
          ContentES = "Soldado Hendedor Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_7012021"
        },
        Mon_Name_7012022 = {
          ContentES = "Soldado Hendedor Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7012022"
        },
        Mon_Name_7012023 = {
          ContentES = "Soldado Hendedor Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_7012023"
        },
        Mon_Name_7012024 = {
          ContentES = "Soldado Hendedor Ⅱ - Fantasma",
          TextMapId = "Mon_Name_7012024"
        },
        Mon_Name_7012201 = {
          ContentES = "Soldado Hendedor Ⅱ - Trueno y Congelación",
          TextMapId = "Mon_Name_7012201"
        },
        Mon_Name_7012301 = {
          ContentES = "Soldado Hendedor Ⅱ - Marchitar, Guardián y Putrefacción",
          TextMapId = "Mon_Name_7012301"
        },
        Mon_Name_7013001 = {
          ContentES = "Soldado Explorador Ⅱ",
          TextMapId = "Mon_Name_7013001"
        },
        Mon_Name_7013011 = {
          ContentES = "Soldado Explorador Ⅱ - Congelación",
          TextMapId = "Mon_Name_7013011"
        },
        Mon_Name_7013012 = {
          ContentES = "Soldado Explorador Ⅱ - Explosión",
          TextMapId = "Mon_Name_7013012"
        },
        Mon_Name_7013013 = {
          ContentES = "Soldado Explorador Ⅱ - Corrosión",
          TextMapId = "Mon_Name_7013013"
        },
        Mon_Name_7013014 = {
          ContentES = "Soldado Explorador Ⅱ - Trueno",
          TextMapId = "Mon_Name_7013014"
        },
        Mon_Name_7013015 = {
          ContentES = "Soldado Explorador Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_7013015"
        },
        Mon_Name_7013016 = {
          ContentES = "Soldado Explorador Ⅱ - Marchitar",
          TextMapId = "Mon_Name_7013016"
        },
        Mon_Name_7013017 = {
          ContentES = "Soldado Explorador Ⅱ - Guardián",
          TextMapId = "Mon_Name_7013017"
        },
        Mon_Name_7013018 = {
          ContentES = "Soldado Explorador Ⅱ - Venganza",
          TextMapId = "Mon_Name_7013018"
        },
        Mon_Name_7013019 = {
          ContentES = "Soldado Explorador Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_7013019"
        },
        Mon_Name_7013020 = {
          ContentES = "Soldado Explorador Ⅱ - Destello",
          TextMapId = "Mon_Name_7013020"
        },
        Mon_Name_7013021 = {
          ContentES = "Soldado Explorador Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_7013021"
        },
        Mon_Name_7013022 = {
          ContentES = "Soldado Explorador Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7013022"
        },
        Mon_Name_7013023 = {
          ContentES = "Soldado Explorador Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_7013023"
        },
        Mon_Name_7013024 = {
          ContentES = "Soldado Explorador Ⅱ - Fantasma",
          TextMapId = "Mon_Name_7013024"
        },
        Mon_Name_7013201 = {
          ContentES = "Soldado Explorador Ⅱ - Baño de Sangre y Explosión",
          TextMapId = "Mon_Name_7013201"
        },
        Mon_Name_7013301 = {
          ContentES = "Soldado Explorador Ⅱ - Fantasma, Tormenta Eléctrica e Infierno Gélido",
          TextMapId = "Mon_Name_7013301"
        },
        Mon_Name_7014001 = {
          ContentES = "Soldado de Asalto Ⅱ",
          TextMapId = "Mon_Name_7014001"
        },
        Mon_Name_7014011 = {
          ContentES = "Soldado de Asalto Ⅱ - Congelación",
          TextMapId = "Mon_Name_7014011"
        },
        Mon_Name_7014012 = {
          ContentES = "Soldado de Asalto Ⅱ - Explosión",
          TextMapId = "Mon_Name_7014012"
        },
        Mon_Name_7014013 = {
          ContentES = "Soldado de Asalto Ⅱ - Corrosión",
          TextMapId = "Mon_Name_7014013"
        },
        Mon_Name_7014014 = {
          ContentES = "Soldado de Asalto Ⅱ - Trueno",
          TextMapId = "Mon_Name_7014014"
        },
        Mon_Name_7014015 = {
          ContentES = "Soldado de Asalto Ⅱ - Putrefacción",
          TextMapId = "Mon_Name_7014015"
        },
        Mon_Name_7014016 = {
          ContentES = "Soldado de Asalto Ⅱ - Marchitar",
          TextMapId = "Mon_Name_7014016"
        },
        Mon_Name_7014017 = {
          ContentES = "Soldado de Asalto Ⅱ - Guardián",
          TextMapId = "Mon_Name_7014017"
        },
        Mon_Name_7014018 = {
          ContentES = "Soldado de Asalto Ⅱ - Venganza",
          TextMapId = "Mon_Name_7014018"
        },
        Mon_Name_7014019 = {
          ContentES = "Soldado de Asalto Ⅱ - Infierno Gélido",
          TextMapId = "Mon_Name_7014019"
        },
        Mon_Name_7014020 = {
          ContentES = "Soldado de Asalto Ⅱ - Destello",
          TextMapId = "Mon_Name_7014020"
        },
        Mon_Name_7014021 = {
          ContentES = "Soldado de Asalto Ⅱ - Sacrificio",
          TextMapId = "Mon_Name_7014021"
        },
        Mon_Name_7014022 = {
          ContentES = "Soldado de Asalto Ⅱ - Tormenta Eléctrica",
          TextMapId = "Mon_Name_7014022"
        },
        Mon_Name_7014023 = {
          ContentES = "Soldado de Asalto Ⅱ - Baño de Sangre",
          TextMapId = "Mon_Name_7014023"
        },
        Mon_Name_7014024 = {
          ContentES = "Soldado de Asalto Ⅱ - Fantasma",
          TextMapId = "Mon_Name_7014024"
        },
        Mon_Name_7014201 = {
          ContentES = "Soldado de Asalto Ⅱ - Destello e Infierno Gélido",
          TextMapId = "Mon_Name_7014201"
        },
        Mon_Name_7014301 = {
          ContentES = "Soldado de Asalto Ⅱ - Fantasma, Destello e Infierno Gélido",
          TextMapId = "Mon_Name_7014301"
        },
        Mon_Name_7015001 = {
          ContentES = "Dron Patrullero",
          TextMapId = "Mon_Name_7015001"
        },
        Mon_Name_7015011 = {
          ContentES = "Dron Patrullero - Congelación",
          TextMapId = "Mon_Name_7015011"
        },
        Mon_Name_7015012 = {
          ContentES = "Dron Patrullero - Explosión",
          TextMapId = "Mon_Name_7015012"
        },
        Mon_Name_7015013 = {
          ContentES = "Dron Patrullero - Corrosión",
          TextMapId = "Mon_Name_7015013"
        },
        Mon_Name_7015014 = {
          ContentES = "Dron Patrullero - Trueno",
          TextMapId = "Mon_Name_7015014"
        },
        Mon_Name_7015015 = {
          ContentES = "Dron Patrullero - Putrefacción",
          TextMapId = "Mon_Name_7015015"
        },
        Mon_Name_7015016 = {
          ContentES = "Dron Patrullero - Marchitar",
          TextMapId = "Mon_Name_7015016"
        },
        Mon_Name_7015017 = {
          ContentES = "Dron Patrullero - Guardián",
          TextMapId = "Mon_Name_7015017"
        },
        Mon_Name_7015018 = {
          ContentES = "Dron Patrullero - Venganza",
          TextMapId = "Mon_Name_7015018"
        },
        Mon_Name_7015019 = {
          ContentES = "Dron Patrullero - Infierno Gélido",
          TextMapId = "Mon_Name_7015019"
        },
        Mon_Name_7015020 = {
          ContentES = "Dron Patrullero - Destello",
          TextMapId = "Mon_Name_7015020"
        },
        Mon_Name_7015021 = {
          ContentES = "Dron Patrullero - Sacrificio",
          TextMapId = "Mon_Name_7015021"
        },
        Mon_Name_7015022 = {
          ContentES = "Dron Patrullero- Tormenta Eléctrica",
          TextMapId = "Mon_Name_7015022"
        },
        Mon_Name_7015023 = {
          ContentES = "Dron Patrullero - Baño de Sangre",
          TextMapId = "Mon_Name_7015023"
        },
        Mon_Name_7015024 = {
          ContentES = "Dron Patrullero - Fantasma",
          TextMapId = "Mon_Name_7015024"
        },
        Mon_Name_7015201 = {
          ContentES = "Dron Patrullero - Venganza y Marchitar",
          TextMapId = "Mon_Name_7015201"
        },
        Mon_Name_7015301 = {
          ContentES = "Dron Patrullero - Venganza, Marchitar y Congelación",
          TextMapId = "Mon_Name_7015301"
        },
        Mon_Name_7016001 = {
          ContentES = "El Ojo de la Legión",
          TextMapId = "Mon_Name_7016001"
        },
        Mon_Name_8001001 = {
          ContentES = "Diácono Bendito",
          TextMapId = "Mon_Name_8001001"
        },
        Mon_Name_8001011 = {
          ContentES = "Diácono Bendito - Congelación",
          TextMapId = "Mon_Name_8001011"
        },
        Mon_Name_8001012 = {
          ContentES = "Diácono Bendito - Explosión",
          TextMapId = "Mon_Name_8001012"
        },
        Mon_Name_8001013 = {
          ContentES = "Diácono Bendito - Corrosión",
          TextMapId = "Mon_Name_8001013"
        },
        Mon_Name_8001014 = {
          ContentES = "Diácono Bendito - Trueno",
          TextMapId = "Mon_Name_8001014"
        },
        Mon_Name_8001015 = {
          ContentES = "Diácono Bendito - Putrefacción",
          TextMapId = "Mon_Name_8001015"
        },
        Mon_Name_8001016 = {
          ContentES = "Diácono Bendito - Marchitar",
          TextMapId = "Mon_Name_8001016"
        },
        Mon_Name_8001017 = {
          ContentES = "Diácono Bendito - Guardián",
          TextMapId = "Mon_Name_8001017"
        },
        Mon_Name_8001018 = {
          ContentES = "Diácono Bendito - Venganza",
          TextMapId = "Mon_Name_8001018"
        },
        Mon_Name_8001019 = {
          ContentES = "Diácono Bendito - Infierno Gélido",
          TextMapId = "Mon_Name_8001019"
        },
        Mon_Name_8001020 = {
          ContentES = "Diácono Bendito - Destello",
          TextMapId = "Mon_Name_8001020"
        },
        Mon_Name_8001021 = {
          ContentES = "Diácono Bendito - Sacrificio",
          TextMapId = "Mon_Name_8001021"
        },
        Mon_Name_8001022 = {
          ContentES = "Diácono Bendito - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8001022"
        },
        Mon_Name_8001023 = {
          ContentES = "Diácono Bendito - Baño de Sangre",
          TextMapId = "Mon_Name_8001023"
        },
        Mon_Name_8001024 = {
          ContentES = "Diácono Bendito - Fantasma",
          TextMapId = "Mon_Name_8001024"
        },
        Mon_Name_8001201 = {
          ContentES = "Diácono Bendito - Tormenta Eléctrica y Putrefacción",
          TextMapId = "Mon_Name_8001201"
        },
        Mon_Name_8001301 = {
          ContentES = "Diácono Bendito - Marchitar, Tormenta Eléctrica y Congelación",
          TextMapId = "Mon_Name_8001301"
        },
        Mon_Name_8002001 = {
          ContentES = "Vanguardia Bendita",
          TextMapId = "Mon_Name_8002001"
        },
        Mon_Name_8002011 = {
          ContentES = "Vanguardia Bendita - Congelación",
          TextMapId = "Mon_Name_8002011"
        },
        Mon_Name_8002012 = {
          ContentES = "Vanguardia Bendita - Explosión",
          TextMapId = "Mon_Name_8002012"
        },
        Mon_Name_8002013 = {
          ContentES = "Vanguardia Bendita - Corrosión",
          TextMapId = "Mon_Name_8002013"
        },
        Mon_Name_8002014 = {
          ContentES = "Vanguardia Bendita - Trueno",
          TextMapId = "Mon_Name_8002014"
        },
        Mon_Name_8002015 = {
          ContentES = "Vanguardia Bendita - Putrefacción",
          TextMapId = "Mon_Name_8002015"
        },
        Mon_Name_8002016 = {
          ContentES = "Vanguardia Bendita - Marchitar",
          TextMapId = "Mon_Name_8002016"
        },
        Mon_Name_8002017 = {
          ContentES = "Vanguardia Bendita - Guardián",
          TextMapId = "Mon_Name_8002017"
        },
        Mon_Name_8002018 = {
          ContentES = "Vanguardia Bendita - Venganza",
          TextMapId = "Mon_Name_8002018"
        },
        Mon_Name_8002019 = {
          ContentES = "Vanguardia Bendita - Infierno Gélido",
          TextMapId = "Mon_Name_8002019"
        },
        Mon_Name_8002020 = {
          ContentES = "Vanguardia Bendita - Destello",
          TextMapId = "Mon_Name_8002020"
        },
        Mon_Name_8002021 = {
          ContentES = "Vanguardia Bendita - Sacrificio",
          TextMapId = "Mon_Name_8002021"
        },
        Mon_Name_8002022 = {
          ContentES = "Vanguardia Bendita - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8002022"
        },
        Mon_Name_8002023 = {
          ContentES = "Vanguardia Bendita - Baño de Sangre",
          TextMapId = "Mon_Name_8002023"
        },
        Mon_Name_8002024 = {
          ContentES = "Vanguardia Bendita - Fantasma",
          TextMapId = "Mon_Name_8002024"
        },
        Mon_Name_8002201 = {
          ContentES = "Vanguardia Bendita - Trueno e Infierno Gélido",
          TextMapId = "Mon_Name_8002201"
        },
        Mon_Name_8002301 = {
          ContentES = "Vanguardia Bendita - Sacrificio, Fantasma y Trueno",
          TextMapId = "Mon_Name_8002301"
        },
        Mon_Name_8002701 = {
          ContentES = "Vanguardia Bendita - Trueno e Infierno Gélido",
          TextMapId = "Mon_Name_8002701"
        },
        Mon_Name_8003001 = {
          ContentES = "Sacerdote Bendito",
          TextMapId = "Mon_Name_8003001"
        },
        Mon_Name_8003011 = {
          ContentES = "Sacerdote Bendito - Congelación",
          TextMapId = "Mon_Name_8003011"
        },
        Mon_Name_8003012 = {
          ContentES = "Sacerdote Bendito - Explosión",
          TextMapId = "Mon_Name_8003012"
        },
        Mon_Name_8003013 = {
          ContentES = "Sacerdote Bendito - Corrosión",
          TextMapId = "Mon_Name_8003013"
        },
        Mon_Name_8003014 = {
          ContentES = "Sacerdote Bendito - Trueno",
          TextMapId = "Mon_Name_8003014"
        },
        Mon_Name_8003015 = {
          ContentES = "Sacerdote Bendito - Putrefacción",
          TextMapId = "Mon_Name_8003015"
        },
        Mon_Name_8003016 = {
          ContentES = "Sacerdote Bendito - Marchitar",
          TextMapId = "Mon_Name_8003016"
        },
        Mon_Name_8003017 = {
          ContentES = "Sacerdote Bendito - Guardián",
          TextMapId = "Mon_Name_8003017"
        },
        Mon_Name_8003018 = {
          ContentES = "Sacerdote Bendito - Venganza",
          TextMapId = "Mon_Name_8003018"
        },
        Mon_Name_8003019 = {
          ContentES = "Sacerdote Bendito - Infierno Gélido",
          TextMapId = "Mon_Name_8003019"
        },
        Mon_Name_8003020 = {
          ContentES = "Sacerdote Bendito - Destello",
          TextMapId = "Mon_Name_8003020"
        },
        Mon_Name_8003021 = {
          ContentES = "Sacerdote Bendito - Sacrificio",
          TextMapId = "Mon_Name_8003021"
        },
        Mon_Name_8003022 = {
          ContentES = "Sacerdote Bendito - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8003022"
        },
        Mon_Name_8003023 = {
          ContentES = "Sacerdote Bendito - Baño de Sangre",
          TextMapId = "Mon_Name_8003023"
        },
        Mon_Name_8003024 = {
          ContentES = "Sacerdote Bendito - Fantasma",
          TextMapId = "Mon_Name_8003024"
        },
        Mon_Name_8003201 = {
          ContentES = "Sacerdote Bendito - Putrefacción y Guardián",
          TextMapId = "Mon_Name_8003201"
        },
        Mon_Name_8003301 = {
          ContentES = "Sacerdote Bendito - Marchitar, Venganza y Guardián",
          TextMapId = "Mon_Name_8003301"
        },
        Mon_Name_8003701 = {
          ContentES = "Sacerdote Bendito - Marchitar y Guardián",
          TextMapId = "Mon_Name_8003701"
        },
        Mon_Name_8500001 = {
          ContentES = "Sibylle",
          TextMapId = "Mon_Name_8500001"
        },
        Mon_Name_8501001 = {
          ContentES = "Maestro de Batalla",
          TextMapId = "Mon_Name_8501001"
        },
        Mon_Name_8501011 = {
          ContentES = "Maestro de Batalla - Congelación",
          TextMapId = "Mon_Name_8501011"
        },
        Mon_Name_8501012 = {
          ContentES = "Maestro de Batalla - Explosión",
          TextMapId = "Mon_Name_8501012"
        },
        Mon_Name_8501013 = {
          ContentES = "Maestro de Batalla - Corrosión",
          TextMapId = "Mon_Name_8501013"
        },
        Mon_Name_8501014 = {
          ContentES = "Maestro de Batalla - Trueno",
          TextMapId = "Mon_Name_8501014"
        },
        Mon_Name_8501015 = {
          ContentES = "Maestro de Batalla - Putrefacción",
          TextMapId = "Mon_Name_8501015"
        }
      }
    end
  },
  {
    MinKey = "Mon_Name_8501016",
    MaxKey = "MonsterRushEvent_Wuyou_DungeonName04",
    Loader = function()
      return {
        Mon_Name_8501016 = {
          ContentES = "Maestro de Batalla - Marchitar",
          TextMapId = "Mon_Name_8501016"
        },
        Mon_Name_8501017 = {
          ContentES = "Maestro de Batalla - Guardián",
          TextMapId = "Mon_Name_8501017"
        },
        Mon_Name_8501018 = {
          ContentES = "Maestro de Batalla - Venganza",
          TextMapId = "Mon_Name_8501018"
        },
        Mon_Name_8501019 = {
          ContentES = "Maestro de Batalla - Infierno Gélido",
          TextMapId = "Mon_Name_8501019"
        },
        Mon_Name_8501020 = {
          ContentES = "Maestro de Batalla - Destello",
          TextMapId = "Mon_Name_8501020"
        },
        Mon_Name_8501021 = {
          ContentES = "Maestro de Batalla - Sacrificio",
          TextMapId = "Mon_Name_8501021"
        },
        Mon_Name_8501022 = {
          ContentES = "Maestro de Batalla - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8501022"
        },
        Mon_Name_8501023 = {
          ContentES = "Maestro de Batalla - Baño de Sangre",
          TextMapId = "Mon_Name_8501023"
        },
        Mon_Name_8501024 = {
          ContentES = "Maestro de Batalla - Fantasma",
          TextMapId = "Mon_Name_8501024"
        },
        Mon_Name_8501201 = {
          ContentES = "Maestro de Batalla - Guardián y Congelación",
          TextMapId = "Mon_Name_8501201"
        },
        Mon_Name_8501301 = {
          ContentES = "Maestro de Batalla - Fantasma, Putrefacción y Explosión",
          TextMapId = "Mon_Name_8501301"
        },
        Mon_Name_8502001 = {
          ContentES = "El Eclosionador",
          TextMapId = "Mon_Name_8502001"
        },
        Mon_Name_8503001 = {
          ContentES = "Cristalófilo",
          TextMapId = "Mon_Name_8503001"
        },
        Mon_Name_8504001 = {
          ContentES = "\"Psyche\"",
          TextMapId = "Mon_Name_8504001"
        },
        Mon_Name_8505001 = {
          ContentES = "La Alcaidesa del Infierno",
          TextMapId = "Mon_Name_8505001"
        },
        Mon_Name_8506001 = {
          ContentES = "\"El Pecador\"",
          TextMapId = "Mon_Name_8506001"
        },
        Mon_Name_8509001 = {
          ContentES = "¿¿¿???",
          TextMapId = "Mon_Name_8509001"
        },
        Mon_Name_8510001 = {
          ContentES = "Zhuyin",
          TextMapId = "Mon_Name_8510001"
        },
        Mon_Name_8511001 = {
          ContentES = "Taihao",
          TextMapId = "Mon_Name_8511001"
        },
        Mon_Name_8512001 = {
          ContentES = "\"Bestia del Campo de Nieve\"",
          TextMapId = "Mon_Name_8512001"
        },
        Mon_Name_8513001 = {
          ContentES = "Asceta Bendito",
          TextMapId = "Mon_Name_8513001"
        },
        Mon_Name_8513011 = {
          ContentES = "Asceta Bendito - Congelación",
          TextMapId = "Mon_Name_8513011"
        },
        Mon_Name_8513012 = {
          ContentES = "Asceta Bendito - Explosión",
          TextMapId = "Mon_Name_8513012"
        },
        Mon_Name_8513013 = {
          ContentES = "Asceta Bendito - Corrosión",
          TextMapId = "Mon_Name_8513013"
        },
        Mon_Name_8513014 = {
          ContentES = "Asceta Bendito - Trueno",
          TextMapId = "Mon_Name_8513014"
        },
        Mon_Name_8513015 = {
          ContentES = "Asceta Bendito - Putrefacción",
          TextMapId = "Mon_Name_8513015"
        },
        Mon_Name_8513016 = {
          ContentES = "Asceta Bendito - Marchitar",
          TextMapId = "Mon_Name_8513016"
        },
        Mon_Name_8513017 = {
          ContentES = "Asceta Bendito - Guardián",
          TextMapId = "Mon_Name_8513017"
        },
        Mon_Name_8513018 = {
          ContentES = "Asceta Bendito - Venganza",
          TextMapId = "Mon_Name_8513018"
        },
        Mon_Name_8513019 = {
          ContentES = "Asceta Bendito - Infierno Gélido",
          TextMapId = "Mon_Name_8513019"
        },
        Mon_Name_8513020 = {
          ContentES = "Asceta Bendito - Destello",
          TextMapId = "Mon_Name_8513020"
        },
        Mon_Name_8513021 = {
          ContentES = "Asceta Bendito - Sacrificio",
          TextMapId = "Mon_Name_8513021"
        },
        Mon_Name_8513022 = {
          ContentES = "Asceta Bendito - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8513022"
        },
        Mon_Name_8513023 = {
          ContentES = "Asceta Bendito - Baño de Sangre",
          TextMapId = "Mon_Name_8513023"
        },
        Mon_Name_8513024 = {
          ContentES = "Asceta Bendito - Fantasma",
          TextMapId = "Mon_Name_8513024"
        },
        Mon_Name_8514001 = {
          ContentES = "Juez Bendito",
          TextMapId = "Mon_Name_8514001"
        },
        Mon_Name_8514011 = {
          ContentES = "Juez Bendito - Congelación",
          TextMapId = "Mon_Name_8514011"
        },
        Mon_Name_8514012 = {
          ContentES = "Juez Bendito - Explosión",
          TextMapId = "Mon_Name_8514012"
        },
        Mon_Name_8514013 = {
          ContentES = "Juez Bendito - Corrosión",
          TextMapId = "Mon_Name_8514013"
        },
        Mon_Name_8514014 = {
          ContentES = "Juez Bendito - Trueno",
          TextMapId = "Mon_Name_8514014"
        },
        Mon_Name_8514015 = {
          ContentES = "Juez Bendito - Putrefacción",
          TextMapId = "Mon_Name_8514015"
        },
        Mon_Name_8514016 = {
          ContentES = "Juez Bendito - Marchitar",
          TextMapId = "Mon_Name_8514016"
        },
        Mon_Name_8514017 = {
          ContentES = "Juez Bendito - Guardián",
          TextMapId = "Mon_Name_8514017"
        },
        Mon_Name_8514018 = {
          ContentES = "Juez Bendito - Venganza",
          TextMapId = "Mon_Name_8514018"
        },
        Mon_Name_8514019 = {
          ContentES = "Juez Bendito - Infierno Gélido",
          TextMapId = "Mon_Name_8514019"
        },
        Mon_Name_8514020 = {
          ContentES = "Juez Bendito - Destello",
          TextMapId = "Mon_Name_8514020"
        },
        Mon_Name_8514021 = {
          ContentES = "Juez Bendito - Sacrificio",
          TextMapId = "Mon_Name_8514021"
        },
        Mon_Name_8514022 = {
          ContentES = "Juez Bendito - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8514022"
        },
        Mon_Name_8514023 = {
          ContentES = "Juez Bendito - Baño de Sangre",
          TextMapId = "Mon_Name_8514023"
        },
        Mon_Name_8514024 = {
          ContentES = "Juez Bendito - Fantasma",
          TextMapId = "Mon_Name_8514024"
        },
        Mon_Name_8514701 = {
          ContentES = "Juez Bendito - Trueno",
          TextMapId = "Mon_Name_8514701"
        },
        Mon_Name_8515001 = {
          ContentES = "El Devorador",
          TextMapId = "Mon_Name_8515001"
        },
        Mon_Name_8515011 = {
          ContentES = "El Devorador - Congelación",
          TextMapId = "Mon_Name_8515011"
        },
        Mon_Name_8515012 = {
          ContentES = "El Devorador - Explosión",
          TextMapId = "Mon_Name_8515012"
        },
        Mon_Name_8515013 = {
          ContentES = "El Devorador - Corrosión",
          TextMapId = "Mon_Name_8515013"
        },
        Mon_Name_8515014 = {
          ContentES = "El Devorador - Trueno",
          TextMapId = "Mon_Name_8515014"
        },
        Mon_Name_8515015 = {
          ContentES = "El Devorador - Putrefacción",
          TextMapId = "Mon_Name_8515015"
        },
        Mon_Name_8515016 = {
          ContentES = "El Devorador - Marchitar",
          TextMapId = "Mon_Name_8515016"
        },
        Mon_Name_8515017 = {
          ContentES = "El Devorador - Guardián",
          TextMapId = "Mon_Name_8515017"
        },
        Mon_Name_8515018 = {
          ContentES = "El Devorador - Venganza",
          TextMapId = "Mon_Name_8515018"
        },
        Mon_Name_8515019 = {
          ContentES = "El Devorador - Infierno Gélido",
          TextMapId = "Mon_Name_8515019"
        },
        Mon_Name_8515020 = {
          ContentES = "El Devorador - Destello",
          TextMapId = "Mon_Name_8515020"
        },
        Mon_Name_8515021 = {
          ContentES = "El Devorador - Sacrificio",
          TextMapId = "Mon_Name_8515021"
        },
        Mon_Name_8515022 = {
          ContentES = "El Devorador - Tormenta Eléctrica",
          TextMapId = "Mon_Name_8515022"
        },
        Mon_Name_8515023 = {
          ContentES = "El Devorador - Baño de Sangre",
          TextMapId = "Mon_Name_8515023"
        },
        Mon_Name_8515024 = {
          ContentES = "El Devorador - Fantasma",
          TextMapId = "Mon_Name_8515024"
        },
        Mon_Name_8518001 = {
          ContentES = "Umbral del Coloso",
          TextMapId = "Mon_Name_8518001"
        },
        Mon_Name_9001001 = {
          ContentES = "Espada del Enjambre",
          TextMapId = "Mon_Name_9001001"
        },
        Mon_Name_9001011 = {
          ContentES = "Espada del Enjambre - Congelación",
          TextMapId = "Mon_Name_9001011"
        },
        Mon_Name_9001012 = {
          ContentES = "Espada del Enjambre - Explosión",
          TextMapId = "Mon_Name_9001012"
        },
        Mon_Name_9001013 = {
          ContentES = "Espada del Enjambre - Corrosión",
          TextMapId = "Mon_Name_9001013"
        },
        Mon_Name_9001014 = {
          ContentES = "Espada del Enjambre - Trueno",
          TextMapId = "Mon_Name_9001014"
        },
        Mon_Name_9001015 = {
          ContentES = "Espada del Enjambre - Putrefacción",
          TextMapId = "Mon_Name_9001015"
        },
        Mon_Name_9001016 = {
          ContentES = "Espada del Enjambre - Marchitar",
          TextMapId = "Mon_Name_9001016"
        },
        Mon_Name_9001017 = {
          ContentES = "Espada del Enjambre - Guardián",
          TextMapId = "Mon_Name_9001017"
        },
        Mon_Name_9001018 = {
          ContentES = "Espada del Enjambre - Venganza",
          TextMapId = "Mon_Name_9001018"
        },
        Mon_Name_9001019 = {
          ContentES = "Espada del Enjambre - Infierno Gélido",
          TextMapId = "Mon_Name_9001019"
        },
        Mon_Name_9001020 = {
          ContentES = "Espada del Enjambre - Destello",
          TextMapId = "Mon_Name_9001020"
        },
        Mon_Name_9001021 = {
          ContentES = "Espada del Enjambre - Sacrificio",
          TextMapId = "Mon_Name_9001021"
        },
        Mon_Name_9001022 = {
          ContentES = "Espada del Enjambre - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9001022"
        },
        Mon_Name_9001023 = {
          ContentES = "Espada del Enjambre - Baño de Sangre",
          TextMapId = "Mon_Name_9001023"
        },
        Mon_Name_9001024 = {
          ContentES = "Espada del Enjambre - Fantasma",
          TextMapId = "Mon_Name_9001024"
        },
        Mon_Name_9001201 = {
          ContentES = "Espada del Enjambre - Baño de Sangre y Fantasma",
          TextMapId = "Mon_Name_9001201"
        },
        Mon_Name_9001301 = {
          ContentES = "Espada del Enjambre - Baño de Sangre, Explosión y Destello",
          TextMapId = "Mon_Name_9001301"
        },
        Mon_Name_9002001 = {
          ContentES = "Flecha del Enjambre",
          TextMapId = "Mon_Name_9002001"
        },
        Mon_Name_9002011 = {
          ContentES = "Flecha del Enjambre - Congelación",
          TextMapId = "Mon_Name_9002011"
        },
        Mon_Name_9002012 = {
          ContentES = "Flecha del Enjambre - Explosión",
          TextMapId = "Mon_Name_9002012"
        },
        Mon_Name_9002013 = {
          ContentES = "Flecha del Enjambre - Corrosión",
          TextMapId = "Mon_Name_9002013"
        },
        Mon_Name_9002014 = {
          ContentES = "Flecha del Enjambre - Trueno",
          TextMapId = "Mon_Name_9002014"
        },
        Mon_Name_9002015 = {
          ContentES = "Flecha del Enjambre - Putrefacción",
          TextMapId = "Mon_Name_9002015"
        },
        Mon_Name_9002016 = {
          ContentES = "Flecha del Enjambre - Marchitar",
          TextMapId = "Mon_Name_9002016"
        },
        Mon_Name_9002017 = {
          ContentES = "Flecha del Enjambre - Guardián",
          TextMapId = "Mon_Name_9002017"
        },
        Mon_Name_9002018 = {
          ContentES = "Flecha del Enjambre - Venganza",
          TextMapId = "Mon_Name_9002018"
        },
        Mon_Name_9002019 = {
          ContentES = "Flecha del Enjambre - Infierno Gélido",
          TextMapId = "Mon_Name_9002019"
        },
        Mon_Name_9002020 = {
          ContentES = "Flecha del Enjambre - Destello",
          TextMapId = "Mon_Name_9002020"
        },
        Mon_Name_9002021 = {
          ContentES = "Flecha del Enjambre - Sacrificio",
          TextMapId = "Mon_Name_9002021"
        },
        Mon_Name_9002022 = {
          ContentES = "Flecha del Enjambre - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9002022"
        },
        Mon_Name_9002023 = {
          ContentES = "Flecha del Enjambre - Baño de Sangre",
          TextMapId = "Mon_Name_9002023"
        },
        Mon_Name_9002024 = {
          ContentES = "Flecha del Enjambre - Fantasma",
          TextMapId = "Mon_Name_9002024"
        },
        Mon_Name_9002201 = {
          ContentES = "Flecha del Enjambre - Tormenta Eléctrica - Marchitar",
          TextMapId = "Mon_Name_9002201"
        },
        Mon_Name_9002301 = {
          ContentES = "Flecha del Enjambre - Fantasma, Tormenta Eléctrica y Putrefacción",
          TextMapId = "Mon_Name_9002301"
        },
        Mon_Name_9003001 = {
          ContentES = "Juguetero",
          TextMapId = "Mon_Name_9003001"
        },
        Mon_Name_9003011 = {
          ContentES = "\"Juguetero\" - Congelación",
          TextMapId = "Mon_Name_9003011"
        },
        Mon_Name_9003012 = {
          ContentES = "\"Juguetero\" - Explosión",
          TextMapId = "Mon_Name_9003012"
        },
        Mon_Name_9003013 = {
          ContentES = "\"Juguetero\" - Corrosión",
          TextMapId = "Mon_Name_9003013"
        },
        Mon_Name_9003014 = {
          ContentES = "\"Juguetero\" - Trueno",
          TextMapId = "Mon_Name_9003014"
        },
        Mon_Name_9003015 = {
          ContentES = "\"Juguetero\" - Putrefacción",
          TextMapId = "Mon_Name_9003015"
        },
        Mon_Name_9003016 = {
          ContentES = "\"Juguetero\" - Marchitar",
          TextMapId = "Mon_Name_9003016"
        },
        Mon_Name_9003017 = {
          ContentES = "\"Juguetero\" - Guardián",
          TextMapId = "Mon_Name_9003017"
        },
        Mon_Name_9003018 = {
          ContentES = "\"Juguetero\" - Venganza",
          TextMapId = "Mon_Name_9003018"
        },
        Mon_Name_9003019 = {
          ContentES = "\"Juguetero\" - Infierno Gélido",
          TextMapId = "Mon_Name_9003019"
        },
        Mon_Name_9003020 = {
          ContentES = "\"Juguetero\" - Destello",
          TextMapId = "Mon_Name_9003020"
        },
        Mon_Name_9003021 = {
          ContentES = "\"Juguetero\" - Sacrificio",
          TextMapId = "Mon_Name_9003021"
        },
        Mon_Name_9003022 = {
          ContentES = "\"Juguetero\" - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9003022"
        },
        Mon_Name_9003023 = {
          ContentES = "\"Juguetero\" - Baño de Sangre",
          TextMapId = "Mon_Name_9003023"
        },
        Mon_Name_9003024 = {
          ContentES = "\"Juguetero\" - Fantasma",
          TextMapId = "Mon_Name_9003024"
        },
        Mon_Name_9003201 = {
          ContentES = "\"Juguetero\" - Trueno y Destello",
          TextMapId = "Mon_Name_9003201"
        },
        Mon_Name_9003301 = {
          ContentES = "\"Juguetero\" - Baño de Sangre, Explosión y Guardián",
          TextMapId = "Mon_Name_9003301"
        },
        Mon_Name_9004001 = {
          ContentES = "Caja de Juguetes",
          TextMapId = "Mon_Name_9004001"
        },
        Mon_Name_9005001 = {
          ContentES = "Bombadicto",
          TextMapId = "Mon_Name_9005001"
        },
        Mon_Name_9005011 = {
          ContentES = "\"Bombadicto\" - Congelación",
          TextMapId = "Mon_Name_9005011"
        },
        Mon_Name_9005012 = {
          ContentES = "\"Bombadicto\" - Explosión",
          TextMapId = "Mon_Name_9005012"
        },
        Mon_Name_9005013 = {
          ContentES = "\"Bombadicto\" - Corrosión",
          TextMapId = "Mon_Name_9005013"
        },
        Mon_Name_9005014 = {
          ContentES = "\"Bombadicto\" - Trueno",
          TextMapId = "Mon_Name_9005014"
        },
        Mon_Name_9005015 = {
          ContentES = "\"Bombadicto\" - Putrefacción",
          TextMapId = "Mon_Name_9005015"
        },
        Mon_Name_9005016 = {
          ContentES = "\"Bombadicto\" - Marchitar",
          TextMapId = "Mon_Name_9005016"
        },
        Mon_Name_9005017 = {
          ContentES = "\"Bombadicto\" - Guardián",
          TextMapId = "Mon_Name_9005017"
        },
        Mon_Name_9005018 = {
          ContentES = "\"Bombadicto\" - Venganza",
          TextMapId = "Mon_Name_9005018"
        },
        Mon_Name_9005019 = {
          ContentES = "\"Bombadicto\" - Infierno Gélido",
          TextMapId = "Mon_Name_9005019"
        },
        Mon_Name_9005020 = {
          ContentES = "\"Bombadicto\" - Destello",
          TextMapId = "Mon_Name_9005020"
        },
        Mon_Name_9005021 = {
          ContentES = "\"Bombadicto\" - Sacrificio",
          TextMapId = "Mon_Name_9005021"
        },
        Mon_Name_9005022 = {
          ContentES = "\"Bombadicto\" - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9005022"
        },
        Mon_Name_9005023 = {
          ContentES = "\"Bombadicto\" - Baño de Sangre",
          TextMapId = "Mon_Name_9005023"
        },
        Mon_Name_9005024 = {
          ContentES = "\"Bombadicto\" - Fantasma",
          TextMapId = "Mon_Name_9005024"
        },
        Mon_Name_9005201 = {
          ContentES = "\"Bombadicto\" - Sacrificio y Destello",
          TextMapId = "Mon_Name_9005201"
        },
        Mon_Name_9005301 = {
          ContentES = "\"Bombadicto\" - Fantasma, Trueno y Destello",
          TextMapId = "Mon_Name_9005301"
        },
        Mon_Name_9006001 = {
          ContentES = "Engañador",
          TextMapId = "Mon_Name_9006001"
        },
        Mon_Name_9006011 = {
          ContentES = "\"Engañador\" - Congelación",
          TextMapId = "Mon_Name_9006011"
        },
        Mon_Name_9006012 = {
          ContentES = "\"Engañador\" - Explosión",
          TextMapId = "Mon_Name_9006012"
        },
        Mon_Name_9006013 = {
          ContentES = "\"Engañador\" - Corrosión",
          TextMapId = "Mon_Name_9006013"
        },
        Mon_Name_9006014 = {
          ContentES = "\"Engañador\" - Trueno",
          TextMapId = "Mon_Name_9006014"
        },
        Mon_Name_9006015 = {
          ContentES = "\"Engañador\" - Putrefacción",
          TextMapId = "Mon_Name_9006015"
        },
        Mon_Name_9006016 = {
          ContentES = "\"Engañador\" - Marchitar",
          TextMapId = "Mon_Name_9006016"
        },
        Mon_Name_9006017 = {
          ContentES = "\"Engañador\" - Guardián",
          TextMapId = "Mon_Name_9006017"
        },
        Mon_Name_9006018 = {
          ContentES = "\"Engañador\" - Venganza",
          TextMapId = "Mon_Name_9006018"
        },
        Mon_Name_9006019 = {
          ContentES = "\"Engañador\" - Infierno Gélido",
          TextMapId = "Mon_Name_9006019"
        },
        Mon_Name_9006020 = {
          ContentES = "\"Engañador\" - Destello",
          TextMapId = "Mon_Name_9006020"
        },
        Mon_Name_9006021 = {
          ContentES = "\"Engañador\" - Sacrificio",
          TextMapId = "Mon_Name_9006021"
        },
        Mon_Name_9006022 = {
          ContentES = "\"Engañador\" - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9006022"
        },
        Mon_Name_9006023 = {
          ContentES = "\"Engañador\" - Baño de Sangre",
          TextMapId = "Mon_Name_9006023"
        },
        Mon_Name_9006024 = {
          ContentES = "\"Engañador\" - Fantasma",
          TextMapId = "Mon_Name_9006024"
        },
        Mon_Name_9006201 = {
          ContentES = "\"Engañador\" - Trueno e Infierno Gélido",
          TextMapId = "Mon_Name_9006201"
        },
        Mon_Name_9006301 = {
          ContentES = "\"Engañador\" - Baño de Sangre, Fantasma y Congelación",
          TextMapId = "Mon_Name_9006301"
        },
        Mon_Name_9007001 = {
          ContentES = "Agente del Enjambre",
          TextMapId = "Mon_Name_9007001"
        },
        Mon_Name_9007011 = {
          ContentES = "Agente del Enjambre - Congelación",
          TextMapId = "Mon_Name_9007011"
        },
        Mon_Name_9007012 = {
          ContentES = "Agente del Enjambre - Explosión",
          TextMapId = "Mon_Name_9007012"
        },
        Mon_Name_9007013 = {
          ContentES = "Agente del Enjambre - Corrosión",
          TextMapId = "Mon_Name_9007013"
        },
        Mon_Name_9007014 = {
          ContentES = "Agente del Enjambre - Trueno",
          TextMapId = "Mon_Name_9007014"
        },
        Mon_Name_9007015 = {
          ContentES = "Agente del Enjambre - Putrefacción",
          TextMapId = "Mon_Name_9007015"
        },
        Mon_Name_9007016 = {
          ContentES = "Agente del Enjambre - Marchitar",
          TextMapId = "Mon_Name_9007016"
        },
        Mon_Name_9007017 = {
          ContentES = "Agente del Enjambre - Guardián",
          TextMapId = "Mon_Name_9007017"
        },
        Mon_Name_9007018 = {
          ContentES = "Agente del Enjambre - Venganza",
          TextMapId = "Mon_Name_9007018"
        },
        Mon_Name_9007019 = {
          ContentES = "Agente del Enjambre - Infierno Gélido",
          TextMapId = "Mon_Name_9007019"
        },
        Mon_Name_9007020 = {
          ContentES = "Agente del Enjambre - Destello",
          TextMapId = "Mon_Name_9007020"
        },
        Mon_Name_9007021 = {
          ContentES = "Agente del Enjambre - Sacrificio",
          TextMapId = "Mon_Name_9007021"
        },
        Mon_Name_9007022 = {
          ContentES = "Agente del Enjambre - Tormenta Eléctrica",
          TextMapId = "Mon_Name_9007022"
        },
        Mon_Name_9007023 = {
          ContentES = "Agente del Enjambre - Baño de Sangre",
          TextMapId = "Mon_Name_9007023"
        },
        Mon_Name_9007024 = {
          ContentES = "Agente del Enjambre - Fantasma",
          TextMapId = "Mon_Name_9007024"
        },
        Mon_Name_9007201 = {
          ContentES = "Agente del Enjambre - Congelación y Marchitar",
          TextMapId = "Mon_Name_9007201"
        },
        Mon_Name_9007301 = {
          ContentES = "Agente del Enjambre - Baño de Sangre, Tormenta Eléctrica y Congelación",
          TextMapId = "Mon_Name_9007301"
        },
        Mon_Name_9500001 = {
          ContentES = "Lulu, la saqueadora de botín",
          TextMapId = "Mon_Name_9500001"
        },
        Mon_Name_9501001 = {
          ContentES = "Joven Sospechoso",
          TextMapId = "Mon_Name_9501001"
        },
        Mon_Name_9501003 = {
          ContentES = "Matón",
          TextMapId = "Mon_Name_9501003"
        },
        Mon_Name_9501004 = {
          ContentES = "Matón",
          TextMapId = "Mon_Name_9501004"
        },
        Mon_Name_9503002 = {
          ContentES = "Larry",
          TextMapId = "Mon_Name_9503002"
        },
        Mon_Name_9503051 = {
          ContentES = "Cazador",
          TextMapId = "Mon_Name_9503051"
        },
        Mon_Name_9507001 = {
          ContentES = "Giselle",
          TextMapId = "Mon_Name_9507001"
        },
        Mon_Name_9508001 = {
          ContentES = "Matón del Mercado negro",
          TextMapId = "Mon_Name_9508001"
        },
        Mon_Name_9509001 = {
          ContentES = "Tejestrellas de Primavera eterna",
          TextMapId = "Mon_Name_9509001"
        },
        Mon_Name_9801001 = {
          ContentES = "Lobo de Nieve",
          TextMapId = "Mon_Name_9801001"
        },
        Mon_Name_9802001 = {
          ContentES = "Ciervo de Cuernos Carmesí",
          TextMapId = "Mon_Name_9802001"
        },
        Mon_Name_9803001 = {
          ContentES = "Ratón Espalda Plateada",
          TextMapId = "Mon_Name_9803001"
        },
        Mon_Name_9804001 = {
          ContentES = "Ruiseñor Chirrón",
          TextMapId = "Mon_Name_9804001"
        },
        Mon_Name_9805001 = {
          ContentES = "Garza Pescadora",
          TextMapId = "Mon_Name_9805001"
        },
        Mon_Name_9806001 = {
          ContentES = "Jilguero Esmeralda",
          TextMapId = "Mon_Name_9806001"
        },
        Mon_Name_9807001 = {
          ContentES = "Jabalí Enano",
          TextMapId = "Mon_Name_9807001"
        },
        Mon_Name_9808001 = {
          ContentES = "Zorro Rojo",
          TextMapId = "Mon_Name_9808001"
        },
        Mon_Name_9809001 = {
          ContentES = "Ciervo Pelonube",
          TextMapId = "Mon_Name_9809001"
        },
        Mon_Name_9810001 = {
          ContentES = "Ave Marina",
          TextMapId = "Mon_Name_9810001"
        },
        MonsterRushEvent_Wuyou_DungeonDes01 = {
          ContentES = "Un Wishen misterioso, espada en mano, aparece de la nada y bloquea tu camino. Tal vez haya sentido tu talento excepcional, porque parece dispuesto a enseñarte uno o dos movimientos. \n\"Mira bien... solo lo mostraré una vez.\"",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes01"
        },
        MonsterRushEvent_Wuyou_DungeonDes02 = {
          ContentES = "La luz del sol se filtra entre las hojas. Una brisa acaricia tu cabello. Como si recordara una tarde perdida, el pequeño Wishen suelta un largo bostezo.\n...Espera, ¿los Wishen también bostezan?",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes02"
        },
        MonsterRushEvent_Wuyou_DungeonDes03 = {
          ContentES = "El diligente espadachín y el perezoso pastor: su discusión continúa sin cesar. Esperemos que no decidan unirse contra ti, {性别:un viajero solitario atrapado|una viajera solitaria atrapada} en su alegre disputa.",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes03"
        },
        MonsterRushEvent_Wuyou_DungeonDes04 = {
          ContentES = "Una hoja... luego dos... luego tres... Ves cómo el Wishen saca talismán tras talismán de detrás de su espalda, como un mago de escenario sacando infinitas cartas de sus mangas.\n\"¡Este no... ni ese... ¡¿Dónde está mi talismán de trueno!?\"",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes04"
        },
        MonsterRushEvent_Wuyou_DungeonDes05 = {
          ContentES = "Sin prisa, un Wishen coloca su sombrero de paja entre tus manos y te pide que lo guardes con cuidado.\nAl siguiente instante, crees ver una figura en traje surgir de su sombra, empuñando un hacha y gritando: \"¡¿Quién más quiere probarlo!?\"",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes05"
        },
        MonsterRushEvent_Wuyou_DungeonDes06 = {
          ContentES = "Se dice que los Wishen nacen de deseos no cumplidos. Miras al compañero que flota tranquilamente a tu lado.\n¿Qué deseo persistente, te preguntas, lo mantiene atado a este mundo?",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes06"
        },
        MonsterRushEvent_Wuyou_DungeonDes07 = {
          ContentES = "Si desvanecerse significa finalmente dejar ir, entonces no existen las despedidas dolorosas en el mundo de los Wishen.\nColoreados con los tonos del alma, estos espíritus caprichosos se reúnen aquí y mañana, como siempre, rebosará de ruido y maravillas.",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonDes07"
        },
        MonsterRushEvent_Wuyou_DungeonName01 = {
          ContentES = "La lección del espadachín anónimo",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName01"
        },
        MonsterRushEvent_Wuyou_DungeonName02 = {
          ContentES = "El bostezo del joven pastor",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName02"
        },
        MonsterRushEvent_Wuyou_DungeonName03 = {
          ContentES = "Una farsa entretenida",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName03"
        },
        MonsterRushEvent_Wuyou_DungeonName04 = {
          ContentES = "El mago de los talismanes infinitos",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName04"
        }
      }
    end
  },
  {
    MinKey = "MonsterRushEvent_Wuyou_DungeonName05",
    MaxKey = "UI_CTL_Esc_Mod",
    Loader = function()
      return {
        MonsterRushEvent_Wuyou_DungeonName05 = {
          ContentES = "El maníaco tranquilo",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName05"
        },
        MonsterRushEvent_Wuyou_DungeonName06 = {
          ContentES = "La prueba de los deseos persistentes",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName06"
        },
        MonsterRushEvent_Wuyou_DungeonName07 = {
          ContentES = "Un mañana sin preocupaciones",
          TextMapId = "MonsterRushEvent_Wuyou_DungeonName07"
        },
        Pack_Name_Shop_Jingli = {
          ContentES = "Paquete de suministros: Energía",
          TextMapId = "Pack_Name_Shop_Jingli"
        },
        Pack_Name_Shop_Start_01 = {
          ContentES = "Cofre de inicio I",
          TextMapId = "Pack_Name_Shop_Start_01"
        },
        Pack_Name_Shop_Start_02 = {
          ContentES = "Cofre de inicio II",
          TextMapId = "Pack_Name_Shop_Start_02"
        },
        Pack_Name_Shop_Start_03 = {
          ContentES = "Cofre de inicio III",
          TextMapId = "Pack_Name_Shop_Start_03"
        },
        Pack_Name_Shop_Start_04 = {
          ContentES = "Cofre de inicio IV",
          TextMapId = "Pack_Name_Shop_Start_04"
        },
        PaotaiGame_Equipped = {
          ContentES = "Equipado: %s/%s",
          TextMapId = "PaotaiGame_Equipped"
        },
        PaotaiGame_Exit_Content = {
          ContentES = "¿Termina el desafío y guarda tu puntuación actual?",
          TextMapId = "PaotaiGame_Exit_Content"
        },
        PaotaiGame_Exit_Title = {
          ContentES = "Salir",
          TextMapId = "PaotaiGame_Exit_Title"
        },
        PaotaiGame_MaxScore = {
          ContentES = "Puntuación más alta",
          TextMapId = "PaotaiGame_MaxScore"
        },
        PaotaiGame_PresentScore = {
          ContentES = "Puntuación actual",
          TextMapId = "PaotaiGame_PresentScore"
        },
        PaotaiGame_Prop = {
          ContentES = "Objetos",
          TextMapId = "PaotaiGame_Prop"
        },
        PaotaiGame_PropLock_1 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅰ</>",
          TextMapId = "PaotaiGame_PropLock_1"
        },
        PaotaiGame_PropLock_2 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅱ</>",
          TextMapId = "PaotaiGame_PropLock_2"
        },
        PaotaiGame_PropLock_3 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅲ</>",
          TextMapId = "PaotaiGame_PropLock_3"
        },
        PaotaiGame_PropLock_4 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅳ</>",
          TextMapId = "PaotaiGame_PropLock_4"
        },
        PaotaiGame_PropLock_5 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅴ</>",
          TextMapId = "PaotaiGame_PropLock_5"
        },
        PaotaiGame_PropLock_6 = {
          ContentES = "Se desbloquea tras completar el nivel <highlight>Ejercicios retumbantes Ⅵ</>",
          TextMapId = "PaotaiGame_PropLock_6"
        },
        PaotaiGame_PropName_1 = {
          ContentES = "Disparos de Alta Cadencia – Resistencia",
          TextMapId = "PaotaiGame_PropName_1"
        },
        PaotaiGame_PropName_2 = {
          ContentES = "Disparos de Alta Cadencia – Potencia",
          TextMapId = "PaotaiGame_PropName_2"
        },
        PaotaiGame_PropName_3 = {
          ContentES = "Disparos de Alta Cadencia – Tiempo de recarga",
          TextMapId = "PaotaiGame_PropName_3"
        },
        PaotaiGame_PropName_4 = {
          ContentES = "Disparos de Alta Cadencia – Desaceleración",
          TextMapId = "PaotaiGame_PropName_4"
        },
        PaotaiGame_PropName_5 = {
          ContentES = "Disparos de Alta Cadencia – Alcance",
          TextMapId = "PaotaiGame_PropName_5"
        },
        PaotaiGame_PropName_6 = {
          ContentES = "Disparos de Alta Cadencia – Mejoras",
          TextMapId = "PaotaiGame_PropName_6"
        },
        PaotaiGame_PropName_7 = {
          ContentES = "Suministros de apoyo aéreo",
          TextMapId = "PaotaiGame_PropName_7"
        },
        PaotaiGame_Weapon = {
          ContentES = "Armas",
          TextMapId = "PaotaiGame_Weapon"
        },
        PaotaiGame_WeaponName_1 = {
          ContentES = "Modo proyectil",
          TextMapId = "PaotaiGame_WeaponName_1"
        },
        PaotaiGame_WeaponName_2 = {
          ContentES = "Modo rayo",
          TextMapId = "PaotaiGame_WeaponName_2"
        },
        PaotaiGame_WeaponName_3 = {
          ContentES = "Modo llama",
          TextMapId = "PaotaiGame_WeaponName_3"
        },
        PaotaiGame_WeaponName_4 = {
          ContentES = "Modo gélido",
          TextMapId = "PaotaiGame_WeaponName_4"
        },
        PaotaiMiniGame_DungeonName_1 = {
          ContentES = "Ejercicios retumbantes Ⅰ",
          TextMapId = "PaotaiMiniGame_DungeonName_1"
        },
        PaotaiMiniGame_DungeonName_2 = {
          ContentES = "Ejercicios retumbantes Ⅱ",
          TextMapId = "PaotaiMiniGame_DungeonName_2"
        },
        PaotaiMiniGame_DungeonName_3 = {
          ContentES = "Ejercicios retumbantes Ⅲ",
          TextMapId = "PaotaiMiniGame_DungeonName_3"
        },
        PaotaiMiniGame_DungeonName_4 = {
          ContentES = "Ejercicios retumbantes Ⅳ",
          TextMapId = "PaotaiMiniGame_DungeonName_4"
        },
        PaotaiMiniGame_DungeonName_5 = {
          ContentES = "Ejercicios retumbantes Ⅴ",
          TextMapId = "PaotaiMiniGame_DungeonName_5"
        },
        PaotaiMiniGame_DungeonName_6 = {
          ContentES = "Ejercicios retumbantes Ⅵ",
          TextMapId = "PaotaiMiniGame_DungeonName_6"
        },
        PaotaiMiniGame_DungeonName_7 = {
          ContentES = "Ejercicios retumbantes Ⅶ",
          TextMapId = "PaotaiMiniGame_DungeonName_7"
        },
        PaotaiMiniGame_DungeonTask_1 = {
          ContentES = "Puntuación: %d",
          TextMapId = "PaotaiMiniGame_DungeonTask_1"
        },
        PermanenEventReward = {
          ContentES = "Recompensas de tiempo limitado",
          TextMapId = "PermanenEventReward"
        },
        Pet_Name_401 = {
          ContentES = "Purpínube",
          TextMapId = "Pet_Name_401"
        },
        Pet_Name_402 = {
          ContentES = "Gotita",
          TextMapId = "Pet_Name_402"
        },
        Pet_Name_403 = {
          ContentES = "Chispollo",
          TextMapId = "Pet_Name_403"
        },
        Pet_Name_404 = {
          ContentES = "Cubolto",
          TextMapId = "Pet_Name_404"
        },
        Pet_Name_405 = {
          ContentES = "Champichito",
          TextMapId = "Pet_Name_405"
        },
        Pet_Name_406 = {
          ContentES = "Lumi",
          TextMapId = "Pet_Name_406"
        },
        Pet_Name_407 = {
          ContentES = "Salutín",
          TextMapId = "Pet_Name_407"
        },
        Pet_Name_408 = {
          ContentES = "Perlita",
          TextMapId = "Pet_Name_408"
        },
        Pet_Name_409 = {
          ContentES = "Sr. Buenas Noches",
          TextMapId = "Pet_Name_409"
        },
        Pet_Name_411 = {
          ContentES = "Calaluz",
          TextMapId = "Pet_Name_411"
        },
        Pet_Name_412 = {
          ContentES = "Coneglace",
          TextMapId = "Pet_Name_412"
        },
        Pet_Name_413 = {
          ContentES = "Pyrocola",
          TextMapId = "Pet_Name_413"
        },
        Pet_Name_414 = {
          ContentES = "Gatichispa",
          TextMapId = "Pet_Name_414"
        },
        Pet_Name_415 = {
          ContentES = "Hierbín",
          TextMapId = "Pet_Name_415"
        },
        Pet_Name_416 = {
          ContentES = "Bolabeja",
          TextMapId = "Pet_Name_416"
        },
        Pet_Name_421 = {
          ContentES = "Umbrelf",
          TextMapId = "Pet_Name_421"
        },
        Pet_Name_422 = {
          ContentES = "Hydrelf",
          TextMapId = "Pet_Name_422"
        },
        Pet_Name_423 = {
          ContentES = "Pyrelf",
          TextMapId = "Pet_Name_423"
        },
        Pet_Name_424 = {
          ContentES = "Electrelf",
          TextMapId = "Pet_Name_424"
        },
        Pet_Name_425 = {
          ContentES = "Anemelf",
          TextMapId = "Pet_Name_425"
        },
        Pet_Name_426 = {
          ContentES = "Luminelf",
          TextMapId = "Pet_Name_426"
        },
        Pet_Name_491 = {
          ContentES = "Dron curativo",
          TextMapId = "Pet_Name_491"
        },
        Pet_Name_492 = {
          ContentES = "Dron magnético",
          TextMapId = "Pet_Name_492"
        },
        Pet_Name_493 = {
          ContentES = "Gelito",
          TextMapId = "Pet_Name_493"
        },
        PhantomTalk_1101_Chest = {
          ContentES = "Hay un cofre aquí. ¿Quieres abrirlo juntos?",
          TextMapId = "PhantomTalk_1101_Chest"
        },
        PhantomTalk_1102_Chest = {
          ContentES = "Una fortuna inesperada... Tal vez sea la recompensa que te mereces.",
          TextMapId = "PhantomTalk_1102_Chest"
        },
        PhantomTalk_1103_Chest = {
          ContentES = "No todas las sorpresas se esconden tras el telón. Algunas están justo bajo la luz.",
          TextMapId = "PhantomTalk_1103_Chest"
        },
        PhantomTalk_1104_Chest = {
          ContentES = "Puede haber un tesoro aquí. Adelante, {性别:joven amigo|joven amiga}, añádelo a tu colección.",
          TextMapId = "PhantomTalk_1104_Chest"
        },
        PhantomTalk_1501_Chest = {
          ContentES = "¿Un cofre? ¡Destózalo, Samael! No, espera... tranquilízate, hoy no.",
          TextMapId = "PhantomTalk_1501_Chest"
        },
        PhantomTalk_1502_Chest = {
          ContentES = "Un recuerdo... tal vez dejado por un alma que se fue hacia el Mar Nebuloso.",
          TextMapId = "PhantomTalk_1502_Chest"
        },
        PhantomTalk_1503_Chest = {
          ContentES = "Sería una lástima dejar este tesoro enterrado en la tierra. Adelante, tómalo.",
          TextMapId = "PhantomTalk_1503_Chest"
        },
        PhantomTalk_1801_Chest = {
          ContentES = "Los amigos de Fina dicen... ¡que huelen el tesoro del Rey!",
          TextMapId = "PhantomTalk_1801_Chest"
        },
        PhantomTalk_2101_Chest = {
          ContentES = "El romance florece con sorpresas... y aquí hay una ahora.",
          TextMapId = "PhantomTalk_2101_Chest"
        },
        PhantomTalk_2301_Chest = {
          ContentES = "¡Oh! Un bonito botín. Jiji... ¿quieres adivinar qué hay dentro?",
          TextMapId = "PhantomTalk_2301_Chest"
        },
        PhantomTalk_2401_Chest = {
          ContentES = "Fortuna inesperada en la naturaleza... Tal vez sea suficiente para comprar algo de curación.",
          TextMapId = "PhantomTalk_2401_Chest"
        },
        PhantomTalk_3101_Chest = {
          ContentES = "Bueno, eso es una sorpresa. Parece que la suerte comienza a cambiar.",
          TextMapId = "PhantomTalk_3101_Chest"
        },
        PhantomTalk_3102_Chest = {
          ContentES = "Como dije: la limpieza viene con alguna que otra sorpresa.",
          TextMapId = "PhantomTalk_3102_Chest"
        },
        PhantomTalk_3103_Chest = {
          ContentES = "Eh... Oliver dice que hay algo br-brillante cerca.",
          TextMapId = "PhantomTalk_3103_Chest"
        },
        PhantomTalk_3201_Chest = {
          ContentES = "¿Un bien sin dueño? Guárdalo, no es un crimen contra la justicia.",
          TextMapId = "PhantomTalk_3201_Chest"
        },
        PhantomTalk_3202_Chest = {
          ContentES = "La suerte también es parte de la riqueza. Adelante, no hay vergüenza en aceptarlo.",
          TextMapId = "PhantomTalk_3202_Chest"
        },
        PhantomTalk_3301_Chest = {
          ContentES = "¡Hueles a tesoro! ¡Qué buen día para la cosecha!",
          TextMapId = "PhantomTalk_3301_Chest"
        },
        PhantomTalk_4101_Chest = {
          ContentES = "Perímetro despejado. Encontré algunos suministros abandonados.",
          TextMapId = "PhantomTalk_4101_Chest"
        },
        PhantomTalk_4102_Chest = {
          ContentES = "Tierra abajo, fuego arriba, el oro nace del esfuerzo. Los signos no me engañaron.",
          TextMapId = "PhantomTalk_4102_Chest"
        },
        PhantomTalk_4201_Chest = {
          ContentES = "Esas cosas mundanas no me sirven. Son tuyas.",
          TextMapId = "PhantomTalk_4201_Chest"
        },
        PhantomTalk_4202_Chest = {
          ContentES = "¿Tesoro? Bien. ¿Crees que me dejarán cambiarlo por un día libre?",
          TextMapId = "PhantomTalk_4202_Chest"
        },
        PhantomTalk_4301_Chest = {
          ContentES = "¿Un tesoro, tirado por ahí? Hmpf. No me interesa la presa que no resiste.",
          TextMapId = "PhantomTalk_4301_Chest"
        },
        PhantomTalk_5101_Chest = {
          ContentES = "¿Encontraste algo, Filbert? Espera, ¡esto no es comida! ¡Escúpelo!",
          TextMapId = "PhantomTalk_5101_Chest"
        },
        PhantomTalk_5102_Chest = {
          ContentES = "¡Mira lo que he encontrado! ¿Como siempre, a medias?",
          TextMapId = "PhantomTalk_5102_Chest"
        },
        PhantomTalk_5301_Chest = {
          ContentES = "Este cofrecito... ¿contendrá también los recuerdos de alguien?",
          TextMapId = "PhantomTalk_5301_Chest"
        },
        PhantomTalk_5401_Chest = {
          ContentES = "Encontré algunos suministros. ¿Reabastecemos antes de irnos otra vez?",
          TextMapId = "PhantomTalk_5401_Chest"
        },
        RESOURCE_DESC_6000001 = {
          ContentES = "Un vale emitido por Primavera eterna, el gremio comercial bajo la dirección de Zhiliu.",
          TextMapId = "RESOURCE_DESC_6000001"
        },
        RESOURCE_NAME_6000001 = {
          ContentES = "Vale de Primavera eterna",
          TextMapId = "RESOURCE_NAME_6000001"
        },
        SkinTrialEvent_Title_Fushu = {
          ContentES = "Destello de aguas corrientes",
          TextMapId = "SkinTrialEvent_Title_Fushu"
        },
        SkinTrialEvent_Title_Saiqi = {
          ContentES = "Cuando los sueños se visten de noche",
          TextMapId = "SkinTrialEvent_Title_Saiqi"
        },
        SkinTrialEvent_Title_Shuimu = {
          ContentES = "Cuando los sueños se visten de noche",
          TextMapId = "SkinTrialEvent_Title_Shuimu"
        },
        SkinTrialEvent_Title_Songlu = {
          ContentES = "Cuando los sueños se visten de noche",
          TextMapId = "SkinTrialEvent_Title_Songlu"
        },
        StarterQuest_Des_102001_1_1 = {
          ContentES = "Sube a cualquier personaje al Niv. 20",
          TextMapId = "StarterQuest_Des_102001_1_1"
        },
        StarterQuest_Des_102001_1_2 = {
          ContentES = "Mejora cualquier arma al Niv. 20",
          TextMapId = "StarterQuest_Des_102001_1_2"
        },
        StarterQuest_Des_102001_1_3 = {
          ContentES = "Abre 10 cofres fuera de los encargos",
          TextMapId = "StarterQuest_Des_102001_1_3"
        },
        StarterQuest_Des_102001_1_4 = {
          ContentES = "Completa la misión secundaria: La errante Luno",
          TextMapId = "StarterQuest_Des_102001_1_4"
        },
        StarterQuest_Des_102001_1_5 = {
          ContentES = "Completa la misión principal: Susurros de las arenas",
          TextMapId = "StarterQuest_Des_102001_1_5"
        },
        StarterQuest_Des_102001_2_1 = {
          ContentES = "Completa un encargo: Precaución",
          TextMapId = "StarterQuest_Des_102001_2_1"
        },
        StarterQuest_Des_102001_2_2 = {
          ContentES = "Abre 20 cofres fuera de los encargos",
          TextMapId = "StarterQuest_Des_102001_2_2"
        },
        StarterQuest_Des_102001_2_3 = {
          ContentES = "Sube 2 habilidades de personaje al Niv. 2",
          TextMapId = "StarterQuest_Des_102001_2_3"
        },
        StarterQuest_Des_102001_2_4 = {
          ContentES = "Supera con éxito 2 Pruebas de Impresión (excepto las de la Tienda de Impresiones)",
          TextMapId = "StarterQuest_Des_102001_2_4"
        },
        StarterQuest_Des_102001_2_5 = {
          ContentES = "Compra un objeto en la Tienda de Impresiones de Lunoeggy en Lago Helado",
          TextMapId = "StarterQuest_Des_102001_2_5"
        },
        StarterQuest_Des_102001_3_1 = {
          ContentES = "Completa la Misión principal: El arte de sobrevivir",
          TextMapId = "StarterQuest_Des_102001_3_1"
        },
        StarterQuest_Des_102001_3_2 = {
          ContentES = "Asciende cualquier personaje a la fase 1",
          TextMapId = "StarterQuest_Des_102001_3_2"
        },
        StarterQuest_Des_102001_3_3 = {
          ContentES = "Asciende cualquier arma a la fase 1",
          TextMapId = "StarterQuest_Des_102001_3_3"
        },
        StarterQuest_Des_102001_3_4 = {
          ContentES = "Mejora al menos 1 Cuña Demoníaca al Niv. 3",
          TextMapId = "StarterQuest_Des_102001_3_4"
        },
        StarterQuest_Des_102001_3_5 = {
          ContentES = "Completa un encargo: Excavación ∞",
          TextMapId = "StarterQuest_Des_102001_3_5"
        },
        StarterQuest_Des_102001_4_1 = {
          ContentES = "Supera con éxito 10 Pruebas de Impresión (excepto las de la Tienda de Impresiones)",
          TextMapId = "StarterQuest_Des_102001_4_1"
        },
        StarterQuest_Des_102001_4_2 = {
          ContentES = "Sube 3 habilidades de personaje al Niv. 3",
          TextMapId = "StarterQuest_Des_102001_4_2"
        },
        StarterQuest_Des_102001_4_3 = {
          ContentES = "Completa la Misión principal: El secreto detrás de la puerta",
          TextMapId = "StarterQuest_Des_102001_4_3"
        },
        StarterQuest_Des_102001_4_4 = {
          ContentES = "Completar un desafío de Luno, la exploradora",
          TextMapId = "StarterQuest_Des_102001_4_4"
        },
        StarterQuest_Des_102001_4_5 = {
          ContentES = "Completa un encargo: Exterminio",
          TextMapId = "StarterQuest_Des_102001_4_5"
        },
        StarterQuest_Des_102001_4_6 = {
          ContentES = "Hazte amigo con 3 Geniemons",
          TextMapId = "StarterQuest_Des_102001_4_6"
        },
        StarterQuest_Des_102001_5_1 = {
          ContentES = "Completa cualquier desafío de \"Ecos nocturnos\" 1 vez",
          TextMapId = "StarterQuest_Des_102001_5_1"
        },
        StarterQuest_Des_102001_5_2 = {
          ContentES = "Sube 3 personajes al Niv. 40",
          TextMapId = "StarterQuest_Des_102001_5_2"
        },
        StarterQuest_Des_102001_5_3 = {
          ContentES = "Mejora 3 armas al Niv. 40",
          TextMapId = "StarterQuest_Des_102001_5_3"
        },
        StarterQuest_Des_102001_5_4 = {
          ContentES = "Mejora al menos 5 Cuñas Demoníacas diferentes al Niv. 5 (los duplicados no cuentan)",
          TextMapId = "StarterQuest_Des_102001_5_4"
        },
        StarterQuest_Des_102001_5_5 = {
          ContentES = "Completa la Misión principal: En una suave brisa",
          TextMapId = "StarterQuest_Des_102001_5_5"
        },
        StarterQuest_Des_102001_5_6 = {
          ContentES = "Hazte amigo con 10 Geniemons",
          TextMapId = "StarterQuest_Des_102001_5_6"
        },
        StarterQuest_Des_102001_6_1 = {
          ContentES = "Mejora al menos 10 Cuñas Demoníacas diferentes al Niv. 5 (los duplicados no cuentan)",
          TextMapId = "StarterQuest_Des_102001_6_1"
        },
        StarterQuest_Des_102001_6_2 = {
          ContentES = "Completa cualquier desafío de \"Laberinto místico\" 1 vez",
          TextMapId = "StarterQuest_Des_102001_6_2"
        },
        StarterQuest_Des_102001_6_3 = {
          ContentES = "Sube 12 habilidades de personaje al Niv. 3",
          TextMapId = "StarterQuest_Des_102001_6_3"
        },
        StarterQuest_Des_102001_6_4 = {
          ContentES = "Forja cualquier arma 1 vez",
          TextMapId = "StarterQuest_Des_102001_6_4"
        },
        StarterQuest_Des_102001_6_5 = {
          ContentES = "Asciende cualquier Geniemon 1 vez",
          TextMapId = "StarterQuest_Des_102001_6_5"
        },
        StarterQuest_Des_102001_7_1 = {
          ContentES = "Completa \"Laberinto místico: Dificultad Ⅱ\"",
          TextMapId = "StarterQuest_Des_102001_7_1"
        },
        StarterQuest_Des_102001_7_2 = {
          ContentES = "Obtén 5 Cuñas Demoníacas de nivel Púrpura",
          TextMapId = "StarterQuest_Des_102001_7_2"
        },
        StarterQuest_Des_102001_7_3 = {
          ContentES = "Obtén 3 accesorios",
          TextMapId = "StarterQuest_Des_102001_7_3"
        },
        StarterQuest_Des_102001_7_4 = {
          ContentES = "Todas las Impresiones del Imperio Hyperborean alcanzan 30",
          TextMapId = "StarterQuest_Des_102001_7_4"
        },
        StarterQuest_Des_102001_7_5 = {
          ContentES = "Hazte amigo con 20 Geniemons",
          TextMapId = "StarterQuest_Des_102001_7_5"
        },
        StarterQuest_Des_102001_7_6 = {
          ContentES = "Asciende cualquier Geniemon 5 veces",
          TextMapId = "StarterQuest_Des_102001_7_6"
        },
        StarterQuest_Des_102001_8_1 = {
          ContentES = "Completa \"Laberinto místico: Dificultad Ⅲ\"",
          TextMapId = "StarterQuest_Des_102001_8_1"
        },
        StarterQuest_Des_102001_8_2 = {
          ContentES = "Completa \"Repertorio Clásico\" Acto V en el Teatro Inmersivo",
          TextMapId = "StarterQuest_Des_102001_8_2"
        },
        StarterQuest_Des_102001_8_3 = {
          ContentES = "Supera \"Ecos nocturnos: El Eclosionador\" en dificultad 50",
          TextMapId = "StarterQuest_Des_102001_8_3"
        },
        StarterQuest_Des_102001_8_4 = {
          ContentES = "Sube 4 personajes al Niv. 50",
          TextMapId = "StarterQuest_Des_102001_8_4"
        },
        StarterQuest_Des_102001_8_5 = {
          ContentES = "Mejora 4 armas al Niv. 50",
          TextMapId = "StarterQuest_Des_102001_8_5"
        },
        StarterQuest_Des_102001_9_1 = {
          ContentES = "Completa todos los \"Actos del Repertorio Clásico\" en el \"Teatro Inmersivo\"",
          TextMapId = "StarterQuest_Des_102001_9_1"
        },
        StarterQuest_Des_102001_9_2 = {
          ContentES = "Completa \"Laberinto místico: Dificultad Ⅳ\"",
          TextMapId = "StarterQuest_Des_102001_9_2"
        },
        StarterQuest_Des_102001_9_3 = {
          ContentES = "Mejora al menos 10 Cuñas Demoníacas de nivel Púrpura o superior al Niv. 5 (los duplicados no cuentan)",
          TextMapId = "StarterQuest_Des_102001_9_3"
        },
        StarterQuest_Des_102001_9_4 = {
          ContentES = "Sube 5 personajes al Niv. 60",
          TextMapId = "StarterQuest_Des_102001_9_4"
        },
        StarterQuest_Des_102001_9_5 = {
          ContentES = "Mejora 5 armas al Niv. 60",
          TextMapId = "StarterQuest_Des_102001_9_5"
        },
        StarterQuest_Des_102001_9_6 = {
          ContentES = "Posee al menos un Geniemon en la fase 3",
          TextMapId = "StarterQuest_Des_102001_9_6"
        },
        System_Des_Bag_CBT3 = {
          ContentES = "<Highlight>Inventario</> desbloqueado",
          TextMapId = "System_Des_Bag_CBT3"
        },
        System_Des_DailyGoal_CBT3 = {
          ContentES = "<Highlight>Notas</> desbloqueadas",
          TextMapId = "System_Des_DailyGoal_CBT3"
        },
        System_Des_Dispatch_CBT3 = {
          ContentES = "<Highlight>Expedición</> desbloqueada",
          TextMapId = "System_Des_Dispatch_CBT3"
        },
        System_Des_GuideBook_CBT3 = {
          ContentES = "<Highlight>Tutoriales</> desbloqueados",
          TextMapId = "System_Des_GuideBook_CBT3"
        },
        System_Des_Invite_CBT3 = {
          ContentES = "<Highlight>Invitación</> desbloqueada",
          TextMapId = "System_Des_Invite_CBT3"
        },
        System_Des_Mail_CBT3 = {
          ContentES = "<Highlight>Correo</> desbloqueado",
          TextMapId = "System_Des_Mail_CBT3"
        },
        System_Des_ModArchive_CBT3 = {
          ContentES = "<Highlight>Arqueta de Cuña Demoníaca</> desbloqueada",
          TextMapId = "System_Des_ModArchive_CBT3"
        },
        System_Des_ModDungeon_CBT3 = {
          ContentES = "<Highlight>Manual de Noctoviajero</> desbloqueado",
          TextMapId = "System_Des_ModDungeon_CBT3"
        },
        System_Des_PhotoCamera_CBT3 = {
          ContentES = "<Highlight>Cámara</> desbloqueada",
          TextMapId = "System_Des_PhotoCamera_CBT3"
        },
        System_Des_Polarity_CBT3 = {
          ContentES = "<Highlight>Modificación de Afinidad</> desbloqueada",
          TextMapId = "System_Des_Polarity_CBT3"
        },
        System_Des_Temple_CBT3 = {
          ContentES = "<Highlight>Pruebas de Ave espiritual</> desbloqueadas",
          TextMapId = "System_Des_Temple_CBT3"
        },
        System_Des_WalnutBag_CBT3 = {
          ContentES = "<Highlight>Encargos secretos</> desbloqueadas",
          TextMapId = "System_Des_WalnutBag_CBT3"
        },
        TheaterOnline_Donate_Explain = {
          ContentES = "Las recompensas del servidor se enviarán por correo una vez desbloqueadas",
          TextMapId = "TheaterOnline_Donate_Explain"
        },
        TheaterOnline_Donate_Progress = {
          ContentES = "Progreso del servidor",
          TextMapId = "TheaterOnline_Donate_Progress"
        },
        TheaterOnline_Donate_Puy = {
          ContentES = "Contribuir",
          TextMapId = "TheaterOnline_Donate_Puy"
        },
        TheaterOnline_Donate_Reward = {
          ContentES = "Recompensas del servidor",
          TextMapId = "TheaterOnline_Donate_Reward"
        },
        TheaterOnline_Donate_Step = {
          ContentES = "Fase %d",
          TextMapId = "TheaterOnline_Donate_Step"
        },
        TheaterOnline_Game_Name = {
          ContentES = "Todos juntos",
          TextMapId = "TheaterOnline_Game_Name"
        },
        TheaterOnline_Task_Daily = {
          ContentES = "Diario",
          TextMapId = "TheaterOnline_Task_Daily"
        },
        TheaterOnline_Task_Total = {
          ContentES = "Total",
          TextMapId = "TheaterOnline_Task_Total"
        },
        UI_Abyss_Des = {
          ContentES = "Espectador o protagonista, la elección es tuya. Entra en tu propia escena, donde el coraje enfrenta a los adversarios más poderosos, y donde la alegría de un desenlace perfecto te espera.",
          TextMapId = "UI_Abyss_Des"
        },
        UI_AcceptEntrust = {
          ContentES = "Aceptar",
          TextMapId = "UI_AcceptEntrust"
        },
        UI_Accessory_Unlock_Shop_Start_01 = {
          ContentES = "Fuente: Cofre de inicio I",
          TextMapId = "UI_Accessory_Unlock_Shop_Start_01"
        },
        UI_Accessory_Unlock_Shop_Start_02 = {
          ContentES = "Fuente: Cofre de inicio II",
          TextMapId = "UI_Accessory_Unlock_Shop_Start_02"
        },
        UI_Accessory_Unlock_Shop_Start_03 = {
          ContentES = "Fuente: Cofre de inicio III",
          TextMapId = "UI_Accessory_Unlock_Shop_Start_03"
        },
        UI_Accessory_Unlock_Shop_Start_04 = {
          ContentES = "Fuente: Cofre de inicio IV",
          TextMapId = "UI_Accessory_Unlock_Shop_Start_04"
        },
        UI_Bai_Beibao_Finish = {
          ContentES = "¡Hasta luego!",
          TextMapId = "UI_Bai_Beibao_Finish"
        },
        UI_Bai_Beibao_Start = {
          ContentES = "¡A ver qué cosas interesantes has encontrado esta vez!",
          TextMapId = "UI_Bai_Beibao_Start"
        },
        UI_BattlePass_PreviewPortal = {
          ContentES = "Vista previa",
          TextMapId = "UI_BattlePass_PreviewPortal"
        },
        UI_CTL_Abyss_EditTeam = {
          ContentES = "Editar alineación",
          TextMapId = "UI_CTL_Abyss_EditTeam"
        },
        UI_CTL_Add = {ContentES = "Añadir", TextMapId = "UI_CTL_Add"},
        ["UI_CTL_Add/Remove"] = {
          ContentES = "Añadir / Eliminar",
          TextMapId = "UI_CTL_Add/Remove"
        },
        UI_CTL_Adjust = {
          ContentES = "Ajustar",
          TextMapId = "UI_CTL_Adjust"
        },
        UI_CTL_Armory_Consumables = {
          ContentES = "Materiales requeridos",
          TextMapId = "UI_CTL_Armory_Consumables"
        },
        UI_CTL_BattleBag_Check = {
          ContentES = "Abrir Mochila táctica",
          TextMapId = "UI_CTL_BattleBag_Check"
        },
        UI_CTL_BattleBag_Input_Slot = {
          ContentES = "Colocar en la casilla seleccionada",
          TextMapId = "UI_CTL_BattleBag_Input_Slot"
        },
        UI_CTL_BulletJump = {
          ContentES = "Salto en Hélice",
          TextMapId = "UI_CTL_BulletJump"
        },
        UI_CTL_Camera = {
          ContentES = "Control de cámara",
          TextMapId = "UI_CTL_Camera"
        },
        UI_CTL_CheckCondition = {
          ContentES = "Requisitos",
          TextMapId = "UI_CTL_CheckCondition"
        },
        UI_CTL_CheckPet = {
          ContentES = "Ver Geniemon",
          TextMapId = "UI_CTL_CheckPet"
        },
        UI_CTL_CheckPlan = {
          ContentES = "Ver equipo",
          TextMapId = "UI_CTL_CheckPlan"
        },
        UI_CTL_CheckProperty = {
          ContentES = "Ver atributos",
          TextMapId = "UI_CTL_CheckProperty"
        },
        UI_CTL_Choose_InputItem = {
          ContentES = "Seleccionar el objeto a colocar",
          TextMapId = "UI_CTL_Choose_InputItem"
        },
        UI_CTL_Choose_Mod = {
          ContentES = "Seleccionar una Cuña Demoníaca",
          TextMapId = "UI_CTL_Choose_Mod"
        },
        UI_CTL_Choose_ReplaceItem = {
          ContentES = "Seleccionar el objeto a reemplazar",
          TextMapId = "UI_CTL_Choose_ReplaceItem"
        },
        UI_CTL_Claim = {
          ContentES = "Reclamar recompensa",
          TextMapId = "UI_CTL_Claim"
        },
        UI_CTL_ClaimALL = {
          ContentES = "Reclamar todo",
          TextMapId = "UI_CTL_ClaimALL"
        },
        UI_CTL_Clear = {
          ContentES = "Borrar",
          TextMapId = "UI_CTL_Clear"
        },
        UI_CTL_CloseTips = {
          ContentES = "Ocultar indicación",
          TextMapId = "UI_CTL_CloseTips"
        },
        UI_CTL_Continue = {
          ContentES = "Continuar",
          TextMapId = "UI_CTL_Continue"
        },
        UI_CTL_DeputeInfo = {
          ContentES = "Info. de encargos",
          TextMapId = "UI_CTL_DeputeInfo"
        },
        UI_CTL_Details = {
          ContentES = "Detalles",
          TextMapId = "UI_CTL_Details"
        },
        UI_CTL_ESC_Exit = {
          ContentES = "(Mantén) para salir del juego",
          TextMapId = "UI_CTL_ESC_Exit"
        },
        UI_CTL_Esc_Mod = {
          ContentES = "Salir",
          TextMapId = "UI_CTL_Esc_Mod"
        }
      }
    end
  },
  {
    MinKey = "UI_CTL_ExpandList",
    MaxKey = "UI_WEAPON_NAME_10498",
    Loader = function()
      return {
        UI_CTL_ExpandList = {
          ContentES = "Desplegar",
          TextMapId = "UI_CTL_ExpandList"
        },
        UI_CTL_Explain = {
          ContentES = "Ver entrada de Atlasium",
          TextMapId = "UI_CTL_Explain"
        },
        UI_CTL_ExplainSet = {
          ContentES = "Detalles del conjunto",
          TextMapId = "UI_CTL_ExplainSet"
        },
        UI_CTL_Fish_Collect = {
          ContentES = "Recoger",
          TextMapId = "UI_CTL_Fish_Collect"
        },
        UI_CTL_Fish_Lift = {
          ContentES = "Enganchar",
          TextMapId = "UI_CTL_Fish_Lift"
        },
        UI_CTL_Fish_Throw = {
          ContentES = "Lanzar",
          TextMapId = "UI_CTL_Fish_Throw"
        },
        UI_CTL_Focus_List = {
          ContentES = "Enfocar lista",
          TextMapId = "UI_CTL_Focus_List"
        },
        UI_CTL_Focus_ModList = {
          ContentES = "Enfocar",
          TextMapId = "UI_CTL_Focus_ModList"
        },
        UI_CTL_Forging_Set = {
          ContentES = "Establecer como objetivo",
          TextMapId = "UI_CTL_Forging_Set"
        },
        UI_CTL_Forging_Unset = {
          ContentES = "Eliminar objetivo",
          TextMapId = "UI_CTL_Forging_Unset"
        },
        UI_CTL_Input_Slot = {
          ContentES = "Colocar en la casilla",
          TextMapId = "UI_CTL_Input_Slot"
        },
        UI_CTL_Loading_Next = {
          ContentES = "Siguiente",
          TextMapId = "UI_CTL_Loading_Next"
        },
        UI_CTL_MinGame_Move = {
          ContentES = "Mover",
          TextMapId = "UI_CTL_MinGame_Move"
        },
        UI_CTL_Move = {
          ContentES = "Mover",
          TextMapId = "UI_CTL_Move"
        },
        UI_CTL_NextLevel = {
          ContentES = "Previsualizar siguiente nivel",
          TextMapId = "UI_CTL_NextLevel"
        },
        ["UI_CTL_On/Off"] = {
          ContentES = "Activar / Desactivar",
          TextMapId = "UI_CTL_On/Off"
        },
        UI_CTL_OpenSystem = {
          ContentES = "Menú rápido",
          TextMapId = "UI_CTL_OpenSystem"
        },
        UI_CTL_Pet_Rename = {
          ContentES = "Renombrar",
          TextMapId = "UI_CTL_Pet_Rename"
        },
        UI_CTL_Pet_Select = {
          ContentES = "Seleccionar material",
          TextMapId = "UI_CTL_Pet_Select"
        },
        UI_CTL_Pet_SwitchAffix = {
          ContentES = "Cambiar de rasgo",
          TextMapId = "UI_CTL_Pet_SwitchAffix"
        },
        UI_CTL_Pet_SwitchSlot = {
          ContentES = "Cambiar de casilla",
          TextMapId = "UI_CTL_Pet_SwitchSlot"
        },
        ["UI_CTL_Play/Pause"] = {
          ContentES = "Reproducir / Pausar",
          TextMapId = "UI_CTL_Play/Pause"
        },
        UI_CTL_PlayerOptions = {
          ContentES = "Opciones del jugador",
          TextMapId = "UI_CTL_PlayerOptions"
        },
        UI_CTL_PositionPlayer = {
          ContentES = "Localizar jugador",
          TextMapId = "UI_CTL_PositionPlayer"
        },
        UI_CTL_PutOn_Mod = {
          ContentES = "Equipar esta Cuña Demoníaca",
          TextMapId = "UI_CTL_PutOn_Mod"
        },
        UI_CTL_Quit = {
          ContentES = "Salir",
          TextMapId = "UI_CTL_Quit"
        },
        UI_CTL_Read = {
          ContentES = "Leer",
          TextMapId = "UI_CTL_Read"
        },
        UI_CTL_Remove = {
          ContentES = "Eliminar",
          TextMapId = "UI_CTL_Remove"
        },
        UI_CTL_ReplaceItem = {
          ContentES = "Reemplazar este objeto",
          TextMapId = "UI_CTL_ReplaceItem"
        },
        UI_CTL_Replace_Mod = {
          ContentES = "Reemplazar esta Cuña Demoníaca",
          TextMapId = "UI_CTL_Replace_Mod"
        },
        UI_CTL_Replace_SelectedMod = {
          ContentES = "Reemplazar Cuña Demoníaca seleccionada",
          TextMapId = "UI_CTL_Replace_SelectedMod"
        },
        UI_CTL_Replace_Slot = {
          ContentES = "Reemplazar el objeto en la casilla",
          TextMapId = "UI_CTL_Replace_Slot"
        },
        UI_CTL_RotatePreview = {
          ContentES = "Rotar vista previa",
          TextMapId = "UI_CTL_RotatePreview"
        },
        UI_CTL_Rougelike_SlideItems = {
          ContentES = "Desplazar para ver los detalles",
          TextMapId = "UI_CTL_Rougelike_SlideItems"
        },
        UI_CTL_Rougelike_SlideSetItems = {
          ContentES = "Desplazarse para ver el conjunto",
          TextMapId = "UI_CTL_Rougelike_SlideSetItems"
        },
        UI_CTL_Select = {
          ContentES = "Seleccionar",
          TextMapId = "UI_CTL_Select"
        },
        ["UI_CTL_Select/Cancel"] = {
          ContentES = "Seleccionar / Cancelar",
          TextMapId = "UI_CTL_Select/Cancel"
        },
        UI_CTL_SelectLeft = {
          ContentES = "Seleccionar a la izquierda",
          TextMapId = "UI_CTL_SelectLeft"
        },
        UI_CTL_SelectMessages = {
          ContentES = "Seleccionar mensaje",
          TextMapId = "UI_CTL_SelectMessages"
        },
        UI_CTL_SelectRight = {
          ContentES = "Seleccionar a la derecha",
          TextMapId = "UI_CTL_SelectRight"
        },
        UI_CTL_SelectRole_Change = {
          ContentES = "Cambiar de personajes",
          TextMapId = "UI_CTL_SelectRole_Change"
        },
        UI_CTL_Select_Slot = {
          ContentES = "Seleccionar una casilla",
          TextMapId = "UI_CTL_Select_Slot"
        },
        UI_CTL_Shop_Converted = {
          ContentES = "Ver objetos convertidos",
          TextMapId = "UI_CTL_Shop_Converted"
        },
        UI_CTL_Shop_Main = {
          ContentES = "Tienda",
          TextMapId = "UI_CTL_Shop_Main"
        },
        UI_CTL_SkinPreview = {
          ContentES = "Previsualización de aspecto",
          TextMapId = "UI_CTL_SkinPreview"
        },
        UI_CTL_Squad_AdjustSorting = {
          ContentES = "Ordenar",
          TextMapId = "UI_CTL_Squad_AdjustSorting"
        },
        UI_CTL_Squad_ExitSorting = {
          ContentES = "Salir",
          TextMapId = "UI_CTL_Squad_ExitSorting"
        },
        UI_CTL_Squad_Expand = {
          ContentES = "Desplegar / Colapsar",
          TextMapId = "UI_CTL_Squad_Expand"
        },
        UI_CTL_Squad_Select = {
          ContentES = "Seleccionar unidad",
          TextMapId = "UI_CTL_Squad_Select"
        },
        UI_CTL_SwichPet = {
          ContentES = "Cambiar Geniemon",
          TextMapId = "UI_CTL_SwichPet"
        },
        UI_CTL_Switch = {
          ContentES = "Cambiar de opción",
          TextMapId = "UI_CTL_Switch"
        },
        UI_CTL_System = {
          ContentES = "Sistema",
          TextMapId = "UI_CTL_System"
        },
        UI_CTL_Unselect = {
          ContentES = "Cancelar",
          TextMapId = "UI_CTL_Unselect"
        },
        UI_CTL_UseSkill = {
          ContentES = "Seleccionar habilidad",
          TextMapId = "UI_CTL_UseSkill"
        },
        UI_CTL_ZoomIn = {
          ContentES = "Acercar",
          TextMapId = "UI_CTL_ZoomIn"
        },
        UI_CTL_ZoomOut = {
          ContentES = "Alejar",
          TextMapId = "UI_CTL_ZoomOut"
        },
        UI_CharTrial_AccessWalnut = {
          ContentES = "Fuentes",
          TextMapId = "UI_CharTrial_AccessWalnut"
        },
        UI_Controller_Check = {
          ContentES = "Ver",
          TextMapId = "UI_Controller_Check"
        },
        UI_Controller_CheckDeputeInfo = {
          ContentES = "Detalles del encargo",
          TextMapId = "UI_Controller_CheckDeputeInfo"
        },
        UI_Controller_CheckDetails = {
          ContentES = "Detalles",
          TextMapId = "UI_Controller_CheckDetails"
        },
        UI_Controller_CheckItems = {
          ContentES = "Ver objetos",
          TextMapId = "UI_Controller_CheckItems"
        },
        UI_Controller_CheckPROB = {
          ContentES = "Ver tarifas",
          TextMapId = "UI_Controller_CheckPROB"
        },
        UI_Controller_CheckPlayer = {
          ContentES = "Ver info. del jugador",
          TextMapId = "UI_Controller_CheckPlayer"
        },
        UI_Controller_CheckReward = {
          ContentES = "Ver recompensas",
          TextMapId = "UI_Controller_CheckReward"
        },
        UI_Controller_CheckTeam = {
          ContentES = "Ver equipo",
          TextMapId = "UI_Controller_CheckTeam"
        },
        UI_Controller_Close = {
          ContentES = "Cerrar",
          TextMapId = "UI_Controller_Close"
        },
        UI_Controller_ClosePlayer = {
          ContentES = "Cerrar",
          TextMapId = "UI_Controller_ClosePlayer"
        },
        UI_Controller_Go = {
          ContentES = "Ir",
          TextMapId = "UI_Controller_Go"
        },
        UI_Controller_Introduction = {
          ContentES = "Descripciones",
          TextMapId = "UI_Controller_Introduction"
        },
        UI_Controller_SelectReward = {
          ContentES = "Seleccionar recompensa",
          TextMapId = "UI_Controller_SelectReward"
        },
        UI_Controller_Slide = {
          ContentES = "Desplazar",
          TextMapId = "UI_Controller_Slide"
        },
        UI_Controller_Switch = {
          ContentES = "Cambiar",
          TextMapId = "UI_Controller_Switch"
        },
        UI_Entrust_Complete = {
          ContentES = "Completado",
          TextMapId = "UI_Entrust_Complete"
        },
        UI_Entrust_Ongoing = {
          ContentES = "En curso",
          TextMapId = "UI_Entrust_Ongoing"
        },
        UI_Entrust_Submit = {
          ContentES = "Entregar",
          TextMapId = "UI_Entrust_Submit"
        },
        UI_Entrust_Submitted = {
          ContentES = "Entregado",
          TextMapId = "UI_Entrust_Submitted"
        },
        UI_EventPortalFinish = {
          ContentES = "Evento completado",
          TextMapId = "UI_EventPortalFinish"
        },
        UI_EventReward_Achieved = {
          ContentES = "Logrado",
          TextMapId = "UI_EventReward_Achieved"
        },
        UI_EventReward_NotAchieved = {
          ContentES = "En curso",
          TextMapId = "UI_EventReward_NotAchieved"
        },
        UI_Event_DailyLogin_Date = {
          ContentES = "Día %s",
          TextMapId = "UI_Event_DailyLogin_Date"
        },
        UI_Finished = {
          ContentES = "Completado",
          TextMapId = "UI_Finished"
        },
        UI_FollowCommunity = {
          ContentES = "Síguenos ahora",
          TextMapId = "UI_FollowCommunity"
        },
        UI_Gacha_Confirm_Selection = {
          ContentES = "Confirmar",
          TextMapId = "UI_Gacha_Confirm_Selection"
        },
        UI_Gacha_Start_Select = {
          ContentES = "Seleccionar un personaje inicial",
          TextMapId = "UI_Gacha_Start_Select"
        },
        UI_Gacha_Start_Warning = {
          ContentES = "Este Crono se abre una vez confirmes tu selección. Antes de obtener tu primer personaje 5★, puedes modificar tu elección libremente.",
          TextMapId = "UI_Gacha_Start_Warning"
        },
        UI_Gacha_Switch_Success = {
          ContentES = "Selección actualizada",
          TextMapId = "UI_Gacha_Switch_Success"
        },
        UI_Gacha_TrialPortal = {
          ContentES = "Probar el personaje",
          TextMapId = "UI_Gacha_TrialPortal"
        },
        UI_JingLi_NoCost = {
          ContentES = "No se requiere gasto de energía",
          TextMapId = "UI_JingLi_NoCost"
        },
        UI_JumpCommunity = {
          ContentES = "Abrir",
          TextMapId = "UI_JumpCommunity"
        },
        UI_Locked_Des_ZhiLiuShop = {
          ContentES = "Tienda no desbloqueada",
          TextMapId = "UI_Locked_Des_ZhiLiuShop"
        },
        UI_Login_Shader = {
          ContentES = "Compilando sombreadores %s%%",
          TextMapId = "UI_Login_Shader"
        },
        UI_ModGuideBook_Archive_Mod = {
          ContentES = "Galería de Cuñas Demoníacas",
          TextMapId = "UI_ModGuideBook_Archive_Mod"
        },
        UI_ModGuideBook_Recommend = {
          ContentES = "Configuración recomendada",
          TextMapId = "UI_ModGuideBook_Recommend"
        },
        UI_ModGuideBook_RewardView = {
          ContentES = "Recompensas",
          TextMapId = "UI_ModGuideBook_RewardView"
        },
        UI_ModGuideBook_Reward_Complete = {
          ContentES = "Reclamado",
          TextMapId = "UI_ModGuideBook_Reward_Complete"
        },
        UI_ModGuideBook_Show_New = {
          ContentES = "Cuñas Demoníacas reveladas",
          TextMapId = "UI_ModGuideBook_Show_New"
        },
        UI_ModGuideBook_Task = {
          ContentES = "Misiones de Cuñas Demoníacas",
          TextMapId = "UI_ModGuideBook_Task"
        },
        UI_ModGuideBook_Task_Block = {
          ContentES = "Ninguna Cuña Demoníaca seleccionada",
          TextMapId = "UI_ModGuideBook_Task_Block"
        },
        UI_ModGuideBook_Task_Collecting = {
          ContentES = "Progreso de colección",
          TextMapId = "UI_ModGuideBook_Task_Collecting"
        },
        UI_ModGuideBook_Task_Complete = {
          ContentES = "Misión completa",
          TextMapId = "UI_ModGuideBook_Task_Complete"
        },
        UI_ModGuideBook_Task_Des_01 = {
          ContentES = "Equipa al menos <highlight>1</> Cuña Demoníaca en un personaje",
          TextMapId = "UI_ModGuideBook_Task_Des_01"
        },
        UI_ModGuideBook_Task_Des_02 = {
          ContentES = "Mejora <highlight>1</> Cuña Demoníaca a <highlight>Niv. 3</> o superior",
          TextMapId = "UI_ModGuideBook_Task_Des_02"
        },
        UI_ModGuideBook_Task_Des_03 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de Personaje</>",
          TextMapId = "UI_ModGuideBook_Task_Des_03"
        },
        UI_ModGuideBook_Task_Des_04 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma cuerpo a cuerpo</>",
          TextMapId = "UI_ModGuideBook_Task_Des_04"
        },
        UI_ModGuideBook_Task_Des_05 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma a distancia</>",
          TextMapId = "UI_ModGuideBook_Task_Des_05"
        },
        UI_ModGuideBook_Task_Des_06 = {
          ContentES = "Equipa al menos <highlight>5</> Cuña Demoníaca en un personaje",
          TextMapId = "UI_ModGuideBook_Task_Des_06"
        },
        UI_ModGuideBook_Task_Des_07 = {
          ContentES = "Mejora <highlight>4</> Cuñas Demoníacas a <highlight>Niv. 3</> o superior",
          TextMapId = "UI_ModGuideBook_Task_Des_07"
        },
        UI_ModGuideBook_Task_Des_08 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de Personaje</>",
          TextMapId = "UI_ModGuideBook_Task_Des_08"
        },
        UI_ModGuideBook_Task_Des_09 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de Personaje</>",
          TextMapId = "UI_ModGuideBook_Task_Des_09"
        },
        UI_ModGuideBook_Task_Des_10 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma a distancia</>",
          TextMapId = "UI_ModGuideBook_Task_Des_10"
        },
        UI_ModGuideBook_Task_Des_11 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma cuerpo a cuerpo</>",
          TextMapId = "UI_ModGuideBook_Task_Des_11"
        },
        UI_ModGuideBook_Task_Des_12 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de Personaje</>",
          TextMapId = "UI_ModGuideBook_Task_Des_12"
        },
        UI_ModGuideBook_Task_Des_13 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma cuerpo a cuerpo</>",
          TextMapId = "UI_ModGuideBook_Task_Des_13"
        },
        UI_ModGuideBook_Task_Des_14 = {
          ContentES = "Colecciona todas las siguientes <highlight>Cuñas Demoníacas de arma a distancia</>",
          TextMapId = "UI_ModGuideBook_Task_Des_14"
        },
        UI_ModGuideBook_Task_Title_Collect_01 = {
          ContentES = "Colección de Cuña Demoníaca I",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_01"
        },
        UI_ModGuideBook_Task_Title_Collect_02 = {
          ContentES = "Colección de Cuña Demoníaca II",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_02"
        },
        UI_ModGuideBook_Task_Title_Collect_03 = {
          ContentES = "Colección de Cuña Demoníaca III",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_03"
        },
        UI_ModGuideBook_Task_Title_Collect_04 = {
          ContentES = "Colección de Cuña Demoníaca IV",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_04"
        },
        UI_ModGuideBook_Task_Title_Collect_05 = {
          ContentES = "Colección de Cuña Demoníaca V",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_05"
        },
        UI_ModGuideBook_Task_Title_Collect_06 = {
          ContentES = "Colección de Cuña Demoníaca VI",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_06"
        },
        UI_ModGuideBook_Task_Title_Collect_07 = {
          ContentES = "Colección de Cuña Demoníaca VII",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_07"
        },
        UI_ModGuideBook_Task_Title_Collect_08 = {
          ContentES = "Colección de Cuña Demoníaca VIII",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_08"
        },
        UI_ModGuideBook_Task_Title_Collect_09 = {
          ContentES = "Colección de Cuña Demoníaca IX",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_09"
        },
        UI_ModGuideBook_Task_Title_Collect_10 = {
          ContentES = "Colección de Cuña Demoníaca X",
          TextMapId = "UI_ModGuideBook_Task_Title_Collect_10"
        },
        UI_ModGuideBook_Task_Title_Equip_01 = {
          ContentES = "Equipamiento de Cuña Demoníaca I",
          TextMapId = "UI_ModGuideBook_Task_Title_Equip_01"
        },
        UI_ModGuideBook_Task_Title_Equip_02 = {
          ContentES = "Equipamiento de Cuña Demoníaca II",
          TextMapId = "UI_ModGuideBook_Task_Title_Equip_02"
        },
        UI_ModGuideBook_Task_Title_LevelUp_01 = {
          ContentES = "Mejora de Cuña Demoníaca I",
          TextMapId = "UI_ModGuideBook_Task_Title_LevelUp_01"
        },
        UI_ModGuideBook_Task_Title_LevelUp_02 = {
          ContentES = "Mejora de Cuña Demoníaca II",
          TextMapId = "UI_ModGuideBook_Task_Title_LevelUp_02"
        },
        UI_ModGuideBook_Task_Update = {
          ContentES = "Actualización de misión",
          TextMapId = "UI_ModGuideBook_Task_Update"
        },
        UI_ModGuideBook_Unlock_New = {
          ContentES = "Cuñas Demoníacas desbloqueadas",
          TextMapId = "UI_ModGuideBook_Unlock_New"
        },
        UI_Mod_Not_Get = {
          ContentES = "No poseído",
          TextMapId = "UI_Mod_Not_Get"
        },
        UI_New_Content = {
          ContentES = "Nuevo",
          TextMapId = "UI_New_Content"
        },
        UI_PatchFix_Popup = {
          ContentES = "¿Deseas borrar la caché y volver a descargar los datos? (Tus datos guardados no serán eliminados.)",
          TextMapId = "UI_PatchFix_Popup"
        },
        UI_PatchFix_Title = {
          ContentES = "Aviso",
          TextMapId = "UI_PatchFix_Title"
        },
        UI_RewardUnlockTips_107003 = {
          ContentES = "Completa la Misión principal: En una suave brisa para desbloquear",
          TextMapId = "UI_RewardUnlockTips_107003"
        },
        UI_Rouge_Des = {
          ContentES = "Permíteme guiarte por los interminables senderos del tiempo.",
          TextMapId = "UI_Rouge_Des"
        },
        UI_SHOP_MAINTAB_ACCESSORY_Back = {
          ContentES = "Espalda",
          TextMapId = "UI_SHOP_MAINTAB_ACCESSORY_Back"
        },
        UI_SHOP_MAINTAB_ACCESSORY_Face = {
          ContentES = "Cara",
          TextMapId = "UI_SHOP_MAINTAB_ACCESSORY_Face"
        },
        UI_SHOP_MAINTAB_ACCESSORY_Head = {
          ContentES = "Cabeza",
          TextMapId = "UI_SHOP_MAINTAB_ACCESSORY_Head"
        },
        UI_SHOP_MAINTAB_ACCESSORY_WEAPON = {
          ContentES = "Arma",
          TextMapId = "UI_SHOP_MAINTAB_ACCESSORY_WEAPON"
        },
        UI_SHOP_MAINTAB_ACCESSORY_Waist = {
          ContentES = "Cintura",
          TextMapId = "UI_SHOP_MAINTAB_ACCESSORY_Waist"
        },
        UI_SHOP_MOD_MELEEUWEAPON = {
          ContentES = "Cuñas Demoníacas (Consonancia – Cuerpo a cuerpo)",
          TextMapId = "UI_SHOP_MOD_MELEEUWEAPON"
        },
        UI_SHOP_MOD_RANGEUWEAPON = {
          ContentES = "Cuñas Demoníacas (Consonancia – a Distancia)",
          TextMapId = "UI_SHOP_MOD_RANGEUWEAPON"
        },
        UI_SettlementPage_NewRecord = {
          ContentES = "Nuevo récord",
          TextMapId = "UI_SettlementPage_NewRecord"
        },
        UI_SettlementPage_TotalScore = {
          ContentES = "Puntuación total",
          TextMapId = "UI_SettlementPage_TotalScore"
        },
        UI_Shop_Bonus = {
          ContentES = "Doble",
          TextMapId = "UI_Shop_Bonus"
        },
        UI_Shop_More = {
          ContentES = "Bonificación",
          TextMapId = "UI_Shop_More"
        },
        UI_Slot_Empty = {
          ContentES = "La casilla seleccionada está vacía",
          TextMapId = "UI_Slot_Empty"
        },
        UI_SystemNotice_TestContent = {
          ContentES = "西语测试文本",
          TextMapId = "UI_SystemNotice_TestContent"
        },
        UI_SystemNotice_Title = {
          ContentES = "西语测试文本",
          TextMapId = "UI_SystemNotice_Title"
        },
        UI_TEMPLE_RULE_NoBattleWheel = {
          ContentES = "Mochila táctica deshabilitada",
          TextMapId = "UI_TEMPLE_RULE_NoBattleWheel"
        },
        UI_TEMPLE_RULE_NoMelee = {
          ContentES = "Armas cuerpo a cuerpo deshabilitadas",
          TextMapId = "UI_TEMPLE_RULE_NoMelee"
        },
        UI_TEMPLE_RULE_NoRanged = {
          ContentES = "Armas a distancia deshabilitadas",
          TextMapId = "UI_TEMPLE_RULE_NoRanged"
        },
        UI_TEMPLE_RULE_NoSkill = {
          ContentES = "Habilidades deshabilitadas",
          TextMapId = "UI_TEMPLE_RULE_NoSkill"
        },
        UI_TempleEvent_Ball = {
          ContentES = "Lanzador de bola de hierro",
          TextMapId = "UI_TempleEvent_Ball"
        },
        UI_TempleEvent_EntryLevel = {
          ContentES = "Inicia desafío",
          TextMapId = "UI_TempleEvent_EntryLevel"
        },
        UI_TempleEvent_HardMode = {
          ContentES = "Dificultad del desafío",
          TextMapId = "UI_TempleEvent_HardMode"
        },
        UI_TempleEvent_HardModeShort = {
          ContentES = "Difícil",
          TextMapId = "UI_TempleEvent_HardModeShort"
        },
        UI_TempleEvent_LevelDes = {
          ContentES = "Acerca del desafío",
          TextMapId = "UI_TempleEvent_LevelDes"
        },
        UI_TempleEvent_LevelRule = {
          ContentES = "Reglas especiales",
          TextMapId = "UI_TempleEvent_LevelRule"
        },
        UI_TempleEvent_LevelTarget = {
          ContentES = "Objetivos",
          TextMapId = "UI_TempleEvent_LevelTarget"
        },
        UI_TempleEvent_Lock_Progress = {
          ContentES = "Se desbloquea tras completar el desafío previo con 1 estrella o más",
          TextMapId = "UI_TempleEvent_Lock_Progress"
        },
        UI_TempleEvent_Lock_Time = {
          ContentES = "Se desbloquea en %s",
          TextMapId = "UI_TempleEvent_Lock_Time"
        },
        UI_TempleEvent_NormalMode = {
          ContentES = "Normal",
          TextMapId = "UI_TempleEvent_NormalMode"
        },
        UI_TempleEvent_RewardDes = {
          ContentES = "Recompensas: %s",
          TextMapId = "UI_TempleEvent_RewardDes"
        },
        UI_TempleEvent_RewardProgress = {
          ContentES = "Progreso de recompensa",
          TextMapId = "UI_TempleEvent_RewardProgress"
        },
        UI_TempleEvent_RewardTarget = {
          ContentES = "Total Recolectado",
          TextMapId = "UI_TempleEvent_RewardTarget"
        },
        UI_TempleEvent_ShiftShot = {
          ContentES = "Disparo con cobertura",
          TextMapId = "UI_TempleEvent_ShiftShot"
        },
        UI_TempleEvent_Shot = {
          ContentES = "Prueba de Tiro",
          TextMapId = "UI_TempleEvent_Shot"
        },
        UI_TempleEvent_StarHasGot = {
          ContentES = "Estrellas Recolectadas (Dificultad actual)",
          TextMapId = "UI_TempleEvent_StarHasGot"
        },
        UI_Tips_Close = {
          ContentES = "Atrás",
          TextMapId = "UI_Tips_Close"
        },
        UI_Tips_Ensure = {
          ContentES = "Confirmar",
          TextMapId = "UI_Tips_Ensure"
        },
        UI_WEAPON_NAME_10101 = {
          ContentES = "Hoja de Ámbar Radiante",
          TextMapId = "UI_WEAPON_NAME_10101"
        },
        UI_WEAPON_NAME_10102 = {
          ContentES = "Grillete del Lobo Solitario",
          TextMapId = "UI_WEAPON_NAME_10102"
        },
        UI_WEAPON_NAME_10103 = {
          ContentES = "Reminiscencia Remanente",
          TextMapId = "UI_WEAPON_NAME_10103"
        },
        UI_WEAPON_NAME_10104 = {
          ContentES = "Tácticas Geniales",
          TextMapId = "UI_WEAPON_NAME_10104"
        },
        UI_WEAPON_NAME_10105 = {
          ContentES = "Rosa Errante",
          TextMapId = "UI_WEAPON_NAME_10105"
        },
        UI_WEAPON_NAME_10198 = {
          ContentES = "Espada del Caballero",
          TextMapId = "UI_WEAPON_NAME_10198"
        },
        UI_WEAPON_NAME_10199 = {
          ContentES = "Espada Metálica",
          TextMapId = "UI_WEAPON_NAME_10199"
        },
        UI_WEAPON_NAME_10201 = {
          ContentES = "Beso de Sirena",
          TextMapId = "UI_WEAPON_NAME_10201"
        },
        UI_WEAPON_NAME_10202 = {
          ContentES = "Alabarda de Jade Primaveral",
          TextMapId = "UI_WEAPON_NAME_10202"
        },
        UI_WEAPON_NAME_10203 = {
          ContentES = "Pecado Imperdonable",
          TextMapId = "UI_WEAPON_NAME_10203"
        },
        UI_WEAPON_NAME_10204 = {
          ContentES = "Abundancia de Esperanza",
          TextMapId = "UI_WEAPON_NAME_10204"
        },
        UI_WEAPON_NAME_10205 = {
          ContentES = "Resplandor Redentor",
          TextMapId = "UI_WEAPON_NAME_10205"
        },
        UI_WEAPON_NAME_10206 = {
          ContentES = "Alma Desvanecida",
          TextMapId = "UI_WEAPON_NAME_10206"
        },
        UI_WEAPON_NAME_10207 = {
          ContentES = "Imperio Azul",
          TextMapId = "UI_WEAPON_NAME_10207"
        },
        UI_WEAPON_NAME_10208 = {
          ContentES = "Paloma de la Paz",
          TextMapId = "UI_WEAPON_NAME_10208"
        },
        UI_WEAPON_NAME_10209 = {
          ContentES = "Segador de Corazón de Obsidiana",
          TextMapId = "UI_WEAPON_NAME_10209"
        },
        UI_WEAPON_NAME_10298 = {
          ContentES = "Lanza del Guardián",
          TextMapId = "UI_WEAPON_NAME_10298"
        },
        UI_WEAPON_NAME_10299 = {
          ContentES = "Lanza Metálica",
          TextMapId = "UI_WEAPON_NAME_10299"
        },
        UI_WEAPON_NAME_10301 = {
          ContentES = "Inferno Punitivo",
          TextMapId = "UI_WEAPON_NAME_10301"
        },
        UI_WEAPON_NAME_10302 = {
          ContentES = "Forjador de Hierro",
          TextMapId = "UI_WEAPON_NAME_10302"
        },
        UI_WEAPON_NAME_10303 = {
          ContentES = "Sed Abrasadora",
          TextMapId = "UI_WEAPON_NAME_10303"
        },
        UI_WEAPON_NAME_10304 = {
          ContentES = "Despedida Eterna",
          TextMapId = "UI_WEAPON_NAME_10304"
        },
        UI_WEAPON_NAME_10398 = {
          ContentES = "Espadón de Escudero",
          TextMapId = "UI_WEAPON_NAME_10398"
        },
        UI_WEAPON_NAME_10399 = {
          ContentES = "Espadón Metálico",
          TextMapId = "UI_WEAPON_NAME_10399"
        },
        UI_WEAPON_NAME_10401 = {
          ContentES = "Colmillos Exiliados",
          TextMapId = "UI_WEAPON_NAME_10401"
        },
        UI_WEAPON_NAME_10402 = {
          ContentES = "Antaño Aureo",
          TextMapId = "UI_WEAPON_NAME_10402"
        },
        UI_WEAPON_NAME_10403 = {
          ContentES = "Mirada de Tiburón Insondable",
          TextMapId = "UI_WEAPON_NAME_10403"
        },
        UI_WEAPON_NAME_10498 = {
          ContentES = "Hojas Dobles del Asesino",
          TextMapId = "UI_WEAPON_NAME_10498"
        }
      }
    end
  },
  {
    MinKey = "UI_WEAPON_NAME_10499",
    MaxKey = "VoiceDes148",
    Loader = function()
      return {
        UI_WEAPON_NAME_10499 = {
          ContentES = "Hojas Dobles Metálicas",
          TextMapId = "UI_WEAPON_NAME_10499"
        },
        UI_WEAPON_NAME_10501 = {
          ContentES = "Oneiros Inmortal",
          TextMapId = "UI_WEAPON_NAME_10501"
        },
        UI_WEAPON_NAME_10502 = {
          ContentES = "Llovizna Serena",
          TextMapId = "UI_WEAPON_NAME_10502"
        },
        UI_WEAPON_NAME_10503 = {
          ContentES = "Látigo de Cadenas",
          TextMapId = "UI_WEAPON_NAME_10503"
        },
        UI_WEAPON_NAME_10504 = {
          ContentES = "Arrecifes Esmeralda",
          TextMapId = "UI_WEAPON_NAME_10504"
        },
        UI_WEAPON_NAME_10598 = {
          ContentES = "Látigo de Verdugo",
          TextMapId = "UI_WEAPON_NAME_10598"
        },
        UI_WEAPON_NAME_10599 = {
          ContentES = "Látigo Metálico",
          TextMapId = "UI_WEAPON_NAME_10599"
        },
        UI_WEAPON_NAME_10601 = {
          ContentES = "Momiji Itteki",
          TextMapId = "UI_WEAPON_NAME_10601"
        },
        UI_WEAPON_NAME_10602 = {
          ContentES = "Sombra Marchita",
          TextMapId = "UI_WEAPON_NAME_10602"
        },
        UI_WEAPON_NAME_10603 = {
          ContentES = "Fervor Sagrado",
          TextMapId = "UI_WEAPON_NAME_10603"
        },
        UI_WEAPON_NAME_10698 = {
          ContentES = "Katana del Solitario",
          TextMapId = "UI_WEAPON_NAME_10698"
        },
        UI_WEAPON_NAME_10699 = {
          ContentES = "Katana Metálica",
          TextMapId = "UI_WEAPON_NAME_10699"
        },
        UI_WEAPON_NAME_110101 = {
          ContentES = "Ymir",
          TextMapId = "UI_WEAPON_NAME_110101"
        },
        UI_WEAPON_NAME_150101 = {
          ContentES = "Samael",
          TextMapId = "UI_WEAPON_NAME_150101"
        },
        UI_WEAPON_NAME_20101 = {
          ContentES = "Singularidad Entrópica",
          TextMapId = "UI_WEAPON_NAME_20101"
        },
        UI_WEAPON_NAME_20102 = {
          ContentES = "Desgarrador",
          TextMapId = "UI_WEAPON_NAME_20102"
        },
        UI_WEAPON_NAME_20103 = {
          ContentES = "Decreto Sacrosanto",
          TextMapId = "UI_WEAPON_NAME_20103"
        },
        UI_WEAPON_NAME_20198 = {
          ContentES = "Pistola del Pastor",
          TextMapId = "UI_WEAPON_NAME_20198"
        },
        UI_WEAPON_NAME_20199 = {
          ContentES = "Pistola Metálica",
          TextMapId = "UI_WEAPON_NAME_20199"
        },
        UI_WEAPON_NAME_20201 = {
          ContentES = "Excresencia",
          TextMapId = "UI_WEAPON_NAME_20201"
        },
        UI_WEAPON_NAME_20203 = {
          ContentES = "Pulsación Azulada",
          TextMapId = "UI_WEAPON_NAME_20203"
        },
        UI_WEAPON_NAME_20205 = {
          ContentES = "Coro Sagrado",
          TextMapId = "UI_WEAPON_NAME_20205"
        },
        UI_WEAPON_NAME_20296 = {
          ContentES = "Pistolas Dobles de Pastor",
          TextMapId = "UI_WEAPON_NAME_20296"
        },
        UI_WEAPON_NAME_20298 = {
          ContentES = "Pistolas Dobles Metálicas",
          TextMapId = "UI_WEAPON_NAME_20298"
        },
        UI_WEAPON_NAME_20301 = {
          ContentES = "Finalidad Estelar",
          TextMapId = "UI_WEAPON_NAME_20301"
        },
        UI_WEAPON_NAME_20302 = {
          ContentES = "Banquete Incandescente",
          TextMapId = "UI_WEAPON_NAME_20302"
        },
        UI_WEAPON_NAME_20303 = {
          ContentES = "Destrucción",
          TextMapId = "UI_WEAPON_NAME_20303"
        },
        UI_WEAPON_NAME_20304 = {
          ContentES = "Trinquete de Guixu",
          TextMapId = "UI_WEAPON_NAME_20304"
        },
        UI_WEAPON_NAME_20305 = {
          ContentES = "Edicto Plateado",
          TextMapId = "UI_WEAPON_NAME_20305"
        },
        UI_WEAPON_NAME_20398 = {
          ContentES = "Lanzagranadas de Helepolis",
          TextMapId = "UI_WEAPON_NAME_20398"
        },
        UI_WEAPON_NAME_20399 = {
          ContentES = "Lanzagranadas Metálica",
          TextMapId = "UI_WEAPON_NAME_20399"
        },
        UI_WEAPON_NAME_20401 = {
          ContentES = "Chirrido",
          TextMapId = "UI_WEAPON_NAME_20401"
        },
        UI_WEAPON_NAME_20402 = {
          ContentES = "Sembrador Silencioso",
          TextMapId = "UI_WEAPON_NAME_20402"
        },
        UI_WEAPON_NAME_20403 = {
          ContentES = "Día del Veredicto Sagrado",
          TextMapId = "UI_WEAPON_NAME_20403"
        },
        UI_WEAPON_NAME_20405 = {
          ContentES = "Arte Explosivo",
          TextMapId = "UI_WEAPON_NAME_20405"
        },
        UI_WEAPON_NAME_20498 = {
          ContentES = "Escopeta del Cazador",
          TextMapId = "UI_WEAPON_NAME_20498"
        },
        UI_WEAPON_NAME_20499 = {
          ContentES = "Escopeta Metálica",
          TextMapId = "UI_WEAPON_NAME_20499"
        },
        UI_WEAPON_NAME_20501 = {
          ContentES = "Rompehuesos",
          TextMapId = "UI_WEAPON_NAME_20501"
        },
        UI_WEAPON_NAME_20502 = {
          ContentES = "Hidra del Trueno Desterrada",
          TextMapId = "UI_WEAPON_NAME_20502"
        },
        UI_WEAPON_NAME_20503 = {
          ContentES = "Llama de Purificación",
          TextMapId = "UI_WEAPON_NAME_20503"
        },
        UI_WEAPON_NAME_20504 = {
          ContentES = "Himno del Amanecer",
          TextMapId = "UI_WEAPON_NAME_20504"
        },
        UI_WEAPON_NAME_20506 = {
          ContentES = "Danza del Velo Celeste",
          TextMapId = "UI_WEAPON_NAME_20506"
        },
        UI_WEAPON_NAME_20507 = {
          ContentES = "Serenata Sumergida",
          TextMapId = "UI_WEAPON_NAME_20507"
        },
        UI_WEAPON_NAME_20509 = {
          ContentES = "Pluma Tejedora de Sueños",
          TextMapId = "UI_WEAPON_NAME_20509"
        },
        UI_WEAPON_NAME_20510 = {
          ContentES = "Luminiscencia Efímera",
          TextMapId = "UI_WEAPON_NAME_20510"
        },
        UI_WEAPON_NAME_20598 = {
          ContentES = "Rifle de Asalto Pionero",
          TextMapId = "UI_WEAPON_NAME_20598"
        },
        UI_WEAPON_NAME_20599 = {
          ContentES = "Rifle de Asalto Metálico",
          TextMapId = "UI_WEAPON_NAME_20599"
        },
        UI_WEAPON_NAME_20601 = {
          ContentES = "Suspiro del Desierto",
          TextMapId = "UI_WEAPON_NAME_20601"
        },
        UI_WEAPON_NAME_20602 = {
          ContentES = "Arco de Luz Apocalíptico",
          TextMapId = "UI_WEAPON_NAME_20602"
        },
        UI_WEAPON_NAME_20603 = {
          ContentES = "Inflorescencia de Embla",
          TextMapId = "UI_WEAPON_NAME_20603"
        },
        UI_WEAPON_NAME_20604 = {
          ContentES = "Desgarralmas",
          TextMapId = "UI_WEAPON_NAME_20604"
        },
        UI_WEAPON_NAME_20698 = {
          ContentES = "Arco Largo del Centinela",
          TextMapId = "UI_WEAPON_NAME_20698"
        },
        UI_WEAPON_NAME_20699 = {
          ContentES = "Arco Largo Metálico",
          TextMapId = "UI_WEAPON_NAME_20699"
        },
        UI_WEAPON_NAME_310101 = {
          ContentES = "Hansel y Gretel",
          TextMapId = "UI_WEAPON_NAME_310101"
        },
        UI_WEAPON_NAME_530101 = {
          ContentES = "Icarus",
          TextMapId = "UI_WEAPON_NAME_530101"
        },
        UI_Walnut_Des = {
          ContentES = "Una carta sellada con el mayor cuidado — dirigida únicamente a los Phoxcazadores más experimentados. Pocos se atreven a responderla, pero aquellos que lo hacen se les promete una recompensa excepcional.",
          TextMapId = "UI_Walnut_Des"
        },
        VoiceDes001 = {
          ContentES = "Charla",
          TextMapId = "VoiceDes001"
        },
        VoiceDes002 = {
          ContentES = "Primer encuentro",
          TextMapId = "VoiceDes002"
        },
        VoiceDes003 = {
          ContentES = "Saludos",
          TextMapId = "VoiceDes003"
        },
        VoiceDes004 = {
          ContentES = "Soliloquio",
          TextMapId = "VoiceDes004"
        },
        VoiceDes005 = {
          ContentES = "Saludos de cumpleaños",
          TextMapId = "VoiceDes005"
        },
        VoiceDes006 = {
          ContentES = "Listo para partir",
          TextMapId = "VoiceDes006"
        },
        VoiceDes007 = {
          ContentES = "Ascensión",
          TextMapId = "VoiceDes007"
        },
        VoiceDes008 = {
          ContentES = "Comienzo de la batalla",
          TextMapId = "VoiceDes008"
        },
        VoiceDes009 = {
          ContentES = "Inactivo",
          TextMapId = "VoiceDes009"
        },
        VoiceDes012 = {
          ContentES = "Herido: I",
          TextMapId = "VoiceDes012"
        },
        VoiceDes013 = {
          ContentES = "Herido: II",
          TextMapId = "VoiceDes013"
        },
        VoiceDes014 = {
          ContentES = "Habilidad de combate: I",
          TextMapId = "VoiceDes014"
        },
        VoiceDes015 = {
          ContentES = "Habilidad de combate: II",
          TextMapId = "VoiceDes015"
        },
        VoiceDes016 = {
          ContentES = "Habilidad definitiva: I",
          TextMapId = "VoiceDes016"
        },
        VoiceDes017 = {
          ContentES = "Habilidad definitiva: II",
          TextMapId = "VoiceDes017"
        },
        VoiceDes018 = {
          ContentES = "Habilidad definitiva: III",
          TextMapId = "VoiceDes018"
        },
        VoiceDes019 = {
          ContentES = "Derrotado: I",
          TextMapId = "VoiceDes019"
        },
        VoiceDes020 = {
          ContentES = "Derrotado: II",
          TextMapId = "VoiceDes020"
        },
        VoiceDes021 = {
          ContentES = "Resurrección",
          TextMapId = "VoiceDes021"
        },
        VoiceDes022 = {
          ContentES = "Victoria",
          TextMapId = "VoiceDes022"
        },
        VoiceDes023 = {
          ContentES = "Retirada",
          TextMapId = "VoiceDes023"
        },
        VoiceDes024 = {
          ContentES = "Victoria: I",
          TextMapId = "VoiceDes024"
        },
        VoiceDes025 = {
          ContentES = "Victoria: II",
          TextMapId = "VoiceDes025"
        },
        VoiceDes026 = {
          ContentES = "Victoria: III",
          TextMapId = "VoiceDes026"
        },
        VoiceDes027 = {
          ContentES = "Victoria: IV",
          TextMapId = "VoiceDes027"
        },
        VoiceDes028 = {
          ContentES = "Doblaje próximamente",
          TextMapId = "VoiceDes028"
        },
        VoiceDes031 = {
          ContentES = "I",
          TextMapId = "VoiceDes031"
        },
        VoiceDes032 = {
          ContentES = "II",
          TextMapId = "VoiceDes032"
        },
        VoiceDes033 = {
          ContentES = "III",
          TextMapId = "VoiceDes033"
        },
        VoiceDes034 = {
          ContentES = "IV",
          TextMapId = "VoiceDes034"
        },
        VoiceDes035 = {
          ContentES = "V",
          TextMapId = "VoiceDes035"
        },
        VoiceDes036 = {
          ContentES = "VI",
          TextMapId = "VoiceDes036"
        },
        VoiceDes037 = {
          ContentES = "VII",
          TextMapId = "VoiceDes037"
        },
        VoiceDes038 = {
          ContentES = "VIII",
          TextMapId = "VoiceDes038"
        },
        VoiceDes039 = {
          ContentES = "IX",
          TextMapId = "VoiceDes039"
        },
        VoiceDes040 = {
          ContentES = "X",
          TextMapId = "VoiceDes040"
        },
        VoiceDes041 = {
          ContentES = "Encuentro aleatorio : I",
          TextMapId = "VoiceDes041"
        },
        VoiceDes042 = {
          ContentES = "Encuentro aleatorio : II",
          TextMapId = "VoiceDes042"
        },
        VoiceDes043 = {
          ContentES = "Encuentro aleatorio : III",
          TextMapId = "VoiceDes043"
        },
        VoiceDes044 = {
          ContentES = "Encuentro aleatorio : IV",
          TextMapId = "VoiceDes044"
        },
        VoiceDes045 = {
          ContentES = "Encuentro aleatorio : V",
          TextMapId = "VoiceDes045"
        },
        VoiceDes046 = {
          ContentES = "Encuentro aleatorio : VI",
          TextMapId = "VoiceDes046"
        },
        VoiceDes047 = {
          ContentES = "Encuentro aleatorio : VII",
          TextMapId = "VoiceDes047"
        },
        VoiceDes048 = {
          ContentES = "Encuentro aleatorio : VIII",
          TextMapId = "VoiceDes048"
        },
        VoiceDes049 = {
          ContentES = "Encuentro aleatorio : IX",
          TextMapId = "VoiceDes049"
        },
        VoiceDes050 = {
          ContentES = "Encuentro aleatorio : X",
          TextMapId = "VoiceDes050"
        },
        VoiceDes051 = {
          ContentES = "Sobre los días lluviosos",
          TextMapId = "VoiceDes051"
        },
        VoiceDes052 = {
          ContentES = "Sobre el amor",
          TextMapId = "VoiceDes052"
        },
        VoiceDes053 = {
          ContentES = "Sobre la gente que te considera rara",
          TextMapId = "VoiceDes053"
        },
        VoiceDes054 = {
          ContentES = "Sobre tu veneno",
          TextMapId = "VoiceDes054"
        },
        VoiceDes055 = {
          ContentES = "Sobre el aroma ocasional",
          TextMapId = "VoiceDes055"
        },
        VoiceDes056 = {
          ContentES = "¿Por qué estás aquí?",
          TextMapId = "VoiceDes056"
        },
        VoiceDes057 = {
          ContentES = "Sobre los deseos",
          TextMapId = "VoiceDes057"
        },
        VoiceDes058 = {
          ContentES = "Sobre el Lago Helado",
          TextMapId = "VoiceDes058"
        },
        VoiceDes059 = {
          ContentES = "Sobre la Legión",
          TextMapId = "VoiceDes059"
        },
        VoiceDes060 = {
          ContentES = "Sobre la nueva vida",
          TextMapId = "VoiceDes060"
        },
        VoiceDes061 = {
          ContentES = "Estoy cansado/a…",
          TextMapId = "VoiceDes061"
        },
        VoiceDes062 = {
          ContentES = "Sobre la imitación",
          TextMapId = "VoiceDes062"
        },
        VoiceDes063 = {
          ContentES = "Sobre el mimetismo",
          TextMapId = "VoiceDes063"
        },
        VoiceDes064 = {
          ContentES = "Sobre el robo",
          TextMapId = "VoiceDes064"
        },
        VoiceDes065 = {
          ContentES = "Sobre tu título",
          TextMapId = "VoiceDes065"
        },
        VoiceDes066 = {
          ContentES = "Sobre Sibylle",
          TextMapId = "VoiceDes066"
        },
        VoiceDes067 = {
          ContentES = "Sobre la solución a los problemas",
          TextMapId = "VoiceDes067"
        },
        VoiceDes068 = {
          ContentES = "Sobre tu arma favorita",
          TextMapId = "VoiceDes068"
        },
        VoiceDes069 = {
          ContentES = "Sobre tus motivos para trabajar",
          TextMapId = "VoiceDes069"
        },
        VoiceDes070 = {
          ContentES = "Sobre el clima",
          TextMapId = "VoiceDes070"
        },
        VoiceDes071 = {
          ContentES = "Sobre la batalla",
          TextMapId = "VoiceDes071"
        },
        VoiceDes072 = {
          ContentES = "Sobre tu identidad",
          TextMapId = "VoiceDes072"
        },
        VoiceDes073 = {
          ContentES = "Sobre la actitud",
          TextMapId = "VoiceDes073"
        },
        VoiceDes074 = {
          ContentES = "Sobre Flora",
          TextMapId = "VoiceDes074"
        },
        VoiceDes075 = {
          ContentES = "Sobre la ropa",
          TextMapId = "VoiceDes075"
        },
        VoiceDes076 = {
          ContentES = "Sobre el Imperio y Charon",
          TextMapId = "VoiceDes076"
        },
        VoiceDes077 = {
          ContentES = "Sobre la jardinería",
          TextMapId = "VoiceDes077"
        },
        VoiceDes078 = {
          ContentES = "Sobre los viajes",
          TextMapId = "VoiceDes078"
        },
        VoiceDes079 = {
          ContentES = "Sobre tu voz interior",
          TextMapId = "VoiceDes079"
        },
        VoiceDes080 = {
          ContentES = "Sobre tu vieja amiga",
          TextMapId = "VoiceDes080"
        },
        VoiceDes081 = {
          ContentES = "Sobre el Imperio Hyperborea",
          TextMapId = "VoiceDes081"
        },
        VoiceDes082 = {
          ContentES = "Sobre tu patria",
          TextMapId = "VoiceDes082"
        },
        VoiceDes083 = {
          ContentES = "Sobre los sueños",
          TextMapId = "VoiceDes083"
        },
        VoiceDes084 = {
          ContentES = "Sobre ser comisaria",
          TextMapId = "VoiceDes084"
        },
        VoiceDes085 = {
          ContentES = "Sobre Filbert",
          TextMapId = "VoiceDes085"
        },
        VoiceDes086 = {
          ContentES = "Sobre la gula",
          TextMapId = "VoiceDes086"
        },
        VoiceDes087 = {
          ContentES = "Sobre la familia",
          TextMapId = "VoiceDes087"
        },
        VoiceDes088 = {
          ContentES = "Sobre el descanso",
          TextMapId = "VoiceDes088"
        },
        VoiceDes089 = {
          ContentES = "¿En qué estás ocupado/a?",
          TextMapId = "VoiceDes089"
        },
        VoiceDes090 = {
          ContentES = "Sobre la 13.ª Legión",
          TextMapId = "VoiceDes090"
        },
        VoiceDes091 = {
          ContentES = "Sobre el Imperio",
          TextMapId = "VoiceDes091"
        },
        VoiceDes092 = {
          ContentES = "Sobre los sentimientos",
          TextMapId = "VoiceDes092"
        },
        VoiceDes093 = {
          ContentES = "Sobre tu identidad",
          TextMapId = "VoiceDes093"
        },
        VoiceDes094 = {
          ContentES = "Sobre Oliver",
          TextMapId = "VoiceDes094"
        },
        VoiceDes095 = {
          ContentES = "Sobre lo que dominas",
          TextMapId = "VoiceDes095"
        },
        VoiceDes096 = {
          ContentES = "Sobre el tartamudeo",
          TextMapId = "VoiceDes096"
        },
        VoiceDes097 = {
          ContentES = "Sobre la infancia",
          TextMapId = "VoiceDes097"
        },
        VoiceDes098 = {
          ContentES = "Sobre ser una recuperadora",
          TextMapId = "VoiceDes098"
        },
        VoiceDes099 = {
          ContentES = "Sobre el basurero",
          TextMapId = "VoiceDes099"
        },
        VoiceDes100 = {
          ContentES = "Sobre el campo de nieve",
          TextMapId = "VoiceDes100"
        },
        VoiceDes101 = {
          ContentES = "Sobre el colgante",
          TextMapId = "VoiceDes101"
        },
        VoiceDes102 = {
          ContentES = "Sobre tu título",
          TextMapId = "VoiceDes102"
        },
        VoiceDes103 = {
          ContentES = "Sobre los deseos",
          TextMapId = "VoiceDes103"
        },
        VoiceDes104 = {
          ContentES = "Sobre los secretos",
          TextMapId = "VoiceDes104"
        },
        VoiceDes105 = {
          ContentES = "Sobre los sueños",
          TextMapId = "VoiceDes105"
        },
        VoiceDes106 = {
          ContentES = "Sobre los padres",
          TextMapId = "VoiceDes106"
        },
        VoiceDes107 = {
          ContentES = "Sobre Outsider",
          TextMapId = "VoiceDes107"
        },
        VoiceDes108 = {
          ContentES = "Sobre tu piel",
          TextMapId = "VoiceDes108"
        },
        VoiceDes109 = {
          ContentES = "Sobre el trabajo",
          TextMapId = "VoiceDes109"
        },
        VoiceDes110 = {
          ContentES = "Sobre la justicia",
          TextMapId = "VoiceDes110"
        },
        VoiceDes111 = {
          ContentES = "Sobre los pasatiempos",
          TextMapId = "VoiceDes111"
        },
        VoiceDes112 = {
          ContentES = "Sobre Huaxu",
          TextMapId = "VoiceDes112"
        },
        VoiceDes113 = {
          ContentES = "Sobre los deberes",
          TextMapId = "VoiceDes113"
        },
        VoiceDes114 = {
          ContentES = "Sobre el estado de ánimo",
          TextMapId = "VoiceDes114"
        },
        VoiceDes115 = {
          ContentES = "Sobre las noches",
          TextMapId = "VoiceDes115"
        },
        VoiceDes116 = {
          ContentES = "Sobre tu patria",
          TextMapId = "VoiceDes116"
        },
        VoiceDes117 = {
          ContentES = "Sobre el Mar Brumoso",
          TextMapId = "VoiceDes117"
        },
        VoiceDes118 = {
          ContentES = "Sobre los amigos",
          TextMapId = "VoiceDes118"
        },
        VoiceDes119 = {
          ContentES = "Sobre su armónica Ⅰ",
          TextMapId = "VoiceDes119"
        },
        VoiceDes120 = {
          ContentES = "Sobre su armónica Ⅱ",
          TextMapId = "VoiceDes120"
        },
        VoiceDes121 = {
          ContentES = "Sobre la Legión Ⅰ",
          TextMapId = "VoiceDes121"
        },
        VoiceDes122 = {
          ContentES = "Sobre la Legión Ⅱ",
          TextMapId = "VoiceDes122"
        },
        VoiceDes123 = {
          ContentES = "Sobre sus cuernos",
          TextMapId = "VoiceDes123"
        },
        VoiceDes124 = {
          ContentES = "Sobre Blues",
          TextMapId = "VoiceDes124"
        },
        VoiceDes125 = {
          ContentES = "Sobre su nombre",
          TextMapId = "VoiceDes125"
        },
        VoiceDes126 = {
          ContentES = "Sobre la actuación",
          TextMapId = "VoiceDes126"
        },
        VoiceDes127 = {
          ContentES = "Sobre el teatro",
          TextMapId = "VoiceDes127"
        },
        VoiceDes128 = {
          ContentES = "Sobre la medicina",
          TextMapId = "VoiceDes128"
        },
        VoiceDes129 = {
          ContentES = "Sobre la Academia de Alquimia",
          TextMapId = "VoiceDes129"
        },
        VoiceDes130 = {
          ContentES = "Sobre su mochila",
          TextMapId = "VoiceDes130"
        },
        VoiceDes131 = {
          ContentES = "Sobre el entrenamiento",
          TextMapId = "VoiceDes131"
        },
        VoiceDes132 = {
          ContentES = "Sobre su padre",
          TextMapId = "VoiceDes132"
        },
        VoiceDes133 = {
          ContentES = "Sobre el arte de la espada",
          TextMapId = "VoiceDes133"
        },
        VoiceDes134 = {
          ContentES = "Sobre la rebelión",
          TextMapId = "VoiceDes134"
        },
        VoiceDes135 = {
          ContentES = "Sobre el dominio de armas",
          TextMapId = "VoiceDes135"
        },
        VoiceDes136 = {
          ContentES = "XI",
          TextMapId = "VoiceDes136"
        },
        VoiceDes137 = {
          ContentES = "Herido: III",
          TextMapId = "VoiceDes137"
        },
        VoiceDes138 = {
          ContentES = "Herido: IV",
          TextMapId = "VoiceDes138"
        },
        VoiceDes139 = {
          ContentES = "Habilidad de combate: III",
          TextMapId = "VoiceDes139"
        },
        VoiceDes140 = {
          ContentES = "Habilidad de combate: IV",
          TextMapId = "VoiceDes140"
        },
        VoiceDes141 = {
          ContentES = "Habilidad de combate: V",
          TextMapId = "VoiceDes141"
        },
        VoiceDes142 = {
          ContentES = "Sobre las técnicas",
          TextMapId = "VoiceDes142"
        },
        VoiceDes143 = {
          ContentES = "Sobre los Abandonados",
          TextMapId = "VoiceDes143"
        },
        VoiceDes144 = {
          ContentES = "Sobre las heridas",
          TextMapId = "VoiceDes144"
        },
        VoiceDes145 = {
          ContentES = "Sobre la supervivencia",
          TextMapId = "VoiceDes145"
        },
        VoiceDes146 = {
          ContentES = "Sobre las recompensas",
          TextMapId = "VoiceDes146"
        },
        VoiceDes147 = {
          ContentES = "Sobre el precio a pagar",
          TextMapId = "VoiceDes147"
        },
        VoiceDes148 = {
          ContentES = "Sobre los negocios",
          TextMapId = "VoiceDes148"
        }
      }
    end
  },
  {
    MinKey = "VoiceDes149",
    MaxKey = "voice_ch_char_Feina_vo_skill02_r01",
    Loader = function()
      return {
        VoiceDes149 = {
          ContentES = "Sobre el miedo",
          TextMapId = "VoiceDes149"
        },
        VoiceDes150 = {
          ContentES = "Habilidad definitiva: IV",
          TextMapId = "VoiceDes150"
        },
        VoiceDes151 = {
          ContentES = "Sobre Samael",
          TextMapId = "VoiceDes151"
        },
        VoiceDes152 = {
          ContentES = "Sobre la Iglesia Elisiana",
          TextMapId = "VoiceDes152"
        },
        VoiceDes153 = {
          ContentES = "Sobre Paciencia",
          TextMapId = "VoiceDes153"
        },
        VoiceDes154 = {
          ContentES = "Sobre las Siete Virtudes",
          TextMapId = "VoiceDes154"
        },
        VoiceLocked_Dialogue = {
          ContentES = "Desbloquea después de las charlas informales en el Santuario.",
          TextMapId = "VoiceLocked_Dialogue"
        },
        ZhiLiuEntrustGrandRewardTips = {
          ContentES = "Completa todos los encargos para reclamar",
          TextMapId = "ZhiLiuEntrustGrandRewardTips"
        },
        ZhiLiuEntrustText01 = {
          ContentES = "Aquí está la lista de compras del día. ¿Podrías ayudarme a reunir estos objetos?",
          TextMapId = "ZhiLiuEntrustText01"
        },
        ZhiLiuEntrustText02 = {
          ContentES = "Necesito caparazones de Filthoid. ¿Podrías ir a cazar algunos para mí?",
          TextMapId = "ZhiLiuEntrustText02"
        },
        ZhiLiuEntrust_Battle = {
          ContentES = "Lista de caza",
          TextMapId = "ZhiLiuEntrust_Battle"
        },
        ZhiLiuEntrust_GetGrandReward = {
          ContentES = "Reclamar recompensa",
          TextMapId = "ZhiLiuEntrust_GetGrandReward"
        },
        ZhiLiuEntrust_GrandReward_Name = {
          ContentES = "Cofre de Polvo Estelar",
          TextMapId = "ZhiLiuEntrust_GrandReward_Name"
        },
        ZhiLiuEntrust_Jump_Tips = {
          ContentES = "¿Quieres teletransportarte a Zhiliu?",
          TextMapId = "ZhiLiuEntrust_Jump_Tips"
        },
        ZhiLiuEntrust_Lock_PretextTasks = {
          ContentES = "Se desbloquea después de completar el encargo del día %s",
          TextMapId = "ZhiLiuEntrust_Lock_PretextTasks"
        },
        ZhiLiuEntrust_Lock_Time1 = {
          ContentES = "Se desbloquea en {DD} d {H} h",
          TextMapId = "ZhiLiuEntrust_Lock_Time1"
        },
        ZhiLiuEntrust_Lock_Time2 = {
          ContentES = "Se desbloquea en {H} h {M} min",
          TextMapId = "ZhiLiuEntrust_Lock_Time2"
        },
        ZhiLiuEntrust_Objective = {
          ContentES = "Objetivo del encargo",
          TextMapId = "ZhiLiuEntrust_Objective"
        },
        ZhiLiuEntrust_Progress = {
          ContentES = "Progreso del encargo",
          TextMapId = "ZhiLiuEntrust_Progress"
        },
        ZhiLiuEntrust_Resource = {
          ContentES = "Lista de compras",
          TextMapId = "ZhiLiuEntrust_Resource"
        },
        voice_ch_char_Aote_vo_appear = {
          ContentES = "Esta es una misión muy delicada. Podemos tratarla juntos, como siempre, ¿mitad y mitad?",
          TextMapId = "voice_ch_char_Aote_vo_appear"
        },
        voice_ch_char_Aote_vo_battleidle = {
          ContentES = "Gastos de suministros... Gastos de transporte... ¿Cuánto fue? ¡Maldita sea, lo olvidé otra vez! Me siento perdido sin mi cuaderno de cuentas.",
          TextMapId = "voice_ch_char_Aote_vo_battleidle"
        },
        voice_ch_char_Aote_vo_battlestart = {
          ContentES = "Terminemos rápido. Tengo montones de cosas que hacer en casa.",
          TextMapId = "voice_ch_char_Aote_vo_battlestart"
        },
        voice_ch_char_Aote_vo_be_hit_heavy_r01 = {
          ContentES = "¡Acabo de arreglarme la ropa!",
          TextMapId = "voice_ch_char_Aote_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Aote_vo_be_hit_heavy_r02 = {
          ContentES = "¡Ay...!",
          TextMapId = "voice_ch_char_Aote_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Aote_vo_birthday = {
          ContentES = "¡Feliz cumpleaños! ¡Feliz cumpleaños!... Oh, nada, solo recuerdo cómo nos conocimos. También se relacionó con el \"cumpleaños\". Y ahora, después de todo este tiempo, celebramos otro \"cumpleaños\" juntos. ¿No es maravilloso el destino?",
          TextMapId = "voice_ch_char_Aote_vo_birthday"
        },
        voice_ch_char_Aote_vo_companio_01 = {
          ContentES = "¿Por qué estás aquí? ¿Estás bien? ¿Cómo te sientes? Deberías dormir un poco. Avísame si necesitas algo, ¿de acuerdo?",
          TextMapId = "voice_ch_char_Aote_vo_companio_01"
        },
        voice_ch_char_Aote_vo_companio_02_1 = {
          ContentES = "Eres la chica que es muy amiga de {nickname}, ¿verdad?... Dicen que no te has sentido bien. Siéntate para descansar un momento.",
          TextMapId = "voice_ch_char_Aote_vo_companio_02_1"
        },
        voice_ch_char_Aote_vo_companio_02_2 = {
          ContentES = "Siéntete como en tu casa, cuido de mi hermana enferma todo el tiempo en casa, estoy acostumbrado a cuidar de los demás... Si tienes hambre, sed o necesitas algo, solo avísame. La amiga de {nickname} también es la mía.",
          TextMapId = "voice_ch_char_Aote_vo_companio_02_2"
        },
        voice_ch_char_Aote_vo_companio_03_1 = {
          ContentES = "¡Dama Camilla! ¿Qué le trae por aquí?... ¿Acaso hay algún comisión urgente? Últimamente {nickname} ha estado agotado, así que tomémonos un descanso por ahora...",
          TextMapId = "voice_ch_char_Aote_vo_companio_03_1"
        },
        voice_ch_char_Aote_vo_companio_03_2 = {
          ContentES = "Pues, si la paga es buena, estoy atento.",
          TextMapId = "voice_ch_char_Aote_vo_companio_03_2"
        },
        voice_ch_char_Aote_vo_companio_04 = {
          ContentES = "¿Te acuerdas de mí cuando era pequeño? Eras como una hermana dulce y un padre severo a la vez... No, no digo que seas vieja ni brutal, ¿eh?, solo... gracias por haberme dado un verdadero hogar.",
          TextMapId = "voice_ch_char_Aote_vo_companio_04"
        },
        voice_ch_char_Aote_vo_die_r01 = {
          ContentES = "*Ejem*... Incluso los mejores, también caemos...",
          TextMapId = "voice_ch_char_Aote_vo_die_r01"
        },
        voice_ch_char_Aote_vo_die_r02 = {
          ContentES = "Cuida de Fina por mí... por favor.",
          TextMapId = "voice_ch_char_Aote_vo_die_r02"
        },
        voice_ch_char_Aote_vo_fail = {
          ContentES = "Bah. Retiraos vosotros. Yo iré detrás.",
          TextMapId = "voice_ch_char_Aote_vo_fail"
        },
        voice_ch_char_Aote_vo_gain = {
          ContentES = "Ya nos conocemos bastante bien, ¿realmente tengo que presentarme?... Bueno... Soy Outsider, de \"Los Noctoviajeros\". Creo que soy algo así como... ¿el protector de niños?",
          TextMapId = "voice_ch_char_Aote_vo_gain"
        },
        voice_ch_char_Aote_vo_idle = {
          ContentES = "Es muy bueno tener tranquilidad y un lugar al que me sienta apegado después de tantos años.",
          TextMapId = "voice_ch_char_Aote_vo_idle"
        },
        voice_ch_char_Aote_vo_lvup = {
          ContentES = "No pienses demasiado en mí. Es que... Es un poco incómodo. Bueno, olvídate.",
          TextMapId = "voice_ch_char_Aote_vo_lvup"
        },
        voice_ch_char_Aote_vo_revive = {
          ContentES = "No te preocupes, tengo muchas heridas como así, eso no es nada.",
          TextMapId = "voice_ch_char_Aote_vo_revive"
        },
        voice_ch_char_Aote_vo_skill01_r01 = {
          ContentES = "Pequeños trucos, grandes utilidades.",
          TextMapId = "voice_ch_char_Aote_vo_skill01_r01"
        },
        voice_ch_char_Aote_vo_skill01_r02 = {
          ContentES = "¡Mira esto!",
          TextMapId = "voice_ch_char_Aote_vo_skill01_r02"
        },
        voice_ch_char_Aote_vo_skill02_r01 = {
          ContentES = "¡Relájate! Es por tu propio bien.",
          TextMapId = "voice_ch_char_Aote_vo_skill02_r01"
        },
        voice_ch_char_Aote_vo_skill02_r02 = {
          ContentES = "Se acabó el tiempo de prueba, ahora toca seriedad.",
          TextMapId = "voice_ch_char_Aote_vo_skill02_r02"
        },
        voice_ch_char_Aote_vo_skill02_r03 = {
          ContentES = "Aprecia tu último vistazo del mundo.",
          TextMapId = "voice_ch_char_Aote_vo_skill02_r03"
        },
        voice_ch_char_Aote_vo_topic_01_1 = {
          ContentES = "¿Una guía? No, la mayoría de los que se dedican a esto no son de los que se ponen a leer libros. Pero sí tengo algunas fórmulas concisas, como mi lema personal es: Dos golpes en las costillas, uno en la cabeza, así de muertos, ni el emperador los revive.",
          TextMapId = "voice_ch_char_Aote_vo_topic_01_1"
        },
        voice_ch_char_Aote_vo_topic_01_2 = {
          ContentES = "No te metas en más de lo que puedes manejar. En este trabajo, la codicia es el mayor enemigo. A veces viene de otros, pero más a menudo, viene de uno mismo.",
          TextMapId = "voice_ch_char_Aote_vo_topic_01_2"
        },
        voice_ch_char_Aote_vo_topic_02_1 = {
          ContentES = "Ellos son como un incendio forestal que nunca se apaga, listo para reavivarse en cualquier momento. Por tu propia seguridad, mejor mantente alejado...",
          TextMapId = "voice_ch_char_Aote_vo_topic_02_1"
        },
        voice_ch_char_Aote_vo_topic_02_2 = {
          ContentES = "Es que... Hemos tenido algunos pequeños encontronazos. Si alguna vez tienes que lidiar con ellos, asegúrate de que no menciones mi nombre.",
          TextMapId = "voice_ch_char_Aote_vo_topic_02_2"
        },
        voice_ch_char_Aote_vo_topic_03_1 = {
          ContentES = "Sí. ¿Me puedes traer esa venda de allá? Necesito esconderla para que Fina no se entere, de lo contrario, va a armar un escándalo.",
          TextMapId = "voice_ch_char_Aote_vo_topic_03_1"
        },
        voice_ch_char_Aote_vo_topic_03_2 = {
          ContentES = "Lo sé, pero las lesiones son parte del trabajo. Prefiero que no se preocupe tanto. Por favor, cúbreme si te pregunta, ¿vale? Te lo agradeceré.",
          TextMapId = "voice_ch_char_Aote_vo_topic_03_2"
        },
        voice_ch_char_Aote_vo_topic_04_1 = {
          ContentES = "Oh. ¿Quieres probar estos bichitos? No te fijes en la apariencia. Solo quítales la cabeza, serán crujientes como galletas, con un ligero sabor a carne en la boca...",
          TextMapId = "voice_ch_char_Aote_vo_topic_04_1"
        },
        voice_ch_char_Aote_vo_topic_04_2 = {
          ContentES = "¿A dónde vas? ¡Esto es un conocimiento útil para sobrevivir!... Cuando te pierdas en la naturaleza sin comida, estos bichitos serán una fuente de energía más valiosa y podrán salvarte la vida.",
          TextMapId = "voice_ch_char_Aote_vo_topic_04_2"
        },
        voice_ch_char_Aote_vo_topic_05_1 = {
          ContentES = "Eh... un momento, ¿por qué solo tienes tantas pocas monedas? ¿Volviste a regalar tu parte del botín?",
          TextMapId = "voice_ch_char_Aote_vo_topic_05_1"
        },
        voice_ch_char_Aote_vo_topic_05_2 = {
          ContentES = "Pero... Ay, no importa, eres así, siempre pensando en los demás. Avísame si necesitas dinero.",
          TextMapId = "voice_ch_char_Aote_vo_topic_05_2"
        },
        voice_ch_char_Aote_vo_topic_05_3 = {
          ContentES = "...Te estás aprovechando, colega.",
          TextMapId = "voice_ch_char_Aote_vo_topic_05_3"
        },
        voice_ch_char_Aote_vo_victory = {
          ContentES = "Déjenlos todos en mis manos. Voy a ver si encuentro algo útil entre los restos.",
          TextMapId = "voice_ch_char_Aote_vo_victory"
        },
        voice_ch_char_Aote_vo_welcome = {
          ContentES = "¡Por fin estás! Terminé todos mis deberes y estoy agotado, pero solo he ganado un poco de dinero. ¡Uf! Sabes que hago mucho por vosotros.",
          TextMapId = "voice_ch_char_Aote_vo_welcome"
        },
        voice_ch_char_Baiheng_vo_appear = {
          ContentES = "Prepararé suficiente medicina para las batallas venideras.",
          TextMapId = "voice_ch_char_Baiheng_vo_appear"
        },
        voice_ch_char_Baiheng_vo_battleidle = {
          ContentES = "¿Cómo podría hacer oídos sordos a tan desgarradores gritos de auxilio?",
          TextMapId = "voice_ch_char_Baiheng_vo_battleidle"
        },
        voice_ch_char_Baiheng_vo_battlestart = {
          ContentES = "No permitiré que la muerte prevalezca.",
          TextMapId = "voice_ch_char_Baiheng_vo_battlestart"
        },
        voice_ch_char_Baiheng_vo_be_hit_heavy_r01 = {
          ContentES = "¡Fétidas impurezas...!",
          TextMapId = "voice_ch_char_Baiheng_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Baiheng_vo_be_hit_r02 = {
          ContentES = "La ropa está sucia...",
          TextMapId = "voice_ch_char_Baiheng_vo_be_hit_r02"
        },
        voice_ch_char_Baiheng_vo_birthday = {
          ContentES = "Hoy es tu día especial. En honor a ello, he preparado una humilde ofrenda: una colección de remedios herbales para prevenir las dolencias menores que puedas encontrar en tus viajes. Ya sea un resfriado, un rasguño o un moretón, te serán de gran utilidad. Sin embargo... mi esperanza de corazón es que permanezcas tan seguro y bien que nunca tengas la necesidad de usarlos.",
          TextMapId = "voice_ch_char_Baiheng_vo_birthday"
        },
        voice_ch_char_Baiheng_vo_companio = {
          ContentES = "Señor Caos, tiene usted nuevas heridas en el cuerpo. ¿Puedo ofrecerle atención médica? *Suspira* O quizás aceptará este ungüento entonces. Puede prevenir infecciones. Le dolerá un poco, aunque me atrevería a decir que lo disfrutará... Tenga cuidado de no aplicarse demasiado.",
          TextMapId = "voice_ch_char_Baiheng_vo_companio"
        },
        voice_ch_char_Baiheng_vo_companio_01 = {
          ContentES = "Señor Randy, en mi humilde opinión, la apatía y la pereza también son síntomas de enfermedad. Quizás ahora esté bien, pero pueden causar problemas de salud en el futuro. ¿Qué le parece hacer un poco de ejercicios para ayudarle?",
          TextMapId = "voice_ch_char_Baiheng_vo_companio_01"
        },
        voice_ch_char_Baiheng_vo_companio_02 = {
          ContentES = "Si bien un sanador puede aliviar el sufrimiento, está fuera de su alcance desafiar el destino. Puedo ofrecerle un remedio para calmar su angustia del corazón, pero la raíz de sus problemas está fuera de mi alcance. Lo mejor es aceptar y adaptarse al paso del tiempo para encontrar el camino hacia la serenidad...",
          TextMapId = "voice_ch_char_Baiheng_vo_companio_02"
        },
        voice_ch_char_Baiheng_vo_companio_03 = {
          ContentES = "¿Oye a menudo que otra voz le habla? ¿Pueden oírla otros también? ¿Qué tal ha sido su descanso? ¿Hay algo que le pese en el corazón? Las aflicciones de la mente son las más difíciles de sanar, incluso con la ayuda de las técnicas de Zhuyou. Pero, como sanadora, no escatimaré esfuerzos.",
          TextMapId = "voice_ch_char_Baiheng_vo_companio_03"
        },
        voice_ch_char_Baiheng_vo_die_r01 = {
          ContentES = "Debes proteger... a los demás...",
          TextMapId = "voice_ch_char_Baiheng_vo_die_r01"
        },
        voice_ch_char_Baiheng_vo_die_r02 = {
          ContentES = "Si yo... fuera una mejor sanadora...",
          TextMapId = "voice_ch_char_Baiheng_vo_die_r02"
        },
        voice_ch_char_Baiheng_vo_fail = {
          ContentES = "No temas. Toma esto para aliviar tu dolor.",
          TextMapId = "voice_ch_char_Baiheng_vo_fail"
        },
        voice_ch_char_Baiheng_vo_gain_1 = {
          ContentES = "El camino que se extiende ante nosotros es largo y está lleno de incertidumbre... Sin embargo, ya que la providencia ha entrelazado nuestros caminos, viajemos juntos, aunque solo sea por un rato.",
          TextMapId = "voice_ch_char_Baiheng_vo_gain_1"
        },
        voice_ch_char_Baiheng_vo_gain_2 = {
          ContentES = "Soy Fushu, una sanadora de Huaxu. Si estás herido o enfermo, no me lo ocultes. Aunque mis habilidades tengan sus límites, haré todo lo posible para cuidar de tu bienestar.",
          TextMapId = "voice_ch_char_Baiheng_vo_gain_2"
        },
        voice_ch_char_Baiheng_vo_idle = {
          ContentES = "Barrer y ventilar por la mañana, rociar alcohol fuerte por la tarde y encender incienso al anochecer para ahuyentar a los insectos, esa es la única manera de mantener una habitación limpia.",
          TextMapId = "voice_ch_char_Baiheng_vo_idle"
        },
        voice_ch_char_Baiheng_vo_lvup = {
          ContentES = "Mantener una dieta saludable y hacer ejercicios regularmente es un deber fundamental para cada sanador.",
          TextMapId = "voice_ch_char_Baiheng_vo_lvup"
        },
        voice_ch_char_Baiheng_vo_revive = {
          ContentES = "Como las flores, florezco de nuevo.",
          TextMapId = "voice_ch_char_Baiheng_vo_revive"
        },
        voice_ch_char_Baiheng_vo_skill01_r01 = {
          ContentES = "¡Que se mejore pronto!",
          TextMapId = "voice_ch_char_Baiheng_vo_skill01_r01"
        },
        voice_ch_char_Baiheng_vo_skill01_r02 = {
          ContentES = "¡Dolor, vete!",
          TextMapId = "voice_ch_char_Baiheng_vo_skill01_r02"
        },
        voice_ch_char_Baiheng_vo_skill02_r01 = {
          ContentES = "¡En el silencio, todo se renueva!",
          TextMapId = "voice_ch_char_Baiheng_vo_skill02_r01"
        },
        voice_ch_char_Baiheng_vo_skill02_r02 = {
          ContentES = "¡Como la luna que crece hasta alcanzar su plenitud!",
          TextMapId = "voice_ch_char_Baiheng_vo_skill02_r02"
        },
        voice_ch_char_Baiheng_vo_skill02_r03 = {
          ContentES = "Aspira profundamente la fragancia curativa.",
          TextMapId = "voice_ch_char_Baiheng_vo_skill02_r03"
        },
        voice_ch_char_Baiheng_vo_topic_01_1 = {
          ContentES = "En efecto. No obstante, el contenido es complejo y críptico, y aún no logro comprender del todo las diferencias entre ciertos remedios. Quizás simplemente no tengo la aptitud necesaria para esta disciplina.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_01_1"
        },
        voice_ch_char_Baiheng_vo_topic_01_2 = {
          ContentES = "En mi época... la medicina no era el método de curación más popular. La gente generalmente practicaba un arte curativo milagroso llamado \"Zhuyou\" para ahuyentar las enfermedades.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_01_2"
        },
        voice_ch_char_Baiheng_vo_topic_01_3 = {
          ContentES = "Aunque este método podía traer sanación y paz, exigía el sacrificio de la fuerza vital del sanador. Ninguno de nosotros vivió para ver la vejez. Derramar nuestra esencia hasta morir era el único camino que conocíamos.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_01_3"
        },
        voice_ch_char_Baiheng_vo_topic_01_4 = {
          ContentES = "El Pabellón de lo Efímero hoy no es más que una reliquia del tiempo, pero el camino de sanar y salvar vidas nunca ha carecido de sucesores. Incluso bajo la carga más pesada, siempre habrá quienes avancen con una determinación inquebrantable.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_01_4"
        },
        voice_ch_char_Baiheng_vo_topic_02_1 = {
          ContentES = "La muerte es como una lámpara que se apaga. Todas las huellas desaparecen, todas las voces se desvanecen. Esa profunda quietud aislada puede consumir hasta el último rastro de esperanza y posibilidad. Si estuviera en mi poder, evitaría que ningún paciente cayera en tal abismo.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_02_1"
        },
        voice_ch_char_Baiheng_vo_topic_02_2 = {
          ContentES = "No te equivocas. Yo... una vez regresé del umbral de la muerte, luchando por salir de las garras de una enfermedad grave. Si tuviera que enfrentar tal prueba de nuevo, no podría decir con certeza que tomaría la misma decisión.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_02_2"
        },
        voice_ch_char_Baiheng_vo_topic_03_1 = {
          ContentES = "Es un lugar para curar y salvar vidas.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_03_1"
        },
        voice_ch_char_Baiheng_vo_topic_03_2 = {
          ContentES = "Esa es la única misión del Pabellón de lo Efímero. Si hubiera que hablar de otros aspectos... cada sanador que se formó en sus muros plantó un albaricoquero el primer día de su práctica. Sin embargo, con el tiempo, las tormentas y la decadencia se llevaron a muchos. Ahora, queda menos de la mitad.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_03_2"
        },
        voice_ch_char_Baiheng_vo_topic_03_3 = {
          ContentES = "Al despertar de un largo sueño, busqué el albaricoquero que planté en mi juventud. Tristemente, el árbol se había marchitado hasta convertirse en madera estéril, y ni siquiera esta cálida primavera pudo incitar nuevos brotes de sus ramas.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_03_3"
        },
        voice_ch_char_Baiheng_vo_topic_03_4 = {
          ContentES = "La vida pasa volando, como un caballo galopando por un estrecho desfiladero, una chispa que salta de un pedernal, o un fantasma que vaga en un sueño. ¿Cuándo puede encontrar el camino en medio de tanta efemeralidad? El pasado se aleja cada vez más, mientras las esperanzas de reparación se desvanecen como la niebla matutina.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_03_4"
        },
        voice_ch_char_Baiheng_vo_topic_04_1 = {
          ContentES = "Sueño con un mundo sin enfermedades incurables.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_04_1"
        },
        voice_ch_char_Baiheng_vo_topic_04_2 = {
          ContentES = "Suena como una pura fantasía, ¿verdad? Sin embargo, incluso sin los milagros de la magia curativa, el propósito de un sanador no cambia.*risita suave* Debo admitir que, viniendo de alguien que aún tiene dificultades para comprender los libros médicos como yo, estas palabras pueden sonarles absurdas.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_04_2"
        },
        voice_ch_char_Baiheng_vo_topic_04_3 = {
          ContentES = "Pero... seguiré pisando este camino, no solo por el bien de los demás o por el legado del Pabellón de lo Efímero, sino también por mi propia realización.",
          TextMapId = "voice_ch_char_Baiheng_vo_topic_04_3"
        },
        voice_ch_char_Baiheng_vo_victory = {
          ContentES = "Necesitaré cambiarme la ropa al volver a casa.",
          TextMapId = "voice_ch_char_Baiheng_vo_victory"
        },
        voice_ch_char_Baiheng_vo_welcome = {
          ContentES = "El entorno moldea el espíritu, y el cuidado consciente fortalece el cuerpo. Quizás un paseo bajo este cielo bondadoso obre maravillas en tu salud.",
          TextMapId = "voice_ch_char_Baiheng_vo_welcome"
        },
        voice_ch_char_Baonu_vo_appear = {
          ContentES = "¡Samael, vamos!",
          TextMapId = "voice_ch_char_Baonu_vo_appear"
        },
        voice_ch_char_Baonu_vo_battleidle = {
          ContentES = "¡Sal y acepta tu paliza!",
          TextMapId = "voice_ch_char_Baonu_vo_battleidle"
        },
        voice_ch_char_Baonu_vo_battlestart = {
          ContentES = "¡La absolución es el dominio de Dios, no el mío!",
          TextMapId = "voice_ch_char_Baonu_vo_battlestart"
        },
        voice_ch_char_Baonu_vo_be_hit_heavy_r01 = {
          ContentES = "¡Miserable cobarde!",
          TextMapId = "voice_ch_char_Baonu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Baonu_vo_be_hit_heavy_r02 = {
          ContentES = "¡Samael!",
          TextMapId = "voice_ch_char_Baonu_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Baonu_vo_birthday = {
          ContentES = "¡Ejem... Me topé con esta pastelería después de completar una misión, y casualmente estaban regalando pasteles de cumpleaños gratis, y luego me encontré contigo, {性别:el pequeño alborotador|la pequeña alborotadora} que siempre necesita mi protección. Así que, eh, tú... Ayúdame a terminar este pastel de frambuesa sobrante. ¡No dejes ni una sola miga!",
          TextMapId = "voice_ch_char_Baonu_vo_birthday"
        },
        voice_ch_char_Baonu_vo_companio_01 = {
          ContentES = "¿Samael? Oh, está bien. Me despierta todas las mañanas, me anima durante el combate e incluso tiene una docena de cuentos para dormir preparados para mí. Así que no hay nada de qué preocuparse.",
          TextMapId = "voice_ch_char_Baonu_vo_companio_01"
        },
        voice_ch_char_Baonu_vo_companio_02 = {
          ContentES = "\"La Paciencia es una de las Siete Virtudes. Quienes poseen este don pueden descubrir secretos ocultos y lograr hazañas extraordinarias…\"\n¡Ya no puedo más! ¡No me imites, pequeño champiñón! ¡En nombre de los Nueve Dioses, te partiré por la mitad con Samael si lo haces una vez más!",
          TextMapId = "voice_ch_char_Baonu_vo_companio_02"
        },
        voice_ch_char_Baonu_vo_companio_03 = {
          ContentES = "¿Crema? ¿Qué pasa? Así es como los elisianos cuidamos de nuestras armas. ¿Tienes algún problema con eso?",
          TextMapId = "voice_ch_char_Baonu_vo_companio_03"
        },
        voice_ch_char_Baonu_vo_companio_04 = {
          ContentES = "Qué extraño. Nunca te había visto desahogar tu ira antes…\nBueno... ¡yo, una candidata de las Siete Virtudes, te ordeno que me muestres tu ira! Nada de seguir predicando esas virtudes, doctrinas y escrituras tontas. ¡Quiero ver una emoción de verdad por una vez!",
          TextMapId = "voice_ch_char_Baonu_vo_companio_04"
        },
        voice_ch_char_Baonu_vo_die_r01 = {
          ContentES = "No puedo… mancillar… el nombre de Samael…",
          TextMapId = "voice_ch_char_Baonu_vo_die_r01"
        },
        voice_ch_char_Baonu_vo_die_r02 = {
          ContentES = "No quiero enfrentar a los Dioses solo…",
          TextMapId = "voice_ch_char_Baonu_vo_die_r02"
        },
        voice_ch_char_Baonu_vo_fail = {
          ContentES = "No, no, no… No voy a dejar que esto me afecte…",
          TextMapId = "voice_ch_char_Baonu_vo_fail"
        },
        voice_ch_char_Baonu_vo_gain = {
          ContentES = "Contemplad, soy la gran Señorita Lisbell, candidata para la Paciencia de las Siete Virtudes de la Iglesia Elisiana. En nombre de la todopoderosa Torre, los Nueve Grandes de Elysium, los... ¿qué era? Ahem, olvida eso. De todos modos, le ordeno que se dirija a mí como \"Señorita Paciencia\". ¿Entiende?",
          TextMapId = "voice_ch_char_Baonu_vo_gain"
        },
        voice_ch_char_Baonu_vo_idle = {
          ContentES = "¡Samael, hace un día precioso afuera! ¿No es este el clima perfecto para comer algo frío? He oído que la Ciudad Sagrada tiene un postre increíble llamado helado. Es una comida de plebeyos, pero apuesto a que es mucho más sabrosa que cualquier cosa que repartan esos viejos carcas. ¡Te conseguiré un poco en secreto!",
          TextMapId = "voice_ch_char_Baonu_vo_idle"
        },
        voice_ch_char_Baonu_vo_lvup = {
          ContentES = "¡Samael, me he vuelto aún más fuerte! ¡Protejamos a estos raritos juntos!",
          TextMapId = "voice_ch_char_Baonu_vo_lvup"
        },
        voice_ch_char_Baonu_vo_revive = {
          ContentES = "¡Incluso la Señorita Paciencia tiene sus límites!",
          TextMapId = "voice_ch_char_Baonu_vo_revive"
        },
        voice_ch_char_Baonu_vo_skill01_r01 = {
          ContentES = "¡Santidad!",
          TextMapId = "voice_ch_char_Baonu_vo_skill01_r01"
        },
        voice_ch_char_Baonu_vo_skill01_r02 = {
          ContentES = "¡En el nombre de la Paciencia!",
          TextMapId = "voice_ch_char_Baonu_vo_skill01_r02"
        },
        voice_ch_char_Baonu_vo_skill02_r01 = {
          ContentES = "¡Ya no puedo más!",
          TextMapId = "voice_ch_char_Baonu_vo_skill02_r01"
        },
        voice_ch_char_Baonu_vo_skill02_r02 = {
          ContentES = "¡Samael, responde a mi llamado!",
          TextMapId = "voice_ch_char_Baonu_vo_skill02_r02"
        },
        voice_ch_char_Baonu_vo_skill02_r03 = {
          ContentES = "¡Samael, concédeme tu “ira”!",
          TextMapId = "voice_ch_char_Baonu_vo_skill02_r03"
        },
        voice_ch_char_Baonu_vo_topic_01_1 = {
          ContentES = "¡Samael no es solo un arma, es mi mejor amigo!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_01_1"
        },
        voice_ch_char_Baonu_vo_topic_01_2 = {
          ContentES = "En la Iglesia, solo aquellos elegidos por una de las Siete Reliquias pueden convertirse en una de Las Siete Virtudes. Había muchos guerreros fuertes ese día, pero yo fui la única que pudo liberar a Samael. Me eligió a mí, ¡así que claro que debo tratarlo como se merece!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_01_2"
        },
        voice_ch_char_Baonu_vo_topic_01_3 = {
          ContentES = "...Lo único es que, desde entonces, no ha respondido a mí. Ni una sola vez... ¡E-Espera! ¡Eso es un secreto de alto nivel! ¡No puedes contarle a nadie, ¿entiendes!?",
          TextMapId = "voice_ch_char_Baonu_vo_topic_01_3"
        },
        voice_ch_char_Baonu_vo_topic_01_4 = {
          ContentES = "¿¡Eh!? ¿¡No le gusta el helado!? Entonces... ¿qué tal puré de papas? ¿¡O aderezo para ensaladas!?",
          TextMapId = "voice_ch_char_Baonu_vo_topic_01_4"
        },
        voice_ch_char_Baonu_vo_topic_02_1 = {
          ContentES = "¡Uf! ¡Cállate! ¡No quiero hablar de esos viejos aguafiestas! Uf, me has arruinado el día... No, no, no puedo enfadarme. Cálmate, Lisbell...",
          TextMapId = "voice_ch_char_Baonu_vo_topic_02_1"
        },
        voice_ch_char_Baonu_vo_topic_02_2 = {
          ContentES = "¡Ejem! ¡Para nada! Son absolutamente maravillosos. Tan amables y comprensivos. Cuando te equivocas en un himno, solo tienes que copiarlo treinta veces. Y si te pillan dándole crema a Samael, solo son dos días encerrado para reflexión en solitario. Realmente, son lo mejor. Absolutamente encantadores...",
          TextMapId = "voice_ch_char_Baonu_vo_topic_02_2"
        },
        voice_ch_char_Baonu_vo_topic_03_1 = {
          ContentES = "Exactamente lo que dice. Ser paciente significa mantenerse fuerte y estoico, aguantando cualquier cosa y nunca, ¡pero nunca, enfadándose!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_03_1"
        },
        voice_ch_char_Baonu_vo_topic_03_2 = {
          ContentES = "¡¿Verdad?! Pero debido a este título, siempre me están diciendo que \"trague mi ira con paciencia\". Pero es como... como ser obligado a detener un bostezo a mitad de camino o levantar tu espada para un golpe perfecto, solo para que te digan: \"¡Oye! Ese no es un enemigo, ¡es un amigo!\" Simplemente te hace aún más...",
          TextMapId = "voice_ch_char_Baonu_vo_topic_03_2"
        },
        voice_ch_char_Baonu_vo_topic_03_3 = {
          ContentES = "¡Argh! Dicen que la ira es un pecado grave. No debo enfadarme. No debo...",
          TextMapId = "voice_ch_char_Baonu_vo_topic_03_3"
        },
        voice_ch_char_Baonu_vo_topic_03_4 = {
          ContentES = "¡Bueno... viene con el trabajo! ¡Soy la Señorita Paciencia, después de todo! Jeje!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_03_4"
        },
        voice_ch_char_Baonu_vo_topic_04_1 = {
          ContentES = "¡Las 'Siete Virtudes' son los campeones más nobles, más poderosos y más deslumbrantes de todo Elysium! ¡Naturalmente, también son los más virtuosos, está en el nombre!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_04_1"
        },
        voice_ch_char_Baonu_vo_topic_04_2 = {
          ContentES = "¿Qué significa esa mirada...? ¡Cómo te atreves a dudar de mí! ¡Te condeno a copiar el Códice treinta, no, cien veces!",
          TextMapId = "voice_ch_char_Baonu_vo_topic_04_2"
        },
        voice_ch_char_Baonu_vo_victory = {
          ContentES = "¡Todo eso fue gracias a mí, Señorita Paciencia!",
          TextMapId = "voice_ch_char_Baonu_vo_victory"
        },
        voice_ch_char_Baonu_vo_welcome = {
          ContentES = "¡Hola! Estoy sacando a Samael a tomar un poco de aire fresco, absorbiendo la luz del sol, sintiendo este lugar juntos. ¿Quieres saludarlo?¡Estará encantado! ...Bueno, ¡probablemente! Jeje~",
          TextMapId = "voice_ch_char_Baonu_vo_welcome"
        },
        voice_ch_char_Dafu_vo_appear = {
          ContentES = "Los suministros de emergencia están listos. Podemos partir en cualquier momento.",
          TextMapId = "voice_ch_char_Dafu_vo_appear"
        },
        voice_ch_char_Dafu_vo_battleidle = {
          ContentES = "Aunque la batalla cambia rápidamente, confío en tu juicio.",
          TextMapId = "voice_ch_char_Dafu_vo_battleidle"
        },
        voice_ch_char_Dafu_vo_battlestart = {
          ContentES = "Esta vez, volveremos sanos y salvos, como siempre.",
          TextMapId = "voice_ch_char_Dafu_vo_battlestart"
        },
        voice_ch_char_Dafu_vo_be_hit_heavy_r01 = {
          ContentES = "¡Cuidado!",
          TextMapId = "voice_ch_char_Dafu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Dafu_vo_be_hit_heavy_r02 = {
          ContentES = "Resiste...",
          TextMapId = "voice_ch_char_Dafu_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Dafu_vo_birthday = {
          ContentES = "¿Sabes qué hoy es un día especial? ¡Exactamente! ¡Hoy es tu cumpleaños! \nSé que, con el paso del tiempo, la vida está llena de obligaciones y responsabilidades. Siempre estamos persiguiendo metas, intentando cumplir con todo y corriendo de un lado a otro. Puede sonar un poco infantil, pero de verdad creo que el día del cumpleaños debería ser especial. Por solo un día, merecemos dejar de lado esas cargas, volver a ser niños despreocupados, disfrutando del amor y los buenos deseos de quienes se preocupan por nosotros. Así que hoy, deja a un lado tus preocupaciones. Sé {性别:un niño|una niña} feliz: disfruta del pastel, sopla las velas y pide un deseo...\n{性别:Niño|Niña}, si estás {性别:solo|sola} ahora, permíteme ser tu \"adulto\" por un momento.\n¡Feliz cumpleaños!",
          TextMapId = "voice_ch_char_Dafu_vo_birthday"
        },
        voice_ch_char_Dafu_vo_companio_01 = {
          ContentES = "Leí una vez textos médicos de Huaxu en la biblioteca de la capital. Aunque sus teorías difieren de las tradiciones médicas de Hyperborea, han demostrado ser notablemente efectivas en los tratamientos. Todavía hay partes que no comprendo del todo: ¿te importaría ayudarme con ellas?",
          TextMapId = "voice_ch_char_Dafu_vo_companio_01"
        },
        voice_ch_char_Dafu_vo_companio_02 = {
          ContentES = "Señora Acaidesa, ¿la justicia que llega tarde aún merece llamarse justicia?",
          TextMapId = "voice_ch_char_Dafu_vo_companio_02"
        },
        voice_ch_char_Dafu_vo_companio_03 = {
          ContentES = "Ha pasado tanto tiempo. Desde que dejé la Spathatoi, apenas hemos hablado. ¿Cómo estás...?",
          TextMapId = "voice_ch_char_Dafu_vo_companio_03"
        },
        voice_ch_char_Dafu_vo_companio_04 = {
          ContentES = "Aunque ya no pertenezco a la Spathatoi, siempre será un lugar en que estudié. Sé que es difícil obtener el perdón, pero quiero decirte: lo siento.",
          TextMapId = "voice_ch_char_Dafu_vo_companio_04"
        },
        voice_ch_char_Dafu_vo_die_r01 = {
          ContentES = "Soy una paramédica..., no puedo...",
          TextMapId = "voice_ch_char_Dafu_vo_die_r01"
        },
        voice_ch_char_Dafu_vo_die_r02 = {
          ContentES = "No te detengas por mí... Sigue luchando...",
          TextMapId = "voice_ch_char_Dafu_vo_die_r02"
        },
        voice_ch_char_Dafu_vo_fail = {
          ContentES = "Yo los cubriré a todos.",
          TextMapId = "voice_ch_char_Dafu_vo_fail"
        },
        voice_ch_char_Dafu_vo_gain = {
          ContentES = "Soy Daphne Theodore, paramédica de Los Grifos, subordinada a la 13.ª Legión de Hyperborea. El campo de batalla está lleno de peligros, pero no te preocupes, siempre estaré aquí para ayudarte.",
          TextMapId = "voice_ch_char_Dafu_vo_gain"
        },
        voice_ch_char_Dafu_vo_idle = {
          ContentES = "Los momentos como estos son tan raros, sin gritos de auxilio, sin informes urgentes. Hmm... Quizás me prepare un café y por fin termine esa novela. ¿Con quién terminará la Princesa...?",
          TextMapId = "voice_ch_char_Dafu_vo_idle"
        },
        voice_ch_char_Dafu_vo_lvup = {
          ContentES = "Con esto, podré aliviar más su dolor.",
          TextMapId = "voice_ch_char_Dafu_vo_lvup"
        },
        voice_ch_char_Dafu_vo_revive = {
          ContentES = "Les prometí que volveríamos juntos, sanos y salvos.",
          TextMapId = "voice_ch_char_Dafu_vo_revive"
        },
        voice_ch_char_Dafu_vo_skill01_r01 = {
          ContentES = "Anestesia y desbridamiento listos.",
          TextMapId = "voice_ch_char_Dafu_vo_skill01_r01"
        },
        voice_ch_char_Dafu_vo_skill01_r02 = {
          ContentES = "¡Torniquete para la hemorragia!",
          TextMapId = "voice_ch_char_Dafu_vo_skill01_r02"
        },
        voice_ch_char_Dafu_vo_skill02_r01 = {
          ContentES = "¿Cuánto tiempo más las llamas de la guerra exigirán nuestra sangre?",
          TextMapId = "voice_ch_char_Dafu_vo_skill02_r01"
        },
        voice_ch_char_Dafu_vo_skill02_r02 = {
          ContentES = "Mantendré el máximo respeto por la vida humana.",
          TextMapId = "voice_ch_char_Dafu_vo_skill02_r02"
        },
        voice_ch_char_Dafu_vo_skill02_r03 = {
          ContentES = "Por la paz que llegará algún día.",
          TextMapId = "voice_ch_char_Dafu_vo_skill02_r03"
        },
        voice_ch_char_Dafu_vo_topic_01_1 = {
          ContentES = "Yo... creo que no tengo ningún pasatiempo en particular. Leer, quizás, si eso cuenta.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_1"
        },
        voice_ch_char_Dafu_vo_topic_01_2 = {
          ContentES = "Mi mamá siempre dice que quedándome en casa con mis libros y sin ir a todos esos bailes y tertulias, estaré perdiendo innumerables oportunidades para ascender en la escala social...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_2"
        },
        voice_ch_char_Dafu_vo_topic_01_3 = {
          ContentES = "Pero, sinceramente, prefiero así.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_3"
        },
        voice_ch_char_Dafu_vo_topic_01_4 = {
          ContentES = "Principalmente, libros sobre medicina de campo de batalla: «Manual de Ayuda de Campo de Emergencia», «Guía Práctica para el Cuidado de Traumatismos», «Cómo Establecer un Hospital de Campaña Temporal»...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_4"
        },
        voice_ch_char_Dafu_vo_topic_01_5 = {
          ContentES = "Quizás sepas que mis estudios previos no se centraban en primeros auxilios, así que, aunque tengo la cualificación del paramédica, a veces me siento un poco superada.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_5"
        },
        voice_ch_char_Dafu_vo_topic_01_6 = {
          ContentES = "Lo sé, por eso estos días estoy leyendo un libro... que se llama «Tacones de Cristal». Cuenta una historia sobre... una princesa y un caballero... ¡No es que me gusten las novelas románticas! Solo... casualmente la abrí y eso es todo...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_01_6"
        },
        voice_ch_char_Dafu_vo_topic_02_1 = {
          ContentES = "¡Por supuesto! La alquimia es la piedra angular de Hyperborea. ¡Los eruditos la llaman el \"Milagro Primordial\"!",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_1"
        },
        voice_ch_char_Dafu_vo_topic_02_2 = {
          ContentES = "Al principio, su propósito era simple: extraer oro de Phoxene. Pero con el tiempo, la gente descubrió que este pequeño cristal podía hacer mucho más: accionar maquinaria, generar chipas de electricidad... Es la \"magia\" de los Solarianos.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_2"
        },
        voice_ch_char_Dafu_vo_topic_02_3 = {
          ContentES = "... Pero luego, la Academia de Alquimia...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_3"
        },
        voice_ch_char_Dafu_vo_topic_02_4 = {
          ContentES = "... Sí, en la Spathatoi. Pero ese capítulo de mi vida ya concluyó.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_4"
        },
        voice_ch_char_Dafu_vo_topic_02_5 = {
          ContentES = "Me fui porque la Spathatoi perdió su rumbo. Lo que comenzó como la búsqueda del conocimiento se convirtió en algo oscuro. Se ha convertido en el núcleo más ardiente de la maquinaria de guerra de Hyperborea, pero su combustible trae sufrimientos y desgracias a mucha gente.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_5"
        },
        voice_ch_char_Dafu_vo_topic_02_6 = {
          ContentES = "Supongo que... yo no era tan fuerte como creía. No podía aceptar en lo que se había convertido, y no tenía el valor ni la fuerza para cambiarlo. Por eso, hice lo único que podía: me fui.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_02_6"
        },
        voice_ch_char_Dafu_vo_topic_03_1 = {
          ContentES = "Algunos artículos y medicamentos de primeros auxilios. Hay vendas, antisépticos, anestésicos y herramientas básicas para el cuidado de heridas, como bisturíes y suturas.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_03_1"
        },
        voice_ch_char_Dafu_vo_topic_03_2 = {
          ContentES = "También llevo un pañuelo y un peine.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_03_2"
        },
        voice_ch_char_Dafu_vo_topic_03_3 = {
          ContentES = "No, no es lo que piensas... No son para mí misma, sino para los fallecidos. Los uso para ayudar a quienes fallecen... para que se vean presentables.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_03_3"
        },
        voice_ch_char_Dafu_vo_topic_03_4 = {
          ContentES = "La crueldad de la muerte no solo arrebata la vida, sino también la dignidad del ser humano.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_03_4"
        },
        voice_ch_char_Dafu_vo_topic_03_5 = {
          ContentES = "Solo quiero que... cuando sus familias vengan a darles su último adiós, puedan ver a sus seres queridos en paz, como si simplemente estuvieran durmiendo. Tras estar separados tanto tiempo, ningún padre o madre debería tener que ver el rostro de su hijo retorcido por el dolor...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_03_5"
        },
        voice_ch_char_Dafu_vo_topic_04_1 = {
          ContentES = "¡Oh, no, está bien! Puedo manejar... Bueno, a veces sí es un poco difícil... Las clases de primeros auxilios y enfermería no son tan difíciles, pero las pruebas de aptitud física... sí me resultan muy difíciles.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_04_1"
        },
        voice_ch_char_Dafu_vo_topic_04_2 = {
          ContentES = "Aunque me levanto antes que todos para entrenar más, apenas consigo aprobar... Por favor no te rías de mí. Adquirir resistencia física es mucho más difícil que estudiar.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_04_2"
        },
        voice_ch_char_Dafu_vo_topic_04_3 = {
          ContentES = "Sí, lo es. Pero cuando dejo de pensar en mis piernas cansadas y miro hacia arriba, veo los campos de trigo extendiéndose más allá de la ciudad y las casitas en el horizonte, escucho el crujido de los molinos de viento y el silbido de los pastores. Siempre me hace sentir mucho mejor.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_04_3"
        },
        voice_ch_char_Dafu_vo_topic_04_4 = {
          ContentES = "Porque... correr por ese camino me da la sensación de estar protegiendo esas cosas sencillas y preciosas de que sean arrebatadas.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_04_4"
        },
        voice_ch_char_Dafu_vo_topic_05_1 = {
          ContentES = "... La última vez que hablé con mi papá fue por el radio. Estaba en el campo de batalla de la Fortaleza de Lonza, y a pesar del peligro, me dijo: No te preocupes, estaré bien.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_05_1"
        },
        voice_ch_char_Dafu_vo_topic_05_2 = {
          ContentES = "Después de todo lo que pasó, a menudo encendía el radio en plena noche, sintonizaba su canal y pulsaba el botón de llamada, con la esperanza de oír su voz de nuevo...",
          TextMapId = "voice_ch_char_Dafu_vo_topic_05_2"
        },
        voice_ch_char_Dafu_vo_topic_05_3 = {
          ContentES = "No fue sino hasta que me senté allí en silencio durante lo que me pareció una eternidad que me di cuenta... de que nunca volvería.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_05_3"
        },
        voice_ch_char_Dafu_vo_topic_05_4 = {
          ContentES = "Gracias. No te preocupes, me mantendré fuerte y seguiré adelante. No pararé hasta que limpie el nombre de mi padre y honre a los agraviados que cayeron en la Batalla de Lonza.",
          TextMapId = "voice_ch_char_Dafu_vo_topic_05_4"
        },
        voice_ch_char_Dafu_vo_victory = {
          ContentES = "Ojalá esta fuera la última batalla... ¡Qué bueno sería!",
          TextMapId = "voice_ch_char_Dafu_vo_victory"
        },
        voice_ch_char_Dafu_vo_welcome = {
          ContentES = "Es un placer verte hoy sano y salvo. Cuídate... La paz que todos anhelamos llegará sin duda algún día.",
          TextMapId = "voice_ch_char_Dafu_vo_welcome"
        },
        voice_ch_char_Feina_vo_appear = {
          ContentES = "¿De verdad que me llevarás a jugar? ¡Es una promesa! ¡Nada de romper la promesa!",
          TextMapId = "voice_ch_char_Feina_vo_appear"
        },
        voice_ch_char_Feina_vo_battleidle = {
          ContentES = "¿Dónde se habrá ido todo el mundo...?",
          TextMapId = "voice_ch_char_Feina_vo_battleidle"
        },
        voice_ch_char_Feina_vo_battlestart = {
          ContentES = "¡Qué jardín tan grande!",
          TextMapId = "voice_ch_char_Feina_vo_battlestart"
        },
        voice_ch_char_Feina_vo_be_hit_heavy_r02 = {
          ContentES = "¡No tengo miedo...!",
          TextMapId = "voice_ch_char_Feina_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Feina_vo_be_hit_r02 = {
          ContentES = "¡No me toques!",
          TextMapId = "voice_ch_char_Feina_vo_be_hit_r02"
        },
        voice_ch_char_Feina_vo_birthday = {
          ContentES = "En el día de su cumpleaños, {性别:Señor|Señorita} Unicornio Blanco regresó a su casita pequeña y acogedora. El pájaro de plumas blancas le trajo las hojas de laurel, el mago entonaba conjuros que llenaban el aire de risas, el valiente caballero permanecía fielmente a su lado, como siempre. Las llamas bailaban alegremente en la chimenea, mientras los copos de nieve traían las bendiciones desde el cielo. La felicidad rebosaba de la pequeña casita...",
          TextMapId = "voice_ch_char_Feina_vo_birthday"
        },
        voice_ch_char_Feina_vo_companio_01 = {
          ContentES = "Prométeme que nunca, jamás, jamás... irás a ese lugar tan aterrador lleno de magos malvados, ¿vale?",
          TextMapId = "voice_ch_char_Feina_vo_companio_01"
        },
        voice_ch_char_Feina_vo_companio_02 = {
          ContentES = "¿Qué es eso? ¿Es tu mascota, Señorita Hámster? ¡Increíble! ¡Seguramente puede llevarte volando por encima de las murallas de los castillos!",
          TextMapId = "voice_ch_char_Feina_vo_companio_02"
        },
        voice_ch_char_Feina_vo_companio_03 = {
          ContentES = "Señorita Leonisa, ¿estás intentando despertar al hada dormida dentro de la espada gigante? Quizás necesites recitar muchos conjuros, como: ¡Oh, aquel que despertó la sagrada espada Samael será destinado a ser rey de Elysium!",
          TextMapId = "voice_ch_char_Feina_vo_companio_03"
        },
        voice_ch_char_Feina_vo_companio_04 = {
          ContentES = "Señor Caballito de mar del sur, me suena haberte visto antes... Hmm... ¡Ah, ya me acuerdo! Hace muchísimo tiempo, papá colgó tu retrato en la pared de casa.",
          TextMapId = "voice_ch_char_Feina_vo_companio_04"
        },
        voice_ch_char_Feina_vo_die_r01 = {
          ContentES = "Es hora de que me vaya a esa tierra lejana...",
          TextMapId = "voice_ch_char_Feina_vo_die_r01"
        },
        voice_ch_char_Feina_vo_die_r02 = {
          ContentES = "Es como si hubiera tenido un sueño muy largo...",
          TextMapId = "voice_ch_char_Feina_vo_die_r02"
        },
        voice_ch_char_Feina_vo_fail = {
          ContentES = "No me gusta este final... nada de nada.",
          TextMapId = "voice_ch_char_Feina_vo_fail"
        },
        voice_ch_char_Feina_vo_gain = {
          ContentES = "\"¡Chir, chir!\" dijo el ruiseñor. Quiere decir: ¡Hola, {性别:Señor/Señorita} Unicornio blanco! A partir de ahora, ¡tú y Fina seréis {性别:buenos amigos/buenas amigas}!",
          TextMapId = "voice_ch_char_Feina_vo_gain"
        },
        voice_ch_char_Feina_vo_idle = {
          ContentES = "♪ Qué casita tan pequeña, tan pequeña... Se esconde entre el verdor de las copas de los árboles, entre los ríos dorados... Mira esa chimenea, las brasas crepitan... Sosteniendo el soldadito de plomo recién reparado por papá, escuchando a mamá cantar una nana... Duérmete...",
          TextMapId = "voice_ch_char_Feina_vo_idle"
        },
        voice_ch_char_Feina_vo_lvup = {
          ContentES = "¡Gaua...!",
          TextMapId = "voice_ch_char_Feina_vo_lvup"
        },
        voice_ch_char_Feina_vo_revive = {
          ContentES = "¿Eh...? ¿Qué pasó...?",
          TextMapId = "voice_ch_char_Feina_vo_revive"
        },
        voice_ch_char_Feina_vo_skill01_r01 = {
          ContentES = "♪ Las estrellas~ brillan~",
          TextMapId = "voice_ch_char_Feina_vo_skill01_r01"
        },
        voice_ch_char_Feina_vo_skill01_r02 = {
          ContentES = "♪ Mi jardín~precioso~",
          TextMapId = "voice_ch_char_Feina_vo_skill01_r02"
        },
        voice_ch_char_Feina_vo_skill02_r01 = {
          ContentES = "¡Amigos de Fina, vengan y protejamos a todos!",
          TextMapId = "voice_ch_char_Feina_vo_skill02_r01"
        }
      }
    end
  },
  {
    MinKey = "voice_ch_char_Feina_vo_skill02_r02",
    MaxKey = "voice_ch_char_Lise_vo_battleidle",
    Loader = function()
      return {
        voice_ch_char_Feina_vo_skill02_r02 = {
          ContentES = "¡No se permiten peleas en el jardín!",
          TextMapId = "voice_ch_char_Feina_vo_skill02_r02"
        },
        voice_ch_char_Feina_vo_skill02_r03 = {
          ContentES = "¡Tengan cuidado, mis valientes soldados!",
          TextMapId = "voice_ch_char_Feina_vo_skill02_r03"
        },
        voice_ch_char_Feina_vo_topic_01_1 = {
          ContentES = "Hmm, tengo una pregunta, si existe un dulce que me hiciera crecer alta...",
          TextMapId = "voice_ch_char_Feina_vo_topic_01_1"
        },
        voice_ch_char_Feina_vo_topic_01_2 = {
          ContentES = "Después de comer ese dulce, ¿podría crecer tan alta que pudiera ver por encima de las nubes e incluso tocar las estrellas?",
          TextMapId = "voice_ch_char_Feina_vo_topic_01_2"
        },
        voice_ch_char_Feina_vo_topic_01_3 = {
          ContentES = "¡Seguramente que no, prometo caminar con mucho cuidado! Bueno... si estás muy preocupada, puedes posarte en mi mano y damos un paseo. ¿Qué te parece?",
          TextMapId = "voice_ch_char_Feina_vo_topic_01_3"
        },
        voice_ch_char_Feina_vo_topic_02_1 = {
          ContentES = "Tengo un gran cofre de cristal lleno de nieve suave, como la que cae fuera de mi ventana, y algodón del azúcar blanco como la nieve. También me gustaría meter las nubes tan suaves como eso algodón de azúcar y las brisas tan cálidas como esas nubes...",
          TextMapId = "voice_ch_char_Feina_vo_topic_02_1"
        },
        voice_ch_char_Feina_vo_topic_02_2 = {
          ContentES = "Y también vuestras risas y carcajadas, todas se meten en ese cofre~",
          TextMapId = "voice_ch_char_Feina_vo_topic_02_2"
        },
        voice_ch_char_Feina_vo_topic_02_3 = {
          ContentES = "Hum... si puedes comer uno de esos dulces que te hacen encoger, podrías entrar. Pero todo es blanco allí, así que ten cuidado de no perderte.",
          TextMapId = "voice_ch_char_Feina_vo_topic_02_3"
        },
        voice_ch_char_Feina_vo_topic_02_4 = {
          ContentES = "Mmm... déjame pensar... Si te pierdes, esparciré un sendero de migas de pan para ti... ¡Síguelo, y encontrarás la salida!",
          TextMapId = "voice_ch_char_Feina_vo_topic_02_4"
        },
        voice_ch_char_Feina_vo_topic_03_1 = {
          ContentES = "¡Mmm...! En mi sueño, vi un ruiseñor con plumas blancas, que un momento descansaba en mi mano y al siguiente jugaba a las escondidas conmigo por la casa... Hmm, ¿fui yo quien soñó, o acaso él soñó conmigo?",
          TextMapId = "voice_ch_char_Feina_vo_topic_03_1"
        },
        voice_ch_char_Feina_vo_topic_03_2 = {
          ContentES = "¡Quizás tengas razón! Tal vez sea un mundo mágico donde todos los niños y animalitos que duermen puedan jugar juntos. Hmm... ¿con quién me encontraré en mi próximo sueño? ¿El Búho Sabio, la Señorita Canario o el Señor Conejo?",
          TextMapId = "voice_ch_char_Feina_vo_topic_03_2"
        },
        voice_ch_char_Feina_vo_topic_04_1 = {
          ContentES = "Antes tenía una mamá y dos papás. Pero ya no están...",
          TextMapId = "voice_ch_char_Feina_vo_topic_04_1"
        },
        voice_ch_char_Feina_vo_topic_04_2 = {
          ContentES = "El primer papá se fue a una tierra lejana con mamá. Y el segundo... también se fue a una tierra lejana... Yo lo llevé allí.",
          TextMapId = "voice_ch_char_Feina_vo_topic_04_2"
        },
        voice_ch_char_Feina_vo_topic_05_1 = {
          ContentES = "Él es el mejor mago, con la voz más suave y con el corazón más bondadoso de todo el mundo...",
          TextMapId = "voice_ch_char_Feina_vo_topic_05_1"
        },
        voice_ch_char_Feina_vo_topic_05_2 = {
          ContentES = "Eh, ¿qué ocurre? Pareces muy confundida.",
          TextMapId = "voice_ch_char_Feina_vo_topic_05_2"
        },
        voice_ch_char_Feina_vo_topic_05_3 = {
          ContentES = "¿Eh...? ¿Quieres decir que él no es amable ni suave contigo? Lo siento mucho... ¡Le daré un golpecito en la cabeza y le pediré que sea más amable contigo!",
          TextMapId = "voice_ch_char_Feina_vo_topic_05_3"
        },
        voice_ch_char_Feina_vo_victory = {
          ContentES = "\"Desde entonces, todos vivieron felices para siempre.\" Buenas noches. Que tengas dulces sueños.",
          TextMapId = "voice_ch_char_Feina_vo_victory"
        },
        voice_ch_char_Feina_vo_welcome = {
          ContentES = "... Ah... eres tú. Hola, ¿cómo estás?",
          TextMapId = "voice_ch_char_Feina_vo_welcome"
        },
        voice_ch_char_Haier_vo_appear = {
          ContentES = "¿Dónde están los pecadores?",
          TextMapId = "voice_ch_char_Haier_vo_appear"
        },
        voice_ch_char_Haier_vo_battleidle = {
          ContentES = "¿Tienes miedo? Creí que eras más fuerte que los demás pecadores. ¡Qué decepción!",
          TextMapId = "voice_ch_char_Haier_vo_battleidle"
        },
        voice_ch_char_Haier_vo_battlestart = {
          ContentES = "¡Todos los pecados serán purgados en las llamas!",
          TextMapId = "voice_ch_char_Haier_vo_battlestart"
        },
        voice_ch_char_Haier_vo_be_hit_heavy_r01 = {
          ContentES = "¡Pecador!",
          TextMapId = "voice_ch_char_Haier_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Haier_vo_be_hit_heavy_r02 = {
          ContentES = "¡Mantente firme!",
          TextMapId = "voice_ch_char_Haier_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Haier_vo_birthday = {
          ContentES = "¿Cumpleaños? ¡Ja! Como si a una Alcaidesa le importaran tales tonterías. Ja, ¿recibir bendiciones te hace feliz? Eres tan fácil de complacer... Bah. ¡Feliz cumpleaños! Haré una excepción y beberé contigo, pero solo hoy.",
          TextMapId = "voice_ch_char_Haier_vo_birthday"
        },
        voice_ch_char_Haier_vo_companio_01 = {
          ContentES = "Yo soy la Alcaidesa y tú, la Jefa de la Legión. Juntas, somos las implacables guardianas del oscuro orden del Imperio. Su odio hacia nosotras no significa nada, ¡mientras sirvamos a Hyperborea!",
          TextMapId = "voice_ch_char_Haier_vo_companio_01"
        },
        voice_ch_char_Haier_vo_companio_02 = {
          ContentES = "Nos encontramos otra vez.",
          TextMapId = "voice_ch_char_Haier_vo_companio_02"
        },
        voice_ch_char_Haier_vo_companio_03 = {
          ContentES = "¡Bah! Eres el Ayudante de Sibylle... el que siempre es acusado de incumplimiento de sus deberes, ¿eh? Puedo ver que escondes tu destreza y ambición solo para estar al lado de Sibylle. Entonces, ¿cuáles son tus motivos ocultos?",
          TextMapId = "voice_ch_char_Haier_vo_companio_03"
        },
        voice_ch_char_Haier_vo_die_r01 = {
          ContentES = "Por el orden del Imperio...",
          TextMapId = "voice_ch_char_Haier_vo_die_r01"
        },
        voice_ch_char_Haier_vo_die_r02 = {
          ContentES = "Yo... no temo... al infierno...",
          TextMapId = "voice_ch_char_Haier_vo_die_r02"
        },
        voice_ch_char_Haier_vo_fail = {
          ContentES = "¡Debo acabar con esta inmundicia con mis propias manos!",
          TextMapId = "voice_ch_char_Haier_vo_fail"
        },
        voice_ch_char_Haier_vo_gain = {
          ContentES = "¡Interesante! El criminal del Imperio ha venido a mí por su propia voluntad. Pues bien, prepárate para la agonía mientras te reduzco a cenizas. Yo soy Hellfire, ¡y te mostraré lo que es el infierno de verdad!",
          TextMapId = "voice_ch_char_Haier_vo_gain"
        },
        voice_ch_char_Haier_vo_idle = {
          ContentES = "¡Qué vista tan placentera!... ¿No tienes miedo de mi fuego? ¡Ja, hormiga ignorante! Lamentarás tu ignorancia cuando te aplasté contra el suelo.",
          TextMapId = "voice_ch_char_Haier_vo_idle"
        },
        voice_ch_char_Haier_vo_lvup = {
          ContentES = "Bueno... Mi llama arde con ferocidad ahora.",
          TextMapId = "voice_ch_char_Haier_vo_lvup"
        },
        voice_ch_char_Haier_vo_revive = {
          ContentES = "Este mundo tiene más pecadores que el infierno.",
          TextMapId = "voice_ch_char_Haier_vo_revive"
        },
        voice_ch_char_Haier_vo_skill01_r01 = {
          ContentES = "¡Arde!",
          TextMapId = "voice_ch_char_Haier_vo_skill01_r01"
        },
        voice_ch_char_Haier_vo_skill01_r02 = {
          ContentES = "¡Abraza el miedo!",
          TextMapId = "voice_ch_char_Haier_vo_skill01_r02"
        },
        voice_ch_char_Haier_vo_skill02_r01 = {
          ContentES = "¡Prepárate para un interrogatorio ardiente!",
          TextMapId = "voice_ch_char_Haier_vo_skill02_r01"
        },
        voice_ch_char_Haier_vo_skill02_r02 = {
          ContentES = "¡Sin piedad!",
          TextMapId = "voice_ch_char_Haier_vo_skill02_r02"
        },
        voice_ch_char_Haier_vo_skill02_r03 = {
          ContentES = "¡Cuenta tus pecados!",
          TextMapId = "voice_ch_char_Haier_vo_skill02_r03"
        },
        voice_ch_char_Haier_vo_topic_01_1 = {
          ContentES = "Si conocieras la historia, sabrías que la primera Alcaidesa de la Prisión Militar Real tenía la piel como lava fundida. Incluso los criminales más despiadados temían sus interrogatorios.",
          TextMapId = "voice_ch_char_Haier_vo_topic_01_1"
        },
        voice_ch_char_Haier_vo_topic_01_2 = {
          ContentES = "Yo, como descendiente suya, llevo con orgullo su título, lista para incinerar todos los pecados con mi fuego.",
          TextMapId = "voice_ch_char_Haier_vo_topic_01_2"
        },
        voice_ch_char_Haier_vo_topic_01_3 = {
          ContentES = "Sí tiene algunos desafíos: solo puedo dormir en camas de hierro y no puedo estar mucho tiempo en estructuras de madera. Sin embargo, me permite sacar criminales de edificios en llamas y administrar justicia. Además, el frío nunca me molesta.",
          TextMapId = "voice_ch_char_Haier_vo_topic_01_3"
        },
        voice_ch_char_Haier_vo_topic_01_4 = {
          ContentES = "Mi aspecto inusual es más bien un regalo para mí. Si acaso tiene algún inconveniente... siempre he querido probar el helado, pero se derrite en mi mano antes de poder saborearlo...",
          TextMapId = "voice_ch_char_Haier_vo_topic_01_4"
        },
        voice_ch_char_Haier_vo_topic_02_1 = {
          ContentES = "Desde la fundación del Imperio, mi familia ha gestionado la prisión donde se encarcelaban los criminales más atroces, corrigiendo los errores o eliminando las amenazas.",
          TextMapId = "voice_ch_char_Haier_vo_topic_02_1"
        },
        voice_ch_char_Haier_vo_topic_02_2 = {
          ContentES = "Mi piel de un rojo intenso, legado de mi antepasado, la primera guardia, me predestinó a hacer cumplir el estricto código que ella estableció. Así que no fui yo quien eligió ser Alcaidesa, fue el manto de la Alcaidesa el que me eligió.",
          TextMapId = "voice_ch_char_Haier_vo_topic_02_2"
        },
        voice_ch_char_Haier_vo_topic_02_3 = {
          ContentES = "Convertirme en Alcaidesa es solo el principio. Me obliga a permanecer vigilante, erradicando cualquier injusticia dentro del Imperio hasta mi último suspiro.",
          TextMapId = "voice_ch_char_Haier_vo_topic_02_3"
        },
        voice_ch_char_Haier_vo_topic_03_1 = {
          ContentES = "Por supuesto. La prisión del Imperio está llena de criminales astutos. Mis deberes incluyen realizar interrogatorios, revisar expedientes y frustrar los intentos de escape.",
          TextMapId = "voice_ch_char_Haier_vo_topic_03_1"
        },
        voice_ch_char_Haier_vo_topic_03_2 = {
          ContentES = "Cada minuto de descanso retrasa la justicia, y cuando la justicia se retrasa, el caos y la ley de la selva prevalecen.",
          TextMapId = "voice_ch_char_Haier_vo_topic_03_2"
        },
        voice_ch_char_Haier_vo_topic_03_3 = {
          ContentES = "Algunos eruditos han imaginado un mundo sin crímenes. Si ese día llegara, mi propósito desaparecería, pues el mal exige la existencia de una Alcaidesa. Hasta entonces, estoy comprometida con el mantenimiento del orden.",
          TextMapId = "voice_ch_char_Haier_vo_topic_03_3"
        },
        voice_ch_char_Haier_vo_topic_04_1 = {
          ContentES = "¿Justicia? La justicia es el control del deseo mediante el poder, la supresión del mal mediante la fuerza y el castigo de los malvados por los poderosos.",
          TextMapId = "voice_ch_char_Haier_vo_topic_04_1"
        },
        voice_ch_char_Haier_vo_topic_04_2 = {
          ContentES = "¿Hmph, simplista? No esperaría que un niño ingenuo lo entendiera. No vivimos en una utopía donde la gente simplemente se da la mano y se ama. ¡Solo a través del poder absoluto y el orden se puede asegurar la verdadera justicia!",
          TextMapId = "voice_ch_char_Haier_vo_topic_04_2"
        },
        voice_ch_char_Haier_vo_topic_05_1 = {
          ContentES = "Con los criminales aun vagando por las calles del Imperio, el tiempo libre es un lujo para la Acaidesa. El único respiro que tengo es cuando me tomo unos tragos de licor fuerte entre tanta actividad.",
          TextMapId = "voice_ch_char_Haier_vo_topic_05_1"
        },
        voice_ch_char_Haier_vo_topic_05_2 = {
          ContentES = "¿Por qué tanta sorpresa? Es solo una distracción. Durante los interrogatorios, siempre escuché hablar de varios tipos de alcohol. Eso despertó mi curiosidad por esa supuesta poción malvada que siempre parecía estar asociada al crimen. Así que bebo de vez en cuando.",
          TextMapId = "voice_ch_char_Haier_vo_topic_05_2"
        },
        voice_ch_char_Haier_vo_topic_05_3 = {
          ContentES = "Y cuanto más bebo, más convencida estoy de que no es la bebida la que es mala.",
          TextMapId = "voice_ch_char_Haier_vo_topic_05_3"
        },
        voice_ch_char_Haier_vo_victory = {
          ContentES = "¿No puedes soportarlo? ¡Esto es solo el comienzo!",
          TextMapId = "voice_ch_char_Haier_vo_victory"
        },
        voice_ch_char_Haier_vo_welcome = {
          ContentES = "¿Estás listo para el interrogatorio?",
          TextMapId = "voice_ch_char_Haier_vo_welcome"
        },
        voice_ch_char_Heitao_vo_appear = {
          ContentES = "Vamos.",
          TextMapId = "voice_ch_char_Heitao_vo_appear"
        },
        voice_ch_char_Heitao_vo_battleidle = {
          ContentES = "... Terminemos este combate pronto y volvamos a casa.",
          TextMapId = "voice_ch_char_Heitao_vo_battleidle"
        },
        voice_ch_char_Heitao_vo_battlestart = {
          ContentES = "Iré primero.",
          TextMapId = "voice_ch_char_Heitao_vo_battlestart"
        },
        voice_ch_char_Heitao_vo_birthday = {
          ContentES = "Me dijiste que querías celebrar tu cumpleaños como los demás. Por eso te ha preparado un pastel como los demás. Dicen que un cumpleaños sin pastel no es un cumpleaños completo. Espero que te llenes de... alegrías cada vez que escuches la palabra \"Cumpleaños\" en el futuro.",
          TextMapId = "voice_ch_char_Heitao_vo_birthday"
        },
        voice_ch_char_Heitao_vo_companio_01 = {
          ContentES = "Durante todos estos años, he cuidado bien de {性别:él/ella} y de mí misma, tal como te prometí... ¿Podrías acariciar mi cabeza y decirme que lo he hecho bien, como solías hacer cuando yo era {性别:pequeño|pequeña}? Y esta vez, por favor no no vuelvas a dejarnos...",
          TextMapId = "voice_ch_char_Heitao_vo_companio_01"
        },
        voice_ch_char_Heitao_vo_companio_02_1 = {
          ContentES = "Señorita Truffle, ¿podría... acariciar a su cerdito? Solo una vez. Por favor, sujételo para mí, temo que se escape. Los animalitos siempre parecen huir de mí cuando me los acerca.",
          TextMapId = "voice_ch_char_Heitao_vo_companio_02_1"
        },
        voice_ch_char_Heitao_vo_companio_02_2 = {
          ContentES = "Gracias... Ah, qué suave y cálido, qué agradable...",
          TextMapId = "voice_ch_char_Heitao_vo_companio_02_2"
        },
        voice_ch_char_Heitao_vo_companio_03 = {
          ContentES = "No soy esa \"N.º 0\" de la Legión, ni tu títere. Vete, porque no me iré contigo vivo.",
          TextMapId = "voice_ch_char_Heitao_vo_companio_03"
        },
        voice_ch_char_Heitao_vo_companio_04_1 = {
          ContentES = "He oído que eres una gran gourmet. ¿Podrías compartir algunas de tus recetas? {nickname} siempre habla maravillas de tu cocina, y no es solo adulación, es un elogio sincero.",
          TextMapId = "voice_ch_char_Heitao_vo_companio_04_1"
        },
        voice_ch_char_Heitao_vo_companio_04_2 = {
          ContentES = "Espera, ¿eso es todo? Entonces, ¿por qué...? ¿Cuál es tu secreto?",
          TextMapId = "voice_ch_char_Heitao_vo_companio_04_2"
        },
        voice_ch_char_Heitao_vo_die_r01 = {
          ContentES = "Debo... proteger...",
          TextMapId = "voice_ch_char_Heitao_vo_die_r01"
        },
        voice_ch_char_Heitao_vo_die_r02 = {
          ContentES = "Quiero volver... al lugar que convenimos...",
          TextMapId = "voice_ch_char_Heitao_vo_die_r02"
        },
        voice_ch_char_Heitao_vo_fail = {
          ContentES = "Me alegra mucho que estás a salvo.",
          TextMapId = "voice_ch_char_Heitao_vo_fail"
        },
        voice_ch_char_Heitao_vo_gain = {
          ContentES = "He vuelto.",
          TextMapId = "voice_ch_char_Heitao_vo_gain"
        },
        voice_ch_char_Heitao_vo_idle = {
          ContentES = "{性别:Él|Ella} nunca quería vivir como un pájaro enjaulado. Sé que algún día {性别:él/ella} abandonará esa isla para alcanzar el cielo. Pero lo que no puede saber es si eso será una bendición o una maldición para nosotros.",
          TextMapId = "voice_ch_char_Heitao_vo_idle"
        },
        voice_ch_char_Heitao_vo_lvup = {
          ContentES = "¿Qué te parece?",
          TextMapId = "voice_ch_char_Heitao_vo_lvup"
        },
        voice_ch_char_Heitao_vo_revive = {
          ContentES = "Todavía no termina.",
          TextMapId = "voice_ch_char_Heitao_vo_revive"
        },
        voice_ch_char_Heitao_vo_skill01_r01 = {
          ContentES = "Te despedazaré.",
          TextMapId = "voice_ch_char_Heitao_vo_skill01_r01"
        },
        voice_ch_char_Heitao_vo_skill01_r02 = {
          ContentES = "Rendir.",
          TextMapId = "voice_ch_char_Heitao_vo_skill01_r02"
        },
        voice_ch_char_Heitao_vo_skill02_r01 = {
          ContentES = "Te terminaré.",
          TextMapId = "voice_ch_char_Heitao_vo_skill02_r01"
        },
        voice_ch_char_Heitao_vo_skill02_r02 = {
          ContentES = "Adiós.",
          TextMapId = "voice_ch_char_Heitao_vo_skill02_r02"
        },
        voice_ch_char_Heitao_vo_skill02_r03 = {
          ContentES = "Nunca daré clemencia a quienes te hayan hecho daño.",
          TextMapId = "voice_ch_char_Heitao_vo_skill02_r03"
        },
        voice_ch_char_Heitao_vo_topic_01_1 = {
          ContentES = "...No lo sé. Yo tampoco estoy segura. Quizás sea un hermoso sueño, en el que nunca me haya alejado de tu lado, como siempre.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_01_1"
        },
        voice_ch_char_Heitao_vo_topic_01_2 = {
          ContentES = "Yo también quería verte, muchísimo... Ojalá nos podamos volver a encontrar algún día.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_01_2"
        },
        voice_ch_char_Heitao_vo_topic_02_1 = {
          ContentES = "¿Deseo? A mí... no se me ocurre ningún deseo. Tu sonrisa por cada mañana ya es el mejor ánimo para mí.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_02_1"
        },
        voice_ch_char_Heitao_vo_topic_02_2 = {
          ContentES = "No te presiones demasiado. Si te sientes deprimida, ven a hablar conmigo. O si no tienes ganas de hablar, podemos pasar un momento en silencio {性别:juntosl|juntas}.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_02_2"
        },
        voice_ch_char_Heitao_vo_topic_03_1 = {
          ContentES = "A diferencia de la Isla del Purgatorio, aquí nieva todos los días. Por suerte, tienes un lugar cálido para quedarte. En comparación con nuestra pequeña cabaña en la Isla del Purgatorio, este lugar es bastante lujoso.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_03_1"
        },
        voice_ch_char_Heitao_vo_topic_03_2 = {
          ContentES = "¿Recuerdas cómo se te quedaban siempre las manos heladas en invierno? Ven, déjame calentártelas.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_03_2"
        },
        voice_ch_char_Heitao_vo_topic_04_1 = {
          ContentES = "Bueno, ese lugar es como una ciudad hecha de acero... Mm, más bien como una prisión exactamente. Pasé mi infancia allí.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_04_1"
        },
        voice_ch_char_Heitao_vo_topic_04_2 = {
          ContentES = "Más tarde, alguien me escapó de allí. Junta contigo, nos llevó a la Isla del Purgatorio. No puedo decirte mucho sobre ella... Lo siento. Le prometí que no lo diría a nadie.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_04_2"
        },
        voice_ch_char_Heitao_vo_topic_04_3 = {
          ContentES = "... La vida en la Isla del Purgatorio era tan tranquila que casi creía que podríamos vivir así para siempre. Pero hasta el día en que ellos vinieron ante mí, no me di cuenta de que yo nunca había escapado verdaderamente de esa prisión.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_04_3"
        },
        voice_ch_char_Heitao_vo_topic_05_1 = {
          ContentES = "Sí, es un poco ruidoso, pero no me disgusta. Has hecho muchos nuevos amigos aquí, esto es bueno, me alegro mucho por ti.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_05_1"
        },
        voice_ch_char_Heitao_vo_topic_05_2 = {
          ContentES = "De esta manera, nunca te sentirás sola, incluso cuando yo no esté de tu lado.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_05_2"
        },
        voice_ch_char_Heitao_vo_topic_06_1 = {
          ContentES = "Pues, descansa un momento con la cabeza en mi regazo, como en los viejos tiempos.",
          TextMapId = "voice_ch_char_Heitao_vo_topic_06_1"
        },
        voice_ch_char_Heitao_vo_victory = {
          ContentES = "Todo ha terminado.",
          TextMapId = "voice_ch_char_Heitao_vo_victory"
        },
        voice_ch_char_Heitao_vo_welcome = {
          ContentES = "Bienvenida de vuelta. ¿Qué plan tienes para hoy? ¿O prefieres descansar en casa?",
          TextMapId = "voice_ch_char_Heitao_vo_welcome"
        },
        voice_ch_char_Kezhou_vo_appear = {
          ContentES = "Para matar, usa la espada; para encontrar la paz, afila la espada interior.",
          TextMapId = "voice_ch_char_Kezhou_vo_appear"
        },
        voice_ch_char_Kezhou_vo_battleidle = {
          ContentES = "Todavía me quedan trucos. ¡Vamos a otra ronda!",
          TextMapId = "voice_ch_char_Kezhou_vo_battleidle"
        },
        voice_ch_char_Kezhou_vo_battlestart = {
          ContentES = "Incluso el león da el cien por cien al cazar una liebre.",
          TextMapId = "voice_ch_char_Kezhou_vo_battlestart"
        },
        voice_ch_char_Kezhou_vo_be_hit_heavy_r01 = {
          ContentES = "¡Buen golpe!",
          TextMapId = "voice_ch_char_Kezhou_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Kezhou_vo_be_hit_heavy_r02 = {
          ContentES = "Sin heridas graves.",
          TextMapId = "voice_ch_char_Kezhou_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Kezhou_vo_birthday = {
          ContentES = "¡Hoy es un día perfecto para beber y cantar!... ¿Qué? ¿Es tu cumpleaños? \nNosotros, los errantes, no le damos mucha importancia a los cumpleaños. En esta vida dura, nunca sabes cuándo será tu último día, así que no solíamos celebrar nada.\nPero oye, ya que eres {性别:un forastero|una forastera} y entrenas conmigo todos los días, una celebración es lo justo.\nPues... ¡Que hoy resuenen las canciones de los héroes! ¡Cantemos en honor al joven y valiente Phoxcazador, fiel a su honor y a sus promesas, tan valiosas como el oro!",
          TextMapId = "voice_ch_char_Kezhou_vo_birthday"
        },
        voice_ch_char_Kezhou_vo_companio_01 = {
          ContentES = "Dicen que el mejor espadachín ni siquiera necesita una espada, cualquier cosa, incluso un tallo de hierba o una ramita, puede convertirse en espada. He oído que luchas con utensilios de limpieza. Supongo que también eres un maestro de la espada, ¿no? ¿Me podrías enseñar algunas técnicas?",
          TextMapId = "voice_ch_char_Kezhou_vo_companio_01"
        },
        voice_ch_char_Kezhou_vo_companio_02 = {
          ContentES = "Por ahora, me quedaré con tu vieja espada. Cuando dejes de andar deprimido y con esa cara larga, te la devolveré. Pero solo si me ganas en un duelo. Si pierdes, será mía para siempre.",
          TextMapId = "voice_ch_char_Kezhou_vo_companio_02"
        },
        voice_ch_char_Kezhou_vo_companio_03 = {
          ContentES = "Una espada puede ser una compañera, un juguete o una herramienta para todo tipo de cosas: cortar, abrir o afeitar. Pero nunca debe ser tu amo. No dejes que esa espada te frene en tu camino.",
          TextMapId = "voice_ch_char_Kezhou_vo_companio_03"
        },
        voice_ch_char_Kezhou_vo_die_r01 = {
          ContentES = "Un hombre sabio sabe cuándo debe retirarse, nos vemos.",
          TextMapId = "voice_ch_char_Kezhou_vo_die_r01"
        },
        voice_ch_char_Kezhou_vo_die_r02 = {
          ContentES = "La habilidad se perfecciona con el esfuerzo… la pereza desafila la hoja...",
          TextMapId = "voice_ch_char_Kezhou_vo_die_r02"
        },
        voice_ch_char_Kezhou_vo_fail = {
          ContentES = "La victoria y la derrota son comunes en la batalla. No pasa nada. Podemos intentarlo de nuevo.",
          TextMapId = "voice_ch_char_Kezhou_vo_fail"
        },
        voice_ch_char_Kezhou_vo_gain = {
          ContentES = "El cielo sirve como el techo, la tierra, como la cama. Tengo la espada en mano, deambulando bajo el firmamento, para buscar la justicia donde ha sido oculta. ¡Ay, olvídalo! Esta presentación tan formal nunca me convence. Vamos a lo sencillo: soy Kezhou, un errante de Huaxu. Si necesitas ayuda, solo dímelo.",
          TextMapId = "voice_ch_char_Kezhou_vo_gain"
        },
        voice_ch_char_Kezhou_vo_idle = {
          ContentES = "Es un lugar luminoso y espacioso. Sería perfecto para practicar esgrima si no hubiera tantas mesas y sillas en el camino.",
          TextMapId = "voice_ch_char_Kezhou_vo_idle"
        },
        voice_ch_char_Kezhou_vo_lvup = {
          ContentES = "Hay que ver mil espadas para comprender una sola.",
          TextMapId = "voice_ch_char_Kezhou_vo_lvup"
        },
        voice_ch_char_Kezhou_vo_revive = {
          ContentES = "¡Esta batalla está lejos de terminar!",
          TextMapId = "voice_ch_char_Kezhou_vo_revive"
        },
        voice_ch_char_Kezhou_vo_skill01_r01 = {
          ContentES = "¡Rápido como una sombra!",
          TextMapId = "voice_ch_char_Kezhou_vo_skill01_r01"
        },
        voice_ch_char_Kezhou_vo_skill01_r02 = {
          ContentES = "¡Quédate aquí y no te metas en líos!",
          TextMapId = "voice_ch_char_Kezhou_vo_skill01_r02"
        },
        voice_ch_char_Kezhou_vo_skill02_r01 = {
          ContentES = "Diez pasos más, nada sobrevivirá.",
          TextMapId = "voice_ch_char_Kezhou_vo_skill02_r01"
        },
        voice_ch_char_Kezhou_vo_skill02_r02 = {
          ContentES = "La danza de la espada, tu llamada final.",
          TextMapId = "voice_ch_char_Kezhou_vo_skill02_r02"
        },
        voice_ch_char_Kezhou_vo_skill02_r03 = {
          ContentES = "¡Es hora de probar esta espada!",
          TextMapId = "voice_ch_char_Kezhou_vo_skill02_r03"
        },
        voice_ch_char_Kezhou_vo_topic_01_1 = {
          ContentES = "¿A ti también te interesa la esgrima? Lo imagino, veo que tienes una espada muy buena. Debes ser muy hábil con ella. ¡Vamos a tener un combate de práctica amistoso y veamos qué tal lo haces!",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_01_1"
        },
        voice_ch_char_Kezhou_vo_topic_01_2 = {
          ContentES = "Sinceramente, ha pasado mucho tiempo desde que conocí a alguien realmente a mi nivel. Mi maestro siempre decía que yo necesitaba más entrenamiento porque era demasiado directo y que debería mejorar mi actuación.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_01_2"
        },
        voice_ch_char_Kezhou_vo_topic_01_3 = {
          ContentES = "No creo que sí, pero mi maestro siempre decía que la esgrima no se trata solo de la habilidad, sino de la actuación, como \"Ocultar tu fuerza fingiendo debilidad\", \"Dominar al enemigo sin luchar\" y \"Derrotar a pocos con muchos\". Esas también son las técnicas de esgrima superiores.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_01_3"
        },
        voice_ch_char_Kezhou_vo_topic_01_4 = {
          ContentES = "Cuando era niño, él me hacía la misma broma. Decía que sus habilidades eran mediocres y me decía que, si lograba derribarlo, no tendría que entrenar más. Tardé un año en darme cuenta de que ni siquiera podía tocarle la manga.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_01_4"
        },
        voice_ch_char_Kezhou_vo_topic_01_5 = {
          ContentES = "Hasta un día, estuve tan agotado que me desplomé en el suelo. Entonces me di cuenta: no había ni una gota de sudor a sus pies. ¿Su aspecto torpe y vacilante? Todo era un acto.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_01_5"
        },
        voice_ch_char_Kezhou_vo_topic_02_1 = {
          ContentES = "Muchas razones, en realidad, pero para resumirlo: odio estar atado por ellas.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_02_1"
        },
        voice_ch_char_Kezhou_vo_topic_02_2 = {
          ContentES = "He sido un espíritu libre toda mi vida, haciendo las cosas a mi manera, desenvainando mi espada ante cualquier injusticia. Solo escuchaba lo que quería oír de mi maestro o Yuming. El resto... entraba por un oído y me salía por el otro, como el viento. Así que dime, ¿por qué iba a dejarme encadenar por unas leyes?",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_02_2"
        },
        voice_ch_char_Kezhou_vo_topic_02_3 = {
          ContentES = "Diría que es la preocupación de un espadachín. Por ejemplo: cuando uno aprende esgrima, sigue al pie de la letra el manual de técnicas, ¿Verdad? Contra oponentes comunes, eso basta. La espada se mueve de forma instantánea.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_02_3"
        },
        voice_ch_char_Kezhou_vo_topic_02_4 = {
          ContentES = "Pero si te apegas demasiado al manual, no sabes reaccionar, tu espada no es mejor que un pedazo de chatarra: roma, torpe e inútil. Ante algo inesperado, te verás como un pollo sin cabeza, dando vueltas sin rumbo.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_02_4"
        },
        voice_ch_char_Kezhou_vo_topic_02_5 = {
          ContentES = "En mi opinión, el Huaxu actual es como un espadachín torpe, aferrado a sus «Nueve Capítulos de Dafeng». Ni siquiera pueden derrotar un errante como yo, ¿qué oportunidad tendrán contra una verdadera amenaza? Solo es cuestión de tiempo para que caigan.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_02_5"
        },
        voice_ch_char_Kezhou_vo_topic_03_1 = {
          ContentES = "¡Por supuesto! Ser bueno en la espada no significa que solo puedas usarla. En Huaxu, hay gente que usa plumas y palillos como armas; ¿acaso eso significa que los espadachines deben morir de hambre o no pueden escribir nunca?",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_03_1"
        },
        voice_ch_char_Kezhou_vo_topic_03_2 = {
          ContentES = "Oh, puedo hacerlo. Pero ¿para qué? Esquivarlo es mucho más fácil, después de todo. Incluso los jabalíes en el bosque saben que es mejor comer rábanos que corteza de árbol.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_03_2"
        },
        voice_ch_char_Kezhou_vo_topic_03_3 = {
          ContentES = "Por supuesto, si alguna vez me encuentro con un oponente digno, puedes apostar a que sacaré mi espada y daré el cien por cien.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_03_3"
        },
        voice_ch_char_Kezhou_vo_topic_04_1 = {
          ContentES = "Sí, efectivamente. Ahora que lo mencionas, recuerdo varios. Hay cosas como \"Rey Fulano\", \"Señor de Tal\" o \"Inmortal de Cual\". Los animales son lo más común, como: dragones, tigres, leones, grullas... ¡de todo! Es como un parque zoológico.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_04_1"
        },
        voice_ch_char_Kezhou_vo_topic_04_2 = {
          ContentES = "Así funciona: cuanto más largo sea el apodo, peores serán las habilidades. Con un apodo más largo, seguramente es un principiante. Con uno ni largo ni corto, no está mal. Con uno corto, es alguien con quien no conviene meterte. Y los que no tienen apodo, son los verdaderos maestros.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_04_2"
        },
        voice_ch_char_Kezhou_vo_topic_04_3 = {
          ContentES = "Por supuesto es mi nombre real. Sé que suena raro, como un apodo, ¿verdad? Incluso mi maestro solía decirme eso, me advertía que con un nombre así la gente me tomaría por un experto y eso solo me traería molestias.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_04_3"
        },
        voice_ch_char_Kezhou_vo_topic_04_4 = {
          ContentES = "Pero es el nombre que me puso mi padre. Quizás esperaba que creciera para convertirme en un héroe. No me dejó mucho, pero llevar este nombre me hace sentir como si su espada aún dejara huella en el mundo.",
          TextMapId = "voice_ch_char_Kezhou_vo_topic_04_4"
        },
        voice_ch_char_Kezhou_vo_victory = {
          ContentES = "Una espada en la mano para extinguir todas las injusticias. ¿Quién será el siguiente?",
          TextMapId = "voice_ch_char_Kezhou_vo_victory"
        },
        voice_ch_char_Kezhou_vo_welcome = {
          ContentES = "¡Hoy es un día perfecto para beber y cantar! Ven, déjame terminar mi vaso y luego iremos a matar los pecadores que merecen mi espada. ¿Qué? ¿Ya dije lo mismo ayer? Bueno, cada día es bueno para vivir así, ¿no estás de acuerdo?",
          TextMapId = "voice_ch_char_Kezhou_vo_welcome"
        },
        voice_ch_char_Landi_vo_appear = {
          ContentES = "¿De verdad tengo que ir allí esta vez?",
          TextMapId = "voice_ch_char_Landi_vo_appear"
        },
        voice_ch_char_Landi_vo_battleidle = {
          ContentES = "Ojalá pudieran entender, como yo, el valor de tomarse un descanso.",
          TextMapId = "voice_ch_char_Landi_vo_battleidle"
        },
        voice_ch_char_Landi_vo_battlestart = {
          ContentES = "Vamos a atacar el punto más débil de su defensa.",
          TextMapId = "voice_ch_char_Landi_vo_battlestart"
        },
        voice_ch_char_Landi_vo_be_hit_heavy_r01 = {
          ContentES = "Eso fue brutal.",
          TextMapId = "voice_ch_char_Landi_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Landi_vo_be_hit_heavy_r02 = {
          ContentES = "Qué cansancio...",
          TextMapId = "voice_ch_char_Landi_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Landi_vo_birthday = {
          ContentES = "Hoy te he estado esperando aquí muchísimo tiempo, sacrificando mi preciado tiempo libre para ti. El único objetivo es para que tuvieras un cumpleaños inolvidable. Eh, anoche incluso modifiqué tus utensilios de cocina y preparé un pastel... parece un pastel. Puede que no parezca muy bueno, pero espero que te guste. Después de todo, fue un gran reto para un novato en la repostería como yo.",
          TextMapId = "voice_ch_char_Landi_vo_birthday"
        },
        voice_ch_char_Landi_vo_companio_01 = {
          ContentES = "Mi informe, Jefa Sibylle. Las tareas de hoy están organizadas. Si tiene alguna orden adicional, estoy lista para cumplirla. Sin embargo, hoy ha sido un día muy exigente, así que debería descansar bien para evitar el agotamiento.",
          TextMapId = "voice_ch_char_Landi_vo_companio_01"
        },
        voice_ch_char_Landi_vo_companio_02 = {
          ContentES = "¡Excelente trabajo en la última misión! Pero he recibido algunas quejas por los daños a la propiedad pública durante la ejecución. Eh, me da un poco de vergüenza disculparme en tu nombre, soy algo tímida. Así que... querida y amable Señorita Lynn, ¿podrías encargarte de estas tareas urgentes por mí? ¡Por favor!",
          TextMapId = "voice_ch_char_Landi_vo_companio_02"
        },
        voice_ch_char_Landi_vo_companio_03 = {
          ContentES = "¿Qué...? ¿Cómo es esto posible? ¡Quizás estoy tan cansada que veo cosas! Mejor pido la baja por lesión laboral y me tomo unos días más de descanso.",
          TextMapId = "voice_ch_char_Landi_vo_companio_03"
        },
        voice_ch_char_Landi_vo_die_r01 = {
          ContentES = "No debí haber aceptado esta tarea...",
          TextMapId = "voice_ch_char_Landi_vo_die_r01"
        },
        voice_ch_char_Landi_vo_die_r02 = {
          ContentES = "Caer en un sueño profundo... no es tan agradable como pensaba...",
          TextMapId = "voice_ch_char_Landi_vo_die_r02"
        },
        voice_ch_char_Landi_vo_fail = {
          ContentES = "¡Saber cuándo retirarse también es la táctica importante! Así que, me voy.",
          TextMapId = "voice_ch_char_Landi_vo_fail"
        },
        voice_ch_char_Landi_vo_gain = {
          ContentES = "Eh, me pillaste. Parece que se acabaron mis días tranquilos... De todas maneras, pareces una persona decente, así que supongo que podría echarte una mano, a título personal, claro está.",
          TextMapId = "voice_ch_char_Landi_vo_gain"
        },
        voice_ch_char_Landi_vo_idle = {
          ContentES = "Hmm... Esta escopeta plegable furtiva automático podría mejorarse para disparar en ráfaga... Si le aumento la potencia de fuego... Hmm, perfecto, podré eliminar a los enemigos aún más rápido en la próxima misión y volver a casa temprano.",
          TextMapId = "voice_ch_char_Landi_vo_idle"
        },
        voice_ch_char_Landi_vo_lvup = {
          ContentES = "Puede ser fastidioso, pero prepararse antes del combate nunca es una pérdida de tiempo.",
          TextMapId = "voice_ch_char_Landi_vo_lvup"
        },
        voice_ch_char_Landi_vo_revive = {
          ContentES = "Es hora de espabilar. Toca trabajar...",
          TextMapId = "voice_ch_char_Landi_vo_revive"
        },
        voice_ch_char_Landi_vo_skill01_r01 = {
          ContentES = "¡Ríndete ya!",
          TextMapId = "voice_ch_char_Landi_vo_skill01_r01"
        },
        voice_ch_char_Landi_vo_skill01_r02 = {
          ContentES = "Relájate.",
          TextMapId = "voice_ch_char_Landi_vo_skill01_r02"
        },
        voice_ch_char_Landi_vo_skill02_r01 = {
          ContentES = "Debilidad identificada.",
          TextMapId = "voice_ch_char_Landi_vo_skill02_r01"
        },
        voice_ch_char_Landi_vo_skill02_r02 = {
          ContentES = "Aquí está la jugada ganadora.",
          TextMapId = "voice_ch_char_Landi_vo_skill02_r02"
        },
        voice_ch_char_Landi_vo_skill02_r03 = {
          ContentES = "Nunca te interpongas entre yo y mi descanso.",
          TextMapId = "voice_ch_char_Landi_vo_skill02_r03"
        },
        voice_ch_char_Landi_vo_topic_01_1 = {
          ContentES = "¿Mi familia? Mis padres llevan años sin preocuparse por mí. Solo mis dos hermanas intentan mandarme de vez en cuando. Pero ahora que estoy en la Legión, fuera de su alcance.",
          TextMapId = "voice_ch_char_Landi_vo_topic_01_1"
        },
        voice_ch_char_Landi_vo_topic_01_2 = {
          ContentES = "¡No, no, nada de eso! ¡E-Ellas son absolutamente encantadoras, inteligentes, amables, dulces, con mucho encanto, hermosas y casi perfectas! Sin embargo, un poco más de decoro sería bueno...",
          TextMapId = "voice_ch_char_Landi_vo_topic_01_2"
        },
        voice_ch_char_Landi_vo_topic_02_1 = {
          ContentES = "¡Anda, tú eres de los que no saben apreciar un buen descanso! Escucha bien: las camas son refugios, donde el alma encuentra la paz; los tejados son santuarios, donde desaparecen las preocupaciones. En los jardines por la tarde, la luz del sol brilla, la siesta es una melodía de los dulces sueños...",
          TextMapId = "voice_ch_char_Landi_vo_topic_02_1"
        },
        voice_ch_char_Landi_vo_topic_02_2 = {
          ContentES = "... ¡Oye! ¡Todavía no he terminado!",
          TextMapId = "voice_ch_char_Landi_vo_topic_02_2"
        },
        voice_ch_char_Landi_vo_topic_03_1 = {
          ContentES = "¡Ella es una auténtica máquina de trabajo! Necesitaría partirme en tres solo para seguirle el ritmo... Bueno, quiero decir, la Jefa Sibylle, como una capitana, siempre es muy estricta con nosotros.",
          TextMapId = "voice_ch_char_Landi_vo_topic_03_1"
        },
        voice_ch_char_Landi_vo_topic_03_2 = {
          ContentES = "Ay, qué debo hacer... Pues, ¿qué te parece si te invito a un té por la tarde y olvidamos esta conversación? No te preocupes, no estará envenenado.",
          TextMapId = "voice_ch_char_Landi_vo_topic_03_2"
        },
        voice_ch_char_Landi_vo_topic_04_1 = {
          ContentES = "Te he diseñado algo increíble: ¡un robot compañero! Te seguirá en el combate, agitando una pequeña pancarta y animándote: \"¡Ánimo!\" \"¡Lo estás petando!\".",
          TextMapId = "voice_ch_char_Landi_vo_topic_04_1"
        },
        voice_ch_char_Landi_vo_topic_04_2 = {
          ContentES = "Es genial, ¿verdad? ¿Si está lleno de energía? Espera a que lo termine...",
          TextMapId = "voice_ch_char_Landi_vo_topic_04_2"
        },
        voice_ch_char_Landi_vo_topic_04_3 = {
          ContentES = "¡Oye, no he terminado! Hice estos planos durante mis valiosos descansos... ¿Sabes lo difícil que fue esconderlos de la Jefa Sibylle?",
          TextMapId = "voice_ch_char_Landi_vo_topic_04_3"
        },
        voice_ch_char_Landi_vo_victory = {
          ContentES = "Estoy segura de que un comandante inteligente y eficiente como tú puede atar los cabos sueltos por su cuenta, ¿verdad? ¡Nos vemos!",
          TextMapId = "voice_ch_char_Landi_vo_victory"
        },
        voice_ch_char_Landi_vo_welcome = {
          ContentES = "Ah... Me siento tan fresco al despertarme. Oye, amigo, no tiene sentido trabajar todo el día. Tu lista de tareas nunca terminará. Recuerda, el descanso es una necesidad, no es un lujo.",
          TextMapId = "voice_ch_char_Landi_vo_welcome"
        },
        voice_ch_char_Linen_vo_appear = {
          ContentES = "Dime. ¿Quién es el objetivo hoy?",
          TextMapId = "voice_ch_char_Linen_vo_appear"
        },
        voice_ch_char_Linen_vo_battleidle = {
          ContentES = "¡Muévete, o no vivirás lo suficiente para pagarme!",
          TextMapId = "voice_ch_char_Linen_vo_battleidle"
        },
        voice_ch_char_Linen_vo_battlestart = {
          ContentES = "¡Vamos!",
          TextMapId = "voice_ch_char_Linen_vo_battlestart"
        },
        voice_ch_char_Linen_vo_be_hit_heavy_r01 = {
          ContentES = "¡Qué dolor ***!",
          TextMapId = "voice_ch_char_Linen_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Linen_vo_be_hit_heavy_r02 = {
          ContentES = "No está tan mal.",
          TextMapId = "voice_ch_char_Linen_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Linen_vo_be_hit_r01 = {
          ContentES = "Bah.",
          TextMapId = "voice_ch_char_Linen_vo_be_hit_r01"
        },
        voice_ch_char_Linen_vo_be_hit_r02 = {
          ContentES = "¡Eh!",
          TextMapId = "voice_ch_char_Linen_vo_be_hit_r02"
        },
        voice_ch_char_Linen_vo_birthday = {
          ContentES = "Feliz cumpleaños. No se me dan bien las palabras bonitas, así que solo te deseo que nunca te falte dinero. Y en cuanto a la misión de hoy, te daré un generoso 20% de descuento. Suena genial, ¿no?",
          TextMapId = "voice_ch_char_Linen_vo_birthday"
        },
        voice_ch_char_Linen_vo_companio_01 = {
          ContentES = "La próxima vez, ve directo al grano, ¿quieres? Tanto balbuceo innecesario me está sacando de quicio.",
          TextMapId = "voice_ch_char_Linen_vo_companio_01"
        },
        voice_ch_char_Linen_vo_companio_02 = {
          ContentES = "... Buen día, comandante.",
          TextMapId = "voice_ch_char_Linen_vo_companio_02"
        },
        voice_ch_char_Linen_vo_companio_03 = {
          ContentES = "Eres un soldado de primera. Eso es todo lo que tengo que decir. Y... asegúrate de cuidarte en tu tiempo libre. ¡Apúrate! Ya oíste bastante, ¡así que lárgate!",
          TextMapId = "voice_ch_char_Linen_vo_companio_03"
        },
        voice_ch_char_Linen_vo_die_r01 = {
          ContentES = "¿Quién... más...?",
          TextMapId = "voice_ch_char_Linen_vo_die_r01"
        },
        voice_ch_char_Linen_vo_die_r02 = {
          ContentES = "Ya no puedo... soportar más...",
          TextMapId = "voice_ch_char_Linen_vo_die_r02"
        },
        voice_ch_char_Linen_vo_fail = {
          ContentES = "Guarda esto en secreto. De lo contrario, te voy a reventar los sesos.",
          TextMapId = "voice_ch_char_Linen_vo_fail"
        },
        voice_ch_char_Linen_vo_gain = {
          ContentES = "No pensé que terminaría trabajando como mercenario para ti. ¿Qué necesitas? Empecemos por mi paga.",
          TextMapId = "voice_ch_char_Linen_vo_gain"
        },
        voice_ch_char_Linen_vo_idle = {
          ContentES = "... No está mal. Debería tener suficiente para este mes. Pensé que ese ** Randy se quedaría con todo... Enviaré esta parte a casa y me las apañaré con el resto.",
          TextMapId = "voice_ch_char_Linen_vo_idle"
        },
        voice_ch_char_Linen_vo_lvup = {
          ContentES = "¡Qué aburrimiento!",
          TextMapId = "voice_ch_char_Linen_vo_lvup"
        },
        voice_ch_char_Linen_vo_revive = {
          ContentES = "¡Allá vamos de nuevo!",
          TextMapId = "voice_ch_char_Linen_vo_revive"
        },
        voice_ch_char_Linen_vo_skill01_r01 = {
          ContentES = "¡Destruye!",
          TextMapId = "voice_ch_char_Linen_vo_skill01_r01"
        },
        voice_ch_char_Linen_vo_skill01_r02 = {
          ContentES = "Voy a patearles el culo.",
          TextMapId = "voice_ch_char_Linen_vo_skill01_r02"
        },
        voice_ch_char_Linen_vo_skill02_r01 = {
          ContentES = "¡Tú lo pediste!",
          TextMapId = "voice_ch_char_Linen_vo_skill02_r01"
        },
        voice_ch_char_Linen_vo_skill02_r02 = {
          ContentES = "¡Paga por haberme hecho perder el tiempo!",
          TextMapId = "voice_ch_char_Linen_vo_skill02_r02"
        },
        voice_ch_char_Linen_vo_skill02_r03 = {
          ContentES = "Ahora estoy furioso.",
          TextMapId = "voice_ch_char_Linen_vo_skill02_r03"
        },
        voice_ch_char_Linen_vo_topic_01_1 = {
          ContentES = "¿Sibylle? Es la Jefa de la 13.ª Legión.",
          TextMapId = "voice_ch_char_Linen_vo_topic_01_1"
        },
        voice_ch_char_Linen_vo_topic_01_2 = {
          ContentES = "Bah, ¿cómo puedo saber más? Ella manda, yo cumplo. Eso es todo.",
          TextMapId = "voice_ch_char_Linen_vo_topic_01_2"
        },
        voice_ch_char_Linen_vo_topic_02_1 = {
          ContentES = "¿Consejos? Mi único consejo es que no hay problema que un buen puñetazo no pueda arreglar. Si eso no funciona, tira otro.",
          TextMapId = "voice_ch_char_Linen_vo_topic_02_1"
        },
        voice_ch_char_Linen_vo_topic_02_2 = {
          ContentES = "Entonces, una bala suele ser la solución.",
          TextMapId = "voice_ch_char_Linen_vo_topic_02_2"
        },
        voice_ch_char_Linen_vo_topic_02_3 = {
          ContentES = "Oh, es solo una expresión. Lo que quiero decir es: sé lo más duro y fuerte que puedas, y eso es todo lo que necesitas. Sigue con tus tonterías y tu cara será la próxima en recibir esos puñetazos.",
          TextMapId = "voice_ch_char_Linen_vo_topic_02_3"
        },
        voice_ch_char_Linen_vo_topic_03_1 = {
          ContentES = "Vi una pistola buenísima el otro día... Olvídalo, no voy a dejar de comer para comprarla. Además, la vieja me queda mejor en la mano.",
          TextMapId = "voice_ch_char_Linen_vo_topic_03_1"
        },
        voice_ch_char_Linen_vo_topic_03_2 = {
          ContentES = "¿De verdad?... Pero, estás tan tieso como yo... Pues, te agradezco, pero no vayas a romper tu alcancía por mí. No quiero deberle nada a nadie.",
          TextMapId = "voice_ch_char_Linen_vo_topic_03_2"
        },
        voice_ch_char_Linen_vo_topic_04_1 = {
          ContentES = "No hay trabajo, no hay comida. ¿Qué parte no entiendes?",
          TextMapId = "voice_ch_char_Linen_vo_topic_04_1"
        },
        voice_ch_char_Linen_vo_topic_04_2 = {
          ContentES = "Estoy de acuerdo, pero mis clientes no piensan así. Siempre me están acosando con: ¿Ya está listo el trabajo? ¡Date prisa! ¡Uf! i no tuviera que alimentar a mi familia, les partiría la cara de imbéciles.",
          TextMapId = "voice_ch_char_Linen_vo_topic_04_2"
        },
        voice_ch_char_Linen_vo_victory = {
          ContentES = "¿Eso es todo? ¡Qué patético!",
          TextMapId = "voice_ch_char_Linen_vo_victory"
        },
        voice_ch_char_Linen_vo_welcome = {
          ContentES = "¿Necesitas algo? Suéltalo rápido. Tengo una misión que terminar.",
          TextMapId = "voice_ch_char_Linen_vo_welcome"
        },
        voice_ch_char_Lise_vo_appear = {
          ContentES = "Armas, suministros, niveles de energía, planes de misión: comprobados por decimoséptima vez, a la espera.",
          TextMapId = "voice_ch_char_Lise_vo_appear"
        },
        voice_ch_char_Lise_vo_battleidle = {
          ContentES = "No quería detenerme. Debo seguir luchando.",
          TextMapId = "voice_ch_char_Lise_vo_battleidle"
        }
      }
    end
  },
  {
    MinKey = "voice_ch_char_Lise_vo_battlestart",
    MaxKey = "voice_ch_char_Saiqi_vo_topic_04_2",
    Loader = function()
      return {
        voice_ch_char_Lise_vo_battlestart = {
          ContentES = "Rhythm Fischer, aquí presente. ¡A su disposición!",
          TextMapId = "voice_ch_char_Lise_vo_battlestart"
        },
        voice_ch_char_Lise_vo_be_hit_heavy_r01 = {
          ContentES = "Estoy bien, he pasado por situación peor.",
          TextMapId = "voice_ch_char_Lise_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Lise_vo_birthday = {
          ContentES = "¿Cumpleaños? Ha pasado muchísimo tiempo desde la última vez que asistí a una fiesta de cumpleaños... Cuando era pequeña, mi familia siempre organizaba celebraciones muy especiales para los cumpleaños. Pero con el paso del tiempo, mi hermano y yo casi no nos veíamos, y los cumpleaños perdieron su significado. \nSolía soñar que, algún día, cuando ambos hubiéramos logrado algo, organizaríamos una gran celebración, como aquellas fiestas extravagantes en el centro de la ciudad, con las lámparas de cristal, una enorme tarta, los vestidos de seda... ¡Qué perfecto sería! Pero ahora, ese sueño nunca se hará realidad...\n¡Ay... lo siento mucho! No quise arruinar el ambiente con mis palabras en una ocasión tan especial... ¡Por favor no dejen que mis palabras empañen este día! Aunque yo no celebre mi cumpleaños, pero hoy es tu cumpleaños, te envío mis mejores deseos: que cada día esté lleno de alegría, hermosos recuerdos y el cariño de tus queridos.",
          TextMapId = "voice_ch_char_Lise_vo_birthday"
        },
        voice_ch_char_Lise_vo_companio_01 = {
          ContentES = "No puedo controlarme cuando algo está desordenado, siempre siento la necesidad de arreglarlo. Pero su casa, Señorita Hilda, es una excepción. Todo está perfectamente ordenado, eso me parece muy admirable.",
          TextMapId = "voice_ch_char_Lise_vo_companio_01"
        },
        voice_ch_char_Lise_vo_companio_02 = {
          ContentES = "Esta propuesta es increíblemente detallada, con cada segundo planificado. Seguirla al pie de la letra debe ser muy satisfactorio. Pero... Es difícil creer que el comandante Randy haya preparado algo así.",
          TextMapId = "voice_ch_char_Lise_vo_companio_02"
        },
        voice_ch_char_Lise_vo_companio_03 = {
          ContentES = "¿Podrías tocar una melodía diferente? No es que tu música no sea hermosa, pero... Me trae recuerdos pasados que prefiero no recordar.",
          TextMapId = "voice_ch_char_Lise_vo_companio_03"
        },
        voice_ch_char_Lise_vo_die_r01 = {
          ContentES = "Lo siento... Nunca quería romper mi promesa...",
          TextMapId = "voice_ch_char_Lise_vo_die_r01"
        },
        voice_ch_char_Lise_vo_die_r02 = {
          ContentES = "Esto... no es tan malo...",
          TextMapId = "voice_ch_char_Lise_vo_die_r02"
        },
        voice_ch_char_Lise_vo_fail = {
          ContentES = "Otra vez... no pude proteger a mis compañeros...",
          TextMapId = "voice_ch_char_Lise_vo_fail"
        },
        voice_ch_char_Lise_vo_gain_01 = {
          ContentES = "Rhythm Fischer, suboficial de la Tropa de Escolta del Lago Helado, subordinada a La 6.ª Legión del Imperio Hyperborea. ¿Qué ocurre? Si hay algo que no se puede resolver realmente, posiblemente puedo ayudarte, debe considerarlo como un favor personal, nada más.",
          TextMapId = "voice_ch_char_Lise_vo_gain_01"
        },
        voice_ch_char_Lise_vo_gain_02 = {
          ContentES = "¡Sí, señor! Rhythm Fischer, informando... Oh, eres tú... Perdóneme. Siempre me olvido... Ya no pertenezco a la Tropa de Escolta... Discúlpame.",
          TextMapId = "voice_ch_char_Lise_vo_gain_02"
        },
        voice_ch_char_Lise_vo_idle = {
          ContentES = "¿Hay algo en lo que pueda ayudar? No es que sea una adicta al trabajo, simplemente... es un hábito, creo que. Cuando no estoy ocupada, me siento inquieta.",
          TextMapId = "voice_ch_char_Lise_vo_idle"
        },
        voice_ch_char_Lise_vo_lvup = {
          ContentES = "Corriente caótica... ¿a quiénes están destinadas a servir?",
          TextMapId = "voice_ch_char_Lise_vo_lvup"
        },
        voice_ch_char_Lise_vo_revive = {
          ContentES = "Sí... Prometí seguir viviendo.",
          TextMapId = "voice_ch_char_Lise_vo_revive"
        },
        voice_ch_char_Lise_vo_skill01_r01 = {
          ContentES = "¡Descarga eléctrica!",
          TextMapId = "voice_ch_char_Lise_vo_skill01_r01"
        },
        voice_ch_char_Lise_vo_skill01_r02 = {
          ContentES = "¡Romper!",
          TextMapId = "voice_ch_char_Lise_vo_skill01_r02"
        },
        voice_ch_char_Lise_vo_skill02_r01 = {
          ContentES = "La misión está terminando.",
          TextMapId = "voice_ch_char_Lise_vo_skill02_r01"
        },
        voice_ch_char_Lise_vo_skill02_r02 = {
          ContentES = "La corriente os silenciará.",
          TextMapId = "voice_ch_char_Lise_vo_skill02_r02"
        },
        voice_ch_char_Lise_vo_skill02_r03 = {
          ContentES = "Es que... ¡Yo elegí seguir viviendo!",
          TextMapId = "voice_ch_char_Lise_vo_skill02_r03"
        },
        voice_ch_char_Lise_vo_topic_01_1 = {
          ContentES = "Oh... ¿Lo has notado? Sí, tengo una, me la regaló alguien muy querido. La guardo bien, pero... No puedo evitar comprobar que esté allí de vez en cuando, por si acaso desaparece.",
          TextMapId = "voice_ch_char_Lise_vo_topic_01_1"
        },
        voice_ch_char_Lise_vo_topic_01_2 = {
          ContentES = "En realidad, solo sé una. La persona que me la regaló me la enseñó. No aprendí rápido... Quizás es que nunca he sido buena en expresar emociones...",
          TextMapId = "voice_ch_char_Lise_vo_topic_01_2"
        },
        voice_ch_char_Lise_vo_topic_01_3 = {
          ContentES = "Pero cada vez que estoy demasiado tenso o me dejo llevar por los impulsos, siempre recurro a ella. Es como un ancla: me recuerda lo que realmente importa, aquello en lo que puedo confiar. De esta manera, me ayuda a recuperar la calma.",
          TextMapId = "voice_ch_char_Lise_vo_topic_01_3"
        },
        voice_ch_char_Lise_vo_topic_01_4 = {
          ContentES = "Muchos de mis compañeros recurren a los médicos para aliviar el estrés, mediante tranquilizantes, estimulantes, ese tipo de cosas. Yo nunca he necesitado esos. Ya sea que mi corazón lata rápido o lento, la armónica siempre me tranquiliza.",
          TextMapId = "voice_ch_char_Lise_vo_topic_01_4"
        },
        voice_ch_char_Lise_vo_topic_02_1 = {
          ContentES = "No está mal. La Legión es uno de los pocos lugares donde el trabajo duro se ve realmente recompensado. He ganado mi posición aquí, y ahora incluso tengo algunos subordinados. Me aseguro de que traten a los Charons y a los Solas con el mismo respeto.",
          TextMapId = "voice_ch_char_Lise_vo_topic_02_1"
        },
        voice_ch_char_Lise_vo_topic_02_2 = {
          ContentES = "He oído muchas quejas, e incluso acusaciones muy duras, sobre cómo la Legión trata al Charon. Hago todo lo posible por aliviar eso... Quizás algún día la gente vea a la Legión con mejores ojos. Espero que con el tiempo, la gente vea a la Legión de una mejora manera.",
          TextMapId = "voice_ch_char_Lise_vo_topic_02_2"
        },
        voice_ch_char_Lise_vo_topic_02_3 = {
          ContentES = "Poco a poco habrá más. Hubo un tiempo en que no había ni un solo Charon en la Legión. Sé que aún no puedo lograr un gran cambio, pero si sigo insistiendo en guiar a mis subordinados por el buen camino, creo que los conflictos entre los Charons y los Solas disminuirán poco a poco.",
          TextMapId = "voice_ch_char_Lise_vo_topic_02_3"
        },
        voice_ch_char_Lise_vo_topic_02_4 = {
          ContentES = "Sí, tratar a todos con justicia y protegerlos de los Filthoids y del Deterioro... Creo que estos esfuerzos pueden mejorar la vida de los Charons. Quizás, así se calmarán un poco los pesados suspiros que se oyen en el Lago Helado.",
          TextMapId = "voice_ch_char_Lise_vo_topic_02_4"
        },
        voice_ch_char_Lise_vo_topic_03_1 = {
          ContentES = "No diría que es responsabilidad. Simplemente sigo las normas de las Tropas de Escolta.",
          TextMapId = "voice_ch_char_Lise_vo_topic_03_1"
        },
        voice_ch_char_Lise_vo_topic_03_2 = {
          ContentES = "Las normas de la Tropa de Escolta prohíben a cualquier legionario comentar la conducta de sus compañeros.",
          TextMapId = "voice_ch_char_Lise_vo_topic_03_2"
        },
        voice_ch_char_Lise_vo_topic_03_3 = {
          ContentES = "De hecho, no los entiendo. Quizás para ellos es solo un trabajo en las Tropas de Escolta. Mientras sus superiores no se den cuenta, creen que está bien relajarse o hacer tonterías.",
          TextMapId = "voice_ch_char_Lise_vo_topic_03_3"
        },
        voice_ch_char_Lise_vo_topic_03_4 = {
          ContentES = "Creo que esa actitud es errónea. La gente necesita algo que la guíe y la modere. Sin eso, simplemente se dejan llevar por la vida, permitiendo que sus valores se vayan deteriorando poco a poco, hasta convertirse en algo tan insignificante como las ratas en las alcantarillas.",
          TextMapId = "voice_ch_char_Lise_vo_topic_03_4"
        },
        voice_ch_char_Lise_vo_topic_04_1 = {
          ContentES = "No... Gracias. No me gusta verme en el espejo. Ver mis cuernos siempre me genera una sensación de incomodidad...",
          TextMapId = "voice_ch_char_Lise_vo_topic_04_1"
        },
        voice_ch_char_Lise_vo_topic_04_2 = {
          ContentES = "No, no es eso. No me avergüenza mi herencia Charon. Es solo que... Creo que mis cuernos se verían mucho mejor si fueran más regulares, más simétricos. ¡No me malinterpretes! No digo nada de malo sobre tus cuernos...",
          TextMapId = "voice_ch_char_Lise_vo_topic_04_2"
        },
        voice_ch_char_Lise_vo_topic_05_1 = {
          ContentES = "Sí... Pero ahora me parece muy pesada, casi insoportable... No sé si tengo la fuerza para volver a cogerla y tocarla.",
          TextMapId = "voice_ch_char_Lise_vo_topic_05_1"
        },
        voice_ch_char_Lise_vo_topic_05_2 = {
          ContentES = "Después de todo, alguna vez esta armónica representaba todas mis esperanzas y sueños. Ahora, solo me recuerda todo lo que he perdido.",
          TextMapId = "voice_ch_char_Lise_vo_topic_05_2"
        },
        voice_ch_char_Lise_vo_topic_05_3 = {
          ContentES = "... Bueno, gracias. Te prometo que cuando vuelva a tocar, cuando esté lista para aprender una nueva melodía, serás la primera en oírla.",
          TextMapId = "voice_ch_char_Lise_vo_topic_05_3"
        },
        voice_ch_char_Lise_vo_topic_06_1 = {
          ContentES = "He estado haciendo trabajos ocasionales. Con eso me alcanza para cubrir mis gastos rutinarios. Pero, sinceramente, ganar dinero ya no es lo importante. Ahora, el trabajo me sirve para mantenerme ocupada.",
          TextMapId = "voice_ch_char_Lise_vo_topic_06_1"
        },
        voice_ch_char_Lise_vo_topic_06_2 = {
          ContentES = "Sí... El trabajo me da un propósito. Me hace feliz. Cuando estoy ocupada, incluso la luz del sol me parece más cálida.",
          TextMapId = "voice_ch_char_Lise_vo_topic_06_2"
        },
        voice_ch_char_Lise_vo_topic_07_1 = {
          ContentES = "Mejor que si me hubiera quedado. La Legión fue mi refugio, el lugar donde creía que mis sueños podían cumplirse realidad. Pero esos sueños se convirtieron en ilusiones, ese supuesto refugio fue un infierno que arrastró a mis seres queridos a un abismo de desesperación sin fin...",
          TextMapId = "voice_ch_char_Lise_vo_topic_07_1"
        },
        voice_ch_char_Lise_vo_topic_07_2 = {
          ContentES = "Ahora, mi corazón arde en deseo de venganza, pero no puedo apuntar mi arma contra quienes alguna vez llamé compañeros. Me siento perdida... Dime, ¿qué debo hacer?",
          TextMapId = "voice_ch_char_Lise_vo_topic_07_2"
        },
        voice_ch_char_Lise_vo_topic_07_3 = {
          ContentES = "... Disculpa mi pérdida de control. Tienes razón. Debo resolverlo yo misma, en lugar de poner esa carga sobre ti. Aunque... puede que me tome algo de tiempo...",
          TextMapId = "voice_ch_char_Lise_vo_topic_07_3"
        },
        voice_ch_char_Lise_vo_victory = {
          ContentES = "¡Qué pena que haya terminado tan rápido! Llévame para la próxima misión, así tú ganarás y yo estaré entretenida.",
          TextMapId = "voice_ch_char_Lise_vo_victory"
        },
        voice_ch_char_Lise_vo_welcome = {
          ContentES = "Patrulla finalizada. No se detectaron criaturas peligrosas, daños estructurales ni marcas sospechosas. Las operaciones rutinarias pueden continuar sin interrupción. Informe concluido.",
          TextMapId = "voice_ch_char_Lise_vo_welcome"
        },
        voice_ch_char_Maer_vo_appear = {
          ContentES = "¿A dónde iremos hoy a rebuscar?",
          TextMapId = "voice_ch_char_Maer_vo_appear"
        },
        voice_ch_char_Maer_vo_battleidle = {
          ContentES = "¡No es suficiente! ¡Aún hay espacio!",
          TextMapId = "voice_ch_char_Maer_vo_battleidle"
        },
        voice_ch_char_Maer_vo_battlestart = {
          ContentES = "¡Vamos a ver qué encontramos esta vez!",
          TextMapId = "voice_ch_char_Maer_vo_battlestart"
        },
        voice_ch_char_Maer_vo_be_hit_heavy_r01 = {
          ContentES = "¡Eso me dolió mucho!",
          TextMapId = "voice_ch_char_Maer_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Maer_vo_be_hit_heavy_r02 = {
          ContentES = "¡Ayyyy!",
          TextMapId = "voice_ch_char_Maer_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Maer_vo_birthday = {
          ContentES = "¡Feliz cumpleaños! Mira, te hice esto: una muñeca de Colita Gruesa, igual que la mía~¡Sabía que tenías muchas ganas de acariciar a Colita Gruesa! Jeje, ¡la Detective Taciturna ha adivinado tus deseos!",
          TextMapId = "voice_ch_char_Maer_vo_birthday"
        },
        voice_ch_char_Maer_vo_companio_01 = {
          ContentES = "¡Mira la tela, la insignia y el cuero! ¡Señora Hilda, usted es mi diosa! Si tiene más de estos objetos de procedencia dudosa que necesitan \"una disposición adecuada\", ¡cuente conmigo por favor! ¡Puede confiar en mí para disponerlos bien!",
          TextMapId = "voice_ch_char_Maer_vo_companio_01"
        },
        voice_ch_char_Maer_vo_companio_02 = {
          ContentES = "¡Pequeña Fina! ¡Cuánto tiempo sin verte! ¿Quieres escuchar el siguiente capítulo de «Nieve, la Guardiana Felina, y Jengibre, el Detective Gatuno»? ¡Perfecto! ¡Déjame coger un taburete y me pongo cómodo para contarte una buena historia!",
          TextMapId = "voice_ch_char_Maer_vo_companio_02"
        },
        voice_ch_char_Maer_vo_companio_03 = {
          ContentES = "¡Le juro que soy una ciudadana ejemplar, Señora Acaidesa! ¡Jamás he robado ni saqueado! Solo recojo unas sobras de los cubos para calmar el hambre. Su deber no llega hasta la basura, ¿verdad?",
          TextMapId = "voice_ch_char_Maer_vo_companio_03"
        },
        voice_ch_char_Maer_vo_companio_04 = {
          ContentES = "Estás viviendo al día, ¿verdad? ¿Quieres acompañarme a recolectar las basuras? Quizás puedas vivir mejor.",
          TextMapId = "voice_ch_char_Maer_vo_companio_04"
        },
        voice_ch_char_Maer_vo_companio_05 = {
          ContentES = "¡Señorita Camilla, la señorita más amable y hermosa! ¿Podría ayudarme con un pequeño problema? ¡Te prometo que es la última vez! Bueno, ¡la última vez de este mes! Seguramente no me niegas, ¿verdad?",
          TextMapId = "voice_ch_char_Maer_vo_companio_05"
        },
        voice_ch_char_Maer_vo_die_r01 = {
          ContentES = "¿Acaso yo... también estoy siendo reciclada...?",
          TextMapId = "voice_ch_char_Maer_vo_die_r01"
        },
        voice_ch_char_Maer_vo_die_r02 = {
          ContentES = "¡Ojalá pudiera ver el Lago Helado... una última vez!",
          TextMapId = "voice_ch_char_Maer_vo_die_r02"
        },
        voice_ch_char_Maer_vo_fail = {
          ContentES = "¡Está bien, lo que importa es seguir viva!",
          TextMapId = "voice_ch_char_Maer_vo_fail"
        },
        voice_ch_char_Maer_vo_gain_1 = {
          ContentES = "¡Hola, {性别:forastero|forastera}! ¡Bienvenido al Lago Helado! ¿Te sientes un poco fuera de lugar? ¡Permíteme, a Margie, mostrarte otra vez las maravillas de este lugar! Primera parada... ¡un montón de basureros sorpresa!",
          TextMapId = "voice_ch_char_Maer_vo_gain_1"
        },
        voice_ch_char_Maer_vo_gain_2 = {
          ContentES = "¿Qué? ¿Ya has oído mi apodo de \"Princesa del Basurero\"?¡Ay, por favor, no te unas a ellos! Solo llámame Margie. Aquí no hay ninguna princesa, ¡solo una recuperadora del Lago Helado!",
          TextMapId = "voice_ch_char_Maer_vo_gain_2"
        },
        voice_ch_char_Maer_vo_idle = {
          ContentES = "Mmm~¡Qué día tan maravilloso! Perfecto para recoger flores, y después oleré de maravilla. ¿{nickname}, quieres acompañarme?",
          TextMapId = "voice_ch_char_Maer_vo_idle"
        },
        voice_ch_char_Maer_vo_lvup = {
          ContentES = "¡Guau! ¡Mis bolsillos de carga ahora son mucho más espaciosos!",
          TextMapId = "voice_ch_char_Maer_vo_lvup"
        },
        voice_ch_char_Maer_vo_revive = {
          ContentES = "¡Convierte las basuras en tesoros!",
          TextMapId = "voice_ch_char_Maer_vo_revive"
        },
        voice_ch_char_Maer_vo_skill01_r01 = {
          ContentES = "¡Reciclable!",
          TextMapId = "voice_ch_char_Maer_vo_skill01_r01"
        },
        voice_ch_char_Maer_vo_skill01_r02 = {
          ContentES = "¡No reciclable!",
          TextMapId = "voice_ch_char_Maer_vo_skill01_r02"
        },
        voice_ch_char_Maer_vo_skill02_r01 = {
          ContentES = "¡Es hora de incinerar las basuras!",
          TextMapId = "voice_ch_char_Maer_vo_skill02_r01"
        },
        voice_ch_char_Maer_vo_skill02_r02 = {
          ContentES = "¡Aquí es donde perteneces!",
          TextMapId = "voice_ch_char_Maer_vo_skill02_r02"
        },
        voice_ch_char_Maer_vo_skill02_r03 = {
          ContentES = "¡Quema! ¡Entierra! ¡Destruye!",
          TextMapId = "voice_ch_char_Maer_vo_skill02_r03"
        },
        voice_ch_char_Maer_vo_topic_01_1 = {
          ContentES = "Humm... Se trata de dar nueva vida a las cosas que la gente tira y de dar a quienes no tienen mucho una oportunidad de vivir mejor.",
          TextMapId = "voice_ch_char_Maer_vo_topic_01_1"
        },
        voice_ch_char_Maer_vo_topic_01_2 = {
          ContentES = "Por ejemplo, convertir las viejas cortinas de terciopelo de un aristócrata en abrigos de invierno para los ancianos; o llevar muñecas a los niños que solo tienen piedras como juguetes... ¡se alegran durante muchísimo tiempo!",
          TextMapId = "voice_ch_char_Maer_vo_topic_01_2"
        },
        voice_ch_char_Maer_vo_topic_01_3 = {
          ContentES = "Una vez, arrastré hasta casa una estantería rota que alguien había tirado. Aunque casi muero de cansancio, enseguida se convirtió en un parque de juegos para una camada de gatitos, ¡valió totalmente la pena!",
          TextMapId = "voice_ch_char_Maer_vo_topic_01_3"
        },
        voice_ch_char_Maer_vo_topic_01_4 = {
          ContentES = "¡Eso es el trabajo de la recuperadora! Generalmente son cosas sin importancia, pero nunca hay un momento aburrido. ¿Qué te parece, quieres unirte a nosotros?",
          TextMapId = "voice_ch_char_Maer_vo_topic_01_4"
        },
        voice_ch_char_Maer_vo_topic_02_1 = {
          ContentES = "¡Shhh! ¡Es un secreto de primera para las recuperadoras! No te lo habría contado si no me hubieras ayudado con ese ladrón!",
          TextMapId = "voice_ch_char_Maer_vo_topic_02_1"
        },
        voice_ch_char_Maer_vo_topic_02_2 = {
          ContentES = "Este mapa muestra la ubicación de todos los basureros del Lago Helado, y también he marcado los pocos donde suelen aparecer las mejores cosas. ¡He ampliado esos basureros y ajustado el horario de mis visitas a la perfección!",
          TextMapId = "voice_ch_char_Maer_vo_topic_02_2"
        },
        voice_ch_char_Maer_vo_topic_02_3 = {
          ContentES = "Pero este trabajo es muy aleatorio, en realidad, casi siempre depende de la suerte...",
          TextMapId = "voice_ch_char_Maer_vo_topic_02_3"
        },
        voice_ch_char_Maer_vo_topic_02_4 = {
          ContentES = "¡Así es, oye, yo sabía que lo entenderías!",
          TextMapId = "voice_ch_char_Maer_vo_topic_02_4"
        },
        voice_ch_char_Maer_vo_topic_03_1 = {
          ContentES = "¡Oh, no, no es así! De hecho, me encanta el Lago Helado. Es que a menudo recuerdo los días que pasaba paseando por los campos de nieve con mi padre. Pasé toda mi infancia de esta manera.",
          TextMapId = "voice_ch_char_Maer_vo_topic_03_1"
        },
        voice_ch_char_Maer_vo_topic_03_2 = {
          ContentES = "Mirando desde aquí, los campos de nieve parecen sacados de un cuento de hadas. Pero cuando estás allí dentro, te sientes diminuto. Incluso después de caminar durante horas por la nieve hasta las rodillas, esa sensación no desaparece, siempre es el mismo paisaje.",
          TextMapId = "voice_ch_char_Maer_vo_topic_03_2"
        },
        voice_ch_char_Maer_vo_topic_03_3 = {
          ContentES = "No me disgustan aquellos días. ¡Pero el Lago Helado bullicioso y animado es mi lugar favorito!",
          TextMapId = "voice_ch_char_Maer_vo_topic_03_3"
        },
        voice_ch_char_Maer_vo_topic_04_1 = {
          ContentES = "Ese es el gran gato que solía acompañarme por los campos de nieve cuando era pequeña! Le llamábamos \"Colita Gruesa\". Solo me dejaba acariciar si le dábamos carne seca, pero ¡ay!, ¡su pelaje era tan suave! ¡Es lo mejor de lo mejor!",
          TextMapId = "voice_ch_char_Maer_vo_topic_04_1"
        },
        voice_ch_char_Maer_vo_topic_04_2 = {
          ContentES = "Humm... Ciertamente no hace \"miau-miau-miau\", suena más como \"rrruaahhh- rrruaahhh-!\"",
          TextMapId = "voice_ch_char_Maer_vo_topic_04_2"
        },
        voice_ch_char_Maer_vo_topic_04_3 = {
          ContentES = "Colita Gruesa prefiere la vida salvaje a la vida en la ciudad. Por eso tuvimos que tomar caminos separados. Sin embargo, ella siempre permanecerá en mi memoria, al igual que aquel campo de nieve.",
          TextMapId = "voice_ch_char_Maer_vo_topic_04_3"
        },
        voice_ch_char_Maer_vo_topic_05_1 = {
          ContentES = "¡No! ¡Eso no soy yo! ¡Soy demasiado mayor para un título tan infantil! ¡Por favor, te ruego que no me vuelvas a llamar así!",
          TextMapId = "voice_ch_char_Maer_vo_topic_05_1"
        },
        voice_ch_char_Maer_vo_topic_05_2 = {
          ContentES = "Claro que es... ejem, ejem, Señorita Margie, ¡la Detective Taciturna que recorre los rincones más recónditos de la ciudad! ¡Hoy te revelaré los secretos del Lago Helado, como siempre!",
          TextMapId = "voice_ch_char_Maer_vo_topic_05_2"
        },
        voice_ch_char_Maer_vo_topic_05_3 = {
          ContentES = "Jeje, ¡ese sí que es un título apropiado para mí!",
          TextMapId = "voice_ch_char_Maer_vo_topic_05_3"
        },
        voice_ch_char_Maer_vo_victory = {
          ContentES = "¡Qué gran botín hoy!",
          TextMapId = "voice_ch_char_Maer_vo_victory"
        },
        voice_ch_char_Maer_vo_welcome = {
          ContentES = "¡He quitado la nieve de la entrada de tu casa de camino aquí! ¿Te ha impresionado, verdad? Seguramente estás pensando en invitarme a una taza de chocolate~",
          TextMapId = "voice_ch_char_Maer_vo_welcome"
        },
        voice_ch_char_NanzhuLight_vo_appear = {
          ContentES = "El mundo fuera de la Isla del Purgatorio desafía todos los relatos, más expansivo, pero más brutal. Este no puede ser su verdadero destino. Por eso, debe hacerse un cambio.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_appear"
        },
        voice_ch_char_NanzhuLight_vo_battleidle = {
          ContentES = "¿A dónde vamos ahora? Déjame revisar el mapa... Uf... Sé que los mapas no me quieren.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_battleidle"
        },
        voice_ch_char_NanzhuLight_vo_battlestart = {
          ContentES = "Esta espada todavía cumple con su deber.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_battlestart"
        },
        voice_ch_char_NanzhuLight_vo_die_r01 = {
          ContentES = "No puedo detenerme… ahora no…",
          TextMapId = "voice_ch_char_NanzhuLight_vo_die_r01"
        },
        voice_ch_char_NanzhuLight_vo_die_r02 = {
          ContentES = "Si tan solo... pudiera volver al lugar donde prometimos...",
          TextMapId = "voice_ch_char_NanzhuLight_vo_die_r02"
        },
        voice_ch_char_NanzhuLight_vo_fail = {
          ContentES = "La próxima vez, pagarán el precio.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_fail"
        },
        voice_ch_char_NanzhuLight_vo_lvup = {
          ContentES = "Cada paso que he dado, cada palabra que he oído y cada alma que he conocido, todo ha afinado mi visión de este mundo y el filo de mi espada.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_lvup"
        },
        voice_ch_char_NanzhuLight_vo_revive = {
          ContentES = "¿Eso fue… solo una pesadilla?",
          TextMapId = "voice_ch_char_NanzhuLight_vo_revive"
        },
        voice_ch_char_NanzhuLight_vo_skill01_r01 = {
          ContentES = "Desaparece.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_skill01_r01"
        },
        voice_ch_char_NanzhuLight_vo_skill01_r02 = {
          ContentES = "Corte de luz.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_skill01_r02"
        },
        voice_ch_char_NanzhuLight_vo_skill02_r01 = {
          ContentES = "Esta vez, yo seré el escudo.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_skill02_r01"
        },
        voice_ch_char_NanzhuLight_vo_skill02_r02 = {
          ContentES = "Por el futuro que afrontaremos juntos.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_skill02_r02"
        },
        voice_ch_char_NanzhuLight_vo_skill02_r03 = {
          ContentES = "Regresa al Mar Nebuloso.",
          TextMapId = "voice_ch_char_NanzhuLight_vo_skill02_r03"
        },
        voice_ch_char_NanzhuLight_vo_victory = {
          ContentES = "Otro paso adelante. Mientras siga avanzando, llegaré…",
          TextMapId = "voice_ch_char_NanzhuLight_vo_victory"
        },
        voice_ch_char_Nifu_vo_appear = {
          ContentES = "Ofreceré la humilde ayuda que esté a mi alcance.",
          TextMapId = "voice_ch_char_Nifu_vo_appear"
        },
        voice_ch_char_Nifu_vo_battleidle = {
          ContentES = "Si el cansancio te abruma, descansa aquí un rato. No necesitas forzarte.",
          TextMapId = "voice_ch_char_Nifu_vo_battleidle"
        },
        voice_ch_char_Nifu_vo_battlestart = {
          ContentES = "Permanezco en guardia en la orilla del Río de la Vida.",
          TextMapId = "voice_ch_char_Nifu_vo_battlestart"
        },
        voice_ch_char_Nifu_vo_be_hit_heavy_r01 = {
          ContentES = "…Estoy bien.",
          TextMapId = "voice_ch_char_Nifu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Nifu_vo_be_hit_heavy_r02 = {
          ContentES = "La paciencia me guiará.",
          TextMapId = "voice_ch_char_Nifu_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Nifu_vo_birthday = {
          ContentES = "{性别:Querido niño|Querida niña}, has recorrido con seguridad otro año, y me alegro de verdad por ti.\nVen, haz un deseo. A tu edad, debes tener más sueños y estos te guiarán en el camino.\nNingún río fluye sin encontrar turbulencias. Aun si las espinas te hieren o la corriente te desvía, te deseo el coraje para seguir adelante. Y cuando por fin llegues a tu propio puerto, que aprecies cada momento del viaje que te llevó hasta allí.\nSi te sientes {性别:perdido|perdida} o simplemente quieres escuchar unos cuentos, mis brazos siempre estarán abiertos para ti. Te mantendré en mis oraciones y te bendeciré... por toda la eternidad.",
          TextMapId = "voice_ch_char_Nifu_vo_birthday"
        },
        voice_ch_char_Nifu_vo_companio_01 = {
          ContentES = "Ninguno podrá escapar de su pasado para siempre. Con el tiempo, tendrás que enfrentarte a él... Que tengas la fuerza para confrontarlo cuando llegue ese momento.",
          TextMapId = "voice_ch_char_Nifu_vo_companio_01"
        },
        voice_ch_char_Nifu_vo_companio_02 = {
          ContentES = "Querida, llevas un aura que me resulta muy familiar. ¿Será que tú, como yo, provienes de días pasados?",
          TextMapId = "voice_ch_char_Nifu_vo_companio_02"
        },
        voice_ch_char_Nifu_vo_companio_03 = {
          ContentES = "Saludos, muchacho. Jeje... En efecto, compartimos una semejanza en nuestros cuernos. Tal vez nuestros caminos se cruzaron hace mucho tiempo. Pero esa no es tu carga. Déjala a un lado y sigue el camino que tu corazón desee.",
          TextMapId = "voice_ch_char_Nifu_vo_companio_03"
        },
        voice_ch_char_Nifu_vo_companio_04 = {
          ContentES = "Mis recuerdos abarcan tiempos inmemorables, pero gran parte de lo que he presenciado ha sido crueldad. Quizás olvidar sea, en realidad, una bendición. Confía en que lo verdaderamente importante volverá a ti, aunque no lo recuerdes.",
          TextMapId = "voice_ch_char_Nifu_vo_companio_04"
        },
        voice_ch_char_Nifu_vo_die_r01 = {
          ContentES = "No te preocupes... como siempre, pronto estaré...",
          TextMapId = "voice_ch_char_Nifu_vo_die_r01"
        },
        voice_ch_char_Nifu_vo_die_r02 = {
          ContentES = "Más vale disfrutar el consuelo en este fugaz letargo.",
          TextMapId = "voice_ch_char_Nifu_vo_die_r02"
        },
        voice_ch_char_Nifu_vo_fail = {
          ContentES = "No importa. La victoria y la derrota son solo momentos efímeros. Levántate y comienza de nuevo.",
          TextMapId = "voice_ch_char_Nifu_vo_fail"
        },
        voice_ch_char_Nifu_vo_gain = {
          ContentES = "Soy Nifle, la Barquera del Mar Nebuloso. No temas, el Mar Nebuloso no llega a este lugar, ni tampoco eres un alma en pena. Considérame simplemente como una transeúnte... o quizás, una testigo de tu viaje.",
          TextMapId = "voice_ch_char_Nifu_vo_gain"
        },
        voice_ch_char_Nifu_vo_idle = {
          ContentES = "En una tierra tan llena de turbulencias, tener un lugar tan tranquilo para un breve momento de paz es un consuelo excepcional.",
          TextMapId = "voice_ch_char_Nifu_vo_idle"
        },
        voice_ch_char_Nifu_vo_lvup = {
          ContentES = "Como el suave retorno de la primavera, cuando la hierba brota de la tierra y los árboles reverdecen.",
          TextMapId = "voice_ch_char_Nifu_vo_lvup"
        },
        voice_ch_char_Nifu_vo_revive = {
          ContentES = "Parece que aún no ha llegado el momento de mi partida.",
          TextMapId = "voice_ch_char_Nifu_vo_revive"
        },
        voice_ch_char_Nifu_vo_skill01_r01 = {
          ContentES = "El ciclo de nacimiento y muerte.",
          TextMapId = "voice_ch_char_Nifu_vo_skill01_r01"
        },
        voice_ch_char_Nifu_vo_skill01_r02 = {
          ContentES = "La noche da paso al amanecer.",
          TextMapId = "voice_ch_char_Nifu_vo_skill01_r02"
        },
        voice_ch_char_Nifu_vo_skill02_r01 = {
          ContentES = "Como las lágrimas misericordiosas de Madre Embla.",
          TextMapId = "voice_ch_char_Nifu_vo_skill02_r01"
        },
        voice_ch_char_Nifu_vo_skill02_r02 = {
          ContentES = "Como todo río que retorna al Mar Nebuloso.",
          TextMapId = "voice_ch_char_Nifu_vo_skill02_r02"
        },
        voice_ch_char_Nifu_vo_skill02_r03 = {
          ContentES = "Quédate en calma, el alma perdida, sigue mi guía.",
          TextMapId = "voice_ch_char_Nifu_vo_skill02_r03"
        },
        voice_ch_char_Nifu_vo_topic_01_1 = {
          ContentES = "Eso es. A lo largo de los incontables años, he viajado -o quizás he vagabundeado- por cada rincón de Atlasia. He pisado cada palmo de su suelo y acariciado con mis dedos cada grano de arena.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_01_1"
        },
        voice_ch_char_Nifu_vo_topic_01_2 = {
          ContentES = "Cuando hayas viajado por lo suficiente, te darás cuenta de que el paisaje de todos los lugares no es tan diferente. Ya sean las nieves del Norte, las arenas de Khemet o el humo que sale de las chimeneas en Huaxu, son solo diferentes tonalidades de niebla que rodean el bosque.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_01_2"
        },
        voice_ch_char_Nifu_vo_topic_01_3 = {
          ContentES = "Si tuviera que elegir... serían las montañas y los bosques de Aethyrie. El aire de allí me trae la mayor paz.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_01_3"
        },
        voice_ch_char_Nifu_vo_topic_01_4 = {
          ContentES = "Quizás lo hagas.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_01_4"
        },
        voice_ch_char_Nifu_vo_topic_01_5 = {
          ContentES = "Si alguna vez te adentras en el Bosque Esmeralda, ¿podrías traerme un ramo de asteres blancos para conmemorar? Bajo aquella tierra reposan mis amigos, mis hijos y una versión de mí misma de antaño.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_01_5"
        },
        voice_ch_char_Nifu_vo_topic_02_1 = {
          ContentES = "El Mar Nebuloso es la cuna y el descanso final de todos los seres vivos. Al Mar Nebuloso, los difuntos regresan, y desde allí, la vida comienza de nuevo... Igualmente que las nubes que se disuelven en la tierra como lluvia, para que luego florezcan las flores en ese mismo suelo.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_02_1"
        },
        voice_ch_char_Nifu_vo_topic_02_2 = {
          ContentES = "Sí, creo que sí, mi {性别:niño|niña}. Un día viajarás al Mar Nebuloso, a los brazos de la Madre Embla.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_02_2"
        },
        voice_ch_char_Nifu_vo_topic_02_3 = {
          ContentES = "Mi {性别:querido niño|querida niña}, atesora todo lo que la vida te ofrece, pero no le temas a su final. El final no es sufrimiento, sino la inevitable conclusión del viaje de la vida.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_02_3"
        },
        voice_ch_char_Nifu_vo_topic_02_4 = {
          ContentES = "Si te cansas, descansa en mis brazos un rato... No temas, este no será un sueño eterno. Todavía tienes mucho que cumplir en este mundo.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_02_4"
        },
        voice_ch_char_Nifu_vo_topic_03_1 = {
          ContentES = "¿Te sorprende mucho eso? De hecho, hace mucho tiempo, durante \"La Gran Migración\", estuve en primera línea como soldado, experta en combate cuerpo a cuerpo.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_03_1"
        },
        voice_ch_char_Nifu_vo_topic_03_2 = {
          ContentES = "Aunque esos días quedaron atrás, aún recuerdo las habilidades fundamentales del combate.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_03_2"
        },
        voice_ch_char_Nifu_vo_topic_03_3 = {
          ContentES = "Durante mi viaje, me enfrenté a menudo a las bestias salvajes. Sus garras y colmillos me dejaron cicatrices, moretones e incluso sufrí heridas de las que debí haber muerto.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_03_3"
        },
        voice_ch_char_Nifu_vo_topic_03_4 = {
          ContentES = "Incluso la luna eterna mengua y crece, en constante cambio. Los humanos, naturalmente, son mucho más complejos, especialmente alguien que ha vivido incontables vidas más allá de la existencia mortal.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_03_4"
        },
        voice_ch_char_Nifu_vo_topic_03_5 = {
          ContentES = "Si tienes curiosidad por saber sobre aquellos días, te los contaré con detalle otro día.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_03_5"
        },
        voice_ch_char_Nifu_vo_topic_04_1 = {
          ContentES = "\"Amigos\"... Según la definición común de esta palabra, he tenido muchos amigos a lo largo de mi vida.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_1"
        },
        voice_ch_char_Nifu_vo_topic_04_10 = {
          ContentES = "Jeje... Lo interesante es que ni siquiera recuerdo por qué discutieron. Es tan extraño... Ahora, cuando pienso en ellos, lo primero que me viene a la mente son esos pequeños detalles insignificantes.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_10"
        },
        voice_ch_char_Nifu_vo_topic_04_11 = {
          ContentES = "Así es. Efectivamente... Fueron unos días maravillosos y llenos de alegría. Pero ya quedaron en el pasado.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_11"
        },
        voice_ch_char_Nifu_vo_topic_04_2 = {
          ContentES = "Sin embargo, cuando oigo esa palabra, los primeros en venirme a la mente son Lexis y Erika, quienes me sacaron de Elysium.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_2"
        },
        voice_ch_char_Nifu_vo_topic_04_3 = {
          ContentES = "En los anales de la historia y los relatos de héroes, suelen ser retratados como el Sabio que desveló el velo de ignorancia de los dioses, y la Heroína que dio su vida por la causa del Sabio...",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_3"
        },
        voice_ch_char_Nifu_vo_topic_04_4 = {
          ContentES = "Pero en mis recuerdos, simplemente eran Lexis y Erika.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_4"
        },
        voice_ch_char_Nifu_vo_topic_04_5 = {
          ContentES = "Erika era una joven chica valiente y vivaz, con un espíritu que atraía a todos. Lexis, aunque brillante, solía reflexionar demasiado. Se sumía en profundas reflexiones repentinamente, lo que, paradójicamente, le hacía parecer un poco lento.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_5"
        },
        voice_ch_char_Nifu_vo_topic_04_6 = {
          ContentES = "Humm... Una vez, Lexis intentó disculparse con Erika por algo que había hecho. Por capricho, ella señaló uno de los blancos de entrenamiento de los soldados y le dijo que lo perdonaría si lograba dar en la diana...",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_6"
        },
        voice_ch_char_Nifu_vo_topic_04_7 = {
          ContentES = "Por supuesto, ella no lo decía en serio. Ni siquiera todos los soldados podían lograrlo, por no hablar de Lexis, cuyas manos eran para la pluma y el pergamino, no para el arco ni la espada.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_7"
        },
        voice_ch_char_Nifu_vo_topic_04_8 = {
          ContentES = "Pero se tomó sus palabras muy en serio. Después de que los soldados se marcharon, se quedó y practicó solo toda la noche.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_8"
        },
        voice_ch_char_Nifu_vo_topic_04_9 = {
          ContentES = "Como imaginarás, la verdadera historia no es un relato de héroes omnipotentes. Incluso alguien tan brillante como Lexis tenía sus límites, practicó hasta que le sangraron las palmas. Erika terminó envolviéndolas con lino, pero él nunca dio en la diana.",
          TextMapId = "voice_ch_char_Nifu_vo_topic_04_9"
        },
        voice_ch_char_Nifu_vo_victory = {
          ContentES = "Quienes derivan hacia el Mar Nebuloso encontrarán consuelo en su abrazo, llevados por las lluvias del renacimiento, para fundirse con la siguiente corriente interminable.",
          TextMapId = "voice_ch_char_Nifu_vo_victory"
        },
        voice_ch_char_Nifu_vo_welcome = {
          ContentES = "Ah, eres tú, mi {性别:querido niño|querida niña}. Buenos días. ¿Hay algo que quieras compartir conmigo?",
          TextMapId = "voice_ch_char_Nifu_vo_welcome"
        },
        voice_ch_char_NvzhuLight_vo_appear = {
          ContentES = "El mundo fuera de la Isla del Purgatorio desafía todos los relatos, más expansivo, pero más brutal. Este no puede ser su verdadero destino. Por eso, debe hacerse un cambio.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_appear"
        },
        voice_ch_char_NvzhuLight_vo_battleidle = {
          ContentES = "¿A dónde vamos ahora? Déjame revisar el mapa... Uf... Sé que los mapas no me quieren.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_battleidle"
        },
        voice_ch_char_NvzhuLight_vo_battlestart = {
          ContentES = "Esta espada todavía cumple con su deber.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_battlestart"
        },
        voice_ch_char_NvzhuLight_vo_die_r01 = {
          ContentES = "No puedo detenerme… ahora no…",
          TextMapId = "voice_ch_char_NvzhuLight_vo_die_r01"
        },
        voice_ch_char_NvzhuLight_vo_die_r02 = {
          ContentES = "Si tan solo... pudiera volver al lugar donde prometimos...",
          TextMapId = "voice_ch_char_NvzhuLight_vo_die_r02"
        },
        voice_ch_char_NvzhuLight_vo_fail = {
          ContentES = "La próxima vez, pagarán el precio.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_fail"
        },
        voice_ch_char_NvzhuLight_vo_lvup = {
          ContentES = "Cada paso que he dado, cada palabra que he oído y cada alma que he conocido, todo ha afinado mi visión de este mundo y el filo de mi espada.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_lvup"
        },
        voice_ch_char_NvzhuLight_vo_revive = {
          ContentES = "¿Eso fue… solo una pesadilla?",
          TextMapId = "voice_ch_char_NvzhuLight_vo_revive"
        },
        voice_ch_char_NvzhuLight_vo_skill01_r01 = {
          ContentES = "Desaparece.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_skill01_r01"
        },
        voice_ch_char_NvzhuLight_vo_skill01_r02 = {
          ContentES = "Corte de luz.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_skill01_r02"
        },
        voice_ch_char_NvzhuLight_vo_skill02_r01 = {
          ContentES = "Esta vez, yo seré el escudo.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_skill02_r01"
        },
        voice_ch_char_NvzhuLight_vo_skill02_r02 = {
          ContentES = "Por el futuro que afrontaremos juntos.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_skill02_r02"
        },
        voice_ch_char_NvzhuLight_vo_skill02_r03 = {
          ContentES = "Regresa al Mar Nebuloso.",
          TextMapId = "voice_ch_char_NvzhuLight_vo_skill02_r03"
        },
        voice_ch_char_NvzhuLight_vo_victory = {
          ContentES = "Otro paso adelante. Mientras siga avanzando, llegaré…",
          TextMapId = "voice_ch_char_NvzhuLight_vo_victory"
        },
        voice_ch_char_Saiqi_vo_appear = {
          ContentES = "Yo sabía que me llevarías contigo.",
          TextMapId = "voice_ch_char_Saiqi_vo_appear"
        },
        voice_ch_char_Saiqi_vo_battleidle = {
          ContentES = "Ojalá este viaje no terminara tan pronto.",
          TextMapId = "voice_ch_char_Saiqi_vo_battleidle"
        },
        voice_ch_char_Saiqi_vo_battlestart = {
          ContentES = "¡Estoy tan emocionada...! ¡Por fin puedo luchar a tu lado...!",
          TextMapId = "voice_ch_char_Saiqi_vo_battlestart"
        },
        voice_ch_char_Saiqi_vo_be_hit_heavy_r01 = {
          ContentES = "¡No me rendiré!",
          TextMapId = "voice_ch_char_Saiqi_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Saiqi_vo_be_hit_heavy_r02 = {
          ContentES = "¡Estoy bien!",
          TextMapId = "voice_ch_char_Saiqi_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Saiqi_vo_be_hit_r01 = {
          ContentES = "¡Ah!",
          TextMapId = "voice_ch_char_Saiqi_vo_be_hit_r01"
        },
        voice_ch_char_Saiqi_vo_be_hit_r02 = {
          ContentES = "¡Ay!",
          TextMapId = "voice_ch_char_Saiqi_vo_be_hit_r02"
        },
        voice_ch_char_Saiqi_vo_birthday = {
          ContentES = "¡Feliz cumpleaños! Tengo un regalo para ti. Espero que te guste... Sí, es una flor de loto con forma de copo de nieve, que simboliza el \"renacimiento\". Desde que nos conocimos, hemos experimentado muchísimas aventuras juntos, y he sido testigo de tu crecimiento y transformación. Por eso, creo que el \"renacimiento\" es el regalo perfecto para ti.",
          TextMapId = "voice_ch_char_Saiqi_vo_birthday"
        },
        voice_ch_char_Saiqi_vo_companio_01 = {
          ContentES = "Me enteré de que tenías planeada una gran celebración de cumpleaños para Fina. Sé que tienes un corazón considerado, a pesar de tu lengua afilada. ¿Puedo acompañarte la próxima vez que prepares una gran sorpresa de cumpleaños para ella?",
          TextMapId = "voice_ch_char_Saiqi_vo_companio_01"
        },
        voice_ch_char_Saiqi_vo_companio_02 = {
          ContentES = "Camilla, me recuerdas a tu taberna, ruidosa pero hogareña... ¡Qué suerte tengo de tener amigos como vosotros!",
          TextMapId = "voice_ch_char_Saiqi_vo_companio_02"
        },
        voice_ch_char_Saiqi_vo_companio_03 = {
          ContentES = "¿Me contarás la historia de Elysium? ¡Muchas gracias! Humm... ¿Qué tipo de flores te gustaría a cambio? ¿Dicen que deliciosas?",
          TextMapId = "voice_ch_char_Saiqi_vo_companio_03"
        },
        voice_ch_char_Saiqi_vo_die_r01 = {
          ContentES = "Después de luchar a tu lado... no me arrepiento de nada.",
          TextMapId = "voice_ch_char_Saiqi_vo_die_r01"
        },
        voice_ch_char_Saiqi_vo_die_r02 = {
          ContentES = "Aquí termina este viaje...",
          TextMapId = "voice_ch_char_Saiqi_vo_die_r02"
        },
        voice_ch_char_Saiqi_vo_fail = {
          ContentES = "No pasa nada. Aquí tienes una flor. La próxima vez, la suerte estará de nuestro lado.",
          TextMapId = "voice_ch_char_Saiqi_vo_fail"
        },
        voice_ch_char_Saiqi_vo_gain = {
          ContentES = "... Eres tú, mi amigo de tan lejos. ¿Me estás llamando?",
          TextMapId = "voice_ch_char_Saiqi_vo_gain"
        },
        voice_ch_char_Saiqi_vo_idle = {
          ContentES = "Siento que el tiempo pasa volando cuando solo os miro... Ojalá el tiempo no transcurriera tan rápido.",
          TextMapId = "voice_ch_char_Saiqi_vo_idle"
        },
        voice_ch_char_Saiqi_vo_lvup = {
          ContentES = "¡Ahora puedo protegerlos a todos!",
          TextMapId = "voice_ch_char_Saiqi_vo_lvup"
        },
        voice_ch_char_Saiqi_vo_revive = {
          ContentES = "¿Aún estoy... viva...?",
          TextMapId = "voice_ch_char_Saiqi_vo_revive"
        },
        voice_ch_char_Saiqi_vo_skill01_r01 = {
          ContentES = "Lo siento.",
          TextMapId = "voice_ch_char_Saiqi_vo_skill01_r01"
        },
        voice_ch_char_Saiqi_vo_skill01_r02 = {
          ContentES = "¡Volad!",
          TextMapId = "voice_ch_char_Saiqi_vo_skill01_r02"
        },
        voice_ch_char_Saiqi_vo_skill02_r01 = {
          ContentES = "Florece como una flor.",
          TextMapId = "voice_ch_char_Saiqi_vo_skill02_r01"
        },
        voice_ch_char_Saiqi_vo_skill02_r02 = {
          ContentES = "¡Libérate del capullo!",
          TextMapId = "voice_ch_char_Saiqi_vo_skill02_r02"
        },
        voice_ch_char_Saiqi_vo_skill02_r03 = {
          ContentES = "Descompone o arde bajo el sol.",
          TextMapId = "voice_ch_char_Saiqi_vo_skill02_r03"
        },
        voice_ch_char_Saiqi_vo_topic_01_1 = {
          ContentES = "¡Gracias! De hecho, los Charons somos bastante resistentes al frío, así que no necesitamos abrigos pesados y caros.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_01_1"
        },
        voice_ch_char_Saiqi_vo_topic_01_2 = {
          ContentES = "Mi mamá hizo este vestido, pero yo elegí el color -este verde vibrante- y también los patrones de las mariposas. Quedaría genial en un lugar cálido, como el sur.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_01_2"
        },
        voice_ch_char_Saiqi_vo_topic_01_3 = {
          ContentES = "¿De verdad? ¡Qué bien! De hecho, solo he visto mariposas azules en los alrededores del Lago Helado. Me encantaría ver algún día qué otros colores de las mariposas existen.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_01_3"
        },
        voice_ch_char_Saiqi_vo_topic_02_1 = {
          ContentES = "Sí, siempre ha sido así durante cientos de años. Nos tratan como plagas, e incluso he sufrido acoso e insultos sin ninguna razón.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_1"
        },
        voice_ch_char_Saiqi_vo_topic_02_2 = {
          ContentES = "Probablemente. Dicen que \"La magia es la raíz de todo mal\". Los libros de historia afirman que nuestros ancestros la usaron para gobernar a los Solas hace más de mil años, cometiendo actos terribles.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_2"
        },
        voice_ch_char_Saiqi_vo_topic_02_3 = {
          ContentES = "Sinceramente, me resulta difícil imaginar algo así... Los Charons que conozco tienen tanto miedo de los Solas que ni siquiera se atreven a hablar en su presencia, y mucho menos a usar magia.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_3"
        },
        voice_ch_char_Saiqi_vo_topic_02_4 = {
          ContentES = "Además, la magia de la mayoría de los Charons es bastante simple: solo sirve para cosas sencillas como encender la chimenea o congelar los alimentos.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_4"
        },
        voice_ch_char_Saiqi_vo_topic_02_5 = {
          ContentES = "En absoluto. ¿Por qué uno tiene que gobernar al otro? ¿Por qué los Charons y los Solas no pueden vivir en paz simplemente?",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_5"
        },
        voice_ch_char_Saiqi_vo_topic_02_6 = {
          ContentES = "Lo único que deseo es que... cuando llegue la primavera, todos podamos salir juntos a disfrutar de las flores. Con eso me bastaría.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_02_6"
        },
        voice_ch_char_Saiqi_vo_topic_03_1 = {
          ContentES = "Ah, seguramente son de mi nuevo proyecto de jardinería. El patio de la Casa de Hypnos parecía un poco pelado con tan pocos árboles. Así que yo quería plantar algunas flores blancas ahí...",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_03_1"
        },
        voice_ch_char_Saiqi_vo_topic_03_2 = {
          ContentES = "Quizás debería plantar algunas aquí también: campanitas, anémonas, drías blancas... ¿Cuál se adaptaría mejor a este lugar?",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_03_2"
        },
        voice_ch_char_Saiqi_vo_topic_03_3 = {
          ContentES = "Tienes razón, debería ser una decisión de todos... ¡Iré a preguntar! Por cierto, ¿qué flor te gusta más entre estas? Te recogeré algunas cuando florezcan.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_03_3"
        },
        voice_ch_char_Saiqi_vo_topic_04_1 = {
          ContentES = "No, he vivido aquí toda mi vida. Siempre oigo esos trenes y me pregunto a dónde irán. Me encantaría ver qué hay allí afuera.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_04_1"
        },
        voice_ch_char_Saiqi_vo_topic_04_2 = {
          ContentES = "Mmm, me encantaría visitar la capital, para empezar. El tío Henrik me contó que los atardeceres en el Río Escarlata son impresionantes... ¡Ah! Y me encantaría visitar la Isla del Purgatorio de la que me hablabas, para sentir la brisa marina y ver si es tan salada como dijiste.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_04_2"
        }
      }
    end
  },
  {
    MinKey = "voice_ch_char_Saiqi_vo_topic_05_1",
    MaxKey = "voice_ch_char_Xier_vo_topic_03_1",
    Loader = function()
      return {
        voice_ch_char_Saiqi_vo_topic_05_1 = {
          ContentES = "Oh, nada, es que... Quiero miraros bien, para memorizar vuestros rostros.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_05_1"
        },
        voice_ch_char_Saiqi_vo_topic_05_2 = {
          ContentES = "¿Podrías mirarme atentamente un momento? Me gustaría que me recuerdes... tal como soy ahora.",
          TextMapId = "voice_ch_char_Saiqi_vo_topic_05_2"
        },
        voice_ch_char_Saiqi_vo_victory = {
          ContentES = "Este viaje quedará grabado en mi corazón para siempre.",
          TextMapId = "voice_ch_char_Saiqi_vo_victory"
        },
        voice_ch_char_Saiqi_vo_welcome = {
          ContentES = "¡Genial! Sigo aquí hoy. Y tú también...",
          TextMapId = "voice_ch_char_Saiqi_vo_welcome"
        },
        voice_ch_char_Shuimu_vo_appear = {
          ContentES = "Pues, ¿me estás invitando a una cita?",
          TextMapId = "voice_ch_char_Shuimu_vo_appear"
        },
        voice_ch_char_Shuimu_vo_battleidle = {
          ContentES = "¡Date prisa! No quiero llegar tarde y arruinar nuestra cita...",
          TextMapId = "voice_ch_char_Shuimu_vo_battleidle"
        },
        voice_ch_char_Shuimu_vo_battlestart = {
          ContentES = "Mi veneno está aumentando como mi pasión por el amor...",
          TextMapId = "voice_ch_char_Shuimu_vo_battlestart"
        },
        voice_ch_char_Shuimu_vo_be_hit_heavy_r01 = {
          ContentES = "¡Qué brutalidad!",
          TextMapId = "voice_ch_char_Shuimu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Shuimu_vo_be_hit_heavy_r02 = {
          ContentES = "¡Eres de sangre fría!",
          TextMapId = "voice_ch_char_Shuimu_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Shuimu_vo_be_hit_r01 = {
          ContentES = "¡Ah!",
          TextMapId = "voice_ch_char_Shuimu_vo_be_hit_r01"
        },
        voice_ch_char_Shuimu_vo_be_hit_r02 = {
          ContentES = "¡Eh!",
          TextMapId = "voice_ch_char_Shuimu_vo_be_hit_r02"
        },
        voice_ch_char_Shuimu_vo_birthday = {
          ContentES = "He oído que hoy es tu cumpleaños. ¿Te gustaría acompañarme a mi jardín de aromas? Ahí es donde guardo los ingredientes aromáticos especialmente para ti. Cada uno contiene el aroma puro del amor, destinado solo para nosotros. ¿Eh? ¿Si los perfumes son tóxicos? *risita*, ven conmigo y lo descubrirás.",
          TextMapId = "voice_ch_char_Shuimu_vo_birthday"
        },
        voice_ch_char_Shuimu_vo_companio_01 = {
          ContentES = "Ese aliento seco... ¡Ah, eres tú! ¡Cuánto tiempo sin verte! ¿Sigues planeando llevarme esposada? ¡Sí! Suena divertido.\nDespués de todo, aunque te diera mil oportunidades, siempre escaparía de tu control... ¿No crees? Señorita Alcaidesa.",
          TextMapId = "voice_ch_char_Shuimu_vo_companio_01"
        },
        voice_ch_char_Shuimu_vo_companio_02 = {
          ContentES = "¿Me tienes miedo? No te preocupes. Al final, haré que me ames. Ven, huele la fragancia que mezclé. Es muy dulce y creo que te encantará.",
          TextMapId = "voice_ch_char_Shuimu_vo_companio_02"
        },
        voice_ch_char_Shuimu_vo_companio_03 = {
          ContentES = "Eres tan extraña como yo. Disfrutas que te hagan daño, saboreas el dolor y masacras a tus enemigos sin pestañear... Lo entiendo. *risita* Así es como debes expresar tu amor.",
          TextMapId = "voice_ch_char_Shuimu_vo_companio_03"
        },
        voice_ch_char_Shuimu_vo_die_r01 = {
          ContentES = "Dios del Amor... Por favor no me abandones...",
          TextMapId = "voice_ch_char_Shuimu_vo_die_r01"
        },
        voice_ch_char_Shuimu_vo_die_r02 = {
          ContentES = "Adiós... amor mío...",
          TextMapId = "voice_ch_char_Shuimu_vo_die_r02"
        },
        voice_ch_char_Shuimu_vo_fail = {
          ContentES = "El fracaso duele... Necesito un poco de consuelo de tu parte.",
          TextMapId = "voice_ch_char_Shuimu_vo_fail"
        },
        voice_ch_char_Shuimu_vo_gain = {
          ContentES = "¡Qué encuentro tan romántico! ¿Será obra del dios del amor? Jeje... Me llamo Rebecca, perfumista. ¿Qué tal si pruebas una fragancia verdaderamente única... La Esencia del Amor? La elaboré yo misma.",
          TextMapId = "voice_ch_char_Shuimu_vo_gain"
        },
        voice_ch_char_Shuimu_vo_idle = {
          ContentES = "¿Te quedas para pasar un rato agradable conmigo? *risita* Ya lo estoy esperando.",
          TextMapId = "voice_ch_char_Shuimu_vo_idle"
        },
        voice_ch_char_Shuimu_vo_lvup = {
          ContentES = "¿Es esto una recompensa por mi amor incondicional?",
          TextMapId = "voice_ch_char_Shuimu_vo_lvup"
        },
        voice_ch_char_Shuimu_vo_revive = {
          ContentES = "¿Es este el poder del amor...?",
          TextMapId = "voice_ch_char_Shuimu_vo_revive"
        },
        voice_ch_char_Shuimu_vo_skill01_r01 = {
          ContentES = "Ven más cerca.",
          TextMapId = "voice_ch_char_Shuimu_vo_skill01_r01"
        },
        voice_ch_char_Shuimu_vo_skill01_r02 = {
          ContentES = "¡Sin contacto violento!",
          TextMapId = "voice_ch_char_Shuimu_vo_skill01_r02"
        },
        voice_ch_char_Shuimu_vo_skill02_r01 = {
          ContentES = "¡Dulce veneno que baja por tu garganta!",
          TextMapId = "voice_ch_char_Shuimu_vo_skill02_r01"
        },
        voice_ch_char_Shuimu_vo_skill02_r02 = {
          ContentES = "¡Púdrete en este fragancia dulce!",
          TextMapId = "voice_ch_char_Shuimu_vo_skill02_r02"
        },
        voice_ch_char_Shuimu_vo_skill02_r03 = {
          ContentES = "No temas, te enviaré a la Tierra del Amor.",
          TextMapId = "voice_ch_char_Shuimu_vo_skill02_r03"
        },
        voice_ch_char_Shuimu_vo_topic_01_1 = {
          ContentES = "Sí, me encantan los días lluviosos. Me recuerdan a las historias de amor que he leído, donde los encuentros románticos siempre suceden bajo la lluvia.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_01_1"
        },
        voice_ch_char_Shuimu_vo_topic_01_2 = {
          ContentES = "¿Has observado alguna vez a los que buscan refugio de la lluvia? Se encuentran bajo los aleros, el aire húmedo intensifica el aroma de la vegetación, el amor fluye gentilmente con avances tentativos...",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_01_2"
        },
        voice_ch_char_Shuimu_vo_topic_01_3 = {
          ContentES = "Jeje... Espera a la próxima vez que llueva y sal conmigo, lo verás.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_01_3"
        },
        voice_ch_char_Shuimu_vo_topic_02_1 = {
          ContentES = "Ah, inicias una conversación sobre el amor conmigo... qué inesperado.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_02_1"
        },
        voice_ch_char_Shuimu_vo_topic_02_2 = {
          ContentES = "Hmm, ¿cómo lo describo?... Hum, es como el agua en el perfume, que besa y abraza cada ingrediente, devora y absorbe su fragancia, y al final se fusiona con ellos para crear un aroma duradero...",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_02_2"
        },
        voice_ch_char_Shuimu_vo_topic_02_3 = {
          ContentES = "Mucho más. Busco un amor tan profundo que nos haga verdaderamente inseparables... Incluso si la vida de uno termina, este se convertirá en el abono para las flores de nuestro jardín, las flores se convertirán en perfume, perdurando alrededor del otro por la eternidad.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_02_3"
        },
        voice_ch_char_Shuimu_vo_topic_03_1 = {
          ContentES = "¿Especial? Ay, efectivamente... Desde pequeña, muchos me han visto un \"monstruo\".",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_03_1"
        },
        voice_ch_char_Shuimu_vo_topic_03_2 = {
          ContentES = "Esas caras de disgusto no son agradables, y eso hay que corregirlo...",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_03_2"
        },
        voice_ch_char_Shuimu_vo_topic_03_3 = {
          ContentES = "Quizás una pequeña punzada de mi toxina en su piel suavice esas miradas de disgusto... Jeje.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_03_3"
        },
        voice_ch_char_Shuimu_vo_topic_03_4 = {
          ContentES = "Entonces, cuando dices \"especial\", ¿te refieres a \"especial\" como un monstruo... o a \"especialmente\" encantadora?",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_03_4"
        },
        voice_ch_char_Shuimu_vo_topic_04_1 = {
          ContentES = "Estoy perfectamente bien. Mi veneno forma parte de mí, como un regalo del Dios del Amor, es inofensivo para mí y me ayudará a encontrar a mi amor predestinado.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_04_1"
        },
        voice_ch_char_Shuimu_vo_topic_04_2 = {
          ContentES = "Por supuesto. Aunque a menudo me hace parecer un monstruo, también me distingue. Creo firmemente que el Predestinado para un monstruo debe ser muy especial, ¿no crees?",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_04_2"
        },
        voice_ch_char_Shuimu_vo_topic_05_1 = {
          ContentES = "Es mi perfume característico, con notas de salida tan intensas como un primer encuentro, notas de corazón de dulzura que fijan el aroma, y una nota de fondo que perdura con un regusto agridulce.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_05_1"
        },
        voice_ch_char_Shuimu_vo_topic_05_2 = {
          ContentES = "Ese es mi pequeño secreto. Sin embargo, me encantaría guiarte personalmente en el proceso de elaboración, paso a paso, del comienzo al final.",
          TextMapId = "voice_ch_char_Shuimu_vo_topic_05_2"
        },
        voice_ch_char_Shuimu_vo_victory = {
          ContentES = "Castigaré a quienes... no sean fieles al amor en nombre del Dios del Amor.",
          TextMapId = "voice_ch_char_Shuimu_vo_victory"
        },
        voice_ch_char_Shuimu_vo_welcome = {
          ContentES = "He estado esperando aquí desde que desperté. Mi veneno casi se ha agotado... Menos mal que viniste. Puedo sentirlo burbujear otra vez por mis venas... ¿Podrías... acercarte un poco más?",
          TextMapId = "voice_ch_char_Shuimu_vo_welcome"
        },
        voice_ch_char_Songlu_vo_appear = {
          ContentES = "Filbert, despierta! ¡Es hora de irnos!",
          TextMapId = "voice_ch_char_Songlu_vo_appear"
        },
        voice_ch_char_Songlu_vo_battleidle = {
          ContentES = "Ñam, ñam, ñam...",
          TextMapId = "voice_ch_char_Songlu_vo_battleidle"
        },
        voice_ch_char_Songlu_vo_battlestart = {
          ContentES = "¡Filbert, vamos, vamos, vamos!",
          TextMapId = "voice_ch_char_Songlu_vo_battlestart"
        },
        voice_ch_char_Songlu_vo_be_hit_heavy_r01 = {
          ContentES = "No es justo...",
          TextMapId = "voice_ch_char_Songlu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Songlu_vo_be_hit_r01 = {
          ContentES = "Ay...",
          TextMapId = "voice_ch_char_Songlu_vo_be_hit_r01"
        },
        voice_ch_char_Songlu_vo_birthday = {
          ContentES = "¡Feliz cumpleaños! Hice un pastel de crema gigante con nueces y mermelada. Pero el olor atrajo a mucha gente... así que... eh... también lo compartí con ellos. ¡Pero no te preocupes! ¡Guardé un trozo para ti! ¡Mira! Elegí el trozo más grande, con mermelada y bayas boreales encima. Pruébalo. Sabe mucho mejor que nuestra ración del ejército.",
          TextMapId = "voice_ch_char_Songlu_vo_birthday"
        },
        voice_ch_char_Songlu_vo_companio_01 = {
          ContentES = "¿Encontraste patatas germinadas en el basurero? ¡No las tires! ¡Las plantamos! Después de mullir la tierra y regar, ¡pronto tendremos muchas patatas para todos!",
          TextMapId = "voice_ch_char_Songlu_vo_companio_01"
        },
        voice_ch_char_Songlu_vo_companio_02 = {
          ContentES = "Siempre estás trabajando muy duro. ¿No te da hambre? ¿Por qué no te unes a la Iglesia? ¡Te prometo que te llenaré la barriga!",
          TextMapId = "voice_ch_char_Songlu_vo_companio_02"
        },
        voice_ch_char_Songlu_vo_companio_03 = {
          ContentES = "¡Holaaa! Oí que rezar te puede elevar el espíritu. Yo, personalmente, creo que una buena comida hace lo mismo. Pero, ¿qué funciona mejor, rezar o comer?",
          TextMapId = "voice_ch_char_Songlu_vo_companio_03"
        },
        voice_ch_char_Songlu_vo_die_r01 = {
          ContentES = "Mira, las espigas de trigo enormes... son más grandes que las bayas...",
          TextMapId = "voice_ch_char_Songlu_vo_die_r01"
        },
        voice_ch_char_Songlu_vo_die_r02 = {
          ContentES = "Imposible... Tomé una comida completa antes del combate...",
          TextMapId = "voice_ch_char_Songlu_vo_die_r02"
        },
        voice_ch_char_Songlu_vo_fail = {
          ContentES = "Filbert, ¿estás bien? ¿Te duele algo?... Oh, mi pequeña dulce... déjame darte un abrazo...",
          TextMapId = "voice_ch_char_Songlu_vo_fail"
        },
        voice_ch_char_Songlu_vo_gain = {
          ContentES = "¡Holaaa! Soy Truffle, la Comisaria, aquí estoy con mis fieles compañeros, la Familia Filbert. ¡Bueno, eso es todo por mi presentación! ¡Pero debo decir que tienes los ojos como platos! ¡Debes estar muriéndote de hambre!",
          TextMapId = "voice_ch_char_Songlu_vo_gain"
        },
        voice_ch_char_Songlu_vo_idle = {
          ContentES = "Vamos a descansar un poco, Filbert. Toma algo de grano y frutos secos, y unas cuantas flores de aperitivo. Si no tienes hambre, las engancharé en mi sombrero por ahora.",
          TextMapId = "voice_ch_char_Songlu_vo_idle"
        },
        voice_ch_char_Songlu_vo_lvup = {
          ContentES = "Con el estómago vacío no llegarás lejos en la batalla. ¡Así que come algo y prepárate para la victoria!",
          TextMapId = "voice_ch_char_Songlu_vo_lvup"
        },
        voice_ch_char_Songlu_vo_revive = {
          ContentES = "La comida de emergencia es asquerosa... Bueno, al menos me llena el estómago.",
          TextMapId = "voice_ch_char_Songlu_vo_revive"
        },
        voice_ch_char_Songlu_vo_skill01_r01 = {
          ContentES = "¡Te voy a hacer volar!",
          TextMapId = "voice_ch_char_Songlu_vo_skill01_r01"
        },
        voice_ch_char_Songlu_vo_skill01_r02 = {
          ContentES = "¡Esto va a doler!",
          TextMapId = "voice_ch_char_Songlu_vo_skill01_r02"
        },
        voice_ch_char_Songlu_vo_skill02_r01 = {
          ContentES = "¡Llega la Comisaria! ¡Adiós al hambre!",
          TextMapId = "voice_ch_char_Songlu_vo_skill02_r01"
        },
        voice_ch_char_Songlu_vo_skill02_r02 = {
          ContentES = "¡Ha llegado la Comisaria especial! ¡A hartarse para siempre!",
          TextMapId = "voice_ch_char_Songlu_vo_skill02_r02"
        },
        voice_ch_char_Songlu_vo_skill02_r03 = {
          ContentES = "¡Dame la comida o te aplasto!",
          TextMapId = "voice_ch_char_Songlu_vo_skill02_r03"
        },
        voice_ch_char_Songlu_vo_topic_01_1 = {
          ContentES = "¿Eh? ¿No lo sabes? El trabajo de una comisaria es asegurarse de que todos coman bien, lidiando con todo tipo de alimentos cada día.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_01_1"
        },
        voice_ch_char_Songlu_vo_topic_01_2 = {
          ContentES = "Por ejemplo, yo recojo todo tipo de alimentos de la naturaleza en el campo, Filbert los trae de vuelta y luego el Señor Barba de la panadería, los convierte en comida deliciosa para todos.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_01_2"
        },
        voice_ch_char_Songlu_vo_topic_01_3 = {
          ContentES = "Y por cierto, regatear con el Señor Barba ¡también es parte de mi trabajo! ¡Jeje!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_01_3"
        },
        voice_ch_char_Songlu_vo_topic_01_4 = {
          ContentES = "¡Qué va! Los demás parecen ser más bien intelectuales, para ellos todo es papeleo: rellenar solicitudes y esperar a que lleguen trenes llenos de comida.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_01_4"
        },
        voice_ch_char_Songlu_vo_topic_01_5 = {
          ContentES = "Pero para un pueblo pequeño como el nuestro, ¡Filbert y yo podemos alimentar a todos! De lo contrario, quizás tenga que aprender a rellenar esos formularios. ¡Ay, no entiendo nada de eso!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_01_5"
        },
        voice_ch_char_Songlu_vo_topic_02_1 = {
          ContentES = "¿Eh? Hmm, quizás sí... Nunca lo había pensado, ¡pero Filbert solo tumba a esos malandrines, gritones y peleones! ¡Se lo merecen!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_02_1"
        },
        voice_ch_char_Songlu_vo_topic_02_2 = {
          ContentES = "Esos tipos siempre terminan con hambre después de sus peleas. Les iría mejor arando campos que blandiendo armas. Así habría menos gente que se vaya a la cama con hambre.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_02_2"
        },
        voice_ch_char_Songlu_vo_topic_02_3 = {
          ContentES = "¡Absolutamente! Las guerras solo traen hambre, ¡son terribles! He oído que en tiempos de guerra, la gente muere de inanición... ¡es lo peor! Espero no tener que verlo jamás.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_02_3"
        },
        voice_ch_char_Songlu_vo_topic_02_4 = {
          ContentES = "¡Eso es! ¡Quienquiera que cause hambre a la gente, tarde o temprano será embestido por Filbert!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_02_4"
        },
        voice_ch_char_Songlu_vo_topic_03_1 = {
          ContentES = "¡Sí, lo es! Y ¿sabes qué? ¡Aunque haya varios arroyos de por medio, Filbert es capaz de olfatear bayas maduras y luego salimos a toda carga a buscarlas! ¡Bastante genial, ¿no crees?!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_03_1"
        },
        voice_ch_char_Songlu_vo_topic_03_2 = {
          ContentES = "¡No te preocupes! Filbert siempre trae comida extra. ¡Así que nunca, nunca te burles de ella! Le harías daño a ella y también a mí.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_03_2"
        },
        voice_ch_char_Songlu_vo_topic_04_1 = {
          ContentES = "¡Gracias! En realidad, son pantalones cortos, no es un vestido. Al comienzo fue un vestido largo y blanco, muy bonito. Luego la modista de la sastrería los convirtió en pantalones cortos para mí.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_04_1"
        },
        voice_ch_char_Songlu_vo_topic_04_2 = {
          ContentES = "Es que un vestido no es lo más práctico para tanto correteo. Una vez, tropecé con el dobladillo y se me voló todo el pan que llevaba en los brazos.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_04_2"
        },
        voice_ch_char_Songlu_vo_topic_04_3 = {
          ContentES = "Pero si llega el día en que ya nadie pase hambre, ¡le pediré a la modista que me los vuelva a convertir en vestido!",
          TextMapId = "voice_ch_char_Songlu_vo_topic_04_3"
        },
        voice_ch_char_Songlu_vo_topic_05_1 = {
          ContentES = "Oh, yo estoy meditando, no distraída. Soy miembro de la Iglesia Elísea, así que intento reflexionar de vez en cuando.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_05_1"
        },
        voice_ch_char_Songlu_vo_topic_05_2 = {
          ContentES = "Solía preguntarme eso, pero los clérigos dijeron que era… blasfomia o algo así. Así que dejé de pensar en eso.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_05_2"
        },
        voice_ch_char_Songlu_vo_topic_05_3 = {
          ContentES = "Nunca termino de entender lo que dicen, como por ejemplo que la gula es un pecado terrible... pero parece que cuanto más alto es el estatus de alguien, más comen.",
          TextMapId = "voice_ch_char_Songlu_vo_topic_05_3"
        },
        voice_ch_char_Songlu_vo_victory = {
          ContentES = "¡Celebremos con una gran fiesta!... Umm... No, no, sería un desperdicio de comida.",
          TextMapId = "voice_ch_char_Songlu_vo_victory"
        },
        voice_ch_char_Songlu_vo_welcome = {
          ContentES = "El sol brilla mucho y los pajaritos están piando de alegría después de un buen atracón. ¿Tú también tienes hambre? ¿Quieres comer algo también?",
          TextMapId = "voice_ch_char_Songlu_vo_welcome"
        },
        voice_ch_char_Tuosi02_attack_r01 = {
          ContentES = "¡Oíd sus lamentos!",
          TextMapId = "voice_ch_char_Tuosi02_attack_r01"
        },
        voice_ch_char_Tuosi02_shoot_r01 = {
          ContentES = "Objetivo bloqueado.",
          TextMapId = "voice_ch_char_Tuosi02_shoot_r01"
        },
        voice_ch_char_Tuosi02_skill01_r01 = {
          ContentES = "No hay escapatoria.",
          TextMapId = "voice_ch_char_Tuosi02_skill01_r01"
        },
        voice_ch_char_Tuosi02_vo_be_hit_heavy_r01 = {
          ContentES = "De nuevo... como siempre.",
          TextMapId = "voice_ch_char_Tuosi02_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Tuosi02_vo_be_hit_heavy_r02 = {
          ContentES = "Rómpelos en pedazos.",
          TextMapId = "voice_ch_char_Tuosi02_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Tuosi_vo_appear = {
          ContentES = "Me has preparado un nuevo escenario.",
          TextMapId = "voice_ch_char_Tuosi_vo_appear"
        },
        voice_ch_char_Tuosi_vo_battleidle = {
          ContentES = "¿Cómo yo era antes...?",
          TextMapId = "voice_ch_char_Tuosi_vo_battleidle"
        },
        voice_ch_char_Tuosi_vo_battlestart = {
          ContentES = "Ahora presento: Un relato de aventura y grandeza.",
          TextMapId = "voice_ch_char_Tuosi_vo_battlestart"
        },
        voice_ch_char_Tuosi_vo_be_hit_heavy_r01 = {
          ContentES = "Estoy bien.",
          TextMapId = "voice_ch_char_Tuosi_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Tuosi_vo_be_hit_heavy_r02 = {
          ContentES = "Toda una tragedia.",
          TextMapId = "voice_ch_char_Tuosi_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Tuosi_vo_birthday = {
          ContentES = "¡Feliz cumpleaños, {nickname}! Gracias por invitarme. \nPara mí, desde que fui expulsado del escenario, los cumpleaños se han convertido en un amargo recordatorio de días dolorosos ya pasados, como focos extinguidos que jamás volverán a brillar, o viejos guiones arrugados y olvidados en el fondo de una papelera.\nSin embargo, hoy me encuentro reflexionando sobre cómo sería un cumpleaños ordinario; uno compuesto de momentos sencillos y cálidos que solo tienen un significado especial para sus participantes: una caja de regalo hecha a mano con bordes irregulares, un pastel ligeramente estropeado por una vela mal colocada, y—\n... ¿una canción de cumpleaños cantada por los amigos? ¿Quieres que cante yo? Bien. Pero debo confesar que no conozco la melodía de cumpleaños de tu tierra natal. Tendrás que enseñármela primero. No te preocupes, aprendo rápido.",
          TextMapId = "voice_ch_char_Tuosi_vo_birthday"
        },
        voice_ch_char_Tuosi_vo_companio_01 = {
          ContentES = "¿Cómo estás últimamente?\n... Disculpa mi brusquedad. No nos conocemos. Solo pregunto... por un amigo mío.",
          TextMapId = "voice_ch_char_Tuosi_vo_companio_01"
        },
        voice_ch_char_Tuosi_vo_companio_02 = {
          ContentES = "¿Verdad? Así que has encontrado un nuevo hogar y una familia que se preocupa por ti... ¡Qué bueno! Rompiste tu jaula... ¡Qué alma tan valiente eres!",
          TextMapId = "voice_ch_char_Tuosi_vo_companio_02"
        },
        voice_ch_char_Tuosi_vo_companio_03 = {
          ContentES = "Señorita, la música que toca es verdaderamente cautivadora. ¿Puedo preguntar el nombre de esta pieza?\nAh, una composición original suya... ¡Qué talento tan envidiable! ¿Pues, podría tener el honor de admirar la partitura?",
          TextMapId = "voice_ch_char_Tuosi_vo_companio_03"
        },
        voice_ch_char_Tuosi_vo_companio_04 = {
          ContentES = "Tu mímica es extraordinaria. Ni siquiera los mejores utileros de escenario podrían crear algo tan exquisitamente detallado.",
          TextMapId = "voice_ch_char_Tuosi_vo_companio_04"
        },
        voice_ch_char_Tuosi_vo_companio_05 = {
          ContentES = "No necesito un espejo para recordarme constantemente mi propia grotesca figura.",
          TextMapId = "voice_ch_char_Tuosi_vo_companio_05"
        },
        voice_ch_char_Tuosi_vo_die_r01 = {
          ContentES = "He terminado... mi actuación.",
          TextMapId = "voice_ch_char_Tuosi_vo_die_r01"
        },
        voice_ch_char_Tuosi_vo_die_r02 = {
          ContentES = "Brindo por... un mundo completamente nuevo...",
          TextMapId = "voice_ch_char_Tuosi_vo_die_r02"
        },
        voice_ch_char_Tuosi_vo_fail = {
          ContentES = "La tragedia es la prueba de los valientes.",
          TextMapId = "voice_ch_char_Tuosi_vo_fail"
        },
        voice_ch_char_Tuosi_vo_gain = {
          ContentES = "Que podamos encontrarnos en la hora más oscura de la noche, donde las sombras cubren mi rostro, librándote del terror de contemplar mi verdadera forma.",
          TextMapId = "voice_ch_char_Tuosi_vo_gain"
        },
        voice_ch_char_Tuosi_vo_idle = {
          ContentES = "Shhh... Casi estoy en el personaje.",
          TextMapId = "voice_ch_char_Tuosi_vo_idle"
        },
        voice_ch_char_Tuosi_vo_lvup = {
          ContentES = "He ensayado para momentos como este incontables veces en el pasado.",
          TextMapId = "voice_ch_char_Tuosi_vo_lvup"
        },
        voice_ch_char_Tuosi_vo_revive = {
          ContentES = "¿Fue solo un intermedio?",
          TextMapId = "voice_ch_char_Tuosi_vo_revive"
        },
        voice_ch_char_Tuosi_vo_skill01_r01 = {
          ContentES = "Toma tu reverencia.",
          TextMapId = "voice_ch_char_Tuosi_vo_skill01_r01"
        },
        voice_ch_char_Tuosi_vo_skill01_r02 = {
          ContentES = "Silencio.",
          TextMapId = "voice_ch_char_Tuosi_vo_skill01_r02"
        },
        voice_ch_char_Tuosi_vo_skill02_r01 = {
          ContentES = "Aunque me convierta en una bestia...",
          TextMapId = "voice_ch_char_Tuosi_vo_skill02_r01"
        },
        voice_ch_char_Tuosi_vo_skill02_r02 = {
          ContentES = "Entonces, toma mi corazón...",
          TextMapId = "voice_ch_char_Tuosi_vo_skill02_r02"
        },
        voice_ch_char_Tuosi_vo_skill02_r03 = {
          ContentES = "Aunque todos los sueños se hayan desvanecido.",
          TextMapId = "voice_ch_char_Tuosi_vo_skill02_r03"
        },
        voice_ch_char_Tuosi_vo_topic_01_1 = {
          ContentES = "Era como una lámpara de cristal rota, una estrella caída en una alcantarilla sucia.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_1"
        },
        voice_ch_char_Tuosi_vo_topic_01_2 = {
          ContentES = "Era justo como esas cosas: ridículamente absurdo, pero de algún modo, brillaba con gran esplendor.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_2"
        },
        voice_ch_char_Tuosi_vo_topic_01_3 = {
          ContentES = "El muro entre nuestras celdas era tan delgado que se oía todo. Estaba allí, a apenas un metro de distancia, divagando sobre su familia, tejiendo sueños del futuro o cantando alguna melodía irremediablemente desafinada.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_3"
        },
        voice_ch_char_Tuosi_vo_topic_01_4 = {
          ContentES = "Por un momento, olvidaba que yo era una bestia enjaulada. Me sentía como un niño normal en la escuela, despertando de una pesadilla durante la siesta, con el ruido de un compañero ruidoso a mi lado.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_4"
        },
        voice_ch_char_Tuosi_vo_topic_01_5 = {
          ContentES = "... Je... Quizás.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_5"
        },
        voice_ch_char_Tuosi_vo_topic_01_6 = {
          ContentES = "Pero \"amigo\" es una palabra demasiado luminosa para alguien como yo. Éramos más bien como dos peces desorientados, luchando por sobrevivir en un lecho de río seco.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_01_6"
        },
        voice_ch_char_Tuosi_vo_topic_02_1 = {
          ContentES = "¿Por qué? La historia de Parsifal terminó hace mucho tiempo. Ese nombre no es más que un eco lejano ahora, tan tenue y distante que a veces me pregunto si fue alguna vez real.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_02_1"
        },
        voice_ch_char_Tuosi_vo_topic_02_2 = {
          ContentES = "... ¿Ah, sí?",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_02_2"
        },
        voice_ch_char_Tuosi_vo_topic_02_3 = {
          ContentES = "Bien. Entonces, llevaré esta actuación final a su conclusión, por ti, mi última y única audiencia.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_02_3"
        },
        voice_ch_char_Tuosi_vo_topic_02_4 = {
          ContentES = "Gracias por concederme un escenario donde descansar mi alma fatigada.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_02_4"
        },
        voice_ch_char_Tuosi_vo_topic_03_1 = {
          ContentES = "Eres muy amable. Gracias. Sin embargo, todas mis promesas se han cumplido. Hay poco que me conmueva.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_03_1"
        },
        voice_ch_char_Tuosi_vo_topic_03_3 = {
          ContentES = "Si alguna vez te encuentras en el Teatro Galea, por favor, transmítele a la Señora Violetta que me he asentado en Aethyrie. Dile que no se preocupe, pues estoy muy bien.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_03_3"
        },
        voice_ch_char_Tuosi_vo_topic_03_4 = {
          ContentES = "\"Una tierra de música y poesía, donde cada guijarro marca un ritmo, y cada arroyo canta una melodía.\"",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_03_4"
        },
        voice_ch_char_Tuosi_vo_topic_03_5 = {
          ContentES = "Espero que esto la convenza de no preguntar por mi paradero. Yo fui su alumno predilecto... Prefiero no empañar sus recuerdos.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_03_5"
        },
        voice_ch_char_Tuosi_vo_topic_03_6 = {
          ContentES = "Así es. La ignorancia es siempre una bendición.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_03_6"
        },
        voice_ch_char_Tuosi_vo_topic_04_1 = {
          ContentES = "¿Por qué quieres aprender a actuar? No necesitas convertirte en otra persona.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_04_1"
        },
        voice_ch_char_Tuosi_vo_topic_04_2 = {
          ContentES = "Cuando estás en el escenario, cada parte de ti desde tus huesos hasta tu respiración, se entrega al personaje. En ese momento, puedes despojarte de todas tus penas y dolores, entrando en un mundo inmaculado por la realidad.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_04_2"
        },
        voice_ch_char_Tuosi_vo_topic_04_3 = {
          ContentES = "Pero tú naciste como {性别:el héroe|la heroína} de tu propia historia, con la admiración y la confianza de quienes te rodean. Brillas con naturalidad, sin necesidad de ningún foco para cautivar.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_04_3"
        },
        voice_ch_char_Tuosi_vo_topic_05_1 = {
          ContentES = "Permanece en pie, perdurando mucho más allá de mis años. A un lado de sus imponentes muros, se alza la imponente ciudad interior, majestuosa como nubes de tormenta, pero más fría.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_1"
        },
        voice_ch_char_Tuosi_vo_topic_05_2 = {
          ContentES = "Figuras elegantemente vestidas descienden de carruajes forrados de seda, discutiendo sobre arte, poesía y el perpetuo cielo sombrío. Cotillean sobre bailes y esponsales, lamentando cómo el fango de la nieve derretida de la ciudad exterior ensucia sus finas botas de cuero.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_2"
        },
        voice_ch_char_Tuosi_vo_topic_05_3 = {
          ContentES = "Al otro lado de los muros,el alborotado distrito de la niebla bulle de caos. Allí los vendedores gritaban a todo pulmón, las madres sujetan a sus hijos, rogando por un mendrugo de pan de centeno. Las manos traviesas dibujaban grafitis desafiantes en el muro, siempre un paso por delante de las patrullas.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_3"
        },
        voice_ch_char_Tuosi_vo_topic_05_4 = {
          ContentES = "Así se encuentra nuestro Teatro Galea. Está atrapado entre estos dos mundos, oyendo todo, pero sin comprender nada.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_4"
        },
        voice_ch_char_Tuosi_vo_topic_05_5 = {
          ContentES = "Curiosamente, lo primero que me viene a la mente no son los guiones ni el lujoso vestuario, ni la abarrotada sala de utilería que barría a diario.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_5"
        },
        voice_ch_char_Tuosi_vo_topic_05_6 = {
          ContentES = "Lo que recuerdo es la alfombra de terciopelo que cubría el escenario tras la caída del telón. Cuando yo era niño, después de la primera actuación que puedo recordar, mi madre y yo nos quedábamos en el escenario una vez que todos se iban, recitando líneas y bailando hasta la madrugada.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_6"
        },
        voice_ch_char_Tuosi_vo_topic_05_7 = {
          ContentES = "Al romper el alba, el cansancio me venció... me recosté en la alfombra, apoyando la cabeza en el regazo de mi madre, y me hundí en un largo y dulce sueño.",
          TextMapId = "voice_ch_char_Tuosi_vo_topic_05_7"
        },
        voice_ch_char_Tuosi_vo_victory = {
          ContentES = "La comedia es la sátira de los sabios.",
          TextMapId = "voice_ch_char_Tuosi_vo_victory"
        },
        voice_ch_char_Tuosi_vo_welcome = {
          ContentES = "Ahora yo actúo como el papel del prisionero destrozado, y tú, como {性别:el alcaide|la alcaidesa}, guardas mis cadenas.",
          TextMapId = "voice_ch_char_Tuosi_vo_welcome"
        },
        voice_ch_char_Xibi_vo_appear = {
          ContentES = "¿Pides ayuda a un enemigo? Bien, parece que el odio no ha oscurecido por completo tu juicio.",
          TextMapId = "voice_ch_char_Xibi_vo_appear"
        },
        voice_ch_char_Xibi_vo_battleidle = {
          ContentES = "¡No hay holgazanería! En la Legión, ya habrías sentido el látigo.",
          TextMapId = "voice_ch_char_Xibi_vo_battleidle"
        },
        voice_ch_char_Xibi_vo_battlestart = {
          ContentES = "¿Quién se atreve a desperdiciar mi tiempo?",
          TextMapId = "voice_ch_char_Xibi_vo_battlestart"
        },
        voice_ch_char_Xibi_vo_be_hit_heavy_r01 = {
          ContentES = "¡Lo lamentarás!",
          TextMapId = "voice_ch_char_Xibi_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Xibi_vo_be_hit_heavy_r02 = {
          ContentES = "¡Eh!",
          TextMapId = "voice_ch_char_Xibi_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Xibi_vo_birthday = {
          ContentES = "... ¿Qué estás esperando? ¿Creías que te prepararía un pastel de cumpleaños? ¡Ja! ¡Qué absurdo! Quizás en la próxima batalla seré piadoso e iré suave contigo.",
          TextMapId = "voice_ch_char_Xibi_vo_birthday"
        },
        voice_ch_char_Xibi_vo_companio_01 = {
          ContentES = "... Es hora de zanjar nuestras diferencias.",
          TextMapId = "voice_ch_char_Xibi_vo_companio_01"
        },
        voice_ch_char_Xibi_vo_companio_02 = {
          ContentES = "Nuestros caminos son diametralmente opuestos. Dudé de mí misma alguna vez, preguntándome si tenías razón. Por desgracia, solo serás recordado como el vencido.",
          TextMapId = "voice_ch_char_Xibi_vo_companio_02"
        },
        voice_ch_char_Xibi_vo_companio_03 = {
          ContentES = "Si no fueras su heredero... mi espada ya habría atravesado tu corazón.",
          TextMapId = "voice_ch_char_Xibi_vo_companio_03"
        },
        voice_ch_char_Xibi_vo_companio_04 = {
          ContentES = "Cuanto más perfecta sea tu máscara, más afilados serán los colmillos que has forjado en la oscuridad. Espero el día en que reveles tu verdadera naturaleza, para destrozarlos sin piedad.",
          TextMapId = "voice_ch_char_Xibi_vo_companio_04"
        },
        voice_ch_char_Xibi_vo_companio_05 = {
          ContentES = "¿Ya se han organizado todos los informes recientes de misiones, planes de combate, documentos de logística e informes de bajas?\nBien, entonces, finalicemos hoy los eslóganes de la campaña exterior, los análisis de los casos internos, los informes de rutina para el Emperador y los datos de las pruebas de las nuevas armas de la Academia Spathatoi. Esto forma parte de nuestro trabajo, no es una carga adicional.",
          TextMapId = "voice_ch_char_Xibi_vo_companio_05"
        },
        voice_ch_char_Xibi_vo_die_r01 = {
          ContentES = "Nos veremos pronto... Su Majestad.",
          TextMapId = "voice_ch_char_Xibi_vo_die_r01"
        },
        voice_ch_char_Xibi_vo_die_r02 = {
          ContentES = "Su Majestad, lo siento... yo no..",
          TextMapId = "voice_ch_char_Xibi_vo_die_r02"
        },
        voice_ch_char_Xibi_vo_fail = {
          ContentES = "La próxima vez, los reduciré a polvo a cada uno.",
          TextMapId = "voice_ch_char_Xibi_vo_fail"
        },
        voice_ch_char_Xibi_vo_gain = {
          ContentES = "Sé lo que quieres preguntar, pero aún no eres lo bastante fuerte como para merecer mi respuesta. Así que, baja tu arma, es el consejo más amable que puedo darte.",
          TextMapId = "voice_ch_char_Xibi_vo_gain"
        },
        voice_ch_char_Xibi_vo_idle = {
          ContentES = "Exponer tu espalda a tu enemigo con tanta facilidad... ¿Es ingenuidad o pura locura?",
          TextMapId = "voice_ch_char_Xibi_vo_idle"
        },
        voice_ch_char_Xibi_vo_lvup = {
          ContentES = "Asciende sin descanso, o serás consumido por el abismo.",
          TextMapId = "voice_ch_char_Xibi_vo_lvup"
        },
        voice_ch_char_Xibi_vo_revive = {
          ContentES = "El infierno no es tan malo. Ya he estado allí antes.",
          TextMapId = "voice_ch_char_Xibi_vo_revive"
        },
        voice_ch_char_Xibi_vo_skill01_r01 = {
          ContentES = "¡Lárgate!",
          TextMapId = "voice_ch_char_Xibi_vo_skill01_r01"
        },
        voice_ch_char_Xibi_vo_skill01_r02 = {
          ContentES = "¡Tiembla!",
          TextMapId = "voice_ch_char_Xibi_vo_skill01_r02"
        },
        voice_ch_char_Xibi_vo_skill02_r01 = {
          ContentES = "Basura patética.",
          TextMapId = "voice_ch_char_Xibi_vo_skill02_r01"
        },
        voice_ch_char_Xibi_vo_skill02_r02 = {
          ContentES = "¡Grita más fuerte, quizás así te muestre clemencia!",
          TextMapId = "voice_ch_char_Xibi_vo_skill02_r02"
        },
        voice_ch_char_Xibi_vo_skill02_r03 = {
          ContentES = "¡Ríndete ante mí!",
          TextMapId = "voice_ch_char_Xibi_vo_skill02_r03"
        },
        voice_ch_char_Xibi_vo_topic_01_1 = {
          ContentES = "Una fuerza especial bajo el mando directo del Emperador, encargada de misiones encubiertas y que sirve como un martillo listo para golpear en el campo de batalla.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_01_1"
        },
        voice_ch_char_Xibi_vo_topic_01_2 = {
          ContentES = "Te equivocas. Sin el Emperador, la Legión sigue en pie, pero sin la Legión, la corona caería sin remedio.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_01_2"
        },
        voice_ch_char_Xibi_vo_topic_01_3 = {
          ContentES = "No dudes en intentarlo. La traición es un delito grave, y cualquier acusación tendría que ascender por los rangos y acabar directamente en mi escritorio.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_01_3"
        },
        voice_ch_char_Xibi_vo_topic_02_1 = {
          ContentES = "Hmpf, mi lealtad no es al Imperio, sino a mis ideales. Un hombre lo dio todo por ellos, y ese es su legado que me esfuerzo por mantener.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_02_1"
        },
        voice_ch_char_Xibi_vo_topic_02_2 = {
          ContentES = "No te falta razón. Sin embargo, para conseguir lo que deseo, usaré todos los medios a mi alcance y ascenderé al poder por cualquier método. Pero cada paso que doy me acerca más a mi ideal. ¿Y a ti, a dónde te han llevado tus pasos?",
          TextMapId = "voice_ch_char_Xibi_vo_topic_02_2"
        },
        voice_ch_char_Xibi_vo_topic_03_1 = {
          ContentES = "Ya da igual. Mi familia ya no está desde hace mucho tiempo.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_03_1"
        },
        voice_ch_char_Xibi_vo_topic_03_2 = {
          ContentES = "De hecho, lo encuentro liberador. Esto significa que ya no hay distracciones, solo hay un camino claro para enfrentarme a mis enemigos, tanto los conocidos como los ocultos.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_03_2"
        },
        voice_ch_char_Xibi_vo_topic_03_3 = {
          ContentES = "Para cualquiera en la Legión, los sentimientos son meras debilidades.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_03_3"
        },
        voice_ch_char_Xibi_vo_topic_04_1 = {
          ContentES = "Así es. He soportado insultos y burlas en persona, aquellos que se esconden a espaldas seguramente se quejan aún más.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_04_1"
        },
        voice_ch_char_Xibi_vo_topic_04_2 = {
          ContentES = "Afortunadamente, en este mundo injusto, el poder absoluto todavía puede ganarte un mínimo de respeto.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_04_2"
        },
        voice_ch_char_Xibi_vo_topic_04_3 = {
          ContentES = "Exactamente. Por eso nunca mostraré debilidad; de lo contrario, se abalanzarán como lobos al olor de la sangre, ansiosos por despedazarme.",
          TextMapId = "voice_ch_char_Xibi_vo_topic_04_3"
        },
        voice_ch_char_Xibi_vo_victory = {
          ContentES = "¿Victoria? Es pan comido...",
          TextMapId = "voice_ch_char_Xibi_vo_victory"
        },
        voice_ch_char_Xibi_vo_welcome = {
          ContentES = "Al observar tus esfuerzos incansables por fortalecerte, no puedo evitar esperar con ansias el día en que vuelvas a desafiarme.",
          TextMapId = "voice_ch_char_Xibi_vo_welcome"
        },
        voice_ch_char_Xier_vo_appear = {
          ContentES = "Bien, haré lo que me pides, por ahora.",
          TextMapId = "voice_ch_char_Xier_vo_appear"
        },
        voice_ch_char_Xier_vo_battleidle = {
          ContentES = "La ropa lavada está casi seca...",
          TextMapId = "voice_ch_char_Xier_vo_battleidle"
        },
        voice_ch_char_Xier_vo_battlestart = {
          ContentES = "Comienza la limpieza.",
          TextMapId = "voice_ch_char_Xier_vo_battlestart"
        },
        voice_ch_char_Xier_vo_be_hit_heavy_r01 = {
          ContentES = "Solo un pequeño rasguño.",
          TextMapId = "voice_ch_char_Xier_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Xier_vo_birthday = {
          ContentES = "Feliz cumpleaños. Si no me equivoco, hoy es tu cumpleaños. Supongo que no necesitas más ayuda, ya que seguro que lo estás celebrando con los demás. Ahora me retiro a mis aposentos para descansar. Ah, he preparado un pastel para ti, que he dejado sobre tu mesa. Estoy convencida de que el sabor cumplirá con tus expectativas, así que asegúrate de terminarlo todo.",
          TextMapId = "voice_ch_char_Xier_vo_birthday"
        },
        voice_ch_char_Xier_vo_companio_01 = {
          ContentES = "Mi flor favorita crece bajo una cúpula de calor eterno. Un solo pétalo, destilado en el té de la noche, trae un sueño reparador. Sin embargo, diez pétalos son venenosos y tienen el poder de inducir el sueño eterno. En mis sueños, podo esta flor y, al despertar, agradezco no tener que cuidarla jamás.",
          TextMapId = "voice_ch_char_Xier_vo_companio_01"
        },
        voice_ch_char_Xier_vo_companio_02 = {
          ContentES = "Qué maravilloso, me sorprende que reflexiones constantemente sobre temas tan profundos. Por mi parte, yo soy una humilde criada, me preocupo solo por las minucias de la vida cotidiana.",
          TextMapId = "voice_ch_char_Xier_vo_companio_02"
        },
        voice_ch_char_Xier_vo_companio_03 = {
          ContentES = "Estos montones de trastos han sido una molestia durante mucho tiempo. Me alegraría que los quitaras. Pero antes de que entres, insisto en hacer una limpieza a fondo, sin objeciones y sin resistirse.",
          TextMapId = "voice_ch_char_Xier_vo_companio_03"
        },
        voice_ch_char_Xier_vo_die_r01 = {
          ContentES = "Esto tendrá que volver a lavarse...",
          TextMapId = "voice_ch_char_Xier_vo_die_r01"
        },
        voice_ch_char_Xier_vo_die_r02 = {
          ContentES = "Lo siento... Señorita Flora...",
          TextMapId = "voice_ch_char_Xier_vo_die_r02"
        },
        voice_ch_char_Xier_vo_fail = {
          ContentES = "Lo siento... Parece que he subestimado la cantidad de suciedad. Debo conseguir las herramientas de limpieza más adecuadas...",
          TextMapId = "voice_ch_char_Xier_vo_fail"
        },
        voice_ch_char_Xier_vo_gain = {
          ContentES = "Soy Hilda, una humilde criada. Me encargo de absolutamente todo de la señorita Flora: desde las rutinas diarias y los planes de dieta hasta la sastrería y la recepción... ¡Ah! Y, si surge la ocasión, soy bastante diestra eliminando molestias o invitados no deseados. Un pequeño servicio adicional, supongo.",
          TextMapId = "voice_ch_char_Xier_vo_gain"
        },
        voice_ch_char_Xier_vo_idle = {
          ContentES = "Desde el amanecer hasta el anochecer, la criada está siempre ocupada. Pero de vez en cuando, puede encontrarse con una distracción inesperada, como alguien que busca su atención mientras está pensando en el menú de la semana.",
          TextMapId = "voice_ch_char_Xier_vo_idle"
        },
        voice_ch_char_Xier_vo_lvup = {
          ContentES = "Debería agradecerte por cortesía. Pero que hacerme más fuerte solo significa más trabajo para mí.",
          TextMapId = "voice_ch_char_Xier_vo_lvup"
        },
        voice_ch_char_Xier_vo_revive = {
          ContentES = "Tras un breve descanso, puedo continuar con la limpieza.",
          TextMapId = "voice_ch_char_Xier_vo_revive"
        },
        voice_ch_char_Xier_vo_skill01_r01 = {
          ContentES = "Plagas sucias.",
          TextMapId = "voice_ch_char_Xier_vo_skill01_r01"
        },
        voice_ch_char_Xier_vo_skill01_r02 = {
          ContentES = "Bah.",
          TextMapId = "voice_ch_char_Xier_vo_skill01_r02"
        },
        voice_ch_char_Xier_vo_skill02_r01 = {
          ContentES = "¡No quedará ni un rastro de suciedad!",
          TextMapId = "voice_ch_char_Xier_vo_skill02_r01"
        },
        voice_ch_char_Xier_vo_skill02_r02 = {
          ContentES = "La limpieza avanza bien, aunque con algo de ruido, pero no te preocupes.",
          TextMapId = "voice_ch_char_Xier_vo_skill02_r02"
        },
        voice_ch_char_Xier_vo_skill02_r03 = {
          ContentES = "Trabajo terminado.",
          TextMapId = "voice_ch_char_Xier_vo_skill02_r03"
        },
        voice_ch_char_Xier_vo_topic_01_1 = {
          ContentES = "Efectivamente, la niebla persistente hace que la ropa nunca se seque y se adhiera al polvo omnipresente.",
          TextMapId = "voice_ch_char_Xier_vo_topic_01_1"
        },
        voice_ch_char_Xier_vo_topic_01_2 = {
          ContentES = "A veces, algunos invitados no deseados querían acercarse sigilosamente a la señorita Flora con malas intenciones.",
          TextMapId = "voice_ch_char_Xier_vo_topic_01_2"
        },
        voice_ch_char_Xier_vo_topic_01_3 = {
          ContentES = "Hum... Los días soleados favorecen el lavado, pero también facilitan que la señorita Flora y yo seamos detectadas. No tenemos un tiempo ideal, solo hay días menos problemáticos.",
          TextMapId = "voice_ch_char_Xier_vo_topic_01_3"
        },
        voice_ch_char_Xier_vo_topic_02_1 = {
          ContentES = "Es normal que una criada sepa defenderse, nada fuera de lo común.",
          TextMapId = "voice_ch_char_Xier_vo_topic_02_1"
        },
        voice_ch_char_Xier_vo_topic_02_2 = {
          ContentES = "Para mí, ya sean moscas o Filthoids, todo es simple suciedad que debe ser eliminada. Considero que mi habilidad en combate es simplemente otra forma de limpieza, solo que más emocionante.",
          TextMapId = "voice_ch_char_Xier_vo_topic_02_2"
        },
        voice_ch_char_Xier_vo_topic_03_1 = {
          ContentES = "¿Objetos peligrosos? A qué te refieres... ¿Puedes ser más específica? Por favor, no des rodeos.",
          TextMapId = "voice_ch_char_Xier_vo_topic_03_1"
        }
      }
    end
  },
  {
    MinKey = "voice_ch_char_Xier_vo_topic_03_2",
    MaxKey = "voice_ch_char_Zhiliu_vo_welcome",
    Loader = function()
      return {
        voice_ch_char_Xier_vo_topic_03_2 = {
          ContentES = "... Ah, sí, tengo cierta predilección por las armas de fuego. Entre todas las herramientas que una criada maneja, las encuentro las más satisfactorias de usar, e insuperables para limpiar ciertos \"desastres\".",
          TextMapId = "voice_ch_char_Xier_vo_topic_03_2"
        },
        voice_ch_char_Xier_vo_topic_03_3 = {
          ContentES = "Si sueles sentirte estresada, quizás te preste unas pocas. Un poco de \"rat-a-tat-tat\" podría resultarte bastante terapéutico.",
          TextMapId = "voice_ch_char_Xier_vo_topic_03_3"
        },
        voice_ch_char_Xier_vo_topic_04_1 = {
          ContentES = "Hm, tal vez. No pierdo el tiempo en cortesías con quienes no me importan.",
          TextMapId = "voice_ch_char_Xier_vo_topic_04_1"
        },
        voice_ch_char_Xier_vo_topic_04_2 = {
          ContentES = "Parece que lo malinterpretas. Eso se debe a que has pagado bien. Si tus fondos se agotan, mi entusiasmo podría decaer.",
          TextMapId = "voice_ch_char_Xier_vo_topic_04_2"
        },
        voice_ch_char_Xier_vo_topic_04_3 = {
          ContentES = "No te preocupes, confía en mí, no dejaré que eso ocurra.",
          TextMapId = "voice_ch_char_Xier_vo_topic_04_3"
        },
        voice_ch_char_Xier_vo_topic_05_1 = {
          ContentES = "¿Eh? ¿D-dónde? Según su calendario, no debería estar aquí hoy...",
          TextMapId = "voice_ch_char_Xier_vo_topic_05_1"
        },
        voice_ch_char_Xier_vo_topic_05_2 = {
          ContentES = "Me has engañado.",
          TextMapId = "voice_ch_char_Xier_vo_topic_05_2"
        },
        voice_ch_char_Xier_vo_topic_05_3 = {
          ContentES = "En absoluto. La Señorita Flora lo es todo para mí. Quizás sea atrevido de mi parte, pero ella es mucho más que mi honorable señora...",
          TextMapId = "voice_ch_char_Xier_vo_topic_05_3"
        },
        voice_ch_char_Xier_vo_topic_05_4 = {
          ContentES = "Lamentablemente, no soy un Bardo Errante, no podría encontrar una palabra perfecta para describirla, una que combine los significados de amiga y familiar.",
          TextMapId = "voice_ch_char_Xier_vo_topic_05_4"
        },
        voice_ch_char_Xier_vo_topic_05_5 = {
          ContentES = "Prefiero guardar tales sentimientos para mí, despejar el camino para la Señorita Flora es tanto mi deber como mi privilegio.",
          TextMapId = "voice_ch_char_Xier_vo_topic_05_5"
        },
        voice_ch_char_Xier_vo_victory_r01 = {
          ContentES = "¡Por fin, limpieza completada! Uf, ahora voy a lavar la ropa.",
          TextMapId = "voice_ch_char_Xier_vo_victory_r01"
        },
        voice_ch_char_Xier_vo_victory_r02 = {
          ContentES = "¡Por fin, limpieza completada! Uf, ahora voy a preparar la comida.",
          TextMapId = "voice_ch_char_Xier_vo_victory_r02"
        },
        voice_ch_char_Xier_vo_victory_r03 = {
          ContentES = "¡Por fin, limpieza completada! Uf, ahora voy a regar las flores.",
          TextMapId = "voice_ch_char_Xier_vo_victory_r03"
        },
        voice_ch_char_Xier_vo_victory_r04 = {
          ContentES = "¡Por fin, limpieza completada! Uf, ahora voy a coser un vestido nuevo para Señorita Flora.",
          TextMapId = "voice_ch_char_Xier_vo_victory_r04"
        },
        voice_ch_char_Xier_vo_welcome = {
          ContentES = "Dígame, ¿en qué puedo serle útil hoy? ¿Le gustaría una refrescante taza de té de flores? ¿O quizás prefiere que me ocupe de alguno de sus fastidiosos enemigos?",
          TextMapId = "voice_ch_char_Xier_vo_welcome"
        },
        voice_ch_char_Yeer_vo_appear = {
          ContentES = "Yale: Oliver debería ser m-mucho m-mejor para l-luchar que yo...",
          TextMapId = "voice_ch_char_Yeer_vo_appear"
        },
        voice_ch_char_Yeer_vo_battleidle = {
          ContentES = "Oliver: ¡Oye, no te quedes ahí parado, b-busca algo para hacer volar por los aires!\nYale: ¡Shh! Tenemos que seguir el plan.",
          TextMapId = "voice_ch_char_Yeer_vo_battleidle"
        },
        voice_ch_char_Yeer_vo_battlestart_r01 = {
          ContentES = "Oliver: ¡Ah... Qué fresco es el aire!",
          TextMapId = "voice_ch_char_Yeer_vo_battlestart_r01"
        },
        voice_ch_char_Yeer_vo_battlestart_r02 = {
          ContentES = "Yale: El experimento está a punto de empezar, t-ten c-cuidado.",
          TextMapId = "voice_ch_char_Yeer_vo_battlestart_r02"
        },
        voice_ch_char_Yeer_vo_be_hit_heavy_r01 = {
          ContentES = "Oliver: ¡Ya verás!",
          TextMapId = "voice_ch_char_Yeer_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Yeer_vo_be_hit_heavy_r02 = {
          ContentES = "Yale: ¡N-no golpees!",
          TextMapId = "voice_ch_char_Yeer_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Yeer_vo_birthday = {
          ContentES = "Yale: ¡Feliz cumpleaños! Y-Yo... te había hecho un regalo. Era un nuevo modelo de \"Pequeño Bum\". Le dibujé una imagen de nosotros l-luchando codo con codo...\nYale: Pero cada vez que lo terminaba, Oliver lo borraba, y yo insistía en r-rehacerlo... una cosa llevó a la otra, y la b-bomba explotó... E-Eh, ¡hoy te haré otro!\nOliver: ¡Basta ya, Yale! ¿Esto es arte? ¡Parece que sean dos Filthoids medio muertos! ¡Deja que este genio dibuje un \"Maestro de las Bombas\" y le muestre a {nickname} qué es el verdadero arte!",
          TextMapId = "voice_ch_char_Yeer_vo_birthday"
        },
        voice_ch_char_Yeer_vo_companio_01 = {
          ContentES = "Yale: H-hola... Tu canto es realmente b-bonito.\nOliver: ¡Bah! Solo otra víctima.",
          TextMapId = "voice_ch_char_Yeer_vo_companio_01"
        },
        voice_ch_char_Yeer_vo_companio_02 = {
          ContentES = "Yale: ¿Filbert... es tu amiga? Yo también tengo un buen amigo. Es tan c-confiable como F-Filbert.\nOliver: Espera, ¿en serio?",
          TextMapId = "voice_ch_char_Yeer_vo_companio_02"
        },
        voice_ch_char_Yeer_vo_companio_03 = {
          ContentES = "Yale: Eh... por favor, no te enfades, todos mis experimentos con bombas c-cumplen con los estándares de s-seguridad...",
          TextMapId = "voice_ch_char_Yeer_vo_companio_03"
        },
        voice_ch_char_Yeer_vo_die_r01 = {
          ContentES = "Oliver: Yale... también puedes sentir el dolor...",
          TextMapId = "voice_ch_char_Yeer_vo_die_r01"
        },
        voice_ch_char_Yeer_vo_die_r02 = {
          ContentES = "Yale: Está bien, Oliver. Estoy aquí contigo...",
          TextMapId = "voice_ch_char_Yeer_vo_die_r02"
        },
        voice_ch_char_Yeer_vo_fail = {
          ContentES = "Oliver: ¡Bah!, la próxima vez no te escaparás.",
          TextMapId = "voice_ch_char_Yeer_vo_fail"
        },
        voice_ch_char_Yeer_vo_gain = {
          ContentES = "Yale: H-Hola... Soy Yale. T-Tú vienes también por un... ¡P-P-Pequeño Bum! ¿verdad...?\nOliver: Bah, ese tipo sigue tartamudeando, nada ha cambiado.",
          TextMapId = "voice_ch_char_Yeer_vo_gain"
        },
        voice_ch_char_Yeer_vo_idle = {
          ContentES = "Yale: T-Tres tristes tigres t-t-tragan trigo...\nOliver: ¡Es \"Tres tristes tigres tragan trigo en un trigal\"! ¡Vamos, Yale, sigue el ritmo!\nYale: ¡E-Está bien! T-Tres tristes tigres...",
          TextMapId = "voice_ch_char_Yeer_vo_idle"
        },
        voice_ch_char_Yeer_vo_lvup = {
          ContentES = "Yale: ¡Genial! Oliver, nos hemos fortalecido juntos.",
          TextMapId = "voice_ch_char_Yeer_vo_lvup"
        },
        voice_ch_char_Yeer_vo_revive = {
          ContentES = "Oliver: ¡Es hora de ajustar cuentas!",
          TextMapId = "voice_ch_char_Yeer_vo_revive"
        },
        voice_ch_char_Yeer_vo_skill01_r01 = {
          ContentES = "Oliver: ¡BUUUM!",
          TextMapId = "voice_ch_char_Yeer_vo_skill01_r01"
        },
        voice_ch_char_Yeer_vo_skill01_r02 = {
          ContentES = "¡Vamos, \"Pequeño Bum\"!",
          TextMapId = "voice_ch_char_Yeer_vo_skill01_r02"
        },
        voice_ch_char_Yeer_vo_skill02_r01 = {
          ContentES = "Oliver: ¡Ya era hora!",
          TextMapId = "voice_ch_char_Yeer_vo_skill02_r01"
        },
        voice_ch_char_Yeer_vo_skill02_r02 = {
          ContentES = "Oliver: ¡Miren la obra maestra de este genio!",
          TextMapId = "voice_ch_char_Yeer_vo_skill02_r02"
        },
        voice_ch_char_Yeer_vo_skill02_r03 = {
          ContentES = "Oliver: ¡Cúbrete los oídos! ¡BUUUM!",
          TextMapId = "voice_ch_char_Yeer_vo_skill02_r03"
        },
        voice_ch_char_Yeer_vo_topic_01_1 = {
          ContentES = "Yale: Oliver no es una bomba que habla... Puede sonar raro, pero... en realidad...",
          TextMapId = "voice_ch_char_Yeer_vo_topic_01_1"
        },
        voice_ch_char_Yeer_vo_topic_01_2 = {
          ContentES = "Oliver: ¡Cállate, me estás cabreando! Soy Yale, y Yale soy yo. ¿Lo entiendes? No importa aunque no lo entiendes. No creo que alguien con tu pequeño cerebro pueda entenderlo.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_01_2"
        },
        voice_ch_char_Yeer_vo_topic_01_3 = {
          ContentES = "Yale: ¡Oliver a-a-actualmente es un buen chico! Puede parecer un poco rudo y grosero, y le gusta aparecer de repente, pero...",
          TextMapId = "voice_ch_char_Yeer_vo_topic_01_3"
        },
        voice_ch_char_Yeer_vo_topic_01_4 = {
          ContentES = "Oliver: ¡Oye! ¿Esas son las palabras elogiosas?",
          TextMapId = "voice_ch_char_Yeer_vo_topic_01_4"
        },
        voice_ch_char_Yeer_vo_topic_02_1 = {
          ContentES = "Yale: Yo... probablemente no pueda ser de mucha ayuda. Lo único en lo que soy bueno... posiblemente es en hacer \"Pequeño Bum\"...",
          TextMapId = "voice_ch_char_Yeer_vo_topic_02_1"
        },
        voice_ch_char_Yeer_vo_topic_02_2 = {
          ContentES = "Yale: \"Pequeño Bum\"... es un artículo más popular... en la juguetería \"Crac y Chis\". Se requiere mucho tiempo para hacerlo.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_02_2"
        },
        voice_ch_char_Yeer_vo_topic_02_3 = {
          ContentES = "Yale: Pero no es por mi buena habilidad... Todo se lo debo a la experiencia de Oliver.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_02_3"
        },
        voice_ch_char_Yeer_vo_topic_03_1 = {
          ContentES = "Yale: ¡Ah, lo siento! P-pero si hablo rápido, me enredo con las palabras.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_03_1"
        },
        voice_ch_char_Yeer_vo_topic_03_2 = {
          ContentES = "Yale: N-No pasa nada, a veces Oliver habla por mí... Y cuando no hay nadie más, Oliver siempre me escucha.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_03_2"
        },
        voice_ch_char_Yeer_vo_topic_04_1 = {
          ContentES = "Yale: Yo nunca tuve una \"infancia\"... Desde mis primeros recuerdos, he estado en este cuerpo. Oliver sí podría haber tenido una.",
          TextMapId = "voice_ch_char_Yeer_vo_topic_04_1"
        },
        voice_ch_char_Yeer_vo_topic_04_2 = {
          ContentES = "Yale: A veces me pregunto cómo sería tener una \"infancia\"... ¿El Señor Jones me habría contado un cuento antes de dormir todas las noches, como un padre normal?",
          TextMapId = "voice_ch_char_Yeer_vo_topic_04_2"
        },
        voice_ch_char_Yeer_vo_topic_04_3 = {
          ContentES = "Oliver: ¿Esperas que ese imbécil te cuente cuentos antes de dormir? ¿Has perdido la cabeza?",
          TextMapId = "voice_ch_char_Yeer_vo_topic_04_3"
        },
        voice_ch_char_Yeer_vo_topic_04_4 = {
          ContentES = "Yale: ¡L-Lo siento! S-Sé que a él solo le importaban sus experimentos... No lo habría hecho...",
          TextMapId = "voice_ch_char_Yeer_vo_topic_04_4"
        },
        voice_ch_char_Yeer_vo_victory = {
          ContentES = "Oliver: ¿Os gusta mi magnífica obra maestra?",
          TextMapId = "voice_ch_char_Yeer_vo_victory"
        },
        voice_ch_char_Yeer_vo_welcome = {
          ContentES = "Yale: Hola... ¡Qué buen día!... Es perfecto para hacer experimentos explosivos... Mmm, ¡qué buen día!",
          TextMapId = "voice_ch_char_Yeer_vo_welcome"
        },
        voice_ch_char_Yuming_vo_appear = {
          ContentES = "Es un honor para mí.",
          TextMapId = "voice_ch_char_Yuming_vo_appear"
        },
        voice_ch_char_Yuming_vo_battleidle = {
          ContentES = "Nunca dudes.",
          TextMapId = "voice_ch_char_Yuming_vo_battleidle"
        },
        voice_ch_char_Yuming_vo_battlestart = {
          ContentES = "Yo me encargaré del trabajo sucio.",
          TextMapId = "voice_ch_char_Yuming_vo_battlestart"
        },
        voice_ch_char_Yuming_vo_be_hit_heavy_r01 = {
          ContentES = "¿Eso es todo lo que puedes?",
          TextMapId = "voice_ch_char_Yuming_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Yuming_vo_be_hit_r01 = {
          ContentES = "¡Eh!",
          TextMapId = "voice_ch_char_Yuming_vo_be_hit_r01"
        },
        voice_ch_char_Yuming_vo_be_hit_r02 = {
          ContentES = "¡Ay!",
          TextMapId = "voice_ch_char_Yuming_vo_be_hit_r02"
        },
        voice_ch_char_Yuming_vo_birthday = {
          ContentES = "¿Cumpleaños? Yo casi nunca prestaba atención a esas cosas. Mi lealtad a los «Nueve Capítulos de Dafeng» me hace que la vida y la muerte sean meras notas a pie de página... Aun así, un deseo amable quizás pueda traer una sonrisa. ... Feliz cumpleaños.",
          TextMapId = "voice_ch_char_Yuming_vo_birthday"
        },
        voice_ch_char_Yuming_vo_companio_01 = {
          ContentES = "Desconozco la historia que has abandonado, pero nuestros aromas son similares. Mantén tu distancia: no hallo consuelo en mi propia especie.",
          TextMapId = "voice_ch_char_Yuming_vo_companio_01"
        },
        voice_ch_char_Yuming_vo_companio_02 = {
          ContentES = "Ya no somos camaradas de antaño. Como el viento fugaz, la gente pasa. Es mejor dejar atrás el ayer.",
          TextMapId = "voice_ch_char_Yuming_vo_companio_02"
        },
        voice_ch_char_Yuming_vo_companio_03 = {
          ContentES = "Tu determinación y tu respeto por la ley merecen mi respeto. ¿Alguna vez la duda nubla tu certeza?",
          TextMapId = "voice_ch_char_Yuming_vo_companio_03"
        },
        voice_ch_char_Yuming_vo_die_r01 = {
          ContentES = "Lo siento... tuviste que ver esto...",
          TextMapId = "voice_ch_char_Yuming_vo_die_r01"
        },
        voice_ch_char_Yuming_vo_die_r02 = {
          ContentES = "¿Podré... deshacerme de mis cadenas...?",
          TextMapId = "voice_ch_char_Yuming_vo_die_r02"
        },
        voice_ch_char_Yuming_vo_fail = {
          ContentES = "Otra marca de deshonra...",
          TextMapId = "voice_ch_char_Yuming_vo_fail"
        },
        voice_ch_char_Yuming_vo_gain = {
          ContentES = "¿Me pides ayuda como un amigo? ¿O me ves solo como un arma que puedes blandir a tu antojo?",
          TextMapId = "voice_ch_char_Yuming_vo_gain"
        },
        voice_ch_char_Yuming_vo_idle = {
          ContentES = "Un día tranquilo es un día bueno.",
          TextMapId = "voice_ch_char_Yuming_vo_idle"
        },
        voice_ch_char_Yuming_vo_lvup = {
          ContentES = "Las estaciones pueden cambiar, pero el conflicto siempre perdura.",
          TextMapId = "voice_ch_char_Yuming_vo_lvup"
        },
        voice_ch_char_Yuming_vo_revive = {
          ContentES = "¿Acaso las cadenas persiguen incluso a quienes encontraron refugio en la muerte?",
          TextMapId = "voice_ch_char_Yuming_vo_revive"
        },
        voice_ch_char_Yuming_vo_skill01_r01 = {
          ContentES = "Destruir.",
          TextMapId = "voice_ch_char_Yuming_vo_skill01_r01"
        },
        voice_ch_char_Yuming_vo_skill01_r02 = {
          ContentES = "Ataque estelar.",
          TextMapId = "voice_ch_char_Yuming_vo_skill01_r02"
        },
        voice_ch_char_Yuming_vo_skill02_r01 = {
          ContentES = "¡El juicio cae!",
          TextMapId = "voice_ch_char_Yuming_vo_skill02_r01"
        },
        voice_ch_char_Yuming_vo_skill02_r02 = {
          ContentES = "Xuanjiao, ¡rompe el frente!",
          TextMapId = "voice_ch_char_Yuming_vo_skill02_r02"
        },
        voice_ch_char_Yuming_vo_skill02_r03 = {
          ContentES = "Alma al acero.",
          TextMapId = "voice_ch_char_Yuming_vo_skill02_r03"
        },
        voice_ch_char_Yuming_vo_topic_01_1 = {
          ContentES = "... Ve a leer un tomo o busca otra compañía para tales discursos triviales. Quizás los Tejestrellas que venden sus artesanías puedan satisfacer tu curiosidad.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_01_1"
        },
        voice_ch_char_Yuming_vo_topic_01_2 = {
          ContentES = "A menudo estoy absorto en mis pensamientos, por eso mi perspectiva suele ser bastante subjetiva. Si realmente sientes curiosidad, una visita a ese lugar te resultará mucho más reveladora que cualquier relato de segunda mano.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_01_2"
        },
        voice_ch_char_Yuming_vo_topic_02_1 = {
          ContentES = "Los «Nueve Capítulos de Dafeng» son las leyes sagradas de Huaxu, no admiten ninguna desobediencia. Si alguien se atreve a desafiar el decreto divino, nos toca a algunos sofocar la consiguiente agitación.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_02_1"
        },
        voice_ch_char_Yuming_vo_topic_02_2 = {
          ContentES = "... Quizás, solo un título. Rara vez me relaciono con la gente común. Mi presencia, por muy necesaria que sea para hacer cumplir la ley, a menudo trae consigo desgracias. Pocos en Huaxu me recibirían con alegría.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_02_2"
        },
        voice_ch_char_Yuming_vo_topic_03_1 = {
          ContentES = "No hay nada que celebrar. Esa es toda la cuestión.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_03_1"
        },
        voice_ch_char_Yuming_vo_topic_03_2 = {
          ContentES = "Agradezco tu preocupación, sin embargo, no quiero cargar a otra alma con mis molestias. Es innecesario.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_03_2"
        },
        voice_ch_char_Yuming_vo_topic_04_1 = {
          ContentES = "En efecto. La luna, una maravilla celestial, purifica los restos del día, sea una festividad o un acto vil. A lo largo de los tiempos, la luna creciente simplemente observa desde su encumbrada posición.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_04_1"
        },
        voice_ch_char_Yuming_vo_topic_04_2 = {
          ContentES = "No, soy uno que le ha dicho adiós al pasado. Esta noche, simplemente me he permitido medio vaso más de vino.",
          TextMapId = "voice_ch_char_Yuming_vo_topic_04_2"
        },
        voice_ch_char_Yuming_vo_victory = {
          ContentES = "Nunca subestimes a tu enemigo.",
          TextMapId = "voice_ch_char_Yuming_vo_victory"
        },
        voice_ch_char_Yuming_vo_welcome = {
          ContentES = "Haz lo que quieras. Aprecia tu libertad antes de que las cadenas de la ley te aten.",
          TextMapId = "voice_ch_char_Yuming_vo_welcome"
        },
        voice_ch_char_Zhangyu_vo_appear = {
          ContentES = "¿Adónde vamos a tener una aventura hoy?",
          TextMapId = "voice_ch_char_Zhangyu_vo_appear"
        },
        voice_ch_char_Zhangyu_vo_battleidle = {
          ContentES = "*Bosteza* ¡Estoy aburridísima!",
          TextMapId = "voice_ch_char_Zhangyu_vo_battleidle"
        },
        voice_ch_char_Zhangyu_vo_battlestart = {
          ContentES = "¡Ta-dah! ¡El Demonio Tabethe, la Mano Roja ha llegado!",
          TextMapId = "voice_ch_char_Zhangyu_vo_battlestart"
        },
        voice_ch_char_Zhangyu_vo_be_hit_heavy_r01 = {
          ContentES = "¡Estoy muy enfadada!",
          TextMapId = "voice_ch_char_Zhangyu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Zhangyu_vo_be_hit_heavy_r02 = {
          ContentES = "¿Cómo te atreves?",
          TextMapId = "voice_ch_char_Zhangyu_vo_be_hit_heavy_r02"
        },
        voice_ch_char_Zhangyu_vo_be_hit_r01 = {
          ContentES = "¡Ah!",
          TextMapId = "voice_ch_char_Zhangyu_vo_be_hit_r01"
        },
        voice_ch_char_Zhangyu_vo_be_hit_r02 = {
          ContentES = "¡Eh!",
          TextMapId = "voice_ch_char_Zhangyu_vo_be_hit_r02"
        },
        voice_ch_char_Zhangyu_vo_birthday = {
          ContentES = "¡Nunca he celebrado mi cumpleaños! ¡Es que es tan difícil tener suficiente para comer! Bueno... les deseo que nunca tengan que pasar hambre ni que se vean obligados a robar para sobrevivir.",
          TextMapId = "voice_ch_char_Zhangyu_vo_birthday"
        },
        voice_ch_char_Zhangyu_vo_companio_01 = {
          ContentES = "¿Quieres atraparme? ¿Por qué? ¡No soy mala! Solo robo a otros ladrones. ¡No es para tanto!... ¡Oye, aléjate! ¡Ay! ¡Eso me quemó!",
          TextMapId = "voice_ch_char_Zhangyu_vo_companio_01"
        },
        voice_ch_char_Zhangyu_vo_companio_02 = {
          ContentES = "¿Esto es para mí? Mmm, pero pareces muy peligroso, así que será mejor que te lo quedes. Espera... este aroma me está mareando... Siento que mis tentáculos se están entumeciendo... ¡De verdad que eres peligroso!",
          TextMapId = "voice_ch_char_Zhangyu_vo_companio_02"
        },
        voice_ch_char_Zhangyu_vo_companio_03 = {
          ContentES = "¡Me encanta la forma en que le hablas a tu espada! \"Samael, ¿te gusta este lugar? ¡Exploremos más sitios juntos!\"\n¡Oye! ¿Qué te pasa? ¿Por qué te alteras tanto? Jaja, ¡eres muy gracioso!",
          TextMapId = "voice_ch_char_Zhangyu_vo_companio_03"
        },
        voice_ch_char_Zhangyu_vo_die_r01 = {
          ContentES = "¡El Demonio Tabethe, la Mano Roja, nunca pierde!",
          TextMapId = "voice_ch_char_Zhangyu_vo_die_r01"
        },
        voice_ch_char_Zhangyu_vo_die_r02 = {
          ContentES = "Esto... no debería ser el final de mi juego...",
          TextMapId = "voice_ch_char_Zhangyu_vo_die_r02"
        },
        voice_ch_char_Zhangyu_vo_fail = {
          ContentES = "¡Sois peores que esos ladrones! *Solloza*",
          TextMapId = "voice_ch_char_Zhangyu_vo_fail"
        },
        voice_ch_char_Zhangyu_vo_gain = {
          ContentES = "¡Jiji, qué buena colección tienes! Me has intrigado un poco... Pero no te preocupes, el Demonio Tabethe, la Mano Roja, nunca roba a la gente honesta. ¿O quizás estás en la lista de los malos?",
          TextMapId = "voice_ch_char_Zhangyu_vo_gain"
        },
        voice_ch_char_Zhangyu_vo_idle = {
          ContentES = "¡Oye! ¡Déjame pelear contigo! Estoy aburridísima y mis tentáculos necesitan estirarse.",
          TextMapId = "voice_ch_char_Zhangyu_vo_idle"
        },
        voice_ch_char_Zhangyu_vo_lvup = {
          ContentES = "Jiji, la próxima vez que me disfrace de barril, ¡no podrás reconocerme en absoluto!",
          TextMapId = "voice_ch_char_Zhangyu_vo_lvup"
        },
        voice_ch_char_Zhangyu_vo_revive = {
          ContentES = "¡Este no fue mi final! ¡Lo sabía!",
          TextMapId = "voice_ch_char_Zhangyu_vo_revive"
        },
        voice_ch_char_Zhangyu_vo_skill01_r01 = {
          ContentES = "¡Qué divertido!",
          TextMapId = "voice_ch_char_Zhangyu_vo_skill01_r01"
        },
        voice_ch_char_Zhangyu_vo_skill01_r02 = {
          ContentES = "¡Toma esto!",
          TextMapId = "voice_ch_char_Zhangyu_vo_skill01_r02"
        },
        voice_ch_char_Zhangyu_vo_skill02_r01 = {
          ContentES = "¡Ay! Eso dolió... Jiji, ¡Mentira!",
          TextMapId = "voice_ch_char_Zhangyu_vo_skill02_r01"
        },
        voice_ch_char_Zhangyu_vo_skill02_r02 = {
          ContentES = "¡Vamos a jugar juntos!",
          TextMapId = "voice_ch_char_Zhangyu_vo_skill02_r02"
        },
        voice_ch_char_Zhangyu_vo_skill02_r03 = {
          ContentES = "¡Ahí viene el Demonio Tabethe, la Mano Roja!",
          TextMapId = "voice_ch_char_Zhangyu_vo_skill02_r03"
        },
        voice_ch_char_Zhangyu_vo_topic_01_1 = {
          ContentES = "Berry, yo...",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_01_1"
        },
        voice_ch_char_Zhangyu_vo_topic_01_2 = {
          ContentES = "Tu sonrisa por cada mañana ya es el mejor ánimo para mí. A partir de ahora, siempre estaré aquí para protegerte. Jeje, bastante convincente, ¿no?",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_01_2"
        },
        voice_ch_char_Zhangyu_vo_topic_01_3 = {
          ContentES = "¿Estás {性别:enfadadol|enfadada}? Jiji, ¡tus ceños fruncidos me dan aún más ganas de imitarte!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_01_3"
        },
        voice_ch_char_Zhangyu_vo_topic_02_1 = {
          ContentES = "¡Es fácil! ¡Es que puedo cambiar mi aspecto como quiera! Jiji, puedo adoptar cualquier forma o color y camuflarme perfectamente en cualquier sitio. ¡Nadie me detecta!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_02_1"
        },
        voice_ch_char_Zhangyu_vo_topic_02_2 = {
          ContentES = "Una vez, incluso me convertí en un barril solo esperando para asustarte, pero no te acercaste...",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_02_2"
        },
        voice_ch_char_Zhangyu_vo_topic_02_3 = {
          ContentES = "¡¿Qué?! Espera, ¡por eso sabías que era yo y te fuiste sin más! ¡Eres tan pícara!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_02_3"
        },
        voice_ch_char_Zhangyu_vo_topic_03_1 = {
          ContentES = "¡Oye! ¡No me metas en el mismo saco que esos malvados que roban a cualquiera! ¡No soy como ellos!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_03_1"
        },
        voice_ch_char_Zhangyu_vo_topic_03_2 = {
          ContentES = "Yo solo robo a los ladrones. Me camuflo, me acerco sigilosamente y les quito mis tesoros favoritos ¡directo de sus bolsillos!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_03_2"
        },
        voice_ch_char_Zhangyu_vo_topic_03_3 = {
          ContentES = "Cuando se dan cuenta, ¡sus caras son geniales! Jiji... ¡Si acaso, soy más bien una justiciera!",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_03_3"
        },
        voice_ch_char_Zhangyu_vo_topic_04_1 = {
          ContentES = "¡Claro que no! A ti tampoco te gustaría que te llamaran \"demonio\" con cara de asco y ceño fruncido.",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_04_1"
        },
        voice_ch_char_Zhangyu_vo_topic_04_2 = {
          ContentES = "Es porque quiero que la palabra \"demonio\" se vuelva genial. Ahora, solo con mencionar mi título \"Demonio Tabethe, la Mano Roja\", a los ladrones les da escalofríos.",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_04_2"
        },
        voice_ch_char_Zhangyu_vo_topic_04_3 = {
          ContentES = "Algún día, la palabra \"demonio\" solo hará que la gente piense lo genial que soy. ¡Qué gran sueño es! ¿Verdad?",
          TextMapId = "voice_ch_char_Zhangyu_vo_topic_04_3"
        },
        voice_ch_char_Zhangyu_vo_victory = {
          ContentES = "¡Idiotas! No me tocaron ni un pelo. ¡Jajaja!",
          TextMapId = "voice_ch_char_Zhangyu_vo_victory"
        },
        voice_ch_char_Zhangyu_vo_welcome = {
          ContentES = "Hum... ahora es el momento perfecto. Debería irme antes de... ¡Eh! ¡Cuándo llegaste!",
          TextMapId = "voice_ch_char_Zhangyu_vo_welcome"
        },
        voice_ch_char_Zhiliu_vo_appear = {
          ContentES = "¿Necesitas ayuda? Jeje, me encantaría ayudarte.",
          TextMapId = "voice_ch_char_Zhiliu_vo_appear"
        },
        voice_ch_char_Zhiliu_vo_battleidle = {
          ContentES = "El tiempo es valioso, al igual que mi tarifa por el servicio.",
          TextMapId = "voice_ch_char_Zhiliu_vo_battleidle"
        },
        voice_ch_char_Zhiliu_vo_battlestart = {
          ContentES = "Terminemos rápido.",
          TextMapId = "voice_ch_char_Zhiliu_vo_battlestart"
        },
        voice_ch_char_Zhiliu_vo_be_hit_heavy_r01 = {
          ContentES = "Eh... es hora de pagar.",
          TextMapId = "voice_ch_char_Zhiliu_vo_be_hit_heavy_r01"
        },
        voice_ch_char_Zhiliu_vo_birthday = {
          ContentES = "Hoy es tu cumpleaños. He preparado un pequeño regalo para ti, puedes abrirlo más tarde.\n¿Te sorpresa? Digamos que moví algunos hilos para conseguir tu perfil. Los datos, por supuesto, se me quedaron grabados en la memoria.\nMuchos han cambiado con el tiempo, pero mi deseo de tu bienestar y felicidad sigue siendo el mismo. Pero si no te molesta que te lo diga... ¡Feliz cumpleaños!",
          TextMapId = "voice_ch_char_Zhiliu_vo_birthday"
        },
        voice_ch_char_Zhiliu_vo_companio_01 = {
          ContentES = "Su perfume tiene una dulzura audaz y embriagadora, sin reservas ni disculpas. Contrasta enormemente con las fragancias sutiles de Huaxu. Me interesa mucho.",
          TextMapId = "voice_ch_char_Zhiliu_vo_companio_01"
        },
        voice_ch_char_Zhiliu_vo_companio_02_1 = {
          ContentES = "El engaño puede servir en la guerra, pero en las relaciones humanas es un método poco útil. Depender demasiado de una misma táctica solo perjudica la reputación en los negocios.",
          TextMapId = "voice_ch_char_Zhiliu_vo_companio_02_1"
        },
        voice_ch_char_Zhiliu_vo_companio_02_2 = {
          ContentES = "Pero, por supuesto, tienes tu propio estilo. Supongo que mis palabras caen en los oídos sordos.",
          TextMapId = "voice_ch_char_Zhiliu_vo_companio_02_2"
        },
        voice_ch_char_Zhiliu_vo_companio_03 = {
          ContentES = "He visto una sombra de alguien a quien conocí.. No, debo estar equivocado. No me haga caso.",
          TextMapId = "voice_ch_char_Zhiliu_vo_companio_03"
        },
        voice_ch_char_Zhiliu_vo_companio_04 = {
          ContentES = "Ha pasado un largo tiempo desde que probé una bebida preparada por ti. Si hoy tienes tiempo, ¿podrías prepararme otro vaso de esa deliciosa bebida de la tarde?",
          TextMapId = "voice_ch_char_Zhiliu_vo_companio_04"
        },
        voice_ch_char_Zhiliu_vo_die_r01 = {
          ContentES = "Nunca pensé... que algún día me equivocaría...",
          TextMapId = "voice_ch_char_Zhiliu_vo_die_r01"
        },
        voice_ch_char_Zhiliu_vo_die_r02 = {
          ContentES = "Al final, no pude escapar de ello...",
          TextMapId = "voice_ch_char_Zhiliu_vo_die_r02"
        },
        voice_ch_char_Zhiliu_vo_fail = {
          ContentES = "No dejes que la desesperación nuble tu juicio. Reconsidera e inténtalo de nuevo.",
          TextMapId = "voice_ch_char_Zhiliu_vo_fail"
        },
        voice_ch_char_Zhiliu_vo_gain = {
          ContentES = "La mayoría de las cosas en este mundo son ilusiones; ¿acaso te importa si es sinceridad o cálculo? Al final, lo más importante es que estoy aquí, frente a ti.",
          TextMapId = "voice_ch_char_Zhiliu_vo_gain"
        },
        voice_ch_char_Zhiliu_vo_idle = {
          ContentES = "Le pedí a mi secretaria que me liberara la agenda para los próximos días. Por ahora, solo deseo disfrutar de esta tranquilidad a tu lado, lejos del bullicio del mundo. ¿Es sinceridad u otra estrategia? ¿Qué opinas?",
          TextMapId = "voice_ch_char_Zhiliu_vo_idle"
        },
        voice_ch_char_Zhiliu_vo_lvup = {
          ContentES = "Como era de esperar, todo va según lo previsto.",
          TextMapId = "voice_ch_char_Zhiliu_vo_lvup"
        },
        voice_ch_char_Zhiliu_vo_revive = {
          ContentES = "¿Creíste que todo había terminado? ¡Qué grave error!",
          TextMapId = "voice_ch_char_Zhiliu_vo_revive"
        },
        voice_ch_char_Zhiliu_vo_skill01_r01 = {
          ContentES = "Hexagrama, despliega tu poder.",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill01_r01"
        },
        voice_ch_char_Zhiliu_vo_skill01_r02 = {
          ContentES = "Presta atención a los designios del destino.",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill01_r02"
        },
        voice_ch_char_Zhiliu_vo_skill02_r01 = {
          ContentES = "El camino de la fortuna se enciende.",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill02_r01"
        },
        voice_ch_char_Zhiliu_vo_skill02_r02 = {
          ContentES = "La tormenta de la estrategia se intensificará.",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill02_r02"
        },
        voice_ch_char_Zhiliu_vo_skill02_r03 = {
          ContentES = "¡Resistir es inútil!",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill02_r03"
        },
        voice_ch_char_Zhiliu_vo_skill02_sp = {
          ContentES = "Adelante, aniquílalos a todos.",
          TextMapId = "voice_ch_char_Zhiliu_vo_skill02_sp"
        },
        voice_ch_char_Zhiliu_vo_topic_01_1 = {
          ContentES = "Nada es ajeno a una negociación. La única pregunta es: ¿qué precio hará que la balanza se incline a tu favor?",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_01_1"
        },
        voice_ch_char_Zhiliu_vo_topic_01_2 = {
          ContentES = "Efectivamente. Tu vida, la mía y la de las incontables personas más: cada una es solo una pieza en un tablero mayor, cuyo valor depende únicamente de lo que esté en juego.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_01_2"
        },
        voice_ch_char_Zhiliu_vo_topic_01_3 = {
          ContentES = "Para quienes somos tan insignificantes, intercambiar lo poco que tenemos por lo que deseamos, también es una gran fortuna.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_01_3"
        },
        voice_ch_char_Zhiliu_vo_topic_01_4 = {
          ContentES = "¿Mi respuesta te incomoda? Entonces, por favor, demuéstrame que me equivoco.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_01_4"
        },
        voice_ch_char_Zhiliu_vo_topic_02_1 = {
          ContentES = "Humm... Nunca te centres solo en las ganancias y pérdidas momentáneas. Piensa a largo plazo. Sé generoso cuando sea necesario. Aprende a comprender a las personas, a usarlas y a hacerles favores, para que te respeten, te admiren y también te teman.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_02_1"
        },
        voice_ch_char_Zhiliu_vo_topic_02_2 = {
          ContentES = "Jeje. Los productos tienen precios fijos, pero las relaciones humanas son una moneda completamente diferente. Quienes regatean por cada moneda, permanecerán siempre atados a su pequeño rincón. Solo dominando el arte de la influencia, se puede elevar por encima del mero comercio y alcanzar hasta la verdadera grandeza.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_02_2"
        },
        voice_ch_char_Zhiliu_vo_topic_03_1 = {
          ContentES = "A menudo estoy metido en los detalles de los negocios, rara vez tengo tiempo libre. El tiempo libre es un lujo para mí.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_03_1"
        },
        voice_ch_char_Zhiliu_vo_topic_03_2 = {
          ContentES = "Sin embargo, si me concediera un breve respiro... probablemente buscaría consuelo en el teatro. Ya sean las antiguas tradiciones narrativas de Huaxu, las refinadas óperas del Imperio o las películas de vanguardia que triunfan en el extranjero, cada una me interesa.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_03_2"
        },
        voice_ch_char_Zhiliu_vo_topic_03_3 = {
          ContentES = "Jeje... Supongo que no. El teatro capta momentos fugaces de la vida, pero en esos momentos fugaces se revelan las profundas verdades sobre la naturaleza humana. La naturaleza humana es algo que desafía la lógica, prospera en la contradicción y resulta fascinante por su imprevisibilidad.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_03_3"
        },
        voice_ch_char_Zhiliu_vo_topic_03_4 = {
          ContentES = "¿Qué sorpresas inesperadas me traerás? Estaré atenta.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_03_4"
        },
        voice_ch_char_Zhiliu_vo_topic_04_1 = {
          ContentES = "¿Eh? ¿Lo has notado? Es un viejo hábito, nada más.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_04_1"
        },
        voice_ch_char_Zhiliu_vo_topic_04_2 = {
          ContentES = "De pequeña, un accidente me dejó atrapada en un barranco a oscuras durante tres días y tres noches. Ahí se originó este... malo hábito.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_04_2"
        },
        voice_ch_char_Zhiliu_vo_topic_04_3 = {
          ContentES = "En este mundo, todos tenemos nuestros miedos. Yo no soy la excepción... Parece {性别:sorprendido|sorprendida}. ¿Por qué?",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_04_3"
        },
        voice_ch_char_Zhiliu_vo_topic_04_4 = {
          ContentES = "Jeje... Tiene razón. Las debilidades pueden ser fatales para un comerciante.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_04_4"
        },
        voice_ch_char_Zhiliu_vo_topic_04_5 = {
          ContentES = "Me entrené rigurosamente para suprimir este defecto. En las negociaciones, puedo controlarlo fácilmente en todo momento. Pero en su presencia, no hay necesidad de fingir.",
          TextMapId = "voice_ch_char_Zhiliu_vo_topic_04_5"
        },
        voice_ch_char_Zhiliu_vo_victory = {
          ContentES = "Un asunto insignificante, apenas vale la pena mencionarlo.",
          TextMapId = "voice_ch_char_Zhiliu_vo_victory"
        },
        voice_ch_char_Zhiliu_vo_welcome = {
          ContentES = "Has venido a verme... {性别:¿Todavía estás enfadado? ¿Confundido?|¿Todavía estás enfadada? ¿Confundida?} ¿O sea, te has vuelto indiferente a mí? Da igual. Tenemos mucho tiempo para discutirlo.",
          TextMapId = "voice_ch_char_Zhiliu_vo_welcome"
        }
      }
    end
  }
}
local rawset = _ENV.rawset
local TextMap_ContentES = setmetatable({}, {
  __index = function(t, key)
    local Partition = DataMgr.GetPartitionData(key, Data)
    if Partition then
      for k, v in pairs(Partition) do
        if rawget(t, k) == nil then
          rawset(t, k, v)
        end
      end
      return Partition[key]
    else
      return nil
    end
  end,
  __pairs = function(t)
    for _, partDef in ipairs(Data) do
      local Partition = DataMgr.GetPartitionData(partDef.MinKey, Data)
      if Partition then
        for k, v in pairs(Partition) do
          if rawget(t, k) == nil then
            rawset(t, k, v)
          end
        end
      end
    end
    return next, t, nil
  end
})
return TextMap_ContentES
