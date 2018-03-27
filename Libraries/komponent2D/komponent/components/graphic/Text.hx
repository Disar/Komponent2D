package komponent.components.graphic;

import kha.Color;
import kha.Font;
import kha.FontStyle;
import kha.Assets;

import komponent.utils.Painter;
import komponent.utils.Screen;
import komponent.ds.FastMatrix;

using komponent.utils.Parser;

class Text extends Graphic
{
	
	public var text:String;
	public var font:Font;
	public var size(default, set):Float;
	public var fontstyle(default, set):FontStyle;
	
	override public function added() 
	{
		super.added();
		text = "";
	}
	
	override public function render()
	{
		if (visible && font != null)
		{
			Painter.setFont(font);
			for (camera in Screen.cameras)
			{
				Painter.matrix = FastMatrix.fromMatrix3(camera.matrix.multmat(matrix));
				Painter.drawString(text, 0, 0);
				Painter.matrix = null;
			}
		}
	}
	
	public inline function set(text:String, font:Font)
	{
		this.text = text;
		this.font = font;
	}
	
	override public function loadConfig(data:Dynamic):Void
	{
		visible = data.visible.parse(true);
		text = data.text.parse("");
		
		var file:String = data.font.file;
		var size:Float = data.font.size;
		var style:FontStyle = data.style.parseFontStyle(FontStyle.Default);
		if (file != null && data.font.size != null && size > 0){
			font = Reflect.field(Assets.fonts, file); 
		}
	}
	
	private override function get_width():Float { return font.width(Std.int(size),text); }
	private override function get_height():Float { return font.height(Std.int(size)); }
	
	//private inline function get_size():Float { return font.size; }
	private inline function set_size(value:Float):Float
	{
		//font = Loader.the.loadFont(font.name, font.style, value);
		return value;
	}
	
	//private inline function get_fontstyle():FontStyle { return font.style; }
	private inline function set_fontstyle(value:FontStyle):FontStyle
	{
		//font = Loader.the.loadFont(font.name, value, font.size);
		return value;
	}
}