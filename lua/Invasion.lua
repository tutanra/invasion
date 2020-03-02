-- FUNCIONES --
invasion_AG = {}
menusDinamicos = {}

function INV_mensaje(_tipo, _texto, _forHelis, _titulo, _groupID)
    -- 1 TIPO MISION STATUS
    -- 2 TIPO ALERTA
    -- 3 TIPO PANICO
    -- 4 STARTUP
    local _msg = ""
    local _snd = ""
    local _dst = ""
    _forHelis = _forHelis or false
    _titulo = _titulo or false
    _groupID = _groupID or false
    if (_tipo == 1) then
        _snd = "beep.ogg"
        _msg = "\nINFORMACIÓN DE MISIÓN\n---------------------------------------\n\n"
    elseif (_tipo == 2) then
        _snd = "Morse.ogg"
        _msg = "\nALERTA DE MISIÓN\n-----------------------------------------\n\n"
    elseif (_tipo == 3) then
        _snd = "sirena.ogg"
        _msg = "\nSERVICIO DE INTELIGENCIA\n-----------------------------------------\n\n"
    elseif (_tipo == 4) then
        _snd = "startup.ogg"
    else
        _snd = "Morse.ogg"
        _msg = "\n"
    end
    if (_titulo ~= false) then
        _msg = "\n" .. _titulo .. "\n----------------------------------------------------------------------------\n\n"
    end
    if (_forHelis == false and _groupID == false) then
        _dst = coalition.side.BLUE
        trigger.action.outTextForCoalition(_dst, _msg .. _texto .. "\n", 10, true)
        trigger.action.outSoundForCoalition(_dst, _snd)
    elseif (_groupID ~= false) then
        trigger.action.outTextForGroup(_groupID, _msg .. _texto .. "\n", 10, true)
        trigger.action.outSoundForGroup(_groupID, _snd)
    else
        for i, _group in pairs(coalition.getGroups(coalition.side.BLUE, Group.Category.HELICOPTER)) do
            if _group ~= nil then
                local _groupHELI = Group.getID(_group)
                trigger.action.outSoundForGroup(_groupHELI, _snd)
                trigger.action.outTextForGroup(_groupHELI, _msg .. _texto .. "\n", 10, true)
            end
        end
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function checkAlive(_groupName)
    local _group = Group.getByName(_groupName)
    for j, _unit in pairs(_group:getUnits()) do
        if _unit ~= nil then
            return _unit
        end
    end
    return nil
end

function checkAliveNumber(_groupName)
    local _group = Group.getByName(_groupName)
    local _totali = Group.getInitialSize(_group)
    local i = 0
    for j, _unit in pairs(_group:getUnits()) do
        if _unit ~= nil then
            if (_unit:getLife() >= 1) then
                i = i + 1
            end
        end
    end
    return i
end

function checkAlivePercent(_groupName)
    local _group = Group.getByName(_groupName)
    local _totali = Group.getInitialSize(_group)
    local i = 0
    for j, _unit in pairs(_group:getUnits()) do
        if _unit ~= nil then
            if (_unit:getLife() > 1) then
                i = i + 1
            end
        end
    end
    return ((i / _totali) * 100)
end

-- BUSQUEDA VALOR EN TABLA
local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value[1] == val then
            return true
        end
    end
    return false
end

-- ACCION DE TAREA IA ELEGIDA EN RANDOM
-- numMAX : Tareas asignadas en la unidad a elegir
function WPrandom(_grupoNombre, _numMAX)
    local _group
    if type(_grupoNombre) == "string" then
        _group = Group.getByName(_grupoNombre)
        env.info("Entra random " .. _grupoNombre)
    else
        _group = _grupoNombre
        env.info("Entra random " .. _group:getName())
    end
    wpRandom = math.random(_numMAX)
    trigger.action.pushAITask(_group, wpRandom)
end

local function getCordenadasVec3(_unidad, _tipo)
    env.info(_unidad)
    if (_tipo == "grupo") then
        local pos = checkAlive(_unidad)
        return Unit.getPosition(pos).p
    elseif (_tipo == "unidad") then
        local pos = Unit.getByName(_unidad)
        return Unit.getPosition(pos).p
    elseif (_tipo == "estatico") then
        local pos = StaticObject.getByName(_unidad)
        return StaticObject.getPosition(pos).p
    end
    return nil
end

local function getCordenadasUnit(_unidad, _tipo)
    local lat, lon
    if (_tipo == "grupo") then
        local pos = checkAlive(_unidad)
        lat, lon = coord.LOtoLL(Unit.getPosition(pos).p)
    elseif (_tipo == "unidad") then
        local pos = Unit.getByName(_unidad)
        lat, lon = coord.LOtoLL(Unit.getPosition(pos).p)
    elseif (_tipo == "estatico") then
        local pos = StaticObject.getByName(_unidad)
        lat, lon = coord.LOtoLL(StaticObject.getPosition(pos).p)
    end
    return (mist.tostringLL(lat, lon, 0, true))
end

function getUnitFromMission(_unidad)
    if type(_unidad) == "string" then
        return _unidad
    else
        for _, _unitName in pairs(_unidad) do
            return _unitName
        end
    end
end

function getVec3FromMission(_unidad, _tipo)
    return getCordenadasVec3(getUnitFromMission(_unidad), _tipo)
end

function getCordenadas(_unidad, _tipo)
    return getCordenadasUnit(getUnitFromMission(_unidad), _tipo)
end

-- NUMERO TOTAL DE AVIONES ENEMIGOS POR GRUPO
local function totalAirplaneGroup(_groupName)
    local _totalAirplane = 0
    local i = 1
    _group = Group.getByName(_groupName .. "#00" .. i)
    while (i < 20) do
        if (_group ~= nil) then
            for j, _unit in pairs(Group.getUnits(_group)) do
                if (_unit ~= nil) then
                    if (Unit.getLife(_unit) > 1.0) then
                        _totalAirplane = _totalAirplane + 1
                    end
                end
            end
        end
        i = i + 1
        _group = Group.getByName(_groupName .. "#00" .. i)
    end
    return _totalAirplane
end

function continueGroup(_groupName)
    local _group = Group.getByName(_groupName)
    if (_group ~= nil) then
        trigger.action.groupContinueMoving(_group)
    end
end

function stopGroup(_groupName)
    local _group = Group.getByName(_groupName)
    if (_group ~= nil) then
        trigger.action.groupStopMoving(_group)
    end
end

function Bengala(_unit)
    trigger.action.signalFlare(Unit.getPoint(_unit), trigger.flareColor.Red, 0)
end

function startGroup(_grupoNombre)
    local _group = Group.getByName(_grupoNombre)
    if (_group ~= nil) then
        local _groupcontrl = Group.getController(_group)
        Controller.setCommand(_groupcontrl, {id = "Start", params = {}})
    end
end

----------------------------
--
--
--
--  FUNCIONES PRINCIPALES DE MENUS Y OBJETIVOS
--
--
--
--
----------------------------
-- MENUS OBJ --
function insertarMision(_txt1, _units, _type, _percent, _txt3, _complete, _trigger)
    local _numArray = tablelength(invasion_AG) + 1
    _trigger = _trigger or false
    invasion_AG[_numArray] = {
        NombreObjetivo = _txt1,
        Unidades = _units,
        UnidadesTipo = _type,
        Porcentaje = _percent,
        TextoObjetivo = _txt3,
        Completado = _complete,
        Realizado = false,
        Dinamico = true
    }
    if (_trigger ~= false) then
        invasion_AG[_numArray].Trigger = _trigger
    end
    trigger.action.markToCoalition(_numArray, _txt1 .. "\n" .. _txt3, getVec3FromMission(_units, _type), coalition.side.BLUE, true)
end

function unidadesActivas(_tipo, _objetivo, _squadron)
    local _unidadesActivas = 0
    local _unidadesTotales = 0
    if (_tipo == "grupo") then
        local _group = Group.getByName(_objetivo)
        _unidadesActivas = checkAliveNumber(_objetivo)
        _unidadesTotales = _group:getInitialSize()
    elseif (_tipo == "unidad") then
        for j, _unitName in ipairs(_objetivo) do
            local _unit = Unit.getByName(_unitName)
            if (_unit ~= nil) then
                if (_unit:getLife() > 1) then
                    _unidadesActivas = _unidadesActivas + 1
                end
            end
            _unidadesTotales = _unidadesTotales + 1
        end
    elseif (_tipo == "estatico") then
        for j, _unitName in ipairs(_objetivo) do
            local _unit = StaticObject.getByName(_unitName)
            if (_unit ~= nil) then
                if (_unit:getLife() > 1) then
                    _unidadesActivas = _unidadesActivas + 1
                end
            end
            _unidadesTotales = _unidadesTotales + 1
        end
    elseif (_tipo == "cap") then
        _unidadesActivas = _squadron.ResourceCount + totalAirplaneGroup(_objetivo)
    end
    if (_unidadesTotales > 1 and _tipo ~= "cap") then
        return _unidadesActivas .. " de " .. _unidadesTotales
    else
        return _unidadesActivas
    end
end

function misionesDinamicas(_groupID)
    local i = 0
    local _msg = ""
    -- env.info("Accion de grupo")
    for j, _menu in pairs(invasion_AG) do
        if (_menu.Dinamico == true and _menu.Realizado == false) then
            local _unitName = ""
            local _unitTipo = ""
            if (i > 0) then
                _msg = _msg .. "\n\n"
            end
            if (type(_menu.Unidades) == "string") then
                _unitName = _menu.Unidades
            else
                _unitName = _menu.Unidades[1]
            end
            if (type(_menu.UnidadesTipo) == "string") then
                _unitTipo = _menu.UnidadesTipo
            else
                _unitTipo = _menu.UnidadesTipo[1]
            end
            _msg = _msg .. "[" .. getCordenadas(_unitName, _unitTipo) .. "] (" .. j .. ") " .. _menu.NombreObjetivo .. " - " .. _menu.TextoObjetivo
            i = i + 1
        end
    end
    if (i == 0) then
        INV_mensaje(1, "", false, "NO HAY MISIONES DINAMICAS ACTIVAS", _groupID)
    else
        INV_mensaje(1, _msg, false, "MISIONES DINAMICAS", _groupID)
    end
end

function inicioMenu()
    for j, _menu in pairs(invasion_AG) do
        if (_menu.Dinamico == false) then
            -- ////SetUp Menu
            missionCommands.addCommandForCoalition(
                coalition.side.BLUE,
                "OBJETIVO " .. j .. " - " .. _menu.NombreObjetivo,
                nil,
                function()
                    local _msg
                    _msg = "OBJETIVO -" .. j .. " - " .. _menu.NombreObjetivo .. "\n\n"
                    if (_menu.VerEstado) then
                        if (type(_menu.TextoObjetivo) == "string") then
                            _msg = _msg .. _menu.TextoObjetivo
                            if (_menu.UnidadesTipo == "cap") then
                                _msg = _msg .. unidadesActivas(_menu.UnidadesTipo, _menu.Unidades, _menu.MooseSquadron)
                            else
                                _msg = _msg .. unidadesActivas(_menu.UnidadesTipo, _menu.Unidades)
                            end
                        else
                            for j, _unitName in ipairs(_menu.Unidades) do
                                _msg = _msg .. _menu.TextoObjetivo[j]
                                if (_menu.UnidadesTipo[j] == "cap") then
                                    _msg = _msg .. unidadesActivas(_menu.UnidadesTipo[j], _unitName, _menu.MooseSquadron[j])
                                else
                                    _msg = _msg .. unidadesActivas(_menu.UnidadesTipo[j], _unitName) .. "\n"
                                end
                            end
                        end
                    else
                        _msg = _msg .. _menu.TextoObjetivo
                    end
                    if (_menu.TextoCumplir) then
                        _msg = _msg .. "\n" .. _menu.TextoCumplir
                    end
                    INV_mensaje(1, _msg)
                end,
                nil
            )
        else
            local _unitName = ""
            local _unitTipo = ""
            if (type(_menu.Unidades) == "string") then
                _unitName = _menu.Unidades
            else
                _unitName = _menu.Unidades[1]
            end
            if (type(_menu.UnidadesTipo) == "string") then
                _unitTipo = _menu.UnidadesTipo
            else
                _unitTipo = _menu.UnidadesTipo[1]
            end
            trigger.action.markToCoalition(
                j,
                _menu.NombreObjetivo .. "\n" .. _menu.TextoObjetivo,
                getVec3FromMission(_unitName, _unitTipo),
                coalition.side.BLUE,
                true
            )
        end
    end
end

function menuDinamico(_groupID)
    if (menusDinamicos[_groupID] == nil) then
        menusDinamicos[_groupID] = missionCommands.addCommandForGroup(_groupID, "MISIONES DINAMICAS->", nil, misionesDinamicas, _groupID)
    end
end

local function missionCompleteUnit(_tipo, _unidad, _porcentaje, _squadron)
    if (type(_unidad) == "string") then
        _squadron = _squadron or nil
        if (_tipo == "grupo") then
            local _unidadesPercent = checkAlivePercent(_unidad)
            if (_porcentaje == 100) then
                if (_unidadesPercent == 0) then
                    return true
                end
            else
                if ((100 - _unidadesPercent) >= _porcentaje) then
                    return true
                end
            end
            return false
        elseif (_tipo == "unidad") then
            local _unit = Unit.getByName(_unidad)
            if (_unit ~= nil) then
                if (_unit:getLife() < 1) then
                    return true
                else
                    return false
                end
            else
                return true
            end
        elseif (_tipo == "estatico") then
            local _DCSstatic = StaticObject.getByName(_unidad)
            if (_DCSstatic ~= nil) then
                if (_DCSstatic:getLife() < 1) then
                    return true
                else
                    return false
                end
            else
                return true
            end
        elseif (_tipo == "cap") then
            local _totalSquadron = _squadron.ResourceCount + totalAirplaneGroup(_unidad)
            if (_totalSquadron == 0 or _totalSquadron == -999) then
                return true
            else
                return false
            end
        end
    else
        for j, _unitName in ipairs(_unidad) do
            if (missionCompleteUnit(_tipo, _unitName, _porcentaje, _squadron) == false) then
                return false
            end
        end
        return true
    end
end

local function missionComplete(_objetivo)
    if (type(_objetivo.Unidades) == "string") then
        -- env.info("Evento : " .. _objetivo.Unidades)
        if (_objetivo.UnidadesTipo == "cap") then
            return missionCompleteUnit(_objetivo.UnidadesTipo, _objetivo.Unidades, _objetivo.Porcentaje, _objetivo.MooseSquadron)
        else
            return missionCompleteUnit(_objetivo.UnidadesTipo, _objetivo.Unidades, _objetivo.Porcentaje)
        end
    else
        local _itemComplete = 0
        local _totalItems = 0
        for j, _unitName in ipairs(_objetivo.Unidades) do
            if (type(_objetivo.UnidadesTipo) == "string") then
                _unitTipo = _objetivo.UnidadesTipo
            else
                _unitTipo = _objetivo.UnidadesTipo[j]
            end
            -- env.info("Evento array : " .. _unitName)
            if (_unitTipo == "grupo") then
                if (missionCompleteUnit(_unitTipo, _unitName, _objetivo.Porcentaje) == false) then
                    return false
                else
                    _itemComplete = _itemComplete + 1
                end
            else
                if (_unitTipo.UnidadesTipo == "cap") then
                    if (missionCompleteUnit(_unitTipo, _unitName, _objetivo.Porcentaje, _objetivo.MooseSquadron[j]) == true) then
                        _itemComplete = _itemComplete + 1
                    end
                else
                    if (missionCompleteUnit(_unitTipo, _unitName, _objetivo.Porcentaje) == true) then
                        _itemComplete = _itemComplete + 1
                    end
                end
            end
            _totalItems = _totalItems + 1
        end
        if (_itemComplete == _totalItems) then
            return true
        elseif (_objetivo.Porcentaje < 100) then
            if (_objetivo.Porcentaje <= ((1 - (_itemComplete / _totalItems)) * 100)) then
                return true
            else
                return false
            end
        end
    end
end

local function checkMissionComplete(_category)
    for j, _menu in pairs(invasion_AG) do
        if (_menu.Realizado == false) then
            if (_category == 3 and _menu.UnidadesTipo == "estatico") then
                if (missionComplete(_menu) == true) then
                    local _nombreMision = "OBJETIVO " .. j .. " - " .. _menu.NombreObjetivo
                    -- env.info(_nombreMision)
                    _menu.Realizado = true
                    INV_mensaje(2, _menu.Completado)
                    if (_menu.Dinamico == false) then
                        missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
                    else
                        trigger.action.removeMark(j)
                    end
                    if (_menu.Trigger ~= nil) then
                        if (type(_menu.Trigger) == "string") then
                            env.info("Trigger String")
                            continueGroup(_menu.Trigger)
                        elseif (type(_menu.Trigger) == "function") then
                            env.info("Trigger Funcion")
                            _menu.Trigger()
                        else
                            env.info("Hay trigger pero no detecta")
                        end
                    end
                end
            elseif (_category == 1 and _menu.UnidadesTipo ~= "estatico") then
                if (missionComplete(_menu) == true) then
                    local _nombreMision = "OBJETIVO " .. j .. " - " .. _menu.NombreObjetivo
                    -- env.info(_nombreMision)
                    _menu.Realizado = true
                    INV_mensaje(2, _menu.Completado)
                    if (_menu.Dinamico == false) then
                        missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
                    else
                        trigger.action.removeMark(j)
                    end
                    if (_menu.Trigger ~= nil) then
                        if (type(_menu.Trigger) == "string") then
                            continueGroup(_menu.Trigger)
                        elseif (type(_menu.Trigger) == "function") then
                            _menu.Trigger()
                        else
                            env.info("Hay trigger pero no detecta")
                        end
                    else
                        env.info("No hay trigger")
                    end
                end
            end
        end
    end
end

eventHandler = {}
function eventHandler:onEvent(_eventDCS)
    if _eventDCS == nil or _eventDCS.initiator == nil then
        return true
    end
    if (_eventDCS.id == world.event.S_EVENT_DEAD) then
        -- MUERTE
        local _categoria = Object.getCategory(_eventDCS.initiator)
        if (_categoria == 3 or _categoria == 1) then
            checkMissionComplete(_categoria)
        end
    elseif (_eventDCS.id == world.event.S_EVENT_BIRTH) then
        local _plrName = Unit.getPlayerName(_eventDCS.initiator)
        if _plrName ~= nil then
            local _groupID = Group.getID(Unit.getGroup(_eventDCS.initiator))
            menuDinamico(_groupID)
            local _msg = "INVASION DCS server Abierto del Escuadron 111\n\n"
            _msg = _msg .. "Importante la lectura del Briefing, posibilidad de Objetivos extras y misiones dinámicas.\n\nSimpleRadio activado."
            timer.scheduleFunction(
                function()
                    INV_mensaje(4, _msg, false, "Bienvenido " .. _plrName .. " - Grupo " .. Group.getName(Unit.getGroup(_eventDCS.initiator)), _groupID)
                end,
                {},
                timer.getTime() + 2
            )
        end
    end
    return true
end

world.addEventHandler(eventHandler)
