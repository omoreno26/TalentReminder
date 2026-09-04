local addonName, TR = ...

local eventFrame = CreateFrame("Frame")

-- Session state used to avoid repeating the World reminder while the player
-- moves between different untracked instanceIDs.
local lastInstanceID
local lastWasWorld

local function CheckCurrentInstance()
    -- 1) World has priority. Ask WoW first, before checking any instanceID.
    if TR.Instances:IsWorld() then
        if TalentReminderDB.remindInWorld and not lastWasWorld then
            TR.Reminder:Show()
        end

        lastInstanceID = nil
        lastWasWorld = true
        return
    end

    -- 2) We are inside an instance. Only now read/check its instanceID.
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    if TR.Instances:IsTracked(instanceID) then
        -- PLAYER_ENTERING_WORLD and ZONE_CHANGED_NEW_AREA can both fire during
        -- the same transition. Only remind when the tracked instance actually
        -- changes, or when we have just come from World.
        if lastWasWorld or lastInstanceID ~= instanceID then
            TR.Reminder:Show()
        end

        lastInstanceID = instanceID
        lastWasWorld = false
        return
    end

    -- 3) Untracked dungeon/raid/scenario/PvP/etc.: do nothing.
    lastInstanceID = instanceID
    lastWasWorld = false
end

local function BuildCurrentInstanceText()
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    return table.concat({
        TR:T("instance") .. ": " .. tostring(instanceName),
        "instanceID: " .. tostring(instanceID),
        "[" .. tostring(instanceID) .. "] = true, -- " .. tostring(instanceName),
    }, "\n")
end

local function ShowCurrentInstance()
    TR.CopyWindow:Show(
        "Talent Reminder - InstanceID",
        BuildCurrentInstanceText(),
        BuildCurrentInstanceText
    )
end

SLASH_TALENTREMINDER1 = "/tr"
SLASH_TALENTREMINDER2 = "/talentreminder"

SlashCmdList["TALENTREMINDER"] = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")

    if msg == "settings" then
        TR.Options:Open()
    elseif msg == "test" then
        TR.Reminder:Show()
    elseif msg == "instances" then
        TR.InstanceDump:Show()
    elseif msg == "move" then
        TR.Reminder:SetMoveMode(not TR.Reminder:IsMoveMode())
        print("|cffffcc00Talent Reminder:|r " ..
            (TR.Reminder:IsMoveMode() and TR:T("moveOn") or TR:T("moveOff")))
    elseif msg == "id" then
        ShowCurrentInstance()
    elseif msg == "stop" then
        TR.Reminder:SetMoveMode(false)
        TR.Reminder:Stop()
    elseif msg == "" then
        return
    end
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
eventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        TalentReminderDB = TalentReminderDB or {}
        TR:CopyDefaults(TR.Defaults, TalentReminderDB)

        TR.Reminder:Initialize()
        TR.Options:Initialize()

        eventFrame:UnregisterEvent("ADDON_LOADED")
        return
    end

    if event == "PLAYER_ENTERING_WORLD" or event == "ZONE_CHANGED_NEW_AREA" then
        C_Timer.After(0.5, CheckCurrentInstance)
    end
end)
