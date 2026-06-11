package.path = "./flintqua/?.lua;./flintqua/?/init.lua;" .. package.path
local flintqua = require("src.flintqua")
local tools = require("tools.os_tools")

-- Load the database
local db = flintqua.open("database/playerdata.db")



-- Clear unusual text first.
tools.clear_screen()


-- Welcome Message
print("[               SEVEN FROZE               ]")
print("[                                         ]")
print("[      Welcome to Seven Froze Dungeon!    ]")
print("[       What do you wanna do now?         ]")
print("[                                         ]")
print("[        1. Explore | 2. Status           ]")



local choice = "" -- Waits for player to type and hit Enter
local valid = false

function choosed_two()
    local Health = db:get("Player Health")
    local goldStatus = db:get("Player Gold")
    print(" [             SEVEN FROZE              ]")
    print(" [            PLAYER STATUS:            ] ")
    print(" [                                      ] ")
    print(" [     CURRENT PLAYER HEALTH " .. Health .. "%.      ] ")
    print(" [   CURRENT PLAYER INVENTORY " .. goldStatus .. " GOLD.   ] ")
    print(" [                                      ] ")
    print(" [       1. Explore | 2. Status         ] ")

end


while not valid do
    io.write("> ")
    choice = io.read()

    if choice == "1" then 
        choosed_one()
        print("")
        valid = true -- This stops the loop!
        
    elseif choice == "2" then
        tools.clear_screen()
        print(choosed_two())
        valid = false -- This stops the loop!
        
    else
        -- If they type anything else, it hits this block,
        -- doesn't set 'valid' to true, so the loop runs again.
        print("Please choose a correct option.")
    end
end

db:close()
 









