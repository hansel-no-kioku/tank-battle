# motion.ls

require! {
  phina: {accessory, geom}:
}

export class Motion extends accessory.Accessory
  (options) ~>
    @_ = ^^ @_default <<<< options
    @init!

  update: (app) ->
    rate = app.delta-time * 30 / 1000
    @_.resolution.times ~>
      @_move rate if @target.parent

  _move: (rate) ->
    if @_.yaw != 0
      angle = @_.yaw * rate / @_.resolution
      @target.rotation += angle
      @target.flare \rotate {angle}

    if @_.accel != 0
      speed = @_.speed + @_.accel * rate / @_.resolution
      @_.speed = Math.clamp speed, @_.speed-min, @_.speed-max

    if @_.speed != 0
      move = geom.Vector2!.from-degree do
        @target.rotation, @_.speed * rate / @_.resolution
      @target.position.add move
      @target.flare \move {move}

  accel:~
    -> @_.accel
    (accel) -> @_.accel = Math.clamp accel, @_.accel-min, @_.accel-max

  yaw:~
    -> @_.yaw
    (yaw) -> @_.yaw = Math.clamp yaw, - @_.yaw-max, @_.yaw-max

  _default:
    speed: 0, speed-min: 0, speed-maxm: 300,
    accel: 0, accel-min: -100, accel-max: 100
    yaw: 0, yaw-max: 100, resolution: 1
