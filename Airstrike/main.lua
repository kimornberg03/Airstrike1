function love.load()

    gameEnd = false
    
    airplane = {}
    airplane.x = 10
    airplane.y = 150
    airplane.pic = love.graphics.newImage("Airplane.png")
    airplane.Width, airplane.Height = airplane.pic:getDimensions()

    back = {}
    back.x = 0
    back.y = 0
    back.pic = love.graphics.newImage("background.png")
    back.Width, back.Height = back.pic:getDimensions()
    back.Speed = 100



    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    window = {}
    window.Width, window.Height = love.window.getMode()

    
    
    astroidTime = 0
    astroidTimeEnd = love.math.random(0.5, 2)

    astroidPictable = {}
    local strpic = "astroid"

    for i = 1, 3 do
       table.insert(astroidPictable, strpic..i..".png") 
    end
    
    astroid = {}

end

function love.update(dt)

    if love.keyboard.isDown("w") then
       if (airplane.y > 0) then 
        airplane.y = airplane.y - 5
       end
    end

    if love.keyboard.isDown("s") then
        if (airplane.y < (window.Height- airplane.Height)) then 
        airplane.y = airplane.y + 5
        end
    end
    
    if (back.x > -(back.Width - window.Width)) then
        back.x = back.x - (back.Speed * dt)
    else 
        back.x = 0
    end
     
    for i, a in ipairs(astroid) do
        a.x = a.x - (a.speed * dt)
        if (a.x < (0 - a.pic:getWidth())) then
            gameEnd = true
        end
    end

    astroidTime = astroidTime + dt

    if (astroidTime > astroidTimeEnd) then
        astroidTime = 0
        astroidTimeEnd = love.math.random(0.5, 2)
        astroid[#astroid+1] = {
            x = window.Width,
            y = love.math.random(0, window.Height),
            speed = love.math.random(50, 300),
            pic = love.graphics.newImage(astroidPictable[love.math.random(1, 3)]),
        }     
    end
end


function love.draw()
    
    
    if (gameEnd == false) then
        
        love.graphics.draw(back.pic, back.x, back.y)
        love.graphics.draw(airplane.pic, airplane.x, airplane.y)
    
   
        for i, ast in ipairs(astroid) do
            love.graphics.draw(ast.pic, ast.x, ast.y)
        end
    else
        love.graphics.print("Game end", 100, 100)
    end
end


