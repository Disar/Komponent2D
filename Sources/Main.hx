package;

import kha.System;
import komponent.Engine;

import scene.*;

class Main {
	public static function main() {

		System.init({title: "Komponent2D", width: 800, height:600}, function () {
			var e =  new Engine("Test", TestScene);
			e.init();
		});
	}
}