# as3-obd2
OBDII Actionscript library based on the ELM327 for CAR/ECU diagnostics and live data retrieval

# Usage
This library is independent on the communication protocol, you need to implement your own socket (USB serial for example) the included BluetoothComSocket is made to work with [a link](https://distriqt.github.io/ANE-Bluetooth) ANE extension for Android.

You can use obd.run() to run a command once, or obd.subscribe() in order to keep running a command constantly. Probably you want to subscribe to commands such as RPM and Speed, and run throttle position or diagnostics only once.

Many OBD commands are already implemented and dispatch easy to read data, however you can implement your own command or use the GenericCommand in order to get the raw bytes from the response.

```	
  //You can implement your own socket
	com = new BluetoothComSocket("00:11:22:33:44:55");
	obd = new ObdDevice(com);
	obd.addEventListener(ObdEvent.RPM, function (e: ObdEvent) {
		trace("RPM:" + e.data.value);
	});
  obd.run(new RPMCommand());
  
  ```
