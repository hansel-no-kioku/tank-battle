# main.ls

require! {
  phina: {game}: phina
  meta
  './scene/mainscene': {MainScene}
  './scene/titlescene': {MyTitleScene}
  './scene/resultscene': {MyResultScene}
}

# register scene classes
phina.global.MainScene = MainScene
phina.global.MyTitleScene = MyTitleScene
phina.global.MyResultScene = MyResultScene

scenes =
  * class-name: \MyTitleScene
    label: \title
    next-label: \main
  * class-name: \MainScene
    label: \main
    next-label: \result
  * class-name: \MyResultScene
    label: \result
    next-label: \title
    arguments:
      message: "#{meta.title}\nVersion #{meta.version}\n"
      timeout: 30

phina.main ->
  debug = window.location.hash is \#debug
  app = game.GameApp do
    start-label: \title
    fps: 60
    scenes: scenes
  app.enable-stats! if debug
  app.run!
