Config = {}

-- Done
Config.DisableFlipVehicle = true -- If false you can use A and D to flip a vehicle back on its wheels
Config.NormalRepairkitAmount = 50.0 -- % that a Normal Repairkit does
Config.SundayDriver = true -- -- If true, the accelerator response is scaled to enable easy slow driving. Will not prevent full throttle. Does not work with binary accelerators like a keyboard. Set to false to disable. The included stop-without-reversing and brake-light-hold feature does also work for keyboards.
Config.WrongWayStress = true -- If driving agenst against trafic [WIP] 
--Done
Config.DisableVehicleAirControlls = true
-- Done
Config.EngineMinHealth = 50.0 -- 0.0 to disable
--Done
Config.SlowDegradingFailure = 250.0 -- Below this value (engine health), slow health degradation will set in
Config.FastDegradingFailure = 200.0 -- Below this value (engine health), health cascading failure will set in
-- Done
Config.DisableVehicleRewards = false

-- Vehicle Stall Still -- Done
Config.Stalls = true
Config.HealthStallAmount = 100.0 -- Vehicles under this health will start to stall

Config.CrashLoseFuel = nil -- Blue wanted it

Config.EngineDamageMulti = 1.0
Config.BodyDamageMulti = 1.0

BackEngineVehicles = {
    [`ninef`] = true,
    [`adder`] = true,
    [`vagner`] = true,
    [`t20`] = true,
    [`infernus`] = true,
    [`zentorno`] = true,
    [`reaper`] = true,
    [`comet2`] = true,
    [`jester`] = true,
    [`jester2`] = true,
    [`cheetah`] = true,
    [`cheetah2`] = true,
    [`prototipo`] = true,
    [`turismor`] = true,
    [`pfister811`] = true,
    [`ardent`] = true,
    [`nero`] = true,
    [`nero2`] = true,
    [`tempesta`] = true,
    [`vacca`] = true,
    [`bullet`] = true,
    [`osiris`] = true,
    [`entityxf`] = true,
    [`turismo2`] = true,
    [`fmj`] = true,
    [`re7b`] = true,
    [`tyrus`] = true,
    [`italigtb`] = true,
    [`penetrator`] = true,
    [`monroe`] = true,
    [`ninef2`] = true,
    [`stingergt`] = true,
    [`surfer`] = true,
    [`surfer2`] = true,
    [`comet3`] = true,
}

Config.VehicleClassDmgMultiplier = {
	[0] = 	0.3,		--	0: Compacts
			1.0,		--	1: Sedans
			0.3,		--	2: SUVs
			0.3,		--	3: Coupes
			0.3,		--	4: Muscle
			0.3,		--	5: Sports Classics
			0.3,		--	6: Sports
			0.3,		--	7: Super
			0.0,		--	8: Motorcycles
			0.3,		--	9: Off-road
			0.3,		--	10: Industrial
			0.3,		--	11: Utility
			0.3,		--	12: Vans
			0.3,		--	13: Cycles
			0.3,		--	14: Boats
			0.3,		--	15: Helicopters
			0.3,		--	16: Planes
			0.3,		--	17: Service
			0.3,		--	18: Emergency
			0.3,		--	19: Military
			0.3,		--	20: Commercial
			0.3			--	21: Trains
}
