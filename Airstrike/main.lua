function love.load()

    gameEnd = false
    
    airplane = {}
    airplane.x = 10
    airplane.y = 150
    airplane.pic = love.graphics.newImage("Pictures/Airplane.png")
    airplane.Width, airplane.Height = airplane.pic:getDimensions()

    back = {}
    back.x = 0
    back.y = 0
    back.pic = love.graphics.newImage("Pictures/background.png")
    back.Width, back.Height = back.pic:getDimensions()
    back.Speed = 100

    bullet = {}
    bullet.pic = love.graphics.newImage("Pictures/Bullet.png")
    bullet.Width, bullet.Height = bullet.pic:getDimensions()

    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    window = {}
    window.Width, window.Height = love.window.getMode()

    astroidRandomMin = 2
    astroidRandomMax = 4
    
    astroidTime = 0
    astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)

    astroidPictable = {}
    local strpic = "Pictures/astroid"

    for i = 1, 3 do
       table.insert(astroidPictable, strpic..i..".png") 
    end
    
    astroid = {}
    bullets = {}
    bulletsSpeed = 300
    maxBullets = 5
    starttimeBool = false
    starttime = 0
    elapsedTime = 0

    boom = {}
    boompic = {}
    for i = 0, 19 do
        table.insert(boompic, "Pictures/Ex/pic"..i..".png")
    end

    music = love.audio.newSource("music.mp3", "stream")
    music:setVolume(1)
    music:setLooping(true)

end



function love.update(dt)

    if gameEnd == false then
        music:play()
    elseif gameEnd == true then
        music:setVolume(0)
end


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

    if love.keyboard.isDown("r") then
        love.event.quit("restart")
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
                addBoom(a.x, a.y)
                table.remove(astroid, i)
                table.remove(bullets, y)
            end
        end
    end

    for j, exp in ipairs(boom) do
        exp.picnumber = exp.picnumber + 1

        if exp.picnumber > 19 then
            table.remove(boom, j)
        end
    end

    for y, b in ipairs(bullets) do
        b.x = b.x + (bulletsSpeed * dt)
        
        if (b.x > window.Width) then
            table.remove(bullets, y)
       end
    end

    if (elapsedTime > 10 and elapsedTime < 20) then
        astroidRandomMin = 1
        astroidRandomMax = 3
    elseif (elapsedTime > 20 and elapsedTime < 30) then
        astroidRandomMin = 0.5
        astroidRandomMax = 2
    elseif (elapsedTime > 30 and elapsedTime < 40) then
        astroidRandomMin = 0.3
        astroidRandomMax = 1.5
    elseif (elapsedTime > 40 and elapsedTime < 50) then
        astroidRandomMin = 0.2
        astroidRandomMax = 1.25
    elseif (elapsedTime > 50 and elapsedTime < 60) then
        astroidRandomMin = 0.1
        astroidRandomMax = 1
    elseif (elapsedTime > 60 and elapsedTime < 100) then
        astroidRandomMin = 0.001
        astroidRandomMax = 0.002
    end

    astroidTime = astroidTime + dt

    if (astroidTime > astroidTimeEnd) then
        astroidTime = 0
        astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)  
        addAstorid()     
    end
end

function addBoom(x, y)
    
    boom[#boom+1] = {
        x = x,
        y = y,
        picnumber = 0
    } 
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
    
        if ((starttimeBool) == false) then
            starttime = os.clock()
            starttimeBool = true
        end

        elapsedTime = os.clock() - starttime
        local str = "Airstrike       "..string.format("Time: %.2f", elapsedTime)
   

        love.window.setTitle(str)
        for i, ast in ipairs(astroid) do
            love.graphics.draw(ast.pic, ast.x, ast.y)
        end

        for y, bul in ipairs(bullets) do
            love.graphics.draw(bullet.pic, bul.x, bul.y)
        end

        for j, exp in ipairs(boom) do
            love.graphics.draw(love.graphics.newImage(boompic[exp.picnumber]), exp.x, exp.y)
        end        
  
    else
        love.window.setTitle("AirStrike")
        love.graphics.setNewFont(12)
        local str = string.format("Time: %.2f", elapsedTime)
        love.graphics.print(str,10,10)
        str = "Game Over"
        local font = love.graphics.setNewFont(25)
        local width = font:getWidth(str)
        local height = font:getHeight(str)

        love.graphics.print(str, ((window.Width/2) - width/2), ((window.Height/2) - height/2))
    end

end


