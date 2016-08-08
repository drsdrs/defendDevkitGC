class GameScreen extends View
  init: (opts)->
    opts = merge opts,
      x: 0
      y: 0
      backgroundColor = '#FFFFFF'
    super opts

    @_top_arcade_view = new ImageView
      superview: @
      x:0
      y:0
      autoSize: true
      image: 'resources/images/arcadeParts/arcade_top.png'

    @_bottom_arcade_view = new ImageView
      superview: @
      x:0
      y:1280
      autoSize: true
      image: 'resources/images/arcadeParts/arcade_bottom.png'

    @_scoreboard = new TextView
      superview: @
      x: 20
      y: 20
      width: 1040
      height: 110
      autoSize: false
      autoFontSize: true
      fontFamily: 'slkscr'
      verticalAlign: 'middle'
      horizontalAlign: 'left'
      wrap: false
      color: '#FFFFFF'


    @_arcade_screen_view = new ArcadeScreenView superview: @

    @_player_view = new Player superview: @_arcade_screen_view



    bind(@, initBtns)()


    @tick = ->
      @_scoreboard.setText Date.now()

    @
