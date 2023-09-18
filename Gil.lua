_addon.name = "Gil"
_addon.author = "Uwu/Darkdoom"
_addon.version = "lol.3"

texts = require 'texts'
require('default_settings')

settings = (defaults)
text_box = texts.new(settings.player)

Timer = os.clock()
Gils = {}

function lpad(str, len, char)
  if char == nil then char = ' ' end
  return string.rep(char, len - #str) .. str
end


function Get_Gil()
  
  local items = windower.ffxi.get_items()
  local gil = items.gil
  local name = Get_Name()
  local pad =  24 - string.len(name)
  local gil_string = lpad(comma_value(gil), pad, ' ')
  windower.send_ipc_message(name .. ": " .. gil_string)
  
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
  
    for k,v in pairs(Gils) do
      
      if msg:sub(-9) ~= Gils[k]:sub(-9) and msg:sub(1, 3) == Gils[k]:sub(1, 3) then
        table.remove(Gils, k)
      end
      
    end
    
end)
  

function Get_Gil_Amount(msg)
    local amount_with_comma = msg:match(": (.+)$")
    local amount = amount_with_comma:gsub(",", "")
    return tonumber(amount)
end

function Get_Total_Gil()
    local total_gil = 0
    for _, msg in pairs(Gils) do
        total_gil = total_gil + Get_Gil_Amount(msg)
    end
    return comma_value(total_gil)
end

function Display_Box()
    full_string = table.concat(Gils, "\n")
    if gil ~= nil then
        local name = Get_Name()
        
        local total_gil = Get_Total_Gil()  -- Get the total gil amount
        
        new_text = "              ~ Gil ~ \n" .. name .. ": " .. gil .. "\n" .. full_string .. "\nTotal: " .. total_gil .. "\n"
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
