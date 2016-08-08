class ArcadeScreenView extends ImageView
  init: (opts)->
    opts = merge opts,
      superview: @
      x: 170
      y: 210
      width: 740
      height: 740
      backgroundColor: '#000000'
      clip: true

    super opts
