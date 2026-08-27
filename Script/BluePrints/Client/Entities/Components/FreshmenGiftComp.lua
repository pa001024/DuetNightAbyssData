local Component = {}

function Component:FreshmenGiftGetReward(CharId, InCallback)
  self.logger.info("FreshmenGiftGetReward Send", CharId)
  
  local function Callback(Ret)
    self.logger.debug("FreshmenGiftGetReward Callback", Ret, CharId)
    if InCallback then
      InCallback(Ret, CharId)
    end
  end
  
  self:CallServer("FreshmenGiftGetReward", Callback, CharId)
end

return Component
