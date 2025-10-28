local ItemUtils = {}

---@param ItemId integer
---@param TableName string | '"Resource"'
function ItemUtils:GetItemName(ItemId, TableName)
    local ItemData = DataMgr[TableName][ItemId]
    if not ItemData then
        return nil
    end

    if not ItemData.Name then
        if TableName == "Resource" then
            return ItemData.ResourceName
        else
            return nil
        end
    else
        return ItemData.Name
    end
end

return ItemUtils
