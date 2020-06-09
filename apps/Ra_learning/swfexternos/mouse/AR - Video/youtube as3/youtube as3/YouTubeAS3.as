package {
	import flash.system.Security;
	import flash.display.MovieClip;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import fl.data.DataProvider;
	import fl.controls.ComboBox;
	import fl.controls.TextArea;
 
	public class YouTubeAS3 extends MovieClip {
		//public var VidHolder:MovieClip;
		//public var VidSelection:ComboBox;
		//public var traceArea:TextArea;
		
		private var player:Object;
		private var loader:Loader;
		private var vidCollection:DataProvider;

		public function YouTubeAS3():void {
			Security.allowInsecureDomain("*");
			Security.allowDomain("*");

			vidCollection = new DataProvider();
			vidCollection.addItem({data:"KhAplw0Z8zQ", label:"Wreckage"});
			vidCollection.addItem({data:"d54AA2YWll0", label:"Window View"});
			vidCollection.addItem({data:"Sv83GeuyN8A", label:"The Fearless Man"});
			vidCollection.addItem({data:"9t5guYGbuZs", label:"Ephemeral"});
			
			VidSelection.dataProvider = vidCollection;
			VidSelection.addEventListener(Event.CHANGE, cueVideo);
 
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/v/KgqUS8uuUA0?version=3"));
		}
 
		private function onLoaderInit(event:Event):void {
			VidHolder.addChild(loader);
			loader.content.addEventListener("onReady", onPlayerReady);
			loader.content.addEventListener("onError", onPlayerError);
			loader.content.addEventListener("onStateChange", onPlayerStateChange);
			loader.content.addEventListener("onPlaybackQualityChange", onVideoPlaybackQualityChange);
		}
 
		private function onPlayerReady(event:Event):void {
			trace("ready"+loader.content)
			traceArea.text += "player ready:" + Object(event).data + "\r";
			player = loader.content;
			player.setSize(VidHolder.width, VidHolder.height);
			VidSelection.selectedIndex = 0;
			//VidSelection.dispatchEvent(new Event(Event.CHANGE));
		}
		private function cueVideo(event:Event):void {
			traceArea.text += "switch to:" + event.target.selectedItem.label + "\r";
			player.cueVideoById(event.target.selectedItem.data);
		}

		private function onPlayerError(event:Event):void {
			traceArea.text += "player error:" + Object(event).data + "\r";
		}

		private function onPlayerStateChange(event:Event):void {
			traceArea.text += "player state:" + Object(event).data + "\r";
		}

		private function onVideoPlaybackQualityChange(event:Event):void {
			traceArea.text += "video quality:" + Object(event).data + "\r";
		}
	}
}
