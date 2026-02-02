require("UnLua")
local M = Class({
  "BluePrints.UI.BP_UIState_C"
})

function M:Construct()
  self.Btn_Dye.Button_Area.OnClicked:Add(self, self.OnDyeClicked)
end

function M:OnDyeClicked()
  local MountId = self.MountId
  if not MountId then
    local MountsMain = self.MountsMain
    if MountsMain then
      MountId = MountsMain:GetDisplayMountId()
    end
  end
  if not MountId then
    return
  end
  local Avatar = GWorld:GetAvatar()
  if not Avatar then
    return
  end
  local Mount = Avatar.Mounts[MountId]
  if not Mount then
    return
  end
  local CurrentSkin = Mount:GetAppearance()
  local SkinId = CurrentSkin and CurrentSkin.SkinId or MountId
  local Params = {
    Target = Mount,
    Type = CommonConst.ArmoryType.Mount,
    SkinId = SkinId,
    IsPreviewMode = false,
    Parent = self.MountsMain,
    OnCloseCallback = function()
    end
  }
  local UIConfig = DataMgr.SystemUI.ArmoryDye
  if UIConfig then
    UIManager(self):LoadUI(UIConst.LoadInConfig, UIConfig.UIName, 0, Params)
  end
end

return M
