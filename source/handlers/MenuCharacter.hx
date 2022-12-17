package handlers;

import flixel.graphics.frames.FlxFramesCollection;
import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;

class MenuCharacter extends FlxSprite
{
	public var ogX:Float;
	var dadOffset:Int = 0;
	var multX:Int = 1;

	public function new(x:Float, charNum:Int, charData:states.menus.LoadingState.MenuCharData)
	{
		super();
		this.ogX = x;
		this.dadOffset = (charNum == 0) ? -100 : 0;
		if (charNum == 2) {
			this.multX = -1;
			this.flipX = !this.flipX;
		}
		antialiasing = true;
		loadCharacter(charData);
	}

	public function loadCharacter(charData:states.menus.LoadingState.MenuCharData) {
		x = ogX + dadOffset + charData.xOffset * multX;
		y = 70 + dadOffset + charData.yOffset;

		frames = Files.sparrowAtlas("menus/storymenu/" + charData.spritePath);

		animation.addByPrefix("idle", charData.idleAnim, 24, true, charData.flipX);
		if (charData.confirmAnim != null)
			animation.addByPrefix("confirm", charData.confirmAnim, 24, false, charData.flipX);

		scale.set(charData.scale, charData.scale);

		animation.play("idle");
		updateHitbox();
	}
}
