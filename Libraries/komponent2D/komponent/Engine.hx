package komponent;

import yaml.Parser;
import yaml.Yaml;

import kha.System;
import kha.Image;
import kha.Scaler;
import kha.Scheduler;
import kha.Framebuffer;

#if debug
import CompileTime;
#end

import komponent.utils.Misc;
import komponent.utils.Time;
import komponent.utils.Painter;
import komponent.utils.Screen;
import komponent.input.Input;

using komponent.utils.Misc;

@:keep
class Engine
{
	
	public var currentScene(default, set):Scene;
	
	public var fps(get, never):Float;
	public var paused:Bool;
	
	public var width:Int;
	public var height:Int;

	// Debug draw
	public var debug:Bool;
	
	// Config
	public var config:Dynamic;
	
	public var backbuffer:Image;
	
	/**
	 * Constructor. Can be used to set the name of this game and to load Rooms.
	 * @param	name			Name to assign to the game.
	 * @param	loadRooms		Rooms that should be loaded before the engine starts
	 * @param	scene			Scene that will be created. Should have no constructor arguments. Default: Scene.
	 * @param	loadingScreen	Loading Screen that is displayed while loading the rooms. Should have no constructor arguments. Default: LoadingScreen.
	 */
	public function new(name:String = "", scene:Class<Scene> = null)
	{
		//_loadRooms = loadRooms;
		paused = false;
		
		#if debug
		debug = true;
		#else
		debug = false;
		#end
		
		if (scene == null)
			_startScene = Scene;
		else
			_startScene = scene;
		
		/*if (loadingScreen == null)
			_loadingScreen = LoadingScreen;
		else
			_loadingScreen = loadingScreen;*/
			
		#if debug
		CompileTime.importPackage("komponent");
		#end


		width = kha.ScreenCanvas.the.width;
		height = kha.ScreenCanvas.the.height;
	}
	
	public function init():Void
	{	
		//Configuration.setScreen(Type.createInstance(_loadingScreen, []));
		//_loadingScreen = null;

		#if debug
		Time.start("loading");
		#end
		//@TODO  load rooms
		kha.Assets.loadEverything(loaded);
	}
	
	private inline function loaded():Void
	{		
		if (kha.Assets.progress == 1.0)
		{
			#if debug
			trace('Rooms loaded in ${Misc.round(Time.stop("loading"), 2)}ms');
			#end
			initEngine();
		}
	}
	
	private function initEngine():Void
	{
		Misc.engine = this;
		
		// init Input
		Input.init();
		
		if (_config != null)
		{
			config = Yaml.parse(Reflect.field(kha.Assets.blobs,_config).toString(), Parser.options().useObjects());
			currentScene = Type.createInstance(config.Engine.scene.type.loadClass(_startScene), []);
			currentScene.loadPrefab(config.Engine.scene);
			
			//name = config.Engine.name.loadDefault("");
			paused = config.Engine.paused.loadDefault(false);
			debug = config.Engine.debug.loadDefault(#if debug true #else false #end);
		}
		else
		{
			currentScene = Type.createInstance(_startScene, []);
		}		
		_startScene = null;
		
		// create backbuffer for rendering and init Painter
		backbuffer = Image.createRenderTarget(width, height);
		Painter.backbuffer = backbuffer;
		
		//Configuration.setScreen(this);
		
		System.notifyOnRender(render);
		Scheduler.addTimeTask(update, 0, 1 / 60);

	}
	
	public function update():Void
	{
		Time.start("updating");
		
		currentScene.update();
		Input.update();
		Time.frames++;
		
		Time.stop("updating");
	}
	
	public function render(framebuffer:Framebuffer):Void
	{
		Time.start("rendering");
		Painter.set(Screen.color, 1);
		Painter.g2.begin();
		currentScene.render();
		Painter.g2.end();
		
		framebuffer.g2.begin(true);
		Scaler.scale(backbuffer, framebuffer, System.screenRotation);
		framebuffer.g2.end();
		
		Time.stop("rendering");
	}
	
	public function onShutdown():Void
	{
		currentScene.quit();
	}
	
	public static function fromConfig(configfile:String):Engine
	{
		var engine:Engine = new Engine("", null);
		engine._config = configfile;
		return engine;
	}
	
	private inline function set_currentScene(value:Scene):Scene
	{
		if (currentScene != null)
		{
			currentScene.end();
		}
		if (currentScene == value)
			return value;
			
		currentScene = value;
		currentScene.engine = this;
		currentScene.begin();
		return value;
	}
	
	private inline function get_fps():Float { return 1 / Time.elapsed; }
	
	private var _startScene:Class<Scene>;
	private var _loadRooms:Array<String>;
	//private var _loadingScreen:Class<Game>;
	
	private var _config:String;
}