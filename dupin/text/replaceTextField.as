package dupin.text
{ 
  import flash.text.TextField;
  public function replaceTextField(removeThis:TextField):TextField{
    var f:TextField = new TextField();
    f.defaultTextFormat = removeThis.defaultTextFormat;
    f.width = removeThis.width;
    f.x = removeThis.x;
    f.y = removeThis.y;
    
    removeThis.parent.addChild(f);
    removeThis.parent.removeChild(removeThis);
    
    return f;
  }
}
