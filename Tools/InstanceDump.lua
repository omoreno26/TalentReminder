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

local function PrintLine(line)
    DEFAULT_CHAT_FRAME:AddMessage(line)
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

local function PrintInstanceTable(title, entries)
    PrintLine("-- " .. title)

    if #entries == 0 then
        PrintLine("-- (none)")
        return
    end

    local seen = {}
    for _, entry in ipairs(entries) do
        if not seen[entry.id] then
            seen[entry.id] = true
            PrintLine(string.format("[%d] = true, -- %s", entry.id, entry.name))
        end
    end
end


local DELVE_EXPANSION_MAPS = {
    -- Expansion root/continent UiMapIDs are discovered by name where possible.
    -- These labels are intentionally English API-independent fallbacks.
    ["The War Within"] = true,
    ["Midnight"] = true,
}

local function FindExpansionRootMaps()
    local roots = {}

    -- Traverse the cosmic map and collect maps whose localized names match
    -- the expansions we care about. Delve POIs are then queried from every
    -- descendant map.
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
                        -- The POI's uiMapID identifies the entrance/world map.
                        -- It is useful for discovery, but it is NOT guaranteed
                        -- to equal GetInstanceInfo()'s instanceID.
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

local function PrintDelveTable(entries)
    PrintLine("-- Delves")
    if #entries == 0 then
        PrintLine("-- (none found)")
        return
    end

    for _, entry in ipairs(entries) do
        PrintLine(string.format(
            "-- uiMapID %d, POI %d -- %s",
            entry.id,
            entry.poiID,
            entry.name
        ))
    end

    PrintLine("-- NOTE: Delve POI uiMapIDs are not guaranteed to be InstanceIDs.")
    PrintLine("-- Use /tr id while inside a Delve to obtain its real GetInstanceInfo() InstanceID.")
end

function TR.InstanceDump:Print(mode, expansionArg)
    mode = (mode or "all"):lower()

    -- A single expansion name/alias can also be passed as the first argument.
    local requestedTier = FindExpansionTier(expansionArg)
    if not requestedTier then
        local tierFromMode = FindExpansionTier(mode)
        if tierFromMode then
            requestedTier = tierFromMode
            mode = "all"
        end
    end

    local showDungeons = mode == "all" or mode == "" or mode == "dungeons" or mode == "dungeon"
    local showRaids = mode == "all" or mode == "" or mode == "raids" or mode == "raid"
    local showDelves = mode == "all" or mode == "" or mode == "delves" or mode == "delve"

    if expansionArg and not requestedTier then
        PrintLine("|cffffcc00Talent Reminder:|r unknown expansion: " .. tostring(expansionArg))
        PrintLine("/tr instances [expansion] [all|dungeons|raids|delves]")
        return
    end

    if not showDungeons and not showRaids and not showDelves then
        PrintLine("|cffffcc00Talent Reminder:|r /tr instances [expansion] [all|dungeons|raids|delves]")
        return
    end

    if not EJ_GetInstanceByIndex or not EJ_SelectTier then
        PrintLine("|cffff2020Talent Reminder:|r Encounter Journal API unavailable.")
        return
    end

    local oldTier = EJ_GetCurrentTier and EJ_GetCurrentTier() or nil
    local maxTier = EJ_GetNumTiers and EJ_GetNumTiers() or #EXPANSIONS

    PrintLine("|cffffcc00Talent Reminder - InstanceID dump|r")
    PrintLine("-- Generated from WoW APIs")

    local delveRoots = showDelves and FindExpansionRootMaps() or {}

    local firstTier = requestedTier or 1
    local lastTier = requestedTier or maxTier

    for tier = firstTier, math.min(lastTier, maxTier) do
        EJ_SelectTier(tier)

        local expansion = EXPANSIONS[tier]
        local expansionName = expansion and expansion.name or ("Expansion " .. tostring(tier - 1))

        PrintLine(" ")
        PrintLine("-- ==================================================")
        PrintLine("-- " .. expansionName)
        PrintLine("-- ==================================================")

        if showDungeons then
            PrintInstanceTable("-- Dungeons", CollectJournalInstances(false))
        end

        if showRaids then
            PrintInstanceTable("-- Raids", CollectJournalInstances(true))
        end

        if showDelves and (expansionName == "The War Within" or expansionName == "Midnight") then
            PrintDelveTable(CollectDelvesForExpansion(delveRoots[expansionName]))
        end
    end

    if oldTier then
        EJ_SelectTier(oldTier)
    end

    PrintLine(" ")
    PrintLine("|cff00ff00Talent Reminder:|r InstanceID dump finished.")
end
