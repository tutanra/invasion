-- GOLFO --
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
function INVASION_RadioMenuSetup()
    subMenuHelis = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "OBJETIVO EXTRA CONVOY")
    missionCommands.addCommandForCoalition(coalition.side.BLUE, "BENGALA CONVOY", subMenuHelis, ConvoyGolfo, nil)
    missionCommands.addCommandForCoalition(coalition.side.BLUE, "ESTADO DE LA MISIÓN", subMenuHelis, ConvoyStatus, nil)
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "ORDENA CONTINUAR AL CONVOY",
        subMenuHelis,
        function()
            if (_statusCNV == 1 or _statusCNV == 3 or _statusCNV == 5) then
                continueConvoyForce()
            end
        end,
        nil
    )
    -- missionCommands.addCommandForCoalition(coalition.side.BLUE, "MISSION TRUCO", subMenuHelis, MissionTruco, nil)

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
                _msg = _msg .. "-Support 1- Desde la base de Sharjah Intl hacía Lavan Island.\n\nInicia encendido de Motores."
                trigger.action.setUserFlag(10, 9)
                startGroup("SUPPORT")
            end
            INV_mensaje(1, _msg)
        end,
        nil
    )
    subMenuModos = missionCommands.addSubMenuForCoalition(coalition.side.BLUE, "MODOS EXTRAS->")
--[[    MOOOSE     
    menuCAPextra =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO EXTRA CAP **",
        subMenuModos,
        function()
            local Khasab_base = ZONE_AIRBASE:New(AIRBASE.PersianGulf.Khasab, 10000)
            CAPDispatcher:SetSquadron("Kish_CAP", AIRBASE.PersianGulf.Kish_International_Airport, {"KISH_SU30", "KISH_F14"})
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
            INV_mensaje(3, "Se informa que se ha detectado mayor presencia de Aviones enemigos en zona hostil.\n\nModo Hardcore A/A activado.")
            trigger.action.setUserFlag(581, 1)
        end,
        subMenuModos
    ) ]]
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
            INV_mensaje(3, "Se informa de mayor presencia AntiAérea terrestre cercanos a los objetivos.\n\nModo Hardcore A/G activado.")
            Group.getByName("OBJ1_REFUERZO_HARDCORE"):activate()
            Group.getByName("OBJ5_SEAD_MV #003"):activate()
            trigger.action.setUserFlag(8001, 1)
        end,
        subMenuModos
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "DESARROLLO",
        subMenuModos,
        function()
            trigger.action.explosion(Unit.getByName("Unidad #407"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #169"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #018"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #014"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #374"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #370"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #371"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #372"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #373"):getPosition().p, 2000)
        end,
        subMenuModos
    )
end

inicioMenu()
INVASION_RadioMenuSetup()

-- MISION 6 sin hacer
trigger.action.setUserFlag(10, 0)
