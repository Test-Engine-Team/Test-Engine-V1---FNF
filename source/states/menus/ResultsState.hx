package states.menus;

import handlers.MusicBeatState;
import flixel.system.FlxSound;

class PauseSubState extends MusicBeatState {
	var music:FlxSound;

	public static var sicks:Int;
	public static var goods:Int;
	public static var bads:Int;
	public static var shits:Int;
	public static var score:Int;
	public static var accuracy:Float;
	public static var songName:String;
	// basically a results screeh
	// this is unfinished!!!
	// basically lets the player know how many notes they hit, how many ssicks, goods, bads, and shits the player got, and the players accuracy
	// these should be in the combo sprites!!

	override public function create()
	{
		//show da shit
	}
}
