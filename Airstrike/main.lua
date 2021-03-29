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

    bullet = {}
    bullet.pic = love.graphics.newImage("Bullet.png")
    bullet.Width, bullet.Height = bullet.pic:getDimensions()

    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    window = {}
    window.Width, window.Height = love.window.getMode()

    astroidRandomMin = 0.5
    astroidRandomMax = 2.5
    
    astroidTime = 0
    astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)

    astroidPictable = {}
    local strpic = "astroid"

    for i = 1, 3 do
       table.insert(astroidPictable, strpic..i..".png") 
    end
    
    astroid = {}
    bullets = {}
    bulletsSpeed = 300
    maxBullets = 5
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

    function love.keypressed( key )
        if (key == "space") then
            addBullet()
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

        for y, b in ipairs(bullets) do
            if (a.x < (b.x + bullet.Width) and (b.y > a.y) and (b.y < (a.y + a.Height))) then
                table.remove(astroid, i)
                table.remove(bullets, y)
            end
        end
    end

    for y, b in ipairs(bullets) do
        b.x = b.x + (bulletsSpeed * dt)
        
        if (b.x > window.Width) then
            table.remove(bullets, y)
       end
    end

    astroidTime = astroidTime + dt

    if (astroidTime > astroidTimeEnd) then
        astroidTime = 0
        astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)  
        addAstorid()     
    end
end

function addBullet()
    
    if (#bullets < maxBullets) then
        bullets[#bullets+1] = {
            x = airplane.x + (airplane.Width - 5),
            y = airplane.y + (airplane.Height/2) - 8
            }   
    end 
end

function addAstorid()

    local tmppic = love.graphics.newImage(astroidPictable[love.math.random(1, 3)])
    local tmpW, tmpH
    tmpW, tmpH = tmppic:getDimensions()

    astroid[#astroid+1] = {
        x = window.Width,
        y = love.math.random(0, window.Height - tmpH),
        speed = love.math.random(50, 300),
        pic = tmppic,
        Height = tmpH,
        Width = tmpW
    } 

    astroid[#astroid].Height = astroid[#astroid].pic:getHeight()
end


function love.draw()
    
    
    if (gameEnd == false) then
        
        love.graphics.draw(back.pic, back.x, back.y)
        love.graphics.draw(airplane.pic, airplane.x, airplane.y)
    
   
        for i, ast in ipairs(astroid) do
            love.graphics.draw(ast.pic, ast.x, ast.y)
        end

        for y, bul in ipairs(bullets) do
            love.graphics.draw(bullet.pic, bul.x, bul.y)
        end
    else
        love.graphics.print("Game end", 100, 100)
    end

end


