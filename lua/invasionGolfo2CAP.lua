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

GolfoDispatcher:SetSquadronCap("CAP_Patrol_Shiraz", ZONE_AIRBASE:New(AIRBASE.PersianGulf.Lar_Airbase, 10000), 4000, 8000, 600, 800, 800, 1200, "BARO")
GolfoDispatcher:SetSquadronCapInterval("CAP_Patrol_Shiraz", 1, 180, 600)
GolfoDispatcher:SetSquadronGci("CAP_Patrol_Shiraz", 900, 2100)

GolfoDispatcher:SetSquadronCap("QESHM_PATROL", ZONE_POLYGON:New( "CAP Zone East", GROUP:FindByName( "CAPIRANPATROL" ) ), 4000, 8000, 600, 800, 800, 1200, "BARO")
GolfoDispatcher:SetSquadronCapInterval("QESHM_PATROL", 1, 180, 600)

GolfoDispatcher:SetEngageRadius(200000)
GolfoDispatcher:SetGciRadius( 250000 )
GolfoDispatcher:SetDefaultGrouping(2)
GolfoDispatcher:SetDefaultTakeoffFromParkingHot()
GolfoDispatcher:SetTacticalDisplay(true)