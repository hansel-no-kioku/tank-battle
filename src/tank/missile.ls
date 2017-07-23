# missile.ls

require! {
  phina: {display, geom}
  '../util/calc': {nrm-yaw}
  '../ex/shadowedrectangle': {ShadowedRectangle}
  '../ex/motion': {Motion}
  '../ex/particle': {Particle}
  './explosion': {Explosion}
}

export class Missile extends ShadowedRectangle
  (params) ~>
    @_ = ^^ @_default <<<< params
    super @_

    display.CircleShape {
      fill: \#f93 radius: @height, alpha: 0.9, stroke: false}
      .add-child-to @
      .set-position -@width / 2, 0
      .tweener
        .to {radius: @height * 1.5, alpha: 0.1}, 100
        .to {radius: @height, alpha: 0.9}, 100
        .setLoop true
    {@side} = @_
    @_seek-count = @_.seek-start
    @motion = Motion(@_).attach-to @

    @on \move ->
      @parent.children.some (e) ~>
        if not (e.permeable or e.side is @_.side) and @hit-test-element e
          e.damaged? @_.damage
          @_explosion!
          true
        else
          false

  update: (app) ->
    if @parent?
      rate = app.delta-time * 30 / 1000
      if @_seekCount > 0
        @_seekCount -= rate
      else
        @_maneuver @_seek!
      @_smoke rate

  damaged: -> @_explosion!

  _seek: ->
    [target, yaw-min, angle-min] = [null, 0, 180]
    for e in @parent.children when e.is-heated?! and e.side isnt @_.side
      rotation = geom.Vector2.sub(e.position, @position).to-angle!.to-degree!
      yaw = nrm-yaw rotation - @rotation
      angle = Math.abs yaw
      if angle <= @_.seek-angle and angle < angleMin
        [target, yaw-min, angle-min] = [e, yaw, angle]
    return yaw-min

  _maneuver: (yaw) -> @motion.yaw = yaw

  _smoke: (rate) ->
    if @_.smoke-rate * rate >= Math.random!
      Particle do
        fill: \white radius: 2, jitter: 0.5
        animation: [to: {radius: @height * 3, alpha: 0}, duration: 1000]
      .set-position @x, @y
      .add-child-to @parent

  _explosion: ->
    Explosion 30, 250
      .set-position @x, @y
      .add-child-to @parent
    @remove!

  _default:
    width: 12, height: 4, stroke: false
    smoke-rate: 0.5, resolution: 5, side: \enemy
    speed: 2, accel: 0.2, speed-max: 8, yaw-max: 0.7
    seek-start: 30, seek-angle: 45, damage: 50
