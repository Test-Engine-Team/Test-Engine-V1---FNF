package handlers;

import flixel.FlxG;

class Highscore {
	public static var testSongScores:Map<String, Int> = new Map();
	public static var ogSongScores:Map<String, Int> = new Map();
	public static var testWeekScores:Map<String, Int> = new Map();
	public static var ogWeekScores:Map<String, Int> = new Map();

	public static var diffArray:Array<String> = ["Easy", "Normal", "Hard"];

	public static function saveScore(song:String, score:Int = 0, ?diff:Int = 0, misses:Int = 0):Void {
		var daSong:String = formatSong(song, diff);

		if (ClientPrefs.testEngineScore)
		{
			if (!testSongScores.exists(daSong) || testSongScores.get(daSong) < score)
				setScore(daSong, score, misses);
		}
		else
		{
			if (!ogSongScores.exists(daSong) || ogSongScores.get(daSong) < score)
				setScore(daSong, score, misses);
		}
	}

	public static function saveWeekScore(week:String, score:Int = 0, ?diff:Int = 0, misses:Int = 0):Void {
		var daWeek:String = formatSong(week, diff);

		if (ClientPrefs.testEngineScore)
		{
			if (!testWeekScores.exists(daWeek) || testWeekScores.get(daWeek) < score)
				setWeekScore(daWeek, score, misses);
		}
		else
		{
			if (!ogWeekScores.exists(daWeek) || ogWeekScores.get(daWeek) < score)
				setWeekScore(daWeek, score, misses);
		}
	}

	/**
	 * YOU SHOULD FORMAT SONG WITH formatSong() BEFORE TOSSING IN SONG VARIABLE
	 */
	static function setScore(song:String, score:Int, misses:Int):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		ogSongScores.set(song, score);
		if (ClientPrefs.testEngineScore)
		{
			FlxG.save.data.testSongScores = testSongScores;
		}
		else
		{
			FlxG.save.data.ogSongScores = ogSongScores;
		}
		FlxG.save.flush();
	}

	static function setWeekScore(week:String, score:Int, misses:Int):Void {
		// Reminder that I don't need to format this song, it should come formatted!
		if (ClientPrefs.testEngineScore)
		{
			testWeekScores.set(week, score);
			FlxG.save.data.testWeekScores = testWeekScores;
		}
		else
		{
			ogWeekScores.set(week, score);
			FlxG.save.data.ogWeekScores = ogWeekScores;
		}
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

		if (ClientPrefs.testEngineScore)
		{
			if (!testSongScores.exists(daSong))
				setScore(daSong, 0, 0);
	
			return testSongScores.get(daSong);
		}
		else
		{
			if (!ogSongScores.exists(daSong))
				setScore(daSong, 0, 0);
	
			return ogSongScores.get(daSong);
		}
	}

	public static function getWeekScore(week:String, diff:Int):Int {
		var daWeek = formatSong(week, diff);

		if (ClientPrefs.testEngineScore)
		{
			if (!testWeekScores.exists(daWeek))
				setWeekScore(daWeek, 0, 0);
	
			return testWeekScores.get(daWeek);
		}
		else
		{
			if (!ogWeekScores.exists(daWeek))
				setWeekScore(daWeek, 0, 0);
	
			return ogWeekScores.get(daWeek);
		}
	}

	public static function load():Void {
		if (ClientPrefs.testEngineScore)
		{
			if (FlxG.save.data.testSongScores != null)
				testSongScores = FlxG.save.data.testSongScores;
	
			if (FlxG.save.data.testWeekScores != null)
				testWeekScores = FlxG.save.data.testWeekScores;
		}
		else
		{
			if (FlxG.save.data.ogSongScores != null)
				ogSongScores = FlxG.save.data.ogSongScores;
	
			if (FlxG.save.data.ogWeekScores != null)
				ogWeekScores = FlxG.save.data.ogWeekScores;
		}
	}
}
