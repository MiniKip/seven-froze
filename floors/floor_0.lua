package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("src.flintqua")
local tools = require("tools.os_tools")
local floor_1 = require("floors.floor_1")

local db = flintqua.open("database/playerdata.db")

local floor_0 = {}

function floor_0.status()
    local Health = db:get("Player Health")
    local goldStatus = db:get("Player Gold")
    
    tools.clear_screen()
    for i = 1, 5 do print("") end
    tools.center_print(" ######################################## ")
    tools.center_print(" #             SEVEN FROZE              # ")
    tools.center_print(" #            PLAYER STATUS:            # ")
    tools.center_print(" #                                      # ")
    tools.center_print(" #     CURRENT PLAYER HEALTH " .. Health .. "%.      # ")
    tools.center_print(" #   CURRENT PLAYER INVENTORY " .. goldStatus .. " GOLD.   # ")
    tools.center_print(" #                                      # ")
    tools.center_print(" #               1. Back                # ")
    tools.center_print(" ######################################## ")
    print("")

    local choice = ""
    local valid = false

    while not valid do
        io.write("> ")
        choice = io.read()

        if choice == "1" then
            tools.clear_screen()
            valid = true
            floor_0.explore()
        else
            print("Please choose a correct option.")
        end
    end
end

function floor_0.explore()
    for i = 1, 5 do print("") end
    tools.center_print(" ######################################################## ")
    tools.center_print(" #                      SEVEN FROZE                     # ")
    tools.center_print(" #                                                      # ")
    tools.center_print(" #                 You found 2 path ways.               # ")
    tools.center_print(" #               What do you wanna do now?              # ")
    tools.center_print(" #                                                      # ") 
    tools.center_print(" #    1. Go Straight | 2. Go Underground | 3. Status    # ") 
    tools.center_print(" ######################################################## ")
    print("")

    local choice = ""
    local valid = false

    while not valid do
        io.write("> ")
        choice = io.read()

        if choice == "1" then 
            tools.clear_screen()
            valid = true
            floor_1.option1(floor_0)
            
        elseif choice == "2" then
            tools.clear_screen()
            valid = true
            floor_0.underground()
            
        elseif choice == "3" then
            tools.clear_screen()
            valid = true
            floor_0.status()
        else
            print("Please choose a correct option.")
        end
    end
end

return floor_0