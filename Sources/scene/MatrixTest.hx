package scene;

import kha.Font;
import kha.input.KeyCode;
import kha.FontStyle;
import kha.Color;

import komponent.ds.Matrix;
import komponent.GameObject;
import komponent.Scene;
import komponent.components.misc.Camera;
import komponent.input.Keyboard;
import komponent.input.Input;
import komponent.input.Mouse;
import komponent.utils.Painter;
import komponent.components.graphic.Image;
import komponent.components.graphic.Text;

import components.ShipController;
import components.CameraController;

class MatrixTest extends Scene
{
	
	public var shipControl:Bool = true;
	
	var font:Font;
	var ship:GameObject;

	override public function begin()
	{
		
	var camera = new GameObject("Camera", 0, 0);
		camera.addComponent(Camera);
		camera.addComponent(CameraController);
		
		ship = new GameObject("Ship", 0, 0);
		ship.addComponent(ShipController);
		ship.transform.localLayer = 0;
		
		
		var rect = new GameObject("Rectangle", 0, 0);
		rect.addComponent(Image).load("Rect");
		rect.transform.localLayer = -1;
		
		//rect.transform.localScaleX = rect.transform.localScaleY = 0.75;

		font = kha.Assets.fonts.droidsans_final_fixed;
		var name = new GameObject("ShipName", 0, -60);
		name.addComponent(Text).set("Ship", font);
		name.transform.localScaleX = name.transform.localScaleY = 2;
		name.transform.attachTo(ship);
		
		Keyboard.define("move_left", [KeyCode.A], [KeyCode.Left]);
		Keyboard.define("move_right", [KeyCode.D], [KeyCode.Right]);
		Keyboard.define("move_up", [KeyCode.W], [KeyCode.Up]);
		Keyboard.define("move_down", [KeyCode.S], [KeyCode.Down]);
		Keyboard.define("rotate_left", [KeyCode.Q]);
		Keyboard.define("rotate_right", [KeyCode.E]);
		Keyboard.define("zoom_in", [KeyCode.R]);
		Keyboard.define("zoom_out", [KeyCode.F]);
		Keyboard.define("switch_control", [KeyCode.Space]);
		
		Input.defineAxis("horizontal", [KEYBOARD("move_left", -1), KEYBOARD("move_right", 1)]);
		Input.defineAxis("vertical", [KEYBOARD("move_up", -1), KEYBOARD("move_down", 1)]);
		Input.defineAxis("rotation", [KEYBOARD("rotate_left", -1), KEYBOARD("rotate_right", 1)]);
		Input.defineAxis("zoom", [KEYBOARD("zoom_in", 1), KEYBOARD("zoom_out", -1)]);
	}
	
	override public function update()
	{
		super.update();
		if (Keyboard.pressed("switch_control"))
			shipControl = !shipControl;
	}
	
	override public function render()
	{
		super.render();
	}
	
}