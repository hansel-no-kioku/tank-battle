# shell.ls

require! {
  '../ex/shadowedrectangle': {ShadowedRectangle}
  '../ex/motion': {Motion}
  './explosion': {Explosion}
}

export class Shell extends ShadowedRectangle
  (params) ~>
    @_ = ^^ @_default <<<< params
    super @_

    @permeable = true
    @motion = Motion(@_).attachTo @
    @on \move ->
      @parent.children.some (e) ~>
        if not (e.permeable or e.side is @_.side) and @hit-test-element e
          e.damaged? @_.damage
          Explosion 16, 200
            .set-position @x, @y
            .add-child-to @parent
          @remove!
          true
        else
          false

  _default:
    width: 10, height: 4, stroke: false
    resolution: 5, side: \enemy speed: 12, damage: 25
