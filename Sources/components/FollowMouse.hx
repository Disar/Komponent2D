package components;

import komponent.Component;
import komponent.utils.Screen;
import komponent.input.Mouse;

class FollowMouse extends Component
{
	
	override public function update()
	{
		transform.localX = Mouse.x-komponent.utils.Screen.halfWidth + komponent.utils.Screen.camera.x;//kha.Scaler.transformXDirectly(Mouse.x,Mouse.y,Screen.width, Screen.height,kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height,kha.System.screenRotation);
		transform.localY = Mouse.y-komponent.utils.Screen.halfHeight+ komponent.utils.Screen.camera.y;//kha.Scaler.transformYDirectly(Mouse.x,Mouse.y,Screen.width, Screen.height,kha.ScreenCanvas.the.width,kha.ScreenCanvas.the.height,kha.System.screenRotation);

		trace(transform.localX,transform.localY);
	}
	
}