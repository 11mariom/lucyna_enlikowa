#!/usr/bin/env lua
-- Cfg:
nick = "lucyna_enlikowa"
real = "/me"
chan = "#mariom-test"
host = "irc.freenode.net"
port = 6667
cmdChar = "'"

-- Załadowanie rdzenia
require( "core" )

-- Inicjalizacja rdzenia
core = core.init( nick, real, chan, host, port )
-- Połączenie z serwerem
core:connect()

-- Plugin autoload:
core:pluginLoad( "ping" )
core:pluginLoad( "hello" )

while true do
   local s = socket:receive()

   if s ~= nil then
      print( s )

      if s:match(" PRIVMSG ") then
	 msg = core:parse( s )
	 print( msg.chan .. "| " .. msg.nick .. ": " .. msg.msg )

	 if msg.msg:find( "^" .. cmdChar .. "load" ) then
	    plug = msg.msg:match("%w+$")
	    core:pluginLoad( plug )
	    cmd:msg( msg.chan, "plugin " .. plug .. " loaded" )
	 elseif msg.msg:find( "^" .. cmdChar .. "unload" ) then
	    plug = msg.msg:match("%w+$")
	    core:pluginUnload( plug )
	    cmd:msg( msg.chan, "plugin " .. plug .. " unloaded" )
	 end

	 for i, v in ipairs( core.cmd ) do

	    if msg.msg:find( "^" .. v.cmd ) then
	       cmd:msg( msg.chan, 
			core[ v.plugin ]:actionCmd( msg.msg, msg.nick ) )
	       --cmd:msg( msg.chan, core.cmd[ v ]:callBack( msg.msg, msg.nick ) )
	    end

	 end

      else
	 for i, v in ipairs( core.raw ) do

	    if s:find( v.cmd ) then
	       cmd:send( core[ v.plugin ]:actionRaw( s ) )
	       --cmd:send( core.cmd[ v ]:callBack( s ) )
	    end

	 end

      end

   end
end
