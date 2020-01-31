-- OBJETIVOS --
invasion_AG = {}

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
        Realizado = false
    }
    invasion_AG[2] = {
        NombreObjetivo = "QUIMICA AL LIMAH",
        Unidades = {"OBJ2.1", "OBJ2.2", "OBJ2.3", "OBJ2.4", "OBJ2.5"},
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "BASE QUIMICA DESTRUIDA : ",
        Completado = "OBJETIVO 2 - COMPLETADO, BASES QUIMICAS NEUTRALIZADAS.\n\nBuen Trabajo !!!",
        VerEstado = true,
        Realizado = false
    }
    invasion_AG[3] = {
        NombreObjetivo = "BUQUE NUCLEAR",
        Unidades = "ObjNuclear",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Buque Nuclear en camino a Al Jari - [D010] desde Shib Derab [CQ95]",
        Completado = "OBJETIVO 3 - BUQUE NUCLEAR DESTRUIDO.\n\nBuen trabajo !!",
        VerEstado = false,
        Realizado = false
    }
    invasion_AG[4] = {
        NombreObjetivo = "LIMPIEZA DE KHASAB",
        Unidades = {
            "Defensa Aerea Khasab Aeropuerto",
            "Defensa Aerea Khasab Puerto"
        },
        UnidadesTipo = "grupo",
        Porcentaje = 20,
        TextoObjetivo = {
            "- Enemigos en zona Aeropuerto ",
            "- Enemigos en zona Puerto "
        },
        TextoCumplir = "Elimina el 80% de las fuerzas enemigas para realizar captura.",
        Completado = "OBJETIVO 4 - LIMPIEZA DE KHASAB CONCLUIDA.\n\nBuen trabajo !!",
        VerEstado = true,
        Realizado = false
    }
    invasion_AG[5] = {
        NombreObjetivo = "PUESTO DE MANDO",
        Unidades = "OBJ5_1",
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "Objetivo pendiente de eliminación.",
        Completado = "OBJETIVO 5 - PUESTO DE MANDO AVANZADO DESTRUIDO.\n\nBuen trabajo !!",
        VerEstado = false,
        Realizado = false
    }
    invasion_AG[6] = {
        NombreObjetivo = "CG 1164 MOSKVA",
        Unidades = "OBJ7_barco",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Crucero Moskva en Bandar e-Lengeh, eliminación pendiente.",
        Completado = "Destruido Crucero Moskva en Bandar e-lengeh.\n\nObjetivo realizado, buen trabajo!!!",
        VerEstado = false,
        Realizado = false
    }
end

function unidadesActivas(_tipo, _objetivo)
    local _unidadesActivas = 0
    local _unidadesTotales = 0
    if (_tipo == "grupo") then
        local _group = Group.getByName(_objetivo)
        _unidadesActivas = table.getn(_group:getUnits())
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

function inicioMenu()
    for j, _menu in pairs(invasion_AG) do
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
    end
end

inicioObjetivos()
inicioMenu()
INVASION_RadioMenuSetup()

missionCommands.addCommandForCoalition(
    coalition.side.BLUE,
    "EXPLOSION",
    nil,
    function()
        trigger.action.explosion(Unit.getByName("ObjNuclear"):getPosition().p, 500)
    end,
    nil
)

local function missionCompleteUnit(_tipo, _unidad, _porcentaje)
    if (_tipo == "grupo") then
        local _unidadesPercent = checkAlivePercent(_unidad)
        if (_porcentaje == 100) then
            if (_unidadesPercent == 0) then
                return true
            end
        else
            if (_unidadesPercent <= _porcentaje) then
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
            return false
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
        --[[         env.info("Porcentaje : " .. _objetivo.Porcentaje)
        env.info("Items completes : " .. _itemComplete)
        env.info("Items _totalItems : " .. _totalItems)
        env.info("En porcentaje " .. (100 - (_itemComplete / _totalItems) * 100))
 ]]
        if (_objetivo.Porcentaje == 100 and _itemComplete == _totalItems) then
            return true
        elseif (_objetivo.Porcentaje < 100) then
            if (_objetivo.Porcentaje <= (100 - (_itemComplete / _totalItems) * 100)) then
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
                    missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
                end
            elseif (_category == 1 and _menu.UnidadesTipo ~= "estatico") then
                if (missionComplete(_menu) == true) then
                    local _nombreMision = "OBJETIVO " .. j .. " - " .. _menu.NombreObjetivo
                    env.info(_nombreMision)
                    _menu.Realizado = true
                    INV_mensaje(2, _menu.Completado)
                    missionCommands.removeItemForCoalition(coalition.side.BLUE, {_nombreMision})
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
    end
end

world.addEventHandler(eventHandler)
