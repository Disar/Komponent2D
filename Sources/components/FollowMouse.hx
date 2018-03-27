package components;

import komponent.Component;
import komponent.utils.Screen;
import komponent.input.Mouse;

class FollowMouse extends Component
{
	
	override public function update()
	{
		transform.localX = Mouse.x;//kha.Scaler.transformXDirectly(Mouse.x,Mouse.y,Screen.width, Screen.height,kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height,kha.System.screenRotation);
		transform.localY = Mouse.y;//kha.Scaler.transformYDirectly(Mouse.x,Mouse.y,Screen.width, Screen.height,kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height,kha.System.screenRotation);

		trace(transform.localX,transform.localY);
	}
	
}