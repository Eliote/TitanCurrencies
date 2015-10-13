--[[
	Description: Titan Panel plugin that shows your Currencies amount
	Author: Eliote
--]]

local ADDON_NAME, L = ...;
local VERSION = GetAddOnMetadata(ADDON_NAME, "Version")

--local PLAYER_NAME = "|c" .. RAID_CLASS_COLORS[select(2, UnitClass("player"))].colorStr .. UnitName("player")
--local PLAYER_REALM = GetRealmName();

local Color = {}
Color.WHITE = "|cFFFFFFFF"
Color.RED = "|cFFDC2924"
Color.YELLOW = "|cFFFFF244"
Color.GREEN = "|cFF3DDC53"
Color.ORANGE = "|cFFE77324"

local function ColorInt(value)
	if value > 0 then return Color.GREEN .. value .. "|r" end
	if value < 0 then return Color.RED .. value .. "|r" end

	return Color.WHITE .. (value)
end

local function OnClick(self, button)
	if (button == "LeftButton") then
		ToggleCharacter("TokenFrame");
	end
end

local menus = {
	{ type = "toggle", text = L["showBarBalance"], var = "ShowBarBalance", def = true },
	{ type = "rightSideToggle" },
}

--[[local function SaveValueForChar(id, value)
	local charTable = TitanGetVar(id, "charTable")
	charTable[PLAYER_NAME] = charTable[PLAYER_NAME] or {}
	charTable[PLAYER_NAME].gold = value
	charTable[PLAYER_NAME].realm = PLAYER_REALM
end]]

local function TitanCurrency(id, currencyId)

	--[[local GetCurrencyInfo = function(currencyId)
		local currencyName, currencyAmount, icon, a4, a5, maximumValue = GetCurrencyInfo(currencyId)

		SaveValueForChar(id, currencyAmount)

		return currencyName, currencyAmount, icon, a4, a5, maximumValue
	end]]

	local currencyName, currencyAmount, icon, _, _, maximumValue = GetCurrencyInfo(currencyId)

	local startAmount = 0

	local function GetButtonText()
		local text = TitanUtils_GetHighlightText(currencyAmount)

		if maximumValue > 0 and currencyAmount >= maximumValue * 0.75 then
			text = Color.YELLOW .. currencyAmount .. "|r"
		elseif currencyAmount == maximumValue then
			text = Color.RED .. currencyAmount .. "|r"
		end

		if TitanGetVar(id, "ShowBarBalance") then
			local dif = currencyAmount - startAmount
			if dif ~= 0 then
				text = text .. " [" .. ColorInt(dif) .. "]"
			end
		end

		return currencyName .. ": ", text
	end

	local function GetTooltipText()
		local text = L["value"] .. "\t" .. TitanUtils_GetHighlightText(currencyAmount) .. "\n"

		if maximumValue > 0 then
			text = text .. L["valueMax"] .. "\t" .. TitanUtils_GetHighlightText(maximumValue) .. "\n"
		end

		text = text .. L["thisSession"] .. "\t" .. ColorInt(currencyAmount - startAmount)

		return text
	end

	local eventsTable = {
		CURRENCY_DISPLAY_UPDATE = function()
			_, currencyAmount, _, _, _, maximumValue = GetCurrencyInfo(currencyId)

			TitanPanelButton_UpdateButton(id)
		end,
		PLAYER_ENTERING_WORLD = function(self)
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")

			_, startAmount = GetCurrencyInfo(currencyId)

			TitanPanelButton_UpdateButton(id)
		end
	}

	return L.Elib({
		id = id,
		name = "Currency [" .. Color.ORANGE .. currencyName .. "|r]",
		tooltip = currencyName,
		icon = icon,
		category = "Information",
		version = VERSION,
		getButtonText = GetButtonText,
		getTooltipText = GetTooltipText,
		eventsTable = eventsTable,
		menus = menus,
		onClick = OnClick
	})
end


TitanCurrency("CURRENCYID_61", 61) -- Dalaran Jewelcrafter's Token
TitanCurrency("CURRENCYID_81", 81) -- Epicurean's Award
TitanCurrency("CURRENCYID_241", 241) -- Champion's Seal
TitanCurrency("CURRENCYID_361", 361) -- Illustrious Jewelcrafter's Token
--TitanCurrency("CURRENCYID_384", 384) -- Dwarf Archaeology Fragment
--TitanCurrency("CURRENCYID_385", 385) -- Troll Archaeology Fragment
TitanCurrency("CURRENCYID_390", 390) -- Conquest Points
TitanCurrency("CURRENCYID_391", 391) -- Tol Barad Commendation
TitanCurrency("CURRENCYID_392", 392) -- Honor Points
--TitanCurrency("CURRENCYID_393", 393) -- Fossil Archaeology Fragment
--TitanCurrency("CURRENCYID_394", 394) -- Night Elf Archaeology Fragment
--TitanCurrency("CURRENCYID_397", 397) -- Orc Archaeology Fragment
--TitanCurrency("CURRENCYID_398", 398) -- Draenei Archaeology Fragment
--TitanCurrency("CURRENCYID_399", 399) -- Vrykul Archaeology Fragment
--TitanCurrency("CURRENCYID_400", 400) -- Nerubian Archaeology Fragment
--TitanCurrency("CURRENCYID_401", 401) -- Tol'vir Archaeology Fragment
TitanCurrency("CURRENCYID_402", 402) -- Ironpaw Token
TitanCurrency("CURRENCYID_416", 416) -- Mark of the World Tree
TitanCurrency("CURRENCYID_515", 515) -- Darkmoon Prize Ticket
TitanCurrency("CURRENCYID_614", 614) -- Mote of Darkness
TitanCurrency("CURRENCYID_615", 615) -- Essence of Corrupted Deathwing
--TitanCurrency("CURRENCYID_676", 676) -- Pandaren Archaeology Fragment
--TitanCurrency("CURRENCYID_677", 677) -- Mogu Archaeology Fragment
TitanCurrency("CURRENCYID_697", 697) -- Elder Charm of Good Fortune
TitanCurrency("CURRENCYID_738", 738) -- Lesser Charm of Good Fortune
TitanCurrency("CURRENCYID_752", 752) -- Mogu Rune of Fate
TitanCurrency("CURRENCYID_754", 754) -- Mantid Archaeology Fragment
TitanCurrency("CURRENCYID_776", 776) -- Warforged Seal
TitanCurrency("CURRENCYID_777", 777) -- Timeless Coin
TitanCurrency("CURRENCYID_789", 789) -- Bloody Coin
--TitanCurrency("CURRENCYID_821", 821) -- Draenor Clans Archaeology Fragment
TitanCurrency("CURRENCYID_823", 823) -- Apexis Crystal
TitanCurrency("CURRENCYID_824", 824) -- Garrison Resources
--TitanCurrency("CURRENCYID_828", 828) -- Ogre Archaeology Fragment
--TitanCurrency("CURRENCYID_829", 829) -- Arakkoa Archaeology Fragment
TitanCurrency("CURRENCYID_910", 910) -- Secret of Draenor Alchemy
TitanCurrency("CURRENCYID_944", 944) -- Artifact Fragment
TitanCurrency("CURRENCYID_980", 980) -- Dingy Iron Coins
TitanCurrency("CURRENCYID_994", 994) -- Seal of Tempered Fate
TitanCurrency("CURRENCYID_999", 999) -- Secret of Draenor Tailoring
TitanCurrency("CURRENCYID_1008", 1008) -- Secret of Draenor Jewelcrafting
TitanCurrency("CURRENCYID_1017", 1017) -- Secret of Draenor Leatherworking
TitanCurrency("CURRENCYID_1020", 1020) -- Secret of Draenor Blacksmithing
TitanCurrency("CURRENCYID_1101", 1101) -- Oil
TitanCurrency("CURRENCYID_1129", 1129) -- Seal of Inevitable Fate
TitanCurrency("CURRENCYID_1166", 1166) -- Timewarped Badge

