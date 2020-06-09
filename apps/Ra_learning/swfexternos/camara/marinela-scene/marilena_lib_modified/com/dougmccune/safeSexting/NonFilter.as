package com.dougmccune.safeSexting
{
	import flash.geom.Rectangle;
	import flash.display.Sprite;

	public class NonFilter implements IFaceFilter
	{
		public function NonFilter()
		{
		}

		public function applyFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite):void
		{
			fullWebcam.filters = [];
		}
		
		public function runFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite, percentageRectangle:Rectangle):void
		{
			faceOverlayOnly.graphics.clear();
		}
		
	}
}