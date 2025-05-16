--[[
    For now, this use of class isn't more efficient than directly modifying the world's grid,
     but it supports future extensibility for features like gravity or flammability.

    BUT Lua lacks class introspection, so problems may come up later.
]]

local ParticleType = require("particle_type")

Particle = {}
Particle.__index = Particle

function Particle:new(i, j, type)
    -- i, j is world's grid's coordinates, not screen's,
    local properties = {
        i = i,
        j = j,
        type = type,
    }
    setmetatable(properties, self)
    return properties
end

function Particle:update(world, worldWidth, worldHeight)
    if self.type == ParticleType.SAND then
        self:updateSand(world, worldWidth, worldHeight)
    end
    -- elseif self.type == FUTURE_TYPE
    --     self:update_FUTURE_TYPE()
    -- end
end

function Particle:render(x, y, size)
    if self.type == ParticleType.SAND then
        self:renderSand(x, y, size)
    end
    -- elseif self.type == FUTURE_TYPE
    --     self:render_FUTURE_TYPE()
    -- end
end

function Particle:setType(type)
    self.type = type
end

function Particle:swapTypeWith(other)
    -- swaps types directly to avoid multiple setType() calls
    self.type, other.type = other.type, self.type
end

function Particle:updateSand(grid, worldWidth, worldHeight)
    local i, j = self.i, self.j

    -- we're at the bottom, don't need to do anything
    if j >= worldHeight then
        return
    end

    -- try to fall straight down
    if grid[i][j + 1].type == ParticleType.EMPTY then
        grid[i][j]:swapTypeWith(grid[i][j + 1])

    -- try to fall diagonally
    elseif grid[i][j + 1].type == ParticleType.SAND then
        local canLeft = i > 1 and grid[i - 1][j + 1].type == ParticleType.EMPTY
        local canRight = i < worldWidth and grid[i + 1][j + 1].type == ParticleType.EMPTY

        -- nowhere to move
        if not (canLeft or canRight) then
            return
        end

        grid[i][j]:setType(ParticleType.EMPTY)

        -- choose a direction randomly if both are free
        if canLeft and canRight then
            if love.math.random() < 0.5 then
                grid[i - 1][j + 1]:setType(ParticleType.SAND)
            else
                grid[i + 1][j + 1]:setType(ParticleType.SAND)
            end
        elseif canLeft then
            grid[i - 1][j + 1]:setType(ParticleType.SAND)
        elseif canRight then
            grid[i + 1][j + 1]:setType(ParticleType.SAND)
        end
    end
end

function Particle:renderSand(x, y, size)
    -- x, y is screen's coordinates, not world's grid's
    love.graphics.setColor(ParticleType.SAND_COLOR[1], ParticleType.SAND_COLOR[2], ParticleType.SAND_COLOR[3])
    love.graphics.rectangle("fill", x, y, size, size)
end

return Particle