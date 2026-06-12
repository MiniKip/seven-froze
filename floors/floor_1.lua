package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("src.flintqua")
local tools = require("tools.os_tools")

local db = flintqua.open("database/playerdata.db")

local floor_1 = {}

function floor_1.option1(floor_0)
    for i = 1, 5 do print("") end
    tools.center_print(" ######################################################## ")
    tools.center_print(" #                     SEVEN FROZE                      # ")
    tools.center_print(" #                                                      # ")
    tools.center_print(" #                    DANGER ZONE!!!!                   # ")
    tools.center_print(" #         You have been surround by 4 Zombies.         # ")
    tools.center_print(" #               What do you wanna do now?              # ")
    tools.center_print(" #                                                      # ") 
    tools.center_print(" #        1. Kill them | 2. Go back | 3. Status         # ") 
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
            floor_1.killend(floor_0)
            
        elseif choice == "2" then
            tools.clear_screen()
            valid = true
            floor_0.explore()
            
        elseif choice == "3" then
            tools.clear_screen()
            valid = true
            floor_0.status()
        else
            print("Please choose a correct option.")
        end
    end
end

function floor_1.killend(floor_0)
    for i = 1, 5 do print("") end
    tools.center_print(" ######################################################## ")
    tools.center_print(" #                     SEVEN FROZE                      # ")
    tools.center_print(" #                                                      # ")
    tools.center_print(" #                 Mission Successful!                  # ")
    tools.center_print(" #      Damage taken: -20 HP                            # ")
    tools.center_print(" #         Zombie One   =  -5 HP                        # ")
    tools.center_print(" #         Zombie Two   =  -5 HP                        # ")
    tools.center_print(" #         Zombie Three =  -5 HP                        # ")
    tools.center_print(" #         Zombie Four  =  -5 HP                        # ")
    tools.center_print(" #                                                      # ") 
    tools.center_print(" #      Reward earned:  +10 GOLD                        # ") 
    tools.center_print(" #                What do you wanna do now?             # ")
    tools.center_print(" #                                                      # ") 
    tools.center_print(" #        1. Next | 2. Go back | 3. Status              # ") 
    tools.center_print(" ######################################################## ")
    print("")
    -- REMEMBER TO UNCOMMET BEFORE RELEASING
    -- local totalGold = db:get("Total GOld") + 10
    -- db:set("Total GOld", totalGold)

    local choice = ""
    local valid = false

    while not valid do
        io.write("> ")
        choice = io.read()

        if choice == "1" then 
            tools.clear_screen()
            for i = 1, 5 do print("") end
            tools.center_print(" ######################################################## ")
            tools.center_print(" #                     SEVEN FROZE                      # ")
            tools.center_print(" #                                                      # ") 
            tools.center_print(" #           You have reached the dead end!             # ") 
            tools.center_print(" #             What do you wanna do now?                # ")
            tools.center_print(" #                                                      # ") 
            tools.center_print(" #               2. Go back | 3. Status                 # ") 
            tools.center_print(" ######################################################## ")
            print("")
            
        elseif choice == "2" then
            tools.clear_screen()
            valid = true
            floor_0.explore()
            
        elseif choice == "3" then
            tools.clear_screen()
            valid = true
            floor_0.status()
        else
            print("Please choose a correct option.")
        end
    end
end

return floor_1