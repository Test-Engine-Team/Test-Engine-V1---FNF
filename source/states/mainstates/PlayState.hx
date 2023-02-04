package states.mainstates;

import haxe.io.Path;
import openfl.Assets;

import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.system.FlxSound;
import flixel.math.FlxPoint;
import flixel.math.FlxMath;
import flixel.math.FlxRect;
import flixel.text.FlxText;
import flixel.FlxSubState;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxTimer;
import states.menus.MainMenuState;
import states.menus.FreeplayState;
import states.menus.StoryMenuState;
import states.debug.AnimationDebug;
import states.etc.substates.GitarooPause;
import states.etc.substates.GameOverState;
import states.etc.substates.PauseSubState;
import states.etc.cutscenes.ScriptCutscene;

import scriptStuff.EventStructures;
import scriptStuff.HiScript;

import ui.Note;
import ui.HealthIcon;

import handlers.MusicBeatState;
import handlers.ClientPrefs;
import handlers.Highscore;
import handlers.Conductor;
import handlers.Character;
import handlers.Files;
import handlers.Stage;
import handlers.NoteSplash;
#if desktop
import handlers.DiscordHandler;
#end
import Section.SwagSection;
import Song.SwagSong;
import Controls;

using StringTools;

class PlayState extends MusicBeatState {
	public static var curStage:String = '';
	public static var SONG:SwagSong;
	public static var songPath:String;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:String = "tutorial";
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var speed:Int = 1;
	public static var diff:String;

	public var scripts:Array<HiScript> = [];

	private var vocals:FlxSound;

	public var dad:Character;
	public var gf:Character;
	public var boyfriend:Character;

	var stage:Stage;

	public var elapsedtime:Float = 0;

	private var notes:FlxTypedGroup<Note>;
	private var unspawnNotes:Array<Note> = [];

	private var strumLine:FlxSprite;
	private var curSection:Int = 0;

	private var camFollow:FlxObject;

	private static var prevCamFollow:FlxObject;

	private static var dadSingLeft:Float = 0;
	private static var dadSingDown:Float = 0;
	private static var dadSingUp:Float = 0;
	private static var dadSingRight:Float = 0;

	private static var bfSingLeft:Float = 0;
	private static var bfSingDown:Float = 0;
	private static var bfSingUp:Float = 0;
	private static var bfSingRight:Float = 0;

	private var strumLineNotes:FlxTypedGroup<FlxSprite>;
	private var playerStrums:FlxTypedGroup<FlxSprite>;

	private var camZooming:Bool = false;

	private var gfSpeed:Int = 1;
	private var health:Float = 1;
	private var combo:Int = 0;
	private var notesHit:Int = 0;
	private var sicks:Int = 0;
	private var goods:Int = 0;
	private var bads:Int = 0;
	private var shits:Int = 0;
	private var poisonTimes:Int = 0;

	private var healthBarBG:FlxSprite;
	private var healthBar:FlxBar;

	// private var timeBarBG:FlxSprite;
	// private var timeBar:FlxBar;
	private var generatedMusic:Bool = false;
	private var startingSong:Bool = false;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	private var camGame:FlxCamera;

	var dialogue:Array<String> = ['dad:blah blah blah', 'bf:coolswag'];

	var talking:Bool = true;
	var songScore:Int = 0;
	var songMisses:Int = 0;
	var fcing:Bool = false;
	var infoText:FlxText;

	var grpNoteSplashes:FlxTypedGroup<NoteSplash>;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	public var foregroundSprites:FlxTypedGroup<FlxSprite>;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;

	public static var pixelStage:Bool = false;

	var inTransition:Bool = true;

	@:unreflective private var gameControls:Controls;

	override public function create() {
		gameControls = new Controls("gameControls", None);
		gameControls.bindKeys(Control.LEFT, ClientPrefs.leftKeybinds);
		gameControls.bindKeys(Control.DOWN, ClientPrefs.downKeybinds);
		gameControls.bindKeys(Control.UP, ClientPrefs.upKeybinds);
		gameControls.bindKeys(Control.RIGHT, ClientPrefs.rightKeybinds);
		gameControls.bindKeys(Control.RESET, [ClientPrefs.resetKeybind]);

		#if debug
		ClientPrefs.tankmanFloat = true;
		#end
		camGame = new FlxCamera();
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		camHUD.alpha = ClientPrefs.uiAlpha;
		if (ClientPrefs.uiAlpha == 0)
			camHUD.visible = false;
		// for those who set the cam hud to 0, its mainly for gifs and botplay videos.

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD);

		FlxCamera.defaultCameras = [camGame];

		// prevFramerateStuff = FlxG.updateFramerate;

		diff = Highscore.diffArray[storyDifficulty].toUpperCase();

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson(songPath = 'tutorial');

		#if SCRIPTS_ENABLED
		// Song Scripts
		for (file in Files.readFolder('data/$songPath')) {
			if (HiScript.allowedExtensions.contains(Path.extension(file)) && Path.withoutExtension(file) != "DIALOGUE_ADVANCED" && Path.withoutExtension(file) != "cutscene")
				scripts.push(new HiScript('assets/data/$songPath/' + Path.withoutExtension(file)));
		}
		// Global Scripts
		for (file in Files.readFolder('gameScripts')) {
			if (HiScript.allowedExtensions.contains(Path.extension(file)))
				scripts.push(new HiScript('assets/gameScripts/' + Path.withoutExtension(file)));
		}
		#end

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		/*switch (SONG.song.toLowerCase()) {
			case 'senpai':
				dialogue = CoolUtil.coolTextFile('assets/data/senpai/senpaiDialogue.txt');
			case 'roses':
				dialogue = CoolUtil.coolTextFile('assets/data/roses/rosesDialogue.txt');
			case 'thorns':
				dialogue = CoolUtil.coolTextFile('assets/data/thorns/thornsDialogue.txt');
		}*/

		var gfVersion:String = 'gf';

		var stageName = SONG.stage;
		if (stageName == null) {
			stageName = switch (SONG.song.toLowerCase()) {
				case 'spookeez' | 'south' | 'monster': "spooky";
				case 'pico' | 'philly' | 'blammed': "philly";
				case 'satin-panties' | 'high' | 'milf': "limo";
				case 'cocoa' | 'eggnog': "mall";
				case 'winter-horrorland': "mallEvil";
				case 'senpai' | 'roses': "school";
				case 'thorns': "schoolEvil";
				case 'ugh' | 'guns' | 'stress': "tank";
				default: "stage";
			}
		}

		switch (stageName) {
			case 'limo':
				gfVersion = 'gf-car';
			case 'mall' | 'mallEvil':
				gfVersion = 'gf-christmas';
			case 'school':
				gfVersion = 'gf-pixel';
			case 'schoolEvil':
				gfVersion = 'gf-pixel';
			case 'tank':
				if (SONG.song.toLowerCase() != 'stress')
					gfVersion = 'gf-at-gunpoint';
		}

		gf = new Character(400, 130, gfVersion);
		gf.scrollFactor.set(0.95, 0.95);

		dad = new Character(100, 100, SONG.player2);

		var camPos:FlxPoint = new FlxPoint(dad.getGraphicMidpoint().x, dad.getGraphicMidpoint().y);

		switch (SONG.player2) {
			case 'gf':
				dad.regX = gf.regX;
				dad.regY = gf.regY;
				gf.visible = false;
				if (isStoryMode) {
					camPos.x += 600;
					tweenCamIn();
				}

			case 'dad':
				camPos.x += 400;
			case 'pico':
				camPos.x += 600;
			case 'senpai':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'senpai-angry':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
			case 'spirit':
				camPos.set(dad.getGraphicMidpoint().x + 300, dad.getGraphicMidpoint().y);
		}

		if (SONG.player1 == null)
			SONG.player1 = 'bf';

		boyfriend = new Character(770, 100, SONG.player1, true);

		stage = new Stage(stageName, this);
		add(stage);
		#if SCRIPTS_ENABLED
		for (script in scripts) {
			if (script.isBlank || script.expr == null)
				continue;
			script.interp.scriptObject = this;
			script.setValue("addScript", function(scriptPath:String) {
				scripts.push(new HiScript(scriptPath));
			});
			script.interp.execute(script.expr);
		}
		scripts_call("create", [], false);

		//scripts_call("createInFront", [], false);
		#end

		add(foregroundSprites);

		/*var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;*/

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(0, 50).makeGraphic(FlxG.width, 10);
		// if(ClientPrefs.downscroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		strumLineNotes = new FlxTypedGroup<FlxSprite>();
		add(strumLineNotes);

		// fake notesplash cache type deal so that it loads in the graphic?

		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		var noteSplash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(noteSplash);
		noteSplash.alpha = 0.1;
		noteSplash.visible = ClientPrefs.noteSplashes;

		add(grpNoteSplashes);

		playerStrums = new FlxTypedGroup<FlxSprite>();

		// startCountdown();

		generateSong(SONG.song);

		// add(strumLine);

		camFollow = new FlxObject(0, 0, 1, 1);

		var dadMidPoint = dad.getMidpoint();
		camFollow.x = dadMidPoint.x + 150 + dad.charData.offsets[2] + stage.offsets.dadCamX;
		camFollow.y = dadMidPoint.y - 100 + dad.charData.offsets[3] + stage.offsets.dadCamY;

		if (prevCamFollow != null) {
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}

		add(camFollow);

		FlxG.camera.follow(camFollow, LOCKON, 0.04);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow.getPosition());

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;

		healthBarBG = new FlxSprite(0, FlxG.height * 0.9).loadGraphic('assets/images/healthBar.png');
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		add(healthBarBG);
		if (ClientPrefs.downscroll)
			healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.createFilledBar(dad.hpcolor, boyfriend.hpcolor);
		add(healthBar);

		infoText = new FlxText(0, healthBarBG.y + 40, FlxG.width, "", 20);
		infoText.setFormat("assets/fonts/vcr.ttf", 16, FlxColor.WHITE, FlxTextAlign.CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		infoText.scrollFactor.set();
		add(infoText);

		iconP1 = new HealthIcon(boyfriend.charData.iconImage, true);
		iconP1.y = healthBar.y - (iconP1.height / 2);
		add(iconP1);

		iconP2 = new HealthIcon(dad.charData.iconImage, false);
		iconP2.y = healthBar.y - (iconP2.height / 2);
		add(iconP2);

		grpNoteSplashes.cameras = [camHUD];
		strumLineNotes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		infoText.cameras = [camHUD];
		//doof.cameras = [camHUD];

		startingSong = true;

		/*if (isStoryMode || ClientPrefs.freeplayCutscenes) {
			switch (SONG.song.toLowerCase()) {
				case "winter-horrorland":
					var blackScreen:FlxSprite = new FlxSprite(0, 0).makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
					add(blackScreen);
					blackScreen.scrollFactor.set();
					camHUD.visible = false;

					new FlxTimer().start(0.1, function(tmr:FlxTimer) {
						remove(blackScreen);
						FlxG.sound.play(Files.sound('Lights_Turn_On'));
						camFollow.y = -2050;
						camFollow.x += 200;
						FlxG.camera.focusOn(camFollow.getPosition());
						FlxG.camera.zoom = 1.5;

						new FlxTimer().start(0.8, function(tmr:FlxTimer) {
							camHUD.visible = true;
							remove(blackScreen);
							FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, 2.5, {
								ease: FlxEase.quadInOut,
								onComplete: function(twn:FlxTween) {
									startCountdown();
								}
							});
						});
					});
				case 'senpai', 'roses', 'thorns':
					schoolIntro(doof);
					if (SONG.song.toLowerCase() == 'roses')
						FlxG.sound.play(Files.sound('ANGRY'));
				default:
					startCountdown();
			}
		} else {
			switch (SONG.song.toLowerCase()) {
				default:
					startCountdown();
			}
		}*/

		super.create();
		#if SCRIPTS_ENABLED scripts_call("createPost");
		scripts_call("postCreate"); #end
	}

	override function finishTransIn() {
		var canCutscene:Bool = (isStoryMode || ClientPrefs.freeplayCutscenes);
		inTransition = false;
		var boolArray:Array<Bool> = [
			(Files.fileExists('data/$songPath', 'cutscene', 'txt') && canCutscene), 
			(Files.fileExists('data/$songPath', 'HARDCODED_CUTSCENE', 'txt') && canCutscene), 
			(Files.fileExists('data/$songPath', 'cutscene', 'mp4') && canCutscene),
		];
		#if SCRIPTS_ENABLED
		for (ext in HiScript.allowedExtensions)
			boolArray.push((Files.fileExists('data/$songPath', 'cutscene', ext) && canCutscene));
		#end
		switch (boolArray.indexOf(true)) {
			#if (SCRIPTS_ENABLED) case -1: #else default: #end
				startCountdown();
			case 0:
				persistentUpdate = false;
				persistentDraw = true;

				var cutscene = new states.etc.cutscenes.DialogueCutscene('assets/data/$songPath/cutscene.txt');
				cutscene.finishCutscene = function(twn:FlxTween) {
					cutscene.close();
					startCountdown();
				}
				openSubState(cutscene);
			case 1:
				persistentUpdate = false;
				persistentDraw = true;

				var cutscene = new states.etc.cutscenes.HardcodedCutscene('assets/data/$songPath/HARDCODED_CUTSCENE.txt');
				cutscene.finishCutscene = function() {
					cutscene.close();
					startCountdown();
				}
				openSubState(cutscene);
			case 2:
				startCountdown(); // Not implemented yet because brandon removed hxCodec
			#if SCRIPTS_ENABLED
			default:
				persistentUpdate = false;
				persistentDraw = true;

				var finishCallback = startCountdown;
				var cutscene = new states.etc.cutscenes.ScriptCutscene('assets/data/$songPath/cutscene', finishCallback, this);
				openSubState(cutscene);
			#end
		}
	}

	/*function schoolIntro(?dialogueBox:DialogueBox):Void {
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Files.sparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();

		if (SONG.song.toLowerCase() == 'roses' || SONG.song.toLowerCase() == 'thorns') {
			remove(black);

			if (SONG.song.toLowerCase() == 'thorns') {
				camHUD.visible = false;
				add(red);
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer) {
			black.alpha -= 0.15;

			if (black.alpha > 0) {
				tmr.reset(0.3);
			} else {
				if (dialogueBox != null) {
					//inCutscene = true;

					if (SONG.song.toLowerCase() == 'thorns') {
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer) {
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1) {
								swagTimer.reset();
							} else {
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Files.sound('Senpai_Dies'), 1, false, null, true, function() {
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function() {
										add(dialogueBox);
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer) {
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					} else {
						add(dialogueBox);
					}
				} else
					startCountdown();

				remove(black);
			}
		});
	}*/

	var startTimer:FlxTimer;
	var perfectMode:Bool = false;

	function startCountdown():Void {
		generateStaticArrows(0);
		generateStaticArrows(1);

		//inCutscene = false;

		talking = false;
		startedCountdown = true;
		Conductor.songPosition = 0;
		Conductor.songPosition -= Conductor.crochet * 5;

		#if SCRIPTS_ENABLED scripts_call("countdownStart"); #end

		var swagCounter:Int = 0;

		startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer) {
			dad.dance();
			gf.dance();
			boyfriend.dance();

			var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
			introAssets.set('default', ['ready.png', "set.png", "go.png"]);
			introAssets.set('school', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);
			introAssets.set('schoolEvil', [
				'weeb/pixelUI/ready-pixel.png',
				'weeb/pixelUI/set-pixel.png',
				'weeb/pixelUI/date-pixel.png'
			]);

			var introAlts:Array<String> = introAssets.get('default');
			var altSuffix:String = "";

			for (value in introAssets.keys()) {
				if (value == curStage) {
					introAlts = introAssets.get(value);
					altSuffix = '-pixel';
				}
			}

			switch (swagCounter) {

				case 0:
					FlxG.sound.play(Files.sound('intro3$altSuffix'), 0.6);
				case 1:
					var ready:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[0]);
					ready.scrollFactor.set();
					ready.updateHitbox();

					if (curStage.startsWith('school'))
						ready.setGraphicSize(Std.int(ready.width * daPixelZoom));

					ready.screenCenter();
					add(ready);
					FlxTween.tween(ready, {y: ready.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							ready.destroy();
						}
					});
					FlxG.sound.play(Files.sound('intro2$altSuffix'), 0.6);
				case 2:
					var set:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[1]);
					set.scrollFactor.set();

					if (curStage.startsWith('school'))
						set.setGraphicSize(Std.int(set.width * daPixelZoom));

					set.screenCenter();
					add(set);
					FlxTween.tween(set, {y: set.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							set.destroy();
						}
					});
					FlxG.sound.play(Files.sound('intro1$altSuffix'), 0.6);
				case 3:
					var go:FlxSprite = new FlxSprite().loadGraphic('assets/images/' + introAlts[2]);
					go.scrollFactor.set();

					if (curStage.startsWith('school'))
						go.setGraphicSize(Std.int(go.width * daPixelZoom));

					go.updateHitbox();

					go.screenCenter();
					add(go);
					FlxTween.tween(go, {y: go.y += 100, alpha: 0}, Conductor.crochet / 1000, {
						ease: FlxEase.cubeInOut,
						onComplete: function(twn:FlxTween) {
							go.destroy();
						}
					});
					FlxG.sound.play(Files.sound('introGo$altSuffix'), 0.6);
				case 4:
			}

			swagCounter += 1;
			// generateSong('fresh');
		}, 5);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void {
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		var instPath:String = (Assets.exists(Files.songInst(SONG.song))) ? Files.songInst(SONG.song) : Files.songInst(songPath);
		if (!paused)
			FlxG.sound.playMusic(instPath, 1, false);
		FlxG.sound.music.onComplete = endSong;
		vocals.play();

		#if SCRIPTS_ENABLED scripts_call("songStart"); #end
	}

	var debugNum:Int = 0;

	private function generateSong(dataPath:String):Void {
		// FlxG.log.add(ChartParser.parse());

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		SONG.song = songData.song;

		var vocalsPath:String = (Assets.exists(Files.songVoices(SONG.song))) ? Files.songVoices(SONG.song) : Files.songVoices(songPath);
		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(vocalsPath);
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped
		for (section in noteData) {
			for (songNotes in section.sectionNotes) {
				var noteCreateParams:NoteCreateParams = {
					makeNote: (songNotes[1] >= 0),
					jsonData: songNotes,
					sectionData: section,
					spritePath: "NOTE_assets",
					holdSpritePath: null,
					antialiasing: true,
					canMiss: true,
					botCanHit: true,
					scale: 0.7,
					spriteType: "sparrow",
					animFPS: 24,
					noteAnims: ["purple0", "blue0", "green0", "red0"],
					holdAnims: ["purple hold piece", "blue hold piece", "green hold piece", "red hold piece"],
					tailAnims: ["pruple end hold", "blue hold end", "green hold end", "red hold end"],
					noteType: "default"
				};
				#if SCRIPTS_ENABLED
				scripts_call("noteCreate", [noteCreateParams]);
				if (!noteCreateParams.makeNote)
					continue;
				#else
				if (stage.curStage.startsWith("school")) {
					noteCreateParams.spritePath = "weeb/pixelUI/arrows-pixels";
					noteCreateParams.holdSpritePath = "weeb/pixelUI/arrowEnds";
					noteCreateParams.spriteType = "grid";
					noteCreateParams.antialiasing = false;
					noteCreateParams.animFPS = 12;
					noteCreateParams.scale = 6;
				}
				#end
				var daStrumTime:Float = noteCreateParams.jsonData[0];
				var daNoteData:Int = Std.int(noteCreateParams.jsonData[1] % 4);

				var gottaHitNote:Bool = (section.mustHitSection && noteCreateParams.jsonData[1] % 8 <= 3)
					|| (!section.mustHitSection && noteCreateParams.jsonData[1] % 8 > 3);

				var oldNote:Note = null;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote, false, noteCreateParams);
				swagNote.sustainLength = songNotes[2];
				swagNote.scrollFactor.set();
				unspawnNotes.push(swagNote);

				var sustainNotes:Array<Note> = []; // For noteCreatePost.
				for (susNote in 0...Math.floor(swagNote.sustainLength / Conductor.stepCrochet)) {
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

					var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + Conductor.stepCrochet, daNoteData, oldNote, true,
						noteCreateParams);
					sustainNote.flipY = ClientPrefs.downscroll;
					sustainNote.scrollFactor.set();
					unspawnNotes.push(sustainNote);
					sustainNotes.push(sustainNote);

					sustainNote.mustPress = gottaHitNote;

					if (sustainNote.mustPress)
						sustainNote.x += FlxG.width / 2; // general offset
				}

				swagNote.mustPress = gottaHitNote;

				if (swagNote.mustPress)
					swagNote.x += FlxG.width / 2; // general offset
				#if SCRIPTS_ENABLED
				scripts_call("noteCreatePost", [swagNote, sustainNotes]);
				#end
			}
			daBeats += 1;
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);

		generatedMusic = true;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int {
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	private function generateStaticArrows(player:Int):Void {
		for (i in 0...4) {
			var strumCreateParams:StrumCreateParams = {
				id: i,
				player: player,
				scale: 0.7,
				spritePath: "NOTE_assets",
				spriteType: "sparrow",
				tweenWhenCreated: !isStoryMode,
				antialiasing: true,
				animFPS: 24,
				glowAnims: ["left confirm", "down confirm", "up confirm", "right confirm"],
				ghostAnims: ["left press", "down press", "up press", "right press"],
				staticAnims: ["arrowLEFT", "arrowDOWN", "arrowUP", "arrowRIGHT"]
			};
			#if SCRIPTS_ENABLED
			scripts_call("strumCreate", [strumCreateParams]);
			#else
			if (stage.curStage.startsWith("school")) {
				strumCreateParams.spritePath = "weeb/pixelUI/arrows-pixels";
				strumCreateParams.spriteType = "grid";
				strumCreateParams.tweenWhenCreated = false;
				strumCreateParams.antialiasing = false;
				strumCreateParams.animFPS = 12;
				strumCreateParams.scale = 6;
			}
			#end

			// FlxG.log.add(i);
			var babyArrow:FlxSprite = new FlxSprite(0, strumLine.y);

			switch (strumCreateParams.spriteType) {
				case "packer":
					babyArrow.frames = Files.packerAtlas(strumCreateParams.spritePath);
					babyArrow.animation.addByPrefix("static", strumCreateParams.staticAnims[i], strumCreateParams.animFPS);
					babyArrow.animation.addByPrefix('pressed', strumCreateParams.ghostAnims[i], strumCreateParams.animFPS, false);
					babyArrow.animation.addByPrefix("confirm", strumCreateParams.glowAnims[i], strumCreateParams.animFPS, false);
				case "grid":
					var bitmapData:openfl.display.BitmapData = Assets.getBitmapData(Files.image(strumCreateParams.spritePath));
					babyArrow.loadGraphic(bitmapData, true, Std.int(bitmapData.width / 4), Std.int(bitmapData.height / 5));
					babyArrow.animation.add("static", [i], strumCreateParams.animFPS);
					babyArrow.animation.add("pressed", [i + 4, i + 8], strumCreateParams.animFPS, false);
					babyArrow.animation.add("confirm", [i + 12, i + 16], strumCreateParams.animFPS, false);
				default:
					babyArrow.frames = Files.sparrowAtlas(strumCreateParams.spritePath);
					babyArrow.animation.addByPrefix("static", strumCreateParams.staticAnims[i], strumCreateParams.animFPS);
					babyArrow.animation.addByPrefix('pressed', strumCreateParams.ghostAnims[i], strumCreateParams.animFPS, false);
					babyArrow.animation.addByPrefix("confirm", strumCreateParams.glowAnims[i], strumCreateParams.animFPS, false);
			}

			babyArrow.antialiasing = strumCreateParams.antialiasing;
			babyArrow.scale.set(strumCreateParams.scale, strumCreateParams.scale);
			babyArrow.x += Note.swagWidth * i;
			babyArrow.updateHitbox();
			babyArrow.scrollFactor.set();

			if (strumCreateParams.tweenWhenCreated) {
				babyArrow.y -= 10;
				babyArrow.alpha = 0;
				var daY:Float = babyArrow.y + 10;
				if (ClientPrefs.downscroll)
					daY = FlxG.height - daY - babyArrow.height;
				FlxTween.tween(babyArrow, {y: daY, alpha: 1}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}

			babyArrow.ID = i;

			if (player == 1)
				playerStrums.add(babyArrow);

			babyArrow.animation.play('static');
			babyArrow.x += FlxG.width / 16;
			babyArrow.x += ((FlxG.width / 2) * player);

			strumLineNotes.add(babyArrow);
			if (ClientPrefs.downscroll)
				babyArrow.y = FlxG.height - babyArrow.y - babyArrow.height;
			#if SCRIPTS_ENABLED scripts_call("strumCreatePost", [babyArrow]); #end
		}
	}

	function tweenCamIn():Void {
		FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
	}

	override function openSubState(SubState:FlxSubState) {
		if (paused) {
			if (FlxG.sound.music != null) {
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (!startTimer.finished)
				startTimer.active = false;
		}

		super.openSubState(SubState);
	}

	override function closeSubState() {
		if (paused) {
			if (FlxG.sound.music != null && !startingSong) {
				resyncVocals();
			}

			if (!startTimer.finished)
				startTimer.active = true;
			paused = false;
		}

		super.closeSubState();
	}

	function resyncVocals():Void {
		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		vocals.time = Conductor.songPosition;
		vocals.play();
	}

	private var paused:Bool = false;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float) {
		elapsedtime += elapsed;

		if (FlxG.keys.justPressed.NINE) {
			iconP1.changeIcon((iconP1.char == "bf-old") ? boyfriend.charData.iconImage : "bf-old");
			#if SCRIPTS_ENABLED scripts_call("oldBfChange"); #end
		}

		health -= ClientPrefs.constantDrain * 1 / 700000;
		health += ClientPrefs.constantHeal * -1 / 700000;

		if (ClientPrefs.limitMisses)
			health = 1;

		super.update(elapsed);
		#if SCRIPTS_ENABLED
		if (!inTransition)
			scripts_call("update", [elapsed], false); 
		#end

		if (songMisses > 0)
			fcing = false;

		if (speed != 1) {
			Conductor.songPosition += elapsed * speed * 100;
			FlxG.sound.music.time += elapsed * speed * 100;
			vocals.time += elapsed * speed * 100;
		}

		if (songMisses >= 1 && ClientPrefs.fcMode)
			health -= 9999;
		if (songMisses == ClientPrefs.maxMisses && ClientPrefs.limitMisses)
			health -= 9999;
		if (health <= 0 && !ClientPrefs.practice)
			health = 0;

		if (ClientPrefs.spinnyspin)
			FlxG.camera.angle += elapsed * 50;

		switch (curStep) {
			case 60, 444, 524, 540, 542, 828:
				// until we code in alt notes
				if (SONG.song.toLowerCase() == 'ugh')
					event('play anim', 'tankman', 'Ugh');
				if (MainMenuState.ugheasteregg && SONG.song.toLowerCase() == 'ugh') {
					event('image flash', 'vineboom', null);
					FlxG.sound.play(Files.sound('vineboom'), 0.6);
				}
		}

		if (curStep > 895 && curStep < 1398 && SONG.song.toLowerCase() == 'guns' && ClientPrefs.tankmanFloat == true) {
			dad.regY += (Math.sin(elapsedtime) * 0.2);
			if (!PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
				camFollow.y = dad.getMidpoint().y;
			}
		}
		if (curStep > 1024 && curStep < 1439 && SONG.song.toLowerCase() == 'guns' && ClientPrefs.tankmanFloat == true) {
			boyfriend.regY += (Math.sin(elapsedtime) * 0.2);
			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
				camFollow.y = boyfriend.getMidpoint().y;
			}
		}

		if (fcing)
		{
			if (ClientPrefs.limitMisses) {
				infoText.text = "Score: " + songScore + " || Misses: " + songMisses + " (FC) / " + ClientPrefs.maxMisses + " || Combo: " + combo + " || Notes Hit: " + notesHit;
			}
			else 
			{
				infoText.text = "Score: " + songScore + " || Misses: " + songMisses + " (FC) || Combo: " + combo + " || Notes Hit: " + notesHit;
			}
		}
		else
		{
			if (ClientPrefs.limitMisses) {
				infoText.text = "Score: " + songScore + " || Misses: " + songMisses + " / " + ClientPrefs.maxMisses + " || Combo: " + combo + " || Notes Hit: " + notesHit;
			}
			else 
			{
				infoText.text = "Score: " + songScore + " || Misses: " + songMisses + " || Combo: " + combo + " || Notes Hit: " + notesHit;
			}
		}

		#if desktop
		DiscordHandler.changePresence('Playing ' + SONG.song.toLowerCase() + '-' + diff, 'With ' + songScore + ' Score And ' + songMisses + ' Misses');
		#end

		if (PlayState.curStage.startsWith('school'))
			pixelStage = true;

		if (FlxG.keys.justPressed.ENTER && startedCountdown && canPause) {
			persistentUpdate = false;
			persistentDraw = true;
			paused = true;

			openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (FlxG.keys.justPressed.SEVEN) {
			FlxG.switchState(new states.debug.ChartingState());
			#if SCRIPTS_ENABLED scripts_call("chartPress"); #end
			#if desktop
			DiscordHandler.changePresence('Charting ', SONG.song.toLowerCase());
			#end
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		iconP1.setGraphicSize(Std.int(FlxMath.lerp(150, iconP1.width, 0.50)));
		iconP2.setGraphicSize(Std.int(FlxMath.lerp(150, iconP2.width, 0.50)));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01) - iconOffset);
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (iconP2.width - iconOffset);

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.keys.justPressed.FIVE)
			FlxG.switchState(new AnimationDebug(SONG.player2));

		if (FlxG.keys.justPressed.SIX)
			FlxG.switchState(new AnimationDebug(SONG.player1));

		if (startingSong) {
			if (startedCountdown) {
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		} else {
			// Conductor.songPosition = FlxG.sound.music.time;
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused) {
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition) {
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (generatedMusic && PlayState.SONG.notes[Std.int(curStep / 16)] != null) {
			var opOffsetX:Float = (dad.regX == gf.regX && dad.regY == gf.regY) ? stage.offsets.gfCamX : stage.offsets.dadCamX;
			var opOffsetY:Float = (dad.regX == gf.regX && dad.regY == gf.regY) ? stage.offsets.gfCamY : stage.offsets.dadCamY;
			var bfMidpoint = boyfriend.getMidpoint();
			var dadMidpoint = dad.getMidpoint();

			if (camFollow.x != dadMidpoint.x + 150 + dad.charData.offsets[2] + opOffsetX && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
				camFollow.x = dadMidpoint.x + 150 + dad.charData.offsets[2] + opOffsetX;
				camFollow.y = dadMidpoint.y - 100 + dad.charData.offsets[3] + opOffsetY;

				if (dad.curCharacter == 'mom')
					vocals.volume = 1;

				if (SONG.song.toLowerCase() == 'tutorial') {
					tweenCamIn();
				}
			}

			if (PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection
				&& camFollow.x != bfMidpoint.x
					- 100
					- boyfriend.charData.offsets[2]
					+ stage.offsets.bfCamX) {
				camFollow.x = bfMidpoint.x - 100 - boyfriend.charData.offsets[2] + stage.offsets.bfCamX;
				camFollow.y = bfMidpoint.y - 100 + boyfriend.charData.offsets[3] + stage.offsets.bfCamY;

				if (SONG.song.toLowerCase() == 'tutorial') {
					FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut});
				}
			}
		}

		if (camZooming) {
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, 0.95);
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, 0.95);
		}

		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		if (SONG.song == 'Fresh') {
			switch (curBeat) {
				case 16:
					camZooming = true;
					gfSpeed = 2;
				case 48:
					gfSpeed = 1;
				case 80:
					gfSpeed = 2;
				case 112:
					gfSpeed = 1;
				case 163:
					// FlxG.sound.music.stop();
					// FlxG.switchState(new TitleState());
			}
		}
		// better streaming of shit

		// RESET = Quick Game Over Screen
		if (gameControls.RESET) {
			health = 0;
			trace("RESET = True");
		}

		// CHEAT = brandon's a pussy
		if (controls.CHEAT) {
			health += 1;
			trace("User is cheating!");
		}

		if (health <= 0 && !ClientPrefs.practice) {
			boyfriend.stunned = true;

			persistentUpdate = false;
			persistentDraw = false;
			paused = true;

			vocals.stop();
			FlxG.sound.music.stop();

			#if debug
			trace("ded");
			#end
			
			#if SCRIPTS_ENABLED
			scripts_call("onDeath", [], false);
			#end

			// 1 / 1000 chance for Gitaroo Man easter egg
			if (FlxG.random.bool(0.1)) {
				// gitaroo man easter egg
				FlxG.switchState(new GitarooPause());
			} else
				openSubState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		}

		if (unspawnNotes[0] != null) {
			if (unspawnNotes[0].strumTime - Conductor.songPosition < 1500) {
				var dunceNote:Note = unspawnNotes[0];
				notes.add(dunceNote);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic) {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.y > FlxG.height) {
					daNote.active = false;
					daNote.visible = false;
				} else {
					daNote.visible = true;
					daNote.active = true;
				}

				daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));

				// i am so fucking sorry for this if condition
				if (daNote.isSustainNote
					&& daNote.y + daNote.offset.y <= strumLine.y + Note.swagWidth / 2
					&& (!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit)))) {
					var swagRect = new FlxRect(0, strumLine.y + Note.swagWidth / 2 - daNote.y, daNote.width * 2, daNote.height * 2);
					swagRect.y /= daNote.scale.y;
					swagRect.height -= swagRect.y;

					daNote.clipRect = swagRect;
				}

				if (!daNote.mustPress && daNote.wasGoodHit && daNote.dadCanHit) {
					var animList:Array<String> = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
					var animSuffix:String = (SONG.notes[Math.floor(curStep / 16)] != null
						&& SONG.notes[Math.floor(curStep / 16)].altAnim) ? "-alt" : "";
					var noteHitParams:NoteHitParams = {
						note: daNote,
						jsonData: daNote.jsonData,
						charForAnim: dad,
						animToPlay: animList[daNote.noteData] + animSuffix,
						enableZoom: (SONG.song != "Tutorial"),
						deleteNote: true,
						strumGlow: true,
						rateNote: false,
						noteSplashes: false,
						camMoveOnHit: true
					}
					#if SCRIPTS_ENABLED scripts_call("dadNoteHit", [noteHitParams]); #end

					if (noteHitParams.enableZoom)
						camZooming = true;

					if (ClientPrefs.fairFight) {
						if (SONG.song == 'High' || SONG.song == 'Test' || SONG.song == 'Cocoa' || SONG.song == 'Ugh')
							health -= ClientPrefs.fairFightHealthLossCount - 0.005;
						else
							health -= ClientPrefs.fairFightHealthLossCount;
					}

					//hopefully i make the cam offset customizable...
					if (ClientPrefs.camMoveOnHit && noteHitParams.camMoveOnHit && !PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
						switch (noteHitParams.animToPlay)
						{
							case "singLEFT":  camFollow.x = dadSingLeft;
							case "singDOWN":  camFollow.y = dadSingDown;
							case "singUP":    camFollow.y = dadSingUp;
							case "singRIGHT": camFollow.x = dadSingRight;
						}
					}	

					noteHitParams.charForAnim.playAnim(noteHitParams.animToPlay, true);
					noteHitParams.charForAnim.holdTimer = 0;

					if (SONG.needsVoices)
						vocals.volume = 1;

					if (noteHitParams.deleteNote) {
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}

				// WIP interpolation shit? Need to fix the pause issue
				// daNote.y = (strumLine.y - (songTime - daNote.strumTime) * (0.45 * PlayState.SONG.speed));

				if (daNote.y < -daNote.height) {
					if (daNote.isSustainNote && daNote.wasGoodHit) {
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					} else {
						if (daNote.tooLate || !daNote.wasGoodHit && daNote.doesMiss) {
							health -= 0.0475;
							vocals.volume = 0;
							songMisses++;
							songScore -= 10;
							combo = 0;
							fcing = false;
							#if SCRIPTS_ENABLED scripts_call("noteMiss"); #end
							if (ClientPrefs.poisonPlus == true
								&& poisonTimes < ClientPrefs.maxPoisonHits
								&& ClientPrefs.maxPoisonHits != 0) {
								trace('poison hit!');
								poisonTimes += 1;
								var poisonPlusTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
									health -= 0.04;
								}, 0);
								// stop timer after 3 seconds
								new FlxTimer().start(3, function(tmr:FlxTimer) {
									trace('stop');
									poisonPlusTimer.cancel();
									poisonTimes -= 1;
								});
							} else if (ClientPrefs.poisonPlus == true && ClientPrefs.maxPoisonHits == 0) {
								trace('poison hit!');
								poisonTimes += 1;
								var poisonPlusTimer = new FlxTimer().start(0.5, function(tmr:FlxTimer) {
									health -= 0.04;
								}, 0);
								// stop timer after 3 seconds
								new FlxTimer().start(3, function(tmr:FlxTimer) {
									trace('stop');
									poisonPlusTimer.cancel();
									poisonTimes -= 1;
								});
							}
						}

						daNote.active = false;
						daNote.visible = false;
						daNote.kill();
						notes.remove(daNote, true);
						daNote.destroy();
					}
				}

				if (ClientPrefs.downscroll)
					daNote.y = FlxG.height - daNote.y - daNote.height;
			});
		}

		if (!inTransition)
			keyShit();

		if (FlxG.keys.justPressed.ONE)
			endSong();
		if (FlxG.keys.justPressed.TWO)
			perfectMode = true;

		#if SCRIPTS_ENABLED
		if (!inTransition)
			scripts_call("updatePost", [elapsed], false);
		#end
	}

	public function endSong():Void {
		#if desktop
		DiscordHandler.changePresence('In The Menus The Last Song They Played Was', SONG.song.toLowerCase()); // holy shit its discord
		#end

		#if SCRIPTS_ENABLED scripts_call("songEnd"); #end

		canPause = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		if (SONG.validScore) {
			#if !switch
			Highscore.saveScore(SONG.song, songScore, storyDifficulty);
			#end
		}

		if (isStoryMode) {
			campaignScore += songScore;
			campaignMisses += songMisses;

			storyPlaylist.remove(storyPlaylist[0]);

			if (storyPlaylist.length <= 0) {
				FlxG.sound.playMusic(Files.music('freakyMenu'));

				transIn = FlxTransitionableState.defaultTransIn;
				transOut = FlxTransitionableState.defaultTransOut;

				FlxG.switchState(new StoryMenuState());

				if (SONG.validScore) {
					Highscore.saveWeekScore(storyWeek, campaignScore, storyDifficulty, campaignMisses);
				}

				FlxG.save.flush();
			} else {
				var daSongPath = Highscore.formatSong(PlayState.storyPlaylist[0], storyDifficulty);
				trace('LOADING NEXT SONG: $daSongPath');

				if (SONG.song.toLowerCase() == 'eggnog') {
					var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
						-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
					blackShit.scrollFactor.set();
					add(blackShit);
					camHUD.visible = false;

					FlxG.sound.play(Files.sound('Lights_Shut_off'));
				}

				FlxTransitionableState.skipNextTransIn = true;
				FlxTransitionableState.skipNextTransOut = true;
				prevCamFollow = camFollow;

				PlayState.songPath = PlayState.storyPlaylist[0];
				PlayState.SONG = Song.loadFromJson(daSongPath, PlayState.storyPlaylist[0]);
				FlxG.sound.music.stop();

				FlxG.switchState(new PlayState());
			}
		} else {
			trace('WENT BACK TO FREEPLAY??');
			FlxG.switchState(new FreeplayState());
		}
	}

	var endingSong:Bool = false;

	private function popUpScore(strumtime:Float, daNote:Note, ?canSplash:Bool = true):Void {
		var noteDiff:Float = Math.abs(strumtime - Conductor.songPosition);
		vocals.volume = 1;

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.55;

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;
		var noteSplash:Bool = true;
		var ratingMiss:Bool = false;

		var daRating:String = "sick";

		if (noteDiff > Conductor.safeZoneOffset * 0.9) {
			daRating = 'shit';
			score = 50;
			noteSplash = false;
			ratingMiss = true;
			shits++;
		} else if (noteDiff > Conductor.safeZoneOffset * 0.75) {
			daRating = 'bad';
			score = 100;
			noteSplash = false;
			bads++;
		} else if (noteDiff > Conductor.safeZoneOffset * 0.2) {
			daRating = 'good';
			score = 200;
			noteSplash = false;
			goods++;
		}

		if (noteSplash && canSplash)
		{
			sicks++;
			var noteSplash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
			noteSplash.setupNoteSplash(daNote.x, daNote.y, daNote.noteData);
			// new NoteSplash(note.x, daNote.y, daNote.noteData);
			grpNoteSplashes.add(noteSplash);
		}

		if (!ClientPrefs.botPlay && !ClientPrefs.practice) {
			var scoreIncrease:Float = (score * ((combo + 1) * 0.05)) * ClientPrefs.scoreMultiplier;
			score += Math.floor(scoreIncrease);
			songScore += score;
		}

		if (ratingMiss && ClientPrefs.shitSystem) {
			var pressedIndex:Int = [
				gameControls.LEFT_P,
				gameControls.DOWN_P,
				gameControls.UP_P,
				gameControls.RIGHT_P
			].indexOf(true);
			if (pressedIndex != -1)
				noteMiss(pressedIndex);
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		// RecalculateRating(false);

		if (pixelStage) {
			pixelShitPart1 = 'weeb/pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Files.image(pixelShitPart1 + daRating + pixelShitPart2));
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Files.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = 600;
		comboSpr.velocity.y -= 150;

		comboSpr.velocity.x += FlxG.random.int(1, 10);
		add(rating);

		if (!curStage.startsWith('school')) {
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = true;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = true;
		} else {
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.7));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.7));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		seperatedScore.push(Math.floor(combo / 100));
		seperatedScore.push(Math.floor((combo - (seperatedScore[0] * 100)) / 10));
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		for (i in seperatedScore) {
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Files.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			if (!curStage.startsWith('school')) {
				numScore.antialiasing = true;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			} else {
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);

			if (combo >= 10 || combo == 0)
				add(numScore);

			if (combo > 9 && ClientPrefs.showComboSprite)
				add(comboSpr);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween) {
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
		}
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween) {
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.001
		});

		curSection += 1;
	}

	private function keyShit():Void {
		// HOLDING
		var up = gameControls.UP;
		var right = gameControls.RIGHT;
		var down = gameControls.DOWN;
		var left = gameControls.LEFT;

		var upP = gameControls.UP_P;
		var rightP = gameControls.RIGHT_P;
		var downP = gameControls.DOWN_P;
		var leftP = gameControls.LEFT_P;

		var heldControlArray:Array<Bool> = [left, down, up, right];
		var controlArray:Array<Bool> = [leftP, downP, upP, rightP];

		if (heldControlArray.indexOf(true) != -1 && generatedMusic) {
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.isSustainNote && daNote.canBeHit && daNote.mustPress && heldControlArray[daNote.noteData]) {
					goodNoteHit(daNote);
				}
			});
		};

		if (controlArray.indexOf(true) != -1 && generatedMusic) {
			boyfriend.holdTimer = 0;

			var pressedNotes:Array<Note> = [];
			var noteDatas:Array<Int> = [];
			var epicNotes:Array<Note> = [];
			notes.forEachAlive(function(daNote:Note) {
				if (daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit) {
					if (noteDatas.indexOf(daNote.noteData) != -1) {
						for (i in 0...pressedNotes.length) {
							var note:Note = pressedNotes[i];
							if (note.noteData == daNote.noteData && Math.abs(daNote.strumTime - note.strumTime) < 10) {
								epicNotes.push(daNote);
								break;
							} else if (note.noteData == daNote.noteData && note.strumTime > daNote.strumTime) {
								pressedNotes.remove(note);
								pressedNotes.push(daNote);
								break;
							}
						}
					} else {
						pressedNotes.push(daNote);
						noteDatas.push(daNote.noteData);
					}
				}
			});
			for (i in 0...epicNotes.length) {
				var note:Note = epicNotes[i];
				note.kill();
				notes.remove(note);
				note.destroy();
			}

			if (pressedNotes.length > 0)
				pressedNotes.sort(sortByShit);

			if (perfectMode) {
				goodNoteHit(pressedNotes[0]);
			} else if (pressedNotes.length > 0) {
				for (i in 0...controlArray.length) {
					if (controlArray[i] && noteDatas.indexOf(i) == -1) {
						badNoteCheck();
					}
				}
				for (i in 0...pressedNotes.length) {
					var note:Note = pressedNotes[i];
					if (controlArray[note.noteData]) {
						goodNoteHit(note);
					}
				}
			} else {
				badNoteCheck(); // turn this back to BadNoteHit if no work
			}
		};

		if (boyfriend.holdTimer > 0.004 * Conductor.stepCrochet && heldControlArray.indexOf(true) == -1) {
			if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss')) {
				boyfriend.dance();
			}
		}

		playerStrums.forEach(function(spr:FlxSprite) {
			if (controlArray[spr.ID] && spr.animation.curAnim.name != 'confirm') {
				spr.animation.play('pressed');
			}
			if (!heldControlArray[spr.ID]) {
				spr.animation.play('static');
			}
			if (spr.animation.curAnim.name != 'confirm' || curStage.startsWith('school')) {
				spr.centerOffsets();
			} else {
				spr.centerOffsets();
				var d = spr.offset;
				d.set(d.x - 13, d.y - 13);
			}
		});
	}

	function noteMiss(direction:Int = 1):Void {
		if (!boyfriend.stunned) {
			if (ClientPrefs.fcMode)
				health -= 9999;
			else
				health -= 0.04;

			if (combo > 5) {
				gf.playAnim('sad');
			}
			combo = 0;

			songScore -= 10;

			songMisses += 1;

			FlxG.sound.play(Files.sound('missnote${FlxG.random.int(1, 3)}'), FlxG.random.float(0.1, 0.2));

			boyfriend.stunned = true;

			#if SCRIPTS_ENABLED scripts_call("noteMiss"); #end

			// RecalculateRating(true);

			// get stunned for 5 seconds
			new FlxTimer().start(5 / 60, function(tmr:FlxTimer) {
				boyfriend.stunned = false;
			});

			switch (direction) {
				case 0:
					boyfriend.playAnim('singLEFTmiss', true);
				case 1:
					boyfriend.playAnim('singDOWNmiss', true);
				case 2:
					boyfriend.playAnim('singUPmiss', true);
				case 3:
					boyfriend.playAnim('singRIGHTmiss', true);
			}
		}
	}

	function badNoteCheck() {
		// i redid this system
		if (ClientPrefs.ghostTapping)
			return;
		var pressedIndex:Int = [
			gameControls.LEFT_P,
			gameControls.DOWN_P,
			gameControls.UP_P,
			gameControls.RIGHT_P
		].indexOf(true);
		if (pressedIndex != -1)
			noteMiss(pressedIndex);
	}

	function goodNoteHit(note:Note):Void {
		if (note.wasGoodHit)
			return;

		var animList:Array<String> = ["singLEFT", "singDOWN", "singUP", "singRIGHT"];
		var noteHitParams:NoteHitParams = {
			note: note,
			jsonData: note.jsonData,
			charForAnim: boyfriend,
			animToPlay: animList[note.noteData],
			enableZoom: (SONG.song != "Tutorial"),
			deleteNote: true,
			strumGlow: true,
			rateNote: true,
			noteSplashes: true,
			camMoveOnHit: true
		}
		#if SCRIPTS_ENABLED scripts_call("bfNoteHit", [noteHitParams]); #end

		if (noteHitParams.enableZoom)
			camZooming = true;

		if (!note.isSustainNote && noteHitParams.rateNote) {
			popUpScore(note.strumTime, note, noteHitParams.noteSplashes);
			combo += 1;
			notesHit++;
			if (notesHit == 1 && songMisses == 0) {
				fcing = true; //ik this is a dumb way to do it but it works!
			}
		}

		//hopefully i make the cam offset customizable...
		if (ClientPrefs.camMoveOnHit && noteHitParams.camMoveOnHit && PlayState.SONG.notes[Std.int(curStep / 16)].mustHitSection) {
			switch (noteHitParams.animToPlay)
			{
				case "singLEFT":  camFollow.x = bfSingLeft;
				case "singDOWN":  camFollow.y = bfSingDown;
				case "singUP":    camFollow.y = bfSingUp;
				case "singRIGHT": camFollow.x = bfSingRight;
			}
		}

		if (note.noteData >= 0)
			health += 0.023;
		else
			health += 0.004;

		noteHitParams.charForAnim.playAnim(noteHitParams.animToPlay, true);
		noteHitParams.charForAnim.holdTimer = 0;

		if (noteHitParams.strumGlow)
			playerStrums.members[note.noteData].animation.play("confirm", true);

		note.wasGoodHit = true;
		vocals.volume = 1;

		if (!note.isSustainNote && noteHitParams.deleteNote) {
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	override function stepHit() {
		super.stepHit();
		stage.stepHit(curStep);
		#if SCRIPTS_ENABLED scripts_call("stepHit", [], false); #end
		if (SONG.needsVoices) {
			if (vocals.time > Conductor.songPosition + 20 || vocals.time < Conductor.songPosition - 20) {
				resyncVocals();
			}
		}
	}

	override function beatHit() {
		super.beatHit();

		if (SONG.notes[Math.floor(curStep / 16)] != null) {
			if (SONG.notes[Math.floor(curStep / 16)].changeBPM) {
				Conductor.changeBPM(SONG.notes[Math.floor(curStep / 16)].bpm);
				FlxG.log.add('CHANGED BPM!');
			}
			// else
			// Conductor.changeBPM(SONG.bpm);

			// Dad doesnt interupt his own notes
			if (!SONG.notes[Math.floor(curStep / 16)].mustHitSection && dadSingLeft == 0)
			{
				dadSingLeft = camFollow.x - 20;
				dadSingDown = camFollow.y + 20;
				dadSingUp = camFollow.y - 20;
				dadSingRight = camFollow.x + 20;
			}
			dad.dance();
		}
		// FlxG.log.add('change bpm' + SONG.notes[Std.int(curStep / 16)].changeBPM);
		// HARDCODING FOR MILF ZOOMS!
		if (SONG.song.toLowerCase() == 'milf' && curBeat >= 168 && curBeat < 200 && camZooming && FlxG.camera.zoom < 1.35) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		if (camZooming && FlxG.camera.zoom < 1.35 && curBeat % 4 == 0) {
			FlxG.camera.zoom += 0.015;
			camHUD.zoom += 0.03;
		}

		iconP1.setGraphicSize(Std.int(iconP1.width + 25));
		iconP2.setGraphicSize(Std.int(iconP2.width + 25));

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (curBeat % gfSpeed == 0) {
			gf.dance();
		}

		if (!boyfriend.animation.curAnim.name.startsWith("sing")) {
			boyfriend.dance();

			if (bfSingLeft == 0)
			{
				bfSingLeft = camFollow.x - 20;
				bfSingDown = camFollow.y + 20;
				bfSingUp = camFollow.y - 20;
				bfSingRight = camFollow.x + 20;
			}
		}

		if (curBeat % 8 == 7 && SONG.song == 'Bopeebo') {
			boyfriend.playAnim('hey', true);

			if (SONG.song == 'Tutorial' && dad.curCharacter == 'gf') {
				dad.playAnim('cheer', true);
			}
		}

		stage.beatHit(curBeat);
		#if SCRIPTS_ENABLED scripts_call("beatHit", [], false); #end
	}

	public function event(name:String = 'play anim', value1:String = 'bf', value2:String = 'hey') {
		switch (name) {
			case 'play anim':
				var boolIndex:Int = [
					(value1 == 'dad' || value1 == SONG.player2),
					(value1 == 'gf' || value1 == 'girlfriend'),
					true
				].indexOf(true);
				var chars = [dad, gf, boyfriend];
				chars[boolIndex].playAnim(value2);
			case 'image flash':
				var image:FlxSprite = new FlxSprite(0, 0).loadGraphic(Files.image(value1));
				image.camera = camHUD;
				image.screenCenter();
				image.alpha = 1;
				add(image);
				FlxTween.tween(image, {alpha: 0.0001}, 0.6);
		}
	}

	#if SCRIPTS_ENABLED
	public function scripts_set(name:String, value:Dynamic) {
		stage.script.setValue(name, value);
		for (script in scripts)
			script.setValue(name, value);
	}

	public function scripts_get(name:String) {
		var value:Dynamic = stage.script.getValue(name);
		for (script in scripts) {
			var disValue:Dynamic = script.getValue(name);
			if (disValue != null)
				value = disValue;
		}
		return value;
	}

	public function scripts_call(name:String, ?params:Array<Dynamic>, ?includeStage:Bool = true) {
		var value:Dynamic = null;
		if (includeStage)
			value = stage.script.callFunction(name, params);
		for (script in scripts) {
			var disValue = script.callFunction(name, params);
			if (disValue != null)
				value = disValue;
		}
		return value;
	}
	#end
}
