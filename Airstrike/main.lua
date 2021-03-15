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

    astroidPictable = {}
    astroidtable = {}
    astroidTime = 0
    astroidTimeEnd = love.math.random(0.5, 2)

    local strpic = "astroid"

    for i = 1, 3 do
       table.insert(astroidPictable, strpic..i..".png") 
    end
    

    astroid = {}
    astroid.x = window.Width
    astroid.y = 0
    astroid.pic = nil
    astroid.picWidht  = 0
    astroid.picHeight = 0
    astroid.speed = 100
    astroid.dead = false


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
    
    if (back.x > -(back.Width - window.Widht)) then
        back.x = back.x - (back.Speed * dt)
    else 
        back.x = 0
    end

    astroidTime = astroidTime + dt
    if (astroidTime > astroidTimeEnd) then
        astroidTime = 0
        astroidTimeEnd = love.math.random(0.5, 2)
        a = astroid
        a.y = love.math.random(0, window.Height)
        a.pic = astroidPictable[love.math.random(1, 3)]
       -- a.picWidht, a.picHeight = a.pic:getDimensions()

        table.insert(astroidtable, a)
    end
end




function love.draw()
    love.graphics.draw(back.pic, back.x, back.y)
    love.graphics.draw(airplane.pic, airplane.x, airplane.y)

    if (astroidtable ~= nil) then 
       
        for i, ast in ipair(astroidtable) do
            love.graphics.draw(ast.pic, ast.x, ast.y)
        end

    end
end
