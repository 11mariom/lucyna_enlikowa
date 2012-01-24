plugin = {}
plugin.__index = plugin

function plugin.init()
   local data = {}
   setmetatable( data, plugin )

   data.name = "admin"
   data.author = "mariom"
   data.version = "0.1"
   data.type = { "cmd" }
   data.cmd = cmdChar .. "admin"

   return data
end

--[[ TODO:
  * kick,
  * mode, voice, op 
--]]
function plugin:actionCmd()
   opt=msg.msg:match( "%w+", 8 )
   opt_2=msg.msg:sub( 9+opt:len() ) or ""

   if admin ~= msg.nick .. "!" .. msg.user then
      return msg.nick .. ": you don't have priveledges!"
   else
      if opt == "join" then
	 if opt_2 ~= nil then
	    cmd:join( opt_2 )
	    return msg.nick .. ": ok, i joined " .. opt_2
	 else
	    return msg.nick .. ": you have to specify channel to join!"
	 end
      elseif opt == "part" then
	 chan=opt_2:match( "#+.+" )

	 if chan ~= nil then
	    cmd:part( chan )
	 else
	    cmd:part( msg.chan )
	 end
	 return "parted " .. chan or msg.chan
      elseif opt == "quit" then
	 cmd:quit( reason or "bye!" )
	 return "quit"
      end
   end 
end

