//This imeplements a bluetooth version of the com socket

package  air.creatix.obd.sockets{
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.events.EventDispatcher;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import air.creatix.obd.sockets.ComSocketEvent;
	import air.creatix.obd.*;
	
	import com.distriqt.extension.bluetooth.Bluetooth;
	import com.distriqt.extension.bluetooth.BluetoothDevice;
	import com.distriqt.extension.bluetooth.events.BluetoothConnectionEvent;
	import com.distriqt.extension.bluetooth.events.BluetoothDeviceEvent;
	import com.distriqt.extension.bluetooth.events.BluetoothEvent;
	
	public class BluetoothComSocket extends ComSocket{
		public var buffer:String="";
		public var addr:String="";
		public var _device		: BluetoothDevice;
		public const uuid		: String = "00001101-0000-1000-8000-00805F9B34FB";
		
		public function BluetoothComSocket(p:String){
			//connect();
			addr=p;
			Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_CONNECTED, connected);
			Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_CONNECT_ERROR, cannot_connect);
			Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_CONNECT_FAILED, cannot_connect);
			Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_DISCONNECTED, disconnected);
			Bluetooth.service.addEventListener( BluetoothConnectionEvent.CONNECTION_RECEIVED_BYTES, bluetooth_received, false, 0, true );
		}
		
		override public function connect(){
			_device = new  BluetoothDevice();
			_device.address = addr;
			trace("bt socket connect:"+_device.address);
			
			Bluetooth.service.connect( _device, uuid );
		}
		
		public function connected(event:BluetoothConnectionEvent){
			dispatchEvent(new ComSocketEvent(ComSocketEvent.CONNECTED));
			
		}
		
		private function cannot_connect(event:BluetoothConnectionEvent){
			dispatchEvent(new ComSocketEvent(ComSocketEvent.DISCONNECTED,event));
		}
		
		private function disconnected(event:BluetoothConnectionEvent){
			dispatchEvent(new ComSocketEvent(ComSocketEvent.DISCONNECTED,event));
		}
		
		private function bluetooth_received(event:BluetoothConnectionEvent){
			var read:ByteArray = Bluetooth.service.readBytes( uuid );
			if (read == null)
			{
				trace( "Error on BT service" );
			}
			else
			{
				var data:Object=new Object();
				var str=read.toString();
				//str=str.substring(0,str.length-1);
				data.string=str
				//trace("recibido:"+str);
				//data.bytes=air.creatix.obd.Util.toArray(str);
				dispatchEvent(new ComSocketEvent(ComSocketEvent.DATA_RECEIVED,data));
			}
		}
		
		
		override public function write(p:String){
			//trace("btwrite:"+p);
			buffer+=p;
		}
		
		override public function flush(){
			//trace("btflushed:"+buffer);
			var data:ByteArray = new ByteArray();
			data.writeUTF( buffer);
			Bluetooth.service.writeBytes(uuid, data);
			buffer="";

		}

	}
	
}
