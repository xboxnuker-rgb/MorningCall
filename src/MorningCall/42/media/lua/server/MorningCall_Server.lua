local MODULE = "MorningCall"
local MORNING_TIME = 5.5 -- 05:30
local POLL_INTERVAL_MS = 1000

local nextPollAt = 0
local nextMorningWorldHour = nil
local lastStateSignature = nil

local function isEligiblePlayer(player)
    return player
        and not player:isDead()
        and not player:isGhostMode()
end

local function playerName(player)
    local name = player:getDisplayName()
    if not name or name == "" then
        name = player:getUsername()
    end
    if not name or name == "" then
        name = "Player"
    end
    return tostring(name)
end

local function buildSleepState()
    local players = getOnlinePlayers()
    local total = 0
    local sleepers = {}
    local signatureParts = {}

    for index = 0, players:size() - 1 do
        local player = players:get(index)
        if isEligiblePlayer(player) then
            total = total + 1
            local asleep = player:isAsleep()
            local name = playerName(player)
            signatureParts[#signatureParts + 1] =
                tostring(player:getOnlineID()) .. ":" .. name .. ":" .. (asleep and "1" or "0")
            if asleep then
                sleepers[#sleepers + 1] = name
            end
        end
    end

    table.sort(signatureParts)
    table.sort(sleepers, function(left, right)
        return string.lower(left) < string.lower(right)
    end)

    return {
        total = total,
        sleepers = sleepers,
    }, table.concat(signatureParts, "|")
end

local function sendSleepState(targetPlayer, force)
    local state, signature = buildSleepState()

    if targetPlayer then
        sendServerCommand(targetPlayer, MODULE, "sleepState", state)
        return
    end

    if force or signature ~= lastStateSignature then
        lastStateSignature = signature
        sendServerCommand(MODULE, "sleepState", state)
    end
end

local function scheduleNextMorning()
    local gameTime = getGameTime()
    local nowWorldHour = gameTime:getWorldAgeHours()
    local timeOfDay = gameTime:getTimeOfDay()
    local hoursUntilMorning = MORNING_TIME - timeOfDay

    -- Loading at or after 05:30 schedules tomorrow instead of replaying today.
    if hoursUntilMorning <= 0 then
        hoursUntilMorning = hoursUntilMorning + 24
    end

    nextMorningWorldHour = nowWorldHour + hoursUntilMorning
end

local function wakeSleepingPlayers()
    local players = getOnlinePlayers()
    for index = 0, players:size() - 1 do
        local player = players:get(index)
        if isEligiblePlayer(player) and player:isAsleep() then
            -- Mirror the state changes handled by vanilla's WAKE_UP object change
            -- on the server, then notify the remote client so its sleep UI fades in.
            player:setAsleep(false)
            player:setForceWakeUpTime(-1)
            player:sendObjectChange(IsoObjectChange.WAKE_UP)
        end
    end
end

local function announceMorning()
    wakeSleepingPlayers()
    sendServerCommand(MODULE, "morning", { time = "05:30" })
    sendSleepState(nil, true)
    print("[MorningCall] 05:30 reached; morning alert sent and sleepers awakened")
end

local function checkMorning()
    if not nextMorningWorldHour then
        scheduleNextMorning()
        return
    end

    local nowWorldHour = getGameTime():getWorldAgeHours()
    if nowWorldHour + 0.0001 < nextMorningWorldHour then
        return
    end

    announceMorning()
    repeat
        nextMorningWorldHour = nextMorningWorldHour + 24
    until nextMorningWorldHour > nowWorldHour
end

local function update()
    local now = getTimestampMs()
    if now < nextPollAt then return end
    nextPollAt = now + POLL_INTERVAL_MS

    checkMorning()
    sendSleepState(nil, false)
end

local function onGameTimeLoaded()
    nextPollAt = 0
    lastStateSignature = nil
    scheduleNextMorning()
    print("[MorningCall] server ready; next wake-up scheduled for 05:30")
end

local function onClientCommand(module, command, player, args)
    if module ~= MODULE then return end
    if command == "hello" then
        sendSleepState(player, true)
    end
end

if isServer() then
    Events.OnGameTimeLoaded.Add(onGameTimeLoaded)
    Events.OnClientCommand.Add(onClientCommand)
    Events.OnTick.Add(update)
end
