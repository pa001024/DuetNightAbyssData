local ReadOnly = (DataMgr or {}).ReadOnly or function(n, x)
  return x
end
return ReadOnly("ServerEffect", {
  [1] = {
    Id = 1,
    Name = "ForbidGetExp"
  }
})
