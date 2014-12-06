(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
module.exports = {
  width: 540,
  height: 960,
  stage: {
    backgroundColor: 0xEEEEEE
  },
  images: {
    pixel: 'assets/img/pixel.png',
    wall: 'assets/img/wall.png'
  }
};


},{}],2:[function(require,module,exports){
var State, config,
  __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

config = require('./config.coffee');

State = (function() {
  function State() {
    this.jump = __bind(this.jump, this);
    this.switchGravity = __bind(this.switchGravity, this);
    this.isCharacterGravityInverted = __bind(this.isCharacterGravityInverted, this);
  }

  State.prototype.preload = function() {
    var imageName, path, _ref, _results;
    this.game.stage = $.extend(this.game.stage, config.stage);
    _ref = config.images;
    _results = [];
    for (imageName in _ref) {
      path = _ref[imageName];
      _results.push(this.game.load.image(imageName, path));
    }
    return _results;
  };

  State.prototype.create = function() {
    this.setUpGame();
    this.createCharacter();
    this.createCharacter2();
    return this.createWorld();
  };

  State.prototype.update = function() {
    if (this.character.body.velocity.y === 0) {
      this.character.body.velocity.y = 450;
    }
    this.character.isCharacterOnGround = false;
    if (this.character2.body.velocity.y === 0) {
      this.character2.body.velocity.y = 450;
    }
    this.character2.isCharacterOnGround = false;
    this.game.physics.arcade.collide(this.characters, this.normalPads, this.steadyBoy);
    this.game.physics.arcade.collide(this.characters, this.speedPads, this.speedUp);
    this.game.physics.arcade.collide(this.characters, this.slowPads, this.slowDown);
    if (this.character.body.position.y > this.character2.body.position.y) {
      this.game.camera.follow(this.character, Phaser.Camera.FOLLOW_PLATFORMER);
    } else {
      this.game.camera.follow(this.character2, Phaser.Camera.FOLLOW_PLATFORMER);
    }
    if (this.cursors.jump.isDown && this.character.isCharacterOnGround) {
      this.jump(this.character);
    }
    if (this.cursors["switch"].isDown && this.character.isCharacterOnGround) {
      this.switchGravity(this.character);
    }
    if (this.cursors2.jump.isDown && this.character2.isCharacterOnGround) {
      this.jump(this.character2);
    }
    if (this.cursors2["switch"].isDown && this.character2.isCharacterOnGround) {
      this.switchGravity(this.character2);
    }
    if (this.game.camera.view.y > this.character.body.position.y + 200 && !(this.character2.body.position.y === 0)) {
      this.resetGame();
      this.increaseScore(this.character2);
      console.log('Score:');
      console.log("Red: " + this.character2.score);
      console.log("Pink: " + this.character.score);
    }
    if (this.game.camera.view.y > this.character2.body.position.y + 200 && !(this.character.body.position.y === 0)) {
      this.resetGame();
      this.increaseScore(this.character);
      console.log('Score:');
      console.log("Red: " + this.character2.score);
      return console.log("Pink: " + this.character.score);
    }
  };

  State.prototype.render = function() {
    return this.game.debug.text(this.character.body.velocity, 32, 32);
  };

  State.prototype.test = function() {
    return console.log('test1');
  };

  State.prototype.speedUp = function(character) {
    character.isCharacterOnGround = true;
    if (character.body.velocity.y <= 1000) {
      return character.body.velocity.y += 30;
    }
  };

  State.prototype.slowDown = function(character) {
    character.isCharacterOnGround = true;
    if (character.body.velocity.y >= 300) {
      return character.body.velocity.y -= 20;
    }
  };

  State.prototype.steadyBoy = function(character) {
    character.isCharacterOnGround = true;
    if (character.body.velocity.y <= 650) {
      character.body.velocity.y += 10;
    }
    if (character.body.velocity.y >= 650) {
      return character.body.velocity.y -= 10;
    }
  };

  State.prototype.createCharacter = function() {
    this.character = this.game.add.sprite(220, 0, 'pixel');
    this.characters.add(this.character);
    this.game.physics.enable(this.character, Phaser.Physics.ARCADE);
    this.character.body.bounce.x = 0;
    this.character.body.collideWorldBounds = true;
    this.character.body.setSize(50, 50);
    this.character.isSwitchingGravity = false;
    this.character.body.gravity.x = 4000;
    this.character.body.gravity.y = 0;
    this.character.anchor.setTo(0.5, 0.5);
    this.character.tint = 0xFF6BD1;
    this.character.isCharacterOnGround = false;
    return this.character.score = 0;
  };

  State.prototype.createCharacter2 = function() {
    this.character2 = this.game.add.sprite(220, 0, 'pixel');
    this.characters.add(this.character2);
    this.game.physics.enable(this.character2, Phaser.Physics.ARCADE);
    this.character2.body.bounce.x = 0;
    this.character2.body.collideWorldBounds = true;
    this.character2.body.setSize(50, 50);
    this.character2.isSwitchingGravity = false;
    this.character2.body.gravity.x = -4000;
    this.character2.body.gravity.y = 0;
    this.character2.anchor.setTo(0.5, 0.5);
    this.character2.tint = 0xFF6B6B;
    this.character2.isCharacterOnGround = false;
    return this.character2.score = 0;
  };

  State.prototype.createWorld = function() {
    this.walls = this.game.add.group();
    this.numberOfPads = 20000 / 200;
    return this.setUpPads(this.numberOfPads);
  };

  State.prototype.isCharacterGravityInverted = function(character) {
    return character.body.gravity.x < 0;
  };

  State.prototype.switchGravity = function(character) {
    return character.body.gravity.x = -character.body.gravity.x;
  };

  State.prototype.jump = function(character) {
    if (this.isCharacterGravityInverted(character)) {
      return character.body.velocity.x = 1000;
    } else {
      return character.body.velocity.x = -1000;
    }
  };

  State.prototype.setUpGame = function() {
    this.game.world.setBounds(0, 0, 540, 20000);
    this.game.time.desiredFps = 60;
    this.game.physics.startSystem(Phaser.Physics.ARCADE);
    this.cursors = {
      jump: this.game.input.keyboard.addKey(Phaser.Keyboard.RIGHT),
      "switch": this.game.input.keyboard.addKey(Phaser.Keyboard.LEFT)
    };
    this.cursors2 = {
      jump: this.game.input.keyboard.addKey(Phaser.Keyboard.S),
      "switch": this.game.input.keyboard.addKey(Phaser.Keyboard.A)
    };
    return this.characters = this.game.add.group();
  };

  State.prototype.setUpPads = function(numberOfPads) {
    if (this.speedPads) {
      this.speedPads.destroy();
    }
    if (this.slowPads) {
      this.slowPads.destroy();
    }
    if (this.normalPads) {
      this.normalPads.destroy();
    }
    this.speedPads = this.game.add.group();
    this.slowPads = this.game.add.group();
    this.normalPads = this.game.add.group();
    this.speedPads.enableBody = true;
    this.slowPads.enableBody = true;
    this.normalPads.enableBody = true;
    this.walls.add(this.speedPads);
    this.walls.add(this.slowPads);
    this.walls.add(this.normalPads);
    this.addPads(numberOfPads);
    this.normalPads.setAll('body.immovable', true);
    this.speedPads.setAll('body.immovable', true);
    this.slowPads.setAll('body.immovable', true);
    this.normalPads.setAll('tint', 0xB0FF87);
    this.speedPads.setAll('tint', 0x9BD3FF);
    return this.slowPads.setAll('tint', 0xFFBC8E);
  };

  State.prototype.addPads = function(numberOfPads) {
    var addedLeftPads, addedRightPads, padTypes, _results;
    addedLeftPads = 0;
    addedRightPads = 0;
    padTypes = [this.normalPads, this.speedPads, this.slowPads];
    while (addedLeftPads !== numberOfPads) {
      this.game.add.sprite(0, addedLeftPads * 200, 'wall', 0, this.game.rnd.pick(padTypes));
      addedLeftPads += 1;
    }
    _results = [];
    while (addedRightPads !== numberOfPads) {
      this.game.add.sprite(490, addedRightPads * 200, 'wall', 0, this.game.rnd.pick(padTypes));
      _results.push(addedRightPads += 1);
    }
    return _results;
  };

  State.prototype.resetGame = function() {
    this.resetCharacters();
    return this.setUpPads(this.numberOfPads);
  };

  State.prototype.resetCharacters = function() {
    this.character.body.position.x = 220;
    this.character.body.position.y = 0;
    this.character.body.gravity.x = 4000;
    this.character.body.velocity.y = 0;
    this.character2.body.position.x = 220;
    this.character2.body.position.y = 0;
    this.character2.body.gravity.x = -4000;
    return this.character2.body.velocity.y = 0;
  };

  State.prototype.increaseScore = function(character) {
    return character.score += 1;
  };

  return State;

})();

module.exports = State;


},{"./config.coffee":1}],3:[function(require,module,exports){
var State, config;

State = require('./lib/state.coffee');

config = require('./lib/config.coffee');

$(document).ready(function() {
  var demo;
  demo = new Phaser.Game(config.width, config.height, Phaser.AUTO);
  return demo.state.add('game', State, true);
});


},{"./lib/config.coffee":1,"./lib/state.coffee":2}]},{},[3]);