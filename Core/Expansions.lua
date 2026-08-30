local addonName, TR = ...

TR.Expansions = {}

-- Central definition for the selectable location/expansion groups.
-- Options.lua only renders these entries; instance membership stays in Instances.lua.
TR.Expansions.Entries = {
    { key = "WORLD", labelKey = "worldMenu" },
    { key = "CLASSIC", label = "Classic" },
    { key = "TBC", label = "The Burning Crusade" },
    { key = "WOTLK", label = "Wrath of the Lich King" },
    { key = "CATACLYSM", label = "Cataclysm" },
    { key = "MOP", label = "Mists of Pandaria" },
    { key = "WOD", label = "Warlords of Draenor" },
    { key = "LEGION", label = "Legion" },
    { key = "BFA", label = "Battle for Azeroth" },
    { key = "SHADOWLANDS", label = "Shadowlands" },
    { key = "DRAGONFLIGHT", label = "Dragonflight" },
    { key = "TWW", label = "The War Within" },
    { key = "MIDNIGHT", label = "Midnight" },
    { key = "CURRENT_SEASON", labelKey = "currentSeason" },
}

function TR.Expansions:IsEnabled(entry)
    if entry.key == "WORLD" then
        return TalentReminderDB.remindInWorld == true
    end

    return TalentReminderDB.expansions[entry.key] ~= false
end

function TR.Expansions:SetEnabled(entry, enabled)
    if entry.key == "WORLD" then
        TalentReminderDB.remindInWorld = enabled
    else
        TalentReminderDB.expansions[entry.key] = enabled
    end
end

function TR.Expansions:GetLabel(entry)
    if entry.labelKey then
        return TR:T(entry.labelKey)
    end

    return entry.label
end
