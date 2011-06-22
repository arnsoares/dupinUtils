package dupin.display {
    import flash.display.*;
    import flash.events.*;
    
    public function fitAndMask(target:DisplayObject, mask:DisplayObject, cacheAsBitmap:Boolean=false):void{

        //Scaling the target
        if(target.width/target.height < mask.width/mask.height) {
            target.width = mask.width;
            target.scaleY = target.scaleX;
        } else {
            target.height = mask.height;
            target.scaleX = target.scaleY;
        }

        //Positioning
        if(mask.parent) {
            target.x = mask.x;
            target.y = mask.y;
            mask.parent.addChild(target);
        } else if(target.parent) {
            mask.x = target.x;
            mask.y = target.y;
            target.parent.addChild(mask);
        }
        
        //Centralize
        target.x -= (target.width - mask.width)/2;
        target.y -= (target.height - mask.height)/2;

        //Cache as bitmap?
        mask.cacheAsBitmap = target.cacheAsBitmap = cacheAsBitmap;

        //Masking
        target.mask = mask;

    }
}

