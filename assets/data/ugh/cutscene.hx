import states.etc.cutscenes.FlxVideo;

/* not done yet!
function create() {
    inCutscene = true;

    var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    blackShit.scrollFactor.set();
    add(blackShit);

    var vid:FlxVideo = new FlxVideo('videos/ughCutscene.mp4');
    vid.finishCallback = function()
    {
        remove(blackShit);
        FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
        startCountdown();
        cameraMovement();
    };

    FlxG.camera.zoom = defaultCamZoom * 1.2;

    camFollow.x += 100;
    camFollow.y += 100;
}