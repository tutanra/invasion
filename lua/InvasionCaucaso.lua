--- CAUCASO ---
local function MissionCAPextra()
    missionCommands.removeItemForCoalition(coalition.side.BLUE, menuCAPextra)
    menuCAPextra = nil
    if (menuHardCore == nil) then
        missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
    end
    INV_mensaje(3,
                "Se informa que se ha detectado mayor presencia de enemigos A/A en zona hostil.\n\nModo Hardcore A/A activado.")
    CAPDispatcher:SetSquadron("CAP_general_extra", AIRBASE.Caucasus.Nalchik,
                              "GCI_extra")
    CAPDispatcher:SetSquadronOverhead("CAP_general_extra", 2)
    CAPDispatcher:SetSquadronCap("CAP_general_extra", FrontGRAL1, 4000, 8000,
                                 600, 800, 800, 1200, "BARO")
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
    INV_mensaje(3,
                "Se informa que se ha detectado mayor presencia de enemigos en zona hostil.\n\nModo Hardcore A/G activado.")
    trigger.action.setUserFlag(999, true)
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

function ConvoyStatus()
    local _statusCNV = trigger.misc.getUserFlag(441)
    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5 or _statusCNV == 7 or
        _statusCNV == 9) then
        local _msg = "Unidad pendiente de eliminación de puesto avanzado.\n\n"
        if (_statusCNV == 1) then
            _msg = _msg .. "Puesto avanzado de blindados en la Carretera."
        end
        if (_statusCNV == 3) then
            _msg = _msg ..
                       "Puesto de Defensas aéreas y artillería en el aeropuerto."
        end
        if (_statusCNV == 5) then
            _msg = _msg ..
                       "Puesto avanzado fortificado de blindados en puesto de Comunicaciones."
        end
        if (_statusCNV == 7) then
            _msg = _msg ..
                       "Puesto avanzado fortificado de blindados en el Puerto."
        end
        if (_statusCNV == 9) then
            _msg = _msg .. "Aeropuerto BATUMI necesita ser limpiado."
        end
        INV_mensaje(1, _msg)
    else
        if (_statusCNV == 99) then
            INV_mensaje(1, "Misión completada.")
        else
            INV_mensaje(1,
                        "Unidades en camino de Batumi por Carretera para la toma del Aeropuerto. Solicita las bengalas para conocer su situación.")
        end
    end
end

function MissionTruco()
    local _statusCNV = trigger.misc.getUserFlag(441)

    trigger.action
        .explosion(Unit.getByName("Unidad #019"):getPosition().p, 3000)
    trigger.action
        .explosion(Unit.getByName("Unidad #021"):getPosition().p, 3000)
    trigger.action
        .explosion(Unit.getByName("Unidad #071"):getPosition().p, 3000)
    trigger.action
        .explosion(Unit.getByName("Unidad #078"):getPosition().p, 3000)
    trigger.action.explosion(Unit.getByName("Unit #124"):getPosition().p, 3000)

    if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5) then
        local _msg = "Unidad pendiente de eliminación de puesto avanzado.\n\n"
        if (_statusCNV == 1) then
            trigger.action.explosion(Unit.getByName("OBJ4_1_1"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_1_2"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_1_3"):getPosition().p,
                                     1000)
        end
        if (_statusCNV == 3) then
            trigger.action.explosion(
                Unit.getByName("Unidad #211"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #207"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #209"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #210"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #211"):getPosition().p, 1000)
        end
        if (_statusCNV == 5) then
            trigger.action.explosion(Unit.getByName("OBJ4_3_1"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_2"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_3"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_4"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_5"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_6"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_7"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_3_8"):getPosition().p,
                                     1000)
        end
        if (_statusCNV == 7) then
            trigger.action.explosion(Unit.getByName("OBJ4_4_1"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_2"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_3"):getPosition().p,
                                     1000)
            trigger.action.explosion(Unit.getByName("OBJ4_4_4"):getPosition().p,
                                     1000)
        end
        if (_statusCNV == 9) then
            trigger.action.explosion(
                Unit.getByName("Unidad #154"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #147"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #151"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #148"):getPosition().p, 1000)
            trigger.action.explosion(
                Unit.getByName("Unidad #148"):getPosition().p, 1000)
        end
    end
end

function INVASION_RadioMenuSetup()
    local subMenuHelis = missionCommands.addSubMenuForCoalition(
                             coalition.side.BLUE, "OBJETIVO EXTRA CONVOY")
    missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                           "BENGALA CONVOY BATUMI",
                                           subMenuHelis, ConvoyBatumi, nil)
    missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                           "ESTADO DE LA MISIÓN", subMenuHelis,
                                           ConvoyStatus, nil)
    missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                           "ORDENA CONTINUAR AL CONVOY",
                                           subMenuHelis, function()
        local _status = trigger.misc.getUserFlag(441)
        if (_status == 3 or _status == 5 or _status == 7 or _status == 9) then
            continueGroup("BATUMI_WIN")
            trigger.action.setUserFlag(441, trigger.misc.getUserFlag(441) + 1)
        end
    end, nil)

    subMenuModos = missionCommands.addSubMenuForCoalition(coalition.side.BLUE,
                                                          "MODOS EXTRAS->")
    menuCAPextra = missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                                          "** MODO EXTRA CAP **",
                                                          subMenuModos,
                                                          MissionCAPextra,
                                                          subMenuModos)
    menuHardCore = missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                                          "** MODO HARDCOCE **",
                                                          subMenuModos,
                                                          MissionHardcore,
                                                          subMenuModos)
    missionCommands.addCommandForCoalition(coalition.side.BLUE,
                                           "MODO SIGUIENTE**NO TOCAR**",
                                           subMenuModos, MissionTruco,
                                           subMenuModos)
end

-- initFunciones()
inicioMenu()
INVASION_RadioMenuSetup()

-- MOOSE SETTINGS
_SETTINGS:SetPlayerMenuOff()
