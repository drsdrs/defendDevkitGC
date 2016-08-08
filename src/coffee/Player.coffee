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


