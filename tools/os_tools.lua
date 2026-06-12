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

function os_tools.center_print(text)
    local terminal_width = 80
    local text_length = string.len(text)
    
    local padding = (terminal_width - text_length) / 2
    
   
    padding = math.floor(padding)
    
    if padding < 0 then padding = 0 end
    
    print(string.rep(" ", padding) .. text)
end


return os_tools
