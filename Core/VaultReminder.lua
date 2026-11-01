local addonName, TR = ...

-- Add player-cast SpellIDs here to test the loot-spec reminder anywhere.
local VAULT_OPENING_SPELL_IDS = {
    [449976] = true,  -- Great Vault
    [1271478] = true, -- Great Vault (Silvermoon)
    [8936] = false, -- resto druid Regrowth for testing
}

local function GetLootSpecText()
    local specID = GetLootSpecialization()
    local specName, specIcon

    if specID == 0 then
        local activeSpecIndex = GetSpecialization()
        if not activeSpecIndex then
            return nil
        end
        _, specName, _, specIcon = GetSpecializationInfo(activeSpecIndex)
    else
        _, specName, _, specIcon = GetSpecializationInfoByID(specID)
    end

    if not specName or not specIcon then
        return nil
    end

    local _, class = UnitClass("player")
    local classColor = (RAID_CLASS_COLORS[class] and RAID_CLASS_COLORS[class].colorStr) or "FFFFFFFF"
    return "|c" .. classColor .. format("|T%d:0|t %s", specIcon, specName) .. "|r"
end

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("UNIT_SPELLCAST_START")
eventFrame:SetScript("OnEvent", function(_, event, unit, castGUID, spellID)
    if unit ~= "player" or not VAULT_OPENING_SPELL_IDS[spellID] then
        return
    end

    local message = GetLootSpecText()
    if message then
        TR.Reminder:Show(message, false)
    end
end)
