# enemy.ls

# [Tank]
# width: 48, height: 24, hp: 100
# accel: 0.2, brake: -0.5, speed-max: 3, yaw-max: 10
# turret.yaw-max: 30, gun-wait: 60, missile-wait: 300
# [ComCommander]
# move-rate: 0.05, gun-rate: 0.05, missile-rate: 0.02
# [Shell] shell.
# width: 10, height: 4, speed: 12, damage: 25
# [Missile] missile.
# width: 12, height: 4, speed: 2, accel: 0.2, speed-max: 8, yaw-max: 0.6
# seek-start: 30, seek-angle: 45, damage: 50
export enemies =
  light-w:
    width: 40, height: 20, hp: 25
    gun-wait: 45, speed-max: 3.2, missile-rate: 0
    turret: barrel-length: 1.0
    shell: width: 8, height: 3, damage: 10
    score: 10

  light-s:
    width: 40, height: 20, hp: 50, accel: 0.3, speed-max: 3.5, yaw-max: 12
    gun-wait: 30, move-rate: 0.1, gun-rate: 0.08
    turret: barrel-length: 1.0
    shell: width: 8, height: 3, damage: 15
    missile: width: 10, height: 3, yaw-max: 0.5, seek-angle: 30, damage: 30
    score: 20

  middle-w:
    hp: 75, speed-max: 2.5, yaw-max: 8, missile-rate: 0
    shell: speed: 10, damage: 20
    score: 20

  middle-s:
    hp: 100, move-rate: 0.1, gun-rate: 0.08
    score: 30

  heavy-w:
    width: 56, height: 28, hp: 125, accel: 0.1, speed-max: 2.5, yaw-max: 6
    gun-wait: 90, missile-wait: 450
    turret: yaw-max: 10
    shell: speed: 10
    missile: yaw-max: 0.5, seek-angle: 30
    score: 30

  heavy-s:
    width: 56, height: 28, hp: 150, accel: 0.1, speed-max: 2.8, yaw-max: 8
    move-rate: 0.1, gun-rate: 0.08, missile-rate: 0.08
    turret: yaw-max: 15
    shell: speed: 10, damage: 35
    missile: damage: 60
    score: 50

  fortress-w:
    width: 80, height: 40, hp: 200, accel: 0.1, speed-max: 1.5, yaw-max: 5
    turret: yaw-max: 5
    shell: width: 12, height: 6, speed: 8, damage: 40
    missile:
      width: 16, height: 6
      speed-max: 6, yaw-max: 0.4, seek-angle: 30, damage: 80
    score: 100

  fortress-s:
    width: 80, height: 40, hp: 400, accel: 0.1, speed-max: 2, yaw-max: 5
    gun-wait: 30, missile-wait: 150
    move-rate: 0.1, gun-rate: 0.08, missile-rate: 0.08
    turret: yaw-max: 8
    shell: width: 16, height: 6, speed: 10, damage: 40
    missile: width: 16, height: 6, speed-max: 6, damage: 80
    score: 200

  missiler-w:
    hp: 25, speed-max: 2, yaw-max: 5, missile-wait: 90, gun-rate: 0
    turret: yaw-max: 4, barrel-length: 0.1
    missile: yaw-max: 0.5, seek-angle: 30
    score: 10

  missiler-s:
    hp: 30, speed-max: 2.5, yaw-max: 8
    missile-wait: 90, move-rate: 0.1, gun-rate: 0, missile-rate: 0.08
    turret: yaw-max: 6, barrel-length: 0.1
    missile: width: 16, height: 6, yaw-max: 0.8, damage: 80
    score: 15
