package org.papervision3d.core.geom
{
	/**
	 * @Author Ralph Hauwert
	 */
	 
	import org.papervision3d.core.geom.renderables.Line3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.proto.CameraObject3D;
	import org.papervision3d.core.render.draw.ILineDrawer;
	import org.papervision3d.materials.LineMaterial;
	import org.papervision3d.objects.DisplayObject3D;
	
	public class Lines3D extends Vertices3D
	{
		
		public var lines:Array;
		private var _material:ILineDrawer;
		
		public function Lines3D(material:LineMaterial, name:String=null)
		{
			super(null, name);
			this.material = material;
			init();
		}
		
		private function init():void
		{
			this.lines = new Array();
		}
		
		public override function project( parent :DisplayObject3D, camera :CameraObject3D, sorted :Array=null ):Number
		{
			// Vertices
			super.project( parent, camera, sorted );
			if( ! sorted ) sorted = this._sorted;
			
			var line3D:Line3D;
			var screenZ:Number;
			
			for each(line3D in lines)
			{
				if(line3D.v0.vertex3DInstance.visible && line3D.v1.vertex3DInstance.visible){
					line3D.renderCommand.renderer = line3D.material;
					screenZ+=line3D.renderCommand.screenDepth = (line3D.v0.vertex3DInstance.z + line3D.v1.vertex3DInstance.z)/2;
					scene.renderer.addToRenderList(line3D.renderCommand);
				}
			}
			
			return screenZ/(lines.length+1);
		}
		
		public function addLine(line:Line3D):void
		{
			lines.push(line);
			line.instance = this;
			if(geometry.vertices.indexOf(line.v0) == -1){
				geometry.vertices.push(line.v0);
			}
			
			if(geometry.vertices.indexOf(line.v1) == -1){
				geometry.vertices.push(line.v1);
			}
		}
		
		public function addNewLine(size:Number, x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number):void
		{
			var line:Line3D = new Line3D(this, material as LineMaterial, size, new Vertex3D(x0,y0,z0), new Vertex3D(x1,y1,z1));
			addLine(line);
		}
		
		public function addNewSegmentedLine(size:Number, segments:Number, x0:Number, y0:Number, z0:Number, x1:Number, y1:Number, z1:Number):void
		{
			//Do line interpolation, and add a bunch of segments for it.
			var xStep:Number = (x1-x0)/segments;
			var yStep:Number = (y1-y0)/segments;
			var zStep:Number = (z1-z0)/segments;
			
			var line:Line3D;
			var pv:Vertex3D = new Vertex3D(x0,y0,z0);
			var nv:Vertex3D;
			for(var n:Number = 0; n<=segments; n++){
				nv = new Vertex3D(x0 + xStep*n, y0+yStep*n, z0+zStep*n);
				line = new Line3D(this, material as LineMaterial, size, pv, nv);
				addLine(line);
				pv = nv;
			}
		}
		
		public function removeLine(line:Line3D):void
		{
			lines.splice(lines.indexOf(line),1);	
		}
		
	}
}