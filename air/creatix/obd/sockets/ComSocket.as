//This is a base class for com sockets implements dummy communication and events

package  air.creatix.obd.sockets{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import air.creatix.obd.sockets.ComSocketEvent;
	
	public class ComSocket extends EventDispatcher{
		var myTimer:Timer;
		public function ComSocket() {
			// constructor code
		}
		
		public function connect(){

		}
		
		public function write(p:String){

		}
		
		public function flush(){
		}
		
		public function read(){
			
		}

	}
	
}
