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
