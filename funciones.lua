do
    -- declare local variables
    --// exportstring( string )
    --// returns a "Lua" portable version of the string
    local function exportstring(s)
        return string.format("%q", s)
    end

    --// The Save Function
    function table.save(tbl, filename)
        local charS, charE = "   ", "\n"
        local file, err = io.open(filename, "wb")
        if err then
            return err
        end

        -- initiate variables for save procedure
        file:write("return {" .. charE)

        for idx, t in ipairs(tbl) do
            file:write("-- Table: {" .. idx .. "}" .. charE)
            file:write("{" .. charE)
            for i, v in pairs(t) do
                file:write(i .. " = " .. exportstring(t[i]) .. "," .. charE)
            end
            file:write("},")
        end
        file:write("}")
        file:close()
    end

    --// The Load Function
    function table.load(sfile)
        local ftables, err = loadfile(sfile)
        if err then
            return _, err
        end
        return ftables()
    end

    --[[     local invasion_users = {}
    invasion_users[1] = {
        Nombre = "Tutan",
        ucid = "86769396ad875ccbf1b92c392fbb5db7",
        role = "instructor" -- "instructor, miembro, miembroSA"
    }
    invasion_users[2] = {
        Nombre = "Virek",
        ucid = "86769396ad875ccbf1b92c392fbb5db7",
        role = "instructor" -- "instructor, miembro, miembroSA"
    } ]]
    -- table.save(invasion_users, "usuarios")
    invasion_users = table.load("usuarios")

    for _, v in ipairs(invasion_users) do
        print("Usuario " .. v.Nombre)
    end
end
