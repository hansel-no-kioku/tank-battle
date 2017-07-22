# com-commander.ls

require! {
  phina: {accessory, geom}
  '../util/vector': {apply-margin}
}

export class ComCommander extends accessory.Accessory
  (@_my-field, @_enemy-field, @_enemy, params) ~>
    @_ = {move-rate: 0.05, gun-rate: 0.05, missile-rate: 0.02} <<<< params
    @init!

  update: (app) ->
    rate = app.delta-time * 30 / 1000

    if @_is-next-move rate
      x = Math.randint @_my-field.left, @_my-field.right
      y = Math.randint @_my-field.top, @_my-field.bottom
      margin = Math.max @target.width, @target.height
      @target.cmd-move apply-margin (geom.Vector2 x, y), @_my-field, margin

    if @_is-fire-gun rate
      @target.cmd-gun @_enemy.position
    else if @_is-fire-missile rate
      @target.cmd-missile @_enemy.position

  _is-next-move: (rate) ->
    not @target.moving! and Math.random! < @_.move-rate * rate

  _is-fire-gun: (rate) -> Math.random! < @_.gun-rate * rate

  _is-fire-missile: (rate) -> Math.random! < @_.missile-rate * rate
