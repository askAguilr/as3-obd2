package air.creatix.obd.commands {
	import air.creatix.obd.Util;
	//cantidad de errores activos
	public class PidDetectionCommand extends ObdCommand {
		private var value = "";
		public const PID = "0100";
		public const name = "piddetection";
		public function PidDetectionCommand() {
			super(PID);
		}

		//calculate values
		//Returns a data object where value is the amount of PID's
		//and PIDs is an array of strings of every PID supported by the ECU.
		override public function performCalculations(): Object {
			var rbytes = air.creatix.obd.Util.toArray(response);
			var length = 0;
			var result = new Array();
			for (var i=2;i<response.length;i+=2) {
				length++;
				result.push(response.substr(i,2));
			}
			var data: Object = new Object();
			data.value = length;
			data.PIDs=result;
			return data;
		}
		//returns result as they are
		public function getResult() {
			return value;
		}

	}


}