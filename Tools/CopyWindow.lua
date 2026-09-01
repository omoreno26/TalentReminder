local addonName, TR = ...

TR.CopyWindow = {}

local window
local titleText
local editBox
local refreshButton
local refreshCallback

local function Refresh()
    if not refreshCallback then
        return
    end

    local text = refreshCallback()
    editBox:SetText(text or "")
    editBox:SetCursorPosition(0)
end

local function CreateWindow()
    if window then
        return
    end

    window = CreateFrame("Frame", "TalentReminderCopyWindowFrame", UIParent, "BackdropTemplate")
    window:SetSize(760, 620)
    window:SetPoint("CENTER")
    window:SetFrameStrata("DIALOG")
    window:SetMovable(true)
    window:SetClampedToScreen(true)
    window:EnableMouse(true)
    window:RegisterForDrag("LeftButton")

    window:SetBackdrop({
        bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background",
        edgeFile = "Interface\\DialogFrame\\UI-DialogBox-Border",
        tile = true,
        tileSize = 32,
        edgeSize = 32,
        insets = { left = 10, right = 10, top = 10, bottom = 10 },
    })

    window:SetScript("OnDragStart", window.StartMoving)
    window:SetScript("OnDragStop", window.StopMovingOrSizing)

    titleText = window:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    titleText:SetPoint("TOPLEFT", 20, -18)

    local help = window:CreateFontString(nil, "OVERLAY", "GameFontHighlightSmall")
    help:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -6)
    help:SetText("Pulsa \"Copiar todo\" y después Ctrl+C")

    local close = CreateFrame("Button", nil, window, "UIPanelCloseButton")
    close:SetPoint("TOPRIGHT", -4, -4)

    local scroll = CreateFrame("ScrollFrame", nil, window, "UIPanelScrollFrameTemplate")
    scroll:SetPoint("TOPLEFT", 20, -62)
    scroll:SetPoint("BOTTOMRIGHT", -38, 50)

    editBox = CreateFrame("EditBox", nil, scroll)
    editBox:SetMultiLine(true)
    editBox:SetAutoFocus(false)
    editBox:SetFontObject(ChatFontNormal)
    editBox:SetWidth(680)
    editBox:SetTextInsets(4, 4, 4, 4)
    editBox:EnableMouse(true)

    scroll:SetScrollChild(editBox)

    editBox:SetScript("OnEscapePressed", function()
        editBox:ClearFocus()
        window:Hide()
    end)

    editBox:SetScript("OnTextChanged", function(self)
        local height = math.max(1, self:GetStringHeight() + 20)
        self:SetHeight(height)
    end)

    local selectAll = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    selectAll:SetSize(140, 26)
    selectAll:SetPoint("BOTTOMLEFT", 20, 16)
    selectAll:SetText("Copiar todo")
    selectAll:SetScript("OnClick", function()
        editBox:SetFocus()
        editBox:HighlightText()
    end)

    refreshButton = CreateFrame("Button", nil, window, "UIPanelButtonTemplate")
    refreshButton:SetSize(120, 26)
    refreshButton:SetPoint("LEFT", selectAll, "RIGHT", 10, 0)
    refreshButton:SetText("Actualizar")
    refreshButton:SetScript("OnClick", Refresh)

    window:Hide()
end

function TR.CopyWindow:Show(title, text, onRefresh)
    CreateWindow()

    refreshCallback = onRefresh
    titleText:SetText(title or "Talent Reminder")
    editBox:SetText(text or "")
    editBox:SetCursorPosition(0)

    if refreshCallback then
        refreshButton:Show()
    else
        refreshButton:Hide()
    end

    window:Show()
    window:Raise()
end
