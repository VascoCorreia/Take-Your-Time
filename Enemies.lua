Pressure_fall = false

Enemy_timer = 3

Lazyproperties = {
  velocity = vector2.new(150,0),
  Width = 44.25,
  run = {},
  Head,
  Body,
  anim_time = 0,
  anim_frame = 0,
  }
LazyHeight = {129, 182.25, 235.5,288.75}
Lazynumber = {}
Lazylegs = {}

Pressureproperties = {
  Width = 50 ,
  Height = 47,
  Image,
} 

Pressurenumber = {}

function initEnemy()
  
    EnemyPresets = {
  [0] = EnemyPreset_0,
  [1] = EnemyPreset_1,
  [2] = EnemyPreset_2,
  [3] = EnemyPreset_3,
  [4] = EnemyPreset_4,
  [5] = EnemyPreset_5,
  [6] = EnemyPreset_6,
  [7] = EnemyPreset_7,
  [8] = EnemyPreset_8,
  [9] = EnemyPreset_9,
  }

end

function LoadEnemies()
  Pressureproperties.Image = love.graphics.newImage("Images/pressure.png")
  Lazyproperties.Head = love.graphics.newImage("Images/Lazy_cabeca.png")
  Lazyproperties.Body = love.graphics.newImage("Images/Lazy_corpo.png")
  for i=0, 4, 1 do
    Lazyproperties.run[i] =love.graphics.newImage("Images/Lazy_run_".. i .. ".png")
  end
end

function enemytimer(dt) -- New wave timer
  
  if Enemy_timer > 0 then
    Enemy_timer = Enemy_timer - dt
  else
    Enemy_timer = 5
  end
  
end

function CreateEnemy(x,y,w,h,vx,vy)
  return {position = vector2.new(x,y), size = vector2.new(w,h), velocity = vector2.new(vx,vy), pressuredeath = false}
  
end

function UpdateLazy(dt)



  for i=1, table.getn(Lazynumber), 1 do
    if Lazynumber[i] ~= nil then
    
      Lazynumber[i].position = vector2.sub(Lazynumber[i].position, 
      vector2.mult(Lazyproperties.velocity, dt)) -- movement
        if Lazynumber[i].position.x + Lazyproperties.Width < 0 then
          table.remove(Lazynumber, 1) -- remove from table if out of screen
        end
    end
  end
  
 for i=1, table.getn(bullets), 1 do
      for j=1, table.getn(Lazynumber), 1 do
        if bullets[i] ~= nil then
        
          if CheckBoxCollision(bullets[i].x, bullets[i].y, bulletproperties.size.x , bulletproperties.size.y , Lazynumber[j].position.x, Lazynumber[j].position.y, Lazyproperties.Width, Lazynumber[j].size.y) then
            if Lazynumber[j].size.y ~= LazyHeight[1] then
              Lazynumber[j].size.y = Lazynumber[j].size.y - 53.25
              Lazynumber[j].position.y = 640 - Lazynumber[j].size.y
            end
            table.remove(bullets,i)
          end
        end
      end
    end
    
    
  
 for i=1, table.getn(bullets), 1 do
      for j=1, table.getn(Lazylegs), 1 do
        if bullets[i] ~= nil then
        
          if CheckBoxCollision(bullets[i].x, bullets[i].y, bulletproperties.size.x , bulletproperties.size.y , Lazylegs[j].position.x, Lazylegs[j].position.y, Lazyproperties.Width, Lazylegs[j].size.y) then
          
            table.remove(bullets,i)
            
          end
        end
      end
    end
    
  
  --start of Lazy leg walk animation --
  Lazyproperties.anim_time= Lazyproperties.anim_time + (1.5 * dt)    
  if Lazyproperties.anim_time > 0.1 then  
    Lazyproperties.anim_frame = Lazyproperties.anim_frame + 1
    
    if Lazyproperties.anim_frame > 4 then
      Lazyproperties.anim_frame = 0
    end    
      Lazyproperties.anim_time = 0  
    --end of Lazy leg walk animation --
  end
end



function UpdatePressure(dt)
 
  Pressure_death = false  
    
    for i=1, table.getn(Pressurenumber), 1 do
      if Pressurenumber[i] ~= nil then
         
        Pressurenumber[i].position = vector2.sub(Pressurenumber[i].position, vector2.mult(Pressurenumber[i].velocity, dt))
        
        if CheckBoxCollision(Pressurenumber[i].position.x,Pressurenumber[i].position.y,Pressureproperties.Width,Pressureproperties.Height,world[2].position.x,world[2].position.y,world[2].size.x,world[2].size.y) then
          
          Pressurenumber[i].velocity.y = 0
        end
        
        
        if Pressurenumber[i].position.x <= player.position.x + player.width and Pressurenumber[i].velocity.x ~= 0 then
        
          Pressurenumber[i].velocity.x = 0
          Pressurenumber[i].velocity.y = -500
        end
      
        if (Pressurenumber[i].position.x + Pressureproperties.Width < 0) then
          table.remove(Pressurenumber, i) -- remove from table if out of screen or dead
        end
      end
    end
    
    for i=1, table.getn(Pressurenumber), 1 do
      for j=1, table.getn(bullets), 1 do
print (i , j)
        if bullets[j] ~= nil and Pressurenumber[i] ~=  nil then
         -- print(table.getn(Pressurenumber))
          if CheckBoxCollision(bullets[j].x, bullets[j].y, bulletproperties.size.x , bulletproperties.size.y , Pressurenumber[i].position.x, Pressurenumber[i].position.y, Pressureproperties.Width, Pressureproperties.Height) then
            Pressurenumber[i].pressuredeath = true
          end
            if Pressurenumber[i].pressuredeath == true then
              table.remove(Pressurenumber, i)
              table.remove(bullets,j)
            end
          end
        end
      end
    end
  



function EnemyPreset_0() -- 1 very small Lazy (beggining of game) EASY DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(),640-LazyHeight[1], Lazyproperties.Width, LazyHeight[1])
  
end

function EnemyPreset_1() -- 1 Pressure (beggining of game) EASY DIFFICULTY
  Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
end

function EnemyPreset_2() -- 1 small lazy (beggining of game) EASY DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(),640-LazyHeight[2], Lazyproperties.Width, LazyHeight[2])
  
end

function EnemyPreset_3() -- 1 medium lazy (beggining of game) EASY DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(),640-LazyHeight[3], Lazyproperties.Width, LazyHeight[3])
  
end

function EnemyPreset_4() -- 1 Pressure and 1 small Lazy (beggining of game) EASY DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(),640-LazyHeight[2], Lazyproperties.Width, LazyHeight[2])
  
  Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
end

function EnemyPreset_5() -- 1 pressure, 1 small Lazy in front 1 big Lazy Behind MEDIUM DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+200,640-LazyHeight[2], Lazyproperties.Width, LazyHeight[2])
  
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+300, 640 - LazyHeight[4], Lazyproperties.Width, LazyHeight[4])
 
  Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
end

function EnemyPreset_6() -- 1 small lazy in front, 1 small Lazy in middle 1 very big Lazy Behind MEDIUM DIFFICULTY
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(),640-LazyHeight[2], Lazyproperties.Width, LazyHeight[2])
  
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+400, 640 - LazyHeight[1], Lazyproperties.Width, LazyHeight[1])
  
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+500, 640 - LazyHeight[4] , Lazyproperties.Width, LazyHeight[4])
  
end

function EnemyPreset_7() -- 1 pressure in front, 1 small lazy in front, 1 small Lazy in middle 1 very big Lazy Behind HARD DIFFICULTY
  Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()-100,640-LazyHeight[2], Lazyproperties.Width, LazyHeight[2])
  
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+400, 640 - LazyHeight[1], Lazyproperties.Width, LazyHeight[1])
  
  Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth()+500, 640 - LazyHeight[4] , Lazyproperties.Width, LazyHeight[4])
  
end

function EnemyPreset_8() -- 2 pressures
    Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
    Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth()+200, 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
    
end

function EnemyPreset_9() -- 1 pressure in front, 1 small lazy in front, 1 small Lazy in middle 1 very big Lazy Behind HARD DIFFICULTY
    Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth(), 200, Pressureproperties.Width, Pressureproperties.Height,250,0)
    Pressurenumber[table.getn(Pressurenumber)+1] = CreateEnemy(love.graphics.getWidth()+200, 400, Pressureproperties.Width, Pressureproperties.Height,250,0)
    Lazynumber[table.getn(Lazynumber)+1] = CreateEnemy(love.graphics.getWidth(), 640 - LazyHeight[4], Lazyproperties.Width, LazyHeight[4])
    
end


function Drawenemy()
  for i=1, table.getn(Lazynumber), 1  do
  --  love.graphics.rectangle("fill", Lazynumber[i].position.x, Lazynumber[i].position.y, Lazynumber[i].size.x, Lazynumber[i].size.y)
    love.graphics.draw(Lazyproperties.run[Lazyproperties.anim_frame], Lazynumber[i].position.x, 630-96,0,1.5,1.5) -- legs
   
     if Lazynumber[i].size.y == LazyHeight[1] then
      love.graphics.draw(Lazyproperties.Head, Lazynumber[i].position.x, 630-96-76.5,0,1.5,1.5)
     elseif Lazynumber[i].size.y == LazyHeight[2] then
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5,0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Head, Lazynumber[i].position.x, 630-96-76.5-52.7,0,1.5,1.5) 
     elseif Lazynumber[i].size.y == LazyHeight[3] then
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5,0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5-52.7,0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Head, Lazynumber[i].position.x, 630-96-76.5-(52.7*2),0,1.5,1.5)
    elseif Lazynumber[i].size.y == LazyHeight[4] then
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5,0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5-52.7,0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Body, Lazynumber[i].position.x, 630-96-76.5-(52.7*2),0,1.5,1.5)
      love.graphics.draw(Lazyproperties.Head, Lazynumber[i].position.x, 630-96-76.5-(52.7*3),0,1.5,1.5)
       
       
    end
  end
  
  for i=1, table.getn(Pressurenumber), 1  do
    --love.graphics.rectangle("fill",Pressurenumber[i].position.x,Pressurenumber[i].position.y,Pressurenumber[i].size.x,Pressurenumber[i].size.y)
    love.graphics.draw(Pressureproperties.Image, Pressurenumber[i].position.x,Pressurenumber[i].position.y,0,1.35,1.35, 12,14)
  end
  
end


function EnemyCollision() 
   
    for i =1, table.getn(Lazynumber), 1 do
      if CheckBoxCollision(player.position.x, player.position.y, player.width , player.height , Lazynumber[i].position.x,Lazynumber[i].position.y,Lazyproperties.Width, Lazynumber[i].size.y) then
        Collided_with_enemy = true
      end
    end
    
    for i =1, table.getn(Pressurenumber), 1 do
      if CheckBoxCollision(player.position.x, player.position.y, player.width , player.height , Pressurenumber[i].position.x, Pressurenumber[i].position.y, Pressureproperties.Width, Pressurenumber[i].size.y) then
        Collided_with_enemy = true
      
      end
    end
  return Collided_with_enemy 
end


