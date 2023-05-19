local cops = 0

local function fetchCop() -- update cops count function
    cops = #ESX.GetExtendedPlayers("job", "police")
    SetTimeout(60000, fetchCop) -- delay 60 seconds next update
end

CreateThread(fetchCop)

local function ValidateItem(name)
    for i = 1, #Config.Items do
        if Config.Items[i].item == name then
            return Config.Items[i]
        end
    end
    return nil
end

local function ValidateRequirements(source, requirements)
    if not next(requirements) then
        return false
    end
    for i = 1, #requirements do
        local hasItem = exports["ox_inventory"]:Search(source, "count", requirements[i].item) >= requirements[i].count
        if not hasItem then
            return false
        end
    end
    return true
end

lib.callback.register("xc_craft:validation", function(source, data)
    if data?.index == nil then
        return labelText("err_data")
    end

    local library = Config.Crafting[data.index]
    if library == nil then
        return labelText("err_data")
    end

    local item = ValidateItem(data.item)
    if item == nil then
        return labelText("err_data")
    end
    if library.cop then
        if cops < library.cop then
            return labelText("not_enough_cop")
        end
    end

    local sufficient = ValidateRequirements(source, item.requirements)
    if not sufficient then
        return labelText("not_enough_required")
    end

    local timer = item.duration * 1000
    return timer
end)

lib.callback.register("xc_craft:proceed", function(source, data)
    if data?.index == nil then
        return labelText("err_data")
    end

    local library = Config.Crafting[data.index]
    if library == nil then
        return labelText("err_data")
    end

    local item = ValidateItem(data.item)
    if item == nil then
        return labelText("err_data")
    end
    if library.cop then
        if cops < library.cop then
            return labelText("not_enough_cop")
        end
    end

    local sufficient = ValidateRequirements(source, item.requirements)
    if not sufficient then
        return labelText("not_enough_required")
    end

    for i = 1, #item.requirements do
        local success = exports["ox_inventory"]:RemoveItem(source, item.requirements[i].item, item.requirements[i].count)
    end

    exports["ox_inventory"]:AddItem(source, item.item, item.count)
    return true
end)