SpecializationUtil.registerSpecialization("SaveMotorStatus", "SaveMotorStatus", g_currentModDirectory.."scripts/SaveMotorStatus.lua");
SpecializationUtil.registerSpecialization("SaveLightStatus", "SaveLightStatus", g_currentModDirectory.."scripts/SaveLightStatus.lua");
SpecializationUtil.registerSpecialization("SaveTurnOnVehicleStatus", "SaveTurnOnVehicleStatus", g_currentModDirectory.."scripts/SaveTurnOnVehicleStatus.lua");

print("--- registering SaveVehicleStatus Mod");

RegisterMod = {};

function RegisterMod:loadMap(name)

	for _, vehicleType in pairs(VehicleTypeUtil.vehicleTypes) do
		if vehicleType ~= nil then
			self:insertSpecialization(vehicleType, "SaveMotorStatus", { Motorized }, {'.SaveMotorStatus', '.saveMotorStatus'});
			self:insertSpecialization(vehicleType, "SaveLightStatus", { Lights }, {'.SaveLightStatus', '.saveLightStatus'});
			self:insertSpecialization(vehicleType, "SaveTurnOnVehicleStatus", { TurnOnVehicle }, {'.SaveTurnOnVehicleStatus', '.saveTurnOnVehicleStatus'});
		end;
	end;
	
end;

function RegisterMod:deleteMap()
end;

function RegisterMod:keyEvent(unicode, sym, modifier, isDown)
end;

function RegisterMod:mouseEvent(posX, posY, isDown, isUp, button)
end;

function RegisterMod:update(dt)
end;

function RegisterMod:draw()
end;

function RegisterMod:insertSpecialization(vehicleType, name, requiredSpecs, checkSpecs)
	local allowInsertion = true;
	for _, spec in pairs(requiredSpecs) do
		allowInsertion = SpecializationUtil.hasSpecialization(spec, vehicleType.specializations);
		if not allowInsertion then
			break;
		end;
	end;
	
	if allowInsertion then
		if vehicleType.name:find('.') then
			customEnvironment = Utils.splitString('.', vehicleType.name)[1];
		end;
		
		if customEnvironment then
			for _, spec in pairs(checkSpecs) do
				if rawget(SpecializationUtil.specializations, customEnvironment .. spec) ~= nil then
					allowInsertion = false;
					break;
				end;
			end;
		end;
		
		if allowInsertion then
			table.insert(vehicleType.specializations, SpecializationUtil.getSpecialization(name));
		end;
	end;
end;

addModEventListener(RegisterMod);