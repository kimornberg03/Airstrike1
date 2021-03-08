function love.load()
    down = {}
    down.y = 100
    x = 0
    y = 0

    backspeed = 100

    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike IV")
    bg = love.graphics.newImage("background.png")
    iWidth, iHeight = bg:getDimensions()
    wWidht, wHeight = love.window.getMode()
end

local color = {0, 0, 1, 1}

function love.update(dt)

    if love.keyboard.isDown("w") then
        down.y = down.y - 5
    end

    if love.keyboard.isDown("s") then
        down.y = down.y + 5
    end
    
    if (x > -(iWidth - wWidht)) then
        x = x - (backspeed * dt)
    else 
        x = 0
    end

end


function love.draw()
    love.graphics.draw(bg, x, y)
    love.graphics.rectangle("fill", 50, down.y, 30, 30 )
end
