plugin = {}
plugin.__index = plugin

function plugin.init()
   local data = {}
   setmetatable( data, plugin )

   data.name = "plugin"
   data.author = "mariom"
   data.version = "0.1"
   data.type = { "cmd" }
   data.cmd = cmdChar .. "plugin"

   return data
end

function plugin:actionCmd()
   opt=msg.msg:match( "%w+", 9 )
   plug=msg.msg:match( "%w+$" )

   if opt == "load" then
      if self:check( plug ) == 0 then
	 return msg.nick .. ": plugin already loaded!"
      else
	 core:pluginLoad( plug )

	 return msg.nick .. ": plugin " .. plug .. " loaded"
      end
   elseif opt == "unload" then
      if self:check( plug ) ~= 0 then
	 return msg.nick .. ": plugin not loaded!"
      else
	 core:pluginUnload( plug )

	 return msg.nick .. ": plugin " .. plug .. " unloaded"
      end
   elseif opt == "list" then
      load=""

      for i, v in pairs( core.plugins ) do
	 load= load .. v .. ", "
      end

      return msg.nick .. ": loaded plugins: " .. load
   else
      return msg.nick ": use: load, unload, list"
   end
end

function plugin:check( _plugin )
   for i, v in pairs( core.plugins ) do
      if _plugin == v then
	 return 0
      end
   end
end
