---@diagnostic disable: undefined-global
function love.conf(t)
    t.title = "Flappy Bird"
    t.window.vsync = 0
    t.window.width = 288
    t.window.height = 512
    t.console = false
    t.window.resizable = false
end
