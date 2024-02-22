Pipe = {
    sprite = love.graphics.newImage("sprites/pipe-green.png"),
    gap = 80,
    velocity = 80,
}

function Pipe.new(x, y)
    local self = setmetatable({}, {__index = Pipe})
    self.posX = x
    self.posY = y
    self.sprite = love.graphics.newImage("sprites/pipe-green.png")
    self.gap = 80
    self.velocity = 80
    self.width = self.sprite:getWidth()
    self.height = self.sprite:getHeight()
    self.passed = false
    return self
end

function Pipe:update(dt)
    if Bird.isDead == false then
        self.posX = self.posX - self.velocity * dt 
    end
end

function Pipe:draw()
    love.graphics.draw(self.sprite, self.posX, self.posY, 0, 1, -1)
    love.graphics.draw(self.sprite, self.posX, self.posY + self.gap)
end

function Pipe:checkCollision(bird) -- 34 Is Bird Width | 24 Is Bird Height
    if self.posX + self.width > bird.posX and self.posX < bird.posX + 34 then
        if bird.posY < self.posY or bird.posY + 24 > self.posY + self.gap then
            bird.isDead = true
            if bird.deathSoundPlayed == false then
                bird.deathSound:play()
                bird.deathSoundPlayed = true
            end
        end
    end
end

