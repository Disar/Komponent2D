package scene;

import kha.Color;
import kha.math.Vector2;

import komponent.GameObject;
import komponent.Scene;
import komponent.input.Keyboard;
import komponent.input.Mouse;
import komponent.utils.Screen;
import komponent.components.misc.Camera;
import komponent.components.misc.Debug;
import komponent.components.graphic.Animation;
import komponent.components.physics.Hitbox;
import komponent.components.Physics;
import komponent.components.graphic.Text;
import komponent.utils.Time;
import komponent.input.Input;

import komponent.utils.Config;

import components.Player;

class GameScene extends Scene
{
	
	public var player:GameObject;
	public var ground:GameObject;
	
	public var config:Dynamic;

	override public function begin()
	{
		Config.load("example");
		
		new GameObject("Camera", 0, 0).addComponent(Camera);
		
		Keyboard.define("restart", [kha.input.KeyCode.R], [kha.input.KeyCode.Control], true);
		//Keyboard.define("debug", ["d"], [Key.CTRL], true);
		
		Keyboard.define("camera_up", [kha.input.KeyCode.W]);
		Keyboard.define("camera_down", [kha.input.KeyCode.S]);
		Keyboard.define("camera_left", [kha.input.KeyCode.A]);
		Keyboard.define("camera_right", [kha.input.KeyCode.D]);
		Keyboard.define("camera_rotation_left", [kha.input.KeyCode.Q]);
		Keyboard.define("camera_rotation_right", [kha.input.KeyCode.E]);
		
		Input.defineAxis("camera_horizontal", [KEYBOARD("camera_left", -1), KEYBOARD("camera_right", 1)]);
		Input.defineAxis("camera_vertical", [KEYBOARD("camera_up", -1), KEYBOARD("camera_down", 1)]);
		Input.defineAxis("camera_rotation", [KEYBOARD("camera_rotation_left", -1), KEYBOARD("camera_rotation_right", 1)]);
		
		Screen.color = Color.fromString("#57A2DF");
		
		player = new GameObject("Player", 0, 0, "player");
		player.addComponent(Player);
		
		ground = new GameObject("Ground", 0, Screen.bottom - 10, "ground");
		var hitbox = ground.addComponent(Hitbox);
		hitbox.setSize(Screen.width, 10);
		
		#if debug
		for (go in gameObjects)
			go.addComponent(Debug);
		#end
		Time.scale = 1;
	}
	
	override public function update()
	{
		super.update();
		if (Keyboard.check("restart"))
			engine.currentScene = new GameScene();
		if (Keyboard.check("debug"))
			engine.debug = !engine.debug;
			
		Screen.camera.x += Input.getAxis("camera_horizontal") * 10;
		Screen.camera.y += Input.getAxis("camera_vertical") * 10;
		Screen.camera.rotation += Input.getAxis("camera_rotation") * 5;
			
		if (Mouse.wheel)
			Screen.camera.zoom += Mouse.wheelDelta * 0.1;
	}
	
}