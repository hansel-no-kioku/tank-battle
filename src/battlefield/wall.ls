# wall.ls

require! {
  '../ex/shadowedrectangle': {ShadowedRectangle}
}

export class Wall extends ShadowedRectangle
  (params) ~>
    p = {
      padding: 12 fill: \#777 stroke: false
      origin-x: 0.5 origin-y: 0.5 x: 0 y: 0
      shadow: 'rgba(0, 0, 0, 0.7)' shadow-blur: 12
      shadow-offset-x: 4 shadow-offset-y: 4
      } <<<< params
    super p

    @set-origin p.origin-x, p.origin-y
    @set-position p.x, p.y
    @_hp = @_hpMax = p.hp

  damaged: (damage) ->
    if @_hp?
      @_hp -= damage
      @alpha = Math.max @_hp / @_hpMax * 0.9 + 0.1, 0
      @remove! if @_hp <= 0
