import handlers.ClientPrefs;

var halloweenBG:FlxSprite;
var lightningStrikeBeat:Int = 0;
var lightningOffset:Int = 8;

function lightningStrikeShit():Void {
	if (ClientPrefs.quality == 'Low') return;

	FlxG.sound.play(Files.randomSound(1, 2, 'thunder_'));
	halloweenBG.animation.play('lightning');
    
	lightningStrikeBeat = curBeat;
	lightningOffset = FlxG.random.int(8, 24);
    
	event('play anim', 'bf', 'scared');
	event('play anim', 'gf', 'scared');
}

function create() {
	halloweenBG = new FlxSprite(-200, -100);
	halloweenBG.frames = Files.sparrowAtlas('halloween_bg');
	halloweenBG.animation.addByPrefix('idle', 'halloweem bg0');
	halloweenBG.animation.addByPrefix('lightning', 'halloweem bg lightning strike', 24, false);
	halloweenBG.animation.play('idle');
	halloweenBG.antialiasing = true;
	add(halloweenBG);
}

function beatHit() {
	if (FlxG.random.bool(10) && curBeat > lightningStrikeBeat + lightningOffset && ClientPrefs.quality != 'Low')
		lightningStrikeShit();
}