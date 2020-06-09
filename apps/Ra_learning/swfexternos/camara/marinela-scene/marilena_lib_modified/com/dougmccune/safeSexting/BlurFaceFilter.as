package com.dougmccune.safeSexting
{
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;

	public class BlurFaceFilter implements IFaceFilter
	{
		public function BlurFaceFilter()
		{
		}

		public function applyFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite):void
		{
			fullWebcam.filters = [new BlurFilter(80, 80)];
		}
		
		public function runFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite, percentageRectangle:Rectangle):void
		{
			faceOverlayOnly.graphics.clear();
		}
		
	}
}