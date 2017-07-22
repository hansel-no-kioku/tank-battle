# shadowsrectangle.ls

require! {
  phina: {display, geom}: phina
}

export class ShadowedRectangle extends display.RectangleShape
  (params) ~>
    @init params
    @shadow-offset-x = params.shadow-offset-x ? 0
    @shadow-offset-y = params.shadow-offset-y ? 0
    @_rotation = params.rotation ? 0
    # @shadow = false if phina.is-mobile!

  rotation:~
    -> @_rotation
    (rotation) ->
      unless @_rotation is rotation
        @_rotation = rotation
        if @shadow and not (@shadow-offset-x is 0 and @shadow-offset-y is 0)
          @_dirtyDraw = true

  prerender: (canvas) ->

  render-fill: (canvas) ->
    v = geom.Vector2 @shadow-offset-x, @shadow-offset-y
    rotation = get-parent-rotation @rotation, @parent
    v.rotate -rotation.to-radian! if v.length! > 0 and rotation isnt 0

    context = @canvas.context
    if @shadow
      context
        ..shadow-offset-x = v.x
        ..shadow-offset-y = v.y
        ..shadowColor = @shadow
        ..shadow-blur = @shadow-blur
    canvas.fill-round-rect do
      -@width / 2, -@height / 2, @width, @height, @corner-radius

  render-stroke: (canvas) ->
    canvas.stroke-round-rect do
      -@width / 2, -@height / 2, @width, @height, @corner-radius

  postrender: ->

get-parent-rotation = (rotation, element) ->
  if element?.rotation?
    rotation + get-parent-rotation element.rotation, element.parent
  else
    rotation
