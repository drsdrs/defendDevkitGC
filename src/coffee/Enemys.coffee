class Enemys extends ViewPool
  init: (opts) ->
    opts = merge opts,
      ctor: ImageView
      initCount: 250
      initOpts:
        width: 40
        height: 40
        anchorX: 20
        anchorY: 20
        image: "resources/images/player.png"

    super opts
