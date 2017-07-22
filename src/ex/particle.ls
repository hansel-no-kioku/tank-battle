# particle.ls

require! {
  phina: {display, geom}
}

export class Particle extends display.CircleShape
  (params) ~>
    @_ = {
      stroke: false, direction: 0, speed: 0, jitter: 0
      animation: [to: {alpha: 0}, duration: 1000, easing: \default]
      } <<<< params
    @init @_

    @permeable = true

    @physical.velocity = geom.Vector2!.fromDegree @_.direction, @_.speed
      .add geom.Vector2!.random!.mul Math.random! * @_.jitter

    @_.animation.each (anime) ~>
      @tweener.to anime.to, anime.duration, anime.easing
    @tweener.call ~> @remove!
