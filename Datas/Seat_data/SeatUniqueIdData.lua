local function make_read_only(t)
  return setmetatable({}, {
    __index = t,
    
    __newindex = function()
      error("Attempt to modify read-only table")
    end
  })
end

return make_read_only({
  "1011",
  "1019",
  "1041",
  "9997",
  "RegionProfTest_Main",
  "SeatUniqueIdData"
})
