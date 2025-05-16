local Particle = require("particle")
local ParticleType = require("particle_type")

World = {}
World.__index = World

function World:new(w, h, pSize)
    local properties = {
        width = w,
        height = h,
        particleSize = pSize,
        grid = {},
    }
    setmetatable(properties, self)

    -- Initialize a 2D array grid with EMPTY particles
    for i = 1, w do
        properties.grid[i] = {}
        for j = 1, h do
            properties.grid[i][j] = Particle:new(i, j, ParticleType.EMPTY)
        end
    end

    return properties
end

function World:update()
    for j = self.height, 1, -1 do
        for i = 1, self.width do
            self.grid[i][j]:update(self.grid, self.width, self.height)
        end
    end
end

function World:render()
    love.graphics.setColor(0, 0, 0)

    for i = 1, self.width do
        for j = 1, self.height do
            self.grid[i][j]:render((i - 1) * self.particleSize, (j - 1) * self.particleSize, self.particleSize)
        end
    end
end

function World:createParticle(i, j, pType)
    self.grid[i][j]:setType(pType)
end

return World