-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "PUESTO FRONTERIZO",
    Unidades = "Nuevo grupo de vehículos #001",
    UnidadesTipo = "grupo", -- "grupo, unidad, estatico"
    Porcentaje = 100, -- porcentaje de unidad destruido
    TextoObjetivo = "UNIDADES RESTANTES : ",
    Completado = "OBJETIVO 1 - PUESTO FRONTERIZO REALIZADO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[2] = {
    NombreObjetivo = "PUESTO ENTREPUEBLOS",
    Unidades = "Nuevo grupo de vehículos #005",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "5 BLINDADOS + INFANTERIA",
    Completado = "OBJETIVO 2 - COMPLETADO, PUESTO ENTREPUEBLOS.\n\nBuen Trabajo !!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[3] = {
    NombreObjetivo = "PUESTO TEBERDA",
    Unidades = "OBJ2 CONVOY #004",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "PUESTO EN TEBERDA",
    Completado = "OBJETIVO 3 - PUESTO EN TEBERDA DESTRUIDO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false,
    Trigger = "OBJ3 CONVOY"
}
invasion_AG[4] = {
    NombreObjetivo = "MEZQUITA",
    Unidades = "Nuevo grupo de vehículos #006",
    TextoObjetivo = "ELIMINA LOS REFUERZOS DE LA MEZQUITA.",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    Completado = "OBJETIVO 4 - LIMPIEZA DE MEZQUITA.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false,
    Trigger = "OBJ4CONV"
}
invasion_AG[5] = {
    NombreObjetivo = "PUESTO DE MANDO",
    Unidades = {"Nuevo grupo de vehículos #019", "Nuevo grupo de vehículos #018"},
    TextoObjetivo = "ELIMINA EL PUESTO DE MANDO.",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    Completado = "OBJETIVO 5 - PUESTO DE MANDO AVANZADO DESTRUIDO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[6] = {
    NombreObjetivo = "SHILKA+INFANTERIA",
    Unidades = "Nuevo grupo de vehículos #010",
    UnidadesTipo = "grupo",
    TextoObjetivo = "SHILKA+INFANTERIA",
    Porcentaje = 100,
    Completado = "SHILKA ELIMINADO.\n\nObjetivo realizado, buen trabajo!!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = true
}
invasion_AG[07] = {
    NombreObjetivo = "PUESTO CARRETERA",
    Unidades = "Nuevo grupo de vehículos #013",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "2 BLINDADOS BMD-1.",
    Completado = "Destruido PUESTO CARRETERA.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[08] = {
    NombreObjetivo = "PUESTO CARRETERA 2",
    Unidades = "Nuevo grupo de vehículos #012",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 BLINDADOS.",
    Completado = "Destruido PUESTO CARRETERA 2.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[09] = {
    NombreObjetivo = "ARTILLERIA",
    Unidades = "Nuevo grupo de vehículos #011",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ARTILLERIA+2 BLINDADOS.",
    Completado = "Destruida Artilleria.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[10] = {
    NombreObjetivo = "PUESTO VERH",
    Unidades = "Nuevo grupo de vehículos #014",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "AAA+3 BLINDADOS.",
    Completado = "Destruido Puesto Verh.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[11] = {
    NombreObjetivo = "LATERAL ENTREPUEBLOS",
    Unidades = "OBJ2 GRP REFUERZO #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 BMP2.",
    Completado = "Destruido Lateral Entrepueblos.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "REFCONV2"
}
invasion_AG[12] = {
    NombreObjetivo = "CONTROL MONTAÑOSO 2",
    Unidades = "RFAPC3",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 APC, INFANTERIA",
    Completado = "Destruido Fuerza de control.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "REFCONV1 #001"
}

invasion_AG[13] = {
    NombreObjetivo = "HANGAR TECNOLOGICO",
    Unidades = "OBJ2 CONVOY #005",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "3 BLINDADOS + INFANTERIA.",
    Completado = "Destruido HANGAR TECNOLOGICO.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[14] = {
    NombreObjetivo = "MIXTO EN PUENTE",
    Unidades = "Nuevo grupo de vehículos #007",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "2 BMP2 - 2 AAA",
    Completado = "MIXTO EN PUENTE.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "Nuevo grupo de vehículos #023"
}
invasion_AG[15] = {
    NombreObjetivo = "ARTILLERIA",
    Unidades = "OBJ2 CONVOY #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "ARTILLERIA EN RIO",
    Completado = "Destruido ARTILLERIA EN RIO.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[16] = {
    NombreObjetivo = "SHILKA + BMP1",
    Unidades = "Nuevo grupo de vehículos #022",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "SHILKA + BMP1 EN RIO",
    Completado = "Destruido SHILKA + BMP1 EN RIO.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
