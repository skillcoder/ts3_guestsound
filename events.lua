require("ts3defs")
require("ts3errors")

local MODULE_NAME = "guestsound"
--local user_array = { "MnfjhODyEeAWpRKhcFRZSse3o4c=", "qioeb8wGoUQ/Cw5jbFFTnnpE8Nc=" }
local user_array = {
	"MnfjhODyEeAWpRKhcFRZSse3o4c=", -- Sword
	"qioeb8wGoUQ/Cw5jbFFTnnpE8Nc=" -- Vitty
	-- "" -- Reptos
	-- "lmiGld35Qabf7xv+ZJJ6LYA2BbE=" -- kiryha
}

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
      		if (grps == "8" and server_name == "Zanul.ru") or has_value(user_array, clientID) then -- replace 10 with the serverguest group id
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