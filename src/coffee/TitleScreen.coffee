class TitleScreen extends ImageView
  init: (opts)->
    opts = merge opts,
      x: 0
      y: 0
      image: 'resources/images/title_screen.png'
    super opts


    startbutton = new View
      superview: @
      x: 0
      y: 0
      width: 300
      height: 300
      zIndex: 100
      backgroundColor = '#008a42'

    startbutton.on 'InputSelect', =>
      @emit 'startGame'

    @
