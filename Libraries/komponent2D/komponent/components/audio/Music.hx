package komponent.components.audio;

import kha.Sound in KhaMusic;
import kha.audio1.AudioChannel in Channel;

class Music extends Component
{
	
	// volume as float in range 0-1
	public var volume(get, set):Float;
	
	// length of the music in miliseconds
	public var length(get, never):Float;
	
	// current playback position in miliseconds
	public var currentPosition(get, never):Float;
	
	// if the music should loop
	public var loop(get, set):Bool;
	
	// if the music is playing
	public var finished(get, never):Bool;
	
	private var _channel:Channel;
	private var _music:KhaMusic;
	private var _loop:Bool;
	
	override public function added() 
	{
		_loop = false;
	}
	
	public inline function load(music:String)
	{
		//_music = Loader.the.getMusic(music);
	}
	
	public inline function play(loop:Bool = true)
	{
		_loop = loop;
		_channel = kha.audio1.Audio.play(_music);
	}
	
	public inline function pause()
	{
		_channel.pause();
	}
	
	public inline function stop()
	{
		_channel.stop();
	}
	
	public inline function unload()
	{
		_music.unload();
	}
	
	private inline function get_volume():Float { return _channel.volume; }
	private inline function set_volume(value:Float):Float {  _channel.volume = value; return value; }
	
	private inline function get_length():Float { return _channel.length; }
	
	private inline function get_currentPosition():Float { return _channel.position; }
	
	private inline function get_loop():Bool { return _loop; }
	private inline function set_loop(value:Bool):Bool
	{
		_loop = value;
		if (!finished)
		{
			pause();
			play(value);
		}
		return value;
	}
	
	private inline function get_finished():Bool { return _channel.finished; }
}