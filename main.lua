local ParticleType = require("particle_type")
local World = require("world")

particleSize = 5

windowWidth = 1200
windowHeight = 600
worldWidth = math.floor(windowWidth / particleSize)
worldHeight = math.floor(windowHeight / particleSize)

debugStr = ""

largeFont = love.graphics.newFont(20)

function love.load()
    love.math.random(os.time())

    love.window.setMode(windowWidth, windowHeight)

    world = World:new(worldWidth, worldHeight, particleSize)
end

function love.update()
    if love.mouse.isDown(1) then
        -- randomize spawn location
        local x, y = love.mouse.getPosition()
        local i = math.floor(x / particleSize) + 1
        local j = math.floor(y / particleSize) + 1
        local spawnRadius = 2
        i = i + love.math.random(-spawnRadius, spawnRadius)
        j = j + love.math.random(-spawnRadius, spawnRadius)

        if i >= 1 and i <= world.width and j >= 1 and j <= world.height then
            world:createParticle(i, j, ParticleType.SAND)
        end
    end
    
    world:update()

    -- for later use
    debugStr = ""
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("FPS: " .. love.timer.getFPS() .. "\n" .. debugStr, largeFont, 3, 3)

    world:render()
end