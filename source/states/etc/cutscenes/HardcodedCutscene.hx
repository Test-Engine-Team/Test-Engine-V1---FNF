package states.etc.cutscenes;

//Web doesnt have hscript so this.
//WIP. DO NOT MESS WITH.
import openfl.Assets;
import handlers.Files;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxTimer;
import flixel.tweens.FlxTween;

using StringTools;


class HardcodedCutscene extends handlers.MusicBeatSubstate {
    public function new(path:String) {
        super();
        switch (Assets.getText(path).trim()) {
            case "SENPAI FUCKING DIES OH GOD":
                FlxG.sound.playMusic(Files.music('LunchboxScary'), 0);
				FlxG.sound.music.fadeIn(1, 0, 0.8);

				var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
				red.scrollFactor.set();
                add(red);

				var senpaiEvil:FlxSprite = new FlxSprite();
				senpaiEvil.frames = Files.sparrowAtlas('weeb/senpaiCrazy');
				senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
				senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
				senpaiEvil.scrollFactor.set();
				senpaiEvil.updateHitbox();
				senpaiEvil.screenCenter();
                add(senpaiEvil);
                senpaiEvil.alpha = 0;
				senpaiEvil.antialiasing = false;

				new FlxTimer().start(2.1, function(tmr:FlxTimer)
				{
					new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
					{
						senpaiEvil.alpha += 0.15;
						if (senpaiEvil.alpha < 1)
							swagTimer.reset();
						else {
							senpaiEvil.animation.play('idle');
							FlxG.sound.play(Files.sound('Senpai_Dies'), 1, false, null, true, function()
							{
								remove(senpaiEvil);
								remove(red);
								FlxG.camera.fade(0xFFFFFFFF, 0.01, true, function()
								{
									var cutscene = new states.etc.cutscenes.DialogueCutscene('assets/data/thorns/thornsDialogue.txt');
									cutscene.finishCutscene = function(twn:FlxTween) {
										cutscene.close();
										finishCutscene();
									}
									openSubState(cutscene);
								}, true);
							});
							new FlxTimer().start(3.2, function(deadTime:FlxTimer)
							{
								FlxG.camera.fade(0xFFFFFFFF, 1.6, false);
							});
						}
					});
				});
        }
    }

    public dynamic function finishCutscene() {
        close();
    }
}