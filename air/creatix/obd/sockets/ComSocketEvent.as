package air.creatix.obd.sockets{
 import flash.events.*;
  
 public class ComSocketEvent extends Event {
	  public var params:Object;
	  public static const CONNECTED:String = "connected";
	  public static const DATA_RECEIVED:String = "datareceived";
	  public static const DISCONNECTED:String = "disconnected";
	 
		 public function ComSocketEvent($type:String, $params:Object=null, $bubbles:Boolean = false, $cancelable:Boolean = false)
		{
			super($type, $bubbles, $cancelable);
			this.params = $params;
		}

	  public override function clone():Event {
	    return new ComSocketEvent(type, this.params, bubbles, cancelable);
	  }
 }
}
