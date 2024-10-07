local props = {}

RegisterNetEvent('vg_drugs:server:registerProp')
AddEventHandler('vg_drugs:server:registerProp', function(propCoords, drugType)
    if not props[drugType] then
        props[drugType] = {}
    end

    props[drugType][#props[drugType] + 1] = { coords = propCoords }
    
    if Config.Debug then
        print(("Debug: Registered prop for drug %s at coordinates: X=%.2f Y=%.2f Z=%.2f"):format(drugType, propCoords.x, propCoords.y, propCoords.z))
    end
end)

RegisterNetEvent('vg_drugs:server:collectItem')
AddEventHandler('vg_drugs:server:collectItem', function(propCoords, drugType)
    local src = source
    local closestPropIndex, closestDistance = nil, 1.5  

    if Config.Debug then
        print(("Debug: Searching for registered props near coordinates: X=%.2f Y=%.2f Z=%.2f for drug %s"):format(propCoords.x, propCoords.y, propCoords.z, drugType))
    end

    local propList = props[drugType]
    if propList then
        for i = 1, #propList do
            local propData = propList[i]
            local distance = #(propCoords - propData.coords)

            if Config.Debug then
                print(("Debug: Checking registered prop at X=%.2f Y=%.2f Z=%.2f Distance=%.2f"):format(propData.coords.x, propData.coords.y, propData.coords.z, distance))
            end

            if distance < closestDistance then
                closestPropIndex = i
                closestDistance = distance
                if Config.Debug then
                    print(("Debug: Found closer registered prop at distance %.2f"):format(distance))
                end
            end
        end
    end

    if closestPropIndex then
        local propData = table.remove(propList, closestPropIndex)

        TriggerClientEvent('vg_drugs:client:removeProp', -1, propData.coords, drugType)

        if Config.Debug then
            print(("Debug: Prop collected by player ID %d at X=%.2f Y=%.2f Z=%.2f"):format(src, propData.coords.x, propData.coords.y, propData.coords.z))
        end
        
        local amount = math.random(Config.Drugs[drugType].MinGatherAmount, Config.Drugs[drugType].MaxGatherAmount)
        
        if exports.ox_inventory:CanCarryItem(src, Config.Drugs[drugType].CollectedItem, amount) then
            exports.ox_inventory:AddItem(src, Config.Drugs[drugType].CollectedItem, amount)
            if Config.Debug then
                print(("Debug: Added %d %s to player ID %d"):format(amount, Config.Drugs[drugType].CollectedItem, src))
            end
        else
            TriggerClientEvent('ox_lib:notify', src, {type = 'error', description = 'You cannot carry any more items.'})
            if Config.Debug then
                print(("Debug: Player ID %d could not carry more."):format(src))
            end
        end
    else
        if Config.Debug then
            print("Error: No valid registered prop found near the provided coordinates.")
        end
    end
end)
