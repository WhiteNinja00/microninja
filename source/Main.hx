package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	var gamewidth = 216;
	var gameheight = 160;
	var zoom = 1;
	var updateframerate = 60;
	var drawframerate = 60;
	var skipsplashscreen = true;
	var startfullscreen = false;
	public function new()
	{
		super();
		addChild(new FlxGame(gamewidth, gameheight, PlayState, zoom, updateframerate, drawframerate, skipsplashscreen, startfullscreen));
	}
}
