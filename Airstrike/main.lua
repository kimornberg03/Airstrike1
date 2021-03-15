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
    back.Speed = 100



    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    window = {}
    window.Widht, window.Height = love.window.getMode()

    

end

function love.update(dt)

    if love.keyboard.isDown("w") then
       if (airplane.y > 0 ) then 
        airplane.y = airplane.y - 5
       end
    end

    if love.keyboard.isDown("s") then
        if (airplane.y < (window.Height- airplane.Height)) then 
        airplane.y = airplane.y + 5
        end
    end
    
    if (back.x > -(back.Width - window.Widht)) then
        back.x = back.x - (back.Speed * dt)
    else 
        back.x = 0
    end

end


function love.draw()
    love.graphics.draw(back.pic, back.x, back.y)
    love.graphics.draw(airplane.pic, airplane.x, airplane.y)
end
