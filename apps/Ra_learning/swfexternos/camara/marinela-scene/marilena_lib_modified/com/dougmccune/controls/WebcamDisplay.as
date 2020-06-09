package com.dougmccune.controls
{
	import flash.media.Camera;
	
	import mx.controls.VideoDisplay;
	import mx.core.EdgeMetrics;
	import mx.core.mx_internal;
	
	use namespace mx_internal;

	public class WebcamDisplay extends VideoDisplay
	{
		public function WebcamDisplay()
		{
			super();
		}
		
		private var cam:Camera;
		
		public var mirror:Boolean = false;
		
		override protected function createChildren():void {
			super.createChildren();
			
			cam = Camera.getCamera();
			cam.setMode(cam.width*1.5, cam.height*1.5, 30);
			attachCamera(cam);
			
			videoPlayer.smoothing = false;
			
			videoPlayer.onMetaData({width:cam.width, height:cam.height});
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			if (!videoPlayer)
	            return;
	
			if(mirror) {
				videoPlayer.scaleX = -videoPlayer.scaleX;
				videoPlayer.x += videoPlayer.width;
			}
		}
		
	}
}