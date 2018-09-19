//This is a base class for com sockets implements dummy communication and events

package  air.creatix.obd.sockets{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import air.creatix.obd.sockets.ComSocketEvent;
	import flash.utils.ByteArray;
	
	public class ComSocket extends EventDispatcher{
		public var buffer:String="";
		var myTimer:Timer;
		public function ComSocket() {
			// constructor code
		}
		
		public function connect(){
			trace("connecting");
			var myTimerc = new Timer(1000,1);
			myTimerc.addEventListener(TimerEvent.TIMER, function(){dispatchEvent(new ComSocketEvent(ComSocketEvent.CONNECTED));});
			myTimerc.start();
		}
		
		public function write(p:String){
			trace("write:"+p);
			buffer+=p;
		}
		
		public function flush(){
			trace("flushed:"+buffer);
			buffer="";
			myTimer = new Timer(2000,1);
			myTimer.addEventListener(TimerEvent.TIMER, timerListener);
			myTimer.start();
		}
		
		function timerListener (e):void{
			trace("Timer is Triggered");
			var data:Object=new Object();
			data.string="dummy";
			data.bytes=new ByteArray();
			dispatchEvent(new ComSocketEvent(ComSocketEvent.DATA_RECEIVED,data));
		}
		
		public function read(){
			
		}

	}
	
}
