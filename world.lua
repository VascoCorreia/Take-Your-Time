-- Old functions I was using to generate the world
world = {}

function CreateObject(x, y, w, h)
  return {position = vector2.new(x, y), size = vector2.new(w, h)}
end

function LoadWorld()
  world[1] = CreateObject(0,0,1400,200) --teto
  world[2] = CreateObject(0,800-160,1400,160) --chao
end

function DrawWorld(world)
  for i = 1, table.getn(world), 1 do
    love.graphics.rectangle("fill", world[i].position.x, world[i].position.y, world[i].size.x, world[i].size.y)
  end
end

