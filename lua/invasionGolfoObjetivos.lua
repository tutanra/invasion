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
        VerEstado = true,
        Realizado = false
    }
    invasion_AG[2] = {
        NombreObjetivo = "QUIMICA AL LIMAH",
        Unidades = {"OBJ2.1", "OBJ2.2", "OBJ2.3", "OBJ2.4", "OBJ2.5"},
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "BASE QUIMICA DESTRUIDA : ",
        VerEstado = true,
        Realizado = false
    }
    invasion_AG[3] = {
        NombreObjetivo = "BUQUE NUCLEAR",
        Unidades = "ConvoyNuclear",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Buque Nuclear en camino a Al Jari - [D010] desde Shib Derab [CQ95]",
        VerEstado = false,
        Realizado = false
    }
    invasion_AG[4] = {
        NombreObjetivo = "LIMPIEZA DE KHASAB",
        Unidades = {
            "Defensa Aerea Khasab Aeropuerto", "Defensa Aerea Khasab Puerto"
        },
        UnidadesTipo = "grupo",
        Porcentaje = 20,
        TextoObjetivo = {
            "- Enemigos en zona Aeropuerto ", "- Enemigos en zona Puerto "
        },
        TextoCumplir = "Elimina el 80% de las fuerzas enemigas para realizar captura.",
        VerEstado = true,
        Realizado = false
    }
    invasion_AG[5] = {
        NombreObjetivo = "PUESTO DE MANDO",
        Unidades = "OBJ5_1",
        UnidadesTipo = "estatico",
        Porcentaje = 100,
        TextoObjetivo = "Objetivo pendiente de eliminación.",
        VerEstado = false,
        Realizado = false
    }
    invasion_AG[6] = {
        NombreObjetivo = "CG 1164 MOSKVA",
        Unidades = "OBJ7_barco",
        UnidadesTipo = "unidad",
        Porcentaje = 100,
        TextoObjetivo = "Crucero Moskva en Bandar e-Lengeh, eliminación pendiente.",
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
                _unidadesActivas = _unidadesActivas + 1
            end
            _unidadesTotales = _unidadesTotales + 1
        end
    elseif (_tipo == "estatico") then
        for j, _unitName in ipairs(_objetivo) do
            local _unit = StaticObject.getByName(_unitName)
            if (_unit ~= nil) then
                _unidadesActivas = _unidadesActivas + 1
            end
            _unidadesTotales = _unidadesTotales + 1
        end
    end
    if (_unidadesTotales == 0) then return false end
    if (_unidadesTotales > 1) then
        return _unidadesActivas .. " de " .. _unidadesTotales
    else
        return _unidadesActivas
    end
end

function inicioMenu()
    for j, _menu in pairs(invasion_AG) do
        -- ////SetUp Menu
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                               "OBJETIVO " .. j .. " - " ..
                                                   _menu.NombreObjetivo, nil,
                                               function()
            local _msg
            _msg = "OBJETIVO -" .. j .. " - " .. _menu.NombreObjetivo .. "\n\n"
            if (_menu.VerEstado) then
                if (type(_menu.TextoObjetivo) == "string") then
                    _msg = _msg .. _menu.TextoObjetivo
                    _msg = _msg ..
                               unidadesActivas(_menu.UnidadesTipo,
                                               _menu.Unidades)
                else
                    for j, _unitName in ipairs(_menu.Unidades) do
                        _msg = _msg .. _menu.TextoObjetivo[j]
                        _msg = _msg ..
                                   unidadesActivas(_menu.UnidadesTipo, _unitName) ..
                                   "\n"
                    end
                end
            else
                _msg = _msg .. _menu.TextoObjetivo
            end
            if (_menu.TextoCumplir) then
                _msg = _msg .. "\n" .. _menu.TextoCumplir
            end
            INV_mensaje(1, _msg)
        end, nil)
    end
end

inicioObjetivos()
inicioMenu()
INVASION_RadioMenuSetup()

missionCommands.addCommandForCoalition(coalition.side.BLUE, "PREUBA", nil,
                                       function()
    trigger.action.explosion(StaticObject.getByName("OBJ5_1"):getPosition().p,
                             1000)
end, nil)

function checkMissionDead(_category)
    for j, _menu in pairs(invasion_AG) do
        if (_menu.Realizado == false) then
            if (_category == 3 and _menu.UnidadesTipo == "estatico") then
                if (unidadesActivas(_menu.UnidadesTipo, _menu.Unidades) == false) then
                    env.info("Mision cumplida")
                end
            elseif (_category == 1 and _menu.UnidadesTipo ~= "estatico") then
                if (unidadesActivas(_menu.UnidadesTipo, _menu.Unidades) == false) then
                    env.info("Mision cumplida")
                end
            end
        end
    end
end

eventHandler = {}
function eventHandler:onEvent(_eventDCS)
    env.info("Evento")
    if _eventDCS == nil or _eventDCS.initiator == nil then return true end
    env.info(Object.getCategory(_eventDCS.initiator))
    if (_eventDCS.id == 8) then
        -- MUERTE
        local _categoria = Object.getCategory(_eventDCS.initiator)
        if (_categoria == 3 or _categoria == 1) then
            checkMissionDead(_categoria)
        end
    end
end

world.addEventHandler(eventHandler)
