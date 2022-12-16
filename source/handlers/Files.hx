package handlers;
import states.menus.TitleState;

class Files{
    static var file:String;
    
    public static function image(image:String){
        return file = 'assets/images/$image.png';
    }

    public static function sound(sound:String){
        return file = 'assets/sounds/$sound${TitleState.soundExt}';
    }

    public static function music(music:String){
        return file = 'assets/music/$music${TitleState.soundExt}';
    }

    public static function song(song:String){
        return file = 'assets/songs/$song${TitleState.soundExt}';
    }

    public static function video(video:String, extention:String = 'mp4') {
        return file = 'assets/videos/$video.$extention';
    }

    public static function font(font:String, extention:String = 'ttf') {
        return file = 'assets/fonts/$font.$extention';
    }
}