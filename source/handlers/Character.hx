package handlers;

import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.animation.FlxBaseAnimation;
import flixel.graphics.frames.FlxAtlasFrames;
import states.mainstates.PlayState;
import states.menus.LoadingState;
import handlers.ModDataStructures;
import handlers.Conductor;

using StringTools;

class Character extends FlxSprite {
	public var animOffsets:Map<String, Array<Float>>;
	public var stunned:Bool = false;
	public var debugMode:Bool = false;

	public var charData:GameCharData;
	public var isPlayer:Bool = false;
	public var isSwagDanceLefterDanceRighter:Bool = false;
	public var curCharacter:String = 'bf';

	public var holdTimer:Float = 0;

	public var hpcolor:FlxColor;

	// If you want to change the position of the characters, mess with these.
	// The sprites x and y now get changed every frame.
	public var regX:Float = 770;
	public var regY:Float = 100;

	// Heres some offsets retaining to sing camera offsets change these lol
	public var singLEFTX:Int = -20;
	public var singLEFTY:Int = 0;
	public var singUPX:Int = 0;
	public var singUPY:Int = -20;
	public var singDOWNX:Int = 0;
	public var singDOWNY:Int = 20;
	public var singRIGHTX:Int = 20;
	public var singRIGHTY:Int = 0;

	public function new(x:Float, y:Float, character:String = "bf", isPlayer:Bool = false) {
		animOffsets = new Map<String, Array<Float>>();
		super(x, y);
		regX = x;
		regY = y;

		this.isPlayer = isPlayer;
		loadCharacter(character);
	}

	public function loadCharacter(?character:String = "bf") {
		animOffsets = [];

		curCharacter = character;
		var dataIndex = LoadingState.modData.charNames.indexOf(curCharacter);
		if (dataIndex == -1) {
			loadCharacter("bf");
			return;
		}
		charData = LoadingState.modData.charList[dataIndex];
		var normallyBF:Bool = (charData.regCharType == "bf");

		// If you wanna add new spritesheet types, add an fileExists function in this array, and add a case in the switch statement.
		var boolIndex:Int = [
			Files.fileExists("images/characters", charData.spriteImage, "txt") // txt exists. loading packer sheet.
		].indexOf(true);
		switch (boolIndex) {
			case 0:
				frames = Files.packerAtlas(charData.spriteImage, "images/characters");
			default:
				frames = Files.sparrowAtlas(charData.spriteImage, "images/characters");
		}

		for (anim in charData.anims) {
			if (anim.indices.length > 0)
				animation.addByIndices(anim.name, anim.prefix, anim.indices, "", anim.fps, anim.looped);
			else
				animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped);

			var daOffsets = [];
			var copiedOffsets:Array<Float> = Reflect.copy(anim.offsets); // Just in case the offset scaling affects the char in mod data.
			if (normallyBF != isPlayer && copiedOffsets.length >= 4)
				daOffsets = [copiedOffsets[2], copiedOffsets[3]]; // Optional alternative offsets for if the character is not on the usual side.
			else
				daOffsets = [copiedOffsets[0], copiedOffsets[1]];

			if (charData.scaleAffectsOffset) {
				daOffsets[0] = daOffsets[0] / charData.scale;
				daOffsets[1] = daOffsets[1] / charData.scale;
			}

			if (!animation.exists(anim.name))
				trace(curCharacter + ": COULDN'T ADD ANIMATION: " + anim.name);

			animOffsets.set(anim.name, daOffsets);
		}
		isSwagDanceLefterDanceRighter = (animation.exists("danceLeft") && animation.exists("danceRight"));

		flipX = charData.flipX;
		if (isPlayer)
			flipX = !flipX;
		antialiasing = charData.antialiasing;
		if (charData.hpColor == null)
			hpcolor = (isPlayer) ? 0xFF00FF88 : 0xFF353535; // I'm not a fan of red and green. I prefer mint and gray. -Srt
		else
			hpcolor = charData.hpColor;
		scale.set(charData.scale, charData.scale);
		updateHitbox();

		if (normallyBF != isPlayer) {
			// if they have sing animations
			if (animation.getByName('singRIGHT') != null) {
				var oldRight = animation.getByName('singRIGHT').frames;
				var oldROffsets = animOffsets["singRIGHT"];
				animation.getByName('singRIGHT').frames = animation.getByName('singLEFT').frames;
				animOffsets["singRIGHT"] = animOffsets["singLEFT"];
				animation.getByName('singLEFT').frames = oldRight;
				animOffsets["singLEFT"] = oldROffsets;
			}

			// IF THEY HAVE MISS ANIMATIONS??
			if (animation.getByName('singRIGHTmiss') != null) {
				var oldMiss = animation.getByName('singRIGHTmiss').frames;
				var oldMOffsets = animOffsets["singRIGHT"];
				animation.getByName('singRIGHTmiss').frames = animation.getByName('singLEFTmiss').frames;
				animOffsets["singRIGHTmiss"] = animOffsets["singLEFTmiss"];
				animation.getByName('singLEFTmiss').frames = oldMiss;
				animOffsets["singLEFTmiss"] = oldMOffsets;
			}
		}

		playAnim(isSwagDanceLefterDanceRighter ? "danceLeft" : "idle");
		danced = true;

		x = regX + charData.offsets[0];
		y = regY + charData.offsets[1];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);
		x = regX + charData.offsets[0];
		y = regY + charData.offsets[1];

		if (animation.curAnim == null)
			return;

		if (animation.curAnim.name.startsWith('sing') && !debugMode) {
			holdTimer += elapsed;
			if (holdTimer >= Conductor.stepCrochet * charData.singDur * 0.001) {
				dance();
				holdTimer = 0;
			}
		}

		// this was originally only for gf but i'd think everyone would like to play other animations when their hair finishes falling.
		if (animation.curAnim.name == 'hairFall' && animation.curAnim.finished && !debugMode) {
			playAnim(isSwagDanceLefterDanceRighter ? 'danceRight' : 'idle');
			danced = false;
		}

		if (animation.curAnim.name == 'firstDeath' && animation.curAnim.finished)
			playAnim('deathLoop');
	}

	private var danced:Bool = false;

	/**
	 * FOR GF DANCING SHIT
	 */
	public function dance() {
		var hairFalling = (animation.curAnim != null && animation.curAnim.name.startsWith('hair') && !animation.curAnim.finished);
		var isSinging = (animation.curAnim != null
			&& animation.curAnim.name.startsWith('sing')
			&& holdTimer < Conductor.stepCrochet * charData.singDur * 0.001);
		if (debugMode || hairFalling || isSinging)
			return;

		danced = !danced;

		var danceAnim:String = 'idle';
		if (isSwagDanceLefterDanceRighter)
			danceAnim = danced ? 'danceLeft' : "danceRight";

		playAnim(danceAnim);
	}

	public function playAnim(AnimName:String, Force:Bool = false, Reversed:Bool = false, Frame:Int = 0):Void {
		if (!animOffsets.exists(AnimName) || !animation.exists(AnimName))
			return; // crashhandler real //ya mean fake. - Srt

		animation.play(AnimName, Force, Reversed, Frame);

		var daOffset = animOffsets.get(animation.curAnim.name);
		if (animOffsets.exists(animation.curAnim.name))
			offset.set(daOffset[0], daOffset[1]);
		else
			offset.set(0, 0);

		if (charData.regCharType == 'gf') {
			danced = switch (AnimName) {
				case "singLEFT": true;
				case "singRIGHT": false;
				case "singUP" | "singDOWN": !danced;
				default: danced;
			}
		}
	}

	public function addOffset(name:String, x:Float = 0, y:Float = 0) {
		animOffsets[name] = [x, y];
	}
}
