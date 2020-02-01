-- Funciones --
-- dofile("lua\\InvasionCaucaso.lua")
env.info("----Inicio de funciones personalizadas 1.1----")
-- /// INICIO DE MISION
_CAPnormal = {{"BATUMI", 0}, {"SUJUMI", 0}, {"NALCHIK", 0}}
_CAPminima = 2

function INV_mensaje(_tipo, _texto, _forHelis)
    -- 1 TIPO MISION STATUS
    -- 2 TIPO ALERTA
    -- 3 TIPO PANICO
    -- 4 MISSION CUMPLIDA
    -- 5 STARTUP
    local _msg = ""
    local _snd = ""
    local _dst = ""
    _forHelis = _forHelis or false
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
        _snd = "Morse.ogg"
        _msg = "\n"
    elseif (_tipo == 5) then
        _snd = "sirena.ogg"
        _msg = "\nSERVICIO DE INTELIGENCIA\n-----------------------------------------\n\n"
    end

    if (_forHelis == false) then
        _dst = coalition.side.BLUE
        trigger.action.outTextForCoalition(_dst, _msg .. _texto .. "\n", 10, true)
        trigger.action.outSoundForCoalition(_dst, _snd)
    else
        env.info("Inicio de Helis")
        for i, _group in pairs(coalition.getGroups(coalition.side.BLUE, Group.Category.HELICOPTER)) do
            env.info(i)
            if _group ~= nil then
                local _groupID = Group.getID(_group)
                trigger.action.outSoundForGroup(_groupID, _snd)
                trigger.action.outTextForGroup(_groupID, _msg .. _texto .. "\n", 10, true)
            end
        end
    end
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

function checkAlivePercent(_groupName)
    local _group = Group.getByName(_groupName)
    local _totali = Group.getInitialSize(_group)
    local i = 0
    for j, _unit in pairs(_group:getUnits()) do
        if _unit ~= nil then
            i = 1
        end
    end
    return ((_totali - i) / _totali) * 100
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
    wpRandom = math.random(_numMAX)
    _group = Group.getByName(_grupoNombre)
    trigger.action.pushAITask(_group, wpRandom)
    --[[     local _groupcontrl = Group.getController( _group )
    Controller.setCommand( _groupcontrl, {id = 'StopRoute',params = { value = true, } } )
    ]]
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

function startGroup(_groupName)
    local _group = Group.getByName(_groupName)
    if (_group ~= nil) then
        local _groupcontrl = Group.getController(_group)
        local StartCommand = {id = 'Start', params = {}}
        _groupcontrl:SetCommand(StartCommand)
    end
end

function checkCAP(timeloop, time)
    if (trigger.misc.getUserFlag(44) == false) then
        local _totalSquadron =
            RA1ADispatcher:GetSquadron("Batumi_defend").ResourceCount + totalAirplaneGroup("BATUMI_MISSION_AIR")
        if (_totalSquadron == 0 or _totalSquadron == -999) then
            INV_mensaje(
                2,
                "Objetivo 4 -BATUMI- elminado. \n\nBlindados terrestres en toma de Aeropuerto en espera de la eliminación de blindados en la zona del aeropuerto.\n\nBuen trabajo!"
            )
            --[[         trigger.action.groupContinueMoving(Group.getByName("BATUMI_WIN")) ]]
            trigger.action.setUserFlag(44, true)
        end
    end
    if (trigger.misc.getUserFlag(55) == false) then
        local _totalSquadron =
            RA2ADispatcher:GetSquadron("Sujumi_defend").ResourceCount + totalAirplaneGroup("SUJUMI_MISSION_AIR")
        if (_totalSquadron == 0 or _totalSquadron == -999) then
            INV_mensaje(
                2,
                "Objetivo 5 -SUJUMI- elminado. \n\nBlindados terrestres en toma de Aeropuerto en espera de la eliminación de blindados en la zona del aeropuerto.\n\nBuen trabajo!"
            )
            --[[         trigger.action.groupContinueMoving(Group.getByName("BATUMI_WIN")) ]]
            trigger.action.setUserFlag(55, true)
        end
    end
    return time + 10
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

local function checkMision1()
    local _msg
    _msg = "OBJETIVO 1 EN ACTIVO\n----\nRecuerda destruir el edificio de municiones situado en el ala SurOeste."
    INV_mensaje(1, _msg)
end

local function checkMision2()
    local _msg = "OBJETIVO 2 EN ACTIVO\n----\nR"
    local grp1 = trigger.misc.getUserFlag("1001")
    _msg = _msg .. "- Helicopteros " .. grp1 .. " de 5\n"
    local grp2 = Group.getByName("OBJ2 BLINDADOS")
    _msg = _msg .. "- Blindados activos " .. table.getn(grp2:getUnits()) .. " de " .. grp2:getInitialSize() .. "\n"
    local grp3 = trigger.misc.getUserFlag("1002")
    _msg = _msg .. "- Almacenes " .. grp3 .. " de 4"
    INV_mensaje(1, _msg)
end

local function checkMision3()
    local _msg = "Convoy avistado mediante seguimiento, marcado en Mapa."
    local grp2 = Group.getByName("OBJ3 CONVOY 1")
    _msg = _msg .. "- Convoy Alpha " .. table.getn(grp2:getUnits()) .. " de " .. grp2:getSize() .. "\n"
    local grp3 = Group.getByName("OBJ3 CONVOY 2")
    _msg = _msg .. "- Convoy Bravo " .. table.getn(grp3:getUnits()) .. " de " .. grp3:getSize()
    INV_mensaje(1, _msg)
end

local function checkMision4()
    local _msg
    local _totalSquadron =
        RA1ADispatcher:GetSquadron("Batumi_defend").ResourceCount + totalAirplaneGroup("BATUMI_MISSION_AIR")

    if (_totalSquadron > 0) then
        _msg = "BATUMI\n\nEnemigos en activo actual : " .. _totalSquadron
    else
        _msg = "BATUMI\n\nCAP eliminada.\n\nElimina parte de la defensa del aeropuerto, blindados."
    end
    INV_mensaje(1, _msg)
end

local function checkMision5()
    local _msg
    local _totalSquadron =
        RA2ADispatcher:GetSquadron("Sujumi_defend").ResourceCount + totalAirplaneGroup("SUJUMI_MISSION_AIR")
    if (_totalSquadron > 0) then
        _msg = "SUJUMI\n\nEnemigos en activo actual : " .. _totalSquadron
    else
        _msg = "SUJUMI\n\nCAP eliminada.\n\nElimina parte de la defensa del aeropuerto, blindados."
    end
    INV_mensaje(1, _msg)
end

local function checkMision6()
    local _msg
    _msg = "Prototipo AWACS : "

    if (Unit.getByName("RSAWACSPILOT") ~= nil) then
        _msg = _msg .. "ACTIVO\n\n"
    else
        _msg = _msg .. "DERRIBADO\n\n"
    end
    INV_mensaje(1, _msg)
end

local function MissionCAPextra()
    missionCommands.removeItemForCoalition(coalition.side.BLUE, menuCAPextra)
    menuCAPextra = nil
    if (menuHardCore == nil) then
        missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
    end
    INV_mensaje(
        3,
        "Se informa que se ha detectado mayor presencia de enemigos A/A en zona hostil.\n\nModo Hardcore A/A activado."
    )
    CAPDispatcher:SetSquadron("CAP_general_extra", AIRBASE.Caucasus.Nalchik, "GCI_extra")
    CAPDispatcher:SetSquadronOverhead("CAP_general_extra", 2)
    CAPDispatcher:SetSquadronCap("CAP_general_extra", FrontGRAL1, 4000, 8000, 600, 800, 800, 1200, "BARO")
    CAPDispatcher:SetSquadronCapInterval("CAP_general_extra", 1, 60, 180, 1)
    CAPDispatcher:SetSquadronGci("CAP_general_extra", 900, 1200)
    CAPDispatcher:SetSquadronTakeoffInAir("CAP_general_extra")
end

local function MissionHardcore()
    missionCommands.removeItemForCoalition(coalition.side.BLUE, menuHardCore)
    menuHardCore = nil
    if (menuCAPextra == nil) then
        missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
    end
    INV_mensaje(
        3,
        "Se informa que se ha detectado mayor presencia de enemigos en zona hostil.\n\nModo Hardcore A/G activado."
    )
    trigger.action.setUserFlag(999, true)
end

local function Bengala(_unit)
    trigger.action.signalFlare(Unit.getPoint(_unit), trigger.flareColor.Red, 0)
end

local function ConvoyBatumi()
    INV_mensaje(1, "Bengala de convoy lanzada, color Rojo.")
    _unit = checkAlive("BATUMI_WIN")
    if (_unit ~= nil) then
        for i = 1, 10 do
            timer.scheduleFunction(Bengala, _unit, timer.getTime() + i)
        end
    end
end

local function ConvoySujumi()
    INV_mensaje(1, "Bengala de convoy lanzada, color Rojo.")
    _unit = checkAlive("SUJUMI_WIN")
    if (_unit ~= nil) then
        for i = 1, 10 do
            timer.scheduleFunction(Bengala, _unit, timer.getTime() + i)
        end
    end
end

function ConvoyStatus()
    local _statusCNV = trigger.misc.getUserFlag(441)
    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5 or _statusCNV == 7 or _statusCNV == 9) then
        local _msg = "Unidad pendiente de eliminación de puesto avanzado.\n\n"
        if (_statusCNV == 1) then
            _msg = _msg .. "Puesto avanzado de blindados en la Carretera."
        end
        if (_statusCNV == 3) then
            _msg = _msg .. "Puesto de Defensas aéreas y artillería en el aeropuerto."
        end
        if (_statusCNV == 5) then
            _msg = _msg .. "Puesto avanzado fortificado de blindados en puesto de Comunicaciones."
        end
        if (_statusCNV == 7) then
            _msg = _msg .. "Puesto avanzado fortificado de blindados en el Puerto."
        end
        if (_statusCNV == 9) then
            _msg = _msg .. "Aeropuerto BATUMI necesita ser limpiado."
        end
        INV_mensaje(1, _msg)
    else
        if (_statusCNV == 99) then
            INV_mensaje(1, "Misión completada.")
        else
            INV_mensaje(
                1,
                "Unidades en camino de Batumi por Carretera para la toma del Aeropuerto. Solicita las bengalas para conocer su situación."
            )
        end
    end
end

function MissionTruco()
    local _statusCNV = trigger.misc.getUserFlag(441)
    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5) then
        local _msg = "Unidad pendiente de eliminación de puesto avanzado.\n\n"
        if (_statusCNV == 1) then
            trigger.action.explosion(Unit.getByName("OBJ4_1_1"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_1_2"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_1_3"):getPosition().p, 1000)
        end
        if (_statusCNV == 3) then
            trigger.action.explosion(Unit.getByName("Unidad #211"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #207"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #209"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #210"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #211"):getPosition().p, 1000)
        end
        if (_statusCNV == 5) then
            trigger.action.explosion(Unit.getByName("OBJ4_3_1"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_2"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_3"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_4"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_5"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_6"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_7"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_8"):getPosition().p, 1000)
        end
        if (_statusCNV == 7) then
            trigger.action.explosion(Unit.getByName("OBJ4_4_1"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_2"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_3"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_4"):getPosition().p, 1000)
        end
        if (_statusCNV == 9) then
            trigger.action.explosion(Unit.getByName("Unidad #154"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #147"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #151"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #148"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #148"):getPosition().p, 1000)
        end
    end
end

function INVASION_RadioMenuSetup()
    -- ////SetUp Menu
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 1 - PUESTO TSJINVALI",
        nil,
        function()
            checkMision1()
        end,
        nil
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 2 - AVANZADA GUPTA",
        nil,
        function()
            checkMision2()
        end,
        nil
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 3 - CONVOY",
        nil,
        function()
            checkMision3()
        end,
        nil
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 4 - BATUMI",
        nil,
        function()
            checkMision4()
        end,
        nil
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 5 - SUJUMI",
        nil,
        function()
            checkMision5()
        end,
        nil
    )
    local subMenuHelis = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "OBJETIVO EXTRA CONVOY")
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "BENGALA CONVOY BATUMI",
        subMenuHelis,
        ConvoyBatumi,
        nil
    )
    missionCommands.addCommandForCoalition(coalition.side.BLUE, "ESTADO DE LA MISIÓN", subMenuHelis, ConvoyStatus, nil)

    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "OBJETIVO 6 - AWACS",
        nil,
        function()
            checkMision6()
        end,
        nil
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "ORDENA CONTINUAR AL CONVOY",
        subMenuHelis,
        function()
            local _status = trigger.misc.getUserFlag(441)
            if (_status == 3 or _status == 5 or _status == 7 or _status == 9) then
                continueGroup("BATUMI_WIN")
                trigger.action.setUserFlag(441, trigger.misc.getUserFlag(441) + 1)
            end
        end,
        nil
    )

    subMenuModos = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "MODOS EXTRAS->")
    menuCAPextra =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO EXTRA CAP **",
        subMenuModos,
        MissionCAPextra,
        subMenuModos
    )
    menuHardCore =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO HARDCOCE **",
        subMenuModos,
        MissionHardcore,
        subMenuModos
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "MODO SIGUIENTE**NO TOCAR**",
        subMenuModos,
        MissionTruco,
        subMenuModos
    )
end

-- MOOSE SETTINGS
_SETTINGS:SetPlayerMenuOff()
-- initFunciones()
INVASION_RadioMenuSetup()
timer.scheduleFunction(checkCAP, 53, timer.getTime() + 10)
