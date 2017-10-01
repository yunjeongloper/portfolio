
BasicGame.MainMenu = function (game) {
  this.music = null;
  this.playButton = null;
};

BasicGame.MainMenu.prototype = {
	
	preload: function(){
		this.load.image('mainbg', 'assets/mainbg.jpg');
	},

  create: function () {
    this.add.sprite(0, 0, 'mainbg');
	this.timer = 0;
	this.style = { font: "27px Hanna", fill:'#A6A6A6', align: "center"};
    this.onclick = this.game.add.text(this.game.width / 2, 80, "게임을 시작하시려면 마우스 왼쪽 버튼을 눌러주세요", this.style);
    this.onclick.anchor.set(0.5, 0.5);
  },

  update: function () {
	  
	this.timer+= this.game.time.elapsed;
	
	if ( this.timer >= 500 ){
        this.timer -= 500;        
		this.onclick.visible = !this.onclick.visible;
	}
	
    if (this.input.activePointer.isDown) {
      this.startGame();
    }
  },

  startGame: function (pointer) {
    this.state.start('Game');
  }

};
