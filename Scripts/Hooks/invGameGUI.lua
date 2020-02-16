do
    net.log("SERVER: Invasion LOG loader")

    -- VARIABLES
    local invasionSERVER = {}

    local function exportstring(s)
        return string.format("%q", s)
    end

    local function isEmpty(s)
        return s == nil or s == "" or s == 0
    end

    local function getCategory(id)
        local _killed_target_category = DCS.getUnitTypeAttribute(id, "category")
        if _killed_target_category == nil then
            local _killed_target_cat_check_ship = DCS.getUnitTypeAttribute(id, "DeckLevel")
            local _killed_target_cat_check_plane = DCS.getUnitTypeAttribute(id, "WingSpan")
            if _killed_target_cat_check_ship ~= nil and _killed_target_cat_check_plane == nil then
                _killed_target_category = "Ships"
            elseif _killed_target_cat_check_ship == nil and _killed_target_cat_check_plane ~= nil then
                _killed_target_category = "Planes"
            else
                _killed_target_category = "Helis"
            end
        end
        return _killed_target_category
    end

    invasionSERVER.fileUSERS = lfs.writedir() .. [[Scripts\e111_users]]
    invasionSERVER.fileSTATS = lfs.writedir() .. [[Scripts\e111_stats]]
    invasionSERVER.fileKILLS = lfs.writedir() .. [[Scripts\e111_killboard]]
    invasionSERVER.e111_users = {}
    invasionSERVER.e111_stats = {}
    invasionSERVER.e111_kills = {}

    invasionSERVER.getStats = function(playerID)
        for _, _table in pairs(invasionSERVER.e111_stats) do
            if (_table.Id == playerID) then
                return _table
            end
        end
    end

    -- // The Save Function
    invasionSERVER.save = function()
        local charS, charE = "   ", "\n"
        local file, err = io.open(invasionSERVER.fileUSERS, "w")
        if err then
            return err
        end
        -- initiate variables for save procedure
        file:write("return {" .. charE)
        for idx, t in ipairs(invasionSERVER.e111_users) do
            -- file:write("-- Table: {" .. idx .. "}" .. charE)
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
        if (_rtn ~= nil) then
            return tostring(_rtn)
        else
            return "0"
        end
    end


    function ripairs(t)
        -- Try not to use break when using this function;
        -- it may cause the array to be left with empty slots
        local ci = 0
        local remove = function()
            t[ci] = nil
        end
        return function(t, i)
            i = i+1
            ci = i
            local v = t[i]
            if v == nil then
                local rj = 0
                for ri = 1, i-1 do
                    if t[ri] ~= nil then
                        rj = rj+1
                        t[rj] = t[ri]
                    end
                end
                for ri = rj+1, i do
                    t[ri] = nil
                end
                return
            end
            return i, v, remove
        end, t, ci
    end

    invasionSERVER.appendKILLS = function(_player, _stats)
        local _msg = ""
        local file
        if (_stats ~= nil) then
            local charS, charC, charE = "   ", ";", "\n"
            net.log("Entra en kills")
            local _foundKILL = false
            for i, _kill, remove in ripairs(invasionSERVER.e111_kills) do
                if _kill.Id == _player then
                    if _foundKILL == false then
                        net.log("Encontrado kills")
                        file, err = io.open(invasionSERVER.fileKILLS, "a")
                        if err then
                            return err
                        end
                        _foundKILL = true
                    end
                    _msg = _msg .. _kill.Time .. charC
                    _msg = _msg .. _stats.ucid .. charC
                    _msg = _msg .. _stats.Nombre .. charC
                    _msg = _msg .. _stats.Avion .. charC
                    _msg = _msg .. _kill.arma .. charC
                    _msg = _msg .. _kill.victima .. charC
                    _msg = _msg .. _kill.tipo .. charE                  
                    remove()
                    file:write(_msg)
                end
            end
            if _foundKILL == true then
                file:close()
                net.log("SERVER: KILLS guardados.")
            end
        end
    end

    invasionSERVER.appendSTATS = function(_stats)
        local _msg = ""
        if (_stats ~= nil and _stats.takeoff > 0) then
            local _player = _stats.Id
                local charS, charC, charE = "   ", ";", "\n"
            local file, err = io.open(invasionSERVER.fileSTATS, "a")
            if err then
                return err
            end
            _stats.Time = DCS.getRealTime() - _stats.Time
            -- UCID, NAME, TIME, MISION, AVION, BLUE, AUTOKILL, DEATH, TAKEOFF, LANDING, EJECTS
            _msg = _msg .. os.date("%y-%m-%d %H:%M:%S") .. charC
            _msg = _msg .. _stats.ucid .. charC
            _msg = _msg .. _stats.Nombre .. charC
            _msg = _msg .. tostring(math.floor(_stats.Time)) .. charC
            _msg = _msg .. _stats.Mission .. charC
            _msg = _msg .. _stats.Avion .. charC
            _msg = _msg .. _stats.Blue .. charC
            _msg = _msg .. _stats.SelfKill .. charC
            _msg = _msg .. _stats.pilotDeath .. charC
            _msg = _msg .. _stats.takeoff .. charC
            _msg = _msg .. _stats.landing .. charC
            _msg = _msg .. _stats.eject .. charE
            file:write(_msg)
            _stats.Time = 0
            _stats.Blue = 0
            _stats.SelfKill = 0
            _stats.pilotDeath = 0
            _stats.takeoff = 0
            _stats.landing = 0
            _stats.eject = 0
            file:close()
            invasionSERVER.appendKILLS(_player, _stats)
            net.log("SERVER: Stats guardados.")
        end
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
            --[[            local message = eventName
             if arg1 ~= nil then
                message = message .. ":arg1:" .. arg1
            end
            if arg2 ~= nil then
                message = message .. ":arg2:" .. arg2
            end
            if arg3 ~= nil then
                message = message .. ":arg3:" .. arg3
            end
            if arg4 ~= nil then
                message = message .. ":arg4:" .. arg4
            end
            if arg5 ~= nil then
                message = message .. ":arg5:" .. arg5
            end
            if arg6 ~= nil then
                message = message .. ":arg6:" .. arg6
            end
            if arg7 ~= nil then
                message = message .. ":arg7:" .. arg7
            end
            net.log("SERVER: " .. message) ]]
            -- KILLS
            if eventName == "kill" then
                if arg1 ~= -1 and arg4 == -1 then
                    net.log("SERVER: Kill humano")
                    local _kill = {}
                    _kill.Id = arg1
                    _kill.Time = os.date("%y-%m-%d %H:%M:%S")
                    _kill.arma = arg7
                    _kill.victima = arg5
                    _kill.tipo = getCategory(arg5)
                    table.insert(invasionSERVER.e111_kills, _kill)
                end
            elseif
                eventName == "disconnect" or eventName == "change_slot" or eventName == "friendly_fire" or eventName == "self_kill" or
                    eventName == "pilot_death" or
                    eventName == "takeoff" or
                    eventName == "landing" or
                    eventName == "eject"
             then
                -- CARGA STATS
                local _stats = invasionSERVER.getStats(arg1)
                if (eventName == "change_slot") then
                    -- CAMBIA SLOTS
                    if (arg3 == 0 and arg2 ~= "") then
                        net.log("SERVER: Inicia el tiempo unicamente")
                        _stats.Time = DCS.getRealTime()
                        _stats.Avion = DCS.getUnitProperty(arg2, DCS.UNIT_TYPE)
                    else
                        if (arg3 ~= 0 and arg2 ~= "") then
                            -- CAMBIO DE SLOT
                            net.log("SERVER: Cambio de slots")
                            invasionSERVER.appendSTATS(_stats)
                            _stats.Avion = DCS.getUnitProperty(arg2, DCS.UNIT_TYPE)
                            _stats.Time = DCS.getRealTime()
                        else
                            if (arg3 ~= 0 and arg2 == "") then
                                net.log("SERVER: De avión a espectadores")
                                invasionSERVER.appendSTATS(_stats)
                                _stats.Avion = ""
                            end
                        end
                    end
                elseif (eventName == "friendly_fire") then
                    _stats.Blue = _stats.Blue + 1
                elseif (eventName == "self_kill") then
                    _stats.SelfKill = _stats.SelfKill + 1
                elseif (eventName == "pilot_death") then
                    _stats.pilotDeath = _stats.pilotDeath + 1
                elseif (eventName == "takeoff") then
                    _stats.takeoff = _stats.takeoff + 1
                elseif (eventName == "landing") then
                    _stats.landing = _stats.landing + 1
                elseif (eventName == "eject") then
                    _stats.eject = _stats.eject + 1
                end
            end
        end
    end

    invasionSERVER.onPlayerConnect = function(_playerID) -- > true | false, "disconnect reason"
        local _playerName = net.get_player_info(_playerID, "name")
        local _ucid = net.get_player_info(_playerID, "ucid")
        net.log("SERVER: Player " .. _ucid .. " : Id : " .. _playerID .. ": conecta")
        if (invasionSERVER.getUser(_ucid) == false) then
            net.log("SERVER: Player not found : " .. _ucid)
            local _tbl = {Nombre = _playerName, ucid = _ucid, e111 = "false"}
            table.insert(invasionSERVER.e111_users, _tbl)
            invasionSERVER.save()
            net.log("SERVER: Tabla guardada : " .. _playerName .. " ucid " .. _ucid)
        end
        local _stats = {}
        _stats.ucid = _ucid
        _stats.Nombre = _playerName
        _stats.Id = _playerID
        _stats.Time = 0
        _stats.Mission = DCS.getMissionName()
        _stats.Blue = 0
        _stats.SelfKill = 0
        _stats.Avion = 0
        _stats.pilotDeath = 0
        _stats.takeoff = 0
        _stats.landing = 0
        _stats.eject = 0
        table.insert(invasionSERVER.e111_stats, _stats)
    end

    --[[     
    invasionSERVER.onSimulationStart = function()
        net.log("SERVER: Current mission is " .. DCS.getMissionName())
    end 
    ]]
    DCS.setUserCallbacks(invasionSERVER)
    net.log("SERVER: Invasion after LOG loader")
end
