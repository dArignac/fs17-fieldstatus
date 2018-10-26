-- Mod for Farming Simulator 17
-- Mod: Field Status
-- Author: darignac
local debug = true;  -- FIXME remove somewhen

-- Helper functions
-------------------------------------------------------------------------------
-- Transforms the given pixel value to the correct value for the game engine
local function pxToNormal(px, dimension)
	-- FIXME what if someone used a different resolution?
	if dimension == "x" then
		return (px / 1920);
	else
		return (px / 1080);
	end;
end;

-- Convert simple values to RGBA
local function toRGBA(r, g, b, a)
	return {r/255, g/255, b/255, a};
end;

-- Prints the given text if the debug flag is enabled
local function debug(txt)
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
		width = pxToNormal(200, "x");
		height = pxToNormal(100, "y");
		horizontalMargin = pxToNormal(16, "x");
		fontSize = pxToNormal(14, "y");
		paddingUntransformed = 5;
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
	--DebugUtil.printTableRecursively(g_currentMission, " ", 0, 1);
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
		debug(">>> Skipping initialization of FieldStatus as already initialized!");
        return;
	end;
	
	-- load background image
	self.hud.overlayBgImageId = createImageOverlay(FieldStatus.imgDirectory .. "white.png");

	-- calculate hud positions
	self.hud.x1 = 1 - self.hud.width - self.hud.horizontalMargin;
	self.hud.y1 = pxToNormal(390, "y");
	self.hud.textX = self.hud.x1 + pxToNormal(self.hud.paddingUntransformed, "x");
	self.hud.textY = self.hud.y1 + pxToNormal(self.hud.paddingUntransformed, "y");

	-- check fields of player, FIXME: needs to find out if new fields were bought via event or so?
	-- taken from https://gdn.giants-software.com/documentation_scripting.php?version=script&category=65&class=3350#new45512
	--local isOwned = g_currentMission:getIsServer() and Utils.getNoNil(getUserAttribute(currentFieldDef, "ownedByPlayer"), false);
	--g_currentMission
	--	fieldDefinitionBase :: table: 0x0250f0ac37f8
	--		unownedFields :: table: 0x0250f0bb5f00
	--		isEnabled :: true
	--		fieldDefsByFieldNumber :: table: 0x0250f0b33360
	--		fieldDefs :: table: 0x0250f0aadb18
	--		objectActivated :: false
	--		numberOfFields :: 31
	--		isInit :: false
	--		activateText :: Feld kaufen oder bewirtschaften

	--[[
		partial output of
			DebugUtil.printTableRecursively(g_currentMission.fieldDefinitionBase.fieldDefsByFieldNumber, " ", 0, 1);
		
	13 :: table: 0x0241708e1b30
		npcIndex :: 9
		fieldJobHotspot :: table: 0x0241729a2738
		fieldBuyTrigger :: 19247
		fieldPriceInitial :: 258390.00463486
		fieldNumber :: 13
		rootNode :: 19246
		fieldDimensions :: 19250
		ownedByPlayer :: false
		getFieldStatusPartitions :: table: 0x024172cd6c80
		fieldPrice :: 258390.00463486
		maxFieldStatusPartitions :: table: 0x0241729f4d68
		setFieldStatusPartitions :: table: 0x0241729a2440
		fieldJobVehicleSpawnDirection :: 1
		fieldArea :: 3.1900000572205
		fieldMapHotspot :: table: 0x024172921118
		fieldJobUsageAllowed :: true
		fieldPriceFactor :: 1
		fieldAngle :: 2
		fieldBuySymbol :: 19248
		fieldMapIndicator :: 19257
		fieldName ::
	14 :: table: 0x024172c5bb68
		npcIndex :: 1
		setFieldStatusPartitions :: table: 0x02417397e140
		fieldBuyTrigger :: 19259
		fieldPriceInitial :: 101250
		fieldNumber :: 14
		rootNode :: 19258
		fieldDimensions :: 19262
		ownedByPlayer :: true
		getFieldStatusPartitions :: table: 0x024173bf5238
		fieldPrice :: 101250
		maxFieldStatusPartitions :: table: 0x024172a2ac00
		fieldJobVehicleSpawnDirection :: -1
		fieldArea :: 1.25
		fieldMapHotspot :: table: 0x024172fa7a40
		fieldJobUsageAllowed :: true
		fieldPriceFactor :: 1
		fieldAngle :: 2
		fieldBuySymbol :: 19260
		fieldMapIndicator :: 19266
		fieldName ::
	]]--

	-- set initialization to done
    self.isModInitialized = true;
    debug((">>> FieldStatus v%s by %s loaded..."):format(FieldStatus.version, FieldStatus.author));
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
	setTextColor(unpack(toRGBA(1, 1, 1, 1.0)));
	local fields = {"7", "12", "21"};
	for idx, field in pairs(fields) do
		local movingY = pxToNormal(450, "y") - pxToNormal(((idx - 1) * 20), "y");
		--debug(("DEBUG idx %s, field %s, x %s, y %s"):format(idx, field, self.hud.textX, movingY));
		renderText(self.hud.textX, movingY, self.hud.fontSize, ("Feld %02d: XX.XX"):format(field));
	end;
end;
-------------------------------------------------------------------------------