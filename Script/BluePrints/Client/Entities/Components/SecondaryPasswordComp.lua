local Component = {}

function Component:SecondaryPasswordSwitch(callback, switch, onlyvalidateonce, password)
  self:CallServer("OnSecondaryPasswordSwitch", callback, switch, onlyvalidateonce, password)
end

function Component:SecondaryPasswordFreeze(timestamp)
  print("SecondaryPasswordFreeze: " .. timestamp)
end

return Component
