local processingActive = {} 


local function StartProcessing(processingType, maxProcessable)
    if processingActive[processingType] then return end 

    
    local input = lib.inputDialog('Processing ' .. processingType, {
        { 
            type = 'number', 
            label = 'Amount to process:', 
            icon = 'fas fa-cogs',
            min = 0, 
            max = maxProcessable,            
            default = maxProcessable }
    })

    if not input or not input[1] or input[1] < 1 then
        return
    end

    local quantity = input[1]

    if Config.UseSecondaryConfirmation == true then
        local confirm = lib.alertDialog({
            header = 'Confirm Processing',
            content = 'Do you want to process ' .. quantity .. ' of ' .. processingType .. '?',
            size = 'md',
            buttons = {
                {label = 'Yes', value = true},
                {label = 'No', value = false}
            }
        })
 

        if not confirm then return end 
    end

    processingActive[processingType] = true

    local recipe = Config.Processing[processingType].Recipe
    local reward = Config.Processing[processingType].Reward
    local baseProcessingTime = Config.Processing[processingType].ProcessingTime
    local totalProcessingTime = baseProcessingTime + (quantity * Config.BulkProcessingTimeIncrease) 
    local animDict = Config.Processing[processingType].AnimDict
    local animClip = Config.Processing[processingType].AnimClip
    local animFlag = Config.Processing[processingType].AnimFlag

  
    lib.progressBar({
        duration = totalProcessingTime,
        label = "Processing...",
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
            sprint = true,
        },
        anim = {
            dict = animDict,
            clip = animClip,
            flag = animFlag,
        }
    })

   
    TriggerServerEvent('vg_drugs:server:processItems', processingType, quantity)

    processingActive[processingType] = false 
end


for processingType, processingConfig in pairs(Config.Processing) do
    for _, location in ipairs(processingConfig.ProcessingLocations) do
      
        exports.ox_target:addSphereZone({
            coords = location,
            radius = 1.5,
            options = {
                {
                    name = 'vg_drugs:server:process_' .. processingType,
                    label = 'Process ' .. processingType,
                    icon = 'fas fa-cogs',
                    onSelect = function()
                      
                        TriggerServerEvent('vg_drugs:server:getMaxProcessable', processingType)
                    end
                }
            }
        })
    end
end


RegisterNetEvent('vg_drugs:client:receiveMaxProcessable')
AddEventHandler('vg_drugs:client:receiveMaxProcessable', function(processingType, maxProcessable)
    StartProcessing(processingType, maxProcessable)
end)
