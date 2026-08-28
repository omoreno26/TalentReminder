local addonName, TR = ...

TR.ColorPicker = TR.ColorPicker or {}

local rgbColorPicker

local function Clamp255(value)
    value = tonumber(value) or 0
    value = math.floor(value + 0.5)
    if value < 0 then return 0 end
    if value > 255 then return 255 end
    return value
end

local function EnsureTextColor()
    TalentReminderDB.textColor = TalentReminderDB.textColor or {}

    local defaults = TR.Defaults.textColor or { r = 1, g = 1, b = 1 }

    if TalentReminderDB.textColor.r == nil then
        TalentReminderDB.textColor.r = defaults.r
    end
    if TalentReminderDB.textColor.g == nil then
        TalentReminderDB.textColor.g = defaults.g
    end
    if TalentReminderDB.textColor.b == nil then
        TalentReminderDB.textColor.b = defaults.b
    end

    return TalentReminderDB.textColor
end

function TR.ColorPicker:Open(anchorButton, previewTexture)
    if rgbColorPicker then
        rgbColorPicker:Hide()
        rgbColorPicker:SetParent(nil)
        rgbColorPicker = nil
    end

    local current = EnsureTextColor()
    local oldR, oldG, oldB = current.r, current.g, current.b

    local frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
    rgbColorPicker = frame

    frame:SetSize(300, 190)
    frame:SetFrameStrata("DIALOG")
    frame:SetClampedToScreen(true)
    frame:SetPoint("TOPLEFT", anchorButton, "BOTTOMLEFT", 0, -6)
    frame:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 24,
        insets = { left = 8, right = 8, top = 8, bottom = 8 },
    })

    local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    title:SetPoint("TOPLEFT", 18, -16)
    title:SetText(TR:T("textColor"))

    local preview = frame:CreateTexture(nil, "ARTWORK")
    preview:SetSize(70, 26)
    preview:SetPoint("TOPRIGHT", -18, -42)

    local edits = {}

    local function MakeRGBField(labelText, x)
        local label = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
        label:SetPoint("TOPLEFT", x, -55)
        label:SetText(labelText)

        local edit = CreateFrame("EditBox", nil, frame, "InputBoxTemplate")
        edit:SetSize(56, 24)
        edit:SetPoint("TOPLEFT", x, -76)
        edit:SetAutoFocus(false)
        edit:SetNumeric(true)
        edit:SetMaxLetters(3)
        edit:SetJustifyH("CENTER")

        return edit
    end

    edits.r = MakeRGBField("R", 18)
    edits.g = MakeRGBField("G", 88)
    edits.b = MakeRGBField("B", 158)

    edits.r:SetText(tostring(math.floor((current.r or 1) * 255 + 0.5)))
    edits.g:SetText(tostring(math.floor((current.g or 1) * 255 + 0.5)))
    edits.b:SetText(tostring(math.floor((current.b or 1) * 255 + 0.5)))

    local function ReadRGB()
        local r = Clamp255(edits.r:GetText())
        local g = Clamp255(edits.g:GetText())
        local b = Clamp255(edits.b:GetText())
        return r, g, b
    end

    local function RefreshPreview()
        local r, g, b = ReadRGB()
        preview:SetColorTexture(r / 255, g / 255, b / 255, 1)
    end

    local function ApplyRGB()
        local r, g, b = ReadRGB()

        edits.r:SetText(tostring(r))
        edits.g:SetText(tostring(g))
        edits.b:SetText(tostring(b))

        TalentReminderDB.textColor = {
            r = r / 255,
            g = g / 255,
            b = b / 255,
        }

        preview:SetColorTexture(r / 255, g / 255, b / 255, 1)

        if previewTexture then
            previewTexture:SetColorTexture(r / 255, g / 255, b / 255, 1)
        end

        TR.Reminder:ApplyTextStyle()
    end

    for _, edit in pairs(edits) do
        edit:SetScript("OnTextChanged", function(_, userInput)
            if userInput then
                RefreshPreview()
            end
        end)
    end

    RefreshPreview()

    local ok = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    ok:SetSize(100, 26)
    ok:SetPoint("BOTTOMRIGHT", -18, 18)
    ok:SetText(TR:T("accept"))
    ok:SetScript("OnClick", function()
        ApplyRGB()
        frame:Hide()
        rgbColorPicker = nil
    end)

    local cancel = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
    cancel:SetSize(100, 26)
    cancel:SetPoint("RIGHT", ok, "LEFT", -8, 0)
    cancel:SetText(TR:T("cancel"))
    cancel:SetScript("OnClick", function()
        TalentReminderDB.textColor = {
            r = oldR,
            g = oldG,
            b = oldB,
        }

        if previewTexture then
            previewTexture:SetColorTexture(oldR, oldG, oldB, 1)
        end

        TR.Reminder:ApplyTextStyle()
        frame:Hide()
        rgbColorPicker = nil
    end)
end
