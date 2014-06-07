package komponent.utils;

import kha.Image;
import kha.Color;
import kha.Rectangle;
import kha.Rotation;
import kha.Font;
import kha.Video;
import kha.Painter in KhaPainter;

import nape.geom.GeomPolyList;
import nape.shape.Shape;
import nape.shape.Polygon;
import nape.geom.Vec2List;
import nape.geom.GeomPoly;

class Painter
{
	
	public static var painter:KhaPainter;
	
	public static var color(never, set):Color;
	public static var alpha(get, set):Float;
	public static var font(never, set):Font;
	
	public static inline function drawCircle(cx:Float, cy:Float, r:Float, scaleX:Float = 1, scaleY:Float = 1, strength:Float = 1, segments:Int = 0):Void
	{
		cx = (cx - Screen.halfWidth) * scaleX + Screen.halfWidth;
		cy = (cy - Screen.halfHeight) * scaleY + Screen.halfHeight;
		
		if (segments <= 0)
			segments = Std.int(10 * Math.sqrt(r));
			
		var theta = 2 * Math.PI / segments;
		var c = Math.cos(theta);
		var s = Math.sin(theta);
		
		var x = r;
		var y = 0.0;
		
		for (n in 0...segments)
		{
			var px = x + cx;
			var py = y + cy;
			
			var t = x;
			x = c * x - s * y;
			y = c * y + s * t;
			
			painter.drawLine(px, py, x + cx, y + cy, strength);
		}
	}
	
	public static inline function fillCircle(cx:Float, cy:Float, r:Float, scaleX:Float = 1, scaleY:Float = 1, segments:Int = 0):Void
	{
		cx = (cx - Screen.halfWidth) * scaleX + Screen.halfWidth;
		cy = (cy - Screen.halfHeight) * scaleY + Screen.halfHeight;
		
		if (segments <= 0)
			segments = Std.int(10 * Math.sqrt(r));
			
		var theta = 2 * Math.PI / segments;
		var c = Math.cos(theta);
		var s = Math.sin(theta);
		
		var x = r;
		var y = 0.0;
		
		for (n in 0...segments)
		{
			var px = x + cx;
			var py = y + cy;
			
			var t = x;
			x = c * x - s * y;
			y = c * y + s * t;
			
			painter.fillTriangle(px, py, x + cx, y + cy, cx, cy);
		}
	}
	
	public static inline function drawImage5(image:Image, x:Float, y:Float,rotation:Rotation, scaleX:Float = 1, scaleY:Float = 1, flipX:Bool = false, flipY:Bool = false, center:Bool = false, useCamera:Bool = false, sourceRect:Rectangle = null, tiledWidth:Int = 0, tiledHeight:Int = 0, fillScreen:Bool = false):Void
	{
		var sx:Float, sy:Float, sw:Float, sh:Float, dw:Float, dh:Float;
		
		if (sourceRect == null)
		{
			dw = image.width * scaleX;
			dh = image.height * scaleY;
			
			sx = sy = 0;
			sw = image.width;
			sh = image.height;
		}
		else
		{
			dw = sourceRect.width * scaleX;
			dh = sourceRect.height * scaleY;
			
			sx = sourceRect.x;
			sy = sourceRect.y;
			sw = sourceRect.width;
			sh = sourceRect.height;
		}
		
		if (center)
		{
			x -= dw / 2;
			y -= dh / 2;
		}
		
		if (flipX)
		{
			x += dw;
			dw *= -1;
		}
		if (flipY)
		{
			y += dh;
			dh *= -1;
		}
		
		if (useCamera)
		{
			x -= Screen.camera.x;
			y -= Screen.camera.y;
			
			x = (x - Screen.halfWidth) * Screen.fullScaleX + Screen.halfWidth;
			y = (y - Screen.halfHeight) * Screen.fullScaleY + Screen.halfHeight;
			
			dw *= Screen.fullScaleX;
			dh *= Screen.fullScaleY;
		}
		
		if (fillScreen)
		{
			x = 0;
			y = 0;
			tiledWidth = Screen.width;
			tiledHeight = Screen.height;
		}
		
		if (tiledWidth > 0 && tiledHeight > 0)
		{
			var tx = 0.0;
			var ty = 0.0;
			
			while (ty < tiledHeight)
			{
				while (tx < tiledWidth)
				{
					Painter.drawImage2(image, sx, sy, dw, sh, x + tx, y + ty, dw, dh, rotation);
					tx += sw;
				}
				tx = 0;
				ty += sh;
			}
		}
		else
		{
			drawImage2(image, sx, sy, sw, sh, x, y, dw, dh, rotation);
		}
	}
	
	public static inline function drawRect2(x:Float, y:Float, width:Float, height:Float, angle:Float = 0, centerX:Float = null, centerY:Float = null, strength:Float = 1.0):Void
	{
		if (centerX == null)
			centerX = x;
		if (centerY == null)
			centerY = y;
			
		x = (x - Screen.halfWidth) * Screen.fullScaleX + Screen.halfWidth;
		y = (y - Screen.halfHeight) * Screen.fullScaleY + Screen.halfHeight;
		
		var rad = angle * Misc.toRad;
		var sin = Math.sin(rad);
        var cos = Math.cos(rad);
		
		var x1 = cos * (x - centerX) - sin * (y - centerY) + centerX;
		var y1 = sin * (x - centerX) + cos * (y - centerY) + centerY;
		
		var x2 = cos * (x + width - centerX) - sin * (y - centerY) + centerX;
		var y2 = sin * (x + width - centerX) + cos * (y - centerY) + centerY;
		
		var x3 = cos * (x + width - centerX) - sin * (y + height - centerY) + centerX;
		var y3 = sin * (x + width - centerX) + cos * (y + height - centerY) + centerY;
		
		var x4 = cos * (x - centerX) - sin * (y + height - centerY) + centerX;
		var y4 = sin * (x - centerX) + cos * (y + height - centerY) + centerY;
		
		drawLine(x1, y1, x2, y2, strength);
		drawLine(x2, y2, x3, y3, strength);
		drawLine(x3, y3, x4, y4, strength);
		drawLine(x4, y4, x1, y1, strength);
	}
	
	public static inline function fillRect2(x:Float, y:Float, width:Float, height:Float, angle:Float = 0, centerX:Float = null, centerY:Float = null):Void
	{
		if (centerX == null)
			centerX = x;
		if (centerY == null)
			centerY = y;
			
		x = (x - Screen.halfWidth) * Screen.fullScaleX + Screen.halfWidth;
		y = (y - Screen.halfHeight) * Screen.fullScaleY + Screen.halfHeight;
		
		var rad = angle * Misc.toRad;
		var sin = Math.sin(rad);
        var cos = Math.cos(rad);
		
		var x1 = cos * (x - centerX) - sin * (y - centerY) + centerX;
		var y1 = sin * (x - centerX) + cos * (y - centerY) + centerY;
		
		var x2 = cos * (x + width - centerX) - sin * (y - centerY) + centerX;
		var y2 = sin * (x + width - centerX) + cos * (y - centerY) + centerY;
		
		var x3 = cos * (x + width - centerX) - sin * (y + height - centerY) + centerX;
		var y3 = sin * (x + width - centerX) + cos * (y + height - centerY) + centerY;
		
		var x4 = cos * (x - centerX) - sin * (y + height - centerY) + centerX;
		var y4 = sin * (x - centerX) + cos * (y + height - centerY) + centerY;
		
		fillTriangle(x1, y1, x2, y2, x3, y3);
		fillTriangle(x3, y3, x4, y4, x1, y1);
	}
	
	public static inline function drawPolygon(polygon:Polygon, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1, strength:Float = 1):Void
	{
		x = ((polygon.body.position.x + x - Screen.halfWidth) * scaleX + Screen.halfWidth) - polygon.body.position.x;
		y = ((polygon.body.position.y + y - Screen.halfHeight) * scaleY + Screen.halfHeight) - polygon.body.position.y;
		
		if (scaleX == 0 && scaleY == 0)
		{
			var iterator = polygon.worldVerts.iterator();
			
			var v0 = iterator.next();
			var v1 = v0;

			while (iterator.hasNext())
			{
				var v2 = iterator.next();
				Painter.drawLine(v1.x + x, v1.y + y, v2.x + x, v2.y + y, strength);
				v1 = v2;
			}
			Painter.drawLine(v1.x + x, v1.y + y, v0.x + x, v0.y + y, strength);
		}
		else
		{
			var polygonCopy:Polygon = cast polygon.copy();
			polygonCopy.body = polygon.body;
			polygonCopy.scale(scaleX, scaleY);
			var iterator = polygonCopy.worldVerts.iterator();
			
			var v0 = iterator.next();
			var v1 = v0;

			while (iterator.hasNext())
			{
				var v2 = iterator.next();
				Painter.drawLine(v1.x + x, v1.y + y, v2.x + x, v2.y + y, strength);
				v1 = v2;
			}
			Painter.drawLine(v1.x + x, v1.y + y, v0.x + x, v0.y + y, strength);
			polygonCopy.body = null;
		}
	}
	
	public static inline function fillPolygon(polygon:Polygon, x:Float = 0, y:Float = 0, scaleX:Float = 1, scaleY:Float = 1):Void
	{
		x = (polygon.body.position.x + x - Screen.halfWidth) * scaleX + Screen.halfWidth;
		y = (polygon.body.position.y + y - Screen.halfHeight) * scaleY + Screen.halfHeight;
		
		var polygons:GeomPolyList;
		if (scaleX == 0 && scaleY == 0)
		{
			var geompoly = GeomPoly.get(polygon.worldVerts);
			polygons = geompoly.triangularDecomposition();
			geompoly.dispose();
		}
		else
		{
			var polygonCopy:Polygon = cast polygon.copy();
			polygonCopy.scale(scaleX, scaleY);
			polygonCopy.body = polygon.body;
			
			var geompoly = GeomPoly.get(polygonCopy.worldVerts);
			polygons = geompoly.triangularDecomposition();
			geompoly.dispose();
			
			polygonCopy.body = null;
		}
		
		for (polygon in polygons)
		{
			var iterator = polygon.iterator();
			for (i in 0...polygon.size())
			{
				var v1 = iterator.next();
				var v2 = iterator.next();
				var v3 = iterator.next();
				Painter.fillTriangle(v1.x + x, v1.y + y, v2.x + x, v2.y + y, v3.x + x, v3.y + y);
			}
			polygon.dispose();
		}
	}
	
	// draws a cross with center at x/y
	public static inline function drawCross(x:Float, y:Float, width:Float, height:Float, strength:Float = 1):Void
	{
		x = (x - Screen.halfWidth) * Screen.fullScaleX + Screen.halfWidth;
		y = (y - Screen.halfHeight) * Screen.fullScaleY + Screen.halfHeight;
		
		x -= width / 2;
		y -= height / 2;
		
		drawLine(x, y, x + width, y + height, strength);
		drawLine(x + width, y, x, y + height, strength);
	}
	
	public static inline function set(color:Color, alpha:Float, font:Font = null):Void
	{
		Painter.color = color;
		Painter.alpha = alpha;
		if (font != null)
			Painter.font = font;
	}
		
	private static inline function set_color(value:Color) { painter.setColor(value); return value; }
	private static inline function get_alpha() { return painter.get_opacity(); }
	private static inline function set_alpha(value:Float) { return painter.set_opacity(value); }
	private static inline function set_font(value:Font) { painter.setFont(value); return value; }
	
	public static inline function drawImage(image: Image, x: Float, y: Float) { painter.drawImage(image, x, y); }
	public static inline function drawImage2(image: Image, sx: Float, sy: Float, sw: Float, sh: Float, dx: Float, dy: Float, dw: Float, dh: Float, rotation: Rotation = null) { painter.drawImage2(image, sx, sy, sw, sh, dx, dy, dw, dh, rotation); }
	public static inline function drawRect(x: Float, y: Float, width: Float, height: Float, strength: Float = 1.0) { painter.drawRect(x, y, width, height, strength); }
	public static inline function fillRect(x: Float, y: Float, width: Float, height: Float) { painter.fillRect(x, y, width, height); }
	public static inline function drawChars(text: String, offset: Int, length: Int, x: Float, y: Float) { painter.drawChars(text, offset, length, x, y); }
	public static inline function drawString(text: String, x: Float, y: Float, scaleX: Float = 1.0, scaleY: Float = 1.0, scaleCenterX: Float = 0.0, scaleCenterY: Float = 0.0) { painter.drawString(text, x, y, scaleX, scaleY, scaleCenterX, scaleCenterY); }
	public static inline function drawLine(x1: Float, y1: Float, x2: Float, y2: Float, strength: Float = 1.0) { painter.drawLine(x1, y1, x2, y2, strength); }
	public static inline function drawVideo(video: Video, x: Float, y: Float, width: Float, height: Float) { painter.drawVideo(video, x, y, width, height); }
	public static inline function fillTriangle(x1: Float, y1: Float, x2: Float, y2: Float, x3: Float, y3: Float) { painter.fillTriangle(x1, y1, x2, y2, x3, y3); }
	public static inline function translate(x: Float, y: Float) { painter.translate(x, y); }
	public static inline function clear() { painter.clear(); }
}