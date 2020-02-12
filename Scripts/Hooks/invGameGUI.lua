do
    net.log("SERVER: Invasion LOG loader")

    -- VARIABLES 
    local invasionSERVER = {}

    local function exportstring(s) return string.format("%q", s) end
    invasionSERVER.fileUSERS = lfs.writedir() .. [[Scripts\e111_users]]
    invasionSERVER.fileSTATS = lfs.writedir() .. [[Scripts\e111_stats]]
    invasionSERVER.e111_users = {}
    invasionSERVER.e111_stats = {}

    invasionSERVER.getStats = function(playerID)
        for _, table in pairs(invasionSERVER.e111_stats) do
            if (table.Id == playerID) then
                return table
            else
                return nil
            end
        end
    end

    -- // The Save Function
    invasionSERVER.save = function()
        local charS, charE = "   ", "\n"
        local file, err = io.open(invasionSERVER.fileUSERS, "wb")
        if err then return err end
        -- initiate variables for save procedure
        file:write("return {" .. charE)
        for idx, t in ipairs(invasionSERVER.e111_users) do
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

    invasionSERVER.appendSTATS = function(_player)
        local charS, charC, charE = "   ", ",", "\n"
        net.log("SERVER: Inicia Stats. : " .. _player)
        local file, err = io.open(invasionSERVER.fileSTATS, "a")
        net.log("Cargado")
        if err then return err end
        local _stats = invasionSERVER.getStats(_player)
        net.log("Estados")
        local _msg = "{ "
        if (_stats ~= nil) then
            net.log(_stats.Nombre)
            net.log(net.get_player_info(_player, "ucid"))
            msg = msg .. net.get_player_info(_player, "ucid") .. charC
            msg = msg .. _stats.Nombre .. charC
            msg = msg .. _stats.ucid .. charC
            msg = msg .. DCS.getMissionName .. charC           
        end
        net.log("Grabacion")
        file:write(msg)
        file:close()
        net.log("SERVER: Stats guardados.")
    end

    -- // The Load Function
    invasionSERVER.load = function()
        local ftables, err = loadfile(invasionSERVER.fileUSERS)
        if err then return _, err end
        return ftables()
    end

    -- BUSQUEDA VALOR EN TABLA
    invasionSERVER.has_value = function(_table, _index, _value)
        if (_table ~= nil) then
            for _, _tb1 in ipairs(_table) do
                if (_tb1[_index] == _value) then return true end
            end
        end
        return false
    end

    invasionSERVER.getUser = function(_table, _index, _value)
        if (_table ~= nil) then
            for _, _tb1 in ipairs(_table) do
                if (_tb1[_index] == _value) then return true end
            end
        end
        return false
    end

    invasionSERVER.e111_users = invasionSERVER.load()

    invasionSERVER.getUser = function(_ucid)
        return
            invasionSERVER.has_value(invasionSERVER.e111_users, "ucid", _ucid)
    end

    invasionSERVER.onPlayerTryChangeSlot =
        function(playerID, side, slotID)
            local _ucid = net.get_player_info(playerID, "ucid")
            local _playerName = net.get_player_info(playerID, "name")
            net.log("SERVER: SSB - Player Selected slot - player: " ..
                        _playerName .. " slot:" .. slotID .. " ucid: " .. _ucid)
            --[[         if (has_value(invasion_users, "ucid", _ucid)) then
            net.log("SERVER: Usuario encontrado")
            net.force_player_slot(playerID, 0, "")
            local _chatMessage = string.format("*** Lo sentimos %s - Slot Ocupado - Utiliza otro Slot! ***", _playerName)
            net.send_chat_to(_chatMessage, playerID)
            return false
        else
            net.log("SERVER: Usuario no encontrado")
            return true
        end ]]
        end

    invasionSERVER.onGameEvent = function(eventName, arg1, arg2, arg3, arg4,
                                          arg5, arg6, arg7)
        -- "friendly_fire", playerID, weaponName, victimPlayerID
        -- "mission_end", winner, msg
        -- "kill", killerPlayerID, killerUnitType, killerSide, victimPlayerID, victimUnitType, victimSide, weaponName
        -- "self_kill", playerID
        -- "change_slot", playerID, slotID, prevSide
        -- "connect", playerID, name
        -- "disconnect", playerID, name, playerSide, reason_code
        -- "crash", playerID, unit_missionID
        -- "eject", playerID, unit_missionID
        -- "takeoff", playerID, unit_missionID, airdromeName
        -- "landing", playerID, unit_missionID, airdromeName
        -- "pilot_death", playerID, unit_missionID
        if DCS:isServer() then
            local message = eventName
            if arg1 ~= nil then message = message .. ":" .. arg1 end
            if arg2 ~= nil then message = message .. ":" .. arg2 end
            if arg3 ~= nil then message = message .. ":" .. arg3 end
            if arg4 ~= nil then message = message .. ":" .. arg4 end
            if arg5 ~= nil then message = message .. ":" .. arg5 end
            if arg6 ~= nil then message = message .. ":" .. arg6 end
            if arg7 ~= nil then message = message .. ":" .. arg7 end
            net.log("SERVER: " .. message)
            if (eventName == "disconnect") then
                invasionSERVER.appendSTATS(arg1)
            end
        end
    end

    invasionSERVER.onPlayerConnect =
        function(_playerID) -- > true | false, "disconnect reason"
            local _ucid = net.get_player_info(_playerID, "ucid")
            net.log("SERVER: Player " .. _ucid .. " conecta")
            local _playerName = net.get_player_info(_playerID, "name")
            if (invasionSERVER.getUser(_ucid) == false) then
                net.log("SERVER: Player not found : " .. _ucid)
                local _tbl = {Nombre = _playerName, ucid = _ucid}
                table.insert(invasionSERVER.e111_users, _tbl)
                invasionSERVER.save()
                net.log("SERVER: Tabla guardada.")
            end
            invasionSERVER.e111_stats[_ucid] = {}
            invasionSERVER.e111_stats[_ucid].ucid = _ucid
            invasionSERVER.e111_stats[_ucid].Nombre = _playerName
            invasionSERVER.e111_stats[_ucid].Id = _playerID
            invasionSERVER.e111_stats[_ucid].Time = DCS.getRealTime()
            return true
        end

--[[     invasionSERVER.onPlayerDisconnect = function(id, err_code)
        net.log("Desconexión")
        invasionSERVER.appendSTATS(id)
    end ]]

    invasionSERVER.onSimulationStart = function()
        net.log('SERVER: Current mission is ' .. DCS.getMissionName())
    end

    DCS.setUserCallbacks(invasionSERVER)
    net.log("SERVER: Invasion after LOG loader")
end
