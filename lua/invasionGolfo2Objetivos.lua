-- OBJETIVOS --
invasion_AG[1] = {
    NombreObjetivo = "EVACUACIÓN",
    Unidades = {
        "OBJ1_SHIP",
        "OBJ1_DEFENSA"
    },
    UnidadesTipo = {"unidad","grupo"},
    Porcentaje = 100,
    TextoObjetivo = {
        "- Barco de transporte : ",
        "- Enemigos en zona Puerto : "
    },
    TextoCumplir = "Elimina el Barco de evacuación y fuerzas enemigas para realizar captura.",
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