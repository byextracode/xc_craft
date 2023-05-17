CreateThread(function()
    for i = 1, #Config.Crafting do
        if Config.target and Config.Crafting[i].target then
            local options = Config.Crafting[i].target
            local coords = options.coords
            local point = lib.points.new({
                coords = coords,
                distance = 5.0
            })
            options.options = {
                {
                    name = options.name,
                    icon = Config.Crafting[i].cooking and "fa-solid fa-fire-burner" or "fa-solid fa-toolbox",
                    label = Config.Crafting[i].cooking and "Cooking" or "Crafting",
                    distance = 1.5,
                    index = i,
                    onSelect = function(data)
                        openMenu(data)
                    end,
                    canInteract = function(entity, distance, coords, name)
                        local authorized = Config.Crafting[i].job == nil and true or isAuthorized(Config.Crafting[i].job)
                        return not cache.vehicle and authorized and not LocalPlayer.state.invBusy
                    end
                }
            }

            if Config.Crafting[i].blip then
                local prop = Config.Crafting[i].blip
                local blip = AddBlipForCoord(coords)
                SetBlipScale(blip, prop.scale)
                SetBlipDisplay(blip, 4)
                SetBlipSprite(blip, prop.sprite)
                SetBlipColour(blip, prop.color)
                SetBlipAsShortRange(blip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString(prop.label)
                EndTextCommandSetBlipName(blip)
            end

            local id
            function point:onEnter()
                id = exports["ox_target"]:addSphereZone(options)
            end

            function point:onExit()
                exports["ox_target"]:removeZone(id)
            end

            local textUI
            function point:nearby()
                local authorized = Config.Crafting[i].job == nil and true or isAuthorized(Config.Crafting[i].job)
                if self.currentDistance <= 2.0 and authorized and not LocalPlayer.state.invBusy then
                    if not textUI then
                        textUI = true
                        lib.showTextUI(labelText("textui"), {icon="eye"})
                    end
                else
                    if textUI then
                        textUI = false
                        lib.hideTextUI()
                    end
                end
                Wait(1000)
            end
        elseif Config.Crafting[i].marker then
            local coords = Config.Crafting[i].marker.coords
            local point = lib.points.new({
                coords = coords,
                distance = 5.0
            })

            local textUI
            function point:nearby()
                local authorized = Config.Crafting[i].job == nil and true or isAuthorized(Config.Crafting[i].job)
                if self.currentDistance <= 2.0 and authorized and not LocalPlayer.state.invBusy then
                    if not textUI then
                        textUI = true
                        lib.showTextUI(labelText("textui"), {icon="e"})
                    end
                    if IsControlJustPressed(0, 38) then
                        openMenu({ index = i })
                        Wait(1000)
                    end
                    DrawMarker(Config.Crafting[i].marker.type, self.coords.x, self.coords.y, self.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, Config.Crafting[i].marker.scale, Config.Crafting[i].marker.scale, Config.Crafting[i].marker.scale, 200, 20, 20, 150, false, true, 2, false, nil, nil, false)
                else
                    if textUI then
                        textUI = false
                        lib.hideTextUI()
                    end
                end
            end
        end
    end
end)