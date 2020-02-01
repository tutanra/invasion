-- Funciones --
-- dofile("lua\\InvasionCaucaso.lua")
env.info("----Inicio de funciones personalizadas 1.1----")
-- /// INICIO DE MISION

function INV_mensaje(_tipo, _texto, _forHelis, _titulo, _groupID)
    -- 1 TIPO MISION STATUS
    -- 2 TIPO ALERTA
    -- 3 TIPO PANICO
    -- 4 MISSION CUMPLIDA
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
    else
        _snd = "Morse.ogg"
        _msg = "\n"
    end
    if (_titulo ~= false) then
        _msg = "\n" .. _titulo .. "\n------------------------------------------------------------------------\n\n"
    end
    env.info("Grupo mensaje " .. _groupID)
    if (_forHelis == false and _groupID == false) then
        _dst = coalition.side.BLUE
        trigger.action.outTextForCoalition(_dst, _msg .. _texto .. "\n", 10, true)
        trigger.action.outSoundForCoalition(_dst, _snd)
    elseif (_groupID ~= false) then
        env.info("Envio por grupo")
        trigger.action.outTextForGroup(_groupID, _msg .. _texto .. "\n", 10, true)
        trigger.action.outSoundForGroup(_groupID, _snd)
    else
        env.info("Inicio de Helis")
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
            if (_unit:getLife() >= 1) then
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
    return (UTILS.tostringLL(lat, lon, 0, true))
end

function getCordenadas(_unidad, _tipo)
    _tipo = _tipo or "unidad"
    if type(_unidad) == "string" then
        env.info( "Unidad : ".._unidad .. " coordenada " .. getCordenadasUnit(_unidad, _tipo))
        return getCordenadasUnit(_unidad, _tipo)
    else
        for j, _unitName in ipairs(_unidad.Unidades) do
            env.info( "Unidad : ".._unitName .. " coordenada " .. getCordenadasUnit(_unitName, _tipo))
            return getCordenadasUnit(_unitName, _tipo)
        end
    end
end

--
--
--
--                      INICIO FUNCIONES CAP
--
--      Selecciona autómaticamente el inicio de aviones según las variables
--          _CAPminima -> Indica mínimo de aviones activos (En grupos)
--
--
--
-- NUMERO TOTAL DE AVIONES ENEMIGOS EN VUELO O CON TAREAS
local function totalAirplaneInAir(_tipo)
    local _totalAirplane = 0
    -- tipo CAP (Normal,Hardcore,extra)
    _tipo = _tipo or false
    for i, _group in pairs(coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)) do
        if _group ~= nil then
            local _groupName = Group.getName(_group)
            if
                (_tipo == false or (_tipo == 1 and has_value(_CAPnormal, _groupName:sub(1, -6))) or
                    (_tipo == 2 and has_value(_CAPhardcore, _groupName:sub(1, -6))) or
                    (_tipo == 3 and has_value(_CAPextra, _groupName:sub(1, -6))))
             then
                if (_tareas == true) then -- SI TIENE TAREA TAMBIEN SUMA
                    local _groupcontrl = Group.getController(_group)
                    if (Controller.hasTask(_groupcontrl) == true) then
                        _totalAirplane = _totalAirplane + 1
                    end
                    for j, _unit in pairs(_group:getUnits()) do
                        if _unit ~= nil and Unit.inAir(_unit) then
                            _totalAirplane = _totalAirplane + 1
                        end
                    end
                end
            end
        end
    end
    env.info("Aviones activos " .. _totalAirplane)
    return _totalAirplane
end

-- NUMERO TOTAL DE AVIONES ENEMIGOS EN VUELO O CON TAREAS POR GRUPO
local function totalAirplaneInAirGroup(_groupName)
    local _totalAirplane = 0
    local i = 1
    _group = Group.getByName(_groupName .. "#00" .. i)
    while (_group ~= nil) do
        local _groupcontrl = Group.getController(_group)
        if (Controller.hasTask(_groupcontrl) == true) then
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

-- INICIAR CAP
function startGroup(_grupoNombre)
    local _group = Group.getByName(_grupoNombre)
    if (_group ~= nil) then
        local _groupcontrl = Group.getController(_group)
        Controller.setCommand(_groupcontrl, {id = "Start", params = {}})
    end
end

function checkCAP(timeloop, time)
    return time + 10
end
--
--   MISSION 6
function missionExtra0_exito()
    INV_mensaje(
        2,
        "Support 1 - Material desplegado, cambio a rumbo 263º para regreso a base segura, vuelva a base y distraiga posibles contactos. \n\nObjetivo realizado, buen trabajo!!!"
    )
    trigger.action.setUserFlag(10, 1)
end
function missionExtra0_fail()
    INV_mensaje(2, "Support 1 derribado.\n\nMisión finalizada sin exito")
    trigger.action.setUserFlag(10, 2)
end
-- MISSION 7
function checkMission6()
    INV_mensaje(2, "Destruido Crucero Moskva en Bandar e-lengeh.\n\nObjetivo realizado, buen trabajo!!!")
    missionCommands.removeItemForCoalition(coalition.side.BLUE, {"OBJETIVO 6 - CG 1164 MOSKVA"})
end
--
--
--
--                      INICIO FUNCIONES MISIONES - MENUS
--
--
--
--
--
function INVASION_RadioMenuSetup()
    subMenuModosActivar = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "ACTIVAR MISIONES->")
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "ESCOLTA OP - SHARJAH INTL",
        subMenuModosActivar,
        function()
            local _msg = "ESCOLTA OP - SHARJAH INTL\n\n"
            if (trigger.misc.getUserFlag(10) == 1) then
                _msg = msg .. "Misión finalizada con éxito."
            elseif (trigger.misc.getUserFlag(10) == 2) then
                _msg = msg .. "Misión finalizada sin éxito. Support Derribado."
            elseif (Unit.inAir(Unit.getByName("Piloto #011"))) then
                _msg = _msg .. "Support 1 en el aire"
            elseif (trigger.misc.getUserFlag(10) == 9) then
                _msg = _msg .. "Support 1 en pista para despegue."
            elseif (trigger.misc.getUserFlag(10) == 0) then
                _msg =
                    _msg ..
                    "-Support 1- Desde la base de Sharjah Intl hacía Lavan Island.\n\nInicia encendido de Motores."
                trigger.action.setUserFlag(10, 9)
                startGroup("SUPPORT")
            end
            INV_mensaje(1, _msg)
        end,
        nil
    )
    subMenuModos = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "MODOS EXTRAS->")
    menuCAPextra =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO EXTRA CAP **",
        subMenuModos,
        function()
            local Khasab_base = ZONE_AIRBASE:New(AIRBASE.PersianGulf.Khasab, 10000)
            CAPDispatcher:SetSquadron(
                "Kish_CAP",
                AIRBASE.PersianGulf.Kish_International_Airport,
                {"KISH_SU30", "KISH_F14"}
            )
            CAPDispatcher:SetSquadronTakeoffInAir("Kish_CAP")
            CAPDispatcher:SetSquadronGci("Kish_CAP", 900, 1200)
            CAPDispatcher:SetSquadronOverhead("Kish_CAP", 2)
            CAPDispatcher:SetSquadronTakeoffInAir("Kish_CAP")
            CAPDispatcher:SetSquadronCap("Qeshm_CAP", Khasab_base, 4000, 8000, 600, 800, 800, 1200, "BARO")
            CAPDispatcher:SetSquadronCapInterval("Qeshm_CAP", 1, 180, 600, 1)
            missionCommands.removeItemForCoalition(coalition.side.BLUE, menuCAPextra)
            menuCAPextra = nil
            if (menuHardCore == nil) then
                missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
            end
            INV_mensaje(
                3,
                "Se informa que se ha detectado mayor presencia de Aviones enemigos en zona hostil.\n\nModo Hardcore A/A activado."
            )
            trigger.action.setUserFlag(581, 1)
        end,
        subMenuModos
    )
    menuHardCore =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO HARDCOCE **",
        subMenuModos,
        function()
            missionCommands.removeItemForCoalition(coalition.side.BLUE, menuHardCore)
            menuHardCore = nil
            if (menuCAPextra == nil) then
                missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
            end
            INV_mensaje(
                3,
                "Se informa de mayor presencia AntiAérea terrestre cercanos a los objetivos.\n\nModo Hardcore A/G activado."
            )
            Group.getByName("OBJ1_REFUERZO_HARDCORE"):activate()
            Group.getByName("OBJ5_SEAD_MV #003"):activate()
            trigger.action.setUserFlag(8001, 1)
        end,
        subMenuModos
    )
end

function golfoRutinas(timeloop, time)
    return time + 5
end

--[[ _barcoOBJ7 = UNIT:FindByName("OBJ7_barco")
_barcoOBJ7:HandleEvent(EVENTS.Dead)
function _barcoOBJ7:OnEventDead(event)
    -- MISSION 7
    INV_mensaje(2, "Destruido Crucero Moskva en Tunb Island.\n\nObjetivo realizado, buen trabajo!!!")
    missionCommands.removeItemForCoalition(coalition.side.BLUE, {"OBJETIVO 7 - CG 1164 MOSKVA"})
end ]]
-- MISION 6 sin hacer
trigger.action.setUserFlag(10, 0)
-- MOOSE SETTINGS
_SETTINGS:SetPlayerMenuOff()
-- initFunciones()
-- timer.scheduleFunction(checkCAP, 53, timer.getTime() + 10)
-- timer.scheduleFunction(golfoRutinas, 53, timer.getTime() + 10)
