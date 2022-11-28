package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import Files;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<String> = [];
	var iconArray:Array<HealthIcon> = [];
	var icons:Array<String> = [];

	var selector:FlxText;
	var curSelected:Int = 0;
	var curDifficulty:Int = 1;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	override function create()
	{
		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		songs.push('Tutorial');
		icons.push('gf');

		if (StoryMenuState.weekUnlocked[1] || isDebug)
		{
			icons.push('dad');
			icons.push('dad');
			icons.push('dad');
			songs.push('Bopeebo');
			songs.push('Fresh');
			songs.push('Dadbattle');
		}

		if (StoryMenuState.weekUnlocked[2] || isDebug)
		{
			icons.push('spooky');
			icons.push('spooky');
			icons.push('monster');
			songs.push('Spookeez');
			songs.push('South');
			songs.push('Monster');
		}

		if (StoryMenuState.weekUnlocked[3] || isDebug)
		{
			icons.push('pico');
			icons.push('pico');
			icons.push('pico');
			songs.push('Pico');
			songs.push('Philly');
			songs.push('Blammed');
		}

		if (StoryMenuState.weekUnlocked[4] || isDebug)
		{
			icons.push('mom');
			icons.push('mom');
			icons.push('mom');
			songs.push('Satin-Panties');
			songs.push('High');
			songs.push('Milf');
		}

		if (StoryMenuState.weekUnlocked[5] || isDebug)
		{
			icons.push('parents');
			icons.push('parents');
			icons.push('monster');
			songs.push('Cocoa');
			songs.push('Eggnog');
			songs.push('Winter-Horrorland');
		}

		if (StoryMenuState.weekUnlocked[6] || isDebug)
		{
			icons.push('senpai');
			icons.push('senpai');
			icons.push('spirit');
			songs.push('Senpai');
			songs.push('Roses');
			songs.push('Thorns');
		}
		if (StoryMenuState.weekUnlocked[7] || isDebug)
			{
				icons.push('tankman');
				icons.push('tankman');
				icons.push('tankman');
				songs.push('Ugh');
				songs.push('Guns');
				songs.push('Stress');
			}
		#if debug
		icons.push('bf-pixel');
		songs.push('Test');
		#else
		if (FlxG.save.data.unlockedTestSong == true) {
			icons.push('bf-pixel');
			songs.push('Test');
		}
		#end

		// LOAD MUSIC

		// LOAD CHARACTERS

		var bg:FlxSprite = new FlxSprite().loadGraphic(Files.image('menuBGBlue'));
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			var icon:HealthIcon = new HealthIcon(icons[i]);
			icon.sprTracker = songText;
			iconArray.push(icon);
			add(icon);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat("assets/fonts/vcr.ttf", 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();

		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.4));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = controls.ACCEPT;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (curSelected == 22) {
			setDiff(1);
		}
		if (curSelected != 22) {
			if (controls.LEFT_P)
				changeDiff(-1);
			if (controls.RIGHT_P)
				changeDiff(1);
		}

		if (controls.BACK)
		{
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			var poop:String = Highscore.formatSong(songs[curSelected].toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;
			FlxG.switchState(new PlayState());
			if (FlxG.sound.music != null)
				FlxG.sound.music.stop();
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	//dumb shit
	function setDiff(difficulty:Int = 1)
	{
		curDifficulty = difficulty;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "EASY";
			case 1:
				diffText.text = 'NORMAL';
			case 2:
				diffText.text = "HARD";
		}
	}

	function changeSelection(change:Int = 0)
	{

		// NGio.logEvent('Fresh');
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected], curDifficulty);
		// lerpScore = 0;
		#end

		FlxG.sound.playMusic(Files.song(songs[curSelected].toLowerCase() + "/Inst"), 0);
		

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
			{
				iconArray[i].alpha = 0.6;
			}
	
			iconArray[curSelected].alpha = 1;
	
			for (item in grpSongs.members)
			{
				item.targetY = bullShit - curSelected;
				bullShit++;
	
				item.alpha = 0.6;
	
				if (item.targetY == 0)
				{
					item.alpha = 1;
				}
		}
	}
}
