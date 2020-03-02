-- GOLFO --
--
--
--
--                      INICIO FUNCIONES MISIONES - MENUS
--
--
--
function INVASION_RadioMenuSetup()
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
--[[             missionCommands.removeItemForCoalition(coalition.side.BLUE, menuHardCore)
            menuHardCore = nil
            if (menuCAPextra == nil) then
                missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
            end
            INV_mensaje(3, "Se informa de mayor presencia AntiAérea terrestre cercanos a los objetivos.\n\nModo Hardcore A/G activado.")
            Group.getByName("OBJ1_REFUERZO_HARDCORE"):activate()
            Group.getByName("OBJ5_SEAD_MV #003"):activate()
            trigger.action.setUserFlag(8001, 1) ]]
        end,
        subMenuModos
    )
    missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "DESARROLLO",
        subMenuModos,
        function()
            trigger.action.explosion(StaticObject.getByName("OBJ4_MANDO1"):getPosition().p, 2000)
            trigger.action.explosion(StaticObject.getByName("OBJ4_RADIO1"):getPosition().p, 2000)
            trigger.action.explosion(StaticObject.getByName("OBJ4_RADIO2"):getPosition().p, 2000)
        end,
        subMenuModos
    )
end

inicioMenu()
INVASION_RadioMenuSetup()

