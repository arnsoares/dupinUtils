package dupin.ui
{   
    
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.geom.Rectangle;
    import flash.text.TextFormat;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormatAlign;
    import flash.text.AntiAliasType;
    import flash.filters.BlurFilter;
    import flash.display.Shape;
    import flash.display.LineScaleMode;
    import flash.display.CapsStyle;
    import flash.display.JointStyle;
    import flash.events.KeyboardEvent;
    import flash.text.TextFieldType;
    import flash.filters.DropShadowFilter;
    import flash.text.GridFitType;
    import flash.display.BitmapData;
    import dupin.display.safeRemoveChild;
    import rinaldi.display.getVisualBounds;
    
    /**
	 * 
	 * 	Easy way to work with text in ActionScript 3.0.
	 * 
	 * 	@param					p_size					    Text size.
	 *  @param                  p_fontName                  Text font.
	 *  @param                  p_color                     Text color.
	 *  @param                  p_type                      Text type ("dynamic" or "input").
	 *  @param                  p_maxChars                  Text max chars.
	 *  @param                  p_letterSpacing             Text letter spacing.
	 *  @param                  p_lineSpacing               Text line spacing.
	 *  @param                  p_autoSize                  Text auto size.
	 *  @param                  p_bold                      Use bold text?
	 *  @param                  p_smooth                    Text smoothing.
	 *  @param                  p_shadow                    Text shadow.
	 *  @param                  p_antiAliasType             Text anti-alias type.
	 *  @param                  p_selectable                Is text selectable?
	 *  @param                  p_embedFonts                Embed fonts?
	 *  @param                  p_multiline                 Multiline?
	 * 
	 * 	@example
	 *	<pre>
	 *	import patota.text.CommonText;
	 * 
	 *	var label : CommonText;
	 * 
	 *	label = new CommonText();
	 *	label.size = 10;
	 *	label.bold = true;
	 *	label.fontName = "Arial";
	 *  label.color = 0x0;
	 *  label.text = "Lorem Ipsum";
	 * 
	 *	addChild(label);
	 *	</pre>	
	 * 
	 * 	@see patota.text
	 * 
	 * 	@author Valério Oliveira, Rafael Rinaldi and Lucas Dupin.
	 * 
	 * */
    
    public class CommonText extends Sprite {
	    
	    public var label : TextField;
	    public var format : TextFormat;
	    public var box : Shape;
	    
	    public var size : Number;
	    public var fontName : String;
	    public var color : uint;
	    public var align : String;
	    public var type : String;
	    public var maxChars : Number;
	    public var letterSpacing : Number;
	    public var lineSpacing : Number;
	    public var autoSize : String;
	    public var bold : Boolean;
	    public var smooth : *;
	    public var shadow : *;
	    public var antiAliasType : String;
	    public var selectable : Boolean;
	    public var embedFonts : Boolean;
	    public var multiline : Boolean;
	    
	    public var _visualBounds : Rectangle;
	    public var _htmlText : String;
	    
	    
	    public var _background : Class;
	    public var _backgroundShape : Sprite;
	    
	    public static var getFont : Function;
	    
	    public function CommonText( p_size : Number = 10, p_fontName : String = "Arial", p_color : uint = 0x0, p_align : String = "left", p_type : String = "dynamic", p_maxChars : Number = 0, p_letterSpacing : Number = 0, p_lineSpacing : Number = 0, p_autoSize : String = "left", p_bold : Boolean = false, p_smooth : * = 0, p_shadow : *  = 0, p_antiAliasType : String = "advanced", p_selectable : Boolean = false, p_embedFonts : Boolean = true, p_multiline : Boolean = true )
	    {
	        size = p_size;
	        fontName = p_fontName;
	        color = p_color;
	        align = p_align;
	        type = p_type;
	        maxChars = p_maxChars;
	        letterSpacing = p_letterSpacing;
	        lineSpacing = p_lineSpacing;
	        autoSize = p_autoSize;
	        bold = bold;
	        smooth = p_smooth;
	        shadow = p_shadow;
	        antiAliasType = p_antiAliasType;
	        selectable = p_selectable;
	        embedFonts = p_embedFonts;
	        multiline = p_multiline;
	        
		    label = new TextField();
	        addChild(label);
	    }
	    
	    public function update() : void
	    {
	        if(!label)
	            return;
	            
	        label.antiAliasType = antiAliasType;
	        label.selectable = selectable;
	        label.embedFonts = embedFonts;
	        label.multiline = multiline;
            
            var filters : Array;
            
	        /** TextFormat instance **/
	        format = new TextFormat();
	        format.size = size;
	        
	        /** If CommonText have "getFont()" method uses him to get the font name, otherwise apply the "fontName" directly in "TextFormat" instance **/
	        if(getFont == null)
	            format.font = fontName;
	        else
	            format.font = getFont(fontName).fontName;
	        
	        format.color = color;
	        format.align = align;
	        format.letterSpacing = letterSpacing;
	        format.leading = lineSpacing;
	        format.bold = bold;
	        
	        /** TextField instance **/
	        label.defaultTextFormat = format;
	        label.type = type;
	        label.antiAliasType = antiAliasType;
	        label.gridFitType = GridFitType.PIXEL;
	        
	        /** Label text effects **/
	        filters = [];
            
            /** Smooth **/ 
	        if(smooth is BlurFilter)
	            filters[0] = smooth;
	        else if(smooth is Number)
	            filters[0] = new BlurFilter(smooth, smooth);

	        /** Shadow **/
	        if(shadow is DropShadowFilter)
	            filters[1] = shadow;
            else if(shadow is Number)
	            filters[1] = new DropShadowFilter(1, 45, shadow, shadow, 0x0, 0);
	        
	        label.filters = filters;
	        
	        label.autoSize = autoSize;
	        label.selectable = selectable;
	        label.multiline = multiline;
	        label.maxChars = maxChars;
	        
	        /** Used to update "visualBounds" when user type something **/
	        if(type == TextFieldType.INPUT)
	            this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
            else if(type == TextFieldType.DYNAMIC)
                if(this.hasEventListener(KeyboardEvent.KEY_DOWN))
                    this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown)
	    }
	    
	    public function set background(value:Class):void
	    {
	       _background = value;
	    }
	    public function get background():Class
	    {
	       return _background;
	    }
	    
	    /** Visual bounds **/
	    public function get visualBounds() : Rectangle
	    {
            return _visualBounds;
	    }
	    
	    public function set visualBounds( value : Rectangle ) : void
	    {
            _visualBounds = value;
            
            if(!value) return;
            
            if(box == null) {
                box = new Shape();
                box.visible = false;
                addChild(box);
            }
            
            /** Redrawing the red bound box **/
            with(box.graphics) clear(), lineStyle(1, 0xCC0000, 1, true, LineScaleMode.NONE, CapsStyle.SQUARE, JointStyle.MITER, 1), drawRect(visualBounds.x, visualBounds.y, visualBounds.width, visualBounds.height);
	    }
	    
        /** Dimensions **/
        override public function get width() : Number
        {
            if(!label)
                return 0;
                
            return label.width;
        }
        
        override public function set width( value : Number ) : void
        {
            if(!label)
                return;
                
            label.width = value;
        }
        
        override public function get height() : Number
        {
            if(!label)
                return 0;
                
            return label.height;
        }
        
        override public function set height( value : Number ) : void
        {
            if(!label)
                return;
            
            label.height = value;
        }
	    
	    /** textWidth (read-only) **/
	    public function get textWidth() : Number
	    {
	        if(!label)
	            return 0;
	            
            return label.textWidth;
	    }
	    
	    public function get textHeight() : Number
	    {
	        if(!label)
	            return 0;
	            
            return label.height;
	    }
	    
	    public function set textHeight( value : Number ) : void
	    {
	        if(!label)
	            return;
	            
	        label.height = value;
	    }
	    
	    /** HTML text **/
	    public function get htmlText() : String
	    {
	        if(!label)
	            return "";
	            
            return _htmlText;
	    }
	    
	    public function set htmlText( value : String ) : void
	    {
	        _htmlText = value;
	        
	        if(!label)
	            return;
	        
	        update();
	        label.htmlText = value ? value : "";
	        
	        visualBounds = getVisualBounds(label);
	        
	        if(_background){
	            
	            //Remove the shape if it exists
	            if(!_backgroundShape) {
	                _backgroundShape = new Sprite();
                }
                
                with(_backgroundShape.graphics){
                    clear();
                    beginBitmapFill(new _background(1, 20), null, true, true);
                    drawRect(0,0,1,20);
                    endFill();
                }
                _backgroundShape.y = visualBounds.y;
                _backgroundShape.width = label.width; _backgroundShape.height = visualBounds.height + 2;
                _backgroundShape.cacheAsBitmap = label.cacheAsBitmap = false;
                _backgroundShape.cacheAsBitmap = label.cacheAsBitmap = true;
                _backgroundShape.mask = label;
                addChild(_backgroundShape);
	        }
	        
	        dispatchEvent(new Event(Event.CHANGE));
	    }
	    
	    /** Text **/
	    public function get text() : String
	    {
	        if(!label)
	            return "";
	            
            return htmlText;
	    }
	    
	    public function set text( value : String ) : void
	    {
	        htmlText = value
	    }
	    
	    public function onKeyDown( event : KeyboardEvent ) : void
	    {
            visualBounds = getVisualBounds(label);
            dispatchEvent(new Event(Event.CHANGE));
	    }
	    
	    public function dispose() : void
	    {
	        format = null;
	        visualBounds = null;
	        
	        if(label != null && contains(label)) {
	            removeChild(label);
	            label = null;
	        }
	        
	        if(box != null && contains(box)) {
	            removeChild(box);
	            box = null;
	        }
	        
	        if(this.hasEventListener(KeyboardEvent.KEY_DOWN))
	            this.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
	            
	        _background = null;
	        
    	    if (_backgroundShape){
    	        safeRemoveChild(_backgroundShape);
    	        _backgroundShape = null;
    	    }
	    }
	
    }

}