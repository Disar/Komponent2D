package komponent.components.audio;

import kha.Sound in KhaSound;
import kha.audio1.AudioChannel;
//import kha.Loader;

class Sound extends Component
{
	
	// volume as float in range 0-1
	public var volume(get, set):Float;
	
	// length of the sound in miliseconds
	public var length(get, never):Float;
	
	// current playback position in miliseconds
	public var currentPosition(get, never):Float;
	
	// if the sound should loop
	public var loop:Bool;
	
	// if the sound is playing
	public var finished(get, never):Bool;
	
	private var _sound:KhaSound;
	private var _soundchannel:AudioChannel;
	private var _stopped:Bool;
	
	override public function added() 
	{
		loop = false;
		_stopped = false;
	}
	
	override public function update()
	{
		if (_soundchannel != null && finished && loop && !_stopped)
			play(loop);
	}
	
	public inline function load(sound:String)
	{
		//_sound = Loader.the.getSound(sound);
		_soundchannel = kha.audio1.Audio.play(_sound);
		_soundchannel.stop();
	}
	
	public inline function play(loop:Bool)
	{
		this.loop = loop;
		_soundchannel.play();
		_stopped = false;
	}
	
	public inline function pause()
	{
		_soundchannel.pause();
	}
	
	public inline function stop()
	{
		_soundchannel.stop();
		_stopped = true;
	}
	
	public inline function unload()
	{
		_sound.unload();
	}
	
	private inline function get_volume():Float { return _soundchannel.volume; }
	private inline function set_volume(value:Float):Float { _soundchannel.volume = value; return value; }
	
	private inline function get_length():Float { return _soundchannel.length; }
	
	private inline function get_currentPosition():Float { return _soundchannel.position; }
	
	private inline function get_finished():Bool { return _soundchannel.finished; }
	
}