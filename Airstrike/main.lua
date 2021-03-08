function love.load()
    
    airplane = {}
    airplane.x = 10
    airplane.y = 150
    airplane.pic = love.graphics.newImage("Airplane.png")
    airplane.width, airplane.Height = airplane.pic:getDimensions()

    back = {}
    back.x = 0
    back.y = 0
    back.pic = love.graphics.newImage("background.png")
    back.Width, back.Height = back.pic:getDimensions()


    x = 0
    y = 0

    backspeed = 100

    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    --bg = love.graphics.newImage("background.png")
  --  iWidth, iHeight = bg:getDimensions()
    wWidht, wHeight = love.window.getMode()

    

end

local color = {0, 0, 1, 1}

function love.update(dt)

    if love.keyboard.isDown("w") then
        airplane.y = airplane.y - 5
    end

    if love.keyboard.isDown("s") then
        airplane.y = airplane.y + 5
    end
    
    if (back.x > -(back.Width - wWidht)) then
        back.x = back.x - (backspeed * dt)
    else 
        back.x = 0
    end

end


function love.draw()
    love.graphics.draw(back.pic, back.x, back.y)
    love.graphics.draw(airplane.pic, airplane.x, airplane.y)
end
