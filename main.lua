function love.load()
 
 
    gameEnd = false --Use for detecting end of Airstrike
    
    --All variables for airplane
    airplane = {}
    airplane.x = 10
    airplane.y = 150
    airplane.pic = love.graphics.newImage("Pictures/Airplane.png")
    airplane.Width, airplane.Height = airplane.pic:getDimensions()
 
    --All variables for background
    back = {}
    back.x = 0
    back.y = 0
    back.pic = love.graphics.newImage("Pictures/background.png")
    back.Width, back.Height = back.pic:getDimensions()
    back.Speed = 100
 
    --All variables for bullet
    bullet = {}
    bullet.pic = love.graphics.newImage("Pictures/Bullet.png")
    bullet.Width, bullet.Height = bullet.pic:getDimensions()
 
    --All variables for window
    love.window.setMode(600, 300,{resizable=false})
    love.window.setTitle("AirStrike")
    window = {}
    window.Width, window.Height = love.window.getMode()
 
    --Min and Max time for creation of astroid
    astroidRandomMin = 2
    astroidRandomMax = 4
    
    --Duration time between creation for astroid
    astroidTime = 0
 
    --Randomize time for creation of astroid
    astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)
 
    --Tables used in program
    astroid = {}
    bullets = {}
    boom = {}
 
 
    bulletsSpeed = 300
    maxBullets = 5
 
    --Variables for gametime
    starttimeBool = false
    starttime = 0
    elapsedTime = 0
 
 
    music = love.audio.newSource("Sounds/music.mp3", "stream")
    music:setVolume(1)
    music:setLooping(true)
    music:play()
 
    losing = love.audio.newSource("Sounds/losing.mp3", "stream")
    losing:setVolume(1)
    losing:setLooping(false)
    losingbool = true
    
end
 
function love.update(dt)

    if (gameEnd == true and losingbool == true) then
        music:setVolume(0)
        losing:play()
        losingbool = false
    end
 
 
    if love.keyboard.isDown("r") then
        love.event.quit("restart")
    end
 
 
    --Move airplane up when press "w"
    if love.keyboard.isDown("w") then
       if (airplane.y > 0) then 
        airplane.y = airplane.y - 5
       end
    end
 
    --Move airplane down when press "s"
    if love.keyboard.isDown("s") then
        if (airplane.y < (window.Height- airplane.Height)) then 
        airplane.y = airplane.y + 5
        end
    end
 
    --Move background
    if (back.x > -(back.Width - window.Width)) then
        back.x = back.x - (back.Speed * dt)
    else 
        back.x = 0
    end
 
    --Update astroid
    for i, a in ipairs(astroid) do
        --Move astroid
        a.x = a.x - (a.speed * dt)
 
        --End game if astroid is out of window
        if (a.x < (0 - a.pic:getWidth())) then
            gameEnd = true
        end
 
        --Checking if any bullet hit an astroid
        for y, b in ipairs(bullets) do
            if (a.x < (b.x + bullet.Width) and (b.y > a.y) and (b.y < (a.y + a.Height))) then
                --If a hit add a explosion
                addBoom(a.x, a.y)
                --If a hit remove astroid and bullet
                table.remove(astroid, i)
                table.remove(bullets, y)
            end
        end
    end
 
    --If any explosion increament picture number
    for j, exp in ipairs(boom) do
        exp.picnumber = exp.picnumber + 1
        --If all pictures showed remove explosion from table
        if exp.picnumber > 19 then
            table.remove(boom, j)
        end
    end
 
    --Update bullets
    for y, b in ipairs(bullets) do
        b.x = b.x + (bulletsSpeed * dt)
        --Remove if out of screen
        if (b.x > window.Width) then
            table.remove(bullets, y)
       end
    end
    
    --Increases creation of astroids by time
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
 
    --Update astroid creation time
    astroidTime = astroidTime + dt
 
 
    --Create astriod
    if (astroidTime > astroidTimeEnd) then
        astroidTime = 0
        astroidTimeEnd = love.math.random(astroidRandomMin, astroidRandomMax)  
        addAstorid()     
    end
end
 
--Create a bullet when press space
function love.keypressed( key )
    if (key == "space") then
        addBullet()
    end
 end
 
 --Add a explosion to the boom table
function addBoom(x, y)
    
    boom[#boom + 1] = {
        x = x,
        y = y,
        picnumber = 0
    } 
end
 
--Add a bullet to the bullets table
function addBullet()
    --If not max bullet in table add a bullet
    if (#bullets < maxBullets) then
        bullets[#bullets+1] = {
            x = airplane.x + (airplane.Width - 5),
            y = airplane.y + (airplane.Height/2) - 8
            }   
    end 
end
 
--Add a astroid to the astroid table
function addAstorid()
 
    --Create a picture and get dimention
    local tmppic = love.graphics.newImage("Pictures/astroid"..love.math.random(1, 3)..".png")
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
 
end
 
 
function love.draw()
 
    --Game running
    if (gameEnd == false) then
        --Draw background and airplane
        love.graphics.draw(back.pic, back.x, back.y)
        love.graphics.draw(airplane.pic, airplane.x, airplane.y)
        
        --Get start value for game time
        if ((starttimeBool) == false) then
            starttime = os.clock()
            starttimeBool = true
        end
        --Update game time
        elapsedTime = os.clock() - starttime
 
        --Draw game title and game time on screen top
        love.window.setTitle("Airstrike       "..string.format("Time: %.2f", elapsedTime))
        
        --Draw all astroid in astroid table
        for i, ast in ipairs(astroid) do
            love.graphics.draw(ast.pic, ast.x, ast.y)
        end
 
        --Draw all bullets in bullets table
        for y, bul in ipairs(bullets) do
            love.graphics.draw(bullet.pic, bul.x, bul.y)
        end
 
        --Draw all explosion in boom table
        for j, exp in ipairs(boom) do
            love.graphics.draw(love.graphics.newImage("Pictures/Ex/pic"..exp.picnumber..".png"), exp.x, exp.y)
        end  
 
    --Game ended
    else
        --Draw title
        love.window.setTitle("AirStrike")
        love.graphics.setNewFont(15)
        --Draw players game time
        love.graphics.print(string.format("Time: %.2f", elapsedTime),10,10)
 
        --Create a string and font to get dimention of string
        local strgame = "Game Over"
        local font = love.graphics.setNewFont(25)
        local widthG = font:getWidth(strgame)
        local heightG = font:getHeight(strgame)
 

        --Create a string and font to get dimention of string
        strrestart = "Press r to restart"
        local font = love.graphics.setNewFont(15)
        local heightE = font:getHeight(strrestart)
 
        --Draw Game Over and restart
        love.graphics.print(strgame, ((window.Width/2) - widthG/2), ((window.Height/2) - heightG/2))
        love.graphics.print(strrestart, 10, (window.Height - heightE - 10))
    end
 
end
 
 
 
