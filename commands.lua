#!/usr/bin/env lua
---- Definicja klasy komend
-- Stworzenie tablicy commamd
command = {}
command.__index = command

-- Basic function to communicate with IRC server
-- @param command Command to send to irc (see RFC)
function command:send( command )
   socket:send( command .. "\r\n" )
   io.write( command .. "\n" )
end

-- Join a channel.
-- @param chan Channel(s) to connect
-- @param key Key to channel(s)
function command:join( chan, key )
   if key ~= nil then
      self:send( "JOIN " .. chan .. " " .. key )
   else
      self:send( "JOIN " .. chan )
   end
end

-- Leave a channel
-- @param chan Channel to leave
-- @param reason Reason of leaving
function command:part( chan, reason )
   if reason ~= nil then
      self:send( "PART " .. chan .. " " .. reason )
   else
      self:send( "PART " .. chan )
   end
end

-- Change channel MODE
-- @param chan Channel
-- @param mode Set/Unset flag on channel
-- @param params Options to some params
function command:mode( chan, mode, params )
   if params ~= nil then
      self:send( "MODE " .. chan .. " " .. mode .. " " .. params )
   else
      self:send( "MODE " .. chan .. " " .. mode )
   end
end

-- Set/unset/check channel topic
-- @param chan Channel
-- @param topic: nil Check actual topic
--               "clear" Clear topic
--               text Set topic to text
function command:topic( chan, topic )
   if topic ~= nil then
      self:send( "TOPIC " .. chan .. " :" .. topic )
   elseif topic == "clear" then
      self:send( "TOPIC " .. chan .. " :" )
   else
      self:send( "TOPIC " .. chan )
   end
end

-- zapraszanie na kanał
-- Invite nick to channel
-- @param nick Nick to invite
-- @param chan Channel
function command:invite( nick, chan )
   self:send( "INVITE " .. nick .. " " .. chan )
end

-- Kick from channel
-- @param nick Nick to kick
-- @param chan Channel
-- @param reason Reason of kick, can be nil
function command:kick( nick, chan, reason )
   if reason ~= nil then
      self:send( "KICK " .. chan .. " " .. nick .. " :" .. reason )
   else
      self:send( "KICK " .. chan .. " " .. nick )
   end
end

-- Send message
-- @param chan Recipent of message (channel or nick)
-- @param msg Message to send
function command:msg( chan, msg )
   self:send( "PRIVMSG " .. chan .. " :" .. msg )
end

-- Send notice
-- @param chan Recipenf of notice (channel or nick)
-- @param msg Matter of notice
function command:notice( chan, msg )
   self:send( "NOTICE " .. chan .. " :" .. msg )
end

-- Quit from IRC
-- @param reason Reason of quit
function command:quit( reason )
   reason =  reason or "bot by mariom & Barthalion"
   self:send( "QUIT :" .. reason )
end
