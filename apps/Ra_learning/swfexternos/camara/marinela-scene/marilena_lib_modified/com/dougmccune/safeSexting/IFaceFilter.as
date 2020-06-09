package com.dougmccune.safeSexting
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public interface IFaceFilter
	{
		function applyFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite):void;
		function runFilter(fullWebcam:Sprite, faceOverlayOnly:Sprite, percentageRectangle:Rectangle):void;
	}
}