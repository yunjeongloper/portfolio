BasicGame.Game = function (game) {

};

BasicGame.Game.prototype = {
	 	
	preload: function() {
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
		// 시작 시 화면 세팅
		this.setupBackground();
		this.q0_card1();
		this.choice=new Array();
		
		this.flipsound=this.add.audio('flipsound');
		
		// 마우스 커서 활성화
		this.cursors = this.input.keyboard.createCursorKeys();
		
		// 중력??? 활성화
		this.game.physics.startSystem(Phaser.Physics.ARCADE);
		
		this.govertxt = { font: "34px Hanna", fill:'#212121',align: "center"};

	},
	
	update: function () {
		// 카드는 좌,우로만 움직일수 있게 함
		this.input.activePointer.y = 400;
		this.card.rotation.x = this.physics.arcade.moveToPointer(this.card, 60, this.input.activePointer, 500);
		//커서를 오른쪽으로 움직였을 시 선택지(textno) 떠오르게 함
		if(this.textno.x<550)
			this.textno.visible=false;
		else
			this.textno.visible=true;
		this.textno.x = Math.floor(this.card.x/1.3 + this.card.width/1.2);
		this.textno.y = Math.floor(this.card.y/4 + this.card.height/1.1);
		//커서를 왼쪽으로 움직였을 시 선택지(textyes) 떠오르게 함
		if(this.textyes.x>250)
			this.textyes.visible=false;
		else
			this.textyes.visible=true;
		this.textyes.x = Math.floor(this.card.x/2+ this.card.width/5);
		this.textyes.y = Math.floor(this.card.y/4 + this.card.height/1.1);
		
		// normal ending 검사
		if(this.loveval<=0||this.loveval>=100||this.moneyval<=0||this.moneyval>=100||this.specval<=0||this.specval>=100){
			this.endingImage();
		}
	},
	endingImage: function(){
		if(this.loveval<=0){
			this.ending=this.add.sprite(this.game.width / 2, 300, 'lovelow');      
			this.end = this.game.add.text(this.game.width / 2, 470, "사랑이 부족한 당신은..GAVE OVER\nF5로 재시작 해주세요", this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		else if(this.loveval>=100){
			this.ending=this.add.sprite(this.game.width / 2, 300, 'lovehigh');
			this.end = this.game.add.text(this.game.width / 2, 470, "사랑이 너무나 넘쳐버린 당신은..GAVE OVER\nF5로 재시작 해주세요", this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		else if(this.moneyval<=0){
			this.ending=this.add.sprite(this.game.width / 2, 300, 'moneylow');
			this.end = this.game.add.text(this.game.width / 2, 470, "돈이 떨어진 당신은..GAVE OVER\nF5로 재시작 해주세요",this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		else if(this.moneyval>=100){
			this.ending=this.add.sprite(this.game.width / 2, 300, 'moneyhigh');
			this.end = this.game.add.text(this.game.width / 2, 470, "돈의 맛을 본 당신은..GAVE OVER\nF5로 재시작 해주세요", this.govertxt);
			this.end.anchor.set(0.5, 0.5);			
		}
		else if(this.specval<=0){
			this.ending=this.add.sprite(this.game.width / 2, 300, 'speclow');
			this.end = this.game.add.text(this.game.width / 2, 470, "학교 생활을 열심히 하지 않은 당신은..\nGAVE OVER..F5로 재시작 해주세요", this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		else if(this.specval>=100){
			this.ending=this.add.sprite(this.game.width /2, 300, 'spechigh');
			this.end = this.game.add.text(this.game.width / 2, 470, "졸업을 일찍 해버렸습니다..GAVE OVER\nF5로 재시작 해주세요",this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		else{
			this.ending=this.add.sprite(this.game.width /2, 300, 'normal1');
			this.end = this.game.add.text(this.game.width / 2, 470, "중견기업에 취직했습니다..사내연애는 보너스\n 재시작은 F5를 눌러주세요", this.govertxt);
			this.end.anchor.set(0.5, 0.5);
		}
		this.ending.anchor.setTo(0.5, 0.5);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.card.kill();
		music.stop();
		normalend=this.add.audio('normalbgm');
		normalend.play();		
		this.game.input.mouse.enabled = false;	
	},
	// 배경이 되는 이미지 셋팅
	setupBackground: function() {
		this.add.sprite(0,0,'spring');
		this.cardbg = this.add.sprite(this.game.width / 2, 400, 'cardbg');
		this.cardbg.anchor.setTo(0.5, 0.5);
		this.setupGauge();
		this.add.sprite(0,0,'frame');
		this.framebg = this.add.sprite(this.game.width / 2, this.game.height/2, 'frame');
		this.framebg.anchor.setTo(0.5, 0.5);
	},
	setupGauge: function(){
		var lovebg = {x: 287, y: 40, width: 60, height: 60};
		this.lovebar = new HealthBar(this.game, lovebg);
		this.loveval=50;
		this.lovebar.setPercent(this.loveval);
		
		var specbg = {x: 520, y: 40, width: 57, height: 60};
		this.specbar = new HealthBar(this.game, specbg);
		this.specval=50;
		this.specbar.setPercent(this.specval); 
		
		var moneybg = {x: 400, y: 40, width: 60, height: 60};
		this.moneybar = new HealthBar(this.game, moneybg);
		this.moneyval=50;
		this.moneybar.setPercent(this.moneyval); 
	},
	flip_ani: function(){
		var tween1 = this.game.add.tween(this.card.scale);
	    tween1.to({ x: 0 }, 300, Phaser.Easing.Linear.None, false, 0);
	    tween1.onComplete.addOnce(function (sprite, tween) {
			if(this.card.frame == 0)
	            this.card.frame = 1;
		    else
		        this.card.frame = 0;
	    }, this);
	    var tween2 = this.game.add.tween(this.card.scale);
	    tween2.to({ x: 1 }, 300, Phaser.Easing.Linear.None, false, 0);
	    tween1.chain(tween2);
	    tween1.start();	
	},
	/**********************************************************************************/
	q0_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard0_1, this);
		
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "25px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};

		this.textyes = this.game.add.text(0, 0, "???", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "누구세요?", this.style);
		this.textno.anchor.set(0.5);
		
		this.question = this.game.add.text(this.game.width/2, 190, "ㅇㅇ대학교 입학을 정말 축하해!\n나는 네가 정말 자랑스러워", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard0_1: function () {
		this.flip_ani();
		this.flipsound.play();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill0_1, this);
	},
	cardkill0_1: function(){
		this.card.kill();
		this.q0_card2();
		//this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q0_card2, this);
	},	
	
	q0_card2: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard0_2, this);
		
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "25px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};

		this.textyes = this.game.add.text(0, 0, "내가 ㅇㅇ대학교\n학생?", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "누구세요?", this.style);
		this.textno.anchor.set(0.5);
		
		this.question = this.game.add.text(this.game.width/2, 190, "무슨소리야! 아직도 정신을 못차렸니?\n내일부터는 대학생이라구!", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard0_2: function () {
		this.flip_ani();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill0_2, this);
	},
	cardkill0_2: function(){
		this.card.kill();
		this.q0_card3();
	},
	
	q0_card3: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard0_3, this);
		
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "20px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};

		this.textyes = this.game.add.text(0, 0, "이렇게\n하는건가?", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "누구세요?", this.style);
		this.textno.anchor.set(0.5);
		
		this.question = this.game.add.text(this.game.width/2, 190, "너는 앞으로 많은 문제에 부딪히게 될거야 그 문제에 어떻게 대답하느냐에 따라서 네 인생이 바뀔거라구!", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard0_3: function () {
		this.flip_ani();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill0_3, this);
	},
	cardkill0_3: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q0_card4, this);
	},
	
	q0_card4: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard0_4, this);
		
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "25px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};

		this.textyes = this.game.add.text(0, 0, "드디어\n시작인가!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "누구세요?", this.style);
		this.textno.anchor.set(0.5);
		
		this.question = this.game.add.text(this.game.width/2, 190, "정말 잘했어! 그럼 이제부터 ㅇㅇ대학교 학생으로서 열심히 지내보라구!", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard0_4: function () {
		this.flip_ani();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill0_4, this);
	},
	cardkill0_4: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q1_card1, this);
	},
	
	/**********************************************************************************/
	q1_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q1_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard1_1, this);
		
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};

		this.textyes = this.game.add.text(0, 0, "새로운 친구도 만나고!\n술도 먹고 1석 2조지!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "복잡한 곳은 가고싶지 않아..", this.style);
		this.textno.anchor.set(0.5);
		
		this.question = this.game.add.text(this.game.width/2, 190, "이번주에 OO대 PP과 신입생 환영회 있는거 아시죠? 참석 안하시면 학교생활 적응하기 힘들어요~", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard1_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-10;
			this.moneybar.setPercent(this.moneyval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+10;
			this.moneybar.setPercent(this.moneyval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill1_1, this);
	},
	cardkill1_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q2_card1, this);
	},
	
	q2_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q2_card2');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard2_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "40px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0,  "제가 왜요?", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0,"좋아요!", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "주인공아! 나랑 벚꽃보러 가자!", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard2_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-10;
			this.lovebar.setPercent(this.loveval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill2_1, this);
	},
	cardkill2_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q3_card1, this);
	},	
	
	q3_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'card4');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard3_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래! 지금 당장 연락하자!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "\n나 혼자 공부하기도 벅찬데.. 무슨..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "학과 홍보 게시판에 스터디를 모집한다는 글이 적혀있다. 새로운 사람도 만나고 성적과 스펙도 올려볼까?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard3_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.specval=this.specval+15;
			this.specbar.setPercent(this.specval);
			this.moneyval=this.moneyval+10;
			this.moneybar.setPercent(this.moneyval);
		}
		else if(this.input.mousePointer.x>400){
			this.specval=this.specval-15;
			this.specbar.setPercent(this.specval);
			this.moneyval=this.moneyval+10;
			this.moneybar.setPercent(this.moneyval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill3_1, this);
	},
	cardkill3_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q4_card1, this);
	},
	q4_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'card4');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard4_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래 해보자! 돈도 벌고 사람도 만나고!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "학생의 본분은 공부일 지어니..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "요즘 소비량이 너무 많이 늘었다.. 알바라도 해야하나? 집 근처 식당에서 서빙알바? 시급도 괜찮은데..?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard4_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.moneyval=this.moneyval+12;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-10;
			this.specbar.setPercent(this.specval);
			this.choice[4]='0';
		}
		else if(this.input.mousePointer.x>400){
			this.moneyval=this.moneyval-23;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+10;
			this.specbar.setPercent(this.specval);
			this.choice[4]='1';
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill4_1, this);
	},
	cardkill4_1: function(){
		this.card.kill();
		if(this.choice[4]=='0')
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q5_card1, this);
		else
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q6_card1, this);
	},
	
	q5_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q5_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard5_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "30px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "ㅇㅇ아..누나도 사실 나도 너를..", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "나무아미타불 관세음보살..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "누나 저.. 누나가 너무 좋아요 누나 저랑 사귀어 주시겠어요?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard5_1: function () {
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneybar.setPercent(this.moneyval);
			this.specbar.setPercent(this.specval);
			this.goback=0;
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-10;
			this.lovebar.setPercent(this.loveval);
			this.moneybar.setPercent(this.moneyval)
			this.specbar.setPercent(this.specval);
			this.goback=1;
		}
		this.flip_ani();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill5_1, this);
	},
	cardkill5_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q6_card1, this);
	},	
	
	q6_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'card4');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard6_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "25px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "지금 당장 출발하자!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "근데 너무 멀다..귀찮아..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "OO대학교 봉사활동? 그래 봉사활동으로 보람도 느끼고 스펙도 쌓아볼까?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard6_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-10;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+10;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-10;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-10;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill6_1, this);
	},
	cardkill6_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q7_card1, this);
	},	
	
	q7_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q7_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard7_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "38px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래 오랜만에 동기들도 보고!\n정말 재밌게 놀아보자!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "내일 수강신청인데 무슨\n사자가 풀뜯어먹는 소리야..?", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "어, 과대님한테 카톡이 왔네?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard7_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-3;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-10;
			this.specbar.setPercent(this.specval);
			this.choice[7]='1';
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+10;
			this.specbar.setPercent(this.specval);
			this.choice[7]='0';
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill7_1, this);
	},
	cardkill7_1: function(){
		this.card.kill();
		if(this.choice[7]=='1'){
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q8_card1, this);
		}
		else{
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q9_card1, this);
		}
	},	
	
	q8_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q8_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard8_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "26px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "이런 자리에 이 몸이 빠질수 없지! ", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "미안 나 조금 아플 예정이라서...", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "아이고 머리야 어제 몇시에 들어갔지..근데 무슨 단톡에 초대가 됐네?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard8_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-4;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-10;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+15;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+10;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill8_1, this);
	},
	cardkill8_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q9_card1, this);
	},	
	
	q9_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q9_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard9_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "23px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "역시 좋아하는 것 같다", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "아니야 그럴리가 없어", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "평소에 친하게 지내던 동기..어느날부터 계속 눈앞에 아른아른 거린다..내 마음은 뭘까?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard9_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-13;
			this.lovebar.setPercent(this.loveval);
			this.moneybar.setPercent(this.moneyval);
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-2;
			this.lovebar.setPercent(this.loveval);
			this.moneybar.setPercent(this.moneyval);
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill9_1, this);
	},
	cardkill9_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q10_card1, this);
	},	
	
	q10_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q10_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard10_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래 내 실력을 보여주지!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "벤치에서 열심히 응원할게요!", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "이번주는 체육대회인거 다들 아시죠? 이번에 꼭 출전해서 우승은 우리과라는 것을 알려줘야 한다구!", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard10_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-15;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+12;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-13;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+3;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+8;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-3;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill10_1, this);
	},
	cardkill10_1: function(){
		this.card.kill();
		/*if(this.choice[1]=='1'){
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q0_card5, this);
		}
		else{
			this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q1_card1, this);
		}*/
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q11_card1, this);
	},	
	
	q11_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q11_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard11_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "29px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "ㄱ...괜찮아요.. 제..제가 할게요...", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "네 괜찮아요 이름 다 빼고 제가 할게요.", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "교양 조별과제 발표 날이 다가온다. 어떻게 해야할까", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard11_1: function () {
		this.flip_ani();
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill11_1, this);
	},
	cardkill11_1: function(){
		this.card.kill();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-3;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+1;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-5;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+1;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-5;
			this.specbar.setPercent(this.specval);
		}
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q12_card1, this);
	},	
	
	q12_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q12_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard12_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "30px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래! 빨리 준비하자!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "듣는다고 크게 바뀌는 건 없을것 같다..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "한 것도 없는데 벌써.. 취업 동아리라도 들을까?", this.style_q);
		this.question.anchor.set(0.5);
	},
	
	flipCard12_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+15;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-5
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+5;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill12_1, this);
	},
	cardkill12_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q13_card1, this);
	},	
	
	q13_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q13_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard13_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "오늘은 모든 걸 잊어버리고 신나게 놀자", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "아니 근데 과제가 있는 것 같은데..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "3학년이 괜히 사망년이 아니였어 너무 힘들다ㅠㅠ 친구가 기분전환하러 클럽에 가자고 하는데 어쩌지?", this.style_q);
		this.question.anchor.set(0.5);
	},
	
	flipCard13_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-15;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-8;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+14;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill13_1, this);
	},
	cardkill13_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q14_card1, this);
	},	
	
	q14_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q14_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard14_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "27px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "지금 당장 문제집부터 사러 가야해!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "근데..4학년이면 아직 한참 남았잖아?", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "뭐? 4학년때 졸업하려면 자격증이 필요하다구? 왜 그걸 이제야 알게 된거야!!!", this.style_q);
		this.question.anchor.set(0.5);
	},
	
	flipCard14_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-15;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-15;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+18;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-10;
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+3;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill14_1, this);
	},
	cardkill14_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q15_card1, this);
	},	
	
	q15_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard15_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "37px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "조금 \n알겠군", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "뭐야 너는", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "이제 슬슬 실감이 나나?", this.style_q);
		this.question.anchor.set(0.5);
	},
	
	flipCard15_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+15;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+8;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+10;
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+8;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill15_1, this);
	},
	cardkill15_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q16_card1, this);
	},	
	
	q16_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q0_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard16_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "33px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "..소중한 \n시간들이었어", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "뭐라는 거야", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "신중하게 선택하길.. 후후.. 그럼이만", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard16_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+10;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+10;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+10;
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+20;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill16_1, this);
	},
	cardkill16_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q17_card1, this);
	},	
	
	q17_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q17_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard17_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "그래! 나의 실력을 더더욱 키울때야!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "졸업하면 뭐라도 되겠지..", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "이번 학기에는 취업아카데미가 열립니다. 전문가와 함께하는 취업 프로그램을 듣고 조금 더 성장해 나가 보는건 어떨까요?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard17_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval-3;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+10;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-4;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-3;
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-25;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill17_1, this);
	},
	cardkill17_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q18_card1, this);
	},	
	
	q18_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q18_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard18_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "빨리 동아리원들을 모아서 공모전 준비를 시작하자", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "어휴.. 무리는 다메요", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "공부한 걸 이용할 때가 왔다! 마침 이번에 딱 맞는 주제의 공모전이 열렸어..! 어떻게할까?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard18_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-3;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+15;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval-2;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-30;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill18_1, this);
	},
	cardkill18_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q20_card1, this);
	},	
	
	q20_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q20_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard20_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "20px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "교수님 정말 영광입니다! 최선을 다하겠습니다!", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "교수님 정말 감사합니다. 마음만 받겠습니다.", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "주인공아 지금 GG회사에서 인턴을 구하고 있는데 네가 그 회사의 참 적합한 인재로 생각되어서 인턴으로 추천했는데 혹시 생각 있니?", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard20_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+20;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+20;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+20;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-30;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill20_1, this);
	},
	cardkill20_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.q21_card1, this);
	},	
	
	q21_card1: function() {
		this.card = this.add.sprite(this.game.width / 2, 400, 'q20_card1');
		this.card.anchor.setTo(0.5, 0.5);		
		this.card.frame = 0;
		this.game.input.onDown.add(this.flipCard21_1, this);
		this.physics.enable(this.card, Phaser.Physics.ARCADE);
		this.card.speed = BasicGame.PLAYER_SPEED;
		this.card.body.collideWorldBounds = true;
		this.style = { font: "23px Hanna",fontStyle:'italic', fill:'#000000', wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.style_q = { font: "22px Hanna", fill:'#212121',backgroundColor:'#D5D5D5',wordWrap: true, wordWrapWidth: this.card.width, align: "center"};
		this.textyes = this.game.add.text(0, 0, "GOD\nBLESS\nYOU", this.style);
		this.textyes.anchor.set(0.5);
		this.textno = this.game.add.text(0,0, "자네 창업은 어떤가..?", this.style);
		this.textno.anchor.set(0.5);
		this.question = this.game.add.text(this.game.width/2, 190, "드디어 4년이 지났다.. 졸업이 코앞이구나. 그동안 참 많은일이 있었지.. 교수님 감사합니다", this.style_q);
		this.question.anchor.set(0.5);
	},
	flipCard21_1: function () {
		this.flip_ani();
		if(this.input.mousePointer.x<400){
			this.loveval=this.loveval+5;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval-3;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval+5;
			this.specbar.setPercent(this.specval);
		}
		else if(this.input.mousePointer.x>400){
			this.loveval=this.loveval+12;
			this.lovebar.setPercent(this.loveval);
			this.moneyval=this.moneyval+5;
			this.moneybar.setPercent(this.moneyval);
			this.specval=this.specval-25;
			this.specbar.setPercent(this.specval);
		}
		this.game.world.remove(this.question);
		this.game.world.remove(this.textno);
		this.game.world.remove(this.textyes);
		this.game.time.events.add(Phaser.Timer.SECOND * 0.8, this.cardkill21_1, this);
	},
	cardkill21_1: function(){
		this.card.kill();
		this.game.time.events.add(Phaser.Timer.SECOND * 0.5, this.endingImage, this);
	},	
	
};