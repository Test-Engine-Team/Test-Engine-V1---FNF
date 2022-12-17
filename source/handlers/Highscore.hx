package handlers;

import flixel.FlxG;

class Highscore
{
	#if (haxe >= "4.0.0")
	public static var songScores:Map<String, Int> = new Map();
	public static var weekScores:Map<String, Int> = new Map();
	#else
	public static var songScores:Map<String, Int> = new Map<String, Int>();
	public static var weekScores:Map<String, Int> = new Map<String, Int>();
	#end

	public static var diffArray:Array<String> =["Easy", "Normal", "Hard"];

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, misses:Int = 0):Void {
		var daSong:String = formatSong(song, diff);

		if (!songScores.exists(daSong) || songScores.get(daSong) < score)
			setScore(daSong, score, misses);
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0, misses:Int = 0):Void {
		var daWeek:String = formatSong(week, diff);

		if (!weekScores.exists(daWeek) || weekScores.get(daWeek) < score)
			setWeekScore(daWeek, score, misses);
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, misses:Int):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		songScores.set(song, score);
		FlxG.save.data.songScores = songScores;
		FlxG.save.flush();
	}
	static function setWeekScore(week:String, score:Int, misses:Int):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		weekScores.set(week, score);
		FlxG.save.data.weekScores = weekScores;
		FlxG.save.flush();
	}

	public static function formatSong(song:String, diff:Int):String {
		var daSong:String = song;
		var daDiff:String = diffArray[diff];
		daSong += (daDiff.toLowerCase() != "normal") ? "-" + daDiff.toLowerCase() : "";

		return daSong;
	}

	public static function getScore(song:String, diff:Int):Int {
		var daSong = formatSong(song, diff);

		if (!songScores.exists(daSong))
			setScore(daSong, 0, 0);

		return songScores.get(daSong);
	}

	public static function getWeekScore(week:String, diff:Int):Int {
		var daWeek = formatSong(week, diff);

		if (!weekScores.exists(daWeek))
			setWeekScore(daWeek, 0, 0);

		return weekScores.get(daWeek);
	}

	public static function load():Void {
		if (FlxG.save.data.songScores != null)
			songScores = FlxG.save.data.songScores;

		if (FlxG.save.data.weekScores != null)
			weekScores = FlxG.save.data.weekScores;
	}
}
