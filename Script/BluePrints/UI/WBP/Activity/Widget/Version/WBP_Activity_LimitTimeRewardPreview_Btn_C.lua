require("UnLua")
local EventVersionUtils = require("BluePrints.UI.WBP.Activity.EventVersionUtils")
local M = Class({
  "BluePrints.UI.BP_EMUserWidget_C"
})

function M:Construct()
  self._VersionNewReddotNodeNames = {}
  self:BindVersionPreviewNewReddot()
  self.Key_GamePad:CreateCommonKey({
    KeyInfoList = {
      {
        Type = "Img",
        ImgShortPath = UIConst.GamePadImgKey.DPadLeft
      }
    }
  })
end

function M:Destruct()
  self:UnbindVersionPreviewNewReddot()
end

function M:BindVersionPreviewNewReddot()
  self:UnbindVersionPreviewNewReddot()
  local gc = DataMgr.GlobalConstant and DataMgr.GlobalConstant.CurrentVersion
  self.CurrentVersion = gc and gc.ConstantValue
  local nodeNames = EventVersionUtils.GetVersionActivityReddotNodeNames(self.CurrentVersion)
  self._VersionNewReddotNodeNames = nodeNames
  for _, nodeName in ipairs(nodeNames) do
    ReddotManager.AddListenerEx(nodeName, self, function(widget, Count, RdType, RdName)
      widget:RefreshVersionNewReddot()
    end)
  end
  self:RefreshVersionNewReddot()
end

function M:UnbindVersionPreviewNewReddot()
  if not self._VersionNewReddotNodeNames then
    return
  end
  for _, nodeName in ipairs(self._VersionNewReddotNodeNames) do
    ReddotManager.RemoveListener(nodeName, self)
  end
  self._VersionNewReddotNodeNames = {}
end

function M:RefreshVersionNewReddot()
  if not self.New then
    return
  end
  local ver = self.CurrentVersion
  if nil == ver and DataMgr.GlobalConstant and DataMgr.GlobalConstant.CurrentVersion then
    ver = DataMgr.GlobalConstant.CurrentVersion.ConstantValue
  end
  local bShow = EventVersionUtils.VersionHasAnyEventNewReddot(ver)
  self.New:SetVisibility(bShow and UIConst.VisibilityOp.SelfHitTestInvisible or UIConst.VisibilityOp.Collapsed)
end

return M
