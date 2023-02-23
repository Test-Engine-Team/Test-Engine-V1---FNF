package states.menus;

import scriptStuff.HiScript;
#if desktop
import handlers.DiscordHandler;
#end
import handlers.shaders.BuildingShaders;
import handlers.shaders.ColorSwap;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.FlxTransitionableState;
import flixel.addons.transition.TransitionData;
import flixel.graphics.FlxGraphic;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup;
import flixel.input.gamepad.FlxGamepad;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import openfl.Assets;
import ui.Alphabet;
import handlers.Files;
import handlers.CoolUtil;
import handlers.Highscore;
import handlers.Conductor;
import handlers.MusicBeatState;
import handlers.ClientPrefs;
import flixel.input.keyboard.FlxKey;
import states.etc.substates.FlashingLightsWarningSubState;

using StringTools;

class TitleState extends MusicBeatState {
	public static var initialized:Bool = false;
	public static var seenIntro:Bool = false;

	var swagShader:ColorSwap;
	var alphaShader:BuildingShaders;

	var blackScreen:FlxSprite;
	var credGroup:FlxGroup;
	var credTextShit:Alphabet;
	var textGroup:FlxGroup;
	var ngSpr:FlxSprite;

	var curWacky:Array<String> = [];

	var wackyImage:FlxSprite;

	var script:HiScript;

	var logoBl:FlxSprite;
	var gfDance:FlxSprite;
	var danceLeft:Bool = false;
	var titleText:FlxSprite;

	var flash:Bool = true;

	var skippedIntro:Bool;

	var transitioning:Bool = false;

	var pressedEnter:Bool = false;

	public static var reloadNeeded:Bool = false;

	override public function create():Void {
		#if SCRIPTS_ENABLED
		script = new HiScript('states/TitleState');
		if (!script.isBlank && script.expr != null) {
			script.interp.scriptObject = this;
			script.interp.execute(script.expr);
		}
		script.callFunction("create");
		#end

		FlxG.mouse.visible = false;
		FlxG.sound.muteKeys = [FlxKey.ZERO];

		persistentUpdate = false;

		swagShader = new ColorSwap();
		alphaShader = new BuildingShaders();

		curWacky = FlxG.random.getObject(getIntroTextShit());

		super.create();

		/*
			if (!persistentUpdate)
			{
				if(FlxG.save.data != null && FlxG.save.data.fullscreen)
				{
					FlxG.fullscreen = FlxG.save.data.fullscreen;
					//trace('LOADED FULLSCREEN SETTING!!'); IK FUCK SHIT IM STUPID - MACKERY
				}
			}
		 */

		startIntro();
	}

	function startIntro() {
		if (!initialized) {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;
			diamond.destroyOnNoUse = false;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 1, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
		}

		// checks if flashing is null, if so desplay a warning
		if (FlxG.save.data.seenFlashingLightsWarning == false)
			openSubState(new states.etc.substates.FlashingLightsWarningSubState());

		if (reloadNeeded) {
			reloadNeeded = false;
			FlxG.resetState();
		}

		if (!seenIntro) {
			FlxG.sound.playMusic(Files.music('freakyMenu'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);
		}

		Conductor.songPosition = 0;
		Conductor.changeBPM(102);
		persistentUpdate = true;

		logoBl = new FlxSprite(-150, -100);
		logoBl.frames = (Files.sparrowAtlas('menus/titlescreen/logoBumpin'));
		logoBl.antialiasing = true;
		logoBl.animation.addByPrefix('bump', 'logo bumpin', 24);
		logoBl.animation.play('bump');
		logoBl.updateHitbox();
		logoBl.shader = swagShader.shader;

		gfDance = new FlxSprite(FlxG.width * 0.4, FlxG.height * 0.07);
		gfDance.frames = (Files.sparrowAtlas('menus/titlescreen/gfDanceTitle'));
		gfDance.animation.addByIndices('danceLeft', 'gfDance', [30, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14], "", 24, false);
		gfDance.animation.addByIndices('danceRight', 'gfDance', [15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29], "", 24, false);
		gfDance.antialiasing = true;
		gfDance.shader = swagShader.shader;
		if (!ClientPrefs.ogTitle) {
			add(gfDance);
			add(logoBl);
		} else {
			FlxG.sound.playMusic(Files.music('title'), 0);

			FlxG.sound.music.fadeIn(4, 0, 0.7);

			FlxG.mouse.visible = true;
		}

		titleText = new FlxSprite(100, FlxG.height * 0.8);
		titleText.frames = Files.sparrowAtlas('menus/titlescreen/titleEnter');
		titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
		titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
		titleText.antialiasing = true;
		titleText.animation.play('idle');
		titleText.updateHitbox();
		titleText.shader = swagShader.shader;
		if (!ClientPrefs.ogTitle)
			add(titleText);

		var ogbg:FlxSprite = new FlxSprite(-600, -200).loadGraphic(Files.image('stageback'));
		ogbg.scrollFactor.set(0.9, 0.9);
		ogbg.active = false;
		if (ClientPrefs.ogTitle)
			add(ogbg);

		var logoB2:FlxSprite = new FlxSprite().loadGraphic(Files.image('menus/titlescreen/logo'));
		logoB2.screenCenter();
		logoB2.color = FlxColor.BLACK;
		if (ClientPrefs.ogTitle)
			add(logoB2);

		var logo:FlxSprite = new FlxSprite().loadGraphic(Files.image('menus/titlescreen/logo'));
		logo.screenCenter();
		logo.antialiasing = true;
		if (ClientPrefs.ogTitle)
			add(logo);

		FlxTween.tween(logoB2, {y: logoB2.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG});
		FlxTween.tween(logo, {y: logoB2.y + 50}, 0.6, {ease: FlxEase.quadInOut, type: PINGPONG, startDelay: 0.1});

		credGroup = new FlxGroup();
		if (!ClientPrefs.ogTitle)
			add(credGroup);
		textGroup = new FlxGroup();

		blackScreen = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		credGroup.add(blackScreen);

		credTextShit = new Alphabet(0, 0, "ninjamuffin99\nPhantomArcade\nkawaisprite\nevilsk8er", true);
		credTextShit.screenCenter();

		credTextShit.visible = false;

		ngSpr = new FlxSprite(0, FlxG.height * 0.52).loadGraphic(Files.image('menus/titlescreen/newgrounds_logo'));
		if (!ClientPrefs.ogTitle)
			add(ngSpr);
		ngSpr.visible = false;
		ngSpr.setGraphicSize(Std.int(ngSpr.width * 0.8));
		ngSpr.updateHitbox();
		ngSpr.screenCenter(X);
		ngSpr.antialiasing = true;

		FlxTween.tween(credTextShit, {y: credTextShit.y + 20}, 2.9, {ease: FlxEase.quadInOut, type: PINGPONG});

		if (seenIntro)
			skipIntro();

		initialized = true;

		#if SCRIPTS_ENABLED
		script.callFunction("createPost");
		#end
	}

	function getIntroTextShit():Array<Array<String>> {
		var fullText:String = Assets.getText('assets/data/introText.txt');

		var firstArray:Array<String> = fullText.split('\n');
		var swagGoodArray:Array<Array<String>> = [];

		for (i in firstArray) {
			swagGoodArray.push(i.split('--'));
		}

		return swagGoodArray;
	}

	override function update(elapsed:Float) {
		#if SCRIPTS_ENABLED
		script.callFunction("update", [elapsed]);
		#end
		if (ClientPrefs.ogTitle) {
			if (controls.ACCEPT && !transitioning) {
				FlxG.sound.play(Files.music('titleShoot'));

				if (flash)
					FlxG.camera.flash(FlxColor.WHITE, 1);

				transitioning = true;
				FlxG.sound.music.stop();

				new FlxTimer().start(2, function(tmr:FlxTimer) {
					// Check if version is outdated
					{
						FlxG.switchState(new MainMenuState());
					}
				});
			}
			return;
		}

		if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

		if (FlxG.keys.justPressed.F) {
			FlxG.fullscreen = !FlxG.fullscreen;
			ClientPrefs.fullscreen = !ClientPrefs.fullscreen;
		}

		if (ClientPrefs.fullscreen)
			FlxG.fullscreen = true;

		var gamepad:FlxGamepad = FlxG.gamepads.lastActive;

		if (gamepad != null) {
			if (gamepad.justPressed.START)
				pressedEnter = true;
		}

		if (pressedEnter || controls.ACCEPT) {
			if (!transitioning && skippedIntro) {
				titleText.animation.play('press');

				if (flash)
					FlxG.camera.flash(FlxColor.WHITE, 1);

				FlxG.sound.play(Files.sound('confirmMenu'));

				transitioning = true;

				new FlxTimer().start(2, function(tmr:FlxTimer) {
					// Check if version is outdated
					{
						FlxG.switchState(new MainMenuState());
					}
				});
			}
		}

		if (pressedEnter || controls.ACCEPT)
			if (!skippedIntro)
				skipIntro();

		if (controls.LEFT)
			swagShader.update(elapsed * 0.1);
		if (controls.RIGHT)
			swagShader.update(-elapsed * 0.1);

		super.update(elapsed);

		#if SCRIPTS_ENABLED
		script.callFunction("updatePost", [elapsed]);
		#end
	}

	function createCoolText(textArray:Array<String>) {
		for (i in 0...textArray.length) {
			var money:Alphabet = new Alphabet(0, 0, textArray[i], true, false);
			money.screenCenter(X);
			money.y += (i * 60) + 200;
			credGroup.add(money);
			textGroup.add(money);
		}
	}

	function addMoreText(text:String) {
		var coolText:Alphabet = new Alphabet(0, 0, text, true, false);
		coolText.screenCenter(X);
		coolText.y += (textGroup.length * 60) + 200;
		credGroup.add(coolText);
		textGroup.add(coolText);
	}

	function deleteCoolText() {
		while (textGroup.members.length > 0) {
			credGroup.remove(textGroup.members[0], true);
			textGroup.remove(textGroup.members[0], true);
		}
	}

	override function beatHit() {
		super.beatHit();

		#if SCRIPTS_ENABLED
		script.callFunction("beatHit");
		#end

		if (skippedIntro) {
			logoBl.animation.play('bump');
			danceLeft = !danceLeft;

			gfDance.animation.play(danceLeft ? "danceLeft" : "danceRight");
		}

		switch (curBeat) {
			case 1:
				createCoolText(CoolUtil.coolTextFile(Files.txt('data/creators')));
			// credTextShit.visible = true;
			case 3:
				addMoreText('present');
			// credTextShit.text += '\npresent...';
			// credTextShit.addText();
			case 4:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = 'In association \nwith';
			// credTextShit.screenCenter();
			case 5:
				createCoolText(['In association', 'with']);
			case 7:
				addMoreText('newgrounds');
				ngSpr.visible = true;
			// credTextShit.text += '\nNewgrounds';
			case 8:
				deleteCoolText();
				ngSpr.visible = false;
			// credTextShit.visible = false;

			// credTextShit.text = 'Shoutouts Tom Fulp';
			// credTextShit.screenCenter();
			case 9:
				createCoolText([curWacky[0]]);
			// credTextShit.visible = true;
			case 11:
				addMoreText(curWacky[1]);
			// credTextShit.text += '\nlmao';
			case 12:
				deleteCoolText();
			// credTextShit.visible = false;
			// credTextShit.text = "Friday";
			// credTextShit.screenCenter();
			case 13:
				addMoreText('Friday');
			// credTextShit.visible = true;
			case 14:
				addMoreText('Night');
			// credTextShit.text += '\nNight';
			case 15:
				addMoreText('Funkin'); // credTextShit.text += '\nFunkin';
			case 16:
				skipIntro();
		}
	}

	function skipIntro():Void {
		if (!skippedIntro) {
			remove(ngSpr);

			if (flash)
				FlxG.camera.flash(FlxColor.WHITE, 4);

			remove(credGroup);
			skippedIntro = true;
			seenIntro = true;
		}
	}
}
