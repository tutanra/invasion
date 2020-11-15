--   CAP   -- 
_SETTINGS:SetPlayerMenuOff()

local DTeste = SET_GROUP:New()
DTeste:FilterPrefixes( {"RS AWACS","GLFEWR"} )
DTeste:FilterStart()
local Detection_Este = DETECTION_AREAS:New(DTeste, 200000)

-- GENERAL
GolfoDispatcher = AI_A2A_DISPATCHER:New(Detection_Este)
GolfoDispatcher:SetBorderZone( ZONE_POLYGON:New("FrontIran", GROUP:FindByName("redborder")) )
   
GolfoDispatcher:SetSquadron("CAP_Patrol_Shiraz", AIRBASE.PersianGulf.Lar_Airbase, "ABUMUSA_EASY1" )
GolfoDispatcher:SetSquadron("QESHM_PATROL", AIRBASE.PersianGulf.Bandar_Abbas_Intl, "ABUMUSA_EASY" )
-- GolfoDispatcher:SetSquadronOverhead("CAP_Patrol_Shiraz" ,2)
-- GolfoDispatcher:SetSquadronOverhead("QESHM_PATROL" ,2)

local CAPpatrolLar= ZONE:New( "CAPpatrol2")
GolfoDispatcher:SetSquadronCap("CAP_Patrol_Shiraz", CAPpatrolLar, 4000, 8000, 600, 800, 800, 1200, "BARO")
GolfoDispatcher:SetSquadronCapInterval("CAP_Patrol_Shiraz", 1, 180, 600)
GolfoDispatcher:SetSquadronGci("CAP_Patrol_Shiraz", 900, 2100)

local CAPpatrolQeshm = ZONE:New( "CAPpatrol1")
GolfoDispatcher:SetSquadronCap("QESHM_PATROL", CAPpatrolQeshm, 4000, 8000, 600, 800, 800, 1200, "BARO")
GolfoDispatcher:SetSquadronCapInterval("QESHM_PATROL", 1, 180, 600)

GolfoDispatcher:SetEngageRadius(150000)
GolfoDispatcher:SetGciRadius( 250000 )
GolfoDispatcher:SetDefaultGrouping(2)
GolfoDispatcher:SetDefaultTakeoffFromParkingCold()
-- GolfoDispatcher:SetTacticalDisplay(true)