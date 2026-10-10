require("UnLua")
local ResourceRoleRenameCardFlow = {}
local RenameDialogId = 100133

local function SubmitRename(Avatar, ResourceId, Name, Callback)
  Avatar:UseChangeNameResourceInBag(ResourceId, Name, Callback)
end

function ResourceRoleRenameCardFlow.Open(Host, StuffConfigData, Extra)
  if not IsValid(Host) or not StuffConfigData then
    return
  end
  local Avatar = GWorld:GetAvatar()
  local ResourceId = tonumber(StuffConfigData.ResourceId)
  if not Avatar or not ResourceId then
    return
  end
  if Avatar:GetResourceNum(ResourceId) <= 0 then
    ErrorCode:Check(ErrorCode.RET_ITEM_NOT_ENOUGH)
    return
  end
  Extra = Extra or {}
  local State = {IsSubmitting = false, IsClosed = false}
  AudioManager(Host):PlayUISound(Host, "event:/ui/common/title_setting_panel_expand", "title_setting_panel_expand_sfx", nil)
  local Params = {
    ChangeName = true,
    FirstInit = true,
    UseReName = true,
    Title = GText("UI_COMMONPOP_TITLE_100054"),
    ResidentTipText = GText("UI_Char_RenameCardNoResetCd"),
    WaitChangeNameServerResult = true,
    ChangeNameSubmitCallbackFunction = function(InputWidget, Name)
      if State.IsClosed or State.IsSubmitting then
        return
      end
      State.IsSubmitting = true
      SubmitRename(Avatar, ResourceId, Name, function(ErrCode)
        State.IsSubmitting = false
        if State.IsClosed or not IsValid(InputWidget) then
          return
        end
        if ErrCode == ErrorCode.RET_SUCCESS then
          UIManager(InputWidget):ShowUITip("CommonToastMain", GText("UI_Change_Success"))
          local Dialog = InputWidget.Owner
          if IsValid(Dialog) then
            Dialog:OnClose()
          end
        else
          ErrorCode:Check(ErrCode)
        end
      end)
    end,
    CloseBtnCallbackObj = Host,
    CloseBtnCallbackFunction = function(CallbackHost)
      AudioManager(CallbackHost):SetEventSoundParam(CallbackHost, "title_setting_panel_expand_sfx", {ToEnd = 1})
    end,
    OnCloseCallbackFunction = function(...)
      State.IsClosed = true
      if Extra.OnClose then
        Extra.OnClose(...)
      end
    end
  }
  local CommonDialog = UIManager(Host):ShowCommonPopupUI(RenameDialogId, Params, Host)
  if CommonDialog then
    local CurrencyWidget = CommonDialog:GetContentWidgetByName("Dialog_Input_new")
    if CurrencyWidget then
      CurrencyWidget:SetResidentTips(GText("UI_Char_RenameCardNoResetCd"))
    end
  end
  return CommonDialog
end

return ResourceRoleRenameCardFlow
