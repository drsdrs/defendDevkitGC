class GunBullets extends ViewPool
  init: (opts) ->
    opts = merge opts,
      ctor: ImageView
      initCount: 250
      initOpts:
        width: 20
        height: 20
        anchorX: 10
        anchorY: 10
        image: "resources/images/player.png"

    super opts

# class Weapons extends View
#   init: (opts) ->
#     opts = merge opts,
#       width: 18
#       height: 18
