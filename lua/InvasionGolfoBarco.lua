-- OBJ7 Init --
-- Aumentamos la masa del barco para dificultar su derribo
_BarcoOBJ7 = {
    ["visible"] = true,
	["taskSelected"] = true,
	["route"] = 
	{
	}, -- end of ["route"]
	["tasks"] = 
	{
	}, -- end of ["tasks"]
    ["hidden"] = false,
    ["units"] = {
        [1] = {
            ["type"] = "MOSCOW",
            ["transportable"] = {
                ["randomTransportable"] = false
            }, -- end of ["transportable"]
            ["unitId"] = 1,
            ["skill"] = "Excellent",
            ["y"] = -91403.619954304,
            ["x"] = 11177.625805699,
            ["name"] = "OBJ7_barco",
            ["mass"] = 10000,
            ["heading"] = 3.1764992386297
        } -- end of [1]
    }, -- end of ["units"]
    ["y"] = -91403.619954304,
    ["x"] = 11177.625805699,
    ["name"] = "OBJ7_Group_barco",
    ["start_time"] = 0,
} -- end of [1]

coalition.addGroup(country.id.IRAN, Group.Category.SHIP, _BarcoOBJ7)
