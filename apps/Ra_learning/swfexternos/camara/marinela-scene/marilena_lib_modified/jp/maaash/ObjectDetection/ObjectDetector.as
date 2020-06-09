//
// Project Marilena
// Object Detection in Actionscript3
// based on OpenCV (Open Computer Vision Library) Object Detection
//
// Copyright (C) 2008, Masakazu OHTSUKA (mash), all rights reserved.
// contact o.masakazu(at)gmail.com
//
// additional optimizations by Mario Klingemann / Quasimondo
// contact mario(at)quasimondo.com
//
// edited by Doug McCune (http://dougmccune.com) to optimize for tracking of real-time webcam video
//
// Redistribution and use in source and binary forms, with or without modification,
// are permitted provided that the following conditions are met:
//
//   * Redistribution's of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//
//   * Redistribution's in binary form must reproduce the above copyright notice,
//     this list of conditions and the following disclaimer in the documentation
//     and/or other materials provided with the distribution.
//
// This software is provided by the copyright holders and contributors "as is" and
// any express or implied warranties, including, but not limited to, the implied
// warranties of merchantability and fitness for a particular purpose are disclaimed.
// In no event shall the Intel Corporation or contributors be liable for any direct,
// indirect, incidental, special, exemplary, or consequential damages
// (including, but not limited to, procurement of substitute goods or services;
// loss of use, data, or profits; or business interruption) however caused
// and on any theory of liability, whether in contract, strict liability,
// or tort (including negligence or otherwise) arising in any way out of
// the use of this software, even if advised of the possibility of such damage.
//
package jp.maaash.ObjectDetection
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;
	
	public class ObjectDetector {
		
		private var tgt       :TargetImage;
		private var _options  :ObjectDetectorOptions;
		
		/**
		 * Using callback functions instead of events for speed.
		 */
		public var foundCallback:Function;
		public var notFoundCallback:Function;
		
		private var cascadesByScale:Dictionary;
		public var lastSuccessfulScale:Number;
		
		private var checkRect:Rectangle;
		
		public function ObjectDetector() {
			tgt = new TargetImage();
			
			cascadesByScale = new Dictionary();
			lastSuccessfulScale = 1;
			checkRect = new Rectangle();
		}

		private var lastBmp:BitmapData;
		
		public function detect( bmp:BitmapData ) :void{
			if (bmp) {
				tgt.bitmapData = bmp;
			}
			
			_detect();
		}
		
		private function _detect() :void {
			var imgw :int = tgt.width, imgh :int = tgt.height;
			var scaledw :int, scaledh :int, limitx  :int, limity  :int, stepx :int, stepy :int, result :int, factor:Number = 1;
			
			/**
			 * Instead of always starting at 1 and scaling up, we start at the last scale factor that successfully found a face.
			 * Since detecting faces in a live video will often involves the faces moving left and right, but not as often closer
			 * or farther (which would require a different scale factor) we can save a lot of time by first just checking the
			 * last scale factor. If we find a face with that scale then we're done and we've saved a lot of time.
			 */
			factor = lastSuccessfulScale;
			
			checkRect.width = checkRect.height = 0;
			
			var fNum:int = 0;
			var numRuns:int = 0;
			
			while(checkRect.width < imgw && checkRect.height < imgh && fNum < 6) {
				fNum++;
				
				/**
				 * The normal algorithm was using a single HaarCascade and then repeatedly setting the scale property
				 * to whatever the current factor we were checking. The problem with that is that setting the scale
				 * loops over all the features in the cascade, and takes more time than I want. The other thing is that
				 * when checking over a webcam image, you end up using a few factor settings, but not that many (totally
				 * dependant on the detector's settings). But say we typically scan through a max of about 5 scale factors,
				 * then we create a single intance of the HaarCascade object for each scale factor and cache it. This means 
				 * the first pass (before any HaarCascades are cached) will take longer, but that the later runs should
				 * be faster.
				 */
				if(cascadesByScale[factor] == null) {
					var newCascade:HaarCascade = new HaarCascade();
					newCascade.targetImage = tgt;
					newCascade.scale = factor;
					cascadesByScale[factor] = newCascade;
				}
				
				var cascade:HaarCascade = cascadesByScale[factor];
				
				checkRect.width  = scaledw = int( cascade.base_window_w * factor );
				checkRect.height = scaledh = int( cascade.base_window_h * factor );
				
				if( scaledw < _options.min_size || scaledh < _options.min_size ){
					factor *= _options.scale_factor;
					continue;
				}
				
				limitx = tgt.width  - scaledw;
				limity = tgt.height - scaledh;
				
				stepx  = scaledw >> 3;
				stepy  = stepx;
				
				var ix:int=0, iy:int=0, startx:int=0, starty:int=0;
				
				for( iy = starty; iy < limity; iy += stepy )
				{
					checkRect.y = iy;
					
					for( ix = startx; ix < limitx; ix += stepx )
					{
						checkRect.x = ix;
						
						result = cascade.run(checkRect);
						
						numRuns++;
						
						if ( result > 0 ) {
							if(foundCallback != null)
								foundCallback(checkRect);
							
							lastSuccessfulScale = factor;
							return;
						}
					}
				}
				
				factor *= _options.scale_factor;
			}
			
			lastSuccessfulScale /= _options.scale_factor;
			
			if(lastSuccessfulScale < 1) {
				lastSuccessfulScale = 1;
			}
							
			if(notFoundCallback != null) {
				notFoundCallback();
			}
		}
		
		public function resetLastScaleFactor():void {
			lastSuccessfulScale /= _options.scale_factor;
			
			if(lastSuccessfulScale < 1) {
				lastSuccessfulScale = 1;
			}
		}

		public function set bitmap( bmp :Bitmap ) :void {
			/**
			 * Setting the bitmapData on the TargetImage class is quite expensive (take a look a the setter in TargetImage),
			 * but I couldn't figure out a good way around it. I was toying with ideas about doing a compare() call on
			 * the previous image with the new one and try to only update the needed pixels, but the TargetImage does
			 * calculations based on surrounding pixels, so I wasn't able to figure out a way to only loop over a partial
			 * list of pixels.
			 */
			tgt.bitmapData = bmp.bitmapData;
		}
		
		public function set options( opt :ObjectDetectorOptions ) :void {
			_options = opt;
		}

	}
}
