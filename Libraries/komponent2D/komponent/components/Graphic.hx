package komponent.components;

import komponent.ds.Rectangle;
import kha.Color;

import komponent.ds.Matrix;
import komponent.utils.Misc;

using komponent.utils.Parser;

class Graphic extends Component
{
	
	public var visible:Bool;
	
	public var alpha:Float;
	public var color:Color;
	
	/**
	 * If the graphic should be flipped horizontally or vertically.
	 */
	public var flipX:Bool;
	public var flipY:Bool;
	
	public var width(get, never):Float;
	public var height(get, never):Float;
	
	public var bounds(get, never):Rectangle;
	
	/*
	 * The matrix used to draw the graphic.
	 */
	public var matrix(get, null):Matrix;
	
	override public function added()
	{
		visible = true;
		alpha = 1;
		color = Color.White;
		flipX = flipY = false;
		scene.addGraphic(this);
	}
	/**
	 * Called when the graphic should render.
	 */
	public function render()
	{
		
	}
	
	override public function loadConfig(data:Dynamic)
	{
		visible = data.parse(true);
		alpha = data.alpha.parse(1.0);
		color = data.color.parseColor(Color.White);
	}
	
	private function onTransformChange(_)
	{
		matrix = null;
		scene.removeGraphic(this);
		scene.addGraphic(this);
	}
	
	private function get_width():Float { return 0.0; }
	private function get_height():Float { return 0.0; }
	
	private inline function get_bounds():Rectangle
	{
		trace("get_Bounds() is not overridden!");
		return new Rectangle(0, 0, 0, 0);
	}
	
	private inline function get_matrix():Matrix
	{
		if (matrix == null)
		{
			var translation = Matrix.translation(transform.localX, transform.localY);
			var scale = Matrix.scale(transform.localScaleX * -Misc.sign(flipX), transform.localScaleY * -Misc.sign(flipY));
			var rotation = Matrix.rotation(transform.localRotation * Misc.toRad);
			var centerTranslation = Matrix.translation( - width / 2, - height / 2);
		
			matrix = Matrix.identity();
			matrix.setFrom(matrix.multmat(translation));
			matrix.setFrom(matrix.multmat(scale));
			matrix.setFrom(matrix.multmat(rotation));
			
			if(transform.parent!= null)
			matrix.setFrom(transform.parent.matrix.multmat(matrix));

			matrix.setFrom(matrix.multmat(centerTranslation));
		}
		return matrix;
	}
}