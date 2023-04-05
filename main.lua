local badApple = RegisterMod("Bad Apple", 1)
local frames = require("frameTable")
local d6 = Isaac.GetItemIdByName("The D6")

-- variables
local currentFrame = 1
local badAppleHasStarted = false
local elapsedTime = 0 -- used later to control the time each frame is shown

-- Spawn hearts function
local function spawnHearts(frame)
    if #frames >= currentFrame then
         for y = 1, #frame do -- rows
            for x = 1, #frame[y] do -- columns
                local heartType = HeartSubType.HEART_BLACK -- heart type that will be shown. black by default
                if frame[y][x] == 1 then
                    heartType = HeartSubType.HEART_ETERNAL
                end
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_HEART, heartType, Vector((x-1)*30 + 110, (y-1)*20 + 150), Vector(0, 0), nil) -- spawn the heart
            end
        end
    end
end

-- Remove hearts function
local function removeHearts()
    for _, entity in ipairs(Isaac.GetRoomEntities()) do
        if entity.Type == EntityType.ENTITY_PICKUP then -- Loops through all pickups and removes them
            entity:Remove()
        end
    end
end

-- Play function
function badApple:Play(_)
    if badAppleHasStarted then
        if elapsedTime == 0 then
            removeHearts()
            spawnHearts(frames[currentFrame])
            currentFrame = currentFrame + 1
        end
        elapsedTime = elapsedTime + 1
        if elapsedTime >= 2 then
            elapsedTime = 0
        end
    end
end

-- Use D6 to start the script and change rooms or reset the run to end it
function badApple:Start()
    badAppleHasStarted = true
end

function badApple:End()
     badAppleHasStarted = false
    currentFrame = 1
end

-- Callbacks
badApple:AddCallback(ModCallbacks.MC_USE_ITEM, badApple.Start, d6)
badApple:AddCallback(ModCallbacks.MC_POST_RENDER, badApple.Play)
badApple:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, badApple.End)

