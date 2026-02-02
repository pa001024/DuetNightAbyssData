local HotFixDiff = {}

function HotFixDiff.DeepDiff(t1, t2, path, diffs, visited)
  diffs = diffs or {}
  path = path or ""
  visited = visited or {}
  if type(t1) ~= type(t2) then
    table.insert(diffs, {
      path = path,
      value1 = t1,
      value2 = t2,
      type = "type_mismatch"
    })
    return diffs
  end
  if type(t1) ~= "table" then
    if t1 ~= t2 then
      table.insert(diffs, {
        path = path,
        value1 = t1,
        value2 = t2,
        type = "value_mismatch"
      })
    end
    return diffs
  end
  for k, v1 in pairs(t1) do
    local currentPath = path .. ("" == path and "" or ".") .. tostring(k)
    if nil == t2[k] then
      table.insert(diffs, {
        path = currentPath,
        value1 = v1,
        value2 = nil,
        type = "missing_in_t2"
      })
    else
      HotFixDiff.DeepDiff(v1, t2[k], currentPath, diffs, visited)
    end
  end
  for k, v2 in pairs(t2) do
    local currentPath = path .. ("" == path and "" or ".") .. tostring(k)
    if nil == t1[k] then
      table.insert(diffs, {
        path = currentPath,
        value1 = nil,
        value2 = v2,
        type = "missing_in_t1"
      })
    end
  end
  return diffs
end

function HotFixDiff.PrettyPrintDiff(name, diffs, _print)
  _print = _print or print
  if 0 == #diffs then
    _print("name:" .. tostring(name) .. ",No differences found")
    return
  end
  local msg = "name:" .. tostring(name) .. ", diff\n"
  for _, diff in ipairs(diffs) do
    msg = msg .. string.format("%s.%s", name, diff.path)
    if diff.type == "type_mismatch" then
      msg = msg .. string.format(" | Type mismatch: Before:%s vs After:%s", type(diff.value1), type(diff.value2))
    elseif diff.type == "value_mismatch" then
      msg = msg .. string.format(" | Value mismatch: Before:%s vs After:%s", tostring(diff.value1), tostring(diff.value2))
    elseif diff.type == "missing_in_t2" then
      msg = msg .. string.format(" | Missing in After: %s", tostring(diff.value1))
    elseif diff.type == "missing_in_t1" then
      msg = msg .. string.format(" | Missing in Before: %s", tostring(diff.value2))
    end
    msg = msg .. "\n"
  end
  _print(msg)
end

function HotFixDiff.ShowDiff(name, t1, t2, _print)
  local diffs = HotFixDiff.DeepDiff(t1, t2)
  HotFixDiff.PrettyPrintDiff(name, diffs, _print)
end

return HotFixDiff
