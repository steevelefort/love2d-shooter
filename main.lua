
function love.load()
    counter = 0
    score = 0
    x = 512
    y = 600
    state = 0
    stars = {}
    for i = 1,1000 do
        table.insert(stars, {
            x = math.random(0,1023),
            y = math.random(0,767),
            r = math.random(0,2),
            speed = math.random(1,20),
            color = math.random(0,10)/10
        })
    end
    shoots = {}
    shootTimer = 0
    enemies = {}
    table.insert(enemies, newEnemy())
    font = love.graphics.newFont(80)
    fontScore = love.graphics.newFont(40)
end

function love.update()
    if state<200 then

       if love.keyboard.isDown("h") then
           x = x - 10
       end
       if love.keyboard.isDown("l") then
           x = x + 10
       end
       if love.keyboard.isDown("k") then
           y = y - 10
       end
       if love.keyboard.isDown("j") then
           y = y + 10
       end
       if love.keyboard.isDown("space") and shootTimer==0 then
           table.insert(shoots, { x = x, y = y })
           shootTimer = 10
       end

       if x<0 then
           x = 0
       end

       if x>1024 then
           x = 1024
       end

       if y<0 then
           y = 0
       end
       if y>698 then
           y = 698
       end
        for i,star in ipairs(stars) do
            star.y = star.y + star.speed
            if star.y>1023 then
                star.y = 0
            end
        end

        for i,shoot in ipairs(shoots) do
            shoot.y = shoot.y - 10
            if shoot.y<0 then
                table.remove(shoots, i)
            end
        end

        if shootTimer>0 then
            shootTimer = shootTimer - 1
        end

        for i,enemy in ipairs(enemies) do
            if score>3000 then
                if enemy.x<x then
                    enemy.x = enemy.x + 2
                else
                    enemy.x = enemy.x - 2
                end
            end
            enemy.y = enemy.y + enemy.speed
            if enemy.state>0 then enemy.state = enemy.state + 10 end
            if enemy.state>100 then enemy.state = enemy.state - 5 end
            --if enemy.y>200 and enemy.state==0 then enemy.state = 1 end
            if enemy.state>200 or enemy.y>799 then
                if enemy.y>799 then score = score - 10 end
                table.remove(enemies, i)
                table.insert(enemies, newEnemy())
            end

            for j,shoot in ipairs(shoots) do
                if (enemy.state==0 and shoot.x>enemy.x-50 and shoot.x<enemy.x+50 and shoot.y>enemy.y-20 and shoot.y<enemy.y+20) then
                    enemy.state = 1
                    table.remove(shoots,j)
                    score = score + 100
                    counter = counter + 1
                    if (counter>9) then
                        counter = 0
                        table.insert(enemies, newEnemy())
                    end
                end
            end

            if (enemy.state==0 and x>enemy.x-70 and x<enemy.x+70 and y>enemy.y-20 and y<enemy.y+20) then
                state = 1
            end
        end
        if state>0 and state<=200 then
            state = state + 10
        end
        if score<0 then score = 0 end
    else
        if love.keyboard.isDown("return") then
            shoots = {}
            shootTimer = 0
            enemies = {}
            table.insert(enemies, newEnemy())
            x = 512
            y = 600
            state = 0
            score = 0
            counter = 0
        end
    end
end

function love.draw()

    if state<200 then
        -- Drwing stars
        for i,star in ipairs(stars) do
            love.graphics.setColor(star.speed/20, star.speed/20, star.speed/20)
            love.graphics.circle("fill", star.x, star.y, star.r, 10) -- Draw white circle with 100 segments.
        end

        -- Drawing shoots
        for i,shoot in ipairs(shoots) do
            love.graphics.setColor(0.3, .8, 1)
            love.graphics.rectangle("fill",shoot.x-4,shoot.y,8,16)
            love.graphics.setColor(1, 1, 1)
            love.graphics.rectangle("fill",shoot.x-2,shoot.y,4,16)
        end

        drawHero(x,y,state)

        for i,enemy in ipairs(enemies) do
            drawEnemy(enemy.x,enemy.y, enemy.state)
        end
    else
        love.graphics.setColor(1, 1, 1)
        love.graphics.setFont(font)
        love.graphics.print("GAME OVER",260,330)
    end

    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(fontScore)
    love.graphics.print(score,5,5)

end

function drawHero(x,y, state)
    -- Drawing spaceshipp


    if state<100 then
        love.graphics.setColor(.3, .3, .3)
        love.graphics.polygon("fill", x,y+10, x,y+50, x-70, y+70);
        love.graphics.setColor(.2, .2, .2)
        love.graphics.polygon("fill", x,y+10, x,y+50, x+70, y+70);

        love.graphics.setColor(.7, .7, .7)
        love.graphics.polygon("fill", x,y, x,y+50, x-30, y+50);
        love.graphics.setColor(.5, .5, .5)
        love.graphics.polygon("fill", x,y, x+30,y+50, x, y+50);

        love.graphics.setColor(.5, .5, .5)
        love.graphics.polygon("fill", x-30,y+50, x, y+50, x, y+70);

        love.graphics.setColor(.3, .3, .3)
        love.graphics.polygon("fill", x,y+50, x+30, y+50, x, y+70);

        love.graphics.setColor(.0, .5, 1)
        love.graphics.polygon("fill", x,y+20, x,y+50, x-20, y+50);
        love.graphics.setColor(.0, .3, .7)
        love.graphics.polygon("fill", x,y+20, x+20,y+50, x, y+50);
    end
    if state>0 then
        if state<100 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", x, y-5, state)
        else
            love.graphics.setColor((200-state)/100, (200-state)/100, (200-state)/100)
            love.graphics.circle("fill", x, y-5, 200-state)
        end
    end
end

function drawEnemy(x,y,state)

    if state<100 then
        love.graphics.setColor(.4, 0, 0)
        love.graphics.polygon("fill",x-5,y-40,x-20,y, x+20,y, x+5, y-40)
        love.graphics.setColor(.6, 0, 0)
        love.graphics.polygon("fill",x-50,y-30,x,y-20,x,y+20)
        love.graphics.polygon("fill",x,y-20,x+50,y-30,x,y+20)
        love.graphics.setColor(1, 0, 0)
        love.graphics.polygon("fill",x-20,y-30,x,y-20,x,y+20)
        love.graphics.setColor(.8, 0, 0)
        love.graphics.polygon("fill",x,y-20,x+20,y-30,x,y+20)
        love.graphics.setColor(0, 0.5, 1)
        love.graphics.polygon("fill",x-10,y-20,x,y-10,x,y+10)
        love.graphics.setColor(0, 0.3, 0.7)
        love.graphics.polygon("fill",x,y-10,x+10,y-20,x,y+10)
    end
    if state>0 then
        if state<100 then
            love.graphics.setColor(1, 1, 1)
            love.graphics.circle("fill", x, y-5, state)
        else
            love.graphics.setColor((200-state)/100, (200-state)/100, (200-state)/100)
            love.graphics.circle("fill", x, y-5, 200-state)
        end
    end
end

function newEnemy()
    return {
        x = math.random(0,1023),
        y = -20,
        state = 0,
        speed = math.random(5,10)
    }
end
