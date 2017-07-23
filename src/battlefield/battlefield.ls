# battlefield.ls

require! {
  phina: {display, geom}
  '../util/object2d': {set-origin2}
  '../tank/tank': {Tank}
  './wall': {Wall}
}

export class BattleField extends display.RectangleShape
  (params) ~>
    @init {fill: \#db8 stroke: false, padding: 0} <<<< params

    wall = 20

    [xmax, ymax] = [@width / 2, @height / 2]
    [field-x-max, field-y-max] = [xmax - wall, ymax - wall]
    [wall-x, wall-y] = [xmax - wall / 2, ymax - wall / 2]

    [field-width, field-height] = [@width, @height].map (v) -> v - wall * 2

    # field
    @enemy-field = geom.Rect do
      -field-x-max, -field-y-max, field-width, field-y-max - wall / 2
    (@my-field = @enemy-field.clone!).y += field-y-max + wall / 2

    [@my-field, @enemy-field].each (f) ~>
      display.RectangleShape do
        width: f.width, height: f.height
        fill: \#ec9 stroke: false, padding: 0
      .add-child-to @
      .set-position f.center-x, f.center-y
      .permeable = true

    # wall 影のため左上から
    @add-child Wall y: -wall-y, width: @width, height: wall
    @add-child Wall x: -wall-x, width: wall, height: field-height

    [bar-num, bar-rate] = [5, 0.8]
    bar-len = field-width * bar-rate / (bar-rate * bar-num + bar-num - 1)
    len = bar-len * (1 + 1 / bar-rate)
    bar-num.times (i) ~>
      Wall do
        x: -field-x-max + bar-len / 2 + len * i
        width: bar-len, height: wall, hp: 200
      .add-child-to @

    @add-child Wall x: wall-x, width: wall, height: field-height
    @add-child Wall y: wall-y, width: @width, height: wall

    @_enemy-num = 0

    @on \killed (e) ->
      if e.tank.side is \me
        @parent.flare \defeated
      else
        @parent.flare \score score: e.tank.score ? 0
        @parent.flare \win if (@_enemy-num -= 1) <= 0

  add-tank: (tank) ->
    tank.add-child-to @
    if tank.side is \me
      tank.set-position @my-field.center-x, @my-field.center-y
        .set-rotation -90
      @_my-tank = tank
    else
      tank.set-position @_enemy-x!, @enemy-field.center-y
        .set-rotation 90
      @_enemy-num += 1
    @

  white-in: (func) ->
    {x, y, origin-x, origin-y} = @
    @_set-origin-my-tank!
    [preX, preY] = [@x, @y]
    @tweener
      .clear!
      .set {x, y, scale-x: 4, scale-y: 4, rotation: 360, alpha: 0}
      .wait 0 # ここで描画してから sleep
      .call ~>  @children.each (.sleep!)
      .to x:pre-x, y:pre-y, scale-x: 1 scale-y: 1 rotation: 0 alpha: 1,
        2000, \easeOutCubic
      .call ~>
        set-origin2 @, origin-x, origin-y
        @children.each (.wake-up!)
        func!

  white-out: (func) ->
    for tank in @children when tank instanceof Tank
      tank.escape-crew!
    {x, y} = @
    @tweener
      .clear!
      .wait 500
      .call ~> @_set-origin-my-tank!
      .to {x, y, scale-x: 4, scale-y: 4, rotation: 360, alpha: 0},
        2000, \easeInCubic
      .wait 500
      .call func

  _enemy-x: ->
    offset = ((@_enemy-num + 1) / 2).to-int! * 96
    @enemy-field.center-x + if @_enemy-num % 2 is 0 then offset else -offset

  _set-origin-my-tank: ->
    if @_my-tank?
      {x, y} = @
      origin-x = @_my-tank.x / @width + @origin-x
      origin-y = @_my-tank.y / @height + @origin-y
      set-origin2 @, origin-x, origin-y
    @
