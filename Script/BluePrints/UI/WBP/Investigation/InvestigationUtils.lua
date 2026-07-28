local M = {}
M.EPanelState = {
  Loading = 1,
  Normal = 2,
  Completed = 3,
  Dialog = 4,
  Hidden = 5
}
M.CheckpointState = {
  Normal = "Normal",
  Aiming = "Aiming",
  Completed = "Completed"
}
return M
