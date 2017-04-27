--
-- Created by IntelliJ IDEA.
-- User: leizy
-- Date: 2017/4/27 0027
-- Time: 上午 11:28
-- To change this template use File | Settings | File Templates.
--

local LeizyRune, ns = ...

local powerdatas = {}
powerdatas.x = 0
powerdatas.y = -125
powerdatas.FontSize = 18
powerdatas.powercolor = {
    ["ENERGY"] = {255/255, 255/255, 225/255},
    ["FOCUS"] = {255/255, 192/255, 0/255},
    ["MANA"] = {1/255, 121/255, 228/255},
    ["RAGE"] = {255/255, 26/255, 48/255},
    ["FURY"] = {255/255, 50/255, 50/255},
    ["MAELSTROM"] = {0/255, 200/255, 255/255},
    ["INSANITY"] = {149/255, 97/255, 219/255},
    ["LUNAR_POWER"] = {134/255, 143/255, 254/255},
    ["RUNIC_POWER"] = {134/255, 239/255, 254/255},
    ["RUNES"] = {0/255, 200/255, 255/255},
    ["FUEL"] = {0, 0.55, 0.5},
    ["AMMOSLOT"] = {1, 0.60, 0},
    ['POWER_TYPE_STEAM'] = {0.55, 0.57, 0.61},
    ['POWER_TYPE_PYRITE'] = {0.60, 0.09, 0.17},
    ['POWER_TYPE_HEAT'] = {0.55, 0.57, 0.61},
    ['POWER_TYPE_OOZE'] = {0.76, 1, 0},
    ['POWER_TYPE_BLOOD_POWER'] = {0.7, 0, 1},
}

local leizypower_MainFrame = CreateFrame("Frame",nil,UIParent)
leizypower_MainFrame:SetWidth(1)
leizypower_MainFrame:SetHeight(1)
leizypower_MainFrame:SetPoint("CENTER",UIParent,powerdatas.x,powerdatas.y)

local power_txtFrame
local power_txtString


local _, ptoken = UnitPowerType("player")

function init_power()
    power_txtFrame = CreateFrame("Frame",nil,leizypower_MainFrame)
    power_txtFrame:SetSize(1,1)
    power_txtFrame:SetPoint("CENTER",leizypower_MainFrame)
    power_txtString = power_txtFrame:CreateFontString(nil,"ARTWORK")
    power_txtString:SetFont("Fonts\\ARHei.ttf",powerdatas.FontSize,"OUTLINE")
    power_txtString:SetPoint("CENTER",power_txtFrame,2,1)
end

function setPowerTxT()
    local curpower = UnitPower("player")
    local maxpower = UnitPowerMax("player")
    power_txtString:SetText(curpower.."/"..maxpower)
    power_txtString:SetTextColor(powerdatas.powercolor[ptoken][1],powerdatas.powercolor[ptoken][2],powerdatas.powercolor[ptoken][3],1)
end

leizypower_MainFrame:SetScript("OnEvent",function(self, event, ...)
    if event == "PLAYER_LOGIN" then
        init_power()

    end
end)

leizypower_MainFrame:RegisterEvent("PLAYER_LOGIN")

leizypower_MainFrame:SetScript("OnUpdate",function() setPowerTxT() end)