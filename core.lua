#!/usr/bin/env lua
---- Definicja klasy rdzenia o to powinien się opierać cały bot
-- Stworzenie tablicy core
core = {}
core.__index = core

-- załadowanie socketów
socket = require( "socket" ).tcp()

-- załadowanie komend ircowych
require( "commands" )
cmd = command

-- Initialize core
-- @param nick Bot's nick
-- @param real Real name
-- @param chan Channel to join
-- @param host Server to connect
-- @param port Port of server
function core.init( nick, real, chan, host, port )
   local data = {}
   setmetatable( data, core )

   -- przypisanie danych
   data.nick = nick
   data.real = real
   data.chan = chan
   data.host = host
   data.port = port or 6667

   -- tablice
   data.cmd = {}
   data.raw = {}
   data.plugins = {}

   return data
end

-- Connect to server, set nick, join channel
function core:connect()
   -- połączenie z serwerem
   io.write( "Connecting…\n" )
   socket:connect( self.host, self.port )

   -- wysłanie danych do serwera
   cmd:send( "NICK " .. self.nick )
   cmd:send( "USER " .. self.nick .. " localhost " .. self.host .. " :" .. 
	      self.real )
   cmd:join( self.chan )
end

-- Parse message
-- @param line Line received from server
function core:parse( line )
   local msg = { }
   msg.nick = string.sub( line:match( ":%w+!" ), 2, -2 )
   msg.user = string.sub( line:match( "!~?%w+@.* P" ), 2, -3 )
   msg.chan = string.sub( line:match( "PRIVMSG .* :"), 9, -3 )
   msg.msg = string.sub( line:match( ":.*", 2 ), 2 )

   return msg
end

-- PLUGIN API
function core:registerHook( _plugin )
   for i, v in ipairs( self[ _plugin ].type ) do
      table.insert( self[v], { cmd = self[ _plugin ][v], plugin = _plugin, 
			       name = self[ _plugin ].name } )
   end
end

function core:unregisterHook( _plugin )
   for i, v in ipairs( self.cmd ) do

      if v.name:find( _plugin ) then
	 self.cmd[i] = nil
      end

   end
end

function core:pluginLoad( _plugin )
   require( _plugin )
   self[ _plugin ] = plugin.init()

   self:registerHook( _plugin )
end

function core:pluginUnload( _plugin )
   self:unregisterHook( _plugin )

   package.loaded[ _plugin ] = nil
end
