-- everything player related


player = {
character_run = {},
character_anim_frame= 0,
character_anim_time= 0,
position = vector2.new(100, 800-(304+65)),
velocity = vector2.new(0, 0),
width = 20,
height = 65,
maxspeed= vector2.new(400, 800),
frictioncoefficient = 400,
--maxspeedair = vector2.new(50,800),
mass = 1,
onGround = false
}

function LoadPlayer()
  for x = 0, 14, 1 do  --load the animation frames
    player.character_run[x] = love.graphics.newImage("Images/character_run_" .. x .. ".png")
  end
  Death_sound_once = true
  Death_sound = love.audio.newSource("Music/415079__harrietniamh__video-game-death-sound-effect.wav","static")
end



function UpdatePlayer(dt)

  local acceleration = vector2.new(0, 0)
  local gravity = vector2.new(0, 1000)

  acceleration = vector2.applyForce(gravity, player.mass, acceleration) -- applying gravity to the player

  
  local friction = vector2.mult(player.velocity, -1)
  friction = vector2.normalize(friction)
  friction = vector2.mult(friction, player.frictioncoefficient)
  acceleration = vector2.applyForce(friction, player.mass, acceleration) -- applying friction to the player
  
  
   movedirection = vector2.new(0, -1)
  
--Movement imput start

  if love.keyboard.isDown("right") then

    local move = vector2.new(1600, 0)
    acceleration = vector2.applyForce(move, player.mass, acceleration)
    movedirection.x = 1

  player.character_anim_time= player.character_anim_time + (1.5 * dt)    
  if player.character_anim_time> 0.1 then  
    player.character_anim_frame= player.character_anim_frame+1--increases the anim. index
    
    if player.character_anim_frame > 7 then             --animation loop
      player.character_anim_frame = 0
    end    
      player.character_anim_time= 0  
    end

  elseif love.keyboard.isDown("left") then
    local move = vector2.new(-1600, 0)
    acceleration = vector2.applyForce(move, player.mass, acceleration)
    movedirection.x= -1
    
  if player.character_anim_frame < 8 or player.character_anim_frame > 14 then
    player.character_anim_frame = 8
  end
  
  player.character_anim_time= player.character_anim_time + (1.5 * dt)    
  if player.character_anim_time> 0.1 then  
    player.character_anim_frame= player.character_anim_frame + 1--increases the anim. index
    
    if player.character_anim_frame > 14 then             --animation loop
      player.character_anim_frame= 8  
    end    
      player.character_anim_time= 0  
    end

  else
      player.character_anim_frame=0
  end
  
  if (player.onGround) then 
    if love.keyboard.isDown("up") then
      
      local jump = vector2.new(0, -250000)
      acceleration = vector2.applyForce(jump, player.mass, acceleration)
      movedirection.y = 1
      player.onGround = false
    end   
    
  end


-- MOvement imput end



  local futurevelocity = vector2.add(player.velocity,vector2.mult(acceleration, dt))
  futurevelocity = vector2.limit(futurevelocity, player.maxspeed.x)
  local futureposition = vector2.add(player.position,vector2.mult(futurevelocity, dt))
  acceleration = CheckCollision(world, futureposition, movedirection, acceleration)



  player.velocity = vector2.add(player.velocity, vector2.mult(acceleration, dt))
  
  if player.onGround == true then
    player.velocity = vector2.limit(player.velocity, player.maxspeed.x)
  else
    --player.velocity = vector2.limit(player.velocity, vector2.magnitude(player.maxspeed))
    if player.velocity.x > 400 then
      player.velocity.x = 400
    elseif player.velocity.x < -400 then
      player.velocity.x = -400
    end
  end
  
  player.position = vector2.add(player.position, vector2.mult(player.velocity, dt)) -- Player movement


-- Player collision with edges of the window start

  if (player.position.x > love.graphics.getWidth() - player.width) then 
    
    player.position.x = love.graphics.getWidth() - player.width
    player.velocity.x = (player.velocity.x * -1) / 2

  elseif (player.position.x < 0) then
    player.position.x = 0
    player.velocity.x = (player.velocity.x * -1) / 2

  end

  if (player.position.y > love.graphics.getHeight() - player.height) then
    player.position.y = love.graphics.getHeight() - player.height
    player.velocity.y = 0
    player.onGround = true
  end
  
  -- Player collision with edges of the window end

end

function DrawPlayer()
  
  love.graphics.draw(player.character_run[player.character_anim_frame], player.position.x, player.position.y, 0, 1, 1, 20)
  
end



-- Player collisions start


function CheckCollision(world, futureposition, movedirection, acceleration)
  for i = 1, table.getn(world), 1 do
    local collisiondir = GetBoxCollisionDirection(futureposition.x, futureposition.y, player.width, player.height, world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
    --print(collisiondir.x .. " " .. collisiondir.y)
    if (collisiondir.x ~= 0 or collisiondir.y ~= 0) then
      if collisiondir.y == movedirection.y then --down collision
        player.velocity.y = 0
        acceleration.y = 0
        player.onGround=true
      elseif collisiondir.y == 1 then --up collision
        player.velocity.y = 0
        acceleration.y = 0
      elseif movedirection.x ~= collisiondir.x then --side collision
        player.velocity.x = 0
        acceleration.x = 0
      end
    end
  end
  return acceleration
end 

function Death()
  
  if Collided_with_enemy or countdown <= 0 then
    if Death_sound_once then
      Death_sound:setVolume(0.6)
      Death_sound:play()
      Death_sound_once = false
    end
    if death_sound_timer < 0 then
      game_music:stop()
      love.graphics.draw(Game_over)
      --love.graphics.rectangle("fill", 558, 291, 279 , 109)
      Game_over_music:play()
       
    end
  end
end


function Death_menu()
  
  x, y = love.mouse.getPosition()
  if x < 837 and x > 558 and y < 400 and y > 291 then
    if love.mouse.isDown(1) then
      Startmenu = true
      Startgame = false
      Game_over_music:stop()
      restart()
    end
    
  elseif  x < 789 and x > 594  and y < 530 and y > 430 then
    if love.mouse.isDown(1) then
      restart()
      Game_over_music:stop()
    end
  elseif x < 789 and x > 594  and y < 657 and y > 557 then
    if love.mouse.isDown(1) then
      love.event.quit()
    end
  end
end