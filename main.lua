---@diagnostic disable: undefined-global, lowercase-global

require("bird")
require("pipes")

-- Sprites for Background
backgroundSprite = love.graphics.newImage("sprites/background-day.png")
baseSprite = love.graphics.newImage("sprites/base.png")

-- Sprites for UI
logo = love.graphics.newImage("sprites/logo.png")
buttonSprite = love.graphics.newImage("sprites/button.png")
tap = love.graphics.newImage("sprites/tap.png")
gameOver = love.graphics.newImage("sprites/gameover.png")
menuBird = love.graphics.newImage("sprites/yellowbird-midflap.png")

local gameState = "menu"

-- Base Animation
local baseScroll = 0
local BASE_SCROLL_SPEED = 90
local BASE_LOOPING_POINT = baseSprite:getWidth() - love.graphics.getWidth()

-- Drawing Menu

function pipeLoad()
    pipes = {}
    for i = 1, 3 do
        local pipeX = love.graphics.getWidth() + (i-1) * 130
        local pipeY = love.math.random(120, love.graphics.getHeight() / 2 + 50)
        local newPipe = Pipe.new(pipeX, pipeY)
        table.insert(pipes, newPipe)
    end
end

function scoreLoad()
    font = love.graphics.newFont("font/pixelfont.ttf", 50)
    score = 0
    pointSound = love.audio.newSource("audio/point.ogg", "static")
    pointSound:setVolume(0.5)
end

function drawMenu()
    --Bird.posX = love.graphics.getWidth() / 2 - Bird.birdSprite:getWidth() / 6
    --Bird.posY = love.graphics.getHeight() / 2 - Bird.birdSprite:getHeight() / 6
    love.graphics.draw(backgroundSprite, 0, 0)
    love.graphics.draw(baseSprite, 0, love.graphics.getHeight() - baseSprite:getHeight())
    love.graphics.draw(logo, love.graphics.getWidth() / 2 - logo:getWidth() / 1.6, logo:getHeight(), 0, 1.3, 1.3)
    love.graphics.draw(menuBird, love.graphics.getWidth() / 2 - 10, love.graphics.getHeight() / 2 - 10)
    love.graphics.draw(tap, love.graphics.getWidth() / 2 - tap:getWidth() / 1.5, love.graphics.getHeight() - tap:getHeight() * 5, 0, 1.5, 1.5)
end

function drawGame()
    love.graphics.draw(backgroundSprite, 0, 0)
        love.graphics.draw(baseSprite, -baseScroll, 400)
        Bird:draw()
        for _, pipe in ipairs(pipes)do
            pipe:draw()
        end

        -- Draw Points
        love.graphics.setFont(font)
        getFont = love.graphics.getFont()
        love.graphics.printf(score, love.graphics.getWidth() / 2 - 55, love.graphics.getHeight() / 8, 110, "center")
        if Bird.isDead == true then
            gameState = "deathMenu"
end

function drawDeathMenu()
    drawGame()
        -- Draw Game Over
            love.graphics.draw(gameOver, love.graphics.getWidth() / 2 - gameOver:getWidth() / 2 - 5 , love.graphics.getHeight() / 2 - gameOver:getHeight() * 3)
            love.graphics.draw(buttonSprite, love.graphics.getWidth() / 2 - buttonSprite:getWidth() * 1.7  / 2, love.graphics.getHeight() / 2 + buttonSprite:getHeight() * 1.7 , 0, 1.7, 1.7)
        end
end

function love.load()
    Bird:load()
    pipeLoad()
    scoreLoad()
end

function love.update(dt)
    -- Base Platform Animation
    if gameState == "playing" then
        if Bird.isDead == false then
            baseScroll = (baseScroll + BASE_SCROLL_SPEED * dt) % BASE_LOOPING_POINT
        end

        Bird:update(dt)
        -- Delete the last pipe and spawn endless pipes.
        for _, pipe in ipairs(pipes) do
            pipe:update(dt)
            pipe:checkCollision(Bird)
            if pipe.posX < Bird.posX and not pipe.passed then
                score = score + 1
                pointSound:play()
                pipe.passed = true
            end
        end

        local lastPipe = pipes[#pipes]
        if lastPipe.posX <= love.graphics.getWidth() - lastPipe.width * 2.7 then
            local pipeX = love.graphics.getWidth()
            local pipeY = love.math.random(120, love.graphics.getHeight() / 2 + 64)
            local newPipe = Pipe.new(pipeX, pipeY)
            table.insert(pipes, newPipe)
        end

        if pipes[1].posX + pipes[1].width < 0 then
            table.remove(pipes, 1)
        end
    end
end


function love.draw()
    if gameState == "menu" then
        drawMenu()
    elseif gameState == "playing" then
        drawGame()
    elseif gameState == "deathMenu" then
        drawDeathMenu()
    end
end

-- Get Mouse Input for Movement
function love.mousepressed(x, y, button)
    if gameState == "menu" then
        if button == 1 then
            gameState = "playing"
        end
    elseif gameState == "playing" then
        if button == 1 and Bird.isDead == false then
            Bird:jump()
            Bird.wingSound:play()
        end
    elseif gameState == "deathMenu" then
        local buttonSpriteWidth = buttonSprite:getWidth() * 1.7
        local buttonSpriteHeight = buttonSprite:getHeight() * 1.7

        if button == 1 and x >= love.graphics.getWidth() / 2 - buttonSpriteWidth / 2 and x <= love.graphics.getWidth() / 2 + buttonSpriteWidth / 2 and y >= love.graphics.getHeight() / 2 + buttonSpriteHeight and y <= love.graphics.getHeight() / 2 + 2 * buttonSpriteHeight then
            Bird.isDead = false
            gameState = "menu"
            Bird:load()
            pipeLoad()
            scoreLoad()
        end
    end
end
