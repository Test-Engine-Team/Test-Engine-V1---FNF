import flixel.FlxSprite;

function create()
{
    inCutscene = true;

    var blackShit:FlxSprite = new FlxSprite(-200, -200).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
    blackShit.scrollFactor.set();
    add(blackShit);

    var vid:FlxVideo = new FlxVideo('music/ughCutscene.mp4');
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

    /* 
        FlxG.sound.playMusic(Paths.music('DISTORTO'), 0);
        FlxG.sound.music.fadeIn(5, 0, 0.5);
        dad.visible = false;
        var tankCutscene:TankCutscene = new TankCutscene(-20, 320);
        tankCutscene.frames = Paths.getSparrowAtlas('cutsceneStuff/tankTalkSong1');
        tankCutscene.animation.addByPrefix('wellWell', 'TANK TALK 1 P1', 24, false);
        tankCutscene.animation.addByPrefix('killYou', 'TANK TALK 1 P2', 24, false);
        tankCutscene.animation.play('wellWell');
        tankCutscene.antialiasing = true;
        gfCutsceneLayer.add(tankCutscene);
        camHUD.visible = false;
        FlxG.camera.zoom *= 1.2;
        camFollow.y += 100;
        tankCutscene.startSyncAudio = FlxG.sound.load(Paths.sound('wellWellWell'));
        new FlxTimer().start(3, function(tmr:FlxTimer)
        {
            camFollow.x += 800;
            camFollow.y += 100;
            FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 0.27, {ease: FlxEase.quadInOut});
            new FlxTimer().start(1.5, function(bep:FlxTimer)
            {
                boyfriend.playAnim('singUP');
                // play sound
                FlxG.sound.play(Paths.sound('bfBeep'), function()
                {
                    boyfriend.playAnim('idle');
                });
            });
            new FlxTimer().start(3, function(swaggy:FlxTimer)
            {
                camFollow.x -= 800;
                camFollow.y -= 100;
                FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom * 1.2}, 0.5, {ease: FlxEase.quadInOut});
                tankCutscene.animation.play('killYou');
                FlxG.sound.play(Paths.sound('killYou'));
                new FlxTimer().start(6.1, function(swagasdga:FlxTimer)
                {
                    FlxTween.tween(FlxG.camera, {zoom: defaultCamZoom}, (Conductor.crochet / 1000) * 5, {ease: FlxEase.quadInOut});
                    FlxG.sound.music.fadeOut((Conductor.crochet / 1000) * 5, 0);
                    new FlxTimer().start((Conductor.crochet / 1000) * 5, function(money:FlxTimer)
                    {
                        dad.visible = true;
                        gfCutsceneLayer.remove(tankCutscene);
                    });
                    cameraMovement();
                    startCountdown();
                    camHUD.visible = true;
                });
            });
    });*/
}