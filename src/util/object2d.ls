# object2d.ls

export set-origin2 = (o2d, x, y) ->
  dx = (x - o2d.origin-x) * o2d.width
  dy = (y - o2d.origin-y) * o2d.height
  o2d.set-origin x, y
  o2d.x += dx
  o2d.y += dy
  for c in o2d.children when c.x? and c.y?
    c.x -= dx
    c.y -= dy
