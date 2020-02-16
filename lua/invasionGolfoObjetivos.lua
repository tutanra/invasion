-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "BASE SAQR PORT",
    Unidades = "DEFENSA_IRAN_SAQR_PORT",
    UnidadesTipo = "grupo", -- "grupo, unidad, estatico"
    Porcentaje = 100, -- porcentaje de unidad destruido
    TextoObjetivo = "UNIDADES RESTANTES : ",
    Completado = "OBJETIVO 1 - ATAQUE REFUERZO A SQR PORT REALIZADO.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[2] = {
    NombreObjetivo = "QUIMICA AL LIMAH",
    Unidades = {"OBJ2 #004", "OBJ2 #001", "OBJ2 #002", "OBJ2 #003", "OBJ2 #005"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "BASES QUIMICAS ACTIVAS : ",
    Completado = "OBJETIVO 2 - COMPLETADO, BASES QUIMICAS NEUTRALIZADAS.\n\nBuen Trabajo !!!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[3] = {
    NombreObjetivo = "BUQUE NUCLEAR",
    Unidades = "ObjNuclear",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "Buque Nuclear en camino a Al Jari - [D010] desde Shib Derab [CQ95]",
    Completado = "OBJETIVO 3 - BUQUE NUCLEAR DESTRUIDO.\n\nBuen trabajo !!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[4] = {
    NombreObjetivo = "LIMPIEZA DE KHASAB",
    Unidades = {
        "Defensa Aerea Khasab Aeropuerto",
        "Defensa Aerea Khasab Puerto"
    },
    UnidadesTipo = {"grupo","grupo"},
    Porcentaje = 80,
    TextoObjetivo = {
        "- Enemigos en zona Aeropuerto ",
        "- Enemigos en zona Puerto "
    },
    TextoCumplir = "Elimina el 80% de las fuerzas enemigas para realizar captura.",
    Completado = "OBJETIVO 4 - LIMPIEZA DE KHASAB CONCLUIDA.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[5] = {
    NombreObjetivo = "PUESTO DE MANDO",
    Unidades = "OBJ5_1",
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "Objetivo pendiente de eliminación.",
    Completado = "OBJETIVO 5 - PUESTO DE MANDO AVANZADO DESTRUIDO.\n\nBuen trabajo !!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[6] = {
    NombreObjetivo = "CG 1164 MOSKVA",
    Unidades = "OBJ7_barco",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "Crucero Moskva en Bandar e-Lengeh, eliminación pendiente.",
    Completado = "Destruido Crucero Moskva en Bandar e-lengeh.\n\nObjetivo realizado, buen trabajo!!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[06] = {
    NombreObjetivo = "CASERNA DE MONTAÑA",
    Unidades = "OBJDIN1",
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA ESTRUCTURA MILITAR.",
    Completado = "Destruido Caserna de montaña.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[07] = {
    NombreObjetivo = "FUERZA OCUPACIÓN",
    Unidades = "OBJDIN2",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "2 BLINDADOS Y 2 FORTIFICACIONES.",
    Completado = "Destruido Fuerza de Ocupación.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[08] = {
    NombreObjetivo = "FUERZA OCUPACIÓN VILLA",
    Unidades = "OBJDIN2 #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "4 BLINDADOS E INFANTERIA.",
    Completado = "Destruido Fuerza de Ocupación en VILLA.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[09] = {
    NombreObjetivo = "PUERTO DIBBA AL-HISN",
    Unidades = "OBJDINADIBBA",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "5 BLINDADOS EN ZONA PUERTO.",
    Completado = "Destruido Fuerza de Ocupación en Puerto.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[10] = {
    NombreObjetivo = "PASO MONTAÑOSO",
    Unidades = "OBJDINAM8",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "1 BLINDADO, INFANTERIA, MANPADS.",
    Completado = "Destruido Fuerza de paso montañosa.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[11] = {
    NombreObjetivo = "CONTROL MONTAÑOSO",
    Unidades = "OBJDINAM8 #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "1 BLINDADO, INFANTERIA, AAA.",
    Completado = "Destruido Fuerza de control, toma de fuerzas aliadas hacía objetivo.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "REFCONV1"
}
invasion_AG[12] = {
    NombreObjetivo = "CONTROL MONTAÑOSO 2",
    Unidades = "RFAPC3",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 APC, INFANTERIA",
    Completado = "Destruido Fuerza de control, toma de fuerzas aliadas hacía objetivo.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "REFCONV1 #001"
}

invasion_AG[13] = {
    NombreObjetivo = "PUESTO DE CARRETERA",
    Unidades = "BlueMASH #009",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "6 BLINDADOS, FORTIFICACIÓN.",
    Completado = "Destruido Puesto de Carretera.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[14] = {
    NombreObjetivo = "AAA EN SAQR PORT",
    Unidades = "DefensaOBJ1Shilka",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "4 SHILKA.",
    Completado = "Destruido AAA en Saqr Port.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[15] = {
    NombreObjetivo = "DEFENSA AL LIMAH OESTE",
    Unidades = "DEFENSA AEREA AL LIMAH #002",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "BLINDADOS + SA6",
    Completado = "Destruido Defensa AL LIMAH OESTE.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
invasion_AG[16] = {
    NombreObjetivo = "SA13 VALLE INTERIOR",
    Unidades = "SA13MOUNTAIN",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "SA13 + AAA",
    Completado = "Destruido Defensa SA13 interior.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true,
    Trigger = "REFCONV1 #002"
}

invasion_AG[17] = {
    NombreObjetivo = "VALLE HANGAR",
    Unidades = "RFAPC4",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 APC + ZU23",
    Completado = "Destruido Defensa interior.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[17] = {
    NombreObjetivo = "APCS EN GRANJA AL LIMAH",
    Unidades = "DEFENSA AEREA AL LIMAH #004",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "4 APC + INFANTERIA + VACAS",
    Completado = "Destruida Defensa interior.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}
