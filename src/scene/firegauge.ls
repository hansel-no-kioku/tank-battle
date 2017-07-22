# firegauge.ls

require! {
  phina: {display, ui, util}
}

export class FireGauge extends ui.Gauge
  (params) ~>
    @_ = ^^ @_default <<<< params
    @init @_

    @setBoundingType \circle
    @radius = @_.radius
    @alpha = @_.alpha if @_.alpha?
    @animation = false

    if @_.label
      @_label = display.Label font-size: @_.font-size, text: @_.label
        .add-child-to @
        .set-position 0, @height / 2 + 12

    @on \enterframe ->
      if @_.get-value?
        @value = Math.clamp @_.get-value!, 0, @max-value

      is-flashing = @is-full! and @_.is-flashing?!
      full-attr = if is-flashing and @_.flashing then @_.flashing else @_.full

      attr = if @is-full! then full-attr else @_.charging
      {@fill, @alpha} = attr
      @_label <<<< attr.label if attr.label?

      @flashing is-flashing

  flashing: (is-flashing) ->
    if is-flashing
      @_.flash-start @tweener unless @tweener.playing
    else
      @_.flash-stop @tweener if @tweener.playing

  prerender: ->

  render-fill: (canvas) ->
    canvas.rotate -Math.PI * 0.5
    start-angle = 0
    end-angle = Math.PI * 2 * @getRate!
    if @_.gauge-color
      canvas.context.fillStyle = @_.gauge-color
      canvas.fillCircle 0, 0, @radius
    canvas.context.fillStyle = @fill
    canvas.fillPie 0, 0, @radius, start-angle, end-angle

  render-stroke: (canvas) ->
    canvas.strokeCircle 0, 0, @radius

  _default:
    background-color: \transparent
    stroke: \#333 stroke-width: 2, radius: 24, gauge-color: \grey
    font-size: 24
    charging:
      fill: \red alpha: 0.5
      label: fill: \grey font-weight: '', shadow: false
    full:
      fill: \yellow alpha: 0.7
      label:
        fill: \yellow font-weight: \bold shadow: \black shadow-blur: 6
    flashing:
      fill: \#7f7 alpha: 0.7
      label:
        fill: \#7f7 font-weight: \bold shadow: \black shadow-blur: 12
    flash-start: (tweener) ->
      tweener
        .clear!
        .set scale-x: 1.0 scale-y: 1.0 alpha: 0.7
        .to scale-x: 1.5 scale-y: 1.5, alpha: 0.2, 500 util.Tween.ease-in-cubic
        .set-loop true
        .play!
    flash-stop: (tweener) ->
      tweener
        .clear!
        .set scale-x: 1.0 scale-y: 1.0 alpha: 0.7
        .play!

  postrender: ->
