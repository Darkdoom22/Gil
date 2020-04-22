_addon.name = "Gil"
_addon.author = "Uwu/Darkdoom"
_addon.version = "lol.1"

texts = require 'texts'
require('default_settings')

settings = (defaults)
text_box = texts.new(settings.player)

Timer = os.clock()
Gils = {}

function Get_Gil()
  
  local items = windower.ffxi.get_items()
  local gil = items.gil
  local name = Get_Name()
  
  windower.send_ipc_message(name .. ": " .. comma_value(gil))
  
  return comma_value(gil)
  
end

function Get_Name()
  
  local player = windower.ffxi.get_player()
  local name = player.name
  
  return name
  
end

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

windower.register_event('ipc message', function(msg)
  
  local name = Get_Name()
  full_string = ""
  
  if not has_value(Gils, msg) then
   
    table.insert(Gils, msg)    
   
  end
  
end)
  

function Display_Box()
  
  full_string = table.concat(Gils,"\n")
  if gil ~= nil then
    
    local name = Get_Name()
    
    new_text = "              ~ Gil~ \n" .. name .. ": " .. gil .. "\n" .. full_string .. "\n"
  
  end

  if new_text ~= nil then
    
    text_box:text(new_text)
    text_box:visible(true)
    
  end
  
end

function comma_value(amount)
  local formatted = amount
  while true do  
    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
    if (k==0) then
      break 
    end
  end
  return formatted
end

windower.register_event('prerender', function()
  
  if os.clock() - Timer > 5 then
    
    gil = Get_Gil()
    Timer = os.clock()
    
    if gil ~= nil then
      
      Display_Box()
      
    end
    
  end
  
end)
