package states.etc.cutscenes;

import scriptStuff.HiScript;
import flixel.tweens.FlxTween;
import handlers.shaders.DropShadowShader;
import haxe.io.Path;
import states.menus.LoadingState;
import flixel.FlxG;
import handlers.Files;
import flixel.addons.text.FlxTypeText;
import openfl.Assets;
import flixel.FlxSprite;
import handlers.MusicBeatSubstate;

using StringTools;

class DialogueCutscene extends MusicBeatSubstate {
	var daFormat:String = "normal";
	var cutsceneBG:FlxSprite;
	var dialogueBox:FlxSprite;
	var text:FlxTypeText;
	var lastTalkVars:Array<String> = ["this isnt set yet", "this is just here to prevent NULL OBJE-"];
	var portait:FlxSprite;
	var commandArray:Array<String>;
	var script:HiScript;

	public function new(filePath:String) {
		super();

		cutsceneBG = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xA8FFFFFF);
		cutsceneBG.alpha = 0;
		add(cutsceneBG);
		var bgTween = FlxTween.tween(cutsceneBG, {alpha: 1}, 0.5);
		portait = new FlxSprite();
		add(portait);
		dialogueBox = new FlxSprite(0, 45);
		add(dialogueBox);
		text = new FlxTypeText(0, 0, 0, "", 32);
		add(text);

		var daText:String = Assets.getText(filePath);
		commandArray = [
			for (line in daText.split('\n'))
				line.trim()
		];

		#if SCRIPTS_ENABLED
		script = new HiScript(Path.directory(filePath) + "/DIALOGUE_ADVANCED");
		if (!script.isBlank && script.expr != null) {
			script.interp.scriptObject = this;
			script.interp.execute(script.expr);
		}
		#end

		untilTalk();

		var formatIndex:Int = LoadingState.modData.diaFormatNames.indexOf(daFormat);
		var format:handlers.ModDataStructures.DialogueFormat = LoadingState.modData.diaFormatList[0];
		if (formatIndex != -1)
			format = LoadingState.modData.diaFormatList[formatIndex];

		dialogueBox.frames = Files.sparrowAtlas(format.boxSpritePath);
		dialogueBox.y = format.y;
		dialogueBox.scale.scale(format.boxScale);
		dialogueBox.updateHitbox();
		dialogueBox.antialiasing = format.boxAntialiasing;
		for (anim in format.anims) {
			if (anim.indices.length > 0)
				dialogueBox.animation.addByIndices(anim.name, anim.prefix, anim.indices, "", anim.fps, anim.looped);
			else
				dialogueBox.animation.addByPrefix(anim.name, anim.prefix, anim.fps, anim.looped);
		}
		text.setPosition(format.textX, format.textY);
		text.fieldWidth = format.textWidth;
		var borderStyle = (format.borderEnabled) ? flixel.text.FlxText.FlxTextBorderStyle.OUTLINE : flixel.text.FlxText.FlxTextBorderStyle.NONE;
		text.setFormat(Files.font(Path.withoutExtension(format.font), Path.extension(format.font)), format.textSize, format.textColor, "left", borderStyle,
			format.borderColor);
		if (format.dropShadow) {
			var shadowShader:DropShadowShader = new DropShadowShader();
			text.shader = shadowShader;
			shadowShader.daShadowColor.value = [
				format.shadowColor.redFloat,
				format.shadowColor.greenFloat,
				format.shadowColor.blueFloat,
				format.shadowColor.alphaFloat
			];
		}

		dialogueBox.animation.play('open');
		var ogCallback = dialogueBox.animation.finishCallback;
		dialogueBox.animation.finishCallback = function(name:String) {
			startTalk();
			dialogueBox.animation.finishCallback = ogCallback;
			#if (SCRIPTS_ENABLED) script.callFunction("firstLine"); #end
		}

		cameras = [FlxG.cameras.list[FlxG.cameras.list.length - 1]];

		#if SCRIPTS_ENABLED script.callFunction("createPost", [bgTween]); #end
	}

	override public function update(elapsed:Float) {
		super.update(elapsed);
		#if (SCRIPTS_ENABLED) script.callFunction("update", [elapsed]); #end
		if (dialogueBox.animation.curAnim == null)
			return;
		if (FlxG.keys.justPressed.ANY && dialogueBox.animation.curAnim.name != "open") {
			#if (SCRIPTS_ENABLED) script.callFunction("nextLine"); #end
			FlxG.sound.play(Files.sound('clickText'), 0.8);
			untilTalk();
			if (commandArray.length > 0)
				startTalk();
			else {
				var finishTween = FlxTween.num(1, 0, 1.2, {onComplete: finishCutscene}, function(num:Float) {
					cutsceneBG.alpha = num;
					dialogueBox.alpha = num;
					text.alpha = num;
					portait.alpha = num;
					text.alpha = num;
				});
				#if (SCRIPTS_ENABLED)
				script.callFunction("onFinish", [finishTween]);
				return;
				#end
			}
			#if (SCRIPTS_ENABLED) script.callFunction("nextLinePost"); #end
		}
	}

	public dynamic function finishCutscene(twn:FlxTween) {
		close();
	}

	function untilTalk() {
		while (!commandArray[0].startsWith("talk") && commandArray.length > 0) {
			var params:Array<String> = commandArray.shift().split(":");
			#if (SCRIPTS_ENABLED) script.callFunction("dialogueCommand", [params]); #end
			switch (params[0]) {
				case "setFormat":
					daFormat = params[1];
				case "setTypeSound":
					text.sounds = [FlxG.sound.load(Files.sound(params[1]), Std.parseFloat(params[2]))];
				case "playMusic":
					FlxG.sound.playMusic(Files.music(params[1]), Std.parseFloat(params[2]));
				case "playSound":
					FlxG.sound.play(Files.sound(params[1]), Std.parseFloat(params[2]));
			}
		}
	}

	function startTalk() {
		var params:Array<String> = commandArray.shift().split(":");
		#if SCRIPTS_ENABLED script.callFunction("onTalk", [params]); #end
		dialogueBox.animation.play(params[1]);
		if (params[2] == "none") {
			lastTalkVars = ["none", "none you dumb"];
			portait.visible = false;
			text.resetText(params[3]);
			text.start(0.04, true);
			return;
		}
		portait.visible = true;
		text.resetText(params[4]);
		text.start(0.04, true);
		if (lastTalkVars[0] != params[2] || lastTalkVars[1] != params[3]) {
			var portaitIndex:Int = LoadingState.modData.diaPortaitNames.indexOf(params[3]);
			var portaitData:handlers.ModDataStructures.DialoguePortait = LoadingState.modData.diaPortaitList[0];
			if (portaitIndex != -1)
				portaitData = LoadingState.modData.diaPortaitList[portaitIndex];
			portait.loadGraphic(Files.image(portaitData.imagePath));
			portait.scale.set(portaitData.scale, portaitData.scale);
			portait.updateHitbox();
			var xStuff:Array<Float> = (params[2] == "left") ? [dialogueBox.x + 50, dialogueBox.x, 1] : [dialogueBox.x + dialogueBox.width - 50, dialogueBox.x
				+ dialogueBox.width, -1];
			portait.x = xStuff[1];
			portait.y = dialogueBox.y - portait.height;
			portait.offset.x += portaitData.xOffset * xStuff[2] * portaitData.scale;
			portait.offset.y += portaitData.yOffset * portaitData.scale;
			portait.flipX = (params[2] == 'left' && portaitData.flipX);
			portait.antialiasing = portaitData.antialiasing;
			portait.alpha = 0;
			var enterTween = FlxTween.tween(portait, {alpha: 1, x: xStuff[0]}, 0.4);
			#if SCRIPTS_ENABLED script.callFunction("newPortait", [enterTween, portaitData, params[3]]); #end
		}
		lastTalkVars = [params[2], params[3]];
		#if SCRIPTS_ENABLED script.callFunction("onTalkPost", [params]); #end
	}
}
