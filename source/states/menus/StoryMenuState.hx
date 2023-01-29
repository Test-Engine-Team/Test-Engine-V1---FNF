package states.menus;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.group.FlxGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import lime.net.curl.CURLCode;
import states.mainstates.PlayState;
import handlers.Files;
import handlers.MenuCharacter;
import handlers.Highscore;
import handlers.MenuItem;
import handlers.MusicBeatState;
import states.menus.LoadingState;
import handlers.ModDataStructures;

import handlers.ClientPrefs;

using StringTools;

class StoryMenuState extends MusicBeatState
{
	var weekList:Array<ModWeekYee> = [];
	var curDifficulty:Int = 1;
	var curWeek:Int = 0;

	var txtWeekTitle:FlxText;
	var scoreText:FlxText;
	var txtTracklist:FlxText;

	var grpWeekText:FlxTypedGroup<MenuItem>;
	var grpWeekCharacters:FlxTypedGroup<MenuCharacter>;

	var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var normDiffY:Float = 0;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	override function create()
	{
		weekList = LoadingState.modData.weekList;
		var firstWeek:ModWeekYee = weekList[curWeek];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		if (FlxG.sound.music != null && !FlxG.sound.music.playing)
			FlxG.sound.playMusic(Files.music('freakyMenu'));

		persistentUpdate = persistentDraw = true;

		scoreText = new FlxText(10, 10, 0, "SCORE: 69420"/*laugh*/, 36);
		scoreText.setFormat("VCR OSD Mono", 32);

		txtWeekTitle = new FlxText(FlxG.width * 0.7, 10, 0, "", 32);
		txtWeekTitle.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, RIGHT);
		txtWeekTitle.alpha = 0.7;

		var rankText:FlxText = new FlxText(0, 10);
		rankText.text = 'RANK: GREAT';
		rankText.setFormat("assets/fonts/vcr.ttf", 32);
		rankText.size = scoreText.size;
		rankText.screenCenter(X);

		var ui_tex = Files.sparrowAtlas("menus/storymenu/campaign_menu_UI_assets");
		var yellowBG:FlxSprite = new FlxSprite(0, 56).makeGraphic(FlxG.width, 400, 0xFFF9CF51);

		grpWeekText = new FlxTypedGroup<MenuItem>();
		add(grpWeekText);

		var blackBarThingie:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, 56, FlxColor.BLACK);
		add(blackBarThingie);

		grpWeekCharacters = new FlxTypedGroup<MenuCharacter>();

		for (i in 0...weekList.length) {
			var weekThing:MenuItem = new MenuItem(0, yellowBG.y + yellowBG.height + 10, weekList[i].spriteImage);
			weekThing.y += ((weekThing.height + 20) * i);
			weekThing.targetY = i;
			grpWeekText.add(weekThing);

			weekThing.screenCenter(X);
			weekThing.antialiasing = true;
		}

		for (char in 0...3) {
			var xArray = [
				(FlxG.width * 0.25) * (1) - 150,
				(FlxG.width * 0.25) * (3) - 150,
				(FlxG.width * 0.25) * (2) - 150
			];
			var weekCharacterThing:MenuCharacter = new MenuCharacter(xArray[char], char, firstWeek.chars[char]);
			grpWeekCharacters.add(weekCharacterThing);
		}

		difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(grpWeekText.members[0].x + grpWeekText.members[0].width + 10, grpWeekText.members[0].y + 10);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		sprDifficulty = new FlxSprite(leftArrow.x + 60, leftArrow.y + 15, Files.image("menus/storymenu/difficulties/normal"));
		sprDifficulty.x += sprDifficulty.frameWidth / 2;
		sprDifficulty.y += sprDifficulty.frameHeight / 2;
		normDiffY = sprDifficulty.y;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(sprDifficulty.x + (sprDifficulty.frameWidth * 0.5) + 10, leftArrow.y);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);
		diffCheck(["/"], firstWeek.diffs);

		add(yellowBG);
		add(grpWeekCharacters);

		txtTracklist = new FlxText(FlxG.width * 0.05, yellowBG.x + yellowBG.height + 100, 0, "Tracks\n", 32);
		txtTracklist.alignment = CENTER;
		txtTracklist.font = rankText.font;
		txtTracklist.color = 0xFFe55777;
		add(txtTracklist);
		// add(rankText);
		add(scoreText);
		add(txtWeekTitle);

		for (i in weekList[curWeek].songs)
			txtTracklist.text += "\n" + i;

		txtTracklist.text = txtTracklist.text.toUpperCase();
	
		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;
	
		#if !switch
		intendedScore = Highscore.getWeekScore(firstWeek.name, curDifficulty);
		#end

		super.create();
	}

	override function update(elapsed:Float)
	{
		PlayState.speed = ClientPrefs.speed;
		// scoreText.setFormat('VCR OSD Mono', 32);
		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.5));

		scoreText.text = "WEEK SCORE:" + lerpScore;

		txtWeekTitle.text = weekList[curWeek].name.toUpperCase();
		txtWeekTitle.x = FlxG.width - (txtWeekTitle.width + 10);

		// FlxG.watch.addQuick('font', scoreText.font);

		if (!movedBack)
		{
			if (!selectedWeek)
			{
				if (controls.UP_P)
					changeWeek(-1);
				else if (controls.DOWN_P)
					changeWeek(1);

				rightArrow.animation.play((controls.RIGHT) ? 'press' : 'idle');
				leftArrow.animation.play((controls.LEFT) ? 'press' : 'idle');

				#if desktop
				if (FlxG.keys.justPressed.M) {
					persistentUpdate = false;
					openSubState(new states.etc.substates.ModSelectSubstate());
					return;
				}
				#end

				if (controls.RIGHT_P)
					changeDifficulty(1);
				else if (controls.LEFT_P)
					changeDifficulty(-1);
			}

			if (controls.ACCEPT)
				selectWeek();
		}

		if (controls.BACK && !movedBack && !selectedWeek)
		{
			FlxG.sound.play(Files.sound('cancelMenu'));
			movedBack = true;
			FlxG.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	function selectWeek()
	{
		if (!stopspamming) {
			FlxG.sound.play(Files.sound('confirmMenu'));

			grpWeekText.members[curWeek].flashColor = 0xFF33FFFF;
			for (i in 0...3) {
				if (grpWeekCharacters.members[i].animation.exists("confirm"))
					grpWeekCharacters.members[i].animation.play('confirm');
			}
			stopspamming = true;
		}

		//Doin for loop cause if i just do `weekList[curWeek].paths` it removes the modData paths as the week continues.
		PlayState.storyPlaylist = [for (path in weekList[curWeek].paths) path];
		PlayState.isStoryMode = true;
		selectedWeek = true;

		PlayState.storyDifficulty = curDifficulty;

		Highscore.diffArray = weekList[curWeek].diffs;
		var songPath:String = Highscore.formatSong(PlayState.storyPlaylist[0], curDifficulty);
		PlayState.songPath = PlayState.storyPlaylist[0];
		PlayState.SONG = Song.loadFromJson(songPath, PlayState.storyPlaylist[0]);
		PlayState.storyWeek = weekList[curWeek].name;
		PlayState.campaignScore = 0;
		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
			FlxG.switchState(new PlayState());
		});
	}

	function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = weekList[curWeek].diffs.length - 1;
		if (curDifficulty >= weekList[curWeek].diffs.length)
			curDifficulty = 0;

		sprDifficulty.loadGraphic(Files.image("menus/storymenu/difficulties/" + weekList[curWeek].diffs[curDifficulty].toLowerCase()));
		sprDifficulty.updateHitbox();
		sprDifficulty.offset.set(0.5 * sprDifficulty.frameWidth, 0.5 * sprDifficulty.frameHeight);

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = normDiffY - 15;
		intendedScore = Highscore.getWeekScore(weekList[curWeek].name, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(weekList[curWeek].name, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: normDiffY, alpha: 1}, 0.07);
	}

	function diffCheck(oldDiff:Array<String>, newDiff:Array<String>) {
		var checkFailed:Bool = false;
		if (oldDiff.length != newDiff.length)
			checkFailed = true;
		for (i in 0...newDiff.length) {
			if (newDiff[i].toLowerCase() != newDiff[i].toLowerCase()) {
				checkFailed = true;
				break;
			}
		}

		if (!checkFailed) return;

		curDifficulty = Math.floor(weekList[curWeek].diffs.length / 2);

		sprDifficulty.loadGraphic(Files.image("menus/storymenu/difficulties/" + weekList[curWeek].diffs[curDifficulty].toLowerCase()));
		sprDifficulty.updateHitbox();
		sprDifficulty.offset.set(0.5 * sprDifficulty.frameWidth, 0.5 * sprDifficulty.frameHeight);

		sprDifficulty.alpha = 0;

		// USING THESE WEIRD VALUES SO THAT IT DOESNT FLOAT UP
		sprDifficulty.y = normDiffY - 15;
		intendedScore = Highscore.getWeekScore(weekList[curWeek].name, curDifficulty);

		#if !switch
		intendedScore = Highscore.getWeekScore(weekList[curWeek].name, curDifficulty);
		#end

		FlxTween.tween(sprDifficulty, {y: normDiffY, alpha: 1}, 0.07);
	}

	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	function changeWeek(change:Int = 0):Void
	{
		var oldDiffs = weekList[curWeek].diffs;
		curWeek += change;

		if (curWeek >= weekList.length)
			curWeek = 0;
		if (curWeek < 0)
			curWeek = weekList.length - 1;

		var bullShit:Int = 0;

		for (item in grpWeekText.members)
		{
			item.targetY = bullShit - curWeek;
			item.alpha = (item.targetY == 0) ? 1 : 0.6;
			bullShit++;
		}

		FlxG.sound.play(Files.sound('scrollMenu'));

		diffCheck(oldDiffs, weekList[curWeek].diffs);
		updateText();
	}

	function updateText() {
		for (i in 0...3)
			grpWeekCharacters.members[i].loadCharacter(weekList[curWeek].chars[i]);

		txtTracklist.text = "Tracks\n";
		for (i in weekList[curWeek].songs)
		{
			txtTracklist.text += "\n" + i;
		}
		txtTracklist.text = txtTracklist.text.toUpperCase();

		txtTracklist.screenCenter(X);
		txtTracklist.x -= FlxG.width * 0.35;

		#if !switch
		intendedScore = Highscore.getWeekScore(weekList[curWeek].name, curDifficulty);
		#end
	}
}
