require("UnLua")
local Common_Dialog_LuaModel_ToArmory = Class("BluePrints.UI.UI_PC.Common.Common_Dialog.Common_Dialog_LuaModel.Common_Dialog_LuaModel_Base")

function Common_Dialog_LuaModel_ToArmory:Initialize()
  self.DialogWidget = UIManager(self):GetUIObj("CommonDialog")
  
  local function OpenArmoryFromPopup(Obj, Data, DialogWidget)
    DebugPrint("yklua OpenArmoryFromPopup")
    DialogWidget.ClickResult = true
  end
  
  local function OnDialogClosedCallback(Obj, Data, DialogWidget)
    DebugPrint("yklua OnDialogClosedCallback")
    if DialogWidget.ClickResult == true then
      PageJumpUtils:JumpToTargetPageByJumpId(52)
      local ArmoryMain = UIManager(self):GetUIObj("ArmoryMain")
      if ArmoryMain then
        UIManager(self):GetUIObj("ArmoryMain").OnCloseDelegate = {
          nil,
          function()
            UIUtils:OpenPopupToArmory()
          end,
          self
        }
      else
        DebugPrint("没有找到军械库界面，关闭界面后不会打开弹窗。")
      end
    end
  end
  
  if self.OnCloseCallbackFunction then
    local OriginFunc = self.OnCloseCallbackFunction
    
    local function NewFunc(Obj, Data, DialogWidget)
      OnDialogClosedCallback(Obj, Data, DialogWidget)
      OriginFunc(Obj, Data, DialogWidget)
    end
    
    self.DialogWidget.OnCloseCallbackFunction = NewFunc
  else
    self.OnCloseCallbackFunction = OnDialogClosedCallback
  end
  self.OnCloseCallbackObj = self
  self.RightBtnCallbackObj = self
  if self.DialogWidget.RightBtnClickedCallback then
    local OriginFunc = self.DialogWidget.RightBtnClickedCallback
    
    local function NewFunc(Obj, Data, DialogWidget)
      OpenArmoryFromPopup(Obj, Data, DialogWidget)
      OriginFunc(Obj, Data, DialogWidget)
      self.OriginFunc = nil
      self.RightBtnClickedCallback = nil
      self.DialogWidget.RightBtnClickedCallback = nil
    end
    
    self.DialogWidget.RightBtnClickedCallback = NewFunc
  else
    self.RightBtnClickedCallback = OpenArmoryFromPopup
  end
end

return Common_Dialog_LuaModel_ToArmory
