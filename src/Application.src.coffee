### silents unneeded errors
^((?!//@ sourceURL).)+$
###

`
import ui.View as View;
import ui.StackView as StackView;
import ui.ImageView as ImageView;
import ui.TextView as TextView;
import ui.ViewPool as ViewPool;
import ui.resource.Image as Image;
import ui.ParticleEngine as ParticleEngine;

import math.geom.intersect as intersect;
import math.geom.Rect as Rect;
import math.geom.Vec2D as Vec2D;
import math.geom.Point as Point;

import device;
import animate;
import AudioManager;
`

c = console; c.l = c.log

radToXy = (rad, speed)->
  x: Math.cos(rad)*(speed||1)
  y: Math.sin(rad)*(speed||1)

class MainApp extends GC.Application
  initUI: ->
    c.l 'init'
    @engine.updateOpts showFPS: true
    @style.backgroundColor = '#ff0000'

    titleScreen = new TitleScreen
    gameScreen = new GameScreen

    rootView = new StackView
      superview: @
      x: 0
      y: 0
      width: 1080
      height: 1920
      clip: true
      scale: device.width / 1080
      backgroundColor: '#00ff00'

    rootView.push titleScreen

    sound = audioManager

    titleScreen.on 'startGame', ->
      sound.play 'levelmusic'
      rootView.push gameScreen
      #gamescreen.emit 'app:start'

    titleScreen.emit 'startGame'

    @

  launchUI: -> return


`exports = MainApp`

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

class Btn extends ImageView
  init: (opts) ->
    options = merge opts,
      autoSize: true
      image: "resources/images/arcadeParts/"+opts.name+".png"
    super options
    @name = opts.name

    @on 'InputStart', ->
      @[@name] = true
      @style.opacity = 0
    @on 'InputSelect', ->
      @[@name] = false
      @style.opacity = 1
    @on 'InputOut', ->
      @[@name] = false
      @style.opacity = 1
    @

initBtns = ->
  @_btn_attack_view = new Btn
    superview: @
    name: 'btn_attack'
    x: 830
    y: 1030
  @_btn_turbo_view = new Btn
    superview: @
    name: 'btn_turbo'
    x: 650
    y: 1090
  @_btn_rotate_left_view = new Btn
    superview: @
    name: 'btn_rotate_left'
    x: 90
    y: 1030
  @_btn_rotate_right_view = new Btn
    superview: @
    name: 'btn_rotate_right'
    x: 270
    y: 1090

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

class Particles extends ParticleEngine
  init: (opts) ->
    opts = merge opts,
      width: 1
      height: 1
      initCount: 1000

    super opts

class Player extends ImageView
  init: (opts) ->
    opts = merge opts,
      x: 370-25
      y: 370-25
      dx: 1
      dy: 3
      width: 50
      height: 50
      anchorX: 25
      anchorY: 25
      opacity: 1
      image: "resources/images/player.png"
      #autoSize: true

    super opts

    @velocity = 0
    @maxVelocity = Math.PI/32
    @velocityInc = Math.PI/1024
    @velocityDec = 0.9

    @bullets = new GunBullets
    @enemys = new Enemys

    @particles = new Particles superview: @__parent

    @throwParticles = (view, len)=>
      len = len||10
      particleObjects = @particles.obtainParticleArray(len)
      while len--
        pObj = particleObjects[len]
        pObj.dx = 200 - Math.random() * 400
        pObj.dy = 200 - Math.random() * 400
        pObj.scale = 25
        pObj.dscale = -25
        pObj.opacity = 1
        pObj.dopacity = -1
        pObj
        pObj.x = view.style.x
        pObj.y = view.style.y

        pObj.image = 'resources/images/player.png'

      @particles.emitParticles particleObjects




    @shootGun = =>
      bullet = @bullets.obtainView()

      bullet.velocity =
        new Vec2D angle: @style.r, magnitude: 2

      xy = new Point(
        x:@style.width/2+bullet.style.height/2, y:0
      ).rotate @style.r

      bullet.updateOpts
        superview: @__parent
        x: 370-bullet.style.width/2+xy.x
        y: 370-bullet.style.height/2+xy.y
        visible: true
        r: @style.r

      bullet.tick = =>
        @enemys.forEachActiveView((enemy)->
          if intersect.rectAndRect(enemy.getBoundingShape(),bullet.getBoundingShape())
            @enemys.releaseView enemy
            @bullets.releaseView bullet
            @throwParticles enemy
        , @)
        bullet.style.x += bullet.velocity.x
        bullet.style.y += bullet.velocity.y
        if bullet.style.y<-bullet.style.width||bullet.style.y>740||bullet.style.x<-bullet.style.width||bullet.style.x>740
          @bullets.releaseView bullet


    @placeEnemy = =>
      enemy = @enemys.obtainView()

      enemy.updateOpts
        superview: @__parent
        x: Math.random()*740
        y: -enemy.style.height
        visible: true
        r: @style.r

      animate(enemy).now(
        x: 370-enemy.style.width/2, y:370-enemy.style.height/2
        5000
      ).then(=> @enemys.releaseView(enemy) )



    @t = 0

    @tick = (dt)=>
      # @getBoundingShape()
      @particles.runTick(dt)
      @style.r += .07
      if (@t++)%4==0 then @shootGun()
      if @t%15==0 then @placeEnemy()


    @



audioManager = new AudioManager
  path: 'resources/sounds'
  files:
    levelmusic:
      path: 'music'
      volume: 0.5
      background: true
      loop: true
    whack:
      path: 'effect'
      background: false


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
