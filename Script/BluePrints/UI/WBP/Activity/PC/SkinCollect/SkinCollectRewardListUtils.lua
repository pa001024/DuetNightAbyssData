local M = {}

function M.CalcTailOverflowScrollOffset(CurrentOffset, EndOffset, ViewportWidth, Overflow)
  CurrentOffset = tonumber(CurrentOffset) or 0
  EndOffset = tonumber(EndOffset) or CurrentOffset
  ViewportWidth = tonumber(ViewportWidth) or 0
  Overflow = tonumber(Overflow) or 0
  if EndOffset <= 0 or ViewportWidth <= 0 or Overflow <= 1.0 then
    return CurrentOffset, 0, 0
  end
  local pixelsPerOffset = ViewportWidth / EndOffset
  if pixelsPerOffset <= 0 then
    return CurrentOffset, 0, 0
  end
  local additionalOffset = Overflow / pixelsPerOffset
  local targetOffset = math.min(CurrentOffset + additionalOffset, EndOffset)
  return targetOffset, additionalOffset, pixelsPerOffset
end

return M
