-- SYRIA --
--

inicioMenu()

    subMenuModos = missionCommands.addSubMenu("MODOS EXTRAS->")
    missionCommands.addCommand(
        "OBJ2",
        subMenuModos,
        function()
            trigger.action.explosion(Unit.getByName("Syria Waha SAM SA-3-1"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("Syria Waha SAM SA-3-2"):getPosition().p, 2000)
        end,
        subMenuModos
    )	
	    missionCommands.addCommand(
        "OBJ3",
        subMenuModos,
        function()
            trigger.action.explosion(Unit.getByName("BLNFRONTERA-1-1"):getPosition().p, 2000)
            trigger.action.explosion(Unit.getByName("BLNFRONTERA-1-2"):getPosition().p, 2000)
        end,
        subMenuModos
    )