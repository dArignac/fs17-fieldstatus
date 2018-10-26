-- Mod for Farming Simulator 17
-- Mod: Field Status
-- Author: darignac
local debug = true;  -- FIXME remove somewhen

-- Helper functions
-------------------------------------------------------------------------------
-- Transforms the given pixel value to the correct value for the game engine
local function pxToNormal(px, dimension)
	-- FIXME what if someone used a different resolution?
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

-- Prints the given text if the debug flag is enabled
function debug(txt)
	if debug then
		print(txt);
	end;
end;
-------------------------------------------------------------------------------


-- Mod registration
-------------------------------------------------------------------------------
local modDesc = loadXMLFile("modDesc", g_currentModDirectory .. "modDesc.xml");

FieldStatus = {
	imgDirectory = g_currentModDirectory .. "res/";
	-- save this, as g_currentModDirectory is only available in this scope
	modDirectory = g_currentModDirectory;
	version = getXMLString(modDesc, "modDesc.version");
	author = getXMLString(modDesc, "modDesc.author");
	-- values for execution
	isModInitialized = false;
	renderHUD = false;
	hud = {
		overlayBgImageId = nil; -- overlayId for background image
		width = pxToNormal(200, 'x');
		height = pxToNormal(100, 'y');
		horizontalMargin = pxToNormal(16, 'x');
		x1 = nil; -- x position of upper left pixel of hud
		y1 = nil; -- y position of upper left pixel of hud
		--x2 = nil; -- x position of lower right pixel of hud
		--y2 = nil; -- y position of lower right pixel of hud
	};
};

addModEventListener(FieldStatus);
-------------------------------------------------------------------------------


-- Function interfaces of the game
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
	self:handleUpdate(dt);
end;

function FieldStatus:draw()
	if self.renderHUD then
		self:render();
	end;
end;
-------------------------------------------------------------------------------


-- Function of the mod
-------------------------------------------------------------------------------
function FieldStatus:initializeMod()
	-- if already initialized, skip addtional init
	if self.isModInitialized then
		debug('>>> Skipping initialization of FieldStatus as already initialized!');
        return;
	end;
	
	-- load background image
	self.hud.overlayBgImageId = createImageOverlay(FieldStatus.imgDirectory .. "white.png");

	-- calculate hud positions
	self.hud.x1 = 1 - self.hud.width - self.hud.horizontalMargin;
	self.hud.y1 = pxToNormal(390, 'y');
	--self.hud.x2 = self.hud.x1 - self.hud.width;
	--self.hud.y2 = self.hud.y1 + self.hud.height;

	-- set initialization to done
    self.isModInitialized = true;
    debug(('>>> FieldStatus v%s by %s loaded...'):format(FieldStatus.version, FieldStatus.author));
end;

function FieldStatus:handleUpdate(dt)
	if g_currentMission:getIsClient() then
		if InputBinding.hasEvent(InputBinding.FIELD_STATUS_HUD) then
			-- toggle hud display, the rendering happens in FieldStatus:render()
			if self.renderHUD then
				self.renderHUD = false;
			else
				self.renderHUD = true;
			end;
		end;
	end;
end;

-- called from the FieldStatus:draw() if FieldStatus.renderHUD is true
-- is called over and over again
function FieldStatus:render()
	renderOverlay(self.hud.overlayBgImageId, self.hud.x1, self.hud.y1, self.hud.width, self.hud.height);
end;
-------------------------------------------------------------------------------