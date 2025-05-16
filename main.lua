EMPTY = 0
SAND = 1

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

    world = createWorld()
end

function love.update()
    if love.mouse.isDown(1) then
        local x, y = love.mouse.getPosition()
        local i = math.floor(x / particleSize) + 1
        local j = math.floor(y / particleSize) + 1

        createParticle(SAND, i, j)

        local dx = love.math.random(-3, 3)
        local dy = love.math.random(-3, 3)
        local ni = i + dx
        local nj = j + dy

        if ni >= 1 and ni <= worldWidth and nj >= 1 and nj <= worldHeight then
            createParticle(SAND, ni, nj)
        end
    end
    
    updateWorld()

    local count = 0
    for i = 1, worldWidth do
        for j = 1, worldHeight do
            if world[i][j] ~= EMPTY then
                count = count + 1
            end
        end
    end
    debugStr = "Number of particles: " .. tostring(count)
end

function love.draw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(debugStr, largeFont, 3, 3)

    renderWorld()
end

function createWorld()
    local world = {}

    for i = 1, worldWidth do
        world[i] = {}

        for j = 1, worldHeight do
            world[i][j] = EMPTY
        end
    end

    return world
end

function renderWorld()
    love.graphics.setLineWidth(0.1)

    for i = 1, worldWidth do
        for j = 1, worldHeight do
            if world[i][j] == EMPTY then
                -- love.graphics.setColor(1, 1, 1)
                -- love.graphics.rectangle("line", (i - 1) * particleSize, (j - 1) * particleSize, particleSize, particleSize)
            elseif world[i][j] == SAND then
                love.graphics.setColor(0.761, 0.698, 0.502)
                love.graphics.rectangle("fill", (i - 1) * particleSize, (j - 1) * particleSize, particleSize, particleSize)
            end
        end
    end
end

function createParticle(particleType, i, j)
    world[i][j] = particleType
end

function updateSand(i, j)
    -- fall straight down
    if j + 1 <= worldHeight and world[i][j + 1] == EMPTY then
        world[i][j] = EMPTY
        world[i][j + 1] = SAND

    -- try to fall diagonally
    elseif j + 1 <= worldHeight then
        local canLeft  = i > 1 and world[i - 1][j + 1] == EMPTY
        local canRight = i < worldWidth and world[i + 1][j + 1] == EMPTY

        -- choose a direction randomly if both are free
        if canLeft and canRight then
            if love.math.random() < 0.5 then
                world[i][j] = EMPTY
                world[i - 1][j + 1] = SAND
            else
                world[i][j] = EMPTY
                world[i + 1][j + 1] = SAND
            end
        elseif canLeft then
            world[i][j] = EMPTY
            world[i - 1][j + 1] = SAND
        elseif canRight then
            world[i][j] = EMPTY
            world[i + 1][j + 1] = SAND
        end
    end
end

function updateWorld()
    for j = worldHeight, 1, -1 do
        for i = 1, worldWidth do
            if world[i][j] == SAND then
                updateSand(i, j)
            end
        end
    end
end