Collectible = {}
Powerup = {}
poweruptimer = 25
collectibletimer = 4
local Collectible_Image
PowerUp_isUp = 8
Powerup_collected = false
increase = false
powerup_fontsize =  1

function LoadCollectible()
  Collectible_sound = love.audio.newSource("Music/341695__projectsu012__coins-1.wav", "static")
  Collectible_Image = love.graphics.newImage("Images/colectible.png")
end

function LoadPowerUp()
  Powerup_nocooldown = love.graphics.newImage("Images/powerup_nocooldown.png")
  Powerup_sound = love.audio.newSource("Music/351810__plasterbrain__shooting-star-4.ogg", "static")
end

function Collectibletimer(dt) -- Collectible timer
  
  if collectibletimer > 0 then

    collectibletimer = collectibletimer - dt
  else
    collectibletimer = 4
    end
  
end

function PowerUptimer(dt) -- Collectible timer
  
  if poweruptimer > 0 then

    poweruptimer = poweruptimer - dt
  else
    poweruptimer = 25
    end
  
end



function CreateCollectible (x,y, w, h)
  
  return {position = vector2.new(x,y), size = vector2.new(w,h)}
end

function DrawCollectible() -- Draws the collectibles on screen
  for i = 0 , table.getn(Collectible), 1 do
   -- love.graphics.setColor(0,1,0)
    if Collectible[i] ~= nil then
      
      love.graphics.draw(Collectible_Image,Collectible[i].position.x, Collectible[i].position.y,0,1.4,1.4,27,30)
    end
   
  end 

end

function DrawPowerUp()
  for i = 0 , table.getn(Powerup), 1 do
    
    if Powerup[i] ~= nil then
      love.graphics.draw(Powerup_nocooldown, Powerup[i].position.x, Powerup[i].position.y,0,1.5,1.5,1,39)
           
    end
  end
  if Powerup_collected then
    love.graphics.setColor(0.4, 1, 0.976)
    love.graphics.print("NO COOLDOWN", 680, 100, 0, powerup_fontsize, powerup_fontsize, 50)
  end
  love.graphics.setColor(1,1,1)
end
 

function UpdatePowerUp(dt)
  
  if poweruptimer <= 0 then
    Powerup[table.getn(Powerup)+1] = CreateCollectible(love.graphics.getWidth(), 400, 40, 35) -- creates a collectible and puts it in the table
  end
  
  for i = 0, table.getn(Powerup), 1 do
    if Powerup[i] ~= nil  then
      if rounded_distance_traveled >= 0 and rounded_distance_traveled < 40 then
        Powerup[i].position.x = Powerup[i].position.x - (250 *dt)
      elseif rounded_distance_traveled > 40 then
        Powerup[i].position.x = Powerup[i].position.x - (300 *dt)
      end   
         
      local Collected = CheckBoxCollision(Powerup[i].position.x, Powerup[i].position.y, Powerup[i].size.x ,Powerup[i].size.y, player.position.x, player.position.y, player.width, player.height) -- checks if player collected the powerup
        
      if Collected then 
        Powerup_sound:setVolume(0.2)
        Powerup_sound:play()
        Powerup_collected =  true
      end
   
      if Powerup[i].position.x + Powerup[i].size.x < 0   then
        table.remove(Powerup, i) -- remove from table if out of screen
      end
    end
  end
  
      if Powerup_collected ==  true then
        
        table.remove(Powerup, i)
        
        if PowerUp_isUp > 0 then
            PowerUp_isUp = PowerUp_isUp - dt
            bulletcooldown = 0
        else
            PowerUp_isUp = 8
            Powerup_collected = false
        end
      end
  
  --[[for i = 0, table.getn(Powerup), 1 do -- if the collectible spawn inside a LAzy enemy it will move slightly to the left  in order to be able to be collected
    for j=0, table.getn(Lazynumber), 1 do 
      if Powerup[i] ~= nil and Lazynumber[j] ~= nil then
        if CheckBoxCollision(Powerup[i].position.x, Powerup[i].position.y, Powerup[i].size.x , Powerup[i].size.y, Lazynumber[j].position.x, Lazynumber[j].position.y, Lazyproperties.Width, Lazynumber[j].size.y) then
      
          Powerup[i].position.x = Powerup[i].position.x - 31
        end
      end
    end
  end--]]
end


function UpdateCollectible(dt)
  --print(table.getn(Collectible))
  if collectibletimer <= 0 then
    local py = math.random(400, 550) -- Collectible position y is a random number between 350 and 550
    Collectible[table.getn(Collectible)+1] = CreateCollectible(love.graphics.getWidth(), py, 12, 12) -- creates a collectible and puts it in the table
  end
  
  for i = 1, table.getn(Collectible), 1 do
    if Collectible[i] ~= nil  then
      --print(i,Collectible[i].position.x)
      
      if rounded_distance_traveled > 0 and rounded_distance_traveled < 40 then
        Collectible[i].position.x = Collectible[i].position.x - (200 *  dt)
      elseif rounded_distance_traveled > 40 then
        Collectible[i].position.x = Collectible[i].position.x - (250 * dt)
      
      end
    

  
     
    local Collected = CheckBoxCollision(Collectible[i].position.x, Collectible[i].position.y, Collectible[i].size.x ,Collectible[i].size.y, player.position.x, player.position.y, player.width , player.height) -- checks if player collected the collectbile
      
    if Collected == true then
      Collectible_sound:setVolume(0.2)
      Collectible_sound:play() 
      countdown = countdown + 5 -- if player as collected add time and remove collectible from the table
      table.remove(Collectible, i)
    end
      
  end
end

for i = 1, table.getn(Collectible), 1 do
    if Collectible[i] ~= nil  then
      if Collectible[i].position.x + Collectible[i].size.x  <= 0  then
        table.remove(Collectible, i) -- remove from table if out of screen
      end
      end
end
end
  
  --[[for i = 0, table.getn(Collectible), 1 do -- if the collectible spawn inside a LAzy enemy it will move slightly to the left  in order to be able to be collected
    for j=0, table.getn(Lazynumber), 1 do 
      if Collectible[i] ~= nil and Lazynumber[j] ~= nil then
        if CheckBoxCollision(Collectible[i].position.x, Collectible[i].position.y, Collectible[i].size.x , Collectible[i].size.y, Lazynumber[j].position.x, Lazynumber[j].position.y, Lazyproperties.Width, Lazynumber[j].size.y) then
      
      Collectible[i].position.x = Collectible[i].position.x - 31
      
        end
      end
    end
  end --]]


function UpdatePowerUpFontsize(dt) -- increases and decreases Power Up Font size
 
  
  if ((PowerUp_isUp <= 8 and PowerUp_isUp>= 6) or (PowerUp_isUp<= 4 and PowerUp_isUp>= 2)) and Powerup_collected == true then
    increase = true
  elseif ((PowerUp_isUp <= 6 and PowerUp_isUp >= 4) or (PowerUp_isUp <= 2 and PowerUp_isUp >= 0)) and Powerup_collected == true then
    increase = false
  end
  if Powerup_collected then
    if increase  then
      powerup_fontsize = powerup_fontsize + (dt/15)
    else
      powerup_fontsize = powerup_fontsize - (dt/15)
    end
  end
end


