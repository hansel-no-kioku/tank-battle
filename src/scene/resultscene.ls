# resultscene.ls

require! {
  phina: {game}
}

export class MyResultScene extends game.ResultScene
  (params) ~>
    @init params

    if params.timeout? > 0
      @_timer-id = do
        <~ set-timeout _, params.timeout * 1000
        @exit!

      @on \exit -> clear-timeout @_timer-id
