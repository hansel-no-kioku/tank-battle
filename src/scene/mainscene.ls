
# mainscene.ls

require! {
  phina: {display, game}
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
    score ?= 0
    stage = if stage? then stage + 1 else 1
    stage-param = stages[(stage - 1) % stages.length]

    @_field = BattleField ({width, height} = @)
      .set-position @gridX.center!, @gridY.center!
      .add-child-to @
    {my-field, enemy-field} = @_field

    player-commander = PlayerCommander my-field, enemy-field

    my-tank = Tank {side: \me fill: \#00f marker: true}
      .entry @_field
      .attach player-commander

    stage-param.enemy.each (param, i) ~>
      Tank param with {side: \enemy fill: \#c00}
        .entry @_field
        .attach ComCommander enemy-field, my-field, my-tank, param

    @_scoreLabel = display.Label do
      font-size: 32, fill: \white shadow: \black shadow-blur: 6
      align: \left, text: score-text score
    .set-position 48, 48
    .add-child-to @

    @_gunGauge = FireGauge do
      label: \GUN get-value: -> my-tank.gun-rate
      is-flashing: -> player-commander.is-gun-ready!
    .set-position @width - 64 * 2, @height - 80
    .add-child-to @

    @_missileGauge = FireGauge do
      label: \MSSL get-value: -> my-tank.missile-rate
      is-flashing: -> player-commander.is-missile-ready!
    .set-position @width - 64, @height - 80
    .add-child-to @

    @_hide-overlay!

    @on \enter -> @app.push-scene StageTitleScene text: "STAGE #{stage}"

    @on \resume ({prev-scene}) ->
      if prev-scene instanceof StageTitleScene
        @_field.white-in ~> @_show-overlay!

    @on \blur ->  @app?.push-scene game.PauseScene!

    @on \score ({kill-score})->
      score += kill-score
      @_scoreLabel.text = score-text score

    @on \defeated ->
      unless @_finish
        @_finish = true
        @_hide-overlay!
        @_field.white-out ~> @exit {score}

    @on \win ->
      unless @_finish
        my-tank.permeable = true
        @_finish = true
        @_hide-overlay!
        @_field.white-out ~> @app.replace-scene MainScene {score, stage}

  _show-overlay: ->
    @_gunGauge?.show!
    @_missileGauge?.show!
    @_scoreLabel?.show!

  _hide-overlay: ->
    @_gunGauge?.hide!
    @_missileGauge?.hide!
    @_scoreLabel?.hide!

score-text = -> "score: #{it}"
