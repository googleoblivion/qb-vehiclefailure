local QBCore = exports['qb-core']:GetCoreObject()
local isBrakingForward = false
local isBrakingReverse = false

local vehicleEngineHealth = 1000
local vehicleBodyHealth = 1000
local vehiclePetrolHealth = 1000

-- -- Functions

local function CleanVehicle(veh)
	local ped = PlayerPedId()
	TaskStartScenarioInPlace(ped, "WORLD_HUMAN_MAID_CLEAN", 0, true)

	if lib.progressCircle({
		duration = math.random(10000, 20000),
		label = Lang:t("progress.clean_veh"),
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
	}) then
		print('Do stuff when complete')
		ClearPedTasks(ped)
		SetVehicleDirtLevel(veh, 0.1)
		SetVehicleUndriveable(veh, false)
		WashDecalsFromVehicle(veh, 1.0)
		TriggerServerEvent('qb-vehiclefailure:server:removewashingkit', veh)
		TriggerEvent('inventory:client:ItemBox', QBCore.Shared.Items["cleaningkit"], "remove")
	else
		print('Do stuff when cancelled')
		ClearPedTasks(ped)
	end
end

local function RepairVehicle(veh, isadvanced)
    SetVehicleDoorOpen(veh, 4, false, false)
	if lib.progressCircle({
		duration = math.random(10000, 20000),
		label = 'Repairing...',
		position = 'bottom',
		useWhileDead = false,
		canCancel = true,
		disable = {
			car = true,
		},
		anim = {
			dict = 'mini@repair',
			clip = 'fixing_a_player' 
		},
	}) then
		print('Do stuff when complete')
		SetVehicleDoorShut(veh, 4, false)
		if isadvanced then
			SetVehicleEngineHealth(veh, 1000.0)
			TriggerServerEvent('qb-vehiclefailure:removeItem', "advancedrepairkit")
		else
			SetVehicleEngineHealth(veh, 500.0)
			TriggerServerEvent('qb-vehiclefailure:removeItem', "repairkit")
		end
		-- SetVehicleEngineOn(veh, true, false, false)
		SetVehicleTyreFixed(veh, 0)
		SetVehicleTyreFixed(veh, 1)
		SetVehicleTyreFixed(veh, 2)
		SetVehicleTyreFixed(veh, 3)
		SetVehicleTyreFixed(veh, 4)
	else
		print('Do stuff when cancelled')
	end
	SetVehicleDoorShut(veh, 4, false)
end

local function isPedDrivingAVehicle()
	local ped = PlayerPedId()
	vehicle = GetVehiclePedIsIn(ped, false)
	if IsPedInAnyVehicle(ped, false) then
		-- Check if ped is in driver seat
		if GetPedInVehicleSeat(vehicle, -1) == ped then
			local class = GetVehicleClass(vehicle)
			-- We don't want planes, helicopters, bicycles and trains
			if class ~= 15 and class ~= 16 and class ~=21 and class ~=13 then
				return true
			end
		end
	end
	return false
end

local function IsBackEngine(veh)
	local eng = GetEntityBoneIndexByName(veh, 'engine')
	if eng ~= -1 then
		local vpos = GetOffsetFromEntityInWorldCoords(veh, 0.0, 2.0, 0.0)
		local bpos = GetWorldPositionOfEntityBone(veh, eng)
		local dist = #(vpos-bpos)
		if dist > 1.0 then
			return true
		end
	end
	return false
end

-- -- Events

RegisterNetEvent('qb-vehiclefailure:client:Repairkit', function(isadvanced)
	local veh = QBCore.Functions.GetClosestVehicle()
	local engineHealth = GetVehicleEngineHealth(veh)
	if veh ~= nil and veh ~= 0 then
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local vehpos = GetEntityCoords(veh)
		if #(pos - vehpos) < 5.0 and not IsPedInAnyVehicle(ped) then
			local drawpos = GetOffsetFromEntityInWorldCoords(veh, 0, 2.5, 0)
			if #(pos - drawpos) < 2.0 and not IsPedInAnyVehicle(ped) then
				if not isadvanced and engineHealth >= 500 then
					QBCore.Functions.Notify(Lang:t("error.healthy_veh"), "error")
				else
					RepairVehicle(veh, isadvanced)
				end
			end
		else
			if #(pos - vehpos) > 4.9 then
				QBCore.Functions.Notify(Lang:t("error.out_range_veh"), "error")
			else
				QBCore.Functions.Notify(Lang:t("error.inside_veh"), "error")
			end
		end
	else
		if veh == nil or veh == 0 then
			QBCore.Functions.Notify(Lang:t("error.not_near_veh"), "error")
		end
	end
end)

RegisterNetEvent('qb-vehiclefailure:client:SyncWash', function(veh)
	SetVehicleDirtLevel(veh, 0.1)
	SetVehicleUndriveable(veh, false)
	WashDecalsFromVehicle(veh, 1.0)
end)

RegisterNetEvent('qb-vehiclefailure:client:CleanVehicle', function()
	local veh = QBCore.Functions.GetClosestVehicle()
	if veh ~= nil and veh ~= 0 then
		local ped = PlayerPedId()
		local pos = GetEntityCoords(ped)
		local vehpos = GetEntityCoords(veh)
		if #(pos - vehpos) < 3.0 and not IsPedInAnyVehicle(ped) then
			CleanVehicle(veh)
		end
	end
end)

RegisterNetEvent('qb-vehiclefailure:client:AdminRepair', function()
	if isPedDrivingAVehicle() then
		local ped = PlayerPedId()
		vehicle = GetVehiclePedIsIn(ped, false)
		SetVehicleDirtLevel(vehicle)
		SetVehicleUndriveable(vehicle, false)
		WashDecalsFromVehicle(vehicle, 1.0)
		QBCore.Functions.Notify(Lang:t("success.repaired_veh"))
		SetVehicleFixed(vehicle)
		vehicleEngineHealth = 1000.0
		vehicleBodyHealth = 1000.0
		vehiclePetrolHealth = 1000.0
		SetVehicleEngineOn(vehicle, true, false, false)
		return
	else
		QBCore.Functions.Notify(Lang:t("error.inside_veh_req"))
	end
end)

local vehicle = nil
local StallTimeout = false

sundayDriverAcceleratorCurve = 7.5
sundayDriverBrakeCurve = 5.0

RegisterNetEvent('baseevents:enteredVehicle', function (veh, CurrentSeat, displayname, netID)
    vehicle = veh
	local model = GetEntityModel(vehicle)
	local oldBodyDamage = GetVehicleBodyHealth(vehicle)
	local vehicleClass = GetVehicleClass(vehicle)
	vehicleEngineHealth = GetVehicleEngineHealth(vehicle)
	vehicleBodyHealth = GetVehicleBodyHealth(vehicle)
	vehiclePetrolHealth = GetVehiclePetrolTankHealth(vehicle)
	local isBack = IsBackEngine(vehicle)
	CreateThread(function()
		while vehicle do
			-- Air Controls
			local sleep = 0
			if Config.DisableVehicleAirControls and IsEntityInAir(vehicle) then
				if not IsThisModelABoat(model) and not IsThisModelAHeli(model) and not IsThisModelAPlane(model) and not IsThisModelABike(model) and not IsThisModelABicycle(model) then
					sleep = 0
					DisableControlAction(0, 59) -- leaning A/D
					DisableControlAction(0, 60) -- leaning W/S
				end
			end
			-- Vehicle Flip
			if Config.DisableFlipVehicle then
				local roll = GetEntityRoll(vehicle)
				if (roll > 75.0 or roll < -75.0) and GetEntitySpeed(vehicle) < 2 then
					sleep = 0
					DisableControlAction(2,59,true) -- Disable left/right
					DisableControlAction(2,60,true) -- Disable up/down
				end
			end
			Wait(sleep)
		end
	end)

	CreateThread(function()
		while vehicle do
			local sleep = 50
			if isPedDrivingAVehicle() then -- Find better way later or somethign
				vehicleClass = GetVehicleClass(vehicle)
				vehicleEngineHealth = GetVehicleEngineHealth(vehicle)
				vehicleBodyHealth = GetVehicleBodyHealth(vehicle)
				vehiclePetrolHealth = GetVehiclePetrolTankHealth(vehicle)

				if vehicleBodyHealth ~= oldBodyDamage then
					print('^1Body Health Changed')
					local amountDamaged = oldBodyDamage - vehicleBodyHealth
					print('Damage Done: '..amountDamaged)
					if amountDamaged > 7.0 then
						SetVehicleUndriveable(vehicle, true)
						Wait(2000)
						SetVehicleUndriveable(vehicle, false)
					end
					oldBodyDamage = vehicleBodyHealth
					print('New Health: '..oldBodyDamage)
					SetVehicleBodyHealth(vehicle, oldBodyDamage)
				end

				-- print(vehicleEngineHealth, vehicleBodyHealth, vehiclePetrolHealth)

				-- print(Citizen.InvokeNative(0xF10B44FD479D69F3, PlayerId(), 2))

				if vehicleEngineHealth <= Config.EngineMinHealth then
					SetVehicleUndriveable(vehicle, true)
					SetVehicleEngineHealth(vehicle, Config.EngineMinHealth)
					SetVehicleEngineOn(vehicle, false, true, true)
				end

				if Config.Stalls and vehicleEngineHealth < Config.HealthStallAmount and vehicleEngineHealth > Config.EngineMinHealth and not StallTimeout then
					StallTimeout = true
					lib.notify({
						id = 'vehicle_stalled',
						description = 'Your vehicle stalled!',
						position = 'top-right',
						style = {
							backgroundColor = '#141517',
							color = '#909296'
						},
						icon = 'car',
						iconColor = '#C53030'
					})
					SetVehicleUndriveable(vehicle, true)
					Wait(math.random(1000, 7000))
					SetVehicleUndriveable(vehicle, false)
					SetTimeout(math.random(10000, 20000), function()
						StallTimeout = false
					end)
				end

				if vehicleEngineHealth > Config.EngineMinHealth and vehicleEngineHealth < Config.SlowDegradingFailure then
					SetVehicleEngineHealth(vehicle, vehicleEngineHealth - 0.3)
				end

				if Config.SundayDriver and vehicleClass ~= 14 then -- Not for boats
					local accelerator = GetControlValue(2,71)
					local brake = GetControlValue(2,72)
					local speed = GetEntitySpeedVector(vehicle, true)['y']
					-- Change Braking force
					if speed >= 1.0 then
						-- Going forward
						if brake > 127 then
							-- Forward and braking
							isBrakingForward = true
						end
					elseif speed <= -1.0 then
						if accelerator > 127 then
							-- Reversing and braking (Using the accelerator)
							isBrakingReverse = true
						end
					else
						-- Stopped or almost stopped or sliding sideways
						local entitySpeed = GetEntitySpeed(vehicle)
						if entitySpeed < 1 then
							-- Not sliding sideways
							if isBrakingForward == true then
								sleep = 0
								--Stopped or going slightly forward while braking
								DisableControlAction(2,72,true) -- Disable Brake until user lets go of brake
								SetVehicleForwardSpeed(vehicle,speed*0.98)
								SetVehicleBrakeLights(vehicle,true)
							end
							if isBrakingReverse == true then
								--Stopped or going slightly in reverse while braking
								DisableControlAction(2,71,true) -- Disable reverse Brake until user lets go of reverse brake (Accelerator)
								SetVehicleForwardSpeed(vehicle,speed*0.98)
								SetVehicleBrakeLights(vehicle,true)
							end
							if isBrakingForward == true and GetDisabledControlNormal(2,72) == 0 then
								-- We let go of the brake
								isBrakingForward=false
							end
							if isBrakingReverse == true and GetDisabledControlNormal(2,71) == 0 then
								-- We let go of the reverse brake (Accelerator)
								isBrakingReverse=false
							end
						end
					end
				end
			end
			Wait(sleep)
		end
	end)
end)

RegisterCommand('vehdebug', function(source, args)
	SetVehicleEngineHealth(vehicle, tonumber(args[1] + .0))
end)

RegisterNetEvent('baseevents:leftVehicle', function (veh, CurrentSeat)
    vehicle = nil
end)

if Config.DisableVehicleRewards then
	CreateThread(function()
		while true do
			Wait(0)
			DisablePlayerVehicleRewards(PlayerId())
		end
	end)
end