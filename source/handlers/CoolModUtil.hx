package handlers;

import handlers.Files;
import states.mainstates.PlayState;

class CoolModUtil
{
    inline public static function changeCamZoom(camZoom:Float) {
        FlxG.camera.zoom = camZoom;
        trace("new cam zoom " + camZoom);
    }
}