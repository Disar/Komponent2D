package komponent.input;

import kha.input.Keyboard in KhaKeyboard;
import kha.input.KeyCode;

using komponent.utils.Parser;

@:allow(komponent.input.Input)
class Keyboard //TODO: Fix pressed()
{
	
	/**
	 * Contains the string of the last keys pressed
	 */
	public static var keyString:String = "";
	
	/**
	 * Defines a new input.
	 * @param	name		String to map the input to.
	 * @param	chars		The keys to use for the Input.
	 * @param	modifiers	The modifiers to use for the Input.
	 * @param	combination	If this Input defintion requires all keys to be pressed.
	 */
	public static inline function define(name:String, ?chars:Array<KeyCode> = null, ?modifiers:Array<KeyCode> = null, combination = false):Void
	{
		_definitions[name] = new InputDefinition(chars, modifiers, combination);
	}
	
	private static function init()
	{
		if (KhaKeyboard.get() != null)
			KhaKeyboard.get().notify(onKeyDown, onKeyUp, onKeyPressed);
	}
	
	/**
	 * If the input or key is held down.
	 * @param	input		An input name to check for.
	 * @return	True or false.
	 */
	public static function check(input:String):Bool
	{
		// if Input doesn't exists return false
		var definition = _definitions[input];
		if (definition == null)
			return false;
		
		var chars = definition.chars;
		if (chars != null)
		{
			for (char in chars)
			{
				// if key is pressed
				if (_pressedChars.indexOf(char) != -1)
					return true;
			}
		}
		var modifiers = definition.modifiers;
		if (modifiers != null)
		{
			for (modifier in modifiers)
			{
				// if key is pressed
				if (_pressedModifiers.indexOf(modifier) != -1)
					return true;
			}
		}
		return false;
	}
	
	/**
	 * If the input or key was pressed this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function pressed(input:String):Bool
	{
		// if Input doesn't exists return false
		var definition = _definitions[input];
		if (definition == null)
			return false;
		
		var chars = definition.chars;
		if (chars != null)
		{
			for (char in chars)
			{
				// if key is pressed
				if (_pressedChars.indexOf(char) != -1)
					return true;
			}
		}
		var modifiers = definition.modifiers;
		if (modifiers != null)
		{
			for (modifier in modifiers)
			{
				// if key is pressed
				if (_pressedModifiers.indexOf(modifier) != -1)
					return true;
			}
		}
		return false;
	}
	
	/**
	 * If the input or key was released this frame.
	 * @param	input		An input name or key to check for.
	 * @return	True or false.
	 */
	public static function released(input:String):Bool
	{
		// if Input doesn't exists return false
		var definition = _definitions[input];
		if (definition == null)
			return false;
		
		var chars = definition.chars;
		if (chars != null)
		{
			for (char in chars)
			{
				// if key is pressed
				if (_releasedChars.indexOf(char) != -1)
					return true;
			}
		}
		var modifiers = definition.modifiers;
		if (modifiers != null)
		{
			for (modifier in modifiers)
			{
				// if key is pressed
				if (_releasedModifiers.indexOf(modifier) != -1)
					return true;
			}
		}
		return false;
	}
	
	private static inline function update()
	{	
		_releasedChars = [];
		_releasedModifiers = [];
	}
	
	public static inline function loadConfig(data:Dynamic)
	{
		var definitions:Array<Dynamic> = data.definitions;
		if (definitions != null)
		{
			for (definition in definitions)
			{
				var name:String = definition.name;
				if (name == null)
				{
					trace("Input Definition is missing a name: " + definition);
					continue;
				}
				
				var chars:Array<KeyCode> = definition.chars;
				
				var modifiers:Array<KeyCode> = [];
				if (definition.modifiers != null)
				{
					for (dynamicModifier in cast(definition.modifiers, Array<Dynamic>))
					{
						var modifier = dynamicModifier.parseKey(null);
						if  (modifier != null)
							modifiers.push(modifier);
					}
					if (modifiers.length == 0) modifiers = null;
				}
					
				if (chars != null || modifiers != null)
					define(name, chars, modifiers, definition.combination.parse(false));
			}
		}
	}
		
	private static inline function onKeyDown(key:KeyCode):Void
	{
		if (_pressedChars.indexOf(key) == -1)
			_pressedChars.push(key);
		_releasedChars.remove(key);
		
		_pressedModifiers.push(key);
		_releasedModifiers.remove(key);
	}
	private static inline function onKeyUp(key: KeyCode):Void
	{
		_pressedChars.remove(key);
		_releasedChars.push(key);
		
		_pressedModifiers.remove(key);
		_releasedModifiers.push(key);
	}

	private static inline function onKeyPressed(s:String):Void
	{

	}
	
	private static var _definitions:Map<String, InputDefinition> = new Map();
	
	private static var _pressedChars:Array<KeyCode> = [];
	private static var _pressedModifiers:Array<KeyCode> = [];
	
	private static var _releasedChars:Array<KeyCode> = [];
	private static var _releasedModifiers:Array<KeyCode> = [];
}

private class InputDefinition
{
	public var chars:Array<KeyCode>;
	public var modifiers:Array<KeyCode>;
	public var combination:Bool;
	
	public function new(chars:Array<KeyCode>, modifiers:Array<KeyCode>, combination:Bool)
	{
		this.chars = chars;
		this.modifiers = modifiers;
		this.combination = combination;
	}
}