local M = {}
local HandleName = "PreviewLevelHandoff"

function M.Show(WorldContext)
  local Manager = UIManager(WorldContext)
  if not Manager then
    return
  end
  Manager:ShowCommonBlackScreen({BlackScreenHandle = HandleName, OutAnimationPlayTime = 0.3})
end

function M.Hide(WorldContext)
  local Manager = UIManager(WorldContext)
  if not Manager then
    return
  end
  Manager:HideCommonBlackScreen(HandleName)
end

return M
