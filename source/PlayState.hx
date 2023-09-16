package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.FlxObject;
import flixel.FlxSprite;
import io.newgrounds.NG;
import flixel.util.FlxSave;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxTimer;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxTween;
import io.newgrounds.objects.Medal;
import io.newgrounds.objects.Score;
import io.newgrounds.objects.ScoreBoard;
import flixel.addons.display.FlxBackdrop;
import flixel.group.FlxGroup.FlxTypedGroup;

class PlayState extends FlxState
{
	var speed = 1.0;
	var addspeed = 0.2;
	var minigamenumberstuff = 5;
	var health = 4;
	var score = 0;
	var timersstarted = true;
	var complete = true;
	var minigame = 1;
	var gameover = false;
	var minigametime = false;
	var lastminigame = 0;
	var gameoverthing = false;
	var highscore:FlxSave;
	var oldhighscore = 0;
	var loggedin = false;
	var menu = true;
	var newgrounds = true;
	//^-code/v-asset stuff
	var backdrop:FlxBackdrop;
	var whiteninja:FlxSprite;
	var text:FlxSprite;
	var one:FlxSprite;
	var two:FlxSprite;
	var three:FlxSprite;
	var background:FlxSprite;
	var hearts:FlxTypedGroup<FlxSprite>;
	var scoretext:FlxText;
	var scorething:FlxSprite;
	var blackoverlay:FlxSprite;
	var gameovertext:FlxText;
	var logo:FlxSprite;
	var button:FlxSprite;
	//^-asset stuff/v-minigame assets
	var carbackground:FlxSprite;
	var car:FlxSprite;
	var runbackground:FlxSprite;
	var wnrun:FlxSprite;
	var box:FlxSprite;
	var jarbackground:FlxSprite;
	var wnhand:FlxSprite;
	var textbackground:FlxSprite;
	var wntext:FlxSprite;
	var textthing:FlxText;
	var wntext2:FlxSprite;
	var map:FlxTilemap;
	var exit:FlxSprite;
	var player:FlxSprite;
	//^-minigame assets/v-minigame code
	var carpress = false;
	var youlost = false;
	var othercaranimation = false;
	var thingforbeep = false;
	var randomcartime = 3.0;
	var howfar = 0.0;
	var loopthing = false;
	var justpressedthing = false;
	var pressesleft = 5;
	var youjustwon = false;
	var texts:Array<String> = [
		'ratio + l + kys + fatherless',
		'wanna play jackbox lol',
		'192.502.063.69',
		'i am inside your walls',
		'i hate you',
		'kys',
		'great argument but i did\nyour mom',
		'there is a pipebomb in\nyour mail'
	];
	var thetext = 0;
	var textsdone = 0;

	override public function create()
	{
		FlxG.mouse.visible = false;

		highscore = new FlxSave();
		highscore.bind("GameData");

		if(highscore.data.highscore == null) {
			highscore.data.highscore = 0;
		}

		oldhighscore = highscore.data.highscore;

		NG.create("54734:uZpEF1aX");
		NG.core.verbose = true;
		NG.core.initEncryption("WZdKa2BlPfpHBlIuL/wZpQ==");

		if(NG.core.attemptingLogin)
			NG.core.onLogin.add(onNGLogin);
		else
			newgrounds = false;

		if(newgrounds) {
			NG.core.requestScoreBoards();
			NG.core.requestMedals();
		}

		trace('newgrounds is ' + newgrounds);

		var backdrop:FlxBackdrop;
		add(backdrop = new FlxBackdrop('assets:assets/images/checkerboard.png'));
		backdrop.velocity.set(20, 20);

		whiteninja = new FlxSprite();
		whiteninja.loadGraphic('assets:assets/images/white ninja.png', true, 135, 135);
		whiteninja.animation.add("vibe", [0, 1, 2, 1], 3);
		whiteninja.animation.add("sad", [3, 4], 3);
		whiteninja.screenCenter(X);
		whiteninja.y = 25;
		add(whiteninja);
		whiteninja.animation.play("vibe");

		scorething = new FlxSprite(0, 0).loadGraphic('assets:assets/images/score.png');
		add(scorething);
		
		scoretext = new FlxText(129, 29, 81, score + "", 12);
		scoretext.color = 0xFF613E00;
		scoretext.alignment = CENTER;
		scoretext.antialiasing = false;
		add(scoretext);

		background = new FlxSprite(0, 0).loadGraphic('assets:assets/images/background.png');
		add(background);
		background.visible = false;

		carbackground = new FlxSprite(0, 0).loadGraphic('assets:assets/images/car background.png');
		add(carbackground);
		carbackground.visible = false;

		car = new FlxSprite(0, 56);
		car.loadGraphic('assets:assets/images/car.png', true, 222, 107);
		car.animation.add("idle", [0], 3);
		car.animation.add("flash", [1], 3);
		car.animation.add("flashend", [2], 3);
		car.screenCenter(X);
		add(car);
		car.animation.play("vibe");
		car.visible = false;

		runbackground = new FlxSprite(0, 0).loadGraphic('assets:assets/images/run background.png', true, 216, 160);
		runbackground.animation.add("animation", [0, 1], 6);
		add(runbackground);
		runbackground.animation.play("animation");
		runbackground.visible = false;

		wnrun = new FlxSprite();
		wnrun.loadGraphic('assets:assets/images/wnrun.png', true, 84, 156);
		wnrun.animation.add("idle", [0], 3);
		wnrun.animation.add("run", [1, 0, 2, 0], 6);
		wnrun.screenCenter(X);
		add(wnrun);
		wnrun.animation.play("idle");
		wnrun.visible = false;

		box = new FlxSprite();
		box.loadGraphic('assets:assets/images/box.png', true, 188, 118);
		box.animation.add("chase", [0, 1, 2, 2], 6);
		box.screenCenter(X);
		box.y = 74;
		add(box);
		box.animation.play("chase");
		box.visible = false;

		jarbackground = new FlxSprite(0, 0).loadGraphic('assets:assets/images/jar background.png');
		add(jarbackground);
		jarbackground.visible = false;

		wnhand = new FlxSprite(0, 0).loadGraphic('assets:assets/images/wn hand.png', true, 216, 160);
		wnhand.animation.add("idle", [0], 6);
		wnhand.animation.add("move", [1], 6);
		wnhand.animation.add("win", [2], 6);
		add(wnhand);
		wnhand.animation.play("idle");
		wnhand.visible = false;

		textbackground = new FlxSprite(0, 0).loadGraphic('assets:assets/images/type background.png');
		add(textbackground);
		textbackground.visible = false;

		wntext = new FlxSprite(0, 0).loadGraphic('assets:assets/images/wn type.png', true, 216, 160);
		wntext.animation.add("idle", [0], 6);
		wntext.animation.add("move", [1], 6);
		wntext.animation.add("win", [2], 6);
		add(wntext);
		wntext.animation.play("idle");
		wntext.visible = false;

		textthing = new FlxText(70, 95, FlxG.width, "", 5);
		textthing.alignment = LEFT;
		textthing.angle = -10;
		add(textthing);
		textthing.visible = false;

		wntext2 = new FlxSprite(0, 0).loadGraphic('assets:assets/images/wn type fingers.png', true, 216, 160);
		wntext2.animation.add("idle", [0], 6);
		wntext2.animation.add("move", [1], 6);
		wntext2.animation.add("win", [2], 6);
		add(wntext2);
		wntext2.animation.play("idle");
		wntext2.visible = false;

		map = new FlxTilemap();
		map.loadMapFromCSV("assets:assets/data/platformlevel.csv", "assets:assets/images/tiles.png", 4, 4, AUTO);
		add(map);
		map.visible = false;

		exit = new FlxSprite(184, 68);
		exit.makeGraphic(24, 32, 0xFF3B3B3B);
		add(exit);
		exit.visible = false;

		player = new FlxSprite();
		player.loadGraphic('assets:assets/images/character.png', true, 8, 16);
		player.animation.add("idle", [0], 2);
		player.animation.add("jump", [4], 15);
		player.animation.add("walk", [1, 0, 2, 0], 15);
		player.maxVelocity.set(70, 170);
		player.acceleration.y = 200 * speed;
		player.drag.x = player.maxVelocity.x * 4 * speed;
		add(player);
		player.visible = false;

		one = new FlxSprite(180, 125).loadGraphic('assets:assets/images/one.png');
		add(one);
		one.visible = false;
		
		two = new FlxSprite(180, 125).loadGraphic('assets:assets/images/two.png');
		add(two);
		two.visible = false;

		three = new FlxSprite(183, 124).loadGraphic('assets:assets/images/three.png');
		add(three);
		three.visible = false;

		text = new FlxSprite(0, 0).loadGraphic('assets:assets/images/car text.png');
		add(text);
		text.visible = false;

		hearts = new FlxTypedGroup<FlxSprite>();
		add(hearts);

		for(i in 0...4) {
			var heart:FlxSprite = new FlxSprite(5 + (i * 27), 5).loadGraphic('assets:assets/images/heart.png');
			heart.ID = i;
			hearts.add(heart);
		}

		blackoverlay = new FlxSprite(0, 0).makeGraphic(FlxG.width, FlxG.height, 0xAA000000);
		add(blackoverlay);
		blackoverlay.visible = false;

		gameovertext = new FlxText(70, 95, FlxG.width, "game over\n\nyour score was " + score + "\nyour highscore is " + highscore.data.highscore + "\n\npress z to restart", 12);
		gameovertext.alignment = CENTER;
		gameovertext.screenCenter();
		gameovertext.antialiasing = false;
		add(gameovertext);
		gameovertext.visible = false;

		logo = new FlxSprite(0, 20).loadGraphic('assets:assets/images/logo.png');
        logo.screenCenter(X);
		add(logo);

		button = new FlxSprite(0, 0).loadGraphic('assets:assets/images/tostart.png');
        button.screenCenter(X);
		add(button);
		
		hidestuff();

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if(menu) {
			if(FlxG.keys.justPressed.Z) {
				showstuff();
				logo.visible = false;
				button.visible = false;
				new FlxTimer().start(0.5 / speed, stopanimation, 0);
				new FlxTimer().start(3.0, startthegame, 1);
				new FlxTimer().start(2.5, maketext, 1);
				menu = false;
			}
		} else if(gameover) {
			if(gameoverthing) {
				if(FlxG.keys.justPressed.Z) {
					speed = 1.0;
					addspeed = 0.2;
					minigamenumberstuff = 5;
					health = 4;
					score = 0;
					timersstarted = true;
					complete = true;
					minigame = 1;
					gameover = false;
					minigametime = false;
					lastminigame = 0;
					gameoverthing = false;
					oldhighscore = highscore.data.highscore;
					background.visible = false;
					whiteninja.visible = true;
					scorething.visible = true;
					scoretext.visible = true;
					hearts.forEach(function(heart:FlxSprite) { heart.visible = true; });
					blackoverlay.visible = false;
					gameovertext.visible = false;
					whiteninja.animation.play("vibe");
					scoretext.text = score + '';
					hearts.forEach(function(heart:FlxSprite) {
						heart.visible = true;
						heart.loadGraphic('assets:assets/images/heart empty.png');
						if(heart.ID < health) {
							heart.loadGraphic('assets:assets/images/heart.png');
						}
					});
					new FlxTimer().start(0.5 / speed, stopanimation, 0);
					new FlxTimer().start(3.0, startthegame, 1);
					new FlxTimer().start(2.5, maketext, 1);
				}
			}
		} else {
			if(!timersstarted) {
				text.visible = false;
				new FlxTimer().start(6.0 / speed, startingnewminigame, 1);
				new FlxTimer().start(5.0 / speed, onething, 1);
				new FlxTimer().start(4.0 / speed, twothing, 1);
				new FlxTimer().start(3.0 / speed, threething, 1);
				complete = false;
				background.visible = true;
				timersstarted = true;
				hearts.forEach(function(heart:FlxSprite) { heart.visible = false; });
				//v-restart the varticies or something ^-starting game code
				carpress = false;
				youlost = false;
				othercaranimation = false;
				thingforbeep = false;
				howfar = 3;
				loopthing = false;
				justpressedthing = false;
				pressesleft = 5;
				youjustwon = false;
				thetext = FlxG.random.int(0, texts.length - 1);
				#if html5
				textsdone = 1;
				#else
				textsdone = 0;
				#end
				textthing.text = '';
				textthing.x = 70;
				textthing.y = 95;
				player.x = 10;
				player.y = 25;
				player.acceleration.x = 0;
				player.drag.x = player.maxVelocity.x * 4 * speed;
			}
			if(minigametime) {
				if(minigame == 1) {
					randomcartime = FlxG.random.float(2, 4);
					carbackground.visible = true;
					car.visible = true;
					if(FlxG.keys.justPressed.Z) {
						if(carpress) {
							if(!youlost) complete = true;
						} else {
							youlost = true;
							complete = false;
						}
					}
					car.animation.play("idle");
					if(carpress) {
						if(othercaranimation) {
							car.animation.play("flashend");
						} else {
							car.animation.play("flash");
							if(!thingforbeep) {
								playaudio('beep');
							}
							thingforbeep = true;
						}
					} else {
						new FlxTimer().start(randomcartime / speed, beep, 1);
						new FlxTimer().start((randomcartime + 0.05) / speed, otheranimation, 1);
					}
				} else if(minigame == 2) {
					runbackground.visible = true;
					wnrun.visible = true;
					box.visible = true;

					if(!loopthing) {
						howfar -= 0.1 * (speed / 3);
						new FlxTimer().start(0.03 / speed, loopthinguhh, 1);
						loopthing = true;
					}

					if(FlxG.keys.justPressed.Z) {
						howfar += 0.4 * speed;
						justpressedthing = true;
					}

					if(howfar >= 5) howfar = 5;
					if(howfar <= 0) {
						howfar = 0;
						youlost = true;
						complete = false;
					}
					if(!youlost) complete = true; 

					if(justpressedthing)
						wnrun.animation.play("run");
					else
						wnrun.animation.play("idle");

					wnrun.y = -10 + (howfar * 3);
					wnrun.scale.x = ((0 - howfar) + 6) / 4;
					wnrun.scale.y = ((0 - howfar) + 6) / 4;
				} else if(minigame == 3) {
					jarbackground.visible = true;
					wnhand.visible = true;
					
					if(pressesleft <= 0) {
						pressesleft = 0;
						complete = true;
						if(!youjustwon) {
							playaudio('horn');
							youjustwon = true;
						}
					}
					if(FlxG.keys.justPressed.Z) {
						pressesleft -= 1;
					}
					if(complete)
						wnhand.animation.play("win");
					else if(FlxG.keys.pressed.Z)
						wnhand.animation.play("move");
					else
						wnhand.animation.play("idle");
				} else if(minigame == 4) {
					textbackground.visible = true;
					wntext.visible = true;
					textthing.visible = true;
					wntext2.visible = true;

					if (texts[thetext].length > textsdone) {
						if(!FlxG.keys.justPressed.ENTER && FlxG.keys.justPressed.ANY) {
							textsdone += 1;
						}
					} else {
						if(FlxG.keys.justPressed.ENTER) {
							complete = true;
						}
					}

					if(complete) {
						wntext.animation.play("win");
						wntext2.animation.play("win");
						textthing.x = 60;
						textthing.y = 62;
					} else if(!FlxG.keys.justPressed.ENTER && FlxG.keys.pressed.ANY) {
						wntext.animation.play("move");
						wntext2.animation.play("move");
					} else {
						wntext.animation.play("idle");
						wntext2.animation.play("idle");
					}

					textthing.text = texts[thetext].substring(0, textsdone);
				} else if(minigame == 5) {
					player.visible = true;
					map.visible = true;
					exit.visible = true;

					if(complete) {
						player.visible = false;
					} else {
						if(FlxG.keys.justPressed.LEFT) {
							player.acceleration.x = (-player.maxVelocity.x * 3) * speed;
							player.flipX = true;
							player.animation.play("walk");
						}
						if(FlxG.keys.justPressed.RIGHT) {
							player.acceleration.x = (player.maxVelocity.x * 3) * speed;
							player.flipX = false;
							player.animation.play("walk");
						}
						if(player.isTouching(FLOOR)) {
							if(FlxG.keys.justPressed.Z || FlxG.keys.justPressed.UP) {
								player.velocity.y = -player.maxVelocity.y / 1.5;
								player.animation.play("jump");
							}
						}
						if(!FlxG.keys.pressed.LEFT && !FlxG.keys.pressed.RIGHT && !FlxG.keys.pressed.Z) {
							player.animation.play("idle");
						}
						FlxMath.lerp(player.acceleration.x, 0, 0.16 / speed);
					}
				} else if(minigame == 6) {
					//
					if(FlxG.keys.justPressed.UP) {
	
					}
					if(FlxG.keys.justPressed.DOWN) {
	
					}
					if(FlxG.keys.justPressed.LEFT) {
	
					}
					if(FlxG.keys.justPressed.RIGHT) {
	
					}
					if(FlxG.keys.justPressed.Z) {
	
					}
				} else if(minigame == 7) {
					//
					if(FlxG.keys.justPressed.UP) {
	
					}
					if(FlxG.keys.justPressed.DOWN) {
	
					}
					if(FlxG.keys.justPressed.LEFT) {
	
					}
					if(FlxG.keys.justPressed.RIGHT) {
	
					}
					if(FlxG.keys.justPressed.Z) {
	
					}
				} else {
					trace('error: minigame does not exist');
				}
			}
		}

		super.update(elapsed);

		FlxG.collide(player, map);
		FlxG.overlap(exit, player, platformwin);
	}

	function platformwin(object1:FlxObject, object2:FlxObject) {
		complete = true;
	}

	function startingnewminigame(timer:FlxTimer) {
		carbackground.visible = false;
		car.visible = false;
		runbackground.visible = false;
		wnrun.visible = false;
		box.visible = false;
		jarbackground.visible = false;
		wnhand.visible = false;
		textbackground.visible = false;
		wntext.visible = false;
		textthing.visible = false;
		textthing.text = '';
		wntext2.visible = false;
		player.visible = false;
		map.visible = false;
		exit.visible = false;
		//^-remove minigame stuff v-other stuff
		minigametime = false;
		background.visible = false;
		one.visible = false;
		minigamenumberstuff -= 1;

		if(complete) {
			score += 1;
			whiteninja.animation.play("vibe");
		} else {
			health -= 1;
			whiteninja.animation.play("sad");
		}

		if(newgrounds) {
			if(score == 1) {
				getmedal(69379);
			} else if(score == 10) {
				getmedal(69380);
			} else if(score == 50) {
				getmedal(69383);
			} else if(score == 69) {
				getmedal(69382);
			} else if(score == 100) {
				getmedal(69381);
			}
		}

		if(minigamenumberstuff == 0) {
			speed += addspeed;
			minigamenumberstuff = 5;
		}

		if(speed > 3) speed = 3;

		scoretext.text = score + '';

		hearts.forEach(function(heart:FlxSprite) {
			heart.visible = true;
			heart.loadGraphic('assets:assets/images/heart empty.png');
			if(heart.ID < health) {
				heart.loadGraphic('assets:assets/images/heart.png');
			}
		});

		if(score >= highscore.data.highscore) {
			highscore.data.highscore = score;
			highscore.flush();
		}

		if(health == 0) {
			gameover = true;
			new FlxTimer().start(3.0, gameoverfunction, 1);
			if(loggedin && newgrounds) {
				for (id in NG.core.scoreBoards.keys()) { //error lol
					var board = NG.core.scoreBoards.get(id);
					board.postScore(score);
				}
			}
			trace('game over');
		} else {
			new FlxTimer().start(3.0 / speed, startthegame, 1);
			new FlxTimer().start(2.5 / speed, maketext, 1);
		}
	}

	function maketext(timer:FlxTimer) {
		lastminigame = minigame;
		minigame = FlxG.random.int(1, 5, [lastminigame]);
		trace('minigame ' + minigame);
		text.visible = true;
		if(minigame == 1) {
			text.loadGraphic('assets:assets/images/car text.png');
		} else if(minigame == 2) {
			text.loadGraphic('assets:assets/images/run text.png');
		} else if(minigame == 3) {
			text.loadGraphic('assets:assets/images/jar text.png');
		} else if(minigame == 4) {
			text.loadGraphic('assets:assets/images/type text.png');
		}
		text.scale.x = 1.5;
		text.scale.y = 1.5;
		FlxTween.tween(text.scale, {x: 1, y: 1}, 0.25 / speed);
	}

	function threething(timer:FlxTimer) {
		three.visible = true;
		numbers(three);
	}

	function twothing(timer:FlxTimer) {
		three.visible = false;
		numbers(two);
	}

	function onething(timer:FlxTimer) {
		two.visible = false;
		numbers(one);
	}

	function numbers(number:FlxSprite) {
		number.visible = true;
		number.scale.x = 1.5;
		number.scale.y = 1.5;
		playaudio('tick');
		FlxTween.tween(number.scale, {x: 1, y: 1}, 0.5 / speed);
	}

	function startthegame(timer:FlxTimer) {
		timersstarted = false;
		minigametime = true;
	}

	function beep(timer:FlxTimer) {
		carpress = true;
	}

	function otheranimation(timer:FlxTimer) {
		othercaranimation = true;
	}

	function loopthinguhh(timer:FlxTimer) {
		loopthing = false;
	}

	function stopanimation(timer:FlxTimer) {
		justpressedthing = false;
	}

	function onNGLogin() {
        loggedin = true;
	}

    function getmedal(id:Int) {
		if (loggedin) {
			var medal =  NG.core.medals.get(id);
			if (!medal.unlocked) medal.sendUnlock();
		}
    }
	
	function gameoverfunction(timer:FlxTimer) {
		hidestuff();

		if(score >= highscore.data.highscore) {
			highscore.data.highscore = score;
			highscore.flush();
		}

		if(oldhighscore < highscore.data.highscore) {
			gameovertext.text = "game over\n\nyour score was " + score + "\nNEW HIGHSCORE!\nyour highscore is " + highscore.data.highscore + "\n\npress z to restart";
		} else {
			gameovertext.text = "game over\n\nyour score was " + score + "\nyour highscore is " + highscore.data.highscore + "\n\npress z to restart";
		}

		gameovertext.screenCenter();

		blackoverlay.visible = true;
		gameovertext.visible = true;
		gameoverthing = true;
	}

	function hidestuff() {
		whiteninja.visible = false;
		scorething.visible = false;
		scoretext.visible = false;
		hearts.forEach(function(heart:FlxSprite) { heart.visible = false; });
	}

	function showstuff() {
		whiteninja.visible = true;
		scorething.visible = true;
		scoretext.visible = true;
		hearts.forEach(function(heart:FlxSprite) { heart.visible = true; });
	}

	function playaudio(audiofile:String) {
		FlxG.sound.play('assets:assets/sounds/' + audiofile + '/' + (speed * 10) + '.mp3');
	}
}
