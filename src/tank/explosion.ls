# explosion.ls

require! {
  phina: {display}
}

export class Explosion extends display.CircleShape
  (size, duration) ~>
    @init fill: \#ff9 radius: 2, alpha: 0.9, stroke: false

    @permeable = true
    duration /= 2
    @tweener
      .to {radius: size / 2}, duration
      .to {radius: size, alpha: 0}, duration
      .call ~> @remove!
