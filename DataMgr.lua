DataMgr = setmetatable({}, {
    __index = function(t, key)
        return require("Datas." .. key)
    end
})

function DataMgr.BinarySearch(Key, DataIndexTable)
    local Low, High = 1, #DataIndexTable
    while Low <= High do
        local Mid = math.floor((Low + High) / 2)
        local Entry = DataIndexTable[Mid]
        if Key >= Entry.MinKey and Key <= Entry.MaxKey then
            return Entry.Loader(), Entry.MinKey, Entry.MaxKey
        elseif Key < Entry.MinKey then
            High = Mid - 1
        else
            Low = Mid + 1
        end
    end
    return nil
end

function DataMgr.QueryTable(Key, FileName, Data)
    local PartitionData, MinKey, MaxKey = DataMgr.BinarySearch(Key, Data)
    if not PartitionData or not PartitionData[Key] then
        return nil
    end
    return PartitionData[Key]
end

function DataMgr.GetPartitionData(Key, Data)
    local PartitionData, MinKey, MaxKey = DataMgr.BinarySearch(Key, Data)
    if not PartitionData or not PartitionData[Key] then
        return nil
    end
    return PartitionData
end

DataMgr.ReadOnly = function(name, tbl)
    return tbl
end

return DataMgr
