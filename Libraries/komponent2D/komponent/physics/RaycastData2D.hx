package komponent.physics;

import differ.data.RayCollision;
import differ.shapes.Ray;
import differ.shapes.Shape;

import komponent.components.Collider;

/**
 * RaycastData with added collider information.
 * See documention of hxCollision.
 */ 
class RaycastData2D
{
	
	public var collider:Collider;
	public var shape:Shape;
	public var ray:Ray;
	
	private var data:RayCollision;
	
	/**
	 * distance along ray that the intersection occurred at.
	 */
	public var start:Float;
	public var end:Float;
	
	public function new(data:RayCollision, coll:Collider) 
	{
		this.data = data;
		collider = coll;
	}
	
	private inline function get_shape():Shape { return data.shape; }
	private inline function get_ray():Ray { return data.ray; }
}