require "ISUI/ISPanel"

local MODULE = "MorningCall"
local NOTICE_DURATION_MS = 6000
local PANEL_HEIGHT = 32
local PANEL_MARGIN = 14
local PANEL_TOP = 42

local MorningCallBanner = ISPanel:derive("MorningCallBanner")

function MorningCallBanner:new()
    local banner = ISPanel.new(self, 0, PANEL_TOP, 320, PANEL_HEIGHT)
    setmetatable(banner, self)
    self.__index = self

    banner.background = false
    banner.statusText = nil
    banner.noticeText = nil
    banner.noticeUntil = 0
    banner:instantiate()
    banner.javaObject:setConsumeMouseEvents(false)
    banner.javaObject:setIgnoreLossControl(true)
    banner:setAlwaysOnTop(true)
    banner:setVisible(false)
    return banner
end

function MorningCallBanner:activeText()
    if self.noticeText and getTimestampMs() < self.noticeUntil then
        return self.noticeText
    end
    self.noticeText = nil
    self.noticeUntil = 0
    return self.statusText
end

function MorningCallBanner:refreshVisibility()
    self:setVisible(self:activeText() ~= nil)
end

function MorningCallBanner:setSleepState(total, sleepers)
    if #sleepers == 0 then
        self.statusText = nil
    else
        self.statusText = "Sleeping " .. tostring(#sleepers) .. "/" .. tostring(total)
            .. ": " .. table.concat(sleepers, ", ")
    end
    self:refreshVisibility()
end

function MorningCallBanner:showMorning(time)
    self.noticeText = "Cock-a-doodle-doo! It's " .. tostring(time or "05:30")
        .. " - morning has arrived."
    self.noticeUntil = getTimestampMs() + NOTICE_DURATION_MS
    self:refreshVisibility()
end

function MorningCallBanner:update()
    ISPanel.update(self)
    self:refreshVisibility()
end

function MorningCallBanner:prerender()
    local text = self:activeText()
    if not text then return end

    local textManager = getTextManager()
    local width = textManager:MeasureStringX(UIFont.Small, text) + PANEL_MARGIN * 2
    local screenWidth = getCore():getScreenWidth()
    width = math.min(width, screenWidth - 30)

    self:setWidth(width)
    self:setHeight(PANEL_HEIGHT)
    self:setX(math.floor((screenWidth - width) / 2))
    self:setY(PANEL_TOP)

    self:drawRect(0, 0, width, PANEL_HEIGHT, 0.82, 0.05, 0.05, 0.05)
    self:drawRectBorder(0, 0, width, PANEL_HEIGHT, 0.9, 0.78, 0.66, 0.24)
    self:drawTextCentre(text, width / 2, 8, 1.0, 0.92, 0.65, 1.0, UIFont.Small)
end

local Client = {
    banner = nil,
    total = 0,
    sleepers = {},
}

function Client:ensureBanner()
    if self.banner then return end
    self.banner = MorningCallBanner:new()
    self.banner:addToUIManager()
    self.banner:setSleepState(self.total, self.sleepers)
end

function Client:requestState()
    if not getPlayer() then return end
    sendClientCommand(MODULE, "hello", {})
end

local function onCreatePlayer(playerIndex, player)
    Client:ensureBanner()
    Client:requestState()
end

local function onServerCommand(module, command, args)
    if module ~= MODULE then return end

    Client:ensureBanner()
    if command == "sleepState" then
        Client.total = tonumber(args.total) or 0
        Client.sleepers = {}
        if args.sleepers then
            for _, name in ipairs(args.sleepers) do
                Client.sleepers[#Client.sleepers + 1] = tostring(name)
            end
        end
        Client.banner:setSleepState(Client.total, Client.sleepers)
    elseif command == "morning" then
        local player = getPlayer()
        if player and player.getEmitter then
            player:getEmitter():playSound("MorningCallRooster")
        else
            getSoundManager():playUISound("MorningCallRooster")
        end
        Client.banner:showMorning(args.time)
    end
end

if isClient() then
    Events.OnCreatePlayer.Add(onCreatePlayer)
    Events.OnServerCommand.Add(onServerCommand)
end
