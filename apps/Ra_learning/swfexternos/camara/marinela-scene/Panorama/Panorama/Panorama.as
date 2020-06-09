/*
 *  PAPER    ON   ERVIS  NPAPER ISION  PE  IS ON  PERVI IO  APER  SI  PA
 *  AP  VI  ONPA  RV  IO PA     SI  PA ER  SI NP PE     ON AP  VI ION AP
 *  PERVI  ON  PE VISIO  APER   IONPA  RV  IO PA  RVIS  NP PE  IS ONPAPE
 *  ER     NPAPER IS     PE     ON  PE  ISIO  AP     IO PA ER  SI NP PER
 *  RV     PA  RV SI     ERVISI NP  ER   IO   PE VISIO  AP  VISI  PA  RV3D
 *  ______________________________________________________________________
 *  papervision3d.org + blog.papervision3d.org + osflash.org/papervision3d
 */



package 
{
import flash.display.*;
import flash.utils.Timer;
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


public class Panorama extends Sprite
{


	private var container 	:Sprite;
	private var scene     	:Scene3D;
	private var camera    	:FreeCamera3D;
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
	

	public function Panorama()
	{
		stage.scaleMode = StageScaleMode.NO_SCALE;

		init3D();
		
		loadAssets();
		
		bitMaps = new Array();
		
		

		stage.quality = StageQuality.LOW;

		
		
	}


	private function init3D():void
	{
		
		container = new Sprite();
		addChild( container );
	
	
		scene = new Scene3D( container );
	

	
		camera = new FreeCamera3D();
		camera.zoom = 1;
		camera.focus = 800;
		camera.z = 10;
		
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
			stage.addEventListener( Event.ENTER_FRAME, loop );
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
		update3D();
	}


	private function update3D():void
	{
		
		// Pan
		var pan:Number = camera.rotationY - 210 * container.mouseX/(stage.stageWidth/2);
		pan = Math.max( -100, Math.min( pan, 100 ) ); // Max speed
		camera.rotationY -= pan / 12;

		// Tilt
		var tilt:Number = 90 * container.mouseY/(stage.stageHeight/2);
		camera.rotationX -= (camera.rotationX + tilt) / 12;

		// Render
		scene.renderCamera( this.camera );
	}
	
		
}
}
