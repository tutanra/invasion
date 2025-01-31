-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "PUESTO TSJINVALI",
    Unidades = "OBJ1 EDIFICIO",
    UnidadesTipo = "estatico", -- "grupo, unidad, estatico"
    Porcentaje = 100, -- porcentaje de unidad destruido
    TextoObjetivo = "Recuerda destruir el edificio de municiones situado en el ala SurOeste.",
    Completado = "OBJETIVO 1 - ATAQUE PUESTO TSJINVALI REALIZADO.\n\nBuen trabajo !!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[2] = {
    NombreObjetivo = "AVANZADA GUPTA",
    Unidades = {
        "OBJ2 BLINDADOS", {
            "OBJ2 ABASTECIMIENTO1", "OBJ2 ABASTECIMIENTO2",
            "OBJ2 ABASTECIMIENTO3", "OBJ2 ABASTECIMIENTO4"
        }, {
            "OBJ2 HELICOPTEROS #001", "OBJ2 HELICOPTEROS #002",
            "OBJ2 HELICOPTEROS #003", "OBJ2 HELICOPTEROS #004",
            "OBJ2 HELICOPTEROS #005"
        }
    },
    UnidadesTipo = {"grupo", "estatico", "estatico"},
    Porcentaje = 100,
    TextoObjetivo = {"- Blindados ", "- Almacenes ", "- Helicópteros "},
    Completado = "OBJETIVO 2 - FUERZAS DE LA AVANZADA GUPTA NEUTRALIZADAS.\n\nBuen Trabajo !!!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[3] = {
    NombreObjetivo = "CONVOY",
    Unidades = {"OBJ3 CONVOY 1", "OBJ3 CONVOY 2"},
    UnidadesTipo = {"grupo", "grupo"},
    Porcentaje = 90,
    TextoObjetivo = {"- Convoy Alpha ", "- Convoy Bravo "},
    TextoCumplit = "Elimina el 80% del convoy avistado mediante seguimiento, marcado en Mapa.",
    Completado = "OBJETIVO 3 - CONVOY NEUTRALIZADO.\nPELIGRO DE INVASIÓN MERMADA\n\nBuen Trabajo !!!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[4] = {
    NombreObjetivo = "BATUMI CAP",
    Unidades = "BATUMI_MISSION_AIR",
    UnidadesTipo = "cap",
    MooseSquadron = RA1ADispatcher:GetSquadron("Batumi_defend"),
    Porcentaje = 100,
    TextoObjetivo = "Fuerza Aérea de Batumi ",
    Completado = "OBJETIVO 4 - CAP BATUMI elminada. \n\nBlindados terrestres en toma de Aeropuerto en espera de la eliminación de blindados en la zona del aeropuerto.\n\nBuen trabajo!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[5] = {
    NombreObjetivo = "SUJUMI CAP",
    Unidades = "SUJUMI_MISSION_AIR",
    UnidadesTipo = "cap",
    MooseSquadron = RA2ADispatcher:GetSquadron("Sujumi_defend"),
    Porcentaje = 100,
    TextoObjetivo = "Fuerza Aérea de Sujumi ",
    Completado = "OBJETIVO 5 - CAP SUJUMI elminada. \n\nBlindados terrestres en toma de Aeropuerto en espera de la eliminación de blindados en la zona del aeropuerto.\n\nBuen trabajo!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}

invasion_AG[6] = {
    NombreObjetivo = "PROTOTIPO AWACS",
    Unidades = "RSAWACSPILOT",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "Derribar prototipo de AWACS enemigo.",
    Completado = "OBJETIVO 6 - PROTOTIPO AWACS elminado. \n\nBuen trabajo!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}

invasion_AG[7] = {
    NombreObjetivo = "DEFENSA SA6",
    Unidades = {"Unidad #071", "Unidad #078"},
    UnidadesTipo = {"unidad", "unidad"},
    Porcentaje = 100,
    TextoObjetivo = "Derribar unidades de búsqueda.",
    Completado = "RASTREADORES SA6 ELIMINADOS. \n\nBuen trabajo!",
    VerEstado = false,
    Realizado = false,
    Dinamico = true
}

invasion_AG[8] = {
    NombreObjetivo = "SHILKA GUFTA BRIDGE",
    Unidades = "Shilka air defense artillery",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "3 Shilka en el puente.",
    Completado = "DERRIBADAS AAA EN EL PUENTE DE GUFTA. \n\nBuen trabajo!",
    VerEstado = false,
    Realizado = false,
    Dinamico = true
}

invasion_AG[9] = {
    NombreObjetivo = "SA6 EN ZONA MONTAÑOSA",
    Unidades = "SHAVSHEBI RADAR #002",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "Conjunto de Puesto de Mando y SA6.",
    Completado = "DERRIBADAS SA6 EN ZONA MONTAÑOSA. \n\nBuen trabajo!",
    VerEstado = false,
    Realizado = false,
    Dinamico = true
}

invasion_AG[10] = {
    NombreObjetivo = "APC KEBVI",
    Unidades = "APCRFZ1",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "4 APC'S EN KEBVI.",
    Completado = "DERRIBADAS APC EN KEBVI. \n\nBuen trabajo!",
    VerEstado = false,
    Realizado = false,
    Dinamico = true
}