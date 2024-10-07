local function calculateMaxProcessable(source, processingType)
    local recipe = Config.Processing[processingType].Recipe
    local reward = Config.Processing[processingType].Reward
    local maxProcessable = nil 
   
    for _, ingredient in pairs(recipe) do
        local itemCount = exports.ox_inventory:GetItemCount(source, ingredient.item)
        local maxForThisIngredient = math.floor(itemCount / ingredient.count) 
        
        if not maxProcessable or maxForThisIngredient < maxProcessable then
            maxProcessable = maxForThisIngredient 
        end
    end

    if not maxProcessable or maxProcessable == 0 then
        return 0
    end
   
    while maxProcessable > 0 do
        local totalRewardCount = reward.count * maxProcessable
        if exports.ox_inventory:CanCarryItem(source, reward.item, totalRewardCount) then
            break 
        else
            maxProcessable = maxProcessable - 1 
        end
    end

    return maxProcessable 
end

local function processItems(source, processingType, quantity)
    local recipe = Config.Processing[processingType].Recipe
    local reward = Config.Processing[processingType].Reward
    local rewardCount = reward.count * quantity 

    for _, ingredient in pairs(recipe) do
        local itemName = ingredient.item
        local requiredAmount = ingredient.count * quantity

        local itemCount = exports.ox_inventory:GetItemCount(source, itemName)

        if itemCount < requiredAmount then
            TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'Not enough items to process.'})
            return
        end
    end

    if not exports.ox_inventory:CanCarryItem(source, reward.item, rewardCount) then
        TriggerClientEvent('ox_lib:notify', source, {type = 'error', description = 'You cannot carry any more items.'})
        return
    end

    for _, ingredient in pairs(recipe) do
        exports.ox_inventory:RemoveItem(source, ingredient.item, ingredient.count * quantity)
    end

    exports.ox_inventory:AddItem(source, reward.item, rewardCount)
    TriggerClientEvent('ox_lib:notify', source, {type = 'success', description = 'Processing completed!'})
end

RegisterNetEvent('vg_drugs:server:getMaxProcessable')
AddEventHandler('vg_drugs:server:getMaxProcessable', function(processingType)
    local src = source
    local maxProcessable = calculateMaxProcessable(src, processingType)
    TriggerClientEvent('vg_drugs:client:receiveMaxProcessable', src, processingType, maxProcessable)
end)

RegisterNetEvent('vg_drugs:server:processItems')
AddEventHandler('vg_drugs:server:processItems', function(processingType, quantity)
    local src = source
    processItems(src, processingType, quantity)
end)
