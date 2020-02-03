-- Objetivo4 --
-- dofile("lua\\InvasionCaucasoOBJ4.lua")
env.info("------ Inicio Funciones Convoy BATUMI ------")
_interaccion1 = false

-- PUESTO 1
local _puesto1 = GROUP:FindByName("OBJ4_PUESTO_1")
local _retirada_puesto1 = ZONE:New("OBJ4_PUESTO_1_RETIRADA")
local _supresion = SUPPRESSION:New(_puesto1)
_supresion:SetRetreatZone(_retirada_puesto1)
_supresion:Fallback(true)
_supresion:Takecover(true)
_supresion:__Start(5)

-- INICIO, CONVOY HACIA PUESTO 1
trigger.action.setUserFlag(441, 0)

function MissionControl4(timeloop, time)
    local _estadoMision = trigger.misc.getUserFlag(441)
    -- OBJETIVO PUESTO 1
    if (_estadoMision == 1) then
        -- SIGUIENTE OBJETIVO PUESTO 3
        if
            (Unit.getByName("OBJ4_1_1") == nil and Unit.getByName("OBJ4_1_2") == nil and
                Unit.getByName("OBJ4_1_3") == nil)
         then
            env.info("Eliminado Puesto 1")
            -- SIGNIFICA QUE EL CONVOY ESTÁ PARADO Y DA EL AVISO DE OBJ CUMPLIDO
            if (_interaccion1 == false) then
                INV_mensaje(2, "Puesto eliminado. \n\nBlindados terrestres hacía objetivo.")
                trigger.action.setUserFlag(441, 2)
            else
                _interaccion1 = false
            end
            continueGroup("RFZ_OBJ4_PUESTO_1")
            continueGroup("RFZ_OBJ4_PUESTO_1 #001")
            continueGroup("RFZ_OBJ4_PUESTO_1 #002")
            continueGroup("RFZ_OBJ4_PUESTO_1 #003")
            continueGroup("BATUMI_WIN")
        else
            -- PRIMERA INTERACCION AVISO DE AMENAZA
            if (_interaccion1 == false) then
                INV_mensaje(
                    2,
                    "Puesto avanzado. \n\nElimina los APC del puesto avanzado a 1 milla por carretera del convoy."
                )
                _interaccion1 = true
            end
        end
    elseif (_estadoMision == 3) then
        -- SIGUIENTE OBJETIVO PUESTO 3
        if (checkAlive("OBJ4_PUESTO_2") == nil) then
            env.info("Eliminado Puesto 2")
            -- SIGNIFICA QUE EL CONVOY ESTÁ PARADO Y DA EL AVISO DE OBJ CUMPLIDO
            if (_interaccion1 == false) then
                INV_mensaje(2, "Puesto aeropuerto eliminado. \n\nBlindados terrestres continúan hacía objetivo.")
                trigger.action.setUserFlag(441, 4)
            else
                _interaccion1 = false
            end
            continueGroup("RFZ_OBJ4_PUESTO_2")
            continueGroup("RFZ_OBJ4_PUESTO_2 #001")
            continueGroup("RFZ_OBJ4_PUESTO_2 #002")
            continueGroup("BATUMI_WIN")
        else
            env.info(trigger.misc.getUserFlag(441))
            -- PRIMERA INTERACCION AVISO DE AMENAZA
            if (_interaccion1 == false) then
                INV_mensaje(
                    2,
                    "Puesto avanzado. \n\nElimina los Shilka y los blindados de infantería del Aeropuerto X."
                )
                _interaccion1 = true
            end
        end
    elseif (_estadoMision == 5) then
        -- SIGUIENTE OBJETIVO PUESTO 3
        if
            (Unit.getByName("OBJ4_3_1") == nil and Unit.getByName("OBJ4_3_2") == nil and
                Unit.getByName("OBJ4_3_3") == nil and
                Unit.getByName("OBJ4_3_4") == nil and
                Unit.getByName("OBJ4_3_5") == nil and
                Unit.getByName("OBJ4_3_6") == nil and
                Unit.getByName("OBJ4_3_7") == nil and
                Unit.getByName("OBJ4_3_8") == nil)
         then
            env.info("Eliminado Puesto 3")
            -- SIGNIFICA QUE EL CONVOY ESTÁ PARADO Y DA EL AVISO DE OBJ CUMPLIDO
            if (_interaccion1 == false) then
                INV_mensaje(2, "Puesto Comuniaciones eliminado. \n\nBlindados terrestres continúan hacía objetivo.")
                trigger.action.setUserFlag(441, 6)
            else
                _interaccion1 = false
            end
            continueGroup("RFZ_OBJ4_PUESTO_3")
            continueGroup("RFZ_OBJ4_PUESTO_3 #001")
            continueGroup("RFZ_OBJ4_PUESTO_3 #002")
            continueGroup("RFZ_OBJ4_PUESTO_3 #003")
            continueGroup("BATUMI_WIN")
        else
            -- PRIMERA INTERACCION AVISO DE AMENAZA
            if (_interaccion1 == false) then
                INV_mensaje(2, "Puesto avanzado. \n\nElimina avanzada situada en el centro de Comunicaciones.")
                _interaccion1 = true
            end
        end
    elseif (_estadoMision == 7) then
        if
            (Unit.getByName("OBJ4_4_1") == nil and Unit.getByName("OBJ4_4_2") == nil and
                Unit.getByName("OBJ4_4_3") == nil and
                Unit.getByName("OBJ4_4_4") == nil)
         then
            env.info("Eliminado Puesto 4")
            -- SIGNIFICA QUE EL CONVOY ESTÁ PARADO Y DA EL AVISO DE OBJ CUMPLIDO
            if (_interaccion1 == false) then
                INV_mensaje(2, "Puesto puerto eliminado.\n\nBlindados terrestres hacía objetivo.")
                trigger.action.setUserFlag(441, 8)
            else
                _interaccion1 = false
            end
            continueGroup("RFZ_OBJ4_PUESTO_4")
            continueGroup("RFZ_OBJ4_PUESTO_4 #001")
            continueGroup("BATUMI_WIN")
        else
            -- PRIMERA INTERACCION AVISO DE AMENAZA
            if (_interaccion1 == false) then
                INV_mensaje(3, "Puesto avanzado detectado. \n\nElimina los Blindados del Puerto.")
                _interaccion1 = true
            end
        end
    elseif (_estadoMision == 9) then
        if (checkAlivePercent("BATUMI INFANTERIA") > 50 and trigger.misc.getUserFlag(44) == true) then
            env.info("Eliminado Puesto Aeropuerto")
            -- SIGNIFICA QUE EL CONVOY ESTÁ PARADO Y DA EL AVISO DE OBJ CUMPLIDO
            if (_interaccion1 == false) then
                INV_mensaje(2, "Aeropuerto completado.\n\nBlindados terrestres hacía objetivo.")
                trigger.action.setUserFlag(441, 10)
            else
                _interaccion1 = false
            end
            continueGroup("BATUMI_WIN")
        else
            -- PRIMERA INTERACCION AVISO DE AMENAZA
            if (_interaccion1 == false) then
                if (trigger.misc.getUserFlag(44) == true) then
                    INV_mensaje(3, "Aeropuerto no está completado, elimina la mayoría de los Blindados del Aeropuerto.")
                else
                    INV_mensaje(
                        3,
                        "Ni la CAP ni los blindados Aeropuerto están completados, elimina la mayoría de los Blindados del Aeropuerto y la CAP antes de tomar la base."
                    )
                end
                _interaccion1 = true
            end
        end
    end
    return time + 5
end

timer.scheduleFunction(MissionControl4, 53, timer.getTime() + 5)
