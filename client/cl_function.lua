local allItems = {}
local ox_items = exports["ox_inventory"]:Items()
for k, v in pairs(ox_items) do
    allItems[k] = {
        label = v.label
    }
end

local function filterItems(place)
    local items = {}
    for i = 1, #Config.Items do
        local location = Config.Items[i].location
        if type(location) ~= "table" then
            location = {location}
        end
        for n = 1, #location do
            if location[n] == place then
                items[#items+1] = Config.Items[i]
            end
        end
    end
    return items
end

local function proceedResult(data)
    local timer = lib.callback.await("xc_craft:validation", false, data)
    local progress_desc = data.cooking and "Cooking" or "Crafting"
    if type(timer) == "string" then
        return lib.notify({
            title = labelText("failure"),
            description = timer,
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end

    local options = {
		duration = timer,
		label = labelText("progress_label", progress_desc),
		position = "bottom",
		useWhileDead = false,
		canCancel = true,
		disable = {
			move = true,
			car = true
		}
	}
	local progress = lib.progressCircle(options)
    if not progress then
		return lib.notify({
            title = labelText("attention"),
            description = labelText("progress_canceled", progress_desc),
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'circle-exclamation',
            iconColor = '#ffff00'
        })
	end

    local result = lib.callback.await("xc_craft:proceed", false, data)
    if type(result) == "string" then
        return lib.notify({
            title = labelText("failure"),
            description = result,
            position = 'top',
            style = {
                backgroundColor = '#141517',
                color = '#909296'
            },
            icon = 'ban',
            iconColor = '#C53030'
        })
    end
    return lib.notify({
		title = labelText("success"),
		description = labelText("progress_finish", progress_desc),
		position = 'top',
		style = {
			backgroundColor = '#141517',
			color = '#909296'
		},
		icon = 'circle-check',
		iconColor = '#00ff00'
	})
end

local function craftAction(data, cooktype)
    local options = {}
    local items = data.items
    for i = 1, #items do
        local v = items[i]
        if v.type == cooktype then
            local metadata = {}
            local itemprogress = 0
            for n = 1, #v.requirements do
                local label = allItems[v.requirements[n].item]?.label or v.requirements[n].item
                local count = v.requirements[n].count
                local myCount = exports["ox_inventory"]:Search("count", v.requirements[n].item)
                local progress = (count - myCount >= 0 and (myCount/count)*100 or 100)
                metadata[#metadata+1] = {
                    ["label"] = ("%s - %s"):format(n, label),
                    ["value"] = ("%s/%s"):format(myCount, count),
                    ["progress"] = progress,
                }
                itemprogress += progress
            end
            options[#options+1] = {
                title = ("%s - %s"):format((#options+1), allItems[v.item]?.label or v.item),
                description = labelText("item_desc", v.duration, v.count),
                progress = itemprogress/#metadata,
                image = ("nui://ox_inventory/web/images/%s.png"):format(v.item),
                metadata = metadata,
                onSelect = function()
                    data.item = v.item
                    proceedResult(data)
                end
            }
        end
    end
    lib.registerContext({
        id = "crafting-action",
        title = data.cooking and labelText("cooking_recipe") or labelText("crafting_material"),
        menu = data.cooking and "craft-cooking",
        options = options
    })
    return lib.showContext("crafting-action")
end

local function openCooking(data)
    lib.registerContext({
        id = "craft-cooking",
        title = data.cooking and labelText("cooking_title") or labelText("crafting_title"),
        options = {
            {
                title = "Food",
                icon = "bowl-food",
                arrow = true,
                onSelect = function()
                    craftAction(data, "food")
                end
            },
            
            {
                title = "Drink",
                icon = "mug-hot",
                arrow = true,
                onSelect = function()
                    craftAction(data, "drink")
                end
            }
        }
    })
    return lib.showContext("craft-cooking")
end

function isAuthorized(authorizedJob)
    if type(authorizedJob) ~= "table" then
        authorizedJob = {authorizedJob}
    end

    local tabletype = table.type(authorizedJob)
    if tabletype == "hash" then
        local grade = authorizedJob[ESX.PlayerData.job.name]
        if grade and grade <= ESX.PlayerData.job.grade then
            return true
        end
    end
    if tabletype == "mixed" then
        if authorizedJob[ESX.PlayerData.job.name] then
            return authorizedJob[ESX.PlayerData.job.name] <= ESX.PlayerData.job.grade
        end
        for index, value in pairs(authorizedJob) do
            if value == ESX.PlayerData.job.name then
                return true
            end
        end
    end
    if tabletype == "array" then
        for i = 1, #authorizedJob do
            if ESX.PlayerData.job.name == authorizedJob[i] then
                return true
            end
        end
    end
    return false
end

function openMenu(data)
    local library = Config.Crafting[data.index]
    local location = library.location
    local items = filterItems(location)
    data.cooking = library.cooking
    data.items = items
    if data.cooking then
        openCooking(data)
    else
        craftAction(data)
    end
end