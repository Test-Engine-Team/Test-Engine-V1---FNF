package states.menus;

import handlers.CoolUtil;
import flixel.math.FlxMath;
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
import handlers.MusicBeatState;
import handlers.Files;
import ui.HealthIcon;
#if discord_rpc
import handlers.DiscordHandler;
#end

class CreditsState extends MusicBeatState {
	var grpMenuShit:FlxTypedGroup<Alphabet>;

	var menuItems:Array<String> = [
		'Megalo', '[504] Brandon', 'Mackery', 'SRT', 'MemeHoovy', 'SIG7Ivan', 'Alik Guh', 'Void', 'YeeterOk', 'Swordcube', 'Chocolate (Iris)', 'Bash Bush',
		'your mother'
	];
	var curSelected:Int = 0;

	override public function create() {
		var bg = new FlxSprite().loadGraphic(Files.image('menus/mainmenu/menuDesat'));
		bg.color = 0x340666;
		add(bg);

		grpMenuShit = new FlxTypedGroup<Alphabet>();
		add(grpMenuShit);

		for (i in 0...menuItems.length) {
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, menuItems[i], true, false);
			songText.isMenuItem = true;
			songText.targetY = i;
			grpMenuShit.add(songText);
		}

		changeSelection();

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];
	}

	override function update(elapsed:Float) {
		super.update(elapsed);

		if (controls.UP_P)
			changeSelection(-1);
		if (controls.DOWN_P)
			changeSelection(1);

		#if discord_rpc
		DiscordHandler.changePresence('Viewing the credits', 'In the credits menu', 'credits');
		#end

		if (controls.BACK)
			FlxG.switchState(new MainMenuState());
		if (controls.ACCEPT) {
			var daSelected:String = menuItems[curSelected].toLowerCase();

			switch (daSelected) {
				case "megalo":
					CoolUtil.openLink('https://www.youtube.com/@megalo7877');
				case "mackery":
					CoolUtil.openLink('https://www.youtube.com/@Mackery');
				case "[504]brandon":
					CoolUtil.openLink('https://github.com/504brandon');
			}
		}
	}

	function changeSelection(change:Int = 0):Void {
		curSelected = FlxMath.wrap(curSelected + change, 0, menuItems.length - 1);

		for (i in 0...grpMenuShit.length) {
			var item = grpMenuShit.members[i];
			item.targetY = i - curSelected;
			item.alpha = item.targetY == 0 ? 1 : 0.6;
		}
	}
}
