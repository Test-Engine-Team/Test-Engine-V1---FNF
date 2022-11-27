package;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.FlxG;
import openfl.Assets;
import flixel.math.FlxRandom;
import flixel.graphics.frames.FlxAtlasFrames;

var file:String;

class Files{
    public static function image(image:String){
        return file = 'assets/images/$image.png';
    }

    public static function sound(sound:String){
        return file = 'assets/sounds/$sound${TitleState.soundExt}';
    }

    public static function song(song:String){
        return file = 'assets/songs/$song${TitleState.soundExt}';
    }
}