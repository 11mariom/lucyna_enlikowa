---- Definicja klasy
-- stworzenie tablicy
plugin = {}
plugin.__index = plugin

-- init!
function plugin.init()
   local data = {}
   setmetatable( data, plugin )

   data.name = "hello"
   data.author = "mariom"
   data.version = "0.1"
   data.type = { "cmd" }
   data.cmd = "cześć"

   return data
end

function plugin:actionCmd()
   return "witaj na kanale " .. msg.chan .. "!"
end

