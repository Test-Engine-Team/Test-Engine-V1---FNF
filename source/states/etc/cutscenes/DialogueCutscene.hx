package states.etc.cutscenes;

import flixel.FlxG;
import handlers.Files;
import flixel.text.FlxText;
import openfl.Assets;
import flixel.FlxSprite;
import handlers.MusicBeatSubstate;

using StringTools;

class DialogueCutscene extends MusicBeatSubstate {
    var daFormat:String = "normal";
    var dialogueBox:FlxSprite;
    var text:FlxText;
    var leftSprite:FlxSprite;
    var rightSprite:FlxSprite;
    var commandArray:Array<String>;

    public function new(filePath:String) {
        super();

        dialogueBox = new FlxSprite(640, 570);
        add(dialogueBox);
        text = new FlxText();
        add(text);

        var daText:String = Assets.getText(filePath);
        commandArray = [
            for (line in daText.split('\n'))
                line.trim()
        ];

        nextLine();
    }

    function nextLine() {
        while (!commandArray[0].startsWith("talk")) {
            var params:Array<String> = commandArray.shift().split(":");
            switch (params[0]) {
                case "setFormat":
                    daFormat = params[1];
                case "playMusic":
                    FlxG.sound.playMusic(Files.music(params[1]), Std.parseFloat(params[2]));
                case "playSound":
                    FlxG.sound.play(Files.sound(params[1]), Std.parseFloat(params[2]));
            }
        }
    }
}