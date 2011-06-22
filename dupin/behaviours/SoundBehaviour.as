package dupin.behaviours {
    import flash.display.*;
    import flash.events.*;
    import potato.modules.media.soundlib.sound;
    
    public class SoundBehaviour extends MouseBehaviour{

        public var over:String;
        public var click:String;

        public function SoundBehaviour(asset:DisplayObject, over:String='over', click:String='click'){
            super(asset, asset);

            this.over = over;
            this.click = click;
        }

        override public function onClick(e:MouseEvent):void{
            sound.clip(click).play();
        }
        override public function onOver(e:MouseEvent):void{
            sound.clip(over).play();
        }
        override public function onOut(e:MouseEvent):void{

        }
    }
}