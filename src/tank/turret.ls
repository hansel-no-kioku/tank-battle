# turret.ls

require! {
  phina: {display, geom}
  '../util/calc': {nrm-yaw}
  '../util/vector': {rotate}
  '../ex/shadowedrectangle': {ShadowedRectangle}
}

export class Turret extends display.DisplayElement
  (params) ~>
    @_ = {corner-radius: 4, yaw-max: 30, barrel-length: 1.2} <<<< params
    @_.width = @_.height = Math.min(@_.width, @_.height) * 0.9
    @init @_

    barrel-params = @_ with {
      width: @width * @_.barrel-length, height: @height * 0.2
      corner-radius: 0}
    @_barrel = ShadowedRectangle barrel-params
    @_barrel
      .set-origin 0, 0.5
      .set-position @width / 2 - @_barrel.padding, 0
      .add-child-to @

    ShadowedRectangle @_
      .set-position 0, 0
      .add-child-to @

  update: (app) ->
    if @_target?
      yaw-max = @_.yaw-max * app.delta-time * 30 / 1000
      # BattleField の座標系で演算
      pos = @position.clone!.add @parent.position
      rotation = geom.Vector2.sub(@_target, pos).toAngle!.to-degree!
      yaw = nrm-yaw rotation - @rotation - @parent.rotation
      yaw2 = Math.clamp yaw, - yaw-max, yaw-max
      @rotate yaw2
      if yaw is yaw2
        m-pos = geom.Vector2 @_barrel.right, @_barrel.center-y
        muzzle-pos = rotate m-pos, (@rotation + @parent.rotation).to-radian!
        muzzle-pos.add @parent.position
        @_fireFunc? muzzle-pos, rotation
        @_target = @_fireFunc = null

  fire-weapon: (target, @_fire-func) -> @_target = target.clone!

  rotate: (angle) -> @rotation += angle
