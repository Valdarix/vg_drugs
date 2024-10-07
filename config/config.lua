Config = {}


Config.Debug = false 
Config.UseSecondaryConfirmation = false 
Config.BulkProcessingTimeIncrease = 1000

-- This is shitty and needs to be cleaned up. 
Config.Drugs = {
    weed = {
        PropModel = `prop_weed_01`,
        CollectedItem = 'weed_bud',
        SpawnArea = {
            coords = vector3(-918.95, 4826.25, 307.69),
            radius = 8.0,
        },
        MinGatherAmount = 1,
        MaxGatherAmount = 5,
        GatherTime = 750,  
        NumOfProps = 10,       
        AnimDict = "amb@prop_human_bum_bin@idle_b",
        AnimClip = "idle_d",
        AnimFlag = 49,
        UseTerrain = true,
    },
    cocaine = {
        PropModel = `h4_prop_bush_cocaplant_01`,
        CollectedItem = 'coke_leaf',
        SpawnArea = {
            coords = vector3(4796.12, -5992.59, 20.43),
            radius = 15.0,
        },
        MinGatherAmount = 1,
        MaxGatherAmount = 4,
        GatherTime = 750, 
        NumOfProps = 10,
        AnimDict = "amb@prop_human_bum_bin@idle_b",
        AnimClip = "idle_d",
        AnimFlag = 49,
        UseTerrain = true,
    },
    acetone = {
        PropModel = `tr_prop_meth_acetone`,
        CollectedItem = 'acetone',
        SpawnArea = {
            coords = vector3(1158.82, -444.32, 74.56),
            radius = 8.0,
        },
        MinGatherAmount = 1,
        MaxGatherAmount = 4,
        GatherTime = 750,  
        NumOfProps = 10,       
        AnimDict = "amb@prop_human_bum_bin@idle_b",
        AnimClip = "idle_d",
        AnimFlag = 49,
        UseTerrain = true,
    },
    ammonia = {
        PropModel = `tr_prop_meth_ammonia`,
        CollectedItem = 'ammonia',
        SpawnArea = {
            coords = vector3(-177.38, 6154.49, 31.21),
            radius = 6.0,
        },
        MinGatherAmount = 1,
        MaxGatherAmount = 4,
        GatherTime = 750,  
        NumOfProps = 10,      
        AnimDict = "amb@prop_human_bum_bin@idle_b",
        AnimClip = "idle_d",
        AnimFlag = 49,
        UseTerrain = false,
    },
    acid = {
        PropModel = `tr_prop_meth_sacid`,
        CollectedItem = 'acid',
        SpawnArea = {
            coords = vector3(2379.88, 3150.19, 23.93),
            radius = 6.0,
        },
        MinGatherAmount = 1,
        MaxGatherAmount = 4,
        GatherTime = 750,  
        NumOfProps = 10,       
        AnimDict = "amb@prop_human_bum_bin@idle_b",
        AnimClip = "idle_d",
        AnimFlag = 49,
        UseTerrain = false,
    },
}

Config.Processing = {
    weed = {
        ProcessingLocations = {
            vector3(-3.96, -2495.13, -8.96),  
            vector3(-5.55, -2497.46, -8.95),  
            vector3(-6.99, -2499.51, -8.95),
            vector3(-2.58, -2499.44, -8.96),
            vector3(-1.28, -2497.52, -8.96),
        },
        Recipe = {
            { item = 'weed_bud', count = 10 },
            { item = 'empty_baggie', count = 5 },
        },
        Reward = { item = 'weed_skunk', count = 5 },  
        ProcessingTime = 5000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
    weedbrick = {
        ProcessingLocations = {
            vector3(0.23, -2512.98, -8.94),              
        },
        Recipe = {
            { item = 'weed_bud', count = 50 },  
        },
        Reward = { item = 'weed_brick', count = 1 },  
        ProcessingTime = 10000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
    meth = {
        ProcessingLocations = {
            vector3(1955.45, 5180.83, 47.98),
            vector3(1953.23, 5180.8, 47.98),
            vector3(1951.08, 5180.85, 47.98),      
        },
        Recipe = {
            { item = 'acetone', count = 30 },  
            { item = 'ammonia', count = 30 },
            { item = 'acid', count = 30 },
            { item = 'empty_baggie', count = 10 },
        },
        Reward = { item = 'meth', count = 10 },  
        ProcessingTime = 10000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
    coke = {
        ProcessingLocations = {
            vector3(1982.4547119141, -2610.29296875, 3.5238170623779),
            vector3(1979.7838134766, -2613.4301757812, 3.4134550094604),
            vector3(1977.2419433594, -2611.5812988281, 2.57563829422),          
        },
        Recipe = {
            { item = 'coke_leaf', count = 20 },             
            { item = 'empty_baggie', count = 10 },
        },
        Reward = { item = 'cokebaggy', count = 10 },  
        ProcessingTime = 10000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
    cokebrick = {
        ProcessingLocations = {
            vector3(1979.1564941406, -2607.3525390625, 3.388885974884),              
        },
        Recipe = {
            { item = 'coke_leaf', count = 50 },         
            
        },
        Reward = { item = 'coke_brick', count = 1 },  
        ProcessingTime = 10000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
    crack = {
        ProcessingLocations = {
            vector3(888.75, -960.68, 39.28),
            vector3(891.18, -960.67, 39.28),
            vector3(893.09, -960.8, 39.28),                  

        },
        Recipe = {
            { item = 'coke_leaf', count = 10 },  
            { item = 'ammonia', count = 5 },           
            { item = 'empty_baggie', count = 10 },
        },
        Reward = { item = 'crack_baggy', count = 10 },  
        ProcessingTime = 10000,       
        AnimDict = "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",  
        AnimClip = "machinic_loop_mechandplayer", 
        AnimFlag = 49, 
    },
}

