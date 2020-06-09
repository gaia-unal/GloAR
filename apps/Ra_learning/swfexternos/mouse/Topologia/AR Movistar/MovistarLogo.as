/* 
* This code is based on the FLARToolKit starter kit
* Load an DAE model
*/

 package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.parsers.DAE;
	import org.papervision3d.objects.primitives.Plane;
	import com.greensock.TweenLite;
	import org.papervision3d.view.Viewport3D;
	import org.papervision3d.scenes.Scene3D;
	import org.papervision3d.cameras.Camera3D;
	import org.papervision3d.render.LazyRenderEngine;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.events.FileLoadEvent;
	import com.greensock.*;
	import org.papervision3d.objects.parsers.Max3DS;
	
	public class MovistarLogo  extends MovieClip{
		
		private var viewport:			Viewport3D;
		private var scene:				Scene3D;
		private var camera:				Camera3D;
		private var movistar:DAE;
		private var renderEngine:			LazyRenderEngine;	
		private var containerAs:DisplayObject3D;
		public var ar:ARBase;
		public var listmod:Array=new Array("models/Anillo.DAE","models/Bus.DAE","models/Estrella.DAE","models/Arbol.DAE");
		public var total:int =listmod.length;
		public var cont:int=0;
		public var bandera:Boolean=false;
		
		private var xStart:Number; 
		private var yStart:Number;
		private var accelX:Number = 0;
		private var accelY:Number = 0;
		private var mouseIsDown:Boolean=false;
	
		public function MovistarLogo() {
			
						
			
			this.addChild(flecha_siguiente);
			this.addChild(flecha_atras);
			this.addChild(info);
			this.addChild(loading);
			
			loading.visible=false;
			loading.stop();
			
			
			info.buttonMode=true;
			info.addEventListener(MouseEvent.ROLL_OVER, overeventoinfo);
			info.addEventListener(MouseEvent.ROLL_OUT, outeventoinfo);
			
			flecha_siguiente.addEventListener(MouseEvent.CLICK,eventosiguiente);
			flecha_atras.addEventListener(MouseEvent.CLICK,eventoatras);
			
			
			viewport = new Viewport3D(800 ,600, false, true);
			this.addChild(viewport);
				
			//instantiates a Scene3D instance
			scene = new Scene3D();
				
			//instantiates a Camera3D instance
			camera = new Camera3D();
				
			//renderer draws the scene to the stage
			renderEngine = new LazyRenderEngine(scene, camera, viewport);
			
			movistar = new DAE(false);
			movistar.load(listmod[cont]);
			movistar.addEventListener(FileLoadEvent.LOAD_COMPLETE, fileLoaded);
			movistar.addEventListener(FileLoadEvent.LOAD_PROGRESS, fileProgres);
			movistar.scale= 120;
			movistar.rotationX = -60;
			movistar.z = 20;
			movistar.x=50;
			
			scene.addChild(movistar);
			
			this.addChild(arr);
			arr.alpha=0;
			arr.addEventListener( MouseEvent.MOUSE_DOWN, onMouseDownHandler );	
			arr.addEventListener(Event.ENTER_FRAME, rotate );
			arr.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler );
				
			this.addEventListener( Event.ENTER_FRAME, loop3D );
					
		}
		
		public function eventosiguiente(e:Event){
			
			TweenLite.to(info, 1, {x:267.4, y:1.5});
			if(cont<(total-1)){
				
				
				
				cont=cont+1;
				
				
				if(cont==1){
					info.gotoAndPlay(2);
				}
				
				if(cont==2){
					info.gotoAndPlay(3);
				}
				
				if(cont==3){
					info.gotoAndPlay(4);
				}
				
				
				movistar.load(listmod[cont]);
				movistar.addEventListener(FileLoadEvent.LOAD_COMPLETE, fileLoaded);
				movistar.addEventListener(FileLoadEvent.LOAD_PROGRESS, fileProgres);
				movistar.scale= 120;
				movistar.rotationX = -60;
				movistar.z = 20;
				movistar.x=20;
				
				
			}
				
		}
		
		public function eventoatras(e:Event){
			
			TweenLite.to(info, 1, {x:267.4, y:1.5});
			if(cont>0){
				cont=cont-1;
				
				if(cont==0){
					info.gotoAndPlay(1);
				}
				
				if(cont==1){
					info.gotoAndPlay(2);
				}
				
				if(cont==2){
					info.gotoAndPlay(3);
				}
				
				if(cont==3){
					info.gotoAndPlay(4);
				}
						
				
				movistar.load(listmod[cont]);
				movistar.addEventListener(FileLoadEvent.LOAD_COMPLETE, fileLoaded);
				movistar.addEventListener(FileLoadEvent.LOAD_PROGRESS, fileProgres);
				movistar.scale= 120;
				movistar.rotationX = -60;
				movistar.z = 20;
				movistar.x=20;
				
				
			}
				
		}
		
		
		public function overeventoinfo(e:MouseEvent){
		
			TweenLite.to(info, 1, {x:267.4, y:1.5});
		
		}
		
		public function outeventoinfo(e:MouseEvent){
		
			TweenLite.to(info, 1, {x:19.4, y:-155.5});
		}
		
		private function fileProgres(event:Event):void {
			
			loading.visible=true;
			loading.play();
			
			
		}
		
		private function fileLoaded(event:Event):void {
			
			
			TweenLite.to(info, 1, {x:267.4, y:1.5});
			loading.visible=false;
			loading.stop();
			
		}
		
		
			
		private function loop3D(event:Event):void {
			
						
				renderEngine.render();
						
		}
		
		private function onMouseDownHandler( e:MouseEvent ):void
		{
			mouseIsDown = true;
			showSphere();
			
		}
		
		private function rotate(e:Event):void
		{	
			if (mouseIsDown) {
				var currentX = this.mouseX;				
				var currentY = this.mouseY;
				accelX = currentX - xStart;
				accelY = currentY - yStart;
				
				if( Math.abs(accelX) > 100 )
					accelX = 100;
				
				if( Math.abs(accelY) > 100 )
					accelY = 100;
				
				accelX /= 100;
				accelY /= 100;
			}
			
			movistar.yaw( -2*accelX );
			movistar.pitch( -accelY );
			
			
			accelX*= .5;
			accelY*= .5;
			
			xStart = this.mouseX;
			yStart = this.mouseY;			
		}
		
		private function onMouseUpHandler(e:MouseEvent):void
		{
			mouseIsDown = false;
			hideSphere();
			
		}
		
		private function showSphere()
		{
			arr.alpha = 0.3;
		}
		
		private function hideSphere()
		{
			arr.alpha = 0;
		}
				
	}
}