local addonName, TR = ...

TR.InstanceDump = {}

-- Encounter Journal dump
-- Prints dungeon and raid InstanceIDs grouped by expansion.
-- Usage:
--   /tr instances
--   /tr instances all
--   /tr instances dungeons
--   /tr instances raids
--
-- WoW's Encounter Journal filter is changed temporarily while collecting
-- each expansion and restored afterwards.
local EXPANSIONS = {
    { level = 0,  name = "Classic",                   aliases = { "classic", "vanilla" } },
    { level = 1,  name = "The Burning Crusade",       aliases = { "tbc", "bc", "burningcrusade" } },
    { level = 2,  name = "Wrath of the Lich King",    aliases = { "wotlk", "wrath" } },
    { level = 3,  name = "Cataclysm",                 aliases = { "cata", "cataclysm" } },
    { level = 4,  name = "Mists of Pandaria",         aliases = { "mop", "pandaria" } },
    { level = 5,  name = "Warlords of Draenor",       aliases = { "wod", "draenor" } },
    { level = 6,  name = "Legion",                    aliases = { "legion" } },
    { level = 7,  name = "Battle for Azeroth",        aliases = { "bfa", "battleforazeroth" } },
    { level = 8,  name = "Shadowlands",               aliases = { "sl", "shadowlands" } },
    { level = 9,  name = "Dragonflight",              aliases = { "df", "dragonflight" } },
    { level = 10, name = "The War Within",            aliases = { "tww", "warwithin", "thewarwithin" } },
    { level = 11, name = "Midnight",                  aliases = { "midnight", "mn" } },
}

local function NormalizeExpansionArg(value)
    return (value or ""):lower():gsub("[%s%p_]+", "")
end

local function FindExpansionTier(value)
    local normalized = NormalizeExpansionArg(value)
    if normalized == "" then
        return nil
    end

    for tier, expansion in ipairs(EXPANSIONS) do
        if NormalizeExpansionArg(expansion.name) == normalized then
            return tier
        end

        for _, alias in ipairs(expansion.aliases or {}) do
            if NormalizeExpansionArg(alias) == normalized then
                return tier
            end
        end
    end
end

local dumpWindow
local dumpEditBox
local dumpTitle

local function AddLine(lines, text)
    lines[#lines + 1] = text or ""
end

local function CollectJournalInstances(isRaid)
    local results = {}
    local index = 1

    while true do
        local journalID, name, _, _, _, _, _, _, _, _, mapID =
            EJ_GetInstanceByIndex(index, isRaid)

        if not journalID then
            break
        end

        if mapID and mapID > 0 then
            results[#results + 1] = {
                id = mapID,
                name = name or ("Journal " .. tostring(journalID)),
            }
        end

        index = index + 1
    end

    table.sort(results, function(a, b)
        if a.id == b.id then
            return a.name < b.name
        end
        return a.id < b.id
    end)

    return results
end

local function AppendInstanceTable(lines, title, entries)
    AddLine(lines, "-- " .. title)

    if #entries == 0 then
        AddLine(lines, "-- (none)")
        AddLine(lines)
        return
    end

    local seen = {}
    for _, entry in ipairs(entries) do
        if not seen[entry.id] then
            seen[entry.id] = true
            AddLine(lines, string.format("[%d] = true, -- %s", entry.id, entry.name))
        end
    end

    AddLine(lines)
end

local DELVE_EXPANSION_MAPS = {
    ["The War Within"] = true,
    ["Midnight"] = true,
}

local function FindExpansionRootMaps()
    local roots = {}

    if not C_Map or not C_Map.GetMapChildrenInfo then
        return roots
    end

    local cosmicCandidates = { 946, 947 }
    local seen = {}

    local function Walk(mapID)
        if seen[mapID] then return end
        seen[mapID] = true

        local info = C_Map.GetMapInfo and C_Map.GetMapInfo(mapID)
        if info and DELVE_EXPANSION_MAPS[info.name] then
            roots[info.name] = info.mapID
        end

        local children = C_Map.GetMapChildrenInfo(mapID, nil, false)
        if children then
            for _, child in ipairs(children) do
                Walk(child.mapID)
            end
        end
    end

    for _, mapID in ipairs(cosmicCandidates) do
        Walk(mapID)
    end

    return roots
end

local function CollectDelvesForExpansion(rootMapID)
    local results = {}
    local seenPOI = {}
    local seenMap = {}

    if not rootMapID or not C_AreaPoiInfo or not C_AreaPoiInfo.GetDelvesForMap then
        return results
    end

    local maps = { rootMapID }

    if C_Map and C_Map.GetMapChildrenInfo then
        local descendants = C_Map.GetMapChildrenInfo(rootMapID, nil, true)
        if descendants then
            for _, info in ipairs(descendants) do
                maps[#maps + 1] = info.mapID
            end
        end
    end

    for _, uiMapID in ipairs(maps) do
        local poiIDs = C_AreaPoiInfo.GetDelvesForMap(uiMapID)
        if poiIDs then
            for _, poiID in ipairs(poiIDs) do
                if not seenPOI[poiID] then
                    seenPOI[poiID] = true

                    local poiInfo = C_AreaPoiInfo.GetAreaPOIInfo(uiMapID, poiID)
                    if poiInfo then
                        local mapID = poiInfo.uiMapID or uiMapID
                        local key = tostring(mapID) .. ":" .. tostring(poiInfo.name)

                        if not seenMap[key] then
                            seenMap[key] = true
                            results[#results + 1] = {
                                id = mapID,
                                name = poiInfo.name or ("Delve POI " .. tostring(poiID)),
                                poiID = poiID,
                            }
                        end
                    end
                end
            end
        end
    end

    table.sort(results, function(a, b)
        if a.id == b.id then
            return a.name < b.name
        end
        return a.id < b.id
    end)

    return results
end

local function AppendDelves(lines, entries)
    AddLine(lines, "-- Delves")

    if #entries == 0 then
        AddLine(lines, "-- (none found)")
        AddLine(lines)
        return
    end

    for _, entry in ipairs(entries) do
        AddLine(lines, string.format(
            "-- uiMapID %d, POI %d -- %s",
            entry.id,
            entry.poiID,
            entry.name
        ))
    end

    AddLine(lines, "-- NOTE: Delve POI uiMapIDs are not guaranteed to be InstanceIDs.")
    AddLine(lines, "-- Use /tr id while inside a Delve to get the real InstanceID.")
    AddLine(lines)
end

local function BuildDumpText()
    if not EJ_GetInstanceByIndex or not EJ_SelectTier then
        return "Talent Reminder\n\nEncounter Journal API unavailable."
    end

    local lines = {}
    local oldTier = EJ_GetCurrentTier and EJ_GetCurrentTier() or nil
    local maxTier = EJ_GetNumTiers and EJ_GetNumTiers() or #EXPANSIONS
    local delveRoots = FindExpansionRootMaps()

    AddLine(lines, "-- Talent Reminder - InstanceID dump")
    AddLine(lines, "-- Generated from WoW APIs")
    AddLine(lines)

    for tier = 1, math.min(maxTier, #EXPANSIONS) do
        EJ_SelectTier(tier)

        local expansion = EXPANSIONS[tier]
        local expansionName = expansion and expansion.name or ("Expansion " .. tostring(tier - 1))

        AddLine(lines, "-- ==================================================")
        AddLine(lines, "-- " .. expansionName)
        AddLine(lines, "-- ==================================================")
        AddLine(lines)

        AppendInstanceTable(lines, "Dungeons", CollectJournalInstances(false))
        AppendInstanceTable(lines, "Raids", CollectJournalInstances(true))

        if expansionName == "The War Within" or expansionName == "Midnight" then
            AppendDelves(lines, CollectDelvesForExpansion(delveRoots[expansionName]))
        end
    end

    if oldTier then
        EJ_SelectTier(oldTier)
    end

    return table.concat(lines, "\n")
end

local function CreateDumpWindow()
    if dumpWindow then
        return
    end

    dumpWindow = CreateFrame("Frame", "TalentReminderInstanceDumpFrame", UIParent, "BackdropTemplate")
    dumpWindow:SetSize(760, 620)
    dumpWindow:SetPoint("CENTER")
    dumpWindow:SetFrameStrata("DIALOG")
    dumpWindow:SetMovable(true)
    dumpWindow:SetClampedToScreen(true)
    dumpWindow:EnableMouse(true)
    dumpWindow:RegisterForDrag("LeftButton")

    dumpWindow:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 10, right = 10, top = 10, bottom = 10 },
    })

    dumpWindow:SetScript("OnDragStart", dumpWindow.StartMoving)
    dumpWindow:SetScript("OnDragStop", dumpWindow.StopMovingOrSizing)

    dumpTitle = dumpWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    dumpTitle:SetPoint("TOPLEFT", 20, -18)
    dumpTitle:SetText("Talent Reminder - InstanceIDs")

    local help = dumpWindow:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    help:SetPoint("TOPLEFT", dumpTitle, "BOTTOMLEFT", 0, -6)
    help:SetText("Pulsa \"Copiar todo\" y después Ctrl+C")

    local close = CreateFrame("Button", nil, dumpWindow, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    local scroll = CreateFrame("ScrollFrame", nil, dumpWindow, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -62)
    scroll:SetPoint("BOTTOMRIGHT", -38, 50)

    dumpEditBox = CreateFrame("EditBox", nil, scroll)
    dumpEditBox:SetMultiLine(true)
    dumpEditBox:SetAutoFocus(false)
    dumpEditBox:SetFontObject(ChatFontNormal)
    dumpEditBox:SetWidth(680)
    dumpEditBox:SetTextInsets(4, 4, 4, 4)
    dumpEditBox:EnableMouse(true)

    scroll:SetScrollChild(dumpEditBox)

    dumpEditBox:SetScript("OnEscapePressed", function()
        dumpEditBox:ClearFocus()
        dumpWindow:Hide()
    end)

    dumpEditBox:SetScript("OnTextChanged", function(self)
        local height = math.max(1, self:GetStringHeight() + 20)
        self:SetHeight(height)
    end)

    local selectAll = CreateFrame("Button", nil, dumpWindow, "UIPanelButtonTemplate")
    selectAll:SetSize(140, 26)
    selectAll:SetPoint("BOTTOMLEFT", 20, 16)
    selectAll:SetText("Copiar todo")
    selectAll:SetScript("OnClick", function()
        dumpEditBox:SetFocus()
        dumpEditBox:HighlightText()
    end)

    local refresh = CreateFrame("Button", nil, dumpWindow, "UIPanelButtonTemplate")
    refresh:SetSize(120, 26)
    refresh:SetPoint("LEFT", selectAll, "RIGHT", 10, 0)
    refresh:SetText("Actualizar")
    refresh:SetScript("OnClick", function()
        dumpEditBox:SetText(BuildDumpText())
        dumpEditBox:SetCursorPosition(0)
    end)

    dumpWindow:Hide()
end

function TR.InstanceDump:Show()
    CreateDumpWindow()

    dumpEditBox:SetText(BuildDumpText())
    dumpEditBox:SetCursorPosition(0)
    dumpWindow:Show()
    dumpWindow:Raise()
end
