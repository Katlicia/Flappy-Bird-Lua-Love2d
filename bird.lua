Bird = {}

function Bird:load()
    --self.birdSprite = love.graphics.newImage("sprites/yellowbird-midflap.png")
    self.birdSprite = love.graphics.newImage("sprites/spritesheet.png")
    self.birdWidth = self.birdSprite:getWidth()
    self.posX = love.graphics.getWidth() / 2 - self.birdSprite:getWidth() / 6
    self.posY = love.graphics.getHeight() / 2 - self.birdSprite:getHeight() / 6
    self.gravity = 0
    self.velocity = 200
    self.gravityVelocity = 650
    self.isDead = false
    self.animation = self:newAnimation(self.birdSprite, 34, 24, 1)
    self.deathSound = love.audio.newSource("audio/hit.ogg", "static")
    self.deathSoundPlayed = false
    self.deathSound:setVolume(0.3)
    self.wingSound = love.audio.newSource("audio/wing.ogg", "static")
    self.wingSound:setVolume(0.5)
end

function Bird:update(dt)
    if self.isDead == false then
        self.animation.currentTime = self.animation.currentTime + dt
        if self.animation.currentTime >= self.animation.duration then
            self.animation.currentTime = self.animation.currentTime - self.animation.duration    
        end
        self.gravity = self.gravity + self.gravityVelocity * dt
        self.posY = self.posY + self.gravity * dt
    end
    if self.posY < 0 then
        self.posY = 0
    end
    self:checkCollison()
   
end

function Bird:draw()
    local spriteNum = math.floor(self.animation.currentTime / self.animation.duration * #self.animation.quads) + 1
    love.graphics.draw(self.animation.spriteSheet, self.animation.quads[spriteNum], self.posX, self.posY, 0, 1)
end

function Bird:jump()
    if self.isDead == false then
        if self.posY > 0 then
            self.gravity = -self.velocity
        end
    end
end

function Bird:checkCollison()
    if self.posY >= 376 then
        self.posY = 376
        self.isDead = true
        if self.deathSoundPlayed == false then
            self.deathSound:play()
            self.deathSoundPlayed = true 
        end
    end
end

function Bird:newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    animation.duration = duration or 1
    animation.currentTime = 0

    return animation
end