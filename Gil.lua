_addon.name = "Gil"
_addon.author = "Uwu/Darkdoom"
_addon.versioin = "lol"

texts = require 'texts'
require('default_settings')

settings = (defaults)
text_box = texts.new(settings.player)

Timer = os.clock()

function Get_Gil()
  
  local items = windower.ffxi.get_items()
  local gil = items.gil
  
  return gil
  
end

function Display_Box()
  
  if gil ~= nil then
    
  new_text = "Gil: " .. comma_value(gil) .. "\n"
  Timer = os.clock()
    
  end

    if new_text ~= nil then
    
      text_box:text(new_text)
      text_box:visible(true)
      Timer = os.clock()
    
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
    
    if gil ~= nil then
      
      Display_Box()
      
    end
    
  end
  
end)
