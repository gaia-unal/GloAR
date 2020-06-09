package com.dougmccune.filters
{
	import flash.display.Shader;
	import flash.filters.ShaderFilter;
	import flash.utils.ByteArray;

	public class PixelBenderFilter extends ShaderFilter
	{
		private var _shaderByteCode:Class;
		public function get shaderByteCode():Class { return _shaderByteCode; }
		public function set shaderByteCode(value:Class):void {
			_shaderByteCode = value;
			shader = new Shader(new _shaderByteCode() as ByteArray);
			
			for each(var object:Object in parameters) {
				shader.data[object.key].value = [object.value];
			}
		}
		
		public function PixelBenderFilter(shader:Shader=null)
		{
			super(shader);
		}
		
		private var _parameters:Array;
		public function get parameters():Array { return _parameters; }
		public function set parameters(value:Array):void {
			_parameters = value;
			
			if(shader != null) {
				for each(var object:Object in parameters) {
					shader.data[object.key].value = [object.value];
				}
			}
		}
		
	}
}