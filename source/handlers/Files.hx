package handlers;

import openfl.Assets;
import lime.tools.AssetType;
import states.menus.TitleState;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.FlxG;
#if sys
import sys.FileSystem;
#end

class Files{
    static var file:String;
    
    public static function image(image:String, folder:String = 'images'){
        return file = 'assets/$folder/$image.png';
    }

    public static function sound(sound:String, folder:String = 'sounds'){
        return file = 'assets/$folder/$sound.ogg';
    }

    public static function music(music:String, folder:String = 'music'){
        return file = 'assets/$folder/$music.ogg';
    }

    public static function song(song:String, folder:String = 'songs'){
        return file = 'assets/$folder/$song.ogg';
    }

    public static function font(font:String, extention:String = 'ttf') {
        #if html5
        extention = 'woff';
        #end
        return file = 'assets/fonts/$font.$extention';
    }

    public static function songJson(songName:String, difficulty:String = 'Normal') {
        //kinda temp
        if (difficulty.toLowerCase() == 'normal') 
            difficulty = "";

        var song:String = songName.toLowerCase();
        var diff:String;
        if (difficulty != "")
            diff = '-' + difficulty.toLowerCase();
        else
            diff = "";
        return file = 'assets/data/$song/$song$diff';
    }

    public static function sparrowAtlas(path:String, folder:String = 'images') {
        return FlxAtlasFrames.fromSparrow('assets/$folder/$path.png', 'assets/$folder/$path.xml');
    }

    public static function packerAtlas(path:String, folder:String = 'images') {
        return FlxAtlasFrames.fromSpriteSheetPacker('assets/$folder/$path.png', 'assets/$folder/$path.txt');
    }

    //public static function packerAtlas

    /*
    public static function fileExists(name:String, type:AssetType) {
        if(OpenFlAssets.exists(getPath(name, type)))
			return true;
        else 
		    return false;
    }
    dumb stuff idk how to do properly*/

    public static function txt(path:String) {
        return file = 'assets/$path.txt';
    }

    public static function randomSound(min:Int, max:Int, fileName:String) {
        return file = 'assets/sounds/$fileName' + FlxG.random.int(min, max) + '.ogg';
    }

    public static function songInst(songName:String) {
        var songFolder = songName.toLowerCase();
        return file = 'assets/songs/$songFolder/Inst.ogg';
    }

    public static function songVoices(songName:String) {
        var songFolder = songName.toLowerCase();
        return file = 'assets/songs/$songFolder/Voices.ogg';
    }

    /*
    public static function grabBuildNum() {
        #if sys
        var path:String = '../../../../buildnum.txt';
        return file = Std.parseInt(File.getContent(sys.FileSystem.absolutePath(path))) + 1;
        #else
        return 'sys is not enabled!';
        #end
    }
    */

    public static function fileExists(path:String, name:String, extention:String) {
        return Assets.exists('assets/$path/$name.$extention');
    }
}