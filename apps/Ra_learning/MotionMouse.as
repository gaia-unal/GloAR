package{
	

import com.soulwire.media.MotionTracker;
import org.papervision3d.core.utils.virtualmouse.*;

import flash.display.MovieClip;
import flash.display.Stage;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.media.Video;
import flash.display.Loader;
import flash.net.URLRequest;
import com.greensock.TweenLite;

	
	public class MotionMouse {
		
		
		public var _motionTracker:MotionTracker;
		private var pointer:MovieClip;
		public var mouse:VirtualMouse;
		
		var oldx:int;
		var oldy:int;
		var newx:int;
		var newy:int;


		
		public function MotionMouse(video:Video, container:MovieClip, conStage:Stage): void {
			
			_motionTracker = new MotionTracker( video );
			
			// We flip the input as we want a mirror image
			_motionTracker.flipInput = true;
			
			

			
			pointer= new MovieClip();
			
			//pointer.alpha= 0;
			container.addChild(pointer);
			mouse = new VirtualMouse(conStage, container, 0, 0);
			mouse.ignore(pointer);
			
			_motionTracker.blur = 40;
			_motionTracker.brightness = 80;
			_motionTracker.contrast  = 180;
			_motionTracker.minArea = 20;
			// Get going!
			
			conStage.addEventListener(MouseEvent.MOUSE_MOVE, move);
			container.addEventListener( Event.ENTER_FRAME, track );
			
			

		}
		
		private function track( e:Event ):void {
			
			_motionTracker.track();
			
			// If there is enough movement (see the MotionTracker's minArea property) then continue
			if ( !_motionTracker.hasMovement ) 
				return;
			
			mouse.lock();
			mouse.x = 50+_motionTracker.motionArea.x;
			mouse.y = 50+_motionTracker.motionArea.y;
			mouse.unlock();
			
		}
		
		public function move(event:MouseEvent):void {
			if (event is IVirtualMouseEvent){
				
				//trace("x"+mouse.x);
				//trace("y"+mouse.y);
				
				
			}
		}
		
	}	
}