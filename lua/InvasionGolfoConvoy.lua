-- CONVOY --
--
_gruposConvoy = "REFOBJ8"
_statusCNV = 0
--

function ConvoyGolfo()
    INV_mensaje(1, "Bengala de convoy lanzada, color Rojo.")
    if (checkAliveNumber(_gruposConvoy) > 0) then
        _unit = checkAlive(_gruposConvoy)
        if (_unit ~= nil) then
            for i = 1, 10 do
                timer.scheduleFunction(Bengala, _unit, timer.getTime() + i)
            end
        end
    end
end

function convoyOrder()
    env.info("CNV: ConvoyORDER")
    env.info("CNV: Estado variable : " .. _statusCNV)
    if
        ((_statusCNV == 1 and invasion_AG[11].Realizado == true) or (_statusCNV == 3 and invasion_AG[12].Realizado == true) or
            (_statusCNV == 5 and invasion_AG[16].Realizado == true))
     then
        continueConvoyForce()
    elseif
        ((_statusCNV < 2 and invasion_AG[11].Realizado == false) or (_statusCNV == 2 and invasion_AG[12].Realizado == false) or
            (_statusCNV == 4 and invasion_AG[16].Realizado == false))
     then
        stopConvoyForce()
    end
end

function continueConvoyForce()
    env.info("CNV: Convoy se mueve.")
    _statusCNV = _statusCNV + 1
    continueGroup(_gruposConvoy)
end

function stopConvoyForce()
    env.info("CNV: Convoy se para.")
    _statusCNV = _statusCNV + 1
    stopGroup(_gruposConvoy)
end

function ConvoyStatus()
    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5 or _statusCNV == 7 or _statusCNV == 9) then
        local _msg = "Unidad pendiente de eliminación de puesto avanzado.\n\n"
        if (_statusCNV == 1) then
            _msg = _msg .. "Puesto avanzado de blindados en la Carretera."
        end
        if (_statusCNV == 3) then
            _msg = _msg .. "Puesto froterizo de blindados en la Carretera."
        end
        if (_statusCNV == 5) then
            _msg = _msg .. "Puesto avanzado fortificado de blindados."
        end
        INV_mensaje(1, _msg)
    else
        if (_statusCNV == 99) then
            INV_mensaje(1, "Misión completada.")
        else
            INV_mensaje(1, "Unidades en camino de Batumi por Carretera para la toma del Aeropuerto. Solicita las bengalas para conocer su situación.")
        end
    end
end

function MissionTruco()
    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5) then
        if (_statusCNV == 1) then
            trigger.action.explosion(Unit.getByName("Unidad #371"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #370"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #372"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #373"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #374"):getPosition().p, 1000)
        end
        if (_statusCNV == 3) then
            trigger.action.explosion(Unit.getByName("Unidad #426"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #428"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #427"):getPosition().p, 1000)
        end
        if (_statusCNV == 5) then
            trigger.action.explosion(Unit.getByName("Unidad #413"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #412"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #408"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #410"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #407"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #493"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #404"):getPosition().p, 1000)
            trigger.action.explosion(Unit.getByName("Unidad #405"):getPosition().p, 1000)
        end
    end
end