    initMission = {}
    function initMission:onEvent(event)
        env.info("Inicio de evento")
        if event.id == world.event.S_EVENT_PLAYER_ENTER_UNIT then
            local _unit = event.initiator
            if _unit and _unit:getGroup() then
                local _group_id = Group.getID(Unit.getGroup(_unit))
                _nickName = Unit.getPlayerName(_unit)
                trigger.action.setUserFlag('555', 1)
                msg = "Bienvenido ".. Unit.getPlayerName(_unit) .." al servidor E111 de Misiones Libres\n\n"
                msg = msg .. "Acabas de unirte al grupo " .. Group.getName(Unit.getGroup(_unit)) .. "\n\n"
                msg = msg .. "Disfruta del vuelo!"
                trigger.action.outSoundForGroup( _group_id, "welcome.ogg")
                trigger.action.outTextForGroup(_group_id, msg, 10)
            end
        end
    end
    world.addEventHandler(initMission)