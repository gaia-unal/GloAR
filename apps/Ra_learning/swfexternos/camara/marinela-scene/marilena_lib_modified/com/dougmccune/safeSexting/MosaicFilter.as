package com.dougmccune.safeSexting
{
	import com.dougmccune.filters.PixelBenderFilter;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;

	public class MosaicFilter implements IFaceFilter
	{
		private var pixelBenderFilter:PixelBenderFilter;
		
		[Embed(source='/assets/MosaicFilter.pbj', mimeType='application/octet-stream')]
		private var shaderClass:Class;
		
		public function MosaicFilter()
		{
			pixelBenderFilter = new PixelBenderFilter();
			pixelBenderFilter.shaderByteCode = shaderClass;
			
			pixelBenderFilter.parameters = [{key:"size", value:25}];
		}

		public function applyFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite):void
		{
			fullWebcam.filters = [pixelBenderFilter];
		}
		
		public function runFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite, percentageRectangle:Rectangle):void
		{
			faceOverlayOnly.graphics.clear();
		}
		
	}
}