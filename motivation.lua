function Drawmotivation()

  love.graphics.setColor(0.286, 0.615, 0.223)
  love.graphics.rectangle("line", 60, 20, 300 , 23)
  love.graphics.rectangle("fill", 60, 20, 0 + distance_traveled, 23)
  love.graphics.setColor(0.764, 0.705, 0.215)
  love.graphics.print("MOTIVATION", 160,20,0,0.75,0.75)
  love.graphics.setColor(1,1,1)

end