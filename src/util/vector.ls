# vector.ls

require! {
  phina: {geom}
}

export apply-margin = (v, r, m) ->
  x = Math.clamp v.x, r.left + m, r.right - m
  y = Math.clamp v.y, r.top + m, r.bottom - m
  geom.Vector2 x, y

export rotate = (v, rad) ->
  len = v.length!
  geom.Vector2!.from-angle v.to-angle! + rad, len if len > 0
