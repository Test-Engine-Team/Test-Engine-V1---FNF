package handlers;

import Song.SwagSong;
import flixel.FlxG;

typedef BPMChangeEvent = {
	var stepTime:Int;
	var songTime:Float;
	var bpm:Float;
}

class Conductor {
	public static var bpm:Float = 100.0;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds
	public static var songPosition:Float;
	public static var offset:Float = 0;

	public static var safeFrames:Int = 10;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000; // is calculated in create(), is safeFrames in milliseconds

	public static var bpmChangeMap:Array<BPMChangeEvent> = [];

	private static var elapsed:Float;

	public function new() {
		FlxG.signals.preUpdate.add(update);
		safeFrames = ClientPrefs.safeFrames;
	}

	function update() {
		elapsed = FlxG.elapsed;
	}

	inline public static function getCrochet(bpm:Float) {
		return (60 / bpm * 1000);
	}

	public static function mapBPMChanges(song:SwagSong) {
		if (song == null)
			throw new haxe.Exception("your song is null/non existent");

		bpmChangeMap = [];

		var curBPM:Float = song.bpm;
		var totalSteps:Int = 0;
		var totalPos:Float = 0;
		for (i in 0...song.notes.length) {
			var doPush = false;
			if (song.notes[i].changeBPM && song.notes[i] != null) {
				curBPM = song.notes[i].bpm;
				doPush = true;
			}
			if (doPush && song.notes[i] != null) {
				var event:BPMChangeEvent = {
					stepTime: totalSteps,
					songTime: totalPos,
					bpm: curBPM
				};
				bpmChangeMap.push(event);
			}

			var deltaSteps:Int = song.notes[i].lengthInSteps;
			totalSteps += deltaSteps;
			totalPos += ((60 / curBPM) * 1000 / 4) * deltaSteps;
		}
		trace("new BPM map BUDDY " + bpmChangeMap);
	}

	inline public static function changeBPM(newBpm:Float) {
		if (newBpm <= 0 || newBpm == bpm)
			return;

		bpm = newBpm;

		updateCrochet();
	}

	inline static function updateCrochet() {
		crochet = getCrochet(bpm);
		stepCrochet = crochet / 4;
	}
}
