package handlers;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxMath;
import flixel.FlxG;
import flixel.util.FlxColor;
import handlers.ClientPrefs;

class MenuItem extends FlxSprite {
	public var targetY:Int = 0;
	public var flashingInt:Int = 0;
	public var flashColor:FlxColor = 0xFFFFFFFF;

	public function new(x:Float, y:Float, image:String) {
		super(x, y, Files.image("menus/storymenu/" + image));
	}

	var time:Float = 0;

	override function update(elapsed:Float) {
		super.update(elapsed);
		y = FlxMath.lerp(y, (targetY * 120) + 480, 0.17);

		time += elapsed;

		if (ClientPrefs.flashingLights) {
			if (flashColor == 0xFFFFFFFF)
				return;
			flashingInt = (flashingInt + 1) % fakeFramerate;

			color = (time % 0.1 > 0.05) ? flashColor : 0xFFFFFFFF;
		}
	}
}
