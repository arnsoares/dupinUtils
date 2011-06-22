package dupin.text
{	
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.TextField;
	import flash.text.AntiAliasType;
	
	/**
	 * Set the defaultTextFormat to the given TextFields
	 * If the text was already set it's will dissapear, this happens because the font
	 * will be embedded, so please run this function BEFORE setting the text
	 * 
	 * One strage behaviour observed is that if you set the htmlText of the field, you'll 
	 * need to specify all font faces, including the embedded one, but only if you have any other <font> tag
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 9.0.0
	 * 
	 * @author Lucas Dupin
	 * @since  01.04.2010
	 */
	public function embedFonts(klass:Class, ...fields):void
	{
		Font.registerFont(klass);
		
		var f:Font = new klass();
		
		for each (var field:TextField in fields)
		{
			var ftm:TextFormat = new TextFormat();
			ftm.font = f.fontName;

			field.embedFonts = true;
			field.selectable = false;
			field.antiAliasType = AntiAliasType.ADVANCED;
			field.defaultTextFormat  = ftm;
			
		}

	}
}
