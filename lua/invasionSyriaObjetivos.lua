-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "DETECCION",
    Unidades = {"OBJ3_1-2-1", "OBJ3_2-2-1", "OBJ3_2-2-3"},
    UnidadesTipo = "unidad", -- "grupo, unidad, estatico"
    Porcentaje = 100, -- porcentaje de unidad destruido
    TextoObjetivo = "UNIDADES RESTANTES : ",
    Completado = "OBJETIVO 1 - ELIMINAR RADARES DE DETECCION.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[2] = {
    NombreObjetivo = "PUESTO DE MANDO HARET CHBIB",
    Unidades = {"OBJ2_1", "OBJ2_1", "OBJ2_1"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "EDIFICIOS PUESTO DE MANDO RESTANTES : ",
    Completado = "OBJETIVO 2 - COMPLETADO, PUESTO DE MANDO NEUTRALIZADO.\n\nBuen Trabajo !!!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[3] = {
    NombreObjetivo = "HELIS ASALTO",
    Unidades = {"Static Ka-50-1","Static Ka-50-2","Static Ka-50-3","Static Ka-50-4","Static Ka-50-5"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "HELICOPTEROS KA50 : ",
    Completado = "OBJETIVO 3 - KA50'S ELIMINADOS.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[4] = {
    NombreObjetivo = "TORRE DE COMUNICACIONES",
    Unidades = "TORREOBJ4",
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "TORRE DE COMUNICACIONES",
    TextoCumplir = "Elimina la torre de Comunicaciones.",
    Completado = "OBJETIVO 4 - TORRE DE COMUNICACIONES ELIMINADO.\n\nBuen trabajo !!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}

invasion_AG[5] = {
    NombreObjetivo = "ELIMINAR SA10",
    Unidades = "SA10OBJ6",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "UNIDADES SA10 : ",
    Completado = "OBJETIVO 6 - ELIMINACION GRUPO SA10 COMPLETADO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[6] = {
    NombreObjetivo = "NASIRIYAH BUNKERS",
    Unidades = {"Static Bunker 2-1", "Static Bunker 2-2", "Static Bunker 2-3", "Static Bunker 2-4", "Static Bunker 2-5", "Static Bunker 2-6", "Static Bunker 2-7", "Static Bunker 2-8"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "EDIFICIOS RESTANTES : ",
    Completado = "OBJETIVO 7 - ELIMINACION BUNKERS COMPLETADO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[7] = {
    NombreObjetivo = "RADAR 1",
    Unidades = "OBJ3_1-2-1",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA RADAR DETECCION.",
    Completado = "Destruido Radar Objetivo 1.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[8] = {
    NombreObjetivo = "RADAR 2",
    Unidades = "OBJ3_2-2-1",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA RADAR DETECCION.",
    Completado = "Destruido Radar Objetivo 1.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[9] = {
    NombreObjetivo = "RADAR 3",
    Unidades = "OBJ3_2-2-3",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA RADAR DETECCION.",
    Completado = "Destruido Radar Objetivo 1.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[10] = {
    NombreObjetivo = "FRONTERA",
    Unidades = "BLNFRONTERA",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA PUESTO FRONTERA.",
    Completado = "Destruido Puesto fronterizo.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Trigger = "BLNFRONTERA-1",
    Dinamico = true
}

invasion_AG[11] = {
    NombreObjetivo = "FRONTERA-2",
    Unidades = "BLNFRONTERA-3",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA PUESTO FRONTERA 2.",
    Completado = "Destruido Puesto.\n\nACTIVADO SISTEMA DE ALERTA, REFUERZOS AL ENCUENTRO!!!",
    Realizado = false,
    Trigger = "BLNFRONTERA-6",
    Dinamico = true
}

invasion_AG[12] = {
    NombreObjetivo = "DEFENSA CIUDAD",
    Unidades = "BLNFRONTERA-4",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA DEFENSA CIUDAD",
    Completado = "Destruido Puesto.\n\nACTIVADO SISTEMA DE ALERTA, REFUERZOS AL ENCUENTRO!!!",
    Realizado = false,
    Trigger = "BLNFRONTERA-9",
    Dinamico = true
}
invasion_AG[13] = {
    NombreObjetivo = "ALEPPO",
    Unidades = "BLNFRONTERA-5",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA DEFENSA CIUDAD",
    Completado = "Destruido Puesto.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[14] = {
    NombreObjetivo = "ALEPPO SA2",
    Unidades = "Syria Waha SAM SA-2",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA SA2 ALEPPO",
    Completado = "Destruido DEFENSA AEREA.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
