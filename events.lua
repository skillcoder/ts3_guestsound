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

local function has_value (tab, val)
    for index, value in ipairs (tab) do
        if value == val then
            return true
        end
    end

    return false
end

local pluginPath = ts3.getPluginPath()
local function playSound (schid, wav)
  local wavPath = pluginPath.."lua_plugin/guestsound/sound/"..wav
  --ts3.printMessageToCurrentTab(wavPath)
  local error = ts3.playWaveFile(schid, wavPath)
  if error ~= ts3errors.ERROR_ok then
    ts3.printMessageToCurrentTab("Error playing "..wavPath..": " .. error)
  end
end

local function onClientMoveEvent(schid, clientID, oldChannelID, newChannelID, visibility, moveMessage)

  --if visibility == ts3defs.Visibility.ENTER_VISIBILITY then
  if oldChannelID == 0 then -- only then enter server
    local nickname, errorCode = ts3.getClientVariableAsString(schid, clientID, ts3defs.ClientProperties.CLIENT_NICKNAME)
    if errorCode ~= ts3errors.ERROR_ok then
      ts3.printMessage(schid, (MODULE_NAME .. ": Error getting nickname: " .. errorCode), 0)
      return
    end

    if (has_value(user_array, clientID)) then 
      ts3.printMessageToCurrentTab("Our user: "..nickname)
      playSound(schid, "new_connection.wav")
      return
    end

    local server_name, errorCode = ts3.getServerVariableAsString(schid, ts3defs.VirtualServerProperties.VIRTUALSERVER_NAME)
    if (errorCode ~= ts3errors.ERROR_ok) then
      ts3.printMessage(schid, (MODULE_NAME .. ": Error getting server name: " .. errorCode), 0)
      return
    end

    --ts3.printMessageToCurrentTab(nickname.." come to server: "..server_name)
    if server_name == monitor_for_server_name then
  	  local grps, error = ts3.getClientVariableAsString(schid, clientID, ts3defs.ClientProperties.CLIENT_SERVERGROUPS)
   	  if error == ts3errors.ERROR_ok then
   		  if grps == monitor_for_group_id then 
          ts3.printMessageToCurrentTab("Our guest: "..nickname.." GroupId: "..grps)
          playSound(schid, "new_connection_ru.wav")
        end
  	  end
    end
  end
end

guestsound_events = {
	onClientMoveEvent = onClientMoveEvent
}