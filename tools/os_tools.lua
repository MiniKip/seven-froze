-- TABLE
local os_tools = {}



-- Clears the screen
function os_tools.clear_screen() -- 2. Attach the function to it
    -- Windows uses 'cls', Mac and Linux use 'clear'
    if os.getenv("OS") and os.getenv("OS"):find("Windows") then
        os.execute("cls")
    else
        os.execute("clear")
    end
end

return os_tools
