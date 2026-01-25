require("UnLua")
local Common_Dialog_LuaModel_Base = setmetatable({}, {
  __index = function(t, k)
    local DialogWidget = rawget(t, "DialogWidget")
    local Result
    if DialogWidget then
      if DialogWidget[k] then
        Result = DialogWidget[k]
      end
      local ContentWidget = DialogWidget:GetContentWidgetByName(k)
      if ContentWidget then
        Result = ContentWidget
      end
      return Result
    end
  end,
  __newindex = function(t, k, v)
    local DialogWidget = rawget(t, "DialogWidget")
    if DialogWidget then
      DialogWidget[k] = v
    else
      rawset(t, k, v)
    end
  end
})

function Common_Dialog_LuaModel_Base:PackageData()
  return nil
end

function Common_Dialog_LuaModel_Base:BindDialogWidget(PopupId, DialogWidget)
  self.DialogWidget = DialogWidget
  self.PopupId = PopupId
end

function Common_Dialog_LuaModel_Base:Initialize()
  DebugPrint("Tianyi@ 弹窗 " .. tostring(self.PopupId) .. " 未定义初始化方法!")
end

return Common_Dialog_LuaModel_Base
