package states.etc.substates;

import sys.io.File;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import handlers.Files;
import sys.FileSystem;
import flixel.FlxSprite;
import flixel.text.FlxText;
import handlers.MusicBeatSubstate;

class ModSelectSubstate extends MusicBeatSubstate {
    var modList:Array<String> = [];
    var curSelected:Int = 0;
    var canSelect:Bool = true;
    var canLeave:Bool = false;

    var listTxt:FlxText;
    var coolEpicAndCoolGradient:FlxSprite;

    public function new() {
        super();

        #if (!desktop) close(); return; #end

        modList = [for (mod in FileSystem.readDirectory("./mods"))
            if (FileSystem.isDirectory("./mods/" + mod) && mod != "+BASE+")
                mod
        ];
        modList.insert(0, "Base Game");

        coolEpicAndCoolGradient = new FlxSprite(1280, 0, Files.image("menus/mainmenu/coolModSelectGradient"));
        coolEpicAndCoolGradient.scrollFactor.set();
        coolEpicAndCoolGradient.color = states.menus.LoadingState.modData.selectColor;
        add(coolEpicAndCoolGradient);

        listTxt = new FlxText(coolEpicAndCoolGradient.width - 10, 10, FlxG.width, "Select Mod\n\n", 20);
        listTxt.setFormat("VCR OSD Mono", 20, 0xFFFFFFFF, "right", FlxTextBorderStyle.OUTLINE, 0xFF000000);
        listTxt.scrollFactor.set();
        add(listTxt);

        for (i in 0...modList.length) {
            var prefix:String = (curSelected == i) ? "> " : "";
            listTxt.text += prefix + modList[i] + "\n";
        }

        FlxTween.tween(coolEpicAndCoolGradient, {x: 1280 - coolEpicAndCoolGradient.width}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween) {
            canLeave = true;
        }});
        FlxTween.tween(listTxt, {x: -10}, 0.5, {ease: FlxEase.circOut});
    }

    override function update(elapsed:Float) {
        super.update(elapsed);

        #if (!desktop) close(); return; #end

        switch ([(controls.UP_P && canSelect), (controls.DOWN_P && canSelect), (controls.ACCEPT && canSelect), (controls.BACK && canLeave)].indexOf(true)) {
            case 0:
                FlxG.sound.play((Files.sound('scrollMenu')));
                curSelected--;
                if (curSelected < 0)
                    curSelected = modList.length - 1;

                listTxt.text = "Select Mod\n\n";
                for (i in 0...modList.length) {
                    var prefix:String = (curSelected == i) ? "> " : "";
                    listTxt.text += prefix + modList[i] + "\n";
                }
            case 1:
                FlxG.sound.play((Files.sound('scrollMenu')));
                curSelected++;
                if (curSelected >= modList.length)
                    curSelected = 0;

                listTxt.text = "Select Mod\n\n";
                for (i in 0...modList.length) {
                    var prefix:String = (curSelected == i) ? "> " : "";
                    listTxt.text += prefix + modList[i] + "\n";
                }
            case 2:
                FlxG.sound.music.stop();
                File.saveContent("./mods/currentMod.txt", (curSelected == 0) ? "" : modList[curSelected]);
                FlxG.switchState(new states.menus.LoadingState());
            case 3:
                canLeave = false;
                canSelect = false;
                FlxTween.tween(coolEpicAndCoolGradient, {x: 1280}, 0.5, {ease: FlxEase.circOut, onComplete: function(twn:FlxTween) {
                    close();
                }});
                FlxTween.tween(listTxt, {x: coolEpicAndCoolGradient.width - 10}, 0.5, {ease: FlxEase.circOut});
        }
    }
}