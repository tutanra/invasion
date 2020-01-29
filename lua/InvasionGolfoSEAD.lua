-- OBJ5 SEAD --
-- Determina la entrada en zona de enemigos -> SEADon Enciende radares
-- Determina si la entrada lanza misil -> SEADmove Apaga radares y mueve a zona aleatoria
-- Salida de zona --> SEADoff
--
--  OBJ5_SEAD -> grupos fijos
--  OBJ5_SEAD_MV -> grupos con posibilidad de moverse, creación de 4 puntos
--
_SEADinit = timer.getTime()
_SEADstatusRed = false

function setAlarmGroup(_group, _state)
    local _groupcontrl = Group.getController(_group)
    env.info("Grupo para SEAD : " .. _group:getName())
    if (_state == true) then
        _groupcontrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.RED)
        env.info("On")
    else
        _groupcontrl:setOption(AI.Option.Ground.id.ALARM_STATE, AI.Option.Ground.val.ALARM_STATE.GREEN)
        env.info("Off")
    end
end

local function SEADaction(_groupName, _status)
    local i = 0
    _group = Group.getByName(_groupName)
    while (_group ~= nil) do
        setAlarmGroup(_group, _status)
        i = i + 1
        _group = Group.getByName(_groupName .. " #00" .. i)
    end
    _SEADstatusRed = _status
end

function SEADon()
    if (_SEADstatusRed == false and (timer.getTime() - _SEADinit) > 5) then
        SEADaction("OBJ5_SEAD", true)
        SEADaction("OBJ5_SEAD_MV", true)
        _SEADinit = timer.getTime()
    end
end

function SEADoff(_force)
    _force = _force or false
    if (_SEADstatusRed == true) then
        if (_force == true or ((timer.getTime() - _SEADinit) > 5 and _force == false)) then
            SEADaction("OBJ5_SEAD", false)
            SEADaction("OBJ5_SEAD_MV", false)
            _SEADinit = timer.getTime()
        end
    end
end

function SEADmove(_activateSEAD)
    local i = 0
    local _groupName = "OBJ5_SEAD_MV"
    _activateSEAD = _activateSEAD or false
    if (_activateSEAD) then
        SEADoff(true)
    end
    _group = Group.getByName(_groupName)
    while (_group ~= nil) do
        WPrandom(_group, 4)
        i = i + 1
        _group = Group.getByName(_groupName .. " #00" .. i)
    end
end
