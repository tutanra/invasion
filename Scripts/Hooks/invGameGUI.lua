do
    net.log("SERVER: Invasion LOG loader")

    local invasionSERVER = {}

    local function exportstring(s)
        return string.format("%q", s)
    end
    --// The Save Function
    invasionSERVER.save = function()
        local _file = lfs.writedir() .. [[Scripts\]] .. "usuarios_invasion"
        local charS, charE = "   ", "\n"
        local file, err = io.open(_file, "wb")
        if err then
            return err
        end
        -- initiate variables for save procedure
        file:write("return {" .. charE)
        for idx, t in ipairs(invasionSERVER.invasion_users) do
            file:write("-- Table: {" .. idx .. "}" .. charE)
            file:write("{" .. charE)
            for i, v in pairs(t) do
                file:write(i .. " = " .. exportstring(t[i]) .. "," .. charE)
            end
            file:write("}," .. charE)
        end
        file:write("}")
        file:close()
    end

    --// The Load Function
    invasionSERVER.load = function()
        local _file = lfs.writedir() .. [[Scripts\]] .. "usuarios_invasion"
        local ftables, err = loadfile(_file)
        if err then
            return _, err
        end
        return ftables()
    end

    -- BUSQUEDA VALOR EN TABLA
    invasionSERVER.has_value = function(_table, _index, _value)
        if (_table ~= nil) then
            for _, _tb1 in ipairs(_table) do
                if (_tb1[_index] == _value) then
                    return true
                end
            end
        end
        return false
    end

    invasionSERVER.invasion_users = invasionSERVER.load()

    invasionSERVER.getUser = function(_ucid)
        return invasionSERVER.has_value(invasionSERVER.invasion_users, "ucid", _ucid)
    end

    invasionSERVER.onPlayerTryChangeSlot = function(playerID, side, slotID)
        local _ucid = net.get_player_info(playerID, "ucid")
        local _playerName = net.get_player_info(playerID, "name")
        net.log("SERVER: SSB - Player Selected slot - player: " .. _playerName .. " slot:" .. slotID .. " ucid: " .. _ucid)
        if (has_value(invasion_users, "ucid", _ucid)) then
            net.log("SERVER: Usuario encontrado")
            net.force_player_slot(playerID, 0, "")
            local _chatMessage = string.format("*** Lo sentimos %s - Slot Ocupado - Utiliza otro Slot! ***", _playerName)
            net.send_chat_to(_chatMessage, playerID)
            return false
        else
            net.log("SERVER: Usuario no encontrado")
            return true
        end
    end

    invasionSERVER.onPlayerConnect = function(_playerID) --> true | false, "disconnect reason"
        local _ucid = net.get_player_info(_playerID, "ucid")
        net.log("SERVER: Player " .. _ucid .. " conecta")
        if (invasionSERVER.getUser(_ucid) == false) then
            net.log("SERVER: Player not found : " .. _ucid)
            local _playerName = net.get_player_info(_playerID, "name")
            local _tbl = {Nombre = _playerName, ucid = _ucid}
            table.insert(invasionSERVER.invasion_users, _tbl)
            invasionSERVER.save()
            net.log("SERVER: Tabla guardada.")
        end
        return true
    end

    DCS.setUserCallbacks(invasionSERVER)
    net.log("SERVER: Invasion after LOG loader")
end
