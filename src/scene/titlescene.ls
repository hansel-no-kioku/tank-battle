# titlescene.ls

require! {
  phina: {display, game}
  meta
}

export class MyTitleScene extends game.TitleScene
  ~>
    @init title: meta.title, background-color: \#36f

    display.Label text: "Version #{meta.version}", fill: \white font-size: 32
      .add-child-to @
      .set-position this.grid-x.center!, this.grid-y.span(5)

    instruction.each (msg) ~>
      display.Label do
        text: msg.text, align: msg.align, fill: \white font-size: 32
      .add-child-to @
      .set-position this.grid-x.center!, this.grid-y.span(9)

instruction =
  * text: 'Move: \nGun: \nMissile: '
    align: \right
  * text: 'Touch\nTap Enemy\nLong Press'
    align: \left
