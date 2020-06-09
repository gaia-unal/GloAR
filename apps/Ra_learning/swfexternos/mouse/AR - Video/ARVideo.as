/* 
 * This code is based on the FLARToolKit starter kit
 * 
 */


package {
	
	import flash.display.*;
	import flash.events.*;
	import flash.system.Security;
	import org.papervision3d.scenes.*;
	import org.papervision3d.cameras.*;
	import org.papervision3d.lights.*;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Matrix3D;
	import org.papervision3d.materials.VideoStreamMaterial;
	import org.papervision3d.materials.MovieMaterial;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.objects.DisplayObject3D;
	import flash.net.NetConnection;
    import flash.net.NetStream;  
    import flash.media.Video;
	import flash.net.URLRequest;
	import com.greensock.*;
	
	public class ARVideo extends ARBase {
		
		private var earth:Sphere;
		private var plane:Plane;
		private var movMat:VideoStreamMaterial;
		private var nc:NetConnection;
		private	var ns:NetStream;
		private	var client:Object;
		private	var vid:Video;
		
		private var loader:Loader;
		private var mat:MovieMaterial;
		private var mov:MovieClip = new MovieClip();
		public var bandera:Boolean=false;
		public var vid1:String="videos/como hacer un cable de red paso a paso crimpado o ponchado.flv";
		/**
		 * The camera and marker paths
		 * 
		 */
		public function ARVideo() {
			
			Security.allowInsecureDomain("*");
			Security.allowDomain("*");
			this.init('Data/camera_para.dat', 'Data/marker16.pat');
			
		}
		
		
		protected override function onInit():void {
			super.onInit(); 
			
			nc = new NetConnection();
            nc.connect (null);
            ns = new NetStream(nc);
			vid = new Video(320,240);
			client = new Object();
			ns.client = client;
			client.onMetaData = nsMetaDataCallback;
			vid.attachNetStream ( ns );
			
			
			
			this.addEventListener( Event.ENTER_FRAME, loop3D );
			this.addChild(background);
			link_1.addEventListener(MouseEvent.CLICK, video2);
			link_1.addEventListener(MouseEvent.ROLL_OVER, efecto1over);
			link_1.addEventListener(MouseEvent.ROLL_OUT, efecto1out);
			
			link_2.addEventListener(MouseEvent.CLICK, video1);
			link_2.addEventListener(MouseEvent.ROLL_OVER, efecto2over);
			link_2.addEventListener(MouseEvent.ROLL_OUT, efecto2out);
			
			
			link_3.addEventListener(MouseEvent.ROLL_OVER, efecto3over);
			link_3.addEventListener(MouseEvent.ROLL_OUT, efecto3out);
			
			link_4.addEventListener(MouseEvent.CLICK, video3);
			link_4.addEventListener(MouseEvent.ROLL_OVER, efecto4over);
			link_4.addEventListener(MouseEvent.ROLL_OUT, efecto4out);
			this.addChild(link_1);
			this.addChild(link_2);
			this.addChild(link_3);
			this.addChild(link_4);
			
		}
		
		public function video1(e:MouseEvent):void{
			
			vid1 ="videos/como hacer un cable de red paso a paso crimpado o ponchado.flv";
			this._baseNode.removeChild(this.plane);
			bandera=false;
		
		}
		
		public function video2(e:MouseEvent):void{
			
			vid1 ="videos/Topologias_de_Red_-_Parte_I_(HQ).flv";
			this._baseNode.removeChild(this.plane);
			bandera=false;
		
		}
		
		public function video3(e:MouseEvent):void{
			
			vid1 ="videos/Topologias_de_Red_-_Parte_II_(HQ).flv";
			this._baseNode.removeChild(this.plane);
			bandera=false;
		
		}
		
		public function efecto1over(e:MouseEvent):void{
				this.addChild(link_1);
				TweenLite.to(link_1, 1, {x:308.6, y:438.8, scaleX:1.3, scaleY:1.3});
		}
		
		public function efecto1out(e:MouseEvent):void{
				this.addChild(link_1);
				TweenLite.to(link_1, 1, {x:308.6, y:438.8, scaleX:0.7, scaleY:0.7});
		}
		
		public function efecto2over(e:MouseEvent):void{
			this.addChild(link_2);
				TweenLite.to(link_2, 1, {x:226.7, y:438.8, scaleX:1.3, scaleY:1.3});
		}
		
		public function efecto2out(e:MouseEvent):void{
			this.addChild(link_2);
				TweenLite.to(link_2, 1, {x:226.7, y:438.8, scaleX:0.7, scaleY:0.7});
		}
		
		public function efecto3over(e:MouseEvent):void{
			this.addChild(link_3);
				TweenLite.to(link_3, 1, {x:473.3, y:438.8, scaleX:1.3, scaleY:1.3});
		}
		
		public function efecto3out(e:MouseEvent):void{
			this.addChild(link_3);
				TweenLite.to(link_3, 1, {x:473.3, y:438.8, scaleX:0.7, scaleY:0.7});
		}
		
		public function efecto4over(e:MouseEvent):void{
			this.addChild(link_4);
				TweenLite.to(link_4, 1, {x:392.6, y:438.8, scaleX:1.3, scaleY:1.3});
		}
		
		public function efecto4out(e:MouseEvent):void{
			this.addChild(link_4);
				TweenLite.to(link_4, 1, {x:392.6, y:438.8, scaleX:0.7, scaleY:0.7});
		}
		
		private function onPlayerReady(event:Event):void {
			this.plane = new Plane(mat, 160, 120, 2, 2); // 40mm x 40mm x 40mm。
			this.plane.z = 60;
			this.plane.rotationX= 180;
			this.plane.rotationZ= 270;			
			this._baseNode.addChild(this.plane);
			this.addEventListener( Event.ENTER_FRAME, loop3D );
		}
		
			
		private function loop3D(event:Event):void {
			
			if(detected==true){
				
				if(bandera==false){
					
					ns.play ( vid1 );
					movMat = new VideoStreamMaterial(vid, ns, true, true);
					this.plane = new Plane(movMat, 160, 120, 2, 2); // 40mm x 40mm x 40mm。
					this.plane.z = 60;
					this.plane.rotationX= 180;
					this.plane.rotationZ= 270;			
					this._baseNode.addChild(this.plane);
					
					this.plane.rotationZ= Matrix3D.matrix2euler(_baseNode.transform).z;
					bandera=true;
					
				}
				else{
					ns.resume();
				
				}
				
			}
			else{
			
				ns.pause();
			}
			
			
		}
		
		
		private function nsMetaDataCallback (mdata:Object):void {
            trace (mdata.duration);
        }

	}
}