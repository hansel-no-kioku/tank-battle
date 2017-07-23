
# mainscene.ls

require! {
  phina: {display, game}
  '../util/polyfill'
  '../commander/player-commander': {PlayerCommander}
  '../commander/com-commander': {ComCommander}
  '../tank/tank': {Tank}
  '../battlefield/battlefield': {BattleField}
  '../config/stage': {stages}
  './firegauge': {FireGauge}
  './stagetitlescene': {StageTitleScene}
}

export class MainScene extends display.DisplayScene
  ({score, stage}) ~>
    @init!

    @_score = score ? 0
    stage ?= 1
    stage-time = 10.9 + stage * 10

    @_field = BattleField ({width, height} = @)
      .set-position @gridX.center!, @gridY.center!
      .add-child-to @
    {my-field, enemy-field} = @_field

    player-commander = PlayerCommander my-field, enemy-field

    my-tank = Tank {side: \me fill: \#00f marker: true}
      .entry @_field
      .attach player-commander

    stages[(stage - 1) % stages.length].enemy.each (param, i) ~>
      Tank param with {side: \enemy fill: \#c00}
        .entry @_field
        .attach ComCommander enemy-field, my-field, my-tank, param

    @_score-label = display.Label do
      font-size: 32, fill: \white shadow: \black shadow-blur: 6
      align: \left, text: score-text @_score
    .set-position 40, 48
    .add-child-to @

    @_time-label = display.Label do
      font-size: 32, fill: \white shadow: \black shadow-blur: 6
      align: \right text: time-text stage-time
    .set-position @width - 40, 48
    .add-child-to @

    @_gun-gauge = FireGauge do
      label: \GUN get-value: -> my-tank.gun-rate
      is-flashing: -> player-commander.is-gun-ready!
    .set-position @width - 64 * 2, @height - 80
    .add-child-to @

    @_missile-gauge = FireGauge do
      label: \MSSL get-value: -> my-tank.missile-rate
      is-flashing: -> player-commander.is-missile-ready!
    .set-position @width - 64, @height - 80
    .add-child-to @

    @_hide-overlay!

    @on \enterframe ({app}) ->
      if not @_finish and stage-time > 0
        stage-time := Math.max 0, stage-time - app.delta-time / 1000
        @_time-label.text = time-text stage-time

    @on \enter -> @app.push-scene StageTitleScene text: "STAGE #{stage}"

    @on \resume ({prev-scene}) ->
      if prev-scene instanceof StageTitleScene
        @_field.white-in ~> @_show-overlay!

    @on \blur ->  @app?.push-scene game.PauseScene!

    @on \score ({score}) -> @_add-score score

    @on \defeated ->
      unless @_finish
        @_finish = true
        @_hide-overlay!
        @_field.white-out ~> @exit {score: @_score}

    @on \win ->
      unless @_finish
        my-tank.permeable = true

        @_stage-score (win-score stage), 300 0 1500
        @_stage-score (time-bonus stage, stage-time), 350 125 1500
        @_stage-score (repair-cost my-tank.damage!), 400 250 1500

        @_finish = true
        @_hide-overlay!
        @_field.white-out ~> @app.replace-scene MainScene do
          score: @_score, stage: stage + 1

  _add-score: (score) ->
    @_score = Math.max 0 @_score + score
    @_score-label.text = score-text @_score

  _show-overlay: ->
    @_gun-gauge?.show!
    @_missile-gauge?.show!
    # @_time-label?.show!

  _hide-overlay: ->
    @_gun-gauge?.hide!
    @_missile-gauge?.hide!
    # @_time-label?.hide!

  _stage-score: ({name, score, params}, y, delay, period) ->
    label = display.Label do
      {text: "#{name}: #{if score > 0 then \+ else ''}#{score}"
      font-size: 32, fill: \white shadow: \black shadow-blur: 8} <<<< params
    width = label.calcCanvasWidth!
    label
      .set-position @width + width, y
      .add-child-to @
      .tweener
        .wait delay
        .move-to -width, y, period, \easeOutInExpo
        .call ~> @_add-score score
        .play!

score-text = -> "Score: #{it}"

digit2 = -> (it + '').pad-start 2 \0

time-text = ->
  minute = Math.floor it / 60
  second = Math.floor it % 60
  "#{digit2 minute}:#{digit2 second}"

win-score = (stage) -> name: \Win score: stage * 10 params: {}

time-bonus = (stage, stage-time) ->
  score = Math.max 0, Math.floor stage-time * 2
  name: "Remaining Time" score, params: {}

repair-cost = (damage) ->
  score = - damage
  params = if score < 0 then {fill: \red} else {}
  {name: \Repair score, params}
