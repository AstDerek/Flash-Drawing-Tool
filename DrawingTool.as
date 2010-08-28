class DrawingTool
{
	public var surface:MovieClip;
	
	public function DrawingTool (_surface:MovieClip)
	{
		surface = _surface;
		
		surface.xpath = new Array();
		surface.ypath = new Array();
		surface.xmin = null;
		surface.ymin = null;
		surface.xmax = null;
		surface.ymax = null;
		
		surface.onMouseDown = function ()
		{
			if (typeof(_root.mainComposition) != "object")
				return;
			
			if (_root.canDraw == false)
				return;
			
			this.xpath.push(this._xmouse);
			this.ypath.push(this._ymouse);
			
			if ((this._xmouse < this.xmin) || (this.xmin == null))
				this.xmin = this._xmouse;
			
			if ((this._ymouse < this.ymin)  || (this.ymin == null))
				this.ymin = this._ymouse;
			
			if ((this._xmouse > this.xmax) || (this.xmax == null))
				this.xmax = this._xmouse;
			
			if ((this._ymouse > this.ymax)  || (this.ymax == null))
				this.ymax = this._ymouse;
			
			this.lineStyle(2,0x000000,100);
			this.moveTo(this._xmouse,this._ymouse);
			
			this.onMouseMove = function ()
			{
				if (typeof(_root.mainComposition) != "object")
					return;
				
				if (_root.canDraw == false)
					return;
				
				this.xpath.push(this._xmouse);
				this.ypath.push(this._ymouse);
				
				if ((this._xmouse < this.xmin) || (this.xmin == null))
					this.xmin = this._xmouse;
				
				if ((this._ymouse < this.ymin) || (this.ymin == null))
					this.ymin = this._ymouse;
				
				if ((this._xmouse > this.xmax) || (this.xmax == null))
					this.xmax = this._xmouse;
				
				if ((this._ymouse > this.ymax) || (this.ymax == null))
					this.ymax = this._ymouse;
				
				this.lineTo(this._xmouse,this._ymouse);
			};
			
			this.onMouseUp = function ()
			{
				if (typeof(_root.mainComposition) != "object")
					return;
				
				if (_root.canDraw == false)
					return;
				
				this.xpath.push('|');
				this.ypath.push('|');
				
				this.onMouseMove = function(){};
			};
		};
	}
	
	public function reset ()
	{
		surface.xpath = new Array();
		surface.ypath = new Array();
		surface.xmax = null;
		surface.ymax = null;
		surface.xmin = null;
		surface.ymin = null;
		surface.clear();
	}
	
	public function export ()
	{
		var source:String = "";
		
		if (surface.xpath.length)
		{
			for (var n=0;n<surface.xpath.length;n++)
			{
				if (surface.xpath[n] == '|')
					source = source.substr(0,-1)+";";
				else
					source += (surface.xpath[n]-surface.xmin)+'.'+(surface.ypath[n]-surface.ymin)+',';
			}
		}
		else
			source = " ";
		
		return {item:"trace",source:source.substr(0,-1),posX:0*surface.xmin+0*(surface.xmax-surface.xmin)/2,posY:0*surface.ymin+0*(surface.ymax-surface.ymin)/2,scaleX:100,scaleY:100,rotation:0};
	}
}