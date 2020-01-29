do
    
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
    
end









21600