local addonName, TR = ...

TR.Options = {}

local panel
local soundDropdown
local soundMenuFrame
local settingsCategory

local function MakeLabel(parent, labelText, x, y)
    local label = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    label:SetText(labelText)
    return label
end

local function MakeSlider(parent, labelText, minValue, maxValue, step, x, y, width, getValue, setValue, formatter)
    MakeLabel(parent, labelText, x, y)

    local slider = CreateFrame("Slider", nil, parent, "OptionsSliderTemplate")
    slider:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y - 24)
    slider:SetWidth(width)
    slider:SetMinMaxValues(minValue, maxValue)
    slider:SetValueStep(step)
    slider:SetObeyStepOnDrag(true)

    if slider.Low then slider.Low:SetText(tostring(minValue)) end
    if slider.High then slider.High:SetText(tostring(maxValue)) end
    if slider.Text then slider.Text:SetText("") end

    local valueText = parent:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    valueText:SetPoint("LEFT", slider, "RIGHT", 14, 0)

    local function RefreshValue(value)
        valueText:SetText(formatter and formatter(value) or tostring(value))
    end

    slider:SetScript("OnValueChanged", function(_, value)
        local rounded = math.floor((value / step) + 0.5) * step
        setValue(rounded)
        RefreshValue(rounded)
        TR.Reminder:ApplyTextStyle()
    end)

    slider:SetValue(getValue())
    RefreshValue(getValue())

    return slider
end

local function MakeCheckbox(parent, labelText, x, y, getValue, setValue)
    local checkbox = CreateFrame("CheckButton", nil, parent, "UICheckButtonTemplate")
    checkbox:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    checkbox:SetChecked(getValue())

    local label = checkbox:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    label:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
    label:SetText(labelText)

    checkbox:SetScript("OnClick", function(self)
        setValue(self:GetChecked() and true or false)
    end)

    return checkbox
end

local function RefreshSoundDropdownText()
    if soundDropdown and soundDropdown.text then
        soundDropdown.text:SetText(TR.Sound:GetSelectedLabel())
    end
end

local function SelectSound(soundType, soundValue)
    TalentReminderDB.soundType = soundType
    TalentReminderDB.soundValue = soundValue

    if soundMenuFrame then
        soundMenuFrame:Hide()
    end

    RefreshSoundDropdownText()
    TR.Sound:Play()
end

local function BuildSoundMenu()
    if soundMenuFrame then
        soundMenuFrame:Hide()
        soundMenuFrame:SetParent(nil)
    end

    soundMenuFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    soundMenuFrame:SetFrameStrata("TOOLTIP")
    soundMenuFrame:SetPoint("TOPLEFT", soundDropdown, "BOTTOMLEFT", 0, -2)
    soundMenuFrame:SetWidth(330)
    soundMenuFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })

    local entries = {
        { label = TR:T("noSound"), type = "NONE", value = "" },
    }

    for _, sound in ipairs(TR.Sound.WoWSounds) do
        table.insert(entries, {
            label = "WoW: " .. sound.name,
            type = "WOW",
            value = sound.key,
        })
    end

    local LSM = TR.Sound:GetLSM()
    if LSM then
        local names = LSM:List("sound") or {}
        table.sort(names, function(a, b)
            return tostring(a):lower() < tostring(b):lower()
        end)

        for _, name in ipairs(names) do
            table.insert(entries, {
                label = "SharedMedia: " .. tostring(name),
                type = "LSM",
                value = name,
            })
        end
    end

    local itemHeight = 22
    local visibleCount = math.min(#entries, 14)
    soundMenuFrame:SetHeight(visibleCount * itemHeight + 12)

    local scrollFrame = CreateFrame("ScrollFrame", nil, soundMenuFrame, "UIPanelScrollFrameTemplate")
    scrollFrame:SetPoint("TOPLEFT", 6, -6)
    scrollFrame:SetPoint("BOTTOMRIGHT", -26, 6)

    local content = CreateFrame("Frame", nil, scrollFrame)
    content:SetWidth(295)
    content:SetHeight(math.max(1, #entries * itemHeight))
    scrollFrame:SetScrollChild(content)

    local previous
    for _, entry in ipairs(entries) do
        local button = CreateFrame("Button", nil, content)
        button:SetHeight(itemHeight)
        button:SetPoint("LEFT", content, "LEFT", 0, 0)
        button:SetPoint("RIGHT", content, "RIGHT", 0, 0)

        if previous then
            button:SetPoint("TOP", previous, "BOTTOM", 0, 0)
        else
            button:SetPoint("TOP", content, "TOP", 0, 0)
        end

        local highlight = button:CreateTexture(nil, "BACKGROUND")
        highlight:SetAllPoints()
        highlight:SetColorTexture(1, 1, 1, 0.08)
        highlight:Hide()

        local txt = button:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
        txt:SetPoint("LEFT", 6, 0)
        txt:SetPoint("RIGHT", -6, 0)
        txt:SetJustifyH("LEFT")
        txt:SetText(entry.label)

        button:SetScript("OnEnter", function() highlight:Show() end)
        button:SetScript("OnLeave", function() highlight:Hide() end)
        button:SetScript("OnClick", function()
            SelectSound(entry.type, entry.value)
        end)

        previous = button
    end

    soundMenuFrame:Show()
end

function TR.Options:RefreshMessage()
    if not messageEditBox then
        return
    end

    local value = TalentReminderDB and TalentReminderDB["message"]
    if not value or value == "" then
        value = TR.Defaults.message
    end

    messageEditBox:SetText(value)
end

function TR.Options:Open()
    if settingsCategory then
        Settings.OpenToCategory(settingsCategory.ID or panel.name)

        -- Settings can show the canvas on the next frame, so refresh again
        -- after opening to guarantee the SavedVariables value is visible.
        C_Timer.After(0, function()
            TR.Options:RefreshMessage()
            RefreshSoundDropdownText()
        end)
    end
end

function TR.Options:Initialize()
    panel = CreateFrame("Frame")
    panel.name = TR:T("title")

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 24, -24)
    title:SetText(TR:T("title"))

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText(TR:T("subtitle"))

    MakeLabel(panel, TR:T("messageLabel"), 24, -98)

    messageEditBox = CreateFrame("EditBox", nil, panel, "InputBoxTemplate")
    messageEditBox:SetPoint("TOPLEFT", 24, -121)
    messageEditBox:SetSize(360, 32)
    messageEditBox:SetAutoFocus(false)
    messageEditBox:SetMaxLetters(120)
    TR.Options:RefreshMessage()

    local function SaveMessage()
        local value = messageEditBox:GetText()
        if value == "" then
            value = TR.Defaults.message
            messageEditBox:SetText(value)
        end
        TalentReminderDB.message = value
        TR.Reminder:ApplyTextStyle()
    end

    messageEditBox:SetScript("OnTextChanged", function(self, userInput)
        if not userInput then
            return
        end

        local value = self:GetText()

        -- Save continuously while the user types so /reload cannot lose
        -- the current configured message. If the field is temporarily empty
        -- while editing, keep the previous saved value until focus is lost.
        if value ~= "" then
            TalentReminderDB.message = value
            TR.Reminder:ApplyTextStyle()
        end
    end)

    messageEditBox:SetScript("OnEnterPressed", function(self)
        SaveMessage()
        self:ClearFocus()
    end)
    messageEditBox:SetScript("OnEditFocusLost", SaveMessage)

    panel:SetScript("OnShow", function()
        TR.Options:RefreshMessage()
        RefreshSoundDropdownText()
    end)

    MakeSlider(panel, TR:T("fontSize"), 12, 72, 1, 24, -176, 300,
        function() return TalentReminderDB.fontSize end,
        function(v) TalentReminderDB.fontSize = v end,
        function(v) return string.format("%d", v) end
    )

    MakeSlider(panel, TR:T("duration"), 1, 15, 0.5, 24, -251, 300,
        function() return TalentReminderDB.duration end,
        function(v)
            TalentReminderDB.duration = v
            if TalentReminderDB.fadeTime > v then
                TalentReminderDB.fadeTime = v
            end
        end,
        function(v) return string.format("%.1f s", v) end
    )

    MakeSlider(panel, TR:T("fade"), 0, 5, 0.25, 24, -326, 300,
        function() return TalentReminderDB.fadeTime end,
        function(v) TalentReminderDB.fadeTime = math.min(v, TalentReminderDB.duration) end,
        function(v) return string.format("%.2f s", v) end
    )

    MakeCheckbox(panel, TR:T("world"), 20, -398,
        function() return TalentReminderDB.remindInWorld end,
        function(v) TalentReminderDB.remindInWorld = v end
    )

    MakeLabel(panel, TR:T("sound"), 24, -441)

    soundDropdown = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    soundDropdown:SetPoint("TOPLEFT", 24, -464)
    soundDropdown:SetSize(330, 30)

    soundDropdown.text = soundDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    soundDropdown.text:SetPoint("LEFT", 12, 0)
    soundDropdown.text:SetPoint("RIGHT", -28, 0)
    soundDropdown.text:SetJustifyH("LEFT")

    -- Dropdown arrow: use WoW's texture instead of a font glyph.
    -- The old "▼" character could be invisible with some client fonts.
    local arrow = soundDropdown:CreateTexture(nil, "OVERLAY")
    arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    arrow:SetSize(20, 20)
    arrow:SetPoint("RIGHT", soundDropdown, "RIGHT", -6, 0)

    soundDropdown:SetScript("OnMouseDown", function()
        arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    end)

    soundDropdown:SetScript("OnMouseUp", function()
        arrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    end)

    soundDropdown:SetScript("OnClick", function()
        if soundMenuFrame and soundMenuFrame:IsShown() then
            soundMenuFrame:Hide()
        else
            BuildSoundMenu()
        end
    end)

    RefreshSoundDropdownText()

    local lsmStatus = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    lsmStatus:SetPoint("TOPLEFT", soundDropdown, "BOTTOMLEFT", 0, -6)
    lsmStatus:SetText(TR.Sound:GetLSM() and TR:T("lsmFound") or TR:T("lsmMissing"))

    local moveButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    moveButton:SetPoint("TOPLEFT", 24, -541)
    moveButton:SetSize(155, 30)
    moveButton:SetText(TR:T("move"))

    moveButton:SetScript("OnClick", function(self)
        TR.Reminder:SetMoveMode(not TR.Reminder:IsMoveMode())
        self:SetText(TR.Reminder:IsMoveMode() and TR:T("lock") or TR:T("move"))
    end)

    local testButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    testButton:SetPoint("LEFT", moveButton, "RIGHT", 12, 0)
    testButton:SetSize(155, 30)
    testButton:SetText(TR:T("test"))

    testButton:SetScript("OnClick", function()
        if TR.Reminder:IsMoveMode() then
            TR.Reminder:SavePosition()
            TR.Reminder:SetMoveMode(false)
            moveButton:SetText(TR:T("move"))
        end
        SaveMessage()
        TR.Reminder:Show()
    end)

    local resetButton = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    resetButton:SetPoint("LEFT", testButton, "RIGHT", 12, 0)
    resetButton:SetSize(155, 30)
    resetButton:SetText(TR:T("center"))

    resetButton:SetScript("OnClick", function()
        TalentReminderDB.point = TR.Defaults.point
        TalentReminderDB.relativePoint = TR.Defaults.relativePoint
        TalentReminderDB.posX = TR.Defaults.posX
        TalentReminderDB.posY = TR.Defaults.posY
        TR.Reminder:ApplyPosition()
    end)

    local info = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    info:SetPoint("TOPLEFT", 24, -596)
    info:SetWidth(560)
    info:SetJustifyH("LEFT")
    info:SetText(TR:T("info"))

    settingsCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    settingsCategory.ID = panel.name
    Settings.RegisterAddOnCategory(settingsCategory)
end
