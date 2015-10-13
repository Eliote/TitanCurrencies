--
-- Author: Eliote
-- Date: 14/09/2015
--

local ADDON_NAME, L = ...;
local VERSION = GetAddOnMetadata(ADDON_NAME, "Version")
local ID = "TITAN_OURO_2"

local Color = {}
Color.RED = "|cFFDC2924"
Color.GREEN = "|cFF3DDC53"
Color.OURO = "|cFFFFFF00"
Color.PRATA = "|cFFCCCCCC"
Color.BRONZE = "|cFFFF6600"

local ICO_OURO = "|TInterface\\MoneyFrame\\UI-GoldIcon:0|t"
local ICO_PRATA = "|TInterface\\MoneyFrame\\UI-SilverIcon:0|t"
local ICO_BRONZE = "|TInterface\\MoneyFrame\\UI-CopperIcon:0|t"

local PLAYER_NAME = "|c" .. RAID_CLASS_COLORS[select(2, UnitClass("player"))].colorStr .. UnitName("player")
local PLAYER_FACTION = UnitFactionGroup("Player")
local PLAYER_REALM = GetRealmName();

local startMoney = 0


local function formatGold(value, cor, somenteMaior)
	local text = ""

	if not somenteMaior or value >= 10000 then
		text = text .. (cor or Color.OURO) .. math.floor(value / 10000) .. ICO_OURO .. "|r "
	end

	if not somenteMaior or (value >= 100 and value < 10000) then
		text = text .. (cor or Color.PRATA) .. math.floor((value / 100) % 100) .. ICO_PRATA .. "|r "
	end

	if not somenteMaior or (value < 100) then
		text = text .. (cor or Color.BRONZE) .. math.floor(value % 100) .. ICO_BRONZE .. "|r"
	end

	return text:trim()
end

local function GetAndSaveMoney(id)
	local money = GetMoney("player")

	local charTable = TitanGetVar(id, "charTable")
	charTable[PLAYER_NAME] = charTable[PLAYER_NAME] or {}
	charTable[PLAYER_NAME].gold = money
	charTable[PLAYER_NAME].realm = PLAYER_REALM
	charTable[PLAYER_NAME].faction = PLAYER_FACTION

	return money
end

local function GetButtonText(self, id)
	local money = GetAndSaveMoney(id)

	local balance = ""
	if TitanGetVar(id, "ShowBarBalance") then
		local dif = money - startMoney
		if dif > 0 then
			balance = Color.GREEN .. " [+" .. formatGold(dif, nil, true) .. Color.GREEN .. "]"
		elseif dif < 0 then
			balance = Color.RED .. " [-" .. formatGold(-dif, Color.RED, true) .. Color.RED .. "]"
		end
	end

	return L["GoldTitle"] .. ": ", formatGold(money, nil, TitanGetVar(id, "ShowHigherOnly")) .. balance
end

local function GetTooltipText(self, id)
	local money = GetAndSaveMoney(id)

	local text = PLAYER_NAME .. "|r\t" .. formatGold(money) .. "\n"

	local charTable = TitanGetVar(id, "charTable")
	local total = money
	for k, v in pairs(charTable) do
		if PLAYER_REALM == v.realm and PLAYER_FACTION == v.faction and PLAYER_NAME ~= k then
			text = text .. k .. "|r\t" .. formatGold(v.gold) .. "\n"
			total = total + v.gold
		end
	end

	text = text .. "-----\n"
	text = text .. "Total:\t" .. formatGold(total) .. "\n\n"

	local dif = money - startMoney
	if dif > 0 then
		text = text .. L["session"] .. "\t" .. formatGold(dif)
	elseif dif < 0 then
		text = text .. L["session"] .. "\t" .. formatGold(-dif, Color.RED)
	end

	return text:trim()
end

local function OnClick(self, button)
	if (button == "LeftButton") then
		ToggleCharacter("TokenFrame");
	end
end

local menus = {
	{ type = "toggle", text = L["HigherOnly"], var = "ShowHigherOnly" },
	{ type = "toggle", text = L["showbb"], var = "ShowBarBalance", def = true },
	{ type = "rightSideToggle" },
	{ type = "space"},
	{ type = "button", text = L["GoldClear"], func = function() TitanSetVar(ID, "charTable", {}); GetAndSaveMoney(ID) end }
}

local eventsTable = {
	PLAYER_ENTERING_WORLD = function(self)
		self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		self.PLAYER_ENTERING_WORLD = nil

		startMoney = GetAndSaveMoney(self.registry.id)

		TitanPanelButton_UpdateButton(self.registry.id)
	end,
	PLAYER_MONEY = function(self)
		TitanPanelButton_UpdateButton(self.registry.id)
	end
}

L.Elib({
	id = ID,
	name = "Titan|cFF007edd " .. L["GoldTitle"] .. "|r",
	tooltip = L["GoldTitle"],
	icon = "Interface\\Icons\\inv_misc_coin_02.blp",
	category = "Information",
	version = VERSION,
	getButtonText = GetButtonText,
	getTooltipText = GetTooltipText,
	eventsTable = eventsTable,
	onClick = OnClick,
	menus = menus,
	savedVariables = { charTable = {} }
})


