-- script CAP --
local DTgeneral = SET_GROUP:New()
DTgeneral:FilterPrefixes({"BS EWR", "RS AWACS"})
DTgeneral:FilterStart()
Detection = DETECTION_AREAS:New(DTgeneral, 30000)

local DTkhasab = SET_GROUP:New()
DTkhasab:FilterPrefixes({"BSK EWR", "RS AWACS"})
DTkhasab:FilterStart()
Detection_khasab = DETECTION_AREAS:New(DTkhasab, 15000)

CAPDispatcher = AI_A2A_DISPATCHER:New(Detection)
-- CAPDispatcher:SetTacticalDisplay(true)
KhasabDispatcher = AI_A2A_DISPATCHER:New(Detection_khasab)
-- KhasabDispatcher:SetTacticalDisplay(true)

-- GENERAL
local Khasab_base = ZONE_AIRBASE:New(AIRBASE.PersianGulf.Khasab, 5000)
local FrontGRAL2 = ZONE_POLYGON:New("FrontGRAL2", GROUP:FindByName("BORDER_general2"))
KhasabDispatcher:SetSquadron("CAP_Patrol_Khasab", AIRBASE.PersianGulf.Khasab, "KHASAB_M21B", 10)
KhasabDispatcher:SetSquadronTakeoffInAir("CAP_Patrol_Khasab")
KhasabDispatcher:SetSquadronCap("CAP_Patrol_Khasab", Khasab_base, 4000, 8000, 600, 800, 800, 1200, "BARO")
KhasabDispatcher:SetSquadronCapInterval("CAP_Patrol_Khasab", 1, 180, 600, 1)
KhasabDispatcher:SetSquadronOverhead("CAP_Patrol_Khasab", 1)
KhasabDispatcher:SetSquadronTakeoffFromRunway("CAP_Patrol_Khasab")

local FrontGRAL1 = ZONE_POLYGON:New("FrontGRAL1", GROUP:FindByName("BORDER_general1"))
CAPDispatcher:SetSquadron("Qeshm_CAP", AIRBASE.PersianGulf.Qeshm_Island, "QESHM_M29A" )
CAPDispatcher:SetSquadronTakeoffInAir("Qeshm_CAP")
CAPDispatcher:SetSquadronGci("Qeshm_CAP", 900, 1200)
CAPDispatcher:SetSquadronOverhead("Qeshm_CAP", 1)
CAPDispatcher:SetSquadronTakeoffInAir("Qeshm_CAP")

CAPDispatcher:SetSquadron("Bandar_CAP", AIRBASE.PersianGulf.Bandar_e_Jask_airfield, "BANDAR_M21B")
CAPDispatcher:SetSquadronTakeoffInAir("Bandar_CAP")
CAPDispatcher:SetSquadronGci("Bandar_CAP", 900, 1200)
CAPDispatcher:SetSquadronOverhead("Bandar_CAP", 1)
CAPDispatcher:SetSquadronTakeoffInAir("Bandar_CAP")
 
CAPDispatcher:SetSquadron("Lengeh_CAP", AIRBASE.PersianGulf.Bandar_Lengeh, "ABUMUSA_M29A")
CAPDispatcher:SetSquadronTakeoffInAir("Lengeh_CAP")
CAPDispatcher:SetSquadronGci("Lengeh_CAP", 900, 1200)
CAPDispatcher:SetSquadronOverhead("Lengeh_CAP", 1)
CAPDispatcher:SetSquadronTakeoffInAir("Lengeh_CAP")

--[[ CAPDispatcher:SetSquadron("TunbMusa_CAP", AIRBASE.PersianGulf.Tunb_Island_AFB, "TUNB_CAP_M29A")
CAPDispatcher:SetSquadronTakeoffInAir("TunbMusa_CAP")
CAPDispatcher:SetSquadronGci("TunbMusa_CAP", 900, 1200)
CAPDispatcher:SetSquadronOverhead("TunbMusa_CAP", 1)
CAPDispatcher:SetSquadronTakeoffInAir("TunbMusa_CAP") ]]

CAPDispatcher:SetDefaultGrouping(2)
CAPDispatcher:SetDefaultLandingAtRunway()
CAPDispatcher:SetBorderZone({FrontGRAL1})

KhasabDispatcher:SetDefaultGrouping(2)
KhasabDispatcher:SetDefaultLandingAtRunway()
KhasabDispatcher:SetBorderZone({FrontGRAL2})