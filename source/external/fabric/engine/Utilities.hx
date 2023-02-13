package external.fabric.engine;

/**
 * A class full of various utilities for different tasks.
 * @author Leather128
 */
class Utilities
{
	/**
	 * List of formatting for different byte amounts
	 * in an array formatted like this:
	 * 
	 * [`Format`, `Divisor`]
	 */
	public static var byte_formats:Array<Array<Dynamic>> = [
		["$bytes B", 1.0],
		["$bytes KB", 1024.0],
		["$bytes MB", 1048576.0],
		["$bytes GB", 1073741824.0],
		["$bytes TB", 1099511627776.0]
	];

	/**
	 * Formats `bytes` into a `String`.
	 * 
	 * Examples (Input = Output)
	 * 
	 * ```
	 * 1024 = '1 kb'
	 * 1536 = '1.5 kb'
	 * 1048576 = '2 mb'
	 * ```
	 * 
	 * @param bytes Amount of bytes to format and return.
	 * @param only_value (Optional, Default = `false`) Whether or not to only format the value of bytes (ex: `'1.5 mb' -> '1.5'`).
	 * @param precision (Optional, Default = `2`) The precision of the decimal value of bytes. (ex: `1 -> 1.5, 2 -> 1.53, etc`).
	 * @return Formatted byte string.
	 */
	public static function format_bytes(bytes:Float, only_value:Bool = false, precision:Int = 2):String
	{
		var formatted_bytes:String = "?";

		for (i in 0...byte_formats.length)
		{
			// If the next byte format has a divisor smaller than the current amount of bytes,
			// and thus not the right format skip it.
			if (byte_formats.length > i + 1 && byte_formats[i + 1][1] < bytes)
				continue;

			var format:Array<Dynamic> = byte_formats[i];

			if (!only_value)
				formatted_bytes = StringTools.replace(format[0], "$bytes", Std.string(flixel.math.FlxMath.roundDecimal(bytes / format[1], precision)));
			else
				formatted_bytes = Std.string(flixel.math.FlxMath.roundDecimal(bytes / format[1], precision));

			break;
		}

		return formatted_bytes;
	}
}
