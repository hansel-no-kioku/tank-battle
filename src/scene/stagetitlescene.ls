# stagetitlescene.ls

require! {
  phina: {display, game}
}

export class StageTitleScene extends display.DisplayScene
  (params) ~>
    p = {background-color: \grey font-color: \white font-size: 86}
      <<<< params
    @init p

    @_label = display.Label fill: \white font-size: p.font-size, text: p.text
      .set-position @grid-x.center!, @grid-y.center!
      .add-child-to @
    @_label.tweener
      .clear!
      .set scale-x: 0, scale-y: 0, alpha: 0
      .to {scale-x: 1, scale-y: 1, alpha: 1}, 250
      .wait 1000
      .to {scale-x: 2, scale-y: 2, alpha: 0}, 250
      .call ~> @app.pop-scene!

    @on \blur -> @app?.push-scene game.PauseScene!
