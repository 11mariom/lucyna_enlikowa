---- Definicja klasy
-- stworzenie tablicy
plugin = {}
plugin.__index = plugin

-- init!
function plugin.init()
   local data = {}
   setmetatable( data, plugin )

   data.name = "pong"
   data.author = "mariom"
   data.version = "0.1"
   data.type = { "cmd", "raw" }
   data.cmd = "ping"
   data.raw = "PING"

   return data
end

function plugin:actionCmd()
   return "pong"
end

function plugin:actionRaw( _cmd )
   return "PONG :" .. _cmd:sub(6)
end
