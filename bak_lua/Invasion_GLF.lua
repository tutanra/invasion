do  
    function INV_mensaje(_tipo, _texto, _forHelis)
        -- 1 TIPO MISION STATUS
        -- 2 TIPO ALERTA
        -- 3 TIPO PANICO
        -- 4 MISSION CUMPLIDA
        local _msg = ""
        local _snd = ""
        local _dst = ""
        _forHelis = _forHelis or false
        if (_tipo == 1) then
            _snd = "beep.ogg"
            _msg =
                "\nINFORMACIÓN DE MISIÓN\n---------------------------------------\n\n"
        elseif (_tipo == 2) then
            _snd = "Morse.ogg"
            _msg =
                "\nALERTA DE MISIÓN\n-----------------------------------------\n\n"
        elseif (_tipo == 3) then
            _snd = "sirena.ogg"
            _msg =
                "\nSERVICIO DE INTELIGENCIA\n-----------------------------------------\n\n"
        else
            _snd = "Morse.ogg"
            _msg = "\n"
        end
        
        if (_forHelis == false) then
            _dst = coalition.side.BLUE
            trigger.action.outTextForCoalition(_dst, _msg .. _texto .. "\n", 10, true)
            trigger.action.outSoundForCoalition(_dst, _snd)
        else
            env.info('Inicio de Helis')
            for i, _group in pairs(coalition.getGroups(coalition.side.BLUE, Group.Category.HELICOPTER)) do
                env.info(i)
                if _group ~= nil then
                    local _groupID = Group.getID(_group)
                    trigger.action.outSoundForGroup(_groupID, _snd)
                    trigger.action.outTextForGroup(_groupID, _msg .. _texto .. "\n", 10, true)
                end
            end
        end
    end
    
    env.info('Inicio de funciones personalizadas 0.1')
    
    -- detecta Unidades de CAP muertas por cualquier causa
    -- _all, toda la CAP ha de estar muerta
    function CAPdead(_grupoNombre, _all)
        local _all = _all or false
        local _group = Group.getByName(_grupoNombre)
        if not _group then return true end
        local _groupcontrl = Group.getController(_group)
        -- variable devolucion
        local _returnVar = false
        -- comprueba que todas la unidades están activas
        local _unitsGroup = Group.getInitialSize(_group)
        local _unitDead = 0
        for index, _unit in pairs(_group:getUnits()) do
            if not _unit or Controller.hasTask(_groupcontrl) == false or Unit.getLife(_unit) < 1 or Unit.isExist(_unit) == false or Unit.isActive(_unit) == false then
                env.info("Muerto : " .. _grupoNombre)
                _returnVar = true
                _unitDead = _unitDead + 1
                if _unitsGroup == _unitDead then
                    --[[ trigger.action.deactivateGroup( _group ) ]]
                    env.info("Todo el grupo")
                elseif _all == true then
                    _returnVar = false
                end
            end
        end
        return _returnVar
    end
    
    -- INICIAR CAP
    function CAPstart(_grupoNombre)
        local _group = Group.getByName(_grupoNombre)
        if not _group then return false end
        local _groupcontrl = Group.getController(_group)
        Controller.setCommand(_groupcontrl, {id = 'Start', params = {}})
    end
    
    -- ACCION DE TAREA IA ELEGIDA EN RANDOM
    -- numMAX : Tareas asignadas en la unidad a elegir
    function WPrandom(_grupoNombre, _numMAX)
        wpRandom = math.random(_numMAX)
        _group = Group.getByName(_grupoNombre)
        trigger.action.pushAITask(_group, wpRandom)
    --[[     local _groupcontrl = Group.getController( _group )
    Controller.setCommand( _groupcontrl, {id = 'StopRoute',params = { value = true, } } )
    ]]
    end
    
    -- NUMERO TOTAL DE AVIONES ENEMIGOS EN VUELO
    function totalAirplaneInAir()
        local _totalAirplane = 0
        for i, _group in pairs(coalition.getGroups(coalition.side.RED, Group.Category.HELICOPTER)) do
            if _group ~= nil then
                for j, _unit in pairs(_group:getUnits()) do
                    if _unit ~= nil and Unit.inAir(_unit) then
                        _totalAirplane = _totalAirplane + 1
                    end
                end
            end
        end
        env.info("Aviones : " .. _totalAirplane)
        return _totalAirplane
    end
    
    -- DETECCION DE REFUERZO CAP
    -- Si no hay nombre devuelve Boolean
    function refuerzoCAP(_numMAX, _grupoNombre)
        _grupoNombre = _grupoNombre or false
        env.info("Inicia refuerzo")
        local _avionesEnVuelo = 0
        for i, _group in pairs(coalition.getGroups(coalition.side.RED, Group.Category.AIRPLANE)) do
            if _group ~= nil then
                for j, _unit in pairs(_group:getUnits()) do
                    if _unit ~= nil and Unit.inAir(_unit) then
                        _avionesEnVuelo = _avionesEnVuelo + 1
                    end
                end
            end
        end
        env.info("Devuelve aviones" .. _avionesEnVuelo)
        if _numMAX <= _avionesEnVuelo then
            if _grupoNombre ~= false then
                CAPstart(_grupoNombre)
            else
                return true
            end
        else
            return false
        end
    end
    
    local function checkMision1()
        local _msg
        local grp = Group.getByName("DEFENSA_IRAN_SAQR_PORT")
        _msg = "Enemigos activos restantes : " .. table.getn(grp:getUnits())
        INV_mensaje(1, _msg)
    end
    
    local function checkMision2()
        local _msg
        local _unitsLife = trigger.misc.getUserFlag(2002)
        -- for i = 1, 5 do
        --     local _nameOBJ = "OBJ2." .. i
        --     env.info(_nameOBJ)
        --     local static_object = Unit.getByName(_nameOBJ)
        --     local health = static_object:getLife()-- Return an integer
        -- -- local _object = Object.getByName("OBJ2.".. i)
        -- -- if Unit.getByName("OBJ2.".. i):getLife() < 1 then _unitsLife = _unitsLife -1 end
        -- end
        _msg = "BASE QUIMICA ACTIVA : " .. _unitsLife .. " de 5"
        INV_mensaje(1, _msg)
    end
    
    local function checkMision3()
        INV_mensaje(1, "Buque Nuclear en camino a Al Jari - [D010] desde Shib Derab [CQ95]")
    end
    
    local function checkMision4()
        local _grp1 = Group.getByName("Defensa Aerea Khasab Aeropuerto")
        local _msg2 = "- Enemigos en zona Aeropuerto " .. table.getn(_grp1:getUnits()) .. " de " .. _grp1:getInitialSize() .. "\n"
        local _grp2 = Group.getByName("Defensa Aerea Khasab Puerto")
        local _msg3 = "- Enemigos en zona Puerto " .. table.getn(_grp2:getUnits()) .. " de " .. _grp2:getInitialSize() .. "\n"
        INV_mensaje(1, _msg2 .. _msg3)
    end
    
    local function MissionCAPextra()
        missionCommands.removeItemForCoalition(coalition.side.BLUE,{"** MODO CAP EXTRA **"})
        INV_mensaje(3, "Se informa que se ha detectado mayor presencia de Aviones enemigos en zona hostil.\n\nModo Hardcore A/A activado.")
        CAPstart("REFUERZO - CAP #001")
        trigger.action.setUserFlag(581,1)
    end
    
    local function MissionHardcore()
        missionCommands.removeItemForCoalition(coalition.side.BLUE,{"** MODO HARDCORE **"})
        INV_mensaje(3, "Se informa de mayor presencia AntiAérea terrestre cercanos a los objetivos.\n\nModo Hardcore A/G activado.")
        Group.getByName("OBJ1_REFUERZO_HARDCORE"):activate()
        trigger.action.setUserFlag(8001,1)
    end
    
    function INVASION_RadioMenuSetup()
        -- ////SetUp Menu
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "OBJETIVO 1 - BASE SAQR PORT", nil,
            function()checkMision1() end,
            nil)
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "OBJETIVO 2 - QUIMICA AL LIMAH", nil,
            function()checkMision2() end,
            nil)
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "OBJETIVO 3 - BUQUE NUCLEAR", nil,
            function()checkMision3() end,
            nil)
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "OBJETIVO 4 - LIMIPEZA DE KHASAB", nil,
            function()checkMision4() end,
            nil)
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "** MODO CAP EXTRA **", nil,
            function()MissionCAPextra() end,
            nil)
        missionCommands.addCommandForCoalition(coalition.side.BLUE,
            "** MODO HARDCORE **", nil,
            function()MissionHardcore() end,
            nil)
    end
    
    -- /// INICIO DE MISION
    _CAPnormal = {"CAP1", "CAP2"}
    _CAPextra = {"REDCAP", "WESTCAP"}
    _helis = {"HELIS1", "HELIS2"}
    _currentCAPnormal = {1, 2}
    _currentCAPextra = {1, 1}
    INVASION_RadioMenuSetup()
end
