local spawnedProps = {}
local props = {}


for drugType, _ in pairs(Config.Drugs) do
    spawnedProps[drugType] = 0
    props[drugType] = {}
end

local function LoadModel(model)
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end
    if Config.Debug then
        print("Debug: Model " .. model .. " loaded successfully.")
    end
end

local function ValidatePropCoord(propCoord, drugType)
    local validate = true
    if spawnedProps[drugType] > 0 then
        for _, v in pairs(props[drugType]) do
            if #(propCoord - GetEntityCoords(v)) < 5 then
                validate = false
                if Config.Debug then
                    print("Debug: Invalid prop coordinate due to proximity to another prop.")
                end
            end
        end
    end
    return validate
end

local function GetGroundZCoord(x, y, drugType)
    local groundCheckHeights = {50, 51.0, 52.0, 53.0, 54.0, 55.0, 56.0, 57.0, 58.0, 59.0, 60.0}

    for _, height in ipairs(groundCheckHeights) do
        local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
        if foundGround then
            if Config.Debug then
                print("Debug: Ground Z found at " .. z .. " for coordinates X: " .. x .. " Y: " .. y)
            end
            return z
        end
    end

    if Config.Debug then
        print("Debug: Using default Z coordinate.")
    end
    return Config.Drugs[drugType].SpawnArea.coords.z
end

local function GeneratePropCoords(drugType)
    while true do
        Wait(1)

        local modX = math.random(-Config.Drugs[drugType].SpawnArea.radius, Config.Drugs[drugType].SpawnArea.radius)
        local modY = math.random(-Config.Drugs[drugType].SpawnArea.radius, Config.Drugs[drugType].SpawnArea.radius)

        local propCoordX = Config.Drugs[drugType].SpawnArea.coords.x + modX
        local propCoordY = Config.Drugs[drugType].SpawnArea.coords.y + modY

        local coordZ
        if Config.Drugs[drugType].UseTerrain then
            coordZ = GetGroundZCoord(propCoordX, propCoordY, drugType)
        else
            coordZ = Config.Drugs[drugType].SpawnArea.coords.z
            if Config.Debug then
                print("Debug: Using configured Z coordinate " .. coordZ .. " for drugType " .. drugType)
            end
        end

        local coord = vector3(propCoordX, propCoordY, coordZ)

        if ValidatePropCoord(coord, drugType) then
            if Config.Debug then
                print("Debug: Valid prop coordinate generated at X: " .. propCoordX .. " Y: " .. propCoordY .. " Z: " .. coordZ)
            end
            return coord
        end
    end
end

local function SpawnProp(drugType)
    LoadModel(Config.Drugs[drugType].PropModel)
    local propCoords = GeneratePropCoords(drugType)
    local prop = CreateObject(Config.Drugs[drugType].PropModel, propCoords.x, propCoords.y, propCoords.z, false, true, false)

    if prop == 0 then
        if Config.Debug then
            print("Error: Failed to create prop at X: " .. propCoords.x .. " Y: " .. propCoords.y .. " Z: " .. propCoords.z)
        end
        return
    end

    PlaceObjectOnGroundProperly(prop)
    FreezeEntityPosition(prop, true)
    props[drugType][#props[drugType] + 1] = prop
    spawnedProps[drugType] += 1

    if Config.Debug then
        print("Debug: Prop spawned at X: " .. propCoords.x .. " Y: " .. propCoords.y .. " Z: " .. propCoords.z)
    end

    TriggerServerEvent('vg_drugs:server:registerProp', propCoords, drugType)
end

local function SpawnInitialProps(drugType)
    if spawnedProps[drugType] < Config.Drugs[drugType].NumOfProps then
        local propsToSpawn = Config.Drugs[drugType].NumOfProps - spawnedProps[drugType]
        for _ = 1, propsToSpawn do
            SpawnProp(drugType)
            Wait(0)
        end
    end
end

local function RemovePropByCoords(propCoords, drugType)
    local closestProp = nil
    local closestDistance = 1.5

    for i, prop in ipairs(props[drugType]) do
        local propPos = GetEntityCoords(prop)
        local distance = #(propCoords - propPos)

        if distance < closestDistance then
            closestProp = prop
            closestDistance = distance
        end
    end

    if closestProp then
        SetEntityAsMissionEntity(closestProp, false, true)
        DeleteObject(closestProp)
        for i, prop in ipairs(props[drugType]) do
            if prop == closestProp then
                table.remove(props[drugType], i)
                spawnedProps[drugType] -= 1
                break
            end
        end
        if Config.Debug then
            print("Debug: Prop removed at X: " .. propCoords.x .. " Y: " .. propCoords.y .. " Z: " .. propCoords.z)
        end

        if spawnedProps[drugType] < Config.Drugs[drugType].NumOfProps then
            SpawnProp(drugType)
        end
    else
        if Config.Debug then
            print("Error: No prop found to remove near coordinates: X=" .. propCoords.x .. " Y=" .. propCoords.y .. " Z=" .. propCoords.z)
        end
    end
end

RegisterNetEvent('vg_drugs:client:removeProp')
AddEventHandler('vg_drugs:client:removeProp', function(propCoords, drugType)
    RemovePropByCoords(propCoords, drugType)
end)

local function StartGathering(propCoords, drugType)   
    lib.progressBar({
        duration = Config.Drugs[drugType].GatherTime,
        label = "Gathering...",
        disable = {
            move = true,
            car = true,
            combat = true,
            mouse = false,
            sprint = true,
        },
        anim = {
            dict = Config.Drugs[drugType].AnimDict,
            clip = Config.Drugs[drugType].AnimClip,
            flag = Config.Drugs[drugType].AnimFlag,
        }
    })
 
    TriggerServerEvent('vg_drugs:server:collectItem', propCoords, drugType)
    RemovePropByCoords(propCoords, drugType)
end


for drugType, drugConfig in pairs(Config.Drugs) do
    local propZone = lib.zones.sphere({
        coords = drugConfig.SpawnArea.coords,
        radius = drugConfig.SpawnArea.radius,
        onEnter = function(self)
            if spawnedProps[drugType] < drugConfig.NumOfProps then
                SpawnInitialProps(drugType)
            end
        end,
        onExit = function(self)
        end,
        debug = false
    })
   
    exports.ox_target:addModel(drugConfig.PropModel, {
        {
            name = 'vg_drugs:client:collectItem_' .. drugType,
            label = 'Collect ' .. drugType,
            icon = 'fas fa-box',
            distance = 2.5,
            onSelect = function(data)
                local propCoords = data.coords
                StartGathering(propCoords, drugType)
            end
        }
    })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then
        for drugType, drugProps in pairs(props) do
            for _, prop in pairs(drugProps) do
                SetEntityAsMissionEntity(prop, false, true)
                DeleteObject(prop)
            end
        end       
    end
end)
