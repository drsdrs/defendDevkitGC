
/* silents unneeded errors
^((?!//@ sourceURL).)+$
 */

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
;
var ArcadeScreenView, Btn, Enemys, GameScreen, GunBullets, MainApp, Particles, Player, TitleScreen, audioManager, c, initBtns, radToXy,
  extend = function(child, parent) { for (var key in parent) { if (hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; },
  hasProp = {}.hasOwnProperty;

c = console;

c.l = c.log;

radToXy = function(rad, speed) {
  return {
    x: Math.cos(rad) * (speed || 1),
    y: Math.sin(rad) * (speed || 1)
  };
};

MainApp = (function(superClass) {
  extend(MainApp, superClass);

  function MainApp() {
    return MainApp.__super__.constructor.apply(this, arguments);
  }

  MainApp.prototype.initUI = function() {
    var gameScreen, rootView, sound, titleScreen;
    c.l('init');
    this.engine.updateOpts({
      showFPS: true
    });
    this.style.backgroundColor = '#ff0000';
    titleScreen = new TitleScreen;
    gameScreen = new GameScreen;
    rootView = new StackView({
      superview: this,
      x: 0,
      y: 0,
      width: 1080,
      height: 1920,
      clip: true,
      scale: device.width / 1080,
      backgroundColor: '#00ff00'
    });
    rootView.push(titleScreen);
    sound = audioManager;
    titleScreen.on('startGame', function() {
      sound.play('levelmusic');
      return rootView.push(gameScreen);
    });
    titleScreen.emit('startGame');
    return this;
  };

  MainApp.prototype.launchUI = function() {};

  return MainApp;

})(GC.Application);

exports = MainApp;

ArcadeScreenView = (function(superClass) {
  extend(ArcadeScreenView, superClass);

  function ArcadeScreenView() {
    return ArcadeScreenView.__super__.constructor.apply(this, arguments);
  }

  ArcadeScreenView.prototype.init = function(opts) {
    opts = merge(opts, {
      superview: this,
      x: 170,
      y: 210,
      width: 740,
      height: 740,
      backgroundColor: '#000000',
      clip: true
    });
    return ArcadeScreenView.__super__.init.call(this, opts);
  };

  return ArcadeScreenView;

})(ImageView);

Btn = (function(superClass) {
  extend(Btn, superClass);

  function Btn() {
    return Btn.__super__.constructor.apply(this, arguments);
  }

  Btn.prototype.init = function(opts) {
    var options;
    options = merge(opts, {
      autoSize: true,
      image: "resources/images/arcadeParts/" + opts.name + ".png"
    });
    Btn.__super__.init.call(this, options);
    this.name = opts.name;
    this.on('InputStart', function() {
      this[this.name] = true;
      return this.style.opacity = 0;
    });
    this.on('InputSelect', function() {
      this[this.name] = false;
      return this.style.opacity = 1;
    });
    this.on('InputOut', function() {
      this[this.name] = false;
      return this.style.opacity = 1;
    });
    return this;
  };

  return Btn;

})(ImageView);

initBtns = function() {
  this._btn_attack_view = new Btn({
    superview: this,
    name: 'btn_attack',
    x: 830,
    y: 1030
  });
  this._btn_turbo_view = new Btn({
    superview: this,
    name: 'btn_turbo',
    x: 650,
    y: 1090
  });
  this._btn_rotate_left_view = new Btn({
    superview: this,
    name: 'btn_rotate_left',
    x: 90,
    y: 1030
  });
  return this._btn_rotate_right_view = new Btn({
    superview: this,
    name: 'btn_rotate_right',
    x: 270,
    y: 1090
  });
};

Enemys = (function(superClass) {
  extend(Enemys, superClass);

  function Enemys() {
    return Enemys.__super__.constructor.apply(this, arguments);
  }

  Enemys.prototype.init = function(opts) {
    opts = merge(opts, {
      ctor: ImageView,
      initCount: 250,
      initOpts: {
        width: 40,
        height: 40,
        anchorX: 20,
        anchorY: 20,
        image: "resources/images/player.png"
      }
    });
    return Enemys.__super__.init.call(this, opts);
  };

  return Enemys;

})(ViewPool);

GameScreen = (function(superClass) {
  extend(GameScreen, superClass);

  function GameScreen() {
    return GameScreen.__super__.constructor.apply(this, arguments);
  }

  GameScreen.prototype.init = function(opts) {
    var backgroundColor;
    opts = merge(opts, {
      x: 0,
      y: 0
    }, backgroundColor = '#FFFFFF');
    GameScreen.__super__.init.call(this, opts);
    this._top_arcade_view = new ImageView({
      superview: this,
      x: 0,
      y: 0,
      autoSize: true,
      image: 'resources/images/arcadeParts/arcade_top.png'
    });
    this._bottom_arcade_view = new ImageView({
      superview: this,
      x: 0,
      y: 1280,
      autoSize: true,
      image: 'resources/images/arcadeParts/arcade_bottom.png'
    });
    this._scoreboard = new TextView({
      superview: this,
      x: 20,
      y: 20,
      width: 1040,
      height: 110,
      autoSize: false,
      autoFontSize: true,
      fontFamily: 'slkscr',
      verticalAlign: 'middle',
      horizontalAlign: 'left',
      wrap: false,
      color: '#FFFFFF'
    });
    this._arcade_screen_view = new ArcadeScreenView({
      superview: this
    });
    this._player_view = new Player({
      superview: this._arcade_screen_view
    });
    bind(this, initBtns)();
    this.tick = function() {
      return this._scoreboard.setText(Date.now());
    };
    return this;
  };

  return GameScreen;

})(View);

Particles = (function(superClass) {
  extend(Particles, superClass);

  function Particles() {
    return Particles.__super__.constructor.apply(this, arguments);
  }

  Particles.prototype.init = function(opts) {
    opts = merge(opts, {
      width: 1,
      height: 1,
      initCount: 1000
    });
    return Particles.__super__.init.call(this, opts);
  };

  return Particles;

})(ParticleEngine);

Player = (function(superClass) {
  extend(Player, superClass);

  function Player() {
    return Player.__super__.constructor.apply(this, arguments);
  }

  Player.prototype.init = function(opts) {
    opts = merge(opts, {
      x: 370 - 25,
      y: 370 - 25,
      dx: 1,
      dy: 3,
      width: 50,
      height: 50,
      anchorX: 25,
      anchorY: 25,
      opacity: 1,
      image: "resources/images/player.png"
    });
    Player.__super__.init.call(this, opts);
    this.velocity = 0;
    this.maxVelocity = Math.PI / 32;
    this.velocityInc = Math.PI / 1024;
    this.velocityDec = 0.9;
    this.bullets = new GunBullets;
    this.enemys = new Enemys;
    this.particles = new Particles({
      superview: this.__parent
    });
    this.throwParticles = (function(_this) {
      return function(view, len) {
        var pObj, particleObjects;
        len = len || 10;
        particleObjects = _this.particles.obtainParticleArray(len);
        while (len--) {
          pObj = particleObjects[len];
          pObj.dx = 200 - Math.random() * 400;
          pObj.dy = 200 - Math.random() * 400;
          pObj.scale = 25;
          pObj.dscale = -25;
          pObj.opacity = 1;
          pObj.dopacity = -1;
          pObj;
          pObj.x = view.style.x;
          pObj.y = view.style.y;
          pObj.image = 'resources/images/player.png';
        }
        return _this.particles.emitParticles(particleObjects);
      };
    })(this);
    this.shootGun = (function(_this) {
      return function() {
        var bullet, xy;
        bullet = _this.bullets.obtainView();
        bullet.velocity = new Vec2D({
          angle: _this.style.r,
          magnitude: 2
        });
        xy = new Point({
          x: _this.style.width / 2 + bullet.style.height / 2,
          y: 0
        }).rotate(_this.style.r);
        bullet.updateOpts({
          superview: _this.__parent,
          x: 370 - bullet.style.width / 2 + xy.x,
          y: 370 - bullet.style.height / 2 + xy.y,
          visible: true,
          r: _this.style.r
        });
        return bullet.tick = function() {
          _this.enemys.forEachActiveView(function(enemy) {
            if (intersect.rectAndRect(enemy.getBoundingShape(), bullet.getBoundingShape())) {
              this.enemys.releaseView(enemy);
              this.bullets.releaseView(bullet);
              return this.throwParticles(enemy);
            }
          }, _this);
          bullet.style.x += bullet.velocity.x;
          bullet.style.y += bullet.velocity.y;
          if (bullet.style.y < -bullet.style.width || bullet.style.y > 740 || bullet.style.x < -bullet.style.width || bullet.style.x > 740) {
            return _this.bullets.releaseView(bullet);
          }
        };
      };
    })(this);
    this.placeEnemy = (function(_this) {
      return function() {
        var enemy;
        enemy = _this.enemys.obtainView();
        enemy.updateOpts({
          superview: _this.__parent,
          x: Math.random() * 740,
          y: -enemy.style.height,
          visible: true,
          r: _this.style.r
        });
        return animate(enemy).now({
          x: 370 - enemy.style.width / 2,
          y: 370 - enemy.style.height / 2
        }, 5000).then(function() {
          return _this.enemys.releaseView(enemy);
        });
      };
    })(this);
    this.t = 0;
    this.tick = (function(_this) {
      return function(dt) {
        _this.particles.runTick(dt);
        _this.style.r += .07;
        if ((_this.t++) % 4 === 0) {
          _this.shootGun();
        }
        if (_this.t % 15 === 0) {
          return _this.placeEnemy();
        }
      };
    })(this);
    return this;
  };

  return Player;

})(ImageView);

audioManager = new AudioManager({
  path: 'resources/sounds',
  files: {
    levelmusic: {
      path: 'music',
      volume: 0.5,
      background: true,
      loop: true
    },
    whack: {
      path: 'effect',
      background: false
    }
  }
});

TitleScreen = (function(superClass) {
  extend(TitleScreen, superClass);

  function TitleScreen() {
    return TitleScreen.__super__.constructor.apply(this, arguments);
  }

  TitleScreen.prototype.init = function(opts) {
    var backgroundColor, startbutton;
    opts = merge(opts, {
      x: 0,
      y: 0,
      image: 'resources/images/title_screen.png'
    });
    TitleScreen.__super__.init.call(this, opts);
    startbutton = new View({
      superview: this,
      x: 0,
      y: 0,
      width: 300,
      height: 300,
      zIndex: 100
    }, backgroundColor = '#008a42');
    startbutton.on('InputSelect', (function(_this) {
      return function() {
        return _this.emit('startGame');
      };
    })(this));
    return this;
  };

  return TitleScreen;

})(ImageView);

GunBullets = (function(superClass) {
  extend(GunBullets, superClass);

  function GunBullets() {
    return GunBullets.__super__.constructor.apply(this, arguments);
  }

  GunBullets.prototype.init = function(opts) {
    opts = merge(opts, {
      ctor: ImageView,
      initCount: 250,
      initOpts: {
        width: 20,
        height: 20,
        anchorX: 10,
        anchorY: 10,
        image: "resources/images/player.png"
      }
    });
    return GunBullets.__super__.init.call(this, opts);
  };

  return GunBullets;

})(ViewPool);

//# sourceMappingURL=Application.js.map
