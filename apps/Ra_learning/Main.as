package{
	
	
	import flash.display.MovieClip;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.events.StatusEvent;
	import org.papervision3d.core.utils.virtualmouse.*;
	import com.soulwire.media.MotionTracker;
	import flash.display.SimpleButton;
	import flash.events.ProgressEvent;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.display.Loader;
	
	public class Main extends MovieClip
	{
		public var botonwebcam:Botonwebcam;
		public var botonmouse:Botonmouse;
		public var botonsonido:Botonsonido;
		public var cam:Camera;
		public var mouse:VirtualMouse;	
		public var _motionTracker:MotionTracker;
		public var timer: Timer;
		public var timerModel: Timer;
		private var motionMouse: MotionMouse;
		
		
		public var _swf1:MovieClip 
		
		//constructor
		public function Main() 
		{
			introtext.visible=false;
			this.addChild(botoninfo);
			botoninfo.addEventListener(MouseEvent.CLICK, eventobotoninfo);
			butonentrar.addEventListener(MouseEvent.CLICK, eventobotonentrar);
			botontopologia.visible=false;
			botondispositivos.visible=false;
			botonvideotuto.visible=false;
			veloboton.visible=false;
			textmodo.visible=false;
			cerrarswf.visible=false;
			botoninstrucciones.visible=false;
			instruccion1.visible=false;
			
			
			
		}
		
		public function eventobotoninfo(e:MouseEvent){
			
			this.addChild(introtext);
			introtext.visible=true;
			introtext.gotoAndPlay(2);
			introtext.info.cerrar.addEventListener(MouseEvent.CLICK, eventocerrarinfo);
		
		}
		
		public function eventobotonentrar(e:MouseEvent){
			
			this.gotoAndStop(2);
			botoninfo.visible=false;
			back.visible=false;
		}
		
		
		public function eventocerrarinfo(e:MouseEvent){
			
			this.removeChild(introtext);
		
		}
		
		//agrega eventos a los camara, mouse, sonido
		public function modobotones(){
		
			botonwebcam=new Botonwebcam();
			this.addChild(botonwebcam);
			botonmouse=new Botonmouse();
			this.addChild(botonmouse);
			botonsonido=new Botonsonido();
			this.addChild(botonsonido);
			textmodo.visible=true;
			botonmouse.addEventListener(MouseEvent.CLICK, iniciamouse);
			botonwebcam.addEventListener(MouseEvent.CLICK, iniciacamara);
			botonsonido.addEventListener(MouseEvent.CLICK, iniciasonido);
		}
		
		//evento camara
		public function iniciacamara(e:MouseEvent){
			
			textmodo.visible=false;
			velo.visible=false;
			
			this.removeChild(botonmouse);
			this.removeChild(botonwebcam);
			this.removeChild(botonsonido);
			initVideo();
		}
		
		//inicia el video, con motionTracking
		private function initVideo():void
		{
			
			if(Camera.names.length>0){
				  
				 cam = Camera.getCamera();
				 cam.addEventListener(StatusEvent.STATUS, statusHandler);
				 cam.setMode( 320, 240, 25);
				  
				 
				 video.attachCamera( cam );
				 this.addChild(video);
				 this.addChild(maskcam);
				 
				 this.addChild(veloboton);
							
				 var vid:Video = new Video( this.video.width, this.video.height );
				 vid.attachCamera( cam );
				 
				 motionMouse= new MotionMouse(vid, this, stage);
			     this.mouse= motionMouse.mouse;
				 this._motionTracker= motionMouse._motionTracker;
				 timer= new Timer(400, 0);
				 timer.addEventListener(TimerEvent.TIMER, timeOut);
				 
				 adicionareventoswebcam();
				 
				 
												 
			}
		}
		
		public function adicionareventoswebcam(){
			botontopologia.addEventListener(MouseEvent.CLICK, RAtopologia);
			botontopologia.addEventListener(MouseEvent.ROLL_OVER, virtualMouseOver);
			botontopologia.addEventListener(MouseEvent.ROLL_OUT, virtualMouseOut);
			botondispositivos.addEventListener(MouseEvent.CLICK, RAdispositivos);
			botondispositivos.addEventListener(MouseEvent.ROLL_OVER, virtualMouseOver);
			botondispositivos.addEventListener(MouseEvent.ROLL_OUT, virtualMouseOut);
			botonvideotuto.addEventListener(MouseEvent.CLICK, RAvideos);
			botonvideotuto.addEventListener(MouseEvent.ROLL_OVER, virtualMouseOver);
			botonvideotuto.addEventListener(MouseEvent.ROLL_OUT, virtualMouseOut);
			botoninstrucciones.addEventListener(MouseEvent.CLICK, instrucciones);
			botoninstrucciones.addEventListener(MouseEvent.ROLL_OVER, virtualMouseOver);
			botoninstrucciones.addEventListener(MouseEvent.ROLL_OUT, virtualMouseOut);
		}
		
		//evento click virtual
		private function timeOut(e:TimerEvent):void{
        	
			timer.removeEventListener(TimerEvent.TIMER, timeOut);
			mouse.click();
					
        }
		
		public function virtualMouseOver(event:MouseEvent):void {
		// if event is of the type IVirtualMouseEvent
		// the event is from the virtual mouse
		
			if (event is IVirtualMouseEvent){
				
				if(_motionTracker.motionArea.width< video.width && _motionTracker.motionArea.height< video.height+200 ){
					
					
					if(event.target is SimpleButton){
							event.target.downState=event.target.upState;
							event.target.upState=event.target.overState;
							event.target.overState= event.target.downState;
					}
					
					
					if(!timer.running){
						
						timer.start();
					}
				}
			}
		}
		
		public function virtualMouseOut(event:MouseEvent):void {
		
			if (event is IVirtualMouseEvent) {
				if(event.target is SimpleButton){
							event.target.downState=event.target.upState;
							event.target.upState=event.target.overState;
							event.target.overState= event.target.downState;
				}
					
				timer.stop();
				timer.addEventListener(TimerEvent.TIMER, timeOut);
				
			}
		}
		
		
		//evento permiso a camara 
		private function statusHandler(event:StatusEvent):void 
		{ 
			if (cam.muted) 
			{ 
				
			} 
			else 
			{ 
				
				this.addChild(botontopologia);
				botontopologia.visible=true;
				this.addChild(botondispositivos);
				botondispositivos.visible=true;
				this.addChild(botonvideotuto);
				botonvideotuto.visible=true;
				this.addChild(botoninstrucciones);
				botoninstrucciones.visible=true;
				this.addChild(instruccion1);
				instruccion1.visible=false;
				
				
				veloboton.visible=true;
				veloboton.gotoAndPlay(2);
				
			} 
		}
		
		public function instrucciones(e:MouseEvent):void{
		
				this.addChild(instruccion1);
				instruccion1.visible=true;
				instruccion1.gotoAndPlay(2);
				instruccion1.cerrar.addEventListener(MouseEvent.CLICK,cerrarinstru);
		}
		
		public function cerrarinstru(e:MouseEvent):void{
			
			instruccion1.visible=false;
		}
		
		public function RAdispositivos(e:MouseEvent){
			
			trace("click");
		
		}
		
		public function RAvideos(e:MouseEvent){
			
			botontopologia.visible=false;
			botondispositivos.visible=false;
			botonvideotuto.visible=false;
			
			quitar();
			
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loop1);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, done1);
			l.load(new URLRequest("camara/ARvideo.swf"));
		
		}
		
		public function RAtopologia(e:MouseEvent){
			
			botontopologia.visible=false;
			botondispositivos.visible=false;
			botonvideotuto.visible=false;
			
			quitar();
							
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loop);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, done);
			l.load(new URLRequest("camara/MovistarLogo.swf"));
			
		}
		
		
		function loop(e:ProgressEvent):void
		{
			var perc:Number = e.bytesLoaded / e.bytesTotal;
			var frame:Number = Math.ceil(perc*100);
			//preloader.gotoAndPlay(frame);
			trace(frame)
		}
		
		function done(e:Event):void
		{
			_swf1= new MovieClip ();
			_swf1.addChild(e.target.content);
			
			this.addChild(_swf1);
			_swf1.scaleX=-1;
			_swf1.x= 751;
			_swf1.y= 39;
			this.veloboton.gotoAndPlay(15);
			this.addChild(veloboton);
			this.addChild(cerrarswf);
			cerrarswf.visible=true;
			cerrarswf.addEventListener(MouseEvent.CLICK,removeswf);
		}
		
		function loop1(e:ProgressEvent):void
		{
			var perc:Number = e.bytesLoaded / e.bytesTotal;
			var frame:Number = Math.ceil(perc*100);
			//preloader.gotoAndPlay(frame);
			trace(frame)
		}
		
		function done1(e:Event):void
		{
			_swf1= new MovieClip ();
			_swf1.addChild(e.target.content);
			
			this.addChild(_swf1);
			_swf1.x= 46.3;
			_swf1.y= 40.4;
			this.veloboton.gotoAndPlay(15);
			this.addChild(veloboton);
			this.addChild(cerrarswf);
			cerrarswf.visible=true;
			cerrarswf.addEventListener(MouseEvent.CLICK,removeswf);
		}
		
		public function removeswf(e:Event):void{
			
			cerrarswf.visible=false;
			this.removeChild(_swf1);
			veloboton.gotoAndPlay(2);
			this.addChild(botontopologia);
			this.addChild(botondispositivos);
			this.addChild(botonvideotuto);
			this.addChild(botoninstrucciones);
			botontopologia.visible=true;
			botondispositivos.visible=true;
			botonvideotuto.visible=true;
			this.video.attachCamera( cam );
			this.video.visible=true;
		}
		
		
		public function quitar():void{
			
			this.video.attachCamera(null);
			this.video.visible = false;
					
		}
		
		//evento boton mouse
		public function iniciamouse(e:MouseEvent){
			
			textmodo.visible=false;
			velo.visible=false;
			this.removeChild(botonmouse);
			this.removeChild(botonwebcam);
			this.removeChild(botonsonido);
			this.addChild(back);
			back.visible=true;
			this.addChild(veloboton);
			
			this.addChild(botontopologia);
			botontopologia.visible=true;
			
			this.addChild(botonvideotuto);
			botonvideotuto.visible=true;
						
			veloboton.visible=true;
			veloboton.gotoAndPlay(2);
			
			adicionareventosmouse();
		}
		
		public function adicionareventosmouse(){
			
			botontopologia.addEventListener(MouseEvent.CLICK, RAtopologiamouse);
			
			botonvideotuto.addEventListener(MouseEvent.CLICK, RAvideosmouse);
			
			
		}
		
		public function RAtopologiamouse(e:MouseEvent){
			
			botontopologia.visible=false;
			botondispositivos.visible=false;
			botonvideotuto.visible=false;
			
			quitar();
							
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loop);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, done2);
			l.load(new URLRequest("mouse/MovistarLogo.swf"));
			
		}
		
		function done2(e:Event):void
		{
			_swf1= new MovieClip ();
			_swf1.addChild(e.target.content);
			
			this.addChild(_swf1);
			_swf1.x= 44.5;
			_swf1.y= 39;
			this.veloboton.gotoAndPlay(15);
			this.addChild(veloboton);
			this.addChild(cerrarswf);
			cerrarswf.visible=true;
			cerrarswf.addEventListener(MouseEvent.CLICK,removeswfmouse);
		}
		
		function done3(e:Event):void
		{
			_swf1= new MovieClip ();
			_swf1.addChild(e.target.content);
			
			
			_swf1.mask=mascaraswf;
			this.addChild(_swf1);
			_swf1.x= 10;
			_swf1.y= 39;
			
			this.veloboton.gotoAndPlay(15);
			this.addChild(veloboton);
			this.addChild(cerrarswf);
			cerrarswf.visible=true;
			cerrarswf.addEventListener(MouseEvent.CLICK,removeswfmouse1);
		}
		
		public function removeswfmouse(e:Event):void{
			
			cerrarswf.visible=false;
			this.removeChild(_swf1);
			veloboton.gotoAndPlay(2);
			this.addChild(botontopologia);
			this.addChild(botonvideotuto);
			botontopologia.visible=true;
			botonvideotuto.visible=true;
			
		}
		
		public function removeswfmouse1(e:Event):void{
			
			cerrarswf.visible=false;
			
			if(_swf1!=null);
				_swf1.visible=false;
				
			veloboton.gotoAndPlay(2);
			this.addChild(botontopologia);
			this.addChild(botonvideotuto);
			botontopologia.visible=true;
			botonvideotuto.visible=true;
			
		}
		
		public function RAvideosmouse(e:MouseEvent){
			
			botontopologia.visible=false;
			botondispositivos.visible=false;
			botonvideotuto.visible=false;
			
			quitar();
			
			var l:Loader = new Loader();
			l.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loop1);
			l.contentLoaderInfo.addEventListener(Event.COMPLETE, done3);
			l.load(new URLRequest("mouse/CameramanSite.swf"));
		
		}
		
		//evento boton sonido
		public function iniciasonido(e:MouseEvent){
			
			textmodo.visible=false;
			velo.visible=false;
			this.removeChild(botonmouse);
			this.removeChild(botonwebcam);
			this.removeChild(botonsonido);
			
		}
	}
}