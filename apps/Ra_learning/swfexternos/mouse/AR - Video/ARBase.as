/* 
 * This code is based on the FLARToolKit starter kit
 * Codigo base para cargar los parametros necesarios de camara, marcadores y el motor 3d papervision
 */

package {
	
	import flash.display.Sprite;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	
	import org.libspark.flartoolkit.core.FLARCode;
	import org.libspark.flartoolkit.core.param.FLARParam;
	import org.libspark.flartoolkit.core.raster.rgb.FLARRgbRaster_BitmapData;
	import org.libspark.flartoolkit.detector.FLARSingleMarkerDetector;
	import org.libspark.flartoolkit.core.transmat.FLARTransMatResult;
	import org.libspark.flartoolkit.pv3d.FLARBaseNode;
	import org.libspark.flartoolkit.pv3d.FLARCamera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.view.stats.StatsView;
	
	[Event(name="init",type="flash.events.Event")]
	[Event(name="init",type="flash.events.Event")]
	[Event(name="ioError",type="flash.events.IOErrorEvent")]
	[Event(name="securityError",type="flash.events.SecurityErrorEvent")]

	public class ARBase extends Sprite {
		
		private var _loader:URLLoader;
		private var _cameraFile:String;
		private var _codeFile:String;
		private var _width:int;
		private var _height:int;
		private var _codeWidth:int;
		
		protected var _param:FLARParam;
		protected var _code:FLARCode;
		protected var _raster:FLARRgbRaster_BitmapData;
		protected var _detector:FLARSingleMarkerDetector;
		
		protected var _webcam:Camera;
		protected var _video:Video;
		protected var _capture:Bitmap;
		
		protected var _base:Sprite;
		protected var _viewport:Viewport3D;
		protected var _camera3d:FLARCamera3D;
		protected var _scene:Scene3D;
		protected var _renderer:LazyRenderEngine;
		public var _baseNode:FLARBaseNode;
		protected var _resultMat:FLARTransMatResult = new FLARTransMatResult();
		public var detected:Boolean = false;
		
		public function ARBase() {
		}
		/**
		 * Set the variables and Load camera binary file
		 * @param cameraFile
		 * @param codeFile
		 * @param canvasWidth
		 * @param canvasHeight
		 * @param codeWidth
		 * 
		 */
		public function init(cameraFile:String, codeFile:String, canvasWidth:int = 320, canvasHeight:int = 240, codeWidth:int = 80):void {
			this._cameraFile = cameraFile;
			this._width = canvasWidth;
			this._height = canvasHeight;
			this._codeFile = codeFile;
			this._codeWidth = codeWidth;
			
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.BINARY;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadParam);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._loader.load(new URLRequest(this._cameraFile));
		}
		/**
		 * Set the the camera and load the marker text file
		 * @param e
		 * 
		 */
		private function _onLoadParam(e:Event):void {
			this._loader.removeEventListener(Event.COMPLETE, this._onLoadParam);
			this._param = new FLARParam();
			this._param.loadARParam(this._loader.data);
			this._param.changeScreenSize(this._width, this._height);
			
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(Event.COMPLETE, this._onLoadCode);
			this._loader.load(new URLRequest(this._codeFile));
		}
		/**
		 * Load the marker code and initialize webcam an video
		 * @param e
		 * 
		 */
		private function _onLoadCode(e:Event):void {
			this._code = new FLARCode(16, 16);
			this._code.loadARPatt(this._loader.data);
			
			this._loader.removeEventListener(Event.COMPLETE, this._onLoadCode);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.dispatchEvent);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.dispatchEvent);
			this._loader = null;
			
			this._webcam = Camera.getCamera();
			if (!this._webcam) {
				throw new Error('No webcam!!!!');
			}
			this._webcam.setMode(this._width, this._height, 30);
			this._video = new Video(this._width, this._height);
			this._video.attachCamera(this._webcam);
			this._capture = new Bitmap(new BitmapData(this._width, this._height, false, 0), PixelSnapping.AUTO, true);
			
			// setup ARToolkit
			this._raster = new FLARRgbRaster_BitmapData(this._capture.bitmapData);
			this._detector = new FLARSingleMarkerDetector(this._param, this._code, this._codeWidth);
			
			this.onInit();
			// setup webcam
			
		}
		/**
		 * Initialize the 3d scene an the papervision BaseNode
		 */
		protected function onInit():void {
			this._base = this.addChild(new Sprite()) as Sprite;
			
			this._capture.width = 705;
			this._capture.height = 517;
			this._base.addChild(this._capture);
			
			this._viewport = this._base.addChild(new Viewport3D(640, 480)) as Viewport3D;
									
			this._camera3d = new FLARCamera3D(this._param);
			
			this._scene = new Scene3D();
			this._baseNode = this._scene.addChild(new FLARBaseNode()) as FLARBaseNode;
			
			this._renderer = new LazyRenderEngine(this._scene, this._camera3d, this._viewport);
			
			this.addEventListener(Event.ENTER_FRAME, this._onEnterFrame);
		}
		/**
		 * Sets the baseNode position on base to te marker detection
		 */
		private function _onEnterFrame(e:Event = null):void {
						
			this._capture.bitmapData.draw(this._video);
			if (this._detector.detectMarkerLite(this._raster, 100) && this._detector.getConfidence() > 0.4) {
				this._detector.getTransformMatrix(this._resultMat);
				this._baseNode.setTransformMatrix(this._resultMat);
				this._baseNode.visible = true;
				this.detected = true;
			} else {
				this._baseNode.visible = false;
				this.detected = false;
			}
			this._renderer.render();
		}
	}
}