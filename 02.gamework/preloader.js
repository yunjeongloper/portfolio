
BasicGame.Preloader = function (game) {
  this.background = null;
  this.preloadBar = null;
};

BasicGame.Preloader.prototype = {

  preload: function () {
	
    this.stage.backgroundColor = '#2d2d2d';

    this.preloadBar = this.add.sprite(this.game.width / 2 - 100, this.game.height / 2, 'preloaderBar');
    this.add.text(this.game.width / 2, this.game.height / 2 - 30, "Loading...", { font: "32px monospace", fill: "#fff" }).anchor.setTo(0.5, 0.5);

    this.load.setPreloadSprite(this.preloadBar);

	this.load.image('spring', 'assets/Spring.jpg');

	this.load.image('cardbg', 'assets/cardback2.png');
	this.load.image('frame', 'assets/frame2.png');
	this.load.image('q0_card1', 'assets/의문의.jpg');
	this.load.image('q1_card1', 'assets/q1_card1.png');
	this.load.image('q2_card1', 'assets/q2_card1.JPG');
	this.load.image('q2_card2', 'assets/q2_card2.JPG');
	this.load.image('card3', 'assets/chindong.png');
	this.load.image('card4', 'assets/alba.png');
	this.load.image('q5_card1', 'assets/알바남.JPG');
	this.load.image('q7_card1', 'assets/gaepa.png');
	this.load.image('card6', 'assets/card_1.png');
	this.load.image('q8_card1', 'assets/chindong.png');
	this.load.image('q9_card1', 'assets/알바녀.JPG');
	this.load.image('q10_card1', 'assets/trophy.png');
	this.load.image('q11_card1', 'assets/jobyeol.png');
	this.load.image('q12_card1', 'assets/e12.png');
	this.load.image('q13_card1', 'assets/tattoo.png');
	this.load.image('q14_card1', 'assets/e14.png');
	this.load.image('q17_card1', 'assets/e17.png');
	this.load.image('q18_card1', 'assets/e19.png');
	this.load.image('q20_card1', 'assets/professor.png');
	
	this.load.image('moneylow','assets/e1.png');
	this.load.image('moneyhigh','assets/e2.png');
	this.load.image('lovelow','assets/e3.png');
	this.load.image('lovehigh','assets/e4.png');
	this.load.image('speclow','assets/e5.png');
	this.load.image('spechigh','assets/e7.png');
	this.load.image('byung','assets/e8.png');
	this.load.image('qnet','assets/e9.png');
	this.load.image('normal1','assets/e10.png');
	this.load.image('normal2','assets/e11.png');
	this.load.image('gover','assets/gover.png');
	
	this.load.audio('bgsound','assets/shiningstar.mp3');
	this.load.audio('normalbgm','assets/deepbreath.mp3');
	this.load.audio('flipsound','assets/flipsound.wav');

  },

  create: function () {
	this.preloadBar.cropEnabled = false;
	music=this.add.audio('bgsound');
	music.play();
  },

  update: function () {
    this.state.start('MainMenu');
  }

};
