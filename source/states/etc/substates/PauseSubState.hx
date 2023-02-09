package states.etc.substates;

import scriptStuff.HiScript;
import flixel.text.FlxText;
import Controls.Control;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.system.FlxSound;
import flixel.util.FlxColor;
import states.mainstates.PlayState;
import states.menus.MainMenuState;
import ui.Alphabet;
import handlers.MusicBeatSubstate;
import handlers.Files;
import handlers.Highscore;
#if desktop
import handlers.DiscordHandler;
#end

class PauseSubState extends MusicBeatSubstate
{
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = ['Resume', 'Restart Song', 'Exit to menu'];
	var curSelected:Int = 0;

	var pauseMusic:FlxSound;

	var levelinfotext:FlxText;

	var script:HiScript;

	public function new(x:Float, y:Float)
	{
		super();
		#if SCRIPTS_ENABLED
		script = new HiScript('substates/PauseSubState');
		if (!script.isBlank && script.expr != null) {
			script.interp.scriptObject = this;
			script.interp.execute(script.expr);
		}
		script.callFunction("create");
		#end

		pauseMusic = new FlxSound().loadEmbedded(Files.music('breakfast'), true, true);
		pauseMusic.volume = 0;
		pauseMusic.play(false, FlxG.random.int(0, Std.int(pauseMusic.length / 2)));

		FlxG.sound.list.add(pauseMusic);

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.alpha = 0.6;
		bg.scrollFactor.set();
		add(bg);

		#if SCRIPTS_ENABLED
		script.callFunction("createBellowItems");
		#end

		levelinfotext = new FlxText(20, 15, 0, '${PlayState.SONG.song}\nSpeed:${PlayState.speed}\n${Highscore.diffArray[PlayState.storyDifficulty].toUpperCase()}');
		levelinfotext.setFormat("assets/fonts/vcr.ttf", 25, FlxColor.WHITE, null, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		levelinfotext.borderSize = 3;
		add(levelinfotext);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length)
		{	
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if SCRIPTS_ENABLED
		script.callFunction("createPost");
		#end
	}

	override function update(elapsed:Float)
	{
		#if SCRIPTS_ENABLED
		script.callFunction("update", [elapsed]);
		#end
		if (pauseMusic.volume < 0.5)
			pauseMusic.volume += 0.01 * elapsed;

		super.update(elapsed);

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

		if (accepted)
		{
			var daSelected:String = menuItems[curSelected];

			switch (daSelected)
			{
				case "Resume":
					close();
				case "Restart Song":
					FlxG.resetState();
				case "Exit to menu":
					#if desktop
					DiscordHandler.changePresence('In The Menus The Last Song They Played Was', PlayState.SONG.song.toLowerCase());
					#end

					FlxG.switchState(new MainMenuState());
					if (PlayState.SONG.song.toLowerCase() == 'test') {
						FlxG.updateFramerate = 150;
						FlxG.drawFramerate = 150;
					}
			}
		}

		#if SCRIPTS_ENABLED
		script.callFunction("updatePost");
		#end
	}

	override function destroy()
	{
		#if SCRIPTS_ENABLED
		script.callFunction("close");
		#end

		pauseMusic.destroy();

		super.destroy();
	}

	function changeSelection(change:Int = 0):Void
	{
		#if SCRIPTS_ENABLED
		script.callFunction("changeSelection");
		#end

		curSelected += change;

		if (curSelected < 0)
			curSelected = menuItems.length - 1;
		if (curSelected >= menuItems.length)
			curSelected = 0;

		var bullShit:Int = 0;

		for (item in grpMenuShit.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
				item.alpha = 1;
		}
		#if SCRIPTS_ENABLED
		script.callFunction("changeSelectionPost");
		#end
	}
}
