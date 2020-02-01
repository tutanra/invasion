-- OBJETIVOS --
invasion_AG = {}
menusDinamicos = {}

function inicioObjetivos()
    -- ABU MUSA ISLAND
    invasion_AG[1] = {
        NombreObjetivo = "BASE SAQR PORT",
        Unidades = "DEFENSA_IRAN_SAQR_PORT",
        UnidadesTipo = "grupo", -- "grupo, unidad, estatico"
        Porcentaje = 100, -- porcentaje de unidad destruido
        TextoObjetivo = "UNIDADES RESTANTES : ",
        Completado = "OBJETIVO 1 - ATAQUE REFUERZO A SQR PORT REALIZADO.\n\nBuen trabajo !!",
        VerEstado = true,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[2] = {
        NombreObjetivo = "QUIMICA AL LIMAH",
        Unidades = {"OBJ2 #004", "OBJ2 #001", "OBJ2 #002", "OBJ2 #003", "OBJ2 #005"},
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "BASES QUIMICAS ACTIVAS : ",
        Completado = "OBJETIVO 2 - COMPLETADO, BASES QUIMICAS NEUTRALIZADAS.\n\nBuen Trabajo !!!",
        VerEstado = true,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[3] = {
        NombreObjetivo = "BUQUE NUCLEAR",
        Unidades = "ObjNuclear",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Buque Nuclear en camino a Al Jari - [D010] desde Shib Derab [CQ95]",
        Completado = "OBJETIVO 3 - BUQUE NUCLEAR DESTRUIDO.\n\nBuen trabajo !!",
        VerEstado = false,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[4] = {
        NombreObjetivo = "LIMPIEZA DE KHASAB",
        Unidades = {
            "Defensa Aerea Khasab Aeropuerto",
            "Defensa Aerea Khasab Puerto"
        },
        UnidadesTipo = "grupo",
        Porcentaje = 80,
        TextoObjetivo = {
            "- Enemigos en zona Aeropuerto ",
            "- Enemigos en zona Puerto "
        },
        TextoCumplir = "Elimina el 80% de las fuerzas enemigas para realizar captura.",
        Completado = "OBJETIVO 4 - LIMPIEZA DE KHASAB CONCLUIDA.\n\nBuen trabajo !!",
        VerEstado = true,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[5] = {
        NombreObjetivo = "PUESTO DE MANDO",
        Unidades = "OBJ5_1",
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "Objetivo pendiente de eliminación.",
        Completado = "OBJETIVO 5 - PUESTO DE MANDO AVANZADO DESTRUIDO.\n\nBuen trabajo !!",
        VerEstado = false,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[6] = {
        NombreObjetivo = "CG 1164 MOSKVA",
        Unidades = "OBJ7_barco",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Crucero Moskva en Bandar e-Lengeh, eliminación pendiente.",
        Completado = "Destruido Crucero Moskva en Bandar e-lengeh.\n\nObjetivo realizado, buen trabajo!!!",
        VerEstado = false,
        Realizado = false,
        Dinamico = false
    }
    invasion_AG[6] = {
        NombreObjetivo = "CASERNA DE MONTAÑA",
        Unidades = "OBJDIN1",
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "ELIMINA ESTRUCTURA MILITAR.",
        Completado = "Destruido Caserna de montaña.\n\nObjetivo dinámico realizado, buen trabajo!!!",
        ZonaBusqueda = "[26'04'16N - 56'12'13E]",
        VerEstado = false,
        Realizado = false,
        Dinamico = true
    }

    invasion_AG[7] = {
        NombreObjetivo = "FUERZA OCUPACIÓN",
        Unidades = "OBJDIN2",
        UnidadesTipo = "grupo",
        Porcentaje = 100,
        TextoObjetivo = "2 BLINDADOS Y 2 FORTIFICACIONES.",
        Completado = "Destruido Fuerza de Ocupación.\n\nObjetivo dinámico realizado, buen trabajo!!!",
        ZonaBusqueda = "[26'04'25N - 56'13'00E]",
        VerEstado = false,
        Realizado = false,
        Dinamico = true
    }
    invasion_AG[8] = {
        NombreObjetivo = "FUERZA OCUPACIÓN VILLA",
        Unidades = "OBJDIN2 #001",
        UnidadesTipo = "grupo",
        Porcentaje = 100,
        TextoObjetivo = "4 BLINDADOS E INFANTERIA.",
        Completado = "Destruido Fuerza de Ocupación en VILLA.\n\nObjetivo dinámico realizado, buen trabajo!!!",
        ZonaBusqueda = "[26'05'38N - 56'13'37E]",
        VerEstado = false,
        Realizado = false,
        Dinamico = true
    }
end

function unidadesActivas(_tipo, _objetivo)
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
    end
    if (_unidadesTotales > 1) then
        return _unidadesActivas .. " de " .. _unidadesTotales
    else
        return _unidadesActivas
    end
end

function misionesDinamicas(_groupID)
    local i = 0
    local _msg = ""
    env.info("Accion de grupo")
    for j, _menu in pairs(invasion_AG) do
        if (_menu.Dinamico == true and _menu.Realizado == false) then
            if (i > 0) then
                _msg = _msg .. "\n\n"
            end
            _msg =
                _msg ..
                "[" ..
                    getCordenadas(_menu.Unidades, _menu.UnidadesTipo) ..
                        "] (" .. j ..") ".. _menu.NombreObjetivo .. " - " .. _menu.TextoObjetivo
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
                            _msg = _msg .. unidadesActivas(_menu.UnidadesTipo, _menu.Unidades)
                        else
                            for j, _unitName in ipairs(_menu.Unidades) do
                                _msg = _msg .. _menu.TextoObjetivo[j]
                                _msg = _msg .. unidadesActivas(_menu.UnidadesTipo, _unitName) .. "\n"
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
            trigger.action.markToCoalition(
                j,
                _menu.NombreObjetivo .. "\n" .. _menu.TextoObjetivo,
                getVec3FromMission(_menu.Unidades, _menu.UnidadesTipo),
                coalition.side.BLUE,
                true
            )
        end
    end
end

function menuDinamico(_groupID)
    if (menusDinamicos[_groupID] == nil) then
        menusDinamicos[_groupID] =
            missionCommands.addCommandForGroup(_groupID, "MISIONES DINAMICAS->", nil, misionesDinamicas, _groupID)
    end
end

inicioObjetivos()
inicioMenu()
INVASION_RadioMenuSetup()

missionCommands.addCommandForCoalition(
    coalition.side.BLUE,
    "DESARROLLO",
    subMenuModos,
    function()
        trigger.action.explosion(Unit.getByName("Unidad #170"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #103"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #169"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #018"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #014"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #013"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #010"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #016"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #005"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #006"):getPosition().p, 2000)
        trigger.action.explosion(Unit.getByName("Unidad #009"):getPosition().p, 2000)
        trigger.action.explosion(StaticObject.getByName("OBJDIN1"):getPosition().p, 500)
        trigger.action.explosion(StaticObject.getByName("OBJ2 #005"):getPosition().p, 500)
        trigger.action.explosion(StaticObject.getByName("OBJ2 #001"):getPosition().p, 500)
    end,
    subMenuModos
)

local function missionCompleteUnit(_tipo, _unidad, _porcentaje)
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
    end
end

local function missionComplete(_objetivo)
    if (type(_objetivo.Unidades) == "string") then
        -- env.info("Evento : " .. _objetivo.Unidades)
        return missionCompleteUnit(_objetivo.UnidadesTipo, _objetivo.Unidades, _objetivo.Porcentaje)
    else
        local _itemComplete = 0
        local _totalItems = 0
        for j, _unitName in ipairs(_objetivo.Unidades) do
            -- env.info("Evento array : " .. _unitName)
            if (_objetivo.UnidadesTipo == "grupo") then
                if (missionCompleteUnit(_objetivo.UnidadesTipo, _unitName, _objetivo.Porcentaje) == false) then
                    return false
                else
                    _itemComplete = _itemComplete + 1
                end
            else
                if (missionCompleteUnit(_objetivo.UnidadesTipo, _unitName, _objetivo.Porcentaje) == true) then
                    _itemComplete = _itemComplete + 1
                end
            end
            _totalItems = _totalItems + 1
        end
        if
            (_objetivo.Porcentaje == 100 and _itemComplete == _totalItems) or
                (_objetivo.UnidadesTipo == "grupo" and _totalItems == _itemComplete)
         then
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
                    env.info(_nombreMision)
                    _menu.Realizado = true
                    INV_mensaje(2, _menu.Completado)
                    if (_menu.Dinamico == false) then
                        missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
                    end
                end
            elseif (_category == 1 and _menu.UnidadesTipo ~= "estatico") then
                if (missionComplete(_menu) == true) then
                    local _nombreMision = "OBJETIVO " .. j .. " - " .. _menu.NombreObjetivo
                    env.info(_nombreMision)
                    _menu.Realizado = true
                    INV_mensaje(2, _menu.Completado)
                    if (_menu.Dinamico == false) then
                        missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
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
    if (_eventDCS.id == 8) then
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
            _msg =
                _msg ..
                "Importante la lectura del Briefing, posibilidad de Objetivos extras y misiones dinámicas.\n\nSimpleRadio activado."
            timer.scheduleFunction(
                function()
                    INV_mensaje(
                        1,
                        _msg,
                        false,
                        "Bienvenido " .. _plrName .. " - Grupo " .. Group.getName(Unit.getGroup(_eventDCS.initiator)),
                        _groupID
                    )
                end,
                {},
                timer.getTime() + 2
            )
        end
    end
end

world.addEventHandler(eventHandler)
