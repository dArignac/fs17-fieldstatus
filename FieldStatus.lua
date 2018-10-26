-- Mod for Farming Simulator 17
-- Mod: Field Status
-- Author: darignac

-- Helper functions
-------------------------------------------------------------------------------
-- Transforms the given pixel value to the correct value for the game engine
local function pxToNormal(px, dimension)
	if dimension == 'x' then
		return (px / 1920);
	else
		return (px / 1080);
	end;
end;

-- Convert simple values to RGBA
function toRGBA(r, g, b, a)
	return {r/255, g/255, b/255, a};
end;
-------------------------------------------------------------------------------

-- Mod registration
-------------------------------------------------------------------------------
local modDesc = loadXMLFile("modDesc", g_currentModDirectory .. "modDesc.xml");

FieldStatus = {
	debug = true;
	isModInitialized = false;
	imgDirectory = g_currentModDirectory .. "res/";
	-- save this, as g_currentModDirectory is only available in this scope
	modDirectory = g_currentModDirectory;
	version = getXMLString(modDesc, "modDesc.version");
	author = getXMLString(modDesc, "modDesc.author");
};

addModEventListener(FieldStatus);
-------------------------------------------------------------------------------

-- Functions of the game
-------------------------------------------------------------------------------
-- called after/while (?) the map is/was loaded
function FieldStatus:loadMap()
	self:initializeMod();
end;

function FieldStatus:deleteMap()
end;

function FieldStatus:keyEvent(unicode, sym, modifier, isDown)
end;

function FieldStatus:mouseEvent(posX, posY, isDown, isUp, button)
end;

function FieldStatus:update(dt)
	self.handleUpdate(dt);
end;

function FieldStatus:draw()
end;
-------------------------------------------------------------------------------

-- Function of the mod
-------------------------------------------------------------------------------
function FieldStatus:initializeMod()
	if self.isModInitialized then
		self:debug('>>> Skipping initialization of FieldStatus as already initialized!');
        return;
    end;

    self.isModInitialized = true;
    self:debug(('>>> FieldStatus v%s by %s loaded...'):format(FieldStatus.version, FieldStatus.author));
end;

-- Prints the given text if the debug flag is enabled
function FieldStatus:debug(txt)
	if FieldStatus.debug then
		print(txt);
	end;
end;

function FieldStatus:handleUpdate(dt)
	if g_currentMission:getIsClient() then
		if InputBinding.hasEvent(InputBinding.FIELD_STATUS_HUD) then
			self:debug('keybinding called');
		end;
	end;
end;
-------------------------------------------------------------------------------