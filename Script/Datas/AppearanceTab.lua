local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("AppearanceTab", {
  [1] = {
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Fashion_Clothing.T_Tab_Fashion_Clothing'",
    TabId = 1,
    Text = "UI_Skin_Name"
  },
  [2] = {
    IconPath = "Texture2D'/Game/UI/Texture/Dynamic/Atlas/Tab/T_Tab_Accessory.T_Tab_Accessory'",
    TabId = 2,
    Text = "UI_Armory_Dress"
  }
})
