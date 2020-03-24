gcicap = {}
gcicap.gci = {}
gcicap.cap = {}

-- Valores posibles "none", "info", "warning" and "error".
gcicap.log_level = "info"

--- Intervalo, en segundos.
gcicap.interval = 30

--- Interval, in seconds, GCI flights get vectors on targets.
-- AI GCI flights don't use their radar, to be as stealth as
-- possible, relying on those vectors.
-- Default 15 seconds.
gcicap.vector_interval = 15

--- Initial spawn delay between CAPs
-- Default 30 seconds.
gcicap.initial_spawn_delay = 30

gcicap.cap.min_alt = 2500
gcicap.cap.max_alt = 7500
gcicap.cap.speed = 220
gcicap.cap.max_engage_distance = 35000
gcicap.cap.vul_time_min = 25
gcicap.cap.vul_time_max = 40
gcicap.cap.group_size = "2"
gcicap.cap.groups_count = 3
gcicap.cap.start_airborne = false

gcicap.gci.groups_count = 20
gcicap.gci.speed = 300
gcicap.gci.group_size = "dynamic"

gcicap.limit_resources = false
gcicap.supply = 48

-- can be "parking", "takeoff" or "air" and defines the way the fighters spawn
gcicap.cap.spawn_mode = "air"

gcicap.cap.zones_count = 3
gcicap.border_group = "redborder"
gcicap.cap.zone_name = "redCAPzone"
gcicap.cap.start_name = "redCAPstart"
gcicap.gci.template_prefix = "__GCI__"
gcicap.cap.template_prefix = "__CAP__"
gcicap.template_count = 2

gcicap.awacs = true

gcicap.log = mist.Logger:new("GCICAP", gcicap.log_level)

do
    --- Flight class.
    -- @type gcicap.Flight
    gcicap.Flight = {}

    local function getFlightIndex(group)
        if type(group) ~= "string" then
            if group:getName() then
                group = group:getName()
            else
                return false
            end
        end
        for j, task in pairs(gcicap.tasks) do
            for n = 1, #gcicap[task].flights do
                if gcicap[task].flights[n].group_name == group then
                    return {task = task, index = n}
                end
            end
        end
        return false
    end

    function gcicap.Flight.getFlight(group)
        f = getFlightIndex(group)
        if f then
            return gcicap[f.task].flights[f.index]
        else
            return false
        end
    end

    function gcicap.Flight:new(group, task, param)
        if group:isExist() then
            local f = {}
            f.group = group
            f.group_name = group:getName()
            f.task = task
            -- is the flight RTB?
            f.rtb = false
            f.in_zone = false

            if task == "cap" then
                f.zone = param
                f.zone_name = param.name
                f.intercepting = false
                f.vul_time = math.random(gcicap.cap.vul_time_min, gcicap.cap.vul_time_max)
            else -- tarea será "gci"
                f.target = param
                f.target_group = param.group
                f.intercepting = true
            end

            -- get current timestamp
            local timestamp = timer.getAbsTime()
            f.units_moved = {}
            -- set timestamp for each unit
            -- this is later used for garbage collection checks
            for u, unit in pairs(group:getUnits()) do
                f.units_moved[u] = {}
                f.units_moved[u].unit = unit
                f.units_moved[u].last_moved = timestamp
                f.units_moved[u].spawned_at = timestamp
            end
            setmetatable(f, self)
            self.__index = self
            table.insert(gcicap[task].flights, f)
            gcicap.log:info("Registered flight: $1", f.group_name)
            return f
        else
            return nil
        end
    end

    --- Removes the flight
    -- @tparam gcicap.Flight self flight object
    function gcicap.Flight:remove()
        if self.zone then
            -- if we didn't already leave the zone do it now.
            self:leaveCAPZone()
        end
        local f = getFlightIndex(self.group_name)
        local r = table.remove(gcicap[f.task].flights, f.index)
        if r then
            gcicap.log:info("Removing flight $1 with index $2", r.group_name, f.index)
        end
    end

    --- Decreases active flights counter in this flights zone.
    -- Actually just decreases the active flights
    -- counter of a zone. Does NOT task the flight itself.
    function gcicap.Flight:leaveCAPZone()
        if self.in_zone then
            local zone = self.zone
            if zone.patrol_count <= 1 then
                zone.patrol_count = 0
            else
                zone.patrol_count = zone.patrol_count - 1
            end
            self.in_zone = false

            -- get current time
            local time_now = timer.getAbsTime()
            -- get time on station by substracting vul start time from current time
            -- and convert it to minutes
            local time_on_station = 0
            if self.vul_start then
                time_on_station = (time_now - self.vul_start) / 60
            end
            local vul_diff = self.vul_time - time_on_station
            -- set new vul time only if more than 5 minutes
            if vul_diff > 5 then
                self.vul_time = vul_diff
            else
                self.vul_time = 0
            end
        end
    end
    --- Increases active flights counter in this flights zone.
    -- Actually just increases the active flights
    -- counter of a zone. Does NOT task the flight itself.
    function gcicap.Flight:enterCAPZone()
        if not self.in_zone then
            self.intercepting = false
            self.in_zone = true
            local zone = self.zone
            zone.patrol_count = zone.patrol_count + 1
        end
    end

    --- Tasks the flight to search and engage the target.
    -- @tparam Unit intruder target unit.
    -- @tparam[opt] boolean cold whether the flight should not destroy
    -- the target and just follow it. Default false.
    function gcicap.Flight:vectorToTarget(intruder, cold)
        local target = nil
        if intruder.group then
            target = gcicap.getFirstActiveUnit(intruder.group)
        end
        if target == nil or intruder.group == nil then
            return
        end
        -- check if interceptor even still exists
        if self.group:isExist() then
            if target:isExist() and target:inAir() then
                local target_pos = target:getPoint()
                local ctl = self.group:getController()

                local gci_task = {
                    id = "Mission",
                    params = {
                        route = {
                            points = {
                                [1] = {
                                    alt = target_pos.y,
                                    x = target_pos.x,
                                    y = target_pos.z,
                                    speed = gcicap.gci.speed,
                                    action = "Turning Point",
                                    type = "Turning Point",
                                    task = {
                                        -- i don't really like this WrappedAction but it's needed in
                                        -- the case the CGI completes this waypoint because of lack/loss
                                        -- of target
                                        id = "WrappedAction",
                                        params = {
                                            action = {
                                                id = "Script",
                                                params = {
                                                    command = "local group = ...\
                          local flight = gcicap.Flight.getFlight(group)\
                          if flight then\
                            if flight.zone then\
                              if flight.intercepting then\
                                flight:taskWithCAP()\
                              end\
                            else\
                              if not flight.target then\
                                flight:taskWithRTB()\
                              end\
                            end\
                          else\
                            gcicap.log:error('Could not find flight')\
                          end"
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                -- checkout of the patrol zone
                if self.zone and not self.intercepting then
                    self:leaveCAPZone()
                end

                intruder.intercepted = true
                self.intercepting = true
                ctl:setTask(gci_task)

                if not cold then
                    gcicap.taskEngageGroup(self.group, intruder.group)
                end

                gcicap.log:info("Vectoring $1 to $2 ($3)", self.group:getName(), intruder.group:getName(), target:getName())

                -- reschedule function until either the interceptor or the intruder is dead
                mist.scheduleFunction(gcicap.Flight.vectorToTarget, {self, intruder, cold}, timer.getTime() + gcicap.vector_interval)
            else -- the target is dead, resume CAP or RTB
                if self.zone then
                    -- send CAP back to work only if still intercepting
                    if self.intercepting then
                        self:taskWithCAP()
                    end
                else
                    self.intercepting = false
                    -- send GCI back to homeplate
                    self:taskWithRTB()
                end
            end
        else
            -- our interceptor group is dead let's see if the
            -- intruder is still there and set him to not beeing intercepted anymore
            if target:isExist() then
                intruder.intercepted = false
            end
        end
    end

    --- Tasks flight with combat air patrol.
    -- Creates waypoints dentro it's assigned zone and tasks
    -- the flight with patroling along the route.
    -- @tparam[opt] boolean cold If set to true the flight won't
    -- engage any enemy unit's it detects by itself. Default false.
    function gcicap.Flight:taskWithCAP(cold)
        -- only task with CAP if ther is still vul time left
        if self.vul_time == 0 then
            -- send flight RTB if no vul time left.
            gcicap.log:info("No vul time left for $1", self.group_name)
            self:taskWithRTB()
        else
            local group = self.group
            local ctl = group:getController()
            local start_pos = gcicap.getFirstActiveUnit(group):getPoint()
            local leg_dist = math.random(gcicap.cap.leg_min, gcicap.cap.leg_max)
            local cap_route = gcicap.buildCAPRoute(start_pos, self.zone.name, self.vul_time, leg_dist)
            local cap_task = {
                id = "Mission",
                params = {
                    route = cap_route
                }
            }

            self.intercepting = false

            ctl:setTask(cap_task)
            self:enterCAPZone()
            ctl:setOption(AI.Option.Air.id.RADAR_USING, AI.Option.Air.val.RADAR_USING.FOR_SEARCH_IF_REQUIRED)

            if not cold then
                gcicap.taskEngage(group)
            end
            gcicap.log:info("Tasking $1 with CAP in zone $2", group:getName(), self.zone.name)
        end
    end

    --- Tasks the flight to return to it's homeplate.
    -- @tparam[opt] Airbase airbase optionally use this as homeplate/airbase
    -- to return to.
    -- @tparam[opt] boolean cold If set to true the flight won't
    -- engage any targets it detects on the way back to base.
    -- Default false.
    function gcicap.Flight:taskWithRTB(airbase, cold)
        if not airbase then
            airbase = self.airbase
        end

        if self.zone then
            self:leaveCAPZone()
            -- let's try to spawn a new CAP flight as soon as the current one is tasked with RTB.
            -- never spawn more than 2 x the groups_count, to prevent spam in case something ever goes wrong.
            if (not gcicap.limit_resources or (gcicap.limit_resources and gcicap.supply > 0)) and #gcicap.cap.flights < gcicap.cap.groups_count * 2 then
                gcicap.spawnCAP(self.zone, gcicap.cap.spawn_mode)
            end
        end
        self.rtb = true
        local group = self.group
        local ctl = group:getController()
        local af_pos = mist.utils.makeVec2(airbase:getPoint())
        local af_id = airbase:getID()
        local rtb_task = {
            id = "Mission",
            params = {
                route = {
                    points = {
                        [1] = {
                            alt = gcicap.cap.min_alt,
                            alt_type = "BARO",
                            speed = gcicap.cap.speed,
                            x = af_pos.x,
                            y = af_pos.y,
                            aerodromeId = af_id,
                            type = "Land",
                            action = "Landing"
                        }
                    }
                }
            }
        }

        ctl:setTask(rtb_task)

        if not cold then
            -- Hot a 10km de la zona
            gcicap.taskEngage(group, 10000)
        end

        gcicap.log:info("Tasking $1 with RTB to $2", group:getName(), airbase:getName())
    end

    --- Clean up inactive/stuck flights.
    function garbageCollector()
        local timestamp = timer.getAbsTime()
        for t, task in pairs(gcicap.tasks) do
            for f, flight in pairs(gcicap[task].flights) do
                if flight.group then
                    if flight.group:isExist() then
                        for u = 1, #flight.units_moved do
                            local unit = flight.units_moved[u].unit
                            -- check if unit exists
                            if unit then
                                if unit:isExist() then
                                    -- if unit is in air we won't do anything
                                    if not unit:inAir() then
                                        -- check if unit is moving
                                        local mag = mist.vec.mag(unit:getVelocity())
                                        if mag == 0 then
                                            -- get the last time the unit moved
                                            local last_moved = flight.units_moved[u].last_moved
                                            if timestamp - last_moved > gcicap.move_timeout then
                                                gcicap.log:info("Cleaning up $1", flight.group:getName())
                                                flight.group:destroy()
                                                flight:remove()
                                            end
                                        else
                                            flight.units_moved[u].last_moved = timestamp
                                        end
                                    end
                                end
                            end
                        end
                    else
                        flight:remove()
                    end
                else
                    flight:remove()
                end
            end
        end
    end

    local function checkForTemplateUnits()
        for i = 1, gcicap.template_count do
            local unit = gcicap.gci.template_prefix .. i
            if not Unit.getByName(unit) then
                gcicap.log:alert("GCI template unit missing: $1", unit)
                return false
            end
        end
        for i = 1, gcicap.template_count do
            local unit = gcicap.cap.template_prefix .. i
            if not Unit.getByName(unit) then
                gcicap.log:alert("CAP template unit missing: $1", unit)
                return false
            end
        end
        if not Group.getByName(gcicap.border_group) then
            gcicap.log:alert("Border group is missing: $1", gcicap.border_group)
            return false
        end
        return true
    end

    local function checkForTriggerZones()
        for i = 1, gcicap.cap.zones_count do
            local zone_name = gcicap.cap.zone_name .. i
            if not trigger.misc.getZone(zone_name) then
                gcicap.log:alert("CAP trigger zone is missing: $1", zone_name)
                return false
            end
        end
        return true
    end

    local function manageCAP()
        local patroled_zones = 0
        for i = 1, #gcicap.cap.zones do
            local zone = gcicap.cap.zones[i]
            gcicap.log:info("Zone $1 has $2 patrols", zone.name, zone.patrol_count)

            -- see if we can send a new CAP into the zone
            if zone.patrol_count <= 0 then
                -- first check if we already hit the maximum amounts of routine CAP groups
                if #gcicap.cap.flights < gcicap.cap.groups_count then
                    -- check if we limit resources and if we have enough supplies
                    -- if we don't limit resource or have enough supplies we spawn
                    if not gcicap.limit_resources or (gcicap.limit_resources and gcicap.supply > 0) then
                        -- finally spawn it
                        gcicap.spawnCAP(gcicap.cap.zones[i], gcicap.cap.spawn_mode)
                    end
                end
            else
                patroled_zones = patroled_zones + 1
            end
        end
        -- if all zones are patroled and we still have cap groups left
        -- send them to a random zone
        if #gcicap.cap.flights < gcicap.cap.groups_count then
            if not gcicap.limit_resources or (gcicap.limit_resources and gcicap.supply > 0) then
                local random_zone = math.random(1, #gcicap.cap.zones)
                gcicap.spawnCAP(gcicap.cap.zones[random_zone], gcicap.cap.spawn_mode)
            end
        end
        gcicap.log:info("$1 patrols in $2/$3 zones", patroled_zones, gcicap.cap.zones_count, #gcicap.cap.flights)
    end

    local function handleIntrusion()
        for i = 1, #gcicap.intruders do
            local intruder = gcicap.intruders[i]
            if intruder.group then
                if intruder.group:isExist() then
                    -- check if we need to do something about him
                    if not intruder.intercepted then
                        -- first check if we have something to work with
                        if #gcicap.cap.flights > 0 or #gcicap.gci.flights > 0 or #gcicap.gci.flights < gcicap.gci.groups_count then
                            -- get closest flight to intruder if there is any
                            local closest = nil
                            local intruder_unit = gcicap.getFirstActiveUnit(intruder.group)
                            local closest_flights = gcicap.getClosestFlightsToUnit(intruder_unit)
                            -- we found close flights
                            local flight_avail = false
                            if closest_flights then
                                for j = 1, #closest_flights do
                                    closest = closest_flights[j]
                                    --fligh_avail = (not closest.flight.rtb) and (not closest.flight.intercepting)
                                    flight_avail = (not closest.flight.intercepting)
                                    if flight_avail then
                                        gcicap.log:info("Found flight $1 which is avaliable for tasking.", closest.flight.group:getName())
                                        break
                                    end
                                end
                            end
                            if flight_avail then
                                -- check if we have a airfield which is closer to the unit than the closest flight
                                -- but add some distance to the airfield since it takes time for a potential spawned
                                -- flight to take-off
                                local closest_af, af_distance = gcicap.getClosestAirfieldToUnit(intruder_unit)
                                af_distance = af_distance + 15000 -- add 15km
                                if closest.distance < af_distance or af_distance == -1 then
                                    -- task flight with intercept
                                    closest.flight:vectorToTarget(intruder)
                                    return
                                end
                                if
                                    (not gcicap.limit_resources or (gcicap.limit_resources and gcicap.supply > 0)) and
                                        #gcicap.gci.flights < gcicap.gci.groups_count and
                                        gcicap.gci.enabled
                                 then
                                    -- spawn CGI
                                    gcicap.log:info("Airfield closer to intruder than flight or no flight available. Spawning GCI")
                                    local gci = gcicap.spawnGCI(intruder)
                                end
                            end
                        end
                    end
                end
            else
                -- the intruder group doesn't exist (anymore) remove it
                table.remove(gcicap.intruders, i)
            end
        end
    end

    -- returns airfields
    -- triggerzones (triggerzone name is exactly the same as airfield name).
    local function getAirfields()
        local coal_airfields = coalition.getAirbases(coalition.side.RED)
        local gcicap_airfields = {}

        -- loop over all coalition airfields
        for i = 1, #coal_airfields do
            -- get name of airfield
            local af_name = coal_airfields[i]:getName()
            if not string.match(af_name, "FARP") then
                -- check if a triggerzone exists with that exact name
                if mist.DBs.zonesByName[af_name] then
                    -- add it to our airfield list for gcicap
                    gcicap_airfields[#gcicap_airfields + 1] = coal_airfields[i]
                end
            end
        end

        if #gcicap_airfields == 0 then
            gcicap.log:warn("No airbase for $1 found")
        end
        return gcicap_airfields
    end

    -- returns all currently active aircraft
    function getAllActiveAircrafts()
        local filter = {"[red][plane]", "[red][helicopter]"}
        local all_aircraft = mist.makeUnitTable(filter)
        local active_aircraft = {}
        for i = 1, #all_aircraft do
            local ac = Unit.getByName(all_aircraft[i])
            if ac ~= nil then
                if Unit.isActive(ac) then
                    table.insert(active_aircraft, ac)
                end
            end
        end
        if #active_aircraft == 0 then
            gcicap.log:warn("No active aircraft for $1 found")
        end
        return active_aircraft
    end

    -- returns all currently active EWR and AWACS units
    local function getAllActiveEWR()
        local filter = {"[red][plane]", "[red][vehicle]", "[red][ship]"}
        local all_vecs = mist.makeUnitTable(filter)
        local active_ewr = {}

        for i = 1, #all_vecs do
            local vec = Unit.getByName(all_vecs[i])
            if vec ~= nil then
                if Unit.isActive(vec) then
                    local vec_type = Unit.getTypeName(vec)
                    if vec_type == "55G6 EWR" or vec_type == "1L13 EWR" then
                        table.insert(active_ewr, vec)
                    end
                    if (vec_type == "A-50" and gcicap.awacs) then
                        table.insert(active_ewr, vec)
                    end
                end
            end
        end
        if #active_ewr == 0 then
            gcicap.log:warn("No active EWR for $1 found")
        end
        return active_ewr
    end

    local function checkForAirspaceIntrusion()
        -- init some local vars
        local border = gcicap.border
        local active_ewr = gcicap.active_ewr
        local intruder_count = 0

        -- only do something if we have active ewr and active aircraft
        if #active_ac > 0 and #active_ewr > 0 then
            -- loop over all aircraft
            for i = 1, #active_ac do
                local ac = active_ac[i]
                local ac_detected = false
                local ac_intruded = false
                local ac_pos = {}
                local ac_group = nil
                local intruder_num = 0
                local ewr = nil
                if ac ~= nil then
                    ac_group = ac:getGroup()
                    if ac_group:isExist() then
                        ac_pos = ac:getPoint()

                        -- now loop over all ewr units
                        for n = 1, #active_ewr do
                            local ewr_controller = active_ewr[n]:getGroup():getController()
                            -- and check if the EWR detected the aircraft
                            if ewr_controller:isTargetDetected(ac, RADAR) then
                                ewr = active_ewr[n]
                                ac_detected = true
                                -- stop once it was detected by one EWR
                                break
                            end
                        end

                        if ac_detected then
                            ac_intruded = mist.pointInPolygon(ac_pos, border)
                            if ac_intruded then
                                local in_list = false
                                -- check if we already know about the intruder
                                for j = 1, #gcicap.intruders do
                                    if gcicap.intruders[j].name == ac_group:getName() then
                                        in_list = true
                                        intruder_num = j
                                        break
                                    end
                                end
                                if not in_list then
                                    intruder_count = intruder_count + 1

                                    gcicap.log:info(
                                        "$1 ($2) intruded airspace of red detected by $4 ($5)",
                                        ac_group:getName(),
                                        ac:getName(),
                                        ewr:getGroup():getName(),
                                        ewr:getName()
                                    )

                                    intruder = {
                                        name = ac_group:getName(),
                                        group = ac_group,
                                        detected_by = ewr,
                                        size = ac_group:getSize(),
                                        intercepted = false
                                    }
                                    table.insert(gcicap.intruders, intruder)
                                    intruder_num = #gcicap.intruders
                                end
                            end -- if ac_intruded
                        end -- if ac_detected
                    end -- if ac_group is existing
                end -- if ac ~= nil
            end -- for #active_ac
        end -- if active_ac > 0 and active_ewr > 0
        if intruder_count > 0 then
            return true
        else
            return false
        end
    end

    --- Returns first active unit of a group.
    -- @tparam Group group group whose first active
    -- unit to return.
    -- @treturn Unit first active unit of group.
    function gcicap.getFirstActiveUnit(group)
        if group ~= nil then
            -- engrish mast0r isExistsingsed
            if not group:isExist() then
                return nil
            end
            local units = group:getUnits()
            for i = 1, group:getSize() do
                if units[i] then
                    return units[i]
                end
            end
            return nil
        else
            return nil
        end
    end

    --- Returns the closest flights to the given unit.
    -- Flights returned are of given side. This function also returns
    -- their distance to the unit. The returned flights are sorted
    -- by distance. First is the closest.
    -- @tparam string side side whose flights to search.
    -- @tparam Unit unit unit object used as reference.
    -- @treturn table Array sorted by distance
    -- containing @{closestFlightsReturn} tables.
    function gcicap.getClosestFlightsToUnit(unit)
        if not unit then
            gcicap.log:error("Couldn't find unit.")
            return
        end
        local closest_flights = {}
        if #gcicap.cap.flights == 0 and #gcicap.gci.flights == 0 then
            gcicap.log:info("No CAP or GCI flights active")
            return nil
        else
            local unit_pos = mist.utils.makeVec2(unit:getPoint())
            local min_distance = -1
            for t, task in pairs(gcicap.tasks) do
                local flights = gcicap[task].flights
                for i = 1, #flights do
                    if flights[i].group then
                        local u = gcicap.getFirstActiveUnit(flights[i].group)
                        if u then
                            local u_pos = mist.utils.makeVec2(u:getPoint())
                            local distance = mist.utils.get2DDist(unit_pos, u_pos)
                            table.insert(closest_flights, {flight = flights[i], distance = distance})
                        else
                            break
                        end
                    end
                end
            end

            -- sort closest flights
            table.sort(
                closest_flights,
                function(a, b)
                    if a.distance < b.distance then
                        return true
                    else
                        return false
                    end
                end
            )

            --- Table returned by getClosestFlightsToUnit.
            -- @table closestFlightsReturn
            -- @tfield gcicap.Flight flight object
            -- @tfield number distance distance in meters from
            -- the unit.
            return closest_flights
        end
    end

    --- Returns a table containting a CAP route.
    -- Route originating from given airbase, waypoints
    -- are placed randomly inside given zone. Optionally
    -- you can specify the amount of waypoints inside the zone.
    -- @tparam string zone trigger zone name
    -- @tparam number vul_time time on station
    -- @tparam number leg_distance leg distance for race-track pattern orbit.
    function gcicap.buildCAPRoute(start_pos, zone, vul_time, leg_distance)
        local points = {}
        -- make altitude consistent for the whole route.
        local alt = math.random(gcicap.cap.min_alt, gcicap.cap.max_alt)

        local start_vul_script =
            "local group = ...\
                local flight = gcicap.Flight.getFlight(group)\
                if flight then\
                  gcicap.log:info('$1 starting vul time $2 at $3',\
                                  flight.group_name, flight.vul_time, flight.zone.name)\
                  flight.vul_start = timer.getAbsTime()\
                else\
                  gcicap.log:error('Could not find flight')\
                end"

        local end_vul_script =
            "local group = ...\
                local flight = gcicap.Flight.getFlight(group)\
                if flight then\
                  gcicap.log:info('$1 vul time over at $2',\
                                  flight.group_name, flight.zone.name)\
                  flight:taskWithRTB()\
                else\
                  gcicap.log:error('Could not find flight')\
                end"

        -- build orbit start waypoint
        local orbit_start_point = mist.getRandomPointInZone(zone)
        -- add a bogus waypoint so the start vul time script block
        -- isn't executed instantly after tasking
        points[1] = mist.fixedWing.buildWP(start_pos)
        points[2] = mist.fixedWing.buildWP(orbit_start_point)
        points[2].task = {}
        points[2].task.id = "ComboTask"
        points[2].task.params = {}
        points[2].task.params.tasks = {}
        points[2].task.params.tasks[1] = {
            number = 1,
            auto = false,
            id = "WrappedAction",
            enabled = true,
            params = {
                action = {
                    id = "Script",
                    params = {
                        command = start_vul_script
                    }
                }
            }
        }
        points[2].task.params.tasks[2] = {
            number = 2,
            auto = false,
            id = "ControlledTask",
            enabled = true,
            params = {
                task = {
                    id = "Orbit",
                    params = {
                        altitude = alt,
                        pattern = "Race-Track",
                        speed = gcicap.cap.speed
                    }
                },
                stopCondition = {
                    duration = vul_time * 60
                }
            }
        }

        -- if we don't use the race-track pattern we'll add the vul end time
        -- waypoint right where the start waypoint is and use the 'Circle' pattern.
        local orbit_end_point
        if not gcicap.cap.race_track_orbit then
            points[2].task.params.tasks[2].params.task.params.pattern = "Circle"
            orbit_end_point = start_pos
        else
            -- build second waypoint (leg end waypoint)
            --local orbit_end_point = mist.getRandPointInCircle(orbit_start_point, leg_distance, leg_distance)
            orbit_end_point = mist.getRandomPointInZone(zone)
        end

        points[3] = mist.fixedWing.buildWP(orbit_end_point)
        points[3].task = {
            id = "WrappedAction",
            params = {
                action = {
                    id = "Script",
                    params = {
                        command = end_vul_script
                    }
                }
            }
        }

        for i = 1, 3 do
            points[i].speed = gcicap.cap.speed
            points[i].alt = alt
        end

        -- local ground_level = land.getHeight(point)
        -- -- avoid crashing into hills
        -- if (alt - 100) < ground_level then
        --   alt = alt + ground_level
        -- end

        gcicap.log:info("Built CAP route with $1 min vul time at $2 meters in $3", vul_time, alt, zone)

        local route = {}
        route.points = points
        return route
    end
    --- Tasks group to automatically engage any spotted targets.
    -- @tparam Group group group to task.
    -- @tparam[opt] number max_dist maximum engagment distance.
    -- Targets further out (from the route) won't be engaged.
    function gcicap.taskEngage(group, max_dist)
        if not max_dist then
            max_dist = gcicap.cap.max_engage_distance
        end
        local ctl = group:getController()
        local engage = {
            id = "EngageTargets",
            params = {
                maxDist = max_dist,
                maxDistEnabled = true,
                targetTypes = {[1] = "Air"},
                priority = 0
            }
        }
        ctl:pushTask(engage)
    end
    --- Tasks group to engage a group.
    -- @tparam Group group group to task.
    -- @tparam Group target group that should be engaged by
    -- given group.
    function gcicap.taskEngageGroup(group, target)
        local ctl = group:getController()
        local engage_group = {
            id = "EngageGroup",
            params = {
                groupId = target:getID(),
                directionEnabled = false,
                priority = 0,
                altittudeEnabled = false
            }
        }
        ctl:pushTask(engage_group)
    end

    --- Spawns a fighter group.
    -- @tparam string name new group name.
    -- @tparam number size count of aircraft in the new group.
    -- @tparam Airbase airbase home plate of the new group.
    -- @tparam string spawn_mode How the new group will be spawned.
    -- Can be 'parking' or 'air'. 'parking' will spawn them at the ramp
    -- wit engines turned off. 'air' will spawn them in the air already
    -- flying.
    -- @tparam string task Task of the new group. Can either be 'cap',
    -- for combat air patrol, or 'gci', for ground controlled intercept.
    -- @tparam[opt] string zone zone name in which to spawn the unit. This only is
    -- taken into account if spawn_mode is "in-zone".
    -- @tparam[opt] boolean cold if set to true the newly group won't engage
    -- any enemys until tasked otherwise. Default false.
    -- @treturn Group|nil newly spawned group or nil on failure.
    function gcicap.spawnFighterGroup(name, size, spawn_mode, task, zone, cold)
        local template_unit_name = gcicap[task].template_prefix .. math.random(1, gcicap.template_count)
        local template_unit = Unit.getByName(template_unit_name)
        if not template_unit then
            gcicap.log:error(
                "Can't find template unit $1. This should never happen.\
                       Somehow the template unit got deleted.",
                template_unit_name
            )
            return nil
        end
        local template_group = mist.getGroupData(template_unit:getGroup():getName())
        local template_unit_data = template_group.units[1]
        local group_data = {}
        local unit_data = {}
        local onboard_num = template_unit_data.onboard_num - 1
        local route = {}
        local rand_point = {}
        if spawn_mode == "in-zone" then
            rand_point = mist.getRandomPointInZone(zone)
        end

        for i = 1, size do
            unit_data[i] = {}
            unit_data[i].type = template_unit_data.type
            unit_data[i].name = name .. " Pilot " .. i

            unit_data[i].x = rand_point.x + (50 * math.sin(math.random(10)))
            unit_data[i].y = rand_point.y + (50 * math.sin(math.random(10)))

            unit_data[i].alt = gcicap.cap.min_alt
            unit_data[i].onboard_num = onboard_num + i
            unit_data[i].groupName = name
            unit_data[i].payload = template_unit_data.payload
            unit_data[i].skill = template_unit_data.skill
            unit_data[i].livery_id = template_unit_data.livery_id
        end

        group_data.units = unit_data
        group_data.groupName = name
        --group_data.country = template_group.country
        group_data.country = template_unit:getCountry()
        group_data.category = template_group.category
        group_data.task = "CAP"

        route.points = {}
        route.points[1] = mist.fixedWing.buildWP(rand_point)
        route.points[1].alt = gcicap.cap.min_alt
        route.points[1].speed = gcicap.cap.speed
        group_data.route = route

        if mist.groupTableCheck(group_data) then
            spawn_pos = zone
            gcicap.log:info("Spawning fighter group $1 at $2", name, spawn_pos)
            mist.dynAdd(group_data)
        else
            gcicap.log:error("Couldn't spawn group with following groupTable: $1", group_data)
        end

        return Group.getByName(name)
    end

    --- Spawns a CAP flight.
    -- @tparam string zone CAP zone (trigger zone) name.
    -- @tparam string spawn_mode how the new CAP will be spawned.
    -- Can be 'parking' or 'air'.
    function gcicap.spawnCAP(zone, spawn_mode)
        -- increase flight number
        gcicap.cap.flight_num = gcicap.cap.flight_num + 1
        local group_name = "CAP " .. gcicap.cap.flight_num
        -- define size of the flight
        local size = gcicap.cap.group_size
        if size == "randomized" then
            size = math.random(1, 2) * 2
        else
            size = tonumber(size)
        end
        -- actually spawn something
        local group = gcicap.spawnFighterGroup(group_name, size, spawn_mode, "cap", zone.name)
        gcicap.supply = gcicap.supply - 1
        local flight = gcicap.Flight:new(group, "cap", zone)
        mist.scheduleFunction(gcicap.Flight.taskWithCAP, {flight}, timer.getTime() + 5)
        return group
    end

    --- Initialization function
    -- Checks if all template units are present. Creates
    -- border polygons if borders enabled.
    -- @todo complete documentation.
    function gcicap.init()
        if not (checkForTemplateUnits() and checkForTriggerZones()) then
            return false
        end
        if gcicap.borders_enabled then
            gcicap.border = mist.getGroupPoints(gcicap.border_group)
        end
        gcicap.intruders = {}
        gcicap.cap.zones = {}
        gcicap.cap.start = {}

        gcicap.cap.flights = {}
        gcicap.gci.flights = {}
        gcicap.cap.flight_num = 0
        gcicap.gci.flight_num = 0
        gcicap.airfields = getAirfields()

        -- loop through all zones
        for i = 1, gcicap.cap.zones_count do
            local zone_name = gcicap.cap.zone_name .. i
            local point = trigger.misc.getZone(zone_name).point
            local size = trigger.misc.getZone(zone_name).radius
            -- create zone table
            gcicap.cap.zones[i] = {
                name = zone_name,
                pos = point,
                radius = size,
                patrol_count = 0
            }
        end
        -- loop through all zones
        for i = 1, gcicap.cap.zones_count do
            local zone_name = gcicap.cap.start_name .. i
            local point = trigger.misc.getZone(zone_name).point
            local size = trigger.misc.getZone(zone_name).radius
            -- create zone table
            gcicap.cap.start[i] = {
                name = zone_name,
                pos = point,
                radius = size,
                patrol_count = 0
            }
        end

        for i = 1, gcicap.cap.groups_count do
            local spawn_mode = "parking"
            if not gcicap.cap.start_airborne then
                spawn_mode = "in-zone"
            end
            -- try to fill all zones
            local zone = gcicap.cap.start[i]
            -- if we have more flights than zones we select one random zone
            if zone == nil then
                zone = gcicap.cap.start[math.random(1, gcicap.cap.zones_count)]
            end
            -- actually spawn the group
            --local grp = gcicap.spawnCAP(zone, spawn_mode)
            -- delay the spawn by gcicap interval seconds after one another
            local spawn_delay = (i - 1) * gcicap.initial_spawn_delay
            mist.scheduleFunction(gcicap.spawnCAP, {zone, spawn_mode}, timer.getTime() + spawn_delay)
        end
        -- add event handler managing despawns
        return true
    end

    --- Main function.
    -- Run approx. every @{gcicap.interval} sconds. A random amount
    -- of 0 to 2 seconds is added for declustering.
    -- @todo do the "declustering" at a different level. Probably
    -- more efficient.
    function gcicap.main()
        -- update list of occupied airfields
        gcicap.airfields = getAirfields()
        -- update list of all aircraft
        gcicap.active_aircraft = getAllActiveAircrafts()
        -- update list of all EWR
        gcicap.active_ewr = getAllActiveEWR()

        manageCAP()
        -- checkForAirspaceIntrusion()
        -- handleIntrusion()
        -- garbageCollector()
    end
end

if gcicap.init() then
    local start_delay = gcicap.initial_spawn_delay
    mist.scheduleFunction(gcicap.main, {}, timer.getTime() + start_delay, gcicap.interval)
end
