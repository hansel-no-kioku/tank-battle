# tank.ls

require! {
  phina: {display, geom}
  '../util/calc': {nrm-yaw}
  '../ex/shadowedrectangle': {ShadowedRectangle}
  '../ex/motion': {Motion}
  '../ex/particle': {Particle}
  './turret': {Turret}
  './shell': {Shell}
  './missile': {Missile}
  './explosion': {Explosion}
}

export class Tank extends ShadowedRectangle
  (params) ~>
    @_ = ^^ @_default <<<< params
    super @_

    @motion = Motion(@_).attach-to @
    @{side, score} = @_
    @_hp = @_.hp
    [@_gun-wait, @_missile-wait] = [@_.gun-wait, @_.missile-wait]

    turret-params = @{
      width, height, fill, stroke, strokeWidth, shadow, shadowBlur
      shadowOffsetX, shadowOffsetY} <<<< @_.turret
    @_turret = Turret turret-params
      .setRotation 0
      .set-position @x, @y
      .add-child-to @

    @on \rotate (e) -> @_turret.rotate -e.angle

  update: (app) ->
    if @parent?
      rate = app.delta-time * 30 / 1000
      @_smoke rate
      @_drive!
      @_gun-wait -= rate if @_gun-wait > 0
      @_missile-wait -= rate if @_missile-wait > 0

  moving: -> @_target?

  entry: (field) ->
    field.add-tank @
    @

  damaged: (damage) ->
    if @_hp > 0
      @_hp -= damage
      @_killed! if @_hp <= 0

  cmd-move: (pos) ->
    unless @_target?.equals pos
      @_target = pos.clone!
      if @_.marker and @parent?
        @_marker?.remove!
        @_marker = display.CircleShape do
          radius: 2, fill: \#06f stroke: false, alpha: 0.7
        .set-position pos.x, pos.y
        .add-child-to @parent
        @_marker.tweener
          .set {radius: 2}
          .wait 0         # これを入れないと alpha → radius の順になる
          .set {alpha: 0.7}
          .to {radius: 12, alpha: 0}, 500
          .setLoop true

  cmd-gun: (pos) ->
    if @_gun-wait <= 0
      @_gun-wait = @_.gun-wait
      @_turret.fire-weapon pos, (pos, rotation) ~>
        @_fire Shell, pos, rotation, @_.shell

  cmd-missile: (pos) ->
    if @_missile-wait <= 0
      @_missile-wait = @_.missile-wait
      @_turret.fire-weapon pos, (pos, rotation) ~>
        @_fire Missile, pos, rotation, @_.missile

  escape-crew: ->
    @_clear-target!
    for a in @accessories when not (a instanceof Motion)
      a.remove!

  is-heated: -> true

  _clear-target: ->
    @_target = null
    if @_marker?
      @_marker.remove!
      @_marker = null

  _drive: ->
    [accel, yaw] = [@_.brake, 0]
    if @_target?
      if geom.Rect(@left, @top, @width, @height).contains @_target.x, @_target.y
        @_clear-target!
      else
        vect = geom.Vector2.sub @_target, @position
        yaw = nrm-yaw vect.to-angle!.to-degree! - @rotation
        accel = @_.accel if -60 < yaw < 60
    [@motion.accel, @motion.yaw] = [accel, yaw]

  _fire: (weapon, pos, rotation, params) ->
    weapon ^^params <<<< @{
      fill, padding, side
      shadow, shadow-blur, shadow-offset-x, shadow-offset-y}
      .set-position pos.x, pos.y
      .setRotation rotation
      .add-child-to @parent

  _smoke: (r) ->
    rate = 0.4
    if r * (1 - Math.sqrt(@_hp / @_.hp)) * rate > Math.random!
      Particle do
        fill: \grey radius: 2, direction: -45, speed: 1, jitter: 0.5
        animation: [to: {radius: 12, alpha: 0}, duration: 2000]
      .set-position @x, @y
      .add-child-to @parent

  _killed: ->
    @escape-crew!
    @tweener
      .wait 1000
      .call ~> @_explosion!
      .wait 300
      .call ~> @set-visible false
      .wait 200
      .call ~>
        @parent.flare \killed {tank: @}
        @remove!

  _explosion: ->
    Explosion 60, 500
      .set-position @x, @y
      .add-child-to @parent

  gun-rate:~
    -> (1 - @_gun-wait / @_.gun-wait) * 100

  missile-rate:~
    -> (1 - @_missile-wait / @_.missile-wait) * 100

  _default:
    width: 48, height: 24, padding: 8, stroke: \#333 stroke-width: 1
    shadow: 'rgba(0, 0, 0, 0.5)', shadow-blur: 4
    shadow-offset-x: 4, shadow-offset-y: 4
    hp: 100, side: \enemy marker: false
    speed-max: 3, yaw-max: 10, accel: 0.2, brake: -0.5
    gun-wait: 60, missile-wait: 300
