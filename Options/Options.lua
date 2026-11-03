local addonName, TR = ...

TR.Options = {}

local panel
local soundDropdown
local soundMenuFrame
local settingsCategory
local messageEditBox
local colorDropdown
local colorMenuFrame
local expansionDropdown
local expansionMenuFrame

local function HideAllDropdownMenus(exceptMenu)
    if colorMenuFrame and colorMenuFrame ~= exceptMenu then
        colorMenuFrame:Hide()
    end

    if expansionMenuFrame and expansionMenuFrame ~= exceptMenu then
        expansionMenuFrame:Hide()
    end

    if soundMenuFrame and soundMenuFrame ~= exceptMenu then
        soundMenuFrame:Hide()
    end
end

local function MakeLabel(parent, labelText, x, y)
    local label = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", parent, "TOPLEFT", x, y)
    label:SetText(labelText)
    return label
end

local function MakeSection(parent, titleText, y, separator)
    -- Native WoW-style centered section title, flanked by two fine rules.
    local title = parent:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    title:SetPoint("TOP", parent, "TOPLEFT", 310, y)
    title:SetText(titleText)

    local leftLine = parent:CreateTexture(nil, "ARTWORK")
    leftLine:SetColorTexture(0.55, 0.44, 0.20, 0.65)
    leftLine:SetHeight(1)
    leftLine:SetPoint("LEFT", parent, "TOPLEFT", 24, y - 7)
    leftLine:SetPoint("RIGHT", title, "LEFT", -8, 0)

    local rightLine = parent:CreateTexture(nil, "ARTWORK")
    rightLine:SetColorTexture(0.55, 0.44, 0.20, 0.65)
    rightLine:SetHeight(1)
    rightLine:SetPoint("LEFT", title, "RIGHT", 8, 0)
    rightLine:SetPoint("RIGHT", parent, "TOPLEFT", 596, y - 7)
    return title
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

    slider:SetScript("OnMouseDown", function()
        HideAllDropdownMenus()
    end)

    slider:SetScript("OnValueChanged", function(_, value)
        HideAllDropdownMenus()
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
        HideAllDropdownMenus()
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
    soundMenuFrame:SetWidth(260)
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

local function GetConfiguredMessage()
    local value = TalentReminderDB and TalentReminderDB["message"]

    if not value or value == "" then
        return TR.Defaults.message
    end

    return value
end

function TR.Options:RefreshMessage()
    if not messageEditBox then
        return
    end

    local value = GetConfiguredMessage()

    if messageEditBox:GetText() ~= value then
        messageEditBox:SetText(value)
    end

    messageEditBox:SetTextColor(1, 1, 1, 1)
end


local function RefreshColorDropdownText()
    if colorDropdown and colorDropdown.text then
        local selected = TalentReminderDB.textColorOption or TR.Defaults.textColorOption
        colorDropdown.text:SetText(TR:T("color" .. tostring(selected)))
    end
end

local function SelectColorOption(index)
    TalentReminderDB.textColorOption = index

    if colorMenuFrame then
        colorMenuFrame:Hide()
    end

    RefreshColorDropdownText()
    TR.Reminder:ApplyTextStyle()
end

local function BuildColorMenu()
    if colorMenuFrame then
        colorMenuFrame:Hide()
        colorMenuFrame:SetParent(nil)
    end

    colorMenuFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    colorMenuFrame:SetFrameStrata("TOOLTIP")
    colorMenuFrame:SetPoint("TOPLEFT", colorDropdown, "BOTTOMLEFT", 0, -2)
    colorMenuFrame:SetSize(180, 104)

    colorMenuFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })

    for index = 1, 4 do
        local button = CreateFrame("Button", nil, colorMenuFrame)
        button:SetPoint("TOPLEFT", 4, -4 - ((index - 1) * 24))
        button:SetPoint("TOPRIGHT", -4, -4 - ((index - 1) * 24))
        button:SetHeight(24)

        local text = button:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        text:SetPoint("LEFT", 8, 0)
        text:SetText(TR:T("color" .. tostring(index)))

        button:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight")

        button:SetScript("OnClick", function()
            SelectColorOption(index)
        end)
    end
end

local expansionEntries = TR.Expansions.Entries

local function IsExpansionEntryEnabled(entry)
    return TR.Expansions:IsEnabled(entry)
end

local function SetExpansionEntryEnabled(entry, enabled)
    TR.Expansions:SetEnabled(entry, enabled)
end

local function GetExpansionEntryLabel(entry)
    return TR.Expansions:GetLabel(entry)
end

local function RefreshExpansionDropdownText()
    if not expansionDropdown or not expansionDropdown.text then
        return
    end

    local selected = 0
    for _, entry in ipairs(expansionEntries) do
        if IsExpansionEntryEnabled(entry) then
            selected = selected + 1
        end
    end

    if selected == #expansionEntries then
        expansionDropdown.text:SetText(TR:T("allExpansions"))
    else
        expansionDropdown.text:SetText(string.format(TR:T("selectedExpansions"), selected))
    end
end

local function BuildExpansionMenu()
    if expansionMenuFrame then
        expansionMenuFrame:Hide()
        expansionMenuFrame:SetParent(nil)
    end

    expansionMenuFrame = CreateFrame("Frame", nil, panel, "BackdropTemplate")
    expansionMenuFrame:SetFrameStrata("TOOLTIP")
    expansionMenuFrame:SetPoint("TOPLEFT", expansionDropdown, "BOTTOMLEFT", 0, -2)
    expansionMenuFrame:SetSize(260, 378)
    expansionMenuFrame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 },
    })

    local all = CreateFrame("CheckButton", nil, expansionMenuFrame, "UICheckButtonTemplate")
    all:SetPoint("TOPLEFT", 8, -8)
    local allLabel = all:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    allLabel:SetPoint("LEFT", all, "RIGHT", 4, 0)
    allLabel:SetText(TR:T("allExpansions"))

    local function RefreshAllCheck()
        for _, entry in ipairs(expansionEntries) do
            if not IsExpansionEntryEnabled(entry) then
                all:SetChecked(false)
                return
            end
        end
        all:SetChecked(true)
    end

    all:SetScript("OnClick", function(self)
        local enabled = self:GetChecked() and true or false
        for _, entry in ipairs(expansionEntries) do
            SetExpansionEntryEnabled(entry, enabled)
        end
        BuildExpansionMenu()
        RefreshExpansionDropdownText()
    end)

    for index, entry in ipairs(expansionEntries) do
        local checkbox = CreateFrame("CheckButton", nil, expansionMenuFrame, "UICheckButtonTemplate")
        checkbox:SetPoint("TOPLEFT", 8, -8 - (index * 24))
        checkbox:SetChecked(IsExpansionEntryEnabled(entry))

        local label = checkbox:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("LEFT", checkbox, "RIGHT", 4, 0)
        label:SetText(GetExpansionEntryLabel(entry))

        checkbox:SetScript("OnClick", function(self)
            SetExpansionEntryEnabled(entry, self:GetChecked() and true or false)
            RefreshAllCheck()
            RefreshExpansionDropdownText()
        end)
    end

    RefreshAllCheck()
    expansionMenuFrame:Show()
end

function TR.Options:Open()
    if not settingsCategory then
        return
    end

    Settings.OpenToCategory(settingsCategory:GetID())

    -- Refresh controls after the Settings panel opens.
    C_Timer.After(0, function()
        TR.Options:RefreshMessage()
        RefreshSoundDropdownText()
        RefreshExpansionDropdownText()
    end)
end

function TR.Options:Initialize()
    panel = CreateFrame("Frame")
    panel:SetSize(650, 580)
    panel.name = TR:T("title")

    local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    title:SetPoint("TOPLEFT", 24, -24)
    title:SetText(TR:T("title"))

    local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
    subtitle:SetText(TR:T("subtitle"))

    local authorName = C_AddOns.GetAddOnMetadata("TalentReminder", "Author") or "?"

    local author = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    author:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -24, -24)
    author:SetText(TR:T("createdBy") .. " " .. authorName)

    local version = C_AddOns.GetAddOnMetadata("TalentReminder", "Version") or "?"
    local versionText = panel:CreateFontString(nil, "ARTWORK", "GameFontDisableSmall")
    versionText:SetPoint("TOPRIGHT", author, "BOTTOMRIGHT", 0, -4)
    versionText:SetText(TR:T("version") .. " " .. version)

    -- Keep the addon header fixed. The scroll viewport ends above WoW's
    -- fixed Close button, and the slider lives outside the clipped viewport.
    local scrollFrame = CreateFrame("ScrollFrame", "TalentReminderOptionsScrollFrame", panel)
    scrollFrame:SetPoint("TOPLEFT", panel, "TOPLEFT", 0, -66)
    scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -46, 54)
    scrollFrame:SetClipsChildren(true)
    scrollFrame:EnableMouseWheel(true)

    local scrollChild = CreateFrame("Frame", nil, scrollFrame)
    scrollChild:SetSize(620, 645)
    scrollFrame:SetScrollChild(scrollChild)
    local content = scrollChild

    -- Explicit native WoW slider: unlike UIPanelScrollFrameTemplate, its
    -- visibility and positioning do not depend on inherited template anchors.
    local scrollBar = CreateFrame("Slider", "TalentReminderOptionsScrollBar", panel, "UIPanelScrollBarTemplate")
    scrollBar:ClearAllPoints()
    scrollBar:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -22, -82)
    scrollBar:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -22, 70)
    scrollBar:SetWidth(16)
    scrollBar:SetValueStep(24)
    scrollBar:SetObeyStepOnDrag(false)

    local function UpdateScrollRange()
        local maxScroll = math.max(0, scrollChild:GetHeight() - scrollFrame:GetHeight())
        scrollBar:SetMinMaxValues(0, maxScroll)
        if scrollBar:GetValue() > maxScroll then
            scrollBar:SetValue(maxScroll)
        end
        scrollFrame:SetVerticalScroll(scrollBar:GetValue())
    end

    scrollBar:SetScript("OnValueChanged", function(_, value)
        scrollFrame:SetVerticalScroll(value)
        HideAllDropdownMenus()
    end)
    scrollFrame:SetScript("OnMouseWheel", function(_, delta)
        scrollBar:SetValue(scrollBar:GetValue() - delta * 36)
    end)
    scrollFrame:HookScript("OnSizeChanged", UpdateScrollRange)
    panel:HookScript("OnShow", function()
        UpdateScrollRange()
        scrollBar:SetValue(0)
        scrollFrame:SetVerticalScroll(0)
        scrollBar:Show()
    end)
    UpdateScrollRange()

    MakeSection(content, TR:T("sectionTalentAlert"), -10, false)

    MakeLabel(content, TR:T("messageLabel"), 24, -41)

    messageEditBox = CreateFrame("EditBox", nil, content, "InputBoxTemplate")
    messageEditBox:SetPoint("TOPLEFT", 24, -64)
    messageEditBox:SetSize(360, 32)
    messageEditBox:SetAutoFocus(false)
    messageEditBox:SetMaxLetters(120)

    -- Keep the configured text visible even when the EditBox does not have
    -- keyboard focus. Some WoW InputBoxTemplate states can dim the text.
    messageEditBox:SetFontObject("ChatFontNormal")
    messageEditBox:SetTextColor(1, 1, 1, 1)
    messageEditBox:SetJustifyH("LEFT")

    local initialMessage = TalentReminderDB and TalentReminderDB["message"]
    if not initialMessage or initialMessage == "" then
        initialMessage = TR.Defaults.message
    end
    messageEditBox:SetText(initialMessage)

    -- WoW's InputBoxTemplate can visually hide preloaded text until the field
    -- receives focus. Keep a separate display label on top while unfocused.
    local messageDisplay = content:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    messageDisplay:SetPoint("LEFT", messageEditBox, "LEFT", 8, 0)
    messageDisplay:SetPoint("RIGHT", messageEditBox, "RIGHT", -8, 0)
    messageDisplay:SetJustifyH("LEFT")
    messageDisplay:SetText(initialMessage)

    local function RefreshMessageDisplay()
        local value = TalentReminderDB and TalentReminderDB["message"]
        if not value or value == "" then
            value = TR.Defaults.message
        end

        messageDisplay:SetText(value)

        if messageEditBox:HasFocus() then
            messageDisplay:Hide()
        else
            messageDisplay:Show()
        end
    end

    local function SaveMessage()
        local value = messageEditBox:GetText()
        if value == "" then
            value = TR.Defaults.message
            messageEditBox:SetText(value)
        end
        TalentReminderDB.message = value
        TR.Reminder:ApplyTextStyle()
    end

    messageEditBox:HookScript("OnEditFocusGained", function(self)
        HideAllDropdownMenus()
        self:SetTextColor(1, 1, 1, 1)
        messageDisplay:Hide()
    end)

    messageEditBox:HookScript("OnEditFocusLost", function(self)
        self:SetTextColor(1, 1, 1, 1)
        RefreshMessageDisplay()
    end)

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
            messageDisplay:SetText(value)
            TR.Reminder:ApplyTextStyle()
        end
    end)

    messageEditBox:SetScript("OnEnterPressed", function(self)
        SaveMessage()
        self:ClearFocus()
    end)
    messageEditBox:SetScript("OnEditFocusLost", SaveMessage)

    RefreshMessageDisplay()

    panel:HookScript("OnShow", function()
        TR.Options:RefreshMessage()
        RefreshMessageDisplay()
        RefreshSoundDropdownText()
        RefreshExpansionDropdownText()
    end)

    messageEditBox:HookScript("OnShow", function()
        TR.Options:RefreshMessage()
        RefreshMessageDisplay()
    end)

    MakeLabel(content, TR:T("textColor"), 24, -112)

    colorDropdown = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    colorDropdown:SetPoint("TOPLEFT", 24, -135)
    colorDropdown:SetSize(260, 30)

    colorDropdown.text = colorDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    colorDropdown.text:SetPoint("LEFT", 10, 0)
    colorDropdown.text:SetPoint("RIGHT", -28, 0)
    colorDropdown.text:SetJustifyH("LEFT")

    local colorArrow = colorDropdown:CreateTexture(nil, "OVERLAY")
    colorArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    colorArrow:SetSize(20, 20)
    colorArrow:SetPoint("RIGHT", colorDropdown, "RIGHT", -6, 0)

    colorDropdown:SetScript("OnMouseDown", function()
        colorArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    end)

    colorDropdown:SetScript("OnMouseUp", function()
        colorArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    end)

    colorDropdown:SetScript("OnClick", function()
        local wasOpen = colorMenuFrame and colorMenuFrame:IsShown()
        HideAllDropdownMenus()

        if not wasOpen then
            BuildColorMenu()
            colorMenuFrame:Show()
        end
    end)

    RefreshColorDropdownText()

    MakeSlider(content, TR:T("fontSize"), 12, 72, 1, 340, -112, 220,
        function() return TalentReminderDB.fontSize end,
        function(v) TalentReminderDB.fontSize = v end,
        function(v) return string.format("%d", v) end
    )

    MakeSlider(content, TR:T("duration"), 1, 15, 0.5, 24, -182, 220,
        function() return TalentReminderDB.duration end,
        function(v)
            TalentReminderDB.duration = v
            if TalentReminderDB.fadeTime > v then
                TalentReminderDB.fadeTime = v
            end
        end,
        function(v) return string.format("%.1f s", v) end
    )

    MakeSlider(content, TR:T("fade"), 0, 5, 0.25, 340, -182, 220,
        function() return TalentReminderDB.fadeTime end,
        function(v) TalentReminderDB.fadeTime = math.min(v, TalentReminderDB.duration) end,
        function(v) return string.format("%.2f s", v) end
    )

    MakeLabel(content, TR:T("sound"), 24, -264)

    soundDropdown = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    soundDropdown:SetPoint("TOPLEFT", 24, -287)
    soundDropdown:SetSize(260, 30)

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
        local wasOpen = soundMenuFrame and soundMenuFrame:IsShown()
        HideAllDropdownMenus()

        if not wasOpen then
            BuildSoundMenu()
        end
    end)

    RefreshSoundDropdownText()

    MakeLabel(content, TR:T("expansions"), 340, -264)

    expansionDropdown = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    expansionDropdown:SetPoint("TOPLEFT", 340, -287)
    expansionDropdown:SetSize(260, 30)

    expansionDropdown.text = expansionDropdown:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
    expansionDropdown.text:SetPoint("LEFT", 12, 0)
    expansionDropdown.text:SetPoint("RIGHT", -28, 0)
    expansionDropdown.text:SetJustifyH("LEFT")

    -- Same native WoW dropdown arrow used by Color and Sound.
    local expansionArrow = expansionDropdown:CreateTexture(nil, "OVERLAY")
    expansionArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    expansionArrow:SetSize(20, 20)
    expansionArrow:SetPoint("RIGHT", expansionDropdown, "RIGHT", -6, 0)

    expansionDropdown:SetScript("OnMouseDown", function()
        expansionArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Down")
    end)

    expansionDropdown:SetScript("OnMouseUp", function()
        expansionArrow:SetTexture("Interface\\ChatFrame\\UI-ChatIcon-ScrollDown-Up")
    end)

    expansionDropdown:SetScript("OnClick", function()
        local wasOpen = expansionMenuFrame and expansionMenuFrame:IsShown()
        HideAllDropdownMenus()

        if not wasOpen then
            BuildExpansionMenu()
        end
    end)

    RefreshExpansionDropdownText()


    MakeCheckbox(content, TR:T("readyCheckReminder"), 24, -334,
        function() return TalentReminderDB.remindOnReadyCheck end,
        function(v) TalentReminderDB.remindOnReadyCheck = v end
    )

    MakeSection(content, TR:T("sectionAdditional"), -380, true)
    MakeCheckbox(content, TR:T("showSpecButtons"), 24, -412,
        function() return TalentReminderDB.showSpecButtons end,
        function(v)
            TalentReminderDB.showSpecButtons = v
            if TR.SpecButtons and TR.SpecButtons.Refresh then
                TR.SpecButtons:Refresh()
            end
        end
    )

    MakeCheckbox(content, TR:T("showVaultLootSpecShort"), 24, -444,
        function() return TalentReminderDB.showVaultLootSpec end,
        function(v) TalentReminderDB.showVaultLootSpec = v end
    )

    MakeSection(content, TR:T("sectionPosition"), -495, true)

    local moveButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    moveButton:SetPoint("TOPLEFT", 24, -525)
    moveButton:SetSize(155, 30)
    moveButton:SetText(TR:T("move"))

    moveButton:SetScript("OnClick", function(self)
        HideAllDropdownMenus()
        TR.Reminder:SetMoveMode(not TR.Reminder:IsMoveMode())
        self:SetText(TR.Reminder:IsMoveMode() and TR:T("lock") or TR:T("move"))
    end)

    local testButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    testButton:SetPoint("LEFT", moveButton, "RIGHT", 12, 0)
    testButton:SetSize(155, 30)
    testButton:SetText(TR:T("test"))

    testButton:SetScript("OnClick", function()
        HideAllDropdownMenus()
        if TR.Reminder:IsMoveMode() then
            TR.Reminder:SavePosition()
            TR.Reminder:SetMoveMode(false)
            moveButton:SetText(TR:T("move"))
        end
        SaveMessage()
        TR.Reminder:Show(TalentReminderDB.message, true)
    end)

    local resetButton = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
    resetButton:SetPoint("LEFT", testButton, "RIGHT", 12, 0)
    resetButton:SetSize(155, 30)
    resetButton:SetText(TR:T("center"))

    resetButton:SetScript("OnClick", function()
        HideAllDropdownMenus()
        TalentReminderDB.point = TR.Defaults.point
        TalentReminderDB.relativePoint = TR.Defaults.relativePoint
        TalentReminderDB.posX = TR.Defaults.posX
        TalentReminderDB.posY = TR.Defaults.posY
        TR.Reminder:ApplyPosition()
    end)

    local info = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
    info:SetPoint("TOPLEFT", 24, -563)
    info:SetWidth(560)
    info:SetJustifyH("LEFT")
    info:SetText(TR:T("info"))


    panel:HookScript("OnHide", function()
        HideAllDropdownMenus()
    end)

    settingsCategory = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
    Settings.RegisterAddOnCategory(settingsCategory)
end
