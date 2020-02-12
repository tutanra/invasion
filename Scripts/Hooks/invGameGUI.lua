do
    net.log("SERVER: Invasion LOG loader")

    -- VARIABLES
    local invasionSERVER = {}

    local function exportstring(s)
        return string.format("%q", s)
    end
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
        if err then
            return err
        end
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

    invasionSERVER.statN = function(id, _n)
        local _rtn = net.get_stat(_player, _n)
        if( _rtn == nil ) then
            return "0"
        else
            return tostring(_rtn)
        end
    end

    invasionSERVER.appendSTATS = function(_player)
        local charS, charC, charE = "   ", ",", " }\n"
        net.log("SERVER: Inicia Stats. : " .. _player)
        local file, err = io.open(invasionSERVER.fileSTATS, "a")
        net.log("Cargado")
        if err then
            return err
        end
        local _stats = invasionSERVER.getStats(_player)
        net.log("Estados")
        -- UCID, NAME, TIME, MISION, BLUE, AUTOKILL, CRASHES, VEHICLES, PLANES, SHIPS, LANDINGS, EJECTS
        local _msg = "{ "
        if (_stats ~= nil) then
            _msg = _msg .. os.date("")
            _msg = _msg .. _stats.ucid .. charC
            _msg = _msg .. _stats.Nombre .. charC
            if (_stats.TimeInit > 0) then
                _stats.Time = _stats.Time + (DCS.getRealTime() - _stats.TimeInit)
            end
            _msg = _msg .. _stats.Time .. charC
            _msg = _msg .. _stats.Mission .. charC
            _msg = _msg .. _stats.Blue .. charC
            _msg = _msg .. _stats.SelfKill .. charC
            _msg = _msg .. invasionSERVER.statN(_player, 1) .. charC --nº of crashes
            _msg = _msg .. invasionSERVER.statN(_player, 2) .. charC --nº of destroyed vehicles
            _msg = _msg .. invasionSERVER.statN(_player, 3) .. charC --nº of planes/helicopters
            _msg = _msg .. invasionSERVER.statN(_player, 4) .. charC --nº of ships
            _msg = _msg .. invasionSERVER.statN(_player, 6) .. charC --nº of landings
            _msg = _msg .. invasionSERVER.statN(_player, 7) .. charE --nº of ejects
            net.log("Grabacion")
            file:write(_msg)
        end
        file:close()
        net.log("SERVER: Stats guardados.")
    end

    -- // The Load Function
    invasionSERVER.load = function()
        local ftables, err = loadfile(invasionSERVER.fileUSERS)
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

    invasionSERVER.getUser = function(_table, _index, _value)
        if (_table ~= nil) then
            for _, _tb1 in ipairs(_table) do
                if (_tb1[_index] == _value) then
                    return true
                end
            end
        end
        return false
    end

    invasionSERVER.e111_users = invasionSERVER.load()

    invasionSERVER.getUser = function(_ucid)
        return invasionSERVER.has_value(invasionSERVER.e111_users, "ucid", _ucid)
    end

    --[[ 
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
]]
    invasionSERVER.onGameEvent = function(eventName, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
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
            if arg1 ~= nil then
                message = message .. ":" .. arg1
            end
            if arg2 ~= nil then
                message = message .. ":" .. arg2
            end
            if arg3 ~= nil then
                message = message .. ":" .. arg3
            end
            if arg4 ~= nil then
                message = message .. ":" .. arg4
            end
            if arg5 ~= nil then
                message = message .. ":" .. arg5
            end
            if arg6 ~= nil then
                message = message .. ":" .. arg6
            end
            if arg7 ~= nil then
                message = message .. ":" .. arg7
            end
            net.log("SERVER: " .. message)
            if (eventName == "disconnect") then
                invasionSERVER.appendSTATS(arg1)
            elseif (eventName == "change_slot") then
                local _stats = invasionSERVER.getStats(arg1)
                net.log("Inicia el tiempo con player : " .. arg1 .. " y slot " .. arg2)
                if (tonumber(arg2) > 0) then
                    net.log("SERVER: Inicia el tiempo")
                    _stats.TimeInit = DCS.getRealTime()
                else
                    net.log("SERVER: Para el tiempo")
                    if (_stats.TimeInit > 0) then
                        net.log("SERVER: Acumula el tiempo")
                        _stats.Time = _stats.Times + (DCS.getRealTime() - _stats.TimeInit)
                        _stats.TimeInit = 0
                    end
                end
            elseif (eventName == "friendly_fire") then
                local _stats = invasionSERVER.getStats(arg1)
                _stats.Blue = _stats.Blue + 1
            elseif (eventName == "self_kill") then
                local _stats = invasionSERVER.getStats(arg1)
                _stats.SelfKill = _stats.SelfKill + 1
            end
        end
    end

    invasionSERVER.onPlayerConnect = function(_playerID) -- > true | false, "disconnect reason"
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
        invasionSERVER.e111_stats[_ucid].Time = 0
        invasionSERVER.e111_stats[_ucid].TimeInit = 0
        invasionSERVER.e111_stats[_ucid].Mission = DCS.getMissionName()
        invasionSERVER.e111_stats[_ucid].Blue = 0
        invasionSERVER.e111_stats[_ucid].SelfKill = 0
        return true
    end

    --[[     invasionSERVER.onPlayerDisconnect = function(id, err_code)
        net.log("Desconexión")
        invasionSERVER.appendSTATS(id)
    end ]]
    invasionSERVER.onSimulationStart = function()
        net.log("SERVER: Current mission is " .. DCS.getMissionName())
    end

    DCS.setUserCallbacks(invasionSERVER)
    net.log("SERVER: Invasion after LOG loader")
end
