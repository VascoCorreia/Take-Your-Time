require "vector2"
require "world"
require "player"
require "collision"
require "Enemies"
require "conf"
require "shooting"
require "countdowntimer"
require "distancetraveled"
require "motivation"
require "collectibles"
require "restart"




function love.load()
 
 
  Startmenu = true
  Startgame = false
  Instructions = false
  VictoryScreen = false
  
  
  
  death_sound_timer = 2
  Victory = love.graphics.newImage("Images/Victory.png")
  mainmenu_music = love.audio.newSource("Music/Main_menu_music.mp3","stream")
  background = love.graphics.newImage("Images/background.png")
  mainmenu = love.graphics.newImage("Images/mainmenu.png")
  victory_music = love.audio.newSource("Music/432699__skibkamusic__skibka-music-dreams.mp3", "stream")
  game_music = love.audio.newSource("Music/251461__joshuaempyre__arcade-music-loop.wav", "stream")
  instructions = love.graphics.newImage("Images/Instructions.png")
  Game_over = love.graphics.newImage("Images/Game_over.png")
  Game_over_music = love.audio.newSource("Music/449408__skibkamusic__skibka-music-blackout.mp3","stream")
  Collided_with_enemy = false
  love.window.setMode(1400, 800)
  LoadWorld()
  initEnemy()
  LoadPlayer()
  LoadCollectible()
  LoadEnemies()
  LoadPowerUp()
  LoadBullets()
end


function love.update(dt)
  --print(mousex,mousey)
  --print(Death_sound_once)
  if Startgame then
    print(Won)
    if Collided_with_enemy == false and countdown > 0 and Won == false then

      if Enemy_timer <= 0 and rounded_distance_traveled <= 5 then
        EnemyPresets[0]()
      elseif Enemy_timer <= 0 and rounded_distance_traveled <= 15 and rounded_distance_traveled > 5 then
        EnemyPresets[1]()
      elseif Enemy_timer <= 0 and rounded_distance_traveled <= 40 and rounded_distance_traveled > 15 then
        local random = math.random(2,5)
        EnemyPresets[random]()
      elseif Enemy_timer <= 0 and rounded_distance_traveled <= 120 and rounded_distance_traveled > 40 then
        Lazyproperties.velocity.x = 200
        local random = math.random(4,6)
        EnemyPresets[random]()
      elseif Enemy_timer <= 0 and rounded_distance_traveled > 120 and rounded_distance_traveled < 290 then
        Lazyproperties.velocity.x = 250
        local random = math.random(5,9)
        EnemyPresets[random]()
        
      end
      
      UpdateDistacetraveled(dt)
      UpdateCollectible(dt)
      Collectibletimer(dt)
      UpdateLazy(dt)
      UpdatePressure(dt)
      UpdateBullets(dt)
      UpdatePlayer(dt)
      enemytimer(dt)
      EnemyCollision(dt)
      Countdown(dt)
      updatecooldown(dt)
      PowerUptimer(dt)
      UpdatePowerUp(dt)
      UpdatePowerUpFontsize(dt)
      
    else
      if death_sound_timer > 0 then
        death_sound_timer = death_sound_timer - dt
        
      end
      if Won then
        UpdatePlayer(dt)
        UpdateLazy(dt)
        UpdatePressure(dt)
        if player.position.x + player.width < 1400 then
          VictoryScreen = true
        end
        end
    end
  end
end


function love.draw()
-- print(Startmenu, Startgame)
  if Startmenu and Startgame == false then
    mainmenu_music:setVolume(0.1)
    mainmenu_music:play()
    love.graphics.draw(mainmenu)
    mousex,mousey = love.mouse.getPosition()
 
      if mousex > 162 and mousex < 402 and mousey >  237 and mousey < 337 then
        if love.mouse.isDown(1) then
          Startgame = true
          Startmenu = false
        end
        
      elseif Instructions then
        love.graphics.draw(instructions)
        if mousex > 34 and mousex < 136 and mousey >  717 and mousey < 759 then
          if love.mouse.isDown(1) then
          Instructions = false
          end
        end
          
      elseif mousex > 162 and mousex < 402 and mousey > 507 and mousey < 607 then
        if love.mouse.isDown(1) then
          love.event.quit()
        end
      end

    --love.graphics.rectangle("fill", 162, 510,240,100)
  else
    if Startgame then
      if (Collided_with_enemy == false and countdown > 0 and Won == false) then
        game_music:setVolume(0.2)
        mainmenu_music:stop()
        game_music:play()
        love.graphics.draw(background,0,0,0,1,1.33)
        DrawPlayer()
        Drawenemy ()
        DrawBullets()
        DrawCollectible()
        DrawPowerUp()
        DrawDistancetraveled()
        Drawtimer()
        Drawmotivation() 

      else
        Death()
        Death_menu()
        

      end
    end
    if Won then
      game_music:stop()
      victory_music:setVolume(0.5)
      victory_music:play()
      love.graphics.draw(Victory)
      VictoryScreen = true
      Startmenu = false
      Instructions = false
      if VictoryScreen then
        local mousex, mousey = love.mouse.getPosition()
        print (mousex,mousey)
        if mousex > 593 and mousex < 892 and  mousey > 354 and mousey < 474 then
          if love.mouse.isDown(1) then
            victory_music:stop()
            VictoryScreen = false
            Startmenu = true
            Startgame = false
          end
        elseif mousex > 593 and mousex < 892 and  mousey > 505 and mousey < 624 then
          if love.mouse.isDown(1) then
            love.event.quit()
          end
        end
      end
    end 
  end
end


function love.mousepressed(x, y, button)

    if (x >= 162 and x <= 402 and y >= 375 and y <= 475) and (button == 1) then      
        Instructions = true
      end
    end


