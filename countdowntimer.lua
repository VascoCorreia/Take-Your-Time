countdown = 20

function Countdown(dt)
  if countdown > 0 then
    countdown = countdown - dt
  end
 -- if countdown == 0 then
   -- countdown = 0
 -- end

end

function Drawtimer()
  love.graphics.setColor(1,1,1)
  love.graphics.setDefaultFilter("nearest", "nearest")
  local timerfont = love.graphics.newFont("edosz.ttf", 25)
  love.graphics.setFont(timerfont)
  local round = string.format("%.1f", countdown)
  love.graphics.print("time: " .. round, 60, 85)
end