fx_version 'cerulean'
lua54 'yes'
game 'gta5'

name "xc_craft"
version "1.0.0"
description "Items crafting for fivem roleplay."
author "wibowo#7184"

shared_script "@es_extended/imports.lua"
shared_script "@ox_lib/init.lua"

shared_script "config.lua"
shared_script "shared.lua"
shared_script "locales/*.lua"

client_script "**/cl_*.lua"
server_script "**/sv_*.lua"

dependencies {
    "es_extended",
    "ox_lib",
    "ox_inventory",
    -- "ox_target" --optional
}