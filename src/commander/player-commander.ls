# player-commander.ls

require! {
  phina: {accessory}
  '../util/vector': {apply-margin}
}

export class PlayerCommander extends accessory.Accessory
  (@_my-field, @_enemyField) ~>
    @init!
    @_tap-time = 0

  update: (app) ->
    if app.pointer.get-pointing!
      @_last-pointer = @target.parent.global-to-local app.pointer.position

      if @_my-field.contains @_last-pointer.x, @_last-pointer.y
        margin = Math.max @target.width, @target.height
        @target.cmd-move apply-margin @_last-pointer, @_my-field, margin

      if @_enemy-field.contains @_last-pointer.x, @_last-pointer.y
        @_tap-time += app.delta-time
      else
        @_tap-time = 0

    else
      if 0 < @_tap-time
        if @_tap-time < @_long-press
          @target.cmd-gun @_last-pointer
        else
          @target.cmd-missile @_last-pointer

      @_tap-time = 0

  is-gun-ready: -> 0 < @_tap-time < @_long-press

  is-missile-ready: -> @_tap-time >= @_long-press

  _long-press: 500
