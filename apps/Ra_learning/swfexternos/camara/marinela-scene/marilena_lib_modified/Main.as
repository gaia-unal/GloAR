package{
	//deteccion face
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import gs.TweenLite;
	import com.dougmccune.face.MarilenaDetector;
	import com.dougmccune.safeSexting.BlackoutEyesFilter;
	import com.dougmccune.safeSexting.IFaceFilter;
	
	//panorama scene.
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.cameras.FreeCamera3D;
	import org.papervision3d.objects.Cube;
	import org.papervision3d.materials.MaterialsList;
	import org.papervision3d.materials.*
	import org.papervision3d.core.proto.*
	import caurina.transitions.*;

	
	
	public class Main extends Sprite{
		
		//deetccion cara
		private var mDetector:MarilenaDetector;
		private var camera:Camera;
		private var faceMask: Sprite;
		private var mcFace: Face;
		private var timer :Timer;
		
		//panorama
		private var container 	:Sprite;
		private var scene     	:Scene3D;
		private var cam3d    	:FreeCamera3D;
		private var cube      	:Cube;
		private var assetArray	:Array;
		private var bitMaps	  	:Array;
		private var cC			:Array;
		private var count	  	:Number;
		private var panCube		:Sprite;
		private var currentCube;
		private var front;
		private var back;
		private var bottom;	
		private var right;	
		private var left;
		private var top;
	
	
		public function Main():void {
			//deteccion cara
			mDetector = new MarilenaDetector();
			mDetector.foundCallback = faceFound;
			mDetector.notFoundCallback = faceNotFound;
			mDetector.smoothMovement = false;
			setFaceFilter();
			camera = Camera.getCamera();
			camera.setMode( 320, 240, 30);
			//video.attachCamera( camera );
			timer= new Timer(500);
			
			//panorama
			stage.scaleMode = StageScaleMode.NO_SCALE;
			init3D();
			loadAssets();
			bitMaps = new Array();
			stage.quality = StageQuality.LOW;
			
		}
		
		private function faceNotFound():void {
			
			if(timer!=null){
				timer.addEventListener(TimerEvent.TIMER, timerHandler);
				timer.start();
			}
		}
		
		private function timerHandler(event:TimerEvent):void {
			mcFace.visible=false;
		}
		
		private function setFaceFilter():void {
			mcFace= new Face();
			mcFace.visible=false;
			
			mDetector.startDetecting();   
			
		}
		
		private function faceFound():void {
			
			if(timer.running){
				timer.stop();
				timer.removeEventListener(TimerEvent.TIMER, timerHandler);
			}
			
			runFace(mDetector.lastPercentageRectangle);
			/*faceMask.graphics.clear();
			
			faceMask.graphics.lineStyle(1, 0xff0000);
			faceMask.graphics.drawRect(width * mDetector.lastPercentageRectangle.x, height * mDetector.lastPercentageRectangle.y, mDetector.lastPercentageRectangle.width * width, mDetector.lastPercentageRectangle.height * height);
			faceMask.graphics.endFill();*/
		}
		
		public function runFace(percentageRectangle:Rectangle):void
		{
			addChild(mcFace);
			mcFace.visible= true;
			var x1:Number = width * percentageRectangle.x;
			var y1:Number = height * percentageRectangle.y;
			var w1:Number = width * percentageRectangle.width;
			var h1:Number = height * percentageRectangle.height;
			mcFace.x=x1;
			mcFace.y=y1;
			
			trace(x1);
			trace(y1);
			
					
			// Pan
			/*var pan:Number = cam3d.rotationY - 210 * container.mouseX/(stage.stageWidth/2);
			pan = Math.max( -100, Math.min( pan, 100 ) ); // Max speed
			cam3d.rotationY -= pan / 12;
	
			// Tilt
			var tilt:Number = 90 * container.mouseY/(stage.stageHeight/2);
			cam3d.rotationX -= (cam3d.rotationX + tilt) / 12;*/
			
			
			
				
			// Render
			
			stage.addEventListener( Event.ENTER_FRAME, loop );
			
			
			
		}
		
		private function init3D():void
		{
		
			container = new Sprite();
			addChild( container );
			scene = new Scene3D( container );
			cam3d = new FreeCamera3D();
			cam3d.zoom = 1;
			cam3d.focus = 800;
			cam3d.z = 10;
		
		}

	
		private function loadAssets():void
		{
			count = 0;
			assetArray = new Array("back", "front", "right", "left", "top", "down");
			loadOne();
		}
	

	
		private function loadOne():void
		{
			var loaD:Loader = new Loader();
			loaD.contentLoaderInfo.addEventListener(Event.COMPLETE, progfin);
			var urlreq:URLRequest = new URLRequest(assetArray[count]+".jpg");
			loaD.load(urlreq);
			
			panCube = new Sprite();
			
			panCube.x = 30+(count*36);
			panCube.y = 10;
		
			panCube.alpha = 0;
			
			currentCube = panCube;
			
			addChild(panCube);
			
		}


		private function progfin(e:Event):void
		{
			var bm:Bitmap = e.target.content;
			var bmm:BitmapData = bm.bitmapData;
			
			bitMaps.push(bmm);
	
			count+=1;
			if(count < assetArray.length) {
				loadOne();
			} else {
				createCube();
				
			};
			
		}
		
		private function createCube()
		{
			var quality :Number = 24;
		
			// Materials
			var b = new BitmapMaterial( bitMaps[0] );
			var f = new BitmapMaterial( bitMaps[1] );
			var r = new BitmapMaterial( bitMaps[2] );
			var l = new BitmapMaterial( bitMaps[3] );
			var t = new BitmapMaterial( bitMaps[4] );
			var d = new BitmapMaterial( bitMaps[5] );
				
			b.smooth = true;
			f.smooth = true;
			r.smooth = true;
			l.smooth = true;
			t.smooth = true;
			d.smooth = true;
			
			b.oneSide = true;
			f.oneSide = true;
			r.oneSide = true;
			l.oneSide = true;
			t.oneSide = true;
			d.oneSide = true;
			
			
			var materials:MaterialsList = new MaterialsList(
			{
				front: f,
				back:  b,
				right: r,
				left:  l,
				top:   t,
				bottom: d
			} );
			
			
			
		
			var insideFaces  :int = Cube.ALL;
	
			var excludeFaces :int = Cube.NONE;
	
			cube = new Cube( materials, 15000, 15000, 15000, quality, quality, quality, insideFaces, excludeFaces );
	
			scene.addChild( cube, "Cube" );
		}
		
		
		
		private function renderNoMouse(e:Event):void
		{
			
		};
		
	
		private function loop(event:Event):void
		{
			scene.renderCamera( this.cam3d );
		}
	
		
	
	}
}