require("ts3defs")
require("ts3errors")

local MODULE_NAME = "guestsound"

--- C O N F I G U R A T I O N ---
-- Monitor for specific user (You must know user id)
local user_array = {
	"MnfjhODyEeAWpRKhcFRZSse3o4c=", -- SomeUsername
	"qioeb8wGoUQ/Cw5jbFFTnnpE8Nc=", -- MyBigFriend
	-- "lmiGld35Qabf7xv+ZJJ6LYA2BbE=" -- Disabled for this user
}

 -- First (TOP) Channel name
local monitor_for_server_name = "You server name"
-- replace 8 with the serverguest group id
-- Permission->Server Groups->Example: Guest(8)
local monitor_for_group_id = "8" 
---------------------------------
---------------------------------

local function onClientMoveEvent(schid, clientID, oldChannelID, newChannelID, visibility, moveMessage)
  local server_name, errorCode = ts3.getServerVariableAsString(schid, ts3defs.VirtualServerProperties.VIRTUALSERVER_NAME)
  if (errorCode ~= ts3errors.ERROR_ok) then
    ts3.printMessage(schid, (MODULE_NAME .. ": Error getting server name: " .. errorCode), 0)
	return
  end
  --ts3.printMessageToCurrentTab("Server: "..server_name);
  --if visibility == ts3defs.Visibility.ENTER_VISIBILITY then
  if oldChannelID == 0 then -- only then enter server
  	local nickname, error = ts3.getClientVariableAsString(schid, clientID, ts3defs.ClientProperties.CLIENT_NICKNAME)
  	if error == ts3errors.ERROR_ok then
  		--ts3.printMessageToCurrentTab("Event: "..oldChannelID.." "..nickname);
    	local grps, error = ts3.getClientVariableAsString(schid, clientID, ts3defs.ClientProperties.CLIENT_SERVERGROUPS)
    	if error == ts3errors.ERROR_ok then
      		if (grps == monitor_for_group_id and server_name == my_server_name) or has_value(user_array, clientID) then 
        		ts3.playWaveFile(schid, "./plugins/lua_plugin/guestsound/sound/new_connection.wav")
      		end
    	end
  	end
  end
end

local function has_value (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

guestsound_events = {
	onClientMoveEvent = onClientMoveEvent
}