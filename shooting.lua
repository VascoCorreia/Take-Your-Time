bulletproperties = {
  size = vector2.new(15,15),
  image,
}

bullets = {}
local cooldown_up = false
bulletcooldown = 0.75

function LoadBullets()
  bulletproperties.image = love.graphics.newImage("Images/bullet_right.png")
  shooting_sound = love.audio.newSource("Music/421704__bolkmar__sfx-laser-shoot-02.wav", "static")
  
end

function love.keypressed(key, scancode, isrepeated)
  shooting_sound:setVolume(0.3)
  if key == "d" and cooldown_up == false then
   -- bulletproperties.image_right = true
   -- bulletproperties.image_left = false
   -- bulletproperties.image_up = false
    cooldown_up = true
    table.insert(bullets, {x = (player.position.x + player.width), y = (player.position.y + player.height / 2) - 8  , upshot = false, leftshot = false})
    shooting_sound:play()
    
  elseif key == "a" and cooldown_up == false then
  --  bulletproperties.image_right = false
    --bulletproperties.image_left = true
    --bulletproperties.image_up = false    
    cooldown_up = true
    shooting_sound:play()
    table.insert(bullets, {x = (player.position.x), y = (player.position.y + player.height / 2) - 3  , upshot = false, leftshot = true})
  
  elseif key == "w" and cooldown_up == false then
    cooldown_up = true
    shooting_sound:play()
    table.insert(bullets, {x = (player.position.x + (player.width/ 2)), y = player.position.y, upshot = true, leftshot = false}) -- shooting upwards

  end
end

function DrawBullets()
  for i = 1, table.getn(bullets), 1 do
    if bullets[i] ~= nil then
      --print(bullets[i].leftshot)
     -- love.graphics.rectangle("fill", bullets[i].x, bullets[i].y, bulletproperties.size.x, bulletproperties.size.y)
      
      if bullets[i].upshot == false and  bullets[i].leftshot == false then
        love.graphics.draw(bulletproperties.image, bullets[i].x, bullets[i].y)
      elseif bullets[i].upshot == false and bullets[i].leftshot == true then
        love.graphics.draw(bulletproperties.image, bullets[i].x, bullets[i].y,0,-1)
      elseif bullets[i].upshot == true and bullets[i].leftshot == false then
        love.graphics.draw(bulletproperties.image, bullets[i].x, bullets[i].y, -3.14/2)
      end
    end
  end
end
function UpdateBullets(dt)
  
  for i = 1, table.getn(bullets), 1 do
    
    if bullets[i] ~= nil then
      
      if bullets[i].upshot == true then
        bullets[i].y = bullets[i].y - (500*dt) 
      elseif bullets[i].leftshot == true then
        bullets[i].x = bullets[i].x + (-500 * dt)
      else
        bullets[i].x = bullets[i].x + (500 * dt)
      end
      if bullets[i].x > love.graphics.getWidth() or bullets[i].y <= 0 or bullets[i].x < 0  then -- bullets dissappear if touch end screen or ceiling
        table.remove(bullets, i)
      end
     end
  end 
end

function updatecooldown(dt)
  if cooldown_up == true then
  bulletcooldown = bulletcooldown - dt
  if bulletcooldown <= 0 then
    bulletcooldown = 0.75
    cooldown_up = false
  end
  end
  return bulletcooldown
end