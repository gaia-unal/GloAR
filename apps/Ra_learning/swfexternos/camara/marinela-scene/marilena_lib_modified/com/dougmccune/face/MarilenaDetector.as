﻿package com.dougmccune.face{	import flash.display.BitmapData;	import flash.display.DisplayObject;	import flash.display.Sprite;	import flash.events.TimerEvent;	import flash.geom.Matrix;	import flash.geom.Rectangle;	import flash.media.Camera;	import flash.media.Video;	import flash.utils.Timer;	import jp.maaash.ObjectDetection.ObjectDetector;	import jp.maaash.ObjectDetection.ObjectDetectorOptions;		public class MarilenaDetector	{		/**		 * When a face is detected this callback function gets called. 		 */		public var foundCallback:Function;				/**		 * If no face is found after a full pass then we call the notFoundCallback function.		 */		public var notFoundCallback:Function;				/**		 * The Rectangle that has the coordinates of the last face we found. This rectangle is in raw coordinates.		 */		public var lastFaceRectangle:Rectangle;				/**		 * This is a rectangle that defines the x/y and width/height of the found face as percentage values. The x		 * and y values are the percentage of the webcam's width or height where the face was found. And the width		 * and height of the rectangle are the width and height as percentages of the webcam video.		 * 		 * Often we don't really want to know raw coordinates, since the size of the source image that was scanned is 		 * unimportant. What's really important is the relative coordinates.		 */		public var lastPercentageRectangle:Rectangle;				/**		 * This Rectangle is the rectangle that defines the last rectangle that we checked in the webcam. Since 		 * we aren't doing a full pass over the webcam everytime, sometimes it's useful to know which area we actually		 * checked. If a face is found we then use that rectangle and exapnd it and then only check that expanded area		 * first. This lets us scan a smaller area that's more likely to include the face.		 */		public var lastSourceFaceRectangle:Rectangle;				/**		 * A simple utility property that is a percentage value that tells us where the center of the found face 		 * falls relative to the webcam's width. So if a face is found directly in the middle this should be .5		 */		public var lastPercentX:Number;				/**		 * Another utility property to tell us the percentage value of where the center of the found face was		 * on the y-axis.		 */		public var lastPercentY:Number;				/**		 * The width of the face found as a percentage of the total width of the wecam. This can be useful as a way to 		 * figure out how close to the camera the face is.		 */		public var lastPercentWidth:Number;				/**		 * We are not scanning the complete image each time and are instead only scanning a smaller area around the last face,		 * and additionally we might be rotating the image to check for rotated faces. So this property contains the actual 		 * image that we are sending into the face tracking algorithm. This might be useful if you want to check to see why		 * the face detection might be failing (ie maybe we're checking an incorrect area of the image).		 */		public var lastBitmapChecked:BitmapData;				/**		 * The rotation angle that we last checked. If we found a face then this will be the last successful rotation		 * angle that was used to find the face (might be useful). If we did not find a face then this will be the 		 * last rotation angle we tried (probably not useful at all).		 */		public var lastRotationAngle:Number = 0;				/**		 * If true then we will use a smoothing factor of 5 to smooth out the movement of the found face rectangles. 		 * If set to false then we immediately set the coordinates of the found faces. If this is false then the movement		 * can seem jumpy and sporadic, but depending on the application that might be desired.		 */		public var smoothMovement:Boolean = true;				private var detector    :ObjectDetector;		private var options     :ObjectDetectorOptions;				private var input:DisplayObject;		private var inputHolder:Sprite;				/**		 * Boolean flag indicating if we are in a recursive call to check a rotated image or not.		 */		private var checkingRotations:Boolean = false;				/**		 * Variable we use to mark that we have found a face while checking various rotations. We recursivly call the detection method		 * as we are checking other rotations, so using this variable lets us bail out of the recursive calls once we find a face.		 */		private var rotatedFound:Boolean = false;				/**		 * If we don't find a face on the first pass we will start to rotate the image and check the rotated version. We rotate		 * to a certain angle, check for a face, if not found rotate further, check again, etc. We run through a certain number		 * of rotations that we check, which are defined in this array. Fewer items in this array will lead to faster failed 		 * attempts, but possibly less correctly found faces if the face is rotated.		 */		private var rotationsToCheck:Array = [0, 5, -5, -10, 10, 15, -15, -20, 20, -35, 35, -50, 50];				/**		 * We keep track of the last rotation angle because when we can't find a face we try to sort the rotations that		 * we will be checking to put them in order that is closest to the last successful rotation that we used to find a face.		 * That means that if we last successfully found a face at 15 degrees then we first want to check 15 degrees, then 10 and 20		 * degrees, then 5 and 25 degrees, and so on.		 */		private var lastRotationAngleUsedForSorting:Number;				private var timer:Timer;				private var scaleToCheck:Number;		private var rectangleToCheck:Rectangle;				public function MarilenaDetector()		{			detector = new ObjectDetector();						detector.foundCallback = faceFound;			detector.notFoundCallback = notFound;						options = new ObjectDetectorOptions();			options.min_size  = 30;			options.scale_factor = 1.3;						detector.options = options;						timer = new Timer(0.001, 0);			timer.addEventListener(TimerEvent.TIMER, timerHandler);						var camera:Camera = Camera.getCamera();			var cWidth:Number = camera.width;			var cHeight:Number = camera.height;						camera.setMode(cWidth, cHeight, 30);						inputHolder = new Sprite();						input = new Video();			Video(input).smoothing = false;			Video(input).attachCamera(camera);					input.width = cWidth/2;			input.height = cHeight/2;						inputHolder.addChild(input);						input.x = -input.width/2;			input.y = -input.height/2;		}				private function faceFound(rect:Rectangle):void {						lastSourceFaceRectangle = rect.clone();						rect.x 		*= 1/scaleToCheck;			rect.y 		*= 1/scaleToCheck;			rect.width 	*= 1/scaleToCheck;			rect.height *= 1/scaleToCheck;						if(rectangleToCheck != null) {				rect.x += rectangleToCheck.x;				rect.y += rectangleToCheck.y;			}						if(lastFaceRectangle) {				var dx:Number = lastFaceRectangle.x - rect.x;				var dy:Number = lastFaceRectangle.y - rect.y;				var dw:Number = lastFaceRectangle.width - rect.width;				var dh:Number = lastFaceRectangle.height - rect.height;								if(dx == 0 && dy == 0 && dw == 0 && dh == 0) {					return;				}				else if(dx > -6 && dx < 6 && dy > -6 && dy < 6) {					return;				}								if(smoothMovement) {					var smoothingFactor:Number = 5;										rect.x 		= lastFaceRectangle.x - dx/smoothingFactor;					rect.y 		= lastFaceRectangle.y - dy/smoothingFactor;					rect.width 	= lastFaceRectangle.width - dw/smoothingFactor;					rect.height = lastFaceRectangle.height - dh/smoothingFactor;				}			}						lastPercentageRectangle = new Rectangle((input.width - (rect.x + rect.width))/input.width, rect.y/input.height, rect.width/input.width, rect.height/input.height);						var centerX:Number = input.width - (rect.x + rect.width);			var centerY:Number = input.height - (rect.y + rect.height);						lastPercentX = centerX/(input.width - rect.width);			lastPercentY = 1 - centerY/(input.height - rect.height);						lastPercentWidth = rect.width/input.width;						lastFaceRectangle = rect.clone();						rectangleToCheck = rect.clone();			rectangleToCheck.inflate(rectangleToCheck.width * .4, rectangleToCheck.height * .4); 								if(rectangleToCheck.width > input.width || rectangleToCheck.height > input.height) {				rectangleToCheck = null;			}						if(checkingRotations) {				rotatedFound = true;				checkingRotations = false;			}							if(foundCallback != null) {				foundCallback();			}		}						private function notFound():void {						if(checkingRotations == false) {								if(lastRotationAngle != lastRotationAngleUsedForSorting) {					rotationsToCheck.sort( function(a:int, b:int):int {						var abs1:int = a-lastRotationAngle;						abs1 = abs1 < 0 ? abs1 * -1 : abs1;												var abs2:int = b-lastRotationAngle;						abs2 = abs2 < 0 ? abs2 * -1 : abs2;												if(abs1 < abs2)							return -1;						else if(abs1 > abs2) 							return 1;						else							return 0;					});									lastRotationAngleUsedForSorting = lastRotationAngle;				}								checkingRotations = true;				rotatedFound = false;								var initialRotation:Number = lastRotationAngle;								var numRotations:int = rotationsToCheck.length;								for(var i:int=0; i<numRotations; i++) {					if(initialRotation != rotationsToCheck[i]) {						lastRotationAngle = rotationsToCheck[i];						detect();												if(checkingRotations == false) {							return;						}					}				}								checkingRotations = false;							if(rotatedFound) {					return;				}			}						if(checkingRotations == false && rotatedFound == false) {				if(rectangleToCheck) {					rectangleToCheck.inflate(rectangleToCheck.width * .4, rectangleToCheck.height * .4); 											if(rectangleToCheck.width > input.width || rectangleToCheck.height > input.height) {						rectangleToCheck = null;					}				}								detector.resetLastScaleFactor();								if(notFoundCallback != null) {					notFoundCallback();				}			}		}				public function startDetecting():void {			timer.start();			detect();		}				public function stopDetecting():void {			if(timer.running)				timer.stop();		}				private function timerHandler(event:TimerEvent):void {			detect();			}				private function detect():void {			var targetWidth:Number = 70;						var m:Matrix = new Matrix();						var bitmapData:BitmapData;			input.scaleX = input.scaleY = 1;						var widthToCheck:Number;			var heightToCheck:Number;						if(rectangleToCheck == null) {				rectangleToCheck = new Rectangle(0, 0, input.width, input.height);			}							scaleToCheck = targetWidth/rectangleToCheck.height;							if(scaleToCheck > 1) {				scaleToCheck = 1;			}						widthToCheck = rectangleToCheck.width * scaleToCheck;			heightToCheck = rectangleToCheck.height * scaleToCheck;						if(lastBitmapChecked != null && lastBitmapChecked.width == widthToCheck && lastBitmapChecked.height == heightToCheck) {				bitmapData = lastBitmapChecked;			}			else {				bitmapData = new BitmapData(widthToCheck, heightToCheck, false);				bitmapData.lock();			}						m.translate(-rectangleToCheck.x - input.x, -rectangleToCheck.y - input.y);					   	m.tx -= input.width/2;		  	m.ty -= input.height/2;		  	m.rotate(lastRotationAngle*(Math.PI/180));		  	m.tx += input.width/2;		  	m.ty += input.height/2;			  				m.scale(scaleToCheck, scaleToCheck);			bitmapData.draw(inputHolder, m, null, null);						if(lastBitmapChecked != bitmapData) {				lastBitmapChecked = bitmapData;			}						detector.detect( bitmapData );		}	}}