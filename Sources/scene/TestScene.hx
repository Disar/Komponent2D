package scene ;

import komponent.GameObject;
import komponent.Scene;
import komponent.input.Keyboard;
import komponent.input.Mouse;
import komponent.utils.Screen;
import komponent.components.misc.Camera;
import komponent.components.graphic.Image;
import komponent.components.misc.Debug;
import komponent.components.physics.Hitbox;
import komponent.components.graphic.Animation;

import components.FollowMouse;

class TestScene extends Scene
{
	
	public var config:Dynamic;

	override public function begin()
	{
		//var configData = Loader.the.getBlob("example").toString();
		//config = Yaml.parse(configData, Parser.options().useObjects());
		
		engine.debug = true;
		
		var c = new GameObject("Camera", 0, 0);
		c.addComponent(Camera);
		
		
		Keyboard.define("restart", [kha.input.KeyCode.R]);
		Keyboard.define("debug", [kha.input.KeyCode.D]);
		
		Keyboard.define("up", [kha.input.KeyCode.W], [kha.input.KeyCode.Up]);
		Keyboard.define("down", [kha.input.KeyCode.S], [kha.input.KeyCode.Down]);
		Keyboard.define("left", [kha.input.KeyCode.A], [kha.input.KeyCode.Left]);
		Keyboard.define("right", [kha.input.KeyCode.D], [kha.input.KeyCode.Right]);
		
		var wabbit = new GameObject("Wabbit", 50, 50);
		wabbit.addComponent(Image).load("wabbit");
		wabbit.addComponent(Debug);
		wabbit.addComponent(FollowMouse);
		
		var coin = new GameObject("Coin");
		coin.transform.localScaleX = coin.transform.localScaleY = 5;
		coin.transform.setPos (10, 0);
		var animation = coin.addComponent(Animation);
		animation.loadSpritemap("coinspin", 10, 10);
		animation.add("spin", [0, 1, 2, 3, 4, 5], 6, true);
		animation.play("spin");
		
		wabbit.transform.attach(coin);
		
		var ground = new GameObject("Ground", Screen.halfWidth, Screen.bottom - 10);
		ground.addComponent(Hitbox).setSize(Screen.width, 10);
		ground.addComponent(Debug);
	}
	
	override public function update()
	{
		super.update();
		
		if (Keyboard.check("restart"))
			engine.currentScene = new TestScene();
		if (Keyboard.check("debug"))
			engine.debug = !engine.debug;
		
		if (Mouse.wheel)
			Screen.camera.zoom += Mouse.wheelDelta * 0.01;
	}
	
}