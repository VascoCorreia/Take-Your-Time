distance_traveled = 0
Won = false
function UpdateDistacetraveled(dt)
  
  if distance_traveled >= 300 then
    Won = true
    distance_traveled = 300
  elseif  distance_traveled <= 40 then
    distance_traveled = distance_traveled + (1.5 * dt)
  elseif  distance_traveled > 40 and  distance_traveled <= 120 then
    distance_traveled = distance_traveled + (2 * dt)
  elseif  distance_traveled > 120 and  distance_traveled < 300 then
    distance_traveled = distance_traveled + (3 * dt)
  end

  rounded_distance_traveled = math.floor(distance_traveled)


end


function DrawDistancetraveled()
  
  love.graphics.print("Distance traveled: " .. rounded_distance_traveled, 60,50 )
  
end