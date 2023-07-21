
function restart()
  death_sound_timer = 2
  Collided_with_enemy = false
  poweruptimer = 25
  collectibletimer = 4
  PowerUp_isUp = 8
  Powerup_collected = false
  increase = false
  powerup_fontsize =  1
  countdown = 20
  distance_traveled = 0
  Enemy_timer = 3
  cooldown_up = false
  bulletcooldown = 0.75
  player.position.x = 100
  player.position.y = 800-(304+65)
  Pressure_fall = false
  Death_sound_once = true
  
  for k in pairs (Lazynumber) do
    Lazynumber[k] = nil
  end
  
  for k in pairs (Pressurenumber) do
    Pressurenumber[k] = nil
  end

  for k in pairs (Collectible) do
    Collectible[k] = nil
  end
  
  for k in pairs (bullets) do
    bullets[k] = nil
  end
  
  for k in pairs (Powerup) do
    Powerup[k] = nil
  end
  
end