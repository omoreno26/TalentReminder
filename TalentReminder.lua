local addonName, TR = ...

local eventFrame = CreateFrame("Frame")

-- Session state used to avoid repeating the World reminder while the player
-- moves between different untracked instanceIDs.
local lastInstanceID
local lastWasWorld

local function CheckCurrentInstance()
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    local isTracked = TR.Instances:IsTracked(instanceID)
    local isWorld = not isTracked

    if isTracked then
        -- Configured instances always show the reminder when entered.
        TR.Reminder:Show()

        lastInstanceID = instanceID
        lastWasWorld = false
        return
    end

    if isWorld then
        -- "World" means any instanceID not present in the tracked list.
        -- Only show the reminder when ENTERING World from a configured
        -- instance (or on the first world detection of this session).
        -- Moving World -> World does not repeat the reminder.
        if TalentReminderDB.remindInWorld and not lastWasWorld then
            TR.Reminder:Show()
        end

        lastInstanceID = instanceID
        lastWasWorld = true
    end
end

local function PrintCurrentInstance()
    local instanceName, instanceType, difficultyID, difficultyName,
          maxPlayers, dynamicDifficulty, isDynamic, instanceID = GetInstanceInfo()

    print("|cffffcc00Talent Reminder|r")
    print(TR:T("instance") .. ": " .. tostring(instanceName))
    print("instanceID: " .. tostring(instanceID))
    print("difficultyID: " .. tostring(difficultyID))
end

SLASH_TALENTREMINDER1 = "/tr"
SLASH_TALENTREMINDER2 = "/talentreminder"

SlashCmdList["TALENTREMINDER"] = function(msg)
    msg = (msg or ""):lower():match("^%s*(.-)%s*$")

    if msg == "test" then
        TR.Reminder:Show()
    elseif msg == "instances" then
        TR.InstanceDump:Show()
    elseif msg == "move" then
        TR.Reminder:SetMoveMode(not TR.Reminder:IsMoveMode())
        print("|cffffcc00Talent Reminder:|r " ..
            (TR.Reminder:IsMoveMode() and TR:T("moveOn") or TR:T("moveOff")))
    elseif msg == "id" then
        PrintCurrentInstance()
    elseif msg == "stop" then
        TR.Reminder:SetMoveMode(false)
        TR.Reminder:Stop()
    else
        TR.Options:Open()
    end
end

eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

eventFrame:SetScript("OnEvent", function(_, event, arg1)
    if event == "ADDON_LOADED" and arg1 == addonName then
        TalentReminderDB = TalentReminderDB or {}
        TR:CopyDefaults(TR.Defaults, TalentReminderDB)

        TR.Reminder:Initialize()
        TR.Options:Initialize()

        eventFrame:UnregisterEvent("ADDON_LOADED")
        return
    end

    if event == "PLAYER_ENTERING_WORLD" then
        C_Timer.After(0.5, CheckCurrentInstance)
    end
end)
