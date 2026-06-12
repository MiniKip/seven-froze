package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("src.flintqua")
local tools = require("tools.os_tools")
local floors_0 = require("floors.floor_0")

local db = flintqua.open("database/playerdata.db")

local welcome = {}

function welcome.status()
    local Health = db:get("Player Health")
    local goldStatus = db:get("Player Gold")
    
    for i = 1, 5 do print("") end
    tools.center_print(" ######################################## ")
    tools.center_print(" #             SEVEN FROZE              #")
    tools.center_print(" #            PLAYER STATUS:            # ")
    tools.center_print(" #                                      # ")
    tools.center_print(" #     CURRENT PLAYER HEALTH " .. Health .. "%.      # ")
    tools.center_print(" #   CURRENT PLAYER INVENTORY " .. goldStatus .. " GOLD.   # ")
    tools.center_print(" #                                      # ")
    tools.center_print(" #        1. Back | 2. Status           # ")
    tools.center_print(" ######################################## ")
end

function welcome.intro()
    for i = 1, 5 do print("") end
    tools.center_print("###########################################")
    tools.center_print("#               SEVEN FROZE               #")
    tools.center_print("#                                         #")
    tools.center_print("#      Welcome to Seven Froze Dungeon!    #")
    tools.center_print("#       What do you wanna do now?         #")
    tools.center_print("#                                         #")
    tools.center_print("#        1. Explore | 2. Status           #")
    tools.center_print("###########################################")
    print("")

    local choice = ""
    local valid = false

    while not valid do
        io.write("> ")
        choice = io.read()
        
        if choice == "1" then 
            tools.clear_screen()
            valid = true
            floors_0.explore()
            
        elseif choice == "2" then
            tools.clear_screen()
            welcome.status()
            
        else
            print("Please choose a correct option.")
        end
    end
end

return welcome
