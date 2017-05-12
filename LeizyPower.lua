--
-- Created by IntelliJ IDEA.
-- User: leizy
-- Date: 2017/4/27 0027
-- Time: 上午 11:28
-- To change this template use File | Settings | File Templates.
--

local LeizyRune, ns = ...
local updatetime = .25
local update = 0
local powerdatas = {}
powerdatas.x = 0
powerdatas.y = -125
powerdatas.FontSize = 18
powerdatas.Alpha = 0.45
powerdatas.powercolor = {
    ["ENERGY"] = { 255 / 255, 255 / 255, 225 / 255 },
    ["FOCUS"] = { 255 / 255, 192 / 255, 0 / 255 },
    ["MANA"] = { 1 / 255, 121 / 255, 228 / 255 },
    ["RAGE"] = { 255 / 255, 26 / 255, 48 / 255 },
    ["FURY"] = { 255 / 255, 50 / 255, 50 / 255 },
    ["MAELSTROM"] = { 0 / 255, 200 / 255, 255 / 255 },
    ["INSANITY"] = { 149 / 255, 97 / 255, 219 / 255 },
    ["LUNAR_POWER"] = { 134 / 255, 143 / 255, 254 / 255 },
    ["RUNIC_POWER"] = { 134 / 255, 239 / 255, 254 / 255 },
    ["RUNES"] = { 0 / 255, 200 / 255, 255 / 255 },
    ["FUEL"] = { 0, 0.55, 0.5 },
    ["AMMOSLOT"] = { 1, 0.60, 0 },
    ['POWER_TYPE_STEAM'] = { 0.55, 0.57, 0.61 },
    ['POWER_TYPE_PYRITE'] = { 0.60, 0.09, 0.17 },
    ['POWER_TYPE_HEAT'] = { 0.55, 0.57, 0.61 },
    ['POWER_TYPE_OOZE'] = { 0.76, 1, 0 },
    ['POWER_TYPE_BLOOD_POWER'] = { 0.7, 0, 1 },
}
powerdatas.barWidth = 170
powerdatas.barHeight = 16

local leizypower_MainFrame = CreateFrame("Frame", "leizypower_MainFrame", UIParent)
leizypower_MainFrame:SetWidth(1)
leizypower_MainFrame:SetHeight(1)
leizypower_MainFrame:SetPoint("CENTER", UIParent, powerdatas.x, powerdatas.y)

local power_txtFrame
local power_txtString

local power_BarFrame

local curpower
local maxpower = UnitPowerMax("player")



function init_power()
    -- 初始化能量文字
    local _, ptoken = UnitPowerType("player")
    power_txtFrame = CreateFrame("Frame", "power_txtFrame", leizypower_MainFrame)
    power_txtFrame:SetSize(1, 1)
    power_txtFrame:SetPoint("CENTER", leizypower_MainFrame)
    power_txtString = power_txtFrame:CreateFontString(nil, "ARTWORK")
    power_txtString:SetFont("Fonts\\ARHei.ttf", powerdatas.FontSize, "OUTLINE")
    power_txtString:SetPoint("CENTER", power_txtFrame, 2, 1)
    power_txtString:SetTextColor(powerdatas.powercolor[ptoken][1], powerdatas.powercolor[ptoken][2], powerdatas.powercolor[ptoken][3], 1)
    -- 能量条
    power_BarFrame = CreateFrame("StatusBar", "power_BarFrame", leizypower_MainFrame)
    power_BarFrame:SetSize(powerdatas.barWidth, powerdatas.barHeight)
    power_BarFrame:SetPoint("CENTER", leizypower_MainFrame, 0, -20)
    power_BarFrame:SetStatusBarTexture("Interface\\Addons\\LeizyRune\\textures\\power_bar")
--    power_BarFrame:SetStatusBarTexture("Interface\\Addons\\TidyPlates_Neon\\Neon_Bar")

    power_BarFrame:SetStatusBarColor(powerdatas.powercolor[ptoken][1], powerdatas.powercolor[ptoken][2], powerdatas.powercolor[ptoken][3], 1)
end

function setPowerTxT()
    curpower = UnitPower("player")
    maxpower = UnitPowerMax("player")
    power_txtString:SetText(curpower .. "/" .. maxpower)
end

function setPowerBar()
    power_BarFrame:SetValue(curpower)
    power_BarFrame:SetMinMaxValues(0, maxpower)
end

leizypower_MainFrame:SetScript("OnEvent", function(self, event, ...)
    if event == "PLAYER_LOGIN"
--            or event == "PLAYER_ENTERING_WORLD"
    then
        init_power()
--        maxpower = UnitPowerMax("player")
    elseif event == "PLAYER_REGEN_ENABLED" then
        UIFrameFadeIn(self, 1, 1.0, powerdatas.Alpha)
    elseif event == "PLAYER_REGEN_DISABLED" then
        UIFrameFadeIn(self, 0.5, powerdatas.Alpha, 1.0)
    elseif event == "PET_BATTLE_OPENING_START" then
        UIFrameFadeIn(self, 1, powerdatas.Alpha, 0)
    elseif event == "PET_BATTLE_CLOSE" or event == "PLAYER_ENTERING_WORLD" then
        UIFrameFadeIn(self, 1, 0, powerdatas.Alpha)
    elseif event == "ACTIVE_TALENT_GROUP_CHANGED" then
--        maxpower = UnitPowerMax("player")
--        power_BarFrame:SetMinMaxValues(0,UnitPowerMax("player"))
    end
end)

leizypower_MainFrame:RegisterEvent("PLAYER_LOGIN")
leizypower_MainFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
leizypower_MainFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
leizypower_MainFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
leizypower_MainFrame:RegisterEvent("UNIT_ENTERED_VEHICLE")
leizypower_MainFrame:RegisterEvent("UNIT_EXITED_VEHICLE")
leizypower_MainFrame:RegisterEvent("ACTIVE_TALENT_GROUP_CHANGED")
leizypower_MainFrame:RegisterEvent("PET_BATTLE_OPENING_START")
leizypower_MainFrame:RegisterEvent("PET_BATTLE_CLOSE")

leizypower_MainFrame:SetScript("OnUpdate", function(_,elapsed)
    update = update + elapsed
    if update >= updatetime then
        update = 0
        setPowerTxT()
        setPowerBar()
    end
end)