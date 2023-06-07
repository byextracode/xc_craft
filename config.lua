Config  = {}

Config.versionCheck = true -- check for updates

Config.Locale = "en"
Config.translation = {}

Config.target = true -- only ox_target compatible

Config.Crafting = {
    {
        location = "kitchen", -- crafting name
        target = { -- if Config.target = true
            name = "craft-kitchen",
            coords = vec3(-2187.9, 4283.25, 49.2),
            radius = 0.25,
        },
        marker = { -- if Config.target = false
            type = 20, -- marker type, see https://docs.fivem.net/docs/game-references/markers/
            coords = vec3(-2187.9, 4283.25, 49.2), -- marker coords
            scale = 0.25, -- marker scale
        },
        blip = { -- optional, blip configuration for current location.
            label = "Kitchen",
            sprite = 467,
            scale = 0.6,
            color = 7
        },
        -- job = {  -- (optional) job restriction (optional) could be string or table (array, hash or mixed).
        --     ["chef"] = 0
        -- },
        cooking = true, -- (optional) is this craft a cooking ? might be needed later to specify item category and animation.
        -- cop = 3 -- (optional) minimum cops to do craft on this location
    },
    {
        location = "public",
        target = {
            name = "craft-public",
            coords = vec3(153.53, -3208.67, 6.1),
            radius = 0.35,
        },
        marker = {
            type = 20,
            coords = vec3(153.53, -3208.67, 6.1),
            scale = 0.35,
        },
        blip = {
            label = "Public Crafting",
            sprite = 467,
            scale = 0.6,
            color = 4
        },
    },
    {
        location = "illegal",
        target = {
            name = "craft-illegal",
            coords = vec3(1987.1, 3788.75, 32.25),
            radius = 0.5,
        },
        job = {
            "mafia",
            "cartel",
            ["biker"] = 2,
            ["gang"] = 1,
        },
        cop = 3,
    },
    {
        location = "mechanic",
        target = {
            name = "craft-mechanic",
            coords = vec3(-345.53, -130.36, 39.2),
            radius = 0.25,
        },
        job = {
            "mechanic"
        }
    },
}

Config.Items = {
    {
        item = "ammo-9", -- item name
        count = 50, -- items results count
        duration = 15, -- seconds
        location = "public", -- location could be string or table array.
        requirements = { -- item name and item count
            { item = "diamond", count = 1 },
            { item = "gold", count = 3 },
            { item = "copper", count = 5 },
            { item = "iron", count = 5 },
        }
    },
    {
        item = "fixkit",
        count = 50,
        duration = 15,
        location = "mechanic",
        requirements = {
            { item = "diamond", count = 1 },
            { item = "gold", count = 3 },
            { item = "copper", count = 5 },
            { item = "iron", count = 5 },
        }
    },
    {
        item = "lockpick",
        count = 50,
        duration = 15,
        location = {
            "public",
            "mechanic",
        },
        requirements = {
            { item = "diamond", count = 1 },
            { item = "gold", count = 3 },
            { item = "copper", count = 5 },
            { item = "iron", count = 5 },
        }
    },
    -- cooking
    {
        item = "burger",
        count = 50,
        type = "food", -- cooking item category
        duration = 15,
        location = "kitchen",
        requirements = {
            { item = "alive_chicken", count = 5 },
            { item = "slaughtered_chicken", count = 5 },
            { item = "packaged_chicken", count = 2 },
        }
    },
    {
        item = "cola",
        count = 50,
        type = "drink",
        duration = 15,
        location = "kitchen",
        requirements = {
            { item = "water", count = 25 },
            { item = "marijuana", count = 20 },
            { item = "petrol", count = 5 },
        }
    },
    {
        item = "hotdog",
        count = 50,
        type = "food",
        duration = 15,
        location = "kitchen",
        requirements = {
            { item = "alive_chicken", count = 10 },
            { item = "slaughtered_chicken", count = 2 },
            { item = "packaged_chicken", count = 5 },
        }
    },
    {
        item = "sprunk",
        count = 50,
        type = "drink",
        duration = 15,
        location = "kitchen",
        requirements = {
            { item = "water", count = 20 },
            { item = "marijuana", count = 5 },
            { item = "petrol", count = 10 },
        }
    },
}