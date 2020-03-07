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
    menuCAPextra =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO EXTRA CAP **",
        subMenuModos,
        function()
            gcicap.gci.template_prefix = "__HARDCORE__"
            gcicap.cap.template_prefix = "__CAP2__"
            getAllActiveAircrafts("red")
            garbageCollector("red")
            menuCAPextra = nil
            if (menuHardCore == nil) then
                missionCommands.removeItemForCoalition(coalition.side.BLUE, subMenuModos)
            end
            INV_mensaje(3, "Se informa que se ha detectado mayor presencia de Aviones enemigos en zona hostil.\n\nModo Hardcore A/A activado.")
        end,
        subMenuModos
    )
--[[     menuHardCore =
        missionCommands.addCommandForCoalition(
        coalition.side.BLUE,
        "** MODO HARDCORE A/T **",
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
            trigger.action.explosion(Unit.getByName("Unidad #006"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #005"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Unidad #007"):getPosition().p, 2000)
        end,
        subMenuModos
    ) ]]
end

inicioMenu()
INVASION_RadioMenuSetup()

