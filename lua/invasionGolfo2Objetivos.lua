-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "EVACUACIÓN",
    Unidades = {
        "OBJ1_SHIP",
        {"Unidad #005", "Unidad #006", "Unidad #007"},
    },
    UnidadesTipo = {"unidad","unidad"},
    Porcentaje = 100,
    TextoObjetivo = {
        "- Barco de transporte : ",
        "- Enemigos en zona Puerto : "
    },
    TextoCumplir = "Elimina el Barco de evacuación y fuerzas enemigas AAA en Puerto para realizar captura.",
    Completado = "OBJETIVO 1 - EVACUACIÓN Y AAA ELIMINADA.\n\nBuen trabajo !!",
    VerEstado = true,
    Realizado = false,
    Dinamico = false
}
invasion_AG[2] = {
    NombreObjetivo = "CUARTEL LENGEH",
    Unidades = "OBJ2_CUARTEL",
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA EL CUARTEL ENEMIGO",
    Completado = "OBJETIVO 2 - COMPLETADO, CUARTEL ENEMIGO ELIMINADO.\n\nBuen Trabajo !!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[3] = {
    NombreObjetivo = "HANGARES",
    Unidades = {"OBJ3_HANGAR1", "OBJ3_HANGAR2"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA LOS HANGARES ENEMIGOS",
    Completado = "OBJETIVO 3 - HANGARES DE ARMAS DESTRUIDOS.\n\nBuen Trabajo !!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}
invasion_AG[4] = {
    NombreObjetivo = "SHAHR-E GHADIM",
    Unidades = {"OBJ4_MANDO1", "OBJ4_RADIO1","OBJ4_RADIO2"},
    UnidadesTipo = "estatico",
    Porcentaje = 100,
    TextoObjetivo = "ELIMINA LAS DOS TORRES DE RADIO Y EL PUESTO DE CONTROL",
    Completado = "OBJETIVO 4 - RADIOS Y PUESTOS DE CONTROL DESTRUIDOS.\n\nBuen Trabajo !!!",
    VerEstado = false,
    Realizado = false,
    Dinamico = false
}

invasion_AG[7] = {
    NombreObjetivo = "AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #002",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "PUERTO SUR LAVAN ISLAND.",
    Completado = "Destruido AAA en puerto Sur.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[8] = {
    NombreObjetivo = "3 APC",
    Unidades = "Nuevo grupo de vehículos #035",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "POLIGONO ESTE LAVAN ISLAND.",
    Completado = "Destruido 3APC en poligono Este.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[9] = {
    NombreObjetivo = "AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #036",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "AEROPUERTO LAVAN ISLAND.",
    Completado = "Destruido AAA + 2 BLINDADOS en Aeropuerto Lavan Island.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[10] = {
    NombreObjetivo = "GRUPO AAA Y SA6",
    Unidades = "Nuevo grupo de vehículos #011",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "COSTA FRENTE LAVAN ISLAND.",
    Completado = "Destruido SA6 frente Lavan Island.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[11] = {
    NombreObjetivo = "2 AAA + APC",
    Unidades = "OBJ1_DEFENSA #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "COSTA CERCA KISH.",
    Completado = "Destruido 2 AAA Y APC frente Kish.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[12] = {
    NombreObjetivo = "1 AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #037",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "AEROPUERTO BANDAR LENGEH.",
    Completado = "Destruido 1 AAA Y 2 blindados aeropuerto Bandar Lengeh.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[13] = {
    NombreObjetivo = "2 LANCHAS",
    Unidades = "Nuevo grupo de barcos #001",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "PUERTO BANDAR LENGEH.",
    Completado = "Destruido 2 lanchas puerto Bandar Lengeh.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[14] = {
    NombreObjetivo = "AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #033",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "PUERTO BANDAR LENGEH.",
    Completado = "Destruido AAA + 2 blindados.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[15] = {
    NombreObjetivo = "SA10",
    Unidades = "Nuevo grupo de vehículos #018",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "POLIGONO EN INTERIOR.",
    Completado = "Destruido SA10.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[16] = {
    NombreObjetivo = "SA10",
    Unidades = "Nuevo grupo de vehículos #025",
    UnidadesTipo = "grupo",
    Porcentaje = 80,
    TextoObjetivo = "POLIGONO EN INTERIOR.",
    Completado = "Destruido SA10.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[17] = {
    NombreObjetivo = "SCUD INOPERATIVO",
    Unidades = "Nuevo grupo de vehículos #038",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "SUR AEROPUERTO LAR.",
    Completado = "Destruido SCUD en sur Aeropuerto Lar.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[18] = {
    NombreObjetivo = "AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #024",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "CIUDAD OESTE SAHR JADID.",
    Completado = "Destruido AAA + 2 BLINDADOS en SAHR JADID.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[19] = {
    NombreObjetivo = "SA18",
    Unidades = "Unidad #124",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "CIUDAD NORTE SAHR JADID.",
    Completado = "Destruido SA18 en norte SAHR JADID.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[20] = {
    NombreObjetivo = "SA18",
    Unidades = "Unidad #128",
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "CIUDAD SURESTE SAHR GHADIM.",
    Completado = "Destruido SA18 en Sureste SAHR GHADIM.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[21] = {
    NombreObjetivo = "AAA + 2 BLINDADOS",
    Unidades = "Nuevo grupo de vehículos #030",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "AEROPUERTO LAR.",
    Completado = "Destruido AAA + 2 Blindados en aeropuerto LAR.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[22] = {
    NombreObjetivo = "SA11",
    Unidades = {"Unidad #106","Unidad #104","Unidad #105","Unidad #103"},
    UnidadesTipo = "unidad",
    Porcentaje = 100,
    TextoObjetivo = "CIUDAD NORESTE SAHR GHADIM.",
    Completado = "Destruido SA11 en Noreste SAHR GHADIM.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}

invasion_AG[23] = {
    NombreObjetivo = "SA10",
    Unidades = "Nuevo grupo de vehículos #032",
    UnidadesTipo = "grupo",
    Porcentaje = 100,
    TextoObjetivo = "CIUDAD JAHROM.",
    Completado = "Destruido SA10 en Ciudad Jahrom.\n\nObjetivo dinámico realizado, buen trabajo!!!",
    Realizado = false,
    Dinamico = true
}