package states.menus;

import openfl.Assets;
import handlers.CoolUtil;
import scriptStuff.HiScript;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.input.keyboard.FlxKey;
import handlers.ClientPrefs;
import handlers.Files;
import handlers.MusicBeatState;
import states.menus.options.Options;
import flixel.FlxState;
#if discord_rpc
import handlers.DiscordHandler;
#end

using StringTools;

class MainMenuState extends MusicBeatState {
	public static var ugheasteregg:Bool = false;

	var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuItem:FlxSprite;

	var optionShit:Array<String> = ['story mode', 'freeplay', 'credits', 'options'];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	var funnyToggle:Bool = false;
	var funnyNumber:Int = 0;

	var easterEggKeys:Array<String> = ['TRISTAN', 'DDLC'];
	var curTristanFunny:Int = 0;
	var curDDLCFunny:Int = 0;

	#if SCRIPTS_ENABLED
	var script:HiScript;
	#end

	override function create() {
		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		var bg:FlxSprite = new FlxSprite(-80).loadGraphic(Files.image('menus/mainmenu/menuBG'));
		bg.scrollFactor.x = 0;
		bg.scrollFactor.y = 0.18;
		bg.setGraphicSize(Std.int(bg.width * 1.1));
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		#if SCRIPTS_ENABLED
		script = new HiScript('states/MainMenuState');
		if (!script.isBlank && script.expr != null) {
			script.interp.scriptObject = this;
			script.interp.execute(script.expr);
		}
		script.callFunction("create");
		#end

		if (!FlxG.sound.music.playing) {
			FlxG.sound.playMusic(Files.music('freakyMenu'));
		}

		persistentUpdate = persistentDraw = true;

		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadGraphic(Files.image('menus/mainmenu/menuDesat'));
		magenta.scrollFactor.x = 0;
		magenta.scrollFactor.y = 0.18;
		magenta.setGraphicSize(Std.int(magenta.width * 1.1));
		magenta.updateHitbox();
		magenta.screenCenter();
		magenta.visible = false;
		magenta.antialiasing = true;
		magenta.color = 0xFFfd719b;
		add(magenta);
		// magenta.scrollFactor.set();

		#if SCRIPTS_ENABLED
		script.callFunction("createBelowItems");
		#end

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length) {
			var tex = Files.sparrowAtlas('menus/mainmenu/donate');

			if (Assets.exists(Files.image('menus/mainmenu/${optionShit[i]}')))
				tex = Files.sparrowAtlas('menus/mainmenu/${optionShit[i]}');

			menuItem = new FlxSprite(0, 60 + (i * 150));
			menuItem.frames = tex;
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItem.scrollFactor.set();
			menuItem.antialiasing = true;
			menuItem.scale.set(0.9, 0.9);
		}

		FlxG.camera.follow(camFollow, null, 0.06);

		var versionShit:FlxText = new FlxText(5, FlxG.height - 36.2, 0, "v" + Application.current.meta.get('version') + "\n[M] - Mod Menu", 12);
		versionShit.scrollFactor.set();
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		changeItem();

		super.create();

		#if SCRIPTS_ENABLED
		script.callFunction("createPost");
		#end
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float) {
		#if SCRIPTS_ENABLED
		script.callFunction("update", [elapsed]);
		#end
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		
		#if discord_rpc
		DiscordHandler.changePresence('Viewing the menu', 'In the main menu', 'main menu');
		#end

		if (!selectedSomethin) {
			if (controls.UP_P) {
				FlxG.sound.play((Files.sound('scrollMenu')));
				changeItem(-1);
			}

			if (controls.DOWN_P) {
				FlxG.sound.play((Files.sound('scrollMenu')));
				changeItem(1);
			}

			if (FlxG.keys.justPressed.T) {
				FlxG.sound.play((Files.sound('confirmMenu')));
				if (!ClientPrefs.tankmanFloat) {
					ClientPrefs.tankmanFloat = true;
					trace("Secret Found!");
				} else
					ClientPrefs.tankmanFloat = false;
			}
			var boolArray:Array<Bool> = [
				(FlxG.keys.justPressed.T),
				(FlxG.keys.justPressed.R),
				(FlxG.keys.justPressed.I),
				(FlxG.keys.justPressed.S),
				(FlxG.keys.justPressed.T),
				(FlxG.keys.justPressed.A),
				(FlxG.keys.justPressed.N)
			];
			if (boolArray[curTristanFunny]) {
				curTristanFunny++;
				if (curTristanFunny >= 7) {
					curTristanFunny = 0;
					FlxG.sound.play(Files.sound('confirmMenu'));
					if (!ClientPrefs.tristanPlayer) {
						ClientPrefs.tristanPlayer = true;
						trace("tristan mode enabled");
					} else {
						ClientPrefs.tristanPlayer = false;
						trace("tristan mode disabled");
					}
				}
			}

			#if MODS_ENABLED
			if (FlxG.keys.justPressed.M) {
				persistentUpdate = false;
				openSubState(new states.etc.substates.ModSelectSubstate());
				return;
			}
			#end

			if (FlxG.keys.justPressed.U)
				ugheasteregg = !ugheasteregg;

			if (controls.BACK)
				FlxG.switchState(new TitleState());

			if (controls.ACCEPT) {
				if (optionShit[curSelected] == 'discord')
					CoolUtil.openLink('https://discord.gg/MsnfKgzMzV');
				else {
					selectedSomethin = true;
					FlxG.sound.play(Files.sound('confirmMenu'));

					if (ClientPrefs.flashingLights)
						FlxFlicker.flicker(magenta, 1.1, 0.15, false);

					menuItems.forEach(function(spr:FlxSprite) {
						if (curSelected != spr.ID) {
							FlxTween.tween(spr, {alpha: 0}, 0.4, {
								ease: FlxEase.quadOut,
								onComplete: function(twn:FlxTween) {
									spr.kill();
								}
							});
						} else {
							FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker) {
								var daChoice:String = optionShit[curSelected];

								switch (daChoice) {
									case 'story mode':
										FlxG.switchState(new StoryMenuState());
										trace("Story Menu Selected");
									case 'freeplay':
										FlxG.switchState(new FreeplayState());
										trace("Freeplay Menu Selected");
									case 'options':
										FlxG.switchState(new Options());
										trace("Options Menu Selected");
									case 'credits':
										FlxG.switchState(new CreditsState());
										trace("Credits Menu Selected");
								}
							});
						}
					});
				}
			}
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite) {
			spr.screenCenter(X);
		});

		#if SCRIPTS_ENABLED
		script.callFunction("updatePost", [elapsed]);
		#end
	}

	function changeItem(huh:Int = 0) {
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite) {
			spr.animation.play('idle');

			if (spr.ID == curSelected) {
				spr.animation.play('selected');
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y);
			}

			spr.updateHitbox();
		});
	}
}
