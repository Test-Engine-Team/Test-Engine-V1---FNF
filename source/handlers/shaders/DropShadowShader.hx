package handlers.shaders;

import flixel.graphics.tile.FlxGraphicsShader;

class DropShadowShader extends FlxGraphicsShader
{
	@:glFragmentSource('
    #pragma header

	uniform vec4 daShadowColor;

	void main() {
		vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);

		vec4 shadowColor = texture2D(bitmap, vec2(openfl_TextureCoordv.x - (2 / openfl_TextureSize.x), openfl_TextureCoordv.y - (2 / openfl_TextureSize.y)));
		shadowColor = daShadowColor * ceil(shadowColor.a);

		gl_FragColor = mix(shadowColor, color, color.a) * openfl_Alphav;
	}
    ')
	public function new()
	{
		super();
	}
}
