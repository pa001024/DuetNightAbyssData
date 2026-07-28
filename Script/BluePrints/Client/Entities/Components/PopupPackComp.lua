local Component = {}

function Component:PopupPackOnce(Id)
  self.logger.info("PopupPackComp PopupPackOnce id = %s", tostring(Id))
  local list = self:PopupPackSelectAllLeftTime()
  self.logger.info(string.format("PopupPackComp PopupPackSelectAllLeftTime = %s", CommonUtils.TableToString3(list)))
  EventManager:FireEvent(EventID.OnShowPopupPack, Id)
end

function Component:PopupPackSelectAllLeftTime()
  local list = {}
  for PopupPackId, PopupPackData in pairs(self.PopupPack) do
    local tabPopupPackData = DataMgr.PopupPack[PopupPackId]
    if tabPopupPackData and PopupPackData.TriggerNum <= tabPopupPackData.MaxTrigger and PopupPackData.LastPopTimeStamp + tabPopupPackData.Duration * 60 > TimeUtils.NowTime() then
      list[PopupPackId] = PopupPackData.LastPopTimeStamp + tabPopupPackData.Duration * 60 - TimeUtils.NowTime()
    end
  end
  return list
end

return Component
